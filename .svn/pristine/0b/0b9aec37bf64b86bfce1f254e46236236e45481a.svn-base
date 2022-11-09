/*
 * 
 */

onefficeApp.controller("ctrl_viewerFrame", function($scope) {
	
	$scope.pinchZoomScale = 1;
	$scope.initViewerFrame = function() {
    	try {
			//$scope.fnloadView($scope.docDataFact.checklist[0].seq);
    	}catch(e){
    		dalert(e);
    	}
	};
	
	$scope.fnloadView = function(fileSeqID,objParam){
		
		setTimeout(function () {
			$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, #one_template").width($(window).width());
			$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, .side, .side_right, #one_template ,#viewer_section"  ).height($(window).height());
		}, 1);
		
		for (var i = totalStyleNumber; i<document.styleSheets.length; i++)
		{
			 document.styleSheets[i].disabled=true;
		}
		
		g_browserCHK.mobile = true;
		$(".totalPageContainerClz").remove();
		$scope.viewObjParam = objParam;
		var htmlContainer = document.createElement("div");
		onefficeMGW.getSecurityInfo(fileSeqID, "", function(responseData) {
			if(responseData != 0) {
				// 보안 문서의 경우 암호 체크 후 열람
				checkPasswordAndView(fileSeqID);
			} else {
				onefficeMGW.getFileContent(fileSeqID, 
					function(fileContent) 
					{//successCB
					
					
						fnLoadViewModeSuccessCB(fileContent,htmlContainer);
						
						setAutoCheckSession();
						
						// 사용기록 서버 등록
						onefficeMGW.accessUserFunction("openDoc");
						
						onefficeMGW.getMyInfo(
							function(myInfoData) {
								if(typeof(myInfoData) == "undefined") {
									oneffice_cloud_myInfoData = null;
								} else {
									oneffice_cloud_myInfoData = myInfoData;
									
									// History 서버 등록
									onefficeMGW.accessDocumentHistory(fileSeqID, CLOUD_CONST_HISTORY_ACTIONCODE_OPEN);
								}
							}, false);
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
	
	$scope.onResizeProc = function(){
		var ww = window.screen.width;
		var mw = 800;
		try {
		    mw = document.getElementById("totalPageContainer").firstChild.offsetWidth;
		} catch(e) {
		    mw = 800;
		}
		var ratio =  ww / mw;
		if(ratio>1) ratio=0.99;
		
		var wh  = window.screen.height-120;
		
		var mh  = 1090;
		try {
			mh = document.getElementById("totalPageContainer").firstChild.offsetHeight;
		} catch(e) {
			mh = 1024;
		}
		
		var ratio_h = wh / mh;
		
//		if(ratio_h<ratio){
//			ratio = ratio_h;
//		}
		
		resizeOnHybridView(ratio);
	}
	
	
	var start_h;
	var finalScale = null;
	var initPinch = false;
	var initStartPosX =0;
	var initStartPosY =0;
	var initScrollTop =0;
	var initScrollLeft =0;
	var startOffset = 0;
	$("#viewerFrame").touchstart(function(event) {
//		if(g_browserCHK.iPad) return;
		var touches = event.originalEvent.touches;
		var wrapelmnt = document.getElementById("viewerFrameContainer");
		if (touches.length >1) {
			start_y1 = touches[0].screenY+wrapelmnt.scrollTop;
			start_x1 = touches[0].screenX+wrapelmnt.scrollLeft;
			start_y2 = touches[1].screenY+wrapelmnt.scrollTop;
			start_x2 = touches[1].screenX+wrapelmnt.scrollLeft;
			start_h = Math.abs(start_y1-start_y2);
			
			
			
			var cposX = (start_x1+start_x2)/2
			var cposY = (start_y1+start_y2)/2
			initStartPosX = (cposX/wrapelmnt.scrollWidth);
			initStartPosY = (cposY/wrapelmnt.scrollHeight);
			initScrollTop = wrapelmnt.scrollTop;
			initScrollLeft = wrapelmnt.scrollLeft;
			
			$("#viewerFrame").css('transform-origin','left top');
			initPinch = true;
			startOffset = 0;
		}
	}).touchmove(function(event) {
//		if( g_browserCHK.iPad) return;
		var touches = event.originalEvent.touches;
		if (touches.length >1) {
			if(!initPinch) return;
			ny1 = touches[0].screenY;
			ny2 = touches[1].screenY;
			ny_h = Math.abs(ny1-ny2);
			
			
			var _scale = ny_h/start_h;
			if(finalScale>1){
				$scope.pinchZoomScale = finalScale*_scale;
			}else{
				$scope.pinchZoomScale = _scale;
			}
			
			$("#viewerFrame").css('transform',"scale("+$scope.pinchZoomScale+")");
			var wrapelmnt = document.getElementById("viewerFrameContainer");
			
			var changeX = (wrapelmnt.scrollWidth*initStartPosX)-(wrapelmnt.clientWidth*initStartPosX);
			var changeY = (wrapelmnt.scrollHeight*initStartPosY)-(wrapelmnt.clientHeight*initStartPosY);
			console.log(wrapelmnt.scrollHeight + "::" + wrapelmnt.clientHeight + "::"+changeY);
//			var changeY = initStartPosY * 20;
			
			if(startOffset==0){
				startOffset = changeY;
			}
			$("#viewerFrameContainer").scrollLeft(initScrollLeft+changeX);
			$("#viewerFrameContainer").scrollTop(initScrollTop+changeY-startOffset);
			
			
		}
	}).touchend(function() {
//		if( g_browserCHK.iPad) return;
		finalScale = $scope.pinchZoomScale;
		
		if(finalScale<=1){
			$scope.pinchZoomScale =1;
			$("#viewerFrame").css('transform',"scale("+$scope.pinchZoomScale+")");
		}
		initPinch = false;
	});
	
	var g_OrgPrintMarginHTML = "";
	var g_DirectShowMode = false;
	var g_HybridViewMode = false;

	var total_page_height = 0;
	var total_page_no = 1;
	var g_chartIDS = [];

	var slideList = [];
	var g_slideNo = 1;
	var totalSlideCount = 1;
	var g_bSlideMode = false;
	//Grab Icon변경시 복구 하기 위해서 설정하는 값을 기억 해 두자.
	var g_cursorStyle = 0;

	var g_ZoomRatioIndex = 0;
	var currentSlideIndex = 1;

	function fnLoadViewModeSuccessCB(fileContent,htmlContainer)
	{
		try
		{
			total_page_height = 0;
			$(".totalPageContainerClz").remove();
			
			var imgs = null;
			var chartTag = null;
			var content = fileContent.content;
			
			htmlContainer.innerHTML = content;//DATA GET END
			oneffice.currFileSubject = fileContent.subject;//DATA GET END
			oneffice.currFileSeq = fileContent.seq;
			oneffice.parentFileContent = fileContent;
			oneffice.onefficeGroupSeq = $scope.myInfo.group_seq;
			
			// link & style
			var headElem = document.getElementsByTagName("head")[0];
			
			$(headElem).find("link.viewer_container").remove();
			$(headElem).find("style.viewer_container").remove();
			
			insertEditorStyleCSS(headElem);
			
			//dze_doc_property import
			setCustomEleInfo(htmlContainer,headElem);

			var titleElem = document.getElementsByTagName("title")[0];
			if ( typeof(oneffice.currFileSubject) != "undefined" && oneffice.currFileSubject != null && oneffice.currFileSubject != "") //title.
			{
				titleElem.innerHTML =  oneffice.currFileSubject + " - ONEFFICE VIEWER";
			} else {
				titleElem.innerHTML =  "ONEFFICE VIEWER";
			}

			//화면에 그려지고 이동하느것이 보이지 않도록 박스를 투명처리
			//changeCss(".dze_printpreview_pagebox", "opacity", "0", document);
			//화면에 문서를 그린다.
			
			document.getElementById("viewerFrame").style.opacity = "0";
			document.getElementById("viewerFrame").scrollTop = 0;
			document.getElementById("viewerFrame").style.overflowX = "hidden";
			
			seperatePage(fileContent, htmlContainer);

			imgs = document.getElementsByTagName('img');
			for (var i = 0 ; i < imgs.length; i++)
			{
				 imgs[i].getAttribute('chart_data');
				if (chartTag !== null) {
					imgs[i].style.visibility = 'hidden';
				}
			}

			//출력시에 보이지 않아야 하는 태그들 치환 처리
			replaceEditorTempTagsFromEditor(0, document);		


			//화면에 그려지고 이동하는것이 끝나면 투명했던 박스를 다시 보이도록 처리
			//changeCss(".dze_printpreview_pagebox", "opacity", "1", document); 
			
			
			var totalPageContainer = document.createElement("div");
			totalPageContainer.id = "totalPageContainer";
			totalPageContainer.classList.add("totalPageContainerClz");
			totalPageContainer.style.display = "none";
			document.getElementById("viewerFrame").appendChild(totalPageContainer);
			
			var pageboxes = document.getElementById("viewerFrame").getElementsByClassName("dze_printpreview_pagebox");
			total_page_no = pageboxes.length;
			for(var i = total_page_no-1; i >= 0; i--) {
				
				if(totalPageContainer.childNodes.length == 0) {
					totalPageContainer.appendChild(pageboxes[i]);
				} else {
					totalPageContainer.insertBefore(pageboxes[i],totalPageContainer.childNodes[0]);
				}
				
				total_page_height += pageboxes[i].offsetHeight + 15;
			}
			
			$(pageboxes).click(function(event) {
				if (event.target.nodeName === "A" && getDocSeqByUrl(event.target.href) !== null) {
					var objOpenInfo = {
						url: event.target.href,
						mode: "r"
					};
					
					openIn(objOpenInfo);
					
					TBCancelBubbleEvent(event);
				}
			});
			
			//totalPageContainer.style.height = total_page_height + "px";
			g_objOnefficeShot.setBodyPgContainer(totalPageContainer);

			//duzon_dialog.fade("in",document.getElementById("viewerFrame"), function() {
//			setTimeout(function() {
//				document.getElementById("viewerFrame").style.opacity = "1";
//				setTimeout(function() {
//					document.getElementById("viewerFrame").scrollTop = 0;			
//				},500);
//			}, 30);
			dzeJ(totalPageContainer).fadeIn(300);
			document.getElementById("viewerFrame").scrollTop = 0;
			setTimeout(function() {
				document.getElementById("viewerFrame").style.opacity = "1";
				document.getElementById("viewerFrame").style.overflowX = "auto";
				var imgs = document.getElementsByTagName('img');
				for (var i = 0 ; i < imgs.length; i++)
				{
					var chartTag = imgs[i].getAttribute('chart_data');
					if (chartTag !== null)
					{
						canvas_create(imgs[i].parentNode, imgs[i]);
					}
				}
				scrollChartAnimation();

			},500);	
			if (true){
//			if (g_browserCHK.mobile === true) {
				var headerList = document.getElementsByTagName("head");
				var metaObj = document.createElement("meta");
				metaObj.setAttribute("name", "viewport");
				//metaObj.setAttribute("content","width=device-width, user-scalable=yes, maximum-scale=1");
				//metaObj.setAttribute("content", "width=device-width");
				var bSlide  = onefficeUtil.getRequestParameter("bSlide");
				
				var ww = window.screen.width;
				var mw = 800;
				try {
				    mw = document.getElementById("totalPageContainer").firstChild.offsetWidth;
				} catch(e) {
				    mw = 800;
				}
				var ratio =  ww / mw;
				if(ratio>1) ratio=0.99;
				
				var wh  = window.screen.height-120;
				
				if( g_browserCHK.iOS === true && g_browserCHK.iPad === true) {
					if(Math.abs(window.orientation)===90){
						wh = window.screen.width-200;
					}else{
						wh  = window.screen.height-200;
					}
					 
				}
				
				var mh  = 1090;
				try {
					mh = document.getElementById("totalPageContainer").firstChild.offsetHeight;
				} catch(e) {
					mh = 1024;
				}
				
				var ratio_h = wh / mh;
				
				if(ratio_h<ratio && bSlide){
					ratio = ratio_h;
				}
				
				if( ww < mw  && g_browserCHK.iOS === true && g_browserCHK.iPad !== true) {
					
					metaObj.setAttribute("content", "initial-scale="+ratio+", minimum-scale=" + ratio + ", maximum-scale=2, user-scalable=yes, width=" + mw);
				} else {
					metaObj.setAttribute("content", "height=device-width");
				}
				//headerList[0].appendChild(metaObj);

//				$(".dze_printpreview_pagebox").css('transform-origin',"left top")
//				$(".dze_printpreview_pagebox").css('transform',"scale("+ratio+")")
				
				var bHybrid = $scope.viewObjParam["hybrid"];
				
				if(bHybrid) {
					g_HybridViewMode = true;
					resizeOnHybridView(ratio);
					viewHybridComunication();

					var bNewEdit = $scope.viewObjParam["newEdit"];
					if(bNewEdit && bNewEdit == "newDoc") {
						setTimeout(function() {
							//goOnefficeEdit();
						}, 0);
					}
					
					if(bSlide==="true"){
						
						document.getElementById("viewerFrame").style.backgroundColor = "#888888";
						
						for(var i = 0; i < slideList.length; i++) {
							
							slideList[i].style.position="absolute";
//							var ttop = ((document.getElementById("viewerFrame").clientHeight-(mh*ratio))/2);
//							slideList[i].style.top=(ttop/ratio)-(38/ratio) + "px"
						
							
							if(i > 0) {
								slideList[i].style.display = "";
								slideList[i].style.opacity = "0";
							} else {
								slideList[i].style.display = "";
								slideList[i].style.opacity = "1";
							}

							slideList[i].style.transition="opacity .3s linear";
						}
					}
				}
			}
			
			if(dzeUiConfig.arrCustomImgSrcRemoveDomain.length > 0 || dzeUiConfig.autoAddImgSrcRemoveDomain === true)
				removeContentsOriginStr();

			// [lsg] iOS에서 더존 폰트의 폭이 다르게 표현되는 문제로 자간 임의 조정
			if(g_browserCHK.iOS) {
				dzeJ("p,td,span").filter(function() {
					return (this.style.fontFamily.indexOf('[더존]') >= 0) && (this.style.letterSpacing == "");
				}).css("letter-spacing", "-0.15px");
			}
		}
		catch(e)
		{
			dalert(e);
		}
	}

	function resizeOnHybridView(nRatio) {
		try {
			document.getElementById("viewerFrame").style.height = document.getElementById("viewerFrameContainer").style.height;

			var ratio;
			if(fnObjectCheckNull(nRatio) == true) {
				var ww = window.screen.width;
				var mw = 800;
				try {
				    mw = document.getElementById("totalPageContainer").firstChild.offsetWidth;
				} catch(e) {
				    mw = 800;
				}
				ratio =  ww / mw;
			} else {
				ratio = nRatio;
			}
		
			
			var totalPageContainer = document.getElementById("totalPageContainer");
				totalPageContainer.style.transform = "scale("+ratio+")";
				totalPageContainer.style.transformOrigin = "left top";

			var newHeight = 0;
			for(var k = 0 ; k < totalPageContainer.childNodes.length ; k++) {
				newHeight += (totalPageContainer.childNodes[k].offsetHeight);
			}
			totalPageContainer.style.height = (newHeight*ratio+30)+"px";
			totalPageContainer.style.display = "table";
			
			var viewelmnt = document.getElementById("viewerFrame");
			
			
			var newWidth = ((ratio > 1)) ? (totalPageContainer.offsetWidth / ratio) : (totalPageContainer.offsetWidth * ratio);
			totalPageContainer.style.width = newWidth+"px";
			if(ratio<1)
				totalPageContainer.style.marginLeft = "calc(50% - "+ newWidth/2+"px)";
				
			setTimeout(
					function() 
					{				
						document.getElementById("viewerFrame").style.overflow = null;
						
					}
				,500);
			
				
		} catch(e) {
			dalert(e);
		}
	}

	function viewHybridComunication() {
		try {
			window.addEventListener('message', function(e) {
				var msg = e.data;

				if(msg.hasOwnProperty("uiEvent")) {
					switch(msg.uiEvent) {
						case "resize":
							resizeOnHybridView();
							break;
						case "goEdit":
							goOnefficeEdit();
							break;
						case "showSlide":
							fnHandler_slideShow(e, 0, g_nActiveEditNumber);
							break;
						case "getSlideInfo":
							sendHybridMessageSlide("totalSlideNum", slideList.length);
							sendHybridMessageSlide("currentSlideNum", currentSlideIndex);
							break;
						case "slideGo":
							goMobileSlide(msg.uiEventData);
							
					}
				}
				
			});
			sendHybridMessageSlide("iframeDone", "");
			
		} catch(e) {
			dalert(e);
		}
	}

	//모바일로 메시지 전송 - Receive: ctrl_viewer.js > addListener
	function sendHybridMessageSlide(type, data) {
		try {
			if(fnObjectCheckNull(type) == true)
				return ;
				
			var message = {
				uiEvent: type,
				uiEventData: data
			};
			window.parent.postMessage(message, "*");
		}
		catch(e) {
		dalert(e);
		}
	}

	//모바일 슬라이드 페이지 이동
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

	function fnLoadViewMode() 
	{
		try
		{
			objOnefficeLoader.setEditorMode(EDITORMODE.VIEWER);
			if(dzeUiConfig.bIndependentEdit === true) {
				
				var htmlContainer = document.createElement("div");
				fnLoadViewModeSuccessCB(opener.oneffice.parentFileContent,htmlContainer);

				if(g_browserCHK.mobile === true) 
					return;	//mobile은 컨트롤러를 출력하지 않는다.

				setTimeout(
					function() 
					{				
						createSlideController();
						createSlideShowMenu();
						if(g_DirectShowMode === true)
						{
							createContextMenu();
							setSlideShowMode(true, 1, false);					
						} 
						
					}
				,500);
				
				return;
				
			}

			oneffice.onErrorCheckSession(//session check...
				function()
				{
					var nAppEnv = oneffice.getAppEnvType();
					var htmlContainer = document.createElement("div");
					var fileSeqID = "";
					
					if(nAppEnv == APPENV.GW )
					{
						fileSeqID = onefficeUtil.getRequestParameter("seq");//1. DATA GET START
						var previewOk = onefficeUtil.getRequestParameter("previewOk");//1. DATA GET START
						if(!fileSeqID)
						{
							closeViewer();
							return;
						}
						
						if(previewOk && opener != null && typeof(opener.oneffice)!= "undefined" && typeof(opener.oneffice.parentFileContent) != "undefined" && opener.oneffice.parentFileContent) {
							fnLoadViewModeSuccessCB(opener.oneffice.parentFileContent,htmlContainer);
						} else {
							
							// 임시로 local 버전과 online 버전 동일하게 사용하기 위해서 아래처럼 처리
							onefficeCommon.getSecurityInfo(fileSeqID, "", function(responseData) {
								if(responseData != 0) {
									// 보안 문서의 경우 암호 체크 후 열람
									checkPasswordAndView(fileSeqID);
								} else {
									onefficeCommon.getFileContent(fileSeqID, 
										function(fileContent) 
										{//successCB
											fnLoadViewModeSuccessCB(fileContent,htmlContainer);
											
											// 사용기록 서버 등록
											onefficeCommon.accessUserFunction("openDoc");
											
											onefficeCommon.getMyInfo(
												function(myInfoData) {
													if(typeof(myInfoData) == "undefined") {
														oneffice_cloud_myInfoData = null;
													} else {
														oneffice_cloud_myInfoData = myInfoData;
														
														// History 서버 등록
														onefficeCommon.accessDocumentHistory(fileSeqID, CLOUD_CONST_HISTORY_ACTIONCODE_OPEN);
													}
												}, false);
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
					}
					else
					{
						//fileSeqID = onefficeUtil.getRequestParameter("seq");//1. DATA GET START
						g_onefficeWeTool.m_bViewer = true;
						g_onefficeWeTool.m_ctrlViewer = htmlContainer;					
						var bSuccess = onefficeWE.openFileProcess();     
						 if(!bSuccess)
	                    {
	                        alert(ID_RES_CONST_STRING_WE_NOT_SUPPORTED);
	                        document.location.href = WEDRIVE_MAIN_LOCATION;
	                        return;
	                    }	
	                    duzon_http.hideLoading();                    
					}

					
					var bShowMode = false;
					var currentPageNum = 1;
					if(nAppEnv == APPENV.GW )
						bShowMode = onefficeUtil.getRequestParameter("bShowMode");
					else
						bShowMode = onefficeUtil.getRequestParameter("bShowMode");
						
					if(bShowMode) {
						g_DirectShowMode = true;
						currentPageNum = onefficeUtil.getRequestParameter("currentPage");
						if (currentPageNum == -1)
							currentPageNum = 1;
					}
					if (!g_DirectShowMode || g_browserCHK.mobile === true)
						document.getElementById("viewerFrame").style.opacity = "1";

					if(g_browserCHK.mobile === true) 
						return;	//mobile은 컨트롤러를 출력하지 않는다.

					setTimeout(//슬라이드 쇼 컨트롤 구성.
						function() 
						{				
							createSlideController();
							createSlideShowMenu();
							if(g_DirectShowMode === true) 
							{
								createContextMenu();
								setSlideShowMode(true, parseInt(currentPageNum), false);
								document.getElementById("viewerFrame").style.opacity = "1";
							}
						}
						,500);
				}
			, dzeUiConfig.bAlwaysCheckSession);
		}
		catch(e)
		{
			dalert(e);
		}                
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
							function(fileContent) 
							{//successCB
							
							
								fnLoadViewModeSuccessCB(fileContent,htmlContainer);
								
								// 사용기록 서버 등록
								onefficeMGW.accessUserFunction("openDoc");
								
								onefficeMGW.getMyInfo(
									function(myInfoData) {
										if(typeof(myInfoData) == "undefined") {
											oneffice_cloud_myInfoData = null;
										} else {
											oneffice_cloud_myInfoData = myInfoData;
											
											// History 서버 등록
											onefficeMGW.accessDocumentHistory(fileSeqID, CLOUD_CONST_HISTORY_ACTIONCODE_OPEN);
										}
									}, false);
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

	function setCustomEleInfo(htmlContainer,headElem)//custom info setting - index check.
	{// dzeLayoutControl.setDocPrintMargin(nEditNumber,newPrintMargin);
	   try
	   {
		   var strPapaerSizeArray = null, strMarginArray = null;
		   var strPapaerColor = "#FFFFFF";

		   var hfControl = g_objHeaderFooter || new HeaderFooter();
		   var pgNumControl = g_objPageNumber || new PageNumber();

           hfControl.init();        //2020-02-10, 페이지 이동 없이 parsing이 일어 날 수 있으므로 초기화 필요
           pgNumControl.init();

		   var tmpCustomEle = htmlContainer.firstElementChild;
		   while(tmpCustomEle)
		   {
				var tmpNodeName = tmpCustomEle.nodeName.toLowerCase();
				var nextEle = tmpCustomEle.nextElementSibling;

				if(tmpNodeName == "dze_doc_property")
				{
					var attrsEle = tmpCustomEle.attributes;
					if(attrsEle)
					{
						for(var i = 0, len = attrsEle.length; i < len; i++)
						{
							var att = attrsEle[i];
							if(att)
							{
								var attName = att.nodeName.toLowerCase();
							//	console.log("[setCustomEleInfo]::docproperty attNamme = " + attName + " attValue = " + att.nodeValue);
								switch(attName)
								{
									case DZE_CUSTOM_ATT_NEW_DOC_CREATE:
									{
										//2019-04-04, 모바일에서만 동작하도록 예외 처리
//										if(g_browserCHK.mobile && att.nodeValue === "NewDocument") {
//											goOnefficeEdit();
//
//											// 하이브리드앱에서는 ctrl_viewer를 거쳐서 편집으로 가도록 수정
//											var bHybrid = onefficeUtil.getRequestParameter("hybrid");
//											if(bHybrid && bHybrid == "hApp") {
//												g_HybridViewMode = true;
//												onefficeUtil.setCookieValue("hybridEdit", "1",10);
//												window.parent.postMessage({ uiEvent: 'newDocEdit' }, "*");
//											}
//										}
									}
									break;
									case DZE_CUSTOM_ATT_PAGEMARGIN:
									{
										strMarginArray = getstrMarginArray(att.nodeValue);   //document print margin info get
									}
									break;
									case DZE_CUSTOM_ATT_PAPERSIZE:
									{
										strPapaerSizeArray = getstrPaperSizeArray(att.nodeValue);   //document print margin info get
										dzeUiConfig.nSettingPaperSize.width = parseFloat(strPapaerSizeArray[0]);
										dzeUiConfig.nSettingPaperSize.height = parseFloat(strPapaerSizeArray[1]);
									}
									break;
									case DZE_CUSTOM_ATT_PAGECOLOR:
									{
										strPapaerColor = att.nodeValue;   //document print margin info get
										if(strPapaerColor) {
											changeCss(".dze_printpreview_pagebox", "background-color", strPapaerColor, document);
											dzeUiConfig.sSettingPaperColor = strPapaerColor;
										}
									}
									break;
//									case DZE_CUSTOM_ATT_WATERMARKSRC:
//									{
//										strWatermarkSrc = att.nodeValue;   //document watermark src
//										if(strWatermarkSrc) {
//											dzeUiConfig.sWatermarkImageSrc = strWatermarkSrc;
//										}
//									}
//									break;
									//머리글/바닥글 (UCDOC-576)
									case DZE_CUSTOM_ATT_DIFF_FIRST_PAGE:
									case DZE_CUSTOM_ATT_DIFF_ODD_EVEN_PAGE:
									case DZE_CUSTOM_ATT_ODD_HEADER:
									case DZE_CUSTOM_ATT_EVEN_HEADER:
									case DZE_CUSTOM_ATT_FIRST_HEADER:
									case DZE_CUSTOM_ATT_ODD_FOOTER:
									case DZE_CUSTOM_ATT_EVEN_FOOTER:
									case DZE_CUSTOM_ATT_FIRST_FOOTER:
									{
										hfControl.setHeaderFooterAttribute(attName, att.nodeValue);
									}
									break;
									case DZE_CUSTOM_ATT_ONEPAGE_MODE:
									{
										if(att.nodeValue == null || att.nodeValue == "") {
											dzeUiConfig.bOfficeOnePageLongMode = false;
										} else {
											dzeUiConfig.bOfficeOnePageLongMode = duzon_http.parseJSON(att.nodeValue);
										}
									}
									break;
									case DZE_CUSTOM_ATT_PAGE_OVERFLOWVISIBLE:
									{
										var strNodeValue = att.nodeValue;   //document print margin info get
										var bPgOverflowVisible = ((strNodeValue == "false") || (strNodeValue == null))? false : true;
										if(bPgOverflowVisible)
										{
											dzeUiConfig.bOfficePgOverflowVisible = bPgOverflowVisible;//true
											changeCss(".dze_printpreview_pagebox_body","overflow","visible",document);
											changeCss(".dze_printpreview_pagebox","overflow","visible",document);
										}
										else
										{
											dzeUiConfig.bOfficePgOverflowVisible = bPgOverflowVisible;//false
											changeCss(".dze_printpreview_pagebox_body","overflow","",document);	//UCDOC-840
											changeCss(".dze_printpreview_pagebox","overflow","hidden",document);
										}
									}
									break;
									case DZE_CUSTOM_ATT_PGNUM:	//페이지 번호 (UCDOC-1171)
									{
										if(pgNumControl)
											pgNumControl.importFromAttNode(att);
									}
									break;
								}
							}
						}
						htmlContainer.removeChild(tmpCustomEle);
					}
				}

				if(tmpNodeName.substring(0,4) != "dze_")//prefix customTag check, string null check
					break;

				tmpCustomEle = nextEle;
			}
			setViewerPageMarginInfo(strMarginArray,0); //set viewer page
			setPrintMarginInfo(htmlContainer,headElem,strMarginArray,strPapaerSizeArray);//set print info
		}
		catch(e)
		{
			dalert(e);
		}
	}

	function setPrintMarginInfo (htmlContainer,headElem,strMarginArray,strPageSizeArray)
	{//document print margin set
	   try
	   {
			var printPageMarginUnitSet = "";
			if(strMarginArray && strMarginArray.length)
			{
				printPageMarginUnitSet = strMarginArray[0]+"mm " + strMarginArray[1]+"mm " + strMarginArray[2]+"mm " + strMarginArray[3]+"mm " ;
				var printLayout = "portrait";
				if(strPageSizeArray[0] > strPageSizeArray[1])
					printLayout = "landscape";

				var docMarginStyleElem = document.createElement("style");
				docMarginStyleElem.className = "viewer_container";
				docMarginStyleElem.setAttribute("type","text/css");
				docMarginStyleElem.setAttribute("media","print");                            
				docMarginStyleElem.innerHTML = "@page{ margin : "+printPageMarginUnitSet+"; size:" + printLayout + ";  }";
				g_OrgPrintMarginHTML = strMarginArray;
				headElem.appendChild(docMarginStyleElem);                        
			}
		}
		catch(e)
		{
			dalert(e);
		}
	}

	function setViewerPageMarginInfo (strMarginArray, nPrintMode)
	{              
	   try
	   {
		   
			var strPageMarginCSS = "";
			var nLeft = 0,nRight = 0,nTop = 0, nBottom = 0;
			if(strMarginArray && strMarginArray.length)
			{
				dzeUiConfig.nSettingPaperMargin.top  = parseFloat(strMarginArray[0]);
				dzeUiConfig.nSettingPaperMargin.right = parseFloat(strMarginArray[1]);
				dzeUiConfig.nSettingPaperMargin.bottom = parseFloat(strMarginArray[2]);
				dzeUiConfig.nSettingPaperMargin.left = parseFloat(strMarginArray[3]);
				dzeUiConfig.nSettingPaperMargin.headerTop = parseFloat(strMarginArray[4]);		//header margin from top (UCDOC-576)
				dzeUiConfig.nSettingPaperMargin.footerBottom = parseFloat(strMarginArray[5]);	//footer margin from bottom
			}
			else
			{
				strMarginArray = getDefaultMarginArray();    
				strMarginArray = strMarginArray.split(" ");                        
			}

			var paperSize = dzeUiConfig.nSettingPaperSize,			//(mm)
				paperMargin = dzeUiConfig.nSettingPaperMargin;		//(mm)

			var pageWidth = paperSize.width - paperMargin.left - paperMargin.right,
				pageHeight = paperSize.height - paperMargin.top - paperMargin.bottom;


			// 1) page box
			changeCss(".dze_printpreview_pagebox","width",paperSize.width +"mm",document);
			
			if(dzeUiConfig.bOfficeOnePageLongMode === true) {
				changeCss(".dze_printpreview_pagebox","height","auto",document);
				changeCss(".dze_printpreview_pagebox","min-height",paperSize.height +"mm",document);
				changeCss(".dze_printpreview_pagebox","display","block", document);
			} else {
				changeCss(".dze_printpreview_pagebox","height","auto",document);
				changeCss(".dze_printpreview_pagebox","min-height",paperSize.height +"mm",document);
				changeCss(".dze_printpreview_pagebox","display","block", document);
//				changeCss(".dze_printpreview_pagebox","height",paperSize.height +"mm",document);
			}
			if(dzeUiConfig.bOfficePgOverflowVisible)
			{
				changeCss(".dze_printpreview_pagebox_body","overflow","visible",document);
				changeCss(".dze_printpreview_pagebox","overflow","visible",document);
			}
			else
			{						
				changeCss(".dze_printpreview_pagebox_body","","",document);	//UCDOC-840
				changeCss(".dze_printpreview_pagebox","overflow","hidden",document);							
			}


			// 2) header
			changeCss(".dze_printpreview_pagebox_header","width",pageWidth + "mm",document);
			changeCss(".dze_printpreview_pagebox_header","min-height",paperMargin.top + "mm",document);	//2019-02-01, UCDOC-840
			changeCss(".dze_printpreview_pagebox_header","max-height",(paperSize.height/2 - paperMargin.headerTop - 10) + "mm",document);
			changeCss(".dze_printpreview_pagebox_header","padding", paperMargin.headerTop + "mm "+ paperMargin.right + "mm 0mm " + paperMargin.left + "mm", document);


			// 3) body
			changeCss(".dze_printpreview_pagebox_body","width",pageWidth + "mm",document);
			changeCss(".dze_printpreview_pagebox_body","padding","0mm "+paperMargin.right+"mm 0mm "+paperMargin.left+"mm",document);
		
			if(dzeUiConfig.bOfficeOnePageLongMode === true) {
				changeCss(".dze_printpreview_pagebox_body", "height", "auto", document);	
				changeCss(".dze_printpreview_pagebox_body", "overflow", "visible", document);	
				changeCss(".dze_printpreview_pagebox_body","min-height",pageHeight + "mm",document);
			} else {
				changeCss(".dze_printpreview_pagebox_body", "height", "auto", document);	
				changeCss(".dze_printpreview_pagebox_body", "overflow", "visible", document);	
				changeCss(".dze_printpreview_pagebox_body","min-height",pageHeight + "mm",document);
//				changeCss(".dze_printpreview_pagebox_body","max-height",pageHeight + "mm",document);
			}


			// 4) footer
			changeCss(".dze_printpreview_pagebox_footer","width",pageWidth + "mm",document);
			changeCss(".dze_printpreview_pagebox_footer","min-height",paperMargin.bottom + "mm",document);	//2019-02-01, UCDOC-840
			changeCss(".dze_printpreview_pagebox_footer","max-height",(paperSize.height/2 - paperMargin.footerBottom - 10) + "mm",document);
			changeCss(".dze_printpreview_pagebox_footer","padding", "0mm "+	paperMargin.right+ "mm " + paperMargin.footerBottom + "mm " + paperMargin.left + "mm", document);







			/*
			//console.log("setMargiinInfo" + strPageMarginCSS);
			strPageMarginCSS = strMarginArray[0] + "mm " + strMarginArray[1] + "mm " + strMarginArray[2] + "mm " + strMarginArray[3] + "mm " ;                                                
			changeCss(".dze_printpreview_pagebox","padding",strPageMarginCSS,document);

			if(nPrintMode == 0) {
				var strWidthUnit = (dzeUiConfig.nSettingPaperSize.width -  dzeUiConfig.nSettingPaperMargin.left -  dzeUiConfig.nSettingPaperMargin.right) + "mm";
				changeCss(".dze_printpreview_pagebox", "width", strWidthUnit, document);      

				var strHeightUnit = (( dzeUiConfig.nSettingPaperSize.height - dzeUiConfig.nSettingPaperMargin.top - dzeUiConfig.nSettingPaperMargin.bottom) + "mm");
				changeCss(".dze_printpreview_pagebox","height",strHeightUnit, document);		
			}
			*/

		}
		catch(e)
		{
			dalert(e);
		}
	}

	function getDefaultMarginArray()
	{
		try
		{
			return  dzeUiConfig.nSettingPaperMargin.top + " " +
					dzeUiConfig.nSettingPaperMargin.right + " " +
					dzeUiConfig.nSettingPaperMargin.bottom + " " +
					dzeUiConfig.nSettingPaperMargin.left + " " +
					dzeUiConfig.nSettingPaperMargin.headerTop + " " +		//header margin from top (UCDOC-576)
					dzeUiConfig.nSettingPaperMargin.footerBottom;			//footer margin from bottom
		}
		catch(e)
		{
			dalert(e);
		}
	}  

	function getstrPaperSizeArray (attValue)
	{
	   try
	   {
			var strPaperSizeArray = "270,210";

			if(attValue)
			{
			   strPaperSizeArray = attValue;//attrEle[i].nodeValue;
			   strPaperSizeArray = strPaperSizeArray.split(",");
			}
			return strPaperSizeArray;
		}
		catch(e)
		{
			dalert(e);
		}
	}

	function getstrMarginArray (attValue)
	{
	   try
	   {
			var strMarginArray = getDefaultMarginArray();

			if(attValue)
			{//get margin info                     
				strMarginArray = attValue;//attrEle[i].nodeValue;
				strMarginArray = strMarginArray.split(",");
			}
			else if(g_OrgPrintMarginHTML.length)
				strMarginArray = g_OrgPrintMarginHTML;

			//console.log("getstrMarginArray" + strMarginArray);
			return strMarginArray;
		}
		catch(e)
		{
			dalert(e);
		}
	}


	function canvas_create(parentNode, element) {
	    var createChartDiv = document.createElement('div');
	    var strImgChartID = element.getAttribute('chart_id');

	    var width = element.clientWidth + 'px';
		var height = element.clientHeight + 'px';

		var boundRect = element.getBoundingClientRect();

		//console.log("offest left = "+ element.offsetLeft +"offset top = " + element.offsetTop );
		createChartDiv.setAttribute('id', 'container_'+strImgChartID);
	    createChartDiv.style.width = width;
	    createChartDiv.style.height = height;
		createChartDiv.style.display = 'block';
		createChartDiv.style.position = "absolute";
		createChartDiv.style.left = element.offsetLeft + "px";
		createChartDiv.style.top = element.offsetTop + "px";
		
		parentNode.insertBefore(createChartDiv, element);
		
		if (element.offsetParent && createChartDiv.offsetParent) 
		{
			if (element.offsetParent.tagName !== createChartDiv.offsetParent.tagName)
			{
				var offsetLeft = g_objPositionUtil.getClassNameLeft(element, "dze_printpreview_pagebox_body");
				var offsetTop = g_objPositionUtil.getClassNameTop(element, "dze_printpreview_pagebox_body");
				createChartDiv.style.left = offsetLeft;
				createChartDiv.style.top = offsetTop;
			}
		}
		
		element.style.visibility = 'hidden';
		var canvas_id = "canvas_"+strImgChartID;
	   	var cCanvasChart = document.createElement('canvas');

	   	cCanvasChart.setAttribute('id', canvas_id);
	   	cCanvasChart.setAttribute('width', width); 
		cCanvasChart.setAttribute('height', height);

	  
	   	createChartDiv.appendChild(cCanvasChart);
	    var ctx = document.getElementById(canvas_id).getContext('2d');
		var attrChartData  = element.getAttribute('chart_data');
		
		onefficeChart.initialize();						
		onefficeChart.convStringToChartData(attrChartData);
		//onefficeChart.addDefaultEvent();
		onefficeChart.makeViewChart(ctx, width, height, canvas_id);
	}
	
	function seperatePage(fileContent, htmlContainer) {
		try {
			if (dzeUiConfig.bOfficePagingMode !== true) {
				changeCss(".dze_printpagebreak_guide","display","none",document);		// pagebreak는 뷰어에서 보이지 않음.
			}
			
			var objViewContainer = $("#viewerFrame");
			
			var allElements = document.createElement("div");
			
			while (htmlContainer.childNodes.length) {
				allElements.appendChild(htmlContainer.childNodes[0]);
			}
			
			var divCnt = 0;
		    var pageNum = 0;
			
			while (allElements.childNodes.length) {
				divCnt++;
				
				if (divCnt == 1) {
					pageNum++;
					var pageDivObj = document.createElement("div");
					pageDivObj.className = "dze_printpreview_pagebox";
					pageDivObj.setAttribute("pageNum",pageNum);
					
					pageDivObj.style = "border: 1px solid lightgray;";
					pageDivObj.style.margin = "15px auto";  
					pageDivObj.style.backgroundColor = dzeUiConfig.sSettingPaperColor;
					
					var pageHeaderElem = document.createElement("div");
					pageHeaderElem.className = "dze_printpreview_pagebox_header";
					
					var pageBodyElem = document.createElement("div");
					pageBodyElem.className = "dze_printpreview_pagebox_body";
					
					var pageFooterElem = document.createElement("div");
					pageFooterElem.className = "dze_printpreview_pagebox_footer";
					
					//머리글/바닥글 innerHTML(UCDOC-576)
					pageHeaderElem.innerHTML = g_objHeaderFooter.getPageHeaderContents(pageNum - 1);
					pageFooterElem.innerHTML = g_objHeaderFooter.getPageFooterContents(pageNum - 1);
					
					pageDivObj.appendChild(pageHeaderElem);
					pageDivObj.appendChild(pageBodyElem);
					pageDivObj.appendChild(pageFooterElem);
					
					if (dzeUiConfig.sWatermarkImageSrc != "") {
						var pageWatermarkElem = document.createElement("div");
						pageWatermarkElem.className = "watermarkContainer";
						pageDivObj.appendChild(pageWatermarkElem);
					}
					
					// bottom Createor
					if (dzeUiConfig.bUsebottomCreatorBackgroundStyle === true) {
						pageDivObj.appendChild(g_objPageControl.makePageBottomCreator());
					}
					
					// 페이지 번호 (UCDOC-1171)
					if (g_objPageNumber && g_objPageNumber.type !== 0) {
						pageDivObj.appendChild(g_objPageNumber.createDiv(pageDivObj, pageNum - 1));
					}
				}
				
				var currElem = allElements.childNodes[0];
				pageBodyElem.appendChild(currElem);//append 하면 childLength 가 감소.
				
				if (currElem.className == "dze_printpagebreak") {
					objViewContainer[0].appendChild(pageDivObj);
					
					setPageLayoutForOnefficeView(pageDivObj, pageNum - 1);	//UCDOC-840
					
					divCnt = 0;
				}
			}
			
			if (dzeUiConfig.sWatermarkImageSrc != "") {
				changeCss(".watermarkContainer","width",dzeUiConfig.nSettingPaperSize.width + "mm",document);
				changeCss(".watermarkContainer","height",dzeUiConfig.nSettingPaperSize.height + "mm",document);
				changeCss(".watermarkContainer","background","url('"+dzeUiConfig.sWatermarkImageSrc+"') no-repeat center center;",document);
			}
			
			objViewContainer[0].appendChild(pageDivObj);
			
			setPageLayoutForOnefficeView(pageDivObj, pageNum - 1);	//UCDOC-840
			
			// 본문내 vidoe 태그 가 있고, 내부 draggable property가 있으면 제거
			var videos = objViewContainer[0].getElementsByTagName("video");
			
			for (var i = 0;i < videos.length; i++) {
				if (videos[i].getAttribute("draggable")) {
					videos[i].removeAttribute("draggable");
				}
				
				if (dzeUiConfig.bIndependentEdit !== true) {
					// 사파리에서 비디오 태그가 API를 통해 컨텐츠를 가져오지 못하는 문제가 있어서 직접 접근하는 경로로 링크 수정
					if (g_browserCHK.iOS && videos[i].firstChild.src.indexOf(ONEFFICE_SERVER_API_GET_ATTACHMENTDATA+"?seq=") >= 0) {
						var videoSrc = videos[i].firstChild.src;
						var domainPath = videoSrc.split("/gw/onefficeApi/")[0];
						var videoSrcArray = videoSrc.split("/");
						var videoFileName = videoSrcArray[videoSrcArray.length-1].split("seq=")[1];
						var docSeq = videoFileName.split("-")[0];
						
						if (domainPath.indexOf("bizboxa.com") >= 0) {
							var groupSeq = onefficeUtil.getRequestParameter("groupseq");
							videos[i].firstChild.src = domainPath+"/upload/"+groupSeq+"/onefficeFile/"+fileContent.owner_id+"/"+docSeq+"/"+videoFileName;
						} else {
							videos[i].firstChild.src = domainPath+"/upload/onefficeFile/"+fileContent.owner_id+"/"+docSeq+"/"+videoFileName;
						}
						
						videos[i].firstChild.src =videos[i].firstChild.src.replace(fileContent.gw_url,fileContent.mobile_gateway_url);
					}
				}
			}
			
			// 모바일 본문내 이미지 경로 재설정
			var imageTags = objViewContainer[0].getElementsByTagName("img");
			var videoTags = objViewContainer[0].getElementsByTagName("video");
			
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
			
			for (var i = 0;i < videoTags.length; i++) {
				var _src = videoTags[i].firstChild.src;
				videoTags[i].setAttribute('webkit-playsinline','');
				videoTags[i].setAttribute('playsinline','');
				
				if (videoTags[i].firstChild.src.indexOf("getAttachmentData.do?seq=") >= 0) {
					var _videoTag = videoTags[i].firstChild;
					var vedioFileName = _src.split("seq=")[1];
					var docSeq = vedioFileName.split("-")[0];
					_videoTag.setAttribute('webSrc', _src);
					var mobileSrc = mobile_http.getProtocolUrl("P018")+"?seq="+vedioFileName+"&pathSeq=1600&token="+mobile_http.hybridBaseData.header.token;
					
					if (g_browserCHK.iOS) {
						if(mobile_http.hybridBaseData.result.compDomain.indexOf("bizboxa.com") >= 0) {
							mobileSrc = 'http://' + mobile_http.hybridBaseData.result.compDomain +"/upload/"+mobile_http.hybridBaseData.result.groupSeq+"/onefficeFile/"+fileContent.owner_id+"/"+docSeq+"/"+vedioFileName;
						} else {
							mobileSrc = 'http://' + mobile_http.hybridBaseData.result.compDomain +"/upload/onefficeFile/"+fileContent.owner_id+"/"+docSeq+"/"+vedioFileName;
						}
					}
					
					_videoTag.src= mobileSrc;
				}
			}
			
			var arrChild = objViewContainer[0].childNodes;
			
			for (var i = 0; i < arrChild.length; i++) {
				if (arrChild[i].nodeName.toLowerCase() == "div" && arrChild[i].className == "dze_printpreview_pagebox") {
					// add pagenumLayer
					var pageNumLayer = document.createElement("div");
					pageNumLayer.className = "slidePageNumLayer";
					pageNumLayer.innerHTML = arrChild[i].getAttribute("pageNum");
					
					arrChild[i].appendChild(pageNumLayer);
					slideList.push(arrChild[i]);
				}
			}
			
			totalSlideCount = slideList.length;
			
			// mobile sheet size set
			changeCss(".dze_printpreview_pagebox", "margin", "0 auto 5px auto", document);
			changeCss(".slidePageNumLayer", "font-size", "50px", document);
			
//			setTimeout(function() {
//				objViewContainer.find("li").each(function(index, item) {
//					$(item).height($(item).height());
//				});
//			}, 1000);
		} catch (e) {
			dalert(e);
		}
	}
	
	//UCDOC-840, page main height / headerfooter padding margin 설정
	function setPageLayoutForOnefficeView(pageDivObj, pageNum) {
		try {
			if (!pageDivObj) {
				return;
			}
			
			var cacheHeight;
			var paperMarginPx;
			var paperSizePx;
			var hfMaxHeightPx;
			
			// initialize
			if (!cacheHeight) {
				var commonUtil = g_objCommonUtil;
				
				cacheHeight = [];
				
				paperMarginPx = cloneSimpleObject(dzeUiConfig.nSettingPaperMargin);
				paperMarginPx.left = +(commonUtil.convMMToPx(paperMarginPx.left).toFixed(2));
				paperMarginPx.top = +(commonUtil.convMMToPx(paperMarginPx.top).toFixed(2));
				paperMarginPx.right = +(commonUtil.convMMToPx(paperMarginPx.right).toFixed(2));
				paperMarginPx.bottom = +(commonUtil.convMMToPx(paperMarginPx.bottom).toFixed(2));
				paperMarginPx.headerTop = +(commonUtil.convMMToPx(paperMarginPx.headerTop).toFixed(2));
				paperMarginPx.footerBottom = +(commonUtil.convMMToPx(paperMarginPx.footerBottom).toFixed(2));

				paperSizePx = cloneSimpleObject(dzeUiConfig.nSettingPaperSize);
				paperSizePx.width = +(commonUtil.convMMToPx(paperSizePx.width).toFixed(2));
				paperSizePx.height = +(commonUtil.convMMToPx(paperSizePx.height).toFixed(2));

				hfMaxHeightPx = +(commonUtil.convMMToPx(dzeUiConfig.nSettingPaperSize.height/2 - 10).toFixed(2));
			}

			var hfControl = g_objHeaderFooter;
			
			var header = pageDivObj.childNodes[0],
				body = pageDivObj.childNodes[1],
				footer = pageDivObj.childNodes[2];

			//UCDOC-840, header/footer padding bottom
			if(hfControl.isBlankHeaderFooter(header))
			{
				header.style.paddingTop = "0px";	//2019-02-01, UCDOC-840
				header.style.minHeight = paperMarginPx.top + "px";
			}
			else
			{
				header.style.paddingTop = paperMarginPx.headerTop + "px";	//2019-02-01, UCDOC-840
				header.style.minHeight = Math.max(paperMarginPx.top - paperMarginPx.headerTop, 0) + "px";
			}

			//header/footer height
			var nHeaderType = hfControl.getPageType(pageNum) | hfControl.HEADER;
			var headerHeight = cacheHeight[nHeaderType];
			if(!headerHeight)
			{
				headerHeight = header.offsetHeight;
				cacheHeight[nHeaderType] = headerHeight;
			}

			var nFooterType = hfControl.getPageType(pageNum) | hfControl.FOOTER;
			var footerHeight = cacheHeight[nFooterType];
			if(!footerHeight)
			{
				footerHeight = footer.offsetHeight;
				cacheHeight[nFooterType] = footerHeight;
			}

			//UCDOC-840, page body height
			var headerMaxHeight = Math.max(paperMarginPx.top, headerHeight);
			var footerMaxHeight = Math.max(paperMarginPx.bottom, footerHeight);

			var bodyHeight = paperSizePx.height - (headerMaxHeight + footerMaxHeight);
			if(dzeUiConfig.bOfficeOnePageLongMode)	//2019-01-30, 원페이지 롱모드 고려
			{
				body.style.height = "";	
				body.style.minHeight = (paperSizePx.height - (headerMaxHeight + footerMaxHeight)) + "px";
				footer.style.position = "relative";
			}
			else
			{
				body.style.height = bodyHeight + "px";
				footer.style.position = "";
			}

			//header overflow 가림막 element
			if(headerHeight >= Math.floor(hfMaxHeightPx))
			{
				var overflowBlinder = document.createElement("div");
				overflowBlinder.style.position = "absolute";
				overflowBlinder.style.top = hfMaxHeightPx + "px";
				overflowBlinder.style.left = "0mm";
				overflowBlinder.style.right = "0mm";
				overflowBlinder.style.height = bodyHeight + "px";
				overflowBlinder.style.backgroundColor = dzeUiConfig.sSettingPaperColor;
				header.appendChild(overflowBlinder);
			}

			if(hfControl.isBlankHeaderFooter(footer))	//2019-02-01, UCDOC-840
			{
				if(dzeUiConfig.bOfficeOnePageLongMode)	//2019-02-01, UCDOC-840
					footer.style.marginTop = "30px";
				else
					footer.style.marginTop = "0px";

				footer.style.paddingBottom = "0px";
				footer.style.minHeight = paperMarginPx.bottom + "px";
			}
			else
			{
				footer.style.paddingBottom = paperMarginPx.footerBottom + "px";
				footer.style.minHeight = "0px";

				//footer를 bottom에 붙이기 위해서, footer margin top을 조정한다.
				var footerMarginTop = Math.max(paperMarginPx.bottom + paperMarginPx.footerBottom - footerHeight, 0);

				if(dzeUiConfig.bOfficeOnePageLongMode)	//2019-02-01, UCDOC-840
					footer.style.marginTop = (footerMarginTop + 30) + "px";
				else
					footer.style.marginTop = footerMarginTop + "px";
			}
		}
		catch(e)
		{
			dalert(e);
		}
	}

	var prevScrollTop = 0;
	var nowScrolling = false;

	//check stop scrolling.
	var scrollCheckTimer = null;
	function startScrollCheck() {
		try
		{
			scrollCheckTimer = setInterval(function() {
			
				if(bIsZoomout === true) return;
		
					if(document.documentElement.scrollTop) {
						var currScrollTop = document.documentElement.scrollTop;
					} else {
						var currScrollTop = document.getElementById("viewerFrame").scrollTop;
					}
		
					if(currScrollTop == prevScrollTop) {
						if(!nowScrolling) return;
						nowScrolling = false;
						showAllPageNumLayer(false);
						stopScrollCheck();
					}
					prevScrollTop = currScrollTop;
		
			},1000);
		}
		catch(e)
		{
			dalert(e);
		}
	}

	function stopScrollCheck() {
		try
		{
			if(scrollCheckTimer) {
				clearInterval(scrollCheckTimer);
				scrollCheckTimer = null;
			}
		}
		catch(e)
		{
			dalert(e);
		}
	}

	function scrollChartAnimation() {
		try {
			if(!document.getElementById("viewerFrame")) return;
			var _clientHeight = document.getElementById("viewerFrame").clientHeight;
			//document안에 chart canvas가 있으면 animation을 재 시작.
			var canvasTags = document.getElementById("viewerFrame").getElementsByTagName("canvas");
			var chartIDs = [];
			for (var i = 0; i < canvasTags.length; i++  )
			{
				if (canvasTags[i].id.indexOf("canvas_chart") >= 0) {
				//animation 재시작
					var _chartID = canvasTags[i].id;
					var _index  = g_chartIDS.indexOf(_chartID);
					var _domRect = canvasTags[i].getBoundingClientRect();
					if (_domRect.top >= 0  && _domRect.bottom >= 0 && _domRect.bottom <= _clientHeight){
						if (_index < 0 ){
							chartIDs.push(_chartID);
							g_chartIDS.push(_chartID);
						}
						//else
							//g_chartIDS.splice(_index,1);
					}else if (_domRect.bottom <= 0 || _domRect.top >= _clientHeight) {
						if (_index >= 0)
							g_chartIDS.splice(_index,1);
					}
				}
			}

			if (chartIDs.length > 0) {
				setChartAnimation(true, chartIDs);
			}

		}
		catch(e)
		{
			dalert(e);
		}
	}
	
	function insertEditorStyleCSS(headElem) {
		try {
			//contents.css
            var styleSheetLink = document.createElement("link");    //UCDOC-1986, 2020-05-21, contents css 추가
			var strCssFilePath = g_strContentsCSS + "?ver=" + objOnefficeLoader.getVer();

			styleSheetLink.setAttribute("rel", "stylesheet");
			styleSheetLink.setAttribute("type", "text/css");
			styleSheetLink.setAttribute("href", strCssFilePath);

			headElem.appendChild(styleSheetLink);

			//editor_style_inherit.css
			styleSheetLink = document.createElement("link");
			strCssFilePath = dzeEnvConfig.strPath_CSS + "editor_style_inherit_mobile.css?ver="+objOnefficeLoader.getVer();
			
			styleSheetLink.className = "viewer_container";
			styleSheetLink.setAttribute("rel", "stylesheet");
			styleSheetLink.setAttribute("type", "text/css");
			styleSheetLink.setAttribute("href", strCssFilePath);
			
			headElem.appendChild(styleSheetLink);
			
		   	// style
			var objStyle = document.createElement("style");
			var strFontSize = (dzeUiConfig.strCustomBodyFontSize.length > 0) ? dzeUiConfig.strCustomBodyFontSize : "11pt";
			
			var strHtml = "";
			strHtml += ".vieweditContainer ";
			strHtml += ("{font-family: '[더존] 본문체 30'; font-size: " + strFontSize + "; font-weight: normal;}");
			
			strHtml += " .vieweditContainer body, .vieweditContainer td, .vieweditContainer p ";
			strHtml += ("{font-family: '[더존] 본문체 30'; font-size: " + strFontSize + ";");
			
			if (fnObjectCheckNull(dzeUiConfig.strCustomBodyLineHeight) === false && dzeUiConfig.strCustomBodyLineHeight !== "") {
				strHtml += (" line-height: " + dzeUiConfig.strCustomBodyLineHeight + ";");
			}
			
			if (fnObjectCheckNull(dzeUiConfig.strCustomBodyLetterSpacing) === false && dzeUiConfig.strCustomBodyLetterSpacing !== "") {
				strHtml += (" letter-spacing:" + dzeUiConfig.strCustomBodyLetterSpacing + ";");
			}
			
			strHtml += "}";
			objStyle.className = "viewer_container";
			objStyle.innerHTML = strHtml;
			
			headElem.appendChild(objStyle);
		} catch (e) {
			dalert(e);
		}
	}
	
	function closeViewer()
	{
		try
		{
			if(dzeUiConfig.bOfficePagingMode !== true) 
				changeCss(".dze_printpagebreak_guide","display","",document);            
			
			objOnefficeLoader.setEditorMode(EDITORMODE.EDITOR);//init
			//window.close();
			
			//console.log("g_browserCHK.mobile:"+g_browserCHK.mobile);		
			if(g_browserCHK.mobile !== true) 
			{
				cmnCtrlToast.showToastMsg(null, ID_RES_CONST_STRING_WARNING_INVALID_DOCUMENT_CALL, 2, "screen_center");
				setTimeout(function() {
					if(!onefficeWE) {
						document.location.href = oneffice.drivePath;
					}
				},1000);							
			} 
			else 
			{			
				cmnCtrlToast.showToastMsg(null, ID_RES_CONST_STRING_WARNING_INVALID_DOCUMENT_CALL, 2, "mobile");
			}
			return;
					
		}
		catch(e)
		{
			dalert(e);
		}
	}

	function changeDocBgColor(strHTML)
	{
		try
		{
			var docStyleElems = document.getElementsByTagName("style");
			for(var i = 0; i < docStyleElems.length; i++) 
			{      
				var txt = docStyleElems[i].innerHTML;
				if(txt.indexOf("background-color") != -1) 
				{
					docStyleElems[i].innerHTML = strHTML;                   
				}
			}
		}
		catch(e)
		{
			dalert(e);
		}
	}

	var beforePrint = function() 
	{
		try
		{
		    //console.log("befrePrint");
			//1. 화면 
			//changeDocBgColor("body {  background-color: #FFFFFF;   }");
			//changeCss(".dze_printpreview_pagebox","border-width","0px",document);     
			changeCss(".dze_printpreview_pagebox","margin","auto",document);     
			//2. 페이지                                   
			var strMarginArray = [["0"],["0"],["0"],["0"]];                    
			setViewerPageMarginInfo(strMarginArray, 1);
			showSlideController(false);
			showAllPageNumLayer(false);
		}
		catch(e)
		{
			dalert(e);
		}
	};

	var afterPrint = function() 
	{
		try
		{
		    //console.log("afterPrint");
			//화면.
			//changeDocBgColor("body {  background-color: #f2f2f2;   }");
			//changeCss(".dze_printpreview_pagebox","border-width","1px",document);     
			changeCss(".dze_printpreview_pagebox","margin","15px auto",document);      
			//페이지
			var strMarginArray = getstrMarginArray(null);                    
			setViewerPageMarginInfo(strMarginArray, 2); //set viewer page
			showSlideController(true);
			
			if(g_bSlideMode === false) {
				showAllPageNumLayer(true);
			}
		}
		catch(e)
		{
			dalert(e);
		}
	};


	function setSlideShowMode(bAct, directSlideNo, fromPreviewMode) {

		var bAlert = false;

		if (typeof(fromPreviewMode) === "undefined") {
			bAlert = true;
		}
		else 
		{
			if (fromPreviewMode == false)
			 bAlert = true;
		}
		
		try {
			
			if(dzeUiConfig.bOfficeOnePageLongMode === true) {
				//showToastMsg(ID_RES_CONST_STRING_ALERT_NOT_AVAILABLE_IN_ONEPAGE_MODE,1.5);
				return;
			}
			//console.log("==========================start setSlideShowMode bAct : "+bAct+", directSlideNo : "+directSlideNo+" ==========================");
			
			if(g_bSlideMode === bAct) return;

			g_bSlideMode = bAct;
			for(var i = 0; i < slideList.length; i++) {
				
				if(bAct == true) {
					slideList[i].style.display = "none";
					slideList[i].style.opacity = "0";
				} else {
					slideList[i].style.display = "";
					slideList[i].style.opacity = "1";
				}

			}
			//zoom
			setSlideShowScreenScale();
			
			if(bAct === true) 
			{
				if(window.addEventListener) 
				{
					window.addEventListener("keydown", addSlideShowKeyDownEvent, false);
					window.addEventListener("resize", setSlideShowScreenScale, false);
					window.addEventListener("mousedown", addSlideShowMouseDownEvent, false);
					window.addEventListener("mousemove", addSlideShowMouseMoveEvent, false);
					window.addEventListener("click", addSlideShowClickEvent, false);
					window.addEventListener("mousewheel", addSlideShowWeelEvent, false);
					window.addEventListener("DOMMouseScroll", addSlideShowWeelEvent, false);
					window.addEventListener("contextmenu", addSlideShowContextmenu, false);
				}				
			} 
			else 
			{
				if(window.removeEventListener) 
				{
					window.removeEventListener("keydown", addSlideShowKeyDownEvent, false);
					window.removeEventListener("resize", setSlideShowScreenScale, false);
					window.removeEventListener("mousedown", addSlideShowMouseDownEvent, false);	
					window.removeEventListener("mousemove", addSlideShowMouseMoveEvent, false);
					window.removeEventListener("click", addSlideShowClickEvent, false);	
					window.removeEventListener("mousewheel", addSlideShowWeelEvent, false);	
					window.removeEventListener("DOMMouseScroll", addSlideShowWeelEvent, false);	
				}	
				
				var contextMenuObj = document.getElementById("dze_idx_oneffice_show_contextmenu_container");
				if (contextMenuObj) {
					document.getElementById("viewerFrame").removeChild(contextMenuObj);
				}
				setSlideShowCursorStyle(-1);
			}
			
			if(bAct === true) {
				
				g_slideNo = 1;
				if(typeof(directSlideNo) === "number") {
					g_slideNo = directSlideNo;
				}
				setFullScreen();
				showSlide();
				showSlideController(false);
				
			} else {
				setFullScreen();
				showSlideController(true);
				allMovieReset();
			}

			if (bAct && bAlert) {
				cmnMsg.showMsg(MESSAGE_CHECK,ID_RES_CONST_STRING_SLIDE_SHOW_CONFIRM,null,[ID_RES_DIALOG_BTN_OK], function()
				{
					cmnMsg.hideMsg();
					document.getElementById("dze_idx_oneffice_go_show_slide_btn").click();
				});
			}
			
		} catch (e) {
			
			dalert(e);
			
		}

	}


	function addSlideShowKeyDownEvent(evnt) {
		try {
			
			//console.log("evnt.keyCode:"+evnt.keyCode);
			if (g_objOnefficeShot.m_bShow === true) {
				//TBCancelBubbleEvent(evnt);
				if (evnt.keyCode === 27) {
					document.getElementById("viewerFrame").style.overflow = "hidden";
					if(g_bSlideMode)
						showSlide();
					else {
						slideList.forEach(function(elem){
							elem.style.display = "";
							elem.style.opacity = "1";
					});
					}
				}
				return;
			}
			
			if (document.getElementById("viewerFrame").style.overflowY !== "hidden") 
			{
				if (!document.getElementById("viewerFrame").msRequestFullscreen) 
				{
					if (evnt.keyCode == ID_KEYCODE_ARROW_TOP) 
					{
						
						if (document.getElementById("viewerFrame").scrollTop > 0)
							document.getElementById("viewerFrame").scrollTop = Math.max(0,  document.getElementById("viewerFrame").scrollTop - 30);
						TBCancelBubbleEvent(evnt);
						return;
					}
		
					if (evnt.keyCode == ID_KEYCODE_ARROW_BOTTOM) 
					{
						if ((document.getElementById("viewerFrame").scrollHeight - document.getElementById("viewerFrame").scrollTop) > document.getElementById("viewerFrame").clientHeight)
							document.getElementById("viewerFrame").scrollTop = Math.min(document.getElementById("viewerFrame").scrollHeight - document.getElementById("viewerFrame").scrollTop, document.getElementById("viewerFrame").scrollTop + 30);
						TBCancelBubbleEvent(evnt);
						return;					
					}
				}
				else 
				{
					if (evnt.keyCode == ID_KEYCODE_ARROW_TOP || evnt.keyCode == ID_KEYCODE_ARROW_BOTTOM) 
						return;
				}
			}
			
			if (evnt.keyCode ==  ID_KEYCODE_PAGE_DOWN || evnt.keyCode ==  ID_KEYCODE_ARROW_RIGHT || evnt.keyCode ==  ID_KEYCODE_ARROW_BOTTOM) 
			{
				showNextSlide();
				TBCancelBubbleEvent(evnt);
			}				

			if (evnt.keyCode == ID_KEYCODE_PAGE_UP || evnt.keyCode == ID_KEYCODE_ARROW_LEFT || evnt.keyCode == ID_KEYCODE_ARROW_TOP) 
			{
				showPrevSlide();
				TBCancelBubbleEvent(evnt);
			}
		} 
		catch (e) 
		{
			dalert(e);
		}
	}

	function setSlideShowScreenScale() {
		try {
			//console.log("setSlideShowScreenScale Call : slideNo : "+slideNo);
			//화면에 보이는 사이즈 측정
			var windowHeight = 0;
			if(document.documentElement.scrollWidth) {

				if(window.innerHeight) {
					windowHeight = window.innerHeight;
				} else {
					windowHeight = document.documentElement.clientHeight;
				}

			} else {
				windowHeight = document.getElementById("viewerFrame").scrollHeight;
			}				

			if(g_bSlideMode === true) {
				
				zoomOutList(false);

				var printablePageHeightMm =  dzeUiConfig.nSettingPaperSize.height;
				var pixToMmRatio =  ONE_PX2MM;
				var printablePageHeightPx = Math.round(printablePageHeightMm / pixToMmRatio);
				var zoomRatio = (windowHeight)/printablePageHeightPx;

				zoomRatio = zoomRatio.toFixed(2);
				document.getElementById("viewerFrame").style.overflow = "hidden";

				//chrome에서 element에 transform scale 적용시 가로/세로 전체 사용처리
				document.getElementById("viewerFrame").style.width = "100%";
				document.getElementById("viewerFrame").style.height = "100%";

			    changeCss(".dze_printpreview_pagebox","margin","0px auto", document);
				
				//scale 조정
				var pages = document.getElementsByClassName("dze_printpreview_pagebox");
				for(var i = 0; i < pages.length; i++) {
					pages[i].style.transform			= "scale("+zoomRatio+")";			
					pages[i].style.msTransform			= "scale("+zoomRatio+")";
					pages[i].style.WebkitTransform		= "scale("+zoomRatio+")";			
					pages[i].style.transformOrigin		= "center top";
					pages[i].style.msTransformOrigin	= "center top";
					pages[i].style.margin				= "0px auto";
					pages[i].style.borderWidth			= "0px";
				}
				
				showAllPageNumLayer(false);

			} else {
				//document.getElementById("viewerFrame").style.zoom = 1;
				//document.getElementById("viewerFrame").style.overflow = "auto";
				//document.getElementById("viewerFrame").style.backgroundColor = "#f2f2f2";
				document.getElementById("viewerFrame").removeAttribute("style");
				
				if(g_browserCHK.mobile === true)
					document.getElementById("viewerFrame").style.backgroundColor = "#F6F7F9";
				else
					document.getElementById("viewerFrame").style.backgroundColor = "#000000";
				
				
				
				changeCss(".dze_printpreview_pagebox","margin","15px auto", document);
				
				//scale 원복
				var pages = document.getElementsByClassName("dze_printpreview_pagebox");
				for(var i = 0; i < pages.length; i++) {
					pages[i].style.transform			= "scale(1)";
					pages[i].style.msTransform			= "scale(1)";
					pages[i].style.WebkitTransform		= "scale(1)";
					pages[i].style.transformOrigin		= "";
					pages[i].style.msTransformOrigin	= "";
					pages[i].style.margin				= "15px auto";
					pages[i].style.borderWidth			= "1px";
				}
				
				if(bIsZoomout === true) {
					zoomOutList(false);
				}		
				//set slide position
				setSlidePositionInSlideList(g_slideNo, false);
				
				//showPageNumLayer(slideList[slideNo-1], true);
				showAllPageNumLayer(true);
				
				//커서스타일 원복
				//setSlideShowCursorStyle(-1);
			}
					
		} catch (e) {
			
			dalert(e);
			
		}
	}

	var g_clickMouseMove = false;
	var g_movePrevX = 0;
	var g_movePrevY = 0;
	//movementX, movementY IE에서 제공을 안함.

	function addSlideShowMouseMoveEvent(evnt) {
		try {
			if (evnt.buttons > 0 && !document.getElementById("viewerFrame").msRequestFullscreen) 
			{
				var movementX = (g_movePrevX ? evnt.screenX - g_movePrevX : 0)
				var movementY = (g_movePrevY ? evnt.screenY - g_movePrevY : 0)
			
				if (document.getElementById("viewerFrame").style.overflowY !== "hidden") {
					var pageDiv = document.getElementById("totalPageContainer");
					var cursorUrl = null;
					cursorUrl = dzeEnvConfig.strPath_Image + "grab.cur";
					document.getElementById("viewerFrame").style.cursor = "url("+cursorUrl+"), pointer";

					if (slideList[g_slideNo-1])
						slideList[g_slideNo-1].style.cursor = "url("+cursorUrl+"), pointer";
					if (movementY < 0 &&  document.getElementById("viewerFrame").scrollTop > 0) {
						document.getElementById("viewerFrame").scrollTop += movementY;
					}else if (movementY > 0 &&  (pageDiv.scrollHeight - document.getElementById("viewerFrame").scrollTop) > document.getElementById("viewerFrame").clientHeight) {
						document.getElementById("viewerFrame").scrollTop += movementY;
					}
					console.log(" ShowMouseMove movementY = " + movementY + " evnt.screenY = " + evnt.screenY);
					document.documentElement.scrollHeight;
					document.documentElement.offsetHeight;
					document.documentElement.clientHeight;
				}

				g_movePrevX = evnt.screenX;
				g_movePrevY = evnt.screenY;
				g_clickMouseMove = true;
			}
		} 
		catch (e)
		{
			dalert(e);
		}
	}

	function addSlideShowMouseDownEvent(evnt) {
		try {
			console.log(" addSlideShowMouseDownEvent evnt.clientY = " + evnt.clientY + " evnt.screenY =" + evnt.screenY);
			TBCancelBubbleEvent(evnt);
		} 
		catch (e)
		{
			dalert(e);
		}

	}

	function addSlideShowClickEvent(evnt) {
		
		try {
			console.log(" addSlideShowClickEvent= " + evnt.clientY + " evnt.buttons = "+ evnt.buttons);

			g_movePrevX = 0;
			g_movePrevY = 0;
			if (g_objOnefficeShot.bShow == true)
				return;
				
			var contextmenuObj = document.getElementById("dze_idx_oneffice_show_contextmenu_container");
			if ( contextmenuObj && contextmenuObj.style.display !== "none")
			{
				contextmenuObj.style.display = "none";
				return;
			}
			
			
			if (g_clickMouseMove !== true) 
			{
				showNextSlide();
			}
			else 
			{
				//이전 Cursor로 변경
				if (document.getElementById("viewerFrame").style.overflowY !== "hidden") {
					setSlideShowCursorStyle(g_cursorStyle);
				}
			}
			g_clickMouseMove = false;
			
			
			var mclickObj = evnt.srcElement ? evnt.srcElement : evnt.target;
			/*
			if(mclickObj.nodeName.toLowerCase() == "a" && mclickObj.href.indexOf("#") != 0) {
				
				window.open(mclickObj.href,"","width=800,height=600,left=0,top=0,resizable=yes,scrollbars=yes");
				TBCancelBubbleEvent(evnt);
				return;
			}
			*/
			if(mclickObj.nodeName.toLowerCase() != "video" && mclickObj.nodeName.toLowerCase() != "a") {
//				showNextSlide();
//				TBCancelBubbleEvent(evnt);
			}		
			
		} catch (e) {
			dalert(e);
		}	
	}

	var g_MouseScrollStop = 0;

	function addSlideShowContextmenu(evnt) {
		try{
			//console.alert("slideShowContextMenu");
			var contextmenuObj = document.getElementById("dze_idx_oneffice_show_contextmenu_container");
			if (contextmenuObj) {

				if (window.outerWidth === screen.width && window.outerHeight === screen.height) {
					document.getElementById("dze_idx_oneffice_context_show_slide_btn").style.display = "none";
					document.getElementById("dze_idx_oneffice_context_close_show_slide_btn").style.display = "";
				} 
				else if ((document.fullScreenElement !== undefined && document.fullScreenElement === null) || (document.msFullscreenElement !== undefined && document.msFullscreenElement === null) || (document.mozFullScreen !== undefined && !document.mozFullScreen) || (document.webkitIsFullScreen !== undefined && !document.webkitIsFullScreen)) 
				{
					document.getElementById("dze_idx_oneffice_context_show_slide_btn").style.display = "";
					document.getElementById("dze_idx_oneffice_context_close_show_slide_btn").style.display = "none";
				} 
				else 
				{
					document.getElementById("dze_idx_oneffice_context_show_slide_btn").style.display = "none";	
					document.getElementById("dze_idx_oneffice_context_close_show_slide_btn").style.display = "";
				}		

				contextmenuObj.style.display = "block";
				contextmenuObj.style.left = evnt.clientX;
				contextmenuObj.style.top = evnt.clientY;
			}
			
		}catch(e) {
			dalert(e);
		}
	}

	function addSlideShowWeelEvent(evnt) {
		
		try {
			
			if (g_objOnefficeShot.m_bShow === false && !document.getElementById("viewerFrame").msRequestFullscreen) 
			{
				var e = evnt || window.event;
				var delta = Math.max(-1, Math.min(1, e.wheelDelta || -e.detail));	
				if(delta < 0) 
				{
					if (document.getElementById("viewerFrame").style.overflowY === "hidden") {
						showNextSlide();
						return;
					}
					else 
					{
						if (document.getElementById("viewerFrame").scrollHeight - document.getElementById("viewerFrame").scrollTop <= document.getElementById("viewerFrame").clientHeight)
						{
							if (g_MouseScrollStop === 0) 
							{
								g_MouseScrollStop = 1;
								return;
							}
						}
		
						if (g_MouseScrollStop === 1)
						{
							document.getElementById("viewerFrame").scrollTop = 0;
							g_MouseScrollStop = 0;
							showNextSlide();
						}
						else if (g_MouseScrollStop === 2)
							g_MouseScrollStop = 0;
					}
				} 
				else 
				{
					if (document.getElementById("viewerFrame").style.overflowY === "hidden") {
						showPrevSlide();
					}
					else 
					{
						if (document.getElementById("viewerFrame").scrollTop <= 0) 
						{
							if (g_MouseScrollStop === 0) {
								g_MouseScrollStop = 2;
								return;
							}
						}
		
						if (g_MouseScrollStop === 2)
						{
							g_MouseScrollStop = 0;
							if (g_slideNo == 1)
								return;
							showPrevSlide();
							document.getElementById("viewerFrame").scrollTop = document.getElementById("viewerFrame").scrollHeight - document.getElementById("viewerFrame").clientHeight;
						}
						else if (g_MouseScrollStop === 1)
							g_MouseScrollStop = 0;
					}
				}
				TBCancelBubbleEvent(evnt);
			}

		} catch (e) {
			dalert(e);
		}
		
	}

	function showPageNumLayer(slideObj, bShow) {
		try
		{
			var pageNumLayer = slideObj.childNodes[slideObj.childNodes.length-1];
			if(pageNumLayer && pageNumLayer.className == "slidePageNumLayer") {
				if(bShow === true) {
					if(pageNumLayer.style.display != "block") {
						pageNumLayer.style.display = "block";
					}
				} else {
					if(pageNumLayer.style.display != "none") {
						pageNumLayer.style.display = "none";
					}
				}
			}
		}
		catch(e)
		{
			dalert(e);
		}
	}
	function showAllPageNumLayer(bShow) {
		try
		{
			if(slideList.length == 0) return;
			if(dzeUiConfig.bOfficeOnePageLongMode === true) return;
			
			//console.log("-------------------------------showAllPageNumLayer bShow = " + bShow);
			
			for(var i = 0; i < slideList.length; i++) {
				showPageNumLayer(slideList[i], bShow);
			}
		}
		catch(e)
		{
			dalert(e);
		}
	}


	function showSlide() {				
		try {
			
			if(slideList.length == 0) return;
			if(dzeUiConfig.bOfficeOnePageLongMode === true) return;
			
			var currSlideNo = g_slideNo-1;
			var currSlide = slideList[currSlideNo];
			
			if(typeof(currSlide) == "undefiend") return;

			//document안에 chart canvas가 있으면 animation을 재 시작.
			var canvasTags = currSlide.getElementsByTagName("canvas");
			var chartIDs = [];
			for (var i = 0; i < canvasTags.length; i++  )
			{
				if (canvasTags[i].id.indexOf("canvas_chart") >= 0) {
				//animation 재시작
					chartIDs.push(canvasTags[i].id);
				}
			}

			if (chartIDs.length > 0){
				console.log("showSlide = " + this);
				setChartAnimation(true, chartIDs);
			}
			
			
			//table내 backgroundImage 가 gif이면 새로 삽입
			var tables = currSlide.getElementsByTagName("table");
			for(var i = 0;i < tables.length; i++) {				
				var EXP = /\.gif/;
				if(tables[i].style.backgroundImage && EXP.test(tables[i].style.backgroundImage)) {
					tables[i].style.backgroundImage = tables[i].style.backgroundImage.replace(/\.gif[\?0-9]*/,".gif?"+new Date().getTime());
				}
			}

			allMovieReset();

			//video autoplay set
			var videos = currSlide.getElementsByTagName("video");
			for(var i = 0;i < videos.length; i++) {
				//videos[i].pause();
				videos[i].currentTime = 0;			
				if(videos[i].getAttribute("playtype") == "Auto") {
					videos[i].play();
				}
			}

			//showPageNumLayer(currSlide, false);

			duzon_dialog.fade("in",currSlide, function() {
				showToastMsg(g_slideNo + " " + ID_RES_CONST_STRING_PAGE,1.5);
			}, 30);		
			/*
		   currSlide.style.display = "block";
		   currSlide.style.opacity = "1";
		   showToastMsg(slideNo + " 페이지",1.5);
			*/

			
		} catch (e) {
			
			dalert(e);
			
		}		
	}
	function hideSlide(direction, callback) {
		
		try {
			
			if(slideList.length == 0) return;
			if(dzeUiConfig.bOfficeOnePageLongMode === true) return;
			
			var currSlideNo = g_slideNo-1;		
			if(typeof(slideList[currSlideNo]) == "undefined") return;
			
			var currSlide = slideList[currSlideNo];
			
			//showPageNumLayer(currSlide, true);

			//duzon_dialog.fade("out",currSlide, callback, 20);		
			
			currSlide.style.display = "none";
			if(typeof(callback) === "function") {
				callback();
			}
			return;
					
			var cnt  = 0;
			var currSlideMarginTop = 0;
			var currOpacity = 1;
			var moveSize = 100;
			var timer = setInterval(function () {

				//console.log("act....");

				if(direction == "up") {

					if(parseInt(currSlide.style.marginTop)) {
						var currSlideMarginTop =  parseInt(currSlide.style.marginTop.replace(/px/,''),10);
//						currSlide.style.marginTop = (currSlideMarginTop - moveSize) + "px";
					} else {
//						currSlide.style.marginTop = (- moveSize) + "px";
					}

				} else {

					if(parseInt(currSlide.style.marginTop)) {
						var currSlideMarginTop =  parseInt(currSlide.style.marginTop.replace(/px/,''),10);
//						currSlide.style.marginTop = (currSlideMarginTop + moveSize) + "px";
					} else {
//						currSlide.style.marginTop = (moveSize) + "px";
					}

				}

				currOpacity = (10 - cnt) / 10;
				currSlide.style.opacity = currOpacity;
				//duzon_dialog.setOpacity(currSlide, currOpacity);

				if(cnt >= 10) {
//					currSlide.style.marginTop = "15px";
					currSlide.style.display = "none";
					clearInterval(timer);
					callback();
					return;
				}

				cnt++;

			}, 30);

		} catch (e) {
			
			dalert(e);
			
		}

	}

	function showNextSlide() {
		
		try {
			
			if(g_slideNo < totalSlideCount) {
				hideSlide("up", function() {
					g_slideNo += 1;
					if (document.getElementById("viewerFrame").scrollTop > 0)
						document.getElementById("viewerFrame").scrollTop = 0;
					showSlide();
					//showToastMsg(slideNo + " 페이지",1.5);
				});
			} else {
				showToastMsg(ID_RES_CONST_STRING_LAST_PAGE,1.5);
				return;
			}
			
		} catch (e) {
			
			dalert(e);
			
		}		
	}

	function showPrevSlide() {
		
		try {
			
			if(g_slideNo > 1) {
				hideSlide("down", function() {
					g_slideNo -= 1;
					if (document.getElementById("viewerFrame").scrollTop > 0)
						document.getElementById("viewerFrame").scrollTop = 0;

					showSlide();
					//showToastMsg(slideNo + " 페이지",1.5);
				});
			} else {
				showToastMsg(ID_RES_CONST_STRING_FIRST_PAGE,2);
				return;
			}
			
		} catch (e) {
			
			dalert(e);
			
		}
			
	}
	function setFullScreen() {
		try {
			var elem = document.getElementById("viewerFrame");
			// ## The below if statement seems to work better ## if ((document.fullScreenElement && document.fullScreenElement !== null) || (document.msfullscreenElement && document.msfullscreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
			if(g_bSlideMode === true) {
				if ((document.fullScreenElement !== undefined && document.fullScreenElement === null) || (document.msFullscreenElement !== undefined && document.msFullscreenElement === null) || (document.mozFullScreen !== undefined && !document.mozFullScreen) || (document.webkitIsFullScreen !== undefined && !document.webkitIsFullScreen)) {

					if (elem.requestFullScreen) {
						elem.requestFullScreen();
					} else if (elem.mozRequestFullScreen) {
						elem.mozRequestFullScreen();
					} else if (elem.webkitRequestFullscreen) {
						elem.webkitRequestFullscreen();
					} else if (elem.msRequestFullscreen) {
						elem.msRequestFullscreen();
					}
				}
			}
			else 
			{
				if (document.cancelFullScreen) {
					document.cancelFullScreen();
				} else if (document.mozCancelFullScreen) {
					document.mozCancelFullScreen();
				} else if (document.webkitCancelFullScreen) {
					document.webkitCancelFullScreen();
				} else if (document.msExitFullscreen) {
					document.msExitFullscreen();
				}

//				setSlideShowMode(false);

			}
			
		} catch (e) {
			
			dalert(e);
			
		}
		
	}


	var toastMsgTimer = null;
	function showToastMsg(msg, sec) {
		try
		{
			var msgElement = document.getElementById("dze_idx_oneffice_show_msg");
			if(!msgElement) {
				var msgElement = document.createElement("div");
				msgElement.id = "dze_idx_oneffice_show_msg";
				msgElement.className = "oneffice_show_msg";
				document.getElementById("viewerFrame").appendChild(msgElement);
			}
			msgElement.innerHTML = msg;
			
			if(toastMsgTimer != null) {
				clearTimeout(toastMsgTimer);
				msgElement.style.display = "none";		
			}
				
			duzon_dialog.fade("in", msgElement, function() {

				toastMsgTimer = setTimeout(function() {
					
					toastMsgTimer = null;
					duzon_dialog.fade("out", msgElement, function() {
						
					});

				},sec*1000);
				
			});
		} 
		catch (e) 
		{
			dalert(e);		
		}
	}


	function createSlideController() 
	{	
		try 
		{		
			var ctlContainer = document.createElement("div");
			ctlContainer.id = "dze_idx_oneffice_slide_controller";
			ctlContainer.className = "oneffice_slide_controller";
			ctlContainer.style.display = "none";
			ctlContainer.onmouseenter = function(evnt) {
				//this.style.opacity = "1";
				duzon_dialog.fade("in",this);
				TBCancelBubbleEvent(evnt);			
			};
			ctlContainer.onmouseleave = function(evnt) {
				this.style.opacity = "0";
			};
			ctlContainer.onmousedown = function(evnt) {
				TBCancelBubbleEvent(evnt);
			};

			/*
			var btnShowSlide = document.createElement("button");
			btnShowSlide.id = "idx_btn_show_slide";		
			btnShowSlide.innerHTML = "슬라이드쇼";
			btnShowSlide.onclick = function() {
				setSlideShowMode(true);
			};
			*/
			var btnShowSlideContainer = document.createElement("div");
			btnShowSlideContainer.id = "idx_btn_show_slide";		
			btnShowSlideContainer.className = "btn_show_slide_ctl";
			btnShowSlideContainer.style.marginBottom = "20px";
			btnShowSlideContainer.innerHTML = ID_RES_CONST_STRING_SLIDE_SHOW;
			//btnShowSlideContainer.appendChild(btnShowSlide);
			btnShowSlideContainer.onclick = function() {
				createContextMenu();
				setSlideShowMode(true, 1, true);
			};
			btnShowSlideContainer.onmouseover = function() {
				this.className = "btn_show_slide_ctl_over";
			};
			btnShowSlideContainer.onmouseout = function() {
				this.className = "btn_show_slide_ctl";
			};
			btnShowSlideContainer.onmousedown = function() {
				this.className = "btn_show_slide_ctl_down";
			};
			btnShowSlideContainer.onmouseup = function() {
				this.className = "btn_show_slide_ctl_over";
			};

			//thumbnail view
			var btnShowThumbnail = document.createElement("div");
			btnShowThumbnail.id = "idx_btn_show_thumbnail";		
			btnShowThumbnail.className = "btn_show_slide_ctl";
			btnShowThumbnail.innerHTML = IE_RES_CONST_STRING_THUMBNAIL_VIEW;
			//btnShowSlideContainer.appendChild(btnShowSlide);
			btnShowThumbnail.onclick = function() {
				showPgThumbnailView();
			};
			btnShowThumbnail.onmouseover = function() {
				this.className = "btn_show_slide_ctl_over";
			};
			btnShowThumbnail.onmouseout = function() {
				this.className = "btn_show_slide_ctl";
			};
			btnShowThumbnail.onmousedown = function() {
				this.className = "btn_show_slide_ctl_down";
			};
			btnShowThumbnail.onmouseup = function() {
				this.className = "btn_show_slide_ctl_over";
			};


			var btnShowZoomOut = document.createElement("div");
			btnShowZoomOut.id = "idx_btn_show_zoomout";
			btnShowZoomOut.className = "btn_show_slide_ctl";
			btnShowZoomOut.innerHTML = ID_RES_CONST_STRING_ZOOM_OUT + "(-)";
			btnShowZoomOut.onclick = function() {
				zoomOutList(true, true);
				//changeCss(".dze_printpreview_pagebox", "float", "left", document);
				//changeCss(".dze_printpreview_pagebox", "margin", "20px", document);
				//document.getElementById('totalPageContainer').style.width = "7000px";
			};
			btnShowZoomOut.onmouseover = function() {
				this.className = "btn_show_slide_ctl_over";
			};
			btnShowZoomOut.onmouseout = function() {
				this.className = "btn_show_slide_ctl";
			};
			btnShowZoomOut.onmousedown = function() {
				this.className = "btn_show_slide_ctl_down";
			};
			btnShowZoomOut.onmouseup = function() {
				this.className = "btn_show_slide_ctl_over";
			};



			var btnShowZoomIn = document.createElement("div");
			btnShowZoomIn.id = "idx_btn_show_zoomin";
			btnShowZoomIn.className = "btn_show_slide_ctl";
			btnShowZoomIn.style.display = "none";
			btnShowZoomIn.innerHTML = ID_RES_CONST_STRING_ZOOM_IN + "(+)";
			btnShowZoomIn.onclick = function() {
				zoomOutList(false, true);
			};		
			btnShowZoomIn.onmouseover = function() {
				this.className = "btn_show_slide_ctl_over";
			};
			btnShowZoomIn.onmouseout = function() {
				this.className = "btn_show_slide_ctl";
			};		
			btnShowZoomIn.onmousedown = function() {
				this.className = "btn_show_slide_ctl_down";
			};
			btnShowZoomIn.onmouseup = function() {
				this.className = "btn_show_slide_ctl_over";
			};
			/*
			var btnShowZoomContainer = document.createElement("div");
			btnShowZoomContainer.appendChild(btnShowZoomOut);
			btnShowZoomContainer.appendChild(btnShowZoomIn);
			*/


			var btnShowScrollTop = document.createElement("div");
			btnShowScrollTop.id = "idx_btn_show_scrolltop";
			btnShowScrollTop.className = "btn_show_slide_ctl";
			btnShowScrollTop.style.marginTop = "20px";
			btnShowScrollTop.innerHTML = "Top";
			btnShowScrollTop.onclick = function() {
				setSlidePositionInSlideList(1, true);
			};		
			btnShowScrollTop.onmouseover = function() {
				this.className = "btn_show_slide_ctl_over";
			};
			btnShowScrollTop.onmouseout = function() {
				this.className = "btn_show_slide_ctl";
			};		
			btnShowScrollTop.onmousedown = function() {
				this.className = "btn_show_slide_ctl_down";
			};
			btnShowScrollTop.onmouseup = function() {
				this.className = "btn_show_slide_ctl_over";
			};

			var btnShowContainerSpacer1 = document.createElement("div");
			btnShowContainerSpacer1.className = "btn_show_slide_ctl_spacer";
			var btnShowContainerSpacer2 = document.createElement("div");
			btnShowContainerSpacer2.className = "btn_show_slide_ctl_spacer";
			var btnShowContainerSpacer3 = document.createElement("div");
			btnShowContainerSpacer3.className = "btn_show_slide_ctl_spacer";

			if(dzeUiConfig.bOfficeOnePageLongMode !== true) {
				ctlContainer.appendChild(btnShowSlideContainer);
				ctlContainer.appendChild(btnShowThumbnail);
			}
			
			ctlContainer.appendChild(btnShowContainerSpacer2);
			
			
			ctlContainer.appendChild(btnShowZoomOut);
			ctlContainer.appendChild(btnShowZoomIn);
			//ctlContainer.appendChild(btnShowContainerSpacer3);		
			
			ctlContainer.appendChild(btnShowScrollTop);
			document.getElementById("viewerFrame").appendChild(ctlContainer);
			showSlideController(true);
		} catch (e) {
			dalert(e);
		}
		
	}
	function showSlideController(bShow) {
		try
		{
			var ctlContainer = document.getElementById("dze_idx_oneffice_slide_controller");
			if(bShow === true) {
				ctlContainer.style.display = "";		
				//duzon_dialog.fade("in",ctlContainer);
			} else {
				ctlContainer.style.display = "none";
				//duzon_dialog.fade("out",ctlContainer);
			}
			
			//slideshowmenu는 반대로
			showSlideShowMenu(!bShow);
			
		} 
		catch (e) 
		{
			dalert(e);		
		}
	}

	function createContextMenu() {
		if (document.getElementById("dze_idx_oneffice_show_contextmenu_container"))
			return;
		
		var contextmenuDiv = document.createElement("div");
		contextmenuDiv.id = "dze_idx_oneffice_show_contextmenu_container";
		contextmenuDiv.className = "dze_oneffice_context_menu_container";
		//Menu Create
		var innerHTML =
		"<div class='dze_menu_sub_parent'><div class='dze_menu_sub_contentChild'>"+ ID_RES_CONST_STRING_ZOOM_INOUT + "</div><div class='dze_menu_sub_iconChild'>></div>";

		var goNextBtn = createcommonDivMenu("dze_idx_oneffice_context_next_slide_btn", "dze_oneffice_context_slideshow_btn", null,ID_RES_CONST_STRING_NEXT_SLIDE, 0);
		var goPrevBtn = createcommonDivMenu("dze_idx_oneffice_context_prev_slide_btn", "dze_oneffice_context_slideshow_btn", null, ID_RES_CONST_STRING_PREV_SLIDE, 1);
		var goMoveBtn = createcommonDivMenu("dze_idx_oneffice_context_move_slide_btn", "dze_oneffice_context_slideshow_btn", null,ID_RES_CONST_STRING_MOVE_SLIDE, 2);
		var goZoomBtn = createcommonDivMenu("dze_idx_oneffice_context_zoom_slide_btn", "dze_oneffice_context_slideshow_btn", null, innerHTML, 3);
		
		createSubZoomOutMenu(goZoomBtn, "dze_idx_oneffice_context_zoomRatio_box");

		goZoomBtn.onmouseover= function(evnt) {
			setZoomCheck("dze_idx_oneffice_context_zoomRatio_box");
			this.lastChild.style.display = "block";
			var clientWidth = document.getElementById("dze_idx_oneffice_context_cursor_btn").clientWidth;
			this.lastChild.style.left = clientWidth;
			this.lastChild.style.top = "0px";
		}
		
		goZoomBtn.onmouseleave= function(evnt) {
			this.lastChild.style.display = "none";
		}
		//cursor
		if(dzeUiConfig.aSlideShowCursorList.length > 0) {
			innerHTML = "<div class='dze_menu_sub_parent'><div class='dze_menu_sub_contentChild'>"+ ID_RES_CONST_STRING_POINTER_OPTION + "</div><div class='dze_menu_sub_iconChild'>></div>";
			var showCursorBtn = createcommonDivMenu("dze_idx_oneffice_context_cursor_btn", "dze_oneffice_context_slideshow_btn", null,innerHTML, 4);
			createSubCursorMenu(showCursorBtn, "dze_idx_oneffice_context_cursor_box");

			showCursorBtn.onmouseover= function(evnt) {
				setCurorCheck("dze_idx_oneffice_context_cursor_box");
				this.lastChild.style.display = "block";
				var clientWidth = document.getElementById("dze_idx_oneffice_context_cursor_btn").clientWidth;
				
				this.lastChild.style.left = clientWidth;
				this.lastChild.style.top = "0px";
			}
			
			showCursorBtn.onmouseleave= function(evnt) {
				this.lastChild.style.display = "none";
			}
		}

		var goShowBtn = createcommonDivMenu("dze_idx_oneffice_context_show_slide_btn", "dze_oneffice_context_slideshow_btn", null, ID_RES_CONST_STRING_VIEW_SHOW, 6);
		goShowBtn.onclick = function(evnt) {
			setFullScreen();
			displaySlideShowMenu(true);
			var contextmenuObj = document.getElementById("dze_idx_oneffice_show_contextmenu_container");
			if (contextmenuObj) {
				contextmenuObj.style.display = "none";
			}
			TBCancelBubbleEvent(evnt);

			setTimeout(function() {
				displaySlideShowMenu(false);
			}, 3000);	
		};		

		var closeShowBtn = createcommonDivMenu("dze_idx_oneffice_context_close_show_slide_btn", "dze_oneffice_context_slideshow_btn", null,ID_RES_CONST_STRING_SLIDE_SHOW_EXIT, 6);

		closeShowBtn.onclick = function(evnt) {
			if(g_DirectShowMode === true) {					
				window.close();
			} else {
				setSlideShowMode(false);
			}
			TBCancelBubbleEvent(evnt);
		};
		
		contextmenuDiv.appendChild(goNextBtn);
		contextmenuDiv.appendChild(goPrevBtn);
		contextmenuDiv.appendChild(goMoveBtn);
		var separateDiv = document.createElement("div");
		separateDiv.className = "context_Menu_Separator";
		contextmenuDiv.appendChild(separateDiv);
		contextmenuDiv.appendChild(goZoomBtn);
		contextmenuDiv.appendChild(showCursorBtn);
		var separateDiv = document.createElement("div");
		separateDiv.className = "context_Menu_Separator";
		contextmenuDiv.appendChild(separateDiv);
		contextmenuDiv.appendChild(goShowBtn);
		contextmenuDiv.appendChild(closeShowBtn);
		document.getElementById("viewerFrame").appendChild(contextmenuDiv);
	}

	function createSubZoomOutMenu(parentobj, id) 
	{
		//////////////////////////////////////////////////////////////////////////////////////
		//zoom
		try {
			var zoomRatioBox = document.createElement("div");
			zoomRatioBox.id = id;
			zoomRatioBox.className = "dze_oneffice_show_cursor_box";
			parentobj.appendChild(zoomRatioBox);
			var aSlideShowZoomRatio =  [ID_RES_CONST_SLIDESHOW_ZOOM_HEIGHT, ID_RES_CONST_SLIDESHOW_ZOOM_WIDTH, 
										ID_RES_CONST_SLIDESHOW_ZOOM_125 ,ID_RES_CONST_SLIDESHOW_ZOOM_150,ID_RES_CONST_SLIDESHOW_ZOOM_175];
		
			for(var i = 0; i < aSlideShowZoomRatio.length; i++) {
				var zoomRatioBtnUnit = document.createElement("div");
				zoomRatioBtnUnit.className = "dze_menu_sub_parent";
		
				//child 1
				var zoomContentChild = document.createElement("div");
				zoomContentChild.className = "dze_menu_sub_contentChild";
				zoomContentChild.innerHTML = aSlideShowZoomRatio[i];
				zoomRatioBtnUnit.appendChild(zoomContentChild);
		
				//child 2
				var zoomIconChild = document.createElement("div");
				zoomIconChild.className = "dze_menu_sub_iconChild";
				if(i==0)
					zoomIconChild.innerHTML = "<img src='image/icon_check.png' style='visibility: visible;'></img>";
				else
					zoomIconChild.innerHTML = "<img src='image/icon_check.png' style='visibility: hidden;'></img>";
					
				zoomRatioBtnUnit.appendChild(zoomIconChild);
		
				zoomRatioBtnUnit.onclick = function(evnt) {
					setZoomRatio(evnt.srcElement.parentNode.parentNode, evnt.srcElement.parentNode);
					//evnt.srcElement.parentElement.parentElement.style.display = "none";
					displaySlideShowMenu(false);
					TBCancelBubbleEvent(evnt);
				};

				zoomRatioBox.onmouseleave = function(evnt) {
					if (evnt.srcElement.parentElement.id !== "dze_idx_oneffice_context_zoom_slide_btn") {
						evnt.srcElement.style.display = "none";
						//displaySlideShowMenu(false);
						TBCancelBubbleEvent(evnt);
					}
				};
				zoomRatioBox.appendChild(zoomRatioBtnUnit);
			}
			//////////////////////////////////////////////////////////////////////////////////////
		}catch(e)
		{
			dalert(e);
		}
	}

	function setZoomCheck(menuID) {
		var zoomRatioDiv = $_(menuID);
		if (zoomRatioDiv) {
			var childElementCount = zoomRatioDiv.childElementCount;
			for (var i =0 ; i < childElementCount; i++)
			{
				if (g_ZoomRatioIndex === i) 
				{
					if (i !== g_ZoomRatioIndex)
						zoomRatioDiv.childNodes[i].lastChild.lastChild.style.visibility = "hidden";
					else
						zoomRatioDiv.childNodes[i].lastChild.lastChild.style.visibility = "visible";
				}
			}
		}
	}

	function setCurorCheck(menuID) {
		var cursorBoxDiv = $_(menuID);
		var childTotalCnt = cursorBoxDiv.childElementCount;
		var strCursor = document.getElementById("viewerFrame").style.cursor;
		console.log ("document.body.style.cursor = " + strCursor);
		
		var selectdIndex = 0;
		if (strCursor.indexOf("red") > 0)
			selectdIndex = 1;
		else if (strCursor.indexOf("blue") > 0 )
			selectdIndex = 2;
		else if (strCursor.indexOf("green") > 0 )
			selectdIndex = 3;		
		else if (strCursor.indexOf("yellow") > 0) 
			selectdIndex = 4;
		else if (strCursor.indexOf("stick") > 0)
			selectdIndex = 5;

		if (cursorBoxDiv) 
		{
			for (var i = 0; i < childTotalCnt; i++) 
			{
				if (i !== selectdIndex)
					cursorBoxDiv.childNodes[i].lastChild.lastChild.style.visibility = "hidden";
				else
					cursorBoxDiv.childNodes[i].lastChild.lastChild.style.visibility = "visible";
			}
		}
	}

	function createSubCursorMenu(parentObj, id)
	{
		try {
			var cursorBox = document.createElement("div");
			cursorBox.id = id;
			cursorBox.className = "dze_oneffice_show_cursor_box";
			parentObj.appendChild(cursorBox);

			var viewCurImageTag = "";
			var cursorpath = "";

			for(var i = 0; i < dzeUiConfig.aSlideShowCursorList.length; i++) 
			{

				var cursorBtnUnit = document.createElement("div");
				cursorBtnUnit.className = "dze_oneffice_show_cursor_box_unit";

				var cursorImgTag = document.createElement("img");
				cursorpath = dzeEnvConfig.strPath_Image+dzeUiConfig.aSlideShowCursorList[i] + '.png';
				cursorImgTag.src = cursorpath;
				cursorImgTag.width = 16;
				cursorImgTag.height = 16;
				cursorImgTag.style.marginRight = "8px";

				var spanTag = document.createElement("span");
				spanTag.style.width = "130px";
				spanTag.innerHTML = dzeUiConfig.aSlideShowCursorList[i].split(".")[0].replace(/\_/,' ');
				
				if (i == 0)
					spanTag.textContent = ID_RES_DIALOG_STRING_BASIC;
				
				cursorBtnUnit.appendChild(cursorImgTag);
				cursorBtnUnit.appendChild(spanTag);

				//child 2
				var zoomIconChild = document.createElement("div");
				//zoomIconChild.className = "dze_menu_sub_iconChild";
				if(i==0)
					zoomIconChild.innerHTML = "<img src='image/icon_check.png' style='visibility: visible;'></img>";
				else
					zoomIconChild.innerHTML = "<img src='image/icon_check.png' style='visibility: hidden;'></img>";
					
				cursorBtnUnit.appendChild(zoomIconChild);

				cursorBtnUnit.setAttribute("cursorNo", i);
				
				cursorBtnUnit.onclick = function(evnt) {
					var cursorNo = evnt.srcElement.parentElement.getAttribute("cursorNo");
					setSlideShowCursorStyle(parseInt(cursorNo));
					displaySlideShowMenu(false);
					TBCancelBubbleEvent(evnt);
				};		

				cursorBox.onmouseleave = function(evnt) {
					if (evnt.srcElement.parentElement.id !== "dze_idx_oneffice_context_cursor_btn") {
						evnt.srcElement.style.display = "none";
						//displaySlideShowMenu(false);
						TBCancelBubbleEvent(evnt);
					}
				};
				cursorBox.appendChild(cursorBtnUnit);
			}
		}
		catch(e) 
		{

		}
	}

	function createcommonDivMenu(id, className, imgIcon, innerHtml, mode) {
		var btnCommonDiv = document.createElement("div");
		btnCommonDiv.id = id;
		btnCommonDiv.className = className;
		
		//goNextBtn.style.marginBottom = "20px";
		if (imgIcon !== null)
		{
			btnCommonDiv.style.display = "flex";
			btnCommonDiv.style.alignItems = "center";

			var btnImageDiv = document.createElement("img");
			btnImageDiv.src = "image/" + imgIcon;
			btnImageDiv.style.marginLeft = "17px";
			btnImageDiv.style.marginRight = "8px";
		
			btnCommonDiv.appendChild(btnImageDiv);
			var btnTextNode = document.createTextNode(innerHtml);
			btnCommonDiv.appendChild(btnTextNode);
			btnCommonDiv.setAttribute("btnType", mode);
		}
		else
			btnCommonDiv.innerHTML = innerHtml;

		btnCommonDiv.setAttribute("btnType", mode);

		btnCommonDiv.onclick = function(evnt) {
			var btnType = evnt.srcElement.getAttribute("btnType");
			if (btnType == 0)
				showNextSlide();
			else if (btnType == 1)
				showPrevSlide();
			else if (btnType == 2)
				showPgThumbnailView();
			else if (btnType == 3 || btnType == 4)
			{
				if(this.lastChild.style.display == "block") {
					this.lastChild.style.display = "none";
				} else {
					this.lastChild.style.display = "block";
				}
				if (btnType == 4)
					setCurorCheck("dze_idx_oneffice_cursor_box");
				else
					setZoomCheck("dze_idx_oneffice_zoomRatio_box");
			}

			if (btnType == 0 || btnType == 1|| btnType == 2)
				displaySlideShowMenu(false);
				
			TBCancelBubbleEvent(evnt);
		};	
		
		return btnCommonDiv;
	}

	function createSlideShowMenu() 
	{
		try {
			var showMenuContainer = document.createElement("div");
			showMenuContainer.id = "dze_idx_oneffice_show_menu_container";
			showMenuContainer.className = "dze_oneffice_show_menu_container";
			showMenuContainer.style.display = "none";
			showMenuContainer.onmousedown = function(evnt) {
				TBCancelBubbleEvent(evnt);	
			};
			showMenuContainer.onmouseup = function(evnt) {
				TBCancelBubbleEvent(evnt);
			};		
			showMenuContainer.onclick = function(evnt) {
				TBCancelBubbleEvent(evnt);
			};		
			showMenuContainer.onmouseover = function(evnt) {

				if(g_bSlideMode !== true) return;
				displaySlideShowMenu(true);
				TBCancelBubbleEvent(evnt);
				
			};
			showMenuContainer.onmouseleave = function(evnt) {

				if(g_bSlideMode !== true) return;
				
				//this.style.opacity = 0;
				displaySlideShowMenu(false);
				TBCancelBubbleEvent(evnt);
			};		
			
			var goNextBtn = createcommonDivMenu("dze_idx_oneffice_go_next_slide_btn", "dze_oneffice_slide_show_btn", "icon_slide_next.png", ID_RES_CONST_STRING_NEXT_SLIDE, 0);
			var goPrevBtn = createcommonDivMenu("dze_idx_oneffice_go_prev_slide_btn", "dze_oneffice_slide_show_btn", "icon_slide_pre.png", ID_RES_CONST_STRING_PREV_SLIDE, 1);
			var goMoveBtn = createcommonDivMenu("dze_idx_oneffice_go_move_slide_btn", "dze_oneffice_slide_show_btn", "icon_slide_move.png", ID_RES_CONST_STRING_MOVE_SLIDE, 2);
			var goZoomBtn = createcommonDivMenu("dze_idx_oneffice_go_zoom_slide_btn", "dze_oneffice_slide_show_btn", "icon_slide_expand.png", ID_RES_CONST_STRING_ZOOM_INOUT, 4);
			createSubZoomOutMenu(goZoomBtn, "dze_idx_oneffice_zoomRatio_box");

			//cursor
			if(dzeUiConfig.aSlideShowCursorList.length > 0) {
				var ShowCursorBtn = createcommonDivMenu("dze_idx_oneffice_cursor_show_btn", "dze_oneffice_slide_show_btn", "icon_slide_pointer.png", ID_RES_CONST_STRING_POINTER_OPTION, 4);
				createSubCursorMenu(ShowCursorBtn, "dze_idx_oneffice_cursor_box");
			}
			
			var goShowBtn = createcommonDivMenu("dze_idx_oneffice_go_show_slide_btn", "dze_oneffice_slide_show_btn", "icon_slide_exit.png", ID_RES_CONST_STRING_VIEW_SHOW, 6);
			goShowBtn.onclick = function(evnt) {
				setFullScreen();
				displaySlideShowMenu(true);
				TBCancelBubbleEvent(evnt);

				setTimeout(function() {
					displaySlideShowMenu(false);
				}, 3000);	
			};			

			var closeShowBtn = createcommonDivMenu("dze_idx_oneffice_close_show_slide_btn", "dze_oneffice_slide_show_btn", "icon_slide_exit.png", ID_RES_CONST_STRING_SLIDE_SHOW_EXIT, 6);
			closeShowBtn.onclick = function(evnt) {
				if(g_DirectShowMode === true) {					
					window.close();
				} else {
					setSlideShowMode(false);
				}
				TBCancelBubbleEvent(evnt);
			};			
			
			showMenuContainer.appendChild(goNextBtn);
			showMenuContainer.appendChild(goPrevBtn);
			goPrevBtn.style.marginTop = "10px";
			showMenuContainer.appendChild(goMoveBtn);
			goMoveBtn.style.marginTop = "10px";

			showMenuContainer.appendChild(goZoomBtn);
			goZoomBtn.style.marginTop = "10px";
			
			if(dzeUiConfig.aSlideShowCursorList.length > 0) {
				showMenuContainer.appendChild(ShowCursorBtn);
				ShowCursorBtn.style.marginTop = "10px";
			}
				
			showMenuContainer.appendChild(goShowBtn);
			goShowBtn.style.marginTop = "10px";

			showMenuContainer.appendChild(closeShowBtn);
			closeShowBtn.style.marginTop = "10px";

			document.getElementById("viewerFrame").appendChild(showMenuContainer);
			
		} catch (e) {
			
			dalert(e);
			
		}

	}
	function showSlideShowMenu(bShow) {
		try
		{
			var menuContainer = document.getElementById("dze_idx_oneffice_show_menu_container");
			if(!menuContainer) return;
			
			menuContainer.style.opacity = "0";
			
			if(bShow === true) {
				menuContainer.style.display = "";
			} else {
				menuContainer.style.display = "none";
			}
		} 
		catch (e) 
		{
			dalert(e);		
		}
	}

	function setZoomRatio(parentobj, currentObj) {
		zoomOutList(false);
		var selectedIdx = -1;
		for (var nIndex = 0 ; nIndex < parentobj.childElementCount; nIndex++) {
			if (currentObj === parentobj.childNodes[nIndex])
				selectedIdx = nIndex;
		}
		
		var iconChildBtns = parentobj.getElementsByClassName("dze_menu_sub_iconChild");

		for (var nIndex = 0; nIndex < iconChildBtns.length; nIndex++) {
			var iconElem = iconChildBtns[nIndex];
			iconElem.firstElementChild.style.visibility = "hidden";	
		}
		
		currentObj.childNodes[1].firstElementChild.style.visibility = "visible";
		
		if (selectedIdx == -1) {
			console.alert("error Selected -1");
			return;
		}

		if(document.documentElement.scrollWidth) {
			if(window.innerHeight) {
				windowHeight = window.innerHeight;
			} else {
				windowHeight = document.documentElement.clientHeight;
			}

		} else {
			windowHeight = document.getElementById("viewerFrame").scrollHeight;
		}				

		//dzeUiConfig.nSettingPaperSize.height
		var printablePageHeightMm =  dzeUiConfig.nSettingPaperSize.height;
		var printablePageWidthMm = dzeUiConfig.nSettingPaperSize.width;

		var pixToMmRatio =  ONE_PX2MM;
		var printablePageHeightPx = Math.floor(printablePageHeightMm / pixToMmRatio);
		var printablePageWitdhPx = Math.floor(printablePageWidthMm / pixToMmRatio);
		//console.log("printablePageHeightPx:"+printablePageHeightPx);

		var zoomRatio = 1;//(windowHeight)/printablePageHeightPx;
		//console.log("zoomRatio:"+zoomRatio);

		switch(selectedIdx) {
			case 0:
				zoomRatio = (windowHeight)/printablePageHeightPx;
				break;
			case 1:
				zoomRatio = (document.documentElement.clientWidth -20) / printablePageWitdhPx;
				break;
			case 2:
				zoomRatio = 1.25;
				break;
			case 3:
				zoomRatio = 1.50;
				break;
			case 4:
				zoomRatio = 1.75;
				break;
		}
		zoomRatio = zoomRatio.toFixed(2);

		/////////////////////////
		if (zoomRatio > 1) {
			document.getElementById("viewerFrame").style.overflowX = "hidden";
			document.getElementById("viewerFrame").style.overflowY = "auto";
		}
		else {
			document.getElementById("viewerFrame").style.overflowX = "hidden";
			document.getElementById("viewerFrame").style.overflowY = "hidden";
		}
			
		
		//chrome에서 element에 transform scale 적용시 가로/세로 전체 사용처리
		document.getElementById("viewerFrame").style.width = "100%";
		document.getElementById("viewerFrame").style.height = "100%";

		changeCss(".dze_printpreview_pagebox","margin","0px auto", document);
		
		//scale 조정
		var pages = document.getElementsByClassName("dze_printpreview_pagebox");
		for(var i = 0; i < pages.length; i++) {
			pages[i].style.transform			= "scale("+zoomRatio+")";			
			pages[i].style.msTransform			= "scale("+zoomRatio+")";
			pages[i].style.WebkitTransform		= "scale("+zoomRatio+")";			
			pages[i].style.transformOrigin		= "center top";
			pages[i].style.msTransformOrigin	= "center top";
			pages[i].style.margin				= "0px auto";
			pages[i].style.borderWidth			= "0px";
		}
		
		g_ZoomRatioIndex = selectedIdx;
		showAllPageNumLayer(false);
	}

	function displaySlideShowMenu(bDisplay) {
		try
		{
			var menuContainer = document.getElementById("dze_idx_oneffice_show_menu_container");
			if(!menuContainer) return;
			if(bDisplay === true) {

				if (window.outerWidth === screen.width && window.outerHeight === screen.height) {
					document.getElementById("dze_idx_oneffice_go_show_slide_btn").style.display = "none";
					document.getElementById("dze_idx_oneffice_close_show_slide_btn").style.display = "flex";
				} 
				else if ((document.fullScreenElement !== undefined && document.fullScreenElement === null) || (document.msFullscreenElement !== undefined && document.msFullscreenElement === null) || (document.mozFullScreen !== undefined && !document.mozFullScreen) || (document.webkitIsFullScreen !== undefined && !document.webkitIsFullScreen)) 
				{
					document.getElementById("dze_idx_oneffice_go_show_slide_btn").style.display = "flex";
					document.getElementById("dze_idx_oneffice_close_show_slide_btn").style.display = "none";
				} 
				else 
				{
					document.getElementById("dze_idx_oneffice_go_show_slide_btn").style.display = "none";	
					document.getElementById("dze_idx_oneffice_close_show_slide_btn").style.display = "flex";
				}		

				//ctlContainer.style.display = "";		
				//menuContainer.style.display = "";
				//duzon_dialog.fade("in",menuContainer);
				menuContainer.style.opacity = "1.0";
				
			} else {
				//menuContainer.style.display = "none";
				menuContainer.style.opacity = "0";
				if (document.getElementById("dze_idx_oneffice_show_contextmenu_container"))
					document.getElementById("dze_idx_oneffice_show_contextmenu_container").style.display = "none";

				document.getElementById("dze_idx_oneffice_zoomRatio_box").style.display = "none";
				document.getElementById("dze_idx_oneffice_cursor_box").style.display = "none";
				//duzon_dialog.fade("out",ctlContainer);
			}
		} 
		catch (e) 
		{
			dalert(e);		
		}
	}

	//슬라이드쇼 실행시 커서모양 설정 (nCursor: dzeUiConfig.aSlideShowCursorList 의 배열인덱스값 전달, 커서모양 해제는 -1 로 전달)
	function setSlideShowCursorStyle(nCursor) {
		try
		{	
			if(slideList.length == 0) return;
			
			g_cursorStyle = nCursor;

			var cursorUrl = null;
			if(nCursor >= 1) {
				cursorUrl = dzeEnvConfig.strPath_Image + dzeUiConfig.aSlideShowCursorList[nCursor] + ".cur";
			}		
			
			document.getElementById("viewerFrame").style.cursor = "url("+cursorUrl+"), pointer";
			
			for(var i = 0; i < slideList.length; i++) {
				if(cursorUrl) {
					slideList[i].style.cursor = "url("+cursorUrl+"), pointer";
				} else {
					slideList[i].style.cursor = "default";
				}				
			}
		} 
		catch (e) 
		{
			dalert(e);		
		}		
	}

	var bIsZoomout = false;
	function zoomOutList(bZoomOut, bAnimate) {
		try
		{
			//console.log("zoomOutList Call  .... bZoomOut : "+bZoomOut);
			
			window.scrollTo(0, 0);
			
			if(bAnimate !== true) {
				var bAnimate = false;	
			}
			
			//30페이지 초과시 애니메이션 끔
			if(total_page_no > 30) {
				bAnimate = false;	
			}
		   
		    //최대사이즈
		    var zoomSize = 1;
			if(bZoomOut === true) {
				
				//최소사이즈
				zoomSize = 0.25;
			}
		   
			if (g_bSlideMode) {
				document.getElementById("viewerFrame").style.height = "100%";
			}else {
				if(bZoomOut === true) {
					execZooming(document.getElementById("totalPageContainer"), "out", zoomSize, bAnimate);
					document.getElementById("viewerFrame").style.height = Math.ceil(total_page_height * zoomSize) + 10 + "px";
					//document.getElementById("totalPageContainer").style.height = document.getElementById("viewerFrame").style.height
		//			document.getElementById("viewerFrame").style.overflow = "hidden";
					
				} else {
					execZooming(document.getElementById("totalPageContainer"), "in", zoomSize, bAnimate);
					document.getElementById("viewerFrame").style.height = Math.ceil(total_page_height * zoomSize) + 10 + "px";
					//document.getElementById("totalPageContainer").style.height = document.getElementById("viewerFrame").style.height
		//			document.getElementById("viewerFrame").style.overflow = "auto";
				}
			}
			var numberElements = document.getElementsByClassName("slidePageNumLayer");
			for(var i = 0; i < numberElements.length; i++) {
				if(bZoomOut === true) {
					numberElements[i].style.fontSize = "50pt";
				} else {
					numberElements[i].style.fontSize = "";
				}
			}
			
			if(g_bSlideMode !== true) {
				bIsZoomout = bZoomOut;
			}
			
			if(bZoomOut === true) {
				document.getElementById("idx_btn_show_zoomout").style.display = "none";
				document.getElementById("idx_btn_show_zoomin").style.display = "";
			} else {
				document.getElementById("idx_btn_show_zoomout").style.display = "";
				document.getElementById("idx_btn_show_zoomin").style.display = "none";
			}
		} 
		catch (e) 
		{
			dalert(e);		
		}
		
		
	}
	function execZooming(elem, zoomAct, limitZoom, bAnimate) {
		try
		{
			
			if(typeof(bAnimate) == "undefined") {
				var bAnimate = true;
			}
			
			if(bAnimate !== true) {
				setZoom(elem, limitZoom);
				return;
			}
			
			var zoomStep = 0.05;
			var currZoom = 1;
			var applyZoom = 1; 

			/*
			if(!elem.style.zoom) {
				//elem.style.zoom = 1;
				setZoom(elem, 1);
			}
			*/
			
			if(zoomAct == "out") {
				currZoom = 1;
			} else {
				currZoom = 0.25;
			}
			
			var timer = setInterval(function() {
				
				//currZoom = parseFloat(elem.style.zoom,10);
				//console.dir(currZoom);
				
				if(zoomAct == "out") {
					
					currZoom -= zoomStep;
					
					//applyZoom = currZoom - zoomStep;
					if(currZoom <= limitZoom) {
						//elem.style.zoom = limitZoom;
						setZoom(elem, limitZoom);
						clearTimeout(timer);
						return;
					}
					
				} else {
					currZoom += zoomStep;
					//applyZoom = currZoom + zoomStep;
					if(currZoom >= limitZoom) {
						//elem.style.zoom = limitZoom;
						setZoom(elem, limitZoom);
						clearTimeout(timer);
						return;
					}
					
				}
				
				//console.log("applyZoom : "+applyZoom);
				//elem.style.zoom = applyZoom;
				setZoom(elem, currZoom);
				
			},30);
		} 
		catch (e) 
		{
			dalert(e);		
		}
		

	}
	function setZoom(elem, scale) {
//		elem.style.zoom = scale;
		elem.style.webkitTransform	= "scale("+scale+")";    // Chrome, Opera, Safari
		elem.style.msTransform		= "scale("+scale+")";       // IE 9
		elem.style.transform		= "scale("+scale+")";     // General	
		elem.style.transformOrigin		= "center top";
		elem.style.msTransformOrigin	= "center top";
//		elem.style.setAttribute("-webkit-transform","scale("+scale+")");
//		elem.style.setAttribute("-moz-transform","scale("+scale+")");
//		elem.style.setAttribute("transform","scale("+scale+")");
		
	}

	//100%리스트 상태에서 슬라이드 더블클릭시 해당 슬라이드번호 슬라이드쇼진행
	function execSlideDblClick(currPageNum) {
		
		try {
			
			if(g_bSlideMode === true) return;		
			
			var currSlide = slideList[currPageNum-1];
			
			if(currSlide) {
				//currSlide.removeAttribute("style");
			}				
			
			if(bIsZoomout === true || g_bSlideMode === true) return;
			
			setSlideShowMode(!g_bSlideMode, currPageNum);
			
		} catch (e) {
			
			dalert(e);
			
		}

	}

	//축소상태에서 슬라이드 클릭시 100% 리스팅으로 바꾸고, 클릭한 슬라이드에 포커싱
	function execSlideClick(currPageNum) {
		
		try {
			
//			if(g_bSlideMode === true) return;		
			if(bIsZoomout === false || g_bSlideMode === true) return;
			
			var currSlide = slideList[currPageNum-1];
			
			if(currSlide) {
				currSlide.removeAttribute("style");
				currSlide.style.backgroundColor = dzeUiConfig.sSettingPaperColor;
			}		
			
			
			zoomOutList(false, false);
			setSlidePositionInSlideList(currPageNum, false);
			
			
		} catch (e) {
			
			dalert(e);
			
		}

	}

	//축소모드에서 슬라이드에 마우스오버시 해당 슬라이드만 약간 확대
	function execSlideMouseOver(currPageNum) {
		try {	
			if(bIsZoomout === false || g_bSlideMode === true) 
				return;
			
			var currSlide = slideList[currPageNum-1];
			if(currSlide) {
				currSlide.style.transform			= "scale(1.1)";
				currSlide.style.msTransform			= "scale(1.1)";
				currSlide.style.WebkitTransform		= "scale(1.1)";
				currSlide.style.transformOrigin		= "center top";
				currSlide.style.msTransformOrigin	= "center top";
				currSlide.style.borderWidth			= "10px";
				currSlide.style.borderColor			= "#1c90fb";
				//currSlide.style.borderColor			= "#F07151";
				currSlide.style.borderStyle			= "solid";
				currSlide.style.zIndex				= "10001";
				currSlide.style.cursor				= "pointer";
				
				if(currPageNum > 1) {
					if(currPageNum == total_page_no) {					
						currSlide.style.marginTop			= "-130px";
					} else {
						currSlide.style.marginTop			= "-80px";
						currSlide.style.marginBottom		= "75px";
					}
				} else {
					currSlide.style.marginBottom		= "-20px";
				}
			}

			
		} catch (e) {
			
			dalert(e);
			
		}
	}

	//축소모드에서 슬라이드에 마우스오버시 해당 슬라이드만 약간 확대된것을 원래대로 복귀
	function execSlideMouseOut(currPageNum) {
		try {		
			if(bIsZoomout === false || g_bSlideMode === true) return;
			
			var currSlide = slideList[currPageNum-1];

			if(currSlide) {
				currSlide.removeAttribute("style");
				currSlide.style.backgroundColor = dzeUiConfig.sSettingPaperColor;
			}
			
		} catch (e) {
			
			dalert(e);
			
		}
	}

	function setSlidePositionInSlideList(slideNo, bAnimate) {
		try {
				if(typeof(bAnimate) == "undefined") {
					var bAnimate = true;
				}
				//SlideShowMode
				if (g_bSlideMode) 
				{
					document.getElementById("viewerFrame").style.overflow = "hidden";
					if(g_slideNo <= totalSlideCount) {
						hideSlide("up", function() {
							g_slideNo = slideNo;
							showSlide();
						});
					} 
					else {
						showToastMsg(ID_RES_CONST_STRING_LAST_PAGE,1.5);
					}	
					return;
				}

				var currSlideNo = slideNo-1;
				if(typeof(slideList[currSlideNo]) != "undefined") {
					//화면에 보이는 사이즈 측정
					var windowHeight = 0;
					if(document.documentElement.scrollWidth) {

						if(window.innerHeight) {
							windowHeight = window.innerHeight;
						} else {
							windowHeight = document.documentElement.clientHeight;
						}

					} else {
						windowHeight = document.getElementById("viewerFrame").scrollHeight;
					}	

					var printablePageHeightPx = Math.floor(dzeUiConfig.nSettingPaperSize.height / ONE_PX2MM);



					//console.log("windowHeight:"+windowHeight);
					//console.log("printablePageHeightPx:"+printablePageHeightPx);


					var emptySpaceHeight = windowHeight - printablePageHeightPx;
					//console.log("emptySpaceHeight:"+emptySpaceHeight);


					//var currSlideTop = slideList[currSlideNo].offsetTop + (emptySpaceHeight/2);
					var currSlideTop = slideList[currSlideNo].offsetTop - (emptySpaceHeight/2);
					//console.log("________________________________________________currSlideTop:"+currSlideTop);

					if(bIsZoomout === true) {
						currSlideTop = Math.floor(currSlideTop/2);
					}

					//console.log("curr scrolltop : " + document.getElementById("viewerFrame").scrollTop);
					//console.log("exe scrolltop : " + currSlideTop);


					if(bAnimate === true) {

						var startScroll = 0;
						var timer = setInterval(function() {

							startScroll += 300;
							if(startScroll >= currSlideTop) {
								window.scrollTo(0, currSlideTop);
								clearInterval(timer);
								return;
							} 
							window.scrollTo(0, startScroll);			

						},10);

					} else {
						
//						window.scrollTo(0, currSlideTop);
						setTimeout(function() {
							window.scrollTo(0, currSlideTop);
						},100);
						
					}

					/*
					*/

				}					
				
			//},400);
			

			
		} catch (e) {
			
			dalert(e);
			
		}

		
		
	}

	/*
	if (window.matchMedia) 
	{
		var mediaQueryList = window.matchMedia('print');
		mediaQueryList.addListener(function(mql) 
		{
			if (mql.matches) 
				beforePrint();
			else
				afterPrint();                    
		});
	}


	window.onbeforeprint = beforePrint;
	window.onafterprint = afterPrint;
	*/

	function showPgThumbnailView()
	{
		try
		{
			if (g_objOnefficeShot.m_bCreate === false) {
				slideList.forEach(function(elem){
					elem.style.display = "";
					elem.style.opacity = "1";
				});
			}
			document.getElementById("viewerFrame").style.overflow = "auto";		
			var bSuccess = g_objOnefficeShot.getShotScreenContainerViewer(slideList);				
		}
		catch(e)
		{
			dalert(e);		
		}	
	}

	var bStatusMobileController = false;
	var bShowMobileControllerTimer = null;
	function showMobileControlContainer(bShow) {
		try {
			var container = document.getElementById("dze_idx_oneffice_mobile_control_container");
			bStatusMobileController = true;

			if(bShowMobileControllerTimer !== null) {
				clearTimeout(bShowMobileControllerTimer);
				container.style.opacity = "1";
				bShowMobileControllerTimer = setTimeout(function() {
					container.style.opacity = "0";
					bStatusMobileController = false;
				},2000);
			} else {
				duzon_dialog.fade("in",container);
				bShowMobileControllerTimer = setTimeout(function() {
					container.style.opacity = "0";
					bStatusMobileController = false;				
				},2000);
			}
			
		} catch (e) {
			dalert(e);		
		}

	}

	function goOnefficeEdit() {
		try {
	        removeHash();	//UCDOC-1109, url에서 하이퍼링크 이동 제거

			var url = document.location.href.replace(/oneffice(\_view)*\.(html|do)/, "oneffice.html");	//2019-02-27

			if(g_HybridViewMode) {
				onefficeUtil.setCookieValue("hybridEdit", "1",10);
			}
			onefficeUtil.setCookieValue("edtM", "1",10);		
			document.location.href = url;
		} catch (e) {
			dalert(e);
		}
	}

	function allMovieReset() {	
		var totalPageContainer = document.getElementById("totalPageContainer");
		var videos = totalPageContainer.getElementsByTagName("video");
		for(var i = 0;i < videos.length; i++) {
			videos[i].pause();
//			videos[i].currentTime = 0;
		}	
	}

	window.onresize = function () {
		if (window.outerWidth === screen.width && window.outerHeight === screen.height) {
			console.log("Document FULL ScREEN CHANGE");
			displaySlideShowMenu(true);
			setChartAnimation(true);
		} else {
			//console.log("Document Full SCREEN NO CHANGE");
			//setChartAnimation(false);
		}
	};

	function setChartAnimation(bStart, chartIDs){
		if (bStart===true){
			var updateFlag = {
				duration : 1000,
				easing : 'easeOutBounce',
				bRestartAnimation : true
			};

			var _length = onefficeChart.showViewCharts.length;
			for (var i = 0 ; i< _length; i++) {
				var bFind = false;
				var chartID  = onefficeChart.showViewCharts[i].id;

				if (typeof(chartIDs) === "undefined"){
					bFind = true;
				}else{
					if(chartIDs.indexOf(chartID) < 0)
						continue;
				}
				
				var chartObj = onefficeChart.showViewCharts[i].chartHandler;
				chartObj.options.tooltips.enabled = true;
				//onefficeChart.showViewCharts[i].chartHandler.options.animation = true;
				chartObj.options.animation = {
					animateScale: true,
					animateRotate: true
				};
				
				chartObj.update(updateFlag);
			}
		}else{
			var _length = onefficeChart.showViewCharts.length;
			var updateFlag = {
				duration : 0,
				bRestartAnimation : false
			};
			for (var i = 0 ; i< _length; i++) {
				var chartObj = onefficeChart.showViewCharts[i].chartHandler;
				chartObj.options.tooltips.enabled = false;
				chartObj.options.animation = null;
				chartObj.update(updateFlag);
			}
		}
	}

	 /* 
	 @ Creater : misty
	 @ Create : 2018.12.11
	 @ Modified : 2017.12.11
	 @ contens : slideshow_Mgr 
	 */

	var g_objShowMgr = new function()
	{
		this.showNSlide = function(nPgNum)
		{//PgNum = 0이 될 수 없음.
			try {
			
				if(nPgNum && (g_slideNo <= totalSlideCount)) {
					hideSlide("up", function() {
						g_slideNo = nPgNum;//+= 1;//pgNum
						showSlide();
						//showToastMsg(slideNo + " 페이지",1.5);
					});
				} 
				else 
				{
					showToastMsg(ID_RES_CONST_STRING_INVALID_CALL,1.5);
					return;
				}
				
			} catch (e) {
				
				dalert(e);
				
			}	
		};
	};
	
	
	
	
});
