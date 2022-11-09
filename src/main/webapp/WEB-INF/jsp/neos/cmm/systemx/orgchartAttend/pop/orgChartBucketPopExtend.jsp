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
	var selectMainTitle = '${params.selectMainTitle}';
	var callback = '${params.callback}';
	var selectedItems = '${params.selectedItems}';
	var selectedItems1 = '${params.selectedItems1}';
	var selectedItems2 = '${params.selectedItems2}';
	var compFilter = '${params.compFilter}';
	var callback = '${params.callback}';
	var callback1 = '${params.callback1}';
	var callback2 = '${params.callback2}';
	var nodeChageEvent = '${params.nodeChange}';
	var callbackParam = '${params.callbackParam}';
	var langCode = '${params.langCode}';
	var initMode = '${params.initMode}';   // 관리자, 마스터일 경우 node all open 판단
	var noUseDefaultNodeInfo = '${params.noUseDefaultNodeInfo}';   // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
	var noUseCompSelect = '${params.noUseCompSelect}';   // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
	
	var includeDeptCode = '${params.includeDeptCode}';   // 조직도 내의 부서 (부서코드) 포멧 라벨 사용
	var noUseDeleteBtn = '${params.noUseDeleteBtn}';	 // 삭제 버튼 미사용
	var isAllDeptEmpShow = '${params.isAllDeptEmpShow}';	 // 하위 부서, 사원 모두 노출
	var isDuplicate = '${params.isDuplicate}';	 // 증복 가능 여부
	var extendSelectAreaCount = '${params.extendSelectAreaCount}';	 // 확장된 선택 영역 갯수
	var extendSelectAreaInfo = '${params.extendSelectAreaInfo}';
	var eaYn = '${params.eaYn}';
	var orgOpenDepth = '${params.orgOpenDepth}';	//조직도 트리 오픈 뎁스
	
	$(document).ready(function() {
		var paramSet = {};
		paramSet.groupSeq = groupSeq;
		paramSet.empSeq = empSeq || '';
		paramSet.deptSeq = deptSeq || '';
		paramSet.compSeq = compSeq || '';
		paramSet.selectMode = selectMode.toLowerCase() || '';
		paramSet.selectItem = selectItem.toLowerCase() || '';
		paramSet.selectMainTitle = selectMainTitle || '';

		paramSet.selectedItems = selectedItems || '';
		paramSet.selectedItems1 = selectedItems1 || '';
		paramSet.selectedItems2 = selectedItems2 || '';
		paramSet.compFilter = compFilter || '';

		paramSet.callback = callback || '';
		paramSet.callback1 = callback1 || '';
		paramSet.callback2 = callback2 || '';
		paramSet.nodeChageEvent = 'OJTC_fnGetEmpDeptList';
		paramSet.callbackParam = callbackParam || '';

		paramSet.langCode = langCode || '';
		paramSet.initMode = initMode || ''; // 관리자, 마스터일 경우 node all open 판단
		
		paramSet.noUseDefaultNodeInfo=  noUseDefaultNodeInfo || '';  // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
		paramSet.noUseCompSelect=  noUseCompSelect || '';  // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
		
		paramSet.includeDeptCode=  includeDeptCode || '';  // 조직도 내의 부서 (부서코드) 포멧 라벨 사용
		
		paramSet.eaYn = eaYn || '';
		
		paramSet.noUseDeleteBtn=  noUseDeleteBtn || '';  // 삭제 버튼 미사용
		paramSet.isAllDeptEmpShow = isAllDeptEmpShow || '';  // 하위 부서, 사원 모두 노출
		paramSet.isDuplicate = isDuplicate || '';			// 증복 가능 여부
		paramSet.isCheckAllDeptEmpShow = false;			// 하위 부서 사원 전체보기 초기값 설정
		paramSet.extendSelectAreaCount = extendSelectAreaCount;	 // 확장된 선택 영역 갯수
		paramSet.extendSelectAreaInfo = extendSelectAreaInfo;	 // 확장된 선택 영역 갯수
			
		
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
		if(extendSelectAreaCount > 1) {
			var count = extendSelectAreaCount;
			var extendInfoArray = extendSelectAreaInfo.split("$");
			var extendInfoCount = extendSelectAreaInfo.split("$").length;
			
			for(var i=0; i < extendInfoArray.length; i++) {
				var selectedMode = extendInfoArray[i].split("|")[1];
				var optionCheck = false;
				
				if(selectedMode != "s" && selectedMode != "m") {
					optionCheck = true;
				}
			}
			if(optionCheck) {
				alert("잘못된 선택모드를 입력했습니다.(s,m)");
				window.close();
			}
			if(count != extendInfoCount) {
				alert("확장 영역 갯수를 잘못 입력했습니다.");
				window.close();	
			}
			
		}

		/** 정의 : /orgchart/include/orgJsTreeControl.jsp  **/
		OJTC_documentReady(paramSet);

		/** 정의 : /orgchart/include/orgJsTree.jsp  **/
		OJT_documentReady(paramSet);

		/** 정의 : /orgchart/include/orgJsSelectedItemList.jsp  **/
		OJIL_documentReady(paramSet);

		/** 정의 : /orgchart/include/orgJsItemList.jsp  **/
		OJSI_documentReady(paramSet);
		
		/* 저장, 취소 버튼 이벤트 정의 */
		OCB_fnSetBtnEvent_SaveCancel(paramSet);

		
		/* 옵션에 따른 페이지 정보 변경 */
		fnResizeForm(paramSet);
		fnSetTitleTxt(paramSet);
	});

	function fnSetTitleTxt(defaultInfo) {
		if(defaultInfo.selectMainTitle == "") {
			if (defaultInfo.selectMode === 'u') {
				$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX000010603","사원 선택")%>');
			} else if (defaultInfo.selectMode === 'd') {
				$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX000010602","부서 선택")%>');
			} else if (defaultInfo.selectMode === 'ud') {
				$('#txt_orgTitle').html('<%=BizboxAMessage.getMessage("TX000016215","사원,부서 선택")%>');
			} else if (defaultInfo.selectMode === 'oc') {
				$('#txt_orgTitle').html('<%=BizboxAMessage.getMessage("TX000010600","회사 선택")%>');
			} else if (defaultInfo.selectMode === 'od') {
				$('#txt_orgTitle').html('<%=BizboxAMessage.getMessage("TX000010602","부서 선택")%>');
			}	
		} else {
			$("#txt_orgTitle").html(defaultInfo.selectMainTitle);
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
			childWindow.resizeTo("1220", "770");	
		}catch(exception){
			console.log('window resizing cat not run dev mode.');
		}
		
	}

	/* [ 저장,취소 ] 저장, 취소 버튼 이벤트 정의
	-----------------------------------------------*/
	function OCB_fnSetBtnEvent_SaveCancel(param) {
		$('#btn_save').click( function() {
			var returnParamSet = {};
			returnParamSet.returnObj = new Array();
			returnParamSet.isSave = true;
			returnParamSet.receiveParam = param;
			returnParamSet.callback = param.callback;
			
			
			if (param.selectMode.indexOf('o') === -1) {
				if(param.extendSelectAreaCount == "1"){
					if ($('.selectedItemRow input:checkbox').length) {
						$('.selectedItemRow input:checkbox')
								.each(
										function(index, item) {
											if ($(item).val()) {
												var obj = JSON
														.parse($(item)
																.val());
												returnParamSet.returnObj
														.push(obj);
											}
										});
					} else {
						if ($('.selectedItemRow > input').val()) {
							var obj = JSON.parse($(
									'.selectedItemRow > input').val());
							returnParamSet.returnObj.push(obj);
						}
					}	
				} else if(param.extendSelectAreaCount == "2") {
					if ($('.selectedItemRow input:checkbox').length) {
						$('.selectedItemRow input:checkbox')
								.each(
										function(index, item) {
											if ($(item).val()) {
												var obj = JSON
														.parse($(item)
																.val());
												obj.flag = "area1";
												returnParamSet.returnObj
														.push(obj);
											}
										});
					} else {
						if ($('.selectedItemRow > input').val()) {
							var obj = JSON.parse($(
									'.selectedItemRow > input').val());
							obj.flag = "area1";
							returnParamSet.returnObj.push(obj);
						}
					}
					
					if ($('.selectedItemRow1 input:checkbox').length) {
						$('.selectedItemRow1 input:checkbox')
								.each(
										function(index, item) {
											if ($(item).val()) {
												var obj = JSON
														.parse($(item)
																.val());
												obj.flag = "area2";
												returnParamSet.returnObj
														.push(obj);
											}
										});
					} else {
						if ($('.selectedItemRow1 > input').val()) {
							var obj = JSON.parse($(
									'.selectedItemRow1 > input').val());
							obj.flag = "area2";
							returnParamSet.returnObj.push(obj);
						}
					}
				} else if(param.extendSelectAreaCount == "3") {
					if ($('.selectedItemRow input:checkbox').length) {
						$('.selectedItemRow input:checkbox')
								.each(
										function(index, item) {
											if ($(item).val()) {
												var obj = JSON
														.parse($(item)
																.val());
												returnParamSet.returnObj
														.push(obj);
											}
										});
					} else {
						if ($('.selectedItemRow > input').val()) {
							var obj = JSON.parse($(
									'.selectedItemRow > input').val());
							returnParamSet.returnObj.push(obj);
						}
					}
					
					if ($('.selectedItemRow1 input:checkbox').length) {
						$('.selectedItemRow1 input:checkbox')
								.each(
										function(index, item) {
											if ($(item).val()) {
												var obj = JSON
														.parse($(item)
																.val());
												obj.flag = "area1";
												returnParamSet.returnObj
														.push(obj);
											}
										});
					} else {
						if ($('.selectedItemRow1 > input').val()) {
							var obj = JSON.parse($(
									'.selectedItemRow1 > input').val());
							obj.flag = "area1";
							returnParamSet.returnObj.push(obj);
						}
					}
					
					if ($('.selectedItemRow2 input:checkbox').length) {
						$('.selectedItemRow2 input:checkbox')
								.each(
										function(index, item) {
											if ($(item).val()) {
												var obj = JSON
														.parse($(item)
																.val());
												obj.flag = "area2";
												returnParamSet.returnObj
														.push(obj);
											}
										});
					} else {
						if ($('.selectedItemRow2 > input').val()) {
							var obj = JSON.parse($(
									'.selectedItemRow2 > input').val());
							obj.flag = "area2";
							returnParamSet.returnObj.push(obj);
						}
					}
				}
				
			} else {
				
				returnParamSet.returnObj = OJT_fnReturnNodeInfo(param);
				if(returnParamSet.returnObj === 'c'){
					alert('<%=BizboxAMessage.getMessage("TX000010599","부서를 선택하여 주세요")%>');
					return;
				}
			}
			
			OCB_fnCall_CallbackFunc(returnParamSet);
			
		});
		$('#btn_cancel').click(function() {
			var returnParamSet = {};
			returnParamSet.returnObj = new Array();
			returnParamSet.isSave = false;
			returnParamSet.receiveParam = param;
			returnParamSet.callback = param.callback;
			OCB_fnCall_CallbackFunc(returnParamSet);
		});
	}

	/* [ 저장,취소 ] 콜백 함수 호출
	-----------------------------------------------*/
	function OCB_fnCall_CallbackFunc(returnParamSet) {

		try{
			var childWindow = window.parent;
			var parentWindow = childWindow.opener;
			$('#hid_returnObj').val(JSON.stringify(returnParamSet));
			$('#hid_returnObj1').val(JSON.stringify(returnParamSet));
			$('#hid_returnObj2').val(JSON.stringify(returnParamSet));

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
			$('#hid_returnObj1').val(JSON.stringify(returnParamSet));
			$('#hid_returnObj2').val(JSON.stringify(returnParamSet));

			document.middleForm.action = callbackUrl;
			document.middleForm.submit();
		}
		
		window.close();
	}
</script>


<input type="hidden" id="mainDeptYn" value="${params.mainDeptYn}" />
<!-- <div class="pop_wrap" style="width: 748px;"> -->
<div class="pop_wrap">
	<div class="pop_head">
		<h1 id="txt_orgTitle"></h1>
		<a href="#n" class="clo"> <img
			src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" />
		</a>
	</div>

	<div class="pop_con">
		<div class="top_box mb10" style="width:695px;">
			<!--  파츠A  -->
			<jsp:include page="../include/orgJsTreeExtendControl.jsp" flush="false" />
		</div>

		<!--  파츠B  -->
		<jsp:include page="../include/orgJsTree.jsp" flush="false" />

		<div class="box_right2" style="width: 389px; height: auto;">
			<!--   파츠C   -->
			<jsp:include page="../include/orgExtendJsItemList.jsp" flush="false" />
			
		</div>
		
		<c:if test="${params.extendSelectAreaCount == '1' }">
			<div class="sele_set posi_ab" style="top:53px; right:16px;" id="div_selectBox1">
				
				<div class="trans_tool">
					<ul class="tool_u1" style="margin-top: 265px;">
						<li><a href="javascript:;" class="a_insertInfo" id="div"><img src="/gw/Images/btn/btn_arr01.png" alt="" /></a></li>
						<li><a href="javascript:;" class="a_deleteInfo" id="div"><img src="/gw/Images/btn/btn_arr02.png" alt="" /></a></li>
					</ul>
				</div>
			
				<div class="box_right3 fr p15 ml0" style="width:388px;height:546px;">
					<!--   파츠D   -->
					<jsp:include page="../include/orgJsSelectedItemList1.jsp" flush="false" />
				</div>
			</div>
		</c:if>
		
		<c:if test="${params.extendSelectAreaCount == '2' }">
			<div class="sele_set posi_ab" style="top:53px; right:16px;" id="div_selectBox2">
				
				<div class="trans_tool">
					<ul class="tool_u1" style="margin-top: 150px;">
						<li><a href="javascript:;" class="a_insertInfo" id="div"><img src="/gw/Images/btn/btn_arr01.png" alt="" /></a></li>
						<li><a href="javascript:;" class="a_deleteInfo" id="removeDiv"><img src="/gw/Images/btn/btn_arr02.png" alt="" /></a></li>
					</ul>
					<ul class="tool_u1" style="margin-top: 220px;">
						<li><a href="javascript:;" class="a_insertInfo" id="div1"><img src="/gw/Images/btn/btn_arr01.png" alt="" /></a></li>
						<li><a href="javascript:;" class="a_deleteInfo" id="removeDiv1"><img src="/gw/Images/btn/btn_arr02.png" alt="" /></a></li>
					</ul>
				</div>
				
				<div class="box_right3 fr p15 ml0" style="width:388px;height:546px;">
					<!--   파츠D   -->
					<jsp:include page="../include/orgJsSelectedItemList2.jsp" flush="false" />
				</div>
			</div>		
		</c:if>
		
		<c:if test="${params.extendSelectAreaCount == '3' }">
			<div class="sele_set posi_ab" style="top:53px; right:16px;" id="div_selectBox3">
				
				<div class="trans_tool">
					<ul class="tool_u1" style="margin-top: 105px;">
						<li><a href="javascript:;" class="a_insertInfo" id="div"><img src="/gw/Images/btn/btn_arr01.png" alt="" /></a></li>
						<li><a href="javascript:;" class="a_deleteInfo" id="removeDiv"><img src="/gw/Images/btn/btn_arr02.png" alt="" /></a></li>
					</ul>
					<ul class="tool_u1" style="margin-top: 130px;">
						<li><a href="javascript:;" class="a_insertInfo" id="div1"><img src="/gw/Images/btn/btn_arr01.png" alt="" /></a></li>
						<li><a href="javascript:;" class="a_deleteInfo" id="removeDiv1"><img src="/gw/Images/btn/btn_arr02.png" alt="" /></a></li>
					</ul>
					<ul class="tool_u1" style="margin-top: 130px;">
						<li><a href="javascript:;" class="a_insertInfo" id="div2"><img src="/gw/Images/btn/btn_arr01.png" alt="" /></a></li>
						<li><a href="javascript:;" class="a_deleteInfo" id="removeDiv2"><img src="/gw/Images/btn/btn_arr02.png" alt="" /></a></li>
					</ul>
				</div>
				
				<div class="box_right3 fr p15 ml0" style="width:388px;height:546px;">
					<!--   파츠D   -->
					<jsp:include page="../include/orgJsSelectedItemList3.jsp" flush="false" />
				</div>
			</div>		
		</c:if>
	</div>

			
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="btn_save" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> <input
				type="button" id="btn_cancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>

</div>
<input type="hidden" id="hid_od_dept_value">
<input type="hidden" id="hid_oc_comp_value">



<iframe id="middleFrame" name="middleFrame" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>
	
<form id="middleForm" name="middleForm" target="middleFrame" method="post">
	<input type="hidden" id="hid_returnObj" name="returnObj" value="" />
	<input type="hidden" id="hid_returnObj1" name="returnObj1" value="" />
	<input type="hidden" id="hid_returnObj2" name="returnObj2" value="" />
</form>