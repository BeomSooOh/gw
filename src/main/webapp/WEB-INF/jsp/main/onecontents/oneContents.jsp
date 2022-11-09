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
		
		$("#topMenuList").find("a[name=topMenu]").each(function(){
			$(this).removeClass("on");
		});
		
		$("#topMenu${params.no}").addClass("on");
		
		var form = document.getElementById('_electronicContract');
		form.target = "_content";
		form.method = "post";
		form.action = "${params.url}";
		form.submit();

	});
</script>
    <form id="_electronicContract" name="_electronicContract">
    	<input type="hidden" name="token" value="${params.token}">
	    <input type="hidden" name="groupCode" value="${params.groupCode}">
	    <input type="hidden" name="eaType" value="${params.eaType}">
	    <input type="hidden" name="compSeq" value="${params.compSeq}">
	    <input type="hidden" name="compCode" value="${params.compCode}">
	    <input type="hidden" name="venderno" value="${params.venderno}">
	    <input type="hidden" name="company" value="${params.company}">
	    <input type="hidden" name="ceoName" value="${params.ceoName}">
	    <input type="hidden" name="uptae" value="${params.uptae}">
	    <input type="hidden" name="upjong" value="${params.upjong}">
	    <input type="hidden" name="zipCode" value="${params.zipCode}">
	    <input type="hidden" name="address" value="${params.address}">
	    <input type="hidden" name="faxNo" value="${params.faxNo}">
	    <input type="hidden" name="webService" value="${params.webService}">
	    <input type="hidden" name="compSeqList" value="${params.compSeqList}">
	    <input type="hidden" name="deptSeq" value="${params.deptSeq}">
	    <input type="hidden" name="deptCode" value="${params.deptCode}">
	    <input type="hidden" name="deptName" value="${params.deptName}">
	    <input type="hidden" name="erpSeq" value="${params.erpSeq}">
	    <input type="hidden" name="empSeq" value="${params.empSeq}">
	    <input type="hidden" name="userId" value="${params.userid}">
	    <input type="hidden" name="userName" value="${params.userName}">
	    <input type="hidden" name="telNo" value="${params.telNo}">
	    <input type="hidden" name="hpNo" value="${params.hpNo}">
	    <input type="hidden" name="email" value="${params.email}">
	    <input type="hidden" name="auth" value="${params.auth}">
    </form>

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

