# fix error: cant convert nil into String
# Rakefile:1 in include?
unless ENV['GEM_HOME'] && (__FILE__.include? ENV['GEM_HOME'])
  require 'bundler'
  Bundler::GemHelper.install_tasks
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'yard'

  YARD::Rake::YardocTask.new(:doc) do |t|
    t.files = ['lib/**/*.rb']
    exclude = 'lib/db'
    static_files = 'LICENSE,CREDITS.md'
    t.options += [
      '--title', 'FIDIUS EvasionDB',
      '--private',   # include private methods
      '--protected', # include protected methods
      '--exclude', exclude,
      '--files', static_files,
      '--readme', 'README.md'
    ]
  end
rescue LoadError
  puts 'YARD not installed (gem install yard), http://yardoc.org'
end
