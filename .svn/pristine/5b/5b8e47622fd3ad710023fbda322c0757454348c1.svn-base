/*
 * 
 */

onefficeApp.controller("ctrl_home", function($scope, $http, $timeout, $state, $filter, $compile, docDataFact) {
   
	var templateScroll;
	var myScroll;
	var menuScroll;
	var folderPathScroll;
	var actionSheetScroll;
	var modeListModel = ['mainView', 'selectView', 'folderView', 'searchView', 'moveView'];
	var objOriginActionSheet;
	var bOpenLink = false;
	var nTouchPoint = -1;
	var nRefresh = 0;		// 0: no,		1: need,		2: ing,			-1: cancel
	var defaultMaxViewSize = 40;
	
	$scope.dataLoading   = false;
	$scope.docViewMode = oneffice.bDocViewMode;
	$scope.viewMode = modeListModel[3];
	$scope.selectCount = 0;
	$scope.currentFolderType = MOBILE_BROWSER_INDEX_MY_FOLDER;
	$scope.currentFolderItem;
	$scope.currentFolderSeq = "";
	$scope.currentFolderName = "MY ONEFFICE"; 
	$scope.parentFolderItem;
	$scope.parentFolderSeq = "";
	$scope.fileCnt = 0;
	$scope.folderCnt = 0;
	$scope.searchComment = "검색 결과가 없습니다.";
	$scope.sortOption = oneffice.sortInfo.sortOption[MOBILE_BROWSER_INDEX_MY_FOLDER];
	$scope.sortAline = oneffice.sortInfo.sortAline[MOBILE_BROWSER_INDEX_MY_FOLDER];
	$scope.bMove = false;
	$scope.copySelectItems = [];
	$scope.arrTemplate = [];
	$scope.maxView = defaultMaxViewSize;
	$scope.reloadComment = false;
	$scope.getBaseData = function() {
		if (objOnefficeLoader.m_bDev === false) {
			NextS.call_getBaseData(init);
		} else {
			onefficeMGW.getMyInfo(init);
		}
		
		function init(objBaseData) {
			if (fnObjectCheckNull(objBaseData) === false) {
				if (objOnefficeLoader.m_bDev === false) {
					// from getBaseData
					if (objBaseData.hasOwnProperty('companyInfo') === false) {
						objBaseData = objBaseData.result;
					}
					
					mobile_http.hybridBaseData = objBaseData;
					
					var objMyInfo = {
						biz_seq: objBaseData.companyInfo.bizSeq,
						login_id: objBaseData.result.loginUserId,
						mail_id: objBaseData.companyInfo.emailAddr,
						mail_domain: objBaseData.companyInfo.emailDomain,
						comp_id: objBaseData.companyInfo.compSeq,
						report_yn: "Y",
						duty_name: objBaseData.result.positionName,
						org_id: objBaseData.result.deptSeq,
						comp_name: objBaseData.result.compName,
						name: objBaseData.result.empName,
						id: objBaseData.result.empSeq,
						org_name: objBaseData.result.deptName,
						group_seq: objBaseData.result.groupSeq
					};
					
					objMyInfo.pic = "http://" + objBaseData.result.compDomain + "/upload/img/profile/" + objMyInfo.group_seq + "/" + objMyInfo.id + "_thum.jpg";
					
					$("#mainContainer").scope().myInfo = objMyInfo;
				} else {
					// from getMyInfo
					$("#mainContainer").scope().myInfo = objBaseData;
				}
				
				oneffice.onefficeGroupSeq = $scope.myInfo.group_seq;
				
				
				NextS.getValue("userEnv", function(objResponse) {
					if (fnObjectCheckNull(objResponse) === true
							|| fnObjectCheckNull(objResponse.userEnv) === true || objResponse.userEnv.length === 0) {
						return;
					}
					
					var strJson = JSON.parse(objResponse.userEnv);
					var objUserEnvInfo;
					
					if (typeof(strJson) === "string") {
						objUserEnvInfo = $.parseJSON(strJson);
					} else {
						objUserEnvInfo = strJson;
					}
					
					if (fnObjectCheckNull(objUserEnvInfo.autoSave) === false) {
						oneffice.autoSave = objUserEnvInfo.autoSave;
					}
					
					if (fnObjectCheckNull(objUserEnvInfo.timer) === false) {
						oneffice.autoSaveTime = objUserEnvInfo.timer;
					}
					if (fnObjectCheckNull(objUserEnvInfo.viewMode) === false) {
						oneffice.bDocViewMode = objUserEnvInfo.viewMode;
						$scope.docViewMode = oneffice.bDocViewMode;
					}
					if (fnObjectCheckNull(objUserEnvInfo.sortInfo) === false) {
						oneffice.sortInfo = objUserEnvInfo.sortInfo;
						$scope.sortOption = oneffice.sortInfo.sortOption[$scope.currentFolderType];
						$scope.sortAline = oneffice.sortInfo.sortAline[$scope.currentFolderType];
					}
					
				});
				
			
			}
			
			$scope.initHome();
			
			if (objOnefficeLoader.m_bDev === false && fnObjectCheckNull(objBaseData.redirect_data) === false) {
				openIn(objBaseData.redirect_data);
			}
		}
	};
	
	$scope.changeLimit = function() {
		$scope.maxView += defaultMaxViewSize;
		$scope.$apply();
		
		setTimeout(function () {
			setDocItemHeight();
			myScroll.refresh();
		}, 100);
	};
	
    $scope.initHome = function() {
    	try {
			templateScroll = new iScroll('id_template_doc_scroll', {"hScroll":true, "hScrollbar":false,"vScroll":false,"wrapperClass":"hWrap1", "resizeWrapper":false});
			
			myScroll = new iScroll('idx_doc_iscroll', {
				"onScrollStart": function (event) {
					var arrClass = event.target.classList;
					
					if (arrClass.contains("btn_more") === true || arrClass.contains("ico_more") === true) {
						return;
					}
					
					if ($(".quick_menu").hasClass("off") === false
							&& $(event.target).parents(".folder_div").length === 0
							&& $(event.target).parents("#id_template_doc_scroll").length === 0
							&& $(event.target).parents("#idx_location_iscroll").length === 0) {
						$(".quick_menu").addClass("off");
					}
				}, "onScrollEnd": function () {
					if ($scope.currentFolderType === MOBILE_BROWSER_INDEX_FAVORITE_FOLDER
							&& event.target !== null && $(event.target).parents(".folder_div").length !== 0) {
						setTimeout(function() {
							showQuickMenu();
						}, 300);
					} else {
						showQuickMenu();
					}
					
					var _posy = myScroll.y;
					if(myScroll.maxScrollY>=myScroll.y){
						$timeout($scope.changeLimit,10);
					}
					
				}, "onBeforeScrollMove": function (){
					
					
				},
				"hScroll":false, "vScrollbar":false, "vScroll":true, "mousewheel":false});
			
			menuScroll = new iScroll('idx_menu_iscroll', {"hScroll":false, "vScrollbar":false, "vScroll":true, "mousewheel":false, "wrapperClass":"side_con"});
			
			if ($("#idx_menu_iscroll").height() >= $("#idx_menu_iscroll ul").height()) {
				menuScroll.disable();
			}
			
			setTimeout(function () {menuScroll.refresh();}, 100);
			
			getTemplate();
			
			$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq, function() {
				$(".quick_menu").removeClass("off");
			});
			
			document.title = "ONEFFICE MOBILE";
			
			$("section").height((window.height - 56 - parseInt($("section").css("padding-top"), 10) - parseInt($("section").css("padding-bottom"), 10)) + "px");
			
			$("section").touchstart(function() {
				$("#input_doc").blur();
				
				if ($scope.viewMode === 'searchView') {
					myScroll.refresh();
				}
			});
			
			$(".side").height(window.height);
			sideMenuClo();
			quick_btn();
			
			actionSheetScroll = new iScroll('id_actionsheet_scroll', {"hScroll":false, "vScrollbar":false, "vScroll":true, "mousewheel":false});
			dzeJ(".action_div").css("max-height", window.height / 2);
			dzeJ(".action_div .menu_container").css("position", "relative");
			
			if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
				actionSheetScroll.disable();
			}
			
			$("#one_home article")[0].addEventListener("touchstart", function(event) {
				if (event.touches.length > 1) {
					event.preventDefault();
				}
			}, {passive: false});
			
			$("#one_home").touchstart(function(event) {
				if (nRefresh === 2
						|| $("#id_actionsheet_scroll").hasClass("on") === true || $(this).find("article").hasClass("on") === true
						|| ($scope.viewMode !== "mainView" && $scope.viewMode !== "folderView")) {
					return;
				}
				
				var touches = event.originalEvent.touches;
				var nTop = parseInt($("#one_home .con_in").css("top"), 10);
				
				if (touches.length === 1 && nTop === 0) {
					nTouchPoint = touches[0].clientY;
					nRefresh = 0;
				}
			}).touchmove(function(event) {
				if (nRefresh === 2
						|| (g_browserCHK.androidtablet === false && g_browserCHK.iPad === false && templateScroll.moved === true)
						|| (fnObjectCheckNull(folderPathScroll) === false &&folderPathScroll.moved === true)) {
					return;
				}
				
				var touches = event.originalEvent.touches;
				
				if (touches.length === 1) {
					if (nTouchPoint < 0) {
						return;
					}
					
					var nHeight = touches[0].clientY - nTouchPoint;
					
					if (0 < nHeight && nHeight <= 150) {
						if (nRefresh === 1 || nRefresh === -1) {
							nRefresh = -1;
						} else {
							nRefresh = 0;
						}
						
						myScroll.enable();
						$("#one_home .con_in").css("top", nHeight);
						
						$(this).find(".refresh").show().css({height: nHeight, opacity: ((nHeight - 50) / 100)});
					} else if (nHeight > 150) {
						nRefresh = 1;
						
						myScroll.disable();
						$("#one_home .con_in").css("top", "150px");
						
						$(this).find(".refresh").show().css({height: 150, opacity: 1});
					}
				}
			}).touchend(function() {
				if (nRefresh === 2) {
					return;
				}
				
				myScroll.enable();
				
				if (nRefresh === 1) {
					nRefresh = 2;
					
					$("#one_home .refresh_modal").show();
					
					var nLimit = 0;
					
					var objInterval = setInterval(function() {
						if (nLimit === 300) {
							doneRefresh();
						}
						
						nLimit++;
					}, 100);
					
					$("#one_home .con_in").animate({top: "70px"}, 400);
					
					$("#one_home .refresh").animate({height: "70px"}, 400).delay(2000).show(function() {
						$scope.doRefresh(function() {
							doneRefresh();
						}, false);
					});
					
					function doneRefresh() {
						clearInterval(objInterval);
						
						$("#one_home .con_in").delay(200).animate({top: "0px"}, "fast", "linear");
						
						$("#one_home .refresh").css("opacity", 0).hide();
						$("#one_home .refresh_modal").hide();
						
						nTouchPoint = -1;
						nRefresh = 0;
					}
				} else {
					if (nRefresh === -1) {
						nRefresh = 0;
						$("#one_home .con_in").animate({top: "0px"}, 100);
					}
					
					$(this).find(".refresh").css("opacity", 0).hide();
					nTouchPoint = -1;
				}
			});
    	} catch (e) {
    		dalert(e);
    	}
	};
	
	$scope.sideMenu = function() {
		try {
			$(".side").animate({ left: "0px" }, 300);
			$(".side").addClass("on");
			$(".modal").show();
		} catch (e) {
			dalert(e);
		}
	};
	
	var sideMenuClo = function() {
		try {
			$(".modal").click(function () {
				$(".side").animate({ left: "-267px" }, 300);
				$(".side").removeClass("on");
				$(".action_div").removeClass("on");
				$(this).hide();
				
				showQuickMenu();
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	var closeModal = function() {
		try {
			if ($(".modal").css('display') !== 'none') {
				$(".modal").click();
			}
			
			if ($(".cancelmodal").css('display') !== 'none') {
				$(".cancelmodal").click();
			}
			
			objOriginActionSheet = null;
		} catch (e) {
			dalert(e);
		}
	};
	
	var quick_btn = function() {
		try {
			$(".quick_menu").click(function () {
				if (!$(this).hasClass("on")) {
					$(this).addClass("on");
					$(".quick_menu .text").show();
					$(".quick_modal").css("display", "block");
					$(".form_menu, .folder_menu, .docu_menu").css('opacity',1);
				} else {
					$(this).removeClass("on");
					$(".quick_menu .text").hide();
					$(".quick_modal").css("display", "none");
					$(".form_menu, .folder_menu, .docu_menu").css('opacity',0);
				}
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	var showQuickMenu = function() {
		try {
			if (($scope.currentFolderType === MOBILE_BROWSER_INDEX_MY_FOLDER || $scope.currentFolderType === MOBILE_BROWSER_INDEX_RECENT_FOLDER)
					&& $scope.viewMode !== 'searchView' && $scope.viewMode !== 'selectView') {
				$(".quick_menu").removeClass("off");
			} else {
				$(".quick_menu").addClass("off");
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var hideOverMenus = function() {
		try {
			var actionDiv = dzeJ(".action_div");
			
			if (actionDiv.hasClass("on") === true) {
				actionDiv.removeClass("on");
			}
			
			closeModal();
		} catch (e) {
			dalert(e);
		}
	};
	
	//사용자 정보 로드
//    $scope.getMyInfoData = function() {
//    	try{
//			onefficeMGW.getMyInfo(function(responseData) {
//				if (fnObjectCheckNull(responseData) === false) {
//					$scope.$parent.myInfo = responseData;
//					oneffice.onefficeGroupSeq = responseData.group_seq;
//				}
//			});
//    	}catch(e){
//    		dalert(e);
//    	}
//	};
	
	//폴더별 리스트 요청
    $scope.getListsByType = function(nType, name) {
		try {
			closeModal();
			$scope.currentFolderName = name;
			$scope.getDataLoadDocumnet(nType, "", function() {
				showQuickMenu();
				
				setTimeout(function() {
					myScroll.scrollTo(0, 0);
				}, 100);
			});
		} catch (e) {
			dalert(e);
		}
    };
	
	var getTemplate = function() {
		try {
			if (fnObjectCheckNull(docformTemplateCategory) === false) {
				docformTemplateCategory.forEach(function(objCategory) {
					objCategory.data.forEach(function(objTemplate) {
						objTemplate.image = "../mobile/images/temp/" + objTemplate.image;
						$scope.arrTemplate.push(objTemplate);
					});
				});
				
				var objContainer = $("#id_template_doc_scroll");
				var objTemplateList;
				
				var objInterval = setInterval(function() {
					objTemplateList = objContainer.find("li");
					
					if (objTemplateList.length > 0) {
						clearInterval(objInterval);
						
						var nThumbWidth;
						var nMargin;
						var nTotal = 0;
						var nWindowWidth = $(window).width();
						
						 if (nWindowWidth >= 712) {
							if (nWindowWidth >= 1024) {
								nThumbWidth = ((nWindowWidth - 100) / 5 - 10);
							} else {
								nThumbWidth = ((nWindowWidth - 60) / 5 - 10);
							}
							
							nMargin = 10;		// margin-left + margin-right
							objTemplateList.width(nThumbWidth);
						} else {
							objTemplateList.width("");
							nThumbWidth = objTemplateList.width();
							nMargin = 8;		// margin-left + margin-right
						}
						
						nTotal = objTemplateList.length * (nThumbWidth + nMargin) + 5;
						
						objContainer.find("ul").css({
							width: nTotal,
							position: "relative"
						});
						
						objTemplateList.css("visibility", "");
						
						setTimeout(function() {
							templateScroll.refresh();
							templateScroll.scrollTo(0, 0);
						}, 100);
						
						if (nTotal < $(window).width()) {
							templateScroll.disable();
						} else {
							templateScroll.enable();
						}
					}
				}, 100);
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var setDocItemHeight = function() {
		try {
			var nDocWidth;
			var nWindowWidth = $(window).width();
			
			if (nWindowWidth < 430) {
				// phone
				nDocWidth = ((nWindowWidth - 24) / 2) - 8;
			} else if (nWindowWidth < 712) {
				// galaxy fold min-device-width: 535
				nDocWidth = ((nWindowWidth - 24) / 3) - 8;
			} else if (nWindowWidth < 1024) {
				// tablet min-device-width: 712
				nDocWidth = ((nWindowWidth - 60) / 4) - 10;
			} else if (nWindowWidth >= 1024) {
				// tablet min-device-width: 1024
				nDocWidth = ((nWindowWidth - 100) / 5) - 10;
			}
			
			var nDocHeight = Math.round(nDocWidth * 1.1);
			
			$(".my_doc .doc_div").css({height: nDocHeight, visibility: "visible"});
			$(".my_doc .doc_div .preview").height(nDocHeight - 54);
		} catch (e) {
			dalert(e);
		}
	};
    
    //전체 문서 데이터 로드
    $scope.getDataLoadDocumnet = function(nType, folderSeq, fnCallback, bShowLoading) {
    	try{
			if (checkDoubleClick() === true) {
				return;
			}
			
			if ($scope.viewMode === "selectView") {
				return;
			}
			
			var bInitIScroll = ($scope.currentFolderName === "MY ONEFFICE" || $scope.currentFolderName === "중요 문서" || fnObjectCheckNull(folderPathScroll) === true);
			
    		$scope.currentFolderType = nType;
    		
    		$scope.sortOption = oneffice.sortInfo.sortOption[$scope.currentFolderType];
			$scope.sortAline = oneffice.sortInfo.sortAline[$scope.currentFolderType];
			
			$scope.reloadComment = false;
			$scope.maxView = defaultMaxViewSize;
			
    		if(folderSeq!="" && $scope.viewMode!='moveView'){
        		$scope.viewMode = 'folderView';
        	}else if($scope.viewMode!='moveView'){
        		$scope.viewMode = 'mainView';
        	}
			
    		if(MOBILE_BROWSER_INDEX_MY_FOLDER != nType || $scope.viewMode != 'mainView' || folderSeq!=""){
				dzeJ(".template_doc").slideUp("slow");
				
			}else{
				dzeJ(".template_doc").slideDown("slow");
			}
    		
    		$scope.$parent.docDataFact.getDocumentList(nType, folderSeq, bShowLoading).then(function(data) {
				if(nType == MOBILE_BROWSER_INDEX_SHARE_OUT || nType == MOBILE_BROWSER_INDEX_SHARE_IN) {
					var newListViewData = [];
					var strEmpSeq = $scope.myInfo.id;
					
					if (strEmpSeq !== null) {
						if (MOBILE_BROWSER_INDEX_SHARE_OUT === nType) {
							for (var i = 0; i < data.list.length; i++) {
								if (data.list[i].userData.nOwnerID === strEmpSeq
										&& data.list[i].deleted != 1) {
									newListViewData.push(data.list[i]);
								}
							}
						}
						
						if (MOBILE_BROWSER_INDEX_SHARE_IN === nType) {
							for (var i = 0; i < data.list.length; i++) {
								if (data.list[i].userData.nOwnerID !== strEmpSeq) {
									newListViewData.push(data.list[i]);
								}
							}
						}
						
						data.list = newListViewData;
					}
				}
				
				if ($scope.viewMode === "moveView") {
					for (var ix=0; ix<$scope.copySelectItems.length; ix++) {
						var _copyObj = $scope.copySelectItems[ix];
						
						if (folderSeq !== _copyObj.parentFolderSeq) {
							data.list.push(_copyObj);
						}
					}
				}
				$scope.reloadComment = true;
    			$scope.documnetDataList = data.list;
    			
    			setFilterApply('');
    			checkSelectList();
				
    			setTimeout(function () {
					setDocItemHeight();
					myScroll.refresh();
				}, 300);
    			
				if (fnObjectCheckNull(fnCallback) === false) {
					fnCallback();
				}
			});
			
			$scope.$parent.docDataFact.getFolderPath(folderSeq).then(function(data) {
    			$scope.folderPathList = data.folderPath;
    			if($scope.folderPathList.length>0){
    				$scope.currentFolderItem = $scope.folderPathList[$scope.folderPathList.length-1];
    				$scope.currentFolderSeq  = $scope.currentFolderItem[0];
    				if(nType==MOBILE_BROWSER_INDEX_MY_FOLDER)
    					$scope.currentFolderName = $scope.currentFolderItem[1]; 	
    			}
    			
    			if($scope.folderPathList.length>1){
    				$scope.parentFolderItem = $scope.folderPathList[$scope.folderPathList.length-2];
        			$scope.parentFolderSeq = $scope.parentFolderItem[0];
    			}
    		}).then(function() {
				setTimeout(function () {
					if ($(".location").length !== 0) {
						var nTotalWidth = 0;
						
						$(".location").find("li").each(function(index, item) {
							nTotalWidth += item.offsetWidth;
						});
						
						$(".location").find("ul").css("width", nTotalWidth + 10);		// 오차 대략 10 정도 가산
						
						if (bInitIScroll === true) {
							folderPathScroll = new iScroll('idx_location_iscroll', {"hScroll":true, "hScrollbar":false, "vScroll":false, "wrapperClass":"hWrap1", "resizeWrapper":false});
						} else {
							folderPathScroll.refresh();
						}
						
						folderPathScroll.scrollTo(nTotalWidth, 0, 0, "back");
//						folderPathScroll.scrollToElement($(".location").find("li").last().get(0));
					}
				}, 100);
			});
    		
    		dzeJ('#mainContainer').show(500);
    	}catch(e){
    		dalert(e);
    	}
    };
	
    //롱프레스 이벤트
    $scope.itemOnLongPress = function() {
		try {
			if ($scope.viewMode !== 'selectView' && $scope.viewMode !== 'searchView') {
				$scope.viewMode = 'selectView';
			}
		} catch (e) {
			dalert(e);
		}
    };
    
    //close 버튼 모드 체인지
    $scope.closeCurrentMode = function()
    {
    	try{
    		switch ($scope.viewMode) {
    		  case 'selectView':
    			  $scope.viewMode = modeListModel[0];
    			  $scope.getDataLoadDocumnet($scope.currentFolderType,$scope.currentFolderSeq);
    		    break;
    		  case 'searchView':
    			  $scope.viewMode = modeListModel[0];
    		    break;
    		  case 'moveView':
    			  $scope.viewMode = modeListModel[0];
    			  $scope.copySelectItems = [];
    			  $scope.getDataLoadDocumnet($scope.currentFolderType,$scope.currentFolderSeq);
    			  
    		    break;
    		  default:
    			break;
    		}
    	}catch(e){
    		dalert(e);
    	}
    };
    
    //문서 폴더 선택 및 해제
    $scope.fileSelectionEvent = function(docItem) {
    	try {
			if (event.target.classList.contains("btn_more") === true
					|| $scope.viewMode !== 'selectView') {
				return;
			}
			
    		docItem.docData.bChecked = docItem.docData.bChecked ? false : true;
    		checkSelectList();
			
			checkBtnDisable();
    	} catch (e) {
    		dalert(e);
    	}
    };
	
	var checkBtnDisable = function() {
		try {
			$scope.$parent.docDataFact.getCheckList();
			
			var bSharedOut = true;		// 공유받은 문서 체크
			
			if ($scope.$parent.docDataFact.checklist.length > 0) {
				$scope.$parent.docDataFact.checklist.some(function(objData) {
					if (objData.userData.nOwnerID.length > 0
							&& $scope.myInfo.id !== objData.userData.nOwnerID) {
						
						bSharedOut = false;
						return;
					}
				});
			}
			
			if ($scope.selectCount === 0 || bSharedOut === false) {
				$("#one_home .right_div .btn_del, #one_home .right_div .btn_move").addClass("disabled");
			} else {
				$("#one_home .right_div .btn_del, #one_home .right_div .btn_move").removeClass("disabled");
			}
		} catch (e) {
			dalert(e);
		}
	};
    
    //선택 리스트 체크
    var checkSelectList = function() {
    	try {
    		var _checkCnt=0;
    		for(var ix=0; ix<$scope.documnetDataList.length; ix++){
    			var _obj = $scope.documnetDataList[ix];
    			if(_obj.docData.bChecked){
    				_checkCnt++;
    			}
    			if($scope.viewMode=="moveView"){
					for(var i=0; i<$scope.copySelectItems.length; i++){
						var _copyObj = $scope.copySelectItems[i];
						if(_obj.seq == _copyObj.seq){
							_obj.docData.bTemp = true;
							_obj.docData.bChecked = true;
						}
					}
				}
    		}
    		$scope.selectCount = _checkCnt;
    	}catch(e){
    		dalert(e);
    	}
	};
    
    //썸네일 리스트 보기 모드 변경
    $scope.changeFileViewMode = function()   {
    	try {
    		$scope.docViewMode = $scope.docViewMode?false:true;
    		oneffice.bDocViewMode = $scope.docViewMode;
    		NextS.setValue({key: "userEnv", val: JSON.stringify({autoSave: oneffice.autoSave, timer: oneffice.autoSaveTime, viewMode:oneffice.bDocViewMode, sortInfo:oneffice.sortInfo})});
    		setTimeout(function () {myScroll.refresh();}, 100);
    	} catch (e) {
    		dalert(e);
    	}
	};
	
	// 더보기 버튼
	$scope.moreBtnClick = function(objDocInfo) {
		try {
			var objActionSheet = dzeJ(".action_div");
			
			if (objActionSheet.hasClass("on") === true) {
				objActionSheet.removeClass("on");
				dzeJ(".modal").css("display", "none");
				
				return;
			}
			
			if (fnObjectCheckNull(objDocInfo) === false) {
				objDocInfo.docData.bChecked = true;
				$("#mainContainer").scope().objCurrentDoc = objDocInfo;
			} else {
				$("#mainContainer").scope().objCurrentDoc = $scope.$parent.docDataFact.getCheckList()[0];
			}
			
			var nCheckStatus;
			
			switch ($scope.viewMode) {
				case "selectView":	nCheckStatus = ($scope.$parent.docDataFact.checklist.length === 0) ? MOBILE_MORE_NONE_SELECT : $scope.$parent.docDataFact.getCheckStatus();	break;
				case "searchView":	nCheckStatus = (fnObjectCheckNull(objDocInfo) === true) ? MOBILE_MORE_SEARCH_MODE : $scope.$parent.docDataFact.getCheckStatus(objDocInfo);	break;
				default:			nCheckStatus = $scope.$parent.docDataFact.getCheckStatus(objDocInfo);	break;
			}
			
			if ((nCheckStatus === MOBILE_MORE_DOC_SELECT || nCheckStatus === MOBILE_MORE_SHARE_MODE)
					&& $scope.$parent.objCurrentDoc.nShareCount > 0) {
				
				$scope.$parent.docDataFact.updateDocShareInfo($scope.$parent.objCurrentDoc.seq).then(function() {
					showMoreMenu(nCheckStatus);
				});
			} else {
				showMoreMenu(nCheckStatus);
			}
		} catch(e) {
			dalert(e);
		}
	};
	
	var showMoreMenu = function(nCheckStatus) {
		try {
			var objActionSheet = $(".action_div");
			
			objActionSheet.find(".menu_container")[0].innerHTML = makeMoreMenuList(nCheckStatus);
			objActionSheet.addClass("on");
			
			if (fnObjectCheckNull($scope.$parent.objCurrentDoc) === false) {
				$(".cancelmodal").css("display", "block");
				
				// 폴더 선택 시 bChecked 값이 초기화 되어있음
				$("#mainContainer").scope().objCurrentDoc.docData.bChecked = true;
			} else {
				$(".modal").css("display", "block");
			}
			
			objActionSheet.find(".ac").on('click', function() {
				moreItemClick(this.getAttribute("menuIndex"));
			});
			
			actionSheetScroll.scrollTo(0, 0);
			
			if (nCheckStatus === MOBILE_MORE_SEARCH_MODE) {
				$(".m_sort_name, .m_sort_date, .m_sort_owner, .m_sort_size").height("56px").show();
				
				selectSortCheck($scope.sortOption, $scope.sortAline);
			}
			
			setTimeout(function() {
				actionSheetScroll.refresh();
			}, 300);
			
			$(".quick_menu").addClass("off");
		} catch (e) {
			dalert(e);
		}
	};
	
	// 설정 버튼
//	$scope.settingBtnClick = function() {
//		try {
//			// 앱 버전에 적용 시 하이브리드 규격에 따라 새 웹뷰로 링크 출력하도록 수정 필요
//			if(g_browserCHK.iOS === true) {
//				var aLink = document.createElement("a");
//				aLink.href = document.location.href.replace("m_one_main.html", "m_one_setting.html");;
//				aLink.click();
//			} else {
//				document.location.href = document.location.href.replace("m_one_main.html", "m_one_setting.html");
//			}
//		} catch(e) {
//			dalert(e);
//		}
//	};
	
	// 로그아웃 버튼
	$scope.settingBtnClick = function() {
		try {
			closeModal();
			
			$("#mainContainer").scope().currentViewPage = "one_custom_page";
			$("#mainContainer").scope().strPageType = "setting";
			
			updateView($scope);
		} catch(e) {
			dalert(e);
		}
	};

	var makeMoreMenuList = function(checkStatus) {
		try {
			var moreMenus = document.createElement("div");
			
			if (MOBILE_BROWSER_INDEX_TRASHBOX == $scope.currentFolderType) {
				checkStatus = MOBILE_MORE_NONE_SELECT;
			}
			
			switch (checkStatus) {
				case MOBILE_MORE_NONE_SELECT:
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_NAME, false, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_DATE, false, true));
					
					if ($scope.currentFolderType == MOBILE_BROWSER_INDEX_SHARE_FOLDER ||
					   $scope.currentFolderType == MOBILE_BROWSER_INDEX_SHARE_OUT ||
					   $scope.currentFolderType == MOBILE_BROWSER_INDEX_SHARE_IN) {
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_OWNER, false, true));
					}
					
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_SIZE, true, true));
					
					if ($scope.viewMode != 'selectView') {
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SELECT));
					}
					
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SELECT_ALL));
					
					if (MOBILE_BROWSER_INDEX_TRASHBOX == $scope.currentFolderType) {
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_EMPTY_TRASH));
					}
					
					break;
					
				case MOBILE_MORE_DOC_SELECT:
					var objDoc = $scope.$parent.objCurrentDoc;
					
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_CANCEL, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE));
					
					if (objDoc.userData.nOwnerID.length === 0
							|| $scope.myInfo.id === objDoc.userData.nOwnerID) {
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_MOVE));
					}
					
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_COPY));
					
					if (objDoc.userData.nOwnerID.length === 0
							|| $scope.myInfo.id === objDoc.userData.nOwnerID) {
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_DEL, true));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_FAVORITE));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_RENAME));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SECURITY));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_READONLY));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_DOCINFO));
					}
					
					break;
					
				case MOBILE_MORE_FOLDER_SELECT:
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_CANCEL, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_MOVE));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_DEL, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_FAVORITE));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_RENAME));
					
					break;
					
				case MOBILE_MORE_MULTI_SELECT:
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_CANCEL, true));
					
					if ($scope.$parent.docDataFact.checklist.some(function(objData) {
						if (objData.userData.nOwnerID.length > 0
								&& $scope.myInfo.id !== objData.userData.nOwnerID) {
							return false;
						}
					}) === false) {
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_MOVE));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_DEL));
					}
					
					break;
					
				case MOBILE_MORE_SEARCH_MODE:
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_NAME, false, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_DATE, false, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_OWNER, false, true));
					moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SORT_SIZE, false, true));
					
					break;
					
				case MOBILE_MORE_SHARE_MODE:
					var objDoc = $scope.$parent.objCurrentDoc;
					
					bOpenLink = objDoc.bOpenLink;
					
					if (objDoc.nShareCount > 0) {
						if (objDoc.userData.nOwnerID.length === 0
								|| $scope.myInfo.id === objDoc.userData.nOwnerID) {
							// 공유한 문서
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_BACK, true));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_LINK, true));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_LINK_VIEW, false, !bOpenLink));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_LINK_EDIT, true, !bOpenLink));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_USER, false));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_COPY_LINK, false, true));
						} else {
							// 공유받은 문서
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_BACK, true));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_USER, false));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_UNLINK, true));
							moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_COPY_LINK, false, true));
						}
					} else {
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_BACK, true));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_LINK, true));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_LINK_VIEW, false, !bOpenLink));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_LINK_EDIT, true, !bOpenLink));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_USER, false));
						moreMenus.appendChild(makeMoreMenuItem(MOBILE_MENU_SHARE_COPY_LINK, false, true));
					}
					
					break;
					
				default:
					break;
			}
			
			return moreMenus.innerHTML;
		} catch(e) {
			dalert(e);
		}
	};

	var makeMoreMenuItem = function(menuIndex, bLineBottom, bHidden) {
		try {
			var menuItem = document.createElement("div");
			menuItem.className = "ac";
			menuItem.setAttribute("menuIndex", menuIndex);

			switch (menuIndex) {
				case MOBILE_MENU_BACK:
					menuItem.className += " m_back";
					menuItem.innerHTML = '<dl><dt>뒤로가기</dt></dl>';
					
					break;
					
				case MOBILE_MENU_CANCEL:
					menuItem.className += " m_cancel";
					menuItem.innerHTML = '<dl><dt>선택 항목 취소</dt></dl>';
					break;
				case MOBILE_MENU_SHARE:
					menuItem.className += " m_share";
					
					var strShareStatus = "꺼짐";
					
					if ($scope.$parent.objCurrentDoc.nShareCount > 0) {
						strShareStatus = "켜짐";
					}
					
					menuItem.innerHTML = '<dl><dt>공유</dt><dd>' + strShareStatus + '<span class="arr"></span></dd></dl>';
					
					break;
					
				case MOBILE_MENU_MOVE:
					menuItem.className += " m_move";
					menuItem.innerHTML = '<dl><dt>이동</dt></dl>';
					break;
				case MOBILE_MENU_COPY:
					menuItem.className += " m_copy";
					menuItem.innerHTML = '<dl><dt>복사</dt></dl>';
					break;
				case MOBILE_MENU_DEL:
					menuItem.className += " m_del";
					menuItem.innerHTML = '<dl><dt>삭제</dt></dl>';
					break;
				case MOBILE_MENU_FAVORITE:
					menuItem.className += " m_book toggleBtn";
					if($scope.$parent.objCurrentDoc.docData.bStar == 0)
						menuItem.innerHTML = '<dl><dt>중요표시</dt><dd class=""><div class="toggleBG" style="background:#fff; border:1px solid #e5e5e5;"><input type="button" class="toggleFG" style="left:0px;" /></div></dd></dl>';
					else
					menuItem.innerHTML = '<dl><dt>중요표시</dt><dd class=""><div class="toggleBG"><input type="button" class="toggleFG" /></div></dd></dl>';
					break;
				case MOBILE_MENU_RENAME:
					menuItem.className += " m_modi";
					menuItem.innerHTML = '<dl><dt>이름바꾸기</dt></dl>';
					break;
				case MOBILE_MENU_SECURITY:
					menuItem.className += " m_secu";
					
					var strSecurityStatus = "꺼짐";
					
					if ($scope.$parent.objCurrentDoc.docData.bSecurity * 1 === 1) {
						strSecurityStatus = "켜짐";
					}
					
					menuItem.innerHTML = '<dl><dt>문서 보안</dt><dd>' + strSecurityStatus + '<span class="arr"></span></dd></dl>';
					
					break;
					
				case MOBILE_MENU_READONLY:
					menuItem.className += " m_read toggleBtn";
					
					if ($scope.$parent.objCurrentDoc.docData.bViewer == 0) {
						menuItem.innerHTML = '<dl><dt>읽기전용 설정</dt><dd class=""><div class="toggleBG" style="background:#fff; border:1px solid #e5e5e5;"><input type="button" class="toggleFG" style="left:0px;" /></div></dd></dl>';
					} else {
						menuItem.innerHTML = '<dl><dt>읽기전용 설정</dt><dd class=""><div class="toggleBG"><input type="button" class="toggleFG" /></div></dd></dl>';
					}
					
					break;
					
				case MOBILE_MENU_DOCINFO:
					menuItem.className += " m_docInfo";
					menuItem.innerHTML = '<dl><dt>문서정보</dt></dl>';
					
					break;
					
				case MOBILE_MENU_SORT:
					menuItem.className += " m_sort";
					menuItem.innerHTML = '<dl><dt>정렬기준</dt></dl>';
					break;
				case MOBILE_MENU_SORT_NAME:
					menuItem.className += " m_sort_name";
					menuItem.innerHTML = '<dl><dt>문서 제목순</dt><dd><span ></span></dd></dl>';
					break;
				case MOBILE_MENU_SORT_DATE:
					menuItem.className += " m_sort_date";
					menuItem.innerHTML = '<dl><dt>최종 수정날짜순</dt><dd><span ></span></dd></dl>';
					break;
				case MOBILE_MENU_SORT_OWNER:
					menuItem.className += " m_sort_owner";
					menuItem.innerHTML = '<dl><dt>소유자순</dt><dd><span ></span></dd></dl>';
					break;
				case MOBILE_MENU_SORT_SIZE:
					menuItem.className += " m_sort_size";
					menuItem.innerHTML = '<dl><dt>파일 크기순</dt><dd><span ></span></dd></dl>';
					break;
				case MOBILE_MENU_SELECT:
					menuItem.className += " m_select";
					menuItem.innerHTML = '<dl><dt >선택</dt></dl>';
					break;
				case MOBILE_MENU_SELECT_ALL:
					menuItem.className += " m_select_all";
					menuItem.innerHTML = '<dl><dt>모두 선택</dt></dl>';
					break;
				case MOBILE_MENU_EMPTY_TRASH:
					menuItem.className += " m_empty_trash";
					menuItem.innerHTML = '<dl><dt>휴지통 비우기</dt></dl>';
					break;
					
				case MOBILE_MENU_SHARE_LINK:
					var strHtml = '<dl><dt>링크 공유</dt>';
					
					if (bOpenLink === true) {
						strHtml += '<dd class=""><div class="toggleBG"><input type="button" class="toggleFG" /></div></dd></dl>';
					} else {
						strHtml += '<dd class=""><div class="toggleBG" style="background:#fff; border:1px solid #e5e5e5;"><input type="button" class="toggleFG" style="left:0px;" /></div></dd></dl>';
					}
					
					menuItem.className += " m_link toggleBtn";
					menuItem.innerHTML = strHtml;
					
					break;
					
				case MOBILE_MENU_SHARE_LINK_VIEW:
					menuItem.className += " m_link_view";
					menuItem.innerHTML = '<dl><dt>보기 가능</dt><dd><span ></span></dd></dl>';
					
					if (bOpenLink === true
							&& $scope.$parent.objCurrentDoc.shareData[0].nShareType === MOBILE_SHARE_OPEN_LINK
							&& $scope.$parent.objCurrentDoc.shareData[0].cSharePermission === "R") {
						menuItem.className += " chk";
					}
					
					break;
					
				case MOBILE_MENU_SHARE_LINK_EDIT:
					menuItem.className += " m_link_edit";
					menuItem.innerHTML = '<dl><dt>편집 가능</dt><dd><span ></span></dd></dl>';
					
					if (bOpenLink === true
							&& $scope.$parent.objCurrentDoc.shareData[0].nShareType === MOBILE_SHARE_OPEN_LINK
							&& $scope.$parent.objCurrentDoc.shareData[0].cSharePermission === "W") {
						menuItem.className += " chk";
					}
					
					break;
					
				case MOBILE_MENU_SHARE_USER:
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
						
						menuItem.className += " m_share_user";
						menuItem.innerHTML = '<dl><dt>사용자 공유</dt><dd>' + strShareStatus + '<span class="arr"></span></dd></dl>';
					} else {
						// 공유받은 문서
						if (nShareCount > 0) {
							strShareStatus = "(" + nShareCount + ")";
						}
						
						menuItem.className += " m_shareinfo";
						menuItem.innerHTML = '<dl><dt>공유 중인 사용자</dt><dd>' + strShareStatus + '<span class="arr"></span></dd></dl>';
					}
					
					break;
					
				case MOBILE_MENU_SHARE_UNLINK:
					menuItem.className += " m_unlink";
					menuItem.innerHTML = '<dl><dt>공유 해제</dt></dl>';
					
					break;
					
				case MOBILE_MENU_SHARE_COPY_LINK:
					menuItem.className += " m_copy_link";
					menuItem.innerHTML = '<dl><dt>링크 복사</dt></dl>';
					
					if ($scope.$parent.objCurrentDoc.nShareCount > 0) {
						bHidden = false;
					}
					
					break;
			}

			if(bLineBottom)
				menuItem.className += " line_btm";

			if(bHidden) {
				menuItem.style.display = "none";
				menuItem.style.height = "0px";
			}

			return menuItem;
		} catch(e) {
			dalert(e);
		}
	};

	$scope.menuClickBridge = function(menuIndex) {
		try {
			moreItemClick(menuIndex);
		} catch(e) {
			dalert(e);
		}
	};

	var moreItemClick = function(menuIndex) {
		try {
			var index = parseInt(menuIndex);
			switch (index) {
				case MOBILE_MENU_BACK:
					if (fnObjectCheckNull(objOriginActionSheet) === false) {
						// 공유 메뉴 상태 업데이트
						objOriginActionSheet.find(".ac.m_share dl dd")[0].innerHTML = (($scope.$parent.objCurrentDoc.nShareCount > 0) ? "켜짐" : "꺼짐") + '<span class="arr"></span></dd></dl>';
						jumpActionSheet($(".action_div .menu_container")[0].innerHTML, objOriginActionSheet[0].innerHTML, false);
						
						objOriginActionSheet = null;
					}
					
					break;
					
				case MOBILE_MENU_CANCEL:
					closeModal();

					for (var i = 0; i < $scope.$parent.docDataFact.list.length; i++) {
						$scope.$parent.docDataFact.list[i].docData.bChecked = false;
					}
					
					$scope.$parent.docDataFact.checklist = [];
					$("#mainContainer").scope().objCurrentDoc = null;
					
					checkSelectList();
					
					updateView($scope);
					
					break;
					
				case MOBILE_MENU_SHARE:
					objOriginActionSheet = $(".action_div .menu_container").clone(true);
					
					jumpActionSheet(objOriginActionSheet[0].innerHTML, makeMoreMenuList(MOBILE_MORE_SHARE_MODE), true);
					
					break;
					
				case MOBILE_MENU_MOVE:
					if ($scope.changeSelectMoveMode(true) === true) {
						updateView($scope);
						closeModal();
					}
					
					break;
				case MOBILE_MENU_COPY:
					if ($scope.changeSelectMoveMode(false) === true) {
						updateView($scope);
						closeModal();
					}
					
					break;
					
				case MOBILE_MENU_DEL:
					$scope.showTrashDialog(($scope.currentFolderType === MOBILE_BROWSER_INDEX_TRASHBOX) ? "delete_in_trash" : "delete_file");
					
					break;
					
				case MOBILE_MENU_FAVORITE:
					var bFavorite = ($scope.$parent.objCurrentDoc.docData.bStar == 0) ? true : false;
					
					onefficeMGW.setFavorite($scope.$parent.objCurrentDoc.seq, $scope.$parent.objCurrentDoc.parentFolderSeq, bFavorite);
					
					$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "bStar", bFavorite);
					updateView($scope);
					
					break;
					
				case MOBILE_MENU_RENAME:
					$scope.showInputDialog("rename");
					
					break;
					
				case MOBILE_MENU_SECURITY:
					if ($scope.$parent.bOnViewStatus === false) {
						closeModal();
					}
					
					$scope.$parent.currentViewPage = "one_scty";
					
					updateView($scope);
					
					break;
				
				case MOBILE_MENU_COMMENT:
					if ($scope.$parent.bOnViewStatus === false) {
						closeModal();
					}
					
					$scope.$parent.currentViewPage = "one_comment";
					
					updateView($scope);
					
					break;
					
				case MOBILE_MENU_DOCINFO:
					if ($scope.$parent.bOnViewStatus === false) {
						closeModal();
					}
					
					$scope.$parent.currentViewPage = "one_docinfo";
					
					updateView($scope);
					
					break;
					
				case MOBILE_MENU_READONLY:
					var bReadonly = ($scope.$parent.objCurrentDoc.docData.bViewer == 0) ? true : false;
					
					onefficeMGW.setReadonly($scope.$parent.objCurrentDoc.seq, $scope.$parent.objCurrentDoc.parentFolderSeq, bReadonly);
					
					$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "bViewer", bReadonly);
					updateView($scope);
					
					break;
					
				case MOBILE_MENU_SORT:
					if (dzeJ(".m_sort_name").is(":visible") === false) {
						dzeJ(".m_sort_name").show().animate({height: "56px"});
						dzeJ(".m_sort_date").show().animate({height: "56px"});
						dzeJ(".m_sort_owner").show().animate({height: "56px"});
						dzeJ(".m_sort_size").show().animate({height: "56px"});
						selectSortCheck($scope.sortOption, $scope.sortAline);
					} else {
						dzeJ(".m_sort_name").animate({height: "0px"}).hide("fast");
						dzeJ(".m_sort_date").animate({height: "0px"}).hide("fast");
						dzeJ(".m_sort_owner").animate({height: "0px"}).hide("fast");
						dzeJ(".m_sort_size").animate({height: "0px"}).hide("fast");
					}
					
					setTimeout(function() {
						actionSheetScroll.refresh();
					}, 500);
					
					break;
					
				case MOBILE_MENU_SORT_NAME:
					changeDocSortList(MOBILE_SORT_ATTR_NAME);
					break;
				case MOBILE_MENU_SORT_DATE:
					changeDocSortList(MOBILE_SORT_ATTR_DATE);
					break;
				case MOBILE_MENU_SORT_OWNER:
					changeDocSortList(MOBILE_SORT_ATTR_OWNER);
					break;
				case MOBILE_MENU_SORT_SIZE:
					changeDocSortList(MOBILE_SORT_ATTR_SIZE);
					break;
				case MOBILE_MENU_SELECT:
				case MOBILE_MENU_SELECT_ALL:
					closeModal();

					$scope.viewMode = 'selectView';

					if(index == MOBILE_MENU_SELECT_ALL) {
						for(var i = 0 ; i < $scope.$parent.docDataFact.list.length ; i++) {
							$scope.$parent.docDataFact.list[i].docData.bChecked = true;
						}
						checkSelectList();
					}
					
					updateView($scope);
					
					break;
					
				case MOBILE_MENU_EMPTY_TRASH:
					$scope.showTrashDialog("empty");
					
					break;
					
				case MOBILE_MENU_SHARE_LINK:
					// 토글버튼 이벤트 완료 후 메뉴 확장/축소 처리
					// 동시 진행 시 토글버튼 UI 먹통되는 현상 발생
					setTimeout(function() {
						if (dzeJ(".m_link_view").is(":visible") === false) {
							share(MOBILE_SHARE_OPEN_LINK, "R");
							
							dzeJ(".m_link_view").addClass("chk").show().animate({height: "56px"});
							dzeJ(".m_link_edit").show().animate({height: "56px"});
							dzeJ(".m_copy_link").show().animate({height: "56px"});
						} else {
							unShare(MOBILE_SHARE_OPEN_LINK);
							
							dzeJ(".m_link_view").removeClass("chk").animate({height: "0px"}).hide("fast");
							dzeJ(".m_link_edit").removeClass("chk").animate({height: "0px"}).hide("fast");
							
							if ($scope.$parent.objCurrentDoc.nShareCount === 0) {
								dzeJ(".m_copy_link").animate({height: "0px"}).hide("fast");
							}
						}
						
						setTimeout(function() {
							actionSheetScroll.refresh();
						}, 500);
					}, 300);
					
					break;
					
				case MOBILE_MENU_SHARE_LINK_VIEW:
					share(MOBILE_SHARE_OPEN_LINK, "R");
					
					break;
					
				case MOBILE_MENU_SHARE_LINK_EDIT:
					share(MOBILE_SHARE_OPEN_LINK, "W");
					
					break;
					
				case MOBILE_MENU_SHARE_USER:
					if ($scope.$parent.bOnViewStatus === false) {
						closeModal();
					}
					
					$scope.$parent.currentViewPage = "one_share";
					
					updateView($scope);
					
					break;
					
				case MOBILE_MENU_SHARE_UNLINK:
					var bSharedByGroup = false;
					var objDoc = $scope.$parent.objCurrentDoc;
					var arrUnshareInfo = [];
					var objMyInfo = $scope.myInfo;
					
					objDoc.shareData.some(function(objData) {
						if (objData.nShareType === MOBILE_SHARE_GROUP
								&& objMyInfo.org_id === objData.nShareID) {
							bSharedByGroup = true;
							return;
						} else if (objMyInfo.id === objData.nShareID
								|| objData.nShareType === MOBILE_SHARE_OPEN_LINK) {
							
							if (arrUnshareInfo.includes(objData.nShareType) === false) {
								arrUnshareInfo.push(objData.nShareType);
							}
						}
					});
					
					if (bSharedByGroup === false) {
						if ($scope.$parent.bOnViewStatus === false) {
							closeModal();
						} else {
							$scope.$parent.viewChange(0);
						}
						
						arrUnshareInfo.forEach(function(nShareType, nIndex) {
							onefficeMGW.unshareDocument(objDoc.seq, nShareType, objMyInfo.id, function() {
								if (nIndex + 1 === arrUnshareInfo.length) {
									mobileToast.show(objDoc.docData.strTitle + " 문서의 공유가 해제되었습니다");
									
									$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq);
								}
							});
						});
					} else {
						mobileToast.show("부서 공유가 된 문서는 공유 해제가 제한됩니다");
					}
					
					break;
					
				case MOBILE_MENU_SHARE_COPY_LINK:
					var strUrl = onefficeMGW.getDocumentShareOpenURL($scope.$parent.objCurrentDoc.seq, $scope.myInfo.group_seq);
					
					// 가져온 url을 mobile clipboard에 넣어야 함
					var clipboard = new ClipboardJS('.m_copy_link', {
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
					
					closeModal();
					
					break;
					
					
				case MOBILE_MENU_DOCPRINT:
					
					fnHandler_Print(null, $(".r17"), 0)
					closeModal();
					
					break;
			}
		} catch(e) {
			dalert(e);
		}
	};
    
    //폴더 이동
    $scope.moveFolderFunc = function(folderSeq)     {
    	try {
    		if ($scope.viewMode=='selectView') return;
			
			if ($scope.currentFolderType === MOBILE_BROWSER_INDEX_TRASHBOX) {
				mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, "삭제된 폴더는 열람할 수 없습니다.");
				
				return;
			}
			
			myScroll.scrollTo(0,0);
    		
    		if(folderSeq!="" && $scope.viewMode!='moveView'){
        		$scope.viewMode = 'folderView';
        	}else if($scope.viewMode!='moveView'){
        		$scope.viewMode = 'mainView';
        	}
			
			if (folderSeq.length > 0 && $scope.currentFolderType !== 0) {
				// 중요문서함에서 폴더 선택 시 MY ONEFFICE로 이동되도록 처리
				$scope.currentFolderType = MOBILE_BROWSER_INDEX_MY_FOLDER;
			}
			
        	$scope.getDataLoadDocumnet($scope.currentFolderType, folderSeq);
    	}catch(e){
    		dalert(e);
    	}
    };
    
    //검색 모드 전환
    $scope.changeSearchMode = function(bSearchMode) {
    	try {
    		if (bSearchMode) {
    			$scope.prevSerchMode = $scope.viewMode;
    			$scope.viewMode = 'searchView';
    			setFilterApply('');
    			dzeJ(".template_doc").hide();
				
    			setTimeout(function () {
    				var searchbox = dzeJ(".head_search").width();
        			var leftdiv = dzeJ(".left_div").outerWidth(true);
        			dzeJ(".head_search input").width(searchbox - leftdiv - 16);
					
        			$("#input_doc").focus().keydown(function(event) {
						if (event.keyCode === 13) {
							if (setFilterApply(this.value) !== false) {
								$(this).blur();
							}
							
							myScroll.refresh();
						}
					});
        			
        			myScroll.refresh();
    			}, 100);
	    	} else {
	    		$scope.maxView = defaultMaxViewSize;
				if ($scope.currentFolderSeq === "" && $scope.currentFolderType === MOBILE_BROWSER_INDEX_MY_FOLDER) {
					dzeJ(".template_doc").show();
				}
				
				$scope.viewMode = $scope.prevSerchMode;
				setFilterApply('');
				
				updateView($scope);
				
				setTimeout(function () {
					setDocItemHeight();
					$scope.onResizeProc();
					myScroll.refresh();
					
				}, 300);
				
//				setTimeout(function () {myScroll.refresh();}, 100);
			}
    		
			showQuickMenu();
    	}catch(e){
    		dalert(e);
    	}
    };
    
	$scope.searchMoreBtnClick = function(index) {
		try {
			var visible = false;
			var nIdx = index * 2;

			if($(".my_list").eq(nIdx).is(":visible")) {
				$(".my_list").eq(nIdx).slideUp();
				$(".my_list").eq(nIdx+1).slideUp();
				$('.search_more').eq(index).addClass("closed");
			} else {
				$(".my_list").eq(nIdx).slideDown();
				$(".my_list").eq(nIdx+1).slideDown();
				$('.search_more').eq(index).removeClass("closed");
			}
		} catch(e) {
			dalert(e);
		}
	};
    
    // 검색 데이터 체인지 이벤트 Apply data list
	var setFilterApply = function(txt) {
		try {
			$(".tit.ownsearch").hide();
			$(".tit.shareinsearch").hide();
			$(".tit.shareoutsearch").hide();
			
			if ((txt === '' || txt.length < 2) && $scope.viewMode == 'searchView') {
				$scope.fileCnt = 0;
    			$scope.folderCnt = 0;
    			$scope.resultDataList = [];
				$scope.resultShareInList = [];
				$scope.resultShareOutList = [];
    			$scope.searchComment = "검색어를 입력하세요.";
				$("#searchResult_nothing").show();
				
				updateView($scope);
				
				return false;
			}
			
			var _folderCnt = 0;
			var _fileCnt = 0;
			
			// 검색의 경우 필터가 아닌 API 사용해 통합 검색 되도록 수정
			// to do... 공유 검색 결과 UI가 추가되면 추가 작업 예정
			if ($scope.viewMode === 'searchView') {
				var bDoneMyDoc = false;
				var bDoneShare = false;
				
				$("#searchResult_nothing").hide();
				
				$scope.$parent.docDataFact.getSearchList(txt, "myoneffice").then(function(data) {
					$scope.resultDataList = data.ownSearchList;
					$scope.maxView = data.ownSearchList.length;
					for (var ix = 0; ix < $scope.resultDataList.length; ix++) {
						var resultObj = $scope.resultDataList[ix];
						if (resultObj) {
							if (resultObj.fileType > 0) {
								_fileCnt++;
							} else {
								_folderCnt++;
							}
						}
					}
					
					if ((_fileCnt + _folderCnt) > 0) {
						$(".tit.ownsearch").show();
						$(".tit.ownsearch")[0].childNodes[1].innerHTML = " (" + $scope.resultDataList.length + ")";
					}
					
					$scope.fileCnt = _fileCnt;
					$scope.folderCnt = _folderCnt;
					
					bDoneMyDoc = true;
				});
				
				$scope.$parent.docDataFact.getSearchList(txt, "share").then(function(data) {
					$scope.resultShareInList = [];
					$scope.resultShareOutList = [];
					
					for (var ix = 0; ix < data.shareSearchList.length; ix++) {
						var resultObj = data.shareSearchList[ix];
						
						if (resultObj) {
							if (data.shareSearchList[ix].userData.nOwnerID === $scope.myInfo.id && data.shareSearchList[ix].deleted != 1) {
								$scope.resultShareOutList.push(data.shareSearchList[ix]);
							} else if (data.shareSearchList[ix].userData.nOwnerID !== $scope.myInfo.id) {
								$scope.resultShareInList.push(data.shareSearchList[ix]);
							}
							
							if (resultObj.fileType > 0) {
								_fileCnt++;
							} else {
								_folderCnt++;
							}
						}
					}
					
					if ((_fileCnt + _folderCnt) > 0) {
						if($scope.resultShareInList.length > 0) {
							$(".tit.shareinsearch").show();
							$(".tit.shareinsearch")[0].childNodes[1].innerHTML = " (" + $scope.resultShareInList.length + ")";
						}
						
						if($scope.resultShareOutList.length > 0) {
							$(".tit.shareoutsearch").show();
							$(".tit.shareoutsearch")[0].childNodes[1].innerHTML = " (" + $scope.resultShareOutList.length + ")";
						}
					}
					
					$scope.fileCnt = _fileCnt;
					$scope.folderCnt = _folderCnt;
					
					bDoneShare = true;
				});
				
				var bDone = false;
				var objInterval = setInterval(function() {
					if (bDoneMyDoc === true && bDoneShare === true) {
						clearInterval(objInterval);
						objInterval = null;
						
						if (bDone === false) {
							bDone = true;
							
							updateSearchResult();
						}
					}
				});
				
				setTimeout(function() {
					if (objInterval !== null) {
						clearInterval(objInterval);
						updateSearchResult();
					}
				}, 5000);
				
				function updateSearchResult() {
					setTimeout(function () {
						setDocItemHeight();
						myScroll.refresh();
					}, 300);
					
					if (($scope.fileCnt + $scope.folderCnt) > 0) {
						$("#searchResult_nothing").hide();
					} else {
						$scope.searchComment = "검색어 결과가 없습니다.";
						$("#searchResult_nothing").show();
					}
					
					updateView($scope);
				}
			} else {
				$scope.resultDataList = $scope.documnetDataList;
				$scope.resultDataList = $filter('filter')($scope.documnetDataList, function (item) {
					return item.docData.strTitle.indexOf(txt) > -1;
				});
				
				for (var ix=0; ix<$scope.resultDataList.length; ix++) {
					var resultObj = $scope.resultDataList[ix];
					
					if (resultObj) {
						if (resultObj.fileType>0) {
							_fileCnt ++;
						} else {
							_folderCnt ++;
						}
					}
				}
				
				if (_fileCnt==0 && _folderCnt==0) {
					$scope.searchComment = "검색어 결과가 없습니다.";
				} else {
					$(".my_list").show();
				}
				
				$scope.fileCnt = _fileCnt;
				$scope.folderCnt = _folderCnt; 
			}
    	} catch (e) {
    		dalert(e);
    	}
    };
	
	// 템플릿 문서 리스트 보여주기
	$scope.showTemplate = function() {
		try {
			closeModal();
			
			$scope.$parent.currentViewPage = "one_template";
			
			updateView($scope);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.createTemplateFile = function(objTemplateInfo) {
		try {
			if (checkDoubleClick() === true) {
				return;
			}
			
			if ($scope.$parent.currentViewPage !== "one_home") {
				$scope.$parent.viewChange(0);
			}
			
			var strDate = new Date().toISOString().split("T")[0];
			strDate = strDate.replaceAll("-", "");
			strDate = strDate.substring(2);
			
			var strPaperMargin = objTemplateInfo.paperMargin.join(",") + ",10,12.5";
			var strOnePageMode = (objTemplateInfo.onePageMode === true) ? "true" : "false";
			var strPageOver = (objTemplateInfo.pageOver === true) ? "true" : "false";
			var strProperty = '<dze_doc_property class="dze_document_property" printmargin="' + strPaperMargin + '" papersize="210,297" pagecolor="#FFFFFF" watermarksrc="" dze_onepage_mode=' + strOnePageMode +' pgcontentsoverflowvisible=' + strPageOver + ' dze_hf_height="20,0,0,20,0,0"';
			
			if (objTemplateInfo.name === "회의록") {
				strProperty += (' temp_category=' + objTemplateInfo.name);
			}
			
			strProperty += '></dze_doc_property>';
			
			var strHtml = strProperty + objTemplateInfo.html;
			
			var objCreateInfo = {
				title: strDate + "_" + objTemplateInfo.name.replaceAll(" ", ""),
				contents: strHtml,
				folderSeq: $scope.currentFolderSeq,
				callBack: function(strDocSeq) {
					onefficeMGW.getFileContent(strDocSeq, function(objDocInfo) {
						$scope.$parent.bOnNewEditMode = true;
						openDocument($scope.$parent.docDataFact.convItem(objDocInfo));
					});
				}
			};
			
			createDocument(objCreateInfo);
		} catch (e) {
			dalert(e);
		}
	};
	
	//새문서 생성 
	$scope.createNewFile = function() {
		try {
			var objCreateInfo = {
				title: MOBILE_STRING_DEFAULT_FILE_NAME,
				contents: oneffice.emptyContent,
				folderSeq: $scope.currentFolderSeq,
				callBack: function(strDocSeq) {
					onefficeMGW.getFileContent(strDocSeq, function(objDocInfo) {
						$scope.$parent.bOnNewEditMode = true;
						openDocument($scope.$parent.docDataFact.convItem(objDocInfo));
					});
				}
			};
			
			createDocument(objCreateInfo);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.showInputDialog = function(type) {
		try {
			hideOverMenus();
			
			var nDialogType = mobileDlg.DIALOG_TYPE.INPUT_TEXT;
			
			var arrButtonInfo = [
				{
					name: "취소",
					func: function() {
						mobileDlg.hideDialog();
					}
				},
				{
					name: "확인",
					func: (type === "newFolder") ? function() {
						var strNewTitle = $('#dlg_text_input').val();
						
						onefficeMGW.checkCreateFolderName(strNewTitle, $scope.currentFolderSeq, function() {
							
							$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq);
							
//							$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "strTitle", strNewTitle);
//							
//							updateView($scope);
							
							mobileDlg.hideDialog();
						});
					}
					: function() {
						var strNewTitle = $('#dlg_text_input').val();
						
						onefficeMGW.checkRenameFile($scope.$parent.objCurrentDoc, strNewTitle, function() {
							$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "strTitle", strNewTitle);
							
							updateView($scope);
							
							mobileDlg.hideDialog();
						});
					}
				}
			];
			
			var strTitle;
			var strFileName;
			
			if (type === "newFolder") {
				strTitle = "새 폴더";
				
				onefficeMGW.checkFileName("제목없는 폴더", $scope.currentFolderSeq, false).then(function(nIndex) {
					strFileName = "제목없는 폴더" + ((fnObjectCheckNull(nIndex) === true || nIndex === 0) ? "" : ("(" + nIndex + ")"));
					
					mobileDlg.showDialog(nDialogType, strFileName, strTitle, arrButtonInfo);
				});
			} else {
				strTitle = "이름 바꾸기";
				strFileName = $scope.$parent.objCurrentDoc.docData.strTitle;
				
				mobileDlg.showDialog(nDialogType, strFileName, strTitle, arrButtonInfo);
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	//전체 선택 해제
	$scope.clearAllCheckItem = function() {
		try {
			var actionDiv = dzeJ(".action_div");
			actionDiv.removeClass("on");
			dzeJ(".cancelmodal").css("display", "none");
			
			for (var i = 0; i < $scope.$parent.docDataFact.list.length; i++) {
				$scope.$parent.docDataFact.list[i].docData.bChecked = false;
			}
			
			checkSelectList();
			
			showQuickMenu();
		} catch(e) {
			dalert(e);
		}
	};
	
	//문서 정렬
	var changeDocSortList = function(sortIndex) {
		try {
			if($scope.sortOption == sortIndex){
				$scope.sortAline = $scope.sortAline=='-'?'':'-';
				oneffice.sortInfo.sortAline[$scope.currentFolderType] = $scope.sortAline;
			}else{
				$scope.sortOption = sortIndex;
				oneffice.sortInfo.sortOption[$scope.currentFolderType] = $scope.sortOption;
			}
			selectSortCheck($scope.sortOption, $scope.sortAline);
			NextS.setValue({key: "userEnv", val: JSON.stringify({autoSave: oneffice.autoSave, timer: oneffice.autoSaveTime, viewMode:oneffice.bDocViewMode, sortInfo:oneffice.sortInfo})});
			updateView($scope);
			setDocItemHeight();
			closeModal(); 
		} catch(e) {
			dalert(e);
		}
	};
	
	//문서 이동 복사 모드
	$scope.changeSelectMoveMode = function(bMove) {
		if ($scope.$parent.docDataFact.getCheckList().length === 0) {
			return false;
		}
		
		if ($("#one_home .right_div .btn_move").hasClass("disabled") === true) {
			return false;
		}
		
		$scope.copySelectItems = [];
		$scope.viewMode = 'moveView';
		$scope.bMove = bMove;
		for(var ix=0; ix<$scope.documnetDataList.length; ix++){
			var _obj = $scope.documnetDataList[ix];
			if(_obj.docData.bChecked){
				_obj.docData.bTemp = true;
				$scope.copySelectItems.push(_obj);
			}
		}
		
		return true;
	};
	
	$scope.showTrashDialog = function(strType) {
		try {
			if ($scope.$parent.docDataFact.getCheckList().length === 0 && strType !="empty") {
				return;
			}
			
			if ($("#one_home .right_div .btn_del").hasClass("disabled") === true) {
				return;
			}
			
			hideOverMenus();
			
			if ((fnObjectCheckNull(strType) === true)) {
				strType = ($scope.currentFolderType === MOBILE_BROWSER_INDEX_TRASHBOX) ? "delete_in_trash" : "delete_file";
			}
			
			var nDialogType = mobileDlg.DIALOG_TYPE.CONFIRM;
			var strTitle;
			var strMessage;
			var fnConfirm;
			
			switch (strType) {
				case "delete_file":
					strTitle = "삭제";
					strMessage = "{0}개의 문서를 삭제하시겠습니까?";
					
					var nSelectionType = onefficeMGW.getContainsImportantShareInList($scope.$parent.docDataFact.checklist);
					
					switch (nSelectionType) {
						case 0:		strMessage = "{0}개의 문서를 삭제하시겠습니까?";	break;
						case 1:		strMessage = "중요 문서가 포함되어 있습니다.<br/>" + strMessage;	break;
						case 2:		strMessage = "중요 문서 입니다.<br/>" + strMessage;	break;
						case 3:		strMessage = "공유 문서가 포함되어 있습니다.<br/>" + strMessage;	break;
						case 4:		strMessage = "공유 문서 입니다.<br/>" + strMessage;	break;
						case 5:		strMessage = "중요 문서와 공유 문서가 포함되어 있습니다.<br/>" + strMessage;	break;
							
						case 6:		strMessage = "폴더 삭제 시 내부 파일도 모두 삭제됩니다.<br/>삭제하시겠습니까?";	break;
						case 7:		strMessage = "폴더 삭제 시 내부 파일도 모두 삭제됩니다.<br/>선택 된 항목들을 삭제하시겠습니까?";	break;
							
						default:	strMessage = "레알 삭제 고고?";	break;
					}
					
					if (nSelectionType < 6) {
						strMessage = String.format(strMessage, $scope.$parent.docDataFact.checklist.length);
					}
					
					fnConfirm = function() {
						var nSuccess = 0;
						var nFailed = 0;
						var objFileInfo;
						var nTotal = $scope.$parent.docDataFact.checklist.length;
						var nDeleteStatus = 0;		// 1: 문서만, 2: 폴더만
						
						var fnSuccess = function() {
							nSuccess++;
							
							if ((nSuccess + nFailed) === nTotal) {
								var strMsg;
								var strMsgOption;
								
								if (nDeleteStatus === 1) {
									strMsgOption = "문서";
								} else if (nDeleteStatus === 2) {
									strMsgOption = "폴더";
								} else if (nDeleteStatus === 3) {
									strMsgOption = "폴더와 문서";
								}
								
								if (nFailed > 0) {
									strMsg = "{0}개의 {1}를 삭제 실패하였습니다.";
									strMsg = String.format(strMsg, nFailed, strMsgOption);
									
									mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, strMsg);
								} else {
									strMsg = "{0}개의 {1}를 삭제하였습니다.";
									strMsg = String.format(strMsg, nSuccess, strMsgOption);
									
									mobileToast.show(strMsg);
								}
								
								if ($scope.viewMode === "selectView") {
									$scope.closeCurrentMode();
								}
								
								$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq);
							}
						};
						
						var fnFailed = function() {
							nFailed++;
							
							if ((nSuccess + nFailed) === nTotal) {
								var strMsgOption;
								
								if (nDeleteStatus === 1) {
									strMsgOption = "문서";
								} else if (nDeleteStatus === 2) {
									strMsgOption = "폴더";
								} else if (nDeleteStatus === 3) {
									strMsgOption = "폴더와 문서";
								}
								
								mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, String.format("{0}개의 {1}를 삭제 실패하였습니다.", nFailed, strMsgOption));
								
								if ($scope.viewMode === "selectView") {
									$scope.closeCurrentMode();
								}
								
								$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq);
							}
						};
						
						for (var index = 0; index < nTotal; index++) {
							objFileInfo = $scope.$parent.docDataFact.checklist[index];
							
							if (objFileInfo.fileType * 1 === 0) {		// 폴더
								nDeleteStatus |= 2;
								
								onefficeMGW.deleteFolder(objFileInfo.seq, fnSuccess, fnFailed);
							} else {		// 문서
								nDeleteStatus |= 1;
								
								onefficeMGW.deleteFile(objFileInfo.seq, fnSuccess, fnFailed);
							}
						}
						
						mobileDlg.hideDialog();
					};
					
					break;
					
				case "delete_in_trash":
					strTitle = "영구 삭제";
					strMessage = "정말 삭제하시겠습니까?";
					
					fnConfirm = function() {
						var nSuccess = 0;
						var nFailed = 0;
						var nTotal = $scope.$parent.docDataFact.checklist.length;
						
						var fnCallback = function(objResponse) {
							if (objResponse.result == "success") {
								nSuccess++;
							} else {
								nFailed++;
							}
							
							if ((nSuccess + nFailed) === nTotal) {
								var strMessage;
								
								if (nFailed === nTotal) {
									strMessage = (nTotal === 1) ? "삭제에 실패했습니다." : "전체 삭제에 실패했습니다.";
								} else if (nFailed > 0) {
									strMessage = "일부 삭제에 실패했습니다.";
								} else {
									strMessage = (nTotal === 1) ? "삭제되었습니다." : "전부 삭제되었습니다.";
								}
								
								mobileToast.show(strMessage);
								
								if ($scope.viewMode === "selectView") {
									$scope.closeCurrentMode();
								}
								
								$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq);
							}
						};
						
						for (var index = 0; index < nTotal; index++) {
							onefficeMGW.deleteTrashDocument($scope.$parent.docDataFact.checklist[index].seq, fnCallback);
						}
						
						mobileDlg.hideDialog();
					};
					
					break;
					
				case "empty":
					strTitle = "휴지통 비우기";
					strMessage = "정말 삭제하시겠습니까?";
					
					fnConfirm = function() {
						onefficeMGW.emptyTrashbox(function(objResponse) {
							if (objResponse.result == "success") {
								mobileToast.show("휴지통이 비워졌습니다.");
								
								$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq);
							}
							
							mobileDlg.hideDialog();
						});
					};
					
					break;
					
				case "restore":
					strTitle = "복원";
					strMessage = "복원 하시겠습니까?";
					
					fnConfirm = function() {
						var nSuccess = 0;
						var nFailed = 0;
						var nTotal = $scope.$parent.docDataFact.checklist.length;
						
						var fnCallback = function(objResponse) {
							if (objResponse.result == "success") {
								nSuccess++;
							} else {
								nFailed++;
							}
							
							if ((nSuccess + nFailed) === nTotal) {
								var strMessage;
								
								if (nFailed === nTotal) {
									strMessage = (nTotal === 1) ? "복구에 실패했습니다." : "전체 복구에 실패했습니다.";
								} else if (nFailed > 0) {
									strMessage = "일부 복구에 실패했습니다.";
								} else {
									strMessage = (nTotal === 1) ? "복구되었습니다." : "전부 복구되었습니다.";
								}
								
								mobileToast.show(strMessage);
								
								if ($scope.viewMode === "selectView") {
									$scope.closeCurrentMode();
								}
								
								$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq);
							}
						};
						
						for (var index = 0; index < nTotal; index++) {
							onefficeMGW.recoverDeletedDocument($scope.$parent.docDataFact.checklist[index].seq, fnCallback);
						}
						
						mobileDlg.hideDialog();
					};
					
					break;
			}
			
			var arrButtonInfo = [
				{
					name: "취소",
					func: function() {
						mobileDlg.hideDialog();
					}
				},
				{
					name: (strType === "restore") ? "복원" : "삭제",
					func: fnConfirm
				}
			];
			
			mobileDlg.showDialog(nDialogType, strMessage, strTitle, arrButtonInfo);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.openDocument = function(item) {
		try {
			if ($scope.viewMode=='selectView') return;
			
			if (event.target.classList.contains("btn_more") === true) {
				return;
			}
			
			if ($scope.currentFolderType === MOBILE_BROWSER_INDEX_TRASHBOX) {
				mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, "삭제된 문서는 열람할 수 없습니다.");
				return;
			}
			
			item.docData.bChecked = true;
			
			openDocument(item);
		} catch (e) {
			dalert(e);
		}
	};
	
	var share = function(nShareType, strPermission, strShareId) {
		try {
			var fnCallback;
			
			if (nShareType === MOBILE_SHARE_OPEN_LINK) {
				if ((strPermission === "R" && $(".m_link_view").hasClass("chk") === true)
						|| (strPermission === "W" && $(".m_link_edit").hasClass("chk") === true)) {
					return;
				}
				
				fnCallback = function(strSeq) {
					if (strPermission === "R" && $(".m_link_view").hasClass("chk") === false) {
						$(".m_link_view").addClass("chk");
						$(".m_link_edit").removeClass("chk");
					} else if (strPermission === "W" && $(".m_link_edit").hasClass("chk") === false) {
						$(".m_link_edit").addClass("chk");
						$(".m_link_view").removeClass("chk");
					}
					
					$scope.$parent.docDataFact.updateDocShareInfo(strSeq);
				};
				
				strShareId = "";
				
				$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "nShareCount", ($scope.$parent.objCurrentDoc.nShareCount + 1));
				updateView($scope);
			}
			
			onefficeMGW.shareDocument($scope.$parent.objCurrentDoc.seq, nShareType, strShareId, strPermission, fnCallback);
		} catch (e) {
			dalert(e);
		}
	};
	
	var unShare = function(nShareType, strShareId) {
		try {
			var fnCallback;
			
			if (nShareType === MOBILE_SHARE_OPEN_LINK) {
				fnCallback = function(strSeq) {
					$(".m_link_view").removeClass("chk");
					$(".m_link_edit").removeClass("chk");
					
					$scope.$parent.docDataFact.updateDocShareInfo(strSeq);
				};
				
				strShareId = "";
				
				$scope.$parent.docDataFact.updateDocStatus($scope.$parent.objCurrentDoc.seq, "nShareCount", ($scope.$parent.objCurrentDoc.nShareCount - 1));
				updateView($scope);
			}
			
			onefficeMGW.unshareDocument($scope.$parent.objCurrentDoc.seq, nShareType, strShareId, fnCallback);
		} catch (e) {
			dalert(e);
		}
	};
	
	var jumpActionSheet = function(strHTML_From, strHTML_To, bGoDown) {
		try {
			var objActionSheet = $(".action_div").css("visibility", "hidden");
			
			objActionSheet.find(".menu_container")[0].innerHTML = strHTML_To;
			
			var nNewHeight = objActionSheet[0].offsetHeight;
			
			objActionSheet.find(".menu_container")[0].innerHTML = strHTML_From;
			
			objActionSheet.css("visibility", "");
			
			objActionSheet.animate({height: nNewHeight}, "fast", function() {
				setTimeout(function() {
					objActionSheet.find(".menu_container")[0].innerHTML = strHTML_To;
					
					objActionSheet.css("height", "");
					
					var nDisplayCount = 1;
					
					$(".action_div .ac").on('click', function() {
						moreItemClick(this.getAttribute("menuIndex"));
					}).each(function(index, item) {
						if (item.style.display !== "none") {
							if (bGoDown === true) {
								// 오른쪽에서 왼쪽으로 채워짐
								$(item).css({position: "relative", left: objActionSheet[0].offsetWidth});
								
								setTimeout(function() {
									$(item).animate({left: ("-=" + objActionSheet[0].offsetWidth + "px")}, "fast", function() {
										$(item).css({position: "", left: ""});
									});
								}, nDisplayCount * 30);
								
								nDisplayCount++;
							} else {
								// 왼쪽에서 오른쪽으로 채워짐
								$(item).css({position: "relative", left: -objActionSheet[0].offsetWidth});
								
								setTimeout(function() {
									$(item).animate({left: ("+=" + objActionSheet[0].offsetWidth + "px")}, "fast", function() {
										$(item).css({position: "", left: ""});
									});
								}, nDisplayCount * 30);
								
								nDisplayCount++;
							}
						}	
					});
					
					setTimeout(function() {
						actionSheetScroll.refresh();
					}, 300);
				}, 200);
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.execCopyMoveCommand = function (){
		
		if($scope.bMove){
			checkCopyListTo($scope.copySelectItems,$scope.currentFolderSeq,true,function(){
				$scope.closeCurrentMode();
			})
		}else{
			checkCopyListTo($scope.copySelectItems,$scope.currentFolderSeq,false,function(){
				$scope.closeCurrentMode();
			})
		}
	};
	
	$scope.onResizeProc = function() {
		
		setTimeout(function () {
			$("#idx_doc_iscroll" ).height($(window).height()-56);
		}, 1);
		
		setTimeout(function () {myScroll.refresh(); menuScroll.refresh(); window.scrollTo(0,-1);}, 300);
		
		var objContainer = $("#id_template_doc_scroll");
		var objTemplateList = objContainer.find("li").css("visibility", "hidden");
		var nWindowWidth = $(window).width();
		
		if (objTemplateList.length > 0) {
			var nThumbWidth;
			var nMargin;
			var nTotal = 0;
			
			if (nWindowWidth >= 712) {
				if (nWindowWidth >= 1024) {
					nThumbWidth = ((nWindowWidth - 100) / 5 - 10);
				} else {
					nThumbWidth = ((nWindowWidth - 60) / 5 - 10);
				}
				
				nMargin = 10;		// margin-left + margin-right
				objTemplateList.width(nThumbWidth);
			} else {
				objTemplateList.width("");
				nThumbWidth = objTemplateList.width();
				if(!nThumbWidth || nThumbWidth===""){
					nThumbWidth = $(".template_doc li .thumb").width();
				}
				nMargin = 8;		// margin-left + margin-right
			}
			
			nTotal = objTemplateList.length * (nThumbWidth + nMargin) + 5;
			
			objContainer.find("ul").css({
				width: nTotal,
				position: "relative"
			});
			
			objTemplateList.css("visibility", "");
			
			setTimeout(function() {
				templateScroll.refresh();
				templateScroll.scrollTo(0, 0);
			}, 100);
			
			if (nTotal < $(window).width()) {
				templateScroll.disable();
			} else {
				templateScroll.enable();
			}
		}
		
		// 썸네일 가로 크기에 따라 높이값 설정
		setDocItemHeight();
		
		// 왼쪽 사이드 메뉴 스크롤 여부 설정
		if ($("#idx_menu_iscroll").height() >= $("#idx_menu_iscroll ul").height()) {
			menuScroll.disable();
		} else {
			menuScroll.enable();
		}
	};
	
	$scope.getThumnailImg = function(doc){
		var resPath = "../mobile/images/ico/icon_thumb_file_oneffice.png";
		
		if (doc.docData.strThumbnail.length === 0
				|| fnObjectCheckNull(mobile_http.hybridBaseData) === true) {
			return resPath;
		}
		
		return ( mobile_http.getProtocolUrl("P018")+"?seq="+doc.docData.strThumbnail+"&pathSeq=1600&token="+mobile_http.hybridBaseData.header.token);
		//return ('http://' + mobile_http.hybridBaseData.result.compDomain + '/upload/onefficeFile/' + $scope.myInfo.id + '/' + doc.seq + '/' + doc.docData.strThumbnail);
	};
	
	$scope.moveBack = function() {
		try {
			if (mobileDlg.isShow() === true) {
				return;
			}
			
			if ($("#home_quick .quick_modal").css("display") !== "none") {
				$(".quick_menu").trigger("click");
				
				return;
			}
			
			var objActionSheet = $("#id_actionsheet_scroll.action_div");
			
			if (objActionSheet.hasClass("on") === true) {
				objActionSheet.removeClass("on");
				closeModal();
				
				return;
			}
			
			if (nRefresh === 2) {
				return;
			}
			
			if ($("#one_home article.side").hasClass("on") === true) {
				$(".modal").trigger("click");
				
				return;
			}
			
			switch ($scope.viewMode) {
				case "selectView":
				case "moveView":	$scope.closeCurrentMode();				return;
				case "searchView":	$scope.changeSearchMode(false);			return;
				case "folderView":	$scope.moveFolderFunc($scope.parentFolderSeq);	return;
			}
			
			if (g_browserCHK.iOS !== true) {
				mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.CONFIRM, "앱을 종료하시겠습니까?", "알림", [
					{
						name: "취소",
						func: function() {
							mobileDlg.hideDialog();
						}
					},
					{
						name: "확인",
						func: function() {
							NextS.exitApp();
						}
					}
				]);
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.doRefresh = function(fnCallback, bShowLoading) {
		try {
			$scope.getDataLoadDocumnet($scope.currentFolderType, $scope.currentFolderSeq, fnCallback, bShowLoading);
			
			templateScroll.refresh();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.filterDocFile = function(doc){
		try {
			if(doc.fileType==1) return true;
			else return false;
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.updateCommentCount = function(doc){
		try {
			if(objOnefficeLoader.m_bHybrid){
				docDataFact.updateCommentCount(doc);
			}
		} catch (e) {
			dalert(e);
		}
	}
	
	$scope.commentCountVisible = function(doc){
		try {
			if(doc.nCommentCounts>0){
				return { display: '' };
			}else{
				return { display: 'none' };
			}
		} catch (e) {
			dalert(e);
		}
	}
	
	$scope.elipsisTitle = function(txt){
		try{
			var fontSize = parseInt($('.doc_btm .txt').css('font-size'));
			var totalByteChar = calByte.getByteLength(txt);
			var ndocWidth = $('.doc_btm').width();
			var maxChar = Math.round(ndocWidth/fontSize);
			if(totalByteChar<=maxChar*2){
				return txt
			}else{
				var _first = calByte.cutByteLength(txt,maxChar);
				var _etcText = txt.substr(_first,txt.length)
				var _last = calByte.cutByteBackLength(_etcText,maxChar);
				return txt.substr(0,_first) + '...' + _etcText.substr(_etcText.length-_last, _etcText.length)
			}
			
		}catch(e){
			
		}
	}
		
});
