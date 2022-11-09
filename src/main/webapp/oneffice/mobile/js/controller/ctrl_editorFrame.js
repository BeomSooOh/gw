/*
 * 
 */

onefficeApp.controller("ctrl_editorFrame", function($scope) {
	
	var initCssLoad = false;
	$scope.initEditorFrame = function() {
    	try {
    		g_bCheckImgSrcProperty = false; //QR 이미지 데이터 삭제 오류 이슈 관련
    		fnLoadEditor();
			//$scope.fnloadView($scope.docDataFact.checklist[0].seq);
    	}catch(e){
    		dalert(e);
    	}
	};
	var initCssLoad = false;
	var loadEditNumber = 0;
	var viewerMode = false;
	var currentLoadSeq = "";
	var initEditTouch = false;
	$scope.setChangeEditMode = function(){
		fnCommandEditorMode(loadEditNumber);
		viewerMode = $scope.$parent.viewerMode=='viewerMode'?true:false;
		
		onefficeMGW.setAccessDocument(currentLoadSeq, "W", "1", 360, function(resFileContent) {
			if (resFileContent.access_perm == "R") {
				fnCommandReadOnlyMode(loadEditNumber, 0);
			} else {
			}
		});
		
		if(g_objEditorDocument.length == 0) {
			return ;
		}
		
		var iframeContainer = document.getElementById('dzeditor_0');
		iframeContainer.style.height = iframeContainer.clientHeight-44 + "px";
		
		var frameWidth = $("#dzeditor_0").width();
		
		var editDocument = g_objEditorDocument[g_nActiveEditNumber].firstChild;
		var docContainer = g_objEditorDocument[g_nActiveEditNumber].getElementsByClassName("dze_document_container")[0];
		var wrapelmnt = g_objEditorDocument[0].getElementById("dze_document_main_container");
		var ratio = frameWidth/editDocument.offsetWidth;
		var newWidth = $("#dzeditor_0").width() / ratio;
		var newHeight = $("#dzeditor_0").height() / ratio;
		editDocument.style.width = newWidth;
		editDocument.style.height = newHeight;
		if(!g_browserCHK.androidtablet && !g_browserCHK.iPad){
		 $(docContainer).css('transform-origin','left top');
		 $(docContainer).css('transform',"scale(2)");
		 var initScrollTop = wrapelmnt.scrollTop*2;
		 $(wrapelmnt).scrollTop(initScrollTop);
		 finalScale = $scope.pinchZoomScale = 2;
		}
		
	}
	$scope.fnloadView = function(fileSeqID,nEditNumber){
		loadEditNumber = nEditNumber;
		currentLoadSeq = fileSeqID;
		$(".totalPageContainerClz").remove();
		g_readonlyMode = false;
		setTimeout(function () {
			$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, #one_template").width($(window).width());
			$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, .side, .side_right, #one_template ,#viewer_section"  ).height($(window).height());
		}, 1);
		
		onefficeMGW.getSecurityInfo(fileSeqID, "", function(responseData) {
			if(responseData != 0) {
				// 보안 문서의 경우 암호 체크 후 열람
				checkPasswordAndView(fileSeqID);
			} else {
				onefficeMGW.getFileContent(fileSeqID, 
					function(responseData) 
					{//successCB
						
						var headElem = document.getElementById("dzeditor_0").contentDocument.getElementsByTagName("head")[0];
						if(!initCssLoad){
							insertEditorStyleCSS(headElem);//헤더에 stylesheet 삽입
							//initCssLoad = true;
						}
						
						viewerMode = $scope.$parent.viewerMode=='viewerMode'?true:false;
						dzeUiConfig.bMobileHybridEdit = true;
						setInitUpdateVariable(nEditNumber);
						fnSetEditObject(nEditNumber);
						initEditorEvent(nEditNumber);
						onLoadFileContent(responseData, nEditNumber);
						
						clearInterval(oneffice.autoSessionCheckTimer);
						setAutoSave();
						setAutoCheckSession();
					},

					function() 
					{//errorCB
						if(g_browserCHK.mobile === true) 
						{
							cmnCtrlToast.showToastMsg(null,ID_RES_CONST_STRING_ALREADY_DELETED_DOCUMENT,1000);
						} 
						else 
						{
							cmnCtrlToast.showToastMsg(null, ID_RES_CONST_STRING_ALREADY_DELETED_DOCUMENT, 3, "screen_center");
							setTimeout(function() {
								if(!onefficeWE) {
									document.location.href = oneffice.drivePath;
								}
							},3500);
						}
						return;
					}
				);
			}
		});	
		
	}
	
	function checkPasswordAndView(fileSeq) {
		try {
			
			
			var nDialogType = mobileDlg.DIALOG_TYPE.INPUT_TEXT;
			
			var arrButtonInfo = [
				{
					name: "취소",
					func: function() {
						mobileDlg.hideDialog();
						$scope.cancelViewing();
					}
				},
				{
					name: "확인",
					func: function() {
						checkPasswordInputValueOnView(fileSeq);
						mobileDlg.hideDialog();
					}
					
				}
			];
			
			var strTitle = "문서보안 열기";
			var strPassWord = "암호를 입력하세요.";
			
			mobileDlg.showDialog(nDialogType, strPassWord, strTitle, arrButtonInfo);
			
		} catch(e) {
			dalert(e);
		}
	}
	
	function checkPasswordInputValueOnView(fileSeq) {
		try {
			var inputPassword = document.getElementById("dlg_text_input");

			onefficeMGW.getSecurityInfo(fileSeq, inputPassword.value, function(responseData) {
				// 2인 경우만 암호가 일치하는 경우이므로 그 외에는 알람 출력 및 암호를 재입력
				if(responseData != 2) {
					if(g_browserCHK.mobile)
						cmnCtrlToast.showToastMsg(null, ID_RES_CONST_STRING_NOTI_CHECK_PASSWORD_ERROR, 2);
					else
						alert(ID_RES_CONST_STRING_NOTI_CHECK_PASSWORD_ERROR);

					inputPassword.focus();
					inputPassword.setSelectionRange(0, inputPassword.value.length);
				} else {
					duzon_dialog.closeDialog();

					var htmlContainer = document.createElement("div");
					onefficeMGW.getFileContent(fileSeq, 
							function(responseData) 
							{//successCB
								
								var headElem = document.getElementById("dzeditor_0").contentDocument.getElementsByTagName("head")[0];
								if(!initCssLoad){
									insertEditorStyleCSS(headElem);//헤더에 stylesheet 삽입
									//initCssLoad = true;
								}
								
								viewerMode = $scope.$parent.viewerMode=='viewerMode'?true:false;
								dzeUiConfig.bMobileHybridEdit = true;
								setInitUpdateVariable(loadEditNumber);
								fnSetEditObject(loadEditNumber);
								initEditorEvent(loadEditNumber);
								onLoadFileContent(responseData, loadEditNumber);
								
								clearInterval(oneffice.autoSessionCheckTimer);
								setAutoSave();
								setAutoCheckSession();
							},

							function() 
							{//errorCB
								if(g_browserCHK.mobile === true) 
								{
									cmnCtrlToast.showToastMsg(null,ID_RES_CONST_STRING_ALREADY_DELETED_DOCUMENT,1000);
								} 
								else 
								{
									cmnCtrlToast.showToastMsg(null, ID_RES_CONST_STRING_ALREADY_DELETED_DOCUMENT, 3, "screen_center");
									setTimeout(function() {
										if(!onefficeWE) {
											document.location.href = oneffice.drivePath;
										}
									},3500);
								}
								return;
							}
						);
				}
			});
		} catch(e) {
			dalert(e);
		}
	}
	
	$scope.onResizeProc = function(){
		
		var mContainer = g_objEditorDocument[0].getElementById('dze_document_main_container')
//		var contaninerHtml = g_objEditorDocument[0].getElementsByTagName('html')[0];
//		var _heightHtml = contaninerHtml.style.height;
//		contaninerHtml.style.height = null;
//		setTimeout(function () {
//			contaninerHtml.style.height = _heightHtml;
//			
//		}, 50);
		
			
				
		if(!g_browserCHK.iOS && !g_browserCHK.androidtablet && !g_browserCHK.galaxyfold) return;
		
		setTimeout(function () {
			var _docHeight = $("#viewerFrameContainer").height();
			var _docWidth  = $("#viewerFrameContainer").width();
			
//			$(mContainer).width(_docWidth);
//			$(mContainer).height(_docHeight);
			
			if(g_objEditorDocument.length == 0) {
				return ;
			}

			var editDocument = g_objEditorDocument[0].firstChild;
			var docContainer = g_objEditorDocument[0].getElementsByClassName("dze_document_container")[0];

			var ratio = _docWidth / docContainer.offsetWidth;
			
			if(ratio>1) ratio = 1;
			var newWidth = _docWidth / ratio;
			var newHeight = _docHeight / ratio;
			
			editDocument.style.width = newWidth;
			editDocument.style.height = newHeight;
			editDocument.style.transform = "scale("+ratio+")";
			editDocument.style.transformOrigin = "left top";
			
//			$(docContainer).width(_docWidth);
//			$(docContainer).height(_docHeight);
			var iframeContainer = document.getElementById('dzeditor_0');
			
			iframeContainer.style.height = _docHeight + "px";
			iframeContainer.style.width = _docWidth + "px";
			    // Resize
			
		}, 1);
	}
	
	var finalScale = null;
	
	function bindTouchEvent(){
		var start_h;
		
		var initPinch = false;
		var initStartPosX =0;
		var initStartPosY =0;
		var initScrollTop =0;
		var initScrollLeft =0;
		
		var wrapelmnt = g_objEditorDocument[0].getElementById("dze_document_main_container");
		var targetelemnt = g_objEditorDocument[0].getElementsByClassName("dze_document_container")[0];
		var divRowgroupControl = document.getElementById("divRowgroupCtrl");
		var startOffset = 0;
		var editDocument = g_objEditorDocument[g_nActiveEditNumber].firstChild;
		var docContainer = g_objEditorDocument[g_nActiveEditNumber].getElementsByClassName("dze_document_container")[0];
		if(g_browserCHK.iOS && !g_browserCHK.iPad){
			targetelemnt.style.overflow = "hidden";
		}
		var ratio = editDocument.offsetWidth / docContainer.offsetWidth;
		var testText ="";
		$(window).scroll(function(event){ 
			var iOSMenuOffset = 0;
			iOSMenuOffset = window.scrollY;
			$('#viewer_header').css('top',iOSMenuOffset+'px');
			$('.quickEditContainer').css('top',56+iOSMenuOffset+'px');
		});

		$('#dzeditor_0').contents().find('.dze_document_container').bind('touchstart', function(event){
//			if(g_browserCHK.iPad) return;
			var touches = event.originalEvent.touches;
			console.log(event)
			if (touches.length >1) {
				start_y1 = touches[0].screenY + wrapelmnt.scrollTop*ratio
				start_x1 = touches[0].screenX;+ wrapelmnt.scrollLeft*ratio
				start_y2 = touches[1].screenY + wrapelmnt.scrollTop*ratio
				start_x2 = touches[1].screenX;+ wrapelmnt.scrollLeft*ratio
				start_h = Math.abs(start_y1-start_y2);
				
				initScrollTop = wrapelmnt.scrollTop;
				initScrollLeft = wrapelmnt.scrollLeft;
				var cposX = (start_x1+start_x2)/2
				var cposY = (start_y1+start_y2)/2
				
				initStartPosX = (cposX/wrapelmnt.scrollWidth);
				initStartPosY = (cposY/wrapelmnt.scrollHeight);
				
				
				$(targetelemnt).css('transform-origin','left top');
				$(targetelemnt).css('height','auto');
				g_objTableMiniMenu.showTableMiniMenu(false, null, 0);
				
				initPinch = true;
				startOffset = 0;
			}else if(initEditTouch && !viewerMode){
				initEditTouch = false;
				initScrollTop = wrapelmnt.scrollTop*2;
				initScrollLeft = wrapelmnt.scrollLeft*2;
				$(targetelemnt).css('transform-origin','left top');
				$(targetelemnt).css('transform',"scale(2)");
				
				var _target = event.originalEvent.target;
				var _top =  (touches[0].clientY)*2;
				var _left = touches[0].clientX*2;
				
				$(wrapelmnt).scrollTop(_top+initScrollTop);
				$(wrapelmnt).scrollLeft(_left + initScrollLeft);
				
				finalScale = $scope.pinchZoomScale = 2;
				
			}
		});
		
		
		$('#dzeditor_0').contents().find('.dze_document_container').bind('touchmove', function(event){
//			if(g_browserCHK.iPad) return;
			var touches = event.originalEvent.touches;
			if (touches.length >1) {
				if(!initPinch) return;
				ny1 = touches[0].screenY;
				ny2 = touches[1].screenY;
				ny_h = Math.abs(ny1-ny2);
				
				var _scale = ny_h/start_h;
				if(finalScale*_scale <1) {
					$scope.pinchZoomScale  = 1;
				}
				if(finalScale>1){
					if(finalScale*_scale <1){
						$scope.pinchZoomScale = 1;
					}else{
						$scope.pinchZoomScale = finalScale*_scale;
					}
					
				}else if(finalScale*_scale <1){
					$scope.pinchZoomScale = 1;
				}else{
					$scope.pinchZoomScale = _scale;
				}
				$(targetelemnt).css('transform',"scale("+$scope.pinchZoomScale+")");
				var changeX = (wrapelmnt.scrollWidth*initStartPosX)-(targetelemnt.clientWidth*initStartPosX);
				var changeY = (wrapelmnt.scrollHeight*initStartPosY)-(targetelemnt.clientHeight*initStartPosY);
				
				if(startOffset==0){
					startOffset = changeY;
				}
				var _mx = initScrollLeft + changeX;
				var _my = initScrollTop + changeY -startOffset;
				$(wrapelmnt).scrollTop(_my);
				$(wrapelmnt).scrollLeft(_mx);
			
				
			}
		});
		
		$('#dzeditor_0').contents().find('.dze_document_container').bind('touchend', function(event) {
			var touches = event.originalEvent.touches;
			if (fnObjectCheckNull($scope.pinchZoomScale) === false) {
				finalScale = $scope.pinchZoomScale;
				
				if (finalScale <= 1) {
					$scope.pinchZoomScale = 1;
					$(targetelemnt).css('transform',"scale(" + $scope.pinchZoomScale + ")");
				}
				
				initPinch = false;
				
				var childRowContorls =  $("#divRowgroupCtrl").children();
				
				for(var ix = 0; ix < childRowContorls.length; ix++) {
					var child = childRowContorls[ix];
					
					$(child).css('transform-origin','left top');
					$(child).css('transform',"scale(" + $scope.pinchZoomScale.toFixed(2) + ")");
				}
			}	
		});
		
		var isScrolling;
		var content = $('#dzeditor_0').contents().find('#dze_document_main_container')[0];
		content.addEventListener('scroll', function(event) {
			clearTimeout(isScrolling);
			if(!viewerMode){
				$(".ico_topScroll").css("bottom","-50px");
				return;
			}
			if(this.scrollTop>0){
				$(".ico_topScroll").css("bottom","10px");
				isScrolling = setTimeout(function() {
					$(".ico_topScroll").css("bottom","-50px");
				
				}, 2000);

			}else{
				$(".ico_topScroll").css("bottom","-50px");
			}
			
		})
		//ios 스크롤 바운스 핀치 떨림 보정
		if(g_browserCHK.iOS){
//			if(g_browserCHK.androidtablet || g_browserCHK.iPad) return;
		
			
			content.addEventListener('scroll', function(event) {
				  this.allowUp = (this.scrollTop < 0);
				  this.allowLeft = (this.scrollLeft < 0);
				  this.allowDown = (this.scrollTop > this.scrollHeight - this.clientHeight);
				  this.allowRight = (this.scrollLeft > this.scrollWidth - this.clientWidth);
				  if(this.allowUp){
						this.scrollTop = 0;
				  }
				  if(this.allowLeft){
						this.scrollLeft = 0;
				  }
				  if(this.allowDown){
						this.scrollTop = this.scrollHeight - this.clientHeight;
				  }
				  if(this.allowRight){
						this.scrollLeft = this.scrollWidth - this.clientWidth;
				  }
			})
			content.addEventListener('touchstart', function(event) {
			    this.allowUp = (this.scrollTop > 0);
			    this.allowLeft = (this.scrollLeft > 0);
			    this.allowDown = (this.scrollTop < this.scrollHeight - this.clientHeight);
			    this.allowRight = (this.scrollLeft < this.scrollWidth - this.clientWidth);
			    this.slideBeginY = event.pageY;
			    this.slideBeginX = event.pageX;
			    testText = "";
			});

			content.addEventListener('touchmove', function(event) {
				
				var up = (event.pageY > this.slideBeginY);
			    var down = (event.pageY < this.slideBeginY);
			    var left = (event.pageX > this.slideBeginX);
			    var right = (event.pageX < this.slideBeginX);
			    this.slideBeginY = event.pageY;
			    this.slideBeginX = event.pageX;
			    
			    if ((up && this.allowUp) || (down && this.allowDown) || (left && this.allowLeft) || (right && this.allowRight)) {
			        event.stopPropagation();
			    }
			    else {
			        event.preventDefault();
			    }
			   
			});
		}
	}

	function onLoadFileContent(resFileContent, nEditNumber) {
		try {
			var bSave = false;
			
//1.
			if (!resFileContent) {
				dzeLayoutControl.setReadonlyMode(true, nEditNumber);
				alert(ID_RES_CONST_STRING_INVALID_CALL);
			}
//2.
			var resData = "";
			g_objPageControl.documentContainerNode = null;
			var fileContent = resFileContent;
			oneffice.parentFileContent = cloneSimpleObject(fileContent);
			oneffice.currFileSeq		= fileContent.seq;
			oneffice.currFolderSeq		= fileContent.folderSeq;
			oneffice.currFileSubject	= fileContent.subject;
			oneffice.currFileOpenDate   = fileContent.hasOwnProperty('openFileDate')?fileContent.openFileDate:null;
			oneffice.currFilePath       = fileContent.hasOwnProperty('openPath')?fileContent.openPath:null;
			
			if (typeof(fileContent.regdate) == "object") {
				oneffice.currFileRegDate = getFullDateFromTimeStamp(fileContent.regdate.time);
			} else {
				oneffice.currFileRegDate	= fileContent.regdate;
			}
			
			if (typeof(fileContent.moddate) == "object") {
				oneffice.currFileModDate	= getFullDateFromTimeStamp(fileContent.moddate.time);
			} else {
				oneffice.currFileModDate	= fileContent.moddate;
			}
			
			oneffice.currFileOwnerId	= fileContent.owner_id;

            onefficeUtil.savedContent = fileContent.content;  //현재 문서의 내용을 oneffice.savedContent 에 저장한다.

            if (fileContent.subject == "" && fileContent.content == oneffice.emptyContent) {
				oneffice.bNewFileStart = true;
                oneffice.bNewFileStartSavedContent = fileContent.content;
			}

			updateSecurityButtonByStatus(nEditNumber);	// 암호 설정 여부에 따라서 버튼 이미지 설정
			resData = fileContent.content;
			
			setEditorHTMLCode(resData, false, nEditNumber);
			
            var docProperty = dzeLayoutControl.getCustomPropertyEle(nEditNumber, "dze_doc_property");
			var savedDocNo = dzeLayoutControl.getDocumentNoProperty(nEditNumber);
			
			if (savedDocNo === oneffice.MERGE_DOC) {	//UCDOC-906, 문서병합하여 새문서 만들기시, 이미지 src를 교체하지 않음
				oneffice.bMadeByMerge = true;
			} else if (savedDocNo !== oneffice.currFileSeq) {
				oneffice.bMadeByCopy = true;
				oneffice.strSavedDocNo = savedDocNo;
			}
			
			// Template Contents Open
			var strTempCategory = docProperty.getAttribute("temp_category");
			
			if (fnObjectCheckNull(strTempCategory) === false) {
				if (strTempCategory === "회의록") {
					var autoDatePTag = g_objEditorDocument[0].getElementById("idx_auto_date");
					
					if (autoDatePTag) {
						var today = new Date();
						var dd = today.getDate();
						var mm = today.getMonth()+1; //January is 0!
						var yyyy = today.getFullYear();
						var strDay;
						var nHour = today.getHours();
						var nMin = today.getMinutes();
						
						switch (today.getDay()) {
							case 0:		strDay = "일";	break;
							case 1:		strDay = "월";	break;
							case 2:		strDay = "화";	break;
							case 3:		strDay = "수";	break;
							case 4:		strDay = "목";	break;
							case 5:		strDay = "금";	break;
							case 6:		strDay = "토";	break;
						}
						
						autoDatePTag.textContent = yyyy + "년 " + mm + "월 " + dd + "일 " + "(" + strDay + ") " + nHour + ":" + nMin;
						autoDatePTag.id = "";
						
						g_objCaretUtil.moveCaret(autoDatePTag, false, false);
					}
					
					var autoWriterPTag = g_objEditorDocument[0].getElementById("idx_auto_writer");
					
					if (autoWriterPTag) {
						autoWriterPTag.textContent = $scope.myInfo.name;
						autoWriterPTag.id = "";
					}
				}
				
				g_objPageControl.syncUpdatePageAll();
                bSave = true;
			}
			
			dzeLayoutControl.setDocPgOverflow(nEditNumber);
			dzeUiConfig.bOfficeOnePageLongMode = dzeLayoutControl.getOnePageModeProperty(nEditNumber);
			
			dzeLayoutControl.applyPaperSizeProperty(nEditNumber);
			dzeLayoutControl.setDocPageColor(nEditNumber);
			g_objZoom.setConfigDocZoomPropertyInfo(nEditNumber);
			dzeLayoutControl.setDocWatermarkSrcFromDocProperty(nEditNumber);
            g_objHeaderFooter.importHeaderFooterAttribute(docProperty);	//header/footer initialize (UCDOC-576)
			g_objHeaderFooter.setHeaderOverflowBlinderStyle();   //header 가림막 스타일 설정 (UCDOC-576)
			g_objPageNumber.import(docProperty);	//페이지 번호 (UCDOC-1171)
			
			dzeLayoutControl.setDocPrintMargin(nEditNumber);    //docProperty가 제거 됨
            docProperty = null;
			
			//onefficeApp.setCurrFileInfo(oneffice.currFileSeq, oneffice.currFolderSeq, oneffice.currFileSubject, oneffice.currFileRegDate, oneffice.currFileModDate);
			
//			initializeDocFocus(nEditNumber);	//first element focusing
			dzeLayoutControl.setEditAreaSize(nEditNumber, true);
			
			if (dzeUiConfig.bOfficePagingMode) {
				g_objPageControl.initializeMultiPageMode(nEditNumber);
			}
			
			if (dzeUiConfig.bOfficeOnePageLongMode === true) {
				g_objPageControl.changePageMode(true);
			}
			
			changeCss(".editorContainer", "opacity", "1", document);	//UCDOC-846//view edit area
			g_objWrapperOutlineUtil_Improved.initWrapperOutlineUtil();
			
			if (typeof(fileContent.readonly) == "undefined") {
				fileContent.readonly = 0;
			}
			
			var accessMode = "W";
			accessMode = $scope.$parent.viewerMode=='viewerMode'?"R":"W";
			if (fileContent.readonly == 1 || (fileContent.share_perm == "R" && fileContent.my_id != fileContent.owner_id)) {
				fnCommandReadOnlyMode(nEditNumber, 0);
				onefficeMGW.setAccessDocument(fileContent.seq, "R", "1", 360, function(resFileContent) {});	// 로깅용...
			} else if ((fileContent.share_type == 9 || fileContent.share_id) && fileContent.share_perm == "W" && fileContent.my_id != fileContent.owner_id) {
				if (dzeUiConfig.bMobileHybridEdit == true) {
					accessMode = "M";	// 모바일 편집 모드 정의
				}
				
				onefficeMGW.setAccessDocument(fileContent.seq, accessMode, "1", 360, function(resFileContent) {
					if(resFileContent.access_perm == "R") {
						fnCommandReadOnlyMode(nEditNumber, 0);
						onefficeMGW.viewDocumentAccessInfo(oneffice.currFileSeq);
					} else {
						onefficeMGW.setTimerDocumentAccessStatus(accessMode, fileContent);
					}
				});
			} else {
				if (dzeUiConfig.bMobileHybridEdit == true) {
					//accessMode = "M";	// 모바일 편집 모드 정의
				}
				
				onefficeMGW.setAccessDocument(fileContent.seq, accessMode, "1", 360, function(resFileContent) {
					
					if (resFileContent.access_perm == "R") {
						fnCommandReadOnlyMode(nEditNumber, 0);
//						onefficeMGW.viewDocumentAccessInfo(fileContent.seq);
					} else {
						//onefficeMGW.setTimerDocumentAccessStatus(accessMode, fileContent);
					}
				});
			}
			
			// 읽기 전용의 경우 알림, 그 외에는 눈금자 출력			
			fnHandler_viewRulerbar(null, null, nEditNumber);
			
			if (g_readonlyMode === true) {
				onefficeUtil.setReadonlyNotificationBar(nEditNumber);
			}
			
			g_objZoom.initDocZoomPropertyInfo(nEditNumber);	//전체 컨텐츠 구성 완료 후 page Zoom 초기화
			
			//UCDOC-1315, "--- 페이지 나누기 ---" 보임/숨김
			g_objPageControl.changeCssPageBreakAfter(nEditNumber);

            g_objVideoControl.setReadOnly(nEditNumber);    //비디오 초기화 (UCDOC-1616)

            // 문서 오픈 시 placeholder text 추가 (UCDOC-589)
            if(g_readonlyMode) {
                g_objPlaceholder.removeAllPlaceholderText(g_objEditorDocument[nEditNumber].body);
            }
            else {
                g_objPlaceholder.setAllPlaceholderText(g_objEditorDocument[nEditNumber].body);
            }

			onefficeCommon.accessUserFunction("openDoc");// 사용기록 서버 등록			
			onefficeCommon.accessDocumentHistory(oneffice.currFileSeq, CLOUD_CONST_HISTORY_ACTIONCODE_OPEN);// History 서버 등록
			
			setTimeout(function() {	// 컴텐츠가 복사 된 경우 or 새 문서가 아닌 경우, 문서 내 컨텐츠 리스트 전송
				if (oneffice.bNewFileStart === false) {
					if (oneffice.bMadeByCopy === true) {
						// 사본에 qr code가 삽입되어 있을 경우 삭제 후 재삽입 처리
						onefficeUtil.renewDocumentQRCode();
						
					//	onefficeMGW.exchangeContentsListInfo(true, oneffice.strSavedDocNo);
					} else {
					//		onefficeMGW.exchangeContentsListInfo(true);
					}
				}
			},3000);
			
			dzeUiConfig.bTBPreviewLetterOperation = false;// 미리보기 효과 제거
			
			setTimeout(function() {// 스크롤 최상위로
				g_objEditorDocument[0].getElementById('dze_document_main_container').scrollTop = 0;
				g_objEditorDocument[0].getElementById('dze_document_main_container').focus();
			},10);
			
			g_objOnefficeEditor.isDocumentLoaded = true;
			
			var editDocument = g_objEditorDocument[g_nActiveEditNumber].firstChild;
			var docContainer = g_objEditorDocument[g_nActiveEditNumber].getElementsByClassName("dze_document_container")[0];

			var ratio = editDocument.offsetWidth / docContainer.offsetWidth;
//			
//			docContainer.style.transform = "scale("+ratio+")";
//			docContainer.style.transformOrigin = "left top";
			
			var iframeContainer = document.getElementById('dzeditor_0');
			
			iframeContainer.style.height = iframeContainer.clientHeight + "px";
			
			setTimeout(function() {		
				document.getElementById('viewer_header').scrollTop = 0;
				
				
				$(".ui-mobile .ui-page-active").scrollTop( 0 );
			},10);
			
			//모바일 본문내 이미지 경로 재설정
			convertWebSrc();
			
			if (bSave) {	//1) 템플릿으로 문서 오픈 된 경우, 2) wehago 사업분석 보고서로 오픈된 경우, 오픈 후 즉시 저장 UCDOC-1464
                var currContent = getEditorHTMLCode(false, nEditNumber, true);
				
				onefficeMGW.saveFile(oneffice.currFileSeq, oneffice.currFolderSeq, oneffice.currFileSubject, currContent, nEditNumber, function() {
					onefficeUtil.setSavedContent(currContent);
					onefficeMGW.setCurrFileInfo(oneffice.currFileSeq, oneffice.currFolderSeq, oneffice.currFileSubject, oneffice.currFileRegDate);
				}, true);
            }
			
			$('#dzeditor_0').contents().find('body').css('background','#F6F7F9');
			g_objUndoRedo.registerInitialContentStack(nEditNumber);	// redoundo 스택 초기화
			
//			$('#dzeditor_0').contents().find('body').css('display','block');
//			$('#dzeditor_0').contents().find('body').css('width','1400px');
//			$('#dzeditor_0').contents().find('body').css('height','2600px');
//			$('#dzeditor_0').contents().find('body').css('position','absolute');
			bindTouchEvent();
			 if($scope.$parent.viewerMode === "viewerMode"){
				 fnCommandReadOnlyMode(nEditNumber, 0);
			 }else if(!g_browserCHK.androidtablet && !g_browserCHK.iPad){
				 $(docContainer).css('transform-origin','left top');
				 $(docContainer).css('transform',"scale(2)");
				finalScale = $scope.pinchZoomScale = 2;
			 }
			 
		} catch (e) {
			dalert(e);
		}
	}
	
	function insertEditorStyleCSS(headElem)
	{       
		try
		{
			var metaObj = document.createElement("meta");
			metaObj.setAttribute("name", "viewport");
			metaObj.setAttribute("content","width=device-width, user-scalable=0, initial-scale=1.0 , maximum-scale=1.0 , minimum-scale=1.0");

			//contents.css
			var styleSheetLink = document.createElement("link");       //UCDOC-1986, 2020-05-21, contents.css 파일 추가
			styleSheetLink.setAttribute("rel", "stylesheet");
			styleSheetLink.setAttribute("type", "text/css");                
			var strCssFilePath = g_strContentsCSS + "?ver=" + objOnefficeLoader.getVer();
			styleSheetLink.setAttribute("href", strCssFilePath);
			headElem.appendChild(styleSheetLink);

			//editor_style_inherit.css
			styleSheetLink = document.createElement("link");
			styleSheetLink.setAttribute("rel", "stylesheet");
			styleSheetLink.setAttribute("type", "text/css");
			strCssFilePath = dzeEnvConfig.strPath_CSS + "editor_style_inherit.css?ver="+objOnefficeLoader.getVer();
			styleSheetLink.setAttribute("href", strCssFilePath);
//			headElem.appendChild(metaObj);
			headElem.appendChild(styleSheetLink);

		   	//style
			var styleEle = document.createElement("style");

			//initalize g_strBody...
			if(!g_strBodyFontFamily)
			{
	            //*** skintool.js, setCustomDisplay() 에도 동일한 초기화 코드가 있으므로, 같이 수정 처리 필요 ***/
				if(dzeUiConfig.strCustomBodyFontFamily.length) {
					if(objOnefficeLoader.m_bDomainDuzon === false)
						dzeUiConfig.strCustomBodyFontFamily = "맑은 고딕";

					g_strBodyFontFamily = quoteFontFamily(dzeUiConfig.strCustomBodyFontFamily.replace(/[\"\']/g, ""));		//UBA-37149
				} else
					g_strBodyFontFamily = "돋움, Dotum, 굴림, Gulim, sans-serif";
			}

			if(!g_strBodyFontSize)
			{
				if(dzeUiConfig.strCustomBodyFontSize.length)
					g_strBodyFontSize = dzeUiConfig.strCustomBodyFontSize;
				else
					g_strBodyFontSize = "11pt";
			}

			if(!g_strBodyLineHeight)
				g_strBodyLineHeight = dzeUiConfig.strCustomBodyLineHeight;

			if(!g_strBodyLetterSpacing)
				g_strBodyLetterSpacing = dzeUiConfig.strCustomBodyLetterSpacing;

			
			g_strBodyFontFamily = "'[더존] 본문체 30'";
			var initHTML = GetInitStyleString(true);

			styleEle.innerHTML = initHTML;
			headElem.appendChild(styleEle);
		}
		catch(e)
		{
			dalert(e);
		}
	}
});
