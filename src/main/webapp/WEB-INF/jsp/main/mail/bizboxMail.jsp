<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
 <%@page import="main.web.BizboxAMessage"%>

    
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
		
		$("#topMenuList").find("a[name=topMenu]").each(function(){
			$(this).removeClass("on");
		});
		$("#topMenu" + no).addClass("on");

		if (urlGubun == 'mail' || urlGubun == 'adminMail') {
    		$("#_content").attr("src", url);
		}
			
	});
</script>
     
	<!-- contents -->
	<div class="contents_wrap" style="top:-1px">
		
		<!-- iframe 영역 -->
		<div id="oneContents">
			<div class="sub_wrap" style="left:0;">
				<!-- iframe 영역 -->
				<iframe name="_content" id="_content" class="" frameborder="0" scrolling="yes" width="100%" height="100%" onload="$('#_content').contents().on('click keyup', function() { localStorage.setItem('LATime', (+new Date())); });"></iframe>
			</div>
		</div>
		
		<div class="footer">
			<span class="copy" id="footerText"></span>
			<ul class="sub_etc">
			<jsp:include page="/footer.do" />
			</ul>
		</div>
	  	
	</div> 
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

