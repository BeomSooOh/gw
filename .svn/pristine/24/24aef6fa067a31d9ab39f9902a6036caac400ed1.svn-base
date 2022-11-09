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

<script type="text/javascript">
	var externalCode = '';
	var externalCodeName = '';

	$(document).ready(function() {
		// 팝업 크기 조절
		fnSetResize();
		
		// 외부 코드 목록 가져오기
		fnGetExternalCodeList();
		
		// 버튼 이벤트 
		fnButtonEvent();
	});
	
	// 버튼 이벤트 
	function fnButtonEvent() {
		// 반영 버튼 이벤트
		$("#btnSave").click(function(){
			fnSave();
		});
		
		// 취소 버튼 이벤트
		$("#btnCancel").click(function(){
			fnCancel();
		});
		
		// 검색 버튼 이벤트
		$("#btnSearch").click(function(){
			fnSearch();
		});
		
		// 검색 엔터 이벤트
		$("#externalName").keydown(function(e) { 
			if (e.keyCode == 13) {
				e.returnValue = false;
				e.cancelBubble = true;
				fnSearch();
			}
		});
	}
	
	
	// 외부 코드 목록 가져오기
	function fnGetExternalCodeList() {
		var params = {}
		params.search = $("#externalName").val();
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemExternalCodeListSelect.do" />',
			success : function(result) {
				//console.log(JSON.stringify(result));
				fnGetExternalCodeListDraw(result.result);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 외부코드 목록 그여주기
	function fnGetExternalCodeListDraw(data) {
		var length = data.length;
		var tag = '';
		if(length == "0") {
			
		} else {
			for(var i=0; i<length; i++) {
				tag += '<tr id="' + data[i].code + '" class="' + data[i].codeName + '" onclick="onSelect(this);">';
				tag += '<td>' + data[i].code + '</td>';
				tag += '<td>' + data[i].codeName + '</td>';
				tag += '</tr>';	
			}
			
		}
		$("#externalCodeList").html(tag);	
	}
	
	// 외부코드 클릭 시 이벤트
	function onSelect(e) {
		externalCode = e.id;
		externalCodeName = e.className;
		
		var tbody = document.getElementById("externalCodeList");
		var tr = tbody.getElementsByTagName("tr");
		var value = e.className;

		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		e.style.backgroundColor = "#E6F4FF";
		
		//fnSelectedCodeType(value)
		//fnGetGroupCodeDetail(groupCode);
	}
	
	// [이벤트] 저장
	function fnSave() {
		opener.fnCallBackExternalCode(externalCode, externalCodeName);
		window.close();
	}
	
	// [이벤트] 취소
	function fnCancel() {
		window.close();
	}
	
	// [이벤트] 검색
	function fnSearch() {
		fnGetExternalCodeList();
	}
	
	// 팝업 크기 조절
	function fnSetResize() {
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
</script>

<div class="pop_wrap resources_reservation_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900000019","코드 선택")%></h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	<!-- //pop_head -->

	<div class="pop_con">
		<div class="twinbox">
			<table style="min-height: inherit;">
				<colgroup>
					<col style="width: 50%;" />
					<col />
				</colgroup>
				<tr>
					<td class="twinbox_td">
						<p class="tit_p"><%=BizboxAMessage.getMessage("TX900000458","외부시스템연동 코드 목록")%></p>

						<div class="com_ta">
							<table>
								<colgroup>
									<col width="99" />
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX900000020","코드/코드명")%></th>
									<td>
										<div class="dod_search">
											<input type="text" class="" id="externalName"
												style="width: 80%;" placeholder="<%=BizboxAMessage.getMessage("TX900000020","코드/코드명")%>" /><a href="#"
												class="btn_sear" id="btnSearch"></a>
										</div>
									</td>
								</tr>
							</table>
						</div>

						<div class="com_ta2 sc_head mt14" style="">
							<table>
								<colgroup>
									<col width="" />
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
									<th><%=BizboxAMessage.getMessage("TX000000209","코드명")%></th>
								</tr>
							</table>
						</div>

						<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
							style="height: 327px;">
							<table>
								<colgroup>
									<col width="" />
									<col width="" />
								</colgroup>
								<tbody id="externalCodeList">
									<tr class="on">
										<td>1536</td>
										<td>넥스트</td>
									</tr>

								</tbody>
								
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="btnSave" value="<%=BizboxAMessage.getMessage("TX000000423","반영")%>" /> 
			<input type="button" id="btnCancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<!-- //pop_wrap -->