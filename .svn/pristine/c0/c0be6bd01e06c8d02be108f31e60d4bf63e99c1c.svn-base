var _g_prefixApproval = "" ;
var _g_tiUseFlag = "" ;
var _g_contextPath = "" ;
var _g_serverName = "" ;
var _g_serverPort = "" ;
var _g_tiKeyCode = "" ;
var _g_diKeyCode = "" ;

var _g_tiLogo = "";
var _g_tiSymbol = "";
var _g_docCompany = "" ;
var _g_tiHeader = "" ;
var _g_tiFooter = "" ;
var _g_orgnztPostNumber = "" ;
var _g_orgnztSiteAddress = "" ;
var _g_orgnztHomepageURL= "" ;
var _g_orgnztFaxNO= "" ;
var _g_orgnztEmail= "" ;
var _g_orgnztTelephoneNO = "" ;
var _g_orgnztName = "" ;

var _g_approvalAction = "INSERT_APPRVLINE" ;
var _g_editType = "0" ;
var _g_curTabNumber = "" ;

var _g_colSymbol = "_COL_" ;
var _g_rowSymbol = "_ROW_";
var _g_isProcess = false ;

lumpApproval = {
		isValid: function (arg1, arg2) {
				switch(arg1) {
					case 'INSERT_APPRVLINE' :
						var curTabNumber  ;
						var frm =document.frmMain;
				        var imsiOpenGrade =  new Number(0);

				    	if(frm.esntlID == undefined ) {
				    		alert("결재라인을  지정하세요.");
				    		commonApproval.pop('POP_APPROVALLINE');
				    		return false ;
				    	}
				    	var rowNum ;
				    	var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;

						var mainElements = document.forms["frmMain"].elements ;

						curTabNumber = parseInt(objCurrentTabNumber[0].value);
						_g_curTabNumber = curTabNumber ;

					    $("#dname_"+curTabNumber).val( $("#dname2_"+curTabNumber).val( ) );
					    if(ncCom_Empty($("#dname_"+curTabNumber).val())) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목을 입력하여 주십시오.");

					    //문서제목 체크
						if(fc_isIncludeEnterKey($("#dname_"+curTabNumber).val())) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목에 엔터키가 포함되어 있습니다.");

						// 제목에 특수문자 체크
						var r1 = new RegExp(getDocTitleExp());
						if(r1.test($("#dname_"+curTabNumber).val())) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목에 아래 예의 특수문자가 포함되어 있습니다.\n예) " + getExpKeyword(getDocTitleExp()));
						//문서제목 체크 끝
						var isChecked = false;
					    if ( mainElements["publicType_"+curTabNumber][1].status == true || mainElements["publicType_"+curTabNumber][2].status  == true ) {

						    rowNum =  mainElements["publicGradeCH_"+curTabNumber].length ;
						    for ( var inx = 0 ; inx < rowNum ; inx++ ) {
				                if (mainElements["publicGradeCH_"+curTabNumber][inx].checked == true ) {
				                    imsiOpenGrade = imsiOpenGrade + Number(mainElements["publicGradeCH_"+curTabNumber][inx].value);
				                    isChecked = true;
				                }
						    }
				            if ( isChecked == false ) {
				                alert("부분공개/비공개 여부는 구분번호를 선택해야 합니다");
				                return false;
				            }
					    } else if (mainElements["publicType_"+curTabNumber][0].status == true) {
					    	imsiOpenGrade = 0;
					    } else {
				            alert("공개여부를 체크해 주십시요!");
				        	return false;
					    }
					    mainElements["openGrade_"+curTabNumber].value = imsiOpenGrade;

				        if(ncCom_Empty($("#aiKeyCode_"+curTabNumber).val())) {
				    		alert("기록물 철을 선택하세요.");
				    		return false ;
				    	}

				    	break;

					case 'INSERT_TEMPAPPRVLINE' :

						var curTabNumber ;
				        var imsiOpenGrade =  new Number(0);
				        var seldocTypeCode;
				    	var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;

						var rowNum = 0 ;
						var mainElements = document.forms["frmMain"].elements ;

						curTabNumber = parseInt(objCurrentTabNumber[0].value);
						_g_curTabNumber = curTabNumber ;

						$("#dname_"+curTabNumber).val( $("#dname2_"+curTabNumber).val( ) );
						if(ncCom_Empty($("#dname_"+curTabNumber).val())) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목을 입력하여 주십시오.");
				        // 문서제목 체크
						if(fc_isIncludeEnterKey($("#dname_"+curTabNumber).val())) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목에 엔터키가 포함되어 있습니다.");


						// 제목에 특수문자 체크
						var r1 = new RegExp(getDocTitleExp());
						if(r1.test($("#dname_"+curTabNumber).val())) return ncCom_ErrField($("#dname2_"+curTabNumber), "문서제목에 아래 예의 특수문자가 포함되어 있습니다.\n예) " + getExpKeyword(getDocTitleExp()));

				        if ( mainElements["publicType_"+curTabNumber][1].status == true || mainElements["publicType_"+curTabNumber][2].status  == true ) {
				            var isChecked = false;
				            rowNum =  mainElements["publicGradeCH_"+curTabNumber].length ;
				            for ( var inx = 0 ; inx < rowNum ; inx++ ) {
				                if (mainElements["publicGradeCH_"+curTabNumber][inx].checked == true ) {
				                    imsiOpenGrade = imsiOpenGrade + Number(mainElements["publicGradeCH_"+curTabNumber][inx].value);
				                    isChecked = true;
				                }
				            }
				            if ( isChecked == false ) {
				                alert("부분공개/비공개 여부는 구분번호를 선택해야 합니다");
				                return false;
				            }
				        } else if (mainElements["publicType_"+curTabNumber][0].status == true) {
				            imsiOpenGrade = 0;
				        } else {
				            alert("공개여부를 체크해 주십시요!");
				        	return false;
				        }

					    mainElements["openGrade_"+curTabNumber].value = imsiOpenGrade;
				    	break;

				}
				return true ;
		},
		setHwpFileName : function (arrDestFileName) {
			var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
			var rowNum = objCurrentTabNumber.length ;
			var arrDocFileName = arrDestFileName[0].split(_g_colSymbol);
			var arrImageFileNameRow = arrDestFileName[1].split(_g_rowSymbol);
			var arrImageFileNameCol ;
			for( var inx = 0 ; inx < rowNum; inx++ ) {
				$("#docFileName_"+objCurrentTabNumber[inx].value).val(arrDocFileName[inx]);
			}
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
		//임시저장
		successTempUploadFile : function(arrDestFileName) {
			if (_g_isProcess == true ) {
				commonApproval.loadingEnd();
				return ;
			}else {
				commonApproval.loadingStart();
				_g_isProcess = true ;
			}
			lumpApproval.setHwpFileName(arrDestFileName);
			///edoc/eapproval/docTempApprovalLumpUpload.do
			frmMain.action = _g_contextPath+"/edoc/eapproval/docTempApprovalInsert.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
		},
		main : function(arg1, arg2, arg3, arg4, arg5, arg6, arg7 ) {
			switch(arg1) {
				case 'INSERT_TEMPAPPRVLINE' : // 임시저장
					if(!lumpApproval.isValid("INSERT_TEMPAPPRVLINE")) {
						lumpApproval.openFolder("1");
						return ;
					}
					commonApproval.setApprovalLineToHwp();
					commonApproval.docInfoToHwp(); //문서항목 hwp 로 저장
					var arrFileName = commonApproval.docFileUpload(_g_contextPath+"/edoc/eapproval/docTempApprovalLumpUpload.do");
					if(arrFileName == false ) return ;
					lumpApproval.successTempUploadFile(arrFileName);
					break;
				case 'APPLY_DOCHWP' :
					commonApproval.setApprovalLineToHwp();
					commonApproval.docInfoToHwp(); //문서항목 hwp 로 저장
					break;
				case 'SINGLE_APPLY_DOCHWP' :
					commonApproval.docInfoToHwp();
					commonApproval.chngFolder("1");
					break;
			}
		},
		
		pop : function(arg) {
			switch(arg) {
				case "POP_DOCSUMMARY" : //문서요약 팝업
					var showTabNumber =  $("#showTabNumber").val();
					$("#docSummary").val($("#docSummary_"+showTabNumber).val());
					$("#summaryDiKeyCode").val($("#summaryDiKeyCode_"+showTabNumber).val());
					openWindow2("",  "popDocSummary", 680, 530, 0) ;
					frmPop.target = "popDocSummary";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/EDocSummary.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case "POP_APPROVALSIGN" : //결재사인팝업
					if(_g_isProcess == true ) return ;
					if(!lumpApproval.isValid("INSERT_APPRVLINE")) {
						lumpApproval.openFolder("1");
						return ;
					}

					$("#isApprovalLast").val("0");
					commonApproval.setApprovalSignInfo();

					openWindow2("",  "popApprovalSign", 430, 370, 0) ;
					frmPop.target = "popApprovalSign";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/approvalSignLump.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case 'POP_ARCHIVE' : //서류철
					var showTabNumber =  $("#showTabNumber").val();
					var aiKeyCode = $("#aiKeyCode_"+showTabNumber).val();
					var obj = {method : "lumpApproval.setArchive",
								c_aikeycode : aiKeyCode};

					NeosUtil.openPopArchive(obj);
					break;
				case 'POP_DESC' : //공개여부 설명
					var uri = _g_contextPath+"/edoc/eapproval/workflow/viewPrivateInfo.do" ;
					openWindow2(uri, "popPrivateInfo", 655, 700, 0) ;
					break;
				case 'POP_RECEIVER' : //수신자 목록
					var showTabNumber =  $("#showTabNumber").val();

					var value = $("input[name='docTypeCode_"+showTabNumber+"']:checked").val() ;
					var uri = "";
					var width = 650 ;
					var height = 510 ;
					uri = _g_contextPath+"/neos/edoc/document/record/popup/outterSelectPopup.do";
					openWindow2("",  "selectOrganView", width, height, 0) ;
					frmPop.c_sireceivecode.value =$("#arrSiReceiveCode_"+showTabNumber).val();
					frmPop.c_sireceivename.value = "";
					frmPop.sendername.value = $("#arrSiSenderName_"+showTabNumber).val();
					frmPop.inputId.value = 'upperOrganId';
					frmPop.methodName.value = 'lumpApproval.setReceive';
					frmPop.target = "selectOrganView";
					frmPop.action = uri;
					frmPop.submit();
					frmPop.target = "" ;
					break;
				case "POP_PREVIEWDOC" : //미리보기
					var showTabNumber =  $("#showTabNumber").val();
					var hwpCtrl = document.getElementById("HwpCtrl_"+showTabNumber);
					var filePath = lumpApproval.getHwpPath(showTabNumber);
					var fileName = rndStr("",10)+showTabNumber+".hwp";
					var filePathName  = filePath +fileName ;
					var isSave = false ;
					isSave = hwpCtrl.SaveAs(filePathName,"HWP","lock:false");
					if(!isSave) {
						alert("문서오류입니다.");
						return false ;
					}
					$("#localPathName_"+showTabNumber).val(filePathName);
					var uri = _g_contextPath+"/edoc/eapproval/workflow/docLumpPreviewPopup.do?showTabNumber="+showTabNumber;
					openWindow2(uri,  "popPreviewDoc"+showTabNumber, 994, 840, 0,1) ;
					break;
				case "POP_DOCEDITLIST" : //문서 수정내역
					var showTabNumber =  $("#showTabNumber").val();
					var diKeyCode = $("#diKeyCode_"+showTabNumber).val();

					var param = "diKeyCode="+diKeyCode ;
					neosPopup("POP_DOCEDITLIST", param);
					break;
				case "POP_EDITRECORD" : //문서 수정 입력
					var uri = _g_contextPath+"/edoc/eapproval/workflow/docEditRecord.do";
					openWindow2(uri,  "popEditRecord", 430, 190, 0) ;
					break;

				case "POP_REFDOC" : //참조문서
					var showTabNumber =  "1";

					var width = 1074 ;
					var height = 540;
					var refDocNumber = "" ;
					var refDiKeyCode = ""  ;
					var refDiTitle = "" ;
					var refUserNm = "" ;
					var refRiRegYMD = "" ;
					var refDiFlag = "" ;
					var refDiDocFlagNm = "" ;
					var uri = _g_contextPath+"/edoc/eapproval/docRefDocInfo.do";

					openWindow2("",  "popRefDoc", width, height, 0) ;
					var rowNum =  document.getElementsByName("refDocNumber_"+showTabNumber).length ;
					var html = "";
					for(var inx = 0 ; inx < rowNum; inx++ ) {
						refDocNumber = document.getElementsByName("refDocNumber_"+showTabNumber)[inx].value ;
						refDiKeyCode = document.getElementsByName("refDiKeyCode_"+showTabNumber)[inx].value ;
		            	refDiTitle = document.getElementsByName("refDiTitle_"+showTabNumber)[inx].value ;
		            	refUserNm = document.getElementsByName("refUserNm_"+showTabNumber)[inx].value ;
		            	refRiRegYMD = document.getElementsByName("refRiRegYMD_"+showTabNumber)[inx].value ;
		            	refDiFlag = document.getElementsByName("refDiFlag_"+showTabNumber)[inx].value ;
		            	refDiDocFlagNm = document.getElementsByName("refDiDocFlagNm_"+showTabNumber)[inx].value ;
		            	html += "<input type = \"hidden\"  name = \"refDocNumber\" id = \"refDocNumber\" value = \""+refDocNumber+"\">"+
		                		"<input type = \"hidden\"  name = \"refDiKeyCode\" id = \"refDiKeyCode\" value = \""+refDiKeyCode+"\">"+
		                		"<input type = \"hidden\"  name = \"refDiTitle\" id = \"refDiTitle\" value = \""+refDiTitle+"\">"+
		                		"<input type = \"hidden\"  name = \"refUserNm\" id = \"refUserNm\" value = \""+refUserNm+"\">"+
		                		"<input type = \"hidden\"  name = \"refDiFlag\" id = \"refDiFlag\" value = \""+refDiFlag+"\">"+
		                		"<input type = \"hidden\"  name = \"refDiDocFlagNm\" id = \"refDiDocFlagNm\" value = \""+refDiDocFlagNm+"\">"+
		                		"<input type = \"hidden\"  name = \"refRiRegYMD\" id = \"refRiRegYMD\"  value = \""+refRiRegYMD+"\">" ;
					}

					$("#idPopRefDoc").html(html);
					$("#popShowTabNumber").val(showTabNumber);
					frmPop.target = "popRefDoc";
					frmPop.method = "post";
					frmPop.action = uri;
					frmPop.submit();
					frmPop.target = "";
					break;
			}
		},


		//기록물철셋팅
		setArchive:function(item) {
//			var obj = $.parseJSON(mdata);
			alert(item.seq);
			var showTabNumber =  $("#showTabNumber").val();
			if(!item) return;
			$("#aiKeyCode_"+showTabNumber).val(item.seq);
			if(item.name){
				$("#aiTitle_"+showTabNumber).val(item.name + " (" +item.reDate+ ")");
				$("#aiPreserve_"+showTabNumber).val(item.preserve);
				$("#preserveName_"+showTabNumber).val(item.reDate);
			}			
		},

		hwpPutText:function(strName, strValue) {
			var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
			var rowNum = objCurrentTabNumber.length ;
			var pHwpCtrl ;
			for( var inx = 0 ; inx < rowNum; inx++) {
				curTabNumber = parseInt(objCurrentTabNumber[inx].value);
				pHwpCtrl =  document.getElementById("HwpCtrl_"+curTabNumber) ;
				_hwpPutText(strName,  strValue, pHwpCtrl);
			}
		},
		//공개 비공개 토글
		publicGubunToggle:function(tabNumber) {
			var publicType = $("input[name='publicType_"+tabNumber+"']:checked").val() ;
	       	//공개
	       	if(publicType == "001") {
	       		$("#idKindNo_"+tabNumber).hide();
	       		$("#diOpen1_"+tabNumber).attr("disabled", false);
	       		$("#diOpen2_"+tabNumber).attr("disabled", false);
	       	} else if (publicType == "002" || publicType =="003") {
	       		$("#idKindNo_"+tabNumber).show();
	       		$("#diOpen1_"+tabNumber).attr("disabled", true);
	       		$("#diOpen2_"+tabNumber).attr("disabled", true);
	       		$("#diOpen2_"+tabNumber).attr("checked", true);

	       	} else {
	       		$("#idRadioHo_"+tabNumber).show();
	       	}
		},

		treatToggle : function(tabNumber) {
			 var value = $("input[name='docTypeCode_"+tabNumber+"']:checked").val() ;
	       	//내부결재
	       	if(value == "000" ) {
	       		$("#idReceiver_"+tabNumber).hide();
	       		$("#idCustomReceiver_"+tabNumber).hide();
	       		$("#idPass_"+tabNumber).hide();
	       		$("#idAddress_"+tabNumber).hide();
	       		$("#idInfoOpen_"+tabNumber).hide();

	       	} else if (value =="001" || value == "002" ) { //대내문서, 대외문서
	       		$("#idReceiver_"+tabNumber).show();
	       		$("#idCustomReceiver_"+tabNumber).show();
	       		$("#idPass_"+tabNumber).hide();
	       		$("#idAddress_"+tabNumber).hide();
	       		$("#idInfoOpen_"+tabNumber).show();

	  			$("#susinjaView_"+tabNumber).val("");
				$("#idApprvLineReceive_"+tabNumber).html("");
				$("#arrSiReceiveCode_"+tabNumber).val("");
				$("#arrSiSenderName_"+tabNumber).val("");

	       	} else if( value == "003" ) {  //민원문서
	       		$("#idReceiver_"+tabNumber).hide();
	       		$("#idCustomReceiver_"+tabNumber).hide();
	       		$("#idPass_"+tabNumber).hide();
	       		$("#idAddress_"+tabNumber).show();
	       		$("#idInfoOpen_"+tabNumber).show();

	       	} else if( value == "004") { //경유문서
	       		$("#idReceiver_"+tabNumber).show();
	       		$("#idCustomReceiver_"+tabNumber).show();
	       		$("#idPass_"+tabNumber).show();
	       		$("#idAddress_"+tabNumber).hide();
	       		$("#idInfoOpen_"+tabNumber).show();

	       	}
		},

		//문서 취급시 제어
		treateControl:function(tabNumber) {
	        var value  = "001";
	        var frm = document.forms[0];
	        var objDocTypeCode = document.getElementsByName("docTypeCode_"+tabNumber) ;
	        //전산망
			if(value == '001') {
				$("#docTypeCode1_"+tabNumber ).attr("disabled", false);
			 	$("#docTypeCode2_"+tabNumber).attr("disabled", false);
			 	$("#docTypeCode3_"+tabNumber).attr("disabled", false);
			 	$("#docTypeCode4_"+tabNumber).attr("disabled", false);
				$("#docTypeCode5_"+tabNumber).attr("disabled", false);
	            if (objDocTypeCode[0].checked)
	            	lumpApproval.treatToggle(tabNumber);
	            else
	            	lumpApproval.treatToggle(tabNumber);

	        }else if(value == '007') { //게시
				$("#docTypeCode1_"+tabNumber).attr("disabled", true);
			 	$("#docTypeCode2_"+tabNumber).attr("disabled", false);
			 	$("#docTypeCode3_"+tabNumber).attr("disabled", true);
			 	$("#docTypeCode4_"+tabNumber).attr("disabled", true);
			 	$("#docTypeCode5_"+tabNumber).attr("disabled", true);

			 	$("#docTypeCode2_"+tabNumber).attr("checked", true);
			 	lumpApproval.treatToggle(tabNumber);
	        } else { // 기타
				$("#docTypeCode1_"+tabNumber).attr("disabled", true);
			 	$("#docTypeCode2_"+tabNumber).attr("disabled", false);
			 	$("#docTypeCode3_"+tabNumber).attr("disabled", false);
			 	$("#docTypeCode4_"+tabNumber).attr("disabled", false);
			 	$("#docTypeCode5_"+tabNumber).attr("disabled", false);

			 	var  docTypeCodeCheckedInx = 0 ;
			 	var  docTypeCodeCheckedCnt = "1" ;
			 	for(var inx = 0 ; inx < objDocTypeCode.length; inx++) {
			 		if ( objDocTypeCode[inx].checked ) {
			 			docTypeCodeCheckedInx = inx ;
			 			break;
			 		}
			 	}
			 	
			 	if ( docTypeCodeCheckedInx == 0 ) {
			 		docTypeCodeCheckedCnt = "2";
			 	}else {
			 		docTypeCodeCheckedCnt = docTypeCodeCheckedInx + 1 ;
			 	}
			 	
			 	$("#docTypeCode"+docTypeCodeCheckedCnt+"_"+tabNumber).attr("checked", true);
			 	lumpApproval.treatToggle(tabNumber);
	        }
		},

		chngAttachFile:function() {
			var showTabNumber = $("#showTabNumber").val();
			if ($("#idAttachFile_"+showTabNumber).css('display') == "none") {
				$("#idAttachFileText_"+showTabNumber).html("첨부파일닫기");
				$("#idAttachFile_"+showTabNumber).slideDown();
				//$("#idAttachFile").show();
			}else {
				$("#idAttachFileText_"+showTabNumber).html("첨부파일보기");
				$("#idAttachFile_"+showTabNumber).slideUp();
				//$("#idAttachFile").hide();
			}
		},


		//의견 저장
		insertOpinionCallBack: function(data) {
			switch(data.errorCode) {
				case 0 :
					alert("의견이 저장되었습니다.");
					var tabNumber = $("#showTabNumber").val();
					$("#dmMemo_"+tabNumber).val("");
					lumpApproval.main('LIST_OPINION');

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

		getHwpPath:function(tabNumber) {
			var filePath = "" ;
			var hwpCtrl = document.getElementById("HwpCtrl_"+tabNumber);
			var filePathName = hwpCtrl.Path() ;
			var point = filePathName.lastIndexOf("\\") ;

			filePath = filePathName.substring(0,point+1);
			return filePath ;
		},
		VIEW_BACKUP_HWPSTART : function(serverName, serverPort, diKeyCode, userKeyCode) {
	    	_pHwpCtrl = HwpControl.HwpCtrl;
		    _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

	    	if (!_VerifyVersion()) {
		  		_pHwpCtrl = null;
		  	   	return;
		  	}
	    	//_pHwpCtrl.SetClientName("DEBUG"); //For debug message
		   	_InitToolBarJS();
			var path = "http://"+serverName+":"+serverPort+_g_contextPath+"/edoc/eapproval/workflow/docDownload.do?randomKey="+rndStr("",13)+"&backupYN=Y&diKeyCode="+diKeyCode+"&userKeyCode="+userKeyCode ;
		   	if(!HwpControl.HwpCtrl.Open(path,"")){
		   		alert("파일 오픈실패!");
		   		//return;
		   	};
		   	_pHwpCtrl.MovePos(2);
		   	_pHwpCtrl.EditMode = 0 ; //읽기전용
	    },
	    PREVIEW_DOC_HWPSTART : function (path, hwpCtrl) {
	    	hwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

	    	if (!_VerifyVersion(hwpCtrl)) {
	    		hwpCtrl = null;
		  	   	return;
		  	}
	    	//hwpCtrl.SetClientName("DEBUG"); //For debug message
		   	if(!hwpCtrl.Open(path,"")){
		   		alert("파일 오픈실패!");
		   		//return;
		   	};
		   	hwpCtrl.EditMode = 0 ;
		 //  	hwpCtrl.run("FilePreview");
		 //  	hwpCtrl.PreviewCommand(15);
		 //  	hwpCtrl.MovePos(2);
	    },
		openFolder:function(tabNumber) {
			if ($("#draftSubjectOff_"+tabNumber).css('display') != "none") {
				$("#draftSubjectOff_"+tabNumber).hide();
				$("#draftSubjectOn2_"+tabNumber).show();
				$("#draftSubjectOn_"+tabNumber).slideDown(0);

			}
			//lumpApproval.chngHwpHeight(tabNumber);
		},	    
	    delFile : function(aiSeqNum, tabNumber) {
	    	$("#idDelFile").append("<input type = 'hidden' name = 'delAiSeqNum_"+tabNumber+"' value = '"+aiSeqNum+"'>");

	    	$("#idDelAiSeq"+aiSeqNum+"_"+tabNumber).remove();
	    },
		docEditMode :function(editMode) {
			var pHwpCtrl = document.getElementById("HwpCtrl_1") ;
			
			if(pHwpCtrl.FieldExist("_F_CONTENTS_")) {
				pHwpCtrl.EditMode = 2 ;
			}else {
				pHwpCtrl.EditMode = 1 ;
			}
		}
}