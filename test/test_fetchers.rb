require 'helper'

class TestFetchers < Test::Unit::TestCase
  def test_prelude_event_fetcher
    PreludeDBHelper.setup_prelude_db($yml_config["ids_db"])
    PreludeDBHelper.insert_event(223,"BadExploit","snort")

    FIDIUS::EvasionDB.use_fetcher "PreludeDB"
    FIDIUS::EvasionDB::current_fetcher.begin_record
    FIDIUS::EvasionDB.current_fetcher.local_ip = "127.0.0.1"
    PreludeDBHelper.insert_event(224,"BadExploit1","snort")
    PreludeDBHelper.insert_event(225,"BadExploit2","snort")
    PreludeDBHelper.insert_event(226,"BadExploit3","snort")
    events = FIDIUS::EvasionDB::current_fetcher.fetch_events
    assert_equal 4,FIDIUS::PreludeDB::Alert.all.size
    assert_equal 3, events.size
  end

  def test_overwrites
    fetcher = FIDIUS::EvasionDB::Fetcher.new("a") do

    end
    assert_raises RuntimeError do
      fetcher.config("a")
    end
    assert_raises RuntimeError do
      fetcher.begin_record
    end
    assert_raises RuntimeError do
      fetcher.fetch_events
    end

  end
end
