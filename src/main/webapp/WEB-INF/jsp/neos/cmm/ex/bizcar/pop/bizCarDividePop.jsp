<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
<%
String carCode = request.getParameter("carCode");
String seqNumList = request.getParameter("seqNumList");
//String driveDate = request.getParameter("driveDate");
%>

var totalKm = 0; //기입력 주행거리 총합계
var listCnt = 0;

$(document).ready(function() {

	getDivideList();

	fnResizeForm();

});//document ready end

//팝업 사이즈 조절
function fnResizeForm() {
	$(".location_info").css("display", "none");
	$(".iframe_wrap").css("padding", "0");

	var strWidth = $('.pop_wrap').outerWidth()
			+ (window.outerWidth - window.innerWidth);
	var strHeight = $('.pop_wrap').outerHeight()
			+ (window.outerHeight - window.innerHeight);

	$('.pop_wrap').css("overflow", "auto");
	//$('.jstreeSet').css("overflow","auto");

	var isFirefox = typeof InstallTrigger !== 'undefined';
	var isIE = /*@cc_on!@*/false || !!document.documentMode;
	var isEdge = !isIE && !!window.StyleMedia;
	var isChrome = !!window.chrome && !!window.chrome.webstore;

	if (isFirefox) {

	}
	if (isIE) {
		$(".pop_foot").css("width", strWidth);
	}
	if (isEdge) {

	}
	if (isChrome) {
	}

	try {
		window.resizeTo(strWidth, strHeight);
	} catch (exception) {
		console.log('window resizing cat not run dev mode.');
	}
}

function getDivideList(){
	var tblParam = {};
	var seqNumList= "<%= seqNumList %>";
	var seqNumArr = seqNumList.split(','); //구분자로 seq만 가져오기
	if(seqNumArr != ''){
		tblParam.seqNumArr = JSON.stringify(seqNumArr);
	}
	tblParam.carCode = "<%= carCode %>";
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/getBizCarDivideList.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
	    	var list = data.divideRowList;
	    	listCnt = list.length; //리스트 개수
	    	
	    	var c = listCnt - 1;
	    	$('#inp_afterKm1').val(list[c].AFTER_KM); //마지막행 주행후거리 입력
	    	
	    	setDivideListTable(list);
		}
		, error:function(data){
			alert("데이터 가져오는 중 오류가 발생하였습니다.");
		}
	});
}

function setDivideListTable(list){
	$("#divideListTable").html("");
    
	var InnerHtml = "";
	for(var i=0;i<list.length;i++){
		//var checkboxId = "inpchk_" + i;
		InnerHtml += "<tr id='" + list[i].SEQ_NUMBER +"_"+ list[i].CAR_CODE + "'>";
		InnerHtml += "<td>" + list[i].CAR_NUMBER + "</td><td>" + list[i].USE_DATE + "</td><td>" + useStr(list[i].USE_FLAG) + "</td><td>" + seStr(list[i].START_FLAG) + "</td><td class='le td_ellipsis' title='"+list[i].START_ADDR+"'>" + list[i].START_ADDR + "</td><td>" + seStr(list[i].END_FLAG) + "</td><td class='le td_ellipsis' title='"+list[i].END_ADDR+"'>" + list[i].END_ADDR + "</td><td class='ri'>" + list[i].MILEAGE_KM + "</td><td id='sum_km' class='ri'>" + "" + "</td><td id='edit_km' class='ri'>" + "" + "</td><td class='ri'>" + list[i].BEFORE_KM +"</td><td class='ri'>" + list[i].AFTER_KM + "</td></tr>";
		
		totalKm += list[i].MILEAGE_KM; //기입력 주행거리 총합계
	}
		
	$("#divideListTable").html(InnerHtml);
	
}

function sum_val(){
	var cal1 = $('#inp_afterKm1').val();
	var cal2 = $('#inp_afterKm2').val();
	
	if(isNaN(cal2)){
		return;
	}
	var mCal = cal2-cal1; //수정할주행 - 현재주행 = 잔여주행에 반영
	
	$('#inp_leftKm').val(mCal); 
	$('#edit_km').html(cal2);
	$('#sum_km').html(cal2);
	
	var table1 = document.getElementById("divideListTable");
	for(var i=0; i<listCnt; i++){
		var mileage = table1.rows[i].cells[7].innerHTML; //각 행의 기입력주행 가져오기
		var ratio = mileage / totalKm; //비율(기입력주행거리/기입력주행거리 총합계)
		//ratio = Math.round(ratio); //비율 반올림
		var plusKm = mCal * ratio; //증감(잔여주행거리*비율)
		plusKm = Math.round(plusKm); //증감 반올림
		table1.rows[i].cells[8].innerHTML = plusKm; //증감 셀반영
		
		var editKm = +mileage+plusKm; //숫자형 덧셈 수정할 주행(기입력주행+증감)
		table1.rows[i].cells[9].innerHTML = editKm; //수정할주행 셀반영
		
		var before = table1.rows[i].cells[10].innerHTML; //행의 주행전 가져오기
		var after = +before+editKm; //주행 후(주행전+수정할주행)
		if(i == listCnt-1){
			table1.rows[i].cells[11].innerHTML = cal2; //사용자가 입력한 수정할 주행후 데이터를 마지막 주행후 기입(반올림으로 차이가 날수있으므로 마지막행에 맞춘다.)
		}else{
			table1.rows[i].cells[11].innerHTML = after; //주행후 셀반영
			table1.rows[i+1].cells[10].innerHTML = after; //주행후값을 다음행 주행전 값으로 셀반영
		}		
		
	}
	
	//var tableSearch = $('divideListTable');
	// rows, cells ( TR / TD ) 를 length를 돌려
    // 테이블의 tr, td 갯수를 가져온다.
    //var rowLen = tableSearch.rows.length;
    //var celLen = tableSearch.cells.length;
    //var tdtd = tableSearch.rows[0].cells[1].innerHTML;
    
    
	
    /* // 체크된 체크박스 값을 가져온다
    checkbox.each(function(i) {
    
        // checkbox.parent() : checkbox의 부모는 <td>이다.
        // checkbox.parent().parent() : <td>의 부모이므로 <tr>이다.
        var tr = checkbox.parent().parent().eq(i);
        var td = tr.children();
        var tbData = {};
                
        // td.eq(0)은 체크박스 이므로  td.eq(1)의 값부터 가져와 객체에 담는다.
        tbData.td1 = td.eq(1).text();
    } */
	
}

function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}

function fnSave(){
	var chkVal = $('#inp_afterKm2').val();
	if(chkVal == '' || chkVal == '0'){
		alert("수정할 주행 후 데이터가 없습니다.");
		return;
	}
	
	if(isNaN(chkVal)){
		alert("수정할 주행 후 값이 숫자가 아닙니다.");
		return;
	}
	if(!confirm("안분 후 데이터를 복원할 수 없습니다. \n반영하시겠습니까?")){
		return;
	}
	
	var table1 = document.getElementById("divideListTable");
	var trArr = new Array();
	
	for(var i=0; i<listCnt; i++){
		var tdArr = {};
		var trId = table1.rows[i].id;
		var idSplit = trId.split('_');
		var driveDate = table1.rows[i].cells[1].innerHTML;
		var editkm = table1.rows[i].cells[9].innerHTML;
		var beforekm = table1.rows[i].cells[10].innerHTML;
		var afterkm = table1.rows[i].cells[11].innerHTML;
		tdArr.seqNum = idSplit[0];
		tdArr.carCode = idSplit[1];
		tdArr.driveDate = driveDate;
		tdArr.editkm = editkm;
		tdArr.beforekm = beforekm;
		tdArr.afterkm = afterkm;
		
		trArr.push(tdArr);
	}
	
	var tblParam = {};
	tblParam.divideList = JSON.stringify(trArr);
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/updateBizCarDivideList.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
	    	var result = data.result;
	    	if(result == 'ok'){
	    		alert("업데이트 성공");
	    		
	    		window.opener.getDataList();
	    		self.close();
	    	}else{
	    		alert("업데이트 실패하였습니다.");
	    	}
		}
		, error:function(data){
			alert("데이터 업데이트 중 오류가 발생하였습니다.");
		}
	});
	
}

function useStr(type){
	var str = "";
	if(type != ""){
		switch (type) {
		  case 1: str = "출근"; break;
		  case 2: str = "퇴근"; break;
		  case 3: str = "출퇴근"; break;
		  case 4: str = "업무용"; break;
		  case 5: str = "비업무용"; break;
		  default: str = ""; break;
		}
	}
	return str;
}
	
function seStr(type){
	var str = "";
	switch (type) {
	  case 0: str = "직접입력"; break;
	  case 1: str = "회사"; break;
	  case 2: str = "자택"; break;
	  case 3: str = "거래처"; break;
	  default: str = ""; break;
	}
	return str;
}

function fnClose(){
	
	self.close();
}
</script>





<div class="pop_wrap" style="width:998px;">
	<div class="pop_head">
		<h1>안분</h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo02.png" alt="" /></a>
	</div>
	
	<div class="pop_con">
           <div class="com_ta">
			<table>
				<colgroup>
					<col width="130"/>
					<col width="190"/>
					<col width="136"/>
					<col width="190"/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>현재 주행 후(Km)</th>
					<td><input type="text" id="inp_afterKm1" style="width:90%;padding-right:10px;" class="ar" readonly/></td>
					<th>수정할 주행 후(Km)</th>
					<td><input type="text" id="inp_afterKm2" style="width:90%;padding-right:10px;" class="ar" onKeyup="sum_val();" onkeydown="return onlyNumber(event)"/></td>
					<th>잔여 주행(Km)</th>
					<td><input type="text" id="inp_leftKm" style="width:90%;padding-right:10px;" class="ar" disabled /></td>
				</tr>
			</table>
		
		</div>

		<div class="com_ta2 mt15 sc_head">
			<table>
				<colgroup>
					<col width="7%"/>
					<col width="8%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="13%"/>
					<col width="7%"/>
					<col width="13%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="8%"/>
					<col width="8%"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>차량</th>
					<th>운행일자</th>
					<th>운행구분</th>
					<th>출발구분</th>
					<th>출발지</th>
					<th>도착구분</th>
					<th>도착지</th>
					<th>기입력주행</th>
					<th>증감(Km)</th>
					<th>수정 할 주행</th>
					<th>주행 전(Km)</th>
					<th>주행 후(Km)</th>
				</tr>
				</table>	
		</div>

		<div class="com_ta2 ova_sc2 bg_lightgray" style="height:148px;">
			<table>
				<colgroup>
					<col width="7%"/>
					<col width="8%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="13%"/>
					<col width="7%"/>
					<col width="13%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="8%"/>
					<col width="8%"/>
					<col width=""/>
				</colgroup>
				<tbody id="divideListTable">
					
				</tbody>
				<%-- <c:forEach items="${divideRowList}" var="list" varStatus="status">
				<tr>
					<td>
						<input type="hidden" name="seq_number" value="${list.SEQ_NUMBER}"/>
						<input type="hidden" name="car_code" value="${list.CAR_CODE}"/>
						${list.CAR_NUMBER}
					</td>
					<td>${list.USE_DATE}</td>
					<td>${list.USE_FLAG}</td>
					<td>${list.START_FLAG}</td>
					<td class="le td_ellipsis" title="${list.START_ADDR}">${list.START_ADDR}</td>
					<td>${list.END_FLAG}</td>
					<td class="le td_ellipsis" title="${list.END_ADDR}">${list.END_ADDR}</td>
					<td class="ri" id="ywyw">${list.MILEAGE_KM}</td>
					<td class="ri"></td>
					<td class="ri"></td>
					<td class="ri">${list.BEFORE_KM}</td>
					<td class="ri">${list.AFTER_KM}</td>
				</tr>
				</c:forEach> --%>
			</table>
		</div>
	</div><!-- //pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="확인" onclick="fnSave();"/>
			<input type="button"  class="gray_btn" value="취소" onclick="fnClose();"/>
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->