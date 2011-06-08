begin
  require 'snortor'
rescue
  raise "can not find snortor gem. Please gem install snortor"
end
module FIDIUS
  module EvasionDB
    module SnortRuleFetcher
      @@rule_path = nil

      @@ssh_host = nil
      @@ssh_pw = nil
      @@ssh_remote_path = nil
      @@ssh_user = nil
      @@fetch_remote = false
      @@ssh_options = {}

      def fetch_rules(attack_module)
        raise "no rulepath given" unless @@rule_path
        puts "snort rule fetcher"

        if @@fetch_remote
          a = {:host=>@@ssh_host,:user=>@@ssh_user,:password=>@@ssh_pw,:remote_path=>@@ssh_remote_path,:options=>@@ssh_options}
          puts "Snortor.import_rules(#{a.inspect})"
          Snortor.import_rules(a)
        else
          Snortor.import_rules(@@rule_path)
        end

        start_time = Time.now
        puts "rules exported save to db now"
        rules_enabled = BitField.new(Snortor.rules.size)
        i = 0

        insert_query = []

        #rules = []
        #rules << Snortor.rules[0]
        #rules << Snortor.rules[1]
        #rules << Snortor.rules[2]
        
        Snortor.rules.each do |rule|
          if rule.message
            #FIDIUS::EvasionDB::Knowledge::IdsRule.create_if_not_exists(rule.message,i)
            insert_query << FIDIUS::EvasionDB::Knowledge::IdsRule.sub_query_for_insert(rule.message,i)
            rules_enabled[i] = (rule.active == true)? 1 : 0
            i += 1
          end
        end
        begin
          FIDIUS::EvasionDB::Knowledge::IdsRule.connection.execute("INSERT IGNORE INTO ids_rules (rule_text,rule_hash,sort) VALUES #{insert_query.join(',')};")
        rescue
          begin
            # try without IGNORE statement
            FIDIUS::EvasionDB::Knowledge::IdsRule.connection.execute("INSERT INTO ids_rules (rule_text,rule_hash,sort) VALUES #{insert_query.join(',')};")
          rescue
            puts $!.message+":"+$!.backtrace.to_s
          end
        end
        end_time = Time.now

        puts "rules stored to db. #{end_time-start_time} seconds needed"
        ruleset = FIDIUS::EvasionDB::Knowledge::EnabledRules.create(:bitstring=>rules_enabled.to_s)
        ruleset.attack_module = attack_module
        ruleset.save
      end

      def config(conf)
        return unless conf
        conf = conf["snort-fetcher"]
        return unless conf.class == Hash

        @@rule_path = conf["rule_path"]#"/home/bernd/fidius/snort/rules/fetched"

        @@ssh_host = conf["ssh_host"] #"10.10.10.254"
        @@ssh_pw = conf["ssh_pw"]#"fidius09"
        @@ssh_remote_path = conf["ssh_remote_path"] #"/etc/snort/rules/"
        @@ssh_user = conf["ssh_user"] #"fidius"
        @@fetch_remote = @@ssh_host != nil
      end

      def self.ssh_options=(a)
        @@ssh_options = a
      end
    end
  end
end
