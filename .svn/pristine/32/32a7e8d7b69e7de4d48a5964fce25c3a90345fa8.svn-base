<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
	<div class="main_wrap" style="width:1100px">
		<!-- 1단 -->
			<c:forEach begin="1" end="${cnt}">
		<div class="con_left">			
			<iframe id="" name="" class="mb8" src="" frameborder="0" scrolling="no" width="228" height="224" ></iframe>
		</div>
			</c:forEach>
	</div> 
	
	<!-- quick link -->
	<div class="main_quick">
		<iframe id="" name="" src="" frameborder="0" scrolling="no" width="100%" height="108"></iframe>	
	</div>
	
	
<script>
var idx = 0;
var jsonObjList = null;
	$(window).load(function() {
		  
		  var listJson = '${returnList}'.replace(/\\'/g, "'");
		   
		  jsonObjList = JSON.parse(listJson);
		  
		 setIframe();
		 
	  });
	
	function setIframe() {
		var iframes = $("iframe");
		if (idx < jsonObjList.length) {
			$(iframes[idx]).attr("src","/edms/board/getMainDocList.do?dir_cd="+jsonObjList[idx++].dir_cd);
			setTimeout("setIframe()", 200);
		}
	}
	
</script>
	
	
	