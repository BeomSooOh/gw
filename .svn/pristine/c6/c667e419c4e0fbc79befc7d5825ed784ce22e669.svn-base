<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

 <script src="../js/kendoui/jquery.min.js"></script>

<script>
	$(document).ready(function() {
		document.form.submit();
	});

	function callbackSelectUser(data) {
		opener.callbackSelectUser(data);
		window.close();
	}
</script>

<form id="form" name="form" target="_content" method="post" action="http://bizboxa.duzonnext.com/gw/cmm/systemx/cmmOcType1Pop.do">
	<input type="hidden" name="mode" value="<%request.getParameter("groupSeq");%>">
	<input type="hidden" name="groupSeq" value="<%request.getParameter("groupSeq");%>">
	<input type="hidden" name="compSeq" value="<%request.getParameter("compSeq");%>">
	<input type="hidden" name="langCode" value="<%request.getParameter("langCode");%>">
	<input type="hidden" name="type" value="<%request.getParameter("type");%>">
	<input type="hidden" name="moduleType" value="<%request.getParameter("moduleType");%>">
	<input type="hidden" name="selectType" value="<%request.getParameter("selectType");%>">
	<input type="hidden" name="callback" value="<%request.getParameter("callback");%>">
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/callbackPop.jsp' />">
	<input type="hidden" name="selectedList" value="<%request.getParameter("selectedList");%>">
	<input type="hidden" name="selectedOrgList" value="<%request.getParameter("selectedOrgList");%>">
	<input type="hidden" name="duplicateOrgList" value="<%request.getParameter("duplicateOrgList");%>">
</form>

	
<iframe id="_content" name="_content" id="" src="" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>

    