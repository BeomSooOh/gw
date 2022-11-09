<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
   
    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script>

    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script>

    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js' />"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.main.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.menu.js' />"></script>
    
    <!-- 메인 js -->
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script>

	
    
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		
		
		function applyPersonnelPdfInfo(){
			
			if($("#groupSeq").val() == ""){
				alert("그룹시퀀스 입력 필수!");
				return;
			}
			
			
			$.ajax({
	            type: "post",
	            url: "/attend/WebHr/applyPersonnelPdfInfo",
	            dataType : "json",
				data : JSON.stringify({ 
					groupSeq:$("groupSeq").val()
				}),
   				contentType: 'application/json; charset=utf-8',
	            success: function (data) {
	            	
	            	$("#total").html("총 : " + data.result.totalCnt);
	            	$("#complete").html("성공 : " + data.result.successCnt);
	            	$("#fail").html("실패 : " + data.result.failCnt);
	            }
	        });
		}		
		
	</script> 
	
	
     
</head>	 
    
<body> 
<div class="sub_contents_wrap" style="height:100%">	
	<div class="sub_contents_border" style="height:100%">	
		groupSeq : <input id="groupSeq" value="" type="text" style="width: 100px;">
		<input type="button" value="upload" onclick="applyPersonnelPdfInfo();"/></br>
		<p id="total">총 : 0</p>
		<p id="complete">성공 : 0</p>
		<p id="fail">실패 : 0</p>		 
	</div>
</div>
    
</body>

</html>
