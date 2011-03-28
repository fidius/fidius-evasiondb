require 'helper'

class TestFetchers < Test::Unit::TestCase
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
