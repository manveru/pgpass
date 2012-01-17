require 'bacon'
Bacon.summary_on_exit

require_relative '../lib/pgpass'

describe Pgpass do
  describe '::load' do
    it 'loads a normal line' do
      line = 'host:1234:database:user:password'

      entry = Pgpass.load(line).first
      entry.hostname.should == 'host'
      entry.port.should == '1234'
      entry.database.should == 'database'
      entry.username.should == 'user'
      entry.password.should == 'password'
    end

    it 'loads a line with *' do
      line = 'host:*:db:user:pw'
      entry = Pgpass.load(line).first
      entry.hostname.should == 'host'
      entry.port.should == '*'
      entry.database.should == 'db'
      entry.username.should == 'user'
      entry.password.should == 'pw'
    end

    it 'loads two lines with *' do
      lines = "h1:*:d1:u1:p1\nh2:*:d2:u2:p2"
      entries = Pgpass.load(lines)
      entries[0].hostname.should == 'h1'
      entries[0].port.should == '*'
      entries[0].database.should == 'd1'
      entries[0].username.should == 'u1'
      entries[0].password.should == 'p1'

      entries[1].hostname.should == 'h2'
      entries[1].port.should == '*'
      entries[1].database.should == 'd2'
      entries[1].username.should == 'u2'
      entries[1].password.should == 'p2'
    end

    it 'loads a line with \:' do
      str = '\:x\:\:y:bar\::\:d:u\::p'
      Pgpass.load(str).should == [
        Pgpass::Entry.create(
          hostname: ':x::y',
          port: 'bar:',
          database: ':d',
          username: 'u:',
          password: 'p',
        )
      ]
    end

    it 'loads a line with \\\\' do
      str = '\\\\x\\\\y:bar\\\\:\\\\d:u:p'
      puts str
      Pgpass.load(str).should == [
        Pgpass::Entry.create(
          hostname: '\\x\\y',
          port: 'bar\\',
          database: '\\d',
          username: 'u',
          password: 'p',
        )
      ]
    end
  end

  describe '::match' do
    def with_pgpass(relative_path)
      location = File.expand_path("../#{relative_path}", __FILE__)
      File.chmod(0600, location)
      Pgpass::LOCATIONS.unshift(location)
      yield
    ensure
      Pgpass::LOCATIONS.delete(location)
    end

    it 'matches an entry with the same database' do
      with_pgpass 'sample/simple' do
        entry = Pgpass.match(database: 'db')
        entry.database.should == 'db'
        entry.username.should == 'manveru'
      end
    end

    it 'matches earlier entries with higher priority' do
      with_pgpass 'sample/multiple' do
        entry = Pgpass.match(database: 'db1')
        entry.database.should == 'db1'
        entry.password.should == 'pass1'
      end
    end
  end
end
