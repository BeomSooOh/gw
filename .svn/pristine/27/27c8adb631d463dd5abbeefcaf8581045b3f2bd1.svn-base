<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>
$(document).ready(function() {
	// 목록으로 돌아가기
		    $("#listBtn").on("click", function(e){
		    	document.form.action = 'projectManageView.do';
		    	document.form.submit();		    	
		    });
		    
		    // 삭제
		    $("#delBtn").on("click", function(e){
		    	
		    	if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
			    	document.form.action = 'projectDelProc.do';
			    	document.form.submit();
		    	}
		
		    });
	});
</script>
    
<form id="form" name="form" method="post" >
	<input type="hidden" name="noProject" value="${projectInfo.noProject}" />
	<input type="hidden" name="sKeyword" value="${params.sKeyword}" />
	<input type="hidden" name="sDatetype" value="${params.sDatetype}" />
	<input type="hidden" name="sdProject" value="${params.sdProject}" />
	<input type="hidden" name="edProject" value="${params.edProject}" />
	<input type="hidden" name="lnPartner" value="${params.lnPartner}" />
	<input type="hidden" name="pageSize" value="${params.pageSize}" />
	<input type="hidden" name="redirectPage" value="${params.redirectPage}" />
	<input type="hidden" name="page" value="${params.page}" />
	<input type="hidden" name="isRedirect" value="Y" />
</form>	