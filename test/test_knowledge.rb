require 'helper'
class TestKnowledge < Test::Unit::TestCase
  include FIDIUS::EvasionDB::Knowledge

  def test_options_hash_finder
    AttackModule.destroy_all
    5.times do
      AttackModule.find_or_create_by_name_and_options("windows-exploit",{:a=>3,:b=>7})
    end
    assert_equal 1, AttackModule.all.size
    assert_equal 2, AttackOption.all.size

    5.times do
      AttackModule.find_or_create_by_name_and_options("windows-exploit",{:a=>3,:b=>5})
    end
    assert_equal 2, AttackModule.all.size
    assert_equal 4, AttackOption.all.size
    5.times do
      AttackModule.find_or_create_by_name_and_options("windows-exploit",{:a=>3,:b=>5,:c=>9})
    end
    assert_equal 3, AttackModule.all.size
    assert_equal 7, AttackOption.all.size
  end

  def test_idmef_event
    event_payload = "hallo"
    event = IdmefEvent.create(:text=>"testexploit",:payload=>event_payload)
    exploit = AttackModule.create(:name=>"exploit")
    payload = AttackPayload.create(:name=>"meterpreter")
    event.attack_module = exploit
    event.attack_payload = payload
    event.save

    event = IdmefEvent.find(event.id)
    assert_equal event_payload.size, event.payload_size
    assert_equal event_payload, event.payload
    assert_equal exploit.id, event.attack_module.id
    assert_equal payload.id, event.attack_payload.id
    event = IdmefEvent.create(:text=>"testexploit")
    assert_equal 0, event.payload_size
  end

  def test_packet
    payload = "hallo"
    packet = Packet.create
    assert_equal [], packet.payload
    packet = Packet.create(:payload=>payload)
    assert_equal payload, packet.payload 
  end

  def test_finders
    payload = "hallo"
    AttackModule.destroy_all
    Packet.destroy_all
    IdmefEvent.destroy_all

    exploit = AttackModule.create(:name=>"exploit")
    packet = Packet.create(:payload=>payload)
    event = IdmefEvent.create(:text=>"testexploit",:payload=>payload)
    
    assert_equal 1,FIDIUS::EvasionDB::Knowledge.get_exploits.size
    assert_equal packet, FIDIUS::EvasionDB::Knowledge.get_packet(packet.id)

    assert_equal 1, FIDIUS::EvasionDB::Knowledge.get_events.size
    assert_equal event, FIDIUS::EvasionDB::Knowledge.get_event(event.id)
    assert_equal packet, FIDIUS::EvasionDB::Knowledge.get_packet(packet.id)

    assert_equal event, FIDIUS::EvasionDB::Knowledge.get_event(event.id)
    p = FIDIUS::EvasionDB::Knowledge.get_packet_for_event(event.id)
    assert_equal packet, p[:packet]
    assert_equal 5, p[:length]
    assert_equal 0, p[:index]
  end
end
