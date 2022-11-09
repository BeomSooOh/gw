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
	var dataCount = 0;
	
	if(dd<10) {
	    dd='0'+dd
	} 
	
	if(mm<10) {
	    mm='0'+mm
	} 
	
	today = String(yyyy)+String(mm)+String(dd);
	
    $(document).ready(function() {
    	
        // 결과 검색
        $("#btnSearch").click(function(){
        	fnGetData();
        });
        
        // 기간 셋팅
        fnInitDatePicker(6);
        
        fnGetData();
        
    
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
    
    function fnGetData() {
        
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
        	$.ajax({
	            type:"post",
	            url:' <c:url value="/cmm/ex/visitor/getQrPlaceCertificationData.do" />',
	            data: { frDate : frDt, toDate: toDt } ,
	            datatype:"text",
	            success:function(e){
	            	dataCount = e.count;
	                $("#dataCount").html(dataCount);
	            }, error:function(e){                          
	            	alert('조회 실패');
	              }
	         });
        	
        	
        }
    }
    
    var excelDownConfig = {
    		// const 영역
    		//
    		totalCount : 0							// like const
    	,	maxRowSize : 50000						// 엑셀리스트 분할 기준 row 갯수 - 이 부분에서 설정된 이후 변경되지 않음
    	,	fileName : "bizboxAlpha_QrPlaceCertificationList_" + today	// 설정할 엑셀파일명 - 다운 리스트 Dialog 발생되는 경우 엑셀파일명[1].xlsx 형식으로 자동변경함
    	,	url_count : '/gw/cmm/ex/visitor/getQrPlaceCertificationData.do'
    	,	url_list : '/gw/cmm/ex/visitor/getQrPlaceCertificationData.do'
    	 
    		// variable 영역
    		// dataSource 전달에 사용 - 파일 순번에 따라 동적으로 변경되거나 검색어, 날짜 등의 실적용시에 전달 적용할 영역
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
    
	function clickButtonDownExcel(){
    	
    	var puddDialog = Pudd.puddDialog({
 			width : "400"
 		,	height : "100"
 		,	message : {
 				type : "question"
 			,	content : "다운로드 하시겠습니까?"
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
 							
 						// dataSource - count 조회
 					    	var dataSourceCount = new Pudd.Data.DataSource({
 					     
 					    		pageSize : 999999
 					    	,	serverPaging : true
 					    	,	request : {
 					    			url : excelDownConfig.url_count
 					    		,	type : 'post'
 					    		,	dataType : "json"
 					    		,	parameterMapping : function( data ) {
 									 	data.frDate = $("#txtFrDt").val(); 
 									 	data.toDate = $("#txtToDt").val();
 						 				return data ;     
 					    			}
 					    		}
 					     
 					    	,	result : {
 					     
 					    			data : function( response ) {
 					     
 					    				//return response.list;
 					    				return null;
 					    			}
 					     
 					    		,	totalCount : function( response ) {
 					     
 					    				return response.count;
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
 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
 					,	defaultFocus :  true// 기본값 true
 					}
					,	{
					attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
				,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
				,	value : "취소"
				,	clickCallback : function( puddDlg ) {
						puddDlg.showDialog( false );
						returnVal = false;
						self.close();
					}
				}
 				]
 			}	
 		
 		});
    }
    
 	// ----- 개발 화면에 따라 처리할 부분
    //
    function generateExcelDownload( dataPage, fileName, saveCallback, stepCallback ) {
     
    	var excel = new JExcel("맑은 고딕 11 #333333");
    	excel.set( { sheet : 0, value : "Sheet1" } );
     	
		var totalCount = dataPage.length;
		
    	// 엑셀 상단 기간 세팅
    	var periodStyle = excel.addStyle({
    		font: "맑은 고딕 11 #333333 B"
    	})
    	var period = "기간: " + $("#txtFrDt").val() + "~" + $("#txtToDt").val() + " / 총 " + totalCount + "건"; 
    	excel.set(0, 0, 0, period, periodStyle);
    	
    	var formatHeader = excel.addStyle ({
    		border: "thin,thin,thin,thin #000000",
    		fill: "#dedede",
    		font: "맑은 고딕 11 #333333 B",// U : underline, B : bold, I : Italic
    		align : "C C",
    	});
		    	
    	var headerRow = 3;
    	var headerCol = 8;
    	
    	for(var i=1; i < headerRow; i++) {
    		for(var j=0; j < headerCol; j++) {
    			excel.set(0, j, i, null, formatHeader);
    		}
    	}
    	
    	excel.set(0, 0, 1, "No.");
    	excel.mergeCell(0, 0, 1, 0, 2);
    	
    	excel.set(0, 1, 1, "인증일시");
    	excel.mergeCell(0, 1, 1, 1, 2);
    	
    	excel.set(0, 2, 1, "회사");
    	excel.mergeCell(0, 2, 1, 2, 2);
    	
    	excel.set(0, 3, 1, "부서");
    	excel.mergeCell(0, 3, 1, 3, 2);
    	
    	excel.set(0, 4, 1, "사원명");
    	excel.mergeCell(0, 4, 1, 4, 2);
    	
    	excel.set(0, 5, 1, "상세정보");
    	excel.mergeCell(0, 5, 1, 7, 1);
    	
    	excel.set(0, 5, 2, "구분");
    	
    	excel.set(0, 6, 2, "위치명(차량번호)");
    	
    	excel.set(0, 7, 2, "위치상세(좌석번호)");
    	
    	excel.setColumnWidth( 0, 0, 5 );// sheet번호, column, value(width)
    	excel.setColumnWidth( 0, 1, 20 );// sheet번호, column, value(width)
    	excel.setColumnWidth( 0, 2, 20 );// sheet번호, column, value(width)
    	excel.setColumnWidth( 0, 3, 50 );// sheet번호, column, value(width)
    	excel.setColumnWidth( 0, 4, 20 );// sheet번호, column, value(width)
    	excel.setColumnWidth( 0, 5, 20 );// sheet번호, column, value(width)
    	excel.setColumnWidth( 0, 6, 20 );// sheet번호, column, value(width)
    	excel.setColumnWidth( 0, 7, 20 );// sheet번호, column, value(width)
    	
    	var formatCell = excel.addStyle ({
    		align : "C"
    	});
    	
    	// header row 이후부터 출력
    	for( var i = 0; i < totalCount; i++ ) {
    		var rowNo = i + 3;
    		
    		excel.set( 0, 0, rowNo, i+1, formatCell );
    		excel.set( 0, 1, rowNo, dataPage[ i ][ "createDate" ], formatCell );
    		excel.set( 0, 2, rowNo, dataPage[ i ][ "compName" ], formatCell );
    		excel.set( 0, 3, rowNo, dataPage[ i ][ "deptPathName" ], formatCell );
    		excel.set( 0, 4, rowNo, dataPage[ i ][ "empName" ], formatCell );
    		
    		if(dataPage[ i ][ "qrGbnCode" ] === "bus"){
    			excel.set( 0, 5, rowNo, "버스", formatCell );	
    		}else if(dataPage[ i ][ "qrGbnCode" ] === "studio"){
    			excel.set( 0, 5, rowNo, "유튜브 방송실", formatCell );
    		}else if(dataPage[ i ][ "qrGbnCode" ] === "meet"){
    			excel.set( 0, 5, rowNo, "회의실", formatCell );
    		}else{
    			excel.set( 0, 5, rowNo, dataPage[ i ][ "qrGbnCode" ], formatCell );
    		}
    		
    		excel.set( 0, 6, rowNo, dataPage[ i ][ "qrCode" ], formatCell );
    		excel.set( 0, 7, rowNo, dataPage[ i ][ "qrDetailCode" ], formatCell ); 
    	}
     
    	excel.generate( fileName, saveCallback, stepCallback );
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
     
				 	data.frDate = $("#txtFrDt").val(); 
				 	data.toDate = $("#txtToDt").val();
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
    	puddDlg.movePositionDialog( document.getElementById( "excelDownTest" ), "right" );
    }
     
</script>

<div class="top_box">
    <dl>
     	<%-- 추후 다국어 적용 --%>        
        <dt class="ar" style="width: 68px;">인증일시</dt>
        <dd> 
			<input type="text" id="txtFrDt" value="" class="puddSetup" pudd-type="datepicker"  /> ~ <input type="text" id="txtToDt" value="" class="puddSetup" pudd-type="datepicker"/>  
		</dd>
 	<%-- 추후 다국어 적용 --%>        
 		<dd> <input id="btnSearch" type="button" value="조회"> </dd>
    </dl>
    
</div>

<div class="sub_contents_wrap">
	<div class="btn_div m0">
		<div class="left_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
 				<p class="tit_p m0 mt5" id="cntInfoTag">전체 검색결과: <span class="text_blue ml15" id="dataCount">0</span> 건 <button class="ml5" id="btnPass" onClick="clickButtonDownExcel()">엑셀저장</button></p>
				
			</div>
		</div>
	</div>
</div>

<div id="confirm" style="display:none;"></div>
<div id="jugglingProgressBar"></div>
<div id="loadingProgressBar"></div>
<div id="circularProgressBar"></div>