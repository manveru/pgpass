# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pgpass"
  s.version = "2012.01.18"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael 'manveru' Fellinger"]
  s.date = "2012-01-18"
  s.email = "mf@rubyists.com"
  s.files = [".gems", ".rvmrc", ".travis.yml", "AUTHORS", "CHANGELOG", "LICENSE", "MANIFEST", "README.md", "Rakefile", "lib/pgpass.rb", "lib/pgpass/version.rb", "pgpass.gemspec", "spec/pgpass.rb", "spec/sample/invalid_permission", "spec/sample/multiple", "spec/sample/simple", "tasks/authors.rake", "tasks/bacon.rake", "tasks/changelog.rake", "tasks/gem.rake", "tasks/manifest.rake", "tasks/release.rake", "tasks/reversion.rake"]
  s.homepage = "http://github.com/manveru/pgpass"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "1.8.10"
  s.summary = "Finding, parsing, and using entries in .pgpass files"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bacon>, [">= 1.1.0"])
    else
      s.add_dependency(%q<bacon>, [">= 1.1.0"])
    end
  else
    s.add_dependency(%q<bacon>, [">= 1.1.0"])
  end
end
