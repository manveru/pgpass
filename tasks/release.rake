# frozen_string_literal: true

namespace :release do
  task prepare: %i[reversion authors gemspec]
  task all: ['release:github', 'release:gemcutter']

  desc 'Release on github'
  task github: :prepare do
    name = GEMSPEC.name
    version = GEMSPEC.version

    sh('git', 'add',
       'MANIFEST', 'CHANGELOG', 'AUTHORS',
       "#{name}.gemspec",
       "lib/#{name}/version.rb")

    puts <<~INSTRUCTIONS
      ================================================================================
      
      I added the relevant files, you can commit them, tag the commit, and push:
      
      git commit -m 'Version #{version}'
      git tag -a -m '#{version}' '#{version}'
      git push
      
      ================================================================================
    INSTRUCTIONS
  end

  desc 'Release on gemcutter'
  task gemcutter: ['release:prepare', :package] do
    name = GEMSPEC.name
    version = GEMSPEC.version

    puts <<~INSTRUCTIONS
      ================================================================================
      
      To publish to gemcutter do following:
      
      gem push pkg/#{name}-#{version}.gem
      
      ================================================================================
    INSTRUCTIONS
  end
end
