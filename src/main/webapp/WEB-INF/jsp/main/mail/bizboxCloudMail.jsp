<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
 <%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href="/gw/css/layout_freeb.css?ver=20201021">
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery-ui.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/common.js?ver=20201021"></script>
<script type="text/javascript" src="/gw/js/Scripts/common_freeb.js?ver=20201021"></script>

<!-- mCustomScrollbar -->
<link rel="stylesheet" type="text/css" href="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.css">
<script type="text/javascript" src="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>


<script type="text/javascript">

	$(document).ready(function() {
		// iframe
		var no = '${params.no}';
		var name = '${params.name}';
		var url = '${params.url}';
		var admEmailUrl = '${params.email}';
		var urlGubun = '${params.urlGubun}';
		var mainForward = '${params.mainForward}';
		var gnbMenuNo = '${params.gnbMenuNo}';
		var lnbMenuNo = '${params.lnbMenuNo}';
		var portletType = '${params.portletType}';

		$("#mCSB_1_container").find("li").removeClass("active");
		$("#topMenu" + no).addClass("active");

		if (urlGubun == 'mail' || urlGubun == 'adminMail') {
    		$("#_content").attr("src", url);
		}
			
	});
</script>
		
	<!-- freeb contents wrap-->
	<div class="freeb_contents_wrap">
		 
		<!-- freeb left contents -->
		<div class="freeb_oneframe_left_contents">
			<!-- freeb gnb -->
			<div class="freeb_gnb">
				<ul class="gnb_list">
					<li class="gnb_menu">
						<span class="menu_all"></span>
						<a href="javascript:void(0);" class="gnb_lnk" title="전체메뉴"><%=BizboxAMessage.getMessage("TX000011268","메뉴목록")%></a>
					</li>
					<c:forEach items="${topMenuList}" var="list" varStatus="c">
					<li class="gnb_menu" id="topMenu${list.menuNo}" name="topMenu">
						<span class="menu_${list.menuImgClass}"></span>
						<a href="javascript:onclickTopCustomMenu(${list.menuNo},'${list.name }', '${list.urlPath}', '${list.urlGubun}', '${list.lnbMenuNo}', '${list.ssoUseYn}');" class="gnb_lnk" title="${list.name}">${list.name}</a>
					</li>						
					</c:forEach>						
				</ul>
			</div>
		</div>
		
		<!-- freeb right contents -->
		<div class="freeb_oneframe_right_contents">
			<div class="freeb_sub_contents">
				<!-- iframe wrap -->
				<div class="iframe_wrap" style="height:100%;padding-bottom: 0px;">
					<iframe name="_content" id="_content" class="" frameborder="0" scrolling="yes" width="100%" height="100%" onload="$('#_content').contents().on('click keyup', function() { localStorage.setItem('LATime', (+new Date())); });"></iframe>
				</div>
			</div>
		</div>
		
	</div>
	<!-- //End of contents wrap -->

	<!-- freeb footer wrap -->
	<div class="freeb_footer_wrap">
		<div class="footer">
			<span class="copy" id="footerText"></span>
			<ul class="sub_etc">
			<jsp:include page="/footer.do?portalDiv=cloud" />
			</ul>
		</div>
	</div>
	<!-- //End of footer wrap -->

	
	<div id="formWindow"></div>
	<script>
	
		function init(){}
		
		// 조직도 팝업
		function orgChartPop() {
			var url = "<c:url value='/cmm/systemx/orgChartAllEmpInfo.do'/>";
			openWindow2(url,  "orgChartPop", 1000, 713, 0, 1);
		}
		
		
		_g_contextPath_ = "${pageContext.request.contextPath}";
		_g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
	</script>	