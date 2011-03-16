module FIDIUS
  module EvasionDB
    GEM_BASE      = File.expand_path('..', __FILE__)
    require (File.join GEM_BASE, 'evasion-db','commands.rb')
    require (File.join GEM_BASE, 'evasion-db','event_fetcher.rb')

    # Your code goes here...
    include Commands
    $prelude_event_fetcher = PreludeEventFetcher.new
  end
end
