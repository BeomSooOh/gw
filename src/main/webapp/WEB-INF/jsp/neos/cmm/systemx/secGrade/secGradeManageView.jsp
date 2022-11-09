<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/jsTree/style.min.css' />" />
<link rel="stylesheet" type="text/css" href="<c:url value='/js/pudd/css/pudd.css' />" />
<link rel="stylesheet" type="text/css" href="<c:url value='/js/pudd/css/re_pudd.css' />" />
<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/pudd/js/pudd-1.1.179.min.js' />"></script>

<script type="text/javascript">
	var lastSearchText = "";
	var lastSearchTreeIndex = null;
	var isSearching = false;
	$(document).ready(function() {
		//보안등급트리 init
		gradeTreeInit();
		
		//사용자그리드 init
		userGridInit([]);

		gridHeightChange( 700 );// 개발시 맞게 사이즈조정해주어야함
		/* $(window).resize(function () {
			gridHeightChange( 700 );// 개발시 맞게 사이즈조정해주어야함
	
		});
	 */	
		Pudd( "#search_pt" ).puddTextBox({ 
				attributes : { style : "width:100%;" } // control 부모 객체 속성 설정
			,	controlAttributes : { placeholder : "<%=BizboxAMessage.getMessage("cop.deptNm","부서명")%>/<%=BizboxAMessage.getMessage("cop.clsfNm","직급")%>/<%=BizboxAMessage.getMessage("TX000000150","사용자명")%>" } // control 자체 객체 속성 설정
			,	value : ""
			,	inputType : "search"
			,	fnSearch : fnSearchUserCallback // search 버튼 callback 선언
		});
	 
	 	//트리 클로즈 방지
	 	$.jstree.plugins.noclose = function () {
	        this.close_node = $.noop;
	    }
	});
	
	function gridHeightChange( minusVal ) {
		var puddGrid = Pudd( "#grid" ).getPuddObject();
		var cHeight = document.body.clientHeight;

		var newGridHeight = cHeight - minusVal;
		if( newGridHeight > 100 ) {// 최소높이
			puddGrid.gridHeight( newGridHeight );
		}
	}
	
	//사용자 목록 조회
	function searchSecGradeUser(params){
		showLoading();
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/secGradeUserList.do" />',
			datatype:"json",
			async: true,
			data: params,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					userGridInit(data.result.secGradeUserList);
				}else if(data.resultCode!="LOGIN004"){
					console.log(data);
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				hideLoading();
			},error: function(result) {
				console.log(result);
				hideLoading();
			}  
		});
	}
	
	//사용자 그리드 초기화
	function userGridInit(exData){
		/* 
		var exData = [
			{ gridCheckBox: "",	부서명:  "UC개발부",	직급: "대리",	사용자명:"이준혁(dragontia)" }
			
		];
 */
		var dataSource = new Pudd.Data.DataSource({
		 
			data : exData			// 직접 data를 배열로 설정하는 옵션 작업할 것			 
		,	pageSize : 10			// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
		,	serverPaging : false
		});
	 
		Pudd( "#grid" ).puddGrid({	 
			dataSource : dataSource	 
		,	scrollable : true	 
		,	resizable : true
		,	pageable : {
			buttonCount : 10
		,	pageList : [ 10, 30, 50, 70, 100 ]
		,	showAlways : false	// 기본값 true - data totalCount가 0 이라도 pager 표시함
						// false 설정한 경우는 data totalCount가 0 이면 pager가 표시되지 않음
		,	pageInfo : true	// pageInfo 표시 여부,  예) 1-13 페이지 / 총 123 개
		}
		,	columns : [
				{
					field : "gridCheckBox"		// grid 내포 checkbox 사용할 경우 고유값 전달
				,	width : 34
				,	editControl : {
						type : "checkbox"
					//,	dataValueField : ""	// value값을 datasource와 매핑하는 경우 설정
					,	basicUse : true
					}
				}			 
			,	{
					field : "deptName"
				,	title : "<%=BizboxAMessage.getMessage("cop.deptNm","부서명")%>"
				,	width : 110
				}
			,	{
					field:"dpNamePosition"
				,	title:"<%=BizboxAMessage.getMessage("cop.clsfNm","직급")%>"
				,	width:100
				}
			,	{
					field:"empName"
				,	title:"<%=BizboxAMessage.getMessage("TX000000150","사용자명")%>(ID)"
				,	width:100
				}
			]
		,	noDataMessage : {
				message : "<%=BizboxAMessage.getMessage("info.nodata.msg2","데이터가 존재하지 않습니다.")%>"
			}
		});
	}
	
	//보안등급 트리 생성
	function gradeTreeInit() {
		$("#gradeTreeView").attr('class','jstreeSet tree_auto'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/secGradeList.do" />',
			datatype:"json",
			async: true,
			data:{
				'compSeq' : $("#com_sel").val(), 
				'useYn' : $("#useYn").val(), 
				'useModule' : $("#useModule").val()
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					
					//css 처리
					setLiAttr(data.result.secGradeList);
					
					$('#gradeTreeView').jstree({ 
			        	'core' : { 
			        		'data' : data.result.secGradeList,
			        		'animation' : false,
			        		'dblclick_toggle':false
			        	},
			        	'plugins' : ["sort"],
			        	'sort' :  function (a, b) {
			        		return this.get_node(a).original.secOrder > this.get_node(b).original.secOrder ? 1 : -1;
		        	    }
			        })
			        .bind("loaded.jstree", function (event, data) {
			        	$(this).jstree("open_all");
					})
					.bind("dblclick.jstree", function (event) {
						fnSecGradeModify();	
					})
					.bind("select_node.jstree", function (event, data) {
						var params = 
						{
							"secId" : data.node.original.id,
							"compSeq" : data.node.original.compSeq,
							"searchText" : Pudd( "#search_pt" ).getPuddObject().val() 
						};
						
						searchSecGradeUser(params);
					});
					
				}else if(data.resultCode!="LOGIN004"){
					console.log(data);
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				
			},error: function(result) {
				console.log(result);
			}  
		});
        		
	}
	
	//보안등급명 검색 버튼
	function fnSearchSecGrade(){
		
		var searchText = $('#searchText').val();
		if(searchText == ''){//빈문자열이면 중지.
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX000002582","검색어를 입력해 주세요.")%>"
				}			 
			});
			return;
		}
		
		if(isSearching){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX000003185","처리중입니다. 잠시만 기다려주십시오.")%>"
				}			 
			});
			return;
		}else{
			isSearching = true;
		}
		
		var nodeList = $("#gradeTreeView").jstree(true).get_json('#', {'flat': true});
		
		//마지막으로 검색
		var index = 0;
		
		if(searchText == lastSearchText){
			index = lastSearchTreeIndex ? lastSearchTreeIndex + 1 : 0; 
		}else{
			lastSearchText = searchText;
		}

		var isFounded = false;
		
		for (i = index; i < nodeList.length; i++) {
			
			var nodeText = nodeList[i].text;
			var nodeId = nodeList[i].id;
			
			if(nodeText.indexOf(searchText) > -1){
				isFounded = true;
				lastSearchTreeIndex = i;
				//기존항목선택해제
				$('#gradeTreeView').jstree("deselect_all");
				//신규항목선택
				$('#gradeTreeView').jstree(true).select_node(nodeId);
				//선택항목으로 스크롤이동
				fnSetScrollToNode(nodeId);
				break;
			}
		}
		
		if(!isFounded){
			lastSearchTreeIndex = null;
		}
		isSearching = false;
	}
	
	//get position of element
	function getPosition(element) {
	    var xPosition = 0;
	    var yPosition = 0;

	    while (element)
	    {
	        xPosition += (element.offsetLeft - element.scrollLeft + element.clientLeft);
	        yPosition += (element.offsetTop - element.scrollTop + element.clientTop);
	        element = element.offsetParent;
	    }
	    return { x: xPosition, y: yPosition };
	}
	//트리뷰 스크롤이동
	function fnSetScrollToNode(nodeId) {
		var jstree = document.getElementById('gradeTreeView');
		var toY = getPosition(document.getElementById(nodeId)).y;
		var offset = jstree.offsetHeight / 2;
		var topV = toY - offset;
		
		$(".jstreeSet").animate({
			scrollTop : (toY/2)
		}, {
			duration : 0,
			complete : function (){
				
			}
		}); // 이동
	}
	//회사 변경 이벤트
	function compChange() {
		$('#gradeTreeView').jstree("destroy").empty();
		/* $("#userInfo").html("");
		document.getElementById('all_chk').checked = false; */
		gradeTreeInit();
		userGridInit([]);
	}
	
	//보안등급목록 신규 버튼 클릭 이벤트
	function fnSecGradeRegBtn(){
		var selectedNode = $('#gradeTreeView').jstree('get_selected', true)[0]; 
		
		//부모노드 찾을때(from 부모노드ID)
		//("#gradeTreeView").jstree().get_node( selectedNode.original.parent ).text
		
		//신규 모드
		$("#popMode").val('c');
		
		if(selectedNode){//선택된 노드가 있음
			//관리자 이면서 선택한 노드가 그룹이면 신규등록 불가
			if('${params.userSe}'=='ADMIN' && selectedNode.original.compSeq=="0"){
				var puddDialog = Pudd.puddDialog({
					width : 400,
					message : {
						type : "warning",
						content : "<%=BizboxAMessage.getMessage("","관리자는 그룹을 등록할 수 없습니다.")%>"
					}			 
				});
				return;
			}
			
			$("#selectedCompSeq").val(selectedNode.original.compSeq);
			$("#selectedUseModule").val(selectedNode.original.module);
			$("#selectedNodeParent").val(selectedNode.original.id);
			
			if(selectedNode.parents && selectedNode.parents[0] != "#"){
			
			//if(selectedNode.original.secDepth > 0){
				$("#selectedNodeParentText").val(selectedNode.original.text);
			}else{
				$("#selectedNodeParentText").val('-');
			}
			
			$("#selectedNodeSecDepth").val(selectedNode.original.secDepth);
			
		}else{//선택된 노드가 없음
			$("#selectedCompSeq").val($("#com_sel").val());
			$("#selectedUseModule").val($("#useModule").val());
			$("#selectedNodeParent").val('');
			$("#selectedNodeParentText").val('-');
			$("#selectedNodeSecDepth").val('');
			$("#selectedNodeText").val('');
			
		}
		
		$("#selectedNodeId").val('');
		$("#selectedNodeUseYn").val('Y');
		$("#selectedNodeIconYn").val('N');
		$("#selectedNodeSecOrder").val('');
		$("#selectedNodeEtc").val('');
		$("#selectedNodeSecNameKr").val('');
		$("#selectedNodeSecNameEn").val('');
		$("#selectedNodeSecNameJp").val('');
		$("#selectedNodeSecNameCn").val('');
		
		fnSecGradeRegPop();
	}
	
	//보안등급목록 수정 더블 클릭 이벤트
	function fnSecGradeModify(){
		
		var selectedNode = $('#gradeTreeView').jstree('get_selected', true)[0]; 

		if(!selectedNode || selectedNode.original.parent == '#'){
			return;
		}
		
		//수정 모드 (수정가능 항목 : 아이콘등록여부, 등급명, 사용여부, 정렬순서, 비고)
		$("#popMode").val('u');
		
		$("#selectedCompSeq").val(selectedNode.original.compSeq);
		$("#selectedUseModule").val(selectedNode.original.module);
		$("#selectedNodeId").val(selectedNode.original.id);
		$("#selectedNodeParent").val(selectedNode.original.parent);
		
		if(selectedNode.parents && selectedNode.parents[0] != "#" && selectedNode.parents[1] != "#"){
		
		//if(selectedNode.original.secDepth > 1){
			$("#selectedNodeParentText").val($("#gradeTreeView").jstree().get_node( selectedNode.original.parent ).text);
		}else{
			$("#selectedNodeParentText").val('-');
		}
		
		$("#selectedNodeSecDepth").val(selectedNode.original.secDepth);
		$("#selectedNodeUseYn").val(selectedNode.original.useYn);
		$("#selectedNodeIconYn").val(selectedNode.original.iconYn);
		$("#selectedNodeSecOrder").val(selectedNode.original.secOrder);
		$("#selectedNodeEtc").val(selectedNode.original.etc);
		$("#selectedNodeSecNameKr").val(selectedNode.original.secNameKr);
		$("#selectedNodeSecNameEn").val(selectedNode.original.secNameEn);
		$("#selectedNodeSecNameJp").val(selectedNode.original.secNameJp);
		$("#selectedNodeSecNameCn").val(selectedNode.original.secNameCn);
		
		fnSecGradeRegPop();
	}
	
	//보안등급 등록 팝업 호출
	function fnSecGradeRegPop() {
		var pop = window.open("", "secGradeRegPop", "width=799,height=475,scrollbars=no");
		secGradeRegPop.target = "secGradeRegPop";
		secGradeRegPop.method = "post";
		secGradeRegPop.action = '<c:url value="/cmm/systemx/secGrade/secGradeRegPop.do" />';
		secGradeRegPop.submit();
		pop.focus();
	}
	//보안등급목록 삭제 Process
	function fnSecGradeRemoveProcess(canRemoveResult){
		var selectedNodes = $('#gradeTreeView').jstree('get_selected', true); 
		
		if(!validationForSecGradeCanRemove(selectedNodes)){
			return;
		}
		
		var params = {
			"secId" : selectedNodes[0].original.id,
			"parent" :selectedNodes[0].original.parent,
			"module" : selectedNodes[0].original.module,
			"compSeq" : selectedNodes[0].original.compSeq,
			"secDepth" : selectedNodes[0].original.secDepth
		};
		if(canRemoveResult.callBackYn =="N"){
			if(confirm("<%=BizboxAMessage.getMessage("common.delete.msg","삭제하시겠습니까?")%>")){
				secGradeRemove(params);
			}
		}else{
			if(confirm(canRemoveResult.typeMessage)){
				params['callBackUrl'] = canRemoveResult.callBackUrl;
				params['type'] = canRemoveResult.type;
				secGradeRemove(params);	
			}
		}
	}
	function secGradeRemove(params){
		//보안등급목록 삭제
		showLoading();
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/removeSecGrade.do" />',
			datatype:"json",
			async: true,
			data: params,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					//보안등급 목록(Tree) & 사용자 목록 초기화(Grid)
					callbackChangeSecGrade();
					var puddDialog = Pudd.puddDialog({
						width : 400,
						message : {
							type : "success",
							content : "<%=BizboxAMessage.getMessage("TX000002121","삭제 되었습니다.")%>"
						}			 
					});
					
				}else if(data.resultCode!="LOGIN004"){
					alert(data.resultMessage);
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				hideLoading();
			},error: function(result) {
				console.log(result);
				hideLoading();
			}  
		});
	}
	
	//보안등급목록 삭제 버튼 클릭 이벤트 (삭제 가능 여부 먼저 호출)
	function fnSecGradeCanRemoveBtn(){
		
		var selectedNodes = $('#gradeTreeView').jstree('get_selected', true); 
		
		if(!validationForSecGradeCanRemove(selectedNodes)){
			return;
		}
		showLoading();
		//보안등급목록 삭제가능 여부
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/canRemoveSecGrade.do" />',
			datatype:"json",
			async: true,
			data: {
				"secId" : selectedNodes[0].original.id,
				"parent" :selectedNodes[0].original.parent,
				"module" : selectedNodes[0].original.module,
				"compSeq" : selectedNodes[0].original.compSeq,
				"secDepth" : selectedNodes[0].original.secDepth
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					//메세지 출력.
					if(data.result.canRemoveYn=="N"){//삭제 할 수 없으면
						var puddDialog = Pudd.puddDialog({
							width : 400,
							message : {
								type : "warning",
								content : data.result.typeMessage
							}			 
						});
					}else{//삭제 가능 하면 삭제 process API 호출
						fnSecGradeRemoveProcess(data.result);
					}
					
				}else if(data.resultCode!="LOGIN004"){
					alert(data.resultMessage);
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				hideLoading();
			},error: function(result) {
				console.log(result);
				hideLoading();
			}  
		});
	}
	//보안등급목록 삭제가능여부 Validation
	function validationForSecGradeCanRemove(selectedNodes){
		
		var selectedNodes = $('#gradeTreeView').jstree('get_selected', true);
		
		if(selectedNodes.length < 1){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","삭제할 항목을 선택해 주세요.")%>"
				}			 
			});
			return false;
		}
		//parent="#" 인 최상위는 삭제 불가
		if(selectedNodes[0].original.parent=="#"){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","최상위는 삭제 불가능 합니다.")%>"
				}			 
			});
			return false;
		}
		
		//관리자는 그룹 보안등급 삭제 불가.
		if('${params.userSe}'=='ADMIN' && selectedNodes[0].original.compSeq == "0"){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","관리자는 그룹을 삭제할 수 없습니다.")%>"
				}			 
			});
			return false;
		}
		<%-- 
		if(selectedNodes[0].original.compSeq == "0" && selectedNodes[0].original.secDepth < 4 && (selectedNodes[0].original.id =="001" || selectedNodes[0].original.id =="002" || selectedNodes[0].original.id =="003")){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","기본 제공되는 등급은 삭제 불가합니다. 미사용 처리 해주세요.")%>"
				}			 
			});
			return false;
		}
		 --%>
		return true;
	}
	//사용자목록 신규 버튼 클릭 이벤트
	function fnSecGradeUserNewBtn(){
		
		var selectedNodes = $('#gradeTreeView').jstree('get_selected', true);
		
		if(!validationSecGradeUserNew(selectedNodes)){
			return;
		}
		
		fnOrgChart();
	}
	
	//사용자목록 삭제 버튼 클릭 이벤트
	function fnSecGradeUserRemoveBtn(){
		var dataTarget = Pudd( "#grid" ).getPuddObject().getGridData();
		
		var removeList = [];
		
		for(var i=0;i<dataTarget.length;i++){
			if(dataTarget[i].gridCheckBox.checked){
				removeList.push(dataTarget[i]);
			}
		}
		
		if(removeList.length < 1){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","삭제할 사용자를 선택하세요.")%>"
				}			 
			});
			return;
		}
		
		//삭제 실행
		if(confirm("<%=BizboxAMessage.getMessage("common.delete.msg","삭제하시겠습니까?")%>")){
			removeSecGradeUser(removeList);	
		}
	}
	
	//사용자목록 삭제
	function removeSecGradeUser(removeList){
		var params = {
			"removeList" : JSON.stringify(removeList) 
		};
		
		//보안등급 사용자 삭제 처리.
		showLoading();
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/removeSecGradeUser.do" />',
			datatype:"json",
			async: true,
			data: params,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					var puddDialog = Pudd.puddDialog({
						width : 400,
						message : {
							type : "success",
							content : "<%=BizboxAMessage.getMessage("TX000002121","삭제 되었습니다.")%>"
						}			 
					});
					fnSearchUserCallback();
				}else if(data.resultCode!="LOGIN004"){
					console.log(data);
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				hideLoading();
			},error: function(result) {
				console.log(result);
				hideLoading();
			}  
		});
	}
	
	//사용자목록 신규 버튼 Validation
	function validationSecGradeUserNew(){
		
		var selectedNodes = $('#gradeTreeView').jstree('get_selected', true);
		
		if(selectedNodes.length < 1){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","사용자 등록할 보안등급을 선택해주세요.")%>"
				}			 
			});
			return false;
		}
		//관리자 이면서 선택한 노드가 그룹이면 신규등록 불가
		<%-- if('${params.userSe}'=='ADMIN' && selectedNodes[0].original.compSeq=="0"){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","관리자는 그룹-사용자를 등록할 수 없습니다.")%>"
				}			 
			});
			return;
		} --%>
		
		if(selectedNodes[0].original.parent == "#"){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","최상위에는 사용자를 추가 할 수 없습니다.")%>"
				}			 
			});
			return false;
		}
		
		return true;
		
	}
	
	//트리 css적용
	function setLiAttr(secGradeList){
		for(var i=0;i<secGradeList.length;i++){
			if(secGradeList[i].compSeq == "0"){
				secGradeList[i].li_attr = {"class":"text_green"};	
			}
			if(secGradeList[i].useYn == "N"){
				secGradeList[i].a_attr = {"class":"text_gray2"};
			}
		}
		
	}
	
	// 조직도 호출
	function fnOrgChart() {
		
		var selectedNodes = $('#gradeTreeView').jstree('get_selected', true);
		var compSeq = selectedNodes[0].original.compSeq;
		
		if(compSeq!="0"){//그룹이 아니면 해당 회사만 보이도록
			$("#compFilter").val(compSeq);
		}else{//그룹이면 볼수있는 회사 전부
			$("#compFilter").val('${params.compFilter}');
		}
		
		var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
		frmPop.submit();
		pop.focus();
	}
	
	//보안등급 선택 팝업 호출
	function fnSecGradePop() {
		var pop = window.open("", "secGradePop", "width=353,height=607,scrollbars=no");
		secGradePop.target = "secGradePop";
		secGradePop.method = "post";
		secGradePop.action = '<c:url value="/cmm/systemx/secGrade/secGradePop.do" />';
		secGradePop.submit();
		pop.focus();
	}
	
	//보안등급 선택 팝업 콜백함수
	function callbackSelectSecGrade(returnObj){
		console.log("callbackSelectSecGrade reutrnObj");
		console.log(returnObj);
	}
	//보안등급 선택 팝업 콜백함수
	function callbackChangeSecGrade(){
		$('#gradeTreeView').jstree("destroy").empty();
		
		//보안등급트리 init
		gradeTreeInit();
		
		//사용자그리드 init
		userGridInit([]);
	}
	
	//사용자 선택팝업 콜백함수
	function callbackSel(data) {
		
		var saveList = data.returnObj;
		
		if(saveList.length < 1){
			return;
		}
		
		var selectedNodes = $('#gradeTreeView').jstree('get_selected', true);
		
		if(selectedNodes.length < 1){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","선택된 보안등급이 없습니다.")%>"
				}			 
			});
			return false;
		}
		
		var params = {
			"secId" : selectedNodes[0].id,
			"saveList" : JSON.stringify(saveList) 
		};
		showLoading();
		//보안등급 사용자 저장 처리.
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/saveSecGradeUser.do" />',
			datatype:"json",
			async: true,
			data: params,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					var puddDialog = Pudd.puddDialog({
						width : 400,
						message : {
							type : "success",
							content : "<%=BizboxAMessage.getMessage("","저장 되었습니다.")%>"
						},defaultClickCallback : function (puddDlg){
							puddDlg.showDialog( false );
							fnSearchUserCallback();			
						}
					});
					
				}else if(data.resultCode!="LOGIN004"){
					console.log(data);
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				hideLoading();
			},error: function(result) {
				console.log(result);
				hideLoading();
			}  
		});
		
	}
	
	// 입력박스 키보드 입력 발생시에 호출되는 callback 함수
	function fnSearchUserCallback() {
		
		var data = $('#gradeTreeView').jstree('get_selected', true)[0]; 
		
		if(!data){
			var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","검색할 보안등급을 선택해 주세요.")%>"
				}			 
			});
			return;
		}
		
		var params = 
		{
			"secId" : data.original.id,
			"compSeq" : data.original.compSeq,
			"searchText" : Pudd( "#search_pt" ).getPuddObject().val()
		};
		 
		searchSecGradeUser(params);
	}
	
	function showLoading(){
        $("#loading").show();
    }

    function hideLoading(){
        $("#loading").hide();
    }
	
</script>

<div class="top_box">
	<dl class="dl1">
		<dt style="width:70px;"class="ar"><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
		<dd>
			<select id="com_sel" class="puddSetup" pudd-style="min-width:120px;" onchange="compChange()">
				<c:forEach var="comp" items="${compList}" varStatus="status">
					<option value="${comp.compSeq}">${comp.compName}</option>
				</c:forEach>
			</select>
		</dd>
		<dt class="ar" style="display:none;"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
		<dd style="display:none;">
			<select id="useYn" class="puddSetup" pudd-style="min-width:120px;">
				<option value="all" selected="selected"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
				<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
			</select>
		</dd>
		<dt class="ar"><%=BizboxAMessage.getMessage("TX000018619","사용")%><%=BizboxAMessage.getMessage("TX000021960","모듈")%></dt>
		<dd>
			<select id="useModule" class="puddSetup" pudd-style="min-width:120px;" onchange="compChange()">
				<c:forEach var="module" items="${moduleList}" varStatus="status">
					<option value="${module.CODE}">${module.CODE_NM}</option>
				</c:forEach>
			</select>
		</dd>
		<dt style="width:70px;"><%=BizboxAMessage.getMessage("TX000005994","보안등급")%><%=BizboxAMessage.getMessage("TX000004915","명")%></dt>
		<dd><input type="text" id="searchText" style="width:150px;" class="puddSetup" value="" onkeydown="if(event.keyCode==13){javascript:fnSearchSecGrade();}"/></dd>
		<dd><input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="fnSearchSecGrade();"/></dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="twinbox mt14">
		<table cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="50%">
				<col width="">
			</colgroup>
			<tr>
				<td class="twinbox_td pt0">
					<div class="btn_div">
						<div class="left_div mt5">	
							<p class="tit_p"><%=BizboxAMessage.getMessage("TX000005994","보안등급")%> <%=BizboxAMessage.getMessage("TX000003107","목록")%></p>
						</div>	
						<div class="right_div">
							<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("button.new","신규")%>" onclick="fnSecGradeRegBtn()"/>
							<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("button.delete","삭제")%>" onclick="fnSecGradeCanRemoveBtn()"/>
						</div>	
					</div>				
					
					<div class="jstreeSet Pop_border auto-hei" auto-hei="380">
						<div id="gradeTreeView" ></div>
					</div>

				</td>
				<td class="twinbox_td pt0">
					<div class="btn_div">
						<div class="left_div mt5">	
							<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016028","사용자 목록")%></p>
						</div>
						<div class="right_div">
							<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000446","추가")%>" onclick="fnSecGradeUserNewBtn()"/>
							<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("button.delete","삭제")%>" onclick="fnSecGradeUserRemoveBtn()"/>
						</div>	
					</div>
					
					<div class="top_box">
						<dl>
							<dt><%=BizboxAMessage.getMessage("button.search","검색")%></dt>
							<dd style="width:70%">
								<div id="search_pt" onkeydown="if(event.keyCode==13){javascript:fnSearchUserCallback();}"></div>
							</dd>
						</dl>
					</div>
					<div id="grid" class="mt14"></div>				
				</td>
			</tr>
		</table>
	</div>	
</div><!-- //sub_contents_wrap -->
<div id="loading" style="display:none; position: absolute;left:50%;top:30%; margin: 0; padding: 0;"><img src="/gw/Images/ico/loading.gif"></div>
<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do'/>">
	<input type="hidden" name="selectMode" width="500" value="ud" />
	<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
	<input type="hidden" name="selectItem" width="500" value="m" />
	<input type="hidden" name="callback" width="500" value="callbackSel" />
	<input type="hidden" name="compSeq" id="compSeq"  value="" />
	<input type="hidden" name="compFilter" id="compFilter" value="${params.compFilter}" />
	<input type="hidden" name="initMode" id="initMode" value="" />
	<input type="hidden" name="noUseDefaultNodeInfo" id="noUseDefaultNodeInfo" value="" />
	<input type="hidden" name="selectedItems" id="selectedItems" value="" />
</form>

<form id="secGradePop" name="secGradePop">
	<input type="hidden" name="callback" value="callbackSelectSecGrade" />
	<input type="hidden" name="compSeq" value="0" />
	<input type="hidden" name="useModule" value="eap" />
	<input type="hidden" name="userSe" value="MASTER" />
	<input type="hidden" name="selectedSecId" value="11111111111" /><!--  -->
</form>

<form id="secGradeRegPop" name="secGradeRegPop">
	<input type="hidden" name="popMode" id="popMode" value="" /><!-- c:신규 등록, u:수정 -->
	<input type="hidden" name="selectedCompSeq" id="selectedCompSeq" value="" /><!-- 회사Seq -->
	<input type="hidden" name="selectedUseModule" id="selectedUseModule" value="" /><!-- 사용모듈 콤보박스 값 -->
	<input type="hidden" name="selectedNodeId" id="selectedNodeId" value="" /><!-- 선택된 노드 ID -->
	<input type="hidden" name="selectedNodeParent" id="selectedNodeParent" value="" /><!-- 선택된 노드 부모ID -->
	<input type="hidden" name="selectedNodeParentText" id="selectedNodeParentText" value="" /><!-- 선택된 노드 부모 Text -->
	<input type="hidden" name="selectedNodeSecDepth" id="selectedNodeSecDepth" value="" /><!-- 선택된 노드 DEPTH -->
	<input type="hidden" name="selectedNodeUseYn" id="selectedNodeUseYn" value="" /><!-- 선택된 노드 사용여부 -->
	<input type="hidden" name="selectedNodeIconYn" id="selectedNodeIconYn" value="" /><!-- 선택된 노드 아이콘 사용여부 -->
	<input type="hidden" name="selectedNodeSecOrder" id="selectedNodeSecOrder" value="" /><!-- 선택된 노드 순서 -->
	<input type="hidden" name="selectedNodeSecNameKr" id="selectedNodeSecNameKr" value="" /><!-- 선택된 노드 등급명(한국어) -->
	<input type="hidden" name="selectedNodeSecNameEn" id="selectedNodeSecNameEn" value="" /><!-- 선택된 노드 등급명(영어) -->
	<input type="hidden" name="selectedNodeSecNameJp" id="selectedNodeSecNameJp" value="" /><!-- 선택된 노드 등급명(일본어) -->
	<input type="hidden" name="selectedNodeSecNameCn" id="selectedNodeSecNameCn" value="" /><!-- 선택된 노드 등급명(중국어) -->
	<input type="hidden" name="selectedNodeEtc" id="selectedNodeEtc" value="" /><!-- 선택된 노드 비고 -->
</form>