require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

#TEST_FILE = File.join('test', 'test_runner.rb')

#desc 'Test functionality of the gem.'
#task :test do
#  sh "ruby #{TEST_FILE}"
#end
