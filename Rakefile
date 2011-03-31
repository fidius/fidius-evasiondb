unless __FILE__.include? ENV['GEM_HOME']
  require 'bundler'
  Bundler::GemHelper.install_tasks
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
