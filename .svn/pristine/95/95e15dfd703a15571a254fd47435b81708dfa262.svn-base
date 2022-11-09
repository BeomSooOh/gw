<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

            <div id="orgTreeView"></div>


            <script>
	            var inline = new kendo.data.HierarchicalDataSource({
	                data: [${orgChartList}],
	                schema: {
                        model: {
                            children: "nodes"
                        } 
                    }
	            });
	
	            $("#orgTreeView").kendoTreeView({
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
