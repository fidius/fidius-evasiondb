require 'helper'
class TestExploit < Test::Unit::TestCase
  include FIDIUS::EvasionDB::Knowledge

  def test_options_hash_finder
    Exploit.destroy_all
    5.times do
      Exploit.find_or_create_by_name_and_options("windows-exploit",{:a=>3,:b=>7})
    end
    assert_equal 1, Exploit.all.size
    assert_equal 2, ExploitOption.all.size

    5.times do
      Exploit.find_or_create_by_name_and_options("windows-exploit",{:a=>3,:b=>5})
    end
    assert_equal 2, Exploit.all.size
    assert_equal 4, ExploitOption.all.size
    5.times do
      Exploit.find_or_create_by_name_and_options("windows-exploit",{:a=>3,:b=>5,:c=>9})
    end
    assert_equal 3, Exploit.all.size
    assert_equal 7, ExploitOption.all.size
  end
end
