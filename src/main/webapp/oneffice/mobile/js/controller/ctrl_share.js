/*
 * 
 */

onefficeApp.controller("ctrl_share", function($scope) {
	
	var objSelectScroll;
	var objBodyScroll;
	var objSearchListScroll;
	var objViewerScroll;
	var objEditorScroll;
	
	var bStatusChanged = false;
	var objDragUser = null;
	var nDragStatus = 0;		// 0: none,		1: dragging
	
	$scope.searchList;
	$scope.selectList;
	$scope.arrViewer;
	$scope.arrEditor;
	$scope.arrShareUserList;
	$scope.bOpenLink = false;
	$scope.bShareSetting = true;
	
	
	var getObjShareInfo = function(strId, nType, strName, strEmName, strPath, strPic, strLoginId, strRank) {
		if (strPic === null) {
			strPic = "../mobile/images/bg/img-profile-";
			
			strPic += (nType === MOBILE_SHARE_USER) ? "none-0" : "group-0";
			
			strPic += (Math.floor(Math.random() * 5) + 1) + ".png";
		}
		
		return {
			id: strId,
			type: nType,
			name: strName,
			em_name: (strEmName !== null) ? strEmName : strName,
			path: strPath,
			pic: strPic, 
			login_id: strLoginId,		// email 전송 시 필요 데이터
			rank: strRank		// 직급
		};
	};
	
	$scope.initShare = function() {
		try {
			if ($scope.$parent.objCurrentDoc.userData.nOwnerID.length === 0
					|| $scope.myInfo.id === $scope.$parent.objCurrentDoc.userData.nOwnerID) {
				$scope.bShareSetting = true;
			} else {
				$scope.bShareSetting = false;
			}
			
			if ($scope.bShareSetting === false) {
				if ($scope.$parent.objCurrentDoc.shareData[0].nShareType === MOBILE_SHARE_OPEN_LINK) {
					$scope.bOpenLink = true;
				} else {
					$scope.bOpenLink = false;
				}
			}
			
			var objShare = $("#one_share");
			
			objShare.trigger("create");
			objShare.addClass("ui-page ui-page-theme-a").css({background: "#fff", "z-index": 101});
			
			var objSection = objShare.find(($scope.bShareSetting === true) ? "#id_body_scroll" : "#id_sharelist_scroll");
			var nBodyHeight;
			
			if ($scope.bShareSetting === true) {
				objShare.find("#id_select_scroll").css("width", "calc(100% - 23px)");
				
				nBodyHeight = "calc(100% - " + (56 + 67 + parseInt(objSection.css("padding-top"), 10) + parseInt(objSection.css("padding-bottom"), 10)) + "px)";
				
				var objMessageBox = objShare.find(".messageSend");
				objMessageBox.width("calc(100% - " + (parseInt(objMessageBox.css("padding-left"), 10) + parseInt(objMessageBox.css("padding-right"), 10)) + "px)");
				
				
				objSelectScroll = new iScroll('id_select_scroll', {"hScroll":true, "hScrollbar":false, "vScroll":false, "mousewheel":false,
					"onBeforeScrollStart": function(event) {
						// input 영역 클릭 이벤트 안먹는 현상 때문에 onBeforeScrollStart 함수 재정의
						if (event.target.nodeName !== "INPUT") {
							event.preventDefault();
						}
					}});
			
				$(".userSearch .searchField").css("position", "relative");
				
				objBodyScroll = new iScroll('id_body_scroll', {"hScroll":false, "vScroll":true, "vScrollbar":false, "mousewheel":false,
					"onBeforeScrollStart": function(event) {
						// textarea 영역 클릭 이벤트 안먹는 현상 때문에 onBeforeScrollStart 함수 재정의
					}});
				
				objSearchListScroll = new iScroll('id_searchlist_scroll', {"hScroll":false, "vScroll":true, "vScrollbar":false, "mousewheel":false});
				objViewerScroll = new iScroll('id_viewer_scroll', {"hScroll":true, "hScrollbar":false, "vScroll":false, "mousewheel":false});
				objEditorScroll = new iScroll('id_editor_scroll', {"hScroll":true, "hScrollbar":false, "vScroll":false, "mousewheel":false});
			} else {
				nBodyHeight = "calc(100% - " + (56 + parseInt(objSection.css("padding-top"), 10) + parseInt(objSection.css("padding-bottom"), 10)) + "px)";
				
				objBodyScroll = new iScroll('id_sharelist_scroll', {"hScroll":false, "vScroll":true, "vScrollbar":false, "mousewheel":false});
			}
			
			objSection.height(nBodyHeight);
			
			setTimeout(function() {
				objShare.find(".nodata").height(objSection.height());
			}, 100);
			
			addListener();
			$scope.initValues(true);
			$scope.$parent.viewChange(2);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.initValues = function(bFirst) {
		try {
			bStatusChanged = false;
			
			$("div.dialog_layer_wrap").show();
			
			if ($scope.bShareSetting === true) {
				// 검색 관련 데이터 초기화
				$(".userSearch input").val("").attr('placeholder', "공유할 사용자 검색");
				
				$scope.searchList = [];
				$scope.selectList = [];
				
				$(".userSearch .writeField").css({width: "calc(100% - 7px)", "max-width": "calc(100% - 7px)"});
				
				if ($(".userSearch input").length > 0) {
					objSelectScroll.scrollToElement($(".userSearch input")[0]);
				}
				
				$("#id_searchlist_scroll").hide();
				
				// 권한설정, 메세지 관련 데이터 초기화
				var objSet = $("div.authority .set li.checkbg");
				var objMsg = $("div.authority .message li.checkbg");
				
				objSet.removeClass("on");
				objSet.find("span.check").removeClass("on");
				objSet.first().addClass("on");
				objSet.first().find("span.check").addClass("on");
				
				objMsg.removeClass("on");
				objMsg.find("span.check").removeClass("on");
				objMsg.first().addClass("on");
				objMsg.first().find("span.check").addClass("on");
				
				var objMsgBox = $("div.authority .messageSend");
				objMsgBox.val("").show().data("before_height", objMsgBox.outerHeight());
			}
			
			// 공유중인 사용자 정보 초기화
			getSharedUserList();
			
			updateView($scope);
			
			setTimeout(function() {
				objBodyScroll.refresh();
			}, 300);
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.moveBack = function() {
		try {
			if (mobileDlg.isShow() === true) {
				return;
			}
			
			if ($("#id_searchlist_scroll").css("display") !== "none") {
				$scope.clearSearchList();
				
				return;
			}
			
			$scope.cancelSetting();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.cancelSetting = function() {
		try {
			if ($scope.$parent.bOnViewStatus == true) {
				$scope.$parent.viewChange(3);
			} else {
				$scope.$parent.viewChange(0);
			}
			
			$("div.dialog_layer_wrap").hide();
		} catch (e) {
			dalert(e);
		}
	};
	
	var addListener = function() {
		try {
			if ($scope.bShareSetting === true) {
				$(".userSearch input").click(function() {
					$(".userSearch .selectField").removeClass("check");
					$(".userSearch .selectField img.del").hide();
					$(".userSearch .selectField img.pic").show();

					setTimeout(function() {
						objBodyScroll.refresh();
					}, 300);
				}).keydown(function(event) {
					if (event.keyCode === 13 && $(".userShare .listUser").css("display") === "none") {
						// ID_KEYCODE_ENTER
						$scope.searchUser(this.value);
					}
				}).on("search", function() {
					// clear button
					setTimeout(function() {
						$scope.searchUser($(".userSearch input").val());
					}, 10);
				});
			}
			
			var objSet = $("div.authority .set li.checkbg");
			var objMsg = $("div.authority .message li.checkbg");
			var objSetCheck = objSet.find("span.check");
			var objMsgCheck = objMsg.find("span.check");
			var objMsgBox = $("div.authority .messageSend");
			
			objSet.click(function() {
				objSet.removeClass("on");
				objSetCheck.removeClass("on");
				
				$(this).addClass("on");
				$(this).find("span.check").addClass("on");
			});
			
			objMsg.click(function() {
				objMsg.removeClass("on");
				objMsgCheck.removeClass("on");
				
				$(this).addClass("on");
				$(this).find("span.check").addClass("on");
				
				if ($(this).find("span.img.icon-msgnone").length === 0) {
					objMsgBox.slideDown("false", function() {
						objMsgBox.focus();
					});
				} else {
					objMsgBox.slideUp("false");
				}
				
				updateView($scope);
				
				setTimeout(function() {
					objBodyScroll.refresh();
				}, 300);
			});
			
			objMsgBox.on("keypress keyup", function() {
				if (objMsgBox.outerHeight() !== objMsgBox.data("before_height")) {
					objMsgBox.data("before_height", objMsgBox.outerHeight());
					
					setTimeout(function() {
						objBodyScroll.refresh();
					}, 300);
				}
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	var addDeleteListener = function() {
		try {
			$(".editShare p.del").off("click").click(function() {
				if (checkDoubleClick() === true) {
					return;
				}
				
				var bIsEditor = ($(this).parents(".editor").length !== 0);
				
				$scope.unShare(this.getAttribute("share_type"), this.getAttribute("share_id"), $(this).next().text(), (bIsEditor === true) ? "W" : "R");
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	var addDragEventListener = function() {
		try {
			dzeJ("#one_share .editShare li").draggable({
				cursorAt: {bottom: 1},
//				revert: true,
//				revertDuration: 200,
				delay: 400,		// docDataFact.js의 touchstart에서 delay 보다 늦게 움직이도록 설정해줘야 함
				opacity: 0.5,
				zIndex: 9999,
				containment: $("#one_share .editShare"),
				helper: function() {
					return $(this).clone().attr("id", "id_drag_helper").appendTo("#one_share .editShare");
				},
				start: function() {
					if (objDragUser === null) {
						dzeJ(this).draggable("cancel");
						$("#id_drag_helper").hide();
						
						return;
					}
					
					nDragStatus = 1;
					dzeJ(this).css("visibility", "hidden");
				},
				stop: function(event, ui) {
					var objItem = dzeJ(this);
					
					if (objDragUser === null) {
						objItem.draggable("cancel");
						
						return;
					}
					
					checkPosition(objItem, ui).then(function(bResult) {
						if (bResult === false) {
							objItem.css({opacity: "", visibility: ""});
							objItem.find("img").css("box-shadow", "");
							objItem.find(".del").show();
						} else {
							addDeleteListener();
						}
						
						changeDragMode();
						nDragStatus = 0;
					});
				},
				drag: function() {
					if (objDragUser === null) {
						dzeJ(this).draggable("cancel");
						
						return;
					}
				}
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.onLongPress = function(objUser, $event) {
		try {
			changeDragMode(objUser);
			
			// 롱클릭 객체에 선택효과 적용
			var objItem = $($event.currentTarget);
			objItem.css("opacity", 0.5);
			objItem.find("img").css("box-shadow", "0px 0px 10px 0px black");
			objItem.find(".del").hide();
		} catch (e) {
			dalert(e);
		}
	};
	
	var changeDragMode = function(objUser) {
		try {
			if (fnObjectCheckNull(objUser) === false) {
				objDragUser = objUser;
				
				objBodyScroll.disable();
				objViewerScroll.disable();
				objEditorScroll.disable();
			} else {
				objDragUser = null;
				
				objBodyScroll.enable();
				objViewerScroll.enable();
				objEditorScroll.enable();
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.release = function($event) {
		try {
			if (objDragUser !== null && nDragStatus === 0) {
				var objItem = $($event.currentTarget);
				
				objItem.css({opacity: "", visibility: ""});
				objItem.find("img").css("box-shadow", "");
				objItem.find(".del").show();
				
				changeDragMode();
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var getSharedUserList = function() {
		try {
			$scope.arrViewer = [];
			$scope.arrEditor = [];
			$scope.arrShareUserList = [];
			
			var arrShareInfo = $scope.$parent.objCurrentDoc.shareData.slice();
			
			if (arrShareInfo.length === 1 && arrShareInfo[0].nShareType === MOBILE_SHARE_OPEN_LINK) {
				return;
			}
			
			if (arrShareInfo.length > 0) {
				$("#one_share .modal").show();
				
				sortShareUser(arrShareInfo, function() {
					try {
						var objInterval = setInterval(function() {
							if ($scope.$$phase !== "$apply" && $scope.$$phase !== "$digest") {
								updateView($scope);
								
								if ($scope.bShareSetting === true) {
									objViewerScroll.refresh();
									objEditorScroll.refresh();
									
									addDeleteListener();
									addDragEventListener();
								} else {
									objBodyScroll.refresh();
								}
								
								clearInterval(objInterval);
							}
						}, 50);
					} catch (e) {
						dalert(e);
					} finally {
						$("#one_share .modal").hide();
					}
				});
			}
			
			// test code
//			$scope.arrShareUserList.push(getObjShareInfo("707010012173", MOBILE_SHARE_USER, "이수길", null, "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원", "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg", "sokm83"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010014418", MOBILE_SHARE_USER, "아이유", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg", "ohk0307"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010014804", MOBILE_SHARE_USER, "정준영", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.chosun.com/sitedata/image/201610/06/2016100602363_0.jpg", "ohk0308"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010011234", MOBILE_SHARE_USER, "정지영", null, "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원", "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg", "ohk0309"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010012345", MOBILE_SHARE_USER, "곽윤우", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg", "ohk0306"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010013456", MOBILE_SHARE_USER, "윤성준", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.chosun.com/sitedata/image/201610/06/2016100602363_0.jpg", "ohk0305"));
//			
//			$scope.arrShareUserList.push(getObjShareInfo("707010010987", MOBILE_SHARE_USER, "김현철", null, "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원", "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg", "ohk0107"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010019876", MOBILE_SHARE_USER, "하성수", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg", "ohk0207"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010018765", MOBILE_SHARE_USER, "정민영", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.chosun.com/sitedata/image/201610/06/2016100602363_0.jpg", "ohk0407"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010017654", MOBILE_SHARE_USER, "김효현", null, "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원", "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg", "ohk0507"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010016543", MOBILE_SHARE_USER, "배산하", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg", "ohk0607"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010015432", MOBILE_SHARE_USER, "박진형", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.chosun.com/sitedata/image/201610/06/2016100602363_0.jpg", "ohk0707"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010010987", MOBILE_SHARE_USER, "김현철", null, "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원", "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg", "ohk0107"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010019876", MOBILE_SHARE_USER, "하성수", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg", "ohk0207"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010018765", MOBILE_SHARE_USER, "정민영", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.chosun.com/sitedata/image/201610/06/2016100602363_0.jpg", "ohk0407"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010017654", MOBILE_SHARE_USER, "김효현", null, "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원", "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg", "ohk0507"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010016543", MOBILE_SHARE_USER, "배산하", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg", "ohk0607"));
//			$scope.arrShareUserList.push(getObjShareInfo("707010015432", MOBILE_SHARE_USER, "박진형", null, "더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털", "http://image.chosun.com/sitedata/image/201610/06/2016100602363_0.jpg", "ohk0707"));
//			
//			if ($scope.bShareSetting === true) {
//				setTimeout(function() {
//					objViewerScroll.refresh();
//					objEditorScroll.refresh();
//					
//					addDragEventListener();
//				}, 100);
//			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var sortShareUser = function(arrShareInfo, fnCallback) {
		try {
			if (arrShareInfo.length === 0) {
				return fnCallback();
			}
			
			var objInfo = arrShareInfo.shift();
			
			if (objInfo.nShareType === MOBILE_SHARE_USER) {
				onefficeMGW.getSearchUserInfoList(CLOUD_CONST_SEARCH_USER_INFO_OPTION_USER_SEQ, objInfo.nShareID, function(objData) {
					objShareInfo = getObjShareInfo(objData[0].id, objInfo.nShareType, objData[0].name, null, objData[0].path_name, getImagePath(objData[0].pic), objData[0].login_id, objData[0].duty_name);
					
					if ($scope.bShareSetting === true) {
						if (objInfo.cSharePermission === "R") {
							$scope.arrViewer.push(objShareInfo);
						} else if (objInfo.cSharePermission === "W") {
							$scope.arrEditor.push(objShareInfo);
						}
					} else {
						$scope.arrShareUserList.push(objShareInfo);
					}
					
					sortShareUser(arrShareInfo, fnCallback);
				});
			} else if (objInfo.nShareType === MOBILE_SHARE_GROUP) {
				objShareInfo = getObjShareInfo(objInfo.nShareID, objInfo.nShareType, objInfo.strName, null, null, null, null, null);
				
				if ($scope.bShareSetting === true) {
					if (objInfo.cSharePermission === "R") {
						$scope.arrViewer.push(objShareInfo);
					} else if (objInfo.cSharePermission === "W") {
						$scope.arrEditor.push(objShareInfo);
					}
				} else {
					$scope.arrShareUserList.push(objShareInfo);
				}
				
				sortShareUser(arrShareInfo, fnCallback);
			} else if (objInfo.nShareType === MOBILE_SHARE_OPEN_LINK) {
				sortShareUser(arrShareInfo, fnCallback);
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var checkPosition = function(objItem, objUi) {
		try {
			return new Promise(function(resolve, reject) {
				var nDistance = null;
				var bIsViewer = objItem.hasClass("viewer") === true;
				
				if (bIsViewer === true) {
					nDistance = objUi.position.top - objUi.originalPosition.top;
				} else {
					nDistance = objUi.originalPosition.top - objUi.position.top;
				}
				
				if (nDistance !== null && 78 < nDistance && nDistance < 120) {
					updateSharedUserList(!bIsViewer).then(function(bResult) {
						resolve(bResult);
					});
				} else {
					resolve(false);
				}
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	var updateSharedUserList = function(bAddViewer) {
		try {
			return new Promise(function(resolve, reject) {
				onefficeMGW.shareDocument($scope.$parent.objCurrentDoc.seq, objDragUser.type, objDragUser.id, (bAddViewer === true) ? "R" : "W", function() {
					if (bAddViewer === true) {
						$scope.arrViewer.push(objDragUser);
						$scope.arrEditor.splice($scope.arrEditor.indexOf(objDragUser), 1);
					} else {
						$scope.arrEditor.push(objDragUser);
						$scope.arrViewer.splice($scope.arrViewer.indexOf(objDragUser), 1);
					}
					
					updateView($scope);
					objViewerScroll.refresh();
					objEditorScroll.refresh();
					
					if (bAddViewer === true) {
						objViewerScroll.scrollTo(objViewerScroll.scrollerW, 0, 0, "back");
					} else {
						objEditorScroll.scrollTo(objEditorScroll.scrollerW, 0, 0, "back");
					}
					
					addDragEventListener();
					
					bStatusChanged = true;
					mobileToast.show(objDragUser.name + "의 권한이 변경되었습니다.");
					
					resolve(true);
				}, function() {
					resolve(false);
				});
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.searchUser = function(strName) {
		try {
			if (strName.length >= 2) {
				onefficeMGW.getSearchUserInfoList(CLOUD_CONST_SEARCH_USER_INFO_OPTION_NAME, strName, function(objResponseData) {
					if (objResponseData.length === 0) {
						$scope.clearSearchList();
						return;
					}
					
					$scope.searchList = [];
					var objShareInfo;
					
					objResponseData.forEach(function(objUserInfo) {
						objShareInfo = getObjShareInfo(objUserInfo.id,
														MOBILE_SHARE_USER,
														objUserInfo.name,
														objUserInfo.name.replace(strName, "<em>" + strName + "</em>"),
														objUserInfo.path_name.replace(/\|/gi, "-"),
														getImagePath(objUserInfo.pic),
														objUserInfo.login_id);
						
						$scope.searchList.push(objShareInfo);
					});
					
					updateView($scope);
					
					var nHeight = 65 * $scope.searchList.length;
					nHeight = (nHeight < 196) ? nHeight : 196;
					
					$(".userShare .cancelmodal").show();
					$(".userShare .listUser").height(nHeight).slideDown(200);
					
					setTimeout(function() {
						$(".userShare .listUser dd").each(function(index, item) {
							// 부서 정보가 리스트 가로 사이즈를 넘어가는 경우 텍스트 중간에 말 줄임 문자 넣어줌
							ellipsisPath(item);
						});
					}, 0);
					
					if ($scope.searchList.length > 3) {
						setTimeout(function() {
							objSearchListScroll.enable();
							objSearchListScroll.refresh();
						}, 300);
					} else {
						objSearchListScroll.disable();
					}
					
					objBodyScroll.disable();
				});
			} else {
				$scope.clearSearchList();
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var ellipsisPath = function(objItem) {
		try {
			var strPath = objItem.textContent;
			var arrPath = strPath.split("-");
			var nMaxLoop = 0;		// 무한루프 예외처리
			var strEllipsis = "......";
			
			while (objItem.scrollWidth > objItem.offsetWidth && nMaxLoop < 3) {
				if (arrPath[1] === strEllipsis) {
					arrPath.splice(1, 1);
				}
				
				arrPath[1] = strEllipsis;
				
				strPath = "";
				
				arrPath.forEach(function(strText, nIndex, arrThis) {
					strPath += strText;
					
					if (nIndex < arrThis.length - 1) {
						strPath += "-";
					}
				});
				
				objItem.textContent = strPath;
				
				nMaxLoop++;
			};
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.selectUser = function(objUserInfo) {
		try {
			if ($scope.selectList.some(isDuplicated) === true) {
				return;
			}
			
			function isDuplicated(objData) {
				return (objData.id === objUserInfo.id);
			}
			
			$scope.selectList.push(objUserInfo);
			
			$(".userSearch input").val("");
			$scope.clearSearchList();
			
			setTimeout(function() {
				updateSearchBox();
				
				$(".userSearch .selectField").removeClass("loading");
			}, 100);
			
			setTimeout(function() {
				objBodyScroll.refresh();
			}, 300);
			
			return;
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.deleteUser = function(objUser) {
		try {
			var nIndex = $scope.selectList.indexOf(objUser);
			
			if (nIndex > -1) {
				$scope.selectList.splice(nIndex, 1);
				
				setTimeout(function() {
					updateSearchBox();
				}, 100);
				
				setTimeout(function() {
					objBodyScroll.refresh();
				}, 300);
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var updateSearchBox = function() {
		try {
			var objSearchBox = $(".userSearch .searchbox");
			var objWriteField = objSearchBox.find(".writeField");
			var objUserList = objSearchBox.find(".selectField");
			
			var nTotalWidth = 0;
			
			if (objUserList.length === 0) {
				objWriteField.width("calc(100% - 7px)");
				objWriteField.find("input").attr('placeholder', "공유할 사용자 검색");
				
				nTotalWidth = objSearchBox[0].offsetWidth;
			} else {
				objUserList.each(function(index, item) {
					nTotalWidth += item.offsetWidth;
				});
				
				var nWriteWidth = Math.abs(nTotalWidth - objSearchBox[0].offsetWidth);
				
				if (nWriteWidth < 165
						|| nTotalWidth - objSearchBox[0].offsetWidth > 0) {
					nWriteWidth = 165;
				} else {
					nWriteWidth -= 15;
				}
				
				objWriteField.width(nWriteWidth);
				nWriteWidth = objWriteField[0].offsetWidth;
				
				objWriteField.find("input").attr('placeholder', "");
				
				// searchField 사이즈가 작을 경우 input 영역이 아래로 내려가는 현상이 있어 여분값 추가
				// 첫번째는 11만큼, 이 후 추가되는 아이템마다 5씩 추가.. 왜 그런지 모름..;
				nTotalWidth = nTotalWidth + nWriteWidth + 11 + (5 * objUserList.length - 1);
			}
			
			objSearchBox.find(".searchField").width(nTotalWidth);
			
			objSelectScroll.refresh();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.checkUser = function($event) {
		try {
			var objTarget = $($event.currentTarget);
			var objDel = objTarget.find("img.del");
			var objImg = objTarget.find("img.pic");
			
			if (objTarget.hasClass("check") === false) {
				$(".userSearch .selectField").removeClass("check");
				$(".userSearch .selectField img.del").hide();
				$(".userSearch .selectField img.pic").show();
				
				objTarget.addClass("check");
				objDel.show();
				objImg.hide();
			} else {
				objTarget.removeClass("check");
				objDel.hide();
				objImg.show();
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.clearSearchList = function() {
		try {
			if ($(".listUser tr").length > 0) {
				objSearchListScroll.scrollToElement($(".listUser tr")[0]);
			}
			
			$scope.searchList = [];
			
			$(".userShare .listUser").hide();
			$(".userShare .cancelmodal").hide();
			$(".userSearch input").focus();
			
			objBodyScroll.enable();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.selectUserInOrgTree = function() {
		try {
			NextS.selectOrg("multi", "select", [], function(arrSelectedList) {
				if (arrSelectedList.length > 0) {
					$("#one_share .modal").show();
					
					var arrSelected = arrSelectedList;
					
					addToSelectList(arrSelected, function() {
						setTimeout(function() {
							setTimeout(function() {
								updateSearchBox();
								
								$(".userSearch .selectField").removeClass("loading");
							}, 100);
							
							setTimeout(function() {
								objBodyScroll.refresh();
							}, 300);
							
							$("#one_share .modal").hide();
						}, 300);
					});
				}
			});
		} catch (e) {
			
		}
	};
	
	var addToSelectList = function(arrSelected, fnCallback) {
		try {
			if (arrSelected.length === 0) {
				fnCallback();
				
				return;
			}
			
			var objUserInfo = arrSelected.shift();
			
			if ($scope.selectList.some(function(objData) {
				return (objUserInfo.type === "emp") ? (objData.id === objUserInfo.empSeq) : (objData.id === objUserInfo.deptSeq);
			}) === true) {
				addToSelectList(arrSelected, fnCallback);
				
				return;
			}
			
			var objShareInfo;
			
			if (objUserInfo.type === "emp") {
				onefficeMGW.getSearchUserInfoList(CLOUD_CONST_SEARCH_USER_INFO_OPTION_USER_SEQ, objUserInfo.empSeq, function(arrUserList) {
					objShareInfo = getObjShareInfo(arrUserList[0].id,
													MOBILE_SHARE_USER,
													arrUserList[0].name,
													null,
													arrUserList[0].path_name,
													getImagePath(arrUserList[0].pic),
													arrUserList[0].login_id);
					
					$scope.selectList.push(objShareInfo);
					updateView($scope);
					
					addToSelectList(arrSelected, fnCallback);
				});
			} else {
				if (fnObjectCheckNull(objUserInfo.deptSeq) === false && objUserInfo.deptSeq.length > 0) {
					objShareInfo = getObjShareInfo(objUserInfo.deptSeq, MOBILE_SHARE_GROUP, objUserInfo.name, null, null, null, null);
					$scope.selectList.push(objShareInfo);
					updateView($scope);
				}
				
				addToSelectList(arrSelected, fnCallback);
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.share = function() {
		try {
			if ($scope.selectList.length === 0) {
				return;
			}
			
			var strFileSeq = $scope.$parent.objCurrentDoc.seq;
			var strPermission = $("#one_share div.authority .set li.checkbg.on").attr("perm");
			
			$scope.selectList.forEach(function(objData, nIndex, arrThis) {
				var nShareType = objData.type;
				var strShareId = objData.id;
				
				onefficeMGW.shareDocument(strFileSeq, nShareType, strShareId, strPermission, function() {
					
					if (nIndex === arrThis.length - 1) {
						mobileToast.show($scope.$parent.objCurrentDoc.docData.strTitle + "문서가 공유되었습니다.");
						
						bStatusChanged = true;
						
						$scope.$parent.docDataFact.updateDocShareInfo($scope.$parent.objCurrentDoc.seq);
						// 메세지 전송
						sendNoti();
						
						$scope.cancelSetting();
					}
				});
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.unShare = function(strType, strId, strName, strPerm) {
		try {
			onefficeMGW.unshareDocument($scope.$parent.objCurrentDoc.seq, strType, strId, function() {
				if (strPerm === "R") {
					$scope.arrViewer.some(function(objUser, nIndex) {
						if (objUser.id === strId) {
							$scope.arrViewer.splice(nIndex, 1);
							updateView($scope);
							objViewerScroll.refresh();
							
							return;
						}
					});
				} else {
					$scope.arrEditor.some(function(objUser, nIndex) {
						if (objUser.id === strId) {
							$scope.arrEditor.splice(nIndex, 1);
							updateView($scope);
							objViewerScroll.refresh();
							
							return;
						}
					});
				}
				
				mobileToast.show(strName + "님의 " + ((strPerm === "R") ? "읽기" : "쓰기") + " 권한을 해제 하였습니다");
				
				bStatusChanged = true;
			});
		} catch (e) {
			dalert(e);
		}
	};
	
	var sendNoti = function() {
		try {
			var objAuth = $("#one_share div.authority");
			var strPermission = objAuth.find(".set li.checkbg.on").attr("perm");
			var nMsgType = objAuth.find(".message li.checkbg.on").attr("msg_type") * 1;
			var strMsg = makeNotiMsg(nMsgType, objAuth.find(".messageSend").val(), $scope.$parent.objCurrentDoc, strPermission);
			
			var arrReceiver = $scope.selectList;
			var arrGroup = [];
			
			$scope.selectList.forEach(function(objUser) {
				if (objUser.type === MOBILE_SHARE_GROUP) {
					arrGroup.push(objUser);
					
					onefficeMGW.getEmpListWithinDept(objUser.id, function(arrData) {
						if (arrGroup.length > 0) {
							arrReceiver.splice(arrReceiver.indexOf(arrGroup[0]), 1);
						}
						
						arrReceiver.concat(arrData);
						
						if (arrGroup.length === 0) {
							arrReceiver = makeReceiverList(nMsgType, arrReceiver);
							
							switch (nMsgType) {
								case MOBILE_SHARE_NOTI_MAIL:
                                    var strTitle = $scope.$parent.objCurrentDoc.docData.strTitle;
									var strFrom = $scope.myInfo.mail_id + "@" + $scope.myInfo.mail_domain;
									
                                    if ($scope.$parent.docDataFact.checklist.length > 1) {
                                        strTitle = "\"" + strTitle + "\" 외 " + ($scope.$parent.docDataFact.checklist.length - 1) + "개의 문서";
                                    }
									
                                	onefficeMGW.sendMail(arrReceiver, "[ONEFFICE 공유] " + strTitle, strMsg, strFrom);
									
                                    break;
									
								case MOBILE_SHARE_NOTI_NOTE:
									onefficeMGW.sendNote(arrReceiver, strMsg);
									
									break;
							}
						}
					});
				}
			});
			
			if (arrGroup.length === 0) {
				arrReceiver = makeReceiverList(nMsgType, arrReceiver);
				
				switch (nMsgType) {
					case MOBILE_SHARE_NOTI_MAIL:
                       var strTitle = $scope.$parent.objCurrentDoc.docData.strTitle;
						var strFrom =  $scope.myInfo.mail_id + "@" + $scope.myInfo.mail_domain;
						
						if ($scope.$parent.docDataFact.checklist.length > 1) {
							strTitle = "\"" + strTitle + "\" 외 " + ($scope.$parent.docDataFact.checklist.length - 1) + "개의 문서";
						}
						
                    	onefficeMGW.sendMail(arrReceiver, "[ONEFFICE 공유] " + strTitle, strMsg, strFrom);
						
                        break;
						
					case MOBILE_SHARE_NOTI_NOTE:
						onefficeMGW.sendNote(arrReceiver, strMsg);
						
						break;
				}
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	var makeNotiMsg = function(nType, strMsg, objDocInfo, strPerm) {
		try {
			strPerm = (strPerm === "R") ? "열람" : "편집";
			
			var arrMsg = strMsg.split(/\r?\n/);	//라인별로 나눔
			
			if (!arrMsg[arrMsg.length - 1]) {
				arrMsg.pop();
			}
			
			var bEmptyMsg = (arrMsg.length === 0);
			var strLink = onefficeMGW.getDocumentShareOpenURL(objDocInfo.seq, $scope.myInfo.group_seq);
			var strNotiMsg = "";
			
			switch (nType) {
				case MOBILE_SHARE_NOTI_MAIL:	// mail
					var strLogo = getImagePath("/gw/oneffice/image/Oneffice.png");
					var strDocIcon = getImagePath("/gw/oneffice/image/cloud/ico_cloud_file.png");
					
					// 홍길동 님이 다음 문서를 보기/편집 하도록 초대하였습니다.
					var strInvite = String.format("{0} 님이 다음 문서를 {1} 하도록 초대하였습니다.",
													"<strong>" + $scope.myInfo.name + "</strong>", "<strong>" + strPerm + "</strong>");
					
					strNotiMsg += '<table cellpadding="0" cellspacing="0" width="100%" height="100%" style="background-color: #f5f5f5;">';
					strNotiMsg += '<tbody>';
					strNotiMsg += '<tr>';
					strNotiMsg += '<td style="padding:20px; vertical-align:top">';
					strNotiMsg += '	<table cellspacing="0" cellpadding="0" style="width:700px; margin:0px auto; background-color:#ffffff; border:1px solid #cccccc; border-collapse:collapse;">';
					strNotiMsg += '	<tbody>';
					strNotiMsg += '	<tr>';
					strNotiMsg += '		<td style="padding:30px 40px; text-align:center" colspan="2">';
					strNotiMsg += '			<img src="' + strLogo + '"></img>';
					strNotiMsg += '		</td>';
					strNotiMsg += '	</tr>';
					strNotiMsg += '	<tr>';
					strNotiMsg += '		<td style="padding:20px 40px" colspan="2">';
					strNotiMsg += '			<p>' + strInvite + '</p>';
					strNotiMsg += '		</td>';
					strNotiMsg += '	</tr>';
					
					// 문서 이름
					strNotiMsg += '	<tr>';
					strNotiMsg += '		<td style="padding:5px 40px;">';
					strNotiMsg += '			<p><img src="' + strDocIcon + '" style="vertical-align:middle; margin-right:5px"></img><a href="' + strLink + '" target="_blank" style="line-height:26px; vertical-align:middle; text-decoration:none; color:#000000;"><strong>' + objDocInfo.docData.strTitle + '</strong></a></p>';
					strNotiMsg += '		</td>';
					strNotiMsg += '		<td style="width:80px; padding:5px 40px;">';
					strNotiMsg += '			<div style="width:90px; height:26px; text-align:center; background-color:#1c90fb; color:#ffffff; cursor:pointer;"><a href="' + strLink + '" target="_blank" style="line-height:26px; vertical-align:middle; text-decoration:none; color:#ffffff;">문서 열기</a></div>';
					strNotiMsg += '		</td>';
					strNotiMsg += '	</tr>';
					
					// 메세지 박스
					if (!bEmptyMsg) {
						strNotiMsg += '	<tr>';
						strNotiMsg += '		<td style="padding:5px 40px;" colspan="2">';
						strNotiMsg += '			<hr style="background-color:#6aa4d9; height:1px; border:0px;"></hr>';
						strNotiMsg += '		</td>';
						strNotiMsg += '	</tr>';
						strNotiMsg += '	<tr>';
						strNotiMsg += '		<td style="padding:5px 40px 0px 40px;" colspan="2">';
						strNotiMsg += '			<table cellpadding="0" cellspacing="0" style="width:100%; border-collapse:collapse; background-color:#f5f5f5; border:1px solid #cccccc">';
						strNotiMsg += '			<tbody>';
						strNotiMsg += '			<tr>';
						strNotiMsg += '				<td style="padding:10px 15px; height:150px; vertical-align:top; word-wrap:break-word; word-break:break-all;">';
						
						for (var i = 0; i < arrMsg.length; i++) {
							strNotiMsg += '					<p>' + arrMsg[i] + '</p>';
						}
						
						strNotiMsg += '				</td>';
						strNotiMsg += '			</tr>';
						strNotiMsg += '			</tbody>';
						strNotiMsg += '			</table>';
						strNotiMsg += '		</td>';
						strNotiMsg += '	</tr>';
					}
					
					// bottom margin
					strNotiMsg += '	<tr>';
					strNotiMsg += '		<td style="padding:5px 40px 20px 40px;" colspan="2"></td>';
					strNotiMsg += '	</tr>';
					
					strNotiMsg += '	</tbody>';
					strNotiMsg += '	</table>';
					strNotiMsg += '</td>';
					strNotiMsg += '</tr>';
					strNotiMsg += '</tbody>';
					strNotiMsg += '</table>';
					
					break;
					
				case MOBILE_SHARE_NOTI_NOTE:	// note
					strNotiMsg += "[ONEFFICE 문서 공유]\r\n";
					strNotiMsg += $scope.myInfo.name + "님이 다음 문서를 " + strPerm + " 하도록 초대하였습니다.\r\n\r\n\r\n";
					
					strNotiMsg += "▣ 문서 제목 ▣\r\n";
					strNotiMsg += objDocInfo.docData.strTitle + "\r\n\r\n";
					
					if (strMsg !== "") {
						strNotiMsg += "▣ 메시지 ▣\r\n";
						strNotiMsg += strMsg + "\r\n\r\n";
					}
					
					strNotiMsg += "▣ URL 링크 ▣\r\n";
					strNotiMsg += strLink + "\r\n\r\n";
					
					break;
					
				default:
					break;
			}
			
			return strNotiMsg;
		} catch(e) {
			dalert(e);
		}
	};
	
	var makeReceiverList = function(nType, arrSelectList) {
		try {
			var arrReceiver = [];
			
			switch (nType) {
				case MOBILE_SHARE_NOTI_MAIL:	// mail
					for (var index = 0 ; index < arrSelectList.length ; index++) {
						if ((fnObjectCheckNull(arrSelectList[index].empNameAdv) === true && fnObjectCheckNull(arrSelectList[index].login_id) === true)
								|| fnObjectCheckNull(arrSelectList[index].name) === true) {
							continue;
						}
						
						var strName;
						var strEmailId;
						
						if (fnObjectCheckNull(arrSelectList[index].login_id) === false) {
							strName = arrSelectList[index].name;
							strEmailId = arrSelectList[index].login_id;
						} else {
							strName = arrSelectList[index].empName;
							strEmailId = arrSelectList[index].empNameAdv.replace("(", "");
							strEmailId = strEmailId.replace(")", "");
						}
						
						var objData = {
							empName: strName,
							email: strEmailId + "@" + $scope.myInfo.mail_domain			// 받을 사람 도메인은 내 도메인과 같다
						};
						
						arrReceiver.push(objData);
					}
					
					break;
					
				case MOBILE_SHARE_NOTI_NOTE:	// note
					for (var index = 0 ; index < arrSelectList.length ; index++) {
						arrReceiver.push(arrSelectList[index].id);
					}
					
					break;
					
				default:
					break;
			}
			
			return arrReceiver;
		} catch (e) {
			dalert(e);
		}
	};
});
