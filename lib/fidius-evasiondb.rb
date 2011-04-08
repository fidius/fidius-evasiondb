# encoding: UTF-8
#require 'rubygems'
#require 'bundler'
require 'logger'
require 'active_record'
require 'fidius-common'
#::Bundler.setup
#::Bundler.require(:default)

module FIDIUS
  module EvasionDB
    $logger = Logger.new(STDOUT)
    $logger.level = Logger::ERROR
    GEM_BASE      = File.expand_path('..', __FILE__)

    $logger.debug "GEM_BASE ist: #{GEM_BASE}"
    require (File.join GEM_BASE, 'evasion-db','log_matches_helper.rb')
    require (File.join GEM_BASE, 'evasion-db','base.rb')
    require (File.join GEM_BASE, 'evasion-db','knowledge.rb')

    # load knowledge
    require (File.join GEM_BASE, 'evasion-db','knowledge', 'connection.rb')
    Dir.glob(File.join GEM_BASE, 'evasion-db','knowledge', '*.rb') do |rb|
      require rb
    end

    # install fetchers
    require (File.join GEM_BASE, 'evasion-db','idmef-fetchers','fetchers.rb')
    FIDIUS::EvasionDB.install_fetchers

    # install recorders
    require (File.join GEM_BASE, 'evasion-db','recorders','recorders.rb')
    FIDIUS::EvasionDB.install_recorders
  end
end
