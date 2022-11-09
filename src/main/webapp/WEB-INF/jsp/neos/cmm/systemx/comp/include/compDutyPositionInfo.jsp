<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<script>
function compDpSave() {
	var formData = $("#basicForm${compDpMap.dpType}").serialize();
	$.ajax({
		type:"post",
		url:"compDutyPositionSaveProc.do",
		datatype:"text",
		data: formData,
		success:function(data){
			
			refreshTreeview();
			
			alert(data.result);
			
		},			
		error : function(e){	//error : function(xhr, status, error) {
			alert("error");	
		}
	});	
}
	
</script>



<div class="com_ta">
 <form id="basicForm${compDpMap.dpType}" name="basicForm${compDpMap.dpType}">
	<input id="compSeq" name="compSeq" value="${compDpMap.compSeq}" type="hidden" />
	<input id="dpType" name="dpType" value="${compDpMap.dpType}" type="hidden" />
	
	<table>
		<tr>
			<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <span>직급코드</span></th>
			<td><input type="text" id="dpSeq" name="dpSeq" value="${compDpMap.dpSeq}" style="width:228px;" /></td>
		</tr>
		<tr>
			<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <span>직급명</span></th>
			<td><input type="text" id="dpName" name="dpName" value="${compDpMap.dpName}" style="width:228px;" /></td>
		</tr>
		<tr>
			<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 사용여부</th>
			<td>
				<input type="radio" name="useYn" value="Y" id="us_radi1" class="k-radio"  checked="checked">
				<label class="k-radio-label radioSel" for="us_radi1">사용</label>
				<input type="radio" name="useYn" value="N"  id="us_radi2" class="k-radio" <c:if test="${compDpMap.useYn == 'N'}">checked</c:if> />
				<label class="k-radio-label radioSel ml10" for="us_radi2">미사용</label>		
			</td>
		</tr>
		<tr>
			<th>적용범위</th>
			<td>${compMap.compName}</td>
		</tr>
		<tr>
			<th>설명</th>
			<td><input type="text" style="width:228px;"  name="descText" value="${compDpMap.descText}" /></td>
		</tr>
		<tr>
			<th>비고</th>
			<td><input type="text" style="width:228px;" id="commentText" name="commentText" value="${compDpMap.commentText}"/></td>
		</tr>
	</table>
</form>
</div>


<div class="btn_cen">
	<input type="button" id="saveBtn" class="saveBtn" onclick="compDpSave()" value="저장" />
</div>

