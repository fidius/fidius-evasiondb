module FIDIUS
  module PreludeDB
    # Wrapper for Prelude_DetectTime table
    class DetectTime < FIDIUS::PreludeDB::Connection
      def self.table_name
        "Prelude_DetectTime"
      end
    end
  end
end
