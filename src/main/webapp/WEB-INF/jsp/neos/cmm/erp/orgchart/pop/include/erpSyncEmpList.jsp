<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ page import="main.web.BizboxAMessage" %>
					
							<div class="com_ta4 hover_no" style="overflow: auto;height: 400px;">
								<table>
									<colgroup>
										<col width="36"/>
										<col width="60"/>
										<col width=""/>
										<col width="60"/>
										<col width="70"/>
										<col width="50"/>
										<col width="50"/>
										<col width="50"/>
										<col width="70"/>
										<col width="60"/>
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
										<th><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></th>
										<th><%=BizboxAMessage.getMessage("TX000018672","직급")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
										<th><%=BizboxAMessage.getMessage("TX000007182","근무구분")%></th>
										<th><%=BizboxAMessage.getMessage("TX000004789","고용형태")%></th>
										<th><%=BizboxAMessage.getMessage("TX900000395","직군/직종")%></th>
										<th><%=BizboxAMessage.getMessage("TX000001748","결과")%></th>
										<th><%=BizboxAMessage.getMessage("TX000017941","라이센스")%></th>
										<th><%=BizboxAMessage.getMessage("TX900000216","오류 상세")%></th>
									</tr>
									<c:forEach items="${detailList}" var="list" varStatus="c">
									
									<c:if test="${params.listType == 'erp'}">
										<c:choose>
											<c:when test="${params.erpType == 'iu' }">
												<tr>
													<td>
														<input type="checkbox" name="noEmp" id="noEmp${c.count}" class="k-checkbox" value="${list.noEmp}">
														<label class="k-checkbox-label bdChk2" for="noEmp${c.count}" ></label>
													</td>
													<td>${list.nmKor}</td>
													<td>${list.cdDeptName}</td>
													<td>${list.noEmail}</td>
													<td>${list.noEmp}</td>
													<td>
													<c:choose>
														<c:when test="${params.erpIuPositionSet == 'cdDutyResp'}">
															${list.cdDutyRespName}
														</c:when>
														<c:when test="${params.erpIuPositionSet == 'cdDutyRank'}">
															${list.cdDutyRankName}
														</c:when>
														<c:otherwise>
															${list.cdDutyStepName}
														</c:otherwise>
													</c:choose>
													</td>
													
													<td>
													<c:choose>
														<c:when test="${params.erpIuDutySet == 'cdDutyStep'}">
															${list.cdDutyStepName}
														</c:when>
														<c:when test="${params.erpIuDutySet == 'cdDutyRank'}">
															${list.cdDutyRankName}
														</c:when>
														<c:otherwise>
															${list.cdDutyRespName}
														</c:otherwise>
													</c:choose>
													</td>													
													
													<td>
														<c:if test="${list.cdIncom == '001'}"><%=BizboxAMessage.getMessage("TX000010068","재직")%></c:if>
														<c:if test="${list.cdIncom == '002'}"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></c:if>
														<c:if test="${list.cdIncom == '099'}"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></c:if>
													</td>
													<td>
														<c:if test="${list.cdEmp == '001'}"><%=BizboxAMessage.getMessage("TX000004791","상용직")%></c:if>
														<c:if test="${list.cdEmp == '002'}"><%=BizboxAMessage.getMessage("TX000004792","일용직")%></c:if>
													</td>
													<td>${list.cdDutyTypeName}</td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
											</c:when>
											<c:when test="${params.erpType == 'icube' }">
												<tr>
													<td>
														<input type="checkbox" name="noEmp" id="noEmp${c.count}" class="k-checkbox" value="${list.empCd}">
														<label class="k-checkbox-label bdChk2" for="noEmp${c.count}" ></label>
													</td>
													<td>${list.korNm}</td>
													<td>${list.deptCdName}</td>
													<td>${list.emalAdd}</td>
													<td>${list.empCd}</td>
													<td>${list.hclsCdName}</td>
													<td>${list.hrspCdName}</td>
													<td>${list.enrlFgName}</td>
													<td>
														<c:if test="${list.emplFg == '001'}"><%=BizboxAMessage.getMessage("TX000004791","상용직")%></c:if>
														<c:if test="${list.emplFg == '002'}"><%=BizboxAMessage.getMessage("TX000004792","일용직")%></c:if>
													</td>
													<td>${list.htypCdName}</td>
													<td></td>
													<td></td>
													<td></td>
												</tr> 
											</c:when>
											<c:when test="${params.erpType == 'gerp' }">
												<tr>
													<td>
														<input type="checkbox" name="noEmp" id="noEmp${c.count}" class="k-checkbox" value="${list.noEmp}">
														<label class="k-checkbox-label bdChk2" for="noEmp${c.count}" ></label>
													</td>
													<td>${list.nmKor}</td>
													<td>${list.cdDeptName}</td>
													<td>${list.nmEmail}</td>
													<td>${list.noEmp}</td>
													<td>
													<c:choose>
														<c:when test="${params.erpIuPositionSet == 'cdDutyResp'}">
															${list.cdDutyRespName}
														</c:when>
														<c:when test="${params.erpIuPositionSet == 'cdDutyRank'}">
															${list.cdDutyRankName}
														</c:when>
														<c:otherwise>
															${list.cdDutyStepName}
														</c:otherwise>
													</c:choose>
													</td>
													
													<td>
													<c:choose>
														<c:when test="${params.erpIuDutySet == 'cdDutyStep'}">
															${list.cdDutyStepName}
														</c:when>
														<c:when test="${params.erpIuDutySet == 'cdDutyRank'}">
															${list.cdDutyRankName}
														</c:when>
														<c:otherwise>
															${list.cdDutyRespName}
														</c:otherwise>
													</c:choose>
													<td>
														<c:if test="${list.cdIncom == '1'}"><%=BizboxAMessage.getMessage("TX000010068","재직")%></c:if>
														<c:if test="${list.cdIncom == '2'}"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></c:if>
														<c:if test="${list.cdIncom == '3'}"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></c:if>
													</td>
													<td>
														<c:if test="${list.cdEmp == '1'}"><%=BizboxAMessage.getMessage("TX000004791","상용직")%></c:if>
														<c:if test="${list.cdEmp == '2'}"><%=BizboxAMessage.getMessage("TX000004792","일용직")%></c:if>
													</td>
													<td>${list.cdDutyTypeName}</td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
											</c:when>
										</c:choose>
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
										</td>
										<td class="${red}">${list.empName}</td>
										<td class="${red}">${list.deptName}</td>
										<td class="${red}">${list.emailAddr}</td>
										<td class="${red}">${list.erpEmpSeq}</td>
										<td class="${red}">${list.positionCodeName}</td>
										<td class="${red}">${list.dutyCodeName}</td>
										<td class="${red}">${list.workStatusName}</td>
										<td class="${red}">${list.statusCodeName}</td>
										<td class="${red}">${list.jobCodeName}</td>
										<td class="${red}">
											<c:choose>
												<c:when test="${list.edResultCode == 6}"><%=BizboxAMessage.getMessage("","오류")%></c:when>
												<c:when test="${list.edResultCode == 30}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
												<c:when test="${list.edResultCode == 40}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
												<c:when test="${list.edResultCode == 50}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
												<c:when test="${list.resultCode == 20}"><%=BizboxAMessage.getMessage("TX000000815","정상")%></c:when>
												<c:when test="${list.resultCode == 2}"><%=BizboxAMessage.getMessage("TX900000393","퇴사자")%></c:when>
												<c:when test="${list.resultCode == 3}"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></c:when>
												<c:when test="${list.resultCode == 0}"><%=BizboxAMessage.getMessage("TX000000815","정상")%></c:when>
												<c:when test="${list.resultCode == 7}"><%=BizboxAMessage.getMessage("TX000012773","퇴사")%></c:when>
												<c:when test="${list.resultCode != 0}"><%=BizboxAMessage.getMessage("TX000006506","오류")%></c:when>
											</c:choose>
										</td>
										<td class="${red}">${list.licenseCheckYnName}</td>
										<td class="${red}">
											<c:choose>
												<c:when test="${list.edResultCode == 6}"><%=BizboxAMessage.getMessage("TX900000392","ERP 부서정보 없음")%></c:when>
												<c:when test="${list.edResultCode == 10}"><%=BizboxAMessage.getMessage("TX900000391","ERP 사업장정보 없음")%></c:when>
												<c:when test="${list.edResultCode == 30}"><%=BizboxAMessage.getMessage("TX900000390","직책 값 없음")%></c:when>
												<c:when test="${list.edResultCode == 40}"><%=BizboxAMessage.getMessage("TX900000389","직급 값 없음")%></c:when>
												<c:when test="${list.edResultCode == 50}"><%=BizboxAMessage.getMessage("TX900000388","직책,직급 값 없음")%></c:when>
												<c:when test="${list.resultCode == 20}"><%=BizboxAMessage.getMessage("TX900000387","ERP 사원정보 변경")%></c:when>
												<c:when test="${list.resultCode == 1}"><%=BizboxAMessage.getMessage("TX000003226","변경")%></c:when>
												<c:when test="${list.resultCode == 2}"><%=BizboxAMessage.getMessage("TX000004490","퇴사처리")%></c:when>
												<c:when test="${list.resultCode == 7}"><button id="${list.erpEmpSeq}" type="button" onclick="fnResign('${list.erpEmpSeq}','${list.compSeq}')"><%=BizboxAMessage.getMessage("TX000004490","퇴사처리")%></button></c:when>
												<c:when test="${list.resultCode == 3}"><%=BizboxAMessage.getMessage("TX000006260","대결자지정")%></c:when>
												<c:when test="${list.resultCode == 10}"><%=BizboxAMessage.getMessage("TX900000369","사업장 정보 없음")%></c:when>
												<c:when test="${list.resultCode == 4}">ERP 
													<c:if test="${params.loginIdType == '1'}"><%=BizboxAMessage.getMessage("TX900000386","사원번호<br>ID없음")%></c:if> 
													<c:if test="${params.loginIdType == '2'}"><%=BizboxAMessage.getMessage("TX900000385","E-Mail<br>ID 없음")%></c:if>
												</c:when>
												<c:when test="${list.resultCode == 5}"><%=BizboxAMessage.getMessage("TX900000370","로그인 ID 중복")%></c:when>
												<c:when test="${list.resultCode == 30}"><%=BizboxAMessage.getMessage("TX900000384","그룹웨어 라이센스 초과")%></c:when>
												<c:when test="${list.resultCode == 40}"><%=BizboxAMessage.getMessage("TX900000383","메일 라이센스 초과")%></c:when>
												<c:when test="${list.resultCode == 11}"><%=BizboxAMessage.getMessage("TX900000382","메일 계정 중복")%></c:when>
												<c:when test="${list.resultCode == 0}"></c:when>
											</c:choose>
										</td>
									</tr>
									</c:if>
									
									</c:forEach>
									<c:if test="${fn:length(detailList) < 1}">
										<tr>
											<td colspan="13">
												<%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%>
											</td>
										</tr>
									</c:if>
									</tbody>
								</table>
							</div>
							
							<div class="paging mt20"> 
							    <ui:pagination paginationInfo="${paginationInfo}" type="bizbox" jsFunction="fn_list" />
							</div>
