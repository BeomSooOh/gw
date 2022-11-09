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
	var smsDate = "${result.smsDate}";
	var agentID = "${result.agentID}";
	var agentKey = "${result.agentKey}";
	var compSeq = "${result.compSeq}";

	$(document).ready(function() {
		// 버튼 이벤트
		fnButtonInit();
		
		// 최초 데이터
		fnInitSmsStatis();
		
		// 셀렉 박스 초기 데이터
		fnSelectBoxInit();
	});
	
	// 버튼 이벤트
	function fnButtonInit() {
		// 통계 검색 클릭
		$("#searchButton").click(function() { 
			fnSearchStatis();
		});
		
		// 엑셀파일 저장 버튼 클릭
		$("#excelSaveButton").click(function() {
			fnExcelSave();
		});
	}
	
	// 최초데이터 호출
	function fnInitSmsStatis(selectDate) {
		
		var param = {};
		param.AgentID = agentID;
		param.AgentKey = agentKey;
		param.compSeq = compSeq;
		param.smsDate = smsDate;
		
		$.ajax({
			type : "POST",
			contentType : "application/json; charset=utf-8",
			async : true,
			url : "<c:url value='/api/sms/web/admin/SmsMonthStatis '/>",
			dataType : "json",
			data : JSON.stringify(param),
			success : function(result) {
				//console.log(JSON.stringify(result));
				if(result.resultCode == "0") {
					fnDrawMonthStatis(result);
				} else {
					console.log("데이터 호출 실패");
				}
			},
			error : function(request, status, error) {
				console.log("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}
	
	// 검색 버튼 
	function fnSearchStatis() {
		//var date = $("#monthSelect").val();
		smsDate = $("#monthSelect").val();
		fnInitSmsStatis();
	}
	
	var excelData = '';
	// 문자 통계 그려주기
	function fnDrawMonthStatis(data) {
		var monthTag = '';
		var deptTag = '';
		var year = '';
		var month = '';
		var totalCount = '';
		var totalPoint = '';
		var statisData = data.result.result;
		var monthDate = statisData.smsDate;
		var deptData = statisData.SMSMonthStatisInfoList;
		excelData = deptData;
		
		if(deptData.length > 0) {
			year = smsDate.substring(0,4);
			month = smsDate.substring(4,6);
			totalCount = statisData.totalCount;
			totalPoint = statisData.totalPoint;
		} else {
			year = smsDate.substring(0,4);
			month = smsDate.substring(4,6);
			totalCount = 0;
			totalPoint = 0.0000;
		}
		
		monthTag += '<th>' + year + '년 ' + month + '월 사용 메시지' + '</th>';
		monthTag += '<td>' + totalCount + '건 (' + parseInt(totalPoint) + 'p)</td>';
		
		$("#selectMonthStatis").html(monthTag);

		if(deptData.length > 0) {
			deptTag += '<tr>';
			for(var i=0; i<deptData.length; i++) {
				if((i%2) == 0) {
					deptTag += '<th>' + deptData[i].deptName + '</th>';
					deptTag += '<td>';
					deptTag += '<span class="fl mt5">' + deptData[i].deptCount + '건(' + parseInt(deptData[i].deptPoint) + 'p)</span>';
					//deptTag += '<span class="fl mt5">' + deptCount + '건(' + deptPoint + 'p)</span>';
					deptTag += '<div class="controll_btn fr p0">';
					deptTag += '<button onclick="fnDeptMonthStatisDetail('+"'"+deptData[i].deptSeq+"'"+')">상세보기</button>';
					deptTag += '</div>';
					deptTag += '</td>';	
				} else if((i % 2) == 1){
					deptTag += '<th>' + deptData[i].deptName + '</th>';
					deptTag += '<td>';
					deptTag += '<span class="fl mt5">' + deptData[i].deptCount + '건(' + parseInt(deptData[i].deptPoint) + 'p)</span>';
					//deptTag += '<span class="fl mt5">' + deptCount + '건(' + deptPoint + 'p)</span>';
					deptTag += '<div class="controll_btn fr p0">';
					deptTag += '<button onclick="fnDeptMonthStatisDetail('+"'"+deptData[i].deptSeq+"'"+')">상세보기</button>';
					deptTag += '</div>';
					deptTag += '</td>';
				}
				if ( ( (i % 2) == 1 ) && ( i < deptData.length-1) ){
					deptTag += '</tr><tr>';		
				}
			}
			deptTag += '</tr>';
		}
		$("#deptMonthStatis").html(deptTag);
	}
	
	// 상세보기
	function fnDeptMonthStatisDetail(deptSeq) {
		var urlPath = "api/sms/web/admin/pop/smsDeptMonthDetail";
		var url = "<c:url value='http://"+location.host+"/gw/" + urlPath + "'/>";
		var params = "?agentID=" + agentID + "&agentKey=" + agentKey + "&compSeq=" + compSeq + "&deptSeq=" + deptSeq + "&smsDate=" + smsDate;
		
  		openWindow2(url + params,  "pop", 1000, 711, 0) ;
	}
	
	// 셀렉트 박스 초기 데이터
	function fnSelectBoxInit() {
		var count = 12;
		var selectTag = '';
		var year = parseInt(smsDate.substring(0,4));
		var month = parseInt(smsDate.substring(4,6));
		
		for(var i=0; i<count ; i++) {
			if(month < 10) {
				month = "0" + month;
			}
			
			selectTag += '<option value="' + (year.toString() + month.toString()) + '">' + year + '년 ' + month + '월' + '</option>';
			
			month = parseInt(month) - 1;
			if(month == 0) {
				month = 12;
			}
			
			if(month == 12) {
				year = year - 1;
			}
		}
		
		$("#monthSelect").html(selectTag);
	}
	
	// 엑셀 저장 
	function fnExcelSave() {
		self.location.href="/gw/api/sms/web/admin/excelDownload?AgentID="+agentID+"&AgentKey="+agentKey+"&compSeq="+compSeq+"&smsDate="+smsDate+"&excelSave=Y";
	}
</script>

<!-- 검색박스 -->
<div class="top_box">
	<dl>
		<dt>기간</dt>
		<dd>
			<select id="monthSelect" class="selectmenu" style="width: 120px;">
<!--  
				<option value="" selected="selected">2017년 1월</option>
				<option value="">2017년 2월</option>
				<option value="">2017년 3월</option>
				<option value="">2017년 4월</option>
				<option value="">2017년 5월</option>
				<option value="">2017년 6월</option>
				<option value="">2017년 7월</option>
				<option value="">2017년 8월</option>
				<option value="">2017년 9월</option>
				<option value="">2017년 10월</option>
				<option value="">2017년 11월</option>
				<option value="">2017년 12월</option>
-->
			</select>
		</dd>
		<dd>
			<input type="button" id="searchButton" value="검색" />
		</dd>
	</dl>
</div>

<div class="sub_contents_wrap">

	<!-- 계정 통계 -->
	<div class="btn_div">
		<div class="left_div">
			<h5>계정 통계</h5>
		</div>
		<div class="right_div">
			<div class="controll_btn p0">
				<button id="excelSaveButton">엑셀파일저장</button>
			</div>
		</div>
	</div>
	<div class="com_ta">
		<table>
			<colgroup>
				<col width="25%" />
				<col width="75%" />
			</colgroup>
			<tr id="selectMonthStatis">
<!--  			
				<th>2017년 1월 사용 메시지</th>
				<td>1,444건 (25,992p)</td>
-->
			</tr>
		</table>
	</div>

	<!-- 부서별집계 -->
	<div class="btn_div">
		<div class="left_div">
			<h5>부서별 집계</h5>
		</div>
	</div>

	<div class="com_ta">
		<table>
			<colgroup>
				<col width="130" />
				<col width="" />
				<col width="130" />
				<col width="" />
			</colgroup>
			<tbody id="deptMonthStatis">
<!--  
				<tr>
					<th>A부서</th>
					<td><span class="fl mt5">123 건(1p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
					<th>B부서</th>
					<td><span class="fl mt5">123 건(20168p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
				</tr>
				<tr>
					<th>C부서</th>
					<td><span class="fl mt5">123 건(968p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
					<th>D부서</th>
					<td><span class="fl mt5">123 건(18p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
				</tr>
				<tr>
					<th>E부서</th>
					<td><span class="fl mt5">123 건(1968p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
					<th>F부서</th>
					<td><span class="fl mt5">123 건(1968p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
				</tr>
				<tr>
					<th>G부서</th>
					<td><span class="fl mt5">123 건(1968p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
					<th>H부서</th>
					<td><span class="fl mt5">123 건(1968p)</span>
						<div class="controll_btn fr p0">
							<button id="">상세보기</button>
						</div></td>
				</tr>
-->
			</tbody>
		</table>
	</div>
</div>