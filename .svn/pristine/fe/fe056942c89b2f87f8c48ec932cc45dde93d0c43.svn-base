<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="main.web.BizboxAMessage"%>
   <script type="text/javascript">
		$(document).ready(function() {
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    
		    //진행상태 셀렉트박스
		    $("#jhst_sel").kendoComboBox({
		        dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000006808","작성")%>","<%=BizboxAMessage.getMessage("TX000011889","검토")%>","<%=BizboxAMessage.getMessage("TX000000798","승인")%>","<%=BizboxAMessage.getMessage("TX000000735","진행")%>","<%=BizboxAMessage.getMessage("TX000001288","완료")%>"]
		        },
		        value:"<%=BizboxAMessage.getMessage("TX000006808","작성")%>"
		    });
			//통화 셀렉트박스
		    $("#th_sel").kendoComboBox({
		        dataSource : {
					data : ["KRW","..."]
		        },
		        value:"KRW"
		    });
			// 프로젝트기간시작
		    $("#start_date").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });

			// 프로젝트기간끝
		    $("#end_date").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });
			// 계약일
		    $("#contract_date").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });	
		    //첨부파일	
			$("#fileUpload01").kendoUpload({
				localization: {
					select: "<%=BizboxAMessage.getMessage("TX000001702","찾기")%>"
				},
				multiple: false
			});
		    
		    computeMoneyExch();
		    
		    
		    
		});
		
		function projectInfo(noProject) {
			$("#noProject").val(noProject);
			document.form.action="projectModifyView.do";
			document.form.submit();
		}
		
		function computeMoneyExch() {
			var rtExch = parseFloat('${projectInfo.rtExch}')||0.0;	//환율
			
			if (rtExch > 0) {
				var base =  parseInt('${projectInfo.amBase}')||0;  // 공급가액
				var vat = parseInt('${projectInfo.amWonvat}')||0; // 부가세
				var won = parseInt('${projectInfo.amWonamt}')||0; // 합계	
				
				$("#exch1").html(neosWonFloor(base * rtExch, 1, 1, 2));
				$("#exch2").html(neosWonFloor(vat * rtExch, 1, 1, 2));
				$("#exch3").html(neosWonFloor(won * rtExch, 1, 1, 2));
			} 
		}
	</script>
						
						<div class="sub_contents_wrap">
							<!-- 버튼영역 -->
							<div id="" class="controll_btn" style="padding:0px;">
								<button id="listBtn" class="k-button"><%=BizboxAMessage.getMessage("TX000016281","목록으로 돌아가기")%></button>
								<button id="delBtn" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
							</div>

							<!-- 프로젝트 기본정보 -->
							<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016085","프로젝트 기본정보")%></p> 
							<div class="com_ta">
								<table>
									<colgroup>
										<col width="165"/>
										<col width="330"/>
										<col width="165"/>
										<col width=""/>
									</colgroup>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000528","프로젝트코드")%></th>
										<td>${projectInfo.noProject}</td>
										<th><%=BizboxAMessage.getMessage("TX000004254","계약일")%></th>
										<td>${projectInfo.dtChange}</td>
									</tr>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%></th>
										<td colspan="3">${projectInfo.nmProject}</td>
									</tr>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000010581","프로젝트기간")%></th>
										<td>${projectInfo.sdProject} ~ ${projectInfo.edProject}</td>
										<th><%=BizboxAMessage.getMessage("TX000000906","진행상태")%></th>
										<td>${projectInfo.staProjectNm}</td>
									</tr>
								</table>
							</div>
							
							<!-- ERP연동이 아닐시 사용
							<div class="com_ta">
								<table>
									<colgroup>
										<col width="165"/>
										<col width="330"/>
										<col width="165"/>
										<col width=""/>
									</colgroup>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> 프로젝트코드</th>
										<td  class="vt">
											<input type="text" style="width:300px;" />
											<p class="text_blue f11 mt5">* 사용 가능한 코드 입니다.</p>
											<p class="text_red f11 mt5">* 이미 등록된 코드 입니다.</p>
										</td>
										<th>계약일</th>
										<td class="vt">
											<input id="contract_date" style="width:250px;" />
										</td>
									</tr>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> 프로젝트명</th>
										<td colspan="3"><input type="text" style="width:743px;" /></td>
									</tr>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> 프로젝트기간</th>
										<td>
											<input id="start_date" style="width:142px;"/>
											~
											<input id="end_date" style="width:142px;"/>
										</td>
										<th>진행상태</th>
										<td>
											<input id="jhst_sel" style="width:250px;" />
										</td>
									</tr>
								</table>
							</div>
							-->
							
							
							<!-- 프로젝트 부가정보 -->
							<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016084","프로젝트 부가정보")%></p>
							<div class="com_ta">
								<table>
									<colgroup>
										<col width="165"/>
										<col width=""/>
									</colgroup>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
										<td>
											<input type="radio" name="syyb" id="syyb1" class="k-radio" checked="checked"/>
											<label class="k-radio-label radioSel" for="syyb1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
											<input type="radio" name="syyb" id="syyb2" <c:if test="${projectInfo.useYn == 'N'}">checked="checked"</c:if> class="k-radio"/>
											<label class="k-radio-label radioSel ml10" for="syyb2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
										</td>
									</tr>
									<tr>
										<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000016086","프로젝트 PM")%></th>
										<td>${projectInfo.pmName}</td>
									</tr>
									<tr>
										<th rowspan="3"><%=BizboxAMessage.getMessage("TX000016118","진행금액")%></th>
										<td class="flo_td">
											<span class="txt_ib" style="width:44px;">(<%=BizboxAMessage.getMessage("TX000015001","통화")%>)</span>
											<span class="txt_ib al" style="width:250px;">${projectInfo.cdExch}</span>
											<span class="txt_ib" style="width:130px;">(<%=BizboxAMessage.getMessage("TX000004660","환율")%>)</span>
											<span class="txt_ib al" style="width:290px;">${projectInfo.rtExch}</span>
										</td>
									</tr>
									<tr>
										<td class="flo_td">
											<span class="txt_ib" style="width:44px;">(<%=BizboxAMessage.getMessage("TX000016165","원화")%>)</span>
											<span class="txt_ib al" style="width:64px;">KRW</span>
											<span class="txt_ib" style="width:75px;"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%> :</span>
											<span class="txt_ib al" style="width:120px;"><fmt:formatNumber pattern="#,##0">${projectInfo.amBase}</fmt:formatNumber></span>
											<span class="txt_ib" style="width:75px;"><%=BizboxAMessage.getMessage("TX000000517","부가세")%> :</span>
											<span class="txt_ib al" style="width:120px;"><fmt:formatNumber pattern="#,##0">${projectInfo.amWonvat}</fmt:formatNumber></span>
											<span class="txt_ib" style="width:75px;"><%=BizboxAMessage.getMessage("TX000000518","합계")%> :</span>
											<span class="txt_ib al" style="width:120px;"><fmt:formatNumber pattern="#,##0">${projectInfo.amWonamt}</fmt:formatNumber></span>
										</td>
									</tr>
									<tr>
										<td class="flo_td">
											<span class="txt_ib" style="width:44px;">(<%=BizboxAMessage.getMessage("TX000016166","외화")%>)</span>
											<span class="txt_ib al" style="width:64px;"><c:if test="${projectInfo.cdExch != 'KRW'}">${projectInfo.cdExch}</c:if></span>
											<span class="txt_ib" style="width:75px;"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%> :</span>
											<span class="txt_ib al" style="width:120px;" id="exch1"></span>
											<span class="txt_ib" style="width:75px;"><%=BizboxAMessage.getMessage("TX000000517","부가세")%> :</span>
											<span class="txt_ib al" style="width:120px;" id="exch2"></span>
											<span class="txt_ib" style="width:75px;"><%=BizboxAMessage.getMessage("TX000000518","합계")%> :</span>
											<span class="txt_ib al" style="width:120px;" id="exch3"></span>
										</td>
									</tr>
									<tr>
										<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
										<td>${projectInfo.dcRmk}</td>
									</tr>
									<tr>
										<th><%=BizboxAMessage.getMessage("TX000000521","첨부파일")%></th>
										<td class="flo_td">
											<c:if test="${not empty projectInfo.idAttach}"><a href="<c:url value='/cmm/file/attachFileDownloadProc.do?fileId=${projectInfo.idAttach}&groupSeq=${groupSeq}' />" >${projectInfo.orignlFileName}.${projectInfo.fileExtsn}</a></c:if>
										</td>
									</tr>
									<tr>
										<th rowspan="4"><%=BizboxAMessage.getMessage("TX000016388","거래처정보")%></th>
										<td class="flo_td">
											<span class="txt_ib al" style="width:58px;">(<%=BizboxAMessage.getMessage("TX000000520","거래처")%>)</span>
											<span class="txt_ib al" style="width:279px;">${projectInfo.lnPartner}</span>
										</td>
									</tr>
									<tr>
										<td class="flo_td">
											<span class="txt_ib al" style="width:58px;">(<%=BizboxAMessage.getMessage("TX000015261","담당자명")%>)</span>
											<span class="txt_ib al" style="width:300px;">${projectInfo.nmPtr}</span>
											<span class="txt_ib al" style="width:65px;">(FAX)</span>
											<span class="txt_ib al" style="width:300px;">${projectInfo.noFax}</span>
										</td>
									</tr>
									<tr>
										<td class="flo_td">
											<span class="txt_ib al" style="width:58px;">(E-mail)</span>
											<span class="txt_ib al" style="width:675px;">${projectInfo.eMail}</span>
										</td>
									</tr>
									<tr>
										<td class="flo_td">
											<span class="txt_ib al" style="width:58px;">(<%=BizboxAMessage.getMessage("TX000000006","전화")%>)</span>
											<span class="txt_ib al" style="width:300px;">${projectInfo.noTel}</span>
											<span class="txt_ib al" style="width:65px;">(<%=BizboxAMessage.getMessage("TX000000008","핸드폰")%>)</span>
											<span class="txt_ib al" style="width:300px;">${projectInfo.noHp}</span>
										</td>
									</tr>
								</table>
							</div><!--// com_ta -->
							
							<div class="btn_cen">
								<input type="button" value="<%=BizboxAMessage.getMessage("TX000001179","수정")%>" onclick="projectInfo('${projectInfo.noProject}')">
								<input type="hidden" id="noProject" name="noProject"/>
							</div>
							
						</div><!-- //sub_contents_wrap -->
						
					
					
					<jsp:include page="/WEB-INF/jsp/neos/cmm/systemx/project/include/projectParameterForm.jsp" />
						