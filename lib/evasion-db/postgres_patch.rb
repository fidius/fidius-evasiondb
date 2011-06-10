# This Patch will fix the Error:
#ActiveRecord::StatementInvalid: PGError: ERROR:  relation "Prelude_Alert" does not exist
#LINE 4:              WHERE a.attrelid = '"Prelude_Alert"'::regclass
#                                        ^
#:             SELECT a.attname, format_type(a.atttypid, a.atttypmod), d.adsrc, a.attnotnull
#              FROM pg_attribute a LEFT JOIN pg_attrdef d
#                ON a.attrelid = d.adrelid AND a.attnum = d.adnum
#             WHERE a.attrelid = '"Prelude_Alert"'::regclass
#               AND a.attnum > 0 AND NOT a.attisdropped
#             ORDER BY a.attnum
# provided @http://s3.amazonaws.com/activereload-lighthouse/assets/a3d9b3646f58246ef6ffe027001dd643cca7aade/postgresql-support-capitalized-table-names.diff?AWSAccessKeyId=1AJ9W2TX1B2Z7C2KYB82&Expires=1290010522&Signature=ignfCi9%2Bm37oHijccGBsbJj298w%3D

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

