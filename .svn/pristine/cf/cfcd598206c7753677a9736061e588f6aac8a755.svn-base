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
    $(document).ready(function() {
        // 결과 검색
        $("#btnSearch").click(function(){
            fnMenuSatisticsGrid();
        });
        
        // 기간 셋팅
        fnInitDatePicker(364);
        
        fnMenuSatisticsGrid();
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
    
    var typeCode = 0;
    function fnMenuSatisticsGrid() {
        // puddTab 함수 호츌
        Pudd( "#menuAccessTab" ).puddTab({
            tabMenu : {
                attributes : { style:"display: inline;", class:"ex01" } //    mt-20
            }
            , tabArea : {
                attributes : { style:"margin-top : 15px", class:"ex02" }
            }
            , newTab : false
            , tabClickCallback : function( idx, tabMenu, tabArea ) {
                // idx : active Tab index ( 0 부터 시작됨 )
                // tabMenu : 활성화된 tab menu li 객체 (DOM 객체)
                // tabArea : 활성화된 tab Area div 객체 (DOM 객체)
                var menuObj = Pudd.getInstance( tabMenu );
                var idStr = menuObj.attr( "id" );
                typeCode = idStr=="mobileTab"?"1":"0";
                
                DrawGrid(typeCode);
            }
        });
        
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
            DrawGrid(typeCode);
        }
    }
    
    function DrawGrid(typeCode) {
        var dataSource = new Pudd.Data.DataSource({
            pageSize : 20
            , serverPaging : true
            , request : {
                type: 'post'
                , dataType: 'json'
                , url: '<c:url value="/menuAccess/searchMenuAccessList.do"/>'
                , parameterMapping : function( data ) {
                    var frDt = $("#txtFrDt").val();
                    var toDt = $("#txtToDt").val();
                    var frDate = new Date(frDt);
                    var toDate = new Date(toDt);
                    var yearAgeToth = new Date(Date.parse(toDate) - 364 * 1000 * 60 * 60 * 24);
                    
                    if (yearAgeToth - frDate > 0) {
                        frDt = yearAgeToth.ProcDate();
                    }
                    
                    data.frDt = frDt + ' 00:00:00';
                    data.toDt = toDt + ' 23:59:59';
                    data.empName = $("#txtEmpName").val() +"";
                    data.menuName = $("#txtMenuName").val() +"";
                    data.typeCode = typeCode;
                }
            }
            , result : {
                data : function( response ) {
                    return response.menuAccessVOList;
                }
                , totalCount : function( response ) {
                    if (response.menuAccessVOList == undefined) {
                        return 0;
                    }
                    else {
                        return response.menuAccessVOList[0].totalCount;
                    }
                }
                , error : function( response ) {
//                     alert( "error - Pudd.Data.DataSource.read, status code - " + response.status );
                }
            }
        });

        if (typeCode == "1") {
            Pudd( "#mobileGrid" ).puddGrid({
                dataSource : dataSource
                , scrollable : false
                , sortable : true
                , resizable : false    // 기본값 false
                , ellipsis : false
                , pageable : {
                    buttonCount : 10
                    , pageList : [ 5, 10, 20 ]
                    , showAlways : false
                }
                , columns : [
                    {
                        field : "empName"
                        , title : "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>"
                    }
                    , {
                        field : "useDate"
                        , title : "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>"
                    }
                    , {
                        field:"menuName"
                        , title:"<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>"
                    }
                    , {
                        field:"useModel"
                        , title:"<%=BizboxAMessage.getMessage("TX900000037", "사용기기")%>"
                    }
                ]
                , noDataMessage : {
                    message : "<%=BizboxAMessage.getMessage("TX000017974", "데이터가 존재하지 않습니다.")%>"
                }
            });
        }
        else {
            Pudd( "#webGrid" ).puddGrid({
                dataSource : dataSource
                , scrollable : false
                , sortable : true
                , resizable : false    // 기본값 false
                , ellipsis : false
                , pageable : {
                    buttonCount : 10
                    , pageList : [ 5, 10, 20 ]
                    , showAlways : false
                }
                , columns : [
                    {
                        field : "empName"
                            , title : "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>"
                    }
                    , {
                        field : "useDate"
                        , title : "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>"
                    }
                    , {
                        field:"menuName"
                        , title:"<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>"
                    }
                    , {
                        field:"accessIp"
                        , title:"<%=BizboxAMessage.getMessage("TX000000245", "사용IP")%>"
                    }
                ]
                , noDataMessage : {
                    message : "<%=BizboxAMessage.getMessage("TX000017974", "데이터가 존재하지 않습니다.")%>"
                }
            });
        }
    }

    var frDth;
    var toDth;
    var empName;
    var menuName;
    var size;

    var excelDownConfig = {
        totalCount : 0
        , webCnt : 0
        , mobileCnt : 0
        , maxRowSize : 25000                                      // 엑셀리스트 분할 기준 row 갯수 - 이 부분에서 설정된 이후 변경되지 않음
        , multiDown : "N"
        , fileName : "BizboxAlpha_MenuAccessHistory_"             // 설정할 엑셀파일명 - 다운 리스트 Dialog 발생되는 경우 엑셀파일명[1].xlsx 형식으로 자동변경함
        , url_list : '/gw/menuAccess/downMenuAccessExcel.do'
        , url_count : '/gw/menuAccess/totalCntMenuAccessList.do'
        , parameter : {
            exType : "0"                                          // 예제 구성을 위해 사용되는 parameter
            , exSplitExcel : "0"                                  // 예제 구성을 위해 사용되는 parameter - 분할 Dialog에서 사용되는 경우 "1", 아니면 "0"
            , rowNo : 0                                           // 엑셀리스트 분할 기준 파일 순번 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
            , rowSize : 0                                         // 엑셀리스트 분할 기준 파일 크기 - 파일 다운로드 리스트에서 해당 파일을 다운로드 클릭시에 순번에 해당되는 값으로 변경
            , rowStart : 0
            , startDate : frDth
            , endDate : toDth
            , empName : empName
            , menuName : menuName
            , typeCode : typeCode
            , size : size
        }
    };
     
    var excel;
    function generateExcelDownload( sheet, dataPage, fileName, saveCallback, stepCallback ) {
        if (sheet == 0) {
            excel = new JExcel("맑은 고딕 11 #333333");
            var sheetName = "WEB";
            var header = [ "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>", "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>", "<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>", "<%=BizboxAMessage.getMessage("TX000000245", "사용IP")%>" ];
            var body = [ "empName", "useDate", "menuName", "accessIp" ];
        }
        else {
            excel.addSheet();
            var sheetName = "MOBILE";
            var header = [ "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>", "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>", "<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>", "<%=BizboxAMessage.getMessage("TX900000037", "사용기기")%>" ];
            var body = [ "empName", "useDate", "menuName", "useModel" ];
        }

        createExcelRow( excel, sheet, sheetName, header, body, dataPage );
        
        excel.generate( fileName, saveCallback, stepCallback );
    }

    function generateExcelMultiDownload( rowNo, sheet, dataPage, fileName, saveCallback, stepCallback ) {
        var sheetName1 = "WEB";
        var header1 = [ "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>", "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>", "<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>", "<%=BizboxAMessage.getMessage("TX000000245", "사용IP")%>" ];
        var body1 = [ "empName", "useDate", "menuName", "accessIp" ];
        var sheetName2 = "MOBILE";
        var header2 = [ "<%=BizboxAMessage.getMessage("TX800002004", "사원명 [ID]")%>", "<%=BizboxAMessage.getMessage("TX000000243", "사용일시")%>", "<%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%>", "<%=BizboxAMessage.getMessage("TX900000037", "사용기기")%>" ];
        var body2 = [ "empName", "useDate", "menuName", "useModel" ];
        
        var fileNo = Math.ceil(excelDownConfig.webCnt/excelDownConfig.maxRowSize);
        
        if (sheet == 0) {
            excel = new JExcel("맑은 고딕 11 #333333");
            createExcelRow( excel, sheet, sheetName1, header1, body1, dataPage );
            if ( fileNo != rowNo ) {
                excel.addSheet();
                createExcelRow( excel, 1, sheetName2, header2, body2, null );
            }
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
                    
                    for(var nm in excelDownConfig.parameter) {
                        data[ nm ] = excelDownConfig.parameter[ nm ];
                    }
                }
            }
            , result : {
                data : function( response ) {
                    excelDownConfig.webCnt = response.hashMap.webCnt;
                    excelDownConfig.mobileCnt = response.hashMap.mobileCnt;
                    excelDownConfig.totalCount = excelDownConfig.webCnt + excelDownConfig.mobileCnt;
                    return response.hashMap;
                }
                , totalCount : function( response ) {
                }
                , error : function( response ) {
                }
            }
        });
        
        dataTotalCnt.read( false, function(){
            if (excelDownConfig.webCnt > excelDownConfig.maxRowSize || excelDownConfig.mobileCnt > excelDownConfig.maxRowSize) {
                excelDownConfig.multiDown = "Y";
                createExcelDownloadDialog();
            }
            else {
                var fileName = excelDownConfig.parameter.fileName+ ".xlsx"
                excelDownConfig.multiDown = "N";
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
                                attributes : {} // control 부모 객체 속성 설정
                                , controlAttributes : { id : "btnConfirm", class : "submit" } // control 자체 객체 속성 설정
                                , value : "<%=BizboxAMessage.getMessage("TX000000078", "확인")%>"
                                , clickCallback : function( puddDlg ) {
                                    puddDlg.showDialog( false );
                                    loadingStart();
                                    excelDownloadProcess( 1, excelDownConfig.maxRowSize, fileName );
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
        });
    }

    function excelDownloadProcess( rowNo, rowSize, fileName ) {
        excelDataSource( rowNo, rowSize, 0, fileName, 0 );
        excelDataSource( rowNo, rowSize, 0, fileName, 1 );
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
                    excelDownConfig.parameter[ "typeCode" ] = typeCode;
                    
                    for(var nm in excelDownConfig.parameter) {
                        data[ nm ] = excelDownConfig.parameter[ nm ];
                    }
                    data.maxRowSize = excelDownConfig.maxRowSize;
                    data.multiDown = excelDownConfig.multiDown;
                }
            }
            , result : {
                data : function( response ) {
                    return response.menuAccessVOList;
                }
                , totalCount : function( response ) {
//                     return response.totalCount;
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
//                     loadingStart();
                    if (excelDownConfig.webCnt > excelDownConfig.maxRowSize || excelDownConfig.mobileCnt > excelDownConfig.maxRowSize){
                        generateExcelMultiDownload( rowNo, typeCode, dataPage, fileName, function() {
                            loadingStop();
                        }, function( rowIdx ){// stepCallback
                        });
                    }
                    else {
                        generateExcelDownload( typeCode, dataPage, fileName, function() {
                            if (typeCode == 1) loadingStop();
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
                    var typeCode = 0;
                    var currentFileCnt = rowNo * excelDownConfig.maxRowSize;
                    
                    // web 남은 갯수가 max보다 클때
                    if (excelDownConfig.webCnt > currentFileCnt) {
                        excelMultiDownloadProcess( rowNo, excelDownConfig.maxRowSize, 0, fileName, typeCode );
                    }
                    // web 남은 갯수가 max보다 작을때
                    else {
                        // max - web남은갯수 = mobile 내려받을 갯수
                        var webRestCnt = excelDownConfig.webCnt%excelDownConfig.maxRowSize;
                        var fileNo = Math.ceil(excelDownConfig.webCnt/excelDownConfig.maxRowSize);
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
                            excelMultiDownloadProcess( 1, excelDownConfig.maxRowSize - webRestCnt, 0, fileName, 1 );
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

    function excelDown() {
        var divContent = document.getElementById( "confirm" );

        var frDt = $("#txtFrDt").val();
        var toDt = $("#txtToDt").val();
        var frDate = new Date(frDt);
        var toDate = new Date(toDt);
        var yearAgeToth = new Date(Date.parse(toDate) - 364 * 1000 * 60 * 60 * 24);
        
        if (yearAgeToth - frDate > 0) {
            frDt = yearAgeToth.ProcDate();
        }
        
        empName = $("#txtEmpName").val();
        menuName = $("#txtMenuName").val();
    
        excelDownConfig.parameter.startDate = frDt + ' 00:00:00';
        excelDownConfig.parameter.endDate = toDt + ' 23:59:59';
        excelDownConfig.parameter.empName = empName;
        excelDownConfig.parameter.menuName = menuName;
        excelDownConfig.parameter.typeCode = typeCode;
        excelDownConfig.parameter.fileName = excelDownConfig.fileName+frDt+"~"+toDt;
        
        clickButtonDownExcel();
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
    
    function preList() {
        openWindow("/gw/cmm/systemx/satistics/menuSatisticsViewPop.do", 1000, 900, 1);
    }
</script>


<div class="top_box">
    <dl>
        <dt class="ar" style="width: 68px;"><%=BizboxAMessage.getMessage("TX000000229", "조회일자")%></dt>
        <dd> <input type="text" id="txtFrDt" value="" class="puddSetup" pudd-type="datepicker"  /> ~ <input type="text" id="txtToDt" value="" class="puddSetup" pudd-type="datepicker"  /> </dd>
        <dt><%=BizboxAMessage.getMessage("TX000000076", "사원명")%></dt>
        <dd><input id="txtEmpName" type="text" style="width:150px;" class="puddSetup" value="" onkeydown="if(event.keyCode==13){javascript:fnMenuSatisticsGrid();}" /></dd>
        <dt><%=BizboxAMessage.getMessage("TX000000120", "메뉴명")%></dt>
        <dd><input id="txtMenuName" type="text" style="width:150px;" class="puddSetup" value="" onkeydown="if(event.keyCode==13){javascript:fnMenuSatisticsGrid();}" /></dd>
        <dd> <input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289", "검색")%>"> </dd>
    </dl>
</div>

<div class="sub_contents_wrap">

        <div id="" class="controll_btn"  style="display: inline; float: right; margin-top: 10px;">
            <button id="btnPreList" class="puddSetup" onclick="preList();"> <%=BizboxAMessage.getMessage("TX000022967", "이전사용내역")%> </button>
            <input type="button" id="btnExcelDown" class="puddSetup" onclick="excelDown();" value="<%=BizboxAMessage.getMessage("TX000006928", "엑셀저장")%>" />
        </div>

        <span id="" style="margin-top: 27px;color: red;position: absolute;margin-left: 160px;"><b><%=BizboxAMessage.getMessage("TX900000603", "※ 최근 1년 데이터만 제공됩니다.")%></b></span>

    <div id="menuAccessTab">
        <ul>
            <li id="webTab">WEB</li>
            <li id="mobileTab">Mobile</li>
        </ul>
        <div style="text-align: center; padding: 55px 0px 0px 0px; font-size: 18px;">
            <!-- 그리드 리스트 -->
            <div id="webGrid"></div>
        </div>
        <div style="text-align: center; padding: 55px 0px 0px 0px; font-size: 18px;">
            <div id="mobileGrid"></div>
        </div>
    </div>
</div>

<div id="confirm" style="display:none;"></div>
<div id="jugglingProgressBar"></div>