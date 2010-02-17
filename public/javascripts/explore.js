e = encodeURIComponent;

function Explore() {

}

Explore.prototype.onJSON = function(json) {
	var fields = [
		[ 'hosts', 'host' ],
		[ 'plugins', 'plugin' ],
		[ 'types', 'type' ],
		[ 'dataSources', 'ds' ],
	];
	for ( var fieldIdx in fields ) {
		var html = "";
		for ( var termIdx in json[fields[fieldIdx][0]] ) {
			var term = json[fields[fieldIdx][0]][termIdx];
			if ( term.matched )
				html += '<div style="font-weight: bold"><a href="javascript:explore.addTerm(\''+fields[fieldIdx][1]+'\', \''+term.value+'\');alarms.onKeyup();"">'+term.value+'</a></div>';
			else if ( term.valid )
				html += '<div><a href="javascript:explore.addTerm(\''+fields[fieldIdx][1]+'\', \''+term.value+'\');alarms.onKeyup();"">'+term.value+'</a></div>';
			else
				html += '<div style="color: grey">'+term.value+'</div>';
		}
		$("#"+fields[fieldIdx][0]).html(html);
	}
	$('#explore_matches').html(json.matches);
}

Explore.prototype.refreshGraph = function() {
	var host = e($("input[name=host]").val());
	var plugin = e($("input[name=plugin]").val());
	var type = e($("input[name=type]").val());
	var dataSource = e($("input[name=ds]").val());
	$("#explore_graph").attr("src", "/images/spinner.gif")
	$("#explore_graph").attr("src", "/graph?host="+host+"&auto_scale=checked&plugin="+plugin+"&type="+type+"&ds="+dataSource+"&timestamp="+Math.random());
}

Explore.prototype.addTerm = function(id, term) {
	var terms = $("input[name="+id+"]").val();
	if ( terms == '' || terms == '.*' ) 
		terms = term;
	else
		terms += "|"+term;
	$("input[name="+id+"]").val(terms);
	this.onKeyup();
}

Explore.prototype.setTerm = function(id, term) {
	$("input[name="+id+"]").val(term);
	this.onKeyup();
}

Explore.prototype.onKeyup = function(event) {
	var host = $("input[name=host]").val();
	var plugin = $("input[name=plugin]").val();
	var type = $("input[name=type]").val();
	var dataSource = $("input[name=ds]").val();
	var self = this;
	$.getJSON("/explore/json", { host: host, plugin: plugin, type: type, ds: dataSource }, function(json) { self.onJSON(json); });
	$("a.thickbox.dashboard").attr("href", "/dashboard/add_prompt?height=240&width=500&host="+e(host)+"&plugin="+e(plugin)+"&type="+e(type)+"&ds="+e(dataSource));
}

Explore.prototype.init = function() {
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

