class GraphController < ApplicationController

	GRAPH_COLORS = [ 
		"#e60b0b", "#e6af0b", "#78e60b", "#0be642", "#0be6e6", "#0b42e6", 
		"#780be6", "#e60baf", "#cc6666", "#cccc66", "#66cc66", "#66cccc", 
		"#6666cc", "#cc66cc", "#660a0a", "#66660a", "#0a660a", "#0a6666", 
		"#0a0a66", "#660a66"
	]

	def graph_index_color index
		GRAPH_COLORS[index % GRAPH_COLORS.size]
	end

	def index
		all_rrds = RRD.find_all
		matched_rrds = filter_rrds all_rrds, params[:host], params[:plugin], params[:type], params[:ds]
		@start = params[:start] || '-3600'
		@end = params[:end] || '-0'
		@cons = params[:cons] || 'AVERAGE'
		@auto_scale = params[:auto_scale] == 'checked'
		rrds = ""
		matched_rrds.each_index do |index|
			rrd = matched_rrds[index]
			graph = "LINE" # index == 0 ? "AREA" : "STACK"
			rrds = rrds + "DEF:metric#{index}='/dist/collectd/var/lib/collectd/#{rrd.host}/#{rrd.plugin}/#{rrd.type}.rrd':#{rrd.data_source}:#{@cons} #{graph}:metric#{index}#{graph_index_color(index)}:'#{rrd.host}/#{rrd.plugin}/#{rrd.type}/#{rrd.data_source}' "
		end
		rrdtool_proc = IO.popen("
			/usr/bin/rrdtool graph - \
			--imgformat=PNG \
			--start=#{@start} \
			--end=#{@end} \
			--rigid \
			--height=120 \
			--width=1024 \
			--alt-autoscale-max \
                        #{@auto_scale ? '--alt-autoscale --alt-y-grid' : '-lower-limit=0'} \
			--watermark='DotSpots, Inc.' \
			#{rrds}
		");
		response.headers['Content-Type'] = 'image/png'
		send_data(rrdtool_proc.read, :filename => "graph.png", :type => 'image/png', :disposition => 'inline')
		rrdtool_proc.close
	end

end
