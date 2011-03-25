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
      $current_exploit = Exploit.find_or_create_by_name_and_options(module_instance.fullname,module_instance.datastore)
      self.start_attack
    end

    def self.module_completed(module_instance)
      # TODO: refactor this
      if module_instance.datastore["RHOST"]
        $prelude_event_fetcher.local_ip = FIDIUS::Common.get_my_ip(module_instance.datastore["RHOST"]) unless $prelude_event_fetcher.local_ip
      end
      if module_instance.datastore["RHOSTS"]
        $prelude_event_fetcher.local_ip = FIDIUS::Common.get_my_ip(module_instance.datastore["RHOSTS"]) unless $prelude_event_fetcher.local_ip
      end
      self.fetch_events(module_instance)

      $current_exploit.finished = true
      $current_exploit.save
    end

    def self.module_error(module_instance,exception)
      self.module_completed(module_instance)
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
      if !$current_exploit.finished
        events.each do |event|
          idmef_event = IdmefEvent.create(:payload=>event.payload,:detect_time=>event.detect_time,
                            :dest_ip=>event.dest_ip,:src_ip=>event.source_ip,
                            :dest_port=>event.dest_port,:src_port=>event.source_port,
                            :text=>event.text,:severity=>event.severity,
                            :analyzer_model=>event.analyzer_model,:ident=>event.id)
          if module_instance && module_instance.respond_to?("fullname")
            $current_exploit.idmef_events << idmef_event
          # meterpreter is not a module and does not respond to fullname 
          # we handle this seperatly
          elsif module_instance == "Meterpreter"
            $current_exploit.exploit_payload.idmef_events << idmef_event
          end
        end
      end
      #if module_instance && module_instance.respond_to?("fullname")
      #  $current_exploit.save if !exploit.finished
      #end
      return events
    end

    def self.log_packet(module_instance,data,socket)
      begin
        # set local ip, if there is no
        $prelude_event_fetcher.local_ip = FIDIUS::Common.get_my_ip(socket.peerhost) unless $prelude_event_fetcher.local_ip
        $logger.debug "logged module_instance: #{module_instance} with #{data.size} bytes payload"
        # TODO: what shall we do with meterpreter? 
        # it has not options and no fullname, logger assigns only the string "meterpreter"
        if module_instance.respond_to?("fullname")
          if !$current_exploit.finished
            $current_exploit.packets << Packet.create(:payload=>data,:src_addr=>socket.localhost,:src_port=>socket.localport,:dest_addr=>socket.peerhost,:dest_port=>socket.peerport)
            $current_exploit.save
          end
        # meterpreter is not a module and does not respond to fullname 
        # we handle this seperatly
        elsif module_instance == "Meterpreter"
          $logger.debug "module_instance is meterpreter"
          $logger.debug "putting package to exploit_payload"
          $current_exploit.exploit_payload.packets << Packet.create(:payload=>data,:src_addr=>socket.localhost,:src_port=>socket.localport,:dest_addr=>socket.peerhost,:dest_port=>socket.peerport)
          $current_exploit.save
        end
        $logger.debug "LOG: #{module_instance} #{data.size} Bytes on #{socket}"
      rescue ActiveRecord::StatementInvalid
        $logger.error "#{$!.message}"
      rescue 
        $logger.error "error: #{$!.inspect}:#{$!.backtrace}"
      end
    end
  end# module EvasionDB
end# module FIDIUS
