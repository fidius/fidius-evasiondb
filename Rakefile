require 'bundler'
Bundler::GemHelper.install_tasks

TEST_FILE = File.join('test', 'test_test.rb')

namespace :evasiondb do
  desc 'Test functionality of the gem.'
  task :test do
    sh "ruby #{TEST_FILE}"
  end
end
