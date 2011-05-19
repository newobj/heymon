OVERVIEW
=======

Heymon is a Rails-based frontend for Collectd. Heymon's initial development was performed as an infrastructure project for <http://dotspots.com>. DotSpots, Inc. has graciously agreed to release this code as open source.

CREDITS
======

Original Author:
Brian Long (<mailto:newobj@gmail.com>, <mailto:brian@dotspots.com>, <http://newobj.net>)

Contributors:
chrispy (<http://github.com/chrispy>)

Heymon's distribution includes:
* Ruby on Rails including constituent parts prototype/scriptaculous - <http://rubyonrails.com>
* jQuery - <http://jquery.com/>
* Thickbox - <http://jquery.com/demo/thickbox/>

SCREENSHOTS
===========

<a href="http://cloud.github.com/downloads/newobj/heymon/Picture_10.png" target="_blank"><img border="0" src="http://30.media.tumblr.com/tumblr_ky2c5kTj041qz5uuvo1_500.png"/></a>

INSTALLATION
============
1. Install the following gems:

    gem install right_aws
    gem install haml
2. Install RRDtool: <http://oss.oetiker.ch/rrdtool/> Make sure to enter bindings/ruby and install the ruby bindings as well.
3. Install the gems for whatever database you plan on using, e.g. sqlite3. Note: use of sqlite3 in production is strongly discouraged.

    gem install sqlite3-ruby
4. Edit your database configuration to your liking.

    (edit config/database.yml)
5. Create heymon's databases

    rake db:migrate
6. Edit `config/environment.rb` to point to your collectd installation.  Note: yes, the implication is that heymon must run on the same machine as collectd.

    COLLECTD_RRD = '<path to collectd rrds e.g. /dist/collectd/var/lib/collectd/rrd>' # (edit config/environment.rb to change the following line)
   Also edit the location of your rrdtool binary as necessary:
    RRDTOOL_BIN = '<path to rrdtool binary e.g. /usr/local/bin/rrdtool>'
7. Start rails and you're off!
