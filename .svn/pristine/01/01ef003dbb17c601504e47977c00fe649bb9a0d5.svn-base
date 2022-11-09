<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	/* ================================================== */
	/* 변수정의 */
	/* ================================================== */
	var userSe = ('${userSe}' || ''); /* 사용자 접근 권한 */
	var rType = ('${param.rType}' || ''); /* A : 관리자 / U : 사용자 */
	var cerSeq = ('${param.cerSeq}' || '0'); /* 증명서 신청 시퀀스 */
	var apprStat = '10'; /* 증명사 상태 코드 ( 신청 : 10 / 승인 : 20 / 반려 : 30 ) */
	var appr = '20'; /* 승인 */
	var reject = '30'; /* 반려 */
	var nCompSeq = ''; /* 관리자가 사용자를 선택하여 신청하는 경우 회사 시퀀스 */
	var nEmpSeq = ''; /* 관리자가 사용자를 선택하여 신청하는 경우 사용자 시퀀스 */
	var dateFormat = 'yyyy-MM-dd';
	var usePurposeEtcStat = ['60'];
	var aSync = false;
	
	/* ================================================== */
	/* document ready */
	/* ================================================== */
	$(document).ready(function(){
		fnInit(); /* element 설정 */
		fnInitEvent(); /* event 정의 */
		fnInitBind(); /* code bind 정의 */
	});
	
	/* ================================================== */
	/* fnInit ( element 설정 ) */
	/* ================================================== */
	function fnInit(){
		/* datapicker 설정 */
		$('#v_reqDt').kendoDatePicker({ format: dateFormat });
		$('#v_reportDt').kendoDatePicker({ format: dateFormat });
		$(".controll_btn button").kendoButton();
		return;
	}
	
	/* ================================================== */
	/* fnInitEvent ( event 정의 ) */
	/* ================================================== */
	function fnInitEvent(){
		
		/* 사용목적 변경 이벤트 */
		$("#v_usePurposeCd").change(function(){
			$('#v_usePurpose').val('');
			if(usePurposeEtcStat.indexOf($(this).val()) > -1){
				$('#v_usePurpose').show();
				$('#v_usePurpose').focus().select();
			} else {
				$('#v_usePurpose').hide();
			}
		});
		
		/* 저장 */
		$('#btnSave').click(function(){
			fnSave();
		});
		/* 승인 */
		$('#btnAppr').click(function(){
			fnAppr(appr);
		});
		/* 반려 */
		$('#btnRjt').click(function(){
			fnAppr(reject);
		});
		/* 대상자 */
		$('#btnUser').click(function(){
			fnSetCertUser();
		});
		return;
	}
	
	/* ================================================== */
	/* fnInitBind ( code bind 정의 ) */
	/* ================================================== */
	function fnInitBind(){
		fnInitCertGubun(); /* 증명서 구분 */
		fnInitReqDate(); /* 신청일자 */
		fnInitReportDate(); /* 제출예정일 */
		fnInitReqCnt(); /* 출려매수 */
		fnInitUsePurpose(); /* 사용목적 */
		fnInitBaseInfo(); /* 기본 정보 */
		return;
	}
	
	/* fnInitBind ( code bind 정의 ) - 증명서 구분 */
	function fnInitCertGubun(){
		var url = '';
		switch(userSe){
			case 'USER':
				url = '<c:url value="/systemx/getCertificateUserList.do" />'
				break;
			case 'ADMIN':
				url = '<c:url value="/systemx/getCertificateList.do" />'
				break;
			default:
				alert('<%=BizboxAMessage.getMessage("TX900000444","사용자 권한 정보를 확인할 수 없습니다.")%>');
				return;
		}
		
		if(url != ''){
			$.ajax({
				type: 'post'
				, url : url
				, datatype: 'text'
				, success: function(data){
					var certList = [];
					if(Array.isArray(data.certList)){ certList = data.certList; }
					
					$.each(certList, function(idx, value){
						if(value.formNm){
							if(value.formSeq){
								$('#t_certGubun')[0].add(new Option(value.formNm, value.formSeq));
							}
						}
					});
				}
				, error: function(result){
					alert("<%=BizboxAMessage.getMessage("TX000016125", "증명서 구분 가져오기 실패")%>");
				}
			})
		}
		
		return;
	}
	/* fnInitBind ( code bind 정의 ) - 신청일자 */
	function fnInitReqDate(){
		var date = new Date();
		$('#v_reqDt').val(fnGetDatetimeFormat(date));
		
		return;
	}
	/* fnInitBind ( code bind 정의 ) - 제출예정일 */
	function fnInitReportDate(){
		var date = new Date();
		date.setDate(date.getDate() + 7);
		$('#v_reportDt').val(fnGetDatetimeFormat(date));
		
		return;
	}
	
	function fnGetDatetimeFormat(date){
		var year = date.getFullYear().toString();
		var month = date.getMonth() + 1;
		var day = date.getDate();
		
		month = ( month < 10 ? "0" + month.toString() : month.toString() );
		day = ( day < 10 ? "0" + day.toString() : day.toString() );
		
		return [year, month, day].join('-');
	}
	
	/* fnInitBind ( code bind 정의 ) - 출력매수 */
	function fnInitReqCnt(){
		for(var i=1; i<11; i++){
			var name = i.toString() + '매';
			var code = i;
			$('#v_reqCnt')[0].add(new Option(name, code));
		}
		return;
	}
	/* fnInitBind ( code bind 정의 ) - 사용목적 */
	function fnInitUsePurpose(){
		var url = '';
		
		switch(userSe){
			case 'USER':
			case 'ADMIN':
				url = '<c:url value="/systemx/getCertificateSubmitList.do" />';
				break;
			default:
				alert('<%=BizboxAMessage.getMessage("TX900000444","사용자 권한 정보를 확인할 수 없습니다.")%>');
				return;
		}
		
		if(url != ''){
			$.ajax({
				type: 'post'
				, url : url
				, datatype: 'text'
				, success: function(data){
					var certSubmitList = [];
					if(Array.isArray(data.certSubmitList)){ certSubmitList = data.certSubmitList; }
					
					$.each(certSubmitList, function(idx, value){
						if(value.detailName){
							if(value.detailCode){
								$("#v_usePurposeCd")[0].add(new Option(value.detailName, value.detailCode));
							}
						}
					});
				}
				, error: function(result){
					alert("<%=BizboxAMessage.getMessage("TX000016125", "증명서 구분 가져오기 실패")%>");
				}
			})
		}
		
		return;
	}
	/* fnInitBind ( code bind 정의 ) - 기본 정보 */
	function fnInitBaseInfo(){
		/* rType : 관리자 ( M ) / 사용자 ( A ) */
		/* cerSeq 존재 : 기 신청내역 호출 */
		if(rType == 'M' || (rType == 'A' && cerSeq != '0')){
			/* 기존 정보 조회 */
			/* 기존 정보 조회 - 저장버튼 처리 */
			fnSetSave(false); /* 저장버튼 미표현 처리 */
			/* 기존 정보 조회 - 관리자 접근 처리 */
			if(rType == 'M'){
				fnSetAppr(false); /* 승인 미표현 처리 */
				fnSetRjt(false); /* 반려 미표현 처리 */
			}
			
			var param = {};
			param.cerSeq = cerSeq
			
			$.ajax({
	        	type:"post"
	    		, url:'<c:url value="/systemx/getCertificateInfo.do" />'
	    		, datatype:"json"
				, data: param
	    		, success: function (data) {
					var cerInfo = {};
					
					if(data.cInfo){
						cerInfo = data.cInfo;
					}
					
					fnSetCerInfo(cerInfo);
	   		    }
	   		    , error: function (result) { 
	   		    	alert("<%=BizboxAMessage.getMessage("TX000016349", "기본정보 가져오기에 실패 하였습니다.")%>"); 
	  		    }
	    	});
		} else {
			$.ajax({
	        	type:"post"
	    		, url:'<c:url value="/systemx/getCertificateDefaultInfo.do"/>'
	    		, datatype:"json"
	    		, success: function (data) {
	    			console.log(data);
					var cerDefaultInfo = {};
					
					if(data.dInfo){
						cerDefaultInfo = data.dInfo;
					}
					
					fnSetDefaultCerInfo(cerDefaultInfo);
	   		    }
	   		    , error: function (result) { 
	   		    	alert("<%=BizboxAMessage.getMessage("TX000016349", "기본정보 가져오기에 실패 하였습니다.")%>"); 
	  		    }
	    	});
		}
	}
	
	/* ================================================== */
	/* 공통사용 */
	/* ================================================== */
	/* 저장버튼 활성화 / 비활성화 처리 */
	function fnSetSave(showStat){
		showStat = ( showStat || false );

		if(showStat){
			/* 버튼 활성화 */
			$("#btnSave").show();
		} else {
			/* 버튼 비활성화 */
			$("#btnSave").hide();
		}
	}
	
	/* 승인버튼 활성화 / 비활성화 처리 */
	function fnSetAppr(showStat){
		showStat = ( showStat || false );
		
		if(showStat){
			/* 버튼 활성화 */
			$("#btnAppr").show();
		} else {
			/* 버튼 비활성화 */
			$("#btnAppr").hide();
		}
	}
	
	/* 승인버튼 활성화 / 비활성화 처리 */
	function fnSetRjt(showStat){
		showStat = ( showStat || false );
		
		if(showStat){
			/* 버튼 활성화 */
			$("#btnRjt").show();
		} else {
			/* 버튼 비활성화 */
			$("#btnRjt").hide();
		}
	}
	
	/* 사용자 선택 활성화 / 비활성화 처리 */
	function fnSetEmpSelect(showStat){
		showStat = ( showStat || false );
		
		if(showStat){
			/* 버튼 활성화 */
			$("#t_empSelect").show();
		} else {
			/* 버튼 비활성화 */
			$("#t_empSelect").hide();
		}
	}
	
	/* ================================================== */
	/* fnSetCerInfo ( 증명서 신청 정보 정의 ) */
	/* ================================================== */
	function fnSetCerInfo(cerInfo){
		if(rType == 'A'){
			apprStat = cerInfo.apprStat;
			
			switch(apprStat){
				case '10':
					fnSetAppr(true);
					fnSetRjt(true);
					break;
				case '20':
					fnSetAppr(false);
					fnSetRjt(true);
					break;
				case '30':
					fnSetAppr(true);
					fnSetRjt(false);
					break;
				default:
					fnSetAppr(false);
					fnSetRjt(false);
					break;
		   }
		}
		
		
		$('#cerInfo').val(JSON.stringify(cerInfo)); /* 증명서 신청 정보 저장 */
		
		/*
		 * ## cerInfo 정의 ##
		cerInfo = {
			compSeq: '', // 회사 시퀀스
			empSeq: '', // 사원 시퀀스
			deptSeq: '', // 부서 시퀀스
			enterDt: '', // 입사일
			fireDt: '', // 퇴사일
			deptNm: '', // 부서명
			dutyNm: '', // 직책명
			gradeNm: '', // 직급명
			erpEmpNo: '', // 사원번호
			co_nm: '', // 회사명
			coNmDisp: '', // 회사명
			workAddr: '', // 사업장 주소
			chaBiz: '', // 담당업무
			empName: '', // 사원명
			reportTo: '', // 제출처
			reqDt: '', // 신청일자
			reportDt: '', // 제출예정일
			formSeq: '', // 증명서 시퀀스
			usePurpose: '', // 사용목적 기타 입력 내용
			usePurposeCd: '', // 사용목적
			reqCnt: '', // 출력매수
			bday1: '', // 주민등록번호 앞 6자리
			bday2: '' // 주민등록번호 뒤 1자리
		}
		*/
		
		/* 상황에 따른 비활성화 처리 ( 수정 불가 항목 ) */
		$('#t_certGubun').attr('disabled', true); /* 증명서 구분 비활성화 */
		$('#v_reqCnt').attr('disabled', true); /* 출력매수 비활성화 */
		$('#v_usePurposeCd').attr('disabled', true); /* 사용목적 비활성화 */
		$("[name='createInfo']").prop('disabled',true); /* 사원번호, 성명, 부서, 직위, 제출처, 담당업무, 사용목적, 주민등록번호 비활성화 */
		$('#v_reqDt').data('kendoDatePicker').enable(false); /* 신청일자 비활성화 */
		$('#v_reportDt').data('kendoDatePicker').enable(false); /* 제출예정일 비활성화 */
		/* 표현정보 반영 ( 사용자 화면 표현 ) */
		$("#v_chaBiz").val(cerInfo.chaBiz || ''); /* 담당업무 */
		$("#v_erpEmpNo").val(cerInfo.erpEmpNo || ''); /* 사원번호 */
		$("#v_empName").val(cerInfo.empName || ''); /* 사원명 */
		$("#v_empName2").val(cerInfo.empName || ''); /* 대상자 사원명 */
		$("#v_deptName").val(cerInfo.deptNm || ''); /* 부서명 */
		$("#v_positionName").val(cerInfo.dutyNm || ''); /* 직위명 */
		$("#v_reportTo").val(cerInfo.reportTo || ''); /* 제출처 */
		$("#v_reqDt").val(cerInfo.reqDt.length == 8 ? cerInfo.reqDt.substr(0,4) + "-" + cerInfo.reqDt.substr(4,2) + "-" + cerInfo.reqDt.substr(6,2) : cerInfo.reqDt); /* 신청일자 */
		$("#v_reportDt").val(cerInfo.reportDt.length == 8 ? cerInfo.reportDt.substr(0,4) + "-" + cerInfo.reportDt.substr(4,2) + "-" + cerInfo.reportDt.substr(6,2) : cerInfo.reportDt); /* 제출예정일 */
		$("#t_certGubun").val(cerInfo.formSeq || ''); /* 증명서 구분 */
		$("#v_usePurpose").val(cerInfo.usePurpose || ''); /* 사용목적 기타 입력 내용 */
		$("#v_usePurposeCd").val(cerInfo.usePurposeCd || ''); /* 사용목적 */
		$("#v_reqCnt").val(cerInfo.reqCnt || ''); /* 출력매수 */
		$("#v_bday1").val(cerInfo.bday1 || ''); /* 주민등록번호 앞 6자리 */
		$("#v_bday2").val(cerInfo.bday2 || ''); /* 주민등록번호 뒤 1자리 */
		
		if(usePurposeEtcStat.indexOf(cerInfo.usePurposeCd || '') > -1){
			/* 상세내역 입력의 다중화 발생 예상으로 배열로 정의 */
			$("#v_usePurpose").show(); /* 사용목적 기타 입력 내용 */
		}
	}
	
	function fnSetDefaultCerInfo(cerInfo){
		if (rType == "A") {
			fnSetEmpSelect(true);
		}
		
		$('#cerInfo').val(JSON.stringify(cerInfo)); /* 증명서 신청 정보 저장 */
		
		/* ## cerInfo 정의 ## */
		// cerInfo = {
		//	emp_seq: '', /* 사원번호 */
		//	comp_seq: '', /* 회사시퀀스 */
		//	duty_code_name: '', /* 직책명 */
		//	duty_nm: '', /* 직책명 */
		//	position_code_name: '', /* 직급명 */
		//	grade_nm: '', /* 직급명 */
		//	join_day: '', /* 입사일 */
		//	enter_dt: '', /* 입사일 */
		//	resign_day: '', /* 퇴직일 */
		//	fire_dt: '', /* 퇴직일 */
		//	emp_name: '', /* 사원명 */
		//	emp_num: '', /* 사원번호 */
		//	erp_emp_num: '', /* ERP 사원번호 */
		//	erp_emp_no: '', /* ERP 사원번호 */
		//	comp_name: '', /* 회사명 */
		//	co_nm: '', /* 회사명 */
		//	comp_display_name: '', /* 회사명(옵션) */
		//	co_nm_disp: '', /* 회사명(옵션) */
		//	co_work: '', /* 회사주소 */
		//	co_addr: '', /* 회사주소 */
		//	dept_seq: '', /* 부서시퀀스 */
		//	dept_name: '', /* 부서명 */
		//	dept_nm: '', /* 부서명 */
		//	zip_code: '', /* 부서 우편번호 */
		//	dept_zip_code: '', /* 부서 우편번호 */
		//	dept_addr: '', /* 부서 주소 */
		//	dept_detail_addr: '', /* 부서 주소 상세 */
		//	main_work: '', /* 담당업무 */
		//	cha_biz: '', /* 담당업무 */
		//	bday1: '', /* 생일 */
		//	bday2: '' /* 성별 */
		// }
		
		nCompSeq = (cerInfo.compSeq || '');
		nEmpSeq = (cerInfo.empSeq || '');
		
		$("#v_chaBiz").val(cerInfo.mainWork || ''); /* 담당업무 */
		$("#v_erpEmpNo").val(cerInfo.erpEmpNum || ''); /* 사원번호 */
		$("#v_empName").val(cerInfo.empName || ''); /* 사원명 */
		$("#v_empName2").val(cerInfo.empName || ''); /* 대상자 사원명 */
		$("#v_deptName").val(cerInfo.deptName || ''); /* 부서명 */
		$("#v_positionName").val(cerInfo.positionCodeName || ''); /* 직위명 */
		$("#v_bday1").val(cerInfo.bday1 || ''); /* 주민등록번호 앞 6자리 */
		$("#v_bday2").val(cerInfo.bday2 || ''); /* 주민등록번호 뒤 1자리 */
	}
	
	/* ================================================== */
	/* 신청 */
	/* ================================================== */
	function fnSave(){
		var deptName = ($("#v_deptName").val() || '');
		var reportTo = ($('#v_reportTo').val() || '');
		var usePurposeCd = ($("#v_usePurposeCd").val() || '');
		var usePurpose = '';
		
		if(usePurposeEtcStat.indexOf(usePurposeCd) > -1){
			usePurpose = ($("#v_usePurpose").val() || '');
		}
		
		/* 필수값 점검 */
		/* 필수값 점검 - 부서명 */
		if((deptName || '') == ''){
			alert("<%=BizboxAMessage.getMessage("TX000007115","부서명을 입력하세요.")%>");
			$("#v_deptName").focus();
			return false;
		}
		/* 필수값 점검 - 제출처 */
		if((reportTo || '') == ''){
			alert("<%=BizboxAMessage.getMessage("TX000005824", "제출처를 입력해 주십시요.")%>");
			$("#v_reportTo").focus();
			return false;
		}
		/* 필수값 점검 - 사용목적 */
		if(usePurposeEtcStat.indexOf(usePurposeCd) > -1){
			if((usePurposeCd || '') == '' || (usePurpose || '') == '') {
				alert("<%=BizboxAMessage.getMessage("TX000016345", "기타사유의 상세정보를 입력해 주세요.")%>");
				$("#v_usePurpose").focus();
				return false;
			}
		}
		
		/*
		 * ## cerInfo 정의 ##
		cerInfo = {
			compSeq: '', // 회사 시퀀스
			empSeq: '', // 사원 시퀀스
			deptSeq: '', // 부서 시퀀스
			enterDt: '', // 입사일
			fireDt: '', // 퇴사일
			deptNm: '', // 부서명
			dutyNm: '', // 직책명
			gradeNm: '', // 직급명
			erpEmpNo: '', // 사원번호
			co_nm: '', // 회사명
			coNmDisp: '', // 회사명
			workAddr: '', // 사업장 주소
			chaBiz: '', // 담당업무
			empName: '', // 사원명
			reportTo: '', // 제출처
			reqDt: '', // 신청일자
			reportDt: '', // 제출예정일
			formSeq: '', // 증명서 시퀀스
			usePurpose: '', // 사용목적 기타 입력 내용
			usePurposeCd: '', // 사용목적
			reqCnt: '', // 출력매수
			bday1: '', // 주민등록번호 앞 6자리
			bday2: '' // 주민등록번호 뒤 1자리
		}
		*/
		
		/* 저장 파라미터 정의 */
		var param = {};
		$.extend(param, JSON.parse($('#cerInfo').val() || '{}'));
		param.formSeq = ($("#t_certGubun").val() || ''); /* 증명서 구분 시퀀스 */
		param.formNm = ($("#t_certGubun option:selected").text() || ''); /* 증명서 구분 명 */
		if(usePurposeEtcStat.indexOf(($("#v_usePurposeCd").val() || '')) > -1){
			param.purposeNm = $("#v_usePurpose").val(); /* 사용목적 기타 ( 사용자 입력 ) */
		} else {
			param.purposeNm = $("#v_usePurposeCd option:selected").text(); /* 사용목적 */
		}
		param.eCompSeq = (nCompSeq || ''); /* 대상자 회사 시퀀스 */
		param.eEmpSeq = (nEmpSeq || ''); /* 대상자 사원 시퀀스 */
		param.adminReqYn = ((rType|| '') == 'A' ? 'Y' : 'N'); /* 관리자 작성 여부 */
		param.deptNm = ($("#v_deptName").val() || '');
		param.reqDt = ($("#v_reqDt").val().replace(/-/gi, "") || ''); /* 신청일자 */
		param.reportTo = ($("#v_reportTo").val() || ''); /* 제출처 */
		param.reportDt = ($("#v_reportDt").val().replace(/-/gi, "") || ''); /* 제출예정일 */
		param.usePurpose = ($("#v_usePurpose").val() || ''); /* 사용목적 기타 ( 사용자 입력 ) */
        param.usePurposeCd = ($("#v_usePurposeCd").val() || ''); /* 사용목적 */
        param.erpEmpNo = $("#v_erpEmpNo").val(); /* 재직자 사원번호 */
       	param.chaBiz = $('#v_chaBiz').val(); /* 재직자 담당업무 */
		param.reqCnt = $("#v_reqCnt").val(); /* 출력매수 */
		param.bday1 = $("#v_bday1").val(); /* 주민등록번호 앞 6자리 */
		param.bday2 = $("#v_bday2").val(); /* 주민등록번호 뒤 1자리 */
		
		$.ajax({
			type:"post"
			, url:'<c:url value="/systemx/requestCertificate.do"/>'
			, datatype:"json"
			, data: param
			, success: function (data) {
				alert("<%=BizboxAMessage.getMessage("TX000002073", "저장되었습니다.")%>");
				
				if(window.opener && (typeof typeof window.opener.BindListGrid != 'undefined'))
				{
					opener.BindListGrid();
				}
				
				self.close();
			}
			, error: function(data){
				alert("<%=BizboxAMessage.getMessage("TX000005212", "저장에 실패했습니다.")%>"); 
			}
		});
		
		return;
	}
	
	/* ================================================== */
	/* 대상자 선택 */
	/* ================================================== */
	function fnSetCertUser(){
		var pop = window.open("", "cmmOrgPop", "width=799,height=789,scrollbars=no");
		
        $("input[name=callback]").val("fnOrgReturnCallback");
        /* $("input[name=compSeq]").val('6'); */
        
        frmPop.target = "cmmOrgPop";
        frmPop.method = "post";
        frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
        frmPop.submit();
        
        pop.focus();
		
		return;
	}
	
	function fnOrgReturnCallback(returnObj){
		var returnCompSeq = ''
			, returnDeptSeq = ''
			, returnEmpSeq = ''
			, returnEmpName = '';
		
		if(returnObj.receiveParam){
			returnCompSeq = (returnObj.receiveParam.compSeq || '');
		}
		
		if(returnObj.returnObj){
			if(Array.isArray(returnObj.returnObj)){
				/* 단일 선택으로 무조건 0번째 index */
				var returnEmpInfo = returnObj.returnObj[0];
				
				returnDeptSeq = returnEmpInfo.deptSeq;
				returnEmpSeq = returnEmpInfo.empSeq;
				returnEmpName = returnEmpInfo.empName;
			}
		}

		if(returnCompSeq == '' || returnDeptSeq == '' || returnEmpSeq == '' || returnEmpName == '') {
			alert('사용자가 선택되지 않았습니다.');
		} else {
			nEmpSeq = (returnEmpSeq || '');
			nDeptSeq = (returnDeptSeq || '');
			fnGetUserInfo(nEmpSeq, nDeptSeq);
		}
		
		return;
	}
	
	function fnGetUserInfo(empSeq, deptSeq){
		var param = {};
		param.eSeq = (empSeq || '');
		param.dSeq = (deptSeq || '');
		
		$.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/getCertificateDefaultInfo.do"/>',
    		datatype:"json",
            data: param,
    		success: function (data) {
				var cerDefaultInfo = {};

				if(data.dInfo){
					cerDefaultInfo = data.dInfo;
				}

				fnSetDefaultCerInfo(cerDefaultInfo);
   		    },
   		    error: function (result) { 
   		    	alert("<%=BizboxAMessage.getMessage("TX000016151", "인증서 기본정보 가져오기에 실패 하였습니다.")%>"); 
  		    }
    	});
	}
	
	/* ================================================== */
	/* 승인 / 반려 */
	/* ================================================== */
	function fnAppr(apprStat){
		var alertMsg = (apprStat =="20" ? "<%=BizboxAMessage.getMessage("TX000012282", "승인하시겠습니까")%>?" : "<%=BizboxAMessage.getMessage("TX000003389", "반려하시겠습니까?")%>");
		
		if(!confirm(alertMsg)){
			return;
		}
		
		var extend = {};
		$.extend(extend, JSON.parse($('#cerInfo').val() || '{}'));
		
		var param = {};
		param.cerSeq = (cerSeq || '');
		param.apprStat = (apprStat || '');
		param.formNm = ($("#t_certGubun option:selected").text() || ''); /* 증명서 구분 명 */
		param.deptNm = (extend.deptNm || '');
		param.gradeNm = (extend.gradeNm || '');
		param.userName = (extend.empName || '');
		param.userSeq = (extend.empSeq || '');
		param.purposeNm  = (extend.usePurpose2 || '');
		param.reportTo = (extend.reportTo || '');
		param.applyDate = (extend.reqDt.substring(0,4)+'-'+extend.reqDt.substring(4,6)+'-'+extend.reqDt.substring(6,8)  || '');
		
		$.ajax({
        	type: "post"
    		, url: '<c:url value="/systemx/apprCertificate.do"/>'
    		, datatype: "json"
            , data: param
    		, success: function (count) {
   				alert("<%=BizboxAMessage.getMessage("TX000014893", "처리되었습니다.")%>");
				
				if(window.opener && (typeof typeof window.opener.BindListGrid != 'undefined'))
				{					
					try {  
						opener.BindListGrid();
					}  
					catch(e) {  	
						console.log(e);//오류 상황 대응 부재
					}  
				}
				
				self.close();
    		}
   		    , error: function (result) { 
   		    	alert("<%=BizboxAMessage.getMessage("TX000016117", "처리에 실패하였습니다.")%>"); 
  		    }
    	});	
	}

</script>

<input type="hidden" id="h_compSeq" name="h_compSeq" />
<input type="hidden" id="h_empSeq" name="h_empSeq" />
<input type="hidden" id="h_deptSeq" name="h_deptSeq" />
<input type="hidden" id="h_joinDay" name="h_joinDay" />
<input type="hidden" id="h_resignDay" name="h_resignDay" />
<input type="hidden" id="h_deptName" name="h_deptName" />
<input type="hidden" id="h_dutyCodeName" name="h_dutyCodeName" />
<input type="hidden" id="h_positionCodeName" name="h_positionCodeName" />
<input type="hidden" id="h_empNum" name="h_empNum" />
<input type="hidden" id="h_erpEmpNum" name="h_erpEmpNum" />
<input type="hidden" id="h_compName" name="h_compName" />
<input type="hidden" id="h_compDisplayName" name="h_compDisplayName" />
<input type="hidden" id="h_deptZipCode" name="h_deptZipCode" />
<input type="hidden" id="h_deptAddr" name="h_deptAddr" />
<input type="hidden" id="h_deptDetailAddr" name="h_deptDetailAddr" />
<input type="hidden" id="h_mainWork" name="h_mainWork" />
<input type="hidden" id="h_telNum" name="h_telNum" />
<input type="hidden" id="h_workAddr" name="h_workAddr" />
<input type="hidden" id="cerInfo" />
	
<div class="pop_wrap">
	<!-- 사용자 단일 선택 폼 기본 형  -->
	<form id="frmPop" name="frmPop" style="display: none;">

		<input type="text" name="popUrlStr" id="txt_popup_url" width="800" value="/gw/systemx/orgChart.do"><br>
		<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  -->
		<input type="text" name="selectMode" width="500" value="u" /><br>
		<!-- value : [s : 단일선택], [m : 복수 선택]-->
		<input type="text" name="selectItem" width="500" value="s" /><br>
		<input type="text" name="callback" width="500" value="" /><br>
		<input type="text" name="langCode" width="500" value="kr" /><br>
		<input type="text" name="groupSeq" width="500" value="" /><br>
		<input type="text" name="compFilter" width="500" value="${compSeq}" /><br>
		<input type="text" name="compSeq" width="500" value=""/><br>
		<input type="text" name="deptSeq" width="500" value="${deptSeq}" /><br>
		<input type="text" name="empSeq" width="500" value="${empSeq}" /><br>
		<input type="text" name="callbackParam" width="500" value="params. - call back param" /><br>
	</form>

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage( "TX000005827", "증명서신청" )%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con scroll_y_on mb20" style="height: 100%;">
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr id="t_empSelect" style="display: none;">
					<!-- 관리자 일때 사용 -->
					<th><%=BizboxAMessage.getMessage( "TX000005018", "대상자" )%></th>
					<td colspan="3"><input id="v_empName2" type="text" value="" style="width: 127px" disabled />
						<div class="controll_btn p0">
							<button id="btnUser"><%=BizboxAMessage.getMessage( "TX000000265", "선택" )%></button>
						</div></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage( "TX000001014", "증명서구분" )%></th>
					<td><select id="t_certGubun" style="margin-right: 5px; float: left;"></td>
					<th><%=BizboxAMessage.getMessage( "TX000000981", "신청일자" )%></th>
					<td><input id="v_reqDt" value="2015-01-01" class="dpWid" /></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage( "TX000000961", "사번" )%></th>
					<td><input name="createInfo" id="v_erpEmpNo" type="text" value="" style="width: 90%" /></td>
					<th><%=BizboxAMessage.getMessage( "TX000000978", "성명" )%></th>
					<td><input name="createInfo" id="v_empName" type="text" value="" style="width: 90%" disabled /></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage( "TX000000098", "부서" )%></th>
					<td><input name="createInfo" id="v_deptName" type="text" value="" style="width: 90%" /></td>
					<th><%=BizboxAMessage.getMessage( "TX000001020", "직위" )%></th>
					<td><input name="createInfo" id="v_positionName" type="text" value="" style="width: 90%" disabled /></td>
				</tr>
				<tr>
					<th><img src="/gw/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage( "TX000001005", "제출처" )%></th>
					<td><input name="createInfo" id="v_reportTo" type="text" value="" style="width: 90%" /></td>
					<th><%=BizboxAMessage.getMessage( "TX000001004", "제출예정일" )%></th>
					<td><input id="v_reportDt" value="2015-01-01" class="dpWid" /></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage( "TX000004504", "출력매수" )%></th>
					<td><select id="v_reqCnt" style="margin-right: 5px; float: left;"></td>
					<th><%=BizboxAMessage.getMessage( "TX000000088", "담당업무" )%></th>
					<td><input name="createInfo" id="v_chaBiz" type="text" value="" style="width: 90%" /></td>
				</tr>
				<tr>
					<th><img src="/gw/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage( "TX000003584", "용도" )%></th>
					<td><select id="v_usePurposeCd" style="margin-right: 5px; float: left;">
							<input name="createInfo" id="v_usePurpose" type="text" value="" style="width: 250px; display: none;" />
							<!-- 기타사유일때만 사용 --></td>
					<th><%=BizboxAMessage.getMessage( "TX000002814", "주민등록번호" )%></th>
					<td><input name="createInfo" id="v_bday1" type="text" value="" style="width: 59px;" onkeyup="javascript:maxLengthMove(this);" maxlength=6 /> - <input name="createInfo" id="v_bday2" type="text" value="" style="width: 16px;" maxlength=1 />******</td>
				</tr>
			</table>
		</div>

		<!-- 관리자 일때 사용 -->
		<div class="com_ta mt20" style="display: none;">
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tbody>
					<tr>
						<th><%=BizboxAMessage.getMessage( "TX000005821", "인감삽입" )%></th>
						<td><input type="radio" name="mf" id="mf1" class="k-radio" checked="checked" /> <label class="k-radio-label radioSel" for="mf1"><%=BizboxAMessage.getMessage( "TX000016153", "인감이미지 삽입" )%></label> <input type="radio" name="mf" id="mf2" class="k-radio" /> <label class="k-radio-label radioSel ml10" for="mf2"><%=BizboxAMessage.getMessage( "TX000016152", "인감이미지 제외" )%></label></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage( "TX000003417", "처리내용" )%></th>
						<td><textarea style="height: 80px; width: 98%; padding: 5px;"></textarea></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input id="btnSave" type="button" value="<%=BizboxAMessage.getMessage( "TX000001256", "저장" )%>" /> <input id="btnAppr" type="button" value="<%=BizboxAMessage.getMessage( "TX000000798", "승인" )%>" style="display: none;" /> <input id="btnRjt" type="button" value="<%=BizboxAMessage.getMessage( "TX000002954", "반려" )%>" style="display: none;" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<!--// pop_wrap -->