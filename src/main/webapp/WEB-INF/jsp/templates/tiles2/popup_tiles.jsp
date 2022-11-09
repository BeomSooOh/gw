<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles" 	uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<script>
		var langCode = "<%=langCode%>";
	</script>
	<!--  kendo ui 관련 js, css  -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />" ></link>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />" ></link>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />" ></link>
		
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" ></link>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">	
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />" >
	
	
	
    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js?ver=20201021' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/common.js?ver=20201021'/>"></script> 
	
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
	
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js?ver=20201021' />"></script>
	    
	<script type="text/javascript"> 

	
	/* tiles : popup_tiles.jsp */
		_g_contextPath_ = "${pageContext.request.contextPath}";
	</script>

	<script type="text/javascript">
		// redirect msg 처리
		<c:if test="${not empty msg}">
			alert('${msg}');
		</c:if>
		
    	document.addEventListener('keydown', function(event) {
    		  if (event.keyCode === 13) {
    		    event.preventDefault();
    		  };
    	}, true);		
		
		$(document).ready(function() {
			if(window.location.protocol.indexOf("http:") > -1) {
				if(opener != null && !opener.closed && opener.document != null){
					var title = opener.document.title;
					if(title != "")
						document.title = title;				
				}
			}
		});
	</script>
</head>
<body>
	<tiles:insertAttribute name="body" />
</body>
</html>