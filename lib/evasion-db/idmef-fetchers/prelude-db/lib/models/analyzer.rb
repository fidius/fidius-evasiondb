module FIDIUS
  module PreludeDB
    # Wrapper for Prelude_Analyzer table
    class Analyzer < FIDIUS::PreludeDB::Connection
      def self.columns() @columns ||= []; end
      def self.column(name, sql_type=nil, default=nil,null=true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s,default,sql_type.to_s,null)
      end
      column :model, :string
      column :name, :string
      column :_message_ident, :bigint

      def self.table_name
        "Prelude_Analyzer"
      end
    end
  end
end
