<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<style>
 html body{
   margin: 0;
 }
 </style>

<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>

<script>

var EditorLoadYN = "0";
var EditorContents = "";

var MinVersion = 0x05050111;
var vHwpCtrl;
var BasePath;
var HWP_UNIT = 283.465;



$(document).ready(function () {
	
    BasePath = _GetBasePath();
    vHwpCtrl = HwpControl.HwpCtrl;

    if (!_VerifyVersion())
        return;

    var vSet = vHwpCtrl.CreateSet("PageSetup");
    vSet.SetItem("TopMargin", 1000);
    vSet.SetItem("LeftMargin", 10);
    vSet.SetItem("RightMargin", 10);
    vSet.SetItem("ottomMargin", 10);
    vHwpCtrl.PageSetup = vSet;

    InitToolBarJS();
    
    $("#HwpCtrl").height(document.documentElement.clientHeight);
    
    EditorLoadYN = "1";
    
    if(parent.fnEditorLoadCallback != null){
    	parent.fnEditorLoadCallback();
    } 
});

function _VerifyVersion() {
    //설치 확인
    if(!vHwpCtrl.Version){
    	alert("한글이 설치되지 않았거나 지원하지 않는 브라우져입니다.");
    	return false;
    }
    
    //버젼 확인
    CurVersion = vHwpCtrl.Version;
    if (CurVersion < MinVersion) {
        alert("HwpCtrl의 버젼이 낮아서 정상적으로 동작하지 않을 수 있습니다.\n" +
    "최신 버젼으로 업데이트하기를 권장합니다.\n\n" +
    "현재 버젼:" + CurVersion + "\n" +
    "권장 버젼:" + MinVersion + " 이상"
    );
        return false;
    }
    return true;
}

function _GetBasePath() {
    //BasePath를 구한다.
    var loc = unescape(document.location.href);
    var lowercase = loc.toLowerCase(loc);
    if (lowercase.indexOf("http://") == 0) // Internet
    {
        return loc.substr(0, loc.lastIndexOf("/") + 1); //BasePath 생성
    }
    else // local
    {
        var path;
        path = loc.replace(/.{2,}:\/{2,}/, ""); // file:/// 를 지워버린다.
        return path.substr(0, path.lastIndexOf("/") + 1); //BasePath 생성
    }
}

function HwpCtrlPictureInsertDialog(){
	alert("HwpCtrlPictureInsertDialog");
}

function InitToolBarJS()    // 툴바 보여주기
{
    OnShowToolBarAll();

    //vHwpCtrl.ReplaceAction("FileNew", "HwpCtrlFileNew");
    //vHwpCtrl.ReplaceAction("FileSave", "HwpCtrlFileSave");
    //vHwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAs");
    //vHwpCtrl.ReplaceAction("FileOpen", "HwpCtrlFileOpen");
    
    vHwpCtrl.ReplaceAction("PictureInsertDialog", "HwpCtrlPictureInsertDialog");
    
    

    vHwpCtrl.ShowStatusBar(0);
    vHwpCtrl.AutoShowHideToolBar = true; //    해당 기능사용시 도구상자를 보여 줌.

}


function OnShowToolBarAll() {
    vHwpCtrl.SetToolBar(-1, "#0;1:TOOLBAR_MENU");         // 0
    vHwpCtrl.SetToolBar(-1, "#1;1:TOOLBAR_FORMAT");         // 2
    vHwpCtrl.SetToolBar(-1, "#1;1:TOOLBAR_STANDARD");     // 1
    
    //vHwpCtrl.SetToolBar(-1, "#3;1:TOOLBAR_DRAW");         // 3
    vHwpCtrl.SetToolBar(-1, "#1;1:TOOLBAR_TABLE");         // 4
    //vHwpCtrl.SetToolBar(-1, "#1;1:TOOLBAR_IMAGE");         // 5
    //vHwpCtrl.SetToolBar(-1, "#6;1:TOOLBAR_NUMBERBULLET"); // 5
    //vHwpCtrl.SetToolBar(-1, "#7;1:TOOLBAR_HEADER_FOOTER"); // 6
    //vHwpCtrl.SetToolBar(-1, "#8;1:TOOLBAR_MASTERPAGE");     // 7
    //vHwpCtrl.SetToolBar(-1, "#9;1:TOOLBAR_NOTE");         // 8
    //vHwpCtrl.SetToolBar(-1, "#10;1:TOOLBAR_COMMENT");     // 9
    //vHwpCtrl.SetToolBar(11, "#11;1:새 도구상자, FileNew, FileSave, FileSaveAs, FileOpen");

    vHwpCtrl.ShowToolBar(true);
}





function fnEditorHtmlLoad(Content) {
	EditorContents = Content;

	if (EditorLoadYN != "1") {
        setTimeout('vHwpCtrl.SetTextFile(EditorContents, "HTML", "");', 500);
        return;
    }
    else {
    	vHwpCtrl.SetTextFile(Content, "HTML", "");	
    }
}

function fnEditorContents() {
    return vHwpCtrl.GetTextFile("HTML", "");
}

function fnEditorImage(){
	
	var ImgList = new Array();
	
	/*
	DZE_UPLOAD_EVENT.getUploadedFileList(0).forEach(function(value){
    	var ImgInfo = {};
    	ImgInfo.webPath = value.url;
    	ImgInfo.fileName = value.filename;
    	ImgInfo.serverPath = value.url.replace(WebPath, ServerPath);
    	ImgList.push(ImgInfo);		
		});
*/
    return ImgList;
}

</script>



<form name="HwpControl">
	<OBJECT id="HwpCtrl" style="LEFT: 0px; TOP:100px" height="500px" width="100%" align=center classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052>
		<PARAM NAME="FILENAME" VALUE="">
	</OBJECT>
</form>

<div id="convertTempArea" >

</div>











