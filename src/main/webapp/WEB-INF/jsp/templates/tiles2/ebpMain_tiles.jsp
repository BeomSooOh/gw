<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="main.web.BizboxAMessage"%>


<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!--수정 배포된 Js파일 캐시 방지  -->
<% Date date = new Date();
   SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMddHHmm");
   String strDate = simpleDate.format(date);   
%>

<c:set var="date" value="<%=strDate%>" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script>
		var langCode = "<%=langCode%>";
	</script>

	<!--css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />"> 
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/animate.css?ver=20201021' />">
    <link rel="stylesheet" type="text/css" href="/gw/ebp/css/portlet.css">
    <link rel="stylesheet" type="text/css" href="/gw/ebp/css/main.css">
    	
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery-1.9.1.min.js' />"></script>

    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js?ver=20201021' />"></script>
    
    <%if(langCode.equals("KR")){ %>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/kr.css' />">
	<%}else if(langCode.equals("EN")){ %>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/en.css' />">
    <%}else if(langCode.equals("JP")){ %>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/jp.css' />">
    <%}else if(langCode.equals("CN")){ %>
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/cn.css' />">
	<%}%>
	
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.main.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.menu.js?ver=20201021' />"></script>
    
	<script type="text/javascript">
		
		function footBtnPop(url){
			window.open(url, "footBtnPop");
		}
		
		// 메인 페이지 이동 개선
		function mainMove(type, urlPath, seq) {
			menu.mainMove(type, urlPath, seq);
		}
		
		// 메인 페이지 이동 개선
		function moveAndReadCheck(alertSeq, forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
			menu.moveAndReadCheck(alertSeq, forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name);
		}
		
		// 조직도 팝업
		function orgChartPop() {
			var url = "<c:url value='/cmm/systemx/orgChartAllEmpInfo.do'/>";
			openWindow2(url,  "orgChartPop", 1000, 713, 1, 1);
		}
		
		// 서버세션 갱신
		function serverSessionReset(){
			$.ajax({
				type: "POST", 
		        url: "${pageContext.request.contextPath}/uat/uia/serverSessionReset.do",
		        async: true,
		        dataType: "json",
		        success: function (result) {
		        	if(result != null && result.isAuthenticated == true){
		        		setTimeout("serverSessionReset()", 600000);
		        	}
		        },  
		        error:function (e) {
		        	//setTimeout("serverSessionReset()", 600000);
		        }
			});			
		}
		
		setTimeout("serverSessionReset()", 600000);		
	
	</script> 
     
</head>	 

<div class="idleCheckDivLock" style="position:absolute;display:none; width:100%; height:100%;z-index:1003;background: black;opacity: 0.8;"></div>

<body class="main_bg portal_ceo">
	<div class="portal_wrap">
		<div>
			<jsp:include page="/ebpGnb.do" /> 
		</div>
		
		<tiles:insertAttribute name="body" /> 
		<!-- //End of main contents -->	  
			<div class="main_footer">
				<div class="footer">
					<span class="copy" id="footerText"></span>
					<ul class="main_etc" id="footBtn">
					<jsp:include page="/footer.do?portalDiv=${portalDiv}" />					
					</ul>
					<c:if test="${!empty imgMap.file_id}">
						<img src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${imgMap.file_id}&fileSn=0' />" alt="" />
					</c:if>
				</div>
			</div>
			
			<form id="form" name="form" action="bizbox.do" method="post">  
				<input type="hidden" id="no" name="no" value="" />
				<input type="hidden" id="name" name="name" value="" /> 
				<input type="hidden" id="lnbName" name="lnbName" value="" /> 
				<input type="hidden" id="url" name="url" value="" />
				<input type="hidden" id="urlGubun" name="urlGubun" value="" />
				<input type="hidden" id="mainForward" name="mainForward" value="" />
				<input type="hidden" id="gnbMenuNo" name="gnbMenuNo" value="" />
				<input type="hidden" id="lnbMenuNo" name="lnbMenuNo" value="" />
				<input type="hidden" id="seq" name="seq" value="" />
				<input type="hidden" id="portletType" name="portletType" value="" />
				<input type="hidden" id="tsearchKeyword" name="tsearchKeyword" value="" />
			</form>
			
		    <div id="idleCheckDivLock" style="position:absolute;display:none; width:100%; height:100%;z-index:1003;background: black;opacity: 0.8;"></div>
		    <div id="idleCheckDiv" style="z-index:1004;display:none;position: absolute;top: 50%;  width: 100%;margin: -113px auto;">	
			    <div style="text-align: center;  width: 100%; height:122px;">
		            <p id="secuText" style="font-size: 17px;  font-family: sans-serif;color: snow;"><%=BizboxAMessage.getMessage("TX000007433","보안설정으로 60초 카운트 후 자동 로그아웃됩니다")%></p>
		            <p id="limitSec" style="  padding: 20px;font-size: 30px;font-family: -webkit-pictograph;color:rgb(255, 194, 0);">60</p>
		            <p onkeyup="loginButton()" id="logonPw" style="display:none;">
		                <input autocomplete="new-password" type="password" style="  margin-top: 20px;  margin-bottom: 20px;  height: 30px;  text-align: center; font-size: 15px;  width: 270px;cursor: pointer;" placeholder="<%=BizboxAMessage.getMessage("TX000004122","패스워드")%>" />
		            </p>
		            <p>
		                <input name="inSession" style="font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="$('#idleCheckDiv, .idleCheckDivLock').hide();limitYn = 1;resetTimer();$('#limitSec').html('60');localStorage.setItem('limitYn', 1);localStorage.removeItem('forceLogoutYn');" value="<%=BizboxAMessage.getMessage("TX000007434","연장하기")%>" />
		                <input name="inSession" style="font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="document.location.href = 'uat/uia/actionLogout.do'" value="<%=BizboxAMessage.getMessage("TX000002980","로그아웃")%>" />
		                <input name="outSession" style=" display:none; font-weight: 600;   height: 45px; width: 276px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="reLogon();" value="<%=BizboxAMessage.getMessage("TX000003108","로그인")%>" />
		                <input name="forceSession" style="display:none; font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="document.location.href = 'uat/uia/actionLogout.do';" value=<%=BizboxAMessage.getMessage("TX000003108","로그인")%> />
		            </p>
			    </div>
		    </div>
			
			
		<script>
		
			function init(){}
			
			_g_contextPath_ = "${pageContext.request.contextPath}";
			_g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
		</script>
		
		<c:if test="${callAllPopup == 'Y'}">
			<iframe height="0" width="0" src="/edms/home/callAllPopup.do" style="visibility:hidden;display:none"></iframe>
		</c:if>	
		
	    <div id="formWindow"></div>	
	</div> 
</body>

</html>
