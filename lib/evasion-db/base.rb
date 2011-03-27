module FIDIUS
  module EvasionDB
    def self.config(yml_file)
      raise "#{yml_file} does not exist" unless File.exists? File.expand_path(yml_file)
      yml_config = YAML.load(File.read(yml_file))
      evasion_db = yml_config['evasion_db']
      unless evasion_db
        raise "no evasion_db part found in file"
      else
        FIDIUS::EvasionDB::Knowledge::Connection.establish_connection evasion_db
        FIDIUS::EvasionDB::Knowledge::Connection.connection

        FIDIUS::EvasionDB::Fetcher.all.each do |fetcher|
          fetcher.config(yml_config)
        end
      end
    end

    def self.use_recoder(recorder_name)
      @current_recorder = Recorder.by_name(recorder_name)
    end

    def self.use_fetcher(fetcher_name)
      @current_fetcher = Fetcher.by_name(fetcher_name)
    end

    def self.current_recorder
      raise "no recorder set. Use FIDIUS::EvasionDB.use_recorder" unless @@current_recorder
      @@current_recorder
    end

    def self.current_fetcher
      raise "no fetcher set. Use FIDIUS::EvasionDB.use_fetcher" unless @@current_fetcher
      @@current_fetcher
    end



    def self.set_local_ip(ip)
      $prelude_event_fetcher.local_ip = ip
    end

    def self.db_connect(config_file)
      $prelude_event_fetcher.connect_db(config_file)
    end

    def self.start_attack
      $prelude_event_fetcher.attack_started
    end

  end# module EvasionDB
end# module FIDIUS
