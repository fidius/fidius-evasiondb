module FIDIUS
  module EvasionDB
    module TestFetcher
      def config(conf)
        $logger.debug "INIT Test FETCHER"
      end

      def begin_record
        $logger.error "test-fetcher begin record"
      end

      def fetch_events
        $logger.error "test-fetcher get events"
      end
    end
  end
end
