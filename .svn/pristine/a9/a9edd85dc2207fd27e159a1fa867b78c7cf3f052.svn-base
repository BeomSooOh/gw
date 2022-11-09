/*
 * 
 */

onefficeApp.controller("ctrl_template", function($scope) {
	
	var objBodyScroll;
	
	$scope.$on("initTemplateValue", function(event) {
		$scope.initValues();
	});
	
	
	$scope.initTemplate = function() {
		try {
			var objTemplate = $("#one_template");
			
			objTemplate.trigger("create");
			objTemplate.addClass("ui-page ui-page-theme-a").css({background: "#fff", "z-index": 101});
			
			var objSection = objTemplate.find("section");
			var nBodyHeight = "calc(100% - 56px)";
			objSection.height(nBodyHeight);
			
			objBodyScroll = new iScroll('id_template_scroll', {"hScroll":false, "vScroll":true, "vScrollbar":false, "mousewheel":false});
			
			addListener();
			$scope.initValues(true);
			$scope.$parent.viewChange(6);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.initValues = function(bFirst) {
		try {
			$("div.dialog_layer_wrap").show();
			
			$("#id_template_grid .grid_item").removeClass("selected");
			
			setTimeout(function() {
				objBodyScroll.refresh();
			}, 300);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.moveBack = function() {
		try {
			$scope.cancel();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.cancel = function() {
		try {
			$scope.$parent.viewChange(0);
			$("div.dialog_layer_wrap").hide();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.confirm = function() {
		try {
			var objSelectedItem = $("#id_template_grid .grid_item.selected");
			
			if (objSelectedItem.length > 0) {
				var arrIndex = $("#id_template_grid .grid_item.selected").attr("temp_index").split("_");
				
				dynamicScriptCall("mobile/js/const/file_docform_const.js", function() {
					var objTemplateInfo = docformTemplateCategory[arrIndex[0] * 1].data[arrIndex[1] * 1];
					
					$("div.dialog_layer_wrap").hide();
					
					$('#one_home').scope().createTemplateFile(objTemplateInfo);
				});
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var addListener = function() {
		try {
			var objGridItem = $("#id_template_grid .grid_item");
			
			objGridItem.click(function() {
				var objItem = $(this);
				
				if (objItem.hasClass("selected") === true) {
					return;
				}
				
				objGridItem.removeClass("selected");
				objItem.addClass("selected");
			});
		} catch (e) {
			dalert(e);
		}
	};
});
