

<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>

<script>
	$(document).ready(function() {
		if('<%=request.getParameter("devMode")%>' === 'dev'){
			$('#form').attr('action','http://bizboxa.duzonnext.com/gw/systemx/prjectPop.do');
			$('#callbackUrl').val( "<%=request.getParameter("devModeUrl")%>" + $('#callbackUrl').val());	
			$('#hid_form_groupSeq').val('demo');
		}else{
			$('#form').attr('action','/gw/systemx/prjectPop.do');
		}
		document.form.submit();

	});

	function callbackSelectProject(data) {
		var callback = data.callback;
		try {
			if (callback) {
				eval('opener.' + callback)(data);
			} else {
				opener.callbackSelectProject(data);
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

<body style="margin :0px; padding: 0px;">
	<div class="pop_wrap">
		<form id="form" name="form" target="_content" method="post" action="<%=request.getParameter("popUrlStr")%>">
		
		<input type="hidden" name="langCode" width="500" 		value="<%=request.getParameter("langCode")%>"/>
		<input type="hidden" name="groupSeq" width="500" 		value="<%=request.getParameter("groupSeq")%>" id="hid_form_groupSeq"/>
		<input type="hidden" name="compSeq" width="500" 		value="<%=request.getParameter("compSeq")%>"/>
		<input type="hidden" name="empSeq" width="500" 			value="<%=request.getParameter("empSeq")%>"/>	
		
		<input type="hidden" name="callback" width="500" 		value="<%=request.getParameter("callback")%>"/>
		<input type="hidden" name="callbackUrl" width="500" id ="callbackUrl"	value="<%=request.getParameter("callbackUrl")%>"/>
		</form>
		
		<iframe id="_content" name="_content" id="" src="" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
	</div>
</body>