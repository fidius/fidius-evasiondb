require 'rubygems'
require 'simplecov'
SimpleCov.start

require 'test/unit'
TEST_DIR = File.dirname(File.expand_path(__FILE__))
LIB_DIR = File.join File.dirname(__FILE__),"..","lib"
$LOAD_PATH.unshift LIB_DIR
require 'lib/fidius-evasiondb'
require 'db/db-install'

module FIDIUS
  module EvasionDB
    
    def self.prepare_tests
      self.prepare_test_db
      FIDIUS::EvasionDB.config(File.join(TEST_DIR, 'config', 'database.yml'))
      self.fill_db_with_values

      #load and run all tests form subdir
      Dir.glob(File.join TEST_DIR, 'test_modules', '*.rb') do |rb|
        require rb
      end
    end

    def self.prepare_test_db
      db_config_path = File.join(TEST_DIR, 'config')
      migrations_path = File.join(LIB_DIR, 'db', 'migrations')
      puts "Database configuration path: #{db_config_path}"
      puts "Migrations path: #{migrations_path}"

      #delete and migrate new test db
      migrate(migrations_path, db_config_path)
    end

    def self.fill_db_with_values
      # fill db with example values (use previous tests?)
    end
  end
end
include FIDIUS::EvasionDB
FIDIUS::EvasionDB.prepare_tests

