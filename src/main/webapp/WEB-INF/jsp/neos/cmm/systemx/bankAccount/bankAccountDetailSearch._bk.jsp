<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script id="treeview-template" type="text/kendo-ui-template">
	        #: item.text #
	</script>
<script type="text/javascript">
	$(document).ready(function() {
		
		fnInitDatePicker(1);
		
		fnGetAccountList();
		
		//기본버튼
		$(".controll_btn button").kendoButton();

 		//시작날짜
		$("#from_date").kendoDatePicker({
			format : "yyyy-MM-dd"
		});

		//종료날짜
		$("#to_date").kendoDatePicker({
			format : "yyyy-MM-dd"
		}); 

		//셀렉트박스
		$("#acc_bank").kendoComboBox({
			dataSource : {
				data : [ "<%=BizboxAMessage.getMessage("TX000010802","국민은행[계좌 : 11680101000884]")%>", "..." ]
			},
			value : "<%=BizboxAMessage.getMessage("TX000010802","국민은행[계좌 : 11680101000884]")%>"
		});
		//셀렉트박스
		$("#sel1").kendoComboBox({
			dataSource : {
			    data : ["2016","..."]
			},
			value:"2016"
		});
		
		//셀렉트박스
		$("#sel2").kendoComboBox({
			dataSource : {
			    data : ["02","..."]
			},
			value:"02"
		}); 

		//grid table
		$("#grid").kendoGrid({
			columns : [ {
				field : "<%=BizboxAMessage.getMessage("TX000011977","거래일시")%>",
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				},
			}, {
				field : "<%=BizboxAMessage.getMessage("TX000000604","적요")%>",
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: left;"
				},
			}, {
				field : "<%=BizboxAMessage.getMessage("TX000010801","기재내용")%>",
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: left;"
				},
			}, {
				field : "<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%>",
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: right;"
				},
			}, {
				field : "<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%>",
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: right;"
				},
			}, {
				field : "<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%>",
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: right;"
				},
			}, {
				field : "<%=BizboxAMessage.getMessage("TX000010798","취급점")%>",
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				},
			} ],

			dataSource : [ {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-13 18:46:06",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","정릉")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "26,900<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "3,857<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			}, {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-13 18:21:24",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","정릉")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "26,900<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "30,757<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			}, {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-13 18:18:17",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","(신투)")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "53,800<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "57,657<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			}, {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-13 07:07:24",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","행신")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "3,857<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "3,857<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			}, {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-05 09:05:39",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","정릉")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "53,800<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			}, {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-05 08:35:30",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","(우리)")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "26,900<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "53,800<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			}, {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-04 23:02:06",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","(외환)")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "26,900<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "26,900<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			}, {
				<%=BizboxAMessage.getMessage("TX000011977","거래일시")%> : "2016-02-02 13:01:25",
				<%=BizboxAMessage.getMessage("TX000000604","적요")%> : "",
				<%=BizboxAMessage.getMessage("TX000010801","기재내용")%> : "<%=BizboxAMessage.getMessage("","정릉")%>",
				<%=BizboxAMessage.getMessage("TX000010800","찾으신금액")%> : "10,382<%=BizboxAMessage.getMessage("TX000000626","원")%>",
				<%=BizboxAMessage.getMessage("TX000010799","맡기신금액")%> : "",
				<%=BizboxAMessage.getMessage("TX000011974","거래후잔액")%> : "",
				<%=BizboxAMessage.getMessage("TX000010798","취급점")%> : "<%=BizboxAMessage.getMessage("","모바일")%>"
			} ],
			height : 330,
			selectable : "single",
			groupable : false,
			columnMenu : false,
			editable : false,
			sortable : true,
			pageable : false
		});

	});//document ready end
	
	
	function fnGetAccountList(){
		var param = {};
		
		param.ACCOUNT_KEY = "";
		param.CB_NAME = "";
		param.CBNO = "";
		param.USE_YN = "1";
		
		$.ajax({
			type: "POST"
			, url: "<c:url value='/cmm/systemx/bankAccount/getAccountList.do' />"
			, data: param
			, success: function(result) {
				alert('성공');	
			}
			, error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
			}
		});
		
	}
	
	
	function fnScrapAccountInfo(mode, page, type) {
		// 날짜 예외처리 일단 제외함
		
		var pageSize = 20;
		
		var searchType = type == "INFO" ? type : escape($("input[name=rblSearchTp]:checked").val());
				
		var param = {};
		
		param.mode = escape(mode);
		param.pageCount = escape(page);
		param.pageSize = escape(pageSize);
		param.accountKey = escape($("#acc_bank").val());					// 확인 필요 (켄도)
		param.from = escape($("#from_date").val());
		param.to = escape($("#to_date").val());
		param.month = escape($("input[name=rblSearchGb]:checked").val() == "0" ? ($("#sel1").val() + $("#sel2").val()) : "")
		param.order = escape($("input[name=rblOrder]:checked").val());
		param.searchType = searchType;
		
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
</script>



<!-- 검색박스 -->
<div class="top_box">
	<dl>
		<dt class="ar" style="width: 68px;"><%=BizboxAMessage.getMessage("TX000000520","거래처")%></dt>
		<dd>
			<input id="acc_bank" class="kendoComboBox" style="width: 280px" />
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
			<input type="radio" name="rblSearchGb" value="1"  id="acc_sel_type1-1" class="k-radio" checked="checked" /> 
			<label class="k-radio-label radioSel" for="acc_sel_type1-1"><%=BizboxAMessage.getMessage("TX000015703","기간별조회")%></label> 
			<input type="radio" name="rblSearchGb" value="0" id="acc_sel_type1-2" class="k-radio" /> 
			<label class="k-radio-label radioSel ml10" for="acc_sel_type1-2"><%=BizboxAMessage.getMessage("TX000015702","월별조회")%></label>
		</dd>
	</dl>
	
	<dl>	
		<dt class="pt10" style="width:70px;"><%=BizboxAMessage.getMessage("TX000015702","월별조회")%></dt>
		<dd class="mr5 pt5 pl5">
			<input id="sel1" class="kendoComboBox" style="width:80px" /> <%=BizboxAMessage.getMessage("TX000000435","년")%>
			<select id="sel2" class="kendoComboBox" style="width: 150px">
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
			</select>월
			<!-- <input id="sel2" class="kendoComboBox" style="width:50px" /> 월 -->
		</dd>
	</dl>

	<dl>
		<dt style="width: 70px;"><%=BizboxAMessage.getMessage("TX000015701","조회내용")%></dt>
		<dd class="mr5 pt5 pl5">
			<input type="radio" name="rblSearchTp" id="acc_sel_type2-1" class="k-radio" checked="checked" /> 
			<label class="k-radio-label radioSel" for="acc_sel_type2-1"><%=BizboxAMessage.getMessage("TX000000862","전체")%></label> 
			<input type="radio" name="rblSearchTp" id="acc_sel_type2-2" class="k-radio" /> 
			<label class="k-radio-label radioSel ml10" for="acc_sel_type2-2"><%=BizboxAMessage.getMessage("","입금내용")%></label> 
			<input type="radio" name="rblSearchTp" id="acc_sel_type2-3" class="k-radio" /> 
			<label class="k-radio-label radioSel ml10" for="acc_sel_type2-3"><%=BizboxAMessage.getMessage("","출금내용")%></label>
		</dd>
	</dl>

	<dl>
		<dt style="width: 70px;"><%=BizboxAMessage.getMessage("TX000000125","정렬순서")%></dt>
		<dd class="mr5 pt5 pl5">
			<input type="radio" name="rblOrder" id="acc_sel_type3-1" class="k-radio" checked="checked" /> 
			<label class="k-radio-label radioSel" for="acc_sel_type3-1"><%=BizboxAMessage.getMessage("","최근내역")%></label> 
			<input type="radio" name="rblOrder" id="acc_sel_type3-2" class="k-radio" /> 
			<label class="k-radio-label radioSel ml10" for="acc_sel_type3-2"><%=BizboxAMessage.getMessage("TX000015697","과거내역")%></label>
		</dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
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
				<td><%=BizboxAMessage.getMessage("","통합 신한은행")%></td>
				<th><%=BizboxAMessage.getMessage("TX000003620","계좌번호")%></th>
				<td>110267117872</td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000011980","예금종류")%></th>
				<td><%=BizboxAMessage.getMessage("","월급통장")%></td>
				<th><%=BizboxAMessage.getMessage("TX000011979","예금주명")%></th>
				<td><%=BizboxAMessage.getMessage("TX000000705","관리자")%></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000000142","현재잔액")%></th>
				<td colspan="3">3,857<%=BizboxAMessage.getMessage("TX000000626","원")%></td>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000011978","출금가능금액")%></th>
				<td colspan="3">3,857<%=BizboxAMessage.getMessage("TX000000626","원")%></td>
			</tr>
		</table>
	</div>

	<!-- 그리드 리스트 -->
	<div id="grid"></div>

</div>
<!-- //sub_contents_wrap -->

</div>
