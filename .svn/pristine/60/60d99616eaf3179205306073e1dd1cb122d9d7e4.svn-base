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

		    //동기화방식 셀렉트박스
		    $("#autoYn").kendoComboBox({
		        dataSource : {
					data : [{text:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:""},{text:"<%=BizboxAMessage.getMessage("TX000012459","수동")%>", value:"N"}, {text:"<%=BizboxAMessage.getMessage("TX000019828","자동")%>", value:"Y"}]
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
		    	
		    	form.action = "<c:url value='/erp/orgchart/erpSyncCompDetailView.do'/>";
		    	
		    	 form.submit();
			});
		    
		  <%--   $("#btnBaseSet").on("click",function(){
		    	if(getErpCmmOption() == '1') {
			    	$("#selectCompSeq").val($("#compSeq").val());
			    	var pop = window.open("", "baseSetPop", "width=616,height=200,scrollbars=no");
					popForm.target = "baseSetPop";
					popForm.method = "post"; 
					popForm.action = "<c:url value='/erp/orgchart/erpSyncBaseDataSetPop.do'/>";
					popForm.submit();
					pop.focus(); 
		    	} else {
		    		alert('<%=BizboxAMessage.getMessage(null,"ERP 조직도 연동 미사용입니다.\\n공통옵션설정을 확인해주세요.")%>');
		    	}
			});
		     --%>
		     
		    $("#btnCompSet").on("click",function(){
		    	if(checkBaseData() == 'Y') {
			    	var pop = window.open("", "orgSetPop", "width=904,height=782,scrollbars=no");
					popForm.target = "compSetPop";
					popForm.method = "post"; 
					popForm.action = "<c:url value='/erp/orgchart/erpSyncCompDataSetPop.do'/>";
					popForm.submit();
					pop.focus();
		    		
		    	} else {
		    		alert('<%=BizboxAMessage.getMessage("TX900000418","회사 동기화 기능을 사용하지 않습니다.")%>');
		    	}
		    	
			});
		    
		    <%-- $("#btnOrgAutoSet").on("click", function() {
		    	$("#selectCompSeq").val($("#compSeq").val());
		    	if(getErpCmmOption() == '1' && checkBaseData() == 'Y') {
		    		$("#selectCompSeq").val($("#compSeq").val());
			    	var pop = window.open("", "orgAutoSetPop", "width=690,height=313,scrollbars=no");
					popForm.target = "orgAutoSetPop";
					popForm.method = "post"; 
					popForm.action = "<c:url value='/erp/orgchart/pop/erpSyncAutoSetPop.do'/>";
					popForm.submit();
					pop.focus(); 
		    	} else {
		    		if(getErpCmmOption() != '1') {
		    			alert('<%=BizboxAMessage.getMessage(null,"ERP 조직도 연동 미사용입니다.\\n공통옵션설정을 확인해주세요.")%>');	
		    		} 
		    		if(checkBaseData() != 'Y') {
		    			alert('<%=BizboxAMessage.getMessage(null,"연동된 정보가 없습니다.\\n연동정보를 확인하여 주세요.")%>');
		    		}
		    		
		    	}
		    }); --%>
		    
		    /* $("#autoSet").on("click", function(){
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
		}); */
		
		function checkBaseData() {
			var bool = true;
			
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
	

				<form id="form" name="form" method="post" action="erpSyncCompDetailView.do">	
					<input type="hidden" id="page" name="page" value="${params.page}" />			
						<div class="top_box">
							<dl> 
								<dt><%=BizboxAMessage.getMessage("TX900000244","동기화방식")%></dt>
								<dd><input class="" id="autoYn" name="autoYn"  style="width:160px;" /></dd>
								<dd><input id="" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"/></dd>
							</dl>
							<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX900000378","기간검색")%> <img id="all_menu_btn" src='<c:url value="/Images/ico/ico_btn_arr_down01.png"/>'/></span>
						</div>
						
						<div class="SearchDetail">
							<dl>
								<dt class="ar"><%=BizboxAMessage.getMessage("TX000021340","기간")%></dt>
								<dd><input id="startDate" name="startDate" value="${params.startDate}" class="dpWid"/> ~ <input id="endDate" name="endDate" value="${params.endDate}" class="dpWid"/>	</dd>
								<dd>
									<span class="dod_search mr26"><a href="#" class="btn_sear"></a></span>
								</dd>
							</dl>
						</div>	
				</form>		
						<div class="sub_contents_wrap">
							<div class="controll_btn p0 mt10" >
								<button type="button" id="btnCompSet" class=""><%=BizboxAMessage.getMessage("TX900000419","회사 동기화")%></button>
								<%-- <button type="button" id="btnOrgAutoSet" class=""><%=BizboxAMessage.getMessage("","자동 동기화 설정")%></button> --%>
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
										<col width="34"/>
										<col width=""/>
										<col width=""/>
										<col width="75"/>
										<col width="75"/>
										<col width="75"/>
										<col width="75"/>
										<col width="90"/>
									</colgroup>
									<tr>
										<th rowspan="2">NO</th>
										<th rowspan="2"><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
										<th rowspan="2"><%=BizboxAMessage.getMessage("TX000007571","일시")%></th>
										<th rowspan="2"><%=BizboxAMessage.getMessage("TX900000244","동기화방식")%></th>
										<th colspan="2"><%=BizboxAMessage.getMessage("TX900000420","회사 반영결과")%></th>
										<th colspan="2"><%=BizboxAMessage.getMessage("TX900000379","담당자 정보")%></th>
									</tr>
									<tr>
										<th><%=BizboxAMessage.getMessage("TX000003101","신규")%></th>
										<th><%=BizboxAMessage.getMessage("TX000003226","변경")%></th> 
										<th><%=BizboxAMessage.getMessage("TX000021265","사용자명")%></th>
										<th><%=BizboxAMessage.getMessage("TX900000380","IP정보")%></th>
									</tr>
									
									<c:if test="${empty detailList}">
									<tr>
										<td class="cen" colspan="8"><%=BizboxAMessage.getMessage("TX000001063","데이터가 없습니다.")%></td>
									</tr>
									</c:if>
									<c:if test="${not empty detailList}">
										<c:forEach items="${detailList}" var="list">
											<tr>
												<td class="">${list.syncSeq}</td>
												<td class="">${list.groupName}</td>
												<td class="">${list.syncDate}</td>
												<td class="">
													<c:if test="${list.autoYn == 'Y'}"><%=BizboxAMessage.getMessage("TX000012458","자동")%></c:if>
													<c:if test="${list.autoYn != 'Y'}"><%=BizboxAMessage.getMessage("TX000012459","수동")%></c:if>
												</td>
												<td class="">${list.compJoinCnt}</td>
												<td class="">${list.compModifyCnt}</td>
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
			<%-- <input type="hidden" id="selectCompSeq" name="selectCompSeq" value="${params.compSeq}" /> --%>
		</form>