module FIDIUS
  module PreludeDB
    # Wrapper for Prelude_Impact table
    class Impact < FIDIUS::PreludeDB::Connection
      def self.columns() @columns ||= []; end
      def self.column(name, sql_type=nil, default=nil,null=true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s,default,sql_type.to_s,null)
      end

      column :description, :string
      column :severity, :string
      column :_message_ident, :bigint

      def self.table_name
        "Prelude_Impact"
      end
    end
  end
end
