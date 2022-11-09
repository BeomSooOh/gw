<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
	<%@page import="main.web.BizboxAMessage"%>



<script>
	$(document).ready(function() {
		if("${type}" == "H"){
			selectDevHistory();
		}else if("${type}" == "D"){
			opener.gridRead();
		}		
	});
	
	function fnSetStatus() {
		var grid = $("#grid").data("kendoGrid");

		var seqList = "${seqList}";

		var tblParam = {};
		tblParam.seqList = seqList;
		tblParam.status = "C";
		tblParam.desc = $("#desc").val();

		if (seqList != "") {
			$.ajax({
				type : "post",
				url : '<c:url value="/cmm/systemx/setSecondCertDevStatus.do" />',
				datatype : "text",
				data : tblParam,
				success : function(data) {
					alert("<%=BizboxAMessage.getMessage("TX900000063","반려되었습니다.")%>");
					opener.gridRead();
					self.close();
				}
			});
		}

	}
	
	function fnClose(){
		self.close();
	}
	
	
	function selectDevHistory(){
		var tblParam = {};
		tblParam.empSeq = "${targetEmpSeq}";

		$.ajax({
			type : "post",
			url : '<c:url value="/cmm/systemx/selectUserDevHistroyList.do" />',
			datatype : "text",
			data : tblParam,
			success : function(data) {
				setHistoryTable(data.historyList);
			}
		});
	}
	
	
	function setHistoryTable(historyDate){
		
		var Html = '';
		for(var i=0;i<historyDate.length; i++){
			Html += '<tr>';
			Html += '<td>' + (i+1) + '</td>';
			Html += '<td>' + historyDate[i].deviceName + '</td>';
			Html += '<td>' + historyDate[i].appName + '</td>';			
			Html += '<td>' + historyDate[i].statusDate + '</td>';
			if(historyDate[i].status == 'P')
				Html += '<td>' + historyDate[i].confirmDate + '</td>';
			else
				Html += '<td>-</td>';	
			Html += '<td>' + historyDate[i].statusMulti + '</td>';
			if(historyDate[i].status == 'P')
				Html += '<td>' + historyDate[i].empName + '</br>(' + historyDate[i].loginId + ')</td>';
			else
				Html += '<td>-</td>';
			Html += '</tr>';
		}
		$('#tList').html('');
		$('#tList').html(Html);
	}
</script>
    
</head>
<c:if test="${type == null}">
<!-- 	인증기기 해지 및 해지확인 팝업 -->
	<div class="pop_wrap" style="width:443px;">
		<div class="pop_head">
			<c:if test="${seq == null}">
				<h1><%=BizboxAMessage.getMessage("TX000021355","반려사유")%></h1>
			</c:if>
			<c:if test="${seq != null}">
				<h1>Bizbox Alpha</h1>
			</c:if>
		</div>
		
		<div class="pop_con">
			<table class="fwb ac" style="width:100%;">
				<tr>
					<td>
						<c:if test="${seq == null}">
							<input type="text" class="ac" style="width: 90%;" placeholder="<%=BizboxAMessage.getMessage("TX900000533","사유를 입력해주세요.")%>" id="desc"/>
						</c:if>
						<c:if test="${seq != null}">
							<input type="text" class="ac" style="width: 90%;" placeholder="<%=BizboxAMessage.getMessage("TX900000066","사유를 입력하지 않았습니다.")%>" id="desc" readonly="readonly" value="${desc}"/>
						</c:if>
					</td>
				</tr>
			</table>
		</div><!-- //pop_con -->
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<c:if test="${seq == null}">
					<input type="button" value="<%=BizboxAMessage.getMessage("TX000002954","반려")%>" onclick="fnSetStatus();"/>
				</c:if>
				<c:if test="${seq != null}">
					<input type="button" value="<%=BizboxAMessage.getMessage("TX000019752","확인")%>" onclick="fnClose();"/>
				</c:if>
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
</c:if>


<c:if test="${type != null}">	
	<c:if test="${type == 'F'}">
		<!-- 	PIN번호 불일치 팝업 -->
		<div class="pop_wrap" style="width:443px;">
			<div class="pop_head">
				<h1>Bizbox Alpha</h1>
			</div>
		
			<div class="pop_con">
				<table class="fwb ac" style="width:100%;">
					<tr>
						<td>
							<span class="Alertbg al">
								<%=BizboxAMessage.getMessage("TX900000326","PIN번호가 맞지않습니다.")%>
								<br />
								<%=BizboxAMessage.getMessage("TX900000327","다시 확인해주세요.")%>
								<br />
								<span class="text_red"><%=BizboxAMessage.getMessage("TX900000330","비밀번호 오류횟수")%> ${failCount}/5</span>
							</span>		
						</td>
					</tr>
				</table>
			</div><!-- //pop_con -->
		
			<div class="pop_foot">
				<div class="btn_cen pt12">
					<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="fnClose();"/>
				</div>
			</div><!-- //pop_foot -->
		</div><!-- //pop_wrap -->
	</c:if>
	<c:if test="${type == 'O'}">
		<!-- 	PIN번호 입력횟수 초과 팝업 -->
		<div class="pop_wrap" style="width:443px;">
			<div class="pop_head">
				<h1>Bizbox Alpha</h1>
			</div>
		
			<div class="pop_con">
				<table class="fwb ac" style="width:100%;">
					<tr>
						<td>
							<span class="Alertbg al">
								<%=BizboxAMessage.getMessage("TX900000332","PIN번호 입력 횟수 초과로 등록불가합니다.")%><br />
								<%=BizboxAMessage.getMessage("TX900000333","관리자에게 PIN번호 초기화를 요청하세요.")%>
							</span>		
						</td>
					</tr>
				</table>
			</div><!-- //pop_con -->
		
			<div class="pop_foot">
				<div class="btn_cen pt12">
					<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="fnClose();"/>
				</div>
			</div><!-- //pop_foot -->
		</div><!-- //pop_wrap -->
	</c:if>
	
	<c:if test="${type == 'C'}">
		<!-- 	인증기기 승인요청 팝업 -->
		<div class="pop_wrap" style="width:443px;">
		<div class="pop_head">
			<h1>Bizbox Alpha</h1>
		</div>
	
		<div class="pop_con">
			<table class="fwb ac" style="width:100%;">
				<tr>
					<td>
						<span class="Alertbg al">
							<%=BizboxAMessage.getMessage("TX900000328","인증기기에 대해 관리자 승인이 필요합니다.")%>
							<br />
							<span class="text_blue">[ <%=BizboxAMessage.getMessage("TX000000761","요청자")%> : ${empName}, <%=BizboxAMessage.getMessage("TX900000534","요청한 인증기기")%> : ${appName} ]</span>
							<br />
							<%=BizboxAMessage.getMessage("TX900000331","위 정보로 승인요청되어, 관리자에게 문의하세요.")%>
						</span>		
					</td>
				</tr>
			</table>
		</div><!-- //pop_con -->
	
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="fnClose();"/>
			</div>
		</div><!-- //pop_foot -->
		</div><!-- //pop_wrap -->
	</c:if>	
	
	<c:if test="${type == 'D'}">
		<!-- 	인증기기 해지 팝업 -->
		<div class="pop_wrap" style="width:443px;">
		<div class="pop_head">
			<h1>Bizbox Alpha</h1>
		</div>
	
		<div class="pop_con">
			<table class="fwb ac" style="width:100%;">
				<tr>
					<td>
						<span class="Alertbg al">
							<%=BizboxAMessage.getMessage("TX900000072","해지되었습니다.")%>
						</span>		
					</td>
				</tr>
			</table>
		</div><!-- //pop_con -->
	
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="fnClose();"/>
			</div>
		</div><!-- //pop_foot -->
		</div><!-- //pop_wrap -->
	</c:if>
	
	
	<c:if test="${type == 'I'}">
		<!-- 	PIN번호 초기화 확인 팝업 -->
		<div class="pop_wrap" style="width:443px;">
		<div class="pop_head">
			<h1>Bizbox Alpha</h1>
		</div>
	
		<div class="pop_con">
			<table class="fwb ac" style="width:100%;">
				<tr>
					<td>
						<span class="Alertbg al">						
							<span class="text_blue">[ <%=BizboxAMessage.getMessage("TX000000286","사용자")%> : ${empName} ]</span>
							<br />
							<%=BizboxAMessage.getMessage("TX900000073","PIN번호 초기화 완료되었습니다.")%>
						</span>
					</td>
				</tr>
			</table>
		</div><!-- //pop_con -->
	
		<div class="pop_foot no_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="fnClose();"/>
			</div>
		</div><!-- //pop_foot -->
		</div><!-- //pop_wrap -->
	</c:if>
	
	<c:if test="${type == 'H'}">
		<!-- 	인증기기 승인이력 팝업 -->
		<div class="com_ta2 sc_head ml15 mr15">
			<table>
				<colgroup>
					<col width="35"/>
					<col width="150"/>
					<col width="100"/>
					<col width=""/>
					<col width=""/>
					<col width="100"/>
					<col width="100"/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000603","번호")%></th>
					<th><%=BizboxAMessage.getMessage("TX900000535","기기 명칭")%></th>
					<th><%=BizboxAMessage.getMessage("TX900000034","인증기기")%></br>Type</th>
					<th><%=BizboxAMessage.getMessage("TX900000061","요청일시")%></th>
					<th><%=BizboxAMessage.getMessage("TX000007536","승인일시")%></th>
					<th><%=BizboxAMessage.getMessage("TX000018400","승인상태")%></th>
					<th><%=BizboxAMessage.getMessage("TX000021342","승인자")%></br>(ID)</th>					
				</tr>
			</table>
		</div>
		<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc" style="height:390px;overflow-y:scroll;">
			<table>
				<colgroup>
					<col width="35"/>
					<col width="150"/>
					<col width="100"/>
					<col width=""/>
					<col width=""/>
					<col width="100"/>
					<col width="100"/>
				</colgroup>
				<tbody id="tList"></tbody>
			</table>	
		</div>
	</c:if>
</c:if>
</html>