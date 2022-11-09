<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
  
	/**
	 * @Class Name : IncludeKendoGrid.jsp
	 * @Description : kendoGrid 관련 js, css 파일들 Include
	 * @Modification Information
	 * @
	 * @  수정일                 수정자            수정내용
	 * @ ----------   --------    ---------------------------
	 * @ 2015.05.12    송준석             최초 생성
	 *
	 *  @author 개발1팀 송준석
	 *  @since 2015.05.12
	 *  @version 1.0
	 *  @see
	 *  IncludeKendoGrid
	 *
	 */
%>

    <!--  kendo ui 관련 js, css  -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendo/kendo.common.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendo/kendo.default.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendo/kendo.dataviz.min.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendos/kendo.dataviz.default.min.css' />" ></link>	

    <script type="text/javascript" src="<c:url value='/js/kendo/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery-1.7.1.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/kendo/kendo.all.min.js'/>"></script>     
