# frozen_string_literal: true

# Once git has a fix for the glibc in handling .mailmap and another fix for
# allowing empty mail address to be mapped in .mailmap we won't have to handle
# them manually.

desc 'Update AUTHORS'
task :authors do
  authors = Hash.new(0)

  `git shortlog -nse`.scan(/(\d+)\s(.+)\s<(.*)>$/) do |count, name, email|
    case name
    when 'ahoward'
      name = 'Ara T. Howard'
      email = 'ara.t.howard@gmail.com'
    when 'Martin Hilbig blueonyx@dev-area.net'
      name = 'Martin Hilbig'
      email = 'blueonyx@dev-area.net'
    when 'Michael Fellinger m.fellinger@gmail.com'
      name = 'Michael Fellinger'
      email = 'm.fellinger@gmail.com'
    end

    authors[[name, email]] += count.to_i
  end

  File.open('AUTHORS', 'w+') do |io|
    io.puts "Following persons have contributed to #{GEMSPEC.name}."
    io.puts '(Sorted by number of submitted patches, then alphabetically)'
    io.puts ''
    authors.sort_by { |(n, _e), c| [-c, n.downcase] }.each do |(name, email), count|
      io.puts(format('%6d %s <%s>', count, name, email))
    end
  end
end
