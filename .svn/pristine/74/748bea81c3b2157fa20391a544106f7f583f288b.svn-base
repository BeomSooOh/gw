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
	// 페이징 변수
	var currentPage = 1;
	var pageSize = 5;
	var prev = 0;
	var next = 0;
	var first = 0;
	var last = 0;
	var totalCount = 0;
	var moreYN = "N";

	// 테스트용 변수, 파라미터로 수신할 필요가 있음.
	var groupSeq = '${params.groupSeq}';
	var empSeq = '${params.empSeq}';
	var deptSeq = '${params.deptSeq}';
	var compSeq = '${params.compSeq}';
	var callback = '${params.callback}';
	var selectedItems = '${params.selectedItems}';
	var langCode = '${params.langCode}';
	
	var projectCode = '';
	var projectName = '';

	$(document).ready(function() {
		var paramSet = {};
		paramSet.groupSeq = groupSeq || '';
		paramSet.empSeq = empSeq || '';
		paramSet.deptSeq = deptSeq || '';
		paramSet.compSeq = compSeq || '';
		paramSet.callback = callback || '';
		paramSet.selectedItems = selectedItems || '';
		paramSet.langCode = langCode || '';
		
		
		//기본버튼
		$(".controll_btn button").kendoButton();

		// 프로젝트 데이터 가져오기
		fnGetProject();

		// 팝업 사이즈 조절
		fnResizeForm();
		
		fnButtonEvent();
		
		fnSaveCancelEvent(paramSet);
	});
	
	function fnButtonEvent() {		
		// 검색버튼
		$("#searchButton").click(function(){
			
		});
	}

	// 프로젝트 데이터 가져오기
	function fnGetProject() {
		var param = {};
		param.groupSeq = groupSeq || '';
		param.empSeq = empSeq || '';
		param.compSeq = compSeq || '';
		param.page = currentPage;
		param.pageSize = pageSize;

		$.ajax({
			type : "POST",
			url : '<c:url value="/systemx/projectData.do" />',
			data : param,
			success : function(result) {
				fnGetProjectDraw(result.result.list);
				fnPagingInfo(result);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000017328","조회하는데 오류가 발생하였습니다.")%>");
			}
		});
	}

	// 프로젝트 데이터 그려주기
	function fnGetProjectDraw(data) {
		var length = data.length;
		var tag = '';

		if (length == "0") {

		} else {
			for (var i = 0; i < length; i++) {
				tag += '<tr id="' + data[i].noProject + '" onclick="onSelect(this);" class="' + data[i].nmProject + '">';
				tag += '<td>' + data[i].noProject + '</td>';
				tag += '<td>' + data[i].nmProject + '</td>';
				tag += '</tr>';
			}

		}

		$("#projectList").html(tag);
	}
	
	// 프로젝트 클릭 이벤트
	function onSelect(e) {
		projectCode = e.id;
		projectName = e.className;
		
		
		var tbody = document.getElementById("projectList");
		var tr = tbody.getElementsByTagName("tr");

		for (var i = 0; i < tr.length; i++)
			tr[i].style.background = "white";
		e.style.backgroundColor = "#E6F4FF";

	}
	
	// 저장버튼 fnSaveCallback
	function fnSaveCancelEvent(param) {
		$('#saveButton').click(function() {
			var returnParamSet = {};
			var projectParam = {};
			returnParamSet.returnObj = new Array();
			returnParamSet.isSave = true;
			returnParamSet.callback = param.callback;
			projectParam.projectCode = projectCode;
			projectParam.projectName = projectName;
			
			returnParamSet.returnObj.push(projectParam);
			
			fnProjectCallback(returnParamSet);
		});
		$('#cancelButton').click(function() {
			var returnParamSet = {};
			returnParamSet.returnObj = new Array();
			returnParamSet.isSave = false;
			returnParamSet.callback = param.callback;
			
			fnProjectCallback(returnParamSet);
		});
	}
	
	// 저장, 취소 콜백 함수
	function fnProjectCallback(returnParamSet) {
		try{
			var childWindow = window.parent;
			var parentWindow = childWindow.opener;
			$('#hid_returnObj').val(JSON.stringify(returnParamSet));
			
			if(typeof(childWindow['callbackSelectProject']) === 'function'){
				childWindow['callbackSelectProject'](returnParamSet);	
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
	
	// 페이징 데이터
	function fnPagingInfo(data) {
		var preStr = '';
		var postStr = '';
		var str = '';
		
		
		
		totalCount = parseInt(data.result.totalCount);
		totalPage = parseInt( totalCount / pageSize ) + 1;
		currentPage = parseInt(data.result.currentPage);
		
		first = (parseInt((currentPage-1)/pageSize)*pageSize) + 1;
		last = (parseInt(totalPage/pageSize) == parseInt(currentPage/pageSize)) ? totalPage%pageSize : pageSize;
		prev = (parseInt((currentPage-1)/pageSize)*pageSize) -9 > 0 ? (parseInt((currentPage-1)/pageSize)*pageSize) - 9 : 1;
		next = (parseInt((currentPage-1)/pageSize)+1) * pageSize + 1 < totalPage ? (parseInt((currentPage-1)/pageSize)+1) * pageSize + 1 : totalPage;
		
		if(currentPage == (next-1)) {
			last = pageSize;
		}

		if(totalPage > 10){ //전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
	        preStr += "<span class='pre_pre'><a href='javascript:goPage(" + ((first-1)==0?1:first-1) + ")'><%=BizboxAMessage.getMessage("TX000017354","10페이지전")%></a></span>" +
	                "<span class='pre'><a href='javascript:goPage(" + ((currentPage-1)==0?1:currentPage-1) + ")'><%=BizboxAMessage.getMessage("TX000003165","이전")%></a></span>";
	    }
	    else if(totalPage <=10 && totalPage > 1){ //전체 인덱스가 10보다 작을경우, 맨앞 태그 작성
	    	preStr += "<span class='pre_pre'><a href='javascript:goPage(" + ((first-1)==0?1:first-1) + ")'><%=BizboxAMessage.getMessage("TX000017354","10페이지전")%></a></span>" +
            "<span class='pre'><a href='javascript:goPage(" + ((currentPage-1)==0?1:currentPage-1) + ")'><%=BizboxAMessage.getMessage("TX000003165","이전")%></a></span>";
	    	
            //preStr += "<span class='pre_pre'><a href='javascript:goPage(1)'>10페이지전</a></span>";
	    }
	     
	    if(totalPage > 10){ //전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
	        postStr += "<span class='nex'><a href='javascript:goPage(" + (currentPage+1) + ")'><%=BizboxAMessage.getMessage("TX000003164","다음")%></a></span>" +
	                    "<span class='nex_nex'><a href='javascript:goPage(" + ((first+last)==totalPage?totalPage:(first+last)) + ")'><%=BizboxAMessage.getMessage("TX000017355","다음10페이지")%></a></span>";
	    }
	    else if(totalPage <=10 && totalPage > 1){ //전체 인덱스가 10보다 작을경우, 맨뒤 태그 작성
	    	postStr += "<span class='nex'><a href='javascript:goPage(" + (currentPage+1) + ")'><%=BizboxAMessage.getMessage("TX000003164","다음")%></a></span>" +
            "<span class='nex_nex'><a href='javascript:goPage(" + ((first+last)==totalPage?totalPage:(first+last)) + ")'><%=BizboxAMessage.getMessage("TX000017355","다음10페이지")%></a></span>";
	    	
            //postStr += "<span class='nex_nex'><a href='javascript:goPage(" + totalPage + ")'>다음10페이지</a></span>";
	    }
	    str += '<ol>';
	    for(var i=first; i<(first+last); i++){
	        if(i != currentPage){
	            str += "<li id='page_" + i + "' class='page'><a href='javascript:goPage(" + i + ")'>"+i+"</a></li>";
	        }
	        else{
	            str += "<li id='page_" + i + "' class='page'><a href='javascript:goPage(" + i + ")'>"+i+"</a></li>";
	        }
	    }
	    str += '</ol>';
	    
	    $("#pagingView").html(preStr + str + postStr);
	    
	    $(".page").removeClass("on");
		$("#page_" + currentPage).addClass("on");
	}
	
	function goPage(selPage) {
		currentPage = selPage;
		
		
		fnGetProject();
	}
	
	
	
	// 팝업 사이즈 조절
	function fnResizeForm() {
		$(".location_info").css("display", "none");
		$(".iframe_wrap").css("padding", "0");

		var strWidth = $('.pop_wrap').outerWidth()
				+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);

		$('.pop_wrap').css("overflow", "auto");
		//$('.jstreeSet').css("overflow","auto");

		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;

		if (isFirefox) {

		}
		if (isIE) {
			$(".pop_foot").css("width", strWidth);
		}
		if (isEdge) {

		}
		if (isChrome) {
		}

		try {
			window.resizeTo(strWidth, strHeight);
		} catch (exception) {
			console.log('window resizing cat not run dev mode.');
		}
	}
</script>

<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000007467","프로젝트 선택")%></h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">
		<div class="top_box clear">
			<dl class="dl2">
				<dt><%=BizboxAMessage.getMessage("TX000000399","검색어")%></dt>
				<dd>
					<input id="text_input" type="text" style="width: 150px;" value="" />
				</dd>
				<!-- 				<dt>사용여부</dt> -->
				<!-- 				<dd> -->
				<!-- 					<input type="radio" name="type_rasel" id="type_rasel1" class="k-radio" checked > -->
				<!-- 					<label class="k-radio-label radioSel" for="type_rasel1">사용</label> -->
				<!-- 					<input type="radio" name="type_rasel" id="type_rasel2" class="k-radio"> -->
				<!-- 					<label class="k-radio-label radioSel ml10" for="type_rasel2">전체(미사용 포함)</label> -->
				<!-- 				</dd> -->
				<dd class="ml10">
					<input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
				</dd>
			</dl>
		</div>

		<!-- 테이블 -->

		<div class="com_ta2 bg_lightgray mt14">
			<table id="example">
				<colgroup>
					<col width="">
					<col width="" />
				</colgroup>
				<thead>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000528","프로젝트코드")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%></th>
					</tr>
				</thead>
				<tbody id="projectList">
				</tbody>
			</table>
		</div>

		<!-- 페이징 -->
		<div class="paging mt20" id="pagingView">
		<!--	<span class="pre_pre"><a href="">10페이지전</a></span>
			<span class="pre"><a href="">이전</a></span>
			 	<ol id="pagingList">
					<li class="on"><a href="">1</a></li>
					<li><a href="">2</a></li>
					<li><a href="">3</a></li>
					<li><a href="">4</a></li>
					<li><a href="">5</a></li>
					<li><a href="">6</a></li>
					<li><a href="">7</a></li>
					<li><a href="">8</a></li>
					<li><a href="">9</a></li>
					<li><a href="">10</a></li>
				</ol>
			<span class="nex"><a href="">다음</a></span>
			<span class="nex_nex"><a href="">10페이지다음</a></span> -->
		</div>

	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input id="saveButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> 
			<input id="cancelButton" type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>
	<!-- //pop_foot -->

</div>

<iframe id="middleFrame" name="middleFrame" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>

<form id="middleForm" name="middleForm" target="middleFrame" method="post">
	<input type="hidden" id="hid_returnObj" name="returnObj" value="" />
</form>