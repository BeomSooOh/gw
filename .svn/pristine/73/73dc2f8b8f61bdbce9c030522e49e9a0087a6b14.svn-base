<%@page import="neos.cmm.util.code.CommonCodeSpecific"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
<%@page import="main.web.BizboxAMessage"%>

<%
/**
 * 
 * @title Neos 로그인 화면 
 **/
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta property="og:title" content="${groupDisplayName}" />
	<meta property="og:description" content="${txtMap.display_text}" />
	<c:if test="${empty logoMap}">
	<meta property="og:image" content="${pageContext.request.getScheme()}://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}/gw/Images/temp/douzone_logo.png?date=191118" />
	</c:if>
	<c:if test="${!empty logoMap}">
	<meta property="og:image" content="${pageContext.request.getScheme()}://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}${logoPath}" />
	</c:if>    
    <title>${groupDisplayName}</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/portlet/css/pudd.css?ver=20201021">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css?ver=20201021"/>
    
    <!--css-->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main.css?ver=20201021" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css?ver=20201021" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css?ver=20201021" />
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.22.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/common.js?ver=20201021"></script> 
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/aes.js?ver=20201021"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/secondCert.js?ver=20200923"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/neos/NeosUtil.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/securityEncUtil.js"></script>
	
	
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/mCustomScrollbar/jquery.mCustomScrollbar.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>
	
    <script>
   
    var ScTargetEmpSeq = "${ScTargetEmpSeq}";
	var secondCertSeq = "${seq}";
	var secondCertType = "${type}";
	var secondCertQrData = "${qrData}";
	var scGroupSeq = "${scGroupSeq}";
	
	var scOptionInfo = "";
	var pinInfo = "";
	
		
	var checkDeviceId = "";
	var pinType = "";
	var pinFailCount = "";
	
	var pinIdx = 0;
	var noticeAutoPopTp = true;
	
	var loginFlag = true;	//로그인버튼 중복클릭 방지플레그
	
	    $(document).ready(function(){
	    	
	    	localStorage.removeItem("forceLogoutYn");
	    	
	    	var passwdCheck = "${passwdChange}";
	    	var loginType = "${loginType}";
	    	
	    	var groupId = "${groupSeq}";
	    	if(groupId != ""){
	    		$("#groupId").val(groupId);
	    		$("#groupId").attr('disabled', 'disabled');
	    		$("#groupId_label").text("");
	    	}	     
	    	
	    	//아이피접근제한체크
			if ("${AccessIpFailMsg}" != "" && passwdCheck != "Y"){
				alert("접속 할 수 없는 IP대역 입니다.\r\n그룹웨어 관리자에게 문의하세요.");
			}else if ("${redirectMsg}" != ""){
				alert("${redirectMsg}");
				location.href = "/gw/uat/uia/egovLoginUsr.do";
			}else if (ScTargetEmpSeq != "" && passwdCheck != "Y") {
				$("#asp_login_a_type").hide();
				$("#asp_login_b_type").hide();
				setSecondCertPop();
			}
	    	
	    	if(loginType != "B"){	    		
			    /*리사이즈*/
			    var loginWidth = $('#asp_login_a_type').width();
			    var loginHeight = $('#asp_login_a_type').height();
			    $('#asp_login_a_type').css("margin-top",-loginHeight*0.5);
			    $('#asp_login_a_type').css("margin-left",-loginWidth*0.5);
			    
			    $(window).resize(function(){
			        var loginWidth = $('#asp_login_a_type').width();
				    var loginHeight = $('#asp_login_a_type').height();
				    $('#asp_login_a_type').css("margin-top",-loginHeight*0.5);
				    $('#asp_login_a_type').css("margin-left",-loginWidth*0.5);
			    });
	    	}else{
	    		/*리사이즈*/
			    var loginWidth = $('#asp_login_b_type').width();
			    var loginHeight = $('#asp_login_b_type').height();
			    $('#asp_login_b_type').css("margin-top",-loginHeight*0.5);
			    $('#asp_login_b_type').css("margin-left",-loginWidth*0.5);
			    
			    $(window).resize(function(){
			        var loginWidth = $('#asp_login_b_type').width();
				    var loginHeight = $('#asp_login_b_type').height();
				    $('#asp_login_b_type').css("margin-top",-loginHeight*0.5);
				    $('#asp_login_b_type').css("margin-left",-loginWidth*0.5);
			    });
	    	}
	    	
	    	if ( typeof(parent.document.getElementById("idBtnLogout")) != "undefined" 
                && parent.document.getElementById("idBtnLogout") != null ) {
                parent.document.location.href = "${pageContext.request.serverName}/NeosMain.do";
            }
	    	
	    	if(passwdCheck != "Y") {
            	window.setTimeout("fnUserIdInit();", 2000);	
            }
	    	
       		if(passwdCheck == "Y") {
       			fnPasswordCheckPop();
       			
           		return false;
           	}
       		
       		
       		if("${positionList}" != "" && passwdCheck != "Y"){
        		/*리사이즈*/
    		    var compWidth = $('#comp_type').width();
    		    var compHeight = $('#comp_type').height();

    		    $('#comp_type').css("margin-top",-compHeight*0.5-20);
    		    $('#comp_type').css("margin-left",-compWidth*0.5-20);
    		    
    		    $(window).resize(function(){
    			    $('#comp_type').css("margin-top",-compHeight*0.5-20);
    		    	$('#comp_type').css("margin-left",-compWidth*0.5-20);
    		    });
        		$(".login_wrap").hide();
        		$(".company_logo").hide();
        		$("#comp_type").show();
        		
        		$("#copyRight").hide();
        	}
       		
            if(window.location.href.indexOf("gw/uat/uia/egovLoginUsr.do?login_error=1") != -1){
        		alert("<%=BizboxAMessage.getMessage("TX900000561","로그인 부서에 대한 권한이 부여되어 있지 않습니다.\\n관리자에게 문의 바랍니다.",request.getSession().getAttribute("nativeLangCode").toString())%>");
        	}else if(window.location.href.indexOf("login_error=SSO") != -1){
        		alert("<%=BizboxAMessage.getMessage("TX900000562","사용자 인증정보가 유효하지 않거나 만료되었습니다.\\n관리자에게 문의 바랍니다.",request.getSession().getAttribute("nativeLangCode").toString())%>");
        	}
       		
       		searchNotice();
		});
		
		function searchNotice(){
		
	    	$.ajax({ 
		        type: "POST", 
		        url: "/gw/api/getGcmsNoticeList.do",
		        data:{reqType : "main" },
		        success: function (data) {
		        	if(data.GcmsNoticeList != null){
		        		setNoticeData(data.GcmsNoticeList);
		        		setNoticePop(data.GcmsNoticePopList);
		        	}
		        },
		        error:function (e) {
		        	console.log(e);
		        }
			});
	    }
			
		function setNoticePop(data){
			
			if(data == null || data.length == 0){
				localStorage.setItem("bizboxCloudNoticeInfo", "");
				return;
			}
			
			//공지사항 팝업처리
			if(localStorage.getItem("bizboxCloudNoticeInfo") == null)
				localStorage.setItem("bizboxCloudNoticeInfo", "");
				
			var bizboxCloudNoticeInfo = localStorage.getItem("bizboxCloudNoticeInfo");
			
	    	for(var i=0; i<data.length; i++){	    		
	    		if(bizboxCloudNoticeInfo.indexOf("|" + data[i].seq + "|") < 0){
   					noticeAutoPop(data[i], "Y");
	    		}
	    	}				
		}
		
		function setNoticeData(data){
			
			cloudNoticeData = data;
			
	    	var innerHtml = "";
	    		    	
	    	var todate = formatToDate();
	    	
	    	for(var i=0; i<data.length; i++){
	    		
	    		innerHtml += "<li onclick='noticeDescPop(\"" + data[i].seq + "\")'><dl>";
	    		
	    		if(todate == data[i].create_dt.substring(0,10).replaceAll("-","")){
	    			innerHtml += "<dt style='font-weight:bold;'><img src='/gw/Images/ico/main_hpop_alt_new.png'>";
	    		}else{
	    			innerHtml += "<dt>";
	    		}
	    		
	    		innerHtml += data[i].title + "</dt><dd>" + data[i].create_dt.substring(0,10) + "</dd></dl></li>";
	    	}
	    	
	    	$("#CloudNotice").html(innerHtml);
	    }
		
		var cloudNoticeData;
		var cloudNoticeCnt = 0;
		
		function formatToDate() {
		    var d = new Date(),
		        month = '' + (d.getMonth() + 1),
		        day = '' + d.getDate(),
		        year = d.getFullYear();

		    if (month.length < 2) month = '0' + month;
		    if (day.length < 2) day = '0' + day;

		    return year+month+day;
		}			
		
		
		
		function noticeAutoPop(data, popYn){
			
			noticeAutoPopTp = false;

		    var windowY = (window.top.outerHeight / 2 + window.top.screenY - ( 565 / 2));
		    var windowX = (window.top.outerWidth / 2 + window.top.screenX - ( 670 / 2));
		    
		    if(popYn == "Y"){
		    	windowY = windowY + (cloudNoticeCnt*50);
		    	windowX = windowX + (cloudNoticeCnt*50);
		    	cloudNoticeCnt++;
		    }
		    
		    if(popYn == "Y"){
		    	window.open("", "noticeAutoPop_" + data.seq, "width=800,height=562,toolbar=no,directories=no,menubar=no,status=no,resizable=no,scrollbars=no,top=" + windowY + ",left=" + windowX);
		    }else{
				window.open("", "noticeAutoPop_" + data.seq, "width=800,height=530,toolbar=no,directories=no,menubar=no,status=no,resizable=no,scrollbars=no,top=" + windowY + ",left=" + windowX);
		    }
	        var frmData = document.cloudNoticePop ;
	        frmData.target = "noticeAutoPop_" + data.seq ;
  			frmData.seq.value = data.seq;
  			frmData.title.value = data.title.replace(/\'/g,"&#39;");
  			frmData.contents.value = data.contents.replace(/\'/g,"&#39;");  			
  			frmData.create_by.value = data.create_by;
	        frmData.create_dt.value = data.create_dt;
	        frmData.pop_yn.value = popYn;
			frmData.submit();
		}
		
		function noticeMorePop(){
			
		    var windowY = (window.top.outerHeight / 2 + window.top.screenY - ( 565 / 2));
		    var windowX = (window.top.outerWidth / 2 + window.top.screenX - ( 670 / 2));
		    
			window.open("/gw/GcmsNoticeListPop.do?pop_yn=N", "noticeMorePop", "width=800,height=530,toolbar=no,directories=no,menubar=no,status=no,resizable=no,scrollbars=no,top=" + windowY + ",left=" + windowX);
						
		}
			    
	    function noticeDescPop(seq){
	    	for(var i=0; i<cloudNoticeData.length; i++){
	    		if(seq == cloudNoticeData[i].seq){
	    			noticeAutoPop(cloudNoticeData[i], "N");
	    		}
	    	}	    	
	    }
	    
		//focus이벤트
		function focusInput(id) {
		    $("#" + id + "_label").text("");
		}
		
		//blur이벤트
		function blurInput(id) {
		    if ($("#" + id).val() == "") {
		        var msg = "";
		        switch (id) {
		        	case "groupId":
		                msg = "Group ID";
		                $("#" + id + "_label").text(msg);
		                break;
		            case "userId":
		                msg = "<%=BizboxAMessage.getMessage("TX000000075","아이디",request.getSession().getAttribute("nativeLangCode").toString())%>";
		                $("#" + id + "_label").text(msg + " <%=BizboxAMessage.getMessage("TX000001236","입력",request.getSession().getAttribute("nativeLangCode").toString())%>");
		                break;
		            case "userPw":
		                msg = "<%=BizboxAMessage.getMessage("TX000000077","비밀번호",request.getSession().getAttribute("nativeLangCode").toString())%>";
		                $("#" + id + "_label").text(msg + " <%=BizboxAMessage.getMessage("TX000001236","입력",request.getSession().getAttribute("nativeLangCode").toString())%>");
		                break;
		        }
		        
		    }
		}
		
		function actionLogin() {
			
			if(loginFlag){
				loginFlag = false;
				if(ScTargetEmpSeq == ""){
					saveid(document.loginForm);
				}
				
				if($("#groupId").val() == ""){
					alert("<%=BizboxAMessage.getMessage("TX900000563","Group ID를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
					$("#groupId_label").focus();
					loginFlag = true;
					return false;
				}
				else if (document.loginForm.id.value =="") {
			        alert("<%=BizboxAMessage.getMessage("TX000010564","아이디를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
			        $("#userId").focus();
			        loginFlag = true;
			    } else if (document.loginForm.password.value =="") {
			        alert("<%=BizboxAMessage.getMessage("TX000010563","비밀번호를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
			        $("#userPw").focus();
			        loginFlag = true;
			    } else {
			        var httpsYN ="<nptag:commoncode  codeid = 'HP001' code='HTTPS'/>";
			        $("fieldset").removeClass("delay05s").addClass("animated1s fadeOut");
					$(".sk-folding-cube").show();
			    	if ( httpsYN == "Y") {
			            var serverName = "${pageContext.request.serverName}";
			            var port = "<nptag:commoncode  codeid = 'HP001' code='HTTPS_PORT' />";		            
			        	setTimeout(function(){
			        		document.loginForm.action="https://"+serverName+":"+port+"<c:url value='/uat/uia/actionLogin.do'/>";
			        	},2700);
			    	}else {		    		
			    		setTimeout(function(){
			    			document.loginForm.action="<c:url value='/uat/uia/actionLogin.do'/>";
			        	},2700);
			          	
			    	}
			    	
			        if(ScTargetEmpSeq == ""){
			    		
			    		var userId0 = securityEncrypt($("#userId").val());
			    		var userId1 = "";
			    		var userId2 = "";
			    		
			    		if(userId0.length > 50){
			    			userId1 = userId0.substr(50);
			    			userId0 = userId0.substr(0,50);
			    			
			        		if(userId1.length > 50){
			        			userId2 = userId1.substr(50);
			        			userId1 = userId1.substr(0,50);
			        		}    			
			    		}
			    		
						$("#userId").val(userId0);
						$("#userIdSub1").val(userId1);
						$("#userIdSub2").val(userId2);
						
						
						<c:choose>
					    <c:when test="${LoginParamEncType == 'NONE'}">
					    
					    </c:when>
					    <c:when test="${LoginParamEncType == 'BASE64'}">
					    $("#userPw").val(btoa(unescape(encodeURIComponent($("#userPw").val()))))
					    </c:when>
					    <c:otherwise>
						$("#userPw").val(securityEncUtil.securityEncrypt($("#userPw").val(), "0"));
					    </c:otherwise>
						</c:choose>	
					}		      	
			      	
			      	$("#groupSeq").val($("#groupId").val());
			      	
			        document.loginForm.submit();
			        
			      	$("#userId").val("");
			      	$("#userPw").val("");    	        
			    }
			}
		}
		
		function securityEncrypt(inputStr){
			<c:choose>
		    <c:when test="${LoginParamEncType == 'NONE'}">
		    return inputStr;
		    </c:when>
		    <c:when test="${LoginParamEncType == 'BASE64'}">
			return btoa(unescape(encodeURIComponent(inputStr)));
		    </c:when>
		    <c:otherwise>
		    return securityEncUtil.securityEncrypt(inputStr, "${securityEncLevel}");
		    </c:otherwise>
			</c:choose>	
		}	
		
		
		function saveid(form) {
		    var expdate = new Date();
		    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
		    if (document.loginForm.checkId.checked)
		        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
		    else
		        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
		    setCookie("saveid", document.loginForm.id.value, expdate);
		}
		
		function setCookie (name, value, expires) {
		    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
		}
		
		function fnInit() {
			
		    var message = document.loginForm.message.value;
		    if (message != "") {
		        alert(message);
		    }
		    
		    var result = document.loginForm.result.value;
		    
		    if(result == "success") {
		 		location.href = "actionLogout.do";
		    }
		    
		
		    getid(document.loginForm); 
		}
		
		
		//로그인 로딩 (B타입용)
		function loadingSubmit(){
			if($("#groupId").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX900000563","Group ID를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
				$("#groupId_label").focus();
				return false;
			}
			else if (document.loginForm.id.value =="") {
		        alert("<%=BizboxAMessage.getMessage("TX000010564","아이디를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
		        $("#userId").focus();
		        return false;
		    } else if (document.loginForm.password.value =="") {
		        alert("<%=BizboxAMessage.getMessage("TX000010563","비밀번호를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
		        $("#userPw").focus();
		        return false;
		    }
			
			$("fieldset, .log_tit").removeClass("delay1s").addClass("animated1s fadeOut");
			$(".spinner").show();
			setTimeout(actionLogin(),2050);
		}
		
		
		function fnUserIdInit(){
			
			if(noticeAutoPopTp){
				if($("#userId").val() != ""){
					$("#userPw").focus();
				}else{
					$("#userPw").val("");
					$("#userId").focus();
				}				
			}

		}
		
		
		function fnPasswordCheckPop() {
			
			var url = "/gw/uat/uia/passwordCheckPop.do";
			var w = 685;
			var h = 405;
			var left = (screen.width/2)-(w/2);
			var top = (screen.height/2)-(h/2);
			  
			var pop = window.open(url, "popup_window",
					"width=" + w +",height=" + h + ", left=" + left + ", top=" + top + "");

			pop.focus();
		}
		
		
		function getCookie(Name) {
		    var search = Name + "=";
		    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
		        offset = document.cookie.indexOf(search);
		        if (offset != -1) { // 쿠키가 존재하면
		            offset += search.length;
		            // set index of beginning of value
		            end = document.cookie.indexOf(";", offset);
		            // 쿠키 값의 마지막 위치 인덱스 번호 설정
		            if (end == -1)
		                end = document.cookie.length;
		            return unescape(document.cookie.substring(offset, end));
		        }
		    }
		    return "";
		}
		
		function getid(form) {
			document.loginForm.checkId.checked = ((document.loginForm.id.value = getCookie("saveid")) != "");
			
			if(document.loginForm.id.value.length>0){
				$("#id").removeClass("id_blur01");
				$("#id").addClass("id_blur01_1");
			} 
		}
		
		function changeEmpPosition(target){
			var seq = $("#"+target.id).attr("seq");
			
			$.ajax({ 
		        type: "POST", 
		        url: "/gw/systemx/changeUserPositionProc.do",
		        
		        data: {seq : seq}, 
		        success: function (e) {  
		        	 location.href = "/gw/userMain.do?isMain=Y";
		        },  
		        error:function (e) {   
		        	console.log(e); 
		        } 
			});
		}
		
		function fnFindPasswordPop(){
			
			if($("#groupId").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX900000563","Group ID를 입력하세요")%>");
				$("#groupId_label").focus();
				return;
			}
			
			var url = "/gw/uat/uia/findPasswdPop.do?groupSeq=" + $("#groupId").val();
			var w = 550;
			var h = 365;
			var left = (screen.width/2)-(w/2);
			var top = (screen.height/2)-(h/2);
			var pop = window.open(url, "popup_window", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + ", scrollbars=0,resizable=0");
			pop.focus();
			
		}		
		
	</script>
	
	<c:if test="${loginType eq 'B'}">
		<style>
	    	.asp_login_b_type_bg2{
	    		position: fixed;width:100%;height:100%;z-index:0;
	    		background: url('${pageContext.request.contextPath}/Images/temp/login_a2_type_temp.png') no-repeat;
	    		background-size: cover;
	    	}
	   	</style>
   	</c:if>
</head>

	
	<c:if test="${loginType eq 'A'}">
	<body id="login" onLoad="fnInit();" class="animated2s fadeIn">		
		<div id="asp_login_a_type">
			<div class="company_logo">
				<c:if test="${empty logoMap}">
				<img src="${pageContext.request.contextPath}/Images/temp/douzone_logo.png?date=191118" alt="" id="">
				</c:if>
				<c:if test="${!empty logoMap}">
				<img src="${logoPath}?${logoMap.file_id}" alt="" id="">
				</c:if>
			</div>
	        <div class="login_wrap">
	        	<div class="login_user_img">
	        		<c:if test="${empty baMap}">
	        			<img src="${pageContext.request.contextPath}/Images/temp/asp_login_a_type_img.png" alt="" id="">
	        		</c:if>
	        		<c:if test="${!empty baMap}">
	        			<img src="${bnPath}?${baMap.file_id}" alt="" id="">
	        		</c:if>
	        	</div>
	        	
	            <div class="login_form_wrap posi_re">
	            	<span class="fl">
		                <p class="log_tit animated1s fadeInUp delay05s">
		                	<c:if test="${empty txtMap}">
	                			<%=BizboxAMessage.getMessage("TX900000564","더존 그룹웨어에 오신것을 환영합니다.",request.getSession().getAttribute("nativeLangCode").toString())%>
	                		</c:if>
	                		<c:if test="${!empty txtMap}">
			                	${txtMap.display_text }
			               	</c:if>
		                </p>
		                <form name="loginForm" action ="${pageContext.request.contextPath}/uat/uia/actionLogin.do" method="post">
		                	<input type="hidden" id="isScLogin" name="isScLogin" value="">
		                	<input type="hidden" id="scUserId" name="scUserId" value="${scUserId}">
                			<input type="hidden" id="scUserPwd" name="scUserPwd" value="${scUserPwd}">
		                	<input type="hidden" name="message" value="${message}"/>
		                	<input type="hidden" name="result" value="${result}"/>
		                	<input name="userSe" type="hidden" value="USER"/>	                	
		                	<input name="j_username" type="hidden"/>
		                	<input name="groupSeq" id="groupSeq" type="hidden" value="${groupSeq}"/>
		                    <fieldset class="animated1s fadeInUp delay05s">
		                    	<label class="i_label" for="groupId" id="groupId_label" onclick="javascript:focusInput('groupId');" style="font-size: 12px;">Group ID</label>
		                        <input type="text" class="inp engfix" id="groupId" onfocus="focusInput('groupId');" onblur="blurInput('groupId');">
		                    	
		                        <input type="text" class="inp engfix" id="userId" name="id" onfocus="focusInput('userId');" onblur="blurInput('userId');" placeholder="<%=BizboxAMessage.getMessage("TX000016184","아이디 입력",request.getSession().getAttribute("nativeLangCode").toString())%>">
		                        <input type="hidden" id="userIdSub1" name="id_sub1" value="" />
                        		<input type="hidden" id="userIdSub2" name="id_sub2" value="" />
		                        
		                        <label class="i_label" for="userPw" id="userPw_label" onclick="javascript:focusInput('userPw');" style="font-size: 12px;"><%=BizboxAMessage.getMessage("TX000014590","비밀번호 입력",request.getSession().getAttribute("nativeLangCode").toString())%></label>
		                        <input type="password" class="inp engfix" id="userPw" name="password" onfocus="focusInput('userPw');" onblur="blurInput('userPw');" onkeydown="if(event.keyCode==13){javascript:actionLogin();return false;}">
		                        
		                        <div class="chk">
		                            <input type="checkbox" id="checkId" name="checkId" onclick="javascript:saveid(document.loginForm);"/>
		                            <label for="checkId"><%=BizboxAMessage.getMessage("TX000005654","아이디저장",request.getSession().getAttribute("nativeLangCode").toString())%></label>
		                            <c:if test="${findPasswdYn eq 'Y'}"><p style="float: right;padding-top: 2px;text-decoration: underline;cursor: pointer;" onclick="fnFindPasswordPop();"><%=BizboxAMessage.getMessage("TX000001707","비밀번호찾기",request.getSession().getAttribute("nativeLangCode").toString())%></p></c:if>
		                        </div>
		                        <div class="log_btn">
		                            <a href="#n" class="login_submit" onclick="actionLogin();return false;"><%=BizboxAMessage.getMessage("TX900000235","로그인",request.getSession().getAttribute("nativeLangCode").toString())%></a>
		                        </div>
		                    </fieldset>
		                </form>
	                </span>
	                <span class="fl">
		                <p class="notice_tit animated1s fadeInUp  delay05s"><%=BizboxAMessage.getMessage("TX900000560","그룹웨어 공지사항",request.getSession().getAttribute("nativeLangCode").toString())%><a href="javascript:noticeMorePop();" class="notice_more" title="<%=BizboxAMessage.getMessage("TX000018197","더보기",request.getSession().getAttribute("nativeLangCode").toString())%>"></a></p>
		                <div class="notice_div ScrollY" style="height:105px;">
		                <ul class="notice_list animated1s fadeInUp delay05s" id="CloudNotice">
		                </ul>
		                </div>
	                </span>
	                
	                <!-- 로딩시작 -------------------------------------------------->
		            <div class="sk-folding-cube">
					  <div class="sk-cube1 sk-cube"></div>
					  <div class="sk-cube2 sk-cube"></div>
					  <div class="sk-cube4 sk-cube"></div>
					  <div class="sk-cube3 sk-cube"></div>
					</div>
					
					<style>
						.sk-folding-cube {
						  display:none;
						  margin: 20px auto;
						  width: 40px;
						  height: 40px;
						  position: absolute;
						  top: 235px;
						  left: 50%;
						  margin: 0 0 0 -20px;
						  -webkit-transform: rotateZ(45deg);
						  transform: rotateZ(45deg);
						}
						
						.sk-folding-cube .sk-cube {
						  float: left;
						  width: 50%;
						  height: 50%;
						  position: relative;
						  -webkit-transform: scale(1.1);
						      -ms-transform: scale(1.1);
						          transform: scale(1.1); 
						}
						.sk-folding-cube .sk-cube:before {
						  content: '';
						  position: absolute;
						  top: 0;
						  left: 0;
						  width: 100%;
						  height: 100%;
						  background-color: #1088e3;
						  -webkit-animation: sk-foldCubeAngle 2.4s infinite linear both;
						          animation: sk-foldCubeAngle 2.4s infinite linear both;
						  -webkit-transform-origin: 100% 100%;
						      -ms-transform-origin: 100% 100%;
						          transform-origin: 100% 100%;
						}
						.sk-folding-cube .sk-cube2 {
						  -webkit-transform: scale(1.1) rotateZ(90deg);
						          transform: scale(1.1) rotateZ(90deg);
						}
						.sk-folding-cube .sk-cube3 {
						  -webkit-transform: scale(1.1) rotateZ(180deg);
						          transform: scale(1.1) rotateZ(180deg);
						}
						.sk-folding-cube .sk-cube4 {
						  -webkit-transform: scale(1.1) rotateZ(270deg);
						          transform: scale(1.1) rotateZ(270deg);
						}
						.sk-folding-cube .sk-cube2:before {
						  -webkit-animation-delay: 0.3s;
						          animation-delay: 0.3s;
						}
						.sk-folding-cube .sk-cube3:before {
						  -webkit-animation-delay: 0.6s;
						          animation-delay: 0.6s; 
						}
						.sk-folding-cube .sk-cube4:before {
						  -webkit-animation-delay: 0.9s;
						          animation-delay: 0.9s;
						}
						@-webkit-keyframes sk-foldCubeAngle {
						  0%, 10% {
						    -webkit-transform: perspective(140px) rotateX(-180deg);
						            transform: perspective(140px) rotateX(-180deg);
						    opacity: 0; 
						  } 25%, 75% {
						    -webkit-transform: perspective(140px) rotateX(0deg);
						            transform: perspective(140px) rotateX(0deg);
						    opacity: 1; 
						  } 90%, 100% {
						    -webkit-transform: perspective(140px) rotateY(180deg);
						            transform: perspective(140px) rotateY(180deg);
						    opacity: 0; 
						  } 
						}
						
						@keyframes sk-foldCubeAngle {
						  0%, 10% {
						    -webkit-transform: perspective(140px) rotateX(-180deg);
						            transform: perspective(140px) rotateX(-180deg);
						    opacity: 0; 
						  } 25%, 75% {
						    -webkit-transform: perspective(140px) rotateX(0deg);
						            transform: perspective(140px) rotateX(0deg);
						    opacity: 1; 
						  } 90%, 100% {
						    -webkit-transform: perspective(140px) rotateY(180deg);
						            transform: perspective(140px) rotateY(180deg);
						    opacity: 0; 
						  }
						}
					</style>
					<!-- 로딩종료 -------------------------------------------------->
					
	            </div>
	        </div>
	        <div id="copyRight" class="copy">Copyright &copy 2017 DOUZONE ICT GROUP All rights reserved.</div>
	    </div>	 
	    <!-- 회사선택 레이어팝업 -->
	    <div id="comp_type">
	    	<c:if test="${eaType ne 'ea'}">
	    	<!-- 영리 -->
	    	<div class="com_ta2 bgtable hover_no cursor_p" id="">
				<table>
					<colgroup>
						<col width="200"/>
	<%-- 					<col width="150"/> --%>
						<col width=""/>
	<%-- 					<col width="85"/> --%>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000018","회사명",request.getSession().getAttribute("nativeLangCode").toString())%></th>
	<!-- 					<th>주부서</th> -->
						<th><%=BizboxAMessage.getMessage("TX000003976","미결",request.getSession().getAttribute("nativeLangCode").toString())%></th>
	<!-- 					<th>진행</th> -->
						<th><%=BizboxAMessage.getMessage("TX000000421","수신참조",request.getSession().getAttribute("nativeLangCode").toString())%></th>
					</tr>
				</table>
			</div>
			<div class="com_ta2 bgtable hover_no cursor_p ova_sc scroll_y_on" id="" max-height:185px;">
				<table id="empPositionInfo">
					<colgroup>
						<col width="200"/>
	<%-- 					<col width="150"/> --%>
						<col width=""/>
	<%-- 					<col width="85"/> --%>
						<col width=""/>
					</colgroup>
					<c:forEach items="${positionList}" var="list">
					<tr id="${list.empCompSeq}${list.deptSeq}" onclick="changeEmpPosition(this);" deptSeq="${list.deptSeq}" compSeq="${list.empCompSeq}" seq="${list.seq}" onmouseover="this.style.background='#E6F4FF'" onmouseout="this.style.background='white'">
						<td>${list.compName}</td>
	<%-- 					<td>${list.deptName}</td> --%>
						<td>${list.eapproval}</td>
	<%-- 					<td>${list.eaprocessingCnt}</td> --%>
						<td>${list.eapprovalRef}</td>
					</tr>
					</c:forEach>
				</table>
			</div>
			</c:if>
			
			<c:if test="${eaType eq 'ea'}">
			<!-- 비영리 -->
	    	<div class="com_ta2 bgtable hover_no cursor_p" id="">
				<table>
					<colgroup>
						<col width="200"/>
						<col width="200"/>
						<col width=""/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000018","회사명",request.getSession().getAttribute("nativeLangCode").toString())%></th>
						<th><%=BizboxAMessage.getMessage("TX000006108","겸직부서",request.getSession().getAttribute("nativeLangCode").toString())%></th>
						<th><%=BizboxAMessage.getMessage("TX000003976","미결",request.getSession().getAttribute("nativeLangCode").toString())%></th>
						<th><%=BizboxAMessage.getMessage("TX000000735","진행",request.getSession().getAttribute("nativeLangCode").toString())%></th>
					</tr>
				</table>
			</div>
			<div class="com_ta2 bgtable hover_no cursor_p ova_sc scroll_y_on" id=""  style="max-height:185px;">
				<table id="empPositionInfo">
					<colgroup>
						<col width="200"/>
						<col width="200"/>
						<col width=""/>
						<col width=""/>
					</colgroup>
					<c:forEach items="${positionList}" var="list">
					<tr id="${list.empCompSeq}${list.deptSeq}" onclick="changeEmpPosition(this);" deptSeq="${list.deptSeq}" compSeq="${list.empCompSeq}" seq="${list.seq}" onmouseover="this.style.background='#E6F4FF'" onmouseout="this.style.background='white'">
						<td>${list.compName}</td>
						<td>${list.deptName}</td>
						<td>${list.eapproval}</td>
						<td>${list.eapprovalRef}</td>
					</tr>
					</c:forEach>
				</table>
			</div>
			</c:if>
	    </div>   
	</body>	
	</c:if>
	
	<c:if test="${loginType ne 'A'}">
	<body id="login" onLoad="fnInit();">
		<c:if test="${!empty baMap.file_id}">
		<c:choose>
		    <c:when test="${baMap.disp_type == '1'}">
		    	<div class="asp_login_b_type_bg2 animated2s fadeIn" style="background-image:url('${bnPath}?${baMap.file_id}');background-size:100% 100%;"></div>
		    </c:when>
		    <c:when test="${baMap.disp_type == '2'}">
		    	<div class="asp_login_b_type_bg2 animated2s fadeIn" style="background-image:url('${bnPath}?${baMap.file_id}');background-position:center;background-repeat: no-repeat;background-size: contain;"></div>
		    </c:when>
		    <c:when test="${baMap.disp_type == '3'}">
		    	<div class="asp_login_b_type_bg2 animated2s fadeIn" style="background-image:url('${bnPath}?${baMap.file_id}');background-repeat:repeat;"></div>
		    </c:when>	    
		    <c:otherwise>
		    	<div class="asp_login_b_type_bg2 animated2s fadeIn" style="background-image:url('${bnPath}?${baMap.file_id}');background-size:cover;"></div>
		    </c:otherwise>
		</c:choose>
		</c:if>
		
		<c:if test="${empty baMap.file_id}">
			<div class="asp_login_b_type_bg2 animated2s fadeIn"></div>
		</c:if>
		
		<div id="asp_login_b_type" class="animated2s fadeIn delay05s">
	        <div class="login_wrap">
	        	<div class="company_logo">
	        		<c:if test="${empty logoMap}">
						<img src="${pageContext.request.contextPath}/Images/temp/douzone_logo2.png?date=191118" alt="" id="">
					</c:if>
					<c:if test="${!empty logoMap}">
						<img src="${logoPath}?${logoMap.file_id}" alt="" id="">      
					</c:if>
				</div>
	            <div class="login_form_wrap clear">
	                <div class="notice_box">
	                	<p class="notice_tit animated1s fadeInUp delay1s"><%=BizboxAMessage.getMessage("TX900000560","그룹웨어 공지사항",request.getSession().getAttribute("nativeLangCode").toString())%><a href="javascript:noticeMorePop();" class="notice_more" title="<%=BizboxAMessage.getMessage("TX000018197","더보기",request.getSession().getAttribute("nativeLangCode").toString())%>"></a></p><!-- 애니메이션 요소가 들어간부분 -->
	                	<div class="notice_div ScrollY" style="height:128px;">
		                <ul class="notice_list animated1s fadeInUp delay1s" id="CloudNotice"><!-- 애니메이션 요소가 들어간부분 -->
		                </div>
		                </ul>
	                </div>
	                <div class="login_box posi_re">
	                	<p class="log_tit animated1s fadeInUp delay1s">
	                		<c:if test="${empty txtMap}">
	                			<%=BizboxAMessage.getMessage("TX900000564","더존 그룹웨어에 오신것을 환영합니다.",request.getSession().getAttribute("nativeLangCode").toString())%>
	                		</c:if>
	                		<c:if test="${!empty txtMap}">
			                	${txtMap.display_text }
			               	</c:if>
	                	</p><!-- 애니메이션 요소가 들어간부분 -->
		                <form name="loginForm" action ="${pageContext.request.contextPath}/uat/uia/actionLogin.do" method="post">
		                	<input type="hidden" id="isScLogin" name="isScLogin" value="">
		                	<input type="hidden" id="scUserId" name="scUserId" value="${scUserId}">
                			<input type="hidden" id="scUserPwd" name="scUserPwd" value="${scUserPwd}">
		                	<input type="hidden" name="message" value="${message}"/>
		                	<input type="hidden" name="result" value="${result}"/>
		                	<input name="userSe" type="hidden" value="USER"/>	                	
		                	<input name="j_username" type="hidden"/>
		                	<input name="groupSeq" id="groupSeq" type="hidden" value="${groupSeq}"/>
		                	
		                    <fieldset class="animated1s fadeInUp delay1s"><!-- 애니메이션 요소가 들어간부분 -->
		                    	<label class="i_label" for="groupId" id="groupId_label" onclick="javascript:focusInput('groupId');" style="font-size: 12px;">Group ID</label>
		                        <input type="text" class="inp engfix" id="groupId" onfocus="focusInput('groupId');" onblur="blurInput('groupId');">
		                    	
		                        <input type="text" class="inp engfix" id="userId" name="id" onfocus="focusInput('userId');" onblur="blurInput('userId');" placeholder="<%=BizboxAMessage.getMessage("TX000016184","아이디 입력",request.getSession().getAttribute("nativeLangCode").toString())%>">
                        		<input type="hidden" id="userIdSub1" name="id_sub1" value="" />
                        		<input type="hidden" id="userIdSub2" name="id_sub2" value="" />
                        				                        
		                        <label class="i_label" for="userPw" id="userPw_label" onclick="javascript:focusInput('userPw');" style="font-size: 12px;"><%=BizboxAMessage.getMessage("TX000014590","비밀번호 입력",request.getSession().getAttribute("nativeLangCode").toString())%></label>
		                        <input type="password" class="inp engfix" id="userPw" name="password" onfocus="focusInput('userPw');" onblur="blurInput('userPw');" onkeydown="if(event.keyCode==13){javascript:loadingSubmit();return false;}">
		                        
		                        <div class="chk">
		                            <input type="checkbox" id="checkId" name="checkId" onclick="javascript:saveid(document.loginForm);"/>
		                            <label for="checkId"><%=BizboxAMessage.getMessage("TX000005654","아이디저장",request.getSession().getAttribute("nativeLangCode").toString())%></label>
		                            <c:if test="${findPasswdYn eq 'Y'}"><p style="float: right;padding-top: 2px;text-decoration: underline;cursor: pointer;" onclick="fnFindPasswordPop();"><%=BizboxAMessage.getMessage("TX000001707","비밀번호찾기",request.getSession().getAttribute("nativeLangCode").toString())%></p></c:if>
		                        </div>
		                        <div class="log_btn">
		                            <a href="#n" class="login_submit" onclick="loadingSubmit();return false;"><%=BizboxAMessage.getMessage("TX900000235","로그인",request.getSession().getAttribute("nativeLangCode").toString())%></a>
		                        </div>
		                    </fieldset>		                    
		                </form>
		                
		                <!-- 로딩시작 -------------------------------------------------->
			            <div class="spinner">
						  <div class="rect1"></div>
						  <div class="rect2"></div>
						  <div class="rect3"></div>
						  <div class="rect4"></div>
						  <div class="rect5"></div>
						</div>
						
						<style>
							.spinner {
							  display:none;
							  position:absolute;
							  top:50%;
							  left:50%;
							  margin: -20px 0 0 0;
							  width: 50px;
							  height: 40px;
							  text-align: center;
							  font-size: 10px;
							}
							
							.spinner > div {
							  background-color: #1088e3;
							  height: 100%;
							  width: 6px;
							  display: inline-block;
							  
							  -webkit-animation: sk-stretchdelay 1.2s infinite ease-in-out;
							  animation: sk-stretchdelay 1.2s infinite ease-in-out;
							}
							
							.spinner .rect2 {
							  -webkit-animation-delay: -1.1s;
							  animation-delay: -1.1s;
							}
							
							.spinner .rect3 {
							  -webkit-animation-delay: -1.0s;
							  animation-delay: -1.0s;
							}
							
							.spinner .rect4 {
							  -webkit-animation-delay: -0.9s;
							  animation-delay: -0.9s;
							}
							
							.spinner .rect5 {
							  -webkit-animation-delay: -0.8s;
							  animation-delay: -0.8s;
							}
							
							@-webkit-keyframes sk-stretchdelay {
							  0%, 40%, 100% { -webkit-transform: scaleY(0.4) }  
							  20% { -webkit-transform: scaleY(1.0) }
							}
							
							@keyframes sk-stretchdelay {
							  0%, 40%, 100% { 
							    transform: scaleY(0.4);
							    -webkit-transform: scaleY(0.4);
							  }  20% { 
							    transform: scaleY(1.0);
							    -webkit-transform: scaleY(1.0);
							  }
							}
						</style>
						<!-- 로딩종료 -------------------------------------------------->
		                	                
	                </div>
	            </div>
	            <div id="copyRight" class="copy">Copyright &copy 2017 DOUZONE ICT GROUP All rights reserved.</div>
	        </div>
	    </div>
<!-- 	    회사선택 레이어팝업 -->
	    <div id="comp_type">
    	<c:if test="${eaType ne 'ea'}">
    	<!-- 영리 -->
    	<div class="com_ta2 bgtable hover_no cursor_p" id="">
			<table>
				<colgroup>
					<col width="200"/>
<%-- 					<col width="150"/> --%>
					<col width=""/>
<%-- 					<col width="85"/> --%>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000018","회사명",request.getSession().getAttribute("nativeLangCode").toString())%></th>
<!-- 					<th>주부서</th> -->
					<th><%=BizboxAMessage.getMessage("TX000003976","미결",request.getSession().getAttribute("nativeLangCode").toString())%></th>
<!-- 					<th>진행</th> -->
					<th><%=BizboxAMessage.getMessage("TX000000421","수신참조",request.getSession().getAttribute("nativeLangCode").toString())%></th>
				</tr>
			</table>
		</div>
    
    	<div class="com_ta2 bgtable hover_no cursor_p ova_sc scroll_y_on" id="" style="max-height:185px;">
			<table id="empPositionInfo">
				<colgroup>
					<col width="200"/>
<%-- 					<col width="150"/> --%>
					<col width=""/>
<%-- 					<col width="85"/> --%>
					<col width=""/>
				</colgroup>
				<c:forEach items="${positionList}" var="list">
				<tr id="${list.empCompSeq}${list.deptSeq}" onclick="changeEmpPosition(this);" deptSeq="${list.deptSeq}" compSeq="${list.empCompSeq}" seq="${list.seq}" onmouseover="this.style.background='#E6F4FF'" onmouseout="this.style.background='white'">
					<td>${list.compName}</td>
<%-- 					<td>${list.deptName}</td> --%>
					<td>${list.eapproval}</td>
<%-- 					<td>${list.eaprocessingCnt}</td> --%>
					<td>${list.eapprovalRef}</td>
				</tr>
				</c:forEach>
			</table>
		</div>
		</c:if>
		
		<c:if test="${eaType eq 'ea'}">
		<!-- 비영리 -->
    	<div class="com_ta2 bgtable hover_no cursor_p" id="">
			<table>
				<colgroup>
					<col width="200"/>
					<col width="200"/>
					<col width=""/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000018385","회사명",request.getSession().getAttribute("nativeLangCode").toString())%></th>
					<th><%=BizboxAMessage.getMessage("TX000006108","겸직부서",request.getSession().getAttribute("nativeLangCode").toString())%></th>
					<th><%=BizboxAMessage.getMessage("TX000003976","미결",request.getSession().getAttribute("nativeLangCode").toString())%></th>
					<th><%=BizboxAMessage.getMessage("TX000000735","진행",request.getSession().getAttribute("nativeLangCode").toString())%></th>
				</tr>
			</table>
		</div>
		<div class="com_ta2 bgtable hover_no cursor_p ova_sc scroll_y_on" id="" style="max-height:185px;">
			<table id="empPositionInfo">
				<colgroup>
					<col width="200"/>
					<col width="200"/>
					<col width=""/>
					<col width=""/>
				</colgroup>
				<c:forEach items="${positionList}" var="list">
				<tr id="${list.empCompSeq}${list.deptSeq}" onclick="changeEmpPosition(this);" deptSeq="${list.deptSeq}" compSeq="${list.empCompSeq}" seq="${list.seq}" onmouseover="this.style.background='#E6F4FF'" onmouseout="this.style.background='white'">
					<td>${list.compName}</td>
					<td>${list.deptName}</td>
					<td>${list.eapproval}</td>
					<td>${list.eapprovalRef}</td>
				</tr>
				</c:forEach>
			</table>
		</div>
		</c:if>
    </div>
	</body>
	</c:if>
	
	<!-- 팝업 :: 이차인증로그인 -->
	<div id="login_v2" class="secondCert login login_v2"	style="margin-left: -300px; margin-top: -289px; display: none;">
		<div class="login_wrap">
			<h2 style="padding:20px 113px 15px">
				<img src="/gw/Images/ico/ico_2_de.png" width="32px" class="fl" />
				<span class="fl" style="margin:3px 0 0 10px"><%=BizboxAMessage.getMessage("TX900000565","이차인증 로그인",request.getSession().getAttribute("nativeLangCode").toString())%></span>
			</h2>
			<p class="info_txt">
				<%=BizboxAMessage.getMessage("TX900000566","그룹웨어 보안을 위해 이차인증을 실행합니다.<br /> 비즈박스알파 모바일앱에서 아래 코드를 읽어주세요.",request.getSession().getAttribute("nativeLangCode").toString())%>
			</p>
			<div class="qr_area">
				<div class="qr_img">
					<div id="qr_view1" class="qr_view"></div>
				</div>
				<div class="qr_time">
					<%=BizboxAMessage.getMessage("TX900000346","남은 시간",request.getSession().getAttribute("nativeLangCode").toString())%> <em id="qr_time1">03:00</em>
				</div>
			</div>
			<p class="sub_info_txt">
				<%=BizboxAMessage.getMessage("TX900000567","※ 인증기기 추가를 하는 경우, 재로그인이 필요합니다.<br /> 인증기기 승인 여부 옵션에 따라, 관리자의 승인이 필요할 수 있습니다.",request.getSession().getAttribute("nativeLangCode").toString())%>
			</p>
			<div class="btn_cen mt20">
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002972","닫기",request.getSession().getAttribute("nativeLangCode").toString())%>"
					style="width: 135px; height: 30px;" onclick="btnClose();" /> <input
					type="button" value="<%=BizboxAMessage.getMessage("TX900000568","인증기기 변경",request.getSession().getAttribute("nativeLangCode").toString())%>" style="width: 135px; height: 30px;" onclick="btnChangScDevice();"/>
			</div>
		</div>
	</div>
	
	
	<!-- 팝업 :: 이차인증기기등록 -->
	<div id="login_v3" class="secondCert device login_v2" style="margin-left: -300px; margin-top: -289px; display: none;">
		<div class="login_wrap">
			<h2 style="padding:20px 100px 15px">
				<img src="/gw/Images/ico/ico_2_mo.png" width="25px" class="fl" />
				<span class="fl" style="margin:3px 0 0 10px"><%=BizboxAMessage.getMessage("TX900000569","이차인증 기기등록",request.getSession().getAttribute("nativeLangCode").toString())%></span>
			</h2>			
			<p class="info_txt">
				<%=BizboxAMessage.getMessage("TX900000570","그룹웨어 보안을 위해 이차인증을 실행합니다.",request.getSession().getAttribute("nativeLangCode").toString())%><br />
				<%=BizboxAMessage.getMessage("TX900000571","이차인증에 필요한 기기 등록을 위해<br />비즈박스알파 모바일 앱에서 아래 코드를 읽어주세요.",request.getSession().getAttribute("nativeLangCode").toString())%>
			</p>
			<div class="qr_area">
				<div class="qr_img">
					<div id="qr_view2" class="qr_view"></div>
				</div>
				<div class="qr_time"><%=BizboxAMessage.getMessage("TX900000346","남은 시간",request.getSession().getAttribute("nativeLangCode").toString())%> <em id="qr_time2">03:00</em></div>
			</div>
			<p class="sub_info_txt">
				<%=BizboxAMessage.getMessage("TX900000572","※ 인증기기 등록후, 재로그인이 필요합니다.",request.getSession().getAttribute("nativeLangCode").toString())%><br />
				<%=BizboxAMessage.getMessage("TX900000573","인증기기 승인 여부 옵션에 따라, 관리자의 승인이 필요할 수 있습니다.",request.getSession().getAttribute("nativeLangCode").toString())%><br />
				<%=BizboxAMessage.getMessage("TX900000574","모바일 앱을 재설치하는 경우, 기기 등록이 필요합니다.",request.getSession().getAttribute("nativeLangCode").toString())%>
			</p>
			<div class="btn_cen mt20">
				<input type="button" class="gray_btn" value="닫기" style="width:140px;height:30px;" onclick="btnClose();"/>
			</div>
		</div>
	</div>
	
	
	<!-- 팝업 :: 이차인증로그인 -->
	<div id="login_v4" class="login_v2" style="display: none;">
		<div class="login_wrap">
			<h2 style="padding:20px 135px 15px">
				<img src="/gw/Images/ico/ico_2_login.png" width="25px" class="fl" />
				<span class="fl" style="margin:3px 0 0 10px" id="pinTitle"></span>
			</h2>		
			<p class="info_txt" id="pinContents">			
			</p>
			<div class="pin_area">
				<div class="pin_input">
					<table>
						<tr>
							<td><input id="pwd_0" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(0, this)"/></td>
							<td><input id="pwd_1" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(1, this)"/></td>
							<td><input id="pwd_2" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(2, this)"/></td>
							<td><input id="pwd_3" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(3, this)"/></td>
						</tr>
					</table>
				</div>
				<div class="pin_board">
					<table>
						<tr>
							<td><input type="button" class="btn ac" value="1" onclick="fnClickPinNum(1)"/></td>
							<td><input type="button" class="btn ac" value="2" onclick="fnClickPinNum(2)"/></td>
							<td><input type="button" class="btn ac" value="3" onclick="fnClickPinNum(3)"/></td>
						</tr>
						<tr>
							<td><input type="button" class="btn ac" value="4" onclick="fnClickPinNum(4)"/></td>
							<td><input type="button" class="btn ac" value="5" onclick="fnClickPinNum(5)"/></td>
							<td><input type="button" class="btn ac" value="6" onclick="fnClickPinNum(6)"/></td>
						</tr>
						<tr>
							<td><input type="button" class="btn ac" value="7" onclick="fnClickPinNum(7)"/></td>
							<td><input type="button" class="btn ac" value="8" onclick="fnClickPinNum(8)"/></td>
							<td><input type="button" class="btn ac" value="9" onclick="fnClickPinNum(9)"/></td>
						</tr>
						<tr>
							<td><input type="button" class="btn ac" value="Reset" onclick="initPinNum()"/></td>
							<td><input type="button" class="btn ac" value="0" onclick="fnClickPinNum(0)"/></td>
							<td><input type="button" class="btn ac" value="Del" onclick="delPinNum();"/></td>
						</tr>
					</table>
				</div>
			</div>
			<div class="btn_cen mt20">
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002972","닫기",request.getSession().getAttribute("nativeLangCode").toString())%>" style="width:135px;height:30px;" onclick="fnClosePinPop();"/>
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000019752", "확인",request.getSession().getAttribute("nativeLangCode").toString())%>" style="width:135px;height:30px;" onclick="fnSavePin();"/>
			</div>
		</div>
	</div>

	<form id="scPop" name="scPop" method="post" action="/gw/cmm/systemx/secondCertDescPop.do" target="scPop">
	  <input name="type" value="" type="hidden"/>
	  <input name="deviceNum" value="" type="hidden"/>
	  <input name="groupSeq" value="" type="hidden"/>
	  <input name="empSeq" value="" type="hidden"/>
	</form>
	
	<form id="cloudNoticePop" name="cloudNoticePop" method="post" action="/gw/GcmsNoticeListPop.do" target="popup_window">
	  <input name="seq" value="" type="hidden"/>
	  <input name="title" value="" type="hidden"/>
	  <input name="contents" value="" type="hidden"/>
	  <input name="create_by" value="" type="hidden"/>
	  <input name="create_dt" value="" type="hidden"/>
	  <input name="pop_yn" value="" type="hidden"/>
	</form>	
</html>