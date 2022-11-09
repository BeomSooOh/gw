var _g_attend_draftName = "" ;
var _g_attend_draftPositionName = "" ;
var _g_attend_draftDeptName = "" ;

var _g_attend_draftYear = "" ;
var _g_attend_draftMonth = "" ;
var _g_attend_draftDay = "" ;

var _g_attend_loginID = "" ;

var _g_attend_writeID = "" ;
var _g_attend_requestID = "" ;
var _g_attend_codeID = "" ;
var _g_attend_code = "" ;
var _g_attend_cause = "" ;
var _g_attend_sDate  = "" ;
var _g_attend_sTime = "" ;
var _g_attend_sHour = "" ;
var _g_attend_sMin = "" ;
var _g_attend_eDate = "" ;
var _g_attend_eTime = "" ;
var _g_attend_eHour = "" ;
var _g_attend_eMin = "" ;
var _g_attend_term= "" ;
var _g_attend_workinstead = "" ;
var _g_attend_workinsteadid = "" ;
var _g_attend_phone = "" ;
var _g_attend_dikeyCode = "" ;
var _g_attend_gwState = "" ;
var _g_attend_deptName = "" ;
var _g_attend_request_deptName = "" ;
var _g_attend_request_userName = "" ;
var _g_attend_request_positionName = "" ;
var _g_attend_vacation_type_nm = "" ;
var _g_attend_userName = "" ;
var _g_attend_requestName = "" ;
var _g_attend_writeName = "" ;
var _g_attend_term = "" ;
var _g_attend_title = "" ;
var _g_attend_cause = "" ;
var _g_attend_draft_date = "" ;
var _g_attend_draft_year= "" ;
var _g_attend_draft_month = "" ;
var _g_attend_draft_day = "" ;

var _g_vacation_total_count = "" ; //총연차일수 
var _g_vacation_used_count = "" ;  //사용연차일수
var _g_vacation_rest_count = "" ;   //잔여연차일수

docInfo = {
		setDocInfo : function (ciKind) {
			_g_attend_sHour = _g_attend_sTime.substring(0,2);
			_g_attend_eHour = _g_attend_eTime.substring(0,2);
			_g_attend_sMin = _g_attend_sTime.substring(2,4);
			_g_attend_eMin = _g_attend_eTime.substring(2,4);
			
			_g_attend_draft_year = _g_attend_draft_date.substring(0,4);
			_g_attend_draft_month = _g_attend_draft_date.substring(5,7);
			_g_attend_draft_day = _g_attend_draft_date.substring(8,10);
			
			lumpApproval.hwpPutText("DRAFT_YEAR"   ,_g_attend_draft_year);
			lumpApproval.hwpPutText("DRAFT_MONTH"   ,_g_attend_draft_month);
			lumpApproval.hwpPutText("DRAFT_DAY"   ,_g_attend_draft_day);
			
			lumpApproval.hwpPutText("FROM_HOUR"   ,_g_attend_sHour);
			lumpApproval.hwpPutText("FROM_MIN"   ,_g_attend_sMin);
			lumpApproval.hwpPutText("TO_HOUR"   ,_g_attend_eHour);
			lumpApproval.hwpPutText("TO_MIN"   ,_g_attend_eMin);
			
			var year = _g_attend_sDate.substring(0, 4);
			var month = _g_attend_sDate.substring(5, 7);
			var day =  _g_attend_sDate.substring(8, 10);
			var time = "" ;
			lumpApproval.hwpPutText("FROM_MONTH"   ,month);
			lumpApproval.hwpPutText("FROM_DAY"   ,day);
			lumpApproval.hwpPutText("FROM_HOUR"   ,_g_attend_sHour);

			month =  _g_attend_eDate.substring(5, 7);
			day =  _g_attend_eDate.substring(8, 10);
			lumpApproval.hwpPutText("TO_MONTH"   ,month);
			lumpApproval.hwpPutText("TO_DAY"   ,day);
			lumpApproval.hwpPutText("TO_HOUR"   ,_g_attend_eHour);
			
			lumpApproval.hwpPutText("DRAFT_DEPT_NM"      ,_g_attend_draftDeptName); //부서
			lumpApproval.hwpPutText("DRAFT_POSITION_NM"   ,_g_attend_draftPositionName); //직위
			lumpApproval.hwpPutText("DRAFT_USER_NM"   ,_g_attend_draftName); //성명
			lumpApproval.hwpPutText("REQUEST_DEPT_NM"      ,_g_attend_request_deptName); //요청자부서
			lumpApproval.hwpPutText("REQUEST_POSITION_NM"   ,_g_attend_request_positionName); //요청자직위
			lumpApproval.hwpPutText("REQUEST_USER_NM"   ,_g_attend_request_userName); //요청자성명
			
			lumpApproval.hwpPutText("VACATION_TOTAL_COUNT"   ,_g_vacation_total_count); //총연자일수
			lumpApproval.hwpPutText("VACATION_USED_COUNT"   ,_g_vacation_used_count); //사용연차일수
			lumpApproval.hwpPutText("VACATION_REST_COUNT"   ,_g_vacation_rest_count); //잔여연차일수
			lumpApproval.hwpPutText("CAUSE"   ,textToHtmlConvert(_g_attend_cause));
			lumpApproval.hwpPutText("doc_name"   ,_g_attend_title);
			if( ciKind == "013" ) { //근태
				lumpApproval.hwpPutText("DEPT_NM"      ,_g_attend_deptName); //부서
				lumpApproval.hwpPutText("POSITION_NM"   ,_g_attend_request_positionName); //직위
				lumpApproval.hwpPutText("DRAFT_USER_NM"   ,_g_attend_requestName); //성명

				lumpApproval.hwpPutText("OUTING"   ," ");
				lumpApproval.hwpPutText("EARLYLEAVE"   ," ");
				lumpApproval.hwpPutText("LATE"   ," ");
				lumpApproval.hwpPutText("EDUCATION"   ," ");
				lumpApproval.hwpPutText("etc"   ," ");
				if(_g_attend_code == "001") {
					lumpApproval.hwpPutText("OUTING"   ,"O");
				}else if(_g_attend_code == "002") {
					lumpApproval.hwpPutText("EARLYLEAVE"   ,"O");
				}else if(_g_attend_code == "003") {
					lumpApproval.hwpPutText("LATE"   ,"O");
				}else if(_g_attend_code == "004") {
					lumpApproval.hwpPutText("EDUCATION"   ,"O");
				}else if(_g_attend_code == "005") {
					lumpApproval.hwpPutText("ETC"   ,"O");
				}
				lumpApproval.hwpPutText("TERM"   ,_g_attend_term);
			}else if ( ciKind == "012" ) { //휴가 
				lumpApproval.hwpPutText("DEPT_NM"      ,_g_attend_deptName); //부서
				lumpApproval.hwpPutText("DRAFT_DEPT_NM"      ,_g_attend_draftDeptName); //부서
				lumpApproval.hwpPutText("DRAFT_POSITION_NM"   ,_g_attend_draftPositionName); //직위
				lumpApproval.hwpPutText("DRAFT_USER_NM"   ,_g_attend_draftName); //성명
				lumpApproval.hwpPutText("VACATION_TYPE_NM"   ,_g_attend_vacation_type_nm); //휴가 종류
				lumpApproval.hwpPutText("DRAFT_DATE"   ,_g_attend_draft_date); //신청일자
				lumpApproval.hwpPutText("REQUEST_USER_NM"   ,_g_attend_requestName); //요청자
				
				if(_g_attend_code == "1") {
					lumpApproval.hwpPutText("VACATION1"   ,"O");
				}else if(_g_attend_code == "2") {
					lumpApproval.hwpPutText("VACATION2"   ,"O");
				}else if(_g_attend_code == "3") {
					lumpApproval.hwpPutText("VACATION3"   ,"O");
				}else if(_g_attend_code == "4") {
					lumpApproval.hwpPutText("VACATION4"   ,"O");
				}else if(_g_attend_code == "5") {
					lumpApproval.hwpPutText("VACATION5"   ,"O");
				}else if(_g_attend_code == "6") {
					lumpApproval.hwpPutText("VACATION6"   ,"O");
				}else if(_g_attend_code == "7") {
					lumpApproval.hwpPutText("VACATION7"   ,"O");
				}else if(_g_attend_code == "8") {
					lumpApproval.hwpPutText("VACATION8"   ,"O");
				}else if(_g_attend_code == "9") {
					lumpApproval.hwpPutText("VACATION9"   ,"O");
				}else if(_g_attend_code == "10") {
					lumpApproval.hwpPutText("VACATION10"   ,"O");
				}
				
				var year = _g_attend_sDate.substring(0, 4);
				var month = _g_attend_sDate.substring(5, 7);
				var day =  _g_attend_sDate.substring(8, 10);
				var from_date = year+"년" +month + "월"+  day + "일" ;
				lumpApproval.hwpPutText("FROM_DATE"   ,from_date);
				year = _g_attend_eDate.substring(0, 4);
				month =  _g_attend_eDate.substring(5, 7);
				day =  _g_attend_eDate.substring(8, 10);

				var to_date = year+"년" +month + "월"+  day + "일"  ;
				lumpApproval.hwpPutText("TO_DATE"   ,to_date);
				
				
				var tHour = 0;
				var tMin = 0;
				if (_g_docCompany == '충북문화재단') {	// 충분문화재단에서 출장을 일수가 아닌 시간으로 보여달라는 요청내용 적용.
					var sh = _g_attend_sTime.substring(0, 2);
					var eh = _g_attend_eTime.substring(0, 2);
					var sm = _g_attend_sTime.substring(2, 4);
					var em = _g_attend_sTime.substring(2, 4);
					
					if (sh != '00' && eh != '00') {
						var s = (parseInt(sh) * 60) + parseInt(sm);
						var e = (parseInt(eh) * 60) + parseInt(em);
						
						if (s > e) return;
						
						var sum = e - s;	 
						
						tHour =  parseInt(sum/60);
						tMin = (sum%60);
					}
					
					if (_g_attend_sDate == _g_attend_eDate) {
						if (tMin < 1) {
							lumpApproval.hwpPutText("TERM"   ,tHour+"시간");
						} else {
							lumpApproval.hwpPutText("TERM"   ,tHour+"시간 " + tMin+"분");
						}
					} else {
						lumpApproval.hwpPutText("TERM"   ,_g_attend_term+"일");
					}
				} else {				
					lumpApproval.hwpPutText("TERM"   ,_g_attend_term);
				}

				var year = _g_attend_sDate.substring(0, 4);
				var month = _g_attend_sDate.substring(5, 7);
				var day =  _g_attend_sDate.substring(8, 10);
				lumpApproval.hwpPutText("FROM_YEAR"   , year);
				lumpApproval.hwpPutText("FROM_MONTH"   ,month);
				lumpApproval.hwpPutText("FROM_DAY"   ,day);
				lumpApproval.hwpPutText("FROM_HOUR"   ,_g_attend_sHour);

				year = _g_attend_eDate.substring(0, 4);
				month =  _g_attend_eDate.substring(5, 7);
				day =  _g_attend_eDate.substring(8, 10);

				lumpApproval.hwpPutText("TO_YEAR"   ,year);
				lumpApproval.hwpPutText("TO_MONTH"   ,month);
				lumpApproval.hwpPutText("TO_DAY"   ,day);
				lumpApproval.hwpPutText("TO_HOUR"   ,_g_attend_eHour);

				lumpApproval.hwpPutText("BUSINESS_NIGHT"   , " ");
				lumpApproval.hwpPutText("BUSINESS_DAY"   , " ");
				if( parseInt(_g_attend_term) >= 2 ) {
					lumpApproval.hwpPutText("BUSINESS_NIGHT"   , parseInt(_g_attend_term)-1);
					lumpApproval.hwpPutText("BUSINESS_DAY"   , _g_attend_term);
				}else {
					lumpApproval.hwpPutText("BUSINESS_DAY"   , _g_attend_term);
				}
			}else if ( ciKind == "014" ) { //특근
				lumpApproval.hwpPutText("DEPT_NM"      ,_g_attend_deptName); //부서
				lumpApproval.hwpPutText("POSITION_NM"   ,_g_attend_request_positionName); //직위
				lumpApproval.hwpPutText("DRAFT_USER_NM"   ,_g_attend_requestName); //성명
				lumpApproval.hwpPutText("GUBUN1"   ,"");
				lumpApproval.hwpPutText("GUBUN2"   ,"");
				if(_g_attend_code == "001") {
					lumpApproval.hwpPutText("GUBUN1"   ,"O");
				}else if(_g_attend_code == "002") {
					lumpApproval.hwpPutText("GUBUN2"   ,"O");
				}
				var year = _g_attend_sDate.substring(0, 4);
				var month = _g_attend_sDate.substring(5, 7);
				var day =  _g_attend_sDate.substring(8, 10);
				lumpApproval.hwpPutText(""   , year);
				lumpApproval.hwpPutText("REQUEST_MONTH"   ,month);
				lumpApproval.hwpPutText("REQUEST_DAY"   ,day);
				lumpApproval.hwpPutText("REQUEST_FROM_HOUR"   ,_g_attend_sTime);
				lumpApproval.hwpPutText("REQUEST_TO_HOUR"   ,_g_attend_sHour);
				lumpApproval.hwpPutText("REQUEST_TERM"   ,_g_attend_term);

				lumpApproval.hwpPutText("REAL_MONTH"   ,month);
				lumpApproval.hwpPutText("REAL_DAY"   ,day);
				lumpApproval.hwpPutText("REAL_FROM_HOUR"   ,_g_attend_sTime);
				lumpApproval.hwpPutText("REAL_TO_HOUR"   ,_g_attend_eHour);
				lumpApproval.hwpPutText("REAL_TERM"   ,_g_attend_term);
			}
		}
}