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
	var boardId = "";
	var boardNm = "";
	var boardFlag = false;


	$(document).ready(function(){
		setMenuDepthList('500000000','501000000','edms');
		
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
	
	function fnTest(no) {
		
		$("#sub_nav_jstree").empty();	

		$.ajax({
			type:"post",
			url: _g_contextPath_ + "/cmm/system/getMenu2Depth.do",
			data:{startWith : no}, 
			datatype:"json",			 
			success:function(data){	
				
				var userSe = data.userSe;
				var items = "";	
				var menuNo = [];
				var menuType = "";
				var seq = 0;
				
				if (data.depth2Menu) {
					
					$.each(data.depth2Menu,function (index,val){
						if(val.menuNo == "501000000"){
							items += "<div class='sub_2dep' id='"+index+'dep'+"'><span  class='"+val.expendClass+"'>"+val.name+"</span></div>";				
							items += "<div id='"+val.menuNo+"'class='sub_2dep_in'></div>";
							menuNo[index] = val.menuNo ;
						}
					});													
					$("#sub_nav_jstree").html(items);	
					//각각 							
					for(var i = 0 ; i < menuNo.length; i++) {
						if(menuNo[i] == "501000000") {
							menuType = "edms";
							setMenuDepthList(no,menuNo[i],menuType);
						}						
					}
				}
			} 
		});
	}
	
	
	function setMenuDepthList(rootMenuNo,upperMenuNo,menuType) {	
		$('#'+upperMenuNo).jstree({
			'core' : {
				  'data' : {
				   'url' :  _g_contextPath_ + '/cmm/system/getJsTreeList.do',
			   	   'cache' : false,
				   'dataType': 'JSON',
				   'check_callback' : true,
				   'data' : function (node) {
					  //alert(JSON.stringify(node));
					  menu.docParameters.dirRootNode = null;
				      return {'upperMenuNo' : (node.id == "#" ? upperMenuNo : node.id ) 
				    	  ,'level' : (node.id == "#" ? "1" : node.original.level )  
				    	  ,'firstDepthMenuNo' : rootMenuNo , 'menuType' :  menuType 
				    	  ,'dir_group_no' : (menu.docParameters.dirGroupNo == null ? 0 : menu.docParameters.dirGroupNo)/*뷴류선택  카테고리 그룹No 업무분류(0) 카테고리(그룹번*/
				    	  ,'dir_type' :( menu.docParameters.dirType == null ? "W" : menu.docParameters.dirType)/*뷴류선택 카테고리 Type 업무뷴류(W) 카테고리(C)*/
				    	  ,'dir_rootNode' : (menu.docParameters.dirRootNode == null ? "root" : menu.docParameters.dirRootNode)
				    	  ,'scheduleSeq' : (node.id == "#" ? "0" : node.original.scheduleSeq)/*Root 폴더를 만들기 위해 필요한 파라미터*/
				    	  ,'target' : "portletBoardSetPop"}
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
				})
				.bind("select_node.jstree", function(event, data) {
					fnSelectBoard(data);
				})
				.on('click', '.jstree-anchor', function (e) {
				    $(this).jstree(true).toggle_node(e.target);			
				  })
				.bind("ready.jstree", function(event, data){		
					$('#501000000').jstree("open_all");
				});	
		}

	
	function fnSelectBoard(data){
		if(data.node.original.urlPath != "") {
			boardFlag = true;
		} else {
			boardFlag = false;
		}
		boardId = "";
		if(data.node.children.length == 0){
			boardId = data.node.original.urlPath.split("=")[1];
			//boardId = data.selected[0].replace("50100","");
			//boardId = parseInt(data.selected[0]) - parseInt("501000000");
		}
		boardNm = data.node.text;
	}
	
	function ok(){
		if(boardFlag) {			
			$.ajax({
				type:"post",
				url: _g_contextPath_ + "/cmm/systemx/portal/checkBoardId.do",
				data:{boardId : boardId}, 
				datatype:"json",			 
				success:function(data){	
					var catType = data.catType
					if(catType == "B" || catType == "S"){
						alert("<%=BizboxAMessage.getMessage("TX900000493","해당 게시판으로 설정 할 수 없습니다.\\n[선택 불가 게시판유형 : 블로그형, 메모]")%>");
						return;
					}			
					opener.boardTreeCallBack(boardId, boardNm);
					self.close();	
				} 
			});	
		} else {
			alert("<%=BizboxAMessage.getMessage("TX900000494","게시함은 선택할 수 없습니다.")%>");
			return;
		}
		
	}
	
	
</script>

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("","게시판 선택")%></h1>
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
		<div id="501000000" style="overflow-y:auto;height:450px;"></div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok()"/> 
				<input id="sam" type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript: self.close();"/>
			</div>
		</div>
	</div>