<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<link rel="stylesheet" type="text/css" href="../../../../css/reKendo.css">
<script>
$(document).ready(function() {	

	//기본버튼
    $(".controll_btn button").kendoButton();
	
    var dataSource = new kendo.data.HierarchicalDataSource({
        transport: {
          read: {
        	  type: 'post',
              url:'<c:url value="/cmm/systemx/portal/getNonEaFormTreeList.do" />',  
              dataType: "json"
          }
        },
        schema: {
          model: {
              id: "seq", 
              children: "items"
          }
          ,data: function(response) {
              return response.treeList;
          }
        }
      });
    
	/// 양식트리
	$("#treeview").kendoTreeView({
		 checkboxes: {
             checkChildren: true
         },
		autoBind: true,
		dataSource : dataSource,
		dataTextField: ["name"],
		dataValueField: ["name", "seq" , "expanded", "spriteCssClass", "type"]
		
	}).data("kendoTreeView");

// 	$('#search-term').on('keyup', function () {

// 	    $('span.k-in > em.text_blue').each(function(){
// 	    	$(this).attr("class","");
// 	    	$(this).attr("style","");
// 	    });
	  
// 	    if ($.trim($(this).val()) == '') { return; }

// 	    var term = this.value.toUpperCase();
// 	    var tlen = term.length;

// 	    $('#treeview2 span.k-in').each(function(){
// 	        var text = $(this).text();
// 	        if($(this).find(".rootfolder").length == 0){
// 		        var p = text.toUpperCase().indexOf(term);
// 		        if (p >= 0) {
// 		            var s1='', s2='';
		        
// 		            var high = '<em class="text_blue" style="font-weight: bold;">' + text.substr(p,tlen) + '</em>';
	
// 		            if (p >= 0) {
// 		                s1 = '<span class="k-sprite file"></span>' + text.substr(0,p);
// 		            }
	
// 		            if (p+tlen < text.length) {
// 		                s2 = text.substring(p+tlen)
// 		            }
	
// 		            $(this).html(s1+high+s2);
// 		        }

// 	        }
// 	    });

// 	}) ;
	// 검색 text enter
    $('#treeSearch').on('keypress', function () {
    	keywordSearch();
    }) ;
    
    //검색버튼
	$("#treeSearchBtn").click(function() {
		keywordSearch();
	});
});


/**
*   트리 검색
*/
function keywordSearch(){
     var treeSearch = $("#treeSearch").val();
     
     if(treeSearch !== "") {   
         $("#treeview .k-group .k-group .k-in").closest("li").hide();
         $("#treeview .k-group .k-group .k-in:contains(" + treeSearch + ")").each(function() {
             $(this).parents("ul, li").each(function () {
                 $(this).show();
             });
         });
     } else {
         $("#treeview .k-group").find("ul").show();
         $("#treeview .k-group").find("li").show();
     }       	        
}

// function callbackOrgChart(data){
// 	var treeview = $("#treeview").data("kendoTreeView");
<%-- 	var nodes = treeview.findByText("<%=BizboxAMessage.getMessage("TX000005622","함")%>"); --%>
// }


// //Tree select
// function onSelect(e){
// }; 



function fnSave(){
	treeCheckList = CommonKendo.getTreeCheckedToJson($("#treeview").data("kendoTreeView"));
	
	opener.eaFormCallBack(treeCheckList);
	self.close();
}


// //전체 체크박스 
// function onCheckAll(chkbox) {
// 	var isCheck = chkbox.checked;
// 	var treeview = $("#treeview2").data("kendoTreeView");
	
// 	var nodes = treeview.dataSource.view();
// 	setTreeNodesAllCheck(treeview, nodes, isCheck);
// };


// function setTreeNodesAllCheck(treeview, nodes, isCheck){
// 	var node, childNodes;
// 	var _nodes = [];
	
// 	for (var i = 0; i < nodes.length; i++) {
// 		node = nodes[i];
// 		var dataItem = treeview.dataSource.get(node.seq);
// 		var n = treeview.findByUid(dataItem.uid);
// 		treeview.dataItem(n).set("checked", isCheck);
		
// 		if (node.hasChildren) {
// 			childNodes = setTreeNodesAllCheck(treeview, node.children.view(), isCheck);

// 		}
// 	}
// }

// function fnClose(){
// 	self.close();
// }

</script>

 
<div class="pop_head">
	<h1><%=BizboxAMessage.getMessage("","결재양식등록")%></h1>
	<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
</div> 
 
 

	<div class="pop_con">

		<div class="com_ta">
			<table>
				<colgroup>
					<col width="99"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000009645","양식함 명")%></th>
					<td>
						<div class="dod_search">
							<input type="text" class="" id="treeSearch" style="width:190px;"}"/>
							<a href="#" id="treeSearchBtn" class="btn_sear"></a>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div style="height: 20px"></div>
		
		<input type="checkbox" id="all_tree" class="k-checkbox" onclick="onCheckAll(this)">
		<label class="k-checkbox-label chkSel" for="all_tree" style="margin:14px 0 0 10px;"><%=BizboxAMessage.getMessage("TX000003025","전체선택")%></label>
		
		<!-- 트리영역 -->

		<div id="treeview" class="tree_icon" style="width:100%;"></div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave()"/> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();"/>
			</div>
		</div>
			


	</div>





<%--
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("","결재양식등록")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	
	<div class="pop_con">
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
				
		<div style="height: 20px"></div>
		<input type="checkbox" id="all_tree" class="k-checkbox" onclick="onCheckAll(this)">
		<label class="k-checkbox-label chkSel" for="all_tree" style="margin:14px 0 0 10px;"><%=BizboxAMessage.getMessage("TX000003025","전체선택")%></label>
		<div id="treeview" style="width: 100%;"></div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave()"/> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();"/>
			</div>
		</div>
	</div>
 --%>


