<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>

	// 로딩이미지
	$(document).bind("ajaxStart", function () {
		kendo.ui.progress($(".sub_contents"), true);
	}).bind("ajaxStop", function () {
		kendo.ui.progress($(".sub_contents"), false);
	});	

	$(document).ready(function() {
		BindKendoGrid();
	});
	
	//kendo grid 변경 부분 
	function BindKendoGrid(){
		
		 var dataSource = new kendo.data.DataSource({
				serverPaging: true,
				transport: {
					read: {
						type: 'post',
						dataType: 'json',
						url: "portalList.do"
					},
				},
				schema: {
					data: function(response) {
						return response.list;
					},
					total: function(response) {
			  	      return response.list.length;
			  	    }
				}
			});		
			
			var grid = $("#grid").kendoGrid({
				dataSource: dataSource,
				height:500,
				groupable: false,
				columnMenu:false,
				editable: false,
				sortable: true,
			    pageable: false,
			    autoBind: true,
			    columns: [
							{ field: "compNm", title: "<%=BizboxAMessage.getMessage("TX000006442","적용회사")%>",headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"}, sortable: true },
				  			{ field: "portalDiv", width:"120px", title: "<%=BizboxAMessage.getMessage("TX000006336","포털구분")%>",headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"}, sortable: true,
				  				template: function(val){
				  					if(val.portalDiv == "cloud"){
				  						return "B <%=BizboxAMessage.getMessage("TX000006143","타입")%>";
				  					}else{
				  						return "A <%=BizboxAMessage.getMessage("TX000006143","타입")%>";
				  					}
				  				}
							},
				  			{ field: "portalNm", title: "<%=BizboxAMessage.getMessage("TX000006337","포털명")%>",headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"}, sortable: true },
				  			{ field: "useYn", width:"120px", title: "<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>",headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"}, sortable: true },
		                    { field: "portalType", width:"300px", title: "<%=BizboxAMessage.getMessage("TX000006335","포털설정")%>",headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"}, sortable: false,
				  				template: function(val){
				  					return "<input type='button' " + (val.editYn == "N" ? "disabled" : "") + " onclick='fnEditPortal(" + val.portalId + ");' class='k-button info' value='<%=BizboxAMessage.getMessage("TX000016348","기본정보설정")%>' /><input type='button' " + (val.editYn == "N" ? "disabled" : "") + " onclick='fnEditPortlet(" + val.portalId + ",\"" + val.portalDiv + "\");' class='k-button info' value='<%=BizboxAMessage.getMessage("TX000016087","포틀릿설정")%>' /><input type='button' " + (val.delYn == "N" ? "disabled" : "") + " onclick='fnDeletePortal(" + val.portalId + ");' class='k-button info' value='<%=BizboxAMessage.getMessage("TX000000424","삭제")%>' />";
				  				}
				  			},
		                    ]
		    }).data("kendoGrid");
	} // grid end
	
	function fnEditPortal(portalId){
		
		var url = "portalInfoPop.do?portalId=" + portalId;
		
		openWindow2(url, "portalInfoPop", 805, 230, 0);
	}
	
	function fnEditPortlet(portalId, portalDiv){
		
		if(portalDiv == "cloud"){
			openWindow2("portletInfoPop.do?portalId=" + portalId, "portletInfoPop", 1300, 900, 1, 1);
		}else{
			openWindow2("portletInfoPop.do?portalId=" + portalId, "portletInfoPop", 800, 800, 1, 1);	
		}
		
	}	
	
	function fnDeletePortal(portalId){
 		if(confirm("<%=BizboxAMessage.getMessage("TX000001981","삭제 하시겠습니까?")%>")){
	 		var tblParam = {};
	 		tblParam.portalId = portalId
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'portalDelete.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {
	    			if(result.value == "1"){
	    				BindKendoGrid();
	    			}else{
	    				alert("<%=BizboxAMessage.getMessage("TX000004925","삭제권한이 없습니다.")%>");
	    			}
	    			//BindKendoGrid();
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
 		}		
	}	


</script>

<div class="sub_contents_wrap" style="">
	<div id="" class="controll_btn">
		<button id="addPortal" class="k-button" onclick="fnEditPortal('0')"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
	</div>
	
	<div id="grid"></div>
	
</div><!-- //sub_contents_wrap -->



                
  