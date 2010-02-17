class AlarmsController < ApplicationController

	layout 'default', :except => [ :json, :add_alarm, :edit_alarm ]

	def index
	    @alarms = Alarm.find :all, :order => [ 'plugin, type, data_source, host' ]
	end
	
	def defs
		@alarm_defs = AlarmDef.find :all, :order => ['host, plugin, type, data_source']
	end
	
	def edit_alarm
		@alarm_def = AlarmDef.find params[:id]
		render :template => 'alarms/add_edit_alarm'
	end
	
	def save_alarm
		if params[:alarm][:id].to_i == -1 
			alarm_def = AlarmDef.new(params[:alarm])
			alarm_def.save!
		else
			@alarm_def = AlarmDef.find params[:alarm][:id]
			@alarm_def.update_attributes!(params[:alarm])		
		end
		redirect_to '/alarms/defs' 
	end	

	def add_alarm
		@alarm_def = AlarmDef.new
		@alarm_def.id = -1
		@alarm_def.host = params[:host]
		@alarm_def.plugin = params[:plugin]
		@alarm_def.type = params[:type]
		@alarm_def.data_source = params[:data_source]
		render :template => 'alarms/add_edit_alarm'
	end

end
