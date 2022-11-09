<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="agentInfo.jsp"%>
<%
    String resultCode = session.getAttribute("resultCode") == null ? "" : session.getAttribute("resultCode").toString();
    String resultData = session.getAttribute("resultData") == null ? "" : session.getAttribute("resultData").toString();

	if(resultCode .equals("000000")){
		//인증성공
		session.setAttribute("SSO_ID", resultData);
		response.sendRedirect("/gw/CustLogOn.do");

	}else{
		//인증실패


	}
%>