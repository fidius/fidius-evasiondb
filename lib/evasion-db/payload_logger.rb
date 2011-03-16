module FIDIUS
class PacketLogger
  def self.on_log(&block)
    $block = block
  end

  def self.log_packet(socket,data,caused_by="")
    begin
      #PUT HERE IS RESPONSIBLE FOR NO SESSION ? $stdout.puts "log payload #{caused_by} #{data.size} bytes"
      $block.call caused_by, data, socket
    rescue
      #PUT HERE IS RESPONSIBLE FOR NO SESSION ? $stdout.puts "ERROR #{$!}:#{$!.backtract}"
    end
  end

  def self.inspect_socket(socket)
    "#{socket.localhost}:#{socket.localport} -> #{socket.peerhost}:#{socket.peerport}"    
  end

  class MySocketEventHandler
	  include Rex::Socket::Comm::Events

    def initialize

    end

	  def on_before_socket_create(comm, param)
	  end

	  def on_socket_created(comm, sock, param)
		  sock.extend(FIDIUS::SocketTracer)
		  sock.context = param.context
		  sock.params = param
		  sock.initlog
	  end
  end

  def self.init_with_framework(framework)
	  $eh = MySocketEventHandler.new
	  Rex::Socket::Comm::Local.register_event_handler($eh)
  end

  def self.cleanup
	  Rex::Socket::Comm::Local.deregister_event_handler($eh)
  end
end #PacketLogger
end #FIDIUS

# This extends the PacketDispatcher from Rex
# with Logging 
# Original Source is: lib/rex/post/meterpreter/packet_dispatcher.rb
module Rex::Post::Meterpreter::PacketDispatcher
  def send_packet(packet, completion_routine = nil, completion_param = nil)
    FIDIUS::PacketLogger.log_packet(self.sock,packet.to_r,"Meterpreter")
    if (completion_routine)
      add_response_waiter(packet, completion_routine, completion_param)
    end

    bytes = 0
    raw   = packet.to_r

    if (raw)
      begin
        bytes = self.sock.write(raw)
      rescue ::Exception => e
        # Mark the session itself as dead
        self.alive = false

        # Indicate that the dispatcher should shut down too
        @finish = true

        # Reraise the error to the top-level caller
        raise e		
      end
    end

    return bytes
  end
end

# This module extends the captured socket instance
# Copied from plugins/socket_logger.rb
module FIDIUS
module SocketTracer
  @@last_id = 0

  attr_accessor :context, :params

  # Hook the write method
  def write(buf, opts = {})
    FIDIUS::PacketLogger.log_packet(self,buf,context['MsfExploit'].fullname)
	  super(buf, opts)
  end

  # Hook the read method
  def read(length = nil, opts = {})
	  r = super(length, opts)
	  return r
  end

  def close(*args)
	  super(*args)
  end

  def initlog
  end
end #SocketTracer
end #FIDIUS
