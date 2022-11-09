<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="../js/kendoui/jquery.min.js"></script>
    <script src="../js/kendoui/kendo.all.min.js"></script>
    <script>
    	function setId() {
			opener.parent.mainMove("NOTICE", "url.do", "23");		
		} 
    
    </script>
</head>
<body>
	<h4>팝업 ID 입력</h4>
	<input type="text" id="id">
	<button type="button" onclick="setId()">ID 입력 테스트</button>
</body>
</html>