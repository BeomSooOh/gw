<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript" src="/gw/js/manual.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		$("#footerText").html('${optionObject.footerText}');
				
	});
	
	function asPopup(){
		 <%-- window.open('http://1.244.116.142/SSC', '<%=BizboxAMessage.getMessage("TX000016040","원격A/S")%>', 'width=800, height=700'); --%>
		window.open('https://rs10.neors.com/customer', '<%=BizboxAMessage.getMessage("TX000016040","원격A/S")%>', 'width=800, height=700');
	}
	
	// 도움말팝업
	function helpPop() {
		var url = "<c:url value='/cmm/systemx/orgChartAllEmpInfo.do'/>";
		openWindow2(url,  "pop", 1000, 710, 1, 1);
	}
	
	<c:if test="${optionObject.option_6 == '1'}">
	function fnFaqPop(){
		openWindow2('http://publicgcms.bizboxa.com/PublicView/BizBoxAlpha/FAQ.aspx?cust=${loginVO.groupSeq}',  "faqPop", 700, 800, 1, 1);
	}
	</c:if>		
	
</script>

<c:if test="${optionObject.option_6 == '1'}">
	<li><a href="javascript:fnFaqPop();"><span class="t10">&nbsp;</span>YouTube</a></li>
</c:if>

<c:if test="${optionObject.option_0 == '1'}">
	<li><a href="javascript:main.fnEaFormPop('${loginVO.eaType}');"><span class="t1">&nbsp;</span><%=BizboxAMessage.getMessage("TX000003211","기안작성")%></a></li>
</c:if>

<c:if test="${optionObject.option_1 == '1'}">
<li><a href="#n" onclick="orgChartPop();"><span class="t2">&nbsp;</span><%=BizboxAMessage.getMessage("TX000004738","조직도")%></a></li>
</c:if>

<c:if test="${optionObject.option_2 == '1'}">
	<li><a href="javascript:msgdown_open();"><span class="t3">&nbsp;</span><%=BizboxAMessage.getMessage("TX000004025","메신저")%></a></li>
	
	<div class="pop_winmac"style="bottom: 55px;display:none;">
		<div class="winmac_in">
			<ul>
				<li class="win"><a href="/upload/PC/messenger/install/BizboxAlpha_PC_Messenger_client.zip" onClick="msgdown_close()">Windows OS</a></li>
				<li class="mac"><a href="/upload/PC/messenger/install/BizboxAlpha_MAC_Messenger_client.zip" onClick="msgdown_close()">Mac OS (Beta)</a></li>
			</ul>
	
		</div>
	</div>
	
	<style>
	.footer .pop_winmac {position:absolute;z-index:10; background:#fff; width:145px;border: 2px solid #1088e3;}
	.footer .pop_winmac .winmac_in {position:relative;overflow:hidden;padding:5px 13px 5px 5px;}
	.footer .pop_winmac .winmac_in ul li:first-child {border-bottom:1px solid #dcdcdc;}
	.footer .pop_winmac .winmac_in ul li {width:100%;}
	.footer .pop_winmac .winmac_in ul li a {display:block; width:100%;font-size:13px;line-height: 33px;;padding-left: 28px;}
	.footer .pop_winmac .winmac_in ul li:hover {background:#dff2fc;}
	.footer .pop_winmac .winmac_in ul li.win a {background:url('/gw/Images/ico/ico_menu_win02.png') no-repeat left center;background-size: 20px 20px;}
	.footer .pop_winmac .winmac_in ul li.mac a {background:url('/gw/Images/ico/ico_menu_mac02.png') no-repeat left center;background-size: 20px 20px;}
	</style>
	
	<script type="text/javascript">
		function msgdown_open() {
			if(!$(".pop_winmac").hasClass("on")){
				$(".pop_winmac").css("left", $(".t3").position().left - 90 + "px");
				$(".pop_winmac").addClass("on");
				$(".pop_winmac").show();
			} else {
				$(".pop_winmac").removeClass("on");
				$(".pop_winmac").hide();
			}
			
			$(window).bind("click keyup", function () { msgdown_close(); });
		}
	
		function msgdown_close() {
			$(".pop_winmac").removeClass("on");
			$(".pop_winmac").hide();
		}
	</script>
</c:if>

<c:if test="${optionObject.option_3 == '1'}">
<li><a href="javascript:appdown_open();"><span class="t5">&nbsp;</span><%=BizboxAMessage.getMessage("TX000007387","앱다운로드")%></a></li>
</c:if>

<c:if test="${optionObject.option_cust001 == '1'}">
<li style="display:none;"><a href="/upload/PC/EndPointUninstaller.zip"><span style="background:url('/gw/Images/ico/cust/Endpoint.png') no-repeat center;">&nbsp;</span><%=BizboxAMessage.getMessage("TX900000353","End-Point삭제")%></a></li>
</c:if>

<c:if test="${optionObject.option_cust002 == '1'}">
<li style="display:none;"><a href="/upload/PC/ArgosPIMON.zip"><span style="background:url('/gw/Images/ico/cust/ArgosPIMON.png') no-repeat center;">&nbsp;</span><%=BizboxAMessage.getMessage("","ArgosPIMON")%></a></li>
</c:if>

<c:if test="${optionObject.option_4 == '1'}">
<li><a href="#n" onclick="asPopup();"><span class="t6">&nbsp;</span><%=BizboxAMessage.getMessage("TX000016040","원격A/S")%></a></li>
</c:if>

<c:if test="${optionObject.option_5 == '1'}">
	<c:if test="${loginVO.userSe == 'USER'}">
		<li><a href="#n" onclick="onlineManualPop('main','');"><span class="t7">&nbsp;</span><%=BizboxAMessage.getMessage("TX000019709","도움말")%></a></li>		
	</c:if>
	<c:if test="${loginVO.userSe != 'USER'}">
		<li><a href="#n" onclick="onlineManualPop('main_adm','');"><span class="t7">&nbsp;</span><%=BizboxAMessage.getMessage("TX000019709","도움말")%></a></li>		
	</c:if>	
</c:if>

<div class="pop_appdown" style="display:none;">
	<div class="appdown_in">
		<a href="javascript:appdown_clo();" class="clo"><img src="/gw/Images/ico/ico_timeline_close.png" alt="닫기"/></a>
		<p class="txt"><%=BizboxAMessage.getMessage("TX000007388","QR코드를 스캔하시면 비즈박스모바일을 다운받을 수 있는 스토어로 이동합니다.")%></p>
		<p class="pic"><img src="/gw/Images/temp/bizboxA_App_QR.png?ver=210924" alt="" width="100" height="100"/></p>
		<p class="tit">IOS / Android</p>
	</div>
</div>							

