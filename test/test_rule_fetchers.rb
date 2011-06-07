require 'helper'

class TestRuleFetchers < Test::Unit::TestCase
  def test_rule_fetcher
    FIDIUS::EvasionDB::Knowledge::EnabledRules.destroy_all
    FIDIUS::EvasionDB.use_rule_fetcher "Snortrule-Fetcher"
    FIDIUS::EvasionDB::current_rule_fetcher.fetch_rules(FIDIUS::EvasionDB::Knowledge::AttackModule.new)
    assert_equal 1, FIDIUS::EvasionDB::Knowledge::EnabledRules.all.size
  end
end
