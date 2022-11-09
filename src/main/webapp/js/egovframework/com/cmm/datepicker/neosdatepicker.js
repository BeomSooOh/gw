	    var neosdatepicker = {};
	    neosdatepicker.datepicker = function(id, pickerOpts){
	        var _opt =  pickerOpts || {};
	        $("#" + id).datepicker(_opt);
	        $("#ui-datepicker-div").hide().css("zIndex", "999999");
	    };
	    neosdatepicker.datepicker2 = function(selector, pickerOpts){
	        var _opt =  pickerOpts || {};
	        $(selector).datepicker(_opt);
	        $("#ui-datepicker-div").hide().css("zIndex", "999999");
	    };
	    neosdatepicker.datepicker3 = function(jqueryObj, pickerOpts){
	        var _opt =  pickerOpts || {};
	        jqueryObj.datepicker(_opt);
	        $("#ui-datepicker-div").hide().css("zIndex", "999999");
	    };	    