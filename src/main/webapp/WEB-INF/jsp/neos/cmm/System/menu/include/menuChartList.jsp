<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<!-- <div class="treeCon" > -->
<!-- <div id="treeview" class="tree_icon tree_auto"></div> -->
<!-- </div>	 -->
<div id="treeview" class="tree_icon tree_auto" style="height:522px;"></div>
<script>

            //기본버튼
        	var inline = new kendo.data.HierarchicalDataSource({
                data: [${menuChartList}],
                schema: {
                    model: { 
                    	id: "seq",
                        children: "items"
                    }     
                }   
            }); 
            
            var treeview = $("#treeview").kendoTreeView({
            	autoBind: true,
//             	checkboxes: {
//                     checkChildren: false
//                 },
                dataSource: inline,
                select: onSelect, 
                dataTextField: ["name"],
                dataValueField: ["seq", "gbn"],
//                 dragAndDrop: true,
                messages: {
                    retry: "Wiederholen",
                    requestFailed: "Anforderung fehlgeschlagen.",
                    loading: "Laden..."
                  }
            }).data("kendoTreeView"); 

	            
            </script>


<input type="hidden" id="chkValue" name="chkValue" value="">


