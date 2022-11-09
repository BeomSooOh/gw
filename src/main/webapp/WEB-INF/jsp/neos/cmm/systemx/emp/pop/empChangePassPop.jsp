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

	var buildType = "${buildType}";

	/* document ready */
	$(document).ready(function() {
		fnInitLayout(); /* 페이지 Layout 초기화 */
	});

	/* fnInitLayout - 페이지 Layout 초기화 */
	function fnInitLayout() {
		/* 기본 버튼 정의 */
		$(".controll_btn button").kendoButton();
		return;
	}

	function ok() {
		
		if($("#changePass").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000012873", "필수값을 입력해 주세요")%>")
			$("#changePass").focus();
			return;
		}
		
		if (confirm("<%=BizboxAMessage.getMessage("TX900000144", "비밀번호를 초기화 하시겠습니까?")%>")) {
			
			var params = {};
			params.empSeq = "${params.empSeq}";
			params.newPasswd = $("#changePass").val();
			params.compSeq = "${params.compSeq}";
			params.loginSetCheck = $("#loginSetCheck").is(":checked") ? "Y" : "N";
			if(buildType == "cloud"){
				params.loginSetCheck = "Y";
			}

			$.ajax({
				type: "post",
				url: "empLoginPasswdResetProc.do",
				datatype: "text",
				async: false,
				data: params,
				success: function(data) {
					if (data.resultCode != "fail") {
						alert("<%=BizboxAMessage.getMessage("TX000019529", "초기화 되었습니다.")%>");
						self.close();
					} else {
						alert(data.result);
					}
				},
				error: function(e) {
					alert("error");
				}
			});			
		}		
	}

</script>

<div class="" style="width: 800px; overlfow-y: hidden">
	
	<div class="pop_head">
		<h1>
		<%=BizboxAMessage.getMessage("TX900000145","비밀번호 초기화")%>
		</h1>
		<a href="#n" class="clo"><img
			src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div>	

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
			<%=BizboxAMessage.getMessage( "TX900000146", "로그인/ 결재/ 급여비밀번호초기화" )%>
		</p>
		
		<p class="pb5 f11" style="padding-bottom: 6px;">
			<c:if test="${buildType eq 'cloud'}">
				<%=BizboxAMessage.getMessage( "", "사용자 로그인 시 비밀번호 재설정이 필요합니다." )%>
			</c:if>
			<c:if test="${buildType ne 'cloud'}">
			<%=BizboxAMessage.getMessage( "TX900000147", "사용자 로그인 시 재설정 체크박스를 선택하면,사용자 로그인 시 비밀번호 재설정이 필요합니다." )%>
			</c:if>
		</p>		
		
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="140" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage( "TX900000148", "초기화비밀번호" )%></th>
					<td>
						<input type="password" style="width: 200px;" id="changePass" name="changePass" />
						<c:if test="${buildType ne 'cloud'}">
							<p class="f11" style="float: right;padding-top: 5px;">
								<input id="loginSetCheck" type="checkbox" checked />
								<%=BizboxAMessage.getMessage( "TX900000149", "사용자 로그인 시 재설정" )%>
							</p>				
						</c:if>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage( "TX000000078", "확인" )%>" onclick="ok();" /> <input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage( "TX000002947", "취소" )%>" onclick="javascript:window.close();" />
		</div>
	</div>
	<!-- //pop_foot -->
	<div id="dialog-form-background" style="display: none; background-color: #FFFFDD; filter: Alpha(Opacity = 50); z-Index: 8888; width: 100%; height: 100%; position: absolute; top: 1px"></div>
</div>
<!-- //pop_wrap -->
