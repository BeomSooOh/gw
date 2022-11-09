<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page import="neos.cmm.util.BizboxAProperties"%>
<%String arrCustomFontOrder = BizboxAProperties.getCustomProperty("BizboxA.Cust.arrCustomFontOrder");%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<style>
 html, body{
   margin: 0;
   overflow: hidden;
 }
 </style>
 
 
<script>
var EditorLoadYN = "0";
var EditorContents = "";

var g_dzEditorBasePath = "${pageContext.request.contextPath}/js/dzeditor_v1.2.0.5/";
var g_dzServerBasePath = "${pageContext.request.contextPath}";
var WebPath = "${params.webPath}";
var ServerPath = "${params.absolPath}";
var lock_yn = "${params.lock_yn}";
var contentEditor = "${params.contentEditor}"
var op_font = "${params.op_font}";
var op_size = "${params.op_size}";
var op_line = "${params.op_line}";
var arrCustomFontName = "${arrCustomFontName}";
var formLineDraw = "${param.formLineDraw}";
var formType = "${param.formType}";

if(parent.document.getElementById("editorView") != null){
	parent.document.getElementById("editorView").setAttribute("frameborder", "0");
	parent.document.getElementById("editorView").setAttribute("scrolling", "no");
}

</script>
 
<script language="javascript" src="${pageContext.request.contextPath}/js/dzeditor_v1.2.0.5/js/dze_env_config_bizboxA_doc_box.js"></script>



<c:set var="module" value="${params.module}" />
<c:choose>
    <c:when test="${module == 'ea' || module == 'eap'}">
    	<!-- 전자결재 전용 UI -->
		<c:set var="contentEditor" value="${params.contentEditor}" />
		<c:choose>
		    <c:when test="${contentEditor == 'Y'}">
				<script language="javascript" src="${pageContext.request.contextPath}/js/dzeditor_v1.2.0.5/js/dze_ui_config_bizboxA_doc_box_manager.js"></script>
		    </c:when>
		    <c:when test="${contentEditor == 'N'}">
				<script language="javascript" src="${pageContext.request.contextPath}/js/dzeditor_v1.2.0.5/js/dze_ui_config_bizboxA_doc_box_form_manager.js"></script>
		    </c:when>		    
		    <c:otherwise>
		        <script language="javascript" src="${pageContext.request.contextPath}/js/dzeditor_v1.2.0.5/js/dze_ui_config_bizboxA_doc_box.js"></script>
		    </c:otherwise>
		</c:choose>    	
    </c:when>
    <c:otherwise>
    	<!-- 일반 UI -->
        <script language="javascript" src="${pageContext.request.contextPath}/js/dzeditor_v1.2.0.5/js/dze_ui_config_bizboxA_board.js"></script>
    </c:otherwise>
</c:choose>

<script>

	//폰트추가설정
	if(arrCustomFontName != ""){
		
		var arrCustomFontOrder = "<%=arrCustomFontOrder%>";
		
		dzeUiConfig.arrCustomFontName.shift();
		arrCustomFontName.split("|").forEach(
		    function(value) { 
		    	
		    	if(arrCustomFontOrder == "Y"){
		    		dzeUiConfig.arrCustomFontName.push(value);	
		    	}else{
		    		dzeUiConfig.arrCustomFontName.unshift(value);
		    	}
		    	 
		    }
		);
		dzeUiConfig.arrCustomFontName.unshift("");
	}	

	if(lock_yn == "1"){
		dzeUiConfig.nCustomFormEditMode = 2;	
	}
	
	dzeEnvConfig.strSaveAsPageURL = g_dzServerBasePath + "/cmm/file/DzEditorImageUpload.do?groupSeq=${params.groupSeq}&type=save_contents&tosavepathurl=" + WebPath + "$" + ServerPath;		//파일-저장하기(SaveAs) Page URL
	dzeEnvConfig.strSavePasteImageURL = g_dzServerBasePath + "/cmm/file/DzEditorImageUpload.do?groupSeq=${params.groupSeq}&type=paste_image&tosavepathurl=" + WebPath + "$" + ServerPath;	//클립보드 붙여넣기
	dzeEnvConfig.strUploadImageURL = g_dzServerBasePath + "/cmm/file/DzEditorImageUpload.do?groupSeq=${params.groupSeq}&type=form_upload_image&tosavepathurl=" + WebPath + "$" + ServerPath;//이미지 업로드
	dzeEnvConfig.strOpenFilePageURL = g_dzServerBasePath + "/cmm/file/DzEditorImageUpload.do?groupSeq=${params.groupSeq}&type=openfile";													//파일-불러오기
	dzeEnvConfig.strUploadExtFileURL = g_dzServerBasePath + "/cmm/file/DzEditorImageUpload.do?groupSeq=${params.groupSeq}&type=form_upload_extfile&tosavepathurl=" + g_dzServerBasePath;	//삽입-개체-파일
	dzeEnvConfig.iFrameLayer = true;
	
	if(contentEditor  == "N"){
		// 이 부분 resizing 허용으로 처리되어야 함
		//dzeUiConfig.bCustomTableResizingYN = false;

		// 표의 cell을 선택하는 경우 좌우 연관관계 있는 cell 의 컨텐츠가 선택되지 않도록 하는 옵션
		dzeUiConfig.bCellUnSelectForMouseMove = true;

		var strStyle = '';
		strStyle += '<style>';
		//strStyle += 'body {min-height:2000px;}';	//CSA10-1204, 양식코드 편집 시 테이블 리사이즈 오류 수정 (2022-05-12)

		//기안양식 에디터 style 설정
		//strStyle += 'td {text-align:center;}';// 기안영식 생성에서만 필요한 부분 - 기안양식 생성과 본문양식 생성 구분 필요
		//strStyle += '#divFormContents {height:auto !important;}';
		strStyle += '.pl5 {padding-left:0px !important;}';
		strStyle += '</style>';
		dzeUiConfig.strCustomAdditionalHeadContent = strStyle;
		//dzeUiConfig.nEditModeAreaWidth = (647 + 22 + 2);// 편집창 영역 자체 크기 + 세로 스크롤바 영역  + 좌우 여백 1px
	}else{
		dzeUiConfig.strCustomBodyFontFamily = op_font;
		dzeUiConfig.strCustomBodyFontSize = op_size;
		dzeUiConfig.strCustomBodyLineHeight = (parseInt(op_line) / 100).toString();
		dzeUiConfig.bCustomContentPTagStyleApply = true;
	}
	
	//양식HEAD 편집이고 결재라인이 통합통합/분리분리 일경우 에디터 사이즈 조정 불가
	if(formType == '10' && (formLineDraw == "20" || formLineDraw == "30")) {
		dzeUiConfig.bCustomTableResizingYN = false;
	}
	
	dzeUiConfig.strLoadingDoneFunction = "loadComplete";
	dzeUiConfig.bCustomEditorWidthPercentageYN = true;
	dzeUiConfig.bCustomEditorHeightIFrameYN = true;
	
	dzeUiConfig.bUseImageToTableMenu = true;
	dzeUiConfig.strImageToTableURL = "/gw/dzBoxImgConvertPop.do";
	
    //다국어 처리
	<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>
	switch("<%=langCode%>"){
		case "EN" : dzeUiConfig.strCustomLanguageSetAndLoad = "en"; break;
		case "JP" : dzeUiConfig.strCustomLanguageSetAndLoad = "ja"; break;
		case "CN" : dzeUiConfig.strCustomLanguageSetAndLoad = "zh-cn"; break;
		default : dzeUiConfig.strCustomLanguageSetAndLoad = "ko"; break;	
	}
		
</script>

<script language="javascript" src="${pageContext.request.contextPath}/js/dzeditor_v1.2.0.5/js/loadlayer.js"></script>

<script>

function fnEditorHtmlLoad(Content) {
	EditorContents = Content;

	if (EditorLoadYN != "1") {
        setTimeout('fnEditorHtmlLoad(EditorContents)', 500);
        return;
    }
    else {
    	dzeEnvConfig.fnSetEditorHTMLCode(Content, false, 0);	
    }
}

function fnInsertHtml(Content, bRegisterUndo) {	//bRegisterUndo: (true : register undo) //CSA10-1204, 2022-05-17
	fnAddHTMLContent(Content, null, 0, 0, bRegisterUndo);
}

function fnEditorContents() {
    return dzeEnvConfig.fnGetEditorHTMLCode(false,0);
}

function fnEditorImage(){
	var ImgList = new Array();
	
	DZE_UPLOAD_EVENT.getUploadedFileList(0).forEach(function(value){
		
		if(Array.isArray(value.filename)){
			for( var i = 0 ; i < value.filename.length; i ++){
		    	var ImgInfo = {};
		    	ImgInfo.webPath = WebPath + value.url[i].substring(value.url[i].indexOf(WebPath) + WebPath.length);
		    	ImgInfo.fileName = value.filename[i];
		    	ImgInfo.serverPath = ServerPath + value.url[i].substring(value.url[i].indexOf(WebPath) + WebPath.length);
		    	ImgList.push(ImgInfo);
			}				
		}else if(value.deleted == null || !value.deleted){
	    	var ImgInfo = {};
	    	ImgInfo.webPath = WebPath + value.url.substring(value.url.indexOf(WebPath) + WebPath.length);
	    	ImgInfo.fileName = value.filename;
	    	ImgInfo.serverPath = ServerPath + value.url.substring(value.url.indexOf(WebPath) + WebPath.length);
	    	ImgList.push(ImgInfo);			
		}
    	
	});

    return ImgList;
}

function fnTestChangeFormCode(dzeditor_no, type_no)
{
	parent.dzeditorChangeFormCode(dzeditor_no, type_no);
}

window.onload = function() {
	
	LATimeReset();
    EditorLoadYN = "1";
    
    if(parent.fnEditorLoadCallback != null){
    	parent.fnEditorLoadCallback();
    }

}

function loadComplete(dzeditor_no)
{
	try	{
		// 부모창에 해당 함수 구현이 있어야 함
		parent.dzLoadComplete(dzeditor_no);
	} catch(e) {
		console.log(e);//오류 상황 대응 부재
	}
}

function LATimeReset()
{
	localStorage.setItem("LATime", (+new Date()));	
	setTimeout(function() {LATimeReset();}, 60000);
}

</script>

</head>
	<body>
		<div dzeditor="true"></div>
	</body>
</html>