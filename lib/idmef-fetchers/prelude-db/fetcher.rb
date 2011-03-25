$logger.debug "prelude-db"
FIDIUS::EvasionDB.fetcher "PreludeDB" do
  $logger.debug "prelude-db do"
  install do
    require (File.join File.dirname(__FILE__), 'models', 'prelude_event.rb')
    require (File.join File.dirname(__FILE__), 'models', 'prelude','connection.rb')
    Dir.glob(File.join File.dirname(__FILE__), 'models', 'prelude', '*.rb') do |rb|
      $logger.debug "loading #{rb}"
      require rb
    end
  end
end
