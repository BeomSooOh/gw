/**
 *  한글파일 공통
 */

	var _MinVersion =  0x05050111; // SetGetTextFile 최소 버젼.
	var _pHwpCtrl;

    /**
     * 버전인증
     * @returns {Boolean}
     */
    function _VerifyVersion() {

    	// 설치확인
    	if(_pHwpCtrl.getAttribute("Version") == null) {
    		//alert("한글 컨트롤이 설치되지 않았습니다.");
    		//return false;
    	}

    	//버젼 확인
    	CurVersion = _pHwpCtrl.Version;
    	if(CurVersion < _MinVersion) {
    		alert("HwpCtrl의 버젼이 낮아서 정상적으로 동작하지 않을 수 있습니다.\n"+
    				"최신 버젼으로 업데이트하기를 권장합니다.\n\n"+
    				"현재 버젼: 0x" + CurVersion.toString(16) + "\n"+
    				"권장 버젼: 0x" + _MinVersion.toString(16) + " 이상" );
    		return false;
    	}


    	if(CurVersion >= 0x0505118 && CurVersion <= 0x050511C ) { // GetTextFile 동작시 오류 발생
    		alert("HwpCtrl.GetTextFile이 정상적으로 동작하지 않는 버젼입니다.\n"+
    				"최신 버젼으로 업데이트하기를 권장합니다.\n\n"+
    				"현재 버젼: 0x" + CurVersion.toString(16) + "\n"+
    				"권장 버젼: " + 0x050511D + " 이상" );
    		return false;
     	}

     	return true;
    }
    function _hwpPutText(fieldName, val) {
    	if(_pHwpCtrl.FieldExist(fieldName )) {
	    	_pHwpCtrl.MoveToField(fieldName, true, true, false);
			//_pHwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);
	    	_pHwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);
	    	_pHwpCtrl.PutFieldText(fieldName, val);
    	}
	}
    function _hwpPutHtml(fieldName, val) {
    	if(_pHwpCtrl.FieldExist(fieldName )) {
    		_pHwpCtrl.MoveToField(fieldName, true, true, true);
    		//_pHwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);
    		_pHwpCtrl.SetTextFile(val, "HTML", "insertfile");
    	}
    }

	function _hwpPutImage(fieldName, imagePath) {
		if(_pHwpCtrl.FieldExist(fieldName )) {
		//_pHwpCtrl.MoveToField(fieldName, true, true, false);
		//_pHwpCtrl.Run("MoveLeft"); //화면에 보이게 하기 위해..
			_hwpInsertPicture(fieldName, imagePath);
		}
	}

	function _hwpInsertPicture(field, path) {
		// 셀에 그림을 넣기 전에, 셀의 내용을 전부 지운다.
		// _pHwpCtrl.ModifyFieldProperties(field, 0,1);
		_pHwpCtrl.MoveToField(field, true, true, false);
		_pHwpCtrl.Run("SelectAll");
		_pHwpCtrl.Run("Delete");

		_pHwpCtrl.MoveToField(field, true, true, false);
		//_pHwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);
		_pHwpCtrl.InsertBackgroundPicture("SelectedCell", path,1,5,0,0,0,0);

		//_pHwpCtrl.InsertPicture(path, true, 2, 0, 1, 0);
		 //_pHwpCtrl.ModifyFieldProperties(field, 1,0);

	}
    /**
     * 툴바 초기화
     */
    function _InitToolBarJS() {
//    	HwpControl.HwpCtrl.LockCommand("Undo", false);
    	HwpControl.HwpCtrl.SetToolBar(0, "FilePreview, Print, Separator,  Undo, Redo , Separator, Cut, Copy, Paste, ShapeCopyPaste,  Separator,CharShape, ParagraphShape,Style, MultiColumn, ParaNumberBullet, Separator, SpellingCheck, HwpDic, InputCodeTable, Presentation, Separator, PictureInsertDialog, TableCreate");
    	HwpControl.HwpCtrl.SetToolBar(-1, "TOOLBAR_FORMAT"); /* font */
    	HwpControl.HwpCtrl.SetToolBar(-1, "TOOLBAR_TABLE");
    	HwpControl.HwpCtrl.ShowToolBar(true);
//    	HwpControl.HwpCtrl.ReplaceAction("Undo", "Redo");//뒤로가기 방지 
    }


    function _hwpStart(filePath){
    	_pHwpCtrl = HwpControl.HwpCtrl;
	    _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

    	if (!_VerifyVersion()) {
	  		_pHwpCtrl = null;
	  	   	return;
	  	}

	   //	HwpControl.HwpCtrl.SetClientName("DEBUG"); //For debug message
	   	_InitToolBarJS();

		//var path= "<spring:message code='eapproval.templatepath' />/${docTemplateInfo.C_TIKEYCODE}.hwp";

	   	if(!HwpControl.HwpCtrl.Open(path,"HWP","versionwarning:true")){
	   		alert("파일 오픈실패!");
	   		return false ;
	   	};
	   	return true ;
    }

    function _hwpPrint() {
    	_pHwpCtrl.run("Print");
    }