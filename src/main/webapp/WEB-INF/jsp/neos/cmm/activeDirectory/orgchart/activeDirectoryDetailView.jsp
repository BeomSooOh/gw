<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	var erpSyncUseYn = '${erpSyncUseYn}';
	
	$(document).ready(function() {
		//기본버튼
	    $(".controll_btn button").kendoButton();
	
		var companyData = null; 
		
		<c:if test="${not empty compListJson}">
			companyData = ${compListJson};
		</c:if>
		
		 //회사 셀렉트박스
	    $("#compSeq").kendoComboBox({
	        dataSource : companyData, 
	        dataTextField: "compName",
	        dataValueField: "compSeq",
	         value:"${params.compSeq}",
	        change: compChange,
	        filter: "contains",
	        suggest: true
	    });
	    
	    //동기화방식 셀렉트박스
	    $("#autoYn").kendoComboBox({
	        dataSource : {
				data : [{text:"전체", value:""},{text:"수동", value:"N"}/*, {text:"자동", value:"Y"}*/]
	        },
	        dataTextField: "text",
	        dataValueField: "value",
	        value:"${params.autoYn}",
	        index:0
	    });
		    
	    //시작날짜
	    $("#startDate").kendoDatePicker({
	    	format: "yyyy-MM-dd",
	    	culture:"ko-KR",
	    	value:'${params.startDate}'
	    });
	    
	    //종료날짜
	    $("#endDate").kendoDatePicker({
	    	format: "yyyy-MM-dd",
	    	culture:"ko-KR",
	    	value:'${params.endDate}'
	    });
	    
	    //검색버튼
	    $(".btn_search").on("click",function(){
	    	$("#page").val("1");
	    	
	    	form.action = "<c:url value='/activeDirectory/orgchart/activeDirectoryDetailView.do'/>";
	    	
	    	 form.submit();
		});
	    
	    
	    $("#btnOrgSet").on("click",function(){
	    	$("#selectCompSeq").val($("#compSeq").val());
	    	var pop = window.open("", "orgSetPop", "width=904,height=782,scrollbars=no");
			popForm.target = "orgSetPop";
			popForm.method = "post"; 
			popForm.action = "<c:url value='/activeDirectory/orgchart/activeDirectoryOrgchartDataSetPop.do'/>";
			popForm.submit();
			pop.focus();
	    
	    	
		});
	});
	
	function compChange(e) {
		
	}
	
	function fn_list(currentPage){	
	   $("#page").val(currentPage);
	   document.form.submit();
	}
	
	function firstList(){	
	   $("#page").val("1");
	   document.form.submit();
	}
</script>


<form id="form" name="form" method="post" action="activeDirectoryDetailView.do">
	<input type="hidden" id="page" name="page" value="${params.page}" />
	<div class="top_box">
		<dl>
			<dt><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
			<dd>
				<input id="compSeq" name="compSeq" value="${params.compSeq}" />
			</dd>
			<dt><%=BizboxAMessage.getMessage("TX900000244","동기화방식")%></dt>
			<dd>
				<input type="text" class="" id="autoYn" name="autoYn"
					style="width: 160px;" />
			</dd>
			<dd>
				<input id="" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
			</dd>
		</dl>
		<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX900000378","기간검색")%> <img id="all_menu_btn"
			src='<c:url value="/Images/ico/ico_btn_arr_down01.png"/>' /></span>
	</div>

	<div class="SearchDetail">
		<dl>
			<dt class="ar"><%=BizboxAMessage.getMessage("TX000000696","기간")%></dt>
			<dd>
				<input id="startDate" name="startDate" value="${params.startDate}" class="dpWid" /> ~ <input id="endDate" name="endDate" value="${params.endDate}" class="dpWid" />
			</dd>
			<dd>
				<span class="dod_search mr26"><a href="#" class="btn_sear"></a></span>
			</dd>
		</dl>
	</div>
</form>
<div class="sub_contents_wrap">
	<div class="controll_btn p0 mt10">
		<button type="button" id="btnOrgSet" class=""><%=BizboxAMessage.getMessage("TX000020528", "조직도 동기화")%></button>
	</div>
	<div class="btn_div">
		<!-- <div class="left_div">
			<p class="tit_p m0">실사용자 :  GW [ <span class="text_blue">100</span> / 200 ] ,  Mail [ <span class="text_blue">2</span> / 10 ] ,  비라이선스 [ <span class="text_blue">3</span> ]</p>
		</div> -->

		<!-- <div class="right_div">
			<p class="tit_p m0">자동 동기화 : <span class="text_blue">사용 중</span></p>	
		</div> -->
	</div>

	<!-- 테이블 -->
	<div class="com_ta2">
		<table>
			<colgroup>
				<col width="34" />
				<col width="" />
				<col width="" />
				<col width="75" />
				<col width="75" />
				<col width="75" />
				<col width="75" />
				<col width="75" />
				<col width="75" />
				<col width="75" />
				<col width="90" />
			</colgroup>
			<tr>
				<th rowspan="2"><%=BizboxAMessage.getMessage(null,"NO")%></th>
				<th rowspan="2"><%=BizboxAMessage.getMessage("TX000021270","회사")%></th>
				<th rowspan="2"><%=BizboxAMessage.getMessage("TX000007571","일시")%></th>
				<th rowspan="2"><%=BizboxAMessage.getMessage("TX900000244","동기화방식")%></th>
				<th colspan="2"><%=BizboxAMessage.getMessage("TX000021936","부서 반영결과")%></th>
				<th colspan="3"><%=BizboxAMessage.getMessage("TX000021937","사용자 반영결과")%></th>
				<th colspan="2"><%=BizboxAMessage.getMessage("TX900000379","담당자 정보")%></th>
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000003101","신규")%></th>
				<th><%=BizboxAMessage.getMessage("TX000003226","변경")%></th>
				<th><%=BizboxAMessage.getMessage("TX000021938","입사")%></th>
				<th><%=BizboxAMessage.getMessage("TX000012773","퇴사")%></th>
				<th><%=BizboxAMessage.getMessage("TX000003226","변경")%></th>
				<th><%=BizboxAMessage.getMessage("TX000021265","사용자명")%></th>
				<th><%=BizboxAMessage.getMessage("TX900000380","IP정보")%></th>
			</tr>

			<c:if test="${empty detailList}">
				<tr>
					<td class="cen" colspan="11"><%=BizboxAMessage.getMessage("TX000001063","데이터가 없습니다.")%></td>
				</tr>
			</c:if>
			<c:if test="${not empty detailList}">
				<c:forEach items="${detailList}" var="list">
					<tr>
						<td class="">${list.syncSeq}</td>
						<td class="">${list.compName}</td>
						<td class="">${list.syncDate}</td>
						<td class="">
							<c:if test="${list.autoYn == 'Y'}"><%=BizboxAMessage.getMessage("TX000012458","자동")%></c:if> 
							<c:if test="${list.autoYn != 'Y'}"><%=BizboxAMessage.getMessage("TX000012459","수동")%></c:if>
						</td>
						<td class="">${list.deptJoinCnt}</td>
						<td class="">${list.deptModifyCnt}</td>
						<td class="">${list.empJoinCnt}</td>
						<td class="">${list.empResignCnt}</td>
						<td class="">${list.empModifyCnt}</td>
						<td class="">${list.empName}</td>
						<td class="">${list.createIp}</td>
					</tr>
				</c:forEach>
			</c:if>
		</table>
	</div>

	<div class="paging mt30">
		<ui:pagination paginationInfo="${paginationInfo}" type="bizbox" jsFunction="fn_list" />
	</div>

	<form id="popForm" name="popForm" method="post">
		<input type="hidden" id="selectCompSeq" name="selectCompSeq" value="${params.compSeq}" />
	</form>