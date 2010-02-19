OVERVIEW
=======

Heymon is a Rails-based frontend for Collectd. Heymon's initial development was performed as an infrastructure project for Dotspots.com. DotSpots, Inc. has graciously agreed to release this code as open source.

CREDITS
======

Brian Long (newobj@gmail.com, brian@dotspots.com)

Heymon's distribution includes:

* Ruby on Rails including constituent parts prototype/scriptaculous - http://rubyonrails.com
* jQuery - http://jquery.com/
* Thickbox - http://jquery.com/demo/thickbox/

SCREENSHOTS
===========

<a href="http://cloud.github.com/downloads/newobj/heymon/Picture_10.png" target="_blank"><img border="0" src="http://30.media.tumblr.com/tumblr_ky2c5kTj041qz5uuvo1_500.png"/></a>

INSTALLATION
============
1) Install the following gems: Note: I personally found it necessary to use version 1.3 of rrdtool-devel for compatibility with RubyRRDtool. [Brian Long]
    gem install right_aws
    gem install haml
    gem install RubyRRDtool
2) Install the gems for whatever database you plan on using, e.g. sqlite3. Note: use of sqlite3 in production is strongly discouraged.
    gem install sqlite3-ruby
3) Edit your database configuration to your liking.
    (edit config/database.yml)
4) Create heymon's databases
    rake db:migrate
5) Edit config/environment.rb to point to your collectd installation.  Note: yes, the implication is that heymon must run on the same machine as collectd.
    COLLECTD_HOME = '<path to collectd installation>' # (edit config/environment.rb to change the following line)
6) Start rails and you're off!
