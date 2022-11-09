<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script type="text/javascript">
	/* 테이블용 변수  */
	var groupSeq = "${loginVo.groupSeq}";
	var selectTableList = [${list}];
	var mainStep 	= 1;
	var subStep 	= 1;
	var SelectTable = 1;
	var errorTable = null;
	var errorEndCount = null;	
	var errorStop = "N"
	/* 시간체크 변수  */
	var selectTotal = 0;
	var insertTotal = 0;
	var tableTime = 0;
	var totalTime = 0;
	var percent = 0;
	/* 메인버튼 변수 */
	var table;
	var queryCorrection = "N"; /* 데이터 보정 값  */
	var interCorrection = "N"; /* 연동 보정 값 */
	var fileDateTransfer = "N"; /* 파일 데이터 이관 값  */
	/* B1 > ASP > Alpha 변수 */
	var AlphaFormCount = -1;
	var AlphaFormFolderCount = -1;
	var b1FormYN = "N"
	/* 보정쿼리 변수 */
	var scriptStartNum;
	/* 이관 카운트 변수 */
	var searchCount;
	var basicCount;
	/* 문서 카운트 변수 */
	var maxContentsSize = -1;
	var maxMigDocSize = -1
	/* 회사 코드 변수 */
	var compSeqList = new Array();
	var compListCount;
	
	$(document).ready(function() {
		/* 무단 보정막기 위한 보정쿼리 숨김  */
		$("#btnQueryCorrection").hide();
		/* View용 테이블 호출 */
		tableList();
		
		if(groupSeq == null || groupSeq == "") {
			alert("로그인을 먼저 하시길 바랍니다.");
		}
		
		//데이터 보정만 해야할 경우 히든 버튼
		$("#test2").click(function(){
			$("#btnQueryCorrection").show();
			queryCorrection = "Y";
		});
		/*  파일 인코딩 */
		$("#encoding").click(function(){
			encoding();
		});	
		
		/* 데이터 이관 버튼*/
		$("#btnDataTransfer").click(function(){
			if(groupSeq == null || groupSeq == "") {
				alert("로그인을 먼저 하시길 바랍니다.");
				return;
			}
			
			if (!confirm("******************!!중요 중요!!*********************\n 전자결재 관련한 (모든 데이터가 삭제)됩니다.\n진행하시겠습니까?\n ")) {
				return;
			}
			
			fndataBackUp();

		});
		
		/* 데이터 선택 이관 버튼*/
		$("#btnDataSelectTransfer").click(function(){
			if(groupSeq == null || groupSeq == "") {
				alert("로그인을 먼저 하시길 바랍니다.");
				return;
			}
			
			if (!confirm("******************!!중요 중요!!*********************\n 데이터 선택 이관 입니다.\n 이관시 에러가 나지 않았으면 돌리지 마세요.")) {
				return;
			}
			
			fndataSelectBackUp();

		});
		
		/* 에러 테이블 지속 이관 버튼 (테이블 삭제 X) */
		$("#btnErrorTransfer").click(function(){
			
			if (!confirm("******************!!중요 중요!!*********************\n 에러테이블 지속이관 버튼입니다.\n이관시 에러가 나지 않았으면 돌리지 마세요.")) {
				return;
			}
			
			fnErrorTransfer();

		});
		
		/* 데이터 보정 버튼 */
		$("#btnQueryCorrection").click(function(){
			if(groupSeq == null || groupSeq == "") {
				alert("로그인을 먼저 하시길 바랍니다.");
				return;
			}
			
			if (!confirm("******************!!중요 중요!!*********************\n 데이터 이관 후 보정 하시기 바랍니다. \n진행하시겠습니까?\n ")) {
				return;
			}
			
			fnQueryCorrection();
		});
		
		/* 데이터 연동보정 버튼  */
		$("#btnInter").click(function(){
			if (!confirm("******************!!중요 중요!!*********************\n 전자결재 데이터가 (모두 이관 된 후 진행)해야 됩니다.\n진행하시겠습니까?")) {
				return;
			}
			
			Pudd( "#fileYN" ).getPuddObject().setChecked( false );
			
			makeInterlockMig();
		});
		
		/* 연동보정에러 보정 버튼 */
		$("#btnInterError").click(function(){
			if (!confirm("******************!!중요 중요!!*********************\n  연동본문의 변환 안된 xml데이터 오류만 보정합니다.\n진행하시겠습니까?")) {
				return;
			}
			
			loadingShow();
			interlockErrorModify();
		});
		
		
		/* 이전문서 이관 버튼 */
		$("#btnTransferredDocDataTransfer").click(function(){
			if(groupSeq == null || groupSeq == "") {
				alert("로그인을 먼저 하시길 바랍니다.");
				return;
			}
			
			if (!confirm("******************!!중요 중요!!*********************\n 결재문서가 이전문서로 이관됩니다.\n진행하시겠습니까?\n ")) {
				return;
			}
			
			// 이전문서 테이블 백업
			fnTransferredDocDataBackUp();
		});
		
		/* 항목별 첨부파일 데이터 이관 버튼 */
		$("#btnFileDataTransfer").click(function(){
			if(groupSeq == null || groupSeq == "") {
				alert("로그인을 먼저 하시길 바랍니다.");
				return;
			}
			
			if (!confirm("******************!!중요 중요!!*********************\n 항목별 첨부파일 데이터가 이관됩니다.\n진행하시겠습니까?\n ")) {
				return;
			}
			
			// 항목별 첨부파일 데이터 이관
			fnFiledataBackUp();
		});
		
		//항목별 첨부파일 이관여부 
		fileYN();		
		//테이블 리스트
		selectTableView();
		//체크박스 호출
		b1FormCheck();
		oneTableTransferCheck();
		// 부분회사 이관 체크박스 생성
		partCompDataExport();
		
	});
	
	// 정상적인 백업 프로세스
	function fndataBackUp() {	
		loadingShow();
		if(Pudd( "#b1FormYN" ).getPuddObject().getChecked()){
			b1FormYN = Pudd("#b1FormYN").getPuddObject().val();
		}
	    $.ajax({
	    	  async			: true
	    	, type			: "GET"
			, url			: "<c:url value='/mig/dataBackUp.do'/>" 
			, data			: {b1FormYN : b1FormYN}
			, success		: function(data) {
				if(data.result == "1") {
					fndataExport(); /* 데이터 이관 */
				}
			}, error 			: function (err) {
				if(err.state == "504"){
					alert("데이터 백업 중 게이트웨이 타임아웃이 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
				}else{
					alert("데이터 백업 중 에러가 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
				}
					loadingHide();
				}
		});
	}
	
	function fndataSelectBackUp() {	
		loadingShow();
		if(Pudd( "#b1FormYN" ).getPuddObject().getChecked()){
			b1FormYN = Pudd("#b1FormYN").getPuddObject().val();
		}
		SelectTable = Pudd("#selectTable").getPuddObject().val();
	    $.ajax({
	    	  async			: true
	    	, type			: "GET"
			, url			: "<c:url value='/mig/dataBackUp.do'/>" 
			, data			: { SelectTable : SelectTable , b1FormYN : b1FormYN}
			, success		: function(data) {
				if(data.result == "1") {
					fndataSelectExport(SelectTable); /* 데이터 이관 */
				}
			}, error 			: function (err) {
				if(err.state == "504"){
					alert("데이터 백업 중 게이트웨이 타임아웃이 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
				}else{
					alert("데이터 백업 중 에러가 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
				}
					loadingHide();
				}
			
		});
	    
	}
	
	//정상적인 이관 프로세스
	function fndataExport() {	
		
		mainStep 	= 1;
		subStep 	= 1;
		pageStart 	= 1;
		pageEnd 	= $("#basicNum").val();		
		grpId		= $("#suiteGrpId").val(); 	
		searchCount = $("#startNum").val();
		basicCount  = $("#basicNum").val();
		// compSeq = $("#compSeq").val()
		
		// 초기화
		compSeqList = new Array();
		
		// compSeqList
		for(var i = 0; i < compListCount; i++) {		
			var chkBoxId = "compChkBox" + i
			if(Pudd( "#"+chkBoxId ).getPuddObject().getChecked()) {
				compSeqList.push( Pudd("#"+chkBoxId).getPuddObject().val() )
			}
		}
		
		AlphaFormCount = -1;
		AlphaFormFolderCount = -1;
		if(Pudd( "#b1FormYN" ).getPuddObject().getChecked()){
			b1FormYN = Pudd("#b1FormYN").getPuddObject().val();
		}
		setTimeout(function() {insertPolling();}, 100);
	}
	// 테이블 이관 오류시 특정 테이블 부터 실행 시킬 메서드 
	function fndataSelectExport(Table) {	
		
		mainStep 	= 1;
		subStep 	= Table;
		pageStart 	= 1;
		if(Table == 38 || Table == 39){
			pageEnd 	=  $("#startNum").val(); 		
		}else{
			pageEnd 	= $("#basicNum").val();	
		}
		AlphaFormCount = -1;
		AlphaFormFolderCount = -1;
		searchCount = $("#startNum").val();
		basicCount  = $("#basicNum").val();
				
		grpId		= $("#suiteGrpId").val(); 	
		if(Pudd( "#b1FormYN" ).getPuddObject().getChecked()){
			b1FormYN = Pudd("#b1FormYN").getPuddObject().val();
		}

		// 초기화
		compSeqList = new Array();
		
		// compSeqList
		for(var i = 0; i < compListCount; i++) {		
			var chkBoxId = "compChkBox" + i
			if(Pudd( "#"+chkBoxId ).getPuddObject().getChecked()) {
				compSeqList.push( Pudd("#"+chkBoxId).getPuddObject().val() )
			}
		}
		
		setTimeout(function() {insertPolling();}, 100);
	}
	/* Timeout 에러시 지속이관 함수  */
	function fnErrorTransfer() {	
		
		mainStep 	= 1;
		subStep 	= errorTable;
		pageStart 	= Number(errorEndCount);
		Table =  Pudd("#selectTable").getPuddObject().val();
		if(subStep == null || pageStart == null ){
			subStep 	= Table;
			pageStart 	= 1;
			errorEndCount = 0;
		}
		if(Table == 38 || Table == 39){
			pageEnd 	=  Number(errorEndCount) + Number($("#startNum").val()); 		
		}else{
			pageEnd 	= Number(errorEndCount) + Number($("#basicNum").val());	
		}
		if (!confirm("아래 사항을 확인해 주세요 \n subStep : " + subStep + "\n pageStart : " + pageStart + "\n pageEnd : " + pageEnd )){
			return;
		}
		searchCount = $("#startNum").val();
		basicCount  = $("#basicNum").val();
		
		grpId		= $("#suiteGrpId").val(); 	
		if(Pudd( "#b1FormYN" ).getPuddObject().getChecked()){
			b1FormYN = Pudd("#b1FormYN").getPuddObject().val();
		}
		if(Pudd( "#oneTableTransferYN" ).getPuddObject().getChecked()){
			errorStop = Pudd("#oneTableTransferYN").getPuddObject().val();
		}
		
		// 초기화
		compSeqList = new Array();
		
		// compSeqList
		for(var i = 0; i < compListCount; i++) {		
			var chkBoxId = "compChkBox" + i
			if(Pudd( "#"+chkBoxId ).getPuddObject().getChecked()) {
				compSeqList.push( Pudd("#"+chkBoxId).getPuddObject().val() )
			}
		}	
		
		if(errorStop == "N"){
		setTimeout(function() {insertPolling();}, 100);
		}else{
		setTimeout(function() {ErrorTableInsertPolling();}, 100);	
		}
	}
	/* 진행형 테이블 이관 */
	function insertPolling() {
		$.ajax({
			async			: true,
			type			: "post",
			url				: "<c:url value='/mig/dataExport.do'/>",
			datatype		: "json",
			traditional 	: true,
			data			: {   mainStep : mainStep, subStep : subStep, pageStart : pageStart
								, pageEnd : pageEnd, grpId : grpId, tableTime : tableTime , totalTime : totalTime 
								, AlphaFormCount : AlphaFormCount , AlphaFormFolderCount : AlphaFormFolderCount, b1FormYN : b1FormYN, searchCount : searchCount 
								, basicCount : basicCount ,maxContentsSize : maxContentsSize, maxMigDocSize : maxMigDocSize, compSeqList:compSeqList },
			success			: function (data) {
				
				if (table != data.tableName){
					selectTotal = 0;
					insertTotal = 0;
					totalTime += parseInt(tableTime);
					tableTime = 0;
				}
				table = data.tableName;
				AlphaFormCount = data.AlphaFormCount;
				AlphaFormFolderCount = data.AlphaFormFolderCount;
				selectTotal += data.selectTotal;
				insertTotal += data.insertTotal;
				tableTime = (insertTotal + selectTotal).toFixed(0);
				
			 	var resultLog = "[ "+data.tableName+" ]" + data.pageStart + " ~ " + data.pageEnd + " : " + data.resultMsg
				$("#"+data.tableName).css("background-color","#FFD232");
				 
				$("#resultDiv").html(resultLog);
				maxContentsSize = data.maxContentsSize;
				maxMigDocSize = data.maxMigDocSize;
				if (data.mainStep == 0) {
					loadingHide();
					$("#connectMsg2").html("<p style='background-color:#FFD232;'>데이터 이관이 완료되었습니다.</p>")
					
					if(data.queryCorrection == "Y"){
						$("#btnQueryCorrection").show();
						queryCorrection = data.queryCorrection;
						  if(queryCorrection == "Y"){
								console.log("데이터 이관 완료");
								fnQueryCorrection(); /* 데이터 보정  */
								}						
					}
					
					return;
				}
				
				// 테이블 데이터 백업 완료
				if(data.mainStep == 1) {
					if (data.subStep > 0) {
						mainStep = 1;
						if (data.pageStart == 1) {
							subStep++;
						}
						pageStart = data.pageStart;
						pageEnd = data.pageEnd;
						errorEndCount = data.pageStart;
						errorTable = data.subStep;
						setTimeout(function() {insertPolling();}, 100);
					} else {
						loadingHide();
						alert("데이터 이관이 완료되었습니다.");
						return;
					}
				}
			},
			
			error 			: function (err) {
				$("#"+table).css("background-color","#FF0000");
				alert("데이터 이관도중 오류가 발생하였습니다.");
				loadingHide();
			},
			
			complete : function() {
				if(fileDateTransfer == "Y"){
					console.log("첨부파일 데이터 보정 완료");
					fnFiledataBackUp();/* 첨부파일 데이터 이관  */
				}    
		    }
		});
	}
	
	/* 단일 테이블 이관 */
	function ErrorTableInsertPolling() {
		$.ajax({
			async			: true,
			type			: "post",
			url				: "<c:url value='/mig/dataExport.do'/>",
			datatype		: "json",
			data			: {   mainStep : mainStep, subStep : subStep, pageStart : pageStart
								, pageEnd : pageEnd, grpId : grpId, tableTime : tableTime , totalTime : totalTime 
								, AlphaFormCount : AlphaFormCount , AlphaFormFolderCount : AlphaFormFolderCount, b1FormYN : b1FormYN, searchCount : searchCount 
								, basicCount : basicCount ,maxContentsSize : maxContentsSize, maxMigDocSize : maxMigDocSize},
			success			: function (data) {
				
				if (table != data.tableName){
					selectTotal = 0;
					insertTotal = 0;
					totalTime += parseInt(tableTime);
					tableTime = 0;
				}
				table = data.tableName;
				AlphaFormCount = data.AlphaFormCount;
				AlphaFormFolderCount = data.AlphaFormFolderCount;
				selectTotal += data.selectTotal;
				insertTotal += data.insertTotal;
				tableTime = (insertTotal + selectTotal).toFixed(0);
				
			 	var resultLog = "[ "+data.tableName+" ]" + data.pageStart + " ~ " + data.pageEnd + " : " + data.resultMsg
				$("#"+data.tableName).css("background-color","#FFD232");
				 
				$("#resultDiv").html(resultLog);
				maxContentsSize = data.maxContentsSize;
				maxMigDocSize = data.maxMigDocSize;
				if (data.mainStep == 0) {
					loadingHide();
					$("#connectMsg2").html("<p style='background-color:#FFD232;'>데이터 이관이 완료되었습니다.</p>")
					return;
				}
				
				// 테이블 데이터 백업 완료
				if(data.mainStep == 1) {
					if (data.subStep > 0) {
						mainStep = 1;
						if (data.pageStart == 1) {
							alert( table+" 테이블  이관이 완료되었습니다.");
							loadingHide();
							return;
						}
						pageStart = data.pageStart;
						pageEnd = data.pageEnd;
						errorEndCount = data.pageStart;
						errorTable = data.subStep;
						setTimeout(function() {ErrorTableInsertPolling();}, 100);
					} else {
						loadingHide();
						alert("데이터 이관이 완료되었습니다.");
						return;
					}
				}
			},
			
			error 			: function (err) {
				$("#"+table).css("background-color","#FF0000");
				alert("데이터 이관도중 오류가 발생하였습니다.");
				loadingHide();
			}

		});
	}
	
	
	
	
	function fnFileDataExport(){
					
			mainStep 	= 1;
			subStep 	= 1;
			pageStart 	= 1;
			pageEnd 	= 100;		
			grpId		= $("#suiteGrpId").val(); 	
			
			setTimeout(function() {fileDateInsertPolling();}, 100);
	}
		
		
	function fileDateInsertPolling() {
		$.ajax({
			async			: true,
			type			: "post",
			url				: "<c:url value='/mig/fileDataExport.do'/>",
			datatype		: "json",
			data			: {   mainStep : mainStep, subStep : subStep, pageStart : pageStart
								, pageEnd : pageEnd, grpId : grpId, tableTime : tableTime , totalTime : totalTime},
			success			: function (data) {
				
				if (table != data.tableName){
					selectTotal = 0;
					insertTotal = 0;
					totalTime += parseInt(tableTime);
					tableTime = 0;
				}
				table = data.tableName;
				
				selectTotal += data.selectTotal;
				insertTotal += data.insertTotal;
				tableTime = (insertTotal + selectTotal).toFixed(0);
				
			 	var resultLog = "[ "+data.tableName+" ]" + data.pageStart + " ~ " + data.pageEnd + " : " + data.resultMsg
				 
				$("#resultDiv").html(resultLog);
				
				if (data.mainStep == 0) {
					loadingHide();
					$("#connectMsg3").html("<p style='background-color:#FFD232;'>파일 데이터 이관이 완료되었습니다.</p>")
					return;
				}
				
				// 테이블 데이터 백업 완료
				if(data.mainStep == 1) {
					if (data.subStep > 0) {
						mainStep = 1;
						if (data.pageStart == 1) {
							subStep++;
						}
						pageStart = data.pageStart;
						pageEnd = data.pageEnd;
						setTimeout(function() {fileDateInsertPolling();}, 100);
					} else {
						loadingHide();
						alert("파일 데이터 이관 이관이 완료되었습니다.");
						return;
					}
				}
			},
			
			error 			: function (err) {
				alert("파일 데이터 이관 이관도중 오류가 발생하였습니다.");
				loadingHide();
			}
		});
	}
		
	
	function fnFiledataBackUp() {	
		loadingShow();
	    $.ajax({
	    	  async			: true
	    	, type			: "GET"
			, url			: "<c:url value='/mig/fileDataBackUp.do'/>" 
			, success		: function(data) {
				if(data.result == "1") {
					fnFileDataExport(); /* 파일데이터 이관 */
				}
			}, error 			: function (err) {
				if(err.state == "504"){
					alert("데이터 백업 중 게이트웨이 타임아웃이 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
				}else{
					alert("데이터 백업 중 에러가 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
				}
					loadingHide();
				}
		});
	}
	
	
	//전체 테이블 리스트 목록
	function tableList(){
		var tableTag = "<table>";
		tableTag +=        "<td id='left'></td>";
		tableTag +=        "<td id='right'></td>"
		tableTag +=    "</table>";
		$("#tableList").append(tableTag);
		
		for(var key in selectTableList) {
			if (key > (selectTableList.length/2)){
				$("#right").append("<p style='margin:1px;' id = "+selectTableList[key].value+">&nbsp"+ selectTableList[key].value +"</p>");
			}else{
			  $("#left").append("<p style='margin : 1px;'id = "+selectTableList[key].value+">&nbsp"+ selectTableList[key].value +"</p>");
			}
		}
		
	}	
	
	//셀렉트 테이블 리스트
	 function selectTableView(){
		// Pudd DataSource 매핑
		var dataSourceComboBox = new Pudd.Data.DataSource({
		 
			data : selectTableList
		});
		 
		Pudd( "#selectTable" ).puddComboBox({
		 
				attributes : { style : "width:220px; margin-right:5px" }// control 부모 객체 속성 설정
			,	controlAttributes : { id : "exAreaSelectBox" }// control 자체 객체 속성 설정
			,	dataSource : dataSourceComboBox
			,	dataValueField : "key"
			,	dataTextField : "value"
			,	selectedIndex : 0
			,	disabled : false
			,	scrollListHide : false
			
			,	template : function( rowData ) {
				 
				var html = rowData.key+'번 ' + rowData.value ;
				return html;
			}
		 
			//,	dataCountCheckShowList : false	// 기본값 false
		 
				// Pudd SelectBox는 내부에서 UI 부분을 재구성하여 표현하는 관계로 제공되는 이벤트만 설정가능
				// 이벤트 설정을 하고자 하는 경우 아래 주석를 해제하고 해당 이벤트 설정하면 됨
				// 제공되는 이벤트 : change
			//,	eventCallback : {
			//		"change" : function( e ) {
			//			console.log( "change" );
			//		}
			//	}
		});
	 }
	
	function fileYN(){
		
		Pudd( "#fileYN" ).puddCheckBox({
			 
			attributes : {}// control 부모 객체 속성 설정
		,	controlAttributes : { id : "exAreaCheckBox" }// control 자체 객체 속성 설정
		,	value : "Y"
		,	checked : false
		,	disabled : false
		,	label : "파일데이터 이관 여부"
		,	checkType : ""
		,	checkAlign : "right"	// left(기본값) : checkBox + 텍스트, right : 텍스트 + checkBox
		});
		
	}
	

	function b1FormCheck(){
		
		Pudd( "#b1FormYN" ).puddCheckBox({
			 
			attributes : {style : "margin:5px;"}// control 부모 객체 속성 설정
		,	controlAttributes : { id : "exAreaCheckBox" }// control 자체 객체 속성 설정
		,	value : "Y"
		,	checked : true
		,	disabled : false
		,	label : "B1 > ASP > Alpha 마이그레이션의 경우 체크를 해제하세요."
		,	checkType : ""
		,	checkAlign : "right"	// left(기본값) : checkBox + 텍스트, right : 텍스트 + checkBox
		});
		
	}
	
	function oneTableTransferCheck(){
		
		Pudd( "#oneTableTransferYN" ).puddCheckBox({
			 
			attributes : {style : "margin:5px;"}// control 부모 객체 속성 설정
		,	controlAttributes : { id : "exAreaCheckBox" }// control 자체 객체 속성 설정
		,	value : "Y"
		,	checked : false
		,	disabled : false
		,	label : "단일테이블만 이관하실경우 체크하세요."
		,	checkType : ""
		,	checkAlign : "right"	// left(기본값) : checkBox + 텍스트, right : 텍스트 + checkBox
		});
		
	}	
	function fnQueryCorrection() {
		loadingShow();
		grpId		= $("#suiteGrpId").val();
		docCount 	= $("#docCount").val();
		if(Pudd( "#b1FormYN" ).getPuddObject().getChecked()){
			b1FormYN = Pudd("#b1FormYN").getPuddObject().val();
		}
		scriptStartNum = 1;
		startNum = 1;
		correcNum = parseInt($("#correcNum").val());
		endNum = correcNum;
		
		setTimeout(function() {fnQueryCorrectionPolling();}, 100);
	}
	
	function fnQueryCorrectionPolling(){
		$.ajax({
		async			: false,
		type			: "post",
		 url			: "<c:url value='/mig/queryCorrection.do'/>", 
		datatype		: "json",
		data			: {grpId : grpId, docCount : docCount ,queryCorrection : queryCorrection, b1FormYN : b1FormYN, scriptStartNum : scriptStartNum
							, startNum : startNum , endNum : endNum },
		success			: function (data) {
				if(data.result == "1") {
					loadingHide();
					$("#connectMsg").html("<p style='background-color:#FFD232;'>데이터 보정이 완료되었습니다.</p>");
					makeInterlockMig();/* 연동 보정  */
				}else if(data.result == "0"){
					$("#connectMsg").html("<p style='background-color:#3af96d;'>"+scriptStartNum+" << 13 종료 >> "+data.startDocId+" ~ "+data.endDocId+"</p>");
					startNum = data.startDocId + correcNum;
					endNum = data.endDocId + correcNum;
					if(scriptStartNum != 13 && scriptStartNum != "test"){
						setTimeout(function() {fnQueryCorrectionPolling();}, 100);
					}
				}else{
					$("#connectMsg").html("<p style='background-color:#3af96d;'>"+scriptStartNum+" << 13 종료 >> "+data.startDocId+" ~ "+data.endDocId+"</p>");
					startNum = 1;
					endNum = correcNum;
					scriptStartNum ++;
					setTimeout(function() {fnQueryCorrectionPolling();}, 100);
				}
		},
		
		error 			: function (err) {
			
			if(err.state == "504"){
				alert("데이터 보정 중 게이트웨이 타임아웃이 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
			}else{
				alert("데이터 보정 중 에러가 발생하였습니다.\n state : "+ err.state + "\n statusText : " + err.statusText);
			}
				loadingHide();
			}
		});
		
	}	
	
	// 연동양식 정보 생성
	function makeInterlockMig() {
		
		loadingShow();
		var interParam = {};
		$.ajax({
			async : true,
			type : "post",
			url	: "<c:url value='/mig/makeInterlockFromMig.do'/>",
			datatype : "json",
			data : interParam,
			success	: function (data) {
				if(data.result.result == "1") {
					insertInterlockPolling();
					console.log("연동 보정 완료");
				} else if(data.result.result == "10") {
					$("#resultDiv").html("해당 고객사는 연동문서가 없습니다. 양식 복사를 진행합니다.");
					formEditCopy();
				} else if(data.result.result == "20") {
					loadingHide();
					alert(data.result.message);
				} else {
					loadingHide();
					alert("연동문서 본문 데이터 생성시 오류가 발생했습니다.");
				}
			},
			error : function (err) {
				loadingHide();
				alert("연동문서 본문 데이터 생성시 오류가 발생했습니다.");
			}


		
		});
		
	}
	
	function partCompDataExport() {

		var interParam = {};
		$.ajax({
			async : true,
			type : "post",
			url	: "<c:url value='/mig/partCompDataExport.do'/>",
			datatype : "json",
			data : interParam,
			success	: function (data) {
				console.log( "호출성공 : " + JSON.stringify(data.list));								
					
				compListCount = data.list.length;
				var chkBoxId = "";
				var chk = "<div id='compChkBox'></div>";
				
				
				for(var i = 0; i < compListCount; i++) {					
					chkBoxId = "compChkBox" + i
					data.list[i].chkBoxId = chkBoxId;
					chk += '<div id=' + chkBoxId + '></div>'					
				}
				$("#compChkBoxList").html(chk);
				
				// 전체 선택박스 생성 
				Pudd( "#compChkBox" ).puddCheckBox({						 
					attributes : {}// control 부모 객체 속성 설정
				,	controlAttributes : { id : "exAreaCheckBox" }// control 자체 객체 속성 설정
				,	value : ""
				,	checked : true
				,	disabled : false
				,	label : "전체"
				,	checkType : ""
				,	checkAlign : "right"	// left(기본값) : checkBox + 텍스트, right : 텍스트 + checkBox
				});
					
				// 회사 선택박스 생성
				for(var i = 0; i < compListCount; i++) {
					makeChkBox(data.list[i].chkBoxId, data.list[i].co_nm_kr, data.list[i].co_id);
				} 
			},
			error : function (err) {
				alert("회사정보 조회 중 오류가 발생하였습니다..");
			}	
		});
	}
	
	function makeChkBox(chkBoxId, compName, compId) {		
		Pudd( "#"+chkBoxId ).puddCheckBox({						 
			attributes : { style : "float: left;"}// control 부모 객체 속성 설정
		,	controlAttributes : { id : "exAreaCheckBox" }// control 자체 객체 속성 설정
		,	value : compId
		,	checked : false
		,	disabled : false
		,	label : compName
		,	checkType : ""
		,	checkAlign : "right"	// left(기본값) : checkBox + 텍스트, right : 텍스트 + checkBox
		});		
	}
	
	function encoding() {
		
		loadingShow();
		var interParam = {};
		$.ajax({
			async : true,
			type : "post",
			url	: "<c:url value='/mig/encoding.do'/>",
			datatype : "json",
			data : interParam,
			success	: function (data) {
				$("#encodingMsg").html("인코딩이 완료 되었습니다.");		
				$("#encodingMsg").css("background-color","#FFD232");
				loadingHide();
			},
			error : function (err) {
				loadingHide();
				alert(" 인코딩 중에 오류가 발생하였습니다 " + err );
			}


		
		});
		
	}
	
	function interlockErrorModify(){
		
		var interErrorParam = {};
		interErrorParam.mainStep = interMainStep;
		interErrorParam.pageStart = interPageStart;
		interErrorParam.pageEnd = $("#interNum").val();
		interErrorParam.grpId = $("#suiteGrpId").val();
		
		$.ajax({
			async : true,
			type : "post",
			url	: "<c:url value='/mig/interlockErrorModify.do'/>",
			datatype : "json",
			data : interErrorParam,
			success	: function (data) {
				
				// 연동 보정 완료
				if (data.mainStep == 0) {
					alert("데이터 보정이 완료되었습니다.");
					loadingHide();
					return;
				}
				// 100개씩 연동보정
				if(data.mainStep == 1) {
					
					interPageStart = data.pageStart;
					interPageEnd = data.pageEnd;
					$("#resultDiv").html(data.resultMsg);
					setTimeout(function() {interlockErrorModify();}, 100);
				}
				
			},
			error : function (err) {
				loadingHide();
				alert("연동 본문 보정시 오류가 발생했습니다.");
			}
		});
	}
	

	var interMainStep = 1;
	var interPageStart = 1;
	var interPageEnd = 10;
	// 연동 데이터와 양식 연동 본문 조합하여 html로 변환
	function insertInterlockPolling() {
		var interParam = {};
		interParam.mainStep = interMainStep;
		interParam.pageStart = interPageStart;
		if (interParam.pageStart == 1){
			interParam.pageEnd = parseInt($("#interNum").val());
		}else{
			interParam.pageEnd = interPageEnd
		}
		interParam.grpId = $("#suiteGrpId").val();
		interParam.interNum = $("#interNum").val();
		
		$.ajax({
			async : true,
			type : "post",
			url : "<c:url value='/mig/interDataExport.do'/>",
			datatype : "json",
			data : interParam,
			success : function (data) {
				
				// 데이터 생성 완료
				if (data.mainStep == 0) {
					formEditCopy();
					//데이터 최기화
					interMainStep = 1;
					interPageStart = 1;
					interPageEnd = $("#startNum").val();;
					return;
				}
				
				// 100개씩 데이터 생성
				if(data.mainStep == 1) {
					
					interPageStart = data.pageStart;
					interPageEnd = data.pageEnd;
					$("#resultDiv").html(data.resultMsg);
					setTimeout(function() {insertInterlockPolling();}, 100);
				}
			},
			
			error : function (err) {
				alert("연동문서 본문내용 이관중 오류가 발생하였습니다.");
				loadingHide();
			}
		});
	}
	
	
	// 연동문서 연동코드 삽입후 alpha폴더로 카피
	function formEditCopy() {
		$("#resultDiv").html("----------------연동문서 본문 치완 및 결재문서 복사중입니다.---------------------");
		if(Pudd( "#b1FormYN" ).getPuddObject().getChecked()){
			b1FormYN = Pudd("#b1FormYN").getPuddObject().val();
		}
		$.ajax({
			async : true,
			type : "post",
			url : "<c:url value='/mig/formEditCopy.do'/>",
			datatype : "json",
			data : {b1FormYN : b1FormYN},
			success : function (data) {
				loadingHide();
				$("#connectMsg1").html("결재양식 이관 복사 완료되 었습니다.");
				$("#resultDiv").html("");
				
				var fileCheck = Pudd( "#fileYN" ).getPuddObject();
				
				if (fileCheck.getChecked() == false){
					TimerStart();	
				}else{
					fileDateTransfer = 'Y';
				}
			},
			
			error : function (err) {
				alert("연동문서 본문내용 이관중 오류가 발생하였습니다.");
				loadingHide();
			}
		});
	}
	
	
	function loading(onoff) {
    	if (onoff == "on") {
    		if($("#viewLoading").css("display") != "block"){
 		   	   $("#viewLoading").css("width", "100%");
 		       $("#viewLoading").css("height", "100%");
 		       $("#viewLoading").fadeIn(100);    		
 		   }
    	} else {
    		$("#viewLoading").fadeOut(200);
    	}
    	
    }
	
	
	function loadingShow() {
		// progressType - loading
		Pudd( "#exArea" ).puddProgressBar({
		 
			progressType : "loading"
		,	attributes : { style:"width:70px; height:70px;" }
		 
		,	strokeColor : "#84c9ff"	// progress 색상
		,	strokeWidth : "3px"	// progress 두께
		 
		,	percentText : "loading"	// loading 표시 문자열 설정 - progressType loading 인 경우만
		,	percentTextColor : "#84c9ff"
		,	percentTextSize : "12px"
		 
			// 배경 layer 설정 - progressType loading 인 경우만
		,	backgroundLayerAttributes : { style : "background-color:#000;filter:alpha(opacity=20);opacity:0.2;width:100%;height:100%;position:fixed;top:0px; left:0px;" }
		 
			// 200 millisecond 마다 callback 호출됨
		,	progressCallback : function( progressBarObj ) {
		 
				// 예제로 임의로 구성함
				//var percent = cnt++;
		 
				// 전달되는 값이 100 이상이면 callback 종료
				// null 값 전달되어도 callback 종료
				//return percent;
				return percent;
			}
		});
		
	}
	
	function loadingHide() {
		Pudd("#exArea").getPuddObject().clearIntervalSet();
	}
	
	
	// 이전문서 테이블 백업
	function fnTransferredDocDataBackUp() {	
		loadingShow();
	    $.ajax({
	    	  type			: "GET"
			, url			: "<c:url value='/mig/transferredDocDataBackUp.do'/>" 
			, success		: function(data) {
				if(data.result == "1") {
					// 이전문서 데이터 마이그레이션
					insertPollingTransferredData();
				}
			}, error 			: function (err) {
				alert("이전문서 데이터 백업 및 초기화도중 에러가 발생하였습니다.");
				loadingHide();
			}
		});
	}
	
	
	
	
	var transferredMainStep = 1;
	var transferredSubStep = 1;
	var transferredPageStart = 1;
	var transferredPageEnd = 100;
	
	// 이전문서 데이터 마이그레이션
	function insertPollingTransferredData() {
		
		var transferredParam = {};
		transferredParam.mainStep = transferredMainStep;
		transferredParam.subStep = transferredSubStep;
		transferredParam.pageStart = transferredPageStart;
		transferredParam.pageEnd = transferredPageEnd;
		transferredParam.grpId = $("#suiteGrpId").val();
		
		
		$.ajax({
			async : true,
			type : "post",
			url : "<c:url value='/mig/insertPollingTransferredData.do'/>",
			datatype : "json",
			data : transferredParam,
			success : function (data) {
				
				// 데이터 생성 완료
				if (data.mainStep == 0) {
					loadingHide();
					alert("data 이관 완료.");
					return;
				}
				
				// 100개씩 데이터 생성
				if(data.mainStep == 1) {
					
					var resultLog = data.resultMsg;
					
					$("#resultDiv").html(resultLog);
					
					if (data.subStep > 0) {
						transferredParam = 1;
						if (data.pageStart == 1) {
							transferredSubStep++;
						}
						transferredPageStart = data.pageStart;
						transferredPageEnd = data.pageEnd;
						
						setTimeout(function() {insertPollingTransferredData();}, 100);
					}
					
					/*
					transferredPageStart = data.pageStart;
					transferredPageEnd = data.pageEnd;
					$("#resultDiv").html(data.resultMsg);
					setTimeout(function() {insertPollingTransferredData();}, 100);
					*/
				}
			},
			
			error : function (err) {
				alert(" 이관중 오류가 발생하였습니다.");
				loadingHide();
			}
		});
		
	}
	
</script>

<script language="JavaScript">
	
		var SetTime = 30;		// 최초 설정 시간(기본 : 초)

		function msg_time() {	// 1초씩 카운트
			
		/* 	m = Math.floor(SetTime / 60) + "분 " + (SetTime % 60) + "초";	// 남은 시간 계산 */
			m = (SetTime % 60) + "초";	
			var msg = "이관 및 보정이 완료되어 <font color='red'>" + m + "</font> 후 box_seq 변경 페이지로 이동합니다. .";
			
			document.all.ViewTimer.innerHTML = msg;		// div 영역에 보여줌 
					
			SetTime--;					// 1초씩 감소
			
			if (SetTime < 0) {			// 시간이 종료 되었으면..
				
				clearInterval(tid);		// 타이머 해제
				location.href = "../ea/box/eaBoxAuto.do"
			}
			
		}

		function TimerStart(){ tid=setInterval('msg_time()',1000) };
				
	</script>

<body>
	
	<div id="exArea"></div>
	

	<div class="pop_wrap">
		<div class="pop_head">
			<h1>마이그레이션</h1>
			
			<input type="button" class="puddSetup" pudd-style="float: right;" value="박스 보정페이지로 이동" onclick = 'location.href = "../ea/box/eaBoxAuto.do"' />
		</div>

		<!--  suite 기본정보  -->
		<div class="pop_con">
			<div class="btn_top2">
				<h2>Suite 기본정보</h2>
			</div>
			<div class="com_ta">
				<table>										
					<tr>
						<th width="180px">Suite 고객사</th>							
						<td width="870px" id=customNameSuite>${suiteBaseInfoVO.grpCd }</td>		
						<th width="180px">Suite 데이터베이스</th>
						<td id=DBNameSuite >${suiteBaseInfoVO.dbName }</td>	
					</tr>
					<tr>
						<th width="180px">Suite 고객사</th>							
						<td width="870px">${suiteBaseInfoVO.fileIp}</td>			
						<th width="180px">Suite Form 인코딩</th>
						<td> 
							<input type="button" class="" id="encoding" value=" ANSI > UTF-8 ">
							<span class="" id="encodingMsg" style="font-color:#ff0000;"> </span>
						</td>	
					</tr>
				</table>
			</div>		
		</div><!-- //pop_con -->
		</br>
		
		<!--  suite 데이터 이관 -->
		<div class="pop_con">
			<div class="com_ta">
				<div class="btn_top2">
					<h2>결재함 마이그레이션(suite -> 결재함)</h2>
				</div>
				<table>
					<tr>
						<th width="180px">기본 데이터 이관 할 갯수</th>
						<td width="180px">
							<div class="posi_re">
 								<input type="text" class="fl ml5 mr5" id="basicNum" value="100"" >
							</div>
						</td>
						<th width="180px">본문 데이터 이관할 갯수 </th>
						<td width="180px">
							<div class="posi_re">
								<input type="text" class="fl ml5 mr5" id="startNum" value="10"" >
							</div>
						</td>
						<th width="180px">연동 데이터 이관할 갯수 </th>
						<td >
							<div class="posi_re">
								<input type="text" class="fl ml5 mr5" id="interNum" value="10"" >
							</div>
						</td>
						<th width="180px">보정 데이터 수정할 갯수 </th>
						<td >
							<div class="posi_re">
								<input type="text" class="fl ml5 mr5" id="correcNum" value="1000"" >
							</div>
						</td>
					</tr>
					<tr>
					<tr>
						<th width="180px">데이터 이관</th>
						<td colspan="5">
							<div class="posi_re">
 								<input type="button" class="fl" id="btnDataTransfer" value="이관">
 								<span class="" id="connectMsg2" style="font-color:#ff0000; float: right;"> </span>
							<!--  <input type="button" id="btnDataTransfer" name = "btnDataTransfer" class="psh_btn" value="<c:out value='${suiteBaseInfoVO.grpId}'/>">이관  -->
							<input type="hidden" id="suiteGrpId" name="suiteGrpId" value="<c:out value='${suiteBaseInfoVO.grpId}'/>" > 
							</div>
							<div id="b1FormYN"></div>
						</td>
					</tr>
						<th width="180px"> 회사단위로 데이터 이관 </th>
						<td id ="compChkBoxList" style="width : 1600px;">															
						</td>
					<tr>					
					</tr>
					<tr>
						<th width="180px"><div id="test1">데이터 선택이관</div></th>
						<td colspan="5">
							<div class="posi_re">
							<div id="selectTable" style="float: left;"></div>
 								<input type="button" id="btnDataSelectTransfer" value="선택이관">
 								<span class="" id="connectMsg2" style="font-color:#ff0000;"> ※ 선택된 테이블부터 이관 됩니다. 테이블을 선택하지 않을 시 전체 데이터 이관됩니다.</span>
							<input type="hidden" id="suiteGrpId" name="suiteGrpId" value="<c:out value='${suiteBaseInfoVO.grpId}'/>" > 
							</div>
						</td>
					</tr>
					<tr>
						<th width="180px">테이블 TimeOut Error</th>
						<td colspan="5">
							<div class="posi_re">
 								<input type="button" id="btnErrorTransfer" value="Error 지속 이관">
 								<span class="" id="connectMsg2" style="font-color:#ff0000;"> ※ 테이블을 삭제하지 않고 에러난 곳에서부터 이관을 진행합니다. 새로고침시 실행되지 않습니다.</span>
							<input type="hidden" id="suiteGrpId" name="suiteGrpId" value="<c:out value='${suiteBaseInfoVO.grpId}'/>" > 
							</div>
							<div id="oneTableTransferYN"></div>
						</td>
					</tr>
					<tr>
						<th width="180px"><div id="test2">데이터 보정</div></th>
						<td colspan="5">
							<div class="posi_re">
 								<input type="button" id="btnQueryCorrection" value="보정">※데이터 이관 완료 후 버튼이 나타납니다. *완료되지 않을 시 나타나지 않음 
 								<span class="" id="connectMsg" style="font-color:#ff0000; float: right;"> </span>
 								<input type="hidden" id="docCount" name="docCount" value="<c:out value='${docCount}'/>" >
							</div>
						</td>
					</tr>
					<tr>
						<th width="180px">연동본문 보정 및 연동문서 변환</th>
						<td colspan="5">
							<div class="posi_re">
 								<input type="button" id="btnInter" value="연동보정">
 								<input type="button" id="btnInterError" value="연동오류 보정" style="float:right">
 								<span class="" id="connectMsg1" style="font-color:#ff0000">※연동 보정시 연동문서 파일을 변환시키기 때문에 한번 실행후 다시 실행시 양식파일은 이관해야됩니다.</span>
							</div>
						</td>
					</tr>
					<tr>
						<th width="180px">항목별 첨부파일 데이터 이관</th>
						<td colspan="5">
							<div class="posi_re">
 								<input type="button" id="btnFileDataTransfer" value="첨부파일 데이터 이관">
 								<div id="fileYN"></div>
 								<span class="" id="connectMsg3" style="font-color:#ff0000; float: right;"> </span>
							</div>
						</td>
					</tr>
				</table> 
			</div>		
		</div><!-- //pop_con -->
		
		
		<!--  suite 데이터 이관 -->
		<div class="pop_con">
			<div class="com_ta">
				<div class="btn_top2">
					<h2>이전문서  마이그레이션(suite -> 이전문서함)</h2>
				</div>
				<table>
					<tr>
						<th width="180px">이전문서 데이터 이관</th>
						<td colspan="3">
							<div class="posi_re">
 								<input type="button" id="btnTransferredDocDataTransfer" value="이관">
							</div>
						</td>
					</tr>
				</table> 
			</div>		
		</div><!-- //pop_con -->
		
		<div id="resultDiv"></div>
		<div id="ViewTimer"></div>
		
		<div class="pop_con">
			<div class="btn_top2">
				<h2>테이블 진행 상황 리스트</h2>
			</div>
			<div class="com_ta">
						<div id="tableList"></div>	
			</div>		
		</div><!-- //pop_con -->
		
	</div><!-- //pop_wrap -->
</body>