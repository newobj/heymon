require 'RRDtool'

$all_rds = []

class RRD
	attr_accessor :host, :plugin, :type, :data_source

	def initialize(host, plugin, type, data_source)
		self.host = host
		self.plugin = plugin
		self.type = type
		self.data_source = data_source
	end

	def self.load_all_rrds
		collectd_rrd_path = "#{COLLECTD_HOME}/var/lib/collectd/"
		rrds = []
		Dir.foreach collectd_rrd_path do |host|
			next if host == '.' or host == '..'
			host_rrd = "#{collectd_rrd_path}/#{host}"
			Dir.foreach host_rrd do |plugin|
				next if plugin == '.' or plugin == '..'
				plugin_rrd = "#{host_rrd}/#{plugin}"
				Dir.foreach plugin_rrd do |type|
					next if type == '.' or type == '..'
					type = type.gsub(/\.rrd$/, "")
					rrd_path = "#{collectd_rrd_path}/#{host}/#{plugin}/#{type}.rrd"
					rrd = RRDtool.new(rrd_path)
					rrd.info.keys.each do |key|
						# assumes data sources have a ds[foo].type entry
						if /^ds\[([^\\]+)\]\.type/ =~ key
							data_source = $1
							rrds << RRD.new(host, plugin, type, data_source)
						end
					end
				end
			end
		end
		$all_rrds = rrds
	end

	def self.find_all
		return $all_rrds if $all_rrds and $all_rrds.size > 0 
		load_all_rrds
		$all_rrds
	end
end