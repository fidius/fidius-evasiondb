module ActiveRecord
  module ConnectionAdapters
    # This class is a patch to make postgres play nice
    class PostgreSQLAdapter < AbstractAdapter
      # will fix quotation bug
      def quote_table_name(name)
        return name
      end
    end
  end
end

