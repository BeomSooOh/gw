<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta name="viewport" content="width=device-width, user-scalable=no">

<title>dzBox</title>

<script src="/gw/js/dzBox_files/svg.min.js" type="text/javascript"></script>
<script src="/gw/js/dzBox_files/dzbox.js" type="text/javascript"></script>
<script src="/gw/js/dzBox_files/dzdisplay.js" type="text/javascript"></script>

<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	setTimeout("convert();", 500);
});

function convert(){	
	 	var jsonText = document.frmData["txtaContent"].value;		

		var adjustValue = 30;
//		dzDisplay.displayWidth = document.body.clientWidth;
//		dzDisplay.displayHeight = document.body.clientHeight;
		dzDisplay.displayWidth = document.documentElement.clientWidth - adjustValue;
		dzDisplay.displayHeight = document.documentElement.clientHeight - adjustValue - 50;// 공간 여백주기 위해 가감
		
//		dzDisplay.displayWidth = document.body.clientWidth;
		dzDisplay.containerBorderYN = false;

		dzDisplay.show(jsonText, null);
};

</script>
</head>

<body>
<div id="drawing"></div>
<center><div id="resultTable"></div></center>
<form name="frmData" onsubmit="return false;" action="" method="post">
<textarea name="txtaContent" readonly="readonly" id="txtaContent" style="width: 100%; display: none;">
${convertData}
</textarea> 
</form>
</body>
</html>
