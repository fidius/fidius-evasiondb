module FIDIUS
  module EvasionDB
    class AbstractIdmefFetcher
      def begin_record
        raise "overwrite this"
      end

      def get_events
        raise "overwrite this"
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "*/fetcher.rb")].each{|fetch_require|
  $logger.debug "load #{fetch_require}"
  require fetch_require
} 
