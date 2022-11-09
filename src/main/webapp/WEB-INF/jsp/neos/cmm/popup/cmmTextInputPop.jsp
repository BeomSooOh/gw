<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>
<script>
	$(document).ready(function() {
		$("#okBtn").on("click", ok);
	});
	
	function ok() {
		var callback = '${callback}';
		
		if (callback) {
			eval('window.opener.' + callback)('', $("#inputText").val(),'${detailCode}','${orgSeq}','${imgOsType}');
		}
		window.close();
	}
	
</script>


<div class="pop_wrap" style="width:558px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016404","TEXT 입력")%></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div>

	<div class="pop_con">	
		<div class="com_ta2 hover_no">
			<table>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016404","TEXT 입력")%></th>
				</tr>
				<tr>
					<td><input type="text" id="inputText" style="width:500px" /></td>
				</tr>
			</table>
		
		</div>
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="okBtn" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" class="gray_btn" onclick="javascript:window.close()" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->
    