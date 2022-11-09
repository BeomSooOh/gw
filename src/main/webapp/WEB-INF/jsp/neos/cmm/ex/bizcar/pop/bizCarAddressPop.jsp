<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">

$(document).ready(function() {
	
	$('.inp_addr').change(function() { 
    	$('#inpEditCheck').val("Y"); 
    });
	
	fnResizeForm();

	getUserAddrData();
	
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


function getUserAddrData(){
	
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
				var addrInfo = data.userAddressInfo;
				$('#comp_adrr').val(addrInfo.compAddr);
				$('#house_adrr').val(addrInfo.houseAddr);
				
				if(addrInfo.newYn == "Y"){ //GW에서 가져온 데이터면 저장체크
					$('#inpEditCheck').val("Y");
				}
				
			}else {
				alert("조회시 오류가 발생하였습니다.");
			}
		}
		, error:function(data){
			alert("조회시 오류가 발생하였습니다.");
		}
	});
	
}

function fnSave(){
	var editChk = $('#inpEditCheck').val();
	if(editChk == "Y"){
		
		if(!confirm("저장하시겠습니까?")){
			return;
		}
		
		var tblParam = {};
		tblParam.compAddr = $('#comp_adrr').val();
		tblParam.houseAddr = $('#house_adrr').val();
		$.ajax({
	    	type:"post",
			url:'<c:url value="/cmm/ex/bizcar/pop/setUserAddress.do"/>',
			datatype:"json",
			data: tblParam ,
			contenttype: "application/json;",
		    success:function(data){
				var result = data.result;
				if(result > 0){
					alert("저장하였습니다.");
					//location.reload();
					self.close();
					
				}else {
					alert("저장시 오류가 발생하였습니다.");
				}
			}
			, error:function(data){
				alert("저장시 오류가 발생하였습니다.");
			}
		});		
		
	}else{
		self.close();
	}
	
}

		
function fnclose(){
	
	self.close();
}
</script>





<div class="pop_wrap" style="width:498px;">
	<div class="pop_head">
		<h1>주소입력 설정</h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	
	<div class="pop_con">
		<p class="tit_p">출발구분과 도착구분의 회사,자택정보를 설정합니다.</p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="100"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>1. 회사</th>
					<td>
						<!-- <input type="button" value="검색" class="blue_btn" /> -->
						<div class="mt5">
						<input type="text" id="comp_adrr" class="inp_addr" style="width:280px;"/>
						<!-- <select id=""class="selectmenu" style="width:280px;">
							<option value="" selected="selected"></option>
							<option value=""></option>
						</select> -->
						</div>
					</td>
				</tr>
				<tr>
					<th>2. 자택</th>
					<td>
						<!-- <input type="button" value="검색" class="blue_btn" /> -->
						<div class="mt5">
						<input type="text" id="house_adrr" class="inp_addr" style="width:280px;"/>
						<!-- <select id=""class="selectmenu" style="width:280px;">
							<option value="" selected="selected"></option>
							<option value=""></option>
						</select> -->
						</div>
					</td>
				</tr>
			</table>
		
		</div>
		
	</div><!-- //pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="hidden" id="inpEditCheck" name="inpEditCheck" value="N"/>
			<input type="button" value="저장" onclick="fnSave();"/>
			<input type="button"  class="gray_btn" value="취소" onclick="fnclose();"/>
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->