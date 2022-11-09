<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>
<%@ include file="/WEB-INF/jsp/calendar/Calendar.jsp"%>

<script type="text/javascript">

	var selectedPage = 1;

	$(document).ready(function() {
		gridRead();
	});
	
	 function gridRead() {
		 var grid = $("#grid").kendoGrid({
				 dataSource: dataSource(),
			     sortable: true ,
	 		     selectable: true,
			     navigatable: true,
	   	  		scrollable: true,
	   	  		columnMenu: false,
	   	  		autoBind: true,
	   	  		page: selectedPage,
		   	  	pageable: {         
		            change: function (e){
		                selectedPage = e.index;            
		            },          
			 		refresh: true,
			    	pageSizes: [10, 20, 50, 100]
		        },
	   	  		columns: [
			                { field: "regDate", title: "<%=BizboxAMessage.getMessage("TX900000061","요청일시")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "orgDiv", title: "<%=BizboxAMessage.getMessage("TX900000473","조직도구분")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "orgName", title: "<%=BizboxAMessage.getMessage("TX900000472","조직도명")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},  
			                { field: "syncType", title: "<%=BizboxAMessage.getMessage("TX900000471","요청구분")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true }, 
			                { field: "syncStatus", title: "<%=BizboxAMessage.getMessage("TX000000760","처리상태")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "syncDate", title: "<%=BizboxAMessage.getMessage("TX900000470","처리일시")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},  
			                { field: "syncMsg", title: "<%=BizboxAMessage.getMessage("TX900000469","결과메세지")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true } 
		           		]
			 }).data("kendoGrid");
	 }	
	
	function dataSource(){
		return new kendo.data.DataSource({
	        serverPaging: true,
	        pageSize: 10,
	         transport: { 
	             read:  {
	                 url: 'ldapSyncDetail.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.syncSeq = '${syncSeq}';
	                 return options;
	             }
	         }, 
	         schema:{
	            data: function(response) {
	              return response.list;
	            },
	            total: function(response) {
	              return response.totalCount;
	            }
	          }
	     });		
	}	 	
	

</script>


<div class="pop_wrap" style="border: none;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900000468","동기화 상세정보")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	<div class="pop_con">
		<div id="grid" class="com_ta2"></div>
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->