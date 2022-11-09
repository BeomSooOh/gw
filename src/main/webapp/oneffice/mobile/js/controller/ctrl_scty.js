/*
 * 
 */

onefficeApp.controller("ctrl_scty", function($scope) {
	
	var objCurrentPW;
	var objNewPW;
	var objConfirmPW;
	
	$scope.nSettingType = 1;		// 0: 암호 해제, 1: 암호 설정, 2: 암호 변경
	
	$scope.$on("initSctyValue", function(event) {
	
		$scope.initValues();
	});
	
	
	$scope.initScty = function() {
    	try {
			var objScty = $("#one_scty");
			
			objScty.trigger("create");
			objScty.addClass("ui-page ui-page-theme-a").css({background: "#fff", "z-index": 101});
			
			var objSection = objScty.find("section");
			objSection.height("calc(100% - " + (56 + parseInt(objSection.css("padding-top"), 10) + parseInt(objSection.css("padding-bottom"), 10)) + "px)");
			
			var objInputBox = objScty.find("input[type='password']");
			objInputBox.width("calc(100% - " + (parseInt(objInputBox.css("padding-left"), 10) + parseInt(objInputBox.css("padding-right"), 10)) + "px)");
			
			objCurrentPW = objScty.find("div.current");
			objNewPW = objScty.find("div.new");
			objConfirmPW = objScty.find("div.confirm");
			
			addListener();
			$scope.initValues(true);
			$scope.$parent.viewChange(1);
    	} catch (e) {
    		dalert(e);
    	}
	};
	
	$scope.initValues = function(bFirst) {
		try {
			$("div.dialog_layer_wrap").show();
			if (fnObjectCheckNull($scope.$parent.objCurrentDoc) === false
					&& $scope.$parent.objCurrentDoc.docData.bSecurity === 1) {
				
				$(".passwordCon .check").show();
				objCurrentPW.show();
				objNewPW.find(".tit").text("새 암호");
				objConfirmPW.find(".tit").text("새 암호 확인");
				
				$scope.setType(2);
			} else {
				$scope.setType(1);
			}
			
			// 기존 텍스트 제거
			objCurrentPW.find("input").val("");
			objNewPW.find("input").val("");
			objConfirmPW.find("input").val("");
			
			setTimeout(function() {
				// 암호 설정 페이지 로드 후 바로 포커스 설정이 되지 않아서 timeout 처리
				if ($scope.nSettingType === 1) {
					objNewPW.find("input").focus();
				} else {
					objCurrentPW.find("input").focus();
				}
			}, 100);
			
			if (bFirst !== true && $scope.$parent.bOnViewStatus == false) {
				updateView($scope);
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.moveBack = function() {
		try {
			if (mobileDlg.isShow() === true) {
				return;
			}
			
			$scope.cancelSetting();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.cancelSetting = function() {
		try {
			if($scope.$parent.bOnViewStatus == true)
				$scope.$parent.viewChange(3);
			else
			$scope.$parent.viewChange(0);
			$("div.dialog_layer_wrap").hide();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.setPassword = function() {
		try {
			if (checkPassword() === true) {
				var fnCallback = function(strDocSeq) {
					if (strDocSeq === $scope.$parent.objCurrentDoc.seq) {
						var strMessage;
						
						switch ($scope.nSettingType) {
							case 0:		strMessage = "문서 보안이 해제되었습니다.";			break;
							case 1:		strMessage = "문서 보안이 설정되었습니다.";			break;
							case 2:		strMessage = "문서 보안 설정이 변경되었습니다.";		break;
						}
						
						$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "bSecurity", ($scope.nSettingType === 0) ? 0 : 1);
						
						mobileToast.show(strMessage);
						$("div.dialog_layer_wrap").hide();
						$scope.$parent.viewChange(0);
					}
				};
				
				if ($scope.nSettingType === 1) {		// 암호 설정
					onefficeMGW.setSecurityPassword($scope.$parent.objCurrentDoc.seq, $scope.$parent.objCurrentDoc.parentFolderSeq, $scope.nSettingType, objNewPW.find("input").val(), null, fnCallback);
				} else {		// 암호 해제, 암호 변경
					var strPassword = objCurrentPW.find("input").val();
					var strNewPassword = objNewPW.find("input").val();
					
					onefficeMGW.getSecurityInfo($scope.$parent.objCurrentDoc.seq, strPassword, function(nStatus) {
						// 0 : 일반 문서 (securityKey 미전달)
						// 1 : 보안 문서 (securityKey 미전달)
						// 2 : 보안 문서면서 암호 일치
						// 3 : 보안 문서면서 암호 불일치
						
						if (nStatus * 1 === 2) {
							onefficeMGW.setSecurityPassword($scope.$parent.objCurrentDoc.seq, $scope.$parent.objCurrentDoc.parentFolderSeq, $scope.nSettingType, strPassword, strNewPassword, fnCallback);
						} else {
							mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, "현재 암호가 설정된 암호와<br/>일치하지 않습니다.");
							
							objCurrentPW.find("input").select().focus();
						}
					});
				}
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.setType = function(nType) {
		try {
			$scope.nSettingType = nType;		// 0: 암호 해제, 1: 암호 설정, 2: 암호 변경
			
			if (nType === 1) {
				$(".passwordCon .check").hide();		// 라디오 버튼 비활성화
				objCurrentPW.hide();					// 현재 암호 입력창 비활성화
				objNewPW.find(".tit").text("문서 암호");
				objConfirmPW.find(".tit").text("암호 확인");
				
				objConfirmPW.find("input").attr("disabled", true).val("");
				objConfirmPW.find(".ui-input-clear").addClass("ui-input-clear-hidden");
				
				objNewPW.find("input").attr("disabled", false).val("");
			} else {
				var objOn;
				var objOff;
				
				if (nType === 2) {
					objOn = $(".passwordCon .check label.ui-first-child");
					objOff = $(".passwordCon .check label.ui-last-child");
					
					objNewPW.find("input").attr("disabled", false);
				} else if (nType === 0) {
					objOn = $(".passwordCon .check label.ui-last-child");
					objOff = $(".passwordCon .check label.ui-first-child");
					
					objNewPW.find("input").attr("disabled", true).val("");
					objNewPW.find(".ui-input-clear").addClass("ui-input-clear-hidden");
				}
				
				objOn.removeClass("ui-radio-off").addClass("ui-radio-on");
				objOff.removeClass("ui-radio-on").addClass("ui-radio-off");
				
				objConfirmPW.find("input").attr("disabled", true).val("");
				objConfirmPW.find(".ui-input-clear").addClass("ui-input-clear-hidden");
				
				objCurrentPW.find("input").focus();
				
				$("#radio-choice-1").click(function(){
					$scope.setType(2);
				});
				$("#radio-choice-2").click(function(){
					$scope.setType(0);
				});
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var checkPassword = function() {
		try {
			// 서버로 넘기기 전 체크
			var bPass = true;
			var strMessage;
			
			var objNewBox = objNewPW.find("input");
			var objConfirmBox = objConfirmPW.find("input");
			var objFocusBox;
			
			switch ($scope.nSettingType) {
				case 1:		// 암호 설정
					if (objNewBox.val().length < 4) {
						strMessage = "암호는 4자 이상 20자 이하로<br/>입력 가능합니다.<br/>다시 입력해주시기 바랍니다.";
						objFocusBox = objNewBox;
						
						bPass = false;
					} else if (objNewBox.val() !== objConfirmBox.val()) {
						strMessage = "확인 암호가 설정된 암호와<br/>일치하지 않습니다.";
						objFocusBox = objConfirmBox;
						
						bPass = false;
					}
					
					break;
					
				case 2:		// 암호 변경
					var objCurrentBox = objCurrentPW.find("input");
					
					if (objCurrentBox.val().length < 4) {
						strMessage = "암호는 4자 이상 20자 이하로<br/>입력 가능합니다.<br/>다시 입력해주시기 바랍니다.";
						objFocusBox = objCurrentBox;
						
						bPass = false;
					} else if (objCurrentBox.val() === objNewBox.val()) {
						strMessage = "새 암호가 현재 암호와 동일합니다.";
						objFocusBox = objNewBox;
						
						bPass = false;
					} else if (objNewBox.val() !== objConfirmBox.val()) {
						strMessage = "확인 암호가 설정된 암호와<br/>일치하지 않습니다.";
						objFocusBox = objConfirmBox;
						
						bPass = false;
					}
					
					break;
			}
			
			if (bPass === false) {
				var arrButtonInfo = [
					{
						name: "확인",
						func: function() {
							mobileDlg.hideDialog();
							objFocusBox.select().focus();
						}
					}
				];
				
				mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, strMessage, null, arrButtonInfo);
			}
			
			return bPass;
		} catch (e) {
			dalert(e);
		}
	};
	
	var addListener = function() {
		try {
			$(".password_input input").keydown(function(event) {
				switch (event.keyCode) {
					case 8:		// ID_KEYCODE_BACKSPACE
					case 46:	// ID_KEYCODE_DELETE
					case 37:	// ID_KEYCODE_ARROW_LEFT
					case 38:	// ID_KEYCODE_ARROW_RIGHT
					case 39:	// ID_KEYCODE_ARROW_TOP
					case 40:	// ID_KEYCODE_ARROW_BOTTOM
					case 9:		// ID_KEYCODE_TAB
					case 32:	// ID_KEYCODE_SPACE
					case 13:	// ID_KEYCODE_ENTER
					case 35:	// ID_KEYCODE_END
					case 36:	// ID_KEYCODE_HOME
					case 16:	// ID_KEYCODE_SHIFT
					case 17:	// ID_KEYCODE_CTRL
					case 18:	// ID_KEYCODE_ALT
						
						break;
						
					default:
						if (this.value.length >= 20) {
							event.preventDefault();
						}
						
						break;
				}
			});
			
			
			objNewPW.find("input").on("keypress keyup", function(event) {
				var objConfirmBox = objConfirmPW.find("input");
				
				if (event.keyCode === 13) {		// ID_KEYCODE_ENTER
					if (objConfirmBox.attr("disabled") !== true) {
						objConfirmBox.focus();
						
						event.preventDefault();
					}
				} else {
					if (this.value.length >= 4) {
						objConfirmBox.attr("disabled", false);
						
						if (objConfirmBox.val().length > 0) {
							objConfirmPW.find(".ui-input-clear").removeClass("ui-input-clear-hidden");
						}
					} else {
						objConfirmBox.attr("disabled", true);
						objConfirmPW.find(".ui-input-clear").addClass("ui-input-clear-hidden");
					}
				}
			});
		} catch (e) {
			dalert(e);
		}
	};
});
