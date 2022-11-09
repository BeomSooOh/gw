<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>

	var htmlInfo;

	$(document).ready(function() {
		$("#cancelBtn").on("click", function(e) {
			window.close();
		});
		
		htmlInfo = JSON.parse('${htmlInfo}');
		
		checkConvertHtml();
	});
	
	function checkConvertHtml(){
		if(htmlInfo.ret == "1") {
			alert("<%=BizboxAMessage.getMessage("TX000010955","문서변환에 실패하였습니다. 다시 시도해 주십시오")%>");
			closeWindow();
		}
		
		if(htmlInfo.htmlStatus == "complete") {
			document.location.replace(htmlInfo.htmlUrl);
		}
		else if(htmlInfo.htmlStatus == "convert") {
			setTimeout("recheckConvertHtml()", 3000);
		}
		else {
			alert("<%=BizboxAMessage.getMessage("TX000010955","문서변환에 실패하였습니다. 다시 시도해 주십시오")%>");
			closeWindow();
		}
	}
	
	function recheckConvertHtml() {
		var param = {};
		
		param = htmlInfo;
		
		$.ajax({
			type:"POST"
			, dataType: "json"
			, url:"<c:url value='/CheckConvertHtml.do' />"
			, data: param
			, success: function(data) {
				htmlInfo = JSON.parse(data.htmlInfo);
				
				checkConvertHtml();
			}
			, error: function(request, status, error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
		});
    }
	
	function closeWindow() {
        if (navigator.appVersion.indexOf("MSIE 7.0")>=0 || navigator.appVersion.indexOf("MSIE 8.0")>=0 ||  navigator.appVersion.indexOf("MSIE 9.0")>=0 ) {
            window.open("about:blank", "_self").close();
        }
        else {
            window.opener = self;
            self.close();
        }
    }

</script>

<!-- 로딩 -->
<div class="pop_wrap_area">
	<div class="pop_wrap brn">
		<img src="Images/ico/loading.gif" alt="로딩" />
	</div>
</div>
<div class="modal"></div>
<!--// 로딩 -->