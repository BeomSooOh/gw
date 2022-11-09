<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jsTree/style.min.css' />" />

<style>
li.jstree-open>a .jstree-icon.jstree-themeicon {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: -3px;
	background: url("/gw/css/jsTree/ico_folder_open01.png") 0px 0px
		no-repeat !important;
}

li.jstree-closed>a .jstree-icon.jstree-themeicon {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: -3px;
	background: url("/gw/css/jsTree/ico_folder_fold01.png") 0px 0px
		no-repeat !important;
}

li.jstree-leaf>a .jstree-icon.jstree-themeicon {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: -3px;
	background: url("/gw/css/jsTree/ico_folder_fold01.png") 0px 0px
		no-repeat !important;
}

.orgTreeView .jstree-container-ul>.jstree-node {
	background: transparent;
}

#orgTreeView .jstree-container-ul>.jstree-node>.jstree-ocl {
	background: transparent;
}

.orgTreeView .jstree-container-ul>.jstree-open>.jstree-ocl {
	background-position: -36px -4px;
}

.orgTreeView .jstree-container-ul>.jstree-closed>.jstree-ocl {
	background-position: -4px -4px;
}

.orgTreeView .jstree-container-ul>.jstree-leaf>.jstree-ocl {
	background: transparent;
}
</style>	

<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>

<%
	String portletTp = request.getParameter("portletTp");
	String portalId = request.getParameter("portalId");
	String portletKey = request.getParameter("portletKey");
	String position = request.getParameter("position");
%>
	
<script>
	$(document).ready(function() {
		$('#orgTreeView_oc')
		.jstree(
				{
					'core' : {
						'data' : {
							'url' : 'portletEaFormUserTreePop.do',
							'cache' : false,
							'dataType' : 'JSON',
							'data' : function(node) {
								return {
									'parentSeq' : (node.id == "#" ? 0
											: node.id)
								}
							},
							'success' : function(param) {
								// console.log(param);
							}
						}
					},
					"checkbox" : {
						"keep_selected_style" : true
					},
					"search": {
						 "case_insensitive": true,
						 "show_only_matches" : true
						},
					"plugins" : [ "checkbox", "search" ]
				}).on(
				'select_node.jstree',
				function(e, data) {
					
				}).bind(
						"loaded.jstree",
						function (event, data) {
							
						}).bind("deselect_node.jstree", function(evt, data) {
							
				        });;
        fnButtonEvent();
	});
	
	function fnButtonEvent() {
		$("#btn_save").click(function() {
			fnSave();
		});
	}
	
	function fnSave() {
		var selectedElmsIds = '';
		var selectedElms = $('#orgTreeView_oc').jstree("get_selected", true);
		$.each(selectedElms, function() {
		    
		    selectedElmsIds += ','+ (this.id);
		});
		
		if(selectedElmsIds.length > 0)
			selectedElmsIds = selectedElmsIds.substring(1);	

		var param = {};
		param.portletTp= "<%= portletTp %>";
		param.portalId  ="<%= portalId %>";
		param.portletKey=  "<%= portletKey %>";
		param.position  ="<%= position %>";
		param.custValue0=selectedElmsIds;
		
		$.ajax({
			type: "post",
            url: '<c:url value="/cmm/systemx/setUserPortlet.do" />',
            datatype: "json",
            async: false,
            data: param,
            success: function (data) {
            	alert('저장되었습니다.');
            	fnCancel();
            	var param = {};
            	param.val0 = selectedElmsIds;
            	opener.fnDrawEaFormPortlet(param, "<%= position %>");
            },
            error: function (e) {   //error : function(xhr, status, error) {
                alert("error2");
            }
		});
	}
	
	function fnCancel() {
		self.close();
	}
</script>

<div class="fl mt10 orgTreeView" style="width: 100%;"
	id="div_org_tree_oc">
	<div class="com_ta">
			<table>
				<colgroup>
					<col width="80"/>
					<col width=""/>
				</colgroup>
				<tr id="">
					<th><%=BizboxAMessage.getMessage("TX000000399","검색어")%></th>
					<td>					
						<input type=text id='search-term' style="width: 100%;"/>						
					</td>
				</tr>
					
			</table>
		</div>
	<div class="box_div p0">
		<div class="jstreeSet" style="height: 100%;">
			<div id="orgTreeView_oc"></div>
		</div>
	</div>
</div>

<div class="pop_foot">
	<div class="btn_cen pt12">
		<input type="button" id="btn_save" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> <input
			type="button" id="btn_cancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
	</div>
</div>