<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script>
   function getEmpInfo(item) {
	
	   opener.callbackEmp(item);
	   
	   window.close();
   }

</script>

<jsp:include page='/systemx/orgChartEmpList.do'>
	<jsp:param name="compSeq" value='<%=request.getAttribute("compSeq")%>' />
</jsp:include>




