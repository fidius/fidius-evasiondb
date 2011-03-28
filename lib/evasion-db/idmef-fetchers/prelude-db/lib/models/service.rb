module FIDIUS
  module PreludeDB
    # Wrapper for Prelude_Service table
    class Service < FIDIUS::PreludeDB::Connection
      def self.table_name
        "Prelude_Service"
      end
    end
  end
end
