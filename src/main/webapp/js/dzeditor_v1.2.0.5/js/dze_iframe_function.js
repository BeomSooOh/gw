
//iframe 방식으로 에디터를 삽입한경우 부모창에서 호출
function getEditorIframeWindow(dzeditor_no) {

	dzeditor_no = parseInt(dzeditor_no,10);
	var iframeElements = document.getElementsByTagName("iframe");
	var dzeFrame = null;
	for(var i = 0; i < iframeElements.length; i++) {
		if(iframeElements[i].getAttribute("dzeditor_no")) {
			if(parseInt(iframeElements[i].getAttribute("dzeditor_no"),10) == dzeditor_no) {
				dzeFrame = iframeElements[i];
				break;
			}
		}
	}
	if(dzeFrame == null) return null;

	var objWin = dzeFrame.contentWindow || dzeFrame.contentDocument;
	return objWin;
}

//에디터 내용 가져오기
function getEditorHTMLCodeIframe(dzeditor_no) {

	var objWin = getEditorIframeWindow(dzeditor_no);
	if(objWin == null) return "";
	return objWin.dzeEnvConfig.fnGetEditorHTMLCode(false, dzeditor_no);
}

//에디터에 내용 넣기
function setEditorHTMLCodeIframe(strHtml, dzeditor_no) {

	var objWin = getEditorIframeWindow(dzeditor_no);
	if(objWin == null) return "";
	return objWin.dzeEnvConfig.fnSetEditorHTMLCode(strHtml, false, dzeditor_no);
}

//에디터에 포커스 
function setFocusEditorIframe(dzeditor_no) {

	var objWin = getEditorIframeWindow(dzeditor_no);
	if(objWin == null) return;
	objWin.duzon_dialog.nEditNumber = dzeditor_no;
	objWin.duzon_dialog.setEditorSelection();
	objWin.duzon_dialog.setEditorFocus();

	objWin.editor_onselectionchange(dzeditor_no);
}

//업로드된 이미지 목록 가져오기
function getUploadedFileListIframe(dzeditor_no) {

	var objWin = getEditorIframeWindow(dzeditor_no);
	if(objWin == null) return "";

	return objWin.DZE_UPLOAD_EVENT.getUploadedFileList(dzeditor_no);
}
