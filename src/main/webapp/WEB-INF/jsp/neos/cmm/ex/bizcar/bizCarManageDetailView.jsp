<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>



<script type="text/javascript">

var userSe = '${userSe}';

$(document).ready(function() {

	visang_sel_size();
	$(window).resize(function() {
		visang_sel_size()
	});

	//시작날짜
	$("#txtFrDt").kendoDatePicker({
		format: "yyyy-MM-dd"
	});

	//종료날짜
	$("#txtToDt").kendoDatePicker({
		format: "yyyy-MM-dd"
	});
	
	//fnInitDatePicker(30);
	fnInitDatePicker();

	$(".visang_sel").hide();
	$(".visang").click(function() {
		$(".visang_sel").show();
	});

	$(".visang_sel").mouseover(function() {
		$(".visang_sel").show();
	});
	$(".visang_sel, .visang").mouseout(function() {
		$(".visang_sel").hide();
	});
		
	getBizCarDetailList();

}); //document ready end


//조회기간 셋팅 일자 세팅
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

// 사업장 레이어	
function visang_sel_size() {
	var visang_wid = $(".visang").width();
	var serefd_wid = $(".btn_search").width();
	$(".visang_sel").width(visang_wid + serefd_wid + 1);
}

//운행기록현황 리스트 가져오기
function getBizCarDetailList(){
	var checkbox = $("#biz_sel").find("input[name=inp_chk]:checked");
	var sendType = $('#sendType').val();
	var deptNm = $('#inp_deptNm').val();
	var userNm = $('#inp_userNm').val();
	
	var tblParam = {};
	tblParam.compSeq = "${loginVO.compSeq}";
	tblParam.groupSeq = "${loginVO.groupSeq}";
	tblParam.empSeq = "${loginVO.uniqId}";
	tblParam.toDt = $('#txtToDt').val();
    tblParam.frDt = $('#txtFrDt').val();
	tblParam.carNum = $("#carNum").val();
	tblParam.carCode = $("#carCode").val();
    if (sendType != ""){
    	tblParam.sendType = $('#sendType').val();
    }
    if (deptNm != ""){
    	tblParam.deptNm = deptNm;
    }
    if (userNm != ""){
    	tblParam.userNm = userNm;
    }
    if (checkbox.length > 0){
    	var chkSel = $("input[name=inp_chk]:checkbox:checked").map(function() {
            return this.value;
        }).get();
    	tblParam.chkSel = JSON.stringify(chkSel);
    }
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/getBizCarDetailList.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
		beforeSend: function() {	              
            $('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
        },
	    success:function(data){
	    	$('html').css("cursor","auto");
	    	var result = data.result;
	    	
	    	setListTable(result);
			
		}
		, error:function(data){
			$('html').css("cursor","auto");
			alert("데이터 가져오는 중 오류가 발생하였습니다.");
		}
	});
	
}

function setListTable(list){
	$("#carListTable").html("");
	var totalKm = 0; //총 주행
    var totalAllAmt = 0; //총 경비합계
    
	var InnerHtml = "";
	for(var i=0;i<list.length;i++){
		//var checkboxId = "inpchk_" + i;
		InnerHtml += "<tr onclick='fnClick(this)' id='" + list[i].CAR_CODE +"_"+ list[i].CAR_NUMBER + "'>";
		InnerHtml += "<td>" + list[i].CAR_CODE + "</td><td>" + list[i].CAR_NUMBER + "</td><td>" + list[i].CAR_NAME + "</td><td class='ri'>" + (list[i].TOTAL_KM == null ? '0' : list[i].TOTAL_KM) + "</td><td class='ri'>" + list[i].WORK_KM + "</td><td class='ri'>" + list[i].NOWORK_KM + "</td><td class='ri'>" + (list[i].WORK_RATIO == null ? '' : list[i].WORK_RATIO) + "</td><td class='ri'>" + addComma(list[i].TOTAL_AMT) + "</td><td class='ri'>" + addComma(list[i].OIL_AMT) + "</td><td class='ri'>" + addComma(list[i].TOLL_AMT) + "</td><td class='ri'>" + addComma(list[i].PARKING_AMT) +"</td><td class='ri'>" + addComma(list[i].REPAIR_AMT) +"</td><td class='ri'>" + addComma(list[i].ETC_AMT) + "</td></tr>";
		
		totalKm += list[i].TOTAL_KM;
        totalAllAmt += list[i].TOTAL_AMT;
	}
	
	$('#totalKm').html(totalKm);
    $('#totalAllAmt').html(addComma(totalAllAmt));
    
	if(list.length == 0)
		InnerHtml += "<tr><td colspan='13'>검색된 차량이 없습니다.</td></tr>";
		
	$("#carListTable").html(InnerHtml);
}

function fnClick(e){
	var table = document.getElementById("carListTable");
	var tr = table.getElementsByTagName("tr");
	for(var i=0; i<tr.length; i++)
		tr[i].style.background = "white";
	e.style.backgroundColor = "#E6F4FF";
	
	$("#selCarNum").val(e.id);
	getDetailRowData();
	
	//최하단 경비 데이터 초기화
	$('#bottom_amt1').html("");
	$('#bottom_amt2').html("");
	$('#bottom_amt3').html("");
	$('#bottom_amt4').html("");
	$('#bottom_amt5').html("");
	$('#bottom_totalamt').html("");
}

function getDetailRowData(){
	//상세현황
	var inCarNum = $('#selCarNum').val();
	var selCar = inCarNum.split('_');
	var carCode = selCar[0];
	var carNum = selCar[1];
    
	//상단검색조건
	var checkbox = $("#biz_sel").find("input[name=inp_chk]:checked");
	var sendType = $('#sendType').val();
	var deptNm = $('#inp_deptNm').val();
	var userNm = $('#inp_userNm').val();
	
    var tblParam = {};
	tblParam.compSeq = "${loginVO.compSeq}";
	tblParam.empSeq = "${loginVO.uniqId}";
	tblParam.carNum = carNum;
	tblParam.carCode = carCode;
	tblParam.toDt = $('#txtToDt').val();
    tblParam.frDt = $('#txtFrDt').val();
    if (sendType != ""){
    	tblParam.sendType = $('#sendType').val();
    }
    if (deptNm != ""){
    	tblParam.deptNm = deptNm;
    }
    if (userNm != ""){
    	tblParam.userNm = userNm;
    }
    if (checkbox.length > 0){
    	var chkSel = $("input[name=inp_chk]:checkbox:checked").map(function() {
            return this.value;
        }).get();
    	tblParam.chkSel = JSON.stringify(chkSel);
    }
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/detailViewRowData.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			var result = data.result;
			setListBottomTable(result);
		}
		, error:function(data){
			alert("상세현황 데이터를 가져오는 중 오류가 발생하였습니다.");
		}
	});
}

//상세현황 테이블 그리기
function setListBottomTable(list){
	$("#carListBottomTable").html("");
	var totalKm = 0; //주행 합계
	var ioKm = 0; //출퇴근 합계
	var workKm = 0; //일반업무 합계
	var noworkKm = 0; //비업무 합계
    var totalAmt = 0; //경비 합계
    
	var InnerHtml = "";
	for(var i=0;i<list.length;i++){
		InnerHtml += "<tr onclick='fnBottomClick(this)' id='" + list[i].CAR_CODE +"_"+ list[i].CAR_NUMBER + "_"+list[i].SEQ_NUMBER+"'>>";
		InnerHtml += "<td>" + list[i].USE_DATE + "</td><td>" + list[i].START_TIME + "</td><td>" + list[i].END_TIME +"</td>";
		if(userSe == "ADMIN"){
			//관리자는 상세현황리스트에 부서,이름 컬럼 추가로 보여짐
			InnerHtml += "<td>" + (list[i].DEPT_NAME == null ? '' : list[i].DEPT_NAME) + "</td><td>" + list[i].EMP_NAME +"</td>";
		}
		InnerHtml += "<td class='le td_ellipsis' title='"+list[i].START_ADDR+"'>" + list[i].START_ADDR + "</td><td class='le td_ellipsis' title='"+ list[i].END_ADDR+"'>"+ list[i].END_ADDR +"</td><td class='ri'>" + list[i].MILEAGE_KM + "</td><td class='ri'>" + (list[i].IO_KM == null ? '' : list[i].IO_KM) + "</td><td class='ri'>" + (list[i].WORK_KM == null ? '' : list[i].WORK_KM) + "</td><td class='ri'>" + (list[i].NOWORK_KM == null ? '' : list[i].NOWORK_KM) + "</td><td class='ri'>" + list[i].BEFORE_KM + "</td><td class='ri'>" + list[i].AFTER_KM +"</td><td class='ri'>" + addComma(list[i].TOTAL_AMT) +"</td><td class='le td_ellipsis' title='"+ list[i].RMK_DC+"'>"+list[i].RMK_DC + "</td><td>" + (list[i].ERP_SEND_YN == '1' ? '전송' : '미전송') + "</td></tr>";
		
		totalKm += list[i].MILEAGE_KM;
		ioKm += list[i].IO_KM;
		workKm += list[i].WORK_KM;
		noworkKm += list[i].NOWORK_KM;
		totalAmt += list[i].TOTAL_AMT;
		
	}
	$('#det_totalkm').html(totalKm);
	$('#det_km1').html(ioKm);
	$('#det_km2').html(workKm);
	$('#det_km3').html(noworkKm);
    $('#det_totalAmt').html(addComma(totalAmt));
    
	if(list.length == 0)
		InnerHtml += "<tr><td colspan='14'>검색된 차량이 없습니다.</td></tr>";
		
	$("#carListBottomTable").html(InnerHtml);
}

function fnBottomClick(e){
	var table = document.getElementById("carListBottomTable");
	var tr = table.getElementsByTagName("tr");
	for(var i=0; i<tr.length; i++)
		tr[i].style.background = "white";
	e.style.backgroundColor = "#E6F4FF";
	
	var trId = e.id;
	getDetailBottomRowData(trId);
}

function getDetailBottomRowData(id){
	//상세현황 Row 클릭
	var selCar = id.split('_');
	var carCode = selCar[0];
	var carNum = selCar[1];
	var seqNum = selCar[2];
    
    var tblParam = {};
	tblParam.compSeq = "${loginVO.compSeq}";
	tblParam.empSeq = "${loginVO.uniqId}";
	tblParam.carNum = carNum;
	tblParam.carCode = carCode;
	tblParam.seqNum = seqNum;
	tblParam.toDt = $('#txtToDt').val();
    tblParam.frDt = $('#txtFrDt').val();
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/detailViewRowData.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			var result = data.result[0];
			var bTotalAmt = result.OIL_AMT+result.TOLL_AMT+result.PARKING_AMT+result.REPAIR_AMT+result.ETC_AMT;
			$('#bottom_amt1').html(addComma(result.OIL_AMT));
			$('#bottom_amt2').html(addComma(result.TOLL_AMT));
			$('#bottom_amt3').html(addComma(result.PARKING_AMT));
			$('#bottom_amt4').html(addComma(result.REPAIR_AMT));
			$('#bottom_amt5').html(addComma(result.ETC_AMT));
			$('#bottom_totalamt').html(addComma(bTotalAmt));
			
		}
		, error:function(data){
			alert("상세현황 경비 데이터를 가져오는 중 오류가 발생하였습니다.");
		}
	});
}

function fnSearch() {
    var toDt = $('#txtToDt').val();
    var frDt = $('#txtFrDt').val();
    if(!chkSelDate(toDt) || !chkSelDate(frDt)){
    	alert('날짜형식(YYYY-MM-DD)에 맞지 않습니다.');
    	return;
    }
    var carNum = $('#carNum').val();
    if (carNum == ""){
    	$('#carCode').val("");
    }
    var carCode = $('#carCode').val();
    var sendType = $("#sendType").val();
    //alert("조회날짜=" + frDt + "~" + toDt + "\n" + "차량번호=" + carNum + "\n" + "차량코드=" + carCode +"\n" + "전송타입=" + sendType);
    getBizCarDetailList();
    
    //하단 상세현황 초기화
    $("#carListBottomTable").html("");
    
    //최하단 경비 데이터 초기화
	$('#bottom_amt1').html("");
	$('#bottom_amt2').html("");
	$('#bottom_amt3').html("");
	$('#bottom_amt4').html("");
	$('#bottom_amt5').html("");
	$('#bottom_totalamt').html("");

}

function fnCarNumSearch(){
	var carNum = $("#carNum").val();
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

function chkSelDate(date){
	var date2 = date.replace(/[^0-9]/g,"");
	var pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
	var ptnChk = pattern.test(date);
	return ptnChk;
}

function fnCarNumPop() {
    var compSeq = "${loginVO.compSeq}";
    var groupSeq = "${loginVO.groupSeq}";
    var empSeq = "${loginVO.uniqId}";
    var carNum = $("#carNum").val();

    var urlpop = "<c:url value='/cmm/ex/bizcar/pop/bizCarNumSearchPop.do'/>?compSeq=" + compSeq + "&groupSeq=" + groupSeq + "&empSeq=" + empSeq + "&carNum=" + encodeURI(carNum);
    openWindow2(urlpop, "fnCarNumPop", 400, 560, 0);
}

function setBizCarNum(no) {
	// 구분자로 받아서 split  차량코드_차량번호 
	var noSplit = no.split('_');
	$("#carCode").val(noSplit[0]); //차량코드
    $("#carNum").val(noSplit[1]); //차량번호
}

function selOnClick(){
	getBizCarDetailList();
	chkSelStr();
	$("#carListBottomTable").html("");
}

function chkSelStr(){
	var checkbox = $("#biz_sel").find("input[name=inp_chk]:checked");
	var cnt = checkbox.length;
	var str = "";  
    $("input[name=inp_chk]:checked").each(function (index) {  
        if(index != cnt-1){
        	str += $(this).attr("valname") + ", ";
        }else{
        	str += $(this).attr("valname");
        }
    });
    $('#visang').text(str);
}

//금액 값에 콤마 삽입
function addComma(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function fnExcelDown() {
	if (confirm("엑셀로 저장하시겠습니까?")) {

		var compSeq = "${loginVO.compSeq}";
		var empSeq = "${loginVO.uniqId}";
		var carCode = $('#carCode').val();
		var carNum = $('#carNum').val();
		var frDt = $("#txtFrDt").val();
		var toDt = $("#txtToDt").val();
		var sendType = $('#sendType').val();
		if(userSe == "ADMIN"){
			var deptNm = $('#inp_deptNm').val();
			var userNm = $('#inp_userNm').val();
		}else{
			var deptNm = "";
			var userNm = "";
		}
		
		var paraStr = "?compSeq=" + compSeq + "&empSeq=" + empSeq + "&carCode=" + carCode + "&carNum=" + carNum + "&frDt=" + frDt + "&toDt=" + toDt + "&sendType=" + sendType + "&deptNm=" + deptNm + "&userNm=" + userNm ;

		self.location.href = "/gw/cmm/ex/bizcar/bizCarExcelDown.do" + paraStr;

	}

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
</script>
    
   

<!-- 검색박스 -->
<div class="top_box">
    <dl>
        <dt>조회기간</dt>
        <dd>
            <div class="dal_div">
            <input id="txtFrDt" class="w113" onkeyup="auto_date_format(event, this)" onkeypress="auto_date_format(event, this)" maxlength="10"/>
            </div>
            ~
            <div class="dal_div">
            <input id="txtToDt" class="w113" onkeyup="auto_date_format(event, this)" onkeypress="auto_date_format(event, this)" maxlength="10"/>
            </div>
        </dd>
        <dt>차량번호</dt>
        <dd>
            <input class="input_search fl" id="carNum" type="text" value="" style="width:130px;" onkeydown="if(event.keyCode==13){javascript:fnCarNumSearch();}">
            <input type="hidden" id="carCode" name="carCode"/>
            <input type="hidden" id="carName" name="carName"/>
            <a href="#" class="btn_search" onclick="fnCarNumSearch();"></a>
        </dd>
        <dt class="ml40">전송여부</dt>
        <dd>
            <select id="sendType" class="selectmenu" style="width:80px; margin-right:5px;">
			<option value="" selected="selected">전체</option>
			<option value="1">전송</option>
			<option value="0">미전송</option>
        </dd>
        <dd><input type="button" id="searchButton" value="검색" onclick="fnSearch();"/></dd>
    </dl>
    <span class="btn_Detail">상세검색 <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<!-- 상세검색박스 -->
<div class="SearchDetail">
    <dl>
        <dt class="ar" style="width:50px;">구분</dt>
        <dd class="mr20">
            <div id="visang" class="visang" style="width:226px;">출근, 퇴근, 출퇴근, 업무용, 비업무용</div>
            <!-- 사업장 리스트 -->
            <div id="biz_sel" class="visang_sel">
                <ul>
                    <li class="pb10">
                        <input type="checkbox" name="inp_chk" id="check01" value="1" valname="출근" onclick="selOnClick();" checked="checked"/>
                        <label for="check01"><span>1.출근</span></label>
                    </li>
                    <li class="pb10">
                        <input type="checkbox" name="inp_chk" id="check02" value="2" valname="퇴근" onclick="selOnClick();" checked="checked"/>
                        <label for="check02"><span>2.퇴근</span></label>
                    </li>
                    <li class="pb10">
                        <input type="checkbox" name="inp_chk" id="check03" value="3" valname="출퇴근" onclick="selOnClick();" checked="checked"/>
                        <label for="check03"><span>3.출퇴근</span></label>
                    </li>
                    <li class="pb10">
                        <input type="checkbox" name="inp_chk" id="check04" value="4" valname="업무용" onclick="selOnClick();" checked="checked"/>
                        <label for="check04"><span>4.업무용</span></label>
                    </li>
                    <li class="">
                        <input type="checkbox" name="inp_chk" id="check05" value="5" valname="비업무용" onclick="selOnClick();" checked="checked"/>
                        <label for="check05"><span>5.비업무용</span></label>
                    </li>
                </ul>
            </div>
        </dd>
        <c:if test="${loginVO.userSe == 'ADMIN'}">
        <div id="inputBox">
	        <dt style="width:57px;">부서</dt>
	        <dd class="mr5">
	            <input type="text" id="inp_deptNm" value="" style="width:180px">
	        </dd>
	        <dt style="width:55px;">이름</dt>
	        <dd class="mr5">
	            <input type="text" id="inp_userNm" value="" style="width:150px">
	        </dd>
        </div>
        </c:if>
    </dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
    <div class="btn_div">
        <div class="left_div">
            <h5>운행기록현황</h5>
        </div>
        <div class="right_div">
            <div class="controll_btn p0">
                <button id="" onclick="fnExcelDown();">엑셀저장</button>
            </div>
        </div>
    </div>
    <div class="com_ta2 sc_head rowHeight">
        <table>
            <colgroup>
                <col width="7%" />
                <col width="9%" />
                <col width="7%" />
                <col width="8%" />
                <col width="8%" />
                <col width="8%" />
                <col width="9.5%" />
                <col width="8%" />
                <col width="7%" />
                <col width="7%" />
                <col width="7%" />
                <col width="7%" />
                <col width="" />
            </colgroup>
            <tr>
                <th>차량코드</th>
                <th>차량번호</th>
                <th>차종</th>
                <th>총주행(Km)</th>
                <th>업무용(Km)</th>
                <th>비업무용(Km)</th>
                <th>업무사용비율(%)</th>
                <th>경비합계</th>
                <th>유류비</th>
                <th>통행료</th>
                <th>주차비</th>
                <th>수선비</th>
                <th>기타</th>
            </tr>
        </table>
    </div>
    <div class="com_ta2 ova_sc2 bg_lightgray rowHeight" style="height:222px;">
        <table>
            <colgroup>
                <col width="7%" />
                <col width="9%" />
                <col width="7%" />
                <col width="8%" />
                <col width="8%" />
                <col width="8%" />
                <col width="9.5%" />
                <col width="8%" />
                <col width="7%" />
                <col width="7%" />
                <col width="7%" />
                <col width="7%" />
                <col width="" />
            </colgroup>
            <tbody id="carListTable">
					
			</tbody>
			<input type="hidden" id="selCarNum" name="selCarNum"/>
        </table>
    </div>
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

    <div class="btn_div mt20">
        <div class="left_div">
            <h5>상세현황</h5>
        </div>
    </div>

    <div class="com_ta2 sc_head rowHeight">
        <table>
       <!-- 관리자는 테이블 컬럼  부서,이름  추가 -->
   		<c:choose>
			<c:when test="${loginVO.userSe == 'ADMIN'}">
				<colgroup>
	              <col width="7%" />
	              <col width="5.5%" />
	              <col width="5.5%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="8%" />
	              <col width="8%" />
	              <col width="7%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="7.5%" />
	              <col width="6%" />
	              <col width="" />
	         	</colgroup>
	        	<tr>
	              <th>사용일자</th>
	              <th>출발시간</th>
	              <th>도착시간</th>
	              <th>부서</th>
	              <th>이름</th>
	              <th>출발지</th>
	              <th>도착지</th>
	              <th>주행(Km)</th>
	              <th>출퇴근</th>
	              <th>일반업무</th>
	              <th>비 업무</th>
	              <th>주행 전</th>
	              <th>주행 후</th>
	              <th>경비합계</th>
	              <th>비고</th>
	              <th>전송여부</th>
	          	</tr>
			</c:when>
			<c:otherwise >
				<colgroup>
	              <col width="7%" />
	              <col width="5.5%" />
	              <col width="5.5%" />
	              <col width="13.5%" />
	              <col width="13.5%" />
	              <col width="7%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="6%" />
	              <col width="7.5%" />
	              <col width="6%" />
	              <col width="" />
	         	</colgroup>
	        	<tr>
	              <th>사용일자</th>
	              <th>출발시간</th>
	              <th>도착시간</th>
	              <th>출발지</th>
	              <th>도착지</th>
	              <th>주행(Km)</th>
	              <th>출퇴근</th>
	              <th>일반업무</th>
	              <th>비 업무</th>
	              <th>주행 전</th>
	              <th>주행 후</th>
	              <th>경비합계</th>
	              <th>비고</th>
	              <th>전송여부</th>
	          	</tr>
			</c:otherwise>
		</c:choose>
            
        </table>
    </div>
    <div class="com_ta2 ova_sc2 bg_lightgray rowHeight" style="height:222px;">
        <table>
        <c:choose>
			<c:when test="${loginVO.userSe == 'ADMIN'}">
				<colgroup>
					<col width="7%" />
					<col width="5.5%" />
					<col width="5.5%" />
					<col width="6%" />
					<col width="6%" />
					<col width="8%" />
					<col width="8%" />
					<col width="7%" />
					<col width="6%" />
					<col width="6%" />
					<col width="6%" />
					<col width="6%" />
					<col width="6%" />
					<col width="7.5%" />
					<col width="6%" />
					<col width="" />
	            </colgroup>
			</c:when>
			<c:otherwise >
				<colgroup>
	                <col width="7%" />
	                <col width="5.5%" />
	                <col width="5.5%" />
	                <col width="13.5%" />
	                <col width="13.5%" />
	                <col width="7%" />
	                <col width="6%" />
	                <col width="6%" />
	                <col width="6%" />
	                <col width="6%" />
	                <col width="6%" />
	                <col width="7.5%" />
	                <col width="6%" />
	                <col width="" />
	            </colgroup>
			</c:otherwise>
		</c:choose>
            <tbody id="carListBottomTable">
					
			</tbody>
            
        </table>
    </div>
    <div class="com_ta2 rowHeight">
        <table>
            <colgroup>
                <col width="7%" />
                <col width="5.5%" />
                <col width="5.5%" />
                <col width="13.5%" />
                <col width="13.5%" />
                <col width="7%" />
                <col width="6%" />
                <col width="6%" />
                <col width="6%" />
                <col width="6%" />
                <col width="6%" />
                <col width="7.5%" />
                <col width="6%" />
                <col width="" />
            </colgroup>
            <tr class="total">
                <td colspan="5">합계</td>
                <td id="det_totalkm"></td>
                <td id="det_km1"></td>
                <td id="det_km2"></td>
                <td id="det_km3"></td>
                <td colspan="2">총 경비합계 </td>
                <td id="det_totalAmt" class="ri"></td>
                <td colspan="2"></td>
            </tr>
        </table>
    </div>

    <div class="top_box gray_box mt10">
        <dl>
            <dt style="width:75px;" class="ar">유류비 :</dt>
            <dd style="width:70px;" id="bottom_amt1" class="ar mt20"></dd>
            <dt style="width:75px;" class="ar">통행료 :</dt>
            <dd style="width:70px;" id="bottom_amt2" class="ar mt20"></dd>
            <dt style="width:75px;" class="ar">주차비 :</dt>
            <dd style="width:70px;" id="bottom_amt3" class="ar mt20"></dd>
            <dt style="width:75px;" class="ar">수선비 :</dt>
            <dd style="width:70px;" id="bottom_amt4" class="ar mt20"></dd>
            <dt style="width:75px;" class="ar">기타 :</dt>
            <dd style="width:70px;" id="bottom_amt5" class="ar mt20"></dd>
            <dt style="width:75px;" class="ar">합계 :</dt>
            <dd style="width:70px;" id="bottom_totalamt" class="ar mt20"></dd>
        </dl>
    </div>

</div>
<!-- //sub_contents_wrap -->
