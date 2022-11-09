<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.84.min.js"></script>
<link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/pudd.css?ver=20201021">

<div class="work_wrap sub_contents_wrap">
	<form id="groupInfoform" name="groupInfoform" action="groupManageSaveProc.do" method="post" onsubmit="return false;">
	<input type="hidden" id="saveTarget" name="saveTarget"/>													
	<div class="btn_div">
		<div class="left_div"><h5><%=BizboxAMessage.getMessage("TX000016370","그룹기본정보")%></h5></div>
		<div class="right_div">
			<div id="" class="controll_btn p0"><button id="" onclick="basicInfoSave();"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button></div>
		</div>
	</div>

	<div class="com_ta">
		<table>
			<colgroup>
				<col width="130"/>
				<col width=""/>
				<col width="120"/>
				<col width=""/>
			</colgroup>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000016134","접속정보")%></th>
				<td>${groupMap.gwUrl}</td>
				<th><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
				<td>${groupMap.groupName}</td>
				<input type="hidden" id="groupName" name="groupName"  value="${groupMap.groupName}" />
				<input type="hidden" id="groupSeq" name="groupSeq"  value="${groupMap.groupSeq}" />
			</tr>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000003273","그룹웨어 타이틀")%></th>
				<td><input type="text" style="width:50%" value="${groupMap.groupDisplayName}" name="groupDisplayName" id="groupDisplayName" onkeyup="stringToByte();" placeholder="<%=BizboxAMessage.getMessage("TX000016364","그룹웨어명 입력(입력시 상단 브라우저에 표시)")%>"/> <a id="titleByte" style="vertical-align: bottom;"></a></td>
				
				<th><%=BizboxAMessage.getMessage("TX000004105","셋업 버전")%></th>
				<td class="pr0">
					<c:choose>
						<c:when test="${buildType == 'cloud' || groupMap.updateClientUseYn != 'Y'}">
							${groupMap.setupVersion}
						</c:when>
						<c:otherwise>
							<u class="fl pt5" style="cursor: pointer;" onclick="fnPatchHistoryPop();">${groupMap.setupVersion}</u>
							<div style="float:right;" onclick="fnPatchClientPop();"><input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000009084","업데이트")%>" /></div>							
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<c:if test="${masterEdit == 'Y'}">
			<tr>
				<th>Master PassWord</th>
				<td colspan="3">
					<input autocomplete="new-password" type="password" id="masterSecu" style="width:200px;text-align:center;" value=""/>
					<div id="" class="controll_btn p0"><button id="" onclick="setMasterSecu();"><%=BizboxAMessage.getMessage("TX000006211","적용")%></button></div>
				</td>
			</tr>			
			</c:if>
		</table>
	</div>
	
	<!-- 메일 알림용 정보 설정 -->
	<div class="btn_div mt30">
		<div class="left_div"><h5><%=BizboxAMessage.getMessage("TX900001439","메일 알림용 정보 설정")%></h5></div>
		<div class="right_div">
			<div id="" class="controll_btn p0"><button onclick="mailAlertInfoSave('check');"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button></div>
		</div>
		<div class="cl text_red ml10">
			<p class="text_red f11 mt5"><%=BizboxAMessage.getMessage("TX900001440","메일 알림 사용 시 발송자의 기본 정보를 설정할 수 있습니다. (시스템 계정으로 메일 수/발신은 제공되지 않습니다.)")%></p>
			<p class="text_red f11 mt5"><%=BizboxAMessage.getMessage("TX900001441","SMTP 서버 사용여부 : 그룹웨어 내부 메일 미 사용시, SMTP 서버 설정 후 외부 메일로 알림을 수신 받을 수 있습니다.")%></p>			
		</div>		
	</div>

	<div class="com_ta">

		<table>
			<colgroup>
				<col width="150"/>
				<col width=""/>
				<col width="120"/>
				<col width=""/>
			</colgroup>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX000003536","발신자명")%></th>
				<td>
					<input class="" type="text" value="${groupMap.groupEmailName}" style="width:200px;text-align:center;" id="groupEmailName" />
				</td>
				<th><%=BizboxAMessage.getMessage("TX900001442","발신자 도메인")%></th>
				<td>
					<input class="" type="text" value="${groupMap.groupEmailId}" style="width:150px;text-align:center;" id="groupEmailId" /> @ <input class="" type="text" value="${groupMap.groupEmailDomain}" style="width:150px;text-align:center;" id="groupEmailDomain" />
				</td>
			</tr>
			<tr <c:if test="${groupMap.smtpProperties == 'Y'}">style="display:none;"</c:if>>
				<th><%=BizboxAMessage.getMessage("TX900001443","SMTP 서버 사용여부")%></th>
				<td name="outSmtpUseYnArea" <c:if test="${groupMap.outSmtpUseYn != 'Y'}">colspan="3"</c:if>>
					<input type="radio" id="outSmtpUseYn1" name="outSmtpUseYn" value="Y" class="k-radio" checked="checked" />
					<label class="k-radio-label radioSel" for="outSmtpUseYn1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
					<input type="radio" id="outSmtpUseYn2" name="outSmtpUseYn" value="N" class="k-radio" <c:if test="${groupMap.outSmtpUseYn != 'Y'}">checked="checked"</c:if> />
					<label class="k-radio-label radioSel ml10" for="outSmtpUseYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
				</td>
				<th name="outSmtpInfo" <c:if test="${groupMap.outSmtpUseYn != 'Y'}">style="display:none;"</c:if>><%=BizboxAMessage.getMessage("TX000013982","SMTP 보안설정")%></th>
				<td name="outSmtpInfo" <c:if test="${groupMap.outSmtpUseYn != 'Y'}">style="display:none;"</c:if>>
					<input type="radio" id="smtpSecuTp1" name="smtpSecuTp" value="" class="k-radio" checked="checked" />
					<label class="k-radio-label radioSel" for="smtpSecuTp1"><%=BizboxAMessage.getMessage("TX000005964","사용안함")%></label>
					<input type="radio" id="smtpSecuTp2" name="smtpSecuTp" value="TLS" class="k-radio" <c:if test="${groupMap.smtpSecuTp == 'TLS'}">checked="checked"</c:if> />
					<label class="k-radio-label radioSel ml10" for="smtpSecuTp2">TLS</label>
					<input type="radio" id="smtpSecuTp3" name="smtpSecuTp" value="SSL" class="k-radio" <c:if test="${groupMap.smtpSecuTp == 'SSL'}">checked="checked"</c:if> />
					<label class="k-radio-label radioSel ml10" for="smtpSecuTp3">SSL</label>					
				</td>
			</tr>
			<tr name="outSmtpInfo" <c:if test="${groupMap.outSmtpUseYn != 'Y'}">style="display:none;"</c:if>>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> SMTP SERVER</th>
				<td>
					<input placeholder="ex) smtp.douzone.com" type="text" value="${groupMap.smtpServer}" style="width:200px;text-align:center;" id="smtpServer"/>
				</td>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> SMTP PORT</th>
				<td>
					<input maxlength="4" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  placeholder="ex) 25" type="text" value="${groupMap.smtpPort}" style="width:150px;text-align:center;" id="smtpPort" />
				</td>
			</tr>
			<tr name="outSmtpInfo" <c:if test="${groupMap.outSmtpUseYn != 'Y'}">style="display:none;"</c:if>>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> SMTP ID</th>
				<td>
					<input placeholder="ex) dz@douzone.com" type="text" value="${groupMap.smtpId}" style="width:200px;text-align:center;" id="smtpId" />
				</td>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> SMTP PW</th>
				<td>
					<input autocomplete="new-password" type="password" type="text" value="${groupMap.smtpPw}" style="width:150px;text-align:center;" id="smtpPw" />
				</td>
			</tr>
			<input type="hidden" id="smtpRecvAddrTp" value="${groupMap.smtpRecvAddrTp}">
		</table>
		
	</div>	
	
	<!-- 그룹업로드절대경로 -->
	<div class="btn_div mt30">
		<div class="left_div"><h5><%=BizboxAMessage.getMessage("TX000021958","첨부파일 업로드 용량 설정")%></h5></div>
		<div class="right_div">
			<div id="" class="controll_btn p0"><button id="" onclick="uploadPathSave();"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button></div>
		</div>
		
		<div class="cl text_blue ml10">
			<%=BizboxAMessage.getMessage("TX000021959","최대 제한 용량 : 5GB / 개당 제한 용량 : 전체 제한 용량 기준 / 최대 파일 개수 : 30개 / 입력 값의 0은 제한 없음을 의미 합니다.")%>	
		</div>
		
		<div class="com_ta mt10">
			<table>
				<colgroup>
					<col width="150"/>
					<col width="130"/>
					<col width="130"/>
					<col width="130"/>
				</colgroup>
				<tr>
					<th class="ac p0" style="text-align:center"><%=BizboxAMessage.getMessage("TX000021960","모듈")%></th>
					<th class="ac p0" style="text-align:center"><%=BizboxAMessage.getMessage("TX000004119","전체용량")%></th>
					<th class="ac p0" style="text-align:center"><%=BizboxAMessage.getMessage("TX000021961","개당 제한 용량")%></th>
					<th class="ac p0" style="text-align:center"><%=BizboxAMessage.getMessage("TX000021962","제한 파일 갯수")%></th>
				</tr>
				<c:forEach var="items" items="${usageList}">	
					<tr>
						<th style="text-align:center"><input type="hidden" name="pathName" value="${items.pathName}" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" >
						<c:choose>
							<c:when test="${items.pathSeq == 100 || items.pathSeq == 200}">
								<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>
							</c:when>
							<c:when test="${items.pathSeq == 1300}">
								<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>
							</c:when>
							<c:when test="${items.pathSeq == 300}">
								<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>
							</c:when>
							<c:when test="${items.pathSeq == 400}">
								<%=BizboxAMessage.getMessage("TX000000483","일정")%>
							</c:when>
							<c:when test="${items.pathSeq == 500}">
								<%=BizboxAMessage.getMessage("TX000011134","게시판")%>
							</c:when>
							<c:when test="${items.pathSeq == 600}">
								<%=BizboxAMessage.getMessage("TX000008627","문서")%>
							</c:when>
							<c:when test="${items.pathSeq == 700}">
								<%=BizboxAMessage.getMessage("TX000000262","메일")%>
							</c:when>																																									
							<c:otherwise>
								${items.pathName}
							</c:otherwise>
						</c:choose>						
						</th>								
						<td style="text-align:center"><input id="total_${items.pathSeq}" target="${items.pathSeq}" class="ar pr5" type="text" name="totalCapac" value="${items.totalCapac}" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="width:30%" > MB</td>
						<td style="text-align:center"><input id="avail_${items.pathSeq}" target="${items.pathSeq}" class="ar pr5" type="text" name="availCapac" value="${items.availCapac}" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="width:30%" > MB</td>
						<td style="text-align:center"><input id="limit_${items.pathSeq}" target="${items.pathSeq}" class="ar pr5" type="text" name="limitFileCount" value="${items.limitFileCount}" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="width:30%" > <%=BizboxAMessage.getMessage("TX000001633"," 개")%></td>
						<input type="hidden" name="pathSeq" value="${items.pathSeq}" id="pathSeq_${items.pathSeq}">
						<input type="hidden" name="osType" value="${items.osType}">
					</tr>	
				</c:forEach>				
			</table>
		</div>
		
	</div>

	<!-- 로그인 이미지 설정 -->	
	<div class="btn_div mt30">
		<div class="left_div"><h5><%=BizboxAMessage.getMessage("TX000016403","Web 기본 이미지")%></h5></div>
		<div class="right_div">
			<div id="" class="controll_btn p0"><button id="" onclick="loginImageSave();"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button></div>
		</div>
	</div>
	
	
	
	<!-- Web -->								
	<div class="com_ta mt10">
		<table>
			<colgroup>
				<col width="50%"/>
				<col width=""/>
			</colgroup>
			<tr>
				<th class="cen">
					<input type="radio" name="type_web" id="typeA_web" class="k-radio" value="A" <c:if test="${groupMap.loginType == 'A'}">checked</c:if>>
					<label class="k-radio-label radioSel" for="typeA_web"><%=BizboxAMessage.getMessage("TX000016402","Web 로그인 A타입")%></label>
				</th>
				<th class="cen">
					<input type="radio" name="type_web" id="typeB_web" class="k-radio" value="B" <c:if test="${groupMap.loginType == 'B'}">checked</c:if>>
					<label class="k-radio-label radioSel ml10" for="typeB_web"><%=BizboxAMessage.getMessage("TX000016401","Web 로그인 B타입")%></label>
				</th>
			</tr>
			<tr>
				<td class="logo_set_box">
					<div class="type_a_new"></div>
					<div id="" class="controll_btn p0 pb5">
						<button id="" onClick="clickFileUpload('IMG_COMP_LOGIN_LOGO_A', 'A')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
					</div>
				</td>
				<td class="logo_set_box">
					<div class="type_b_new"></div>
					<div id="" class="controll_btn p0 pb5">
						<button id="" onClick="clickFileUpload('IMG_COMP_LOGIN_LOGO_B', 'B')"><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></button>
					</div>
				</td>
			</tr>
		</table>
	</div>

	<!-- Phone 이미지 설정 -->
	<div class="btn_div mt30">
		<div class="left_div"><h5><%=BizboxAMessage.getMessage("TX000016410","Phone 기본 이미지 설정")%></h5></div>
		<div class="right_div">
<!-- 			<div id="" class="controll_btn p0"><button id="">저장</button></div> -->
		</div>
		<div class="cl text_blue ml10"><%=BizboxAMessage.getMessage("TX000016310","로그인 이후 변경된 이미지로 반영됩니다.")%></div>
	</div>
	
	<div class="com_ta mt10">
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
	<div class="btn_div mt30">
		<div class="left_div"><h5><%=BizboxAMessage.getMessage("TX000016413","PC메신저 기본 이미지 설정")%></h5></div>
		<div class="right_div">
<!-- 			<div id="" class="controll_btn p0"><button id="">저장</button></div> -->
		</div>
		<div class="cl text_blue ml10"><%=BizboxAMessage.getMessage("TX000016310","로그인 이후 변경된 이미지로 반영됩니다.")%></div>
	</div>
	
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
</form>
</div><!-- //sub_contents_wrap -->

<form id="groupPatchClientPopForm" name="groupPatchClientPopForm" method="post" action="/BizboxPatchClient/ssoMasterLogin" target="popup_window">
  <input name="token" value="" type="hidden"/>
</form>

<script>
	var osType = "linux";
	var buildType = "${buildType}";
	var gwVolume = "${groupMap.gwVolume}" == "" ? 0 : "${groupMap.gwVolume}" * 1024;
	var mailVolume = "${groupMap.mailVolume}" == "" ? 0 : "${groupMap.mailVolume}" * 1024;
	
	$(document).ready(function() {
		stringToByte();
		//탭
		$("#tabstrip, #tabstrip_in").kendoTabStrip({
			animation:  {
				open: {
					effects: ""
				}
			}
		});
		var container = $("#groupInfoform");
                    kendo.init(container);
                    container.kendoValidator();
                    
        
        //클라우드 일 경우 메일 전체용량 설정 불가 처리(계약용량에 따라 GCMS,mail에서 별도 api로 셋팅)
        if(buildType == "cloud"){
	        $("#total_700").val(mailVolume);
	        $("#total_700").attr("disabled", "disabled");
	        $("#total_700").attr("name","");
	        $("#pathSeq_700").remove();
        }
        
        $('input[type=radio][name="outSmtpUseYn"]').on('change', function() {
            if($(this).val() == "Y"){
            	$('[name="outSmtpInfo"]').show();
            	$('[name="outSmtpUseYnArea"]').attr("colspan","1");
            }else{
            	$('[name=outSmtpInfo]').hide();
            	$('[name="outSmtpUseYnArea"]').attr("colspan","3");
            }
       });         
	});
	
	function fnPatchClientPop(){
		
 		$.ajax({
        	type:"post",
    		url:'<c:url value="/cmm/systemx/group/setUpdateClientToken.do"/>',
    		datatype:"json",
    		contentType: 'test/plain',
    		success: function (result) {
    			
    			if(result != null && result.token != null && result.token != ""){
    				
    				window.open("", "groupPatchClientPop", "width=904,height=443,scrollbars=no");
    				
    		        var frmData = document.groupPatchClientPopForm ;
    		        frmData.target = "groupPatchClientPop" ;
    		        frmData.token.value = result.token;
    				frmData.submit();	    				
			    	
    			}else{
    				alert("<%=BizboxAMessage.getMessage("TX000020304","세션이 존재하지 않습니다. 다시 로그인하세요.")%>");
    				parent.location.href = "/gw/uat/uia/actionLogout.do";
    			}
    			
    		} ,
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    }
    	});
	}
	
	function fnPatchHistoryPop(){
		
		Pudd.puddDialog({
			 
			width : 1000
		,	height : 400
		 
		,	modal : true			// 기본값 true
		,	draggable : false		// 기본값 true
		,	resize : false			// 기본값 false
		 
		,	header : {
				title : "<%=BizboxAMessage.getMessage("TX900000284","업데이트 상세정보")%>"
			,	align : "left"	// left, center, right
		 
			,	minimizeButton : false	// 기본값 false
			,	maximizeButton : false	// 기본값 false
		 
			,	closeButton : true	// 기본값 true
			,	closeCallback : function( puddDlg ) {
					// close 버튼은 내부에서 showDialog( false ) 실행함 - 즉, 닫기 처리는 내부에서 진행됨
					// 추가적인 작업 내용이 있는 경우 이곳에서 처리
				}
			}
		,	body : {
		 
				iframe : true
			,	url : "/gw/cmm/systemx/group/groupPatchHistoryInfoPop.do"

			}
		});		
		
		
	}	

 	function groupDetailInfoPop(){
 		alert("<%=BizboxAMessage.getMessage("TX000010635","개발예정 중입니다")%>");
 	}
 
 	function basicInfoSave(){
 		if(confirm("<%=BizboxAMessage.getMessage("TX000010634","그룹기본정보를 저장 하시겠습니까?")%>")){
	 		$("#saveTarget").val("B");
	 		document.groupInfoform.submit();
 		}
 	}
 	
 	function mailAlertInfoSave(state){

 		var groupEmailName = $("#groupEmailName").val();
 		var groupEmailId = $("#groupEmailId").val().replace(/ /gi,"");
 		var groupEmailDomain = $("#groupEmailDomain").val().replace(/ /gi,"");
 		var outSmtpUseYn = $(':radio[name="outSmtpUseYn"]:checked').val();
 		var smtpServer = $("#smtpServer").val().replace(/ /gi,"");
 		var smtpPort = $("#smtpPort").val();
 		var smtpId = $("#smtpId").val().replace(/ /gi,"");
 		var smtpPw = $("#smtpPw").val().replace(/ /gi,"");
 		var smtpSecuTp = $(':radio[name="smtpSecuTp"]:checked').val();
 		var smtpRecvAddrTp = $("#smtpRecvAddrTp").val();
 		
 		if(state == "check"){
 	 		if(outSmtpUseYn == "Y"){
 	 			if(smtpServer == "" || smtpPort == "" || smtpId == "" || smtpPw == ""){
 	 				puddAlert("warning", "<%=BizboxAMessage.getMessage("TX000020928","필수값이 입력되지 않았습니다.")%>", "");
 	 				return;
 	 			}
 	 		}
 	 		
 	 		puddConfirm("<%=BizboxAMessage.getMessage("TX900001465","메일 알림용 정보 설정을 저장 하시겠습니까?")%>", "mailAlertInfoSave('proc')");
 			
 		}else if(state == "proc"){
 			
	 		var tblParam = {};
	 		
	 		tblParam.groupEmailName = groupEmailName;
	 		tblParam.groupEmailId = groupEmailId;
	 		tblParam.groupEmailDomain = groupEmailDomain;
	 		tblParam.outSmtpUseYn = outSmtpUseYn;
	 		tblParam.smtpServer = smtpServer;
	 		tblParam.smtpPort = smtpPort;
	 		tblParam.smtpId = smtpId;
	 		tblParam.smtpPw = smtpPw;
	 		tblParam.smtpSecuTp = smtpSecuTp;
	 		tblParam.smtpRecvAddrTp = smtpRecvAddrTp;
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/systemx/group/mailAlertInfoSave.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {
	    			
	    			if(result.result == "success"){
	    				puddAlert("success", "<%=BizboxAMessage.getMessage("TX000010637","정상적으로 저장되었습니다")%>", "");	
	    			}else{
	    				puddAlert("error", "<%=BizboxAMessage.getMessage("TX000002439","권한이 없습니다.")%>", "");
	    			}	    			
	    			
	    		} ,
			    error: function (result) {
			    	
			    	alert("error", "<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
			    		
			    }
	    	});	 			
 			
 		}
 	}
 	
 	function puddConfirm(alertMsg, callback){
 		var puddDialog = Pudd.puddDialog({
 			width : "400"
 		,	height : "100"
 		,	message : {
 				type : "question"
 			,	content : alertMsg.replace(/\n/g, "<br>")
 			}
 		,	footer : {
 		
 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
 				buttons : [
 					{
 						attributes : {}// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
 					,	value : "<%=BizboxAMessage.getMessage("TX000019752","확인")%>"
 					,	clickCallback : function( puddDlg ) {
 							puddDlg.showDialog( false );
 							eval(callback);
 						}
 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
 					,	defaultFocus :  true// 기본값 true
 					}
 				,	{
 						attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
 					,	value : "<%=BizboxAMessage.getMessage("TX000002947","취소")%>"
 					,	clickCallback : function( puddDlg ) {
 		
 							puddDlg.showDialog( false );
 						}
 					}
 				]
 			}	
 		
 		});		
 	}

 	function puddAlert(type, alertMsg, callback){
 		var puddDialog = Pudd.puddDialog({
 			width : "400"
 		,	height : "100"
 		,	message : {
 				type : type
 			,	content : alertMsg.replace(/\n/g, "<br>")
 			}
 		,	footer : {
 		
 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
 				buttons : [
 					{
 						attributes : {}// control 부모 객체 속성 설정
 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
 					,	value : "<%=BizboxAMessage.getMessage("TX000019752","확인")%>"
 					,	clickCallback : function( puddDlg ) {
 							puddDlg.showDialog( false );
 							eval(callback);
 						}
 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
 					,	defaultFocus :  true// 기본값 true
 					}
 				]
 			}	
 		
 		});		
 	}
 	
 	function uploadPathSave(){
 		
 		var checkUsageFlag = false;
 		var checkTotalFlag = false;
 		var checkCountFlag = false;
 		var eaType = "${eaType}";
 		var totalSize = 0;
 		var cnt=0;
 		
		$("input[name='totalCapac']").each(function(){
			var size = $(this).val();	
			
			if(parseInt(size) > 5120) {
				checkUsageFlag = true;
				return;
			}
			
			// 비영리 문서유통 예외처리
// 			if(eaType == "ea") {
// 				if($(this).attr("id") == "1500") {
// 					if(parseInt(size) > 5) {
// 						checkUsageFlag = true;
// 						return;	
// 					}
// 				}	
// 			}
			
		});
			
		$("input[name='availCapac']").each(function(){
			var size = $(this).val();
			
			if($("#total_" + $(this).attr("target")).val() != "0"){
				if(parseInt(size) > parseInt($("#total_" + $(this).attr("target")).val())){
					checkTotalFlag = true;
					return;
				}
			}
			
			if(parseInt(size) > 5120) {
				checkUsageFlag = true;
				return;
			}
			// 비영리 문서유통 예외처리
// 			if(eaType == "ea") {
// 				if($(this).attr("id") == "1500") {
// 					if(parseInt(size) > 5) {
// 						checkUsageFlag = true;
// 						return;	
// 					}
// 				}
// 			}
		});
		
		$("input[name='limitFileCount']").each(function(){
			var count = $(this).val();
			
			if(parseInt(count) > 30) {
				checkCountFlag = true;
				return;
			}	
			
			// 비영리 문서유통 예외처리
// 			if(eaType == "ea") {
// 				if($(this).attr("id") == "1500") {
// 					if(parseInt(count) > 10) {
// 						checkCountFlag = true;
// 						return;	
// 					}
// 				}
// 			}
		});

		if(checkCountFlag) {
 			alert("<%=BizboxAMessage.getMessage("TX000021933","최대 파일 개수는 30개를 넘을 수 없습니다.")%>");
 		} else if(checkUsageFlag) {
 			alert("<%=BizboxAMessage.getMessage("TX000021934","최대 제한 용량은 5GB를 넘을 수 없습니다.")%>");
 		} else if(checkTotalFlag){
 			alert("<%=BizboxAMessage.getMessage("TX000021935","개당 제한 용량은 전체용량을 초과해서 설정 할 수 없습니다.")%>");
 		}	

 		
 		
 		if(!checkCountFlag && !checkUsageFlag && !checkTotalFlag) {
 			if(confirm("<%=BizboxAMessage.getMessage("TX000021963","첨부파일 업로드 용량 설정을 저장 하시겠습니까?")%>")){
		 			
 		 		$("#saveTarget").val("U");
 		 		document.groupInfoform.submit();
 	 		}	
 		}
 		
 	}
 	
 	function stringToByte(){
 		var Title = $("#groupDisplayName").val();	
 		var count = 0;
 		
 		var stringByteLength = (function(s,b,i,c){
 			for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1){
 				if (b>100)
 					return b;
 			};
 			return b
 		})(Title);
 		
 		if(stringByteLength > 100){
 			alert("<%=BizboxAMessage.getMessage("TX000010632","{0}byte이상 입력 할 수 없습니다")%>".replace("{0}","100"));
			var str = $("#groupDisplayName").val();		
			for(var i=0;i<str.length;i++){
				if(escape(str.charAt(i)).length >= 4)
					count += 3;
				else{
					if(escape(str.charAt(i)) != '%0D')
						count++;
				}
				if(count > 100){
					if(escape(str.charAt(i)) == "%0A")
						i--;
					break;
				}
			}
			$("#groupDisplayName").val(str.substring(0,i));
			count = (function(s,b,i,c){
	 			for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1){
	 				if (b>100)
	 					return b;
	 			};
	 			return b
	 		})($("#groupDisplayName").val());
			$("#titleByte").html("byte("+count+"/100)"); 
 		}
 		else{
 			$("#titleByte").html("byte("+stringByteLength+"/100)"); 
 		}
 		
 						
 	}
 	
 	function clickFileUpload(id, type) {
    	var url = "<c:url value='/cmm/systemx/groupLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr"+"&type="+type;
    	openWindow2(url+"?"+params,  "groupLogoUploadPop", 598, type == "B" ? 357 : 313 , 0) ;
    }
 	
 	function clickPhFileUpload(id, type){
 		var url = "<c:url value='/cmm/systemx/groupPhLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr&type="+ type;
    	openWindow2(url+"?"+params,  "groupPhLogoUploadPop", 638, 417, 0) ;
 	}
 	
 	function clickMsgFileUpload(id){
 		var url = "<c:url value='/cmm/systemx/groupMsgLogoUploadPop.do'/>";       
    	var params = "imgType="+id+"&callback=setOrgImgArr";
    	openWindow2(url+"?"+params,  "groupMsgLogoUploadPop", 556, 261, 0) ;
 	}

 	function loginImageSave(){
 		if(confirm("<%=BizboxAMessage.getMessage("TX000010631","로그인 이미지 설정을 저장 하시겠습니까?")%>")){
	 		var type = "";
	 		if(document.getElementById("typeA_web").checked)
	 			type = "A";
	 		else
	 			type = "B";
	 		
	 		var tblParam = {};
	 		tblParam.type = type
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/systemx/group/setLoginImgType.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (cnt) {
	    				alert("<%=BizboxAMessage.getMessage("TX000002120","저장 되었습니다.")%>");
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
 		}
 	}
 	
	<c:if test="${masterEdit == 'Y'}">
	
 	function setMasterSecu(){
 		
 		if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
 			
	 		var tblParam = {};
	 		tblParam.masterSecu = $("#masterSecu").val();
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/systemx/group/setMasterSecu.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {
	    			alert(result.resultMsg);
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
 		}
 	}	
	</c:if> 	
 	
 	
</script>