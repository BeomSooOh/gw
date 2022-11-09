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
					/* var empSeq = $(inp).val();
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
					setCount(); */
					
				}
			
			 
			</script>
			
			<table id="empListTable">
				<colgroup>
						<col width="35"/>
						<col width="80"/>
						<col width="65"/>
						<col width=""/>
					</colgroup>
				
				<c:forEach items="${empList}" var="list" varStatus="c"> 
				 	<tr>
						<td class="le"><input type="checkbox" name="seq" id="chkbox_${c.count}" class="k-checkbox empchk" <c:if test="${empty list.emailAddr || list.emailAddr == ''}">disabled</c:if> />
							<label class="k-checkbox-label" for="chkbox_${c.count}" style="padding:0.2em 0 0 10px;"></label>
							<input type="hidden" name="deptSeq" class="inp_box" value="${list.deptSeq}">
							<input type="hidden" name="deptName" class="inp_box" value="${list.deptName}">
							<input type="hidden" name="empSeq" class="inp_box" value="${list.empSeq}">
							<input type="hidden" name="empName" class="inp_box" value="${list.empName}">
							<input type="hidden" name="compSeq" class="inp_box" value="${list.compSeq}">
							<input type="hidden" name="groupSeq" class="inp_box" value="${list.groupSeq}">
							<input type="hidden" name="compName" class="inp_box" value="${list.compName}">
							<input type="hidden" name="bizSeq" class="inp_box" value="${list.bizSeq}">
							<c:if test="${empty list.emailAddr || list.emailAddr == ''}">
								<input type="hidden" name="email" class="inp_box" value="">
							</c:if>
							<c:if test="${not empty list.emailAddr && list.emailAddr != ''}">
								<input type="hidden" name="email" class="inp_box" value="${list.emailAddr}@${list.emailDomain}">
							</c:if>
						</td>
						<td>${list.compName}</td>
						<td class="">${list.empName}</td>
						
						<c:if test="${empty list.emailAddr || list.emailAddr == ''}">
						<td class="le"><div class=".mx120" title=""></div></td>
						</c:if>
						<c:if test="${not empty list.emailAddr && list.emailAddr != ''}">
						<td class="le"><div class=".mx120" title="${list.emailAddr}@${list.emailDomain}">${list.emailAddr}@${list.emailDomain}</div></td>
						</c:if>
						
					</tr>
				
				</c:forEach>
			</table>
			
		