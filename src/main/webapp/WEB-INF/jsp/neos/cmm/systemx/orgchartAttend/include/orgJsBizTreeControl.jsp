<!-- 사용자 조직도 상단 검색 창 구현 -->
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="main.web.BizboxAMessage"%>
<!-- 프로토 타입 정의용 스크립트 -->
<script type="text/javascript">

	/* [Map] declare javascipt hashmap prototype
	========================================*/
	Map = function () {
		this.map = new Object();
	};
	Map.prototype = {
		put: function (key, value) {
			this.map[key] = value;
		},
		get: function (key) {
			return this.map[key];
		},
		containsKey: function (key) {
			return key in this.map;
		},
		containsValue: function (value) {
			for (var prop in this.map) {
				if (this.map[prop] == value) return true;
			}
			return false;
		},
		isEmpty: function (key) {
			return (this.size() == 0);
		},
		clear: function () {
			for (var prop in this.map) {
				delete this.map[prop];
			}
		},
		remove: function (key) {
			delete this.map[key];
		},
		keys: function () {
			var keys = new Array();
			for (var prop in this.map) {
				keys.push(prop);
			}
			return keys;
		},
		values: function () {
			var values = new Array();
			for (var prop in this.map) {
				values.push(this.map[prop]);
			}
			return values;
		},
		size: function () {
			var count = 0;
			for (var prop in this.map) {
				count++;
			}
			return count;
		}
	};
</script>

<!-- 사업장 선택 -->
<div class="top_box_in orgChartTopBox" id="div_org_search_biz">
	<div id="" class="dod_search posi_re">
		<input type="text" class="txt_search_filter" id="text_input" style="width: 380px;text-indent: 4px;" /> 
		<span class="posi_ab text_gray span_result_cnt" style="top: 5px; right: 315px;"></span>
		<!-- 부서일때 -->
		<a href="#n" class="btn_sear btn_search"></a>
	</div>
</div>


<script type="text/javascript">

	/* [페이지 준비] 페이지 로드 완료시 호출
	 * defaultInfo : 팝업 호출시의 옵션및 사용자 기본 정보
	-----------------------------------------------*/
	function OJTC_documentReady(defaultInfo) {
		$('.orgChartTopBox').hide();
		$('#div_org_search_biz').show();

		/* 기본 선택 아이템 조회 */
		OJTC_fnSetSelectedItems(defaultInfo)
		/* 드롭다운 박스 초기화 */
		OJTC_fnSelectBoxInit();
		/* 검색 버튼 초기화 */
		OJTC_fnSetSearchBtnEvent(defaultInfo);
		/* 엔터 검색 기능 적용 */
		OJTC_fnSetKeyPressEvent(defaultInfo);
		/* 하위 부서 사원 전체보기 체크 이벤트 */
		OJTC_fnSetAllDeptEmpShowEvent(defaultInfo);
	}

	/* [ 선택된 아이템 ] 기존 선택 아이템 기본 설정.
	-----------------------------------------------*/
	function OJTC_fnSetSelectedItems(defaultInfo) {
		var items = defaultInfo.selectedItems.split(',');
		var paramBizSet = new Array();
		
		for (var i = 0; i < items.length; i++) {
			var temp = items[i].split('|');
			var obj = {};
			obj.groupSeq = temp[0];
			obj.compSeq = temp[1];
			obj.bizSeq = temp[2];
			obj.itemId = temp[3];
			obj.empBizDiv = temp[4];
			if (obj.empBizDiv === 'b') {
				paramBizSet.push(obj);
			}
		}


		var whereClause_biz = '';
		for (var i = 0; i < paramBizSet.length; i++) {
			var item = paramBizSet[i];
			item.bizSeq = item.bizSeq == '0' ? '' : item.bizSeq;
			
			if(item.empBizDiv === 'b'){
				whereClause_biz += ' OR 	(group_seq=\'' + ( item.groupSeq || '' ) + '\' AND comp_seq = \'' + ( item.compSeq || '\'\'' ) + '\' AND biz_seq = \'' + ( item.bizSeq || '\'\'' ) +'\' AND gbn_org = \'' + ( item.empBizDiv || '' ) + '\') ';	
			}else if(item.empBizDiv === 'c'){
				whereClause_biz += ' OR 	(group_seq=\'' + ( item.groupSeq || '' ) + '\' AND comp_seq = \'' + ( item.compSeq || '\'\'' ) + '\' AND gbn_org = \'' + ( item.empBizDiv || '' ) + '\') ';
			}
			
		}
		var data = {};
		data.whereClause_biz = whereClause_biz;
		data.langCode = defaultInfo.langCode;
		
		
		
		$.ajax({
			async: true
			, type: "post"
			, url: '<c:url value="/cmm/systemx/GetSelectedBizProfileListBiz.do" />'
			, dataType: "json"
			, data: data
			, success: function (result) {
				// function declare : /include/orgJsSelectedItemList.jsp
				OJSI_fnSetSelectedItemList(defaultInfo, result.returnObj);
			}
			, error: function (err) {
				alert(JSON.stringify(err));
			}
		});
	}

	/* [ 검색 ]검색 이벤트 지정
	-----------------------------------------------*/
	function OJTC_fnSetSearchBtnEvent(defaultInfo) {
		$('.btn_search').click(function () {
			OJTC_fnSearch(defaultInfo);
		});
	}
	/* [ 검색 ] 키보드 입력 이벤트 정의
	-----------------------------------------------*/
	function OJTC_fnSetKeyPressEvent(defaultInfo) {
		$('input[type=text]').keydown(function (event) {
			
			if (event.keyCode === 13) {
				event.returnValue = false;
				event.cancelBubble = true;
				OJTC_fnSearch(defaultInfo);
			}else{
				OJTC_fnSetResultCnt({ fullCount: 0, resultCount: 0 });	
			}
		});
	}

	/* [ 검색 ] 데이터 검색
	 * filterData : 이전의 검색이력, 중복 검색 방지
	-----------------------------------------------*/
	function OJTC_fnSearch(defaultInfo) {
		if (!$('.txt_search_filter:visible').val()) { 
			OJTC_fnSetResultCnt({ fullCount: 0, resultCount: 0 });
			alert('<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>');  
		return; }

		//검색 api 호출
		var filter = $('.txt_search_filter:visible').val() || '';
		var selectMode = 'b';
		
		
		var searchResult = {};
		searchResult = OJT_fnSearchItem(defaultInfo,selectMode, filter);
			
		if (searchResult.isSuccess && searchResult.hasResult) {
			defaultInfo.selectedId = searchResult.deptSeq;
		} else if (searchResult.isSuccess && (!searchResult.hasResult)) {
			alert('<%=BizboxAMessage.getMessage("TX000007470","검색 결과가 없습니다.")%>');
		}

		// 검색 결과 갯수 설정
		OJTC_fnSetResultCnt({ fullCount: searchResult.fullCount, resultCount: searchResult.resultCount });
	}

	/* [ 검색 결과 ] 사용자,부서 검색후의 카운팅 표기
	-----------------------------------------------*/
	function OJTC_fnSetResultCnt(param) {
		var fullCnt = param.fullCount || '0';
		if(fullCnt == 0) { $('.span_result_cnt').html(''); return; }
		
		var resultCnt = param.resultCount || '0';
		var dispVal = resultCnt + '/' + fullCnt;
		$('.span_result_cnt').html(dispVal);
	}

	/* [ 검색 결과 ] 사용자,부서 검색후의 카운팅 표기
	-----------------------------------------------*/
	function OJTC_fnSelectBoxInit() {
		//조직도검색 셀렉트
		var data = [{ text: "<%=BizboxAMessage.getMessage("TX000000141","사원")%>", value: "u" }, { text: "<%=BizboxAMessage.getMessage("TX000000098","부서")%>", value: "d" }];
		$("#em_sel").kendoDropDownList({
			dataTextField: "text"
			, dataValueField: "value"
			, dataSource: data
		});
	}

	/* [ 사원, 부서 검색 ] 선택된 노드에 속한 사원, 부서 검색
	 * defaultInfo : 사원 부서 검색 정보
	 * call by : /include/orgJsTree.jsp
	-----------------------------------------------*/
	var nodeParsingData = new Map();
	function OJTC_fnGetEmpDeptList(defaultInfo) {
		
		var key = defaultInfo.orgGubun + defaultInfo.selectedId 
					+ (defaultInfo.isCheckAllDeptEmpShow ? '_1' : '_0') ;
		
		/** map 내에 기존에 검색된 이력이 없으면 검색 진행. **/
		nodeParsingData.containsKey(key) || $.ajax({
		//nodeParsingData.containsKey(defaultInfo.selectedId) || $.ajax({	// 기존
			async: false
			, type: "post"
			, url: '<c:url value="/cmm/systemx/GetBizProfileListForBiz.do" />'
			, dataType: "json"
			, data: defaultInfo
			, success: function (result) {
				// console.log(JSON.stringify(result));
				//nodeParsingData.put(defaultInfo.selectedId, result.returnObj); //기존
				nodeParsingData.put(key, result.returnObj);
			}
			, error: function (err) {
				alert('<%=BizboxAMessage.getMessage("TX000010615","서버와 연결에 실패하였습니다")%>');
			}
		});

		if(defaultInfo.selectMode.indexOf('o') === -1){
			// function declare : /include/orgJsItemList.jsp
			//OJIL_fnSetItemList(defaultInfo, nodeParsingData.get(defaultInfo.selectedId));   //기존
			OJIL_fnSetItemList(defaultInfo, nodeParsingData.get(key));
		}
	}
	
	/* [ 기능옵션 ] 하위 부서 사원 전체보기 체크 이벤트.
	-----------------------------------------------*/
	function OJTC_fnSetAllDeptEmpShowEvent(defaultInfo) {
		var isShow = defaultInfo.isAllDeptEmpShow;
		if(isShow) {
			console.log("true");
			$(".allDeptEmpShow").show();
		} else {
			console.log("false");
			$(".allDeptEmpShow").hide();
		}
		
		$("input:checkbox.allDeptEmpShow").click(function(){
			if($(this).prop("checked")) {
				defaultInfo.isCheckAllDeptEmpShow=true;		
			} else {
				defaultInfo.isCheckAllDeptEmpShow=false;
			}
			OJTC_fnGetEmpDeptList(defaultInfo);
		});
	}	

</script>
