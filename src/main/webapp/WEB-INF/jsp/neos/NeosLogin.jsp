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
	<meta property="og:image" content="${pageContext.request.getScheme()}://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}/gw/Images/temp/douzone_logo.png?data=191118" />
	</c:if>
	<c:if test="${!empty logoMap}">
	<meta property="og:image" content="${pageContext.request.getScheme()}://${pageContext.request.getServerName()}:${pageContext.request.getServerPort()}${logoPath}" />
	</c:if>    
    <title>${groupDisplayName}</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/portlet/css/pudd.css?ver=20201021">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css?ver=20201021"/>
    <!--Kendo ui css-->
    
    <!--css-->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main.css?ver=20201021" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css?ver=20201021" />
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.22.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/common.js?ver=20201021"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/aes.js?ver=20201021"></script> 
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/secondCert.js?ver=20200923"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/securityEncUtil.js"></script>
	
	<style type="text/css">
		::-webkit-input-placeholder { /* Chrome, Safari, Opera */
		    color: #8d8d8d;
		    font-weight: 400;
		}
		
		::-moz-placeholder {  /* Firefox */
		    color: #8d8d8d;
		    font-weight: 400;
		}
		
		:-ms-input-placeholder { /* IE10–11 */
		    color: #8d8d8d !important;
		    font-weight: 400 !important;
		}
		
		::-ms-input-placeholder { /* Edge */
		    color: #8d8d8d;
		    font-weight: 400;
		}
		
		::placeholder { /* CSS Working Draft */
		    color: #8d8d8d;
		    font-weight: 400;
		}
	</style>
	
    <script>
    
    	var passwdCheck = "${passwdChange}";
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
    	
    	var loginFlag = true;	//로그인버튼 중복클릭 방지플레그
    	
        $(document).ready(function(){
        	
        	localStorage.removeItem("forceLogoutYn");
        	
        	//아이피접근제한체크
			if ("${AccessIpFailMsg}" != "" && passwdCheck != "Y"){
				alert("접속 할 수 없는 IP대역 입니다.\r\n그룹웨어 관리자에게 문의하세요.");
			}else if ("${redirectMsg}" != ""){
				alert("${redirectMsg}");
				location.href = "/gw/uat/uia/egovLoginUsr.do";
			}else if (ScTargetEmpSeq != "" && passwdCheck != "Y") {
				$("#login_b1_type").hide();
				$("#login_b2_type").hide();				
				setSecondCertPop();
			} else if ("${positionList}" != "" && passwdCheck != "Y") {
        		/*리사이즈*/
    		    var loginWidth = $('#login_b2_type').width();
    		    var loginHeight = $('#login_b2_type').height();
    		    var compWidth = $('#comp_type').width();
    		    var compHeight = $('#comp_type').height();
    		    
    		    $('#login_b2_type').css("margin-top",-loginHeight*0.5);
    		    $('#login_b2_type').css("margin-left",-loginWidth*0.5);
    		    $('#comp_type').css("margin-top",-compHeight*0.5-20);
    		    $('#comp_type').css("margin-left",-compWidth*0.5-20);
    		    
    		    $(window).resize(function(){
    			    $('#login_b2_type').css("margin-top",-loginHeight*0.5);
    			    $('#login_b2_type').css("margin-left",-loginWidth*0.5);
    			    $('#comp_type').css("margin-top",-compHeight*0.5-20);
    		    	$('#comp_type').css("margin-left",-compWidth*0.5-20);
    		    });
    		    
        		$(".login_wrap").hide();
        		$(".company_logo").hide();
        		$("[name=custMain]").hide();
        		$("#comp_type").show();
        	}
        	
            /*리사이즈*/
            var loginWidth = $('#login_b1_type').width();
            var loginHeight = $('#login_b1_type').height();
            $('#login_b1_type').css("margin-top",-loginHeight*0.5);
            $('#login_b1_type').css("margin-left",-loginWidth*0.5);
            
            $(window).resize(function(){
                var loginWidth = $('#login_b1_type').width();
                var loginHeight = $('#login_b1_type').height();
                $('#login_b1_type').css("margin-top",-loginHeight*0.5);
                $('#login_b1_type').css("margin-left",-loginWidth*0.5);
            });
                        
            /*리사이즈*/
            var loginWidth = $('#login_b2_type').width();
            var loginHeight = $('#login_b2_type').height();
            $('#login_b2_type').css("margin-top",-loginHeight*0.5);
            $('#login_b2_type').css("margin-left",-loginWidth*0.5);
            
            $(window).resize(function(){
                var loginWidth = $('#login_b2_type').width();
                var loginHeight = $('#login_b2_type').height();
                $('#login_b2_type').css("margin-top",-loginHeight*0.5);
                $('#login_b2_type').css("margin-left",-loginWidth*0.5);
            });
            
            if ( typeof(parent.document.getElementById("idBtnLogout")) != "undefined" 
                && parent.document.getElementById("idBtnLogout") != null ) {
                parent.document.location.href = "${pageContext.request.serverName}/NeosMain.do";
            }
            
            if(passwdCheck != "Y") {
            	window.setTimeout("fnUserIdInit();", 150);	
            }
            
            if("${loginType}" == "A") {
        		if(passwdCheck == "Y") {
        			fnPasswordCheckPop();
        			getid(document.loginForm);
            		return false;
            	}
        	} else {
        		if(passwdCheck == "Y") {
        			fnPasswordCheckPop();
        			getid(document.loginForm);
            		return false;
            	}
        	}
            
            if(window.location.href.indexOf("gw/uat/uia/egovLoginUsr.do?login_error=1") != -1){
        		alert("<%=BizboxAMessage.getMessage("TX900000561","로그인 부서에 대한 권한이 부여되어 있지 않습니다.\\n관리자에게 문의 바랍니다.",request.getSession().getAttribute("nativeLangCode").toString())%>");
        	}else if(window.location.href.indexOf("login_error=SSO") != -1){
        		alert("<%=BizboxAMessage.getMessage("TX900000562","사용자 인증정보가 유효하지 않거나 만료되었습니다.\\n관리자에게 문의 바랍니다.",request.getSession().getAttribute("nativeLangCode").toString())%>");
        	}

            fnInit();
            
        });
        
function fnUserIdInit(){
	if($("#userId").val() != ""){
		$("#userPw").focus();
	}else{
		$("#userPw").val("");
		$("#userId").focus();
	}
}
        
function actionLogin() {
	if(loginFlag){
		loginFlag = false;
		if(ScTargetEmpSeq == ""){
			saveid(document.loginForm);
		}
		
	    if (document.loginForm.id.value =="") {
	        alert("<%=BizboxAMessage.getMessage("TX000010564","아이디를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
	        $("#userId").focus();
	        loginFlag = true;
	    } else if (document.loginForm.password.value =="") {
	        alert("<%=BizboxAMessage.getMessage("TX000010563","비밀번호를 입력하세요",request.getSession().getAttribute("nativeLangCode").toString())%>");
	        $("#userPw").focus();
	        loginFlag = true;
	    } else {
	        var httpsYN ="<nptag:commoncode  codeid = 'HP001' code='HTTPS'/>";
	    	if ( httpsYN == "Y") {
	            var serverName = "${pageContext.request.serverName}";
	            var port = "<nptag:commoncode  codeid = 'HP001' code='HTTPS_PORT' />";
	        	document.loginForm.action="https://"+serverName+":"+port+"<c:url value='/uat/uia/actionLogin.do'/>";
	    	}else {
	          	document.loginForm.action="<c:url value='/uat/uia/actionLogin.do'/>";
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

function setCookie (name, value, expires) {
    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
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

function saveid(form) {
    var expdate = new Date();
    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
    if (document.loginForm.checkId.checked)
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
    else
        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
    setCookie("saveid", document.loginForm.id.value, expdate);
}

function getid(form) {
	document.loginForm.checkId.checked = ((document.loginForm.id.value = getCookie("saveid")) != "");
	
	if(document.loginForm.id.value.length>0){
		$("#id").removeClass("id_blur01");
		$("#id").addClass("id_blur01_1");
	} 
}

function fnInit() {

	var resMsg = document.scPop.resMsg.value;
    var resResult = document.scPop.resResult.value;
    
    if (resMsg != "") {
        alert(resMsg);
    }
    
    if(resResult == "success") {
 		location.href = "actionLogout.do";
    }

    getid(document.loginForm);
    
}  

function changeEmpPosition(target){
	var seq = $("#"+target.id).attr("seq")
	
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

function fnPasswordCheckPop() {
	
	var url = "/gw/uat/uia/passwordCheckPop.do";
	var w = 685;
	var h = 405;
	var left = (screen.width/2)-(w/2);
	var top = (screen.height/2)-(h/2);
	  
	var pop = window.open(url, "popup_window", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + "");

	pop.focus();
}

function fnFindPasswordPop(){
	
	var url = "/gw/uat/uia/findPasswdPop.do";
	var w = 550;
	var h = 365;
	var left = (screen.width/2)-(w/2);
	var top = (screen.height/2)-(h/2);
	var pop = window.open(url, "popup_window", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + ", scrollbars=0,resizable=0");
	pop.focus();
	
}

</script>
${custLogonHtmlAppend}
</head>

<c:if test="${loginType eq 'A'}">
<body>
    <div id="login_b1_type" style="margin-top: -243px;margin-left: -366.5px;">
        <div class="company_logo">
        <c:if test="${empty logoMap}">
            <img src="${pageContext.request.contextPath}/Images/temp/douzone_logo.png?date=191118" alt="" id="">
        </c:if>
        <c:if test="${!empty logoMap}">
            <img src="${logoPath}?${logoMap.file_id}" alt="" id="" height="46px">
        </c:if>            
        </div>
        <div class="login_wrap">
            <div class="login_user_img">
                <c:if test="${empty baMap}">
                <img src="${pageContext.request.contextPath}/Images/temp/login_b1_type_img.png" alt="" id="">        
                </c:if>            
                <c:if test="${!empty baMap}">
                <img src="${bnPath}?${baMap.file_id}" alt="" id="">
                </c:if>                
            </div>
            
            <div class="login_form_wrap">
                <p class="log_tit">
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
                    <fieldset>
                        <input type="text" onkeydown="if(event.keyCode==13){javascript:actionLogin();}" class="inp engfix"  id="userId" placeholder="<%=BizboxAMessage.getMessage("TX000016184","아이디 입력",request.getSession().getAttribute("nativeLangCode").toString())%>" name="id" />
                        <input type="hidden" id="userIdSub1" name="id_sub1" value="" />
                        <input type="hidden" id="userIdSub2" name="id_sub2" value="" />
                        
                        <input type="password" onkeydown="if(event.keyCode==13){javascript:actionLogin();}" class="inp engfix" id="userPw" placeholder="<%=BizboxAMessage.getMessage("TX000007698","패스워드 입력",request.getSession().getAttribute("nativeLangCode").toString())%>" name="password" />
                        <div class="chk">
                            <input type="checkbox" id="checkId" type="checkbox" name="checkId" style="border:none; vertical-align:middle;" onClick="javascript:saveid(document.loginForm);"/>
                            <label for="checkId"><%=BizboxAMessage.getMessage("TX000005654","아이디저장",request.getSession().getAttribute("nativeLangCode").toString())%></label>
                            <c:if test="${findPasswdYn eq 'Y'}"><p style="float: right;padding-top: 2px;text-decoration: underline;cursor: pointer;" onclick="fnFindPasswordPop();"><%=BizboxAMessage.getMessage("TX000001707","비밀번호찾기",request.getSession().getAttribute("nativeLangCode").toString())%></p></c:if>
                        </div>
                        <div class="log_btn" onclick="actionLogin();return false;">
                            <div class="login_submit" ><%=BizboxAMessage.getMessage("TX900000235","로그인",request.getSession().getAttribute("nativeLangCode").toString())%></div>
                        </div> 
                    </fieldset>
                </form>
            </div>
        </div>
        <div class="copy" style="display:none;">Copyright © DOUZONE BIZON. All rights reserved.</div>        
    </div>
</body>
</c:if>
<c:if test="${loginType eq 'B'}">
<c:if test="${empty baMap.file_id}">
<body class="login_b2_type_bg">
</c:if>
<c:if test="${!empty baMap.file_id}">
<c:choose>
    <c:when test="${baMap.disp_type == '1'}">
		<body name="${baMap.disp_type}" style="background-image:url('${bnPath}?${baMap.file_id}');background-size:100% 100%;">
    </c:when>
    <c:when test="${baMap.disp_type == '2'}">
		<body name="${baMap.disp_type}" style="background-image:url('${bnPath}?${baMap.file_id}');background-position:center;background-repeat: no-repeat;background-size: contain;">
    </c:when>
    <c:when test="${baMap.disp_type == '3'}">
		<body name="${baMap.disp_type}" style="background-image:url('${bnPath}?${baMap.file_id}');background-repeat:repeat;">
    </c:when>	    
    <c:otherwise>
        <body name="${baMap.disp_type}" style="background-image:url('${bnPath}?${baMap.file_id}');background-size:cover;">
    </c:otherwise>
</c:choose>
</c:if>
    <div id="login_b2_type" style="margin-top: -183px; margin-left: -285px;">
        
            <div class="company_logo">
                <c:if test="${empty logoMap}">
                <img src="${pageContext.request.contextPath}/Images/temp/douzone_logo.png?date=191118" alt="" id="">                
                </c:if>
                <c:if test="${!empty logoMap}">
                <img src="${logoPath}?${logoMap.file_id}" alt="" id="" height="46px">               
                </c:if>            
            </div>
            <div class="login_wrap">
            <div class="login_form_wrap">
                <p class="log_tit" style="padding:6px 0 10px 100px;">
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
                    <fieldset>      
                        <input type="text" onkeydown="if(event.keyCode==13){javascript:actionLogin();}" class="inp engfix"  id="userId" name="id" placeholder="<%=BizboxAMessage.getMessage("TX000016184","아이디 입력",request.getSession().getAttribute("nativeLangCode").toString())%>" />
                        <input type="hidden" id="userIdSub1" name="id_sub1" value="" />
                        <input type="hidden" id="userIdSub2" name="id_sub2" value="" />
                        
                        <input type="password" onkeydown="if(event.keyCode==13){javascript:actionLogin();}" class="inp engfix" id="userPw" name="password" placeholder="<%=BizboxAMessage.getMessage("TX000022319","패스워드 입력",request.getSession().getAttribute("nativeLangCode").toString())%>" />
                        <div class="chk">
                            <input type="checkbox" id="checkId" type="checkbox" name="checkId" style="border:none; vertical-align:middle;" onClick="javascript:saveid(document.loginForm);"/>
                            <label for="checkId"><%=BizboxAMessage.getMessage("TX000005654","아이디저장",request.getSession().getAttribute("nativeLangCode").toString())%></label>
                            <c:if test="${findPasswdYn eq 'Y'}"><p style="float: right;padding-top: 2px;text-decoration: underline;cursor: pointer;" onclick="fnFindPasswordPop();"><%=BizboxAMessage.getMessage("TX000001707","비밀번호찾기",request.getSession().getAttribute("nativeLangCode").toString())%></p></c:if>
                        </div>
                        <div class="log_btn" onclick="actionLogin();return false;">
                            <div class="login_submit" ><%=BizboxAMessage.getMessage("TX900000235","로그인",request.getSession().getAttribute("nativeLangCode").toString())%></div>
                        </div> 
                    </fieldset>
                </form>
            </div>
        </div>
         <div class="copy" style="display:none;">Copyright © DOUZONE BIZON. All rights reserved.</div>
    </div>
</body>
</c:if>

<c:if test="${loginType eq 'CUST'}">
${custLogonHtml}
</c:if>

    <!-- 회사선택 레이어팝업 -->
    <div id="comp_type">
    	<c:if test="${eaType eq 'eap'}">
    	<!-- 영리 -->
    	<div class="com_ta2 bgtable hover_no cursor_p" id="">
			<table>
				<colgroup>
					<col width="200"/>
					<col width=""/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000018","회사명",request.getSession().getAttribute("nativeLangCode").toString())%></th>
					<th><%=BizboxAMessage.getMessage("TX000003976","미결",request.getSession().getAttribute("nativeLangCode").toString())%></th>
					<th><%=BizboxAMessage.getMessage("TX000000421","수신참조",request.getSession().getAttribute("nativeLangCode").toString())%></th>
				</tr>
			</table>
		</div>
		<div class="com_ta2 bgtable hover_no cursor_p ova_sc scroll_y_on" id="" max-height:185px;">
			<table id="empPositionInfo">
				<colgroup>
					<col width="200"/>
					<col width=""/>
					<col width=""/>
				</colgroup>
				<c:forEach items="${positionList}" var="list">
				<tr id="${list.empCompSeq}${list.deptSeq}" onclick="changeEmpPosition(this);" deptSeq="${list.deptSeq}" compSeq="${list.empCompSeq}" seq="${list.seq}" onmouseover="this.style.background='#E6F4FF'" onmouseout="this.style.background='white'">
					<td>${list.compName}</td>
					<td>${list.eapproval}</td>
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
			<span class="fl" style="margin:3px 0 0 10px" id="devRegTitle"><%=BizboxAMessage.getMessage("TX900000569","이차인증 기기등록",request.getSession().getAttribute("nativeLangCode").toString())%></span>
		</h2>
		<p class="info_txt" id="devRegText">
			<%=BizboxAMessage.getMessage("TX900000570","그룹웨어 보안을 위해 이차인증을 실행합니다.",request.getSession().getAttribute("nativeLangCode").toString())%><br />
			<%=BizboxAMessage.getMessage("TX900000571","이차인증에 필요한 기기 등록을 위해<br />비즈박스알파 모바일 앱에서 아래 코드를 읽어주세요.",request.getSession().getAttribute("nativeLangCode").toString())%>
		</p>
		<div class="qr_area">
			<div class="qr_img">
				<div id="qr_view2" class="qr_view"></div>
			</div>
			<div class="qr_time"><%=BizboxAMessage.getMessage("TX900000346","남은 시간",request.getSession().getAttribute("nativeLangCode").toString())%> <em id="qr_time2">03:00</em></div>
		</div>
		<p class="sub_info_txt" id="devRegSubText">
			<%=BizboxAMessage.getMessage("TX900000572","※ 인증기기 등록후, 재로그인이 필요합니다.",request.getSession().getAttribute("nativeLangCode").toString())%><br />
			<%=BizboxAMessage.getMessage("TX900000573","인증기기 승인 여부 옵션에 따라, 관리자의 승인이 필요할 수 있습니다.",request.getSession().getAttribute("nativeLangCode").toString())%><br />
			<%=BizboxAMessage.getMessage("TX900000574","모바일 앱을 재설치하는 경우, 기기 등록이 필요합니다.",request.getSession().getAttribute("nativeLangCode").toString())%>
		</p>
		<div class="btn_cen mt20">
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002972","닫기",request.getSession().getAttribute("nativeLangCode").toString())%>" style="width:140px;height:30px;" onclick="btnClose();"/>
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
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000019752","확인",request.getSession().getAttribute("nativeLangCode").toString())%>" style="width:135px;height:30px;" onclick="fnSavePin();"/>
		</div>
	</div>
</div>


<form id="scPop" name="scPop" method="post" action="/gw/cmm/systemx/secondCertDescPop.do" target="scPop">
  <input name="type" value="" type="hidden"/>
  <input name="deviceNum" value="" type="hidden"/>
  <input name="groupSeq" value="" type="hidden"/>
  <input name="empSeq" value="" type="hidden"/>
  <input name="resMsg" value="${message}" type="hidden"/>
  <input name="resResult" value="${result}" type="hidden"/>  
</form>
</html>