/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dze_env_config_suite.js - 에디터 환경설정
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 에디터가 설치된 웹경로
var g_dzEditorBasePath = "/dzeditor_v1.2.0.5/";

var dzeEnvConfig = {
	// 아마란스 api 사용
	bUseAmaranthApi: false,

	iFrameLayer: true,

	// 컬러스킨
	//"gray","red","brown","orange","yellow","green","bluegreen","light_blue","blue","violet","pink"
	skinColor: "blue",


	// 에디터 가로/세로 사이즈 설정은 dze_ui_config_XXX.js 파일에서 설정
	//
	// 가로크기 - 부모객체 100% 적용 - dzeUiConfig.bCustomEditorWidthPercentageYN : true 설정
	// 세로크기 - iframe 객체 높이로 적용 - dzeUiConfig.bCustomEditorHeightIFrameYN : true 설정
	// 가로크기, 세로크기 별도 지정 - nEditorWidth: 670, nEditorHeight: 600 설정


	// 에디터 기본 URL 설정
	strPath_Dir: g_dzEditorBasePath,
	strPath_Image: g_dzEditorBasePath + "image/",
	strPath_JS: g_dzEditorBasePath + "js/",
	strPath_JS_Script: g_dzEditorBasePath + "js/script/",
	strPath_JS_Release: g_dzEditorBasePath + "js/release/",
	strPath_JS_Libs: g_dzEditorBasePath + "js/libs/",
	strPath_CSS: g_dzEditorBasePath + "css/",

	// 디버깅 모드
	bDebugging: false,

	// 제품 도움말 URL
	strHelpPageURL: g_dzEditorBasePath + "pop_help.html",

	// 미리보기 Page URL
	strPreviewPageURL: g_dzEditorBasePath + "pop_preview_x.html",// 일반모드 미리보기(XHTML)

	//서버페이지 설정(JSP)
	strSaveAsPageURL: g_dzEditorBasePath + "server/server_save.jsp",						//파일-저장하기(SaveAs) Page URL
	strSavePasteImageURL: g_dzEditorBasePath + "server/server_save_paste_image.jsp",		//클립보드 붙여넣기
	strUploadImageURL: g_dzEditorBasePath + "server/server_upload_image.jsp",				//이미지 업로드
	//strOpenFilePageURL: g_dzEditorBasePath + "server/server_open.jsp",					//파일-불러오기 (사용안함, UBA-71834)
	strUploadExtFileURL: g_dzEditorBasePath + "server/server_upload_extfile.jsp",			//삽입-개체-파일
	strGetWebContentURL: g_dzEditorBasePath + "server/server_get_webcontent.jsp",			//URL 읽어오기
	strGetWebImgURL: ""/*g_dzEditorBasePath + "server/server_get_web_image.jsp"*/,			//URL Img Data - proxy (BC10-10871)

	setEditorPath: function(path) {
		this.strPath_Dir = path;
	},
	setEditorJsPath: function(path) {
		this.strPath_JS = path;
	},
	setEitorImagePath: function(path) {
		this.strPath_Image = path;
	},
	setEitorCssPath: function(path) {
		this.strPath_CSS = path;
	},
	setSkinColor: function(color) {
		this.skinColor = color;
	},


	//사용자 함수
	fnGetEditorHTMLCode: function(bEncode, nEditNumber) {
		return getEditorHTMLCode(bEncode, nEditNumber);
	},

	fnSetEditorHTMLCode: function(strHTMLCode, bEncode, nEditNumber) {
		return setEditorHTMLCode(strHTMLCode, bEncode, nEditNumber);
	},
	
	fnInsertHTMLContent: function(strHTMLContent, nEditNumber) {
		return insertHTMLContent(strHTMLContent, nEditNumber);
	},

	fnGetEditorHTMLCodeFromId: function(bEncode, editorId) {
		return getEditorHTMLCodeFromId(bEncode, editorId);
	},

	fnSetEditorHTMLCodeFromId: function(strHTMLCode, bEncode, editorId) {
		return setEditorHTMLCodeFromId(strHTMLCode, bEncode, editorId);
	},
	fnGetEditorFonts: function() {
		return getEditorFontList();
	},

	fnSetEditorFonts: function(strFontName, nCode) {
		return setEditorFontList(strFontName, nCode);
	},

	// ----------------------------------------------------------------------------------------- //
	// fnAddHTMLContent 매개변수 설명
	// ----------------------------------------------------------------------------------------- //
	// 매개변수 - 1 : 전달하고자 하는 문자열(태그포함)
	// 매개변수 - 2 : 전달하고자 하는 객체(매개변수 3 이 0 인 경우만 해당)
	// 매개변수 - 3 : 삽입하고자 하는 위치( 0 - 최근에 선택된 영역, 1 - 상단, 2 - 하단 )
	// 매개변수 - 4 : 편집창 번호(에디터 1개만 사용하는 경우는 0, 멀티에디터는 해당 에디터 번호)
	// 매개변수 - 5 : register undo 여부
	//				여러개의 iframe방식 에디터 사용하는 경우는 별도 문의
	// ----------------------------------------------------------------------------------------- //
	fnAddHTMLContent: function(strHTMLContent, objAddElement, nPosType, nEditNumber, bRegisterUndoRedo) {
		return fnAddHTMLContent(strHTMLContent, objAddElement, nPosType, nEditNumber, bRegisterUndoRedo);
	},

	fnBindExternalData: function(nEditNumber, objExternalData, option) {
		return doBindExternalDataWithOption(nEditNumber, objExternalData, option);
	},

	fnGetBindExternalData: function(nEditNumber) {
	    var ret = getBindExternalData(nEditNumber);
		return ret;
	},

    fnGetEditorImageUrl: function(nEditNumber) {
		return getEditorImageUrl(nEditNumber);
	},

	//에디터 편집 여부 (BC10-11248)
	fnGetModified: function(nEditNumber) {
		return getModified(nEditNumber);
	}

};

document.write('<script type="text/javascript" src="' + dzeEnvConfig.strPath_JS + 'browser.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + dzeEnvConfig.strPath_JS_Libs + 'es6_promise.auto.min.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + dzeEnvConfig.strPath_JS_Release + 'dze_script.js"></scrip' +'t>');
