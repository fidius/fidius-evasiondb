require 'rake/testtask'
require 'active_record'
require 'logger'

module FIDIUS
  module EvasionDB

    def self.migrate migrations_path, db_config_path
      @CFG_D = db_config_path

      self.connection_data

      begin
        self.drop_database @connection_data['evasion_db']
      rescue
        puts "DB drop: Could not find database #{@connection_data['database']}"
      end

      self.create_database @connection_data['evasion_db']

      self.with_db do
        ActiveRecord::Migrator.migrate(migrations_path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      end
    end

    def connection_data
      @connection_data ||= YAML.load_file("#{@CFG_D}/database.yml")
    end

    def with_db &block
      begin
        ActiveRecord::Base.establish_connection(connection_data['evasion_db'])
        ActiveRecord::Base.logger = Logger.new(STDOUT)
        ActiveRecord::Base.logger.level = Logger::WARN
        yield connection_data
      rescue
        raise
      ensure
        ActiveRecord::Base.connection.disconnect!
      end
    end

    # copied and modified activerecord-3.0.4/lib/active_record/railties/database.rake
    def drop_database(config)
      case config['adapter']
      when /sqlite/
        FileUtils.rm (config['database'])
      when /mysql/
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection.drop_database config['database']
      when 'postgresql'
        ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
        ActiveRecord::Base.connection.drop_database config['database']
      end
    end

    # dito
    def create_database(config)
      case config['adapter']

      when /mysql/
        require 'mysql'
        @charset   = ENV['CHARSET']   || 'utf8'
        @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
        creation_options = {:charset => (config['charset'] || @charset), :collation => (config['collation'] || @collation)}
        error_class = config['adapter'] =~ /mysql2/ ? Mysql2::Error : Mysql::Error
        access_denied_error = 1045
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => nil))
          ActiveRecord::Base.connection.create_database(config['database'], creation_options)
          ActiveRecord::Base.establish_connection(config)
        rescue error_class => sqlerr
          if sqlerr.errno == access_denied_error
            print "#{sqlerr.error}. \nPlease provide the root password for your mysql installation\n>"
          root_password = $stdin.gets.strip
            grant_statement = "GRANT ALL PRIVILEGES ON #{config['database']}.* " \
            "TO '#{config['username']}'@'localhost' " \
            "IDENTIFIED BY '#{config['password']}' WITH GRANT OPTION;"
            ActiveRecord::Base.establish_connection(config.merge('database' => nil, 'username' => 'root', 'password' => root_password))
            ActiveRecord::Base.connection.create_database(config['database'], creation_options)
            ActiveRecord::Base.connection.execute grant_statement
            ActiveRecord::Base.establish_connection(config)
          else
            $stderr.puts sqlerr.error
            $stderr.puts "Couldn't create database for #{config.inspect}, charset: #{config['charset'] || @charset}, collation: #{config['collation'] || @collation}"
            $stderr.puts "(if you set the charset manually, make sure you have a matching collation)" if config['charset']
          end
        end
      when 'postgresql'
        @encoding = config['encoding'] || ENV['CHARSET'] || 'utf8'
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
          ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => @encoding))
          ActiveRecord::Base.establish_connection(config)
        rescue Exception => e
          $stderr.puts e, *(e.backtrace)
          $stderr.puts "Couldn't create database for #{config.inspect}"
        end
      end

    end
  end
end
