TEST_DIR = File.dirname(File.expand_path(__FILE__))
LIB_DIR = File.join(TEST_DIR, '..', 'lib')

$LOAD_PATH.unshift LIB_DIR
require 'fidius-evasiondb'
require 'test/unit'
require 'db/db-install'
require "#{TEST_DIR}/factories"

module FIDIUS
  module EvasionDB
    def run_tests
      self.prepare_test_db

      $prelude_event_fetcher.connect_db(File.join(TEST_DIR, 'config', 'database.yml'))
      #self.fill_db_with_values

      #load and run all tests form subdir
      Dir.glob(File.join TEST_DIR, 'test_modules', '*.rb') do |rb|
        require rb
      end
    end

    def prepare_test_db

      db_config_path = File.join(TEST_DIR, 'config')
      migrations_path = File.join(LIB_DIR, 'db', 'migrations')

      puts "Database configuration path: #{db_config_path}"
      puts "Migrations path: #{migrations_path}"

      #delete and migrate new test db
      FIDIUS::EvasionDB.migrate(migrations_path, db_config_path)
    end

    def fill_db_with_values
      # fill db with example values (use previous tests?)
    end
  end
end

include FIDIUS::EvasionDB
FIDIUS::EvasionDB.run_tests
