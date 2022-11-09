<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>


<script src="http://code.jquery.com/jquery-latest.js"></script>



<script>
var fileIdList = [];	    //첨부파일 추가목록	
var delFileList = [];

function uploadtest(){
	$("#uploadTest")[0].contentWindow.UploadCallback = "callbackcel()";
	
	$("#uploadTest")[0].contentWindow.fnAttFileUpload();
}

function callbackcel(){
	var formData = new FormData();
    for (var x = 0; x < $("#uploadTest")[0].contentWindow.attachFile.length; x++) 
    {
        formData.append("file" + x, $("#uploadTest")[0].contentWindow.attachFile[x]);
    }
    
    formData.append("fileId", "5245");
    formData.append("dataType", "json");
    formData.append("groupSeq", "demo");
    formData.append("relativePath", ""); 
    formData.append("empSeq", "1"); 
    formData.append("pathSeq", "300");
    
	$.ajax({
	     url: "/gw/FileAttach.do",
	     type: "POST",
	     data: formData,
	     async: false,
	     cache: false,
	     contentType: false,
	     processData: false,
	     success:  function(data){
	    	//console.log("success");
	    	//console.log(data);
	    	 
	    	if(data.params.fileListMap != null && data.params.fileListMap.length > 0){
	    		for(var i=0;i<data.params.fileListMap.length;i++){
		    		var fileId = data.params.fileListMap[i].fileId;
		    		var fileSn = data.params.fileListMap[i].fileSn;		
		    		var originalFileName = data.params.fileListMap[i].orginFileName;
		    		var fileSize = data.params.fileListMap[i].fileSize;
		    		var fileExtsn = data.params.fileListMap[i].fileExt;
		    		var fullFileName = data.params.fileListMap[i].orginFileName+'.'+data.params.fileListMap[i].fileExt;
		    		
		    		
		    		//# 파일저장
		    		var fileId = data.params.fileListMap[i].fileId ;
		    		$("#fileId").val(fileId);
		    		
		    		/* 멀티파일 등록 객체 */
		    		var obj = new Object();
		    		obj.fnum = fileSn;					//rowCount	//num;
		    		obj.fileId = fileId;
		    		obj.fileSn = fileSn;
		    		obj.fileSize = fileSize;
		    		obj.originalFileName = originalFileName;	
		    		fileIdList.push(obj);	    		
	    		}
	    	}else{
	    		alert('파일등록 실패');
	    	}				    							 
	    	 
	    	alert(fileIdList);
	     	/* alert(data); if json obj. alert(JSON.stringify(data));*/
	     },
	     error : function(data){
	    	 	//console.log("error");
          	//console.log(data);
       }
});
}
</script>
<div>
<iframe id="uploadTest" src="/gw/ajaxFileUploadProcView.do?uploadMode=U&groupSeq=demo" width="600px" height="170px"></iframe>
<input type="button" onclick="javascript:uploadtest();">
</div>


