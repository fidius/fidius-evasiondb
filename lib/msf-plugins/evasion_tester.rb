# -*- coding: utf-8 -*-
module Msf

class Plugin::EvasionTester < Msf::Plugin

  class PreludeEventFetcher

    attr_accessor :local_ip

    def initialize
      @start_time = nil
      @connection_established = false
      @local_ip = nil
    end

    def connect_db(file)
      if (File.exists? File.expand_path(file))
 	      db = YAML.load(File.read(file))['evasion_db']
        if db != nil
          $stdout.puts "connecting to database"
          Connection.establish_connection db
          require 'plugins/prelude/postgres_patch.rb'
          @connection_established = true
        else
          raise "no evasion_db entry found in file"
        end
      else
        raise "#{file} does not exist"
      end
    end


    def attack_started
      raise "no connection to database" if !@connection_established
      a = Alert.find(:first,:joins => [:detect_time],:order=>"time DESC")
      last_event = PreludeEvent.new(a)
      @start_time = last_event.detect_time
    end

    def get_events
      raise "no local ip given" if @local_ip == nil
      raise "no connection to database" if !@connection_established
      raise "please start_attack before fetching" if @start_time == nil
      res = Array.new
      events = Alert.find(:all,:joins => [:detect_time],:order=>"time DESC",:conditions=>["time > :d",{:d => @start_time}])
      events.each do |event|
        ev = PreludeEvent.new(event)
        if @local_ip != nil
          if ev.source_ip == @local_ip || ev.dest_ip == @local_ip
            res << ev
          end
        else
          res << ev
        end
      end
      return res
    end
  end


class ConsoleCommandDispatcher
  include Msf::Ui::Console::CommandDispatcher
  def name
    "EvasionTester"
  end

  def explain_db_connection
    print_status("Usage: ")
    print_status("evasion_db_connect path/to/database.yml")
    print_status()
    print_status("database.yml must have evasion_db entry which points to prelude db")
    print_status()
    print_status("example:")
    print_status("evasion_db:")
    print_status("  adapter: mysql")
    print_status("  host: localhost")
    print_status("  port: 3306")
    print_status("  encoding: utf8")
    print_status("  database: msf")
    print_status("  username: root")
    print_status("  password:")
  end

  def commands
    {
      "start_attack" => "indicate that you want to collect all events from Time.now on",
      "fetch_events" => "fetch events which were created in the meanwhile",
      "evasion_db_connect" => "connect to an instance of prelude database",
      "load_php_meterpreter_evasion" => "load evasion for php meterpreter rpc-calls will be send base64 encoded",
      "set_local_ip" => "set your local ip to filter events",
    }
  end

  def cmd_set_local_ip(*args)
    raise "example: set_local_ip 10.0.0.100" if args.size != 1
    $prelude_event_fetcher.local_ip = args[0]
  end

  def cmd_evasion_db_connect(*args)
    if args.size == 0
      # error no path to database.yml
      print_error("no args given")
      explain_db_connection
    else
      file = args[0]
      begin
        $prelude_event_fetcher.connect_db(file)
      rescue
        print_error($!)
        explain_db_connection
      end
    end
  end

  def cmd_start_attack(*args)
    print_status("start attack")
    $prelude_event_fetcher.attack_started
  end

  def cmd_load_php_meterpreter_evasion
    require 'plugins/prelude/php_meterpreter_evasion.rb'
    print_status("changes for evasion loaded")
  end

  def cmd_fetch_events(*args)
    # TODO: IP ändern?
    events = $prelude_event_fetcher.get_events
    print_status "#{events.size} events generated"
    print_status
    events.each do |e|
      print_status "#{e}"
    end
  end
end

  PRELUDE_DB = "prelude"
  def initialize(framework, opts)
    super
    require 'plugins/prelude/prelude_event.rb'
    $prelude_event_fetcher = PreludeEventFetcher.new
    $prelude_event_fetcher.connect_db("data/database.yml")
    begin
      add_console_dispatcher(ConsoleCommandDispatcher)
    rescue
      puts "#{$!.inspect}"
    end
    print_status("EvasionTester plugin loaded.")
  end

  def cleanup
    remove_console_dispatcher(ConsoleCommandDispatcher)
  end

  def name
    "EvasionTester"
  end

  def desc
    "DESC"
  end
end

end


