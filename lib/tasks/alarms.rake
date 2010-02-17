require 'right_aws'
require 'base64'

task :alarms => :environment do
	all_rrds = RRD.find_all
	alarm_defs = AlarmDef.find :all
	alarm_defs.each do |ad|
		next if ad.disabled
		puts "[#{Time.now}] Examining alarm for #{ad.host}/#{ad.plugin}/#{ad.type}/#{ad.data_source}"
		rrds = all_rrds.reject do |rrd|
			(ad.host and !rrd.host.match("^(#{ad.host})$")) or
			(ad.plugin and !rrd.plugin.match("^(#{ad.plugin})$")) or
			(ad.type and !rrd.type.match("^(#{ad.type})$")) or
			(ad.data_source and !rrd.data_source.match("^(#{ad.data_source})$"))
		end
		rrds.each do |rrd|
				puts "[#{Time.now}]    Matched #{rrd.host}/#{rrd.plugin}/#{rrd.type}/#{rrd.data_source}"
				cmd = "/dist/collectd/bin/collectd-nagios -s /dist/collectd/collectd.sock -n #{rrd.plugin}/#{rrd.type} -d #{rrd.data_source} -g none -H #{rrd.host} -c #{ad.critical_range} -w #{ad.warning_range}"
				puts "[#{Time.now}]    - #{cmd}"
				result = IO.popen(cmd).gets
				puts "[#{Time.now}]    - #{result}"
				if result =~ /([A-Z]+): [0-9]+ critical, [0-9]+ warning, [0-9]+ okay \| [a-z]+=([0-9\.\+ena]+);;;;/
				   	severity = $1
					value = $2
					severity = 'OKAY' if ( value == 'nan' ) 
				else 
					severity = 'CRITICAL'
					value = 'UNAVAILABLE'
				end
				puts "[#{Time.now}]    - #{severity}(#{value})"
				alarm = Alarm.find :first, :conditions => "host = '#{rrd.host}' AND plugin='#{rrd.plugin}' AND type='#{rrd.type}' AND data_source='#{rrd.data_source}'"
				if !alarm
					# new alarms start as OKAY
					alarm = Alarm.new
					alarm.host = rrd.host
					alarm.plugin = rrd.plugin
					alarm.type = rrd.type
					alarm.data_source = rrd.data_source
					alarm.severity = 'OKAY'
					old_severity = 'OKAY'
				else
					old_severity = alarm.severity
				end
				alarm.update_severity severity
				alarm.value = value
				alarm.def_id = ad.id
				alarm.message = ad.message_format.dup
				alarm.message.gsub! "$host", rrd.host
				alarm.message.gsub! "$plugin", rrd.plugin
				alarm.message.gsub! "$type", rrd.type
				alarm.message.gsub! "$data_source", rrd.data_source
				alarm.message.gsub! "$severity", alarm.severity
				alarm.message.gsub! "$value", value
				if old_severity != alarm.severity
					puts "[#{Time.now}]    - Sending email due to severity transition"
					transition old_severity, alarm
				else 
					puts "[#{Time.now}]    - Not sending email -- no severity transition"
				end
				alarm.save!
		end
	end
end

def send_email(from, from_alias, to, to_alias, subject, message)
    msg = <<END_OF_MESSAGE
From: #{from_alias} <#{from}>
To: #{to_alias} <#{to}>
Subject: #{subject}
	 
#{message}
END_OF_MESSAGE
    Net::SMTP.start('outmail.dotspots.com') do |smtp|
        smtp.send_message msg, from, to
    end
end

def transition old_severity, alarm
    if alarm.severity == 'OKAY'
      msg = <<EOM
The alarm on #{alarm.host}/#{alarm.plugin}/#{alarm.type}/#{alarm.data_source} returned to the #{alarm.severity} state. [#{alarm.value}]
EOM
    else
      msg = <<EOM
The alarm on #{alarm.host}/#{alarm.plugin}/#{alarm.type}/#{alarm.data_source} has changed state to #{alarm.severity}. [#{alarm.value}]
#{alarm.message}
Please visit http://heymon.dotspots.com/explore/?host=#{CGI.escape(alarm.host)}&plugin=#{CGI.escape(alarm.plugin)}&type=#{CGI.escape(alarm.type)}&ds=#{CGI.escape(alarm.data_source)} to get more details.
EOM
    end

    send_email('heymon@dotspots.com', 'Heymon', 'ops@dotspots.com', 'DotOps', "[#{alarm.severity}] on #{alarm.host}/#{alarm.plugin}/#{alarm.type}/#{alarm.data_source}", msg);
    if ( alarm.alarm_def.action and alarm.alarm_def.action.length > 0 )
      send_email('heymon@dotspots.com', 'Heymon', alarm.alarm_def.action+"@dotspots.pagerduty.com", 'DotOps', "[#{alarm.severity}] on #{alarm.host}/#{alarm.plugin}/#{alarm.type}/#{alarm.data_source}", msg);      
    end
    sqs = RightAws::SqsGen2.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    q = sqs.queue('skype_ops')
    q.send_message(Base64.b64encode(msg))
end
