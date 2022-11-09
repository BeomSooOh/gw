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

<script type="text/javascript">
	/* [Map] declare javascipt hashmap prototype
	========================================*/
	Map = function() {
		this.map = new Object();
	};
	Map.prototype = {
		put : function(key, value) {
			this.map[key] = value;
		},
		get : function(key) {
			return this.map[key];
		},
		containsKey : function(key) {
			return key in this.map;
		},
		containsValue : function(value) {
			for ( var prop in this.map) {
				if (this.map[prop] == value)
					return true;
			}
			return false;
		},
		isEmpty : function(key) {
			return (this.size() == 0);
		},
		clear : function() {
			for ( var prop in this.map) {
				delete this.map[prop];
			}
		},
		remove : function(key) {
			delete this.map[key];
		},
		keys : function() {
			var keys = new Array();
			for ( var prop in this.map) {
				keys.push(prop);
			}
			return keys;
		},
		values : function() {
			var values = new Array();
			for ( var prop in this.map) {
				values.push(this.map[prop]);
			}
			return values;
		},
		size : function() {
			var count = 0;
			for ( var prop in this.map) {
				count++;
			}
			return count;
		}
	};
</script>

<script type="text/javascript">
	// 조직도 호출 변수
	var langCode = '${langCode}';
	var groupSeq = '${groupSeq}';
	var compSeq = '${compSeq}';
	var deptSeq = '${deptSeq}';
	var empSeq = '${empSeq}';
	var userSe = '${userSe}';
	var mappingCheck = '';			// 맵핑된 권한

	var filterdData = new Map();
	$(document).ready(function() {
		// 기본 이벤트
		fnInit();

		// 버튼 기본 동작
		fnButtonInit();
		
		// [조직도] 조직도 호출
		fnOrgChart();

		// [권한목록] 권한 호출
		fnAuthList();

		// 노출 메뉴 호출
		fnMenuList();

		// 권한회사/회계단위 호출(erp데이터)
		fnGWErpInfoList();
	});

	// 기본 이벤트
	function fnInit() {
		// 회사 셀렉트박스
		fnCompSelectBox()
		
		// orgChart 조직도 크기조절
		OJT_fnSetTreeWidth("290");
		OJT_fnSetTreeHeight("425");
	}
	
	// [조직도] 회사 selectbox
	function fnCompSelectBox() {
		var staProjectSelData = ${compListJson};
		var coCombobox = $("#orgChartSelectBox").kendoComboBox({
	    	dataTextField: "compName",
            dataValueField: "compSeq",
	        dataSource :staProjectSelData
	    }).data("kendoComboBox");
	    
	    var coCombobox = $("#orgChartSelectBox").data("kendoComboBox");
	    if(userSe == "MASTER") {
	    	coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });	
	    }
	    
	    coCombobox.refresh();
	    coCombobox.select(0);
	}
	
	// 버튼 기본 동작
	function fnButtonInit() {
		// 조직도 검색 버튼
		$("#orgChartSearch").keydown(function(e) { 
			if (e.keyCode == 13) {
				fnSearchOrg();
			}
		});

		// 조직도 검색 클릭
		$("#orgChartSearchBtn").click(function() { 
			fnSearchOrg();
		});

		// 권한 목록 검색 버튼
		$("#authSearch").keydown(function(e) { 
			if (e.keyCode == 13) {
				fnAuthList()
			}
		});

		// 권한 목록 검색 클릭
		$("#authSearchBtn").click(function() { 
			fnAuthList()
		});

		// 권한적용 버튼
		$("#authSaveBtn").click(function() {
			fnAuthEmpSave();
		});

		$("#showUser").click(function(e){
			fnAuthUserShow(e);
		});
		
		// 권한편집 버튼
		$("#authEditBtn").click(function() {
			var authCode = $("#authList input:radio[name='authCheck']:checked").attr("id");
			var url = "AccPopEditAuthView.do";
			var urlPath = url + "?authCode=" + authCode;
			var pop = window.open(urlPath, "AccPopEditAuth", "width=995, height=540");
		});

		// 권한 체크 이벤트
		$("#authList").on('click', 'input:radio[name=authCheck]', function() {
			var authCode = $(this).attr("id");	
			
			fnAuthMappingMenu(authCode);
		});

		// 조직도 체크 이벤트
		$("#orgChartList").on('click', 'input:checkbox[name=orgCheck]', function() {
			fnOrgCheckEvent(this);
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
			}else {
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
			$("input:radio[name='authCheck']").attr("checked", false);
			
			fnErpBizCheckEvent($(this).attr("class"), $(this).attr("gwcomp"));
		});
	}	
		
	// [조직도] 최초 조직도 호출
	function fnOrgChart() {
		var paramSet = {};
		paramSet.groupSeq = groupSeq;
		paramSet.empSeq = empSeq || '';
		paramSet.deptSeq = deptSeq || '';
		paramSet.compSeq = compSeq || '';

		paramSet.selectMode = 'd';
		paramSet.selectItem = 's';

		paramSet.nodeChageEvent = 'fnNodeSelect';

		paramSet.langCode = langCode || '';
		paramSet.initMode = '';
		
		if(userSe == "ADMIN") {
			paramSet.compFilter = compSeq;
		}
		
		/** 정의 : /orgchart/include/orgJsTree.jsp  **/
		OJT_documentReady(paramSet);
	}

	// [조직도] 선택 부서
	function fnNodeSelect(data) {
		callbackOrgChart(data);
	}

	// [조직도] 선택 부서 사용자+권한 데이터 가져오기
	function callbackOrgChart(data) {
		var params = {};
		
		params.groupSeq = data.groupSeq;
		params.selectedId = data.selectedId;

		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthEmpListInfoSelect.do" />',
			success : function(result) {
				fnOrgChartDraw(result.orgChart);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});

	}	
	
	// [조직도] 선택 부서 사용자+권한 데이터 그려주기
	function fnOrgChartDraw(data) {
		var tag = '';
		var length = data.length;

		for (var i = 0; i < length; i++) {
			tag += '<li>';
			tag += '<input type="checkbox" authCode="' + data[i].authCode + '" name="orgCheck" id="' + data[i].empSeq + '" value="' + data[i].superKey + '" /> ';
			tag += '<label for="' + data[i].empSeq + '">';
			tag += '<span class="na">[' + data[i].deptName + ' / '
					+ data[i].positionName + '] ' + data[i].empName + ' ';
			if (data[i].authCodeName == "") {
				tag += '<span class="condi">' + data[i].authCodeName
						+ '</span>';
			} else {
				tag += '<span class="condi"> ( ' + data[i].authCodeName
						+ ' )</span>';
			}

			tag += '</span>';
			tag += '</label>';
			tag += '</li>';
		}

		$("#orgChartList").html(tag);
	}	
	
	// [권한목록] 권한목록 데이터 가져오기
	function fnAuthList() {
		var param = {};
		param.authName = $("#authSearch").val() || "";
		param.erpSeq = $("#authSelectBox").val() || "";

		$.ajax({
			type : "POST",
			data : param,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthListInfoSelect.do" />',
			success : function(result) {
				fnAuthListDraw(result.authList);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}	
	
	// [권한목록] 권한 그려주기
	function fnAuthListDraw(data) {
		var tag = '';
		var length = data.length;

		for (var i = 0; i < length; i++) {
			var compName = '';
			var useYn = data[i].use_yn;
			var authCodeName = data[i].auth_code_nm;
			var empCnt = data[i].emp_cnt;
			var authcode = data[i].auth_code;
			
			if(data[i].comp_cnt == "0") {
				compName = data[i].erp_co_cd_name;
			} else {
				compName = data[i].erp_co_cd_name + ' 외 ' + data[i].comp_cnt;
			}
			
			
			if(data[i].order_num == "1") {
				tag += '<tr>';
				tag += '<td>-</td>';
				tag += '<td class="le"><%=BizboxAMessage.getMessage("TX000017353","사용자 지정권한")%></td>';
				tag += '<td></td>';
				tag += '<td>사용</td>';
				tag += '<td>';
				tag += '<div class="acc_cen_div">';
				tag += '<div class="controll_btn p0 fl">';
				tag += '<button onclick="fnAuthUserShow(\'userAuth\', \'<%=BizboxAMessage.getMessage("TX000017353","사용자 지정권한")%>\', \'' + empCnt + '\')"><%=BizboxAMessage.getMessage("TX000015967","사용자보기")%></button>';
				tag += '</div>';
				tag += '<span class="acc_txt">' + empCnt + '<%=BizboxAMessage.getMessage("TX000000878","명")%></span>';
				tag += '</div>';
				tag += '</td>';
				tag += '</tr>';
			} else {
				tag += '<tr>';
				tag += '<td>';
				tag += '<input type="radio" name="authCheck" id="' + authcode + '" class="k-radio authCheck"/> ';
				tag += '<label class="k-radio-label radioSel" for="' + authcode + '"></label>';
				tag += '</td>';
				tag += '<td class="le">' + authCodeName + '</td>';
				tag += '<td>' + compName + '</td>';
				tag += '<td>' + useYn + '</td>';
				tag += '<td>';
				tag += '<div class="acc_cen_div">';
				tag += '<div class="controll_btn p0 fl">';
				tag += '<button onclick="fnAuthUserShow(\'' + authcode + '\', \'' + authCodeName + '\', \'' + empCnt + '\', \'' + compName + '\')"><%=BizboxAMessage.getMessage("TX000015967","사용자보기")%></button>';

				tag += '</div>';
				tag += '<span class="acc_txt">' + empCnt + '<%=BizboxAMessage.getMessage("TX000000878","명")%></span>';
				tag += '</div>';
				tag += '</td>';
				tag += '</tr>';
			}
			
		}

		$("#authList").html(tag);
	}	
	
	// [권한상세 - 노출메누선택] 노출 메뉴 데이터 가져오기
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
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
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
				tag += '<label class="text_gray" for="' + data[i].detail_code + '">'
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
				fnGWErpSelectBox(result.selectBoxList);
				//fnGWErpSelectBox(result.GWErpInfoList);
				
				fnGWErpInfoListDraw(result.GWCompInfo, result.GWErpInfoList);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}	
	
	// [권한목록] 권한회사 selectbox
	function fnGWErpSelectBox(data) {
		var erpData = new Array();
		var length = data.length;
		
		for(var i=0; i<length; i++) {
			var erpInfo = {};
// 			if(data[i].GBN == "C") {
				
// 			}
			erpInfo.erpCompName = data[i].selectName;
			erpInfo.erpCompSeq = data[i].compSeq;
			
			erpData.push(erpInfo);
		}
		
		var erpCombobox = $("#authSelectBox").kendoComboBox({
	    	dataTextField: "erpCompName",
            dataValueField: "erpCompSeq",
	        dataSource :erpData
	    }).data("kendoComboBox");
	    
	    var erpCombobox = $("#authSelectBox").data("kendoComboBox");
	    if(userSe == "MASTER") {
	    	erpCombobox.dataSource.insert(0, { erpCompName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", erpCompSeq: "" });	
	    }
	    
	    erpCombobox.refresh();
	    erpCombobox.select(0);
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
			tag += '<label for="GW' + GWData[i].comp_seq + '">' + GWData[i].comp_name + '(GW)</label>';
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
				tag += '<label for="C' + ERPData[j].CODE + '_' + ERPData[j].gwCompSeq + '">' + ERPData[j].NAME + '(ERP)</label>';
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
				mappingCheck = result.authMappingData;
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
				
				
				$("input:checkbox[name='erpBiz']").each(function() {
					for (var i = 0; i < length; i++) {
						erp_co_cd = mappingCheck[i].erp_co_cd;
						erp_biz_cd = mappingCheck[i].erp_biz_cd;
						var key = erp_biz_cd + "|" + erp_co_cd;
						var gwCompSeq = mappingCheck[i].comp_seq;
						
						if($(this).attr("id") == key && $(this).attr("gwComp") == gwCompSeq) {
							$(this).prop("checked", true);
							fnErpBizCheckEvent($(this).attr("class"), gwCompSeq);
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
	
	// [권한부여] 사용자 권한 등록
	function fnAuthEmpSave() {
		var params = {};
		var authCode = $("input:radio[name='authCheck']:checked").attr("id") || "";
		var erpOrgChartCheck = false;
		var orgChartCheck = false;
		
		// erp 조직도 체크 확인
		$("input:checkbox[name='erpBiz']").each(function() {
			if ($(this).is(":checked") == true) {
				erpOrgChartCheck = true;	
			}
		});
		
		// 조직도 체크 확인
		$("input:checkbox[name='orgCheck']").each(function() {
			if ($(this).is(":checked") == true) {
				orgChartCheck = true;	
			}
		});
		
		// 필수체크 값 확인 (erp 조직도)
		if(!erpOrgChartCheck){
			alert("<%=BizboxAMessage.getMessage("TX000015958","필수값이 저장되지 않았습니다. 다시 확인해주세요.")%>");
			return;
		}
		
		// 필수체크 값 확인 (조직도 사용자 선택)
		if(!orgChartCheck){
			alert("<%=BizboxAMessage.getMessage("TX000015958","필수값이 저장되지 않았습니다. 다시 확인해주세요.")%>");
			return;
		}
		
		if(authCode == "") {
			// 사용자 권한
			fnUserAuthReg();	
		} else {
			// 기존 권한
			fnAuthEmpReg(authCode);
		}
	}
	
	// [권한부여] 기존권한 사용자 등록
	function fnAuthEmpReg(authCode) {
		var params = {};
		var userInfoArray = new Array();
		var info = {};
		
		$("#orgChartList input:checkbox[name=orgCheck]").each(function(){
			var userInfo = {};
			if($(this).prop("checked")){
				userInfo.baseAuthCode = $(this).attr("authCode");
				userInfo.authComp = $(this).val().split("|")[1];
				userInfo.authDept = $(this).val().split("|")[2];
				userInfo.authEmp = $(this).val().split("|")[3];
				
				userInfoArray.push(userInfo);
			}
			
		});
		
		info.changeAuth = authCode;
		info.userArray = userInfoArray;
		

		params.info = info;
		params.info = JSON.stringify(info);
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthEmpInfoInsert.do" />',
			success : function(result) {
				if(result.result == "success") {
					alert("<%=BizboxAMessage.getMessage("TX000015971","권한을 부여했습니다.")%>");
					window.location.reload();
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000015972","권한 부여에 실패했습니다.")%>");
				}
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}	
	
	// [권한부여] 사용자 지정 권한 (권한생성)
	function fnUserAuthReg() {
		var params = {};
		var userInfoArray = new Array();
		var menuArray = new Array();
		var erpCompCode = {};
		var erpBizCode = {};
		var erpInfoArray = new Array();
		var compArray = new Array();
		
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

		
		
		$("input:checkbox[name='erpBiz']").each(function() {
			var compSeq = '';
			var bizSeq = '';
			var compName = '';
			var bizName = '';
			var gwCompSeq = '';
			
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

		
		$("#orgChartList input:checkbox[name=orgCheck]").each(function(){
			var userInfo = {};
			if($(this).prop("checked")){
				userInfo.baseAuthCode = $(this).attr("authCode");
				userInfo.authComp = $(this).val().split("|")[1];
				userInfo.authDept = $(this).val().split("|")[2];
				userInfo.authEmp = $(this).val().split("|")[3];
				
				userInfoArray.push(userInfo);
			}
			
		});
		
		$("input[name=gwComp]").each(function(){
			if($(this).prop("checked") || $(this).prop("indeterminate")){
				var compInfo = {};
				var tempId = $(this).attr("id");
				var length = tempId.length;
				compInfo.compSeq = tempId.substring(2, length); 
				//alert($(this).attr("id").substring(2, length));
				compArray.push(compInfo);
			} else {
				
			}
			
		});

		var info = {};
		info.userInfoArray = userInfoArray;
		info.menuArray = menuArray;
		info.erpInfoArray = erpInfoArray;
		info.compArray = compArray;
		info.userAuth = "userAuth";

		params.info = info;
		params.info = JSON.stringify(params.info);
		//params.info = params.info;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AuthUserInsert.do" />',
			success : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000015971","권한을 부여했습니다.")%>");
				window.location.reload();
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

	
	// [이벤트] 조직도 체크 박스 이벤트
	// 노출메뉴 선택 여부가 들어가야 함
	function fnOrgCheckEvent(data) {
 		var authFlag = false;
		var authCode = '';
 		var count = 0;
 		var newAuthCode = '';
 		
 		if($(data).prop("checked")) {
 			authCode = $(data).attr("authCode");
 		}
 		
		$("#orgChartList input:checkbox[name=orgCheck]").each(function(){
			if($(this).prop("checked")) {
				newAuthCode = $(this).attr("authCode");
				count++;
				
				if(authCode != $(this).attr("authCode")) {
					authFlag = true;
				}
			}
			
		});
		
		if(count == 0) {
			$("input:radio[name='authCheck']").attr("checked", false);
			$("#GWErpInfoList input:checkbox[name='erpComp']").attr("indeterminate", false);
			$("#GWErpInfoList input:checkbox[name='erpComp']").attr("checked", false);
			$("#GWErpInfoList input:checkbox[name='erpBiz']").attr("checked", false);
		}

		if(count > 1) {
			if(authFlag) {
				$("input:radio[name='authCheck']").attr("checked", false);
				$("#GWErpInfoList input:checkbox[name='erpComp']").attr("indeterminate", false);
				$("#GWErpInfoList input:checkbox[name='erpComp']").attr("checked", false);
				$("#GWErpInfoList input:checkbox[name='erpBiz']").attr("checked", false);	
			} else {
				$("#" + authCode).prop("checked", true);
				fnAuthMappingMenu(authCode);
			}
			
		} else {
			$("#" + authCode).prop("checked", true);
			fnAuthMappingMenu(authCode);
		}

		if(count == 1 && newAuthCode != "") {
			$("#" + newAuthCode).prop("checked", true);
			fnAuthMappingMenu(newAuthCode);
		}
		
	}
	
	// [이벤트] 신규 버튼 동작
	function fnNewAuth() {
		$("input:radio[name='authCheck']").attr("checked", false);
		$("input:checkbox[name='erpBiz']").attr("checked", false);
		$("input:checkbox[name='erpComp']").attr("checked", false);
	}

	// [이벤트] 사용자 보기
	function fnAuthUserShow(authCode, authCodeName, empCnt, compName) {
		//alert(authCode + "/" + authCodeName + "/" + empCnt + "/" + compName);
		var url = "AccPopUserShowView.do";
		var urlPath = url + "?authCode=" + authCode + "&authName=" + encodeURI(encodeURI(authCodeName)) + "&empCnt=" + empCnt + "&compName=" + encodeURI(encodeURI(compName));
		
		var pop = window.open(urlPath, "AccPopUserShow", "width=395,height=340");
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
		

	
	// 사용자 보기 콜백 함수
	function fnCallBack(data, empSeq) {
		OJT_fnSearchNode(true, data);
//		fnUserSearchCheck(empSeq);
		$("#orgChartList input:checkbox[name=orgCheck]").each(function(){
			if(empSeq == $(this).attr("id")) {
				$("#" + empSeq).prop("checked", true);
				$("#" + empSeq).focus();
				//window.scrollTo(0, $("#" + empSeq).offset().top);
				fnOrgCheckEvent(this);
				
			}
		});
	}
	

	
	
	function fnSearchOrg() {
		var params = {};
		params.filter = $("#orgChartSearch").val();
		params.selectMode = "u";
		params.compFilter = $("#orgChartSelectBox").val();
		params.langCode = langCode;
		params.groupSeq = groupSeq;
		params.empSeq = empSeq;
		
		var key = "u" + '|' + $("#orgChartSearch").val();
		
		filterdData.containsKey(key)
			|| $.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/GetFilterdUserDeptProfileListForDept.do" />',
			success : function(result) {
				//console.log(JSON.stringify(result));
				
				if(result.returnObj.length == 0) {
					alert("검색결과가 없습니다.");
 					return;
				}
				
				// 검색 이력 체우기
				filterdData.put(key, {
					dataObj : result.returnObj,
					index : 0,
					length : result.returnObj.length
				});
					
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
		
		var returnObj = {};
		returnObj.isSuccess = true;
		returnObj.hasResult = false;
		returnObj.selectedId = null;
		returnObj.selectMode = null;
		returnObj.selectItem = null;
		returnObj.fullCount = 0;
		returnObj.resultCount = 0;
		
		if (filterdData.get(key).length) {
			// 검색 결과가 있는 경우.
			var searchedTemp = filterdData.get(key);
			var singleItem = searchedTemp.dataObj[searchedTemp.index
					% searchedTemp.length];

			returnObj.hasResult = true;
			returnObj.selectedId = singleItem.deptSeq;
			returnObj.selectMode = "u";
			returnObj.selectItem = "s";
			returnObj.fullCount = searchedTemp.length;
			returnObj.resultCount = ((searchedTemp.index) % searchedTemp.length + 1);
			searchedTemp.index++;
			
			// 사용자검색 포커스용 전역변수 지정
			if(searchedTemp.dataObj[returnObj.resultCount -1].empDeptFlag == "u"){
				focusSuperKey = searchedTemp.dataObj[returnObj.resultCount -1].superKey;	
			}else{
				focusSuperKey = "";
			}
			
			// 노드 처리 포인트 처리 - 이 페이지임.
			OJT_fnSearchNode(true, singleItem.deptPath, singleItem.bizUseYn, singleItem, "u");
			
			setTimeout("fnUserSearchCheck('" + singleItem.empSeq + "')", 100);
			fnUserSearchCheck();
		}
	}
	
	function fnUserSearchCheck(empSeq) {
		$("#orgChartList input:checkbox[name=orgCheck]").each(function(){
			if(empSeq == $(this).attr("id")) {
				$("#" + empSeq).prop("checked", true);
				window.scrollTo(0, $("#" + empSeq).offset().top);
				fnOrgCheckEvent(this);
			}
		});
	}
	
</script>


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">

	<div class="twinbox">
		<table style="">
			<colgroup>
				<col width="322" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<p class="tit_p mt7"><%=BizboxAMessage.getMessage("TX000005190","사용자선택")%></p>

					<div class="box_left" style="width: 290px;">


						<p class="record_tabSearch">
							<input id="orgChartSelectBox" style="width: 125px;" /> <input
								class="k-textbox input_search" id="orgChartSearch" type="text"
								value="" style="width: 100px;" placeholder=""> <a
								href="#" class="btn_search" id="orgChartSearchBtn"></a>
						</p>

						<!-- 조직도-->
						<style>
						.jstreeSet .box_left {border:none;}	
						</style>
						<div class="jstreeSet" style="overflow-y:hidden;border:none;">
							<jsp:include
								page="../../neos/cmm/systemx/orgchart/include/orgJsTree.jsp"
								flush="false" />
						</div>

						<div class="acc_bottom">
							<ul id="orgChartList">
								<!-- <li><input type="checkbox" id="chk1" /> <label for="chk1"><span
										class="na">[대통령 / 실세] 최순실 <span class="condi">(외주협력)</span></span></label></li>
								<li><input type="checkbox" id="chk2" /><label for="chk2"><span
										class="na">[기획설계 / 대리 ] 정유라 <span class="condi">(외주협력)</span></span></label></li>
								<li class="on"><input type="checkbox" id="chk3" /><label
									for="chk3"><span class="na">[대통령 / 바지] 박근혜 <span
											class="condi">(외주협력)</span></span></label></li>
								<li><input type="checkbox" id="chk4" /><label for="chk4"><span
										class="na">[개발 / 주임연구원] 고영태 <span class="condi">(외주협력)</span></span></label></li> -->
							</ul>

						</div>

					</div> <!-- //box_left -->
				</td>
				<td class="twinbox_td" style="min-width: 850px;">
					<p class="tit_p fl mt7"><%=BizboxAMessage.getMessage("TX000015963","권한목록")%></p>
					<div class="controll_btn fr p0">
						<button id="authSaveBtn"><%=BizboxAMessage.getMessage("TX000015973","권한적용")%></button>
						<button id="authEditBtn"><%=BizboxAMessage.getMessage("TX000015962","권한편집")%></button>
					</div>

					<div class="top_box">
						<dl>
							<dt><%=BizboxAMessage.getMessage("TX000015969","권한회사")%></dt>
							<dd>
								<input type="text" id="authSelectBox" class="kendoComboBox"
									style="width: 200px;" />
							</dd>
							<dt><%=BizboxAMessage.getMessage("TX000000136","권한명")%></dt>
							<dd>
								<input type="text" class="" id="authSearch"
									style="width: 200px;" />
							</dd>
							<dd>
								<input type="button" id="authSearchBtn" value="검색" />
							</dd>
						</dl>
					</div>

					<div class="com_ta2 mt10" style="">
						<table>
							<colgroup>
								<col width="34" />
								<col width="220" />
								<col width="220" />
								<col width="220" />
								<col width="" />
							</colgroup>
							<tr>
								<th></th>
								<th><%=BizboxAMessage.getMessage("TX000000136","권한명")%></th>
								<th><%=BizboxAMessage.getMessage("TX000015974","권한회사(자금관리)")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<th><%=BizboxAMessage.getMessage("TX000015967","사용자보기")%></th>
							</tr>
						</table>
					</div>


					<div class="com_ta2 ova_sc cursor_p bg_lightgray"
						style="height: 255px">
						<table>
							<colgroup>
								<col width="34" />
								<col width="220" />
								<col width="220" />
								<col width="220" />
								<col width="" />
							</colgroup>
							<tbody id="authList">
								<!-- 							<tr> -->
								<!-- 								<td><input type="radio" name="inp_radi" id="inp_radi1" -->
								<!-- 									class="k-radio" checked="checked" /> <label -->
								<!-- 									class="k-radio-label radioSel" for="inp_radi1"></label></td> -->
								<!-- 								<td class="le">일반사용자</td> -->
								<!-- 								<td>더존비즈온 외1</td> -->
								<!-- 								<td>미사용</td> -->
								<!-- 								<td> -->
								<!-- 									<div class="acc_cen_div"> -->
								<!-- 										<div class="controll_btn p0 fl"> -->
								<!-- 											<button>사용자 보기</button> -->
								<!-- 										</div> -->
								<!-- 										<span class="acc_txt">45명</span> -->
								<!-- 									</div> -->
								<!-- 								</td> -->
								<!-- 							</tr> -->
							</tbody>

						</table>
					</div>


					<p class="tit_p mt20">
						<%=BizboxAMessage.getMessage("TX000015975","권한상세")%> <span class="text_red fwn">(<%=BizboxAMessage.getMessage("TX000015976","필수체크값")%>)</span>
					</p>
					<div class="gr_ta">
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
													<input type="checkbox" id="allCheck" checked /><label
														for="lhk1" id="mainMenuName"></label>
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
													<!-- 													<li><p> -->
													<!-- 															<input type="checkbox" id="lhk2" /><label for="lhk2">자금일보</label> -->
													<!-- 														</p></li> -->
													<!-- 													<li><p> -->
													<!-- 															<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label> -->
													<!-- 														</p></li> -->
													<!-- 													<li><p> -->
													<!-- 															<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label> -->
													<!-- 														</p></li> -->
													<!-- 													<li><p> -->
													<!-- 															<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label> -->
													<!-- 														</p></li> -->
													<!-- 													<li><p> -->
													<!-- 															<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label> -->
													<!-- 														</p></li> -->
													<!-- 													<li><p> -->
													<!-- 															<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label> -->
													<!-- 														</p></li> -->
													<!-- 													<li><p> -->
													<!-- 															<input type="checkbox" id="lhk3" /><label for="lhk3">총괄자금현황</label> -->
													<!-- 														</p></li> -->
												</ul>
												</div>
											</li>
										</ul>
									</div>
								</td>
								<td>
									<div class="chk_div_sc" style="height: 210px;">
										<ul id="GWErpInfoList">
											<!-- 										<p><input id="C3210" type="checkbox"><label for="C">에스엠디엔그룹(주)</label></p><ul><li><p><input id="D3210" type="checkbox"><label for="D">에스엠디엔그룹(주)</label></p></li><p></p></ul><ul><li><p><input id="D1000" type="checkbox"><label for="D">_태원산업본사</label></p></li><p></p></ul><ul><li><p><input id="D2000" type="checkbox"><label for="D">_대전지사(7598)</label></p></li><p></p></ul><ul><li><p><input id="D3000" type="checkbox"><label for="D">_부산지사(8473)</label></p></li><p></p></ul><ul><li><p><input id="D4000" type="checkbox"><label for="D">_광주지사</label></p></li><p></p></ul><ul><li><p><input id="D5000" type="checkbox"><label for="D">_대구지사</label></p></li><p></p></ul><ul><li><p><input id="D6000" type="checkbox"><label for="D">_울산지사</label></p></li><p></p></ul><ul><li><p><input id="D7000" type="checkbox"><label for="D">_전주지사</label></p></li><p></p></ul><ul><li><p><input id="D8000" type="checkbox"><label for="D">_강릉지사</label></p></li><p></p></ul><ul><li><p><input id="D9000" type="checkbox"><label for="D">_인천지사</label></p></li><p></p></ul><ul><li><p><input id="D9100" type="checkbox"><label for="D">_원주지사</label></p></li><p></p></ul><ul><li><p><input id="D9200" type="checkbox"><label for="D">_수원지사</label></p></li><p></p></ul><ul><li><p><input id="D9300" type="checkbox"><label for="D">_포항지사</label></p></li><p></p></ul><ul><li><p><input id="D9400" type="checkbox"><label for="D">_해외지사(8206)</label></p></li><p></p></ul><ul><li><p><input id="D9500" type="checkbox"><label for="D">_해외지사(9857)</label></p></li><p></p></ul> -->
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
<!-- //sub_contents_wrap -->
