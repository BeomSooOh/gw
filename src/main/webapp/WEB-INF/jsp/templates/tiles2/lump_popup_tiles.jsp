<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="min-width:860px">
<head>
	<meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!-- <base target="_self">  <base target="_parent">  -->

	<script>
		var langCode = "<%=langCode%>";
	</script>

    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/jquery-1.7.2.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/ui.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/jquery.alphanumeric.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/jshashtable.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/lump.NeosCodeUtil.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.form.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.MetaData.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.MultiFile.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.blockUI.js' />"></script>
    
    <!--  kendo ui 관련 js, css  -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.default.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.default.min.css' />" ></link>  
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css'/> "></link>
    
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
    
    <!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">    
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />">
    <!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />"></link>
    
    
    <script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
    <script type="text/javascript">
    
    // 로딩이미지
    $("#viewLoading").hide();
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
    </script>
</head>
<body  ondragstart="return false">
<div id="pop_loading" style="position:fixed; top:50%; left:50%;  margin-top:-5px; margin-left:-8px; /*visibility: visible;*/">
    <img src="<c:url value='/images/ajax-loader.gif' />" />
</div>
 <div id="viewLoading" style="position:absolute; top:0px; left:0px; z-index:9999; text-align:center; background:#ffffff; filter:alpha(opacity=60); opacity:alpha*0.6; display:none;">
     <iframe id="ifLoading" src="about:blank" frameborder="0" width="100%" height="100%" scrolling="no"></iframe>
     <div style="position:absolute; top:0px; left:0px; width:100%; height:100%; z-index:9999; text-align:center;">
         <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height:100%;">
             <tr><td style="height:100%;"><img src="<c:url value='/images/ajax-loader.gif' />"></td></tr>
         </table>
     </div>
 </div>
<div id="pop_contents" style="visibility:hidden;">
    <tiles:insertAttribute name="body" />
</div>
</body>
    <script type="text/javascript">
    /* tiles : lump_popup_tiles.jsp */
        _g_contextPath_ = "${pageContext.request.contextPath}";
        _g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
        _g_approvalImgMethodType ="<nptag:commoncode  codeid = 'APRIMG' code='IMGSIGNTYPE' />";
        _g_outFileLimitYN ="<nptag:commoncode  codeid = 'DOC003' code='OUT_FILELIMITYN' />";
    </script>
</html>