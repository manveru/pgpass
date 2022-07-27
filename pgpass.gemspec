# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'pgpass'
  s.version = '2022.07.27'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael 'manveru' Fellinger"]
  s.date = '2022-07-27'
  s.email = 'ruby@manveru.dev'
  s.files = ['.gems', '.rvmrc', '.travis.yml', 'AUTHORS', 'CHANGELOG', 'LICENSE', 'MANIFEST', 'README.md', 'Rakefile', 'lib/pgpass.rb', 'lib/pgpass/version.rb', 'pgpass.gemspec', 'spec/pgpass.rb', 'spec/sample/invalid_permission', 'spec/sample/multiple', 'spec/sample/simple', 'tasks/authors.rake', 'tasks/bacon.rake', 'tasks/changelog.rake', 'tasks/gem.rake', 'tasks/manifest.rake', 'tasks/release.rake', 'tasks/reversion.rake']
  s.homepage = 'http://github.com/manveru/pgpass'
  s.require_paths = ['lib']
  s.required_ruby_version = Gem::Requirement.new('>= 1.9.2')
  s.rubygems_version = '1.8.10'
  s.summary = 'Finding, parsing, and using entries in .pgpass files'

  if s.respond_to? :specification_version
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_development_dependency('bacon', ['>= 1.1.0'])
    else
      s.add_dependency('bacon', ['>= 1.1.0'])
    end
  else
    s.add_dependency('bacon', ['>= 1.1.0'])
  end
end
