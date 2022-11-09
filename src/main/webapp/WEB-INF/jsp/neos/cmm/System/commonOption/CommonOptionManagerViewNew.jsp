<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib uri="/tags/np_taglib" prefix="nptag"%>
<%@page import="main.web.BizboxAMessage"%>
<%@page import="cloud.CloudConnetInfo"%>

<style>
.multibox{overflow:hidden;float:left;width:83%; min-height:22px;margin:4px 4px 3px 0;border:1px solid #c3c3c3;}
.multibox li{float:left;clear:none;margin:1px;padding:2px;border:1px solid #accfff;background-color:#eff7ff;color:#4a4a4a;}
.multibox li .close_btn{margin:0 4px;}

input::placeholder {color:#ccc;}
input::-webkit-input-placeholder {color:#ccc;}
input:-ms-input-placeholder {color:#ccc;}

textarea::placeholder {color:#ccc;}
textarea::-webkit-input-placeholder {color:#ccc;}
textarea:-ms-input-placeholder {color:#ccc;}
</style>

<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>

<script type="text/javascript">
	var optionId = "";
	var selectedOptionValueId = "";
	var selectedOptionValueOld = "";
	var optionListData = '';	// optionList 값
	var gubunType = '';			// 타입 변수
	var gubunCombobox = '';		// 구분 콤보박스 값 (disable을 위해 선언)
	
	var buildType = "<%=CloudConnetInfo.getBuildType()%>";

	$(document).ready(function() {
		// 기본버튼
		$(".controll_btn button").kendoButton();
		
		// 구분값 선택
		fnOptionGubun();
		
		// 회사선택
		fnCompList();
		
		// 테이블 row 클릭 이벤트
		$("#optionTable").on("click", ".optionSetting", function(){
			fnOptionSetting(this);
		});
		
		// 저장 버튼 
		$("#saveButton").click(function(){
			fnSave();	
		});

		// 옵션테이블 active
		$('#optionTable').on("click", ".p_list, .op_list", function() {
			$('.op_ta tr').removeClass('on');
			$(this).parent().addClass('on');
		})
		$('#optionTable').on("click", ".p_list", function() {
			$(this).toggleClass('active');
			$(this).parent().next().toggleClass('active');
		})
		
	});
	
	// 회사 리스트 그려주기
	function fnCompList() {
		$("#company").kendoComboBox({
			dataTextField: "compName",
			dataValueField: "compSeq",
			dataSource :${compListJson},
			change: fnGetOptionData,
			filter: "contains",
			suggest: true
		});
		
		var coCombobox = $("#company").data("kendoComboBox");
		if("${loginVO.userSe}" == "MASTER"){
			coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000933","그룹")%>", compSeq: "0" });
			coCombobox.refresh();
		}
		coCombobox.select(0);
		
		fnGetOptionData();
	}
	
	function fnOptionGubun() {
		$("#division").kendoComboBox({
			dataSource : [
            	{Gubun:"Web", Value:"cm"},
            	{Gubun:"Messenger", Value:"msg"},
            	{Gubun:"App", Value:"app"},
             	{Gubun:"<%=BizboxAMessage.getMessage("TX000006671","공통")%>", Value:"cm"}
            ],
            dataTextField : "Gubun",
            dataValueField : "Value",
            change: fnGetOptionData
		});
		gubunCombobox = $("#division").data("kendoComboBox");
		gubunCombobox.select(0);
	}
	
	// 최초 옵션 그려주기
	var optionTableTag = '';
	function fnDraw() {
		
		var pOptionId = '';
		var optionList = optionListData;
		
		for(var i=0; i<optionList.length; i++) {
			var optionData = optionList[i].value;
			
			if(optionData.optionLevel == 1) {
				fnDrawDetail(optionData);
			}
		}	
		
		$("#optionList").html(optionTableTag);
	}

	var flag = true;
	function fnDrawDetail(data) {
		
		if(data.children.length > 0){
			data.children = data.children.filter(function(val){return val.pOptionMustValue == null || val.pOptionMustValue == "" || val.pOptionMustValue.indexOf("|" + data.optionValue + "|") > -1});
		}
		
		if(data.children.length == 0) {
			
			// 자식 노드가 없는 경우
			if(flag) {
				optionTableTag += '<tr id="' + data.optionId + '" gubun="' + data.optionGroup + '" class="optionSetting">';
				optionTableTag += '<td class="le op_list"><span class="">' + data.optionNm + '</span></td>';
				optionTableTag += '<td class="le">' + fnGetOptionValueName(data.optionId, data.selectValue, data.optionValueId, data.optionValue) + '</td>';
				optionTableTag += '</tr>';	
			}
			return;
			
		} else {
			
			if(flag) {
				
				//폴더형 상위옵션
				if(data.optionValueId == null && data.pOptionMustValue == null){
					optionTableTag += '<tr id="' + data.optionId + '" gubun="folder" class="optionSetting">';
					optionTableTag += '<td class="le p_list"><span class="">' + data.optionNm + '</span></td>';
					optionTableTag += '<td class="le"></td>';

				}else{
					optionTableTag += '<tr id="' + data.optionId + '" gubun="' + data.optionGroup + '" class="optionSetting">';
					optionTableTag += '<td class="le p_list"><span class="">' + data.optionNm + '</span></td>';
					optionTableTag += '<td class="le">' + fnGetOptionValueName(data.optionId, data.selectValue, data.optionValueId, data.optionValue) + '</td>';
				}

				optionTableTag += '</tr>';
				
			}
			
			//하위노드 그리기
			optionTableTag += '<tr class="op_sub">';
			optionTableTag += '<td class="p0 brn" colspan="2">';
			optionTableTag += '<table>';
			optionTableTag += '<colgroup>';
			optionTableTag += '<col width=""/>';
			optionTableTag += '<col width="200"/>';
			optionTableTag += '</colgroup>';
			
			// 자식 노드 
			for(var i=0; i<data.children.length; i++) {
				flag = false;
				
				if(data.children[i].children.length > 0){
					data.children[i].children = data.children[i].children.filter(function(val){return val.pOptionMustValue == null || val.pOptionMustValue == "" || val.pOptionMustValue.indexOf("|" + data.children[i].optionValue + "|") > -1});
				}
				
				optionTableTag += '<tr id="' + data.children[i].optionId + '" gubun="' + data.children[i].optionGroup + '" class="optionSetting">';
				optionTableTag += '<td class="le ' + (data.children[i].children.length == 0 ? "op_list" : "p_list") + '"><span class="">' + data.children[i].optionNm + '</span></td>';
				optionTableTag += '<td class="le">' + fnGetOptionValueName(data.children[i].optionId, data.children[i].selectValue, data.children[i].optionValueId, data.children[i].optionValue) + '</td>';
				optionTableTag += '</tr>';					
				
				fnDrawDetail(data.children[i]);	
			}
			optionTableTag += '</table>';
			optionTableTag += '</td>';
			optionTableTag += '</tr>';
			flag = true;
		}
	}
	
	function fnGetOptionValueName(optionIdTo, selectValue, optionValueIdTo, optionValueTo){
		
		if(optionIdTo == "cm101"){
			//로그인실패 잠금설정
		 	var selectValueArray = selectValue.split("|");
			
			if(selectValueArray[0] == "0"){
				selectValue = "<%=BizboxAMessage.getMessage("TX000018611","미사용")%>";
			}else{
				selectValue = selectValueArray[0] + "<%=BizboxAMessage.getMessage("TX000003554","회")%>";
				
				if(selectValueArray.length > 1 && selectValueArray[1] != "0"){
					selectValue += " / " + selectValueArray[1] + "<%=BizboxAMessage.getMessage("TX000020500","분")%>";
				}else{
					selectValue += " / " + "<%=BizboxAMessage.getMessage("TX000022935","계속")%>";
				}
			}
		}else if(optionIdTo == "cm101_1"){
			//로그인 미접속 잠금설정
			if(selectValue != "0" && selectValue != ""){
				selectValue += "<%=BizboxAMessage.getMessage("TX000020247","일")%>";	
			}else{
				selectValue = "<%=BizboxAMessage.getMessage("TX000018611","미사용")%>";
			}
		}else if(optionIdTo == "cm102"){
			//강제 로그아웃 시간설정
			if(selectValue != "0" && selectValue != ""){
				selectValue += "<%=BizboxAMessage.getMessage("TX000020500","분")%>";	
			}else{
				selectValue = "<%=BizboxAMessage.getMessage("TX000018611","미사용")%>";
			}
		}else if(optionIdTo == "cm201"){
			//비밀번호 만료기간 설정
			
			var cm201Type = "d";
			var cm201Val1 = "0";
			var cm201Val2 = "0";
			
			var cm201Value = optionValueTo.split("▦");
			
			if(cm201Value.length > 1){
				cm201Type = cm201Value[0];
				cm201Val1 = cm201Value[1].split("|")[0];
				cm201Val2 = cm201Value[1].split("|")[1];
			}else{
				var selectValueArray = cm201Value[0].split("|");
				
				if(selectValueArray.length > 1){
					cm201Val1 = selectValueArray[0];
					cm201Val2 = selectValueArray[1];
				}else{
					cm201Val2 = selectValueArray[0];
				}
				
			}
			
			selectValue = "";
			
			if(cm201Type == "d" && (cm201Val1 != "0" || cm201Val2 != "0")){
				
				if(cm201Val1 != "0" && cm201Val1 != ""){
					selectValue += cm201Val1 + "<%=BizboxAMessage.getMessage("TX000022796","일 이후 안내")%>" + "<br>";
				}					
				
				if(cm201Val2 != "0" && cm201Val2 != ""){
					selectValue += cm201Val2 + "<%=BizboxAMessage.getMessage("TX000022942","일 이후 만료(종료)")%>";	
				}
				
			}else if(cm201Type == "m"){
				
				selectValue += "<%=BizboxAMessage.getMessage("","매월")%> " + cm201Val1 + "<%=BizboxAMessage.getMessage("","일 만료(종료)")%>" + "<br>";
				selectValue += cm201Val2 + "<%=BizboxAMessage.getMessage("","일 전 안내")%>";
				
			}else{
				selectValue = "<%=BizboxAMessage.getMessage("TX000018611","미사용")%>";
			}
		
		}else if(optionIdTo == "cm202"){
			//비밀번호 입력 자리수 설정
			var selectValueArray = selectValue.split("|");
			
			selectValue = "";
			
			if(selectValueArray[0] != "0" && selectValueArray[0] != ""){
				selectValue = "<%=BizboxAMessage.getMessage("TX000010842","최소")%> : " + selectValueArray[0];	
			}
			
			if(selectValueArray.length > 1 && selectValueArray[1] != "0" && selectValueArray[1] != ""){
				selectValue += (selectValue != "" ? " / " : "") + "<%=BizboxAMessage.getMessage("TX000002618","최대")%> : " + selectValueArray[1];	
			}
			
		}else if(optionIdTo == "cm205" || optionIdTo == "cm206"){
			//비밀번호 입력 자리수 설정
			var selectValueArray = selectValue.split("|");
			
			if(selectValueArray[0] != ""){
				selectValue = selectValueArray[0];
				
				if(selectValueArray.length > 1){
					selectValue += " <%=BizboxAMessage.getMessage("TX000005613","외")%> " + (selectValueArray.length-1).toString() + "<%=BizboxAMessage.getMessage("TX000000476","건")%>";
				}
				
			}else{
				selectValue = "<%=BizboxAMessage.getMessage("TX000018611","미사용")%>";
			}
			
		}
		
		//확장자제한 예외처리 
		if(optionValueIdTo == "option0207"){
			var extList = optionValueTo.split("▦")[1];
			
			if(extList != ""){
				selectValue += "</br>(" + extList.replace(new RegExp("\\|", "g"), ", ") + ")";
			}
		}
		
		return selectValue;
	}

	var erpSyncResult = '';
	var useCompInfo = '';
	
	// 옵션 데이터 가져오기
	function fnGetOptionData() {
		optionTableTag = '';
		var param = {};
		param.compSeq = $("#company").val();
		
		if($("#company").val() == "0") {
			param.gubun = "1";		// 그룹 선택 시
			gubunCombobox.enable(true);	
		} else {
			param.gubun = "2";		// 회사 선택 시 
			
			// 회사 선택 시 구분 값 비활성화
			gubunCombobox.select(0);
			gubunCombobox.enable(false);			
		}
		
		param.type = $("#division").val();
		param.typeText = $("#division").data("kendoComboBox").input.val();
		
		$.ajax({
			type : "post",
			url  : "<c:url value='/cmm/system/CommonOptionList.do'/>",
			dataType : "json",
			data : param,
			async : false,
			success : function(result) {
				optionListData = result.optionListJson;
				erpSyncResult = result.erpSyncResult;
				erpSyncResult = result.erpSyncResult;
				useCompInfo = result.useCompInfo;
				fnDraw();
			},
			error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
			}
		});
	}
	
	// 옵션 데이터 갱신
	function fnRefreshOptionData(optionId) {
		
		optionTableTag = '';
		var param = {};
		param.compSeq = $("#company").val();
		
		if($("#company").val() == "0") {
			param.gubun = "1";		// 그룹 선택 시
		} else {
			param.gubun = "2";		// 회사 선택 시 
		}
		
		param.type = $("#division").val();
		param.typeText = $("#division").data("kendoComboBox").input.val();
		param.optionId = optionId;
		param.compare = "compare";
		
		$.ajax({
			type : "post",
			url  : "<c:url value='/cmm/system/CommonOptionList.do'/>",
			dataType : "json",
			data : param,
			async : false,
			success : function(result) {
				$($("#optionList #"+optionId+" td")[1]).html(fnGetOptionValueName(result.optionListJson[0].value.optionId, result.optionListJson[0].value.selectValue, result.optionListJson[0].value.optionValueId, result.optionListJson[0].value.optionValue));
			},
			error: function(result) {

			}
		});
	}	
	
	//게시판 롤업 게시판 선택버튼 팝업
	function fnBoardListPop(){
		var url = "/gw/cmm/systemx/portal/portletBoardListPop.do?";
		openWindow2(url, "portletEaBoxListPop", 502, 700, 1, 1);
	}
	
	function boardTreeCallBack(boardId, boardNm){
		$("#msg1910_").val(boardNm + "(" + boardId + ")");
	}
	
	// 옵션 설정 값 
	function fnOptionSetting(data) {
		
		gubunType = $(data).attr("gubun");
		var id = $(data).attr("id");
		
		//클라우드형 아이디/비밀번호 설정규칙 필수
		if(buildType == "cloud" && id == "cm200"){
			gubunType = "folder";
		}
		
		//옵션설명 및 관련 옵션 설명 추가 구문
		$("#optionDetail").text(optionListData.filter(function(x) { return x.optionId === id})[0].value.optionDesc);
		$("#addOptionDetail").text(optionListData.filter(function(x) { return x.optionId === id})[0].value.optionDesc2);
		
		if(gubunType == "folder"){
			$("#optionSettingValue").html("");
			$("#saveButton").hide();
			return;
		}else{
			$("#saveButton").show();
		}		
		
		var param = {};
		
		param.optionId = id;
		param.gubunType = gubunType;
		param.compSeq = $("#company").val();
		
		if($("#company").val() == "0") {
			param.gubun = "1";		// 그룹 선택 일 때
		} else {
			param.gubun = "2";		// 회사 선택 일 때 
		}
		
		$.ajax({
			type : "post",
			url  : "<c:url value='/cmm/system/CommonOptionSettingValue.do'/>",
			dataType : "json",
			data : param,
			async : false,
			success : function(result) {
				var optionValue = result.optionValueJson;
				var tag = '';
				
				optionId = optionValue[0].optionId;
				selectedOptionValueOld = optionValue[0].optionValueDisplay;
				
				if(optionId == "cm101") {

					var valArray = optionValue[0].optionValueDisplay.split("|");
					var val1 = valArray.length > 1 ? valArray[1] : "0";
					
					tag += '<tr><td class="le">';
					tag += '<input type="text" id="select_val0" value="' + valArray[0] + '"> <%=BizboxAMessage.getMessage("TX000022937","회 실패할 경우")%>';
					tag += '</td></tr>';
					
					tag += '<tr><td class="le" style="padding-left:30px;">';
					tag += '<input type="radio" name="select_val1" id="select_val1_0" class="k-radio" value="0" '+(val1 == "0" ? "checked=\"checked\"" : "")+' >';	
					tag += '<label for="select_val1_0"><%=BizboxAMessage.getMessage("TX000022952","계속 잠금상태 유지 (관리자 문의)")%></label>';
					tag += '</td></tr>';
					
					tag += '<tr><td class="le" style="padding-left:30px;">';
					tag += '<input type="radio" name="select_val1" id="select_val1_1" class="k-radio" value="1" '+(val1 != "0" ? "checked=\"checked\"" : "")+' >';	
					tag += '<label for="select_val1_1"><input type="text" id="select_val2" value="' + val1 + '"> <%=BizboxAMessage.getMessage("TX000022938","분 동안 잠금상태 유지")%></label>';
					tag += '</td></tr>';
					
				}else if(optionId == "cm101_1") {

					tag += '<tr><td class="le">';
					tag += '<input type="text" id="select_val0" value="' + optionValue[0].optionValueDisplay + '"> <%=BizboxAMessage.getMessage("TX000022939","일 동안 접속하지 않은 경우")%>';
					tag += '</td></tr>';
					
				}else if(optionId == "cm102") {

					tag += '<tr><td class="le">';
					tag += '<input type="text" id="select_val0" value="' + optionValue[0].optionValueDisplay + '"> <%=BizboxAMessage.getMessage("TX000022940","분 동안 사용하지 않은 경우")%>';
					tag += '</td></tr>';
					
				}else if(optionId == "cm205" || optionId == "cm206") {
					
					tag += '<tr>';
					tag += '<td><input type="text" id="multiTextInput" placeholder="<%=BizboxAMessage.getMessage("TX900000076","제한단어입력")%> + Enter" style="width:99%;text-align:center;" onkeyup="javascript:if(event.keyCode==13){fnAddText(\'\'); return false;}" /></td>';
					tag += '</tr>';
					
					var valArray = optionValue[0].optionValueDisplay.split("|");
					tag += '<tr><td>';
					tag += '<ul class="multibox scroll_y_on" id="multiTextInputBox" style="width:99%; height:320px;-ms-overflow-y:scroll;">';
					
					$.each(valArray, function( index, value ) {
						if(value != "")
						tag += '<li>'+value+'<a class="close_btn" onclick="fnRemoveText(this);" href="#"><img src="/gw/Images/ico/close_btn01.png"></a></li>';
					});
					
					tag += '</ul>';
					tag += '</td></tr>';					

				}else if(optionId == "com701") {
					
					var com701OptionValue =  optionValue[0].optionValueDisplay.split('|');
					
					tag += '<tr><td class="le">';
					if(com701OptionValue.length > 1){
						tag += '<input type="radio" name="selectCom701" id="' + optionValue[1].optionId + "_" + optionValue[1].detailCode + '" class="k-radio" value="' + optionValue[1].detailCode + '" onclick="com701Click(0)">';
					}else{
						tag += '<input type="radio" name="selectCom701" id="' + optionValue[1].optionId + "_" + optionValue[1].detailCode + '" class="k-radio" value="' + optionValue[1].detailCode + '" onclick="com701Click(0)" checked="checked">';
					}
					tag += '<label class="k-radio-label radioSel-op" for="' + optionValue[1].optionId + "_" + optionValue[1].detailCode + '">' + optionValue[1].detailName + '</label>';
					tag += '</td></tr>';
					tag += '<tr><td class="le">';
					if(com701OptionValue.length > 1){
						tag += '<input type="radio" name="selectCom701" id="' + optionValue[0].optionId + "_" + optionValue[0].detailCode + '" class="k-radio" value="' + optionValue[0].detailCode + '" onclick="com701Click(1)" checked="checked">';
					}else{
						tag += '<input type="radio" name="selectCom701" id="' + optionValue[0].optionId + "_" + optionValue[0].detailCode + '" class="k-radio" value="' + optionValue[0].detailCode + '" onclick="com701Click(1)">';
					}
					tag += '<label class="k-radio-label radioSel-op" for="' + optionValue[0].optionId + "_" + optionValue[0].detailCode + '">' + optionValue[0].detailName + '</label>';
					tag += '</td></tr>';
					
					if(com701OptionValue.length > 1){
						tag += '<tr id="com701_addOption">';
						tag += '<td class="le">';
						tag += '<input type="text" name="select" id="com701_" value="' + com701OptionValue[0] + '" style="width:80px;"> <input  id="com701Commbo" style="width:80px;"/>';
					}else{
						tag += '<tr id="com701_addOption" style="display:none;">';
						tag += '<td class="le">';
						tag += '<input type="text" name="select" id="com701_" value="" style="width:80px;"> <input  id="com701Commbo" style="width:80px;"/>';
					}
					
					tag += '</td>';
					tag += '</tr>';

				}else if(optionId == "cm600") {
					tag += '<tr>';
					tag += '<td class="le">';
					if(optionValue[0].optionValueDisplay.split("▦")[0] == "1"){
						tag += '<input type="radio" name="selectcm600" id="' + optionValue[1].optionId + "_" + optionValue[1].detailCode + '" class="k-radio" value="' + optionValue[1].detailCode + '" checked="checked" onclick="cm600Click(\'1\')">';
					}else{
						tag += '<input type="radio" name="selectcm600" id="' + optionValue[1].optionId + "_" + optionValue[1].detailCode + '" class="k-radio" value="' + optionValue[1].detailCode + '" onclick="cm600Click(\'1\')">';
					}
					tag += '<label class="k-radio-label radioSel-op" for="' + optionValue[1].optionId + "_" + optionValue[1].detailCode + '">' + optionValue[1].detailName + '</label>';
					tag += '</td>';
					tag += '</tr>';
					if(optionValue[0].optionValueDisplay.split("▦")[0] == "1"){
						tag += '<tr style="" id="cm600input">';
					}else{
						tag += '<tr style="display:none;" id="cm600input">';
					}
					tag += '<td class="le">';
					tag += '<input style="width:98%;text-align:center;" placeholder="<%=BizboxAMessage.getMessage("TX000001996","숫자만 입력 가능합니다.")%>" type="text" name="select" id="txt' + optionValue[1].optionId + '" value="' + optionValue[1].optionValueDisplay.split("▦")[1] + '">';
					tag += '</td>';
					tag += '</tr>';
					tag += '<tr>';
					tag += '<td class="le">';
					if(optionValue[0].optionValueDisplay.split("▦")[0] == "0"){
						tag += '<input type="radio" name="selectcm600" id="' + optionValue[0].optionId + "_" + optionValue[0].detailCode + '" class="k-radio" value="' + optionValue[0].detailCode + '" checked="checked" onclick="cm600Click(\'0\')">';
					}else{
						tag += '<input type="radio" name="selectcm600" id="' + optionValue[0].optionId + "_" + optionValue[0].detailCode + '" class="k-radio" value="' + optionValue[0].detailCode + '" onclick="cm600Click(\'0\')">';
					}
					tag += '<label class="k-radio-label radioSel-op" for="' + optionValue[0].optionId + "_" + optionValue[0].detailCode + '">' + optionValue[0].detailName + '</label>';
					tag += '</td>';
					tag += '</tr>';
					
				} else {
					
					selectedOptionValueId = "";
					var optionValueDisplay = "";
					
					for(var i=optionValue.length; i>0; i--) {
						
						selectedOptionValueId = optionValue[i-1].optionValueId;
						optionValueDisplay = optionValue[i-1].optionValueDisplay;
						
						if(optionValue[i-1].optionGroup == "single") {				// 라디오 버튼 기능
							tag += '<tr>';
							tag += '<td class="le">';
							if(optionValue[i-1].detailCode == optionValue[i-1].optionValueDisplay.split("▦")[0]) {
								tag += '<input type="radio" name="select" id="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '" class="k-radio" value="' + optionValue[i-1].detailCode + '" checked="checked">';	
								tag += '<label class="k-radio-label radioSel-op" for="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '">' + optionValue[i-1].detailName + '</label>';
							} else {
								tag += '<input type="radio" name="select" id="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '" class="k-radio" value="' + optionValue[i-1].detailCode + '">';
								tag += '<label class="k-radio-label radioSel-op" for="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '">' + optionValue[i-1].detailName + '</label>';
							}							
							tag += '</td>';
							tag += '</tr>';
						} else if(optionValue[i-1].optionGroup == "multi") {		// checkbox 버튼 기능
							var selectValue = "|" + optionValue[0].optionValueDisplay + "|";
						
							tag += '<tr>';
							tag += '<td class="le">';
							
							if(selectValue.indexOf("|" + optionValue[i-1].detailCode + "|") != -1) {
								tag += '<input type="checkbox" name="select" id="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '" class="k-checkbox" value="' + optionValue[i-1].detailCode + '" checked="checked">';
								tag += '<label class="k-checkbox-label chkSel-op" for="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '">' + optionValue[i-1].detailName + '</label>';	
							} else {
								tag += '<input type="checkbox" name="select" id="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '" class="k-checkbox" value="' + optionValue[i-1].detailCode + '">';
								tag += '<label class="k-checkbox-label chkSel-op" for="' + optionValue[i-1].optionId + "_" + optionValue[i-1].detailCode + '">' + optionValue[i-1].detailName + '</label>';
							}
							
							if(optionValue[i-1].optionId == "cm204" && optionValue[i-1].detailCode == "4"){
								tag += " <select id='cm204_selectbox' style='width:40px;'><option value='3' "+(selectValue.indexOf("|4_3|") != -1 ? "selected" : "")+">3</option><option value='4' "+(selectValue.indexOf("|4_4|") != -1 ? "selected" : "")+">4</option><option value='5' "+(selectValue.indexOf("|4_5|") != -1 ? "selected" : "")+">5</option></select> <%=BizboxAMessage.getMessage("TX000005067","자리")%>";
							}
							
							tag += '</td>';
							tag += '</tr>';
						} else {								// text bar 기능
							// 최소, 최대 예외처리(비밀번호 설정)
							if(optionValue[i-1].optionId == 'cm202') {
								var min = optionValue[i-1].optionValueDisplay.split("|")[0];
								var max = optionValue[i-1].optionValueDisplay.split("|")[1];
								
								tag += '<tr>';
								tag += '<td class="le"><%=BizboxAMessage.getMessage("TX000010842","최소")%> : <input type="text" name="select" id="' + optionValue[i-1].optionId + "_min" + '" value="' + min + '" class="min"></td>';
								tag += '</tr>';
								
								tag += '<tr>';
								tag += '<td class="le"><%=BizboxAMessage.getMessage("TX000002618","최대")%> : <input type="text" name="select" id="' + optionValue[i-1].optionId + "_max" + '" value="' + max + '" class="max"></td>';
								tag += '</tr>';
							} else {
								tag += '<tr>';
								
								if(optionValue[i-1].optionId == 'msg1910') {
									tag += '<td class="le"><input readonly="readonly" type="text" name="select" id="' + optionValue[i-1].optionId + "_" + '" value="' + optionValue[i-1].optionValueDisplay + '">';
									tag += '&nbsp<input type="button" onclick="fnBoardListPop();" value="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" />'
								}else{
									tag += '<td class="le"><input type="text" name="select" id="' + optionValue[i-1].optionId + "_" + '" value="' + optionValue[i-1].optionValueDisplay + '">';
								}
								tag += '</td>';
								tag += '</tr>';	
							}
							
						}
					}
					
					//확장자제한 예외처리 
					if(selectedOptionValueId == "option0207"){
						
						var optionValueStrArray = optionValue[0].optionValueDisplay.split("▦");
						var valArray = optionValueStrArray[1].split("|");
						
						tag += '<tr>';
						
						tag += '<td><input type="text" id="multiTextInput" style="width:99%;text-align:center;" onkeyup="javascript:if(event.keyCode==13){fnAddText(\'ext\'); fnSetExtOptionTextShow(); return false;}" /></td>';
						tag += '</tr>';
						
						tag += '<tr><td>';
						tag += '<ul class="multibox scroll_y_on" id="multiTextInputBox" style="width:99%; height:320px;-ms-overflow-y:scroll;"><div name="extInfoDes" style="text-align: left;margin: 5px;color: #868686;"></div>';
						
						$.each(valArray, function( index, value ) {
							if(value != "")
							tag += '<li>'+value+'<a class="close_btn" onclick="fnRemoveText(this);" href="#"><img src="/gw/Images/ico/close_btn01.png"></a></li>';
						});
						
						tag += '</ul>';
						tag += '</td></tr>';
						
					}
					
					//만료기한 예외처리 
					if(selectedOptionValueId == "option0211"){
						
						var cm201Type = "d";
						var cm201Val1 = "0";
						var cm201Val2 = "0";
						var cm201Val3 = "1";
						var cm201Val4 = "1";
						
						var cm201MonthStyle = "";
						var cm201DayStyle = "";
						
						var optionValueStrArray = optionValue[0].optionValueDisplay.split("▦");
						
						if(optionValueStrArray.length > 1){
							cm201Type = optionValueStrArray[0];
							var valArray = optionValueStrArray[1].split("|");
							
							if(cm201Type == "d"){
								cm201Val1 = valArray[0];
								cm201Val2 = valArray.length > 1 ? valArray[1] : "0";
							}else{
								cm201Val3 = valArray[0];
								cm201Val4 = valArray[1];
							}
							
						}else{
							var valArray = optionValueStrArray[0].split("|");
							
							if(valArray.length > 1){
								cm201Val1 = valArray[0];
								cm201Val2 = valArray[1];
							}else{
								cm201Val2 = valArray[0];
							}
							
						}
						
						if(cm201Type == "d"){
							cm201MonthStyle = ' style="display:none;" ';
						}else{
							cm201DayStyle = ' style="display:none;" ';
						}
						
						tag += '<tr '+cm201DayStyle+' name="cm201Day" ><td class="le">';
						if(cm201Val1 == "0")
							tag += '<input type="text" id="select_val1" value="' + cm201Val1 + '" onblur="onblurCm201Day()"><span id="cm201DaySpan"> <%=BizboxAMessage.getMessage("TX000022796","일 이후 안내")%>(미사용)</<span>';
						else
							tag += '<input type="text" id="select_val1" value="' + cm201Val1 + '" onblur="onblurCm201Day()"><span id="cm201DaySpan"> <%=BizboxAMessage.getMessage("TX000022796","일 이후 안내")%></<span>';
						tag += '</td></tr>';
						tag += '<tr '+cm201DayStyle+' name="cm201Day"><td class="le">';
						tag += '<input type="text" id="select_val2" value="' + cm201Val2 + '"> <%=BizboxAMessage.getMessage("TX000022942","일 이후 만료(종료)")%>';
						tag += '</td></tr>';
						
						tag += '<tr '+cm201MonthStyle+' name="cm201Month" ><td class="le">';
						tag += '<%=BizboxAMessage.getMessage("","매월")%> <select style="width: 80px;" id="select_val3">';
						
						for(var i=1; i < 32; i++) {
							if(i == cm201Val3){
								tag += '<option value="' + i + '" selected>' + i + '</option>';	
							}else{
								tag += '<option value="' + i + '" >' + i + '</option>';
							}
						}
						
						tag += '</select> <%=BizboxAMessage.getMessage("","일 만료(종료)")%>';
						
						tag += '</td></tr>';
						tag += '<tr '+cm201MonthStyle+' name="cm201Month"><td class="le">';
						
						tag += '<select style="width: 80px;" id="select_val4"" onchange="onChangeCm201()">';
						
						tag += '<option value="0" '+(cm201Val4 == "0" ? "selected" : "")+'>0</option>';
						tag += '<option value="1" '+(cm201Val4 == "1" ? "selected" : "")+'>1</option>';
						tag += '<option value="3" '+(cm201Val4 == "3" ? "selected" : "")+'>3</option>';
						tag += '<option value="7" '+(cm201Val4 == "7" ? "selected" : "")+'>7</option>';
						
						if(cm201Val4 == "0")
							tag += '</select><span id="cm201Span"> <%=BizboxAMessage.getMessage("","일 전 안내(미사용)")%></span>';
						else
							tag += '</select><span id="cm201Span"> <%=BizboxAMessage.getMessage("","일 전 안내")%></span>';
							
						tag += '</td></tr>';
						
					}					
					
				}				
				
				$("#optionSettingValue").html(tag);
				
				//확장자제한 예외처리 
				if(selectedOptionValueId == "option0207"){
					fnSetExtOptionText("option0207");
					
					$("#optionSettingValue input:radio").change(function() {
						fnSetExtOptionText("option0207");
					});					
					
				}
				
				//만료기한 예외처리 
				if(selectedOptionValueId == "option0211"){
					
					if(optionValue[0].optionValueDisplay.indexOf("▦") < 0 || optionValue[0].optionValueDisplay.split("▦")[1].split("|").length > 2){
						$("#optionSettingValue [name=cm201Day]").hide();
						$("#optionSettingValue [name=cm201Month]").hide();
						$("#cm201_0").prop("checked", true);
					}					
					
					fnSetExtOptionText("option0211");
					
					$("#optionSettingValue input:radio").change(function() {
						fnSetExtOptionText("option0211");
					});					
					
				}
				
				//erp조직도연동 그룹웨어 초기 비밀번호 설정 한글입력 방지
				if(selectedOptionValueId == "option1140"){
					$("#cm1140_").css("width","99%");
					$("#cm1140_").on("blur keyup", function() {
						$(this).val( $(this).val().replace( /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '' ) );
					});
				}
				
				$("#com701Commbo").kendoComboBox({
					dataSource : [
		            	{type:"분", Value:"m"},
		            	{type:"시간", Value:"h"},
		            	{type:"일", Value:"d"}
		            ],
		            dataTextField : "type",
		            dataValueField : "Value"
				});
				
				
				var cbox = $("#com701Commbo").data("kendoComboBox");
				
				if(cbox != null){
					cbox.select(0);
					
					if(optionValue[0].optionValueDisplay.split('|').length > 1 && optionValue[0].optionValueDisplay.split('|')[1] != ''){
						cbox.value(optionValue[0].optionValueDisplay.split('|')[1]);
					}					
				}
				
				//클라우드형 아이디/비밀번호 설정규칙 필수
				if(buildType == "cloud"){
					
					if(optionId == "cm203"){
						$("#cm203_3").attr("disabled", true);
						$("#cm203_2").attr("disabled", true);
						$("#cm203_1").attr("disabled", true);
					}else if(optionId == "cm204"){
						$("#cm204_0").attr("disabled", true);
						$("#cm204_4").attr("disabled", true);
						$("#cm204_selectbox").attr("disabled", true);
						$("#cm204_6").attr("disabled", true);
					}
					
				}
				
			}, 
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
			}	
		});	
			
	}
	
	function onChangeCm201(){
		if($("#select_val4").val() == "0"){
			$("#cm201Span").html(" <%=BizboxAMessage.getMessage("","일 전 안내(미사용)")%>");
		}else{
			$("#cm201Span").html(" <%=BizboxAMessage.getMessage("","일 전 안내")%>");
		}
	}
	
	function onblurCm201Day(){
		if($("#select_val1").val() == "0")
			$("#cm201DaySpan").html(" <%=BizboxAMessage.getMessage("TX000022796","일 이후 안내")%>(미사용)");
		else
			$("#cm201DaySpan").html(" <%=BizboxAMessage.getMessage("TX000022796","일 이후 안내")%>");
	}
	
	function cm600Click(value){
		if(value == "1"){
			$("#cm600input").show();
		}else{
			$("#cm600input").hide();
		}
	}
	
	function fnSetExtOptionText(optionId){
		
		var extCheckedValue = $("#optionSettingValue input:radio:checked").val();
		
		if(optionId == "option0207"){
			
			if(extCheckedValue == "permit"){
				$("#multiTextInput").attr("placeholder", "<%=BizboxAMessage.getMessage("TX800000678","허용확장자입력")%> + Enter");
				$("#multiTextInputBox div").html("<%=BizboxAMessage.getMessage("TX800000677","허용할 확장자를 필수로 입력해 주세요.")%>");
			}else{
				$("#multiTextInput").attr("placeholder", "<%=BizboxAMessage.getMessage("TX800000679","제한확장자입력")%> + Enter");
				$("#multiTextInputBox div").html("<%=BizboxAMessage.getMessage("TX800000676","입력값이 없는 경우 제한없이 사용할 수 있습니다.")%>");
			}
			
			fnSetExtOptionTextShow();			
		}else if(optionId == "option0211"){
			
			if(extCheckedValue == null){
				$("#optionSettingValue input:radio[value=d]").prop("checked", true);
				extCheckedValue = "d";
			}
			
			if(extCheckedValue == "d"){
				$("#optionSettingValue [name=cm201Month]").hide();
				$("#optionSettingValue [name=cm201Day]").show();
				
			}else if(extCheckedValue == "m"){
				$("#optionSettingValue [name=cm201Day]").hide();
				$("#optionSettingValue [name=cm201Month]").show();
			}else{
				$("#optionSettingValue [name=cm201Day]").hide();
				$("#optionSettingValue [name=cm201Month]").hide();
			}
		}
	}
	
	function fnSetExtOptionTextShow(){
		
		if($("#multiTextInputBox div[name=extInfoDes]").length > 0){
			
			if($("#multiTextInputBox li").length == 0){
				$("#multiTextInputBox div[name=extInfoDes]").show();
			}else{
				$("#multiTextInputBox div[name=extInfoDes]").hide();
			}
		}
		
	}
	
	function fnAddText(inputType){
		var inputText = $("#multiTextInput").val().split(" ").join("");
		
		if(inputType == "ext"){
			inputText = inputText.toLowerCase();
			inputText = inputText.replace(new RegExp("\\.", "g"), "");
		}

		if(inputText != ""){
			
			var overlapCheck = true;
			
			$.each($("#multiTextInputBox li"), function( index, value ) {
				if(inputText == $(value).text()){
					alert("<%=BizboxAMessage.getMessage("TX000012923","중복 데이터 있음")%>" + "["+$(value).text()+"]");
					overlapCheck = false;
					return false;
				}
			});
			
			if(overlapCheck){
				$("#multiTextInputBox").append('<li>'+inputText+'<a class="close_btn" onclick="fnRemoveText(this);" href="#"><img src="/gw/Images/ico/close_btn01.png"></a></li>');
				$("#multiTextInput").val("");				
			}
		}

	}
	
	function fnRemoveText(obj){
		$(obj).parent().remove();
		
		fnSetExtOptionTextShow();
	}	
	
	// 저장 버튼
	function fnSave() {
		var param = {};
		var optionValue = '';
		var saveFlag = true;
		var alertFlag = true;
		var tmpValue = '';
		var min = '';
		var max = '';
		
		if(optionId == "cm1140"){
			
			optionValue = $("#cm1140_").val();	
			
			if(optionValue == "" || optionValue == "undefinded" || optionValue == null) {
				alert("<%=BizboxAMessage.getMessage("","데이터를 입력해주세요.")%>");
				return;
			}
		
		}
		
		if(optionId == "cm101") {
			
			optionValue = $("#select_val0").val();
			tmpValue = "0";
			if(optionValue != "0" && $("[name=select_val1]:checked").val() == "1"){
				
				if(!isNumber($("#select_val2").val())){	
					alert("<%=BizboxAMessage.getMessage("TX000001996","숫자만 입력 가능합니다.")%>");
					$("#select_val2").focus();
					return;
				}else{
					tmpValue = $("#select_val2").val();
				}
			}
			
			optionValue += "|" + tmpValue;
			
		}else if(optionId == "cm101_1" || optionId == "cm102") {
			
			optionValue = $("#select_val0").val();
			
			if(!isNumber(optionValue)){	
				alert("<%=BizboxAMessage.getMessage("TX000001996","숫자만 입력 가능합니다.")%>");
				$("#select_val0").focus();
				return;
			}
			
		}else if(optionId == "cm205" || optionId == "cm206") {
			
			$.each($("#multiTextInputBox li"), function( index, value ) {
				optionValue += (index == 0 ? "" : "|") + $(value).text();
			});
			
		}if(optionId == "com701") {
			if($("[name=selectCom701]:checked").val() == "1"){
				if($("#com701_").val() == ""){
					alert("<%=BizboxAMessage.getMessage("","데이터를 입력해주세요.")%>");
					return;
				}
				if(isNaN($("#com701_").val())){
					alert("<%=BizboxAMessage.getMessage("","숫자만 입력 가능합니다.")%>");
					return;
				}
				
				var max = 0;
				if($("#com701Commbo").val() == "m"){
					max = 60;	
				}else if($("#com701Commbo").val() == "h"){
					max = 24;
				}else if($("#com701Commbo").val() == "d"){
					max = 90;
				} 
				
				if($("#com701_").val() < 1 || $("#com701_").val() > max){
					alert("<%=BizboxAMessage.getMessage("","0 또는 최대 입력값이 초과되었습니다.")%>");
					return;
				}
				
				
				optionValue = $("#com701_").val() + "|" + $("#com701Commbo").val();
			}else{
				optionValue = $("[name=selectCom701]:checked").val();
			}			
		}if(optionId == "cm600") {
			if($("[name=selectcm600]:checked").val() == "1"){
				if(isNaN($("#txtcm600").val())){
					alert("<%=BizboxAMessage.getMessage("","숫자만 입력 가능합니다.")%>");
					return;
				}
				if($("#txtcm600").val() == ""){
					alert("<%=BizboxAMessage.getMessage("","데이터를 입력해주세요.")%>");
					return;
				}
				if($("#txtcm600").val() < 0 || $("#txtcm600").val() > 100){
					alert("<%=BizboxAMessage.getMessage("","데이터를 확인해주세요.(최소값:0, 최대값:100)")%>");
					return;
				}
			}
			
			if($("[name=selectcm600]:checked").val() == "1"){
				optionValue = $("[name=selectcm600]:checked").val() + "▦" + $("#txtcm600").val();
			}else{
				optionValue = $("[name=selectcm600]:checked").val() + "▦" + "";
			}
						
		}else{
		
			$("input[name=select]").each(function(){

				if($(this).is(":checked")) {
					if(gubunType == "single") {
						
						if(optionId == "cm1100" && ($(this).attr("value") == "1")) {				// erp 연동 셋팅 예외처리
							if(erpSyncResult == "C") {
								saveFlag = false;
								alert("<%=BizboxAMessage.getMessage("TX000022944","회사정보관리에서 ERP 연동 설정을 먼저 해야합니다.")%>");
							} else if(erpSyncResult == "Y") {
								saveFlag = true;
								
							} else if(erpSyncResult == "N") {
								saveFlag = false;
								
								var msg = "<%=BizboxAMessage.getMessage("TX900000077","다른 회사에서 ERP 조직도 연동을 사용 중입니다.")%>\n";
								msg += "<%=BizboxAMessage.getMessage("TX900000078", "동일 ERP DB 사용 시 중복 설정 할 수 없습니다.")%>\n";
								msg += "[<%=BizboxAMessage.getMessage("TX000022946","사용중인 회사명")%> : "+ useCompInfo +"]";
								
								alert(msg);
							}
						}
						
						if(optionId == "cm200" && ($(this).attr("value") == "0")) {
							
							if(selectedOptionValueOld == "0"){
								alert("<%=BizboxAMessage.getMessage("TX000004299","변경된 값이 없습니다.")%>");
								saveFlag = false;
								return false;
							}
							
							var msg = "<%=BizboxAMessage.getMessage("TX900000079","비밀번호 설정 규칙 옵션 미사용시, 계정 탈취,")%>\n";
							msg += "<%=BizboxAMessage.getMessage("TX900000080","비밀번호 도용 등 보안상 문제가 발생 될 수 있습니다.")%>\n";
							msg += "<%=BizboxAMessage.getMessage("TX900000081","그래도 설정 규칙 옵션을 미사용으로 변경 하시겠습니까?")%>\n";
							
							if(!confirm(msg)) {
								saveFlag = false;
								return false;
							}
						}
						
						optionValue = $(this).attr("value");
					} else if(gubunType == "multi") {
						optionValue += $(this).attr("value") + "|";
					}
				} else {
					if(gubunType == "text") {					
						// 최소,최대 예외처리(비밀번호설정)
						if(optionId == "cm202") {
							
							if($(this).attr("class") == "min") {
								
								min = $(this).val();
								
								var minSet = 6;
								
								if(min < minSet) {
									alertFlag = false;
									alert("<%=BizboxAMessage.getMessage("TX000010841","최소 입력은 {0}자리 이상입니다")%>".replace("{0}",minSet));
									$(this).focus();
									saveFlag = false;
								} else if(min > 16){
									alertFlag = false;
									alert("<%=BizboxAMessage.getMessage("TX000010840","최대 입력은 {0}자리 이하입니다")%>".replace("{0}","16"));
									$(this).focus();
									saveFlag = false;
								} else {
									optionValue = min + "|";
								}
								
							} else {
								max = $(this).val();
								
								if(max == "0" || max =="") {
									if($(this).val() == "") {
										optionValue += "0";
									} else {
										optionValue += max;
									}
								} else if(max > 16) {
									alertFlag = false;
									alert("<%=BizboxAMessage.getMessage("TX000010840","최대 입력은 {0}자리 이하입니다")%>".replace("{0}","16"));
									$(this).focus();
									saveFlag = false;
								} else if(max < 4) {
									alertFlag = false;
									alert("<%=BizboxAMessage.getMessage("TX000010841","최소 입력은 {0}자리 이상입니다")%>".replace("{0}","4"));
									$(this).focus();
									saveFlag = false;
								} else {
									optionValue += max;
								}
							}
						}else {
							optionValue = $(this).val();	
							
							if(optionValue == "" || optionValue == "undefinded" || optionValue == null) {
								optionValue = "0";
							}
								
						}
						

						
						
						//쪽지/대화 자동삭제 일수
						if(optionId == "com101" || optionId == "com201") {
							optionValue = $(this).val();
							var msg = "<%=BizboxAMessage.getMessage("TX900000084","보관기간 설정 변경 시, 변경시점부터 적용됩니다.")%>\n";
							msg += "<%=BizboxAMessage.getMessage("TX900000085","변경하시겠습니까?")%>";
							if(!isNumber(optionValue)){	
								alert("<%=BizboxAMessage.getMessage("TX000001996","숫자만 입력 가능합니다.")%>");
								saveFlag = false;
								$(this).focus();
							}else if(optionValue < 30 || optionValue > 1095){
								alert("<%=BizboxAMessage.getMessage("TX900000086","보관기간은 [최소 30일 / 최대 1095일]까지 설정할 수 있습니다.")%>")
								saveFlag = false;
								$(this).focus();
							}else if(!confirm(msg)){
								saveFlag = false;
							}
						}
					}
				}			
			});
			
			//확장자제한 예외처리 
			if(selectedOptionValueId == "option0207"){
				
				if($("#multiTextInputBox li").length > 100){
					puddAlert("<%=BizboxAMessage.getMessage("","등록 가능한 최대 개수는 100개 입니다.")%>");
					return;
				}
				
				optionValue += "▦";
				
				$.each($("#multiTextInputBox li"), function( index, value ) {
					optionValue += (index == 0 ? "" : "|") + $(value).text();
				});
				
				if(optionValue == "permit▦"){
					puddAlert("<%=BizboxAMessage.getMessage("","허용할 확장자를 입력해주세요.")%>");
					return;
				}
				
			}
			
			//만료기한 예외처리 
			if(selectedOptionValueId == "option0211"){
				
				if(optionValue == "d"){
					
					if(!isNumber($("#select_val1").val())){	
						alert("<%=BizboxAMessage.getMessage("TX000001996","숫자만 입력 가능합니다.")%>");
						$("#select_val0").focus();
						return;
					}
					
					if(!isNumber($("#select_val2").val())){	
						alert("<%=BizboxAMessage.getMessage("TX000001996","숫자만 입력 가능합니다.")%>");
						$("#select_val1").focus();
						return;
					}
					
					if($("#select_val2").val() == "0"){
						alert("<%=BizboxAMessage.getMessage("","1일 이상만 입력이 가능합니다.")%>");
						$("#select_val2").focus();
						return;
					}
					
					if(($("#select_val1").val() == $("#select_val2").val() && $("#select_val1").val() != "0") || (parseInt($("#select_val1").val()) > parseInt($("#select_val2").val()))){	
						alert("<%=BizboxAMessage.getMessage("","안내 기준일자가 만료 기준일자보다 크거나 같을 수 없습니다.")%>");
						$("#select_val1").focus();
						return;
					}
					
					optionValue = "d▦" + $("#select_val1").val() + "|" + $("#select_val2").val();
					
				}else if(optionValue == "m"){
					optionValue = "m▦" + $("#select_val3").val() + "|" + $("#select_val4").val();
				}else{
					optionValue = "d▦0|0|0" //미사용처리
				}
				
			}			
			
			//연속반복 문자(숫자)자리수설정 예외처리
			if(optionId == "cm204" && optionValue.indexOf("4|") != -1){
				optionValue += "4_" + $("#cm204_selectbox").val() + "|";
			}
			
			// 멀티 선택 시 아무것도 선택 안할 경우
			if(gubunType == "multi") {		
				if(optionValue == '') {
					optionValue = '999';
				}
			}
			
			if(max != "0") {
				
				min = parseInt(min);
				max = parseInt(max);
				
				if(min > max) {
					alert("<%=BizboxAMessage.getMessage("TX000010839","최소값이 최대값보다 큽니다")%>");
					saveFlag = false;
					return;
				}
			}
		}
		
		if(selectedOptionValueOld == optionValue){
			alert("<%=BizboxAMessage.getMessage("TX000004299","변경된 값이 없습니다.")%>");
			return;
		}
		
		if(alertFlag == true && (optionId == "cm201" || optionId == "cm202" || optionId == "cm203" || optionId == "cm204" || optionId == "cm205" || optionId == "cm206")) {
			alertFlag = false;
			var msg = "<%=BizboxAMessage.getMessage("TX900000082","옵션 설정 값 변경시, 변경 시점부터 사용자에게 반영 됩니다.")%>\n";
			msg += "<%=BizboxAMessage.getMessage("TX900000083","사용자 재 로그인 시 확인 가능 합니다.")%>\n";
			alert(msg);	
		}		
		
		param.optionId = optionId;
		param.compSeq = $("#company").val();
		
		param.optionValue = optionValue;
		
		if($("#company").val() == "0") {
			param.gubun = "1";
		} else {
			param.gubun = "2";
			
			// 회사 선택 시 구분 값 비활성화
			gubunCombobox.select(0);
			gubunCombobox.enable(false);
		}
		
		param.type = $("#division").val();
		
		if(saveFlag) {
			$.ajax({
				type : "post",
				url  : "<c:url value='/cmm/system/CommonOptionSave.do'/>",
				dataType : "json",
				data : param,
				async : false,
				success : function(result) {					
					alert("<%=BizboxAMessage.getMessage("TX000022951","변경 되었습니다.")%>");
					
					// 새로그림
					if($("#optionList #"+optionId+".sub").length > 0){
						fnRefreshOptionData(optionId);
					}else{
						fnGetOptionData();
						// 우측 테이블 초기화
						$("#optionSettingValue").html("");						
					}
					
				}, 
				error : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
				}	
			});	
		}
	}
	
	function isNumber(s) {
		  s += ''; // 문자열로 변환
		  s = s.replace(/^\s*|\s*$/g, ''); // 좌우 공백 제거
		  if (s == '' || isNaN(s)) return false;
		  return true;
	}
	
	function puddAlert(alertMsg){
		var puddDialog = Pudd.puddDialog({
			width : "400"
		,	height : "100"
		,	message : {
				type : "warning"
			,	content : alertMsg.replace(/\n/g, "<br>")
			}
		});		
	}
	
	function com701Click(e){
		if(e == "0"){
			$("#com701_addOption").hide();
		}else if(e == "1"){
			$("#com701_addOption").show();
		}
	}
</script>

<div class="sub_contents_wrap">
	<div class="top_box">
		<dl>
			<dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
			<dd>
				<input id="company" />
			</dd>
			<dt><%=BizboxAMessage.getMessage("TX000000214","구분")%></dt>
			<dd>
				<input  id="division" style="width:100px;"/>
			</dd>
		</dl>
	</div>
	<div class="btn_div">
		<div class="left_div">
			<p class="tit_p m0 mt5"><%=BizboxAMessage.getMessage("TX000016169","옵션목록")%></p>
		</div>

		<div class="right_div">
			<div id="" class="controll_btn" style="padding: 0px;">
				<button id="saveButton" style="display:none;" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
			</div>
		</div>
	</div>

	<div class="twinbox">
		<table style="min-height: auto;">
			<colgroup>
				<col>
				<col width="30%">
			</colgroup>
			<tbody>
				<tr>
					<!-- 왼쪽 -->
					<td class="twinbox_td" id="optionTable">
						<!-- 테이블 -->
						<div class="com_ta2">
							<table>
								<colgroup>
									<col width="" />
									<col width="217" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000006673","옵션")%></th>
									<th><%=BizboxAMessage.getMessage("TX000000217","설정값")%></th>
								</tr>
							</table>
						</div>

						<div class="op_ta ova_sc bg_lightgray"
							style="height: 380px; overflow: hidden; overflow-y: scroll;">
							<table>
								<colgroup>
									<col width="" />
									<col width="200" />
								</colgroup>
								<tbody id="optionList">
									<!-- 그룹 :: 공통 -->
									<tr>
										<td class="le p_list"><span class="ml20"><%=BizboxAMessage.getMessage("TX000010059","로그인/로그아웃")%>
												<%=BizboxAMessage.getMessage("TX000016099","통제")%></span></td>
										<td class="le"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></td>
									</tr>
									<tr class="op_sub">
										<td class="p0 brn" colspan="2">
											<table>
												<colgroup>
													<col width="" />
													<col width="200" />
												</colgroup>
												<tr>
													<td class="le op_list"><span class="ml40"><%=BizboxAMessage.getMessage("TX000010838","로그인 실패")%>
															<%=BizboxAMessage.getMessage("TX000006520","설정")%></span></td>
													<td class="le">0</td>
												</tr>
												<tr>
													<td class="le op_list"><span class="ml40"><%=BizboxAMessage.getMessage("TX000010837","강제")%>
															<%=BizboxAMessage.getMessage("TX000016319","로그아웃 시간설정")%></span></td>
													<td class="le">0</td>
												</tr>
											</table>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</td>

					<!-- 오른쪽 -->
					<td class="twinbox_td">
						<!-- 테이블 -->
						<div class="com_ta2">
							<table>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000016196","설정값 상세")%></th>
								</tr>
							</table>
						</div>

						<div class="com_ta2 op_ta ova_sc bg_lightgray"
							style="height: 380px; overflow: hidden; overflow-y: auto;">
							<table>
								<tbody id="optionSettingValue"></tbody>
							</table>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- 테이블 -->
	<div class="com_ta mt14">
		<table>
			<colgroup>
				<col width="120" />
				<col width="" />
			</colgroup>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000016168","옵션설명")%></th>
				<td><textarea id="optionDetail" style="width: 98%; height: 50px; padding: 10px;" readonly="readonly"></textarea>
				</td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000006697","관련 옵션 설명")%></th>
				<td><textarea id="addOptionDetail" style="width: 98%; height: 50px; padding: 10px;"></textarea>
				</td>
			</tr>
		</table>
	</div>

</div>
<!-- //sub_contents_wrap -->
