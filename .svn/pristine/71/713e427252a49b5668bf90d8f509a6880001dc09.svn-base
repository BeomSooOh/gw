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
<%
	String gubun = request.getParameter("gubun");
	String groupCode = request.getParameter("groupCode");
%>

<script type="text/javascript">
	var gubun = "<%= gubun %>";
	var groupCode = "<%= groupCode %>";
	var duplicateFlag = false;
	
	$(document).ready(function() {
		// 팝업 크기 조절
		fnSetResize()
		
		// 버튼 이벤트
		fnButtonEvent();
		
		if(gubun == "edit") {
			$("#groupCode").attr("disabled", "disabled");
			$("#groupCode").val(groupCode);
		}
	});
	
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
	
	// 버튼 이벤트
	function fnButtonEvent() {
		// 저장 버튼 이벤트
		$("#saveButton").click(function(){
			fnSaveCodeGroup();
		});
		
		// 취소 버튼 이벤트
		$("#cancelButton").click(function(){
			fnCancelCodeGroup();
		});
	}
	
	// 저장 버튼
	function fnSaveCodeGroup() {		
		var checkFlag = false;
		var groupCode = $("#groupCode").val();
		var groupName = $("#groupName").val();
		var authGubun = $("#authGubun").val();
		var useYN = $(".useYN:checked").val();
		
		var params = {};
		params.groupCode = groupCode;
		params.groupName = groupName;
		params.authGubun = authGubun;
		params.useYN = useYN;
		
		checkFlag = fnSaveCheck();
		
		if(checkFlag) {
			alert("<%=BizboxAMessage.getMessage("TX000010857","필수 값이 입력되지 않았습니다")%>");
			return;
		}
		
		if(duplicateFlag) {
			alert("<%=BizboxAMessage.getMessage("TX000010757","코드가 중복되었습니다")%>");
			return;
		}
		
		if(gubun == "save") {
			$.ajax({
				type : "POST",
				data : params,
				async : false,
				url : '<c:url value="/cmm/systemx/item/ItemCodeGroupInsert.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000002598","저장하였습니다")%>");
					opener.fnCallBackInit();
					window.close();
				},
				error : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
				}
			});
		} else if(gubun == "edit") {
			$.ajax({
				type : "POST",
				data : params,
				async : false,
				url : '<c:url value="/cmm/systemx/item/ItemCodeGroupUpdate.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010628","수정하였습니다")%>");
					opener.fnCallBackInit();
					window.close();
				},
				error : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
				}
			});
		}
		
	}
	
	function fnSaveCheck() {
		var groupCode = $("#groupCode").val();
		var groupName = $("#groupName").val();
		
		if(groupCode == "") {
			$("#groupCode").focus();
			return true;
		}
		if(groupName == "") {
			$("#groupName").focus();
			return true;
		}
		
		return false;
	}
	
	// 취소 버튼
	function fnCancelCodeGroup() {
		window.close();
	}
	
	
	// 코드 중복 확인
	function checkGroupCodeSeq(id) {
		var strReg = /^[A-Za-z0-9]+$/; 

        if (!strReg.test(id)){
			alert('<%=BizboxAMessage.getMessage("TX000017329", "영문과 숫자만 입력가능합니다.")%>');
			$("#groupCode").val("");
			return;
        }
        
        var digit = /^[A-Za-z0-9]{0,5}$/;
        
        if (!digit.test(id)){
			alert('<%=BizboxAMessage.getMessage("", "그룹코드는 최대 5자리 입니다.")%>');
			$("#groupCode").val("");
			return;
        }
        
		if (id == ""){
			$("#info").prop("class", "");
	        $("#info").html("");
		}
		
        if (id != null && id != '') {
        	if(id == "0"){
            	$("#info").prop("class", "fl text_red f11 mt5 ml10");
                $("#info").html("! <%=BizboxAMessage.getMessage("TX000009762", "사용 불가능한 코드 입니다")%>");
            }
        	else{
	            $.ajax({
	                type: "post",
	                url : '<c:url value="/cmm/systemx/item/checkGroupCodeSeq.do" />',
	                datatype: "text",
	                data: { groupCodeSeq: id },
	                success: function (data) {
	                    if (data.result == "1") {
	                    	$("#info").prop("class", "fl text_blue f11 mt5 ml10");
	                        $("#info").html("* <%=BizboxAMessage.getMessage("TX000009763", "사용 가능한 코드 입니다")%>");
	                        duplicateFlag = false;
	                    }                    
	                    else {
	                    	$("#info").prop("class", "fl text_red f11 mt5 ml10");
	                        $("#info").html("! <%=BizboxAMessage.getMessage("TX000010757", "코드가 중복되었습니다")%>");
	                        duplicateFlag = true;
	                    }
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error");
	                }
	            });
            }
       	}	
	}
</script>

<div class="pop_wrap resources_reservation_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000017319","코드 그룹 등록")%></h1>
		<a href="#n" class="clo"><img
			src="../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">

		<div class="com_ta">
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img src="../../../../Images/ico/ico_check01.png" alt="" />
						<%=BizboxAMessage.getMessage("TX000000001","그룹코드")%></th>
					<td><input id="groupCode" class="fl" type="text" value=""
						placeholder="<%=BizboxAMessage.getMessage("TX000017333","영문/숫자만 입력가능")%>" style="width: 162px" onkeyup="checkGroupCodeSeq(this.value);">
						<p id="info" class="fl text_blue f11 mt5 ml10"></p>	
						<!-- <p class="fl text_red f11 mt5 ml10">! 코드가 중복되었습니다.</p>  사용 안할경우 p태그 주석처리-->
						<!-- <p class="fl text_blue f11 mt5 ml10">! 사용 가능한 코드 입니다.</p>  사용 안할경우 p태그 주석처리-->
					</td>
				</tr>
				<tr>
					<th><img src="../../../../Images/ico/ico_check01.png" alt="" />
						<%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
					<td><input id="groupName" class="" type="text" value="${codeDetailInfo.codeGrpNm}" style="width: 95%"></td>
				</tr>
 				<tr>
					<th><%=BizboxAMessage.getMessage("TX000006303","권한구분")%></th>
					<td><input id="authGubun" class="" type="text" value="${codeDetailInfo.codeGrpDesc}" style="width: 95%"></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
					<td>
						<input type="radio" name="inp_radi" id="useY" class="k-radio useYN" value="1" checked="checked" /> 
						<label class="k-radio-label radioSel2" for="useY"><%=BizboxAMessage.getMessage("TX000002850","예")%></label> 
						<input type="radio" name="inp_radi" id="useN" class="k-radio useYN" value="0" <c:if test="${codeDetailInfo.useYn == '0'}">checked</c:if> /> 
						<label class="k-radio-label radioSel2" for="useN" style="margin: 0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
					</td>
				</tr>
			</table>
		</div>

	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input id="saveButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> 
			<input id="cancelButton" type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<!-- //pop_wrap -->
