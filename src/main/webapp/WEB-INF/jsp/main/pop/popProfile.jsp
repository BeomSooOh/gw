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
		$("#cancelBtn").on("click",function(e){
			window.close();
		});
	});

</script>

<div class="pop_wrap pb15" style="width:600px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000008520","프로필 보기")%></h1>
		<a href="#n" class="clo"><img src="Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	<div class="pop_con">		
		<div class="profile">
			<ul>
				<li class="profile_img">
					<p class="img"><img src="${profilePath}/${userInfo.empSeq}_thum.jpg" alt="" onerror="this.src='Images/bg/profile_noimg.png'"/></p>
					<p class="name">[${userInfo.deptPositionCodeName}] ${userInfo.empName}</p>
				</li>
				<li class="profile_info">
					<ul>
						<li class="icon01">${userInfo.compName} ${userInfo.deptName}</li>					
						<li class="icon02">${userInfo.loginId}</li>					
						<li class="icon03">${userInfo.mobileTelNum}</li>					
						<li class="icon04">${userInfo.telNum}</li>					
						<li class="icon05">${userInfo.emailAddr}@${userInfo.emailDomain}</li>				
						<li class="icon06">(${userInfo.deptZipCode}) ${userInfo.deptAddr} ${userInfo.deptDetailAddr}</li>
					</ul>
				</li>
			</ul>
		</div>	
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->