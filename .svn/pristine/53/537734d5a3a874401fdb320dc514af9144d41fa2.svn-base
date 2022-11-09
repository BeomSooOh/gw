<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ page import="neos.cmm.util.BizboxAProperties"%>

<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery-1.9.1.min.js' />"></script>
    
    <script>
    
    function insertKey(){
    	
    	if($("#addKeyStr").val() == ""){
    		alert("check input value!");
    		$("#addKeyStr").focus();
    		return;
    	}
 		
		var tblParam = {};
		tblParam.functionKey = $("#addKeyStr").val();
		
		$.ajax({
			type:"post",
		    url: '/gw/cmm/system/updateDBLicenseKey.do',
		    async: false,
		    dataType: 'json',
		    data: tblParam,
		    success: function(result) { 
		    	$("#resultMsg").html(result.result);
		    },
		    error: function(xhr) { 
		    	$("#resultMsg").html("발급키가 유효하지 않습니다.");
		    }
	   });	 		
    }   
    
    </script> 
</head>
<body>
	<h2>Key Registration(Customer)</h2>
	<form>
        <div id="example">
            	<ul id="fieldlist">
            		<li style="margin-top: 10px;"> 
            			Registration key : <input id="addKeyStr" style="width: 500px;"/>
            			<button id="selBtn2" type="button" onclick="insertKey()" >apply</button>
	                </li>
	               	<text id="resultMsg"></text>
            	</ul> 
        </div> 
        </form>        
</body>
</html>