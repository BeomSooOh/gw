<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
	<%@page import="main.web.BizboxAMessage"%>
	
	
	
	<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.84.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.min.js"></script>    
    
    <script src="/gw/js/neos/NeosUtil.js"></script>
</head>

<script type="text/javascript">
	
	var devCnt = "${deviceCnt}";
	
	$(document).ready(function() {
		
		
		var contentStr1 = '';
			contentStr1 += '[<span class="text_blue"><%=BizboxAMessage.getMessage("TX900000034", "인증기기")%></span>]<br />';
			contentStr1 += '<span>- <%=BizboxAMessage.getMessage("TX900000035", "로그인 시 이차 인증에 사용되는 모바일 기기입니다.")%></span><br />';
			contentStr1 += '<span>- <%=BizboxAMessage.getMessage("TX900000036", "인증기기로 그룹웨어 앱을 사용하실 수 있습니다.")%></span><br /><br />';
			contentStr1 += '[<span class="text_blue"><%=BizboxAMessage.getMessage("TX900000037", "사용기기")%></span>]<br />';
			contentStr1 += '<span>- <%=BizboxAMessage.getMessage("TX900000038", "그룹웨어 앱을 사용할 수 있는 모바일 또는 태블릿 기기입니다.")%></span><br />';
			contentStr1 += '<span>- <%=BizboxAMessage.getMessage("TX900000039", "사용 기기로 등록하지 않는 경우, 그룹웨어 앱 사용이 불가합니다.")%></span><br /><br />';
			
			contentStr1 += '<span><%=BizboxAMessage.getMessage("TX900000040", "※ 이차인증범위를 App만 선택하는 경우,")%><br />&nbsp;&nbsp;<%=BizboxAMessage.getMessage("TX900000041", "사용기기 가능 개수만 설정이 가능합니다.")%></span>';
		
		$( "#helpDialog1" ).on( "click", function() {
			Pudd.puddDialog({
					width : 400
				,	modal : true		// 기본값 true
				,	draggable : true	// 기본값 true
				,	resize : false		// 기본값 false
				,	header : {
						title : "<%=BizboxAMessage.getMessage("TX900000042", "이차인증기기")%>"
					,	align : "left"	// left, center, right
					,	minimizeButton : false	// 기본값 false
					,	maximizeButton : false	// 기본값 false
					,	closeButton : true	// 기본값 true
				}
				,	body : {
						// dialog content 문자열
						content : contentStr1
				}
			});
		});
		fnRangeClick('${range}');
		setSelectedOrgList();		
	});
	
	function ok(){
		 var useYn = "";
		 var range = "";
		 var target = "";
		 var approvalYn = "";
		 var pinYn = "";
		 var appConfirmYn = "${appConfirmYn}";
		 
		 //데이터 체크
		 if(document.getElementById("useY").checked){
			 useYn = "Y";
		 }else{
			 useYn = "N";
		 }
		 
		 
		 if(document.getElementById("range_M").checked){
			 range = "M";
			 
			 if(document.getElementById("appConfirmY").checked){
				 appConfirmYn = "Y";
			 }else{
				 appConfirmYn = "N";
			 }
		 }else if(document.getElementById("range_A").checked){
			 range = "A";
		 }
		 
		 if(document.getElementById("targetA").checked){
			 target = "A";
		 }else if(document.getElementById("targetE").checked){
			 target = "E";
		 }
		 
		 if(document.getElementById("approvalY").checked){
			 approvalYn = "Y";
		 }else{
			 approvalYn = "N";
		 }
		 
		 if(document.getElementById("pinY").checked){
			 pinYn = "Y";
		 }else{
			 pinYn = "N";
		 }
		 
		 
		 
		 var selectedItemE = "";
		 var selectedItemI = "";
		 
		 
		 var puddObj1 = Pudd( "#total_use" ).getPuddObject();
		 var data1 = puddObj1.getData();
		 
		 var puddObj2 = Pudd( "#one_use" ).getPuddObject();
		 var data2 = puddObj2.getData();
		 
		 for(var i=0; i<data1.length; i++){
			 var gbnFlag = data1[i].value.split("|");
			 if(gbnFlag[4] == "c"){
				 selectedItemE += "▩" + gbnFlag[4] + "▦" + gbnFlag[1] + "▦" + data1[i].value;				 
			 }else if(gbnFlag[4] == "d"){
				 selectedItemE += "▩" + gbnFlag[4] + "▦" + gbnFlag[2] + "▦" + data1[i].value;
			 }else if(gbnFlag[4] == "u"){
				 selectedItemE += "▩" + gbnFlag[4] + "▦" + gbnFlag[3] + "▦" + data1[i].value;
			 }
		 }		 
		 
		 for(var i=0; i<data2.length; i++){
			 var gbnFlag = data2[i].value.split("|");
			 if(gbnFlag[4] == "c"){
				 selectedItemI += "▩" + gbnFlag[4] + "▦" + gbnFlag[1] + "▦" + data2[i].value;				 
			 }else if(gbnFlag[4] == "d"){
				 selectedItemI += "▩" + gbnFlag[4] + "▦" + gbnFlag[2] + "▦" + data2[i].value;
			 }else if(gbnFlag[4] == "u"){
				 selectedItemI += "▩" + gbnFlag[4] + "▦" + gbnFlag[3] + "▦" + data2[i].value;
			 }
		 }
		 
		 if(selectedItemE.length > 0){
			 selectedItemE = selectedItemE.substring(1);
		 }
		 if(selectedItemI.length > 0){
			 selectedItemI = selectedItemI.substring(1);
		 }
		 
		 var tblParam = {};
		 tblParam.useYn = useYn;
		 tblParam.deviceCnt = Pudd( "#deviceCnt" ).getPuddObject().val();
		 devCnt = tblParam.deviceCnt;
		 tblParam.range = range;
		 tblParam.target = target;
		 tblParam.approvalYn = approvalYn;
		 tblParam.pinYn = pinYn;
		 tblParam.selectedItemE = selectedItemE;
		 tblParam.selectedItemI = selectedItemI;
		 tblParam.appConfirmYn = appConfirmYn;
		 
		 $.ajax({
		     	type:"post",
		 		url:'<c:url value="/cmm/systemx/saveSecondCertOptionInfo.do"/>',
		 		datatype:"text",
		 		data:tblParam,
		 		success: function (data) {
		 			setScAlert("<%=BizboxAMessage.getMessage("TX000002073", "저장되었습니다.")%>", "success");
				}
	 	});
	 }
	
	 var orgPopFlag = "";
	 var orgPopTarget = "";
	 
	function setOrgList(flag){
		
		 orgPopFlag = flag;
		 
		 var selectedItem = "";
		 
		 var target = (flag == "E" ? "total_use" : "one_use");
		 orgPopTarget = target;
		 
		 var puddObj = Pudd( "#" + target ).getPuddObject();
		 var data = puddObj.getData();
		 
		 
		 for(var i=0; i<data.length; i++){
			 selectedItem += "," + data[i].value;
		 }
		 if(selectedItem.length > 0)
			 selectedItem = selectedItem.substring(1);
		 
		 
		 $("#selectedItems").val(selectedItem);	 
		 
		 var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
			frmPop.submit();
			pop.focus();
	 }
	
	function callbackSel(data){	 	 
		 var htmlTag = "";
		 
		 jsonData = data.returnObj;	
		 
		 var orgData = [];
		 
		 for(var i=0;i<jsonData.length; i++){
			var data = {};
			data.value = jsonData[i].superKey;
			data.text = jsonData[i].orgName;
			
			orgData.push(data);
		 }
		 
		 
		 var exData1 = orgData;
		 
		 // Pudd DataSource 매핑
	 	 var dataSource2ndTotal = new Pudd.Data.DataSource({
	 		data : exData1
		 });
	   
		 Pudd( "#" + orgPopTarget ).puddSelectiveInput({
				// 수정모드인 경우 dataSource 전달, 신규는 해당없음
				dataSource : dataSource2ndTotal
			,	dataValueField : "value"
			,	dataTextField : "text"
	 
			,	writeMode : false // 기본 입력 모드
			,	disabled : false
			,	editButton : false
			,	deleteButton : true
	 
			// 입력박스에서 내용이 없는 상태에서 backspace 입력하는 경우 이전 항목 삭제처리
			,	backspaceDelete : false
		 });
		 
		 Pudd( "#" + orgPopTarget ).on( "selectiveInputItemClick", function( e ) {
			 
				// e.detail 항목으로 customEvent param 전달됨
				// e.detail.spanObj - click 객체
				var evntVal = e.detail;
			 
				if( ! evntVal ) return;
				if( ! evntVal.spanObj ) return;
			 
				var valStr = "|" + evntVal.spanObj.inputObj.val() + "|";
				if(valStr.indexOf("|u|") > -1){
					var empSeq = valStr.split("|")[4];
					openEmpProfileInfoPop('','',empSeq);
				}
			});
	 
	 }
	
	
	function fnTargetClick(target){
		if(target == "A"){
			$("#target_A").show();
			$("#target_E").hide();
		}else{
			$("#target_A").hide();
			$("#target_E").show();
		}
	}
	
	
	
	function setSelectedOrgList(){
		 var selectedItemE = '${excludeOrgList}';	 
		 var selectedItemI = '${includeOrgList}';
		 
		 selectedItemE = JSON.parse(selectedItemE);
		 selectedItemI = JSON.parse(selectedItemI);
		 
		// Data 생성
			var exData1 = selectedItemE;
			 
			// Pudd DataSource 매핑
			var dataSource2ndTotal = new Pudd.Data.DataSource({
				data : exData1
			});
		   
			Pudd( "#total_use" ).puddSelectiveInput({
					// 수정모드인 경우 dataSource 전달, 신규는 해당없음
					dataSource : dataSource2ndTotal
				,	dataValueField : "value"
				,	dataTextField : "text"
		 
				,	writeMode : false // 기본 입력 모드
				,	disabled : false
				,	editButton : false
				,	deleteButton : true
		 
				// 입력박스에서 내용이 없는 상태에서 backspace 입력하는 경우 이전 항목 삭제처리
				,	backspaceDelete : false
			});
			
			// Data 생성
			var exData2 = selectedItemI;
			 
			// Pudd DataSource 매핑
			var dataSource2ndUser = new Pudd.Data.DataSource({
				data : exData2
			});
		   
			Pudd( "#one_use" ).puddSelectiveInput({
					// 수정모드인 경우 dataSource 전달, 신규는 해당없음
					dataSource : dataSource2ndUser
				,	dataValueField : "value"
				,	dataTextField : "text"
		 
				,	writeMode : false // 기본 입력 모드
				,	disabled : false
				,	editButton : false
				,	deleteButton : true
		 
				// 입력박스에서 내용이 없는 상태에서 backspace 입력하는 경우 이전 항목 삭제처리
				,	backspaceDelete : false
			});
			
			
			Pudd( "#total_use" ).on( "selectiveInputItemClick", function( e ) {
				 
				// e.detail 항목으로 customEvent param 전달됨
				// e.detail.spanObj - click 객체
				var evntVal = e.detail;
			 
				if( ! evntVal ) return;
				if( ! evntVal.spanObj ) return;
			 
				var valStr = "|" + evntVal.spanObj.inputObj.val() + "|";
				if(valStr.indexOf("|u|") > -1){
					var empSeq = valStr.split("|")[4];
					openEmpProfileInfoPop('','',empSeq);
				}
			});
			
			
			Pudd( "#one_use" ).on( "selectiveInputItemClick", function( e ) {
				 
				// e.detail 항목으로 customEvent param 전달됨
				// e.detail.spanObj - click 객체
				var evntVal = e.detail;
			 
				if( ! evntVal ) return;
				if( ! evntVal.spanObj ) return;

				var valStr =  "|" + evntVal.spanObj.inputObj.val() + "|";
				if(valStr.indexOf("|u|") > -1){
					var empSeq = valStr.split("|")[4];
					openEmpProfileInfoPop('','',empSeq);
				}
			});
			
			
			if("${target}" == "A"){
				$("#target_A").show();
				$("#target_E").hide();			
			}else{
				$("#target_A").hide();
				$("#target_E").show();
			}
	 }
	
	
	function checkOption(e, type){	 
		 if(document.getElementById("approvalN").checked && document.getElementById("pinN").checked){
			 setScAlert("<%=BizboxAMessage.getMessage("TX900000043", "인증기기 승인여부와 PIN번호 사용여부는 동시에 미사용처리할 수 없습니다.")%>", "warning");
			 if(type == 0){
				 Pudd( 'input[type="radio"][name="2ndRai04"][value="1"]' ).getPuddObject().setChecked( true );
			 }
			 else{
				 Pudd( 'input[type="radio"][name="2ndRai05"][value="1"]' ).getPuddObject().setChecked( true );
			 }
		 }
		 
	 }
	
	
	function setScAlert(msg, type){
		//type -> success, warning
		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';

		
		var puddDialog = Pudd.puddDialog({	
				width : 550	// 기본값 300
			,	message : {		 
					type : type
				,	content : titleStr
				},
		footer : {
			 
			buttons : [
				{
					attributes : {}// control 부모 객체 속성 설정
				,	controlAttributes : { id : "alertConfirm", class : "submit" }// control 자체 객체 속성 설정
				,	value : "확인"
				}
			]
		}
		});			
		$( "#alertConfirm" ).click(function() {
			puddDialog.showDialog( false );
		});			
	
	}
	
	function fnRangeClick(target){
		var codeData = "";
		
		if(target == "A"){
			codeData = [
			            	{ "value" : 1, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","0") }
			            ,	{ "value" : 2, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","1") }
			            ,	{ "value" : 3, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","2") }
			            ,	{ "value" : 4, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","3") }
			            ,	{ "value" : 5, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","4") }
			            ,	{ "value" : 6, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","5") }
			            ,	{ "value" : 7, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","6") }
			            ,	{ "value" : 8, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","7") }
			            ,	{ "value" : 9, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","8") }
			            ,	{ "value" : 10, "text" : "<%=BizboxAMessage.getMessage("TX900000044","인증기기 : {0}대")%>, ".replace("{0}", "1") + "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","9") }
			            ];
			$("#appConfirmZone").hide();
		}else{
			codeData = [
			            	{ "value" : 1, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","1") }			            
			            ,	{ "value" : 2, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","2") }
			            ,	{ "value" : 3, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","3") }
			            ,	{ "value" : 4, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","4") }
			            ,	{ "value" : 5, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","5") }
			            ,	{ "value" : 6, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","6") }
			            ,	{ "value" : 7, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","7") }
			            ,	{ "value" : 8, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","8") }
			            ,	{ "value" : 9, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","9") }
			            ,	{ "value" : 10, "text" : "<%=BizboxAMessage.getMessage("TX900000045","사용기기 : {0}대")%>".replace("{0}","10") }
			            ];
			
			$("#appConfirmZone").show();
		}

		var dataSourceComboBox = new Pudd.Data.DataSource({			 
			data : codeData
		});
		
		Pudd( "#deviceCnt" ).puddComboBox({			 
			attributes : { style : "width:220px;" }// control 부모 객체 속성 설정
		,	controlAttributes : { id : "exAreaSelectBox" }// control 자체 객체 속성 설정
		,	dataSource : dataSourceComboBox
		,	dataValueField : "value"
		,	dataTextField : "text"
		,	selectedIndex : devCnt - 1
		});
	}

</script>



<div class="sub_contents_wrap">
	<div class="btn_div mt0">
		<div class="left_div">
			<p class="tit_p mb5 mt5"><%=BizboxAMessage.getMessage("TX900000046","이차인증 설정")%></p>
		</div>
		<div class="right_div">
			<input type="button" onclick="ok();" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
		</div>
	</div>

	<div class="com_ta">
		<table>
			<colgroup>
				<col width="200" />
				<col width="" />
			</colgroup>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX900000047","이차인증 사용여부")%></th>
				<td>
					<input type="radio" value="1" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000000180","사용")%>" name="useYn" id="useY" <c:if test="${useYn == 'Y'}">checked</c:if> /> 
					<input type="radio" value="2" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000001243","미사용")%>" name="useYn" id="useN" <c:if test="${useYn == 'N'}">checked</c:if> /></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX900000048","이차인증 범위")%></th>
				<td>
					<input onclick="fnRangeClick('A');" type="radio" id="range_A" name="range" class="puddSetup" pudd-label="Web+Messenger+App" <c:if test="${range == 'A'}">checked</c:if> />
					<input onclick="fnRangeClick('M');" type="radio" id="range_M" name="range" class="puddSetup ml10" pudd-label="App" <c:if test="${range == 'M'}">checked</c:if> /></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX900000049","이차인증 기기")%></th>
				<td>
					<!-- Web+Messenger+App 선택시 --> 
					<div id="deviceCnt" style="display:inline-block;"/></div><a href="#n" class="ml5" id="helpDialog1"><img src="${pageContext.request.contextPath}/Images/ico/ico_explain.png"></a>
				</td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX900000050","이차인증 대상")%></th>
				<td>
					<input type="radio" id="targetA" onclick="fnTargetClick('A');" name="2ndRai03" value="1" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000015530","전체사용")%>" <c:if test="${target == 'A'}">checked</c:if> /> 
					<input type="radio" id="targetE" onclick="fnTargetClick('E');" name="2ndRai03" value="2" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX900000051","일부사용")%>" <c:if test="${target == 'E'}">checked</c:if> />
					 
					<dl class="clear mt10" id="target_A">
						<dt class="fl mt5 mr10 fwb"><%=BizboxAMessage.getMessage("TX900000052","제외대상")%></dt>
						<dd class="fl mr5" style="width: 50%;">
							<div id="total_use" style="width: 100%"></div>
						</dd>
						<dd class="fl">
							<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" pudd-style="vertical-align:top;" onclick="setOrgList('E')"/>
						</dd>
					</dl> <!-- 일부사용 -->
					<dl class="clear mt10" id="target_E">
						<dt class="fl mt5 mr10 fwb"><%=BizboxAMessage.getMessage("TX900000053","인증대상")%></dt>
						<dd class="fl mr5" style="width: 50%;">
							<div id="one_use" style="width: 100%"></div>
						</dd>
						<dd class="fl">
							<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" pudd-style="vertical-align:top;" onclick="setOrgList('I')"/>
						</dd>
					</dl>
					
				</td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX900000054","인증기기 승인여부")%></th>
				<td>
					<input type="radio" id="approvalY" name="2ndRai04" value="1" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000000180","사용")%>" <c:if test="${approvalYn == 'Y'}">checked</c:if> onclick="checkOption(this, 0)" /> 
					<input type="radio" id="approvalN" name="2ndRai04" value="2" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000001243","미사용")%>" <c:if test="${approvalYn == 'N'}">checked</c:if> onclick="checkOption(this, 0)" /></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX900000055","PIN번호 사용여부")%></th>
				<td>
					<input type="radio" id="pinY" name="2ndRai05" value="1" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000000180","사용")%>" <c:if test="${pinYn == 'Y'}">checked</c:if> onclick="checkOption(this, 1)" /> 
					<input type="radio" id="pinN" name="2ndRai05" value="2" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000001243","미사용")%>" <c:if test="${pinYn == 'N'}">checked</c:if> onclick="checkOption(this, 1)" /></td>
			</tr>
			<tr id="appConfirmZone">
				<th><%=BizboxAMessage.getMessage("TX900000056","App최초 로그인")%></br><%=BizboxAMessage.getMessage("TX900000057","인증처리 사용여부")%></th>
				<td>
					<input type="radio" id="appConfirmY" name="2ndRai06" value="1" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000000180","사용")%>" <c:if test="${appConfirmYn == 'Y'}">checked</c:if> /> 
					<input type="radio" id="appConfirmN" name="2ndRai06" value="2" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000001243","미사용")%>" <c:if test="${appConfirmYn == 'N'}">checked</c:if> />
				</td>
			</tr>
		</table>
	</div>
</div>


<form id="frmPop" name="frmPop"> 
		<input type="hidden" name="selectedItems" id="selectedItems" value="" />
		<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do" />
		<input type="hidden" name="selectMode" id="selectMode" value="ud" />
		<input type="hidden" name="selectItem" value="m" />
		<input type="hidden" name="callback" id="callback" value="" />
		<input type="hidden" name="compSeq" value="6" />
		<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/>
		<input type="hidden" name="empUniqYn" value="Y" />
		<input type="hidden" name="empUniqGroup" value="ALL" />
</form>


</html>