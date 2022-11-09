<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@page import="main.web.BizboxAMessage"%>
<%@ page import="neos.cmm.util.BizboxAProperties"%>
<!--css-->
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">

<!--js-->
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.167.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/aes.js?ver=20201021"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/securityEncUtil.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		// 최초데이터
		fnInit();

		// 버튼 이벤트 정의
		fnButtonInit();
	});

	// 최초 데이터 셋팅
	function fnInit() {
		var passDue = '${inputDueValueResult}';
		var passDigit = '${inputDigitResult}';
		var passRule = '${inputRuleResult}';
		var passLimit = '${inputLimitResult}';
		var title = '${title}';
		var content = '${content}';


		$("#title").html(title);
		$("#content").html(content);

		$("#passDue").text(passDue);
		$("#passDigit").text(passDigit);
		$("#passRule").text(passRule.slice(0,-1));
		$("#passLimit").text(passLimit.slice(0,-1));

		if(passDue == "" && passDigit == "" && passRule == "" && passLimit == "") {

			$("#detailPasswdOption").empty();

			var tag = "";

			tag += "<li><%=BizboxAMessage.getMessage("TX000022474", "비밀번호 설정규칙 옵션을 사용하지 않습니다.")%></li>";

			$("#detailPasswdOption").html(tag);


		}

		fnResizeForm();
	}

	function fnButtonInit() {
		$("#okBtn").click(function() {
			fnPasswordCheckNew();
		});

		$("#cancelBtn").click(function() {
			self.close();
		});
	}

	function fnPasswordCheckNew() {
		var message = '';					// 상황에 따른 알럿 내용
		var contents = '';
		var title = '';
		var necessaryAlertMsg = '';

		var type = '${type}';
		var pass = $("#pass").val();
		var modPass = $("#modPass").val();
		var rePass = $("#rePass").val();

		var necessaryFlag = true;
		var passwdChangeFlag = false;

		// 비밀번호 규칙 기본 정규식 (기존 비밀번호 입력 X)
		if (pass == "" && "${pageInfo}" != "empInfoPop") {
			necessaryAlertMsg += '<%=BizboxAMessage.getMessage("TX000022467", "기존비밀번호")%>' + ',' ;
			title = '<%=BizboxAMessage.getMessage("TX000022470", "필수 입력 값이 입력 되지 않았습니다.")%>';
			necessaryFlag = false;
			$("#pass").focus();
		}

		// 비밀번호 규칙 기본 정규식 (변경 비밀번호 입력 X)
		if (rePass == "") {
			necessaryAlertMsg += '<%=BizboxAMessage.getMessage("TX000022468", "변경비밀번호")%>' + ',' ;
            title = '<%=BizboxAMessage.getMessage("TX000022470", "필수 입력 값이 입력 되지 않았습니다.")%>';
			necessaryFlag = false;
			$("#rePass").focus();
		}

		if(modPass == "") {
			necessaryAlertMsg += '<%=BizboxAMessage.getMessage("TX000022469", "변경비밀번호 확인")%>' + ',' ;
            title = '<%=BizboxAMessage.getMessage("TX000022470", "필수 입력 값이 입력 되지 않았습니다.")%>';
			necessaryFlag = false;
			$("#modPass").focus();
		}

		if(!necessaryFlag) {
			var message = "";
			message += "[<span class='text_blue'>" + necessaryAlertMsg.slice(0, -1) + "</span>]";
			fnPopAlert(message, title);
			return;
		}


		// 비밀번호 규칙 기본 정규식 (변경 비밀번호 일치 X)
		if (modPass != rePass) {
			title = '<%=BizboxAMessage.getMessage("TX000022471", "변경비밀번호확인이 일치하지 않습니다")%>';
			fnPopAlert('', title);

			return false;
		}

		// 기존 비밀번호와 변경 비밀번호가 같은 정우
		if(pass == modPass) { // 기존 패스워드와 일치하여 변경이 불가능합니다. TX000020110
			title = '<%=BizboxAMessage.getMessage("TX000020110", "기존 패스워드와 일치하여 변경이 불가능합니다.")%>';
			fnPopAlert('', title);

			return false;
		}

		var checkParams = {};
		var ParamEncType ='<%=BizboxAProperties.getCustomProperty("BizboxA.Cust.LoginParamEncType")%>'
		checkParams.groupSeq = '${groupSeq}';
		checkParams.loginId = '${loginId}';
		checkParams.empSeq = '${empSeq}';
		checkParams.type = '${type}';
		switch(ParamEncType){
		case  'AES' :
			checkParams.oPWD = securityEncUtil.securityEncrypt(pass,0);
			checkParams.nPWD = securityEncUtil.securityEncrypt(modPass,0)
			 
			break;
		default:
			checkParams.oPWD = btoa(unescape(encodeURIComponent(pass)));
			checkParams.nPWD = btoa(unescape(encodeURIComponent(modPass)));
		    break;
		}
		checkParams.pageInfo = "${pageInfo}";

		state(1);

		$.ajax({
			type: "POST",
	        url: "${pageContext.request.contextPath}/uat/uia/passwordChangeCheck.do",
	        async: true,
	        data: checkParams,
	        success: function (result) {
	        	state(0);
	        	console.log(JSON.stringify(result));
	        	if(result.result.resultCode == "success") {
	        		//passwdChangeFlag = true;
                    title = '<%=BizboxAMessage.getMessage("TX000022476", "비밀번호가 정상적으로 변경되었습니다.")%>';
	        		fnSetSnackbar(title,'success',1500);
	        		setTimeout(function(){
	        			window.close();
	        		}, 1000);
	        		//return;
	        	} else {
	        		passwdChangeFlag = false;
	        		contents = result.result.message;
	        		if(result.result.ex != null) {
	        			title = contents;
	        			contents = '';
	        		} else {
	                    title = '<%=BizboxAMessage.getMessage("TX000022477", "비밀번호 입력 규칙이 잘못 되었습니다.<br>아래 제시된 값을 확인 후 수정하여 주세요.")%>';
	        		}

	        		fnPopAlert(contents, title);

	        		return;
	        	}


	        },
	        error:function (e) {
	        	state(0);
	        	console.log(e);
	        }
		});

	}
		
	function fnSetSnackbar(msg, type, duration){
		var puddActionBar = Pudd.puddSnackBar({
			type	: type
		,	message : msg
		,	duration : 1500
		});
	}

	function fnPasswordNext(){
		if(!confirm("<%=BizboxAMessage.getMessage("TX000022478", "다음 로그인 시 변경하시겠습니까?")%>")){
			return;
		}

		opener.location.href = "/gw/forwardIndex.do?passwdNext=Y";
		self.close();
	}

	// 정규식 공통 함수
	function fnRegExpression(regExpression, message, modPass) {
		if(!regExpression.test(modPass)){
			//alert(message);
			return 0;
		}
	}

	// 코드 유형 및 기본값 선택 팝업 호출
	function fnPopAlert(title, contents) {
		var url = '<c:url value="/cmm/cmmPage/cmmCheckPop.do?type=pass"/>';
		var w = 520;
		var h = 206;
		var left = (screen.width/2)-(w/2);
		var top = (screen.height/2)-(h/2);

		var pop = window.open('', "new_popup",
				"width=520,height=205, left=" + left + ", top=" + top + "");

		if(contents == "") {
			$("#resultContent").val('');
		} else {
			$("#resultContent").val(contents);
		}

		$("#resultMessage").val(title);


		checkMessage.method = "post";
		checkMessage.action = url;
		checkMessage.submit();
	    pop.focus();

	}

	/* [ 사이즈 변경 ] 옵션 값에 따른 페이지 리폼
	-----------------------------------------------*/
	function fnResizeForm() {

		var strWidth = $('.pop_wrap').outerWidth()
		+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);

		$('.pop_wrap').css("overflow","auto");

		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;

		if(isFirefox){

		}if(isIE){

		}if(isEdge){

		}if(isChrome){
		}

		try{
			var childWindow = window.parent;
			childWindow.resizeTo(strWidth, strHeight);
		}catch(exception){
			console.log('window resizing cat not run dev mode.');
		}

	}

</script>

<form id="checkMessage" name="checkMessage" method="post"
	target="new_popup">
	<input type="hidden" id="resultMessage" name="resultMessage" value="" />
	<input type="hidden" id="resultContent" name="resultContent" value="" />
</form>

<input id="type" name="type" type="hidden" value="def"></input>
<input id="type" name="passChangeOption" type="hidden" value="Y"></input>

<div class="pop_wrap password_change2">
	<div id="dialog-form-background"
		style="display: none; background-color: #FFFFDD; filter: Alpha(Opacity = 50); z-Index: 8888; width: 100%; height: 100%; position: absolute; top: 1px; cursor: wait"></div>
	<div class="pop_head">
		<h1 id="title"></h1>
		<a href="#n" class="clo"><img
			src=${pageContext.request.contextPath}/Images/btn/btn_pop_clo01.png
			alt="" /></a>
	</div>
	<!-- //pop_head -->
	<div class="pop_con">
		<div class="text" id="content"></div>

		<div class="com_ta">
			<table>
				<colgroup>
					<col width="30%" />
					<col width="" />
				</colgroup>
				<tr
					<c:if test="${pageInfo eq 'empInfoPop'}">style="display:none;"</c:if> />
				<th><img
					src=${pageContext.request.contextPath}/Images/ico/ico_check01.png
					alt="" /><%=BizboxAMessage.getMessage("TX000006281", "기존비밀번호")%></th>
				<td><input autocomplete="new-password" type="password"
					id="pass" name="pass" style="width: 90%;" /></td>
				</tr>
				<tr>
					<th><img
						src=${pageContext.request.contextPath}/Images/ico/ico_check01.png
						alt="" /><%=BizboxAMessage.getMessage("TX000006282", "변경비밀번호")%></th>
					<td><input autocomplete="new-password" type="password"
						id="modPass" name="modPass" style="width: 90%;" /></td>
				</tr>
				<tr>
					<th><img
						src=${pageContext.request.contextPath}/Images/ico/ico_check01.png
						alt="" /><%=BizboxAMessage.getMessage("TX000016259", "변경비밀번호 확인")%></th>
					<td><input autocomplete="new-password" type="password"
						id="rePass" name="rePass" style="width: 90%;" /></td>
				</tr>
			</table>
		</div>

		<ul class="password_con mt10" id="detailPasswdOption">
			<li><%=BizboxAMessage.getMessage("TX000022479", "비밀번호 만료 기한")%> :
				<span class="text_blue" id="passDue"></span></li>
			<li><%=BizboxAMessage.getMessage("TX000022480", "입력 자리 수 제한")%> :
				<span class="text_blue" id="passDigit"></span></li>
			<li><%=BizboxAMessage.getMessage("TX000022481", "필수 입력 값")%> : <span
				class="text_blue" id="passRule"></span></li>
			<li><%=BizboxAMessage.getMessage("TX000022482", "입력 제한 값")%> : <span
				class="text_blue" id="passLimit"></span></li>
		</ul>

		<p class="text_red mt10 f11">
			※
			<%=BizboxAMessage.getMessage("TX000022475", "여러 사이트에서 사용하는 동일한 비밀번호나 쉬운 비밀 번호로 설정 시 도용될 위험이 있습니다.")%></p>

	</div>

	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="okBtn"
				value="<%=BizboxAMessage.getMessage("TX000000078", "확인")%>" />
			<c:if test="${passwdChangeNext == 'N'}">
				<input type="button" class="gray_btn" id="cancelBtn"
					value="<%=BizboxAMessage.getMessage("TX000002947", "취소")%>" />
			</c:if>
			<c:if test="${passwdChangeNext == 'Y'}">
				<input type="button" class="gray_btn" onclick="fnPasswordNext();"
					value="<%=BizboxAMessage.getMessage("TX000022613", "다음에 변경")%>" />
			</c:if>
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<!-- //pop_wrap -->

