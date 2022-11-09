
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>${title }</title>
    <script type="text/javascript">
    /* tiles : contents_tiles.jsp */ 
        _g_contextPath_ = "${pageContext.request.contextPath}";
        
		var langCode = "<%=langCode%>";
        
    </script>

    <!--  kendo ui 관련 js, css  -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.default.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.default.min.css' />" ></link> 
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />" ></link>
    
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" ></link>
    
    <!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">    
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />" >
    
    <!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />" ></link>
    
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
    
    <%if(langCode.equals("KR")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/kr.css' />">
    <%}else if(langCode.equals("EN")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.en-US.min.js'/>"></script>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/en.css' />">
    <%}else if(langCode.equals("JP")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ja-JP.min.js'/>"></script>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/jp.css' />">
    <%}else if(langCode.equals("CN")){ %>
		<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.zh-CN.min.js'/>"></script>
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/cn.css' />">
	<%}%>
    
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js?ver=20201021'/>"></script>
    
<script type="text/javascript">


	$(function(){
		pop_loading(); 
	});
	// edward contents loading Bar 
	function pop_loading() {
		$("#pop_loading").css("visibility","hidden");  
		$("#pop_contents").css("visibility","visible"); 
		$("#pop_loading").fadeOut(); 
		$("#pop_contents").fadeIn();			
	}
	/* tiles : lump_popup_tiles.jsp */
    _g_contextPath_ = "${pageContext.request.contextPath}";
    _g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
    _g_approvalImgMethodType ="<nptag:commoncode  codeid = 'APRIMG' code='IMGSIGNTYPE' />";
    _g_outFileLimitYN ="<nptag:commoncode  codeid = 'DOC003' code='OUT_FILELIMITYN' />";
</script>


</head>
<body>

<div id="pop_loading" style="position:fixed; top:50%; left:50%;  margin-top:-5px; margin-left:-8px; /*visibility: visible;*/">
    <img src="<c:url value='/Images/ajax-loader.gif'/>" />
</div>
<%-- <div id="pop_contents" style="visibility:hidden;">
	<tiles:insertAttribute name="body" />
</div>	 --%>
<tiles:insertAttribute name="body" />
</body>
</html>