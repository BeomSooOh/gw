<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

 <script src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>

<script>
	$(document).ready(function() {
		document.form.submit();
	});

	function callbackSelectOrg(data) {
		var callback = data.callback;
		try {
			if (callback) {
				eval('opener.' + callback)(data);
			} else {
				opener.callbackSelectUser(data);
			}
		} catch(exception) {
			console.log(exception);//오류 상황 대응 부재
		} 
		
		window.close(); 
	}
	
	function popClose() {
		window.close();
	}
</script>

<%
	String selectedAddrList = request.getParameter("selectedAddrList")+"";
	selectedAddrList = URLEncoder.encode(selectedAddrList, "UTF-8");
	String selectedList = request.getParameter("selectedList")+"";
	selectedList = URLEncoder.encode(selectedList, "UTF-8");
	String selectedOrgList = request.getParameter("selectedOrgList")+"";
	selectedOrgList = URLEncoder.encode(selectedOrgList, "UTF-8");
	String duplicateOrgList = request.getParameter("duplicateOrgList")+"";
	duplicateOrgList = URLEncoder.encode(duplicateOrgList, "UTF-8");
%>


<%-- <form id="form" name="form" target="_content" method="post" action="http://bizboxa.duzonnext.com/gw/cmm/systemx/cmmOcType1Pop.do"> --%>
<form id="form" name="form" target="_content" method="post" action="<%=request.getParameter("popUrlStr")%>">
	<input type="hidden" name="mode" value="<%=request.getParameter("mode")%>">
	<input type="hidden" name="groupSeq" value="<%=request.getParameter("groupSeq")%>">
	<input type="hidden" name="compSeq" value="<%=request.getParameter("compSeq")%>">
	<input type="hidden" name="deptSeq" value="<%=request.getParameter("deptSeq")%>">
	<input type="hidden" name="langCode" value="<%=request.getParameter("langCode")%>">
	<input type="hidden" name="type" value="<%=request.getParameter("type")%>">
	<input type="hidden" name="moduleType" value="<%=request.getParameter("moduleType")%>">
	<input type="hidden" name="selectType" value="<%=request.getParameter("selectType")%>">
	<input type="hidden" name="callback" value="<%=request.getParameter("callback")%>">
	<input type="hidden" name="isGroupAll" value="<%=request.getParameter("isGroupAll")%>">
	<input type="hidden" name="callbackUrl" value="<%=request.getParameter("callbackUrl")%>">
	<input type="hidden" name="selectedList" value="<%=selectedList%>">
	<input type="hidden" name="selectedOrgList" value="<%=selectedOrgList%>">
	<input type="hidden" name="duplicateOrgList" value="<%=duplicateOrgList%>">
	<input type="hidden" name="selectedAddrList" value="<%=selectedAddrList%>">
</form>

	
<iframe id="_content" name="_content" id="" src="" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>

    