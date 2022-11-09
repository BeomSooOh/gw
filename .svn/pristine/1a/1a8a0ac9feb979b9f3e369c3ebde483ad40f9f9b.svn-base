<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">

$(document).ready(function() {
	
});		

	function fnDownAndSave() {
		var activeYn = "${activxYn}";
		
		if(activeYn == "N"){    	
		    this.location.href = '${fileUrl}';
	        return false;
		}
		else{
			if(('${fileUrl}').toUpperCase().indexOf('HTTP') < 0){
				goForm(window.location.protocol + "//" + location.host + '${fileUrl}');
			}else{
				goForm('${fileUrl}');	
			}
		}
	}
	
	function goForm(url){
		
		if('${paramMap.loginId}' == ""){
			alert("<%=BizboxAMessage.getMessage("TX000017930","파일 다운로드 권한이 없습니다.")%>");
		}else{
			try{
				document.PimonAX.FileDownLoad(url, '${loginId}', '${fileNm}');
				window.close();
			}catch(e){
				alert("<%=BizboxAMessage.getMessage("TX000017931","파일 다운로드는 IE브라우져에서만 가능합니다.")%>");	
			}
		}
	}
</script>

<c:if test="${activxYn == 'Y'}">
<OBJECT id="PimonAX" classid="clsid:D5EC7744-CA4E-42C0-BF49-3A6F2B225A32" codebase="/gw/js/activeX/plugin/PimonFileCtrl.cab#version=2017.1.3.1" width=0 height=0 align=center hspace=0 vspace=0></OBJECT>
</c:if>

<div class="profile_file_add">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000017932","첨부파일 다운로드")%></h1>
	</div>
	<div class="pop_con">
		<h2>${fileNm}</h2>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" onclick="javascript:fnDownAndSave();" value="<%=BizboxAMessage.getMessage("TX000001687","다운로드")%>" />
			<input type="button" class="gray_btn" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->	
