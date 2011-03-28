require 'helper'
class TestPreludeDB < Test::Unit::TestCase
  def test_prelude_event
    PreludeDBHelper.setup_prelude_db($yml_config["ids_db"])
    #PreludeDBHelper.delete_all_records
    PreludeDBHelper.insert_event(223,"BadExploit","snort")

    p = FIDIUS::PreludeDB::Alert.first
    p = FIDIUS::PreludeDB::Classification.first
    p1 = FIDIUS::PreludeDB::PreludeEvent.find :first
    p2 = FIDIUS::PreludeDB::PreludeEvent.find :last
    assert_equal p1.id, p2.id
    assert_equal [p1],FIDIUS::PreludeDB::PreludeEvent.find(:all)
    assert_equal p1, FIDIUS::PreludeDB::PreludeEvent.find(p1.id)

    assert_equal "127.0.0.1", p1.source_ip
    assert_equal "127.0.0.1", p1.dest_ip
    assert_equal 445, p1.source_port
    assert_equal 446, p1.dest_port
    assert_equal FIDIUS::PreludeDB::DetectTime.first.time, p1.detect_time
    assert_equal "BadExploit", p1.text
    assert_equal "high", p1.severity
    assert_equal "snort", p1.analyzer_model
    assert_equal 223, p1.id
    assert_equal "00042a60-1fd5-11df-ad31", p1.messageid
    assert_equal "BadExploit: 127.0.0.1:445 -> 127.0.0.1:446", p1.to_s

    p1 = FIDIUS::PreludeDB::PreludeEvent.new(nil)
    assert_equal "No Ref", p1.source_ip
    assert_equal "No Ref", p1.dest_ip
    assert_equal "No Ref", p1.source_port
    assert_equal "No Ref", p1.dest_port
    assert_equal "No Ref", p1.detect_time
    assert_equal "No Ref", p1.text
    assert_equal "No Ref", p1.analyzer_model
    assert_equal "No Ref", p1.severity
    assert_equal "No Ref", p1.id
    assert_equal "No Ref", p1.messageid
    assert_equal "No Ref: No Ref:No Ref -> No Ref:No Ref", p1.to_s

  end
end
