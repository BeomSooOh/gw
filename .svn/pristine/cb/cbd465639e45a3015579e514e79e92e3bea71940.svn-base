<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="<c:url value='/js/dext5editor/js/dext5editor.js' />" type="text/javascript" /></script>

<style>
 html body{
   margin: 0;
 }
 </style>

<script language="javascript">

var editor1;
fnEditorInit();
var EditorLoadYN = "0";
var EditorContents = "";
var WebPath = "";
var ServerPath = "";

window.onload = function() {
	//dext_editor_loaded_event 자동호출 못한경우 수동으로 호출
	setTimeout("dext_editor_loaded_event_force();", 500);
}

function dext_editor_loaded_event_force(){
	if(EditorLoadYN == "0"){
		dext_editor_loaded_event(null);	
	}
}

function dext_editor_loaded_event(DEXT5Editor) {
	DEXT5.addUserCssUrl(location.protocol + "//" + location.host + "/" + '${pageContext.request.contextPath}/css/layout.css', 'BizboxA');
	DEXT5.addUserCssUrl(location.protocol + "//" + location.host + "/" + '${pageContext.request.contextPath}/css/contents.css', 'BizboxA');
    DEXT5.addUserCssUrl(location.protocol + "//" + location.host + "/" + '${pageContext.request.contextPath}/css/common.css', 'BizboxA');
    DEXT5.addUserCssUrl(location.protocol + "//" + location.host + "/" + '${pageContext.request.contextPath}/css/ea_layout.css', 'BizboxA');
    var _css = "body { font-family:굴림 }";    //사용자 css로 변경후 다시 굴림으로 변경 
    DEXT5.setUserCssText(_css, "BizboxA");  //에디터 기본설정->common.css에서 폰트가 변경됨->다시 굴림으로 설정   Bizbox A common.css 에서 font가 설정되있어서 재설정해줘야함. common.css 수정??필요한지
    if(EditorLoadYN == "0" && parent.fnEditorLoadCallback != null){
    	parent.fnEditorLoadCallback();
    }
    
    EditorLoadYN = "1";
}

//fnEditorLoad, fnEditorSave 함수는 에디터들의 공통함수(즉 인터페이스 처럼)
function fnEditorInit() {
    
	WebPath = "/upload";
	ServerPath = "${params.absolPath}";	
	
    DEXT5.config.ToSavePathURL = WebPath + "|" + ServerPath;
    DEXT5.config.HandlerUrl = "<c:url value='/cmm/file/Dext5ImageUpload.do'/>";
    DEXT5.config.ServerDomain = "/";
    DEXT5.config.Width = "100%";
    DEXT5.config.AutoBodyFit = "1";
    
    //다국어 처리
	<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>
	switch("<%=langCode%>"){
	case "EN" : DEXT5.config.Lang = "en-us";break;
	case "JP" : DEXT5.config.Lang = "ja-jp";break;
	case "CN" : DEXT5.config.Lang = "zh-cn";break;
	default : DEXT5.config.Lang = "ko-kr";break;	
	}
	
	DEXT5.config.Height = (document.documentElement.clientHeight) + "px";
    DEXT5.config.DevelopLangage = "JSP";
    DEXT5.config.RunTimes = "html5";
    DEXT5.config.ToolBarGrouping = "1";

    // 에디터의 팝업창과 우클릭 메뉴를 부모창에 띄우기 위한 설정.
    // 에디터를 iframe 형태로 띄우는 경우 사이즈가 작아서 팝업창이나 우클릭 메뉴가 가려질 때 설정하면 유용합니다.
    DEXT5.config.DialogWindow = parent.window;
    DEXT5.config.EditorHolder = "divEditor";
    
    var op_font = "${params.op_font}";
    var op_size = "${params.op_size}";
    var op_line = "${params.op_line}";    
    
    DEXT5.config.DefaultFontFamily = op_font;
    DEXT5.config.DefaultFontSize = op_size;
    DEXT5.config.DefaultLineHeight = op_line + "%";

    console.log(op_font);
	console.log(op_size);
	console.log(op_line + "%");    

    editor1 = new Dext5editor("BizboxA");
}

function fnEditorHtmlLoad(Content) {
	EditorContents = Content;

	if (EditorLoadYN != "1") {
        setTimeout('fnEditorHtmlLoad(EditorContents)', 500);
        return;
    }
    else {
        DEXT5.setHtmlValueEx(Content, 'BizboxA');
    }
}

function fnInsertHtml(Content) {
	DEXT5.setInsertHTML(Content, 'BizboxA');
}

function fnEditorContents() {
    return DEXT5.getHtmlValueEx();
}

function fnEditorImage(){
	var pathInfo = DEXT5.config.ToSavePathURL.split('|');
	var ImgList = new Array();
	
	var EditorImgInfo = DEXT5.getImages("BizboxA").split('\u000c');
	
	for (var i = 0; i <= EditorImgInfo.length; i++) {
		if(EditorImgInfo[i] != null && EditorImgInfo[i] != "" && EditorImgInfo[i].indexOf("/editorImg/") > -1){
	    	var ImgInfo = {};
	    	ImgInfo.webPath = EditorImgInfo[i].split('\u000b')[0];
	    	ImgInfo.fileName = EditorImgInfo[i].split('\u000b')[1];
	    	ImgInfo.serverPath = ImgInfo.webPath.replace(pathInfo[0], pathInfo[1]);
	    	ImgList.push(ImgInfo);					
		}
	}	
    
    return ImgList;
}



</script>
</head>


<div id="divEditor"></div>

