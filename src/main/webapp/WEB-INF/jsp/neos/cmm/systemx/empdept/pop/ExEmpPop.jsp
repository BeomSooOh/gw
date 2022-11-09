<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<script type="text/javascript" src='<c:url value="/js/datatables/jquery.dataTables.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.select.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.scroller.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.rowReorder.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.fixedHea검색er.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ex/CommonEX.js"></c:url>'></script>

	<script type="text/javascript">		
	
	$(document).ready(function() {
		if("${result}" != ""){
			alert("${result}");
			self.close();
		}
		fnSearch();
	});
	function fnSearch(){
		var tblParam = {};
		tblParam.erpCompSeq = $("#erpCompSeq").val();
		tblParam.searchStr = $("#txtSearchStr").val();
		tblParam.groupSeq = "${groupSeq}";
		tblParam.compSeq = "${compSeq}";
		
		$.ajax({
        	type:"post",
    		url:'<c:url value="/cmm/systemx/getExEmpList.do"/>',
    		datatype:"json",
    		data: tblParam ,
    		contenttype: "application/json;",
    		success: function (data) {
				setExEmpListTable(data.empList);
		    } ,
		    error: function (result) { 
    		}
    	});
	}

	function setExEmpListTable(empList){
		var innerHTML = "";
		$("#exEmpListTable").html("");
		for(var i=0;i<empList.length;i++){
			innerHTML += "<tr ondblclick='fnDblclick(this)' onclick='fnclick(this)' id='" + empList[i].erpEmpSeq + "'>";
			if(empList[i].erpEmpName != null){
				innerHTML += "<td>" + empList[i].erpEmpSeq + "</td>";
				innerHTML += "<td>" + empList[i].erpEmpName + "</td>";
			}else{
				innerHTML += "<td>" + empList[i].erpEmpSeq + "</td>";
				innerHTML += "<td>" + empList[i].erpEmpNm + "</td>";
			}
			innerHTML += "</tr>";
		}
		$("#exEmpListTable").html(innerHTML);
	}
	
	function fnDblclick(e){
		//선택 erp사번 중복 조회
		var tblParam = {};
		tblParam.compSeq = "${compSeq}";
		tblParam.empErpNo = e.id;
		tblParam.empSeq = "${empSeq}";
		$.ajax({
        	type:"post",
    		url:'<c:url value="/cmm/systemx/getExEmpNoList.do"/>',
    		datatype:"json",
    		data: tblParam ,
    		contenttype: "application/json;",
    		success: function (data) {
    			if(data.result.cnt == "0"){
    				opener.setEmpErpNo(e.id, $("#erpCompSeq").val());
    				self.close();
    			}else{
    				//alert("다른 사용자가 사용중인 ERP사번 입니다.\n중복 등록 할 수 없습니다.\n[사용중인 사원 : " + data.result.empName + "(" + data.result.loginId + ")]");
    				var empInfo = data.result.empName + "(" + data.result.loginId + ")";
    				var url = "<c:url value='/cmm/systemx/erpEmpNoCheckPop.do'/>?empInfo=" + encodeURI(empInfo);    
    				opener.openWindow2(url,  "erpEmpNoCheckPop", 442, 163, 0) ;    			
    				self.close();
    			}
		    } ,
		    error: function (result) { 
    		}
    	});
	}
	
	function fnclick(e){
		var table = document.getElementById("empListTable");
		var tr = table.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		e.style.backgroundColor = "#E6F4FF";
		
		$("#empErpNo").val(e.id);		
	}
	
	function ok(){
		
		//선택 erp사번 중복 조회
		var tblParam = {};
		tblParam.compSeq = "${compSeq}";
		tblParam.empErpNo = $("#empErpNo").val();
		tblParam.empSeq = "${empSeq}";
		
		if($("#empErpNo").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000457","사번을 선택해 주세요.")%>");
			return;
		}
		
		$.ajax({
        	type:"post",
    		url:'<c:url value="/cmm/systemx/getExEmpNoList.do"/>',
    		datatype:"json",
    		data: tblParam ,
    		contenttype: "application/json;",
    		success: function (data) {
    			if(data.result.cnt == "0"){
    				var empErpNo = $("#empErpNo").val();
    				opener.setEmpErpNo(empErpNo, $("#erpCompSeq").val());
    				self.close();
    			}else{
    				//alert("다른 사용자가 사용중인 ERP사번 입니다.\n중복 등록 할 수 없습니다.\n[사용중인 사원 : " + data.result.empName + "(" + data.result.loginId + ")]");
    				var empInfo = data.result.empName + "(" + data.result.loginId + ")";
    				var url = "<c:url value='/cmm/systemx/erpEmpNoCheckPop.do'/>?empInfo=" + encodeURI(empInfo);     
    				opener.openWindow2(url,  "erpEmpNoCheckPop", 442, 163, 0) ;  
    				self.close();
    			}
		    } ,
		    error: function (result) { 
    		}
    	});
		
		
		
	}
	</script>

</head>
<body>
<div class="pop_wrap" style="538px;">
	<input type="hidden" id="erpCompSeq" value="${erpCompSeq}"></input>
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000006231","ERP사번 선택")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con div_form">
		<!-- 검색영역 -->
		<div class="top_box pr10">
			<dl>
				<dt><%=BizboxAMessage.getMessage("TX000017926","이름검색")%></dt>
				<dd><input id="txtSearchStr" name="txtSearchStr" type="text" style="width:150px;" value="${searchStr}" onkeydown="if(event.keyCode==13){javascript:fnSearch();}"/></dd>
				<dd>
					<input type="button" id="btnPopupSearch" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="fnSearch();"/>
					<input type="hidden" id="empErpNo" name="empErpNo"/>
				</dd>
				
			</dl>
		</div>

		<!-- 테이블 -->
		<div class="com_ta2 mt14">
			<table>
				<colgroup>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<thead>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
					</tr>
				</thead>
			</table>		
			</div>

			<div class="com_ta2 scroll_y_on bg_lightgray" style="height:333px;">
			<table class="brtn" id="empListTable">
				<colgroup>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tbody id="exEmpListTable">	
					<c:forEach items="${empList}" var="c">
						<c:if test="${serviceName == 'ExCodeOrgERPiUService'}">
	                        <tr ondblclick="fnDblclick(this);" id="${c.erpEmpSeq}" onclick="fnclick(this);">
								<td>${c.erpEmpSeq}</td>
								<td>${c.erpEmpName}</td>
							</tr>   
						</c:if>
						<c:if test="${serviceName == 'ExCodeOrgiCUBEService'}">
	                        <tr ondblclick="fnDblclick(this);" id="${c.erpEmpSeq}" onclick="fnclick(this);">
								<td>${c.erpEmpSeq}</td>
								<td>${c.erpEmpNm}</td>
							</tr>   
						</c:if>
                    </c:forEach>			
				</tbody>
			</table>		
		</div>
	

	</div><!--// pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="ok();"/>
			<input type="button" id="btnClose" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript:window.close();"/>
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->
</body>









