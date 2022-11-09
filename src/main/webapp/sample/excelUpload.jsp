<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
    
<!DOCTYPE html>
<html>

<head>
    <title></title>
    <link rel="stylesheet" href="../css/kendoui/kendo.common.min.css" />
    <link rel="stylesheet" href="../css/kendoui/kendo.default.min.css" />

    <script src="../js/kendoui/jquery.min.js"></script>
    <script src="../js/kendoui/kendo.all.min.js"></script>
</head> 

<body>

	<form id="form" name="form" method="post" action="/gw/api/poi/procExcelUpload2.do" enctype="multipart/form-data">
		Excel: <input id="excelUploadFile" name="excelUploadFile" type="file" />
		<input type="submit" value="엑셀 업로드" />
	</form>
	
	<form id="form2" name="form2" method="post">
		Excel: <input id="excelUploadFile" name="excelUploadFile" type="file" />
		<button type="button" onclick="req()" style="width:100px;height:20px">엑셀 업로드</button>
	</form>
	
	<script>
	
         $(document).ready(function() {
             
         });
 		
 		 function req() {
 			var formData = new FormData($('#form2')[0]);

     		$.ajax({
     			url: '/gw/api/poi/procExcelTemp.do',
     			processData: false,
     			contentType: false,
     			data: formData,
     			type: 'POST',
     			success:function(d){
     				alert(JSON.stringify(d.retData));
     			},			 
     			error : function(e){
     				alert("error");
     			}
     		});	   
 	     }
         
     </script>
	
     <style>
         #fieldlist {
             margin: 0;
             padding: 0;
         }

         #fieldlist li {
             list-style: none;
             padding-bottom: .7em;
             text-align: left;
         }

         #fieldlist label {
             display: block;
             padding-bottom: .3em;
             font-weight: bold;
             font-size: 12px;
             color: #444;
         }

         #fieldlist li.status {
             text-align: center;
         }

         #fieldlist li .k-widget:not(.k-tooltip),
         #fieldlist li .k-textbox {
             margin: 0 5px 5px 0;
         }
         
     </style>

</body>

</html>
