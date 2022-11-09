<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page import="main.web.BizboxAMessage"%>

<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>

	<script type="text/javascript">
		var langCode = "<%=langCode%>";
	</script>
	<style>
		.highlight {color:#058df5 !important;font-weight:bold;}
	</style>
	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />
	
	<!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css?ver=20201021' />">	
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css?ver=20201021' />"> 
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
	
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js?ver=20201021' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js?ver=20201021' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.core.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	<%if(langCode.equals("KR")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
    <%}else if(langCode.equals("EN")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.en-US.min.js'/>"></script>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/en.css' />">
    <%}else if(langCode.equals("JP")){ %>
    	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ja-JP.min.js'/>"></script>
    	<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/jp.css' />">
    <%}else if(langCode.equals("CN")){ %>
		<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.zh-CN.min.js'/>"></script>
		<link rel="stylesheet" type="text/css" href="<c:url value='/css/lang/cn.css' />">
	<%}%>
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js?ver=20201021' />"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.main.js?ver=20201021' />"></script>
    
    <!-- 메인 js -->
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.dotdotdot.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.highlight.js' />"></script>
    <script type="text/javascript">
	
    _g_contextPath_ = "${pageContext.request.contextPath}";
	_g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
    
	var tsearchKeyword = "";
	var protocol = "";
	var eaType = '${params.eaType}'; // 전자결재 영리/비영리 구분
	if(eaType == "" || eaType == null) eaType = "eap";
	var eaName = "6"; // 기본 전자결재(영리)
	if(eaType == "ea"){
		eaName = "7"; // 기본 전자결재(비영리)
	}
	var detailSearchYn = '${params.detailSearchYn}'; // 상세검색 ON 여부
	
	//첨부파일 모듈별 보기옵션 설정값
	var attProjectValue = "${pathSeq300}";	
	var attScheduleValue = "${pathSeq400}";
	var attBoardValue = "${pathSeq500}";
	var attDocValue = "${pathSeq600}";
	var attEaValue = "${pathSeqEa}";
	
	var selectedFileUrl = "";
    var selectedfileNm = "";
    var selectedfileId = "";
    var selectedFileExtsn = "";
    var selectedModuleTp = "";
    var pathSeq = "";
    var loadingMap = {};
	
	if("${attViewOptionValue}" != "1"){
		attProjectValue = "1";	
		attScheduleValue = "1";
		attBoardValue = "1";
		attDocValue = "1";
		attEaValue = "1";
	}
	
	//좌측 트리뷰 데이터 초기화
	var treeview;
	var flatData = [];
	var initCntStr = '(' + fnMoneyTypeReturn(0) + ')'; 
	var totalYn = {text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>"+initCntStr, name: "1", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>"};
	var mailYn = {text: "<%=BizboxAMessage.getMessage("TX000000262","메일")%>"+initCntStr, name: "0", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000262","메일")%>"};
	var scheduleYn = {text: "<%=BizboxAMessage.getMessage("TX000000483","일정")%>"+initCntStr, name: "3", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000483","일정")%>"};
	var noteYn = {text: "<%=BizboxAMessage.getMessage("TX000010157","노트")%>"+initCntStr, name: "4", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000010157","노트")%>"};
	var reportYn = {text: "<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>"+initCntStr, name: "5", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>"};
	var projectYn = {text: "<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>"+initCntStr, name: "2", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>"};
	var boardYn = {text: "<%=BizboxAMessage.getMessage("TX000011134","게시판")%>"+initCntStr, name: "9", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000011134","게시판")%>"};
	var edmsYn = {text: "<%=BizboxAMessage.getMessage("TX000008576","문서")%>"+initCntStr, name: "8", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000008576","문서")%>"};
	var hrYn = {text: "<%=BizboxAMessage.getMessage("TX000020784","인물")%>"+initCntStr, name: "11", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000020784","인물")%>"};
	var eadocYn = {text: "<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>"+initCntStr, name: eaName, count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>"};
	var tsFileYn = {text: "<%=BizboxAMessage.getMessage("TX000000521","첨부파일")%>"+initCntStr, name: "10", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000521","첨부파일")%>"};
	var onefficeYn = {text: "<%=BizboxAMessage.getMessage("","ONEFFICE")%>"+initCntStr, name: "12", count: 0, onlyText:"<%=BizboxAMessage.getMessage("","ONEFFICE")%>"};
	
	flatData[0] = totalYn;
	
	if('${menuAuthMap.eadocYn}' == 'Y'){
		flatData[flatData.length] = eadocYn;
	}
	if('${menuAuthMap.mailYn}' == 'Y' && '${params.hrSearchYn}' == 'N'){
		flatData[flatData.length] = mailYn;
	}
	if('${menuAuthMap.scheduleYn}' == 'Y'){
		flatData[flatData.length] = scheduleYn;
	}
	if('${menuAuthMap.projectYn}' == 'Y'){
		flatData[flatData.length] = projectYn;
	}
	if('${menuAuthMap.boardYn}' == 'Y'){
		flatData[flatData.length] = boardYn;
	}
	if('${menuAuthMap.edmsYn}' == 'Y'){
		flatData[flatData.length] = edmsYn;
	}
	if('${menuAuthMap.reportYn}' == 'Y'){
		flatData[flatData.length] = reportYn;
	}
	if('${menuAuthMap.noteYn}' == 'Y'){
		flatData[flatData.length] = noteYn;
	}
	if('${params.hrSearchYn}' == 'N'){
		flatData[flatData.length] = hrYn;
	}
	if('${menuAuthMap.onefficeYn}' == 'Y'){
		flatData[flatData.length] = onefficeYn;
	}
	flatData[flatData.length] = tsFileYn;
	
	//화면이 다 로드 된 후에 실행합니다.
	$(window).load(function() {
		
		var selectDivTmp = '${params.selectDiv}'; //기간선택, 직접입력
 		var orderDivTmp = '${params.orderDiv}'; // 정확도순, 최신순
		
		if(detailSearchYn == "Y"){
			$(".SearchDetail").show();
			$('#all_menu_btn').attr('src', _g_contextPath_ + '/Images/ico/ico_btn_arr_up01.png');
		}
		nonResult();
		
		//페이지 검색 시 기간선택, 직접입력 셋팅
		setRadioStatus(selectDivTmp);
		
		//페이지 검색 시 정확도, 최신순 셋팅
		setOrderBtnStatus(orderDivTmp);
		
	});
	
	$(window).resize(function() { 
		nonResult(); //검색결과 없을때 문구
	});
	
 	$(document).ready(function() {
 		
		// 동작 이벤트 (시간 초기화)
		$(window).bind("click keyup", function () { localStorage.setItem("LATime", (+new Date())); });
		if (document.location.protocol == 'http:') {
			protocol = "http:"
		    }
		else {
			protocol = "https:"
		}
 		var searchType = '${params.searchType}';
 		tsearchKeyword = '${params.tsearchKeyword}'; // 통합검색어
 		var boardType = '${params.boardType}'; // Left메뉴 선택 구분
 		var fromDate = '${params.fromDate}'; // 검색 시작 일자
 		var toDate = '${params.toDate}'; // 검색 종료 일자
 		var dateDiv = '${params.dateDiv}'; // 기간선택 선택값
 		var tsearchSubKeyword = '${params.tsearchSubKeyword}'; // 결과내 재검색
 		var selectDiv = '${params.selectDiv}'; //기간선택, 직접입력
 		var orderDiv = '${params.orderDiv}'; // 정확도순, 최신순
 		var pageIndex = '${params.pageIndex}';
 		var hrEmpSeq = '${params.hrEmpSeq}'; //인물검색
 		var mailUrlTmp = '${mailUrl}';
 		if(orderDiv == ""){
 			orderDiv = "B";
 		}
 		
 		//좌측 트리뷰 : 서브메뉴 선언
		$("#sub_nav").kendoTreeView({
	      	dataSource:flatData, //dataSource
			select:function(e){
				
				if(!validation()){
					e.preventDefault();
		 			return;
		 		}
				
				var treeview = $("#sub_nav").data("kendoTreeView");//트리데이터 가져오기
			    //선택활성
			    treeview.expand(e.node);
			    var item = treeview.dataItem(e.node);
			    var itemName = item.name;
			    formTotal.boardType.value = itemName;
			    getTotalSearch('2', true);
			    //이전선택 초기화
			    $(".k-in").removeClass('k-state-selected');
			}
	    });
		treeview = $("#sub_nav").data("kendoTreeView");
		if(boardType == '1'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000000862","전체")%>"+initCntStr));
		}else if(boardType == '2'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>"+initCntStr));
		}else if(boardType == '3'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000000483","일정")%>"+initCntStr));
		}else if(boardType == '4'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000010157","노트")%>"+initCntStr));
		}else if(boardType == '5'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>"+initCntStr));
		}else if(boardType == '6' || boardType == '7'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>"+initCntStr));
		}else if(boardType == '0'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000000262","메일")%>"+initCntStr));
		}else if(boardType == '9'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000011134","게시판")%>"+initCntStr));
		}else if(boardType == '8'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000008576","문서")%>"+initCntStr));
		}else if(boardType == '11'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000020784","인물")%>"+initCntStr));
		}else if(boardType == '10'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("TX000000521","첨부파일")%>"+initCntStr));
		}else if(boardType == '12'){
			treeview.select(treeview.findByText("<%=BizboxAMessage.getMessage("","ONEFFICE")%>"+initCntStr));
		}
		treeview.collapse(".k-item");
		 		
 		$("#tsearchKeyword").val(tsearchKeyword);
 		$("#tsearchKeywordResult").text(tsearchKeyword);
 		$("#tsearchKeywordResultSub").text(tsearchKeyword);
 		$("#tsearchKeywordSubResult").text(tsearchSubKeyword);
 		$("#tsearchSubKeyword").val(tsearchSubKeyword);
 		if(fromDate == ""){ // 날짜 입력값이 없으면 오늘날짜로 셋팅
 			$("#from_date").val(getToDay("-","today"));
 		}else{
 			$("#from_date").val(fromDate);
 		}
 		if(toDate == ""){ // 날짜 입력값이 없으면 오늘날짜로 셋팅
 			$("#to_date").val(getToDay("-","today"));
 		}else{
 			$("#to_date").val(toDate);
 		}
 		formTotal.selectDiv.value = selectDiv;
 		formTotal.boardType.value = boardType;
 		formTotal.orderDiv.value = orderDiv;
 		formTotal.pageIndex.value = pageIndex;
 		formTotal.hrEmpSeq.value = hrEmpSeq;

 		//boardType이 없을 시 전체가 default
 		if(dateDiv == ""){
 			dateDiv = "total";
 		}
 		/*초기값 셋팅 END*/
 		var bb = "";
	 	//검색버튼
	 	$("#searchButton").click(function(e){
	 		getTotalSearch('2', true);
		});
	 	
	 	$("#searchButtonHrTotalSearch").click(function(e){
	 		if(!validation()){
	 			return;
	 		}
	 		showLoading();
	 		formTotal.boardType.value = "1";
	 		formTotal.hrSearchYn.value = "N";
 			formTotal.submit();
		});
	 		
		//기본버튼
	   $(".controll_btn button").kendoButton();
	   
	   //시작날짜
	   $("#from_date").kendoDatePicker({
	   	format: "yyyy-MM-dd"
	   });
	   
	   //종료날짜
	   $("#to_date").kendoDatePicker({
	   	format: "yyyy-MM-dd"
	   });
	   
	   $("#combo_sel_1").kendoComboBox({
	   	dataTextField: "text",
	       dataValueField: "value",
	       dataSource : [
	       		{ text : "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value : "total"},
	       		{ text : "<%=BizboxAMessage.getMessage("TX000018185","1일")%>", value : "today"},
	       		{ text : "<%=BizboxAMessage.getMessage("TX000018186","1주")%>", value : "week"},
	       		{ text : "<%=BizboxAMessage.getMessage("TX000018187","1개월")%>", value : "month"},
	       		{ text : "<%=BizboxAMessage.getMessage("TX000016771","1년")%>", value : "year"}
	       	],
	       value:dateDiv,
           change: function (e) {
           	if(e.sender.selectedIndex == -1)
           		e.sender.value("");
           }
	   });
	  //기간선택 시 선택값 form 입력 및 직접입력 Disabled
      $("input[id=search_radi_1]").click(function() {  //기간선택 시
    	  setRadioStatus("S");
    	  formTotal.selectDiv.value = "S";
      });
      
	  //직접입력 시 선택값 form 입력 및 기간선택 Disabled
      $("input[id=search_radi_2]").click(function() {  //직접입력 시
    	  setRadioStatus("M");
    	  formTotal.selectDiv.value = "M";
      });
	   
	   dot_play();
   	
	   function dot_play(){
			$('.dot1').dotdotdot();
			$('.dot2').each(function() {
				var path = $(this).html().split( '.' );
				if ( path.length > 1 ) {
					var name = path.pop();
					$(this).html( path.join( '.' ) + '<span class="filename">.' + name + '</span>' );
					$(this).dotdotdot({
						after: '.filename',
						wrap: 'letter'
					});						
				}
			});
		}
	   
	   //정확도순, 최신순 정렬버튼 클릭 시 
	   $(".result_type_btn li").click(function(){
		   formTotal.orderDiv.value = $(this).attr("id");
		   setOrderBtnStatus($(this).attr("id"));
		   getTotalSearch('2', false);
		});
	   
		//페이지 로딩 시 통합검색어 포커스 이동
		//$("#tsearchKeyword").focus();
	
		//인물검색일 경우 최초 로딩시 한번만 호출
		if('${params.hrSearchYn}' == 'Y'){
			searchTotalSearchContent("11", false, '${params.hrSearchYn}', false);
		}

		//최초 화면 로드시 호출
		getTotalSearch("2", true);
		
	}); // ready end
	 
  	// 조직도 팝업
  	function orgChartPop() {
  		var url = "<c:url value='/cmm/systemx/orgChartAllEmpInfo.do'/>";
  		openWindow2(url,  "orgChartPop", 1000, 713, 0, 1);
  	}
  	
  	//업무보고 팝업
  	function reportPop(reportSeq, jobType, createSeq, targetEmpSeq, openYn) {
  		var type = "1";
  		if(jobType == "report-2"){
  			type = "2";
  		}
  		
  		var empSeq = '${loginVO.uniqId}';
  		//console.log("empSeq : "+empSeq);
  		var url = "";
  		
  		if(createSeq == empSeq){ // 보고자면
  			url = "<c:url value='"+protocol+"//"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&type="+type+"&kind=0'/>";
  		}else if(targetEmpSeq == empSeq){ // 보고대상자면
  			url = "<c:url value='"+protocol+"//"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&createEmpSeq="+createSeq+"&loginEmpSeq="+empSeq+"&type="+type+"&kind=1'/>";
  		
  		}else if(openYn == "Y"){ // 공개보고서면
  			url = "<c:url value='"+protocol+"//"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&createEmpSeq="+createSeq+"&loginEmpSeq="+empSeq+"&type="+type+"&kind=3'/>";
  		
  		}else{ // 참조보고서
  			url = "<c:url value='"+protocol+"//"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&createEmpSeq="+createSeq+"&loginEmpSeq="+empSeq+"&type="+type+"&kind=2'/>";
  		
  		}
  		

  		openWindow2(url,  "pop", 1000, 711, 1) ;
  	}
  	
  	//전자결재(영리) 팝업
  	function eapPop(docSeq, formId, migYn) {
  		var url = "";
  		if(eaType == "ea"){
  			if(migYn == "1"){
  				docSeq = docSeq.replace("mig_","");
  				url = "<c:url value='"+protocol+"//"+location.host+"/ea/ea/docpop/EAAppDocMigPop.do?doc_id="+docSeq+"'/>";
  			}else{
  				url = "<c:url value='"+protocol+"//"+location.host+"/ea/edoc/eapproval/docCommonDraftView.do?diKeyCode="+docSeq+"'/>";
  			}
  			
  		}else{
  			if(migYn == "1"){
  				docSeq = docSeq.replace("mig_","");
  				url = "<c:url value='"+protocol+"//"+location.host+"/eap/ea/docpop/EAAppDocMigPop.do?doc_id="+docSeq+"'/>";
  			}else{
  				url = "<c:url value='"+protocol+"//"+location.host+"/eap/ea/docpop/EAAppDocViewPop.do?doc_id="+docSeq+"&form_id="+formId+"'/>";
  			}
  		}

  		openWindow2(url,  "pop", 1000, 711, "yes",0);
  	}
  	
  	//업무관리 페이지이동
  	function projectMove(jobType, pkSeq, groupSeq) {
  		
  		var projectType = "";
  		var projectSeq = "";
  		var workSeq = "";
  		var jobSeq = "";
  		var menuNo = "";
  		var type = "";
  		
  		if(jobType == "project-1"){
  			projectSeq = pkSeq;
  			menuNo = "401020000";
  			type = "P";
  		}else if(jobType == "project-2"){
  			workSeq = pkSeq;
  			menuNo = "401030000";
  			type = "W";
  		}else if(jobType == "project-3"){
  			jobSeq = pkSeq;
  			menuNo = "401040000";
  			type = "J";
  		}
  		var url = "<c:url value='"+protocol+"//"+location.host+"/project/Views/Common/project/projectView.do?pSeq="+projectSeq+"&wSeq="+workSeq+"&jSeq="+jobSeq+"&type="+type+"'/>";
  		openWindow2(url,  "pop", 1100, 911, 0) ;
  	}
  	
    //업무관리 페이지이동
    function projectMove2(jobType, pkSeq, groupSeq, wSeq, pSeq, jSeq) {      

	    var type = "";    
	
	    if(jobType == "project-1"){
	    	type = "P";
	    }else if(jobType == "project-2"){
	    	type = "W";
	    }else if(jobType == "project-3"){
	    	type = "J";
	    }
	
	    var url = "<c:url value='"+protocol+"//"+location.host+"/project/Views/Common/project/projectView.do?pSeq="+pSeq+"&wSeq="+wSeq+"&jSeq="+jSeq+"&type="+type+"'/>";
	
	    openWindow2(url,  "pop", 1100, 911, 0) ;

    }
  	
  	function mailContentMove(){
  		var mailUrl = '${mailUrl}';
  		parent.onclickTopCustomMenu('200000000', '메일',mailUrl, 'mail' ,'','N');
  	}
  	
  	//게시판 페이지이동
  	function boardMove(jobType, catSeq, artSeq) {
  		
  		if(jobType == "board-1" || jobType == "board-3"){
  			var url = "<c:url value='"+protocol+"//"+location.host+"/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq+"'/>";
  		}else if(jobType == "board-2"){
  			var url = "<c:url value='"+protocol+"//"+location.host+"/edms/board/happyPollResultView.do?surveyNo="+catSeq+"'/>";
  		}
  		openWindow2(url,  "pop", 833, 711,"yes", 0) ;
  	}

	//일정 페이지이동
  	function scheduleMove(pkSeq1, pkSeq2) {
  		var url = "<c:url value='"+protocol+"//"+location.host+"/schedule/Views/Common/mCalendar/detail?seq="+pkSeq2+"'/>";
  		openWindow2(url,  "pop", 833, 711,"yes", 0);
  	}
  
  	//노트 페이지이동
  	function noteMove(pkSeq) {
  		var url = "<c:url value='"+protocol+"//"+location.host+"/schedule/Views/Common/note/noteList.do?noteSeq="+pkSeq+"'/>";
  		openWindow2(url,  "pop", 1000, 711, "no", 0) ;
  	}
  
 	 //문서 페이지이동
  	function edmsMove(wDirCd, artSeqNo) {
  		var url = "<c:url value='"+protocol+"//"+location.host+"/edms/doc/viewPost.do?dir_cd="+wDirCd+"&dir_lvl=3&dir_type=W&currentPage=1&artNo="+artSeqNo+"&dirMngYn=N&hasRead=Y&hasWrite=Y&searchField=&searchValue=&startDate=&endDate='/>";
  		openWindow2(url,  "pop", 1000, 711, "yes", 0) ;
  	}
 	 
  	 //문서 페이지이동
  	function edmsMove2(wDirCd, artSeqNo) {
  		var url = "<c:url value='"+protocol+"//"+location.host+"/edms/doc/viewBpmPost.do?dir_cd="+wDirCd+"&artNo="+artSeqNo+"&dir_type=B'/>";
  		openWindow2(url,  "pop", 1000, 711, "yes", 0) ;
  	}
  
  	//메일 페이지이동
  	function mailMove(emailAddr, muid) {
  		var mailUrl = '${mailUrl}';
  		var gwDomain = window.location.host + (window.location.port == "" ? "" : (":" + window.location.port));
  		var url = "<c:url value='"+mailUrl+"/readMailPopApi.do?gwDomain=" + gwDomain + "&email="+emailAddr+"&muid="+muid+"'/>";
  		openWindow2(url,  "pop", 1000, 711, "yes",0);
  	}
  
  	//원피스 페이지이동
  	function onefficeMove(jobType, pkSeq, groupSeq) {
  		
  		var nCurDocSeq = pkSeq + "&groupSeq=" + groupSeq;
  					
  		// 캐시를 방지하기 위해 임의의 문자+숫자 조합 4자리 추가
  		var randStr = "";
  		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  		for( var i=0; i < 4; i++ )
  			randStr += possible.charAt(Math.floor(Math.random() * possible.length));
  		nCurDocSeq += "&_t="+randStr;

  		var filePath = "seq="+ nCurDocSeq;
  		filePath = window.btoa(filePath);
  		var strPageURL ="/gw/oneffice/oneffice.do?"+encodeURIComponent(filePath);
	  
  		openWindow2(strPageURL,  "pop", 1100, 911, 0) ;
  	}
  
  	//첨부파일 본문이동
  	function contentView(keysObj,jobType){
    	keysObj = keysObj.replace(/@/gi,"\"");
    	var obj = JSON.parse(keysObj);
    	
    	if(jobType == "board-1" || jobType == "board-2" || jobType == "board-3"){
    		boardMove(jobType, obj.boardNo, obj.artNo);
    	}
    	if(jobType == "project-1"){
    		projectMove(jobType, obj.prjSeq, '');
    	}
    	if(jobType == "project-2"){
    		projectMove(jobType, obj.workSeq, '');
    	}
    	if(jobType == "project-3"){
    		projectMove(jobType, obj.jobSeq, '');
    	}
    	if(jobType == "eapproval-1" || jobType == "eapproval-2" ||jobType == "eadoc-1" || jobType == "eadoc-2"){ // 전자결재
    		eapPop(obj.doc_id, obj.formId);
    	}
    	if(jobType == "report-1" || jobType == "report-2"){
    		reportPop(obj.reportSeq, jobType, obj.createSeq, obj.targetEmpSeq, obj.openYn);
    	}
    	if(jobType == "edms-1"){
    		edmsMove(obj.dir_cd, obj.art_seq_no);
    	}
    	if(jobType == "edms-2"){
    		edmsMove2(obj.dir_cd, obj.art_seq_no);
    	}
    	if(jobType == "note"){
    		noteMove(obj.noteSeq);
    	}
    	if(jobType == "schedule-1"){
    		scheduleMove(pkSeq1, pkSeq2)
    	}
    }
  
  	function boardTypeDetail(values){
  		formTotal.boardType.value = values;
  		getTotalSearch('2', false);
  	}
  	
  	//인물검색
  	function getTotalSearchHr(str,hrEmpSeq){
  		formTotal.hrEmpSeq.value = hrEmpSeq;
  		getTotalSearch(str, false);
  	}
  	
  	function canSearchStatus(){
  		var canSearch = true;
  		
  		for(key in loadingMap){
  			if(loadingMap[key]){
  				canSearch = false;
  				break;
  			}
  		}
  		
  		return canSearch;
  	}
  	
  	function validation(){
  		
  		var result = true;
  		
  		formTotal.tsearchKeyword.value = $("#tsearchKeyword").val();
 		if(formTotal.tsearchKeyword.value == "" || $.trim($("#tsearchKeyword").val()) == ""){
 			alert("<%=BizboxAMessage.getMessage("TX000018188","검색어 입력은 필수사항입니다.")%>");
 			$("#tsearchKeyword").focus();
 			return false;
 		}
 		
 		
 		return result;
  	}
  	
  	//유효성검사 후 Controller 호출 저장
  	function getTotalSearch(str, canCountUpdate){
  		if(!canSearchStatus()){
  			alert("<%=BizboxAMessage.getMessage("TX000005114","페이지 로딩중 입니다. 잠시후에 다시 시도해 주세요.")%>");
  			return;
  		} 

  		var tsearchSubKeyword = "";
  		
  		if(typeof $("#tsearchSubKeyword").val() == "undefined"){
  			tsearchSubKeyword = "";
  		}else{
  			tsearchSubKeyword = $("#tsearchSubKeyword").val();
  		}
  		
  		if($('#all_menu_btn').attr('src')== _g_contextPath_ + '/Images/ico/ico_btn_arr_down01.png'){ // 닫혀 있으면
  			formTotal.detailSearchYn.value = "N";
  			formTotal.tsearchSubKeyword.value = "";
  			formTotal.fromDate.value = "";
  	 		formTotal.toDate.value = "";
  	 		formTotal.dateDiv.value = "";
		}else{ // 열려 있으면
			
			formTotal.detailSearchYn.value = "Y";
			formTotal.tsearchSubKeyword.value = tsearchSubKeyword;
			formTotal.fromDate.value = $("#from_date").val();
	 		formTotal.toDate.value = $("#to_date").val();
	 		formTotal.dateDiv.value = $("#combo_sel_1").val(); // 기간선택
	 		
	 		if(formTotal.selectDiv.value == "S"){
	 			formTotal.fromDate.value = getToDay("-",$("#combo_sel_1").val());
	 			formTotal.toDate.value = getToDay("-","today");
	 		}
	 		
		}
  		if((formTotal.tsearchKeyword.value != $("#tsearchKeyword").val()) || str == "1"){
  			formTotal.detailSearchYn.value = "N";
  			formTotal.tsearchSubKeyword.value = "";
  			formTotal.fromDate.value = "";
  	 		formTotal.toDate.value = "";
  	 		formTotal.dateDiv.value = "";
  	 		formTotal.pageIndex.value = "1";
  		}
  		if(str == "2"){
  			formTotal.pageIndex.value = "1";
  		}
  		
  		if(formTotal.boardType.value == "1"){
  			formTotal.pageIndex.value = "1";
  		}else{
  			
  		}
  		
 		if(!validation()){
 			return;
 		}
 		
 		$("#hrTab" + formTotal.boardType.value).siblings().removeClass("on");
		$("#hrTab" + formTotal.boardType.value).addClass("on");
 		
 		showLoading();
 		
 		if(str == "4"){
 			formTotal.hrSearchYn.value = "Y";
 			formTotal.boardType.value = "1";
 			formTotal.pageIndex.value = "1";
 			//기존 인물검색 화면 별도 처리 -> totalSearchContentNew.jsp 하나의 화면 처리로 변경 (hrSearchYn 구분자로 판별)
 			//formTotal.action = "getTotalSearchContentHr.do"; 			
 			formTotal.submit();
 		}else{
 			//모듈별 공통 API 조회
 			var isAll = (formTotal.boardType.value == "1");
 			//검색전 초기화
 			initBeforeSearch(isAll);
 			if(isAll){//전체 조회
 				allSearch(isAll);
 			}else{//모듈 1개 조회.
 				searchTotalSearchContent(formTotal.boardType.value, false, null, canCountUpdate);
 			}
 			//검색어 저장 처리.
 			saveSearchKeyword();
 		}
	}
  	//검색어 저장 처리
  	function saveSearchKeyword(){
  		var formParam = jQuery("#formTotal").serialize();
  		$.ajax({ 
			type:"POST",
			url: '<c:url value="/saveSearchKeyword.do"/>',
			datatype:"json",
			async: true,
			data:formParam,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				if(data.resultCode=="LOGIN004" && canSearchStatus()){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
  	}
  	
  	//모듈 전체삭제
  	function removeAllModule(){
  		for(var i=0;i<13;i++){
			if('${params.hrSearchYn}'=='Y' && i==11){
				continue;
			}
			$("#result_module_" + i).remove();
		}
  	}
  	
  	//검색전 초기화
  	function initBeforeSearch(isAll){
  		//검색어 초기화
  		$("#tsearchKeywordResult").text($("#tsearchKeyword").val());
  		//검색어 옆 결과 건수 초기화
  		$("#tsearchKeywordCountResult").text(fnMoneyTypeReturn('0'));
  		
  		if(isAll){
	  		//전체 일 경우에만 검색 전 전체 삭제.
	  		removeAllModule();
	  		$("#paging").remove();
  		}
  	}
  	
  	//모듈별 공통 API 조회 
  	//조회 타입 (boardType) : 메일(0),업무관리(2), 일정(3), 노트(4), 업무보고(5), 전자결재(6:영리,7:비영리), 문서(8), 게시판(9), 첨부파일(10), 인물(11), ONEFFICE(12)
  	function searchTotalSearchContent (boardType, isAll, hrSearchYn, canCountUpdate){  		
 		loadingMap[boardType] = true;
  		formTotal.listType.value = boardType;
  		var formParam = jQuery("#formTotal").serialize();
  		$.ajax({ 
			type:"POST",
			url: '<c:url value="/getTotalSearchList.do"/>',
			datatype:"json",
			async: hrSearchYn ? false : true,
			data:formParam,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					//script 태그 제거
					removeScript(data.result);
					//인물검색 전용(인물검색일경우 화면 로드시 최초 한번 인물 가져올때)이 아닐 때만 건수 갱신
					if(!hrSearchYn){
						//1. 가져온 데이터로  KendoTreeView의 검색 건수 및 화면상의 검색 건수 갱신
						modifyModuleCount(data.result.pagingReturnObj, boardType, isAll);
					}
					//2. 가져온 데이터로 화면 다시 그리기.(각 모듈별 페이지, 페이징)
					refreshSearchResult(data.result.pagingReturnObj, boardType, isAll, hrSearchYn);
					//검색어 하이라이트
					searchKeywordHighlight();
					//KendoTabStrip 처리
					kendoTabStripProc();
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				loadingMap[boardType] = false;
				
				if(canSearchStatus()){
					hideLoading();	
				}
				
				if(data.resultCode=="LOGIN004" && canSearchStatus()){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
				loadingMap[boardType] = false;
				if(canSearchStatus()){
					hideLoading();	
				}
			}  
		});
  		
  		//개별 모듈 호출이면 별도로 백그라운드에서 다른 모듈들의 카운트 조회 후 좌측 트리뷰 카운트 갱신.
		if(!isAll && canCountUpdate){ 
			searchTotalSearchCount(boardType);
		}
  	}
  	
  	function removeScript(result){
  		if(result.pagingReturnObj){
	  		var jsonStr = JSON.stringify(result.pagingReturnObj);
	  		var removedJsonStr = jsonStr.replace(/<(\/script|script)([^>]*)>/gi,"");
	  		result.pagingReturnObj = JSON.parse(removedJsonStr);
  		}
  	}
  	
  	//listTypes의 모듈들의 카운트를 가져온다.
	<%-- function searchTotalSearchCountOne (boardType){
  		
		//boardType: 1(전체), 해당 모듈의 boardType 두개를 제외한 나머지 boardType 추출 후 formTotal.listTypes에 저장  
		var listTypes = '';
		for(var i=0;i<flatData.length;i++){
			
			var listType = flatData[i]['name'];
			
			if(listType !='1' && listType != boardType){
				listTypes += (listType + ",");
			}
		}
		
		if(listTypes.length > 0){
			listTypes = listTypes.substring(0, listTypes.length-1);
		}else{
			return;
		}
		
  		formTotal.listTypes.value = listTypes;
  		
  		var formParam = jQuery("#formTotal").serialize();
  		$.ajax({ 
			type:"POST",
			url: '<c:url value="/getTotalSearchCount.do"/>',
			datatype:"json",
			data:formParam,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					
					for(var key in data.result.count){
						modifyModuleCount(data.result.count[key], key, false, true);
					}
					
					for(i=0;i<flatData.length;i++){
						//좌측 트리뷰 데이터를 갱신 했으므로 가장 마지막 선택한 모듈을 선택해준다.
						if(flatData[i]['name']==formTotal.boardType.value){
							treeview.select(treeview.findByText(flatData[i]['text']));
							break;
						}
					}
					
				}else if(data.resultCode=="LOGIN004"){//loginVO NULL
					window.parent.location.href = "/gw/userMain.do";
				}else{
					alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
  	} --%>
  	
	//파라메터에 들어온 모듈 이외의 다른 모듈들의 갯수를 가져온다.
	function searchTotalSearchCount (boardType){
  		
		//boardType: 1(전체), 해당 모듈의 boardType 두개를 제외한 나머지 boardType 추출 후 formTotal.listTypes에 저장  
		for(var i=0;i<flatData.length;i++){
			
			var listType = flatData[i]['name'];
			
			if(listType !='1' && listType != boardType){
				
				formTotal.listTypes.value = listType;
				var formParam = jQuery("#formTotal").serialize();

				$.ajax({ 
					type:"POST",
					url: '<c:url value="/getTotalSearchCount.do"/>',
					datatype:"json",
					data:formParam,
					success:function(data){
						if(data.resultCode=="SUCCESS"){
							
							for(key in data.result.count){
								modifyModuleCount(data.result.count[key], key, false, true);
							}
							for(i=0;i<flatData.length;i++){
								//좌측 트리뷰 데이터를 갱신 했으므로 가장 마지막 선택한 모듈을 선택해준다.
								if(flatData[i]['name']==formTotal.boardType.value){
									treeview.select(treeview.findByText(flatData[i]['text']));
									break;
								}
							}
							
						}else if(data.resultCode!="LOGIN004"){
							//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
						}
						
					},error: function(result) {
						alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
					}  
				});
			}
		}
  	}
  	
  	//KendoTreeView의 검색 건수 갱신
  	function modifyModuleCount(data, boardType, isAll, isExCount){
		if(flatData){
			var isChanged = false;
			var totalCount = 0;//전체 카운트
			var allIndex = 0;//전체 모듈 인덱스 넘버
			var text = '';
			//해당 모듈 카운트 갱신
			for(i=0;i<flatData.length;i++){
				if(flatData[i]['name']=="1"){
					allIndex = i;
				}
				
				if(flatData[i]['name']==boardType){
					flatData[i]['count'] = data.totalcount;
					flatData[i]['text'] = flatData[i]['onlyText'] + "(" + fnMoneyTypeReturn(data.totalcount) + ")";
					text = flatData[i]['text'];
					$("#hrTabCount" + boardType).text(fnMoneyTypeReturn(data.totalcount));
					isChanged = true;
				}
				totalCount += flatData[i]['count'];
			}
			if(isChanged){
				//전체 카운트 갱신
				flatData[allIndex]['text'] = flatData[allIndex]['onlyText'] + "(" + fnMoneyTypeReturn(totalCount) + ")";
				$("#tsearchKeywordCountResultForHr").text(fnMoneyTypeReturn(totalCount));
				$("#hrTabCount1").text(fnMoneyTypeReturn(totalCount));
				treeview.dataSource.data(flatData);
				
				//별도 카운트 계산용도가 아닐때만.
				if(!isExCount){
					//전체 일시 전체 선택
					if(isAll){
						treeview.select(treeview.findByText(flatData[allIndex]['text']));
						$("#tsearchKeywordCountResult").text(fnMoneyTypeReturn(totalCount));
						
						if(totalCount == 0){
							$("#noResult").show();
						}else{
							$("#noResult").hide();
						}
						
					}else{//전체가 아닐시 해당 모듈의 트리뷰 선택
						
						treeview.select(treeview.findByText(text));
						$("#tsearchKeywordCountResult").text(fnMoneyTypeReturn(data.totalcount));
						
						if(data.totalcount == 0){
							$("#noResult").show();
						}else{
							$("#noResult").hide();
						}
						
					}
				}
			}
		}
  	}
  	//전체 모듈 조회
  	//조회 타입 (boardType) : 메일(0),업무관리(2), 일정(3), 노트(4), 업무보고(5), 전자결재(6:영리,7:비영리), 문서(8), 게시판(9), 첨부파일(10), 인물(11), ONEFFICE(12)
  	function allSearch(isAll){
  		//전자결재
		if('${menuAuthMap.eadocYn}' == 'Y'){
			searchTotalSearchContent(eaName, isAll);
		}
		//메일
		if('${menuAuthMap.mailYn}' == 'Y' && '${params.hrSearchYn}' == 'N'){
			searchTotalSearchContent("0", isAll);
		}
		//일정
		if('${menuAuthMap.scheduleYn}' == 'Y'){
			searchTotalSearchContent("3", isAll);
		}
		//업무관리
		if('${menuAuthMap.projectYn}' == 'Y'){
			searchTotalSearchContent("2", isAll);
		}
		//게시판
		if('${menuAuthMap.boardYn}' == 'Y'){
			searchTotalSearchContent("9", isAll);
		}
		//문서
		if('${menuAuthMap.edmsYn}' == 'Y'){
			searchTotalSearchContent("8", isAll);
		}
		//업무보고
		if('${menuAuthMap.reportYn}' == 'Y'){
			searchTotalSearchContent("5", isAll);
		}
		//노트
		if('${menuAuthMap.noteYn}' == 'Y'){
			searchTotalSearchContent("4", isAll);
		}
		//원피스
		if('${menuAuthMap.onefficeYn}' == 'Y'){
			searchTotalSearchContent("12", isAll);
		}
		//첨부파일
		searchTotalSearchContent("10", isAll);
		//인물
		if('${params.hrSearchYn}' == 'N'){
			searchTotalSearchContent("11", isAll);
		}
  	}
  	
  	//페이징 모듈 생성
  	function createPagingModule(data, boardType){
  		
  		var typeCnt = data.totalcount;//전체 게시물 갯수
  		var pageSizing = 10;//default 페이지 사이즈 10 
  		var pagingCnt = 0;//페이지 총 갯수 = 전체 게시물 갯수 / 페이징 사이즈
  		
  		if(boardType=="10" || boardType=="12"){//첨부파일, 원피스 페이징 사이즈
  			pageSizing = 40;
  		}else if(boardType=="11"){//인물 페이징 사이즈
  			pageSizing = 8;
  		}
  		
  		pagingCnt = typeCnt / pageSizing; // 312 / 10 = 31.2
  		var pageIndex = parseInt(formTotal.pageIndex.value);//현재 페이지 번호 (1~)
  		pageIndex = (pageIndex < 1) ? 1 : pageIndex;
  		
  		//startPage : 현재 페이지 번호가 1~10 : 0, 1, 2 
  		var startPage = Math.floor((pageIndex - 1) / 10); //Math.floor (주어진 숫자와 같거나 작은 정수 중에서 가장 큰 수를 반환합니다)
  		//endPage   : 현재 페이지 번호가 1~10 : 1, 2, 3
  		var endPage = Math.ceil(pageIndex / 10);          //Math.ceil (주어진 숫자보다 크거나 같은 숫자 중 가장 작은 숫자를 integer 로 반환합니다.)
  		pagingCnt = pagingCnt + ( 1 - ( pagingCnt % 1 ) ) % 1;
  		
  		startPage = startPage * 10 + 1;// 1, 11, 21 ...
  		endPage = endPage * 10;        //10, 20, 30 ...
  		
  		var innerHtml = '<div id="paging" class="paging pt30">';
  		
  		if(pageIndex > 1){
  			innerHtml += '<span class="pre_pre"><a href="javascript:pageMove(\'1\');">이전이전</a></span>';
			innerHtml += '<span class="pre"><a href="javascript:pageMove(\'' + (pageIndex - 1) + '\');">이전</a></span>';
  		} else {
  			innerHtml += '<span class="pre_pre" style="cursor:not-allowed"><a>이전이전</a></span>';
			innerHtml += '<span class="pre" style="cursor:not-allowed"><a>이전</a></span>';
  		}
  		innerHtml += '<ol>';
  		/* if(startPage > 10){
  			innerHtml += '<li><a href="javascript:pageMove(\'1\')">1...</a></li>';
  		} */
  		for(var i=startPage;i<=endPage;i++){
  			if((pagingCnt+1) > i){
  				
  				if(pageIndex == i){
  					innerHtml += '<li class="on"><a href="#">' + i + '</a></li>';
  				}else{
  					innerHtml += '<li><a href="javascript:pageMove(\'' + i + '\')">' + i + '</a></li>';
  				}
  			}
  		}
  		
  		/* if(pageIndex < ((((pagingCnt+1) - ((pagingCnt+1) % 10)))+1) && pageIndex != pagingCnt){
  			innerHtml += '<li><a href="javascript:pageMove(\'' + pagingCnt + '\')">...' + pagingCnt + '</a></li>';
  		} */
  		innerHtml += '</ol>';
  		
  		if(pageIndex < pagingCnt){
  			innerHtml += '<span class="nex"><a href="javascript:pageMove(\'' + (pageIndex + 1) + '\');">다음</a></span>';
  			innerHtml += '<span class="nex_nex"><a href="javascript:pageMove(\'' + pagingCnt + '\');">다음다음</a></span>';
  		} else {
  			innerHtml += '<span class="nex" style="cursor:not-allowed"><a>다음</a></span>';
			innerHtml += '<span class="nex_nex" style="cursor:not-allowed"><a>다음다음</a></span>';
  		}
  		
  		innerHtml += '</div>';
  		//페이징 삽입
  		$(".sub_contents_wrap").append(innerHtml);
  	}
  	
  	//화면 갱신.(각 모듈별 페이지, 페이징)
  	function refreshSearchResult(data, boardType, isAll, hrSearchYn){
  		
	  	//1. 기존 DOM 제거 처리
	  	//페이징 제거
	  	if(!hrSearchYn){//인물검색 전용이 아닐때만 호출
	  		$("#paging").remove();
	  		if(!isAll){//개별 모듈 호출
	  			//개별 모듈 호출이면 나머지도 삭제 되야하므로 전체 삭제
	  			removeAllModule();
	  		}else{//전체 호출이면 어차피 개별 모듈 각각 제거 처리. 및 페이징 제거
	  			$("#result_module_" + boardType).remove();
	  		}
	  	}
	  	//2. 데이터가 있을 경우만 DOM 다시 그리기
  		if (data.resultgrid.length > 0){
  			//2-1. 모듈별 최상위 div innerHtml 생성
  			createRootDivInnerHtml(data, boardType, hrSearchYn); 
  			//2-2. 모듈별 result_title innerHtml 생성
  			var innerHtml = '';
  			//인물검색전용이 아닐
  			if(!hrSearchYn){
  				innerHtml = createResultTitleInnerHtml(data, boardType, isAll);
  			}
  			//2-3. 모듈별 list innerHtml 생성
  			innerHtml = createListInnerHtml(data, boardType, innerHtml, hrSearchYn);
  			//2-4. 삽입 처리.
  			$("#result_module_" + boardType).append(innerHtml);
  			//2-5. 페이징 처리.
  	  		if(!isAll){//개별 모듈 호출
  	  			//개별 모듈 호출이고 데이터가 1개 이상이면 페이징 생성
  				createPagingModule(data, boardType);
  	  		}  			
  		}
  	}
  	//모듈별 최상위 div innerHtml 생성
  	//조회 타입 (boardType) : 메일(0)V,업무관리(2)V, 일정(3)V, 노트(4)V, 업무보고(5)V, 전자결재(6:영리,7:비영리)V, 문서(8)V, 게시판(9)V, 첨부파일(10), 인물(11)V, ONEFFICE(12)V
  	function createRootDivInnerHtml(data, boardType, hrSearchYn){
  		
  		var classNm = "result_works";
  		
  		if(boardType == "11"){//인물
  			classNm = "result_people";
  		}else if(boardType == "10" || boardType == "12"){//첨부파일, 원피스
  			classNm = "result_people";
  		}
  		var innerHtml = '<div id="result_module_' + boardType + '" class="' + classNm + '"></div>'; 
  		
  		if(!hrSearchYn){
  			$(".sub_contents_wrap").append(innerHtml);	
  		}else{//인물검색 전용이면
			innerHtml += '<div class="mt7 mb15">';
			innerHtml += '"<span class="match">' + data.resultgrid[0].empName + '</span>"에 대한 활동이 <span id="tsearchKeywordCountResultForHr" class="fwb text_blue"></span>건 존재합니다.';
			innerHtml += '</div>';
			//start:인물검색 전용 탭생성
			innerHtml += '<div class="tab_nor st2">';
			innerHtml += 	'<ul>';
			for(var i=0;i<flatData.length;i++){
				
				var boardType = flatData[i]['name'];
				var onlyText = flatData[i]['onlyText'];
				
				if(i == 0){
					innerHtml += '<li id="hrTab' + boardType + '" class="on">';
				}else{
					innerHtml += '<li id="hrTab' + boardType + '">';
				}
				innerHtml += 	'<a href="javascript:boardTypeDetail(' + boardType + ');">' + onlyText + '<span id="hrTabCount' + boardType + '" class="num">0</span></a>';
				innerHtml += '</li>';
				
			}
			innerHtml += 	'</ul>';
			innerHtml += '</div>';
			//end:인물검색 전용 탭생성
  			$(".iframe_wrap").prepend(innerHtml);
  		}
  		
  	}
  	
  	//모듈별 result_title innerHtml 생성
  	//조회 타입 (boardType) : 메일(0),업무관리(2), 일정(3), 노트(4), 업무보고(5), 전자결재(6:영리,7:비영리), 문서(8), 게시판(9), 첨부파일(10), 인물(11), ONEFFICE(12)
  	function createResultTitleInnerHtml(data, boardType, isAll){
		//해당 모듈의 카운트  		
  		var moduleCnt = fnMoneyTypeReturn(data.totalcount + '');
  		//result_title 시작태그
  		var innerHtml = '<div class="result_title">';
  		//모듈명
  		var moduleName = 'name';  		
		
  		if(boardType == '2'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>';
		}else if(boardType == '3'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000000483","일정")%>';
		}else if(boardType == '4'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000010157","노트")%>';
		}else if(boardType == '5'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>';
		}else if(boardType == '6' || boardType == '7'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>';
		}else if(boardType == '0'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000000262","메일")%>';
		}else if(boardType == '9'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000011134","게시판")%>';
		}else if(boardType == '8'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000008576","문서")%>';
		}else if(boardType == '11'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000020784","인물")%>';
		}else if(boardType == '10'){
			moduleName = '<%=BizboxAMessage.getMessage("TX000000521","첨부파일")%>';
		}else if(boardType == '12'){
			moduleName = '<%=BizboxAMessage.getMessage("","ONEFFICE")%>';
		}
  		
  		//공통
		innerHtml += '<h2>' + moduleName + '<span id=\"\" class=\"text_blue\"> (' + moduleCnt +')</span>';
		
		if(!isAll && boardType =='0'){
			innerHtml += '&nbsp;&nbsp;&nbsp;';
			innerHtml += '<u><a href="javascript:mailContentMove();"><%=BizboxAMessage.getMessage("TX900000358","메일 상세검색")%></a></u>';
		}
		innerHtml += '</h2>';
		
		//전체 검색시
		if(isAll){
			innerHtml += '<a href="javascript:boardTypeDetail(\'' + boardType + '\');" class="more_btn">' + moduleName + ' <%=BizboxAMessage.getMessage("TX000018197","더보기")%></a>';
		}else{//모듈별 검색시
			innerHtml += '<a href="javascript:boardTypeDetail(\'1\');" class="more_btn"><%=BizboxAMessage.getMessage("TX000018196","전체 검색결과")%></a>';
		}
  		
  		//result_title 종료태그
  		innerHtml += '</div>';
  		
  		return innerHtml;
  	}
  	//모듈별 list innerHtml 생성
  	//인물검색, 첨부파일, 원피스는 화면 포맷이 전혀 다름.
  	//나머지는 비슷하기는 하나 안에 내부 IF문이 많은 타입으로 공통화 시키면 로직 파악 어려움 으로 각각 그림.
  	//조회 타입 (boardType) : 메일(0)V,업무관리(2)V, 일정(3)V, 노트(4)V, 업무보고(5)V, 전자결재(6:영리,7:비영리)V, 문서(8)V, 게시판(9)V, 첨부파일(10), 인물(11)V, ONEFFICE(12)V
  	function createListInnerHtml(data, boardType, innerHtml, hrSearchYn){
  		
  		//첨부파일 화면 처리.
  		if(boardType == "10"){
  			innerHtml += '<div class="tab_page mt10">';
  			innerHtml += 	'<div class="tab_style"  id="tabstrip">';
  			innerHtml += 		'<ul>';
  			innerHtml += 			'<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000000862","전체")%></li>';
  			innerHtml += 			'<li><%=BizboxAMessage.getMessage("TX000005937","이미지")%></li>';
  			innerHtml += 			'<li><%=BizboxAMessage.getMessage("TX000008576","문서")%></li>';
  			innerHtml += 			'<li><%=BizboxAMessage.getMessage("TX000018199","멀티미디어")%></li>';
  			innerHtml += 			'<li><%=BizboxAMessage.getMessage("TX000005400","기타")%></li>';
  			innerHtml += 		'</ul>';
  			//------------------------------------------------- 전체 탭 -----------------------------------------------------
  			innerHtml += 		'<div  class="tab1" style="min-heiht:300px;">';//전체 탭
  			for(var i=0;i<data.resultgrid.length;i++){
  				var result = data.resultgrid[i];
  				
	  			innerHtml += 		'<div class="tts_div">';
	  			innerHtml += 			'<p class="tts_tit">';
	  			innerHtml += 			'<a href="javascript:contentView(\'' + replaceAll(result.keys, '\"', '@') + '\',\'' + result.jobType + '\');">';
	  			
	  			if(result.title && result.title.length > 15){
	  				
	  				var keyIndexOf = result.title.indexOf($("#tsearchKeyword").val());
					
					if(keyIndexOf > 15){
						innerHtml += result.title.substring(keyIndexOf-(15-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
					}else if(result.title.length > 15){
						innerHtml += result.title.substring(0, 15);
					}else{
						innerHtml += result.title;	
					}	  				
	  				
	  			}else{
	  				innerHtml += result.title;
	  			}
	  			
	  			innerHtml +=			'</a>';
	  			innerHtml +=			'</p>';
	  			innerHtml += 			'<div class="tts_con">';
	  			innerHtml += 				'<div class="tts_pictxt">';
	  			innerHtml += 					'<div class="ico">';
	  			innerHtml += 						'<img src="/gw/Images/ico/file_ico2/ico_file_' + result.fileExtsn.toLowerCase()+ '.png" alt="" onerror="this.src=\'/gw/Images/ico/file_ico2/ico_file_etc.png\'"/>';
	  			innerHtml += 					'</div>';
	  			innerHtml += 					'<div class="pt_div">';
	  			innerHtml += 					'<div class="dot1">';
	  			
	  			//전체 탭에서 이미지일 경우
	  			if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='jpg' 
	  					|| result.fileExtsn.toLowerCase() =='jpeg' 
	  					|| result.fileExtsn.toLowerCase() =='gif' 
	  					|| result.fileExtsn.toLowerCase() =='png' 
	  					|| result.fileExtsn.toLowerCase() =='bmp')){
	  				
	  				if(result.jobType == "board-1" || result.jobType == "board-2"){
	  					innerHtml += boardFileImgTag(result.pkSeq, result.filePath, result.fileName);
	  				}else{
	  					var url = '<c:url value="/cmm/file/fileDownloadProc.do?fileId=' + result.fileId+ '&fileSn=' + result.fileSn + '"/>'; 
	  					innerHtml += '<img id="totalTabImg" width="109" height="66" src="' + url + '" onerror="this.src=\'/gw/Images/ico/media_noimg.png\'" />';
	  				}
	  			//전체 탭에서 동영상일 경우
	  			}else if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='mp4' || result.fileExtsn.toLowerCase() =='mov' || result.fileExtsn.toLowerCase() =='avi' 
	  					|| result.fileExtsn.toLowerCase() =='asf' || result.fileExtsn.toLowerCase() =='wmv' || result.fileExtsn.toLowerCase() =='mpeg'
	  					|| result.fileExtsn.toLowerCase() =='mpg' || result.fileExtsn.toLowerCase() =='mp3' || result.fileExtsn.toLowerCase() =='wma'
	  					|| result.fileExtsn.toLowerCase() =='wav' || result.fileExtsn.toLowerCase() =='flv')){
	  				innerHtml += '<img src="/gw/Images/ico/media_noimg.png" alt="" />';
	  			}else{
	  				if(result.fileContent && result.fileContent.length > 30){
	  					var keyIndexOf = result.fileContent.indexOf($("#tsearchKeyword").val());
	  					
	  					if(keyIndexOf > 30){
	  						innerHtml += result.fileContent.substring(keyIndexOf-(30-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
	  					}else{
	  						innerHtml += result.fileContent;
	  					}
	  				}else if(!result.fileContent || (result.fileContent && result.fileContent.length == 0)){
	  					innerHtml += '<%=BizboxAMessage.getMessage("","미리보기가 지원되지 않는 확장자입니다.")%>';
	  				}else if(result.fileContent && result.fileContent.length <= 30){
	  					innerHtml += result.fileContent;
	  				}
	  			}
	  			innerHtml += 					'</div>';
	  			innerHtml += 					'</div>';
	  			innerHtml += 				'</div>';
	  			innerHtml += 				'<div class="tts_file">';
	  			
	  			if(result.jobType == 'board-1' || result.jobType == 'board-2'){
	  				innerHtml += boardFileDownPop(result.pkSeq, result.filePath, result.fileName, result.fileName, result.jobType, result.fileSn, result.fileExtsn);
	  			}else if(result.jobType == 'edms-1'){
	  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
	  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'doc\')" class="dot2">';
	  				innerHtml += result.fileName;
	  				innerHtml += '</a>';
	  			}else if(result.jobType == 'edms-2'){
	  			//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
	  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'bpm\')" class="dot2">';
	  				innerHtml += result.fileName;
	  				innerHtml += '</a>';
	  			}else{
	  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
	  				innerHtml += result.fileName;
	  				innerHtml += '</a>';
	  			}
	  			innerHtml += 				'</div>';
	  			innerHtml += 				'<div class="na_dat">';
	  			innerHtml += 					'<span class="na"></span>';
	  			innerHtml += 					'<span class="dat">';
	  			innerHtml += result.createDate.replace("T", " ").substring(0, 10);
	  			innerHtml += 					'</span>';
	  			innerHtml += 				'</div>';
	  			innerHtml += 			'</div>';//tts_con
	  			innerHtml += 		'</div>';//tts_div
			}
  			innerHtml += 		'</div>';//end tab1
  			//------------------------------------------------- 이미지 탭 -----------------------------------------------------
  			innerHtml += 		'<div  class="tab2" style="min-heiht:300px;">';//이미지 탭
  			for(var i=0;i<data.resultgrid.length;i++){
  				var result = data.resultgrid[i];
  				
	  			if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='jpg' 
	  					|| result.fileExtsn.toLowerCase() =='jpeg' 
	  					|| result.fileExtsn.toLowerCase() =='gif' 
	  					|| result.fileExtsn.toLowerCase() =='png' 
	  					|| result.fileExtsn.toLowerCase() =='bmp')){
  				
		  			innerHtml += 		'<div class="tts_div">';
		  			innerHtml += 			'<p class="tts_tit">';
		  			innerHtml +=			'<div class="dot1">';
		  			innerHtml += 			'<a href="javascript:contentView(\'' + replaceAll(result.keys, '\"', '@') + '\',\'' + result.jobType + '\');">';
		  			
		  			if(result.title && result.title.length > 15){
		  				
		  				var keyIndexOf = result.title.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 15){
							innerHtml += result.title.substring(keyIndexOf-(15-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else if(result.title.length > 15){
							innerHtml += result.title.substring(0, 15) + '...';
						}else{
							innerHtml += result.title;	
						}	  				
		  				
		  			}else{
		  				innerHtml += result.title;
		  			}
		  			
		  			innerHtml +=			'</a>';
		  			innerHtml +=			'</div>';
		  			innerHtml +=			'</p>';
		  			innerHtml += 			'<div class="tts_con">';
		  			innerHtml += 				'<div class="tts_pictxt">';
		  			innerHtml += 					'<div class="ico">';
		  			innerHtml += 						'<img src="/gw/Images/ico/file_ico2/ico_file_' + result.fileExtsn.toLowerCase()+ '.png" alt="" onerror="this.src=\'/gw/Images/ico/file_ico2/ico_file_etc.png\'"/>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 					'<div class="pt_div">';
					innerHtml +=						'<a href="#n" class="dot1">';
					
					var url = '<c:url value="/cmm/file/fileDownloadProc.do?fileId=' + result.fileId+ '&fileSn=' + result.fileSn + '"/>';
  					
					
					if(result.jobType == "board-1" || result.jobType == "board-2"){
	  					innerHtml += boardFileImgTag(result.pkSeq, result.filePath, result.fileName);
	  				}else{
	  					var url = '<c:url value="/cmm/file/fileDownloadProc.do?fileId=' + result.fileId+ '&fileSn=' + result.fileSn + '"/>'; 
	  					innerHtml += '<img id="totalTabImg" width="109" height="66" src="' + url + '" onerror="this.src=\'/gw/Images/ico/media_noimg.png\'" />';
	  				}
 
					innerHtml +=						'</a>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="tts_file">';
		  			
		  			if(result.jobType == 'board-1' || result.jobType == 'board-2'){
		  				innerHtml += boardFileDownPop(result.pkSeq, result.filePath, result.fileName, result.fileName, result.jobType, result.fileSn, result.fileExtsn);
		  			}else if(result.jobType == 'edms-1'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'doc\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else if(result.jobType == 'edms-2'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'bpm\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else{
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="na_dat">';
		  			innerHtml += 					'<span class="na"></span>';
		  			innerHtml += 					'<span class="dat">';
		  			innerHtml += result.createDate.replace("T", " ").substring(0, 10);
		  			innerHtml += 					'</span>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 			'</div>';//tts_con
		  			innerHtml += 		'</div>';//tts_div
	  			}
			}
  			innerHtml += 		'</div>';//end tab2
			//------------------------------------------------- 문서 탭 -----------------------------------------------------
  			innerHtml += 		'<div  class="tab3" style="min-heiht:300px;">';//문서 탭
  			for(var i=0;i<data.resultgrid.length;i++){
  				var result = data.resultgrid[i];
  				
	  			if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='pdf' 
	  					|| result.fileExtsn.toLowerCase() =='pptx' 
	  					|| result.fileExtsn.toLowerCase() =='ppt' 
	  					|| result.fileExtsn.toLowerCase() =='xlsx' 
	  					|| result.fileExtsn.toLowerCase() =='xls'
  						|| result.fileExtsn.toLowerCase() =='docx'
						|| result.fileExtsn.toLowerCase() =='doc'
  						|| result.fileExtsn.toLowerCase() =='rtf'
  						|| result.fileExtsn.toLowerCase() =='hwpx'
  						|| result.fileExtsn.toLowerCase() =='hwp'
  						|| result.fileExtsn.toLowerCase() =='gul'
						|| result.fileExtsn.toLowerCase() =='txt')){
	  				
		  			innerHtml += 		'<div class="tts_div">';
		  			innerHtml += 			'<p class="tts_tit">';
		  			innerHtml += 			'<a href="javascript:contentView(\'' + replaceAll(result.keys, '\"', '@') + '\',\'' + result.jobType + '\');">';
		  			
		  			if(result.title && result.title.length > 15){
		  				
		  				var keyIndexOf = result.title.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 15){
							innerHtml += result.title.substring(keyIndexOf-(15-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else if(result.title.length > 15){
							innerHtml += result.title.substring(0, 15) + '...';
						}else{
							innerHtml += result.title;	
						}	  				
		  				
		  			}else{
		  				innerHtml += result.title;
		  			}
		  			
		  			innerHtml +=			'</a>';
		  			innerHtml +=			'</p>';
		  			innerHtml += 			'<div class="tts_con">';
		  			innerHtml += 				'<div class="tts_pictxt">';
		  			innerHtml += 					'<div class="ico">';
		  			innerHtml += 						'<img src="/gw/Images/ico/file_ico2/ico_file_' + result.fileExtsn.toLowerCase()+ '.png" alt="" onerror="this.src=\'/gw/Images/ico/file_ico2/ico_file_etc.png\'"/>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 					'<div class="pt_div">';
		  			innerHtml += 					'<div class="dot1">';
		  			
	  				if(result.fileContent && result.fileContent.length > 30){
	  					var keyIndexOf = result.fileContent.indexOf($("#tsearchKeyword").val());
	  					
	  					if(keyIndexOf > 30){
	  						innerHtml += result.fileContent.substring(keyIndexOf-(30-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
	  					}else{
	  						innerHtml += result.fileContent;
	  					}
	  				}else if(!result.fileContent || (result.fileContent && result.fileContent.length == 0)){
	  					innerHtml += '<%=BizboxAMessage.getMessage("","미리보기가 지원되지 않는 확장자입니다.")%>';
	  				}else if(result.fileContent && result.fileContent.length <= 30){
	  					innerHtml += result.fileContent;
	  				}
	  				
		  			innerHtml += 					'</div>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="tts_file">';
		  			
		  			if(result.jobType == 'board-1' || result.jobType == 'board-2'){
		  				innerHtml += boardFileDownPop(result.pkSeq, result.filePath, result.fileName, result.fileName, result.jobType, result.fileSn, result.fileExtsn);
		  			}else if(result.jobType == 'edms-1'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'doc\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else if(result.jobType == 'edms-2'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'bpm\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else{
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="na_dat">';
		  			innerHtml += 					'<span class="na"></span>';
		  			innerHtml += 					'<span class="dat">';
		  			innerHtml += result.createDate.replace("T", " ").substring(0, 10);
		  			innerHtml += 					'</span>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 			'</div>';//tts_con
		  			innerHtml += 		'</div>';//tts_div
	  			}
			}
  			innerHtml += 		'</div>';//end tab3
  			//------------------------------------------------- 멀티미디어 탭 -----------------------------------------------------
  			innerHtml += 		'<div  class="tab4" style="min-heiht:300px;">';//멀티미디어 탭
  			for(var i=0;i<data.resultgrid.length;i++){
  				var result = data.resultgrid[i];
  				
  				if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='mp4' || result.fileExtsn.toLowerCase() =='mov' || result.fileExtsn.toLowerCase() =='avi' 
  					|| result.fileExtsn.toLowerCase() =='asf' || result.fileExtsn.toLowerCase() =='wmv' || result.fileExtsn.toLowerCase() =='mpeg'
  					|| result.fileExtsn.toLowerCase() =='mpg' || result.fileExtsn.toLowerCase() =='mp3' || result.fileExtsn.toLowerCase() =='wma'
  					|| result.fileExtsn.toLowerCase() =='wav' || result.fileExtsn.toLowerCase() =='flv')){
	  				
		  			innerHtml += 		'<div class="tts_div">';
		  			innerHtml += 			'<p class="tts_tit">';
		  			innerHtml += 			'<a href="javascript:contentView(\'' + replaceAll(result.keys, '\"', '@') + '\',\'' + result.jobType + '\');">';
		  			
		  			if(result.title && result.title.length > 15){
		  				
		  				var keyIndexOf = result.title.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 15){
							innerHtml += result.title.substring(keyIndexOf-(15-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else if(result.title.length > 15){
							innerHtml += result.title.substring(0, 15) + '...';
						}else{
							innerHtml += result.title;	
						}	  				
		  				
		  			}else{
		  				innerHtml += result.title;
		  			}
		  			
		  			innerHtml +=			'</a>';
		  			innerHtml +=			'</p>';
		  			innerHtml += 			'<div class="tts_con">';
		  			innerHtml += 				'<div class="tts_pictxt">';
		  			innerHtml += 					'<div class="ico">';
		  			innerHtml += 						'<img src="/gw/Images/ico/file_ico2/ico_file_' + result.fileExtsn.toLowerCase()+ '.png" alt="" onerror="this.src=\'/gw/Images/ico/file_ico2/ico_file_etc.png\'"/>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 					'<div class="pt_div">';
		  			innerHtml += 					'<div class="dot1">';
		  			
	  				if(result.fileContent && result.fileContent.length > 30){
	  					var keyIndexOf = result.fileContent.indexOf($("#tsearchKeyword").val());
	  					
	  					if(keyIndexOf > 30){
	  						innerHtml += result.fileContent.substring(keyIndexOf-(30-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
	  					}else{
	  						innerHtml += result.fileContent;
	  					}
	  				}else if(!result.fileContent || (result.fileContent && result.fileContent.length == 0)){
	  					innerHtml += '<img id="totalTabImg" width="109" height="66" src="/gw/Images/ico/media_noimg.png" />';
	  				}else if(result.fileContent && result.fileContent.length <= 30){
	  					innerHtml += result.fileContent;
	  				}
	  				
		  			innerHtml += 					'</div>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="tts_file">';
		  			
		  			if(result.jobType == 'board-1' || result.jobType == 'board-2'){
		  				innerHtml += boardFileDownPop(result.pkSeq, result.filePath, result.fileName, result.fileName, result.jobType, result.fileSn, result.fileExtsn);
		  			}else if(result.jobType == 'edms-1'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'doc\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else if(result.jobType == 'edms-2'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'bpm\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else{
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="na_dat">';
		  			innerHtml += 					'<span class="na"></span>';
		  			innerHtml += 					'<span class="dat">';
		  			innerHtml += result.createDate.replace("T", " ").substring(0, 10);
		  			innerHtml += 					'</span>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 			'</div>';//tts_con
		  			innerHtml += 		'</div>';//tts_div
	  			}
			}
  			innerHtml += 		'</div>';//end tab4
  			//------------------------------------------------- 기타 탭 -----------------------------------------------------
  			innerHtml += 		'<div  class="tab5" style="min-heiht:300px;">';//기타 탭
  			for(var i=0;i<data.resultgrid.length;i++){
  				var result = data.resultgrid[i];
  				
  				if(result.fileExtsn && (result.fileExtsn.toLowerCase() !='mp4' && result.fileExtsn.toLowerCase() !='mov' && result.fileExtsn.toLowerCase() !='avi' 
  					&& result.fileExtsn.toLowerCase() !='asf' && result.fileExtsn.toLowerCase() !='wmv' && result.fileExtsn.toLowerCase() !='mpeg'
  					&& result.fileExtsn.toLowerCase() !='mpg' && result.fileExtsn.toLowerCase() !='mp3' && result.fileExtsn.toLowerCase() !='wma'
  					&& result.fileExtsn.toLowerCase() !='wav' && result.fileExtsn.toLowerCase() !='flv' && result.fileExtsn.toLowerCase() !='pdf' 
	  				&& result.fileExtsn.toLowerCase() !='pptx'&& result.fileExtsn.toLowerCase() !='ppt' && result.fileExtsn.toLowerCase() !='xlsx' 
		  			&& result.fileExtsn.toLowerCase() !='xls' && result.fileExtsn.toLowerCase() !='docx'&& result.fileExtsn.toLowerCase() !='doc'
 					&& result.fileExtsn.toLowerCase() !='rtf' && result.fileExtsn.toLowerCase() !='hwpx' && result.fileExtsn.toLowerCase() !='hwp' && result.fileExtsn.toLowerCase() !='gul'
					&& result.fileExtsn.toLowerCase() !='txt' && result.fileExtsn.toLowerCase() !='bmp' && result.fileExtsn.toLowerCase() !='png'
					&& result.fileExtsn.toLowerCase() !='jpg' && result.fileExtsn.toLowerCase() !='jpeg' && result.fileExtsn.toLowerCase() !='gif')){
	  				
		  			innerHtml += 		'<div class="tts_div">';
		  			innerHtml += 			'<p class="tts_tit">';
		  			innerHtml += 			'<a href="javascript:contentView(\'' + replaceAll(result.keys, '\"', '@') + '\',\'' + result.jobType + '\');">';
		  			
		  			if(result.title && result.title.length > 15){
		  				
		  				var keyIndexOf = result.title.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 15){
							innerHtml += result.title.substring(keyIndexOf-(15-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else if(result.title.length > 15){
							innerHtml += result.title.substring(0, 15) + '...';
						}else{
							innerHtml += result.title;	
						}	  				
		  				
		  			}else{
		  				innerHtml += result.title;
		  			}
		  			
		  			innerHtml +=			'</a>';
		  			innerHtml +=			'</p>';
		  			innerHtml += 			'<div class="tts_con">';
		  			innerHtml += 				'<div class="tts_pictxt">';
		  			innerHtml += 					'<div class="ico">';
		  			innerHtml += 						'<img src="/gw/Images/ico/file_ico2/ico_file_' + result.fileExtsn.toLowerCase()+ '.png" alt="" onerror="this.src=\'/gw/Images/ico/file_ico2/ico_file_etc.png\'"/>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 					'<div class="pt_div">';
		  			innerHtml += 						'<div class="dot1"><img src="/gw/Images/ico/sample_video01.png" alt="" />';
		  			innerHtml += 						'</div>';
		  			innerHtml += 					'</div>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="tts_file">';
		  			
		  			if(result.jobType == 'board-1' || result.jobType == 'board-2'){
		  				innerHtml += boardFileDownPop(result.pkSeq, result.filePath, result.fileName, result.fileName, result.jobType, result.fileSn, result.fileExtsn);
		  			}else if(result.jobType == 'edms-1'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=doc&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'doc\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else if(result.jobType == 'edms-2'){
		  				//innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&moduleTp=bpm&pathSeq=600&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'bpm\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}else{
		  				innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\')" class="dot2">';
		  				innerHtml += result.fileName;
		  				innerHtml += '</a>';
		  			}
		  			innerHtml += 				'</div>';
		  			innerHtml += 				'<div class="na_dat">';
		  			innerHtml += 					'<span class="na"></span>';
		  			innerHtml += 					'<span class="dat">';
		  			innerHtml += result.createDate.replace("T", " ").substring(0, 10);
		  			innerHtml += 					'</span>';
		  			innerHtml += 				'</div>';
		  			innerHtml += 			'</div>';//tts_con
		  			innerHtml += 		'</div>';//tts_div
	  			}
			}
  			innerHtml += 		'</div>';//end tab5
  			//-------------------------------------------------------------
  			innerHtml +=	'</div>';//end tab_style
			innerHtml +='</div>';//end tab_page
  		}
  		//원피스 화면 처리.
  		else if(boardType == "12"){
  			innerHtml += '<div class="tab_page mt10">';
  			innerHtml += '<div class="tab_style"  id="tabstrip2">';
  			innerHtml += '<ul style="display:none">';
  			innerHtml += '<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000000862","전체")%></li>';
  			innerHtml += '</ul>';
  			innerHtml += '<div  class="tab1" style="min-heiht:300px;">';
			for(var i=0;i<data.resultgrid.length;i++){
  				var result = data.resultgrid[i];
  				
	  			innerHtml += '<div class="tts_div h160">';
	  			innerHtml += '<div class="tts_con">';
	  			innerHtml += '<div class="tts_pictxt brtn">';
	  			innerHtml += '<div class="ico pt0">';
	  			innerHtml += '<img src="/gw/Images/ico/file_ico2/ico_oneffice.png" width="58" height="70" alt="" />';
	  			innerHtml += '</div>';
	  			innerHtml += '<div class="pt_div">';
	  			if(result.content && result.content.length > 0){
	  				innerHtml += '<div class="dot1 pt0">' + result.content + '</div>';
	  			}else{
	  				innerHtml += '<div class="dot1 pt0">' + '<%=BizboxAMessage.getMessage("","검색내용이 없어 제공하지 않습니다.")%>' + '</div>';
	  			}
	  			innerHtml += '</div>';
	  			innerHtml += '</div>';
	  			innerHtml += '<div class="tts_file lh18">';
	  			innerHtml += '<a href="javascript:onefficeMove(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\');">';
	  			innerHtml += result.docName;
	  			innerHtml += '</a>';
	  			innerHtml += '</div>';
	  			innerHtml += '<div class="na_dat">';
	  			if(result.shareYn =='Y'){
	  				innerHtml += '<span class="na"><img src="/gw/Images/ico/ico_share.png" class="mr5"/>' + '<%=BizboxAMessage.getMessage("","공유받은 문서")%>' + '</span>';	
	  			}
	  			var modDate = '';
	  			if(result.modDate){
	  				modDate = result.modDate.replace("T", " ").substring(0, 10);
	  			}
	  			innerHtml += '<span class="dat">' + modDate + '</span>';
	  			innerHtml += '</div>';
	  			innerHtml += '</div>';
	  			innerHtml += '</div>';
			}
			innerHtml += '</div>';
			innerHtml += '</div>';
			innerHtml += '</div>';
  		
  		}
  		//인물 화면 처리
  		else if(boardType == "11"){
  			var profilePath = '${profilePath}';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				var result = data.resultgrid[i];
 
  				var activeShow = '';
  				
  				if(hrSearchYn){//인물전용 검색일 경우
  					innerHtml += '<p class="tit_peo mt20"><%=BizboxAMessage.getMessage("TX000020786","인물정보")%></p>';
  				}else {//그냥 검색일 경우
  					activeShow = '<input onClick="javascript:getTotalSearchHr(\'4\',\'' + result.empSeq +'\');" type="button" value="<%=BizboxAMessage.getMessage("TX000020785","활동보기")%>" class="fr small_btn mt5" />';
  				}
  				
  				innerHtml += '<div class="pp_div">';
  				
  				
  				
  				innerHtml += 	'<table>';
  				innerHtml += 		'<colgroup>';
  				innerHtml += 			'<col width=""/>';
  				innerHtml += 			'<col width="53"/>';
  				innerHtml += 			'<col width="172"/>';
  				innerHtml += 			'<col width="64"/>';
  				innerHtml += 			'<col width="82"/>';
  				innerHtml += 		'</colgroup>';
  				innerHtml += 		'<tr>';
  				innerHtml += 			'<td class="pic" rowspan="5">';
  				innerHtml += 				'<img id="img_picFileIdNew" src="' + profilePath + '/' + result.empSeq + '_thum.jpg?<%=System.currentTimeMillis()%>" onerror="this.src=\'/gw/Images/bg/mypage_noimg.png\'"/>';
  				innerHtml += 			'</td>';
  				innerHtml += 			'<td class="na_td" colspan="4">';
  				innerHtml += 				'<span class="match">' + result.empName + '</span>';
  				innerHtml += 				'<span class="po">' + result.positionName +'/' + result.dutyName + '</span>';
  				innerHtml += activeShow;
  				innerHtml += 			'</td>';
  				innerHtml += 		'</tr>';
  				innerHtml += 		'<tr>';
  				innerHtml += 			'<th><%=BizboxAMessage.getMessage("TX000000083","생년월일")%></th>';
  				innerHtml += 			'<td>' + result.bday + '</td>';
  				innerHtml += 			'<th><%=BizboxAMessage.getMessage("TX000005040","사무실번호")%></th>';
  				innerHtml += 			'<td>' + result.telNum + '</td>';
  				innerHtml += 		'</tr>';
  				innerHtml += 		'<tr>';
  				innerHtml += 			'<th><%=BizboxAMessage.getMessage("TX000000008","핸드폰")%></th>';
  				innerHtml += 			'<td>' + result.mobileTelNum + '</td>';
  				innerHtml += 			'<th><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>';
  				innerHtml += 			'<td>' + result.faxNum + '</td>';
  				innerHtml += 		'</tr>';
  				innerHtml += 		'<tr>';
  				innerHtml += 			'<th><%=BizboxAMessage.getMessage("TX000000949","메일주소")%></th>';
  				innerHtml += 			'<td>' + result.emailAddr + '</td>';
  				innerHtml += 			'<th><%=BizboxAMessage.getMessage("TX000000088","담당업무")%></th>';
  				innerHtml += 			'<td>' + result.mainWork + '</td>';
  				innerHtml += 		'</tr>';
  				innerHtml += 		'<tr>';
  				innerHtml += 			'<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>';
  				innerHtml += 			'<td colspan="3">' + result.compDeptName + '</td>';
  				innerHtml += 		'</tr>';
  				innerHtml += 	'</table>';
  				innerHtml += '</div>';
  			}
  		}
  		//일정 화면 처리.
  		else if(boardType == "3"){
  			
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				//일정 pkSeq로직
  				var pkSeq1 = '';
  				var pkSeq2 = '';
  				if(result.pkSeq && result.pkSeq != ''){
  					var pkSeqS = result.pkSeq.split(',');
  					for(var j=0;j<pkSeqS.length;j++){
  						if(j==0){
  							pkSeq1 = pkSeqS[0];
  						}else if(j==1){
  							pkSeq2 = pkSeqS[1];
  						}
  					}
  				}
  				//1. title_line 처리
  				innerHtml += '<li class=\"list\">';
				innerHtml += 	'<div class=\"title_line\">';
				innerHtml += 		'<span class=\"box_txt\">';
				
				if(jobType =='schedule-1'){
					if(result.gbnCode =='G' || result.gbnCode =='D'){
						innerHtml += '<%=BizboxAMessage.getMessage("TX000012110","공유")%>';
					}else if(result.gbnCode =='E'){
						innerHtml += '<%=BizboxAMessage.getMessage("TX000002835","개인")%>';
					}else if(result.gbnCode =='P'){
						innerHtml += '<%=BizboxAMessage.getMessage("TX000000519","프로젝트")%>';
					}else{
						innerHtml += '<%=BizboxAMessage.getMessage("TX000012110","공유")%>';
					}
				}else if(jobType =='schedule-2'){
					innerHtml += '<%=BizboxAMessage.getMessage("TX000012112","자원")%>';
				}
				
				//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
				innerHtml += 		'</span>';
				innerHtml += 		'<h3 class="title_line_txt">';
				innerHtml += 		'<a href="javascript:scheduleMove(\'' + pkSeq1 +'\',\'' + pkSeq2 + '\');">';
				
				//제목
				if(jobType =='schedule-1'){
					innerHtml += result.schTitle;
  				}else if(jobType =='schedule-2'){
  					innerHtml += result.reqText;
  				}
  					
				innerHtml += 		'</a>';
				innerHtml += 		'</h3>';
				innerHtml += 		'<ul class="misc">';
				innerHtml += 		'<li><span id="">';
				
				//날짜
				if(result.startDate.length > 10){
					var startDate = fnDateTypeReturn(result.startDate.replace("T", " ").substring(0, 16),'s');
					innerHtml += startDate;
				}
				innerHtml += ' ~ ';
				
				if(result.endDate.length > 10){
					
					var endDate = fnDateTypeReturn(result.endDate.replace("T", " ").substring(0, 16),'s');
					innerHtml += endDate;
				}
				
				innerHtml += 		'</span></li>';
				innerHtml += 	'</ul>';
				innerHtml += 	'</div>';
				
				//3. contents_line 처리 (내용)
				if((result.jobType == 'schedule-1' && result.contents && result.contents != '') || (result.jobType == 'schedule-2' && result.descText && result.descText != '')){
					innerHtml += '<div class="contens_line">';
					
					if(result.jobType == 'schedule-2'){
						innerHtml += '<ul class="contents_list_type">';
						innerHtml += 	'<li>';
						innerHtml += 		'<dl>';
						innerHtml += 			'<dt><%=BizboxAMessage.getMessage("TX000012088","자원명")%> : </dt>';
						innerHtml += 			'<dd class="highlight">' + result.resName + '</dd>';
						innerHtml += 		'</dl>';
						innerHtml += 	'</li>';
						innerHtml += '</ul>';
					}
					innerHtml += '<p class="contents_text_type">';
					
					if(result.contents && result.contents.length > 230 && result.jobType == 'schedule-1'){
						var keyIndexOf = result.contents.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 230){
							innerHtml += result.contents.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else{
							innerHtml += result.contents.substring(0, 230);
						}
						
					}else if(result.descText && result.descText.length > 230 && result.jobType == 'schedule-2'){
						var keyIndexOf = result.descText.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 230){
							innerHtml += result.descText.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else{
							innerHtml += result.descText.substring(0, 230);
						}
					}else if(result.contents && result.contents.length <= 230 && result.jobType == 'schedule-1'){
						innerHtml += result.contents;
					}else if(result.descText && result.descText.length <= 230 && result.jobType == 'schedule-2'){
						innerHtml += result.descText;
					}
					innerHtml += '<a href="javascript:scheduleMove(\'' + pkSeq1 +'\',\'' + pkSeq2 + '\');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
					innerHtml += '</p>';
					innerHtml += '</div>';
				}
				innerHtml += '</li>';//리스트 마지막 종료 태그
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}
  		//전자결재(영리/비영리)
		else if(boardType == "6" || boardType == "7"){
  			
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				//1. title_line 처리
  				innerHtml += '<li class=\"list\">';
  	  			innerHtml += 	'<div class=\"title_line\">';
  	  			innerHtml += 		'<span class=\"box_txt\">';
  	  			if(result.formNm){
  					innerHtml += result.formNm[langCode.toLowerCase()];
  	  			}
  	  			innerHtml += 		'</span>';
  	  			//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
  	  			innerHtml += 		'<h3 class="title_line_txt">';
	  			innerHtml += 		'<a href="javascript:eapPop(\'' + result.pkSeq + '\',\'' + result.formId + '\',\'' + result.migYn + '\');">';
  	  			//제목
 	  			innerHtml += result.docTitle;
  	  			innerHtml += '		</a>';
  	  			innerHtml += '		</h3>';
  	  			innerHtml += '		<ul class="misc">';
  	  			innerHtml += '		<li><span id="">';
  	  			//날짜
  	  			if(boardType == "6"){
  					innerHtml += fnHangleType2Return(JSON.stringify(result.formNm));
  	  			}else if(boardType == "7"){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000000494","기안일")%> :'; 
  	  			}
  				if(result.docDate && result.docDate.length > 10){
  					innerHtml += result.docDate.replace("T", " ").substring(0, 10);
  				}else if(result.docDate && result.docDate.length < 10) {
  					innerHtml += fnDateTypeReturn(result.docDate, '-');
  				}
  	  			innerHtml += '		</span></li>';
  	  			innerHtml += '	</ul>';
  	  			innerHtml += '	</div>';
  	  			//3. contents_line 처리 (내용)
  	  			if(result.docContents && result.docContents != ''){
  	  				
  	  				innerHtml += '<div class="contens_line">';
  					innerHtml += 	'<ul class="contents_list_type">';
  					innerHtml += 		'<li>';
  					innerHtml += 			'<dl>';
  					
  					var dtName = '<%=BizboxAMessage.getMessage("TX000000663","문서번호")%> : ';
  					if(result.docNo == null){
  						result.docNo ="-";
  					}
  					innerHtml += 				'<dt>' + dtName + '</dt>';
  					innerHtml += 				'<dd>' + result.docNo + '</dd>';
  					innerHtml += 			'</dl>';
  					innerHtml += 		'</li>';
  					innerHtml += 	'</ul>';
  	  				innerHtml += 	'<p class="contents_text_type">';
  	  				if(result.docContents && result.docContents.length > 230){
  	  					var keyIndexOf = result.docContents.indexOf($("#tsearchKeyword").val());
  	  					
  	  					if(keyIndexOf > 230){
  	  						innerHtml += result.docContents.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
  	  					}else{
  	  						innerHtml += result.docContents.substring(0, 230);
  	  					}
  	  					
  	  				}else if(result.docContents && result.docContents.length <= 230){
	  					innerHtml += result.docContents;
	  				}else if(!result.docContents || (result.docContents && result.docContents.length == 0)){
	  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
	  				}
  	  				innerHtml += '<a href="javascript:eapPop(\'' + result.pkSeq +'\',\'' + result.formId + '\',\'' + result.migYn + '\');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
  	  				innerHtml += '</p>';
  	  				innerHtml += '</div>';
  	  			}
  	  			innerHtml += '</li>';//리스트 마지막 종료 태그
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}//노트
		else if(boardType == "4"){
  			
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				//1. title_line 처리
  				innerHtml += '<li class=\"list\">';
  	  			innerHtml += 	'<div class=\"title_line\">';
  	  			innerHtml += 		'<span class=\"box_txt\">';
  	  			if(result.folderName == ''){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000010157","노트")%>';
  	  			}
  				innerHtml += result.folderName; 
  	  			innerHtml += 		'</span>';
  	  			//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
  	  			innerHtml += 		'<h3 class="title_line_txt">';
	  			innerHtml += 		'<a href="javascript:noteMove(' + result.pkSeq + ');">';
  	  			//제목
 	  			innerHtml += result.noteName;
  	  			innerHtml += '		</a>';
  	  			innerHtml += '		</h3>';
  	  			innerHtml += '		<ul class="misc">';
  	  			innerHtml += '		<li><span id="">';
  	  			//날짜
  				if(result.docDate){
  					innerHtml += result.noteDate.replace("T", " ");
  				}
  	  			innerHtml += '		</span></li>';
  	  			innerHtml += '	</ul>';
  	  			innerHtml += '	</div>';
  	  			//3. contents_line 처리 (내용)
  	  			if(result.contents && result.contents != ''){
  	  				
  	  				innerHtml += '<div class="contens_line">';
  	  				innerHtml += 	'<p class="contents_text_type">';
  	  				if(result.contents && result.contents.length > 230){
  	  					var keyIndexOf = result.contents.indexOf($("#tsearchKeyword").val());
  	  					
  	  					if(keyIndexOf > 230){
  	  						innerHtml += result.contents.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
  	  					}else{
  	  						innerHtml += result.contents.substring(0, 230);
  	  					}
  	  					
  	  				}else if(result.contents && result.contents.length <= 230){
	  					innerHtml += result.contents;
	  				}else if(!result.contents || (result.contents && result.contents.length == 0)){
	  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
	  				}
  	  				innerHtml += '<a href="javascript:noteMove(' + result.pkSeq +');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
  	  				innerHtml += '</p>';
  	  				innerHtml += '</div>';
  	  			}
  	  			innerHtml += '</li>';//리스트 마지막 종료 태그
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}
  		//업무보고 화면 처리.
		else if(boardType == "5"){
  			
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				//1. title_line 처리
  				innerHtml += '<li class=\"list\">';
  	  			innerHtml += 	'<div class=\"title_line\">';
  	  			innerHtml += 		'<span class=\"box_txt\">';
  	  			if(jobType == 'report-1'){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000006542","일일")%>';
  	  			}else if(jobType == 'report-2'){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000006781","수시")%>';
  	  			}
  	  			innerHtml += 		'</span>';
  	  			//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
  	  			innerHtml += 		'<h3 class="title_line_txt">';
	  			innerHtml += 		'<a href="javascript:reportPop(\'' + result.reportSeq + '\',\'' + result.jobType + '\',\'' + result.createSeq + '\',\'' + result.targetEmpSeq + '\',\'' + result.openYn + '\');">';
  	  			//제목
 	  			innerHtml += result.title;
  	  			innerHtml += '		</a>';
  	  			innerHtml += '		</h3>';
  	  			innerHtml += '		<ul class="misc">';
  	  			innerHtml += '		<li><span id=""><%=BizboxAMessage.getMessage("TX000008462","보고일")%> : ';
  	  			//날짜
  				if(result.reportDate){
  					innerHtml += fnDateTypeReturn(result.reportDate, '-');
  				}
  	  			innerHtml += '		</span></li>';
  	  			innerHtml += '	</ul>';
  	  			innerHtml += '	</div>';
				//임시 Contents_line 삭제함. 원피스 업무보고 깨짐현상
				//totalSearchContent.jsp 1966~2031 line innerHtml로 변환 작업 필요
  	  			innerHtml += '</li>';//리스트 마지막 종료 태그
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}
  		//업무관리 화면 처리.
  		else if(boardType == "2"){
  			
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
				
  				if(jobType =='project-1' || jobType =='project-2' || jobType =='project-3' || jobType =='board-3'){
  				
	  				//1. title_line 처리
	  				innerHtml += '<li class=\"list\">';
					innerHtml += 	'<div class=\"title_line\">';
					innerHtml += 		'<span class=\"box_txt\">';
					
					if(jobType =='project-1'){
						innerHtml += '<%=BizboxAMessage.getMessage("TX000000519","프로젝트")%>';
					}else if(jobType =='project-2'){
						innerHtml += '<%=BizboxAMessage.getMessage("TX000010930","업무")%>';
					}else if(jobType =='project-3'){
						innerHtml += '<%=BizboxAMessage.getMessage("TX000007154","할일")%>';
					}else if(jobType =='board-3'){
						innerHtml += result.catTitle;
					}
					
					//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
					innerHtml += 		'</span>';
					innerHtml += 		'<h3 class="title_line_txt">';
					
					if(jobType =='project-1'){
						innerHtml += 		'<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');">';
						innerHtml += result.prjName;
					}else if(jobType =='project-2'){
						innerHtml += 		'<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');">';
						innerHtml += result.workName;
					}else if(jobType =='project-3'){
						innerHtml += 		'<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');">';
						innerHtml += result.jobName;
					}else if(jobType =='board-3'){
						innerHtml += 		'<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');">';
						innerHtml += result.artTitle;
					}
					
					innerHtml += 		'</a>';
					innerHtml += 		'</h3>';
					innerHtml += 		'<ul class="misc">';
					innerHtml += 		'<li><span id="">';
					
					if(jobType =='project-1'){
						innerHtml += fnDateTypeReturn(result.prjSdDate,'-');
						innerHtml += '~';
						innerHtml += fnDateTypeReturn(result.prjEdDate,'-');
					}else if(jobType =='project-2'){
						innerHtml += fnDateTypeReturn(result.workSdDate,'-');
						innerHtml += '~';
						innerHtml += fnDateTypeReturn(result.workEdDate,'-');
					}else if(jobType =='project-3'){
						innerHtml += fnDateTypeReturn(result.jobSdDate,'-');
						innerHtml += '~';
						innerHtml += fnDateTypeReturn(result.jobEdDate,'-');
					}else if(jobType =='board-3'){
						if(result.writeDate && result.writeDate.length > 10){
							innerHtml += result.writeDate.replace('T', ' ').substring(0,10);
						}
					}
					
					innerHtml += 		'</span></li>';
					innerHtml += 	'</ul>';
					innerHtml += 	'</div>';
					
					//3. contents_line 처리 (내용)
					if((result.jobType == 'project-1' && result.dcRmk != '') || (result.jobType == 'project-2' && result.workContents != '') || (result.jobType == 'project-3' && result.jobDetail != '') || (result.jobType == 'board-3' && result.artContent != '')){
						innerHtml += '<div class="contens_line">';
						
						if(result.jobType == 'schedule-2'){
							innerHtml += '<ul class="contents_list_type">';
							innerHtml += 	'<li>';
							innerHtml += 		'<dl>';
							innerHtml += 			'<dt><%=BizboxAMessage.getMessage("TX000012088","자원명")%> : </dt>';
							innerHtml += 			'<dd class="highlight">' + result.resName + '</dd>';
							innerHtml += 		'</dl>';
							innerHtml += 	'</li>';
							innerHtml += '</ul>';
						}
						innerHtml += '<p class="contents_text_type">';
						
						if(result.dcRmk && result.dcRmk.length > 230 && result.jobType == 'project-1'){
							var keyIndexOf = result.dcRmk.indexOf($("#tsearchKeyword").val());
							
							if(keyIndexOf > 230){
								innerHtml += result.dcRmk.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
							}else{
								innerHtml += result.dcRmk.substring(0, 230);
							}
							
						}else if(result.workContents && result.workContents.length > 230 && result.jobType == 'project-2'){
							var keyIndexOf = result.workContents.indexOf($("#tsearchKeyword").val());
							
							if(keyIndexOf > 230){
								innerHtml += result.workContents.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
							}else{
								innerHtml += result.workContents.substring(0, 230);
							}
						}else if(result.jobDetail && result.jobDetail.length > 230 && result.jobType == 'project-3'){
							var keyIndexOf = result.jobDetail.indexOf($("#tsearchKeyword").val());
							
							if(keyIndexOf > 230){
								innerHtml += result.jobDetail.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
							}else{
								innerHtml += result.jobDetail.substring(0, 230);
							}
						}else if(result.artContent && result.artContent.length > 230 && result.jobType == 'board-3'){
							var keyIndexOf = result.artContent.indexOf($("#tsearchKeyword").val());
							
							if(keyIndexOf > 230){
								innerHtml += result.artContent.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
							}else{
								innerHtml += result.artContent.substring(0, 230);
							}
						}else if(result.dcRmk && result.dcRmk.length <= 230 && result.jobType == 'project-1'){
							innerHtml += result.dcRmk;
						}else if(result.workContents && result.workContents.length <= 230 && result.jobType == 'project-2'){
							innerHtml += result.workContents;
						}else if(result.jobDetail && result.jobDetail.length <= 230 && result.jobType == 'project-3'){
							innerHtml += result.jobDetail;
						}else if(result.artContent && result.artContent.length <= 230 && result.jobType == 'board-3'){
							innerHtml += result.artContent;
						}else if(!result.dcRmk || (result.dcRmk && result.dcRmk.length == 0 && result.jobType == 'project-1')){
		  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
		  				}else if(!result.workContents || (result.workContents && result.workContents.length == 0 && result.jobType == 'project-2')){
		  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
		  				}else if(!result.jobDetail || (result.jobDetail && result.jobDetail.length == 0 && result.jobType == 'project-3')){
		  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
		  				}else if(!result.artContent || (result.artContent && result.artContent.length == 0 && result.jobType == 'board-3')){
		  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
		  				}
						
						if(result.jobType == 'project-1' || result.jobType == 'project-2' || result.jobType == 'project-3'){
							innerHtml += '<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';							
						}else if(result.jobType == 'board-3'){
							innerHtml += '<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
						}
		
						innerHtml += '</p>';
						innerHtml += '</div>';
					}
					innerHtml += '</li>';//리스트 마지막 종료 태그
  				}
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}
  		//메일 화면 처리.
  		else if(boardType == "0"){
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				//1. title_line 처리
  				innerHtml += '<li class=\"list\">';
  	  			innerHtml += 	'<div class=\"title_line\">';
  	  			innerHtml += 		'<span class=\"box_txt\">';
  				innerHtml += fnMainInBoxNameReturn(result.boxName);
  	  			innerHtml += 		'</span>';
  	  			//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
  	  			innerHtml += 		'<h3 class="title_line_txt">';
  	  	
  	  			//제목
  				innerHtml += 		'<a href="javascript:mailMove(\'' + result.emailAddr + '\',\'' + result.muid + '\');">';
  				innerHtml += result.subject; 
  	  			innerHtml += '		</a>';
  	  			innerHtml += '		</h3>';
  	  			innerHtml += '		<ul class="misc">';
  	  			//날짜
  	  			innerHtml += '		<li><span id="">From : ';
  				innerHtml += result.mailFrom;
  	  			innerHtml += '		</span></li>';
  	  			innerHtml += '		<li><span id="">To : ';
				innerHtml += fnMailToOtherReturn(result.mailTo.replace('&lt;','<').replace('&gt;','>').replace('\"','').replace('\'',''));
	  			innerHtml += '		</span></li>';
	  			innerHtml += '		<li><span id=""><%=BizboxAMessage.getMessage("TX000000480","날짜")%> : ';
	  			if(result.rfc822date && result.rfc822date.length > 10){
	  				innerHtml += result.rfc822date.replace("T", " ").substring(0, 10);
	  			}
	  			innerHtml += '		</span></li>';
  	  			innerHtml += '	</ul>';
  	  			innerHtml += '	</div>';
  	  			//3. contents_line 처리 (내용)
  	  			innerHtml += '<div class="contens_line">';
				innerHtml += 	'<p class="contents_text_type">';
				
				if(result.mailBody && result.mailBody.length > 230){
  	  				var keyIndexOf = result.mailBody.indexOf($("#tsearchKeyword").val());
  	  				
  	  				if(keyIndexOf > 230){
  	  					innerHtml += result.mailBody.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
  	  				}else{
  	  					innerHtml += result.mailBody.substring(0, 230);
  	  				}
  	  				
  	  			}else{
  	  				innerHtml += result.mailBody;
  	  			}
  	  				
  	  			innerHtml += 	'<a href="javascript:mailMove(\'' + result.emailAddr + '\',\'' + result.muid + '\');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
  	  			innerHtml += 	'</p>';
  	  			innerHtml += '</div>';
  	  			innerHtml += '</li>';//리스트 마지막 종료 태그
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}
  		//문서 화면 처리.
  		else if(boardType == "8"){
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				//1. title_line 처리
  				innerHtml += '<li class=\"list\">';
  	  			innerHtml += 	'<div class=\"title_line\">';
  	  			innerHtml += 		'<span class=\"box_txt\">';
  				innerHtml += result.dirNm;
  	  			innerHtml += 		'</span>';
  	  			//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
  	  			innerHtml += 		'<h3 class="title_line_txt">';
  	  	
  	  			//제목
  	  			if(jobType =='edms-2'){
  	  				innerHtml += 		'<a href="javascript:edmsMove2(\'' + result.bDirCd + '\',\'' + result.artSeqNo + '\');">';
  	  			}else{
  	  				innerHtml += 		'<a href="javascript:edmsMove(\'' + result.wDirCd + '\',\'' + result.artSeqNo + '\');">';	
  	  			}
  				innerHtml += result.artTitle; 
  	  			innerHtml += '		</a>';
  	  			innerHtml += '		</h3>';
  	  			innerHtml += '		<ul class="misc">';
  	  			innerHtml += '		<li><span id="">';
  	  			//날짜
  	  			innerHtml += '<%=BizboxAMessage.getMessage("TX000000612","작성일")%> : ';
  				if(result.writeDate && result.writeDate.length > 10){
  					innerHtml += result.writeDate.replace("T", " ").substring(0, 10);
  				}
  	  			
  	  			innerHtml += '		</span></li>';
  	  			innerHtml += '	</ul>';
  	  			innerHtml += '	</div>';
  	  			//3. contents_line 처리 (내용)
  	  			if(result.artContent && result.artContent != ''){
  	  				
  	  				innerHtml += '<div class="contens_line">';
  	  				innerHtml += 	'<ul class="contents_list_type docu_ul">';
					innerHtml += 		'<li>';
					innerHtml += 			'<dl>';
					innerHtml += 				'<dt><%=BizboxAMessage.getMessage("TX000000663","문서번호")%> : </dt>';
					innerHtml += 				'<dd>' + result.artSeqNm + '</dd>';
					innerHtml += 			'</dl>';
					innerHtml += 		'</li>';
					innerHtml += 	'</ul>';
					innerHtml += '<p class="contents_text_type">';
					
					innerHtml += result.artContent;
  	  				
  	  				innerHtml += '<a href="javascript:edmsMove(\'' + result.wDirCd + '\',\'' + result.artSeqNo + '\');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
  	  				innerHtml += '</p>';
  	  				innerHtml += '</div>';
  	  			}
  	  			innerHtml += '</li>';//리스트 마지막 종료 태그
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}
  		//게시판 화면 처리.
  		else if(boardType == "9"){
  			innerHtml += '<ul id=\"\" class=\"list_style_1\">';
  			for(var i=0;i<data.resultgrid.length;i++){
  				
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				//1. title_line 처리
  				innerHtml += '<li class=\"list\">';
  	  			innerHtml += 	'<div class=\"title_line\">';
  	  			innerHtml += 		'<span class=\"box_txt\">';
  	  			if(result.jobType == 'board-1' || result.jobType == 'board-3'){
  	  				innerHtml += result.catTitle;
  	  			}else if(result.jobType == 'board-2'){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000002747","설문조사")%>';
  	  			}
  	  			innerHtml += 		'</span>';
  	  			//2. title_line_txt 처리 (title_line 옆에 제목 href 링크처리)
  	  			innerHtml += 		'<h3 class="title_line_txt">';
  	  	
  	  			//제목
  	  			if(result.jobType == 'board-1' || result.jobType == 'board-3'){
	  				innerHtml += 		'<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');">';
	  				innerHtml += result.artTitle; 
  	  			}
  	  			if(result.jobType == 'board-2'){
	  				innerHtml += 		'<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + '' +'\');">';
	  				innerHtml += result.artTitle; 
	  			}
  	  			innerHtml += '		</a>';
  	  			innerHtml += '		</h3>';
  	  			innerHtml += '		<ul class="misc">';
  	  			innerHtml += '		<li><span id="">';
  	  			//날짜
  	  			if(result.jobType == 'board-1' || result.jobType == 'board-3'){
	  				if(result.writeDate && result.writeDate.length > 10){
	  					innerHtml += result.writeDate.replace("T", " ").substring(0, 10);
	  				}
  	  			}
  	  			if(result.jobType == 'board-2'){
	  				if(result.startDate && result.startDate.length > 10){
	  					innerHtml += result.startDate.replace("T", " ").substring(0, 10);
	  				}
	  				innerHtml += '~';
	  				if(result.endDate && result.endDate.length > 10){
	  					innerHtml += result.endDate.replace("T", " ").substring(0, 10);
	  				}
	  			}
  	  			
  	  			innerHtml += '		</span></li>';
  	  			innerHtml += '	</ul>';
  	  			innerHtml += '	</div>';
  	  			//3. contents_line 처리 (내용)
  	  			if((result.jobType == 'board-1' && result.artContent && result.artContent != '') 
  	  					|| (result.jobType == 'board-3' && result.artContent && result.artContent != '')){
  	  				
  	  				innerHtml += '<div class="contens_line">';
  	  				innerHtml += 	'<p class="contents_text_type">';
  	  				if(result.artContent && result.artContent.length > 230){
  	  					var keyIndexOf = result.artContent.indexOf($("#tsearchKeyword").val());
  	  					
  	  					if(keyIndexOf > 230){
  	  						innerHtml += result.artContent.substring(keyIndexOf-(230-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
  	  					}else{
  	  						innerHtml += result.artContent.substring(0, 230);
  	  					}
  	  					
  	  				}else if(result.artContent && result.artContent.length <= 230){
	  					innerHtml += result.artContent;
	  				}else if(!result.artContent || (result.artContent && result.artContent.length == 0)){
	  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
	  				}
  	  				innerHtml += '<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');"><span class="text_more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
  	  				innerHtml += '</p>';
  	  				innerHtml += '</div>';
  	  			}
  	  			innerHtml += '</li>';//리스트 마지막 종료 태그
  				
  			}//for loop 종료
  			innerHtml += '</ul>';
  		}
  		return innerHtml;
  	}
  	
  	//kendoTreeView 적용처리.
  	function kendoTabStripProc(){
		$("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: ""
				}
			}
		});
		$("#tabstrip2").kendoTabStrip({
			animation:  {
				open: {
					effects: ""
				}
			}
		});
  	}
  	
  	//하이라이트 적용 처리.
  	function searchKeywordHighlight(){
  		
  		var keywordList = [];
		var replaceKeyword = $("#tsearchKeyword").val();
		if(replaceKeyword.indexOf(" ") > -1){
			keywordList = replaceKeyword.split(" ");
			for(var i = 0; i < keywordList.length ; i++){
				//$('.sub_wrap').highlight(keywordList[i]);
				$('.title_line_txt').highlight(keywordList[i]);
				$('.contents_text_type').highlight(keywordList[i]);
				$('.highlight_h').highlight(keywordList[i]);
				$('.tts_tit').highlight(keywordList[i]);
				$('.pt_div').highlight(keywordList[i]);
				$('.tts_file').highlight(keywordList[i]);
	  		}
		}else{
			//$('.sub_wrap').highlight(replaceKeyword);
			$('.title_line_txt').highlight(replaceKeyword);
			$('.contents_text_type').highlight(replaceKeyword);
			$('.highlight_h').highlight(replaceKeyword);
			$('.tts_tit').highlight(replaceKeyword);
			$('.pt_div').highlight(replaceKeyword);
			$('.tts_file').highlight(replaceKeyword);
		}
  	}
  	
  	//기간선택 시 날짜 계산
  	function getToDay(token,dayDiv) {
		 var now = new Date();
	     var year = now.getFullYear();
	     var month = now.getMonth()+1;
	   	 var day = now.getDate();
	   	 
	   	 if(dayDiv == "week"){
	   		 day = now.getDate() - 7;
	   	 }else if(dayDiv == "month"){
	   		 month = now.getMonth();
	   	 }else if(dayDiv == "year"){
	   		 year = now.getFullYear() - 1;
	   	 }
	   	 
	   	 if(month < 10){ month = "0"+month; }
	   	 if(day < 10){ day = "0"+day; }
	     return year+token+month+token+day;
	}
  	
  	function fnMoneyType(v) {
	 var reg = /(^[+-]?\d+)(\d{3})/;
	  v += '';

	  while (reg.test(v))
	    v = v.replace(reg, '$1' + ',' + '$2');

	  document.write(v);
	}
  	
  	function fnMoneyTypeReturn(v) {
  		 var reg = /(^[+-]?\d+)(\d{3})/;
  		  v += '';

  		  while (reg.test(v))
  		    v = v.replace(reg, '$1' + ',' + '$2');

  		  return v;
  		}
  	
  	function fnGetWeek(getDateVal){
  		var now = new Date(getDateVal).getDay();
  		var weekName = new Array('<%=BizboxAMessage.getMessage("TX000005656","일")%>','<%=BizboxAMessage.getMessage("TX000005657","월")%>','<%=BizboxAMessage.getMessage("TX000005658","화")%>','<%=BizboxAMessage.getMessage("TX000005659","수")%>','<%=BizboxAMessage.getMessage("TX000005660","목")%>','<%=BizboxAMessage.getMessage("TX000005661","금")%>','<%=BizboxAMessage.getMessage("TX000005662","토")%>');
  		
  		return getDateVal+"("+weekName[now]+")";
  	}
  	
  	function fnDateType(v,token) {
  		if(token == "h"){ // 년월일 표시
  			v = v.substring(0,4)+"<%=BizboxAMessage.getMessage("TX000000435","년")%> "+v.substring(4,6)+"<%=BizboxAMessage.getMessage("TX000000436","월")%> "+v.substring(6,8)+"<%=BizboxAMessage.getMessage("TX000000437","일")%>";
  		}else if(token == "s"){ // 일정 날짜 표시
  			var day = fnGetWeek(v.substring(0,4)+"-"+v.substring(5,7)+"-"+v.substring(8,10));
  			v = day+" "+v.substring(11,16);
  		}else{
  			v = v.substring(0,4)+token+v.substring(4,6)+token+v.substring(6,8);
  		}

  		document.write(v);
  	}
  	
  	function fnDateTypeReturn(v,token) {
  		if(token == "h"){ // 년월일 표시
  			v = v.substring(0,4)+"<%=BizboxAMessage.getMessage("TX000000435","년")%> "+v.substring(4,6)+"<%=BizboxAMessage.getMessage("TX000000436","월")%> "+v.substring(6,8)+"<%=BizboxAMessage.getMessage("TX000000437","일")%>";
  		}else if(token == "s"){ // 일정 날짜 표시
  			var day = fnGetWeek(v.substring(0,4)+"-"+v.substring(5,7)+"-"+v.substring(8,10));
  			v = day+" "+v.substring(11,16);
  		}else{
  			v = v.substring(0,4)+token+v.substring(4,6)+token+v.substring(6,8);
  		}

  		return v;
  	}
  	
  	function fnHangleType(v){
		var str = "";
  		for(var i = 0; i < v.length; i++){
  			if (/.*?[가-힣]+.*?/.test(v.charAt(i)) == true) {
  				str += v.charAt(i);
  			}
  		}
  		
  		if(str == ""){
  			document.write("<%=BizboxAMessage.getMessage("TX000018190","대외공문")%>");
  		}else{
  			document.write(str);
  		}
  	}
  	
  	function fnHangleTypeReturn(v){
		var str = "";
  		for(var i = 0; i < v.length; i++){
  			if (/.*?[가-힣]+.*?/.test(v.charAt(i)) == true) {
  				str += v.charAt(i);
  			}
  		}
  		
  		if(str == ""){
  			return "<%=BizboxAMessage.getMessage("TX000018190","대외공문")%>";
  		}else{
  			return str;
  		}
  		
  	}
  	
  	function fnHangleType2(v){
		var str = "";
  		for(var i = 0; i < v.length; i++){
  			if (/.*?[가-힣]+.*?/.test(v.charAt(i)) == true) {
  				str += v.charAt(i);
  			}
  		}
  		
  		if(str == ""){
  			document.write("<%=BizboxAMessage.getMessage("TX000000612","작성일")%> : ");
  		}else{
  			document.write("<%=BizboxAMessage.getMessage("TX000000494","기안일")%> : ");
  		}
  	}
  	
  	function fnHangleType2Return(v){
		var str = "";
  		for(var i = 0; i < v.length; i++){
  			if (/.*?[가-힣]+.*?/.test(v.charAt(i)) == true) {
  				str += v.charAt(i);
  			}
  		}
  		
  		if(str == ""){
  			return "<%=BizboxAMessage.getMessage("TX000000612","작성일")%> : ";
  		}else{
  			return "<%=BizboxAMessage.getMessage("TX000000494","기안일")%> : ";
  		}
  	}
  	
  	function fnTimeStampFormat(v){
  		var date = new Date(eval(v));
  		var year = date.getFullYear();
  		var month = date.getMonth()+1;
  		var day = date.getDay();

  		var retVal =   year + "-" + (month < 10 ? "0" + month : month) + "-" 
  		                        + (day < 10 ? "0" + day : day);
  		                        
		document.write(retVal);
  	}
  	
  	function pageMove(str){
  		formTotal.pageIndex.value = str;
  		getTotalSearch('3', false);
  	}

  	function boardFileDownPop(boardNo,fileNm,fileRnm, linkDoc, jobType, fileSeqNo, fileExtsn) {
    	var fileNmSub = fileNm;
    	var fileNmTmp = fileNm.substring(fileNm.lastIndexOf("/")+1);
    	var boardNoTmp = fileNmSub.substring(0,fileNmSub.lastIndexOf("/"));
    	boardNoTmp = boardNoTmp.substring(boardNoTmp.lastIndexOf("/")+1);
    	//IE브라우저 인코딩 오류로 인한 로직
    	fileRnm = encodeURIComponent(fileRnm);
    	var downUrl = "/edms/board/downloadFile.do?boardNo="+boardNoTmp+"&fileNm="+fileNmTmp+"&fileRnm="+fileRnm+"."+fileExtsn;
    	var url = "<a style='cursor:pointer' onclick='fnFileDownLoad(\"" + downUrl + "\",\"" + fileSeqNo + "\",\"" + jobType + "\",\"" + linkDoc + "\",\"" + fileExtsn + "\")\'>"+linkDoc+"</a>";
  		return url;
  	}
     
    function boardFileImgTag(boardNo,fileNm,fileRnm) {
     	var fileNmSub = fileNm;
     	var fileNmTmp = fileNm.substring(fileNm.lastIndexOf("/")+1);
     	var fileExtsn = fileNmTmp.substring(fileNmTmp.lastIndexOf(".")+1);
     	fileRnm = fileRnm + "." + fileExtsn;
     	
     	var boardNoTmp = fileNmSub.substring(0,fileNmSub.lastIndexOf("/"));
     	boardNoTmp = boardNoTmp.substring(boardNoTmp.lastIndexOf("/")+1);
     	var errorImgTag = "/gw/Images/ico/media_noimg.png";
 		var imgTag = "<img id='totalTabImg' width='109' height='66' src='/edms/board/downloadFile.do?boardNo="+boardNoTmp+"&fileNm="+fileNmTmp+"&fileRnm="+fileRnm+"' onerror='this.src="+errorImgTag+"' />";
   		return imgTag;
   	}
    
    function showLoading(){
        $("#loading").show();
    }

    function hideLoading(){
        $("#loading").hide();
    }
    
    //메일함 분류
    function fnMainInBoxNameReturn(v) {
		
    	if(v == "INBOX"){
    		v = "[<%=BizboxAMessage.getMessage("TX000001580","받은편지함")%>]";
    	}else if(v == "SENT"){
    		v = "[<%=BizboxAMessage.getMessage("TX000001581","보낸편지함")%>]";
    	}
    	
   		return v;
   	}
    
    //받는 사람 외 표시
	function fnMailToOtherReturn(v) {
    	var returnStr = "";
    	var strTail = [];
    	if(v.indexOf(",") > -1){
    		strTail = v.split(",");
    		returnStr = strTail[0]+" 외 "+(strTail.length-1)+"명";
    	}else{
    		returnStr = v;
    	}
   		return returnStr;
   	}
    
	function replaceAll(str, searchStr, replaceStr) {
		
		if(str){
			return str.split(searchStr).join(replaceStr);	
		}
	  return str;
	}
	
	//검색결과 없을때 
	function nonResult(){
		var subContents = $(".sub_contents").height() - 51;	
		var topBox = $(".top_box").height() + 22;	
		var searchDetail = $(".SearchDetail").height() + 31;
		var searchResultBar = $(".search_result_bar").height() + 11;
		var nonResult = subContents - (topBox + searchDetail + searchResultBar);

		$(".non_result").height(nonResult);	
		$(".non_result").css("line-height",nonResult+"px");
	}
	
	
	//첨부파일 다운로드
	function fnFileDownLoad(url, fileId, moduleTp, fileNm, fileExtsn, MODULE_TP){
		
		selectedModuleTp = "";
		
		var optionValue = "";
		
		if(moduleTp == "project-1" || moduleTp == "project-2" || moduleTp == "project-3"){
			optionValue = attProjectValue;
		}else if(moduleTp == "schedule-1" || moduleTp == "schedule-2" || moduleTp == "note" || moduleTp == "report-1" || moduleTp == "report-2"){
			optionValue = attScheduleValue;
		}else if(moduleTp == "board-1" || moduleTp == "board-2" || moduleTp == "board-3"){
			optionValue = attBoardValue;
		}else if(moduleTp == "edms-1" || moduleTp == "edms-2" || moduleTp == "edms-3"){
			optionValue = attDocValue;
		}else if(moduleTp == "eadoc-1" || moduleTp == "eadoc-2" || moduleTp == "eapproval-1" || moduleTp == "eapproval-2"){
			optionValue = attEaValue;
		}
		
		
		if(optionValue == "-1"){
    		return;
    	}
		
		
		if(optionValue == "0"){
    		var extsn = fileExtsn;
			var checkExtsn = ".hwp.hwpx.doc.docx.ppt.pptx.xls.xlsx.pdf";
			if(checkExtsn.indexOf(extsn) == -1){
				 this.location.href = url;
			     return false;
			}    		
			else{
	    		selectedFileUrl = url;
	    	    selectedfileNm = fileNm;
	    	    selectedfileId = fileId;    	
	    	    selectedFileExtsn = fileExtsn;
	    	    if(MODULE_TP){
	    	    	selectedModuleTp = MODULE_TP;
	    	    }
	    		
	    		$(".downfile_sel_pop").show();
	    		x = event.pageX;	
				y = event.pageY;
				$(".downfile_sel_pop").css({top:y+"px",left:x+"px"})
	    		return
			}
    	}
		
		if(optionValue == "1"){
		    this.location.href = url;
	        return false;
		}
		//문서뷰어
		else if(optionValue == "2"){
			var extsn = fileExtsn;
			var checkExtsn = ".hwp.hwpx.doc.docx.ppt.pptx.xls.xlsx";
			if(checkExtsn.indexOf(extsn) != -1){
				fnDocViewerPop(url, fileNm, fileId);
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000575","해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자 : 이미지, pdf, hwp, hwpx, doc, docx, ppt, pptx, xls, xlsx]")%>");
				return;
			}
		}
	}
	
	function getExtensionOfFilename(filename) { 
    	var _fileLen = filename.length; 
    	var _lastDot = filename.lastIndexOf('.'); 
    	// 확장자 명만 추출한 후 소문자로 변경
    	var _fileExt = filename.substring(_lastDot, _fileLen).toLowerCase(); 
    	return _fileExt; 
   	} 
	
	function fnMouseOut(){
    	$(".downfile_sel_pop").hide();
    }
	
	function fnFileDirectDown(){
    	this.location.href = selectedFileUrl;
        return false;
    }
    
    function fnFileViewerPop(){
    	var extsn = selectedFileExtsn;
		var checkExtsn = ".hwp.hwpx.doc.docx.ppt.pptx.xls.xlsx";
		<c:choose>
		<c:when test="${inlineViewYn == 'N'}">
		var checkExtsnInline = "";
		</c:when>
		<c:otherwise>
		var checkExtsnInline = ".jpeg.bmp.gif.jpg.png.pdf";
		</c:otherwise>
		</c:choose>			
		if(checkExtsnInline.indexOf(extsn) != -1){
			fnInlineView(selectedFileUrl, selectedfileNm, selectedfileId);
		}else if(checkExtsn.indexOf(extsn) != -1){
			fnDocViewerPop(selectedFileUrl, selectedfileNm, selectedfileId);
		}else{
			alert("<%=BizboxAMessage.getMessage("TX900000575","해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자 : 이미지, pdf, hwp, hwpx, doc, docx, ppt, pptx, xls, xlsx]")%>");
		}
    }
    
    function fnDocViewerPop(fileUrl, fileNm, fileId){
    	var fileSn = "";
    	var moduleTp = "";
    	
    	if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
        	fileId = getQueryVariable(fileUrl, 'fileId');
        	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
        	moduleTp = "gw";
    		if(fileSn == "" || fileSn == null)
    			fileSn = "0";
    	}
    	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
    		fileId = getQueryVariable(fileUrl, 'fileId');
        	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
        	moduleTp = "gw";
    		if(fileSn == "" || fileSn == null)
    			fileSn = "0";
    	}
    	
    	//게시판 url예외처리
    	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
    		moduleTp = "board";
    	}
    	
    	//문서 url예외처리
    	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
    		if(fileUrl.indexOf("oldArtNo") != -1){
    			moduleTp = "doc_old";
    			fileSn = getQueryVariable(fileUrl, 'oldArtNo');
    		}else{
    			moduleTp = "doc";	
    		}		
    	}
    	
    	//문서 url예외처리
    	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
    		moduleTp = "bpm";
    	}
    	
    	var timestamp = new Date().getTime();
     	var docViewrPopForm = document.docViewrPopForm;
     	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
     	docViewrPopForm.action = "/gw/docViewerPop.do";
     	docViewrPopForm.target = "docViewerPop" + timestamp ;
     	docViewrPopForm.groupSeq.value = "";
     	docViewrPopForm.fileId.value = fileId;
     	docViewrPopForm.fileSn.value = fileSn;
     	docViewrPopForm.moduleTp.value = selectedModuleTp ? selectedModuleTp : moduleTp;
     	docViewrPopForm.submit();
    }

    function fnInlineView(fileUrl, fileNm, fileId){
    	
      	var fileSn = "";
    	var moduleTp = "";
    	
    	if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
        	fileId = getQueryVariable(fileUrl, 'fileId');
        	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
        	moduleTp = "gw";
    		if(fileSn == "" || fileSn == null)
    			fileSn = "0";
      	}
      	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
      		fileId = getQueryVariable(fileUrl, 'fileId');
    	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
    	    	moduleTp = "gw";
    			if(fileSn == "" || fileSn == null)
    				fileSn = "0";
      	}

      	//게시판 url예외처리
      	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
      		moduleTp = "board";
      	}
      	
      	//문서 url예외처리
      	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
      		
    		if(fileUrl.indexOf("oldArtNo") != -1){
    			moduleTp = "doc_old";
    			fileSn = getQueryVariable(fileUrl, 'oldArtNo');
    		}else{
    			moduleTp = "doc";	
    		}	
    		
      	}
      	
      	//문서 url예외처리
      	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
      		moduleTp = "bpm";
      	}
    	
    	//그외는 gw다운로드로 통일
    	else{
    		fileId = getQueryVariable(fileUrl, 'fileId');
        	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
        	moduleTp = "gw";
    		if(fileSn == "" || fileSn == null)
    			fileSn = "0";
    	}
    	
    	var timestamp = new Date().getTime();
     	var docViewrPopForm = document.docViewrPopForm;
     	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=yes,menubar=no");
     	docViewrPopForm.action = "/gw/cmm/file/fileDownloadProc.do";
     	docViewrPopForm.target = "docViewerPop" + timestamp ;
     	docViewrPopForm.pathSeq.value = pathSeq;
     	docViewrPopForm.fileId.value = fileId;
     	docViewrPopForm.fileSn.value = fileSn;
     	docViewrPopForm.moduleTp.value = selectedModuleTp ? selectedModuleTp : moduleTp;
     	docViewrPopForm.submit();		
    }
    
    function getQueryVariable(fileUrl, strPara) {
        var params = {};
        fileUrl.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str, key, value) { params[key] = value; });
        return params[strPara];
     }
    
  	//기간선택, 직접입력 선택 시 disabled
	function setRadioStatus(selectDiv){
		if(selectDiv == "S"){
			$("#combo_sel_1").data("kendoComboBox").enable(true);
	    	$("#from_date").attr("disabled", true);
	    	$("#from_date").data("kendoDatePicker").enable(false);
	    	$("#to_date").attr("disabled", true);
	    	$("#to_date").data("kendoDatePicker").enable(false);
	    	$("#search_radi_1").attr("checked", true);
		}else if(selectDiv == "M"){
			$("#combo_sel_1").data("kendoComboBox").enable(false);
	    	$("#from_date").attr("disabled", false);
	    	$("#from_date").data("kendoDatePicker").enable(true);
	    	$("#to_date").attr("disabled", false);
	    	$("#to_date").data("kendoDatePicker").enable(true);
	    	$("#search_radi_2").attr("checked", true);
		}
	}

	//페이지 검색 시 정확도, 최신순 버튼 선택
	function setOrderBtnStatus(selectDiv){
		 if(selectDiv == "A"){
			 $("#B").removeClass("on");
			 $("#A").addClass("on");
		 }else{
			 $("#A").removeClass("on");
			 $("#B").addClass("on");
		 }
	 }
 </script>
    
<!-- contents -->
<div class="contents_wrap" style="top:0px; margin-top:0px;">
	<c:if test="${params.hrSearchYn == 'N'}">
	<div class="side_wrap" style="top:0px">
		<div class="nav_div">
			<ul id="sub_nav" style="border-width:0"></ul>
		</div>
	</div>
	<div class="sub_wrap">
	</c:if>
	<c:if test="${params.hrSearchYn == 'Y'}">
	<div class="side_wrap" style="top:0px;display:none">
		<div class="nav_div">
			<ul id="sub_nav" style="border-width:0"></ul>
		</div>
	</div>
	<div class="sub_wrap" style="left:0px;overflow:auto;">
	</c:if>
		<div class="sub_contents" style="overflow:auto;">
			<!-- iframe wrap -->
			<div class="iframe_wrap">
			
				<!--  
						//
						//
						//
						인물 검색시(hrSearchYn=="Y") 해당 인물 표시 영역
						//
						//
						//
				-->
			
				<!-- 검색박스 -->
				<div class="top_box mt20">
					<dl>
						<dt class="ar en_w77" style="width:68px;"><%=BizboxAMessage.getMessage("TX000007032","통합검색")%></dt>
						<dd><input type="text" value="" style="ime-mode:inactive;width:185px" id="tsearchKeyword" name="tsearchKeyword" onkeydown="if(event.keyCode==13){javascript:getTotalSearch('2', true);}" autocomplete="off" ></dd>
						<dd><a href="javascript:;" class="searchButton"  title="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"><input id="searchButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"></a></dd>
						<c:if test="${params.hrSearchYn == 'Y'}">
						<dd><a href="javascript:;" class="searchButton"  title="<%=BizboxAMessage.getMessage("TX000007032","통합검색")%>"><input id="searchButtonHrTotalSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000007032","통합검색")%>"></a></dd>
						</c:if>
					</dl>
					<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='/gw/Images/ico/ico_btn_arr_down01.png'/></span>
				</div>
				<!-- 상세검색박스 -->
				<div class="SearchDetail" style="display:none;">
					<dl>
						<dt>
							<input type="radio" name="search_radi" id="search_radi_1" class="k-radio" />
							<label class="k-radio-label" for="search_radi_1" style="padding:0.2em 0 0 1.8em;"><%=BizboxAMessage.getMessage("TX000018191","기간선택")%></label>
						</dt>
						<dd><input type="text" id="combo_sel_1" class="kendoComboBox" style="width:60px;" /></dd>
						<dt class="ml30">
							<input type="radio" name="search_radi" id="search_radi_2" class="k-radio" />
							<label class="k-radio-label" for="search_radi_2" style="padding:0.2em 0 0 1.8em;"><%=BizboxAMessage.getMessage("TX000001021","직접입력")%></label>
						</dt>
						<dd>
							<input id="from_date" value="2015-01-01" class="dpWid"/>
							~
							<input id="to_date" value="2015-05-27" class="dpWid"/>
						</dd>
					</dl>
				</div>

				<!-- 컨텐츠내용영역 -->
				<div class="sub_contents_wrap">
					
					<!-- 통합검색 검색영역 시작 ---------------------------------------------------------------------------------------------->
					<div class="search_result_bar">

						<div class="fl mt7">
							"<span class="match" id="tsearchKeywordResult"></span>"<%=BizboxAMessage.getMessage("TX900000357","에 대한 검색결과 중")%> <span id="tsearchKeywordCountResult" class="fwb text_blue"></span><%=BizboxAMessage.getMessage("TX900000356","건의 결과를 검색하였습니다.")%>
						</div>
						<div class="fr" id="result_type_id">
							<ul class="result_type_btn">
								<li id="A"><a href="#n" id="" onClick="" ><%=BizboxAMessage.getMessage("TX000018194","정확도순")%></a></li>
								<li id="B"><a href="#n" id="" onClick="" ><%=BizboxAMessage.getMessage("TX000018195","최신순")%></a></li>
							</ul>
						</div>
					</div>
					
					<!--  
						//
						//
						//
						기존(totalSearchContent.jsp) 각 모듈별 결과 페이지 영역 (ajax 동적 DOM 처리로 변경)
						//
						//
						//
					-->
					
					<div id="noResult" style="display:none" class="non_result fwb ac"><span><%=BizboxAMessage.getMessage("TX000007470","검색 결과가 없습니다.")%></span></div>
					<!-- //통합검색 검색영역 종료 -------------------------------------------------------------------------------------------->					
				</div><!-- //sub_contents_wrap -->
			</div><!-- iframe wrap -->
		</div><!-- //sub_contents -->
	</div><!-- //sub_wrap -->

	<div id="" class="downfile_sel_pop posi_fix" style="top:133px;left:690px; display: none;" onmouseleave="fnMouseOut();">
	   	<ul>
	   		<li><a href="#n" onclick="fnFileDirectDown();"><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a></li>
	   		<li><a href="#n" onclick="fnFileViewerPop();"><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a></li>
	   	</ul>
	</div>
</div>
<div id="loading" style="position: absolute;left:50%;top:30%; margin: 0; padding: 0;"><img src="/gw/Images/ico/loading.gif"></div>
<form id="formTotal" name="formTotal" action="getTotalSearchContentNew.do" method="post">  
	<input type="hidden" id="tsearchKeyword" name="tsearchKeyword" value="${params.tsearchKeyword}" /> <!-- 메인 키워드 -->
	<input type="hidden" id="tsearchSubKeyword" name="tsearchSubKeyword" value="" /> <!-- 상세검색 키워드 -->
	<input type="hidden" id="boardType" name="boardType" value="" /> <!-- 레프트메뉴 구분 -->
	<input type="hidden" id="listType" name="listType" value="" /> <!-- 목록 구분 -->
	<input type="hidden" id="listTypes" name="listTypes" value="" /> <!-- 조회된 개별 모듈 이외에 카운트 조회시 조회할 모듈들 (ex>7,8) -->
	<input type="hidden" id="fromDate" name="fromDate" value="" /> <!-- 검색 시작 일자 -->
	<input type="hidden" id="toDate" name="toDate" value="" /> <!-- 검색 종료 일자 -->
	<input type="hidden" id="dateDiv" name="dateDiv" value="" /> <!-- 기간선택, 임의선택 여부 -->
	<input type="hidden" id="detailSearchYn" name="detailSearchYn" value="N" /> <!-- 상세검색 ON/OFF 여부 (Y/N) -->
	<input type="hidden" id="selectDiv" name="selectDiv" value="S"/> <!-- 기간선택값 -->
	<input type="hidden" id="orderDiv" name="orderDiv" value="B"/> <!-- 정렬구분 -->
	<input type="hidden" id="pageIndex" name="pageIndex" value="1"/> <!-- 페이징처리 -->
	<input type="hidden" id="hrSearchYn" name="hrSearchYn" value="${params.hrSearchYn}"/> <!-- 인물 검색 여부 -->
	<input type="hidden" id="hrEmpSeq" name="hrEmpSeq" value="${params.hrEmpSeq}"/> <!-- 인물 검색 선택된 empSeq -->
</form>

<form id="docViewrPopForm" name="docViewrPopForm" method="post">
    <input type="hidden" name="groupSeq" />
    <input type="hidden" name="fileId" />
    <input type="hidden" name="fileSn" />
    <input type="hidden" name="moduleTp" />
    <input type="hidden" name="pathSeq" />
    <input type="hidden" name="inlineView" value="Y" />
</form>

