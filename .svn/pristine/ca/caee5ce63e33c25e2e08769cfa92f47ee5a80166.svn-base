<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>


	<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.167.min.js"></script>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jszip-3.1.5.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/FileSaver-1.2.2_1.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jexcel-1.0.5.js"></script>


<script type="text/javascript">
		var ddlDataSource;
    	$(document).ready(function() {
    		if("${authDiv}" != "USER")
    	    	$("#authDiv").html("<%=BizboxAMessage.getMessage("TX000010881","관리자 등록건 보기")%>");
    	    else
    	    	$("#authDiv").html("<%=BizboxAMessage.getMessage("TX000010876","내가 등록한 주소록 보기")%>");
    		
    		
			//기본버튼
		    $(".controll_btn button").kendoButton();
			
		    $("#btnSearch").click(function () { fnSearch(); });
		    $("#btnExport").click(function () { fnExport(); });
		        
		    
		    //var ddlDivType = NeosCodeUtil.getCodeList("mp0007");
		    var ddlDivType = NeosCodeUtil.getCodeMultiList("mp0007",langCode.toLowerCase());
		    
			$("#ddlGroupDiv2").kendoComboBox({
		        dataSource : ddlDivType,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        sort:{field:"CODE_NM", dir:"asc"},
		        value:""
		    });			
			
			var dataSource = [{
				"CODE_EN": "",
				"CODE_NM": "<%=BizboxAMessage.getMessage("TX000000862","전체")%>",
				"CODE_ID": "mp0007",
				"CODE_DC": null,
				"CODE": "00"
			}];
			
			if(ddlDivType){
				dataSource = dataSource.concat(ddlDivType);	
			}
			
		    $("#ddlGroupDiv1").kendoComboBox({
		        dataSource : dataSource,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        value: "00"
		    });
			
			
			var tblParam = {};
			tblParam.adminAuth = "${authDiv}";
			    
			$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/mp/addr/GetGroupList.do"/>',
	    		data: tblParam,
	    		datatype:"text",
	    		async:false,
	    		success: function (data) {
		    				setAddrGroupDDlList(data.list);	    				
		    		    } ,
			    error: function (result) { 
			    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			    		}
	    	});
			
			
			//사진등록임시
			$(".phogo_add_btn").on("click",function(){
				$(".hidden_file_add").click();
			})
			
			controlInit();
			BindListGrid();
		});//document ready end
		
		function Bindgroupddl2(){
			if($("#ddlGroupDiv1").val() != "00")
			{
				var tblParam = {};
				tblParam.groupDiv = $("#ddlGroupDiv1").val();
				tblParam.adminAuth = "${authDiv}";
				$.ajax({
		        	type:"post",
		    		url:'<c:url value="/cmm/mp/addr/GetGroupList.do"/>',
		    		datatype:"text",
		    		data: tblParam ,
		    		success: function (data) {
		    					setAddrGroupDDlList(data.list);
		    		    	} ,
				    error: function (result) { 
				    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
				    		}
		    	});
			}
		}
		
		
		function setAddrGroupDDlList(data){
			var codeData = data;
			
			var dataSource = [{
				"CD_NAME": "<%=BizboxAMessage.getMessage("TX000000862","전체")%>",
				"CD_SEQ": "00"
			}];
			if(codeData){		    					
				dataSource = dataSource.concat(codeData);	
			}
					    				 
			// Pudd DataSource 매핑
			var dataSourceComboBox = new Pudd.Data.DataSource({		    				 
				data : dataSource
			});
			 
			Pudd( "#ddlGroupNm1" ).puddComboBox({
			 
				attributes : { style : "width:200px;" }// control 부모 객체 속성 설정
			,	controlAttributes : { id : "exAreaSelectBox" }// control 자체 객체 속성 설정
			,	dataSource : dataSourceComboBox
			,	dataValueField : "CD_SEQ"
			,	dataTextField : "CD_NAME"
			,	selectedIndex : 0
			,	disabled : false
			,	scrollListHide : false
			 
			,	filter : true
			 
				// Pudd SelectBox는 내부에서 UI 부분을 재구성하여 표현하는 관계로 제공되는 이벤트만 설정가능
				// 이벤트 설정을 하고자 하는 경우 아래 주석를 해제하고 해당 이벤트 설정하면 됨
				// 제공되는 이벤트 : change
			,	eventCallback : {
					"change" : function( e ) {
						fnSearch();
					}
				}
			});
		}
		
		
		function controlInit(){
			if("${authDiv}" == "1"){
	    	}
			else{
				$("#btnSave").hide();
				$("#btnDel").hide();
				$("#btnImport").hide();
			}
		}
		
		//grid셋팅
	    function BindListGrid(){
			var grid = $("#grid").kendoGrid({
				columns: [
				  			{
						  		title:"<%=BizboxAMessage.getMessage("TX000000214","구분")%>",
						  		field:"addr_div_nm",
						  		width:60, 
						  		headerAttributes: {style: "text-align: center;"}, 
						  		attributes: {style: "text-align: center;"},
				  			},
				  			{
				  				title:"<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>",
				  				field:"addr_group_nm",
						  		width:80, 
						  		headerAttributes: {style: "text-align: center;"}, 
						  		attributes: {style: "text-align: center;"},
				  			},
				  			{
				  				title:"<%=BizboxAMessage.getMessage("TX000000277","이름")%>",
				  				field:"emp_nm",
						  		width:70, 
						  		headerAttributes: {style: "text-align: center;"}, 
						  		attributes: {style: "text-align: center;"},
				  			},
				  			{
				  				title:"<%=BizboxAMessage.getMessage("TX000000047","회사")%>",
				  				field:"comp_nm",
						  		headerAttributes: {style: "text-align: center;"}, 
						  		attributes: {style: "text-align: center;"},
				  			},
				  			{
				  				title:"<%=BizboxAMessage.getMessage("TX000000637","등록자 ")%>" + "(ID))",
				  				field:"create_nm",
						  		width:80, 
						  		headerAttributes: {style: "text-align: center;"}, 
						  		attributes: {style: "text-align: center;"},
				  			}
				  			
						],
						height:610,
						dataSource: dataSource,
						selectable: "single",
						groupable: false,
						columnMenu:false,
						editable: false,
						sortable: true,
					    pageable: true,
						dataBound: function(e){ 
							$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
								$("#grid tr[data-uid]").removeClass("k-state-selected");
								$(this).addClass("k-state-selected");
								var selectedItem = e.sender.dataItem(e.sender.select());
								
								//데이타 조회fucntion 호출
								fnSetAddrInfo(selectedItem);
					            });							
						}				    
					}).data("kendoGrid");
			
					grid.dataSource.page(0);
				}
	    var dataSource = new kendo.data.DataSource({
		   	  serverPaging: true,
		   	  pageSize: 10,
		   	  transport: {
		   	    read: {
		   	      type: 'post',
		   	      dataType: 'json',
		   	      url: '<c:url value="/cmm/mp/addr/getAddrList.do"/>'
		   	    },
		   	    parameterMap: function(data, operation) {
		   	    	if($("#ddlGroupDiv1").data("kendoComboBox").value() != "00")
		   	    		data.addrDiv = $("#ddlGroupDiv1").data("kendoComboBox").value();
		   	    	if(Pudd( "#ddlGroupNm1" ).getPuddObject().val() != "00")
		   	    		data.addrGroupSeq = Pudd( "#ddlGroupNm1" ).getPuddObject().val();
		   	    	data.txtEmpNm = $("#txtEmpNm").val();
		   	    	data.txtCompNm = $("#txtCompNm").val();
	   	    		data.txtPhNum =$("#txtPhNum").val();
	   	    		data.txtFaxNum = $("#txtFaxNum").val();
	   	    		if(document.getElementById("my_addr").checked)
		   	    		data.chkMyGroup = "1";
		   	    	return data ;
		   	    }
		   	  },
		   	  schema: {
		   	    data: function(response) {
		   	      return response.list;
		   	    },
		   	 	total: function(response) {
				        return response.totalCount;
			      	}
		   	  }
	 	  });
	    
	    function fnSearch(){
	    	BindListGrid();
	    }
	    
	   
		
		
		
		function fnExport(){
	    	var addrDiv = "";
	    	var addrGroupSeq = "";
	    	if($("#ddlGroupDiv1").data("kendoComboBox").value() != "00")
	    		addrDiv = $("#ddlGroupDiv1").data("kendoComboBox").value();
	    	if(Pudd( "#ddlGroupNm1" ).getPuddObject().val() != "00")
	    		addrGroupSeq = Pudd( "#ddlGroupNm1" ).getPuddObject().val();
	    	var txtEmpNm = $("#txtEmpNm").val();
	    	var txtCompNm = $("#txtCompNm").val();
	    	var txtPhNum =$("#txtPhNum").val();
	    	var txtFaxNum = $("#txtFaxNum").val();
	    	var chkMyGroup = "";
    		if(document.getElementById("my_addr").checked)
    			chkMyGroup = "1";
    		
    		var tblParam = {};
    		tblParam.addrDiv = addrDiv;
    		tblParam.addrGroupSeq = addrGroupSeq;
    		tblParam.txtEmpNm = txtEmpNm;
    		tblParam.txtCompNm = txtCompNm;
    		tblParam.txtPhNum = txtPhNum;
    		tblParam.txtFaxNum = txtFaxNum;
    		tblParam.chkMyGroup = chkMyGroup;
    		
    		$.ajax({
	        	type:"post",
	        	
	    		url:'<c:url value="/cmm/mp/addr/AddrInfoExcelExport.do"/>',
	    		datatype:"json",
	    		data: tblParam ,
	    		success: function (data) {
	    				exData = data.list;
	    				clickButtonDownExcel();
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
		    		}
	    	});
	    }
		
		
		function fnSetAddrInfo(data){
			var tblParam = {};

// 			$("#btnExport").show();

			tblParam.addrSeq = data.addr_seq;
			$.ajax({
	        	type:"post",
	        	
	    		url:'<c:url value="/cmm/mp/addr/GetAddrInfo.do"/>',
	    		datatype:"json",
	    		data: tblParam ,
	    		success: function (data) {
	    				addrInfoSetting(data.result);
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000012391","엑셀 출력과정에서 오류가 발생하였습니다")%>");
		    		}
	    	});
		}
		
		function addrInfoSetting(data){
			$("#txtEmpName").val(data.emp_nm);
			$("#emailAddr").val(data.emp_email);
			$("#phNumber").val(data.emp_hp);
			$("#number").val(data.emp_tel);
			$("#faxNum").val(data.emp_fax);
			$("#txtAddr").val(data.emp_zip_addr);
			$("#orderNum").val(data.order_num);
			$("#txtCompName").val(data.comp_nm);
			$("#compNum").val(data.comp_num);
			$("#compNumber").val(data.comp_tel);
			$("#compFaxNum").val(data.comp_fax);
			$("#compAddr").val(data.comp_zip_addr);
			$("#compEct").val(data.etc);
			$("#compInfo").val(data.note);
			
			
			var dUrl = "../../../Images/bg/mypage_noimg.png";
			if(data.emp_photo != null && data.emp_photo != ""){
				dUrl = "/gw/cmm/file/fileDownloadProc.do?fileId="+data.emp_photo+"&fileSn=0";
			}
			$("#IMG_ADDR_IMG").attr("src",dUrl)
		}		
		
		
		
		
		//주소록 내보내기(푸딩 엑셀 익스포트)
		
		// 오늘 날짜 string 가져오기 - 엑셀 파일명 생성에 사용함
		var dateObj = new Pudd.Util.Date();
		var dateStr = dateObj.getFormatString( "yyyyMMdd" );
		
		var exData = [];		
		var excelDownConfig = {
			// const 영역
			totalCount : 0							// like const
		,	maxRowSize : 50000						// 엑셀리스트 분할 기준 row 갯수 - 이 부분에서 설정된 이후 변경되지 않음
		,	fileName : "BizBoxAlpha_AddressBook_Today(" + dateStr + ")"	// 설정할 엑셀파일명 - 다운 리스트 Dialog 발생되는 경우 엑셀파일명[1].xlsx 형식으로 자동변경함
		};
		
		function clickButtonDownExcel() {

			// 본 예제는 Data 배열로 직접 설정하여서 dataSource 활용한 부분은 생략
			excelDownConfig.totalCount = exData.length;
			checkCountExcelDownload();
		}
		
		function checkCountExcelDownload() {

			if( excelDownConfig.totalCount > excelDownConfig.maxRowSize ) {

				// excelDownload Dialog 생성
				createExcelDownloadDialog();

			} else {

				// 다운로드 - 1개 파일
				var rowNo = 1;
				var rowSize = excelDownConfig.totalCount;
				var fileName = excelDownConfig.fileName + ".xlsx";

				callExcelDownload( rowNo, rowSize, fileName );// 매개변수 rowNo, rowSize, fileName
			}
		}
		
		
		function createExcelDownloadDialog() {

			// puddCustomDialog 함수 호출
			// 1st 매개변수 - puddDialog에서 사용되는 옵션 + excelDownload callback
			// 2nd 매개변수 - "excelDownload" 문자열 전달
			//
			var puddDlg = Pudd.puddCustomDialog({

				width : 400
			,	height : 130

			,	modal : false		// 기본값 true
			,	draggable : false	// 기본값 true

			,	autoResizePosition : false	// 기본값 true - 위치가 고정되어야 됨

			,	header : {

					title : "<%=BizboxAMessage.getMessage("TX000009553","엑셀 다운로드")%>"
				,	align : "left"	// left, center, right
				,	closeButton : true	// 기본값 true
				}
			,	body : {// 선언만 설정 - 내부에서 UI 설정함
				}

			,	excelDownload : {

					totalCount : excelDownConfig.totalCount
				,	maxRowSize : excelDownConfig.maxRowSize
				,	fileName : excelDownConfig.fileName

				,	listClick : function( rowNo, rowSize, fileName ) {

						callExcelDownload( rowNo, rowSize, fileName );
					}
				}
			}, "excelDownload" );


			// 클릭한 버튼 객체 아래로 위치시키기
			// 1st 매개변수 - 위치될 기준 객체
			// 2nd 매개변수 - "left" : 왼쪽 기준으로 위치, "right" : 오른쪽 기준으로 위치
			//
			puddDlg.movePositionDialog( document.getElementById( "excelDownTest" ), "right" );
		}
		
		
		function callExcelDownload( rowNo, rowSize, fileName ) {

			Pudd( "#circularProgressBar" ).puddProgressBar({

				progressType : "circular"
			,	attributes : { style:"width:150px; height:150px;" }

			,	strokeColor : "#00bcd4"	// progress 색상
			,	strokeWidth : "3px"	// progress 두께

			,	percentText : ""
			,	percentTextColor : "#fff"
			,	percentTextSize : "24px"

				// progressType : "circular" 인 경우만 해당되는 옵션
			,	modal : true
			,	extraText : {

					text : fileName
				,	attributes : { style : "" }
				}

				// 내부적으로 timeout 으로 아래 함수를 호출함. 시간은 100 milliseconds
			,	progressStartCallback : function( progressBarObj ) {

					excelDownloadProcess( rowNo, rowSize, fileName, progressBarObj );
				}
			});
		}
		
		
		
		function excelDownloadProcess( rowNo, rowSize, fileName, progressBarObj ) {

			var dataSourceList = new Pudd.Data.DataSource({

				data : exData			// 직접 data를 배열로 설정

			,	pageSize : 999999
			,	serverPaging : false
			});

			progressBarObj.updateProgressBar( 10 );// 10%

			setTimeout( function() {

				dataSourceList.read( false, function(){

					if( true === dataSourceList.responseResult ) {// success

						progressBarObj.updateProgressBar( 40 );// 40%

						// json data 저장
						var dataPage = dataSourceList.dataPage;
						var dataLen = dataPage.length;

						// excel파일 다운로드 처리
						generateExcelDownload( dataPage, fileName, function() {// saveCallback

							progressBarObj.updateProgressBar( 100 );// 100%
							progressBarObj.clearIntervalSet();// progressBar 종료

						}, function( rowIdx ){// stepCallback

							if( dataLen ) {

								var percent = ( ( rowIdx * 100 / dataLen ) / 2 ) + 40;
								percent = parseInt( percent );

								progressBarObj.updateProgressBar( percent );
							}
						});

					} else {// error

						progressBarObj.clearIntervalSet();// progressBar 종료
					}
				});
			}, 10);
		}
		
		
		
		function generateExcelDownload( dataPage, fileName, saveCallback, stepCallback ) {
			 
			var excel = new JExcel("맑은 고딕 10 #333333");
			excel.set( { sheet : 0, value : "Sheet1" } );
		 
			// column 크기 설정
			excel.setColumnWidth( 0, 0, 9.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 1, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 2, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 3, 20.14 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 4, 18.43 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 5, 15.57 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 6, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 7, 29.86 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 8, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 9, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 10, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 11, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 12, 11.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 13, 30.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 14, 14.29 );// sheet번호, column, value(width)
			excel.setColumnWidth( 0, 15, 14.29 );// sheet번호, column, value(width)
		 
			// header 포맷스타일 설정
			var formatHeader;			
		 
			// header style 설정
			var headerRow = 2;
			var headerCol = 16;
			for( var i = 0; i < headerRow; i++ ) {		 
				for( var j = 0; j < headerCol; j++ ) {
					
		 			if(i == 0 && j <= 8){	
		 				//개인정보 헤더
		 				formatHeader = excel.addStyle ({
							border: "thin,thin,thin,thin",
							fill: "#E3DFED",
							font: "맑은 고딕 10 #333333 B",// U : underline, B : bold, I : Italic
							align : "C C"// horizontal, vertical
						});
						excel.set( 0, j, i, null, formatHeader );// sheet번호, column, row, value, style
		 			}else if(i == 0 && j > 8){
		 				//회사정보 헤더
						if(j == 9){
							formatHeader = excel.addStyle ({
								border: "thick,thin,thin,thin",
								fill: "#F3DADD",
								font: "맑은 고딕 10 #333333 B",// U : underline, B : bold, I : Italic
								align : "C C"// horizontal, vertical
							});
		 				}else{
		 					formatHeader = excel.addStyle ({
								border: "thin,thin,thin,thin",
								fill: "#F3DADD",
								font: "맑은 고딕 10 #333333 B",// U : underline, B : bold, I : Italic
								align : "C C"// horizontal, vertical
							});
		 				}
		 				excel.set( 0, j, i, null, formatHeader );// sheet번호, column, row, value, style
		 			}else{
		 				//컬럼값 헤더	
						if(j == 9){
							formatHeader = excel.addStyle ({
								border: "thick,thin,thin,thin",
								fill: "#C7D8F2",
								font: "맑은 고딕 10 #333333 B",// U : underline, B : bold, I : Italic
								align : "C C"// horizontal, vertical
							});
		 				}else{
		 					formatHeader = excel.addStyle ({
								border: "thin,thin,thin,thin",
								fill: "#C7D8F2",
								font: "맑은 고딕 10 #333333 B",// U : underline, B : bold, I : Italic
								align : "C C"// horizontal, vertical
							});
		 				}
		 				excel.set( 0, j, i, null, formatHeader );// sheet번호, column, row, value, style
		 			}
				}
			}
		 
			// header - column - "개인정보"
			excel.set( 0, 0, 0, "<%=BizboxAMessage.getMessage("TX000016397","개인 정보")%>" );// sheet번호, column, row, value, style
			excel.mergeCell( 0, 0, 0, 8, 0 );// sheet번호, start column, start row, end column, end row
		 
			// header - column - "회사정보"
			excel.set( 0, 9, 0, "<%=BizboxAMessage.getMessage("TX000016060","회사 정보")%>" );// sheet번호, column, row, value, style
			excel.mergeCell( 0, 9, 0, 15, 0 );// sheet번호, start column, start row, end column, end row
			
			// header - column - "구분"
			excel.set( 0, 0, 1, "<%=BizboxAMessage.getMessage("TX000022126","구분")%>" );// sheet번호, column, row, value, style
			
			// header - column - "그룹명"
			excel.set( 0, 1, 1, "<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>" );// sheet번호, column, row, value, style
			
			// header - column - "이름"
			excel.set( 0, 2, 1, "<%=BizboxAMessage.getMessage("TX000000277","이름")%>" );// sheet번호, column, row, value, style
			
			// header - column - "이메일"
			excel.set( 0, 3, 1, "<%=BizboxAMessage.getMessage("TX000002932","이메일")%>" );// sheet번호, column, row, value, style
			
			// header - column - "일반전화"
			excel.set( 0, 4, 1, "<%=BizboxAMessage.getMessage("TX000000654","휴대전화")%>" );// sheet번호, column, row, value, style
			
			// header - column - "일반전화"
			excel.set( 0, 5, 1, "<%=BizboxAMessage.getMessage("TX000016150","일반전화")%>" );// sheet번호, column, row, value, style
			
			// header - column - "일반팩스"
			excel.set( 0, 6, 1, "<%=BizboxAMessage.getMessage("TX000018432","일반팩스")%>" );// sheet번호, column, row, value, style
			
			// header - column - "개인주소"
			excel.set( 0, 7, 1, "<%=BizboxAMessage.getMessage("TX000000093","개인주소")%>" );// sheet번호, column, row, value, style
			
			// header - column - "정렬"
			excel.set( 0, 8, 1, "<%=BizboxAMessage.getMessage("TX000019823","정렬")%>" );// sheet번호, column, row, value, style
			
			// header - column - "회사명"
			excel.set( 0, 9, 1, "<%=BizboxAMessage.getMessage("TX000021259","회사명")%>" );// sheet번호, column, row, value, style
			
			// header - column - "사업자번호"
			excel.set( 0, 10, 1, "<%=BizboxAMessage.getMessage("TX000000024","사업자번호")%>" );// sheet번호, column, row, value, style
			
			// header - column - "대표전화"
			excel.set( 0, 11, 1, "<%=BizboxAMessage.getMessage("TX000016328","대표전화")%>" );// sheet번호, column, row, value, style
			
			// header - column - "대표팩스"
			excel.set( 0, 12, 1, "<%=BizboxAMessage.getMessage("TX000016326","대표팩스")%>" );// sheet번호, column, row, value, style
			
			// header - column - "대표주소"
			excel.set( 0, 13, 1, "<%=BizboxAMessage.getMessage("TX000016327","대표주소")%>" );// sheet번호, column, row, value, style
			
			// header - column - "추가정보"
			excel.set( 0, 14, 1, "<%=BizboxAMessage.getMessage("TX000004489","추가정보")%>" );// sheet번호, column, row, value, style
			
			// header - column - "비고"
			excel.set( 0, 15, 1, "<%=BizboxAMessage.getMessage("TX000018384","비고")%>" );// sheet번호, column, row, value, style
		 
			// cell style 설정
			var formatCell1 = excel.addStyle ({
				border: "thin,thin,thin,thin",
				align : "C"
			});
			var formatCell2 = excel.addStyle ({
				border: "thick,thin,thin,thin",
				align : "C"
			});
			
			// header row 이후부터 출력
			var totalCount = dataPage.length;
			for( var i = 0; i < totalCount; i++ ) {
		 
				var rowNo = i + 2;
				
				excel.set( 0, 0, rowNo, dataPage[ i ][ "addr_div_nm" ], formatCell1 );
				excel.set( 0, 1, rowNo, dataPage[ i ][ "addr_group_nm" ], formatCell1 );
				excel.set( 0, 2, rowNo, dataPage[ i ][ "emp_nm" ], formatCell1 );
				excel.set( 0, 3, rowNo, dataPage[ i ][ "emp_email" ], formatCell1 );
				excel.set( 0, 4, rowNo, dataPage[ i ][ "emp_hp" ], formatCell1 );
				excel.set( 0, 5, rowNo, dataPage[ i ][ "emp_tel" ], formatCell1 );
				excel.set( 0, 6, rowNo, dataPage[ i ][ "emp_fax" ], formatCell1 );
				excel.set( 0, 7, rowNo, dataPage[ i ][ "emp_zip_addr" ], formatCell1 );
				excel.set( 0, 8, rowNo, dataPage[ i ][ "order_num" ], formatCell1 );
				excel.set( 0, 9, rowNo, dataPage[ i ][ "comp_nm" ], formatCell2 );
				excel.set( 0, 10, rowNo, dataPage[ i ][ "comp_num" ], formatCell1 );
				excel.set( 0, 11, rowNo, dataPage[ i ][ "comp_tel" ], formatCell1 );
				excel.set( 0, 12, rowNo, dataPage[ i ][ "comp_fax" ], formatCell1 );
				excel.set( 0, 13, rowNo, dataPage[ i ][ "comp_zip_addr" ], formatCell1 );
				excel.set( 0, 14, rowNo, dataPage[ i ][ "etc" ], formatCell1 );
				excel.set( 0, 15, rowNo, dataPage[ i ][ "note" ], formatCell1 );
			}
		 
			excel.generate( fileName, saveCallback, stepCallback );
		}  
		
		function fnSetSnackbar(msg, type, duration){
			var puddActionBar = Pudd.puddSnackBar({
				type	: type
			,	message : msg
			,	duration : 1500
			});
		}
    </script>


			<!-- 검색박스 -->
			<div id="circularProgressBar"></div>
			<div class="top_box">
				<dl>
					<dt class="ar en_w70" style="width:50px;"><%=BizboxAMessage.getMessage("TX000000214","구분")%></dt>
					<dd><input id="ddlGroupDiv1" class="kendoComboBox" style="width:80px" onchange="Bindgroupddl2();"/></dd>
					
					<dt class="ar" style="width:65px;"><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></dt>
					<dd>
						<div id="ddlGroupNm1"></div>
					<dd>
						<input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
					</dd>
				</dl>
				<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
			</div>
			
			<!-- 상세검색박스 -->
			<div class="SearchDetail">
				<dl>	
					<dt class="en_w68" style="width:46px;"><%=BizboxAMessage.getMessage("TX000000277","이름")%></dt>
					<dd class="mr5 pt5 pl5">
						<input type="text" style="width:200px;" id="txtEmpNm"/>
					</dd>
					<dt class="en_w105" style="width:50px;"><%=BizboxAMessage.getMessage("TX000000018","회사명")%></dt>
					<dd class="mr5 pt5 pl5">
						<input type="text" style="width:200px;" id="txtCompNm"/>
					</dd>
				</dl>
				<dl>	
					<dt class="en_w68" style="width:46px;"><%=BizboxAMessage.getMessage("TX000000006","전화")%></dt>
					<dd class="mr5 pt5 pl5">
						<input type="text" style="width:200px;" id="txtPhNum"/>
					</dd>
					<dt class="en_w105" style="width:50px;"><%=BizboxAMessage.getMessage("TX000000007","팩스")%></dt>
					<dd class="mr5 pt5 pl5">
						<input type="text" style="width:200px;" id="txtFaxNum"/>
					</dd>
				</dl>
			</div>
			

			<!-- 컨텐츠내용영역 -->
			<div class="sub_contents_wrap">
				<div class="btn_div m0">
					<div class="left_div">
						<div id="" class="pt15" style="margin-left: 3px">
							<input type="checkbox" name="inp_chk" id="my_addr" class="k-checkbox" onclick="fnSearch();"><label class="k-checkbox-label chkSel" for="my_addr" id="authDiv"></label>
						</div>
					</div>
					<div class="right_div">
						<!-- 컨트롤버튼영역 -->
						<div id="" class="controll_btn">
							<button id="btnExport"><%=BizboxAMessage.getMessage("TX000005727","내보내기")%></button>
						</div>
					</div>
				</div>
				
				<div class="twinbox">
					<table style="min-height: auto;">
						<colgroup>
							<col width="40%" />
							<col />
						</colgroup>
						<tr>
							<td class="twinbox_td">
								<!-- 그리드 리스트 -->
								<div id="grid"></div>
							</td>
							<td class="twinbox_td">
								<div class="com_ta mt10">
									<table>
										<colgroup>
											<col width="20%" />
											<col width="30%" />
											<col width="20%" />
											<col />
										</colgroup>
										<!-- 개인정보 -->
										<tr>
											<th colspan="4" class="cen"><%=BizboxAMessage.getMessage("TX000016397","개인정보")%><span class="text_red">(<%=BizboxAMessage.getMessage("TX000004080","필수")%>)</span></th>
										</tr>
										<tr>
											<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
											<td><input type="text" style="width:90%;" id="txtEmpName" readonly="readonly"/></td>
											<th class="cen" colspan="2"><%=BizboxAMessage.getMessage("TX000000082","사진")%>(120*160)</th>
										</tr>
										<tr>
											<th><img src="../../../Images/ico/ico_check02.png" alt="" /> <%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>
											<td><input type="text" style="width:90%;" id="emailAddr" readonly="readonly"/></td>
											<th class="cen" colspan="2" rowspan="6">
												<p class="imgfile" id=""><img src="../../../Images/bg/mypage_noimg.png" id="IMG_ADDR_IMG" width="120" height="160" alt="등록된 이미지가 없습니다" /></p>
												
												<input type="file" id="" class="hidden_file_add" name=""/>
											</th>
										</tr>
										<tr>
											<th><img src="../../../Images/ico/ico_check02.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
											<td><input type="text" style="width:90%;" id="phNumber" readonly="readonly"/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000016150","일반전화")%></th>
											<td><input type="text" style="width:90%;" id="number" readonly="readonly"/></td>
										</tr>
										<tr>
											<th><img src="../../../Images/ico/ico_check02.png" alt="" /> <%=BizboxAMessage.getMessage("TX000015147","일반팩스")%></th>
											<td><input type="text" style="width:90%;" id="faxNum" readonly="readonly"/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000093","개인주소")%></th>
											<td><input type="text" style="width:90%;" id="txtAddr" readonly="readonly"/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
											<td><input type="text" style="width:90%;" id="orderNum" readonly="readonly"/></td>
										</tr>
										<!-- 회사정보 -->
										<tr>
											<th colspan="4" class="cen"><%=BizboxAMessage.getMessage("TX000016060","회사정보")%>(<%=BizboxAMessage.getMessage("TX000000265","선택")%>)</th>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
											<td>
												<input type="text" style="width:90%;" id="txtCompName" readonly="readonly"/>
											</td>
											<th><%=BizboxAMessage.getMessage("TX000000024","사업자번호")%></th>
											<td><input type="text" style="width:90%;" id="compNum" readonly="readonly"/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000016328","대표전화")%></th>
											<td><input type="text" style="width:90%;" id="compNumber" readonly="readonly"/></td>
											<th><%=BizboxAMessage.getMessage("TX000016326","대표팩스")%></th>
											<td><input type="text" style="width:90%;" id="compFaxNum" readonly="readonly"/></td>
										</tr>
										<!-- 관리자일때만 사용 
										<tr>
											<th>회사이메일</th>
											<td colspan="3"><input type="text" style="width:96.3%;"/></td>
										</tr>
										 -->
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000016327","대표주소")%></th>
											<td colspan="3"><input type="text" style="width:96.3%;" id="compAddr" readonly="readonly"/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000004489","추가정보")%></th>
											<td colspan="3"><input type="text" style="width:96.3%;" id="compEct" readonly="readonly"/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
											<td colspan="3"><input type="text" style="width:96.3%;" id="compInfo" readonly="readonly"/></td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</div>
				
									
			</div><!-- //sub_contents_wrap -->
