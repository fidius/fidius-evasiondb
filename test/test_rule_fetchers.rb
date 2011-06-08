require 'helper'

class TestRuleFetchers < Test::Unit::TestCase
  def test_rule_fetcher
    FIDIUS::EvasionDB::Knowledge::EnabledRules.destroy_all
    FIDIUS::EvasionDB::Knowledge::IdsRule.destroy_all

    FIDIUS::EvasionDB.use_rule_fetcher "Snortrule-Fetcher"
    FIDIUS::EvasionDB::current_rule_fetcher.fetch_rules(FIDIUS::EvasionDB::Knowledge::AttackModule.new)

    # cant provide this for sqlite
    #assert_equal 2, FIDIUS::EvasionDB::Knowledge::IdsRule.all.size
    assert_equal 1, FIDIUS::EvasionDB::Knowledge::EnabledRules.all.size
    enabled_rules = FIDIUS::EvasionDB::Knowledge::EnabledRules.first
    assert_equal "11", enabled_rules.bitstring
  end
end
