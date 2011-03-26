module FIDIUS
  module EvasionDB
    module TestFetcher
      def begin_record
        $logger.error "test-fetcher begin record"
      end

      def get_events
        $logger.error "test-fetcher get events"
      end
    end
  end
end
