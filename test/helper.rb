require 'rubygems'
require 'sqlite3'
require 'simplecov'
TEST_DIR = File.dirname(File.expand_path(__FILE__))
LIB_DIR = File.expand_path(File.join File.dirname(__FILE__),"..","lib") #File.join File.dirname(__FILE__),"..","lib"

SimpleCov.add_group 'Core', "./lib/evasion-db"
SimpleCov.add_group 'Knowledge', "./lib/evasion-db/knowledge/*"
SimpleCov.add_group 'Fetchers', "./lib/evasion-db/idmef-fetchers/*"
SimpleCov.add_group 'Recorders', "./lib/evasion-db/recorders/*"

SimpleCov.add_filter "./lib/db/*"
SimpleCov.start

require 'test/unit'
#$LOAD_PATH.unshift LIB_DIR
require "#{LIB_DIR}/fidius-evasiondb"
require "#{LIB_DIR}/db/db-install"
require "#{TEST_DIR}/preludedb_helper.rb"

module FIDIUS
  module EvasionDB
    
    def self.prepare_tests
      $config_file = File.join(TEST_DIR, 'config', 'database.yml')
      $yml_config = YAML.load(File.read($config_file))
      self.prepare_test_db
      FIDIUS::EvasionDB.config($config_file)
      self.fill_db_with_values
    end

    def self.prepare_test_db
      File.delete($yml_config["evasion_db"]["database"])
      db_config_path = File.join(TEST_DIR, 'config')
      migrations_path = File.join(LIB_DIR, 'db', 'migrations')
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
