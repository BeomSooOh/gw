/*
 * 
 */

onefficeApp.controller("ctrl_sliderFrame", function($scope) {
	
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
	var slideList = [];
	var lastRatio = 1;
	var g_objPageControl_1 = null;;
	$scope.fnloadView = function(fileSeqID,nEditNumber){
		loadEditNumber = nEditNumber;
		currentLoadSeq = fileSeqID;
		$(".totalPageContainerClz").remove();
		//g_readonlyMode = false;
		setTimeout(function () {
			$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, #one_template").width($(window).width());
			$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, .side, .side_right, #one_template ,#viewer_section"  ).height($(window).height());
		}, 1);
		
		onefficeMGW.getFileContent(fileSeqID, 
				function(responseData) 
				{//successCB
					
					var headElem = document.getElementById("dzeditor_1").contentDocument.getElementsByTagName("head")[0];
					if(!initCssLoad){
						insertEditorStyleCSS(headElem);//헤더에 stylesheet 삽입
						//initCssLoad = true;
					}
					
					//viewerMode = true
					dzeUiConfig.bMobileHybridEdit = true;
					setInitUpdateVariable(nEditNumber);
					fnSetEditObject(nEditNumber);
					initEditorEvent(nEditNumber);
					onLoadFileContent(responseData, nEditNumber);
					
//					clearInterval(oneffice.autoSessionCheckTimer);
//					setAutoSave();
//					setAutoCheckSession();
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
	
	$scope.onResizeProc = function(){
		
		
		var mContainer = g_objEditorDocument[1].getElementById('dze_document_main_container')
		var editDocument = g_objEditorDocument[g_nActiveEditNumber].firstChild;
		var docContainer = g_objEditorDocument[g_nActiveEditNumber].getElementsByClassName("dze_document_container")[0];
//		//if(!g_browserCHK.iOS && !g_browserCHK.androidtablet && !g_browserCHK.galaxyfold) return;
		setTimeout(function () {
			var _docHeight = $("#one_slideshow").height()-56;
			var _docWidth  = $("#one_slideshow").width();
			
			var iframeContainer = document.getElementById('dzeditor_1');
		
			var childPageNode = docContainer.childNodes;
			editDocument.style.backgroundColor = "#888888";
			var cHeight = editDocument.clientHeight;
			
			var ratio = _docWidth / docContainer.offsetWidth;
			var ratio_h = (_docHeight-62) / (childPageNode[0].offsetHeight);
			if(ratio_h<ratio){
				ratio = ratio_h;
			}
			if(ratio>1) ratio = 1;
			lastRatio = ratio;
			
			for(var i = 0; i < childPageNode.length; i++) {
				var cnode = childPageNode[i];
				var pHeight = slideList[i].clientHeight * ratio;
				var setmargin = (_docHeight-56 -  pHeight)/2 / ratio;
				if(setmargin<0) setmargin=5;
				slideList[i].style.margin= setmargin+"px auto";
			}
			$scope.$parent.setTotalSlideNum(slideList.length);
			$scope.$parent.setCurrentSlideNum(1);
			
			var newWidth = _docWidth / ratio;
			var newHeight = _docHeight / ratio;
			
			editDocument.style.width = newWidth;
			editDocument.style.height = newHeight;

			editDocument.style.transform = "scale("+ratio+")";
			editDocument.style.transformOrigin = "left top";
			
			iframeContainer.style.width = _docWidth + "px";
			iframeContainer.style.height = _docHeight + "px";
						
		}, 1);
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
			
			if (fileContent.subject == "" && fileContent.content == oneffice.emptyContent) {
				oneffice.bNewFileStart = true;
			}
			
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
			
			if(g_objEditorDocument.length == 0) {
				return ;
			}

			var editDocument = g_objEditorDocument[g_nActiveEditNumber].firstChild;
			var docContainer = g_objEditorDocument[g_nActiveEditNumber].getElementsByClassName("dze_document_container")[0];
			var childPageNode = docContainer.childNodes;
			editDocument.style.backgroundColor = "#888888";
			var cHeight = editDocument.clientHeight;
			
			var ratio = editDocument.offsetWidth / docContainer.offsetWidth;
			var ratio_h = (editDocument.offsetHeight-62) / (childPageNode[0].offsetHeight);
			for(var i = 0; i < childPageNode.length; i++) {
				var cnode = childPageNode[i];
				slideList.push(childPageNode[i]);
				slideList[i].style.position="absolute";
				
				if(i > 0) {
					slideList[i].style.display = "";
					slideList[i].style.opacity = "0";
				} else {
					slideList[i].style.display = "";
					slideList[i].style.opacity = "1";
				}

				slideList[i].style.transition="opacity .3s linear";
				var pHeight = slideList[i].clientHeight * ratio;
				var setmargin = (cHeight-56 -  pHeight)/2 / ratio;
				if(setmargin<0) setmargin=5;
				slideList[i].style.margin= setmargin+"px auto";
			}
			$scope.$parent.setTotalSlideNum(slideList.length);
			$scope.$parent.setCurrentSlideNum(1);
			if(ratio_h<ratio){
				ratio = ratio_h;
			}
			if(ratio>1) ratio = 1;
			lastRatio = ratio;
			var newWidth = editDocument.offsetWidth / ratio;
			var newHeight = editDocument.offsetHeight / ratio;
			
			editDocument.style.width = newWidth;
			editDocument.style.height = newHeight;
			editDocument.style.transform = "scale("+ratio+")";
			editDocument.style.transformOrigin = "left top";
			
			
			var iframeContainer = document.getElementById('dzeditor_1');
			
			iframeContainer.style.height = iframeContainer.clientHeight + "px";
			
			setTimeout(function() {		
				document.getElementById('viewer_header').scrollTop = 0;
				
				
				$(".ui-mobile .ui-page-active").scrollTop( 0 );
			},10);
			
			//모바일 본문내 이미지 경로 재설정
			convertWebSrc(1);
			
			docContainer.style.background = "#888888";
			$('#dzeditor_1').contents().find('body').css('background','#888888');
//			g_objUndoRedo.registerInitialContentStack(nEditNumber);	// redoundo 스택 초기화
			fnCommandReadOnlyMode(nEditNumber, 0);
			g_objPageControl_1 = g_objPageControl;
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
            var styleSheetLink = document.createElement("link");   //UCDOC-1986, 2020-05-21, contents css 추가
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
	
	function goMobileSlide(pNum){
		for(var i = 0; i < slideList.length; i++) {
			
			slideList[i].style.position="absolute";
			
			if(i == pNum-1) {
				slideList[i].style.display = "";
				slideList[i].style.opacity = "1";
			} else {
				slideList[i].style.display = "";
				slideList[i].style.opacity = "0";
			}

		}
	}
	
	$scope.goPageMoveSlider = function(pnum){
		goMobileSlide(pnum);
	}
});
