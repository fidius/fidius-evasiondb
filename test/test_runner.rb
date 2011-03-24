TEST_DIR = File.dirname(File.expand_path(__FILE__))
LIB_DIR = File.join(TEST_DIR, '..', 'lib')

$LOAD_PATH.unshift LIB_DIR
require 'evasion-db'
require 'test/unit'
require 'db/db-install'

module FIDIUS
  module EvasionDB
    def prepare_test_db
      puts "TEST_DIR: #{TEST_DIR}"
      puts "LIB_DIR: #{LIB_DIR}"

      db_config_path = File.join(TEST_DIR, 'config')
      migrations_path = File.join(LIB_DIR, 'db', 'migrations')

      puts "db_config_path: #{db_config_path}"
      puts "migrations_path: #{migrations_path}"

      #delete and migrate new test db
      FIDIUS::EvasionDB.migrate(migrations_path, db_config_path)

    end
  end
end

include FIDIUS::EvasionDB
FIDIUS::EvasionDB.prepare_test_db
