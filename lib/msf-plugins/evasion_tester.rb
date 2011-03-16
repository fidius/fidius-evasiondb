# -*- coding: utf-8 -*-
module Msf
class Plugin::EvasionTester < Msf::Plugin
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
        "set_local_ip" => "set your local ip to filter events",
      }
    end

    def cmd_set_local_ip(*args)
      raise "example: set_local_ip 10.0.0.100" if args.size != 1
      FIDIUS::EvasionDB::Commands.set_local_ip(args[0])
    end

    def cmd_evasion_db_connect(*args)
      if args.size == 0
        # error no path to database.yml
        print_error("no args given")
        explain_db_connection
      else
        file = args[0]
        begin
          FIDIUS::EvasionDB::Commands.db_connect(file)
        rescue
          print_error($!)
          explain_db_connection
        end
      end
    end

    def cmd_start_attack(*args)
      print_status("start attack")
      FIDIUS::EvasionDB::Commands.start_attack
    end

    def cmd_fetch_events(*args)
      events = FIDIUS::EvasionDB::Commands.fetch_events
      print_status "#{events.size} events generated"
      print_status
      events.each do |e|
        print_status "#{e}"
      end
    end
  end

  def initialize(framework, opts)
    super
    # TODO require gem
    require 'evasion-db'
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
