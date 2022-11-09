/**
 * http://usejsdoc.org/
 */

	
var onefficeApp = angular.module('onefficeApp', ['ui.router', 'ngAnimate', 'ngTouch', 'ngSanitize']);

onefficeApp.factory("docDataFact", function ($http, $q) {

	var factory = {
		utime: new Date() - 86400,
		list: [],
		recentlist: [],
		folderPath : [],
		checklist: [],
		ownSearchList: [],
		shareSearchList: [],
	};


	factory.convItem = function (tmpItemList) {
		var data = {};
		
		data.seq = tmpItemList.seq;												//doc_no;	//this.m_DocInfoData.docSeq = oneffice.currFileSeq;				
		data.fileType = parseInt(tmpItemList.type, 10) ? 1/*file*/ : 0/*folder*/;				//doc_type
		data.parentFolderSeq = tmpItemList.folderSeq;			//folder_no;
		data.nIdxCurItemList = "";//misty - 2018.08.27 추후 검토. share list 에서 chk list 로 데이터 이동시 체크 요,.
		//doc_info
		data.docData = {};
		data.docData.nContentSize = tmpItemList.content_size;
		data.docData.strContents = tmpItemList.content;

		data.docData.strTitle = tmpItemList.subject;
		data.docData.strKeywords = tmpItemList.keyword;
		data.docData.bDeleted = getBooleanValue(tmpItemList.deleted);
		data.docData.bChecked = false;
		data.docData.bTemp = false;
		data.docData.bViewer = getBooleanValue(tmpItemList.readonly);
		data.docData.bStar = getBooleanValue(tmpItemList.important);
		data.docData.bSecurity = (tmpItemList.security_key.length > 0 && tmpItemList.security_key !== "0") ? 1 : 0;
		data.docData.strThumbnail = tmpItemList.strThumbnail;
		data.docData.imageThumbnail = "";
		data.docData.nDBIdx = 0;		//nReserved
		
		// reg_date
		if (typeof(tmpItemList.regdate) === "string") {
			data.docData.strCreatedDate = tmpItemList.regdate;
		} else {
			data.docData.strCreatedDate = convDateString(new Date(tmpItemList.regdate.time));
		}
		
		// mod_date, oneffice.currFileModDate
		if (typeof(tmpItemList.moddate) === "string") {
			var modifyDateArr = tmpItemList.moddate.split("-");
			
			var modifyDateYear = modifyDateArr[0];
			var modifyDateMonth = modifyDateArr[1];
			var modifyDateDay = modifyDateArr[2].split(" ")[0];
			var modifyDateHour = modifyDateArr[2].split(" ")[1].split(":")[0];
			var modifyDateMinute = modifyDateArr[2].split(" ")[1].split(":")[1];
			
			data.docData.strModifiedDate = tmpItemList.moddate;
			data.docData.dateModifiedDate = new Date(modifyDateYear, modifyDateMonth - 1, modifyDateDay, modifyDateHour, modifyDateMinute);
		} else {
			data.docData.strModifiedDate = convDateString(new Date(tmpItemList.moddate.time));
			data.docData.dateModifiedDate = new Date(tmpItemList.moddate.time);
		}
		
		data.docData.diffModifiedDate = calculateDateDiff(new Date(), data.docData.dateModifiedDate);
		
		// access_date
		if (typeof(tmpItemList.accessdate) === "string") {
			data.docData.strAccessedDate = tmpItemList.accessdate;
		} else {
			data.docData.strAccessedDate = convDateString(new Date(tmpItemList.accessdate.time));
		}
		
		// share_info
		data.shareData = tmpItemList.share_data;
		
		// user_info
		data.userData = {};
		data.userData.nSharedID = tmpItemList.share_id;//공유 받은 사람
		data.userData.strSharedName = tmpItemList.share_name;
		data.userData.strSharedOrgName = tmpItemList.share_org_name;

		data.userData.nOwnerID = tmpItemList.owner_id;// 공유자. oneffice.currFileOwnerId;//this.m_userData.
		data.userData.strOwnerName = tmpItemList.owner_name;
		data.userData.nOwnerDeptID = tmpItemList.owner_org_id;
		data.userData.strOwnerDeptName = tmpItemList.owner_org_name;
		
		data.nShareCount = tmpItemList.share_count * 1;
		
		data.serverData = tmpItemList;
		
		data.sortEditData = data.docData.dateModifiedDate;
		data.sortTitle = tmpItemList.subject;
		data.sortSize  = tmpItemList.content_size;
		data.sortOwner  = tmpItemList.owner_name;
		
		if (tmpItemList.share_count > 0) {
			if (tmpItemList.owner_id === "" || tmpItemList.owner_id === $("#mainContainer").scope().myInfo.id) {
				data.shareInOut = "out";
			} else {
				data.shareInOut = "in";
			}
		} else {
			data.shareInOut = "none";
		}
		
		data.nCommentCounts = 0;
		
		
		function convDateString(objDate) {
			var arrDate = objDate.toISOString().split("T");
			var strDate = arrDate[0] + " " + arrDate[1].slice(0, 8);
			
			return strDate;
		}
		
		return data;
	};
	
	factory.updateCommentCounts = function(arrList) {
		try {
//			arrList.forEach(function(objDocInfo) {
//				getCommentCounts(objDocInfo);
//			});
		} catch (e) {
			dalert(e);
		}
	};
	
	factory.updateCommentCount = function(objDocInfo) {
		try {
			getCommentCounts(objDocInfo);
		} catch (e) {
			dalert(e);
		}
	};
	
	var getCommentCounts = function(objDocInfo) {
		try {
			var objRequestData = {
				langCode: "kr",
				moduleGbnCode: "oneffice",
				moduleSeq: objDocInfo.seq,
				commentType: ""
			};
			
			onefficeMGW.getCommentCount(objRequestData, function(objResponse) {
				if (isNaN(objResponse.count) === true) {
					objResponse.count = 0;
				}
				
				objDocInfo.nCommentCounts = objResponse.count;
				
				updateView($("#mainContainer").scope());
			}, false);
		} catch (e) {
			dalert(e);
		}
	};
	
	factory.getRecentList = function () {

		var defer = $q.defer();

		var listCount = 5;
		onefficeMGW.getFileList("", "", CLOUD_CONST_BROWSER_MODE_RECENT, "", function (responseData) {
			var arr = [];
			responseData.forEach(function (item, index) {
				arr.push(factory.convItem(item));
			});

			factory.recentlist = arr;
			defer.resolve(factory);
		}, "", listCount);

		return defer.promise;
	};

	factory.getSearchList = function (searchStr, storage) {
		var defer = $q.defer();

		onefficeMGW.getFileList("", "", CLOUD_CONST_BROWSER_MODE_SEARCH_RESULT, searchStr, function (responseData) {
			var arr = [];
			responseData.forEach(function (item, index) {
				arr.push(factory.convItem(item));
			});

			if (storage == "myoneffice") {
				factory.ownSearchList = arr;
			} else {
				factory.shareSearchList = arr;
			}
				
			defer.resolve(factory);
		}, storage);
		
//		onefficeMGW.getSearchTotalList(searchStr,function(responseData){
//			console.log(responseData);
//		});
		
		return defer.promise;
	};

	factory.getDocumentList = function (nType, folderSeq, bShowLoading) {

		var defer = $q.defer();
		var browserMode = CLOUD_CONST_BROWSER_MODE_MYONEFFICE;
		var parentSeq = (folderSeq) ? folderSeq : "";

		switch (nType) {
			case MOBILE_BROWSER_INDEX_MY_FOLDER:
				browserMode = CLOUD_CONST_BROWSER_MODE_MYONEFFICE;
				break;
			case MOBILE_BROWSER_INDEX_SHARE_FOLDER:
				browserMode = CLOUD_CONST_BROWSER_MODE_SHARE;
				break;
			case MOBILE_BROWSER_INDEX_SHARE_OUT:
				browserMode = CLOUD_CONST_BROWSER_MODE_MY_SHARE_LIST;
				break;
			case MOBILE_BROWSER_INDEX_SHARE_IN:
				browserMode = CLOUD_CONST_BROWSER_MODE_SHARED_BY_LIST;
				break;
			case MOBILE_BROWSER_INDEX_RECENT_FOLDER:
				browserMode = CLOUD_CONST_BROWSER_MODE_RECENT;
				break;
			case MOBILE_BROWSER_INDEX_SECURITY_FOLDER:
				browserMode = CLOUD_CONST_BROWSER_MODE_SECURITY;
				break;
			case MOBILE_BROWSER_INDEX_FAVORITE_FOLDER:
				browserMode = CLOUD_CONST_BROWSER_MODE_FAVORITE;
				break;
			case MOBILE_BROWSER_INDEX_TRASHBOX:
				browserMode = CLOUD_CONST_BROWSER_MODE_TRASHBOX;
				break;
			default:
				break;
		}
		
		onefficeMGW.getFileList(parentSeq, "", browserMode, "", function (responseData) {
			var arr = [];
			responseData.forEach(function (item, index) {
				arr.push(factory.convItem(item));
			});
			
			factory.list = arr;
//			factory.updateCommentCounts(factory.list);
			
			defer.resolve(factory);
		}, undefined, undefined, bShowLoading);
		
		return defer.promise;
	};
	
	factory.getFolderPath = function(folderSeq)
	{
		var folderPathArray = [];
		var defer = $q.defer();
		onefficeMGW.getFolderPathInfo(folderPathArray, folderSeq, function(responseData) {
			
			var arr = [];
			responseData.forEach(function(item, index) {
				arr.push(item);
			});
			
			factory.folderPath = arr;
			defer.resolve(factory);
		});
		return defer.promise;
	};
	
	factory.getCheckList = function() {
		try {
			factory.checklist = [];
			
			factory.list.forEach(function(objItem) {
				if (objItem.docData.bChecked === true) {
					factory.checklist.push(objItem);
				}
			});
			
			return factory.checklist;
		} catch (e) {
			dalert(e);
		}
	};
	
	factory.getCheckStatus = function(objDocInfo) {
		var checkStatus = MOBILE_MORE_NONE_SELECT;
		
		if (fnObjectCheckNull(objDocInfo) === false) {
			// objDocInfo가 있다면 선택한 객체 하나에 대해서만 status 체크
			return (objDocInfo.fileType === 0) ? MOBILE_MORE_FOLDER_SELECT : MOBILE_MORE_DOC_SELECT;
		}
		
		for (var i = 0; i < factory.list.length; i++) {
			if(factory.list[i].docData.bChecked) {
				if (factory.list[i].fileType == 0) {	// Folder
					checkStatus = (MOBILE_MORE_NONE_SELECT == checkStatus) ? MOBILE_MORE_FOLDER_SELECT : MOBILE_MORE_MULTI_SELECT;
				} else {	// File
					checkStatus = (MOBILE_MORE_NONE_SELECT == checkStatus) ? MOBILE_MORE_DOC_SELECT : MOBILE_MORE_MULTI_SELECT;
				}

				if (MOBILE_MORE_MULTI_SELECT == checkStatus)
					return checkStatus;
			}
		}

		return checkStatus;
	};

	factory.getImagePath = function (item) {
		var resPath = "../mobile/images/ico/icon_thumb_file_oneffice.png";
		var currTime = new Date().getTime();

		 if (item.docData.strThumbnail.length) {
			 
			 onefficeMGW.getImageContent(item.docData.strThumbnail,function(data){
					if(data==null){
						item.docData.imageThumbnail = resPath;
						return resPath;
					}else{
						var i = new Image();
						i.src = data;
						return i;
					}
				})
		 }else{
			 return resPath;
		 }
			
		
		
	};
	
	factory.updateDocStatus = function (strSeq, strStatus, nValue) {
		try {
			// 전체 문서 리스트 검색
			factory.list.some(function(objItem) {
				if (objItem.seq === strSeq) {
					update(objItem);
					return true;
				}
			});
			
			// 선택된 문서 정보 업데이트
			if ($("#mainContainer").scope().objCurrentDoc !== null
					&& $("#mainContainer").scope().objCurrentDoc.seq === strSeq) {
				update($("#mainContainer").scope().objCurrentDoc);
			}
			
			function update(objDocInfo) {
				if (strStatus === "nShareCount") {
					objDocInfo[strStatus] = nValue;
				} else {
					objDocInfo.docData[strStatus] = nValue;
				}
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	factory.updateDocShareInfo = function(strSeq) {
		try {
			var objDefer = $q.defer();
			
			onefficeMGW.getShareInfo(strSeq, function(arrData) {
				
				// 중복된 open link 제거
				var arrShareInfo = arrData.slice(0, 1);
				
				for (var index = 1; index < arrData.length; index++) {
					if ((arrData[index].share_type * 1) !== 9) {
						arrShareInfo.push(arrData[index]);
					}
				}
				
				// 전체 문서 리스트 검색
				factory.list.some(function(objItem) {
					if (objItem.seq === strSeq) {
						update(objItem);
						return true;
					}
				});
				
				// 선택된 문서 정보 업데이트
				if ($("#mainContainer").scope().objCurrentDoc !== null
						&& $("#mainContainer").scope().objCurrentDoc.seq === strSeq) {
					update($("#mainContainer").scope().objCurrentDoc);
				}
				
				function getShareData() {
					var objShareInfo;
					var arrShareData = [];
					
					arrShareInfo.forEach(function(objData) {
						objShareInfo = {
							nShareID: objData.share_id,
							strShareDate: objData.share_date,
							cSharePermission: objData.share_perm.toUpperCase(),
							nShareType: objData.share_type * 1,
							strName: null
						};
						
						if (objShareInfo.nShareType === MOBILE_SHARE_USER) {
							objShareInfo.strName = objData.share_name;
						} else if (objShareInfo.nShareType === MOBILE_SHARE_GROUP) {
							objShareInfo.strName = objData.share_org_name;
						}
						
						arrShareData.push(objShareInfo);
					});
					
					return arrShareData;
				}
				
				function update(objDocInfo) {
					objDocInfo.shareData = getShareData();
					objDocInfo.bOpenLink = (arrShareInfo.length === 0) ? false : (arrShareInfo[0].share_type * 1 === MOBILE_SHARE_OPEN_LINK);
					objDocInfo.nShareCount = arrShareInfo.length;
				}
				
				objDefer.resolve(factory);
			}, false);
			
			return objDefer.promise;
		} catch (e) {
			dalert(e);
		}
	};
	
	return factory;
});

onefficeApp.directive('iframeDirective', ['$sce', function($sce) {
	  return {
	    restrict: 'E',
	    template: '<iframe src="{{ trustedUrl }}" width="100%" height="100%"  frameborder="0" scrolling="yes"></iframe>',
	  }
	}]);

onefficeApp.directive('onLongPress', function ($timeout) {
	var nStartX;
	var nStartY;
	
	return {
		restrict: 'A',
		link: function ($scope, $elm, $attrs) {
			$elm.bind('touchstart', function (evt) {
				// Locally scoped variable that will keep track of the long press
				$scope.longPress = true;
				
				var nDelay = 1000;
				var arrClass = evt.currentTarget.classList;
				
				nStartX = evt.originalEvent.touches[0].clientX;
				nStartY = evt.originalEvent.touches[0].clientY;
				
				if (arrClass.contains("viewer") === true || arrClass.contains("editor") === true) {
					nDelay = 300;
				}
				
				// We'll set a timeout for 600 ms for a long press
				$timeout(function () {
					if ($scope.longPress) {
						// If the touchend event hasn't fired,
						// apply the function given in on the element's on-long-press attribute
						$scope.$apply(function () {
							$scope.$eval($attrs.onLongPress, {$event: evt});
						});
					}
				}, nDelay);
			});
			
			$elm.bind('touchmove', function (evt) {
				// Prevent the onLongPress event from firing
				if (Math.abs(evt.originalEvent.touches[0].clientX - nStartX) > 10
						|| Math.abs(evt.originalEvent.touches[0].clientY - nStartY) > 10) {
					$scope.longPress = false;
				}
				
				// If there is an on-touch-move function attached to this element, apply it
				if ($attrs.onTouchMove) {
					$scope.$apply(function () {
						$scope.$eval($attrs.onTouchMove);
					});
				}
			});

			$elm.bind('touchend', function (evt) {
				// Prevent the onLongPress event from firing
				$scope.longPress = false;
				
				nStartX = 0;
				nStartY = 0;
				
				// If there is an on-touch-end function attached to this element, apply it
				if ($attrs.onTouchEnd) {
					$scope.$apply(function () {
						$scope.$eval($attrs.onTouchEnd);
					});
				}
			});
		}
	};
}).directive('myclick', function() {
	return function(scope, element, attrs) {
		// moreBtnClick이 두번 호출되는 현상 예외처리
		element.bind('touchstart click', function(event) {
			event.preventDefault();
            event.stopPropagation();
			
            scope.$apply(attrs['myclick']);
		});
	};
});
