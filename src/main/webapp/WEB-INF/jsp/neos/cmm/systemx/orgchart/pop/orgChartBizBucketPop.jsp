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
	var callback = '${params.callback}';
	var selectedItems = '${params.selectedItems}';
	var compFilter = '${params.compFilter}';
	var callback = '${params.callback}';
	var nodeChageEvent = '${params.nodeChange}';
	var callbackParam = '${params.callbackParam}';
	var langCode = '${params.langCode}';
	var initMode = '${params.initMode}';   // 관리자, 마스터일 경우 node all open 판단
	var noUseDefaultNodeInfo = '${params.noUseDefaultNodeInfo}';   // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
	var noUseCompSelect = '${params.noUseCompSelect}';   // 관리자, 마스터일 경우 기본 노드 선택 여부 결정.
	var isAllDeptEmpShow = '${params.isAllDeptEmpShow}';	 // 하위 부서, 사원 모두 노출
	var isDuplicate = '${params.isDuplicate}';	 // 증복 가능 여부
	
	var includeDeptCode = '${params.includeDeptCode}';   // 조직도 내의 부서 (부서코드) 포멧 라벨 사용
	var noUseDeleteBtn = '${params.noUseDeleteBtn}';	 // 삭제 버튼 미사용
	
	$(document).ready(function() {
		var paramSet = {};
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
		paramSet.isCheckAllDeptEmpShow = false;			// 하위 부서 사원 전체보기 초기값 설정
		
		

		if (!callback) {
			alert('<%=BizboxAMessage.getMessage("TX000010604","서버 정보에 오류가 있습니다")%>');
			window.close();
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
		$('#txt_orgTitle').append('<%=BizboxAMessage.getMessage("TX900000486","사업장 선택")%>');
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

					if (param.selectMode.indexOf('o') === -1) {
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
		// Origin source
		
		try{
			var childWindow = window.parent;
			var parentWindow = childWindow.opener;
			$('#hid_returnObj').val(JSON.stringify(returnParamSet));

			if(typeof(childWindow['callbackSelectBiz']) === 'function'){
				childWindow['callbackSelectBiz'](returnParamSet);	
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
</script>


<input type="hidden" id="mainDeptYn" value="${params.mainDeptYn}" />
<div class="pop_wrap" style="width: 748px;">

	<div class="pop_head">
		<h1 id="txt_orgTitle"></h1>
		<a href="#n" class="clo"> <img
			src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" />
		</a>
	</div>

	<div class="pop_con">
		<div class="top_box mb10">
			<!--  파츠A  -->
			<jsp:include page="../include/orgJsBizTreeControl.jsp" flush="false" />
		</div>

		<!--  파츠B  -->
		<jsp:include page="../include/orgJsBizTree.jsp" flush="false" />

		<div class="box_right2 fr" style="width: 402px; height: auto;">
			<!--   파츠C   -->
			<jsp:include page="../include/orgJsBizItemList.jsp" flush="false" />
			<!--   파츠D   -->
			<jsp:include page="../include/orgJsBizSelectedItemList.jsp"
				flush="false" />
		</div>
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
</form>