module Rex
module Post
module Meterpreter
module PacketDispatcher
  alias original_send_request send_request

  def send_request(packet, t = self.response_timeout)
    begin
      packet.tlvs.each do |tlv|
        if ["stdapi_fs_ls","stdapi_sys_config_sysinfo","stdapi_fs_getwd","stdapi_sys_config_getuid"].member?(tlv.value)
          tlv.value = Base64.encode64(tlv.value).to_s.gsub("\n","")
        end
      end
      res = original_send_request(packet,t)
      return res
    rescue
      $stdout.puts "your error: #{$!} is here: #{$!.backtrace}"
    end
  end
end
end
end
end
