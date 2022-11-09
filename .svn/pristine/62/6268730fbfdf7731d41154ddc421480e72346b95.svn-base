<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<%
	String authCode = request.getParameter("authCode");
%>

<script type="text/javascript">
	// 파라미터로 넘겨 받은 권한 코드
	var authCodeRequest = "<%= authCode %>"; 
	var newAuthFlag = false;
	
	$(document).ready(function() {
		// 버튼 기본 동작
		fnButtonInit();

		// 팝업 크기 조절
		fnSetResize();

		// 노출 메뉴 호출
		fnMenuList();

		// 권한회사/회계단위 호출(erp데이터)
		fnGWErpInfoList();
		
		// 권한 호출
		fnAuthList();
	});

	// 버튼 기본 동작
	function fnButtonInit() {
		// 신규 버튼
		$("#newAuthBtn").click(function() {
			fnNewAuth();
		});

		// 저장 버튼
		$("#authSaveBtn").click(function() {
			fnAuthSave();
		});

		// 삭제 버튼
		$("#authDeleteBtn").click(function() {
			fnAuthDelete();
		});

		// 확인 버튼
		$("#checkBtn").click(function() {
			fnCheck();
		});

		// 취소 버튼
		$("#cancelBtn").click(function() {
			fnCancel();
		});
		
		// 권한 체크 이벤트
		$("#authList").on('click', 'input:radio[name=authCheck]', function() {
			var authCode = $(this).attr("id");	
			authCodeRequest = "";
			newAuthFlag = false;
			fnAuthMappingMenu(authCode);
		});
		
		// GW회사 체크박스 이벤트
		$("#GWErpInfoList").on('click', 'input:checkbox[name="gwComp"]', function(){
			if($(this).prop("checked")) {
				var tempId = $(this).attr("id");
				var length = tempId.length;
				var id = $(this).attr("id").substring(2, length);
		
				$("#GWErpInfoList input:checkbox[gwComp=" + id + "]").prop("checked", true);
				//$("#GWErpInfoList input:checkbox[gwComp=" + id + "]").prop("indeterminate", true);

			}else {
				var tempId = $(this).attr("id");
				var length = tempId.length;
				var id = $(this).attr("id").substring(2, length);
		
				$("#GWErpInfoList input:checkbox[gwComp=" + id + "]").prop("checked", false);
				$("#GWErpInfoList input:checkbox[gwComp=" + id + "]").prop("indeterminate", false);
			}
		});
		
		// 권한회사/회계단위 선택 체크 박스 이벤트 (회사)
		$("#GWErpInfoList").on('click', 'input:checkbox[name="erpComp"]', function(){
			if($(this).prop("checked")) {
				var tempId = $(this).attr("id");
				var length = tempId.length;
				var gwId = $(this).attr("gwComp");
				
				$("#GW"+gwId).prop("checked", true);
				
				var id = $(this).attr("id").substring(1, length).split("_")[0];
				var gwCompSeq = $(this).attr("gwComp");
				
				$("#GWErpInfoList input:checkbox[name='erpBiz']").each(function(){
					if($(this).attr("id").split("|")[1] == id && $(this).attr("gwComp") == gwCompSeq) {
						$(this).prop("checked", true);
					}
				});
			} else {
				var tempId = $(this).attr("id");
				var length = tempId.length;
				var gwId = $(this).attr("gwComp");
				
				$("#GW"+gwId).prop("checked", false);
				
				var id = $(this).attr("id").substring(1, length).split("_")[0];
				var gwCompSeq = $(this).attr("gwComp");
			
				$("#GWErpInfoList input:checkbox[name='erpBiz']").each(function(){
					if($(this).attr("id").split("|")[1] == id && $(this).attr("gwComp") == gwCompSeq) {
						$(this).prop("checked", false);
					}
				});
			}
		});
		
		// 권한회사/회계단위 선택 체크 박스 이벤트 (사업장)
		$("#GWErpInfoList").on('click', 'input:checkbox[name="erpBiz"]', function(){
			fnErpBizCheckEvent($(this).attr("class"), $(this).attr("gwcomp"));
		});
	}

	// [권한상세 - 노출메뉴선택] 노출 메뉴 데이터 가져오기
	function fnMenuList() {
		var param = {};
		
		$.ajax({
			type : "POST",
			data : param,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthMenuListInfoSelect.do" />',
			success : function(result) {
				fnMenuListDraw(result.menuAuthList);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000015955","메뉴를 불러오는데 실패했습니다.")%>");
			}
		});
	}

	// [권한상세 - 노출메뉴선택] 노출메뉴 그려주기
	function fnMenuListDraw(data) {
		var tag = '';
		var length = data.length;

		for (var i = 0; i < length; i++) {
			if (data[i].detail_code == "") {
				$("#mainMenuName").html(data[i].detail_name);
			} else {
				tag += '<li><p>';
				tag += '<input type="checkbox" class="authMenuList" disabled id="' + data[i].detail_code + '" />';
				tag += '<label for="' + data[i].detail_code + '">'
						+ data[i].detail_name + '</label>';
				tag += '</li></p>';
			}
		}

		$("#menuAuthList").html(tag);
	}	
	
	// [권한상세 - 권한회사/회계단위 선택] 권한회사/회계단위 호출(erp데이터)
	function fnGWErpInfoList() {
		var param = {};

		$.ajax({
			type : "POST",
			data : param,
			async : false,
			url : '<c:url value="/accmoney/auth/ErpDeptListInfoSelect.do" />',
			success : function(result) {
				fnGWErpInfoListDraw(result.GWCompInfo, result.GWErpInfoList);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}	
	
	// [권한상세 - 권한회사/회계단위 선택] 권한회사/회계단위 호출(erp데이터) GW 그려주기
	function fnGWErpInfoListDraw(GWData, ERPData) {
		var tag = '';
		var erpTag = '';
		var GWLength = GWData.length;
		
		for(var i=0; i<GWLength; i++) {
			tag += '<li>';
			tag += '<p>';
			tag += '<input type="checkbox" name="gwComp" id="GW' + GWData[i].comp_seq + '" />';
			tag += '<label for="GW' + GWData[i].comp_seq + '">' + GWData[i].comp_name + '</label>';
			tag += '</p>';
			tag += '<ul id="GWComp_' + GWData[i].comp_seq + '"></ul>';
			tag += '</li>';
			
		}
		$("#GWErpInfoList").html(tag);
		
		fnErpInfoListDraw(ERPData);
	}	
	
	// [권한상세 - 권한회사/회계단위 선택] 권한회사/회계단위 호출(erp데이터) ERP 그려주기
	function fnErpInfoListDraw(ERPData) {
		var tag = '';
		var ERPLength = ERPData.length;
	
		for (var j = 0; j < ERPLength; j++) {
			if (ERPData[j].GBN == "C") {
				tag += '<li>';
				tag += '<p>';
				tag += '<input type="checkbox" gwComp="' + ERPData[j].gwCompSeq + '" name="erpComp" id="C' + ERPData[j].CODE + '_' + ERPData[j].gwCompSeq + '" />';
				tag += '<label for="C' + ERPData[j].CODE + '_' + ERPData[j].gwCompSeq + '">' + ERPData[j].NAME + '</label>';
				tag += '</p>';
			}

			for (var k = 0; k < ERPLength; k++) {
				if (ERPData[j].GBN == "C" && ERPData[j].CODE == ERPData[k].compSeq
						&& ERPData[k].GBN == "D" && ERPData[j].gwCompSeq == ERPData[k].gwCompSeq) {
					tag += '<ul>';
					tag += '<li>';
					tag += '<p>';
					tag += '<input type="checkbox" gwComp="' + ERPData[k].gwCompSeq + '" class="C' + ERPData[j].CODE + '_' + ERPData[k].gwCompSeq + '" bizName="' + ERPData[k].NAME + '" compName="' + ERPData[j].NAME + '" name="erpBiz" compSeq="' + ERPData[k].compSeq + '" id="D' + ERPData[k].CODE + '|' + ERPData[k].compSeq + '" />';
					tag += '<label for="D' + ERPData[k].CODE + '">' + ERPData[k].NAME + '</label>';
					tag += '</li>';
					tag += '</p>';
					tag += '</ul>';
				}
			}
			
			if(ERPData[j].GBN == "C") {
				tag += '</li>';
				$("#GWComp_" + ERPData[j].gwCompSeq).html(tag);	
				tag = '';
			}
			
		}
	}		
	
	// [권한목록] 권한목록 데이터 가져오기
	function fnAuthList() {
		var param = {};
		param.authName = "";
		param.erpSeq = "";

		$.ajax({
			type : "POST",
			data : param,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthListInfoSelect.do" />',
			success : function(result) {
				fnAuthListDraw(result.authList);
				
				if(authCodeRequest != "undefined") {
					fnAuthMappingMenu(authCodeRequest);
				}
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000015954","권한 호출 시 에러가 발생하였습니다.")%>");
			}
		});
	}	
	
	// [권한목록] 권한 그려주기
	function fnAuthListDraw(data) {
		var tag = '';
		var length = data.length;

		for(var i=0; i<length; i++) {
			if(data[i].order_num != "1") {
				tag += '<tr>';
				tag += '<td>';
				tag += '<input type="radio" name="authCheck" id="' + data[i].auth_code + '" class="k-radio" /> ';
				tag += '<label class="k-radio-label radioSel" for="' + data[i].auth_code + '"></label>';
				tag += '</td>';
				tag += '<td class="le">' + data[i].auth_code_nm + '</td>';
				tag += '</tr>';
			}
		}
		
		$("#authList").html(tag);
	}	
	
	// [권한상세 - 권한회사/회계단위 선택] 권한 메뉴 맵핑 정보 가져오기
	function fnAuthMappingMenu(authCode) {
		var params = {};

		params.authCode = authCode;

		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthMappingData.do" />',
			success : function(result) {
				$("input:checkbox[name='gwComp']").attr("checked", false);
				$("input:checkbox[name='gwComp']").attr("indeterminate", false);
	
				$("input:checkbox[name='erpComp']").attr("checked", false);
				$("input:checkbox[name='erpComp']").attr("indeterminate", false);
				$("input:checkbox[name='erpBiz']").attr("checked", false);
				var mappingCheck = result.authMappingData;
				var length = mappingCheck.length;
				var erp_co_cd = '';
				var erp_biz_cd = '';
				var menuCodeCnt = 0;
				var mainMenuCheck = '';
				
				// 권한회사/회계단위 선택되어 있을 경우 노출메뉴 여부 확인 ( 1개 이상일 경우 전체로 간주함 )
				if( length > 0 ){
					mainMenuCheck = mappingCheck[0].menu_code;
					menuCodeCnt = mainMenuCheck.split('|').length;
				}
				
				// 권한 정보
				$("#" + authCodeRequest).attr("checked", true);
				$("#authNameInput").val(mappingCheck[0].auth_code_nm);
				$("#authEtcInput").val(mappingCheck[0].etc);
				
				if(mappingCheck[0].use_yn == "Y") {
					$("#authUseY").prop("checked", true);
				} else {
					$("#authUseN").prop("checked", true);
				}

				// 메뉴 체크 이벤트
				$("input:checkbox[name='erpBiz']").each(function() {
					for (var i = 0; i < length; i++) {
						erp_co_cd = mappingCheck[i].erp_co_cd;
						erp_biz_cd = mappingCheck[i].erp_biz_cd;
						var key = erp_biz_cd + "|" + erp_co_cd;
						var gwCompSeq = mappingCheck[i].comp_seq;
						
						if($(this).attr("id") == key && $(this).attr("gwComp") == gwCompSeq) {
							$(this).prop("checked", true);
							fnErpBizCheckEvent($(this).attr("class"), gwCompSeq)
						}
					}
				});
				
				$("input:checkbox[name='erpComp']").each(function() {
					for (var i = 0; i < length; i++) {
						erp_co_cd = mappingCheck[i].erp_co_cd;
						var gwCompSeq = mappingCheck[i].comp_seq;
						
						if($(this).attr("id") == "C" + erp_co_cd && $(this).attr("gwComp") == gwCompSeq) {
							$(this).prop("checked", true);
							fnErpCompCheckEvent(erp_co_cd);
						}
					}
				});
				
				$("input:radio[name='mainMenuName']").each(function() {
					if(menuCodeCnt == 1 && mainMenuCheck == '006' ){		
						if($(this).attr("id") == "006" ) {
							$(this).prop("checked", true);
						}						
					}else{
						if($(this).attr("id") == "all" ) {
							$(this).prop("checked", true);
						}						
					}
				});						
				
				
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}		
	
	// [이벤트] 저장 버튼 동작
	function fnAuthSave() {
		if(newAuthFlag == true || authCodeRequest =="undefined") {	
			fnAuthCreate();	
		} else {
			fnAuthEdit();
		}
		
	}	
	
	// 신규 권한 생성
	function fnAuthCreate() {
		var params = {};
		var compArray = new Array();
		var erpOrgChartCheck = false;
		var authName = $("#authNameInput").val() || "";
		params.authName = authName;
		params.authEtc = $("#authEtcInput").val() || "";
		params.authUseYN = $(".authUseYN:checked").val();
		
		
		$("input:checkbox[name='gwComp']").each(function(){
			if($(this).prop("checked") || $(this).prop("indeterminate")){
				var compInfo = {};
				var tempId = $(this).attr("id");
				var length = tempId.length;
				compInfo.compSeq = tempId.substring(2, length); 
				compArray.push(compInfo);
			} else {
				
			}
			
		});
		var info = {};
		info.compSeq = compArray;
		params.compSeq = JSON.stringify(info);

		// 필수체크 값 확인 (권한명)
		if(authName == "") {
			alert("<%=BizboxAMessage.getMessage("TX000015958","필수값이 저장되지 않았습니다. 다시 확인해주세요.")%>");
			return;
		}
		
		// erp 조직도 체크 확인
		$("input:checkbox[name='erpBiz']").each(function() {
			if ($(this).is(":checked") == true) {
				erpOrgChartCheck = true;	
			}
		});
		
		// 필수체크 값 확인 (erp 조직도)
		if(!erpOrgChartCheck){
			alert("<%=BizboxAMessage.getMessage("TX000015958","필수값이 저장되지 않았습니다. 다시 확인해주세요.")%>");
			return;
		}

		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthInfoInsert.do" />',
			success : function(result) {
				//console.log(JSON.stringify(result));
				fnAuthMenuCreate(result.aaData);
				fnNewAuth();
				window.close();
				
				window.opener.location.reload();
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}	
	
	// 권한에 따른 메뉴, erp 데이터 저장
	function fnAuthMenuCreate(authCode) {
		var params = {};
		var erpCompCode = {};
		var erpBizCode = {};
		var menuArray = new Array();
		var erpInfoArray = new Array();
		
		
		// 메뉴 정보
		/*
		$(".authMenuList").each(function() {
			var id = $(this).attr("id");
			
			menuArray.push(id);
		});
		*/

		// TODO: 구분 값 줘야함(2차개발 시 )
		// 자금관리(전체메뉴) 선택 시 모든 하위 메뉴 코드를 넘겨줌
		if($('input:radio[name="mainMenuName"]:checked').val()=='all'){
			$(".authMenuList").each(function() {
				var id = $(this).attr("id");
				//console.log(id);
				menuArray.push(id);
			});
		}else{
			//채권연령분석 메뉴만 넘겨줌
			menuArray.push('006');
		}		
		
		
		// erp 체크 메뉴
		$("input:checkbox[name='erpBiz']").each(function() {
			var compSeq = '';		// erp 회사코드
			var bizSeq = '';		// erp 사업장코드
			var compName = '';		// erp 회사 이름
			var bizName = '';		// erp 사업장이름
			var gwCompSeq = '';		// GW 회사시퀀스

			if ($(this).is(":checked") == true) {
				var erpInfo = {};
				compSeq = $(this).attr("compSeq");
				bizSeq = $(this).attr("id").split("|")[0];
				compName = $(this).attr("compName");
				bizName = $(this).attr("bizName");
				gwCompSeq = $(this).attr("gwComp");

				erpInfo.erpComp = compSeq;
				erpInfo.erpBiz = bizSeq;
				erpInfo.erpCompNm = compName;
				erpInfo.erpBizNm = bizName;
				erpInfo.gwCompSeq = gwCompSeq;

				erpInfoArray.push(erpInfo);
			}
		});

		var info = {};
		info.authName = $("#authNameInput").val();
		info.authEtc = $("#authEtcInput").val();
		info.authUseYN = $(".authUseYN:checked").val();;
		info.menuArray = menuArray;
		info.erpInfo = erpInfoArray;
		info.authCode = authCode;

		params.info = info;
		params.info = JSON.stringify(params.info);

		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthMenuDeptInfoInsert.do" />',
			success : function(result) {
				if(result.result == "success") {
					authCodeRequest = "undefined";
					// 권한 호출
					fnAuthList();
					
					fnNewAuth();
					
					alert("<%=BizboxAMessage.getMessage("TX000015961","권한이 저장되었습니다.")%>");
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000002596","저장에 실패하였습니다")%>");
				}
				
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}	
	
	// 권한 수정
	function fnAuthEdit() {
		var params = {};
		var authCode = $("#authList input:radio[name='authCheck']:checked").attr("id");
		var authName = $("#authNameInput").val() || "";
		var compArray = new Array();
		var erpOrgChartCheck = false;
		var menuArray = new Array();
		var erpCompCode = {};
		var erpBizCode = {};
		var erpInfoArray = new Array();
		
		// 필수체크 값 확인 (권한명)
		if(authName == "") {
			alert("<%=BizboxAMessage.getMessage("TX000015958","필수값이 저장되지 않았습니다. 다시 확인해주세요.")%>");
			return;
		}
		
		// erp 조직도 체크 확인
		$("input:checkbox[name='erpBiz']").each(function() {
			if ($(this).is(":checked") == true) {
				erpOrgChartCheck = true;	
			}
		});
		
		// 필수체크 값 확인 (erp 조직도)
		if(!erpOrgChartCheck){
			alert("<%=BizboxAMessage.getMessage("TX000015958","필수값이 저장되지 않았습니다. 다시 확인해주세요.")%>");
			return;
		}
		
		// TODO: 구분 값 줘야함(2차개발 시 )
		/*
		$(".authMenuList").each(function() {
			var id = $(this).attr("id");
			console.log(id);
			menuArray.push(id);
		});
		*/

		// TODO: 구분 값 줘야함(2차개발 시 )
		// 자금관리(전체메뉴) 선택 시 모든 하위 메뉴 코드를 넘겨줌
		if($('input:radio[name="mainMenuName"]:checked').val()=='all'){
			$(".authMenuList").each(function() {
				var id = $(this).attr("id");
				//console.log(id);
				menuArray.push(id);
			});
		}else{
			//채권연령분석 메뉴만 넘겨줌
			menuArray.push('006');
		}		
		
		// 그룹웨어 회사 
		$("input:checkbox[name='gwComp']").each(function(){
			if($(this).prop("checked") || $(this).prop("indeterminate")){
				var compInfo = {};
				var tempId = $(this).attr("id");
				var length = tempId.length;
				compInfo.compSeq = tempId.substring(2, length); 
				compArray.push(compInfo);
			} else {
				
			}
			
		});

		$("input:checkbox[name='erpBiz']").each(function() {
			var compSeq = '';
			var bizSeq = '';
			var compName = '';
			var bizName = '';
			var gwCompSeq = '';		// GW 회사시퀀스

			if ($(this).is(":checked") == true) {
				var erpInfo = {};
				compSeq = $(this).attr("compSeq");
				bizSeq = $(this).attr("id").split("|")[0];
				compName = $(this).attr("compName");
				bizName = $(this).attr("bizName");
				gwCompSeq = $(this).attr("gwComp");

				erpInfo.erpComp = compSeq;
				erpInfo.erpBiz = bizSeq;
				erpInfo.erpCompNm = compName;
				erpInfo.erpBizNm = bizName;
				erpInfo.gwCompSeq = gwCompSeq;

				erpInfoArray.push(erpInfo);
			}
		});

		var info = {};
		info.authName = $("#authNameInput").val();
		info.authEtc = $("#authEtcInput").val();
		info.authUseYN = $(".authUseYN:checked").val();;
		info.menuArray = menuArray;
		info.erpInfo = erpInfoArray;
		info.authCode = authCode;
		info.compArray = compArray;

		params.info = info;
		params.info = JSON.stringify(params.info);
		params.authCode = authCode;
		params.authName = authName;
		params.authEtc = $("#authEtcInput").val() || "";
		params.authUseYN = $(".authUseYN:checked").val();;
		
		
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthMenuDeptInfoUpdate.do" />',
			success : function(result) {
				if(result.result == "success") {
					alert("<%=BizboxAMessage.getMessage("TX000015959","권한을 수정하였습니다.")%>");	
					fnNewAuth();
					fnAuthList();
					window.close();
					window.opener.location.reload();
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000015960","수정에 실패했습니다.")%>");
				}
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}	


	// [이벤트] 삭제 버튼 동작
	function fnAuthDelete() {
		var params = {};
		var authCode = $("#authList input:radio[name='authCheck']:checked").attr("id");
		params.authCode = authCode;
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthMenuDeptInfoDelete.do" />',
			success : function(result) {
				if(result.result == "success") {
					authCodeRequest = "undefined";
					// 권한 호출
					fnAuthList();

					fnNewAuth();
					window.opener.location.reload();
					
					alert("<%=BizboxAMessage.getMessage("TX000015956","권한이 삭제되었습니다.")%>");
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000002106","삭제에 실패하였습니다.")%>");
				}
				
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// [이벤트] 회계단위 클릭 이벤트
	function fnErpBizCheckEvent(code, gwCompSeq) {
		var checked = 0;
		var unchecked = 0;
		var allCount = 0;
		

		$("." + code).each(function(){
			allCount++;
			if($(this).prop("checked")) {
				checked++;		
			} else {
				unchecked++;
			}
		});
		
		if(checked == 0) {
			if($("#" + code).attr("gwcomp") == gwCompSeq){
				$(this).prop("checked", false);	
			}
			
			var gwId = $("#" + code).attr("gwComp");
			
			$("#GW" + gwId).prop("checked", false);
		}
		
		if(unchecked>0) {
			if($("#" + code).attr("gwcomp") == gwCompSeq){
				$("#" + code).prop("indeterminate", true);
			}
			
			var gwId = $("#" + code).attr("gwComp");
			
			$("#GW" + gwId).prop("indeterminate", true);
			
		}
		
		
		if($("." + code + ":checked").length == allCount) {
			if($("#" + code).attr("gwcomp") == gwCompSeq){
				$("#" + code).prop("indeterminate", false);
				$("#" + code).prop("checked", true);
			}
			
			var gwId = $("#" + code).attr("gwComp");
			
			$("#GW" + gwId).prop("indeterminate", false);
			$("#GW" + gwId).prop("checked", true);
		}
		
		if($("." + code + ":checked").length == 0) {
			if($("#" + code).attr("gwcomp") == gwCompSeq){
				$("#" + code).prop("indeterminate", false);
				$("#" + code).prop("checked", false);
			}
			
			var gwId = $("#" + code).attr("gwComp");
			
			$("#GW" + gwId).prop("indeterminate", false);
		}
	}

	// [이벤트] erp 조직도 회사 체크 이벤트
	function fnErpCompCheckEvent(code) {
		var checked = 0;
		var unchecked = 0;
		
		$(".C" + code ).each(function(){
			if($(this).prop("checked")) {
				checked++;
			} else {
				unchecked++;
			}
		});
		
		if(checked == 0) {
			$("#C"+ code).prop("checked", false);
		}
		
		if(unchecked>0) {
			$("#C"+ code).prop("indeterminate", true);
		}
	}	

	// [이벤트] 신규 버튼 동작
	function fnNewAuth() {
		newAuthFlag = true;
		$("#authNameInput").val("");
		$("#authEtcInput").val("");
		$("#authUseY").prop("checked", true);
		$("input:radio[name='authCheck']").attr("checked", false);
		$("input:checkbox[name='erpBiz']").attr("checked", false);
		$("input:checkbox[name='erpComp']").attr("checked", false);
		$("input:checkbox[name='gwComp']").attr("checked", false);
		
		$("input:checkbox[name='erpComp']").attr("indeterminate", false);
		$("input:checkbox[name='gwComp']").attr("indeterminate", false);
		
		// 노출메뉴 전체 선택 디폴트
		$("input:radio[name='mainMenuName']:radio[id='all']").prop('checked', true);
	}

	// [이벤트] 확인 버튼 동작
	function fnCheck() {
		window.close();
		
	}

	// [이벤트] 취소 버튼 동작
	function fnCancel() {
		window.close();
		//window.opener.location.reload();		
	}


	// 팝업 크기 조절
	function fnSetResize() {
		$(".location_info").css("display", "none");
		$(".iframe_wrap").css("padding", "0");

		var strWidth = $('.pop_wrap').outerWidth()
				+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);

		$('.pop_wrap').css("overflow", "auto");
		//$('.jstreeSet').css("overflow","auto");

		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;

		if (isFirefox) {

		}
		if (isIE) {
			$(".pop_foot").css("width", strWidth);
		}
		if (isEdge) {

		}
		if (isChrome) {
		}

		try {
			window.resizeTo(strWidth, strHeight);
		} catch (exception) {
			console.log('window resizing cat not run dev mode.');
		}
	}
</script>




<div class="pop_wrap" style="width: 898px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000015962","권한편집")%></h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	<div class="pop_con">

		<div class="ovh">
			<p class="tit_p fl mt7"><%=BizboxAMessage.getMessage("TX000015963","권한목록")%></p>
			<div class="controll_btn fr p0">
				<button id="newAuthBtn"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
				<button id="authSaveBtn"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
				<button id="authDeleteBtn"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>

		<div class="twinbox cl">
			<table style="min-height: 366px;">
				<colgroup>
					<col width="30%" />
					<col />
				</colgroup>
				<tr>
					<td class="twinbox_td">
						<div class="com_ta2">
							<table>
								<colgroup>
									<col width="34" />
									<col />
								</colgroup>
								<tr>
									<th></th>
									<th><%=BizboxAMessage.getMessage("TX000000136","권한명")%></th>
								</tr>
							</table>
						</div>
						<div class="com_ta2 ova_sc cursor_p bg_lightgray"
							style="height: 296px">
							<table>
								<colgroup>
									<col width="34" />
									<col />
								</colgroup>
								<tbody id="authList">
<!-- 									<tr>
										<td><input type="radio" name="inp_radi" id="inp_radi1"
											class="k-radio" checked="checked" /> <label
											class="k-radio-label radioSel" for="inp_radi1"></label></td>
										<td class="le"></td>
									</tr> -->
								</tbody>
							</table>
						</div>
					</td>
					<td class="twinbox_td">

						<div class="com_ta">
							<table>
								<colgroup>
									<col width="100" />
									<col width="220" />
									<col width="100" />
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000136","권한명")%></th>
									<td><input type="text" style="width: 98%"
										id="authNameInput" /></td>
									<th><%=BizboxAMessage.getMessage("TX000000274","사용유무")%></th>
									<td><input type="radio" name="inp_radi" id="authUseY"
										class="k-radio authUseYN" checked="checked" value="Y" /> <label
										class="k-radio-label radioSel" for="authUseYN"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label> <input
										type="radio" name="inp_radi" id="authUseN"
										class="k-radio authUseYN" value="N" /> <label
										class="k-radio-label radioSel" for="authUseN"
										style="margin: 0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label></td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
									<td colspan="3"><input type="text" style="width: 98%"
										id="authEtcInput" /></td>
								</tr>
							</table>
						</div>

						<div class="gr_ta mt10">
							<table>
								<colgroup>
									<col width="50%" />
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000015964","노출메뉴 선택")%></th>
									<th><%=BizboxAMessage.getMessage("TX000015965","권한회사 / 회계단위 선택")%></th>
								</tr>
								<tr>
									<td>
										<div class="chk_div_sc" style="height: 210px;">
											<ul>
												<li>
													<p>
														<!-- 
														<input type="checkbox" id="lhk1" checked="checked" /><label for="lhk1"
															id="mainMenuName"></label>
														 -->	
														<input type="radio" name="mainMenuName" id="all" class="k-radio" value="all" checked="checked"/> 
														<label class="k-radio-label radioSel" for="all">자금관리(전체메뉴)</label>
														</p>
														<p>
														<input type="radio" name="mainMenuName" id="006" class="k-radio" value="006" /> 
														<label class="k-radio-label radioSel ml10" for="006">채권연령분석</label>																
															
													</p>
													<div style="display: none">
													<ul id="menuAuthList">
														<!-- <li><p>
																<input type="checkbox" id="lhk2" /><label for="lhk2">자금일보</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label>
															</p></li> -->
													</ul>
													</div>
												</li>
											</ul>
										</div>
									</td>
									<td>
										<div class="chk_div_sc" style="height: 210px;">
											<ul id="GWErpInfoList">
												<!-- <li>
													<p>
														<input type="checkbox" id="lhk1" /><label for="lhk1">더존IT그룹</label>
													</p>
													<ul>
														<li><p>
																<input type="checkbox" id="lhk2" /><label for="lhk2">회사회사</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">회사회사2</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">회사회사4</label>
															</p></li>
													</ul>
												</li>
												<li>
													<p>
														<input type="checkbox" id="lhk1" /><label for="lhk1">더존IT그룹</label>
													</p>
													<ul>
														<li><p>
																<input type="checkbox" id="lhk1" /><label for="lhk1">더존IT그룹</label>
															</p>
															<ul>
																<li><p>
																		<input type="checkbox" id="lhk2" /><label for="lhk2">회사회사</label>
																	</p></li>
																<li><p>
																		<input type="checkbox" id="lhk3" /><label for="lhk3">회사회사5</label>
																	</p></li>
																<li><p>
																		<input type="checkbox" id="lhk3" /><label for="lhk3">회사회사67</label>
																	</p></li>
															</ul></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">회사회사8</label>
															</p></li>
														<li><p>
																<input type="checkbox" id="lhk3" /><label for="lhk3">회사회사7</label>
															</p></li>
													</ul>
												</li> -->
											</ul>
										</div>
									</td>
								</tr>
							</table>
						</div>

					</td>
				</tr>
			</table>
		</div>


	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="checkBtn" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" /> <input
				type="button" class="gray_btn" id="cancelBtn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>
	<!--	//pop_foot -->
</div>
<!-- //pop_wrap -->
