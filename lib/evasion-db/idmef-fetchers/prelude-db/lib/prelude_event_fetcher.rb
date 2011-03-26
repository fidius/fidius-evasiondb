module FIDIUS
  module EvasionDB
    module PreludeEventFetcher
      def config(conf)
        $logger.debug "INIT PRELUDE EVENT FETCHER"
 	      ids_db = conf['ids_db']
        raise "no ids_db part found" unless ids_db
        FIDIUS::PreludeDB::Connection.establish_connection ids_db
        FIDIUS::PreludeDB::Connection.connection
        require (File.join File.dirname(__FILE__), 'patches', 'postgres_patch.rb')
      end

      def begin_record
        $logger.error "deine mudder begin record"
      end

      def get_events
        $logger.error "deine mudder get events"
      end
    end
  end
end

require (File.join File.dirname(__FILE__), 'models', 'prelude_event.rb')
require (File.join File.dirname(__FILE__), 'models', 'connection.rb')
Dir.glob(File.join File.dirname(__FILE__), 'models', '*.rb') do |rb|
  $logger.debug "loading #{rb}"
  require rb
end

