#require 'RRDtool'

class ExploreController < ApplicationController

	layout 'default', :except => [ :json ]

	def json
		all_rrds = RRD.find_all

		@matched_rrds =  filter_rrds all_rrds, params[:host], params[:plugin], params[:type], params[:ds]
		host_rrds = filter_rrds all_rrds, nil, params[:plugin], params[:type], params[:ds]
		plugin_rrds = filter_rrds all_rrds, params[:host], nil, params[:type], params[:ds]
		type_rrds = filter_rrds all_rrds, params[:host], params[:plugin], nil, params[:ds]
		data_source_rrds = filter_rrds all_rrds, params[:host], params[:plugin], params[:type], nil

		@matched_hosts = @matched_rrds.collect { |rrd| rrd.host }.uniq.sort
		@matched_plugins = @matched_rrds.collect { |rrd| rrd.plugin }.uniq.sort
		@matched_types = @matched_rrds.collect { |rrd| rrd.type }.uniq.sort
		@matched_data_sources = @matched_rrds.collect { |rrd| rrd.data_source }.uniq.sort

		@valid_hosts = host_rrds.collect { |rrd| rrd.host }.uniq.sort
		@valid_plugins = plugin_rrds.collect { |rrd| rrd.plugin }.uniq.sort
		@valid_types = type_rrds.collect { |rrd| rrd.type }.uniq.sort
		@valid_data_sources = data_source_rrds.collect { |rrd| rrd.data_source }.uniq.sort

		@all_hosts = all_rrds.collect { |rrd| rrd.host }.uniq.sort{ |h1,h2| h1.reverse <=> h2.reverse }
		@all_plugins = all_rrds.collect { |rrd| rrd.plugin }.uniq.sort
		@all_types = all_rrds.collect { |rrd| rrd.type }.uniq.sort
		@all_data_sources = all_rrds.collect { |rrd| rrd.data_source }.uniq.sort
	end

	def reload_rrds
		RRD.load_all_rrds
		redirect_to '/'
	end

	def index
	    @host = params[:host] || '.*'
	    @plugin = params[:plugin] || '.*'
	    @type = params[:type] || '.*'
	    @ds = params[:ds] || '.*'
	end

end
