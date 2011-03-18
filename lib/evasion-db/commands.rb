module FIDIUS
  module EvasionDB
    module Commands

      def self.get_events
        IdmefEvent.all
      end

      def self.get_packet_for_event(event_id)
        event = IdmefEvent.find(event_id)
        FIDIUS::EvasionDB::LogMatchesHelper.find_packets_for_event(event,Packet.all)
      end

      def self.test_get_packet
        event = IdmefEvent.find(16)
        packet = FIDIUS::EvasionDB::LogMatchesHelper.find_packets_for_event(event,Packet.all)
      end



      def self.test_get_event
        event = IdmefEvent.find(16)

       # puts packet.inspect
        #Packet.first.payload
      end

      def self.set_local_ip(ip)
        #raise "dont need this any more"
        #puts "GEM EXEC: set_local_ip #{ip}"
        $prelude_event_fetcher.local_ip = ip
      end

      def self.db_connect(config_file)
        $prelude_event_fetcher.connect_db(config_file)
      end

      def self.start_attack
        $prelude_event_fetcher.attack_started
      end

      def self.fetch_events
        $prelude_event_fetcher.get_events
      end

      def self.log_packet(caused_by,data,socket)
        begin
          # set local ip, if there is no
          $prelude_event_fetcher.local_ip = FIDIUS::Common.get_my_ip(socket.peerhost) unless $prelude_event_fetcher.local_ip

          Packet.create(:exploit=>caused_by, :payload=>data,:src_addr=>socket.localhost,:src_port=>socket.localport,:dest_addr=>socket.peerhost,:dest_port=>socket.peerport)
          $stdout.puts "LOG: #{caused_by} #{data.size} Bytes on #{socket}"
        rescue
          $stdout.puts "error: #{$!.inspect}:#{$!.backtrace}"
       end
      end
    end# module Commands
  end# module EvasionDB
end# module FIDIUS
