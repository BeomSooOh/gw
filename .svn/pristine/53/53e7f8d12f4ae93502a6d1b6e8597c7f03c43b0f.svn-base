
//==========================================================================
// common.js
//==========================================================================

function docDivFc() { //문서미리보기
	$(".doc_div .preview").each(function () {
		var th_pa_wid = $(this).parent().width();
		$(this).width(th_pa_wid);
	});
}

function selectSortCheck(index, orderby){
	
	var convertClassName = orderby=='-'?'desc':'asc';
	
	dzeJ(".m_sort_name").removeClass("chk desc asc");
	dzeJ(".m_sort_date").removeClass("chk desc asc");
	dzeJ(".m_sort_size").removeClass("chk desc asc");
	dzeJ(".m_sort_owner").removeClass("chk desc asc");
	
	switch (index) {
		case MOBILE_SORT_ATTR_NAME:
			dzeJ(".m_sort_name").addClass("chk "+convertClassName);
			break;
		case MOBILE_SORT_ATTR_DATE:
			dzeJ(".m_sort_date").addClass("chk "+convertClassName);
			break;
		case MOBILE_SORT_ATTR_SIZE:
			dzeJ(".m_sort_size").addClass("chk "+convertClassName);
			break;
		case MOBILE_SORT_ATTR_OWNER:
			dzeJ(".m_sort_owner").addClass("chk "+convertClassName);
			break;
	}
}


//토글 버튼 (on/off 기능)
$(document).on('click', '.toggleBtn', function () {
	var toggleBG = $(this).find('.toggleBG');
	var toggleFG = $(this).find('.toggleFG');
	var left = toggleFG.css('left');
	if (left == '22px') {
		toggleBG.css('background', '#fff').css('border', '1px solid #e5e5e5');
		toggleActionStart(toggleFG, 'TO_LEFT');
	} else if (left == '0px') {
		toggleBG.css('background', '#529bf8').css('border', '1px solid #529bf8');
		toggleActionStart(toggleFG, 'TO_RIGHT');
	}
});

// 토글 버튼 이동 모션 함수
function toggleActionStart(toggleBtn, LR) {
	// 0.01초 단위로 실행
	var intervalID = setInterval(
		function () {
			// 버튼 이동
			var left = parseInt(toggleBtn.css('left'));
			left += (LR == 'TO_RIGHT') ? 2 : -2;
			if (left >= 0 && left <= 22) {
				left += 'px';
				toggleBtn.css('left', left);
			}
		}, 10);
	setTimeout(function () {
		clearInterval(intervalID);
	}, 201);
}

function getMinDateFromTimeStamp(time) {
	var d = new Date(time);
	var year = d.getFullYear();
	var month = d.getMonth() + 1;
	if (month < 10) month = "0" + month;
	var day = d.getDate();
	if (day < 10) day = "0" + day;

	return "" + year + "." + month + "." + day;
}

function getBooleanValue(objValue) {
	try {
		if (fnObjectCheckNull(objValue) === true) {
			return 0;
		}
		
		var nBoolean = 0;
		
		if (objValue.length > 0) {
			if (typeof(objValue) === "string") {
				if (objValue.toLowerCase() === "y") {
					nBoolean = 1;
				} else if (objValue.toLowerCase() === "n") {
					nBoolean = 0;
				} else {
					nBoolean = (isNaN(objValue * 1) === true) ? 0 : objValue * 1;
				}
			} else if (typeof(objValue) === "number") {
				nBoolean = objValue;
			}
		}
		
		return nBoolean;
	} catch (e) {
		dalert(e);
	}
}

function calculateDateDiff(beforeDate, afterDate) {
	try {
		var diff = Math.abs(afterDate.getTime() - beforeDate.getTime());
		diff = Math.ceil(diff / (1000 * 3600 * 24));
		
		return diff;
	} catch(e) {
		dalert(e);
	}
};

function getBaseDocInfo(strDocSeq, strFolderSeq) {
	try {
		return {
			seq: strDocSeq,
			folderSeq: strFolderSeq,
			subject: "",
			content: "",
			readonly: "",
			important: "",
			security_key: undefined
			// 아래는 현재 안쓰는 거 같은데...
//			type: null,
//			content_size: null,
//			owner_id: null,
//			keyword: null,
//			regdate: null,
//			moddate: null,
//			accessdate: null,
//			deleted: null,
//			openFileDate: null,
//			openPath: null
		};
	} catch (e) {
		dalert(e);
	}
}

function fnObjectCheckNull(objCheck)
{
	try
	{
		if( (null == objCheck) || (ID_STRING_NAME_UNDEFINED == typeof(objCheck)) )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	catch(e)
	{
		return false;
	}
};

function getSelectItemList(arr)
{
	try
	{
		var _arr = [];
		for(var ix=0; ix<arr.length; ix++){
			var _obj = arr[ix];
			if(_obj.docData.bChecked){
				_arr.push(_obj);
			}
		}
		return _arr;
	}
	catch(e)
	{
		dalert(e);
	}
}

String.format = function() {
	try {
		var theString = arguments[0];
		
		for (var index = 1; index < arguments.length; index++) {
			var regEx = new RegExp("\\{" + (index - 1) + "\\}", "gm");
			
			theString = theString.replace(regEx, arguments[index]);
		}
		
		return theString;
	} catch (e) {
		dalert(e);
	}
};


/************************************ TOAST *****************************************/
var mobileToast = {
	show: function(strMsg, nType, nTime, strPosition) {
		try {
			var strClass = "toast_box ";
			var strSrc = "";
			
			switch (nType) {
				case MOBILE_TOAST.INFO:
					strClass += "info";
					strSrc = "../mobile/images/ico/icon_toast_info.png";
					
					break;
					
				case MOBILE_TOAST.ERROR:
					strClass += "error";
					strSrc = "../mobile/images/ico/icon_toast_error.png";
					
					break;
					
				case MOBILE_TOAST.WARNING:
					strClass += "warning";
					strSrc = "../mobile/images/ico/icon_toast_warning.png";
					
					break;
					
				case MOBILE_TOAST.CONFIRM:
					strClass += "confirm";
					strSrc = "../mobile/images/ico/icon_toast_confirm.png";
					
					break;
					
				case MOBILE_TOAST.LOADING:
					strClass += "loading";
					strSrc = "../mobile/images/ico/icon_toast_loading.png";
					
					break;
					
				default:
					nType = MOBILE_TOAST.DEFAULT;
					
					break;
			}
			
			var objInterval = null;
			var objToastBox = $("div.toast_box");
			
			objToastBox.removeAttr("class").addClass(strClass);
			
			if (nType !== MOBILE_TOAST.DEFAULT) {
				objToastBox.find(".image").attr("src", strSrc).show();
				
				if (nType === MOBILE_TOAST.LOADING) {
					var nDegrees = 0;
					objInterval = setInterval(function() {
						objToastBox.find(".image").css({transform: "translateY(-50%) rotate(" + nDegrees + "deg)"});
						
						nDegrees += 2;
					}, 1);
				}
			} else {
				objToastBox.find(".image").css("transform", "").hide();
			}
			
//			if (fnObjectCheckNull(strPosition) === false && strPosition === "center") {
//				objToastBox.css("top", "50%");
//			}
			
			objToastBox.find(".message").text(strMsg);
			
			nTime = (fnObjectCheckNull(nTime) === true) ? 2 : nTime;
			
			objToastBox.fadeIn("fast", function() {
				setTimeout(function() {
					objToastBox.fadeOut("slow", function() {
						if (fnObjectCheckNull(strPosition) === false && strPosition === "center") {
							objToastBox.css("top", "");
						}
					});
					
					if (objInterval !== null) {
						clearInterval(objInterval);
					}
				}, (nTime * 1000));
			});
		} catch (e) {
			dalert(e);
		}
	}
};



//문서 폴더 이동 복사 실행 함수
function checkCopyListTo(contentList, destinationSeq, bMove, callback) 
{
	try 
	{
		if(destinationSeq === null || typeof(destinationSeq) === "undefined")
			var destinationSeq = "";

		if(bMove)
		{
			for(var i = 0 ; i < contentList.length ; i++) 
			{
				var fileData = contentList[i];
				var folderSeq =  fileData.parentFolderSeq;

				if(fileData.seq == destinationSeq || folderSeq == destinationSeq) 
				{
					mobileToast.show(ID_RES_CONST_STRING_WARNING_CANNOT_MOVE_SELECTED_FOLDER);
					return false;
				}
			}

			var movedCnt = 0;
			var failedCnt = 0;
			
			for(var i = 0 ; i < contentList.length ; i++) // folderSeq를 destinationSeq로 변경
			{
				var fileData = contentList[i].serverData;
				fileData.folderSeq = destinationSeq;

				var bFolder = fileData.fileType==0?true:false;
				var nextFunc = null;
				if(bFolder) 
					nextFunc = onefficeMGW.saveFolderContent;
				else
					nextFunc = onefficeMGW.saveFileContent;
			
				nextFunc(fileData, function(responseData_DocID) {						
					if(typeof(responseData_DocID) === "string" && responseData_DocID && responseData_DocID.length > 0)
						movedCnt++;
					else if(typeof(responseData_DocID) === "number" && responseData_DocID  > 0)						
						movedCnt++;

					if(movedCnt === contentList.length) 
					{
						if(destinationSeq === "") 
						{
							mobileToast.show(String.format(ID_RES_CONST_STRING_NOTI_MOVED_DOCUMENT_LIST, movedCnt));
							if(typeof(callback) === "function")
							{
								callback();
							}
						} 
						else 
						{								
							onefficeMGW.getFolderContent(destinationSeq, function(responseData) {									
								var folderName = (responseData === null || responseData.subject === "undefined") ? "MY ONEFFICE" : responseData.subject;									
								mobileToast.show(String.format(ID_RES_CONST_STRING_NOTI_MOVED_DOCUMENT_LIST, movedCnt));
								if(typeof(callback) === "function")
								{
									callback();
								}
							});
						}
						return ;
					}
											
					if((movedCnt+failedCnt) === contentList.length) 
					{
						alert(String.format(ID_RES_CONST_STRING_NOTI_MOVED_LIST_FAIL, failedCnt));
						if(typeof(callback) === "function")
						{
							callback();
						}
						
					}
				}, function(e) {	// failed
					failedCnt++;
					
					if((movedCnt+failedCnt) === contentList.length) 
					{
						alert(String.format(ID_RES_CONST_STRING_NOTI_MOVED_LIST_FAIL, failedCnt));
						if(typeof(callback) === "function")
						{
							callback();
						}

					}
				});
			}
		}
		else	
		{
			var copiedCnt = 0;
			var failedCnt = 0;
			for(var i = 0 ; i < contentList.length ; i++) 
			{
				onefficeMGW.getFileContent(contentList[i].seq, function(resData) {
					onefficeMGW.copyFileToFolder(resData.seq, destinationSeq, function(responseData_DocID) {
						if(typeof(responseData_DocID) === "string" && responseData_DocID && responseData_DocID.length > 0)
							copiedCnt++;
						else if(typeof(responseData_DocID) === "number" && responseData_DocID  > 0)
							copiedCnt++;

						if(copiedCnt === contentList.length) 
						{
							if(destinationSeq === "") 
							{
								mobileToast.show(String.format(ID_RES_CONST_STRING_NOTI_COPIED_DOCUMENT, "MY ONEFFICE"));
								if(typeof(callback) === "function")
								{
									callback();
								}
							} 
							else 
							{
								onefficeMGW.getFolderContent(destinationSeq, function(responseData) {
									var folderName = (responseData === null || responseData.subject === "undefined") ? "MY ONEFFICE" : responseData.subject;
									mobileToast.show(String.format(ID_RES_CONST_STRING_NOTI_COPIED_DOCUMENT, folderName));
									if(typeof(callback) === "function")
									{
										callback();
									}
								});
							}
						}
					}, function(e) {	// failed
						failedCnt++;						
						
						if((copiedCnt+failedCnt) === contentList.length) 
						{// 실패 팝업 처리
							alert(ID_RES_CONST_STRING_NOTI_COPIED_LIST_FAIL);
							if(typeof(callback) === "function")
							{
								callback();
							}
						}
					});
				});
			}
		}
	} 
	catch(e) 
	{
		dalert(e);
	}
}

function getFullUrlFromPath(strPath) {
	try {
		var strUrl = "";
		
		if (strPath.indexOf("http://") == 0
				|| strPath.indexOf("https://") == 0
				|| strPath.indexOf("//") == 0) {
			strUrl = strPath;
		} else {
			if (strPath.indexOf("/") == 0) {
				strUrl = document.location.origin + strPath;
			} else {
				strUrl = document.location.href.substring(0, location.href.lastIndexOf('/')) + "/" + strPath;
			}
		}
		
		return strUrl;
	} catch (e) {
		dalert(e);
	}
}

function fnHandler_saveMobileFile(fnCallback) {
	try {
		if (oneffice.currFileSeq !== "" && oneffice.currFileSubject !== "") {
			convertMobileSrc();
			
			var currContent = getEditorHTMLCode(false, g_nActiveEditNumber, true, true);

			if (onefficeUtil.checkSameContent(currContent)) {
				fnCallback(false);
				return;
			}
			
			onefficeMGW.saveFile(oneffice.currFileSeq, oneffice.currFolderSeq, oneffice.currFileSubject, currContent, g_nActiveEditNumber, function () {
				onefficeUtil.setSavedContent(currContent);
				onefficeMGW.setCurrFileInfo(oneffice.currFileSeq, oneffice.currFolderSeq, oneffice.currFileSubject, oneffice.currFileRegDate);
				
				if (fnObjectCheckNull(fnCallback) === false && typeof(fnCallback) === "function") {
					fnCallback(true);
				}
			}, true);
		}
	} catch (e) {
		dalert(e);
	} finally {
		convertWebSrc();
	}
}

var sendIFrameMessage = function(type, data, bKeepFocus) {
	try {
		var msg = {
				uiEvent: type,
				uiEventData: data
			};
		
		var bUndoRedoStack = false;
		
		if(msg.hasOwnProperty("uiEvent")) {
			switch(msg.uiEvent) {
				case "undo":
					g_objUndoRedo.operateUndoRedoStack(true, false, g_nActiveEditNumber);
					break;
				case "redo":
					g_objUndoRedo.operateUndoRedoStack(false, false, g_nActiveEditNumber);
					break;
				case "fontSizeUp":
					increaseFontSize(true, g_nActiveEditNumber);
					break;
				case "fontSizeDown":
					increaseFontSize(false, g_nActiveEditNumber);
					break;
				case "bold":
				case "italic":
				case "underline":
				case "strikethrough":
				case "superscript":
				case "subscript":
					fnHandler_SupportCommand_Main(g_nActiveEditNumber, msg.uiEvent);
					break;
				case "insertunorderedlist":
				case "insertorderedlist":
					fnHandler_SupportCommand_Main(g_nActiveEditNumber, msg.uiEvent);
					break;
				case "justifyleft":
				case "justifycenter":
				case "justifyright":
				case "justify":
					var cmdID = 0;
					switch (msg.uiEvent) {
						case "justifyleft":
							cmdID = 3;
							break;
						case "justifycenter":
							cmdID = 4;
							break;
						case "justifyright":
							cmdID = 5;
							break;
						case "justify":
							cmdID = 69;
							break;
					}

					fnHandler_Align_Main(g_nActiveEditNumber, msg.uiEvent, msg.uiEventData, cmdID);

					// 테이블 리사이즈 라인 초기화
					g_objTableResize.setTableMoveLine(false, false, 0, 0, 0, 0, 0);

					//객체선택 가이드라인이 있는경우 스크롤될때 재세팅한다.(위치조절)
					if (g_objWrapperOutlineResize.objExtSelectedInfo) {
						showExtOutline_ObjectElement(g_objWrapperOutlineResize.objExtSelectedInfo.objElement, true, false, g_nActiveEditNumber);
					}

					g_objTableMiniMenu.delayUpdate();
					bUndoRedoStack = true;
					break;

				case "indent":
				case "outdent":
					var bOutdent = (msg.uiEvent == "indent") ? false : true;
					g_objLetterFn.setParaStyle(g_nActiveEditNumber, bOutdent ? { outdent: true } : { indent: true });
			
					bUndoRedoStack = true;
					break;

				case "textColor":
					g_nLetterOperationType = ID_LETTER_OPERATION_FORE_COLOR;
					fnColorCellApply(msg.uiEventData, null, DZE_LETTER_COMMAND_FONT_COLOR);
					break;
				case "textBGColor":
					g_nLetterOperationType = ID_LETTER_OPERATION_BACK_COLOR;
					fnColorCellApply(msg.uiEventData, null, DZE_LETTER_COMMAND_FONT_BACKGROUND_COLOR);
					break;

				case "insertEmoticon":
					var eContents = msg.uiEventData;
					fnAddHTMLContent(eContents, null, 0, g_nActiveEditNumber);
					break;
				case "showSlide":
					fnHandler_slideShow(e, 0, g_nActiveEditNumber);
					break;
					

				case "insertHr":
					g_objShapeFunction.onDeselectAllShapes();
					g_objInsertUtil.insertTableCodeAtSelection("<hr>", g_nActiveEditNumber);
					bUndoRedoStack = true;
					break;

				case "insertPageBreak":
					insertPrintPageBreak(g_nActiveEditNumber);
					break;

				case "getQRStatus":
					var bFirst = false;
					var bLast = false;
					if(g_objEditorDocument[g_nActiveEditNumber].getElementsByClassName("oneffice_qrcode_first_container").length > 0)
						bFirst = true;
					if(g_objEditorDocument[g_nActiveEditNumber].getElementsByClassName("oneffice_qrcode_last_container").length > 0)
						bLast = true;

					MobileEventUtil.sendHybridMessage("qrStatusCB", bFirst+"|"+bLast);
					break;
				case "qrCodeFirst":
					applyFirstQRCode(msg.uiEventData);
					break;
				case "qrCodeLast":
					applyLastQRCode(msg.uiEventData);
					break;
					
				case "insertTable":
					duzon_dialog.createSelectedCellsTable(msg.uiEventData.row, msg.uiEventData.col, g_nActiveEditNumber);
					
					break;
					
				case "insertLayout":
					duzon_dialog.selectedLayoutNo = msg.uiEventData.index;
					
					dynamicScriptCall("js/const/file_layout_const.js", function() {
						duzon_dialog.inputSelectLayoutData();
						
						g_objUndoRedo.registerUndoRedoStack(0, g_nActiveEditNumber);
					});
					
					break;
					
				case "openReport":
					executeMergeBizboxReport(msg.uiEventData.content_list, msg.uiEventData.merge_Item, function() {
						g_objUndoRedo.registerUndoRedoStack(0, g_nActiveEditNumber);
						
						cmnCtrlToast.showToastMsg(null, "병합이 완료되었습니다.", 1.5);
					});
					
					break;

				case "insertImage":    //UCDOC-2750
					insertHTMLCodeAtSelection_SubDetail(setOrgImageSize(data, getMaxBoundSize()), g_nActiveEditNumber);
					bUndoRedoStack = true;
					break;
			}
		}

		if(bUndoRedoStack) {
			g_objUndoRedo.registerUndoRedoStack(0, g_nActiveEditNumber);

			if(dzeUiConfig.bOfficePagingMode) {    //UCDOC-2750
				g_objPageControl.onSetDelayedUpdatePageTimer();
			}
		}

		if (bKeepFocus === true) {
			duzon_dialog.setEditorSelection();
			duzon_dialog.setEditorFocus();
		}
	} catch(e) {
		dalert(e);
	}
}

function convertMobileSrc() {
	try {
		//모바일 본문내 이미지 경로 복구
		if (fnObjectCheckNull(g_objEditorDocument[0]) === true) {
			return;
		}
		
		var imageTags = g_objEditorDocument[0].getElementById('dze_document_main_container').getElementsByTagName("img");
		var videoTags = g_objEditorDocument[0].getElementById('dze_document_main_container').getElementsByTagName("video");
		for (var i = 0;i < imageTags.length; i++) {
			var webUrl = imageTags[i].getAttribute('webSrc');
			
			if (!webUrl) continue;
			
			if (webUrl.indexOf("getAttachmentData.do?seq=") >= 0 || webUrl.indexOf("/image/") >= 0) {
				var _imgTag = imageTags[i];
				_imgTag.src= webUrl;
			}
		}
		for (var i = 0;i < videoTags.length; i++) {
			var webUrl = videoTags[i].firstChild.getAttribute('webSrc');
			
			if (!webUrl) continue;
			
			if (webUrl.indexOf("getAttachmentData.do?seq=") >= 0) {
				var _videoTag = videoTags[i].firstChild;
				_videoTag.src= webUrl;
			}
		}
	} catch (e) {
		dalert(e);
	}
}

function convertWebSrc(editNumber) {
	try {
		
		if(!editNumber){
			editNumber = 0;
		}
		
		if (fnObjectCheckNull(g_objEditorDocument[editNumber]) === true) {
			return;
		}
		
		
		var imageTags = g_objEditorDocument[editNumber].getElementById('dze_document_main_container').getElementsByTagName("img");
		var videoTags = g_objEditorDocument[editNumber].getElementById('dze_document_main_container').getElementsByTagName("video");
		for (var i = 0;i < imageTags.length; i++) {
			var _src = imageTags[i].src;
			
			if (imageTags[i].src.indexOf("getAttachmentData.do?seq=") >= 0) {
				var _imgTag = imageTags[i];
				var imgFileName = _src.split("seq=")[1];
				var docSeq = imgFileName.split("-")[0];
				_imgTag.setAttribute('webSrc', _src);
				var mobileSrc = mobile_http.getProtocolUrl("P018")+"?seq="+imgFileName+"&pathSeq=1600&token="+mobile_http.hybridBaseData.header.token;
				_imgTag.src= mobileSrc;
			}
			
			if (imageTags[i].src.indexOf("file") >= 0 && imageTags[i].src.indexOf("/image/") >= 0) {
				var _imgTag = imageTags[i];
				var imgFileName = _src.split("/image/")[1];
				_imgTag.setAttribute('webSrc', "./image/"+imgFileName);
				var mobileSrcemoticon = "../image/"+imgFileName;
				_imgTag.src= mobileSrcemoticon;
			}
		}
		for(var i = 0;i < videoTags.length; i++) {
			var _src = videoTags[i].firstChild.src;
			videoTags[i].setAttribute('webkit-playsinline','');
			videoTags[i].setAttribute('playsinline','');
			if(videoTags[i].firstChild.src.indexOf("getAttachmentData.do?seq=") >= 0){
				var _videoTag = videoTags[i].firstChild;
				var vedioFileName = _src.split("seq=")[1];
				var docSeq = vedioFileName.split("-")[0];
				_videoTag.setAttribute('webSrc', _src);
				var mobileSrc = mobile_http.getProtocolUrl("P018")+"?seq="+vedioFileName+"&pathSeq=1600&token="+mobile_http.hybridBaseData.header.token;
				if(g_browserCHK.iOS){
					var ownseq = mobile_http.hybridBaseData.result.empSeq;
					if(oneffice.parentFileContent){
						ownseq = oneffice.parentFileContent.owner_id;
					}
					if(mobile_http.hybridBaseData.result.compDomain.indexOf("bizboxa.com") >= 0) {
						mobileSrc = 'http://' + mobile_http.hybridBaseData.result.compDomain +"/upload/"+mobile_http.hybridBaseData.result.groupSeq+"/onefficeFile/"+ownseq+"/"+docSeq+"/"+vedioFileName;
					} else {
						mobileSrc = 'http://' + mobile_http.hybridBaseData.result.compDomain +"/upload/onefficeFile/"+ownseq+"/"+docSeq+"/"+vedioFileName;
					}
//					mobileSrc = 'http://' + mobile_http.hybridBaseData.result.compDomain +"/upload/onefficeFile/"+mobile_http.hybridBaseData.result.empSeq+"/"+docSeq+"/"+vedioFileName;
				}
				_videoTag.src= mobileSrc;

			}
		}
	} catch (e) {
		dalert(e);
	}
}

function getImagePath(strOrigin) {
	try {
		if (mobile_http.hybridBaseData !== null) {
			strOrigin = 'http://' + mobile_http.hybridBaseData.result.compDomain + strOrigin;
		}
		
		return strOrigin;
	} catch (e) {
		dalert(e);
	}
}

function updateView(objScope) {
	try {
		if (objScope.$$phase !== "$apply" && objScope.$$phase !== "$digest") {
			objScope.$apply();
		}
	} catch (e) {
		dalert(e);
	}
}

function moveBack() {
	try {
		var strCurrentView = $("#mainContainer").scope().currentViewPage;
		
		switch (strCurrentView) {
			case "one_home":			$("#one_home").scope().moveBack();			break;
			case "one_viewer":			$("#one_viewer").scope().moveBack();		break;
			case "one_share":			$("#one_share").scope().moveBack();			break;
			case "one_scty":			$("#one_scty").scope().moveBack();			break;
			case "one_template":		$("#one_template").scope().moveBack();		break;
			case "one_custom_page":		$("#one_custom_page").scope().moveBack();	break;
			case "one_slideshow":		$("#one_slideshow").scope().moveBack();		break;
			case "one_comment":			$("#one_comment").scope().moveBack();		break
			case "one_docinfo":			$("#one_docinfo").scope().moveBack();		break;
		}
	} catch (e) {
		dalert(e);
	}
}

function openIn(objOpenInfo) {
	try {
		if (fnObjectCheckNull(objOpenInfo) === true) {
			return;
		}
		
		if (fnObjectCheckNull($("#one_viewer").scope()) === false
				&& $("#one_viewer").scope().bEditMode === true) {
			// 편집 중인 상태에서 ime 활성화 된 경우 내리도록 처리
			document.activeElement.blur();
		}
		
		var strSeq = getDocSeqByUrl(objOpenInfo.url);
		
		onefficeMGW.getFileContent(strSeq, function(objDocInfo) {
			var objMainScope = $("#mainContainer").scope();
			
			var objDocInfo = objMainScope.docDataFact.convItem(objDocInfo);
			objDocInfo.strOpenMode = objOpenInfo.mode;
			
			if (objMainScope.bViewerPageLoad === false) {
				setDocLoadTimer();
				openDocument(objDocInfo);
			} else {
				var strMsg;
				
				if ($("#one_viewer").scope().bEditMode === true) {
					strMsg = "현재 편집 중인 문서를 저장하고";
				} else {
					strMsg = "현재 열람 중인 문서를 닫고";
				}
				
				strMsg += ("<br/>새 문서를 " + ((objOpenInfo.mode === "w") ? "편집" : "열람") + "하시겠습니까?");
				
				var arrButtonInfo = [
					{
						name: "취소",
						func: function() {
							mobileDlg.hideDialog();
						}
					},
					{
						name: "확인",
						func: function() {
							setDocLoadTimer();
							
							if ($("#one_viewer").scope().bEditMode === true) {
								fnHandler_saveMobileFile(function() {
									objMainScope.viewChange(0);
									$("#one_home").scope().clearAllCheckItem();
									
									setTimeout(function() {
										openDocument(objDocInfo);
									}, 1000);
								});
							} else {
								objMainScope.viewChange(0);
								$("#one_home").scope().clearAllCheckItem();
								
								setTimeout(function() {
									openDocument(objDocInfo);
								}, 1000);
							}
							
							mobileDlg.hideDialog();
						}
					}
				];
				
				mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.CONFIRM, strMsg, "알림", arrButtonInfo);
			}
			
			function setDocLoadTimer() {
				$(".load_doc_modal").show();
				
				setTimeout(function() {
					if ($(".load_doc_modal").css("display") !== "none") {
						$(".load_doc_modal").hide();
						objMainScope.objOpenInInfo = null;
						
						mobileToast.show("문서 로드에 실패했습니다.", MOBILE_TOAST.ERROR);
					}
				}, 5000);
			}
		});
	} catch (e) {
		dalert(e);
	}
}

function openDocument(objDocInfo) {
	try {
		if (fnObjectCheckNull(objDocInfo) === true) {
			return;
		}
		
		var objMainScope = $("#mainContainer").scope();
		
		if (fnObjectCheckNull(objDocInfo.strOpenMode) === true) {
//			objDocInfo.docData.bChecked = true;
//			objMainScope.docDataFact.checklist = [];
//			objMainScope.docDataFact.checklist.push(objDocInfo);
			
			objMainScope.objCurrentDoc = objDocInfo;
			objMainScope.objOpenInInfo = null;
		} else {
			objMainScope.objOpenInInfo = objDocInfo;
		}
		
		objMainScope.bViewerPageLoad = true;
		
		updateView(objMainScope);
	} catch (e) {
		dalert(e);
	}
}

function createDocument(objCreateInfo) {
	try {
		onefficeMGW.checkFileName(objCreateInfo.title, objCreateInfo.folderSeq, true).then(function(nIndex) {
			var strDoctitle = objCreateInfo.title + ((fnObjectCheckNull(nIndex) === true || nIndex === 0) ? "" : ("(" + nIndex + ")"));
			
			onefficeMGW.onCreateNewFile(strDoctitle, objCreateInfo.contents, objCreateInfo.folderSeq, objCreateInfo.callBack);
		});
	} catch (e) {
		dalert(e);
	}
}

function setAutoSave() {
	try {
		// 자동저장
		if (oneffice.autoSave === true) {
			oneffice.autoSaveTimer = setInterval(function () {
				// 머리글/바닥글 편집모드에서는 자동저장하지 않는다. (본문이 업데이트 되지 않았으므로) (UCDOC-576)
				if (g_objHeaderFooter.getHeaderFooterEditMode() === true) {
					return;
				}
				
				fnHandler_saveMobileFile(function(bResult) {
					if (bResult === true) {
						mobileToast.show(ID_RES_CONST_STRING_AUTO_SAVED, MOBILE_TOAST.CONFIRM);
					}
				});
			}, oneffice.autoSaveTime * 1000);
		}
	} catch (e) {
		dalert(e);
	}
}

function setAutoCheckSession() {
	try {
		oneffice.autoSessionCheckTimer = setInterval(function () {
			onefficeMGW.checkSession();
		}, oneffice.autoSessionCheckTime * 1000);
	} catch (e) {
		dalert(e);
	}
}

var nPreviousEvent = null;

function checkDoubleClick() {
	try {
		var nCurrent = Date.now();
		var nPrevious = nPreviousEvent;
		
		nPreviousEvent = nCurrent;
		
		if (nPrevious !== null
				&& nCurrent - nPrevious < 250) {
			// 클릭 이벤트 인터벌이 250 이하이면 더블클릭으로 간주
			return true;
		}
		
		return false;
	} catch (e) {
		dalert(e);
	}
};

function insertImgContents(obj){
	try {
		
		if(!obj) return;
		
		var _imgFile = obj.files[0];
		DZE_UPLOAD_EVENT.uploadImageObject(_imgFile,
			function succes(url){
				console.log("succes img upload");
			}
		);
	} catch (e) {
		dalert(e);
	}
}

function getNetworkStatus() {
	try {
		if (fnObjectCheckNull(navigator.connection) === false
				&& navigator.connection.type === "none") {
			return false;
		}
		
		return true;
	} catch (e) {
		dalert(e);
	}
}

function checkNetworkStatus() {
	try {
		if (getNetworkStatus() === false) {
			// 네트워크가 끊긴 경우
			var strMsg = "네트워크 연결 상태가 좋지 않습니다.<br/>확인 후 다시 시도하시기 바랍니다.";
			
			var arrButtonInfo = [
				{
					name: "확인",
					func: function() {
						mobileDlg.hideDialog();
						NextS.exitLogin();
					}
				}
			];
			
			mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, strMsg, null, arrButtonInfo);
		}
	} catch (e) {
		dalert(e);
	}
}

String.prototype.byteLength = function() {
    var l= 0;
     
    for(var idx=0; idx < this.length; idx++) {
        var c = escape(this.charAt(idx));
         
        if( c.length==1 ) l ++;
        else if( c.indexOf("%u")!=-1 ) l += 2;
        else if( c.indexOf("%")!=-1 ) l += c.length/3;
    }
     
    return l;
};
var calByte = {
		getByteLength : function(s) {

			if (s == null || s.length == 0) {
				return 0;
			}
			var size = 0;

			for ( var i = 0; i < s.length; i++) {
				size += this.charByteSize(s.charAt(i));
			}

			return size;
		},
			
		cutByteLength : function(s, len) {

			if (s == null || s.length == 0) {
				return 0;
			}
			var size = 0;
			var rIndex = s.length;

			for ( var i = 0; i < s.length; i++) {
				size += this.charByteSize(s.charAt(i));
				if( size == len ) {
					rIndex = i + 1;
					break;
				} else if( size > len ) {
					rIndex = i;
					break;
				}
			}

			return rIndex;
		},
		cutByteBackLength : function(s, len) {

			if (s == null || s.length == 0) {
				return 0;
			}
			var size = 0;
			var rIndex = s.length;

			for ( var i = s.length; i > 0; i--) {
				size += this.charByteSize(s.charAt(i));
				if( size == len ) {
					rIndex = i + 1;
					break;
				} else if( size > len ) {
					rIndex = i;
					break;
				}
			}

			return s.length - rIndex;
		},

		charByteSize : function(ch) {

			if (ch == null || ch.length == 0) {
				return 0;
			}

			var charCode = ch.charCodeAt(0);

			if (charCode <= 0x00007F) {
				return 1;
			} else if (charCode <= 0x0007FF) {
				return 2;
			} else if (charCode <= 0x00FFFF) {
				return 2;
			} else {
				return 2;
			}
		}
	};