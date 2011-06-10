# Author::    FIDIUS (mailto:grp-fidius@tzi.de) 
# License::   Distributes under the same terms as fidius-evasiondb Gem
module FIDIUS
  # EvasionDB is a knowledge database which provides information about idmef-events which are
  # thrown by an ids like prelude. You can use this gem in two ways.
  # One way is to generate knowledge via running exploits whithin metasploit. The other way is 
  # require this gem and query existing knowledge estimate how loud an exploit might be.
  #
  module EvasionDB
    # stores content of configuration yml
    @@yml_config = nil
    @@current_fetcher = nil
    @@current_recorder = nil
    @@current_rule_fetcher = nil

    # Configures EvasionDB. 
    #
    # @param [String] path to an yml-file containing db-connection settings for ids_db and evasion_db
    # sample config can be created with 'fidius-evasiondb -e'
    def self.config(yml_file)
      if yml_file.class == String
        raise "#{yml_file} does not exist" unless File.exists? File.expand_path(yml_file)
        @@yml_config = YAML.load(File.read(yml_file))
        evasion_db = @@yml_config['evasion_db']
      elsif yml_file.class == Hash
        # also react on connection settings given as hash
        evasion_db = yml_file
      else
        raise "please input string or hash"
      end
      unless evasion_db
        raise "no evasion_db part found in file"
      else
        #self.load_db_adapter(evasion_db['adapter'])
        FIDIUS::EvasionDB::Knowledge::Connection.establish_connection evasion_db
        #require File.join(GEM_BASE, 'evasion-db', 'postgres_patch.rb')
        FIDIUS::EvasionDB::Knowledge::Connection.connection
      end
    end

    # Use a given recorder. Recorders are used to log packets while an exploit is running.
    # Currently there is only the msf-recorder available. Use it by setting FIDIUS::EvasionDB.use_recorder "Msf-Recorder"
    #
    # @param [String] recordername
    # @raise RuntimeError if recorder not found
    def self.use_recoder(recorder_name)
      raise "not configured. use FIDIUS::EvasionDB.config first" unless @@yml_config
      @@current_recorder = Recorder.by_name(recorder_name)
      raise "recorder #{recorder_name} not found" unless @@current_recorder
    end

    # Use a given fetcher. Fetchers are used to fetch idmef-events after an exploit is finished.
    # Currently there is only the Prelude-Fetcher available. Use it by setting FIDIUS::EvasionDB.use_fetcher "PreludeDB"
    #
    # @param [String] fetcher_name
    # @raise RuntimeError if fetcher not found
    def self.use_fetcher(fetcher_name)
      raise "not configured. use FIDIUS::EvasionDB.config first" unless @@yml_config
      @@current_fetcher = Fetcher.by_name(fetcher_name)
      raise "fetcher #{fetcher_name} not found" unless @@current_fetcher    
      @@current_fetcher.config(@@yml_config)
    end

    # Use a given rule-fetcher. RuleFetchers are used to fetch rules from an rule based ids.
    # Currently there is only the Fetcher for a Snort IDS. 
    #
    # @param [String] rule_fetcher_name
    # @raise RuntimeError if fetcher not found
    def self.use_rule_fetcher(rule_fetcher_name)
      raise "not configured. use FIDIUS::EvasionDB.config first" unless @@yml_config
      @@current_rule_fetcher = RuleFetcher.by_name(rule_fetcher_name)
      raise "rule-fetcher #{rule_fetcher_name} not found" unless @@current_rule_fetcher    
      @@current_rule_fetcher.config(@@yml_config)
    end

    # Returns the current recorder
    #
    # @see #use_recorder
    # @raise RuntimeError if recorder was not set
    def self.current_recorder
      raise "no recorder set. Use FIDIUS::EvasionDB.use_recorder" unless @@current_recorder
      @@current_recorder
    end

    # Returns the current recorder
    #
    # @see #use_fetcher
    # @raise RuntimeError if fetcher was not set
    def self.current_fetcher
      raise "no fetcher set. Use FIDIUS::EvasionDB.use_fetcher" unless @@current_fetcher
      @@current_fetcher
    end


    # Returns the current rule fetcher
    #
    # @see #use_rule_fetcher
    def self.current_rule_fetcher
      @@current_rule_fetcher
    end
  end# module EvasionDB
end# module FIDIUS
