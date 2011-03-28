module FIDIUS
  module EvasionDB
    module LogMatchesHelper

  # this method is from Rex::Text of metasploit
	def self.to_hex(str, prefix = "\\x", count = 1)
		raise ::RuntimeError, "unable to chunk into #{count} byte chunks" if ((str.length % count) > 0)

		# XXX: Regexp.new is used here since using /.{#{count}}/o would compile
		# the regex the first time it is used and never check again.  Since we
		# want to know how many to capture on every instance, we do it this
		# way.
		return str.unpack('H*')[0].gsub(Regexp.new(".{#{count * 2}}", nil, 'n')) { |s| prefix + s }
	end

  def self.find_packets_for_event(event,packets)
    event_payload = nil
    return unless event.payload
    if event.payload.size > 0
      event_payload = self.to_hex(event.payload).gsub("\\x","")
    end
    return unless event_payload

    packets.each do |packet|
      str = nil
      # lets find the payload of the prelude event
      # in one of the logged payloads
      packet_payload = self.to_hex(packet.payload).gsub("\\x","")
      str = packet_payload[event_payload]
      return {:packet=>packet,:index=>packet.payload.index(event.payload),:length=>event.payload.size} if str != nil
    end
    nil
  end

end
end
end
