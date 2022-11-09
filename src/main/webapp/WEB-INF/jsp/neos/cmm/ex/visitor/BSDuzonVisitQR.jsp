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

<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jszip-3.1.5.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/FileSaver-1.2.2_1.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jexcel-1.0.5.js"></script>

<script type="text/javascript">

	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth()+1; //January is 0!
	var yyyy = today.getFullYear();
	
	if(dd<10) {
	    dd='0'+dd
	} 
	
	if(mm<10) {
	    mm='0'+mm
	} 
	
	today = yyyy+mm+dd;
	
    $(document).ready(function() {
    	
        // 결과 검색
        $("#btnSearch").click(function(){
        	fnQrListGrid();
        });
        
        $("#btnReSend").click(function() {
        	fnMMSReSend();
        });
        
        /* 성명/차량번호 검색 조건 변경 */
        $("#searchCategory").change(function() {
        	if( $("#searchCategory").val() == "visit_car_no" ){
        		$("#carNoArea").show();
        		$("#nameArea").hide();
        		$("#txtVisitName").val('');
        	}
        	else {
        		$("#nameArea").show();
        		$("#carNoArea").hide();
        		$("#txtVisitCarNo").val('');
        	}
        });
        
        $("#btnPass").click(function () {
        	
        })
        
        // 기간 셋팅
        fnInitDatePicker(7);
        
        fnQrListGrid();
        
    
    });
    
    // 기간 셋팅
    function fnInitDatePicker(dayGap) {
        Date.prototype.ProcDate = function () {
            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString(); //
            var dd = this.getDate().toString();
            return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]);
        };
        
        var toD = new Date();
        Pudd("#txtToDt").getPuddObject().setDate(toD.ProcDate());
        var fromD = new Date(toD.getFullYear(), toD.getMonth(), toD.getDate()-dayGap);
        Pudd("#txtFrDt").getPuddObject().setDate(fromD.ProcDate());
    } 
    
    function fnQrListGrid() {
        
        var frDt = $("#txtFrDt").val();
        var toDt = $("#txtToDt").val();
        var frDate = new Date(frDt);
        var toDate = new Date(toDt);
        
        if (frDate - toDate > 0) {
            var puddDialog = Pudd.puddDialog({
                width : 350
                , height : 100
                , message : {
                    type : "warning"
                    , content : "<%=BizboxAMessage.getMessage("TX000005743", "시작일이 종료일보다 큽니다.")%>"
                }
            });
        }
        else {
            DrawGrid();
        }
    }
    
    function DrawGrid() {
    	
    	var dataSource = new Pudd.Data.DataSource({
			serverPaging: true,
			pageSize: 10,
			request: {
			    type: 'post',
			    dataType: 'json',
			    url: '<c:url value="/cmm/ex/visitor/getVisitorList.do"/>',
			 	parameterMapping: function(data) {
				 	data.nRNo = 0;
				 	data.pDist = 1;		//1:일반,  2:외주
				 	data.qrFrDt = $("#txtFrDt").val().replace(/-/gi, ''); 
				 	data.qrToDt = $("#txtToDt").val().replace(/-/gi, '');
				 	
	   	    		data.pVisitNm = $("#txtVisitName").val();
				 	data.pVisitCarNo = $("#txtVisitCarNo").val();
	   	    		
	   	    		data.elet_appv_link_yn = "Y"
	   	    		data.searchListType = "qr";
				 	
					data.pType = "search";	   	    	
	 				return data ;
		     	}
	     	 },
			result : {
				data : function( response ) {
					return response.list;
				},
				totalCount : function( response ) {
					return response.totalCount;
				},
				error : function( response ) {
					alert( "오류" );
				}
			}
		});		

     
         Pudd( "#webGrid" ).puddGrid({
             dataSource : dataSource
             , scrollable : true
             , sortable : true
             , resizable : false    // 기본값 false
             , ellipsis : false
             , pageable : {
                 buttonCount : 10
                 , pageList : [ 10, 20, 30 ]
                 , showAlways : false
             }
             , columns : [
             	{
         			field : "gridCheckBox"		// grid 내포 checkbox 사용할 경우 고유값 전달
         		,	width : 25
         		 	,	editControl : {
         				type : "checkbox",
         				dataValueField: "visit_dt_fr"
         			,	basicUse : true
         		 	}
         		}
         	,	{
         			field : "visitor_co"
         		,	title : "회사명"
         		,	width : 100
         		}
         	,	{
         			field : "visitor_nm"
         		,	title : "성명"
         		,	width : 70
         		}
         	,	{
         			field : "visit_hp"
         		,	title : "연락처"
         		,	width : 100
         		}
         	,	{
         			field : "visit_car_no"
         		,	title : "차량번호"
         		,	width : 100
         		,	content : {
 					template : function (rowData) {
 						var data = rowData.visit_car_no;
 						if(rowData.visit_pticket_yn == "Y"){
 							data += "(무료)" 
 						}
 						var html = '<p>'+data+'</p>';
 						return html;
 					}
 				} 
         		}
         	,	{
         			field : "man_emp_name"
         		,	title : "담당자"
         		,	width : 70
         		}
         	,	{
	     			field : "req_emp_name"
	     		,	title : "등록자"
	     		,	width : 70
     			}
         	,	{
	     			field : "message"
	     		,	title : "메시지"
	     		,	width : 250
	     		,	content : {
	     				template : function () {
	     					var html = '<p>을지타워 방문 QR코드 발송</p>';
	     					return html;
	     				}
	     			}
	 			}
         	,	{
         			field : "qr_send_date"
   				,	title : "전송일시"
	     		,	width : 100
         		}
         	,	{
     				field : "qr_send_status_code"
				,	title : "발송상태"
     			,	width : 80
     			,	content : {
     					template : function (rowData) {
     						var status = "";
     						if(rowData.qr_send_status_code == "Success"){
     							 status = "성공"
     						}
     						else {
     							status = "실패"
     						}
     						var html = '<p>'+status+'</p>';
     						return html;
     					}
     				} 
     			}
         	,	{
     				field : "detail"
				,	title : "상세"
     			,	width : 50
     			,   content : {
     					template : function (rowData) {
         					var html = '<div class="controll_btn p0" style="text-align:center;"><button class="k-button" style="width:50px" id="' + rowData.r_no + '" visit_dt_fr="'+ rowData.visit_dt_fr.replace(/-/gi, "") + '" onclick="btnDetail(this);"><%=BizboxAMessage.getMessage("TX000000899","조회")%></button></div>';
							return html;         					
         				}
     				}
         		}
             ]
             , loadCallback : function ( headerTable, contentTable, footerTable, gridObj ){
	             var rowLength = contentTable.rows.length;
	         	 if( rowLength <= 0 ) return;
	         	 for( var i=0; i<rowLength; i++ ) {
	    			
	         		var tdObj = Pudd.getInstance( contentTable.rows[ i ].cells[ 0 ] );// td 첫번째 항목이 checkbox 포함한 td
	    			var val = tdObj.checkboxObj.val().replace(/-/gi, ""); // val : 방문일자
	    			
	    			/* 기간이 지났을 경우 checkBox disabled */
	    			if( today > val ) {
	    				tdObj.checkboxObj.setDisabled( true );
	    			} 
	         	 }
             }
             , noDataMessage : {
                 message : "<%=BizboxAMessage.getMessage("TX000017974", "데이터가 존재하지 않습니다.")%>"
             }
             
         });
        
    }
    
    function btnDetail(e) {
    	console.log(e);
		var gridDate = e.getAttribute('visit_dt_fr');
		var url="";
		
		/* 날짜가 지난 전송 건 */
		if(parseInt(today) > parseInt(gridDate)){
			url = "visitorPopView.do?r_no="+e.id;			
		}
		/* 날짜가 지나지 않은 전송 건 - 수정 가능 */
		else {
			url = "visitorPopView.do?r_no="+e.id+"&type=edit";
		}
    	
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "visitorPopView", "width=550,height=457,left="+left+" top="+top);
	   	pop.focus();
    }
    
    /* QR코드 재발송 */
    function fnMMSReSend() {
    	var puddGrid = Pudd("#webGrid").getPuddObject();
    	if( !puddGrid ) return;
    	
    	var dataCheckedRowObj = puddGrid.getGridCheckedRowObj( "gridCheckBox" );
    	
    	if( dataCheckedRowObj.length == 0 ) {
    		alert("<%=BizboxAMessage.getMessage("","재발송 항목을 선택해주세요.")%>");
  			return;
    	} 
    	
    	var resend_r_no = "";
    	
   		for( var i in dataCheckedRowObj ) {
   			resend_r_no += "," + dataCheckedRowObj[i].rowData.r_no;
   		}
   		resend_r_no = resend_r_no.substring(1);
   		console.log(resend_r_no);
	
		if (!confirm("<%=BizboxAMessage.getMessage("","재발송 하시겠습니까?")%>")) {
	        return;
	    }
	    
	    $.ajax({
	    	type:"post",
			url:'<c:url value="/cmm/ex/visitor/ReSendMMS.do" />',
			datatype:"text",
			data: { r_no_list : resend_r_no } ,
			success:function(data){
				if(data.result.resultCode == "SUCCESS"){
					alert("<%=BizboxAMessage.getMessage("","재발송되었습니다.")%>");
					DrawGrid();
				}
				else {
					alert('QR코드 재발송 도중 에러가 발생하였습니다.');
				}
			},error : function(data){
				alert('QR코드 재발송 도중 에러가 발생하였습니다.');
			}
	    	
	    });
  		
	}
    
    /* 기간 별 검색 */
    /* <param> 1: 1주일 2: 1개월 3: 3개월 */
    function periodSerach( param ){
    	
    	if(param == 1){
    		fnInitDatePicker(7)	
    	}
    	else if(param == 2){
    		fnInitDatePicker(30)
    	}
    	else {
    		fnInitDatePicker(90)
    	}
    	
    	fnQrListGrid();
    }

    
    var excelDownConfig = {
    		// const 영역
    		//
    		totalCount : 0							// like const
    	,	maxRowSize : 50000						// 엑셀리스트 분할 기준 row 갯수 - 이 부분에서 설정된 이후 변경되지 않음
    	,	fileName : "bizboxAlpha_BSDuzonVisitQrList_" + today	// 설정할 엑셀파일명 - 다운 리스트 Dialog 발생되는 경우 엑셀파일명[1].xlsx 형식으로 자동변경함
    	,	url_count : '/gw/cmm/ex/visitor/qrListTotalCount.do'
    	,	url_list : '/gw/cmm/ex/visitor/getVisitorList.do'
    	 
    		// variable 영역
    		//
    		// dataSource 전달에 사용 - 파일 순번에 따라 동적으로 변경되거나 검색어, 날짜 등의 실적용시에 전달 적용할 영역
    		//
    	,	parameter : {
    	 
    			exType : "0"		// 예제 구성을 위해 사용되는 parameter
    		,	exSplitExcel : "0"	// 예제 구성을 위해 사용되는 parameter - 분할 Dialog에서 사용되는 경우 "1", 아니면 "0"
    	 
    		,	rowNo : 0			// 엑셀리스트 분할 기준 파일 순번 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
    		,	rowSize : 0			// 엑셀리스트 분할 기준 파일 크기 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
    	 
    		,	startDate : ""		// 예제 성격으로 작성됨 - 실적용시에 해당 화면에 맞게 처리
    		,	endDate : ""		// 예제 성격으로 작성됨 - 실적용시에 해당 화면에 맞게 처리
    		,	searchText : ""		// 예제 성격으로 작성됨 - 실적용시에 해당 화면에 맞게 처리
    		
    	}
    }
    
 	// ----- 개발 화면에 따라 처리할 부분
    //
    function generateExcelDownload( dataPage, fileName, saveCallback, stepCallback ) {
     
    	var excel = new JExcel("맑은 고딕 11 #333333");
    	excel.set( { sheet : 0, value : "테스트Sheet" } );
     
    	var headers = [ "회사명", "성명", "연락처", "차량번호", "담당자", "등록자", "메시지", "전송일시", "발송상태" ];
    	var formatHeader = excel.addStyle ({
    		border: "thin,thin,thin,thin #000000",
    		fill: "#dedede",
    		font: "맑은 고딕 11 #333333 B",// U : underline, B : bold, I : Italic
    		align : "C"
    	});
     
    	for( var i=0; i<headers.length; i++ ) {
     
    		excel.set( 0, i, 0, headers[i], formatHeader );// sheet번호, column, row, value, style
    		excel.setColumnWidth( 0, i, 30 );// sheet번호, column, value(width)
    	}
     
    	var formatCell = excel.addStyle ({
    		align : "C"
    	});
     
    	// header row 이후부터 출력
    	var totalCount = dataPage.length;
    	for( var i = 0; i < totalCount; i++ ) {
     
    		var rowNo = i + 1;
     
    		excel.set( 0, 0, rowNo, dataPage[ i ][ "visitor_co" ] );
    		excel.set( 0, 1, rowNo, dataPage[ i ][ "visitor_nm" ] );
    		excel.set( 0, 2, rowNo, dataPage[ i ][ "visit_hp" ] );
    		excel.set( 0, 3, rowNo, dataPage[ i ][ "visit_car_no" ] );
    		excel.set( 0, 4, rowNo, dataPage[ i ][ "man_emp_name" ] );
    		excel.set( 0, 5, rowNo, dataPage[ i ][ "req_emp_name" ] );
    		/* 메시지 - 임시 하드코딩 */
    		excel.set( 0, 6, rowNo, "을지타워 방문 QR코드 발송" );
    		excel.set( 0, 7, rowNo, dataPage[ i ][ "qr_send_date" ] );
    		excel.set( 0, 8, rowNo, dataPage[ i ][ "qr_send_status_code" ] == "Success" ?  "성공" : "실패" );
    	}
     
    	excel.generate( fileName, saveCallback, stepCallback );
    }
 	
 // 예제 구성 코드
    function clickButtonDownExcel() {
     
    	// dataSource - count 조회
    	var dataSourceCount = new Pudd.Data.DataSource({
     
    		pageSize : 999999
    	,	serverPaging : true
    	,	request : {
    			url : excelDownConfig.url_count
    		,	type : 'post'
    		,	dataType : "json"
    		,	parameterMapping : function( data ) {
	    			data.nRNo = 0;
				 	data.pDist = 1;		//1:일반,  2:외주
				 	data.qrFrDt = $("#txtFrDt").val().replace(/-/gi, ''); 
				 	data.qrToDt = $("#txtToDt").val().replace(/-/gi, '');
	   	    		data.pVisitNm = $("#txtVisitName").val();
				 	data.pVisitCarNo = $("#txtVisitCarNo").val();
					data.pType = "search";	   	    	
	 				return data ;     
    			}
    		}
     
    	,	result : {
     
    			data : function( response ) {
     
    				//return response.list;
    				return null;
    			}
     
    		,	totalCount : function( response ) {
     
    				return response.totalCount;
    			}
     
    		,	error : function( response ) {
     
    				//alert( "error - Pudd.Data.DataSource.read, status code - " + response.status );
    			}
    		}
    	});
     
    	Pudd( "#loadingProgressBar" ).puddProgressBar({
     
    		progressType : "loading"
    	,	attributes : { style:"width:90px; height:90px;" }
     
    	,	strokeColor : "#84c9ff"	// progress 색상
    	,	strokeWidth : "3px"	// progress 두께
     
    	,	percentText : "처리중..."	// loading 표시 문자열 설정 - progressType loading 인 경우만
    	,	percentTextColor : "#84c9ff"
    	,	percentTextSize : "12px"//"12px"
     
    		// 내부적으로 timeout 으로 아래 함수를 호출함. 시간은 100 milliseconds
    	,	progressStartCallback : function( progressBarObj ) {
     
    			dataSourceCount.read( false, function() {
     
    				if( true === dataSourceCount.responseResult ) {// success
     
    					// 전체 갯수
    					excelDownConfig.totalCount = dataSourceCount.totalCount;
     
    					checkCountExcelDownload();
     
    					// loading progressBar 종료처리
    					progressBarObj.clearIntervalSet();
     
    				} else {// error
     
    					// loading progressBar 종료처리
    					progressBarObj.clearIntervalSet();
    				}
    			});
    		}
    	});
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
     
    		pageSize : 999999
    	,	serverPaging : true
     
    	,	request : {
     
    			url : excelDownConfig.url_list
    		,	type : 'post'
    		,	dataType : "json"
     
    		,	parameterMapping : function( data ) {
     
	    			data.nRNo = 0;
				 	data.pDist = 1;		//1:일반,  2:외주
				 	data.qrFrDt = $("#txtFrDt").val().replace(/-/gi, ''); 
				 	data.qrToDt = $("#txtToDt").val().replace(/-/gi, '');
				 	
	   	    		data.pVisitNm = $("#txtVisitName").val();
				 	data.pVisitCarNo = $("#txtVisitCarNo").val();
	   	    		
	   	    		data.elet_appv_link_yn = "Y"
	   	    		data.searchListType = "qr";
				 	
					data.pType = "search";
	 				return data ;
    			}
    		}
     
    	,	result : {
     
    			data : function( response ) {
     
    				return response.list;
    			}
     
    		,	totalCount : function( response ) {
     
    				return response.totalCount;
    			}
     
    		,	error : function( response ) {
     
    				//alert( "error - Pudd.Data.DataSource.read, status code - " + response.status );
    			}
    		}
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
     
    			title : "엑셀 다운로드"
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
     
</script>

<div style="height: 50px;
			text-align:left;
			border-right: none; 
			border:1px solid #c3c3c3;
			padding: 5px 0;
			margin-bottom: 10px;
			padding: 20px 0px 0px 25px;">
	<div style="margin-bottom: -10px;">
		전송결과는 6개월간 보관되며, 6개월 초과데이터는 자동 삭제됩니다.
	</div>
	<br/>
	<div>이미 전송된 건은 [전송취소]할 수 없습니다.</div>
</div>

<div class="top_box">
    <dl>
     	<%-- 추후 다국어 적용 --%>        
        <dt class="ar" style="width: 68px;">검색</dt>
        <dd>
        	<select id="searchCategory" style="width: 90px">
				<option value="visit_name">성명</option>
				<option value="visit_car_no">차량번호</option>
			</select>
        </dd>
        <dd id="nameArea"><input id="txtVisitName" type="text" style="width:200px;" class="puddSetup" value="" onkeydown="if(event.keyCode==13){javascript:fnQrListGrid();}" /></dd>
 		<dd id="carNoArea" style="display:none;"><input id="txtVisitCarNo" type="text" style="width:200px;" class="puddSetup" value="" onkeydown="if(event.keyCode==13){javascript:fnQrListGrid();}" /></dd>
 	<%-- 추후 다국어 적용 --%>        
 		<dd> <input id="btnSearch" type="button" value="조회"> </dd>
    </dl>
    <span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
    
</div>

<!-- 상세검색박스 -->
<div class="SearchDetail">
	<dl>	
        <dt class="ar" style="width: 68px;">기간</dt>
		<dd> 
			<input type="text" id="txtFrDt" value="" class="puddSetup" pudd-type="datepicker"  /> ~ <input type="text" id="txtToDt" value="" class="puddSetup" pudd-type="datepicker"/>  
		</dd>
        <input type="button" id="btnExcelDown" class="puddSetup" onclick="periodSerach(1);" value="1주일" style="padding-left: 10px; margin-left:5px; width: 50px;"/>
        <input type="button" id="btnExcelDown" class="puddSetup" onclick="periodSerach(2);" value="1개월" style="padding-left: 10px; width: 50px;"/>
        <input type="button" id="btnExcelDown" class="puddSetup" onclick="periodSerach(3);" value="3개월" style="padding-left: 10px; width: 50px;"/>
	</dl> 
</div>

<div class="sub_contents_wrap">
	<div class="btn_div m0">
		<div class="left_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				<button id="btnPass" onClick="clickButtonDownExcel()">엑셀파일저장</button>
			</div>
		</div>
		
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				 <input id="btnReSend" type="button" value="재발송" style="
	           		background: #1088e3;
				    height: 24px;
				    padding: 0 11px;
				    color: #fff;
				    border: none;
				    font-weight: bold;
				    border-radius: 0px;"
           		>
			</div>
		</div>
	</div>
   
  
    <div style="text-align: center; font-size: 18px;">
        <!-- 그리드 리스트 -->
        <div id="webGrid"></div>
    </div>
</div>

<div id="confirm" style="display:none;"></div>
<div id="jugglingProgressBar"></div>
<div id="loadingProgressBar"></div>
<div id="circularProgressBar"></div>