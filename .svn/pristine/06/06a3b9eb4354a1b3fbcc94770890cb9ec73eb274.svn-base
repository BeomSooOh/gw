<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

	<!--css-->
	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="/gw/js/Scripts/jqueryui/jquery-ui.css"/>
    	<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="/gw/js/pudd/Script/pudd/pudd-1.1.189.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/common.js"></script>

 <script type="text/javascript">
 	
 	var progressPercent = 0;
 
    $(document).ready(function() {
    	
    	<c:if test="${params.resultCode < 1}">
			<c:if test="${params.resultCode == -1}">
				alert("<%=BizboxAMessage.getMessage("TX900000212","연동된 정보가 없습니다.")%>\n<%=BizboxAMessage.getMessage("TX900000213","연동정보를 확인하여 주세요.")%>");
			</c:if>
			window.close();
		</c:if>
		
		
		// 근무구분 코드 맵핑
		var gwCodeList = ${gwWorkCodeListJson};			
		var syncWorkCodeList = [];
		
		<c:if test="${not empty syncWorkCodeList}">
		<c:forEach items="${syncWorkCodeList}" var="list" varStatus="c">
			var data = {};
			data.erpCode = '${list.erpCode}';
			data.erpCodeName = '${list.erpCodeName}';
			data.groupSeq = '${list.groupSeq}';
			data.compSeq = '${list.compSeq}';
			data.codeType = '${list.codeType}';
			data.gwCode = '${list.gwCode}';
			syncWorkCodeList.push(data);
		</c:forEach>
		</c:if>
		
		var dataSource = new Pudd.Data.DataSource({
				data : gridData = syncWorkCodeList
			,	pageSize : 1000	// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
			,	serverPaging : false
		});
		
		Pudd("#grid1").puddGrid({
				dataSource : dataSource	
			,   height : 201
			,	scrollable : true		 
			,	sortable : true	
			,	resizable : true
			,	ellipsis : false		 
			,	columns : [	
					{
						field : "erpCodeName"
					,	title : "ERP"
					,	width: 50
					,	widthUnit: "%"
					}
				,	{
						field:"gwCode"
					,	title:"<%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%>"
					,	content : {
									template : function( rowData ) {
										var html ='<select id="gwWorkCode_' + rowData.erpCode + '" class="puddSetup" pudd-style="width:60%">';
										
										for(var i=0;i<gwCodeList.length;i++){
											if(gwCodeList[i].gwCode == rowData.gwCode){
												html += '<option value="' + gwCodeList[i].gwCode + '" selected="selected">' + gwCodeList[i].gwCodeName + '</option>';
											}else{
												html += '<option value="' + gwCodeList[i].gwCode + '">' + gwCodeList[i].gwCodeName + '</option>';
											}
										}
										
										html +='</select>';
										
										return html;
									}
								}
					}
				]
		});
		
		
		
		
		
		//라이선스 설정탭
		
		//상용직
		var syncRegularCodeList = [];
		<c:if test="${not empty syncRegularCodeList}">
			<c:forEach items="${syncRegularCodeList}" var="list" varStatus="c">
				var data = {};
				data.cdField = '${list.cdField}';
				data.erpCodeName = '${list.erpCodeName}';
				data.fg1Syscode = '${list.fg1Syscode}';
				data.codeType = '${list.codeType}';
				data.gwCode = '${list.gwCode}';
				data.gwCode2 = '${list.gwCode2}';
				data.groupSeq = '${list.groupSeq}';
				data.cdCompany = '${list.cdCompany}';
				data.compSeq = '${list.compSeq}';
				data.erpCode = '${list.erpCode}';
				data.useYN = '${list.useYN}';
				data.typeName = '<%=BizboxAMessage.getMessage("","상용직")%>';
				data.type = '1';
				syncRegularCodeList.push(data);
			</c:forEach>
		</c:if>
		
		// 일용직
		<c:if test="${not empty syncDayCodeList}">
			<c:forEach items="${syncDayCodeList}" var="list" varStatus="c">
				var data = {};
				data.cdField = '${list.cdField}';
				data.erpCodeName = '${list.erpCodeName}';
				data.fg1Syscode = '${list.fg1Syscode}';
				data.codeType = '${list.codeType}';
				data.gwCode = '${list.gwCode}';
				data.gwCode2 = '${list.gwCode2}';
				data.groupSeq = '${list.groupSeq}';
				data.cdCompany = '${list.cdCompany}';
				data.compSeq = '${list.compSeq}';
				data.erpCode = '${list.erpCode}';
				data.useYN = '${list.useYN}';
				data.typeName = '<%=BizboxAMessage.getMessage("","일용직")%>';
				data.type = '2';
				syncRegularCodeList.push(data);
			</c:forEach>
		</c:if>

		var dataSource2 = new Pudd.Data.DataSource({
				data : gridData = syncRegularCodeList
			,	pageSize : 1000	// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
			,	serverPaging : false
		});
		 
		Pudd("#grid2").puddGrid({
				dataSource : dataSource2	
			,   height : 186
			,	scrollable : true		 
			,	sortable : true	
			,	resizable : true
			,	ellipsis : false		 
			,	columns : [	
					{
						field : "typeName"
					,	title : "<%=BizboxAMessage.getMessage("","구분")%>"
					,	width: 70
					}
				,	{
						field : "erpCodeName"
					,	title : "ERP"
					,	width: 30
					,	widthUnit: "%"
					}
				,	{
						field:"data2"
					,	title:"<%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%>"
					,	content : {
									template : function( rowData ) {
									var target = rowData.type == "1" ? "gwLicenseCode1_" : "gwLicenseCode2_";
									var html ='<select id="' + target + '' + rowData.erpCode + '" class="puddSetup" pudd-style="width:60%">'
										 html += '<option value="1" ' + (rowData.gwCode == '1' ? 'selected="selected"' : '') + '><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></option>';
										 html += '<option value="2" ' + (rowData.gwCode == '2' ? 'selected="selected"' : '') + '><%=BizboxAMessage.getMessage("TX000000262","메일")%></option>';
										 html += '<option value="3" ' + (rowData.gwCode == '3' ? 'selected="selected"' : '') + '><%=BizboxAMessage.getMessage("TX000017901","비라이선스")%></option>';
										 html +='</select>'
									return html;
									}
								}
					}
				,	{
						field : ""
					,	title : "근태사용여부"
					,	width : 150
					,	content : {
						template : function( rowData ) {
						var target = rowData.type == "1" ? "gwCheckWorkYn1_" : "gwCheckWorkYn2_";
						var html ='<select id="' + target + '' + rowData.erpCode + '" class="puddSetup" pudd-style="width:80%">'
							 html += '<option value="Y" ' + (rowData.gwCode2 == 'Y' ? 'selected="selected"' : '') + '>사용</option>';
							 html += '<option value="N" ' + (rowData.gwCode2 == 'N' ? 'selected="selected"' : '') + '>미사용</option>';
							 html += '<option value="" ' + (rowData.gwCode2 == null || rowData.gwCode2 == '' ? 'selected="selected"' : '') + '>선택안함</option>';
							 html +='</select>'
						return html;
						}
					}
					}
				]
		});

		var syncDutyPosiCodeList = [];
		<c:if test="${not empty syncDutyPosiCodeList}">
			<c:forEach items="${syncDutyPosiCodeList}" var="list" varStatus="c">
				var data = {};
				data.codeType = '${list.codeType}';
				data.gwCode = '${list.gwCode}';
				data.groupSeq = '${list.groupSeq}';
				data.compSeq = '${list.compSeq}';
				data.erpCode = '${list.erpCode}';
				data.erpCodeName = '${list.erpCodeName}';
				syncDutyPosiCodeList.push(data);
			</c:forEach>
		</c:if>
		
		
			
		if("${params.erpType}" == "iu"){
			if(syncDutyPosiCodeList.length == 0){
				syncDutyPosiCodeList = [
					{"erpCode":"1", "gwCode":"1", "erpCodeName":"<%=BizboxAMessage.getMessage("TX000018672","직급")%>"}
				,	{"erpCode":"2", "gwCode":"2", "erpCodeName":"<%=BizboxAMessage.getMessage("TX000000105","직책")%>"}
				,	{"erpCode":"3", "gwCode":"3", "erpCodeName":"<%=BizboxAMessage.getMessage("TX000001020","직위")%>"}
				]
			}
		}else{
			if(syncDutyPosiCodeList.length == 0){
				syncDutyPosiCodeList = [
					{"erpCode":"1", "gwCode":"1", "erpCodeName":"<%=BizboxAMessage.getMessage("TX000018672","직급")%>"}
				,	{"erpCode":"2", "gwCode":"2", "erpCodeName":"<%=BizboxAMessage.getMessage("TX000000105","직책")%>"}
				]
			}
		}
			
		
		var dataSource4 = new Pudd.Data.DataSource({
				data : gridData = syncDutyPosiCodeList
			,	pageSize : 1000	// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
			,	serverPaging : false
		});
		 
		Pudd("#grid4").puddGrid({
				dataSource : dataSource4	
			,   height : 201
			,	scrollable : true		 
			,	sortable : true	
			,	resizable : true
			,	ellipsis : false		 
			,	columns : [	
					{
						field : "erpCodeName"
					,	title : "ERP"
					,	width: 50
					,	widthUnit: "%"
					}
				,	{
						field:"data2"
					,	title:"<%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%>"
					,	content : {
									template : function( rowData ) {
										var html = '';
										if("${params.erpType}" == "iu"){
											html ='<select name="gwDutyPosi" id="gwDutyPosi_' + rowData.erpCode + '" class="puddSetup" pudd-style="width:60%">'
											html += '<option value="1" ' +  (rowData.gwCode == '1' ? 'selected="selected"' : '')  + '><%=BizboxAMessage.getMessage("TX000018672","직급")%></option>';
											html += '<option value="2" ' +  (rowData.gwCode == '2' ? 'selected="selected"' : '')  + '><%=BizboxAMessage.getMessage("TX000000105","직책")%></option>';
											html += '<option value="3" ' +  (rowData.gwCode == '3' ? 'selected="selected"' : '')  + '><%=BizboxAMessage.getMessage("TX000005964","사용안함")%></option>';
											html +='</select>'
										}else{
											html ='<select name="gwDutyPosi" id="gwDutyPosi_' + rowData.erpCode + '" class="puddSetup" pudd-style="width:60%">'
											html += '<option value="1" ' +  (rowData.gwCode == '1' ? 'selected="selected"' : '')  + '><%=BizboxAMessage.getMessage("TX000018672","직급")%></option>';
											html += '<option value="2" ' +  (rowData.gwCode == '2' ? 'selected="selected"' : '')  + '><%=BizboxAMessage.getMessage("TX000000105","직책")%></option>';
											html +='</select>'
										}
										return html;
									}
								}
					}
				]
		});

			
		
		$("#saveBtn").on("click", function(e) {
			baseDataSaveProc();
		});
		
		$("#cancelBtn").on("click", function(e) {
			setConfirm("<%=BizboxAMessage.getMessage("","기초설정이 완료되어야 조직도 동기화 사용이 가능합니다.")%></br><%=BizboxAMessage.getMessage("","설정을 취소하시겠습니까?")%>","question");
		});
		
	});	

	function bsNext(th){

		if ($(th).parent().parent().hasClass("bs_foot1"))
		{
			$(".bs_set_step.st1").addClass("animated05s fadeOutLeft").hide(500);
			setTimeout(function(){$(".bs_set_step.st1").removeClass("animated05s fadeOutLeft")},500);
			$(".bs_set_step.st2").addClass("animated05s fadeInRight").show();
			setTimeout(function(){$(".bs_set_step.st2").removeClass("animated05s fadeInRight")},500);
			$(".bs_foot1").hide();
			$(".bs_foot2").show();
		}else if ($(th).parent().parent().hasClass("bs_foot2"))
		{
			$(".bs_set_step.st2").addClass("animated05s fadeOutLeft").hide(500);
			setTimeout(function(){$(".bs_set_step.st2").removeClass("animated05s fadeOutLeft")},500);
			$(".bs_set_step.st3").addClass("animated05s fadeInRight").show();
			setTimeout(function(){$(".bs_set_step.st3").removeClass("animated05s fadeInRight")},500);
			$(".bs_foot2").hide();
			$(".bs_foot3").show();
		}
		
	};
	
	function bsPrev(th){

		if ($(th).parent().parent().hasClass("bs_foot2"))
		{
			$(".bs_set_step.st1").addClass("animated05s fadeInLeft").show();
			setTimeout(function(){$(".bs_set_step.st1").removeClass("animated05s fadeInLeft")},500);
			$(".bs_set_step.st2").addClass("animated05s fadeOutRight").hide(500);
			setTimeout(function(){$(".bs_set_step.st2").removeClass("animated05s fadeOutRight")},500);
			
			$(".bs_foot2").hide();
			$(".bs_foot1").show();

		}else if ($(th).parent().parent().hasClass("bs_foot3"))
		{
			$(".bs_set_step.st2").addClass("animated05s fadeInLeft").show();
			setTimeout(function(){$(".bs_set_step.st2").removeClass("animated05s fadeInLeft")},500);
			$(".bs_set_step.st3").addClass("animated05s fadeOutRight").hide(500);
			setTimeout(function(){$(".bs_set_step.st3").removeClass("animated05s fadeOutRight")},500);
			
			$(".bs_foot3").hide();
			$(".bs_foot2").show();
		}
		
	};
	
	function baseDataSaveProc() {
		
		if(!checkValidataion()){
			setAlert("<%=BizboxAMessage.getMessage("","그룹웨어 선택값이 중복되었습니다.")%></br><%=BizboxAMessage.getMessage("TX900000163","다시 선택해주세요.")%>", "warning", false);
			return;
		}
		
		
		var saveData = {};
		var codeList = [];
		
		// 근무구분 코드 데이터 셋팅
		var puddGrid = Pudd( "#grid1" ).getPuddObject();
		if( puddGrid ) {		 
			var data = puddGrid.getGridData();
			if( data )	{
				for( var i in data ) {
					var dt = {};
					var rowData = data[ i ];
					dt.codeType = "10";
					dt.erpCode = rowData.erpCode;
					dt.gwCode = $("#gwWorkCode_" + rowData.erpCode).val();
					dt.erpCodeName = rowData.erpCodeName;
					codeList.push(dt);
				}
			}
		}
		
		
		//상용직, 일용직 라이선스 데이터 셋팅
		puddGrid = Pudd( "#grid2" ).getPuddObject();
		if( puddGrid ) {		 
			var data = puddGrid.getGridData();
			if( data )	{
				for( var i in data ) {
					var dt = {};
					var rowData = data[ i ];
					if(rowData.type == "1"){
						dt.codeType = "20";
						dt.gwCode = $("#gwLicenseCode1_" + rowData.erpCode).val();
						dt.gwCode2 = $("#gwCheckWorkYn1_" + rowData.erpCode).val();
					}else if(rowData.type == "2"){
						dt.codeType = "30";
						dt.gwCode = $("#gwLicenseCode2_" + rowData.erpCode).val();
						dt.gwCode2 = $("#gwCheckWorkYn2_" + rowData.erpCode).val();
					}
					dt.erpCode = rowData.erpCode;
					dt.erpCodeName = rowData.erpCodeName;
					codeList.push(dt);
				}
			}
		}
		
		//직급/직책 데이터 셋팅
		puddGrid = Pudd( "#grid4" ).getPuddObject();
		if( puddGrid ) {		 
			var data = puddGrid.getGridData();
			if( data )	{
				for( var i in data ) {
					var dt = {};
					var rowData = data[ i ];
					dt.codeType = "40";
					dt.erpCode = rowData.erpCode;
					dt.gwCode = $("#gwDutyPosi_" + rowData.erpCode).val();
					dt.erpCodeName = rowData.erpCodeName;
					codeList.push(dt);
				}
			}
		}
		
		
		
		saveData.codeList = codeList;
		
		var tblParam = {};
		tblParam.groupSeq = "${params.groupSeq}";
		tblParam.compSeq = "${params.compSeq}";
		tblParam.data = JSON.stringify(saveData);
		
		setProgressBar();
		
		 $.ajax({
	     	type:"post",
	 		url:'<c:url value="/erp/orgchart/erpSyncBaseDataSetPopSaveProc.do"/>',
	 		datatype:"text",
	 		data:tblParam,
	 		success: function (data) {
	 			progressPercent = 100;
	 			setAlert("<%=BizboxAMessage.getMessage("", "기초 설정이 완료되었습니다.")%>", "success", true);			 			
			},
			error: function (result) {
				progressPercent = 100;
	 			alert("fail");
	 		}
	 	});
	}
	
	
	function checkValidataion(){
		var gwDutyPosi = $("select[name=gwDutyPosi]");
		
		var arr = []
		for(var i = 0; i < gwDutyPosi.length; i++) {
			arr.push($("#" + gwDutyPosi[i].id).val());
		}
		
		
		//직급/직책/직위 중복선택여부 확인
		var sorted_arr = arr.slice().sort();
		var results = [];
		for (var i = 0; i < arr.length - 1; i++) {
		    if (sorted_arr[i + 1] == sorted_arr[i]) {
		        results.push(sorted_arr[i]);
		    }
		}
		
		if(results.length == 0){
			return true;
		}else{	
			return false;
		}
	}
	
	
	
	function setAlert(msg, type, closeFlag){
		//type -> success, warning		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';		
			
		var puddDialog = Pudd.puddDialog({	
			width : 500	// 기본값 300
		,	height : 100	// 기본값 400		 
		,	message : {		 
				type : type
				,content : titleStr
			},
			footer : {
				 
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
					,	value : '<%=BizboxAMessage.getMessage("TX000019752", "확인")%>'
					,	clickCallback : function( puddDlg ) {
							if(closeFlag){
								window.self.close();			//현재창 닫음
							}else{
								puddDialog.showDialog(false);
							}
						}
					}				
				]				
			}
		});			
		$("#btnConfirm").focus();	
	}
	
	
	
	function setConfirm(msg, type){
		//type -> success, warning		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';		
			
		var puddDialog = Pudd.puddDialog({	
			width : 500	// 기본값 300
		,	height : 100	// 기본값 400		 
		,	message : {		 
				type : type
				,content : titleStr
			},
			footer : {
				 
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
					,	value : '<%=BizboxAMessage.getMessage("TX000019752", "확인")%>'
					,	clickCallback : function( puddDlg ) {
							puddDlg.showDialog( false );
							window.self.close();
						}
					},
					{
						attributes : {style : "margin-left:5px;"}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnCancel"}// control 자체 객체 속성 설정
					,	value : '<%=BizboxAMessage.getMessage("TX000002947", "취소")%>'
					,	clickCallback : function( puddDlg ) {
							puddDlg.showDialog( false );
						}
					}					
				]				
			}
		});			
		$("#btnConfirm").focus();
	}
	
	
	function setProgressBar(){
		var puddObj = Pudd( "#progressBar" ).getPuddObject();
		if( puddObj ) {
			puddObj.clearIntervalSet();
		}
		var cnt = 0;
		Pudd( "#progressBar" ).puddProgressBar({
				progressType : "loading"
			,	attributes : { style:"width:70px; height:70px;" }
			,	strokeColor : "#84c9ff"	// progress 색상
			,	strokeWidth : "3px"	// progress 두께
			,	textAttributes : { style : "" }		// text 객체 속성 설정
			,	percentText : "loading"	// loading 표시 문자열 설정 - progressType : loading, juggling 인 경우만 해당
			,	percentTextColor : "#84c9ff"
			,	percentTextSize : "12px"
			,	backgroundLayerAttributes : { style : "background-color:#000;filter:alpha(opacity=20);opacity:0.2;width:100%;height:100%;position:fixed;top:0px; left:0px;" }
			,	progressCallback : function( progressBarObj ) {
			 		return progressPercent;
				}
		});
	}

</script>

<body>
<div class="pop_wrap" style="width:100%;" id="content">
	<div id="progressBar"></div>
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000020527","기초 설정")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con posi_re" style="height:405px">
		<div class="bs_set_step st1">
			<div class="Pop_border p15 mb15" style="background:#f0f6fd;">
				<p class="tit_p mb8"><%=BizboxAMessage.getMessage("","ERP의 근무구분 코드를 그룹웨어에서 사용할 코드로 맵핑 합니다.")%></p>
				<p class="tit_p mb0"><%=BizboxAMessage.getMessage("","사용자 연동 시 선택된 그룹웨어의 근무구분 값으로 적용 됩니다.")%></p>
			</div>
			<div class="bs_tab">
				<ul>
					<li class="on">
						<a href="#n">1. <%=BizboxAMessage.getMessage("","ERP코드 설정")%></a>
						<span class="arr_semo"></span>
					</li>
					<li>
						<a href="#n">2. <%=BizboxAMessage.getMessage("TX000021939","라이선스 설정")%></a>
						<span class="arr_semo"></span>
					</li>
					<li>
						<a href="#n">3. <%=BizboxAMessage.getMessage("","직급직책 설정")%></a>
					</li>
				</ul>
			</div>
			<p class="tit_p">근무구분 코드 맵핑</p>
			<div id="grid1"></div>
		</div><!--// bs_set_step1 -->

		<div class="bs_set_step st2" style="display:none;">
			<div class="Pop_border p15 mb15" style="background:#f0f6fd;">
				<p class="tit_p mb8"><%=BizboxAMessage.getMessage("","ERP의 직군유형을 그룹웨어에서 사용할 라이선스로 맵핑 합니다.")%></p>
				<p class="tit_p mb0"><%=BizboxAMessage.getMessage("","사용자 연동 시 선택된 그룹웨어의 라이선스 값으로 적용 됩니다.")%></p>
			</div>
			<div class="bs_tab">
				<ul>
					<li>
						<a href="#n">1. <%=BizboxAMessage.getMessage("","ERP코드 설정")%></a>
						<span class="arr_semo"></span>
					</li>
					<li class="on">
						<a href="#n">2. <%=BizboxAMessage.getMessage("TX000021939","라이선스 설정")%></a>
						<span class="arr_semo"></span>
					</li>
					<li>
						<a href="#n">3. <%=BizboxAMessage.getMessage("","직급직책 설정")%></a>
					</li>
				</ul>
			</div>

			<div>
				<div style="padding-top:10px;">
					<div id="grid2"></div>
				</div>
			</div>
		</div><!--// bs_set_step2 -->

		<div class="bs_set_step st3" style="display:none;">
			<div class="Pop_border p15 mb15" style="background:#f0f6fd;">
				<p class="tit_p mb8"><%=BizboxAMessage.getMessage("","ERP의 코드 중 그룹웨어에서 사용할 직급/직책을 선택 합니다.")%></p>
				<p class="tit_p mb0"><span class="text_red"><%=BizboxAMessage.getMessage("","직급/직책은 중복 선택 할 수 없으며")%></span>, <%=BizboxAMessage.getMessage("","맵핑된 코드가 그룹웨어로 연동됩니다.")%></p>
			</div>
			<div class="bs_tab">
				<ul>
					<li>
						<a href="#n">1. <%=BizboxAMessage.getMessage("","ERP코드 설정")%></a>
						<span class="arr_semo"></span>
					</li>
					<li>
						<a href="#n">2. <%=BizboxAMessage.getMessage("TX000021939","라이선스 설정")%></a>
						<span class="arr_semo"></span>
					</li>
					<li class="on">
						<a href="#n">3. <%=BizboxAMessage.getMessage("","직급직책 설정")%></a>
						<span class="arr_semo"></span>
					</li>
				</ul>
			</div>
			<p class="tit_p"><%=BizboxAMessage.getMessage("","직급/직책 선택")%></p>
			<div id="grid4"></div>
		</div><!--// bs_set_step3 -->


	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12 bs_foot1">
			<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000003164","다음")%>" onclick="bsNext(this);" />
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000019660","취소")%>" id="cancelBtn"/>
		</div>
		<div class="btn_cen pt12  bs_foot2" style="display:none;">
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000003165","이전")%>" onclick="bsPrev(this);" />
			<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000003164","다음")%>" onclick="bsNext(this);"/>
		</div>
		<div class="btn_cen pt12 bs_foot3" style="display:none;">
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000003165","이전")%>" onclick="bsPrev(this);"/>
			<input id="saveBtn" type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001288","완료")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!--// pop_wrap -->

<div id="ProgressBar"></div>

</body>