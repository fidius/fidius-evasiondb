# encoding: UTF-8
module Msf
class Plugin::EvasionDB < Msf::Plugin
  class ConsoleCommandDispatcher
    include Msf::Ui::Console::CommandDispatcher
    def name
      "FIDIUS-EvasionDB"
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
        "fetch_events" => "fetch events which were created in the meanwhile",
        "show_events" => "shows all fetched idmef-events",
        "show_event" => "shows information about an idmef-event",
        "show_packet" => "shows information about a packet",
        "send_packet" => "send a given packet to generate false positive",
        "send_event_payload" => "send a given payload of an idmef-event to generate false positive",
        "config_exploit" => "configures an exploit with the options of a previous runtime",
        "delete_events" => "deletes events from knowledge",
        "set_autologging" => "true|false automatically log all executed modules",
        "import_rules" => "import rules based on your config (this could take some time)",
        "assign_rules_to_attack" => "assigns bitvector of activated rules to the given attack"
      }
    end

    def run_cmd(cmd)
      $console.run_single(cmd)
    end

	def to_hex_dump(str, from=-1, to=-1)
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
        begin
          line[(idx-to).abs*3+offset+1] = "#{line[(idx-to).abs*3+offset+1]}%clr"
        rescue
          # rescue if the index is out of range, than end mark
          line[line.length-1] = "#{line[line.length-1]}%clr"
        end
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
    buf << "%clr" unless rclosed
		buf << "\n"
	end

    def send_payload_to_host(payload,host,port)
      begin
        c = Rex::Socket.create_tcp('PeerHost'=>host,'PeerPort' => port)
        c.write(payload)
        c.close
      rescue
        print_error "#{$!} in #{$!.backtrace}"
      end
    end

    def cmd_import_rules(*args)
      FIDIUS::EvasionDB.current_rule_fetcher.import_rules
    end

    def cmd_assign_rules_to_attack(*args)
      raise "please provide an attack module id" if args.size != 1
      a = FIDIUS::EvasionDB::Knowledge::AttackModule.find(args[0].to_i)
      FIDIUS::EvasionDB.current_rule_fetcher.fetch_rules(a)
    end


    def cmd_send_packet(*args)
      raise "please provide packet id" if args.size != 1
      packet = FIDIUS::EvasionDB::Knowledge.get_packet(args[0].to_i)
      send_payload_to_host(packet.payload,packet.dest_addr,packet.dest_port)
    end

    def cmd_send_event_payload(*args)
      raise "please provide packet id" if args.size != 1
      event = FIDIUS::EvasionDB::Knowledge.get_event(args[0].to_i)
      send_payload_to_host(event.payload,event.dest_ip,445)
    end

    def cmd_show_events(*args)
      exploits = FIDIUS::EvasionDB::Knowledge.get_exploits
      exploits.each do |exploit|
        events = exploit.idmef_events
        print_line "-"*60
        print_line "(#{exploit.id})#{exploit.name} with #{exploit.attack_options.size} options"
        print_line "-"*60
        print_line "#{events.size} idmef-events fetched"
        print_line "-"*60

        if exploit.enabled_rules
          print_line "-"*60
          all = exploit.enabled_rules.count(:all)
          active = exploit.enabled_rules.count(:active)
          print_line "Rules: #{active}/#{all}"
          print_line "-"*60
        end
        events.each do |event|
          print_line "(#{event.id})#{event.text} with #{event.payload_size} bytes payload"
        end
      end
    end

    def cmd_set_autologging(*args)
      raise "please use set_autologging true|false" if args.size != 1
      $auto_logging = args[0] == true
    end

    def cmd_delete_events(*args)
      raise "please provide id" if args.size != 1
      exploit = FIDIUS::EvasionDB::Knowledge.get_exploit(args[0].to_i)
      exploit.destroy
    end

    def cmd_config_exploit(*args)
      raise "please provide id" if args.size != 1
      exploit = FIDIUS::EvasionDB::Knowledge.get_exploit(args[0].to_i)
      run_cmd("use #{exploit.name}")
      exploit.attack_options.each do |option|
        run_cmd("set #{option.option_key} #{option.option_value}")
      end
    end

    def cmd_show_packet(*args)
      raise "please provide packet_id" if args.size != 1
      packet = FIDIUS::EvasionDB::Knowledge::Packet.find(args[0].to_i)
      
      hex = to_hex_dump(packet.payload)
      print_line hex
    end

    def cmd_show_event(*args)
      raise "please provide event_id" if args.size != 1
      event_id = args[0].to_i
      print_line "event_id:#{event_id}"
      event = FIDIUS::EvasionDB::Knowledge.get_event(event_id)
      packet = FIDIUS::EvasionDB::Knowledge.get_packet_for_event(event_id)
      print_line "(#{event.id}) Event(#{event.text}) : #{event.payload_size} bytes payload"
      if packet
        print_line "#{packet.inspect}"
        print_line "#{packet[:packet].inspect}"
        print_line "PACKET(#{packet[:packet].id}): "
        print_line "#{packet[:packet].payload.size} bytes"
        print_line "match #{packet[:index]} - #{packet[:index]+packet[:length]-1}"
        hex = to_hex_dump(packet[:packet].payload,packet[:index],packet[:index]+packet[:length]-1)
        print_line hex      
      else
        print_line "no packets available"
      end
      print_line "EVENT PAYLOAD(#{event.payload.size}) bytes:"
      hex = to_hex_dump(event.payload)
      print_line hex
    end

    def cmd_fetch_events(*args)
      #events = FIDIUS::EvasionDB::Knowledge.fetch_events
      FIDIUS::EvasionDB.current_fetcher.local_ip = nil
      events = FIDIUS::EvasionDB.current_fetcher.fetch_events
      if events
        print_status "#{events.size} events generated"
        print_status
        events.each do |e|
          print_line "(#{e.id}) Event(#{e.text}) : #{e.payload_size} bytes payload (#{e.src_ip} -> #{e.dest_ip})"
          print_status "#{e}"
        end
      else
        print_status "0 events generated"
      end
      FIDIUS::EvasionDB.current_fetcher.begin_record
    end
  end

  def initialize(framework, opts)
    super
    require 'fidius-evasiondb'
    msf_home = File.expand_path("../..",__FILE__)
    dbconfig_path = File.join(msf_home,"data","database.yml")
    raise "no database.yml in #{dbconfig_path}" if !File.exists?(dbconfig_path)

    $console = opts['ConsoleDriver']
    $auto_logging = true
    FIDIUS::EvasionDB.config(dbconfig_path)
    FIDIUS::EvasionDB.use_recoder "Msf-Recorder"
    FIDIUS::EvasionDB.use_fetcher "PreludeDB"
    FIDIUS::EvasionDB.use_rule_fetcher "Snortrule-Fetcher"
    FIDIUS::EvasionDB::SnortRuleFetcher.ssh_options = {:auth_methods=>["password"],:msfmodule=>FIDIUS::MsfModuleStub}

    add_console_dispatcher(ConsoleCommandDispatcher)
    framework.events.add_general_subscriber(FIDIUS::ModuleRunCallback.new)

    FIDIUS::PacketLogger.init_with_framework(framework)
    FIDIUS::PacketLogger.on_log do |caused_by, data, socket|
      FIDIUS::EvasionDB.current_recorder.log_packet(caused_by,data,socket)
    end
    FIDIUS::EvasionDB.current_fetcher.begin_record
    print_status("EvasionDB plugin loaded.")
  end

  def cleanup
    remove_console_dispatcher(ConsoleCommandDispatcher)
  end

  def name
    "FIDIUS-EvasionDB"
  end

  def desc
    ""
  end
end

end

module FIDIUS
class PacketLogger
  def self.on_log(&block)
    $block = block
  end

  def self.log_packet(socket,data,module_instance=nil)
    begin
      $block.call module_instance, data, socket
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

class ModuleRunCallback
  def on_module_run(instance)
    FIDIUS::EvasionDB.current_recorder.module_started(instance) if $auto_logging
  end
	#
	# Called when a module finishes
	#
	def on_module_complete(instance)
    FIDIUS::EvasionDB.current_recorder.module_completed(instance) if $auto_logging
	end

	#
	# Called when a module raises an exception
	#
	def on_module_error(instance, exception)
    FIDIUS::EvasionDB.current_recorder.module_error(instance,exception) if $auto_logging
	end
end #class ModuleRunCallback

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
    module_instance = context['MsfExploit'] if context['MsfExploit']
    FIDIUS::PacketLogger.log_packet(self,buf,module_instance)
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

module FIDIUS
class MsfModuleStub
  # do nothing to prevent metasploits lib/net/ssh.rb from dieing
  def self.add_socket(a)
  end
  def self.remove_socket(a)
  end
end
end
