# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

	helper :all # include all helpers, all the time

	before_filter :reload_routes

	def reload_routes
		ActionController::Routing::Routes.reload if ENV['RAILS_ENV'] == 'development'
	end

	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	protect_from_forgery # :secret => '75b141a54eb6a283ddb8f322067b9629'
  
	# See ActionController::Base for details 
	# Uncomment this to filter the contents of submitted sensitive data parameters
	# from your application log (in this case, all fields with names like "password"). 
	# filter_parameter_logging :password

	def filter_rrds rrds, host_regex, plugin_regex, type_regex, data_source_regex
		rrds.reject do |rrd|
			(host_regex and !rrd.host.match("^(#{host_regex})$")) or
			(plugin_regex and !rrd.plugin.match("^(#{plugin_regex})$")) or
			(type_regex and !rrd.type.match("^(#{type_regex})$")) or
			(data_source_regex and !rrd.data_source.match("^(#{data_source_regex})$"))
		end
	end

end
