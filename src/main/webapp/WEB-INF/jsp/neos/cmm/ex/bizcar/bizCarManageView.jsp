<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href='<c:url value="/js/Scripts/jqueryui/jquery-ui.css"></c:url>' />
<link rel="stylesheet" type="text/css" href='<c:url value="/js/ex/pudd-ex.css"></c:url>' />
<script type="text/javascript" src='<c:url value="/js/Scripts/jqueryui/jquery-ui.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ex/ex-ui-1.0.1.js"></c:url>'></script>
<style>
#modal-bg {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,.3);
    z-index: 10;
}
#carnum-modal {
    display: none;
    position: fixed;
    left: calc( 50% - 160px ); top: calc( 50% - 70px );
    width: 320px; height: 140px; 
    background: #fff;
    z-index: 11;
    padding: 10px;
}
.ui-button .ui-icon {background-image: none !important;}
.controll_btn button:disabled {border:1px solid #c9cac9;background:#f0f0f0;cursor:default;}
</style>

<script type="text/javascript">

/* 전역 변수 */
var loginV = "${loginVO}";
var erpCloseDt = "";

var rgx1 = /\D/g;  // /[^0-9]/g 와 같은 표현
var rgx2 = /(\d+)(\d{3})/;

/* 운행기록부 테이블 컬럼 */	
var consTableColumn = [{
    title: '<input type="checkbox" name="inp_chkAll" onclick="fnCheck(this);"/>', /* 제목 */
    display: 'Y',
	displayKey: '',
	colKey: 'chkBox',
	width: '30px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: 'checkbox', /* 입력 포맷 (text, combo, datepicker) */
    disabled: '', //disabled
    data: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	return true;
    }
},{
    title: '차량코드', /* 제목 */
    display: 'N', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'carCode', /* json 연동 키 */
    width: '80px', /* 너비 */
    reqYN: 'Y', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	return true;
    }
},{
    title: '차량', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'carNum', /* json 연동 키 */
    width: '80px', /* 너비 */
    reqYN: 'Y', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	/* if(event.keyCode=='13'){
    		fnCarNumPopOpen();
    	} */
    	//값 변경 이벤트 체크
    	//$('#rowEditCheck').val("Y");
    	return true;
    }
},{
    title: '시퀀스', /* 제목 */
    display: 'N', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'seqNum', /* json 연동 키 */
    width: '80px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	return true;
    }
}, {
	title: '운행일자',
	display: 'Y',
	displayKey: '',
	colKey: 'driveDate',
	width: '80px',
	reqYN: 'Y',
	align: 'center', /* 정렬 */
    type: 'datepicker', /* 입력 포맷 (text, combo, datepicker) */
    comboData: {},
    disabled: '',
    classes: '',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
    keyDownBefore : function(obj){
    	if(obj.keyCode=='13' || obj.keyCode=='1'){
    		//var date = obj.data.driveDate;
    		
    		//var chk = chkDateStr(date); //날짜형식 데이터 체크
    	}
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
}, {
	title: '운행구분',
	display: 'Y',
	displayKey: '',
	colKey: 'driveFlag',
	width: '80px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: 'combo', /* 입력 포맷 (text, combo, datepicker) */
    comboData: {
    	code: 'driveFlagCode',
        name: 'driveFlag',
        list: [
            { 'driveFlagCode': '1', 'driveFlag': '출근' },
            { 'driveFlagCode': '2', 'driveFlag': '퇴근' },
			{ 'driveFlagCode': '3', 'driveFlag': '출퇴근' },
			{ 'driveFlagCode': '4', 'driveFlag': '업무용' },
            { 'driveFlagCode': '5', 'driveFlag': '비업무용' }
        ]
    },
    disabled: '',
    classes: '',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
}, {
    title: '출발시간', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'startTime', /* json 연동 키 */
    width: '80px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
}, {
    title: '도착시간', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'endTime', /* json 연동 키 */
    width: '80px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
}, {
	title: '출발구분',
	display: 'Y',
	displayKey: '',
	colKey: 'startFlag',
	width: '100px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: 'combo', /* 입력 포맷 (text, combo, datepicker) */
    comboData: {
    	code: 'startFlagCode',
        name: 'startFlag',
        list: [
            { 'startFlagCode': '0', 'startFlag': '직접입력' },
            { 'startFlagCode': '1', 'startFlag': '회사' },
			{ 'startFlagCode': '2', 'startFlag': '자택' },
			{ 'startFlagCode': '3', 'startFlag': '거래처' },
            { 'startFlagCode': '4', 'startFlag': '직전출발지' }
        ]
    },
    disabled: '',
    classes: '',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
    keyDownBefore : function(obj){
    	if(obj.keyCode=='13' || obj.keyCode=='1'){
    		//출발구분 선택 체크
    		var ywrow = $('#tbl_bizcarTop').extable('getSelectedRowData');
        	var sFlag = obj.data.startFlag;
        	if(sFlag != ""){
        		if(isNaN(sFlag) != false){ //입력값이 문자열일때 숫자로 변환.
            		sFlag = setStartFlag("num",sFlag);
            	}
            	switch (sFlag) {
            	case "0": obj.data.startFlag = "직접입력"; obj.data.startFlagCode = "0"; break;
    	  		  case "1": obj.data.startFlag = "회사"; obj.data.startFlagCode = "1"; break;
    	  		  case "2": obj.data.startFlag = "자택"; obj.data.startFlagCode = "2"; break;
    	  		  case "3": obj.data.startFlag = "거래처"; obj.data.startFlagCode = "3"; break;
    	  		  case "4": obj.data.startFlag = "직전출발지"; obj.data.startFlagCode = "4"; break;
    	  		default: obj.data.startFlag = ""; obj.data.startFlagCode = ""; break;
    	  		}
            	
            	var aa = obj.data.startFlagCode;
            	
            	//직접입력 선택시
            	if(aa == '0'){
            		$('#tbl_bizcarTop').extable('setRowData', { startAddr: ""}, ywrow.colIndex, ywrow.rowIndex);
            	}else if(aa == '1'){
            		//구분값에 따라 주소입력설정이 되어있으면 자택,회사 정보 가져오기
                	//회사 선택시
            		var tblParam = {};
            		$.ajax({
            	    	type:"post",
            			url:'<c:url value="/cmm/ex/bizcar/pop/getUserAddress.do"/>',
            			datatype:"json",
            			data: tblParam ,
            			contenttype: "application/json;",
            		    success:function(data){
            				var result = data.result;
            				if(result > 0){
            					var addr = data.userAddressInfo;
            					$('#tbl_bizcarTop').extable('setRowData', { startAddr: addr.compAddr }, ywrow.colIndex, ywrow.rowIndex);
            					$('#inp_startAddr').val(addr.compAddr);
            				}
            			}
            			, error:function(data){
            				//alert("조회시 오류가 발생하였습니다.");
            			}
            		});
        		}else if(aa == '2'){
            		//자택 선택시
            		var tblParam = {};
            		$.ajax({
            	    	type:"post",
            			url:'<c:url value="/cmm/ex/bizcar/pop/getUserAddress.do"/>',
            			datatype:"json",
            			data: tblParam ,
            			contenttype: "application/json;",
            		    success:function(data){
            				var result = data.result;
            				if(result > 0){
            					var addr = data.userAddressInfo;
            					$('#tbl_bizcarTop').extable('setRowData', { startAddr: addr.houseAddr }, ywrow.colIndex, ywrow.rowIndex);
            					$('#inp_startAddr').val(addr.houseAddr);
            				}
            			}
            			, error:function(data){
            				//alert("조회시 오류가 발생하였습니다.");
            			}
            		});
        		}else if(aa == '3'){
            		//거래처 선택시
            		var rowSeq = "S_"+ywrow.colIndex+"_"+ywrow.rowIndex;
            		//거래처 조회 팝업 호출
            		fnTradePopOpen(rowSeq);
            		
        		}else if(aa == '4'){
            		//직전출발지 선택시
            		if(ywrow.rowIndex != '0'){
            			var beforeRow = $('#tbl_bizcarTop').extable('getRowData', ywrow.rowIndex-1); //이전 행 데이터 가져오기
                		$('#tbl_bizcarTop').extable('setRowData', { startAddr: beforeRow.startAddr, startFlag: beforeRow.startFlag, startAddrDetail: beforeRow.startAddrDetail }, ywrow.colIndex, ywrow.rowIndex);
                		$('#inp_startAddr').val(beforeRow.startAddrDetail);
            		}
            	}else{
            		//그외
            		alert('출발구분 값을 확인해주세요');
            		$('#tbl_bizcarTop').extable('setRowData', { startAddr: "" }, ywrow.colIndex, ywrow.rowIndex);
            		$('#inp_startAddr').val("");
            	}
        	}        	
        	
    	}

    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
}, {
    title: '출발지', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'startAddr', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
}, {
    title: '출발지상세', /* 제목 */
    display: 'N', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'startAddrDetail', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	return true;
    }
}, {
	title: '도착구분',
	display: 'Y',
	displayKey: '',
	colKey: 'endFlag',
	width: '100px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: 'combo', /* 입력 포맷 (text, combo, datepicker) */
    comboData: {
    	code: 'endFlagCode',
        name: 'endFlag',
        list: [
            { 'endFlagCode': '0', 'endFlag': '직접입력' },
            { 'endFlagCode': '1', 'endFlag': '회사' },
			{ 'endFlagCode': '2', 'endFlag': '자택' },
			{ 'endFlagCode': '3', 'endFlag': '거래처' },
            { 'endFlagCode': '4', 'endFlag': '직전도착지' }
        ]
    },
    disabled: '',
    classes: '',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
    keyDownBefore : function(obj){
    	if(obj.keyCode=='13' || obj.keyCode=='1'){
    		//도착구분 선택 체크
    		var ywrow = $('#tbl_bizcarTop').extable('getSelectedRowData');
    		
    		var eFlag = obj.data.endFlag;
    		if(eFlag != ""){
    			if(isNaN(eFlag) != false){ //입력값이 문자열일때 숫자로 변환.
        			eFlag = setEndFlag("num",eFlag);
        		}
            	switch (eFlag) {
            	case "0": obj.data.endFlag = "직접입력"; obj.data.endFlagCode = "0"; break;
    	  		  case "1": obj.data.endFlag = "회사"; obj.data.endFlagCode = "1"; break;
    	  		  case "2": obj.data.endFlag = "자택"; obj.data.endFlagCode = "2"; break;
    	  		  case "3": obj.data.endFlag = "거래처"; obj.data.endFlagCode = "3"; break;
    	  		  case "4": obj.data.endFlag = "직전도착지"; obj.data.endFlagCode = "4"; break;
    	  		default: obj.data.endFlag = ""; obj.data.endFlagCode = ""; break;
    	  		}
            	
            	var bb = obj.data.endFlagCode;
            	
            	//직접입력 선택시
            	if(bb == '0'){
            		$('#tbl_bizcarTop').extable('setRowData', { endAddr: ""}, ywrow.colIndex, ywrow.rowIndex);
            	}else if(bb == '1'){
            		//구분값에 따라 주소입력설정이 되어있으면 자택,회사 정보 가져오기
                	//회사 선택시
            		var tblParam = {};
            		$.ajax({
            	    	type:"post",
            			url:'<c:url value="/cmm/ex/bizcar/pop/getUserAddress.do"/>',
            			datatype:"json",
            			data: tblParam ,
            			contenttype: "application/json;",
            		    success:function(data){
            				var result = data.result;
            				if(result > 0){
            					var addr = data.userAddressInfo;
            					$('#tbl_bizcarTop').extable('setRowData', { endAddr: addr.compAddr }, ywrow.colIndex, ywrow.rowIndex);
            					$('#inp_endAddr').val(addr.compAddr);
            				}
            			}
            			, error:function(data){
            				//alert("조회시 오류가 발생하였습니다.");
            			}
            		});
        		}else if(bb == '2'){
        			//자택 선택시
            		var tblParam = {};
            		$.ajax({
            	    	type:"post",
            			url:'<c:url value="/cmm/ex/bizcar/pop/getUserAddress.do"/>',
            			datatype:"json",
            			data: tblParam ,
            			contenttype: "application/json;",
            		    success:function(data){
            				var result = data.result;
            				if(result > 0){
            					var addr = data.userAddressInfo;
            					$('#tbl_bizcarTop').extable('setRowData', { endAddr: addr.houseAddr }, ywrow.colIndex, ywrow.rowIndex);
            					$('#inp_endAddr').val(addr.houseAddr);
            				}
            			}
            			, error:function(data){
            				//alert("조회시 오류가 발생하였습니다.");
            			}
            		});
        		}else if(bb == '3'){
            		//거래처 선택시
            		var rowSeq = "E_"+ywrow.colIndex+"_"+ywrow.rowIndex;
            		//거래처 조회 팝업 호출
            		fnTradePopOpen(rowSeq);
            		
        		}else if(bb == '4'){
            		//직전도착지 선택시
            		if(ywrow.rowIndex != '0'){
            			var beforeRow = $('#tbl_bizcarTop').extable('getRowData', ywrow.rowIndex-1); //이전 행 데이터 가져오기
                		$('#tbl_bizcarTop').extable('setRowData', { endAddr: beforeRow.endAddr, endFlag: beforeRow.endFlag, endAddrDetail: beforeRow.endAddrDetail }, ywrow.colIndex, ywrow.rowIndex);
            			$('#inp_endAddr').val(beforeRow.endAddrDetail);
            		}
        		}else{
        			//그외
        			alert('도착구분 값을 확인해주세요');
        			$('#tbl_bizcarTop').extable('setRowData', { endAddr: "" }, ywrow.colIndex, ywrow.rowIndex);
        			$('#inp_endAddr').val("");
        		}
    		}
    		
    	}
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
}, {
    title: '도착지', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'endAddr', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	
    	return true;
    }
}, {
    title: '도착지상세', /* 제목 */
    display: 'N', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'endAddrDetail', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	return true;
    }
},{
    title: '주행전(Km)', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'beforeKm', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//숫자형식만 입력되도록
   		/* var ywrow = $('#tbl_bizcarTop').extable('getSelectedRowData');
   		var aa = obj.data.beforeKm;
   		var bb = aa.replace(/[^0-9]/g,"");
   		$('#tbl_bizcarTop').extable('setRowData', { beforeKm: bb}, ywrow.colIndex, ywrow.rowIndex); */
   		
   		//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
},{
    title: '주행후(Km)', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'afterKm', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
},{
    title: '주행(Km)', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'mileageKm', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	return true;
    }
},{
    title: '비고', /* 제목 */
    display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'note', /* json 연동 키 */
    width: '100px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	//값 변경 이벤트 체크
    	$('#rowEditCheck').val("Y");
    	
    	//alert("비고");
    	if(event.keyCode=='13'){
    		//var date = obj.data.driveDate;
    		//var chk = chkDateStr(date); //날짜형식 데이터 체크
    		
    		//마지막 줄에서 엔터를 쳤을때
    		var ywall = $('#tbl_bizcarTop').extable('getAllData');
    		var ywrow = $('#tbl_bizcarTop').extable('getSelectedRowData');
    		
    		//비고란에서만 수정시에 비고현재값을 가져오지 못해 제이쿼리로 직접 input값 가져옴
    		var getNote = $('.inpTextBox').val(); 
    		ywrow.data.note = getNote;
    		var rowXY = ywrow.colIndex+"_"+ywrow.rowIndex
    		insertRowData(rowXY,ywrow);
    		
    		//필수값 체크
    		if ($('#tbl_bizcarTop').extable('getReqCheck').pass){
    			//마지막 행에서 엔터를 쳤을때 행 추가
        		if(ywall.length-1 <= ywrow.rowIndex){
        			$('#tbl_bizcarTop').extable('setAddRow',{ 
        				chkBox: "",
        				carCode: "",
        				carNum: "", 
        				driveDate: "", 
        				driveFlag: "",
    					startTime: "",
    					endTime: "",
    					startFlag: "",
    					startAddr: "",
    					startAddrDetail: "",
    					endFlag: "",
    					endAddr: "",
    					endAddrDetail: "",
    					beforeKm: "",
                        afterKm: "",
                        mileageKm: "",
                        note: "",
                        sendYn: "",
                        bookMarkYn:"<img src=\"../../../Images/ico/ico_book01.png\" alt=\"\" id=\"bookmarkico\"/>"});
            		$('#tbl_bizcarTop').extable('setFocus', 0, ywrow.rowIndex+1);
        		}
    		}
    		
    	}
    	return true;
    }
},{
	title: '경비합계',
	display: 'Y',
	displayKey: '',
	colKey: 'totalAmt',
	width: '100px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: '', /* 입력 포맷 (text, combo, datepicker) */
    disabled: 'disabled',
    classes: 'bg_total2',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
    keyDownBefore : function(obj) {
    	
    	return true;
    	//fnConsSave(obj); 저장
    }
}, {
	title: '전송여부',
	display: 'Y',
	displayKey: '',
	colKey: 'sendYn',
	width: '80px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 (text, combo, datepicker) */
    comboData: {},
    disabled: 'disabled', //disabled
    data: 'asdasd',
    classes: 'bg_total2',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
    keyDownBefore : function(obj){
    	return true;
    }
}, {
	title: '<img src="<c:url value='/Images/ico/ico_book01_on.png'/>" alt="" />',
	display: 'Y',
	displayKey: '',
	colKey: 'bookMarkYn',
	width: '40px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: '', /* 입력 포맷 (text, combo, datepicker) */
    disabled: 'disabled', //disabled
    data: '',
    classes: 'bg_total2 bookmark',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
   	clickAfter: function (obj) {  return true; },
   	clickBefore: function (obj) { return true; },
    keyDownBefore : function(obj){
    	
    	return true;
    }
   	
}, {
	title: '북마크코드',
	display: 'N',
	displayKey: '',
	colKey: 'bookMarkCode',
	width: '40px',
	reqYN: 'N',
	align: 'center', /* 정렬 */
    type: '', /* 입력 포맷 (text, combo, datepicker) */
    disabled: 'disabled', //disabled
    data: '',
    classes: 'bg_total2 bookmark',
    mask: '',
    editor: { 
    	open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } 
   	},
    keyDownBefore : function(obj){
    	return true;
    }
   	
},{
    title: '차량종류', /* 제목 */
    display: 'N', /* 표현 여부 (표현 : Y / 미표현 : N) */
    displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
    colKey: 'carName', /* json 연동 키 */
    width: '80px', /* 너비 */
    reqYN: 'N', /* 필수 입력 여부 */
    align: 'center', /* 정렬 */
    type: 'text', /* 입력 포맷 */
    disabled: '',
    classes: '',
    mask: '',
    editor: {
        open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ }
    },
    keyDownBefore : function(obj){
    	return true;
    }
}];



$(document).ready(function() {

    pop_position();
    $(window).resize(function() {
        pop_position();
    });

    //시작날짜
    $("#txtFrDt").kendoDatePicker({
        format: "yyyy-MM-dd"
    });

    //종료날짜
    $("#txtToDt").kendoDatePicker({
        format: "yyyy-MM-dd"
    });
    
    //차량번호 검색 이벤트
    $('#carNum').keydown(function() { 
    	if(event.keyCode==13){
    		fnCarNumSearch();
    	}else{
    		$('#carSearch').val("N"); //차량검색여부 초기화
    	}
    });

    //fnInitDatePicker(30);
    fnInitDatePicker();
    
    /* ERP운행기록 마감일자 가져오기 */
    getErpCloseDt();

    /* [ 테이블 Lv1 ] 그리드 테이블 데이터가져오기 */
    getDataList();
    
    //값 변경 체크(하단 데이터변경 체크 주석처리 18.03.19)
    /* $('.inp_Detail').change(function() { 
    	$('#rowEditCheck').val("Y"); 
    });
    $(".selectType").selectmenu({
    	change: function( event, ui ) {
    		$('#rowEditCheck').val("Y"); 
    	}
    });*/ 

    //차량검색 모달창
    /* $("#modal-open,#modal-close").click(function () {
		$("#carnum-modal,#modal-bg").toggle();
	}); */

    //$('#tbl_bizcarTop').extable('setRowData', { note: 'gfgfgfff' }, 1, 1);
    

}); //document ready end

$(function() {
    //달력
    var datePickerOptions = {
        altFormat: "yy-mm-dd",
        dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
        dateFormat: "yy-mm-dd",
        dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        showOtherMonths: true,
        selectOtherMonths: true,
        showMonthAfterYear: true,
        nextText: "Next",
        prevTex: "Prev"

    };

    //$("#testDatepicker").kendoDatePicker(datePickerOptions);

    //테이블 로우 선택 
    var TR = $('.rightContents.cus_ta table tr');
    var TD = $('.rightContents.cus_ta table tr td');
    var iFocus = $('.rightContents.cus_ta table tr td input');
    var ROW = $('.searchTable .rightContents.cus_ta table tr');

    TR.click(function() {
        TR.removeClass('lineOn onSel'), $(this).addClass('lineOn onSel');
    }), TR.focusout(function() {
        TR.removeClass('lineOn onSel')
    });

    ROW.click(function() {
        TR.removeClass('lineOn onSel onRow'), $(this).addClass('onRow');
    }), TR.focusout(function() {
        TR.removeClass('onRow')
    });

    TD.focusin(function() {
        if ($(this).parents('.total').length > 0) {
            return;
        }
        TD.removeClass('focus'), $(this).addClass('focus');
    }), TD.focusout(function() {
        TD.removeClass('focus')
    });

    iFocus.click(function() {
        if ($(this).parents('.total').length > 0) {
            return;
        }
        iFocus.removeClass('focus'), $(this).addClass('focus');
    }), iFocus.focusout(function() {
        iFocus.removeClass('focus')
    });
    
    puddSelectBox();


});

// 조회기간 셋팅 = 기간일자 값을 받아서 세팅type
/* function fnInitDatePicker(dayGap) {

    // Object Date add prototype
    Date.prototype.ProcDate = function() {
        var yyyy = this.getFullYear().toString();
        var mm = (this.getMonth() + 1).toString(); //
        var dd = this.getDate().toString();
        return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' +
            (dd[1] ? dd : "0" + dd[0]);
    };

    var toD = new Date();
    $('#txtToDt').val(toD.ProcDate());


    var fromD = new Date(toD.getFullYear(), toD.getMonth(),
        toD.getDate() - dayGap);

    $('#txtFrDt').val(fromD.ProcDate());
} */

//조회기간 셋팅 = 일자기준아닌 달기준 간격 세팅type
function fnInitDatePicker() {

    // Object Date add prototype
    Date.prototype.ProcDate = function() {
        var yyyy = this.getFullYear().toString();
        var mm = (this.getMonth() + 1).toString(); //
        var dd = this.getDate().toString();
        return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' +
            (dd[1] ? dd : "0" + dd[0]);
    };

    var toD = new Date();
    $('#txtToDt').val(toD.ProcDate());


    var fromD = new Date(toD.getFullYear(), toD.getMonth() - 1,
        toD.getDate());

    $('#txtFrDt').val(fromD.ProcDate());
}

//휠스크롤
function fixDataOnWheel() {
    if (event.wheelDelta < 0) {
        DataScroll.doScroll('scrollbarDown');
    } else {
        DataScroll.doScroll('scrollbarUp');
    }
    table1Scroll();
}

//각 테이블 스크롤 동기화
function table1Scroll() {
	$(".table1 .leftContents").scrollTop($(".table1 .rightContents").scrollTop());
	$(".table1 .rightHeader").scrollLeft($(".table1 .rightContents").scrollLeft());
}

/* function fnModalOpen(){
	$('#modal-open').click();
} */

function fnCarNumSearch(){
	var carNum = $("#carNum").val();
	$('#carSearch').val("N"); //차량 검색여부 초기화
	
	if(carNum == ""){
		//차량검색어가 없으면 바로 팝업띄우기
		fnCarNumPop();
		
	}else{
		var tblParam = {};
		tblParam.carNum = carNum;
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/ex/bizcar/pop/bizCarErpSearch.do"/>',
			datatype:"json",
			data: tblParam ,
			contenttype: "application/json;",
		    success:function(data){
		    	var result = data.result;
		    	if(result){
		    		alert(result);
		    	}
		    	var list = data.bizCarNumList2;
		    	if(list.length == 1){
		    		$("#carCode").val(list[0].CAR_CD); //차량코드
		    	    $("#carNum").val(list[0].CAR_NB); //차량번호
		    	    $("#carName").val(list[0].CAR_NM); //차량종류
		    	}else{
		    		//검색결과 하나 이상이면 팝업 띄우기
		    		fnCarNumPop();
		    	}
				
			}
			, error:function(data){
				alert("차량번호 조회 중 오류가 발생하였습니다.");
			}
		});
	}
	
}

function fnCarNumPopOpen(rowSeq){
	//콜백 함수 setBizCarNum2
	var compSeq = "${loginVO.compSeq}";
	var groupSeq = "${loginVO.groupSeq}";
	var empSeq = "${loginVO.uniqId}";
	var carNum = "";
	
	var urlpop = "<c:url value='/cmm/ex/bizcar/pop/bizCarNumSearchPop.do'/>?compSeq=" + compSeq + "&groupSeq=" + groupSeq + "&empSeq=" + empSeq + "&carNum=" + carNum + "&rowSeq=" + rowSeq;
	openWindow2(urlpop, "fnCarNumPop", 400, 560, 0);
}

function fnCarNumPop() {
    var compSeq = "${loginVO.compSeq}";
    var groupSeq = "${loginVO.groupSeq}";
    var empSeq = "${loginVO.uniqId}";
    var carNum = $("#carNum").val();

    var urlpop = "<c:url value='/cmm/ex/bizcar/pop/bizCarNumSearchPop.do'/>?compSeq=" + compSeq + "&groupSeq=" + groupSeq + "&empSeq=" + empSeq + "&carNum=" + encodeURI(carNum);
    openWindow2(urlpop, "fnCarNumPop", 400, 560, 0);
}

function fnTradePopOpen(rowSeq){
	//콜백 함수 setBizCarTrade
	var urlpop = "<c:url value='/cmm/ex/bizcar/pop/bizCarTradeSearchPop.do'/>?rowSeq=" + rowSeq;
	openWindow2(urlpop, "fnTradePop", 898, 490, 0);
}

function setBizCarTrade(selTrade,row) {
	// 구분자로 받아서 split이용하여 row에 넣어줌 
	var trSplit = selTrade.split('_'); //selTrade:거래처명_주소
	var rowSplit = row.split('_'); //row:출발도착구분(S or E)_rowX_rowY
	var initType = rowSplit[0];
	if(initType == 'S'){
		$('#tbl_bizcarTop').extable('setRowData', { startAddr: trSplit[0],startAddrDetail: trSplit[1]}, rowSplit[1], rowSplit[2]);
		$('#inp_startAddr').val(trSplit[1]); //상세주소 입력
	}else if(initType == 'E'){
		$('#tbl_bizcarTop').extable('setRowData', { endAddr: trSplit[0],endAddrDetail: trSplit[1]}, rowSplit[1], rowSplit[2]);
		$('#inp_endAddr').val(trSplit[1]); //상세주소 입력
	}
	
	//그리드 변경 체크
	$('#rowEditCheck').val("Y");
}

function fnSearch() {
    var toDt = $('#txtToDt').val();
    var frDt = $('#txtFrDt').val();
    if(!chkSelDate(toDt) || !chkSelDate(frDt)){
    	alert('날짜형식(YYYY-MM-DD)에 맞지 않습니다.');
    	return;
    }
    var carCode = $('#carCode').val();
    if(carCode != ''){
    	$('#carSearch').val("Y");
    }else{
    	$('#carSearch').val("N");
    }
    var carNum = $('#carNum').val();
    var sendType = $("#sendType").val();
    //alert("조회날짜=" + frDt + "~" + toDt + "\n" + "차량번호=" + carNum + "\n" + "차량코드=" + carCode +"\n" + "전송타입=" + sendType);
    getDataList();

}

function chkSelDate(date){
	var date2 = date.replace(/[^0-9]/g,"");
	var pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
	var ptnChk = pattern.test(date);
	return ptnChk;
}

function fnDriveSearchPop() {
    //주행거리검색 보류
    alert("준비중입니다.");
    //var popurl = "<c:url value='/cmm/ex/bizcar/pop/bizCarDriveSearchPop.do'/>?carNum=" + carNum;
    //openWindow2(popurl,  "fnDriveSearchPop", 400, 560, 0) ;
}

function fnBookMarkPop() {
    var popurl = "<c:url value='/cmm/ex/bizcar/pop/bizCarBookMarkPop.do'/>?carNum=" + carNum;
    openWindow2(popurl, "fnBookMarkPop", 1098, 457, 0);
}

function fnAddressPop() {
    var popurl = "<c:url value='/cmm/ex/bizcar/pop/bizCarAddressPop.do'/>?carNum=" + carNum;
    openWindow2(popurl, "fnBookMarkPop", 500, 280, 0);
}

function fnReCalPop() {
	var carNum = $("#carNum").val();
	var carCode = $("#carCode").val();
	var toDt = $('#txtToDt').val();
	var frDt = $('#txtFrDt').val();
	var carSearch = $('#carSearch').val();
	if(carNum == "" || carCode == "" || carSearch == "N"){
		alert("재계산은 차량 1대 조회 후 가능합니다.");
		return;
	}
	
	//재계산시 ERP전송 데이터 포함 체크
	if(!chkReCalErpSend()){
		alert("조회 내역에 전송 건이 포함되어 있습니다. 해당 항목을 취소하거나\n미전송 항목만 검색 후 재계산해 주시기 바랍니다.");
		return;
	}
	//재계산시 ERP전송 데이터 포함 체크
	if(!chkReCalCloseDt()){
		alert("ERP 마감된 데이터가 포함되어 있습니다. (마감일"+erpCloseDt+")\n이후 검색 후 재계산해 주시기 바랍니다.");
		return;
	}

	//재계산시 주행전 주행후 주행거리 체크.
	if(!chkReCalMileageKm()){
		alert("조회 된 데이터 중 주행(km)값이 없거나 '0'인 데이터가 있습니다.");
		return;
	}
	var sendType = $('#sendType').val();
	
	$('#fr_sendType').val(sendType);
    $('#fr_carNum').val(carNum);
    $('#fr_carCode').val(carCode);
    $('#fr_toDt').val(toDt);
    $('#fr_frDt').val(frDt);
    $('#fr_erpCloseDt').val(erpCloseDt);
    
    var popurl = "<c:url value='/cmm/ex/bizcar/pop/bizCarReCalPop.do'/>";
    //openWindow2(popurl,  "fnReCalPop", 600, 230, 0) ;
    openWindow2("", "fnReCalPop", 578, 218, 0);
    frmReCal.target = "fnReCalPop";
    frmReCal.method = "post";
    frmReCal.action = popurl;
    frmReCal.submit();
}

//재계산 팝업에서 그리드 데이터 체크시 호출하는 함수
function fnChkReCalList(rType){
	var rtnVal = "ok";
	
	var totalRow = $('#tbl_bizcarTop').extable('getAllData');
	for(var i=0; i<totalRow.length; i++){
		if(totalRow[i].seqNum == "" || totalRow[i].sendYn == "전송" || totalRow[i].driveDate <= erpCloseDt){ //재계산 값 유효 체크
			totalRow.splice(i, 1); //배열 삭제
		}
	}
	
	if(rType == "forward"){
		if(totalRow[0].beforeKm == null || totalRow[0].beforeKm == "" || totalRow[0].beforeKm == "0" || totalRow[0].mileageKm == null ||totalRow[0].mileageKm == "" || totalRow[0].mileageKm == "0"){
			rtnVal = "fail1";
		}
	
	}else if(rType == "reverse"){
		var j = totalRow.length - 1; //마지막 행
		if(totalRow[j].afterKm == null || totalRow[j].afterKm == "" || totalRow[j].afterKm == "0" || totalRow[j].mileageKm == null ||totalRow[j].mileageKm == "" || totalRow[j].mileageKm == "0"){
			rtnVal = "fail2";
		}
	}
	
	return rtnVal;
}

//재계산 대상리스트 중 ERP전송 여부 체크
function chkReCalErpSend(){
	var chkVal = true;
	var totalRow = $('#tbl_bizcarTop').extable('getAllData');
	for(var i=0; i<totalRow.length; i++){
		if(totalRow[i].seqNum != ""){ //seqNum 값 유효 체크
			if(totalRow[i].sendYn == "전송"){
				chkVal = false;
			}
		}
	}
	return chkVal;
}

//재계산 대상리스트 중 마감여부 체크
function chkReCalCloseDt(){
	var chkVal = true;
	var totalRow = $('#tbl_bizcarTop').extable('getAllData');
	for(var i=0; i<totalRow.length; i++){
		if(totalRow[i].seqNum != ""){ //seqNum 값 유효 체크
			if(totalRow[i].driveDate <= erpCloseDt){
				chkVal = false;
			}
		}
	}
	return chkVal;
}

//재계산 대상리스트 중 주행값 0이거나 null 체크
function chkReCalMileageKm(){
	var chkVal = true;
	var totalRow = $('#tbl_bizcarTop').extable('getAllData');
	for(var i=0; i<totalRow.length; i++){
		if(totalRow[i].seqNum != ""){ //seqNum 값 유효 체크
			if(totalRow[i].mileageKm == null ||totalRow[i].mileageKm == "" || totalRow[i].mileageKm == "0"){
				chkVal = false;
			}
		}
	}
	return chkVal;
}

function chkDivideRow(){
	var chkVal = true;
	var totalRow = $('#tbl_bizcarTop').extable('getAllData');
	for(var i=0; i<totalRow.length; i++){
		if(totalRow[i].seqNum){ //seqNum 값 유효 체크
			if(totalRow[i].beforeKm == null || totalRow[i].beforeKm == "" || totalRow[i].beforeKm == "0" || totalRow[i].mileageKm == null ||totalRow[i].mileageKm == "" || totalRow[i].mileageKm == "0" || totalRow[i].afterKm == null || totalRow[i].afterKm == "" || totalRow[i].afterKm == "0"){
				chkVal = false;
			}
		}
	}
	return chkVal;
}

function fnDividePop() {
	var carChk = $("#carCode").val();
	var carSearch = $("#carSearch").val();
	var carNum = $("#carNum").val();
	if(carChk == '' || carSearch == "N" || carNum == ''){
		alert("안분은 1대의 차량운행기록만 계산가능합니다. 다시확인해주세요.");
		return;
	}
	var chkList = getChkBox(); //seq정보만
	if(chkList.length == 0){
		alert("안분할 운행기록을 선택해주세요.");
		return;
	}
	
	//안분시 주행전 주행후 주행거리 체크.
	var chkRowList = getChkBoxRow(); //row정보_seq정보
	var dataChk = true;
	var sendChk = true;
	for(var i=0; i<chkRowList.length; i++){
		var split = chkRowList[i].split('_');
		var rowData = $('#tbl_bizcarTop').extable('getRowData', split[1]);
		if(!divideRowChk(rowData)){
			dataChk = false;
		}
		if(rowData.sendYn == "전송"){
			sendChk = false;
		}
	}
	if(!sendChk){
		alert("전송된 데이터는 안분처리할 수 없습니다.");
		return;
	}
	//해당 행 데이터 마감 체크 
	if(!fnCloseChk(chkRowList)){
		alert("마감된 데이터는 안분처리할 수 없습니다.");
		return;
	}
	if(!dataChk){
		alert("체크된 데이터 중 주행전/주행후/주행 거리(km) \n값이 없거나 '0'인 데이터가 있습니다.");
		return;
	}
	var seqNumList = chkList;
	//var driveDate = rowData.driveDate.replace(/-/gi, "");
	var carCode = $("#carCode").val();
	
    var popurl = "<c:url value='/cmm/ex/bizcar/pop/bizCarDividePop.do'/>?carCode="+carCode+"&seqNumList="+seqNumList;
    openWindow2(popurl, "fnDividePop", 998, 360, 0);
}

//복사 팝업 제외, row데이터 바로 DB복사하는것으로 기획수정
/* function fnCopyPop() {
    var popurl = "<c:url value='/cmm/ex/bizcar/pop/bizCarCopyPop.do'/>?carNum=" + carNum;
    openWindow2(popurl, "fnCopyPop", 500, 380, 0);
} */

function fnCopyData() {	
	//체크항목 가져오기
	var chkList = getChkBox();
	if(chkList.length == 0){
		alert("복사할 운행기록을 선택해주세요.");
		return;
	}
	if(!confirm("해당 데이터를 복사하시겠습니까?")){
		return;
	}
	
	var tblParam = {};
	tblParam.seqNumArr = JSON.stringify(chkList);
	//tblParam.carCode = rowData.carCode;
	//tblParam.useDate = rowData.driveDate;
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/copyBizCarData.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			var result = data.result;
			if(result == 'ok'){
				alert("복사 성공하였습니다.");
				getDataList();
			}else{
				alert("복사 실패");
			}
			
			
		}
		, error:function(data){
			alert("복사하는도중 오류가 발생하였습니다.");
		}
	});
}

function fnUploadPop() {
    var popurl = "<c:url value='/cmm/ex/bizcar/pop/bizCarUploadPop.do'/>?carNum=" + carNum;
    openWindow2(popurl, "fnUploadPop", 1000, 520, 0);
}

function setBizCarNum(no) {
	// 구분자로 받아서 split  차량코드_차량번호 
	var noSplit = no.split('_');
	$("#carCode").val(noSplit[0]); //차량코드
    $("#carNum").val(noSplit[1]); //차량번호
    $("#carName").val(noSplit[2]); //차량종류
}

function setBizCarNum2(no,row) {
	// 구분자로 받아서 split row에 넣어줌 차량코드_차량번호 
	var noSplit = no.split('_');
	var rowSplit = row.split('_');
	$('#tbl_bizcarTop').extable('setRowData', { carCode: noSplit[0],carNum: noSplit[1],carName: noSplit[2]}, rowSplit[1], rowSplit[0]);
	//팝업에서 선택한 차량으로 마지막 주행후거리 데이터 조회
	if(rowSplit.length == '3'){ //마지막 행 신규데이터에만 적용
		getCarAfterKm(noSplit[0],rowSplit[1],rowSplit[0]);
	}
	//그리드 변경 체크
	$('#rowEditCheck').val("Y");
}

/* bizcarJs 따로 생성 시작 */


//ROW데이터 리스트 가져오기 
function getDataList() {
    var tblParam = {};
    tblParam.frDt = $('#txtFrDt').val();
    tblParam.toDt = $('#txtToDt').val();
    tblParam.carNum = $('#carNum').val();
    tblParam.carCode = $('#carCode').val();
    var sendType = $('#sendType').val();
    if ( sendType != ""){
    	tblParam.sendType = $('#sendType').val();
    }
    $.ajax({
        type: "post",
        url: '<c:url value="/cmm/ex/bizcar/bizCarDataList.do"/>',
        datatype: "json",
        data: tblParam,
        contenttype: "application/json;",
        //async: false, 저장후 포커스 처리할때
        beforeSend: function() {	              
        	$('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
        },
        success: function(data) {
        	$('html').css("cursor","auto");
            var dataList = [];
            var result = data.result;
            var list = data.list;
            var totalKm = 0; //총 주행
            var totalAllAmt = 0; //총 경비합계
            var erpSendCloseList = new Array(); //ERP 전송 데이터 & 마감일자 이전 데이터
            //var result3 = JSON.stringify(data.list);
            for (var i = 0; i < list.length; i++) {
                dataList.push({
                	chkBox: "<input type='checkbox' name='inp_chk' id='check_"+i+"_"+list[i].seqNum+"' onclick='fnCheck(this);' />",
                	carCode: list[i].carCode,
                    carNum: list[i].carNum,
                    seqNum: list[i].seqNum,
                    driveDate: list[i].driveDate,
                    driveFlag: setUseFlag("str", list[i].driveFlag),
                    startTime: list[i].startTime,
                    endTime: list[i].endTime,
                    startFlag: setStartFlag("str", list[i].startFlag),
                    startAddr: list[i].startAddr,
                    startAddrDetail: list[i].startAddrDetail,
                    endFlag: setEndFlag("str", list[i].endFlag),
                    endAddr: list[i].endAddr,
                    endAddrDetail: list[i].endAddrDetail,
                    beforeKm: (list[i].beforeKm == 0) ? "0" : list[i].beforeKm,
                    afterKm: (list[i].afterKm == 0) ? "0" : list[i].afterKm,
                    mileageKm: (list[i].mileageKm == 0) ? "0" : list[i].mileageKm,
                    note: list[i].rmkDc,
                    totalAmt: addComma(list[i].totalAmt),
                    sendYn: (list[i].erpSendYn == "1") ? "전송" : "미전송",
                    bookMarkYn: (list[i].bookMarkCode > 0) ? '<img src=\"../../../Images/ico/ico_book01_on.png\" alt=\"\" id=\"bookmarkico\"/>' : '<img src=\"../../../Images/ico/ico_book01.png\" alt=\"\" id=\"bookmarkico\"/>',
                    bookMarkCode: list[i].bookMarkCode,
                    carName: list[i].carName
                });
                
                totalKm += list[i].mileageKm;
                totalAllAmt += list[i].totalAmt;
                
                //erp 전송된 데이터 및 마감일자 이전 운행기록부 disable처리위해  ROW 저장
                if(list[i].erpSendYn == "1" || list[i].driveDate <= erpCloseDt){
                	erpSendCloseList.push(i);
                }
            };
            
            $('#totalKm').html(totalKm);
            
            $('#totalAllAmt').html(addComma(totalAllAmt));

            //extable 테이블 그리기
            fnDrawGridTable(dataList);
            
            //하단 상세데이터 초기화
            fnNewDetailData();
            
            //ERP 전송된 데이터 disable처리
            fnRowDisable(erpSendCloseList);

        },
        error: function(data) {
        	$('html').css("cursor","auto");
            alert("데이터 가져오는 중 오류가 발생하였습니다.");
        }
    });

}

/*	[ 테이블 Lv1 ] 그리드 테이블 그리기
----------------------------------------- */
function fnDrawGridTable(dataList) {

    $('#tbl_bizcarTop').extable({
        column: consTableColumn,
        data: dataList,
        height: 300,
        clickBefore: function(data) {
            var rowData = $('#tbl_bizcarTop').extable('getSelectedRowData');
            var ywAll = $('#tbl_bizcarTop').extable('getAllData');
            //var selRowData = $('#tbl_bizcarTop').extable('getSelectedRowData').data;
            console.log(data);
            
            //운행일자 날짜형식 체크
            if(data.beforeColIndex == '4'){
            	var date = rowData.data.driveDate;
            	if(date != ""){
            		var chk = chkDateStr(date); //날짜형식 데이터 체크
            		if(!chk)
            		$('#rowEditCheck').val("N");
            	}else{
            		$('#rowEditCheck').val("N"); //공백이면 변경체크 제외
            	}
        		
            }
          	//운행구분 숫자입력 변환
            if(data.beforeColIndex == '5'){
            	var dFlag = rowData.data.driveFlag;
            	if(dFlag != ""){
            		if(isNaN(dFlag) != false){ //입력값이 문자열일때 숫자로 변환.
                		dFlag = setUseFlag("num",dFlag);
                	}
                	if(isNaN(dFlag) == false){ //입력값이 숫자인지 체크
                		if(dFlag== "1" || dFlag=="2" || dFlag=="3" || dFlag=="4" || dFlag=="5"){
                			switch (dFlag) {
                			  case "1": dFlag = 1; break;
                			  case "2": dFlag = 2; break;
                			  case "3": dFlag = 3; break;
                			  case "4": dFlag = 4; break;
                			  case "5": dFlag = 5; break;
                			  }
                    		$('#tbl_bizcarTop').extable('setRowData', { driveFlag: setUseFlag("str", dFlag)}, rowData.colIndex, rowData.rowIndex);
                    	}else {
                    		alert("운행구분 값을 확인해주세요.");
                    		$('#tbl_bizcarTop').extable('setRowData', { driveFlag: ""}, rowData.colIndex, rowData.rowIndex);
                    		$('#rowEditCheck').val("N");
                    	}
                	}
            	}
            	
            }
          	//출발시간 형식 체크
            if(data.beforeColIndex == '6'){
            	var sTime = rowData.data.startTime;
            	if(sTime != ""){
            		var sTimeInt = sTime.replace(/[^0-9]/g,"");
                	if(sTimeInt.length == 4){
                		var hh = sTimeInt.substr(0,2);
                		var mm = sTimeInt.substr(2,2);
                		if(hh > 23 || mm > 59){
                			alert('시간형식(HH:MM)에 맞지 않습니다.');
                			$('#tbl_bizcarTop').extable('setRowData', { startTime: ""}, rowData.colIndex, rowData.rowIndex);
                    		$('#rowEditCheck').val("N");
                		}else{
                			sTime = hh+":"+mm;
                    		$('#tbl_bizcarTop').extable('setRowData', { startTime: sTime}, rowData.colIndex, rowData.rowIndex);
                		}
                	}else if (sTimeInt.length == 3){
                		var hh = sTimeInt.substr(0,1);
                		var mm = sTimeInt.substr(1,2);
                		if(mm > 59){
                			alert('시간형식(HH:MM)에 맞지 않습니다.');
                			$('#tbl_bizcarTop').extable('setRowData', { startTime: ""}, rowData.colIndex, rowData.rowIndex);
                    		$('#rowEditCheck').val("N");
                		}else {
                			sTime = "0"+hh+":"+mm;
                    		$('#tbl_bizcarTop').extable('setRowData', { startTime: sTime}, rowData.colIndex, rowData.rowIndex);
                		}
                	}else if (sTimeInt.length == 2) {
                		var hh = sTimeInt.substr(0,2);
                		if(hh > 23){
                			alert('시간형식(HH:MM)에 맞지 않습니다.');
                			$('#tbl_bizcarTop').extable('setRowData', { startTime: ""}, rowData.colIndex, rowData.rowIndex);
                    		$('#rowEditCheck').val("N");
                		}else {
                			sTime = hh+":00";
                			$('#tbl_bizcarTop').extable('setRowData', { startTime: sTime}, rowData.colIndex, rowData.rowIndex);
                		}                		
                	}else if (sTimeInt.length == 1) {
               			sTime = "0"+sTime+":00";
               			$('#tbl_bizcarTop').extable('setRowData', { startTime: sTime}, rowData.colIndex, rowData.rowIndex);
                	}else {
                		alert('시간형식(HH:MM)에 맞지 않습니다.');
                		$('#tbl_bizcarTop').extable('setRowData', { startTime: ""}, rowData.colIndex, rowData.rowIndex);
                		$('#rowEditCheck').val("N");
                	}
            	}
            }
          	//도착시간 형식 체크
            if(data.beforeColIndex == '7'){
            	var eTime = rowData.data.endTime;
            	if(eTime != ""){
            		var eTimeInt = eTime.replace(/[^0-9]/g,"");
                	if(eTimeInt.length == 4){
                		var hh = eTimeInt.substr(0,2);
                		var mm = eTimeInt.substr(2,2);
                		if(hh > 23 || mm > 59){
                			alert('시간형식(HH:MM)에 맞지 않습니다.');
                			$('#tbl_bizcarTop').extable('setRowData', { endTime: ""}, rowData.colIndex, rowData.rowIndex);
                    		$('#rowEditCheck').val("N");
                		}else{
                			eTime = hh+":"+mm;
                    		$('#tbl_bizcarTop').extable('setRowData', { endTime: eTime}, rowData.colIndex, rowData.rowIndex);
                		}
                	}else if (eTimeInt.length == 3){
                		var hh = eTimeInt.substr(0,1);
                		var mm = eTimeInt.substr(1,2);
                		if(mm > 59){
                			alert('시간형식(HH:MM)에 맞지 않습니다.');
                			$('#tbl_bizcarTop').extable('setRowData', { endTime: ""}, rowData.colIndex, rowData.rowIndex);
                    		$('#rowEditCheck').val("N");
                		}else{
                			eTime = "0"+hh+":"+mm;
                    		$('#tbl_bizcarTop').extable('setRowData', { endTime: eTime}, rowData.colIndex, rowData.rowIndex);
                		}
                	}else if (eTimeInt.length == 2){
                		var hh = eTimeInt.substr(0,2);
                		if(hh > 24){
                			alert('시간형식(HH:MM)에 맞지 않습니다.');
                			$('#tbl_bizcarTop').extable('setRowData', { endTime: ""}, rowData.colIndex, rowData.rowIndex);
                    		$('#rowEditCheck').val("N");
                		}else {
                			eTime = hh+":00";
                			$('#tbl_bizcarTop').extable('setRowData', { endTime: eTime}, rowData.colIndex, rowData.rowIndex);
                		}  
                	}else if (eTimeInt.length == 1) {
               			eTime = "0"+eTime+":00";
               			$('#tbl_bizcarTop').extable('setRowData', { endTime: eTime}, rowData.colIndex, rowData.rowIndex);
                	}else{
                		alert('시간형식(HH:MM)에 맞지 않습니다.');
                		$('#tbl_bizcarTop').extable('setRowData', { endTime: ""}, rowData.colIndex, rowData.rowIndex);
                		$('#rowEditCheck').val("N");
                	}
            	}
            }
          	//주행전 숫자입력 변환
            if(data.beforeColIndex == '14'){
            	var bKm = rowData.data.beforeKm;
            	if(isNaN(bKm) == true){ //입력값에 문자가 있는지 체크
               		var bKmInt = bKm.replace(/[^0-9]/g,"");
               		$('#tbl_bizcarTop').extable('setRowData', { beforeKm: bKmInt}, rowData.colIndex, rowData.rowIndex);
            	}
            }
          	//주행후 숫자입력 변환
            if(data.beforeColIndex == '15'){
            	var aKm = rowData.data.afterKm;
            	//입력값에 문자가 있는지 체크
            	if(isNaN(aKm) == true){ 
               		var aKmInt = aKm.replace(/[^0-9]/g,"");
               		$('#tbl_bizcarTop').extable('setRowData', { afterKm: aKmInt}, rowData.colIndex, rowData.rowIndex);
            	}
            	//주행전거리가 기입되어 있으면 주행거리 자동계산 추가(주행후-주행전=주행)
            	if(rowData.data.chkBox == ""){ //마지막 입력행에서만 적용 
            		var bKm = rowData.data.beforeKm;
            		if(aKm > '0' && bKm > '0'){ 
                		$('#tbl_bizcarTop').extable('setRowData', { mileageKm: Number(aKm)-Number(bKm)}, rowData.colIndex, rowData.rowIndex);
                	}
            	}
            	
            }
          	//주행 숫자입력 변환
            if(data.beforeColIndex == '16'){
            	var mKm = rowData.data.mileageKm;
            	if(isNaN(mKm) == true){ //입력값에 문자가 있는지 체크
               		var mKmInt = mKm.replace(/[^0-9]/g,"");
               		$('#tbl_bizcarTop').extable('setRowData', { mileageKm: mKmInt}, rowData.colIndex, rowData.rowIndex);
            	}
            	//주행전거리가 기입되어 있으면 주행후거리 자동계산 추가(주행+주행전=주행후)
            	if(rowData.data.chkBox == ""){ //마지막 입력행에서만 적용 
            		var bKm = rowData.data.beforeKm;
            		if(mKm > '0' && bKm > '0'){ 
                		$('#tbl_bizcarTop').extable('setRowData', { afterKm: Number(mKm)+Number(bKm)}, rowData.colIndex, rowData.rowIndex);
                	}
            	}
            }
            
            // row 이동 확인 - row 이동 시 저장 및 수정 
            if (data.afterRowIndex != data.beforeRowIndex) {
                if ($('#tbl_bizcarTop').extable('getReqCheck').pass) {
                    console.log("row 이동");
                    console.log($('#tbl_bizcarTop').extable('getReqCheck'));
                    console.log("row 저장="+rowData);
                    //이동시 row data 저장
                    var rowEditCheck = $('#rowEditCheck').val();
                    if(rowEditCheck =="Y"){
                    	//마지막 추가행 비고엔터시와 두번 저장되지 않도록 다음마지막행인지 중복삽입 체크
                    	if(ywAll.length-1 != data.afterRowIndex){
                    		var rowXY = data.beforeColIndex+"_"+data.beforeRowIndex; //저장 후 포커스 위치
                            insertRowData(rowXY,rowData);
                    	}
                    }
                    
                    return true;
                } else {
                	
                    //alert('필수입력 값이 존재하지 않습니다.');
                    //console.log("row 이동 X");
                    //return false;
                    return true;
                }
            } else {
                return true;
            }
        },
        clickAfter: function(data) {
        	//alert("클릭했다 에프터");
        	var ywAll = $('#tbl_bizcarTop').extable('getAllData');
            var selRowData = $('#tbl_bizcarTop').extable('getSelectedRowData').data;
            //alert("클릭 row data는?=="+data.data.note);
            //alert("에프터");
            
            if(data.afterColIndex != '0'){ //체크박스 상세조회 제외
            	if(data.beforeRowIndex != data.afterRowIndex){
                	if(data.data.carCode != ""){
                		getDetailRowData(selRowData); //row클릭시 하단 데이터 세팅
                	}else {
                		//하단데이터 초기화
                		fnNewDetailData();
                	}
                	
                }
            }
            
            var selRow = $('#tbl_bizcarTop').extable('getSelectedRowData');
            var ywall = $('#tbl_bizcarTop').extable('getAllData');
            if (selRow.colIndex == '20') {
                //북마크 클릭 alert("북마크");
                //seqNum이 있는 것만 진행
                if(selRow.data.seqNum != ""){
                	if(selRow.data.bookMarkCode == null || selRow.data.bookMarkCode == ""){
                    	insertBookMark(selRow);
                    }else{
                    	deleteBookMark(selRow);
                    }
                }
                
            }
            
    		//차량 클릭시 차량조회 팝업 오픈
            if(selRow.colIndex == '2'){
            	
            	if(ywall.length-1 <= selRow.rowIndex){ //마지막 행이면 주행후거리 MAX값 조회위해 N 구분 추가
            		var prRowSeq = selRow.rowIndex + "_" + selRow.colIndex + "_N";
            	}else{
            		if(selRowData.sendYn == "전송" || selRowData.driveDate <= erpCloseDt){ //ERP전송 데이터 및 마감일자 이전 데이터는 팝업 제외
                		return;
                	}
            		var prRowSeq = selRow.rowIndex + "_" + selRow.colIndex;
            	}
				fnCarNumPopOpen(prRowSeq);
			}
            return true;
        },
    });
    $('#tbl_bizcarTop').extable('setAddRow',{ 
    	chkBox: "",
    	carCode: "",
		carNum: "", 
		driveDate: "", 
		driveFlag: "",
		startTime: "",
		endTime: "",
		startFlag: "",
		startAddr: "",
		startAddrDetail: "",
		endFlag: "",
		endAddr: "",
		endAddrDetail: "",
		beforeKm: "",
        afterKm: "",
        mileageKm: "",
        note: "",
        totalAmt: "",
        sendYn: "",
        bookMarkYn:"",
        bookMarkCode: null,
        carName:""});
    //$('#tbl_bizcarTop').extable('setFocus', 0, 0); 시작 포커스
}

function getDetailRowData(data){
	//상세주소
	$('#inp_startAddr').val(data.startAddrDetail);
    $('#inp_endAddr').val(data.endAddrDetail);
    
    var tblParam = {};
	tblParam.carNum = data.carNum;
	tblParam.carCode = data.carCode;
	tblParam.seqNum = data.seqNum;
	tblParam.useDate = data.driveDate;
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/detailRowData.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			var result = data.result[0];
			if(typeof result != 'undefined'){
				setDetailData(result);
				
				//ERP전송된 데이터 및 마감일자 이전 데이터는 수정불가 하도록 disabled 처리
				if(result.erpSendYn == '1' || result.driveDate <= erpCloseDt){
					setDetailDataFix();
				}
			}
			
		}
		, error:function(data){
			alert("상세데이터 가져오는 중 오류가 발생하였습니다.");
		}
	});
}

function setDetailData(result){
	//$('#selectType01').val(result.oilAmtType).attr("selected","true"); selectbox변경으로 주석
	$('#amtSave').removeAttr("disabled"); //경비저장버튼 disabled 처리 제거
	$('.selectField').removeAttr("disabled"); //결재구분 disabled 처리 제거
	$('.inp_Detail').removeAttr("readonly"); //금액 readonly 처리 제거
	$('.cloneList li').removeClass("on"); //li on클래스 제거
	
	$('#total_Amt').val(addComma(result.totalAmt)); //경비총합계
	var aType = result.oilAmtType; //유류비
	$('#selectAmt_1').children('.selectText').text(setAmtType(aType));
	$('#listAmt_1 li[val="'+aType+'"]').addClass("on");
	$('#amtType01').val(addComma(result.oilAmt));
	aType = result.tollAmtType; //통행료
	$('#selectAmt_2').children('.selectText').text(setAmtType(aType));
	$('#listAmt_2 li[val="'+aType+'"]').addClass("on");
	$('#amtType02').val(addComma(result.tollAmt));
	aType = result.parkingAmtType; //주차비
	$('#selectAmt_3').children('.selectText').text(setAmtType(aType));
	$('#listAmt_3 li[val="'+aType+'"]').addClass("on");
	$('#amtType03').val(addComma(result.parkingAmt));
	aType = result.repairAmtType; //수선비
	$('#selectAmt_4').children('.selectText').text(setAmtType(aType));
	$('#listAmt_4 li[val="'+aType+'"]').addClass("on");
	$('#amtType04').val(addComma(result.repairAmt));
	aType = result.etcAmtType; //기타
	$('#selectAmt_5').children('.selectText').text(setAmtType(aType));
	$('#listAmt_5 li[val="'+aType+'"]').addClass("on");
	$('#amtType05').val(addComma(result.etcAmt));
	//$(".selectType").selectmenu("refresh");
}

//ERP전송된 데이터는 수정불가 하도록 disabled 처리
function setDetailDataFix(){
	$('#amtSave').attr("disabled", true);
	$('.selectField').attr("disabled", true);
	$('.inp_Detail').attr("readonly", true);
}

//운행구분 변경
function setUseFlag(type,val){
	var strFlag ='';
	//str이면 숫자에서 문자열로 변경
	if(type == "str"){
		switch (val) {
		  case 1: strFlag = "출근"; break;
		  case 2: strFlag = "퇴근"; break;
		  case 3: strFlag = "출퇴근"; break;
		  case 4: strFlag = "업무용"; break;
		  case 5: strFlag = "비업무용"; break;
		  default: strFlag = ""; break;
		}
	}else if(type =="num"){
		val.trim();
		switch (val) {
		  case "출근": strFlag = "1"; break;
		  case "퇴근": strFlag = "2"; break;
		  case "출퇴근": strFlag = "3"; break;
		  case "업무용": strFlag = "4"; break;
		  case "비업무용": strFlag = "5"; break;
		  default: strFlag = ""; break;
		}
	}
	
	return strFlag;	
}

//출발,도착 구분  변경
function setStartFlag(type,val){
	var flagVal ='';
	if(type == "str"){
		switch (val) {
		  case 0: flagVal = "직접입력"; break;
		  case 1: flagVal = "회사"; break;
		  case 2: flagVal = "자택"; break;
		  case 3: flagVal = "거래처"; break;
		  case 4: flagVal = "직전출발지"; break;
		  default: flagVal = ""; break;
		}
	}else if(type =="num"){
		val.trim();
		switch (val) {
		  case "직접입력": flagVal = "0"; break;
		  case "회사": flagVal = "1"; break;
		  case "자택": flagVal = "2"; break;
		  case "거래처": flagVal = "3"; break;
		  case "직전출발지": flagVal = "4"; break;
		  default: flagVal = ""; break;
		}
	}
	return flagVal;
}

//출발,도착 구분  변경
function setEndFlag(type,val){
	var flagVal ='';
	if(type == "str"){
		switch (val) {
		  case 0: flagVal = "직접입력"; break;
		  case 1: flagVal = "회사"; break;
		  case 2: flagVal = "자택"; break;
		  case 3: flagVal = "거래처"; break;
		  case 4: flagVal = "직전도착지"; break;
		  default: flagVal = ""; break;
		}
	}else if(type =="num"){
		val.trim();
		switch (val) {
		  case "직접입력": flagVal = "0"; break;
		  case "회사": flagVal = "1"; break;
		  case "자택": flagVal = "2"; break;
		  case "거래처": flagVal = "3"; break;
		  case "직전도착지": flagVal = "4"; break;
		  default: flagVal = ""; break;
		}
	}
	return flagVal;
}

//결재구분 변경
function setAmtType(type){
	var str = '';
	switch (type) {
	  case 0: str = "0.없음"; break;
	  case 1: str = "1.현금"; break;
	  case 2: str = "2.현금영수증"; break;
	  case 3: str = "3.카드(법인)"; break;
	  case 4: str = "4.카드(개인)"; break;
	  default: str = "0.없음"; break;
	}
	return str;
}

//ERP 전송된 데이터는 수정이 안되도록 해당 row disabled 처리
function fnRowDisable(row){
	for(var i=0; i<row.length; i++){
		$('#tbl_bizcarTop').extable('setRowAllDisable', row[i], 'disabled');
	}
}

function addBookMark(rowData) {
	
	for(var i=0; i<rowData.length; i++){
		$('#tbl_bizcarTop').extable('setAddRow',{ 
			chkBox: "",
			carCode: "",
			carNum: "", 
			driveDate: "", 
			driveFlag: rowData[i].td3,
			startTime: rowData[i].td4,
			endTime: rowData[i].td5,
			startFlag: rowData[i].td6,
			startAddr: rowData[i].td7,
			startAddrDetail: "",
			endFlag: rowData[i].td8,
			endAddr: rowData[i].td9,
			endAddrDetail: "",
			beforeKm: "",
	        afterKm: "",
	        mileageKm: "",
	        note: rowData[i].td10,
	        totalAmt: "",
	        sendYn: "",
	        bookMarkYn:"<img src=\"../../../Images/ico/ico_book01.png\" alt=\"\" id=\"bookmarkico\"/>",
	        bookMarkCode: null,
	        carName:""});

	}
}

function insertBookMark(rowData){
	//북마크 DB저장
    var tblParam = {};
	tblParam.seqNum = rowData.data.seqNum;
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/insertBookMarkData.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			//bookmark 시퀀스 리턴받아 insert한 row에 세팅
			var result = data.result;
			if(result > 0){
				var bmCode = data.bmCode;
		    	$('#tbl_bizcarTop').extable('setRowData', { bookMarkYn: '<img src=\"../../../Images/ico/ico_book01_on.png\" alt=\"\" id=\"bookmarkico\"/>', bookMarkCode: bmCode}, rowData.colIndex, rowData.rowIndex);
			}else{
				alert("즐겨찾기 저장 실패");
			}			
		}
		, error:function(data){
			alert("즐겨찾기 저장 중 오류가 발생하였습니다.");
		}
	});
}

function deleteBookMark(rowData){
	//북마크 DB삭제
	var bmCodeArr = new Array();
	var bmCode = rowData.data.bookMarkCode;
	bmCodeArr.push(bmCode);
	
	var tblParam = {};
	tblParam.seqNum = rowData.data.seqNum;
	tblParam.bmCodeArr = JSON.stringify(bmCodeArr);
	
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/deleteBookMark.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			//var result = data.result[0];
	    	$('#tbl_bizcarTop').extable('setRowData', { bookMarkYn: '<img src=\"../../../Images/ico/ico_book01.png\" alt=\"\" id=\"bookmarkico\"/>', bookMarkCode: null}, rowData.colIndex, rowData.rowIndex);
		}
		, error:function(data){
			alert("즐겨찾기 저장 중 오류가 발생하였습니다.");
		}
	});
}

//금액 값에 콤마 삽입
function addComma(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

//금액 입력 후 다시 숫자에 콤마 넣어줌
function getNumber(obj){
	//input 금액 입력시 콤바 넣기
    var num01;
    var num02;
    num01 = obj.value;
    num02 = num01.replace(rgx1,"");
    num01 = setComma(num02);
    obj.value =  num01;
}

function setComma(inNum){
    
    var outNum;
    outNum = inNum; 
    while (rgx2.test(outNum)) {
         outNum = outNum.replace(rgx2, '$1' + ',' + '$2');
     }
    return outNum;
}

function addZero(num, len) {
	//var val = num.replace(":","");
	var val = num.replace(/[^0-9]/g,""); //숫자만 남기고 모두 제거
    while(val.toString().length < len) {
    	val = "0" + val;
    }
    return val;
}

function delComma(inNum){
	var outNum ='';
	outNum = inNum.replace(/,/gi, "");
	return outNum;
}

/* function selOnChange() {
	alert("셀렉변경");
	$('#rowEditCheck').val("Y"); 
} */

function fnNewDetailData(){
	//하단 상세데이터 초기화
	$('#inp_startAddr').val("");
    $('#inp_endAddr').val("");
    $('#total_Amt').val("");
    $('#amtSave').removeAttr("disabled"); //경비저장버튼 disabled 처리 제거
    $('.selectField').removeAttr("disabled"); //결재구분 disabled 처리 제거
	$('.inp_Detail').removeAttr("readonly"); //금액 readonly 처리 제거
    $('.cloneList li').removeClass("on"); //selectbox li on클래스 초기화
    $('.selectField').children('.selectText').text("0.없음"); //selectbox 초기화
    $('.cloneList li[val="0"]').addClass("on"); // 0.없음 으로 초기화
    
	$('#amtType01').val("");
	$('#amtType02').val("");
	$('#amtType03').val("");
	$('#amtType04').val("");
	$('#amtType05').val("");
	
	//row 수정체크 초기화
	$('#rowEditCheck').val("N");
}

function insertRowData(inFocus,rowData){
	//var ywyw = $('#tbl_bizcarTop').extable('getRowData', rowData.rowIndex);
		
	if (!$('#tbl_bizcarTop').extable('getReqCheck').pass){
		if(rowData.data.carNum !='' && rowData.data.carCode==''){
			alert("차량조회 팝업에서 차량을 선택해주세요");
		}else if(rowData.data.driveDate == ''){
			alert("운행일자가 존재하지 않습니다.");
		}else{
			alert("차량정보가 존재하지 않습니다.");
		}
		$('#rowEditCheck').val("N"); //값변경체크 N
		return;
	}
	//inFocus로 저장후 focus 이동
	var afterFocus = inFocus.split('_');
	var afterFocusX = afterFocus[0];
	var afterFocusY = afterFocus[1];
    	
	var tblParam = {};
	if(rowData.data.seqNum != ""){
    	tblParam.seqNum = rowData.data.seqNum;
    }
    tblParam.compSeq = "${loginVO.compSeq}";
    tblParam.empSeq = "${loginVO.uniqId}";
    tblParam.erpCompSeq = "${loginVO.erpCoCd}";
    tblParam.carNum = rowData.data.carNum;
    tblParam.carCode = rowData.data.carCode;
    tblParam.carName = rowData.data.carName;
    tblParam.driveDate = rowData.data.driveDate;
    tblParam.driveFlag = setUseFlag("num",rowData.data.driveFlag);
    tblParam.startTime = addZero(rowData.data.startTime, 4);
    if(tblParam.startTime.length != 4){
    	alert("출발시간 형식을 확인해주세요. \n입력 예) 09:30, 0930, 930");
    	$('#rowEditCheck').val("N"); //값변경체크 N
    	return;
    }
    tblParam.endTime = addZero(rowData.data.endTime, 4);
    if(tblParam.endTime.length != 4){
    	alert("도착시간 형식을 확인해주세요. \n입력 예) 09:30, 0930, 930");
    	$('#rowEditCheck').val("N"); //값변경체크 N
    	return;
    }
    tblParam.startFlag = setStartFlag("num",rowData.data.startFlag);
    tblParam.startAddr = rowData.data.startAddr;
    tblParam.endFlag = setEndFlag("num",rowData.data.endFlag);
    tblParam.endAddr = rowData.data.endAddr;
    tblParam.beforeKm = rowData.data.beforeKm;
    if(tblParam.beforeKm == null || tblParam.beforeKm == ""){
    	tblParam.beforeKm = 0;
    }
    tblParam.afterKm = rowData.data.afterKm;
    if(tblParam.afterKm == null || tblParam.afterKm == ""){
    	tblParam.afterKm = 0;
    }
    tblParam.mileageKm = rowData.data.mileageKm;
    if(tblParam.mileageKm == null || tblParam.mileageKm == ""){
    	tblParam.mileageKm = 0;
    }
    tblParam.note = rowData.data.note;
    //하단 상세주소(사용자 직접입력,회사,자택 시 상세주소도 동일하게 입력)
    tblParam.startAddrDetail = $('#inp_startAddr').val();
    if(tblParam.startFlag == "0" || tblParam.startFlag == "1" || tblParam.startFlag == "2")
    tblParam.startAddrDetail = rowData.data.startAddr;
    	
    tblParam.endAddrDetail = $('#inp_endAddr').val();
    if(tblParam.endFlag == "0" || tblParam.endFlag == "1" || tblParam.endFlag == "2")
    tblParam.endAddrDetail = rowData.data.endAddr;
    
    $.ajax({
        type: "post",
        url: '<c:url value="/cmm/ex/bizcar/insertBizCarData.do"/>',
        datatype: "json",
        data: tblParam,
        contenttype: "application/json;",
        success: function(data) {
        	var result = data.result;
        	if(result > 0){
        		getDataList();
        		//포커스 제어(getDataList() ajax 동기처리 해야함)
        		//$('#tbl_bizcarTop').extable('setFocus', afterFocusX, afterFocusY);
        	}else{
        		
        	}
        	$('#rowEditCheck').val("N");

        },
        error: function(data) {
            alert("저장하는 중 오류가 발생하였습니다.");
            $('#rowEditCheck').val("N");
        }
    });	
}

function fnErpSend(){
	//체크항목 가져오기
	var chkList = getChkBox(); //seq정보만
	var chkRowList = getChkBoxRow(); //row정보_seq정보
	var driveDateList = new Array(); //운행일자 마감체크하기 위해
	if(chkRowList.length == 0){
		alert("운행기록을 선택해주세요.");
		return;
	}
	if(!confirm("해당 데이터를 전송하시겠습니까?")){
		return;
	}
	//해당 행 데이터 값 체크 
	var dataChk = true;
	for(var i=0; i<chkRowList.length; i++){
		var split = chkRowList[i].split('_');
		var rowData = $('#tbl_bizcarTop').extable('getRowData', split[1]);
		driveDateList.push(rowData.driveDate); //마감체크 운행일자
		if(!sendRowChk(rowData)){
			dataChk = false;
		}
	}
	if(!dataChk){
		alert("기입하지 않은 항목이 있습니다.");
		return;
	}
	//icube 운행기록부 마감여부 체크
	var erpChkVal = erpCloseChk(driveDateList);
	if(erpChkVal != "ok"){
		alert("마감된 데이터입니다. (마감일:"+erpChkVal+") \n전송취소가 불가능하오니 담당자에게 문의하세요.");
		return;
	}
	
	//전송할 데이터 조합
	var sendList = new Array();
	for(var i=0; i<chkRowList.length; i++){
		var rowObj = {};
		var split = chkRowList[i].split('_');
		var rowData = $('#tbl_bizcarTop').extable('getRowData', split[1]);
		rowObj.carCode = rowData.carCode;
		rowObj.driveDate = rowData.driveDate;
		rowObj.seqNum = rowData.seqNum;
		rowObj.startTime = rowData.startTime;
		rowObj.mileageKm = rowData.mileageKm;
		if(rowData.mileageKm == null || rowData.mileageKm ==''){
			rowObj.mileageKm = '0';
		}
		var driveFlag = rowData.driveFlag; //운행구분
		if(driveFlag =='출근' || driveFlag =='퇴근' || driveFlag =='출퇴근'){
			rowObj.ioKm = rowData.mileageKm;
			rowObj.workKm = '0';
		}else if(driveFlag =='업무용') {
			rowObj.workKm = rowData.mileageKm;
			rowObj.ioKm = '0';
		}else{ //비업무용
			rowObj.workKm = '0';
			rowObj.ioKm = '0';
		}
		rowObj.beforeKm = rowData.beforeKm;
		if(rowObj.beforeKm == null || rowObj.beforeKm ==''){
			rowObj.beforeKm = '0';
		}
		rowObj.afterKm = rowData.afterKm;
		if(rowObj.afterKm == null || rowObj.afterKm ==''){
			rowObj.afterKm = '0';
		}
		rowObj.note = rowData.note;		
		
		sendList.push(rowObj);
	}
	
	var tblParam = {};
	tblParam.sendList = JSON.stringify(sendList);		
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/bizCarErpDataInsert.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
		beforeSend: function() {	              
			$('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
		},
	    success:function(data){
	    	$('html').css("cursor","auto");
			var result = data.result;
			if(result > 0){
				alert("전송하였습니다.");
				getDataList();
			}else{
				alert("실패하였습니다.");
			}			
		}
		, error:function(data){
			$('html').css("cursor","auto");
			alert("데이터 저장 중 오류가 발생하였습니다.");
		}
	});
	
}

function sendRowChk(rowData){
	var reVal = true;
	
	if(rowData.carCode == '' || rowData.carCode == null)
		reVal = false;
	if(rowData.driveDate == '' || rowData.driveDate == null)
		reVal = false;
	if(rowData.driveFlag == '' || rowData.driveFlag == null)
		reVal = false;
	if(rowData.startTime == '' || rowData.startTime == null)
		reVal = false;
	if(rowData.endTime == '' || rowData.endTime == null)
		reVal = false;
	if(rowData.startFlag == '' || rowData.startFlag == null)
		reVal = false;
	if(rowData.startAddr == '' || rowData.startAddr == null)
		reVal = false;
	if(rowData.endFlag == '' || rowData.endFlag == null)
		reVal = false;
	if(rowData.endAddr == '' || rowData.endAddr == null)
		reVal = false;
	if(rowData.beforeKm == '' || rowData.beforeKm == null)
		reVal = false;
	if(rowData.afterKm == '' || rowData.afterKm == null)
		reVal = false;
	if(rowData.mileageKm == '' || rowData.mileageKm == null)
		reVal = false;
	
	return reVal;
}

function divideRowChk(rowData){
	var reVal = true;	
	if(rowData.beforeKm == '' || rowData.beforeKm == null)
		reVal = false;
	if(rowData.afterKm == '' || rowData.afterKm == null)
		reVal = false;
	if(rowData.mileageKm == '' || rowData.mileageKm == null)
		reVal = false;
	
	return reVal;
}

function fnErpCancel(){
	//체크항목 가져오기
	var chkList = getChkBox(); //seq정보만
	var chkRowList = getChkBoxRow(); //row정보_seq정보
	var driveDateList = new Array(); //운행일자 마감체크하기 위해
	if(chkRowList.length == 0){
		alert("운행기록을 선택해주세요.");
		return;
	}
	if(!confirm("해당 데이터를 전송 취소하시겠습니까?")){
		return;
	}
	//해당 행 데이터 값 체크 
	var dataChk = true;
	for(var i=0; i<chkRowList.length; i++){
		var split = chkRowList[i].split('_');
		var rowData = $('#tbl_bizcarTop').extable('getRowData', split[1]);
		driveDateList.push(rowData.driveDate); //마감체크 운행일자
		if(rowData.sendYn != '전송'){
			alert("미전송 데이터는 전송취소할 수 없습니다.");
			return;
		}
	}
	//icube 운행기록부 마감여부 체크
	var erpChkVal = erpCloseChk(driveDateList);
	if(erpChkVal != "ok"){
		alert("마감된 데이터입니다. (마감일:"+erpChkVal+") \n전송취소가 불가능하오니 담당자에게 문의하세요.");
		return;
	}
	
	//전송취소 할 데이터 조합
	var sendDelList = new Array();
	for(var i=0; i<chkRowList.length; i++){
		var rowObj = {};
		var split = chkRowList[i].split('_');
		var rowData = $('#tbl_bizcarTop').extable('getRowData', split[1]);
		rowObj.carCode = rowData.carCode;
		rowObj.driveDate = rowData.driveDate;
		rowObj.seqNum = rowData.seqNum;
		
		sendDelList.push(rowObj);
	}
	
	var tblParam = {};
	tblParam.sendDelList = JSON.stringify(sendDelList);
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/bizCarErpDataDelete.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
		beforeSend: function() {	              
			$('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
		},
	    success:function(data){
	    	$('html').css("cursor","auto");
			var result = data.result;
			if(result > 0){
				alert("전송취소를 성공하였습니다.");
				getDataList();
			}else{
				alert("실패하였습니다.");
			}			
		}
		, error:function(data){
			$('html').css("cursor","auto");
			alert("데이터 저장 중 오류가 발생하였습니다.");
		}
	});
	
}

//페이지 로딩시 erp마감일자 가져오기
function getErpCloseDt(){
	var tblParam = {};
	tblParam.compSeq = "${loginVO.compSeq}";
	tblParam.groupSeq = "${loginVO.groupSeq}";
	tblParam.empSeq = "${loginVO.uniqId}";
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/getBizCarErpCloseDt.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
		async: false, //동기처리
	    success:function(data){
	    	var closeDt = data.bizCarCloseDt;
	    	erpCloseDt = closeDt; //전역변수에 담기
		}
		, error:function(data){
			alert("ERP 운행기록 마감일자를 가져오는 중 오류가 발생하였습니다.");			
		}
	});
	
}

function erpCloseChk(dList){
	var rtnChk = "";
	var tblParam = {};
	tblParam.compSeq = "${loginVO.compSeq}";
	tblParam.groupSeq = "${loginVO.groupSeq}";
	tblParam.empSeq = "${loginVO.uniqId}";
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/getBizCarErpCloseDt.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
		async: false, //동기처리
	    success:function(data){
	    	var closeDt = data.bizCarCloseDt;
	    	var fCnt = 0; //마감 항목 카운트
	    	//마감일자 날짜형식 변환
	    	var closeDateArr = closeDt.split('-');
	    	var closeDateCompare = new Date(closeDateArr[0], parseInt(closeDateArr[1])-1, closeDateArr[2]);
	    	
	    	for(var i=0; i<dList.length; i++){
	    		//운행일자 날짜형식 변환
	    		var driveDateArr = dList[i].split('-');
	    		var driveDateCompare = new Date(driveDateArr[0], parseInt(driveDateArr[1])-1, driveDateArr[2]);
	            
	            if(driveDateCompare.getTime() <= closeDateCompare.getTime()) {
	            	fCnt++;
	            }
	    	}
	    	
	    	if(fCnt == 0){
	    		rtnChk = "ok";
	    	}else{
	    		rtnChk = closeDt; //마감일자 반환
	    	}
			
		}
		, error:function(data){
			alert("데이터 가져오는 중 오류가 발생하였습니다.");			
		}
	});
	
	return rtnChk;
}

function fnDelete(){
	//체크항목 가져오기
	var chkList = getChkBox(); //seq정보만
	var chkRowList = getChkBoxRow(); //row정보_seq정보
	if(chkRowList.length == 0){
		alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
		return;
	}
	//해당 행 데이터 전송여부 체크 
	if(!fnSendChk(chkRowList)){
		alert("전송된 데이터는 삭제가 불가합니다.");
		return;
	}
	//해당 행 데이터 마감 체크 
	if(!fnCloseChk(chkRowList)){
		alert("마감된 데이터는 삭제가 불가합니다.");
		return;
	}
	
	if(!confirm("삭제한 데이터는 복원이 불가능합니다. \n체크된 데이터를 삭제하시겠습니까?")){
		return;
	}
	
	var tblParam = {};
    tblParam.seqNumArr = JSON.stringify(chkList);
    $.ajax({
        type: "post",
        url: '<c:url value="/cmm/ex/bizcar/deleteBizCarData.do"/>',
        datatype: "json",
        data: tblParam,
        contenttype: "application/json;",
        success: function(data) {
        	alert("삭제되었습니다.");
        	/* for(var j=0; j<delRow.length; j++ ){
        		$('#tbl_bizcarTop').extable('setRemoveRow', delRow[j]); //ex js에서 배열 n번째 삭제. 삭제후 배열 위치 달라지기에 다시 가져오기 수행
        	} */
        	getDataList();
        	
        	//하단 상세데이터 초기화
            fnNewDetailData();

        },
        error: function(data) {
            alert("삭제 중 오류가 발생하였습니다.");
        }
    });
}

function fnSendChk(chkRowList){
	var sendChk = true;
	for(var i=0; i<chkRowList.length; i++){
		var split = chkRowList[i].split('_');
		var rowData = $('#tbl_bizcarTop').extable('getRowData', split[1]);
		if(rowData.sendYn == "전송"){
			sendChk = false;
		}
	}
	return sendChk;
}

function fnCloseChk(chkRowList){
	var closeChk = true;
	for(var i=0; i<chkRowList.length; i++){
		var split = chkRowList[i].split('_');
		var rowData = $('#tbl_bizcarTop').extable('getRowData', split[1]);
		if(rowData.driveDate <= erpCloseDt){
			closeChk = false;
		}
	}
	return closeChk;
}

function fnCheck(obj){
	//$('.chkico').prop('checked', $(obj).prop('checked'));
	var checked = $(obj)[0].checked;
	
	if($(obj).attr("name") == "inp_chkAll"){
		$("input[type=checkbox][name=inp_chk]").prop("checked",checked);
	}else{
		if($("input[type=checkbox][name=inp_chk]:not(:checked)").length == 0){
			$("input[type=checkbox][name=inp_chkAll]").prop("checked",true);
		}else{
			$("input[type=checkbox][name=inp_chkAll]").prop("checked",false);
		}
	}
}

function getChkBox(){
	//체크박스 항목 가져오기
	var chkList = new Array();
	$.each($("input[type=checkbox][name=inp_chk]:checked"), function (i, t) {
		var chkInfo = $(t).attr("id");
		var split = chkInfo.split('_'); //id값에서 구분자로 seq만 가져오기
		chkList.push(split[2]);
    });
	return chkList;
}

function getChkBoxRow(){
	//체크박스 항목 가져오기
	var chkList = new Array();
	$.each($("input[type=checkbox][name=inp_chk]:checked"), function (i, t) {
		var chkInfo = $(t).attr("id");
		chkList.push(chkInfo); //rowSeq_seqNum 구분자로 행구분 포함 리턴
    });
	return chkList;
}

//조회기간 날짜 입력 자동 하이픈 추가
function auto_date_format(e, oThis){
    var num_arr = [ 
        97, 98, 99, 100, 101, 102, 103, 104, 105, 96,
        48, 49, 50, 51, 52, 53, 54, 55, 56, 57
    ]
    
    var key_code = ( e.which ) ? e.which : e.keyCode;
    if( num_arr.indexOf( Number( key_code ) ) != -1 ){
        var len = oThis.value.length;
        if( len == 4 ) oThis.value += "-";
        if( len == 7 ) oThis.value += "-";
    }
}

//운행일자 데이터 형식체크(운행일자 입력후 엔터 및 포커스 이동 시)
function chkDateStr(date){
	var date2 = date.replace(/[^0-9]/g,"");
	var pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
	var ptnChk = pattern.test(date);
	
	if(!ptnChk){ //날짜형식 패턴 체크
		var ywrow = $('#tbl_bizcarTop').extable('getSelectedRowData');
	
		if(date2.length == 8){
			var changeDate = changeDateStr(date2); //사용자 숫자 8자리 기입시 하이픈 자동추가
			$('#tbl_bizcarTop').extable('setRowData', { driveDate: changeDate}, ywrow.colIndex, ywrow.rowIndex);
		}else{
			alert("날짜형식(YYYY-MM-DD)에 맞지 않습니다. 입력값: "+date);
			$('#tbl_bizcarTop').extable('setRowData', { driveDate: ""}, ywrow.colIndex, ywrow.rowIndex);
			return false;
		}    			
	}
	return true;
}

//운행일자 8자리숫자 기입시 날짜형식으로 변환
function changeDateStr(str){
	var yyyy = str.substr(0,4);
	var mm = str.substr(4,2);
	var dd = str.substr(6,2);
	return yyyy+"-"+mm+"-"+dd;
}

//출발시간 형식 체크
function chkTimeVal(time){
	var time2 = time.replace(/[^0-9]/g,"");
	var pattern = /[0-9]{2}:[0-9]{2}/;
	var ptnChk = pattern.test(time);
}

//하단 경비합계 저장
function fnAmtSave(){
	var selRow = $('#tbl_bizcarTop').extable('getSelectedRowData').data;
	var selRowX = $('#tbl_bizcarTop').extable('getSelectedRowData').colIndex;
	var selRowY = $('#tbl_bizcarTop').extable('getSelectedRowData').rowIndex;
	
	if(typeof selRow == 'undefined'){
		alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
		return;
	}else if(selRow.seqNum == ""){
		alert("저장된 데이터를 선택해주세요.");
		return;
	}else if(selRow.sendYn == "Y"){
		alert("전송된 데이터는 변경할 수 없습니다.");
		return;
	}
	//var yytest = $('#listAmt_1 li.on').attr('val');
	
	var tblParam = {};
	tblParam.seqNum = selRow.seqNum;
	tblParam.oilAmtType = $('#listAmt_1 li.on').attr('val');
	tblParam.oilAmt = delComma($('#amtType01').val());
	tblParam.tollAmtType = $('#listAmt_2 li.on').attr('val');
	tblParam.tollAmt = delComma($('#amtType02').val());
	tblParam.parkingAmtType = $('#listAmt_3 li.on').attr('val');
	tblParam.parkingAmt = delComma($('#amtType03').val());
	tblParam.repairAmtType = $('#listAmt_4 li.on').attr('val');
	tblParam.repairAmt = delComma($('#amtType04').val());
	tblParam.etcAmtType = $('#listAmt_5 li.on').attr('val');
	tblParam.etcAmt = delComma($('#amtType05').val());
	
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/updateAmtData.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			var result = data.result;
			var totalAmt = data.totalAmt;
			if(result > 0){
				alert("경비항목을 저장하였습니다.");
				/* 해당 항목 합계 계산*/
				$('#tbl_bizcarTop').extable('setRowData', { totalAmt: addComma(totalAmt)}, selRowX, selRowY); //그리드 경비합계 update
				$('#total_Amt').val(addComma(totalAmt)); //하단 합계 update
				/* 전체 그리드 경비합계 계산 */
				var totalRow = $('#tbl_bizcarTop').extable('getAllData');
				var totalAllAmt = 0; //총 경비합계
				for(var j=0; j<totalRow.length; j++){
					if(totalRow[j].seqNum != ""){
						var amt = totalRow[j].totalAmt;
						totalAllAmt += Number(amt.replace(/[^0-9]/g,""));
					}
				}
				$('#totalAllAmt').html(addComma(totalAllAmt));
			}
		}
		, error:function(data){
			alert("경비항목 저장 중 오류가 발생하였습니다.");
		}
	});
}

//차량등록시 해당차량 마지막 주행후 거리 가져오기
function getCarAfterKm(carCode,rowX,rowY){
	var tblParam = {};
	tblParam.carCode = carCode;
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/getCarAfterKm.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
	    	var result = data.result.afterKm;
	    	if(result.length > 0){
	    		$('#tbl_bizcarTop').extable('setRowData', { beforeKm: result[0].AFTER_KM}, rowX, rowY);
	    	}
		}
		, error:function(data){
			
		}
	});
}

/* 하단 경비합계 pudd selectbox 사용  */
function puddSelectBox(){
	fnInitDeleteEvent();	
	
	//selectField를 클릭했을때
	$('.selectField').on("click",function(){
		
		if($(this).hasClass("disabled")){
		
			$(this).blur();
			
		}else if($(this).hasClass("on")){
			
			$(this).removeClass("on").blur();
			$(this).parent().find(".cloneList").removeClass("fadeIn").hide();
		
		}else{
		
			$(this).focus();
			selectPosition(this);
			$(this).addClass("on");
			$(".cloneList").removeClass("fadeIn").hide();
			$(this).parent().find(".cloneList").addClass("fadeIn").show();
			
		};
		
	}).blur(function(){
		
		if( !$(this).siblings(".cloneList").children().find("li").hasClass("hover") ){
			$(".cloneList").removeClass("fadeIn").hide();
		};
		
		$(this).removeClass("on");
		
	});
	
	//selectBox의 리스트를 클릭했을때
	$(".PUDD-UI-selectBox .cloneList li").on("click",function(){
		var changeText = $(this).text();
		$(this).parent().parent().siblings('.selectField').children('.selectText').text(changeText);
		$(this).siblings(".cloneList li").removeClass("on");
		$(this).addClass("on");
		$(".cloneList").removeClass("fadeIn").hide();
		//alert('클릭한값= '+$(this).attr("val"));
		
	}).hover(function(event){
		
		if(event.type == "mouseenter" ){
			$(this).addClass("hover");	
		}else{
			$(this).removeClass("hover");
		};
		
	});
	
}

//셀렉트에서 포커스 빠질때
function selectBlur(){
	
	$(".cloneList").removeClass("fadeIn").hide();
	
};

//셀렉트 리스트박스 위치조정
function selectPosition(obj){
	
	var This = $(obj);
	var parentWidth = This.parent().width()
	var parentHeight = This.parent().height();
	var bodyChk = $(window).height();
	var ThisY = This.offset().top;
	var ThisL = This.offset().left;
	var ScHeight = $(window).scrollTop();
	var listHeight = This.parent().find(".cloneList").height();
	var bottomHeight = ( (bodyChk - ThisY - parentHeight) + ScHeight );
	var elemHeight = (isNaN(Number(This.height())) ? 0 : Number(This.height())) + 6;
	var elemHeight2 = (isNaN(Number(This.height())) ? 0 : Number(This.height())) + 2;
	
	if(bottomHeight < listHeight){
		//위로	
		This.parent().find(".cloneList").css({"width":parentWidth-2 + "px","top":((ThisY - listHeight - 2)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});
		
	}else{
		//아래로
		if(This.parent().hasClass("PUDD-UI-selectBox")){
			
			This.parent().find(".cloneList").css({"width":parentWidth-2 + "px","top":((ThisY + elemHeight)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});	
		
		}else if(This.parent().hasClass("PUDD-UI-multiSelectBox")){
			
			This.parent().find(".cloneList").css({"width":parentWidth-2 + "px","top":((ThisY + elemHeight2)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});
			
		};
	};
};

function fnInitDeleteEvent(){
	$(".multiBox .del_btn").on("click",function( event ){
		
		if(event.stopImmediatePropagation) event.stopImmediatePropagation(); //MOZILLA
		else event.isImmediatePropagationEnabled = false; //IE
		
		var cloneIndex = $(this).attr("cloneindex");
		$(this).parent().parent().parent().siblings(".cloneList").children().find("li").eq(cloneIndex).removeClass("on");
		$(this).parent().remove();
		
	});
};


/* bizcarJs 따로 생성 끝 */
				
</script>
    
   

   
<!-- 컨트롤박스 -->
<div class="top_box">
    <dl>
        <dt>조회기간</dt>
        <dd>
            <div class="dal_div">
            <input id="txtFrDt" class="w113" onkeyup="auto_date_format(event, this)" onkeypress="auto_date_format(event, this)" maxlength="10"/>
                <!-- <input type="text" value="2017-02-01" class="w113" readonly />
                <a href="#n" class="button_dal"></a> -->
            </div>
            ~
            <div class="dal_div">
            <input id="txtToDt" class="w113" onkeyup="auto_date_format(event, this)" onkeypress="auto_date_format(event, this)" maxlength="10"/>
                <!-- <input type="text" value="2017-02-01" class="w113" readonly />
                <a href="#n" class="button_dal"></a> -->
            </div>
        </dd>
        <dt>차량번호</dt>
        <dd>
            <input class="input_search fl" id="carNum" type="text" value="" style="width:130px;" >
            <input type="hidden" id="carCode" name="carCode"/>
            <input type="hidden" id="carName" name="carName"/>
            <a href="#" class="btn_search" onclick="fnCarNumSearch();"></a>
        </dd>
        <dt class="ml40">전송여부</dt>
        <dd>
            <select id="sendType" class="selectmenu" style="width:80px;">
			<option value="" selected="selected">전체</option>
			<option value="1">전송</option>
			<option value="0">미전송</option>
		</select>
        </dd>
        <dd><input type="button" id="searchButton" value="검색" onclick="fnSearch();"/></dd>
        <input type="hidden" id="carSearch" name="carSearch" value="N"/>
    </dl>
</div>

<div class="sub_contents_wrap posi_re">
    <!-- 버튼 -->
    <div class="btn_div">
        <div class="left_div">
            <div class="controll_btn p0">
                <!-- <button id="driveSearch" onclick="fnDriveSearchPop();">주행거리 검색 (F6)</button> -->
                <button id="bookMark" onclick="fnBookMarkPop();">즐겨찾기</button>
                <button id="addrSet" onclick="fnAddressPop();">주소입력설정</button>
                <button id="reCal" onclick="fnReCalPop();">재계산</button>
            </div>
        </div>
        <div class="right_div">
            <div class="controll_btn p0">
                <button id="transSave" onclick="fnErpSend();">전송</button>
                <button id="transCancle" onclick="fnErpCancel();">전송취소</button>
                <button id="dataDivide" onclick="fnDividePop();" title="안분이란 선택한 운행기록에 대해 동일한 비율로 거리를 분배하는 기능입니다.">안분</button>
                <button id="dataCopy" onclick="fnCopyData();">복사</button>
                <button id="dataDel" onclick="fnDelete();">삭제</button>
                <button id="excelUpload" onclick="fnUploadPop();">업로드</button>
            </div>
        </div>
    </div>

    <!-- 테이블 -->
    <div class="table1">
    
        <div id="tbl_bizcarTop" class="cus_ta_ea"></div>
        <input type="hidden" id="rowEditCheck" name="rowEditCheck" value="N"/>
        
    </div>

    <!-- 합계 테이블 -->
    <div class="com_ta2 rowHeight">
        <table>
            <colgroup>
                <col width="440" />
                <col width="" />
                <col width="" />
                <col width="" />
                <col width="" />
            </colgroup>
            <tr class="total">
                <td>합계</td>
                <td>총 주행(Km)</td>
                <td id="totalKm" class="ri"></td>
                <td>총 경비합계 </td>
                <td id="totalAllAmt" class="ri"></td>
            </tr>
        </table>
    </div>


    <!-- 상세주소 -->
    <div>
        <p class="tit_p mt20">상세주소</p>
        <div class="vehicles_detail clear">
            <dl class="fl clear" style="width:50%;">
                <dt style="width:50px;">출발지</dt>
                <dd style="width:75%;"><input style="width:100%;" type="text" id="inp_startAddr" class="" disabled/></dd>
            </dl>
            <dl class="fr clear" style="width:50%;">
                <dt style="width:50px;">도착지</dt>
                <dd style="width:75%;"><input style="width:100%;" type="text" id="inp_endAddr" class="" disabled/></dd>
            </dl>
        </div>
    </div>
<!-- <img src="../../../Images/ico/ico_book01.png" alt="" id="bookmarkico"/> -->
    <!-- 경비합계 -->
    <div>
        <div class="btn_div mt20">
	        <div class="left_div">
	            <h5>경비합계</h5>
	        </div>
	        <div class="right_div">
	            <div class="controll_btn p0">
	                <button id="amtSave" onclick="fnAmtSave();">경비저장</button>
	            </div>
	        </div>
	    </div>
        	
        <div class="com_ta2 rowHeight">
            <table>
                <tr>
                    <th rowspan="2" class="borderR">합계</th>
                    <th colspan="2">유류비</th>
                    <th colspan="2">통행료</th>
                    <th colspan="2">주차비</th>
                    <th colspan="2">수선비</th>
                    <th colspan="2">기타</th>
                </tr>
                <tr>
                    <th>결재구분</th>
                    <th>금액</th>
                    <th>결재구분</th>
                    <th>금액</th>
                    <th>결재구분</th>
                    <th>금액</th>
                    <th>결재구분</th>
                    <th>금액</th>
                    <th>결재구분</th>
                    <th>금액</th>
                </tr>
                <tr>
                    <td class="ri"><input id="total_Amt" type="text" name="" size="20" onchange="getNumber(this);" style="width:100%; border:0; text-align:right;" readonly></td>
					<td>
					<!-- selectBox -->
					<div class="PUDD PUDD-UI-selectBox PUDD-COLOR-blue" style="width:90%;">
						<!-- 보여지는 필드 -->
						<div id="selectAmt_1" class="selectField" tabindex="1">
							<span class="selectText">0.없음</span>
							<button class="selectFieldBtn"><span class="arr"></span></button>
						</div>						
						<!-- 보여지는 리스트 :: 숨겨진 셀렉트와 매핑된 리스트 -->
						<div id="listAmt_1" class="cloneList">
							<ul>
								<li class="on" val="0">0.없음</li>
								<li val="1">1.현금</li>
								<li val="2">2.현금영수증</li>
								<li val="3">3.카드(법인)</li>
								<li val="4">4.카드(개인)</li>
							</ul>
						</div>
					</div>
					</td>
                    <td class="ri"><input id="amtType01" class="inp_Detail" type="text" name="" size="20" onchange="getNumber(this);" onkeyup="" style="width:100%; border:0; text-align:right;"></td>
                    <td>
                    <div class="PUDD PUDD-UI-selectBox PUDD-COLOR-blue" style="width:90%;">
						<!-- 보여지는 필드 -->
						<div id="selectAmt_2" class="selectField" tabindex="1">
							<span class="selectText">0.없음</span>
							<button class="selectFieldBtn"><span class="arr"></span></button>
						</div>						
						<!-- 보여지는 리스트 :: 숨겨진 셀렉트와 매핑된 리스트 -->
						<div id="listAmt_2" class="cloneList">
							<ul>
								<li class="on" val="0">0.없음</li>
								<li val="1">1.현금</li>
								<li val="2">2.현금영수증</li>
								<li val="3">3.카드(법인)</li>
								<li val="4">4.카드(개인)</li>
							</ul>
						</div>
					</div>
					</td>
                    <td class="ri"><input id="amtType02" class="inp_Detail" type="text" name="" size="20" onchange="getNumber(this);" onkeyup="" style="width:100%; border:0; text-align:right;"></td>
                    <td>
                    <div class="PUDD PUDD-UI-selectBox PUDD-COLOR-blue" style="width:90%;">
						<!-- 보여지는 필드 -->
						<div id="selectAmt_3" class="selectField" tabindex="1">
							<span class="selectText">0.없음</span>
							<button class="selectFieldBtn"><span class="arr"></span></button>
						</div>						
						<!-- 보여지는 리스트 :: 숨겨진 셀렉트와 매핑된 리스트 -->
						<div id="listAmt_3" class="cloneList">
							<ul>
								<li class="on" val="0">0.없음</li>
								<li val="1">1.현금</li>
								<li val="2">2.현금영수증</li>
								<li val="3">3.카드(법인)</li>
								<li val="4">4.카드(개인)</li>
							</ul>
						</div>
					</div>
					</td>
                    <td class="ri"><input id="amtType03" class="inp_Detail" type="text" name="" size="20" onchange="getNumber(this);" onkeyup="" style="width:100%; border:0; text-align:right;"></td>
                    <td>
                    <div class="PUDD PUDD-UI-selectBox PUDD-COLOR-blue" style="width:90%;">
						<!-- 보여지는 필드 -->
						<div id="selectAmt_4" class="selectField" tabindex="1">
							<span class="selectText">0.없음</span>
							<button class="selectFieldBtn"><span class="arr"></span></button>
						</div>						
						<!-- 보여지는 리스트 :: 숨겨진 셀렉트와 매핑된 리스트 -->
						<div id="listAmt_4" class="cloneList">
							<ul>
								<li class="on" val="0">0.없음</li>
								<li val="1">1.현금</li>
								<li val="2">2.현금영수증</li>
								<li val="3">3.카드(법인)</li>
								<li val="4">4.카드(개인)</li>
							</ul>
						</div>
					</div>
					</td>
                    <td class="ri"><input id="amtType04" class="inp_Detail" type="text" name="" size="20" onchange="getNumber(this);" onkeyup="" style="width:100%; border:0; text-align:right;"></td>
                    <td>
                    <div class="PUDD PUDD-UI-selectBox PUDD-COLOR-blue" style="width:90%;">
						<!-- 보여지는 필드 -->
						<div id="selectAmt_5" class="selectField" tabindex="1">
							<span class="selectText">0.없음</span>
							<button class="selectFieldBtn"><span class="arr"></span></button>
						</div>						
						<!-- 보여지는 리스트 :: 숨겨진 셀렉트와 매핑된 리스트 -->
						<div id="listAmt_5" class="cloneList">
							<ul>
								<li class="on" val="0">0.없음</li>
								<li val="1">1.현금</li>
								<li val="2">2.현금영수증</li>
								<li val="3">3.카드(법인)</li>
								<li val="4">4.카드(개인)</li>
							</ul>
						</div>
					</div>
					</td>
                    <td class="ri"><input id="amtType05" class="inp_Detail" type="text" name="" size="20" onchange="getNumber(this);" onkeyup="" style="width:100%; border:0; text-align:right;"></td>
                </tr>
            </table>
        </div>
    </div>
</div>
<!-- //sub_contents_wrap -->

<!-- 재계산 팝업창 정보  -->
<form id="frmReCal" name="frmReCal">
	<input type="hidden" id="fr_carNum" name="fr_carNum" value="" />
	<input type="hidden" id="fr_carCode" name="fr_carCode" value="" />
	<input type="hidden" id="fr_toDt" name="fr_toDt" value="" />
	<input type="hidden" id="fr_frDt" name="fr_frDt" value="" />
	<input type="hidden" id="fr_sendType" name="fr_sendType" value="" />
	<input type="hidden" id="fr_erpCloseDt" name="fr_erpCloseDt" value="" />
</form>


<!-- 차량검색 모달팝업----------------------------------------------------- -->       
<!-- <input type="hidden" id="modal-open" name="modal-open" onclick="" />                     
<div id="carnum-modal">
	팝업 띄우세요
	<button id="modal-close">창 닫기</button>
</div>
<div id="modal-bg"></div>
 --><!--// 차량검색 모달팝업----------------------------------------------------- --> 