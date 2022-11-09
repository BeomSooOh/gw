<%@page
	import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="main.web.BizboxAMessage"%>

<div class="pop_con">
	<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016436","Bill36524 팩스/문자 이용요금은 다음과 같습니다.")%></p>
	<div class="com_ta2 hover_no">
		<table>
			<colgroup>
				<col width="70" />
				<col width="101" />
				<col width="" />
				<col width="121" />
			</colgroup>
			<tr>
				<th colspan="2"><%=BizboxAMessage.getMessage("TX000015690","서비스구분")%></th>
				<th><%=BizboxAMessage.getMessage("TX000016155","이용요금")%></th>
				<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
			</tr>
			<tr>
				<td rowspan="2"><%=BizboxAMessage.getMessage("TX000000007","팩스")%></td>
				<td><%=BizboxAMessage.getMessage("TX000016421","FAX 발송")%></td>
				<td class="ri pr15 text_blue fwb"><%=BizboxAMessage.getMessage("TX000016440","40P/장")%></td>
				<td></td>
			</tr>
			<tr>
				<td class="bg_skyblue2 not_fir"><%=BizboxAMessage.getMessage("TX000016420","FAX 수신")%></td>
				<td class="ri pr15 text_blue fwb bg_skyblue2"><%=BizboxAMessage.getMessage("TX000011813","무료")%></td>
				<td></td>
			</tr>
			<tr>
				<td rowspan="2"><%=BizboxAMessage.getMessage("TX000006206","문자")%></td>
				<td><%=BizboxAMessage.getMessage("TX000016337","단문(SMS)")%></td>
				<td class="ri pr15 text_blue fwb"><%=BizboxAMessage.getMessage("TX000016443","16P/1건")%></td>
				<td class="le text_blue fwb"><%=BizboxAMessage.getMessage("TX000016437","90byte 발송")%></td>
			</tr>
			<tr>
				<td class="not_fir"><%=BizboxAMessage.getMessage("TX000016144","장문(LMS)")%></td>
				<td class="ri pr15 text_blue fwb"><%=BizboxAMessage.getMessage("TX000016439","45P/1건")%></td>
				<td class="le text_blue fwb"><%=BizboxAMessage.getMessage("TX000016441","2,000byte 발송")%></td>
			</tr>
		</table>

	</div>

</div>
<!-- //pop_con -->


