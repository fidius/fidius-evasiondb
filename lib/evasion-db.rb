require 'active_record'
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
    require (File.join GEM_BASE, 'models', 'prelude','connection.rb')
    Dir.glob(File.join GEM_BASE, 'models', 'prelude', '*.rb') do |rb|
      require rb
    end
    require (File.join GEM_BASE, 'models', 'evasion','evasion_db_connection.rb')
    Dir.glob(File.join GEM_BASE, 'models', 'evasion', '*.rb') do |rb|
      require rb
    end

    $prelude_event_fetcher = PreludeEventFetcher.new
    # FIXME: only for test purpose
    $prelude_event_fetcher.connect_db((File.join GEM_BASE, 'msf-plugins', 'database.yml.example'))
  end
end
