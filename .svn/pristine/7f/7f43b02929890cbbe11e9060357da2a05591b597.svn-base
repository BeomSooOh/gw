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
	var newButtonFlag = true;			// 신규버튼 눌렀을 때 1로 변환

	$(document).ready( function() {
		//기본버튼
		$(".controll_btn button").kendoButton();

		//사용여부 셀렉트박스
		$("#bankUseYN").kendoComboBox();

		// 거래처 리스트 가져오기
		fnAccountSelectBoxData();
		
		// 계좌 목록 리스트 데이터 가져오기
		fnAccountListData();

		// 버튼 이벤트 정의
		fnButtonInit();
	});
	
	// 거래처 목록 가져오기
	function fnAccountSelectBoxData() {
		var param = {};
		
		$.ajax({
			type: "POST"
			, contentType: "application/json; charset=utf-8"
			, url:  "<c:url value='/api/account/web/CBCodeList' />"
			, data: JSON.stringify(param)
			, success: function(result) {
				//alert(JSON.stringify(result.result.cbCodeList));
				
				var cbCodeList = result.result.cbCodeList;
				//거래처 셀렉트박스
				$("#accountSelect").kendoComboBox({
					dataSource : cbCodeList,
					dataTextField : "cbName",
					dataValueField : "cbCode",
					index : 0
				});
			}
			, error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
			}
		});
	}
	
	// 계좌 목록 리스트 데이터 가져오기
	function fnAccountListData() {
		var param = {};
		param.cbName = $("#accountSearch").val();
		param.cbNo = $("#accountNumSearch").val();
		param.useYn = $("#bankUseYN").val();
		
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url:  "<c:url value='/api/account/web/AccountList' />"
				, data: JSON.stringify(param)
				, success: function(result) {
					//alert(JSON.stringify(result));
					var accountData = result.result.accountList;
					fnAccountListGrid(accountData);
				}
				, error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
		});
	}
	
// 	function fnAccountListData() {
// 		accountData = new kendo.data.DataSource({
// 			serverPaging : true,
// 			transport : {
// 				read : {
// 					type : "post",
// 					dataType: "json",
// 					url : "<c:url value='/api/account/web/AccountList' />" 
// 				},
// 				parameterMap : function(data, operation) {
// 					data.cbName = "";
// 					data.cbNo = "";
// 					data.useYn = "";
// 					var test = {};
// 					test.data = data;
// 					return test;
// 				}
// 			},
// 			schema : {
// 				data : function(response) {
// 					console.log(JSON.stringify(response.accountList));
// 					alert(response.accountList);
// 					return response.accountList;
// 				},
// 				total : function(resposne) {
// 					return response.totalCount;
// 				}
// 			}
// 		});
// 		//alert(JSON.stringify(accountData));
// 		// 계좌 목록 리스트 그려주기
// 		fnAccountListGrid();
// 	}
	
	// 계좌 목록 리스트 그려주기
	function fnAccountListGrid(accountData) {
		$("#accountList").kendoGrid({
			dataSource : accountData,
			height : 295,
			selectable : "single",
			groupable : false,
			columnMenu : false,
			editable : false,
			sortable : true,
			pageable : false,
			columns : [
		           {
			        	field : "<%=BizboxAMessage.getMessage("TX000000265","선택")%>",
			        	width : 40,
			        	headerTemplate : '<input type="checkbox" name="inp_chk" id="grid_all_chk" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="grid_all_chk"></label>',
			        	headerAttributes : {
							style : "text-align:center;vertical-align:middle;"
						},
						template : '<input type="checkbox" name="inp_chk" id="#= accountSeq #" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="#= accountSeq #"></label>',
						attribute : {
							style : "text-align:center;vertical-align:middle;"
						}, 
						sortable : false
		           },
		           {
		        	   title : "<%=BizboxAMessage.getMessage("TX000000520","거래처")%>",
		        	   template : function(data) {
		        		   return data.cbName;
		        	   },
		        	   headerAttributes : {
		        		   style : "text-align: center;"
		        	   },
		        	   attributes : {
		        		   style : "text-align: center;"
		        	   }
		           },
		           {
		        	   title : "<%=BizboxAMessage.getMessage("TX000003620","계좌번호")%>",
		        	   template : function(data) {
		        		   return data.cbNo;
		        	   },
		        	   headerAttributes : {
		        		   style : "text-align: center;"
		        	   },
		        	   attributes : {
		        		   style : "text-align: center;"
		        	   }
		           },
		           {
		        	   title : "<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>",
		        	   template : function(data) {
		        		   return data.useYn;
		        	   },
		        	   headerAttributes : {
		        		   style : "text-align: center;"
		        	   },
		        	   attributes : {
		        		   style : "text-align: center;"
		        	   }
		           }
           ],
			dataBound: function(e){ 
				$("#accountList tr[data-uid]").css("cursor","pointer").click(function () {
					$("#accountList tr[data-uid]").removeClass("k-state-selected");
					$(this).addClass("k-state-selected");
					
					//선택 item
					var selectedItem = e.sender.dataItem(e.sender.select());
					
					//데이타 조회 fucntion 호출
					accountSeq = selectedItem.accountSeq;
					newButtonFlag = false;					
					fnAccountInfoGrid(selectedItem);
		            });							
			}		
		});
	}
	
	// 계좌 정보 그려주기
	function fnAccountInfoGrid(data) {
//		alert(JSON.stringify(data));
		
		var serviceDivision = data.svType;			// 서비스 구분
		var lookUpDivision = data.scType;			// 조회 구분
		var accountCode = data.cbCode; 			// 거래처 
		var accountNum = data.cbNo;				// 계좌번호
		var accountPW = data.cbPw;				// 비밀번호
		var loginID	= data.cbLoginId;				// 로그인 ID
		var loginPW = data.cbLoginPw;			// 로그인 PW
		var useYn = data.useYn;						// 사용여부
		
		$("input[name=serviceDivision]").val([serviceDivision]);		// 서비스 구분 값 
		$("input[name=lookUpDivision]").val([lookUpDivision]);		// 조회 구분 값 
		$("#accountSelect").data("kendoComboBox").value(accountCode);		// 거래처 값
		$("#accountNum").val(accountNum);									// 계좌번호 값
		$("#accountPW").val(accountPW);										// 비밀번호 값
		$("#loginID").val(loginID);												// 로그인 ID 값
		$("#loginPW").val(loginPW);												// 로그인 PW 값
		$("input[name=accountUseYN]").val([useYn]);						// 사용여부 값
	}
	
	// 버튼 이벤트 정의
	function fnButtonInit() {
		// 신규 버튼
		$("#newButton").click(function(){
			fnNewButton();
		});
		
		// 저장 버튼
		$("#saveButton").click(function(){
			fnSaveButton();
		});
		
		// 삭제 버튼
		$("#removeButton").click(function(){
			fnRemoveButton();
		});
		
		// 검색 버튼
		$("#searchButton").click(function(){
			fnAccountListData();
		}) ;
	}
	
	// 신규버튼 
	function fnNewButton() {
		newButtonFlag = true;		// 신규 등록을 위한 accountSeq값 초기화
		accountSeq = "";
		$("input[name=serviceDivision]").val(["1"]);		// 서비스 구분 값 
		$("input[name=lookUpDivision]").val(["1"]);		// 조회 구분 값 
		$("#accountSelect").data("kendoComboBox").value("002");
		$("#accountNum").val("");								// 계좌번호 값
		$("#accountPW").val("");									// 비밀번호 값
		$("#loginID").val("");											// 로그인 ID 값
		$("#loginPW").val("");											// 로그인 PW 값
		$("input[name=accountUseYN]").val(["Y"]);					// 사용여부 값
	
		// row selected 된거 삭제	
		var grid = $("#accountList").data("kendoGrid");
		grid.dataItem(grid.tbody.find("tr").attr("class", ""));
	}
	
	// 저장버튼
	function fnSaveButton() {									
		var param = {};
		
		// 유효성 체크	
		if($("#accountNum").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010810","계좌번호는 필수입니다")%>");
			$("#accountNum").focus();
			return;
		}
		
		if($("#accountPW").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010810","계좌번호는 필수입니다")%>");
			$("#accountPW").focus();
			return;
		}
		
		if($("#loginIDRow").css("display") !== "none" && $("#loginID").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000010808","로그인 아이디는 필수입니다")%>");
			$("#loginID").focus();
			return;
		}
		
		if($("#loginPWRow").css("display") !== "none" && $("#loginPW").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010807","로그인 패스워드는 필수입니다")%>");
			$("#loginPW").focus();
			return;
		}
		
		
		if($("input[name=lookUpDivision]:checked").val() == "3" && $("input[name=serviceDivision]:checked").val() == "1" && $("#personNum").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010806","주민등록번호는 필수입니다")%>");
			$("#personInfoNum").focus();
			return;
		}
		
		if($("input[name=lookUpDivision]:checked").val() == "3" && $("input[name=serviceDivision]:checked").val() != "1" && $("#companyInfoNum").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010805","사업자번호는 필수입니다")%>");
			$("#companyInfoNum").focus();
			return;
		}
	
		if(newButtonFlag) {			// 신규 저장 
			param.accountSeq = "";
		} else {										// 수정
			param.accountSeq = accountSeq;
		}
		param.svType = $("input[name=serviceDivision]:checked").val();		// 서비스 구분 값
		param.scType = $("input[name=lookUpDivision]:checked").val();		// 조회 구분 값
		param.cbCode = $("#accountSelect").val();							// 거래처 코드 값
		param.cbNo = $("#accountNum").val();								// 계좌번호 값
		param.cbPw = $("#accountPW").val();								// 비밀번호 값
		param.cbLoginId = $("#loginID").val();								// 로그인 ID 값
		param.cbLoginPw = $("#loginPW").val();							// 로그인 PW 값
		param.idnNo = "";															// 주민등록/사업자번호 값
		param.useYn = $("input[name=accountUseYN]:checked").val();			// 사용여부 값
		
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url:  "<c:url value='/api/account/web/AccountAdd' />"
				, data: JSON.stringify(param)
				, success: function(result) {
					//alert(JSON.stringify(result));
					if(result.resultCode=="0") {
						alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
						
						newButtonFlag = true;		// 신규 등록을 위한 accountSeq값 초기화
						accountSeq = "";
						$("input[name=serviceDivision]").val(["1"]);		// 서비스 구분 값 
						$("input[name=lookUpDivision]").val(["1"]);		// 조회 구분 값 
						$("#accountSelect").data("kendoComboBox").value("002");
						$("#accountNum").val("");								// 계좌번호 값
						$("#accountPW").val("");									// 비밀번호 값
						$("#loginID").val("");											// 로그인 ID 값
						$("#loginPW").val("");											// 로그인 PW 값
						$("input[name=accountUseYN]").val(["Y"]);					// 사용여부 값
						
						fnAccountListData();
					} else {
						alert(result.resultMessage);
					}
					
				}
				, error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
		});
	}
	
	// 삭제버튼
	function fnRemoveButton() {
		var param = {};
		if(newButtonFlag) {
			alert("<%=BizboxAMessage.getMessage("TX000010804","삭제할 계좌를 선택해주세요")%>");
			return;
		} else {
			param.accountSeq = accountSeq;
		}
		
		if(!confirm("<%=BizboxAMessage.getMessage("TX000015635","정말 삭제하시겠습니까?")%>")) {
			return;			
		}
		
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url:  "<c:url value='/api/account/web/AccountDel' />"
				, data: JSON.stringify(param)
				, success: function(result) {
					//alert(JSON.stringify(result));
					if(result.resultCode == "0") {
						alert("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>");
						
						newButtonFlag = true;		// 신규 등록을 위한 accountSeq값 초기화
						accountSeq = "";
						$("input[name=serviceDivision]").val(["1"]);		// 서비스 구분 값 
						$("input[name=lookUpDivision]").val(["1"]);		// 조회 구분 값 
						$("#accountSelect").data("kendoComboBox").value("002");
						$("#accountNum").val("");								// 계좌번호 값
						$("#accountPW").val("");									// 비밀번호 값
						$("#loginID").val("");											// 로그인 ID 값
						$("#loginPW").val("");											// 로그인 PW 값
						$("input[name=accountUseYN]").val(["Y"]);					// 사용여부 값
						
						// row selected 된거 삭제	
						var grid = $("#accountList").data("kendoGrid");
						grid.dataItem(grid.tbody.find("tr").attr("class", ""));
						
						fnAccountListData();
						
					} else {
						alert(result.resultMessage);
					}
				}
				, error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
		});
	}
	
	// 선택값에 따른 메뉴 선택
	function fnMenuShowHide() {
		if($("input[name=serviceDivision]:checked").val() == "1" && $("input[name=lookUpDivision]:checked").val() =="3"){
			$("#loginIDRow").hide();
			$("#loginPWRow").hide();
			$("#companyInfoNum").hide();
			$("#personInfoNum").show();
		} else if($("input[name=serviceDivision]:checked").val() == "4" && $("input[name=lookUpDivision]:checked").val() =="3") {
			$("#loginIDRow").hide();
			$("#loginPWRow").hide();
			$("#personInfoNum").hide();
			$("#companyInfoNum").show();
		} else {
			$("#loginIDRow").show();
			$("#loginPWRow").show();
			$("#personInfoNum").hide();
			$("#companyInfoNum").hide();	
		}
	}
</script>



<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<!-- 검색박스 -->
	<div class="top_box">
		<dl>
			<dt class="ar" style="width: 68px;"><%=BizboxAMessage.getMessage("TX000000520","거래처")%></dt>
			<dd>
				<input type="text" id="accountSearch"style="width: 150px" />
			</dd>

			<dt class="ar en_w105" style="width: 68px;"><%=BizboxAMessage.getMessage("TX000003620","계좌번호")%></dt>
			<dd>
				<input type="text" id="accountNumSearch" class="kendoComboBox" style="width: 150px" />
			</dd>

			<dt class="ar" style="width: 68px;"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
			<dd>
				<!-- <input id="sel_bank" class="kendoComboBox" style="width: 150px" /> -->
				<select id="bankUseYN" class="kendoComboBox" style="width: 150px">
					<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
					<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
					<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
				</select>
			</dd>

			<dd>
				<input id="searchButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
			</dd>
		</dl>
	</div>

	<div class="btn_div m0">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				<button id="newButton"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
				<button id="saveButton"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
				<button id="removeButton"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>
	</div>

	<div class="twinbox">
		<table style="min-height: auto;">
			<colgroup>
				<col width="50%" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<!-- 그리드 리스트 -->
					<div id="accountList"></div>
				</td>
				<td class="twinbox_td">
					<div class="com_ta">
						<table>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000015690","서비스구분")%></th>
								<td>
									<input type="radio" name="serviceDivision" id="personal" class="k-radio" value="1" checked="checked" onchange="fnMenuShowHide()"/>
									<label class="k-radio-label radioSel" for="personal"><%=BizboxAMessage.getMessage("TX000002835","개인")%></label> 
									<input type="radio" name="serviceDivision" id="enterprise" class="k-radio" value="4"  onchange="fnMenuShowHide()"/>
									<label class="k-radio-label radioSel ml10" for="enterprise"><%=BizboxAMessage.getMessage("TX000015706","기업")%></label>
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000854","조회구분")%></th>
								<td>
									<input type="radio" name="lookUpDivision" id="lookUpID" class="k-radio" checked="checked" value="1" onchange="fnMenuShowHide()"/> 
									<label class="k-radio-label radioSel" for="lookUpID"><%=BizboxAMessage.getMessage("TX000015683","아이디조회")%></label> 
									<input type="radio" name="lookUpDivision" id="lookUpSpeed" class="k-radio" value="3" onchange="fnMenuShowHide()"/> 
									<label class="k-radio-label radioSel ml10" for="lookUpSpeed"><%=BizboxAMessage.getMessage("TX000015682","빠른조회")%></label>
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000520","거래처")%></th>
								<td><input id="accountSelect" style="width: 150xp;" /></td>
							</tr>
							<tr>
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000003620","계좌번호")%></th>
								<td><input type="text" id="accountNum" style="width: 200px;" /></td>
							</tr>
							<tr>
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000000077","비밀번호")%></th>
								<td><input autocomplete="new-password" type="password" id="accountPW" style="width: 200px;" /></td>
							</tr>
							<tr id="loginIDRow">
								<th>
									<img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000000133","로그인ID")%>
								</th>
								<td>
									<input type="text" id="loginID" style="width: 200px;" />
								</td>
							</tr>
							<tr id="loginPWRow">
								<th><img src="../../../Images/ico/ico_check01.png" alt="" />
									<%=BizboxAMessage.getMessage("TX000015684","로그인PW")%></th>
								<td><input autocomplete="new-password" type="password" id="loginPW" style="width: 200px;" /></td>
							</tr>
							<tr id="personInfoNum" style="display:none">
								<th><img src="../../../Images/ico/ico_check01.png" alt="" /><%=BizboxAMessage.getMessage("TX000002814","주민등록번호")%></th>
								<td><input autocomplete="new-password" type="password" id="personNum" style="width: 200px;" /></td>
							</tr>
							<tr id="companyInfoNum" style="display:none">
								<th><img src="../../../Images/ico/ico_check01.png" alt="" /><%=BizboxAMessage.getMessage("TX000000024","사업자번호")%></th>
								<td><input autocomplete="new-password" type="password" id="companyNum" style="width: 200px;" /></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td>
									<input type="radio" name="accountUseYN" id="accountUseY" value="Y" class="k-radio" checked="checked" /> 
									<label class="k-radio-label radioSel" for="accountUseY"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label> 
									<input type="radio" name="accountUseYN" id="accountUseN" value="N" class="k-radio" />
									<label class="k-radio-label radioSel ml10" for="accountUseN"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- //sub_contents_wrap -->

