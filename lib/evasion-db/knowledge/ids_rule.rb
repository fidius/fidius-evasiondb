module FIDIUS::EvasionDB::Knowledge
  class IdsRule < FIDIUS::EvasionDB::Knowledge::Connection
    def self.table_name
      "ids_rules"
    end

    def self.exists?(text)
      self.find_by_rule_hash(Digest::MD5.hexdigest(text)) != nil
    end

    def self.sub_query_for_insert(text,sort)
      h = Digest::MD5.hexdigest(text)
      # escape single quotes
      text = self.sanitize(text)
      return "(#{text},'#{h}',#{sort})"
    end

    def self.create_if_not_exists(text,sort=0)
      q = self.sub_query_for_insert(text,sort)
      begin
        self.connection.execute("INSERT IGNORE INTO ids_rules (rule_text,rule_hash,sort) VALUES #{q};")
      rescue
        puts $!.message
        puts "trying without IGNORE command"
        begin
          self.connection.execute("INSERT INTO ids_rules (rule_text,rule_hash,sort) VALUES #{q};")
        rescue
          puts $!.message
        end
      end
    end
  end
end
