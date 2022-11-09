<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/jsTree/style.min.css' />" />
	<script type="text/javascript"
	src="<c:url value='/js/jsTree/jstree.min.js' />"></script>

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

	
<script src="/gw/js/neos/systemx/systemx.menu.js?ver=20201021"></script>
	
<script>
	var dir_cd = "";
	var doc_nm = "";
	var docFlag = false;
	var dir_type = "";
	var dir_lvl = "";
	

	$(document).ready(function(){
		setMenuDepthList('600000000','601000000','portletDocumentSetPop');
		$('#search-term').keyup(function(){
			var searchTxt = $("#search-term").val();
			$(".jstree-anchor").each(function(){
				$(this).removeClass("text_blue");
			});
			if(searchTxt != ""){
				$(".jstree-anchor").each(function(){
					if($(this).text().indexOf(searchTxt) != -1){
						$(this).addClass("text_blue");
					}				
				});
			}
		});

	});	
	
	function setMenuDepthList(rootMenuNo,upperMenuNo,menuType) {
		$('#'+upperMenuNo).jstree({
			'core' : {
				  'data' : {
				   'url' :  _g_contextPath_ + '/cmm/system/getJsTreeList.do',
			   	   'cache' : false,
				   'dataType': 'JSON',
				   'check_callback' : true,
				   'data' : function (node) {
					  menu.docParameters.dirRootNode = null;
					  if(menu.docParameters.dirRootNode != 'undefined' || menu.docParameters.dirRootNode != null){
						   // 카테고리 분류 Root노드가 아닐경우 
						   menu.docParameters.dirRootNode = 'childeNodes';
					   }
				      return {'upperMenuNo' : (node.id == "#" ? upperMenuNo : node.id ) 
				    	  ,'level' : (node.id == "#" ? "1" : node.original.level )  
				    	  ,'firstDepthMenuNo' : rootMenuNo , 'menuType' :  menuType 
				    	  ,'dir_group_no' : (menu.docParameters.dirGroupNo == null ? 0 : menu.docParameters.dirGroupNo)/*뷴류선택  카테고리 그룹No 업무분류(0) 카테고리(그룹번*/
				    	  ,'dir_type' :( menu.docParameters.dirType == null ? "W" : menu.docParameters.dirType)/*뷴류선택 카테고리 Type 업무뷴류(W) 카테고리(C)*/
				    	  ,'dir_rootNode' : (menu.docParameters.dirRootNode == null ? "root" : menu.docParameters.dirRootNode)
				    	  ,'scheduleSeq' : (node.id == "#" ? "0" : node.original.scheduleSeq)/*Root 폴더를 만들기 위해 필요한 파라미터*/
				    	  ,'target' : "portletDocSetPop"}
				   },
				   'multiple':false
				  }
				},
				"search": {
					 "case_insensitive": true,
					 "show_only_matches" : true
					},
				"checkbox": {
					"keep_selected_style" : true
					},
				plugins: ["search"]})
				.bind("loaded.jstree", function(event, data) {
					//모두 펼치기
					$("#"+upperMenuNo).jstree("open_all");	
				})
				.bind("select_node.jstree", function(event, data) {
					fnSelectDoc(data);
				})
				.on('click', '.jstree-anchor', function (e) {
				    $(this).jstree(true).toggle_node(e.target);			
				  })
			/*
				.bind("ready.jstree", function(event, data){		
					$('#501000000').jstree("open_all");
				});	
			*/
	}

	
	function fnSelectDoc(data){
		if(data.node.original.urlPath != "") {
			docFlag = true;
		} else {
			docFlag = false;
		}
		if(data.node.children.length == 0){
			var urlPath = data.node.original.urlPath;
			var dir_lvl_reg = /dir_lvl=(\d+)/.exec(urlPath);
			var dir_type_reg = /dir_type=([A-Z])/.exec(urlPath);
			
			dir_cd = data.node.original.id;
			dir_lvl = dir_lvl_reg[1];
			dir_type = dir_type_reg[1];
		}
		doc_nm = data.node.text;
	}
	
	function ok(){
		if(docFlag) {	
			opener.docTreeCallBack(dir_cd, dir_lvl, dir_type, doc_nm);
			self.close();
		} else {
			alert("<%=BizboxAMessage.getMessage("TX900000000","문서함을 선택할 수 없습니다.")%>");
			return;
		}
		
	}
	
	
</script>

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000020956","문서함 선택")%></h1>
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
		<div id="601000000" style="overflow-y:auto;height:450px;"></div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok()"/> 
				<input id="sam" type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript: self.close();"/>
			</div>
		</div>
	</div>