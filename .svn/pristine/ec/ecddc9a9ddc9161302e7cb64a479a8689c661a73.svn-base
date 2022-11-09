<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>

<style>
 html body{
   margin: 0;
 }
 </style>

<script language="javascript" src="${pageContext.request.contextPath}/js/dext5upload/js/dext5upload.js"></script>


<script type="text/javascript">

    var DEXT5UPLOAD_STATE = false;
    var DEXT5UPLOAD_COMPLITE = false;
    var DEXT5UPLOAD_ID = "";
    var attachFile = [];
    var Binding_Data;
    var tempPath = "";
    var UploadCallback = "";

    //임시폴더키 생성
    var rndstr = new RndStr();
    rndstr.setType('0'); //숫자
    rndstr.setStr(20);   //10자리
    tempPath = "${params.absolPath}/uploadTemp/" + rndstr.getStr();    

    function DEXT5UPLOAD_OnCreationComplete(uploadID) {
        DEXT5UPLOAD_STATE = true;
        DEXT5UPLOAD_ID = uploadID;
        
        if(parent.fnLoadCallback != null){
        	parent.fnLoadCallback();
        }        
    }

    function DEXT5UPLOAD_OnTransfer_Start(uploadID) {
        //시작
    }

    function DEXT5UPLOAD_UploadingCancel(uploadID, uploadedFileListObj) {
        //취소
    	DEXT5UPLOAD_COMPLITE = false;
    }

    function DEXT5UPLOAD_OnTransfer_Complete(uploadID) {
    	
    	DEXT5UPLOAD_COMPLITE = true;
    	
    	//콜백함수 호출
        if (UploadCallback != "") {
        	parent.eval(UploadCallback);
        }
    }
    
    function getFileNmList(){
    	var fileNmList = "";
    	var newFile;
    	var webFile;
    	var file_list = DEXT5UPLOAD.GetAllFileListForJson("dext5");	
    	
    	if(file_list != null){
    		newFile = file_list.newFile.originalName;  
    		webFile = file_list.webFile.originalName;
    	}
    	
    	if(newFile != null && newFile.length > 0){
    		for(var i=0;i<newFile.length;i++){
    			fileNmList += "|" + newFile[i];
    		}
    	}
    	if(webFile != null && webFile.length > 0){
    		for(var i=0;i<webFile.length;i++){
    			fileNmList += "|" + webFile[i];
    		}
    	}
    	
    	if(fileNmList.length > 0){
    		fileNmList = fileNmList.substring(1);
    	}
    	
    	return fileNmList;
    }
    
    
    function DEXT5UPLOAD_OnError(uploadID, code, message, uploadedFileListObj) {
        //오류
        DEXT5UPLOAD_COMPLITE = false;
        alert(message);
    }
    
    function getAttTotalSize(){  
    	return DEXT5UPLOAD.GetTotalFileSize("dext5")/1024/1024;
    }
    
    function DEXT5UPLOAD_AfterAddItem(uploadID, strFileName, nFileSize, nAddItemIndex) {
        DEXT5UPLOAD_COMPLITE = false;
    }    
    
	<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

    switch ("<%=langCode%>") {
        case "EN": DEXT5UPLOAD.config.Lang = "en-us"; break;
        case "JP": DEXT5UPLOAD.config.Lang = "ja-jp"; break;
        case "CN": DEXT5UPLOAD.config.Lang = "zh-cn"; break;
    }
    
	if(parent.document.getElementById("uploaderView") != null){
		
		parent.document.getElementById("uploaderView").style.borderWidth = "0";
    }
	
	DEXT5UPLOAD.config.Height = (document.documentElement.clientHeight - 4) + "px";
	DEXT5UPLOAD.config.HandlerUrl = "${pageContext.request.contextPath}/js/dext5upload/handler/dext5handler.jsp";
    DEXT5UPLOAD.config.ViewerHandlerUrl = "${pageContext.request.contextPath}/cmm/file/Dext5Uploader.do";
    DEXT5UPLOAD.config.DownloadHandlerUrl = "${pageContext.request.contextPath}/cmm/file/Dext5Uploader.do?activxYn=${activxYn}";
    DEXT5UPLOAD.config.DialogWindow = parent.window;
    DEXT5UPLOAD.rootPath = "${pageContext.request.contextPath}/js/dext5upload/";

    new Dext5Upload("dext5");
    
    function fnAttFileUpload() {
    	if(DEXT5UPLOAD.GetNewUploadListForJson("dext5") == null || DEXT5UPLOAD_COMPLITE){
    		return true;
    	}
    	
    	DEXT5UPLOAD.SetConfig("HandlerUrl", "${pageContext.request.contextPath}/js/dext5upload/handler/dext5handler.jsp?tempPath=" + tempPath, "dext5");
    	DEXT5UPLOAD.Transfer("dext5");
    	attachFile = [];
         for (var x = 0; x < DEXT5UPLOAD.GetNewUploadListForJson("dext5").originalName.length; x++) {
        	 var fileInfo = tempPath + "|" + DEXT5UPLOAD.GetNewUploadListForJson("dext5").originalName[x];
        	 attachFile.push(fileInfo);
         }    	
    	
    	return false;
    }
    
    function getUploadFileCnt(){
     	var file_list = DEXT5UPLOAD.GetTotalFileCount("dext5");
   	 	return file_list;    	 
    }
    
    function fnAttFileListBinding(fileList){
    	
    	if(fileList.length > 0){
            Binding_Data = fileList;

            if (DEXT5UPLOAD_STATE == true) {            	
            	for (var i = 0; i < fileList.length; i++) {
            		var fileSn = "";
                    if(fileList[i].fileSn != null && fileList[i].fileSn != "")
                    	fileSn = fileList[i].fileSn;
                    var fileId = fileSn + "|" + fileList[i].fileId;
            		DEXT5UPLOAD.AddUploadedFile(fileId, fileList[i].fileNm, fileList[i].fileThumUrl, fileList[i].fileSize, fileList[i].fileUrl, 'dext5');
           		}        	
            } else {
                window.setTimeout("fnAttFileListBinding(Binding_Data);", 500);
            }    		
    	}
    }
    
    function fnAttFileList() {

        var AttFile = "";
        var DelFile = "";
        var DelFileKey = "";
        var DelFileSn = "";

        var tblParam = {};
        var DelList = DEXT5UPLOAD.GetDeleteListForJson("dext5");
        var AttList = DEXT5UPLOAD.GetNewUploadListForJson("dext5");

        if (DelList != null) {
        	for (var i = 0; i < DelList.originalName.length; i++) {
        		var delFileId = DelList.uniqKey[i].split("|")[1];
        		var delFileSn = DelList.uniqKey[i].split("|")[0];
        		
        		DelFile += "|" + DelList.originalName[i];
        		DelFileKey += "|" + delFileId;
        		DelFileSn += "|" + delFileSn;
        	}
        	
            if(DelFile.length > 0){
            	DelFile = DelFile.substring(1);
            	DelFileKey = DelFileKey.substring(1);
            	DelFileSn = DelFileSn.substring(1);
            }
        }
        
        if (AttList != null) {
        	for (var i = 0; i < AttList.originalName.length; i++) {
        		AttFile += "|" + AttList.originalName[i];
        	}
        	
            if(AttList.length > 0){
            	AttList = AttList.substring(1);
            }        	
        }

        tblParam.tempfolder = tempPath;
        tblParam.attachfilelist = AttFile;
        tblParam.attachpathlist = AttFile;
        tblParam.deletefilelist = DelFile;
        tblParam.deletekeylist = DelFileKey;
        tblParam.deletesnlist = DelFileSn;

        return tblParam;
    }
    
    function RndStr() {
        this.str = '';
        this.pattern = /^[a-zA-Z0-9]+$/;

        this.setStr = function (n) {
            if (!/^[0-9]+$/.test(n)) n = 0x10;
            this.str = '';
            for (var i = 0; i < n - 1; i++) {
                this.rndchar();
            }
        }

        this.setType = function (s) {
            switch (s) {
                case '1': this.pattern = /^[0-9]+$/; break;
                case 'A': this.pattern = /^[A-Z]+$/; break;
                case 'a': this.pattern = /^[a-z]+$/; break;
                case 'A1': this.pattern = /^[A-Z0-9]+$/; break;
                case 'a1': this.pattern = /^[a-z0-9]+$/; break;
                default: this.pattern = /^[a-zA-Z0-9]+$/;
            }
        }

        this.getStr = function () {
            return this.str;
        }

        this.rndchar = function () {
            var rnd = Math.round(Math.random() * 1000);

            if (!this.pattern.test(String.fromCharCode(rnd))) {
                this.rndchar();
            } else {
                this.str += String.fromCharCode(rnd);
            }
        }
    }
</script>
       
<div id="dext5"></div>






