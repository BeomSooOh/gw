<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<div class="controll_btn fr pr15">
	<c:if test="${loginVO.userSe == 'MASTER'}">
	<button onclick="fnNew();"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
	</c:if>
	<button id="saveCompInfoBtn" class="saveBtn"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	<c:if test="${loginVO.userSe == 'MASTER'}">
	<button onclick="removeComp();"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
	</c:if>
</div>

<form id="frmPop" name="frmPop" style="height:0px;">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="oc" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="" />
	<input type="hidden" name="selectedItems" value="" />
	<input type="hidden" id="compFilter" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="addtableInfo" value="standard_code"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>

<div class="tab_style" id="tabstrip">
	<ul>
		<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></li>
		<li><%=BizboxAMessage.getMessage("TX000016061","접속정보")%></li>
	</ul>

	
	<!-- 기본정보 탭 -->

	<div class="tab_div_in">
		<form id="basicForm" name="basicForm" onsubmit="return false;">
		<input id="parentCompSeq" name="parentCompSeq" value="${compMap.parentCompSeq}" type="hidden" />		
		<input id="groupSeq" name="groupSeq" value="${compMap.groupSeq}" type="hidden" />
		<input id="sType" name="sType" value="I" type="hidden" />
		<input id="erpUseYN" name="erpUseYN" type="hidden" />
		<input id="smsUseYN" name="smsUseYN" type="hidden" />
		<input id="smsType" name="smsType" type="hidden" value=""/>
		<input id="smsId" name="smsId" type="hidden" value="${compMap.smsId}"/>
		<input id="smsPasswd" name="smsPasswd" type="hidden" value="${compMap.smsPasswd}"/>
		<input id="groupIpInfo" name="groupIpInfo" type="hidden" value="${compMap.groupDomain}"/>
		<input id="compSeq" name="compSeq" type="hidden" value="${compMap.compSeq}" />
	
		<p class="tit_p fl mt7"><%=BizboxAMessage.getMessage("TX000016065","회사기본정보")%></p>
		
		
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="80"/>
                    <col width="80"/>
					<col width="30%"/>
					<col width="100"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000017","회사코드")%></th>
					<td>
						<input id="compCd" name="compCd"  type="text" value="${compMap.compCd}" style="width:100%" onkeyup="checkCompSeq(this.value);">
						<p id="info" class="text_blue f11 mt5"></p>				
					</td>
					<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
					<td>
						<input type="radio" id="useYn" name="useYn" value="Y" class="k-radio" checked="checked" />
						<label class="k-radio-label radioSel" for="useYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
						<input type="radio" id="useYn2" name="useYn" value="N" class="k-radio" <c:if test="${compMap.useYn == 'N'}">checked</c:if> />
						<label class="k-radio-label radioSel ml10" for="useYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
					</td>
				</tr>
				<tr>
					<th rowspan="4"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
					<td><input  id="compName" name="compName" value="${compMultiMap.compName}" type="text" style="width:100%"/></td>
					<th><%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>
					<td><input id="ownerName" name="ownerName" value="${compMultiMap.ownerName}"  type="text" style="width:100%"/></td>
				</tr>
				<tr>
				   <th><%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
				   <td><input id="compNameEn" name="compNameEn" class="" type="text" value="${compMultiMap.compNameEn}" style="width:100%"/></td>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" style="visibility: hidden;" id="checkImg01"/><%=BizboxAMessage.getMessage("TX000000024","사업자번호")%></th>
					<td><input  type="text" id="compRegistNum" name="compRegistNum" value="${compMap.compRegistNum}" style="width:100%"/></td>
				</tr>
				<tr>
				    <th><%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
				    <td><input id="compNameJp" name="compNameJp" class="" type="text" value="${compMultiMap.compNameJp}" style="width:100%"/></td>
					<th><%=BizboxAMessage.getMessage("TX000000025","법인번호")%></th>
					<td><input  type="text" id="compNum" name="compNum" value="${compMap.compNum}" style="width:100%"/></td>
				</tr>
				<tr>
				   <th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
				   <td><input id="compNameCn" name="compNameCn" class="" type="text" value="${compMultiMap.compNameCn}" style="width:100%"/></td>
					<th><%=BizboxAMessage.getMessage("TX000000019","회사약칭")%></th>
					<td><input type="text"  id="compNickname" name="compNickname" value="${compMultiMap.compNickname}" style="width:100%"/></td>				   
				</tr>
				<tr id="standardCodeInfo">
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000016132","정부기준코드")%></th>
					<td colspan="3">
						<input type="radio" onchange="fnStandardTypeChange(1);" id="standardType1" name="standardType" value="1" class="k-radio" checked="checked" />
						<label class="k-radio-label radioSel" for="standardType1"><%=BizboxAMessage.getMessage("TX000001021","직접입력")%></label>
						&nbsp;
						<input id="standardCode" name="standardCode" value="${compMap.standardCode}"  type="text" style="width:200px;"/>
						&nbsp;
						<input type="radio" onchange="fnStandardTypeChange(2);" id="standardType2" name="standardType" value="2" class="k-radio" />
						<label class="k-radio-label radioSel ml10" for="standardType2"><%=BizboxAMessage.getMessage("TX900000281","타회사 코드참조")%></label>
						&nbsp;
						<input id="standardCompName" name="standardCompName" value="${compMap.standardCompName}" readonly="readonly" type="text" style="width:200px;display:none;"/>
						<input id="standardCompSeq" name="standardCompSeq" value="${compMap.standardCompSeq}" type="hidden" style="display:none;"/>
						<div id="standardCompSelect" class="controll_btn p0" style="display:none;">						
							<button onclick="fnStandardCompSelect();"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
						</div>
						<p class="text_red f11 mt5"><%=BizboxAMessage.getMessage("TX900000282","※정부기준코드를 발급받지 않은 회사의 경우, 타회사 코드를 참조하면 사용이 가능합니다.")%></p>
					</td>
				</tr>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000000029","업태")%></th>
					<td><input type="text"  id="bizCondition" name="bizCondition" value="${compMultiMap.bizCondition}" style="width:100%"/></td>
					<th><%=BizboxAMessage.getMessage("TX000000030","종목")%></th>
					<td><input type="text"  id="item" name="item" value="${compMultiMap.item}" style="width:100%"/></td>
				</tr>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000016328","대표전화")%></th>
					<td><input type="text" id="telNum" name="telNum" value="${compMap.telNum}" style="width:100%"/></td>
					<th><%=BizboxAMessage.getMessage("TX000016326","대표팩스")%></th>
					<td><input type="text" id="faxNum" name="faxNum" value="${compMap.faxNum}" style="width:100%"/></td>
				</tr>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000016353","기본도메인")%></th>
					<td>
						<!--내부메일 미사용인 경우 -->
						<c:if test="${compMap.compEmailYn == 'N'}">																		
						@ <input class="" type="text" value="${compMap.emailDomain}" style="width:150px;" id="emailDomain" name="emailDomain"/>
						<p id="email_info" class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX000016457","* 입력한 도메인은 정보표시 용도입니다.")%></p>
						</c:if>
						
						<!--내부메일 사용인 경우 -->
						<c:if test="${compMap.compEmailYn == 'Y'}">
						@ <input class="" type="text" value="${compMap.emailDomain}" style="width:150px;" id="emailDomain" name="emailDomain" disabled="disabled"/>
						<p id="email_info" class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX000016465","* 내부 메일 사용중 입니다.")%></p>
						</c:if>
						
						<!--신규 등록인 경우 -->
						<c:if test="${compMap.compEmailYn != 'Y'}">
							<c:if test="${compMap.compEmailYn != 'N'}">
							@ <input class="" type="text" style="width:150px;" id="emailDomain" name="emailDomain"/>
							</c:if>
						</c:if>
				  	</td>
					<th><%=BizboxAMessage.getMessage("TX000000125","정렬순서")%></th>
					<td>
						<div class="posi_re">
							<input class="" type="text" value="${compMap.orderNum}" maxlength="7" style="width:100%" id="order" name="order" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'/>
						</div>
					</td>				  
				</tr>					
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000000115","회사주소")%></th>
					
					<td colspan="3">
						<input type="text" id="zipCode" name="zipCode" value="${compMap.zipCode}" style="width:88px;" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="우편번호"</c:if> />						
						<div id="" class="controll_btn p0" <c:if test="${ClosedNetworkYn == 'Y'}">style="display: none;"</c:if> >						
							<button id="btnZip" onclick="fnZipPop(this);"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
						</div>
						
						<div class="mt5">
							<input id="addr" name="addr" value="${compMultiMap.addr}"  type="text"style="width:100%">
						</div>
						<div class="mt5">
							<input class="" type="text" style="width:100%" placeholder="<%=BizboxAMessage.getMessage("TX000010786","상세주소입력")%>" id="detailAddr" name="detailAddr" value="${compMultiMap.detailAddr}">
						</div>
					</td>
				</tr>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000016079","홈페이지주소")%></th>
					<td><input type="text" id="homepgAddr" name="homepgAddr" value="${compMap.homepgAddr}" style="width:100%"></td>
					<th><%=BizboxAMessage.getMessage("TX000016350","기본언어")%></th>
					<td><input class="" id="nativeLangCode" name="nativeLangCode" value="" style="width:100%"/></td>													
				</tr>
			</table>
		</div>		
		
		<p class="tit_p mt15"><%=BizboxAMessage.getMessage("TX000016177","연동 정보")%></p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="160"/>
<%-- 					<col width="35%"/> --%>
					<col width=""/>
<%-- 					<col width=""/> --%>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000021","ERP버전")%></th>
					<td>
						<input type="radio" name="erp_u1u2" id="erp_radio_u1" class="k-radio" onclick="fn_erpUse();">
						<label class="k-radio-label radioSel" for="erp_radio_u1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
						<input type="radio" name="erp_u1u2" id="erp_radio_u2" class="k-radio" checked="checked"  onclick="fn_erpUse();">
						<label class="k-radio-label radioSel ml10" for="erp_radio_u2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
						<div id="" class="controll_btn p0 pl10">
							<button id="btnErp" onclick="erpConOptionPop()" disabled="disabled"><%=BizboxAMessage.getMessage("TX000006520","설정")%></button>
						</div>
					</td>
					<th style="display: none;"><%=BizboxAMessage.getMessage("TX000016407","SMS 사용여부")%></th>
					<td style="display: none;">
						<input type="radio" name="sms_u1u2" id="sms_radio_u1" class="k-radio" onclick="fn_smsUse();" disabled="disabled">
						<label class="k-radio-label radioSel" for="sms_radio_u1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
						<input type="radio" name="sms_u1u2" id="sms_radio_u2" class="k-radio" checked="checked" onclick="fn_smsUse();" disabled="disabled">
						<label class="k-radio-label radioSel ml10" for="sms_radio_u2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
						<div id="" class="controll_btn p0 pl10">
							<button id="btnSms" disabled="disabled" onclick="smsConPop();"><%=BizboxAMessage.getMessage("TX000006520","설정")%></button>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<p class="tit_p mt15"><%=BizboxAMessage.getMessage("TX000016154","인감 정보")%></p>
		
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="160"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000003442","발신명의")%></th>
					<td>
						<input type="text" style="width:356px;text-indent:8px;" placeholder="<%=BizboxAMessage.getMessage("TX000016101","텍스트입력")%>" value="${txtMap.displayText}" id="displayText" name="displayText"/>
						<input type="hidden" id="senderName" name="senderName" value="compMultiMap.senderName">					
					</td>
				</tr>
			</table>
		</div>
		<div style="height: 20px;"/>
		
		<div class="com_ta4 hover_no">
			<table>
				<colgroup>
					<col width="25%"/>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000027","법인인감")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000060","사용인감")%></th>
					<th><%=BizboxAMessage.getMessage("TX000016059","회사직인")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000023","양식로고")%></th>
				</tr>
				<tr>
					<td>
						<input id="fileList" name="fileList" type="hidden"> 
						<div class="stemp_img_box posi_re" style="float:none;margin:0 auto;">
							<img id="IMG_COMP_STAMP1_IMG" alt="" width="71" height="71" src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${imgMap.IMG_COMP_STAMP1.fileId}&fileSn=0' />" >
							<a href="#n" class="del_btn" style="visibility: hidden;" id="IMG_COMP_STAMP1_DEL" name="IMG_COMP_STAMP1" onclick="fn_ImgDel(this, 1)"></a>
							<input type="hidden" id="IMG_COMP_STAMP1_fileID" name="IMG_COMP_STAMP1_fileID" value="${imgMap.IMG_COMP_STAMP1.fileId}">
							<input type="hidden" id="IMG_COMP_STAMP1_newYN" name="IMG_COMP_STAMP1_newYN" value="N">							
						</div>
						<div id="" class="controll_btn cen mt7 file_cen">
<!-- 							<button id="fileUpload01" name="IMG_COMP_STAMP1">등록</button> -->
							<p id="p_File1">
								<input type="file" id="fileUpload01" class="hidden_file_add" name="IMG_COMP_STAMP1" onchange="stamp1Upload(this);"/>
							</p>
							<button id="btnStamp1" class="phogo_add_btn"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
<!-- 							<input name="IMG_COMP_STAMP1"  id="fileUpload01"   type="file" class="file_stemp" /> -->
							<input id="IMG_COMP_STAMP1_SEQ" name="IMG_COMP_STAMP1_SEQ" type="hidden" value="${imgMap.IMG_COMP_STAMP1.imgSeq}" />
						</div>
					</td>
					<td>
						<div class="stemp_img_box posi_re" style="float:none;margin:0 auto;">
							<img id="IMG_COMP_STAMP2_IMG" alt="" width="71" height="71" src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${imgMap.IMG_COMP_STAMP2.fileId}&fileSn=0' />" >
							<a href="#n" class="del_btn" style="visibility: hidden;" id="IMG_COMP_STAMP2_DEL" name="IMG_COMP_STAMP2" onclick="fn_ImgDel(this, 2)"></a>
							<input type="hidden" id="IMG_COMP_STAMP2_fileID" name="IMG_COMP_STAMP2_fileID" value="${imgMap.IMG_COMP_STAMP2.fileId}">
							<input type="hidden" id="IMG_COMP_STAMP2_newYN" name="IMG_COMP_STAMP2_newYN" value="N">
						</div>
						<div id="" class="controll_btn cen mt7 file_cen">
<!-- 							<input name="IMG_COMP_STAMP2"  id="fileUpload01"   type="file" class="file_stemp" /> -->
							<p id="p_File2">
								<input type="file" id="fileUpload02" class="hidden_file_add" name="IMG_COMP_STAMP2" onchange="stamp2Upload(this);"/>
							</p>
							<button id="btnStamp2" class="phogo_add_btn2"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
							<input id="IMG_COMP_STAMP2_SEQ" name="IMG_COMP_STAMP2_SEQ" type="hidden" value="${imgMap.IMG_COMP_STAMP2.imgSeq}" />
						</div>
					</td>
					<td>
						<div class="stemp_img_box posi_re" style="float:none;margin:0 auto;">
							<img id="IMG_COMP_STAMP3_IMG" alt="" width="71" height="71" src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${imgMap.IMG_COMP_STAMP3.fileId}&fileSn=0' />" >
							<a href="#n" class="del_btn" style="visibility: hidden;" id="IMG_COMP_STAMP3_DEL" name="IMG_COMP_STAMP3" onclick="fn_ImgDel(this, 3)"></a>
							<input type="hidden" id="IMG_COMP_STAMP3_fileID" name="IMG_COMP_STAMP3_fileID" value="${imgMap.IMG_COMP_STAMP3.fileId}">
							<input type="hidden" id="IMG_COMP_STAMP3_newYN" name="IMG_COMP_STAMP3_newYN" value="N">
						</div>
						<div id="" class="controll_btn cen mt7 file_cen">
<!-- 							<input name="IMG_COMP_STAMP3"  id="fileUpload01"   type="file" class="file_stemp" /> -->
							<p id="p_File3">
								<input type="file" id="fileUpload03" class="hidden_file_add" name="IMG_COMP_STAMP3" onchange="stamp3Upload(this);"/>
							</p>
							<button id="btnStamp3" class="phogo_add_btn3"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
							<input id="IMG_COMP_STAMP3_SEQ" name="IMG_COMP_STAMP3_SEQ" type="hidden" value="${imgMap.IMG_COMP_STAMP3.imgSeq}" />
						</div>
					</td>
<!-- 					<td> -->
<!-- 						<div class="stemp_img_box posi_re" style="float:none;margin:0 auto;"> -->
<%-- 							<img id="IMG_COMP_STAMP4_IMG" alt="" width="80" height="80" src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${imgMap.IMG_COMP_STAMP4.fileId}&fileSn=0' />" > --%>
<!-- 							<a href="#n" class="del_btn" style="visibility: hidden;" id="IMG_COMP_STAMP4_DEL" name="IMG_COMP_STAMP4" onclick="fn_ImgDel(this)"></a> -->
<%-- 							<input type="hidden" id="IMG_COMP_STAMP4_fileID" name="IMG_COMP_STAMP4_fileID" value="${imgMap.IMG_COMP_STAMP4.fileId}"> --%>
<!-- 							<input type="hidden" id="IMG_COMP_STAMP4_newYN" name="IMG_COMP_STAMP4_newYN" value="N"> -->
<!-- 						</div> -->
<%-- 						<input type="text" style="width:80%;text-indent:8px;" class="mt7" placeholder="텍스트입력" id="displayText" name="displayText" value="${txtMap.displayText}"/> --%>
<!-- 						<div id="" class="controll_btn cen mt7 file_cen"> -->
<!-- 							<input name="IMG_COMP_STAMP4"  id="fileUpload01"   type="file" class="file_stemp" /> -->
<%-- 							<input id="IMG_COMP_STAMP4_SEQ" name="IMG_COMP_STAMP4_SEQ" type="hidden" value="${imgMap.IMG_COMP_STAMP4.imgSeq}" /> --%>
<!-- 						</div> -->
<!-- 					</td> -->
					<td>
						<div class="sign_img_box posi_re" style="float:none;margin:0 auto;">
							<img id="IMG_COMP_DRAFT_LOGO_IMG" alt="" width="160" height="28" src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${imgMap.IMG_COMP_DRAFT_LOGO.fileId}&fileSn=0' />" >
							<a href="#n" class="del_btn" style="visibility: hidden;" id="IMG_COMP_DRAFT_LOGO_DEL" name="IMG_COMP_DRAFT_LOGO" onclick="fn_ImgDel(this, 4)"></a>
							<input type="hidden" id="IMG_COMP_DRAFT_LOGO_fileID" name="IMG_COMP_DRAFT_LOGO_fileID" value="${imgMap.IMG_COMP_DRAFT_LOGO.fileId}">
							<input type="hidden" id="IMG_COMP_DRAFT_LOGO_newYN" name="IMG_COMP_DRAFT_LOGO_newYN" value="N">
						</div>
						<div id="" class="controll_btn cen mt7 file_cen">
<!-- 							<input name="IMG_COMP_DRAFT_LOGO"  id="fileUpload01"   type="file" class="file_stemp" /> -->
							<p id="p_File4">
								<input type="file" id="fileUpload04" class="hidden_file_add" name="IMG_COMP_DRAFT_LOGO" onchange="draftUpload(this);"/>
							</p>
							<button id="btnDraft" class="phogo_add_btn4"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
							<input id="IMG_COMP_DRAFT_LOGO_SEQ" name="IMG_COMP_DRAFT_LOGO_SEQ" type="hidden" value="${imgMap.IMG_COMP_DRAFT_LOGO.imgSeq}" />
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<!-- web 탭 -->
	<div class="tab_div_in">
		<p class="tit_p fl mt7"><%=BizboxAMessage.getMessage("TX000016061","회사접속정보")%></p>

		<div class="com_ta">
			<table>
				<colgroup>
					<col width="110"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th rowspan="2"><%=BizboxAMessage.getMessage("TX000016237","브라우저 설정")%></th>
					<td>
						<dl>
							<dt class="fl ar mr10 pt6" style="width:80px;"><%=BizboxAMessage.getMessage("TX000016222","사용 도메인")%></dt>
							<dd class="fl" style="width:70px;"><input class="" type="text" value="${compMap.compDomain}" style="width:350px" id="compDomain" name="compDomain" disabled="disabled"/></dd>
						</dl>
					</td>
				</tr>
				<tr>
					<td>
						<dl>
							<dt class="fl ar mr10 pt6" style="width:80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000016102","타이틀명")%></dt>
							<dd class="fl"><input class="" type="text" value="${compMultiMap.compDisplayName}" style="width:350px" placeholder="<%=BizboxAMessage.getMessage("TX000016364","그룹웨어명 입력(입력시 상단 브라우저에 표시)")%>" id="compTitle" name="compTitle"></dd>
						</dl>
					</td>
				</tr>
			</table>
		</div>
		
		<p class="tit_p mt15"><%=BizboxAMessage.getMessage("TX000016072","회사 이미지 설정")%></p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="50%"/>
					<col width=""/>
				</colgroup>
				<tr id="webType">
					<th class="cen">
						<input type="radio" checked="checked" name="type_web" id="typeA_web" class="k-radio" value="A" <c:if test="${compMap.loginType == 'A'}">checked</c:if>>
						<label class="k-radio-label radioSel" for="typeA_web"><%=BizboxAMessage.getMessage("TX000016317","로그인 A타입")%></label>
					</th>
					<th class="cen">
						<input type="radio" name="type_web" id="typeB_web" class="k-radio" value="B" <c:if test="${compMap.loginType == 'B'}">checked</c:if>>
						<label class="k-radio-label radioSel" for="typeB_web"><%=BizboxAMessage.getMessage("TX000016316","로그인 B타입")%></label>
					</th>
				</tr>
				<tr id="webTypeDetail">
					<td class="logo_set_box">
						<div class="type_a_new"></div>
						<div id="" class="controll_btn p0 pb5">
							<button id="btnLoginLogoA" onClick="clickFileUpload('IMG_COMP_LOGIN_LOGO_A', 'A')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
						</div>
					</td>
					<td class="logo_set_box">
						<div class="type_b_new"></div>
						<div id="" class="controll_btn p0 pb5">
							<button id="btnLoginLogoB" onClick="clickFileUpload('IMG_COMP_LOGIN_LOGO_B', 'B')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
						</div>
					</td>
				</tr>
				<tr>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000016291","메인 상단로고")%></th>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000016290","메인 하단 푸터")%></th>
				</tr>
				<tr>
					<td class="logo_set_box">
						<div class="type_top"></div>
						<div id="" class="controll_btn p0 pb5">
							<button id="" onClick="clickMainTopUpload('IMG_COMP_LOGO','99')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
						</div>
					</td>
					<td class="logo_set_box">
						<div class="type_footer"></div>
						<div id="" class="controll_btn p0 pb5">
							<button id="" onClick="clickMainFootUpload('IMG_COMP_FOOTER','99')"><%=BizboxAMessage.getMessage("TX000016280","문구 등록")%></button>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<p class="tit_p mt15 mb0"><%=BizboxAMessage.getMessage("TX000016409","Phone 이미지 설정")%></p>
		<div class="cl text_blue ml10 mt5 mb10"><%=BizboxAMessage.getMessage("TX000016310","로그인 이후 변경된 이미지로 반영됩니다.")%></div>
		
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="50%"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000016412","Phone A타입(White)")%></th>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000016411","Phone B타입(Blue)")%></th>
				</tr>
				<tr>
					<td class="logo_set_box">
						<div class="type_phone_a"></div>
						<div id="" class="controll_btn p0 pb5">
							<button id="" onClick="clickPhFileUpload('LOGO_01','A')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
						</div>
					</td>
					<td class="logo_set_box">
						<div class="type_phone_b"></div>
						<div id="" class="controll_btn p0 pb5">
							<button id="" onClick="clickPhFileUpload('LOGO_01','B')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- PC 메신저 이미지 설정 -->
		<p class="tit_p mt15 mb0"><%=BizboxAMessage.getMessage("TX000016415","PC 메신저 이미지 설정")%></p>
		<div class="cl text_blue ml10 mt5 mb10"><%=BizboxAMessage.getMessage("TX000016310","로그인 이후 변경된 이미지로 반영됩니다.")%></div>
		
		<div class="com_ta mt10">
			<table>
				<colgroup>
					<col width="50%"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000016414","PC 메신저")%></th>
					<th class="cen"></th>
				</tr>
				<tr>
					<td class="logo_set_box">
						<div class="type_msg_new"></div>
						<div id="" class="controll_btn p0 pb5">
							<button id="" onClick="clickMsgFileUpload('LOGO_02')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
						</div>
					</td>
					<td class="logo_set_box"></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">

var ID_check = false;

$(document).ready(function() {
		//기본버튼
		$("button").kendoButton();    	
		
		
		$("#btnStamp1").on("click",function(){
			$("#fileUpload01").click();
		})
		$("#btnStamp2").on("click",function(){
			$("#fileUpload02").click();
		})
		$("#btnStamp3").on("click",function(){
			$("#fileUpload03").click();
		})
		$("#btnDraft").on("click",function(){
			$("#fileUpload04").click();
		})
		
		$(".saveBtn").kendoButton({
	        click: compInfoSave
	    });
		
		//탭
		$("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: "fadeIn"
				}
			}		
		
		});
		
		
		 //기본도메인 셀렉트
	    $("#domain").kendoComboBox();
		
		//기본언어 셀렉트
		 $("#nativeLangCode").kendoComboBox({
		        dataSource : JSON.parse('${langList}'),
		        dataTextField: "detailName",
		        dataValueField: "detailCode",
		        index: 0
		    });
		
		
		if("${compMap.compSeq}" != ""){
			$("#nativeLangCode").data("kendoComboBox").value("${compMap.nativeLangCode}");
		}
		
		if($("#compSeq").val() == ""){
			var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");
		    tabStrip.enable(tabStrip.tabGroup.children().eq(1), false);
		}
		
		// Validato
		var container = $("#basicForm");
        kendo.init(container);
        container.kendoValidator();
        
        var container = $("#basicForm");
        kendo.init(container);
        container.kendoValidator();
        
        fnImgInit();
        
        if($("#compSeq").val() == ""){
        	$("#sType").val("I");
        }
        else{
        	$("#sType").val("U");
        	ID_check = true;
        }
        	
        if("${compMap.erpUse}" == "Y"){
        	document.getElementById("erp_radio_u1").checked = true;
        	$("#btnErp").data("kendoButton").enable(true);
        }
        
       	if("${compMap.smsUse}" == "Y"){
       		document.getElementById("sms_radio_u1").checked = true;
       		$("#btnSms").data("kendoButton").enable(true);
       		if($("#smsId").val() == ""){
       			$("#smsType").val("biz");
       			$("#checkImg01").attr("style","visibility: visible;");
       		}
       		else{
       			$("#smsType").val("sureM");
       		}
       	}
       	
       	if("${compMap.standardCompSeq}" != ""){
       		fnStandardTypeChange(2);
       	}else{
       		fnStandardTypeChange(1);
       	}
       	
       	if($("#compDomain").val() == $("#groupIpInfo").val() || $("#compDomain").val() == ""){
       		$("#btnLoginLogoA").attr("disabled",true);
       		$("#btnLoginLogoB").attr("disabled",true);
       		$("#typeA_web").attr("disabled",true);
       		$("#typeB_web").attr("disabled",true);
       		
       		$("#webType").hide();
       		$("#webTypeDetail").hide();
       	}  
       	
       	if("${eaType}" == "eap"){
			$("#standardCodeInfo").hide();
			$("#standardCode").val("");
		}else{
			$("#standardCodeInfo").show();			
		}
	});
	
	function fnStandardCompSelect() {
		$("input[name='selectedItems']").val($("#standardCompSeq").val());
		var pop = window.open("", "cmmOrgPop", "width=351,height=618,scrollbars=no");
		$("#callback").val("callbackSel");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
		frmPop.submit();
		pop.focus(); 
	}
	
    function callbackSel(data) {
    	if(data.returnObj.length > 0){
			$("#standardCompName").val(data.returnObj[0].compName);
 			$("#standardCompSeq").val(data.returnObj[0].selectedId);    		
    	}else{
			$("#standardCompName").val("");
 			$("#standardCompSeq").val("");
    	}
  	}	
	
 	function fnStandardTypeChange(type){
 		if(type == 1){
 			document.getElementById("standardType1").checked = true;
 			$("#standardCompName").hide();
 			$("#standardCompSeq").hide();
 			$("#standardCompSelect").hide(); 			
 			$("#standardCode").attr("disabled", false);
 		}else{
 			document.getElementById("standardType2").checked = true;
 			$("#standardCompName").show();
 			$("#standardCompSeq").show();
 			$("#standardCompSelect").show();
 			$("#standardCode").attr("disabled", true);
 		}
 	}
	
	function erpConOptionPop(){
		var compSeq = $("#compSeq").val();
		
		if("${loginVO.userSe}" == "MASTER"){
			if($("#compSeq").val() == "" || $("#compSeq").val() == null){
				alert("<%=BizboxAMessage.getMessage("TX000010785","회사를 선택해 주세요")%>");
				return false;
			}
		}
		var url = "<c:url value='/cmm/systemx/erpConOptionPop.do'/>" + "?compSeq=" + compSeq;          
    	openWindow2(url,  "erpConOptionPop", 698, 692, 0) ;
	}
	
	function smsConPop(){
		var compSeq = $("#compSeq").val();
		if("${loginVO.userSe}" == "MASTER"){
			if($("#compSeq").val() == "" || $("#compSeq").val() == null){
				alert("<%=BizboxAMessage.getMessage("TX000010785","회사를 선택해 주세요")%>");
				return false;
			}
		}
		var url = "<c:url value='/cmm/systemx/smsConOptionPop.do'/>" + "?compSeq=" + compSeq;          
    	openWindow2(url,  "smsConOptionPop", 542, 262, 0) ;
	}
	
	function compInfoSave() {

		if($("#compCd").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000010784","회사코드를 입력해 주세요")%>");
			return false;
		}
		else if($("#compName").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000010783","회사명을 입력해 주세요")%>");
			return false;
		}

		if(!ID_check){
			alert("<%=BizboxAMessage.getMessage("TX000010780","회사코드를 확인해 주세요")%>");
			return false;
		}
		
		if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>"))
		{
			
			
			if($("#fileUpload01").val() != ""){
				var formData = new FormData();
   	 			var pic = $("#fileUpload01")[0];    				
   	 			
   	 			formData.append("file", pic.files[0]);
   	 			formData.append("pathSeq", "900");	//이미지 폴더
   	 			formData.append("relativePath", "stamp"); // 상대 경로
    				 
   	 			$.ajax({
   	                 url: _g_contextPath_ + "/cmm/file/profileUploadProc.do",
   	                 type: "post",
   	                 dataType: "json",
   	                 data: formData,
   	                 async:false,
   	                 // cache: false,
   	                 processData: false,
   	                 contentType: false,
   	                 success: function(data) {
   	                	$("#IMG_COMP_STAMP1_fileID").val(data.fileId);
  	  					$("#IMG_COMP_STAMP1_newYN").val("Y");								
   	                 },
   	                 error: function (result) { 
   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
   	 		    			return false;
   	 		    		}
   	             });
			}
			
			
			if($("#fileUpload02").val() != ""){
				var formData = new FormData();
   	 			var pic = $("#fileUpload02")[0];
    				
   	 			formData.append("file", pic.files[0]);
   	 			formData.append("pathSeq", "900");	//이미지 폴더
   	 			formData.append("relativePath", "stamp"); // 상대 경로
    				 
   	 			$.ajax({
   	                 url: _g_contextPath_ + "/cmm/file/profileUploadProc.do",
   	                 type: "post",
   	                 dataType: "json",
   	                 data: formData,
   	                 async:false,
   	                 // cache: false,
   	                 processData: false,
   	                 contentType: false,
   	                 success: function(data) {
   	                	$("#IMG_COMP_STAMP2_fileID").val(data.fileId);
  	  					$("#IMG_COMP_STAMP2_newYN").val("Y");								
   	                 },
   	                 error: function (result) { 
   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
   	 		    			return false;
   	 		    		}
   	             });
			}
			
			
			if($("#fileUpload03").val() != ""){
				var formData = new FormData();
   	 			var pic = $("#fileUpload03")[0];
    				
   	 			formData.append("file", pic.files[0]);
   	 			formData.append("pathSeq", "900");	//이미지 폴더
   	 			formData.append("relativePath", "stamp"); // 상대 경로
    				 
   	 			$.ajax({
   	                 url: _g_contextPath_ + "/cmm/file/profileUploadProc.do",
   	                 type: "post",
   	                 dataType: "json",
   	                 data: formData,
   	                 async:false,
   	                 // cache: false,
   	                 processData: false,
   	                 contentType: false,
   	                 success: function(data) {
   	                	$("#IMG_COMP_STAMP3_fileID").val(data.fileId);
  	  					$("#IMG_COMP_STAMP3_newYN").val("Y");								
   	                 },
   	                 error: function (result) { 
   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
   	 		    			return false;
   	 		    		}
   	             });
			}
			
			
			if($("#fileUpload04").val() != ""){
				var formData = new FormData();
   	 			var pic = $("#fileUpload04")[0];
    				
   	 			formData.append("file", pic.files[0]);
   	 			formData.append("pathSeq", "900");	//이미지 폴더
   	 			formData.append("relativePath", "stamp"); // 상대 경로
    				 
   	 			$.ajax({
   	                 url: _g_contextPath_ + "/cmm/file/profileUploadProc.do",
   	                 type: "post",
   	                 dataType: "json",
   	                 data: formData,
   	                 async:false,
   	                 // cache: false,
   	                 processData: false,
   	                 contentType: false,
   	                 success: function(data) {
   	                	$("#IMG_COMP_DRAFT_LOGO_fileID").val(data.fileId);
  	  					$("#IMG_COMP_DRAFT_LOGO_newYN").val("Y");								
   	                 },
   	                 error: function (result) { 
   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
   	 		    			return false;
   	 		    		}
   	             });
			}
			
			var validator = $("#basicForm").data("kendoValidator");
			var fileList = "";
			for(var i=0;i<$(".hidden_file_add").length;i++){
				if($(".hidden_file_add")[i].name == "IMG_COMP_DRAFT_LOGO"){
					var fileID = $("#IMG_COMP_DRAFT_LOGO_fileID").val();
					if(fileID == "")
						fileID = "0";
					fileList += ",IMG_COMP_DRAFT_LOGO|" + fileID + "|" + $("#IMG_COMP_DRAFT_LOGO_newYN").val();
				}
				else{
					var fileID = $("#IMG_COMP_STAMP" + (i+1) + "_fileID").val();
					if(fileID == "")
						fileID = "0";
					fileList += ",IMG_COMP_STAMP" + (i+1) + "|" + fileID + "|" + $("#IMG_COMP_STAMP" + (i+1) + "_newYN").val();
				}
			}
			$("#fileList").val(fileList.substring(1));	
			
			if(document.getElementById("erp_radio_u1").checked)
				$("#erpUseYN").val("Y");
			else
				$("#erpUseYN").val("N");
			
			if(document.getElementById("sms_radio_u1").checked)
				$("#smsUseYN").val("Y");
			else
				$("#smsUseYN").val("N");
			
			if($(':radio[name="standardType"]:checked').val() == "1"){
				$("#standardCompName").val("");
				$("#standardCompSeq").val("");
			}
			
	        if (validator.validate()) {
	        	$("#senderName").val($("#displayText").val());
				var formData = $("#basicForm").serialize();
				formData += "&uType=0";
				formData += "&compDomain=" + encodeURIComponent($("#compDomain").val());
				formData += "&compDisplayName=" + encodeURIComponent($("#compTitle").val());
				
 				if(document.getElementById("typeA_web").checked)
 					formData += "&loginType=A";
 				else
 					formData += "&loginType=B";		

				$.ajax({
					type:"post",
					url:"compInfoSaveProc.do",
					datatype:"text",
					data: formData,
					async:false,
					success:function(data){
						
						alert(data.result);
						
						if(data.resultCode == "fail"){
							return;
						}else{
							location.reload();	
						}

					},			
					error : function(xhr, status, error) {
						alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
					}
				});	
	        }
        }
	}   

	function clickFileUpload(id, type) {
    	var url = "<c:url value='/cmm/systemx/groupLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr"+"&type="+type+"&compSeq="+$("#compSeq").val();
    	openWindow2(url+"?"+params,  "groupLogoUploadPop", 598, type == "B" ? 357 : 313, 0) ;
    }
	function clickPhFileUpload(id, type){
 		var url = "<c:url value='/cmm/systemx/groupPhLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr"+"&compSeq="+$("#compSeq").val()+"&type="+type;
    	openWindow2(url+"?"+params,  "groupPhLogoUploadPop", 638, 417, 0) ;
 	}
 	
 	function clickMsgFileUpload(id){
 		var url = "<c:url value='/cmm/systemx/groupMsgLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr"+"&compSeq="+$("#compSeq").val();
    	openWindow2(url+"?"+params,  "groupMsgLogoUploadPop", 556, 261, 0) ;
 	}
 	
 	function clickMainTopUpload(id){
 		var url = "<c:url value='/cmm/systemx/groupMainTopLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr"+"&compSeq="+$("#compSeq").val();
    	openWindow2(url+"?"+params,  "groupMainTopLogoUploadPop", 596, 218, 0) ;
 	}
 	
 	function clickMainFootUpload(id){
 		var url = "<c:url value='/cmm/systemx/groupMainFootLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr"+"&compSeq="+$("#compSeq").val();
    	openWindow2(url+"?"+params,  "groupMainFootLogoUploadPop", 598, 238, 0) ;
 	}
 	function fn_ImgDel(target, index)
	{
//  			if($("#"+target.name+"_fileID").val() != "")
// 			{
// 	 			var fileId = $("#"+target.name+"_fileID").val();
// 	 			$.ajax({
// 					type:"post",
// 					url:_g_contextPath_+"/cmm/systemx/orgDeleteImage.do",
// 					datatype:"json",
// 					data: {imgType:target.name, orgSeq:$("#compSeq").val(), file_Id : fileId},
// 					success:function(data){					
// 						alert("정상적으로 삭제되었습니다.");
// 					},			
// 					error : function(e){	//error : function(xhr, status, error) {
// 						alert("error");	
// 					}
// 				});
//  			}
			 			
		$('#'+target.id).attr("style","visibility:hidden");
 		$('#'+target.name+"_IMG").attr("style","visibility:hidden");	
 		$('#'+target.name+"_fileID").val("");
 		$('#'+target.name+"_newYN").val("N");
 		
 		var innerHTML = "";
 		if(index == 1){
 			innerHTML = "<input type='file' id='fileUpload01' class='hidden_file_add' name='IMG_COMP_STAMP1' onchange='stamp1Upload(this);'/>";
 		}
 		else if(index == 2){
 			innerHTML = "<input type='file' id='fileUpload02' class='hidden_file_add' name='IMG_COMP_STAMP2' onchange='stamp2Upload(this);'/>";
 		}
 		else if(index == 3){
 			innerHTML = "<input type='file' id='fileUpload03' class='hidden_file_add' name='IMG_COMP_STAMP3' onchange='stamp3Upload(this);'/>";
 		}
 		else if(index == 4){
 			innerHTML = "<input type='file' id='fileUpload04' class='hidden_file_add' name='IMG_COMP_DRAFT_LOGO' onchange='draftUpload(this);'/>";
 		}	
 		
 		$("#p_File" + index).html("");		
		$("#p_File" + index).html(innerHTML);
	}
 	
 	function fnImgInit(){
 		var imgCompStamp1 = document.getElementById('IMG_COMP_STAMP1_IMG');
 		var imgCompStamp2 = document.getElementById('IMG_COMP_STAMP2_IMG');
 		var imgCompStamp3 = document.getElementById('IMG_COMP_STAMP3_IMG');
 		var imgCompStamp4 = document.getElementById('IMG_COMP_DRAFT_LOGO_IMG');

		if('${imgMap.IMG_COMP_STAMP1.fileId}' == '')
			$("#IMG_COMP_STAMP1_IMG").attr("style","visibility:hidden");
		else			
			$("#IMG_COMP_STAMP1_DEL").attr("style", "visibility:visible");		
		
		if('${imgMap.IMG_COMP_STAMP2.fileId}' == '')
			$("#IMG_COMP_STAMP2_IMG").attr("style","visibility:hidden");
		else
			$("#IMG_COMP_STAMP2_DEL").attr("style", "visibility:visible");
		
		if('${imgMap.IMG_COMP_STAMP3.fileId}' == '')			
			$("#IMG_COMP_STAMP3_IMG").attr("style","visibility:hidden");
		else
			$("#IMG_COMP_STAMP3_DEL").attr("style", "visibility:visible");
		
		if('${imgMap.IMG_COMP_DRAFT_LOGO.fileId}' == '')
			$("#IMG_COMP_DRAFT_LOGO_IMG").attr("style","visibility:hidden");
		else
			$("#IMG_COMP_DRAFT_LOGO_DEL").attr("style", "visibility:visible");		
 	}
 	
 	function fnNew(){
 		location.reload();
 	}
 		
	function fn_erpUse(){
		if(document.getElementById("erp_radio_u2").checked)
			$("#btnErp").data("kendoButton").enable(false);
		else
			$("#btnErp").data("kendoButton").enable(true);		
	}
	function fn_smsUse(){
		if(document.getElementById("sms_radio_u2").checked){
			$("#btnSms").data("kendoButton").enable(false);
			$("#checkImg01").attr("style","visibility: hidden;");
			$("#smsType").val("");
			$("#smsId").val("");
			$("#smsPasswd").val("");
		}
		else
			$("#btnSms").data("kendoButton").enable(true);
	}
	
	function setSmsConOption(smsType, smsId, smsPwd){
		$("#smsType").val(smsType);		
		
		if(smsType == "biz"){
			$("#checkImg01").attr("style","visibility: visible;");	
			$("#smsId").val("");
			$("#smsPasswd").val("");
		}
		else{
			$("#smsId").val(smsId);
			$("#smsPasswd").val(smsPwd);
			$("#checkImg01").attr("style","visibility: hidden;");	
		}
	}
	
	function checkCompSeq(id) {
		if(id == "0"){
			$("#info").prop("class", "text_red f11 mt5");
            $("#info").html("<%=BizboxAMessage.getMessage("TX000009762","사용 불가능한 코드 입니다")%>");
            ID_check = false;
		}
		else if(id == ""){
			$("#info").prop("class", "");
            $("#info").html("");
            ID_check = false;
		}
		else{
	        if (id != null && id != '') {
	            $.ajax({
	                type: "post",
	                url: "compSeqCheck.do",
	                datatype: "text",
	                data: { compCd: id , compSeq:$("#compSeq").val()},
	                success: function (data) {
	                    if (data.result == "1") {
	                    	$("#info").prop("class", "text_blue f11 mt5");
	                        $("#info").html("<%=BizboxAMessage.getMessage("TX000007084","사용 가능한 코드입니다.")%>");
	                        ID_check = true;
	                    } else {
	                    	$("#info").prop("class", "text_red f11 mt5");
	                        $("#info").html("<%=BizboxAMessage.getMessage("TX000005915","이미 사용중인 코드입니다.")%>");
	                        ID_check = false;
	                    }
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error");
	                }
	            });
	        }
        }
      }
        
        
      // 다음 우편번호
      function fnZipPop(target) {
          new daum.Postcode({
              oncomplete: function(data) {
              	
                  var fullAddr = ''; // 최종 주소 변수
                  var extraAddr = ''; // 조합형 주소 변수

                  // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                  if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                      fullAddr = data.roadAddress;

                  } else { // 사용자가 지번 주소를 선택했을 경우(J)
                      fullAddr = data.jibunAddress;
                  }

                  // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                  if(data.userSelectedType === 'R'){
                      //법정동명이 있을 경우 추가한다.
                      if(data.bname !== ''){
                          extraAddr += data.bname;
                      }
                      // 건물명이 있을 경우 추가한다.
                      if(data.buildingName !== ''){
                          extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                      }
                      // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                      fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                  }

                  if(target.id == "btnCompZip"){
  	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
  	                document.getElementById('deptZipCode').value = data.zonecode; //5자리 새우편번호 사용
  	                document.getElementById('deptAddr').value = fullAddr;
  	
  	                // 커서를 상세주소 필드로 이동한다.
  	                document.getElementById('deptDetailAddr').focus();
                  }
                  else{
                  	// 우편번호와 주소 정보를 해당 필드에 넣는다.
  	                document.getElementById('zipCode').value = data.zonecode; //5자리 새우편번호 사용
  	                document.getElementById('addr').value = fullAddr;
  	
  	                // 커서를 상세주소 필드로 이동한다.
  	                document.getElementById('detailAddr').focus();
                  }
              }
          }).open();
      }
      
      function stamp1Upload(value){
    	  if(value.files && value.files[0]) 
  		{
  			var reader = new FileReader();

  			reader.onload = function (e) {
  				$('#IMG_COMP_STAMP1_IMG').attr('src', e.target.result);
  				$("#IMG_COMP_STAMP1_IMG").attr("style","visibility:visible");
  			}
  		
  			reader.readAsDataURL(value.files[0]);
  			
  			$("#IMG_COMP_STAMP1_DEL").attr("style", "visibility:visible");
  		}
      }
      
      function stamp2Upload(value){
    	  if(value.files && value.files[0]) 
  		{
  			var reader = new FileReader();

  			reader.onload = function (e) {
  				$('#IMG_COMP_STAMP2_IMG').attr('src', e.target.result);
  				$("#IMG_COMP_STAMP2_IMG").attr("style","visibility:visible");
  			}
  		
  			reader.readAsDataURL(value.files[0]);
  			
  			$("#IMG_COMP_STAMP2_DEL").attr("style", "visibility:visible");
  		}
      }
      
      function stamp3Upload(value){
    	  if(value.files && value.files[0]) 
  		{
  			var reader = new FileReader();

  			reader.onload = function (e) {
  				$('#IMG_COMP_STAMP3_IMG').attr('src', e.target.result);
  				$("#IMG_COMP_STAMP3_IMG").attr("style","visibility:visible");
  			}
  		
  			reader.readAsDataURL(value.files[0]);
  			
  			$("#IMG_COMP_STAMP3_DEL").attr("style", "visibility:visible");
  		}
      }
      
      function draftUpload(value){
    	  if(value.files && value.files[0]) 
  		{
  			var reader = new FileReader();

  			reader.onload = function (e) {
  				$('#IMG_COMP_DRAFT_LOGO_IMG').attr('src', e.target.result);
  				$("#IMG_COMP_DRAFT_LOGO_IMG").attr("style","visibility:visible");
  			}
  		
  			reader.readAsDataURL(value.files[0]);
  			
  			$("#IMG_COMP_DRAFT_LOGO_DEL").attr("style", "visibility:visible");
  		}
      }
</script>