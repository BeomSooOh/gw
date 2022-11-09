/*
 * 
 */

var settingMgr = {
	objBodyScroll: null,
	
	init: function() {
		if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
			$("#one_custom_page").width("").height("");
		}
		
		$("#one_custom_page header .right_div").hide();
		
		var objSetting = $("#id_setting");
		
		objSetting.height("calc(100% - 56px)");
		
		
		objSetting.find("#account_info").text($("#mainContainer").scope().myInfo.login_id);
		objSetting.find("#version_info").text(objOnefficeLoader.getVer());
		
		var objTimer = objSetting.find("li.autoSave_sub");
		objTimer.removeClass("selected");
		
		if (oneffice.autoSave === false) {
			objSetting.find("li.autoSave .toggleBG").attr("style", "background:#fff; border:1px solid #e5e5e5;");
			objSetting.find("li.autoSave .toggleFG").css("left", "0px");
			
			objTimer.hide();
		} else {
			objTimer.show();
			
			if (oneffice.autoSaveTime === 60) {
				objTimer.eq(0).addClass("selected");
			} else {
				objTimer.eq(1).addClass("selected");
			}
		}
		
		
		this.objBodyScroll = new iScroll('id_setting', {"hScroll":false, "vScroll":true, "vScrollbar":false, "mousewheel":false});
		
		this.addListener();
		
		setTimeout(function() {
			settingMgr.objBodyScroll.refresh();
		}, 300);
	},
	
	addListener: function() {
		try {
			// 자동저장
			var objTimer = $("#id_setting li.autoSave_sub");
			
			$("#id_setting .autoSave").click(function() {
				oneffice.autoSave = !oneffice.autoSave;
				
				objTimer.removeClass("selected");
				
				if (oneffice.autoSave === true) {
					oneffice.autoSaveTime = 300;
					objTimer.eq(1).addClass("selected");
					
					objTimer.eq(1).slideDown("fast");
					
					setTimeout(function() {
						objTimer.eq(0).slideDown("fast");
					}, 50);
				} else {
					objTimer.eq(0).slideUp("fast");
					
					setTimeout(function() {
						objTimer.eq(1).slideUp("fast");
					}, 50);
				}
			});
			
			objTimer.click(function() {
				objTimer.removeClass("selected");
				
				var objTarget = $(this);
				
				objTarget.addClass("selected");
				
				if (objTarget[0] === objTimer[0]) {
					oneffice.autoSaveTime = 60;
				} else {
					oneffice.autoSaveTime = 300;
				}
			});
			
			// 로그아웃
			$("#id_setting .logout").touchstart(function() {
				$(this).find(".right img").attr("src", "../mobile/images/btn/btn-arrow-sele.png");
			}).touchend(function() {
				$(this).find(".right img").attr("src", "../mobile/images/btn/btn-arrow-none.png");
			}).click(function() {
				var arrButtonInfo = [
					{
						name: "아니오",
						func: function() {
							mobileDlg.hideDialog();
						}
					},
					{
						name: "예",
						func: function() {
							NextS.exitLogin();
							mobileDlg.hideDialog();
						}
					}
				];
				
				mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.CONFIRM, '로그아웃 하시겠습니까?', '알림', arrButtonInfo);
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	cancel: function() {
		try {
			if (mobileDlg.isShow() === true) {
				return false;
			}
			
			NextS.setValue({key: "userEnv", val: JSON.stringify({autoSave: oneffice.autoSave, timer: oneffice.autoSaveTime, viewMode:oneffice.bDocViewMode, sortInfo:oneffice.sortInfo})});
			
			return true;
		} catch (e) {
			dalert(e);
		}

	}
};