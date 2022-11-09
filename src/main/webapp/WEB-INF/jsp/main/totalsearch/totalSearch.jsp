<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<c:if test="${portalDiv != 'cloud'}">

	<div class="contents_wrap" style="top:-1px">
		
		<!-- iframe 영역 -->
		<div id="oneContents">
			<div class="sub_wrap" style="left:0;">
				<!-- iframe 영역 -->
				<iframe id="iframeTotalSearchContent" name="iframeTotalSearchContent" target="iframeTotalSearchContent" width="100%" height="100%" src="/gw/totalSearchParam.do" frameborder="0"  scrolling="no"></iframe>
			</div>
		</div>
		
		<div class="footer">
			<span class="copy" id="footerText"></span>
			<ul class="sub_etc">
			<jsp:include page="/footer.do" />
			</ul>
		</div>
	  	
	</div> 

</c:if>

<c:if test="${portalDiv == 'cloud'}">

<link rel="stylesheet" type="text/css" href="/gw/css/layout_freeb.css?ver=20201021">
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery-ui.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/common.js?ver=20201021"></script>
<script type="text/javascript" src="/gw/js/Scripts/common_freeb.js?ver=20201021"></script>

<!-- mCustomScrollbar -->
<link rel="stylesheet" type="text/css" href="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.css">
<script type="text/javascript" src="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>


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
		<div class="freeb_sub_contents" style="overflow: hidden;">
			<!-- iframe wrap -->
			<div class="iframe_wrap" style="height:100%;padding-bottom: 0px;">
				<iframe id="iframeTotalSearchContent" name="iframeTotalSearchContent" target="iframeTotalSearchContent" width="100%" height="100%" src="/gw/totalSearchParam.do" frameborder="0"  scrolling="no"></iframe>
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
</c:if>

<div id="formWindow"></div>

<script type="text/javascript">
	
	document.forms[0].tsearchKeyword.value = '${tsearchKeyword}';

	function getSearchKeyword(){
		return document.forms[0].tsearchKeyword.value;
	}	
	
</script>
