<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>
	$(document).ready(function() {
		
		var result = '${result}';
		
		if (result != null && result.length > 0) {
			var r = parseInt(result);
			if (r > 0) {
				alert("<%=BizboxAMessage.getMessage("TX000010958","나의메뉴설정 완료")%>");
				opener.myMenu();
				window.close(); 
			} else { 
				lert("<%=BizboxAMessage.getMessage("TX000010957","나의메뉴설정 실패")%>");
			}
		}
		
		$("#initBtn").on("click",function(e){
			$("input[name=menuNo]:checkbox").attr("checked", false);
		});
		
		$("input[name=menuNo]:checkbox").on("change",function(e){
			var cnt = $("input[name=menuNo]:checked").length;
			if (cnt > 16) {
				alert("<%=BizboxAMessage.getMessage("TX000010956","최대 16개까지 메뉴 설정이 가능합니다")%>");
			}
		});
		
		$("#okBtn").on("click",function(e){
			var cnt = $("input[name=menuNo]:checked").length;
			if (cnt > 16) {
				alert("<%=BizboxAMessage.getMessage("TX000010956","최대 16개까지 메뉴 설정이 가능합니다")%>");
			} else {
				document.form.submit();
			}
		});
		
		$("#cancelBtn").on("click",function(e){
			window.close();
		});
		
		mymenuSize()
		
		$(window).resize(function() {
			mymenuSize()
		});
	});
	
	// 마이메뉴 테이블 높이지정
	function mymenuSize(){
	     var mm_hei=$("html").height()-150;
	     $(".mymenuSize").height(mm_hei);
	}

</script>

<form id="form" name="form" method="post" action="myMenuSetPopSaveProc.do">
<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016037","나의메뉴설정")%></h1>
		<a href="#n" class="clo"  onclick="javascript:window.close();"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
	</div>

	<div class="pop_con">
		<h2><%=BizboxAMessage.getMessage("TX000016037","나의메뉴설정")%></h2>
		<div class="com_ta3 scroll_on mymenuSize" style="min-height:450px">
			<table class="mymenu">
				<colgroup>
					<c:forEach begin="1" end="${fn:length(gubunList)}" step="1">
						<col width=""/>
					</c:forEach>
				</colgroup>
				<c:forEach items="${menuList}" var="list" varStatus="i">
					<tr>
						<c:forEach items="${gubunList}" var="clist" varStatus="c">
							<c:set var="columName" value="${clist}${c.count-1}" /> 
							<c:if test="${i.count == 1 }">
								<th class="cen">${list[columName].name}</th> 
							</c:if>
							<c:if test="${i.count > 1}">
								<c:if test="${list[columName].lvl == 2}">
								<td class="tit pl10"><span>${list[columName].name}</span></td>
								</c:if>
								<c:if test="${list[columName].lvl == 3}">
								<td class="le pl10"><input type="checkbox" id="mymemu${i.count}_${c.count}" name="menuNo" class="k-checkbox" ${list[columName].isChecked} value=" ${list[columName].menuNo}" ><label class="k-checkbox-label" for="mymemu${i.count}_${c.count}" style="padding:0.2em 0 0 1.5em;">${list[columName].name}</label></td>
								</c:if>
								<c:if test="${empty list[columName].lvl}">
									<td class="le pl10"></td>
								</c:if>
							</c:if> 
						</c:forEach>   
					</tr>  
				</c:forEach>
			</table>
		</div>
	</div><!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000002960","초기화")%>" id="initBtn" />
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" id="okBtn" />
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" id="cancelBtn" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->
</form>