<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<!-- 사용자 정렬 팝업 -->
<div id="sortPop">

<script>
	function saveCompSort() {
		var formData = $("#compSortForm").serialize();
		$.ajax({
			type:"post",
			url:"deptCompSortSaveProc.do",
			datatype:"text",
			data: formData,
			success:function(data){
				alert(data.result);
			},			
			error : function(e){	//error : function(xhr, status, error) {
				alert("error");	
			}
		});	
	}
</script>
		<div id="window">
		<form id="compSortForm" name="compSortForm">
		   <input name="compSeq" type="hidden" value="${compSeq}" />
	       <ul>
	       		<li>
	       			<label>1<%=BizboxAMessage.getMessage("TX000008902","순위")%> :</label>  
	       			<select name="sortField">
	       				<c:forEach items="${sortList}" var="list">
	       					<option value="${list.detailCode}" <c:if test="${list.orderNum == 1}">selected</c:if> >${list.detailName }</option>
	       				</c:forEach>
	       			</select>
	       		</li>
	       		<li>
	       			<label>2<%=BizboxAMessage.getMessage("TX000008902","순위")%> :</label>  
	       			<select name="sortField">
	       				<c:forEach items="${sortList}" var="list">
	       					<option value="${list.detailCode}" <c:if test="${list.orderNum == 2}">selected</c:if> >${list.detailName }</option>
	       				</c:forEach>
	       			</select>
	       		</li>
	       		<li>
	       			<label>3<%=BizboxAMessage.getMessage("TX000008902","순위")%> :</label>  
	       			<select name="sortField">
	       				<c:forEach items="${sortList}" var="list">
	       					<option value="${list.detailCode}" <c:if test="${list.orderNum == 3}">selected</c:if> >${list.detailName }</option>
	       				</c:forEach>
	       			</select>
	       		</li>
	       		<li>
	       			<label>4<%=BizboxAMessage.getMessage("TX000008902","순위")%> :</label>  
	       			<select name="sortField">
	       				<c:forEach items="${sortList}" var="list">
	       					<option value="${list.detailCode}" <c:if test="${list.orderNum == 4}">selected</c:if> >${list.detailName }</option>
	       				</c:forEach>
	       			</select>
	       		</li>
	       		<li>
	       			<label>5<%=BizboxAMessage.getMessage("TX000008902","순위")%> :</label>  
	       			<select name="sortField">
	       				<c:forEach items="${sortList}" var="list">
	       					<option value="${list.detailCode}" <c:if test="${list.orderNum == 5}">selected</c:if> >${list.detailName }</option>
	       				</c:forEach>
	       			</select>
	       		</li>
	       </ul>
	       </form>
	       
	       <p style="text-align:center">
	       		<button id="saveCompSortBtn" class="k-button deptBtn" onclick="saveCompSort()"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	       </p>
	            
	    </div> 
	
</div>

 



                
  