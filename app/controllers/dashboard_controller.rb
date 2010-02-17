class DashboardController < ApplicationController

	layout 'default', :except => [ :add_prompt ]

	def add_graph
		host = params[:host]
		plugin = params[:plugin]
		type = params[:type]
		data_source = params[:ds]
		if params[:id].to_i == -1
			dashboard = Dashboard.new
			dashboard.query = [ host, plugin, type, data_source ] * " " 
			dashboard.group = 'Ungrouped'
			dashboard.name = params[:name]
			dashboard.grp = params[:grp]
			dashboard.save
		else
			dashboard = Dashboard.find params[:id]
			dashboard.query = dashboard.query + "\n" + [ host, plugin, type, data_source ] * " " 
			dashboard.save
		end
		redirect_to :controller => :dashboard, :action => :view, :id => dashboard.id
	end

	def add_prompt
		@host = params[:host]
		@plugin = params[:plugin]
		@type = params[:type]
		@data_source = params[:ds]
		@dashboards = Dashboard.find :all
	end

	def view
		@dashboard = Dashboard.find params[:id]
		@start = params[:start] || '-3600' 
		@end = params[:end] || '-0'
		@cons = params[:cons] || 'AVERAGE'
		@auto_scale = params[:auto_scale]
	end

	def save
		if params[:commit] == 'Delete'
			Dashboard.delete params[:id]
			redirect_to :controller => :dashboard, :action => :index
		else
			@dashboard = Dashboard.find(params[:id])
			@dashboard.query = params[:dashboard][:query]
			@dashboard.update_attributes! params[:dashboard]
			redirect_to :controller => :dashboard, :action => :view, :id => @dashboard.id, :timestamp => rand()
		end
	end

	def index
		@dashboards = Dashboard.find :all
		@dashboard_groups = {}
		@dashboards.each do |dashboard|
			@dashboard_groups[dashboard.group] ||= []
			@dashboard_groups[dashboard.group] << dashboard
		end
	end

end
