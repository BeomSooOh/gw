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

	var faxSeq;
	var agentId;
	var agentKey;
	var clickFlag = false;
	var smsCompSeqList;
	
	$(document).ready(function() {
		//기본버튼
		$(".controll_btn button").kendoButton();

		// 팩스 연동 목록 조회
		fnGetFaxList();

		// 버튼 초기화 함수
		fnButtonInit();

		//사용여부 셀렉트박스
		$("#use_sel").kendoComboBox();

		//번호소멸 
		$("tr.extinction td").addClass('text_gray2');

		$("#faxDetail").hide();
		$("#pointBox").hide();

	});

	// 팩스 연동 목록 조회
	function fnGetFaxList() {
		var param = {};

 		param.bill36524Id = $("#btnText").val();
 		param.useYn = $("#use_sel").val();
		
		$.ajax({
			type : "POST",
			contentType : "application/json; charset=utf-8",
			url : "<c:url value='/api/fax/web/master/FaxList '/>",
			data : JSON.stringify(param),
			dataType : "json",
			success : function(result) {
				if(result.resultCode == "0") {
					fnTableGrid(result.result.faxList);
				} else {
					alert(result.resultMessage);
				}
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});

	}

	function fnButtonInit() {
		// 검색 버튼
		$("#searchButton, #searchImgButton").click(function() {
			fnSearchList();
		});

		// 추가 버튼 
		$("#addButton").click(function() {
			fnAddButton();
		});

		// 제거 버튼
		$("#removeButton").click(function() {
			fnRemoveButton();
		});

		// 저장 버튼		
		$("#saveButton").click(function() {
			fnSaveButton();
		});

		// 충전 버튼
		$("#faxCharge").click(function() {
			fnFaxCharge();
		});

		// 갱신 버튼
		$("#faxRefresh").click(function() {
			fnFaxRefresh();
		});

		// 요금안내 버튼
		$("#faxChargeInfo").click(function() {
			fnFaxChargeInfo();
		});
		
		// 서비스 연장 버튼
		$("#faxServiceExtension").click(function(){
			fnFaxServiceExtension();
		});
		
		// 회원가입 버튼
		$("#faxRegisterPage").click(function() {
			fnFaxRegisterPage();
		});
		
		// SMS 회사 선택 버튼
		$("#useSMSCompanySelect").click(function(){
			fnPopSMSCompanySelect();
		});
	}

	// 검색 버튼
	function fnSearchList() {
		fnGetFaxList();
	}

	// 추가 버튼 이벤트
	function fnAddButton() {
		$("#faxID").val("");
		$("#faxPW").val("");
		$("#useSMSCompany").val("");
		
		$("#pointBox").hide();
		$("#faxDetail").hide();

		$("#faxID").attr("disabled", false);
		$("#faxPW").attr("disabled", false);

	}

	// 삭제 버튼 이벤트
	function fnRemoveButton() {
		var removeParam = {};

		removeParam.faxSeq = faxSeq;

		if(!confirm("<%=BizboxAMessage.getMessage("TX000010908","선택한 팩스연동 정보를 삭제 하시겠습니까? 삭제 시 해당 계정 내 팩스번호 연결설정이 초기화 됩니다")%>")) {
			return;
		}
		
		$.ajax({
			type : "POST",
			contentType : "application/json; charset=utf-8",
			url : "<c:url value='/api/fax/web/master/FaxDel '/>",
			data : JSON.stringify(removeParam),
			dataType : "json",
			success : function(result) {
				if(result.resultCode == "0") {
					alert("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>");	
					
					// 번호목록 숨기기
					$("#faxDetail").hide();
					$("#pointBox").hide();
					
					$("#faxID").val('');
					$("#faxPW").val('');
					
					fnGetFaxList();
				} else {
					alert(result.resultMessage);
				}
				
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 저장 버튼 
	function fnSaveButton() { 
		var saveParam = {};

		var useYN = '';

		if ($("#faxUse").is(":checked") == true) {
			useYN = "Y";
		} else {
			useYN = "N";
		}

		saveParam.faxSeq = faxSeq;
		saveParam.bill36524Id = $("#faxID").val();
		saveParam.bill36524Pwd = $("#faxPW").val();
		saveParam.smsCompParams = smsCompParams;
		saveParam.useYn = useYN;


		if ($("#faxID").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010906","팩스 아이디를 입력해주세요")%>");
			$("#faxID").focus();
			return;
		}

		if ($("#faxPW").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010905","팩스 비밀번호를 입력해주세요")%>");
			$("#faxPW").focus();
			return;
		}

		$.ajax({
			type : "POST",
			contentType : "application/json; charset=utf-8",
			url : "<c:url value='/api/fax/web/master/FaxAdd '/>",
			data : JSON.stringify(saveParam),
			dataType : "json",
			success : function(result) {
				console.log(JSON.stringify(result));
				if(result.resultCode == "0"){
					alert('<%=BizboxAMessage.getMessage("TX000002120","저장 되었습니다.")%>');
					fnGetFaxList();
				} else {
					alert(result.resultMessage);
				}
				
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 갱신 버튼
	function fnFaxRefresh() {
		var param = {};

		param.faxSeq = faxSeq;

		$.ajax({
			type : "POST",
			contentType : "application/json; charset=utf-8",
			async : false,
			url : "<c:url value='/api/fax/web/master/Refresh '/>",
			dataType : "json",
			data : JSON.stringify(param),
			success : function(result) {
				if(result.resultCode =="0") {
					alert("<%=BizboxAMessage.getMessage("TX000010904","팩스 정보가 갱신되었습니다")%>");
				} else {
					alert(result.resultMessage);
				}
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 요금 안내 버튼 
	function fnFaxChargeInfo() {
		var popFaxChargeInfo = $("#popFaxChargeInfo");
		var url = "<c:url value='/api/fax/web/master/popFaxChargeInfo'/>";

		popFaxChargeInfo.kendoWindow({
			iframe : true,
			draggable : false,
			width : "598px",
			height : "270px",
			title : "<%=BizboxAMessage.getMessage("TX000010903","요금안내")%>",
			visible : false,
			content : {
				url : url,
				type : "GET"
			},
			action : [ "Pin", "Minimize", "Maximize", "Close" ]
		}).data("kendoWindow").center().open();
	}

	// 팩스연동 아이디 및 사용여부 리스트 조회
	function fnTableGrid(dataResult) {
		$("#grid").kendoGrid({
			dataSource : dataResult,
			sortable : true,
			selectable : "single",
			navigatable : true,
			pageable : false,
			scrollable : true,
			columnMenu : false,
			autoBind : true,
			columns : [ {
				title : "<%=BizboxAMessage.getMessage("TX000010902","팩스아이디")%>",
				template : function(data) {
					return data.bill36524Id;
				},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				}
			}, {
				title : "<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>",
				template : function(data) {
					if (data.useYn == "Y") {
						return "<%=BizboxAMessage.getMessage("TX000000180","사용")%>";
					} else {
						return "<%=BizboxAMessage.getMessage("TX000001243","미사용")%>";
					}
				},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				}
			}, {
				title : "faxSeq",
				template : function(data) {
					return data.faxSeq;
				},
				hidden : true
			},
			{
				title : "agentId",
				template : function(data) {
					return data.agentIdEncode;
				},
				hidden : true
			},
			{
				title : "agentKey",
				template : function(data) {
					return data.agentKey;
				},
				hidden : true
			}],
			dataBound: function(e){ 
				$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
					$("#grid tr[data-uid]").removeClass("k-state-selected");
					$(this).addClass("k-state-selected");
					
					//선택 item
					var selectedItem = e.sender.dataItem(e.sender.select());
					
					//데이타 조회 fucntion 호출
					fnRowClick(selectedItem);
		            });							
			}			
		});
	}

	function fnRowClick(selectedItem) {
		clickFlag = true;
		faxSeq = selectedItem.faxSeq;
		agentId = selectedItem.agentIdEncode;
		agentKey = selectedItem.agentKey;

		$("#faxID").attr("disabled", true);
		$("#faxPW").attr("disabled", true);

		var param = {};

		param.faxSeq = faxSeq;

		//  팩스 아이디/팩스 비밀번호/사용 여부 가져오기
		$.ajax({
			type : "POST"
			,
			async : false,
			url : "<c:url value='/api/fax/web/master/getFaxInfo '/>",
			dataType : "json",
			data : param,
			success : function(result) {
				var data = result.faxInfo.faxInfo[0];
				var id = data.bill36524_id;
				var pw = data.bill36524_pwd;
				var useYN = data.use_yn;
				var point = data.point;
				var pointDigit = point.toString().replace(
						/\B(?=(\d{3})+(?!\d))/g, ","); // 세자리 마다 , 정규식
				var pointDisplay = "Point : " + pointDigit;

				$("#faxID").val(id);
				$("#faxPW").val(pw);

				if (useYN == "Y") {
					$("#faxUse").attr("checked", true);
					$("#faxNotUse").attr("checked", false);
				} else {
					
					$("#faxNotUse").attr("checked", true);
					$("#faxUse").attr("checked", false);
				}
				$("#useSMSCompany").val(data.smsComp);
				$("#faxDetail").show();
				$("#pointBox").show();
				$("#point").html(pointDisplay);
				
				smsCompSeqList = data.smsCompSeq;
				var smsData = data.smsCompSeq.split("|");

				var compInfoArray = new Array();
				for(var i=0; i<smsData.length; i++) {
					var compInfo = {};
					compInfo.compSeq = smsData[i];
					compInfo.sms_id = $("#faxID").val();
					
					compInfoArray.push(compInfo);
				}
				
				smsCompParams.compInfoArray = compInfoArray;
				smsCompParams.compInfoArray = JSON.stringify(compInfoArray);
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});

		// 포인트, 팩스번호 목록 가져오기
		$.ajax({
			type : "POST",
			contentType : "application/json; charset=utf-8",
			url : "<c:url value='/api/fax/web/master/FaxNoList '/>",
			data : JSON.stringify(param),
			dataType : "json",
			success : function(result) {
				var faxNoListData = result.result.faxNoList;

				fnFaxNoListGrid(faxNoListData);

			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 팩스 연동 번호 목록
	function fnFaxNoListGrid(data) {
		var tag = '';

		for (var i = 0; i < data.length; i++) {
			tag += '<tr>';
			tag += '   <td>' + (i + 1) + '</td>';
			tag += '   <td>' + data[i].faxNo.replace(/(^050.{1}|^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3" ) + '</td>';

			if (data[i].syncYn == "Y") {
				tag += '<td><%=BizboxAMessage.getMessage("TX000006520","설정")%></td>';
			} else {
				tag += '<td><%=BizboxAMessage.getMessage("TX000010915","미설정")%></td>';
			}

			tag += '<td>' + data[i].useBeginDate + ' ~ ' + data[i].useEndDate
					+ '</td>';

			if (data[i].status == "A") {
				tag += '<td><%=BizboxAMessage.getMessage("TX000001464","사용중")%></td>';
			} else if (data[i].status == "B") {
				tag += '<td><span class="text_red"><%=BizboxAMessage.getMessage("TX000010913","종료임박")%></span></td>';
			} else if (data[i].status == "C") {
				tag += '<td><%=BizboxAMessage.getMessage("TX000010912","기간종료")%></td>';
			} else {
				tag += '<td class="destoryNo"><%=BizboxAMessage.getMessage("TX000010911","번호소멸")%></td>';
			}
			tag += '</tr>';
		}

		$("#faxNoList").html(tag);
		
		$(".destoryNo").closest("tr").attr("class", "extinction");
	}
	
	// 충전 버튼 클릭 이벤트
	function fnFaxCharge() {
		
		var id=agentId.toString();
		var key = agentKey.toString();
		window.open('http://bizboxweb.cloudfax.co.kr/BizBoxWebFax/Bill36524PointManager.aspx?AgentID='+ id + '&agentKey=' + key, "<%=BizboxAMessage.getMessage("TX000016108","충전")%>", "height=660, width=805");
	}
	
	// 서비스연장 버튼 클릭 이벤트
	function fnFaxServiceExtension() {
	
		var id=agentId.toString();
		var key = agentKey.toString();
		
		window.open('http://bizboxweb.cloudfax.co.kr/BizBoxWebFax/Bill36524ReceiveFaxMng.aspx?AgentID='+ id + '&agentKey=' + key, "<%=BizboxAMessage.getMessage("TX000016202","서비스연장")%>","height=660, width=805");
		
	}
	
	// 회원가입 버튼 클릭 이벤트
	function fnFaxRegisterPage() {
		window.open("https://www.bill36524.com/BillRegistUser.jsp?CType=AP", "bill365회원가입", "width=800, height=850, toolbar=no, menubar=no, scrollbars=yes, resizable=yes");
	}
	
	// SMS 회사 선택 클릭 이벤트
	function fnPopSMSCompanySelect() {
		var smsId = '';
		
		if($("#faxID").val() == "") {
			alert("아이디를 클릭해주세요.");
			return;
		} else {
			smsId = $("#faxID").val();
		}
		
		var url = "popSMSCompanySelect.do?smsCompSeqList=" + smsCompSeqList;
	    var pop = window.open(url, "groupAddPop", "width=395,height=565");
	}
	
	var smsCompParams = {};
	function fnCallBack(data) {

		var compNames = '';
		var compInfoArray = new Array;
		var info = {};
		
		
		for(var i=0; i<data.length; i++) {
			var compInfo = {};
			compNames += data[i].compName + ", ";
			compInfo.compSeq = data[i].compSeq;
			compInfo.sms_id = $("#faxID").val();
			
			compInfoArray.push(compInfo);
		}
		$("#useSMSCompany").val(compNames.substring(0, (compNames.length-2)));

		smsCompParams.compInfoArray = compInfoArray;
		smsCompParams.compInfoArray = JSON.stringify(compInfoArray);
	}
	
</script>

<div class="top_box">
	<dl>
		<dt><%=BizboxAMessage.getMessage("TX000010902","팩스아이디")%></dt>
		<dd>
			<input class="k-textbox input_search fl" id="btnText" type="text"
				value="" style="width: 173px;" placeholder=""> <a href="#"
				class="btn_search fl posi_re" id="searchImgButton"></a>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
		<dd>
			<!--<input id="use_sel" type="text" value="" style="width: 100px;" /> -->
			<select id="use_sel" class="kendoComboBox" style="width: 100px">
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
				<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
			</select> <input id="searchButton" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
		</dd>
	</dl>
</div>

<div class="sub_contents_wrap">

	<div class="btn_div">
		<div class="left_div">
			<h5><%=BizboxAMessage.getMessage("TX000016091","팩스연동 목록")%></h5>
		</div>

		<div class="right_div">
			<div id="" class="controll_btn p0">
				<button id="faxRegisterPage" class="k-button"><%=BizboxAMessage.getMessage("TX900000435","회원가입")%></button>
				<button id="addButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
				<button id="removeButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>
	</div>

	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width: 40%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<!-- // 켄도 그리드 테이블 원할 경우 사용-->
					<div id="grid"></div> 
				</td>
				<td class="twinbox_td">
					<!-- 선택 테이블 -->
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120" />
								<col width="" />
							</colgroup>
							<tr>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000010902","팩스아이디")%></th>
								<td><input id="faxID" class="" type="text" value=""
									style="width: 95%" disabled="" /></td>
							</tr>
							<tr>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000016094","팩스 비밀번호")%></th>
								<td><input autocomplete="new-password" id="faxPW" class="" type="password" value=""
									style="width: 95%" disabled="" /></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000017928","문자 사용회사")%></th>
								<td><input id="useSMSCompany" class="" type="text" value=""
									style="width: 90%"/><button id="useSMSCompanySelect" class="k-button"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td class="useYN"><input type="radio" name="radio_u1u2"
									id="faxUse" class="k-radio" checked="checked" value="Y" /> <label
									class="k-radio-label radioSel" for="faxUse"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label> <input
									type="radio" name="radio_u1u2" id="faxNotUse" class="k-radio"
									value="N" /> <label class="k-radio-label radioSel ml10"
									for="faxNotUse"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label></td>
							</tr>
						</table>
					</div>
					<div class="btn_cen">
						<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" id="saveButton" />
					</div> <!-- 컨트롤버튼 -->
					<div class="mt30" id="pointBox">
						<span class="fl text_blue mt7"> <strong id="point">Point
								: 9,500</strong>
						</span>
						<div id="" class="controll_btn p0">
							<button id="faxCharge"><%=BizboxAMessage.getMessage("TX000016108","충전")%></button>
							<button id="faxRefresh"><%=BizboxAMessage.getMessage("TX000016394","갱신")%></button>
							<button id="faxServiceExtension"><%=BizboxAMessage.getMessage("TX000016202","서비스연장")%></button>
							<button id="faxChargeInfo"><%=BizboxAMessage.getMessage("TX000010903","요금안내")%></button>
						</div>
					</div>

					<div class="com_ta2 mt10" style="height: 298px; overflow: auto;"
						id="faxDetail">
						<table>
							<colgroup>
								<col width="" />
								<col width="" />
								<col width="" />
								<col width="" />
								<col width="" />
							</colgroup>
							<thead>
								<tr>
									<th>No</th>
									<th><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
									<th><%=BizboxAMessage.getMessage("TX000010916","연결")%></th>
									<th><%=BizboxAMessage.getMessage("TX000010914","서비스기간")%></th>
									<th><%=BizboxAMessage.getMessage("TX000000543","상태")%></th>
								</tr>
							</thead>
							<tbody id="faxNoList">
							</tbody>
						</table>
					</div>


				</td>
			</tr>
		</table>
	</div>
	<div id="popFaxChargeInfo"></div>
</div>


<!-- //sub_contents_wrap -->