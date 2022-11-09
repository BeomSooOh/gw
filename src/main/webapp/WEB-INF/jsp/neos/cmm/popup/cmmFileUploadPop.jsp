<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
		$(document).ready(function() {
			
			var result = '${resultCode}';
			
			if (result == 'SUCCESS') {
				alert('${resultMessage}');
				
				var callback = '${callback}';
		
				if (callback) {
					eval('window.opener.' + callback)('${fileId}', '','${detailCode}','${orgSeq}','${imgOsType}');
				}
				
				window.close();
				
			}
			
			//프로필사진등록	
			$("#photofiles").kendoUpload({
				multiple: false,
				localization: {
					select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
			    }
			});
			
			$("#okBtn").on("click", ok);
		});	
		
		function ok() {
			document.form.submit();
		}
		
		
</script>
<form id="form" name="form" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cmm/file/fileUploadProc.do">	
	<input type="hidden" id="orgSeq" name="orgSeq" value="${orgSeq}" >
	<input type="hidden" id="imgOsType" name="imgOsType" value="${imgOsType}" >
	<input type="hidden" id="imgType" name="imgType" value="${detailCode}" >
	<input type="hidden" id="code" name="code" value="${code}" >
	<input type="hidden" id="detailCode" name="detailCode" value="${detailCode}" >
	<input type="hidden" id="callback" name="callback" value="${callback}" >
	<input type="hidden" id="pathSeq" name="pathSeq" value="900" > 
	<input type="hidden" id="dataType" name="dataType" value="page" >
	<input type="hidden" id="page" name="page" value="/cmm/popup/cmmFileUploadPop.do" > 
	<div class="pop_wrap profile_file_add" style="width:418px;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000009109","이미지 업로드")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		</div><!-- //pop_head -->
		<div class="pop_con">
			<h2>${title}</h2>
			<div class="file_add_box">
				<input name="photofiles" id="photofiles" type="file" >
			</div>
		</div><!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000602","등록")%>" id="okBtn" />
				<input type="button" class="gray_btn" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->	
</form>