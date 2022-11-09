<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>


<body onload="document.getElementById('ssoPost').submit();">
	<form id="ssoPost" action="${ssoPostParam.ssoPostUrl}" method="post" style="display:none;">
	
		<c:if test="${ssoPostParam.ssoEmpCtlName != ''}">
			<input type="text" name="${ssoPostParam.ssoEmpCtlName}" value="${ssoPostParam.ssoEmpCtlVal}" />
		</c:if>
		
		<c:if test="${ssoPostParam.ssoPwdCtlName != ''}">
			<input type="text" name="${ssoPostParam.ssoPwdCtlName}" value="${ssoPostParam.ssoPwdCtlVal}" />
		</c:if>
	
		<c:if test="${ssoPostParam.ssoLogincdCtlName != ''}">
			<input type="text" name="${ssoPostParam.ssoLogincdCtlName}" value="${ssoPostParam.ssoLogincdCtlVal}" />
		</c:if>
		
		<c:if test="${ssoPostParam.ssoCoseqCtlName != ''}">
			<input type="text" name="${ssoPostParam.ssoCoseqCtlName}" value="${ssoPostParam.ssoCoseqCtlVal}" />
		</c:if>
		
		<c:if test="${ssoPostParam.ssoErpempnoCtlName != ''}">
			<input type="text" name="${ssoPostParam.ssoErpempnoCtlName}" value="${ssoPostParam.ssoErpempnoCtlVal}" />
		</c:if>			
			
		<c:if test="${ssoPostParam.ssoErpcocdCtlName != ''}">
			<input type="text" name="${ssoPostParam.ssoErpcocdCtlName}" value="${ssoPostParam.ssoErpcocdCtlVal}" />
		</c:if>
		
		<c:if test="${ssoPostParam.ssoEtcCtlYn == 'Y'}">
			<input type="text" name="${ssoPostParam.ssoEtcCtlName}" value="${ssoPostParam.ssoEtcCtlValue}" />
		</c:if>		
	
	</form>
</body>
