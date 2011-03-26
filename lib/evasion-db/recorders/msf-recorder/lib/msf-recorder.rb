module FIDIUS
  module EvasionDB
    module MsfRecorder
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

    end
  end
end
