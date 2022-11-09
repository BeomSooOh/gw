/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dze_ui_config.js - 에디터 UI 설정
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


var dzeUiConfig = {


	// 메뉴바 show 또는 hidden 만 지원(메뉴레이어)
	bCustomize_MenuBar_Display: true,

	// 첫번째 툴바 show 또는 hidden 설정(세부 항목은 따로 설정)
	bCustomize_ToolBar1_Display: true,

	// 두번째 툴바 show 또는 hidden 설정(세부 항목은 따로 설정)
	bCustomize_ToolBar2_Display: true,

	// 세번째 툴바 show 또는 hidden 설정(세부 항목은 따로 설정)
	bCustomize_ToolBar3_Display: false,

	// Bottom Tab바 show 또는 hidden 만 지원(미리보기,편집창,소스창 버튼)
	bCustomize_TabBar_Display: true,

	//에디터 하단 리사이징바 설정하기
	bCustomBottomResizeYN: false,	// true - 적용함, false - 적용안함

	//하단 리사이징 버튼 적용 여부
	bCustomBottomResizeBtnYN: false,	// true - 적용함, false - 적용안함

	// 테이블 셀 편집제한 기능
	bUseLockEditCellFunction: true,

	//false: body에 직접 붙여넣기
	//true: temp div에 붙여넣고 body로 옮김 (UBA-20165)
	bUsePasteCapture: true,

	//multi image insert 사용 (UBA-18676)
	bUseMultiImageInsert: true,
	
	// file upload
	bUseServerUpload: true,
	
	// 전자계약 양식
	bUseContractForm: false,
	
	// data binding
	bUseDataBind: false,
	bUseDataBindTwoWay: false,    //양방향 데이터 바인딩 (UCDOC-1719)

	//조합중 마우스 클릭시 조합 안풀리고 글자 띄는 문제 임시 수정 (2019-07-04, UBA-43427)
	bTempChromeIme : true,

	//문단번호 수준 증/감 순서 세팅
	applyOListStyleDepthItems: ["decimal","decimal-leading-zero","upper-alpha","lower-alpha","upper-roman","lower-roman"],
	//글머리기호 수준 증/감 순서 세팅
	applyUListStyleDepthItems: ["disc","circle","square"],

	//html 리턴 시, 모든 zero width space 글자 제거 (UCDOC-1461)
    bRemoveZeroWidthSpace: false,

	//붙여넣기: 텍스트만 붙여넣기 메뉴 기능
	bUsePasteOptionMenu: true,

	//다이얼로그 open default position (UCDOC-2361)
	strDefaultDialogPosition: "screen_center",	//screen_center: 화면 중앙, center: 에디터 중앙, relative: mouse 위치

	//다이얼로그 drag를 window 안에서만 허용 (UCDOC-2361)
	bAllowDialogDragInWindow: false,

	//글머리글기호 확장기호 사용(삽입되는 사이트에 관련 CSS 등록 필요)
	useExtUnorderedListStyleType: false,
	//글머리기호 자동매기기
	bAutoSetListStyleType: false,
	//글머리기호 수준 증/감 처리 작동여부
	bApplyListStyleDepth: true,
	//문단번호 수준 증/감 순서 세팅
	applyOListStyleDepthItems: ["decimal","decimal-leading-zero","upper-alpha","lower-alpha","upper-roman","lower-roman","decimal","decimal-leading-zero","upper-alpha","lower-alpha","upper-roman","lower-roman"],
	//글머리기호 수준 증/감 순서 세팅
	applyUListStyleDepthItems: ["disc","circle","square","disc","circle","square","disc","circle","square"],

	//북마크 기능 사용 하지 않음 (CSA10-1468)
	bDoNotUseBookmark: false,

	//--------------------------------------------------------------------------------------- 툴바 메뉴 설정
	arrCustomToolbar1: [],
	arrCustomToolbar2: [],
	arrCustomToolbar3: [],
	arrCustomAddToolbar1: [],
	arrCustomAddToolbar2: [],
	arrCustomAddToolbar3: [],
	arrDisableMenu: [],

	setCustomToolbars: function() {
	
		//툴바 메뉴 1줄
		this.arrCustomToolbar1 = [

			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_SAVEAS, 0],
			[ID_CUSTOM_PRINT, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 1],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_UNDO, 0],
			[ID_CUSTOM_REDO, 0],
			[ID_CUSTOM_CUT, 0],
			[ID_CUSTOM_COPY, 0],
			[ID_CUSTOM_PASTE, 0],
			[ID_CUSTOM_EDIT_PASTESPECIAL, 0],
			[ID_CUSTOM_DELETE, 0],
			[ID_CUSTOM_SELECT_ALL, 0],
			[ID_CUSTOM_EDIT_SEARCH, 0],
			[ID_CUSTOM_EDIT_REPLACE, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8], 
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_INSERT_IMAGE, 0],
			[ID_CUSTOM_INSERT_OBJECT_MOVIE, 0],
			[ID_CUSTOM_INSERT_OBJECT_FILE, 0],
			[ID_CUSTOM_INSERT_OBJECT_HR, 0],
			[ID_CUSTOM_INSERT_SPECIALCHARS, 0],
			[ID_CUSTOM_HYPERLINK_INSERT, 0],
			[ID_CUSTOM_INIT_CURSOR, 0],
			[ID_CUSTOM_INSERT_STAMP, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8], 
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_INSERT_PARAGRAPH_STARTPOINT, 0],
			[ID_CUSTOM_INSERT_PARAGRAPH_ENDPOINT, 0],
//                        [ID_CUSTOM_SELECT_PARAGRAPH, 0],    // [lsg] Drop&down

			[ID_CUSTOM_TOOLBAR_SPACE, 8], 
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			
			[ID_CUSTOM_IMAGE_TO_TABLE,0], 

			[ID_CUSTOM_TOOLBAR_SPACE, 8], 
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0], 
			[ID_CUSTOM_TOOLBAR_SPACE, 8],


			[ID_CUSTOM_TABLE_CREATE, 0],
			[ID_CUSTOM_DRAW_TABLE, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8], 
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_TABLE_ADD_ROW, 0],
			[ID_CUSTOM_TABLE_ADD_ROW_DOWN, 0],
			[ID_CUSTOM_TABLE_DELETE_ROW, 0],
			[ID_CUSTOM_TABLE_ADD_COL, 0],
			[ID_CUSTOM_TABLE_ADD_COL_RIGHT, 0],
			[ID_CUSTOM_TABLE_DELETE_COL, 0],

			[ID_CUSTOM_TABLE_MERGE_CELL, 0],
			[ID_CUSTOM_TABLE_SPLIT_CELL, 0],
			[ID_CUSTOM_TABLE_CELL_SAME_HEIGHT, 0],
			[ID_CUSTOM_TABLE_CELL_SAME_WIDTH, 0],
			[ID_CUSTOM_TABLE_CELL_ALIGN, 0],
			[ID_CUSTOM_TABLE_CELL_BACKCOLOR, 0],
			[ID_CUSTOM_TABLE_CONVERT_TEXT, 0],
			[ID_CUSTOM_TABLE_NUMBER_FORMAT, 0]

		];

		//툴바 메뉴 2줄
		this.arrCustomToolbar2 = [

			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_HEADING_SIZE, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 4],
			[ID_CUSTOM_FONT_NAME, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 4],
			[ID_CUSTOM_FONT_SIZE, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 3],

			[ID_CUSTOM_STYLE_INCREASE_FONTSIZE, 0],
			[ID_CUSTOM_STYLE_DECREASE_FONTSIZE, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_LINE_HEIGHT, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 4],
			[ID_CUSTOM_LETTER_SPACING, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 4],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_BOLD, 0],
			[ID_CUSTOM_ITALIC, 0],
			[ID_CUSTOM_UNDERLINE, 0],
			[ID_CUSTOM_STRIKE, 0],
			[ID_CUSTOM_SUPERSCRIPT, 0],
			[ID_CUSTOM_SUBSCRIPT, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_FORE_COLOR, 0],
			[ID_CUSTOM_BACK_COLOR, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_JUSTIFY_LEFT, 0],
			[ID_CUSTOM_JUSTIFY_CENTER, 0],
			[ID_CUSTOM_JUSTIFY_RIGHT, 0],
			[ID_CUSTOM_JUSTIFY_JUSTIFY, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_OUTDENT, 0],
			[ID_CUSTOM_INDENT, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_INSERT_ORDERED_LIST, 0],
			[ID_CUSTOM_INSERT_UNORDERED_LIST, 0]
	//		[ID_CUSTOM_STYLE_INCREASEORDER, 0],
	//		[ID_CUSTOM_STYLE_DECREASEORDER, 0]

		];

		//툴바 메뉴 3줄
		this.arrCustomToolbar3 = [

			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_FORM_TABLE, 0],

			[ID_CUSTOM_TOOLBAR_SPACE, 8],
			[ID_CUSTOM_TOOLBAR_SEPARATOR, 0],
			[ID_CUSTOM_TOOLBAR_SPACE, 8],

			[ID_CUSTOM_FORM_TAG_SWITCH, 0],
			[ID_CUSTOM_FORM_TAG_CHECKBOX, 0],
			[ID_CUSTOM_FORM_TAG_SELECT, 0]

		];
		
		// 추가되는 버튼에 대한 처리
		this.setCustomAddToolbars();
		
		// 사용하지 않는 메뉴 제거 처리
		this.setDisableMenu();
		this.removeDisableMenu();
	},

	setCustomAddToolbars: function() {
		
		while(0 != this.arrCustomAddToolbar1.length) {
			
			this.arrCustomToolbar1.push( this.arrCustomAddToolbar1.splice(0, 1)[0] );
		}

		while(0 != this.arrCustomAddToolbar2.length) {
			this.arrCustomToolbar2.push( this.arrCustomAddToolbar2.splice(0, 1)[0] );
		}

		while(0 != this.arrCustomAddToolbar3.length) {
			this.arrCustomToolbar3.push( this.arrCustomAddToolbar3.splice(0, 1)[0] );
		}
	},
	
	setDisableMenu: function() {
		if (this.bUseServerUpload === false) {
			this.arrDisableMenu.push(ID_CUSTOM_INSERT_OBJECT_FILE);
		}
	},
	
	removeDisableMenu: function() {
		
		var nCommandId;
		var nArrayIndex = null;
		var arrToolbar;
		
		for (var index = 0; index < this.arrDisableMenu.length; index++) {
			nCommandId = this.arrDisableMenu[index];
			arrToolbar = this.arrCustomToolbar1;
			nArrayIndex = getArrayIndex(arrToolbar, nCommandId);
			
			if (nArrayIndex === null) {
				arrToolbar = this.arrCustomToolbar2;
				nArrayIndex = getArrayIndex(arrToolbar, nCommandId);
				
				if (nArrayIndex === null) {
					arrToolbar = this.arrCustomToolbar3;
					nArrayIndex = getArrayIndex(arrToolbar, nCommandId);
				}
			}
			if (nArrayIndex !== null) {
				arrToolbar.splice(nArrayIndex, 1);

				try
				{

					for(var i=0; i<arrToolbar.length-5; i++){

					var j = 0;
					if(arrToolbar[i][0] === ID_CUSTOM_TOOLBAR_SPACE &&
						arrToolbar[i+1][0] === ID_CUSTOM_TOOLBAR_SEPARATOR &&
						arrToolbar[i+2][0] === ID_CUSTOM_TOOLBAR_SPACE){

							j = i+3;

							if(arrToolbar[j][0] === ID_CUSTOM_TOOLBAR_SPACE &&
								arrToolbar[j+1][0] === ID_CUSTOM_TOOLBAR_SEPARATOR &&
								arrToolbar[j+2][0] === ID_CUSTOM_TOOLBAR_SPACE){
									arrToolbar.splice(j, 3);
							}
						}
					}

			    }
			    catch(e) {}
			}
		}

		function getArrayIndex(arrToolbar, nCommandId) {
			for (var index = 0; index < arrToolbar.length; index++) {
				if (nCommandId === arrToolbar[index][0]) {
         	        return index;			
				}
			}
			
			return null;
		}

	},

	//--------------------------------------------------------------------------------------- 컨텍스트 메뉴 설정
	arrContextMenu_General: [],
	arrContextMenu_OneCell: [],
	arrContextMenu_MultiCell: [],
	arrContextMenu_Control: [],	
	setCustomContextMenus: function() {

		//컨텍스트메뉴 - 일반
		this.arrContextMenu_General = [

			ID_CUSTOM_FILE_PROPERTY,		// 파일속성
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_CUT,					// 잘라내기
			ID_CUSTOM_COPY,					// 복사
			ID_CUSTOM_PASTE,				// 붙여넣기

			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자

			ID_CUSTOM_STYLE_FONT,			// 글자모양
			ID_CUSTOM_STYLE_PARAGRAPH,		// 문단모양
			ID_CUSTOM_STYLE_STYLE,			// 스타일
			ID_CUSTOM_STYLE_UNORDEREDLIST,	// 글머리표모양
			ID_CUSTOM_STYLE_ORDEREDLIST,	// 문단번호모양
			ID_CUSTOM_SET_LIST_START_NEW,        //번호 새로 매기기 (UCDOC-4000)
			ID_CUSTOM_SET_LIST_START_CONTINUE,   //번호 매기기 계속 (UCDOC-4000)

			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자

			ID_CUSTOM_INSERT_SPECIALCHARS,	// 문자표
			ID_CUSTOM_EXTERNAL_DATA_AREA,	// 데이터 바인딩
			ID_CUSTOM_HYPERLINK_INSERT,		// 하이퍼링크
			ID_CUSTOM_HYPERLINK_REMOVE,		// 하이퍼링크 제거
			ID_CUSTOM_INIT_CURSOR,			// 초기 커서 위치 설정
			ID_CUSTOM_INIT_CURSOR_REMOVE,	// 초기 커서 위치 제거
	
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			
			ID_CUSTOM_IMAGE_TO_TABLE
		];

		//컨텍스트 메뉴 - 단일 셀 선택
		this.arrContextMenu_OneCell = [

			ID_CUSTOM_CUT,					// 오려두기
			ID_CUSTOM_COPY,					// 복사하기
			ID_CUSTOM_PASTE,				// 붙이기
			ID_CUSTOM_PASTE_CELL,			// 복사한 셀 붙여넣기
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_STYLE_FONT,			// 글자모양
			ID_CUSTOM_STYLE_PARAGRAPH,		// 문단모양
			ID_CUSTOM_STYLE_UNORDEREDLIST,	// 글머리표모양
			ID_CUSTOM_STYLE_ORDEREDLIST,	// 문단번호모양
			ID_CUSTOM_SET_LIST_START_NEW,        //번호 새로 매기기 (UCDOC-4000)
			ID_CUSTOM_SET_LIST_START_CONTINUE,   //번호 매기기 계속 (UCDOC-4000)
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_JUSTIFY_TABLE,		// 맞춤 (표)
			ID_CUSTOM_OUTDENT,				// 내어쓰기
			ID_CUSTOM_INDENT,				// 들여쓰기
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_PROPERTY,		// 표속성
			ID_CUSTOM_TABLE_CELL_PROPERTY,	// 셀속성
			ID_CUSTOM_TABLE_CELL_STYLE,		// 셀테두리배경
			ID_CUSTOM_LOCK_EDIT_CELL,		// 셀 편집제한
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_CELL_INSERT,	// 셀 삽입
			ID_CUSTOM_TABLE_CELL_DELETE,	// 셀 삭제
			ID_CUSTOM_TABLE_SPLIT_CELL,		// 셀 나누기
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_CONVERT_TEXT,	//표 텍스트로 변환
			ID_CUSTOM_TABLE_FORMULA,		// 계산식
			ID_CUSTOM_TABLE_SELECT_FORMULA, // 선택계산식
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_INSERT_SPECIALCHARS,	// 문자표
			ID_CUSTOM_EXTERNAL_DATA_AREA,	// 데이터 바인딩
			ID_CUSTOM_HYPERLINK_INSERT,		// 하이퍼링크
			ID_CUSTOM_HYPERLINK_REMOVE,		// 하이퍼링크 제거
			ID_CUSTOM_INIT_CURSOR			// 초기 커서 위치

		];

		//컨텍스트 메뉴 - 복수 셀 선택
		this.arrContextMenu_MultiCell = [

			ID_CUSTOM_CUT,					// 오려두기
			ID_CUSTOM_COPY,					// 복사하기
			//ID_CUSTOM_PASTE,				// 붙이기
			ID_CUSTOM_PASTE_CELL,			// 복사한 셀 붙여넣기
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_STYLE_FONT,			// 글자모양
			ID_CUSTOM_STYLE_PARAGRAPH,		// 문단모양
			ID_CUSTOM_STYLE_UNORDEREDLIST,	// 글머리표모양
			ID_CUSTOM_STYLE_ORDEREDLIST,	// 문단번호모양
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_JUSTIFY_TABLE,		// 맞춤 (표)
			ID_CUSTOM_OUTDENT,				// 내어쓰기
			ID_CUSTOM_INDENT,				// 들여쓰기
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_PROPERTY,		// 표속성
			ID_CUSTOM_TABLE_CELL_PROPERTY,	// 셀속성
			ID_CUSTOM_TABLE_CELL_STYLE,		// 셀테두리배경
			ID_CUSTOM_LOCK_EDIT_CELL,		// 셀 편집제한
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_CELL_INSERT,	// 셀 삽입
			ID_CUSTOM_TABLE_CELL_DELETE,	// 셀 삭제
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_MERGE_CELL,		// 셀 합치기
			ID_CUSTOM_TABLE_SPLIT_CELL,		// 셀 나누기			
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_CELL_SAME_HEIGHT,	// 행 높이를 같게 (UAC-3653)
			ID_CUSTOM_TABLE_CELL_SAME_WIDTH,	// 열 너비를 같게 (UAC-3653)
			ID_CUSTOM_MENU_SEPARATOR,		// ---------------- 메뉴 구분자
			ID_CUSTOM_TABLE_FORMULA			// 계산식

		];

		//컨텍스트 메뉴 - 컨트롤 선택(이미지 등)
		this.arrContextMenu_Control = [
			ID_CUSTOM_CUT,					// 오려두기
			ID_CUSTOM_COPY,					// 복사하기
			ID_CUSTOM_PASTE				// 붙이기
		];

		//컨텍스트 메뉴 - 컨트롤 선택 (데이터 바인딩 input)
		this.arrContextMenu_ControlExternalData = [
			ID_CUSTOM_MODIFY_EXTERNAL_DATA_AREA	// 데이터 바인딩 수정
		];
		
	},




	//--------------------------------------------------------------------------------------- 메뉴 바 설정
	arrCustomMenuBar: [

		//1. 파일
		[
			true,		// 새 문서
			true,		// 불러오기
			true,		// --------------------- 구분자
			false,		// 서식양식
			true,		// 레이아웃
			true,		// --------------------- 구분자
			true,		// 저장하기
			true,		// --------------------- 구분자
			true		// 인쇄
		],
		
		//2. 편집
		[
			true,		// 되돌리기
			true,		// 다시하기
			true,		// --------------------- 구분자
			true,		// 오려두기
			true,		// 복사하기
			true,		// 붙이기
			true,		// 골라붙이기
			true,		// 지우기
			true,		// --------------------- 구분자
			true,		// 전체선택
			true,		// --------------------- 구분자
			true,		// 찾기
			true,		// 바꾸기
			true		// 대/소문자 바꾸기
		],

		//3. 보기
		[
			true,		// 편집 보기
			true,		// HTML 보기
			true		// 미리 보기
		],

		//4. 삽입
		[
			true,		// 그림
			true,		// 개체
			true,		// --------------------- 구분자
			true,		// 문자표
			true,		// --------------------- 구분자
			true,		// 책갈피
			true,		// 하이퍼링크
			true,		// 초기 커서 위치 설정
			true		// 문단

		],

		//5. 서식
		[
			true,		// 글자모양
			true,		// 문단모양
			true,		// --------------------- 구분자
			true,		// 스타일
			true,		// --------------------- 구분자
			true,		// 글 머리표 모양
			true,		// 문단 번호 모양
			false,		// --------------------- 구분자
			false,		// 한수준 증가
			false		// 한수준 감소
		],
			
		//6. 표
		[
			true,		// 표 만들기
			true,		// --------------------- 구분자
			true,		// 표 속성
			true,		// 셀 속성
			true,		// 셀 테두리/배경
			true,		// 셀 편집제한
			true,		// --------------------- 구분자
			true,		// 줄/칸 추가하기
			true,		// 줄 지우기
			true,		// 칸 지우기
			true,		// --------------------- 구분자
			true,		// 셀 합치기
			true,		// 셀 나누기
			true,		// --------------------- 구분자
			true,		// 셀 높이를 같게
			true,		// 셀 너비를 같게
			true,		// --------------------- 구분자
			true,		// 셀 정렬
			true,		// --------------------- 구분자
			true,		// 표 텍스트로 변환
			true,		// 계산식
			true		// 선택 계산식
		],

		//7. 도움말
		[
			true,		// 단축키 도움말
			false,		// 제품 도움말
			true,		// 양식추출 도움말
			true		// 제품 정보
		]

	],


	//--------------------------------------------------------------------------------------- 탭바 설정
	arrCustomTabBar: [
		true,		// 미리보기
		true,		// 편집보기
		true		// HTML보기
	],


	//--------------------------------------------------------------------------------------- XHTML 포맷으로 컨텐츠의 내용 설정하기
	bCustomContentXHTMLFormatYN: true,		//true - XHTML1.0 기준, false - HTML4.01 기준
	bCustomContentXHTMLTabSettingYN: true,	//true - Tab 적용함, false - Tab 적용안함


	//--------------------------------------------------------------------------------------- iFrame에서 이노디터 활성화시 Border 보정치
	nCustomIframeBorderSetting: 0,		// iframe으로 호출하는 경우 아니면 0으로 설정할 것



	//--------------------------------------------------------------------------------------- P 태그 상단,하단 여백 크기
	strCustomBodyFontFamily: "",// 돋움 - 별도 설정없으면 css 정의된 폰트명 적용됨
	strCustomBodyFontSize: "",	// 9pt - 별도 설정없으면 css 정의된 폰트크기 적용됨
	strCustomBodyFontColor: "",	// 별도 설정없으면 css 정의된 폰트색상 적용됨 (기본색상 : 검정)
	strCustomBodyLineHeight: "1.2",
	strCustomBodyLetterSpacing: "",
	strCustomPTagMarginTop: "0px",
	strCustomPTagMarginBottom: "0px",
	//--------------------------------------------------------------------------------------- 작성된 컨텐츠의 내용을 얻어올 때 P 태그의 style(margin-top, margin-bottom)을 무조건 설정하기 - Start
	// -- P 태그와 BLOCKQUOTE 태그(들여쓰기) 2가지 태그에 동시 적용됨
	// -----------------------------------------------------------------------------------------------------------------
	// -- P 태그 상단,하단 여백 크기 설정은 고객사에서 strCustomPTagMarginTop, strCustomPTagMarginBottom 반영됨
	//    font-family : strCustomBodyFontFamily 값, font-size : strCustomBodyFontSize 값, 
	// -----------------------------------------------------------------------------------------------------------------
	// -- 결과 컨텐츠 : <p style="line-height:1;font-family:굴림;font-size:10pt;margin-top:0px;margin-bottom:0px;">...</p> 형태로 처리됨
	//
	bCustomContentPTagStyleApply: false,	// true - 적용함, false - 적용안함



	//--------------------------------------------------------------------------------------- 편집창의 가로 Scroll 사용여부
	bCustomEnableEditHorizontalScroll: true,		// true - 사용, false - 사용안함


	//--------------------------------------------------------------------------------------- 미리보기창의 가로 크기, 세로 크기 설정
	nCustomPreviewWindowWidth: 700,		// 기본가로크기 - 700(숫자만 가능)
	nCustomPreviewWindowHeight: 650,		// 기본세로크기 - 650(숫자만 가능)


	//--------------------------------------------------------------------------------------- 폰트명 설정 - (내용이 없는경우 Default 값으로 적용)
	// -- 영문 폰트명은 소문자로 설정할 것
	//
	arrCustomFontName: [
		"",		// ----- 공백으로 전달하는 경우 없음(글꼴 제거)으로 설정됨. 표시문구는 "기본".
		"굴림",
		"굴림체",
		"궁서",
		"궁서체",
		"돋움",
		"돋움체",
		"맑은 고딕",
		"바탕",
		"바탕체",
		"arial",
		"tahoma",
		"times new roman",
		"verdana"
	],
	
	//-------------------------------------------------------------------------------------  폰트 사이즈 설정 - (내용이 없는경우 Default 값으로 적용)
	arrCustomFontSize: [
		'', '8pt', '9pt', '10pt', '11pt', '12pt', '13pt', '14pt', '15pt','16pt','17pt', '18pt','19pt','20pt','22pt', '24pt', '26pt','30pt', '36pt'
	],

	//-------------------------------------------------------------------------------------  줄간격 설정 - (내용이 없는경우 Default 값으로 적용)
	arrCustomLineHeight: [
		'', '1', '1.2', '1.5','1.8', '2', '2.5', '3'
	],

	//-------------------------------------------------------------------------------------  글자간격 설정 - (내용이 없는경우 Default 값으로 적용)
	arrCustomLetterSpacing: [
		'', '1pt', '2pt', '4pt', '6pt', '8pt', '10pt'
	],

	//--------------------------------------------------------------------------------------- 다국어 지원 언어 설정 - (공백 : 시스템 언어로 자동 로딩)
	//ex) 한국어 OS -> 한국어 로딩, 영어 OS -> 영어 로딩
	strCustomLanguageSetAndLoad: "",		// 한국어 - ko, 영어 - en


	//--------------------------------------------------------------------------------------- 미리보기 사용자 정의 함수 호출 - (공백 : Default 미리보기 적용)
	strCustomPreviewCallFunction: "",


	//--------------------------------------------------------------------------------------- FireFox에서 이노디터 활성화시 Layer 보정치 - Start(FireFox에서 메뉴,색상창 등이 밀리는 현상이 발생할 경우만 해당))
	nCustomFireFoxLayerSetting_X: 0,
	nCustomFireFoxLayerSetting_Y: 0,

	
	//--------------------------------------------------------------------------------------- 편집창에 추가적인 CSS 적용 설정 
	arrCustomAdditionalEditAreaCSS: [
		/*
		"http://gwa.duzon.com/eap/css/kendoui/kendo.common.min.css",
		"http://gwa.duzon.com/eap/css/kendoui/kendo.default.min.css",
		"http://gwa.duzon.com/eap/css/kendoui/kendo.dataviz.min.css",
		"http://gwa.duzon.com/eap/css/kendoui/kendo.dataviz.default.min.css",
		"http://gwa.duzon.com/eap/css/kendoui/kendo.silver.min.css",
		"http://gwa.duzon.com/eap/css/common.css",
		"http://gwa.duzon.com/eap/css/reKendo.css"
		*/
	],

	//편집창을 호출하는 부모 페이지의 CSS 전체 자동 include 
	// -- 설정에 따른 편집창 스타일  	true	: css > editor_style_inherit.css
	//									false	: css > editor_style.css
	// -----------------------------------------------------------------------------------------------------------------
	bCustomAutoIncludeParentCSS: true,	// 기본값 : false


	//--------------------------------------------------------------------------------------- 편집창 head 부분에 추가적인 내용 적용 설정
	strCustomAdditionalHeadContent: "",


	//--------------------------------------------------------------------------------------- 페이지 로딩시 Focus 설정 여부
	bCustomEditFocusYN: true,	//true - 설정함, false - 설정안함


	//--------------------------------------------------------------------------------------- 소스창에서 스크립트 허용 여부
	bCustomSourceAreaScriptAllowYN: false,	// true - 허용함, false - 허용안함


	//--------------------------------------------------------------------------------------- 소스창에서 iframe 허용 여부
	bCustomSourceAreaIframeAllowYN: true,	// true - 허용함, false - 허용안함


	//--------------------------------------------------------------------------------------- 테이블 Operation 허용 설정 여부
	bCustomTableOperationYN: true,	// true - 허용함, false - 허용안함


	//--------------------------------------------------------------------------------------- 테이블 리사이징 허용 설정 여부
	bCustomTableResizingYN: true,	// true - 허용함, false - 허용안함


	//--------------------------------------------------------------------------------------- 테이블 상단 문단삽입용 라인 UI 허용 설정 여부
	bCustomTableEnterLineYN: false,	// true - 허용함, false - 허용안함


	//--------------------------------------------------------------------------------------- 테이블 셀(박스형 UI) 리사이징 허용 설정 여부
	bCustomTableCellResizingYN: false,	// true - 허용함, false - 허용안함


	//--------------------------------------------------------------------------------------- 편집 모드 설정 여부
	nCustomFormEditMode: 0,	// 0 - 일반모드, 1 - 양식 편집 모드(관리자), 2 - 양식 사용 모드(사용자)
	
	
	//--------------------------------------------------------------------------------------- 셀 편집제한 모드 설정 여부
	nCustomLockEditCellMode: false,	// true - 셀 편집제한 기능 제공(관리자), false - 셀 편집제한 기능 제공 안함(사용자)
	
	//--------------------------------------------------------------------------------------- 테이블 편집제한 모드 설정 여부
	nLockEditTableMode: false,		// true - 테이블 편집제한 기능 제공(관리자), false - 테이블 편집제한 기능 제공 안함(사용자)
	
	//--------------------------------------------------------------------------------------- 초기화면 편집창/소스창 설정
	bCustomEditSourceMode: true,	// true - 편집창 기본, false - 소스창


	//--------------------------------------------------------------------------------------- 작성된 컨텐츠의 내용을 얻어올 때 Anchor 태그의 target을 무조건 새창(_blank)로 설정하기 - Start
	bCustomAnchorTargetBlankYN: false,	// true - 적용함, false - 적용안함


	//--------------------------------------------------------------------------------------- 작성된 컨텐츠의 내용을 얻어올 때 P 태그를 BR 태그로 변경 설정하기
	//xhtml 포맷 설정인 경우만 해당(bCustomContentXHTMLFormatYN = true)
	bCustomConvertPTagToBrTag: false,	// true - 적용함, false - 적용안함


	//--------------------------------------------------------------------------------------- 작성된 컨텐츠의 내용을 얻어올 때 IMG 태그의 SRC 경로에서 도메인 제거 후 가져오기
	// -- xhtml 포맷 설정인 경우만 해당(bCustomContentXHTMLFormatYN = true)
	// -- ex) 이미지 소스의 경로가 http://www.innoditor.com/sample/image/sample_1.gif 인 경우
	// --     아래 배열 항목에 "http://www.innoditor.com" 으로 등록하면 실제 컨텐츠의 내용을 가져올 때
	// --	  "/sample/image/sample_1.gif" 의 값으로 이미지 소스경로를 전달함
	// -----------------------------------------------------------------------------------------------------------------
	// -- 아래의 설정된 값은 샘플로 작성된 값이며 실제로는 고객사 해당 도메인을 입력하여 설정
	// -- 대소문자 구분하지 않고 도메인을 설정하여도 해당 검사시에 고려하여 적용함
	// -----------------------------------------------------------------------------------------------------------------
	// -- 설정시 유의사항(문자열이 긴 순서대로 설정)
	// -- http://localhost, http:localhost:80, http://localhost:8080 을 설정한다고 가정하면
	// -- 배열의 순서는 http://localhost:8080, http:localhost:80, http://localhost 순서로 설정하여야 함
	arrCustomImgSrcRemoveDomain: [
		/*
		"http://www.duzon.com";
		"https://www.duzon.com";
		"http://duzon.com";
		"https://duzon.com";
		*/
	],
	//위 옵션에 현재 사이트의 도메인 자동 등록
	autoAddImgSrcRemoveDomain: true,


	//--------------------------------------------------------------------------------------- 작성된 컨텐츠의 내용을 얻어올 때 A(Anchor) 태그의 href 경로에서 도메인 제거 후 가져오기
	// -- xhtml 포맷 설정인 경우만 해당(bCustomContentXHTMLFormatYN = true)
	// -- IMG 태그의 SRC 경로 도메인 제거에 사용되는 배열값을 그대로 이용함
	bCustomAnchorHrefRemoveDomainYN: false,	// true - 도메인 제거함, false - 도메인 제거안함


	//--------------------------------------------------------------------------------------- Context Menu 사용여부 설정하기
	bCustomContextMenuUseYN: true,	// true - 적용함, false - 적용안함



	//--------------------------------------------------------------------------------------- Context Menu 항상 편집창 안에서만 표시되도록 설정하기
	//iframe 같은 독립 윈도우 영역등에서 Context Menu가 일부만 표시되는 현상 발생시에만 적용
	bCustomContextMenuDisplayInEditAreaYN: false,	// true - 적용함, false - 적용안함



	//--------------------------------------------------------------------------------------- 에디터 생성시에 가로크기를 에디터를 로딩할 부모객체의 100%로 설정하기
	bCustomEditorWidthPercentageYN: true,// true - 적용함, false - 적용안함, 기본값 - false
	//--------------------------------------------------------------------------------------- 에디터 생성시에 iframe 세로크기에 맞도록 에디터 높이 설정하기
	bCustomEditorHeightIFrameYN: true,// true - 적용함, false - 적용안함, 기본값 - false

	//--------------------------------------------------------------------------------------- 에디터 가로, 세로 크기 지정
	// -- bCustomEditorWidthPercentageYN 변수값이 true 로 선언된 경우는 nEditorWidth 값이 선언되어 있어도 해당 값은 무시됨
	// -- bCustomEditorHeightIFrameYN 변수값이 true 로 선언된 경우는 nEditorHeight 값이 선언되어 있어도 해당 값은 무시됨
	nEditorWidth: 670,
	nEditorHeight: 600,


	//--------------------------------------------------------------------------------------- 편집창/소스창 전환시에 추가적인 이벤트 처리를 위한 함수 호출 설정하기
	//호출하는 곳에서 해당 함수가 정의되어 있어야 함
	//ex) 설정하고자 하는 경우 strCustomTabModeEventFunction = "fnTestTabModeEventFunction";
	strCustomTabModeEventFunction: "",	// 기본 - 없음


	//--------------------------------------------------------------------------------------- 테이블 생성 또는 테이블 셀내용 삭제시 공백도 제거하기
	bCustomSetTableCellBlank: false,	// true - 적용함, false - 적용안함


	//--------------------------------------------------------------------------------------- 편집창의 focus/blur 이벤트 발생 후 추가적인 처리를 위한 함수 호출 설정하기
	// -- 에디터를 호출하는 곳에서 해당 함수가 정의되어 있어야 함
	// -- ex) 설정하고자 하는 경우 strCustomFocusEventFunction = "fnTestFocusEventFunction";
	strCustomFocusEventFunction: "",	// 기본 - 없음


	//--------------------------------------------------------------------------------------- 한글, 워드 보정 실행시에 P, SPAN 태그에 정의된 항목 중 제거하고자 하는 속성명 설정
	// -- ex) p class="바탕글", span lang="en-us"
	arrCustomAdjustRemoveAttributeName: [
		"class",
		"className",
		"lang"
	],


	//--------------------------------------------------------------------------------------- 한글, 워드 보정 실행시에 P, SPAN 태그에 정의된 항목 중 제거하고자 하는 스타일 설정
	// -- "mso-..." 항목으로 설정된 style은 보정 기능에서 자체적으로 제거함
	// -- ex) span style="text-justify: ...;"
	arrCustomAdjustRemoveStyleName: [
		"text-justify",
		"layout-grid-mode"
	],


	//--------------------------------------------------------------------------------------- 한글, 워드 보정 실행시에 TABLE, TD Border 값을 pt -> px 변경시 100분율 단위 변경률 설정
	// -- 권장 : 60 전후 값 사용, 20 이하의 값을 설정시 적용안됨
	nCustomAdjustFromPtToPxRatio: 60,	// 기본값 : 60


	//--------------------------------------------------------------------------------------- 한글, 워드 붙여넣기 시에 자동보정 실행여부 설정
	// -- 한글,워드 등의 문서에서 붙여넣기를 하신 경우
	// -- 기존 내용에 한글,워드 등의 일부 적합하지 않은 코드가 있는 경우
	//
	// -- 진행하시는 경우 기존 내용과 다소 상이하게 표현될 수 있음
	// -- 일부 처리 가능한 코드들에 대하여 진행
	// -- 문서 크기에 따라 다소 시간이 소요될 수 있음
	// -----------------------------------------------------------------------------------------------------------------
	bCustomAutoAdjustHwpWordYN: true,	// true - 적용함, false - 적용안함


	//--------------------------------------------------------------------------------------- fnGetEditorHTMLCode 함수 호출시 Garbage 문자열 제거 설정
	arrCustomRemoveGarbageText: [
		"<!--[if !vml]-->",
		"<!--[if \n!vml]-->",
		"&lt;!--[if !vml]--&gt;",
		"&lt;!--[if \n!vml]--&gt;",
		"<!--[if !supportEmptyParas]-->",
		"<!--[if \n!supportEmptyParas]-->",
		"&lt;!--[if !supportEmptyParas]--&gt;",
		"&lt;!--[if \n!supportEmptyParas]--&gt;",
		"<!--[if !supportLineBreakNewLine]-->",
		"<!--[if \n!supportLineBreakNewLine]-->",
		"&lt;!--[if !supportLineBreakNewLine]--&gt;",
		"&lt;!--[if \n!supportLineBreakNewLine]--&gt;",
		"<!--[if !supportLists]-->",
		"<!--[if \n!supportLists]-->",
		"&lt;!--[if !supportLists]--&gt;",
		"&lt;!--[if \n!supportLists]--&gt;",
		"<!--[endif]-->",
		"&lt;!--[endif]--&gt;",
		"­",
		"&shy;"
	],



	//--------------------------------------------------------------------------------------- img src 속성부분에 적합하지 않은 속성값 조사, 제거 설정
	// -- 이미지 확장자 .jpg .gif .png .bmp 경우만 허용
	// -- 위의 명시된 확장자가 아닌 경우 src 값 자동 제거 처리함
	//
	// -- arrCustomCheckImgSrcPropertyValue 배열에 조사하고자 하는 비적합한 src 값 설정
	// -- 배열에 등록된 문구를 포함하고 있는 경우 src 값 자동 제거 처리함
	// -----------------------------------------------------------------------------------------------------------------
	bCustomCheckImgSrcProperty: false,// 기본값 : true
	arrCustomCheckImgSrcPropertyValue: [
		".js"
	],


	//--------------------------------------------------------------------------------------- fnGetEditorHTMLCode 함수 호출시 태그 종료문자 '>' 처리 설정 - Start
	// -- fnGetEditorHTMLCode(true, 0) 함수 호출하는 경우
	// -- 첫번째 매개변수가 true 인 경우 < (&lt;) , & (&amp;)  두가지 문자에 대하여만 특수문자 변경처리함
	// -- 추가적으로 태그 종료문자 > (&gt;) 특수문자 처리하고자 하는 경우 옵션 설정값을 true로 설정
	// -----------------------------------------------------------------------------------------------------------------
	bCustomEncodeEndCharacterYN: false,	// 기본값 : false



	//--------------------------------------------------------------------------------------- 호출하는 페이지에서 document.domain 설정을 위해 호출하는 임시 페이지명 설정하기
	// -- IE 만 해당됨
	// -- 에디터 호출하는 페이지에서 document.domain 설정이 있는 경우 보안 엑세스 해제를 위해 임시 페이지를 호출함
	// -- 임시 페이지 명은 innoditor > domain.html 으로 기본 설정되었음
	// -- 임시 페이지 명의 경로는 innoditor 디렉로리에 있어야 함
	// 
	// -- document.domain 설정이 없는 경우는 설정하지 않아야 함
	// -----------------------------------------------------------------------------------------------------------------
	strCustomDomainPageName: "",	// 기본값은 없음("")


	//--------------------------------------------------------------------------------------- IE 호환성보기에서 에디터 높이가 설정된 높이로 표시되지 않는 경우 높이 명시적으로 설정하기
	bCustomEditorHeightReSettingYN: true,	// 기본값 : false


	//--------------------------------------------------------------------------------------- 들여쓰기, 내어쓰기 간격 크기 설정하기
	nCustomOutdentIndentWidth: 40,	// 기본값 : 7 , 숫자만 입력 가능


	//--------------------------------------------------------------------------------------- 크롬, 파이어폭스 BR 태그 P 태그로 자동 변경 설정하기
	// -- 해당 옵션을 수정하는 경우 크롬 등에서 문자열 조작 기능이 영향을 받으므로 특수한 상황에서만 수정
	// -----------------------------------------------------------------------------------------------------------------
	bCustomAutoBrConvertPTag: true,	// 기본값 : true


	//파입 삽입 시 파일아이콘 출력 여부
	attachFileExtIconView: false,


	// 에디터 로딩 완료 후 호출하는 함수
	strLoadingDoneFunction: "",


	//XSS필터링
	bRemoveXSS: true,

	//에디터자체의 테두리 수동 설정
	bSetCustomEditorContainerOutLine: false,
	//위설정이 true인경우 테두리 두께, 숫자만 입력하며, 단위는 px값이다. => 순서: 상,하,좌,우
	nCustomEditorContainerOutLineValues: [0,0,0,0],

	//에디터 편집창의 body margin 수동 설정
	bSetCustomEditorBodyMargin: false,
	//위 설정이 true인 경우 에디터 편집창의 body margin 세팅(숫자형), 단위는 px, 아래 변수값에 단위제외한 숫자값만 입력 => 순서: 상,하,좌,우
	nCustomEditorBodyMarginValues: [0,0,0,0],

	//에디터 편집창의 body word-break(단어 분리 줄바꿈) 수동 설정 (UBA-14575)
	//기본값: "normal"(v1.1.2.9 이상)
	strEditorStyleBodyWordBreak: "normal",	//"normal", "break-all", "keep-all"

	// 양식코드 예약어 문자열 2차원 배열
	// ex) [ ["_DF01_", "red"], ["_DF03_", ""] ] : 1st 요소는 문구열, 2nd 요소는 표시할 색상
	arrFormCodeString : [],

	// 양식코드 변경사항 전달 Callback 함수
	strChangeFormCodeFunction : "",
	
	//스킨컬러 세팅 : ["스킨명", "진한 값", "연한 값"]
	arrSkinColorSet: [		
		["blue",		"#547ecf", "#f3f7ff"],
		["bluegreen",	"#38a67c", "#f2faf6"],
		["brown",		"#b8842b", "#f8f5f0"],
		["gray",		"#7c8490", "#f2f4f7"],
		["green",		"#80b44c", "#f5faf0"],
		["lightblue",	"#289bd8", "#f1f8fc"],
		["orange",		"#e68a3a", "#fdf6f0"],
		["pink",		"#cc64ae", "#fcf5fa"],
		["red",			"#e26a6a", "#fdf4f4"],
		["violet",		"#8c6acf", "#f8f5fe"],
		["yellow",		"#dfb200", "#fcfaf0"]
	],

	// 테이블 자제 선택 메뉴 사용여부
	bUseTableMiniMenu : true,

	// 이미지에서 테이블 추출 사용여부
	bUseImageToTableMenu : true,
	strImageToTableURL : "",
	bUseImageToTableURLParam: false,	//이미지 선택 후 테이블 추출 시, 이미지 src를 query string으로 전달 (Amaranth 10)
	
	bCopyPasteTableCell: true,
	
	// 외부 이미지 업로드 사용
	bUseImageExtUpload : false,
	
	// 원피스 링크 붙여넣기시 링크박스 적용
	bApplyPasteOnefficeLink: false, 

	// 에디터 영역을 display:none 셋팅으로 생성 후 show 이벤트 시점에 호출하여야 하는 함수
	showEditor: function(editorId) {
		fnShowEditor(editorId);
	},


	construct: function() {
	}

};
dzeUiConfig.construct();