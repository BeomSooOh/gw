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
	var formItemRangeComboBox = '';
	var formItemTypeComboBox = '';
	var formSystemGubunComboBox = '';
	var formDatetimeTypeComboBox = '';
	var textLinCountComboBox = '';
	var userDefineCodeTypeComboBox = '';
	var formSystemMultiComboBox = '';
	var formSystemDisplayComboBox = '';
	var formDatetimeDateTypeComboBox = '';
	var numberDecimalPointComboBox = '';

	var systemDefaultLoginUserData = ''; // NeosCodeUtil.getCodeList('It0004');
	var systemDefaultLoginDeptData = '';//NeosCodeUtil.getCodeList('It0005');

	var systemUserDisplayData = '';//NeosCodeUtil.getCodeList('It0007');
	var systemDeptDisplayData = '';// NeosCodeUtil.getCodeList('It0008');

	var glovalItemCode = '';
	var checkFlag = false;
	var isShowNotUseFlag = false;
	var duplicateFlag = false;
	var initFlag = true;

	$(document).ready(function() {
		// 초기값 셋팅
		fnInit();

		// 버튼 이벤트
		fnButtonEvent();

		// 항목 목록 데이터 가져오기
		fnGetItemList();

	});

	// 초기값 
	function fnInit() {
		// 항목범위
		var itemSelect = NeosCodeUtil.getCodeList('It0001');

		// Type
		var typeSelect = NeosCodeUtil.getCodeList('It0002');
		
		// 항목범위 ComboBox (검색창)
		$("#searchItemRange").kendoComboBox({
			dataSource : itemSelect,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  sel_gubun,
			index : 0
		});
		var searchItemRangeComboBox = $("#searchItemRange").data(
				"kendoComboBox");

		// 항목범위 ComboBox (정보창)
		$("#formItemRange").kendoComboBox({
			dataSource : itemSelect,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  sel_gubun,
			index : 0
		});
		formItemRangeComboBox = $("#formItemRange").data("kendoComboBox");

		// type ComboBox (정보창)
		$("#formItemType").kendoComboBox({
			dataSource : typeSelect,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			change : fnTypeSelectForm,
			index : 0
		});
		formItemTypeComboBox = $("#formItemType").data("kendoComboBox");

	}

	// 버튼 이벤트
	function fnButtonEvent() {
		// 검색 엔터 이벤트
		$("#itemSearchKey").keydown(function(e) {
			if (e.keyCode == 13) {
				e.returnValue = false;
				e.cancelBubble = true;
				fnGetItemList();
			}
		});

		// 검색 클릭 이벤트
		$("#searchButton").click(function() {
			fnGetItemList();
		});

		// 신규 클릭 이벤트
		$("#newButton").click(function() {
			fnFormInit();
		});

		// 저장 클릭 이벤트
		$("#saveButton").click(function() {
			fnItemSave();
		});

		// 삭제 클릭 이벤트
		$("#deleteButton").click(function() {
			fnItemDelete();
		});

		// 코드 유형 및 기본값 선택 팝업 호출 (선택 클릭 이벤트)
		$("#userDefineSelectButton").click(function() {
			fnPopCodeTypeSelect();
		});
		
		// 외부코드 선택 팝업 호출 (선택 클릭 이벤트)
		$("#externalSelectButton").click(function(){
			fnPopExternalTypeSelect();
		});

		// 체크 이벤트 확인
		$("#isShowNotUse").click(function() {
			if($(this).prop("checked")) {
				isShowNotUseFlag = true;
			} else {
				isShowNotUseFlag = false;
			}
			fnGetItemList();
		});
		
		$("#itemList").on("click", "tr", function(){
			onSelect(this);
		});

		//물음표 마우스 오버시 show/hide
		$('.btn_question_mark').on("mouseover", function() {
			$('.qm_pop').css("top", parseInt($(this).css("top"), 10) + 23);
			$('.qm_pop').show();
		});
		
		$('.btn_question_mark').on("mouseout", function() {
			$('.qm_pop').hide();
		});		
		
		$("#all_chk").click(function(){
			if($(this).is(":checked")) {
				$("input[name=checkItem]").prop("checked", true);
				
			} else {
				$("input[name=checkItem]").prop("checked", false);
			}
		});
	}

	// 코드 유형 및 기본값 선택 팝업 호출
	function fnPopCodeTypeSelect() {
		var url = "pop/ItemPopCodeTypeSelectView.do";
		var pop = window.open(url, "ItemPopCodeTypeSelectView",
				"width=800,height=340");

	}
	
	// 외부코드 선택 팝업 호출
	function fnPopExternalTypeSelect() {
		var url = "pop/ItemPopExternalTypeSelectView.do";
		var pop = window.open(url, "ItemPopExternalTypeSelectView",
				"width=700,height=603");
	}

	// 항목 목록 데이터 가져오기
	function fnGetItemList() {
		var params = {};
		params.search = $("#itemSearchKey").val();
		
		if(isShowNotUseFlag) {
			params.isShowNotUse = "Y";
		} else {
			params.isShowNotUse = "N";
		}

		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemListSelect.do" />',
			success : function(result) {
				fnGetItemListDraw(result.result);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000017328","조회하는데 오류가 발생하였습니다.")%>");
			}
		});
	}

	// 항목 목록 데이터 그려주기
	function fnGetItemListDraw(data) {
		var length = data.length;
		var tag = '';

		if (length == "0") {
			tag += '';
		} else {
			for (var i = 0; i < length; i++) {
				tag += '<tr id="' + data[i].itemCode
						+ '" >';
				tag += '<td onclick="event.cancelBubble=true;">';
				tag += '<input type="checkbox" name="checkItem" id="check_' + data[i].itemCode + '" class="k-checkbox itemCodeCheck">';
				tag += '<label class="k-checkbox-label radioSel" for="check_' + data[i].itemCode + '"></label>';
				tag += '</td>'
				tag += '<td>' + data[i].itemCode + '</td>';
				tag += '<td>' + data[i].itemCodeName + '</td>';
				tag += '<td>' + data[i].itemCodeRange + '</td>';
				tag += '<td>' + data[i].itemTypeName + '</td>';
				tag += '<td>' + data[i].itemUseYN + '</td>';
				tag += '</tr>';
			}

		}
		$("#itemList").html(tag);
	}

	// 항목 클릭 시 이벤트
	function onSelect(data) {
		initFlag = false;
		glovalItemCode = $(data).attr("id");
		
		$("#itemList tr").removeClass("on");
		
		$(data).addClass("on");
		
		fnGetItemCodeDetail(glovalItemCode);	
		
	}

	// 항목 클릭 시 세부정보 가져오기
	function fnGetItemCodeDetail(id) {
		var params = {};
		params.itemCode = id;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemCodeDetailSelect.do" />',
			success : function(result) {
				fnItemCodeDetailDraw(result.result);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000017328","조회하는데 오류가 발생하였습니다.")%>");
			}
		});
	}

	// 항목 클릭 시 세부사항 정보 그려주기
	function fnItemCodeDetailDraw(data) {
		$("#formItemCode").attr("disabled", "disabled");
		$("#formItemCode").val(data.itemCode);
		$("#formItemName").val(data.itemName);
		$("#formItemDesc").val(data.itemDesc);
		formItemRangeComboBox.value(data.itemRange);
		formItemTypeComboBox.value(data.itemType);
		
		fnTypeSelectForm();
		
		if(data.itemUseYN == "1") {
			$("#useY").prop("checked", true);
			$("#useN").prop("checked", false);
		} else {
			$("#useN").prop("checked", true);
			$("#useY").prop("checked", false);
		}
		
		if (data.itemType == "10") {
			formSystemGubunComboBox.value(data.systemGubun);
			formSystemMultiComboBox.value(data.systemMulti);
			formSystemDisplayComboBox.value(data.systemDisplay);
			fnSystemGubunSelect();
			$("#systemDefault").val(data.systemDefault);
		} else if (data.itemType == "20") {
			textLinCountComboBox.value(data.textLineCount);
			$("#textLength").val(data.numberMaxVal);
		} else if (data.itemType == "30") {
			$("#numberMaxVal").val(data.numberMaxVal);
			$("#numberMinVal").val(data.numberMinVal);
			numberDecimalPointComboBox.value(data.numberDecimalPoint);
		} else if (data.itemType == "40") {
			userDefineCodeTypeComboBox.value(data.userDefineCodeType);
			$("#userDefineCodeKind").val(data.userDefineGroupCodeNm);
			$("#userDefineCodeDefault").val(data.userDefineGroupCodeDefaultNm);
		} else if (data.itemType == "50") {
			$("#datetimeType").val(data.datetimeType);
			$("#datetimeDateType").val(data.datetimeDateType);
			$("#datetimeDefault1").val(data.datetimeDefault1);
			$("#datetimeDefault2").val(data.datetimeDefault2);			
			formDatetimeTypeComboBox.value(data.datetimeType);
			formDatetimeDateTypeComboBox.value(data.datetimeDateType);
			fnDateTimeChange();
		} else if (data.itemType == "60") {
			
		} else if (data.itemType == "70") {
			$("#externalCodeKind").val(data.externalCodeNm);
		}
	}

	// 신규 버튼 
	function fnFormInit() {
		initFlag = true;
		
		$("#formItemCode").attr("disabled", false);
		$("#formItemCode").val('');
		$("#formItemName").val('');
		$("#formItemDesc").val('');
		formItemRangeComboBox.select(0);
		formItemTypeComboBox.select(0);
		
		$(".typeForm").hide();

		$("#itemList tr").removeClass("on");
	}

	// 항목 저장 
	function fnItemSave() {
		var checkFlag = false;
		var gubun = '';

		if ($("#formItemCode").attr("disabled") == "disabled") {
			gubun = "edit";
		} else {
			gubun = "save";
		}

		// 기초데이터
		var itemCode = $("#formItemCode").val();
		var itemName = $("#formItemName").val();
		var itemDesc = $("#formItemDesc").val();
		var itemRange = $("#formItemRange").val();
		var itemType = $("#formItemType").val();
		var itemUseYN = $(".itemUseYN:checked").val();

		/* TYPE 별 데이터 */
		// SYSTEM
		var systemGubun = $("#systemGubun").val();
		var systemDefault = $("#systemDefault").val();
		var systemMulti = $("#systemMulti").val();
		var systemDisplay = $("#systemDisplay").val();

		// TEXT
		var textLineCount = $("#textLineCount").val();
		var textLength = $("#textLength").val();

		// NUMBER
		var numberMaxVal = $("#numberMaxVal").val();
		var numberMinVal = $("#numberMinVal").val();
		var numberDecimalPoint = $("#numberDecimalPoint").val();

		// DATETIME
		var datetimeType = $("#datetimeType").val();
		var datetimeDateType = $("#datetimeDateType").val();
		var datetimeDefault1 = $("#datetimeDefault1").val();
		var datetimeDefault2 = $("#datetimeDefault2").val();

		// UserDefine
		var userDefineCodeType = $("#userDefineCodeType").val();
		var userDefineCodeKind = $("#userDefineCodeKindHidden").val();
		var userDefineCodeDefault = $("#userDefineCodeDefaultHidden").val();
		
		// ExternalCode
		var externalCodeKind = $("#externalCodeKindHidden").val();

		var params = {};
		params.itemCode = itemCode;
		params.itemName = itemName;
		params.itemDesc = itemDesc;
		params.itemRange = itemRange;
		params.itemType = itemType;
		params.itemUseYN = itemUseYN;

		// 필수항목 체크
		checkFlag = fnCheckSave();

		if (checkFlag) {
			alert("<%=BizboxAMessage.getMessage("TX000010857","필수 값이 입력되지 않았습니다")%>");
			return;
		}
		
		if(duplicateFlag) {
			alert("<%=BizboxAMessage.getMessage("TX000010757","코드가 중복되었습니다")%>");
			return;
		}

		if (itemType == "10") {
			params.systemGubun = systemGubun;
			params.systemDefault = systemDefault;
			params.systemMulti = systemMulti;
			params.systemDisplay = systemDisplay;
		} else if (itemType == "20") {
			params.textLineCount = textLineCount;
			params.numberMaxVal = textLength;
		} else if (itemType == "30") {
			params.numberMaxVal = numberMaxVal;
			params.numberMinVal = numberMinVal;
			params.numberDecimalPoint = numberDecimalPoint;
			
			numberMaxVal = parseInt(numberMaxVal);
			numberMinVal = parseInt(numberMinVal);
			
			if(numberMaxVal > 10) {
				alert("<%=BizboxAMessage.getMessage("TX900000016","최대 10 이하로 입력해주세요")%>");
				return;
			}
			
			if(numberMinVal < 1) {
				alert("<%=BizboxAMessage.getMessage("TX900000017","최소 1 이상으로 입력해주세요")%>");
				return;
			}
			
			if(numberMaxVal < numberMinVal) {
				alert("<%=BizboxAMessage.getMessage("TX900000018","최소값이 최대값 보다 클 수 없습니다.")%>");
				return;
			}
		} else if (itemType == "40") {
			params.userDefineCodeType = userDefineCodeType;
			params.userDefineCodeKind = userDefineCodeKind;
			params.userDefineCodeDefault = userDefineCodeDefault;
		} else if (itemType == "50") {
			var d = new Date();
			var toYear = leadingZeros(d.getFullYear(), 4);
			var toMonth = leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2);
			var toDay = leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2);
			var toHour = leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2) + ' ' + leadingZeros(d.getHours(),2);
			var toMinute = leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2) + ' ' + leadingZeros(d.getHours(),2) + ':' + leadingZeros(d.getMinutes(),2);

			/* 기간일때  체크 처리 : 빈값일 경우 today 가져와서 확인 필요
			   - 시작일만 빈값일 경우 => 제한처리
			   - 종료일만 빈값일 경우 => 입력한 시작일이 today보다 미래일 경우 제한처리
			   - empty일 경우 상관없음 => 전자결재에서 처리할 문제
			*/
			if (datetimeType == '20') {
				var checkToday = datetimeDateType == '10' ? toYear :
									datetimeDateType == '20' ? toMonth :
										datetimeDateType == '30' ? toDay :
											datetimeDateType == '40' ? toHour : toMinute;
				
				if (datetimeDefault1 == 'empty' || datetimeDefault1 == 'EMPTY' || datetimeDefault2 == 'empty' || datetimeDefault2 == 'EMPTY') {
					params.datetimeType = datetimeType;
					params.datetimeDateType = datetimeDateType;
					params.datetimeDefault1 = datetimeDefault1;
					params.datetimeDefault2 = datetimeDefault2;
				}
				else if (datetimeDefault2 == '' && datetimeDefault1 > checkToday) {
					alert("<%=BizboxAMessage.getMessage("TX800002002","시작일을 종료일보다 크게 입력할 수 없습니다.")%>");
					document.getElementById("datetimeDefault1").focus();
					return
				}
				else if (datetimeDefault1 == '' && datetimeDefault2 != '') {
					alert("<%=BizboxAMessage.getMessage("TX800002003","종료일만 선택 시 시작일이 종료일보다 커질 수 있어 설정 불가합니다.")%>");
					document.getElementById("datetimeDefault1").focus();
					return
				}
				else if (datetimeDefault1 != '' && datetimeDefault2 != '' && datetimeDefault1 > datetimeDefault2) {
					alert("<%=BizboxAMessage.getMessage("TX800002002","시작일을 종료일보다 크게 입력할 수 없습니다.")%>");
					document.getElementById("datetimeDefault2").focus();
					return
				}
				else {
					params.datetimeType = datetimeType;
					params.datetimeDateType = datetimeDateType;
					params.datetimeDefault1 = datetimeDefault1;
					params.datetimeDefault2 = datetimeDefault2;
				}
			}
			else {
				params.datetimeType = datetimeType;
				params.datetimeDateType = datetimeDateType;
				params.datetimeDefault1 = datetimeDefault1;
				params.datetimeDefault2 = datetimeDefault2;
			}
		} else if (itemType == "60") {
			
		} else if (itemType == "70") {
			params.externalCodeKind = externalCodeKind;
		}
		
		if (gubun == "save") {
			$.ajax({
				type : "POST",
				data : params,
				async : false,
				url : '<c:url value="/cmm/systemx/item/ItemCodeInsert.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000015756","저장하였습니다.")%>");
					fnGetItemList();
					fnFormInit();
				},
				error : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
				}
			});
		} else if (gubun == "edit") {
			$.ajax({
				type : "POST",
				data : params,
				async : false,
				url : '<c:url value="/cmm/systemx/item/ItemCodeUpdate.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010628","수정하였습니다")%>");
					fnGetItemList();
					fnFormInit();
				},
				error : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
				}
			});
		}

	}

	// 필수항목 체크
	function fnCheckSave() {
		var itemCode = $("#formItemCode").val();
		var itemName = $("#formItemName").val();
		var itemType = $("#formItemType").val();

		if (itemCode == "") {
			$("#formItemCode").focus();
			return true;
		} else if (itemName == "") {
			$("#formItemName").focus();
			return true;
		} else if (itemType == "1") {
			return true;
		}
		
		if(itemType == "70") {
			var external = $("#externalCodeKind").val();
			
			if(external == "") {
				return true;
			}
		}
		return false;
	}

	// 항목 삭제
	function fnItemDelete() {
		var checkCount = 0;
		var params = {};
		var itemCodeArray = new Array();
		$("#itemList input:checkbox[name='checkItem']").each(function() {
			var itemParam = {};
			if($(this).prop("checked")){
				checkCount++;
				itemParam.itemCode = $(this).attr("id").replace("check_", "");
				itemCodeArray.push(itemParam);
			}
		});

		if(checkCount == 0) {
			alert("<%=BizboxAMessage.getMessage("TX000002319","삭제할 항목을 선택하세요.")%>");
			return;
		}
		
		if(!confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")) {
			return;
		}
		
		params.itemCodeArray = itemCodeArray;
		params.itemCodeArray = JSON.stringify(params);
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemCodeDelete.do" />',
			success : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000008214","삭제했습니다")%>");
				fnGetItemList();
				fnFormInit();
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});

	}

	// 타입별 유형
	function fnTypeSelectForm() {
		$(".typeForm").hide();
		var typeSelect = $("#formItemType").val();

		if (typeSelect == "10") {
			// SYSTEM
			$("#system").show();
			fnSettingSystem();
		} else if (typeSelect == "20") {
			// TEXT
			$("#text").show();
			fnSettingText();
		} else if (typeSelect == "30") {
			// NUMBER
			$("#number").show();
			fnSettingNumber();
		} else if (typeSelect == "40") {
			// 사용자정의
			$("#userDefine").show();
			fnSettingUserDefine();
		} else if (typeSelect == "50") {
			// DATETIME
			$("#datetime").show();
			fnSettingDatetime();
			
		} else if (typeSelect == "60") {
			// PROJECT
			$("#project").show();
		} else if(typeSelect == "70") {
			// External Code (외부시스템)
			$("#externalCode").show();
		}
	}

	// SYSTEM Setting
	function fnSettingSystem() {
		var systemGubunData = NeosCodeUtil.getCodeList('It0003');
		var systemMultiData = NeosCodeUtil.getCodeList('It0006');
		systemDefaultLoginUserData = NeosCodeUtil.getCodeList('It0004');
		systemDefaultLoginDeptData = NeosCodeUtil.getCodeList('It0005');

		systemUserDisplayData = NeosCodeUtil.getCodeList('It0007');
		systemDeptDisplayData = NeosCodeUtil.getCodeList('It0008');
		
		
		$("#systemGubun").kendoComboBox({
			dataSource : systemGubunData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			change : fnSystemGubunSelect,
			index : 0
		});
		formSystemGubunComboBox = $("#systemGubun").data("kendoComboBox");

		$("#systemMulti").kendoComboBox({
			dataSource : systemMultiData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  fnSystemGubunSelect,
			index : 0
		});
		formSystemMultiComboBox = $("#systemMulti").data("kendoComboBox");

		$("#systemDefault").kendoComboBox({
			dataSource : systemDefaultLoginUserData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  fnSystemGubunSelect,
			index : 0
		});

		$("#systemDisplay").kendoComboBox({
			dataSource : systemUserDisplayData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  fnSystemGubunSelect,
			index : 0
		});
		formSystemDisplayComboBox = $("#systemDisplay").data("kendoComboBox");
		
		if(initFlag) {
			formSystemGubunComboBox.select(0);
			formSystemMultiComboBox.select(0);
			formSystemDisplayComboBox.select(0);
		}
	}

	function fnSystemGubunSelect() {
		var selectGubun = $("#systemGubun").val();

		if (selectGubun == "10") {
			$("#systemDefault").kendoComboBox({
				dataSource : systemDefaultLoginUserData,
				dataTextField : "CODE_NM",
				dataValueField : "CODE",
				//change :  fnSystemGubunSelect,
				index : 0
			});

			$("#systemDisplay").kendoComboBox({
				dataSource : systemUserDisplayData,
				dataTextField : "CODE_NM",
				dataValueField : "CODE",
				//change :  fnSystemGubunSelect,
				index : 0
			});
		} else if (selectGubun == "20") {
			$("#systemDefault").kendoComboBox({
				dataSource : systemDefaultLoginDeptData,
				dataTextField : "CODE_NM",
				dataValueField : "CODE",
				//change :  fnSystemGubunSelect,
				index : 0
			});

			$("#systemDisplay").kendoComboBox({
				dataSource : systemDeptDisplayData,
				dataTextField : "CODE_NM",
				dataValueField : "CODE",
				//change :  fnSystemGubunSelect,
				index : 0
			});
		}
	}

	// TEXT Setting
	function fnSettingText() {
		var textLineCountData = NeosCodeUtil.getCodeList('It0009');
		textLineCountData.sort(fnLineCountSort);
		
		
		$("#textLineCount").kendoComboBox({
			dataSource : textLineCountData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  fnSystemGubunSelect,
			index : 0
		});
		textLinCountComboBox = $("#textLineCount").data("kendoComboBox");
		
		if(initFlag) {
			textLinCountComboBox.select(0);
		}
	}

	// TEXT LineCount Sort
	function fnLineCountSort(a, b) {
		if (parseInt(a.CODE_NM) < parseInt(b.CODE_NM)) {
			return -1;
		}
		if (parseInt(a.CODE_NM) > parseInt(b.CODE_NM)) {
			return 1;
		}
		return 0;
	}

	// NUMBER 소수점자리 세팅
	function fnSettingNumber() {
		
		var numberDecimalPointData = NeosCodeUtil.getCodeList('It0014');

		$("#numberDecimalPoint").kendoComboBox({
			dataSource : numberDecimalPointData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  fnSystemGubunSelect,
			index : 0
		});
		
		numberDecimalPointComboBox = $("#numberDecimalPoint").data("kendoComboBox");
		
		if(initFlag) {
			$("#numberMaxVal").val("");
			$("#numberMinVal").val("");
			numberDecimalPointComboBox.select(0);
		}
	}

	// DATETIME Setting
	function fnSettingDatetime() {
		var datetimeTypeData = NeosCodeUtil.getCodeList('It0011');
		var datetimeDateTypeData = NeosCodeUtil.getCodeList('It0012');

		$("#datetimeTermType").hide();

		datetimeDateTypeData.map(function(item){
			if(item.CODE =="10") {
				item.CODE_NM += '(yyyy)'
			} 
			else if (item.CODE =="20") {
				item.CODE_NM += '(yyyy-mm)'
			}
			else if (item.CODE =="30") {
				item.CODE_NM += '(yyyy-mm-dd)'
			}
			else if (item.CODE =="40") {
				item.CODE_NM += '(yyyy-mm-dd hh)'
			}
			else if (item.CODE =="50") {
				item.CODE_NM += '(yyyy-mm-dd hh:mm)'
			}
 			return item;
 		});

		$("#datetimeType").kendoComboBox({
			dataSource : datetimeTypeData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			change : fnDateTimeChange,
			index : 0
		});
		formDatetimeTypeComboBox = $("#datetimeType").data("kendoComboBox");

		$("#datetimeDateType").kendoComboBox({
			dataSource : datetimeDateTypeData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			change :  fnDatetimeResetValue,
			index : 0
		});
		formDatetimeDateTypeComboBox = $("#datetimeDateType").data("kendoComboBox");
		
		if(initFlag) {
			formDatetimeTypeComboBox.select(0);
			formDatetimeDateTypeComboBox.select(0);
			fnDatetimeResetValue()
			$("#datetimeTermType").hide();
		}
	}

	function fnDateTimeChange() {
		var datetimeType = $("#datetimeType").val();
		if (datetimeType == "10") {
			$("#datetimeTermType").hide();
			$("#datetimeDefault2").val("");
		}
		else {
			$("#datetimeTermType").show();
		}
	}
	
	function fnDatetimeResetValue() {
		$("#datetimeDefault1").val("");
		$("#datetimeDefault2").val("");
	}
	
	function fnDatetimeFocusout(div) {
		var inputValue = $("#datetimeDefault"+div).val()
		var datetimeDefault1 = $("#datetimeDefault1").val()
		
		var datetimeDateType = $("#datetimeDateType").val();
		
		if (inputValue == 'empty' || inputValue == 'EMPTY' || inputValue == '') {
		}
		else {
			var isCheckedValue = fnDatetimeValidation(datetimeDateType, inputValue);
			
			if (!isCheckedValue) {
				alert("<%=BizboxAMessage.getMessage("TX800002001","형식에 맞게 다시 입력 해주세요.")%>");
				$("#datetimeDefault"+div).val("");
				document.getElementById("datetimeDefault"+div).focus();
			}
			
		}
	}
	
	function leadingZeros(n, digits) {
		var zero = '';
		n = n.toString();
		if (n.length < digits) {
			for (i = 0; i < digits - n.length; i++) {
				zero += '0';
			}
		}
		return zero + n;
	}
	
	function fnDatetimeValidation(datetimeDateType, value) {
		var date_pattern = '';
		if (datetimeDateType == '10') {
			date_pattern = /^(19|20)\d{2}$/; 
		}
		else if (datetimeDateType == '20') {
			date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])$/; 
		}
		else if (datetimeDateType == '30') {
			date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; 
		}
		else if (datetimeDateType == '40') {
			date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1]) (0[0-9]|1[0-9]|2[0-3])$/; 
		}
		else if (datetimeDateType == '50') {
			date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1]) (0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/;
		}
		
		if (!date_pattern.test(value)) {
			return false
		}
		
		return true
	}

	// 사용자정의 Setting
	function fnSettingUserDefine() {
		var userDefineCodeTypeData = NeosCodeUtil.getCodeList('It0010');

		
		
		$("#userDefineCodeType").kendoComboBox({
			dataSource : userDefineCodeTypeData,
			dataTextField : "CODE_NM",
			dataValueField : "CODE",
			//change :  fnSystemGubunSelect,
			index : 0
		});
		
		userDefineCodeTypeComboBox = $("#userDefineCodeType").data("kendoComboBox");
		
		if(initFlag) {
			userDefineCodeTypeComboBox.select(0);
			$("#userDefineCodeKind").val("");
			$("#userDefineCodeDefault").val("");
		}
	}
	
	// 콜백 함수
	function fnCallBack(groupCodeInfo, detailCodeInfo) {
		var groupCode = groupCodeInfo.split("|")[0];
		var groupCodeName = groupCodeInfo.split("|")[1];
		var detailCode = detailCodeInfo.split("|")[0];
		var detailCodeName = detailCodeInfo.split("|")[1];
		
		$("#userDefineCodeKind").val(groupCodeName);
		$("#userDefineCodeDefault").val(detailCodeName);
		$("#userDefineCodeKindHidden").val(groupCode);
		$("#userDefineCodeDefaultHidden").val(detailCode);
	}
	
	// 콜백 함수
	function fnCallBackExternalCode(externalCode, externalCodeName) {
		$("#externalCodeKind").val(externalCodeName);
		$("#externalCodeKindHidden").val(externalCode);
	}
	
	// 코드 중복 확인
	function checkItemCodeSeq(id) {
		var strReg = /^[A-Za-z0-9]+$/; 

        if (!strReg.test(id)){
			alert('<%=BizboxAMessage.getMessage("TX000017329","영문과 숫자만 입력가능합니다.")%>');
			$("#formItemCode").val("");
			return;
        }
        
		if (id == ""){
			$("#info").prop("class", "");
	        $("#info").html("");
		}
		
        if (id != null && id != '') {
        	if(id == "0"){
            	$("#info").prop("class", "fl text_red f11 mt5 ml10");
                $("#info").html("! <%=BizboxAMessage.getMessage("TX000009762", "사용 불가능한 코드 입니다")%>");
            }
        	else{
	            $.ajax({
	                type: "post",
	                url : '<c:url value="/cmm/systemx/item/checkItemCodeSeq.do" />',
	                datatype: "text",
	                data: { itemCodeSeq: id },
	                success: function (data) {
	                    if (data.result == "1") {
	                    	$("#info").prop("class", "fl text_blue f11 mt5 ml10");
	                        $("#info").html("* <%=BizboxAMessage.getMessage("TX000009763", "사용 가능한 코드 입니다")%>");
	                        duplicateFlag = false;
	                    }                    
	                    else {
	                    	$("#info").prop("class", "fl text_red f11 mt5 ml10");
	                        $("#info").html("! <%=BizboxAMessage.getMessage("TX000010757", "코드가 중복되었습니다")%>");
	                        duplicateFlag = true;
	                    }
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error");
	                }
	            });
            }
       	}	
	}
        
	function removeCharCnt(event,count) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ){
			return; 
		}else{
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
			
			if(event.target.value.length > count){
				event.target.value = event.target.value.substring(0,count);
			}
			
		}
			
	}


</script>

<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000017330","항목범위")%></dt>
		<dd>
			<input id="searchItemRange" style="width: 110px;" />
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000003501","항목명")%></dt>
		<dd>
			<input type="text" class="" id="itemSearchKey" style="width: 173px;" />
		</dd>
		<dd>
			<input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
		</dd>
		<dd class="fr mr20 mt0">
			<input type="checkbox" name="ms_chk" id="isShowNotUse"
				class="k-checkbox"> <label class="k-checkbox-label radioSel"
				for="isShowNotUse"><%=BizboxAMessage.getMessage("TX000017331","미사용포함")%></label>
		</dd>
	</dl>
</div>

<div class="sub_contents_wrap" style="">

	<div class="btn_div">
		<div class="left_div">
			<p class="tit_p m0 mt7"><%=BizboxAMessage.getMessage("TX000017332","항목 목록")%></p>
		</div>

		<div class="right_div">
			<div class="controll_btn p0">
				<button id="newButton" class="k-button"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
				<button id="saveButton" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
				<button id="deleteButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>
	</div>

	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width: 50%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<div class="com_ta2 sc_head" style="">
						<table>
							<colgroup>
								<col width="34" />
								<col width="" />
								<col width="" />
								<col width="" />
								<col width="" />
								<col width="" />
							</colgroup>
							<tr>
								<th><input type="checkbox" name="all_chk" id="all_chk"
									class="k-checkbox"> <label
									class="k-checkbox-label radioSel" for="all_chk"></label></th>
								<th><%=BizboxAMessage.getMessage("TX000003930","항목코드")%></th>
								<th><%=BizboxAMessage.getMessage("TX000003501","항목명")%></th>
								<th><%=BizboxAMessage.getMessage("TX000017330","항목범위")%></th>
								<th>TYPE</th>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
							</tr>
						</table>
					</div>

					<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
						style="height: 556px;">
						<table>
							<colgroup>
								<col width="34" />
								<col width="" />
								<col width="" />
								<col width="" />
								<col width="" />
								<col width="" />
							</colgroup>
							<tbody id="itemList">
								<!-- <tr>
								<td><input type="checkbox" name="inp_chk" id="inp_chk1"
									class="k-checkbox"> <label
									class="k-checkbox-label radioSel" for="inp_chk1"></label></td>
								<td>1001</td>
								<td>신청사유</td>
								<td>전자결재</td>
								<td>TEXT</td>
								<td>예</td>
							</tr> -->
							</tbody>

						</table>
					</div>
				</td>
				<td class="twinbox_td">
					<!-- 옵션설정 -->
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120" />
								<col width="" />
							</colgroup>
							<tr>
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000003930","항목코드")%></th>
								<td><input id="formItemCode" class="fl" type="text"
									value="" placeholder="<%=BizboxAMessage.getMessage("TX000017333","영문/숫자만 입력가능")%>" value="" style="width: 162px" onkeyup="checkItemCodeSeq(this.value);">
									<p id="info" class="fl text_blue f11 mt5 ml10"></p>	
									<!-- <p class="fl text_red f11 mt5 ml10">! 코드가 중복되었습니다.</p>  사용 안할경우 p태그 주석처리-->
									<!-- <p class="fl text_blue f11 mt5 ml10">! 사용 가능한 코드 입니다.</p>  사용 안할경우 p태그 주석처리-->
								</td>
							</tr>
							<tr>
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000003501","항목명")%></th>
								<td><input id="formItemName" class="" type="text" value=""
									style="width: 95%"></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000016","설명")%></th>
								<td><input id="formItemDesc" class="" type="text" value=""
									style="width: 95%"></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000017330","항목범위")%></th>
								<td><input id="formItemRange" style="width: 110px;" /></td>
							</tr>
							<tr>
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									TYPE</th>
								<td>
									<!-- type 선택에 따라 아래 숨겨진 옵션들이 노출되어야 합니다. --> <input
									id="formItemType" style="width: 110px;" /> <!-- SYSTEM Type -->
									<div id="system" class="type_no1 mt5 typeForm"
										style="display: none;">
										<div class="com_ta">
											<table>
												<colgroup>
													<col width="120" />
													<col width="" />
												</colgroup>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>
													<td><input id="systemGubun" style="width: 130px;" /></td>
												</tr>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000000936","기본값")%></th>
													<td><input id="systemDefault" style="width: 130px;" /></td>
												</tr>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000017334","멀티선택")%></th>
													<td><input id="systemMulti" style="width: 130px;" /></td>
												</tr>
												<tr>
													<th>Display</th>
													<td><input id="systemDisplay" style="width: 130px;" /></td>
												</tr>
											</table>
										</div>
									</div> <!-- TEXT Type -->
									<div id="text" class="type_no2 mt5 typeForm"
										style="display: none;">
										<div class="com_ta">
											<table>
												<colgroup>
													<col width="120" />
													<col width="" />
												</colgroup>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000017335","Line 수")%></th>
													<td><input id="textLineCount" style="width: 110px;" /></td>
												</tr>

												<tr>
													<th><%=BizboxAMessage.getMessage("TX000005238","제한")%> Byte</th>
													<td><input id="textLength" type="text" style="width: 110px;" onkeydown='return onlyNumber(event);' onkeyup='removeCharCnt(event,5);' /> Byte</td>
												</tr>
												
												
											</table>
										</div>
									</div> <!-- NUMBER Type -->
									<div id="number" class="type_no3 mt5 typeForm"
										style="display: none;">
										<div class="com_ta">
											<table>
												<colgroup>
													<col width="120" />
													<col width="" />
												</colgroup>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000017336","최대값")%></th>
													<td><input id="numberMaxVal" class="" type="text"
														value="" style="width: 95%"></td>
												</tr>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000017337","최소값")%></th>
													<td><input id="numberMinVal" class="" type="text"
														value="" style="width: 95%"></td>
												</tr>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000017338","소수점자릿수")%></th>
													<td><input id="numberDecimalPoint" class="" style="width: 110px;"></td>
												</tr>
											</table>
										</div>
									</div>
									<!-- DATETIME Type -->
									<div id="datetime" class="type_no4 mt5 posi_re typeForm" style="display: none;">
										<div class="com_ta">
											<table>
												<colgroup>
													<col width="120" />
													<col width="" />
												</colgroup>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000017339","날짜 Type")%></th>
													<td><input id="datetimeType" style="width: 250px;" /></td>
												</tr>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000012203","형식")%></th>
													<td><input id="datetimeDateType" style="width: 250px;" /></td>
												</tr>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000000936","기본값")%>1</th>
													<td>
														<input id="datetimeDefault1" class="" type="text" value="yyyy" placeholder="<%=BizboxAMessage.getMessage("TX000012690","날짜 형식에 맞춰 입력하세요")%>" style="width: 250px" onfocusout="fnDatetimeFocusout('1')">
<!-- 														<a href="#" class="btn_question_mark"></a> -->
													</td>
												</tr>
												<tr id="datetimeTermType">
													<th><%=BizboxAMessage.getMessage("TX000000936","기본값")%>2</th>
													<td>
														<input id="datetimeDefault2" class="" type="text" value="yyyy" placeholder="<%=BizboxAMessage.getMessage("TX000012690","날짜 형식에 맞춰 입력하세요")%>" style="width: 250px" onfocusout="fnDatetimeFocusout('2')">
<!-- 														<a href="#" class="btn_question_mark"></a> -->
													</td>
												</tr>
											</table>
											<br />
											※ <%=BizboxAMessage.getMessage("TX800002000","기본값 미입력 시, Today 기준으로 결재양식에 표시됩니다.")%>
										</div>

										<!-- 물음표 도움말 팝 : 미사용으로 주석처리(2021.01.20) -->
<!-- 										<div class="pop_wrap_dir qm_pop"> -->
<!-- 											<div class="pop_head"> -->
<%-- 												<h1><%=BizboxAMessage.getMessage("TX000017340","기본 입력값 형식안내")%></h1> --%>
<!-- 											</div> -->

<!-- 											<div class="pop_con"> -->
<!-- 												<div class="com_ta"> -->
<!-- 													<table> -->
<%-- 														<colgroup> --%>
<%-- 															<col width="110" /> --%>
<%-- 															<col width="" /> --%>
<%-- 														</colgroup> --%>
<!-- 														<tr> -->
<%-- 															<th><%=BizboxAMessage.getMessage("TX000000435","년")%></th> --%>
<!-- 															<td>yyyy</td> -->
<!-- 														</tr> -->
<!-- 														<tr> -->
<%-- 															<th><%=BizboxAMessage.getMessage("TX000002881","년월")%></th> --%>
<!-- 															<td>yyyy-mm</td> -->
<!-- 														</tr> -->
<!-- 														<tr> -->
<%-- 															<th><%=BizboxAMessage.getMessage("TX000017341","년월일")%></th> --%>
<!-- 															<td>yyyy-mm-dd</td> -->
<!-- 														</tr> -->
<!-- 														<tr> -->
<%-- 															<th><%=BizboxAMessage.getMessage("TX000017342","년월일시")%></th> --%>
<!-- 															<td>yyyy-mm-dd hh</td> -->
<!-- 														</tr> -->
<!-- 													</table> -->
<!-- 												</div> -->
<!-- 												// com_ta -->
<!-- 											</div> -->
<!-- 										</div> -->
										<!-- //pop_wrap -->
									</div> <!-- PROJECT Type -->
									<div id="project" class="type_no5 mt5 dod_search typeForm"
										style="display: none;">
										<input class="" type="text" value="PROJECT" style="width: 95%"
											readonly="readonly">
									</div> <!-- 사용자정의 Type -->
									<div id="userDefine" class="type_no6 mt5 typeForm"
										style="display: none;">
										<div class="com_ta">
											<table>
												<colgroup>
													<col width="120" />
													<col width="" />
												</colgroup>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000017343","CODE 형태")%></th>
													<td><input id="userDefineCodeType"
														style="width: 110px;" /></td>
												</tr>
												<tr>
													<th rowspan="2"><%=BizboxAMessage.getMessage("TX000017344","코드 유형")%><br />/<%=BizboxAMessage.getMessage("TX000017345","코드 기본값")%>
													</th>
													<td>
													<input id="userDefineCodeKind" class="" type="text" value="" style="width: 109px" readonly placeholder="<%=BizboxAMessage.getMessage("TX000017344","코드 유형")%>">
													<input id="userDefineCodeKindHidden" class="" type="hidden" value="" >
														<div class="controll_btn p0">
															<button id="userDefineSelectButton"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
														</div></td>
												</tr>
												<tr>
													<td><input id="userDefineCodeDefault" class="" type="text" value="" style="width: 109px" readonly placeholder="<%=BizboxAMessage.getMessage("TX000017345","코드 기본값")%>"></td>
													<input id="userDefineCodeDefaultHidden" class="" type="hidden" value="" >
												</tr>
											</table>
										</div>
									</div>
									<div id="externalCode" class="type_no6 mt5 typeForm"
										style="display: none;">
										<div class="com_ta">
											<table>
												<colgroup>
													<col width="120" />
													<col width="" />
												</colgroup>
												<tr>
													<th rowspan="2"><img src="../../../Images/ico/ico_check01.png"
														alt="" /><%=BizboxAMessage.getMessage("TX900000019","코드 선택")%>
													</th>
													<td>
													<input id="externalCodeKind" class="" type="text" value="" style="width: 109px" placeholder="<%=BizboxAMessage.getMessage("TX900000020","코드/코드명")%>">
													<input id="externalCodeKindHidden" class="" type="hidden" value="" >
													<div class="controll_btn p0">
														<button id="externalSelectButton"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
													</div></td>
												</tr>
											</table>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td><input type="radio" name="radio_u1u2" id="useY"
									class="k-radio itemUseYN" value="1" checked="checked">
									<label class="k-radio-label radioSel" for="useY"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
									<input type="radio" name="radio_u1u2" id="useN"
									class="k-radio itemUseYN" value="0"> <label
									class="k-radio-label radioSel ml10" for="useN"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
								</td>
							</tr>
						</table>
					</div> <!-- 					<div class="btn_cen">
						<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
					</div> -->
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- //sub_contents_wrap -->
