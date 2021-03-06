module FIDIUS
  module EvasionDB
    # This module provides active-record classes for the knowledge database.
    # Some handy query methods are also available.
    module Knowledge
      # used in find_events_for_exploit
      # to indicate that the exploit with minimal events should be searched
      MIN_EVENTS = 1
      # used in find_events_for_exploit
      # to indicate that the exploit with maximal events should be searched
      MAX_EVENTS = 2

      autoload :AttackModule,  "#{GEM_BASE}/evasion-db/knowledge/attack_module"
      autoload :AttackOption,  "#{GEM_BASE}/evasion-db/knowledge/attack_option"
      autoload :AttackPayload, "#{GEM_BASE}/evasion-db/knowledge/attack_payload"
      autoload :Connection,    "#{GEM_BASE}/evasion-db/knowledge/connection"
      autoload :IdmefEvent,    "#{GEM_BASE}/evasion-db/knowledge/idmef_event"
      autoload :Packet,        "#{GEM_BASE}/evasion-db/knowledge/packet"
      autoload :IdsRule,       "#{GEM_BASE}/evasion-db/knowledge/ids_rule"
      autoload :EnabledRules,  "#{GEM_BASE}/evasion-db/knowledge/enabled_rules"

      # returns all modules(exploits) in knowledge database
      def self.get_exploits
        AttackModule.all
      end

      def self.get_exploit(id)
        AttackModule.find(id)
      end

      # finds a packet within an id
      #
      #@param [integer] packet id
      def self.get_packet(id)
        Packet.find(id)
      end

      # returns all idmef-events
      def self.get_events
        IdmefEvent.all
      end

      # return an certain event
      #
      #@param [integer] event id
      def self.get_event(event_id)
        IdmefEvent.find(event_id)
      end

      # returns a certain packet
      #
      #@param [integer] packet id
      def self.get_packet(pid)
        Packet.find(pid)
      end

      # returns all exploits for the given services
      #
      #@param [array] ports_list
      def self.find_exploits_for_services(ports_list)
        exploits = []
        ports_list.each { |port| exploits.concat(find_exploits_for_service(port)) }
        exploits.map { |e| e.id }
      end

      # returns all exploits for the given service
      #
      #@param [integer] port
      def self.find_exploits_for_service(port)
        option_set = AttackOption.where(:option_key => "RPORT",
                                        :option_value => port)
        exploits = []
        option_set.each { |opt| exploits << opt.attack_module }
        exploits
      end

      # returns the packets which might be responsible for the given event
      #
      # @param [integer] event id
      def self.get_packet_for_event(event_id)
        event = IdmefEvent.find(event_id)
        FIDIUS::EvasionDB::LogMatchesHelper.find_packets_for_event(event,Packet.all)
      end

      # find out the events raised by the given payload
      #
      #@param [string] payload
      def self.get_events_for_payload(payload)
        #TODO: Search all packets which belong to this event
        events = []
        search_payload = FIDIUS::EvasionDB::LogMatchesHelper.to_hex(payload)
        IdmefEvent.find_each do |event|
          event_payload = FIDIUS::EvasionDB::LogMatchesHelper.to_hex(event.payload)
          events << event if event_payload.include?(search_payload)
        end

        events
      end

      # find events for an module(exploit). you can restrict your results by setting options
      # which sould be used by the exploit. You can even determine if minimal or maximal size of
      # events should be returned
      #
      #@param [string] exploit/module name
      #@param [hash] options which should be used
      #@param [integer] MIN_EVENTS||MAX_EVENTS
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
