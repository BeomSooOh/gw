<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
			<script>
			
				$(".empchk").click(function(e){
					selectEmp(this);
				});
				
				function selectEmp(inp) {
					// 중복체크
					var empSeq = $(inp).val();
					var e = $("#selEmpListTable").find("input[value="+empSeq+"]").val();
					if (e != null && e != '') {
						//alert("선택된 사원입니다.");	
						return;
					} 
					
					var row = $(inp).parent().parent();
					// row 복제
					var newRow = row.clone(true);
					
					// id와 for 어티리뷰트 값 변경
					$(newRow).find(".empchk").attr("id","selchk_"+idx);
					$(newRow).find(".empchk").attr("class","k-checkbox selempchk");
					$(newRow).find(".k-checkbox-label").attr("for", "selchk_"+idx);
					
					//html 생성
					var h = "<tr>"+$(newRow).html()+"</tr>";
					 // 추가
					$("#selEmpListTable").append(h); 
					// 인덱스 증가
					idx++;
					// 선택된 사원 목록 총개 변경
					setCount();
					
				}
			
			 
			</script>
			 
			
			
			<table id="empListTable">
				<colgroup>
					<col width="120"/>
					<col width="75"/>
					<col />
				</colgroup>
				
				<c:forEach items="${empList}" var="list" varStatus="c">
				 
					<tr>
						<td class="le">
							<input type="checkbox" id="chkbox_${c.count}" name="seq" class="k-checkbox empchk" value="${list.deptSeq}${list.empSeq}">
							<label class="k-checkbox-label" for="chkbox_${c.count}" style="margin:0 0 0 10px; padding:0.2em 0 0 1.5em;">
							${list.empName}(${list.loginId})
							<input type="hidden" name="deptSeq" value="${list.deptSeq}">
							<input type="hidden" name="deptName" value="${list.deptName}">
							<input type="hidden" name="empSeq" value="${list.empSeq}">
							<input type="hidden" name="empName" value="${list.empName}">
							<input type="hidden" name="compSeq" value="${list.compSeq}">
							
							<c:if test="${not empty list.deptDutyCode}">							
							<input type="hidden" name="dutyCode" value="${list.deptDutyCode}">
							<input type="hidden" name="dutyCodeName" value="${list.deptDutyCodeName}">
							</c:if>
							<c:if test="${empty list.deptDutyCode}">
							<input type="hidden" name="dutyCode" value="${list.dutyCode}">
							<input type="hidden" name="dutyCodeName" value="${list.dutyCodeName}">
							</c:if>
							
							<c:if test="${not empty list.deptPositionCode}">							
							<input type="hidden" name="positionCode" value="${list.deptPositionCode}">
							<input type="hidden" name="positionCodeName" value="${list.deptPositionCodeName}">
							</c:if>
							<c:if test="${empty list.deptPositionCode}">
							<input type="hidden" name="positionCode" value="${list.positionCode}">
							<input type="hidden" name="positionCodeName" value="${list.positionCodeName}">
							</c:if>
						</td>  
						<td class="">${list.deptName}</label></td>
						<td class="">${list.dutyCodeName}</label></td>
					</tr>    
				
				</c:forEach>
			</table>
			
		