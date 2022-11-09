/*
 * 
 */

var getReportMgr = {
	objListScroll: null,
	objPreviewScroll: null,
	
	init: function() {
		try {
			$("#one_custom_page header .btn_check").addClass("disabled");
			
			var nListHeight = "calc(100% - " + (49 + 94 + 20) + "px)";
			$("#id_list_scroll").height(nListHeight);
			
			if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
				var strStyle = $("#one_custom_page").attr("style");
				strStyle += "width: 560px !important; height: 580px !important;";
				$("#one_custom_page").attr("style", strStyle);
			}
			
			this.objListScroll = new iScroll('id_list_scroll', {"hScroll":false, "vScroll":true, "vScrollbar":false, "mousewheel":false});
			
			this.addListener();
			
			$("#id_get_report .tab").removeClass("selected");
			$("#id_get_report .tab[report_kind=1]").trigger("click");
			
			$("#one_custom_page .head .btn_check").show();
		} catch (e) {
			dalert(e);
		}
	},
	
	addListener: function() {
		try {
			// tab 메뉴
			var objTabs = $("#id_get_report .tab");
			
			objTabs.click(function() {
				var objCurrentTab = $(this);
				
				if (objCurrentTab.hasClass("selected") === true) {
					return;
				}
				
				objTabs.removeClass("selected");
				objCurrentTab.addClass("selected");
				
				getReportMgr.getReport(objCurrentTab.attr("report_kind"));
			});
			
			// report list
			dzeJ("#id_get_report .report_list ul.selected").sortable({
				axis: "y",
				item: "li",
				scroll: true,
				scrollSensitivity: 100,
				scrollSpeed: 100,
				distance: 15,
				revert: 200,
//				containment: "#id_get_report .report_list",
				start: function(event, ui) {
					ui.item.css("opacity", 0.5);
				},
				stop: function(event, ui) {
					ui.item.css("opacity", "");
				}
			}).disableSelection();
			
			
			// option 메뉴
			var objOptions = $("#id_get_report .option");
			
			objOptions.click(function() {
				var objCurrentOption = $(this);
				
				if (objCurrentOption.hasClass("selected") === true) {
					return;
				}
				
				objOptions.removeClass("selected");
				objCurrentOption.addClass("selected");
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	cancel: function() {
		try {
			if ($("#id_report_preview").css("display") !== "none") {
				$("#id_report_preview").hide(function() {
					$("#one_custom_page .head .btn_check").show();
					$("#id_report_preview_scroll").empty();
				});
				
				return false;
			} else {
				return true;
			}
		} catch (e) {
			dalert(e);
		}
	},
	
	confirm: function() {
		try {
			if ($("#one_custom_page .head .btn_check").hasClass("disabled") === true) {
				mobileToast.show("보고서를 선택 해 주세요", MOBILE_TOAST.INFO);
				
				return false;
			}
			
			var objReportsInfo = {
				seq: [],
				title: [],
				emp_name: []
			};
			var objContentsInfo = {
				subject: [], 
				content: [],
				emp_name: []
			};
			
			var bMergeSameItem = ($("#id_get_report .option.selected").attr("option_type") * 1 === 0) ? true : false;
			
			$("#id_get_report .report_list ul.selected li").each(function(index, item) {
				item = $(item);
				
				objReportsInfo.seq.push(item.attr("report_seq"));
				objReportsInfo.title.push(item.text());
				objReportsInfo.emp_name.push(item.attr("report_emp_name"));
			});
			
			onefficeMGW.getBizboxReportContent(objReportsInfo, objContentsInfo, function(objContents) {
				sendIFrameMessage("openReport", {content_list: objContents, merge_Item: bMergeSameItem}, false);
			});
			
			return true;
		} catch (e) {
			dalert(e);
		}
	},
	
	activateConfirmBtn: function() {
		try {
			if ($("#id_get_report .report_list ul.selected").children().length > 0) {
				$("#one_custom_page .head .btn_check").removeClass("disabled");
			} else {
				$("#one_custom_page .head .btn_check").addClass("disabled");
			}
		} catch (e) {
			dalert(e);
		}
	},
	
	getReport: function(strKind) {
		try {
			var objDateInfo = this.getDateTerm();
			
			var objReportList = $("#id_get_report .report_list ul.available");
			var objSelectedList = $("#id_get_report .report_list ul.selected");
			
			objReportList.empty().hide();
			
			onefficeMGW.getBizboxReportList(strKind, objDateInfo, function(arrReportInfo) {
				var objReportItem;
				
				arrReportInfo.forEach(function(objData) {
					objReportItem = getReportMgr.makeReportItem(objData);
					
					if (fnObjectCheckNull(objReportItem) === false) {
						if (objSelectedList.find("li[report_seq=" + objData.reportSeq + "]").length !== 0) {
							objReportItem.hide();
						}
						
						objReportItem.appendTo(objReportList);
						
						getReportMgr.addItemListener(objReportItem);
					}
				});
				
				objReportList.slideDown(400, function() {
					objReportList.find("li").each(function(index, item) {
						if (item.style.display !== "none") {
							getReportMgr.objListScroll.scrollTo(0, -item.offsetTop, 100);
							
							return false;
						}
					});
					
					getReportMgr.objListScroll.refresh();
				});
			}, function() {
				mobileToast.show("보고서 목록 조회에 실패했습니다.", MOBILE_TOAST.ERROR, null, "center");
				
//				var objReportItem;
//				
//				for (var index = 0; index < 15; index++) {
//					objReportItem = null;
//					
//					var data = {
//						reportSeq: "123456" + strKind + "_" + index,
//						empName: "byron" + index,
//						title: "test_report_" + strKind + "_" + (index * 17),
//						type: "1"
//					};
//					
//					objReportItem = getReportMgr.makeReportItem(data);
//					
//					if (fnObjectCheckNull(objReportItem) === false) {
//						if (objSelectedList.find("li[report_seq=" + data.reportSeq + "]").length !== 0) {
//							objReportItem.hide();
//						}
//						
//						objReportItem.appendTo(objReportList);
//						
//						getReportMgr.addItemListener(objReportItem);
//					}
//				}
//				
//				objReportList.slideDown(400, function() {
//					objReportList.find("li").each(function(index, item) {
//						if (item.style.display !== "none") {
//							getReportMgr.objListScroll.scrollTo(0, -item.offsetTop, 100);
//							
//							return false;
//						}
//					});
//					
//					getReportMgr.objListScroll.refresh();
//				});
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	getDateTerm: function() {
		try {
			var strStartData;
			var strEndDate;
			
			var currentDate =  new Date();
			var startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() - 29);		// 오늘 기준 30일 전 까지 데이터만 가져옴
			
			// 현재 날짜
			var nYear = currentDate.getFullYear();
			var nMonth = currentDate.getMonth() + 1;
			var nDate = currentDate.getDate();
			
			if (nMonth < 10) {
				nMonth = "0" + nMonth;
			}
			
			if (nDate < 10) {
				nDate = "0" + nDate;
			}
			
			strEndDate = "" + nYear + nMonth + nDate;
			
			// 30일 전 날짜
			nYear = startDate.getFullYear();
			nMonth = startDate.getMonth() + 1;
			nDate = startDate.getDate();
			
			if (nMonth < 10) {
				nMonth = "0" + nMonth;
			}
			
			if (nDate < 10) {
				nDate = "0" + nDate;
			}
			
			strStartData = "" + nYear + nMonth + nDate;
			
			return {
				startDate: strStartData,
				endDate: strEndDate
			};
		} catch (e) {
			dalert(e);	
		}
	},
	
	makeReportItem: function(objInfo) {
		try {
			var objItem = document.createElement("li");
			var objTitleBox = document.createElement("div");
			var objTitle = document.createElement("span");
			var objPrevBtn = document.createElement("prevbtn");
			var objBtn = document.createElement("img");
			
			objItem.setAttribute("report_seq", objInfo.reportSeq);
			objItem.setAttribute("report_emp_name", objInfo.empName);
			
			objTitle.innerHTML = objInfo.title;
			
			objPrevBtn.className = "preview";
			objPrevBtn.textContent = "원문보기";
			
			objBtn.className = "move";
			objBtn.src = "../mobile/images/btn/btn_move.png";
			objBtn.style.float = "right";
			objBtn.style.display = "none";
			
			objItem.appendChild(objTitleBox);
			objTitleBox.appendChild(objTitle);
			objItem.appendChild(objPrevBtn);
			objItem.appendChild(objBtn);
			
			return $(objItem);
		} catch (e) {
			dalert(e);
		}
	},
	
	addItemListener: function(objReport) {
		try {
			var objSelected = dzeJ("#id_get_report .report_list ul.selected");
			var objAvailable = $("#id_get_report .report_list ul.available");
			
			objReport.click(function(clickEvent) {
				if (clickEvent.target.classList.contains("preview") === true) {
					return;
				}
				
				var objGroup = objReport.parent("ul");
				
				if (objGroup.hasClass("selected") === true) {
					var objTarget = clickEvent.originalEvent.target;
					
					if (objTarget.nodeName === "IMG" && objTarget.classList.contains("move") === true) {
						return;
					}
					
					var strSeq = objReport.attr("report_seq");
					objAvailable.find("li[report_seq=" + strSeq + "]").slideDown("fast");
					
					objReport.slideUp("fast", function() {
						objReport.remove();
						
						getReportMgr.activateConfirmBtn();
						
						objSelected.sortable((getReportMgr.checkSortable() === true) ? "enable" : "disable");
					});
				} else if (objGroup.hasClass("available") === true) {
					var objSelectedItem = objReport.clone().css("display", "none");
					objSelectedItem.find("img.move").show();
					
					objSelectedItem.mousedown(function(event) {
						var objController = event.originalEvent.target;
						
						if (getReportMgr.checkSortable(objController) === false) {
							objSelected.sortable("disable");
						}
					}).mouseup(function() {
						objSelected.sortable((getReportMgr.checkSortable() === true) ? "enable" : "disable");
					});
					
					getReportMgr.addItemListener(objSelectedItem);
					
					objSelectedItem.appendTo(objSelected);
					objReport.slideUp("fast");
					
					objSelectedItem.slideDown("fast", function() {
						getReportMgr.activateConfirmBtn();
						
						objSelected.sortable((getReportMgr.checkSortable() === true) ? "enable" : "disable");
					});
				}
				
				setTimeout(function() {
					getReportMgr.objListScroll.refresh();
				}, 300);
			});
			
			objReport.find("prevbtn.preview").click(function() {
				if (checkDoubleClick() === true) {
					return;
				}
				
				var objPrevBtn = $(this);
				
				objPrevBtn.attr("src", "../mobile/images/btn/btn-search-sele.png");
				
				setTimeout(function() {
					objPrevBtn.attr("src", "../mobile/images/btn/btn-search-none.png");
				}, 200);
				
				var objReport = objPrevBtn.parent("li");
				
				var objReportsInfo = {
					seq: [objReport.attr("report_seq")],
					title: [objReport.text()],
					emp_name: [objReport.attr("report_emp_name")]
				};
				var objContentsInfo = {
					subject: [], 
					content: [],
					emp_name: []
				};
				$(this).addClass("viewed");
				onefficeMGW.getBizboxReportContent(objReportsInfo, objContentsInfo, function(objContents) {
					getReportMgr.showReportPreview(objContents.content[0]);
				});
			});
			
			objReport.find("img.move").touchstart(function(event) {
				getReportMgr.objListScroll.disable();
			}).touchmove(function(event) {
				
			}).touchend(function(event) {
				getReportMgr.objListScroll.enable();
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	checkSortable: function(objTarget) {
		try {
			var bSortable = false;
			
			if (fnObjectCheckNull(objTarget) === false) {
				if (objTarget.nodeName === "IMG" && objTarget.classList.contains("move") === true) {
					bSortable = true;
				}
			} else {
				if ($("#id_get_report .report_list ul.selected li").length > 1) {
					bSortable = true;
				}
			}
			
			return bSortable;
		} catch (e) {
			dalert(e);
		}
	},
	
	showReportPreview: function(strHTML) {
		try {
			if (fnObjectCheckNull(strHTML) === true) {
				return;
			}
			
			var objDoc = document.implementation.createHTMLDocument("NewDoc");
			objDoc.documentElement.innerHTML = strHTML;
			
			var objContent;
			
			if (objDoc.body.childNodes.length === 1 && objDoc.body.firstChild.nodeName === "DIV" && objDoc.body.firstChild.id === "oneffice_content") {
				objContent = objDoc.body.firstChild;
			} else {
				objContent = objDoc.body;
			}
			
			if (objContent.childNodes.length < 2 || objContent.childNodes[0].nodeName.toLowerCase() !== "dze_doc_property") {
				return;
			}
			
			objContent = $(objContent);
			objContent.css({width: "fit-content", height: "fit-content", padding: "20px 0px"});
			
			var objContainer = $("#id_report_preview_scroll");
			
			$(objContent).appendTo(objContainer);
			
			$("#id_report_preview").css("visibility", "hidden").show(function() {
				$("#one_custom_page .head .btn_check").hide();
			});
			
			var nRatio = ((g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) ? 528 : window.width - 40) / objContent.width();
			var nHeight;
			
			if (objContent.find("dze_doc_property").attr("dze_onepage_mode") === "true") {
				nHeight = objContent.height();
			} else {
				var nPageCounts = objContent.find(".dze_printpagebreak").length + 1;
				nHeight = g_objCommonUtil.convMMToPx(297) * nPageCounts;
			}
			
			objContent.css({
				height: nHeight * nRatio,
				transform: "scale(" + nRatio + ")",
				transformOrigin: "left top"
			});
			
			this.objPreviewScroll = new iScroll('id_report_preview_scroll', {"hScroll": false, "vScrollbar": false, "vScroll": true, "mousewheel": false});
			
			$("#id_report_preview").hide().css("visibility", "visible").show();
			
			setTimeout(function() {
				getReportMgr.objPreviewScroll.refresh();
			}, 300);
		} catch (e) {
			dalert(e);
		}
	}
};