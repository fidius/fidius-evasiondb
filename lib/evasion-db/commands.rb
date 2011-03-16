module FIDIUS
  module EvasionDB
    module Commands

      def self.set_local_ip(ip)
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
          Packet.create(:exploit=>caused_by, :payload=>data,:src_addr=>socket.localhost,:src_port=>socket.localport,:dest_addr=>socket.peerhost,:dest_port=>socket.peerport)
          $stdout.puts "LOG: #{caused_by} #{data.size} Bytes on #{socket}"
        rescue
          $stdout.puts "error: #{$!.inspect}:#{$!.backtrace}"
       end
      end

    end# module Commands
  end# module EvasionDB
end# module FIDIUS
