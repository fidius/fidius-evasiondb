module FIDIUS
  module PreludeDB
    # Wrapper for Prelude_Classification table
    class Classification < FIDIUS::PreludeDB::Connection
      def self.table_name
        "Prelude_Classification"
      end
    end
  end
end
