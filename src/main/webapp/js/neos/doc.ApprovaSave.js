
var _g_contextPath = "" ;
var _g_serverName = "" ;
var _g_serverPort = "" ;
var _g_tiKeyCode = "" ;
var _g_tiLogo = "";
var _g_tiSymbol = "";
var _g_docCompany = "" ;
var _g_tiHeader = "" ;
var _g_tiFooter = "" ;
var _g_treatmentCode = "" ;
var _g_docGradeCode = "" ;
var _g_docTypeCode = "" ;
var _g_secretGradeCode= "" ;
var _g_publicType = "" ;
var _g_diKeyCode = "" ;
var _g_userName = "" ;
var _g_orgnztPostNumber = "" ;
var _g_orgnztSiteAddress = "" ;
var _g_orgnztHomepageURL= "" ;
var _g_orgnztTelephoneNO= "" ;
var _g_orgnztFaxNO= "" ;
var _g_orgnztEmail= "" ;
var _g_approvalAction = "INSERT_APPRVLINE" ;
var _g_userKeyCode = "" ;
var _g_arrKlUserType004 ;
var _g_arrKlUserType002 ;
var _g_editType = "0" ;
approvalSave = {

		INIT_INSERT : function (serverName, serverPort, tiKeyCode) {
			_g_serverName = serverName ;
			_g_serverPort = serverPort ;
			_g_tiKeyCode = tiKeyCode ;
			approvalSave.hwpStart(); //문서 초기화

			$("#idKindNo").hide();  //구분번호 숨김
			$("#idReceiver").hide(); // 수신자 숨김
			$("#idAddress").hide(); //주소 숨김
			$("#idPass").hide(); //경로 숨김
			$("#idInfoOpen").hide(); //홈페이지 공개여부 숨김
			$("#idUnfolder").hide();
			$("#idFolder").show();
			$("#idAttachFile").hide(); //숨김
			$("#zipcode1, #zipcode2").numeric(); //우편번호 숫자만 입력가능

			$("#idImgUnfolder").click(function() {
				approvalSave.chngFolder();
			});
			$("#idImgFolder").click(function() {
				approvalSave.chngFolder();
			});
			approvalSave.getDocInfo(); // 문서정보 입력
		},
		INIT_EDIT : function (serverName, serverPort, diKeycode) {
			_g_serverName = serverName ;
			_g_serverPort = serverPort ;
			_g_diKeyCode = diKeycode ;
			approvalSave.EDIT_HWPSTART(); //문서 초기화

			$("#idKindNo").hide();  //구분번호 숨김
			$("#idReceiver").hide(); // 수신자 숨김
			$("#idCustomReceiver").hide();
			$("#idAddress").hide(); //주소 숨김
			$("#idPass").hide(); //경로 숨김
			$("#idInfoOpen").hide(); //홈페이지 공개여부 숨김
			$("#idAttachFile").hide(); //숨김
			$("#zipcode1, #zipcode2").numeric(); //우편번호 숫자만 입력가능

			$("#idImgUnfolder").click(function() {
				approvalSave.chngFolder();
			});
			$("#idImgFolder").click(function() {
				approvalSave.chngFolder();
			});
			approvalSave.getDocInfo(); // 문서정보 입력
		},
		INIT_VIEW : function (serverName, serverPort, diKeycode) {
			_g_serverName = serverName ;
			_g_serverPort = serverPort ;
			_g_diKeyCode = diKeycode ;
			_g_approvalAction = "INSERT_VIEWAPPRVLINE";
			approvalSave.EDIT_HWPSTART(); //문서 초기화
		},
		isValid: function (arg1, arg2) {
				switch(arg1) {
					case 'INSERT_OPINION':
						if(ncCom_Empty($("#dmMemo").val() )) return ncCom_ErrField($("#dmMemo"), "결재 특이 사항을 입력하세요.");
						break;

					case 'POP_VIEWAPPROVALSIGN' :
						var frm =document.frmMain;
						if(frm.esntlID == undefined ) {
				    		alert("결재라인을  지정하세요.");
				    		return false ;
				    	}
						break;
					case 'INSERT_APPRVLINE' :
						var frm =document.frmMain;
				        var imsiOpenGrade =  new Number(0);
				        var seldocTypeCode;
				    	var rowNum = 0 ;
				    	if(frm.esntlID == undefined ) {
				    		alert("결재라인을  지정하세요.");
				    		approvalSave.pop('POP_APPROVALLINE');
				    		 return false ;
				    	}
				    	$("#dname").val( $("#dname2").val( ) );
				        if(ncCom_Empty($("#dname").val()) ) return ncCom_ErrField($("#dname2"), "문서제목을 입력하여 주십시오.");

				        // 문서제목 체크
						if(fc_isIncludeEnterKey($("#dname").val()))  return ncCom_ErrField($("#dname2"), "문서제목에 엔터키가 포함되어 있습니다.");

						// 제목에 특수문자 체크
						var r1 = new RegExp(getDocTitleExp());
						if(r1.test($("#dname").val())) return ncCom_ErrField($("#dname2"), "문서제목에 아래 예의 특수문자가 포함되어 있습니다.\n예) " + getExpKeyword(getDocTitleExp()));


						// 문서제목 체크 끝
				        if ( frm.publicType[1].status == true || frm.publicType[2].status == true ) {
				            var isChecked = false;
				            rowNum = frm.publicGradeCH.length;
				            for ( var inx = 0 ; inx < rowNum ; inx++ ) {
				                if ( frm.publicGradeCH[inx].checked == true ) {
				                    imsiOpenGrade = imsiOpenGrade + Number(frm.publicGradeCH[inx].value);
				                    isChecked = true;
				                }
				            }
				            if ( isChecked == false ) {
				                alert("부분공개/비공개 여부는 구분번호를 선택해야 합니다");
				                return false;
				            }
				        } else if (frm.publicType[0].status == true) {
				            imsiOpenGrade = 0;
				        } else {
				            alert("공개여부를 체크해 주십시요!");
				        	return false;
				        }

				        frm.openGrade.value = imsiOpenGrade;

				        var treatmentsCodeCheck = "false";
				        rowNum = frm.treatmentCode.length;
				        for ( var inx = 0 ; inx < rowNum ; inx++ ) {
				            if ( frm.treatmentCode[inx].checked == true ) {
				                treatmentsCodeCheck = "true";
				                break;
				            }
				        }

				        //묶음기안문이면 전산망으로만 작성이 가능하므로 선택할 수 있는 취급이 없다.
				        if(frm.templateType.value == '007' ) {
					        treatmentsCodeCheck = "true";
				        }

				        if (treatmentsCodeCheck ==  "false") {
				            alert("문서취급을 선택해 주시기 바랍니다");
				            return false;
				        }

				        seldocTypeCode = $("input[name='docTypeCode']:checked").val();

				        // 내부결재
				        if(seldocTypeCode == "000"){
				        	approvalSave.initReceive();// 수신자초기화
				            frm.viaPath.value = "";
				            frm.zipcode1.value = "";
				            frm.zipcode2.value = "";
				            frm.address.value = "";
				            frm.civilUserName.value = "";
				            frm.civilEmail.value = "";
				        }
				        // 대내결재 || 대외결재
				        else if(seldocTypeCode == "001" ||seldocTypeCode == "002"){
				            frm.viaPath.value = "";
				            frm.zipcode1.value = "";
				            frm.zipcode2.value = "";
				            frm.address.value = "";
				            frm.civilUserName.value = "";
				            frm.civilEmail.value = "";
				            if(ncCom_Empty($("#susinjaView").val())) {
				                alert("수신처를 지정해주십시요.");
				                return false;
				            }
				        }
				        // 민원
				        else if(seldocTypeCode == "003"){
				        	approvalSave.initReceive();// 수신자초기화
				            frm.viaPath.value = "";

				        	if(ncCom_Empty(frm.zipcode1.value) ) return ncCom_ErrField(frm.zipcode1, "우편번호를 지정해주십시요.");
				            if(ncCom_Empty(frm.zipcode2.value) ) return ncCom_ErrField(frm.zipcode2, "우편번호를 지정해주십시요.");
				            if(ncCom_Empty(frm.address.value) ) return ncCom_ErrField(frm.address, "주소를 지정해주십시요.");
				            if(ncCom_Empty(frm.civilUserName.value) ) return ncCom_ErrField(frm.civilUserName, "민원인명을 입력해주십시요.");
				            if(frm.civilUserName.value.length > 30 ) return ncCom_ErrField(frm.civilUserName, "민원인명은 30자이내로 입력해주십시요.");
				            if(frm.civilEmail.value.length > 50 ) return ncCom_ErrField(frm.civilEmail, "민원인 Email은 50자이내로 입력해주십시요.");

				         //   frm.civilUserName.value = frm.civilUserName.value + " " + approvalSave.getSuffix();
				        }
				        //경유
				        else if(seldocTypeCode == "004"){
				            frm.zipcode1.value = "";
				            frm.zipcode2.value = "";
				            frm.address.value = "";
				            frm.civilUserName.value = "";
				            frm.civilEmail.value = "";

				            if(ncCom_Empty($("#susinjaView").val())) {
				                alert("수신처를 지정해주십시요.");
				                return false;
				            }

				            if(ncCom_Empty(frm.viaPath.value) ) return ncCom_ErrField(frm.viaPath, "경유지를 입력해주십시요.");

				        } else {
				            return false;
				        }
				    	if(ncCom_Empty(frm.aiKeyCode.value)) {
				    		alert("기록물 철을 선택하세요.");
				    		return false ;
				    	}
				    	break;

					case 'INSERT_TEMPAPPRVLINE' :

				        var frm =document.frmMain;
				        var imsiOpenGrade =  new Number(0);
				        var seldocTypeCode;
				    	var rowNum = 0 ;
				    	$("#dname").val( $("#dname2").val( ) );
				        if(ncCom_Empty($("#dname").val()) ) return ncCom_ErrField($("#dname2"), "문서제목을 입력하여 주십시오.");

				        // 문서제목 체크
						if(fc_isIncludeEnterKey($("#dname").val()))  return ncCom_ErrField($("#dname2"), "문서제목에 엔터키가 포함되어 있습니다.");

						// 제목에 특수문자 체크
						var r1 = new RegExp(getDocTitleExp());
						if(r1.test($("#dname").val())) return ncCom_ErrField($("#dname2"), "문서제목에 아래 예의 특수문자가 포함되어 있습니다.\n예) " + getExpKeyword(getDocTitleExp()));


						// 문서제목 체크 끝
				        if ( frm.publicType[1].status == true || frm.publicType[2].status == true ) {
				            var isChecked = false;
				            rowNum = frm.publicGradeCH.length;
				            for ( var inx = 0 ; inx < rowNum ; inx++ ) {
				                if ( frm.publicGradeCH[inx].checked == true ) {
				                    imsiOpenGrade = imsiOpenGrade + Number(frm.publicGradeCH[inx].value);
				                    isChecked = true;
				                }
				            }
				            if ( isChecked == false ) {
				                alert("부분공개/비공개 여부는 구분번호를 선택해야 합니다");
				                return false;
				            }
				        } else if (frm.publicType[0].status == true) {
				            imsiOpenGrade = 0;
				        } else {
				            alert("공개여부를 체크해 주십시요!");
				        	return false;
				        }

				        frm.openGrade.value = imsiOpenGrade;

				        var treatmentsCodeCheck = "false";
				        rowNum = frm.treatmentCode.length;
				        for ( var inx = 0 ; inx < rowNum ; inx++ ) {
				            if ( frm.treatmentCode[inx].checked == true ) {
				                treatmentsCodeCheck = "true";
				                break;
				            }
				        }

				        //묶음기안문이면 전산망으로만 작성이 가능하므로 선택할 수 있는 취급이 없다.
				        if(frm.templateType.value == '007' ) {
					        treatmentsCodeCheck = "true";
				        }

				        if (treatmentsCodeCheck ==  "false") {
				            alert("문서취급을 선택해 주시기 바랍니다");
				            return false;
				        }

				        seldocTypeCode = $("input[name='docTypeCode']:checked").val();

				        // 내부결재
				        if(seldocTypeCode == "000"){
				        	approvalSave.initReceive();// 수신자초기화
				            frm.viaPath.value = "";
				            frm.zipcode1.value = "";
				            frm.zipcode2.value = "";
				            frm.address.value = "";
				            frm.civilUserName.value = "";
				            frm.civilEmail.value = "";
				        }
				        // 대내결재 || 대외결재
				        else if(seldocTypeCode == "001" ||seldocTypeCode == "002"){
				            frm.viaPath.value = "";
				            frm.zipcode1.value = "";
				            frm.zipcode2.value = "";
				            frm.address.value = "";
				            frm.civilUserName.value = "";
				            frm.civilEmail.value = "";
				            if(ncCom_Empty($("#susinjaView").val())) {
				           //     alert("수신처를 지정해주십시요.");
				            //    return false;
				            }
				        }
				        // 민원
				        else if(seldocTypeCode == "003"){
				        	approvalSave.initReceive();// 수신자초기화
				            frm.viaPath.value = "";

			//	        	if(ncCom_Empty(frm.zipcode1.value) ) return ncCom_ErrField(frm.zipcode1, "우편번호를 지정해주십시요.");
			//	            if(ncCom_Empty(frm.zipcode2.value) ) return ncCom_ErrField(frm.zipcode2, "우편번호를 지정해주십시요.");
			//	            if(ncCom_Empty(frm.address.value) ) return ncCom_ErrField(frm.address, "주소를 지정해주십시요.");
				            if(ncCom_Empty(frm.civilUserName.value) ) return ncCom_ErrField(frm.civilUserName, "민원인명을 입력해주십시요.");
				            if(!ncCom_Empty(frm.civilUserName.value) )
				            	if(frm.civilUserName.value.length> 30 ) return ncCom_ErrField(frm.civilUserName, "민원인명은 30자이내로 입력해주십시요.");

				            if(!ncCom_Empty(frm.civilEmail.value) )
				            	if(frm.civilEmail.value.length > 50 ) return ncCom_ErrField(frm.civilEmail, "민원인 Email은 50자이내로 입력해주십시요.");

				            //frm.civilUserName.value = frm.civilUserName.value + " " + approvalSave.getSuffix();
				        }
				        //경유
				        else if(seldocTypeCode == "004"){
				            frm.zipcode1.value = "";
				            frm.zipcode2.value = "";
				            frm.address.value = "";
				            frm.civilUserName.value = "";
				            frm.civilEmail.value = "";
				   /*
				            if(ncCom_Empty($("#susinjaView").val())) {
				                alert("수신처를 지정해주십시요.");
				                return false;
				            }

				            if(ncCom_Empty(frm.viaPath.value) ) return ncCom_ErrField(frm.viaPath, "경유지를 입력해주십시요.");
				    */
				        } else {
				            return false;
				        }
/*
				    	if(ncCom_Empty(frm.aiKeyCode.value)) {
				    		alert("기록물 철을 선택하세요.");
				    		return false ;
				    	}
*/
				    	break;

				}
				return true ;
		},
		buttonToggle:function(buttonType) {
			switch (buttonType) {
				case 'BTN_EDIT' :
				case 'BTN_APPROVAL' :
					approvalSave.setHwpEditabled();
					var isEditInput =false ;

					//문서본문 수정여부를 확인한다.
					if($("#approvalKlEditFlag").val() == "Y") {

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
						approvalSave.pop("POP_EDITRECORD");
					}else {
						_g_editType = "0" ;
						if( buttonType == "BTN_EDIT") {
							approvalSave.main("EDIT_APPROVALLINE");
						}else {
							approvalSave.pop('POP_VIEWAPPROVALSIGN');
						}
					}
					break;
			}
		},
		getSuffix : function() {
			var frm = document.forms[0];

	        if(frm.suffix[0].selected)
	            return "귀하";

	        return "귀중";
		},
		successApprovalLineUploadFile : function(destFileName) {
	    	$("#docFileName").val(destFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/approvalLineEdit.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="application/x-www-form-urlencoded" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
	    },
		successApprovalSignUploadFile : function(destFileName) {
	    	$("#docFileName").val(destFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/approvalSignEdit.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="application/x-www-form-urlencoded" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
	    },

		successTempUploadFile : function(destFileName) {
	    	$("#docFileName").val(destFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/docTempApprovalInsert.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
		},
		setApprovalSignInfo : function() {
			 //대리결재가 있어 연속으로 결재 + 대리결재 가 있을경우  같이 결재 처리하기위해 배열사용함

			_g_arrKlUserType004 = [[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1]] ; // 협조 (1열 : 대리결재여부, 2열: 사인등록여부)
			_g_arrKlUserType002 = [[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1],[0,-1]] ; // 결재 (1열 : 대리결재여부, 2열: 사인등록여부)

			if(frmMain.esntlID.length == undefined || frmMain.esntlID.length  == 1 ) { //상신자이면서 전결처리
	    		$("#isApprovalLast").val("1");
	    		_g_arrKlUserType002[0][1] = 1 ;
	    	} else  {
	    		var rowNum = frmMain.esntlID.length ;
	    		var approvalInx = -2;
	    		var userType002 = -1;
	    		var userType004 = -1 ;
	    		var klUserType = "" ;
	    		for(var inx = 0 ; inx < rowNum; inx++) {
	    			klUserType = frmMain.klUserType[inx].value ;
	    			if(klUserType == "001" || klUserType == "002" || klUserType == "003") { //결재
    					userType002++ ;

    				}else if ( klUserType == "004" ){ //협의
    					userType004++;

    				}
	    			if( frmMain.esntlID[inx].value ==  _g_userKeyCode ) {

	    				if(  ncCom_Empty(frmMain.klStatus[inx].value ) ) { //결재 했으면 skip 대리 결재 체크
	    					if ( klUserType == "004" ){ //협의
    							_g_arrKlUserType004[userType004][1] = 0 ;
    						}else {
    							_g_arrKlUserType002[userType002][1] = 0 ;
    						}
	    				}else { //결재 안했으면
	    					if( approvalInx == -2 ) {
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    						}else {
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    						}
	    					}else {
	    						if ( inx - approvalInx != 1) break;
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    						}else {
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    						}
	    					}

	    				}

	    			}else if ( frmMain.viUserKey[inx].value ==  _g_userKeyCode ) { //대리결재
	    				if(  ncCom_Empty(frmMain.klStatus[inx].value ) ) { //대리결재 했으면 skip
	    					if ( klUserType == "004" ){ //협의
    							_g_arrKlUserType004[userType004][1] = 0 ;
    						}else {
    							_g_arrKlUserType002[userType002][1] = 0 ;
    						}
	    				}else { //결재 안했으면
	    					if( approvalInx == -2 ) {
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							_g_arrKlUserType004[userType004][0] = 1 ; //대결여부
	    						}else {
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    							_g_arrKlUserType002[userType002][0] = 1 ; //대결여부
	    						}

	    					}else {
	    						if ( inx - approvalInx != 1) break;
	    						approvalInx =   inx ;
	    						if ( klUserType == "004" ){ //협의
	    							_g_arrKlUserType004[userType004][1] = 1 ;
	    							_g_arrKlUserType004[userType004][0] = 1 ; //대결여부
	    						}else {
	    							_g_arrKlUserType002[userType002][1] = 1 ;
	    							_g_arrKlUserType002[userType002][0] = 1 ; //대결여부
	    						}
	    					}
	    				}
	    			}else {
	    				if ( klUserType == "004" ){ //협의
							_g_arrKlUserType004[userType004][1] = 0 ;
						}else {
							_g_arrKlUserType002[userType002][1] = 0 ;
						}
	    			}
	    		}

	    		if (approvalInx == rowNum -1) {
	    			$("#isApprovalLast").val("1");
	    		}
	    	}
		},
		main : function(arg1, arg2, arg3, arg4, arg5, arg6, arg7 ) {
			switch(arg1) {
				case 'INSERT_APPRVLINE' : // 문서, 선택항목저장
					if(!approvalSave.isValid(arg1)) return ;

				 	if( !approvalSave.setApprovalInfo(arg1, arg2, arg3, arg4, arg5, arg6, arg7) ) return ;

				 	approvalSave.docInfoToHwp(); //문서항목 hwp 로 저장

				 	var fileName = approvalSave.docFileUpload("text.hwp", _g_contextPath+"/edoc/eapproval/docApprovalUpload.do", $("#userPassword").val());

				 	if(fileName == false ) return ;

					approvalSave.successUploadFile(fileName);
					break;
				case 'INSERT_VIEWAPPRVLINE' : // 결재
					if( !approvalSave.setApprovalInfo(arg1, arg2, arg3, arg4, arg5, arg6, arg7) ) return ;

				 	var fileName = approvalSave.docFileUpload("text.hwp", _g_contextPath+"/edoc/eapproval/docApprovalUpload.do", $("#userPassword").val());
				 	if(fileName == false ) return ;

					approvalSave.successApprovalSignUploadFile(fileName);
					break;

				case 'EDIT_APPROVALLINE' : // 문서upload, 결재라인 수정
					approvalSave.setApprovalLineToHwp();
					var fileName = approvalSave.docFileUpload("text.hwp", _g_contextPath+"/edoc/eapproval/docTempApprovalUpload.do");
					if(fileName == false ) return ;
					approvalSave.successApprovalLineUploadFile(fileName);
					break;
				case 'INSERT_TEMPAPPRVLINE' : // 임시저장
					if(!approvalSave.isValid("INSERT_TEMPAPPRVLINE")) return ;
					approvalSave.setApprovalLineToHwp();

					approvalSave.docInfoToHwp(); //문서항목 hwp 로 저장
					var fileName = approvalSave.docFileUpload("text.hwp", _g_contextPath+"/edoc/eapproval/docTempApprovalUpload.do");
					if(fileName == false ) return ;
					approvalSave.successTempUploadFile(fileName);
					break;
				case 'INSERT_OPINION' : //의견저장
					if(!approvalSave.isValid(arg1)) return ;
					var url = _g_contextPath+"/edoc/eapproval/workflow/insertDocOpinion.do" ;
					var data = { "diKeyCode": $("#diKeyCode").val(),
								 "dmMemo": $("#dmMemo").val(),
								 "resultType" : "INSERT_OPINION"} ;
					ajaxPOST(url, data, approvalSave.insertOpinionCallBack);
					break;
				case 'LIST_OPINION' : //의견리스트
					var url = _g_contextPath+"/edoc/eapproval/workflow/listDocOpinion.do" ;
					var data = { "diKeyCode": $("#diKeyCode").val() } ;
					ajaxPOST(url, data, approvalSave.opinionListCallBack);
					break;

				case 'DELETE_OPINION' : //의견삭제
					var url = _g_contextPath+"/edoc/eapproval/workflow/deleteDocOpinion.do" ;
					var data = { "diKeyCode": $("#diKeyCode").val() ,
								  "dmWriteDate" : arg2} ;
					ajaxPOST(url, data, approvalSave.deleteOpinionCallBack);
					break;
				case 'APPLY_DOCHWP' :
					approvalSave.setApprovalLineToHwp();
					approvalSave.docInfoToHwp(); //문서항목 hwp 로 저장
					break;
			}
		},
		//문서파일 upload
		docFileUpload : function (fileName, uploadUri, userPassword) {
			var filePath = approvalSave.getHwpPath();
			var filePathName  = filePath +fileName ;
			var isSave = false ;
			isSave = _pHwpCtrl.SaveAs(filePathName,"HWP","lock:false");

			if(!isSave) {
				alert("문서오류입니다.");
				return false ;
			}
			//문서페이지수
			$("#riAfterPage").val(_pHwpCtrl.PageCount);

			uploader.addFile("docFile", filePathName);
			uploader.addParam("file_id", "upload.approval.doc.temp");
			if(!ncCom_Empty(userPassword)) {
				uploader.addParam("userPassword", userPassword);
			}
			var result = uploader.sendRequest(_g_serverName, _g_serverPort, uploadUri);

			var fileName = approvalSave.isValid('UPLOAD_FILE', result);

			if(fileName == false ) return false ;
			return fileName ;
		},
		//결재정보입력
		setApprovalInfo: function(approvalType, klUserType, approvalCnt, isApprovalLast, curDate, docNum, riDocNum) {
				var signPlace = "" ;
				var modified = _pHwpCtrl.IsModified ;

				if ( ncCom_Empty( $("#diKeyCode").val() ) ) {
					$("#approvalKlEditFlag").val("N");
				}else {
					if(modified == 0 ) {
						$("#approvalKlEditFlag").val("N");
					}else {
						$("#approvalKlEditFlag").val("Y");
					}
				}
				// 결재라인정보를 hwp 에 설정함.
				approvalSave.setApprovalLineToHwp();

				if(frmMain.paramDiStatus.value != "004") { // 보류 일경우 사인 셋팅 안함...
					var sign = "" ;
					if ( frmMain.signType.value == "1" ) {
						sign =  _g_userName ;

					} else if (frmMain.signType.value == "3" ) {
						//sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImage.do?fileSn=0&atchFileId="+frmMain.signID.value ;
						if(_g_compayCD == "10014" || _g_compayCD == "10022" ) {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/cmm/fms/getImageViewer.do?filename="+frmMain.signID.value+"&type=usersign";
						}else {
							sign =  "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?imageType=egovImg&fileSn=0&atchFileId="+frmMain.signID.value ;
						}

				 	}else {
						alert("사인 종류를 선택하세요.");
					 	return false;
				 	}
					var rowNum = _g_arrKlUserType002.length ;

					//결재
					for(var inx = 0 ; inx < rowNum ; inx++) {
						if ( _g_arrKlUserType002[inx][1] == 1 ) {
							signPlace = "approval"+ (inx+1) ;

							if ( frmMain.signType.value == "1" ) {
								_hwpPutText(signPlace, sign);

							} else if (frmMain.signType.value == "3" ) {
								_hwpPutImage(signPlace, sign);
						 	}
							if(frmMain.paramDiStatus.value == "007")  {
								_hwpPutText("approval_opt"+(inx+1), "반려");
						 		_hwpPutText("doc_runday", " ");
						 		_hwpPutText("doc_docnum", " ");
								_hwpPutText("approval_date", " "  );
						 		break;
							}
							if(_g_arrKlUserType002[inx][0] == 1 ) { //대결이면
								_hwpPutText("approval_opt"+(inx+1), "대결");
							}

						}else if (_g_arrKlUserType002[inx][1] == -1) {
							if(inx > 0 ) {
								if( isApprovalLast == "1" ) {
									if(_g_arrKlUserType002[inx-1][0] == 1 ) { //대결이면
										_hwpPutText("approval_opt"+inx, "대결 "+curDate);
									}else {
										_hwpPutText("approval_opt"+inx, curDate);
									}
								//	_hwpPutText("approval_opt"+approvalCnt, curDate);
							 		_hwpPutText("doc_runday", docNum +"( "+ curDate +" )");
							 		_hwpPutText("doc_docnum", docNum);
							 		_hwpPutText("approval_date", curDate);
									if(approvalType == "INSERT_APPRVLINE") $("#riDocNum").val(riDocNum);
								}else {
									if(_g_arrKlUserType002[inx-1][0] == 1 ) { //대결이면
										_hwpPutText("approval_opt"+inx, "대결");
									}
									if(approvalType == "INSERT_APPRVLINE")  $("#riDocNum").val("");
								}
							}
							break;

						}
					}

					//협조
					for(var inx = 0 ; inx < rowNum ; inx++) {
						if ( _g_arrKlUserType004[inx][1] == 1 ) {
							signPlace = "cooperation"+ (inx+1) ;
							if(frmMain.paramDiStatus.value == "007")  {
								if ( frmMain.signType.value == "1" ) {
									_hwpPutText(signPlace, "반려"+sign);

								} else if (frmMain.signType.value == "3" ) {
									_hwpPutImage(signPlace, sign);
									_pHwpCtrl.PutFieldText(signPlace, "반려");
							 	}
								break;
							}else {
								if ( frmMain.signType.value == "1" ) {
									_hwpPutText(signPlace, "대결"+sign);

								} else if (frmMain.signType.value == "3" ) {
									_hwpPutImage(signPlace, sign);
									_pHwpCtrl.PutFieldText(signPlace, "대결");
							 	}
							}    
						}
					}
				}
				return true ;
		},
		pop : function(arg) {
			switch(arg) {
				case "POP_DOCSUMMARY" : //문서요약 팝업
					openWindow2("",  "popDocSummary", 680, 530, 0) ;
					frmPop.target = "popDocSummary";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/EDocSummary.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case "POP_DOCSUMMARYVIEW" : //문서요약 팝업
					openWindow2("",  "popDocSummary", 680, 500, 0) ;
					frmPop.target = "popDocSummary";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/docSummaryView.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case "POP_APPROVALLINE" : //결재라인 팝업
					openWindow2("",  "popApprovalLine", 960, 520, 0) ;
					frmPop.target = "popApprovalLine";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/approvalLineWrite.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case 'POP_APPROVALLINEVIEW' :
					var diKeyCode = frmMain.diKeyCode.value ;
					var param = "diKeyCode="+diKeyCode;
					neosPopup('POP_APPLINE', param);
					break;
				case "POP_APPROVALSIGN" : //결재사인팝업

					if(!approvalSave.isValid("INSERT_APPRVLINE")) return ;

					$("#isApprovalLast").val("0");
					approvalSave.setApprovalSignInfo();
					openWindow2("",  "popApprovalSign", 430, 370, 0) ;
					frmPop.target = "popApprovalSign";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/approvalSign.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case 'POP_VIEWAPPROVALSIGN' : //문서필수항목체크 제외 하고 결재사인팝업
					if(!approvalSave.isValid(arg)) return ;
					$("#isApprovalLast").val("0");
					approvalSave.setApprovalSignInfo();
					openWindow2("",  "popApprovalSign", 430, 370, 0) ;
					frmPop.target = "popApprovalSign";
					frmPop.method = "post";
					frmPop.action = _g_contextPath+"/edoc/eapproval/workflow/approvalSign.do";
					frmPop.submit();
					frmPop.target = "";
					break;
				case 'POP_ARCHIVE' : //서류철
					var aiKeyCode = $("#aiKeyCode").val();
					var obj = {method : "approvalSave.setArchive",
							c_aikeycode : aiKeyCode};

					NeosUtil.openPopArchive(obj);
					break;
				case 'POP_DESC' : //공개여부 설명
					var uri = _g_contextPath+"/edoc/eapproval/workflow/viewPrivateInfo.do" ;
					openWindow2(uri, "popPrivateInfo", 655, 600, 0) ;
					break;
				case 'POP_RECEIVER' : //수신자 목록


					var value = $("input[name='docTypeCode']:checked").val() ;

					var uri = "";
					var width =0;
					var height =0;
					if( value == "001" ) {
						width = 650 ;
						height = 510;
						uri = _g_contextPath+"/neos/edoc/document/record/popup/outterSelectPopup.do";
					}else if (value  == "002") {
						width = 660 ;
						height = 550;
						uri = _g_contextPath+"/neos/edoc/document/record/popup/LdapSelectPopup.do";
					}
					openWindow2("",  "selectOrganView", width, height, 0) ;
					frmPop.c_sireceivecode.value =$("#arrSiReceiveCode").val();
					frmPop.c_sireceivename.value = "";
					frmPop.sendername.value = $("#arrSiSenderName").val();
					frmPop.inputId.value = 'upperOrganId';
					frmPop.methodName.value = 'approvalSave.setReceive';
					frmPop.target = "selectOrganView";
					frmPop.action = uri;
					frmPop.submit();
					frmPop.target = "" ;
					break;
				case "POP_PREVIEWDOC" : //미리보기
					var filePath = approvalSave.getHwpPath();
					var fileName = rndStr("",10)+".hwp";
					var filePathName  = filePath +fileName ;
					var isSave = false ;
					isSave = _pHwpCtrl.SaveAs(filePathName,"HWP","lock:false");
					if(!isSave) {
						alert("문서오류입니다.");
						return false ;
					}
					frmMain.localPathName.value = filePathName ;
					var uri = _g_contextPath+"/edoc/eapproval/workflow/docPreviewPopup.do";
					openWindow2(uri,  "popPreviewDoc",  966, 630, 0,0) ;
					break;
				case "POP_DOCEDITLIST" : //문서 수정내역
					var param = "diKeyCode="+frmMain.diKeyCode.value+"&diSeqNum="+frmMain.diSeqNum.value+"&miSeqNum="+frmMain.miSeqNum.value;
					neosPopup("POP_DOCEDITLIST", param);
					break;
				case "POP_EDITRECORD" : //문서 수정 입력
					var uri = _g_contextPath+"/edoc/eapproval/workflow/docEditRecord.do";
					openWindow2(uri,  "popEditRecord", 430, 190, 0) ;
					break;
			}
		},

		//문서정보를 한글파일에 입력
		docInfoToHwp : function() {
			var senderName  = $("#susinjaView").val() ;
			var docReceive = "" ;
			var docReceiveList = "" ;
			var receiveRowNum = 0;
			if(!ncCom_Empty(senderName)) {
				var objSiReceiveCode = document.getElementsByName("siReceiveCode_"+curTabNumber) ;
				receiveRowNum = 0 ;
				if ( objSiReceiveCode != undefined) {
					receiveRowNum = objSiReceiveCode.length ;
				}
				if(!ncCom_Empty(senderName)) {
					if( receiveRowNum > 1 ) {
						docReceive = "수신자 참조" ;
						docReceiveList = senderName ;
					}else {
						docReceive = senderName ;
						docReceiveList = "";
					}
				}

			}
			if(frmMain.selSenderName ==  undefined ) {
				_pHwpCtrl.PutFieldText("sender_name", " ");
			}else {
				_hwpPutText("sender_name", $("#selSenderName").val()); //발신인명
			}

			_hwpPutText("doc_name", $("#dname2").val()); //문서제목
			_hwpPutText("doc_receive", docReceive); //수신
			_hwpPutText("doc_via", $("#viaPath").val()); //경유지
			_hwpPutText("doc_receivelist", docReceiveList); //수신자 리스트
		/*
	        frmMain.zipcode1.value = "";
	        frmMain.zipcode2.value = "";
	        frmMain.address.value = "";
	        frmMain.civilUserName.value = "";
	        frmMain.civilEmail.value = "";
		*/
	        var zipCode = "" ;
	        if (!ncCom_Empty($("#zipcode1").val())) {
	        	zipCode =$("#zipcode1").val() +"-"+ $("#zipcode2").val() ;
	        }
			_hwpPutText("post_number", zipCode); //우편번호
			_hwpPutText("site_address", $("#address").val()); //우편번호
			_hwpPutText("email", $("#civilEmail").val()); //이메일
			var publicType = $("input[name='publicType']:checked").val() ;
			var publicTypeName = "" ;
			if (publicType == "001") {
				publicTypeName = "공개";
			}else {
				var arrPublicGradeCH = checkBoxSelectedIndex(frmMain.publicGradeCH);
				var rowNum = 0 ;
				var publicGradeCH= "" ;
				if (arrPublicGradeCH != undefined ) {
					rowNum = arrPublicGradeCH.length ;
					for(var inx = 0 ; inx < rowNum; inx++) {
						publicGradeCH += (arrPublicGradeCH[inx]+1)+"";
						if(inx < rowNum -1) {
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
			_hwpPutText("management", publicTypeName); //문서 공개, 비공개
			//민원문서일경우
			seldocTypeCode = $("input[name='docTypeCode']:checked").val();
			if(seldocTypeCode == "003"){
				docReceive = $("#civilUserName").val() + " " +approvalSave.getSuffix() + "( 우" +$("#zipcode1").val()+"-"+$("#zipcode2").val() +" "+ $("#address").val() +" )" ;
				_hwpPutText("doc_receive", docReceive); //수신
			}else {
				if(docReceive == "") _hwpPutText("doc_receive", " "); //수신
			}

		},

		//기록물철셋팅
		setArchive:function(item) {
			//var obj = $.parseJSON(mdata);
			//alert(mdata);
			alert(item.seq);
			if(!item) return;
			$("#aiKeyCode").val(item.seq);
			if(item.name){
				$("#aiTitle").val(item.name + " (" +item.reDate+ ")");
				$("#aiPreserve").val(item.preserve);
				$("#preserveName_"+showTabNumber).val(item.reDate);
			}
		},


		//hwp 결재라인 초기화
		initApprovalHwp:function() {
			for( var inx = 1 ; inx <=8; inx++ ) {
		    	_pHwpCtrl.PutFieldText("approval_opt"+inx, " ");
		    	_pHwpCtrl.PutFieldText("approver"+inx, " ");
		    	_pHwpCtrl.PutFieldText("cooperate"+inx, " ");
			}
		},

		//수신자초기화
		initReceive :function() {
			$("#susinjaView").val("");
			$("#idApprvLineReceive").val("");
		},

		//공개 비공개 토글
		publicGubunToggle:function() {
			var publicType = $("input[name='publicType']:checked").val() ;
	       	//공개
	       	if(publicType == "001") {
	       		$("#idKindNo").hide();
	       		$("#diOpen1").attr("disabled", false);
	       		$("#diOpen2").attr("disabled", false);
	       	} else if (publicType == "002" || publicType =="003") {
	       		$("#idKindNo").show();
	       		$("#diOpen1").attr("disabled", true);
	       		$("#diOpen2").attr("disabled", true);
	       		$("#diOpen2").attr("checked", true);

	       	} else {
	       		$("#idRadioHo").show();
	       	}
		},

		treatToggle : function() {
			 var value = $("input[name='docTypeCode']:checked").val() ;
	       	//내부결재
	       	if(value == "000" ) {
	       		$("#idReceiver").hide();
	       		$("#idPass").hide();
	       		$("#idAddress").hide();
	       		$("#idInfoOpen").hide();

	       	} else if (value =="001" || value == "002" ) { //대내문서, 대외문서
	       		$("#idReceiver").show();
	       		$("#idPass").hide();
	       		$("#idAddress").hide();
	       		$("#idInfoOpen").show();
				$("#susinjaView").val("");
				$("#idApprvLineReceive").html("");
				$("#idApprvLineReceive2").html("");
				$("#arrSiReceiveCode").val("");
				$("#arrSiSenderName").val("");
	       	} else if( value == "003" ) {  //민원문서
	       		$("#idReceiver").hide();
	       		$("#idPass").hide();
	       		$("#idAddress").show();
	       		$("#idInfoOpen").show();

	       	} else if( value == "004") { //경유문서
	       		$("#idReceiver").show();
	       		$("#idPass").show();
	       		$("#idAddress").hide();
	       		$("#idInfoOpen").show();

	       	}
		},

		//문서 취급시 제어
		treateControl:function() {
	        var value = $("input[name='treatmentCode']:checked").val() ;
	        var frm = document.forms[0];
	        //전산망
			if(value == '001') {
				$("#docTypeCode1").attr("disabled", false);
			 	$("#docTypeCode2").attr("disabled", false);
			 	$("#docTypeCode3").attr("disabled", false);
			 	$("#docTypeCode4").attr("disabled", false);
				$("#docTypeCode5").attr("disabled", false);
	            if (frm.docTypeCode[0].checked)
	            	approvalSave.treatToggle();
	            else
	            	approvalSave.treatToggle();

	        }else if(value == '007') { //게시
				$("#docTypeCode1").attr("disabled", true);
			 	$("#docTypeCode2").attr("disabled", false);
			 	$("#docTypeCode3").attr("disabled", true);
			 	$("#docTypeCode4").attr("disabled", true);
			 	$("#docTypeCode5").attr("disabled", true);

			 	$("#docTypeCode2").attr("checked", true);
			 	approvalSave.treatToggle();
	        } else { // 기타
				$("#docTypeCode1").attr("disabled", true);
			 	$("#docTypeCode2").attr("disabled", false);
			 	$("#docTypeCode3").attr("disabled", false);
			 	$("#docTypeCode4").attr("disabled", false);
			 	$("#docTypeCode5").attr("disabled", false);

			 	$("#docTypeCode2").attr("checked", true);
			 	approvalSave.treatToggle();
	        }
		},

		//문서정보 입력 정보 가져온다.
		getDocInfo:function() {
			if( ncCom_Empty( _g_publicType ) )  _g_publicType  = "FIRST";
			var docInfoHtml = NeosCodeUtil.getCodeRadio("COM106", "publicType", _g_publicType,"approvalSave.publicGubunToggle();") ; //공개여부
			docInfoHtml += "&nbsp;&nbsp;<a href=\"#none\" onclick=\"approvalSave.pop('POP_DESC');\"><img src=\""+_g_contextPath+"/images/neos/popup/topbullet_3rd_on.gif\"><font color=\"#666666\"> 비공개대상정보설명</font></a>";
			$("#idPublicHtml").html( docInfoHtml);

			docInfoHtml = NeosCodeUtil.getCodeCheck("COM105", "publicGradeCH", "","") ; //구분번호
			$("#idKindNoHtml").html(docInfoHtml);

			if( ncCom_Empty( _g_treatmentCode ) )  _g_treatmentCode  = "FIRST";
			docInfoHtml = NeosCodeUtil.getCodeRadio("COM107", "treatmentCode", _g_treatmentCode,"approvalSave.treateControl()") ; //문서취급
			$("#idTreatmentHtml").html( docInfoHtml);

			if( ncCom_Empty( _g_docGradeCode ) )  _g_docGradeCode  = "FIRST";
			docInfoHtml = NeosCodeUtil.getCodeRadio("COM111", "docGradeCode", _g_docGradeCode,"") ; //긴급여부
			$("#idDocGradesHtml").html(docInfoHtml);

			if( ncCom_Empty( _g_docTypeCode ) )  _g_docTypeCode  = "FIRST";
			docInfoHtml = NeosCodeUtil.getCodeRadio("COM110", "docTypeCode", _g_docTypeCode,"approvalSave.treatToggle();") ;  //문서구분
			$("#idDocGubunHtml").html(docInfoHtml);

			if( ncCom_Empty( _g_secretGradeCode ) )  _g_secretGradeCode  = "FIRST";
			docInfoHtml = NeosCodeUtil.getCodeRadio("COM129", "secretGradeCode", _g_secretGradeCode,"") ; //보안문서
			$("#idSecurityHtml").html( docInfoHtml+" (결재선+소유자 열람)");
		},

		chngFolder:function() {
			if ($("#idDocInfo").css('display') == "none") {
				$("#idDocInfo").slideDown();
				$("#idUnfolder").hide();
				$("#idFolder").show();
			}else {
				$("#idDocInfo").slideUp();
				$("#idUnfolder").show();
				$("#idFolder").hide();
			}
		},

		chngAttachFile:function() {
			if ($("#idAttachFile").css('display') == "none") {
				$("#idAttachFileText").html("첨부파일닫기");
				$("#idAttachFile").slideDown();
				//$("#idAttachFile").show();
			}else {
				$("#idAttachFileText").html("첨부파일보기");
				$("#idAttachFile").slideUp();
				//$("#idAttachFile").hide();
			}
		},


		//의견 저장
		insertOpinionCallBack: function(data) {
			switch(data.errorCode) {
				case 0 :
					alert("의견이 저장되었습니다.");
					$("#dmMemo").val("");
					approvalSave.main('LIST_OPINION');

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
		//의견삭제
		deleteOpinionCallBack: function(data) {
			switch(data.errorCode) {
				case 0 :
					alert("의견이 삭제되었습니다.");
					approvalSave.main('LIST_OPINION');
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
			for(var inx = 0 ; inx < rowNum; inx++  ) {
				listHtml += "<li>";
				if( list[inx].c_klreturnflag == '1') {
					listHtml += "<p><span><strong>"+list[inx].user_nm+"</strong> |</span> [반려]&nbsp;"+list[inx].c_dmmemo+"</p> ";
					listHtml += "<p class=\"date\">"+list[inx].convertWriteDate
				}else {
					listHtml += "<p><span><strong>"+list[inx].user_nm+"</strong> |</span>"+list[inx].c_dmmemo+"</p> ";
					listHtml += "<p class=\"date\">"+list[inx].convertWriteDate
					if(list[inx].c_dmwriteuserkey == userKey   ) {
						listHtml += "<a href=\"#none\" onClick= \"lumpApproval.main('DELETE_OPINION', '"+list[inx].c_dmwritedate+"');\" >&nbsp;<img src=\""+_g_contextPath+"/images/btn/btn_commentDel.gif\" width=\"13\" height=\"13\" alt=\"삭제\" /></a>";
					}
				}
				listHtml += "</p>";
				listHtml += "</li>";
			}
			$("#listOpinion").html(listHtml);
		},
		//결재라인 수정 반영
		setApprvLine : function (apprvLine, delApprvLine) {
			$("#idApprvLine").html(apprvLine);
			$("#idApprvLine2").html(apprvLine);

			if(!ncCom_Empty(delApprvLine)) {
				$("#delApprovalMember").html(delApprvLine);
				$("#delApprovalMember2").html(delApprvLine);
			}else {
				$("#delApprovalMember").html("");
				$("#delApprovalMember2").html("");
			}
			return true ;
		},

		editModeToggle:function(editType) {
			if(editType == "1") {
				$("#idSave").show();
				$("#idEdit").hide();
	  			if(_pHwpCtrl.FieldExist("_F_CONTENTS_")) {
	  				_pHwpCtrl.EditMode = 2 ; //CELL 과 누름틀중 양식모드에서 편집가능한 속성을 가진 것만 편집가능하다. 
				}else {
					_pHwpCtrl.EditMode = 1 ; // 일반 편집모드
				}						
			}else {
				$("#idSave").hide();
				$("#idEdit").show();
				_pHwpCtrl.EditMode = 0 ; // 읽기전용
			}
		},
		getHwpPath:function() {
			var filePath = "" ;
			var filePathName = _pHwpCtrl.Path() ;
			var point = filePathName.lastIndexOf("\\") ;

			filePath = filePathName.substring(0,point+1);
			return filePath ;
		},
		//문서 정보 시작
		hwpStart : function() {
			_pHwpCtrl = HwpControl.HwpCtrl;
		    _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

	    	if (!_VerifyVersion()) {
		  		_pHwpCtrl = null;
		  	   	return;
		  	}

	    	//_pHwpCtrl.SetClientName("DEBUG"); //For debug message
		   	_InitToolBarJS();

			//var path= "<spring:message code='eapproval.templatepath' />/${docTemplateInfo.C_TIKEYCODE}.hwp";

			var path = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docDownload.do?randomKey="+rndStr("",13)+"&tiKeyCode="+_g_tiKeyCode ;
		   	if(!_pHwpCtrl.Open(path,"HWP","versionwarning:true")){
		   		alert("기안문서가 없습니다. 관리자한테 문의하세요!");
		   		self.close();
		   		return;
		   	};
			if(!ncCom_Empty(_g_orgnztPostNumber)) {
				if( _g_orgnztPostNumber.length == 6 ) {
					_g_orgnztPostNumber = _g_orgnztPostNumber.substring(0,3) +"-"+ _g_orgnztPostNumber.substring(3,6)
				}
			}
		   	//문서초기 정보입력
		   	_pHwpCtrl.PutFieldText("header_campaign", _g_tiHeader);
		   	_pHwpCtrl.PutFieldText("agency_name", _g_docCompany);
		   	_pHwpCtrl.PutFieldText("post_number", _g_orgnztPostNumber);
		   	_pHwpCtrl.PutFieldText("site_address", _g_orgnztSiteAddress);
		   	_pHwpCtrl.PutFieldText("homepage_url", _g_orgnztHomepageURL);
		   	_pHwpCtrl.PutFieldText("telephone_no", _g_orgnztTelephoneNO);
		   	_pHwpCtrl.PutFieldText("fax_no", _g_orgnztFaxNO);
		   	_pHwpCtrl.PutFieldText("email", _g_orgnztEmail);
		   if(!ncCom_Empty(_g_tiLogo)) {
		   		_hwpPutImage("img_logo", "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?randomKey="+rndStr("",13)+"&imageName="+_g_tiLogo+"&imageType=logo");
		   }
		   if(!ncCom_Empty(_g_tiSymbol)) {
		   		_hwpPutImage("img_symbol", "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath+"/edoc/eapproval/workflow/docImgDownload.do?randomKey="+rndStr("",13)+"&imageName="+_g_tiSymbol+"&imageType=symbol");
		   }

		   	_pHwpCtrl.PutFieldText("footer_campaign", _g_tiFooter );
		},
		VIEW_BACKUP_HWPSTART : function(serverName, serverPort, diKeyCode, userKeyCode) {
	    	_pHwpCtrl = HwpControl.HwpCtrl;
		    _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

	    	if (!_VerifyVersion()) {
		  		_pHwpCtrl = null;
		  	   	return;
		  	}
	    	//_pHwpCtrl.SetClientName("DEBUG"); //For debug message
		   	//_InitToolBarJS();
			var path = "http://"+serverName+":"+serverPort+_g_contextPath+"/edoc/eapproval/workflow/docDownload.do?randomKey="+rndStr("",13)+"&backupYN=Y&diKeyCode="+diKeyCode+"&userKeyCode="+userKeyCode ;
		   	if(!HwpControl.HwpCtrl.Open(path,"")){
		   		alert("파일 오픈실패!");
		   		//return;
		   	};
		   	_pHwpCtrl.MovePos(2);
		   	_pHwpCtrl.EditMode = 0 ; //읽기전용
	    },
	    PREVIEW_DOC_HWPSTART : function (path) {
	    	_pHwpCtrl = HwpControl.HwpCtrl;
		    _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

	    	if (!_VerifyVersion()) {
		  		_pHwpCtrl = null;
		  	   	return;
		  	}
	    	//_pHwpCtrl.SetClientName("DEBUG"); //For debug message
		   	if(!HwpControl.HwpCtrl.Open(path,"")){
		   		alert("파일 오픈실패!");
		   		//return;
		   	};
		   	_pHwpCtrl.EditMode = 0 ; //읽기전용
			_pHwpCtrl.run("FilePreview");
			_pHwpCtrl.PreviewCommand(6);
			_pHwpCtrl.MovePos(2);
			//_pHwpCtrl.Run("MoveLineBegin");
	    },
	    delFile : function(aiSeqNum) {
	    	$("#idDelFile").append("<input type = 'hidden' name = 'delAiSeqNum' value = '"+aiSeqNum+"'>");

	    	$("#idDelAiSeq"+aiSeqNum).remove();
	    }
}