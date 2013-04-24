# The file .pgpass in a user's home directory or the file referenced by
# PGPASSFILE can contain passwords to be used if the connection requires a
# password (and no password has been specified otherwise).
# On Microsoft Windows the file is named %APPDATA%\postgresql\pgpass.conf
# (where %APPDATA% refers to the Application Data subdirectory in the user's
# profile).
#
# This file should contain lines of the following format:
#
# hostname:port:database:username:password
#
# (You can add a reminder comment to the file by copying the line above and
# preceding it with `#`.) Each of the first four fields can be a literal value,
# or `*`, which matches anything.
#
# The password field from the first line that matches the current connection
# parameters will be used.
#
# (Therefore, put more-specific entries first when you are using wildcards.) If
# an entry needs to contain : or \, escape this character with \.
#
# A host name of localhost matches both TCP (host name localhost) and Unix
# domain socket (pghost empty or the default socket directory) connections
# coming from the local machine.
#
# In a standby server, a database name of replication matches streaming
# replication connections made to the master server.
#
# The database field is of limited usefulness because users have the same
# password for all databases in the same cluster.
#
# On Unix systems, the permissions on .pgpass must disallow any access to world
# or group; achieve this by the command chmod 0600 ~/.pgpass. If the
# permissions are less strict than this, the file will be ignored.
#
# On Microsoft Windows, it is assumed that the file is stored in a directory
# that is secure, so no special permissions check is made.

require 'strscan'
require 'uri'
require 'etc'

module Pgpass
  class Entry < Struct.new(:hostname, :port, :database, :username, :password)
    def self.create(hash)
      new(*hash.values_at(*members))
    end

    def blank?
      any = hostname || port || database || username || password
      any ? false : true
    end

    def to_url
      uri = URI("postgres:///")
      uri.user = username || ENV['PGUSER'] || Etc.getlogin
      uri.password = password || ENV['PGPASSWORD']
      uri.host = hostname || ENV['PGHOST'] || 'localhost'
      uri.port = (port || ENV['PGPORT'] || 5432).to_i
      uri.path = "/#{database || ENV['PGDATABASE']}"
      uri.to_s
    end

    def to_hash
      Hash[self.class.members.map{|m| [m, self[m]] }]
    end

    def merge(other)
      self.class.create(to_hash.merge(other.to_hash))
    end

    def ==(other)
      compare(database, other.database) &&
        compare(username, other.username) &&
        compare(hostname, other.hostname) &&
        compare(port, other.port) &&
        compare(password, other.password)
    end

    def complement(other)
      self.class.create(
        database: complement_one(database, other.database),
        username: complement_one(username, other.username),
        hostname: complement_one(hostname, other.hostname),
        port:     complement_one(port,     other.port),
        password: complement_one(password, other.password),
      )
    end

    private

    def compare(a, b)
      b == nil || a == b || a == '*' || b == '*'
    end

    def complement_one(a, b)
      a = nil if a == '*'
      b = nil if b == '*'
      a ? a : b
    end
  end

  LOCATIONS = [ENV['PGPASSFILE'], './.pgpass', '~/.pgpass']

  module_function

  def match(given_options = {})
    search = Entry.create(
      user:     (ENV['PGUSER'] || '*'),
      password: ENV['PGPASSWORD'],
      host:     (ENV['PGHOST'] || '*'),
      port:     (ENV['PGPORT'] || '*'),
      database: (ENV['PGDATABASE'] || '*'),
    ).merge(given_options)

    LOCATIONS.compact.each do |path|
      path = File.expand_path(path)
      # consider only files
      next unless File.file?(path)
      # that aren't world/group accessible
      unless File.stat(path).mode & 077 == 0
        warn("Ignoring group or world readable file #{path}. Set permissions to 0600 to use.")
        next
      end

      load_file(path).each do |entry|
        return entry.complement(search) if entry == search
      end
    end

    nil
  end

  def guess(paths = PATH)
    PATH.each do |path|
      begin
        load_file(File.join(path, ".pgpass"))
      rescue Errno::ENOENT => ex
        warn(ex)
      end
    end
  end

  def load_file(path)
    File.open(File.expand_path(path), 'r'){|io| load(io) }
  end

  def load(io)
    io.each_line.map{|line| parse_line(line) }
  end

  def parse_line(line)
    sc = StringScanner.new(line)
    entry = Entry.new
    key_index = 0
    value = ''

    loop do
      pos = sc.pos

      if sc.bol?
        if sc.scan(/\s*#/)
          # commented line
          return
        elsif sc.scan(/\s*$/)
          # empty line
          return
        end
      end

      if sc.eos?
        entry[Entry.members[key_index]] = value
        return entry # end of string
      end

      if sc.scan(/\\:/)
        value << ':'
      elsif sc.scan(/\\\\/)
        value << '\\'
      elsif sc.scan(/:/)
        entry[Entry.members[key_index]] = value
        key_index += 1
        value = ''
      elsif sc.scan(/\r\n|\r|\n/)
        entry[Entry.members[key_index]] = value
        return entry
      elsif sc.scan(/./)
        value << sc[0]
      end

      if sc.pos == pos
        raise "position didn't advance, stuck in parsing"
      end
    end

    return entry
  end
end
