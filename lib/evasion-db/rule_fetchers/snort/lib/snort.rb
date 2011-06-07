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

      def fetch_rules(attack_module)
        raise "no rulepath given" unless @@rule_path
        puts "snort rule fetcher"
        download_rules if @@fetch_remote

        Snortor.import_rules(@@rule_path)
        rules_enabled = BitField.new(Snortor.rules.size)
        i = 0
        Snortor.rules.each do |rule|
          if rule.message
            FIDIUS::EvasionDB::Knowledge::IdsRule.exists?(rule.message)
            rules_enabled[i] = rule.active
            i += 1
          end
        end

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


      def download_rules
        require 'net/ssh'
        require 'net/scp'
        #Net::SCP.download!("10.10.10.254", "root",
        #  "/etc/snort/rules/x11.rules", "/home/bernd/fidius/snortor/x11.rules",
        #  :password => "fidius09")
        puts "try to download rules from #{@@ssh_host}:#{@@ssh_remote_path}"
        Dir.mkdir(@@rule_path) if !File.exists?(@@rule_path)
        Net::SSH.start(@@ssh_host, @@ssh_user, :password => @@ssh_pw) do |ssh|
          ssh.scp.download! @@ssh_remote_path, @@rule_path,:recursive=>true
          #ssh.scp.upload! "/home/bernd/fidius/snortor/rules/rules/x11.rules", "/root/x11.rules"
        end
      end
    end
  end
end
