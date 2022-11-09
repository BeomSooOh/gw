<!-- 사용자 조직도 구현 -->
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="main.web.BizboxAMessage"%>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/jsTree/style.min.css' />" />

<!-- 프로토 타입 정의용 스크립트 -->
<script type="text/javascript">
	/* [Map] declare javascipt hashmap prototype
	========================================*/
	Map = function() {
		this.map = new Object();
	};
	Map.prototype = {
		put : function(key, value) {
			this.map[key] = value;
		},
		get : function(key) {
			return this.map[key];
		},
		containsKey : function(key) {
			return key in this.map;
		},
		containsValue : function(value) {
			for ( var prop in this.map) {
				if (this.map[prop] == value)
					return true;
			}
			return false;
		},
		isEmpty : function(key) {
			return (this.size() == 0);
		},
		clear : function() {
			for ( var prop in this.map) {
				delete this.map[prop];
			}
		},
		remove : function(key) {
			delete this.map[key];
		},
		keys : function() {
			var keys = new Array();
			for ( var prop in this.map) {
				keys.push(prop);
			}
			return keys;
		},
		values : function() {
			var values = new Array();
			for ( var prop in this.map) {
				values.push(this.map[prop]);
			}
			return values;
		},
		size : function() {
			var count = 0;
			for ( var prop in this.map) {
				count++;
			}
			return count;
		}
	};
</script>

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

<script type="text/javascript"
	src="<c:url value='/js/jsTree/jstree.min.js' />"></script>


<!-- 기본 회사 조직도 트리 -->
<div class="box_left orgTreeView" style="width: 270px;"
	id="div_org_tree_">
	<div class="p0">
		<div class="jstreeSet" style="height: 495px;">
			<div id="orgTreeView_"></div>
		</div>
	</div>
</div>

<!-- 회사 조직도 선택 트리 -->
<div class="fl mt10 orgTreeView" style="width: 315px;"
	id="div_org_tree_oc">
	<div class="box_div p0">
		<div class="jstreeSet" style="height: 390px;">
			<div id="orgTreeView_oc"></div>
		</div>
	</div>
</div>

<input type="hidden" id="hid_node_temp_value">
<input type="hidden" id="hid_od_dept_value">
<input type="hidden" id="hid_oc_comp_value">




<script type="text/javascript">
	/* [트리 작성 준비] 트리 작성 페이지 준비
	---------------------------------------------------------*/
	function OJT_documentReady(param) {
		
		console.log('OJT_documentReady(param) / 공통 조직도 사용 호출.  param : ' + JSON.stringify(param));
		
		$('.orgTreeView').hide()
		if (param.selectMode === 'oc') {
			// 회사 조직도 선택 트리 출력
			$('#div_org_tree_oc').show();
			OJT_fnSetOrgTreeOc(param);
		} else {
			// 공통 조직도 선택 트리 출력
			$('#div_org_tree_').show();
			paramSet = param;
			OJT_fnSetOrgTree(paramSet);
		}
	}
	
	/* [트리 사이즈] 트리 사이즈 변경 - 가로
	---------------------------------------------------------*/
	function OJT_fnSetTreeWidth(width) {
		console.log('OJT_fnSetTreeWidth(width) / 트리 사이즈 변경.  width : ' + width);
		
		width = width.replace('px','');
		var px = width + 'px';
		
		$('.orgTreeView').width(width);
	}
	/* [트리 사이즈] 트리 사이즈 변경 - 세로
	---------------------------------------------------------*/
	function OJT_fnSetTreeHeight(height) {
		console.log('OJT_fnSetTreeHeight(height) / 트리 사이즈 변경.  height : ' + height);
		
		height = height.replace('px','');
		var px = height + 'px';
		
		$('.jstreeSet').height(height);
	}
	
	
	/* [트리 검색] 대상 노드 탐색, 하이라이팅
	 * node select event firing.
	 * isClose : 기존의 열려있던 노드 닫기 여부 [true / false]
	 * nodePath : node의 경로 [6|72|101] * 구분은 파이프 라인
	---------------------------------------------------------*/
	function OJT_fnSearchNode(isClose, nodePath) {
		 console.log('OJT_fnSearchNode(isClose, nodePath) / 대상 노드 탐색.  nodePath : ' + nodePath);
		 
		if (isClose) {
			$('#orgTreeView_').jstree("close_all");
		}

		nodePath += '';
		var l = nodePath.split("|");
		
		
		$('#orgTreeView_').jstree("deselect_all");
		for (var i = 0; i < l.length; i++) {
			var orgGbn = 'c';
			if(i == 0){
				// 노드가 회사인 경우.
				orgGbn = 'c';
			}else{
				// 노드가 부서인 경우
				orgGbn = 'd';
			}
			$('#orgTreeView_').jstree("open_node", $("#"+ orgGbn + l[i]));
			
			if (i === (l.length - 1)) {

				$('#orgTreeView_').jstree("select_node", $("#"+orgGbn + l[i]));
				$('#orgTreeView_oc').jstree("select_node", $("#" + l[i]));

				/* 스크롤링 */
				fnSetScrollToNode(orgGbn+l[i]);
			}
		}
	}
	 
	/* [노드 반환] 선택된 노드로 스크롤 이동  
	---------------------------------------------------------*/
	function fnSetScrollToNode(nodeId) {
		console.log('fnSetScrollToNode(nodeId) / 스크롤 이동.  nodeId : ' + nodeId);
		
		
		var jstree = document.getElementById('orgTreeView_');
		var toY = getPosition(document.getElementById(nodeId)).y;
		var offset = jstree.offsetHeight / 2;
		var topV = toY - offset;
		
		// alert('y : ' +  toY + '\nx : ' + offset + '\ntopV : ' + topV );
		
		$(".jstreeSet").animate({
			scrollTop : (toY/2)
		}, 200); // 이동
	}

	/* [노드 반환] 선택된 노드 포지션 반환
	---------------------------------------------------------*/
	function getPosition(element) {
		var xPosition = 0;
		var yPosition = 0;

		while (element) {
			xPosition += (element.offsetLeft - element.scrollLeft + element.clientLeft);
			yPosition += (element.offsetTop - element.scrollTop + element.clientTop);
			element = element.offsetParent;
		}
		return {
			x : xPosition,
			y : yPosition
		};
	}
	
	
	/* [노드 아이디 반환] 노드 아이디 보정하여 반환
	---------------------------------------------------------*/
	function OJT_fnGetCompensId(id){
		return id.substring(1);
	}
	

	/* [노드 반환] 선택된 노드 정보 반환
	---------------------------------------------------------*/
	function OJT_fnGetNodeId() {
		return $('#hid_node_temp_value').val() || '';
	}


	/* [노드 반환] 선택된 노드 정보 반환 [od / oc]
	---------------------------------------------------------*/
	function OJT_fnReturnNodeInfo(defaultInfo) {
		if (defaultInfo.selectMode === 'oc') {
			return JSON.parse($('#hid_oc_comp_value').val());
		} else if (defaultInfo.selectMode === 'od') {
			
			if(JSON.parse($('#hid_od_dept_value').val())[0].empDeptGb === 'c'&& defaultInfo.noUseCompSelect){
				return 'c';
			}	else{
				return JSON.parse($('#hid_od_dept_value').val());	
			}		
		}
		return null;
	}

	
	
	
	/* [트리 작성] 부서 선택 트리 작성
	---------------------------------------------------------*/
	var orgJsSelectedNode = '';
	function OJT_fnSetOrgTree(defaultInfo) {
		
		var paramStr = '?compFilter=' + (defaultInfo.compFilter || '');
		paramStr += '&langCode=' + (defaultInfo.langCode || '');
		paramStr += '&groupSeq=' + (defaultInfo.groupSeq || '');
		paramStr += '&compSeq=' + (defaultInfo.compSeq || '');
		paramStr += '&deptSeq=' + (defaultInfo.deptSeq || '');
		paramStr += '&empSeq=' + (defaultInfo.empSeq || '');
		paramStr += '&includeDeptCode=' + (defaultInfo.includeDeptCode || '');	
		paramStr += '&bizTree=true';

		console.log('OJT_fnSetOrgTree(defaultInfo) / 트리 정보 조회.  parameter : ' + JSON.stringify(paramStr));
		
		$('#orgTreeView_')
				.jstree(
						{
							'core' : {
								'data' : {
									'url' : '<c:url value="/cmm/systemx/orgChartFullListView.do" />'
											+ paramStr,
									'cache' : false,
									'dataType' : 'JSON',
								},
								'animation' : false
							}
						})
				.on(
						'select_node.jstree',
						function(e, data) {
							// 하위 사원 전체보기 시 compSeq 찾기
							var parents = [];
							var parents = data.node.parents;
							var rootCompId = "";
							
							if(parents[0] != "#") {
								rootCompId = parents[parents.length - 2].substring(1, parents[parents.length - 2].length);
							} else {
								rootCompId = data.selected[0].substring(1,data.selected[0].length);
							}
							
							defaultInfo.rootCompId = rootCompId;
							
							var i, j, r = [], item, paramSet = {};
							for (i = 0, j = data.selected.length; i < j; i++) {
								item = data.instance.get_node(data.selected[i]);
							}

							console.log('node_click');
							
							// 노드 정보 임시저장
							$('#hid_node_temp_value').val(OJT_fnGetCompensId(item.id));
							
							var SelectItemGb = item.id.substring(0,1);
							$('#hid_od_dept_value').val(JSON.stringify([ {
								selectedId : OJT_fnGetCompensId(item.id),
								deptName : item.text,
								empDeptGb : SelectItemGb
							} ]));
							
							if((item.id.substring(0,1) == 'b') && (OJT_fnGetCompensId(item.parent) == OJT_fnGetCompensId(item.id))) {
								defaultInfo.baseBiz = "Y";
							} else {
								defaultInfo.baseBiz = "N";
							}

							defaultInfo.selectedId = OJT_fnGetCompensId(item.id);
							defaultInfo.orgGubun = item.id.substring(0,1);
							
							if (defaultInfo.nodeChageEvent || (typeof (window[defaultInfo.nodeChageEvent]) === 'function')) {
								window[defaultInfo.nodeChageEvent](defaultInfo);
							}
						})
				.bind(
						"loaded.jstree",
						function(event, data) {
							// 노드 정보 임시 저장
							var id = $("#orgTreeView_").jstree("get_selected")[0]
									|| '';
							var nodeText = $('#' + id).text() || '';
							
							$('#hid_node_temp_value').val(OJT_fnGetCompensId(id));
							$('#hid_od_dept_value').val(JSON.stringify([ {
								selectedId : OJT_fnGetCompensId(id),
								deptName : nodeText
							} ]));

							
							/* 노드 스크롤링 */
							fnSetScrollToNode(id);
							
							//alert('initMode : ' + defaultInfo.initMode);
							
							defaultInfo.selectedId = OJT_fnGetCompensId(id);
							defaultInfo.orgGubun = "d";
							if(!defaultInfo.initMode){  // 관리자, 마스터일 경우 본인부서선택 안되어 추가함.
								if (defaultInfo.nodeChageEvent || (typeof (window[defaultInfo.nodeChageEvent]) === 'function')) {
									
									if(!defaultInfo.noUseDefaultNodeInfo){
										window[defaultInfo.nodeChageEvent](defaultInfo);	
									}
								}
							}else{   // 관리자, 마스터일 경우 본인부서선택 안되어 추가함. 
								$('#orgTreeView_').jstree("open_all");
							}
							
							if(!defaultInfo.noUseExtendArea) {
								if(defaultInfo.isDuplicate && (defaultInfo.extendSelectAreaCount  == "1")) {
									$('.tb_selected_item_list:visible > tbody > tr').each(function(){
										var id = $(this).attr("id");
										var selectedId = id.replace($(this).attr("id").split("_")[0], "l");
										
										$("#" + selectedId).hide();
									});
								} else if(defaultInfo.isDuplicate && (defaultInfo.extendSelectAreaCount  == "2")) {
									$('.tb_selected_item_list:visible > tbody > tr').each(function(){
										var id = $(this).attr("id");
										var selectedId = id.replace($(this).attr("id").split("_")[0], "l");
										
										$("#" + selectedId).hide();
									});
									
									$('.tb_selected_item_list1:visible > tbody > tr').each(function(){
										var id = $(this).attr("id");
										var selectedId = id.replace($(this).attr("id").split("_")[0], "l");
										
										$("#" + selectedId).hide();
									});
								} else if(defaultInfo.isDuplicate && (defaultInfo.extendSelectAreaCount  == "3")) {
									$('.tb_selected_item_list:visible > tbody > tr').each(function(){
										var id = $(this).attr("id");
										var selectedId = id.replace($(this).attr("id").split("_")[0], "l");
										
										$("#" + selectedId).hide();
									});
									
									$('.tb_selected_item_list1:visible > tbody > tr').each(function(){
										var id = $(this).attr("id");
										var selectedId = id.replace($(this).attr("id").split("_")[0], "l");
										
										$("#" + selectedId).hide();
									});
									
									$('.tb_selected_item_list2:visible > tbody > tr').each(function(){
										var id = $(this).attr("id");
										var selectedId = id.replace($(this).attr("id").split("_")[0], "l");
										
										$("#" + selectedId).hide();
									});
								}
							}
						});
	}

	/* [트리 작성] 회사 조직도 선택 트리 생성[oc]
	---------------------------------------------------------*/
	function OJT_fnSetOrgTreeOc(defaultInfo) {
		// defaultInfo.selectedItems;
		var paramStr = '?compFilter=' + defaultInfo.compFilter || '';
		paramStr += '&langCode=' + defaultInfo.langCode || '';
		paramStr += '&groupSeq=' + defaultInfo.groupSeq || '';
		paramStr += '&deptSeq=' + defaultInfo.deptSeq || '';
		$('#orgTreeView_oc')
				.jstree(
						{
							'core' : {
								'data' : {
									'url' : '<c:url value="/cmm/systemx/orgChartListJsTreeViewOc.do" />'+ paramStr,
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
							"plugins" : [ "checkbox" ]
						}).on(
						'select_node.jstree',
						function(e, data) {
							var selectedElms = $('#orgTreeView_oc').jstree(
									"get_checked", true);
							var temp = [];

							var length = selectedElms.length;
							for (var i = 0; i < length; i++) {
								var item = selectedElms[i];
								if (item.id != 'root') {
									temp.push({
										selectedId : item.id,
										compName : item.text
									});
								}
							}
							$('#hid_oc_comp_value').val(JSON.stringify(temp));
						}).bind(
								"loaded.jstree",
								function (event, data) {
									$('#orgTreeView_oc').jstree('open_all');
									var selectedElms = $('#orgTreeView_oc').jstree(
											"get_checked", true);
									
									
									var temp = [];

									var length = selectedElms.length;
									for (var i = 0; i < length; i++) {
										var item = selectedElms[i];
										if (item.id != 'root') {
											temp.push({
												selectedId: item.id,
												compName: item.text
											});
										}
									}

									var l = [];
									l = defaultInfo.selectedItems.split(',');
									length = l.length;
									for (var i = 0; i < length; i++) {
										var item =  selectedItems[i];
										$('#orgTreeView_oc').jstree("select_node", $("#" + l[i]));
										
									}


									$('#hid_oc_comp_value').val(JSON.stringify(temp));
								}).bind("deselect_node.jstree", function(evt, data) {
									var selectedElms = $('#orgTreeView_oc').jstree(
											"get_checked", true);
									var temp = [];

									var length = selectedElms.length;
									
									for (var i = 0; i < length; i++) {
										var item = selectedElms[i];
										if (item != 'root') {
											temp.push({
												selectedId : item.id,
												compName : item.text
											});
										}
									}
									$('#hid_oc_comp_value').val(JSON.stringify(temp));
						        });;
	}

	/* [아이템 검색] 트리노드 내에 속하는 아이템 검색
	 * selectMode = [u,d,udu,udd] , 사용자 검색,부서 검색, 사용자부서 검색중 사용자 이름으로 검색, 사용자와 부서 검색중 부서이름 검색
	 * text = user input
	---------------------------------------------------------*/
	var filterdData = new Map();
	function OJT_fnSearchItem(defaultInfo, selectMode, text) {
		var param = {};
		param.filter = text;
		param.selectMode = selectMode;
		param.compFilter = defaultInfo.compFilter;
		param.langCode = defaultInfo.langCode;
		param.groupSeq = defaultInfo.groupSeq;
		
		var key = param.selectMode + '|' + param.filter;

		filterdData.containsKey(key)
				|| $
						.ajax({
							async : false,
							type : "post",
							url : '<c:url value="/cmm/systemx/GetFilterdBizProfileListForBiz.do" />',
							dataType : "json",
							data : param,
							success : function(result) {
								// 검색 이력 체우기
								filterdData.put(key, {
									dataObj : result.returnObj,
									index : 0,
									length : result.returnObj.length
								});
							},
							error : function(err) {
								//alert(JSON.stringify('서버와 연결에 실패 하였습니다. (COrgP001X)'));
								return {
									errCode : 'COrgP001X',
									isSuccess : false,
									hasResult : false
								};
							}
						});

		var returnObj = {};
		returnObj.isSuccess = true;
		returnObj.hasResult = false;
		returnObj.selectedId = null;
		returnObj.selectMode = null;
		returnObj.selectItem = null;
		returnObj.fullCount = 0;
		returnObj.resultCount = 0;

		if (filterdData.get(key).length) {
			// 검색 결과가 있는 경우.
			var searchedTemp = filterdData.get(key);
			var singleItem = searchedTemp.dataObj[searchedTemp.index
					% searchedTemp.length];

			returnObj.hasResult = true;
			returnObj.selectedId = singleItem.deptSeq;
			returnObj.selectMode = defaultInfo.selectMode;
			returnObj.selectItem = defaultInfo.selectItem;
			returnObj.fullCount = searchedTemp.length;
			returnObj.resultCount = ((searchedTemp.index) % searchedTemp.length + 1);
			searchedTemp.index++;

			// 노드 처리 포인트 처리 - 이 페이지임.
			OJT_fnSearchNode(true, singleItem.deptPath);
		}

		return returnObj;
	}
</script>
