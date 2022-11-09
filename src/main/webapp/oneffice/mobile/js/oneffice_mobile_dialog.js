/* 
 *	oneffice_mobile_dialog.js :: Oneffice Mobile Dialog
 *
 *	
 *
 */

var mobile_Dialog = new function() {
	
	function initMobileDialog() {
		return {		// define public value, method
		// public value
			DIALOG_TYPE: {
				INPUT_TEXT:			1,
				CONFIRM:			2,
				ALERT:				3
				
				// custom dialog type maybe..
			},
			
			
		// public method
			showDialog: function(nDialogType, strMessage, strTitle, arrButtonInfo) {
				try {
					createDialogContents(nDialogType, strMessage, strTitle, arrButtonInfo);
					
					$("div.pop_layer_wrap").show();
					
					if (nDialogType === this.DIALOG_TYPE.INPUT_TEXT) {
						$("#dlg_text_input").focus().select();
					}
				} catch (e) {
					dalert(e);
				}
			},
			
			hideDialog: function() {
				try {
					$("div.pop_layer_wrap").hide();
				} catch (e) {
					dalert(e);
				}
			},
			
			isShow: function() {
				try {
					return ($("#mainContainer .pop_layer_wrap").css("display") !== "none");
				} catch (e) {
					dalert(e);
				}
			}
		};
	}
	
	return {
		getInstance: function() {
			if (fnObjectCheckNull(_instance) === true) {
				_instance = initMobileDialog();
			}
			
			return _instance;
		}
	};
	
	
// define private value, method
	
// private value
	var _instance;
	
	
// private method
	function createDialogContents(nDialogType, strMessage, strTitle, arrButtonInfo) {
		try {
			$("div.pop_layer").removeClass("change_layer alert_layer");
			
			var DIALOG = mobileDlg.DIALOG_TYPE;
			
			switch (nDialogType) {
				case DIALOG.INPUT_TEXT:
					dialog_textInput(strTitle, strMessage);
					
					break;
					
				case DIALOG.CONFIRM:
					dialog_confirm(strTitle, strMessage);
					
					break;
					
				case DIALOG.ALERT:
					dialog_alert(strMessage);
					
					if (fnObjectCheckNull(arrButtonInfo) === true) {
						arrButtonInfo = [
							{
								name: "확인",
								func: function() {
									mobileDlg.hideDialog();
								}
							}
						];
					}
					
					break;
			}
			
			createButtons(arrButtonInfo);
		} catch (e) {
			dalert(e);
		}
	}
	
	function createButtons(arrBtnInfo) {
		/*
		 * param
		 *	arrBtnInfo: {
		 *		name:
		 *		func:
		 *	}
		 */
		try {
			var objContents = $("div.pl_foot").empty();
			
			if (fnObjectCheckNull(arrBtnInfo) === true) {
				// 버튼 정보가 없으면 버튼 영역 보이지 않도록 처리
				objContents.hide();
				
				return;
			}
			
			var objButtonContainer = document.createElement("ul");
			var objButtonFrame;
			var objButton;
			var objButtonInfo;
			
			objContents.append(objButtonContainer);
			
			switch (arrBtnInfo.length) {
				case 1:		objButtonContainer.className = "btn1";	break;
				case 2:		objButtonContainer.className = "btn2";	break;
				case 3:		objButtonContainer.className = "btn3";	break;
			}
			
			for (var index = 0; index < arrBtnInfo.length; index++) {
				objButtonInfo = arrBtnInfo[index];
				
				objButtonFrame = document.createElement("li");
				objButton = document.createElement("a");
				
				objButtonContainer.appendChild(objButtonFrame);
				objButtonFrame.appendChild(objButton);
				
				$(objButton).addClass("ui-link").text(objButtonInfo.name).click(objButtonInfo.func);
			}
		} catch (e) {
			dalert(e);
		}
	}
	
	function dialog_textInput(strTitle, strDefaultText) {
		try {
			$("div.pop_layer").addClass("change_layer");
			
			var objContents = $("div.pl_con").empty();
			
			var objTitle = document.createElement("div");
			var objInput = document.createElement("input");
			
			objContents.append(objTitle);
			objContents.append(objInput);
			
			objTitle.className = "tit";
			objTitle.textContent = strTitle;
			
			objInput.type = "search";
			objInput.id = "dlg_text_input";
			
			$(objInput).val(strDefaultText);
//			$(objInput).textinput({	clearBtn: true, preventFocusZoom: false});
		} catch (e) {
			dalert(e);
		}
	}
	
	function dialog_confirm(strTitle, strMessage) {
		try {
			$("div.pop_layer").addClass("alert_layer");
			
			var objContents = $("div.pl_con").empty();
			
			var objTitle = document.createElement("div");
			var objMessage = document.createElement("p");
			
			objContents.append(objTitle);
			objContents.append(objMessage);
			
			objTitle.className = "tit";
			objTitle.textContent = strTitle;
			
			objMessage.className = "txt";
			objMessage.innerHTML = strMessage;
		} catch (e) {
			dalert(e);
		}
	}
	
	function dialog_alert(strMessage) {
		try {
			$("div.pop_layer").addClass("alert_layer");
			
			var objContents = $("div.pl_con").empty();
			
			var objTitle = document.createElement("div");
			var objMessage = document.createElement("p");
			
			objContents.append(objTitle);
			objContents.append(objMessage);
			
			objTitle.className = "ico_alert";
			
			objMessage.className = "txt";
			objMessage.innerHTML = strMessage;
		} catch (e) {
			dalert(e);
		}
	}
};

var mobileDlg = mobile_Dialog.getInstance();