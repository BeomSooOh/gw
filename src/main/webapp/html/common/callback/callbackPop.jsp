<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<% 
	request.setCharacterEncoding("UTF-8");
	String data = request.getParameter("data");
	String callback = request.getParameter("callback");
	
	// 자식창 창 닫기 처리
	String popClose = "0";
	if (request.getParameter("popClose") != null) {
		popClose = request.getParameter("popClose");
	}
%>
 
<script type="text/javascript">
	var popClose = <%=popClose%>;

	if (popClose != null && popClose == '1') {
		parent.parent.popClose();
	} else {
		parent.parent.callbackSelectOrg(<%=data%>);
	}
	
	
</script>