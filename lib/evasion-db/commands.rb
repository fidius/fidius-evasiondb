module FIDIUS
  module EvasionDB
    module Commands

  def self.set_local_ip(ip)
    $prelude_event_fetcher.local_ip = ip
  end

  def self.connect_db(config_file)
    $prelude_event_fetcher.connect_db(config_file)
  end

  def self.start_attack
    $prelude_event_fetcher.attack_started
  end

  def self.fetch_events
    $prelude_event_fetcher.get_events
  end

    end
  end# module Commands
end# module FIDIUS
