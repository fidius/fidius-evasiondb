module FIDIUS
  module PreludeDB
    # Wrapper for Prelude_DetectTime table
    class DetectTime < FIDIUS::PreludeDB::Connection
      set_primary_key :_message_ident
      set_table_name "Prelude_DetectTime"
      #def self.table_name
      #  puts "HALLO"
      #  "Prelude_DetectTime"
      #end
    end
  end
end
