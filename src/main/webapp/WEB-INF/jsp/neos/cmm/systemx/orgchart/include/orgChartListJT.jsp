<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jsTree/style.min.css' />" />
<style>
	li.jstree-open > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("/gw/css/jsTree/ico_folder_open01.png") 0px 0px no-repeat !important; }
	li.jstree-closed > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("/gw/css/jsTree/ico_folder_fold01.png") 0px 0px no-repeat !important; }
	li.jstree-leaf > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("/gw/css/jsTree/ico_folder_fold01.png") 0px 0px no-repeat !important; }

	#orgTreeView .jstree-container-ul > .jstree-node { background:transparent; }
	#orgTreeView .jstree-container-ul > .jstree-node > .jstree-ocl { background:transparent; }	
	#orgTreeView .jstree-container-ul > .jstree-open > .jstree-ocl { background-position:-36px -4px; }
	#orgTreeView .jstree-container-ul > .jstree-closed> .jstree-ocl { background-position:-4px -4px; }
	#orgTreeView .jstree-container-ul > .jstree-leaf> .jstree-ocl { background:transparent; }
</style>
<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>

            <div id="orgTreeView"></div>

            <script>
	            
	            function onSelect(e) {
	            	var item = e.node;
	            	
	               	callbackOrgChart(item);	// 반드시 구현
	            }
	            
	            $('#orgTreeView').jstree({ 
	            	'core' : { 
	            		'data' : {
		            		'url' : '<c:url value="/cmm/systemx/orgChartListJT.do" />',
		            		'cache' : false,
		            		'dataType': 'JSON',
 		        			'data' : function (node) { 
 		        				return {'parentSeq' : (node.id == "#" ? 0 : node.id)}
 		        			}
	            		},
	            		'animation' : false 
	            	}
	            })
	            .bind("loaded.jstree", function (event, data) {
					//console.log("loaded.jstree");
	            	// load후 처리될 event를 적어줍니다.
	            	fnMyDeptInfo();
				})
				.bind("select_node.jstree", function (event, data) {
					//console.log("select_node.jstree");
					onSelect(data);
					// node가 select될때 처리될 event를 적어줍니다.​
				});
				/*.bind("open_node.jstree", function (event, data) {
					console.log("open_node.jstree");
					// node가 open 될때 처리될 event를 적어줍니다.​
				})
				.bind("dblclick.jstree", function (event) {
					console.log("dblclick.jstree");
					// node가 더블클릭 될때 처리될 event를 적어줍니다.​​
				});*/
				
            </script>
