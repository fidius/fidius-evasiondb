TEST_DIR = File.dirname(File.expand_path(__FILE__))
LIB_DIR = File.join(TEST_DIR, '..', 'lib', 'evasion-db')

$LOAD_PATH.unshift LIB_DIR
require 'test/unit'

# Tests the parsing funcionality of the NVD parser.
class TestTest < Test::Unit::TestCase
  def test_the_truth
    assert true
  end
end
