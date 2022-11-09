<%@page import="org.apache.poi.hssf.record.formula.functions.Loginv"%>
<%@page import="bizbox.orgchart.service.vo.LoginVO"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<%
	LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
	System.out.println("loginVO : " + loginVO);
	System.out.println("loginVO.getEmail() : " + loginVO.getEmail());
	System.out.println("loginVO.getEmailDomain() : " + loginVO.getEmailDomain());

	String bemail = loginVO.getEmailDomain();
	
	if (loginVO.getEmailDomain() == null || loginVO.getEmailDomain().equals("") == false) {
		loginVO.setEmailDomain("testtttt");
	}
	
	String email = loginVO.getEmailDomain();
%>
<textarea style="width:600px; height:500px"><%=bemail%></textarea>

<textarea style="width:600px; height:500px"><%=email%></textarea>