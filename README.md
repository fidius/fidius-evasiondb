# FIDIUS fidius-evasiondb

The FIDIUS Evasion-DB Gem is used to ...

Description

This gem is developed in the context of the students project "FIDIUS" at the
University of Bremen, for more information about FIDIUS visit
[fidius.me](http://fidius.me/en).

## Installation

UNTIL RELEASE: rake install

Simply install this package with Rubygems:

    $ gem install fidius-evasiondb

Then switch to the root directory of your Metasploit installation and run

    $ fidius-evasiondb -e

Follow the instructions.

Please note: The Evasion-DB Gem has only been tested with Linux systems
and might
 not work with Windows.

## Configuration

The database configuration can be found in

    path/to/your/metasploit/root/data/database.yml 

It has been tested with Postgres and MySQL databases but should work for others, too.

## Usage

There are two possibilities to use this Gem, either inside the Metasploit console (with a plugin) or from external scripts by requiring the Gem. 

### In msfconsole

* example for monitoring an exploit
* 

### From external script

* rquire gem, connect_db
* Only queries possible

### Queries

* list and explain available queries

## Authors and Contact

fidius-evasiondb was written by

* FIDIUS Intrusion Detection with Intelligent User Support
  <grp-fidius@tzi.de>, <http://fidius.me>
* in particular:
 * Bernhard Katzmarski <bkatzm+fidius-evasiondb@tzi.de>
 * Jens Färber <jfaerber+fidius-evasiondb@tzi.de>
 * Kai-Uwe Hanke <khanke+fidius-evasiondb@tzi.de>

If you have any questions, remarks, suggestion, improvements,
etc. feel free to drop a line at the addresses given above.
You might also join `#fidius` on Freenode or use the contact
form on our [website](http://fidius.me/en/contact).


## License

Simplified BSD License and GNU GPLv2. See also the file LICENSE.
