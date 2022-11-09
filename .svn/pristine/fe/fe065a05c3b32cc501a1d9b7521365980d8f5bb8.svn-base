<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ page import="neos.cmm.util.code.CommonCodeSpecific" %>
<%@ page import="neos.cmm.util.BizboxAProperties" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">

/**
 * SSO 연동도 고려해야함!!!
 */

var manualUserSe = "${loginVO.userSe}";
var orgnztId = "${loginVO.orgnztId}";
var parentOptionValue = "${parentOptionValue}";
//var parentOptionValue = "0";
var optionValueLogoutTime = "";
var optionValueLogoutType = "";
var limitYn = 1;		// 제한 여부
var logonTime = "${logonTime}";
var empDeptFlag = false;
var alertFlag = true;
var logoutFlag = true;
var mentionUseYnFlag = "${mentionUseYn}";
var compMailUrl = "${compMailUrl}";

// 로그인 정보가 있는지 없는지 검사!!
sessionCheck();



// console.log(logonTime);
// 로그인 통제 옵션 사용 시 (상위 옵션)
if(parentOptionValue == "1") {
	// 자동 로그아웃 시간
	optionValueLogoutTime = "${optionValueLogoutTime}";
	optionValueLogoutType = "${optionValueLogoutType}";
	
	localStorage.setItem("limitYn", 1);		
	
	// 강제 로그아웃 시간 값이 존재할때 
	if(optionValueLogoutTime > 0) {

		// 동작 이벤트 (시간 초기화)
		$(window).bind("click keyup", function () { resetTimer(); });
		
		// 사용 기록이 없을 때
		if(localStorage.getItem("LATime") == "" || localStorage.getItem("LATime") == null) {
			resetTimer();
		} else if (logonTime != null && logonTime != "") {
            resetTimer();
        }

		// 강제 로그 아웃 되었을 때
		if ((parseInt(localStorage.getItem("LATime")) + (60000 * optionValueLogoutTime) < (+new Date()))) {
            document.location.href = 'uat/uia/actionLogout.do';
            alert("<%=BizboxAMessage.getMessage("TX000011986","보안설정으로 인해 자동 로그아웃 되었습니다.")%>");
        } else {
            resetTimer();
            setInterval(function () { idleCheck(); }, 10000);
        }
	}
}

//세션체크 하는 함수 로그아웃 이후 뒤로가기시 세션체크하여 로그인 페이지 이동을 위해 작성 
function sessionCheck() {
	$.ajax({
		type: "GET"
		, url: '<c:url value="/uat/uia/serverSessionReset.do"/>'
		, cache: false
		, success: function(result) {
			if(!result.isAuthenticated){
				alert("<%=BizboxAMessage.getMessage("TX000015982", "세션이 만료되었습니다.")%>");
				document.location.href = 'uat/uia/egovLoginUsr.do';
			}
		}
		, error: function(result) {}
	});
}

function idleCheck() {
	
	if(!logoutFlag){
		fnAutoLogout();
		return;
		
	}else if (logoutFlag && limitYn == "1" && (parseInt(localStorage.getItem("LATime")) + (60000 * optionValueLogoutTime) - (+new Date())) < 0) {
		
		//PC Sleep으로 인해 스크립트 미동작 후 1분이상 지연 처리
		if((parseInt(localStorage.getItem("LATime")) + (60000 * optionValueLogoutTime) - (+new Date())) < -60000){
			fnAutoLogout();
			logoutFlag = false;
			return;
		}		
		
		localStorage.setItem("limitYn", 0);
		
        $("#idleCheckDiv, .idleCheckDivLock").show();
        limitYn = 0;
        countDown();
    }
}

function countDown() {
	var sec = parseInt($("#limitSec").html());

	if(limitYn == "0"){
		if (sec > 0) {
	        setTimeout("countDown()", 1000);
	        $("#limitSec").html(sec -1);
	    } else {
	    	fnAutoLogout();
	    }
	}
}

function fnAutoLogout(){
	
	localStorage.setItem("forceLogoutYn", "Y");
	
	$("#idleCheckDiv, .idleCheckDivLock").show();
    $("#secuText").html("<%=BizboxAMessage.getMessage("TX000007432","보안설정으로 인해 자동 로그아웃 되었습니다.")%>");
    $('[name=inSession]').hide();
    $("#limitSec").hide();
    
    if(optionValueLogoutType != "1"){
        $("#logonPw").find('input').val("");
        $("#logonPw").show();
        $('[name=outSession]').show();
        
        fnRemoveSession();
        
    }else{
    	
    	setTimeout(function() {
            document.location.href = 'uat/uia/actionLogout.do';
            if(logoutFlag){
            	alert("<%=BizboxAMessage.getMessage("TX000011986","보안설정으로 인해 자동 로그아웃 되었습니다.")%>");
            	fnRemoveSession();            	
            }
    	}, 500);    	

    }	
    
}

// 로그아웃 세션 삭제
var fnRemoveSessionField = false;
	
function fnRemoveSession() {
	
	if(fnRemoveSessionField){
		return;
	}	
	
	$.ajax({
		type: "POST"
		, url: '<c:url value="/uat/uia/removeSession.do" />'
		, success: function(result) {
			fnRemoveSessionField = true;
		}
		, error: function(result) {
			$("#idleCheckDiv, .idleCheckDivLock").show();
	        $("#secuText").html("<%=BizboxAMessage.getMessage("TX000007432","보안설정으로 인해 자동 로그아웃 되었습니다.")%>");
	        $('[name=inSession]').remove();
            $('[name=outSession]').remove();
            $("#limitSec").remove();
            $("#logonPw").remove();
            
            $('[name=forceSession]').show();		
		}
	});
}

// 동작 이벤트 발생 시 시간 초기화
function resetTimer() {
	if(limitYn == "1") {
		localStorage.setItem("LATime", (+new Date()));	
	}
}


function loginButton() {
    if (event.keyCode == 13) {
        reLogon();
    }
}


function reLogon() {
	if ($("#logonPw").find('input').val() == "") {
        alert("<%=BizboxAMessage.getMessage("TX000012059","패스워드를 입력해 주십시오.")%>");
        return;
    }
	
	var param = {};
	param.userSe = "${loginVO.userSe}";
	param.groupSeq = "${loginVO.groupSeq}";
	param.compSeq = "${loginVO.compSeq}";
	param.deptSeq = "${loginVO.orgnztId}";
	param.empSeq = "${loginVO.uniqId}";
	param.type = "def";
	param.secuStrBase = btoa(unescape(encodeURIComponent($("#logonPw").find('input').val())));

	$.ajax({
		type: "POST"
		, data: param
		, url: '<c:url value="/loginPwCheck.do" />'
		, success: function(result) {
			if(result.result > 0) {
				
				localStorage.removeItem("forceLogoutYn");
				logoutFlag = true;
                localStorage.setItem("limitYn", 1);
                limitYn = 1;
                resetTimer();				
				
                //세션이 없을경우 처리
                if(result.result == 2){
        			document.reLogonProcForm.action = "systemx/reLogonProc.do";
        			document.reLogonProcForm.encPasswdOld.value = param.encPasswdOld;
        			document.reLogonProcForm.langCode.value = result.langCode;
        			document.reLogonProcForm.submit();
                }else{
    				$('#idleCheckDiv, .idleCheckDivLock').hide();
                    $('#limitSec').html('60');
                    $("#limitSec").show();
                    $('[name=inSession]').show();
                    $('[name=outSession]').hide();
                    $("#logonPw").hide();                	
                }
			} else {
				alert('<%=BizboxAMessage.getMessage("TX000012083","패스워드가 일치하지 않습니다.")%>');
				$("#logonPw").focus();
			}
		}
		, error: function(result) {
			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
		}
	});
}

	var topType = '${topType}';	
	var popType = 0; // 0:모두,1:프로필팝업, 2:알림팝업, 3:나의메뉴
	var clickCnt = 0;
	var chkInOut = false;
	
	function getTopMenu() {
		return menu.topMenuInfo;
	}
	
	function getLeftMenuList() {
		return menu.leftMenuList;
	}
	
	function onclickTopMenu(no, name, url, urlGubun) {
		
		$(".profile_comp_box").css("display", "none");
		
		if(topType == "mailex")
			$("#_content").attr("src","/"+urlGubun + "/cmm/systemx/myInfoManage.do");
		
		else{
			if (topType == 'tsearch' || topType == 'main' || topType == 'mainex' || topType == 'timeline' || topType == 'mail' || urlGubun == 'mail' || urlGubun == 'adminMail') {
				
				$("#no").val(no);
				$("#name").val(name);
				$("#url").val(url);
				$("#urlGubun").val(urlGubun);
				
				if (urlGubun == 'mail' || urlGubun == 'adminMail') {
					form.action="bizboxMail.do";
				}else if(urlGubun == 'mailex'){ // 메일전용 계정 추가
					form.action="bizboxMailEx.do";
				}else if(urlGubun == 'noticeMail') {
					openWindow2(url, name, 980, 680, 1, 1);
					return;
				}else {
					form.action="bizbox.do";
				}
				
				form.submit();
				
				//return mainmenu.clickTopBtn(no, name, url, urlGubun);
			} else {
				return menu.clickTopBtn(no, name, url, urlGubun);
			}
		}
	}
	
	function onclickTopCustomMenu(no, name, url, urlGubun, lnbMenuNo, ssoYn) {
		
		var param = {};
		param.menuNo = no;
		param.menuNm = name;					
		
		$.ajax({
			type:"post",
			url: _g_contextPath_ + "/cmm/system/menuUseHistory.do",
			datatype:"json",
			data: param,
			success:function(data){
				if(data != null && data.sessionYn == null){
					location.href = "/gw/forwardIndex.do?maxSessionOut=Y";
				}else if(data != null && data.sessionYn == "N"){
					menu.fnRedirectLogon();
					return;
				}else {
					
					clearTimeout(menuSetTimeID);
					detailUrl = "";
					
					if(urlGubun == "link_pop"/*  || urlGubun == "link_iframe" */){
						menu.go(urlGubun, url, no, name, ssoYn);
						return;
					}
					
					$("#topMenuList").find("a[name=topMenu]").each(function(){
						$(this).removeClass("on");
					});
					$("#topMenu" + no).addClass("on");
					
					if(urlGubun == "WEHAGO") {
						$.ajax({ 
							type:"POST",
							url: '<c:url value="/linkWehagoSsoService.do"/>',
							data: "",
							async: false,
							datatype:"json",			  
							success:function(data){
								if(data.resultCode == "200") {
									var resultData = data.resultData;
									var wehagoDomain = resultData.mode === 'DEV' ? 'http://dev.wehago.com/#/sso/service' : 'https://wehago.com/#/sso/service';
									var serviceDomainUrl = wehagoDomain + '?security_param=' + resultData.securityParamEnc + '&software_name=' + 'bizbox' + '&domain=' + btoa(resultData.domain);
									console.log(serviceDomainUrl);
									window.open(serviceDomainUrl, '위하고 서비스');
								} else {
									Pudd.puddDialog({
										width: '400',
										height: '100',
										message: {
											type: 'error',
											content: 'WEHAGO와 연동되지 않았습니다.'
										}
									})	
								}
							}  
						});
					}else if(urlGubun == "one_contents"){
						$("#no").val(no);
						$("#name").val(name);
						$("#url").val(url);
						$("#urlGubun").val(urlGubun);
						$("#gnbMenuNo").val(no);
						$("#mainForward").val(ssoYn);
						form.action="oneContents.do";
						form.submit();
					}else if(urlGubun != "mail" && lnbMenuNo != ""){
						$("#no").val(no);
						$("#name").val(name);
						$("#url").val(url);
						$("#urlGubun").val(urlGubun);
						$("#mainForward").val('mainForward');
						$("#gnbMenuNo").val(no);
						$("#lnbName").val('');
						$("#lnbMenuNo").val(lnbMenuNo);
						$("#portletType").val('APPROVAL');
						$("#userSe").val('USER');
						form.action="bizbox.do";
						form.submit();			
					}else{
						onclickTopMenu(no, name, url, urlGubun);
					}
				}
			},
			error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
		});	
	}
	
	function changeMode(userSe) {
		if(doubleClickEventStat){
			doubleClickEventStat = false;			
			/* 함수가 잘 못 실행된 경우 상태값을 스스로 복원할 수 있도로 예외처리 적용 */
			/* 함수가 한번 수행 후 오류가 날 경우 doubleClickEventStat 값을 보완 하는 기능이 없기 때문에 별도 interval 처리 */
			/* 2018-01-10 김상겸 */
			var interval = setInterval(function(){
				doubleClickEventStat = true;
				clearInterval(interval);
			}, 1000);
			location.href = "changeUserSe.do?userSe="+userSe;
		}
	}
	
	
	function forwardPageByAlert(url, alertId, eventType, eventSubType, senderSeq, e){
		
		if(eventType == "TALK" || eventType == "MESSAGE"){
			
			$("#alertId").val(alertId);

	    	var pop_title = "mentionDetailPop.do" ;
	    	openWindow2("",  "mentionDetailPop.do", 500, 390, 1) ;
	        var frmData = document.detailPopForm ;
	        frmData.target = pop_title ;
	        frmData.action = "/gw/mentionDetailPop.do";
	        frmData.submit();
		}
		else{	
			
			var data = $(e).attr("data");
			data = JSON.parse(data);

			/*
			if(eventSubType == "PR001"){
				projectMove('project-1', data.prjSeq);
			}else if(eventSubType == "PR011"){
				projectMove('project-2', data.prjSeq);
			}else if(eventSubType == "PR013"){
				projectMove('project-3', data.prjSeq);
			}else
			*/
			
			if(eventSubType == "SC001"){
				scheduleMove(data.schSeq, data.schSeq);
			}else if(eventSubType == "RP001"){
				reportDetail(data.reportSeq, '1', data.kind);
			}else if(eventSubType == "RP002"){
				reportDetail(data.reportSeq, '1', data.kind);
			}else if(eventSubType == "RP003"){
				reportDetail(data.reportSeq, '1', data.kind);
			}else if(eventSubType == "EA101"){
				eapPop(url);
			}else if(eventSubType == "ED001"){
				edmsMove(data.dir_cd, data.artNo);
			}else if(eventSubType == "BO001"){
				if(data.cat_type == "B"){
					boardMove('board-4', data.boardNo, data.artNo);
				}else{
					boardMove('board-1', data.boardNo, data.artNo);
				}
			}else if(eventSubType == "BO002" || eventSubType == "BO004" || eventSubType == "BO007" || eventSubType == "BO009"){				
				var pop = openWindow2("/edms/home" + url,  "alertInfoPop", 1000, 800, 1) ;		    	
 		    	pop.focus();
			}else if(eventType == "EAPPROVAL"){
				eaDocMove(url, eventSubType);
			}else if(eventType == "ONEFFICE"){				
				var pop = openWindow2(data.doc_url, "alertInfoPop", 1000, 800, 1, 1) ;		    	
 		    	pop.focus();
			}
			
			else{
				if(url != ""){
	 				var urlGubun = "";
					
	 				if(eventType == "MAIL"){
						
	 				}else if(eventType == "PROJECT"){
	 					urlGubun = "project";
	 				}else if(eventType == "RESOURCE"){
	 					urlGubun = "schedule";
	 				}else if(eventType == "REPORT"){
	 					urlGubun = "schedule";
	 				}else if(eventType == "EAPPROVAL"){
	 					urlGubun = "${loginVO.eaType}";
	 				}else if(eventType == "BOARD"){
	 					urlGubun = "edms/board";
	 				}else if(eventType == "EDMS"){
	 					urlGubun = "edms/doc";
	 				}else if(eventType == "ATTEND"){
	 					if(eventSubType == "AT001" || eventSubType == "AT002" || eventSubType == "AT003")
	 						urlGubun = "attend";
	 					else
	 						urlGubun = "attend";
	 				}else if(eventType == "SCHEDULE"){
	 					urlGubun = "schedule";
	 				}
	 				
	 				var popUrl = (urlGubun == "") ? url : ("/" + urlGubun + "/" + url);
	 				
	 		    	var pop = openWindow2(popUrl,  "alertInfoPop", 1000, 800, 1) ;		    	
	 		    	pop.focus();
	 			}
			}

		}
		
		//해당알림 읽음처리				
		fnAlertRead(alertId);	
	}
	
	
	function eaDocMove(url, eventSubType){
		if(eventSubType == "EA001" || eventSubType == "EA003"){
			//접수문서도착, 접수문서재지정 -> 내접수함
			mainmenu.mainToLnbMenu('100000000', '', '/neos/edoc/delivery/receive/board/common/ReceiveBoardCommonList.do', 'ea', '', 'main', '100000000', '103020100', '<%=BizboxAMessage.getMessage("TX000010192","내접수함")%>', 'main');
		}else if(eventSubType == "EA002"){
			//과접수문서도착 -> 과접수대기함
			mainmenu.mainToLnbMenu('100000000', '', '/neos/edoc/delivery/receive/board/common/ReceiveDeptStandingList.do', 'ea', '', 'main', '100000000', '103020300', '<%=BizboxAMessage.getMessage("TX000010190","과접수대기함")%>', 'main');
		}else if(eventSubType == "EA004" || eventSubType == "EA005"){
			//배부문서도착, 배부문서재지정 -> 배부대기함
			mainmenu.mainToLnbMenu('100000000', '', '/neos/edoc/delivery/baebu/board/common/BaebuBoardCommonList.do', 'ea', '', 'main', '100000000', '103030100', '<%=BizboxAMessage.getMessage("TX000010187","배부대기함")%>', 'main');
		}else if(eventSubType == "EA006"){
			//발송문서도착 -> 발송대기함
			mainmenu.mainToLnbMenu('100000000', '', '/neos/edoc/delivery/send/board/common/SendBoardCommonList.do', 'ea', '', 'main', '100000000', '103010100', '<%=BizboxAMessage.getMessage("TX000010196","발송대기함")%>', 'main');
		}else{
	    	var pop = openWindow2("/${loginVO.eaType}/" + url,  "alertInfoPop", 1000, 800, 1) ;		    	
	    	pop.focus();
		}
				
	}
		
	function reportDetail(reportSeq, type, kind){
		var url = "/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&type="+type+"&kind="+kind;

  		openWindow2(url,  "pop", 1020, 600, 1) ;
	}
	
	
	
	function eapPop(urlPath) {
  		var url = "/${loginVO.eaType}" + urlPath;

  		openWindow2(url,  "pop", 1000, 711, 1) ;
  	}	
	
	function scheduleMove(pkSeq1, pkSeq2) {
  		var url = "/schedule/Views/Common/mCalendar/detail?seq="+pkSeq2;
  		openWindow2(url,  "pop", 833, 711,"yes", 1);
  		  		
  	}
	
	function boardMove(jobType, catSeq, artSeq) {  		
  		if(jobType == "board-1" || jobType == "board-3"){
  			var url = "/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq;
  			openWindow2(url,  "pop", 1200, 711,"yes", 1) ;
  		}else if(jobType == "board-2"){
  			var url = "/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq;
  			openWindow2(url,  "pop", 1200, 711,"yes", 1) ;
  		}else if(jobType == "board-4"){
  			var url = "/edms/board/viewBoard.do?boardNo="+catSeq+"&artNo="+artSeq;
  			openWindow2(url,  "pop", 1200, 711,"yes", 1) ;
  		}
  	}
	
	
	function edmsMove(wDirCd, artSeqNo) {
  		
  		var url = "/edms/doc/viewPost.do?dir_cd="+wDirCd+"&dir_lvl=3&dir_type=W&currentPage=1&artNo="+artSeqNo+"&dirMngYn=N&hasRead=Y&hasWrite=Y&searchField=&searchValue=&startDate=&endDate=";
  		openWindow2(url,  "pop", 1000, 711, "yes", 1) ;
  			
  	}

	
	/*
	function projectMove(jobType, pkSeq) {
  		
  		var projectType = "";
  		var projectSeq = "";
  		var workSeq = "";
  		var jobSeq = "";
  		var menuNo = "";
  		var type = "";
  		
  		if(jobType == "project-1"){
  			projectSeq = pkSeq;
  			menuNo = "401020000";
  			type = "P";
  		}else if(jobType == "project-2"){
  			workSeq = pkSeq;
  			menuNo = "401030000";
  			type = "W";
  		}else if(jobType == "project-3"){
  			jobSeq = pkSeq;
  			menuNo = "401040000";
  			type = "J";
  		}
  		
  		var url = "/project/Views/Common/project/projectView.do?pSeq="+projectSeq+"&wSeq="+workSeq+"&jSeq="+jobSeq+"&type="+type;
  		openWindow2(url,  "pop", 1100, 911, 1) ;
  	}*/
	
	function fnAlertRead(alertId){
		var tblParam = {};
		tblParam.alertId = alertId;
		
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/alertRead.do"/>',
			data: tblParam,
			async: false,
			datatype:"json",			  
			success:function(data){
				setTimeout("alertCntReflesh()", 500);	
			}  
		});
	}
	
	
	function alertCntReflesh(){		
		$.ajax({ 
			type:"post",
			url: _g_contextPath_ + "/alertUnreadCnt.do",
			datatype:"text",
			async: true,
			success:function(data){
				var alertNotifyYn = data.alertNotifyYn;
				if(data.alertMentionCnt > 0){
					$("#alertCnt").html("@");
					$("#newMentionIcon").addClass("new");
				}
				else if(alertNotifyYn == "Y"){												
					$("#alertCnt").html("N");
				}
				else{
					$("#alertCnt").html("");
					$("#alertCnt").attr("class","");
				}
				
				if(data.alertMentionCnt < 1){
					$("#newMentionIcon").removeClass("new");
				}
			},
			error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
		});
	}
	
	
	function forwardPage(alertSeq, menuGugun, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {

		if(lnbMenuNo == "934000001"){
		   	var left = (screen.width-958)/2;
		   	var top = (screen.height-753)/2;
		   	 
		   	var pop = window.open("/gw" + url, "certRequestPop", "width=690,height=370,left="+left+" top="+top);
		   	pop.focus();
			
			return;
		}
		
		menu.hideGbnPopup(this.Event);
		
		if (topType == 'timeline' || topType == 'mail' || urlGubun == 'mail') {
			if (urlGubun == 'ea' || urlGubun == 'eap' || (urlGubun == 'schedule' && url.search("report") > 0)) {
				window.open("../"+urlGubun+url);
				//window.close();
			}
			else {
				menu.moveAndReadCheck2(alertSeq, topType, menuGugun, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name);
			}
		}
		else {
			if (urlGubun == 'ea' || urlGubun == 'eap' || (urlGubun == 'schedule' && url.search("report") > 0)) {
				window.open("../"+urlGubun+url);
				//window.close();
			}
			else {
				menu.moveAndReadCheck(alertSeq, topType, menuGugun, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name);
			}
		}
	}
	
	function changeMainContent(target) {
		/*
		if (target == "timeline") {
			form.action="timeline.do";
		}
		else {
			form.action="userMain.do";
		}
		
		form.submit();
		*/
		
		if(target == "portal"){
			$("#pTap").addClass("on");
			$("#tTap").removeClass("on");
		}else{
			$("#pTap").removeClass("on");
			$("#tTap").addClass("on");
		}
		
		menu.timeline(target);
	}
	
	function changeTotalSearch() {
		if($("#tsearch").val() == "" || $.trim($("#tsearch").val()) == ""){
			alert("<%=BizboxAMessage.getMessage("TX000016039","검색어를 입력해주세요")%>!");
			$("#tsearch").focus();
			return;
		}
		var timestamp = new Date().getTime();
		$("#formSearch").attr('action', 'totalSearch.do?t=' + timestamp.toString());
		menu.totalsearch();
	}
	
	
	$(document).ready(function() {
		
		//forceLogoutCheck
		if(localStorage.getItem("forceLogoutYn") == "Y"){
			
			if("${forceLogoutYn}" == "N"){
				localStorage.removeItem("forceLogoutYn");
			}else{
				$("body").remove();
	            document.location.href = 'uat/uia/actionLogout.do';
	            alert("<%=BizboxAMessage.getMessage("TX000011986","보안설정으로 인해 자동 로그아웃 되었습니다.")%>");
	            localStorage.removeItem("forceLogoutYn");
	            return;			
			}			
		}
		
		//통합검색창 input 더미 태그 삭제 함수
		delDummyInputTag();
		
		var img = new Image(); 
		img.onload=function(){
			var innerHTML = "";
			if("${userSe}" == "USER")
				innerHTML = "<img src=\"${imgMap.orgPath}/IMG_COMP_LOGO_${loginVO.compSeq}.${imgMap.file_extsn}\" onerror=\"this.src='/gw/Images/temp/logo.png'\" alt=\"\" height=\"38\"/>";
			else
				innerHTML = "<img src=\"${imgMap.orgPath}/IMG_COMP_LOGO_${loginVO.compSeq}.${imgMap.file_extsn}\" onerror=\"this.src='/gw/Images/temp/logo_admin.png'\" alt=\"\" height=\"38\"/>";
			$("#logoImgHyperLink").html(innerHTML);
		} 
		
		img.onerror=function(){
			var innerHTML = "";
			if("${userSe}" == "USER")
				innerHTML = "<img src=\"/gw/Images/temp/logo.png\" onerror=\"this.src='/gw/Images/temp/logo.png'\" alt=\"\" height=\"38\"/>";
			else
				innerHTML = "<img src=\"${imgMap.orgPath}/IMG_COMP_LOGO_${loginVO.compSeq}.${imgMap.file_extsn}\" onerror=\"this.src='/gw/Images/temp/logo_admin.png'\" alt=\"\" height=\"38\"/>";		
			$("#logoImgHyperLink").html(innerHTML);
		} 
		img.src='${imgMap.orgPath}/IMG_COMP_LOGO_${loginVO.compSeq}.${imgMap.file_extsn}';		
		
		if("${groupMap.groupDomain}" == "${titleMap.compDomain}"){
			if("${titleMap.compDisplayName}" != "")
				document.title = "${titleMap.compDisplayName}";
			else if("${groupMap.groupDisplayName}" != "")
				document.title = "${groupMap.groupDisplayName}";
		}
		else{
			if("${titleMap.compDomain}" != "" && "${titleMap.compDisplayName}" != "")
				document.title = "${titleMap.compDisplayName}";
		}
		
		if("${mentionUseYn}" == "N"){
			$(".alert_box").focusout(function(e){
				if(!chkInOut){
					$(".alert_box").css("display", "none");
					alertBtn_Click();
				}
			});
		}
		
		
		if("${mentionUseYn}" == "Y"){
			$(".mention_alert_box").focusout(function(e){
				if(!chkInOut){
					$("body").off("click.mention_alert_box");
					$(".mention_alert_box").css("display", "none");
					alertBtn_Click();
				}
			});
		}else{
			$(".alert_box").focusout(function(e){
				if(!chkInOut){
					$(".alert_box").css("display", "none");
					alertBtn_Click();
				}
			});
		}
		
		$(".profile_comp_box").focusout(function(e){
			if(!chkInOut)
				$(".profile_comp_box").css("display", "none");
		});		
		
		$(".mymenu_box").focusout(function(e){
			if(!chkInOut)
				$(".mymenu_box").css("display", "none");
		});
		
		if("${mentionUseYn}" == "N"){
			$(".alert_box").on('mouseenter', function(){
				chkInOut = true;
			});
			
	 		$(".alert_box").on('mouseleave', function(){
				chkInOut = false;
			});
		}else{
			$(".mention_alert_box").on('mouseenter', function(){
				chkInOut = true;
			});
			$(".mention_alert_box").on('mouseleave', function(){
				chkInOut = false;
			});
		}
		

		
		
		
		$(".profile_comp_box").on('mouseenter', function(){
			chkInOut = true;
		});
		$(".profile_comp_box").on('mouseleave', function(){
			chkInOut = false;
		});		
		
		$(".mymenu_box").on('mouseenter', function(){
			chkInOut = true;
		});
		$(".mymenu_box").on('mouseleave', function(){
			chkInOut = false;
		});
		
		if(topType == "timeline") {
			$("#tTap").addClass('on');
		}
		else {
			$("#pTap").addClass('on');
		}
		
		<c:if test="${topType != 'mailex'}">
		// 알림 카운트 조회
		if("${mentionUseYn}" == "N"){
			menu.alertCnt();
			menu.alertPolling();	// 주기적으로 호출
		}else{
			menu.alertUnreadCnt();
			menu.alertUnreadPolling();	// 주기적으로 호출			
		}
		
		
		// edms는 서버가 다를수 있음.
		menu.edmsDomain = '${groupMap.edmsUrl}';		
		</c:if>
		
		<c:if test="${userSe == 'ADMIN' || userSe == 'MASTER'}">
			$("body").prop("class", "${bodyClass}");
		</c:if>
		
		<c:if test="${userSe == 'MASTER'}">
			$("body").addClass("master");
		</c:if>
		
		// 검색
		$(".search_btn").click(function(e){
			//readyInfo();
			changeTotalSearch();
		});
		
// 		// 열린 메뉴 다른 영역 클릭시 닫기
// 		$('.header_wrap').on("click", function(e){
// 			console.log("header_wrap click");
// 			//e.stopPropagation(); 
// 			if (popType != 1 && popType != 2) {
// 				menu.hideGbnPopup(0);
// 			}
// 		});
// 		$('.main_wrap').on("click", function(e){
// 			console.log("main_wrap click");
// 			//e.stopPropagation(); 
// 			if (popType != 1 && popType != 2) {
// 				menu.hideGbnPopup(0);
// 			}
// 		}); 
		
		$('iframe').on("click", function(e){
// 			console.log("iframe click");
			//e.stopPropagation(); 
			menu.hideGbnPopup(0);
		});
		
		//사진등록임시
		$(".phogo_add_btn").on("click",function(){
			$(".hidden_file_add").click();
		})
		
		$(".hidden_file_add").on("change",function (){
			
			/* IE 10 버젼 이하에서 작동이 안될 수 있음. 추후 다른 방법으로 변경 예정. */
			var formData = new FormData();
			var pic = $("#userPic")[0];
			
			formData.append("file", pic.files[0]);
			formData.append("pathSeq", "910");	//이미지 폴더
			formData.append("relativePath", ""); // 상대 경로
			 
	        menu.userImgUpload(formData, "userImg");

	    });
		
		//프로필팝업 온오프
		$(".divi_txt").on("mousedown",function(e){
// 			console.log("divi_txt click");
			popType = 1;
			menu.hideGbnPopup(popType);
			$(".profile_comp_box").toggle();
			$(".h_pop_box").focus();
			
			//chkInOut = true;
			e.preventDefault(); 
			setPositionList();
		}) 
		
// 	   //알림팝업 온오프
	   $(".alert_btn").on("mousedown",function(e){

		   $(".profile_comp_box").css("display", "none");
		   
		   popType = 2;
		   menu.hideGbnPopup(popType);
		   if("${mentionUseYn}" == "N"){
	 			$(".alert_box").toggle();			   
		   }else{
				$(".mention_alert_box").toggle();
				
				if($("#_content").length > 0) {
					
					$("body").css("overflow", "hidden");
					
					$("#_content").contents().find("body").click(function(e) {
						//console.log(!$(e.target).hasClass("alert_btn"), !$(".mention_alert_box").is(e.target), $(".mention_alert_box").has(e.target).length);
						if(!$(e.target).hasClass("alert_btn") && !$(".mention_alert_box").is(e.target) && $(".mention_alert_box").has(e.target).length == 0) {
							if($(".mention_alert_box").css("display") == "block") {
								chkInOut = false;
								$(".mention_alert_box").blur();
							}
						}
					});
				} 
				
				// 알림 팝업 생성시 바디태그에 클릭이벤트 추가한다.
				// 알림 팝업 태그의 focusout 이벤트가 정상 작동하지 않아 로직 추가 
				$("body").on("click.mention_alert_box", function(e) {
					//console.log(!$(e.target).hasClass("alert_btn"), !$(".mention_alert_box").is(e.target), $(".mention_alert_box").has(e.target).length);
					if(!$(e.target).hasClass("alert_btn") && !$(".mention_alert_box").is(e.target) && $(".mention_alert_box").has(e.target).length == 0) {
						if($(".mention_alert_box").css("display") == "block") {
							chkInOut = false;
							$(".mention_alert_box").blur();
						}
					}
				});
		   }
		   
		   $(".h_pop_box").focus();
		   chkInOut = true;
			
		   //e.stopPropagation();
		   e.preventDefault(); 
		   
		   alertBtn_Click();
		})
		
		
		// 	   //알림팝업 온오프
	   $("#alertCnt").on("mousedown",function(e){
		   
		   $(".profile_comp_box").css("display", "none");
		   
		   popType = 2;
		   menu.hideGbnPopup(popType);
		   if("${mentionUseYn}" == "N"){
	 			$(".alert_box").toggle();			   
		   }else{
				$(".mention_alert_box").toggle();
		   }
			$(".h_pop_box").focus();
			chkInOut = true;
			
		  // e.stopPropagation();
		   e.preventDefault(); 
		   
		   alertBtn_Click();
		})
		
		//나의메뉴팝업 온오프
	   $(".mymenu_btn").on("mousedown",function(e){
// 		   console.log("mymenu_btn click");
		   popType = 3;
		   menu.hideGbnPopup(popType);
		   
		  var mymenu_box = $(".mymenu_box").css("display");
		  
		  // 나의메뉴 데이터 호출
		  if (mymenu_box == 'none') {
			myMenu();
		  }
		   
			$(".mymenu_box").toggle();
			$(".mymenu_box").focus();
			chkInOut = true;
		   e.stopPropagation(); 
		});
		

		
		
		//컨텐츠를 클릭할때(컨텐츠에 타이틀도 포함)
		$(".list_con").on("click",function(){
			$(this).parent().removeClass("unread");
		});
		
		//접고 펼치기
		$(".toggle_btn").on("click",function(){
			$(this).toggleClass("down");
			$(this).parent().parent().find(".sub_detail").removeClass("animated1s fadeIn").toggleClass("animated1s fadeIn").toggle();
			
			//멘션 접고 펼치기
			if($(this).hasClass("down")){
				$(this).parent().parent().find(".mention_detail").removeClass("ellipsis").toggleClass("animated1s fadeIn");
			}else{
				$(this).parent().parent().find(".mention_detail").removeClass("animated1s fadeIn").toggleClass("ellipsis");
			}
		});
		
		
		if("${loginVO.userSe}" != "ADMIN"){		
	
	        $(".more_div").mouseover(function () {
	            $(".more_div").show();
	            $(".top_menu .more_btn > a").parent().addClass("on");
	        });
	        $(".more_div").mouseout(function () {
	            $(".more_div").hide();
	            $(".top_menu .more_btn > a").parent().removeClass("on");
	        });
	
	
	        /*메뉴내용 더보기 팝업으로 복사*/
	        $("#more_div_ul").html("");
	        var menuCln = $(".top_menu ul li").clone();
	        $("#more_div_ul").html(menuCln); //.html();
	
	        mainMenuSize();
		}
		
		<c:if test="${firstGnbRenderTp == 'SSO' && cloudYn == 'Y' && bizboxCloudNoticeInfo != ''}">
		setTimeout("fnCloudNoticePop();", 2000);
		</c:if>			
		
	});  
	
	<c:if test="${firstGnbRenderTp == 'SSO' && cloudYn == 'Y' && bizboxCloudNoticeInfo != ''}">
	
	function fnCloudNoticePop(){
		
		var bizboxCloudNoticeStr = "${bizboxCloudNoticeInfo}";
		
		if(localStorage.getItem("bizboxCloudNoticeInfo") == null)
			localStorage.setItem("bizboxCloudNoticeInfo", "");
			
		var bizboxCloudNoticeInfo = localStorage.getItem("bizboxCloudNoticeInfo");
		
		var bizboxCloudNoticeAlert = false;
		
		if(bizboxCloudNoticeInfo != ""){
			
    		$.each(bizboxCloudNoticeStr.split("|"), function (index, item) {
    			
    			if(bizboxCloudNoticeInfo.indexOf("|" + item + "|") < 0){
    				bizboxCloudNoticeAlert = true;
    			}
    			
    		});    		
			
		}else{
			bizboxCloudNoticeAlert = true;
		}
		
		if(bizboxCloudNoticeAlert){
			
	    	$.ajax({ 
		        type: "POST", 
		        url: "/gw/api/getGcmsNoticeList.do",
		        data:{reqType : "pop" },
		        async: true,
		        success: function (data) {
		        	if(data.GcmsNoticePopList != null){
		        		if(data.GcmsNoticePopList.length == 0){
		        			localStorage.setItem("bizboxCloudNoticeInfo", "");
		        			return;
		        		}
		        		
		        		//공지사항 팝업처리
		            	for(var i=0; i<data.GcmsNoticePopList.length; i++){	    		
		            		if(bizboxCloudNoticeInfo.indexOf("|" + data.GcmsNoticePopList[i].seq + "|") < 0){
		        					noticeAutoPop(data.GcmsNoticePopList[i], "Y");
		            		}
		            	}
		        	}
		        },
		        error:function (e) {
		        	console.log(e);
		        }
			});
		}
	}
	
	var cloudNoticeCnt = 1;
	
	function noticeAutoPop(data, popYn){
		
	    var windowY = (window.top.outerHeight / 2 + window.top.screenY - ( 565 / 2));
	    var windowX = (window.top.outerWidth / 2 + window.top.screenX - ( 670 / 2));
	    
    	windowY = windowY + (cloudNoticeCnt*50);
    	windowX = windowX + (cloudNoticeCnt*50);
    	cloudNoticeCnt++;
	    
    	window.open("", "noticeAutoPop_" + data.seq, "width=800,height=562,toolbar=no,directories=no,menubar=no,status=no,resizable=no,scrollbars=no,top=" + windowY + ",left=" + windowX);

    	var frmData = document.cloudNoticePop ;
        frmData.target = "noticeAutoPop_" + data.seq ;
		frmData.seq.value = data.seq;
		frmData.title.value = data.title;
		frmData.contents.value = data.contents;
		frmData.create_by.value = data.create_by;
        frmData.create_dt.value = data.create_dt;
        frmData.pop_yn.value = popYn;
		frmData.submit();
	}		
	
	</c:if>		
	
	
	function myMenu() {
		 menu.myMenu();
	}
	 
	<c:if test="${userSe == 'MASTER' }">
	function changeCompany(seq) {
		$.ajax({ 
			type:"post",
			url: _g_contextPath_ + "/cmm/systemx/compChangeProc.do",
			data:{compSeq : seq}, 
			datatype:"json",			  
			success:function(data){								
				if (data.result) {
					if (topType != 'main') {
						menu.contentReload();
					}
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000010959","회사 변경 실패")%>");	
				}
			}  
		});  
	}
	</c:if>
	
	function alertBtn_Click(){
		if("${mentionUseYn}" == "N"){
			// 알림 버튼 클릭시 알림 리스트 조회
			var alert_box = $(".alert_box").css("display");
			if (alert_box == 'block' || alert_box == '') {
			    menu.alertInfo();
			}
		}else{
			// 알림 버튼 클릭시 알림 리스트 조회
//	 		var alert_box = $(".alert_box").css("display");
			var mention_alert_box = $(".mention_alert_box").css("display");
			if (mention_alert_box == 'block' || mention_alert_box == '') {
			    menu.alertInfo();
			}
		}		
	}
	
	function setAlertRemoveNew(){
		$("#allAlertRead").hide();
		$("li[name=li_item]").attr("class","");
		$("li[name=li_item]").find("span.ico_new").remove();
		$("#alertCnt").attr("class", "");
		$("#alertCnt").html("");
	}
	 
	// 비밀번호 변경 팝업 호출
	function fn_pwdPop(type){
			var url = "/gw/cmm/systemx/myinfoPwdModPop.do?type="+type;
	    	var pop = window.open(url, "myinfoPwdModPop", "width=500,height=390,scrollbars=yes");    		
	}
	
	function fn_masterAuthPage(){
		mainmenu.mainToLnbMenu('1900000000', '<%=BizboxAMessage.getMessage("TX000007033","시스템설정")%>', '', 'gw', '', 'main', '1900000000', '1903050000', '<%=BizboxAMessage.getMessage("TX000013533","마스터권한설정")%>', 'main');
	}
	
	
	/* double click 방지 */
	var doubleClickEventStat = true;
	
	function changeEmpPosition(target){
		if(doubleClickEventStat){		
			doubleClickEventStat = false;
			
			/* 함수가 잘 못 실행된 경우 상태값을 스스로 복원할 수 있도로 예외처리 적용 */
			/* 함수가 한번 수행 후 오류가 날 경우 doubleClickEventStat 값을 보완 하는 기능이 없기 때문에 별도 interval 처리 */
			/* 2018-01-10 김상겸 */
			var interval = setInterval(function(){
				doubleClickEventStat = true;
				clearInterval(interval);
			}, 1000);
			var curTr = "${loginVO.organId}" + "${loginVO.orgnztId}";
			if(curTr != target.id){
				document.changeUserPositionProcForm.action = "systemx/changeUserPositionProc.do";
				document.changeUserPositionProcForm.seq.value = $("#"+target.id).attr("seq");
				document.changeUserPositionProcForm.submit();
				mailSessionReset();
			}
		}
	}
	
	function mailSessionReset(){
		if("${loginVO.url}" != ""){
			$.ajax({
				type: "POST", 
		        url: "${loginVO.url}sessionInit.do",
		        async: true,
		        dataType: "json",
		        success: function (result) {
		        },  
		        error:function (e) {
		        }
			});			
		}
	}
	
	function setPositionList(){
		if("${userSe}" == "USER" || "${userSe}" == "ADMIN"){
			
			if(!empDeptFlag){
				empDeptFlag = true;
				$.ajax({
					type: "POST"
					, url: '<c:url value="/getPositionList.do" />'
					, success: function(result) {			
						var innerHTML = "";	
						
						if(result != null && result.positionList == null){
							location.href = "/gw/forwardIndex.do?maxSessionOut=Y";
						}else{
							for(var i=0;i<result.positionList.length;i++){
								var positionData = result.positionList[i];
								var boldTag = "";
								
								//주회사인 경우 볼드처리
								if(positionData.mainCompYn == "Y"){
									boldTag = " fwb";
								}
														
								if("${topType}" == "mailex"){
									innerHTML += "<tr class='positionList" + boldTag + "' id='" + positionData.empCompSeq + positionData.deptSeq + "' onclick='changeEmpPosition(this);' deptSeq='" + positionData.deptSeq + "' compSeq='" + positionData.empCompSeq + "' seq='" + positionData.seq + "'>";
									innerHTML += "<td>" + positionData.compName + "</td>";
									innerHTML += "</tr>";											
								}else if("${loginVO.eaType}" == "ea"){
									innerHTML += "<tr class='positionList" + boldTag + "' id='" + positionData.empCompSeq + positionData.deptSeq + "' onclick='changeEmpPosition(this);' deptSeq='" + positionData.deptSeq + "' compSeq='" + positionData.empCompSeq + "' seq='" + positionData.seq + "'>";
									innerHTML += "<td>" + positionData.compName + "</td>";
									innerHTML += "<td>" + positionData.deptName + "</td>";
									innerHTML += "<td>" + positionData.eapproval + "</td>";
									innerHTML += "</tr>";			
								}else{
									innerHTML += "<tr class='positionList' id='" + positionData.empCompSeq + positionData.deptSeq + "' onclick='changeEmpPosition(this);' deptSeq='" + positionData.deptSeq + "' compSeq='" + positionData.empCompSeq + "' seq='" + positionData.seq + "'>";
									innerHTML += "<td class='" + boldTag + "'>" + positionData.compName + "</td>";
									innerHTML += "<td>" + positionData.eapproval + "</td>";
									innerHTML += "<td>" + positionData.eapprovalRef + "</td>";
									innerHTML += "</tr>";
								}
							}		
							$("#empPositionInfo").append(innerHTML);
							$("#positionSpinImg").remove();
		
							if("${userSe}" != "MASTER"){
							    var table = document.getElementById("empPositionInfo");
								var tr = table.getElementsByTagName("tr");
								for(var i=0; i<tr.length; i++)
									tr[i].style.backgroundColor = "white";
								var curTr = document.getElementById("${loginVO.organId}" + "${loginVO.orgnztId}");
								curTr.style.backgroundColor = "#E6F4FF";
						   }
						}
					}				
					, error: function(result) {
						//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
					}
				});
			}
		}
	}
	
	
	function fnMailMove(mailUid,recvEmail,url,alertId) {
		
		var targetUrl = url.replace("{0}", "muid=" + mailUid);
		targetUrl = targetUrl.replace("{1}", "email=" + recvEmail);
		
		if(targetUrl.indexOf("/mail2/") != -1){
			targetUrl = compMailUrl + targetUrl.substring(targetUrl.indexOf("/mail2/")+7);			
		}
		
		var gwDomain = window.location.host + (window.location.port == "" ? "" : (":" + window.location.port));
		var pop = openWindow2(targetUrl + "&seen=0&userSe=USER&gwDomain=" + gwDomain,"readMailPopApi",1020,700,1,1);
		pop.focus();
		
    	//해당알림 읽음처리				
		fnAlertRead(alertId);
	}
	
	
	function tabClick(target){
		if(target == "A"){
			$("#allReadBtn").css("display","");
			if($(".alertDiv").length == 0){
				$("#noDate").css("display","");
			}else{
				$("#noDate").css("display","none");
			}
		}
		else if(target == "M"){
			$("#allReadBtn").css("display","none");
			if($(".mentionDiv").length == 0){
				$("#noDate").css("display","");
			}else{
				$("#noDate").css("display","none");
			}
		}
	}
	
	function closeAlertPop(){
		if(mentionUseYnFlag == "Y"){
			$(".mention_alert_box").css("display", "none");
		}else{
			$(".alert_box").css("display", "none");
		}
	}
	
	function closeProfilePop(){
		$(".profile_comp_box").css("display", "none");
	}
	
	function delDummyInputTag() {
		setTimeout(function(){
			$("#dummyTag").remove();
		}, 3000);
	}
</script>

<c:if test="${ScriptAppendYn == 'Y'}">
	<c:if test="${ScriptAppendUrl != '99' && TokTokSSLUseYn != 'Y'}">
	<script language="javascript" src="${ScriptAppendUrl}"></script>
	</c:if>
	
	<c:if test="${ScriptAppendFunction != '99' && TokTokSSLUseYn != 'Y'}">
	<div style="width:100%; background-color: white;">
		<script language="javascript">${ScriptAppendFunction}</script>
	</div>	
	</c:if>	
</c:if>


<c:if test="${TokTokSSLUseYn == 'Y'}">
	<jsp:include page="/html/toktok/GroupPortal_GNB.html" />
</c:if>

<!-- header_top_wrap -->
		<div class="header_top_wrap">
			<div class="header_top">
				<!-- logo -->
				<h1 class="logo">
					<c:if test="${topType == 'mailex'}"> <!-- 메일전용 계정 추가 -->
						<a href="<c:url value='/bizboxMailEx.do' />" title="<%=BizboxAMessage.getMessage("TX000000013","메인")%>" id="logoImgHyperLink">						
						
						</a>
					</c:if>
					<c:if test="${topType != 'mailex'}"> <!-- 메일전용 계정 추가 -->
						<a href="<c:url value='${mainPage}' />" title="<%=BizboxAMessage.getMessage("TX000000013","메인")%>" id="logoImgHyperLink">						
						
						</a>
					</c:if>
				</h1>
				<div class="top_menu">
				<p class="more_btn" style="display:none;"><a href="#n"><span class="arr"><%=BizboxAMessage.getMessage("TX000006348","더보기")%></span></a></p>				
				<!-- global nav -->
				<ul class="nav" id="topMenuList"> 
					<c:forEach items="${topMenuList}" var="list" varStatus="c">
						<c:if test="${topType ne 'mailex'}"> <!-- 메일전용 계정 추가 -->
							<li><a href="javascript:onclickTopCustomMenu(${list.menuNo},'${list.name }', '${list.urlPath}', '${list.urlGubun}', '${list.lnbMenuNo}', '${list.ssoUseYn}');" class="nav${c.count}" title="${list.name }" id="topMenu${list.menuNo}" name="topMenu">${list.name }</a></li>
						</c:if>
					</c:forEach>
				</ul>
                </div>
				<!--더보기 메뉴-->
					<div class="more_div" style="display:none;">
						<ul id="more_div_ul">
						  
						</ul>
					</div>
				<!--//더보기 메뉴-->		
				
			</div> 
		</div>
		
		<!-- header_sub_wrap -->
		<div class="header_sub_wrap">
			<div class="header_sub">
			
				<c:if test="${userSe == 'USER' && (topType == 'main' || topType == 'timeline' || topType == 'tsearch')}">
				<!-- contents tab -->
					<ul class="con_tab">
				   		<li id="pTap" class=""><a href="javascript:;" class="con_tab1" onClick="changeMainContent('portal');" title="<%=BizboxAMessage.getMessage("TX000002978","회사포털")%>"><%=BizboxAMessage.getMessage("TX000002978","회사포털")%></a></li>
				   		<c:if test="${mentionUseYn == 'Y'}">
						<li id="tTap" class=""><a href="javascript:;" class="con_tab2" onClick="changeMainContent('timeline');" title="<%=BizboxAMessage.getMessage("TX000021503","통합알림")%>"><%=BizboxAMessage.getMessage("TX000021503","통합알림")%></a></li>
						</c:if>
						<c:if test="${mentionUseYn == 'N'}">
						<li id="tTap" class=""><a href="javascript:;" class="con_tab2" onClick="changeMainContent('timeline');" title="<%=BizboxAMessage.getMessage("TX000007364","타임라인")%>"><%=BizboxAMessage.getMessage("TX000007364","타임라인")%></a></li>
						</c:if>
					</ul>
				</c:if>
				
				<!-- user misc -->
				<div class="misc">    
					<!-- 프로필 -->
					<div class="profile_wrap">
						<div class="bg_pic"></div>
						<c:if test="${not empty optionValue && optionValue != 'null'}">
							<c:if test="${not empty displayPositionDuty && displayPositionDuty == 'position'}">
								<span class="divi_img"><img class="userImg" src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" alt="" onerror="this.src='/gw/Images/temp/pic_Noimg.png'" /></span><a href="#n" class="divi_txt">${empPathNm}${empPathNm eq "" ? "" : "-"}${empNameInfo} <c:if test="${not empty loginVO.positionNm && loginVO.positionNm != 'null'}">${loginVO.positionNm}</c:if></a>
							</c:if>
							<c:if test="${not empty displayPositionDuty && displayPositionDuty == 'duty'}">
								<span class="divi_img"><img class="userImg" src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" alt="" onerror="this.src='/gw/Images/temp/pic_Noimg.png'" /></span><a href="#n" class="divi_txt">${empPathNm}${empPathNm eq "" ? "" : "-"}${empNameInfo} <c:if test="${not empty loginVO.classNm && loginVO.classNm != 'null'}">${loginVO.classNm}</c:if></a>
							</c:if>
						</c:if>
						<c:if test="${empty optionValue || optionValue == 'null'}">
							<c:if test="${empty displayPositionDuty || displayPositionDuty == 'position'}">
								<span class="divi_img"><img class="userImg" src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" alt="" onerror="this.src='/gw/Images/temp/pic_Noimg.png'" /></span><a href="#n" class="divi_txt">${loginVO.orgnztNm}-${empNameInfo} <c:if test="${not empty loginVO.positionNm && loginVO.positionNm != 'null'}">${loginVO.positionNm}</c:if></a>
							</c:if>
						</c:if>
						<!-- 팝업::프로필 --> 
						<div class="header_pop_wrap profile_comp_box" style="display:none;">  
							<div class="h_pop_box" id="profileInfo" tabindex="1" style="outline: none;"> 
								<div class="pop_shape"></div> 
								<div class="con"> 	  
									<div class="profile_top">
										<!-- 프로필사진 -->
										<div class="profile_pic">
											<div class="circle_bg"></div>
											<span class="divi_pic"><img class="userImg" src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" onerror="this.src='/gw/Images/temp/pic_Noimg.png'" alt="" /></span>
											<c:if test="${profileModifyOption == 1}">
											<a href="javascript:;" class="phogo_add_btn" title="<%=BizboxAMessage.getMessage("TX000016042","프로필사진등록")%>"><img src="<c:url value='/Images/btn/profile_photo_add.png' />" alt="프로필사진등록" /></a>
											<input type="file" id="userPic" class="hidden_file_add" name="userPic" style="position:absolute;top:-1000px;" />
											</c:if>										
										</div>
										<!-- 프로필정보 -->
										<div class="profile_info">
											<dl class="clear">
												<dt class="mr5"><%=BizboxAMessage.getMessage("TX000016044","현재 접속 IP")%> :</dt>
												<dd id="" class="text_blue fwb">${loginVO.ip}</dd>
												<dd class="ml5"></dd>
											</dl>
											<span class="txt_nm">${loginVO.name}<span>(${loginVO.id})</span> 
												<span>
													<c:if test="${not empty displayPositionDuty && displayPositionDuty == 'position'}">
														<c:if test="${not empty loginVO.positionNm && loginVO.positionNm != 'null'}">${loginVO.positionNm}</c:if>
													</c:if>
													<c:if test="${not empty displayPositionDuty && displayPositionDuty == 'duty'}">
														<c:if test="${not empty loginVO.classNm && loginVO.classNm != 'null'}">${loginVO.classNm}</c:if>
													</c:if>
												</span>
											</span> 
										</div>
									</div>
									<c:if test="${userSe ne 'MASTER' }">
										<p class="tit_p mt10 ml10">
											<%=BizboxAMessage.getMessage("TX000016060","회사정보")%>
											<img id="positionSpinImg" src="/gw/Images/ajax-loader.gif" style="width: 20px;">
										</p>
										
										<!-- 메일전용  -->
										<c:if test="${topType == 'mailex'}">
										<div class="ml10 mr10" id="" style="display:block;">
											<div class="com_ta2 ova_sc cursor_p bg_lightgray mb10" style="height:222px;">
												<table id="empPositionInfo">
													<colgroup>
														<col width="100%"/>
													</colgroup>
													<tr>
														<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
													</tr>
												</table>
											</div>
										</div>										
										</c:if>
										
										<c:if test="${topType != 'mailex'}">
										<!-- 영리  -->
										<c:if test="${loginVO.eaType ne 'ea' }">
											<div class="ml10 mr10" id="" style="display:block;">
												<div class="com_ta2 ova_sc cursor_p bg_lightgray mb10" style="height:222px;">
													<table id="empPositionInfo">
														<colgroup>
															<col width="40%"/>
															<col width=""/>
															<col width=""/>
														</colgroup>
														<tr>
															<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
															<th><%=BizboxAMessage.getMessage("TX000003976","미결")%></th>
															<th><%=BizboxAMessage.getMessage("TX000000421","수신참조")%></th>
														</tr>
													</table>
												</div>
											</div>
										</c:if>
										<!-- 비영리  -->
										<c:if test="${loginVO.eaType eq 'ea' }">
											<div class="ml10 mr10" id="">
												<div class="com_ta2 ova_sc cursor_p bg_lightgray mb10" style="height:222px;">
													<table id="empPositionInfo">
														<colgroup>
															<col width="50%"/>
															<col width=""/>
															<col width=""/>
														</colgroup>
														<tr>
															<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
															<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
															<th><%=BizboxAMessage.getMessage("TX000010935","대기")%></th>
														</tr>						
													</table>
												</div>
											</div>
										</c:if>
										</c:if>
										
									</c:if>
								</div>
								<c:if test="${userSe eq 'MASTER' }">
								<c:if test="${userType eq 'MASTER' }">
								<div class="bot">
									<div class="btn_cen pt12">
										<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000016045","패스워드변경")%>" onclick="fn_pwdPop('def');"/>
										<input type="button" value="<%=BizboxAMessage.getMessage("TX000002980","로그아웃")%>" onclick="javascript:main.userLogout();"/>
									</div>
								</div>
								</c:if>
								<c:if test="${userType eq 'USER' }">
								<div class="bot">
									<div class="btn_cen pt12">
										<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000016046","마스터 권한 변경")%>" onclick="fn_masterAuthPage();"/>
										<input type="button" value="<%=BizboxAMessage.getMessage("TX000002980","로그아웃")%>" onclick="javascript:main.userLogout();"/>
									</div>
								</div>
								</c:if>
								
								</c:if>
								<c:if test="${userSe ne 'MASTER' }">
								<c:if test="${userSe eq 'USER' }">
									<div class="bot">
										<div class="btn_cen pt12">
											<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000007440","화면설정")%>" onclick="readyInfo()" style="display: none;"/>
											<input type="button" class="gray_btn" onclick="onclickTopMenu('800000000','<%=BizboxAMessage.getMessage("TX000002986","마이페이지")%>', '', 'gw')" value="<%=BizboxAMessage.getMessage("TX000002986","마이페이지")%>"/>
											<input type="button" value="<%=BizboxAMessage.getMessage("TX000002980","로그아웃")%>" onclick="javascript:main.userLogout();"/>
										</div>
									</div>
								</c:if>
								<c:if test="${userSe eq 'ADMIN' }">
									<div class="bot">
										<div class="btn_cen pt12">
											<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000007440","화면설정")%>" onclick="readyInfo()" style="display: none;"/>
											<input type="button" class="gray_btn" onclick="onclickTopMenu('920000000','<%=BizboxAMessage.getMessage("TX000002986","마이페이지")%>', '', 'gw')" value="<%=BizboxAMessage.getMessage("TX000002986","마이페이지")%>"/>
											<input type="button" value="<%=BizboxAMessage.getMessage("TX000002980","로그아웃")%>" onclick="javascript:main.userLogout();"/>
										</div>
									</div>
								</c:if>
								</c:if>
							</div>
						</div><!-- //팝업::프로필종료 -->
						
					</div>
					
					<!-- 기타버튼 -->
					<div class="fn_wrap">
						<ul class="fn_list">
						<c:if test="${topType != 'mailex'}"> <!-- 메일전용 계정 -->
							<li class="firstbar"></li>
							<li>
								<a href="javascript:;" id="" class="alert_btn" title=""></a><span id="alertCnt"></span>
								<!-- 팝업::알림 -->
								<c:if test="${mentionUseYn == 'Y'}">
								<div class="header_pop_wrap mention_alert_box" style="display:none;">
									<div class="m_pop_box">
										<div class="m_pop_shape"></div>
										<div class="m_pop_t">
<!-- 											<img id="alertSpinImg" src="/gw/Images/ajax-loader.gif" style="width: 20px;"> -->
											<!-- 알림 탭 -->
											<ul class="alert_tab clear">
												<li id="alertAll" class="on" onclick="tabClick('A')">
													<a href="#n" class="tab01">
														<span class="ico"></span>
														
														<span class="txt"><%=BizboxAMessage.getMessage("TX000000893","알림")%></span>
														<span class="" id="newIcon"></span>
													</a>
												</li>
												<li id="mentionAlert" onclick="tabClick('M')">
													<a href="#n" class="tab02">
														<span class="ico"></span>
														<span class="" id="newMentionIcon"></span>
														<span class="txt"><%=BizboxAMessage.getMessage("TX000023088","멘션")%></span>
													</a>
												</li>
											</ul>
											
											<!-- 공통 바 -->
											<div class="btn_div m0 pt5 pb5">
												<div class="right_div mr15">
													<div class="fl mt4 mr10">
														<input type="checkbox" name="inp_chk" id="allOpen" class="" onclick="allOpen();">&nbsp;<label for="allOpen" style="margin-top: 4px;"><%=BizboxAMessage.getMessage("TX900000352","펼쳐보기")%></label>
													</div>
													<div id="" class="controll_btn p0 fl">
														<button id="allReadBtn" onclick="allRead();"><%=BizboxAMessage.getMessage("TX000007681","전체읽음")%></button>
													</div>
												</div>
											</div>
										</div>	
										<div class="m_pop_c scroll_y_on" style="height:500px;" id="alertBox" >
											
										</div>
									</div>
								</div>
								</c:if>
								<c:if test="${mentionUseYn == 'N'}">
								<div class="header_pop_wrap alert_box" style="display:none;" onmouseleave="closeAlertPop();">
    								<div class="h_pop_box" id="alertInfo" tabindex="2" style="outline: none;">
										<div class="pop_shape"></div>
										<div class="pop_t">
											<h3>
												<%=BizboxAMessage.getMessage("TX000000893","알림")%> 
												<img id="alertSpinImg" src="/gw/Images/ajax-loader.gif" style="width: 20px;">
											</h3>
											<input id="allAlertRead" onclick="fnRemoveNew();" style="display:none; margin-top: -24px;float: right;" type="button" value="<%=BizboxAMessage.getMessage("TX000007681","전체읽음")%>" >
										</div>
										<div class="pop_c" id="alertBox"></div> 
									</div>
								</div>
								</c:if>								
							</li>
							</c:if>
						</ul>
					</div> 
					<!-- 검색 -->
				 	<c:if test="${totalSearchOptionValue == '1' && userSe == 'USER' && topType != 'tsearch' && topType != 'mailex'}">
						<div class="">
							<input id="dummyTag" type="password" style="display:none;" disabled/>
							<input type="text" class="search" id="tsearch" onkeydown="if(event.keyCode==13){javascript:changeTotalSearch();}"/>
							<a href="#" class="search_btn"  title="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"><%=BizboxAMessage.getMessage("TX000001289","검색")%></a>
						</div>
					</c:if>
					
					<c:if test="${userSe == 'USER' && topType != 'mailex'}"> <!-- 메일전용 계정 추가 -->
						 <div class="">  
						 <c:if test="${isAdminAuth == true}"> 
						 <a href="#" onclick="changeMode('ADMIN')" class="fn_btn" title="<%=BizboxAMessage.getMessage("TX000000705","관리자")%>"><%=BizboxAMessage.getMessage("TX000000705","관리자")%></a>
						 </c:if>
						 <c:if test="${isMasterAuth == true}"> 
						 <a href="#" onclick="changeMode('MASTER')" class="fn_btn" title="<%=BizboxAMessage.getMessage("TX000016047","마스터")%>"><%=BizboxAMessage.getMessage("TX000016047","마스터")%></a>
						 </c:if>
						 </div>  
					</c:if>		

					<c:if test="${userSe == 'ADMIN' && topType != 'mailex'}">  <!-- 메일전용 계정 추가 -->
						 <div class="">  
						 <a href="#" onclick="changeMode('USER')" class="fn_btn" title="<%=BizboxAMessage.getMessage("TX000000286","사용자")%>"><%=BizboxAMessage.getMessage("TX000000286","사용자")%></a>
						 <c:if test="${isMasterAuth == true}"> 
						 <a href="#" onclick="changeMode('MASTER')" class="fn_btn" title="<%=BizboxAMessage.getMessage("TX000016047","마스터")%>"><%=BizboxAMessage.getMessage("TX000016047","마스터")%></a>
						 </c:if>
						 </div>  
					</c:if>
					
					<c:if test="${userSe == 'MASTER' && topType != 'mailex'}">  <!-- 메일전용 계정 추가 -->
						 <div class="">  
						 <a href="#" onclick="changeMode('USER')" class="fn_btn" title="<%=BizboxAMessage.getMessage("TX000000286","사용자")%>"><%=BizboxAMessage.getMessage("TX000000286","사용자")%></a>
						 <c:if test="${isAdminAuth == true}"> 
						 <a href="#" onclick="changeMode('ADMIN')" class="fn_btn" title="<%=BizboxAMessage.getMessage("TX000000705","관리자")%>"><%=BizboxAMessage.getMessage("TX000000705","관리자")%></a>
						 </c:if>
						 </div>  
					</c:if>													
			</div>
		</div> 
</div>
<form id="formSearch" name="formSearch" action="totalSearch.do?t=" method="post">  
	<input type="hidden" id="tsearchKeyword" name="tsearchKeyword" value="" />
	<input type="hidden" id="gnbBoardType" name="gnbBoardType" value="1" />
</form>

<form name="detailPopForm" id="detailPopForm" method="post">
    <input type="hidden" name="alertId" id="alertId" value="" />
</form>

<form name="changeUserPositionProcForm" id="changeUserPositionProcForm" method="post">
    <input type="hidden" name="seq" id="seq" value="" />
</form>

<form name="reLogonProcForm" id="reLogonProcForm" method="post">
	<input type="hidden" name="compSeq" id="compSeq" value="${loginVO.compSeq}" />
	<input type="hidden" name="deptSeq" id="deptSeq" value="${loginVO.orgnztId}" />
	<input type="hidden" name="groupSeq" id="groupSeq" value="${loginVO.groupSeq}" />
	<input type="hidden" name="empSeq" id="empSeq" value="${loginVO.uniqId}" />
	<input type="hidden" name="userSe" id="userSe" value="${loginVO.userSe}" />
	<input type="hidden" name="type" id="type" value="def" />
	<input type="hidden" name="encPasswdOld" id="encPasswdOld" value="" />
	<input type="hidden" name="langCode" id="langCode" value="" />	
</form>

<c:if test="${firstGnbRenderTp == 'SSO' && cloudYn == 'Y' && bizboxCloudNoticeInfo != ''}">
<form id="cloudNoticePop" name="cloudNoticePop" method="post" action="/gw/GcmsNoticeListPop.do" target="popup_window">
	<input name="seq" value="" type="hidden"/>
	<input name="title" value="" type="hidden"/>
	<input name="contents" value="" type="hidden"/>
	<input name="create_by" value="" type="hidden"/>
	<input name="create_dt" value="" type="hidden"/>
	<input name="pop_yn" value="" type="hidden"/>
</form>	
</c:if>	