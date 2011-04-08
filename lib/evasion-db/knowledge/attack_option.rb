module FIDIUS::EvasionDB::Knowledge
  # every AttackModule can have multiple options
  # these are key value pairs which are represented by this class
  class AttackOption < FIDIUS::EvasionDB::Knowledge::Connection
    belongs_to :attack_module

    def self.table_name
      "attack_options"
    end

  end
end
