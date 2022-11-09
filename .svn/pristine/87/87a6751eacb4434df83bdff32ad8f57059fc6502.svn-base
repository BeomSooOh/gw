/*
 * 
 */

var sendReportMgr = {
	
	bodyScroll: null,
	receiverScroll: null,
	ccScroll: null,
	
	init: function() {
		try {
			$("#one_custom_page header .btn_check").addClass("disabled");
			
			if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
				var strStyle = $("#one_custom_page").attr("style");
				strStyle += "width: 560px !important; height: 580px !important;";
				$("#one_custom_page").attr("style", strStyle);
			}
			
			var objHead = document.getElementsByTagName("head")[0];
			
			$(objHead).find("style.send_report_container").remove();
			
			var objStyle = document.createElement("style");
			var strFontSize = (dzeUiConfig.strCustomBodyFontSize.length > 0) ? dzeUiConfig.strCustomBodyFontSize : "11pt";
			
			var strHtml = "";
			strHtml += "#one_custom_page #id_report_content ";
			strHtml += ("{font-family: '[더존] 본문체 30'; font-size: " + strFontSize + "; font-weight: normal;}");
			
			strHtml += " #one_custom_page #id_report_content body, #one_custom_page #id_report_content td, #one_custom_page #id_report_content p ";
			strHtml += ("{font-family: '[더존] 본문체 30'; font-size: " + strFontSize + ";");
			
			if (fnObjectCheckNull(dzeUiConfig.strCustomBodyLineHeight) === false && dzeUiConfig.strCustomBodyLineHeight !== "") {
				strHtml += (" line-height: " + dzeUiConfig.strCustomBodyLineHeight + ";");
			}
			
			if (fnObjectCheckNull(dzeUiConfig.strCustomBodyLetterSpacing) === false && dzeUiConfig.strCustomBodyLetterSpacing !== "") {
				strHtml += (" letter-spacing:" + dzeUiConfig.strCustomBodyLetterSpacing + ";");
			}
			
			strHtml += "}";
			objStyle.className = "send_report_container";
			objStyle.innerHTML = strHtml;
			objHead.appendChild(objStyle);
			
			this.addListener();
			
			NextS.getValue("receiver_list", function(objResponse) {
				if (fnObjectCheckNull(objResponse) === true
						|| fnObjectCheckNull(objResponse.receiver_list) === true || objResponse.receiver_list.length === 0) {
					return;
				}
				
				var strJson = JSON.parse(objResponse.receiver_list);
				var objReceiver;
				
				if (typeof(strJson) === "string") {
					objReceiver = $.parseJSON(strJson);
				} else {
					objReceiver = strJson;
				}
				
				if (fnObjectCheckNull(objReceiver.recv) === true) {
					return;
				}
				
				var objUserBtn;
				
				// receiver
				objUserBtn = sendReportMgr.createUserBtn(objReceiver.recv);
				
				var objReceiverList = $("#id_report_receiver .receiver_list");
				
				if (fnObjectCheckNull(objUserBtn) === false) {
					objReceiverList.empty();
					objUserBtn.appendTo(objReceiverList);
				}
				
				sendReportMgr.refreshList(true);
				sendReportMgr.addClickListener(true);
				sendReportMgr.activateConfirmBtn();
				
				// cc
				if (fnObjectCheckNull(objReceiver.cc) === false) {
					var objCcList = $("#id_report_cc .cc_list");
					objCcList.empty();
					
					objReceiver.cc.forEach(function(objUser) {
						objUserBtn = sendReportMgr.createUserBtn(objUser);
						
						if (fnObjectCheckNull(objUserBtn) === false) {
							objUserBtn.appendTo(objCcList);
						}
					});
					
					sendReportMgr.refreshList(false);
					sendReportMgr.addClickListener(false);
				}
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	addListener: function() {
		try {
			this.initReportType();
			this.initReceiverList();
			this.initCcList();
			this.initDatePicker();
			this.initTitleBox();
			this.initReportContent();
		} catch (e) {
			dalert(e);
		}
	},
	
	initReportType: function() {
		try {
			var objLabels = $("#id_report_type label");
			
			objLabels.click(function() {
				setType(($(this).attr("for") === "radio_report_1") ? 0 : 1);
			});
			
			$("#id_report_type input").click(function() {
				setType(($(this).attr("id") === "radio_report_1") ? 0 : 1);
			});
			
			function setType(nType) {		// 0: 일일보고,		1: 수시보고
				var objBtn = objLabels.eq(nType);
				
				if (objBtn.hasClass("selected") === true) {
					return;
				}
				
				objLabels.removeClass("selected");
				objBtn.addClass("selected");
				
				if (nType === 1) {
					$("#id_report_title").show();
				} else {
					$("#id_report_title").hide();
				}
				
				sendReportMgr.activateConfirmBtn();
				
				sendReportMgr.bodyScroll.refresh();
			}
		} catch (e) {
			dalert(e);
		}
	},
	
	initReceiverList: function() {
		try {
			this.receiverScroll = new iScroll('id_receiver_scroll', {"hScroll":true, "hScrollbar":false, "vScroll":false, "mousewheel":false});
			
			var objReceiverList = $("#id_report_receiver .receiver_list");
			
			objReceiverList.css("position", "relative");
			
			
			// test code
//			var arrUser = [
//				{empSeq: "1234", name: "정지영"},
//			];
//			
//			var btn;
//			
//			arrUser.forEach(function(objUser) {
//				btn = sendReportMgr.createUserBtn(objUser);
//				
//				if (fnObjectCheckNull(btn) === false) {
//					btn.appendTo(objReceiverList);
//				}
//			});
//			
//			this.refreshList(true);
//			
//			this.addClickListener(true);
//			
//			this.activateConfirmBtn();
			
			
			$("#id_report_receiver .org_arrow").click(function() {
				NextS.selectOrg("single", "none", [], function(arrSelectedList) {
					if (arrSelectedList.length > 0) {
						$("#one_custom_page .modal").show();
						
						var objUserBtn = sendReportMgr.createUserBtn(arrSelectedList[0]);
						
						if (fnObjectCheckNull(objUserBtn) === false) {
							objReceiverList.empty();
							objUserBtn.appendTo(objReceiverList);
						}
						
						sendReportMgr.refreshList(true);
						
						sendReportMgr.addClickListener(true);
						
						sendReportMgr.activateConfirmBtn();
						
						$("#one_custom_page .modal").hide();
					}
				});
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	initCcList: function() {
		try {
			this.ccScroll = new iScroll('id_cc_scroll', {"hScroll":true, "hScrollbar":false, "vScroll":false, "mousewheel":false});
			
			var objCcList = $("#id_report_cc .cc_list");
			
			objCcList.css("position", "relative");
			
			
			// test code
//			var arrUser = [
//				{empSeq: "1234", name: "정지영"},
//				{empSeq: "1122", name: "이수길"},
//				{empSeq: "3456", name: "윤성준"},
//				{empSeq: "5643", name: "곽윤우"},
//				{empSeq: "9873", name: "배산하"}
//			];
//			
//			var btn;
//			
//			arrUser.forEach(function(objUser) {
//				btn = sendReportMgr.createUserBtn(objUser);
//				
//				if (fnObjectCheckNull(btn) === false) {
//					btn.appendTo(objCcList);
//				}
//			});
//			
//			this.refreshList(false);
//			
//			this.addClickListener(false);
			
			
			$("#id_report_cc .org_arrow").click(function() {
				NextS.selectOrg("multi", "none", [], function(arrSelectedList) {
					if (arrSelectedList.length > 0) {
						$("#one_custom_page .modal").show();
						
						var objUserBtn;
						
						arrSelectedList.forEach(function(objUser) {
							objUserBtn = sendReportMgr.createUserBtn(objUser);
							
							if (fnObjectCheckNull(objUserBtn) === false) {
								objUserBtn.appendTo(objCcList);
							}
						});
						
						sendReportMgr.refreshList(false);
						
						sendReportMgr.addClickListener(false);
						
						$("#one_custom_page .modal").hide();
					}
				});
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	createUserBtn: function(objUser) {
		try {
			var objBtn = $("<li>");
			var objName = $("<p>");
			
			objBtn.attr({
				compSeq: objUser.compSeq,
				empSeq: objUser.empSeq,
				empName: objUser.name
			});
			
			objName.text(objUser.name);
			
			objName.appendTo(objBtn);
			
			return objBtn;
		} catch (e) {
			dalert(e);
		}
	},
	
	addClickListener: function(bReceiver) {
		try {
			var objList = $("#id_report_receiver .receiver_list li, #id_report_cc .cc_list li");
			
			objList.off("click");
			
			objList.click(function() {
				if (checkDoubleClick() === false) {		// iscroll 중첩으로 인해 click 이벤트가 중복으로 들어오는 현상 예외처리
					var objBtn = $(this);
					
					if (objBtn.hasClass("selected") === true) {
						objBtn.remove();
						sendReportMgr.refreshList(bReceiver);
						sendReportMgr.activateConfirmBtn();
					} else {
						objList.removeClass("selected");
						objBtn.addClass("selected");
					}
				}
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	refreshList: function(bReceiver) {
		try {
			var objList = (bReceiver === true) ? $("#id_report_receiver .receiver_list") : $("#id_report_cc .cc_list");
			var nTotalWidth = 0;
			
			objList.children().each(function(index, item) {
				nTotalWidth += (item.offsetWidth + 4);
			});
			
			objList.width(nTotalWidth + 10);
			
			if (bReceiver === true) {
				sendReportMgr.receiverScroll.refresh();
			} else {
				sendReportMgr.ccScroll.refresh();
			}
		} catch (e) {
			dalert(e);
		}
	},
	
	initDatePicker: function() {
		try {
			dzeJ("#id_datepicker").datepicker({
				dateFormat: "yy-mm-dd",
				showOn: "button",
				buttonImage: "../mobile/images/btn/btn-arrow-none.png",
				buttonImageOnly: true,
				showMonthAfterYear: true,
				yearSuffix: "년",
				prevText: "",
				nextText: "",
				gotoCurrent: true,
				monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
				monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
				dayNames: ["일", "월", "화", "수", "목", "금", "토"],
				dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
				dayNamesShort: ["일", "월", "화", "수", "목", "금", "토"],
				beforeShow: function() {
					setTimeout(function() {
						var objDatePicker = $("#ui-datepicker-div");
						var objContainer = $("#id_report_date .option_right");
						
//						if (g_browserCHK.androidtablet === false && g_browserCHK.iPad === false) {
//							objDatePicker.width(objContainer.width());
//						}
						
						objDatePicker.css({
							top: objContainer.offset().top + objContainer.height() + 3,
							left: objContainer.offset().left + 10,
							visibility: "visible"
						});
					}, 100);
				},
				onClose: function() {
					$("#ui-datepicker-div").css("visibility", "hidden");
				}
			});
			
			dzeJ("#id_datepicker").datepicker("setDate", "today");
		} catch (e) {
			dalert(e);
		}
	},
	
	initTitleBox: function() {
		try {
			$("#id_report_title input").textinput({clearBtn: true}).keyup(function() {
				sendReportMgr.activateConfirmBtn();
			});
			
			$("#id_report_title .ui-input-text .ui-input-clear").click(function() {
				$("#one_custom_page header .btn_check").addClass("disabled");
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	initReportContent: function() {
		try {
			var strContent = getEditorHTMLCode(false, g_nActiveEditNumber, true, true);
			var objContainer = $("#id_report_content .content_container");
			
			$(strContent).appendTo(objContainer);
			
			var objDocProperty = objContainer.find("dze_doc_property");
			var arrPaperSize = objDocProperty.attr("papersize").split(",");
			var arrPaperMargin = objDocProperty.attr("printmargin").split(",");
			
			var nPaperInner = (arrPaperSize[0] * 1) - ((arrPaperMargin[1] * 1) + (arrPaperMargin[3] * 1));		// 문서 가로사이즈에서 좌,우 여백 빼줌
			nPaperInner = Math.ceil(g_objCommonUtil.convMMToPx(nPaperInner));
			
			var nNewWidth = ((g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) ? 528 : (window.width - 32));
			var nRatio = nNewWidth / nPaperInner;
			nNewWidth = nNewWidth / nRatio;
			var nNewHeight = objContainer.height() * nRatio;
			
			objContainer.css({
				width: nNewWidth,
				height: nNewHeight,
				transform: "scale(" + nRatio + ")",
				transformOrigin: "left top"
			});
			
			this.bodyScroll = new iScroll('id_send_report', {"hScroll": false, "vScrollbar": false, "vScroll": true, "mousewheel": false,
				onBeforeScrollStart: function(event) {
					if (event.target.nodeName !== "INPUT") {
						event.preventDefault();
					}
					
					var objTarget = $(event.target);
					
					if (objTarget.parents(".receiver_list li").length === 0 && objTarget.parents(".cc_list li").length === 0) {
						$("#id_report_receiver .receiver_list li, #id_report_cc .cc_list li").removeClass("selected");
					}
					
					if (objTarget.parents("#ui-datepicker-div").length === 0) {
						$("#ui-datepicker-div").hide();
					}
				}});
			
			this.bodyScroll.refresh();
		} catch (e) {
			dalert(e);
		}
	},
	
	confirm: function(fnCallback) {
		try {
			if ($("#one_custom_page .head .btn_check").hasClass("disabled") === true) {
				if ($("#id_report_receiver .receiver_list li").length === 0) {
					mobileToast.show("보고대상을 설정하세요", MOBILE_TOAST.INFO);
				} else if ($("#id_report_type label.selected").attr("for") === "radio_report_2" && $("#id_report_title input").val().length === 0) {
					mobileToast.show("제목을 입력하세요", MOBILE_TOAST.INFO);
				}
				
				fnCallback(false);
				
				return;
			}
			
			var strType = ($("#id_report_type label.selected").attr("for") === "radio_report_1") ? "1" : "2";
			
			var fnSave = function() {
				fnSendReport("A");
				mobileDlg.hideDialog();
			};
			
			var fnReport = function() {
				fnSendReport("B");
				mobileDlg.hideDialog();
			};
			
			function fnSendReport(strState) {
				try {
					var strDate = $("#id_report_date input").val().replace(/\-/g,'');
					var objReceiver = $("#id_report_receiver .receiver_list li");
						objReceiver = {compSeq: objReceiver.attr("compSeq"), empSeq: objReceiver.attr("empSeq"), name: objReceiver.attr("empName")};
					var strTitle = (strType === "1") ? "" : $("#id_report_title input").val();
					var strContent = getEditorHTMLCode(false, g_nActiveEditNumber, true, true);
                    //UCDOC-1986, 2020-05-21, contents css 추가
					var strHTML = '<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width"><title>Oneffice Document</title><link rel="stylesheet" href="https://gwa.douzone.com/gw/oneffice/css/contents.css?ver='+objOnefficeLoader.getVer()+'"><link rel="stylesheet" href="https://gwa.douzone.com/gw/oneffice/css/editor_style_inherit.css?ver='+objOnefficeLoader.getVer()+'"><style>body, td, p {font-family:"[더존] 본문체 30"}body, td, p {font-size:11pt}body, td {line-height:1.8}body {margin: 0} .dze_tb_layout_td{border:0 !important; } </style></head><body><div id="oneffice_content" style="width: 170mm; padding: 10px; margin: auto;">' + strContent + '</div></body></html>';
					var objContent = [
						{
							type: (strType === "1") ? "1" : "3",
							seq: 1,
							title: "",
							contents: strHTML
						}
					];
					
					var arrCc = [];
					
					$("#id_report_cc .cc_list li").each(function(index, item) {
						arrCc.push({compSeq: item.getAttribute("compSeq"), empSeq: item.getAttribute("empSeq"), name: item.getAttribute("empName")});
					});
					
					NextS.setValue({key: "receiver_list", val: JSON.stringify({recv: objReceiver, cc: arrCc})});
					
					
					// strType				1: 일일, 2: 수시
					// strState				A: 저장, B: 보고
					// objTargetInfo		수신자 정보 (compSeq, empSeq)
					// strReportDate		날짜 yyyymmdd
					// strTitle				수시만
					// objContent			보고서 내용
					// arrRefererList		참조자 정보 (compSeq, empSeq)
					// fnSuccess
					// fnError
					onefficeMGW.insertBizboxReport(strType, strState, objReceiver, strDate, strTitle, objContent, arrCc, function(objResponse) {
						var strMsg = (strState === "A") ? "보고서가 저장되었습니다" : "보고서를 전송하였습니다";
						
						mobileToast.show(strMsg, MOBILE_TOAST.CONFIRM);
					});
					
					fnCallback(true);
				} catch (e) {
					dalert(e);
				}
			}
			
			var arrButtonInfo = [
				{
					name: "취소",
					func: function() {
						mobileDlg.hideDialog();
					}
				},
				{
					name: "저장",
					func: fnSave
				},
				{
					name: "보고",
					func: fnReport
				}
			];
			
			mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.CONFIRM, "보고서를 어떻게 처리하시겠습니까?", (strType === "1") ? "일일보고" : "수시보고", arrButtonInfo);
		} catch (e) {
			dalert(e);
		}
	},
	
	activateConfirmBtn: function() {
		try {
			if (($("#id_report_type label.selected").attr("for") === "radio_report_2" && $("#id_report_title input").val().length === 0)
					|| $("#id_report_receiver .receiver_list li").length === 0) {
				$("#one_custom_page header .btn_check").addClass("disabled");
			} else {
				$("#one_custom_page header .btn_check").removeClass("disabled");
			}
		} catch (e) {
			dalert(e);
		}
	}
};