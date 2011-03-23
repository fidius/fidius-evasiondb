TEST_DIR = File.dirname(File.expand_path(__FILE__))
LIB_DIR = File.join(TEST_DIR, '..', 'lib', 'evasion-db')

$LOAD_PATH.unshift LIB_DIR
require 'lib/evasion-db'
require 'test/unit'

module FIDIUS
  module EvasionDB
  # TODO: how to test with sample DB ??
  $prelude_event_fetcher.connect_db((File.join GEM_BASE, 'msf-plugins', 'database.yml.example'))
  end
end
