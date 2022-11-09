<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<script type="text/javascript" src='<c:url value="/js/datatables/jquery.dataTables.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.select.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.scroller.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.rowReorder.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.fixedHea검색er.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ex/CommonEX.js"></c:url>'></script>

<script type="text/javascript">
	$(document).ready(function() {	
		//기본버튼
	   $(".controll_btn button").kendoButton();
	});
	
	function ok(){
		self.close();
	}
</script>


<body>
<div class="pop_wrap" style="width:443px;">
	<div class="pop_head">
		<h1>Bizbox Alpha</h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		
	</div>
	<div class="pop_con">
		<table class="" style="width:100%; text-align: center;">
			<tr>
				<td>
					<span><%=BizboxAMessage.getMessage("TX900000460","다른 사용자가 사용중인 ERP 사번 입니다.")%></span><br/>
					<span><%=BizboxAMessage.getMessage("TX900000461","중복 등록 할 수 없습니다.")%></span><br/>
					<span>[<%=BizboxAMessage.getMessage("TX900000462","사용중인 사원")%> : <span class="text_blue f11 mt5 fwb">${empInfo}</span>]</span>		
				</td>
			</tr>
		</table>
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="ok();"/>
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->
</body>