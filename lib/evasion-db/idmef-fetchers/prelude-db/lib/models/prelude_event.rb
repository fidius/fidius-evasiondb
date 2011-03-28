module FIDIUS
  module PreludeDB
    # Represents an IDMEF-Event which is distributed over multiple tables in PreludeManager
    class PreludeEvent < FIDIUS::PreludeDB::Connection
      has_many :annotated_events
      def self.columns() @columns ||= []; end
      def self.column(name, sql_type=nil, default=nil,null=true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s,default,sql_type.to_s,null)
      end

      @prelude_alert = nil

      def initialize(prelude_alert)
        @prelude_alert = prelude_alert
      end

      def self.find_by_sql(query)

      end
      
      def self.total_entries(options = nil)
        return Alert.total_entries
      end

      def self.find(*args)
        if args[0].is_a? Numeric
          a = Alert.find(:all, :conditions => [ "_ident = ?", args[0] ])
          return PreludeEvent.new a.first
        else
          case args[0]  
            when :all
              if args[1]
                if(args[1][:conditions] == nil)
                  args[1] = args[1].merge({:joins => [:detect_time,]})
                  args[1] = args[1].merge({:order => 'time DESC'})
                end
              end
              a = Alert.find(*args)
              result = Array.new
              a.each do |pa|
                result.push PreludeEvent.new pa
              end
              return result
            when :first
              a = Alert.first
              return PreludeEvent.new a
            when :last
              a = Alert.last
              return PreludeEvent.new a
            else  

          end
        end
      end

      def source_ip
        return @prelude_alert.source_ip unless @prelude_alert.nil?
        return "No Ref"
      end

      def dest_ip
        return @prelude_alert.dest_ip unless @prelude_alert.nil?
        return "No Ref"
      end

      def source_port
        return @prelude_alert.source_port.port unless @prelude_alert.nil?
        return "No Ref"
      end

      def dest_port
        return @prelude_alert.dest_port.port unless @prelude_alert.nil?
        return "No Ref"
      end

      def payload
        return @prelude_alert.payload_data unless @prelude_alert.nil?
      end

      def detect_time
       return @prelude_alert.detect_time.time unless @prelude_alert.nil?
       return "No Ref"
      end
      def text
        return @prelude_alert.classification.text  unless @prelude_alert.nil?
        return "No Ref"
      end
      def severity
        return @prelude_alert.severity  unless @prelude_alert.nil?
        return "No Ref"
      end
      def analyzer_model
        return @prelude_alert.analyzer.name.to_s  unless @prelude_alert.nil?
        return "No Ref"
      end

      def id
        return @prelude_alert._ident  unless @prelude_alert.nil?
        return "No Ref"
      end

      def inspect
        begin
        return "PreludeEvent id: "+id.to_s+", source_ip: "+source_ip+" dest_ip: "+dest_ip+" severity: "+severity+" text: "+text+" analyzer_model: "+analyzer_model+" detect_time: "+detect_time.to_s+""
        rescue
          puts $!.message+":"+$!.backtrace.to_s
        end
      end

      def to_s
        "#{text}: #{source_ip}:#{source_port} -> #{dest_ip}:#{dest_port}"
      end

      def messageid
        return @prelude_alert.messageid unless @prelude_alert.nil?
        return "No Ref"
      end
    end
  end
end
