<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
<%@page import="main.web.BizboxAMessage"%>

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!DOCTYPE html>
<html>
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

    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js?ver=20201021' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="/gw/js/manual.js"></script>
	
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
    
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js?ver=20201021' />"></script>

    <style type="text/css">
        .a-common {
            cursor: default !important;
            text-decoration: none !important;
        }
    </style>
    
    <script>
    
	document.addEventListener('keydown', function(event) {
		  if (event.keyCode === 13) {
		    event.preventDefault();
		  };
	}, true);	    
    
    $(document).ready(function(){
    	$(".k-combobox .k-input").addClass('kendoComboBox');
		
		// redirect msg 처리
		<c:if test="${not empty msg}">
			alert('${msg}');
		</c:if>
    	
    });
    
        function init(){}
        
        _g_contextPath_ = "${pageContext.request.contextPath}";
        _g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
    </script>
</head>

<body>
<div class="sub_wrap">
	<div class="iframe_wrap">
			<div class="sub_title_wrap">
				<div class="location_info">
					 <ul id="menuHistory"></ul> 
				</div>
				<div class="btn_manual" onclick="onlineManualPop()"><%=BizboxAMessage.getMessage("TX000019709","도움말")%></div>
				<div class="title_div">
					<h4></h4>
				</div>  
			</div>
			
			<script>
				try {
					var topInfo = parent.getTopMenu();
					
					var hstHtml = '<li><a class="a-common" href="#n"><img src="'+_g_contextPath_+'/Images/ico/ico_home01.png" alt="홈">&nbsp;</a></li>';
					hstHtml += '<li><a class="a-common" href="#n">'+topInfo.name+'&nbsp;</a></li>';  
										 
					var leftList = parent.getLeftMenuList();
					 
					if (leftList != null && leftList.length > 0) {
						for(var i = leftList.length-1; i >= 0; i--) {
							if(i == 0){
								hstHtml += '<li class="on"><a class="a-common" href="#n">'+leftList[i].name+'&nbsp;</a></li>';
							} else {
								hstHtml += '<li><a class="a-common" href="#n">'+leftList[i].name+'&nbsp;</a></li>';
							}
						}
						
						$(".title_div").html('<h4>'+leftList[0].name+'&nbsp;</h4>');
					} else {
						$(".title_div").html('<h4>'+topInfo.name+'&nbsp;</h4>');
					}
					
					$("#menuHistory").html(hstHtml);
					
				} catch (exception) {
					console.log(exception);//오류 상황 대응 부재
				}
				
				// 도움말팝업
				function helpPop() {
					var url = "<c:url value='/cmm/systemx/orgChartAllEmpInfo.do'/>";
					openWindow2(url,  "pop", 1000, 710, 1, 1);
				}				
			</script>
		<tiles:insertAttribute name="body" />
	</div>
</div>
</body>
</html>