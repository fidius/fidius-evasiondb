# Tests the parsing funcionality of the NVD parser.
class TestTest < Test::Unit::TestCase
  def test_the_truth
    assert true
  end

  def test_set_local_ip
    FIDIUS::EvasionDB.set_local_ip "localhost"
  end

  #def test_start_attack
  #  FIDIUS::EvasionDB.start_attack
  #end
end
