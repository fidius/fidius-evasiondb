module FIDIUS::EvasionDB::Knowledge
  # model for local store generated idmef events and relate them to an executed attack
  class IdmefEvent < FIDIUS::EvasionDB::Knowledge::Connection
    belongs_to :attack_module
    belongs_to :attack_payload

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
