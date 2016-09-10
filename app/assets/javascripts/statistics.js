$(document).ready(function() {
	$.ajax({

		type : "GET",

		cache : false,

		url : "/game_power",

		dataType : "text",

		success : processData,

		error : errorAlert

	});

	function processData(data) {
		
		if ($("#flot-gp").length > 0) {
			var cdate = new Date();
			var oneWeekAgo = new Date();
			oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
			$.plot($("#flot-gp"), [{
				label : "Game Power",
				data : $.parseJSON(data),
				color : "#f36b6b"
			}], {
				xaxis : {
					min : oneWeekAgo.getTime(),
					max : cdate.getTime(),
					mode : "time",
					tickSize : [24, "hour"]
				},
				series : {
					lines : {
						show : true,
						fill : true
					},
					points : {
						show : true,
					}
				},
				grid : {
					hoverable : true,
					clickable : true
				},
				legend : {
					show : false
				}
			});

			$("#flot-gp").bind("plothover", function(event, pos, item) {
				if (item) {
					if (previousPoint != item.dataIndex) {
						previousPoint = item.dataIndex;

						$("#tooltip").remove();
						var y = item.datapoint[1].toFixed();

						showTooltip(item.pageX, item.pageY, item.series.label + " = " + y + " hits");
					}
				} else {
					$("#tooltip").remove();
					previousPoint = null;
				}
			});
		}
	}

	function errorAlert(data) {

	}
});

$(document).ready(function() {
$.ajax({

		type : "GET",

		cache : false,

		url : "/magnetic_power",

		dataType : "text",

		success : processMagneticData,

		error : errorMagenticAlert

	});

	function processMagneticData(data) {
		
		if ($("#flot-mp").length > 0) {
			var cdate = new Date();
			var oneWeekAgo = new Date();
			oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
			$.plot($("#flot-mp"), [{
				label : "Magentic Power",
				data : $.parseJSON(data),
				color : "#3a8ce5"
			}], {
				xaxis : {
					min : oneWeekAgo.getTime(),
					max : cdate.getTime(),
					mode : "time",
					tickSize : [24, "hour"]
				},
				series : {
					lines : {
						show : true,
						fill : true
					},
					points : {
						show : true,
					}
				},
				grid : {
					hoverable : true,
					clickable : true
				},
				legend : {
					show : false
				}
			});

			$("#flot-mp").bind("plothover", function(event, pos, item) {
				if (item) {
					if (previousPoint != item.dataIndex) {
						previousPoint = item.dataIndex;

						$("#tooltip").remove();
						var y = item.datapoint[1].toFixed();

						showTooltip(item.pageX, item.pageY, item.series.label + " = " + y + " hits");
					}
				} else {
					$("#tooltip").remove();
					previousPoint = null;
				}
			});
		}
	}

	function errorMagenticAlert(data) {

	}
});