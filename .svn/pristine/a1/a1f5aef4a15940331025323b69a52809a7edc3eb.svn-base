<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

	<div id="example">

            <div class="demo-section k-header">
				<div>
						조직도
				</div>             
                <div id="treeview" class="treecontents"></div>
            </div>

            <script>
	            var inline = new kendo.data.HierarchicalDataSource({
	                data: [${orgChartList}],
	                schema: {
                        model: {
                            children: "nodes"
                        }
                    },
	            });
	
	            $("#treeview").kendoTreeView({
                    dataSource: inline,
                    height: 500,
                    select: onSelect,
        	        checkboxes: {
                        checkChildren: true,  // 상위항목 체크 시 하위항목 모두 선책
                        template: checkboxTemplate
                    },            
                    check: onCheck,                      
                    dataTextField: ["name"],
                    dataValueField: ["seq", "gbn"],
                    dataBound: function(e) {
                    	var item = e.sender.dataItem(e.node);
//                         var seq = item.seq;
//                         var gbnOrg = item.gbn;
                     	
                     	if(item != null){
                     		setChecked(e);
                     		console.log("DataBound", item.name +  " : " + item.gbn);	
                     	}
                    	
                      }
                });

	            function checkboxTemplate(e) {
	            	var id = e.item.seq + "_" +e.item.gbn;
	            	  if(e.item.checked == 'true') {
	            	    return "<input type='checkbox' name='treeCheck' checked='checked' value='"+e.item.seq+"'/>";
	            	  } 
	            	  else {
	            	    return "<input type='checkbox' name='treeCheck'  value='"+e.item.seq+"'/>";
	            	  }
	            }	            
	            
	            
	            function onSelect(e) {
	            	var item = e.sender.dataItem(e.node);
	               	var seq = item.seq;
	               	var gbnOrg = item.gbn;
	               	console.log("DataBound", seq +  " : " + gbnOrg);
	               	//callbackOrgChart(seq, gbnOrg);	// 반드시 구현
	            }

	            // show checked node IDs on datasource change
	            
	            function onCheck() {
	            	var treeView = $("#treeview").data("kendoTreeView"), message;
	            	var checkedNodes = [], checkedNodesNm = [], checkedNodesGbn = [];

	                checkedNodeIds(treeView.dataSource.view(), checkedNodes, checkedNodesNm, checkedNodesGbn);
	                
	                $("#chkValue").val(checkedNodes.join(","));
	                $("#chkNm").val(checkedNodesNm.join(","));
	                $("#chkGbn").val(checkedNodesGbn.join(",")); 

	                //callbackOrgChart(seq, gbnOrg); //
	            }	

	            // function that gathers IDs of checked nodes
	            function checkedNodeIds(nodes, checkedNodes, checkedNodesNm, checkedNodesGbn) {
	                for (var i = 0; i < nodes.length; i++) {
	                    if (nodes[i].checked) {
	                        checkedNodes.push(nodes[i].seq);
	                        checkedNodesNm.push(nodes[i].name);
	                        checkedNodesGbn.push(nodes[i].gbn);
	                    }

	                    if (nodes[i].hasChildren) {
	                        checkedNodeIds(nodes[i].children.view(), checkedNodes, checkedNodesNm, checkedNodesGbn);
	                    }
	                }
	            }	             	    		
	    		
	            // 선택된 체크박스 value 값 리턴 ( a01,a02,a03... )
	            function getCheckedValue(){
		       		var arrCheckedValue = checkBoxSelectedValue(document.getElementsByName("treeCheck"));

		           	var rowNum = arrCheckedValue.length;
		     
		    		var chkValue = "";
		     	    for(var inx = 0 ; inx < rowNum; inx++) {
		     	    	if(inx == 0 )
		     	    		chkValue =arrCheckedValue[inx] ;
		     	    	else 
		     	    		chkValue = chkValue+","+arrCheckedValue[inx] ; 	    	
		     	    }	
		     	    return chkValue;
	            }
	            
            </script>

            <style>
                #example {
                    text-align: left;
                } 

                .demo-section {
                    display: inline-block;
                    vertical-align: top;
                    width: 300px;
                    text-align: left;
                    margin: 0 2em;
                }

                .treecontents {
                    width: 300px;
                    height:500px;
                    text-align: left;
                    margin: 0 2em;
                }                
            </style>
        </div>

<input type="hidden" id="chkValue" name="chkValue" value="">
<input type="hidden" id="chkNm" name="chkNm" value="">
<input type="hidden" id="chkGbn" name="chkGbn" value="">



