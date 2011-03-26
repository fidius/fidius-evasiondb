module FIDIUS
  module EvasionDB
    module MsfRecorder
      def module_started(module_instance)
        @@current_exploit = Exploit.find_or_create_by_name_and_options(module_instance.fullname,module_instance.datastore)
        FIDIUS::EvasionDB.current_fetcher.begin_record
      end

      def module_completed(module_instance)
        # TODO: refactor this
        if module_instance.datastore["RHOST"]
          FIDIUS::EvasionDB.current_fetcher.local_ip = FIDIUS::Common.get_my_ip(module_instance.datastore["RHOST"]) unless $prelude_event_fetcher.local_ip
        end
        if module_instance.datastore["RHOSTS"]
          FIDIUS::EvasionDB.current_fetcher.local_ip = FIDIUS::Common.get_my_ip(module_instance.datastore["RHOSTS"]) unless $prelude_event_fetcher.local_ip
        end
        if !@@current_exploit.finished
          events = FIDIUS::EvasionDB.current_fetcher.fetch_events(module_instance)
          events.each do |event|
            if module_instance && module_instance.respond_to?("fullname")
              @@current_exploit.idmef_events << idmef_event
              # meterpreter is not a module and does not respond to fullname 
              # we handle this seperatly
            elsif module_instance == "Meterpreter"
              @@current_exploit.exploit_payload.idmef_events << idmef_event
            end
          end
          @@current_exploit.finished = true
          @@current_exploit.save
        end
      end

      def module_error(module_instance,exception)
        module_completed(module_instance)
      end



      def log_packet(module_instance,data,socket)
        begin
          # set local ip, if there is no
          #FIDIUS::EvasionDB.current_fetcher.local_ip = FIDIUS::Common.get_my_ip(socket.peerhost)
          $logger.debug "logged module_instance: #{module_instance} with #{data.size} bytes payload"
          # TODO: what shall we do with meterpreter? 
          # it has not options and no fullname, logger assigns only the string "meterpreter"
          if module_instance.respond_to?("fullname")
            if !@@current_exploit.finished
              @@current_exploit.packets << Packet.create(:payload=>data,:src_addr=>socket.localhost,:src_port=>socket.localport,:dest_addr=>socket.peerhost,:dest_port=>socket.peerport)
              @@current_exploit.save
            end
          # meterpreter is not a module and does not respond to fullname 
          # we handle this seperatly
          elsif module_instance == "Meterpreter"
            $logger.debug "module_instance is meterpreter"
            $logger.debug "putting package to exploit_payload"
            @@current_exploit.exploit_payload.packets << Packet.create(:payload=>data,:src_addr=>socket.localhost,:src_port=>socket.localport,:dest_addr=>socket.peerhost,:dest_port=>socket.peerport)
            @@current_exploit.save
          end
          $logger.debug "LOG: #{module_instance} #{data.size} Bytes on #{socket}"
        rescue ActiveRecord::StatementInvalid
          $logger.error "#{$!.message}"
        rescue 
          $logger.error "error: #{$!.inspect}:#{$!.backtrace}"
        end
      end

    end
  end
end
