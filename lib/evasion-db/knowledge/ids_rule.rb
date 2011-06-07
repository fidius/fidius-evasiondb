module FIDIUS::EvasionDB::Knowledge
  class IdsRule < FIDIUS::EvasionDB::Knowledge::Connection
    def self.table_name
      "ids_rules"
    end

    def self.exists?(text)
      self.find_by_hash(Digest::MD5.hexdigest(text)) != nil
    end

    def self.create_if_not_exists(text)
      unless self.exists?(text)
        sort = 0
        latest = self.find(:first,:order=>"sort DESC")
        sort = latest.sort+1 if latest
        self.create(:rule_text=>text,:hash=>Digest::MD5.hexdigest(text),:sort=>sort)
      end
    end
  end
end
