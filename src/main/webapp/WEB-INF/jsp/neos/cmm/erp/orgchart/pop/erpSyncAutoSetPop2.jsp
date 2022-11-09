<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

<%@ include file="/WEB-INF/jsp/calendar/Calendar.jsp"%>


<script type="text/javascript">
	var compSeq = "${compSeq}";
	var saveYN = "${erpSyncAuto}";
	var saveFlag = "insert";
	var today = ConvertDateToString();

	$(document).ready(function() {
		/* 이벤트 초기화 */
		fnButtonInit();
		
		/* 이미 저장된 값 있을 경우 데이터 셋팅 */
		if(saveYN == "Y") {
			saveFlag = "update";
			fnInit();	
		} else {
			saveFlag = "insert";
			
			$("#from_date").val(today);
		}
	});
	
	/* 이벤트 초기화 */
	function fnButtonInit() {
		$("#saveButton").click(function() {
			fnSave();
		});
		
		$("#cancelButton").click(function(){
			self.close();
		});
	}
	
	/* 스케줄러 데이터 저장  */
	function fnSave() {
		var param = {};
		var selectOption = $("input[name='day_sel']:checked").val();
		
		// 선택 값에 따른 데이터 가져오기
		if(selectOption == "noUse") {						// 사용안함
			param.time = "";
		} else if(selectOption == "everyDay") {				// 매일
			param.time = $("#everyDaySelect").val();
		} else if(selectOption == "everyWeek") {			// 매주
			param.week = $("#everyWeekSelect").val();
			param.time = $("#everyWeekTimeSelect").val(); 
		} else if(selectOption == "everyMonth") {			// 매월
			param.day = $("#everyMonthSelect").val();
			param.time = $("#everyMonthTimeSelect").val();
		} else if(selectOption == "specialDay") {			// 지정한 시간
			param.date = $("#from_date").val(); //.replace(/-/gi, "");
			param.time = $("#specialDateTimeSelect").val();
		}
		
		param.selectOption = selectOption;
		param.compSeq = compSeq;
		param.saveFlag = saveFlag;
		
		
		$.ajax({
			type : "POST"
			, url : "<c:url value='/erp/orgchart/pop/erpSyncAutoSetSave.do'/>"
			, data : param
			, async : false
			, dataType : "json"
			, success : function(result) {
				// TX000002073
				alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다")%>");
				self.close();
			}
			, error: function(result) {
				
			}
		});	
		
		
	}
	
	/* 이미 저장된 값 있을 경우 데이터 셋팅 */
	function fnInit() {
		var scheduleType = "${erpSyncAutoList.scheduleType}";
		
		if(scheduleType == "0") {			// 사용안함
			$("#noUseInput").attr("checked", true);
		} else if(scheduleType == "1") {	// 매일
			$("#everyDayInput").attr("checked", true);
			
			$("#from_date").val(today);
			$('#everyDaySelect option[value="${erpSyncAutoList.scheduleTime}"]').attr("selected", true);
		} else if(scheduleType == "2") {	// 매주
			$("#everyWeekInput").attr("checked", true);
			
			$("#from_date").val(today);
			$('#everyWeekSelect option[value="${erpSyncAutoList.scheduleWeek}"]').attr("selected", true);
			$('#everyWeekTimeSelect option[value="${erpSyncAutoList.scheduleTime}"]').attr("selected", true);
		} else if(scheduleType == "3") {	// 매월
			$("#everyMonthInput").attr("checked", true);
		
			$("#from_date").val(today);
			$('#everyMonthSelect option[value="${erpSyncAutoList.scheduleDay}"]').attr("selected", true);
			$('#everyMonthTimeSelect option[value="${erpSyncAutoList.scheduleTime}"]').attr("selected", true);
		} else if(scheduleType == "4") {	// 지정한 시간
			var scheduleTime = "${erpSyncAutoList.specialDay}";
			$("#specialDayInput").attr("checked", true);
			$('#from_date').val(scheduleTime);
			$('#specialDateTimeSelect option[value="${erpSyncAutoList.scheduleTime}"]').attr("selected", true);
		}
	}
</script>


<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000020529","자동 동기화 설정")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	<div class="pop_con">
		<div class="com_ta">
			<table>
			<colgroup>
				<col width="20%" />
				<col />
			</colgroup>
				<tr>
					<td colspan="2">
						<input type="radio" name="day_sel" id="noUseInput" value="noUse" checked/>
						<label for="noUseInput"><%=BizboxAMessage.getMessage("TX000005964","사용안함")%></label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="day_sel" id="everyDayInput" value="everyDay"/>
						<label for="everyDayInput"><%=BizboxAMessage.getMessage("TX000006594","매일")%></label>
					</td>
					<td class="brln">
						<span class="mr5"><%=BizboxAMessage.getMessage("TX000018694","시간")%></span> 
						<select id="everyDaySelect" class="selectmenu timer" style="width:100px;">
							<option value="0000"  selected="selected">00:00</option>
							<option value="0100">01:00</option>
							<option value="0200">02:00</option>
							<option value="0300">03:00</option>
							<option value="0400">04:00</option>
							<option value="0500">05:00</option>
							<option value="0600">06:00</option>
							<option value="0700">07:00</option>
							<option value="0800">08:00</option>
							<option value="0900">09:00</option>
							<option value="1000">10:00</option>
							<option value="1100">11:00</option>
							<option value="1200">12:00</option>
							<option value="1300">13:00</option>
							<option value="1400">14:00</option>
							<option value="1500">15:00</option>
							<option value="1600">16:00</option>
							<option value="1700">17:00</option>
							<option value="1800">18:00</option>
							<option value="1900">19:00</option>
							<option value="2000">20:00</option>
							<option value="2100">21:00</option>
							<option value="2200">22:00</option>
							<option value="2300">23:00</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="day_sel" id="everyWeekInput" value="everyWeek"/>
						<label for="everyWeekInput"><%=BizboxAMessage.getMessage("TX000006579","매주")%></label>
					</td>
					<td class="brln">
						<span class="mr5"><%=BizboxAMessage.getMessage("TX000000635","요일")%></span> 
						<select id="everyWeekSelect" class="selectmenu" style="width:100px;">
							<option value="mon"  selected="selected"><%=BizboxAMessage.getMessage("TX000005657","월")%></option>
							<option value="tue"><%=BizboxAMessage.getMessage("TX000005658","화")%></option>
							<option value="wed"><%=BizboxAMessage.getMessage("TX000005659","수")%></option>
							<option value="thu"><%=BizboxAMessage.getMessage("TX000005660","목")%></option>
							<option value="fri"><%=BizboxAMessage.getMessage("TX000005661","금")%></option>
							<option value="sat"><%=BizboxAMessage.getMessage("TX000005662","토")%></option>
							<option value="sun"><%=BizboxAMessage.getMessage("TX000005656","일")%></option>
						</select>

						<span class="ml10 mr5"><%=BizboxAMessage.getMessage("TX000018694","시간")%></span> 
						<select id="everyWeekTimeSelect" class="selectmenu timer" style="width:100px;">
							<option value="0000"  selected="selected">00:00</option>
							<option value="0100">01:00</option>
							<option value="0200">02:00</option>
							<option value="0300">03:00</option>
							<option value="0400">04:00</option>
							<option value="0500">05:00</option>
							<option value="0600">06:00</option>
							<option value="0700">07:00</option>
							<option value="0800">08:00</option>
							<option value="0900">09:00</option>
							<option value="1000">10:00</option>
							<option value="1100">11:00</option>
							<option value="1200">12:00</option>
							<option value="1300">13:00</option>
							<option value="1400">14:00</option>
							<option value="1500">15:00</option>
							<option value="1600">16:00</option>
							<option value="1700">17:00</option>
							<option value="1800">18:00</option>
							<option value="1900">19:00</option>
							<option value="2000">20:00</option>
							<option value="2100">21:00</option>
							<option value="2200">22:00</option>
							<option value="2300">23:00</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="day_sel" id="everyMonthInput" value="everyMonth"/>
						<label for="everyMonthInput"><%=BizboxAMessage.getMessage("TX000006581","매월")%></label>
					</td>
					<td class="brln">
						<span class="mr5 pl12"><%=BizboxAMessage.getMessage("TX000000437","일")%></span> 
						<select id="everyMonthSelect" class="selectmenu" style="width:100px;">
							<option value="01"  selected="selected">1</option>
							<option value="02">2</option>
							<option value="03">3</option>
							<option value="04">4</option>
							<option value="05">5</option>
							<option value="06">6</option>
							<option value="07">7</option>
							<option value="08">8</option>
							<option value="09">9</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
							<option value="13">13</option>
							<option value="14">14</option>
							<option value="15">15</option>
							<option value="16">16</option>
							<option value="17">17</option>
							<option value="18">18</option>
							<option value="19">19</option>
							<option value="20">20</option>
							<option value="21">21</option>
							<option value="22">22</option>
							<option value="23">23</option>
							<option value="24">24</option>
							<option value="25">25</option>
							<option value="26">26</option>
							<option value="27">27</option>
							<option value="28">28</option>
							<option value="29">29</option>
							<option value="30">30</option>
							<option value="31">31</option>
						</select>

						<span class="ml10 mr5"><%=BizboxAMessage.getMessage("TX000018694","시간")%></span> 
						<select id="everyMonthTimeSelect" class="selectmenu timer" style="width:100px;">
							<option value="0000"  selected="selected">00:00</option>
							<option value="0100">01:00</option>
							<option value="0200">02:00</option>
							<option value="0300">03:00</option>
							<option value="0400">04:00</option>
							<option value="0500">05:00</option>
							<option value="0600">06:00</option>
							<option value="0700">07:00</option>
							<option value="0800">08:00</option>
							<option value="0900">09:00</option>
							<option value="1000">10:00</option>
							<option value="1100">11:00</option>
							<option value="1200">12:00</option>
							<option value="1300">13:00</option>
							<option value="1400">14:00</option>
							<option value="1500">15:00</option>
							<option value="1600">16:00</option>
							<option value="1700">17:00</option>
							<option value="1800">18:00</option>
							<option value="1900">19:00</option>
							<option value="2000">20:00</option>
							<option value="2100">21:00</option>
							<option value="2200">22:00</option>
							<option value="2300">23:00</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="day_sel" id="specialDayInput" value="specialDay"/>
						<label for="specialDayInput"><%=BizboxAMessage.getMessage("TX000011068","날짜선택")%></label>
					</td>
					<td class="brln">
						<div class="dal_div ml13">
							<input id="from_date" type="text" value="2017-02-01" style="width:118px;" readonly/>
						</div>

						<span class="ml10 mr5"><%=BizboxAMessage.getMessage("TX000018694","시간")%></span> 
						<select id="specialDateTimeSelect" class="selectmenu timer" style="width:100px;">
							<option value="0000"  selected="selected">00:00</option>
							<option value="0100">01:00</option>
							<option value="0200">02:00</option>
							<option value="0300">03:00</option>
							<option value="0400">04:00</option>
							<option value="0500">05:00</option>
							<option value="0600">06:00</option>
							<option value="0700">07:00</option>
							<option value="0800">08:00</option>
							<option value="0900">09:00</option>
							<option value="1000">10:00</option>
							<option value="1100">11:00</option>
							<option value="1200">12:00</option>
							<option value="1300">13:00</option>
							<option value="1400">14:00</option>
							<option value="1500">15:00</option>
							<option value="1600">16:00</option>
							<option value="1700">17:00</option>
							<option value="1800">18:00</option>
							<option value="1900">19:00</option>
							<option value="2000">20:00</option>
							<option value="2100">21:00</option>
							<option value="2200">22:00</option>
							<option value="2300">23:00</option>
						</select>
					</td>
				</tr>
			</table>
		</div>	
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="saveButton" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" id="cancelButton" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->