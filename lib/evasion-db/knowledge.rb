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

      MIN_EVENTS = 1
      MAX_EVENTS = 2
      
      def self.find_events_for_exploit(name,options={},result = MIN_EVENTS)
        attacks = AttackModule.find_all_by_name(name).delete_if do |attack|
          !attack.has_options(options)
        end

        if attacks.size > 0
          res = nil
          if result == MIN_EVENTS
            min_cnt = 1073741823 #max value
            attacks.each do |attack|
              events_cnt = attack.idmef_events.size
              if events_cnt < min_cnt
                min_cnt = events_cnt
                res = attack
              end
            end
          elsif result == MAX_EVENTS
            min_cnt = 0 #min value
            attacks.each do |attack|
              events_cnt = attack.idmef_events.size
              if events_cnt > min_cnt
                min_cnt = events_cnt
                res = attack
              end
            end
          end
          return res.idmef_events if result
        end
        nil
      end
    end
  end
end 
