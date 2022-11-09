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
	var groupCode = '';
	var groupCodeInfo = '';
	var detailCodeInfo = '';
	
	$(document).ready(function() {
		// 팝업 크기 조절
		fnSetResize();
		
		// 그룹 코드 목록 가져오기
		fnGetGroupCodeList();
		
		// 버튼 이벤트 
		fnButtonEvent();
	});

	// 버튼 이벤트
	function fnButtonEvent() {
		// 저장 버튼 이벤트
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
		$("#codeTypeName").keydown(function(e) { 
			if (e.keyCode == 13) {
				e.returnValue = false;
				e.cancelBubble = true;
				fnSearch();
			}
		});
	}
	
	// 그룹 코드 목록 가져오기
	function fnGetGroupCodeList() {
		var params = {}
		params.search = $("#codeTypeName").val();
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemUserDefineCodeListSelect.do" />',
			success : function(result) {
				fnGetGroupCodeListDraw(result.result);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	function fnGetGroupCodeListDraw(data) {
		var length = data.length;
		var tag = '';
		if(length == "0") {
			
		} else {
			for(var i=0; i<length; i++) {
				tag += '<tr class="' + data[i].groupCode + '|' + data[i].groupName + '|' + data[i].authGubun + '" id="' + data[i].groupCode + '" onclick="onSelect(this);">';
				tag += '<td>' + data[i].groupCode + '</td>';
				tag += '<td>' + data[i].groupName + '</td>';
				tag += '<td>' + data[i].authGubun + '</td>';	
			}
			
		}
		$("#groupCodeList").html(tag);	
	}
	
	// 그룹코드 클릭 시 이벤트
	function onSelect(e) {
		groupCode = e.id;
		groupCodeInfo = e.className;
		
		var tbody = document.getElementById("groupCodeList");
		var tr = tbody.getElementsByTagName("tr");
		var value = e.className;

		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		e.style.backgroundColor = "#E6F4FF";
		
		fnSelectedCodeType(value)
		fnGetGroupCodeDetail(groupCode);
	}
	
	//선택 코드 그려주기
	function fnSelectedCodeType(value) {
		var tag = '';
		
		tag += '<tr class="on">';
		tag += '<td>' + value.split("|")[0] + '</td>';
		tag += '<td>' + value.split("|")[1] + '</td>';
		tag += '<td>' + value.split("|")[2] + '</td>';
		tag += '</td>';
		
		$("#selectedCode").html(tag);
	}
	
	// 크룹코드 클릭 시 상세 코드 목록 가져오기
	function fnGetGroupCodeDetail(id) {
		fnDetailCodeList();
	}
	
	// 그룹코드 상세코드 조회
	function fnDetailCodeList() {
		var params = {};
		params.groupCode = groupCode;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemCodeGroupDetailCodeSelect.do" />',
			success : function(result) {
				
				fnDetailCodeDraw(result.result);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 그룹코드 상세 코드 그리기
	function fnDetailCodeDraw(data) {
		var length = data.length;
		var tag = '';
		
		if(length == "0") {
			
		} else {
			for(var i=0; i<length; i++) {
				tag += '<tr class="' + data[i].detailCode + '|' + data[i].detailCodeName + '" id="' + data[i].detailCode + '" onclick="onSelectDetail(this);">';
				tag += '<td>' + data[i].detailCode + '</td>';
				tag += '<td>' + data[i].detailCodeName +'</td>';
				tag += '<td>' + data[i].detailCodeOrder +'</td>';
				tag += '</tr>';
			}
		}
		$("#detailCodeList").html(tag);
	}
	
	function onSelectDetail(e) {
		var id = e.id;
		detailCodeInfo = e.className;
		var tbody = document.getElementById("detailCodeList");
		var tr = tbody.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		e.style.backgroundColor = "#E6F4FF";
	}
	
	
	
	/************** [이벤트] *****************/
	
	// [이벤트] 저장
	function fnSave() {
		var checkFlag = true;
		
		if(groupCodeInfo == "") {
			alert("<%=BizboxAMessage.getMessage("TX000017320","코드 유형을 선택해주세요.")%>");
			checkFlag = false;
			return;
		}
		
// 		if(detailCodeInfo == "") {
<%-- 			alert("<%=BizboxAMessage.getMessage("TX000017321","코드 유형 상세값을 선택해주세요.")%>"); --%>
// 			checkFlag = false;
// 			return;
// 		}
		
		if(checkFlag) {
			opener.fnCallBack(groupCodeInfo, detailCodeInfo);
			window.close();
		}
	}
	
	// [이벤트] 취소
	function fnCancel() {
		window.close();
	}
	
	// [이벤트] 검색
	function fnSearch() {
		fnGetGroupCodeList();
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
		<h1><%=BizboxAMessage.getMessage("TX000017322","코드 유형 및 기본값 선택")%></h1>
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
						<p class="tit_p"><%=BizboxAMessage.getMessage("TX000017323","코드유형선택")%></p>

						<div class="com_ta">
							<table>
								<colgroup>
									<col width="99" />
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000017324","코드유형검색")%></th>
									<td>
										<div class="dod_search">
											<input type="text" class="" id="codeTypeName"
												style="width: 80%;" placeholder="<%=BizboxAMessage.getMessage("TX000010918","코드유형명")%>" /><a href="#"
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
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
									<th><%=BizboxAMessage.getMessage("TX000010918","코드유형명")%></th>
									<th><%=BizboxAMessage.getMessage("TX000000016","설명")%></th>
								</tr>
							</table>
						</div>

						<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
							style="height: 327px;">
							<table>
								<colgroup>
									<col width="" />
									<col width="" />
									<col width="" />
								</colgroup>
								<tbody id="groupCodeList">
<!-- 									<tr class="on"> -->
<!-- 										<td>1536</td> -->
<!-- 										<td>넥스트</td> -->
<!-- 										<td>거래처</td> -->
<!-- 									</tr> -->

								</tbody>
								
							</table>
						</div>
					</td>

					<td class="twinbox_td">
						<!-- 선택된 코드 유형 -->
						<p class="tit_p"><%=BizboxAMessage.getMessage("TX000017325","선택된 코드 유형")%></p>

						<div class="com_ta2 sc_head" style="">
							<table>
								<colgroup>
									<col width="" />
									<col width="" />
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
									<th><%=BizboxAMessage.getMessage("TX000010918","코드유형명")%></th>
									<th><%=BizboxAMessage.getMessage("TX000000016","설명")%></th>
								</tr>
							</table>
						</div>

						<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
							style="height: 150px;">
							<table>
								<colgroup>
									<col width="" />
									<col width="" />
									<col width="" />
								</colgroup>
								<tbody id="selectedCode">
<!-- 									<tr class="on"> -->
<!-- 										<td>1536</td> -->
<!-- 										<td>넥스트</td> -->
<!-- 										<td>거래처</td> -->
<!-- 									</tr> -->
								</tbody>
								
							</table>
						</div> <!-- 코드 유형 상세(기본값 선택) -->
						<p class="tit_p mt14"><%=BizboxAMessage.getMessage("TX000017326","코드 유형 상세(기본값 선택)")%></p>

						<div class="com_ta2 sc_head" style="">
							<table>
								<colgroup>
									<col width="" />
									<col width="" />
									<col width="" />
								</colgroup>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
									<th><%=BizboxAMessage.getMessage("TX000017327","코드값")%></th>
									<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
								</tr>
							</table>
						</div>

						<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
							style="height: 150px;">
							<table>
								<colgroup>
									<col width="" />
									<col width="" />
									<col width="" />
								</colgroup>
								<tbody id="detailCodeList">
<!-- 									<tr class="on"> -->
<!-- 										<td>1536</td> -->
<!-- 										<td>넥스트</td> -->
<!-- 										<td>1</td> -->
<!-- 									</tr> -->
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
			<input type="button" id="btnSave" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> 
			<input type="button" id="btnCancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<!-- //pop_wrap -->
