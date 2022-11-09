<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
	<head>

		<!--css-->
		<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
		<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
		<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
		<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">
		    
		<!--js-->
		<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>
		<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jszip-3.1.5.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/FileSaver-1.2.2_1.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jexcel-1.0.5.js"></script>
	
		<script type="text/javascript">
		
		var fromDate;
		var toDate;

		$(document).ready(function() {
	        // 기간 셋팅
			fnInitDatePicker(364);
			
			gridRead();
			
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
		
		function gridRead(){
			var dataSource = new Pudd.Data.DataSource({
				pageSize : 20
			,	serverPaging : true
			,	request : {
					url :'/gw/cmm/systemx/satistics/menuSatisticsData.do'
				,	type : 'post'
				,	dataType : "json"
				,	parameterMapping : function( tblParam ) {
					
						tblParam.take = "20";
						tblParam.skip = "0";
						tblParam.empName = empName.value;
						tblParam.menuName = menuName.value;
						tblParam.frDt = $('#txtFrDt').val() + ' 00:00:00'; 
						tblParam.toDt = $('#txtToDt').val() + ' 23:59:59';
						
						fromDate = $('#txtFrDt').val();
						toDate = $('#txtToDt').val();
					
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
					}
				}
			});			

			Pudd("#grid").puddGrid({		 
					dataSource : dataSource
				,	scrollable : false
				,	sortable : true			
				,	resizable : true
				,	ellipsis : false
 				,	hoverUse : false
				,	pageable : {
					buttonCount : 10,
					pageList : [ 5, 10, 20 ],
					//,	showAlways : true	// 기본값 true - data totalCount가 0 이라도 pager 표시함
								// false 설정한 경우는 data totalCount가 0 이면 pager가 표시되지 않음
 					pageInfo : true	// pageInfo 표시 여부,  예) 1-13 페이지 / 총 123 개
                   , showAlways : false
				}
				,	columns : [
						{
							field : "empName"
						,	title : "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>"
						}
					,	{
							field : "useDate"
						,	title : "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>"
						}
					,	{
							field : "menuName"
						,	title : "<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>"
						}
					,	{
							field : "accessIp"
						,	title : "<%=BizboxAMessage.getMessage("TX000000245", "사용IP")%>"
						}
					]
			});
		}
		
	    var excelDownConfig = {
            totalCount : 0                                        // like const
            , maxRowSize : 25000                                      // 엑셀리스트 분할 기준 row 갯수 - 이 부분에서 설정된 이후 변경되지 않음
            , fileName : "BizboxAlpha_MenuAccessPreviousHistory_"         // 설정할 엑셀파일명 - 다운 리스트 Dialog 발생되는 경우 엑셀파일명[1].xlsx 형식으로 자동변경함
            , url_list : '/gw/cmm/systemx/satistics/menuSatisticsDataExcel.do'
            , parameter : {
                exType : "0"        // 예제 구성을 위해 사용되는 parameter
                , exSplitExcel : "0"    // 예제 구성을 위해 사용되는 parameter - 분할 Dialog에서 사용되는 경우 "1", 아니면 "0"
                , rowNo : 0            // 엑셀리스트 분할 기준 파일 순번 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
                , rowSize : 0        // 엑셀리스트 분할 기준 파일 크기 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
                , startDate : $('#txtFrDt').val()
                , endDate : $('#txtToDt').val()
                , empName : ""
                , menuName : ""
                , size : 0
            }
        };
		
		function excelDown(){
			var GridObj = Pudd("#grid").getPuddObject();
		    excelDownConfig.parameter.startDate = $('#txtFrDt').val() + ' 00:00:00'; 
			excelDownConfig.parameter.endDate = $('#txtToDt').val() + ' 23:59:59';		  
			excelDownConfig.parameter.fileName = excelDownConfig.fileName+$('#txtFrDt').val()+"~"+$('#txtToDt').val();
			excelDownConfig.parameter.empName = empName.value;
			excelDownConfig.parameter.menuName = menuName.value;
			
			excelDownConfig.totalCount = GridObj.optObject.dataSource.totalCount;
			if( excelDownConfig.totalCount > excelDownConfig.maxRowSize ){
				createExcelDownloadDialog();
			}
			else {
    	        Pudd.puddDialog({
    	            width : 500
    	            , height : 100
    	            , message : {
    	                type : "question"
    	                , content : "<%=BizboxAMessage.getMessage("TX000022968", "사용내역이 많은 경우 다소 시간이 소요될 수 있습니다.<br> 다운로드 하시겠습니까?")%>"
    	            }
    	            , footer : {
    	                buttons : [
    	                    {
    	                        attributes : {}// control 부모 객체 속성 설정
    	                        , controlAttributes : { id : "btnConfirm", class : "submit" } // control 자체 객체 속성 설정
    	                        , value : "<%=BizboxAMessage.getMessage("TX000000078", "확인")%>"
    	                        , clickCallback : function( puddDlg ) {
    	                		    puddDlg.showDialog( false );
    	                		    loadingStart();
    	                		    var fileName = excelDownConfig.parameter.fileName + ".xlsx";
    	                		    excelDataSource( 1, excelDownConfig.maxRowSize, fileName );
    	                        }
    	                        , defaultFocus :true// 기본값 true
    	                    }
    	                    , {
    	                        attributes : { style : "margin-left:5px;" }
    	                        , controlAttributes : { id : "btnCancel" }
    	                        , value : "<%=BizboxAMessage.getMessage("TX000002947", "취소")%>"
    	                        , clickCallback : function( puddDlg ) {
    	                            puddDlg.showDialog( false );
    	                        }
    	                    }
    	                ]
    	            }
    	        });
			}
	    }
		
	    function createExcelDownloadDialog() {
	        // puddCustomDialog 함수 호출
	        // 1st 매개변수 - puddDialog에서 사용되는 옵션 + excelDownload callback
	        // 2nd 매개변수 - "excelDownload" 문자열 전달
	        var puddDlg = Pudd.puddCustomDialog({
	            width : 500
	            , height : 130
	            , modal : false              // 기본값 true
	            , draggable : true           // 기본값 true
	            , autoResizePosition : false // 기본값 true - 위치가 고정되어야 됨
	            , header : {
	                title : "<%=BizboxAMessage.getMessage("TX000002977", "엑셀")%>"+ " <%=BizboxAMessage.getMessage("TX000001687", "다운로드")%>"
	                , align : "left"         // left, center, right
	                , closeButton : true     // 기본값 true
	            }
	            , body : { }
	            , excelDownload : {
	                totalCount : excelDownConfig.totalCount
	                , maxRowSize : excelDownConfig.maxRowSize
	                , fileName : excelDownConfig.parameter.fileName
	                , listClick : function( rowNo, rowSize, fileName ) {
	                    loadingStart();
	                    excelDataSource( rowNo, rowSize, fileName );
	                }
	            }
	        }, "excelDownload" );
	        
	        // 클릭한 버튼 객체 아래로 위치시키기
	        // 1st 매개변수 - 위치될 기준 객체
	        // 2nd 매개변수 - "left" : 왼쪽 기준으로 위치, "right" : 오른쪽 기준으로 위치
	        puddDlg.movePositionDialog( document.getElementById( "btnExcelDown" ), "right" );
	    }
	    
	    function excelDataSource( rowNo, rowSize, fileName ) {
	        var dataSourceList = new Pudd.Data.DataSource({
	            pageSize : rowSize
	            , serverPaging : true
	            , request : {
	                url : excelDownConfig.url_list
	                , type : 'post'
	                , dataType : "json"
	                , parameterMapping : function( data ) {
	                    excelDownConfig.parameter[ "rowNo" ] = rowNo;
	                    excelDownConfig.parameter[ "rowSize" ] = rowSize;
	                    
	                    for(var nm in excelDownConfig.parameter) {
	                        data[ nm ] = excelDownConfig.parameter[ nm ];
	                    }
	                    data.maxRowSize = excelDownConfig.maxRowSize;
	                }
	            }
	            , result : {
	                data : function( response ) {
	                    return response.list;
	                }
	                , totalCount : function( response ) {
//	                     return response.totalCount;
	                }
	                , error : function( response ) {
	                }
	            }
	        });

	        setTimeout( function() {
	            dataSourceList.read( false, function(){
	                if( true == dataSourceList.responseResult ) {
	                    
	                    var dataPage = dataSourceList.dataPage;
	                    var dataLen;
	                    if (dataPage != null) {
	                        dataLen = dataPage.length;
	                    }
	                    else {
	                        dataLen = null;
	                    }
	                    
                        generateExcelDownload( 0, dataPage, fileName, function() {
                            loadingStop();
                        }, function( rowIdx ){// stepCallback
                        });
	                }
	                else {// error
	    //                 progressBarObj.clearIntervalSet();// progressBar 종료
	                }
	            });
	        }, 10);
	    }
	    
	    function generateExcelDownload( sheet, dataPage, fileName, saveCallback, stepCallback ) {
	        var excel = new JExcel("맑은 고딕 11 #333333");
            var sheetName = "WEB";
            var header = [ "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>", "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>", "<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>", "<%=BizboxAMessage.getMessage("TX000000245", "사용IP")%>" ];
            var body = [ "empName", "useDate", "menuName", "accessIp" ];

	        createExcelRow( excel, sheet, sheetName, header, body, dataPage );
	        
	        excel.generate( fileName, saveCallback, stepCallback );
	    }
	    
	    function createExcelRow( excel, sheet, sheetName, header, body, dataPage ) {

	        excel.set( { sheet : sheet, value : sheetName } );
	        
	        var formatHeader = excel.addStyle ({
	            border: "thin,thin,thin,thin #000000",
	            fill: "#dedede",
	            font: "맑은 고딕 11 #333333 B",// U : underline, B : bold, I : Italic
	            align : "C"
	        });
	        
	        for( var i=0; i<header.length; i++ ) {
	            excel.set( sheet, i, 0, header[i], formatHeader );// sheet번호, column, row, value, style
	            excel.setColumnWidth( sheet, i, 30 );// sheet번호, column, value(width)
	        }
	        
	        var formatCell = excel.addStyle ({
	            align : "C"
	        });
	        
	        if (dataPage != null) {
	            // header row 이후부터 출력
	            var totalCount = dataPage.length;
	            for( var i = 0; i < totalCount; i++ ) {
	                var rowNo = i + 1;
	                for ( var j = 0; j < body.length; j++ ) {
	                    excel.set( sheet, j, rowNo, dataPage[i][ body[j] ] );
	                }
	            }
	        }
//	         else {
	<%--             excel.set( sheet, 0, 1, "<%=BizboxAMessage.getMessage("TX000017974", "데이터가 존재하지 않습니다.")%>" ); --%>
//	         }
	    }
	    
	    var processCnt = 0;
	    function loadingStart() {
	        if (processCnt == 0) {
	            processCnt = 1;
	            Pudd( "#jugglingProgressBar" ).puddProgressBar({
	                progressType : "juggling"
	                , percentText : "Downloading..."
	                , progressCallback : function( progressBarObj ) {
	                    return processCnt;
	                }
	            });
	        }
	    }
	    
	    function loadingStop() {
	        processCnt = 0;
	        Pudd("#jugglingProgressBar").getPuddObject().clearIntervalSet();
	    }
	    
		</script>
	</head>
	<body class="">
		<div class="pop_wrap" style="border: none;">
			<div class="pop_head">
				<h1><%=BizboxAMessage.getMessage("TX000022967", "이전사용 내역")%></h1>
			</div>
			<!-- // -->
			<div class="pop_con">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000022966", "WEB 사용내역")%></p>
				<div class="top_box">
					<dl class="dl1">
						<dt style="" class="ar"><%=BizboxAMessage.getMessage("TX000000229", "조회일자")%></dt>
                        <dd> <input type="text" id="txtFrDt" value="" class="puddSetup" pudd-type="datepicker"  /> ~ <input type="text" id="txtToDt" value="" class="puddSetup" pudd-type="datepicker"  /> </dd>
						<dt><%=BizboxAMessage.getMessage("TX000000076", "사원명")%></dt>
						<dd><input id="empName" type="text" style="width:150px;" class="puddSetup" value="" onkeydown="if(event.keyCode==13){javascript:gridRead();}" /></dd>
						<dt><%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%></dt>
						<dd><input id="menuName" type="text" style="width:150px;" class="puddSetup" value="" onkeydown="if(event.keyCode==13){javascript:gridRead();}" /></dd>
					<dd><input type="button" onclick="gridRead();" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001289", "검색")%>" /></dd>
					</dl>
				</div>
				<div class="btn_div">
					<div class="right_div">
						<input onclick="excelDown();" type="button" id="btnExcelDown" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000006928", "엑셀저장")%>" />
					</div>	
				</div>
				<div id="grid"></div>
			</div>
		</div>
        <div id="confirm" style="display:none;"></div>
        <div id="jugglingProgressBar"></div>
	</body>
</html>