<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>


<script type="text/javascript">

var carNum = '${carNum}';
var carCode = '${carCode}';
var toDt = '${toDt}';
var frDt = '${frDt}';
var sendType = '${sendType}';
var erpCloseDt = '${erpCloseDt}';

$(document).ready(function() {
	
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

function fnSave(){
	var reCalType = $("input[name='recal_radi']:checked").val();
	//reCalType = 정방향 forward, 역방향 reverse

	if(typeof reCalType == 'undefined'){
		alert("재계산 옵션을 선택해주세요.");
		return;
	}
	
	var reCalChk = window.opener.fnChkReCalList(reCalType);
	
	if(reCalChk != "ok"){
		if(reCalChk == "fail1"){
			alert("재계산 할 첫번째 운행기록 값의 주행정보가 0이거나 기입되지 않았습니다.");
			return;
		}else if(reCalChk == "fail2"){
			alert("재계산 할 마지막 운행기록 값의 주행정보가  0이거나 기입되지 않았습니다.");
			return;
		}
	}	
	
	if(!confirm("재계산 후 데이터를 복원할 수 없습니다. \n재계산 하시겠습니까?")){
		return;
	}
	
	var tblParam = {};
	tblParam.carNum = carNum;
	tblParam.carCode = carCode;
	tblParam.toDt = toDt;
	tblParam.frDt = frDt;
	if(sendType != ""){
		tblParam.sendType = sendType;
	}	
	tblParam.reCalType = reCalType;
	tblParam.erpCloseDt = erpCloseDt;
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/reCalData.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			var result = data.result;
			if (result == "ok"){
				
				window.opener.getDataList();
				self.close();					
			}else {
				alert("재계산시 오류가 발생하였습니다.");
			}
			
		}
		, error:function(data){
			alert("재계산시 오류가 발생하였습니다.");
		}
	});
}

function fnClose(){
	
	self.close();
}
</script>





<div class="pop_wrap" style="width:578px;">
	<div class="pop_head">
		<h1>재계산</h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	
	<div class="pop_con">
		<p class="fwb"><span class="text_blue">${carNum}</span> 차량의 현재 조회 된 데이터의 주행 전/후 거리를 재계산합니다.</p>
		<div class="Pop_border p10 mt10">
			<p class="let1">
				<input type="radio" name="recal_radi" id="val_radi1" value="forward"/>
				<label for="val_radi1">정방향 : </label> 조회된 데이터 중 첫번째 라인의 데이터의 주행 전 거리를 기준으로 주행 전/후 거리 재계산</p>
			<p class="let1 mt10">
				<input type="radio" name="recal_radi" id="val_radi2" value="reverse"/>
				<label for="val_radi2">역방향 : </label> 조회된 데이터 중 마지막 라인의 데이터의 주행 전 거리를 기준으로 주행 전/후 거리 재계산</p>
		</div>
		<div class="mt5">
			<span class="text_red fr" style="font-size:11px">※마감된 데이터 및 ERP전송된 데이터는 재계산 대상에서 제외</span>
		</div>
		
	</div><!-- //pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="확인" onclick="fnSave();"/>
			<input type="button"  class="gray_btn" value="취소" onclick="fnClose();"/>
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->