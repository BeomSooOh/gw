<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">
	<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
</head>

 <script type="text/javascript">
 
    $(document).ready(function() {
    	
    	fnGetGridData();
    	
    	});	
    
    var gridData;
    function fnGetGridData() {
    	if($("#changePass").val() != ""){
			$("#changePass").val("");
    	}
    	$.ajax({
			type: "post",
			url: "/gw/getFindPasswdEmpList.do",
			datatype: "json",
			data:'',
			success: function(data) {
				if (data.resultCode != "fail") {
					gridData = data.findPasswdEmpList;
					if(gridData.length > 0){
						fnbindData(gridData);
					}
					else {
						self.close();
					}
				}else {
					puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
				}
			},
			error: function(e) {
				puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
			}
		});			
    }
    
    function fnbindData(gridData){
    	var dataSource = new Pudd.Data.DataSource({
			data : gridData	// 직접 data를 배열로 설정하는 옵션 작업할 것
		,	pageSize : 1000	// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
		,	serverPaging : false
	});
	
	//bind
		Pudd("#grid").puddGrid({		 
			dataSource : dataSource
		,   height : 200
		,	scrollable : true		 
		,	sortable : true	
		,	resizable : true
		,	ellipsis : false		 
		,	columns : [	
				{
					field : "gridCheckBox"		// grid 내포 checkbox 사용할 경우 고유값 전달
				,	width : 34
				,	editControl : {
						type : "checkbox"
					,	dataValueField : "empSeq"
					,	basicUse : true
					}
				}	
			,	{
					field : "compName"
				,	title : "<%=BizboxAMessage.getMessage("","회사")%>"					
				}
			,	{
					field:"deptName"
				,	title:"<%=BizboxAMessage.getMessage("","부서")%>"
				,	width:130	
				}
			,	{
					field:"empName"
				,	title:"<%=BizboxAMessage.getMessage("","요청자(ID)")%>"
				,	width:110
				}
			,	{
					field:"reqDate"
				,	title:"<%=BizboxAMessage.getMessage("","요청일시")%>"
				,	width:140
				}
			,	{
					field:"loginPasswd"
				,	title:"<%=BizboxAMessage.getMessage("","요청 IP")%>"
				,	width:120
				}
			]
	});
    }

    
 	function puddConfirm(alertMsg, callback){
 		var puddDialog = Pudd.puddDialog({
 			width : "400"
 		,	height : "100"
 		,	message : {
 				type : "question"
 			,	content : alertMsg.replace(/\n/g, "<br>")
 			}
 		,	footer : {
 		
 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
 				buttons : [
 					{
 						attributes : {}// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
 					,	value : "확인"
 					,	clickCallback : function( puddDlg ) {
 							puddDlg.showDialog( false );
 							eval(callback);
 						}
 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
 					,	defaultFocus :  true// 기본값 true
 					}
 				,	{
 						attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
 					,	value : "취소"
 					,	clickCallback : function( puddDlg ) {
 		
 							puddDlg.showDialog( false );
 						}
 					}
 				]
 			}	
 		
 		});		
 	}

 	function puddAlert(type, alertMsg, callback){
 		var puddDialog = Pudd.puddDialog({
 			width : "400"
 		,	height : "100"
 		,	message : {
 				type : type
 			,	content : alertMsg.replace(/\n/g, "<br>")
 			}
 		,	footer : {
 		
 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
 				buttons : [
 					{
 						attributes : {}// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
 					,	value : "확인"
 					,	clickCallback : function( puddDlg ) {
 							puddDlg.showDialog( false );
 							eval(callback);
 						}
 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
 					,	defaultFocus :  true// 기본값 true
 					}
 				]
 			}	
 		
 		});		
 	}    
    
	function ok() {
		
		var puddGrid = Pudd( "#grid" ).getPuddObject();
		
		var dataCheckedRow = puddGrid.getGridCheckedRowData( "gridCheckBox" );
		
		if(dataCheckedRow.length == 0){
			puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000007613", "사원을 선택해주세요")%>","");
			return;
		}
		
		if($("#changePass").val() == ""){
			puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000012873", "필수값을 입력해 주세요")%>","$('#changePass').focus()");
			return;
		}
		
		if (confirm("<%=BizboxAMessage.getMessage("TX900000144", "비밀번호를 초기화 하시겠습니까?")%>")) {
			
			var selectedList = [];
			
		    $.each(dataCheckedRow, function (i, t) {
		    	
		    	var selectedInfo = {};
		    	selectedInfo.empSeq = t.empSeq;
		    	selectedList.push(selectedInfo);
		    	
		    });			
			
			var params = {};
			params.empSeqArray = JSON.stringify(selectedList);
			params.newPasswd = $("#changePass").val();
			params.loginSetCheck = $("#loginSetCheck").is(":checked") ? "Y" : "N";

			fnLoading(true);
			
			$.ajax({
				type: "post",
				url: "empLoginPasswdResetProc.do",
				datatype: "json",
				data: params,
				success: function(data) {
					fnLoading(false);
					if (data.resultCode != "fail") {
						puddAlert("success", "<%=BizboxAMessage.getMessage("TX000019529", "초기화 되었습니다.")%>","fnGetGridData()");
					} else {
						puddAlert("error", data.result, "");
					}
					
				},
				error: function(e) {
					fnLoading(false);
					puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
				}
			});			
		}		
	}    
	
 	var percent = 0;
 	
 	function fnLoading(flag){
 		
 		if(flag){
 	 		percent = 0;
 	 		
 	 	 	Pudd( "#ProgressBar" ).puddProgressBar({
 	 	 		 
 	 	 		progressType : "juggling"
 	 	 	,	attributes : { style:"width:70px; height:70px;" }
 	 	 	 
 	 	 	,	strokeColor : "#84c9ff"	// progress 색상
 	 	 	,	strokeWidth : "3px"	// progress 두께
 	 	 	 
 	 	 	,	textAttributes : { style : "" }		// text 객체 속성 설정
 	 	 	 
 	 	 	,	percentText : "loading"	// loading 표시 문자열 설정 - progressType : loading, juggling 인 경우만 해당
 	 	 	,	percentTextColor : "#84c9ff"
 	 	 	,	percentTextSize : "12px"
 	 	 	 
 	 	 		// 배경 layer 설정 - progressType : loading, juggling 인 경우만 해당
 	 	 	,	backgroundLayerAttributes : { style : "background-color:#000;filter:alpha(opacity=20);opacity:0.2;width:100%;height:100%;position:fixed;top:0px; left:0px;" }
 	 	 	 
 	 	 		// 200 millisecond 마다 callback 호출됨
 	 	 	,	progressCallback : function( progressBarObj ) {

 	 	 			return percent;
 	 	 		}
 	 	 	});   			
 		}else{
 			percent = 100;
 		}
 	}	
 	
    
</script>

<body>
<div class="pop_wrap" style="border: none;">  <!-- window 750*499 -->
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("","비밀번호 초기화 요청")%></h1>
	</div>	
	
	<div class="pop_con">
		<p class="tit_p"><%=BizboxAMessage.getMessage("","요청 사용자")%></p>
		
		<div id="grid"></div>

		<p class="tit_p mt30 mb7"><%=BizboxAMessage.getMessage( "TX900000146", "로그인/ 결재/ 급여비밀번호초기화" )%></p>
		<p><%=BizboxAMessage.getMessage( "TX900000147", "사용자 로그인 시 재설정 체크박스를 선택하면,사용자 로그인 시 비밀번호 재설정이 필요합니다." )%></p>
		<div class="com_ta mt10">
			<table>
				<colgroup>
					<col width="140"/>
					<col width="">
				</colgroup>
				<tr>
					<th><img src="/gw/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage( "TX900000148", "초기화비밀번호" )%></th>
					<td>
						<input id="changePass" type="password" autocomplete="new-password" style="width:150px;" class="puddSetup" value=""/>
						<span class="fr mt5"><input id="loginSetCheck" type="checkbox" value="1" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage( "TX900000149", "사용자 로그인 시 재설정" )%>" checked disabled /></span>
					</td>
				</tr>
			</table>
		</div>
	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="puddSetup submit" onclick="ok();" value="<%=BizboxAMessage.getMessage( "TX000000078", "확인" )%>" />
			<input type="button" class="puddSetup" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage( "TX000002947", "취소" )%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!--// pop_wrap -->

<div id="ProgressBar"></div>

</body>
</html>






