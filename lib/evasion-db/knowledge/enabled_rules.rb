module FIDIUS::EvasionDB::Knowledge
  class EnabledRules < FIDIUS::EvasionDB::Knowledge::Connection
    belongs_to :attack_module

    def self.table_name
      "enabled_rules"
    end
  end
end
