<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<script>
	//조직도 callback 구현
	function callbackOrgChart(item) {
	//	var empDeptInfo = $('#empDeptInfo').html();
		
		var treeview = $("#orgTreeView").data("kendoTreeView");
		var selectedNode = treeview.select();
	
		
		if (item.nodes != null && item.nodes.length == 0) {
					$.ajax({
						type:"post",
						url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
						data:{groupSeq:item.groupSeq, compSeq:item.compSeq, bizSeq:item.bizSeq, deptSeq : item.seq},
						datatype:"json",			
						success:function(data){
							if (data.list) {
								var list = data.list;
								for(var i = 0 ; i < list.length; i++) {
									
									selectedNode = treeview.select();
									
			                         if (selectedNode.length == 0) {
			                             selectedNode = null;
			                         } 
			                                                  
			                         list[i].hasChildren = false;
			                         treeview.append(list[i], selectedNode);
			 
			                         //row.addClass("k-state-selected");
								}
							}
							 
						}
					});
		} else {
			
			// 반드시 구현
			getEmpInfo(item);
		}
	}
	
	function setEmpList(item) {
		var treeview = $("#orgTreeView").data("kendoTreeView");
		var selectedNode = treeview.select();
		
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
				data:{groupSeq:item.groupSeq, compSeq:item.compSeq, bizSeq:item.bizSeq, deptSeq : item.seq},
				datatype:"json",			
				success:function(data){
					if (data.list) {
						var list = data.list;
						for(var i = 0 ; i < list.length; i++) {
							
	                         if (selectedNode.length == 0) {
	                             selectedNode = null;
	                         } 
	                                                  
	                         list[i].hasChildren = false;
	                         treeview.append(list[i], selectedNode);
	 
	                         //row.addClass("k-state-selected");
						}
					}
					 
				}
			});
	}
	
	function searchKeyword() {
		var searchKeyword = $("#searchKeyword").val();
		 
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
			data:{nameAndLoginId : searchKeyword},
			datatype:"json",			
			success:function(data){
				if (data.list) {
					var list = data.list;
					setTreeViewSelect(list); 
				}
				
			}
		});
	}
	
	function setTreeViewSelect(nodes) {
		var treeview = $("#orgTreeView").data("kendoTreeView");
		var datasource = treeview.dataSource;
		for(var i = 0; i < nodes.length; i++) {
			var dataItem = datasource.get(nodes[i].deptSeq);
			console.log('nodes[i].deptSeq : ' + nodes[i].deptSeq);
			if (dataItem != null) {
				var node = treeview.findByUid(dataItem.uid);
				console.log('dataItem.uid : ' + dataItem.uid);
				if (node != null && dataItem.nodes.length == 0){
					treeview.select(node);
					console.log(node);
					setEmpList(dataItem);
					console.log(treeview.select());
					treeview.select($());
				}
			}
		}
	} 
	  
</script>



<div id="orgTreeView" class="tree_icon tree_auto" style="height:500px;"></div>

<script>
	            var inline = new kendo.data.HierarchicalDataSource({
	                data: [${orgChartList}],
	                schema: {
                        model: {
                        	id: "seq",
                            children: "nodes"
                        } 
                    }
	            });
	            
	            var checkChildren = '${checkChildren}';
	            
	            if (checkChildren == null || checkChildren == '' || checkChildren == 'false') {
	            	checkChildren = false;
	            } else {
	            	checkChildren = true;
	            }
	
	            $("#orgTreeView").kendoTreeView({
	            	checkboxes: {
	                    checkChildren: checkChildren
	                },
                    dataSource: inline,
                    select: onSelect,
                    dataTextField: ["name"],
                    dataValueField: ["seq", "gbn"]
                }); 
	            
	            function onSelect(e) {
	            	var item = e.sender.dataItem(e.node);
	               	
	               	callbackOrgChart(item);	// 반드시 구현
	            }
	            
	            
	            
            </script>




