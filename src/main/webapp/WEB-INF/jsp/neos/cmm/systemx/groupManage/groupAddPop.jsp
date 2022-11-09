<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>Bizbox A</title>

<!--Kendo ui css-->
<link rel="stylesheet" type="text/css"
	href="../../../css/kendoui/kendo.common.min.css">
<link rel="stylesheet" type="text/css"
	href="../../../css/kendoui/kendo.dataviz.min.css">
<link rel="stylesheet" type="text/css"
	href="../../../css/kendoui/kendo.mobile.all.min.css">

<!-- Theme -->
<link rel="stylesheet" type="text/css"
	href="../../../css/kendoui/kendo.silver.min.css" />

<!--css-->
<link rel="stylesheet" type="text/css" href="../../../css/main.css?ver=20201021">
<link rel="stylesheet" type="text/css" href="../../../css/common.css?ver=20201021">

<!--Kendo UI customize css-->
<link rel="stylesheet" type="text/css" href="../../../css/reKendo.css">

<!--js-->
<script type="text/javascript"
	src="../../../Scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../../../Scripts/common.js"></script>

<!--Kendo ui js-->
<script type="text/javascript"
	src="../../../Scripts/kendoui/jquery.min.js"></script>
<script type="text/javascript"
	src="../../../Scripts/kendoui/kendo.all.min.js"></script>

<%
	String type = request.getParameter("type");
	String grouppingSeq = request.getParameter("grouppingSeq");
%>

<script type="text/javascript">
	var type = "<%= type %>" ;
	
	
	$(document).ready(function() {
		// 버튼 이벤트 초기화
		fnEventInit();
		
		//기본버튼
		$(".controll_btn button").kendoButton();

		if(type=="mode") {
			var groupId = "<%= grouppingSeq %>";
			fnGetGroupData(groupId);
			$("#btnSave").val("<%=BizboxAMessage.getMessage("TX000001179","수정")%>");
		}
		
		// 팝업 크기 조절
		fnSetResize();
	});
	
	// 팝업 크기 조절
	function fnSetResize() {
		$(".location_info").css("display", "none");
		$(".iframe_wrap").css("padding", "0");
		
		var strWidth = $('.pop_wrap').outerWidth()
		+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);
		
		$('.pop_wrap').css("overflow","auto");
		//$('.jstreeSet').css("overflow","auto");
		
		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;
		
		if(isFirefox){
			
		}if(isIE){
			$(".pop_foot").css("width", strWidth);
		}if(isEdge){
			
		}if(isChrome){
		}
		
		try{
			window.resizeTo(strWidth, strHeight);	
		}catch(exception){
			console.log('window resizing cat not run dev mode.');
		}
	}
	
	// 버튼 이벤트 초기화
	function fnEventInit() {
		// 저장 버튼 이벤트
		$("#btnSave").click(function(){
			if(type == "mode") {
				var groupId = "<%= grouppingSeq %>";
				fnUpdate(groupId);
			} else {
				fnSave();	
			}
			
		});
		
		// 취소 버튼 이벤트
		$("#btnCancel").click(function(){
			fnPopClose();
		});
	}
	
	// 취소 버튼 
	function fnPopClose() {
		window.close();
	}
	
	// 저장버튼
	function fnSave() {
		var param = {};
		param.grouppingName = $("#groupName").val();
		param.grouppingNameEn = $("#groupNameEn").val();
		param.grouppingNameJp = $("#groupNameJp").val();
		param.grouppingNameCn = $("#groupNameCn").val();
		param.grouppingOrder = $("#groupOrder").val() || "9999";
		param.grouppingEtc = $("#etc").val() || "";
		
		if($("#groupName").val() == "") {
			alert("! "+"<%=BizboxAMessage.getMessage("TX000010630","필수 값이 입력되지 않았습니다.　                       (명칭)")%>".replace("　","\n"));
			return;
		}
		
		$.ajax({
			type: "POST"
			, url: 'groupSave.do'
			, data: param
			, success: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
				self.close();
				
				// 새로고침
				window.opener.fnGroupListData();
				window.opener.fnCompListData();

			}
			, error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 더블클릭(수정일 때)
	function fnGetGroupData(id) {
		var param = {};
		param.grouppingSeq = id;
		
		$.ajax({
			type: "POST"
			, url: 'groupInfo.do'
			, data: param
			, success: function(result) {
				//console.log(JSON.stringify(result));
				var data = result.groupInfo[0];
				
				$("#groupName").val(data.grouppingName);
				$("#groupNameEn").val(data.grouppingNameEn);
				$("#groupNameJp").val(data.grouppingNameJp);
				$("#groupNameCn").val(data.grouppingNameCn);
				$("#groupOrder").val(data.grouppingOrder);
				$("#etc").val(data.grouppingEtc);
			}
			, error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}	
		});
		
	}
	
	// 그룹 정보 수정
	function fnUpdate(id) {
		var param = {};
		param.grouppingSeq = id;
		param.grouppingName = $("#groupName").val();
		param.grouppingNameEn = $("#groupNameEn").val();
		param.grouppingNameJp = $("#groupNameJp").val();
		param.grouppingNameCn = $("#groupNameCn").val();
		param.grouppingOrder = $("#groupOrder").val() || "9999";
		param.grouppingEtc = $("#etc").val() || "";
		
		if($("#groupName").val() == "") {
			alert("! "+"<%=BizboxAMessage.getMessage("TX000010630","필수 값이 입력되지 않았습니다.　                       (명칭)")%>".replace("　","\n"));
			return;
		}
		
		$.ajax({
			type: "POST"
			, url: 'groupInfoUpdate.do'
			, data: param
			, success: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010628","수정하였습니다")%>");
				self.close();
				
				// 새로고침
				window.opener.fnGroupListData();
				window.opener.fnCompListData();

			}
			, error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
</script>

</head>

<body class="">
	<div class="pop_wrap">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000016358","그룹핑 폴더등록")%></h1>
			<a href="#n" class="clo"><img
				src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
		</div>
		<!-- //pop_head -->
		<div class="pop_con">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="100" />
						<col width="" />
					</colgroup>
					<tr>
						<th rowspan="4"><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000152","명칭")%></th>
						<th><img src="../../../Images/ico/ico_check01.png" alt="" />
							<%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
						<td><input type="text" id="groupName" class="ml10" style="width: 90%;" /></td>						
					</tr>
					<tr>
						<th><img src="" alt="" />
							<%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
						<td><input type="text" id="groupNameEn" class="ml10" style="width: 90%;" /></td>
					</tr>
					<tr>	
						<th><img src="" alt="" />
							<%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
						<td><input type="text" id="groupNameJp" class="ml10" style="width: 90%;" /></td>
					</tr>
					<tr>
						<th><img src="" alt="" />
							<%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
						<td><input type="text" id="groupNameCn" class="ml10" style="width: 90%;" /></td>
					</tr>
					<tr>
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
						<td><input type="text" id="groupOrder" class="ml10" style="width: 90%;" /></td>
					</tr>
					<tr>
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
						<td><input type="text" id="etc" class="ml10" style="width: 90%;" /></td>
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
</body>
</html>