# frozen_string_literal: true

desc 'Run all bacon specs with pretty output'
task :bacon do
  require 'open3'
  require 'matrix'
  require 'fileutils'

  specs = PROJECT_SPECS

  some_failed = false
  specs_size = specs.size
  len = specs.map(&:size).max
  totals = Vector[0, 0, 0, 0]

  red = "\e[31m%s\e[0m"
  yellow = "\e[33m%s\e[0m"
  green = "\e[32m%s\e[0m"
  left_format = "%4d/%d: %-#{len + 11}s"
  spec_format = /(?<specifications>\d+) specifications \((?<requirements>\d+) requirements\), (?<failures>\d+) failures, (?<errors>\d+) errors/

  specs.each_with_index do |spec, idx|
    print(format(left_format, idx + 1, specs_size, spec))

    Open3.popen3(FileUtils::RUBY, '-w', spec) do |_sin, sout, serr|
      out = sout.read.strip
      err = serr.read.strip

      # this is conventional, see spec/innate/state/fiber.rb for usage
      if out =~ /^Bacon::Error: (needed .*)/
        puts(yellow % format('%6s %s', '', Regexp.last_match(1)))
      else
        total = nil

        out.each_line do |line|
          next unless spec_format =~ line

          total = Vector[*$~[1..-1].map(&:to_i)]
          break
        end

        if total
          totals += total
          tests, assertions, failures, errors = total.to_a

          if tests.positive? && (failures + errors).zero?
            puts((green % '%6d passed') % tests)
          else
            some_failed = true
            puts(red % '       failed')
            puts out unless out.empty?
            puts err unless err.empty?
          end
        else
          some_failed = true
          puts(red % '       failed')
          puts out unless out.empty?
          puts err unless err.empty?
        end
      end
    end
  end

  total_color = some_failed ? red : green
  puts(total_color % ('%d specifications (%d requirements), %d failures, %d errors' % totals.to_a))
  exit 1 if some_failed
end
