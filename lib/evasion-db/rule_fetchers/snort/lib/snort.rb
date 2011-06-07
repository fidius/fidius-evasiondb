begin
  require 'snortor'
rescue
  raise "can not find snortor gem. Please gem install snortor"
end
module FIDIUS
  module EvasionDB
    module SnortRuleFetcher
      @@rule_path = nil
      def fetch_rules(attack_module)
        raise "no rulepath given" unless @@rule_path
        puts "snort rule fetcher"
        Snortor.import_rules(@@rule_path)
        rules_enabled = Bitfield.new(Snortor.rules.size)
        i = 0
        Snortor.rules.each do |rule|
          if rule.message
            FIDIUS::EvasionDB::Knowledge::IdsRule.exists?(rule.message)
            rules_enabled[i]
            i += 1
          end
        end
      end

      def config(conf)
        @@rule_path = "/home/bernd/fidius/snort/rules"
      end
    end
  end
end
