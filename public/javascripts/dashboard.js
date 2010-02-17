e = encodeURIComponent;

function Dashboard() {

}

Dashboard.prototype.addGraph = function(dashboardId, host, plugin, type, dataSource) {
	if ( -1 == dashboardId ) {
		var dashboardName = prompt("Enter name for new dashboard");
		var dashboardGroup = prompt("Enter group for new dashboard");
	} else {
	}
	document.location = "/dashboard/add_graph?id="+dashboardId+"&host="+host+"&plugin="+plugin+"&type="+type+"&ds="+dataSource+"&name="+e(dashboardName)+"&grp="+e(dashboardGroup);
}

Dashboard.prototype.init = function() {
}

