var g_receiveGubun = "_ROW_";
var _g_arrKlUserType007 ;   //합의
var _g_arrKlUserType004 ;   //협조
var _g_arrKlUserType002 ;   //결재
var _g_arrKlUserType032 ;   //전결처리
var _g_approvalAction = "INSERT_APPRVLINE" ;
var _g_editType = "0" ;
var _g_isApprovalLast = false ; //결재에서 최종결재일경우    
var _g_isTotalApprovalLast = false ; // 결재 합의 포함했어 최종 결재여부 
var _g_receiveYN = "N" ;  //수신문서 여부
var _g_nonElecYN = "N" ;  //비전자(Y), 전자 문서(N) 여부
var _g_fileSymbol = "_NFN_";
var _g_userName = "" ;
var _g_positionName = "" ;
var _g_draftDeptName = "" ;
var _g_draftDate = "" ;
var _g_bagicHeight = 80 ;
var _g_docEditYN = "N" ;
var _g_isLoading = false ;
var _g_docTypeCodeID = "";
var _g_userKeyCode = "" ;
var _g_userOrgCode = "" ;
var _g_memoReportYN =  "N";
var _g_approvalImgMethodType = "1" ;
var _g_oldDocumentYN = "N";
var _g_approverCode = "001"; //001 직위, 002 직급
var _g_docApprovalClosedYN = "Y" ; //결재완료후 기안기 닫기여부
var _g_outFileLimitYN = "Y" ; //대외문서 첨부파일용량체크여부
var _g_senderList = "" ;
commonApproval = {
		/***********************************************************************/
		/**************************결재라인 저장********************************/
		/***********************************************************************/
		successApprovalLineUploadFile : function(arrDestFileName) {
			if (_g_isProcess == true ) {
				commonApproval.loadingEnd();
				return ;
			}else {
				commonApproval.loadingStart();
				_g_isProcess = true ;
			}
			lumpApproval.setHwpFileName(arrDestFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/approvalLineEdit.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
	    },		
		/***********************************************************************/
		/***********************************결재********************************/
		/***********************************************************************/
		successApprovalSignUploadFile : function(arrDestFileName) {
		
			commonApproval.setHwpFileName(arrDestFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/approvalSignEdit.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
	    },
		/***********************************************************************/
		/*******모바일 결재후 문서열었을때 결재라인 보정후 결재문서 저장********/
		/***********************************************************************/
		successDocApprovalSignUploadFile : function(arrDestFileName) {
			commonApproval.setHwpFileName(arrDestFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/docApprovalSignUpload.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
			frmMain.target = "" ;
	    },
	    /***********************************************************************/
	    /*******접수문서회수 반려후 문서열었을때 결재라인 보정후 결재문서 저장********/
	    /***********************************************************************/
	    successReceiveRreturnSignUploadFile : function(arrDestFileName) {
	    	commonApproval.setHwpFileName(arrDestFileName);
	    	frmMain.action = _g_contextPath+"/edoc/eapproval/receiveReturnSignUpload.do" ;
	    	frmMain.method= "post";
	    	frmMain.target = "hiddenFrame" ;
	    	frmMain.enctype="multipart/form-data" ;
	    	frmMain.submit();
	    	frmMain.enctype="application/x-www-form-urlencoded" ;
	    	frmMain.target = "" ;
	    },	    
	    /***********************************************************************/
	    /*******최종결재후 문서열었을때 결재라인 보정후 결재문서 저장********/
	    /***********************************************************************/
	    successFinalDocApprovalUploadFile : function(arrDestFileName) {
	    	commonApproval.setHwpFileName(arrDestFileName);
	    	frmMain.action = _g_contextPath+"/edoc/eapproval/lastDocApprovalUpload.do" ;
	    	frmMain.method= "post";
	    	frmMain.target = "hiddenFrame" ;
	    	frmMain.enctype="multipart/form-data" ;
	    	frmMain.submit();
	    	frmMain.enctype="application/x-www-form-urlencoded" ;
	    	frmMain.target = "" ;
	    },
	    /***********************************************************************/
	    /*******결재후 문서열었을때 결재라인 보정후 결재문서 저장***********/
	    /***********************************************************************/
	    successRevisitionDocApprovalUploadFile : function(arrDestFileName) {
	    	commonApproval.setHwpFileName(arrDestFileName);
	    	frmMain.action = _g_contextPath+"/edoc/eapproval/revisitionDocApprovalUpload.do" ;
	    	frmMain.method= "post";
	    	frmMain.target = "hiddenFrame" ;
	    	frmMain.enctype="multipart/form-data" ;
	    	frmMain.submit();
	    	frmMain.enctype="application/x-www-form-urlencoded" ;
	    	frmMain.target = "" ;
	    },
	    /***********************************************************************/
	    /*******최종결재후 문서열었을때 결재라인 보정후 결재문서 저장********/
	    /***********************************************************************/
	    successReceiveFinalDocApprovalUploadFile : function(arrDestFileName) {
	    	commonApproval.setHwpFileName(arrDestFileName);
	    	frmMain.action = _g_contextPath+"/edoc/eapproval/lastReceiveDocApprovalUpload.do" ;
	    	frmMain.method= "post";
	    	frmMain.target = "hiddenFrame" ;
	    	frmMain.enctype="multipart/form-data" ;
	    	frmMain.submit();
	    	frmMain.enctype="application/x-www-form-urlencoded" ;
	    	frmMain.target = "" ;
	    },
	    
		/***********************************************************************/
		/**************************문서정보 저장및 결재*************************/
		/***********************************************************************/
		successUploadFile : function(arrDestFileName) {
			commonApproval.setHwpFileName(arrDestFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/docApprovalInsert.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
		},
		/***********************************************************************/
		/**************************기록물철 초기화******************************/
		/***********************************************************************/		
		initOwnArchive:function(tabNumber) {
	        var aiKeyCode = $("#ownAiKeyCode").val() ;
	        var curAiKeyCode = $("#aiKeyCode_"+tabNumber).val();
	        
	        if( ncCom_Empty(curAiKeyCode)  && !ncCom_Empty( aiKeyCode ) )  {
	        	var aiKeyCode = $("#ownAiKeyCode").val() ;
	            var aiTitle = $("#ownAiTitle").val() ;
	            var preserve = $("#ownPreserve").val() ;
	            var preserveName = $("#ownPreserveName").val() ;
	            $("#aiKeyCode_"+tabNumber).val(aiKeyCode);
	            $("#aiTitle_"+tabNumber).val(aiTitle + " (" +preserveName+ ")");
	            $("#aiPreserve_"+tabNumber).val(preserve);
	            $("#preserveName_"+tabNumber).val(preserveName);
	        }
	    },
	    
	    /***********************************************************************/
	    /**************************수신처 초기화********************************/
	    /***********************************************************************/		
	    initReceive:function(tabNumber) {
	    	var autoSiReceiveName = $("#autoSiReceiveName").val() ;
	    	var autoSiReceiveCode = $("#autoSiReceiveCode").val();
	    	var siReceiveUserName = "" ;
	    	
	    	if(ncCom_Empty(autoSiReceiveName)) return ;
	    	
	        $("input[name=docTypeCode_"+tabNumber+"]").filter("input[value=001]").attr("checked", "checked"); //대내문서로 체크함.
	        lumpApproval.treatToggle(tabNumber);
	    	commonApproval.setReceive( autoSiReceiveCode, "" ,autoSiReceiveName, siReceiveUserName, tabNumber);
	    	
	    },
	    /***********************************************************************/
	    /***********************수신처 공백으로 초기화**************************/
	    /***********************************************************************/		
	    emptyReceive:function(tabNumber) {
			$("#susinjaView_"+tabNumber).val("");
			$("#customSusinjaView_"+tabNumber).val("");
			$("#idApprvLineReceive_"+tabNumber).val("");
	    	
	    },	    
		/***********************************************************************/
		/************************상신시 기안기에서 호출*************************/
		/***********************************************************************/	    
		INIT_INSERT : function ( tabNumber) {
			commonApproval.hwpStart(tabNumber); //문서 초기화

			$("#idKindNo_"+tabNumber).hide();  //구분번호 숨김
			$("#idReceiver_"+tabNumber).hide(); // 수신자 숨김
			$("#idCustomReceiver_"+tabNumber).hide();
			$("#idAddress_"+tabNumber).hide(); //주소 숨김
			$("#idPass_"+tabNumber).hide(); //경로 숨김
			$("#idInfoOpen_"+tabNumber).hide(); //홈페이지 공개여부 숨김
			$("#idUnfolder_"+tabNumber).hide();
			$("#idFolder_"+tabNumber).show();
			$("#idAttachFile_"+tabNumber).hide(); //숨김
			$("#zipcode1_"+tabNumber).numeric();
			$("#zipcode2_"+tabNumber).numeric();
			$("#idImgUnfolder_"+tabNumber).click(function() {
				commonApproval.chngFolder(tabNumber);
			});
			$("#idImgFolder_"+tabNumber).click(function() {
				commonApproval.chngFolder(tabNumber);
			});
			commonApproval.getDocInfo(tabNumber); // 문서정보 입력
		},	    
		/***********************************************************************/
		/**************************한글파일보기*********************************/
		/***********************************************************************/
		INIT_VIEW : function (tabNumber, diKeyCode, isDocEdit) {
			_g_approvalAction = "INSERT_VIEWAPPRVLINE";
			commonApproval.EDIT_HWPSTART(tabNumber, diKeyCode, isDocEdit); //문서 초기화

			$("#idImgUnfolder_"+tabNumber).click(function() {
				commonApproval.chngFolder(tabNumber);
			});
			$("#idImgFolder_"+tabNumber).click(function() {
				commonApproval.chngFolder(tabNumber);
			});

		},
		/***********************************************************************/
		/**************************수정시 한글파일******************************/
		/***********************************************************************/		
		INIT_EDIT : function (tabNumber, diKeyCode, publicType, treatmentCode, docGradeCode, docTypeCode, secretGradeCode) {

			commonApproval.EDIT_HWPSTART(tabNumber, diKeyCode); //문서 초기화

			$("#idKindNo_"+tabNumber).hide();  //구분번호 숨김
			$("#idReceiver_"+tabNumber).hide(); // 수신자 숨김
			$("#idCustomReceiver_"+tabNumber).hide();
			$("#idAddress_"+tabNumber).hide(); //주소 숨김
			$("#idPass_"+tabNumber).hide(); //경로 숨김
			$("#idInfoOpen_"+tabNumber).hide(); //홈페이지 공개여부 숨김
			$("#idAttachFile_"+tabNumber).hide(); //숨김
			$("#zipcode1_"+tabNumber).numeric();
			$("#zipcode2_"+tabNumber).numeric();

			$("#idImgUnfolder_"+tabNumber).click(function() {
				commonApproval.chngFolder(tabNumber);
			});
			$("#idImgFolder_"+tabNumber).click(function() {
				commonApproval.chngFolder(tabNumber);
			});
			
			commonApproval.getDocInfo(tabNumber, publicType, treatmentCode, docGradeCode, docTypeCode, secretGradeCode); // 문서정보 입력
			
			
		   	var draftYear = "" ;
		   	var draftMonth = "" ;
		   	var draftDay = "" ;
			var hwpCtrl = document.getElementById("HwpCtrl_"+tabNumber);
		   	if(!ncCom_Empty(_g_draftDate) && _g_draftDate.length == 10 ) { 
			   	draftYear = _g_draftDate.substring(0,4);
			   	draftMonth = _g_draftDate.substring(5,7);
			   	draftDay = _g_draftDate.substring(8,10);
			   	_hwpPutText("DRAFT_YEAR",  draftYear , hwpCtrl);
			   	_hwpPutText("DRAFT_MONTH",  draftMonth , hwpCtrl);
			   	_hwpPutText("DRAFT_DAY",  draftDay , hwpCtrl);
		   	}
		},		
		/***********************************************************************/
		/**************************한글파일수정*********************************/
		/***********************************************************************/
		EDIT_HWPSTART : function(tabNumber, diKeyCode, isDocEdit) {
			var hwpCtrl = document.getElementById("HwpCtrl_"+tabNumber);
			hwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
			
	    	if (!_VerifyVersion(hwpCtrl)) {
	    		hwpCtrl = null;
		  	   	return;
		  	}
	    	//hwpCtrl.SetClientName("DEBUG"); //For debug message
	    	if(isDocEdit == undefined) isDocEdit = true ;

	    	if ( isDocEdit )_InitToolBarJS(hwpCtrl);
			var path = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docDownload.do?randomKey="+rndStr("",13)+"&diKeyCode="+diKeyCode ;
		   	if(!hwpCtrl.Open(path,"")){
		   		alert("파일 오픈실패!");
		   		//return;
		   	};
		   	/*
		   	 * function mergeHwp()
 				{
 				HwpControl.HwpCtrl.Open("c:\\1.hwp");  //첫번째 파일을 불러옴..
 				HwpControl.HwpCtrl.MovePos(3);            //문서의 맨 마지막으로 이동
 				HwpControl.HwpCtrl.Insert("c:\\2.hwp");  //두번째 파일을 끼워넣기 함..
 				HwpControl.HwpCtrl.SaveAs("c:\\3.hwp");  //다른이름으로 저장하기..

				}
		   	 * 
		   	 * 
		   	 */
		   	if(isDocEdit) {
				if(hwpCtrl.FieldExist("_F_CONTENTS_")) {
					hwpCtrl.EditMode = 2 ; //CELL과 누름틀 중 양식모드에서 편집 가능한 속성을 가진 것만 편집가능하다.
				}else {
					hwpCtrl.EditMode = 1 ; //편집모드
				}
		   	}else {
		   		hwpCtrl.EditMode = 0; 
		   	}
		   	hwpCtrl.MovePos(2);
	    },
	    
		/***********************************************************************/
		/**************************첨부파일다운로드*****************************/
		/***********************************************************************/
		fileDownload : function(aiSeqNum, tabNumber) {
			$("#aiSeqNum").val(aiSeqNum);
			$("#diKeyCode").val($("#diKeyCode_"+tabNumber).val());
			frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/EDocAttachFileDownload.do" ;
			frmPop.method = "post" ;
			frmPop.target = "hiddenFrame" ;
			frmPop.submit();
			frmPop.target = "" ;
		},
		/***********************************************************************/
		/************************배포문서파일다운로드***************************/
		/***********************************************************************/
		localDownLoad : function( savedFileName, localFileName ) {
			$("#savedFileName").val(savedFileName);
			$("#localFileName").val(localFileName);
			frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/DocLocalFileDownload.do" ;
			frmPop.method = "post" ;
			frmPop.target = "hiddenFrame" ;
			frmPop.submit();
			frmPop.target = "" ;
		}, 
		
		/***********************************************************************/
		/**************************비전자 문서 저장*****************************/
		/***********************************************************************/
		nonElecDocLocalDownLoad : function( savedFileName, localFileName ) {
			$("#savedFileName").val(savedFileName);
			$("#localFileName").val(localFileName);
			if( _g_oldDocumentYN == "Y") {
				frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/nonElecOldDocLocalFileDownload.do" ;
			}else {
				frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/nonElecDocLocalFileDownload.do" ;
			}
			frmPop.method = "post" ;
			frmPop.target = "hiddenFrame" ;
			frmPop.submit();
			frmPop.target = "" ;
		}, 	
		
		/***********************************************************************/
		/*******************************HWP 저장********************************/
		/***********************************************************************/
	    LOCAL_SAVE : function () {
	    	if(_g_nonElecYN == "Y") return ;
	    	var curTabNumber = "" ;
			var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
			var rowNum = objCurrentTabNumber.length ;
			var pHwpCtrl ;
			for( var inx = 0 ; inx < rowNum; inx++) {
				curTabNumber = parseInt(objCurrentTabNumber[inx].value);
				pHwpCtrl =  document.getElementById("HwpCtrl_"+curTabNumber) ;
				pHwpCtrl.Save();
			}
	    },	
		/***********************************************************************/
		/*******************************VALID함수*******************************/
		/***********************************************************************/
	    isValid: function (arg1, arg2) {
			switch(arg1) {
				case 'UPLOAD_FILE' :
					var result = arg2 ;
					var arrDestFileName ;
					if(ncCom_Empty(result)) {
						alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요");
						return false ;
					}
					var temp = "";
					var point  = 0 ;
					var destFileName= "";
					if(result.length >=7 ) {
						temp  = result.substring(0,7) ;
					}
					point = temp.indexOf("SUCCESS") ;
					if(point < 0 ) {
						alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요");
						return false ;
					}
					destFileName = result.substring(8, result.length);
					destFileName = ncCom_Replace(destFileName,"\n","");
					destFileName = ncCom_Replace(destFileName,"\r","");
					arrDestFileName = destFileName.split(_g_fileSymbol);
					return arrDestFileName;			
				case 'INSERT_OPINION':
					var tabNumber = $("#showTabNumber").val();
					if(ncCom_Empty($("#dmMemo_"+tabNumber).val() )) return ncCom_ErrField($("#dmMemo_"+tabNumber), "결재 특이 사항을 입력하세요.");
					break;
				case 'EDIT_DOCNAME':
					var curTabNumber = arg2
				    var docTitle = $("#dname2_"+curTabNumber).val();
				    var srcDiTitle = $("#srcDiTitle_"+curTabNumber).val();
				    if(ncCom_Empty(docTitle)) return false  ;
					if(docTitle == srcDiTitle ) return true ;    
				
				    //문서제목 체크
					if(fc_isIncludeEnterKey(docTitle)) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목에 엔터키가 포함되어 있습니다.");

					// 제목에 특수문자 체크
					var r1 = new RegExp(getDocTitleExp());
					if(r1.test(docTitle)) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목에 아래 예의 특수문자가 포함되어 있습니다.\n예) " + getExpKeyword(getDocTitleExp()));
					break;
				case 'VALID_APPRVLINE':
					var rowNum = document.getElementsByName("emplyrSttusCode").length ;
					for(var inx = 0 ; inx < rowNum; inx++ ) {
		       	 		if(document.getElementsByName("emplyrSttusCode")[inx].value != "999" 
		       	 			&& document.getElementsByName("isSaved")[inx].value == "1" 
							&& !ncCom_Empty(document.getElementsByName("klStatus")[inx].value) ) {
		       	 			alert("결재라인에 " +document.getElementsByName("userNm")[inx].value+ " 은(는) 재직중이 아닙니다. 확인 해주세요");
		       	 			return false ;
		                 }
		       	  	}
					break;
				case 'EQUAL_PASSWORD' :
					if(ncCom_Empty($("#userPassword").val())) {
						alert("결재비밀번호가 없습니다.");
						return false ;
					}
					if($("#paramDiStatus").val() == "999") {
						if( !commonApproval.isValid("VALID_APPRVLINE") ) return false;
					}
					break;					
				case 'POP_VIEWAPPROVALSIGN' :
					var frm =document.frmMain;
					if(frm.esntlID == undefined ) {
			    		alert("결재라인을  지정하세요.");
			    		return false ;
			    	}
					if(_g_docEditYN == "Y") {
						if (!commonApproval.setAllDocNameHwp() ) return false ;
					}
					break;	
					
			}
			return true ;
			
		},
		
		/***********************************************************************/
		/*******************************MAIN 함수*******************************/
		/***********************************************************************/		
		main:function (arg1, arg2, arg3 , arg4, arg5, arg6, arg7 ) {
			switch(arg1) {
				case 'EQUAL_PASSWORD' : //결재비밀번호비교
					if(!commonApproval.isValid(arg1)) return ;
					if(_g_isProcess == true ) {
						commonApproval.loadingEnd();
						return ;
					}else  {
						commonApproval.loadingStart();
						_g_isProcess = true ;
					}
					commonApproval.setAllDocFileName();
					commonApproval.setApprovalSignInfo();
					commonApproval.hwpNonModified();

					var url = _g_contextPath+"/edoc/eapproval/workflow/approvalSignLumpPassword.do" ;
	/*				
					var data = { "userPassword": $("#userPassword").val(),
								  "klUserType" : arg2,
								  "selectedCnt" : arg3,
								  "isApprovalLast" : arg4,
								  "curDate" : arg5,
								  "docNum" : arg6,
								  "liKeyCode" : $("#liKeyCode").val(),
								  "diStatus" : $("#paramDiStatus").val(),
								  "draftCount" : rowNum };
 								  
					ajaxPOST(url, data, commonApproval.approvalPasswordCallBack);
   */
					frmMain.action  = url ;
					frmMain.method  = "post";
			    	frmMain.target  = "hiddenFrame" ;
			    	frmMain.enctype ="application/x-www-form-urlencoded" ;
			    	frmMain.submit();
			    	frmMain.enctype ="application/x-www-form-urlencoded" ;
			    	frmMain.target  = "" ;
					break;
				case 'EDIT_NONELECAPPROVALLINE' : //결재라인 수정
					//doc.reading.js 참조
					if($("#docReadingYN").val() == 'Y') setAllReadingInfo();
		
					if(_g_docEditYN == "Y") {
						if (!commonApproval.setAllDocNameHwp() ) {
							return ;
						}
					}
					if (_g_isProcess == true ) {
						commonApproval.loadingEnd();
						return ;
					}else {
						commonApproval.loadingStart();
						_g_isProcess = true ;
					}
					var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
					if(arrFileName == false ) return ;
					
					if(arrFileName != "" ) commonApproval.setHwpFileName(arrFileName);
					
					frmMain.action = _g_contextPath+"/edoc/eapproval/approvalLineEdit.do" ;
					frmMain.method= "post";
					frmMain.target = "hiddenFrame" ;
					frmMain.enctype="multipart/form-data" ;
					frmMain.submit();
					frmMain.enctype="application/x-www-form-urlencoded" ;
					break;	
				case 'INSERT_APPRVLINE' : // 문서, 선택항목저장
					if(!lumpApproval.isValid(arg1)) return ;

				 	if( !commonApproval.setApprovalInfo(arg1, arg2) ) return ;

				 	commonApproval.docInfoToHwp(); //문서항목 hwp 로 저장
				 	
				 	var arrFileName = commonApproval.docFileUpload( _g_contextPath+"/edoc/eapproval/docApprovalLumpUpload.do", $("#userPassword").val());
				 	if(arrFileName == false ) return ;
				 	
					commonApproval.successUploadFile(arrFileName);
					break;	
				case 'EDIT_APPROVALLINE' : // 문서upload, 결재라인 수정
					commonApproval.setHwpModified();
					
					if(_g_docEditYN == "Y") {
						if (!commonApproval.setAllDocNameHwp() ) return ;
					}
					commonApproval.setApprovalLineToHwp();
					commonApproval.setAllDocFileName();
					
			    	//doc.reading.js 참조
					if($("#docReadingYN").val() == 'Y') setAllReadingInfo();
					
					var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
					if(arrFileName == false ) return ;
					commonApproval.successApprovalLineUploadFile(arrFileName);
					break;	
				case 'INSERT_VIEWAPPRVLINE' : // 결재
					if( !commonApproval.setApprovalInfo(arg1, arg2) ) return ;
					//doc.reading.js 참조
					if($("#docReadingYN").val() == 'Y') setAllReadingInfo();
				 	var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docApprovalLumpUpload.do", $("#userPassword").val());
				 	if(arrFileName == false ) return ;
				 	
					commonApproval.successApprovalSignUploadFile(arrFileName);
					break;					
				case 'LIST_OPINION' : //의견리스트
					var tabNumber = $("#showTabNumber").val();
					var url = _g_contextPath+"/edoc/eapproval/workflow/listDocOpinion.do" ;
					var data = { "diKeyCode": $("#diKeyCode_"+tabNumber).val() } ;
					ajaxPOST(url, data, commonApproval.opinionListCallBack);
					break;
				case 'INSERT_OPINION' : //의견저장
					if(!commonApproval.isValid(arg1)) return ;
					var tabNumber = $("#showTabNumber").val();
					var url = _g_contextPath+"/edoc/eapproval/workflow/insertDocOpinion.do" ;
					var data = { "diKeyCode": $("#diKeyCode_"+tabNumber).val(),
								 "dmMemo": $("#dmMemo_"+tabNumber).val(),
								 "resultType" : "INSERT_OPINION"} ;
					ajaxPOST(url, data, commonApproval.insertOpinionCallBack);
					break;
				case 'DELETE_OPINION' : //의견삭제
					var tabNumber = $("#showTabNumber").val();
					var url = _g_contextPath+"/edoc/eapproval/workflow/deleteDocOpinion.do" ;
					var data = { "diKeyCode": $("#diKeyCode_"+tabNumber).val() ,
								  "dmWriteDate" : arg2} ;
					ajaxPOST(url, data, commonApproval.deleteOpinionCallBack);
					break;					
				case 'LOCAL_SAVE' : //PC저장
					if(_g_nonElecYN == "Y" && _g_memoReportYN == "N") { //비전자문서
						var tabNumber = $("#showTabNumber").val();
						var diKeyCode = $("#diKeyCode_"+tabNumber).val();
						commonApproval.nonElecDocLocalDownLoad(diKeyCode, arg2);
					}else {
						var showTabNumber =  $("#showTabNumber").val();
				    	
						var filePath = lumpApproval.getHwpPath(showTabNumber);
						var tabNumber = $("#showTabNumber").val();
						var hwpCtrl = document.getElementById("HwpCtrl_"+tabNumber);
						var fileName = rndStr("",10)+showTabNumber+".hwp";
						var filePathName = filePath + fileName;
						var srcFilePathName = hwpCtrl.Path() ;
			
						//로컬 에 저장하기전 원본파일을 저장한다.
						hwpCtrl.Save();
			
						var isSave = hwpCtrl.SaveAs(filePathName,"HWP");
			
						if(isSave != true ) return false ;
					
						var vAct = hwpCtrl.CreateAction("FileSetSecurity");
					    var vSet = vAct.CreateSet();
					    vAct.GetDefault(vSet);
					    vSet.SetItem("Password", rndStr("",8));       // 패스워드
					    vSet.SetItem("NoPrint", 0);       // 프린트
					    vSet.SetItem("NoCopy", 1);       // 복사
					    if(!vAct.Execute(vSet) ) {
					    	alert("실패");
					    }
					
					    hwpCtrl.Open(srcFilePathName,"HWP","versionwarning:true") ;
						//var isSave = hwpCtrl.SaveAs(filePathName,"HWP","distribute:true");
						//alert(isSave);
			
					    hwpCtrl.EditMode = 0 ;
					   	hwpCtrl.MovePos(2);
					   	
						$("#localPathName_"+showTabNumber).val(filePathName);
						//var uri = _g_contextPath+"/edoc/eapproval/workflow/docLumpSavePopup.do?showTabNumber="+showTabNumber;
						//openWindow2(uri,  "popSaveDoc"+showTabNumber, _g_aproval_width_, _g_aproval_heigth_, 0,1) ;
					
						uploader.addFile("docFile_1", filePathName);
					
						uploader.addParam("upload_file_cnt", 1);
						uploader.addParam("file_id", "upload.approval.doc.temp");
						var uploadUri = _g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do";
						var result = uploader.sendRequest(_g_serverName, _g_serverPort, uploadUri);
						var arrFileName = commonApproval.isValid('UPLOAD_FILE', result);
						commonApproval.localDownLoad(arrFileName[0], arg2);
					}
				
					break;
			}
		},
		/***********************************************************************/
		/***************************관인 이미지 삽입****************************/
		/***********************************************************************/		
		sealInsert : function(hwpCtrl, diKeyCode){
			
	        var data = {"c_dikeycode" : diKeyCode};
	        $.ajax({                
	            url: getContextPath() +'/neos/edoc/delivery/send/popup/imageGwaninLoad.do',
	            type:"post",
	            datatype:"json",
	            data: data,
	          	async:false ,
	            success:function(data){ 
	                var url = getContextPath()+"/cmm/fms/getImageViewer.do?filename="+data+"&type=sign";
	                var signPath =  'http://'+_g_serverName+':'+_g_serverPort+url;
	                if(data){
	                    if(hwpCtrl.FieldExist("seal")){  
	                        _hwpPutImages('seal',signPath,hwpCtrl);
	                       
	                    }
	                }
	            },
	            error:function(request,status,error){
	                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	            }
	        });
	    },	
	    /*************************************************************************/
	    /***************************결재의견 삽입*************************************/
	    /*************************************************************************/		
	    opinionInsert : function(hwpCtrl, diKeyCode){
	    	var data = {"diKeyCode" : diKeyCode};
	    	$.ajax({                
	    		url: getContextPath() +'/edoc/eapproval/workflow/listDocOpinionHTML.do',
	    		type:"post",
	    		datatype:"json",
	    		data: data,
	    		async:false ,
	    		success:function(data){ 
	    			
	    			if(data){
	    				var opinionHTML  = data.opinionHTML ;
	    			
	    				if(hwpCtrl.FieldExist("OPINION_PRINT")){
	    					if(!ncCom_Empty(opinionHTML)) {
	    						 hwpCtrl.MoveToField('OPINION_PRINT',true,true,false);
	    						 hwpCtrl.SetTextFile(opinionHTML, "HTML", 'insertfile');
	    					}
	    				}
	    			}
	    		},
	    		error:function(request,status,error){
	    			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    		}
	    	});
	    },	
	    
		/***********************************************************************/
		/********************************문서정보 입력**************************/
		/***********************************************************************/	    
	    /**
	     * 문서정보입력 
	     * @param tabNumber  탭번호
	     * @param publicType 공개여부
	     * @param treatmentCode  문서취급
	     * @param docGradeCode 긴급여부
	     * @param docTypeCode 문서구분
	     * @param secretGradeCode 보안여부
	     */
		getDocInfo:function(tabNumber, publicType, treatmentCode, docGradeCode, docTypeCode, secretGradeCode    ) {
			if( ncCom_Empty( publicType ) )  publicType  = "FIRST";
			var docInfoHtml = NeosLumpCodeUtil.getCodeRadio("COM106", "publicType"  , tabNumber, publicType,"lumpApproval.publicGubunToggle('"+tabNumber+"');") ; //공개여부
			$("#idPublicHtml_"+tabNumber).html( docInfoHtml);

			docInfoHtml = NeosLumpCodeUtil.getCodeCheck("COM105", "publicGradeCH", tabNumber, "","") ; //구분번호
			docInfoHtml += "&nbsp;&nbsp;<a href=\"#none\" onclick=\"lumpApproval.pop('POP_DESC');\"><img src=\""+_g_contextPath+"/images/neos/popup/topbullet_3rd_on.gif\"><font color=\"#666666\"> 비공개대상정보설명</font></a>";
			$("#idKindNoHtml_"+tabNumber).html(docInfoHtml);

			if( ncCom_Empty( treatmentCode ) )  treatmentCode  = "FIRST";
			docInfoHtml = NeosLumpCodeUtil.getCodeRadio("COM107", "treatmentCode", tabNumber, treatmentCode,"lumpApproval.treateControl('"+tabNumber+"')") ; //문서취급
			$("#idTreatmentHtml_"+tabNumber).html( docInfoHtml);
			
			if( ncCom_Empty( docGradeCode ) )  docGradeCode  = "FIRST";
			docInfoHtml = NeosLumpCodeUtil.getCodeRadio("COM111", "docGradeCode", tabNumber, docGradeCode,"") ; //긴급여부
			$("#idDocGradesHtml_"+tabNumber).html(docInfoHtml);
			
			if( ncCom_Empty( docTypeCode ) ) docTypeCode  = "FIRST";
			docInfoHtml = NeosLumpCodeUtil.getCodeRadio(_g_docTypeCodeID, "docTypeCode", tabNumber, docTypeCode,"lumpApproval.treatToggle('"+tabNumber+"');") ;  //문서구분
			$("#idDocGubunHtml_"+tabNumber).html(docInfoHtml);

			if( ncCom_Empty( secretGradeCode ) ) secretGradeCode  = "FIRST";
			docInfoHtml = NeosLumpCodeUtil.getCodeRadio("COM129", "secretGradeCode", tabNumber, secretGradeCode,"") ; //보안문서

			$("#idSecurityHtml_"+tabNumber).html( docInfoHtml+" (결재선+소유자 열람)");
			commonApproval.autoReceiveDocInfo(tabNumber);
		},	 
		
		autoReceiveDocInfo :function(tabNumber) {
			if(_g_tiUseFlag == "003") { //자동 수발신 문서
				$("#treatmentCode1_"+tabNumber ).attr("disabled", true);
				$("#treatmentCode2_"+tabNumber ).attr("disabled", true);
				$("#treatmentCode3_"+tabNumber ).attr("disabled", true);
				$("#treatmentCode4_"+tabNumber ).attr("disabled", true);
				$("#treatmentCode5_"+tabNumber ).attr("disabled", true);
				$("#treatmentCode6_"+tabNumber ).attr("disabled", true);
				$("#treatmentCode7_"+tabNumber ).attr("disabled", true);

				$("#docTypeCode1_"+tabNumber ).attr("disabled", true);
				$("#docTypeCode2_"+tabNumber ).attr("disabled", true);
				$("#docTypeCode3_"+tabNumber ).attr("disabled", true);
				$("#docTypeCode4_"+tabNumber ).attr("disabled", true);
				$("#docTypeCode5_"+tabNumber ).attr("disabled", true);
			}
		},		
		/***********************************************************************/
		/********************************팝업 호출******************************/
		/***********************************************************************/
	    pop : function(arg) {
			switch(arg) {
				case 'POP_RECEIVER' : //수신자 목록
					var showTabNumber =  $("#showTabNumber").val();
		
					var docTypeCode = $("input[name='docTypeCode_"+showTabNumber+"']:checked").val() ;
					
					var uri = "";
					var width = 640 ;
					var height = 550 ;
					if( docTypeCode == "001" ) { //대내
						width = 630 ;
						height = 630;
						uri = _g_contextPath+"/neos/edoc/document/record/popup/outterSelectPopup.do";
					}else if (docTypeCode  == "002" || docTypeCode  == "004") { //대외
						width = 515 ;
						height = 630;
						uri = _g_contextPath+"/neos/edoc/document/record/popup/LdapSelectPopup.do";
					}
					
					openWindow2("",  "selectOrganView", width, height, 0) ;
					frmPop.c_sireceivecode.value =$("#arrSiReceiveCode_"+showTabNumber).val();
					frmPop.c_sireceivename.value = "";
					frmPop.c_sireceiveusername.value = "";
					frmPop.sendername.value = $("#arrSiSenderName_"+showTabNumber).val();
					frmPop.senderusername.value = $("#arrSiReceiveUserName_"+showTabNumber).val();
					frmPop.inputId.value = 'upperOrganId';
					frmPop.methodName.value = 'commonApproval.setReceive';
					frmPop.target = "selectOrganView";
					frmPop.action = uri;
					frmPop.submit();
					frmPop.target = "" ;
					break;
				case "POP_DOCSUMMARYVIEW" : //문서요약 팝업
					var showTabNumber =  $("#showTabNumber").val();
					$("#summaryDiKeyCode").val($("#summaryDiKeyCode_"+showTabNumber).val());
					openWindow2("",  "popDocSummary", 646, 510, 0) ;
					frmPop.target = "popDocSummary";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/docSummaryView.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case "POP_HWPSAVE" : //파일명
					var showTabNumber = $("#showTabNumber").val();
			    	var doctype = $("#docTypeCode_"+showTabNumber).val();
			    	var draftStatus = $("#draftStatus").val();			    	
			    	var riDocNum = $("#riDocNum_"+showTabNumber).val();
			    	if(doctype=='001'||doctype=='002'||doctype=='003'||doctype=='004'){
				    	if(confirm("관인을 삽입하시겠습니까?")){
				    		if(!riDocNum){
					    		alert('결재완료 전에는 관인삽입이 불가능합니다.');
					    		return;
					    	}
				    		var pHwpCtrl =  document.getElementById("HwpCtrl_"+showTabNumber) ;
				    		var diKeyCode = $("#diKeyCode_"+showTabNumber).val(); 
				    		commonApproval.sealInsert(pHwpCtrl, diKeyCode);
				    	}
			    	}
			    	
					var uri = _g_contextPath+"/edoc/eapproval/workflow/hwpFileSavePopup.do";
					openWindow2(uri,  "popApprovalSign", 350, 120, 0) ;
					break;
			    case "POP_HWPPRINT" : //인쇄
			    	var showTabNumber = $("#showTabNumber").val();
		          /*
		            var doctype = $("#docTypeCode_"+showTabNumber).val();
		            if(doctype=='001'||doctype=='002'||doctype=='004'){
		              if(confirm("관인을 삽입하시겠습니까?")){
		                commonApproval.sealInsert();
		              }
		            }
		            */
			    	var docTypeCode = $("#docTypeCode_"+showTabNumber).val();
			    	var diKeyCode = $("#diKeyCode_"+showTabNumber).val();
			    	var draftStatus = $("#draftStatus").val();
			    	var riDocNum = $("#riDocNum_"+showTabNumber).val();
			    	var uri = _g_contextPath+"/edoc/eapproval/workflow/hwpPrintPopup.do?showTabNumber="+showTabNumber+"&diKeyCode="+diKeyCode+"&docTypeCode="+docTypeCode+"&draftStatus="+draftStatus+"&riDocNum="+riDocNum;
			    	openWindow2(uri,  "popApprovalPrint", 350, 120, 0) ;
			    	break;      	
				case "POP_APPROVALLINE" : //결재라인 팝업
					var showTabNumber =  $("#showTabNumber").val();					
					$("#idApprvLine2").html($("#idApprvLine").html());
					$("#delApprovalMember2").html($("#delApprovalMember").html());
					$("#popSelOrganID").val($("#selOrganID_"+showTabNumber).val());
					$("#popDiSenderCode").val($("#diSenderCode_"+showTabNumber).val());
					$("#popSelSenderName").val($("#selSenderName_"+showTabNumber).val());					
					openWindow2("",  "popApprovalLine",  1015, 669, 0) ;
					frmPop.target = "popApprovalLine";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/approvalLineWrite.do";
					frmPop.submit();
					frmPop.target = "";
					$("#idApprvLine2").html("");
					$("#delApprovalMember2").html("");
					break;
				case 'POP_APPROVALLINEVIEW' : //결재라인 보기
					var diKeyCode = $("#diKeyCode_1").val();
					var param = "diKeyCode="+diKeyCode;
					neosPopup('POP_APPLINE', param);
					break;
				case 'POP_VIEWAPPROVALSIGN' : //문서필수항목체크 제외 하고 결재사인팝업
					if(!commonApproval.isValid(arg)) return ;
					frmPop.diKeyCode.value =  $("#diKeyCode_1").val();
					
					$("#isApprovalLast").val("0");
					commonApproval.setApprovalSignInfo();
					var objEsntlID = document.getElementsByName("esntlID");
					var objKlOrgCode = document.getElementsByName("deptID");
					var objKlUserType = document.getElementsByName("klUserType");
					var objViUserKey = document.getElementsByName("viUserKey");
					var objViOrgCode = document.getElementsByName("viOrgCode");
					var objKlStatus = document.getElementsByName("klStatus");
					var objAbsentName = document.getElementsByName("absentName") ;
					var popKlUserType = "" ;
					var rowNum = objEsntlID.length ;
					var isKyuljae = false ;
					for(var inx = rowNum-1 ; inx >= 0 ; inx--) {
						if( _g_userKeyCode ==  objEsntlID[inx].value && _g_userOrgCode == objKlOrgCode[inx].value  &&  !ncCom_Empty(objKlStatus[inx].value) ) {
							$("#popKlUserType").val(objKlUserType[inx].value);
							isKyuljae = true ;
							break;
						}else if (_g_userKeyCode == objViUserKey[inx].value  && _g_userOrgCode == objViOrgCode[inx].value &&  !ncCom_Empty(objKlStatus[inx].value)  ) {
							popKlUserType = objKlUserType[inx].value ;
						}
					}
					if(isKyuljae == false ) {
						$("#popKlUserType").val(popKlUserType);
					}
					openWindow2("",  "popApprovalSign", 430, 370, 0) ;
					frmPop.target = "popApprovalSign";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/approvalSignLump.do";
					frmPop.submit();
					frmPop.target = "";
					break;	
	    		case "POP_KOFIA_AUDIT" : //kofia 금투 감사의견 팝업 2013-06 10 orbit 추가  해당 키 값이 넘어가지 않아 수정함
					var showTabNumber =  $("#showTabNumber").val();
					var diKeyCode = $("#diKeyCode_"+showTabNumber).val() ;
	    			var uri = getContextPath() + "/kofia/consultlawReason/pop/PopinHwpView.do?c_dikeycode="+diKeyCode ;
	    			openWindow2(uri,  "popReasonView", 500, 450, 0) ;
	                break;	
	    		case "POP_SHAREDDOCUSER" : //공유문서사용자 선택
	    			var url = getContextPath()+"/edoc/eapproval/workflow/sharedDocUser.do?methodName=setCheckedSharedUser";
					openWindow2(url, "popSharedDocUser", 520, 570, 0) ;
					break;	                
			}
	    } ,

		/**********************************************************************************************/
		/***********************************결재라인정보저장 ******************************************/
		/**********************************************************************************************/
		setApprovalSignInfo : function() {
			 //대리결재가 있어 연속으로 결재 + 대리결재+결재안함 가 있을경우  같이 결재 처리하기위해 배열사용함
			 //2열 결재 했으면 :0, 결재 안했으면 1 로셋팅
			_g_isApprovalLast =  false ;
			_g_isTotalApprovalLast = false ;
			_g_arrKlUserType007 = [[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""]] ; // 합의 (1열 : 대리결재여부, 2열: 사인등록여부)
			_g_arrKlUserType004 = [[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""]] ; // 협조 (1열 : 대리결재여부, 2열: 사인등록여부)
			_g_arrKlUserType002 = [[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1,""],[0,-1, ""]] ; // 결재 (1열 : 대리결재여부, 2열: 사인등록여부)
			_g_arrKlUserType032 = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]; //전결처리
			
			var klUserType = "" ;
			var objEsntlID = document.getElementsByName("esntlID");
			var objKlOrgCode = document.getElementsByName("deptID");
			var objKlUserType = document.getElementsByName("klUserType");
			var objViUserKey = document.getElementsByName("viUserKey");
			var objViOrgCode = document.getElementsByName("viOrgCode");
			var objKlStatus = document.getElementsByName("klStatus");
			var objAbsentName = document.getElementsByName("absentName") ;
			var objKlUserProperty032 = document.getElementsByName("klUserProperty032");
			var objKlUserProperty064 = document.getElementsByName("klUserProperty064");
			var objKlUserProperty256 = document.getElementsByName("klUserProperty256");
			var klUserProperty064 = "" ;
			var klUserProperty256 = "" ;
			var absentName = "" ;
			
			var rowNum = objEsntlID.length ;
			var lastInx = 0 ; //결재중에 최종결재 index 합의는 제외
			
		    if ( document.getElementsByName("klUserType")[rowNum-1].value == "007" ) { // 마지막이 합의이면 
	        	for(var inx = rowNum-1 ; inx > 0   ; inx--) {
		       		klUserType = objKlUserType[inx].value;
		       		if( klUserType == "001" || klUserType == "002" || klUserType == "003"  ) { //결재
		       			lastInx = inx ;
		       			break;
		       		}
	        	}
		    }else {
		    	lastInx = rowNum -1 ;  ;
		    }
			
			if( rowNum  == 1 ) { //상신자이면서 전결처리
	    		$("#isApprovalLast").val("1");
	    		_g_arrKlUserType002[0][1] = 1 ;
	    		_g_arrKlUserType032[0] = 1 ;
	    		_g_isApprovalLast =  true ;
	    		_g_isTotalApprovalLast = true ;
	    	} else  {
	    		var approvalInx = -2;
	    		var userType002 = -1; //결재
	    		var userType004 = -1 ; //협의
	    		var userType007 = -1;  //합의
	    		
	    		var klUserType = "" ;
	    		var klUserProperty032 = "" ;
	    		for(var inx = 0 ; inx < rowNum; inx++) {
	    			klUserType = objKlUserType[inx].value ;
	    			klUserProperty032 = objKlUserProperty032[inx].value ;
					klUserProperty064 = objKlUserProperty064[inx].value ;
					klUserProperty256 = objKlUserProperty256[inx].value ;
					absentName = objAbsentName[inx].value ;
	    			if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	    				userType002++ ;
	   					if(klUserProperty032 == "032") {
	   						_g_arrKlUserType032[userType002] = 1;
	   					}else {
	   						_g_arrKlUserType032[userType002] = 0;
	   					}
	   				}else if ( klUserType == "004" ){ //협의
	   					userType004++;
	   				}else if ( klUserType == '007') { //합의
	   					userType007++;
	   				}
	    			 
	    			if( objEsntlID[inx].value ==  _g_userKeyCode && objKlOrgCode[inx].value ==  _g_userOrgCode) {
	    				if(  ncCom_Empty(objKlStatus[inx].value ) ) { //결재 했으면 skip 대리 결재 체크
	    					if ( klUserType == "004" ){ //협조
	   							_g_arrKlUserType004[userType004][1] = 0 ;
	   						}else  if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	   							if(klUserProperty032 == "032") {
	   								_g_arrKlUserType032[userType002] = 1;
	   							}else  {
	   								_g_arrKlUserType032[userType002] = 0;
	   							}
	   							_g_arrKlUserType002[userType002][1] = 0 ;
							}else if(klUserType == "007") { //합의
								_g_arrKlUserType002[userType007][1] = 0 ;
							}
	    				}else { //결재 안했으면
	    					if( approvalInx == -2 ) {
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							if(klUserProperty256 == "256") _g_arrKlUserType004[userType004][0] = 1 ;
	    							
	    						}else  if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	    							_g_arrKlUserType002[userType002][1] = 1 ;
    								if(klUserProperty256 == "256") _g_arrKlUserType002[userType002][0] = 1 ;
	    							
	    						}else if (klUserType == "007") {
	    							_g_arrKlUserType007[userType007][1] = 1 ;
	    							if(klUserProperty256 == "256") _g_arrKlUserType007[userType007][0] = 1 ;
	    						}
	    					}else {
	    						if ( inx - approvalInx != 1) break;
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							if(klUserProperty256 == "256") _g_arrKlUserType004[userType004][0] = 1 ;
	    						}else  if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    							if(klUserProperty064 == "256") _g_arrKlUserType002[userType002][0] = 1 ;
	    						}else if (klUserType == "007") {
	    							_g_arrKlUserType007[userType007][1] = 1 ;
	    							if(klUserProperty064 == "256") userType007[userType007][0] = 1 ;
	    						}
	    					}
	    					if (inx == lastInx )  _g_isApprovalLast = true ;
	    				}
	    			}else if ( objViUserKey[inx].value ==  _g_userKeyCode  && objViOrgCode[inx].value ==  _g_userOrgCode) { //대리결재
	    				if(  ncCom_Empty(objKlStatus[inx].value ) ) { //대리결재 했으면 skip
	    					if ( klUserType == "004" ){ //협의
   							_g_arrKlUserType004[userType004][1] = 0 ;
	    					}else  if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
   							_g_arrKlUserType002[userType002][1] = 0 ;
	    					}else if ( klUserType == "007" ){ //합의 
	    						_g_arrKlUserType007[userType007][1] = 0 ;	
	    					}
	    				}else { //결재 안했으면
	    					if( approvalInx == -2 ) {
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							_g_arrKlUserType004[userType004][0] = 1 ; //대결여부
	    						}else if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    							_g_arrKlUserType002[userType002][0] = 1 ; //대결여부
	    						}else if (klUserType == "007" ){ //합의 
	    							_g_arrKlUserType007[userType007][1] = 1 ;
	    							_g_arrKlUserType007[userType007][0] = 1 ; //대결여부
	    						}

	    					}else {
	    						if ( inx - approvalInx != 1) break;
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							_g_arrKlUserType004[userType004][0] = 1 ; //대결여부
	    						} else if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    							_g_arrKlUserType002[userType002][0] = 1 ; //대결여부
	    						} else if (klUserType == "007" ){ //합의
	    							_g_arrKlUserType007[userType007][1] = 1 ;
	    							_g_arrKlUserType007[userType007][0] = 1 ; //대결여부
	    						}
	    					}
	    					if (inx == lastInx )  _g_isApprovalLast = true ;
	    				}
	    		   }else if (klUserProperty064 == "064") { //결재안함 
	    			   if(  ncCom_Empty(objKlStatus[inx].value ) ) { //결재 했으면 skip 대리 결재 체크
	    				   if ( klUserType == "004" ){ //협의
	   							_g_arrKlUserType004[userType004][1] = 0 ;
		    				}else  if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	   							_g_arrKlUserType002[userType002][1] = 0 ;
		    				}else if ( klUserType == "007" ){ //합의 
		    					_g_arrKlUserType007[userType007][1] = 0 ;	
		    				}   
	    			   }else {
	    				   if( approvalInx == -2 ) {
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							_g_arrKlUserType004[userType004][0] = 2 ; //결재안함
	    							_g_arrKlUserType004[userType004][2] = absentName ; //결재안함
	    						}else if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    							_g_arrKlUserType002[userType002][0] = 2 ; //결재안함
	    							_g_arrKlUserType002[userType002][2] = absentName ; //결재안함
	    						}else if (klUserType == "007" ){ //합의 
	    							_g_arrKlUserType007[userType007][1] = 1 ;
	    							_g_arrKlUserType007[userType007][0] = 2 ; //결재안함
	    							_g_arrKlUserType007[userType007][2] = absentName ; //결재안함
	    						}

	    					}else {
	    						if ( inx - approvalInx != 1) break;
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							_g_arrKlUserType004[userType004][0] = 2 ; //결재안함
	    							_g_arrKlUserType004[userType004][2] = absentName ; //결재안함
	    							
	    						} else if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    							_g_arrKlUserType002[userType002][0] = 2 ; //결재안함
	    							_g_arrKlUserType002[userType002][2] = absentName ; //결재안함
	    						} else if (klUserType == "007" ){ //합의
	    							_g_arrKlUserType007[userType007][1] = 1 ;
	    							_g_arrKlUserType007[userType007][0] = 2 ; //결재안함
	    							_g_arrKlUserType007[userType007][2] = absentName ; //결재안함
	    						}
	    					}
	    					if (inx == lastInx )  _g_isApprovalLast = true ;	    				   
	    			   }
	    		   }else {
	    				if ( klUserType == "004" ){ //협의
							_g_arrKlUserType004[userType004][1] = 0 ;
	    				} else if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
							_g_arrKlUserType002[userType002][1] = 0 ;
						} else if (klUserType == "007" ){ //합의
							_g_arrKlUserType007[userType007][1] = 0 ;
						}
	    			}
	    		}
	    		
	    		if (approvalInx == rowNum -1) {
	    			$("#isApprovalLast").val("1"); // 합의, 결재 포함했어 최종결재,
	    			_g_isTotalApprovalLast = true ;
	    		}
	    	}
		},
		
		/**********************************************************************************************/
		/***********************************HWP 문서 결재정보입력 *************************************/
		/**********************************************************************************************/
		//hwp 문서에 결재 정보(사인, 최종결재시 문서번호등.) 입력
		setApprovalInfo: function(approvalType, curDate) {

				var signPlace = "" ;
				var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
				var rowNum = objCurrentTabNumber.length ;
				var paramDiStatus =  frmMain.paramDiStatus.value ;
				var pHwpCtrl ;
				var docNum = "" ;
				var riDocNum = "" ;
				var junkyulName = "" ;
				var approvalMD = "";
				var docOpinionYN = $("#docOpinionYN").val();
				var docOpinionName = "" ;
				if(docOpinionYN == "Y") {
					docOpinionName = "의견있음 ";
				}
			  	if(_g_nonElecYN == "Y") { //비전자문서
			  		if(paramDiStatus == "004") return true; //보류는 사인 입력안함.
			  		
					if(_g_isTotalApprovalLast == true ) {
						if(paramDiStatus != "007")  { //반려가 아닐경우만 문서번호 입력
							$("#riDocNum_1").val(riDocNum);
						}
				 		$("#paramLastApprovalSign").val("1");
					}else {
						$("#riDocNum_1").val("");
						$("#paramLastApprovalSign").val("0");	
					}
					
			  	}else { //전자문서
			  		//수정확인
					commonApproval.setHwpModified();
					// 결재라인정보를 hwp 에 설정함.
					commonApproval.setApprovalLineToHwp();
					if(paramDiStatus == "004") return true; //보류는 사인 입력안함.
					var sign = "" ;
					var signType =  frmMain.signType.value ;
					var paramDiStatus = frmMain.paramDiStatus.value ;
					
					if ( signType == "1" ) {
						sign =  _g_userName ;
	
					} else if (signType == "3" ) {
						//sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImage.do?fileSn=0&atchFileId="+frmMain.signID.value ;
	//						sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+frmMain.signID.value ;
						if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2") {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+frmMain.signID.value+"&type=usersign";
						}else {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+frmMain.signID.value ;
						}
						//sign = "http://intrad.kofia.or.kr/gw/images/btn/btn_search.gif";
				 	}else {
						alert("사인 종류를 선택하세요.");
					 	return false;
				 	}
					approvalMD = curDate.substring(5, curDate.length) ;
					approvalMD = ncCom_Replace(approvalMD,'.','/');
					var subRowNum = _g_arrKlUserType002.length ;
					
					for( var inx = 0 ; inx < rowNum; inx++) {
						curTabNumber = parseInt(objCurrentTabNumber[inx].value);
						pHwpCtrl = document.getElementById("HwpCtrl_"+curTabNumber) ;
						
						//결재
						for(var subInx = 0 ; subInx < subRowNum ; subInx++) {
							if ( _g_arrKlUserType002[subInx][1] == 1 ) {
								signPlace = _g_prefixApproval+"approval"+ (subInx+1) ;
								if( _g_arrKlUserType002[subInx][0] == 2 ) { //결재안함.
									_hwpPutText(signPlace, _g_arrKlUserType002[subInx][2], pHwpCtrl);
								}else if ( signType == "1" ) {
									_hwpPutText(signPlace, sign, pHwpCtrl);
								} else if (signType == "3" ) {
									_hwpPutImages(signPlace, sign, pHwpCtrl);
							 	}
	
								if(paramDiStatus == "007")  {
									_hwpPutText(_g_prefixApproval+"approval_opt"+(subInx+1), docOpinionName + "반려", pHwpCtrl);
							 		_hwpPutText("doc_runday", " ", pHwpCtrl);
							 		_hwpPutText("doc_docnum", " " , pHwpCtrl );
							 		break;
								}
								
								if(_g_arrKlUserType002[subInx][0] == 1 ) { //대결이면
									_hwpPutText(_g_prefixApproval+"approval_opt"+(subInx+1), docOpinionName + "대결", pHwpCtrl);
								}
	
							}else if (_g_arrKlUserType002[subInx][1] == -1) { //마지막 결재 처리
								if(subInx > 0 ) {
									if( _g_isApprovalLast == true ) {
										if( _g_arrKlUserType032[subInx-1] == 1) {
											junkyulName = "전결 ";
										}
										if(_g_arrKlUserType002[subInx-1][0] == 1 ) { //대결이면
											_hwpPutText(_g_prefixApproval+"approval_opt"+subInx, docOpinionName  + junkyulName+ " 대결 "+approvalMD, pHwpCtrl);
										}else {
											_hwpPutText(_g_prefixApproval+"approval_opt"+subInx, docOpinionName  + junkyulName+approvalMD, pHwpCtrl);
										}
										
									}else {
										if(_g_arrKlUserType002[subInx-1][0] == 1 ) { //대결이면
											_hwpPutText(_g_prefixApproval+"approval_opt"+subInx, docOpinionName + " " + "대결", pHwpCtrl);
										}
									}
								}
								break;
	
							}
						}
						var agencyNm ="";
						//협조
						for(var subInx = 0 ; subInx < subRowNum ; subInx++) {
							if ( _g_arrKlUserType004[subInx][1] == 1 ) {
								if(_g_arrKlUserType004[subInx][0] == 1 ) agencyNm = "대결";
								else agencyNm = "";
	
								signPlace = _g_prefixApproval+"cooperation"+ (subInx+1) ;
								if(paramDiStatus == "007")  { //반려
									if ( signType == "1" ) {
										_hwpPutText(signPlace, docOpinionName + " " + agencyNm+" 반려"+sign, pHwpCtrl);
	
									} else if (signType == "3" ) {
										_hwpPutImages(signPlace, sign, pHwpCtrl);
										if(pHwpCtrl.FieldExist(signPlace)) pHwpCtrl.PutFieldText(signPlace, agencyNm+"반려");
								 	}
									break;
								}else {
									if( _g_arrKlUserType004[subInx][0] == 2 ) { //결재안함
										_hwpPutText(signPlace, _g_arrKlUserType004[subInx][2], pHwpCtrl);
									
									}else if ( signType == "1" ) {
										_hwpPutText(signPlace, docOpinionName + " " +agencyNm+sign, pHwpCtrl);
	
									} else if (frmMain.signType.value == "3" ) {
										_hwpPutImages(signPlace, docOpinionName + " " +sign, pHwpCtrl);
										if(pHwpCtrl.FieldExist(signPlace)) pHwpCtrl.PutFieldText(signPlace, agencyNm);
								 	}
								}
							}
						}
						agencyNm = "" ;
						//합의
						for(var subInx = 0 ; subInx < subRowNum ; subInx++) {
							if ( _g_arrKlUserType007[subInx][1] == 1 ) {
								if(_g_arrKlUserType007[subInx][0] == 1 ) agencyNm = "대결";
								else agencyNm = "";
	
								signPlace = _g_prefixApproval+"agreement"+ (subInx+1) ;
								if(paramDiStatus == "007")  {
									if ( signType == "1" ) {
										_hwpPutText(signPlace, docOpinionName + " " +agencyNm+" 반려 "+sign, pHwpCtrl);
	
									} else if (signType == "3" ) {
										_hwpPutImages(signPlace, sign, pHwpCtrl);
										if(pHwpCtrl.FieldExist(signPlace))  pHwpCtrl.PutFieldText(signPlace, docOpinionName + " " + agencyNm+" 반려");
								 	}
									break;
								}else {
									if( _g_arrKlUserType007[subInx][0] == 2 ) { //결재안함
										_hwpPutText(signPlace, _g_arrKlUserType007[subInx][2], pHwpCtrl);
									
									}else if ( signType == "1" ) {
										_hwpPutText(signPlace, agencyNm+sign, pHwpCtrl);
	
									} else if (frmMain.signType.value == "3" ) {
										_hwpPutImages(signPlace, sign, pHwpCtrl);
										if(pHwpCtrl.FieldExist(signPlace))  pHwpCtrl.PutFieldText(signPlace, agencyNm);
								 	}
								}
								_hwpPutText(_g_prefixApproval+"agreement_opt"+(subInx+1), approvalMD, pHwpCtrl);
							}
						}
						
						if(_g_isTotalApprovalLast == true ) {
							if(paramDiStatus != "007")  { //반려가 아닐경우만 문서번호 입력
								if(_g_prefixApproval != "r_") {
									//_hwpPutText("doc_docnum", docNum , pHwpCtrl );	
							 		//_hwpPutText("doc_runday", docNum +"( "+ curDate +" )", pHwpCtrl );
							 		//_hwpPutText("approval_date",  curDate , pHwpCtrl );
								}else {
									//접수문서
									//_hwpPutText("doc_acceptday", docNum +"( "+ curDate +" )", pHwpCtrl );
								}
								//$("#riDocNum_"+curTabNumber).val(riDocNum);
							}
					 		$("#paramLastApprovalSign").val("1");
						}else {
							$("#riDocNum_"+curTabNumber).val("");
							$("#paramLastApprovalSign").val("0");	
						}
				 		
					} //end for
					if(_g_isTotalApprovalLast == true )  commonApproval.officialSeal();
			  	}
			return true ;
		},	
		
		/**********************************************************************************************/
		/***********************************내부결재 자동관인삽입 *************************************/
		/**********************************************************************************************/		
	    officialSeal: function() {
	    	var autoInSend = $("#autoInSend").val() ;
	    	if (autoInSend != "Y") return ;
	    	
	    	var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	    	var diSenderCode =  $("#diSenderCode").val(); ;
	    	var hwpRowNum = objCurrentTabNumber.length ;
	    	var hwpCtrl;
	    	var tabNumber = "" ;
	    	var officialSealSign = "" ;
	    	var curTabNumber = "" ;
	    	var selDocTypeCode = "" ;
	    	var curTabNumber = objCurrentTabNumber[0].value ; 
	    	var objDocTypeCode =  document.getElementsByName("docTypeCode_"+curTabNumber) ;
	    	var docTypeRowNum  = objDocTypeCode.length ;
	    	
	    	for(var inx = 0 ; inx < hwpRowNum ; inx++) {
	    		curTabNumber =  objCurrentTabNumber[inx].value ;
	    		selDocTypeCode = "" ;
	    		
	    		if(docTypeRowNum > 1)
	    			selDocTypeCode = $("input[name='docTypeCode_"+curTabNumber+"']:checked").val();
	    		else 
	    			selDocTypeCode = $("#docTypeCode_"+curTabNumber).val();
	    		
	    		if(selDocTypeCode == "001") { //대내문서 
	    			officialSealSign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=officialSeal&diSenderCode="+diSenderCode ;
	    			hwpCtrl = document.getElementById("HwpCtrl_"+curTabNumber) ;
	    			_hwpPutImage("seal", officialSealSign, hwpCtrl);
	    		} 
	    			 
	    	}
	    },
    	
		/***********************************************************************/
		/******접수문서회수, 반려시 문서의 결재정보를 초기화후 다시 서버에 저장*/
		/***********************************************************************/
		initReceiveSign: function () {
			var hwpCtrl = document.getElementById("HwpCtrl_1");
			for(var inx = 1 ; inx <= 16; inx++ ) {
				cooperation = "r_cooperation"+ inx ;
				agreement = "r_agreement"+ inx ;
				approval = "r_approval"+ inx ;
				if(hwpCtrl.FieldExist(cooperation)) {
					_hwpPutText(cooperation, " ", hwpCtrl);
		        }
				if(hwpCtrl.FieldExist(approval)) {
					_hwpPutText(approval, " ", hwpCtrl);
				}
				if(hwpCtrl.FieldExist(agreement)) {
					_hwpPutText(agreement, " ", hwpCtrl);
				}
				if(hwpCtrl.FieldExist("r_approval_opt"+ inx)) {
					_hwpPutText("r_approval_opt"+ inx, " ", hwpCtrl);
				}
	
				if(hwpCtrl.FieldExist("r_agreement_opt"+ inx)) {
					_hwpPutText("r_agreement_opt"+ inx, " ", hwpCtrl);
				}
				if(hwpCtrl.FieldExist("r_approver"+inx)) {
				    _hwpPutText("r_approver"+inx, " ", hwpCtrl);
				}
				if(hwpCtrl.FieldExist("r_cooperate"+inx)) {
				  _hwpPutText("r_cooperate"+inx, " ", hwpCtrl);
				}
				if(hwpCtrl.FieldExist("r_agree"+inx)) {
				  _hwpPutText("r_agree"+inx, " ", hwpCtrl);
				}
			}		    
	
	    	var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
	    	if(arrFileName == false ) return ;
	    	commonApproval.successReceiveRreturnSignUploadFile(arrFileName);
		},	    
	    
		/**************************************************************************************/
		/******모바일 결재후 문서열었을때 결재사인 보정후 다시 서버에 저장*********************/
		/**************************************************************************************/
		setLocalSign : function () {
			var rowNum =  document.getElementsByName("esntlID").length ;
		    var esntlID ;
		    var isSaved ;
		    var klStatus ;
		    var absentFlag ;
		    var viUserKey ;
		    var signID ; 
		    var signFileName = "" ;
		    var viSignFileName = "" ;
		    var totUserType002 = 0 ;
	        var userType002 = 0; //결재 갯수
	        var userType004 = 0; //협의 갯수
	        var userType007 = 0; //합의 갯수
	        var signType = "" ;
	        var userNm = "" ;
	        var returnFlag = "" ;
	        var approvalMD = ""  ;
	        var objKlUserType = document.getElementsByName("klUserType") ;
	        var objKlSignCode = document.getElementsByName("klSignCode") ;
	        var objKlSignDay = document.getElementsByName("klSignDay") ;
	        var objUserNm = document.getElementsByName("userNm") ;
	        var objReturnFlag =  document.getElementsByName("klReturnFlag") ;
	        var objKlSignID =  document.getElementsByName("klSignID") ;
	        var objKlDesideSignID =  document.getElementsByName("klDesideSignID") ;
	        var objKlSignFileName =  document.getElementsByName("klSignFileName") ;
	        var objKlDesideSignFileName =  document.getElementsByName("klDesideSignFileName") ;
	        var objKlDesideUserNm =  document.getElementsByName("klDesideUserNm") ;
	        var objRiDocNum =  document.getElementsByName("riDocNum") ;
	        var objDeptNm =  document.getElementsByName("deptNm") ;
	        var objKlUserProperty032 =  document.getElementsByName("klUserProperty032") ;
	        var objKlUserProperty064 =  document.getElementsByName("klUserProperty064") ;
	        var objKlUserProperty256 =  document.getElementsByName("klUserProperty256") ;
	        var objKlDocOpinionYN =  document.getElementsByName("klDocOpinionYN") ;
	        var klDocOpinionYN = "" ;
	        var klDocOpinionName = "" ;
	        var klUserProperty064 = "" ;
	        var klUserProperty256 = "" ;
	        
	        for(var inx = 0 ; inx < rowNum; inx++ ) {
	            klUserType = objKlUserType[inx].value;
	            
	            if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	                userType002++ ;
	
	            }else if ( klUserType == "004" ){ //협의
	                userType004++;
	
	            }else if (klUserType == "007" ){ //합의
	            	userType007++;
	            }
	        }
	        
	        totUserType002  = userType002 ;
	        var isSign = true ;
	        var signDay = "" ;
	        var subHwpCtrl ;
	        var signPlace = "" ;
	        var isUpload = false ;
	        var isLastApproval = false  ; 
	        
	        var sign = "" ;
	        var junkyulName = "" ;
	        var agencyName = "" ;
	        var absentName = "" ;
	        var klDesideSignID = "" ;
	        var klDesideSignFileName = "";
	        var klDesideUserNm = "" ;
	        var klUserProperty032 = "" ;
	        var docNum = "" ;
	        var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	        var hwpRowNum = objCurrentTabNumber.length ;
	        var hwpCtrl = document.getElementById("HwpCtrl_1") ;
	        var tabNumber = "" ;
		    for(var inx = rowNum-1 ; inx >= 0; inx--) {
		        esntlID = document.getElementsByName("esntlID")[inx].value ;
		        isSaved = document.getElementsByName("isSaved")[inx].value;
		        klStatus = document.getElementsByName("klStatus")[inx].value;
		        absentFlag =  document.getElementsByName("absentFlag")[inx].value;
		        viUserKey =  document.getElementsByName("viUserKey")[inx].value;
		        absentName = document.getElementsByName("absentName")[inx].value;
		        signDay =  objKlSignDay[inx].value;
		        signType =  objKlSignCode[inx].value;
		        userNm =  objUserNm[inx].value;
		        returnFlag =  objReturnFlag[inx].value;
		        signID   =  objKlSignID[inx].value;
		        klDesideUserNm =  objKlDesideUserNm[inx].value;
		        klDesideSignID =  objKlDesideSignID[inx].value;
		        klDesideSignFileName =  objKlDesideSignFileName[inx].value;
		        signFileName   =  objKlSignFileName[inx].value;
		        klUserProperty032 = objKlUserProperty032[inx].value;
		        klUserType = objKlUserType[inx].value;
		        klUserProperty064 = objKlUserProperty064[inx].value;
		        klUserProperty256 = objKlUserProperty256[inx].value;
		        klDocOpinionYN = objKlDocOpinionYN[inx].value;
		        if(klDocOpinionYN == "Y") {
		        	klDocOpinionName = "의견있음 ";
		        }else {
		        	klDocOpinionName = "";
		        }
		        isLastApproval002 = false ;
		        junkyulName = "" ;
		        sign = "" ;
		        agencyName = "" ;
		        approvalMD = "" ;
		        optPlace = "" ;
		        signPlace = "" ;
		        
		        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
		        	signPlace  = _g_prefixApproval+"approval"+userType002 ;
		        	optPlace  = _g_prefixApproval+"approval_opt"+userType002 ;
		        	
		            userType002-- ;
		        	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) { 
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;
			        }
	            
	            }else if ( klUserType == "004" ){ //협조
		        	signPlace  = _g_prefixApproval+"cooperation"+userType004 ;
		        	userType004--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }
	                
	            }else if (klUserType == "007" ){ //합의
	            	signPlace  = _g_prefixApproval+"agreement"+userType007 ;
	            	userType007--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
	            		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }
	            }
		    	
	    		if ( inx == rowNum-1)  {
	    			if (ncCom_Empty(klStatus)) {
	    				isLastApproval = true ;
	    			}
	    		}
	    		else isLastApproval =false ;
		    	
		    	
				if (returnFlag == "1") {
					junkyulName = "반려" ;
				}else if (klUserProperty032 == "032") {
					junkyulName = "전결" ;
				}
				if (signType != "4" && ( !ncCom_Empty(klDesideUserNm) || klUserProperty256 == "256" )) { //대결 
					if(signType =="1") {
						sign = klDesideUserNm ;
					}else {
						if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2") {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+klDesideSignFileName+"&type=usersign";
						}else {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+klDesideSignID ;
						}
					}
					agencyName = "대결 " ;
				}else {
					if(signType == "4") {
						sign = absentName ;
					}else if(signType =="1") {
						sign = userNm ;
					}else {
						if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2" ) {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+signFileName+"&type=usersign";
						}else {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+signID ;
						}
					}	        				
				}
				if( totUserType002 == userType002 + 1 ) { //속성이 결재인 회원들중에서최종결재
					if(ncCom_Empty(klStatus)) {
						approvalMD = signDay.substring(4,signDay.length) ;
						approvalMD = approvalMD.substring(0,2) +"/" + approvalMD.substring(2,4) ;
					}
				}
				
				signDay = ncCom_Date(signDay, '.') ; 
				isUpload = true ;
				for(var subInx = 0 ; subInx < hwpRowNum;  subInx++ ) {
					tabNumber = objCurrentTabNumber[subInx].value ;
					subHwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
			        if (isLastApproval == true ) {
			        	docNum = objDeptNm[0].value + "-" +  $("#riDocNum_"+tabNumber).val() ;
			        	if(_g_receiveYN == "Y" || _g_prefixApproval == "r_") {
			        		_hwpPutText("doc_acceptday", docNum +"( "+ signDay +" )", subHwpCtrl );
			        	}else {
			        		
			        		_hwpPutText("doc_docnum", docNum , subHwpCtrl );	
					 		_hwpPutText("doc_runday", docNum +"( "+ signDay +" )", subHwpCtrl );
					 		_hwpPutText("approval_date",  signDay , subHwpCtrl );		
			        	}
			        }
			        
			        var textValue = _hwpMultiLineFieldText(subHwpCtrl, optPlace);
			        var optTxt = klDocOpinionName+junkyulName+agencyName+approvalMD ;
			        if( !ncCom_Empty(optTxt) && ncCom_Trim(optTxt) != ncCom_Trim(textValue) ) {
			        	_hwpPutText(optPlace, optTxt, subHwpCtrl);
			        	isUpload = true ;
			        }
			        if( isSign == false  ) {
				        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, sign, subHwpCtrl);
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
						 	}
				        }else {	
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, klDocOpinionName+agencyName+junkyulName+sign, subHwpCtrl);
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
								if(subHwpCtrl.FieldExist(signPlace)) subHwpCtrl.PutFieldText(signPlace, klDocOpinionName+agencyName+junkyulName);
						 	}
				        }
			        }
				}
		    }

		    if(isLastApproval == false) {
		    	if( commonApproval.setFinalDocNumber() == true ) {
		    		isUpload = true ;
		    	}
		    }
	    
		    if(isUpload ) {
	
		    	var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
		    	if(arrFileName == false ) return ;
		    	commonApproval.successDocApprovalSignUploadFile(arrFileName);
		    }
		    
		},
		/**************************************************************************************/
		/******최종결재후 문서열었을때및 보정후 다시 서버에 저장*********************/
		/**************************************************************************************/
		setLastApprovalLocal : function () {
			var rowNum =  document.getElementsByName("esntlID").length ;
		    var esntlID ;
		    var isSaved ;
		    var klStatus ;
		    var absentFlag ;
		    var viUserKey ;
		    var signID ; 
		    var signFileName = "" ;
		    var viSignFileName = "" ;		    
		    var totUserType002 = 0 ;
	        var userType002 = 0; //결재 갯수
	        var userType004 = 0; //협의 갯수
	        var userType007 = 0; //합의 갯수
	        var signType = "" ;
	        var userNm = "" ;
	        var returnFlag = "" ;
	        var approvalMD = ""  ;
	        var objKlUserType = document.getElementsByName("klUserType") ;
	        var objKlSignCode = document.getElementsByName("klSignCode") ;
	        var objKlSignDay = document.getElementsByName("klSignDay") ;
	        var objUserNm = document.getElementsByName("userNm") ;
	        var objReturnFlag =  document.getElementsByName("klReturnFlag") ;
	        var objKlSignID =  document.getElementsByName("klSignID") ;
	        var objKlDesideSignID =  document.getElementsByName("klDesideSignID") ;
	        var objKlDesideSignFileName =  document.getElementsByName("klDesideSignFileName") ;
	        var objKlDesideUserNm =  document.getElementsByName("klDesideUserNm") ;
	        var objRiDocNum =  document.getElementsByName("riDocNum") ;
	        var objDeptNm =  document.getElementsByName("deptNm") ;
	        var objKlUserProperty032 =  document.getElementsByName("klUserProperty032") ;
	        var objKlUserProperty064 =  document.getElementsByName("klUserProperty064") ;
	        var objKlUserProperty256 =  document.getElementsByName("klUserProperty256") ;
	        var objKlSignFileName =  document.getElementsByName("klSignFileName") ;
	        var objKlDocOpinionYN =  document.getElementsByName("klDocOpinionYN") ;
	        var klUserProperty064 = "" ;
	        var klUserProperty256 = "" ;
	        
	        for(var inx = 0 ; inx < rowNum; inx++ ) {
	            klUserType = objKlUserType[inx].value;
	            
	            if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	                userType002++ ;
	
	            }else if ( klUserType == "004" ){ //협의
	                userType004++;
	
	            }else if (klUserType == "007" ){ //합의
	            	userType007++;
	            }
	        }
	        
	        totUserType002  = userType002 ;
	        var isSign = true ;
	        var signDay = "" ;
	        var subHwpCtrl ;
	        var signPlace = "" ;
	        var isUpload = false ;
	        var isLastApproval = false  ; 
	        
	        var sign = "" ;
	        var junkyulName = "" ;
	        var agencyName = "" ;
	        var absentName = "" ;
	        var viSignID = "" ;
	        var klDesideSignID = "" ;
	        var klDesideSignFileName = "";
	        var klDesideUserNm = "" ;
	        var klUserProperty032 = "" ;
	        var klDocOpinionYN = "" ;
	        var klDocOpinionName = "" ;
	        var docNum = "" ;
	        var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	        var hwpRowNum = objCurrentTabNumber.length ;
	        var hwpCtrl = document.getElementById("HwpCtrl_1") ;
	        var tabNumber = "" ;
		    for(var inx = rowNum-1 ; inx >= 0; inx--) {
		        esntlID = document.getElementsByName("esntlID")[inx].value ;
		        isSaved = document.getElementsByName("isSaved")[inx].value;
		        klStatus = document.getElementsByName("klStatus")[inx].value;
		        absentFlag =  document.getElementsByName("absentFlag")[inx].value;
		        viUserKey =  document.getElementsByName("viUserKey")[inx].value;
		        absentName = document.getElementsByName("absentName")[inx].value;
		        signDay =  objKlSignDay[inx].value;
		        signType =  objKlSignCode[inx].value;
		        userNm =  objUserNm[inx].value;
		        returnFlag =  objReturnFlag[inx].value;
		        signID   =  objKlSignID[inx].value;
		        klDesideUserNm =  objKlDesideUserNm[inx].value;
		        
		        klDesideSignID =  objKlDesideSignID[inx].value;
		        klDesideSignFileName =  objKlDesideSignFileName[inx].value;
		        signFileName   =  objKlSignFileName[inx].value;
		        klUserProperty032 = objKlUserProperty032[inx].value;
		        klUserType = objKlUserType[inx].value;
		        klUserProperty064 = objKlUserProperty064[inx].value;
		        klUserProperty256 = objKlUserProperty256[inx].value;
		        klDocOpinionYN = objKlDocOpinionYN[inx].value;
		        isLastApproval002 = false ;
		        isSign = false ;
		        junkyulName = "" ;
		        sign = "" ;
		        agencyName = "" ;
		        approvalMD = "" ;
		        optPlace = "" ;
		        signPlace = "" ;
		        if(klDocOpinionYN == "Y") {
		        	klDocOpinionName = "의견있음 ";
		        }else {
		        	klDocOpinionName = "";
		        }
		        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
		        	signPlace  = _g_prefixApproval+"approval"+userType002 ;
		        	optPlace  = _g_prefixApproval+"approval_opt"+userType002 ;
		        	
		            userType002-- ;
		        	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) { 
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;
			        }else {
			        	continue ;
			        }
	            
	            }else if ( klUserType == "004" ){ //협조
		        	signPlace  = _g_prefixApproval+"cooperation"+userType004 ;
		        	userType004--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }else {
	    	        	continue ;
	    	        }
	                
	            }else if (klUserType == "007" ){ //합의
	            	signPlace  = _g_prefixApproval+"agreement"+userType007 ;
	            	userType007--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
	            		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }else {
	    	        	continue ;
	    	        }
	            }
		        
		        //기안문서에 사인이 있으면 종료한다.
		    	//if(isSign == true ) break; 
		    	
	    		if ( inx == rowNum-1) isLastApproval = true ;
	    		else isLastApproval =false ;
		    	
		    //	if( isSign == false  ) {
					if (returnFlag == "1") {
						junkyulName = "반려" ;
					}else if (klUserProperty032 == "032") {
						junkyulName = "전결 " ;
					}
					if (signType != "4" && ( !ncCom_Empty(klDesideUserNm) || klUserProperty256 == "256" ) ) { //대결 
						if(signType =="1") {
							sign = klDesideUserNm ;
						}else {
							if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2") {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+klDesideSignFileName+"&type=usersign";
							}else {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+klDesideSignID ;
							}
						}
						agencyName = "대결 " ;
					}else {
						if(signType == "4") {
							sign = absentName ;
						}else if(signType =="1") {
							sign = userNm ;
						}else {
							if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2" ) {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+signFileName+"&type=usersign";
							}else {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+signID ;
							}
						}	        				
					}
		    //	}
				
				if( totUserType002 == userType002 + 1 ) { //속성이 결재인 회원들중에서최종결재
					approvalMD = signDay.substring(4,signDay.length) ;
					approvalMD = approvalMD.substring(0,2) +"/" + approvalMD.substring(2,4) ;
				}
				signDay = ncCom_Date(signDay, '.') ; 
				
				for(var subInx = 0 ; subInx < hwpRowNum;  subInx++ ) {
					tabNumber = objCurrentTabNumber[subInx].value ;
					subHwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
			        if (isLastApproval == true ) {
			        	docNum = objDeptNm[0].value + "-" +  $("#riDocNum_"+tabNumber).val() ;
			        	if(_g_receiveYN == "Y" || _g_prefixApproval == "r_") {
			        		_hwpPutText("doc_acceptday", docNum +"( "+ signDay +" )", subHwpCtrl );
			        	}else {
			        		_hwpPutText("doc_docnum", docNum , subHwpCtrl );	
					 		_hwpPutText("doc_runday", docNum +"( "+ signDay +" )", subHwpCtrl );
					 		_hwpPutText("approval_date",  signDay , subHwpCtrl );		
			        	}
			        	isUpload = true ;
			        }
			        var textValue = _hwpMultiLineFieldText(subHwpCtrl, optPlace);
			        var optTxt = klDocOpinionName+junkyulName+agencyName+approvalMD ;
			        if( !ncCom_Empty(optTxt) && ncCom_Trim(optTxt) != ncCom_Trim(textValue) ) {
			        	_hwpPutText(optPlace, optTxt, subHwpCtrl);
			        	isUpload = true ;
			        }
			        if( isSign == false  ) {
				        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, sign, subHwpCtrl);
				
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
						 	}
				        }else {	
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, klDocOpinionName+agencyName+junkyulName+sign, subHwpCtrl);
				
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
								if(subHwpCtrl.FieldExist(signPlace)) subHwpCtrl.PutFieldText(signPlace, klDocOpinionName+agencyName+junkyulName);
						 	}
				        }
				        isUpload = true ;
			        }
				}
		    }
		    if(isLastApproval == false) {
		    	if( commonApproval.setFinalDocNumber() == true ) {
		    		isUpload = true ;
		    	}
		    }
		    if(isUpload ) {
	
		    	var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
		    	if(arrFileName == false ) return ;
		    	commonApproval.successFinalDocApprovalUploadFile(arrFileName);
		    }
		},
		
		/**************************************************************************************/
		/******최종결재후 수신처로 자동발송했을경우 문서열었을때및 보정후 다시 서버에 저장*********************/
		/**************************************************************************************/
		setReceiveLastApprovalLocal : function () {
			var rowNum =  document.getElementsByName("send_esntlID").length ;
		    var esntlID ;
		    var isSaved ;
		    var klStatus ;
		    var absentFlag ;
		    var viUserKey ;
		    var signID ; 
		    var signFileName = "" ;
		    var viSignFileName = "" ;			    
		    var totUserType002 = 0 ;
	        var userType002 = 0; //결재 갯수
	        var userType004 = 0; //협의 갯수
	        var userType007 = 0; //합의 갯수
	        var signType = "" ;
	        var userNm = "" ;
	        var returnFlag = "" ;
	        var approvalMD = ""  ;
	        var objKlUserType = document.getElementsByName("send_klUserType") ;
	        var objKlSignCode = document.getElementsByName("send_klSignCode") ;
	        var objKlSignDay = document.getElementsByName("send_klSignDay") ;
	        var objUserNm = document.getElementsByName("send_userNm") ;
	        var objReturnFlag =  document.getElementsByName("send_klReturnFlag") ;
	        var objKlSignID =  document.getElementsByName("send_klSignID") ;
	        var objVISignID =  document.getElementsByName("send_viSignID") ;
	        var objVIUserNm =  document.getElementsByName("send_viUserNm") ;
	        var objRiDocNum =  document.getElementsByName("send_riDocNum") ;
	        var objDeptNm =  document.getElementsByName("send_deptNm") ;
	        var objKlUserProperty032 =  document.getElementsByName("send_klUserProperty032") ;
	        var objKlUserProperty064 =  document.getElementsByName("send_klUserProperty064") ;
	        var objKlUserProperty256 =  document.getElementsByName("send_klUserProperty256") ;
	        var objKlSignFileName =  document.getElementsByName("send_klSignFileName") ;
	        var objVISignFileName =  document.getElementsByName("send_viSignFileName") ;
	        var objKlDesideSignID =  document.getElementsByName("send_klDesideSignID") ;
	        var objKlDesideSignFileName =  document.getElementsByName("send_klDesideSignFileName") ;
	        var objKlDesideUserNm =  document.getElementsByName("send_klDesideUserNm") ;
	        var objKlDocOpinionYN =  document.getElementsByName("send_klDocOpinionYN") ;
	        var klUserProperty064 = "" ;
	        var klUserProperty256 = "" ;
	        var klDocOpinionYN = "" ;
	        var klDocOpinionName = "" ;
	        for(var inx = 0 ; inx < rowNum; inx++ ) {
	            klUserType = objKlUserType[inx].value;
	            
	            if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	                userType002++ ;
	
	            }else if ( klUserType == "004" ){ //협의
	                userType004++;
	
	            }else if (klUserType == "007" ){ //합의
	            	userType007++;
	            }
	        }
	        
	        totUserType002  = userType002 ;
	        var isSign = true ;
	        var signDay = "" ;
	        var subHwpCtrl ;
	        var signPlace = "" ;
	        var isUpload = false ;
	        var isLastApproval = false  ; 
	        
	        var sign = "" ;
	        var junkyulName = "" ;
	        var agencyName = "" ;
	        var absentName = "" ;
	        var viSignID = "" ;
	        var viUserNm = "" ;
	        var klUserProperty032 = "" ;
	        var docNum = "" ;
	        
	        var klDesideSignID = "" ;
	        var klDesideSignFileName = "";
	        var klDesideUserNm = "" ;
	        
	        var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	        var hwpRowNum = objCurrentTabNumber.length ;
	        var hwpCtrl = document.getElementById("HwpCtrl_1") ;
	        var tabNumber = "" ;
		    for(var inx = rowNum-1 ; inx >= 0; inx--) {
		        esntlID = document.getElementsByName("send_esntlID")[inx].value ;
		        isSaved = document.getElementsByName("send_isSaved")[inx].value;
		        klStatus = document.getElementsByName("send_klStatus")[inx].value;
		        absentFlag =  document.getElementsByName("send_absentFlag")[inx].value;
		        viUserKey =  document.getElementsByName("send_viUserKey")[inx].value;
		        absentName = document.getElementsByName("send_absentName")[inx].value;
		        signDay =  objKlSignDay[inx].value;
		        signType =  objKlSignCode[inx].value;
		        userNm =  objUserNm[inx].value;
		        returnFlag =  objReturnFlag[inx].value;
		        signID   =  objKlSignID[inx].value;
		        viUserNm =  objVIUserNm[inx].value;
		        viSignID =  objVISignID[inx].value;
		        signFileName   =  objKlSignFileName[inx].value;
		        viSignFileName =  objVISignFileName[inx].value;		        
		        klUserProperty032 = objKlUserProperty032[inx].value;
		        klUserType = objKlUserType[inx].value;
		        klUserProperty064 = objKlUserProperty064[inx].value;
		        klUserProperty256 = objKlUserProperty256[inx].value;
		        klDesideUserNm =  objKlDesideUserNm[inx].value;
		        klDesideSignID =  objKlDesideSignID[inx].value;
		        klDesideSignFileName =  objKlDesideSignFileName[inx].value;
		        klDocOpinionYN = objKlDocOpinionYN[inx].value;
		        
		        if(klDocOpinionYN == "Y") {
		        	klDocOpinionName = "의견있음 ";
		        }else {
		        	klDocOpinionName = "";
		        }
		        
		        isLastApproval002 = false ;
		        junkyulName = "" ;
		        sign = "" ;
		        agencyName = "" ;
		        approvalMD = "" ;
		        optPlace = "" ;
		        signPlace = "" ;
		        
		        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
		        	signPlace  = "approval"+userType002 ;
		        	optPlace  = "approval_opt"+userType002 ;
		        	
		            userType002-- ;
		        	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) { 
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;
			        }else {
			        	continue ;
			        }
	            
	            }else if ( klUserType == "004" ){ //협조
		        	signPlace  =  "cooperation"+userType004 ;
		        	userType004--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }else {
	    	        	continue ;
	    	        }
	                
	            }else if (klUserType == "007" ){ //합의
	            	signPlace  = "agreement"+userType007 ;
	            	userType007--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
	            		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }else {
	    	        	continue ;
	    	        }
	            }
		        
		        //기안문서에 사인이 있으면 종료한다.
		    	//if(isSign == true ) break; 
		    	
	    		if ( inx == rowNum-1) isLastApproval = true ;
	    		else isLastApproval =false ;
		    	
		    //	if( isSign == false  ) {
					if (returnFlag == "1") {
						junkyulName = "반려" ;
					}else if (klUserProperty032 == "032") {
						junkyulName = "전결 " ;
					}
					if ( signType != "4" && ( !ncCom_Empty(klDesideUserNm) || klUserProperty256 == "265" ) ) { //대결 
						if(signType =="1") {
							sign = klDesideUserNm ;
						}else {
							if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2") {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+klDesideSignFileName+"&type=usersign";
							}else {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+klDesideSignID ;
							}
						}
						agencyName = "대결 " ;
					}else {
						if(signType == "4") {
							sign = absentName ;
						}else if(signType =="1") {
							sign = userNm ;
						}else {
							if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2" ) {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+signFileName+"&type=usersign";
							}else {
								sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+signID ;
							}
						}	        				
					}
		    //	}
		    	
				if( totUserType002 == userType002 + 1 ) { //속성이 결재인 회원들중에서최종결재
					approvalMD = signDay.substring(4,signDay.length) ;
					approvalMD = approvalMD.substring(0,2) +"/" + approvalMD.substring(2,4) ;
				}
				signDay = ncCom_Date(signDay, '.') ; 
		
				for(var subInx = 0 ; subInx < hwpRowNum;  subInx++ ) {
					tabNumber = objCurrentTabNumber[subInx].value ;
					subHwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
			        if (isLastApproval == true ) {
			        	docNum = objDeptNm[0].value + "-" +  $("#send_riDocNum_"+tabNumber).val() ;
		
		        		_hwpPutText("doc_docnum", docNum , subHwpCtrl );	
				 		_hwpPutText("doc_runday", docNum +"( "+ signDay +" )", subHwpCtrl );
				 		_hwpPutText("approval_date",  signDay , subHwpCtrl );		
						isUpload = true ;
					
			        }
			        
			        var textValue = _hwpMultiLineFieldText(subHwpCtrl, optPlace);
			        var optTxt = klDocOpinionName+junkyulName+agencyName+approvalMD ;
			        if( !ncCom_Empty(optTxt) && ncCom_Trim(optTxt) != ncCom_Trim(textValue) ) {
			        	_hwpPutText(optPlace, optTxt, subHwpCtrl);
			        	isUpload = true ;
			        }
			        
			        if( isSign == false  ) {
				        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, sign, subHwpCtrl);
				
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
						 	}
				        }else {	
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, klDocOpinionName+agencyName+junkyulName+sign, subHwpCtrl);
				
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
								if(subHwpCtrl.FieldExist(signPlace)) subHwpCtrl.PutFieldText(signPlace, klDocOpinionName+agencyName+junkyulName);
						 	}
				        }
				        isUpload = true ;
			        }
				}
		    }
		    if(isLastApproval == false) {
		    	if( commonApproval.setFinalDocNumber("send_") == true ) {
		    		isUpload = true ;
		    	}
		    }
		    if(isUpload ) {
		    	var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
		    	if(arrFileName == false ) return ;
		    	commonApproval.successReceiveFinalDocApprovalUploadFile(arrFileName);
		    }
		},	
		
		/**************************************************************************************/
		/******결재후 다시 기안문서를 열었을경우  결재했는데  한글코드에 결재사인이 없으면 입력후 등록*********************/
		/**************************************************************************************/
		setApprovalRevisition : function () {
			var rowNum =  document.getElementsByName("esntlID").length ;
		    var esntlID ;
		    var isSaved ;
		    var klStatus ;
		    var absentFlag ;
		    var viUserKey ;
		    var signID ; 
		    var signFileName = "" ;
		    var viSignFileName = "" ;		    
		    var totUserType002 = 0 ;
	        var userType002 = 0; //결재 갯수
	        var userType004 = 0; //협의 갯수
	        var userType007 = 0; //합의 갯수
	        var signType = "" ;
	        var userNm = "" ;
	        var returnFlag = "" ;
	        var approvalMD = ""  ;
	        var objKlUserType = document.getElementsByName("klUserType") ;
	        var objKlSignCode = document.getElementsByName("klSignCode") ;
	        var objKlSignDay = document.getElementsByName("klSignDay") ;
	        var objUserNm = document.getElementsByName("userNm") ;
	        var objReturnFlag =  document.getElementsByName("klReturnFlag") ;
	        var objKlSignID =  document.getElementsByName("klSignID") ;
	        var objVISignID =  document.getElementsByName("viSignID") ;
	        var objVIUserNm =  document.getElementsByName("viUserNm") ;
	        var objRiDocNum =  document.getElementsByName("riDocNum") ;
	        var objDeptNm =  document.getElementsByName("deptNm") ;
	        var objKlUserProperty032 =  document.getElementsByName("klUserProperty032") ;
	        var objKlUserProperty064 =  document.getElementsByName("klUserProperty064") ;
	        var objKlUserProperty256 =  document.getElementsByName("klUserProperty256") ;
	        var objKlSignFileName =  document.getElementsByName("klSignFileName") ;
	        var objVISignFileName =  document.getElementsByName("viSignFileName") ;	  
	        var objKlDesideSignID =  document.getElementsByName("klDesideSignID") ;
	        var objKlDesideSignFileName =  document.getElementsByName("klDesideSignFileName") ;
	        var objKlDesideUserNm =  document.getElementsByName("klDesideUserNm") ;
	        var objKlDocOpinionYN =  document.getElementsByName("klDocOpinionYN") ;
	        var klUserProperty064 = "" ;
	        var klUserProperty256 = "" ;
	        var klDocOpinionYN = "" ;
	        var klDocOpinionName = "" ;
	        for(var inx = 0 ; inx < rowNum; inx++ ) {
	            klUserType = objKlUserType[inx].value;
	            
	            if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
	                userType002++ ;
	
	            }else if ( klUserType == "004" ){ //협의
	                userType004++;
	
	            }else if (klUserType == "007" ){ //합의
	            	userType007++;
	            }
	        }
	        
	        totUserType002  = userType002 ;
	        var isSign = true ;
	        var signDay = "" ;
	        var subHwpCtrl ;
	        var signPlace = "" ;
	        var isUpload = false ;
	        var isLastApproval = false  ; 
	        
	        var sign = "" ;
	        var junkyulName = "" ;
	        var agencyName = "" ;
	        var absentName = "" ;
	        var viSignID = "" ;
	        var viUserNm = "" ;
	        var klUserProperty032 = "" ;
	        var docNum = "" ;
	        
	        var klDesideSignID = "" ;
	        var klDesideSignFileName = "";
	        var klDesideUserNm = "" ;
	        
	        var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	        var hwpRowNum = objCurrentTabNumber.length ;
	        var hwpCtrl = document.getElementById("HwpCtrl_1") ;
	        var tabNumber = "" ;
		    for(var inx = rowNum-1 ; inx >= 0; inx--) {
		        esntlID = document.getElementsByName("esntlID")[inx].value ;
		        isSaved = document.getElementsByName("isSaved")[inx].value;
		        klStatus = document.getElementsByName("klStatus")[inx].value;
		        absentFlag =  document.getElementsByName("absentFlag")[inx].value;
		        viUserKey =  document.getElementsByName("viUserKey")[inx].value;
		        absentName = document.getElementsByName("absentName")[inx].value;
		        signDay =  objKlSignDay[inx].value;
		        signType =  objKlSignCode[inx].value;
		        userNm =  objUserNm[inx].value;
		        returnFlag =  objReturnFlag[inx].value;
		        signID   =  objKlSignID[inx].value;
		        viUserNm =  objVIUserNm[inx].value;
		        viSignID =  objVISignID[inx].value;
		        signFileName   =  objKlSignFileName[inx].value;
		        viSignFileName =  objVISignFileName[inx].value;
		        klUserProperty032 = objKlUserProperty032[inx].value;
		        klUserType = objKlUserType[inx].value;
		        klUserProperty064 = objKlUserProperty064[inx].value;
		        klUserProperty256 = objKlUserProperty256[inx].value;
		        klDesideUserNm =  objKlDesideUserNm[inx].value;
		        klDesideSignID =  objKlDesideSignID[inx].value;
		        klDesideSignFileName =  objKlDesideSignFileName[inx].value;
		        
		        klDocOpinionYN = objKlDocOpinionYN[inx].value;
		        
		        if(klDocOpinionYN == "Y") {
		        	klDocOpinionName = "의견있음 ";
		        }else {
		        	klDocOpinionName = "";
		        }
		
		        isLastApproval002 = false ;
		        isSign = false ;
		        junkyulName = "" ;
		        sign = "" ;
		        agencyName = "" ;
		        approvalMD = "" ;
		        optPlace = "" ;
		        signPlace = "" ;
		        
		        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
		        	signPlace  = _g_prefixApproval+"approval"+userType002 ;
		        	optPlace  = _g_prefixApproval+"approval_opt"+userType002 ;
		        	
		            userType002-- ;
		        	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) { 
		        		if( !hwpCtrl.FieldExist(signPlace )) continue;
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;
			        }else {
			        	continue ;
			        }
	            
	            }else if ( klUserType == "004" ){ //협조
		        	signPlace  = _g_prefixApproval+"cooperation"+userType004 ;
		        	userType004--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
	            		if( !hwpCtrl.FieldExist(signPlace )) continue;
		        		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }else {
	    	        	continue ;
	    	        }
	                
	            }else if (klUserType == "007" ){ //합의
	            	signPlace  = _g_prefixApproval+"agreement"+userType007 ;
	            	userType007--;
	            	if(  ncCom_Empty(klStatus ) && isSaved == "1"  ) {
	            		if( !hwpCtrl.FieldExist(signPlace )) continue;
	            		isSign = commonApproval.isHwpText(hwpCtrl, signPlace ) ;
		        		if( isSign == false ) isSign = commonApproval.isHwpImg(hwpCtrl, signPlace) ;	
	    	        }else {
	    	        	continue ;
	    	        }
	            }
		        //기안문서에 사인이 있으면 종료한다.
		    	//if(isSign == true ) break; 
		    	
	    		if ( inx == rowNum-1) isLastApproval = true ;
	    		else isLastApproval =false ;
		    	
//		    	if( isSign == false  ) {
				if (returnFlag == "1") {
					junkyulName = "반려" ;
				}else if (klUserProperty032 == "032") {
					junkyulName = "전결 " ;
				}
				if (signType != "4" && ( !ncCom_Empty(klDesideUserNm) || klUserProperty256 == "256" ) ) { //대결 
					if(signType =="1") {
						sign = klDesideUserNm ;
					}else {
						if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2") {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+klDesideSignFileName+"&type=usersign";
						}else {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+klDesideSignID ;
						}
					}
					agencyName = "대결 " ;
				}else {
					if(signType == "4") {
						sign = absentName ;
					}else if(signType =="1") {
						sign = userNm ;
					}else {
						if(_g_compayCD == "10014" || _g_compayCD == "10022" || _g_compayCD == "10015" || _g_approvalImgMethodType == "2" ) {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+signFileName+"&type=usersign";
						}else {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+signID ;
						}
					}	        				
				}
//		    	}
		    	
				if( totUserType002 == userType002 + 1 ) { //속성이 결재인 회원들중에서최종결재
					approvalMD = signDay.substring(4,signDay.length) ;
					approvalMD = approvalMD.substring(0,2) +"/" + approvalMD.substring(2,4) ;
				}
				signDay = ncCom_Date(signDay, '.') ; 
				
				for(var subInx = 0 ; subInx < hwpRowNum;  subInx++ ) {
					tabNumber = objCurrentTabNumber[subInx].value ;
					subHwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
			        if( !ncCom_Empty(optPlace) && subHwpCtrl.FieldExist(optPlace )){
				        var textValue = _hwpMultiLineFieldText(subHwpCtrl, optPlace);
				        var optTxt = klDocOpinionName+junkyulName+agencyName+approvalMD ;
				        if(  ncCom_Trim(optTxt) != ncCom_Trim(textValue) ) {
				        	if (ncCom_Empty(optTxt) ) {
				        		optTxt = " ";
				        	}
				        	_hwpPutText(optPlace, optTxt, subHwpCtrl);
				        	isUpload = true ;
				        }
					}
			        if( isSign == false ) {
				        if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, sign, subHwpCtrl);
				
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
						 	}
				        }else {	
							if ( signType == "1" || signType == "4" ) {
								_hwpPutText(signPlace, klDocOpinionName+agencyName+junkyulName+sign, subHwpCtrl);
				
							} else if (signType == "3" ) {
								_hwpPutImages(signPlace, sign, subHwpCtrl);
								if(subHwpCtrl.FieldExist(signPlace)) subHwpCtrl.PutFieldText(signPlace, klDocOpinionName+agencyName+junkyulName);
						 	}
				        }
				        isUpload = true ;
			        }
					subHwpCtrl.MovePos(2);
				}
		    }
		    
		 
	    	if( commonApproval.setFinalDocNumber() == true ) {
	    		isUpload = true ;
	    	}
		    if(isUpload ) {
		    	var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
		    	if(arrFileName == false ) return ;
		    	commonApproval.successRevisitionDocApprovalUploadFile(arrFileName);
		    }
		},
		getNumber:function(arg) {
			return arg.trim().replace(/[^0-9]/g,"");
		},
		setFinalDocNumber:function(docPrefix) {
		    var hwpDocAcceptDayNumber = "" ;
		    var riDocNum = "" ;
		    var riDocFullNumber = "" ;
		    var tempNumber = 0;
		    var riDocSignDay = "" ;
		    var riDocDeptNumber = "" ;
		    var hwpDocFullNumber = "" ;
		    var hwpDocNum = "" ;
		    var hwpLastSignDay = "" ;
		    var tabNumber ;
		    var isUpload = false ;
	        var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	        var rowNum = objCurrentTabNumber.length ;
	        var hwpCtrl;
	        if(ncCom_Empty(docPrefix)) {
	        	docPrefix = "" ;
	        }
		    for(var inx = 0 ; inx < rowNum;  inx++ ) {
		    	tabNumber = objCurrentTabNumber[inx].value ;
		    	hwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
		    	hwpDocAcceptDayNumber = 0 ;
		    	tempNumber = 0 ;
		    	
		    	try {
		    		riDocNum = $("#"+docPrefix+"riDocNum_"+tabNumber).val() ;
		    		riDocFullNumber = $("#"+docPrefix+"riDocFullNum_"+tabNumber).val() ;
		    		riDocDeptNumber = $("#"+docPrefix+"riDocDeptNum_"+tabNumber).val() ;
		    		riDocSignDay = $("#"+docPrefix+"riDocSignDay_"+tabNumber).val() ;
		    		
		    		if(ncCom_Empty(riDocNum)) {
		    			break; ;
		    		}
		    		hwpDocFullNumber = "" ;
		    		hwpDocNum = "" ;
		    		hwpLastSignDay = "" ;
		    		
		    		if(_g_receiveYN == "Y" || _g_prefixApproval == "r_") {
		    			hwpDocFullNumber = _hwpMultiLineFieldText(hwpCtrl, "doc_acceptday");
		    		}else {
		    			hwpDocFullNumber = _hwpMultiLineFieldText(hwpCtrl, "doc_runday"); 
		    			if( hwpCtrl.FieldExist("doc_docnum" )) {
		    				hwpDocNum = _hwpMultiLineFieldText(hwpCtrl, "doc_docnum");
		    			}
		    			if( hwpCtrl.FieldExist("approval_date" )) {
		    				hwpLastSignDay = _hwpMultiLineFieldText(hwpCtrl, "approval_date");
		    			}
		    			
		    		}
		    	
		    		if( !ncCom_Empty(hwpDocFullNumber) ) {
			    		 hwpDocAcceptDayNumber = commonApproval.getNumber(hwpDocFullNumber.split('-')[1]) ;
			    	}
		    		 
		    		tempNumber = commonApproval.getNumber(riDocFullNumber.split('-')[1]) ;
		    		
		    		if(_g_receiveYN == "Y" || _g_prefixApproval == "r_") {
		    			if( hwpCtrl.FieldExist("doc_acceptday" )) {
			    			if(tempNumber != hwpDocAcceptDayNumber ) {
				    			_hwpPutText("doc_acceptday", riDocFullNumber, hwpCtrl );
				    			isUpload = true ;
			    			}
		    			}
		    		}else {
		    			if( hwpCtrl.FieldExist("doc_runday" )) {
			    			if(tempNumber != hwpDocAcceptDayNumber ) {
				    			_hwpPutText("doc_runday", riDocFullNumber, hwpCtrl );
				    			isUpload = true ;
							}
		    			}
		    			if( hwpCtrl.FieldExist("doc_docnum" )) {
		    				if(ncCom_Empty(hwpDocNum) || hwpDocNum != riDocDeptNumber ) {
		    					hwpCtrl.PutFieldText("doc_docnum", riDocDeptNumber);
		    					isUpload = true ;
		    				}
		    			}
		    			if( hwpCtrl.FieldExist("approval_date" )) {
		    				if(ncCom_Empty(hwpLastSignDay) || hwpLastSignDay !=  riDocSignDay ) {
		    					hwpCtrl.PutFieldText("approval_date", riDocSignDay);
		    					isUpload = true ;
		    				}
		    			}
		    		}
		    		hwpCtrl.MovePos(2);
		    	}catch(e){
		    	console.log(e);//오류 상황 대응 부재
		    	}
	        		
	        }
		    return isUpload ;
		},
	/**
	 * 
	 * @param siReceiveCode : 수신처코드(구분자 )
	 * @param siReceiveName : 부서명 (구분자 )
	 * @param siSenderName  : 발신인명 (구분자 )
	 * @param siReceiveUserName :참조자 (구분자 )
	 * @param tabNumber : (tabNumber : 일괄기안일경우 수신처를 셋팅해야하는 문서 tabnumber )
	 * @desc siReceiveCode, siReceiveName, siSenderName, siReceiveUserName 갯수가 맞아야함
	 */
	//수신자 셋팅
	setReceive:function(siReceiveCode, siReceiveName, siSenderName, siReceiveUserName, tabNumber) {
		var arrSiReceiveCode ;
		var arrSiReceiveName ;
		var arrSenderName ;
		var arrSiReceiveUserName ;
		var rowNum = 0 ;
		var receiveNameHtml = "" ;
		var html = "" ;
		var showTabNumber ;
		var receiveUserName = "" ;
		if(ncCom_Empty(tabNumber)) {
			showTabNumber =  $("#showTabNumber").val();
		}else {
			showTabNumber = tabNumber ;
		}
		if(siReceiveCode){
       
			arrSiReceiveCode = siReceiveCode.split(g_receiveGubun);
			arrSiReceiveName = siReceiveName.split(g_receiveGubun);
			arrSenderName = siSenderName.split(g_receiveGubun);
			if(!ncCom_Empty(siReceiveUserName) ) arrSiReceiveUserName = siReceiveUserName.split(g_receiveGubun);
			rowNum = arrSiReceiveCode.length ;
		}
		var hwpCtrl ;
		var hwpDocReceiveList = "" ;
//		try {
//			hwpCtrl = document.getElementById("HwpCtrl_"+showTabNumber) ;
//			hwpDocReceiveList = _hwpMultiLineFieldText(hwpCtrl, "doc_receivelist");
//		}catch(e) { }
		
		for(var inx=0; inx < rowNum; inx++){
			receiveNameHtml  += arrSenderName[inx] ;
			receiveUserName = "" ;
			if(arrSiReceiveUserName != undefined ) receiveUserName = arrSiReceiveUserName[inx] ;
			
			if(!ncCom_Empty(receiveUserName) ) {
				receiveNameHtml  += "(" +receiveUserName+ ")" ;
			}
			if( inx < rowNum-1) {
				receiveNameHtml += ", ";
				
			}
			
			html += "<input type = 'hidden' name = 'siReceiveCode_"+showTabNumber+"' id = 'siReceiveCode_"+showTabNumber+"' value = '"+arrSiReceiveCode[inx]+"'>" ;
			html += "<input type = 'hidden' name = 'siReceiveName_"+showTabNumber+"' id = 'siReceiveName_"+showTabNumber+"' value = '"+arrSiReceiveName[inx]+"'>" ;
			html += "<input type = 'hidden' name = 'siSenderName_"+showTabNumber+"' id = 'siSenderName_"+showTabNumber+"' value = '"+arrSenderName[inx]+"'>" ;
			if(arrSiReceiveUserName != undefined   ) 
				html += "<input type = 'hidden' name = 'siReceiveUserName_"+showTabNumber+"' id = 'siReceiveUserName_"+showTabNumber+"' value = '"+arrSiReceiveUserName[inx]+"'>" ;
			else 
				html += "<input type = 'hidden' name = 'siReceiveUserName_"+showTabNumber+"' id = 'siReceiveUserName_"+showTabNumber+"' value = ''>" ;
			
		
			
		}
	//	if(ncCom_Empty(hwpDocReceiveList) ) {
		hwpDocReceiveList = receiveNameHtml;
	//	}
		$("#susinjaView_"+showTabNumber).val(receiveNameHtml);
		$("#customSusinjaView_"+showTabNumber).val(hwpDocReceiveList);
		$("#idApprvLineReceive_"+showTabNumber).html(html);
		$("#arrSiReceiveCode_"+showTabNumber).val(siReceiveCode);
		$("#arrSiSenderName_"+showTabNumber).val(siSenderName);
		
		if(!ncCom_Empty(siReceiveUserName) ) $("#arrSiReceiveUserName_"+showTabNumber).val(siReceiveUserName);
		else $("#arrSiReceiveUserName_"+showTabNumber).val("");
	},
	/**********************************************************************************************/
	/***********************************문서파일이름 저장 *****************************************/
	/**********************************************************************************************/
	setHwpFileName : function (arrDestFileName) {
	  	if(_g_nonElecYN == "Y") {
	  		if ( $("#hwpYN").val() == "N") return ;
	  	}
	  	
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = objCurrentTabNumber.length ;
		if(_g_nonElecYN == "Y") {
			var arrImageFileNameRow = arrDestFileName[0].split(_g_rowSymbol);
		}else {
			var arrDocFileName = arrDestFileName[0].split(_g_colSymbol);
			var arrImageFileNameRow = arrDestFileName[1].split(_g_rowSymbol);
			for( var inx = 0 ; inx < rowNum; inx++ ) {
				$("#docFileName_"+objCurrentTabNumber[inx].value).val(arrDocFileName[inx]);
			}
		}
		var arrImageFileNameCol ;
		rowNum = arrImageFileNameRow.length ;
		var subRowNum = 0 ;
		var imageFileNameHtml = "" ;
		var tabNumber  ;
		for(var inx = 0 ; inx< rowNum; inx++) {
			arrImageFileNameCol = arrImageFileNameRow[inx].split(_g_colSymbol);
			subRowNum = arrImageFileNameCol.length ;
			tabNumber = objCurrentTabNumber[inx].value ;
			for(var subInx = 0 ; subInx < subRowNum; subInx++) {
				imageFileNameHtml  += "<input type =\"hidden\" name = \"imageFileName_"+tabNumber+"\" + value = '"+arrImageFileNameCol[subInx]+"'>" ;
			}
		}
		$("#idImageFileName").html(imageFileNameHtml);
		

	},
	/**********************************************************************************************/
	/***********************************결재라인 수정 반영*****************************************/
	/**********************************************************************************************/
	setApprvLine : function (apprvLine, delApprvLine) {
		$("#idApprvLine").html(apprvLine);
		//$("#idApprvLine2").html(apprvLine);
		if(!ncCom_Empty(delApprvLine)) {
			$("#delApprovalMember").html(delApprvLine);
		//	$("#delApprovalMember2").html(delApprvLine);
		}else {
			$("#delApprovalMember").html("");
		//	$("#delApprovalMember2").html("");
		}
		return true ;
	},
	loadingStart:function() {

		if (_g_isLoading == false ) {
			$("#viewLoading").css("width", "100%");
		    $("#viewLoading").css("height", "100%");
		    $("#viewLoading").fadeIn(500);
		}else {
			_g_isLoading= true ;
		}

	} ,
	loadingEnd:function() {
		 $("#viewLoading").fadeOut(500);
		 _g_isLoading = false ;
	} ,
	
	//필드명에 텍스트 존재여부
	isHwpText : function(pHwp, fieldName) {
		var result = true ;
        var textValue = _hwpMultiLineFieldText(pHwp, fieldName);
        if(ncCom_Empty(textValue)) {
        	result = false ;
        }
        return result ;
	},
	/**********************************************************************************************/
	/***********************************결재문서 제목반환******************************************/
	/**********************************************************************************************/
	getDocTitle : function() {
		var showTabNumber =  $("#showTabNumber").val();
		var diTitle = $("#diTitle_"+showTabNumber).val();
		if(ncCom_Empty(diTitle) ) {
			 diTitle = $("#srcDiTitle_"+showTabNumber).val();
		}
		return diTitle; 
	},
	/**********************************************************************************************/
	/***********************************HWP 필드명에 이미지 확인***********************************/
	/**********************************************************************************************/
	isHwpImg : function (pHwp, fieldName) {
		var act;
		var set;
		var subset;
		var result = false ;
		
		pHwp.MoveToField(fieldName, true, true, true);
		act =pHwp.CreateAction("CellBorderFill");
		set = act.CreateSet();
		act.GetDefault(set);
		if (set.ItemExist("FillAttr")) {
			subset = set.Item("FillAttr");
			if(subset.ItemExist("Type")) {
				if((subset.Item("Type") & 2) == 2) {
					result = true ;
				} else {
					result  = false ;
				}
			}
		} else {
			result = false ;
		}
		pHwp.Run("Cancel");
		
		return result ;
	}, 
	/**********************************************************************************************/
	/***********************************HWP 결재라인 적용 *****************************************/
	/**********************************************************************************************/	
	setApprovalLineToHwp : function () {
		if(_g_nonElecYN == "Y") return ;
		var lastApprovalInx = commonApproval.initApprovalHwp();// hwp 문서 결재라인 초기화
		
		var docApprover = "";
		var userType002 = 0; //결재 갯수
		var userType004 = 0; //협의 갯수
		var userType007 = 0; //합의 갯수
		var klUserProperty002 = "" ;
		var klUserProperty004 = "" ;
		var klUserProperty032 = "" ;
		var klUserProperty064 = "" ;
		var klStatus = "" ;
		var absentFlag = "" ;
		var klUserProperty = "" ;
		var klUserType = "" ;
		var hwpFieldName = "" ;
		var objEsntlID = document.getElementsByName("esntlID");
		var objUserNm = document.getElementsByName("userNm");
		var objKlUserType = document.getElementsByName("klUserType");
		var objKlUserProperty002 = document.getElementsByName("klUserProperty002");
		var objKlUserProperty004 = document.getElementsByName("klUserProperty004");
		var objKlUserProperty032 = document.getElementsByName("klUserProperty032");
		var objKlUserProperty064 = document.getElementsByName("klUserProperty064");
		var objAbsentFlag = document.getElementsByName("absentFlag");
		var objPositionNm = document.getElementsByName("positionNm");
		var objClassName = document.getElementsByName("className");
		var objKlStatus = document.getElementsByName("klStatus");
		var objAbsentName = document.getElementsByName("absentName");
		var objDeptName = document.getElementsByName("deptNm");
		var deptName = "" ;
		var absentName = "";
		var optPlace = "" ;
		var agencyName = "" ;
		var signDay = "";
		var signPlace  = "";
		var deptPlace = "" ;
		if(objEsntlID == undefined ) return ;
		var rowNum = objEsntlID.length ;
		var isSignAbsent = false ;
		
		
		for( var inx = 0 ; inx < rowNum; inx++) {
/*
			if( frmMain.klUserType[0].value != "001") {
					alert("기안자는 기안만 가능합니다.");
					return false  ;
			}
*/
			klUserType = objKlUserType[inx].value;
			klUserProperty002 = objKlUserProperty002[inx].value;
			klUserProperty004 = objKlUserProperty004[inx].value;
			klUserProperty032 = objKlUserProperty032[inx].value;
			klUserProperty064 = objKlUserProperty064[inx].value;
			deptName = objDeptName[inx].value;
			klStatus = objKlStatus[inx].value ;
			absentFlag = objAbsentFlag[inx].value ;
			
			
			klUserProperty ="";
			if( klUserProperty002 =="002") {
				klUserProperty += "★ ";
			}

			if( klUserProperty004 =="004") {
				klUserProperty += "⊙ ";
			}
			absentName = "" ;
			if(klUserProperty064 == "064") {
				if(inx > 0 && isSignAbsent == false && ncCom_Empty(objKlStatus[inx-1].value) ) { //결재안함이고, 전결재자가 결재를 했으면.
					isSignAbsent = true ;
					absentName = objAbsentName[inx].value;
				}else if( isSignAbsent &&  "064" == objKlUserProperty064[inx-1].value) { //전결재자가 결재안함이면(연속결재안함).
					absentName = objAbsentName[inx].value;
				}else {
					isSignAbsent = false ;
				}
			}
			
			if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
				userType002++ ;
				hwpFieldName = _g_prefixApproval+"approver"+userType002 ;
				optPlace = _g_prefixApproval+"approval_opt"+userType002 ;
				signPlace = _g_prefixApproval+"approval"+userType002 ;
				deptPlace = _g_prefixApproval+"approval_deptnm"+userType002 ;
				agencyName = "";
				
				if(klUserProperty032 == "032") {
					agencyName = "전결" ;
				}
				if( absentFlag == "Y" && klUserProperty064 != "064" ) {
					agencyName += "대결" ;
				}
				
				if(ncCom_Empty(klStatus) ) {
					signDay =  document.getElementsByName("klSignDay")[inx].value ;
					//'결재..합의' 결재라인이 되어있으면. 합의자가 최종결재자를추가 한후 반영했다가(반영하기전 결재라인을 초기화한다.)
					//다시 마지막결재자를 삭제했을경우
					//마지막결재자한날짜가 양식에서 삭제되기 때문에 다시 결재날짜를 넣어준다.
					if(!ncCom_Empty(signDay) && (lastApprovalInx >= 0  && (lastApprovalInx+1) == userType002 ) ) { 
						approvalMD = signDay.substring(4,signDay.length) ;
						approvalMD = approvalMD.substring(0,2) +"/" + approvalMD.substring(2,4) ;
					}else {
						approvalMD = "" ;
					}
					
					lumpApproval.hwpPutText(optPlace ,agencyName + approvalMD);
				}
			}else if ( klUserType == "004" ){ //협조
				userType004++ ;
				signPlace = _g_prefixApproval+"cooperation"+userType004 ;
				deptPlace = _g_prefixApproval+"cooperation_deptnm"+userType004 ;
				hwpFieldName = _g_prefixApproval+"cooperate"+userType004 ;
			}else if ( klUserType == "007") { //합의
				userType007++ ;
				signPlace = _g_prefixApproval+"agreement"+userType007 ;
				deptPlace = _g_prefixApproval+"agreement_deptnm"+userType007 ;
				hwpFieldName = _g_prefixApproval+"agree"+userType007 ;
			}
			if(!ncCom_Empty(absentName) ) {
				lumpApproval.hwpPutText(signPlace , absentName);
			}
			
			if(_g_approverCode == "002") {
				docApprover = objClassName[inx].value ;
			}else {
				docApprover = objPositionNm[inx].value ;
			}
			lumpApproval.hwpPutText(hwpFieldName , klUserProperty+docApprover);
			lumpApproval.hwpPutText(deptPlace , deptName);
		}
		
		//최종결재자 이름, 직위 추가.
		if(rowNum > 0 ) {
			if(_g_approverCode == "002") {
				docApprover = objClassName[rowNum-1].value ;
			}else {
				docApprover = objPositionNm[rowNum-1].value ;
			}
			lumpApproval.hwpPutText("FINAL_APPROVAL_USER_NAME" ,objUserNm[rowNum-1].value);
			lumpApproval.hwpPutText("FINAL_APPROVAL_POSITION_NAME" , docApprover);
		}
		//_pHwpCtrl.PutFieldText("sender_name", frmMain.selSenderName.value);
		return true ;
	},	
	hwpPrint:function(curTabNumber, diKeyCode, insertGwaninYN, insertOpinionYN, popPrint ) {
		
		var pHwpCtrl =  document.getElementById("HwpCtrl_"+curTabNumber) ;
		
		if(insertGwaninYN == "Y") {
			commonApproval.sealInsert(pHwpCtrl, diKeyCode);
		}
		if(insertOpinionYN == "Y" ) {
			commonApproval.opinionInsert(pHwpCtrl, diKeyCode);
		}
		
		pHwpCtrl.PrintDocument();
/*		
		if(insertGwaninYN == "Y") {
			if(pHwpCtrl.FieldExist("seal")) {
				pHwpCtrl.MoveToField("seal", true, true, false);
				pHwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);
			}
		}
*/		
		if(insertOpinionYN == "Y" ) {
			if(pHwpCtrl.FieldExist("OPINION_PRINT")) {
				_hwpPutText("OPINION_PRINT", " ", pHwpCtrl);
			}
		}
		
	},
	/**********************************************************************************************/
	/***********************************HWP 결재라인 초기화 ***************************************/
	/**********************************************************************************************/
	initApprovalHwp:function() {
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = 0  ;
		var pHwpCtrl ;
		var agency = "" ; 
		var lastApprovalInx = -1 ;
		var objEsntlID = document.getElementsByName("esntlID");
		var objKlUserType = document.getElementsByName("klUserType");
		var klUserType = "";
		var rowNum = objEsntlID.length ;
		
		for(var inx = 0 ; inx < rowNum ; inx++ ) {
			klUserType = objKlUserType[inx].value;
			if(klUserType == "001" || klUserType == "002" || klUserType == "003" ) {
				lastApprovalInx++ ;
			}
		}
		var signDay = "" ;
		var approvalMD = "" ;
		rowNum = objCurrentTabNumber.length ;
		for( var inx = 0 ; inx < rowNum; inx++) {
			curTabNumber = parseInt(objCurrentTabNumber[inx].value);
			pHwpCtrl =  document.getElementById("HwpCtrl_"+curTabNumber) ;
			
			for( var subInx = 1 ; subInx <=8; subInx++ ) {
				_hwpPutText(_g_prefixApproval+"approval_opt"+subInx, " ", pHwpCtrl);
				_hwpPutText(_g_prefixApproval+"approver"+subInx,  " ", pHwpCtrl);
				_hwpPutText(_g_prefixApproval+"cooperate"+subInx,  " ", pHwpCtrl);
				_hwpPutText(_g_prefixApproval+"agree"+subInx,  " ", pHwpCtrl);
			}
		}
		return lastApprovalInx ;
	},
	/**********************************************************************************************/
	/***********************************HWP 문서 수정여부 적용 ************************************/
	/**********************************************************************************************/	
	setHwpModified: function() {
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = objCurrentTabNumber.length ;
		var curTabNumber = "" ;
		var hwpCtrl ;
		var modified = 0 ;
		
		for( var inx = 0 ; inx < rowNum; inx++) {
			curTabNumber = parseInt(objCurrentTabNumber[inx].value);
			hwpCtrl = document.getElementById("HwpCtrl_"+curTabNumber) ;
			modified = hwpCtrl.IsModified ;
			if( typeof(modified) == "undefined") {
				modified = 0 ;
			}
			if ( ncCom_Empty( $("#diKeyCode_"+curTabNumber).val() ) ) {
				$("#approvalKlEditFlag_"+curTabNumber).val("N");
			}else {
				if(modified == 0 ) {
					$("#approvalKlEditFlag_"+curTabNumber).val("N");
				}else {
					$("#approvalKlEditFlag_"+curTabNumber).val("Y");
				}
			}
		}
	},
	/**********************************************************************************************/
	/***************************결재버튼클릭시 문서수정여부확인************************************/
	/**********************************************************************************************/	
	buttonToggle:function(buttonType) {
		switch (buttonType) {
			case 'BTN_EDIT' :
			case 'BTN_APPROVAL' :
				var curTabNumber = "" ;
				var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
				var rowNum = objCurrentTabNumber.length ;
				var pHwpCtrl ;
				var modified ;
				
				if( commonApproval.docExternalAttachFileSize("2") == false ) {
					alert("대외문서는 첨부파일크기는 5M 이하여야 합니다.") ;
					return ;
				}
				//여러개 일경우 수정내역을 입력 안받는다.
				if(rowNum > 1 ) {
					if( buttonType == "BTN_EDIT") {
						commonApproval.main("EDIT_APPROVALLINE");
					}else {
						commonApproval.pop('POP_VIEWAPPROVALSIGN');
					}
					return ;
				}
				//기안문이 하나일경우만 수정내역을 입력받는다.
				var isEditInput =false ;
				curTabNumber = parseInt(objCurrentTabNumber[0].value);
				if($("#approvalKlEditFlag_"+curTabNumber).val() == "N") {
					pHwpCtrl =  document.getElementById("HwpCtrl_"+curTabNumber) ;
					modified = pHwpCtrl.IsModified ;
				
					//문서본문 수정여부를 확인한다.
					if ( ncCom_Empty( $("#diKeyCode_"+curTabNumber).val() ) ) {
						$("#approvalKlEditFlag_"+curTabNumber).val("N");
					}else {
						if(modified == 0 ) {
							$("#approvalKlEditFlag_"+curTabNumber).val("N");
						}else {
							$("#approvalKlEditFlag_"+curTabNumber).val("Y");
							if( buttonType == "BTN_EDIT"  ) {
								isEditInput = confirm("본문 수정내역이 있습니다,\n\n 수정내역을 입력하시고 저장하시겠습니까?") ;
							}else {
								isEditInput = confirm("본문 수정내역이 있습니다,\n\n 수정내역을 입력하시고 결재하시겠습니까?") ;
							}
						}
					}
				}else {
					if( buttonType == "BTN_EDIT"  ) {
						isEditInput = confirm("본문 수정내역이 있습니다,\n\n 수정내역을 입력하시고 저장하시겠습니까?") ;
					}else {
						isEditInput = confirm("본문 수정내역이 있습니다,\n\n 수정내역을 입력하시고 결재하시겠습니까?") ;
					}
				}
				
				if(isEditInput ) {
					if( buttonType == "BTN_EDIT") {
						_g_editType = "1" ;
					}else {
						_g_editType = "2" ;
					}
					lumpApproval.pop("POP_EDITRECORD");
				}else {
					_g_editType = "0" ;
					if( buttonType == "BTN_EDIT") {
						commonApproval.main("EDIT_APPROVALLINE");
					}else {
						commonApproval.pop('POP_VIEWAPPROVALSIGN');
					}
				}
				break;
		}
	},
	/**********************************************************************************************/
	/***********************************HWP 문서 수정여부확인**************************************/
	/**********************************************************************************************/
	setHwpEditabled : function() {
		if(_g_nonElecYN == "Y") return ;
		
		var curTabNumber = "" ;
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = objCurrentTabNumber.length ;
		var hwpCtrl ;
		var modified ;
		for( var inx = 0 ; inx < rowNum; inx++) {
			curTabNumber = parseInt(objCurrentTabNumber[inx].value);
			if($("#approvalKlEditFlag_"+curTabNumber).val() == "N") {
				hwpCtrl =  document.getElementById("HwpCtrl_"+curTabNumber) ;
				modified = hwpCtrl.IsModified ;
				//문서본문 수정여부를 확인한다.
				if ( ncCom_Empty( $("#diKeyCode_"+curTabNumber).val() ) ) {
					$("#approvalKlEditFlag_"+curTabNumber).val("N");
				}else {
					if(modified == 0 ) {
						$("#approvalKlEditFlag_"+curTabNumber).val("N");
					}else {
						$("#approvalKlEditFlag_"+curTabNumber).val("Y");
					}
				}
			}
		}
	},
	/**********************************************************************************************/
	/***********************************전체문서정보를 한글파일에 입력******************************/
	/**********************************************************************************************/
	//문서정보를 한글파일에 입력
	docInfoToHwp : function(argType) {
	  	if(_g_nonElecYN == "Y") return ;
		var senderName  = "" ;
		var docReceive = "" ;
		var docReceiveEn = "" ;
		var docReceiveList = "" ;
		var objCurrentTabNumber ;
		var rowNum = 0 ;
		if(typeof(argType) == "undefined" || ncCom_Empty(argType)) {
			objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
			rowNum = objCurrentTabNumber.length ;
		}else if (argType == "single") {
			rowNum = 1 ;
			
			objCurrentTabNumber = new Array();
			objCurrentTabNumber.push($("#showTabNumber").val());
		}
		var pHwpCtrl ;
		var zipCode = "" ;
		var subRowNum = 0  ;
		var publicGradeCH= "" ;
		var arrPublicGradeCH ;
		var publicType = "";
		var publicTypeName = "" ;
		var seldocTypeCode = "" ;
		var preserveName = "" ;
		var receiveRowNum = 0;
		var viaPath = "" ;
		var selSenderName = $("#selSenderName").val() ;
		var diSenderName = $("#diSenderName").val() ;
		var customSenderName = "" ;
		for( var inx = 0 ; inx < rowNum; inx++) {
			if ( argType == "single") {
				curTabNumber = parseInt(objCurrentTabNumber[inx]);
			}else {
				curTabNumber = parseInt(objCurrentTabNumber[inx].value);	
			}
			
			senderName  = $("#susinjaView_"+curTabNumber).val() ;
			customSenderName = $("#customSusinjaView_"+curTabNumber).val() ;
			preserveName = $("#preserveName_"+curTabNumber).val();
			docReceive = "" ;
			docReceiveEn = "" ;
			docReceiveList = "" ;
			
			seldocTypeCode = $("input[name='docTypeCode_"+curTabNumber+"']:checked").val();
			
			pHwpCtrl = document.getElementById("HwpCtrl_"+curTabNumber);
			if(seldocTypeCode == "000") {
				docReceive = "내부결재" ;
				docReceiveEn = "Internal Approval" ;
				docReceiveList = "" ;
				customSenderName = "" ;
				_hwpPutText("doc_receivelist_title", " ", pHwpCtrl);
			}else {
				var objSiReceiveCode = document.getElementsByName("siReceiveCode_"+curTabNumber) ;
				receiveRowNum = 0 ;
				if ( objSiReceiveCode != undefined) {
					receiveRowNum = objSiReceiveCode.length ;
				}
				if(!ncCom_Empty(senderName)) {
					if( receiveRowNum > 1 ) {
						docReceive = "수신자 참조" ;
						docReceiveEn = "Multiple Recipients" ;
						if(!ncCom_Empty(customSenderName)) {
							docReceiveList = customSenderName;
						}else {
							docReceiveList = senderName ;
						}
						_hwpPutText("doc_receivelist_title", "수신자", pHwpCtrl);
					}else {
						if(!ncCom_Empty(customSenderName)) {
							docReceive = customSenderName;
							docReceiveEn =  customSenderName;
						}else {
							docReceive = senderName;
							docReceiveEn =  senderName;
						}
						docReceiveList = "";
						_hwpPutText("doc_receivelist_title", " ", pHwpCtrl);
					}
				}else {
					_hwpPutText("doc_receivelist_title", " ", pHwpCtrl);
				}
				if(seldocTypeCode != "004") {
					 $("#viaPath_"+curTabNumber).val("");
				}
			}
			
			_hwpPutText("doc_receive", " ", pHwpCtrl);
			_hwpPutText("doc_receivelist", " ", pHwpCtrl);
			
			selSenderName = $("#selSenderName_"+curTabNumber).val() ;
			if(seldocTypeCode == "001" || seldocTypeCode == "002" || seldocTypeCode == "003"   || seldocTypeCode == "004"  ) { //대내.대외
				if(ncCom_Empty(selSenderName) ) {
					_hwpPutText("sender_name", diSenderName, pHwpCtrl); //발신인명	
				}else {
					_hwpPutText("sender_name", selSenderName, pHwpCtrl); //발신인명
				}
			}else { 
				_hwpPutText("sender_name", " ", pHwpCtrl); //발신인명
			}
			_hwpPutText("doc_name", $("#dname2_"+curTabNumber).val(), pHwpCtrl); //문서제목
			_hwpPutText("doc_receive", docReceive, pHwpCtrl); //수신
			_hwpPutText("doc_receive_en", docReceiveEn, pHwpCtrl); //수신
			
			viaPath = $("#viaPath_"+curTabNumber).val() ;
			if(ncCom_Empty(viaPath)) {
				_hwpPutText("doc_via"," ", pHwpCtrl); //경유지
			}else {
				_hwpPutText("doc_via", viaPath, pHwpCtrl); //경유지
			}
			_hwpPutText("doc_receivelist", docReceiveList, pHwpCtrl); //수신자 리스트
			
			publicType = $("input[name='publicType_"+curTabNumber+"']:checked").val() ;
			publicTypeName = "" ;

			if (publicType == "001") {
				publicTypeName = "공개";
			}else {
				arrPublicGradeCH = checkBoxSelectedIndex(document.forms["frmMain"].elements["publicGradeCH_"+curTabNumber]);
				subRowNum = 0 ;
				publicGradeCH= "" ;

				if (arrPublicGradeCH != undefined ) {
					subRowNum = arrPublicGradeCH.length ;
					for(var subInx = 0 ; subInx < subRowNum; subInx++) {
						publicGradeCH += (arrPublicGradeCH[subInx]+1)+"";
						if(subInx < subRowNum -1) {
							publicGradeCH += "," ;
						}
					}
					if(!ncCom_Empty(publicGradeCH)) {
						publicGradeCH  = "( "+publicGradeCH+" )" ;
					}
				}
				if (publicType == "002") {
					publicTypeName = "부분공개";
				}else {
					publicTypeName = "비공개";
				}
				publicTypeName += " "+publicGradeCH ;
			}

			_hwpPutText("management", publicTypeName, pHwpCtrl); //문서 공개, 비공개
			_hwpPutText("preserve_name", preserveName, pHwpCtrl); //보존년한

			seldocTypeCode = $("input[name='docTypeCode_"+curTabNumber+"']:checked").val();

			if(seldocTypeCode == "003"){//민원문서일경우
				docReceive = $("#civilUserName_"+curTabNumber).val() + " " +lumpApproval.getSuffix(curTabNumber) + "( 우" +$("#zipcode1_"+curTabNumber).val()+"-"+$("#zipcode2_"+curTabNumber).val() +" "+ $("#address_"+curTabNumber).val() +" )" ;
				_hwpPutText("doc_receive", docReceive, pHwpCtrl); //수신
				_hwpPutText("doc_receive_en", docReceive, pHwpCtrl); //수신
			}else {
				if(docReceive == "") _hwpPutText("doc_receive", " ", pHwpCtrl); //수신
				if(docReceiveEn == "") _hwpPutText("doc_receive_en", " ", pHwpCtrl); //수신
			}
		}
		commonApproval.setAllDocFileName(argType);
	},
	
	/**********************************************************************************************/
	/***********************************TOOL BAR 없는 문서*****************************************/
	/**********************************************************************************************/	
    DOC_HWPSTART : function (hwpCtrl) {
    	hwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

    	if (!_VerifyVersion(hwpCtrl)) {
    		hwpCtrl = null;
	  	   	return;
	  	}
		var path = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docDownload.do?randomKey="+rndStr("",13)+"&tiKeyCode="+_g_tiKeyCode ;

	   	if(!hwpCtrl.Open(path,"HWP","versionwarning:true")){
	   		alert("증명서가 없습니다. 관리자한테 문의하세요!");
	   		self.close();
	   		return;
	   	};
		hwpCtrl.EditMode = 0 ; //읽기 전용
    },
    validDocName : function () {
    	var curTabNumber = $("#showTabNumber").val();
		return true ;
		//문서제목 체크 끝
    },
	/**********************************************************************************************/
	/***********************************onBlur 문서제목 수정***************************************/
	/**********************************************************************************************/
    setDocNameHwp : function () {
    	var curTabNumber = $("#showTabNumber").val();
    	if(!commonApproval.isValid("EDIT_DOCNAME", curTabNumber)) return ;
    	
    	var pHwpCtrl = document.getElementById("HwpCtrl_"+curTabNumber);
    	
    	var docTitle = $("#dname2_"+curTabNumber).val();
	    var srcDiTitle = $("#srcDiTitle_"+curTabNumber).val();
		if(docTitle == srcDiTitle ) return ;
		
    	_hwpPutText("doc_name", docTitle, pHwpCtrl); //문서제목
    },
    
    /**********************************************************************************************/
	/*****************************결재시 문서제목 한글파일에적용***********************************/
	/**********************************************************************************************/
    setAllDocNameHwp : function() {
    	var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
        var rowNum = objCurrentTabNumber.length ;
        var docTitle = "" ;
        var curTabNumber = "" ;
	    for(var inx = 0; inx < rowNum; inx++) { 
	    	curTabNumber = objCurrentTabNumber[inx].value ;
		    docTitle = $("#dname2_"+curTabNumber).val();
		    if(ncCom_Empty(docTitle)) {
		    	return ncCom_ErrField($("#dname2_"+curTabNumber), "제목을 입력하세요.")
		    }
	    	if(!commonApproval.isValid("EDIT_DOCNAME", curTabNumber)) return false ;
	    	$("#dname_"+curTabNumber).val(docTitle);
	    }
	    return true ;
    },
    
    /**********************************************************************************************/
    /*****************************결재시 문서제목 한글파일에적용***********************************/
    /**********************************************************************************************/
    setAllDocFileName : function(argType) {
    	if(_g_nonElecYN == "Y") return ;
    	
    	var objCurrentTabNumber ;
    	var rowNum = 0 ;
    	if(typeof(argType) == "undefined" || ncCom_Empty(argType)) {
			objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
			rowNum = objCurrentTabNumber.length ;
		}else if (argType == "single") {
			rowNum = 1 ;
			
			objCurrentTabNumber = new Array();
			objCurrentTabNumber.push($("#showTabNumber").val());
		}
    	var curTabNumber = 0;
    	var objNeosFile = "" ;
    	var filePathName = "" ;
		var fileNameExt = "" ;
		var fileName = "" ;
		var fileRowNum = 0;
		var totFileName = "";
		var pos = 0 ;
		var firstFileName = false ;
		var pHwpCtrl ;
		var totalInx = 0 ;
		var fontSizeNm = "12pt";
		var fontFamily = "굴림체";
		var objSavedNeosFile ;
		var savedFileRowNum = 0 ;
		
    	for(var inx = 0; inx < rowNum; inx++) {
    		if ( argType == "single") {
				curTabNumber = parseInt(objCurrentTabNumber[inx]);
			}else {
				curTabNumber = parseInt(objCurrentTabNumber[inx].value);	
			}
    		
    		objSavedNeosFile = document.getElementsByName("insertFileName_"+curTabNumber) ;
    		pHwpCtrl = document.getElementById("HwpCtrl_"+curTabNumber);
    		
    		totalInx = 0 ;
    		firstFileName = false ;
    		fileNameHtml = "" ;
    		
    		savedFileRowNum = 0 ;
    		//저장된 파일갯수
    		if ( objSavedNeosFile != null && objSavedNeosFile != undefined ) {
    			savedFileRowNum = objSavedNeosFile.length ;
    		}
    		
    		objNeosFile = document.getElementsByName("neosFile_"+curTabNumber) ;
    		fileRowNum = 0 ;
    		//새로추가한 파일갯수
    		if ( objNeosFile != null && objNeosFile != undefined ) {
    			fileRowNum = objNeosFile.length -1 ;
    			if( fileRowNum < 0 ) fileRowNum = 0 ;
    		}
    		
    		if(savedFileRowNum +  fileRowNum == 1) { 
    			totalInx  =1 ;
    			
    			if( savedFileRowNum == 1 ) {
    				filePathName = objSavedNeosFile[0].value ;
	    			
    			}else {
	    			filePathName = objNeosFile[0].value ;
    			}
    			if(ncCom_Empty(filePathName)) continue ;
    			
    			pos = filePathName.lastIndexOf("\\");
    			fileNameExt = filePathName.substring(pos+1,filePathName.length );
    			pos = fileNameExt.lastIndexOf(".");
    			if(pos > 0 )  { 
    				fileName = fileNameExt.substring(0, pos );
    			}else {
    				fileName = fileNameExt ;
    			}
    			
    			fileName = fileName + " 1부.&nbsp;&nbsp;끝.";
    			
    			fileNameHtml = "<table width =\"600px\" border = \"0\" ><tr height=\"30px\"><td width =\"50px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">붙임</p></td>" ;
    			fileNameHtml += "<td width = \"550px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName+"</td></tr></table>" ;
    			
    		}else {
	       		var fileNameHtml = "" ;
	    		if(savedFileRowNum > 0 ) {
	    			fileNameHtml = "<table width =\"600px\" border = \"0\" ><tr height=\"30px\"><td width =\"50px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">붙임</p></td>" ;
	    		}
	    		
	    		for(var fileInx = 0; fileInx < savedFileRowNum; fileInx++) {
	    			filePathName = objSavedNeosFile[fileInx].value ;
	    			if(ncCom_Empty(filePathName)) continue ;
	    			
	    			pos = filePathName.lastIndexOf("\\");
	    			
	    			fileName = filePathName.substring(pos+1,filePathName.length );
	    			
	    			fileName = (++totalInx) + ". " + fileName + " 1부";
	    			if(firstFileName == false ) {
	    				firstFileName = true ;
	    				if( fileRowNum -1 ==  fileInx ) {
	    					fileNameHtml += "<td width = \"550px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName+"" ;
	    				}else {
	    					fileNameHtml += "<td width = \"550px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName+"</td></tr>" ;
	    				}
	    				
	    			}else {
	    				
	    				if( savedFileRowNum -1 ==  fileInx ) {
	    					fileNameHtml += "<tr height=\"30px\" ><td  width =\"50px\" >&nbsp;</td><td width = \"550px\"><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName ;
	    				}else {
	    					fileNameHtml += "<tr height=\"30px\" ><td  width =\"50px\" >&nbsp;</td><td width = \"550px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName+"</p></td></tr>" ;
	    				}
	    			}
	    		}
	    		
	    		if(fileRowNum <=  0) {
	    			if(!ncCom_Empty(fileNameHtml)) {
	    				fileNameHtml += ".&nbsp;&nbsp;끝.</p></td></tr></table>" ;
	    			}
	    		}else {
	    			if(!ncCom_Empty(fileNameHtml)) {
	    				fileNameHtml += "</p></td></tr>" ;
	    			}else {
	    				fileNameHtml += "<table width =\"600px\" border = \"0\" ><tr height=\"30px\" ><td width =\"50px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">붙임</p></td>" ;
	    			}
	    		}
	    		firstFileName = false ;
	    		var emptyFileNameHtml = false ;
	    		
	    		if(totalInx== 0 ) {
	    			emptyFileNameHtml = true ;
	    		}
	    		for(var fileInx = 0 ; fileInx < fileRowNum; fileInx++) {
	    			filePathName = objNeosFile[fileInx].value ;
	    			if(ncCom_Empty(filePathName)) {
	    				continue ;
	    			}
	    			pos = filePathName.lastIndexOf("\\");
	    			
	    			fileNameExt = filePathName.substring(pos+1,filePathName.length );
	    			pos = fileNameExt.lastIndexOf(".");
	    			fileName = fileNameExt.substring(0, pos );
	    			fileName = (++totalInx) + ". " + fileName + " 1부";
	    			
	    			if( fileRowNum -1 ==  fileInx ) {
						fileName += ".&nbsp;&nbsp;끝." ;
					}
	    			
	    			if(firstFileName == false ) {
	    				if(emptyFileNameHtml == true ) {
	    					fileNameHtml += "<td width = \"550px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName+"</p></td></tr>" ;
	    					emptyFileNameHtml = false ;
	    				}else {
	    					fileNameHtml += "<tr height=\"30px\" ><td width =\"50px\" >&nbsp;</td><td width = \"550px\" ><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName+"</p></td></tr>" ;
	    				}
	    				firstFileName = true ;
	    			}else {
	    				
	    				fileNameHtml += "<tr height=\"30px\"><td width =\"50px\" >&nbsp;</td><td width = \"550px\"><p style=\"font-family:" + fontFamily + "; font-size:" + fontSizeNm + ";\">"+fileName+"</p></td></tr>" ;
	    			}
	    		}
	    		
	    		if(fileRowNum > 0 ) {
	    			fileNameHtml += "</table>" ;
	    		}
    		}
    		
    		if(totalInx == 0 ) {
    			fileNameHtml = "";
    		}
    		if(pHwpCtrl.FieldExist("doc_filename")) {
    			_hwpPutText("doc_filename", " ", pHwpCtrl)
	    		if( _g_nonElecYN != "Y" ) {
					if( ncCom_Empty(fileNameHtml)) {
						_hwpPutText("doc_filename", " ", pHwpCtrl); //수신
					}else {
						_hwpPutHtml("doc_filename", fileNameHtml, pHwpCtrl); //첨부파일명
					}    			
	    		}
    		}
    	}
    },
    
	/**********************************************************************************************/
	/***********************************한글결재파일 UPLOAD****************************************/
	/**********************************************************************************************/
	docFileUpload : function (uploadUri, userPassword) {
	  	if(_g_nonElecYN == "Y") {
	    	if ( $("#hwpYN").val() == "N") return ;
	  	}
	  	
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = objCurrentTabNumber.length ;
		var filePath = "" ;
		var tabNumber = "" ;
		var fileName = "";
		var imageFileName = "" ;
		var filePathName  = "" ;
		var imageFilePathName = "" ;
		var orderName = "" ;
		var isSave = false ;
		var arrFilePathName = new Array(rowNum);
//		var arrImageFilePathName =  new Array(rowNum);
		var hwpCtrl ;

		var subRowNum = 0 ;
		for(var inx = 0 ; inx < rowNum; inx++) {
			tabNumber = objCurrentTabNumber[inx].value ;
			filePath = lumpApproval.getHwpPath(tabNumber);
			
			fileName = rndStr("",10)+tabNumber ;

			filePathName  = filePath +fileName+".hwp";
			
			hwpCtrl = document.getElementById("HwpCtrl_"+tabNumber);
			

			if(_g_nonElecYN == "Y") {
				isSave = true ;
				hwpCtrl.SaveAs(filePathName,"HWP","lock:false");
			}else {
				isSave = hwpCtrl.SaveAs(filePathName,"HWP","lock:false");
				hwpCtrl.Save();
				
			}

			subRowNum = hwpCtrl.PageCount ;

			for(var subInx = 0 ; subInx < subRowNum; subInx++) {

				imageFileName = fileName +"_"+(subInx+1)+".gif";
				imageFilePathName = filePath + imageFileName;
				hwpCtrl.CreatePageImage(imageFilePathName, subInx,"","","gif");

				uploader.addFile("docImageFile_"+(inx+1)+"_"+(subInx+1), imageFilePathName);
			}

			if(!isSave) {
				alert("문서오류입니다.");
				return false ;
			}
			arrFilePathName[inx] = filePathName ;
			
			//문서페이지수
			$("#riAfterPage_"+tabNumber).val(subRowNum);
			uploader.addParam("upload_imagefile_cnt_"+(inx+1), subRowNum);
			
		}
		
		if(_g_nonElecYN != "Y") {
			for( var inx = 0 ; inx < rowNum; inx++) {
				uploader.addFile("docFile_"+(inx+1), arrFilePathName[inx]);
			}
		}
		
		uploader.addParam("upload_file_cnt", rowNum);
		uploader.addParam("file_id", "upload.approval.doc.temp");
		if(!ncCom_Empty(userPassword)) {
			uploader.addParam("userPassword", userPassword);
		}
		
		var result = uploader.sendRequest(_g_serverName, _g_serverPort, uploadUri);
		
		var arrFileName = commonApproval.isValid('UPLOAD_FILE', result);
		if(arrFileName == false ) return false ;
		return arrFileName ;
	},
	/**********************************************************************************************/
	/***********************************수정, 저장 버튼 toogle*************************************/
	/**********************************************************************************************/	
	editModeToggle:function(editType) {
		if(_g_nonElecYN == "Y") return ;
		if($("draftStatus").val() == "001" || $("draftStatus").val() == "003" ) return ;

		var curTabNumber = "" ;
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = objCurrentTabNumber.length ;
		var pHwpCtrl ;
		for( var inx = 0 ; inx < rowNum; inx++) {
			curTabNumber = parseInt(objCurrentTabNumber[inx].value);

			if(editType == "1") {
				$("#idSave_"+curTabNumber).show();
				$("#idEdit_"+curTabNumber).hide();
				if( _g_docEditYN == "Y" ) {
				      $('#dname2_'+curTabNumber).prop('readonly', false);
				      $('#dname2_'+curTabNumber).removeClass('inputBg');
				}
			}else {
				$("#idSave_"+curTabNumber).hide();
				$("#idEdit_"+curTabNumber).show();
				if( _g_docEditYN == "Y" ) {
					$('#dname2_'+curTabNumber).prop('readonly', true);
				    $('#dname2_'+curTabNumber).addClass('inputBg');
				}
			}
			pHwpCtrl =  document.getElementById("HwpCtrl_"+curTabNumber) ;

			if(editType == "1") {
				if(pHwpCtrl.FieldExist("_F_CONTENTS_")) {
					pHwpCtrl.EditMode = 2 ;
				}else {
					pHwpCtrl.EditMode = 1 ;
				}
			}else {
				pHwpCtrl.EditMode = 0 ;
			}
		}
	},
	/**********************************************************************************************/
	/********************************기안시 문서 다운로드및 문저정보입력***************************/
	/**********************************************************************************************/
	hwpStart : function(tabNumber, editMode) {
		var hwpCtrl = document.getElementById("HwpCtrl_"+tabNumber);

		hwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

    	if (!_VerifyVersion(hwpCtrl)) {
    		hwpCtrl = null;
	  	   	return;
	  	}

    	//hwpCtrl.SetClientName("DEBUG"); //For debug message
	   	_InitToolBarJS(hwpCtrl);

		//var path= "<spring:message code='eapproval.templatepath' />/${docTemplateInfo.C_TIKEYCODE}.hwp";

		var path = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docDownload.do?randomKey="+rndStr("",13)+"&tiKeyCode="+_g_tiKeyCode ;

	   	if(!hwpCtrl.Open(path,"HWP","versionwarning:true")){
	   		alert("기안문서가 없습니다. 관리자한테 문의하세요!");
	   		self.close();
	   		return;
	   	};
	   	if( typeof(editMode) == "undefined") {
			if(hwpCtrl.FieldExist("_F_CONTENTS_")) {
				hwpCtrl.EditMode = 2 ; //CELL과 누름틀 중 양식모드에서 편집 가능한 속성을 가진 것만 편집가능하다.
			}else {
				hwpCtrl.EditMode = 1 ; //일반 편집모드
			}
	   	}else {
	   		hwpCtrl.EditMode = editMode ; //일반 편집모드
	   	}
	   	//문서초기 정보입력
		if(!ncCom_Empty(_g_orgnztPostNumber)) {
			if( _g_orgnztPostNumber.length == 6 ) {
				_g_orgnztPostNumber = _g_orgnztPostNumber.substring(0,3) +"-"+ _g_orgnztPostNumber.substring(3,6)
			}
		}
	   	_hwpPutText("header_campaign",  _g_tiHeader , hwpCtrl);
	   	_hwpPutText("agency_name",  _g_docCompany , hwpCtrl);
	   	_hwpPutText("post_number",  _g_orgnztPostNumber , hwpCtrl);
	   	_hwpPutText("site_address",  _g_orgnztSiteAddress , hwpCtrl);
	   	_hwpPutText("homepage_url",  _g_orgnztHomepageURL , hwpCtrl);
	   	_hwpPutText("telephone_no",  _g_orgnztTelephoneNO , hwpCtrl);
	   	_hwpPutText("fax_no",  _g_orgnztFaxNO , hwpCtrl);
	   	_hwpPutText("email",  _g_orgnztEmail , hwpCtrl);

		if(hwpCtrl.FieldExist("img_logo")) {
			if(!ncCom_Empty(_g_tiLogo)) {
				_hwpPutImage("img_logo", "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?randomKey="+rndStr("",13)+"&imageName="+_g_tiLogo+"&imageType=logo", hwpCtrl);
			}
		}

		if(hwpCtrl.FieldExist("img_symbol")) {
			if(!ncCom_Empty(_g_tiSymbol)) {
				_hwpPutImage("img_symbol", "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?randomKey="+rndStr("",13)+"&imageName="+_g_tiSymbol+"&imageType=symbol", hwpCtrl);
			}
		}
	   	_hwpPutText("footer_campaign",  _g_tiFooter , hwpCtrl);
	   	_hwpPutText("DRAFT_USER_NM",  _g_userName , hwpCtrl);
	   	_hwpPutText("POSITION_NM",  _g_positionName , hwpCtrl);
	   	_hwpPutText("DRAFT_DEPT_NM",  _g_draftDeptName , hwpCtrl);
	   	_hwpPutText("DRAFT_DATE",  _g_draftDate , hwpCtrl);
	   	var draftYear = "" ;
	   	var draftMonth = "" ;
	   	var draftDay = "" ;
	   	if(!ncCom_Empty(_g_draftDate) && _g_draftDate.length == 10 ) { 
		   	draftYear = _g_draftDate.substring(0,4);
		   	draftMonth = _g_draftDate.substring(5,7);
		   	draftDay = _g_draftDate.substring(8,10);
		   	
		   	_hwpPutText("DRAFT_YEAR",  draftYear , hwpCtrl);
		   	_hwpPutText("DRAFT_MONTH",  draftMonth , hwpCtrl);
		   	_hwpPutText("DRAFT_DAY",  draftDay , hwpCtrl);
	   	}
		hwpCtrl.MovePos(2);
	},	
	//대외문서 첨부파일 5m 이상일경우 에러가 발생하기때문에 5mb 이하로 제한
	docExternalAttachFileSize:function(argType) {
		if (_g_outFileLimitYN == "N") return true ;
			
		var curTabNumber  ;
		var selDocTypeCode = "" ;
		var selTreatmentCode = "" ;
        var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
        var rowNum = objCurrentTabNumber.length ;
        var colFiles ;
        var fileID = "" ;
        var totalAttachFileSize = 0 ;
        var neosFileSize = 0 ;
		for( var inx = 0 ; inx < rowNum; inx++) {
			curTabNumber = parseInt(objCurrentTabNumber[inx].value);
	    	
	          /*
	            var doctype = $("#docTypeCode_"+showTabNumber).val();
	            if(doctype=='001'||doctype=='002'||doctype=='004'){
	              if(confirm("관인을 삽입하시겠습니까?")){
	                commonApproval.sealInsert();
	              }
	            }
	            */
		    
			 if(argType == "1") {
		    	 selDocTypeCode = $("input[name='docTypeCode_"+curTabNumber+"']:checked").val();
		    	 selTreatmentCode = $("input[name='treatmentCode_"+curTabNumber+"']:checked").val();
		     }else {
		    	 selDocTypeCode =  $("#docTypeCode_"+curTabNumber).val();
		    	 selTreatmentCode = $("#treatmentCode_"+curTabNumber).val();		    	 
		     }
			 //전상망 이면서 대외문서만 파일사이즈크기 체크
			if(selDocTypeCode == "002" && selTreatmentCode == "001") {
				totalAttachFileSize = 0 ;
				neosFileSize = 0 ;
				colFiles = document.getElementsByName("neosFile_"+curTabNumber ) ;
				for( var subInx = 0; subInx < colFiles.length; subInx++) {
					fileID = colFiles[subInx].getAttribute("id");
					
					if(ncCom_Empty(colFiles[subInx].value)) {
						continue;
					}
					totalAttachFileSize += getFileSize(fileID);
				}
				
				colFiles = document.getElementsByName("neosFileSize_"+curTabNumber ) ;
				for( var subInx = 0; subInx < colFiles.length; subInx++) {
					
					neosFileSize =  colFiles[subInx].value;
					neosFileSize = neosFileSize / 1048576 ;
					
					totalAttachFileSize += roundPrecision(neosFileSize,2);
				}

				if(totalAttachFileSize > 5) {
					return false ;
				}
			}
		}
		return true ;
	},
	
	// deptid 에 해당하는 발신인명
	getSenderName : function getSenderName(deptID) {
	    var rowNum = 0 ;
	    var senderName = "" ;
	    if( _g_senderList != "" && _g_senderList != undefined) {
	        rowNum = _g_senderList.length ;
	    }
	    for(var inx = 0 ; inx < rowNum ; inx++) {
	        if( _g_senderList[inx].organ_id == deptID ) { 
	        	senderName = _g_senderList[inx].sendername ;
	            break; 
	        }
	    }
	    return senderName ;
	},
	//부서에 해당하는 상위 기관을 가져온다.
	selectedSender: function(diSenderCode) {
		var selOrganID = "" ;
		var rowNum = 0 ;

	    if( _g_senderList != "" && _g_senderList != undefined) {
	        rowNum = _g_senderList.length ;
	    }
	    var isUpper = false ;
	    for(var inx = rowNum-1 ; inx >= 0; inx--) {
	        if(isUpper == false ) {
	            if( _g_senderList[inx].organ_id == diSenderCode ) {
	                selOrganID = _g_senderList[inx].upper_organ_id;
	                if(inx == 0 ) selOrganID = diSenderCode  ;
	                isUpper = true ;
	                continue ;
	            }
	        }else {
	            if( _g_senderList[inx].organ_id == selOrganID ) {
	                if( _g_senderList[inx].content_type == "D" ) {
	                    selOrganID =  _g_senderList[inx].upper_organ_id ;
	                 
	                }else if (_g_senderList[inx].content_type == "O" ) {
	                    break;
	                }
	            }
	        }
	        if( inx == 0 ) selOrganID = "" ;
	   }
	   return  selOrganID ;
	}, 
	setSenderList : function(senderList) {
		_g_senderList = $.parseJSON(senderList) ;
	},
	setSenderName : function () {
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	    var rowNum = objCurrentTabNumber.length ;
		var lastApprovalDeptID = $("#lastApprovalDeptID").val();
		var diSenderCode = "" ;
		var selDocTypeCode = "" ;
		var selOrganID = "";
		var selSenderName = "" ;
		
		for( var inx = 0 ; inx < rowNum; inx++) {
			curTabNumber = parseInt(objCurrentTabNumber[inx].value);
			diSenderCode = $("#diSenderCode_"+curTabNumber).val();
			selDocTypeCode = $("input[name='docTypeCode_"+curTabNumber+"']:checked").val();
			
			selOrganID = "" ;
			selSenderName = "" ;
			
			if(	ncCom_Empty(diSenderCode) ){   
				if(ncCom_Empty(lastApprovalDeptID)) {
					if ( document.getElementsByName("deptID").length >  0 ) { 
						lastApprovalDeptID =  document.getElementsByName("deptID")[0].value  ;
					}
				}
				selOrganID = commonApproval.selectedSender(lastApprovalDeptID); //기관id 를 조회 한다.
				if( !ncCom_Empty(selOrganID) ) {
					if(selDocTypeCode == "001" ) { //발신인명의가 선택 안되어있고 최종 결재자 부서의 발신명의로 한다.
						diSenderCode =  lastApprovalDeptID ;
						selSenderName = commonApproval.getSenderName(lastApprovalDeptID) ;
					}else  if ( selDocTypeCode == "002" || selDocTypeCode == "004" ){  //발신인명의가 선택 안되어있고 대내문서가 아니면 기관명을 발신인명으로 한다.
	             	    diSenderCode =  selOrganID ;
	                    selSenderName = commonApproval.getSenderName(selOrganID) ;
	             	}
	             }
				$("#selOrganID_"+curTabNumber).val(selOrganID);
				$("#diSenderCode_"+curTabNumber).val(diSenderCode);
				$("#selSenderName_"+curTabNumber).val(selSenderName);	
			}else {
				if( !( selDocTypeCode == "001" ||  selDocTypeCode == "002" || selDocTypeCode == "004" ) ) {
					$("#selOrganID_"+curTabNumber).val("");
					$("#diSenderCode_"+curTabNumber).val("");
					$("#selSenderName_"+curTabNumber).val("");
				}
			}
		}
	},
	//문서 상세보기 보기, 숨기기
	chngFolder:function(tabNumber) {
		if ($("#draftSubjectOff_"+tabNumber).css('display') == "none") {
			$("#draftSubjectOn_"+tabNumber).hide();
			$("#draftSubjectOff_"+tabNumber).show();
			$("#draftSubjectOn2_"+tabNumber).hide();
			//$("#draftSubjectOn_"+tabNumber).slideUp(0);
			commonApproval.chngHwpHeight(tabNumber);
		}else {

			$("#draftSubjectOn_"+tabNumber).show();
			$("#draftSubjectOff_"+tabNumber).hide();
			$("#draftSubjectOn2_"+tabNumber).show();
			//$("#draftSubjectOn_"+tabNumber).slideDown(0);

		}
		var hwpCtrl =  document.getElementById("HwpCtrl_"+tabNumber) ;
    	_InitToolBarJS(hwpCtrl);
	},
	
	hwpCtrHeight: function () {
    	var browseHeight= 460;
    	browseHeight =document.documentElement.clientHeight;
    	browseHeight = browseHeight - _g_bagicHeight ;

        if(browseHeight < 460 ) browseHeight = 460;
        return browseHeight ;
	},
    chngHwpHeight: function(tabNumber) {
    	var display = $("#draftSubjectOn_"+tabNumber).css('display');
    	//alert(display);
    	if (display != undefined && display != "none")  return ;
		var height2 = commonApproval.hwpCtrHeight();
    	var hwpCtrl =  document.getElementById("HwpCtrl_"+tabNumber) ;
        hwpCtrl.style.height = height2+"px" ;
    },
    /**********************************************************************************************/
	/****************************************연속결재*********************************************/
	/**********************************************************************************************/
    sequenceDocApprovalView: function() {
    	var arrDiKeyCode = document.getElementsByName("sequenceDiKeyCode");
		var param = "" ;
		var rowNum = arrDiKeyCode.length ;
		if( rowNum == 0 )  {
			if(_g_docApprovalClosedYN == "Y") self.close();
			return ; 
		}
		
		if(!confirm("다음 결재 문서가 있습니다. 결재 하시겠습니까?"))  {
			if(_g_docApprovalClosedYN == "Y") self.close();
			return ;
		}
		
		param= "multiViewYN=Y";
		for(var inx = 0; inx < rowNum; inx++) {
			if( inx == 0 ) {
				param += "&diKeyCode="+arrDiKeyCode[inx].value ;
			}else {
				param += "&sequenceDiKeyCode="+arrDiKeyCode[inx].value;
			}
		}
		var url = getContextPath()+"/edoc/eapproval/docCommonDraftView.do?"+ param;
		document.location.href = url;
    }, 
    /**********************************************************************************************/
	/***********************수정여부를 초기화셋팅(modified 를 0으로)*********************************/
	/**********************************************************************************************/    
    hwpNonModified: function() {
    	if(_g_nonElecYN == "Y") return ;
    	var hwpCtrl;
	   	var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
	    var rowNum = objCurrentTabNumber.length ;
	  
	    for(var inx = 0 ; inx < rowNum;  inx++ ) {
	    	tabNumber = objCurrentTabNumber[inx].value ;
	    	if( $("#approvalKlEditFlag_"+tabNumber).val() == "N" ) {
	    		hwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
		    	try {
		    		hwpCtrl.Save();
		    	}catch(e){console.log(e);//오류 상황 대응 부재
		    	}
	    	}
	    }    	
    },    
    /**********************************************************************************************/
	/***********************한글문서 view 위치를 TOP으로 지정**************************************/
	/**********************************************************************************************/    
    hwpTopView: function(argTabNumber) {
    	var hwpCtrl;
    	var tabNumber ;
    	if(ncCom_Empty(argTabNumber)) {
		   	var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		    var rowNum = objCurrentTabNumber.length ;
		  
		    for(var inx = 0 ; inx < rowNum;  inx++ ) {
		    	tabNumber = objCurrentTabNumber[inx].value ;
		    	hwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
		    	hwpCtrl.MovePos(2);
		    }    	
    	}else {
    		tabNumber = argTabNumber;
        	hwpCtrl =   document.getElementById("HwpCtrl_"+ tabNumber) ;
	    	hwpCtrl.MovePos(2);
    	}
    },
/***************************************************************************************/
/***********************************CALL BACK 함수 *************************************/
/***************************************************************************************/
	//비밀번호 비교한후 호출하는 함수
	approvalPasswordCallBack : function(errorCode,paramCurDate) {
		switch(errorCode) {
			case 0 :
				//commonApproval.main(_g_approvalAction, data.klUserType, data.selectedCnt, data.isApprovalLast, data.curDate, data.docNumList );
				//commonApproval.main(_g_approvalAction, data.klUserType, data.selectedCnt, data.isApprovalLast, data.curDate);
				commonApproval.main(_g_approvalAction, paramCurDate);
				break;
			case 1001 :
				commonApproval.loadingEnd();
				_g_isProcess = false ;
				alert("비밀번호 오류입니다.");
				break;
			case 1002 :
				commonApproval.loadingEnd();
				_g_isProcess = false ;
				alert("비밀번호 오류입니다.");
				break;
			case 9999 :
				commonApproval.loadingEnd();
				_g_isProcess = false ;
				alert("시스템 에러입니다. 관리자한테 문의 하세요.");
				break;
			default :
				commonApproval.loadingEnd();
				_g_isProcess = false ;
				alert("시스템 에러입니다. 관리자한테 문의 하세요.");
				break;
		}
	},   
	//의견 저장 callBack
	insertOpinionCallBack: function(data) {
		switch(data.errorCode) {
			case 0 :
				alert("의견이 저장되었습니다.");
				var tabNumber = $("#showTabNumber").val();
				$("#dmMemo_"+tabNumber).val("");
				commonApproval.main('LIST_OPINION');

				break;
			case 1001 :
				alert("문서 코드가 없습니다.");
				break;
			case 1002 :
				alert("메모명이 없습니다.");
				break;
			case 9999 :
				alert("시스템 에러입니다. 관리자한테 문의 하세요.");
				break;
		}
	},
	//의견리스트
	opinionListCallBack: function(data) {
		var list ;
		var rowNum= 0 ;
		var userKey = _g_userKeyCode ;
		if( data != "" && data.list != undefined) {
			list = data.list ;
			rowNum = list.length ;
		}
		var listHtml = "" ;
		var tabNumber = $("#showTabNumber").val();
		for(var inx = 0 ; inx < rowNum; inx++  ) {
			listHtml += "<li>";
			if( list[inx].c_klreturnflag == '1') {
				listHtml += "<p><span><strong>"+list[inx].user_nm+"</strong> |</span> [반려]&nbsp;"+list[inx].c_dmmemo+"</p> ";
				listHtml += "<p class=\"date\">"+list[inx].convertWriteDate
			}else {
				listHtml += "<p><span><strong>"+list[inx].user_nm+"</strong> |</span>"+list[inx].c_dmmemo+"</p> ";
				listHtml += "<p class=\"date\">"+list[inx].convertWriteDate
				if(list[inx].c_dmwriteuserkey == userKey   ) {
					listHtml += "<a href=\"#none\" onClick= \"commonApproval.main('DELETE_OPINION', '"+list[inx].c_dmwritedate+"');\" >&nbsp;<img src=\""+_g_contextPath+"/images/btn/btn_commentDel.gif\" width=\"13\" height=\"13\" alt=\"삭제\" /></a>";
				}
			}
			listHtml += "</p>";
			listHtml += "</li>";
		}
		$("#listOpinion_"+tabNumber).html(listHtml);
		$("#opinionCnt_"+tabNumber).html(rowNum+"건");
	},
	//의견삭제
	deleteOpinionCallBack: function(data) {
		switch(data.errorCode) {
			case 0 :
				alert("의견이 삭제되었습니다.");
				commonApproval.main('LIST_OPINION');
				break;
			case 1001 :
				alert("문서 코드가 없습니다.");
				break;
			case 1002 :
				alert("본인 의견만 삭제 가능합니다.");
				break;
			case 9999 :
				alert("시스템 에러입니다. 관리자한테 문의 하세요.");
				break;
		}
	},
	//문서정보를 저장한후 호출하는 함수
	insertDocInfoCallBack :  function (errorCode, isClosed, liKeyCode, iuMsg) {
		errorCode = parseInt(errorCode);
		commonApproval.loadingEnd();
		_g_isProcess = false ;
		var arrDiKeyCode = document.getElementsByName("sequenceDiKeyCode") ;
		var rowNum = arrDiKeyCode.length ;
		if(!ncCom_Empty(iuMsg)) {
			alert(iuMsg);
		}else {
			switch(errorCode) {
				case 0 :
					if(rowNum  == 0 ) alert("처리하였습니다.");
					try {
						opener.document.location.reload();
					} catch (e) {console.log(e);//오류 상황 대응 부재
					}
					try {
						opener.top.top_refresh();
					} catch (e) {console.log(e);//오류 상황 대응 부재
					}
					if(isClosed == "Y") {
						self.close();
					}else {
						var param= "firstApproval=N&multiViewYN=Y&liKeyCode="+liKeyCode;
						var uri = getContextPath()+"/edoc/eapproval/docCommonDraftView.do?"+ param;
						document.location.href = uri;
					}
					break;
				case 1001 :
					alert("문서명이 없습니다.");
					break;

				case 1002 :
					alert("결재라인이 없습니다.");
					break;

				case 1003 :
					alert("사용자 속성값 오류입니다.");
					break;

				case 1004 :
					alert("결재자가 너무많습니다.");
					break;

				case 1005 :
					alert("협의자가 너무많습니다.");
					break;

				case 1007 :
					alert("부분공개/비공개 여부는 구분번호를 선택해야 합니다.");
					break;

				case 1009 :
					alert("기록물철을 선택하세요.");
					break;
				case 8001 :
				case 8002 :
				case 8003 :
					alert("첨부파일 오류입니다.");
					break;
				case 9999 :
					alert("시스템 에러입니다. 관리자한테 문의 하세요.");
					break;
				default :
					alert("시스템 에러입니다. 관리자한테 문의 하세요.");
					break;

			}
		}
	},
	//문서정보를 저장한후 호출하는 함수
	copyDocInfoCallBack :  function (errorCode, diKeyCode) {
		errorCode = parseInt(errorCode);
		switch(errorCode) {
			case 0 :
				//alert("재기안 하였습니다.");
				opener.location.href = _g_contextPath+"/neos/edoc/eapproval/reportstoragebox/tempStorage.do";
				var param = "diKeyCode="+diKeyCode ;
				var pop = neosPopup("POP_DOCVIEW", param);
				if(!pop) {
					alert("팝업을 해제해 주세요.");
					return ;
				}
				
				self.close();
				break;
			case 9999 :
				alert("시스템 에러입니다. 관리자한테 문의 하세요.");
				break;
			default :
				alert("시스템 에러입니다. 관리자한테 문의 하세요.");
				break;

		}
	},
	updateApprovalSignCallBack : function(errorCode, isClosed, iuMsg, diKeyCode) {
		errorCode = parseInt(errorCode);
		_g_isProcess = false ;
		commonApproval.loadingEnd();
		var arrDiKeyCode = document.getElementsByName("sequenceDiKeyCode");
		var rowNum = arrDiKeyCode.length ;
		
		if(!ncCom_Empty(iuMsg)) {
			alert(iuMsg);
		}else {		
			switch(errorCode) {
				case 0 :
					if(rowNum == 0 ) alert("처리 하였습니다.");
					try { opener.document.location.reload(); } catch (e) {console.log(e);//오류 상황 대응 부재
					}
					try {
						opener.top.top_refresh();
					} catch (e) {console.log(e);//오류 상황 대응 부재
					}
					
					if( !ncCom_Empty(diKeyCode ) ) {
						var param = "firstApproval=N" ;
						
						for(var inx = 0; inx < rowNum; inx++) {
							param += "&sequenceDiKeyCode="+arrDiKeyCode[inx].value;
						}
						
						param += "&updateApprovalSign=1&multiViewYN=Y&diKeyCode="+diKeyCode;
						var uri = getContextPath()+"/edoc/eapproval/docCommonDraftView.do?"+ param;
						document.location.href = uri;
					}else {
						if(isClosed == "Y") self.close();
					}
					break;
				case 1001 :
					alert("문서명이 없습니다.");
					break;
	
				case 1002 :
					alert("결재라인이 없습니다.");
					break;
				case 8001 :
				case 8002 :
				case 8003 :
					alert("첨부파일 오류입니다.");
					break;
				case 9999 :
					alert("시스템 에러입니다. 관리자한테 문의 하세요.");
					break;
				default :
					alert("시스템 에러입니다. 관리자한테 문의 하세요.");
					break;
			}
		}
	},
	
	pdfViewr:function(no, path) {
		//<script language="javascript">pdfViewr('1','HTTP://그룹웨어주소/pdf주소');</script>
		  var cont = '';
	 
	    cont = '<OBJECT CLASSID="clsid:CA8A9780-280D-11CF-A24D-444553540000" ID="PDFViewer'+no+'" width="100%" style="width:100%;height:880px" border=1 >'
	            + '<param name="src" value="'+path+'">'
	            + '<EMBED>PDF문서를 보시려면 Acrobat Reader를 설치하셔야 합니다.</EMBED>'
	            + '</OBJECT></br>';
	
/*
		  
	    cont = '<OBJECT data = "'+path+'" type="application/pdf" ID="PDFViewer'+no+'" width="100%" style="width:100%;height:880px" border=1  >'
        + '<param name="src" value="'+path+'">'
        + '<EMBED>PDF문서를 보시려면 Acrobat Reader를 설치하셔야 합니다.</EMBED>'
        + '</OBJECT></br>';
	*/    
	    document.write(cont);
	    
	    try{
	    	
	        document.getElementById("PDFViewer"+no).setShowToolbar(true);
	    }catch(e) {
	        alert(e);
	        alert('PDF문서를 보시려면 Acrobat Reader를 설치하셔야 합니다.');
	       
	    }
	}
}