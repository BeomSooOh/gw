/*
 * 
 */

onefficeApp.controller("ctrl_comment", function($scope,$timeout) {
	
	var getObjShareInfo = function(strId, nType, strName, comp_id, org_id, strEmName, strPath, strPic, strLoginId) {
		if (strPic === null) {
			strPic = "./mobile/images/bg/img-profile-";
			
			strPic += (nType === MOBILE_SHARE_USER) ? "none-0" : "group-0";
			
			strPic += (Math.floor(Math.random() * 5) + 1) + ".png";
		}
		
		return {
			id: strId,
			type: nType,
			name: strName,
			compSeq: comp_id,
			deptSeq: org_id,
			em_name: (strEmName !== null) ? strEmName : strName,
			path: strPath,
			pic: strPic, 
			login_id: strLoginId		// email 전송 시 필요 데이터
		};
	};
	
	$scope.selectedComment=null;
	$scope.replyMode = false;
	$scope.editMode = false;
	var setCustomScroll = false;
	var deptReciveList = [];
	$scope.initComment = function() {
    	try {
    		$("div.dialog_layer_wrap").show();
			var objEditor = $('#cmtDiv');
    		objEditor.unbind();
			
			var objCommnet = $("#one_comment");
			
			objCommnet.trigger("create");
			objCommnet.addClass("ui-page ui-page-theme-a").css({background: "#fff", "z-index": 101});
			
			$scope.$parent.viewChange(7);
			$scope.getCommentData();
			
			objEditor.on("keypress keyup", function() {
				// 댓글 작성창 높이가 변경된 경우 위쪽의 댓글창 높이 변경
				updateWindowHeight();
                
                var range = window.getSelection().getRangeAt(0);
				
				var _targetLine = range.startContainer.data;
				
				if (!_targetLine) {
                    range = null;
					return;
				}
				
				var _inner = _targetLine;
				var _index = _inner.indexOf("@", range.startOffset - 5);
				
				if (_index!=-1) {
					var searchTxt = _inner.substr(_index + 1, 3);
					$scope.searchUser(searchTxt);
				}
                
                range = null;
			});
			
			updateWindowHeight();
			
			objCommnet.find(".modal").click(function () {
				$(".action_div").removeClass("on");
				$(this).hide();
			});
			
			$(window).scroll(function(event){
				if(g_browserCHK.androidtablet || g_browserCHK.iPad) return;
				var iOSMenuOffset = 0;
				iOSMenuOffset = window.scrollY;
				$('#commentHeader').css('top',iOSMenuOffset+'px');
			});
			
			deptReciveList = [];
			
			$scope.objDocInfo.shareData.forEach(function(shareInfo){
				if (shareInfo.nShareType =="1") {
					onefficeMGW.getEmpListWithinDept(shareInfo.nShareID, function (responseData) {
						for(var ix=0; ix<responseData.length; ix++)
						{
							if(responseData[ix].empSeq !=  mobile_http.hybridBaseData.result.empSeq){
								deptReciveList.push(responseData[ix]);
							}
						}
					});
				}
			});
		
			
			
    	} catch (e) {
    		dalert(e);
    	}
	};
	
	$scope.moveBack = function() {
		try {
			var objActionSheet = $("#id_actionsheet_scroll.action_div");
			
			if (objActionSheet.hasClass("on") === true) {
				objActionSheet.removeClass("on");
				$("#one_comment .modal").hide();
				
				return;
			}
			
			$scope.cancelComment();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.cancelComment = function() {
		try {
			if($scope.$parent.bOnViewStatus == true)
				$scope.$parent.viewChange(3);
			else
			$scope.$parent.viewChange(0);
			$("div.dialog_layer_wrap").hide();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.getCommentData = function(){
		$scope.shareUserList = [];
		$scope.mySeq = mobile_http.hybridBaseData.result.empSeq;
		$scope.objDocInfo = $scope.$parent.objCurrentDoc;
		$scope.objDocInfo.shareData.forEach(function(shareInfo){
			$scope.shareUserList.push(shareInfo);
		});
		var _docOwner = {
				nShareID: $scope.objDocInfo.userData.nOwnerID==""?mobile_http.hybridBaseData.result.empSeq:$scope.objDocInfo.userData.nOwnerID,
				strShareDate: null,
				cSharePermission: "W",
				nShareType: 0,
				strName: $scope.objDocInfo.userData.strOwnerName==""?mobile_http.hybridBaseData.result.empName:$scope.objDocInfo.userData.strOwnerName,
		}
		$scope.shareUserList.push(_docOwner);
		
				
		var requestData ={
			langCode : "kr",
			moduleGbnCode : "oneffice",
			moduleSeq : $scope.objDocInfo.seq,
			commentType : "",
			sort : "A",
			searchWay : "U",
			reqSubType : "N",
			commentSeq : "",
			pageSize : 99,
		};

		onefficeMGW.getCommentList(requestData, function (responseData) {
			$scope.CommentList = responseData;
			updateView($scope);
			$timeout(commentScrollEnd,5);
			$scope.replyMode = false;
			$scope.editMode = false;
		});
	}
	
	function commentScrollEnd(){
		
		var d = $('.commentContainer');
		if(!setCustomScroll){
			d.scrollTop(d.prop('scrollHeight')+100);
		}else{
			setCustomScroll = false;
		}
		
	
	}
	
	$scope.setCommentMargin = function(margin){
		try{
			if(margin>1){
				return { marginLeft: 30 };
			}else{
				return { marginLeft: 0 };
			}
			
		}catch(e){
			dalert(e);
		}
	};
	
	
	$scope.getCommentPrfile = function(commetData){
//		return 'http://bizboxa.duzonnext.com//upload/img/profile/demo/' + commetData.createSeq + '.jpg';
		return 'http://' + mobile_http.hybridBaseData.result.compDomain + '/upload/img/profile/' + $scope.myInfo.group_seq + '/' + commetData.createSeq + '.jpg';
	};
	
	$scope.changeMention = function(index,comment){
		$timeout(function(){
			var _str = replaceAllPkg(comment.contents,"\n","</br>");
			var _defaultColor = "#148dda";
			if($scope.mySeq==comment.createSeq) _defaultColor="#8FF7C3";
			var _res = replaceAllPkg(_str,"|>@",'<span><input type="button" style="background:none; border:none; font-size:14px; color:'+_defaultColor+'; padding-bottom:2px;" ');
			_res = replaceAllPkg(_res,"@<|",'></span>');
			_res = replaceAllPkg(_res,",name=", "value=");
			$("#comment_"+index).html(_res);
			},0);
	};
	
	var lastSearchName = "";
	$scope.searchUser = function(strName) {
		try {
			if (strName.length >= 2) {
				lastSearchName = strName;
				onefficeMGW.getSearchUserInfoList(CLOUD_CONST_SEARCH_USER_INFO_OPTION_NAME, strName, function(objResponseData) {
					if (objResponseData.length === 0) {
						$scope.clearSearchList();
						return;
					}
					
					$scope.searchList = [];
					var objShareInfo;
					var checkOpenLink = false;
					$scope.shareUserList.forEach(function(shareInfo){
						if(shareInfo.nShareType==9){
							checkOpenLink = true;
						}
					});
					objResponseData.forEach(function(objUserInfo) {
						objShareInfo = getObjShareInfo(objUserInfo.id,
														MOBILE_SHARE_USER,
														objUserInfo.name,
														objUserInfo.comp_id, 
														objUserInfo.org_id,
														objUserInfo.name.replace(strName, "<em>" + strName + "</em>"),
														objUserInfo.path_name.replace(/\|/gi, "-"),
														getImagePath(objUserInfo.pic),
														objUserInfo.login_id);
						
						if(checkOpenLink){
							$scope.searchList.push(objShareInfo);
						}else{
							$scope.shareUserList.forEach(function(shareInfo){
								if(shareInfo.nShareID == objShareInfo.id){
									$scope.searchList.push(objShareInfo);
									
								}
							});
						}
						
						
						for(var ix=0; ix<deptReciveList.length; ix++){
							if(objShareInfo.id == deptReciveList[ix].empSeq){
								var isList = false;
								for(var j=0; j<$scope.searchList.length; j++){
									if($scope.searchList[j].id  == objShareInfo.id){
										isList = true;
									}
								}
								if(!isList){
									$scope.searchList.push(objShareInfo);
								}
								
							}
							
						}
						
						
					});
					if ($scope.searchList.length === 0) {
						$scope.clearSearchList();
						return;
					}
					
					updateView($scope);
					
					var nHeight = 65 * $scope.searchList.length;
					nHeight = (nHeight < 196) ? nHeight : 196;
					
					$(".searchShereUser").show();
					$(".searchShereUser").height(nHeight).slideDown(200);
					
					setTimeout(function() {
						$(".userShare .listUser dd").each(function(index, item) {
							// 부서 정보가 리스트 가로 사이즈를 넘어가는 경우 텍스트 중간에 말 줄임 문자 넣어줌
							//ellipsisPath(item);
						});
					}, 0);
					
				});
			} else {
				$scope.clearSearchList();
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.clearSearchList = function() {
		try {
			
			$scope.searchList = [];
			
			$(".searchShereUser").hide();
			
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.addMention = function(user){
		try{
			var _userId   = user.id;
			var _userName = user.name;
			var cmt = document.getElementById('cmtDiv');
			var _str = '<span><input class="mentions" type="button" style="background:none; border:none; font-size:16px; color: #148dda; padding-bottom:2px;" empseq="'+_userId+'" value="'+_userName+'"></span>'
			var orgHTML = cmt.innerHTML;
			cmt.innerHTML = orgHTML.replace("@"+lastSearchName, _str);
			
			$scope.clearSearchList();
			
		} catch (e){
			dalert(e);
		}
	};
	
	$scope.actionSheetType = "myComment";
	$scope.commentOnLongPress = function(cmt){
		try{
			$scope.selectedComment = cmt;
			$scope.actionSheetType = $scope.mySeq==$scope.selectedComment.createSeq?"myComment":"shereComment";
				
			$("#cmtDiv").blur();
			var objActionSheet = $("#id_actionsheet_scroll.action_div");
			objActionSheet.addClass("on");
			$("#one_comment .modal").css("display", "block");
		} catch (e) {
			
		}
	};
	
	$scope.insertCommnet = function() {
		try {
			var cmt = document.getElementById('cmtDiv');
			
			if (cmt.textContent.trim() === "") {
				return;
			}
			
			var grpSeq = mobile_http.hybridBaseData.result.groupSeq;
			var compSeq = mobile_http.hybridBaseData.result.compSeq;
			var recvList = [];
			var mentionList = [];
			
			$scope.shareUserList.forEach(function(shareObj) {
				var shereId = shareObj.nShareID;
				var _obj;
				
				if (shareObj.nShareType =="1") {
					for(var ix=0; ix<deptReciveList.length; ix++){
						recvList.push(deptReciveList[ix]);
					}
				} else if (shareObj.nShareType=="0") {
					_obj = {groupSeq:grpSeq, compSeq:compSeq, deptSeq:"", empSeq:shereId, langCode:"kr",pushYn:"Y"};
				}
				
				if (shereId!=$scope.mySeq && shareObj.nShareType != "9" && shareObj.nShareType != "1") {
					recvList.push(_obj);
				}
			});
			
			var strOpenURL = "/gw/oneffice/" + oneffice.getEditModeDocPath($scope.objDocInfo.seq, $scope.myInfo.group_seq, "view_comment");
			var sendcmt = document.getElementById('sendCmtArea');
			sendcmt.innerHTML =  cmt.innerHTML;
			
			if ($(sendcmt).find(".mentions").length > 0) {
				$.each($(sendcmt).find(".mentions"), function( key, value ) {
					$(value).replaceWith("|>@empseq=\"" + $(value).attr("empseq") + "\",name=\"" + $(value).attr("value") + "\"@<|");
					
					//멘션수신리스트 세팅
						var recvMentionEmp = {};
						recvMentionEmp.groupSeq = grpSeq;
						recvMentionEmp.compSeq = "";
						recvMentionEmp.deptSeq = "";
						recvMentionEmp.empSeq = $(value).attr("empseq");
						mentionList.push(recvMentionEmp);
						
						//recvMentionEmp.langCode = "kr";
						//recvMentionEmp.pushYn = "Y";							
						//eventInfo.recvEmpList.push(recvMentionEmp);
				});
			}
			
			$.each($(sendcmt).find("div"), function(key, value) {
				$(value).replaceWith("\n" + $(value).html());
			});
			
			$.each($(sendcmt).find("br"), function(key, value) {
				$(value).replaceWith("\n");
			});
			
			var cmtContents = sendcmt.innerText;
			var _topLevelCommentSeq="";
			var _parentCommentSeq="";
			var _commentSeq ="";
			var _depth = 1;
			
			if ($scope.replyMode || $scope.editMode) {
				setCustomScroll = true;
			} else {
				setCustomScroll = false;
			}
			
			if ($scope.replyMode && $scope.selectedComment != null) {
				_parentCommentSeq = $scope.selectedComment.commentSeq;
				_topLevelCommentSeq = $scope.selectedComment.topLevelCommentSeq;
				_depth = $scope.selectedComment.depth+1;
			}
			
			if ($scope.editMode && $scope.selectedComment != null) {
				_commentSeq = $scope.selectedComment.commentSeq;
				_parentCommentSeq = $scope.selectedComment.parentCommentSeq;
				_topLevelCommentSeq = $scope.selectedComment.topLevelCommentSeq;
			}
			
			var requestData = {
					langCode : "kr",
					commentSeq : _commentSeq,
					moduleGbnCode : "oneffice",
					moduleSeq : $scope.objDocInfo.seq,
					topLevelCommentSeq : _topLevelCommentSeq,
					parentCommentSeq : _parentCommentSeq,
					depth : _depth,
					fileId: "",
					contents: cmtContents,
					commentType:"",
					highGbnCode:"",
					middleGbnCode:"",
					commentPassword: "",
					empName: "",
					dutyCode :mobile_http.hybridBaseData.result.dutyCode,
					positionCode: mobile_http.hybridBaseData.result.positionCode,
					event: {
						alertYn:"Y",
						pushYn:"Y",
						talkYn:"Y",
						mailYn:"Y",
						smsYn:"Y",
						portalYn:"Y",
						timelineYn:"Y",
						recvEmpBulk:"",
						recvEmpList:recvList,
						recvMentionEmpList:mentionList,	
						url:"",
						ignoreCntYn:"Y",
						eventType:"ONEFFICE",
						eventSubType:"ONE001",
						data: {doc_url: strOpenURL, user_nm: mobile_http.hybridBaseData.result.empName, noti_msg: cmtContents}
					}
				};
				
				onefficeMGW.updateComment(requestData, function (responseData) {
					$scope.getCommentData();
					$('#cmtDiv').html("");
					$scope.selectedComment = null;
					$scope.replyMode = false;
					$scope.editMode = false;
					updateWindowHeight();
				});
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.deleteComment = function(){
		try{
			if(!$scope.selectedComment || $scope.selectedComment==null) return;
			var d = $('.commentContainer');
			var requestData ={
					langCode : "kr",
					commentSeq :$scope.selectedComment.commentSeq,
					moduleGbnCode : "oneffice",
					moduleSeq : $scope.objDocInfo.seq,
					topLevelCommentSeq :$scope.selectedComment.topLevelCommentSeq
					
				};
				onefficeMGW.deleteComment(requestData, function (responseData) {
					$scope.getCommentData();
					$scope.selectedComment = null;
					mobileToast.show("댓글이  삭제되었습니다.", MOBILE_TOAST.INFO);
					$("#one_comment .modal").trigger("click");
				});
			
		}catch (e){
			dalert(e);
		}
	};
	
	$scope.copyComment = function(){
		try{
			if(!$scope.selectedComment || $scope.selectedComment==null) return;
			
			var cmt = document.getElementById('cmtDiv');
			var _str = replaceAllPkg($scope.selectedComment.contents,"\n","</br>");;
			var _defaultColor = "#148dda";
			var _res = replaceAllPkg(_str,"|>@",'<span><input class="mentions" type="button" style="background:none; border:none; font-size:14px; color:'+_defaultColor+'; padding-bottom:2px;" ');
			_res = replaceAllPkg(_res,"@<|",'></span>');
			_res = replaceAllPkg(_res,",name=", "value=");
			
			$(cmt).html(_res);
			setFocusLastCaret()
			
			$scope.selectedComment = null;
			$("#one_comment .modal").trigger("click");
			
		}catch (e){
			dalert(e);
		}
	};
	
	
	$scope.replyComment = function(cmt){
		try{
			if(cmt) $scope.selectedComment = cmt;
			
			if(!$scope.selectedComment || $scope.selectedComment==null) return;
			$scope.replyMode = true;
			$scope.editMode = false;
			
			var cmt = document.getElementById('cmtDiv');
			var _str = '<span><input class="mentions" type="button" style="background:none; border:none; font-size:16px; color: #148dda; padding-bottom:2px;" empseq="'+$scope.selectedComment.createSeq+'" value="'+$scope.selectedComment.empName+'"></span>'
			$(cmt).html(_str);
			
			setFocusLastCaret()
			
			
			
			
			$("#one_comment .modal").trigger("click");
		}catch (e){
			dalert(e);
		}
	};
	
	$scope.editComment = function(){
		try{
			if(!$scope.selectedComment || $scope.selectedComment==null) return;
			$scope.replyMode = false;
			$scope.editMode = true;
			
			var cmt = document.getElementById('cmtDiv');
			var _str = replaceAllPkg($scope.selectedComment.contents,"\n","</br>");;
			var _defaultColor = "#148dda";
			
			var _res = replaceAllPkg(_str,"|>@",'<span><input class="mentions" type="button" style="background:none; border:none; font-size:14px; color:'+_defaultColor+'; padding-bottom:2px;" ');
			_res = replaceAllPkg(_res,"@<|",'></span>');
			_res = replaceAllPkg(_res,",name=", "value=");
			
			$(cmt).html(_res);
			setFocusLastCaret()
			
			$("#one_comment .modal").trigger("click");
		}catch (e){
			dalert(e);
		}
	};
	
	$scope.closeComment = function() {
		try {
			$('#cmtDiv').html("");
			$scope.selectedComment = null;
			$scope.replyMode = false;
			$scope.editMode = false;
			
			updateWindowHeight();
		} catch (e) {
			dalert(e);
		}
	};
	
	function setFocusLastCaret(){
		var cmt = document.getElementById('cmtDiv');
		
		$(cmt).focus();
		
		var range = document.createRange();
		range.selectNodeContents(cmt);
		range.collapse(false);
		
		var sel = window.getSelection();
		sel.removeAllRanges();
		sel.addRange(range);
	}
	
	function replaceAllPkg(str, searchStr, replaceStr) {
		if(str == null){
			return "";
		}
		
	    return str.split(searchStr).join(replaceStr);
	}
	
	$scope.onResizeProc = function() {
		try {
			var objComment = $("#one_comment");
			var nWindowHeight = $(window).height();
			
			if (nWindowHeight < objComment.height()) {
				var strStyle = objComment.attr("style");
				strStyle += (" min-height: " + (nWindowHeight - 10) + "px !important");
				
				objComment.attr("style", strStyle);
			} else {
				objComment[0].style["min-height"] = "";
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	function updateWindowHeight() {
		try {
			var nHeight = $("#one_comment .cmtEditor").height();
			var objCommentContainer = $("#one_comment .commentContainer");
			var nContainerHeight = objCommentContainer.height();
			
			objCommentContainer.height("calc(100% - " + nHeight + "px)");
			
			if (nContainerHeight + objCommentContainer.scrollTop() >= objCommentContainer[0].scrollHeight - 1) {
				// 스크롤이 가장 하단에 위치한 경우 하단 포커스 유지되도록 scrollTop 갱신
				objCommentContainer.scrollTop(objCommentContainer[0].scrollHeight);
			}
		} catch (e) {
			dalert(e);
		}
	}
});
