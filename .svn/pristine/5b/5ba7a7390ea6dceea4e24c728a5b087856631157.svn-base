<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<TITLE>dzBox</TITLE> 
<script src="../js/dzBox_files/svg.min.js" type="text/javascript"></script>
<script src="../js/dzBox_files/dzbox.js" type="text/javascript"></script>
<script src="../js/dzBox_files/dzdisplay.js" type="text/javascript"></script>


<script src="http://code.jquery.com/jquery-latest.js"></script>
<SCRIPT>

function fnInit(){
	$("#picFileId_New").val("");
	$("#txtaContent").val("");
	$("#drawing").html("");
	$("#resultTable").html("");	
}

function upload(){
	var fileValue = $("#picFileId_New").val().split("\\");	
	var filePath = "";
	
	if($("#picFileId_New").val() == ""){
		alert("파일을 선택해주세요");
		return false;
	}else{
	
	for(var i=0;i<fileValue.length-1;i++){
		filePath += fileValue[i] + "/";
	}	
	var fileName = fileValue[fileValue.length-1];

	var tblParam = {};
	tblParam.filePath = filePath;
	tblParam.fileNm = fileName;
	
	
	if($("#picFileId_New").val() != ""){
			var formData = new FormData();
			var pic = $("#picFileId_New")[0];
			
			formData.append("file", pic.files[0]);
			formData.append("pathSeq", "0");	//이미지 폴더
			formData.append("relativePath", "/imgFormTest/"); // 상대 경로
			formData.append("empSeq", "");
			 
			$.ajax({
				url:'<c:url value="/cmm/file/profileUploadProc.do"/>',
                type: "post",
                dataType: "json",
                data: formData,
                async:false,
                // cache: false,
                processData: false,
                contentType: false,
                success: function(data) {
               		$("#picFileIdNew").val(data.fileId);
               		tblParam.fileId = $("#picFileIdNew").val();								
                },
                error: function (result) { 
		    			alert("실패");
		    			return false;
		    		}
            });
	}
	
	$.ajax({
     	type:"post",
 		url:'<c:url value="/formBox.do"/>',
 		datatype:"text",
 		data:tblParam,
 		async:false,
 		success: function (data) { 			
 			document.frmData["txtaContent"].value = data.convertData;
 			setTimeout("convert();", 500);
		},
		error: function (result) {
 			alert("error");
 		}
 	});
	}
}


function convert(){

	var jsonText = document.frmData["txtaContent"].value;
	
	dzDisplay.displayWidth = document.body.clientWidth;
	dzDisplay.containerBorderYN = false;

	dzDisplay.show(jsonText, null);
	
};
</SCRIPT>
 
<META name="GENERATOR" content="MSHTML 11.00.10570.1001"></HEAD> 
<BODY>
<DIV></DIV>
<DIV id="drawing"></DIV>
<DIV id="resultTable"></DIV>
<DIV></DIV>
<FORM name="frmData" onsubmit="return false;" action="" method="post">
<TEXTAREA name="txtaContent" cols="100" readonly="readonly" id="txtaContent" style="width: 100%;">
</TEXTAREA> 
</FORM>
<input type="file" id="picFileId_New" name="picFileIdNew" />
<input type="button" value="업로드" onclick="upload();"/>
<input type="hidden" id="picFileIdNew">
<!-- <input type="button" value="초기화" onclick="fnInit();"/> -->
</BODY></HTML>
