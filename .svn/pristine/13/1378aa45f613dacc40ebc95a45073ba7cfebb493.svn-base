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
	});
	
	 function gridRead() {
		 var grid = $("#grid").data("kendoGrid");
			grid.dataSource.read();
			grid.refresh();
	 }
	 
	 // 언어 종류를 구분자로 직렬화 된 것을 array로 변환하여 메인 언어는 bold 처리한다.
	 function rebuildLang(v) {
		 var r = "";
		 if (v != null && v != '') {
			 var arr = v.split(',');
			 if (arr != null && arr.length > 0) {
				
				 for(var i = 0; i < arr.length; i++) {
					
					 var sarr = arr[i].split('|');
					 
					 if (sarr[1] == 'Y') {
						 r += "<b>"+sarr[0]+"</b> ";
					 } else {
					 	r += sarr[0]+" ";
					 }
				 } 
				 
			 }
		 }
		 
		 return r;
	 }
</script>
 
<div>
	
	<div>
			<select id="searchType" name="searchType" style="width:100px;">
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
			 	<option value="0"><%=BizboxAMessage.getMessage("TX000000018","회사명")%></option>
			 	<option value="1"><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></option>
			</select>
		
        	<input type="text" id="searchKeyword" name="searchKeyword" />
        
	 	<button id="primaryTextButton" class="k-primary"><%=BizboxAMessage.getMessage("TX000001289","검색")%></button>
	</div> 
	  
</div>
<div> 
	<div id="grid" ></div>
</div>

 

<script id="langTemplate" type="text/x-kendo-tmpl">
	#= kendo.toString(rebuildLang(lang)) # 
</script> 

<script>
	$(document).ready(function() {
	    var dataSource = new kendo.data.DataSource({
	    	serverPaging: true,
	  		pageSize: 10,
	         transport: { 
	             read:  {
	                 url: 'groupCompListData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.searchKeyword = $("#searchKeyword").val();
	                 options.searchType = $("#searchType").val();
	                    
	                 if (operation !== "read" && options.models) {
	                     return {models: kendo.stringify(options.models)};
	                 }
	                 
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
	
		 $("#grid").kendoGrid({
		     dataSource: dataSource,
		     sortable: false ,
   	  		selectable: true,
   	  		navigatable: true,
   	  		pageable: {
					refresh: false,
   	    		pageSizes: true
   	  		},
   	  		scrollable: true,
   	  		columnMenu: false,
   	  		autoBind: true,
		    columns: [
						{ field: "compSeq", title: "<%=BizboxAMessage.getMessage("TX000000017","회사코드")%>",align:"center", width: "100px" },
		                { field: "compName", title: "<%=BizboxAMessage.getMessage("TX000000018","회사명")%>" , align:"center" , width: "200px"/* , filterable: false, sortable: false, template: "<input type=\"checkbox\" name =\"chkEmp\"  class=\"checkbox\" value = \"#=empSeq#\"/>"  */ },
		                { field: "useYn", title: "<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>", align:"center", width: "80px" },
		                { field: "erpYn", title: "<%=BizboxAMessage.getMessage("TX000010762","ERP연동")%>", width: "80px" }, 
		                { field: "snsId", title: "<%=BizboxAMessage.getMessage("TX000010761","SMS연동")%>", width: "80px" }, 
		                { field: "loginType", title: "<%=BizboxAMessage.getMessage("TX000010760","별도로그인")%>", width: "90px"},  
		                { field: "lang", title: "<%=BizboxAMessage.getMessage("TX000010759","다국어")%>", template:kendo.template($("#langTemplate").html())},   
		                { field: "createDate", title: "<%=BizboxAMessage.getMessage("TX000010758","최초사용일")%>", width: "130px" } 

	           		]
		 });
		  
		 
		 $("#primaryTextButton").kendoButton({
			 click: function(e) {
				 gridRead();
			 } 
		 });
		 
		 $("#searchType").kendoDropDownList();

	});
</script>
 
 



                
  