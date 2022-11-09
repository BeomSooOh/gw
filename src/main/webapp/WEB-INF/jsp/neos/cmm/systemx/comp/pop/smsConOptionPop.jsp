<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
		$(document).ready(function() {

			$("#tabstrip").kendoTabStrip({
				animation:  {
					open: {
						effects: "fadeIn"
					}
				}
			});

			

		//기본버튼
           $(".controll_btn button").kendoButton();
		
		
		
			if("${smsMap.smsUse}" == "1"){
				if("${smsMap.smsId}" != ""){
					$("#smsId").val("${smsMap.smsId}");
					$("#smsPwd").val("${smsMap.smsPasswd}");
					document.getElementById("radi_sure").checked = true;
					bizSureFn(2);
				}
			}
		});	
		
		/*탭*/
		function bizSureFn(n){
		    

		    switch (n) {
		        case 1:
		        $('.sms_tab1').css("display","block");
				$('.sms_tab2').css("display","none");

		        break;
		        
		        case 2:
		        $('.sms_tab2').css("display","block");
				$('.sms_tab1').css("display","none");
		        break;
		        
		    }
		}

		function ok(){
			var smsType = "";
			if(document.getElementById("radi_biz").checked)
				smsType = "biz";
			else{
				smsType = "sureM";
				if($("#smsId").val() == "" || $("#smsPwd").val() == ""){
					alert("<%=BizboxAMessage.getMessage("TX000016417","ID/Pwd는 필수 입력값입니다.")%>");
					return false;
				}
			}			
			var smsId = $("#smsId").val();
			var smsPwd = $("#smsPwd").val();
			
			opener.setSmsConOption(smsType, smsId, smsPwd);
			window.close();
		}
	</script>
	
	
	<body class="">
<div class="pop_wrap" style="width:548px">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016406","SMS 연결설정")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	<div class="pop_con">
		<div class="com_ta4 hover_no">
			<table>
				<tr>
					<td>
						<input type="radio" name="radi_sel" id="radi_biz" class="k-radio" onclick="bizSureFn(1);" checked/>
						<label class="k-radio-label radioSel" for="radi_biz"><%=BizboxAMessage.getMessage("TX000016226","비즈통")%></label>
						<div style="width:130px;display:inline-block"></div>
						<input type="radio" name="radi_sel" id="radi_sure" class="k-radio"  onclick="bizSureFn(2);"/>
						<label class="k-radio-label radioSel" for="radi_sure"><%=BizboxAMessage.getMessage("TX000016189","슈어엠")%></label>
					
					</td>
				</tr>
				<tr>
					<td style="height:93px;">
						<div class="sms_tab1">
							<p>-<%=BizboxAMessage.getMessage("TX000016271","발신번호 사전등록 인증을 위해 회사의 사업자 번호를 꼭 입력해 주세요.")%></p>
						</div>
						<div class="sms_tab2" style="display:none;">
							<p class="mt10">-<%=BizboxAMessage.getMessage("TX000016321","등록된 계정 및 연동 패스워드를 입력해 주세요")%></p>

							<div class="com_ta" style="width:460px; margin:15px auto;">
								<table>
									<colgroup>
										<col width="100"/>
										<col width=""/>
										<col width="100"/>
										<col width=""/>
									</colgroup>
									<tr>
										<th class="pr15"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> ID</th>
										<td><input type="text" style="width:90%;" id="smsId"/></td>
										<th class="pr15"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> Password</th>
										<td><input autocomplete="new-password" type="Password" style="width:90%;" id="smsPwd"/></td>
									</tr>
								</table>
							</div>
						</div>
					
					</td>
				</tr>
			</table>
		</div>	

	</div><!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok();"/>
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript:window.close();"/>
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
</body>