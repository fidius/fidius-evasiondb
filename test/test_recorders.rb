require_relative 'helper'

module FIDIUS
  module EvasionDB
    module TestFetcher
      def fetch_events(*args)
        result = []
        5.times do |i|
          result << FIDIUS::EvasionDB::Knowledge::IdmefEvent.create(:payload=>"payload",
                            :detect_time=>Time.now,
                            :dest_ip=>"10.0.0.1",:src_ip=>"10.20.20.1",
                            :dest_port=>445,:src_port=>4465,
                            :text=>"Hard Event",:severity=>"High",
                            :analyzer_model=>"Snort",:ident=>i)
        end
        result
      end
    end
  end
end
class TestRecorders < Test::Unit::TestCase
  class SocketStub
    def localhost
      "10.0.0.1"
    end
    def localport
      4446
    end
    def peerhost
      "10.20.20.1"
    end
    def peerport
      445
    end
  end

  class MsfModuleInstanceStub
    def datastore
      {"RHOST"=>"127.0.0.1","Payload" => "windows/meterpreter/bind_tcp","RHOSTS"=>"127.0.0.1"}
    end
    def fullname
      "windows/smb/ms08_067_netapi"
    end
  end

  def test_msf_recorder
    FIDIUS::EvasionDB::Knowledge::AttackModule.destroy_all
    instance = MsfModuleInstanceStub.new
    socket = SocketStub.new
    FIDIUS::EvasionDB.use_recoder "Msf-Recorder"
    FIDIUS::EvasionDB.use_fetcher "TestFetcher"

    FIDIUS::EvasionDB.current_recorder.module_started(instance)
    assert_equal 1, FIDIUS::EvasionDB::Knowledge::AttackModule.all.size
    assert_equal instance.fullname,  FIDIUS::EvasionDB::Knowledge::AttackModule.first.name
    10.times do |i|
      FIDIUS::EvasionDB.current_recorder.log_packet(instance,"payload#{i}",socket)
    end
    FIDIUS::EvasionDB.current_recorder.module_completed(instance)
    assert_equal "127.0.0.1", FIDIUS::EvasionDB.current_fetcher.local_ip
    assert_equal 10,  FIDIUS::EvasionDB::Knowledge::AttackModule.first.packets.size
  end

  def test_meterpreter_record
    FIDIUS::EvasionDB::Knowledge::AttackModule.destroy_all

    instance = MsfModuleInstanceStub.new
    socket = SocketStub.new
    FIDIUS::EvasionDB.use_recoder "Msf-Recorder"
    FIDIUS::EvasionDB.use_fetcher "TestFetcher"

    FIDIUS::EvasionDB.current_recorder.module_started(instance)
    assert_equal 1, FIDIUS::EvasionDB::Knowledge::AttackModule.all.size
    assert_equal instance.fullname,  FIDIUS::EvasionDB::Knowledge::AttackModule.first.name

    FIDIUS::EvasionDB.current_recorder.module_completed(instance)
    10.times do |i|
      FIDIUS::EvasionDB.current_recorder.log_packet("Meterpreter","payload#{i}",socket)
    end
    FIDIUS::EvasionDB.current_recorder.module_completed(instance)
    assert_equal "127.0.0.1", FIDIUS::EvasionDB.current_fetcher.local_ip
    assert_equal 10,  FIDIUS::EvasionDB::Knowledge::AttackModule.first.attack_payload.packets.size
  end

  def test_module_error
    FIDIUS::EvasionDB::Knowledge::AttackModule.destroy_all
    instance = MsfModuleInstanceStub.new
    socket = SocketStub.new
    FIDIUS::EvasionDB.use_recoder "Msf-Recorder"
    FIDIUS::EvasionDB.use_fetcher "TestFetcher"

    FIDIUS::EvasionDB.current_recorder.module_started(instance)
    assert_equal 1, FIDIUS::EvasionDB::Knowledge::AttackModule.all.size
    assert_equal instance.fullname,  FIDIUS::EvasionDB::Knowledge::AttackModule.first.name
    10.times do |i|
      FIDIUS::EvasionDB.current_recorder.log_packet(instance,"payload#{i}",socket)
    end
    FIDIUS::EvasionDB.current_recorder.module_error(instance,"ERROR")
    assert_equal "127.0.0.1", FIDIUS::EvasionDB.current_fetcher.local_ip
    assert_equal 10,  FIDIUS::EvasionDB::Knowledge::AttackModule.first.packets.size

  end

  def test_overwrites
    recorder = FIDIUS::EvasionDB::Recorder.new("a") do

    end
    assert_raises RuntimeError do
      recorder.start
    end
    assert_raises RuntimeError do
      recorder.log_packet
    end
  end
end
