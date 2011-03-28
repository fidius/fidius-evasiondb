module FIDIUS
  module EvasionDB
    module Knowledge
      def self.get_exploits
        AttackModule.all
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

      FIND_MIN = 1
      FIND_MAX = 2
      
      def self.find_events_for_exploit(name,options=[],result = FIND_MIN)
        e = AttackModule.find_all_by_name(name)
        if e.size > 0
          return e
        end
        nil
      end
    end
  end
end 
