<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
<%@ page import="main.web.BizboxAMessage"%>
    
    
<script src="../js/kendoui/jquery.min.js"></script>    
    
<H1><%=BizboxAMessage.getMessage("TX000017903","공통업로더")%></H1>

<script>
function fnAdd(){
    var list = [];
    var data = {};
    data.fileId = $("#fileId").val();
    data.fileNm = $("#fileNm").val();
    data.fileSize = $("#fileSz").val();
    list.push(data);
    $("#uploaderView")[0].contentWindow.fnAttFileListBinding(list);	
}

function fnSave(){
	
	if($("#uploaderView")[0].contentWindow.fnAttFileUpload()){
		fnCallBack();
	}else{
		$("#uploaderView")[0].contentWindow.UploadCallback = "fnCallBack()";
	}
}

function fnCallBack(){
	alert("<%=BizboxAMessage.getMessage("TX000017904","저장이 완료됐습니다.")%>");
}

function fnGetInfo(){
	var info = $("#uploaderView")[0].contentWindow.fnAttFileList();
	alert("<%=BizboxAMessage.getMessage("TX000017905","임시저장경로")%> : " + info.tempPath + "\r\n<%=BizboxAMessage.getMessage("TX000017906","추가한파일")%> : " + info.attachfilelist + "\r\n<%=BizboxAMessage.getMessage("TX000017909","기존삭제파일")%> : " + info.deletefilelist);
}


</script>

<iframe id="uploaderView" style="width:100%;height:200px;" src="/gw/ajaxFileUploadProcView.do?uploadMode=U" ></iframe>

<%=BizboxAMessage.getMessage("TX000005244","파일명")%> : <input id="fileNm" type="text" value="test.txt" />
<%=BizboxAMessage.getMessage("TX000016212","사이즈")%> : <input id="fileSz" type="text" value="123456" />
fileId : <input id="fileId" type="text" value="1069" />
<input type="button" onclick="fnAdd();" value="<%=BizboxAMessage.getMessage("TX000017907","기존파일추가")%>" />
<input type="button" onclick="fnSave();" value="<%=BizboxAMessage.getMessage("TX000008511","문서저장")%>" />
<input type="button" onclick="fnGetInfo();" value="<%=BizboxAMessage.getMessage("TX000017908","첨부파일정보")%>" />