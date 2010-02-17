e = encodeURIComponent;

function Alarms() {

}

e = encodeURIComponent;

Alarms.prototype.onKeyup = function(event) {
	var host = $("input[name=host]").val();
	var plugin = $("input[name=plugin]").val();
	var type = $("input[name=type]").val();
	var dataSource = $("input[name=ds]").val();
	$("a.thickbox.alarm").attr("href", "/alarms/add_alarm?host="+e(host)+"&plugin="+e(plugin)+"&type="+e(type)+"&data_source="+e(dataSource));
}

Alarms.prototype.addAlarm = function(id, host, plugin, type, dataSource, warningRange, warningDurationThreshold, criticalRange, criticalDurationThreshold, messageFormat, action, disabled) {
	document.location = "/alarms/save_alarm?alarm[id]="+id+"&alarm[host]="+e(host)+"&alarm[plugin]="+e(plugin)+"&alarm[type]="+e(type)+"&alarm[data_source]="+e(dataSource)+"&alarm[warning_range]="+e(warningRange)+"&alarm[critical_range]="+e(criticalRange)+"&alarm[message_format]="+e(messageFormat)+"&alarm[action]="+e(action)+"&alarm[disabled]="+e(disabled)+"&alarm[warning_duration_threshold]="+e(warningDurationThreshold)+"&alarm[critical_duration_threshold]="+e(criticalDurationThreshold);
}

Alarms.prototype.init = function() {
	var self = this;
	$("input[name=host]").keyup(function(event) { self.onKeyup(event); } );
	$("input[name=plugin]").keyup(function(event) { self.onKeyup(event); } );
	$("input[name=type]").keyup(function(event) { self.onKeyup(event); } );
	$("input[name=ds]").keyup(function(event) { self.onKeyup(event); } );

	$("#ajaxMessage").ajaxStart(function(){
		$(this).html('<br/>Exploring... <img src="/images/spinner.gif"/>');
	});

	$("#ajaxMessage").ajaxStop(function(){
		$(this).html("&nbsp;");
	});

	this.onKeyup();
}

