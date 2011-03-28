module FIDIUS::EvasionDB::Knowledge
  # everey attack can have a payload.
  # in metasploit this could be meterpreter
  class AttackPayload < FIDIUS::EvasionDB::Knowledge::Connection
    belongs_to :attack_module
    has_many :packets
    has_many :idmef_events

    def self.table_name
      "attack_payloads"
    end
  end
end
