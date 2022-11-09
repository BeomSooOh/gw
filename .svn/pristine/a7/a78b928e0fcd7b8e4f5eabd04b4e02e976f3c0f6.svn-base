<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="main.web.BizboxAMessage"%>

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!--수정 배포된 Js파일 캐시 방지  -->
<% Date date = new Date();
   SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMddHHmm");
   String strDate = simpleDate.format(date);   
%>

<c:set var="date" value="<%=strDate%>" />
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko" style="overflow-y:hidden">
<head>
	<meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script>
		var langCode = "<%=langCode%>";
	</script>
	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js?ver=20201021' />"></script>
	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />

	<!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">	
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />"> 
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
    
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js' />"></script>
    <%-- <script type="text/javascript" src="<c:url value='/js/neos/resize_iframe.js' />"></script> --%>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js?ver=20201021' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	
	<%if(langCode.equals("KR")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
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
	
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js?ver=20201021' />"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.menu.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.main.js?ver=20201021' />"></script>
    
     <!-- top js -->
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script>
    
	<script type="text/javascript">
	$(document).ready(function() {
		
		var no = '${params.no}';
		var name = '${params.name}';
		var lnbName = '${params.lnbName}';
		var url = '${params.url}';
		var urlGubun = '${params.urlGubun}';
		var mainForward = '${params.mainForward}';
		var gnbMenuNo = '${params.gnbMenuNo}';
		var lnbMenuNo = '${params.lnbMenuNo}';
		var portletType = '${params.portletType}';
		
		var popYn = '${params.popYn}';
		var popUrl = '${params.popUrl}';
		
		
		if(popYn == "Y") {
			window.open(popUrl)
		}
		
		if(urlGubun == "eap") {
			//alert(urlGubun+" / "+popYn+" / "+popUrl);
			mainmenu.clickTopBtn(no, name, '', '');
		}
		else {
			menu.forwardFromMain(portletType, gnbMenuNo, lnbMenuNo, url, urlGubun, name , lnbName , mainForward);
		}
				
	});
	</script>
     
</head>


<body class="">
	<!-- Header -->
	<div class="header_wrap"> 
		<jsp:include page="/topGnb.do" /> 
	</div> 
	 
	<!-- contents -->
	<div class="contents_wrap">
		<div id="horizontal">
			<div class="side_wrap"> 
				<h2 class="sub_nav_title"></h2> 
				<div class="nav_div">
					<ul id="sub_nav" style="border-width:0"></ul>
				</div>	
			</div>
			<div class="sub_wrap">
				<div class="sub_contents">
						<!-- iframe 영역 -->  
						<iframe name="_content" id="_content" class="" frameborder="0" scrolling="yes" width="100%" height="100%" onload="$('#_content').contents().on('click keyup', function() { localStorage.setItem('LATime', (+new Date())); });"></iframe>
				</div> 
			</div>  
		</div> <!--//# horizontal -->
			

	  	<div class="footer">
			<span class="copy" id="footerText"></span>
			<ul class="sub_etc">
			<jsp:include page="/footer.do" />
			</ul>
		</div>
	  	
	</div> 
	<div id="formWindow"></div>	
	<form id="form" name="form" action="bizbox.do" method="post">  
		<input type="hidden" id="no" name="no" value="" />
		<input type="hidden" id="name" name="name" value="" /> 
		<input type="hidden" id="lnbName" name="lnbName" value="" /> 
		<input type="hidden" id="url" name="url" value="" />
		<input type="hidden" id="urlGubun" name="urlGubun" value="" />
		<input type="hidden" id="mainForward" name="mainForward" value="" />
		<input type="hidden" id="gnbMenuNo" name="gnbMenuNo" value="" />
		<input type="hidden" id="lnbMenuNo" name="lnbMenuNo" value="" />
		<input type="hidden" id="seq" name="seq" value="" />
		<input type="hidden" id="portletType" name="portletType" value="" />
		<input type="hidden" id="popYn" name="popYn" value="" />
		<input type="hidden" id="popUrl" name="popUrl" value="" />
		<input type="hidden" id="tsearchKeyword"  value="" />
	</form>  
	
	
	
	<script>
	
		function init(){}
		
		// 조직도 팝업
		function orgChartPop() {
			var url = "<c:url value='/cmm/systemx/orgChartAllEmpInfo.do'/>";
			openWindow2(url,  "orgChartPop", 1000, 713, 0, 1);
		}
		
		
		
		_g_contextPath_ = "${pageContext.request.contextPath}";
		_g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
	</script>
	
</body>
</html>
