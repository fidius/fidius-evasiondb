require 'logger'
require 'active_record'
require 'fidius-common'

module FIDIUS
  module EvasionDB
    $logger = Logger.new(STDOUT)
    $logger.level = Logger::DEBUG
    $logger.debug "geht los"
    GEM_BASE      = File.expand_path('..', __FILE__)
    require (File.join GEM_BASE, 'evasion-db','log_matches_helper.rb')
    require (File.join GEM_BASE, 'evasion-db','commands.rb')
    require (File.join GEM_BASE, 'evasion-db','finders.rb')
    require (File.join GEM_BASE, 'evasion-db','event_fetcher.rb')

    Dir.glob(File.join GEM_BASE, 'evasion-db', '*.rb') do |rb|
      require rb
    end

    require (File.join GEM_BASE, 'idmef-fetchers','fetchers.rb')
    FIDIUS::EvasionDB.install_fetchers

    require (File.join GEM_BASE, 'models', 'evasion','evasion_db_connection.rb')
    Dir.glob(File.join GEM_BASE, 'models', 'evasion', '*.rb') do |rb|
      require rb
    end

    $prelude_event_fetcher = PreludeEventFetcher.new
  end
end
