module FIDIUS
  module EvasionDB
    GEM_BASE      = File.expand_path('..', __FILE__)
    require (File.join GEM_BASE, 'evasion-db','commands.rb')
    require (File.join GEM_BASE, 'evasion-db','event_fetcher.rb')

    # Your code goes here...
    include Commands

    Dir.glob(File.join GEM_BASE, 'evasion-db', '*.rb') do |rb|
      require rb
    end
    Dir.glob(File.join GEM_BASE, 'models', 'prelude', '*.rb') do |rb|
      require rb
    end
    Dir.glob(File.join GEM_BASE, 'models', 'evasion', '*.rb') do |rb|
      require rb
    end

    $prelude_event_fetcher = PreludeEventFetcher.new
  end
end
