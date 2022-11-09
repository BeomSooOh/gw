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
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.192.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jszip-3.1.5.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/FileSaver-1.2.2_1.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/excel/jexcel-1.0.5.js"></script>

<script type="text/javascript">

var fromDate;
var toDate;
var excel;
var frDth;
var toDth;
var empName;
var menuName;
var size;
var processCnt = 0;
var excelDownConfig = {
	        totalCount : 0
	        , maxRowSize : 65000                                      // 엑셀리스트 분할 기준 row 갯수 - 이 부분에서 설정된 이후 변경되지 않음
	        , multiDown : "N"
	        , fileName : "BizboxAlpha_LoginHistory_"             // 설정할 엑셀파일명 - 다운 리스트 Dialog 발생되는 경우 엑셀파일명[1].xlsx 형식으로 자동변경함
	        , url_list : '/gw/cmm/systemx/satistics/loginSatisticsDataExcel.do'
	        , url_count : '/gw/cmm/systemx/satistics/loginSatisticsDataTotalCnt.do'
	        , parameter : {
	            exType : "0"                                          // 예제 구성을 위해 사용되는 parameter
	            , exSplitExcel : "0"                                  // 예제 구성을 위해 사용되는 parameter - 분할 Dialog에서 사용되는 경우 "1", 아니면 "0"
	            , rowNo : 0                                           // 엑셀리스트 분할 기준 파일 순번 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
	            , rowSize : 0                                         // 엑셀리스트 분할 기준 파일 크기 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
	            , rowStart : 0
	            , startDate : frDth
	            , endDate : toDth
	            , empName : empName
	            , size : size
	            , frDt : 0
	            , gubun : 0
	            , toDt : 0
	        }
	    };
	 
	 
    function generateExcelDownload( sheet, dataPage, fileName, saveCallback, stepCallback ) {
        if (sheet == 0) {
            excel = new JExcel("맑은 고딕 11 #333333");
            var sheetName = "WEB";
            var header = [ "<%=BizboxAMessage.getMessage("TX000000076", "사원명")%>", "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>", "<%=BizboxAMessage.getMessage("TX000000236", "로그인IP")%>", "<%=BizboxAMessage.getMessage("TX000000214", "구분")%>" ];
            var body = [ "empName", "loginDate", "accessIp", "deviceType" ];
        }
        createExcelRow( excel, sheet, sheetName, header, body, dataPage );
        
        excel.generate( fileName, saveCallback, stepCallback );
    }
    
    function generateExcelMultiDownload( rowNo, sheet, dataPage, fileName, saveCallback, stepCallback ) {
        var sheetName1 = "WEB";
        var header1 = [ "<%=BizboxAMessage.getMessage("TX000000076", "사원명")%>", "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>", "<%=BizboxAMessage.getMessage("TX000000236", "로그인IP")%>", "<%=BizboxAMessage.getMessage("TX000000214", "구분")%>" ];
        var body1 = [ "empName", "loginDate", "accessIp", "deviceType" ];
    
        var fileNo = Math.ceil(excelDownConfig.totalCount / excelDownConfig.maxRowSize);
        
        if (sheet == 0) {
            excel = new JExcel("맑은 고딕 11 #333333");
            createExcelRow( excel, sheet, sheetName1, header1, body1, dataPage );
           /*  if ( fileNo != rowNo ) {
                excel.addSheet();
                createExcelRow( excel, 1, sheetName2, header2, body2, null );
            } */
        }
        else if (rowNo == 1){
            excel.addSheet();
            createExcelRow( excel, 1, sheetName2, header2, body2, dataPage );
        }
        else {
            excel = new JExcel("맑은 고딕 11 #333333");
            createExcelRow( excel, 0, sheetName1, header1, body1, null );
            excel.addSheet();
            createExcelRow( excel, sheet, sheetName2, header2, body2, dataPage );
        }
        
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
    }
    
    function clickButtonDownExcel() {
        var dataTotalCnt = new Pudd.Data.DataSource({
            pageSize : 0
            , serverPaging : true
            , request : {
                url : excelDownConfig.url_count
                , type : 'post'
                , dataType : "json"
                , parameterMapping : function( data ) {
                    excelDownConfig.parameter[ "rowNo" ] = 1;
                    
                    data["gubun"] = excelDownConfig.parameter["gubun"];
                    data["empName"] = excelDownConfig.parameter["empName"];
                    data["frDt"] = excelDownConfig.parameter["frDt"];
                    data["toDt"] = excelDownConfig.parameter["toDt"];
                }
            }
            , result : {
                data : function( response ) {
                    excelDownConfig.totalCount = response.totalCount;
                    return response;
                }
                , totalCount : function( response ) {
                }
                , error : function( response ) {
                }
            }
        });
        
        dataTotalCnt.read( false, function(){
            if (excelDownConfig.totalCount > excelDownConfig.maxRowSize) {
                excelDownConfig.multiDown = "Y";
                createExcelDownloadDialog();
            }
            else {
                var fileName = excelDownConfig.parameter.fileName+ ".xlsx"
                excelDownConfig.multiDown = "N";
                loadingStart();
                excelDownloadProcess( 1, excelDownConfig.maxRowSize, fileName );
            }
        });
    }

    function excelDownloadProcess( rowNo, rowSize, fileName ) {
        excelDataSource( rowNo, rowSize, 0, fileName, 0 );
        //excelDataSource( rowNo, rowSize, 0, fileName, 1 );
    }
    
    function excelMultiDownloadProcess( rowNo, rowSize, rowStart, fileName, typeCode ) {
        excelDataSource( rowNo, rowSize, rowStart, fileName, typeCode );
    }
    
    function excelDataSource( rowNo, rowSize, rowStart, fileName, typeCode ) {
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
                    excelDownConfig.parameter[ "rowStart" ] = rowStart;
                    
                   /*  for(var nm in excelDownConfig.parameter) {
                        data[ nm ] = excelDownConfig.parameter[ nm ];
                    } */
                    data["gubun"] = excelDownConfig.parameter["gubun"];
                    data["empName"] = excelDownConfig.parameter["empName"];
                    data["frDt"] = excelDownConfig.parameter["frDt"];
                    data["toDt"] = excelDownConfig.parameter["toDt"];
					data["rowNo"] = excelDownConfig.parameter["rowNo"];
					data["rowSize"] = excelDownConfig.parameter["rowSize"];
					data["rowStart"] = excelDownConfig.parameter["rowStart"];

                    data.maxRowSize = excelDownConfig.maxRowSize;
                    data.multiDown = excelDownConfig.multiDown;
                }
            }
            , result : {
                data : function( response ) {
                    return response.excelList;
                }
                , totalCount : function( response ) {
//                     return response.totalCount;
                }
                , error : function( response ) {
                }
            }
        });

        //TODO 로그인 내역 Api를 보고 수정해야함
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
//                     loadingStart();
                    if (excelDownConfig.totalCount > excelDownConfig.maxRowSize){
                        generateExcelMultiDownload( rowNo, typeCode, dataPage, fileName, function() {
                            loadingStop();
                        }, function( rowIdx ){// stepCallback
                        });
                    }
                    else {
                        generateExcelDownload( typeCode, dataPage, fileName, function() {
                            if (typeCode == 0) loadingStop();
                        }, function( rowIdx ){// stepCallback
                        });
                    }
                }
                else {// error
    //                 progressBarObj.clearIntervalSet();// progressBar 종료
                }
            });
        }, 10);
    }
    
    function createExcelDownloadDialog() {
        // puddCustomDialog 함수 호출
        // 1st 매개변수 - puddDialog에서 사용되는 옵션 + excelDownload callback
        // 2nd 매개변수 - "excelDownload" 문자열 전달
        var puddDlg = Pudd.puddCustomDialog({
            width : 470
            , height : 130
            , modal : false              // 기본값 true
            , draggable : true           // 기본값 true
            , autoResizePosition : false // 기본값 true - 위치가 고정되어야 됨
            , header : {
                title : "엑셀 다운로드"
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
                    var typeCode = 0;
                    var currentFileCnt = rowNo * excelDownConfig.maxRowSize;
                    
                    // totalCount 남은 갯수가 max보다 클때
                    if (excelDownConfig.totalCount > currentFileCnt) {
                        excelMultiDownloadProcess( rowNo, excelDownConfig.maxRowSize, 0, fileName, typeCode );
                    }
                    // totalCount 남은 갯수가 max보다 작을때
                    else {
                        // max - web남은갯수 = mobile 내려받을 갯수
                        var webRestCnt = excelDownConfig.totalCount % excelDownConfig.maxRowSize;
                        var fileNo = Math.ceil(excelDownConfig.totalCount / excelDownConfig.maxRowSize);
                        // web = 0, mobile 일때
                        if (rowNo > fileNo) {
                            rowNo = rowNo - fileNo + 1;
                            typeCode = 1;
                            var mobileRowStart = (rowNo-2)*excelDownConfig.maxRowSize + (excelDownConfig.maxRowSize - webRestCnt);
                            excelMultiDownloadProcess( rowNo, excelDownConfig.maxRowSize, mobileRowStart, fileName, typeCode );
                        }
                        // 0 < web 남은갯수 < max , mobile 일때
                        else {
                            // web 남은갯수 다운
                            excelMultiDownloadProcess( rowNo, excelDownConfig.maxRowSize, 0, fileName, 0 );
                            
                            // max - web남은갯수 = mobile 내려받을 size
                            // excelMultiDownloadProcess( 1, excelDownConfig.maxRowSize - webRestCnt, 0, fileName, 1 );
                        }
                    }
                    
                    
                }
            }
        }, "excelDownload" );
        
        // 클릭한 버튼 객체 아래로 위치시키기
        // 1st 매개변수 - 위치될 기준 객체
        // 2nd 매개변수 - "left" : 왼쪽 기준으로 위치, "right" : 오른쪽 기준으로 위치
        puddDlg.movePositionDialog( document.getElementById( "btnExcelDown" ), "right" );
    }
    
    function loadingStart() {
        if (processCnt == 0) {
            processCnt = 1;
            Pudd( "#jugglingProgressBar" ).puddProgressBar({
                progressType : "juggling"
                , percentText : "다운로드 중 입니다..."
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


	$(document).ready(function(){
	
	    // 결과 검색
	    $("#btnSearch").click(function(){
	    	fnLoginSatisticsGrid();
	    });
	    
	    fnPuddSetLangCode()
	    
	    Pudd( "#txtFrDt" ).puddDatePicker({	    	 
			typeDisplay : "year"
		,	value : ""
		,	disabled : false
		});
	    Pudd( "#txtToDt" ).puddDatePicker({	    	 
			typeDisplay : "year"
		,	value : ""
		,	disabled : false
		});	     
	    // 기간 셋팅
	    fnInitDatePicker(3);
	    
	    // 로그인 데이터 가져오기
	    fnLoginSatisticsGrid();
	});
	
	function fnPuddSetLangCode(){
		 Pudd.Resource.Calendar.weekName = [ "<%=BizboxAMessage.getMessage("TX000003641", "일")%>", "<%=BizboxAMessage.getMessage("TX000003642", "월")%>", "<%=BizboxAMessage.getMessage("TX000000676", "화")%>", "<%=BizboxAMessage.getMessage("TX000000677", "수")%>", "<%=BizboxAMessage.getMessage("TX000000678", "목")%>", "<%=BizboxAMessage.getMessage("TX000000679", "금")%>", "<%=BizboxAMessage.getMessage("TX000000680", "토")%>" ];
		 Pudd.Resource.Calendar.todayNameStr = "<%=BizboxAMessage.getMessage("TX000003149", "오늘")%>";		  
		 Pudd.Resource.Calendar.dayStr = "<%=BizboxAMessage.getMessage("TX000003641", "일")%>";
		 Pudd.Resource.Calendar.weekStr = "<%=BizboxAMessage.getMessage("TX000012332", "주")%>";
		 Pudd.Resource.Calendar.monthStr = "<%=BizboxAMessage.getMessage("TX000018121", "월")%>";
		 Pudd.Resource.Calendar.beforeDayNameStr = "<%=BizboxAMessage.getMessage("", "전일")%>";
		 Pudd.Resource.Calendar.weekNameStr = "<%=BizboxAMessage.getMessage("TX000006543", "주간")%>";
		 Pudd.Resource.Calendar.lastWeekNameStr = "<%=BizboxAMessage.getMessage("", "전주")%>";
		 Pudd.Resource.Calendar.monthNameStr = "<%=BizboxAMessage.getMessage("", "당월")%>";
		 Pudd.Resource.Calendar.lastMonthNameStr = "<%=BizboxAMessage.getMessage("", "전월")%>";
		 Pudd.Resource.Calendar.upToNowNameStr = "<%=BizboxAMessage.getMessage("", "오늘까지")%>";
		 Pudd.Resource.Calendar.firstQuarterNameStr = "1/4<%=BizboxAMessage.getMessage("TX000009444", "분기")%>";
		 Pudd.Resource.Calendar.secondQuarterNameStr = "2/4<%=BizboxAMessage.getMessage("TX000009444", "분기")%>";
		 Pudd.Resource.Calendar.thirdQuarterNameStr = "3/4<%=BizboxAMessage.getMessage("TX000009444", "분기")%>";
		 Pudd.Resource.Calendar.fourthQuarterNameStr = "4/4<%=BizboxAMessage.getMessage("TX000009444", "분기")%>";
		 Pudd.Resource.Calendar.firstHalfNameStr = "<%=BizboxAMessage.getMessage("TX000009443", "상반기")%>";
		 Pudd.Resource.Calendar.secondHalfNameStr = "<%=BizboxAMessage.getMessage("TX000009442", "하반기")%>";
		 Pudd.Resource.Calendar.selectedPeriodNameStr = "<%=BizboxAMessage.getMessage("TX000000696", "선택기간")%>";
		 Pudd.Resource.Calendar.confirmButtonNameStr = "<%=BizboxAMessage.getMessage("TX000019752", "확인")%>";
		 Pudd.Resource.Calendar.cancelButtonNameStr = "<%=BizboxAMessage.getMessage("TX000022128", "취소")%>";
	 }
	
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
	
	function fnLoginSatisticsGrid(){
		var dataSource = new Pudd.Data.DataSource({
			pageSize : 20,
			serverPaging : true,
			request : {
                url: '<c:url value="/cmm/systemx/satistics/loginSatisticsData.do"/>',
				type : 'post',
				dataType : "json",
				parameterMapping : function( tblParam ) {
                    tblParam.gubun = $("#division").val();
                    tblParam.empName = $("#txtEmpName").val();
                    tblParam.frDt = Pudd('#txtFrDt').getPuddObject().getDate() + ' 00:00:00'; 
                    tblParam.toDt = Pudd('#txtToDt').getPuddObject().getDate() + ' 23:59:59';
                    
                    fromDate = Pudd('#txtFrDt').getPuddObject().getDate();
                    toDate = Pudd('#txtToDt').getPuddObject().getDate();
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
				}
			}
		});			

		Pudd("#grid").puddGrid({		 
			dataSource : dataSource,
			scrollable : false,
			resizable : true,
			ellipsis : false,
			pageable : {
				buttonCount : 10,
				pageList : [ 5, 10, 20 ],
				showAlways : false
			},
			columns : [
				{ field : "empName" , title : "<%=BizboxAMessage.getMessage("", "사원명 [ID]")%>" ,
				  content : {template : function( rowData ) {var html = '<label>' + rowData.empName + ' [' + rowData.loginId + ']' + '</label>'; return html;}}
				},
				{ field : "loginDate" , title : "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>" },
				{ field : "accessIp" , title : "<%=BizboxAMessage.getMessage("TX000000236", "로그인IP")%>" },
				{ field : "deviceType" ,title : "<%=BizboxAMessage.getMessage("TX000000214", "구분")%>"}
			]
            , noDataMessage : {
                message : "<%=BizboxAMessage.getMessage("TX000017974", "데이터가 존재하지 않습니다.")%>"
            }
		});
	}

	/* function excelDown() {
		var gubun = $("#division").val();
		var empName = $("#txtEmpName").val();
		var frDt = $("#txtFrDt").val() + ' 00:00:00';
		var toDt = $("#txtToDt").val() + ' 23:59:59';

		var paraStr = "?gubun=" + gubun + "&empName="
				+ encodeURI(encodeURIComponent(empName)) + "&frDt=" + frDt
				+ "&toDt=" + toDt;
		self.location.href = "/gw/cmm/systemx/satistics/loginSatisticsDataExcel.do"
				+ paraStr;
	} */
	
	 function excelDown() {
        var divContent = document.getElementById( "confirm" );

		var gubun = $("#division").val();
        var frDt = Pudd('#txtFrDt').getPuddObject().getDate();
        var toDt = Pudd('#txtToDt').getPuddObject().getDate();
        var frDate = new Date(frDt);
        var toDate = new Date(toDt);
        var yearAgeToth = new Date(Date.parse(toDate) - 364 * 1000 * 60 * 60 * 24);
        
        if (yearAgeToth - frDate > 0) {
            frDt = yearAgeToth.ProcDate();
        }
        
        empName = $("#txtEmpName").val();
    
        excelDownConfig.parameter.startDate = frDt + ' 00:00:00';
        excelDownConfig.parameter.endDate = toDt + ' 23:59:59';
        excelDownConfig.parameter.empName = encodeURI(encodeURIComponent(empName));
        excelDownConfig.parameter.gubun = gubun;
        excelDownConfig.parameter.frDt = frDt + ' 00:00:00';
        excelDownConfig.parameter.toDt = toDt + ' 23:59:59';
        excelDownConfig.parameter.fileName = excelDownConfig.fileName+frDt+"~"+toDt;
        
        clickButtonDownExcel();
	}
</script>

    <div class="top_box">
        <dl>
            <dt class="ar" style="width: 68px;"><%=BizboxAMessage.getMessage("TX000000229", "조회일자")%></dt>
            <dd>
	            <div class="clear">
	            	<div id="txtFrDt" class="fl"></div>
	            	<div class="fl mt5">&nbsp;~&nbsp;</div>
	            	<div id="txtToDt" class="fl"></div>
	            </div>                
            </dd>
            <dt><%=BizboxAMessage.getMessage("TX000000076", "사원명")%></dt>
            <dd>
                <input onkeydown="if(event.keyCode==13){javascript:fnLoginSatisticsGrid();}" type="text" id="txtEmpName" />
            </dd>
            <dt><%=BizboxAMessage.getMessage("TX000000214", "구분")%></dt>
            <dd>
                <select class="puddSetup" id="division" pudd-style="width:100px;">
                    <option value="all" selected><%=BizboxAMessage.getMessage("TX000000862", "전체")%></option>
                    <option value="WEB"><%=BizboxAMessage.getMessage("TX000016163", "웹")%></option>
                    <option value="MESSENGER"><%=BizboxAMessage.getMessage("TX000004025", "메신저")%></option>
                    <option value="MOBILE"><%=BizboxAMessage.getMessage("TX000016053", "모바일")%></option>
                </select>
            </dd>
            <dd>
                <input type="button" onclick="fnLoginSatisticsGrid();"class="puddSetup submit"value="<%=BizboxAMessage.getMessage("TX000001289", "검색")%>" />
            </dd>
        </dl>
    </div>

    <div class="sub_contents_wrap">
        <div id="" class="controll_btn">
            <input onclick="excelDown();" type="button" id="btnExcelDown" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000006928", "엑셀저장")%>" />
        </div>
        <!-- 그리드 리스트 -->
        <div id="grid"></div>
    </div>
 <div id="confirm" style="display:none;"></div>
<div id="jugglingProgressBar"></div>
