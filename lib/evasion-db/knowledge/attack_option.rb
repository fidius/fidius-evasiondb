module FIDIUS::EvasionDB::Knowledge
  class AttackOption < FIDIUS::EvasionDB::Knowledge::Connection
    belongs_to :attack

    def self.table_name
      "attack_options"
    end

  end
end
