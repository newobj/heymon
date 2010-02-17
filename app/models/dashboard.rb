class Dashboard < ActiveRecord::Base
	def group
		grp
	end
	def group= g
		self["grp"] = g
	end
	def each_graph_url
		query.split("\n").each do |line|
			host,plugin,type,data_source = line.split(" ").collect { |token| CGI::escape(token) }
			next if !host or host == '' or !plugin or plugin == '' or !type or type == '' or !data_source or data_source == ''
			yield "/graph?host=#{host}&plugin=#{plugin}&type=#{type}&ds=#{data_source}&timestamp="
		end
	end
end
