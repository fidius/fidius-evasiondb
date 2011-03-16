module LogMatchesHelper

  def find_packets_for_event(event,packets)
    require 'rex'
    event_payload = nil
    return unless event.payload
    if event.payload.size > 0
      event_payload = Rex::Text.to_hex(event.payload).gsub("\\x","")
    end
    return unless event_payload

    packets.each do |packet|
      str = nil
      # lets find the payload of the prelude event
      # in one of the logged payloads
      packet_payload = Rex::Text.to_hex(packet.payload).gsub("\\x","")
      str = packet_payload[event_payload]
      return str if str != nil
    end
  end

end
