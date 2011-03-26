module FIDIUS
  module PreludeDB
    class AdditionalData < FIDIUS::PreludeDB::Connection
      set_table_name "Prelude_AdditionalData"
      def self.columns() @columns ||= []; end
      def self.column(name, sql_type=nil, default=nil,null=true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s,default,sql_type.to_s,null)
      end

      column :_message_ident, :bigint
      column :meaning, :string
      column :data, :longblob
    end
  end
end
