<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="../js/kendoui/jquery.min.js"></script>
    <script src="../js/kendoui/kendo.all.min.js"></script>
<script>
	$(document).ready(function() {
		var url = "pop.jsp";
	    var pop = window.open(url, "pop", "width=576,height=600,scrollbars=no");
			 		
	    pop.focus();   
	});
	
	function setId() {
		parent.setId($("#id").val());	
	}

</script>
</head>
<body>
	
	<h4>iframe 테스트</h4>
	<input type="text" id="id">
	<button type="button" onclick="setId()">ID 입력 테스트</button>
	
</body>
</html>