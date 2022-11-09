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
<style>
	.hidden-multi-lang {
		display: none !important; 
	}
</style>
<script type="text/javascript">
	var isShowNotUseFlag = false;
	var externalCode = '';
	
	$(document).ready(function() {
		// 코드 목록 가져오기
		fnGetExternalCodeList();
		
		// 버튼 이벤트 초기화
		fnButtonEvent();
		
		// 최초 진입
		fnSelectDbType(0);
	});
	
	// 버튼 이벤트
	function fnButtonEvent() {
		// 검색 엔터 이벤트
		$("#searchExternalCodeName").keydown(function(e) { 
			if (e.keyCode == 13) {
				e.returnValue = false;
				e.cancelBubble = true;
				fnGetExternalCodeList();
			}
		});
		
		// 검색 클릭 이벤트
		$("#searchButton").click(function(){
			fnGetExternalCodeList();
		});
		
		// 신규 버튼 이벤트 
		$("#newExternalCodeButton").click(function(){
			fnInitExternalCode();
		});
		
		// 저장 버튼 이벤트
		$("#saveExternalCodeButton").click(function(){
			fnSaveExternalCode();
		});
		
		// 삭제 버튼 이벤트
		$("#deleteExternalCodeButton").click(function(){
			fnDeleteExternalCode();
		});
		
		// 체크 이벤트 확인
		$("#isShowNotUse").click(function() {
			if($(this).prop("checked")) {
				isShowNotUseFlag = true;
			} else {
				isShowNotUseFlag = false;
			}
			fnGetExternalCodeList();
		});
		
		// 그룹코드 선택
		$("#externalCodeList").on("click", "tr", function(){
			onSelect(this);
		});
		
		$("input:radio[name='dbType']").click(function() {
			fnSelectDbType($(this).attr("value"));
		});
	}
	
	// 외부코드 목록 가져오기
	function fnGetExternalCodeList() {
		var params = {}
		params.search = $("#searchExternalCodeName").val();
		
		if(isShowNotUseFlag) {
			params.isShowNotUse = "Y";
		} else {
			params.isShowNotUse = "N";
		}
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemExternalCodeListSelect.do" />',
			success : function(result) {
				//console.log(JSON.stringify(result.result));
				fnGetExternalCodeListDraw(result.result);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 신규 버튼 이벤트 
	function fnInitExternalCode() {
		fnSelectDbType(0);
		
		$("#code").attr("disabled", false);
		$("#code").val('');
		$("#codeName").val('');
		$("#codeExplanation").val('');
		$("input:radio[name='dbType'][value='0']").prop("checked", true);
		$("#dbName").val('');
		$("#dbAddress").val('');
		$("#dbID").val('');
		$("#dbPW").val('');
		$("#dbCode").val('');
		$("#dbCodeName").val('');
		$("#outputForm").val('');
		$("#outputFormEn").val('');
		$("#outputFormJp").val('');
		$("#outputFormCn").val('');
		$("#searchCode").val('');
		$("#returnCode").val('');
		$("#returnCodeEn").val('');
		$("#returnCodeJp").val('');
		$("#returnCodeCn").val('');
		$("#returnCodeOutputForm").val('');
		$("#returnCodeOutputFormEn").val('');
		$("#returnCodeOutputFormJp").val('');
		$("#returnCodeOutputFormCn").val('');
		$("input:radio[name='selectMode'][value='m']").prop("checked", true);
		$("#queryArea").val('');
		
		$("#popupWidthSize").val('');
		$("#popupHeightSize").val('');
		$("#callbackFuncName").val('');
		$("#url").val('');
		
		var tbody = document.getElementById("externalCodeList");
		var tr = tbody.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
	}
	
	// 저장 버튼 이벤트
	function fnSaveExternalCode() {
		var gubun = "";
		var checkFlag = false;
		var params = {};
		var query = $("#queryArea").val();
		
		
		
		if($("#code").attr("disabled") == "disabled") {
			gubun = "edit";
		} else {
			gubun = "save";
		}
		
		params.code = $("#code").val().replace(/ /g, '');
		params.codeName = $("#codeName").val().replace(/ /g, '');
		params.codeExplanation = $("#codeExplanation").val();
		params.dbType = $("input:radio[name='dbType']:checked").val().replace(/ /g, '');
		params.dbName = $("#dbName").val().replace(/ /g, '');
		params.dbAddress = $("#dbAddress").val().replace(/ /g, '');
		params.dbID = $("#dbID").val().replace(/ /g, '');
		params.dbPW = $("#dbPW").val().replace(/ /g, '');
		params.dbCode = $("#dbCode").val().replace(/ /g, '');
		params.dbCodeName = $("#dbCodeName").val().replace(/ /g, '');
		params.outputForm = $("#outputForm").val().replace(/ /g, '');
		params.outputFormEn = $("#outputFormEn").val().replace(/ /g, '');
		params.outputFormJp = $("#outputFormJp").val().replace(/ /g, '');
		params.outputFormCn = $("#outputFormCn").val().replace(/ /g, '');
		params.searchCode = $("#searchCode").val().replace(/ /g, '');
		params.returnCode = $("#returnCode").val().replace(/ /g, '');
		params.returnCodeEn = $("#returnCodeEn").val().replace(/ /g, '');
		params.returnCodeJp = $("#returnCodeJp").val().replace(/ /g, '');
		params.returnCodeCn = $("#returnCodeCn").val().replace(/ /g, '');
		params.returnCodeOutputForm = $("#returnCodeOutputForm").val().replace(/ /g, '');
		params.returnCodeOutputFormEn = $("#returnCodeOutputFormEn").val().replace(/ /g, '');
		params.returnCodeOutputFormJp = $("#returnCodeOutputFormJp").val().replace(/ /g, '');
		params.returnCodeOutputFormCn = $("#returnCodeOutputFormCn").val().replace(/ /g, '');
		params.queryArea = $("#queryArea").val();
		params.selectMode = $("input:radio[name='selectMode']:checked").val();
		params.useYN = $("input:radio[name='useYN']:checked").val();
		
		
		params.popupWidthSize = $("#popupWidthSize").val() || "";
		params.popupHeightSize = $("#popupHeightSize").val() || "";
		params.callbackFuncName = $("#callbackFuncName").val() || "";
		params.url = $("#url").val() || "";
		
		

		// 필수 입력값 체크(상세코드)
		checkArray = fnSaveCheck();
		
		if(checkArray.length == 0) {
			checkFlag = false;
		} else {
			checkFlag = true;
		}
		
		if(checkFlag) {
			var resultString = '';
			
			for(var i=0; i<checkArray.length; i++) {
				resultString += checkArray[i] + ",";  
			}
			
			fnPopAlert(resultString.slice(0, -1));
			
			
			return;
		}
		
		//return;
		if(gubun == "save") {
			$.ajax({
				type : "POST",
				data : params,
				async : false,
				url : '<c:url value="/cmm/systemx/item/ItemExternalCodeInsert.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
					
					fnGetExternalCodeList();
					fnInitExternalCode();
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
				url : '<c:url value="/cmm/systemx/item/ItemExternalCodeEdit.do" />',
				success : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000002580","수정되었습니다.")%>");
					
					fnGetExternalCodeList();
					fnInitExternalCode();
				},
				error : function(result) {
					alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
				}
			});
		}
	}

	// 삭제 버튼 이벤트
	function fnDeleteExternalCode() {
		var params = {};
		params.externalCode = externalCode;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemExternalCodeDelete.do" />',
			success : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000014096","삭제하였습니다.")%>");
				
				fnGetExternalCodeList();
				fnInitExternalCode();
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 코드 목록 그려주기
	function fnGetExternalCodeListDraw(data) {
		var length = data.length;
		var tag = '';

		if(length == "0") {
			
		} else {
			for(var i=0; i<length; i++) {
				tag += '<tr id="' + data[i].code + '">';
				tag += '<td onclick="event.cancelBubble=true;">' + data[i].code + '</td>';
				tag += '<td>' + data[i].codeName + '</td>';
				tag += '<td>' + data[i].useYN + '</td>';
				tag += '</tr>';	
			}
		}
		
		$("#externalCodeList").html(tag);
	}
	
	// 그룹코드 클릭 시 이벤트
	function onSelect(data) {
		externalCode = $(data).attr("id");
		
		$("#externalCodeList tr").removeClass("on");
		
		$(data).addClass("on");
		
		fnGetExternalCodeDetail(externalCode);
	}
	
	// 코드목록 세부 사항 가져오기
	function fnGetExternalCodeDetail(data) {
		var params = {};
		params.externalCode = data;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/ItemExternalCodeDetailSelect.do" />',
			success : function(result) {
				console.log(JSON.stringify(result));
				
				fnSelectDbType(result.result.dbType);
				$("#code").attr("disabled", "disabled");
				
				$("#code").val(result.result.code);
				$("#codeName").val(result.result.codeName);
				$("#codeExplanation").val(result.result.codeExplanation);
				$("input:radio[name='dbType'][value='" + result.result.dbType + "']").prop("checked", true);
				$("#dbName").val(result.result.dbName);
				$("#dbAddress").val(result.result.dbAddress);
				$("#dbID").val(result.result.dbID);
				$("#dbPW").val(result.result.dbPW);
				$("#dbCode").val(result.result.dbCode);
				$("#dbCodeName").val(result.result.dbCodeName);
				$("#outputForm").val(result.result.outputForm);
				$("#outputFormEn").val(result.result.outputFormEn);
				$("#outputFormJp").val(result.result.outputFormJp);
				$("#outputFormCn").val(result.result.outputFormCn);
				$("#searchCode").val(result.result.searchCode);
				$("#returnCode").val(result.result.returnCode);
				$("#returnCodeEn").val(result.result.returnCodeEn);
				$("#returnCodeJp").val(result.result.returnCodeJp);
				$("#returnCodeCn").val(result.result.returnCodeCn);
				$("#returnCodeOutputForm").val(result.result.returnCodeOutputForm);
				$("#returnCodeOutputFormEn").val(result.result.returnCodeOutputFormEn);
				$("#returnCodeOutputFormJp").val(result.result.returnCodeOutputFormJp);
				$("#returnCodeOutputFormCn").val(result.result.returnCodeOutputFormCn);
				$("#queryArea").val(result.result.queryArea);
				$("input:radio[name='useYN'][value='" + result.result.useYN + "']").prop("checked", true);
				$("input:radio[name='selectMode'][value='" + result.result.selectMode + "']").prop("checked", true);

				if(result.result.dbType == "3") {
					$("#popupWidthSize").val(result.result.popupWidth);
					$("#popupHeightSize").val(result.result.popupHeight);
					$("#callbackFuncName").val(result.result.callbackFunction);
					$("#url").val(result.result.url);
				}
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 상세코드 중복 확인
	function checkDetailCodeSeq(id) {
		var strReg = /^[A-Za-z0-9]+$/; 

        if (!strReg.test(id)){
			alert("<%=BizboxAMessage.getMessage("TX000017329","영문과 숫자만 입력가능합니다.")%>");
			$("#code").val("");
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
        		params.externalCodeSeq = id;
        		
	            $.ajax({
	                type: "post",
	                url : '<c:url value="/cmm/systemx/item/checkExternalCodeSeq.do" />',
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
        
	// 코드 유형 및 기본값 선택 팝업 호출
	function fnPopAlert(result) {
		var url = '<c:url value="/cmm/systemx/item/pop/ItemPopAlertView.do?"/>';
		var w = 520;
		var h = 206;
		var left = (screen.width/2)-(w/2);
		var top = (screen.height/2)-(h/2);
		  
		var pop = window.open("", "popup_window",
				"width=520,height=205, left=" + left + ", top=" + top + "");
		$("#resultMessage").val(result);
		
		checkMessage.method = "post";
		checkMessage.action = url; 
		checkMessage.submit(); 
	    pop.focus();   

	}
	
	// 필수 입력값 체크(상세코드)
	function fnSaveCheck() {
		var code = $("#code").val();
		var codeName = $("#codeName").val();
		var dbName = $("#dbName").val();
		var dbAddress = $("#dbAddress").val();
		var dbID = $("#dbID").val();
		var dbPW = $("#dbPW").val();
		var dbCode = $("#dbCode").val();
		var dbCodeName = $("#dbCodeName").val();
		var outputForm = $("#outputForm").val();
		var searchCode = $("#searchCode").val();
		var returnCode = $("#returnCode").val();
		var returnCodeOutputForm = $("#returnCodeOutputForm").val();
		var queryArea = $("#queryArea").val();
		var result = new Array(); 
		var dbType = $("input:radio[name='dbType']:checked").val();	
		
		var popupWidthSize = $("#popupWidthSize").val();
		var popupHeightSize = $("#popupHeightSize").val();
		var callbackFuncName = $("#callbackFuncName").val();
		var url = $("#url").val();
		
		
		if(dbType == "3") {
			if(popupWidthSize == "" || popupHeightSize == "") {
				result.push("<%=BizboxAMessage.getMessage("TX000019393", "팝업사이즈")%>");
				
				$("#popupWidthSize").focus();
			}
			
			if(callbackFuncName == "") {
				result.push("<%=BizboxAMessage.getMessage("TX900000022", "콜백함수명")%>");
				
				$("#callbackFuncName").focus();
			}
			
			if(url == "") {
				result.push("URL");
				
				$("#url").focus();
			}
		} else {
			if(code == "") {
				result.push("<%=BizboxAMessage.getMessage("TX000000045", "코드")%>");
				
				$("#code").focus();
			} 
			
			if(codeName == "") {
				result.push("<%=BizboxAMessage.getMessage("TX000000209", "코드명")%>");
				
				$("#codeName").focus();
			}
			
			if(dbName == "" || dbAddress == "" || dbID == "" || dbPW == "") {
				result.push("<%=BizboxAMessage.getMessage("TX900000023", "연결정보")%>DB");
				
				$("#dbName").focus();
			}
			
			
			if(dbCode == "" || dbCodeName == "" || outputForm == "" || searchCode == "" || returnCode == "" || returnCodeOutputForm == "") { 
				result.push("<%=BizboxAMessage.getMessage("TX000016724", "쿼리설정")%>")
				
				$("#dbCode").focus();
			}
			

			if(queryArea == "") {
				result.push("<%=BizboxAMessage.getMessage("TX900000024", "쿼리")%>");
				
				$("#queryArea").focus();
			}
		}
		
		return result;
	}
	
	function fnSelectDbType(id) {
		if(id == "3") {
			$(".externalSetItem").hide();
			$(".externalUrlSetItem").show();
		} else {
			$(".externalSetItem").show();
			$(".externalUrlSetItem").hide();
		}
	}

</script>

<form id="checkMessage" name="checkMessage" method="post" target="popup_window">
	<input type="hidden" id="resultMessage" name="resultMessage" value=""/>
</form>


<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX900000020", "코드/코드명")%></dt>
		<dd>
			<input id="searchExternalCodeName" class="" type="text" value="" placeholder="" style="width:162px;">
		</dd>
		<dd class="mr40"><input id="searchButton" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289", "검색")%>"/></dd>
	</dl>
	 <span class="posi_ab" style="top:19px;right:20px;"><input type="checkbox" id="isShowNotUse"/><label for="isShowNotUse"><%=BizboxAMessage.getMessage("TX000017331", "미사용포함")%></label> </span>
</div>


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	
	<div class="twinbox mt15">
		<table>
			<colgroup>
				<col style="width:35%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td p0">
					<div class="pl15 pr15 clear">
						<p class="tit_p fl mt20"><%=BizboxAMessage.getMessage("TX900000025", "코드 목록")%></p>
					</div>
					
					<!-- 테이블 -->
					<div class="com_ta2 sc_head ml15 mr15">
						<table>
							<colgroup>
								<col width=""/>
								<col width=""/>
								<col width="87"/>
							</colgroup>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000045", "코드")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000209", "코드명")%></th>
								<th><%=BizboxAMessage.getMessage("TX000016716", "사용여부")%></th>
							</tr>
						</table>
					</div>
					
					<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc2" style="height:614px;">
						<table>
							<colgroup>
								<col width=""/>
								<col width=""/>
								<col width="87"/>
							</colgroup>
							<tbody id="externalCodeList">
<!-- 
							<tr>
								<td>1536</td>
								<td>넥스트</td>
								<td>사용</td>
							</tr>
							<tr>
								<td>1536</td>
								<td>넥스트</td>
								<td>사용</td>
							</tr>
							<tr>
								<td>1536</td>
								<td>넥스트</td>
								<td>사용</td>
							</tr>
							<tr>
								<td>1536</td>
								<td>넥스트</td>
								<td>사용</td>
							</tr>
							<tr>
								<td>1536</td>
								<td>넥스트</td>
								<td>사용</td>
							</tr>
 -->
							</tbody>
						</table>	
					</div>
				</td>
				<td class="twinbox_td pt5">
					
						<div class="controll_btn fr">
							<button id="newExternalCodeButton"><%=BizboxAMessage.getMessage("TX000003101", "신규")%></button>
							<button id="saveExternalCodeButton"><%=BizboxAMessage.getMessage("TX000005666", "저장")%></button>
							<button id="deleteExternalCodeButton"><%=BizboxAMessage.getMessage("TX000005668", "삭제")%></button>
						</div>
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="100"/>
								<col width="80"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th colspan="2"><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000045", "코드")%></th>
								<td>
									<input type="text" class="fl" id="code" style="width:162px" placeholder="<%=BizboxAMessage.getMessage("TX000017333","영문/숫자만 입력가능")%>" onkeyup="checkDetailCodeSeq(this.value);" />
									<p id="info" class="fl text_blue f11 mt5 ml10"></p>
								</td>
							</tr>
							<tr>
								<th colspan="2"><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000209", "코드명")%></th>
								<td><input type="text" id="codeName" style="width:90%" /></td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000018158", "설명")%></th>
								<td><input type="text" id="codeExplanation" style="width:90%" /></td>
							</tr>
							<tr>
								<th colspan="2">DBMS</th>
								<td>
									<input type="radio" name="dbType" id="maria" class="" value="0" checked="checked" /><label for="maria">Maria</label>
									<input type="radio" name="dbType" id="oracle" class="mr10" value="1" /><label for="oracle">Oracle</label>
									<input type="radio" name="dbType" id="mssql" class="mr10" value="2" /><label for="mssql">MSSQL</label>
									<input type="radio" name="dbType" id="url" class="mr10" value="3" /><label for="url">Custom</label>
								</td>
							</tr>
							<tr class="">
								<th rowspan="4"><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX900000026", "DB연결정보")%></th>
								<th>DB</th>
								<td><input type="text" id="dbName" style="width:90%" /></td>
							</tr>
							<tr class="">
								<th>IP</th>
								<td><input type="text" id="dbAddress" style="width:90%" /></td>
							</tr>
							<tr class="">
								<th>ID</th>
								<td><input type="text" id="dbID" style="width:90%" /></td>
							</tr>
							<tr class="">
								<th>PW</th>
								<td><input autocomplete="new-password" type="password" id="dbPW" style="width:90%" /></td>
							</tr>
							<tr class="externalSetItem">
								<th rowspan="6"><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000016724", "쿼리설정")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000045", "코드")%></th>
								<td><input type="text" id="dbCode" style="width:90%" placeholder="Code, name" /></td>
							</tr>
							<tr class="externalSetItem"> 
								<th><%=BizboxAMessage.getMessage("TX000000152", "명칭")%></th>
								<td><input type="text" id="dbCodeName" style="width:90%" placeholder="<%=BizboxAMessage.getMessage("TX000000045", "코드")%>, <%=BizboxAMessage.getMessage("TX000000152", "명칭")%>"/></td>
							</tr>
							<tr class="externalSetItem">
								<th><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%></th>
								<td><input type="text" id="outputForm" style="width:90%"  placeholder="▥code▥(▥name▥)"/> <br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%><br/>(<%=BizboxAMessage.getMessage("TX000002790", "영어")%>)</th>
								<td><input type="text" id="outputFormEn" style="width:90%"  placeholder="▥code▥(▥name▥)"/> <br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%><br/>(<%=BizboxAMessage.getMessage("TX000002788", "일본어")%>)</th>
								<td><input type="text" id="outputFormJp" style="width:90%"  placeholder="▥code▥(▥name▥)"/> <br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%><br/>(<%=BizboxAMessage.getMessage("TX000002789", "중국어")%>)</th>
								<td><input type="text" id="outputFormCn" style="width:90%"  placeholder="▥code▥(▥name▥)"/> <br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem">
								<th><%=BizboxAMessage.getMessage("TX900000028", "검색코드")%></th>
								<td><input type="text" id="searchCode" style="width:90%" placeholder="Code, name" /></td>
							</tr>
							<tr class="externalSetItem">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%></th>
								<td><input type="text" id="returnCode" style="width:90%" placeholder="Code" /></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%><br/>(<%=BizboxAMessage.getMessage("TX000002790", "영어")%>)</th>
								<td><input type="text" id="returnCodeEn" style="width:90%" placeholder="Code" /></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%><br/>(<%=BizboxAMessage.getMessage("TX000002788", "일본어")%>)</th>
								<td><input type="text" id="returnCodeJp" style="width:90%" placeholder="Code" /></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%><br/>(<%=BizboxAMessage.getMessage("TX000002789", "중국어")%>)</th>
								<td><input type="text" id="returnCodeCn" style="width:90%" placeholder="Code" /></td>
							</tr>
							<tr class="externalSetItem">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%><br><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%></th>
								<td><input type="text" id="returnCodeOutputForm" style="width:90%" placeholder="▥code▥(▥name▥)" /><br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%><br><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%><br/>(<%=BizboxAMessage.getMessage("TX000002790", "영어")%>)</th>
								<td><input type="text" id="returnCodeOutputFormEn" style="width:90%" placeholder="▥code▥(▥name▥)" /><br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%><br><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%><br/>(<%=BizboxAMessage.getMessage("TX000002788", "일본어")%>)</th>
								<td><input type="text" id="returnCodeOutputFormJp" style="width:90%" placeholder="▥code▥(▥name▥)" /><br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem hidden-multi-lang">
								<th><%=BizboxAMessage.getMessage("TX900000029", "반환코드")%><br><%=BizboxAMessage.getMessage("TX000003338", "출력형태")%><br/>(<%=BizboxAMessage.getMessage("TX000002789", "중국어")%>)</th>
								<td><input type="text" id="returnCodeOutputFormCn" style="width:90%" placeholder="▥code▥(▥name▥)" /><br /><span class="text_blue dp_ib mt10 mb10"><%=BizboxAMessage.getMessage("TX900000027", "▥사이의 문자가 문서양식에 표현됩니다.")%></span></td>
							</tr>
							<tr class="externalSetItem">
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000017334", "멀티선택")%></th>
								<td>
									<input type="radio" name="selectMode" id="multi" class="" value="m" checked="checked" /><label for="multi"><%=BizboxAMessage.getMessage("TX900000030", "멀티")%></label>
									<input type="radio" name="selectMode" id="single" class="mr10" value="s" /><label for="single"><%=BizboxAMessage.getMessage("TX900000031", "싱글")%></label>
								</td>
							</tr>
							<tr class="externalUrlSetItem">
								<th rowspan="2"><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000019393", "팝업사이즈")%></th>
								<th><%=BizboxAMessage.getMessage("TX000016738", "가로")%></th>
								<td><input type="text" id="popupWidthSize" style="width:90%" /></td>
							</tr>
							<tr class="externalUrlSetItem"> 
								<th><%=BizboxAMessage.getMessage("TX000016739", "세로")%></th>
								<td><input type="text" id="popupHeightSize" style="width:90%" /></td>
							</tr>
							<tr class="externalUrlSetItem">
								<th colspan="2"><%=BizboxAMessage.getMessage("TX900000022", "콜백함수명")%></th>
								<td><input type="text" id="callbackFuncName" style="width:90%" /></td>
							</tr>
							<tr class="externalUrlSetItem">
								<th colspan="2"><%=BizboxAMessage.getMessage("TX900000032", "호출 URL")%></th>
								<td><input type="text" id="url" style="width:90%" /></td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000000028", "사용여부")%></th>
								<td>
									<input type="radio" name="useYN" id="useY" class="" value="Y" checked="checked" /><label for="useY"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
									<input type="radio" name="useYN" id="useN" class="mr10" value="N" /><label for="useN"><%=BizboxAMessage.getMessage("TX000001243", "사용")%></label>
								</td>
							</tr>
						</table>
					</div>
					<div class="txt_div externalSetItem">
						<p class="pt10 pb10"><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX900000033", "쿼리 : 검색코드는 ▥로 따로 감싸야합니다.")%> <span class="ml10 text_blue">ex) Where aa = ‘▥code▥’</span></p>
						<textarea id="queryArea" style="width:98%; padding:1%;height:120px;"></textarea>
					
					</div>
				</td>
			</tr>
		</table>
	</div>
	
</div><!-- //sub_contents_wrap -->					
</div><!-- iframe wrap -->
</div><!-- //sub_contents -->