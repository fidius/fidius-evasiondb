module FIDIUS
  module PreludeDB

    class Alert < FIDIUS::PreludeDB::Connection
      has_one :detect_time, :class_name => 'DetectTime', :foreign_key => :_message_ident, :primary_key => :_ident
      has_one :source_address, :class_name => 'Address', :foreign_key => :_message_ident, :primary_key => :_ident, :conditions => [ "Prelude_Address._parent_type = 'S'" ]
      has_one :dest_address, :class_name => 'Address', :foreign_key => :_message_ident, :primary_key => :_ident, :conditions => [ "Prelude_Address._parent_type = 'T'" ]
      has_one :source_port, :class_name => 'Service', :foreign_key => :_message_ident, :primary_key => :_ident, :conditions => [ "Prelude_Service._parent_type = 'S'" ]
      has_one :dest_port, :class_name => 'Service', :foreign_key => :_message_ident, :primary_key => :_ident, :conditions => [ "Prelude_Service._parent_type = 'T'" ]
      has_one :classification, :class_name => 'Classification', :foreign_key => :_message_ident, :primary_key => :_ident
      has_one :analyzer, :class_name => 'Analyzer', :foreign_key => :_message_ident, :primary_key => :_ident
      has_one :impact, :class_name => 'Impact', :foreign_key => :_message_ident, :primary_key => :_ident
      has_one :payload, :class_name => 'AdditionalData', :foreign_key => :_message_ident, :primary_key => :_ident, :conditions=>["Prelude_AdditionalData.meaning='payload'"]
      set_primary_key :_ident

      def self.table_name
        "Prelude_Alert"
      end

      def self.total_entries
        sql = connection();
	      sql.begin_db_transaction
	      value = sql.execute("SELECT count(*) FROM Prelude_Alert;").fetch_row;
	      sql.commit_db_transaction
	      value[0].to_i;
      end

      def source_ip
        source_address.address
      end

      def dest_ip
         dest_address.address
      end

      def severity
        return impact.severity
      end

      def payload_data
        payload.data if payload != nil
      end
    end
  end
end
