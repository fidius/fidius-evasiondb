module FIDIUS
  module EvasionDB
  class PreludeEventFetcher

    attr_accessor :local_ip

    def initialize
      @start_time = nil
      @connection_established = false
      @local_ip = nil
    end

    def connect_db(file)
      if (File.exists? File.expand_path(file))
 	      evasion_db = YAML.load(File.read(file))['evasion_db']
 	      ids_db = YAML.load(File.read(file))['ids_db']
        
        unless evasion_db || ids_db
          raise "no evasion_db or ids_db entry found in file"
        else
          $stdout.puts "connecting to database"
          Connection.establish_connection ids_db
          EvasionDbConnection.establish_connection evasion_db

          raise "could not connect to evasion_db" unless Connection.connected?
          raise "could not connect to ids_db" unless EvasionDbConnection.connected?

          require File.join(GEM_BASE, 'patches','postgres_patch.rb')
          @connection_established = true
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
      puts "alert.find(:all,:joins=>[:detect_time],time > #{@start_time})"
      events = Alert.find(:all,:joins => [:detect_time],:order=>"time DESC",:conditions=>["time > :d",{:d => @start_time}])
      puts "found #{events.size} events"
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
end
end
