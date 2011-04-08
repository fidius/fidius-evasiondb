require 'digest/md5'
module FIDIUS::EvasionDB::Knowledge
  # Represents an Attack
  # in metasploit this would be exploits or auxiliaries
  class AttackModule < FIDIUS::EvasionDB::Knowledge::Connection
    has_many :idmef_events, :dependent=>:destroy
    has_many :packets, :dependent=>:destroy
    has_many :attack_options, :dependent=>:destroy
    has_one :attack_payload, :dependent=>:destroy

    def self.table_name
      "attack_modules"
    end

    def self.find_or_create_by_name_and_options(name,options)
      hash = Digest::MD5.hexdigest(options.to_s)
      attack_module = self.find_or_create_by_name_and_options_hash(name,hash)
      if attack_module.attack_options.size == 0
        attack_module.options_hash = hash
        $logger.debug "PAYLOAD: #{options['PAYLOAD']}"
        attack_module.attack_payload = AttackPayload.new(:name=>options["Payload"]) if options["Payload"]
        options.each do |k,v|
          attack_module.attack_options << AttackOption.new(:option_key=>k,:option_value=>v)
        end
        attack_module.save
      end
      attack_module
    end

    def has_option(k,v)
      attack_options.find_by_option_key_and_option_value(k,v) != nil
    end

    def has_options(options = {})
      options.each do |k,v|
        return false if !self.has_option(k,v)
      end
      true
    end
  end
end
