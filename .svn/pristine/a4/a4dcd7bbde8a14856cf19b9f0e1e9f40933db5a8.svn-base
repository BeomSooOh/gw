<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
		$(document).ready(function() {
		//기본버튼
           $(".controll_btn button").kendoButton();
		});
	</script>

<div class="pop_wrap re_draft_pop" style="width:358px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000006520","설정")%></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
	</div>	
	
	<form id="form" name="form" method="post" action="projectSyncSetProc.do">
	<div class="pop_con">			
		<p><%=BizboxAMessage.getMessage("TX000016427","ERP 정보 싱크 유형")%></p>
		<div class="box_gray">
			<table class="mt5">
				<tr>
					<td>
					<input type="radio" id="pop_ra_u1" name="isSyncAuto"class="k-radio" <c:if test="${isSyncAuto == 'Y'}">checked</c:if> value="Y" />
					<label class="k-radio-label" for="pop_ra_u1" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000012458","자동")%></label>
					<input type="text" name="cycleCount" style="width:100px; text-align:right" value="${cycleCount}" /> <%=BizboxAMessage.getMessage("TX000001229","분")%>
					 
					<input type="radio" id="pop_ra_u2" name="isSyncAuto" class="k-radio" <c:if test="${isSyncAuto == 'N'}">checked</c:if> value="N" />
					<label class="k-radio-label" for="pop_ra_u2" style="margin:0 0 0 15px;padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000012459","수동")%></label>
					</td>
				</tr>
			</table>
			<p class="mt10"><%=BizboxAMessage.getMessage("TX000016133","정보 싱크의 주기는 분단위로 설정이 가능하며")%></p>
			<p class=""><%=BizboxAMessage.getMessage("TX000016445","10분을 권장합니다.")%> </p>
		</div>
	</div>
	</form>
	
	<div class="pop_foot">
		<div class="btn_cen">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="document.form.submit()" />
			<input type="button" class="gray_btn" onclick="window.close()"  value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>
</div>

