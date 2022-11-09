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
	var accountSeq = "";
	
	$(document).ready(function() {
		fnInitDatePicker(1);
		
		//기본버튼
		$(".controll_btn button").kendoButton();

		//시작날짜
		$("#from_date").kendoDatePicker();

		//종료날짜
		$("#to_date").kendoDatePicker();

		// 내가 등록한 거채처 목록 가져오기 (selectBox)
		fnMyAccountSelectBoxData();
		
		// 버튼 이벤트 초기화
		fnButtonInit();

		// 년 / 월 셋팅
		fnDateSetting();

	});//document ready end
	
	function fnDateSetting() {
		var toDay = new Date();
		
		var month = toDay.getMonth();		// 현재 월
		var year = toDay.getFullYear();			// 현재 연도
		var pastYear = new Array();				// 최근 5년
		
		// 최근 5년 담기
		for(var i=0; i < 5; i++) {
			var recentYear = {}
			recentYear.Date = year-i;
			recentYear.Value = recentYear.Date;
			pastYear.push(recentYear);
		}

		// 년도
		$("#year").kendoComboBox({
			dataSource : pastYear,
			dataTextField : "Date",
			dataValueField : "Value"
		});

		var comboBoxYearData = $("#year").data("kendoComboBox");
		comboBoxYearData.value(year);
		
		// 월
		$("#month").kendoComboBox({
			dataSource : [
            	{Date:"01", Value:"01"},
            	{Date:"02", Value:"02"},
            	{Date:"03", Value:"03"},
            	{Date:"04", Value:"04"},
            	{Date:"05", Value:"05"},
            	{Date:"06", Value:"06"},
            	{Date:"07", Value:"07"},
            	{Date:"08", Value:"08"},
            	{Date:"09", Value:"09"},
            	{Date:"10", Value:"10"},
            	{Date:"11", Value:"11"},
            	{Date:"12", Value:"12"}
            ],
            dataTextField : "Date",
            dataValueField : "Value"
		});
		

		var comboBoxMonthData = $("#month").data("kendoComboBox");
		comboBoxMonthData.select(month);
		
	}
	
	// 내가 등록한 거채처 목록 가져오기 (selectBox)
	function fnMyAccountSelectBoxData() {
		var param = {};
		param.cbName = "";		// 거래처명 (전체)
		param.cbNo = "";				// 계좌번호 (전체)
		param.useYn = "Y";			// 사용 중인것만
		
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url:  "<c:url value='/api/account/web/AccountList' />"
				, data: JSON.stringify(param)
				, success: function(result) {
					//console.log(JSON.stringify(result));
					//alert(JSON.stringify(result));
					var myAccountRegList = result.result.accountList;
					
					// select box에 뿌려줄 데이터 생성
					for(var i=0; i<myAccountRegList.length; i++) {
						var display = myAccountRegList[i].cbName + "[" + myAccountRegList[i].cbNo + "]";
						myAccountRegList[i].display = display;
					}

					// select box 그려주기
					$("#myAccountRegList").kendoComboBox({
						dataSource : myAccountRegList,
						dataTextField : "display",
						dataValueField : "cbCode",
						select : fnAccountInfo,				// select box 선택 시 event		
						index : 0
					});
					
					// select box 첫번째 이벤트 실행
					fnAccountFirstInfo(myAccountRegList[0].accountSeq);
				}
				, error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
		});
	}
	
	// select box 첫번째 이벤트 실행
	function fnAccountFirstInfo(accountSeqDate) {
		accountSeq = accountSeqDate;
		var param = {};
		param.accountSeq = accountSeq;
		//return;
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url:  "<c:url value='/api/account/web/Balance' />"
				, data: JSON.stringify(param)
				, success: function(result) {
					//console.log(JSON.stringify(result));
					if(result.resultCode =="0") {
						var accountInfo = result.result;
						
						// 계좌 정보 그려주기
						fnAccountInfoGrid(accountInfo);	
					} else {
						alert(result.resultMessage);	
					}
				}
				, error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
		});
	}
	
	// select box 선택 시 해당되는 account 정보 가져오기
	function fnAccountInfo(e) {										// 실 서버에서 확인 데이터만 뿌려주기
		dataItem = this.dataItem(e.item.index());
		//alert(JSON.stringify(dataItem));
		accountSeq = dataItem.accountSeq
		var param = {};
		param.accountSeq = accountSeq;
		//return;
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url:  "<c:url value='/api/account/web/Balance' />"
				, data: JSON.stringify(param)
				, success: function(result) {
					//console.log(JSON.stringify(result));
					if(result.resultCode == "0") {
						var accountInfo = result.result;
						
						// 계좌 정보 그려주기
						fnAccountInfoGrid(accountInfo);	
					} else {
						alert(result.resultMessage);
					}
				}
				, error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
		});
		
	}
	
	// 계좌 정보 그려주기
	function fnAccountInfoGrid(data) {
		var account = data.cbName;									// 거래처
		var accountNum = data.cbNo;								// 계좌번호
		var depositType = data.accType;							// 예금종류
		var depositName = data.accName; 						// 예금주명
		var currentBalance = data.balance;						// 현재 잔액
		var posibleWithDrawBalance = data.availMoney;		// 출금 가능 
		
		$("#account").html(account);
		$("#accountNum").html(accountNum);
		$("#depositType").html(depositType);
		$("#depositName").html(depositName);
		$("#currentBalance").html(currentBalance);
		$("#posibleWithDrawBalance").html(posibleWithDrawBalance);
	}
	
	// 버튼 이벤트 
	function fnButtonInit() {
		$("#searchButton").click(function(){
			// 거래 내역 가져오기
			fnTransaction();
		});
	}
	
	// 거래 내역 가져오기
	function fnTransaction() {
		
		var param = {};

		param.accountSeq = accountSeq;
		//param.userGuid = $("#hiddenUserGuid").val();
		param.userGuid = "";
		param.pageNum = 1;
		param.pageSize = 10000000;
		if($("input[name=lookUpTime]:checked").val() == "1") {
			param.from = $("#from_date").val().replace(/\-/g,'');
			param.to = $("#to_date").val().replace(/\-/g,'');	
		} else {
			param.from = $("#year").val() + $("#month").val() + "01";
			param.to = $("#year").val() + $("#month").val() + "31";
		}
		param.order = $("input[name=order]:checked").val();
		param.searchType = $("input[name=lookupContent]:checked").val();
		//alert(JSON.stringify(param));
		//return;
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url:  "<c:url value='/api/account/web/Transaction' />"
				, data: JSON.stringify(param)
				, success: function(result) {
					//alert(JSON.stringify(result));
					//console.log(JSON.stringify(result));
					if(result.resultCode =="0") {
						var transactionData = result.result.transactionList;
						
						// 거래 내역 그려주기
						fnTransactionGrid(transactionData);	
					} else {
						alert(result.resultMessage);
					}
					
				}
				, error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
		});
	}
	
	// 거래 내역 그리드
	function fnTransactionGrid(transactionData) {
		$("#transactionList").kendoGrid({
			dataSource : {
				data : transactionData,
				pageSize : 10
			},
			height : 330,
			selectable : "single",
			groupable : false,
			columnMenu : false,
			editable : false,
			sortable : true,
			pageable : true,
			columns : [
            	{
            		field : "<%=BizboxAMessage.getMessage("TX000011977","거래일시")%>",
            		headerAttributes : {
            			style : "text-align: center;"
            		},
            		attribute : {
            			style : "text-align: center;"
            		},
            		template : function(data) {
            			return data.date;
            		}
            	},
            	{
            		field : "<%=BizboxAMessage.getMessage("TX000000604","적요")%>",
            		headerAttributes : {
            			style : "text-align: center;"
            		},
            		attribute : {
            			style : "text-align: center;"
            		},
            		template : function(data) {
            			return data.summary;
            		}
            	},
            	{
            		field : "<%=BizboxAMessage.getMessage("TX000010801","기재내용")%>",
            		headerAttributes : {
            			style : "text-align: center;"
            		},
            		attribute : {
            			style : "text-align: center;"
            		},
            		template : function(data) {
            			return data.etc;
            		}
            	},
            	{
            		field : "<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%>",
            		headerAttributes : {
            			style : "text-align: center;"
            		},
            		attribute : {
            			style : "text-align: center;"
            		},
            		template : function(data) {
            			return data.output;
            		}
            	},
            	{
            		field : "<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%>",
            		headerAttributes : {
            			style : "text-align: center;"
            		},
            		attribute : {
            			style : "text-align: center;"
            		},
            		template : function(data) {
            			return data.input;
            		}
            	},
            	{
            		field : "<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%>",
            		headerAttributes : {
            			style : "text-align: center;"
            		},
            		attribute : {
            			style : "text-align: center;"
            		},
            		template : function(data) {
            			return data.balance;
            		}
            	},
            	{
            		field : "<%=BizboxAMessage.getMessage("TX000010798","취급점")%>",
            		headerAttributes : {
            			style : "text-align: center;"
            		},
            		attribute : {
            			style : "text-align: center;"
            		},
            		template : function(data) {
            			return data.division;
            		}
            	}
            ]			
		});
		
	}

	/*	[데이트 피커] Initialrize date picker with gap
	----------------------------------------*/
	function fnInitDatePicker(monthGap) {

		// Object Date add prototype
		Date.prototype.ProcDate = function() {
			var yyyy = this.getFullYear().toString();
			var mm = (this.getMonth() + 1).toString(); //
			var dd = this.getDate().toString();
			return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-'
					+ (dd[1] ? dd : "0" + dd[0]);
		};

		var toD = new Date();
		$('#to_date').val(toD.ProcDate());

		if (toD.getMonth() == (12 - monthGap)) {
			var fromD = new Date(toD.getFullYear() - 1, 0, toD.getDate());
		} else {
			var fromD = new Date(toD.getFullYear(), toD.getMonth() - monthGap, toD.getDate());
		}
		$('#from_date').val(fromD.ProcDate());
	}

	/*	[데이트 피커] Get value of date pickers / return { [Text]from_date : #from_date, [Text]to_date : #to_date}
	----------------------------------------*/
	function fnGetDatePickerValue() {
		var returnDate = {};
		returnDate.from_date = $("#from_date").val() + ' 00:00:00';
		returnDate.to_date = $("#to_date").val() + ' 23:59:59';

		return returnDate;
	}		
	
	// 기간 선택 이벤트
	function fnMenuShowHide() {
		if($("input[name=lookUpTime]:checked").val() == "1") {
			$("#monthLookUp").hide();
		} else {
			$("#monthLookUp").show();
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
				<input id="myAccountRegList" class="kendoComboBox" style="width: 280px" />
			</dd>

			<dt class="ar" style="width: 68px;"><%=BizboxAMessage.getMessage("TX000000861","조회기간")%></dt>
			<dd>
				<input id="from_date" value="2015-01-01" class="dpWid" /> ~ <input
					id="to_date" value="2015-05-27" class="dpWid" />
			</dd>
			<dd>
				<input id="searchButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
			</dd>
		</dl>
		<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn"
			src='../../../Images/ico/ico_btn_arr_down01.png' /></span>
	</div>

	<!-- 상세검색박스 -->
	<div class="SearchDetail">
		<dl>
			<dt style="width: 70px;"><%=BizboxAMessage.getMessage("TX000000854","조회구분")%></dt>
			<dd class="mr5 pt5 pl5">
				<input type="radio" name="lookUpTime" id="fullDate" class="k-radio" checked="checked" value="1" onchange="fnMenuShowHide()"/> 
				<label class="k-radio-label radioSel" for="fullDate"><%=BizboxAMessage.getMessage("TX000015703","기간별조회")%></label>
				<input type="radio" name="lookUpTime" id="monthDate" class="k-radio" value="2" onchange="fnMenuShowHide()"/> 
				<label class="k-radio-label radioSel ml10" for="monthDate"><%=BizboxAMessage.getMessage("TX000015702","월별조회")%></label>
			</dd>
		</dl>

		<dl id="monthLookUp" style="display:none">
			<dt class="pt10" style="width: 70px;"><%=BizboxAMessage.getMessage("TX000015702","월별조회")%></dt>
			<dd class="mr5 pt5 pl5">
				<input id="year" class="kendoComboBox" style="width: 80px" /> <%=BizboxAMessage.getMessage("TX000000435","년")%> 
				<input id="month" class="kendoComboBox" style="width: 50px" /> <%=BizboxAMessage.getMessage("TX000000436","월")%>
			</dd>
		</dl>

		<dl>
			<dt style="width: 70px;"><%=BizboxAMessage.getMessage("TX000015701","조회내용")%></dt>
			<dd class="mr5 pt5 pl5">
				<input type="radio" name="lookupContent" id="allContent" class="k-radio" value="0" checked="checked" /> 
				<label class="k-radio-label radioSel" for="allContent"><%=BizboxAMessage.getMessage("TX000000862","전체")%></label> 
				<input type="radio" name="lookupContent" id="inputContent" value="1" class="k-radio" /> 
				<label class="k-radio-label radioSel ml10" for="inputContent"><%=BizboxAMessage.getMessage("TX000016148","입금내용")%></label> 
				<input type="radio" name="lookupContent" id="outContent" value="2" class="k-radio" /> 
				<label class="k-radio-label radioSel ml10" for="outContent"><%=BizboxAMessage.getMessage("TX000016112","출금내용")%></label>
			</dd>
		</dl>

		<dl>
			<dt style="width: 70px;"><%=BizboxAMessage.getMessage("TX000000125","정렬순서")%></dt>
			<dd class="mr5 pt5 pl5">
				<input type="radio" name="order" id="recentHistory" class="k-radio" value="B" checked="checked" /> 
				<label class="k-radio-label radioSel" for="recentHistory"><%=BizboxAMessage.getMessage("TX000016115","최근내역")%></label> 
				<input type="radio" name="order" id="pastHistory" class="k-radio" value="A"/> 
				<label class="k-radio-label radioSel ml10" for="pastHistory"><%=BizboxAMessage.getMessage("TX000015697","과거내역")%></label>
			</dd>
		</dl>
	</div>
	<div class="btn_div m0">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				<button id=""><%=BizboxAMessage.getMessage("TX000002977","엑셀")%></button>
			</div>
		</div>
	</div>

	<div class="com_ta mb20">
		<table>
			<colgroup>
				<col width="20%" />
				<col width="" />
				<col width="20%" />
				<col width="" />
			</colgroup>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000000520","거래처")%></th>
				<td id="account"></td>
				<th><%=BizboxAMessage.getMessage("TX000003620","계좌번호")%></th>
				<td id="accountNum"></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000011980","예금종류")%></th>
				<td id="depositType"></td>
				<th><%=BizboxAMessage.getMessage("TX000011979","예금주명")%></th>
				<td id="depositName"></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000000142","현재잔액")%></th>
				<td colspan="3" id="currentBalance"></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000011978","출금가능금액")%></th>
				<td colspan="3" id="posibleWithDrawBalance"></td>
			</tr>
		</table>
	</div>

	<!-- 그리드 리스트 -->
	<div id="transactionList"></div>

</div>
<!-- //sub_contents_wrap -->
