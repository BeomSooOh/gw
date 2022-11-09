<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<style type="text/css">
html {
	overflow: hidden;
}
</style>

<script type="text/javascript">
	/* 변수정의 */
	var ID_check = true; /* id 중복 점검 ( 중복 : true / 미중복 : false ) */
	var Email_check = true; /* e-mail 중복 점검 ( 중복 : true / 미중복 : false ) */
	var isMailUse = "${isMailUse}"; /* 메일 사용여부 ( 사용 : Y / 미사용 : !Y ) */

	/* document ready */
	$(document).ready(function() {
		fnInit(); /* 페이지 초기화 */
		fnInitLayout(); /* 페이지 Layout 초기화 */
		fnInitEvent(); /* 페이지 Event 정의 */
	});

	/* fnInit - 페이지 초기화 */
	function fnInit() {
		return;
	}

	/* fnInitLayout - 페이지 Layout 초기화 */
	function fnInitLayout() {
		/* 기본 버튼 정의 */
		$(".controll_btn button").kendoButton();
		return;
	}

	/* fnInitEvent - 페이지 Event 정의 */
	function fnInitEvent() {
		return;
	}

	function ok() {		
		if (ID_check && Email_check) {
			if($("#changeID").val() == "" && $("#changeMail").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000010728", "정보를 다시 확인하세요")%>")
			}			
			else if (confirm("<%=BizboxAMessage.getMessage("TX000010729", "ID를 변경 하시겠습니까?")%>")) {
				var empSeq = "${params.empSeq}";
				var loginId = $("#changeID").val();
				updateLoginId(loginId, empSeq);
			}
		} else {
			alert("<%=BizboxAMessage.getMessage("TX000010728", "정보를 다시 확인하세요")%>")
		}
	}

	function updateLoginId(id, empSeq) {
		//var chkMail = $("input[name=changeMailId]:checked").val(); //메일 사용 여부
		var params = {};
		id = id.replace(/ /gi, "");
		$("#changeID").val($("#changeID").val().replace(/ /gi, ""));
		$("#beforeId").val($("#beforeId").val().replace(/ /gi, ""));
		$("#changeMail").val($("#changeMail").val().replace(/ /gi, ""));
		params.empSeq = $("#empSeq").val();
		params.deptSeq = $("#deptSeq").val();
		params.compSeq = $("#compSeq").val();
		params.afterId = $("#changeID").val();
		params.beforeId = $("#beforeId").val();
		params.emailAddr = $("#changeMail").val();
		params.mailUrl = "changeUserId.do";
		var getMailCode = '0';
// 		if (isMailUse == 'Y' && Email_check) {
<%-- 			getMailCode = setMailId("changeUserId.do", "<%=BizboxAMessage.getMessage("TX000010727", "메일 ID 변경")%>", params); --%>
// 			console.log("getMailCode : " + getMailCode);
// 			Email_check = false;
// 		}
		if (Email_check && ID_check) {
			var params = {};
			params.loginId = id;
			params.empSeq = empSeq;
			params.ID_check = ID_check;
			params.Email_check = Email_check
			params.emailId = $("#changeMail").val();
			params.compSeq = $("#compSeq").val();
			$.ajax({
				type: "post",
				url: "empLoginIdSaveProc.do",
				datatype: "text",
				async: false,
				data: params,
				success: function(data) {
					if (data.resultCode != "fail") {
						alert("<%=BizboxAMessage.getMessage("TX000010726", "ID가 변경되었습니다")%>");
						opener.gridRead();
						self.close();
					} else {
						alert(data.result);
					}
				},
				error: function(e) { //error : function(xhr, status, error) {
					alert("error");
				}
			});
		} else if (getMailCode == '0') {
			alert("<%=BizboxAMessage.getMessage("TX000010725", "Email ID가 변경되었습니다")%>");
			self.close();
		} else if (getMailCode == '1') {
			alert("<%=BizboxAMessage.getMessage("TX000010724", "ID변경시 오류가 발생하였습니다.관리자에게 문의 바랍니다.")%>");
		} else if (getMailCode == '2') {
			alert("<%=BizboxAMessage.getMessage("TX000010723", "변경하려는 ID가 없습니다.관리자에게 문의 바랍니다.")%>");
		} else if (getMailCode == '3') {
			alert("<%=BizboxAMessage.getMessage("TX000010722", "사용자seq가 맞지 않습니다.관리자에게 문의 바랍니다.")%>");
		} else if (getMailCode == '4') {
			alert("<%=BizboxAMessage.getMessage("TX000010721", "변경하려는 ID가 존재합니다.관리자에게 문의 바랍니다.")%>");
		}
	}


	function checkLoginId(id) {
		if (id != null && id != '' && id.length > 0) {
			$.ajax({
				type: "post",
				url: "empLoginIdCheck.do",
				datatype: "text",
				data: {
					loginId: id
				},
				success: function(data) {
					if (data.result == 0) {
						$("#info").prop("class", "text_blue f11 mt5");
						$("#info").html("<%=BizboxAMessage.getMessage("TX000010720", "사용가능한 ID입니다")%>");
						ID_check = true;
					} else if (data.result == 1) {
						$("#info").prop("class", "text_red f11 mt5");
						$("#info").html("! <%=BizboxAMessage.getMessage("TX000010719", "이미 사용중인 ID 입니다")%>");
						ID_check = false;
					} else if (data.result == 2) {
						$("#info").prop("class", "text_red f11 mt5");
						$("#info").html("! <%=BizboxAMessage.getMessage("TX900000141", "추측하기 쉬운 단어입니다")%>");
						ID_check = false;
					}
				},
				error: function(e) { //error : function(xhr, status, error) {
					alert("error");
				}
			});
		} else {
			$("#info").prop("class", "text_red f11 mt5");
			$("#info").html("");
			ID_check = true;
		}

		var id = $("#changeID").val();
		//             $("#changeID").val(id.toLowerCase());
		$("#changeMail").val(id);
		checkEmailId($("#changeMail").val());
	}

	function checkEmailId(id) {

		var checkId = /[A-Z]/;

		if (checkId.test(id)) {
			Email_check = false;
			$("#email_info").prop("class", "text_red f11 mt5");
			$("#email_info").html("<%=BizboxAMessage.getMessage("TX000016330", "대문자를 포함할 수 없습니다.")%>");
			return;
		}

		checkId = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
		if (checkId.test($("#changeMail").val())) {
			Email_check = false;
			$("#email_info").prop("class", "text_red f11 mt5");
			$("#email_info").html("<%=BizboxAMessage.getMessage("TX900000142", "한글을 포함할 수 없습니다.")%>");
			return;
		}

		var reg_email = /^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*$/;

		if (id.search(reg_email) < 0) {
			if(id != ''){
				Email_check = false;
				$("#email_info").prop("class", "text_red f11 mt5");
				$("#email_info").html("<%=BizboxAMessage.getMessage("TX900000143", "특수문자나 공백을 포함할 수 없습니다.")%>");				
				return;
			}else{
				$("#email_info").html("");
				Email_check = true;
			}
		}

		if (id != null && id != '') {
			$.ajax({
				type: "post",
				url: "empLoginIdCheck.do",
				datatype: "text",
				data: {
					emailAddr: id
				},
				success: function(data) {
					if (id == "${empInfo.emailAddr}") {
						$("#email_info").prop("class", "text_red f11 mt5");
						$("#email_info").html("! <%=BizboxAMessage.getMessage("TX000010719 ", "이미 사용중인 ID 입니다 ")%>");
						Email_check = false;
					} else if (data.result == 0) {
						$("#email_info").prop("class", "text_blue f11 mt5");
						$("#email_info").html("<%=BizboxAMessage.getMessage("TX000010720 ", "사용가능한 ID입니다 ")%>");
						Email_check = true;
					} else if (data.result == 1) {
						$("#email_info").prop("class", "text_red f11 mt5");
						$("#email_info").html("! <%=BizboxAMessage.getMessage("TX000010719 ", "이미 사용중인 ID 입니다 ")%>");
						Email_check = false;
					} else if (data.result == 2) {
						$("#email_info").prop("class", "text_red f11 mt5");
						$("#email_info").html("! <%=BizboxAMessage.getMessage("TX900000141", "추측하기 쉬운 단어입니다")%>");
						Email_check = false;
					}

				},
				error: function(e) { //error : function(xhr, status, error) {
					alert("error");
				}
			});
		} else if (id == '') {
			$("#email_info").prop("class", "text_red f11 mt5");
			$("#email_info").html("");
			Email_check = true;
		}
	}

	function msgChange(msgCd) {
		$("#alertMsg").css('color', 'red');
		if (msgCd == '0') {
			$("#alertMsg").text('!<%=BizboxAMessage.getMessage("TX000010716", "변경 ID와 동일하게 메일 ID도 변경처리 됩니다")%>');
		} else {
			$("#alertMsg").text('!<%=BizboxAMessage.getMessage("TX000010715", "메일 ID는 변경되지 않습니다")%>' );
		}
	}
</script>

<div class="pop_wrap_dir" style="width: 800px; overlfow-y: hidden">
	<input type="hidden" id="empSeq" value='${params.empSeq}' /> <input type="hidden" id="deptSeq" value='${params.deptSeq}' /> <input type="hidden" id="compSeq" value='${params.compSeq}' /> <input type="hidden" id="beforeId" value='${params.loginId}' />

	<%-- <div class="pop_head"> <h1>로그인 ID 변경</h1> <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a> </div><!-- //pop_head --> --%>
	<div class="pop_con">
		<p class="tit_p">
			<%=BizboxAMessage.getMessage( "TX000006332", "사용자정보" )%>
		</p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="130" />
					<col width="" />
					<col width="130" />
					<col width="" />
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage( "TX000000047", "회사" )%></th>
					<td>${params.compNm}</td>
					<th><%=BizboxAMessage.getMessage( "TX000000098", "부서" )%></th>
					<td>${params.deptNm}</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage( "TX000016418", "ID" )%></th>
					<td>${params.loginId}</td>
					<th><%=BizboxAMessage.getMessage( "TX000000277", "이름" )%></th>
					<td>${params.empNm}</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage( "TX000000099", "직급" )%></th>
					<td>${params.positionCodeNm}</td>
					<th><%=BizboxAMessage.getMessage( "TX000000105", "직책" )%></th>
					<td>${params.dutyCodeNm}</td>
				</tr>
			</table>
		</div>

		<p class="tit_p mt20">
			<%=BizboxAMessage.getMessage( "TX000006225", "변경아이디" )%>
		</p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="140" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage( "TX000016260", "변경ID" )%></th>
					<td><input type="text" style="width: 200px;" onkeyup="checkLoginId(this.value);" id="changeID" name="changeID" /> <span id="info" name="info" class="text_blue ml10"></span> <!-- 유효성문구 개발단 처리
						<span id="" class="text_blue ml10">! 사용가능한 ID입니다.</span>
						<span id="" class="text_red ml10">! 중복된 ID 입니다.</span>
						 --></td>
				</tr>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage( "TX000010727", "메일 ID 변경" )%></th>
					<td><input type="text" style="width: 200px;" id="changeMail" name="changeMail" onkeyup="checkEmailId(this.value);" onchange="checkEmailId(this.value);" /> <span class="text_red ml10" id="email_info"></span>
						<p class="pt6 f11">
							ㆍ
							<%=BizboxAMessage.getMessage( "TX000016289", "메일 ID를 변경하여도 기존  메일 정보는 사용 가능 합니다." )%>
						</p> <!-- <input type="radio" name="changeMailId" onchange="msgChange('0')" id="changeMailI0" class="k-radio" checked value="0">
	                    <label class="k-radio-label" for="changeMailI0" style="padding:0.2em 0 0 1.5em;">예</label>
	                    <input type="radio" name="changeMailId" onchange="msgChange('1')" id="changeMailId1" class="k-radio" value="1">
	                    <label class="k-radio-label" for="changeMailId1" style="margin:0 0 0 10px; padding:0.2em 0 0 1.5em;" >아니오</label>
                        
                        <label id="alertMsg"></label> --> <!-- 유효성문구 개발단 처리
                        <span id="" class="text_blue ml10">! 사용가능한 ID입니다.</span>
                        <span id="" class="text_red ml10">! 중복된 ID 입니다.</span>
                         --></td>
				</tr>
			</table>
		</div>
	</div>
	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage( "TX000001256", "저장" )%>" onclick="ok();" /> <input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage( "TX000002947", "취소" )%>" onclick="javascript:window.close();" />
		</div>
	</div>
	<!-- //pop_foot -->
	<div id="dialog-form-background" style="display: none; background-color: #FFFFDD; filter: Alpha(Opacity = 50); z-Index: 8888; width: 100%; height: 100%; position: absolute; top: 1px"></div>
</div>
<!-- //pop_wrap -->
