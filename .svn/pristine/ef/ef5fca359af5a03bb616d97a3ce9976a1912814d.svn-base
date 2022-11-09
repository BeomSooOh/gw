<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="description" content="" />
    <meta name="keywords" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <link rel="stylesheet" href="/gw/ebp/css/pudd.css" />
    <link rel="stylesheet" href="/gw/ebp/css/comm/common.css" />
    <link rel="stylesheet" href="/gw/ebp/css/common.css" />
    <link rel="stylesheet" href="/gw/ebp/css/animate.css" />
    <link rel="stylesheet" href="/gw/ebp/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.css" />
    <link rel="stylesheet" href="/gw/ebp/css/portalview.css" />
    <%-- <link rel="stylesheet" type="text/css" href="<c:url value='/css/contents.css' />"> --%>
    <style>
		.highlight {color:#058df5 !important;font-weight:bold;}
		.downfile_sel_pop{background:#fff;border:1px solid #c3c3c3;padding:5px 10px;}
		.downfile_sel_pop ul li{min-width:70px;padding: 3px 0;}
		.downfile_sel_pop ul li a{white-space: nowrap;}
	</style>
	<script type="text/javascript">
		var langCode = "<%=langCode%>";
	</script>
    <script type="text/javascript" src="/gw/ebp/Scripts/comm/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="/gw/ebp/Scripts/pudd/pudd-1.1.184.min.js"></script>
    <script type="text/javascript" src="/gw/ebp/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>
    <script type="text/javascript" src="/gw/ebp/Scripts/portalview.js"></script>
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.highlight.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.dotdotdot.js' />"></script>
    <script type="text/javascript">
    //모듈별 메뉴정보 맵
	/* var menuInfoMap = {
		"EA" : "20050000"		
	}; */
	var menuInfoMap = {
				
	};
	//검색창
	var exData = [];//검색창 메뉴리스트
	var lastMenuRequestTime = 0;//검색창 마지막 요청 시간
	var lastMenuSearchKeyword = "";//검색창 마지막 검색 단어 (연관 메뉴 처리)

	//검색결과
	var leftMenuList = [];//좌측 메뉴리스트
	var relatedSearchList = [];//우측 상단 연관검색어 리스트
	var relatedMenuList = [];//우측 하단 연관메뉴 리스트

	//연관검색어(사용자가 검색한 검색어 누적리스트 최대 2개)
	var relatedSearchWordList = [];//연관검색어 처리 하기위한 변수
	
	//통합검색 검색 가능 여부
	var loadingMap = {};
	
	//연관 링크 limit count
	var relatedLinkCount = 2;
	
	//document ready
	$(document).ready(function() {
		//최근검색어 조회
		getRecentSearchKeyword();
		//모듈리스트 조회
		getModuleList();
		//알림 요약/상세 조회
		getNoticeInfo();
	});
	//알림 요약/상세 조회
	function getNoticeInfo(){
		//전자결재
		getEaNotice();
		//일정
		getScNotice();
		//메일
		getMlNotice();
		//업무관리 (kiss 개발 이후 예정)
		getPrNotice();
	}
	//전자결재 알림 요약/상세 조회
	function getEaNotice(){
		//안읽음 카운트 조회
		$.ajax({ 
			type:"POST",
			url: '/event/GetEventCount',
			contentType:"application/json",
			datatype:"json",
			async: true,
			data:JSON.stringify({
				"groupSeq":"${groupSeq}",
				"compSeq":"${compSeq}",
				"typeMobile":"mobile",
				"senderSeq":"${empSeq}",
				"deptSeq":"${deptSeq}"
			}),
			success:function(data){
				if(data && data.ea){
					//전자결재 알림 요약 카운트 갱신
					refreshNoticeCount("eaCnt", data.ea["${compSeq}"]["eapproval"]);
					//안읽은 전자결재 미결함 리스트 조회
					getEaList();				
				}
		
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
	}
	//안읽은 전자결재 미결함 리스트 조회
	function getEaList(){
		var menuId = "2002020000";
		$.ajax({ 
			type:"POST",
			url: '/eap/ea/edoc/main/EaPortletCloudList.do',
			datatype:"json",
			async: true,
			data:{
				"val0" : menuId,
				"val1": 3,
				"iframe":"N"/* ,
				"sReadYN" :"N"//미열람만 조회 */
			},
			success:function(data){
				var list = data.EaPortletDocList !== "" ? JSON.parse(data.EaPortletDocList) : null;
				
				//전자결재 상세 다시 그리기
				$('#eaDetail').html('');
				var innerHtml = '<dl>';
				innerHtml += 		'<dt><a href="javascript:moveMenu(\'EA\',\'' + menuId + '\')">전자결재 미결재가 ' + $('#eaCnt').html() + '건 있습니다.</a></dt>';
				
				for(var i=0;i<list.length;i++){
					if(i==3) break;//최대 3개
					//if(list[i].READYN == "N"){
						//TODO 팝업이 아닌, 전자결재 > 미결함 > 해당 건으로 이동 가능한지 확인 필요.
						innerHtml += 	'<dd><a href="javascript:fnEventDocTitle(' + "'" + list[i].DOC_ID + "', '" + list[i].FORM_ID + "', '" + list[i].DOC_WIDTH + "'"+ ');">' + list[i].DOC_TITLE_ORIGIN + '</a></dd>';	
					//}
				}
				
				innerHtml += 	'</dl>';
				
				$('#eaDetail').append(innerHtml);
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});		
	}
	// 전자결재 팝업보기(영리)
	function fnEventDocTitle( doc_id, form_id, doc_width ) {

       //var doc_width = 900;
        var intWidth = doc_width;
        var intHeight = screen.height - 100;
        var agt = navigator.userAgent.toLowerCase();
        if (agt.indexOf("safari") != -1) {
            intHeight = intHeight - 70;
        }
        var intLeft = screen.width / 2 - intWidth / 2;
        var intTop = screen.height / 2 - intHeight / 2 - 40;
        if (agt.indexOf("safari") != -1) {
            intTop = intTop - 30;
        }
        var url = "/eap/ea/docpop/EAAppDocViewPop.do?doc_id=" + doc_id + "&form_id=" + form_id;
        window.open(url, 'AppDoc', 'menubar=0,resizable=0,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
        
      	//전자결재 알림 요약/상세 갱신
		setTimeout(getEaNotice, 1500);
    }
	//일정 알림 요약/상세 조회
	function getScNotice(){
		//안읽음 카운트 조회 및 리스트 조회
		var now = new Date();
		var minus1Day = new Date();
		minus1Day.setDate(minus1Day.getDate()-1);
		var plus1Day = new Date();
		plus1Day.setDate(plus1Day.getDate()+1);
	  	var formattedNow = now.yyyymmdd();
	  	var formattedMinus1Day = minus1Day.yyyymmdd();
	  	var formattedPlus1Day = plus1Day.yyyymmdd();
		$.ajax({ 
			type:"GET",
			url: '<c:url value="/schedulePortlet.do"/>',
			datatype:"json",
			async: true,
			data:{
				"startDate":formattedMinus1Day,
				"endDate":formattedPlus1Day,
				"scheduleCheckDate":formattedNow,
				"toDay":formattedNow,
				"indivi":"Y",
				"share":"Y",
				"special":"N",
				"selectBox":"total",
				"readYn":"N"
			},
			success:function(data){
				
				if(data && data.scheduleContents){
					refreshNoticeCount("scCnt", data.scheduleContents.length);
					//일정 상세 다시그리기
					$('#scDetail').html('');
					var innerHtml = '<dl>';
					innerHtml += 		'<dt><a href="javascript:moveModule(\'CL\', true)">' + now.mmddDayOfWeek() + ' ' + $('#scCnt').html() + '건의 일정이 있습니다.</a></dt>';
					
					for(var i=0;i<data.scheduleContents.length;i++){
						if(i==3) break;//최대 3개
						//TODO 팝업이 아닌, 일정 > 해당 일정으로 이동 가능한지 확인 필요.
						innerHtml += 	'<dd><a href="javascript:fnSchedulePop(' + data.scheduleContents[i].schSeq + ')">' + data.scheduleContents[i].schTitle + '</a></dd>';	
					}
					
					innerHtml += 	'</dl>';
					
					$('#scDetail').append(innerHtml);
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
	}
	// 일정 팝업
    function fnSchedulePop(scheduleSeq) {
    	var url = "<c:url value='http://"+location.host+"/schedule/Views/Common/mCalendar/detail?seq="+scheduleSeq+"'/>";
  		openWindowPop(url,  "pop", 833, 711,"yes", 1);
  		//일정 알림 요약/상세 갱신
		setTimeout(getScNotice, 1500);
    }
	//메일 알림 요약/상세 조회
	function getMlNotice(){
		//안읽음 카운트 조회
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/emailCountUsage.do"/>',
			datatype:"json",
			async: true,
			data:{
			},
			success:function(data){
				
				if(data && data.mailUsageCountData && data.mailUsageCountData.mailboxList && data.mailUsageCountData.mailboxList.length > 0){
					
					var list = data.mailUsageCountData.mailboxList;
					for(var i=0;i<list.length;i++){
						if(list[i].name=="INBOX"){
							//메일 알림 요약 카운트 갱신
							refreshNoticeCount("mlCnt", list[i].unseen);
							//안읽은 메일 리스트 조회
							getMailList();
							break;
						}
					}
					
				}else{
					alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
				}
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
	}
	//안읽은 메일 리스트 조회
	function getMailList(){
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/emailList.do"/>',
			datatype:"json",
			async: true,
			data:{
				"title":"",
				"seen" : "0",
				"count": 3
			},
			success:function(data){
				if(data && data.mailList && data.mailList && data.mailList.resultCode == "0" && data.mailList.result && data.mailList.result.mailList){
					//메일 상세 다시 그리기
					$('#mlDetail').html('');
					var innerHtml = '<dl>';
					innerHtml += 		'<dt><a href="javascript:moveMenu(\'ML\',\'51\')">읽지않은 메일 ' + $('#mlCnt').html() + '건이 있습니다.</a></dt>';
					
					for(var i=0;i<data.mailList.result.mailList.length;i++){
						if(i==3) break;//최대 3개
						if(data.mailList.result.mailList[i].seen == 0){
							//TODO 팝업이 아닌, 받은편지함 > 해당 메일로 이동 가능한지 확인 필요.
							innerHtml += 	'<dd><a href="javascript:mailInfoPop(\'' + data.mailList.result.mailList[i].muid + '\',\'' + data.mailUrl + '\',\'' + data.email + '\')">' + data.mailList.result.mailList[i].subject + '</a></dd>';	
						}
					}
					
					innerHtml += 	'</dl>';
					
					$('#mlDetail').append(innerHtml);
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});		
	}
	// 메일 팝업
	function mailInfoPop(muid, mailUrl, mail){	
		var gwDomain = window.location.host + (window.location.port == "" ? "" : (":" + window.location.port));
		openWindowPop( mailUrl + "readMailPopApi.do?gwDomain=" + gwDomain + "&email=" + mail + "&muid=" + muid + "&seen=0&userSe=USER","readMailPopApi",1020,700,1,1,"");
		//메일 알림 요약/상세 갱신
		setTimeout(getMlNotice, 1500);
	}
	function openWindowPop(url,  windowName, width, height, strScroll, strResize, position ){
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		if(strResize == undefined || strResize == '') {
			strResize = 0 ;
		}
		
		readMailPop = parent.window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll+", resizable="+ strResize);
		
		try {readMailPop.focus(); } catch(e){
			console.log(e);//오류 상황 대응 부재
		}
		return readMailPop;
	}
			
	//TODO 업무관리 알림 요약/상세 조회
	function getPrNotice(){
		console.log("업무관리 알림 요약/상세 조회");
	}
	//알림 요약 카운트 갱신
	function refreshNoticeCount(documentId, count){
		$("#" + documentId).html('' + count);
	}
	//검색 결과 데이터 초기화
	function initData(){
		//메뉴리스트 데이터 초기화
		leftMenuList = [];
		replaceResultTextSet( $( "#mCSB_4_container" ), leftMenuList, "");
		$("#menuCnt").text("0");
		//연관컨텐츠 : 통합검색 초기화
		initTotalSearch();
		//연관컨텐츠 : 연관 링크 초기화
		initRelatedLink();
		//연관 검색어 데이터 초기화
		relatedSearchList = [];
		//연관 메뉴 데이터 초기화
		relatedMenuList = [];
	}
	//검색전 초기화
  	function initTotalSearch(){
  		//건수 초기화
  		$("#relatedTotalCount").text(fnMoneyTypeReturn('0'));
  		//전체 일 경우에만 검색 전 전체 삭제.
  		removeAllModule();
  	}
  	//연관 링크 전체삭제
  	function initRelatedLink(){
  		for(var i=0;i<relatedLinkCount;i++){
			$("#result_module_related_link" + i).remove();
		}
  	}
  	//통합검색 모듈 전체삭제
  	function removeAllModule(){
  		for(var i=0;i<13;i++){
			$("#result_module_" + i).remove();
		}
  	}
	//메뉴리스트
	function setMenuData(menuList, valStr, resultData){
		
		resultData = [];
		var exDataModuleMap = {};
		
		//모듈 MAP 생성
		for(var i=0;i<menuList.length;i++){
			var module = menuList[i].module;//"BM"
			var moduleName = menuList[i].moduleName;//"예산관리"
			var id = menuList[i].id;//"NPBBEE01000"
			var name = menuList[i].name;//"일상경비지출원인행위부"
			var path = menuList[i].path;//"비영리예산 > 일상경비 > 일상경비지출원인행위부"
			
			if(!exDataModuleMap[module]){//모듈이 존재하지 않으면
				exDataModuleMap[module] = {
					"count" : 1,
					"exDt" : moduleName + "(" + 1 + ")",
					"exText" : [path],
					"exId" : [id],
					"exName" : [name],
					"module" : module
				};
			}else{//존재하면
				exDataModuleMap[module]["count"] += 1;
				exDataModuleMap[module]["exDt"] = (moduleName + "(" + exDataModuleMap[module]["count"] + ")");
				exDataModuleMap[module]["exText"].push(path);
				exDataModuleMap[module]["exId"].push(id);
				exDataModuleMap[module]["module"] = module;
				exDataModuleMap[module]["exName"].push(name);
			}
		}
		//모듈 MAP to LIST
		for(key in exDataModuleMap){
			resultData.push(exDataModuleMap[key]);
		}
		return resultData;
	}
	//결과창_메뉴리스트 조회
	function getMenuList(valStr){
		loadingMap["menuSearch"] = true;
		var requestTime = new Date().getTime();
		window.parent.dews.ajax.get("/api/CM/MenuService/Search?keyword=" + valStr + "&_" + "=" + requestTime)
		.done(function(data, textStatus, request){
			if(data.state=="success"){
				//메뉴데이터 세팅
				leftMenuList = setMenuData(data.data, valStr, leftMenuList);
				//건수 갱신
				$("#menuCnt").text(data.data.length + "");
				// autoText content 설정
				replaceResultTextSet( $( "#mCSB_4_container" ), leftMenuList, valStr );
				if(data.data.length == 0){
					$('#noMenuList').show();
				}else{
					$('#noMenuList').hide();
				}
				
			}else if(data.state!="success"){//요청 실패
				alert("api 호출 실패");
			}
			loadingMap["menuSearch"] = false;
		});
	}
	//결과창_연관 검색어 조회
	//valStr : 검색어
	//type : "0" 연관메뉴, "1" 연관검색어
	function getRelatedSearchList(valStr, type){
		
		loadingMap["relatedSearch" + type] = true;
		
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/ebp/portalView/getRelatedSearchKeyword.do"/>',
			datatype:"json",
			async: true,
			data:{
				"searchWord": valStr,
				"type" : type,
				"size" : 10
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					
					refreshRelatedSearchKeyword(data.result, type);
					
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						//window.parent.location.href = "/gw/userMain.do";
						window.parent.dews.app.overlay.hide();
					}
				}
				
				loadingMap["relatedSearch" + type] = false;
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
				loadingMap["relatedSearch" + type] = false;
			}  
		});
	}
	//결과창_연관검색어("1")/연관메뉴("0") 세팅
	function refreshRelatedSearchKeyword(relatedSearchKeywordList, type){
		var areaId = '';
		var key = '';
		if(type == "1"){//연관검색어
			areaId = "relatedWordArea"; 
			key = "relatedSearchWord";
		}else if(type == "0"){//연관메뉴
			areaId = "relatedMenuArea";
			key = "menuName";
		}else{
			return;
		}
		$("#" + areaId).html('');
		
		if(relatedSearchKeywordList.length > 0){
			for(var i=0;i<relatedSearchKeywordList.length;i++){
				var id = relatedSearchKeywordList[i]["id"];
				var keyword = relatedSearchKeywordList[i][key];
				var innerHtml = '';
				if(type == "1"){
					innerHtml = '<li id="' + id + '"><a href="javascript:onClickRelated(\'' + keyword + '\')">' + keyword + '</a></li>';	
				}else if(type =="0"){
					innerHtml = '<li id="' + id + '"><a href="javascript:moveMenu(\'' + relatedSearchKeywordList[i]["menuModule"] + '\',\'' + relatedSearchKeywordList[i]["menuId"] + '\',\'' + relatedSearchKeywordList[i]["menuName"] + '\')">' + keyword + '</a></li>';
				}
				//연관검색어 / 메뉴 삽입
		  		$("#" + areaId).append(innerHtml);	
			}	
		}else{//no data
			$("#" + areaId).append('<div class="nonSearch"><%=BizboxAMessage.getMessage("TX000007470","검색 결과가 없습니다.")%></div>');
		}
				
	}
	//연관검색어 클릭 이벤트
	function onClickRelated(keyword){
		$( "#searchText" ).val(keyword).focus();
        $( ".reset_btn" ).show();
        userInfoPopClose();//사용자정보 팝업 강제종료
	}
	
	//검색창_모듈리스트 조회
	function getModuleList(){
		var requestTime = new Date().getTime();
		window.parent.dews.ajax.get("/api/CM/MenuService/Module?_" + "=" + requestTime)
		.done(function(data, textStatus, request){
			if(data.state=="success"){//요청 성공이면
				//모듈리스트 그리기
				drawModuleList(data.data);
				
			}else if(data.state!="success"){//요청 실패
				alert("api 호출 실패");
			}
		});	
	}
	//검색창_모듈리스트 그리기
	function drawModuleList(moduleList){
		var innerHtml = '';
		var count = 0;
		for(var i=0;i<moduleList.length;i++){
			
			if(count == 10){
				break;
			}
			
			var moduleId = moduleList[i]["id"].toLowerCase();
			var moduleName = moduleList[i]["name"];
			var isDynamic = moduleList[i]["dynamic"];
			
			//화면 깨져서 우선 아이콘 존재하는 모듈만 그리도록 임시적용
			if(moduleId=="cl"){//cl 클래스 충돌로 sc로 변경
				moduleId = "sc";
			}
			if(moduleId=="ea" || moduleId=="ml" || moduleId=="sc" 
			|| moduleId=="wk" || moduleId=="sf" || moduleId=="dc" 
			|| moduleId=="bd" || moduleId=="ds" || moduleId=="bm" 
			|| moduleId=="ci" || moduleId=="cr" || moduleId=="fi" 
			|| moduleId=="hr" || moduleId=="ma" || moduleId=="tr" 
			|| moduleId=="tx" || moduleId=="ua" || moduleId=="um"){//현재 총 18개 모듈 아이콘 적용
				innerHtml += '<li class="' + moduleId + '">';
				innerHtml +=	'<a href="javascript:moveModule(\'' + moduleList[i]["id"] + '\',' + isDynamic + ');">' + moduleName + '</a>';
				innerHtml += '</li>';
				count++;
			}else{//아이콘 없는 모듈은 메일 아이콘으로
				innerHtml += '<li class="ml">';
				innerHtml +=	'<a href="javascript:moveModule(\'' + moduleList[i]["id"] + '\',' + isDynamic + ');">' + moduleName + '</a>';
				innerHtml += '</li>';
				count++;
			}
		}
		$("#moduleList").append(innerHtml);
	}
	//검색창_해당모듈 이동 처리(해당모듈의 메뉴 리스트 조회후 가장 첫번째 이동가능한 메뉴로 이동)
	function moveModule(moduleId, isDynamic){
		if(!menuInfoMap[moduleId]){//존재하지 않으면 해당 모듈의 메뉴리스트 조회후 이동처리
			var requestTime = new Date().getTime();
			window.parent.dews.ajax.get("/api/CM/MenuService/" + moduleId + "?dynamic=" + isDynamic + "&_" + "=" + requestTime)
			.done(function(data, textStatus, request){
				if(data.state=="success"){//요청 성공이면
					if(!isDynamic){
						setFirstMenuInfoForNotDynamic(moduleId, data.data);//데이터 세팅후 조회	
					}else{
						setFirstMenuInfoForDynamic(moduleId, data.data);//데이터 세팅후 조회
					}
					
					if(menuInfoMap[moduleId]){
						moveMenu(moduleId, menuInfoMap[moduleId]);	
					}
				}else if(data.state!="success"){//요청 실패
					alert("api 호출 실패");
				}
			});	
		}else{
			//존재하면 바로 이동처리
			moveMenu(moduleId, menuInfoMap[moduleId]);
		}
	}
	//첫번째 메뉴정보 세팅 (재귀호출)_동적메뉴
	function setFirstMenuInfoForDynamic(moduleId, menuList){
		if(menuList){
			for(var i=0;i<menuList.length;i++){
				if(menuInfoMap[moduleId]){
					break;
				}
				var id = menuList[i].id;
				var type = menuList[i].type;
				var children = menuList[i].children;
				
				if(children == null && type=="folder"){
					continue;
				}else{
					if(type == "page"){
						menuInfoMap[moduleId] = id;
						break;
					}
					if(children != null){
						setFirstMenuInfoForDynamic(moduleId, children);	
					}
				}
			}	
		}
	}
	//첫번째 메뉴정보 세팅 (재귀호출)_비동적메뉴
	function setFirstMenuInfoForNotDynamic(moduleId, menuList){
		if(menuList){
			for(var i=0;i<menuList.length;i++){
				if(menuInfoMap[moduleId]){
					break;
				}
				var id = menuList[i].id;
				var children = menuList[i].children;
				
				if(children == null){
					menuInfoMap[moduleId] = id;
					break;
				}else{
					setFirstMenuInfoForNotDynamic(moduleId, children);
				}
			}	
		}
	}
	//검색창_최근검색어 세팅
	function refreshRecentSearchKeyword(recentSearchKeywordList){
		
		$("#recentWordArea").html('');
		
		for(var i=0;i<recentSearchKeywordList.length;i++){
			
			var id = recentSearchKeywordList[i]["id"];
			var searchWord = recentSearchKeywordList[i]["searchWord"];
			var innerHtml = '<dd id="' + id + '"><span>' + searchWord + '</span><a href="javascript:void(0)" class="delete_btn"></a></dd>';
			//최근검색어 삽입
	  		$("#recentWordArea").append(innerHtml);	
		}		
	}
	//검색창_최근검색어 조회
	function getRecentSearchKeyword(){
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/getRecentSearchKeyword.do"/>',
			datatype:"json",
			async: true,
			data:{
				"size":6
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					
					refreshRecentSearchKeyword(data.result);
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						//window.parent.location.href = "/gw/userMain.do";
						window.parent.dews.app.overlay.hide();
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
	}
	//검색창_검색어 저장 처리
  	function saveSearchKeyword(valStr){
  		$.ajax({ 
			type:"POST",
			url: '<c:url value="/saveSearchKeyword.do"/>',
			datatype:"json",
			async: true,
			data:{
				"tsearchKeyword" : valStr
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					//최근검색어 재조회
					getRecentSearchKeyword();
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						//window.parent.location.href = "/gw/userMain.do";
						window.parent.dews.app.overlay.hide();
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
  	}
  	//검색창_검색어 미사용 처리
  	function setNoUseSearchKeyword(id, callback){
  		$.ajax({ 
			type:"POST",
			url: '<c:url value="/setNoUseSearchKeyword.do"/>',
			datatype:"json",
			async: true,
			data:{
				"_id" : id
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					callback();
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						//window.parent.location.href = "/gw/userMain.do";
						window.parent.dews.app.overlay.hide();
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
  	}
  	//derp 메뉴이동
  	function moveMenu(module, menuId, menuName){
  		if(lastMenuSearchKeyword && menuName){//연관메뉴 저장 처리.
  			$.ajax({ 
  				type:"POST",
  				url: '<c:url value="/ebp/portalView/saveRelatedSearchKeyword.do"/>',
  				datatype:"json",
  				async: true,
  				data:{
  					"saveType":"0",
  					"menuModule" : module,
  					"menuId" : menuId,
  					"menuName" : menuName,
  					"searchWord" : lastMenuSearchKeyword
  				},
  				success:function(data){
  					if(data.resultCode=="SUCCESS"){
  						getRelatedSearchList(lastMenuSearchKeyword, "0");
  					}else if(data.resultCode!="LOGIN004"){
  						//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
  					}
  					
  					if(data.resultCode=="LOGIN004"){//loginVO NULL
  						if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
  							//window.parent.location.href = "/gw/userMain.do";
  							window.parent.dews.app.overlay.hide();
  						}
  					}
  					
  				},error: function(result) {
  					alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
  				}  
  			});
  		}
		window.parent.dews.ui.openMenu(module, menuId, {"test":"param"});
		window.parent.dews.app.overlay.hide();
		//메뉴이동시 연관검색어 리스트 초기화 시켜줌
		clearRelatedSearchWordList();
	}
  	//결과창_연관검색어 리스트 초기화
  	function clearRelatedSearchWordList(){
  		relatedSearchWordList = [];
  	}
  	//결과창_연관검색어 저장 처리
	function saveRelatedSearchKeyword(valStr){
		relatedSearchWordList.push(valStr);
		console.log(relatedSearchWordList);
		if(relatedSearchWordList.length == 2){//저장
			$.ajax({ 
  				type:"POST",
  				url: '<c:url value="/ebp/portalView/saveRelatedSearchKeyword.do"/>',
  				datatype:"json",
  				async: true,
  				data:{
  					"saveType":"1",
  					"searchWord" : relatedSearchWordList[0],
  					"relatedSearchWord" : relatedSearchWordList[1]
  				},
  				success:function(data){
  					if(data.resultCode=="SUCCESS"){
  						
  					}else if(data.resultCode!="LOGIN004"){
  						//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
  					}
  					
  					if(data.resultCode=="LOGIN004"){//loginVO NULL
  						if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
  							//window.parent.location.href = "/gw/userMain.do";
  							window.parent.dews.app.overlay.hide();
  						}
  					}
  					
  				},error: function(result) {
  					alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
  				}  
  			});
			clearRelatedSearchWordList();//초기화
		}
	}
  	//결과창_처리
  	function processResult(valStr){
  		//검색어 저장
  		saveSearchKeyword(valStr);
  		//연관검색어 저장 처리
  		saveRelatedSearchKeyword(valStr);
  		//데이터 초기화
  		initData();
  		//메뉴리스트 조회
  		getMenuList(valStr);
  		//연관 컨텐츠 조회 (통합검색, 연관)
  		getRelatedContents(valStr);
  		//연관 검색어 조회
  		getRelatedSearchList(valStr, "1");
  		//연관 메뉴 조회
  		getRelatedSearchList(valStr, "0");
  	}
  	//연관 컨텐츠 조회 (통합검색, 연관링크)
  	function getRelatedContents(valStr){
  		$("#tsearchKeyword").val(valStr);
  		//카운트 데이터
  		var flatData = [];
  		//통합검색 조회
  		//통합검색 옵션 조회 > 통합검색 조회, 연관 링크 조회
 		getTotalSearchOption(valStr, flatData);
 		//연관 링크 조회
  		getRelatedLink(valStr, flatData);
  	}
  	//통합검색 옵션 조회
  	function getTotalSearchOption(valStr, flatData){
  		$.ajax({ 
			type:"GET",
			url: '<c:url value="/getTotalSearchOption.do"/>',
			datatype:"json",
			async: true,
			data:{
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					//카운트 데이터 초기화
			  		flatData = initTotalSearchCount(data.result, flatData);
					//통합검색 조회
					getTotalSearch(valStr, data.result, flatData);
					
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						//window.parent.location.href = "/gw/userMain.do";
						window.parent.dews.app.overlay.hide();
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
  	}
  	//통합검색 조회
  	function getTotalSearch(valStr, optionMap, flatData){
  		//통합검색 전체 모듈 조회
  		allSearch(true, optionMap, flatData);
  		
  	}
  	//통합검색 카운트 데이터 초기화
  	function initTotalSearchCount(optionMap, flatData){
  		
  		if(!optionMap.menuAuthMap){
  			return flatData;
  		}
  		var initCntStr = '(0)'; 
  		var totalYn = {text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>"+initCntStr, name: "1", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>"};
  		var mailYn = {text: "<%=BizboxAMessage.getMessage("TX000000262","메일")%>"+initCntStr, name: "0", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000262","메일")%>"};
  		var scheduleYn = {text: "<%=BizboxAMessage.getMessage("TX000000483","일정")%>"+initCntStr, name: "3", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000483","일정")%>"};
  		var noteYn = {text: "<%=BizboxAMessage.getMessage("TX000010157","노트")%>"+initCntStr, name: "4", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000010157","노트")%>"};
  		var reportYn = {text: "<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>"+initCntStr, name: "5", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>"};
  		var projectYn = {text: "<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>"+initCntStr, name: "2", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>"};
  		var boardYn = {text: "<%=BizboxAMessage.getMessage("TX000011134","게시판")%>"+initCntStr, name: "9", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000011134","게시판")%>"};
  		var edmsYn = {text: "<%=BizboxAMessage.getMessage("TX000008576","문서")%>"+initCntStr, name: "8", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000008576","문서")%>"};
  		var hrYn = {text: "<%=BizboxAMessage.getMessage("TX000020784","인물")%>"+initCntStr, name: "11", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000020784","인물")%>"};
  		var eadocYn = {text: "<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>"+initCntStr, name: optionMap.eaName, count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>"};
  		var tsFileYn = {text: "<%=BizboxAMessage.getMessage("TX000000521","첨부파일")%>"+initCntStr, name: "10", count: 0, onlyText:"<%=BizboxAMessage.getMessage("TX000000521","첨부파일")%>"};
  		var onefficeYn = {text: "<%=BizboxAMessage.getMessage("","ONEFFICE")%>"+initCntStr, name: "12", count: 0, onlyText:"<%=BizboxAMessage.getMessage("","ONEFFICE")%>"};
  		
  		flatData[0] = totalYn;
  		
  		if(optionMap.menuAuthMap.eadocYn == 'Y'){
  			flatData[flatData.length] = eadocYn;
  		}
  		if(optionMap.menuAuthMap.mailYn == 'Y'){
  			flatData[flatData.length] = mailYn;
  		}
  		if(optionMap.menuAuthMap.scheduleYn == 'Y'){
  			flatData[flatData.length] = scheduleYn;
  		}
  		if(optionMap.menuAuthMap.projectYn == 'Y'){
  			flatData[flatData.length] = projectYn;
  		}
  		if(optionMap.menuAuthMap.boardYn == 'Y'){
  			flatData[flatData.length] = boardYn;
  		}
  		if(optionMap.menuAuthMap.edmsYn == 'Y'){
  			flatData[flatData.length] = edmsYn;
  		}
  		if(optionMap.menuAuthMap.reportYn == 'Y'){
  			flatData[flatData.length] = reportYn;
  		}
  		if(optionMap.menuAuthMap.noteYn == 'Y'){
  			flatData[flatData.length] = noteYn;
  		}
		flatData[flatData.length] = hrYn;
  		if(optionMap.menuAuthMap.onefficeYn == 'Y'){
  			flatData[flatData.length] = onefficeYn;
  		}
  		flatData[flatData.length] = tsFileYn;
  		return flatData;
  	}
  	
  	//통합검색 전체 모듈 조회
  	//조회 타입 (boardType) : 메일(0),업무관리(2), 일정(3), 노트(4), 업무보고(5), 전자결재(6:영리,7:비영리), 문서(8), 게시판(9), 첨부파일(10), 인물(11), ONEFFICE(12)
  	function allSearch(isAll, optionMap, flatData){
  		//전자결재
		if(optionMap.menuAuthMap.eadocYn == 'Y'){
			searchTotalSearchContent(optionMap.eaName, isAll, flatData, optionMap);
		}
		//메일
		if(optionMap.menuAuthMap.mailYn == 'Y'){
			searchTotalSearchContent("0", isAll, flatData, optionMap);
		}
		//일정
		if(optionMap.menuAuthMap.scheduleYn == 'Y'){
			searchTotalSearchContent("3", isAll, flatData, optionMap);
		}
		//업무관리
		if(optionMap.menuAuthMap.projectYn == 'Y'){
			searchTotalSearchContent("2", isAll, flatData, optionMap);
		}
		//게시판
		if(optionMap.menuAuthMap.boardYn == 'Y'){
			searchTotalSearchContent("9", isAll, flatData, optionMap);
		}
		//문서
		if(optionMap.menuAuthMap.edmsYn == 'Y'){
			searchTotalSearchContent("8", isAll, flatData, optionMap);
		}
		//업무보고
		if(optionMap.menuAuthMap.reportYn == 'Y'){
			searchTotalSearchContent("5", isAll, flatData, optionMap);
		}
		//노트
		if(optionMap.menuAuthMap.noteYn == 'Y'){
			searchTotalSearchContent("4", isAll, flatData, optionMap);
		}
		//원피스
		if(optionMap.menuAuthMap.onefficeYn == 'Y'){
			searchTotalSearchContent("12", isAll, flatData, optionMap);
		}
		//첨부파일
		searchTotalSearchContent("10", isAll, flatData, optionMap);
		//인물
		searchTotalSearchContent("11", isAll, flatData, optionMap);
  	}
  	//모듈별 공통 API 조회 
  	//조회 타입 (boardType) : 메일(0),업무관리(2), 일정(3), 노트(4), 업무보고(5), 전자결재(6:영리,7:비영리), 문서(8), 게시판(9), 첨부파일(10), 인물(11), ONEFFICE(12)
  	function searchTotalSearchContent (boardType, isAll, flatData, optionMap){
  		
  		loadingMap[boardType] = true;
  		formTotal.listType.value = boardType;
  		var formParam = jQuery("#formTotal").serialize();
  		$.ajax({ 
			type:"POST",
			url: '<c:url value="/getTotalSearchList.do"/>',
			datatype:"json",
			async: true,
			data:formParam,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					//script 태그 제거
					removeScript(data.result);
					//1. 가져온 데이터로  KendoTreeView의 검색 건수 및 화면상의 검색 건수 갱신
					modifyModuleCount(data.result.pagingReturnObj, boardType, isAll, flatData);
					//2. 가져온 데이터로 화면 다시 그리기.(각 모듈별 페이지)
					refreshSearchResult(data.result.pagingReturnObj, boardType, isAll, optionMap);
					//검색어 하이라이트
					searchKeywordHighlight();
					//푸딩 탭처리
					setPuddingTab();
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				loadingMap[boardType] = false;
				
				if(data.resultCode=="LOGIN004" && canSearchStatus()){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
				loadingMap[boardType] = false;
			}  
		});
  	}
  	function setPuddingTab(){
  	// puddTab 함수 호츌
		Pudd( ".sr_tab" ).puddTab({
		 
				tabMenu : {
		 
					attributes : { style:"", class:"tab_menu" }// tabMenu 부모객체에 속성 설정하고자 하는 경우
				}
			,	tabArea : {
		 
					attributes : { style:"", class:"tab_area" }// tabArea 부모객체에 속성 설정하고자 하는 경우
				}
		 
			,	newTab : false
			,	tabSameWidth : true
		});
  	}
  	function removeScript(result){
  		if(result.pagingReturnObj){
	  		var jsonStr = JSON.stringify(result.pagingReturnObj);
	  		var removedJsonStr = jsonStr.replace(/<(\/script|script)([^>]*)>/gi,"");
	  		result.pagingReturnObj = JSON.parse(removedJsonStr);
  		}
  	}
  	//통합검색의 검색 건수 갱신
  	function modifyModuleCount(data, boardType, isAll, flatData){
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
				isChanged = true;
			}
			totalCount += flatData[i]['count'];
		}
		if(isChanged){
			//전체 카운트 갱신
			flatData[allIndex]['text'] = flatData[allIndex]['onlyText'] + "(" + fnMoneyTypeReturn(totalCount) + ")";
			
			//전체 일시 전체 선택
			if(isAll){
				$("#relatedTotalCount").text(fnMoneyTypeReturn(totalCount));
				
				if(totalCount == 0){
					$("#relatedNoResult").show();
				}else{
					$("#relatedNoResult").hide();
				}
				
			}
		}
  	}
  	//화면 갱신.(각 모듈별 페이지, 페이징)
  	function refreshSearchResult(data, boardType, isAll, optionMap){
  		
	  	//1. 기존 DOM 제거 처리
	  	//개별 모듈 제거
	  	$("#result_module_" + boardType).remove();
	  	
	  	//2. 데이터가 있을 경우만 DOM 다시 그리기
  		if (data.resultgrid.length > 0){
  			//2-1. 모듈별 최상위 div innerHtml 생성
  			createRootDivInnerHtml(data, boardType); 
  			//2-2. 모듈별 result_title innerHtml 생성
  			var innerHtml = createResultTitleInnerHtml(data, boardType, isAll);
  			//2-3. 모듈별 list innerHtml 생성
  			innerHtml = createListInnerHtml(data, boardType, innerHtml, optionMap);
  			//2-4. 삽입 처리.
  			$("#result_module_" + boardType).append(innerHtml);
  		}
  	}
  	//모듈별 최상위 div innerHtml 생성
  	//조회 타입 (boardType) : 메일(0)V,업무관리(2)V, 일정(3)V, 노트(4)V, 업무보고(5)V, 전자결재(6:영리,7:비영리)V, 문서(8)V, 게시판(9)V, 첨부파일(10), 인물(11)V, ONEFFICE(12)V
  	function createRootDivInnerHtml(data, boardType, isRelatedLink){
  		
  		var classNm = "sr_div";
  		
  		if(boardType == "0"){//메일
  			classNm += (" " + "sr_ma");
  		}else if(boardType == "2"){//업무관리
  			classNm += (" " + "sr_wk");
  		}else if(boardType == "3"){//일정
  			classNm += (" " + "sr_sc");
  		}else if(boardType == "4"){//노트
  			classNm += (" " + "sr_nt");
  		}else if(boardType == "5"){//업무보고
  			classNm += (" " + "sr_wr");
  		}else if(boardType == "6" || boardType == "7"){//전자결재
  			classNm += (" " + "sr_ea");
  		}else if(boardType == "8"){//문서
  			classNm += (" " + "sr_dc");
  		}else if(boardType == "9"){//게시판
  			classNm += (" " + "sr_bd");
  		}else if(boardType == "10"){//첨부파일
  			classNm += (" " + "sr_fi");
  		}else if(boardType == "11"){//인물
  			classNm += (" " + "sr_ds");
  		}else if(boardType == "12"){//ONEFFICE
  			classNm += (" " + "sr_of");
  		}
  		var innerHtml = '<div id="result_module_' + boardType + '" class="' + classNm + '"></div>'; 
  		
  		if(!isRelatedLink){
  			$(".sr_list").append(innerHtml);	
  		}else{
  			$(".sr_list").prepend(innerHtml);
  		}
  	}
  	function boardTypeDetail(boardType){
  		//TODO 세부 메뉴 이동처리 개발 필요
  		alert("세부 메뉴 이동처리 개발 필요[" + boardType + "]");
  	}
  	//모듈별 result_title innerHtml 생성
  	//조회 타입 (boardType) : 메일(0),업무관리(2), 일정(3), 노트(4), 업무보고(5)V, 전자결재(6:영리,7:비영리)V, 문서(8), 게시판(9), 첨부파일(10), 인물(11), ONEFFICE(12)
  	function createResultTitleInnerHtml(data, boardType, isAll){
		//해당 모듈의 카운트  		
  		var moduleCnt = fnMoneyTypeReturn(data.totalcount + '');
  		//sr_tit 시작태그
  		var innerHtml = '<div class="sr_tit" onClick="boardTypeDetail(\'' + boardType + '\')">';
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
		innerHtml += '<h2>' + moduleName + '</h2>'; 
		innerHtml += '<p class=\"re_num\"> (<span class="col">' + moduleCnt +'</span>)</p>';
		
  		//result_title 종료태그
  		innerHtml += '</div>';
  		
  		return innerHtml;
  	}
  	
  	function titleDotDotDot(title){
  		//최대 제한 자릿수
  		var titleLimitLength = 15;
  		//제목 줄임 처리
		var subject = '';
		if(title && title != ''){
			if(title && title.length > titleLimitLength){
				subject += (title.substring(0, titleLimitLength) + '...');
			}else if(title && title.length <= titleLimitLength){
				subject += title;
			}else if(!title || (title && title.length == 0)){
				subject += '';
			}
		}
		return subject;
  	}
  	//연관컨텐츠 > 통합검색 > 첨부파일 DOM
  	function getTotalSearchFileContentHtmlDom(innerHtml, result, optionMap){
  		innerHtml +=		'<li>';
		innerHtml += 		'<div class="sts_div">';
		innerHtml += 			'<p class="sts_tit">';
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
		innerHtml += 			'<div class="sts_con">';
		innerHtml += 				'<div class="sts_pictxt">';
		innerHtml += 					'<div class="pt_div">';
		//전체 탭에서 이미지일 경우
		if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='jpg' 
				|| result.fileExtsn.toLowerCase() =='jpeg' 
				|| result.fileExtsn.toLowerCase() =='gif' 
				|| result.fileExtsn.toLowerCase() =='png' 
				|| result.fileExtsn.toLowerCase() =='bmp')){
			innerHtml += 						'<a href="#n" class="dot1">';
			if(result.jobType == "board-1" || result.jobType == "board-2"){
				innerHtml += boardFileImgTag(result.pkSeq, result.filePath, result.fileName);
			}else{
				var url = '<c:url value="/cmm/file/fileDownloadProc.do?fileId=' + result.fileId+ '&fileSn=' + result.fileSn + '"/>'; 
				innerHtml += '<img id="totalTabImg" src="' + url + '" onerror="this.src=\'/gw/Images/ico/media_noimg.png\'" />';
			}
		//전체 탭에서 동영상일 경우
		}else if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='mp4' || result.fileExtsn.toLowerCase() =='mov' || result.fileExtsn.toLowerCase() =='avi' 
				|| result.fileExtsn.toLowerCase() =='asf' || result.fileExtsn.toLowerCase() =='wmv' || result.fileExtsn.toLowerCase() =='mpeg'
				|| result.fileExtsn.toLowerCase() =='mpg' || result.fileExtsn.toLowerCase() =='mp3' || result.fileExtsn.toLowerCase() =='wma'
				|| result.fileExtsn.toLowerCase() =='wav' || result.fileExtsn.toLowerCase() =='flv')){
			innerHtml += 						'<a href="#n" class="video1">';
			innerHtml += '<img src="/gw/Images/ico/media_noimg.png" alt="" />';
		}else{
			innerHtml += 						'<a href="#n" class="dot1">';
			if(result.fileContent && result.fileContent.length > 30){
				var keyIndexOf = result.fileContent.indexOf($("#tsearchKeyword").val());
				
				if(keyIndexOf > 30){
					innerHtml += result.fileContent.substring(keyIndexOf-(30-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
				}else{
					innerHtml += result.fileContent;
				}
			}else if(!result.fileContent || (result.fileContent && result.fileContent.length == 0)){
				innerHtml += '<%=BizboxAMessage.getMessage("","텍스트가 포함되어 있지 않아 미리보기 지원이 되지 않습니다.")%>';
			}else if(result.fileContent && result.fileContent.length <= 30){
				innerHtml += result.fileContent;
			}
		}
		innerHtml +=						'</a>';
		innerHtml += 					'</div>';
		innerHtml += 				'</div>';
		innerHtml += 				'<div class="sts_file">';
		
		if(result.jobType == 'board-1' || result.jobType == 'board-2'){
			innerHtml += boardFileDownPop(result.pkSeq, result.filePath, result.fileName, result.fileName, result.jobType, result.fileSn, result.fileExtsn, optionMap);
		}else if(result.jobType == 'edms-1' || result.jobType == 'edms-2'){
			innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/edms/doc/downloadFile.do?artNo=' + result.pkSeq + '&fileNo=' + result.fileSn +'\',\'' + result.fileSn + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'' + optionMap.pathSeq300 + '\',\'' + optionMap.pathSeq400 + '\',\'' + optionMap.pathSeq500 + '\',\'' + optionMap.pathSeq600 + '\',\'' + optionMap.pathSeqEa + '\')" class="dot2 file_' + result.fileExtsn.toLowerCase() + '">'; 
			innerHtml += result.fileName;
			innerHtml += '</a>';
		}else{
			innerHtml += '<a style="cursor:pointer" onclick="fnFileDownLoad(\'/gw/cmm/file/fileDownloadProc.do?fileId=' + result.fileId + '&fileSn=' + result.fileSn +'\',\'' + result.fileId + '\',\'' + result.jobType +'\',\'' + result.fileName + '\',\'' + result.fileExtsn + '\',\'' + optionMap.pathSeq300 + '\',\'' + optionMap.pathSeq400 + '\',\'' + optionMap.pathSeq500 + '\',\'' + optionMap.pathSeq600 + '\',\'' + optionMap.pathSeqEa + '\')" class="dot2 file_' + result.fileExtsn.toLowerCase() + '">';
			innerHtml += result.fileName;
			innerHtml += '</a>';
		}
		innerHtml += 				'</div>';
		innerHtml += 				'<div class="na_dat">';
		innerHtml += 					'<p class="na"></p>';
		innerHtml += 					'<span class="dat">';
		innerHtml += result.createDate.replace("T", " ").substring(0, 10);
		innerHtml += 					'</span>';
		innerHtml += 				'</div>';
		innerHtml += 			'</div>';//sts_con
		innerHtml += 		'</div>';//sts_div
		innerHtml +=		'</li>';//li
		return innerHtml;
  	}
  	
  	//모듈별 list innerHtml 생성
  	//인물검색, 첨부파일, 원피스는 화면 포맷이 전혀 다름.
  	//나머지는 비슷하기는 하나 안에 내부 IF문이 많은 타입으로 공통화 시키면 로직 파악 어려움 으로 각각 그림.
  	//조회 타입 (boardType) : 메일(0)V,업무관리(2)V, 일정(3)V, 노트(4)V, 업무보고(5)V, 전자결재(6:영리,7:비영리)V, 문서(8)V, 게시판(9)V, 첨부파일(10)V, 인물(11)V, ONEFFICE(12)V
  	function createListInnerHtml(data, boardType, innerHtml, optionMap){
  		
  		innerHtml += '<div class="sr_con">';
  		
  		//첨부파일 화면 처리.
  		if(boardType == "10"){
  			innerHtml += '<div class="sr_tab">';
  			innerHtml += 	'<ul>';
  			innerHtml += 		'<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000000862","전체")%></li>';
  			innerHtml += 		'<li><%=BizboxAMessage.getMessage("TX000005937","이미지")%></li>';
  			innerHtml += 		'<li><%=BizboxAMessage.getMessage("TX000008576","문서")%></li>';
  			innerHtml += 		'<li><%=BizboxAMessage.getMessage("TX000018199","멀티미디어")%></li>';
  			innerHtml += 		'<li><%=BizboxAMessage.getMessage("TX000005400","기타")%></li>';
  			innerHtml += 	'</ul>';
  			//------------------------------------------------- 전체 탭 -----------------------------------------------------
  			innerHtml += 	'<div  class="tab1">';//전체 탭
  			innerHtml += 		'<div class="sr_box_list">';
  			innerHtml += 			'<ul>';
  			//전체 탭 for문
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				innerHtml = getTotalSearchFileContentHtmlDom(innerHtml, result, optionMap);
			}//전체 탭 for문 end
  			innerHtml += 			'</ul>';
  			innerHtml += 		'</div>';
  			innerHtml +=	'</div>';//tab1 end
  			//------------------------------------------------- 이미지 탭 -----------------------------------------------------
  			innerHtml += 	'<div  class="tab2">';//이미지 탭
  			innerHtml += 		'<div class="sr_box_list">';
  			innerHtml += 			'<ul>';
  			//이미지 탭 for문
  			var imgTabCount = 0;
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(imgTabCount==3) break;
  				var result = data.resultgrid[i];
  				
  				if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='jpg' 
  					|| result.fileExtsn.toLowerCase() =='jpeg' 
  					|| result.fileExtsn.toLowerCase() =='gif' 
  					|| result.fileExtsn.toLowerCase() =='png' 
  					|| result.fileExtsn.toLowerCase() =='bmp')){
	  				
  					innerHtml = getTotalSearchFileContentHtmlDom(innerHtml, result, optionMap);
		  			imgTabCount++;
  				}
			}//이미지 탭 for문 end
  			innerHtml += 			'</ul>';
  			innerHtml += 		'</div>';
  			innerHtml += 	'</div>';//tab2 end
  			//------------------------------------------------- 문서 탭 -----------------------------------------------------
  			innerHtml += 	'<div  class="tab3">';//문서 탭
  			innerHtml += 		'<div class="sr_box_list">';
  			innerHtml += 			'<ul>';
  			//문서 탭 for문
  			var docTabCount = 0;
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(docTabCount==3) break;
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
	  				
  					innerHtml = getTotalSearchFileContentHtmlDom(innerHtml, result, optionMap);
		  			docTabCount++;
  				}
			}//문서 탭 for문 end
  			innerHtml += 			'</ul>';
  			innerHtml += 		'</div>';
  			innerHtml += 	'</div>';//tab3 end
  			//------------------------------------------------- 멀티미디어 탭 -----------------------------------------------------
  			innerHtml += 	'<div  class="tab4">';//멀티미디어 탭
  			innerHtml += 		'<div class="sr_box_list">';
  			innerHtml += 			'<ul>';
  			//멀티미디어 탭 for문
  			var multiTabCount = 0;
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(multiTabCount==3) break;
  				var result = data.resultgrid[i];
  				
  				if(result.fileExtsn && (result.fileExtsn.toLowerCase() =='mp4' || result.fileExtsn.toLowerCase() =='mov' || result.fileExtsn.toLowerCase() =='avi' 
  					|| result.fileExtsn.toLowerCase() =='asf' || result.fileExtsn.toLowerCase() =='wmv' || result.fileExtsn.toLowerCase() =='mpeg'
  					|| result.fileExtsn.toLowerCase() =='mpg' || result.fileExtsn.toLowerCase() =='mp3' || result.fileExtsn.toLowerCase() =='wma'
  					|| result.fileExtsn.toLowerCase() =='wav' || result.fileExtsn.toLowerCase() =='flv')){
	  				
  					innerHtml = getTotalSearchFileContentHtmlDom(innerHtml, result, optionMap);
	  				
		  			multiTabCount++;
  				}
			}//멀티미디어 탭 for문 end
  			innerHtml += 			'</ul>';
  			innerHtml += 		'</div>';
  			innerHtml += 	'</div>';//tab4 end
  			//------------------------------------------------- 기타 탭 -----------------------------------------------------
  			innerHtml += 	'<div  class="tab5">';//기타 탭
  			innerHtml += 		'<div class="sr_box_list">';
  			innerHtml += 			'<ul>';
  			//기타 탭 for문
  			var etcTabCount = 0;
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(etcTabCount==3) break;
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
	  				
  					innerHtml = getTotalSearchFileContentHtmlDom(innerHtml, result, optionMap);
		  			etcTabCount++;
  				}
			}//기타 탭 for문 end
  			innerHtml += 			'</ul>';
  			innerHtml += 		'</div>';
  			innerHtml += 	'</div>';//tab5 end
  			innerHtml += '</div>';//sr_tab end
  		}
  		//원피스 화면 처리.
  		else if(boardType == "12"){
  			innerHtml += '<div class="sr_box_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				innerHtml += '<li>';
  				innerHtml += 	'<div class="sts_div">';
  				innerHtml += 		'<div class="sts_pictxt">';
  				innerHtml += 			'<div class="pt_div">';
  				if(result.content && result.content != ''){
  	  				if(result.content && result.content.length > 60){
  	  					var keyIndexOf = result.content.indexOf($("#tsearchKeyword").val());
  	  					
  	  					if(keyIndexOf > 60){
  	  						innerHtml += result.content.substring(keyIndexOf-(60-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
  	  					}else{
  	  						innerHtml += result.content.substring(0, 60);
  	  					}
  	  					
  	  				}else if(result.content && result.content.length <= 60){
	  					innerHtml += result.content;
	  				}else if(!result.content || (result.content && result.content.length == 0)){
	  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","검색내용이 없어 제공하지 않습니다.")%>';
	  				}
  	  			}
  				
  				innerHtml += 				'</a>';
  				innerHtml += 			'</div>';
  				innerHtml +=		'</div>';
  				innerHtml +=		'<div class="sts_file">'
 				innerHtml +=	 		'<a href="javascript:onefficeMove(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\');" class="dot2 file_one">' + result.docName + '</a>';
  				innerHtml += 		'</div>';
  				innerHtml +=		'<div class="na_dat">';
  				var modDate = '';
	  			if(result.modDate){
	  				modDate = result.modDate.replace("T", " ").substring(0, 10);
	  			}
  				innerHtml +=			'<span class="dat">' + modDate+ '</span>';
  				if(result.shareYn =='Y'){
  					innerHtml +=			'<span class="share_sp red"></span>';	
	  			}else{
	  				innerHtml +=			'<span class="red"></span>';
	  			}
  				innerHtml +=		'</div>';
  				innerHtml += 	'</div>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//인물 화면 처리
  		else if(boardType == "11"){
  			var profilePath = optionMap.profilePath;
  			
  			innerHtml += '<div class="sr_box_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				innerHtml += '<li>';
  				innerHtml += 	'<div class="person">';
  				innerHtml += 		'<div class="pic_set">';
  				innerHtml += 			'<div class="pic">';
  				innerHtml += 				'<img src="' + profilePath + '/' + result.empSeq + '_thum.jpg?<%=System.currentTimeMillis()%>" onerror="this.src=\'/gw/Images/bg/mypage_noimg.png\'"/>';
  				innerHtml += 			'</div>';
  				innerHtml +=			'<div class="pic_bg"></div>';
  				innerHtml +=		'</div>';
  				innerHtml +=		'<div class="per_info">'
  				innerHtml += 			'<dl>';
  				innerHtml += 				'<dt>' + result.empName + '</dt>';
  				innerHtml += 				'<dd class="po">' + result.positionName +'/' + result.dutyName + '</dd>';
  				innerHtml += 				'<dd class="ph">' + result.telNum + '</dd>';
  				innerHtml += 				'<dd class="dp">' + result.compDeptName + '</dd>';
  				innerHtml += 			'</dl>';
  				innerHtml += 		'</div>';
  				innerHtml += 		'<a href="#n" onClick="javascript:getTotalSearchHr(\'4\',\'' + result.empSeq +'\');" class="ac_more"><%=BizboxAMessage.getMessage("TX000020785","활동보기")%></a>';
  				innerHtml += 	'</div>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//일정 화면 처리.
  		else if(boardType == "3"){
  			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
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
  				
  				innerHtml += '<li>';
				innerHtml += 	'<dl>';
  				innerHtml += 		'<dt><span class="tit_sp">';
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
  				
  				innerHtml += '</span><a href="javascript:scheduleMove(\'' + pkSeq1 +'\',\'' + pkSeq2 + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">';
  				//제목
  				if(jobType =='schedule-1'){
					innerHtml += titleDotDotDot(result.schTitle);
  				}else if(jobType =='schedule-2'){
  					innerHtml += titleDotDotDot(result.reqText);
  				}
  				
  				innerHtml += 		'</a></dt>';
  				innerHtml += 		'<dd class="txt_dd">';
  				innerHtml += 			'<p class="txt_p">';

  				//3. contents_line 처리 (내용)
				if((result.jobType == 'schedule-1' && result.contents && result.contents != '') || (result.jobType == 'schedule-2' && result.descText && result.descText != '')){
					if(result.jobType == 'schedule-2'){
						innerHtml += 			'<%=BizboxAMessage.getMessage("TX000012088","자원명")%> : ' + result.resName + '<br/>';
					}
					innerHtml += 			'<%=BizboxAMessage.getMessage("TX000000145","내용")%> : ';
					
					if(result.contents && result.contents.length > 60 && result.jobType == 'schedule-1'){
						var keyIndexOf = result.contents.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 60){
							innerHtml += result.contents.substring(keyIndexOf-(60-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else{
							innerHtml += result.contents.substring(0, 60);
						}
						
					}else if(result.descText && result.descText.length > 60 && result.jobType == 'schedule-2'){
						var keyIndexOf = result.descText.indexOf($("#tsearchKeyword").val());
						
						if(keyIndexOf > 60){
							innerHtml += result.descText.substring(keyIndexOf-(60-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
						}else{
							innerHtml += result.descText.substring(0, 60);
						}
					}else if(result.contents && result.contents.length <= 60 && result.jobType == 'schedule-1'){
						innerHtml += result.contents;
					}else if(result.descText && result.descText.length <= 60 && result.jobType == 'schedule-2'){
						innerHtml += result.descText;
					}
					innerHtml += '<a href="javascript:scheduleMove(\'' + pkSeq1 +'\',\'' + pkSeq2 + '\');" class="more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
				}
  				innerHtml += 			'</p>'
  				innerHtml += 		'</dd>'
  				innerHtml += 	'</dl>'
  				innerHtml +=	'<p class="lo_txt">';
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
				innerHtml +=	'</p>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//전자결재(영리/비영리)
		else if(boardType == "6" || boardType == "7"){
			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				innerHtml += '<li>';
				innerHtml += 	'<dl>';
  				innerHtml += 		'<dt><a href="javascript:eapPop(\'' + result.pkSeq + '\',\'' + result.formId + '\',\'' + result.migYn + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">' + titleDotDotDot(result.docTitle) + '</a></dt>';
  				innerHtml += 		'<dd class="date">';
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
  				innerHtml += 		'</dd>'
  				innerHtml += 		'<dd class="txt_dd">';
  				innerHtml += 			'<p class="txt_p">';
  				//3. contents_line 처리 (내용)
  	  			if(result.docContents && result.docContents != ''){
  	  				if(result.docContents && result.docContents.length > 60){
  	  					var keyIndexOf = result.docContents.indexOf($("#tsearchKeyword").val());
  	  					
  	  					if(keyIndexOf > 60){
  	  						innerHtml += result.docContents.substring(keyIndexOf-(60-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
  	  					}else{
  	  						innerHtml += result.docContents.substring(0, 60);
  	  					}
  	  					
  	  				}else if(result.docContents && result.docContents.length <= 60){
	  					innerHtml += result.docContents;
	  				}else if(!result.docContents || (result.docContents && result.docContents.length == 0)){
	  					innerHtml += '<%=BizboxAMessage.getMessage("TX000018198","내용 없음")%>';
	  				}
  	  				innerHtml += 		'<a href="javascript:eapPop(\'' + result.pkSeq +'\',\'' + result.formId + '\',\'' + result.migYn + '\',\'' + optionMap.eaType + '\');" class="more">...<%=BizboxAMessage.getMessage("TX000018197","더보기")%></a>';
  	  			}
  				
  				innerHtml += 			'</p>'
  				innerHtml += 		'</dd>'
  				innerHtml += 	'</dl>'
  				innerHtml +=	'<p class="lo_txt">' + result.formNm[langCode.toLowerCase()] + '</p>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}//노트
		else if(boardType == "4"){
			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				innerHtml += '<li>';
				innerHtml += 	'<dl>';
  				innerHtml += 		'<dt>';
  				innerHtml += '<a href="javascript:noteMove(\'' + result.pkSeq + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">' + titleDotDotDot(result.noteName) + '</a></dt>';
  				innerHtml += 		'<dd class="date">';
  				//날짜
  				if(result.noteDate){
  					innerHtml += result.noteDate.replace("T", " ");
  				}
  				innerHtml += 		'</dd>'
  				innerHtml += 	'</dl>'
  				innerHtml += 	'<p class="lo_txt wk_lo3">';
				if(result.folderName == ''){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000010157","노트")%>';
  	  			}
  				innerHtml += result.folderName;
  				innerHtml +=	'</p>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//업무보고 화면 처리.
		else if(boardType == "5"){
			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				innerHtml += '<li>';
				innerHtml += 	'<dl>';
  				innerHtml += 		'<dt><span class="tit_sp">';
  				if(jobType == 'report-1'){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000006542","일일")%>';
  	  			}else if(jobType == 'report-2'){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000006781","수시")%>';
  	  			}
  				innerHtml += '</span><a href="javascript:reportPop(\'' + result.reportSeq + '\',\'' + result.jobType + '\',\'' + result.createSeq + '\',\'' + result.targetEmpSeq + '\',\'' + result.openYn + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">' + titleDotDotDot(result.title) + '</a></dt>';
  				innerHtml += 		'<dd class="date"><%=BizboxAMessage.getMessage("TX000000480","날짜")%> : ';
  				//날짜
  				if(result.reportDate){
  					innerHtml += fnDateTypeReturn(result.reportDate, '-');
  				}
  				innerHtml += 		'</dd>'
  				innerHtml += 	'</dl>'
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//업무관리 화면 처리.
  		else if(boardType == "2"){
  			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				if(jobType =='project-1' || jobType =='project-2' || jobType =='project-3' || jobType =='board-3'){
	  				innerHtml += '<li>';
					innerHtml += 	'<dl>';
					innerHtml += 		'<dt>';
					//제목
		  	  		if(jobType =='project-1'){
						innerHtml += 		'<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');"  class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">';
						innerHtml += titleDotDotDot(result.prjName);
					}else if(jobType =='project-2'){
						innerHtml += 		'<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">';
						innerHtml += titleDotDotDot(result.workName);
					}else if(jobType =='project-3'){
						innerHtml += 		'<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">';
						innerHtml += titleDotDotDot(result.jobName);
					}else if(jobType =='board-3'){
						innerHtml += 		'<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">';
						innerHtml += titleDotDotDot(result.artTitle);
					}
					innerHtml += 		'</a></dt>';
	  				innerHtml += 		'<dd class="date">';
	  				//날짜
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
	  				innerHtml += 		'</dd>';
	  				innerHtml += 		'<dd class="txt_dd">';
	  				innerHtml += 			'<p class="txt_p">';
	  				//3. contents_line 처리 (내용)
					if((result.jobType == 'project-1' && result.dcRmk != '') || (result.jobType == 'project-2' && result.workContents != '') || (result.jobType == 'project-3' && result.jobDetail != '') || (result.jobType == 'board-3' && result.artContent != '')){
						
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
							innerHtml += '<a href="javascript:projectMove2(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + result.groupSeq + '\',\'' + result.workSeq + '\',\'' + result.prjSeq+ '\',\'' + '' + '\');" class="more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></a>';							
						}else if(result.jobType == 'board-3'){
							innerHtml += '<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');" class="more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></a>';
						}
					}
	  				
	  				innerHtml += 			'</p>'
	  				innerHtml += 		'</dd>'
	  				innerHtml += 	'</dl>'
	  				
	  				if(jobType =='project-1'){
	  					innerHtml +=	'<p class="lo_txt wk_lo2">';
						innerHtml += '<%=BizboxAMessage.getMessage("TX000000519","프로젝트")%>';
					}else if(jobType =='project-2'){
						innerHtml +=	'<p class="lo_txt wk_lo1">';
						innerHtml += '<%=BizboxAMessage.getMessage("TX000010930","업무")%>';
					}else if(jobType =='project-3'){
						innerHtml +=	'<p class="lo_txt wk_lo3">';
						innerHtml += '<%=BizboxAMessage.getMessage("TX000007154","할일")%>';
					}else if(jobType =='board-3'){
						innerHtml +=	'<p class="lo_txt wk_lo1">';
						innerHtml += result.catTitle;
					}
					innerHtml +=	'</p>';
	  				innerHtml += '</li>';
  				}
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//메일 화면 처리.
  		else if(boardType == "0"){
  			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
				
  				innerHtml += '<li>';
				innerHtml += 	'<dl>';
  				innerHtml += 		'<dt><span class="tit_sp">' + fnMainInBoxNameReturn(result.boxName) + '</span><a href="javascript:mailMove(\'' + result.emailAddr + '\',\'' + result.muid + '\',\'' + optionMap.mailUrl + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">' + titleDotDotDot(result.subject) + '</a></dt>';
  				innerHtml += 		'<dd class="date"><%=BizboxAMessage.getMessage("TX000000480","날짜")%> : ';
  				if(result.rfc822date && result.rfc822date.length > 10){
	  				innerHtml += result.rfc822date.replace("T", " ").substring(0, 10);
	  			}
  				innerHtml += 		'</dd>'
  				innerHtml += 		'<dd class="txt_dd">';
  				innerHtml += 			'<p class="txt_p">';

  				if(result.mailBody && result.mailBody.length > 60){
  	  				var keyIndexOf = result.mailBody.indexOf($("#tsearchKeyword").val());
  	  				
  	  				if(keyIndexOf > 60){
  	  					innerHtml += result.mailBody.substring(keyIndexOf-(60-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
  	  				}else{
  	  					innerHtml += result.mailBody.substring(0, 60);
  	  				}
  	  				
  	  			}else{
  	  				innerHtml += result.mailBody;
  	  			}
  				innerHtml += 			'<a href="javascript:mailMove(\'' + result.emailAddr + '\',\'' + result.muid + '\',\'' + optionMap.mailUrl + '\');" class="more">...<%=BizboxAMessage.getMessage("TX000018197","더보기")%></a>';
  				innerHtml += 			'</p>'
  				innerHtml += 		'</dd>'
  				innerHtml += 	'</dl>'
  				innerHtml +=	'<p class="lo_txt">From : ' + result.mailFrom + '</p>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//문서 화면 처리.
  		else if(boardType == "8"){
  			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				innerHtml += '<li>';
				innerHtml += 	'<dl>';
				innerHtml += 		'<dt><a href="javascript:edmsMove(\'' + result.wDirCd + '\',\'' + result.artSeqNo + '\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">' + titleDotDotDot(result.artTitle) + '</a></dt>';
  				innerHtml += 		'<dd class="date">';
  				innerHtml += '<%=BizboxAMessage.getMessage("TX000000612","작성일")%> : ';
  				if(result.writeDate && result.writeDate.length > 10){
  					innerHtml += result.writeDate.replace("T", " ").substring(0, 10);
  				}
  				innerHtml += 		'</dd>';
  				innerHtml += 		'<dd class="txt_dd">';
  				innerHtml += 			'<p class="txt_p">';

  				//3. contents_line 처리 (내용)
				if(result.artContent && result.artContent != ''){
  	  				
					
					if(result.artContent && result.artContent.length > 60){
	  	  				var keyIndexOf = result.artContent.indexOf($("#tsearchKeyword").val());
	  	  				
	  	  				if(keyIndexOf > 60){
	  	  					innerHtml += result.artContent.substring(keyIndexOf-(60-$("#tsearchKeyword").val().length), keyIndexOf + $("#tsearchKeyword").val().length);
	  	  				}else{
	  	  					innerHtml += result.artContent.substring(0, 60);
	  	  				}
	  	  				
	  	  			}else{
	  	  				innerHtml += result.artContent;
	  	  			}
  	  				
					innerHtml += 		'<a href="javascript:edmsMove(\'' + result.wDirCd + '\',\'' + result.artSeqNo + '\');" class="more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></span></a>';
  	  			}
				
  				innerHtml += 			'</p>'
  				innerHtml += 		'</dd>'
  				innerHtml += 	'</dl>'
  				innerHtml +=	'<p class="lo_txt">';
  				innerHtml += result.dirNm;
				innerHtml +=	'</p>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		//게시판 화면 처리.
  		else if(boardType == "9"){
  			innerHtml += '<div class="sr_txt_list">';
  			innerHtml += 	'<ul>';
  			
  			for(var i=0;i<data.resultgrid.length;i++){
  				if(i==3) break;
  				var result = data.resultgrid[i];
  				var jobType = result.jobType;
  				
  				innerHtml += '<li>';
				innerHtml += 	'<dl>';
				innerHtml += 		'<dt>';
				//제목
  	  			if(result.jobType == 'board-1' || result.jobType == 'board-3'){
	  				innerHtml += 		'<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">';
  	  			}
  	  			if(result.jobType == 'board-2'){
	  				innerHtml += 		'<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.pkSeq + '\',\'' + '' +'\');" class="more" style="display:inline;font-size:14px;font-weight:bold;color:black;background:none">';
	  			}
  		  		innerHtml += titleDotDotDot(result.artTitle);
				
				innerHtml += 		'</a></dt>';
  				innerHtml += 		'<dd class="date">';
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
  				innerHtml += 		'</dd>';
  				innerHtml += 		'<dd class="txt_dd">';
  				innerHtml += 			'<p class="txt_p">';

  				//3. contents_line 처리 (내용)
  	  			if((result.jobType == 'board-1' && result.artContent && result.artContent != '') 
  	  					|| (result.jobType == 'board-3' && result.artContent && result.artContent != '')){
  	  				
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
  	  				innerHtml += '<a href="javascript:boardMove(\'' + result.jobType + '\',\'' + result.catSeqNo + '\',\'' + result.artSeqNo +'\');" class="more">··· <%=BizboxAMessage.getMessage("TX000018197","더보기")%></a>';
  	  			}
  				innerHtml += 			'</p>'
  				innerHtml += 		'</dd>'
  				innerHtml += 	'</dl>'
  				innerHtml +=	'<p class="lo_txt">';
  				if(result.jobType == 'board-1' || result.jobType == 'board-3'){
  	  				innerHtml += result.catTitle;
  	  			}else if(result.jobType == 'board-2'){
  	  				innerHtml += '<%=BizboxAMessage.getMessage("TX000002747","설문조사")%>';
  	  			}
				innerHtml +=	'</p>';
  				innerHtml += '</li>';
  			}
  			innerHtml += 	'</ul>';
  			innerHtml += '</div>';
  		}
  		
  		innerHtml += '</div>';
  		
  		return innerHtml;
  	}
  	function boardFileImgTag(boardNo,fileNm,fileRnm) {
     	var fileNmSub = fileNm;
     	var fileNmTmp = fileNm.substring(fileNm.lastIndexOf("/")+1);
     	var fileExtsn = fileNmTmp.substring(fileNmTmp.lastIndexOf(".")+1);
     	fileRnm = fileRnm + "." + fileExtsn;
     	
     	var boardNoTmp = fileNmSub.substring(0,fileNmSub.lastIndexOf("/"));
     	boardNoTmp = boardNoTmp.substring(boardNoTmp.lastIndexOf("/")+1);
     	var errorImgTag = "/gw/Images/ico/media_noimg.png";
 		var imgTag = "<img id='totalTabImg' src='/edms/board/downloadFile.do?boardNo="+boardNoTmp+"&fileNm="+fileNmTmp+"&fileRnm="+fileRnm+"' onerror='this.src="+errorImgTag+"' />";
   		return imgTag;
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
    	if(jobType == "eapproval-1" || jobType == "eapproval-2"){ // 전자결재
    		eapPop(obj.doc_id, obj.formId);
    	}
    	if(jobType == "report-1" || jobType == "report-2"){
    		reportPop(obj.reportSeq, jobType, obj.createSeq, obj.targetEmpSeq, obj.openYn);
    	}
    	if(jobType == "edms-1" || jobType == "edms-2"){
    		edmsMove(obj.dir_cd, obj.art_seq_no);
    	}
    	if(jobType == "note"){
    		noteMove(obj.noteSeq);
    	}
    	if(jobType == "schedule-1"){
    		scheduleMove(pkSeq1, pkSeq2)
    	}
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
  		var url = "<c:url value='http://"+location.host+"/project/Views/Common/project/projectView.do?pSeq="+projectSeq+"&wSeq="+workSeq+"&jSeq="+jobSeq+"&type="+type+"'/>";
  		openWindow2(url,  "pop", 1100, 911, 0) ;
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
		if(checkExtsn.indexOf(extsn) != -1){
			fnDocViewerPop(selectedFileUrl, selectedfileNm, selectedfileId);
		}else{
			alert("<%=BizboxAMessage.getMessage("TX900000575","해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자 : 이미지, pdf, hwp, hwpx, doc, docx, ppt, pptx, xls, xlsx]")%>");
		}
    }
  	//첨부파일 다운로드
	function fnFileDownLoad(url, fileId, moduleTp, fileNm, fileExtsn, pathSeq300, pathSeq400, pathSeq500, pathSeq600, pathSeqEa){
  		
		var optionValue = "";
		
		if(moduleTp == "project-1" || moduleTp == "project-2" || moduleTp == "project-3"){
			optionValue = pathSeq300;
		}else if(moduleTp == "schedule-1" || moduleTp == "schedule-2" || moduleTp == "note" || moduleTp == "report-1" || moduleTp == "report-2"){
			optionValue = pathSeq400;
		}else if(moduleTp == "board-1" || moduleTp == "board-2" || moduleTp == "board-3"){
			optionValue = pathSeq500;
		}else if(moduleTp == "edms-1" || moduleTp == "edms-2" || moduleTp == "edms-3"){
			optionValue = pathSeq600;
		}else if(moduleTp == "eadoc-1" || moduleTp == "eadoc-2" || moduleTp == "eapproval-1" || moduleTp == "eapproval-2"){
			optionValue = pathSeqEa;
		}
		
		
		if(optionValue == "-1"){
    		return;
    	}
		
		
		if(optionValue == "0"){
    		var extsn = fileExtsn;
			var checkExtsn = ".hwp.hwpx.doc.docx.ppt.pptx.xls.xlsx";
			if(checkExtsn.indexOf(extsn) == -1){
				 this.location.href = url;
			     return false;
			}    		
			else{
	    		selectedFileUrl = url;
	    	    selectedfileNm = fileNm;
	    	    selectedfileId = fileId;    	
	    	    selectedFileExtsn = fileExtsn;
	    		
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
	function replaceAll(str, searchStr, replaceStr) {
		
		if(str){
			return str.split(searchStr).join(replaceStr);	
		}
	  return str;
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
    		moduleTp = "doc";
    	}
    	
		fnDocViewer(fileId, fileSn, moduleTp);
    }
    
    function fnDocViewer(fileId, fileSn, moduleTp){
		var timestamp = new Date().getTime();
	 	var docViewrPopForm = document.docViewrPopForm;
	 	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
	 	docViewrPopForm.action = "/gw/docViewerPop.do";
	 	docViewrPopForm.target = "docViewerPop" + timestamp ;
	 	docViewrPopForm.groupSeq.value = "${groupSeq}";
	 	docViewrPopForm.fileId.value = fileId;
	 	docViewrPopForm.fileSn.value = fileSn;
	 	docViewrPopForm.moduleTp.value = moduleTp;
	 	docViewrPopForm.submit();     	
    }
    
    function getQueryVariable(fileUrl, strPara) {
        var params = {};
        fileUrl.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str, key, value) { params[key] = value; });
        return params[strPara];
     }
  	function boardFileDownPop(boardNo,fileNm,fileRnm, linkDoc, jobType, fileSeqNo, fileExtsn, optionMap) {
    	var fileNmSub = fileNm;
    	var fileNmTmp = fileNm.substring(fileNm.lastIndexOf("/")+1);
    	var boardNoTmp = fileNmSub.substring(0,fileNmSub.lastIndexOf("/"));
    	boardNoTmp = boardNoTmp.substring(boardNoTmp.lastIndexOf("/")+1);
    	var downUrl = "/edms/board/downloadFile.do?boardNo="+boardNoTmp+"&fileNm="+fileNmTmp+"&fileRnm="+fileRnm+"."+fileExtsn;
    	var url = "<a style='cursor:pointer' onclick='fnFileDownLoad(\"" + downUrl + "\",\"" + fileSeqNo + "\",\"" + jobType + "\",\"" + linkDoc + "\",\"" + fileExtsn + "\",\"" + optionMap.pathSeq300 + "\",\"" + optionMap.pathSeq400 + "\",\"" + optionMap.pathSeq500 + "\",\"" + optionMap.pathSeq600 + "\",\"" + optionMap.pathSeqEa + "\")\'>"+linkDoc+"</a>";
  		return url;
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
	
	    var url = "<c:url value='http://"+location.host+"/project/Views/Common/project/projectView.do?pSeq="+pSeq+"&wSeq="+wSeq+"&jSeq="+jSeq+"&type="+type+"'/>";
	
	    openWindow2(url,  "pop", 1100, 911, 0) ;

    }
  //게시판 페이지이동
  	function boardMove(jobType, catSeq, artSeq) {
  		
  		if(jobType == "board-1" || jobType == "board-3"){
  			var url = "<c:url value='http://"+location.host+"/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq+"'/>";
  		}else if(jobType == "board-2"){
  			var url = "<c:url value='http://"+location.host+"/edms/board/happyPollResultView.do?surveyNo="+catSeq+"'/>";
  		}
  		openWindow2(url,  "pop", 833, 711,"yes", 0) ;
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
  	//노트 페이지이동
  	function noteMove(pkSeq) {
  		var url = "<c:url value='http://"+location.host+"/schedule/Views/Common/note/noteList.do?noteSeq="+pkSeq+"'/>";
  		openWindow2(url,  "pop", 1000, 711, "no", 0) ;
  	}
  	//업무보고 팝업
  	function reportPop(reportSeq, jobType, createSeq, targetEmpSeq, openYn) {
  		var type = "1";
  		if(jobType == "report-2"){
  			type = "2";
  		}
  		
  		var empSeq = '${empSeq}';
  		//console.log("empSeq : "+empSeq);
  		var url = "";
  		
  		if(createSeq == empSeq){ // 보고자면
  			url = "<c:url value='http://"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&type="+type+"&kind=0'/>";
  		}else if(targetEmpSeq == empSeq){ // 보고대상자면
  			url = "<c:url value='http://"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&createEmpSeq="+createSeq+"&loginEmpSeq="+empSeq+"&type="+type+"&kind=1'/>";
  		
  		}else if(openYn == "Y"){ // 공개보고서면
  			url = "<c:url value='http://"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&createEmpSeq="+createSeq+"&loginEmpSeq="+empSeq+"&type="+type+"&kind=3'/>";
  		
  		}else{ // 참조보고서
  			url = "<c:url value='http://"+location.host+"/schedule/Views/Common/report/reportInfoPop.do?reportSeq="+reportSeq+"&createEmpSeq="+createSeq+"&loginEmpSeq="+empSeq+"&type="+type+"&kind=2'/>";
  		
  		}
  		

  		openWindow2(url,  "pop", 1000, 711, 1) ;
  	}
  	//게시판 페이지이동
  	function boardMove(jobType, catSeq, artSeq) {
  		
  		if(jobType == "board-1" || jobType == "board-3"){
  			var url = "<c:url value='http://"+location.host+"/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq+"'/>";
  		}else if(jobType == "board-2"){
  			var url = "<c:url value='http://"+location.host+"/edms/board/happyPollResultView.do?surveyNo="+catSeq+"'/>";
  		}
  		openWindow2(url,  "pop", 833, 711,"yes", 0) ;
  	}
  	//문서 페이지이동
  	function edmsMove(wDirCd, artSeqNo) {
  		var url = "<c:url value='http://"+location.host+"/edms/doc/viewPost.do?dir_cd="+wDirCd+"&dir_lvl=3&dir_type=W&currentPage=1&artNo="+artSeqNo+"&dirMngYn=N&hasRead=Y&hasWrite=Y&searchField=&searchValue=&startDate=&endDate='/>";
  		openWindow2(url,  "pop", 1000, 711, "yes", 0) ;
  	}
  	//전자결재(영리) 팝업
  	function eapPop(docSeq, formId, migYn, eaType) {
  		var url = "";
  		if(eaType == "ea"){
  			if(migYn == "1"){
  				docSeq = docSeq.replace("mig_","");
  				url = "<c:url value='http://"+location.host+"/ea/ea/docpop/EAAppDocMigPop.do?doc_id="+docSeq+"'/>";
  			}else{
  				url = "<c:url value='http://"+location.host+"/ea/edoc/eapproval/docCommonDraftView.do?diKeyCode="+docSeq+"'/>";
  			}
  			
  		}else{
  			if(migYn == "1"){
  				docSeq = docSeq.replace("mig_","");
  				url = "<c:url value='http://"+location.host+"/eap/ea/docpop/EAAppDocMigPop.do?doc_id="+docSeq+"'/>";
  			}else{
  				url = "<c:url value='http://"+location.host+"/eap/ea/docpop/EAAppDocViewPop.do?doc_id="+docSeq+"&form_id="+formId+"'/>";
  			}
  		}

  		openWindow2(url,  "pop", 1000, 711, "yes",0);
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
  	function fnGetWeek(getDateVal){
  		var now = new Date(getDateVal).getDay();
  		var weekName = new Array('<%=BizboxAMessage.getMessage("TX000005656","일")%>','<%=BizboxAMessage.getMessage("TX000005657","월")%>','<%=BizboxAMessage.getMessage("TX000005658","화")%>','<%=BizboxAMessage.getMessage("TX000005659","수")%>','<%=BizboxAMessage.getMessage("TX000005660","목")%>','<%=BizboxAMessage.getMessage("TX000005661","금")%>','<%=BizboxAMessage.getMessage("TX000005662","토")%>');
  		
  		return getDateVal+"("+weekName[now]+")";
  	}
  	//일정 페이지이동
  	function scheduleMove(pkSeq1, pkSeq2) {
  		var url = "<c:url value='http://"+location.host+"/schedule/Views/Common/mCalendar/detail?seq="+pkSeq2+"'/>";
  		openWindow2(url,  "pop", 833, 711,"yes", 0);
  	}
  	//메일함 분류
    function fnMainInBoxNameReturn(v) {
		
    	if(v == "INBOX"){
    		v = "<%=BizboxAMessage.getMessage("TX000001580","받은편지함")%>";
    	}else if(v == "SENT"){
    		v = "<%=BizboxAMessage.getMessage("TX000001581","보낸편지함")%>";
    	}
    	
   		return v;
   	}
  	//메일 페이지이동
  	function mailMove(emailAddr, muid, mailUrl) {
  		var gwDomain = window.location.host + (window.location.port == "" ? "" : (":" + window.location.port));
  		var url = "<c:url value='"+mailUrl+"/readMailPopApi.do?gwDomain=" + gwDomain + "&email="+emailAddr+"&muid="+muid+"'/>";
  		openWindow2(url,  "pop", 1000, 711, "yes",0);
  	}
  	//하이라이트 적용 처리.
  	function searchKeywordHighlight(){
  		
  		var keywordList = [];
		var replaceKeyword = $("#tsearchKeyword").val();
		if(replaceKeyword.indexOf(" ") > -1){
			keywordList = replaceKeyword.split(" ");
			for(var i = 0; i < keywordList.length ; i++){
				$('.sr_con').highlight(keywordList[i]);
				
	  		}
		}else{
			$('.sr_con').highlight(replaceKeyword);
			
		}
  	}
  	//인물검색_활동보기 클릭시 
  	function getTotalSearchHr(str,hrEmpSeq){
  		/* formTotal.hrEmpSeq.value = hrEmpSeq;
  		getTotalSearch(str, false); */
  		//TODO 인물_활동보기 이동처리 개발 필요
  		alert("인물_활동보기 이동처리 개발 필요[" + boardType + "]");
  	}
  	//통합검색 조회 가능 여부
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
  	//TODO 연관 링크 조회
  	function getRelatedLink(valStr, flatData){
  		$.ajax({ 
			type:"GET",
			url: '<c:url value="/ebp/portalView/getRelatedLink.do"/>',
			datatype:"json",
			async: true,
			data:{
				"searchWord": valStr,
				"count": relatedLinkCount 
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					//1. flatData 연관링크 관련 생성
					for(var i=0;i<data.result.length;i++){
						var row = data.result[i];
						var boardType = "related_link" + i;
						flatData.push({text: row.id + '(0)', name: boardType, count: 0, onlyText: row.id})
						//2. 가져온 데이터로  KendoTreeView의 검색 건수 및 화면상의 검색 건수 갱신
						modifyModuleCount({'totalcount': data.result.length}, boardType, true, flatData);
						//3. 가져온 데이터로 화면 다시 그리기.
						refreshRelatedLinkResult(row, boardType);
					}
					
				}else if(data.resultCode!="LOGIN004"){
					//alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");	
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						//window.parent.location.href = "/gw/userMain.do";
						window.parent.dews.app.overlay.hide();
					}
				}
				
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});
  	}
  	//연관 링크 화면 갱신
  	function refreshRelatedLinkResult(data, boardType){
		//최상위 div innerHtml 생성
		createRootDivInnerHtml(data, boardType, true); 
		//삽입
		var innerHtml = '<a href="' + data.url + '" target="_blank">' + data.url + '(연계 시스템 정의후 개발필요)</a>';
		$("#result_module_" + boardType).append(innerHtml);
  	}
  	Date.prototype.yyyymmdd = function() {
  	  var mm = this.getMonth() + 1; // getMonth() is zero-based
  	  var dd = this.getDate();

  	  return [this.getFullYear(),
  	          (mm>9 ? '' : '0') + mm,
  	          (dd>9 ? '' : '0') + dd
  	         ].join('');
  	};
  	Date.prototype.mmddDayOfWeek = function() {
 	  var week = ['일', '월', '화', '수', '목', '금', '토'];
      var dayOfWeek = week[this.getDay()];

   	  var mm = this.getMonth() + 1; // getMonth() is zero-based
   	  var dd = this.getDate();

   	  return [(mm>9 ? '' : '0') + mm, '.',(dd>9 ? '' : '0') + dd, '(', dayOfWeek, ')'].join('');
   	};
   	function fnMoneyTypeReturn(v) {
	 var reg = /(^[+-]?\d+)(\d{3})/;
	  v += '';

	  while (reg.test(v))
	    v = v.replace(reg, '$1' + ',' + '$2');

	  return v;
	}
	</script>
    <title>KLAGO</title>
</head>
<body>
	<div id="searchWrap" style="transform:translateY(0%);">
		<!-- 검색 헤더 -->
		<div class="searchHeader">
			<div class="logo">
				<img src="/gw/ebp/Images/portalview/logo_klago.png">
			</div>
			<div class="search_util">
				<div class="user_profile">
					<div class="pic_div"><img src="/gw/ebp/Images/portalview/temp_pic.png" alt=""></div>
					<span class="user_info">(주)더존비즈온-홍길동 사원</span>
				</div>
				<ul class="util_btn">
					<li><a href="javascript:void(0)" class="menu"></a></li>
					<li>
						<a href="javascript:void(0)" class="alert" style="position:relative;">
							<div class="puddSetup" pudd-type="badge" pudd-badge-type="limit" pudd-badge-limitCount="99" pudd-badge-content="123" pudd-badge-align="floatRight" pudd-badge-size="small" pudd-badge-style="background:#fc5356;"></div>
						</a>
					</li>					
				</ul>
			</div>
		</div>
		
		<!-- 검색입력단 -->
		<div class="searchBox animated1s fadeInUp">
			<input id="searchText" type="text" pudd-style="position:relative;width: 500px;height: 56px;z-index:1;" style="color: #000000;font-size: 18px;font-family: NSR !important;font-weight: bold;padding: 0 80px 0 22px;border: none;border-radius: 56px;outline: none;background: rgba(255,255,255,0.91);box-shadow:0px 5px 10px rgba(0,0,0,0.2);-webkit-box-shadow:0px 5px 10px rgba(0,0,0,0.2);-moz-box-shadow:0px 5px 10px rgba(0,0,0,0.2);" class="puddSetup inpBox" placeholder="통합검색" />
			<a href="javascript:void(0)" class="reset_btn"></a>
			<a href="javascript:void(0)" class="search_btn"></a>
			<div id="autoText" class="autoText freebScrollY"></div>
		</div>
		
		<!-- 최근검색어 -->
		<div class="lately_keyword">
			<dl>
				<dt>최근검색어</dt>
				<div id="recentWordArea">
				
				</div>
			</dl>
		</div>
		
		<!-- 알림상세  li class
			.ea 전자결재
			.ma 메일        
			.sc 일정     
			.wk 업무관리   
		-->
		<div class="alertBox_detail freebScrollY">
			<ul>
				<li class="ea" id="eaDetail">
					<dl></dl>
				</li>
				<li class="sc" id="scDetail">
					
				</li>
				<li class="ma" id="mlDetail">
					
				</li>
				<li class="wk" id="prDetail">
					<dl>
						<dt><a href="javascript:void(0)">업무관리 진행중인 업무가 2건 있습니다.</a></dt>
						<dd><a href="javascript:void(0)">업무관리 KISS 개발중</a></dd>
						<dd><a href="javascript:void(0)">오늘마감 [남아프리카공화국 가나다라상사 Alpha구축] 모바일버튼 검수진행 및 디자인 수정</a></dd>
					</dl>
				</li>
			</ul>
		</div>
		
		<!-- 알림리스트 li class
			.ea 전자결재
			.ma 메일        
			.sc 일정     
			.wk 업무관리   
			.bd 게시판    
			.ds 인사근태   
			.dc 문서
		-->
		<div class="alertBox_list freebScrollY">
			<ul>
				<li class="ea">
					<a href="javascript:moveMenu('EA','2002020000')">
						<%=BizboxAMessage.getMessage("TX000000479","전자결재")%><span class="cnt"><b id="eaCnt">0</b>건</span>
					</a>
				</li>
				<li class="sc">
					<a href="javascript:moveModule('CL',true)">
						<%=BizboxAMessage.getMessage("TX000000483","일정")%><span class="cnt"><b id="scCnt">0</b>건</span>
					</a>
				</li>
				<li class="ma">
					<a href="javascript:moveMenu('ML','51')">
						<%=BizboxAMessage.getMessage("TX000000262","메일")%><span class="cnt"><b id="mlCnt">0</b>건</span>
					</a>
				</li>
				<li class="wk">
					<a href="javascript:void(0)">
						<%=BizboxAMessage.getMessage("TX000010151","업무관리")%><span class="cnt"><b id="prCnt">2</b>건</span>
					</a>
				</li>
			</ul>
		</div>
		
		<!-- 최근사용 모듈 li class
			.ea 전자결재
			.ma 메일
			.sc 일정
			.wk 업무관리
			.bd 게시판
			.ds 인사근태
			.at 회계
			.dc 문서
			.mp 마이페이지
			.et 확장기능
			.of 원피스
			.st 시스템설정
			.ec 전자계약
			.sf 스마트자금관리
		-->
		<div class="lately_use">
			<ul id="moduleList">
				
			</ul>
			<a href="javascript:void(0)" class="full_btn"></a>
		</div>
		
		<!-- copylight -->
		<div class="copy">Copyright &copy; 2019 DOUZONE ICT Group All rights reserved.</div>
		
		<!-- 결과 -->
		<div class="searchResult" style="display:none">
			<div class="srWrap">
				<div class="unitbox1">
					<div class="tit">
						<b>메뉴</b>
						<span class="line">|</span>
						총 <span id="menuCnt" class="cnt">0</span><%=BizboxAMessage.getMessage("","건이 검색되었습니다.")%>
					</div>
					<div id="noMenuList" class="nonSearch" style="display:none"><%=BizboxAMessage.getMessage("TX000007470","검색 결과가 없습니다.")%></div>
					<div class="srCon01 freebScrollY"></div>
				</div>
				<div class="unitbox2">
					<div class="tit">
						<b>연관컨텐츠</b>
						<span class="line">|</span>
						총 <span class="cnt" id="relatedTotalCount">0</span><%=BizboxAMessage.getMessage("","건이 검색되었습니다.")%>
					</div>
					<div class="srCon02 freebScrollY">
						<div class="nonSearch" id="relatedNoResult" style="display:none"><%=BizboxAMessage.getMessage("TX000007470","검색 결과가 없습니다.")%></div>
						<!-- 연관컨텐츠 퍼블리싱 필요구간 -->
						<div class="sr_list">
						
						</div><!-- // sr_list 끝 -->
						<!-- // -->
					</div>
				</div>
				<div class="unitbox3">
					<div class="srCon03 freebScrollY">
						<div class="tit">
							<b><%=BizboxAMessage.getMessage("","연관검색어")%></b>
						</div>
						<ul id="relatedWordArea" class="RelatedSearches">
							
						</ul>
						
						<div class="tit">
							<b><%=BizboxAMessage.getMessage("","연관메뉴")%></b>
						</div>
						<ul id="relatedMenuArea" class="RelatedMenu">
							
						</ul>
					</div>
				</div>
			</div>
		</div>
		<!-- portal view btn -->
		<div id="portalview_btn" class="portalview_btn up"></div>
		
		<!-- 사용자정보 팝업 -->
		<div id="" class="user_profile_pop">
			<div class="user_pic">
				<img src="/gw/ebp/Images/portalview/temp_pic.png" alt="">
			</div>
			<div class="user_name">
				<span class="name">홍길동</span>
				<span class="grade">사원</span>
			</div>
			<div class="user_buttons">
				<a id="user_info" href="#">내 정보 설정</a>
				<span>|</span>
				<a id="ch_password" href="#">비밀번호 변경</a>
            </div>
			<div class="user-status-change user_company">
				<select class="puddSetup" pudd-style="width: 200px;margin: 12px 0 0 20px;">
					<option value="더존비즈온">더존비즈온</option>
					<option value="아이텍스넷">아이텍스넷</option>
				</select>
			</div>
			<div class="user-status-change user_group">
				<select class="puddSetup" pudd-style="width: 200px;margin: 12px 0 0 20px;">
					<option value="ERP관리자(GERP)">ERP관리자(GERP)</option>
					<option value="기술개발그룹">기술개발그룹</option>
				</select>
			</div>
			<div class="user-status-change user_language">
				<select class="puddSetup" pudd-style="width: 200px;margin: 12px 0 0 20px;">
					<option value="한국어">한국어</option>
					<option value="영어">영어</option>
					<option value="중국어">중국어</option>
					<option value="일본어">일본어</option>
				</select>
			</div>
			<div class="user-status-change user_timezone">
				<select class="puddSetup" pudd-style="width: 200px;margin: 12px 0 0 20px;">
					<option value="(GMT-09:00) America/Metlakatla">(GMT-09:00) America/Metlakatla</option>
					<option value="(GMT+03:00) Asia/Kuwait">(GMT+03:00) Asia/Kuwait</option>
					<option value="(GMT+07:00) Asia/Vientiane">(GMT+07:00) Asia/Vientiane</option>
					<option value="(GMT+02:00) Asia/Beirut">(GMT+02:00) Asia/Beirut</option>
				</select>
			</div>			
			<div class="user-status-change user_font_size">
				<div class="title">글꼴크기</div>
				<div class="change_font">
					<input type="button" class="puddSetup" value="-" pudd-style="width:24px;" style="padding:3px 0 5px 0; line-height: 1em;"/>
					<span id="changeFontSize">12px</span>
					<input type="button" class="puddSetup" value="+" pudd-style="width:24px;" style="padding:3px 0 5px 0; line-height: 1em;"/>
				</div>
			</div>
			<div class="app_info">
				<ul>
					<li>
  						<label>라이센스 기간</label>
							<span id="ch_license">2017.01.01 ~ 2017.12.31</span>
					</li>
					<li>
  						<label>프로그램 버전</label>
							<span id="ch_version">Ver.20190618</span>
					</li>
  				</ul>
			</div>
			<div class="bottom_buttons">
				<input type="button" class="apply puddSetup" value="변경적용" pudd-style="" style=" padding: 0 19px; height: 32px; font-size: 15px;"/>
				<input type="button" class="logout puddSetup" value="로그아웃" pudd-style="" style=" padding: 0 19px; height: 32px; font-size: 15px;"/>
			</div>
		</div>
	</div>
	<div id="" class="downfile_sel_pop posi_fix" style="top:133px;left:690px; display: none;" onmouseleave="fnMouseOut();">
	   	<ul>
	   		<li><a href="#n" onclick="fnFileDirectDown();"><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a></li>
	   		<li><a href="#n" onclick="fnFileViewerPop();"><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a></li>
	   	</ul>
	</div>
<form id="formTotal" name="formTotal">  
<input type="hidden" id="tsearchKeyword" name="tsearchKeyword" value="" /> <!-- 메인 키워드 -->
<input type="hidden" id="tsearchSubKeyword" name="tsearchSubKeyword" value="" /> <!-- 상세검색 키워드 -->
<input type="hidden" id="boardType" name="boardType" value="1" /> <!-- 레프트메뉴 구분 : 전체-->
<input type="hidden" id="listType" name="listType" value="" /> <!-- 목록 구분 -->
<input type="hidden" id="listTypes" name="listTypes" value="" /> <!-- 조회된 개별 모듈 이외에 카운트 조회시 조회할 모듈들 (ex>7,8) -->
<input type="hidden" id="fromDate" name="fromDate" value="" /> <!-- 검색 시작 일자 -->
<input type="hidden" id="toDate" name="toDate" value="" /> <!-- 검색 종료 일자 -->
<input type="hidden" id="dateDiv" name="dateDiv" value="" /> <!-- 기간선택, 임의선택 여부 -->
<input type="hidden" id="detailSearchYn" name="detailSearchYn" value="N" /> <!-- 상세검색 ON/OFF 여부 (Y/N) -->
<input type="hidden" id="selectDiv" name="selectDiv" value="S"/> <!-- 기간선택값 -->
<input type="hidden" id="orderDiv" name="orderDiv" value="B"/> <!-- 정렬구분 -->
<input type="hidden" id="pageIndex" name="pageIndex" value="1"/> <!-- 페이징처리 -->
<input type="hidden" id="hrSearchYn" name="hrSearchYn" value="N"/> <!-- 인물 검색 여부 -->
<input type="hidden" id="hrEmpSeq" name="hrEmpSeq" value=""/> <!-- 인물 검색 선택된 empSeq -->
</form>

<form id="docViewrPopForm" name="docViewrPopForm" method="post">
    <input type="hidden" name="groupSeq" />
    <input type="hidden" name="fileId" />
    <input type="hidden" name="fileSn" />
    <input type="hidden" name="moduleTp" />
    <input type="hidden" name="pathSeq" />
    <input type="hidden" name="inlineView" value="Y" />
</form>

</body>
</html> 