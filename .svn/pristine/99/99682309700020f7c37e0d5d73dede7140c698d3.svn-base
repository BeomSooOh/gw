<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	$(document).ready(function() {
		//기본버튼
		$(".controll_btn button").kendoButton();
	
		$("#okBtn").on("click", function() {
			var idx = $('#partnerPmListTable').find('input[type=radio]:checked').val();
			if (idx != null && idx != "") {
				var listJson = $.parseJSON('${pmListJson}');
				
				console.log(listJson[idx]);
				
				opener.callbackPartnerPm(listJson[idx]);
				 
				window.close(); 
				
			}
			else{
				alert("<%=BizboxAMessage.getMessage("TX000014926","담당자를 선택해주세요.")%>");
			}
		});
	
		
		$('#partnerPmListTable').delegate('tr', 'click', function (event) {
			
			
			 $(this).find('input[type=radio]').prop("checked", true);
			 
			 if($(event.target).is('input:checkbox')) {
			  
			 } else {
			 }
		 
		});
	}); 
	
	function fn_list(currentPage){	
	   $("#page").val(currentPage);
       document.form.submit();
	}
	
	function fnClose(){
		window.close();
	}
</script>

<form id="form" name="form" method="post" action="partnerPmListPop.do">
	<input type="hidden" id="page" name="page" value="${params.page}">
	<input type="hidden" id="pageSize" name="pageSize" value="${params.pageSize}">
	<input type="hidden" id="cdPartner" name="cdPartner" value="${params.cdPartner}">
</form>

<div class="pop_wrap resources_reservation_wrap" style="width:598px;">  
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000016392","거래처 담당자 선택")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		</div><!-- //pop_head -->

		<div class="pop_con">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="167"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016080","현재 선택된 거래처")%></th>
						<td>${partnerInfo.lnPartner}</td>
					</tr>
				</table>
			</div>
			
<form id="selectForm" name="selectForm">
			<div class="com_ta2 mt15" style="height:400px">
				<table id="partnerPmListTable">
					<colgroup>
						<col width="37"/>
						<col width="50"/>
						<col width="80"/>
						<col width=""/>
						<col width="90"/>
						<col width="100"/>
						<col width="90"/>
					</colgroup>
					<tr>
						<th></th>
						<th>NO</th>
						<th><%=BizboxAMessage.getMessage("TX000015261","담당자명")%></th>
						<th>E-mail</th>
						<th><%=BizboxAMessage.getMessage("TX000000006","전화")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000008","핸드폰")%></th>
						<th>FAX</th>
					</tr>
					<c:forEach items="${pmList}" var="list" varStatus="c">
					<tr>
						<td>
							<input type="radio" name="inp_chk" id="inp_chk${list.noSeq}" class="k-radio" value="${list.noSeq}"/>
							<label class="k-radio-label radioSel" for="inp_chk${list.noSeq}"></label>
						</td>
						<td>${list.noSeq+1}</td>
						<td>${list.nmPtr}</td>
						<td class="word_b">${list.eMail}</td>
						<td>${list.noTel}</td>
						<td>${list.noHp}</td>
						<td>${list.noFax}</td>
					</tr>
					</c:forEach>
				</table>	
			</div>
</form>

			<div class="paging mt20"> 
			    <ui:pagination paginationInfo="${paginationInfo}" type="bizbox" jsFunction="fn_list" />
			</div> 

		</div><!-- //pop_con -->
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" id="okBtn" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
				<input type="button" onclick="fnClose();" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->