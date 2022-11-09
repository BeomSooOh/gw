<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/calendar.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-ui-1.12.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/recalendar.css">
    

<style type="text/css">
	.ui-datepicker-trigger{
	    position: absolute;
	    z-index: 2;
	    top: 5px;
	    right: 5px;
	}
</style>

<script type="text/javascript">

    $(document).ready(function(){
    	
    	$("#from_date").datepicker({
    		dateFormat : "yy-mm-dd",
    		showOn: 'button',
    		buttonImage: "<c:url value='/Images/ico/btn_dal01.png'/>",
    		buttonText: "Show date",
    		buttonImageOnly: true // 버튼에 있는 이미지만 표시한다.
        });
    	
		$("#to_date").datepicker({
			dateFormat : "yy-mm-dd",
			showOn: 'button',
    		buttonImage: "<c:url value='/Images/ico/btn_dal01.png'/>",
    		buttonText: "Show date",
    		buttonImageOnly: true // 버튼에 있는 이미지만 표시한다.
        });
 
		/*
    	if($("#from_date").val()!=''){
    		$("#from_date").datepicker(datePickerOptions).datepicker();
    	}else{
    		$("#from_date").datepicker(datePickerOptions).datepicker('setDate', '0');
    	}
    	
    	if($("#to_date").val()!=''){
    		$("#to_date").datepicker(datePickerOptions).datepicker();
        }else{
        	$("#to_date").datepicker(datePickerOptions).datepicker('setDate', '+1d');
        }
       */
        
        $("#from_date").on("change", function(){
            var fromDate = $("#from_date").val();
            
            var dateFormat = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
            if(dateFormat.test(fromDate) == false){
                alert("<%=BizboxAMessage.getMessage("TX000012420","날짜 형식에 맞게 입력하여야 합니다")%>");
                $("#from_date").datepicker('setDate','0');
                return;
            }
            
        });
        
        $("#to_date").on("change", function(){
            var toDate = $("#to_date").val();
            
            var dateFormat = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
            if(dateFormat.test(toDate) == false){
                alert("<%=BizboxAMessage.getMessage("TX000012420","날짜 형식에 맞게 입력하여야 합니다")%>");
                $("#to_date").datepicker('setDate','0');
                return;
            }
        });

    });

    function ConvertStringToDate (dateString) {
        dateString = $.trim(dateString);
        var date = null;
        if (!dateString) {
            return new Date();
        }

        dateStringArr = dateString.split("-");
        if (dateStringArr.length < 3) {
            return new Date();
        }

        if (parseInt(dateStringArr[0], 10)
                && parseInt(dateStringArr[1], 10)
                && parseInt(dateStringArr[2], 10)) {
            date = new Date(parseInt(dateStringArr[0], 10), parseInt(
                    dateStringArr[1], 10) - 1, parseInt(dateStringArr[2],
                    10));
        } else {
            date = new Date();
        }
        return date;
    };

    function ConvertDateToString(date) {
        var newDate = new Date();
        var year = null;
        var month = null;
        var day = null;

        if (date) {

            year = date.getFullYear();
            month = date.getMonth();
            day = date.getDate();
        } else {
            year = newDate.getFullYear();
            month = newDate.getMonth();
            day = newDate.getDate();
        }

        month = month + 1;
        if (month < 10) {
            month = "0" + month;
        }
        if (day < 10) {
            day = "0" + day;
        }

        return year.toString() + "-" + month.toString() + "-"
                + day.toString();
    };
    
	function transNumber(arg){
        if(Number(arg) < 10){
            return '0'+arg;
        }else{
            return arg;
        }
    }
</script>


</head>

<body>

	<!-- Code Here  -->

</body>
</html>

