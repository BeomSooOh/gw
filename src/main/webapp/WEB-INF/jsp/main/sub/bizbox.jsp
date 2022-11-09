<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="main.web.BizboxAMessage"%>

<c:if test="${params.urlGubun == 'mail'}">
<script type="text/javascript">		
	window.onload = function(){
	  form.submit();
	}
</script>

<form id="form" name="form" action="bizboxMail.do" method="post">  
	<input type="hidden" id="no" name="no" value="${params.no}" />
	<input type="hidden" id="name" name="name" value="${params.name}" /> 
	<input type="hidden" id="lnbName" name="lnbName" value="${params.lnbName}" /> 
	<input type="hidden" id="url" name="url" value="${params.url}" />
	<input type="hidden" id="urlGubun" name="urlGubun" value="${params.urlGubun}" />
	<input type="hidden" id="mainForward" name="mainForward" value="" />
	<input type="hidden" id="gnbMenuNo" name="gnbMenuNo" value="" />
	<input type="hidden" id="lnbMenuNo" name="lnbMenuNo" value="" />
	<input type="hidden" id="seq" name="seq" value="" />
	<input type="hidden" id="portletType" name="portletType" value="" />
	<input type="hidden" id="userSe" value="" />
	<input type="hidden" id="tsearchKeyword"  value="" />
</form>
</c:if>

<c:if test="${params.urlGubun != 'mail'}">

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

<!--수정 배포된 Js파일 캐시 방지  -->
<% Date date = new Date();
   SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMddHHmm");
   String strDate = simpleDate.format(date);   
%>
<c:set var="date" value="<%=strDate%>" />
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko" style="overflow-y:hidden">
<head>
	<meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script>
		var portalDiv = "package";
		var langCode = "<%=langCode%>";
	</script>
	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js?ver=20201021' />"></script>
	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />

	<!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">	
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
    
    <!--jstree css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/jsTree/style.min.css' />" />
    
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js?ver=20201021' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	
	<%if(langCode.equals("KR")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
    <%}else if(langCode.equals("EN")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.en-US.min.js'/>"></script>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/en.css' />">
    <%}else if(langCode.equals("JP")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ja-JP.min.js'/>"></script>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/jp.css' />">
    <%}else if(langCode.equals("CN")){ %>
		<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.zh-CN.min.js'/>"></script>
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/cn.css' />">
	<%}%>
	
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js?ver=20201021' />"></script>

    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.menu.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.main.js?ver=20201021' />"></script>
    
	<!--jstree js-->
	<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>
    
	<script type="text/javascript">
	$(document).ready(function() {
		
		// iframe
		var no = '${params.no}';
		var name = '${params.name}';
		var lnbName = '${params.lnbName}';
		var url = '${params.url}';
		var urlGubun = '${params.urlGubun}';
		var mainForward = '${params.mainForward}';
		var gnbMenuNo = '${params.gnbMenuNo}';
		var lnbMenuNo = '${params.lnbMenuNo}';
		var portletType = '${params.portletType}';
		var userSe = '${userSe}';
		var linkType = '${params.linkType}';
		var ssoYn = '${params.ssoYn}';
		$("#userSe").val(userSe);
		
		if(ssoYn == 'Y' && (url == "" || url == null || lnbMenuNo == "")){
			// SSO 대메뉴이동
			menu.clickTopBtn(no, name, url, urlGubun);
		}else if (ssoYn != 'Y' && (mainForward == null || mainForward == '')) {
			// GNB 버튼 클릭	
			menu.clickTopBtn(no, name, url, urlGubun);
		}else {
			// 메인 iframe 에서 페이지 이동을 누른경우
			if(linkType == "E"){
				var dirCd = "";
				var tmp = url.split("?");
				var arr = tmp[1].split("&");
				for(var i=0; i<arr.length; i++){
					dirCd = arr[i];
					if(dirCd != dirCd.replace("dir_cd=", "")){
						lnbMenuNo = dirCd.replace("dir_cd=", "");
						url = "/doc" + url;
						mainForward = "mainForward";
					}
				}
			}			
			
			menu.forwardFromMain(portletType, gnbMenuNo, lnbMenuNo, url, urlGubun, name , lnbName , mainForward );
		}
		
		$("#topMenuList").find("a[name=topMenu]").each(function(){
			$(this).removeClass("on");
		});
		$("#topMenu" + no).addClass("on");
		$("#topMenu" + gnbMenuNo).addClass("on");
				
	});
	
	//contents iframe 영역에서 메뉴이동을 할경우 
	function menuMove(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
// 		menu.move(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name);
		mainmenu.mainToLnbMenu(gnbMenuNo, name, url, urlGubun, '', 'main', gnbMenuNo, lnbMenuNo, '', 'main');
	}
	
	// 조직도 팝업
	function orgChartPop() {
		var url = "<c:url value='/cmm/systemx/orgChartAllEmpInfo.do'/>";
		openWindow2(url,  "orgChartPop", 1000, 713, 0, 1);
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
<body class="">
	<!-- Header -->
	<div class="header_wrap"> 
		<jsp:include page="/topGnb.do" /> 
	</div> 
	 
	<!-- contents -->
	
	<div class="contents_wrap">
		<div id="horizontal">
			<div class="side_wrap"> 
				<h2 class="sub_nav_title"></h2> 
				<div class="nav_div">
					<div id="sub_nav_jstree" style="border-width:0">
					</div>
				</div>	
			</div>
			<div class="sub_wrap">
				<div class="sub_contents" id="_sub_contents">
						<!-- iframe 영역 -->  
						<iframe name="_content" id="_content" class="" frameborder="0" scrolling="yes" width="100%" height="100%" onload="$('#_content').contents().on('click keyup', function() { localStorage.setItem('LATime', (+new Date())); });"></iframe>
				</div> 
			</div>  
		</div> <!--//# horizontal -->
			

	  	<div class="footer">
			<span class="copy" id="footerText"></span>
			<ul class="sub_etc">
			<jsp:include page="/footer.do" />
			</ul>
			<c:if test="${!empty imgMap.file_id}">
				<img src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${imgMap.file_id}&fileSn=0' />" alt="" />
			</c:if>
		</div>
		
	</div> 
	
    <div id="idleCheckDiv" style="z-index:1004;display:none;position: absolute;top: 50%;  width: 100%;margin: -113px auto;">	
	    <div style="text-align: center;  width: 100%; height:122px;">
            <p id="secuText" style="font-size: 17px;  font-family: sans-serif;color: snow;"><%=BizboxAMessage.getMessage("TX000007433","보안설정으로 60초 카운트 후 자동 로그아웃됩니다")%></p>
            <p id="limitSec" style="  padding: 20px;font-size: 30px;font-family: -webkit-pictograph;color:rgb(255, 194, 0);">60</p>
            <p onkeyup="loginButton()" id="logonPw" style="display:none;">
                <input autocomplete="new-password" type="password" style="  margin-top: 20px;  margin-bottom: 20px;  height: 30px;  text-align: center; font-size: 15px;  width: 270px;cursor: pointer;" placeholder="<%=BizboxAMessage.getMessage("TX000004122","패스워드")%>" />
            </p>
            <p>
                <input name="inSession" style="font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="$('#idleCheckDiv, .idleCheckDivLock').hide();limitYn = 1;resetTimer();$('#limitSec').html('60');localStorage.setItem('limitYn', 1);localStorage.removeItem('forceLogoutYn');" value="<%=BizboxAMessage.getMessage("TX000007434","연장하기")%>" />
                <input name="inSession" style="font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="document.location.href = 'uat/uia/actionLogout.do';" value=<%=BizboxAMessage.getMessage("TX000002980","로그아웃")%> />
                <input name="outSession" style="display:none; font-weight: 600;   height: 45px; width: 276px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="reLogon();" value="<%=BizboxAMessage.getMessage("TX000003108","로그인")%>" />
                <input name="forceSession" style="display:none; font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#fafafa;color:#333333;padding:0 8px; height:30px; border-bottom:1px solid #bdbdbd;line-height:22px;" type="button" onclick="document.location.href = 'uat/uia/actionLogout.do';" value=<%=BizboxAMessage.getMessage("TX000003108","로그인")%> />
            </p>
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
		<input type="hidden" id="userSe"  value="" />
	</form> 
	
	<script>
		function init(){}
		
		_g_contextPath_ = "${pageContext.request.contextPath}";
		_g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
	</script>
	<div id="formWindow"></div>	
</body>
</html>
</c:if>