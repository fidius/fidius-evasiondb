module FIDIUS
  module EvasionDB
      def self.get_exploits
        Exploit.all
      end

      def self.get_packet(id)
        Packet.find(id)
      end

      def self.get_events
        IdmefEvent.all
      end

      def self.get_event(event_id)
        IdmefEvent.find(event_id)
      end

      def self.get_packet(pid)
        Packet.find(pid)
      end

      def self.get_packet_for_event(event_id)
        event = IdmefEvent.find(event_id)
        FIDIUS::EvasionDB::LogMatchesHelper.find_packets_for_event(event,Packet.all)
      end

      def self.module_started(module_instance)
        self.start_attack
      end

      def self.module_completed(module_instance)
        self.fetch_events(module_instance)
      end

      def self.module_error(module_instance,exception)
        self.fetch_events(module_instance)
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

      def self.fetch_events(module_instance=nil)
        events = $prelude_event_fetcher.get_events
        # TODO: what shall we do with meterpreter? 
        # it has not options and no fullname, logger assigns only the string "meterpreter"
        if module_instance && module_instance.respond_to?("fullname")          
          exploit = Exploit.find_or_create_by_name_and_options(module_instance.fullname,module_instance.datastore)
        end
        events.each do |event|
          idmef_event = IdmefEvent.create(:payload=>event.payload,:detect_time=>event.detect_time,
                            :dest_ip=>event.dest_ip,:src_ip=>event.source_ip,
                            :dest_port=>event.dest_port,:src_port=>event.source_port,
                            :text=>event.text,:severity=>event.severity,
                            :analyzer_model=>event.analyzer_model,:ident=>event.id)
          if module_instance && module_instance.respond_to?("fullname")
            exploit.idmef_events << idmef_event
          end
        end
        if module_instance && module_instance.respond_to?("fullname")
          exploit.save
        end
        return events
      end

      def self.log_packet(module_instance,data,socket)
        begin
          # set local ip, if there is no
          $prelude_event_fetcher.local_ip = FIDIUS::Common.get_my_ip(socket.peerhost) unless $prelude_event_fetcher.local_ip

          # TODO: what shall we do with meterpreter? 
          # it has not options and no fullname, logger assigns only the string "meterpreter"
          if module_instance.respond_to?("fullname")
            exploit = Exploit.find_or_create_by_name_and_options(module_instance.fullname,module_instance.datastore)
            exploit.packets << Packet.create(:payload=>data,:src_addr=>socket.localhost,:src_port=>socket.localport,:dest_addr=>socket.peerhost,:dest_port=>socket.peerport)
            exploit.save
          end
          $stdout.puts "LOG: #{module_instance} #{data.size} Bytes on #{socket}"
        rescue
          $stdout.puts "error: #{$!.inspect}:#{$!.backtrace}"
       end
      end
  end# module EvasionDB
end# module FIDIUS
