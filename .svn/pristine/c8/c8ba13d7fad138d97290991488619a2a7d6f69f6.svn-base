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

		//진행상태 셀렉트박스
		    $("#staProject").kendoComboBox({
		        dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000006808","작성")%>","<%=BizboxAMessage.getMessage("TX000011889","검토")%>","<%=BizboxAMessage.getMessage("TX000000798","승인")%>","<%=BizboxAMessage.getMessage("TX000000735","진행")%>"]
		        },
		        value:"<%=BizboxAMessage.getMessage("TX000006808","작성")%>"
		    });
		//통화 셀렉트박스
		    $("#cdExch").kendoComboBox({
		        dataSource : {
					data : ["KRW","USA", "EUR"]
		        },
		        value:"KRW"
		    });
		// 프로젝트기간시작
		    $("#sdProject").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR" 
		    });

		// 프로젝트기간끝
		    $("#edProject").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR" 
		    });
		// 계약일
		    $("#dtChange").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR" 
		    });	
	});
</script>

	<div class="pop_wrap resources_reservation_wrap" style="width:998px;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000016083","프로젝트추가")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
		</div><!-- //pop_head -->
		
		<div class="pop_con">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016085","프로젝트 기본정보")%></p>
			<div class="com_ta">
					<table>
						<colgroup>
							<col width="153"/>
							<col width="326"/>
							<col width="133"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000528","프로젝트코드")%></th>
							<td  class="vt"><input type="text" style="width:296px;" id="noProject" name="noProject" /> <p class="text_blue f11 mt5">* <%=BizboxAMessage.getMessage("TX000009763","사용 가능한 코드 입니다")%></p></td>
							<th><%=BizboxAMessage.getMessage("TX000004254","계약일")%></th>
							<td class="vt">
								<input id="dtChange" name="dtChange" style="width:320px;" />
							</td>
						</tr>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%></th>
							<td colspan="3"><input type="text" style="width:777px;" id="nmProject" name="nmProject" /></td>
						</tr>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000010581","프로젝트기간")%></th>
							<td><input id="sdProject" name="sdProject" style="width:137px;" class="fl"/><div class="fl" style="width:24px;height:24px;"></div> <input id="edProject" name="edProject" style="width:137px;" class="fl"/></td>
							<th><%=BizboxAMessage.getMessage("TX000000906","진행상태")%></th>
							<td>
								<input id="staProject" name="staProject" style="width:320px;" />
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000520","거래처")%></th>
							<td>
								<div class="dod_search">
									<input type="text" class=""id="cdPartner" name="cdPartner" style="width:275px;" placeholder="" /><a href="#" class="btn_sear"></a>
								</div>
							</td>
							<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
							<td>
								<input type="radio" name="useYn" id="useYn1" class="k-radio" checked="checked"/>
								<label class="k-radio-label radioSel" for="useYn1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
								<input type="radio" name="useYn" id="useYn2" class="k-radio"/>
								<label class="k-radio-label radioSel ml10" for="useYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
							</td>
						</tr>
						<tr>
							<th rowspan="3"><%=BizboxAMessage.getMessage("TX000016118","진행금액")%></th>
							<td colspan="3" class="flo_td">
								<span class="txt_ib"><%=BizboxAMessage.getMessage("TX000015001","통화")%></span>
								<input style="width:310px;" id="cdExch" name="cdExch" />
								<span class="txt_ib" style="width:116px;"><%=BizboxAMessage.getMessage("TX000004660","환율")%></span> 
								<input type="text" style="width:306px;" class="num_inp" id="rtExch" name="rtExch" disabled />
							</td>
						</tr>
						<tr>
							<td colspan="3" class="flo_td">
								<input type="text" style="width:121px;text-indent:0; text-align:center;" value="KRW" />
								<span class="txt_ib" style="width:88px;"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%></span>
								<input type="text" style="width:117px;" class="num_inp" id="amBase" name="amBase" />
								<span class="txt_ib" style="width:87px;"><%=BizboxAMessage.getMessage("TX000000517","부가세")%></span>
								<input type="text" style="width:117px;" class="num_inp" id="amVat" name="amVat" />
								<span class="txt_ib" style="width:87px;"><%=BizboxAMessage.getMessage("TX000000518","합계")%></span>
								<input type="text" style="width:117px;" class="num_inp" id="amWonamt" name="amWonamt" />
							</td>
						</tr>
						<tr>
							<td colspan="3" class="flo_td">
								<input type="text" style="width:121px;text-indent:0; text-align:center;" disabled />
								<span class="txt_ib" style="width:88px;"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%></span>
								<input type="text" style="width:117px;" class="num_inp" disabled />
								<span class="txt_ib" style="width:87px;"><%=BizboxAMessage.getMessage("TX000000517","부가세")%></span>
								<input type="text" style="width:117px;" class="num_inp" disabled/>
								<span class="txt_ib" style="width:87px;"><%=BizboxAMessage.getMessage("TX000000518","합계")%></span>
								<input type="text" style="width:117px;" class="num_inp" disabled/>
							</td>
						</tr>
					</table>
			</div><!--// com_ta -->

			<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016084","프로젝트 부가정보")%></p>
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="153"/>
						<col width="326"/>
						<col width="133"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000767","담당부서")%></th>
						<td>
							<div class="dod_search">
								<input type="text" class=""id="text_input"  style="width:275px;" placeholder="" /><a href="#" class="btn_sear"></a>
							</div>
						</td>
						<th><%=BizboxAMessage.getMessage("TX000000329","담당자")%></th>
						<td>
							<div class="dod_search">
								<input type="text" class=""id="text_input"  style="width:297px;" placeholder="" /><a href="#" class="btn_sear"></a>
							</div>
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000012425","프로젝트 참여자")%></th>
						<td colspan="3">
							<div class="dod_search">
								<input type="text" class=""id="text_input"  style="width:756px;" placeholder="" /><a href="#" class="btn_sear"></a>
							</div>
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
						<td colspan="3">
							<input type="text" style="width:777px;" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000521","첨부파일")%></th>
						<td colspan="3">
							<div class="dod_search">
								<input type="text" class=""id="text_input"  style="width:756px;" placeholder="" /><a href="#" class="btn_sear"></a>
							</div>
						</td>
					</tr>
					<tr>
						<th rowspan="3"><%=BizboxAMessage.getMessage("TX000016391","거래처 담당자 정보")%></th>
						<td colspan="3" class="flo_td">
							<span class="txt_ib" style="width:48px;"><%=BizboxAMessage.getMessage("TX000015261","담당자명")%></span>
							<input type="text" style="width:318px;" />
							<span class="txt_ib" style="width:75px;">FAX</span>
							<input type="text" style="width:318px;"/>
						</td>
					</tr>
					<tr>
						<td colspan="3" class="flo_td">
							<span class="txt_ib" style="width:48px;">E-mail</span>
							<input type="text" style="width:721px;" />
						</td>
					</tr>
					<tr>
						<td colspan="3" class="flo_td">
							<span class="txt_ib" style="width:48px;"><%=BizboxAMessage.getMessage("TX000000006","전화")%></span>
							<input type="text" style="width:318px;" />
							<span class="txt_ib" style="width:75px;"><%=BizboxAMessage.getMessage("TX000000008","핸드폰")%></span>
							<input type="text" style="width:318px;"/>
						</td>
					</tr>
				</table>
			</div>


		</div><!-- //pop_con -->
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
				<input type="button"  class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->    