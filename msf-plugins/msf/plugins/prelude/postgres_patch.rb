puts ">> Loading Postgres patch"

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      def quote_table_name(name)
        return name
      end
    end
  end
end

