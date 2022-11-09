<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>



<style>
.portal_main_wrap {
	overflow: hidden;
	position: relative;
	width: 960px;
	min-height: 696px;
	margin: 15px auto 0 auto;
}

.portal_con_center .portal_cc_top {
	float: left;
	width: 568px;
}

.portal_con_center .portal_cc_left {
	float: left;
	width: 280px;
}

.portal_con_center .portal_cc_right {
	float: left;
	width: 280px;
	margin-left: 8px !important;
}

.portal_portlet {
	background-color: white;
	cursor: move;
	border: 1px solid #c7c7c7;
	margin-bottom: 8px !important;
	width: 565px;
}

.portal_portlet .portlet_img {
	margin: 5px;
}

.portal_portlet .portlet_img_not_use {
	margin: 5px;
	opacity: 0.1;
}

.portal_portlet .link_sts {
	position: absolute;
	left: 70px;
	margin-top: 10px;
	font-weight: bold;
}
</style>


<div class="pop_wrap resources_reservation_wrap" style="height: 100%; border: none; overflow-y: auto;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016087", "포틀릿설정")%></h1>
	</div>
	
	<div class="pop_con">
		<div class="com_ta">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000004661", "기본정보")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="150" />
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016088", "포틀릿구분")%></th>
					<td id="portletTypeName"></td>
					<th><%=BizboxAMessage.getMessage("TX000000028", "사용여부")%></th>
					<td>
						<input type="radio" id="useYn" name="useYn" value="Y" class="" checked="checked" /> <label for="useYn"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
						<input type="radio" id="useYn2" name="useYn" value="N" class="ml10" /> <label for="useYn2"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="divPortletNameSet" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="150" />
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
					<td>
						<input id="portletKrName" type="text" style="width: 100%;" value="" />
					</td>
					<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
					<td>
						<input id="portletCnName" type="text" style="width: 100%;" value="" />
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
					<td>
						<input id="portletEnName" type="text" style="width: 100%;" value="" />
					</td>
					<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
					<td>
						<input id="portletJpName" type="text" style="width: 100%;" value="" />
					</td>
				</tr>
			</table>
		</div>
					
		<div id="portletTemplete_mybox" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000007", "표시옵션")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="radio" onclick="fnRadioButtonEvent('myInfo','all');" name="portletTemplete_mybox_displayOption" id="portletTemplete_mybox_all" value="all" checked /> <label for="portletTemplete_mybox_all"><%=BizboxAMessage.getMessage("TX000004225", "모두표시")%></label>
						<input type="radio" onclick="fnRadioButtonEvent('myInfo','attend');" name="portletTemplete_mybox_displayOption" id="portletTemplete_mybox_attend" value="attend" class="ml10" /> <label for="portletTemplete_mybox_attend"><%=BizboxAMessage.getMessage("TX900000495", "출퇴근영역만 표시")%></label>
						<input type="radio" onclick="fnRadioButtonEvent('myInfo','profile');" name="portletTemplete_mybox_displayOption" id="portletTemplete_mybox_profile" value="profile" class="ml10" /> <label for="portletTemplete_mybox_profile"><%=BizboxAMessage.getMessage("TX900000496", "프로필영역만 표시")%></label>
					</td>
				</tr>
				<tr id="portletTemplete_mybox_attendCheck" >
					<th><%=BizboxAMessage.getMessage("TX000016109", "출퇴근체크")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" id="portletTemplete_mybox_val01" /> <label for="portletTemplete_mybox_val01"><%=BizboxAMessage.getMessage("TX000016110", "출퇴근사용")%></label>
						<input type="checkbox" id="portletTemplete_mybox_val02" class="ml10" /> <label for="portletTemplete_mybox_val02"><%=BizboxAMessage.getMessage("TX900000008", "시간표시")%></label>
						<input type="checkbox" id="portletTemplete_mybox_val03" class="ml10" /> <label id="portletTemplete_mybox_val03_label" for="portletTemplete_mybox_val03"><%=BizboxAMessage.getMessage("TX900000009", "자동출근처리 (당일 최초 로그인 시)")%></label>
					</td>
				</tr>
			</table>
		</div>					
		
		<div id="portletTemplete_calendar" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"><%=BizboxAMessage.getMessage("TX000000483", "일정")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" id="portletTemplete_calendar_val00" name="calenderOptionCheckbox" /> <label for="portletTemplete_calendar_val00"><%=BizboxAMessage.getMessage("TX000018850", "전체개인일정")%></label>
						<input type="checkbox" id="portletTemplete_calendar_val01" name="calenderOptionCheckbox" class="ml10" /> <label for="portletTemplete_calendar_val01"><%=BizboxAMessage.getMessage("TX000018969", "전체공유일정")%></label>
						<input type="checkbox" id="portletTemplete_calendar_val02" name="calenderOptionCheckbox" class="ml10" /> <label for="portletTemplete_calendar_val02"><%=BizboxAMessage.getMessage("TX000007381", "기념일")%></label>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("", "기본값설정")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="radio" name="defaultCalenderType" id="defalutCalenderOption_all" value="all" /><label for="defalutCalenderOption_all"><%=BizboxAMessage.getMessage("TX000010380", "전체일정")%></label>
						<input type="radio" name="defaultCalenderType" id="defalutCalenderOption_private" checked="checked" value="private" class="ml10" /><label for="defalutCalenderOption_private">&nbsp;<%=BizboxAMessage.getMessage("TX000004103", "개인일정")%></label>
						<input type="radio" name="defaultCalenderType" id="defalutCalenderOption_share" value="share" class="ml10" /><label for="defalutCalenderOption_share"><%=BizboxAMessage.getMessage("TX000010163", "공유일정")%></label>
						<input type="radio" name="defaultCalenderType" id="defalutCalenderOption_special" value="special" class="ml10" /><label for="defalutCalenderOption_special"><%=BizboxAMessage.getMessage("TX000007381", "기념일")%></label>	
					</td>
				</tr>
			</table>
		</div>
		
		<div id="portletTemplete_iframe_banner" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
				</colgroup>
				
				<tr>
					<th><%=BizboxAMessage.getMessage("TX900000005", "배너방식")%></th>
					<td colspan="3">
						<input onclick="fnRadioButtonEvent('banner','Y');" type="radio" id="portletTemplete_iframe_banner_slide" name="portletTemplete_iframe_banner_imageChoice" checked value="Y" /> <label for="portletTemplete_iframe_banner_slide"><%=BizboxAMessage.getMessage("TX900000006", "슬라이드")%></label>
						<input onclick="fnRadioButtonEvent('banner','N');" type="radio" id="portletTemplete_iframe_banner_imageList" name="portletTemplete_iframe_banner_imageChoice" value="N" class="ml10" /> <label for="portletTemplete_iframe_banner_imageList"><%=BizboxAMessage.getMessage("TX000005559", "리스트")%></label>
					</td>
				</tr>				
				<tr name="portletTemplete_iframe_banner_slide_option">
					<th class="brtn"><%=BizboxAMessage.getMessage("TX000016257", "변환주기(ms)")%></th>
					<td class="brtn"><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" id="portletTemplete_iframe_banner_bn_pause" type="text" style="width: 50px;" value="3000" /></td>
					<th class="brtn"><%=BizboxAMessage.getMessage("TX000016258", "변환속도(ms)")%></th>
					<td class="brtn"><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" id="portletTemplete_iframe_banner_bn_speed" type="text" style="width: 50px;" value="1000" /></td>
				</tr>
				<tr name="portletTemplete_iframe_banner_slide_option">
					<th><%=BizboxAMessage.getMessage("TX000016156", "이미지선택버튼")%></th>
					<td>
						<input type="radio" id="portletTemplete_iframe_banner_moBtnY" name="portletTemplete_iframe_banner_moBtn" value="true" class="" checked /> <label for="portletTemplete_iframe_banner_moBtnY"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
						<input type="radio" id="portletTemplete_iframe_banner_moBtnN" name="portletTemplete_iframe_banner_moBtn" value="false" class="ml10" /> <label for="portletTemplete_iframe_banner_moBtnN"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016256", "변환타입")%></th>
					<td>
						<input type="radio" id="portletTemplete_iframe_banner_moveTp1" name="portletTemplete_iframe_banner_moveTp" value="fade" checked /> <label for="portletTemplete_iframe_banner_moveTp1"><%=BizboxAMessage.getMessage("TX000016090", "페이딩")%></label>
						<br>
						<input type="radio" id="portletTemplete_iframe_banner_moveTp2" name="portletTemplete_iframe_banner_moveTp" value="horizontal" /> <label for="portletTemplete_iframe_banner_moveTp2"><%=BizboxAMessage.getMessage("TX000016129", "좌우")%></label>
						<br>
						<input type="radio" id="portletTemplete_iframe_banner_moveTp3" name="portletTemplete_iframe_banner_moveTp" value="vertical" /> <label for="portletTemplete_iframe_banner_moveTp3"><%=BizboxAMessage.getMessage("TX000016204", "상하")%></label>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="portletTemplete_iframe_quick" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
				</colgroup>
				<tr>
					<th class="brtn"><%=BizboxAMessage.getMessage("TX000016160", "이동주기(ms)")%></th>
					<td class="brtn"><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" id="portletTemplete_iframe_quick_qu_pause" type="text" style="width: 50px;" value="3000" /></td>
					<th class="brtn"><%=BizboxAMessage.getMessage("TX000016161", "이동방향")%></th>
					<td class="brtn">
						<input type="radio" id="portletTemplete_iframe_quick_dirTp1" name="portletTemplete_iframe_quick_dirTp" value="left" checked /> <label for="portletTemplete_iframe_quick_dirTp1"><%=BizboxAMessage.getMessage("TX000007911", "왼쪽")%></label>
						<input type="radio" id="portletTemplete_iframe_quick_dirTp2" name="portletTemplete_iframe_quick_dirTp" value="right" class="ml10"/> <label for="portletTemplete_iframe_quick_dirTp2"><%=BizboxAMessage.getMessage("TX000007909", "오른쪽")%></label>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="portletTemplete_iframe_outer" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
				</colgroup>
				<tr>
					<th class="brtn">I-Frame URL</th>
					<td class="brtn"><input id="portletTemplete_iframe_outer_if_url" type="text" value="" style="width: 95%;" /></td>
					<th><%=BizboxAMessage.getMessage("TX000016405","SSO연동")%></th>
					<td>
						<div class="controll_btn" style="padding:0px;" link_seq="-1">
							<button onclick="fnbutton('set',this)"><%=BizboxAMessage.getMessage("TX000017969", "SSO설정")%></button>	
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="portletTemplete_board" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<div class="controll_btn mt8" style="float:right;">
				<button id="" onclick="fnBoardListPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
			</div>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
					<td>
						<input type="text" style="width: 100%;" id="portletTemplete_board_boardName" value=""/>
						<input type="hidden" id="portletTemplete_board_boardID" value="" />
					</td>
				</tr>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
					<td><input type="text" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="width: 40%;" id="portletTemplete_board_boardCount" value="" /></td>
				</tr>
			</table>			
		</div>
		
		<!-- 문서 포틀릿 설정 -->
		<div id="portletTemplete_doc" class="com_ta" style="margin-top:20px;display:none;">		
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<div class="controll_btn mt8" style="float:right;">
				<button id="reg_document_btn" onclick="fnDocListPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
			</div>					
				
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
						<td>
							<input type="text" style="width: 100%;" id="portletTemplete_doc_docName" value=""/>
							<input type="hidden" id="portletTemplete_doc_dirCd" value=""/>
							<input type="hidden" id="portletTemplete_doc_docType" value=""/>
							<input type="hidden" id="portletTemplete_doc_docLvl" value=""/>
						</td>
					</tr>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
						<td><input type="text" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="width: 40%;" id="portletTemplete_doc_docCount" value="" /></td>
					</tr>
				</table>
			</div>
		</div>

		
		<div id="portletTemplete_calendar" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<div class="controll_btn mt8" style="float:right;">
				<button id="" onclick="fnBoardListPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
			</div>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				
				<tr id="attendCheck">
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"><%=BizboxAMessage.getMessage("TX900000497", "일정표시")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" id="val00" /> <label for="val00"><%=BizboxAMessage.getMessage("TX000018850", "전체개인일정")%></label>
						<input type="checkbox" id="val01" class="ml10" /> <label for="val01"><%=BizboxAMessage.getMessage("TX000018969", "전체공유일정")%></label>
						<input type="checkbox" id="val02" class="ml10" /> <label for="val02"><%=BizboxAMessage.getMessage("TX000007381", "기념일")%></label>
					</td>
				</tr>
			</table>			
		</div>			
		
		<div id="portletTemplete_web_sign" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<div class="controll_btn mt8" style="float:right;">
				<button id="" onclick="fnEaBoxPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
			</div>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
					<td>
						<ul class="multibox p0 m0 mr5" style="width: 100%;" id="portletTemplete_web_sign_listBox"></ul>
					</td>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX900000010", "기안자명 표시")%></th>
					<td>
						<input type="radio" name="portletTemplete_web_sign_displayOption" id="portletTemplete_web_sign_displayOptionY" checked value="Y" /> <label for="portletTemplete_web_sign_displayOptionY"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
						<input type="radio" name="portletTemplete_web_sign_displayOption" id="portletTemplete_web_sign_displayOptionN" value="N" class="ml10" /> <label for="portletTemplete_web_sign_displayOptionN"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
					</td>
				</tr>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
					<td><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" type="text" style="width: 50px;" id="portletTemplete_web_sign_listCnt" value="" /> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>
				</tr>
			</table>		
		</div>		
		
		<div id="portletTemplete_inbox" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
					<td class="pd6">
						<select id="portletTemplete_inbox_mailSelect" name="portletTemplete_inbox_mailSelect" style="width: 156px;" />
					</td>
					<td style="border-left: 0px;" align="left">
						<input type="checkbox" id="portletTemplete_inbox_val01" /> <label for="portletTemplete_inbox_val01"><%=BizboxAMessage.getMessage("TX900000011", "미열람메일만 보기")%></label>	
					</td>
				</tr>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
					<td colspan="3"><input onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" type="text" style="width: 50px;" id="portletTemplete_inbox_val02" value="10"/> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>					
				</tr>	
			</table>
		</div>
		
		<div id="portletTemplete_mail_status" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000014", "메일현황 내역")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" id="portletTemplete_mail_status_val00" /> <label for="portletTemplete_mail_status_val00"><%=BizboxAMessage.getMessage("TX000001580", "받은편지함")%></label>
						<input type="checkbox" id="portletTemplete_mail_status_val01" class="ml10"/> <label for="portletTemplete_mail_status_val01"><%=BizboxAMessage.getMessage("TX000000478", "사용량")%></label>
					</td>
				</tr>
			</table>
		</div>		
		
		<div id="portletTemplete_weather" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000006274", "날씨지역")%></th>
					<td class="pd6">
						<select id="portletTemplete_weather_weatherCity" name="portletTemplete_weather_weatherCity"	style="width: 156px;" />
					</td>
				</tr>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000012", "API 발급키")%></th>
					<td class="pd6">
						<input id="weatherApiKey" type="text" style="width: 350px;"/>
						<input type="button" class="gray_btn" onclick="weatherApiCheck()" value="<%=BizboxAMessage.getMessage("TX000016178", "연결확인")%>"/>
						<div id="testResultContainer"></div>
					</td>
				</tr>
			</table>
		</div>		
		
		<div id="portletTemplete_sign_status_eap" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000002975", "결재함")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" id="portletTemplete_sign_status_eap_val00" /> <label for="portletTemplete_sign_status_eap_val00"><%=BizboxAMessage.getMessage("TX000005555", "미결함")%></label>
						<input type="checkbox" id="portletTemplete_sign_status_eap_val01" class="ml10"/> <label for="portletTemplete_sign_status_eap_val01"><%=BizboxAMessage.getMessage("TX000010091", "예결함")%></label>
						<input type="checkbox" id="portletTemplete_sign_status_eap_val02" class="ml10"/> <label for="portletTemplete_sign_status_eap_val02"><%=BizboxAMessage.getMessage("TX000018507", "수신참조함")%></label>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX900000013", "결재요청문서 상태")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" id="portletTemplete_sign_status_eap_val04" /> <label for="portletTemplete_sign_status_eap_val04"><%=BizboxAMessage.getMessage("TX000000475", "진행중")%></label>
					</td>
				</tr>
			</table>
		</div>		
		
		<div id="portletTemplete_sign_status_ea" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000002975", "결재함")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" id="portletTemplete_sign_status_ea_val00"  /> <label for="portletTemplete_sign_status_ea_val00"><%=BizboxAMessage.getMessage("TX000008298", "결재대기문서")%></label>
						<input type="checkbox" id="portletTemplete_sign_status_ea_val01"  /> <label for="portletTemplete_sign_status_ea_val01"><%=BizboxAMessage.getMessage("TX000010199", "결재완료문서")%></label>
						<input type="checkbox" id="portletTemplete_sign_status_ea_val02"  /> <label for="portletTemplete_sign_status_ea_val02"><%=BizboxAMessage.getMessage("TX000010198", "결재반려문서")%></label>
						<input type="checkbox" id="portletTemplete_sign_status_ea_val03"  /> <label for="portletTemplete_sign_status_ea_val03"><%=BizboxAMessage.getMessage("TX000010204", "상신문서")%></label>
						<input type="checkbox" id="portletTemplete_sign_status_ea_val04"  /> <label for="portletTemplete_sign_status_ea_val04"><%=BizboxAMessage.getMessage("TX000010201", "열람문서")%></label>
						<input type="checkbox" id="portletTemplete_sign_status_ea_val05"  /> <label for="portletTemplete_sign_status_ea_val05"><%=BizboxAMessage.getMessage("TX000010200", "결재예정문서")%></label>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("", "결재요청문서 상태")%></th>
					<td align="left" style="border-left: 0px;">
						<input type="checkbox" name="portletTemplete_sign_status_ea_displayOption" id="portletTemplete_sign_status_ea_val06" /> <label for="portletTemplete_sign_status_ea_val06"><%=BizboxAMessage.getMessage("TX000000475", "진행중")%></label>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="portletTemplete_sign_form_eap" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<div class="controll_btn mt8" style="float:right;">
				<button id="" onclick="fnEaFormPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
			</div>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000015", "기본 결재양식")%></th>
					<td>
						<ul class="multibox p0 m0 mr5" style="width: 100%;" id="portletTemplete_sign_form_eap_listBox"></ul>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="portletTemplete_sign_form_ea" class="com_ta" style="margin-top:20px;display:none;">
			<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
			<div class="controll_btn mt8" style="float:right;">
				<button id="" onclick="fnNonEaBoxPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
			</div>
			<table>
				<colgroup>
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000015", "기본 결재양식")%></th>
					<td>
						<ul class="multibox p0 m0 mr5" style="width: 100%;" id="portletTemplete_sign_form_ea_listBox"></ul>
					</td>
					</td>
				</tr>
			</table>
		</div>			
		
		<div id="imgSetList" style="display:none;">
			<div class="clear">
				<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016262", "배너설정")%></p>
				<div class="controll_btn mt8">
					<button id=""  onclick="fnbutton('add','')"><%=BizboxAMessage.getMessage("TX000017975", "배너추가")%></button>
				</div>
			</div>
			<div id="sortable" class="portal_cc_top"></div>
		</div>			
	</div>
	
	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button"
				value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>"
				onclick="fnSavePortal();" /> <input type="button" class="gray_btn"
				value="<%=BizboxAMessage.getMessage("TX000002947", "취소")%>"
				onclick="fnclose();" />
		</div>
	</div>	
	
</div>
	
<div id="portlet_model" style="display: none;">
	<div link_seq="0" link_nm="" link_url="" file_id="0" use_yn="Y"
		show_from="" show_to="" ssoUseYn="" ssoType="" ssoUserId=""
		ssoCompSeq="" ssoPwd="" sspErpSeq="" ssoLoginCd="" ssoErpCompSeq=""
		class="portal_portlet">
		<span name="link_seq"
			style="padding: 15px; font-size: 10pt; font-weight: bold;"></span> <img
			class="portlet_img" src="" width="200"
			height="${portletSetInfo.abjustHeightSet}"> <span
			class="link_sts"></span> <input onclick="fnbutton('img',this)"
			style="margin-left: 50px;" type="button"
			value="<%=BizboxAMessage.getMessage("TX000016157", "이미지변경")%>" /> <input
			onclick="fnbutton('set',this)" type="button"
			value="<%=BizboxAMessage.getMessage("TX000006443", "링크설정")%>" /> <input
			onclick="fnbutton('del',this)" type="button"
			value="<%=BizboxAMessage.getMessage("TX000000424", "삭제")%>" />
	</div>
	<input name="IMG_PORTAL_BANNER" id="file_upload" type="file" />
</div>	


<script>

	//로딩이미지
	$(document).bind("ajaxStart", function () {
		kendo.ui.progress($(".pop_wrap"), true);
	}).bind("ajaxStop", function () {
		kendo.ui.progress($(".pop_wrap"), false);
	});
	
	var portletInfo = opener.selectedPortlet;
	var portletBoxType = portletInfo.portletBoxType;
	var eaType = "${loginVo.eaType}";
	var ImgMode = "";
	var ImgKey = "";
	


	$(document).ready(function() {
		
		$("#portletTypeName").html(portletInfo.portletBoxTitle);
		$("#portletKrName").val(portletInfo.portletBoxTitle);
		
		var portletOption = portletInfo.portletInfo;
		
		if(portletOption != null && portletOption != "" && portletOption != "demo"){

			$('input:radio[name="useYn"]').filter("[value=" + portletOption.useYn + "]")[0].checked = true;
			
			if(portletOption.port_name_kr != null && portletOption.port_name_kr != ""){
				$("#portletKrName").val(portletOption.port_name_kr);	
			}
	    	
	    	$("#portletCnName").val(portletOption.port_name_cn);
	    	$("#portletJpName").val(portletOption.port_name_jp);
	    	$("#portletEnName").val(portletOption.port_name_en);				
		}
		
		$("#" + portletBoxType).show();
		
		if(portletBoxType == "portletTemplete_mybox"){
			//내정보
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				
				if(portletOption.val01 == "Y"){
					$("#portletTemplete_mybox_val01")[0].checked = true;	
				}
				
				if(portletOption.val02 == "Y"){
					$("#portletTemplete_mybox_val02")[0].checked = true;	
				}
				
				if(portletOption.val03 == "Y"){
					$("#portletTemplete_mybox_val03")[0].checked = true;	
				}				

				fnRadioButtonEvent("myInfo",portletOption.displayOption);
			}
			
			fnAttendCheck();
			
		}else if(portletBoxType == "portletTemplete_web_sign"){
			//결재함리스트
			$("#divPortletNameSet").show();
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				
		    	$("#portletTemplete_web_sign_listCnt").val(portletOption.val1);
		    	$('input:radio[name="portletTemplete_web_sign_displayOption"]').filter("[value=" + portletOption.val2 + "]")[0].checked = true;
		    	console.log(Array.isArray(portletOption.val0));
				if(portletOption.val0 != ""){
					if(Array.isArray(portletOption.val0) === true) {
						var opValue = "";
						var opValueArray = portletOption.val0.sort(function(a, b){
							return a.order - b.order;
						});	
						opValueArray.forEach(function(item){
							opValue += item.menu_seq + ",";
						});
						
						tblParam = {};
						tblParam.opValue = opValue.slice(0,-1);
					} else {
						tblParam = {};
						tblParam.opValue = portletOption.val0
					}
							
					$.ajax({
			        	type:"post",
			    		url:'getEaBoxPortletInfo.do',
			    		datatype:"json",
			            data: tblParam ,
			    		success: function (data) {
			    			$("#portletTemplete_web_sign_listBox").html("");
			    			var InnerHTML = "";
			    			var orderDataList = [];
			    			
			    			if(Array.isArray(portletOption.val0) === true) {
			    				opValueArray.forEach(function(item, index) {
				    				for(var i = 0; i < data.list.length; i++) {
				    					if(item.menu_seq == data.list[i].menuNo) {
				    						orderDataList.push(data.list[i]);
				    					}
				    				}
				    			});
			    			} else {
			    				orderDataList = data.list;
			    			}
			    			
			    			
			    						    			
			    			for(var i=0; i<orderDataList.length; i++){	
			    				var targetID = orderDataList[i].menuNo;
			    	    		InnerHTML += "<li id='" + targetID + "' name='eaBox'>";
			    	    		InnerHTML += orderDataList[i].menuNm
			    	    		InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""+ targetID +"\")'>";
			    	    		InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
			    	    		InnerHTML += "</a></li>";
			    			}
			    			
			    			
			    			$("#portletTemplete_web_sign_listBox").html(InnerHTML);
		    		    } ,
					    error: function (result) { 
					    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
					    }
			    	});	
				}
			}			
		}else if(portletBoxType == "portletTemplete_sign_form"){
			//결재양식
			$("#divPortletNameSet").show();
			
			if(eaType == "ea"){
				//비영리
				$("#" + portletBoxType + "_ea").show();
				
				if(portletOption != null && portletOption != "" && portletOption != "demo"){
					
					if(portletOption.val0){
						tblParam = {};
						tblParam.opValue = portletOption.val0;
						
						$.ajax({
				        	type:"post",
				    		url:'getNonEaFormPortletInfo.do',
				    		datatype:"json",
				            data: tblParam ,
				    		success: function (data) {
					    			$("#portletTemplete_sign_form_ea_listBox").html("");
					    			var InnerHTML = "";
					    			for(var i=0;i<data.list.length;i++){	
					    				var targetID = data.list[i].formId;
					    	    		InnerHTML += "<li id='" + targetID + "' name='nonEaForm'>";
					    	    		InnerHTML += data.list[i].formNm
					    	    		InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""+ targetID +"\")'>";
					    	    		InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
					    	    		InnerHTML += "</a></li>";
					    			}
					    			$("#portletTemplete_sign_form_ea_listBox").html(InnerHTML);
				    		    } ,
						    error: function (result) { 
						    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
						    		}
				    	});	
					}		
				}				
			}else{
				//영리
				$("#" + portletBoxType + "_eap").show();
				
				if(portletOption != null && portletOption != "" && portletOption != "demo"){
					
					if(portletOption.val0){
						tblParam = {};
						tblParam.opValue = portletOption.val0;
						
						$.ajax({
				        	type:"post",
				    		url:'getEaFormPortletInfo.do',
				    		datatype:"json",
				            data: tblParam ,
				    		success: function (data) {
					    			$("#portletTemplete_sign_form_eap_listBox").html("");
					    			var InnerHTML = "";
					    			for(var i=0;i<data.list.length;i++){	
					    				var targetID = data.list[i].formId;
					    	    		InnerHTML += "<li id='" + targetID + "' name='eaForm'>";
					    	    		InnerHTML += data.list[i].formNm
					    	    		InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""+ targetID +"\")'>";
					    	    		InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
					    	    		InnerHTML += "</a></li>";
					    			}
					    			$("#portletTemplete_sign_form_eap_listBox").html(InnerHTML);
				    		    } ,
						    error: function (result) { 
						    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
						    		}
				    	});	
					}			
				}
			}
		}else if(portletBoxType == "portletTemplete_sign_status"){
			//결재현황
			$("#divPortletNameSet").show();
			
			if(eaType == "ea"){
				//비영리
				$("#" + portletBoxType + "_ea").show();
				
				if(portletOption != null && portletOption != "" && portletOption != "demo"){
					$("#portletTemplete_sign_status_ea_val00")[0].checked = portletOption.val00;
					$("#portletTemplete_sign_status_ea_val01")[0].checked = portletOption.val01;
					$("#portletTemplete_sign_status_ea_val02")[0].checked = portletOption.val02;
					$("#portletTemplete_sign_status_ea_val03")[0].checked = portletOption.val03;
					$("#portletTemplete_sign_status_ea_val04")[0].checked = portletOption.val04;
					$("#portletTemplete_sign_status_ea_val05")[0].checked = portletOption.val05;
					$("#portletTemplete_sign_status_ea_val06")[0].checked = portletOption.val06;						
				}				
			}else{
				//영리
				$("#" + portletBoxType + "_eap").show();
				
				if(portletOption != null && portletOption != "" && portletOption != "demo"){
					$("#portletTemplete_sign_status_eap_val00")[0].checked = portletOption.val00;
					$("#portletTemplete_sign_status_eap_val01")[0].checked = portletOption.val01;
					$("#portletTemplete_sign_status_eap_val02")[0].checked = portletOption.val02;
					$("#portletTemplete_sign_status_eap_val04")[0].checked = portletOption.val04;					
				}
			}
		}else if(portletBoxType == "portletTemplete_mail_status"){
			//메일현황
			$("#divPortletNameSet").show();
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				
				if(portletOption.val0 == "Y"){
					$("#portletTemplete_mail_status_val00")[0].checked = true;	
				}
				
				if(portletOption.val1 == "Y"){
					$("#portletTemplete_mail_status_val01")[0].checked = true;	
				}				
				
			}	
		}else if(portletBoxType == "portletTemplete_inbox"){
			//받은편지함
			$("#divPortletNameSet").show();
			
			var opValue = "0";
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				opValue = portletOption.val0;
				
				if(portletOption.val1 == "Y"){
					$("#portletTemplete_inbox_val01")[0].checked = true;	
				}
				
				$("#portletTemplete_inbox_val02").val(portletOption.val2);
			}	
			
			var ddlActType = NeosCodeUtil.getCodeList("cm1020"); 
		    $("#portletTemplete_inbox_mailSelect").kendoComboBox({
		        dataSource : ddlActType,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        value: opValue
		    });
		    
		    if(opValue == "")
		    	$('#portletTemplete_inbox_mailSelect').data('kendoComboBox').value("0");
		    else
		    	$('#portletTemplete_inbox_mailSelect').data('kendoComboBox').value(opValue);			

		}else if(portletBoxType == "portletTemplete_board"){
			//게시판
			$("#divPortletNameSet").show();
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
		 		$("#portletTemplete_board_boardName").val(portletOption.val0);
		 		$("#portletTemplete_board_boardID").val(portletOption.val1);
		 		$("#portletTemplete_board_boardCount").val(portletOption.val2);				
			}
		}else if(portletBoxType == "portletTemplete_doc"){
			//문서 다국어 html 테이블
			$("#divPortletNameSet").show();
			
			//문서 옵션값 셋팅 구문 
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
		 		$("#portletTemplete_doc_docName").val(portletOption.val0);
		 		$("#portletTemplete_doc_dirCd").val(portletOption.val1);
		 		$("#portletTemplete_doc_docType").val(portletOption.val2);		
		 		$("#portletTemplete_doc_docLvl").val(portletOption.val3);
		 		$("#portletTemplete_doc_docCount").val(portletOption.val4);		 		
			}			
			
		}else if(portletBoxType == "portletTemplete_calendar_horizontal" || portletBoxType == "portletTemplete_calendar_vertical"){
			//일정
			$("#divPortletNameSet").show();
			$("#portletTemplete_calendar").show();
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				
				if(portletOption.val0 == "Y"){
					$("#portletTemplete_calendar_val00")[0].checked = true;
				}else{
					$("#portletTemplete_calendar_val00")[0].checked = false;
				}
				
				if(portletOption.val1 == "Y"){
					$("#portletTemplete_calendar_val01")[0].checked = true;
				}else{
					$("#portletTemplete_calendar_val01")[0].checked = false;
				}
				
				if(portletOption.val2 == "Y"){
					$("#portletTemplete_calendar_val02")[0].checked = true;
				}else{
					$("#portletTemplete_calendar_val02")[0].checked = false;
				}
				
			}
			
			//일정캘린더 일정표시 옵션 초기화하기 위해 페이지 랜더시 호출한다.
			settingCalenderDefaultOption();
			
			if(portletOption.val3) {
				var defaultOption = portletOption.val3;
				$("input[name=defaultCalenderType]").prop("checked", false);
				switch  (defaultOption){
					case "private":
						$($("input[name=defaultCalenderType]")[1]).prop("checked", true);
						break;
					case "share":
						$($("input[name=defaultCalenderType]")[2]).prop("checked", true);
						break;
					case "special":
						$($("input[name=defaultCalenderType]")[3]).prop("checked", true);
						break;
					case "all": 
						$($("input[name=defaultCalenderType]")[0]).prop("checked", true);
						break;
				}
			}
			
		}else if(portletBoxType == "portletTemplete_weather"){
			//날씨
			var opValue = "60,127";
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				opValue = portletOption.val0;
			}			
			
			var ddlActType = NeosCodeUtil.getCodeList("cm1010"); 
		    $("#portletTemplete_weather_weatherCity").kendoComboBox({
		        dataSource : ddlActType,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        value: opValue
		    });			
			
		    $('#portletTemplete_weather_weatherCity').data('kendoComboBox').value(opValue);
		    
		    $.ajax({
		    	type: "post",
		    	url: "getWeatherApiKey.do",
		    	dataType: "json",
		    	success: function(data){
		    		$("#weatherApiKey").val(data.weatherApiKey);
		    	},
		    	error: function(data){
		    		console.log(data);
		    	}
		    })
		    
		}else if(portletBoxType == "portletTemplete_iframe_banner"){
			//배너
			fnImgSetListInit();
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				$("#portletTemplete_iframe_banner_bn_pause").val(portletOption.val0);
				$("#portletTemplete_iframe_banner_bn_speed").val(portletOption.val1);
				$('input:radio[name="portletTemplete_iframe_banner_moBtn"]').filter("[value=" + portletOption.val3 + "]")[0].checked = true;
				$('input:radio[name="portletTemplete_iframe_banner_moveTp"]').filter("[value=" + portletOption.val2 + "]")[0].checked = true;
				fnRadioButtonEvent("banner",portletOption.val4);
				
				//링크리스트 바인딩
				if(portletOption.linkList.length > 0){
					fnLinkListBind("banner",portletOption.linkList);
				}
			}
		}else if(portletBoxType == "portletTemplete_iframe_quick"){
			//퀵링크
			fnImgSetListInit();
			
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				$("#portletTemplete_iframe_quick_qu_pause").val(portletOption.val0);
				$('input:radio[name="portletTemplete_iframe_quick_dirTp"]').filter("[value=" + portletOption.val1 + "]")[0].checked = true;
				
				//링크리스트 바인딩
				if(portletOption.linkList.length > 0){
					fnLinkListBind("banner",portletOption.linkList);
				}
			}
		}else if(portletBoxType == "portletTemplete_iframe_outer"){
			//아이프레임
			if(portletOption != null && portletOption != "" && portletOption != "demo"){
				$("#portletTemplete_iframe_outer_if_url").val(portletOption.ifUrl);
				
				//링크리스트 바인딩
				if(portletOption.linkList.length > 0){
					fnLinkListBind("iframe",portletOption.linkList);
				}else{
					$("#sortable").append($("#portlet_model .portal_portlet").attr("link_seq","-1").clone());
				}
			}else{
				$("#sortable").append($("#portlet_model .portal_portlet").attr("link_seq","-1").clone());
			}
		}else{
			//포틀릿명망 설정
			$("#divPortletNameSet").show();
		}
		
		//일정캘린더 일정표시 옵션 변경시 기본값 설정이 변경된다.
		$("input[name=calenderOptionCheckbox]").change(function() {
			settingCalenderDefaultOption();
		});
		
	});
	
	function settingCalenderDefaultOption() {
		/*
		* #portletTemplete_calendar_val00 == 전체개인일정
		* #portletTemplete_calendar_val01 == 전체공유일정
		* #portletTemplete_calendar_val02 == 기념일
		*/
		var optionCheck = [];
		var checkDefaultRadio = false;
		
		// 라디오 태그 초기화
		$("input[name=defaultCalenderType]").prop("checked",false);
		$("input[name=defaultCalenderType]").attr("disabled",false);
		
		// 일정표시 체크박스 정보를 조회
		optionCheck[0] = !$("#portletTemplete_calendar_val00").is(":checked");
		optionCheck[1] = !$("#portletTemplete_calendar_val01").is(":checked");
		optionCheck[2] = !$("#portletTemplete_calendar_val02").is(":checked");
		
		optionCheck.forEach(function(item, index){
			
			$($("input[name=defaultCalenderType]")[index + 1]).attr("disabled", optionCheck[index]);
			
			// 기념일 체크시 전체일정 disable 설정을 한다. 
			if(index == 2) {
				if(optionCheck[0] && optionCheck[1] && !optionCheck[2]) {
					$($("input[name=defaultCalenderType]")[0]).attr("disabled", true);
				} else if(optionCheck[0] && optionCheck[1] && optionCheck[2]) {
					$("input[name=defaultCalenderType]").attr("disabled", true);
				}
				
				// default 선택을 하기위해 추가한 로직
				for(var i = 0; $("input[name=defaultCalenderType]").length > i; i++){
					var target = $("input[name=defaultCalenderType]")[i];
					
					// checkDefaultRadio 플래그는 default 기본옵션이 선택되어있는지 판별하는 플래그
					// 현재 옵션이 disable이 아니고 default로 선택한 옵션이 없다면 선택 
					if($(target).prop("disabled") == false && checkDefaultRadio == false) {
						
						// 일정표시 옵션이 전체 선택일때 기본값 설정을 개인일정을 default로 설정한다.
						if(i === 0 && (optionCheck[0] === false && optionCheck[1] === false && optionCheck[2] === false)) {
							continue;
						}
						
						$(target).prop("checked", true);
						checkDefaultRadio = true;
						
					}
					
				}
			}
		});
	}
	
	function fnLinkListBind(type, linkList){
		
	    $.each(linkList, function (i, t) {
			$("#portlet_model .portal_portlet").attr("link_seq", t.link_seq);
			$("#portlet_model .portal_portlet").attr("link_nm", t.link_nm);
			$("#portlet_model .portal_portlet").attr("file_id", t.file_id);
			$("#portlet_model .portal_portlet").attr("use_yn", t.use_yn);
			$("#portlet_model .portal_portlet").attr("show_from", t.show_from);
			$("#portlet_model .portal_portlet").attr("show_to", t.show_to);
			$("#portlet_model .portal_portlet").attr("ssoUseYn", t.ssoUseYn);
			$("#portlet_model .portal_portlet").attr("ssoType", t.ssoType);
			$("#portlet_model .portal_portlet").attr("ssoUserId", t.ssoUserId);
			$("#portlet_model .portal_portlet").attr("ssoCompSeq", t.ssoCompSeq);
			$("#portlet_model .portal_portlet").attr("ssoEncryptType", t.ssoEncryptType);
			$("#portlet_model .portal_portlet").attr("ssoEncryptKey", t.ssoEncryptKey);
			$("#portlet_model .portal_portlet").attr("ssoTimeLink", t.ssoTimeLink);
			$("#portlet_model .portal_portlet").attr("ssoEncryptScope", t.ssoEncryptScope);
			$("#portlet_model .portal_portlet").attr("sspErpSeq", t.sspErpSeq);
			$("#portlet_model .portal_portlet").attr("ssoLoginCd", t.ssoLoginCd);
			$("#portlet_model .portal_portlet").attr("ssoErpCompSeq", t.ssoErpCompSeq);
			$("#portlet_model .portal_portlet").attr("ssoEtcName", t.ssoEtcName);
			$("#portlet_model .portal_portlet").attr("ssoEtcValue", t.ssoEtcValue);
			$("#portlet_model .portal_portlet").attr("link_url", t.link_url);
			$("#portlet_model img").attr("src", "/gw/cmm/file/fileDownloadProc.do?fileId="+t.file_id+"&fileSn=0");
			
			$("#sortable").append($("#portlet_model .portal_portlet").clone());
	    });
	    
	    if(type != "iframe"){
	    	refreshSeq();	
	    }
	    
		$("#portlet_model .portal_portlet").attr("link_seq", "");
		$("#portlet_model .portal_portlet").attr("link_nm", "");
		$("#portlet_model .portal_portlet").attr("file_id", "");
		$("#portlet_model .portal_portlet").attr("use_yn", "");
		$("#portlet_model .portal_portlet").attr("show_from", "");
		$("#portlet_model .portal_portlet").attr("show_to", "");
		$("#portlet_model .portal_portlet").attr("ssoUseYn", "");
		$("#portlet_model .portal_portlet").attr("ssoType", "");
		$("#portlet_model .portal_portlet").attr("ssoUserId", "");
		$("#portlet_model .portal_portlet").attr("ssoCompSeq", "");
		$("#portlet_model .portal_portlet").attr("ssoEncryptType", "");
		$("#portlet_model .portal_portlet").attr("ssoEncryptKey", "");
		$("#portlet_model .portal_portlet").attr("ssoTimeLink", "");
		$("#portlet_model .portal_portlet").attr("ssoEncryptScope", "");
		$("#portlet_model .portal_portlet").attr("sspErpSeq", "");
		$("#portlet_model .portal_portlet").attr("ssoLoginCd", "");
		$("#portlet_model .portal_portlet").attr("ssoErpCompSeq", "");
		$("#portlet_model .portal_portlet").attr("ssoEtcName", "");
		$("#portlet_model .portal_portlet").attr("ssoEtcValue", "");
		$("#portlet_model .portal_portlet").attr("link_url", "");
		$("#portlet_model img").attr("src", "");    
	}
	
	function fnSavePortal(){
		
 		if($("#portletKrName").val() == "") {
 			alert("필수값이 입력되지 않았습니다.");
 			$("#portletKrName").focus();
 			return;
 		}
		
 			var optionInfo = {};
 			optionInfo.useYn = $("[name=useYn]:checked").val();
 	    	optionInfo.port_name_kr = $("#portletKrName").val();
 	    	optionInfo.port_name_cn = $("#portletCnName").val();
 	    	optionInfo.port_name_jp = $("#portletJpName").val();
 	    	optionInfo.port_name_en = $("#portletEnName").val(); 			
 			
 			if(portletBoxType == "portletTemplete_mybox"){
 				//내정보
				optionInfo.displayOption = $("[name=portletTemplete_mybox_displayOption]:checked").val();
 				
 				if($("#portletTemplete_mybox_val01")[0].checked){
 					optionInfo.val01 = "Y";
 				}else{
 					optionInfo.val01 = "N";
 				}
 				
 				if($("#portletTemplete_mybox_val02")[0].checked){
 					optionInfo.val02 = "Y";
 				}else{
 					optionInfo.val02 = "N";
 				} 
 				
 				if($("#portletTemplete_mybox_val03")[0].checked){
 					optionInfo.val03 = "Y";
 				}else{
 					optionInfo.val03 = "N";
 				}  				
				
 			}else if(portletBoxType == "portletTemplete_web_sign"){
 				//결재함리스트
				var eaBoxList = $("li[name=eaBox]");
				var menuNoList = "";
				
		    	for(var i=0;i<eaBoxList.length;i++){
		    		menuNoList += "," + eaBoxList[i].id;
		    	}		    	
		    	if(menuNoList.length > 0)
		    		menuNoList = menuNoList.substring(1);
		    	
		 		if((menuNoList.length == 0 || menuNoList == "") || ($("#portletTemplete_web_sign_listCnt").val() == 0 || $("#portletTemplete_web_sign_listCnt").val() == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
		    			 		
		 		var menuNoListArray = menuNoList.split(",");
		 		var menuNoListOrderJson = menuNoListArray.map(function(item, index) {
		 			return {menu_seq: item, order: index}
		 		});
		 				 		
		    	optionInfo.val0 = menuNoListOrderJson;
		    	optionInfo.val1 = $("#portletTemplete_web_sign_listCnt").val();
		    	optionInfo.val2 = $("[name=portletTemplete_web_sign_displayOption]:checked").val();


 			}else if(portletBoxType == "portletTemplete_sign_form"){
 				//결재양식
 				var eaFormList;
 				var formIdList = "";
 				
 				if(eaType == "ea"){
 					//비영리
 					eaFormList = $("li[name=nonEaForm]");
 				}else{
 					//영리
 					eaFormList = $("li[name=eaForm]");
 				}
		    	
		    	for(var i=0;i<eaFormList.length;i++){
		    		formIdList += "," + eaFormList[i].id;
		    	}
		    	
		    	if(formIdList.length > 0)
		    		formIdList = formIdList.substring(1);
		    	
		 		if($("#portletKrName").val() == "" || (formIdList.length == 0 || formIdList == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			return
			 	}		    	
		    	
		    	optionInfo.val0 = formIdList;
		    	
 			}else if(portletBoxType == "portletTemplete_sign_status"){
 				//결재양식
 				
 				if(eaType == "ea"){
 					//비영리
 					optionInfo.val00 = $("#portletTemplete_sign_status_ea_val00")[0].checked;
 					optionInfo.val01 = $("#portletTemplete_sign_status_ea_val01")[0].checked;
 					optionInfo.val02 = $("#portletTemplete_sign_status_ea_val02")[0].checked;
 					optionInfo.val03 = $("#portletTemplete_sign_status_ea_val03")[0].checked; 					
 					optionInfo.val04 = $("#portletTemplete_sign_status_ea_val04")[0].checked;
 					optionInfo.val05 = $("#portletTemplete_sign_status_ea_val05")[0].checked;
 					optionInfo.val06 = $("#portletTemplete_sign_status_ea_val06")[0].checked;
 					
 					if(!optionInfo.val00 && !optionInfo.val01 && !optionInfo.val02 && !optionInfo.val03 && !optionInfo.val04 && !optionInfo.val05){
 			 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
 			 			return; 						
 					}
 				}else{
 					//영리
 					optionInfo.val00 = $("#portletTemplete_sign_status_eap_val00")[0].checked;
 					optionInfo.val01 = $("#portletTemplete_sign_status_eap_val01")[0].checked;
 					optionInfo.val02 = $("#portletTemplete_sign_status_eap_val02")[0].checked;
 					optionInfo.val04 = $("#portletTemplete_sign_status_eap_val04")[0].checked;
 					
 					if(!optionInfo.val00 && !optionInfo.val01 && !optionInfo.val02){
 			 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
 			 			return; 						
 					} 					
 				}
 			}else if(portletBoxType == "portletTemplete_mail_status"){
 				//메일현황
 				
 				if($("#portletTemplete_mail_status_val00")[0].checked){
 					optionInfo.val0 = "Y";
 				}else{
 					optionInfo.val0 = "N";
 				}
 				
 				if($("#portletTemplete_mail_status_val01")[0].checked){
 					optionInfo.val1 = "Y";
 				}else{
 					optionInfo.val1 = "N";
 				} 				

				if(optionInfo.val0 == "N" && optionInfo.val1 == "N"){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			return; 						
				}
 			}else if(portletBoxType == "portletTemplete_inbox"){
 				//받은편지함
 				optionInfo.val0 = $('#portletTemplete_inbox_mailSelect').data('kendoComboBox').value();
 				
 				if($("#portletTemplete_inbox_val01")[0].checked == true){
 					optionInfo.val1 = "Y";
 				}else{
 					optionInfo.val1 = "N";
 				}
 				
 				optionInfo.val2 = $("#portletTemplete_inbox_val02").val();
 				
				if(optionInfo.val2 == "0" || optionInfo.val2 == ""){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			$("#portletTemplete_inbox_val02").focus();
		 			return;
				} 				

 			}else if(portletBoxType == "portletTemplete_board"){

				let str = $("#portletTemplete_board_boardName").val();

				if(!checkXSS(str) || !checkSmallDot(str) || !checkBigDot(str)){
					$("#portletTemplete_board_boardName").val("");
					$("#portletTemplete_board_boardName").focus();
					return;
				}

				optionInfo.val0 = str;	
 				optionInfo.val1 = $("#portletTemplete_board_boardID").val();
 				optionInfo.val2 = $("#portletTemplete_board_boardCount").val();
				if(optionInfo.val1 == "" || optionInfo.val2 == "0" || optionInfo.val2 == ""){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			return;
				}
 			}else if(portletBoxType == "portletTemplete_doc"){
 				//문서
 				optionInfo.val0 = $("#portletTemplete_doc_docName").val();
 				optionInfo.val1 = $("#portletTemplete_doc_dirCd").val();
 				optionInfo.val2 = $("#portletTemplete_doc_docType").val();
 				optionInfo.val3 = $("#portletTemplete_doc_docLvl").val();
 				optionInfo.val4 = $("#portletTemplete_doc_docCount").val();
 				
 				
				if(optionInfo.val0 == "" || optionInfo.val4 == ""){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			return;
				}
			}else if(portletBoxType == "portletTemplete_calendar_horizontal" || portletBoxType == "portletTemplete_calendar_vertical"){
 				//일정
 				if($("#portletTemplete_calendar_val00")[0].checked == true){
 					optionInfo.val0 = "Y";
 				}else{
 					optionInfo.val0 = "N";
 				} 
 				
 				if($("#portletTemplete_calendar_val01")[0].checked == true){
 					optionInfo.val1 = "Y";
 				}else{
 					optionInfo.val1 = "N";
 				} 
 				
 				if($("#portletTemplete_calendar_val02")[0].checked == true){
 					optionInfo.val2 = "Y";
 				}else{
 					optionInfo.val2 = "N";
 				}
 				
 				// 기본 옵션 설정
				optionInfo.val3 = $("input:radio[name=defaultCalenderType]:checked").val() == undefined ? 
		 			null : $("input:radio[name=defaultCalenderType]:checked").val();
		 		
 				
				if(optionInfo.val0 == "N" && optionInfo.val1 == "N" && optionInfo.val2 == "N"){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			return;
				}
 			}else if(portletBoxType == "portletTemplete_weather"){
 				// API 키가 인증된 키인지 인증 플래그 값을 가져온다.
 				var isWeatherApi = $("#weatherApiKey").attr("isWeatherApi");
 				
 				// API 인증 플래그가 undefined, null, "false" 일경우 저장을 하지 않는다.
 				if(isWeatherApi === undefined || isWeatherApi === null || isWeatherApi === "false"){
 					alert("<%=BizboxAMessage.getMessage("","날씨 API키 인증이 완료되지 않았습니다.")%>");
 					return;
 				}
 				
 				//날씨
 				optionInfo.val0 = $('#portletTemplete_weather_weatherCity').data('kendoComboBox').value();
 				optionInfo.val1 = $('#portletTemplete_weather_weatherCity').data('kendoComboBox').text();
 				var weatherApiKey = $("#weatherApiKey").val() == null ? "" : $("#weatherApiKey").val();
 				
 				opener.setWeatherApiKey(weatherApiKey);
 			}else if(portletBoxType == "portletTemplete_iframe_banner"){
 				//배너
 				optionInfo.val4 = $("[name=portletTemplete_iframe_banner_imageChoice]:checked").val();
 				optionInfo.val0 = $("#portletTemplete_iframe_banner_bn_pause").val();
 				optionInfo.val1 = $("#portletTemplete_iframe_banner_bn_speed").val();
 				optionInfo.val2 = $("[name=portletTemplete_iframe_banner_moveTp]:checked").val();
 				optionInfo.val3 = $("[name=portletTemplete_iframe_banner_moBtn]:checked").val();
 				optionInfo.linkList = fnGetLinkList("banner");
 				
 				if(optionInfo.val4 == "Y" && ($("#portletTemplete_iframe_banner_bn_pause").val() == "" || $("#portletTemplete_iframe_banner_bn_speed").val() == "")){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			return; 					
 				}
 			}else if(portletBoxType == "portletTemplete_iframe_quick"){
 				//퀵링크
 				optionInfo.val0 = $("#portletTemplete_iframe_quick_qu_pause").val();
 				optionInfo.val1 = $("[name=portletTemplete_iframe_quick_dirTp]:checked").val();
 				optionInfo.linkList = fnGetLinkList("banner");
 				
 				if($("#portletTemplete_iframe_quick_qu_pause").val() == ""){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			$("#portletTemplete_iframe_quick_qu_pause").focus();
		 			return; 					
 				}
				 
 			}else if(portletBoxType == "portletTemplete_iframe_outer"){
 				
 				var str = $("#portletTemplete_iframe_outer_if_url").val()

				if(!checkUrl(str)){
					$("#portletTemplete_iframe_outer_if_url").val("");
					$("#portletTemplete_iframe_outer_if_url").focus();
					return;
				}

				var iframeUrl = str;

			
				
				
 				//아이프레임
 				if(iframeUrl == ""){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수 값이 입력되지 않았습니다.")%>");
		 			$("#portletTemplete_iframe_outer_if_url").focus();
		 			return; 					
 				} 
				 else if(iframeUrl.indexOf("\\") > -1 || iframeUrl.indexOf("'") > -1) {
 					alert("저장 불가한 문자가 입력되었습니다. (\\ , ') 금지 ");
 					return;
 				}
				 
			

		

				 

 				
 				var text = $("#portletTemplete_iframe_outer_if_url").val();
 				var hangleUrl = text.replace(/[^ㄱ-ㅎ가-힣]/gi,"");
 				var url = text.replace(hangleUrl, encodeURI(hangleUrl));
 				var url1 = url.replace(/%/gi, "^"); 				

 				optionInfo.ifUrl = url1;
 				optionInfo.linkList = fnGetLinkList("iframe");
 				
 				if($("#portletTemplete_iframe_quick_qu_pause").val() == ""){
		 			alert("<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>");
		 			$("#portletTemplete_iframe_quick_qu_pause").focus();
		 			return; 					
 				}
 			}

			 if(!checkSmallDot(optionInfo) || !checkBigDot(optionInfo) || !checkXSS(optionInfo)){
				return;
			  }
 			
			
 			opener.portletSetCallback(JSON.stringify(optionInfo));
 			fnclose();

	}
	
	function fnImgSetListInit(){
		
		$("#imgSetList").show();
		
	    $("#sortable").kendoSortable({
	        connectWith: "#sortable",
	        placeholder: placeholder,
	        change: refreshSeq        
	    });
	    
		//첨부파일처리.	
		$("#file_upload").kendoUpload({
			async: {
            	saveUrl: _g_contextPath_+'/cmm/file/fileUploadProc.do',
                autoUpload: true
            },
            localization: {
				select: "<%=BizboxAMessage.getMessage("TX000000602","등록")%>"
			},
            showFileList: false,
            upload:function(e) { 
				var dataType = 'json';
				var pathSeq = '900';
				var relativePath = '/portal';
				
				var params = "dataType=" + dataType;
				params += "&pathSeq=" + pathSeq;
				params += "&relativePath=" + relativePath;
				
            	e.sender.options.async.saveUrl = _g_contextPath_+'/cmm/file/fileUploadProc.do?'+params;
            	
            	var inputName =  $(e.sender).attr("name");
            	
            	$('#'+inputName+"_INP").val(e.files[0].name);
            },
            success: onSuccess
		});			
		
		
	}



	function checkSmallDot(str) {


	    var check = true;
	    if(typeof str === "string"){
	    if(str !== null && (str.indexOf("'") > -1) || (str.indexOf("\\") > -1)){
	        alert("저장 불가한 문자가 입력되었습니다. (\\ , ') 금지 ");
	          return false; 
	    }else{
	        return true;
	    }
	   }
	   else if (typeof str === "object"){
	    for(var i = 0; i < Object.keys(str).length; i++){
	        var value = str[Object.keys(str)[i]];
	        if(typeof value === "string"){
	            if(value !== null && (value.indexOf("'") > -1) || (value.indexOf("\\") > -1)){
	               alert("저장 불가한 문자가 입력되었습니다. (\\ , ') 금지 ");
	                check = false;
	                break;
	            }else{
	                check = true;
	            }
	        }else{
	            check = true;
	        }
	    }
	    return check		
	   }

	}



	function checkBigDot(str) {

	    var check = true;
	    if(typeof str === "string"){
	        if(str !== null && (str.indexOf("\"") > -1)){
	            alert("저장 불가한 문자가 입력되었습니다. (\") 금지 ");
	              return false;
	        }else{
	            return true;
	        }
	    }
	    else if (typeof str === "object"){
	        for(var i = 0; i < Object.keys(str).length; i++){
	            var value = str[Object.keys(str)[i]];
	        if(typeof value === "string"){
	            if(value !== null && (value.indexOf("\"") > -1)){
	            alert("저장 불가한 문자가 입력되었습니다. (\") 금지 ");
	            check = false;
	            break;
	              }
	            else{
	                check = true;
	                }
	        }
	        else{
	            check = true;
	        }
	    }
	    return check;		
	   }		
	    }



	 function checkXSS(str) {	
			var check = true;
			var tagRegExp = new RegExp("<script[^>]*>((\n|\r|.)*?)<\\/script>",'i');
			if(typeof str === "string"){
			if(tagRegExp.test(str)){
				var tagResult = tagRegExp.exec(str);
				str = tagResult[0];
				alert("저장 불가한 문자가 입력되었습니다 <script> 금지 ")
				return false;
			}else{		
				return true;
			}
		  }else if (typeof str === "object"){
			for(var i = 0; i < Object.keys(str).length; i++){
	            var value = str[Object.keys(str)[i]];
				if(typeof value === "string"){
				if(tagRegExp.test(value)){
					var tagResult = tagRegExp.exec(value);
					// value = tagResult[0]
					alert("저장 불가한 문자가 입력되었습니다 <script> 금지 ");
					check = false;
					break;
				}else{
					check = true;
				}
				
		    	}else{
		    		check = true;
		    	}
				
			}	
			return check;
		}
		}

	function checkUrl(str){
		var regExp = new RegExp("(http(s)?:\\/\\/)([a-z0-9\\w]+\\.*)+[^'|\"]*" , "i");
		var urlResult = regExp.exec(str);
						
 		if(urlResult !== null){
 			if(urlResult[0] !== str){
 				alert("잘못된 형식의 URL 입니다. ex) http://www.douzone.com  \n \" ' |  사용 불가능" );
 	 			return false;
 			}else{
				return true;
 			}				
 					
 			}else{
 				alert("잘못된 형식의 URL 입니다. ex) http://www.douzone.com " );
	 			return false;
 		}


	}
	
	function fnAttendCheck() {
		$.ajax({
        	type:"post",
    		url:'getAttendCheck.do',
    		datatype:"json",
    		async:false,
    		success: function (data) {
	    		var result = data.list.secomUse;
	    		
	    		if(result == "Y") {
	    			$("#portletTemplete_mybox_val03").prop('disabled', true);
	    			//$("#portletTemplete_mybox_val03_label").hide();
	    		}
   		    } ,
		    error: function (result) { 
    			alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
    		}
    	});	
	}
	
	//라디오버튼 이벤트 (내정보)
	function fnRadioButtonEvent(type, val) {
		
		if(type == "myInfo"){
			$('input:radio[name="portletTemplete_mybox_displayOption"]').filter("[value=" + val + "]")[0].checked = true;
			
			if(val == "profile"){
				$("#portletTemplete_mybox_val01")[0].checked = false;
				$("#portletTemplete_mybox_val02")[0].checked = false;
				$("#portletTemplete_mybox_val03")[0].checked = false;
				$("#portletTemplete_mybox_attendCheck").hide();
			}else{
				$("#portletTemplete_mybox_attendCheck").show();
			}			
		}else if(type == "banner"){
			$('input:radio[name="portletTemplete_iframe_banner_imageChoice"]').filter("[value=" + val + "]")[0].checked = true;
			
			if(val == "Y"){
				$("[name=portletTemplete_iframe_banner_slide_option]").show();
			}else{
				$("[name=portletTemplete_iframe_banner_slide_option]").hide();
			}			
		}
	}
	
	function fnBannerOption() {
		$("input[name='imageChoice']").click(function(){
			if($(this).val() == "Y") {
				$("#bannerOption").show();
			} else if ($(this).val() == "N") {
				$("#bannerOption").hide();
			}
		});
	}
	
	function refreshSeq(){
	    $.each($("#sortable span[name=link_seq]"), function (i, t) {
	    	$(t).html(i+1);
	    	
	    	$(t).closest("div").attr("link_seq", $(t).text());
	    });		
	}
	
	function fnbutton(mode, obj){
		ImgMode = mode;
		
		if(mode == "add"){
			$("#file_upload").click();
		}else if (mode == "img"){
			ImgKey = $(obj).parent().attr("link_seq");
			$("#file_upload").click();
		}else if (mode == "del"){
			
			$(obj).parent().remove();
			refreshSeq();
			
		}else if (mode == "set"){
			var url = "portletLinkPop.do?linkSeq=" + $(obj).parent().attr("link_seq");
			openWindow2(url, "portletLinkPop", 652, 385, 1, 1);			
		}		
		
	}

	function fnImageAdd(file_id, url){
		
		if(ImgMode == "add"){
			$("#portlet_model .portal_portlet").attr("file_id", file_id);
			$("#portlet_model img").attr("src", url);
			
			//키생성
			var link_seq = 1;
			
		    $.each($("#sortable .portal_portlet"), function (i, t) {
		    	  var value = parseFloat($(t).attr("link_seq"));
		    	  link_seq = (value >= link_seq) ? (value + 1) : link_seq;
		    });

		    $("#sortable").append($("#portlet_model .portal_portlet").attr("link_seq",link_seq).clone());			
			
		    refreshSeq();
			
		}else if(ImgMode == "img"){
			$("#sortable .portal_portlet[link_seq=" + ImgKey + "]").attr("file_id", file_id)
			$("#sortable .portal_portlet[link_seq=" + ImgKey + "]").find("img").attr("src", url);
		}
		
	}
	
	function onSuccess(e) {
		if (e.operation == "upload") {
			var fileId = e.response.fileId;
			if (fileId != null && fileId != '') {
				fnImageAdd(fileId, "/gw/cmm/file/fileDownloadProc.do?fileId="+fileId+"&fileSn=0");
			} else {
				alert(e.response);
			}
		}
	}
	
	function placeholder(e) {
	    return $("<div class='portal_portlet' style='background-color:black;opacity:0.2;width:" + $(e).width() + "px;height:" + $(e).height() + "px;''></div>");
	}	
	
	function fnGetLinkList(type){
		
		var LinkList = new Array();
		
	    $.each($("#sortable .portal_portlet"), function (i, t) {
	    	
	    	var link_info = {};
	    	
	    	link_info.link_seq = $(t).attr("link_seq") == null ? "" : $(t).attr("link_seq");
	    	link_info.link_nm = $(t).attr("link_nm") == null ? "" : $(t).attr("link_nm");
	    	link_info.file_id = $(t).attr("file_id") == null ? "" : $(t).attr("file_id");
	    	link_info.use_yn = $(t).attr("use_yn") == null ? "" : $(t).attr("use_yn");
	    	link_info.show_from = $(t).attr("show_from") == null ? "" : $(t).attr("show_from");
	    	link_info.show_to = $(t).attr("show_to") == null ? "" : $(t).attr("show_to");
	    	link_info.ssoUseYn = $(t).attr("ssoUseYn") == null ? "" : $(t).attr("ssoUseYn");
	    	link_info.ssoType = $(t).attr("ssoType") == null ? "" : $(t).attr("ssoType");
	    	link_info.ssoUserId = $(t).attr("ssoUserId") == null ? "" : $(t).attr("ssoUserId");
	    	link_info.ssoCompSeq = $(t).attr("ssoCompSeq") == null ? "" : $(t).attr("ssoCompSeq");
	    	link_info.ssoEncryptType = $(t).attr("ssoEncryptType") == null ? "" : $(t).attr("ssoEncryptType");
	    	link_info.ssoEncryptKey = $(t).attr("ssoEncryptKey") == null ? "" : $(t).attr("ssoEncryptKey");
	    	link_info.ssoTimeLink = $(t).attr("ssoTimeLink") == null ? "" : $(t).attr("ssoTimeLink");
	    	link_info.ssoEncryptScope = $(t).attr("ssoEncryptScope") == null ? "" : $(t).attr("ssoEncryptScope");
	    	link_info.sspErpSeq = $(t).attr("sspErpSeq") == null ? "" : $(t).attr("sspErpSeq");
	    	link_info.ssoLoginCd = $(t).attr("ssoLoginCd") == null ? "" : $(t).attr("ssoLoginCd");
	    	link_info.ssoErpCompSeq = $(t).attr("ssoErpCompSeq") == null ? "" : $(t).attr("ssoErpCompSeq");
	    	link_info.ssoEtcName = $(t).attr("ssoEtcName") == null ? "" : $(t).attr("ssoEtcName");
	    	link_info.ssoEtcValue = $(t).attr("ssoEtcValue") == null ? "" : $(t).attr("ssoEtcValue");
	    	
	    	if(type == "iframe"){
	    		link_info.link_url = $("#portletTemplete_iframe_outer_if_url").val();
	    	}else{
	    		link_info.link_url = $(t).attr("link_url") == null ? "" : $(t).attr("link_url");	
	    	}
	    	
	    	LinkList.push(link_info);
	    	
	    });
		
		return LinkList;
	}	

	function fnclose() {
		self.close();
	}

	//전자결재 결재함 선택 팝업
	function fnEaBoxPop() {
		var eaBoxList = $("li[name=eaBox]");

		menuNoList = "";

		for (var i = 0; i < eaBoxList.length; i++) {
			menuNoList += "," + eaBoxList[i].id;
		}

		if (menuNoList.length > 0)
			menuNoList = menuNoList.substring(1);

		var url = "portletEaBoxListPop.do?menuNoList=" + menuNoList;
		openWindow2(url, "portletEaBoxListPop", 502, 700, 1, 1);
	}
	

	//전자결재(비) 결재함 선택 팝업
	function fnNonEaBoxPop() {
		var eaNonBoxList = $("li[name=nonEaForm]");

		formIdList = "";

		for (var i = 0; i < eaNonBoxList.length; i++) {
			formIdList += "," + eaNonBoxList[i].id;
		}

		if (formIdList.length > 0)
			formIdList = formIdList.substring(1);

		var url = "portletEaTreePop.do?formIdList=" + formIdList;
		openWindow2(url, "portletEaTreePop", 502, 700, 1, 1);
	}
	
	//게시판 트리 선택 팝업
	function fnBoardListPop() {
		var url = "portletBoardListPop.do?";
		openWindow2(url, "portletEaBoxListPop", 502, 700, 1, 1);
	}

	function eaBoxCallBack(treeCheckList) {
		var checkEaBoxList = JSON.parse(treeCheckList);
		console.log(JSON.stringify(checkEaBoxList));
		var InnerHTML = "";
		$("#portletTemplete_web_sign_listBox").html("");
		for (var i = 0; i < checkEaBoxList.length; i++) {
			if (checkEaBoxList[i].seq == '2002000000' || checkEaBoxList[i].seq == '101000000' || checkEaBoxList[i].seq == '102000000' || checkEaBoxList[i].seq == '100000000') {
				continue;
			} else {
				var targetID = checkEaBoxList[i].seq;
				InnerHTML += "<li id='" + targetID + "' name='eaBox'>";
				InnerHTML += checkEaBoxList[i].name;
				InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""
						+ targetID + "\")'>";
				InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
				InnerHTML += "</a></li>";
			}
		}

		$("#portletTemplete_web_sign_listBox").html(InnerHTML);
	}
	
	function boardTreeCallBack(boardID, boardNm) {
		$("#portletTemplete_board_boardID").val(boardID);
		$("#portletTemplete_board_boardName").val(boardNm);
	}

	function delAppli(target) {
		$("#" + target).remove();
	}
	
	function fnNameCheck() {
		var checkFlag = false;
		if($("portletKrName").val() == "") {
			return true;
		}
		
		return false;
		
	}
	
	function fnEaFormPop() {
		var eaFormList = $("li[name=eaForm]");

		formIdList = "";

		for (var i = 0; i < eaFormList.length; i++) {
			formIdList += "," + eaFormList[i].id;
		}

		if (formIdList.length > 0)
			formIdList = formIdList.substring(1);

		var url = "portletEaFormListPop.do?formIdList=" + formIdList;
		openWindow2(url, "portletEaFormListPop", 502, 700, 1, 1);
	}
	
	function eaFormCallBack(treeCheckList) {
		var checkEaBoxList = JSON.parse(treeCheckList);
		
		var InnerHTML = "";
		$("#portletTemplete_sign_form_eap_listBox").html("");
		for (var i = 0; i < checkEaBoxList.length; i++) {
			if(checkEaBoxList[i].spriteCssClass != "folder") {
				var targetID = checkEaBoxList[i].seq;
				InnerHTML += "<li id='" + targetID + "' name='eaForm'>";
				InnerHTML += checkEaBoxList[i].name;
				InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""
						+ targetID + "\")'>";
				InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
				InnerHTML += "</a></li>";	
			}
		}

		$("#portletTemplete_sign_form_eap_listBox").html(InnerHTML);
	}
	
	function eaNonFormCallBack(treeCheckList) {
		var checkNonEaBoxList = JSON.parse(treeCheckList);
		var InnerHTML = "";
		$("#portletTemplete_sign_form_ea_listBox").html("");
		for (var i = 0; i < checkNonEaBoxList.length; i++) {
			if(checkNonEaBoxList[i].spriteCssClass != "folder") {
				var targetID = checkNonEaBoxList[i].seq;
				InnerHTML += "<li id='" + targetID + "' name='nonEaForm'>";
				InnerHTML += checkNonEaBoxList[i].name;
				InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""
						+ targetID + "\")'>";
				InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
				InnerHTML += "</a></li>";	
			}
		}

		$("#portletTemplete_sign_form_ea_listBox").html(InnerHTML);
	}
	
	//기상청 api 연동 테스트 
	function weatherApiCheck(){
		var weatherApiKey = $("#weatherApiKey").val()
		var _date = new Date();
						
		var tblParam = {
			weatherApiKey: weatherApiKey,
			weatherCity: $("#weatherCity").val(),
			location: "71,132",
			baseDate: new Date().toISOString().slice(0,10).replace(/-/gi,""),
			baseTime: "0210"
		}
		
		$.ajax({
			type:"post",
	   		url:'/gw/cmm/systemx/weather/getWeather.do',
	   		datatype:"json",
	        data: tblParam ,
	   		success: function (data){
	   			$("#testResultContainer").empty();
	   			if(data.result.response.header.resultCode == "00") {
	   				alert("<%=BizboxAMessage.getMessage("TX900000001","연결성공")%>");
	   				
	   				// API 연동이 성공하면 성공 플래그를 저장한다.
	   				$("#weatherApiKey").attr("isWeatherApi","true");
	   				
	   				$("#testResultContainer").append("<span style='color:blue; font-size: 10px;'><%=BizboxAMessage.getMessage("TX900000002","* 연결에 성공하였습니다.")%></span>");
	   			}else if(data.result.response.header.resultCode == "30" || data.result.response.header.resultCode == "10" || data.result.response.header.resultCode == "-1") {
	   				alert("<%=BizboxAMessage.getMessage("TX900000003","API Key를 확인해주세요.")%>");
	   				
	   				//API 연동이 실패하면 실패 플래그를 저장한다.
	   				$("#weatherApiKey").attr("isWeatherApi","false");
	   				
	   				$("#testResultContainer").append("<span style='color:red; font-size: 10px;'><%=BizboxAMessage.getMessage("TX900000003","API Key를 확인해주세요.")%></span>");
	   			}
	   		},
	   		error: function (result){
	   			alert("<%=BizboxAMessage.getMessage("TX900000004","연결 중 에러가 발생하였습니다.")%>");
	   		}
		});
	}
	
	//문서 조회범위 트리 팝업 오픈 함수
	function fnDocListPop() {
		var url = "portletDocListPop.do";
		openWindow2(url,"portletEaBoxListPop", 502, 700, 1, 1);
	}
	
	
	//문서 조회범위 트리 콜백 함수 
	function docTreeCallBack(dir_cd, dir_lvl, dir_type, dir_nm) {
		$("#portletTemplete_doc_dirCd").val(dir_cd);
		$("#portletTemplete_doc_docName").val(dir_nm);
		$("#portletTemplete_doc_docType").val(dir_type);
		$("#portletTemplete_doc_docLvl").val(dir_lvl);
	}
</script>
	
