<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@page import="main.web.BizboxAMessage"%>
					
<div class="com_ta4 hover_no" style="overflow: auto;height: 400px;">
	<table>
		<colgroup>
			<col width="36"/>
			<col width="60"/>
			<col width=""/>
			<col width="60"/>
			<col width="70"/>
			<col width="50"/>
			<col width="80"/>
			<col width="100"/>
		</colgroup>
		<tbody id="empTable">
		<tr>
			<th>
				<input type="checkbox" name="inp_chk" id="all_chk" onclick="checkAll(this)" class="k-checkbox">
				<label class="k-checkbox-label bdChk2" for="all_chk" ></label>
			</th>
			<th><%=BizboxAMessage.getMessage("TX000000076","사원명")%></th>
			<th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
			<th><%=BizboxAMessage.getMessage("TX000016287","메일ID")%></th>
			<th><%=BizboxAMessage.getMessage("TX000000133","로그인ID")%></th>
			<th><%=BizboxAMessage.getMessage("TX000001748","결과")%></th>
			<th><%=BizboxAMessage.getMessage("TX000017941","라이센스")%></th>
			<th><%=BizboxAMessage.getMessage("TX900000216","오류 상세")%></th>
		</tr>
		<c:forEach items="${detailList}" var="list" varStatus="c">
		
		<c:if test="${params.listType == 'erp'}">
			<tr>
				<td>
					<input type="checkbox" name="noEmp" id="noEmp${c.count}" class="k-checkbox" value="${list.erpEmpSeq}">
					<label class="k-checkbox-label bdChk2" for="noEmp${c.count}" ></label>
				</td>
				<td>${list.empName}</td>
				<td>${list.deptName}</td>
				<td>${list.emailAddr}</td>
				<td>${list.loginId}</td>
				<td>
					<c:if test="${list.workStatus == '001'}"><%=BizboxAMessage.getMessage("TX000010068","재직")%></c:if>
					<c:if test="${list.workStatus == '002'}"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></c:if>
					<c:if test="${list.workStatus == '099'}"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></c:if>
				</td>
				
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</c:if>
		
		<c:if test="${params.listType != 'erp'}">
			<c:set var="red" value="" />
			<c:if test="${list.edResultCode == 6 || list.resultCode != '0' || list.edResultCode == 30 || list.edResultCode == 40 || list.edResultCode == 50}" >
				<c:set var="red" value="text_red" />
			</c:if>
			<c:if test="${list.resultCode == '20' && list.edResultCode != 6 && list.edResultCode != 30 && list.edResultCode != 40 && list.edResultCode != 50}" >
				<c:set var="red" value="text_blue" />
			</c:if>
		<tr>
			<td class="${red}">
				<input type="checkbox" name="inp_chk" id="" class="k-checkbox">
				<label class="k-checkbox-label bdChk2" for="" ></label>
			</td>
			<td class="${red}">${list.empName}</td>
			<td class="${red}">${list.deptName}</td>
			<td class="${red}">${list.emailAddr}</td>
			<td class="${red}">${list.loginId}</td>
			
 			<td class="${red}">
				<c:choose>
					<c:when test="${list.resultCode == 20}"><%=BizboxAMessage.getMessage("TX000000815","정상")%></c:when>
					<c:when test="${list.edResultCode == 6}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
					<c:when test="${list.resultCode == 2}"><%=BizboxAMessage.getMessage("TX000012773","퇴사")%></c:when>
					<c:when test="${list.resultCode == 3}"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></c:when>
					<c:when test="${list.resultCode == 0}"><%=BizboxAMessage.getMessage("TX000000815","정상")%></c:when>
					<c:when test="${list.resultCode == 30}"><%=BizboxAMessage.getMessage("TX000003226","변경")%></c:when>
					<c:when test="${list.resultCode != 0}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
				</c:choose>
			</td> 
			<td class="${red}">${list.licenseCheckYnName}</td>
			<td class="${red}">
				<c:choose>
					<c:when test="${list.resultCode == 20}"><%=BizboxAMessage.getMessage("TX900000366","사원정보 변경")%></c:when>
					<c:when test="${list.edResultCode == 6}"><%=BizboxAMessage.getMessage("TX900000367","ERP 부서정보 없음")%></c:when>
					<c:when test="${list.edResultCode == 10}"><%=BizboxAMessage.getMessage("TX900000368","ERP 사업장정보 없음")%></c:when>
					<c:when test="${list.resultCode == 1}"><%=BizboxAMessage.getMessage("TX000003226","변경")%></c:when>
					<c:when test="${list.resultCode == 2}"><%=BizboxAMessage.getMessage("TX000004490","퇴사처리")%></c:when>
					<c:when test="${list.resultCode == 3}"><%=BizboxAMessage.getMessage("TX000006260","대결자지정")%></c:when>
					<c:when test="${list.resultCode == 10}"><%=BizboxAMessage.getMessage("TX900000369","사업장 정보 없음")%></c:when>
					<c:when test="${list.resultCode == 5}"><%=BizboxAMessage.getMessage("TX900000370","로그인 ID 중복")%></c:when>
					<c:when test="${list.resultCode == 30}"><%=BizboxAMessage.getMessage("TX900000371","그룹웨어 라이센스 초과")%></c:when>
					<c:when test="${list.resultCode == 40}"><%=BizboxAMessage.getMessage("TX900000372","메일 라이센스 초과")%></c:when>
					<c:when test="${list.resultCode == 0}"></c:when>
				</c:choose>
			</td>
		</tr>
		</c:if>
		
		</c:forEach>
		</tbody>
	</table>
</div>

<div class="paging mt20"> 
    <ui:pagination paginationInfo="${paginationInfo}" type="bizbox" jsFunction="fn_list" />
</div>
