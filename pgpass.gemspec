# -*- encoding: utf-8 -*-
# stub: pgpass 2023.01.01 ruby lib

Gem::Specification.new do |s|
  s.name = "pgpass".freeze
  s.version = "2023.01.01"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael 'manveru' Fellinger".freeze]
  s.date = "2023-01-01"
  s.email = "mf@rubyists.com".freeze
  s.files = ["AUTHORS".freeze, "CHANGELOG".freeze, "LICENSE".freeze, "MANIFEST".freeze, "README.md".freeze, "Rakefile".freeze, "lib".freeze, "lib/pgpass".freeze, "lib/pgpass.rb".freeze, "lib/pgpass/version.rb".freeze, "pgpass.gemspec".freeze, "spec".freeze, "spec/pgpass.rb".freeze, "spec/sample".freeze, "spec/sample/invalid_permission".freeze, "spec/sample/multiple".freeze, "spec/sample/simple".freeze, "tasks".freeze, "tasks/authors.rake".freeze, "tasks/bacon.rake".freeze, "tasks/changelog.rake".freeze, "tasks/gem.rake".freeze, "tasks/manifest.rake".freeze, "tasks/release.rake".freeze, "tasks/reversion.rake".freeze]
  s.homepage = "http://github.com/manveru/pgpass".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2".freeze)
  s.rubygems_version = "3.3.20".freeze
  s.summary = "Finding, parsing, and using entries in .pgpass files".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bacon>.freeze, [">= 1.1.0"])
  else
    s.add_dependency(%q<bacon>.freeze, [">= 1.1.0"])
  end
end
