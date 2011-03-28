module FIDIUS
  module PreludeDB
    # Wrapper for Prelude_Address table
    class Address < FIDIUS::PreludeDB::Connection
      set_table_name "Prelude_Address"
    end
  end
end
