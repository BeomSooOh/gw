<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<head>
   	<!--css-->
   	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css?ver=20201021">
</head>

<script>

	window.addEventListener('DOMContentLoaded', function(){
		window.resizeTo(600,380);
	});
	
</script>

<body>
<div class="pop_wrap" style="border:none;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000015788","프로필")%></h1>
	</div>

	<div class="pop_con profile">		
		<table width="100%">
			<colgroup>
				<col width="130" />
				<col width="" />
			</colgroup>
			<tr>
				<td class="profile_img mt15">					
					<p class="img"><img src="${profileInfo.profilePath}/${profileInfo.empSeq}_thum.jpg?<%=System.currentTimeMillis()%>" onerror=this.src="/gw/Images/bg/profile_noimg.png" alt=""/></p>
					<p class="name">${profileInfo.empName}</p>
				</td>
				<td class="profile_info">
					<table width="100%">
						<colgroup>
							<col width="50%" />
							<col width="50%" />
						</colgroup>
						<tr>
							<td colspan="2" class="icon01">${profileInfo.deptPathName}</td>
						</tr>
						<tr>
							<td colspan="2" class="icon02">${profileInfo.loginId}</td>
						</tr>
						<tr>
							<td class="icon03">${profileInfo.mobileTelNum}</td>
							<td class="icon08">${profileInfo.bday}</td>
						</tr>
						<tr>
							<td class="icon04">${profileInfo.telNum}</td>
							<td class="icon10">${profileInfo.faxNum}</td>
						</tr>						
						<tr>
							<td colspan="2" class="icon09">${profileInfo.mainWork}</td>
						</tr>
		
						<c:if test="${profileInfo.inEmailAddr != ''}">
							<tr>
								<td colspan="2" class="icon05">${profileInfo.inEmailAddr}</td>
							</tr>	
						</c:if>
						
						<c:if test="${profileInfo.outEmailAddr != ''}">
							<tr>
								<td colspan="2" class="icon05">${profileInfo.outEmailAddr}</td>
							</tr>	
						</c:if>

						<tr>
							<td colspan="2" class="icon06">${profileInfo.addr}</td>
						</tr>
					</table>		
				</td>
			</tr>
		</table>	
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</body>
</html>