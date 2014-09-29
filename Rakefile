require 'rspec/core/rake_task'

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  ENV['COVERAGE'] = ''
  task.rspec_opts = ['--color', '--order', 'rand']
end

task :default => :spec
