class Alarm < ActiveRecord::Base
	set_inheritance_column '_class'
	belongs_to :alarm_def, :foreign_key => :def_id
      
	def update_severity sev
		if false
			# noop
		elsif self.severity == 'OKAY' and sev == 'CRITICAL'
			self.entered_critical_at ||= Time.now
		elsif self.severity == 'OKAY' and sev == 'WARNING'
			self.entered_warning_at ||= Time.now
		elsif self.severity == 'OKAY' and sev == 'OKAY'
			self.entered_critical_at = nil
			self.entered_warning_at = nil
		elsif self.severity == 'CRITICAL' and sev == 'CRITICAL'
			# noop
		elsif self.severity == 'CRITICAL' and sev == 'WARNING'
			self.entered_critical_at = nil
			self.entered_warning_at ||= Time.now
		elsif self.severity == 'CRITICAL' and sev == 'OKAY'
			self.entered_critical_at = nil
			self.entered_warning_at = nil
		elsif self.severity == 'WARNING' and sev == 'CRITICAL'
			self.entered_critical_at ||= Time.now
		elsif self.severity == 'WARNING' and sev == 'WARNING'
			# noop
		elsif self.severity == 'WARNING' and sev == 'OKAY'
			self.entered_critical_at = nil
			self.entered_warning_at = nil
		end
		if entered_critical_at && time_to_critical <= 0
			self.severity = 'CRITICAL'
		elsif entered_warning_at && time_to_warning <= 0
			self.severity = 'WARNING'
		else
			self.severity = 'OKAY' 
		end
	end
	
	def time_to_critical 
		return alarm_def.critical_duration_threshold - (Time.now - entered_critical_at)
	end
	
	def time_to_warning 
		return alarm_def.warning_duration_threshold - (Time.now - entered_warning_at)
	end
      
	def alarm_trend
		return '&nbsp;' if severity != 'OKAY' 
     	msg = '&nbsp;'
     	msg = "<span style='padding: 2px; background-color: red'>CRITICAL</span> in #{time_to_critical.to_i}s" if entered_critical_at
     	msg = "<span style='padding: 2px; background-color: yellow'>WARNING</span> in #{time_to_warning.to_i}s" if entered_warning_at
		return msg
     end
end
