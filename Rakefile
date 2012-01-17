require 'rake/clean'
require 'rubygems/package_task'
require 'time'
require 'date'

PROJECT_SPECS = FileList['spec/**/*.rb']
PROJECT_MODULE = 'Pgpass'
PROJECT_README = 'README.md'
PROJECT_VERSION = (ENV['VERSION'] || Date.today.strftime('%Y.%m.%d')).dup

DEPENDENCIES = {}

DEVELOPMENT_DEPENDENCIES = {
  'bacon'     => {:version => '>= 1.1.0'},
}

GEMSPEC = Gem::Specification.new{|s|
  s.name         = 'pgpass'
  s.author       = "Michael 'manveru' Fellinger"
  s.summary      = "Finding, parsing, and using entries in .pgpass files"
  s.email        = 'mf@rubyists.com'
  s.homepage     = 'http://github.com/manveru/pgpass'
  s.platform     = Gem::Platform::RUBY
  s.version      = PROJECT_VERSION
  s.files        = `git ls-files`.split("\n").sort
  s.has_rdoc     = true
  s.require_path = 'lib'
  s.required_ruby_version = '>= 1.9.2'
}

DEPENDENCIES.each do |name, options|
  GEMSPEC.add_dependency(name, options[:version])
end

DEVELOPMENT_DEPENDENCIES.each do |name, options|
  GEMSPEC.add_development_dependency(name, options[:version])
end

Dir['tasks/*.rake'].each{|f| import(f) }

task :default => [:bacon]

CLEAN.include('')
