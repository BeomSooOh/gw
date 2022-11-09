<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
    
    	
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    
<script type="text/javascript">
	
$(document).ready(function() {
	
	var tsearchKeyword = parent.getSearchKeyword();
	form.tsearchKeyword.value = tsearchKeyword;
	form.searchType.value = 'main';
	form.tsearchSubKeyword = '';
	form.boardType.value = '1';
	form.fromDate.value = '';
	form.toDate.value = '';
	form.dateDiv.value = '';
	form.detailSearchYn.value = 'N';
	form.selectDiv.value = 'S';
	form.orderDiv.value = 'B';
	form.pageIndex.value = '1';
	form.hrSearchYn.value = 'N';
	form.hrEmpSeq.value = '';
	
	totalSearchSubmit();
});

</script>
	<div id="loading" style="position: absolute;left:50%;top:30%; margin: 0; padding: 0;"><img src="/gw/Images/ico/loading.gif"></div>

	<form id="form" name="form" action="getTotalSearchContentNew.do" method="post">  
	<input type="hidden" id="searchType" name="searchType" value="main" />
	<input type="hidden" id="tsearchKeyword" name="tsearchKeyword" value="" />
	<input type="hidden" id="tsearchSubKeyword" name="tsearchSubKeyword" value="" />
	<input type="hidden" id="boardType" name="boardType" value="1" />
	<input type="hidden" id="fromDate" name="fromDate" value="" />
	<input type="hidden" id="toDate" name="toDate" value="" />
	<input type="hidden" id="dateDiv" name="dateDiv" value="" />
	<input type="hidden" id="detailSearchYn" name="detailSearchYn" value="N" />
	<input type="hidden" id="selectDiv" name="selectDiv" value="S"/>
	<input type="hidden" id="orderDiv" name="orderDiv" value="B"/>
	<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
	<input type="hidden" id="hrSearchYn" name="hrSearchYn" value="N"/>
	<input type="hidden" id="hrEmpSeq" name="hrEmpSeq" value=""/>
</form>

<script>
	function totalSearchSubmit(){
		form.submit();
	}
</script>