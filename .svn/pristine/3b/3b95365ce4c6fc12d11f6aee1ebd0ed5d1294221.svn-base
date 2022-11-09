/*
 * 
 */

onefficeApp.controller("ctrl_viewer", function($scope,$sce, $timeout) {
	
	$scope.bShareOpenLink = false;
	$scope.bShareEditPerm = false;

	$scope.bQRFirstStatus = false;
	$scope.bQRLastStatus = false;

	$scope.bEditMode = false;
	$scope.CommentList = new Array();
	$scope.CommentCount = 0;
	var menuScroll;
	var addSheetScroll;
	var modeViewEdit = ['viewerMode', 'editorMode'];
	$scope.viewerMode = modeViewEdit[0];
	
	$scope.$on("initViewerValue", function(event) {
		//$scope.initViewSrc();
	});
	
	$scope.initViewer = function() {
    	try {
			if ($scope.$parent.bViewerPageLoad === false) {
				// viewer page를 명시적으로 load하고 초기화 된 상태인지 체크
				return;
			}

			var objScty = $("#one_viewer");
			objScty.trigger("create");
			objScty.addClass("ui-page ui-page-theme-a").css({background: "#fff"});
			objScty.find("header").css({
				position: "absolute",
				left: "0px",
				right:" 0px",
				"z-index": 1,
				height: "56px"
			});
			
			var objSection = objScty.find("section");
			objSection.css({
				position: "absolute",
				top: "56px",
				left: "0px",
				right: "0px",
				"z-index": 0,
				overflow: "hidden",
				height: (window.height - 56 - parseInt(objSection.css("padding-top"), 10) - parseInt(objSection.css("padding-bottom"), 10))
			});

			$("#idx_viewer_menu_iscroll").css("height", (window.screen.height-56)+"px");
			menuScroll = new iScroll('idx_viewer_menu_iscroll', {"hScroll":false, "vScrollbar":false, "vScroll":true, "mousewheel":false ,"wrapperClass":"side_con"});
			
			if (g_browserCHK.androidtablet === false && g_browserCHK.iPad === false) {
				$("#id_insertsheet_container").css("max-height", window.height / 2);
				$("#id_insertsheet_container").css("height", window.height / 2);
			}
			
			addSheetScroll = new iScroll('id_insertsheet_scroll', {"hScroll":false, "vScrollbar":false, "vScroll":true, "mousewheel":false ,"wrapperClass":"insertSheet"});

			$("#id_insertsheet_scroll").css("height", ($("#id_insertsheet_container").height()-44)+"px");
			dzeJ("#id_insertsheet_scroll .menu_container").css("position", "relative");

			setTimeout(function () {menuScroll.refresh(); addSheetScroll.refresh();}, 100);

			$(".view_modal").click(function () {
				closeViewModal();
			});
			
			addListener();
			$scope.$parent.viewChange(3);
			
			$timeout($scope.initViewSrc, 100);
			
			
    	}catch(e){
    		dalert(e);
    	}
	};
	
	$scope.initViewSrc = function() {
		try {
			$scope.bEditMode = false;
			$(".quick_menu").removeClass("off");
			
			$scope.bQRFirstStatus = false;
			$scope.bQRLastStatus = false;

			$scope.viewerMode = modeViewEdit[0];
			$scope.$parent.bOnViewStatus = true;
			
			var shareBtn = document.getElementById("viewer_share_btn");
			if(shareBtn) shareBtn.outerHTML = '<dd id="viewer_share_btn" class=""><div class="toggleBG" style="background:#fff; border:1px solid #e5e5e5;"><input type="button" class="toggleFG" style="left:0px;" /></div></dd>';
			$(".r9, .r10, .r13").removeClass("on").addClass("off");
			
			var objParam = {"hybrid": "hApp"};
			
			if ($scope.$parent.bOnNewEditMode) {		// 새 문서로 진입 시에는 바로 편집 모드 진입 처리
				objParam = {"hybrid": "hApp", "newEdit": "newDoc"};
				$scope.viewerMode = modeViewEdit[1];
				
				if (g_browserCHK.iPad || g_browserCHK.androidtablet) {		// pad
					$(".homeTitle").css("position", "absolute");
					$(".homeTitle").css("margin-left", "178px");
					$(".homeTitle").css("width", "calc(100% - 360px)");
				} else {		// phone
					$(".homeTitle").fadeOut();
				}
				
				$("#viewer_quick").fadeOut();
			}
			
			if ($scope.$parent.objOpenInInfo !== null) {
				$("#mainContainer").scope().objCurrentDoc = $scope.$parent.objOpenInInfo;
				$("#mainContainer").scope().objOpenInInfo = null;
			}
			
			if ($scope.$parent.objCurrentDoc.nShareCount > 0) {
				$scope.$parent.docDataFact.updateDocShareInfo($scope.$parent.objCurrentDoc.seq).then(function() {
					setDocInfo().then(function() {
						loadDocument();
					});
				});
			} else {
				setDocInfo().then(function() {
					loadDocument();
				});
			}
			
			function loadDocument() {
				var openURL = oneffice.getViewModeDocPath($scope.$parent.objCurrentDoc.seq, objParam);
				var iFrame = $("#iFrame_viewer");
				iFrame.attr("src", openURL);
				getCommentCount();
				if ($scope.$parent.bOnNewEditMode === true || $scope.$parent.objCurrentDoc.strOpenMode === "w") {
					$scope.startEditorMode();
				} else {
					$scope.startViewerMode();
//					$timeout(function() {
//						$("#viewerFrame").scope().fnloadView($scope.$parent.objCurrentDoc.seq, objParam);
//					}, 100);
				}
				
				$(".load_doc_modal").hide();
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var setDocInfo = function() {
		try {
			return new Promise(function(resolve, reject) {
				var objDocInfo = $scope.$parent.objCurrentDoc;
				$scope.currentFileName = objDocInfo.docData.strTitle;
				
			// 제목 수정권한 체크
			// 즐겨찾기 상태 설정
				if (objDocInfo.userData.nOwnerID.length === 0
						|| $scope.myInfo.id === objDocInfo.userData.nOwnerID) {
					$("#one_viewer .side_right .rename").show();
					
					if (objDocInfo.docData.bStar == 1) {
						$("#one_viewer .side_right .toggle_star").addClass("on");
					} else {
						$("#one_viewer .side_right .toggle_star").removeClass("on");
					}
					
					$("#one_viewer .side_right .doc_title").width("calc(100% - 55px)");
				} else {
					$("#one_viewer .side_right .rename, #one_viewer .side_right .toggle_star").hide();
					
					$("#one_viewer .side_right .doc_title").width("100%");
				}
				
			// open link 권한 체크
				$scope.bShareOpenLink = false;
				
				if (objDocInfo.nShareCount > 0) {
					if (objDocInfo.bOpenLink === true) {
						$scope.bShareOpenLink = true;
						
						if (objDocInfo.shareData[0].cSharePermission === "R") {
							$scope.bShareEditPerm = false;
						} else {
							$scope.bShareEditPerm = true;
						}
						
						var shareBtn = document.getElementById("viewer_share_btn");
						
						if (shareBtn) {
							shareBtn.outerHTML = '<dd id="viewer_share_btn" class=""><div class="toggleBG"><input type="button" class="toggleFG" /></div></dd>';
						}
					}
				}
				
			// 읽기 / 쓰기 권한 체크
				var bEditPerm = true;
				
				if (objDocInfo.docData.bViewer === 1) {
					bEditPerm = false;
				} else if (objDocInfo.nShareCount > 0) {
					if (objDocInfo.userData.nOwnerID.length === 0
							|| $scope.myInfo.id === objDocInfo.userData.nOwnerID) {
						// 사용자가 문서 소유자인 경우 편집권한 제공
						bEditPerm = true;
					} else {
						// 사용자가 문서 소유자가 아닌 경우 편집권한 체크
						bEditPerm = false;
						
						if ($scope.bShareOpenLink === true && $scope.bShareEditPerm === true) {
							bEditPerm = $scope.bShareEditPerm;
						} else {
							objDocInfo.shareData.some(function(objInfo) {
								if (objInfo.nShareID === $scope.myInfo.id) {
									bEditPerm = (objInfo.cSharePermission === "W") ? true : false;
									
									return;
								}
							});
						}
					}
				}
				
				if (bEditPerm === true) {
					$("#viewer_quick").show();
				} else {
					mobileToast.show(ID_RES_CONST_STRING_OPENED_READ_ONLY, MOBILE_TOAST.INFO);
					$("#viewer_quick").hide();
				}
				
				resolve();
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.moveBack = function() {
		try {
			if (mobileDlg.isShow() === true) {
				return;
			}
			
			if ($("#one_viewer .side_right").hasClass("on") === true
					|| $("#id_insertsheet_container.action_div").hasClass("on") === true) {
				closeViewModal();
				
				return;
			}
			
			if ($(".quickColorPicker").length !== 0) {
				$(".quickColorBGContainer").click();
				
				return;
			}
			
			$scope.cancelViewing();
		} catch (e) {
			dalert(e);
		}
	};
	
	function doCancelViewing(bClearCheck) {
		var bTablet = (g_browserCHK.iPad || g_browserCHK.androidtablet);
			if(bTablet) {	// pad
				// do nothing ...
			} else {	// phone
				$(".homeTitle").fadeIn();
			}
			$("#viewer_quick").fadeIn();

			var accessMode = $scope.viewerMode=='viewerMode'?"R":"W";
			onefficeMGW.setAccessDocument($("#mainContainer").scope().objCurrentDoc.seq, accessMode, "0", 360, function(resFileContent) {
				if (resFileContent.access_perm == "R") {
					
				} else {
					
				}
			});
			
			// iOS의 경우 unload 이벤트가 처리되지 않음
//			if(g_browserCHK.iOS) {
//				onefficeMGW.setAccessDocument(oneffice.currFileSeq, "M", "0", 360, function (responseData) { });
//			}

//			if(bTablet) {
				dzeJ("#viewer_header").css("height", "56px");
				$("#viewer_section").css("top", "56px").css("height", ($("#viewer_section").height()+44)+"px");
//			} else {
//				$(".quick_toggle_container").remove();
//			}
			$(".quickEditContainer").remove();
			$(".quickColorBGContainer").remove();
			$(".quickColorPicker").remove();
			
			$(".totalPageContainerClz").remove();
			
			
			$("#viewerFrameContainer").css("height", "calc(100% - 56px)");

			// 편집중인 경우 "저장안함 / 취소 / 저장" 출력
			var iFrame = $("#iFrame_viewer");
			iFrame.attr("src", "");

			$scope.$parent.viewChange(0);
//			$scope.$parent.bOnViewStatus = false;
			
			$("#mainContainer").scope().setEditMode(false);
//			$scope.$parent.bOnNewEditMode = false;
			
			$("#mainContainer").scope().objCurrentDoc = null;
			
			//add home controller Check Clear
			if(fnObjectCheckNull(bClearCheck) == true) bClearCheck = false;
			if(bClearCheck == false)
				$("#one_home").scope().clearAllCheckItem();
//			$("#one_home").scope().getDataLoadDocumnet($("#one_home").scope().currentFolderType, $("#one_home").scope().currentFolderSeq);
			$("div.dialog_layer_wrap").hide();
			mobileDlg.hideDialog();
			
			clearInterval(oneffice.autoSaveTimer);
			clearInterval(oneffice.autoSessionCheckTimer);
			oneffice.autoSaveTimer = null;
			oneffice.autoSessionCheckTimer = null;
			
			
	}
	
	$scope.cancelViewing = function(bClearCheck) {
		try {
			
			if($scope.viewerMode == 'viewerMode'){
				doCancelViewing(bClearCheck);
			}else{
				convertMobileSrc();
				var currContent = getEditorHTMLCode(false, g_nActiveEditNumber, true, true);

				if (currContent === "" || onefficeUtil.checkSameContent(currContent)) {
					convertWebSrc();
					doCancelViewing(bClearCheck);
				} else {
					convertWebSrc();
					var arrButtonInfo = [
						     				{
						     					name: "취소",
						     					func: function() {
						     						mobileDlg.hideDialog();
						     					}
						     				},
						     				{
						     					name: "나가기",
				     							func: function() {
				     								doCancelViewing(bClearCheck)
						     					}
						     				}
						     			];
						     			
				   mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.CONFIRM, "저장하지 않은 정보가 있습니다 .<br/>정말로 나가시겠습니까?", "알림", arrButtonInfo);
				}
			}
		} catch (e) {
			dalert(e);
		}
	};

	$scope.saveProc = function() {
		try {
			fnHandler_saveMobileFile(function(bResult) {
				if (bResult === true) {
					setTimeout(function () {
						mobileToast.show(ID_RES_CONST_STRING_SAVED, MOBILE_TOAST.CONFIRM);
					}, 1000);
				} else {
					mobileToast.show(ID_RES_CONST_STRING_NOT_MODIFIED, MOBILE_TOAST.INFO);
				}
			});
		} catch(e) {
			dalert(e);
		}
	};
	$scope.undoProc = function() {
		try {
			sendIFrameMessage("undo", null, true);
		} catch(e) {
			dalert(e);
		}
	};
	$scope.redoProc = function() {
		try {
			sendIFrameMessage("redo", null, true);
		} catch(e) {
			dalert(e);
		}
	};
	$scope.insertProc = function() {
		try {
			dzeJ("#id_insertsheet_title").text('삽입');
			$(".action_div div div ld .arr_left").hide();
			var actionDiv = dzeJ("#id_insertsheet_container");
			
			if (!actionDiv.hasClass("on")) {
				actionDiv.find(".menu_container")[0].innerHTML = makeInsertMenuList();
				actionDiv.addClass("on");
				$(".view_modal").show();
				$(".view_modal").css("opacity", "0");
				
				dzeJ(".action_div .ac").on('click', function() {
					insertItemClick(this.getAttribute("menuIndex"));
				});
				
				addSheetScroll.scrollTo(0, 0);
				setTimeout(function() { addSheetScroll.refresh();}, 100);

				sendIFrameMessage("getQRStatus", null, false);	// 비동기기 때문에 문서 열람 시점에 미리 요청
			} else {
				actionDiv.removeClass("on");
				$(".view_modal").hide();
				$(".view_modal").css("opacity", "");
			}
		} catch(e) {
			dalert(e);
		}
	};
	$scope.sideRightMenu = function(strMenu) {
		try {
			if (fnObjectCheckNull(strMenu) === true) {
				strMenu = "main";
			}
			
			updateSideMenuList(strMenu);
			
			getCommentCount();
			
			$(".side_right").animate({ right: "0px" }, 300);
			$(".side_right").addClass("on");
			$(".view_modal").show();
		} catch(e) {
			dalert(e);
		}
	};

	$scope.menuFunc_Rename = function() {
		try {
			closeViewModal();

			$scope.showRenameDialog();
		} catch(e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_Favorite = function() {
		try {
			var objDocInfo = $scope.$parent.objCurrentDoc;
			var bFavorite = (objDocInfo.docData.bStar == 0) ? true : false;
			
			onefficeMGW.setFavorite(objDocInfo.seq, objDocInfo.parentFolderSeq, bFavorite);
			
			$scope.$parent.docDataFact.updateDocStatus(objDocInfo.seq, "bStar", bFavorite);
			
			if (bFavorite === true) {
				$("#one_viewer .side_right .toggle_star").addClass("on");
			} else {
				$("#one_viewer .side_right .toggle_star").removeClass("on");
			}
		} catch (e) {
			dalert(e);
		}
	};

	$scope.showRenameDialog = function() {
		try {
			var nDialogType = mobileDlg.DIALOG_TYPE.INPUT_TEXT;
			var strTitle = "이름 바꾸기";
			var strFileName = $scope.$parent.objCurrentDoc.docData.strTitle;
			
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
						var strNewTitle = $('#dlg_text_input').val();
						
						onefficeMGW.checkRenameFile($scope.$parent.objCurrentDoc, strNewTitle, function() {
							$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "strTitle", strNewTitle);
							
							$scope.currentFileName = strNewTitle;
							oneffice.currFileSubject = strNewTitle;
							
							updateView($scope);
							
							mobileDlg.hideDialog();
						});
					}
				}
			];
			
			mobileDlg.showDialog(nDialogType, strFileName, strTitle, arrButtonInfo);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_Connect = function() {
		try {
			updateSideMenuList("share");
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_Report = function() {
		try {
			if ($scope.viewerMode === modeViewEdit[0]) {
				return;
			}
			
			updateSideMenuList("report");
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_Copy = function() {
		try {
			// Close Viewer
			closeViewModal();
			$scope.cancelViewing(true);

			// Copy Proc...
			//
			//bChecked 값이 초기화 되어있음
			var _obj = $scope.$parent.objCurrentDoc;
			if (fnObjectCheckNull(_obj) === false) {
				_obj.docData.bChecked = true;
			}
			
			$("#one_home").scope().changeSelectMoveMode(false);
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_Security = function() {
		try {
			closeViewModal();

			$("#one_home").scope().menuClickBridge(MOBILE_MENU_SECURITY);
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_SlideShow = function() {
		try {
			closeViewModal();
			
			$("#mainContainer").scope().currentViewPage = "one_slideshow";
			
			updateView($scope);
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_Back = function() {
		try {
			updateSideMenuList("back");
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_LinkShare = function() {
		try {
			$scope.bShareEditPerm = false;	// 항상 보기 가능으로 기본 설정

			// 링크 공유 활성화에 따른 서브 메뉴 출력
			if($scope.bShareOpenLink == false) {
				$scope.bShareOpenLink = true;
				$(".r9, .r10, .r13").slideDown(function() {
					$(this).removeClass("off").addClass("on").css("display", "");
				});
				
				$(".r9 chk").show();
				$(".r10 chk").hide();

				onefficeMGW.shareDocument($scope.$parent.objCurrentDoc.seq, MOBILE_SHARE_OPEN_LINK, "", "R");
			} else {
				$scope.bShareOpenLink = false;
				$(".r9, .r10, .r13").slideUp(function() {
					$(this).removeClass("on").addClass("off").css("display", "");
				});

				onefficeMGW.unshareDocument($scope.$parent.objCurrentDoc.seq, MOBILE_SHARE_OPEN_LINK, "");
			}
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_LinkShareView = function() {
		try {
			$scope.bShareEditPerm = false;
			onefficeMGW.shareDocument($scope.$parent.objCurrentDoc.seq, MOBILE_SHARE_OPEN_LINK, "", "R");

			$(".r9 chk").show();
			$(".r10 chk").hide();
		} catch(e) {
			dalert(e);
		}
	};
	$scope.menuFunc_LinkShareEdit = function() {
		try {
			$scope.bShareEditPerm = true;
			onefficeMGW.shareDocument($scope.$parent.objCurrentDoc.seq, MOBILE_SHARE_OPEN_LINK, "", "W");

			$(".r9 chk").hide();
			$(".r10 chk").show();
		} catch(e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_UserShare = function() {
		try {
			closeViewModal();

			$("#one_home").scope().menuClickBridge(MOBILE_MENU_SHARE_USER);
		} catch(e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_Unshare = function() {
		try {
			$("#one_home").scope().menuClickBridge(MOBILE_MENU_SHARE_UNLINK);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_LinkCopy = function() {
		try {
			var strUrl = onefficeMGW.getDocumentShareOpenURL($scope.$parent.objCurrentDoc.seq, $scope.myInfo.group_seq);
			
			// 가져온 url을 mobile clipboard에 넣어야 함
			var clipboard = new ClipboardJS('.r13', {
				text: function() {
					return strUrl;
				}
			});
			
			clipboard.on('success', function(e) {
				mobileToast.show("링크URL을 클립보드에 복사하였습니다");
			});
			
			clipboard.on('error', function(e) {
				mobileToast.show("복사 실패", MOBILE_TOAST.ERROR);
			});
		} catch(e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_sendReport = function() {
		try {
			closeViewModal();
			
			$("#mainContainer").scope().currentViewPage = "one_custom_page";
			$("#mainContainer").scope().strPageType = "sendReport";
			
			updateView($scope);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_getReport = function() {
		try {
			closeViewModal();
			
			$("#mainContainer").scope().currentViewPage = "one_custom_page";
			$("#mainContainer").scope().strPageType = "getReport";
			
			updateView($scope);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_getComment = function() {
		try {
			
			closeViewModal();

			$("#one_home").scope().menuClickBridge(MOBILE_MENU_COMMENT);
			

		} catch (e) {
			dalert(e);
		}
	};

	$scope.menuFunc_getDocinfo = function() {
		try {
			
			closeViewModal();

			$("#one_home").scope().menuClickBridge(MOBILE_MENU_DOCINFO);
			

		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.menuFunc_getDocPrint = function() {
		try {
			
			closeViewModal();

			$("#one_home").scope().menuClickBridge(MOBILE_MENU_DOCPRINT);
			

		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.startViewerMode = function() {
		try {
			var accessWrite = false;
			var accessName = "";
			onefficeMGW.setAccessDocument($("#mainContainer").scope().objCurrentDoc.seq, "W", "0", 360, function(resFileContent) {
				onefficeMGW.getDocumentAccessInfo($("#mainContainer").scope().objCurrentDoc.seq, function(resFileContent) {
					for(var ix=0; ix<resFileContent.length; ix++){
						var _usr = resFileContent[ix];
						if(_usr.access_perm =="W"){
							accessWrite = true;
							accessName = _usr.name;
						}
					}
					if(accessWrite){
						$(".topInfoTxt").html("읽기전용으로 열린 문서입니다.["+accessName+"]님이 편집중입니다.")
						$(".topInfoContainer").show();
						mobileToast.show(ID_RES_CONST_STRING_OPENED_READ_ONLY, MOBILE_TOAST.INFO);
						$("#viewer_quick").hide();
					}
				});
			});
			
			$scope.bEditMode = true;
			$scope.viewerMode = modeViewEdit[0];
			
			$timeout(function() {
				$("#dzeditor_0").scope().fnloadView($scope.$parent.objCurrentDoc.seq, 0);
			}, 500);
			
			var iFrame = document.getElementById("iFrame_viewer");
			
			if (iFrame && iFrame.contentWindow) {
				iFrame.contentWindow.postMessage({uiEvent: 'goEdit'}, "*");
			}
			
			updateView($scope);
			
		} catch(e) {
			dalert(e);
		}
	};
	
	$scope.changeEditorMode = function() {
		try {
			var accessWrite = false;
			var accessName = "";
			onefficeMGW.getDocumentAccessInfo($("#mainContainer").scope().objCurrentDoc.seq, function(resFileContent) {
				for(var ix=0; ix<resFileContent.length; ix++){
					var _usr = resFileContent[ix];
					if(_usr.access_perm =="W"){
						accessWrite = true;
						accessName = _usr.name;
					}
				}
				if(accessWrite){
					$(".topInfoTxt").html("읽기전용으로 열린 문서입니다.["+accessName+"]님이 편집중입니다.")
					$(".topInfoContainer").show();
					mobileToast.show(ID_RES_CONST_STRING_OPENED_READ_ONLY, MOBILE_TOAST.INFO);
					$("#viewer_quick").hide();
				}else{
					$scope.bEditMode = true;
					$scope.viewerMode = modeViewEdit[1];
					$scope.$apply();
					makeQuickMenu();

					if(g_browserCHK.iPad || g_browserCHK.androidtablet) {	// pad
						$(".homeTitle").css("position", "absolute");
						$(".homeTitle").css("margin-left", "178px");
						$(".homeTitle").css("width", "calc(100% - 360px)");
					} else {	// phone
						$(".homeTitle").fadeOut();
					}
					
					$("#viewer_quick").fadeOut();
					
					
					$("#dzeditor_0").scope().setChangeEditMode();
				}
			});
			
			
		} catch(e) {
			dalert(e);
		}
	};
	
	$scope.startEditorMode = function() {
		try {
			$scope.bEditMode = true;
			$scope.viewerMode = modeViewEdit[1];
			makeQuickMenu();

			if(g_browserCHK.iPad || g_browserCHK.androidtablet) {	// pad
				$(".homeTitle").css("position", "absolute");
				$(".homeTitle").css("margin-left", "178px");
				$(".homeTitle").css("width", "calc(100% - 360px)");
			} else {	// phone
				$(".homeTitle").fadeOut();
			}
			
			$("#viewer_quick").fadeOut();
			
			$timeout(function() {
				$("#dzeditor_0").scope().fnloadView($scope.$parent.objCurrentDoc.seq, 0);
			}, 500);
			
			var iFrame = document.getElementById("iFrame_viewer");
			
			if (iFrame && iFrame.contentWindow) {
				iFrame.contentWindow.postMessage({uiEvent: 'goEdit'}, "*");
			}
			
			updateView($scope);
		} catch(e) {
			dalert(e);
		}
	};
	
	$scope.closeTopInfo = function(){
		try {
			$(".topInfoContainer").hide();
		} catch(e) {
			dalert(e);
		}
	}

	var makeQuickMenu = function() {
		try {
			var bTablet = (g_browserCHK.iPad || g_browserCHK.androidtablet);

			// HTML 구성
			var quickContainer = document.createElement("div");
			quickContainer.className = "quickEditContainer";

			var htmlSTR = '';
			htmlSTR += '<div id="m_quick_edit_panel" style="width: 815px; height: 100%; padding: 0 18px; margin:0 auto; overflow: hidden;">';
			htmlSTR += '	<div class="font_size_control">';
			htmlSTR += '		<a class="font_down" quickindex="1"></a>';
			htmlSTR += '		<span id="font_size_status">11pt</span>';
			htmlSTR += '		<a class="font_up" quickindex="2"></a>';
			htmlSTR += '	</div>';
			htmlSTR += '	<a class="bold_quick" quickindex="3"></a>';
			htmlSTR += '	<a class="italic_quick" quickindex="4"></a>';
			htmlSTR += '	<a class="uline_quick" quickindex="5"></a>';
			htmlSTR += '	<a class="mline_quick" quickindex="6"></a>';
			htmlSTR += '	<a class="super_quick" quickindex="7"></a>';
			htmlSTR += '	<a class="sub_quick" quickindex="8"></a>';
			htmlSTR += '	<a class="text_color_quick" quickindex="9"><div id="m_text_color"></div></a>';
			htmlSTR += '	<a class="text_bg_color_quick" quickindex="10"><div id="m_text_bg_color"></div></a>';
			htmlSTR += '	<div class="mobile_menu_seperate"></div>';
			htmlSTR += '	<a class="unorder_quick" quickindex="11"></a>';
			htmlSTR += '	<a class="order_quick" quickindex="12"></a>';
			htmlSTR += '	<div class="mobile_menu_seperate"></div>';
			htmlSTR += '	<a class="left_align_quick" quickindex="13"></a>';
			htmlSTR += '	<a class="center_align_quick" quickindex="14"></a>';
			htmlSTR += '	<a class="right_align_quick" quickindex="15"></a>';
			htmlSTR += '	<a class="full_align_quick" quickindex="16"></a>';
			htmlSTR += '	<div class="mobile_menu_seperate"></div>';
			htmlSTR += '	<a class="indent_quick" quickindex="17"></a>';
			htmlSTR += '	<a class="outdent_quick" quickindex="18"></a>';
			htmlSTR += '</div>';
			quickContainer.innerHTML = htmlSTR;

			
			// 퀵메뉴 추가 위치에 따른 화면 구성
//			if(bTablet) {
				// viewer_header 밑
				quickContainer.style.top = "56px";
				$("#viewer_section").css("top", "100px").css("height", ($("#viewer_section").height()-44)+"px");
				dzeJ("#viewer_header").css("height", "100px");
				dzeJ("#viewer_header").append(quickContainer);
				$("#viewerFrameContainer").css("height", "calc(100% - 100px)");
//			} else {
//				var toggleBtn = document.createElement("div");
//				toggleBtn.className = "quick_toggle_container";
//				toggleBtn.innerHTML = '	<a class="quick_toggle" quickindex="17"><img id="m_quick_toggle_img" width="12.5px" height="7px" src="../mobile/images/btn/btn-text-down.png" /></a>';
//
//				// viewer_section 밑
//				quickContainer.style.bottom = "0px";
//				dzeJ("#viewer_section").append(quickContainer);
//				dzeJ("#viewer_section").append(toggleBtn);
//				$("#viewerFrameContainer").css("height", "calc(100% - 120px)");
//			}


			// 퀵메뉴 이벤트 등록
			dzeJ(".quickEditContainer a").on('click', function() {
				quickMenuClick(this.getAttribute("quickindex"));
			});
//			dzeJ(".quick_toggle_container a").on('click', function() {
//				quickMenuClick(this.getAttribute("quickindex"));
//			});
		} catch(e) {
			dalert(e);
		}
	};

	var quickMenuClick = function(quickindex) {
		try {
			if(dzeJ(".quickColorPicker").length > 0) {
				dzeJ(".quickColorBGContainer").click();
				return ;
			}

			var index = parseInt(quickindex);
			switch (index) {
				case MOBILE_QUICK_FONT_DOWN:
					{
						sendIFrameMessage("fontSizeDown", null, true);
					}
					break;

				case MOBILE_QUICK_FONT_UP:
					{
						sendIFrameMessage("fontSizeUp", null, true);
					}
					break;

				case MOBILE_QUICK_BOLD:
					sendIFrameMessage("bold", null, true);
					
					break;

				case MOBILE_QUICK_ITALIC:
					sendIFrameMessage("italic", null, true);
					
					break;

				case MOBILE_QUICK_U_LINE:
					sendIFrameMessage("underline", null, true);
					
					break;

				case MOBILE_QUICK_M_LINE:
					sendIFrameMessage("strikethrough", null, true);
					
					break;
					
				case MOBILE_QUICK_SUPER:
					sendIFrameMessage("superscript", null, true);
					
					break;
					
				case MOBILE_QUICK_SUB:
					sendIFrameMessage("subscript", null, true);
					
					break;

				case MOBILE_QUICK_TEXT_COLOR:
					{
						makeQuickColorPicker(MOBILE_QUICK_TEXT_COLOR);
					}
					break;

				case MOBILE_QUICK_TEXT_BG_COLOR:
					{
						makeQuickColorPicker(MOBILE_QUICK_TEXT_BG_COLOR);
					}
					break;

				case MOBILE_QUICK_UNORDER:
					{
						sendIFrameMessage("insertunorderedlist", null, true);
					}
					break;

				case MOBILE_QUICK_ORDER:
					{
						sendIFrameMessage("insertorderedlist", null, true);
					}
					break;

				case MOBILE_QUICK_L_ALIGN:
					{
						var alignOn = $(".left_align_quick").hasClass("on");
						sendIFrameMessage("justifyleft", alignOn, true);
					}
					break;

				case MOBILE_QUICK_C_ALIGN:
					{
						var alignOn = $(".center_align_quick").hasClass("on");
						sendIFrameMessage("justifycenter", alignOn, true);
					}
					break;

				case MOBILE_QUICK_R_ALIGN:
					{
						var alignOn = $(".right_align_quick").hasClass("on");
						sendIFrameMessage("justifyright", alignOn, true);
					}
					break;

				case MOBILE_QUICK_F_ALIGN:
					{
						var alignOn = $(".full_align_quick").hasClass("on");
						sendIFrameMessage("justify", alignOn, true);
					}
					break;

				case MOBILE_QUICK_INDENT:
					{
						sendIFrameMessage("indent", null, true);
					}
					break;

				case MOBILE_QUICK_OUTENT:
					{
						sendIFrameMessage("outdent", null, true);
					}
					break;

				case MOBILE_QUICK_TOGGLE:	// Quick Menu Toggle
					{
						if ($(".quickEditContainer").is(':visible') == true) {
							$(".quickEditContainer").slideUp();
							$(".quick_toggle_container").animate({bottom: "0px"})
							$("#viewerFrameContainer").css("height", "calc(100% - 76px)");
							$("#m_quick_toggle_img").attr("src", "../mobile/images/btn/btn-text-up.png");
						} else {
							$(".quickEditContainer").slideDown().css("overflow", "auto");
							$(".quick_toggle_container").animate({bottom: "44px"})
							$("#viewerFrameContainer").css("height", "calc(100% - 120px)");
							$("#m_quick_toggle_img").attr("src", "../mobile/images/btn/btn-text-down.png");
						}
					}
					break;
			}
		} catch(e) {
			dalert(e);
		}
	};

	var makeQuickColorPicker = function(quickIndex) {
		try {
			var bTablet = (g_browserCHK.iPad || g_browserCHK.androidtablet);

			// HTML 구성
			var quickBGContainer = document.createElement("div");
			quickBGContainer.className = "quickColorBGContainer";

			var quickColorPicker = document.createElement("div");
			quickColorPicker.className = "quickColorPicker";

			var htmlSTR = '';
			htmlSTR += '<div id="m_quick_color_panel">';
			if(MOBILE_QUICK_TEXT_BG_COLOR == quickIndex) {
				htmlSTR += '	<p style="height: 29px;">';
				htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_NONE+';"><cross class="crossline"></cross></color></cover>';
			} else {
				htmlSTR += '	<p style="height: 29px; margin-bottom: 4px;">';
			}
			htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_0+';"></color></cover>';
			htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_1+';"></color></cover>';
			htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_2+';"></color></cover>';
			htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_3+';"></color></cover>';
			htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_4+';"></color></cover>';
			htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_5+';"></color></cover>';
			htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_6+';"></color></cover>';
			htmlSTR += '	</p>';
			if(MOBILE_QUICK_TEXT_COLOR == quickIndex) {
				htmlSTR += '	<p style="height: 29px;">';
				htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_7+';"></color></cover>';
				htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_8+';"></color></cover>';
				htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_9+';"></color></cover>';
				htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_10+';"></color></cover>';
				htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_11+';"></color></cover>';
				htmlSTR += '		<cover><color class="quick_color_item" style="background-color:'+MOBILE_QUICK_COLOR_12+';"></color></cover>';
				htmlSTR += '	</p>';
			}
			htmlSTR += '</div>';
			quickColorPicker.innerHTML = htmlSTR;

			
			// 퀵메뉴 추가 위치에 따른 화면 구성
			if(bTablet) {
				// viewer_header 밑
				quickColorPicker.style.top = "105px";
				dzeJ("#viewer_section").append(quickBGContainer);
				dzeJ("#viewer_section").append(quickColorPicker);
				dzeJ(quickColorPicker).hide().slideDown();
			} else {
				// viewer_section 밑
				quickColorPicker.style.bottom = "50px";
				dzeJ("#viewer_section").append(quickBGContainer);
				dzeJ("#viewer_section").append(quickColorPicker);
				dzeJ(quickColorPicker).hide().slideDown();
			}


			// 메뉴 사라지게 해야 함
			dzeJ(".quickColorBGContainer").on('click', function() {
				dzeJ(quickColorPicker).slideUp(300, function() {
					this.remove();	// Color Picker
				});
				this.remove();	// BG Container
				
				duzon_dialog.setEditorSelection();
				duzon_dialog.setEditorFocus();
			});

			// 컬러 메뉴 이벤트 등록
			dzeJ("#m_quick_color_panel color").on('click', function() {
				if(MOBILE_QUICK_TEXT_COLOR == quickIndex) {
					sendIFrameMessage("textColor", this.style.backgroundColor, true);
					dzeJ("#m_text_color").css("background-color", this.style.backgroundColor);
				}
				if(MOBILE_QUICK_TEXT_BG_COLOR == quickIndex) {
					sendIFrameMessage("textBGColor", this.style.backgroundColor, true);
					dzeJ("#m_text_bg_color").css("background-color", this.style.backgroundColor);
				}

				dzeJ("cover").removeClass("on");
				dzeJ("color").removeClass("on");
				dzeJ(this).parent().addClass("on");
				dzeJ(this).addClass("on");
			});
			
			duzon_dialog.setEditorSelection();
			duzon_dialog.setEditorFocus();
		} catch(e) {
			dalert(e);
		}
	};

	var makeInsertMenuList = function(menuIndex) {
		try {
			var mode = (fnObjectCheckNull(menuIndex) == true) ? -1 : menuIndex;
			var moreMenus = document.createElement("div");

			switch (mode) {
				case MOBILE_INSERT_IMAGE:
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_GALLERY));
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_CAMERA));
					break;
				case MOBILE_INSERT_EMOTICON:
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_EMOTICON_LIST));
					break;
				case MOBILE_INSERT_QRCODE:
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_QRCODE_MODE));
					break;
				default:
//					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_IMAGE));
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_TABLE));
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_LAYOUT));
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_EMOTICON));
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_HR_LINE));
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_PAGE_BREAK));
					moreMenus.appendChild(makeInsertMenuItem(MOBILE_INSERT_QRCODE));
					break;
			}

			return moreMenus.innerHTML;
		} catch(e) {
			dalert(e);
		}
	};

	var makeInsertMenuItem = function(menuIndex) {
		try {
			var menuItem = document.createElement("div");
			menuItem.className = "ac";
			menuItem.setAttribute("menuIndex", menuIndex);

			switch (menuIndex) {
				case MOBILE_INSERT_IMAGE:	// 이미지
					menuItem.className += " i_image";
					menuItem.innerHTML = '<dl><dt>이미지</dt><dd><span class="arr_more"></span></dd></dl>';
					break;

				case MOBILE_INSERT_GALLERY:	// 사진 앨범
					menuItem.className += " i_gallery";
					menuItem.innerHTML = '<dl><dt>사진 앨범</dt></dl>';
					break;

				case MOBILE_INSERT_CAMERA:	// 카메라
					menuItem.className += " i_camera";
					menuItem.innerHTML = '<dl><dt>카메라</dt></dl>';
					break;

				case MOBILE_INSERT_TABLE:	// 표
					menuItem.className += " i_table";
					menuItem.innerHTML = '<dl><dt>표</dt></dl>';
					break;

				case MOBILE_INSERT_LAYOUT:	// 레이아웃 템플릿
					menuItem.className += " i_layout";
					menuItem.innerHTML = '<dl><dt>레이아웃 템플릿</dt></dl>';
					break;

				case MOBILE_INSERT_EMOTICON:	// 이모티콘
					menuItem.className += " i_emoticon";
					menuItem.innerHTML = '<dl><dt>이모티콘</dt><dd><span class="arr_more"></span></dd></dl>';
					break;

				case MOBILE_INSERT_EMOTICON_LIST:	// 이모티콘 리스트
					menuItem.className += " i_emoticon_list";
					var eWidth = ($('#id_insertsheet_scroll').width()/4)-1;
					var eHeight = eWidth;
					var innerStr = "<div class='emoticon_wrap'>";
					
					for (var ix=0; ix<emoticonArr.length; ix++) {
						innerStr += "<div class='emoticon_item' style='width:"+eWidth+"px; height:"+eHeight+"px;'>";
						innerStr += "<img src=../"+emoticonArr[ix]+" webSrc='"+emoticonArr[ix]+"' style='width:"+eWidth*0.8+"px; height:"+eHeight*0.8+"px; margin-top:10px;'>";
						innerStr += "</div>";
					}
					
					innerStr += "</div>";
					
					menuItem.innerHTML = innerStr;
					break;

				case MOBILE_INSERT_HR_LINE:	// 가로줄
					menuItem.className += " i_hr_line";
					menuItem.innerHTML = '<dl><dt>가로줄</dt></dl>';
					break;

				case MOBILE_INSERT_PAGE_BREAK:	// 페이지 나누기
					menuItem.className += " i_page_break";
					menuItem.innerHTML = '<dl><dt>페이지 나누기</dt></dl>';
					break;

				case MOBILE_INSERT_QRCODE:	// QR코드
					menuItem.className += " i_qrcode";
					menuItem.innerHTML = '<dl><dt>QR코드</dt><dd><span class="arr_more"></span></dd></dl>';
					break;

				case MOBILE_INSERT_QRCODE_MODE:	// QR코드 선택
					menuItem.className += " i_qrcode_mode";
					var bFirstOn = ($scope.bQRFirstStatus) ? ' on' : '';
					var bLastOn = ($scope.bQRLastStatus) ? ' on' : '';
					menuItem.innerHTML = '<div class="qrcode_selection_container"><div class="qrcode_selection_div'+bFirstOn+'" index="1"><div class="qrcode_selection_first"></div></div><p class="qrcode_info_text">첫 페이지 우측 상단</p></div>';
					menuItem.innerHTML += '<div class="qrcode_selection_container"><div class="qrcode_selection_div'+bLastOn+'" index="2"><div class="qrcode_selection_last"></div><div class="qrcode_selection_last_strike1"></div><div class="qrcode_selection_last_strike2"></div></div><p class="qrcode_info_text">마지막 페이지 하단</p></div>';
					break;
			}

			return menuItem;
		} catch(e) {
			dalert(e);
		}
	};

	var insertItemClick = function(menuIndex) {
		try {
			var index = parseInt(menuIndex);
			switch (index) {
				case MOBILE_INSERT_IMAGE:	// 이미지
				{
					var insertContainer = dzeJ("#id_insertsheet_container");
					insertContainer.css("bottom", "-" + (insertContainer.height() - 160) + "px");
					
					dzeJ("#id_insertsheet_title").text('이미지');
					dzeJ(".action_div div div ld .arr_left").show();
					dzeJ("#id_insertsheet_container .menu_container")[0].innerHTML = makeInsertMenuList(MOBILE_INSERT_IMAGE);
					
					dzeJ(".insert_title_container").on('click', function() {
						insertMenuBack();
					});

					dzeJ(".action_div .ac").on('click', function() {
						insertItemClick(this.getAttribute("menuIndex"));
					});

					// animation
					dzeJ("#id_insertsheet_scroll").css("left", dzeJ("#id_insertsheet_scroll").css("width")).animate({left: "0px"});
					
					addSheetScroll.scrollTo(0, 0);
					setTimeout(function() { addSheetScroll.refresh();}, 100);
				}
					break;

				case MOBILE_INSERT_GALLERY:	// 사진 앨범
					$('#inputFile').click();
					closeViewModal();
					break;

				case MOBILE_INSERT_CAMERA:	// 카메라
					closeViewModal();
					break;

				case MOBILE_INSERT_TABLE:	// 표
					closeViewModal();
					
					$("#mainContainer").scope().currentViewPage = "one_custom_page";
					$("#mainContainer").scope().strPageType = "table";
					
					updateView($scope);
					
					break;
					
				case MOBILE_INSERT_LAYOUT:	// 레이아웃 템플릿
					closeViewModal();
					
					$("#mainContainer").scope().currentViewPage = "one_custom_page";
					$("#mainContainer").scope().strPageType = "layout";
					
					updateView($scope);
					
					break;
					
				case MOBILE_INSERT_EMOTICON:	// 이모티콘
				{
					dzeJ("#id_insertsheet_title").text('이모티콘');
					dzeJ(".action_div div div ld .arr_left").show();
					dzeJ("#id_insertsheet_container .menu_container")[0].innerHTML = makeInsertMenuList(MOBILE_INSERT_EMOTICON);
					
					dzeJ(".insert_title_container").on('click', function() {
						insertMenuBack();
					});
					
					var objEmoticon = $(".emoticon_item");
					
					objEmoticon.on('click',function(e){
						objEmoticon.removeClass("active");
						
						var objTarget = dzeJ(this);
						objTarget.addClass("active");
						
						var objImg = $("<img>");
						
						objImg.attr("src", ("http://" + mobile_http.hybridBaseData.result.compDomain + "/gw/oneffice/" + objTarget.find("img").attr("websrc")));
						objImg.css({width: 68 + "px", height: 68 + "px"});
						
						sendIFrameMessage("insertEmoticon", objImg[0].outerHTML, false);
					});

					// 이모티콘 리스트 클릭
					// dzeJ(".action_div .ac").on('click', function() {
					// 	insertItemClick(this.getAttribute("menuIndex"));
					// });
					
					// animation
					dzeJ("#id_insertsheet_scroll").css("left", dzeJ("#id_insertsheet_scroll").css("width")).animate({left: "0px"});
					
					var nRowCount = Math.ceil(emoticonArr.length / 4);
					$(".i_emoticon_list").height(nRowCount * (objEmoticon.height() + 1));
					
					addSheetScroll.scrollTo(0, 0);
					setTimeout(function() { addSheetScroll.refresh();}, 100);
				}
					break;

				case MOBILE_INSERT_EMOTICON_LIST:	// 이모티콘 리스트
					closeViewModal();
					break;

				case MOBILE_INSERT_HR_LINE:	// 가로줄
					sendIFrameMessage("insertHr", null, false);
					closeViewModal();
					break;

				case MOBILE_INSERT_PAGE_BREAK:	// 페이지 나누기
					sendIFrameMessage("insertPageBreak", null, false);
					closeViewModal();
					break;

				case MOBILE_INSERT_QRCODE:	// QR코드
				{
					var insertContainer = dzeJ("#id_insertsheet_container");
					insertContainer.css("bottom", "-"+(insertContainer.height()-260)+"px");
					dzeJ("#id_insertsheet_title").text('QR코드');
					dzeJ(".action_div div div ld .arr_left").show();
					dzeJ("#id_insertsheet_container .menu_container")[0].innerHTML = makeInsertMenuList(MOBILE_INSERT_QRCODE);
					
					dzeJ(".insert_title_container").on('click', function() {
						insertMenuBack();
					});

					dzeJ(".qrcode_selection_div").on('click', function() {
						var bOnOffQRCode = false;
						var selectedItem = dzeJ(this);

						if (selectedItem.hasClass("on")) {
							selectedItem.removeClass("on");
							bOnOffQRCode = false;
						} else {
							selectedItem.addClass("on");
							bOnOffQRCode = true;
						}

						if(this.getAttribute("index") == "1") {
							sendIFrameMessage("qrCodeFirst", bOnOffQRCode, false);
							$scope.bQRFirstStatus = bOnOffQRCode;
						} else {
							sendIFrameMessage("qrCodeLast", bOnOffQRCode, false);
							$scope.bQRLastStatus = bOnOffQRCode;
						}
					});

					// animation
					dzeJ("#id_insertsheet_scroll").css("left", dzeJ("#id_insertsheet_scroll").css("width")).animate({left: "0px"});
					
					addSheetScroll.scrollTo(0, 0);
					setTimeout(function() { addSheetScroll.refresh();}, 100);
				}
					break;
			}
		} catch (e) {
			dalert(e);
		}
	};

	var insertMenuBack = function() {
		try {
			dzeJ("#id_insertsheet_title").text('삽입');
			$(".action_div div div ld .arr_left").hide();
			dzeJ("#id_insertsheet_container").css("bottom", "");
			dzeJ("#id_insertsheet_container .menu_container")[0].innerHTML = makeInsertMenuList();
		
			dzeJ(".action_div .ac").on('click', function() {
				insertItemClick(this.getAttribute("menuIndex"));
			});
			
			// animation
			// to do... 나중에 어색하단 얘기 나오면 위로 동일한 UI를 가진 뷰 하나 복사해서 띄우고 슬라이딩 처리 후 사라짐 처리하자
			dzeJ("#id_insertsheet_scroll").css("left", "-"+dzeJ("#id_insertsheet_scroll").css("width")).animate({left: "0px"});

			addSheetScroll.scrollTo(0, 0);
			setTimeout(function() { addSheetScroll.refresh();}, 100);
		} catch(e) {
			dalert(e);
		}
	}

	var closeViewModal = function() {
		try {
			var rightSide = $(".side_right");
			if (rightSide.hasClass("on")) {
				rightSide.animate({ right: "-301px" }, 300);
				rightSide.removeClass("on");
			}

			var insertSheet = $("#id_insertsheet_container");
			if (insertSheet.hasClass("on")) {
				insertSheet.removeClass("on");
				insertSheet.css("bottom", "");
			}
			$(".view_modal").hide();
			$(".view_modal").css("opacity", "");
		} catch(e) {
			dalert(e);
		}
	};
	
	var updateSideMenuList = function(strEvent) {
		try {
			var objMenus = $("#side_menu_list li");
			var bSharedOut = true;		// true: 공유한 문서,	false: 공유받은 문서
			
			if (strEvent === "main" || strEvent === "back" || strEvent === "share") {
				if ($scope.$parent.objCurrentDoc.userData.nOwnerID.length > 0
						&& $scope.myInfo.id !== $scope.$parent.objCurrentDoc.userData.nOwnerID) {
					bSharedOut = false;
				}
			}
			
			switch (strEvent) {
				case "main":
				case "back":
					objMenus.each(function(index, item) {
						var objMenu = $(item).find(".r" + (index + 1));
						
						if (objMenu.length !== 0) {
							switch (index + 1) {
								case 1:		// 원피스 커넥트
									objMenu.removeClass("off").addClass("on");
									
									break;
									
								case 2:		// 업무보고
									if ($scope.viewerMode === modeViewEdit[0]) {
										objMenu.removeClass("on").addClass("off");
									} else {
										if (bSharedOut === true) {
											objMenu.removeClass("off").addClass("on");
										} else {
											objMenu.removeClass("on").addClass("off");
										}
									}
									
									break;
								case 3:		// 문서댓글
									objMenu.removeClass("off").addClass("on");
									
									break;	
								case 4:		// 사본 만들기
									objMenu.removeClass("off").addClass("on");
									
									break;
									
								case 5:		// 문서보안 설정
									if (bSharedOut === true) {
										objMenu.removeClass("off").addClass("on");
									} else {
										objMenu.removeClass("on").addClass("off");
									}
									
									break;
									
								case 6:		// 슬라이드 쇼
									objMenu.removeClass("off").addClass("on");
									
									break;
								
								case 16:		// 문서정보
									objMenu.removeClass("off").addClass("on");
									
									break;
									
//								case 17:		// 인쇄
//									objMenu.removeClass("off").addClass("on");
//									
//									break;
									
								
									
//댓글시 주석 해제				//case 1: case 3: case 4: case 5:	case 15: objMenu.removeClass("off").addClass("on");		break;
									
								default:	objMenu.removeClass("on").addClass("off");		break;
							}
						}
					});
					
					if (strEvent === "back") {
						$("#side_menu_list").css({left: "-" + $("#side_menu_list").width() + "px"}).animate({left: "0px"}, 300);
					}
					
					break;
					
				case "share":
					var objDoc = $scope.$parent.objCurrentDoc;
					var strShareStatus = "";
					var nShareCount = objDoc.nShareCount;
					
					if (nShareCount > 0
							&& objDoc.shareData[0].nShareType === MOBILE_SHARE_OPEN_LINK) {
						nShareCount--;
					}
					
					if (objDoc.userData.nOwnerID.length === 0
							|| $scope.myInfo.id === objDoc.userData.nOwnerID) {
						// 공유한 문서
						strShareStatus = "꺼짐";
						
						if (nShareCount > 0) {
							strShareStatus = "공유 중 (" + nShareCount + ")";
						}
						
						$("#one_viewer .r11 .ico").css("background-image", "");
						$("#one_viewer .r11 .text").text("사용자 공유");
					} else {
						// 공유받은 문서
						if (nShareCount > 0) {
							strShareStatus = "(" + nShareCount + ")";
						}
						
						$("#one_viewer .r11 .ico").css("background-image", "url(../mobile/images/ico/icon-shareinfo-none.png)");
						$("#one_viewer .r11 .text").text("공유 중인 사용자");
					}
					
					$("#viewer_usershare_status").html(strShareStatus);
					
					objMenus.each(function(index, item) {
						var objMenu = $(item).find(".r" + (index + 1));
						
						if (objMenu.length !== 0) {
							switch (index + 1) {
								case 7:		// 뒤로가기
								case 11:	// 사용자 공유
									objMenu.removeClass("off").addClass("on");
									
									break;
									
								case 8:		// 링크 공유
									if (bSharedOut === true) {
										objMenu.removeClass("off").addClass("on");
									} else {
										objMenu.removeClass("on").addClass("off");
									}
									
									break;
								
								case 9:		// 링크 공유 - 보기 가능
								case 10:		// 링크 공유 - 편집 가능
									if (bSharedOut === true) {
										if ($scope.bShareOpenLink === true) {
											objMenu.removeClass("off").addClass("on");
											
											if (index + 1 === 9) {
												// 보기 가능
												if ($scope.bShareEditPerm === false) {
													objMenu.find("chk").show();
												} else {
													objMenu.find("chk").hide();
												}
											} else {
												// 편집 가능
												if ($scope.bShareEditPerm === false) {
													objMenu.find("chk").hide();
												} else {
													objMenu.find("chk").show();
												}
											}
										} else {
											objMenu.removeClass("on").addClass("off");
										}
									} else {
										objMenu.removeClass("on").addClass("off");
									}
									
									break;
									
								case 12:	// 공유 해제
									if (bSharedOut === true) {
										objMenu.removeClass("on").addClass("off");
									} else {
										objMenu.removeClass("off").addClass("on");
									}
									
									break;
									
								case 13:	// 링크 복사
									if (nShareCount > 0 || $scope.bShareOpenLink === true) {
										objMenu.removeClass("off").addClass("on");
									} else {
										objMenu.removeClass("on").addClass("off");
									}
									
									break;
									
								default:	objMenu.removeClass("on").addClass("off");		break;
							}
						}
					});
					
					$("#side_menu_list").css({left: $("#side_menu_list").width() + "px"}).animate({left: "0px"}, 300);
					
					break;
					
				case "report":
					objMenus.each(function(index, item) {
						var objMenu = $(item).find(".r" + (index + 1));
						
						if (objMenu.length !== 0) {
							switch (index + 1) {
								case 7: case 14: case 15:		objMenu.removeClass("off").addClass("on");		break;
								default:						objMenu.removeClass("on").addClass("off");		break;
							}
						}
					});
					
					$("#side_menu_list").css({left: $("#side_menu_list").width() + "px"}).animate({left: "0px"}, 300);
					
					break;
					
				case "comment":
					objMenus.each(function(index, item) {
						var objMenu = $(item).find(".r" + (index + 1));
						
						if (objMenu.length !== 0) {
							switch (index + 1) {
								case 7:			        		objMenu.removeClass("off").addClass("on");		break;
								default:						objMenu.removeClass("on").addClass("off");		break;
							}
						}
					});
					
					$("#side_menu_list").css({left: $("#side_menu_list").width() + "px"}).animate({left: "0px"}, 300);
					
					break;
			}
		} catch(e) {
			dalert(e);
		}
	};

	$scope.resiveEventMessage = function(msg){
		if(msg.hasOwnProperty("uiEvent")) {
			switch(msg.uiEvent) {
				case "newDocEdit":
					{
						$scope.viewerMode = modeViewEdit[1];
						makeQuickMenu();

						if (g_browserCHK.iPad || g_browserCHK.androidtablet) {	// pad
							$(".homeTitle").css("position", "absolute");
							$(".homeTitle").css("margin-left", "178px");
							$(".homeTitle").css("width", "calc(100% - 360px)");
						} else {	// phone
							$(".homeTitle").fadeOut();
						}
						$("#viewer_quick").fadeOut();
						updateView($scope);
					}
					break;
				case "tap":
					{
						if($("#viewer_header").is(":visible")) {
							$("#viewer_header").slideUp();
							$("#viewer_quick").fadeOut();
							$("#viewer_section").css("top", "0px").css("height", ($("#viewer_section").height()+56)+"px");
						} else {
							$("#viewer_header").slideDown();
							$("#viewer_quick").fadeIn();
							$("#viewer_section").css("top", "56px").css("height", ($("#viewer_section").height()-56)+"px");
						}
					}
					break;
				case "fontSize":
					if (fnObjectCheckNull(msg.uiEventData) == true || msg.uiEventData === "") {
						return;
					}
					
					var fontSize = msg.uiEventData;
					$("#font_size_status").text(fontSize);
					
					break;
					
				case "boldStatus":
				case "italicStatus":
				case "uLineStatus":
				case "mLineStatus":
				case "superStatus":
				case "subStatus":
				case "unOrderListStatus":
				case "totalSlideNum":
				case "currentSlideNum":
				case "iframeDone":
				case "orderListStatus":
					{
						if (fnObjectCheckNull(msg.uiEventData) == true) return;

						var targetBtn;
						switch (msg.uiEvent) {
							case "boldStatus":
								targetBtn = $(".bold_quick");
								break;
							case "italicStatus":
								targetBtn = $(".italic_quick");
								break;
							case "uLineStatus":
								targetBtn = $(".uline_quick");
								break;
							case "mLineStatus":
								targetBtn = $(".mline_quick");
								break;
							case "superStatus":
								targetBtn = $(".super_quick");
								break;
							case "subStatus":
								targetBtn = $(".sub_quick");
								break;
							case "unOrderListStatus":
								targetBtn = $(".unorder_quick");
								break;
							case "orderListStatus":
								targetBtn = $(".order_quick");
								break;
						}

						if (msg.uiEventData == true)
							targetBtn.addClass("on");
						else
							targetBtn.removeClass("on");
					}
					break;
				case "alignStatus":
					$(".left_align_quick").removeClass("on");
					$(".center_align_quick").removeClass("on");
					$(".right_align_quick").removeClass("on");
					$(".full_align_quick").removeClass("on");

					switch (msg.uiEventData) {
						case 0:
							break;
						case 1:
							$(".left_align_quick").addClass("on");
							break;
						case 2:
							$(".center_align_quick").addClass("on");
							break;
						case 3:
							$(".right_align_quick").addClass("on");
							break;
						case 4:
							$(".full_align_quick").addClass("on");
							break;
					}
					break;
				case "qrStatusCB":
					if(msg.uiEventData) {
						var statusArray = msg.uiEventData.split('|');
						if(statusArray.length > 1) {
							if(statusArray[0] == "true")
								$scope.bQRFirstStatus = true;
							if(statusArray[1] == "true")
								$scope.bQRLastStatus = true;
						}
					}
					break;
				case "saveStatus":
					if (msg.uiEventData == false) {
						$(".btn_save").addClass("disabled");
					} else {
						$(".btn_save").removeClass("disabled");
					}
					break;
				case "undoStatus":
					if(msg.uiEventData == false) {
						$(".btn_undo").addClass("disabled");
					} else {
						$(".btn_undo").removeClass("disabled");
					}
					break;
				case "redoStatus":
					if (msg.uiEventData == false) {
						$(".btn_redo").addClass("disabled");
					} else {
						$(".btn_redo").removeClass("disabled");
					}
					break;
				default:
					dalert("Default - "+msg.uiEvent);
					break;
			}
		}
		
	}
	var addListener = function() {
		try {
			window.addEventListener('message', function(e) {
				var msg = e.data;

				if(msg.hasOwnProperty("uiEvent")) {
					switch(msg.uiEvent) {
						case "newDocEdit":
							{
								$scope.viewerMode = modeViewEdit[1];
								makeQuickMenu();

								if (g_browserCHK.iPad || g_browserCHK.androidtablet) {	// pad
									$(".homeTitle").css("position", "absolute");
									$(".homeTitle").css("margin-left", "178px");
									$(".homeTitle").css("width", "calc(100% - 360px)");
								} else {	// phone
									$(".homeTitle").fadeOut();
								}
								$("#viewer_quick").fadeOut();
								updateView($scope);
							}
							break;
						case "tap":
							{
								if($("#viewer_header").is(":visible")) {
									$("#viewer_header").slideUp();
									$("#viewer_quick").fadeOut();
									$("#viewer_section").css("top", "0px").css("height", ($("#viewer_section").height()+56)+"px");
								} else {
									$("#viewer_header").slideDown();
									$("#viewer_quick").fadeIn();
									$("#viewer_section").css("top", "56px").css("height", ($("#viewer_section").height()-56)+"px");
								}
							}
							break;
						case "fontSize":
							{
								if (fnObjectCheckNull(msg.uiEventData) == true) return;

								var fontSize = (msg.uiEventData == "") ? "-" : msg.uiEventData;
								$("#font_size_status").text(fontSize);
							}
							break;
						case "boldStatus":
						case "italicStatus":
						case "uLineStatus":
						case "mLineStatus":
						case "superStatus":
						case "subStatus":
						case "unOrderListStatus":
						case "totalSlideNum":
						case "currentSlideNum":
						case "iframeDone":
						case "orderListStatus":
							{
								if (fnObjectCheckNull(msg.uiEventData) == true) return;

								var targetBtn;
								switch (msg.uiEvent) {
									case "boldStatus":
										targetBtn = $(".bold_quick");
										break;
									case "italicStatus":
										targetBtn = $(".italic_quick");
										break;
									case "uLineStatus":
										targetBtn = $(".uline_quick");
										break;
									case "mLineStatus":
										targetBtn = $(".mline_quick");
										break;
									case "superStatus":
										targetBtn = $(".super_quick");
										break;
									case "subStatus":
										targetBtn = $(".sub_quick");
										break;
									case "unOrderListStatus":
										targetBtn = $(".unorder_quick");
										break;
									case "orderListStatus":
										targetBtn = $(".order_quick");
										break;
								}
								

								if(targetBtn){
									if (msg.uiEventData == true)
										targetBtn.addClass("on");
									else
										targetBtn.removeClass("on");
								}
								
							}
							break;
						case "alignStatus":
							$(".left_align_quick").removeClass("on");
							$(".center_align_quick").removeClass("on");
							$(".right_align_quick").removeClass("on");
							$(".full_align_quick").removeClass("on");

							switch (msg.uiEventData) {
								case 0:
									break;
								case 1:
									$(".left_align_quick").addClass("on");
									break;
								case 2:
									$(".center_align_quick").addClass("on");
									break;
								case 3:
									$(".right_align_quick").addClass("on");
									break;
								case 4:
									$(".full_align_quick").addClass("on");
									break;
							}
							break;
						case "qrStatusCB":
							if(msg.uiEventData) {
								var statusArray = msg.uiEventData.split('|');
								if(statusArray.length > 1) {
									if(statusArray[0] == "true")
										$scope.bQRFirstStatus = true;
									if(statusArray[1] == "true")
										$scope.bQRLastStatus = true;
								}
							}
							break;
						case "saveStatus":
							if (msg.uiEventData == false) {
								$(".btn_save").addClass("disabled");
							} else {
								$(".btn_save").removeClass("disabled");
							}
							break;
						case "undoStatus":
							if(msg.uiEventData == false) {
								$(".btn_undo").addClass("disabled");
							} else {
								$(".btn_undo").removeClass("disabled");
							}
							break;
						case "redoStatus":
							if (msg.uiEventData == false) {
								$(".btn_redo").addClass("disabled");
							} else {
								$(".btn_redo").removeClass("disabled");
							}
							break;
						default:
							dalert("Default - "+msg.uiEvent);
							break;
					}
				}
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.onResizeProc = function() {
		if (g_browserCHK.galaxyfold === true) {
			var viewerScope = $("#viewerFrame").scope();
			if(fnObjectCheckNull(viewerScope) === false){
				viewerScope.onResizeProc();
			}
		}
		
		sendIFrameMessage("resize", null, false);
	};
	
	$scope.setCommentMargin = function(margin){
		try{
			return { marginLeft: parseInt(margin)*10 }
		}catch(e){
			dalert(e);
		}
	}
	
	
	$scope.getCommentPrfile = function(commetData){
		return 'http://' + mobile_http.hybridBaseData.result.compDomain + '/upload/img/profile/' + $scope.myInfo.group_seq + '/' + commetData.createSeq + '.jpg';
	}
	
	function getCommentCount() {
		var requestData = {
			langCode : "kr",
			moduleGbnCode : "oneffice",
			moduleSeq : $scope.$parent.objCurrentDoc.seq,
			commentType:""
		};
		
		onefficeMGW.getCommentCount(requestData, function (responseData) {
			$scope.CommentCount = responseData.count;
			updateView($scope);
		}, false);
	}
	
	$scope.setScrollTopEditor = function(){
		try{
			g_objEditorDocument[0].getElementById('dze_document_main_container').scrollTop = 0;
		}catch(e){
			dalert(e);
		}
		
	}
});
