module FIDIUS
  module PreludeDB
    class Service < FIDIUS::PreludeDB::Connection
      def self.table_name
        "Prelude_Service"
      end
    end
  end
end
