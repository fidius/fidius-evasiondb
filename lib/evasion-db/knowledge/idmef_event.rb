module FIDIUS::EvasionDB::Models
  class IdmefEvent < FIDIUS::EvasionDB::Models::Connection
    belongs_to :exploit
    belongs_to :exploit_payload

    def self.table_name
      "idmef_events"
    end

    def payload
      return [] if self[:payload] == nil
      self[:payload]
    end

    def payload_size
      return self[:payload].size if self[:payload]
      return 0
    end
  end
end
