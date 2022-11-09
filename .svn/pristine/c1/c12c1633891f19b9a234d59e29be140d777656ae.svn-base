<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script>
		var langCode = "<%=langCode%>";
	</script>
	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js?ver=20201021' />"></script>
	<!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">	
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />"> 
	<%if(langCode.equals("KR")){ %>
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/kr.css' />">
	<%}else if(langCode.equals("EN")){ %>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/en.css' />">
    <%}else if(langCode.equals("JP")){ %>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/jp.css' />">
    <%}else if(langCode.equals("CN")){ %>
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/cn.css' />">
	<%}%>
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
	
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    
</head>	 
    
<body> 
	
	<tiles:insertAttribute name="body" /> 
 
</body>

</html>
