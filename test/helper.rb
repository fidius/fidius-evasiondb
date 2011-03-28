require 'rubygems'
require 'sqlite3'
require 'simplecov'
TEST_DIR = File.dirname(File.expand_path(__FILE__))
LIB_DIR = File.join File.dirname(__FILE__),"..","lib"

#puts "bla: #{ File.join(LIB_DIR,"fidius-evasiondb")}"
#SimpleCov.root(File.join(LIB_DIR,"fidius-evasiondb"))
SimpleCov.add_group 'Core', "./lib/evasion-db"
SimpleCov.add_group 'Knowledge', "./lib/evasion-db/knowledge/*"
SimpleCov.add_group 'Fetchers', "./lib/evasion-db/idmef-fetchers/*"
SimpleCov.add_group 'Recorders', "./lib/evasion-db/recorders/*"
SimpleCov.add_filter "./lib/db/migrations/"
SimpleCov.start

#gemfile = File.expand_path('../../Gemfile', __FILE__)
#ENV['BUNDLE_GEMFILE'] = gemfile
#require 'bundler'
#Bundler.setup(:test)
#Bundler.require
#exit!

require 'test/unit'
$LOAD_PATH.unshift LIB_DIR
require 'lib/fidius-evasiondb'
require 'db/db-install'


module FIDIUS
  module EvasionDB
    
    def self.prepare_tests
      $config_file = File.join(TEST_DIR, 'config', 'database.yml')
      $yml_config = YAML.load(File.read($config_file))
      self.prepare_test_db
      FIDIUS::EvasionDB.config($config_file)
      self.fill_db_with_values

      #load and run all tests form subdir
      #Dir.glob(File.join TEST_DIR, 'test_modules', '*.rb') do |rb|
      #  require rb
      #end
    end

    def self.prepare_test_db
      db_config_path = File.join(TEST_DIR, 'config')
      migrations_path = File.join(LIB_DIR, 'db', 'migrations')
      puts "Database configuration path: #{db_config_path}"
      puts "Migrations path: #{migrations_path}"

      #delete and migrate new test db
      migrate(migrations_path, db_config_path)

      #config = YAML.load_file("#{db_config_path}/database.yml")
      self.setup_prelude_db
      #create_database(config["ids_db"])
    end

    def self.setup_prelude_db
      puts "BLA: #{$yml_config["ids_db"]["database"]}"
      FIDIUS::PreludeDB::Connection.establish_connection $yml_config["ids_db"]
      sql = File.read(File.join(TEST_DIR,"config","prelude.sql"))
      sql.split(';').each do |sql_statement|
        sql_statement = sql_statement.lstrip
        if sql_statement != ""
          FIDIUS::PreludeDB::Connection.connection.execute sql_statement
        end
      end
    end

    def self.fill_db_with_values
      # fill db with example values (use previous tests?)
    end
  end
end
include FIDIUS::EvasionDB
FIDIUS::EvasionDB.prepare_tests

