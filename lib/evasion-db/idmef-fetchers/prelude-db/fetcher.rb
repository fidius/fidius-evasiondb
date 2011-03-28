$logger.debug "prelude-db"
FIDIUS::EvasionDB.fetcher "PreludeDB" do
  $logger.debug "prelude-db do"
  install do
    require (File.join File.dirname(__FILE__), 'lib', 'prelude_event_fetcher.rb')
    self.extend PreludeEventFetcher
  end
end
