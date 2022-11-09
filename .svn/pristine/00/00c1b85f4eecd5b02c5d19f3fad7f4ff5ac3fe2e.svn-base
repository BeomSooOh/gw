<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@page import="main.web.BizboxAMessage"%>

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">
	<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
</head>

<script type="text/javascript">

	var stepCnt = 1;
	var targetEmpSeq;
	var outMailExistYn = "N";
	var smtpExistYn = "Y";
	
	/* 패스워드 인증번호 임계치 카운터 */
 	var limiteCertificationCount = 0;
	var limiteFindIdCount = 0;

    $(document).ready(function() {
    	fnShowSelectedStep("");
    	$("#loginId").focus();
	});	
    
    function fnPrev(){
    	
    	stepCnt--;
    	fnShowSelectedStep("");
    	
    }
    
    function fnNext(){
    	
    	if(stepCnt == 1){
    		
    		if($("#loginId").val() == ""){
    			puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000002640","ID를 입력해 주세요")%>", "");
    			return;
    		}
    		
	 		var tblParam = {};
	 		
	 		<c:if test="${groupSeq != ''}">
	 		tblParam.groupSeq = "${groupSeq}";
	 		</c:if>
	 		
	 		tblParam.loginId = $("#loginId").val();
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'<c:url value="/uat/uia/findPasswdInfo.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {
	    			
	    			if(result.empExistYn == "Y"){
	    				var findPasswdReqTime = localStorage.getItem('findPasswdReq_' + $("#loginId").val());
	    				
	    				if(findPasswdReqTime) {	    					
   							var reqTime = new Date(findPasswdReqTime).getTime();
   							var nowTime = new Date().getTime();
   							
   							var diffMinute = (nowTime - reqTime) / 1000 / 60;
   							
   							if(diffMinute < 3) {
   								puddAlert("warning", "재요청 제한시간(3분)이 지난 후에 이용해 주세요.", "");
   								return;
   							} else {
   								localStorage.removeItem('findPasswdReq_' + $('#loginId').val());
   							}
	    				}
	    					    				
	    				var cm210 = "${cm210}";
	    				
	    				if(cm210.indexOf("0") > -1){
	    					
	    					$('input:radio[name="findTypeSel"][value="email"]').prop('checked', true);
	    					
	    					if(result.outMailExistYn == "Y"){
		    					$("[name=emailInfo]").html("(" + result.emailId + "@" + result.emailDomain + ")");
		    					$("#emailRadio").attr("disabled", false);
		    					outMailExistYn = "Y";
		    					smtpExistYn = result.smtpExistYn;
		    					
	    					}else{
		    					$("[name=emailInfo]").html("(" + "<%=BizboxAMessage.getMessage("","개인메일정보 없음")%>" + ")");
		    					$("#emailRadio").attr("disabled", true);
	    					}
	    					
	    					$("#emailDiv").show();
	    					
	    				}else{
	    					$("#emailDiv").hide();
	    				}
	    				
	    				if(cm210.indexOf("1") > -1){
	    					$("#adminDiv").show();
	    					
	    					if(cm210.indexOf("0") < 0 || result.outMailExistYn != "Y"){
	    						$('input:radio[name="findTypeSel"][value="admin"]').prop('checked', true);	
	    					}
	    					
	    				}else{
	    					$("#adminDiv").hide();
	    					
	    					if(cm210.indexOf("0") > -1){
	    						$("#emailRadio").attr("disabled", false);
	    					}
	    					
	    				}
	    				
		    	    	stepCnt++;
		    	    	fnShowSelectedStep("");
		    	    	targetEmpSeq = result.empSeq;
		    	    	
	    			}else{
	    				if(limiteFindIdCount < 5) {
	    					limiteFindIdCount += 1;
		    				puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000009312","사용자 정보가 존재하지  않습니다")%>", "");
	    				} else {
	    					puddAlert("warning", "사용자 정보 조회 횟수 초과하였습니다.", "window.close()");
	    				}
	    			}
	    			
	    		} ,
			    error: function (result) {
			    	puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
			    }
	    	});    		
    		
    	}else if(stepCnt == 2){
    		
    		if($('[name="findTypeSel"]:checked').val() == "email"){
    			
    			if(outMailExistYn == "N"){
	    	    	stepCnt = 2;
	    	    	fnShowSelectedStep(".empty");
	    	    	
	    	    	$(".pwsearch_setp span").removeAttr("style");
	        		$("#titleSpan3,#titleSpan4").hide();
	        		$("#titleSpan5").show();
	        		$("#titleSpan5").css("font-weight", "bold");
	        		$("#titleSpan5").css("color", "#058df5");
	        		$("#titleText").html("");
	    			$("#btnPrev,#btnNext").hide();
	    	    	$("#btnClose").show();	        		
	        		
	        		return;
    			}else if(smtpExistYn == "N"){
	    	    	stepCnt = 2;
	    	    	fnShowSelectedStep(".smtp");
	    	    	
	    	    	$(".pwsearch_setp span").removeAttr("style");
	        		$("#titleSpan3,#titleSpan4").hide();
	        		$("#titleSpan5").show();
	        		$("#titleSpan5").css("font-weight", "bold");
	        		$("#titleSpan5").css("color", "#058df5");
	        		$("#titleText").html("");
	    			$("#btnPrev,#btnNext").hide();
	    	    	$("#btnClose").show();	        		
	        		
	        		return;    				
    				
    			}else{
        	    	stepCnt++;
        	    	fnShowSelectedStep(".email");
        	    	fnReqSecuNumFlag = true;
        	    	
    				$("#reqSecuNumBtn").show();
    				$("#reqLimitCount").hide();
    				$("#reqSecuNum").attr("disabled", true);
    			}
    	    	
    		}else{
    			
    	 		var tblParam = {};
    	 		
    	 		<c:if test="${groupSeq != ''}">
    	 		tblParam.groupSeq = "${groupSeq}";
    	 		</c:if>
    	 		
    	 		tblParam.loginId = $("#loginId").val();
    	 		tblParam.passwdStatusCode = "F";
    	 		
    	 		$.ajax({
    	        	type:"post",
    	    		url:'<c:url value="/uat/uia/findPasswdReq.do"/>',
    	    		datatype:"json",
    	            data: tblParam ,
    	    		success: function (result) {
    	    			
    	    			if(result.result == "SUCCESS"){
        	    	    	stepCnt++;
        	    	    	fnShowSelectedStep(".admin");
        	    			$("#btnPrev,#btnNext").hide();
        	    	    	$("#btnClose").show();
        	    	    	
        	    	    	localStorage.setItem('findPasswdReq' + '_' + $("#loginId").val(), new Date());
    	    			}else if(result.result == "REQ"){
    	    				puddAlert("warning", "<%=BizboxAMessage.getMessage("","이미 초기화 요청된 계정입니다.")%>");
    	    			}else if(result.result == "SMTP"){
			    	    	fnShowSelectedStep(".smtp");
			    	    	$("#btnNext").hide();
    	    			}else{
    	    				puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");	
    	    			}
    	    			
    	    		} ,
    			    error: function (result) {
    			    	puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
    			    }
    	    	});     			
    			

    		}
    		
    	}else if(stepCnt == 3){
    		if($("#reqSecuNum").val().length == 4){
    			
    	 		var tblParam = {};
    	 		
    	 		<c:if test="${groupSeq != ''}">
    	 		tblParam.groupSeq = "${groupSeq}";
    	 		</c:if>
    	 		
    	 		tblParam.loginId = $("#loginId").val();
    	 		tblParam.findPasswdSecuNum = $("#reqSecuNum").val();
    	 		
    	 		$.ajax({
    	        	type:"post",
    	    		url:'<c:url value="/uat/uia/findPasswdCheck.do"/>',
    	    		datatype:"json",
    	            data: tblParam ,
    	    		success: function (result) {
    	    			
    	    			if(result.result == "SUCCESS"){
    	    				limiteCertificationCount = 0;
    	    				puddAlert("success", "<%=BizboxAMessage.getMessage("","인증번호가 확인되었습니다.")%>", "fnPasswdChange()");
    	    			}else{
    	    				if(limiteCertificationCount < 5) {
    	    					limiteCertificationCount += 1;
        	    				puddAlert("warning", "<%=BizboxAMessage.getMessage("","인증번호가 올바르지 않습니다.")%>");		
    	    				} else {
    	    					puddAlert("warning", "인증번호 인증 횟수를 초과하였습니다.", "window.close()");
    	    				}
    	    			}
    	    			
    	    		} ,
    			    error: function (result) {
    			    	puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
    			    }
    	    	});      			
    			
    		}else{
    			puddAlert("warning", "<%=BizboxAMessage.getMessage("","인증번호를 입력해주세요.")%>");
    		}
    		
    	}
    	
    }
    
    var fnReqSecuNumFlag = true;
    var lMin = 3;
    var lSec = 0;
    
    function fnReqSecuNum(){
    	
    	if(fnReqSecuNumFlag){
    		
    		fnReqSecuNumFlag = false;
    		
	 		var tblParam = {};
	 		
	 		<c:if test="${groupSeq != ''}">
	 		tblParam.groupSeq = "${groupSeq}";
	 		</c:if>
	 		
	 		tblParam.loginId = $("#loginId").val();
	 		tblParam.passwdStatusCode = "M";
	 		
	 		fnLoading(true);
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'<c:url value="/uat/uia/findPasswdReq.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {
	    			
	    			fnLoading(false);
	    			
	    			if(result.result == "SUCCESS"){
	    				
	    				$("#reqSecuNumBtn").hide();
	    				$("#reqLimitCount").show();
	    			    lMin = 3;
	    			    lSec = 0;
	    			    fnCountDown();
	    			    $("#btnNext").show();
	    			    $("#reqSecuNum").attr("disabled", false);
	    			    $("#reqSecuNum").focus();
	    			    
	    				
	    			}else if(result.result == "REQ"){
	    				puddAlert("warning", "<%=BizboxAMessage.getMessage("","이미 초기화 요청된 계정입니다.")%>");	
	    			}else if(result.result == "SMTP"){
	    				puddAlert("warning", "<%=BizboxAMessage.getMessage("","SMTP 정보가 설정되지 않아, 메일 인증을 사용할 수 없습니다.")%>");	
	    				fnReqSecuNumFlag = true;
	    			}else{
	    				puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
	    				fnReqSecuNumFlag = true;
	    			}
	    			
	    		} ,
			    error: function (result) {
			    	fnLoading(false);
			    	puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
			    	fnReqSecuNumFlag = true;
			    }
	    	});       		
    	}
    }
    
    function fnCountDown(){
    	
    	if(stepCnt > 3){
    		return;
    	}
    	
    	$("#reqLimitCount").html("0" + lMin + ":" + (lSec < 10 ? "0" : "") + lSec);
        
        if(lMin < 1 && lSec < 1){
        	
            lMin = 3;
            lSec = 0;
            
            puddAlert("warning", "<%=BizboxAMessage.getMessage("","인증번호 입력 시간이 초과되었습니다.<br>인증번호 받기를 다시 클릭해주세요.")%>");
            
            fnReqSecuNumFlag = true;
			$("#reqSecuNumBtn").show();
			$("#reqLimitCount").hide();            
        	
        }else{
        	
        	if(lSec == 0){
        		lMin--;
        		lSec = 59;
        	}else{
        		lSec--;
        	}
        	
        	setTimeout("fnCountDown()", 1000);	
        }
    }
    
    function fnClose(){
    	self.close();
    }
    
    function fnShowSelectedStep(subClass){
    	
    	$(".pwsearch_setp span").removeAttr("style");
    	
    	if(subClass == ".admin"){
    		$("#titleSpan3,#titleSpan4").hide();
    		$("#titleSpan5").show();
    		$("#titleSpan5").css("font-weight", "bold");
    		$("#titleSpan5").css("color", "#058df5");
    		
    	}else{
    		$("#titleSpan" + stepCnt).css("font-weight", "bold");
    		$("#titleSpan" + stepCnt).css("color", "#058df5");
    		$("#titleSpan5").hide();
    	}
    	
    	$("[name=stepDiv]").hide();
    	
    	if(subClass == ".empty"){
    		$(".step_con03.empty").show();
    	}else if(subClass == ".smtp"){
    		$(".step_con03.smtp").show();
    	}else{
    		$(".step_con0" + stepCnt + subClass).show();
    	}
    	
    	if(stepCnt == 1){
    		$("#btnPrev").hide();
    	}else{
    		$("#btnPrev").show();
    	}
    	
    	if(stepCnt < 3){
    		$("#btnNext").show();
    	}
    	
    	if(stepCnt == 1){
    		$("#titleText").html("<%=BizboxAMessage.getMessage("","비밀번호를 찾고자 하는 그룹웨어 ID를 입력해주세요.")%>");
    	}else if(stepCnt == 2){
    		$("#titleText").html("<%=BizboxAMessage.getMessage("","비밀번호 찾기 방법을 선택해 주세요.")%>");
    	}else if(stepCnt == 3 && subClass == ".email"){
    		$("#titleText").html("<%=BizboxAMessage.getMessage("","그룹웨어에 등록된 개인메일로 인증번호가 발송됩니다.")%>");
    	}else if(stepCnt == 4){
    		$("#titleText").html("<%=BizboxAMessage.getMessage("","비밀번호를 재설정해주세요.")%>");
    	}else{
    		$("#titleText").html("");
    	}
    	
    }
    
 	function puddConfirm(alertMsg, callback){
 		var puddDialog = Pudd.puddDialog({
 			width : "400"
 		,	height : "100"
 		,	message : {
 				type : "question"
 			,	content : alertMsg.replace(/\n/g, "<br>")
 			}
 		,	footer : {
 		
 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
 				buttons : [
 					{
 						attributes : {}// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
 					,	value : "확인"
 					,	clickCallback : function( puddDlg ) {
 							puddDlg.showDialog( false );
 							eval(callback);
 						}
 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
 					,	defaultFocus :  true// 기본값 true
 					}
 				,	{
 						attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
 					,	value : "취소"
 					,	clickCallback : function( puddDlg ) {
 		
 							puddDlg.showDialog( false );
 						}
 					}
 				]
 			}	
 		
 		});		
 	}

 	function puddAlert(type, alertMsg, callback){
 		var puddDialog = Pudd.puddDialog({
 			width : "400"
 		,	height : "100"
 		,	message : {
 				type : type
 			,	content : alertMsg.replace(/\n/g, "<br>")
 			}
 		,	footer : {
 		
 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
 				buttons : [
 					{
 						attributes : {}// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
 					,	value : "확인"
 					,	clickCallback : function( puddDlg ) {
 							puddDlg.showDialog( false );
 							eval(callback);
 						}
 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
 					,	defaultFocus :  true// 기본값 true
 					}
 				]
 			}	
 		
 		});		
 	}
 	
 	var percent = 0;
 	
 	function fnLoading(flag){
 		
 		if(flag){
 	 		percent = 0;
 	 		
 	 	 	Pudd( "#ProgressBar" ).puddProgressBar({
 	 	 		 
 	 	 		progressType : "juggling"
 	 	 	,	attributes : { style:"width:70px; height:70px;" }
 	 	 	 
 	 	 	,	strokeColor : "#84c9ff"	// progress 색상
 	 	 	,	strokeWidth : "3px"	// progress 두께
 	 	 	 
 	 	 	,	textAttributes : { style : "" }		// text 객체 속성 설정
 	 	 	 
 	 	 	,	percentText : "loading"	// loading 표시 문자열 설정 - progressType : loading, juggling 인 경우만 해당
 	 	 	,	percentTextColor : "#84c9ff"
 	 	 	,	percentTextSize : "12px"
 	 	 	 
 	 	 		// 배경 layer 설정 - progressType : loading, juggling 인 경우만 해당
 	 	 	,	backgroundLayerAttributes : { style : "background-color:#000;filter:alpha(opacity=20);opacity:0.2;width:100%;height:100%;position:fixed;top:0px; left:0px;" }
 	 	 	 
 	 	 		// 200 millisecond 마다 callback 호출됨
 	 	 	,	progressCallback : function( progressBarObj ) {

 	 	 			return percent;
 	 	 		}
 	 	 	});   			
 		}else{
 			percent = 100;
 		}
 	}
 	
    function fnPasswdChange(){
    	stepCnt = 4;
    	fnShowSelectedStep("");
    	
    	$("#loginIdTo").html($("#loginId").val());
    	$("#modPass").focus();
    	$("#btnPrev,#btnNext,#btnClose").hide();
    	$("#btnSave").show();
    	
   		var passDue = '${inputDueValueResult}';
   		var passDigit = '${inputDigitResult}';
   		var passRule = '${inputRuleResult}';
   		var passLimit = '${inputLimitResult}';

   		$("#passDue").text(passDue);
   		$("#passDigit").text(passDigit);
   		$("#passRule").text(passRule.slice(0,-1));
   		$("#passLimit").text(passLimit.slice(0,-1));

   		if(passDue == "" && passDigit == "" && passRule == "" && passLimit == "") {

   			$("#detailPasswdOption").empty();

   			var tag = "";

   			tag += "* <%=BizboxAMessage.getMessage("TX000022474","비밀번호 설정규칙 옵션을 사용하지 않습니다.")%>";

   			$("#detailPasswdOption").html(tag);

   		}
   		
   		if($(document).height() > $(window).height()){
   			window.resizeBy(0,$(document).height() - $(window).height());
   		}
    }	
    
    function fnPasswordCheckNew(){
    	
		var message = '';					// 상황에 따른 알럿 내용
		var necessaryAlertMsg = '';

		var type = 'find';
		var modPass = $("#modPass").val();
		var rePass = $("#rePass").val();

		var necessaryFlag = true;
		var passwdChangeFlag = false;

		// 비밀번호 규칙 기본 정규식 (변경 비밀번호 입력 X)
		if(modPass == "") {
			puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000022470","필수 입력 값이 입력 되지 않았습니다.")%>", "$('#modPass').focus()");
			return false;
		}		
		
		if (rePass == "") {
			puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000022470","필수 입력 값이 입력 되지 않았습니다.")%>", "$('#rePass').focus()");
			return false;
		}

		// 비밀번호 규칙 기본 정규식 (변경 비밀번호 일치 X)
		if (modPass != rePass) {
			puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000022471","변경비밀번호확인이 일치하지 않습니다")%>", "$('#rePass').focus()");
			return false;
		}

		var checkParams = {};
 		<c:if test="${groupSeq != ''}">
 		checkParams.groupSeq = "${groupSeq}";
 		</c:if>		
		checkParams.loginId = $("#loginId").val();
		checkParams.empSeq = targetEmpSeq;
		checkParams.findPasswdSecuNum = $("#reqSecuNum").val();
		checkParams.type = type;
		checkParams.nPWD = btoa(unescape(encodeURIComponent(modPass)));
		
		fnLoading(true);

		$.ajax({
			type: "POST",
	        url: "${pageContext.request.contextPath}/uat/uia/passwordChangeCheck.do",
	        async: true,
	        data: checkParams,
	        success: function (result) {
	        	
	        	fnLoading(false);
	        	
	        	if(result.result.resultCode == "success") {
	        		
	        		puddAlert("success", '<%=BizboxAMessage.getMessage("TX000022476","비밀번호가 정상적으로 변경되었습니다.")%>', "fnClose()");
	        		
	        	}else if(result.result.ex != null) {

	        		puddAlert("warning", result.result.message, "");
	                
	        	}else{

	        		puddAlert("warning", result.result.message, "");
	        		
	        	}

	        },
	        error:function (e) {
		    	fnLoading(false);
		    	puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");	        	
	        }
		});    	
    }
    
</script>

<body>
<div class="pop_wrap pwSearch" style="border: none;">  <!-- window 팝업사이즈 550*365 -->
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("","비밀번호 찾기")%></h1>
	</div>	
	
	<div class="pop_con pt10" style="overflow:auto;">		
		<dl class="pwsearch_setp">
			<dt><span id="titleSpan1" style="font-weight:bold;color:#058df5;" ><%=BizboxAMessage.getMessage("","ID입력")%></span><span id="titleSpan2"> &gt; <%=BizboxAMessage.getMessage("","인증방법 선택")%></span><span id="titleSpan3"> &gt; <%=BizboxAMessage.getMessage("","인증번호 확인")%></span><span id="titleSpan4"> &gt; <%=BizboxAMessage.getMessage("","비밀번호 재설정")%></span><span style="display:none;" id="titleSpan5"> &gt; <%=BizboxAMessage.getMessage("TX000001288","완료")%></span></dt>
			<dd id="titleText"></dd>
		</dl>
		
		<div class="step_con">
			<!-- step01 -->
			<div name="stepDiv" class="step_con01">
				<input type="text" id="loginId" style="width:290px; height:40px;" class="puddSetup ac inp engfix" value="" placeholder="<%=BizboxAMessage.getMessage("","그룹웨어 ID 입력")%>" />
			</div>

			<!-- step02 -->
			<div name="stepDiv" class="step_con02" style="display:none;">
				<div id="emailDiv" class="box box01">
					<input id="emailRadio" type="radio" name="findTypeSel" value="email"/>
					<label for="emailRadio"><%=BizboxAMessage.getMessage("","그룹웨어에 등록된 개인메일로 인증")%></label>
					<p name="emailInfo" class="text_blue pt5 pl19"></p>
					<p class="text">* <%=BizboxAMessage.getMessage("","그룹웨어에 등록된 개인메일로 인증번호가 발송됩니다.")%></p>
				</div>
				<div id="adminDiv" class="box mt10 box02">
					<input id="adminRadio" type="radio" name="findTypeSel" value="admin"/>
					<label for="adminRadio"><%=BizboxAMessage.getMessage("","그룹웨어 관리자 요청")%></label>
					<p class="text">* <%=BizboxAMessage.getMessage("","관리자에게 비밀번호 초기화 요청됩니다.")%></p>
				</div>			
			</div>

			<!-- step03 : (외부메일 사용 및 옵션설정 미사용) - 18p -->
			<div name="stepDiv" class="step_con03 smtp" style="display:none;">
				<div class="box box03 bg01"><%=BizboxAMessage.getMessage("","SMTP 정보가 설정되지 않아, 메일 인증을 사용할 수 없습니다.")%> <br/>
				<%=BizboxAMessage.getMessage("TX000018544","관리자에게 문의해주세요.")%></div>			
			</div>
			
			<!-- step03 : (외부메일 사용 및 옵션설정 사용) / 내부메일 사용 시 -19p -->
			<div name="stepDiv" class="step_con03 email" style="display:none;">
				<div class="box box03 ac">
					<p name="emailInfo" class="text_blue pt15"></p>
					<p class="pt10">
						<input id="reqSecuNum" type="text" style="width:200px;text-align: center;" class="puddSetup" value="" placeholder="<%=BizboxAMessage.getMessage("","인증번호 4글자 입력")%>" maxlength="4" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' />
						<input id="reqSecuNumBtn" onclick="fnReqSecuNum();" type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("","인증번호 받기")%>" />
						<span id="reqLimitCount" class="text_red pl10 fwb"></span>
					</p>
					<p class="pt15 lh20"><%=BizboxAMessage.getMessage("","인증번호가 오지 않는 경우, 스팸 메일로 분류된 건 아닌지 확인해주세요.")%><br/>
					<%=BizboxAMessage.getMessage("","스팸 메일함에 메일이 없다면, 인증번호 받기를 다시 선택해주세요.")%></p>
				</div>			
			</div>

			<!-- step03 : 개인메일 미등록 시 관리자 요청 완료 -21p -->
			<div name="stepDiv" class="step_con03 admin" style="display:none;">
				<div class="box box03 bg02"><%=BizboxAMessage.getMessage("","관리자에게 초기화 요청을 하였습니다.")%><br/>
				<%=BizboxAMessage.getMessage("","초기화 후, 재로그인 시 비밀번호 재설정이 필요합니다.")%></div>				
			</div>

			<!-- step03 : 개인메일 옵션 사용 및 메일정보없음 - 25p -->
			<div name="stepDiv" class="step_con03 empty" style="display:none;">
				<div class="box box03 bg01"><%=BizboxAMessage.getMessage("","개인메일이 등록되어 있지 않습니다.")%><br/>
				<%=BizboxAMessage.getMessage("TX000018544","관리자에게 문의해주세요.")%></div>			
			</div>

			<!-- step04 -->
			<div class="step_con04" style="display:none;">
				<p class="tit_p"><%=BizboxAMessage.getMessage("","그룹웨어 ID")%> : <span id="loginIdTo" class="text_blue"></span></p>	
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="140"/>
							<col width="">
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000021196","변경비밀번호")%></th>
							<td><input id="modPass" autocomplete="new-password" type="password" pudd-style="width:100%;" class="puddSetup" value=""/></td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000021197","변경비밀번호 확인")%></th>
							<td><input id="rePass" autocomplete="new-password" type="password" pudd-style="width:100%;" class="puddSetup" value=""/></td>
						</tr>
					</table>
				</div>
				<p id="detailPasswdOption" class="text_gray pt10 f11 lh16">
					* <%=BizboxAMessage.getMessage("TX000022479","비밀번호 만료 기한")%> : <span class="text_blue" id="passDue"></span><br>
					* <%=BizboxAMessage.getMessage("TX000022480","입력 자리 수 제한")%> : <span class="text_blue" id="passDigit"></span><br>
					* <%=BizboxAMessage.getMessage("TX000022481","필수 입력 값")%> : <span class="text_blue" id="passRule"></span><br>
					* <%=BizboxAMessage.getMessage("TX000022482","입력 제한 값")%> : <span class="text_blue" id="passLimit"></span>
				</p>
				<p class="text_red pt5 lh16 f11">* <%=BizboxAMessage.getMessage("TX000022475","여러 사이트에서 사용하는 동일한 비밀번호나 쉬운 비밀 번호로 설정 시 도용될 위험이 있습니다.")%></p>
			</div>

		</div>		
	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input id="btnPrev" onclick="fnPrev();" type="button" class="puddSetup" style="display:none;" value="<%=BizboxAMessage.getMessage("TX000003165","이전")%>" />
			<input id="btnNext" onclick="fnNext();" type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000003164","다음")%>" />
			<input id="btnClose" onclick="fnClose();" type="button" class="puddSetup submit" style="display:none;" value="<%=BizboxAMessage.getMessage("TX000019668","닫기")%>" />
			<input id="btnSave" onclick="fnPasswordCheckNew();" type="button" class="puddSetup submit" style="display:none;" value="<%=BizboxAMessage.getMessage("TX000019752","확인")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!--// pop_wrap -->

<div id="ProgressBar"></div>

</body>
</html>














