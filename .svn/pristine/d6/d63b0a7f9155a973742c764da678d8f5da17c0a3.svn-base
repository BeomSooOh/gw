<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript">
    /* tiles : contents_tiles.jsp */ 
    </script>

	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />

	<!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/layout.css' />">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/contents.css' />">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/mail.css' />">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css' />">  
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
	
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js' />"></script>

    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery-1.7.1.min.js'/>"></script>     
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
    
    <!-- 메인 js -->
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script>
	
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js' />"></script>

    
    <script>
    
    $(document).ready(function(){
    	

    });
    
    
        function init(){}
        
        _g_contextPath_ = "${pageContext.request.contextPath}";
        _g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
    </script>


</head>
메뉴 히스토리
<!-- <body> -->
	<!-- iframe wrap -->
	<div class="iframe_wrap"> 

		<!-- 컨텐츠타이틀영역 -->
<!-- 		<div class="sub_title_wrap"> -->
			<div class="location_info">
				 <ul id="menuHistory"></ul> 
			</div>
			<div class="title_div">
				<h4></h4>
			</div>  
			
			<button type="button" onclick="parent.forwardPage('/home/mypage_MyArt.do')"><%=BizboxAMessage.getMessage("TX000017910","페이지이동")%></button>
			<button type="button" onclick="parent.forwardPage('/neos/edoc/document/record/board/common/RecordInnerBoardCommonList.do')"><%=BizboxAMessage.getMessage("TX000000479","전자결재")%></button>
			
			<script>
				
					var top = parent.getTopMenu();
					
					var hstHtml = '<li><a href="#n"><img src="'+_g_contextPath_+'/Images/ico/ico_home01.png" alt="홈"></a></li>';
					hstHtml += '<li><a href="#n">'+top.name+'</a></li>';  
					 
					var leftList = parent.getLeftMenuList();
					 
					if (leftList != null && leftList.length > 0) {
						for(var i = leftList.length-1; i >= 0; i--) {
							hstHtml += '<li><a href="#n">'+leftList[i].name+'</a></li>';
						}
						
						$(".title_div").html('<h4>'+leftList[0].name+'</h4>');
					}
					
					$("#menuHistory").html(hstHtml);
					
				
			   
			</script>
			
			
<!-- 		</div> -->
		
	</div><!-- //iframe wrap -->

<!-- </body> -->
</html>