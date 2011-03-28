module FIDIUS
  module EvasionDB
    # This module is only a sample how a custom fetcher could be implemented.
    module TestFetcher
      def config(conf)
        $logger.debug "INIT Test FETCHER"
      end

      def begin_record
        $logger.debug "test-fetcher begin record"
      end

      def fetch_events(*args)
        $logger.debug "test-fetcher get events"
        return []
      end
    end
  end
end
