# -*- coding: utf-8 -*-
module Msf
class Plugin::EvasionTester < Msf::Plugin
  class ConsoleCommandDispatcher
    include Msf::Ui::Console::CommandDispatcher
    def name
      "EvasionTester"
    end

    def explain_db_connection
      print_status("Usage: ")
      print_status("evasion_db_connect path/to/database.yml")
      print_status()
      print_status("database.yml must have evasion_db entry which points to prelude db")
      print_status()
      print_status("example:")
      print_status("evasion_db:")
      print_status("  adapter: mysql")
      print_status("  host: localhost")
      print_status("  port: 3306")
      print_status("  encoding: utf8")
      print_status("  database: msf")
      print_status("  username: root")
      print_status("  password:")
    end

    def commands
      {
        "start_attack" => "indicate that you want to collect all events from Time.now on",
        "fetch_events" => "fetch events which were created in the meanwhile",
        "evasion_db_connect" => "connect to an instance of prelude database",
        "set_local_ip" => "set your local ip to filter events",
        "show_events" => "shows all fetched idmef-events",
        "show_event" => "shows information about an idmef-event"
      }
    end

    def cmd_set_local_ip(*args)
      raise "example: set_local_ip 10.0.0.100" if args.size != 1
      FIDIUS::EvasionDB::Commands.set_local_ip(args[0])
    end

    def cmd_evasion_db_connect(*args)
      if args.size == 0
        # error no path to database.yml
        print_error("no args given")
        explain_db_connection
      else
        file = args[0]
        begin
          FIDIUS::EvasionDB::Commands.db_connect(file)
        rescue
          print_error($!)
          explain_db_connection
        end
      end
    end

	def to_hex_dump(str, from=1, to=3)
    width=16
		buf = ''
		idx = 0
		cnt = 0
		snl = false
		lst = 0
    rclosed = true
		while (idx < str.length)      
			chunk = str[idx, width]
			line  = chunk.unpack("H*")[0].scan(/../).join(" ")
      if from >= idx && from < idx+width
        line[(idx-from).abs*3] = "%bld%red#{line[(idx-from).abs*3]}"
      end
      if to >= idx && to < idx+width
        offset = 0
        offset = "%bld%red".length if line["%bld%red"]
        line[(idx-to).abs*3+offset+1] = "#{line[(idx-to).abs*3+offset+1]}%clr"
      end
			buf << line

      line_length = line.gsub("%bld%red","").gsub("%clr","").length
			if (lst == 0)
				lst = line_length
				buf << " " * 4
			else
				buf << " " * ((lst - line_length) + 4).abs
			end

      index = 0
			chunk.unpack("C*").each do |c|
        if from >= idx && from < idx+width && (idx-from).abs == index || !rclosed
          buf << "%bld%red"
          rclosed = false
        end

				if (c >	0x1f and c < 0x7f)
					buf << c.chr
				else
					buf << "."
				end
        if to >= idx && to < idx+width && (idx-to).abs == index
          buf << "%clr"
          rclosed = true
        end

        index = index+1
			end
			buf << "\n"

			idx += width
		end

		buf << "\n"
	end

    def cmd_show_events(*args)
      events = FIDIUS::EvasionDB::Commands.get_events
      print_line "#{events.size} idmef-events fetched"
      events.each do |event|
        print_line "(#{event.id})#{event.text} with #{event.payload_size} bytes payload"
      end
    end

    def cmd_show_event(*args)
      raise "please provide event_id" if args.size != 1

      packet = FIDIUS::EvasionDB::Commands.get_packet_for_event(args[0].to_i)
      hex = to_hex_dump(packet[:packet].payload,packet[:index],packet[:index]+packet[:length])
      print_line "PACKET(#{packet[:packet].id}): #{packet[:packet].payload.size} bytes"
      print_line "match #{packet[:index]} - #{packet[:index]+packet[:length]}"
      print_line hex      
    end


    def cmd_start_attack(*args)
      #p = FIDIUS::EvasionDB::Commands.test_get_payload
      #packet = FIDIUS::EvasionDB::Commands.test_get_packet
      #event = FIDIUS::EvasionDB::Commands.test_get_event

      #hex = to_hex_dump(packet[:packet].payload,packet[:index],packet[:index]+packet[:length])
      #print_line "PACKET(#{packet[:packet].id}): #{packet[:packet].payload.size} bytes"
      #print_line "match #{packet[:index]} - #{packet[:index]+packet[:length]}"
      #print_line hex
      #print_line "----"
      #print_line "IDMEF-Event: #{event.payload.size} bytes"
      #hex = to_hex_dump(event.payload)
      #print_line hex


      print_status("start attack")
      FIDIUS::EvasionDB::Commands.start_attack
    end

    def cmd_fetch_events(*args)
      events = FIDIUS::EvasionDB::Commands.fetch_events
      print_status "#{events.size} events generated"
      print_status
      events.each do |e|
        print_status "#{e}"
      end
    end
  end

  def initialize(framework, opts)
    super
    # TODO require gem
    require 'evasion-db'
    begin
      add_console_dispatcher(ConsoleCommandDispatcher)
      FIDIUS::PacketLogger.init_with_framework(framework)
      FIDIUS::PacketLogger.on_log do |caused_by, data, socket|
        FIDIUS::EvasionDB::Commands.log_packet(caused_by,data,socket)
      end
    rescue
      puts "#{$!.inspect}"
    end
    print_status("EvasionTester plugin loaded.")
  end

  def cleanup
    remove_console_dispatcher(ConsoleCommandDispatcher)
  end

  def name
    "EvasionTester"
  end

  def desc
    "DESC"
  end
end

end

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
