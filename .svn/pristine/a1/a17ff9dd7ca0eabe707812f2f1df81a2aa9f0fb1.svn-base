<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

<script>

	$(document).ready(function() {
		
		// 로딩이미지
		$(document).bind("ajaxStart", function () {
			kendo.ui.progress($("body"), true);
		}).bind("ajaxStop", function () {
			kendo.ui.progress($("body"), false);
		});				
		
	    //기본버튼
		var inline = new kendo.data.HierarchicalDataSource({
	        data: [${treeList}],        
	        schema: {
	            model: { 
	            	id: "seq",
	                children: "items"
	            }     
	        }
	    }); 		
	    
		/// 양식트리
		$("#treeview").kendoTreeView({
			 checkboxes: {
	             checkChildren: false
	         },
			autoBind: true,
			dataSource : inline,
	        check: onCheck,			
			dataTextField: ["name"],
			dataValueField: ["name", "seq" , "expanded", "spriteCssClass", "type"]
			
		}).data("kendoTreeView");			
		
	});
	
    function onCheck(e) {
    	var chbx = $(e.node).find('.k-checkbox input').filter(":first");
        var state = chbx.is(':checked');
    	 $(e.node).find(".k-group input").prop('checked', state);
        $(e.node).find(".k-group li.k-item").each(function(i,v){
        	e.sender.dataSource.getByUid($(v).attr('data-uid')).checked = state;
        });
    }  
	
    function fnclose(){
    	self.close();
    }
    
    function fnSave(){
    	
		if(!confirm("<%=BizboxAMessage.getMessage("TX000006312","반영하시겠습니까?")%>")){
			return;
		}
		
		var tblParam = {};
		tblParam.compSeq = "${compSeq}";
		tblParam.ouInfo = CommonKendo.getTreeCheckedToJson($("#treeview").data("kendoTreeView"));
		
 		$.ajax({
        	type:"post",
    		url:'insertOuInfo.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {
    			opener.atgSyncYn = "N";
    			opener.gridRead();
    			self.close();
    		} ,
		    error: function (result) {
		    	alert("<%=BizboxAMessage.getMessage("TX000002003", "작업이 실패했습니다.")%>");
			}
		});				
    }
    
</script>

<div class="pop_wrap resources_reservation_wrap" style="border:none;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX900000475","AD서버 조직도 반영")%></h1>
		</div>
		<!-- //pop_head -->

		<div class="pop_con">
		
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX900000480","연동 조직단위(OU) 설정")%></p>
		
			<!-- 트리영역 -->
			<div class="Pop_border p10 mt10">
				<div id="treeview" class="tree_icon p0" style="width:100%;"></div>
			</div>
		</div>
		
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000423","반영")%>" onclick="fnSave();" /> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();" />
			</div>
		</div>
</div>
	
