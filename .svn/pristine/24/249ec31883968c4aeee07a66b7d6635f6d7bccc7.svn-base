/*
 * 
 */

onefficeApp.controller("ctrl_custom", function($scope) {
	
	$scope.$on("initCustomPage", function(event) {
		$scope.initPage();
	});
	
	$scope.initCustom = function() {
		var objCustom = $("#one_custom_page");
			
		objCustom.trigger("create");
		objCustom.addClass("ui-page ui-page-theme-a").css({background: "#fff", "z-index": 101});
		
		var objSection = objCustom.find("section");
		objSection.height("calc(100% - " + (56 + parseInt(objSection.css("padding-top"), 10) + parseInt(objSection.css("padding-bottom"), 10)) + "px)");
		
		$scope.initPage();
		
		$scope.$parent.viewChange(4);
	};
	
	$scope.initPage = function() {
		try {
			$("div.dialog_layer_wrap").show();
			var objTitle = $("#one_custom_page header h1");
			
			switch ($scope.$parent.strPageType) {
				case "setting":
					objTitle.text("설정");
					
					dynamicScriptCall("./mobile/js/const/fn_setting.js", function() {
						createCustomPage(settingHTML);
					});
					
					break;
					
				case "table":
					objTitle.text("표 삽입");
					
					dynamicScriptCall("./mobile/js/const/fn_insert_table.js", function() {
						createCustomPage(insertTableHTML);
					});
					
					break;
					
				case "layout":
					objTitle.text("레이아웃 템플릿");
					
					dynamicScriptCall("./mobile/js/const/fn_insert_layout.js", function() {
						createCustomPage(insertLayoutHTML);
					});
					
					break;
					
				case "sendReport":
					objTitle.text("업무보고 보내기");
					
//					$("#custom_content").load("./mobile/fn_send_report.html", function() {
//						sendReportMgr.init();
//					});
					
					dynamicScriptCall("./mobile/js/const/fn_send_report.js", function() {
						createCustomPage(sendReportHTML);
					});
					
					break;
					
				case "getReport":
					objTitle.text("업무보고 가져오기");
					
					dynamicScriptCall("./mobile/js/const/fn_get_report.js", function() {
						createCustomPage(getReportHTML);
					});
					
					break;
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var createCustomPage = function(strHTML) {
		try {
			var objPage = $(strHTML);
			
			if (objPage.length !== 0) {
				objPage.appendTo($("#custom_content"));
			}
			
			setTimeout(function() {
				switch ($scope.$parent.strPageType) {
					case "setting":			settingMgr.init();			break;
					case "table":			insertTableMgr.init();		break;
					case "layout":			insertLayoutMgr.init();		break;
					case "sendReport":		sendReportMgr.init();		break;
					case "getReport":		getReportMgr.init();		break;
				}
			}, 100);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.moveBack = function() {
		try {
			switch ($scope.$parent.strPageType) {
				case "setting":
				case "table":
				case "layout":
				case "sendReport":
				case "getReport":
					$scope.cancel();
					
					break;
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.cancel = function() {
		try {
			var bGoBack = true;
			
			switch ($scope.$parent.strPageType) {
				case "setting":		bGoBack = settingMgr.cancel();		break;
				case "getReport":	bGoBack = getReportMgr.cancel();	break;
			}
			
			if (bGoBack === true) {
				if ($scope.$parent.bOnViewStatus == true) {
					$scope.$parent.viewChange(3);
				} else {
					$scope.$parent.viewChange(0);
				}
				
				$("div.dialog_layer_wrap").hide();
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.confirm = function() {
		try {
			var bGoBack = true;
			
			switch ($scope.$parent.strPageType) {
				case "table":		insertTableMgr.confirm();				break;
				case "layout":		bGoBack = insertLayoutMgr.confirm();	break;
				case "getReport":	bGoBack = getReportMgr.confirm();		break;
				case "sendReport":
					bGoBack = false;
					
					sendReportMgr.confirm(function(bResult) {
						if (bResult === true) {
							$scope.$parent.viewChange(3);
							$("div.dialog_layer_wrap").hide();
						}
					});
					
					break;
			}
			
			if (bGoBack === true) {
				$scope.$parent.viewChange(3);
				$("div.dialog_layer_wrap").hide();
			}
		} catch (e) {
			dalert(e);
		}
	};
});
