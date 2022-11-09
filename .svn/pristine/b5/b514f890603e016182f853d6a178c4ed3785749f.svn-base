<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script>
	function myMenuSetPop() {
    	 var pop = window.open("myMenuSetPop.do", "myMenuSetPop", "width=1052,height=600,scrollbars=no,fullscreen=yes");
    	 pop.focus();
     }

</script>

									<div class="h_pop_box">
										<div class="pop_shape"></div>
										<div class="pop_t">
											<h3><%=BizboxAMessage.getMessage("TX000016037","나의메뉴설정")%></h3>
										</div>
										<div class="pop_c">
											<ul class="menu_list_btn">
											   <c:forEach varStatus="c" begin="1" end="16" step="1">
											   		<c:set var="cl" value="" />
											   		<c:if test="${c.count != 1 && c.count % 4 == 0 }">
											   			<c:set var="cl" value="last" />
											   		</c:if>
											   		<c:if test="${not empty myMenuList[c.count-1].menuNm}">
													   	<li class="${cl}">
															<a href="#" onclick="forwardPage('', '${myMenuList[c.count-1].type}', '${myMenuList[c.count-1].gnbMenuNo}', '${myMenuList[c.count-1].menuNo}', '${myMenuList[c.count-1].urlPath}', '${myMenuList[c.count-1].urlGubun}', '${myMenuList[c.count-1].seq}', '${myMenuList[c.count-1].gnbMenuNm}')" id="" class="${myMenuList[c.count-1].menuImgClass}" title="">${myMenuList[c.count-1].menuNm}</a>
														</li>
													</c:if>
													<c:if test="${empty myMenuList[c.count-1].menuNm}">
														<li class="${cl}">
														</li>
													</c:if> 
											   </c:forEach>
											</ul>
										</div>
										<div class="pop_b">
											<div class="btn_right">
												<span class="txt">* <%=BizboxAMessage.getMessage("TX000016038","나의메뉴설정에서 자주 사용하는 메뉴를 설정하세요. (최대16개)")%></span>
												<input type="button" id="" value="<%=BizboxAMessage.getMessage("TX000016037","나의메뉴설정")%>" onclick="myMenuSetPop()" />
											</div>
										</div>
									</div>
    