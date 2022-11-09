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
										<col width=""/>
										<col width="60"/>
										<col width="100"/>
										<col width="100"/>
										<col width="100"/>
										<col width="50"/>
										<col width="100"/>
									</colgroup>
									<tbody id="empTable">
									<tr>
										<th>
											<input type="checkbox" name="inp_chk" id="all_chk" onclick="checkAll(this)" class="k-checkbox">
											<label class="k-checkbox-label bdChk2" for="all_chk" ></label>
										</th>
										<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000029","업태")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000030","종목")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000036","메일도메인")%></th>
										<th><%=BizboxAMessage.getMessage("TX000001748","결과")%></th>
										<th><%=BizboxAMessage.getMessage("TX900000402","오류 상세")%></th>
									</tr>
									<c:forEach items="${detailList}" var="list" varStatus="c">
									
									<c:if test="${params.listType == 'erp'}">
										<c:choose>
											<c:when test="${params.erpType == 'gerp' }">
												<tr>
													<td>
														<input type="checkbox" name="cdCompany" id="cdCompany${c.count}" class="k-checkbox" value="${list.cdCompany}">
														<label class="k-checkbox-label bdChk2" for="cdCompany${c.count}" ></label>
													</td>
													<td>${list.nmCompany}</td>
													<td>${list.nmCeo}</td>
													<td></td>
													<td></td>
													<td>${list.mailDomain}</td>
													<td></td>
													<td></td>
												</tr>
											</c:when>
										</c:choose>
									</c:if>
									
									<c:if test="${params.listType != 'erp'}">
										<c:set var="red" value="" />
										<c:if test="${list.edResultCode == 6 || list.resultCode != '0'}" >
											<c:set var="red" value="text_red" />
										</c:if>
									<tr>
										<td class="${red}">
											<input type="checkbox" name="inp_chk" id="" class="k-checkbox">
											<label class="k-checkbox-label bdChk2" for="" ></label>
										</td>
										<td class="${red}">${list.compName}</td>
										<td class="${red}">${list.ownerName}</td>
										<td class="${red}">${list.bizCondition}</td>
										<td class="${red}">${list.item}</td>
										<td class="${red}">${list.emailDomain}</td>
										<td class="${red}">
											<c:choose>
												<c:when test="${list.resultCode == 20}"><%=BizboxAMessage.getMessage("TX900000394","정상")%></c:when>
												<c:when test="${list.edResultCode == 6}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
												<c:when test="${list.resultCode == 0}"><%=BizboxAMessage.getMessage("TX900000394","정상")%></c:when>
												<c:when test="${list.resultCode != 0}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
											</c:choose>
										</td>
										<td class="${red}">
											<c:choose>
												<c:when test="${list.resultCode == 20}"><%=BizboxAMessage.getMessage("TX900000403","ERP 회사정보 변경")%></c:when>
												<c:when test="${list.resultCode == 5}"><%=BizboxAMessage.getMessage("TX900000404","회사 코드 중복")%></c:when>
												<c:when test="${list.resultCode == 1}"><%=BizboxAMessage.getMessage("TX000003226","변경")%></c:when>
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
