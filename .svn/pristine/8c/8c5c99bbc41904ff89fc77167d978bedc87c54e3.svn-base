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
	var isShowNotUseFlag = false;
	var duplicateFlag = false;

	$(document).ready(function() {
		// 그룹 코드 목록 가져오기
		fnGetGroupCodeList();
		
		// 버튼 이벤트 초기화
		fnButtonEvent();
	});
	
	// 버튼 이벤트
	function fnButtonEvent() {
		// 검색 엔터 이벤트
		$("#searchGroupName").keydown(function(e) { 
			if (e.keyCode == 13) {
				e.returnValue = false;
				e.cancelBubble = true;
				fnGetGroupCodeList();
			}
		});
		
		// 검색 클릭 이벤트
		$("#searchButton").click(function(){
			fnGetGroupCodeList();
		})
		
		// 추가 버튼 이벤트 (그룹코드 목록)
		$("#saveGroupCodeButton").click(function(){
			fnSaveGroupCode("save");
		});
				
		// 삭제 버튼 이벤트 (그룹코드 목록)
		$("#deleteGroupCodeButton").click(function(){
			fnDeleteGroupCode();
		});
		
		// 신규 버튼 이벤트 (상세코드)
		$("#newDetailCodeButton").click(function(){
			fnInitDetailCode();
		});

		// 저장 버튼 이벤트 (상세코드)
		$("#saveDetailCodeButton").click(function(){
			fnSaveDetailCode();
		});
		
		// 삭제 버튼 이벤트 (상세코드)
		$("#deleteDetailCodeButton").click(function(){
			fnDeleteDetailCode();
		});
		
		// 수정 이벤트 (그룹코드 목록) 더블클릭
		$("#groupCodeList").on("dblclick", "tr", function(){
			fnSaveGroupCode("edit");
		});
		
		// 그룹코드 선택
		$("#groupCodeList").on("click", "tr", function(){
			onSelect(this);
		});
		
		// 체크 이벤트 확인
		$("#isShowNotUse").click(function() {
			if($(this).prop("checked")) {
				isShowNotUseFlag = true;
			} else {
				isShowNotUseFlag = false;
			}
			fnGetGroupCodeList();
		});
		
		// 전체 체크 박스 이벤트
		$("#allCheck").click(function(){
			if($(this).is(":checked")) {
				$("input[name=checkGroupCode]").prop("checked", true);
				
			} else {
				$("input[name=checkGroupCode]").prop("checked", false);
			}
		});
	}
	
	// 그룹 코드 목록 가져오기
	function fnGetGroupCodeList() {
		var params = {}
		params.search = $("#searchGroupName").val();
		
		if(isShowNotUseFlag) {
			params.isShowNotUse = "Y";
		} else {
			params.isShowNotUse = "N";
		}
		
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
				tag += '<tr id="' + data[i].groupCode + '" >';
				tag += '<td onclick="event.cancelBubble=true;">';
	 			tag += '<input type="checkbox" name="checkGroupCode" id="check_' + data[i].groupCode + '" class="k-checkbox" />';
	 			tag += '<label class="k-checkbox-label bdChk2" for="check_' + data[i].groupCode + '"></label>';
	 			tag += '</td>';
				tag += '<td>' + data[i].groupCode + '</td>';
				tag += '<td>' + data[i].groupName + '</td>';
				tag += '<td>' + data[i].useYN + '</td>';	
			}
			
		}
		$("#groupCodeList").html(tag);	
	}
	
	// 그룹코드 클릭 시 이벤트
	function onSelect(data) {
		groupCode = $(data).attr("id");
		
		$("#groupCodeList tr").removeClass("on");
		
		$(data).addClass("on");
		
		fnGetGroupCodeDetail(groupCode);
	}
	
	// 크룹코드 클릭 시 상세 코드 목록 가져오기
	function fnGetGroupCodeDetail(id) {
		fnDetailCodeList();
	}
	
	// 그룹코드 추가
	function fnSaveGroupCode(gubun) {
		var url = "pop/ItemPopGroupCodeRegView.do?gubun=" + gubun + "&groupCode=" + groupCode;
		var pop = window.open(url, "ItemPopGroupCodeRegView", "width=800,height=340");
	}
	
	// 상세코드 신규 버튼
	function fnInitDetailCode() {
		$("#detailCode").attr("disabled", false);
		$("#detailCode").val('');
		$("#detailCodeName").val('');
		$("#detailCodeNameEn").val('');
		$("#detailCodeNameJp").val('');
		$("#detailCodeNameCn").val('');
		$("#detailCodeOrder").val('');
		
		var tbody = document.getElementById("detailCodeList");
		var tr = tbody.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
	}
	
	// 상세코드 저장 버튼
	function fnSaveDetailCode() {
		
		if($("#detailCode").attr("disabled") == "disabled") {
			gubun = "edit";
		} else {
			gubun = "save";
		}
		
		var checkFlag = false;
		var params = {};
		params.detailCode = $("#detailCode").val();
		params.detailCodeName = $("#detailCodeName").val();
		params.detailCodeNameEn = $("#detailCodeNameEn").val();
		params.detailCodeNameJp = $("#detailCodeNameJp").val();
		params.detailCodeNameCn = $("#detailCodeNameCn").val();
		params.detailCodeOrder = $("#detailCodeOrder").val();
		params.groupCode = groupCode;
		// 필수 입력값 체크(상세코드)
		checkFlag = fnSaveCheck();
		
		if(groupCode == "") {
			alert("<%=BizboxAMessage.getMessage("TX000017346","그룹코드를 선택해주세요")%>");
			return;
		}
		
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
				url : '<c:url value="/cmm/systemx/item/ItemCodeGroupDetailCodeInsert.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
					
					fnDetailCodeList();
					fnInitDetailCode()
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
				url : '<c:url value="/cmm/systemx/item/ItemCodeGroupDetailCodeEdit.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000002580","수정되었습니다.")%>");
					fnDetailCodeList();
					fnInitDetailCode()
				},
				error : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
				}
			});
		}
		
	}

	// 필수 입력값 체크(상세코드)
	function fnSaveCheck() {
		var detailCode = $("#detailCode").val();
		var detailCodeName = $("#detailCodeName").val();
		
		if(detailCode == "") {
			$("#detailCode").focus();
			return true;
		} 
		if(detailCodeName == "") {
			$("#detailCodeName").focus();
			return true;
		}
		return false;
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
				tag += '<tr id="' + data[i].detailCode + '" onclick="onSelectDetail(this);">';
				tag += '<td>' + data[i].detailCode + '</td>';
				tag += '<td>' + data[i].detailCodeName + '</td>';
				//tag += '<td>' + data[i].detailCodeNameEn + '</td>';
				//tag += '<td>' + data[i].detailCodeNameJp + '</td>';
				//tag += '<td>' + data[i].detailCodeNameCn + '</td>';
				tag += '</tr>';
			}
		}
		$("#detailCodeList").html(tag);
	}
	
	// 상세 코드 목록 클릭 
	function onSelectDetail(e) {
		var id = e.id;
		var tbody = document.getElementById("detailCodeList");
		var tr = tbody.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		e.style.backgroundColor = "#E6F4FF";
		
		fnEditGroupCodeDetail(id);
	}
	
	// 상세코드 클릭 시
	function fnEditGroupCodeDetail(id) {
		var params = {};
		params.groupCode = groupCode;
		params.detailCode = id;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemDetailCodeSelect.do" />',
			success : function(result) {
				$("#detailCode").attr("disabled", "disabled");
				$("#detailCode").val(result.result.detailCode);
				$("#detailCodeName").val(result.result.detailCodeName);
				$("#detailCodeNameEn").val(result.result.detailCodeNameEn);
				$("#detailCodeNameJp").val(result.result.detailCodeNameJp);
				$("#detailCodeNameCn").val(result.result.detailCodeNameCn);
				$("#detailCodeOrder").val(result.result.detailCodeOrder);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
		
	}
	
	// 그룹 코드 삭제
	function fnDeleteGroupCode() {
		var checkCount = 0;
		var params = {};
		var groupCodeArray = new Array();
		
		$("#groupCodeList input:checkbox[name='checkGroupCode']").each(function() {
			var groupCodeParam = {};
			if($(this).prop("checked")){
				checkCount++;
				groupCodeParam.groupCode = $(this).attr("id").replace("check_", "");
				groupCodeArray.push(groupCodeParam);
			}
		});

		if(checkCount == 0) {
			alert("<%=BizboxAMessage.getMessage("TX000008093","삭제할 항목을 선택하여 주세요")%>");
			return;
		}
		
		if(!confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")) {
			return;
		}
		
		params.groupCodeArray = groupCodeArray;
		params.groupCodeArray = JSON.stringify(params);

		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemGroupCodeDelete.do" />',
			success : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000014096","삭제하였습니다.")%>");
				fnGetGroupCodeList();
				fnInitDetailCode();
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 상세코드 삭제
	function fnDeleteDetailCode() {
		var params = {};
		params.groupCode = groupCode;
		params.detailCode = $("#detailCode").val();
		
		if(!confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")) {
			return;
		}
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemDetailCodeDelete.do" />',
			success : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000014096","삭제하였습니다.")%>");
				fnDetailCodeList();
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 콜백함수 (새로고침)
	function fnCallBackInit() {
		fnGetGroupCodeList();
		fnInitDetailCode();
	}
	
	// 상세코드 중복 확인
	function checkDetailCodeSeq(id) {
		var strReg = /^[A-Za-z0-9]+$/; 

        if (!strReg.test(id)){
			alert("<%=BizboxAMessage.getMessage("TX000017329","영문과 숫자만 입력가능합니다.")%>");
			$("#detailCode").val("");
			return;
        }
        
        if(groupCode == "") {
        	alert("<%=BizboxAMessage.getMessage("TX000017346","그룹코드를 선택해주세요.")%>");
        	$("#detailCode").val("");
        	return;
        }
        
		var digit = /^[A-Za-z0-9]{0,5}$/;
        
        if (!digit.test(id)){
			alert('<%=BizboxAMessage.getMessage("TX900000021", "항목코드는 최대 5자리 입니다.")%>');
			$("#detailCode").val("");
			return;
        }
        
		if (id == ""){
			$("#info").prop("class", "");
	        $("#info").html("");
	        $("#chkSeq").val("false");
		}
		
        if (id != null && id != '') {
        	if(id == "0"){
            	$("#info").prop("class", "fl text_red f11 mt5 ml10");
                $("#info").html("! <%=BizboxAMessage.getMessage("TX000009762", "사용 불가능한 코드 입니다")%>");
                $("#chkSeq").val("false");
            }
        	else{
        		var params = {};
        		params.detailCodeSeq = id;
        		params.groupCodeSeq = groupCode;
        		
	            $.ajax({
	                type: "post",
	                url : '<c:url value="/cmm/systemx/item/checkDetailCodeSeq.do" />',
	                data: params,
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

<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></dt>
		<dd>
			<input type="text" class="" id="searchGroupName" style="width: 173px;" />
		</dd>
		<dd>
			<input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
		</dd>
		<dd class="fr mr20 mt0">
			<input type="checkbox" name="inp_chk" id="isShowNotUse" class="k-checkbox" /> <label
				class="k-checkbox-label bdChk2" for="isShowNotUse"><%=BizboxAMessage.getMessage("TX000017347","미사용 포함")%></label>
		</dd>
	</dl>
</div>

<div class="sub_contents_wrap">
	<div class="twinbox mt10">
		<table>
			<colgroup>
				<col style="width: 50%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<p class="tit_p fl mt7"><%=BizboxAMessage.getMessage("TX000017348","그룹 코드 목록")%></p>
					<div class="controll_btn fr p0">
						<button id="saveGroupCodeButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
						<button id="deleteGroupCodeButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
					</div>

					<div class="com_ta2 cl sc_head" style="">
						<table>
							<colgroup>
 								<col width="34" />
								<col width="" />
								<col width="" />
								<col width="25%" />
							</colgroup>
							<tr>
								<th><input type="checkbox" name="inp_chk" id="allCheck"
									class="k-checkbox" /> <label class="k-checkbox-label bdChk2"
									for="allCheck"></label></th>
								<th><%=BizboxAMessage.getMessage("TX000000001","그룹코드")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
							</tr>
						</table>
					</div>


					<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
						style="height: 572px;">
						<table>
							<colgroup>
 								<col width="34" />
								<col width="" />
								<col width="" />
								<col width="25%" />
							</colgroup>
							<tbody id="groupCodeList">
								<!-- <tr>
								<td><input type="checkbox" name="inp_chk" id=""
									class="k-checkbox" /> <label class="k-checkbox-label bdChk2"
									for=""></label></td>
								<td>1536</td>
								<td>넥스트</td>
								<td>사용</td>
							</tr> -->
							</tbody>
						</table>
					</div>
				</td>
				<td class="twinbox_td">

					<p class="tit_p fl mt7"><%=BizboxAMessage.getMessage("TX000017349","상세 코드")%></p>
					<div class="controll_btn fr p0">
						<button id="newDetailCodeButton" class="k-button"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
						<button id="saveDetailCodeButton" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
						<button id="deleteDetailCodeButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
					</div> <!-- 옵션설정 -->
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120" />
								<col width="" />
							</colgroup>
							<tr>
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
								<td><input id="detailCode" class="fl" type="text" value=""
									placeholder="<%=BizboxAMessage.getMessage("TX000017333","영문/숫자만 입력가능")%>" style="width: 162px" onkeyup="checkDetailCodeSeq(this.value);">
									<p id="info" class="fl text_blue f11 mt5 ml10"></p>	
									<!-- <p class="fl text_red f11 mt5 ml10">! 코드가 중복되었습니다.</p> 사용 안할경우 p태그 주석처리-->
									<!-- <p class="fl text_blue f11 mt5 ml10">! 사용 가능한 코드 입니다.</p>  사용 안할경우 p태그 주석처리-->
								</td>
							</tr>
							<tr>
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000005584","한글")%>)</th>
								<td><input id="detailCodeName" class="" type="text" value="" style="width: 95%"></td>
							</tr>
							<tr style="display: none">
								<th><%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000005585","영어")%>)</th>
								<td><input id="detailCodeNameEn" class="" type="text" value="" style="width: 95%"></td>
							</tr>
							<tr style="display: none">
								<th><%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000005586","일본어")%>)</th>
								<td><input id="detailCodeNameJp" class="" type="text" value="" style="width: 95%"></td>
							</tr>
							<tr style="display: none">
								<th><%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000018698","중국어")%>)</th>
								<td><input id="detailCodeNameCn" class="" type="text" value="" style="width: 95%"></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
								<td><input id="detailCodeOrder" class="" type="text" value="" style="width: 95%"></td>
							</tr>
						</table>
					</div>

					<p class="tit_p fl mt20"><%=BizboxAMessage.getMessage("TX000017350","상세 코드 목록")%></p>

					<div class="com_ta2 cl sc_head">
						<table>
							<colgroup>
								<col width="" />
								<col width="50%" />
							</colgroup>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000005584","한글")%>)</th>
								<th style="display:none;"><%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000005585","영어")%>)</th>
								<th style="display:none;"><%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000005586","일본어")%>)</th>
								<th style="display:none;"><%=BizboxAMessage.getMessage("TX000000209","코드명")%>(<%=BizboxAMessage.getMessage("TX000018698","중국어")%>)</th>
							</tr>
						</table>
					</div>


					<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
						style="height: 397px;">
						<table>
							<colgroup>
								<col width="" />
								<col width="50%" />
							</colgroup>
							<tbody id="detailCodeList">
								<!-- <tr>
								<td>1536</td>
								<td>넥스트</td>
							</tr> -->
							</tbody>
							
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- //sub_contents_wrap -->