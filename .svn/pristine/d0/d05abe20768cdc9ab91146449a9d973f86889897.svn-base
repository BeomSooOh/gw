<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jsTree/style.min.css' />" />
<link rel="stylesheet" type="text/css" href="<c:url value='/js/pudd/css/pudd.css' />" />
<link rel="stylesheet" type="text/css" href="<c:url value='/js/pudd/css/re_pudd.css' />" />
<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/pudd/js/pudd-1.1.179.min.js' />"></script>

<title></title>
</head>

<script type="text/javascript">
	var isSearching = false;
	var lastSearchText = "";
	var lastSearchTreeIndex = null;
	
	var callback = '${params.callback}';
	var compSeq = '${params.compSeq}';
	var useModule = '${params.useModule}';
	var selectedSecId = '${params.selectedSecId}';
	var userSe = '${params.userSe}';
	
	$(document).ready(function() {
		var paramSet = {};
		paramSet.compSeq = compSeq || '';
		paramSet.callback = callback || '';
		paramSet.useModule = useModule || '';
		paramSet.selectedSecId = selectedSecId || '';
		
		if (!callback) {
			alert('<%=BizboxAMessage.getMessage("TX800002005","콜백 함수가 존재하지 않습니다.")%>');
			window.close();
		}
		if (!(compSeq)) {
			alert('<%=BizboxAMessage.getMessage("TX000001894","회사코드가 존재하지 않습니다.")%>');
			window.close();
		}
		if (!(useModule)) {
			alert('<%=BizboxAMessage.getMessage("TX800002006","사용할 모듈이 존재 하지 않습니다.")%>');
			window.close();
		}
		if (!(userSe)) {
			alert('<%=BizboxAMessage.getMessage("TX000016539","권한이 존재 하지 않습니다.")%>');
			window.close();
		}
		
		Pudd( "#searchText" ).puddTextBox({
				attributes : { style : "width:230px;" } // control 부모 객체 속성 설정
			,	controlAttributes : { placeholder : "<%=BizboxAMessage.getMessage("TX000001289","검색")%>" } // control 자체 객체 속성 설정
			,	value : ""
			,	inputType : "search"
			,	fnSearch : fnSearchSecGrade // search 버튼 callback 선언
		});
		
		/* 옵션에 따른 페이지 정보 변경 */
		//fnResizeForm();
		/* 저장, 취소 버튼 이벤트 정의 */
		fnSetBtnEvent_SaveCancel();
		
		gradeTreeInit();
	});
	function fnResizeForm() {
		$('#div_org_tree_').width(315);
		$('.pop_wrap').width(349);
		$('.pop_foot').width(349);
		$('.jstreeSet').height(390);
		var strWidth = $('.pop_wrap').outerWidth()
		+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);
		
		$('.pop_wrap').css("overflow","hidden");
		$('.jstreeSet').css("overflow","hidden");
		
		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;
		
		if(isFirefox){
			
		}if(isIE){
			
		}if(isEdge){
			
		}if(isChrome){
		}
		
		try{
			var childWindow = window.parent;
			childWindow.resizeTo(strWidth, strHeight);	
		}catch(exception){
			console.log('window resizing cat not run dev mode.');
		}
	}
	//트리 css적용
	function setLiAttr(secGradeList){
		for(var i=0;i<secGradeList.length;i++){
			if(secGradeList[i].compSeq == "0"){
				secGradeList[i].li_attr = {"class":"text_green"};	
			}
			if(secGradeList[i].useYn == "N"){
				secGradeList[i].a_attr = {"class":"text_gray2"};
				secGradeList[i].state = {
						"disabled" : true
				}
			}
		}
	}
	
	//보안등급 트리 생성
	function gradeTreeInit() {
		//$("#gradeTreeView").attr('class','jstreeSet tree_auto'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/secGradeListForPop.do" />',
			datatype:"json",
			async: true,
			data:{
				'compSeq' : compSeq, 
				'useYn' : "Y", 
				'useModule' : useModule
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
			        	'plugins' : ["sort","conditionalselect"],
			        	'conditionalselect' : function (node) {
			        	    return node.original.useYn=='Y' ? true : false;
			        	  },
			        	'sort' :  function (a, b) {
			        		
			        		if(selectedSecId){
				        		if(this.get_node(a).original.id == selectedSecId){
				        			return -1;
				        		}
				        		if(this.get_node(b).original.id == selectedSecId){
				        			return -1;
				        		}
			        		}
			        		return this.get_node(a).original.secOrder > this.get_node(b).original.secOrder ? 1 : -1;
		        	    }
			        })
			        .bind("loaded.jstree", function (event, data) {
			        	$("#gradeTreeView").height("380px");
			        	$(this).jstree("open_all");
			        	if(selectedSecId){
			        		$('#gradeTreeView').jstree(true).select_node(selectedSecId);
			        		fnSetScrollToNode(selectedSecId);
			        	}
			        	
					})
					.bind("dblclick.jstree", function (event) {
						
					    var instance = $.jstree.reference(this),
			            node = instance.get_node(event.target);
					    
					    if(node.original.useYn == 'N'){
						    return;	   
					    }
						processSave();
					})
					.bind("select_node.jstree", function (event, data) {
						
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
	
	
	function validationForSave(selectedNode){
		
		if(!selectedNode || selectedNode.parent == '#'){
			var puddDialog = Pudd.puddDialog({
				width : 330,
				message : {
					type : "warning",
					content : '<%=BizboxAMessage.getMessage("TX800002007","저장 할 수 없습니다.")%>'
				}			 
			});
			return false;
		}
		
		return true;
	}
	
	/* [ 저장,취소 ] 저장, 취소 버튼 이벤트 정의
	-----------------------------------------------*/
	function fnSetBtnEvent_SaveCancel() {
		$('#btn_save').click(function() {
			
			processSave();
		});
		$('#btn_cancel').click(function() {
			parent.window.close();
		});
	}
	
	function processSave(){
		var selectedNode = $('#gradeTreeView').jstree('get_selected', true)[0];
		
		if(!validationForSave(selectedNode)){
			return;
		}
		
		fnCall_CallbackFunc(selectedNode);
	}

	/* [ 저장,취소 ] 콜백 함수 호출
	-----------------------------------------------*/
	function fnCall_CallbackFunc(data) {
		window.opener[callback](data);
		window.close();
	}
	
	//보안등급명 검색 버튼
	function fnSearchSecGrade(){
		
		var searchText = Pudd( "#searchText" ).getPuddObject().val();
		if(searchText == ''){//빈문자열이면 중지.
			var puddDialog = Pudd.puddDialog({
				width : 330,
				message : {
					type : "warning",
					content : '<%=BizboxAMessage.getMessage("TX000002582","검색어를 입력해 주세요.")%>'
				}			 
			});
			return;
		}
		
		if(isSearching){
			var puddDialog = Pudd.puddDialog({
				width : 330,
				message : {
					type : "warning",
					content : '<%=BizboxAMessage.getMessage("TX000003185","처리중입니다. 잠시만 기다려주십시오.")%>'
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
			
			if(nodeText.indexOf(searchText) > -1 && $('#gradeTreeView').jstree(true).get_node(nodeId).original.useYn == 'Y'){
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
</script>
<div class="pop_wrap organ_wrap" style="width:385px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900001560","보안등급 선택")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
					
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt><%=BizboxAMessage.getMessage("TX000003771","등급명")%></dt>
				<dd>
					<div id="searchText" onkeydown="if(event.keyCode==13){javascript:fnSearchSecGrade();}"></div>
				</dd>
			</dl>
		</div>
		<div class="text_blue mt14">
			- 
			<c:if test="${params.userSe == 'USER'}">
			<%=BizboxAMessage.getMessage("TX900001561","사용자가 선택 가능한 보안등급이 조회 됩니다.")%>
			</c:if>
			<c:if test="${params.userSe == 'ADMIN' || params.userSe == 'MASTER'}">
			<%=BizboxAMessage.getMessage("TX800002008","회사 항목의 선택 값에 따라 보안등급이 조회 됩니다.")%>
			</c:if>
		</div>
		<div class="box_div p0 mt14">
			<div id="gradeTreeView" class="jstreeSet" style="height:350px;"></div>
		</div>
	</div><!-- //pop_con -->	

	<div class="pop_foot">
		<div class="btn_cen pt12">			
			<input type="button" class="puddSetup submit" id="btn_save" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> 
			<input type="button" class="puddSetup gray_btn" id="btn_cancel" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->
