<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%
/**
 * @Class Name : Common.jsp
 * @title
 * @author UC개발부 개발1팀 이두승
 * @since 2015. 8. 11.
 * @version
 * @dscription 모든 페이지에 참조되어야 할 리소스들(js, css  기타 등등) -->popup 전용
 *
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용
 * -----------  -------  --------------------------------
 * 2015. 8. 11.  이두승        최초 생성
 *
 */
%>
<!--  kendo ui 관련 js, css  -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />" ></link>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.default.min.css' />" ></link>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />" ></link>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.default.min.css' />" ></link>  
<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />" ></link>  
<!--  kendo theme  -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" ></link>  

<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021'/>" />
<!--Kendo UI customize css-->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css'/>" /> 
<!--Kendo UI js lib -->
<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-1.9.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/Scripts/common.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>     

<!--Neos 관련 js-->
<script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script>
