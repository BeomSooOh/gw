<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>


<script>
 function callbackOrgChart(item) {
	
	 var idx = $("#idx").val();
	 
	 opener.setData("deptName", idx, item.name);
	
 } 

</script>

<!-- 팝업 개발은 했으나 window로 대체하면서 사용하지 않음. 추후 필요할 경우.. -->


<input type="hidden" id="idx" name="idx" value="${idx}" />

<h4>부서선택 </h4>
<div id="orgChartList" style="float: left">
	<jsp:include page='/systemx/orgChartList.do'>
		<jsp:param name="compSeq" value='<%=request.getAttribute("compSeq")%>' />
	</jsp:include>
</div>