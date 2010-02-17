#!/usr/bin/ruby

require 'rubygems'
require 'mysql'

STDIN.each do |line|
        if line =~ /Severity: (.*)/
                @severity = $1
        elsif line =~ /Time: (.*)/
                @time = $1
        elsif line =~ /Host: (.*)/
                @host = $1
        elsif line =~ /Plugin: (.*)/
                @plugin = $1
        elsif line =~ /PluginInstance: (.*)/
                @plugin_inst = $1
        elsif line =~ /Type: (.*)/
                @type = $1
        elsif line =~ /TypeInstance: (.*)/
                @type_inst = $1
        elsif line =~ /[a-z]+/
                @message ||= ''
                @message = "#{@message} #{line.chomp.tr('\'', '')}"
        end
end

#puts "#{@severity} | #{@host} | #{@plugin} | #{@plugin_inst} | #{@type} | #{@type_inst} | #{@message}"

dstmt = "delete from alarms where host = '#{@host}' and plugin = '#{@plugin}' and plugin_instance = '#{@plugin_inst}' and type = '#{@type}' and type_instance = '#{@type_inst}'"
puts dstmt
istmt = "insert into alarms (severity, host, plugin, plugin_instance, type, type_instance, message, created_at, updated_at) values ('#{@severity}', '#{@host}', '#{@plugin}', '#{@plugin_inst}', '#{@type}', '#{@type_inst}', '#{@message}', utc_timestamp, utc_timestamp)"
puts istmt

dbh = Mysql.real_connect("logjam.dotspots.com", "root", "", "heymon")
puts "Server version: " + dbh.get_server_info

dbh.query(dstmt);
dbh.query(istmt);

#db = SQLite3::Database.new( "/dist/heymon/db/production.sqlite3" )
#db.execute( dstmt )
#db.execute( istmt )
dbh.close

puts "closed"
