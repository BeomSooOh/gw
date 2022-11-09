<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href= '/gw/js/pudd/css/pudd.css' />
<script type="text/javascript" src= '/gw/js/pudd/js/pudd-1.1.23.min.js'></script>

<script type="text/javascript">
	var j=0;
	var userSe = "${userSe}";
	var comboBoxFlag = true;	// 콤보박스 첫번째 데이터를 위한 플래그변수 (마스터) - 초기
	var masterFlag = true;		// 마스터 셋팅 정보 가져오기	- 초기 
	var initCompSeq = '';			// 콤보박스 첫번째 데이터를 위한 변수 (마스터)
	var masterResult = '';
	var alarmInfo = '';
	var compLists = ${compListJson};
	var menuList = ${alarmMenuListJson};
	
	$(document).ready(function(){
		// 초기 리스트 호출
		fnInit();
		
		// 셀렉 박스 항목 가져오기
		fnMenuList();
		
		// 버튼 이벤트 등록
		fnButtonInit();
		
		// 전체 선택 
		fnAllCheck();
		
		// 드랍 버튼 이벤트
		fnDropEvent();
		

	});

	
	// 초기 리스트 호출
	function fnInit() {
		// 알림 항목 테이블 보이기
		$(".alarm_ta_in").show();

		// 알림 항목 가져오기
		if(userSe != "MASTER") {
			fnSetDetailAlarmMaster();
		}

		// master 호출 시 회사 리스트 노출
		if(userSe == "MASTER") {
			fnCompSelect();
		}
	}
	
	// master 계정일 경우 회사 select box 
	function fnCompSelect() {
		
		$("#compTitle").show();
		$("#compSelectBox").show();
		
		
		initCompSeq = compLists[0].compSeq;
		
		// Pudd DataSource 매핑
		var dataSourceComboBox = new Pudd.Data.DataSource({
			data : compLists
		});		
		
		Pudd( "#comp_sel" ).puddComboBox({
			 
			attributes : { style : "width:250px;" }// control 부모 객체 속성 설정
		,	controlAttributes : {}// control 자체 객체 속성 설정
		,	dataSource : dataSourceComboBox
		,	dataValueField : "compSeq"
		,	dataTextField : "compName"
		,	selectedIndex : 0
		,	disabled : false
		,	scrollListHide : false
		});
		
		
		// change
		var puddObj = Pudd( "#comp_sel" ).getPuddObject();
		puddObj.on( "change", function( e ) {
			fnSetDetailAlarmMaster();
		});
		
		if(comboBoxFlag){
			fnSetDetailAlarmMaster();	
		}
	}
	
	// 회사 선택 시 알림 세부사항 가져오기
	function fnSetDetailAlarmMaster() {
		var param = {};
		
		// 마스터 일 경우 회사 선택 경우
		if(userSe == "MASTER") {
			if(comboBoxFlag) {
				param.compSeq = initCompSeq;
				comboBoxFlag = false;
			} else {
				param.compSeq = Pudd( "#comp_sel" ).getPuddObject().val();
			}	
		}
		
		$.ajax({
			type: "POST"
			, url: "getAlarmDetailList.do"
			, data: param
			, dataType : "json"
			, success: function(result) {
				//alert(JSON.stringify(result));
				if(result != null) {
					alarmInfo = result.alarmMenuListDetailJson;	
					fnMenuItemList();
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000010814","데이터가 존재하지 않습니다. 관리자에게 문의 부탁드립니다.")%>");
				}
				
				//alert(JSON.stringify(alarmInfo));
			}
			, error: function(result) {
				
			}
		});
		
	}

	
	// 셀렉 박스 항목 가져오기
	function fnMenuList() {
		
		$.each(menuList, function( index, value ) {
			
			switch(value.flag1){
				case "COMMON" : value.flag2 = "<%=BizboxAMessage.getMessage("TX800000680","공통/시스템설정")%>"; break;
				case "PROJECT" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>"; break;
				case "EAPPROVAL" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>"; break;
				case "BOARD" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000011134","게시판")%>"; break;
				case "EDMS" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000008627","문서")%>"; break;
				case "EXTEND" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000010113","확장기능")%>"; break;
				case "ATTEND" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000011135","근태관리")%>"; break;
				case "MAIL" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000000262","메일")%>"; break;
				case "SCHEDULE" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000005550","일정관리")%>"; break;
				case "RESOURCE" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000007392","자원관리")%>"; break;
				case "MENTION" : value.flag2 = "<%=BizboxAMessage.getMessage("TX000021504","알파멘션")%>"; break;
			}
			
		});
		
		// Pudd DataSource 매핑
		var dataSourceComboBox = new Pudd.Data.DataSource({
			data : menuList
		});		
		
		Pudd( "#alarm_sel" ).puddComboBox({
			 
			attributes : { style : "width:250px;" }// control 부모 객체 속성 설정
		,	controlAttributes : {}// control 자체 객체 속성 설정
		,	dataSource : dataSourceComboBox
		,	dataValueField : "flag1"
		,	dataTextField : "flag2"
		,	selectedIndex : 0
		,	disabled : false
		,	scrollListHide : false
		});
		
		// change
		var puddObj = Pudd( "#alarm_sel" ).getPuddObject();
		puddObj.on( "change", function( e ) {
			menuSelChange();
		});		
		
		$("#ALL").remove();
		$("#select_ALL").parent().closest("tr").remove();
	}
	

	// 셀렉 박스 변경 이벤트
	function menuSelChange() {
		var code = Pudd( "#alarm_sel" ).getPuddObject().val();
		
		// 모든 항목 테이블 숨기기
		$(".alarm_ta_in").hide();
				
		// 전체 선택시 예외 처리
		if(code == "ALL") {
			$(".alarm_ta table th a").attr("class", "al_up");
			
			$(".alarm_ta_in").show();
		} else {
		
			$(".alarm_ta table th a").attr("class", "al_down");
			$("#drop_" + code).attr("class", "al_up");
			// 선택된 항목 테이블 보이기
			$("#select_" + code).show(); 
			
		}
	}
	
	var menuGubun = '';
	var alertChk_ = 0,pushChk_ = 0,talkChk_ = 0,mailChk_ = 0,smsChk_ = 0,portalChk_ = 0;
	var alertUnChk_ = 0,pushUnChk_ = 0,talkUnChk_ = 0,mailUnChk_ = 0,smsUnChk_ = 0,portalUnChk_ = 0;	
	
	// 메뉴에 따른 알림 항목 가져오기
	function fnMenuItemList() {
		// 알림 항목 가져오기
		
		var alertType = '';
		var tag = '';
		var lastIndex = alarmInfo.length;
		var checkInfo = '';
		
		// 알림항목 초기화
		$("#allTable tr.item").remove();
		 
		for(var i=0; i<alarmInfo.length; i++) {
			
			if(menuGubun != "" && menuGubun != alarmInfo[i].flag1){
				fnCheckBox();
				alertChk_ = 0,pushChk_ = 0,talkChk_ = 0,mailChk_ = 0,smsChk_ = 0,portalChk_ = 0;
				alertUnChk_ = 0,pushUnChk_ = 0,talkUnChk_ = 0,mailUnChk_ = 0,smsUnChk_ = 0,portalUnChk_ = 0;
			}
			
			menuGubun = alarmInfo[i].flag1;
			alertType = alarmInfo[i].alertType;
			
			tag = '<tr class="item" id="' + alarmInfo[i].alertType + '" value="' + alarmInfo[i].detailName + '" note="' + alarmInfo[i].note + '">';
			tag += '<td class="le"><a href="#n" onclick="fnAlarmInfo($(this))">' + alarmInfo[i].detailName + '</a></td>';
			
			if(alarmInfo[i].masterAlert == "N" || alarmInfo[i].adminAlert == "B"){
				checkInfo = 'disabled';
			}else if(alarmInfo[i].adminAlert == "Y"){
				checkInfo = 'checked';
				alertChk_++;
			}else{
				checkInfo = '';
				alertUnChk_++;
			}
			
			tag += '<td><input type="checkbox" onclick="fnCheckBoxClick($(this))" name="alertChk_' + menuGubun  + '"  value="' + alarmInfo[i].adminAlert + '" id=alert_' + alertType + ' class="" ' + checkInfo + ' /></td>';
			
			if(alarmInfo[i].masterPush == "N" || alarmInfo[i].adminPush == "B"){
				checkInfo = 'disabled';
			}else if(alarmInfo[i].adminPush == "Y"){
				checkInfo = 'checked';
				pushChk_++;
			}else{
				checkInfo = '';
				pushUnChk_++;
			}
			
			tag += '<td><input type="checkbox" onclick="fnCheckBoxClick($(this))" name="pushChk_' + menuGubun  + '" value="' + alarmInfo[i].adminPush + '" id=push_' + alertType + ' class="" ' + checkInfo + ' /></td>';
			
			if(alarmInfo[i].masterTalk == "N" || alarmInfo[i].adminTalk == "B"){
				checkInfo = 'disabled';
			}else if(alarmInfo[i].adminTalk == "Y"){
				checkInfo = 'checked';
				talkChk_++;
			}else{
				checkInfo = '';
				talkUnChk_++;
			}
			
			tag += '<td><input type="checkbox" onclick="fnCheckBoxClick($(this))" name="talkChk_' + menuGubun  + '" value="' + alarmInfo[i].adminTalk + '" id=talk_' + alertType + ' class="" ' + checkInfo + ' /></td>';
			
			if(alarmInfo[i].masterMail == "N" || alarmInfo[i].adminMail == "B"){
				checkInfo = 'disabled';
			}else if(alarmInfo[i].adminMail == "Y"){
				checkInfo = 'checked';
				mailChk_++;
			}else{
				checkInfo = '';
				mailUnChk_++;
			}			
			tag += '<td><input type="checkbox" onclick="fnCheckBoxClick($(this))" name="mailChk_' + menuGubun  + '" value="' + alarmInfo[i].adminMail + '" id=mail_' + alertType + ' class="" ' + checkInfo + ' /></td>';
			
			if(alarmInfo[i].masterSms == "N" || alarmInfo[i].adminSms == "B"){
				checkInfo = 'disabled';
			}else if(alarmInfo[i].adminSms == "Y"){
				checkInfo = 'checked';
				smsChk_++;
			}else{
				checkInfo = '';
				smsUnChk_++;
			}
			
			tag += '<td style="display:none;"><input type="checkbox" onclick="fnCheckBoxClick($(this))" name="smsChk_' + menuGubun  + '" value="' + alarmInfo[i].adminSms + '" id=sms_' + alertType + ' class="" ' + checkInfo + ' /></td>';
			
			if(alarmInfo[i].masterPortal == "N" || alarmInfo[i].adminPortal == "B"){
				checkInfo = 'disabled';
			}else if(alarmInfo[i].adminPortal == "Y"){
				checkInfo = 'checked';
				portalChk_++;
			}else{
				checkInfo = '';
				portalUnChk_++;
			}
			
			tag += '<td><input type="checkbox" onclick="fnCheckBoxClick($(this))" name="portalChk_' + menuGubun  + '" value="' + alarmInfo[i].adminPortal + '" id=portal_' + alertType + ' class="" ' + checkInfo + ' /></td>';
			tag += '</tr>';
			$("." + menuGubun + "_item").append(tag);

		}
		
		fnCheckBox();
	}
	
	// 체크박스 체크
	function fnCheckBox() {
		
		if(alertChk_ == 0 && alertUnChk_ == 0){
			//disabled
			$("#allAlert_" + menuGubun).attr("disabled", true);
		}else if (alertUnChk_ == 0){
			//allChecked
			$("#allAlert_" + menuGubun).prop("checked", true);
		}
		
		if(pushChk_ == 0 && pushUnChk_ == 0){
			//disabled
			$("#allPush_" + menuGubun).attr("disabled", true);
		}else if (pushUnChk_ == 0){
			//allChecked
			$("#allPush_" + menuGubun).prop("checked", true);
		}		
		
		if(talkChk_ == 0 && talkUnChk_ == 0){
			//disabled
			$("#allTalk_" + menuGubun).attr("disabled", true);
		}else if (talkUnChk_ == 0){
			//allChecked
			$("#allTalk_" + menuGubun).prop("checked", true);
		}	
		
		if(mailChk_ == 0 && mailUnChk_ == 0){
			//disabled
			$("#allMail_" + menuGubun).attr("disabled", true);
		}else if (mailUnChk_ == 0){
			//allChecked
			$("#allMail_" + menuGubun).prop("checked", true);
		}		
		
		if(smsChk_ == 0 && smsUnChk_ == 0){
			//disabled
			$("#allSms_" + menuGubun).attr("disabled", true);
		}else if (smsUnChk_ == 0){
			//allChecked
			$("#allSms_" + menuGubun).prop("checked", true);
		}		
		
		if(portalChk_ == 0 && portalUnChk_ == 0){
			//disabled
			$("#allPortal_" + menuGubun).attr("disabled", true);
		}else if (portalUnChk_ == 0){
			//allChecked
			$("#allPortal_" + menuGubun).prop("checked", true);
		}			
	}	
	
	// 알림 설명
	function fnAlarmInfo(e) {
		var menuCode = e.parent().closest("tr").attr("id");
		var explain = e.parent().closest("tr").attr("note");
		
		$(".item").removeClass("on");
		$("#" + menuCode).addClass("on");
		
		$("#detail").html(explain);
	}
	
	// 버튼 이벤트
	function fnButtonInit() {
		// 저장 버튼 이벤트
		$("#saveAlarmDetail").click(function(){
			fnSaveAlarmDetail();
		});
	}
	
	// 드랍다운 버튼 이벤트
	function fnDropEvent() {
		$(".al_down").parent().parent().next("tr").children().find(".alarm_ta_in").hide();
		
		$(".alarm_ta table th div a").click(
			function() {

				if ($(this).hasClass("al_down")) {
					$(this).removeClass("al_down");
					$(this).addClass("al_up");
					$(this).parent().parent().parent().next("tr").children()
							.find(".alarm_ta_in").slideDown();
					
				} else {

					$(this).removeClass("al_up");
					$(this).addClass("al_down");
					$(this).parent().parent().parent().next("tr").children()
							.find(".alarm_ta_in").slideUp();
				}
			});	
	} 
		
	// 항목별 전체 클릭
	function fnAllCheck() {
		
		var menu = ["Alert", "Push", "Talk", "Mail", "Sms", "Portal", "Timeline"];
		
		 for(var i = 0; i<menu.length; i++) {
			$("input[name=all" + menu[i] + "]").each(function(){
				var small = menu[i].toLowerCase();
				$(this).click(function(){
					var id = $(this).attr('id');
					
					var idIndex = id.indexOf("_");
					var gubun = id.substring((idIndex+1), id.length);
					
					if($(this).is(":checked")) {
						$("input[name=" + small + "Chk_" + gubun + "]:enabled").prop("checked", true);	
					} else {
						$("input[name=" + small + "Chk_" + gubun + "]:enabled").prop("checked", false);
					}
					
				});
			}); 
		}
	}

	// 선택된 항목 저장 및 수정
	function fnSaveAlarmDetail() {

		var alarmSetting = new Array();
	
		
		for(var i=0; i<alarmInfo.length; i++) {
			var alarmParam = {};
			
			alarmParam.alertType = alarmInfo[i].alertType;
			alarmParam.alert_yn = $("#alert_" + alarmInfo[i].alertType).val() != "B" ? ($("#alert_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.push_yn = $("#push_" + alarmInfo[i].alertType).val() != "B" ? ($("#push_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.talk_yn = $("#talk_" + alarmInfo[i].alertType).val() != "B" ? ($("#talk_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.mail_yn = $("#mail_" + alarmInfo[i].alertType).val() != "B" ? ($("#mail_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.sms_yn = $("#sms_" + alarmInfo[i].alertType).val() != "B" ? ($("#sms_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.portal_yn = $("#portal_" + alarmInfo[i].alertType).val() != "B" ? ($("#portal_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.timeline_yn = $("#portal_" + alarmInfo[i].alertType).val() != "B" ? ($("#portal_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			
			if(userSe == "MASTER") {
				alarmParam.compSeq = Pudd( "#comp_sel" ).getPuddObject().val();
			}
			alarmSetting.push(alarmParam);

		}		
				
		// 정상 코드
 		$.ajax({
			type: "POST"
			, url: "alarmDetailUpdate.do"
			, dataType: "json"
			, data: {paramMap : JSON.stringify(alarmSetting)}
			, success: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010811","알림이 저장되었습니다")%>");
			}
			, error: function(result) {
				
			}
		}); 
	}
	
	// 체크박스 클릭 이벤트
	function fnCheckBoxClick(data) {
		var checkBoxId = $(data).attr("id");
		var alarmGubun = initCap(checkBoxId.split("_")[0]);
		var alarmParamGubun = checkBoxId.split("_")[0];
		var menuGubun = "";
		
		if(checkBoxId.indexOf("SC") > -1 || checkBoxId.indexOf("RP") > -1) {	// 일정		
			menuGubun = "SCHEDULE";
		} else if(checkBoxId.indexOf("PR") > -1) {		// 업무
			menuGubun = "PROJECT";
		} else if(checkBoxId.indexOf("EA") > -1) {		// 결재
			menuGubun = "EAPPROVAL";
		} else if(checkBoxId.indexOf("BO") > -1) {		// 게시판			
			menuGubun = "BOARD";
		} else if(checkBoxId.indexOf("ED") > -1) {		// 문서관리
			menuGubun = "EDMS";
		} else if(checkBoxId.indexOf("EX") > -1) {		// 확장기능
			menuGubun = "EXTEND";
		} else if(checkBoxId.indexOf("MA") > -1) {		// 메일
			menuGubun = "MAIL";
		} else if(checkBoxId.indexOf("RS") > -1) {		// 자원
			menuGubun = "RESOURCE";
		} else if(checkBoxId.indexOf("WO") > -1) {		// 근태
			menuGubun = "WORK";
		} else if(checkBoxId.indexOf("MT") > -1) {		// 알파멘션
			menuGubun = "MENTION";
		}else if(checkBoxId.indexOf("GW") > -1) {		// 공통 시스템설정
			menuGubun = "COMMON";
		}
		
		if(!$(data).is(":checked")) {
			$("#all" + alarmGubun + "_" + menuGubun).attr("checked", false);
		}
		
		// 항목 전체 클릭 시 전체 선택
		fnAllCheckBox(alarmParamGubun, menuGubun);
	}
	
	// 항목 전체 클릭 시 전체 선택 
	function fnAllCheckBox(alarmParamGubun, menuGubun) {
		var check = 0;
		var alarmGubun = initCap(alarmParamGubun);
		
		$("input:checkbox[name='" + alarmParamGubun + "Chk_" + menuGubun + "']").each(function(){
			//alert($(this).val());
			
			if($(this).val() != "B") {
				if(!$(this).is(":checked")) {
					check++;
				}	
			}
			
		});
		//alert(check);
		if(check==0) {
			$("#all" + alarmGubun + "_" + menuGubun).prop("checked", true);
		} else {
			$("#all" + alarmGubun + "_" + menuGubun).prop("checked", false);
		}
	}
	
	// 맨앞글씨 대문자 처리
	 function initCap(str) {
		 var str = str.substring(0, 1).toUpperCase() + str.substring(1, str.length).toLowerCase();
		 return str;
	 }
</script>

<div class="sub_contents_wrap" style="">

	<div class="top_box">
		<dl class="dl1">
			<dt id="compTitle" style="display:none;"><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
			<dd id="compSelectBox">
				<div id="comp_sel" class="puddSetup" ></div>
			</dd>
			
			<dt><%=BizboxAMessage.getMessage("TX000000239","메뉴")%></dt>
			<dd>
				<div id="alarm_sel" class="puddSetup" ></div>
			</dd>
		</dl>

	</div>

	<div id="" class="controll_btn">
		<input id="saveAlarmDetail" type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
	</div>

	<div class="alarm_ta" >
		<table cellspacing="0" cellpadding="0" id="allTable">
		<c:forEach var = "menu" items="${alarmMenuList}" varStatus="status">
			<tr id="${menu.flag1}" class="alarmName">
				<th><div class="posi_re">
				<c:choose>
					<c:when test="${menu.flag1=='COMMON'}"><%=BizboxAMessage.getMessage("TX800000680","공통/시스템설정")%></c:when>
					<c:when test="${menu.flag1=='PROJECT'}"><%=BizboxAMessage.getMessage("TX000010151","업무관리")%></c:when>
					<c:when test="${menu.flag1=='EAPPROVAL'}"><%=BizboxAMessage.getMessage("TX000000479","전자결재")%></c:when>
					<c:when test="${menu.flag1=='BOARD'}"><%=BizboxAMessage.getMessage("TX000011134","게시판")%></c:when>
					<c:when test="${menu.flag1=='EDMS'}"><%=BizboxAMessage.getMessage("TX000008627","문서")%></c:when>
					<c:when test="${menu.flag1=='EXTEND'}"><%=BizboxAMessage.getMessage("TX000010113","확장기능")%></c:when>
					<c:when test="${menu.flag1=='ATTEND'}"><%=BizboxAMessage.getMessage("TX000011135","근태관리")%></c:when>
					<c:when test="${menu.flag1=='MAIL'}"><%=BizboxAMessage.getMessage("TX000000262","메일")%></c:when>
					<c:when test="${menu.flag1=='SCHEDULE'}"><%=BizboxAMessage.getMessage("TX000005550","일정관리")%></c:when>
					<c:when test="${menu.flag1=='RESOURCE'}"><%=BizboxAMessage.getMessage("TX000007392","자원관리")%></c:when>
					<c:when test="${menu.flag1=='MENTION'}"><%=BizboxAMessage.getMessage("TX000021504","알파멘션")%></c:when>
					<c:otherwise>${menu.flag2}</c:otherwise>
				</c:choose>				
				<a href="#n" class="dropButton al_up" id="drop_${menu.flag1}"></a></div></th>
			</tr>
			<tr>
			<td class="td_class">
				<div class="com_ta2 alarm_ta_in" id="select_${menu.flag1}">
					<table id="${menu.flag1}">
						<colgroup>
							<col width="" />
							<col width="70" class="en_w115"/>
							<col width="70" />
							<col width="70" class="en_w100"/>
							<col width="70" />
							<col width="70" />
						</colgroup>
						<thead>
						<tr>
							<th class="vm"><%=BizboxAMessage.getMessage("TX000005521","항목")%></th>
							<th>
								<input type="checkbox" name="allAlert" id="allAlert_${menu.flag1}" class=""  /><label class="mt8" for="allAlert_${menu.flag1}"></label> 
								<label class="" for="allAlert_${menu.flag1}"><span><%=BizboxAMessage.getMessage("TX000004025","메신저")%></span></br><span style="float:left;margin:-5px 0 0 24px;">Push</span></label>
								
							</th>
							<th>
								<input type="checkbox" name="allPush" id="allPush_${menu.flag1}" class=""  /><label class="mt8" for="allPush_${menu.flag1}"></label> 
								<label class="" for="allPush_${menu.flag1}"><span><%=BizboxAMessage.getMessage("TX000016053","모바일")%></span></br><span style="float:left;margin:-5px 0 0 24px;">Push</span></label>
							</th>
							<th>  
								<label class="" for="allTalk_${menu.flag1}"><%=BizboxAMessage.getMessage("TX000007934","대화방")%></label></br>
								<input type="checkbox" name="allTalk" id="allTalk_${menu.flag1}" class=""  /><label class="" for="allTalk_${menu.flag1}"></label>
							</th>
							<th>
								<label class="" for="allMail_${menu.flag1}"><%=BizboxAMessage.getMessage("TX000000262","메일")%></label></br>
								<input type="checkbox" name="allMail" id="allMail_${menu.flag1}" class=""  /><label class="" for="allMail_${menu.flag1}"></label> 
							</th>
							<th style="display:none;">
								<label class="" for="allSms_${menu.flag1}">SMS</label></br>
								<input type="checkbox" name="allSms" id="allSms_${menu.flag1}" class=""  /><label class="" for="allSms_${menu.flag1}"></label> 
							</th>
							<th>
								<label class="" for="allPortal_${menu.flag1}"><%=BizboxAMessage.getMessage("TX000021955","메인알림")%></label></br>
								<input type="checkbox" name="allPortal" id="allPortal_${menu.flag1}" class=""  /><label class="" for="allPortal_${menu.flag1}"></label> 
							</th>
						</tr>
						</thead>
						<tbody class="${menu.flag1}_item">
						
						</tbody>
					</table>
				</div>
				<!--// com_ta2 alarm_ta_in 공통-->
			</td>
			</tr>

		</c:forEach>
	
		</table>
	</div>
	<!-- //alarm_ta -->


	<div class="com_ta6 mt40" >
		<table>
			<tr>
				<th class=""><%=BizboxAMessage.getMessage("TX000016181","알림 상세 설명")%></th>
			</tr>
			<tr>
				<td class="le" style="height: 105px" id="detail"><%=BizboxAMessage.getMessage("TX000010813","커스터마이징 메뉴 추가시 알림이 적용된경우")%>
					<%=BizboxAMessage.getMessage("TX000016324","'대화방'과 '메일'을 기본으로 한다")%></td>
			</tr>
		</table>
	</div>
	<!-- //com_ta6 -->

</div>


<!-- //sub_contents_wrap -->
