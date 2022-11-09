<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">



<script type="text/javascript">

	var groupSeq = '${params.groupSeq}';
	var empSeq = '${params.empSeq}';
	var deptSeq = '${params.deptSeq}';
	var compSeq = '${params.compSeq}';
	
	var selectMode = '${params.selectMode}';
	var selectItem = '${params.selectItem}';
	
	var compFilter = '${params.compFilter}';
	
	var nodeChageEvent = '${params.nodeChange}';

	$(document).ready(function() {

		/*
			[ parameter validate]
			파라미터 내용은 공통팝업 문서 확인
			문서 외 추가 nodeChangeEvent
		*/
		
		var paramSet = {};
		// 트리 최초 기본 선택 부서 값 변경 / 기본값 loginVO 사용.
		paramSet.groupSeq = groupSeq;
		paramSet.empSeq = empSeq || '';
		paramSet.deptSeq = deptSeq || '';
		paramSet.compSeq = compSeq || '';
		
		// 트리 구조 선택 값.
		paramSet.selectMode = selectMode.toLowerCase() || '';
		paramSet.selectItem = selectItem.toLowerCase() || '';
		
		// 트리 구성 요소 선택 값.
		paramSet.compFilter = compFilter || '';
		
		// 노트 체인지 이벤트 델리게이터 = 'event name'
		paramSet.nodeChageEvent = 'nodeSelectEvent';
		
		/** 정의 : /orgchart/include/orgJsTree.jsp  **/
		/* 트리 노드 초기화 호출. 해당 function 모든 작업 전 실행. */
		OJT_documentReady(paramSet);
		
	});

	/* 노드 체인지 이벤트 
	--------------------------------------------*/
	function nodeSelectEvent(params){
		alert(JSON.stringify(params));
	}

</script>


<%
	/* 
		작성자 : 최상배
		devMode 파라미터는 groupSeq사용.
		Domain 상황에 맞는 파일 경로 지정.
		개발을 제외한 경우의 페이지는 GW컨테이너의 것을 공통 사용하며, 관리.
	*/	
	String path = "";
	 
	if (request.getParameter("devMode") != null && (request.getParameter("devMode").toString().equals("dev"))) {
		// 데모서버 업로드 시 사용.
		path = "/WEB-INF/jsp/neos/cmm/systemx/orgchart/include/orgJsTree.jsp";
	} else {
		// 개발 중 사용.
		path = request.getParameter("treeUrl");
	}
%>

<!-- JS트리 호출 -->
<div class="pop_con">
	<jsp:include page="<%= path %>" flush="false" />
</div>

