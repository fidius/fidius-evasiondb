# encoding: UTF-8

require 'logger'
require 'fidius-common'
require 'active_record'
require 'evasion-db/base'

module FIDIUS
  module EvasionDB
    $logger       = Logger.new(STDOUT)
    $logger.level = Logger::ERROR
    GEM_BASE      = File.expand_path('..', __FILE__)
    $logger.debug "GEM_BASE ist: #{GEM_BASE}"
    
    autoload :VERSION,          'evasion-db/version'
    autoload :LogMatchesHelper, 'evasion-db/log_matches_helper'
    autoload :Knowledge,        'evasion-db/knowledge'
    autoload :BitField,         'evasion-db/vendor/bitfield'

    # install fetchers
    require File.join(GEM_BASE, 'evasion-db', 'idmef-fetchers', 'fetchers.rb')
    FIDIUS::EvasionDB.install_fetchers

    # install recorders
    require File.join(GEM_BASE, 'evasion-db', 'recorders', 'recorders.rb')
    FIDIUS::EvasionDB.install_recorders

    # install rule_recorder
    require File.join(GEM_BASE, 'evasion-db', 'rule_fetchers', 'rule_fetchers.rb')
    FIDIUS::EvasionDB.install_rule_fetchers
  end
end
