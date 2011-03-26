module FIDIUS
  module EvasionDB
    module PreludeEventFetcher
      def begin_record
        $logger.error "deine mudder begin record"
      end

      def get_events
        $logger.error "deine mudder get events"
      end
    end
  end
end

#require (File.join File.dirname(__FILE__), 'models', 'prelude_event.rb')
#require (File.join File.dirname(__FILE__), 'models', 'prelude','connection.rb')
#Dir.glob(File.join File.dirname(__FILE__), 'models', 'prelude', '*.rb') do |rb|
#  $logger.debug "loading #{rb}"
#  require rb
#end

