<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/jsTree/style.min.css' />" />



<style>
	html {overflow:hidden;} 
li.jstree-open > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ03_open.png") 0px -1px no-repeat !important; }
li.jstree-closed > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ03_close.png") 0px -1px no-repeat !important; }
li.jstree-leaf > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ03_close.png") 0px -1px no-repeat !important; }

li.col_brown.jstree-open > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ04_open.png") 0px -1px no-repeat !important; }
li.col_brown.jstree-closed > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ04_close.png") 0px -1px no-repeat !important; }
li.col_brown.jstree-leaf > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ04_close.png") 0px -1px no-repeat !important; }

li.col_green.jstree-open > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ05_open.png") 0px -1px no-repeat !important; }
li.col_green.jstree-closed > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ05_close.png") 0px -1px no-repeat !important; }
li.col_green.jstree-leaf > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ05_close.png") 0px -1px no-repeat !important; }

li.col_disabled.jstree-open > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ06_open.png") 0px -1px no-repeat !important; }
li.col_disabled.jstree-closed > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ06_close.png") 0px -1px no-repeat !important; }
li.col_disabled.jstree-leaf > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ06_close.png") 0px -1px no-repeat !important; }
li.col_disabled .jstree-anchor {color:#8d8d8d;}

li.comp_li > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ01.png") 0px -1px no-repeat !important; }
li.busi_li > a .jstree-icon.jstree-themeicon { margin-left: 5px; margin-top: 5px; margin-right: -3px; background:url("../../Images/ico/ico_organ02.png") 0px -1px no-repeat !important; }

#orgTreeView .jstree-container-ul>.jstree-node {
	background: transparent;
}

#orgTreeView .jstree-container-ul>.jstree-node>.jstree-ocl {
	background: transparent;
}

#orgTreeView .jstree-container-ul>.jstree-open>.jstree-ocl {
	background-position: -36px -4px;
}

#orgTreeView .jstree-container-ul>.jstree-closed>.jstree-ocl {
	background-position: -4px -4px;
}

#orgTreeView .jstree-container-ul>.jstree-leaf>.jstree-ocl {
	background: transparent;
}
</style>

<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>

<script id="treeview-template" type="text/kendo-ui-template">
	#: item.name #
</script>

<script>
var batchSeq = "${batchSeq}";
var batchBizSeq = "${batchBizSeq}";


//조직도 트리 생성
	$(document).ready(function(){
		deptManageTreeInit();		
	});

	function setLiAttr(n){
		for(var i=0;i<n.children.length;i++){
			setLiAttr(n.children[i]);	
		}
		n.li_attr['class'] = n.tIcon;
		return;
	}

	function setDeptBatch(target, target2){
		var arrDeptBatchList = target.split("|");
		var arrDeptBatchBizLisy = target2.split("|");
		
		for(var i=0;i<arrDeptBatchList.length;i++){
			$("#" + arrDeptBatchBizLisy[i] + arrDeptBatchList[i] + " >a").css("color","blue");
			$("#" + arrDeptBatchBizLisy[i] + arrDeptBatchList[i] + " >a").css("font-weight","bold");
		}
	}
	function deptManageTreeInit() {
	    $('#orgTreeView').jstree({ 
	    	'core' : { 
	    		'data' : {
	        		'url' : '<c:url value="/cmm/systemx/deptManageOrgChartListJT.do" />',
	        		'cache' : false,
	        		'dataType': 'JSON',
	        			'data' : function (node) { 
	        				return {'parentSeq' : (node.id == "#" ? 0 : node.id), 'compSeq' : '${targetCompSeq}', 'searchDept' : '', 'deptSeq' : '', 'includeDeptCode' : true, 'retKey' : '${retKey}'};	        				
	        			},
	        			'success' : function (n) {
	        				setLiAttr(n[0]);
	        				setDeptBatch(batchSeq, batchBizSeq);
	        			    return n;
	        			}
	    		},
	    		'animation' : false 
	    	}
	    })
	    .bind("loaded.jstree", function (event, data) {
	    	$(this).jstree("open_all");
	    	setDeptBatch(batchSeq, batchBizSeq);
		})
		.bind("select_node.jstree", function (event, data) {
			setDeptBatch(batchSeq, batchBizSeq);
		});

	    $("#orgTreeView").bind("open_node.jstree", function (event, data) { 
    		setDeptBatch(batchSeq, batchBizSeq);
    	}); 
	}
	
	/* [노드 아이디 반환] 노드 아이디 보정하여 반환
	---------------------------------------------------------*/
	function OJT_fnGetCompensId(id){
		return id.substring(1);
	}
	
	
	function fnSetScrollToNode(nodeId) {
		var jstree = document.getElementById('orgTreeView');
		var toY = getPosition(document.getElementById("d"+nodeId)).y;
		var offset = jstree.offsetHeight / 2;
		var topV = toY - offset;
		
		$(".jstreeSet").animate({
			scrollTop : (toY/2)
		}, 200); // 이동
	}

</script>

<script type="text/javascript"
	src="<c:url value='/js/jsTree/jstree.min.js' />"></script>

<body class="">
	<div class="pop_wrap" style="width:400px;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000006199","조직도 미리보기")%></h1>
			<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
		</div><!-- //pop_head -->
		
		<div class="pop_con">			
			<h2><%=BizboxAMessage.getMessage("TX000016272","반영된 조직도")%></h2>		

			<!-- 트리영역 -->
			<div id="" class="Pop_border scroll_on mt10" style="height:400px;">
				<div id="orgTreeView" class="tree_icon" style="height:389px;"></div>
			</div>
		</div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button"  class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002972","닫기")%>" onclick="javascript:window.close();"/>
			</div>
		</div> 
		<!-- //pop_foot -->
	</div><!-- //pop_wrap -->
</body>