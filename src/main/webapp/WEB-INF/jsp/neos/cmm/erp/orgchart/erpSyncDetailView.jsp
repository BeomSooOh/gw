<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
					data : [{text:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:""},{text:"<%=BizboxAMessage.getMessage("TX000012459","수동")%>", value:"N"}, {text:"<%=BizboxAMessage.getMessage("TX000012458","자동")%>", value:"Y"}]
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
		    
		    $(".btn_search").on("click",function(){
		    	$("#page").val("1");
		    	
		    	form.action = "<c:url value='/erp/orgchart/erpSyncDetailView.do'/>";
		    	
		    	 form.submit();
			});
		    
		    $("#btnBaseSet").on("click",function(){
		    	if(getErpCmmOption() == '1') {
			    	$("#selectCompSeq").val($("#compSeq").val());
			    	var pop = openWindow2("", "baseSetPop", setPopWidth(646), setPopHeight(527), 1, 1); 
					popForm.target = "baseSetPop";
					popForm.method = "post"; 
					popForm.action = "<c:url value='/erp/orgchart/erpSyncBaseDataSetPop.do'/>";
					popForm.submit();
					pop.focus(); 
		    	} else {
		    		alert("<%=BizboxAMessage.getMessage("TX900000210","ERP 조직도 연동 미사용입니다.")%>\n<%=BizboxAMessage.getMessage("TX900000211","공통옵션설정을 확인해주세요.")%>");
		    	}
			});
		    
		    $("#btnOrgSet").on("click",function(){
		    	$("#selectCompSeq").val($("#compSeq").val());
		    	
		    	var baseDataFlag = checkBaseData();
		    	
		    	if(baseDataFlag == 'Y' && getErpCmmOption() == '1') {
			    	var pop = openWindow2("", "orgSetPop", setPopWidth(900 ), setPopHeight(797), 1, 1); 
					popForm.target = "orgSetPop";
					popForm.method = "post"; 
					popForm.action = "<c:url value='/erp/orgchart/erpSyncOrgchartDataSetPop.do'/>";
					popForm.submit();
					pop.focus();
		    		
		    	} else {
		    		if(getErpCmmOption() != '1'){
		    			alert("<%=BizboxAMessage.getMessage("TX900000210","ERP 조직도 연동 미사용입니다.")%>\n<%=BizboxAMessage.getMessage("TX900000211","공통옵션설정을 확인해주세요.")%>");
		    		}else if(baseDataFlag != 'Y'){
		    			alert("<%=BizboxAMessage.getMessage("","기초설정 정보가 없습니다.")%>\n<%=BizboxAMessage.getMessage("","기초설정 작업 후 확인하여 주세요.")%>");
		    		}else{
		    			alert("<%=BizboxAMessage.getMessage("TX900000212","연동된 정보가 없습니다.")%>\n<%=BizboxAMessage.getMessage("TX900000213","연동정보를 확인하여 주세요.")%>");
		    		}
		    	}
		    	
			});
		    
		    $("#btnOrgAutoSet").on("click", function() {
		    	$("#selectCompSeq").val($("#compSeq").val());
		    	
				var baseDataFlag = checkBaseData();		    
		    	
		    	if(getErpCmmOption() == '1' && baseDataFlag == 'Y') {
		    		$("#selectCompSeq").val($("#compSeq").val());
			    	var pop = openWindow2("",  "orgAutoSetPop", 690, setPopHeight(450), 1, 1) ;
					popForm.target = "orgAutoSetPop";
					popForm.method = "post"; 
					popForm.action = "<c:url value='/erp/orgchart/pop/erpSyncAutoSetPop.do'/>";
					popForm.submit();
					pop.focus(); 
		    	} else {
		    		if(getErpCmmOption() != '1') {
		    			alert("<%=BizboxAMessage.getMessage("TX900000210","ERP 조직도 연동 미사용입니다.")%>\n<%=BizboxAMessage.getMessage("TX900000211","공통옵션설정을 확인해주세요.")%>");
		    		}else if(baseDataFlag != 'Y'){
		    			alert("<%=BizboxAMessage.getMessage("","기초설정 정보가 없습니다.")%>\n<%=BizboxAMessage.getMessage("","기초설정 작업 후 확인하여 주세요.")%>");
		    		}else{
		    			alert("<%=BizboxAMessage.getMessage("TX900000212","연동된 정보가 없습니다.")%>\n<%=BizboxAMessage.getMessage("TX900000213","연동정보를 확인하여 주세요.")%>");
		    		}
		    		
		    	}
		    });
		    
		    $("#autoSet").on("click", function(){
		    	$.ajax({
		    		type:"post",
		 			url:"erpSyncAuto.do",
		 			datatype:"json",
		 			async:false,
		 			data: {compSeq:$("#compSeq").val()},
		 			success:function(data){
		 				
		 			},			
		 			error : function(e){
		 				alert("checkBaseData error");	
		 			}
		    	});
		    });
		    
		    if("${autoSyncInfo.scheduleType}" != "" && "${autoSyncInfo.scheduleType}" != "0"){
		    	$("#btnOrgSet").attr("disabled","disabled");
		    	$("#autoTag").html("자동동기화 : 사용중");
		    }
		});
		
		function checkBaseData() {
			var bool = false;
			$.ajax({
	 			type:"post",
	 			url:"erpSyncChkBaseData.do",
	 			datatype:"json",
	 			async:false,
	 			data: {compSeq:$("#compSeq").val(), codeType:'40'},
	 			success:function(data){
	 				bool = data.baseDataYn;
	 			},			
	 			error : function(e){
	 				alert("checkBaseData error");	
	 			}
	 		});	
			return bool;
		}
		
		function getErpCmmOption() {
			var v = '';
			$.ajax({
	 			type:"post",
	 			url:"<c:url value='/cmm/system/getErpOptionValue.do'/>",
	 			datatype:"json",
	 			async:false,
	 			data: {compSeq:$("#compSeq").val(), option:"cm1100"},
	 			success:function(data){
	 				v = data.option.optionRealValue;
	 			},			
	 			error : function(e){
	 				alert("getErpCmmOption error");	
	 			}
	 		});	
			return v;
		}
		
		function compChange(e) {
			$("#page").val("1");
	    	form.action = "<c:url value='/erp/orgchart/erpSyncDetailView.do'/>";
	    	form.submit();
		}
		
		function fn_list(currentPage){	
		   $("#page").val(currentPage);
		   document.form.submit();
		}
		
		function firstList(){	
		   $("#page").val("1");
		   document.form.submit();
		}
		
		
		//브라우저별 팝업 높이사이즈 조정(크롬기준으로 변경처리)
		function setPopHeight(height){
			
			var agent = navigator.userAgent.toLowerCase();

			if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {		  
				// 익스플로러 체크
				return height-1;
			}else if (agent.indexOf("chrome") != -1) {
				// 크롬 체크
				return height;
			}else if (agent.indexOf("firefox") != -1) {
				// 파이어폭스 체크
				return height+3;
			}
		}
		
		//브라우저별 팝업 너비사이즈 조정(크롬기준으로 변경처리)
		function setPopWidth(width){

			var agent = navigator.userAgent.toLowerCase();

			if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {		  
				// 익스플로러 체크
				return width-4;
			}else if (agent.indexOf("chrome") != -1) {
				// 크롬 체크
				return width;
			}else if (agent.indexOf("firefox") != -1) {
				// 파이어폭스 체크
				return width;
			}
		}
		
	</script>	
				<form id="form" name="form" method="post" action="erpSyncDetailView.do">	
					<input type="hidden" id="page" name="page" value="${params.page}" />			
						<div class="top_box">
							<dl> 
								<dt><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
								<dd><input  id="compSeq" name="compSeq" value="${params.compSeq}" /></dd>
								<dt><%=BizboxAMessage.getMessage("TX000016175","연동방식")%></dt>
								<dd><input type="text" class=""id="autoYn" name="autoYn"  style="width:160px;" /></dd>
								<dd><input id="" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"/></dd>
							</dl>
							<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='<c:url value="/Images/ico/ico_btn_arr_down01.png"/>'/></span>
						</div>
						
						<div class="SearchDetail">
							<dl>
								<dt class="ar"><%=BizboxAMessage.getMessage("TX000000696","기간")%></dt>
								<dd><input id="startDate" name="startDate" value="${params.startDate}" class="dpWid"/> ~ <input id="endDate" name="endDate" value="${params.endDate}" class="dpWid"/>	</dd>
								<dd>
									<span class="dod_search mr26"><a href="#" class="btn_sear"></a></span>
								</dd>
							</dl>
						</div>	
				</form>		
						<div class="sub_contents_wrap">
							
							<div class="btn_div" style="margin-bottom:15px;">
							<div class="right_div">
								<div class="controll_btn p0 mt10" >
									<span class="text_blue" id="autoTag" style="margin-right:25px;float:left;margin-top:6px"></span>
									<button type="button" id="btnBaseSet" class=""><%=BizboxAMessage.getMessage("TX000020527","기초 설정")%></button>
									<button type="button" id="btnOrgSet" class=""><%=BizboxAMessage.getMessage("TX000020528","조직도 동기화")%></button>
									<button type="button" id="btnOrgAutoSet" class=""><%=BizboxAMessage.getMessage("TX000020529","자동 동기화 설정")%></button>
								</div>
							</div>
							</div>
							
							<!-- 테이블 -->
							<div class="com_ta2">
								<table>
									<colgroup>
										<col width="100"/>
										<col width=""/>
										<col width=""/>
										<col width="75"/>
										<col width="75"/>
										<col width="75"/>
										<col width="75"/>
										<col width="75"/>
										<col width="75"/>
										<col width="75"/>
										<col width="90"/>
									</colgroup>
									<tr>
										<th rowspan="2">NO</th>
										<th rowspan="2"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
										<th rowspan="2"><%=BizboxAMessage.getMessage("TX000007571","일시")%></th>
										<th rowspan="2"><%=BizboxAMessage.getMessage("TX000016175","연동방식")%></th>
										<th colspan="2"><%=BizboxAMessage.getMessage("TX000021936","부서 반영결과")%></th>
										<th colspan="3"><%=BizboxAMessage.getMessage("TX000021937","사용자 반영결과")%></th>
										<th colspan="2"><%=BizboxAMessage.getMessage("TX000018368","담당자")%></th>
									</tr>
									<tr>
										<th><%=BizboxAMessage.getMessage("TX000003101","신규")%></th>
										<th><%=BizboxAMessage.getMessage("TX000003226","변경")%></th>
										<th><%=BizboxAMessage.getMessage("TX000021938","입사")%></th>
										<th><%=BizboxAMessage.getMessage("TX000012773","퇴사")%></th>
										<th><%=BizboxAMessage.getMessage("TX000003226","변경")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000150","사용자명")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000236","로그인IP")%></th>
									</tr>
									
									<c:if test="${empty detailList}">
									<tr>
										<td class="cen" colspan="11"><%=BizboxAMessage.getMessage("TX000001063","데이터가 없습니다.")%></td>
									</tr>
									</c:if>
									<c:if test="${not empty detailList}">
										<c:forEach items="${detailList}" var="list">
											<tr>
												<td class="">${list.rownum}</td>
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
		