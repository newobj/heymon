require 'RRD'

desc "Dumps info on all the rrds owned by collectd"
task :rrd_info => :environment do
	hosts = []

	Dir.foreach COLLECTD_RRD do |file|
		next if file == '.' or file == '..'
		hosts << file
	end

	hosts.each do |host|
		host_rrd = "#{COLLECTD_RRD}/#{host}"
		Dir.foreach host_rrd do |plugin|
			next if plugin == '.' or plugin == '..'
			plugin_rrd = "#{host_rrd}/#{plugin}"
			Dir.foreach plugin_rrd do |type|
				next if type === '.' or type == '..'
				rrd_path = "#{COLLECTD_RRD}/#{host}/#{plugin}/#{type}" #.gsub /\.rrd$/, ""
				rrd_info = RRD.info(rrd_path)
				data_sources = rrd_info.keys.inject [] do |ds,key|
					ds << $1 if  /^ds\[([^\\]+)\]/ =~ key
					ds
				end
				type = type.gsub /\.rrd$/, ''
				data_sources.uniq.each do |ds|
					puts "#{host}/#{plugin}/#{type}/#{ds}"
				end
			end
		end
	end
end
