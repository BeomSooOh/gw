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

<script type="text/javascript" src='<c:url value="/js/datatables/jquery.dataTables.min.js"></c:url>'></script>

<script type="text/javascript">
	var smsDate = "${result.smsDate}";
	var agentID = "${result.agentID}";
	var agentKey = "${result.agentKey}";
	var compSeq = "${result.compSeq}";
	var deptSeq = "${result.deptSeq}";


	$(document).ready(function(){
		// 팝업 사이트 조절
		fnSetResize();
		
		// 상세조회 데이터 가져오기
		fnGetSmsDeptMonthStatis();
		
		$("#closeButton").click(function(){
			self.close();
		});
	});
	
	// 팝업 크기 조절
	function fnSetResize() {		
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
	
	// 상세조회 데이터 가져오기
	function fnGetSmsDeptMonthStatis() {
		var param = {};
		param.AgentID = agentID;
		param.AgentKey = agentKey;
		param.compSeq = compSeq;
		param.smsDate = smsDate;
		param.deptSeq = deptSeq;
		
		$.ajax({
			type : "POST",
			contentType : "application/json; charset=utf-8",
			async : true,
			url : "<c:url value='/api/sms/web/admin/SmsDeptMonthStatisDetail '/>",
			dataType : "json",
			data : JSON.stringify(param),
			success : function(result) {
				//console.log(JSON.stringify(result));
				if(result.resultCode == "0") {
					fnDrawDetailStatis(result.result.result.SMSMonthStatisDetailList);
				}
			},
			error : function(request, status, error) {
				console.log("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}
	
	// 부서 상세 보여주기
	function fnDrawDetailStatis(data) {
		console.log(JSON.stringify(data));
		var columnDefs = [
     			{
     				"targets" : 0,
     				"data" : null,
     				"render" : function(data) {
     					console.log(JSON.stringify(data));
     					return '<span>'+ data.deptName +'</span>';
     				}
     			},{
     				"targets" : 1,
     				"data" : null,
     				"render" : function(data) {
     					return '<span>'+ data.empName +'</span>';
     				}
     			},{
     				"targets" : 2,
     				"data" : null,
     				"render" : function(data) {
     					var year = data.smsDate.substring(0,4);
     					var month = data.smsDate.substring(4,6);
     					
     					return '<span>'+ year + '년 ' + month + '월</span>';
     				}
     			},{
     				"targets" : 3,
     				"data" : null,
     				"render" : function(data) {
     					var userCount = data.userCount;
     					var userPoint = data.userPoint;
     					return '<span>'+ data.userCount +'(' + parseInt(userPoint) + 'p)</span>';
     				}
     			}
     		];
		
		var columns = [
   				{
	   				"sTitle" : "부서",
	   				"bVisible" : true,
	   				"bSortable" : false,
	   				"sWidth" : ""
	   			}, {
	   				"sTitle" : "이름",
	   				"bVisible" : true,
	   				"bSortable" : false,
	   				"sWidth" : ""
	   			}, {
	   				"sTitle" : "월 별 이용 건 수 ",
	   				"bVisible" : true,
	   				"bSortable" : false,
	   				"sWidth" : ""
	   			}, {
	   				"sTitle" : "사용 건 수 (포인트)",
	   				"bVisible" : true,
	   				"bSortable" : false,
	   				"sWidth" : ""
	   			}
	   		];
		
			oTable = $('#smsDeptDetailStatis').dataTable({
				select : true,
				bAutoWidth : false,
				"sScrollY": "600px",
				destroy : true,
				lengthMenu : [ [ 10, 20, 30, 40, 50 ], [ 10, 20, 30, 40, 50 ] ],
				data : data,
				columnDefs : columnDefs || [],
				aoColumns : columns || '',
				bSort : false,
				paging : true,
			});
		
			
		}
		
	</script>

<div class="pop_wrap" id="" style="width: 698px;">
	<div class="pop_head">
		<h1>부서 상세 조회</h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">
		<div class="com_ta2 bg_lightgray" style="height: 408px;">

			<table id="smsDeptDetailStatis">
				<colgroup>
					<col width="150" />
					<col width="125" />
					<col width="125" />
					<col width="" />
				</colgroup>
<!--  
				<tr>
					<th>부서</th>
					<th>직급(직책)</th>
					<th>이름</th>
					<th>월 별 이용 건 수</th>
					<th>사용 건 수(포인트)</th>
-->
					<!-- 수신번호 -->
<!--  					
				</tr>
				<tr>
					<td>이러닝교육팀</td>
					<td>부장</td>
					<td>박상중</td>
					<td>2017년1월</td>
					<td>10(180p)</td>
				</tr>
				<tr>
					<td>이러닝교육팀</td>
					<td>부장</td>
					<td>박상중</td>
					<td>2017년1월</td>
					<td>10(180p)</td>
				</tr>
				<tr>
					<td>이러닝교육팀</td>
					<td>부장</td>
					<td>박상중</td>
					<td>2017년1월</td>
					<td>10(180p)</td>
				</tr>
				<tr>
					<td>이러닝교육팀</td>
					<td>부장</td>
					<td>박상중</td>
					<td>2017년1월</td>
					<td>10(180p)</td>
				</tr>
				<tr>
					<td>이러닝교육팀</td>
					<td>부장</td>
					<td>박상중</td>
					<td>2017년1월</td>
					<td>10(180p)</td>
				</tr>
-->
				<!-- <tr>
						<td colspan="3">조회 된 내역이 없습니다.</td>
					</tr> -->


			</table>
		</div>
<!--  
		<div class="paging mt20">
			<span class="pre_pre"><a href="">10페이지전</a></span> <span class="pre"><a
				href="">이전</a></span>
			<ol>
				<li class="on"><a href="">1</a></li>
				<li><a href="">2</a></li>
				<li><a href="">3</a></li>
				<li><a href="">4</a></li>
				<li><a href="">5</a></li>
				<li><a href="">6</a></li>
				<li><a href="">7</a></li>
				<li><a href="">8</a></li>
				<li><a href="">9</a></li>
				<li><a href="">10</a></li>
			</ol>
			<span class="nex"><a href="">다음</a></span> <span class="nex_nex"><a
				href="">10페이지다음</a></span>
		</div>
-->
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="closeButton" value="닫기" />
		</div>
	</div>
	<!-- //pop_foot -->

</div>
<!-- //pop_wrap -->