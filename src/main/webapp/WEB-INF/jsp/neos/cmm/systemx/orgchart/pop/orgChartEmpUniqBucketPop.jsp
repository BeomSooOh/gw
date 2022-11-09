<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>

<!-- mCustomScrollbar -->
<link rel="stylesheet" type="text/css" href="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.css">
<script type="text/javascript" src="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>

<title></title>
</head>

<script type="text/javascript">

	// 테스트용 변수, 파라미터로 수신할 필요가 있음.
	var groupSeq = '${params.groupSeq}';
	var empSeq = '${params.empSeq}';
	var deptSeq = '${params.deptSeq}';
	var compSeq = '${params.compSeq}';
	var selectMode = '${params.selectMode}';
	var selectItem = '${params.selectItem}';
	var callback = '${params.callback}';
	var selectedItems = '${params.selectedItems}';
	var compFilter = "${params.compFilter}";
	var callback = '${params.callback}';
	var nodeChageEvent = '${params.nodeChange}';
	var callbackParam = '${params.callbackParam}';
	var langCode = '${params.langCode}';
	var initMode = '${params.initMode}';   // 관리자, 마스터일 경우 node all open 판단
	var noUseDefaultNodeInfo = '${params.noUseDefaultNodeInfo}';   // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
	var noUseCompSelect = '${params.noUseCompSelect}';   // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
	var isAllDeptEmpShow = '${params.isAllDeptEmpShow}';	 // 하위 부서, 사원 모두 노출
	var isDuplicate = '${params.isDuplicate}';	 // 증복 가능 여부
	var isAllCompShow = '${params.isAllCompShow}';	 // 조직도 전체 노출
	var includeDeptCode = '${params.includeDeptCode}';   // 조직도 내의 부서 (부서코드) 포멧 라벨 사용
	var noUseDeleteBtn = '${params.noUseDeleteBtn}';	 // 삭제 버튼 미사용
	var displayPositionDuty = '${params.displayPositionDuty}';
	var noUseBiz = '${params.noUseBiz}';
	var innerReceiveFlag = '${params.innerReceiveFlag}';   //대내수신여부 플레그값(비영리전자결재전용)
	var eaYn = '${params.eaYn}';   //전자결재전용부서 표시여부
	var authPopYn = '${params.authPopYn}';   //권한부여관리 공통팝업플레그(해당팝업은 조직도 표시/미표시 구분없이 모든사용자 조회되어야함)
	var addtableInfo = '${params.addtableInfo}';	//회사선택팝업 호출 시 추가항목컬럼명 > 회사명(추가항목컬럼값)
	var rootYn = '${params.rootYn}';	//회사선택팝업 호출 시 추가항목컬럼명 > 회사명(추가항목컬럼값)
	var empUniqGroup = '${params.empUniqGroup}';	//그룹설정값
	var empUniqGroupName = '${params.empUniqGroupName}';	//그룹설정값명
	var empUniqGroupSet = '${params.empUniqGroupSet}';	//공통조직도팝업 그룹설정 사용여부 (Y/N)
	var grouppingCompList = '${grouppingCompList}';
	
	var exMyinfoYn = '${params.exMyinfoYn}';		//본인사용자 제외옵션.
	var orgOpenDepth = '${params.orgOpenDepth}';	//조직도 트리 오픈 뎁스
	
	$(document).ready(function() {
		
		fnReady();
		
		if(empUniqGroupSet == "Y"){
			
			$.each(JSON.parse(grouppingCompList), function( index, value ) {
				var groupInfoHtml = "<li onclick='fnGroupSel(this);' empUniqGroup="+value.empUniqGroup+" compSeqStr="+value.compSeqStr+"><div class='org_div'><span class='txt'>";
				groupInfoHtml += "<input type='radio' class='puddSetup' name='radi' pudd-label='"+value.empUniqGroupName+"'/></span>";
				
				if(value.compNameStr != ""){
					var compNameArray = value.compNameStr.split(",");
					var compInfoHtml = "<div class='io_tooltip io_tooltip2'><div class='io_tooltip_in'><div class='io_tooltip_con'><ul>";

					$.each(compNameArray, function( i, val ) {
						if(i == 0){
							var compLength = compNameArray.length-1;
							
							if(compLength > 0){
								groupInfoHtml += "<span class='txt2' onmouseover='tooltip_fc(this);' onmouseout=''>| "+val+" 회사 외 "+compLength.toString()+"개</span>";	
							}else{
								groupInfoHtml += "<span class='txt2' onmouseover='tooltip_fc(this);' onmouseout=''>| "+val+"</span>";	
							}
							
						}
						compInfoHtml += "<li>"+val+"</li>";
					});
					
					compInfoHtml += "</ul></div><div class='semo'></div></div></div>";
					groupInfoHtml += compInfoHtml;
				}
				
				groupInfoHtml += "</div></li>";
				
				$("#groupList").append(groupInfoHtml);
			});
			
		}else{
			fnInit();
		}
		
		/*조직도범위선택*/
			$(".io_tooltip2").mouseleave(function(){
				$(".io_tooltip2").hide();
			});
		$(".org_list").scroll(function(){
			$(".io_tooltip2").hide();;
		});
	});
	
	var paramSet = {};
	
	function fnReady(){
		paramSet.groupSeq = groupSeq;
		paramSet.empSeq = empSeq || '';
		paramSet.deptSeq = deptSeq || '';
		paramSet.compSeq = compSeq || '';
		paramSet.selectMode = selectMode.toLowerCase() || '';
		paramSet.selectItem = selectItem.toLowerCase() || '';
		paramSet.selectedItems = selectedItems || '';
		paramSet.compFilter = compFilter || '';
		paramSet.callback = callback || '';
		paramSet.nodeChageEvent = 'OJTC_fnGetEmpDeptList';
		paramSet.callbackParam = callbackParam || '';
		paramSet.langCode = langCode || '';
		paramSet.initMode = initMode || ''; // 관리자, 마스터일 경우 node all open 판단
		paramSet.noUseDefaultNodeInfo=  noUseDefaultNodeInfo || '';  // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
		paramSet.noUseCompSelect=  noUseCompSelect || '';  // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
		paramSet.includeDeptCode=  includeDeptCode || '';  // 조직도 내의 부서 (부서코드) 포멧 라벨 사용
		paramSet.noUseDeleteBtn=  noUseDeleteBtn || '';  // 삭제 버튼 미사용
		paramSet.isAllDeptEmpShow = isAllDeptEmpShow || '';  // 하위 부서, 사원 모두 노출
		paramSet.isDuplicate = isDuplicate || '';			// 증복 가능 여부
		paramSet.isAllCompShow = isAllCompShow || '';	 // 조직도 전체 노출
		paramSet.isCheckAllDeptEmpShow = false;			// 하위 부서 사원 전체보기 초기값 설정
		paramSet.displayPositionDuty = displayPositionDuty || 'position';
		paramSet.noUseBiz = noUseBiz || '';
		paramSet.innerReceiveFlag = innerReceiveFlag || '';
		paramSet.eaYn = eaYn || '';
		paramSet.authPopYn = authPopYn || '';
		paramSet.addtableInfo = addtableInfo || '';
		paramSet.exMyinfoYn = exMyinfoYn || '';
		paramSet.empUniqYn = 'Y';		

		/* 파라미터 무결 검증 */
		if (!(selectMode)) {
			alert('<%=BizboxAMessage.getMessage("TX000010606","사용자 선택 정보에 오류가 있습니다")%>');
			window.close();
		}
		if (!(selectItem)) {
			alert('<%=BizboxAMessage.getMessage("TX000010605","사용자 선택에 오류가 있습니다")%>');
			window.close();
		}
		if (!callback) {
			alert('<%=BizboxAMessage.getMessage("TX000010604","서버 정보에 오류가 있습니다")%>');
			window.close();
		}
		
		OJTC_documentReadyDf(paramSet);
		OJIL_documentReadyDf(paramSet);
		OJSI_documentReadyDf(paramSet);
		
		/* 옵션에 따른 페이지 정보 변경 */
		fnResizeForm(paramSet);		
		fnSetTitleTxt(paramSet);
		
	}
	
	function fnInit(){
		
		kendo.ui.progress($("body"), true);

		paramSet.compFilter = compFilter || '';

		/** 정의 : /orgchart/include/orgJsTreeControl.jsp  **/
		OJTC_documentReadyInit(paramSet);

		/** 정의 : /orgchart/include/orgJsTree.jsp  **/
		OJT_documentReady(paramSet);

		/** 정의 : /orgchart/include/orgJsSelectedItemList.jsp  **/
		OJIL_documentReadyInit(paramSet);

		/** 정의 : /orgchart/include/orgJsItemList.jsp  **/
		OJSI_documentReadyInit(paramSet);

		/* 저장, 취소 버튼 이벤트 정의 */
		OCB_fnSetBtnEvent_SaveCancel(paramSet);
		
		if(empUniqGroupName != ""){
			$('#txt_orgTitle').append(" ("+empUniqGroupName+")");
		}
		
	}

	function fnSetTitleTxt(defaultInfo) {
		if (defaultInfo.selectMode === 'u') {
			$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX000010603","사원 선택")%>');
		} else if (defaultInfo.selectMode === 'd') {
			$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX000010602","부서 선택")%>');
		} else if (defaultInfo.selectMode === 'ud') {
			$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX000016215","사원,부서 선택")%>');
		} else if (defaultInfo.selectMode === 'oc') {
			$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX000010600","회사 선택")%>');
		} else if (defaultInfo.selectMode === 'od') {
			$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX000010602","부서 선택")%>');
		} else if (defaultInfo.selectMode === 'ob') {
			$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX900000486","사업장 선택")%>');
		}
		
	}

	/* [ 사이즈 변경 ] 옵션 값에 따른 페이지 리폼
	-----------------------------------------------*/
	function fnResizeForm(defaultInfo) {
		if (defaultInfo.selectMode.indexOf('o') > -1) {
			$('#div_org_tree_').width(315);
			$('.pop_wrap').width(349);
			$('.pop_foot').width(349);
			$('.jstreeSet').height(390);
		}
		var strWidth = $('.pop_wrap').outerWidth()
		+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);
		
		$('.pop_wrap').css("overflow","auto");
		$('.jstreeSet').css("overflow","auto");
		
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

	/* [ 저장,취소 ] 저장, 취소 버튼 이벤트 정의
	-----------------------------------------------*/
	function OCB_fnSetBtnEvent_SaveCancel(param) {
		$('#btn_save').click(
				function() {

					var returnParamSet = {};
					returnParamSet.returnObj = new Array();
					returnParamSet.isSave = true;
					returnParamSet.receiveParam = param;
					returnParamSet.callback = param.callback;
					returnParamSet.empUniqGroup = empUniqGroup;
					
					if($("#div_selected_item_list .io_div input:hidden").length > 0){
						
						$.each($("#div_selected_item_list .io_div input:hidden"), function( index, value ) {
							
							returnParamSet.returnObj.push(JSON.parse($(value).val()));
							
						});
						
					}
					
					OCB_fnCall_CallbackFunc(returnParamSet);
				});
		$('#btn_cancel').click(function() {
			parent.window.close();
		});
	}
	
	/* [ 저장,취소 ] 콜백 함수 호출
	-----------------------------------------------*/
	function OCB_fnCall_CallbackFunc(returnParamSet) {
		// Origin source
		
		try{
			var childWindow = window.parent;
			var parentWindow = childWindow.opener;
			$('#hid_returnObj').val(JSON.stringify(returnParamSet));

			if(typeof(childWindow['callbackSelectOrg']) === 'function'){
				childWindow['callbackSelectOrg'](returnParamSet);	
			}else{
				window.opener[callback](returnParamSet);
			}
		}catch(exception){
			var callbackUrl = "${params.callbackUrl}";
			var callbackFunction = "${params.callback}";
			returnParamSet['callback'] = callbackFunction;

			$("#hid_returnObj").val(JSON.stringify(returnParamSet));

			document.middleForm.action = callbackUrl;
			document.middleForm.submit();
		}
		
		window.close();
	}
	
	
//캘린더관리자, 참여자, 공개자 툴팁 생성
		function tooltip_fc(th) { 
			$(".io_tooltip").hide();
			var int_org = $(th).parent().parent();
			var io_div = $(th).parent();	
			var y = io_div.offset().top - $(document).scrollTop();
			var x = io_div.offset().left - $(document).scrollLeft(); 
			var x_th = $(th).offset().left - $(document).scrollLeft(); 
			var tooltipH = io_div.offset().top + io_div.find(".io_tooltip").height();
					
			var doc_wid = $(document).width()
			var win_wid=$(window).width();
			var io_div_wid = io_div.width();
			var tool_wid = io_div.find(".io_tooltip").width();
			var tool_hei = io_div.find(".io_tooltip").height();

			

			 // int_org.find(".io_tooltip").hide();
			  io_div.find(".io_tooltip").show();
			  io_div.find(".io_tooltip").addClass("animated03s fadeInUp");
			  io_div.find(".io_tooltip").css("top",y+20);
			  io_div.find(".io_tooltip").css("left",x);
			  io_div.find(".io_tooltip2").css("left",x_th);
			  io_div.find(".io_tooltip2").css("top",y+30);

			 if ((x+tool_wid) > win_wid && $(".pop_wrap").height() < tooltipH )//***pop_wrap 가 개발에 달라질 수 있음***
			{
				 io_div.find(".io_tooltip").addClass("right");
				 io_div.find(".io_tooltip").addClass("down");
				 io_div.find(".io_tooltip").removeClass("fadeInUp");
				 io_div.find(".io_tooltip").addClass("animated03s fadeInDown");
				  io_div.find(".io_tooltip").css("left","inherit");
				  io_div.find(".io_tooltip").css("right",doc_wid - (x+io_div_wid) - (doc_wid - win_wid) );
				  io_div.find(".io_tooltip").css("top",y - io_div.find(".io_tooltip").height() );
			 
			} else if ( $(".pop_wrap").height() < tooltipH)//***pop_wrap 가 개발에 달라질 수 있음***
			{
				io_div.find(".io_tooltip").addClass("down");
				io_div.find(".io_tooltip").removeClass("fadeInUp");
				io_div.find(".io_tooltip").addClass("animated03s fadeInDown");
				io_div.find(".io_tooltip").css("top",y - io_div.find(".io_tooltip").height() );
				io_div.find(".io_tooltip").css("left",x);


			}  else if ((x+tool_wid) > win_wid  )
			{
			  io_div.find(".io_tooltip").addClass("right");
			  io_div.find(".io_tooltip").css("left","inherit");
			  io_div.find(".io_tooltip").css("right",doc_wid - (x+io_div_wid) - (doc_wid - win_wid) );
			  io_div.find(".io_tooltip").css("top",y+20);
			} else {
				io_div.find(".io_tooltip").removeClass("right");
				io_div.find(".io_tooltip").removeClass("down");
			}

				//조직도범위선택만
			if (io_div.position().top > 450)
			{
					io_div.find(".io_tooltip2").addClass("down");
					io_div.find(".io_tooltip2").css("top",y-tool_hei+10);
					io_div.find(".io_tooltip2").removeClass("fadeInUp");
					io_div.find(".io_tooltip2").addClass("animated03s fadeInDown");
					io_div.find(".io_tooltip2").css("left",x_th);
			}
			  
			  
			return false;
		}
		function tooltip_out_fc(th){ //툴팁 제거
			$(th).parent().parent().find(".io_tooltip").hide();
			$(th).parent().parent().find(".io_tooltip").removeClass("animated03s fadeInUp fadeInDown right down");				 
		}		
		
		function io_close() { //단일 닫기
			$(".io_div .clo").click(function(){
				$(this).parent().addClass("animated05s zoomOutUp");
				setTimeout( function(){$(".io_div.zoomOutUp").remove()} , 310);
				setTimeout( function(){$(".io_div.zoomOutUp").nextAll().addClass("animated03s slideInRight")} , 300);
				setTimeout( function(){$(".int_org").children().removeClass("animated03s slideInRight")} , 700);
				return false;
			});			
		}


	function io_add() { //단일 추가 (개발에 맞게 변경 요망)
		$(".io_div:last-child").addClass("animated03s slideInDown2");
		setTimeout( function(){$(".io_div:last-child").removeClass("animated03s slideInDown2")} , 500);
		return false;

	}

	function io_add_all() { //전체 추가 (개발에 맞게 변경 요망)
		$(".io_div").addClass("animated05s slideInDown2");
		setTimeout( function(){$(".io_div").removeClass("animated05s slideInDown2")} , 550);
		return false;

	}
	
	function fnGroupSet(){
		
		if($("#groupList li .UI-ON").length == 0){
			alert("<%=BizboxAMessage.getMessage("TX900000487","그룹 선택은 필수입니다.")%>");
			return;
		}

		empUniqGroup = $("#groupList li .UI-ON").parents("li").attr("empuniqgroup");
		empUniqGroupName = $("#groupList li .UI-ON input").attr("pudd-label");
		compFilter = $("#groupList li .UI-ON").parents("li").attr("compSeqStr");
		
		$("#groupSelDiv").hide();
		fnInit();
		
	}
	
	function fnGroupSel(obj){

		$("#groupList .UI-ON").removeClass("UI-ON");
		$(obj).find(".PUDD-UI-radio").addClass("UI-ON");
		
	}
	
	function fnJsTreeLoadedEvent(){

		kendo.ui.progress($("body"), false);
		
		//로딩이미지
		$(document).bind("ajaxStart", function () {
			kendo.ui.progress($("body"), true);
		}).bind("ajaxStop", function () {
			kendo.ui.progress($("body"), false);
		});
		
	}	
	
		
	
	
	
	
</script>

<input type="hidden" id="mainDeptYn" value="${params.mainDeptYn}" />
<div id="wrapDiv" class="pop_wrap">

	<div class="pop_head">
		<h1 id="txt_orgTitle"></h1>
		<a href="#n" class="clo"> <img
			src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" />
		</a>
	</div>

	<div class="pop_con">
		<div class="top_box mb10">
		<!--  파츠A
		  
		-->
		<jsp:include page="../include/orgJsTreeControl.jsp" flush="false" />
		
		</div>
	
		<table cellspacing="0" cellpadding="0" style="width:100%;">
			<colgroup>
				<col width="250"/>
				<col width=""/>
			</colgroup>
			<tr>
				<td>
					<div class="fl mt10 mt10" style="width:100%;">
					
						<!--  파츠B
						
						  -->
						  <jsp:include page="../include/orgJsTreeEmpUniq.jsp" flush="false" />
						
					</div>
				</td>
				<td>
					<div class="box_right2 ml10 mt10" style="width:auto;height:auto;">
					
						<!--   파츠C
						   
						-->
						<jsp:include page="../include/orgJsItemListEmpUniq.jsp" flush="false" />
						
						
						<!--   파츠D
						   
						-->
						<jsp:include page="../include/orgJsSelectedItemListEmpUniq.jsp" flush="false" />
						
					</div>
				</td>
			</tr>
		</table>		
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="btn_save" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> 
			<input type="button" id="btn_cancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>

</div>
<input type="hidden" id="hid_od_dept_value">
<input type="hidden" id="hid_oc_comp_value">



<iframe id="middleFrame" name="middleFrame" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>
	
<form id="middleForm" name="middleForm" target="middleFrame" method="post">
	<input type="hidden" id="hid_returnObj" name="returnObj" value="" />
</form>

<c:if test="${params.empUniqGroupSet eq 'Y'}">
<!--조직도 범위 선택 -->
<div id="groupSelDiv" class="org_pop">
	<div class="org_pop_in">
		<p class="tit"><%=BizboxAMessage.getMessage("TX900000488","조직도 범위 선택")%></p>
		<div class="org_list" style="height:470px">
			<ul id="groupList"></ul>
		</div>
		<p class="txt_p"><%=BizboxAMessage.getMessage("TX900000489","※조직도 범위는 최초 한번만 선택합니다. (변경불가)")%></p>
		<div class="btn_c">
			<input onclick="fnGroupSet();" type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
		</div>
	</div>
	<div class="modal"></div>
</div>
</c:if>


