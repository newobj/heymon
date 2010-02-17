module ExploreHelper
	def state_json_helper matched, valid, value
		if matched.include? value 
			return '"matched": true'
		elsif valid.include? value 
			return '"valid": true'
		else
			return ""
		end
	end
end
