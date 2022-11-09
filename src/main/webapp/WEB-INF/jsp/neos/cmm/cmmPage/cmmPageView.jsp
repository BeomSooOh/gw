<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
	
<script type="text/javascript">
<%
	String menu = request.getParameter("menuNm");
%>
	$(document).ready(function(){
		var menuName = "<%= menu %>";
		var detail = "";
		
		if(menuName == "bookMark") {
			detail = "<%=BizboxAMessage.getMessage("TX900000381","즐겨찾기 게시판이 없습니다")%>";
		}
		
		$(".location_info").remove();
		$(".title_div").remove();
		
		// $(".index_menu").html("'"+ menuName + "’<br />&nbsp;<%=BizboxAMessage.getMessage("TX000007347","상세메뉴를 선택하세요")%>'");
		//$(".index_menu").html("'’<br />&nbsp;<%=BizboxAMessage.getMessage("TX900000381","즐겨찾기 게시판이 없습니다")%>'");
		$(".index_menu").text("‘" + detail + "’");
	});
</script>

<!-- index 화면 -->
<div class="sub_index">
	<p class="index_menu">
		
	</p>
</div>
<!-- //index 화면 -->

