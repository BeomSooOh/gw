<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
   
    <!--css-->
	<link rel="stylesheet" type="text/css" href="/gw/js/portlet/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="/gw/css/common.css?ver=20201021">
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/animate.css">
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/pudd.css?ver=20201021">
	<!-- link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/portlet.css?ver=20201021">  -->
	<script type="text/javascript" src="/gw/js/portlet/Scripts/pudd/pudd-1.1.11.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/gw/ebp/css/portlet.css">

    <!--js-->
    <script type="text/javascript" src="/gw/js/portlet/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/portlet/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="/gw/js/portlet/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common.js?ver=20201021"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common_freeb.js?ver=20201021"></script>
    <script type="text/javascript" src="/gw/js/Highcharts-6.1.0/highcharts.js"></script>
    
    <!-- mCustomScrollbar -->
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.css">
    <script type="text/javascript" src="/gw/js/portlet/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>
    
    <script>
    
		var langCode = '${loginVO.langCode}';
		var eaType = '${loginVO.eaType}';	
		var portletSizeInfo = {
			info: [],
			length: ''
		};
    	var selectedPortlet;
    	var newPortletKey = 0;
    	var chartObject = {};
    	
    	//날씨 API 키 변수 
    	var weatherApiKey = '${weatherApiKey}';
    
		$(document).ready(function () {
			
		    gridHeight();
		    portletList();
		    $(window).resize(function(){
		    	gridHeight();
		    	portletList();
		    	
		    	//포틀릿 리스트 사이즈 변동이 생기면 함수실행
			    var poplist = $(".portletList").width();
			    var nowlist = "";
			    
			    if(nowlist != poplist){
			    	nowlist = poplist;
			    	portletList();
			    	
			    };
			    
		    });
		    
		    initPortletSizeInfo();
		    
		    $(document).on('mouseup',function(){
				//포틀릿이 신규로 추가되었을 때 포틀릿 사이즈 변수를 초기화 한다.
		    	if($(".portletLayer").length !== portletSizeInfo.length){
		    		initPortletSizeInfo();
		    	}
				
				var sizeCheck = checkPortletSize();
				console.log(sizeCheck);
				//포틀릿 사이즈가 변경되었는지 확인
		    	if(sizeCheck !== null){
		    		reDrawChart(sizeCheck);
		    	}
		    });
		    
		    $(document).on('mousedown',function(e){
		    	console.log(e);
		    });
		   
		});
		
		function createPortletSize() {
			var arr = [];
			
			$(".portletLayer").each(function(index, item){
		    	var rowIndex = $(item).attr('class').indexOf('row');
		    	var colIndex = $(item).attr('class').indexOf('col');
		    	
		    	var obj = {
		    		portletTp: $(item).attr('portlettp'),
		    		col: $(item).attr('class')[rowIndex + 3],
		    		row: $(item).attr('class')[colIndex + 3]
		    	}
		    	
		    	arr.push(obj);
		    });
			
			return arr;
		}
		
		function initPortletSizeInfo() {
			
			portletSizeInfo.info = createPortletSize();					    
		    portletSizeInfo.length = $(".portletLayer").length;
		    
		}
		
		function checkPortletSize() {
			var newPortletSize = createPortletSize();
			var resultPortletTp = null;
			
			if(portletSizeInfo.info) {
				portletSizeInfo.info.forEach(function(item, index, array){
					var prevItem = item;
					var prevItemIndex = index;
					var prevArray = array;
					newPortletSize.forEach(function(item, index, array){
						if(item.portletTp === prevItem.portletTp){
							if(item.col !== prevItem.col || item.row !== prevItem.row) {
								resultPortletTp = item.portletTp;
								// 포틀릿 사이즈 정보를 업데이트 해준다. 
								prevArray[prevItemIndex] = item;
							}
						}
					});
				});
				return resultPortletTp;
			}				
		}
		
		function reDrawChart(portletTp){
			var chartContainer = "#" + portletTp + 'Container';
			console.log(chartContainer);
			/*
			chartObject[portletTp].chart.update({
				chart: {
					height: getChartContainerSize(chartContainer).height
				}
			});
			*/
			chartObject[portletTp].chart.destroy();
			
			var targetDiv = $("div[portlettp=" + portletTp + "]");
			
			var callFunc = eval("drawChart_" + portletTp);
			
			callFunc(null, targetDiv, null);
		}

		function gridHeight(){
			var popWidth = $(window).outerWidth(true);
			var popHeight = $(window).outerHeight(true);
			var popHead = $(".pop_head").outerHeight(true);
			$(".portletGridWrap").width(popWidth-34).height(popHeight-(popHead+140));
		};
		
		function portletList(){
			var popWidth = $(window).outerWidth(true);
			var liSize = $(".portletList ul li").size();
			var liWidth = $(".portletList ul li").outerWidth(true);
			var listWidth = ( liSize * liWidth ) + 116;
			var poplist = $(".portletList").width();
			
			if(poplist < listWidth){
				$(".portletList").addClass("insize").width(popWidth-116);
			}else{
				$(".portletList").removeClass("insize").width(popWidth-32);	
			};
		};
    </script>

    <script>
		// configCallback 함수
		var configCallback = function( portlet ) {

			var boxType = portlet.boxType;

			var config = {};

			if( "portletTemplete_iframe_outer" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 20;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "iframe";
				config.allowDuplicate = true;

			} else if( "portletTemplete_iframe_quick" == boxType ) {

				config.defaultRow = 1;
				config.defaultCol = 10;
				config.maxRow = 1;
				config.maxCol = 10;
				config.minRow = 1;
				config.minCol = 10;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000016104","퀵링크")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_mybox" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 2;
				config.maxCol = 2;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000016693","내정보")%>";
				config.allowDuplicate = false;

			} else if( "portletTemplete_board" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "공지사항";
				config.allowDuplicate = true;

			} else if( "portletTemplete_mail_status" == boxType ) {

				config.defaultRow = 1;
				config.defaultCol = 2;
				config.maxRow = 1;
				config.maxCol = 10;
				config.minRow = 1;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000022828","메일현황")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_inbox" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000001580","받은편지함")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_calendar_horizontal" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 2;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더")%>(<%=BizboxAMessage.getMessage("","가로형")%>)";
				config.allowDuplicate = true;

			} else if( "portletTemplete_calendar_vertical" == boxType ) {

				config.defaultRow = 4;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 2;
				config.minRow = 4;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더")%>(<%=BizboxAMessage.getMessage("","세로형")%>)";
				config.allowDuplicate = true;

			} else if( "portletTemplete_notice" == boxType ) {

				config.defaultRow = 4;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 4;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000021503","통합알림")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_assetGrowthIndex" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "자산성장성지표";
				config.allowDuplicate = true;

			} else if( "portletTemplete_inventoryStatus" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 4;
				config.minCol = 2;
				config.boxTitle = "재고현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_wehagoService" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 4;
				config.minCol = 2;
				config.boxTitle = "WEHAGO 서비스";
				config.allowDuplicate = true;

			} else if( "portletTemplete_salesPerformance" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "매출실적현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_bpNetProfit" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "경영실적[당기순이익]";
				config.allowDuplicate = true;

			} else if( "portletTemplete_totalFundStatus" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 6;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 6;
				config.boxTitle = "총자금현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_boundAgeStatus" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "채권연령현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_annualUseManage" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "임직원 연차사용관리";
				config.allowDuplicate = true;

			} else if( "portletTemplete_weekWorkingHours" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "금주 근무시간";
				config.allowDuplicate = true;

			} else if( "portletTemplete_myWorkStatus" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "나의 근무현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_overTimeApplication" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "연장근무신청";
				config.allowDuplicate = true;

			} else if( "portletTemplete_workingStatus" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "근무현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_etcBox" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "기타 컨테이너박스";
				config.allowDuplicate = true;

			} else if( "portletTemplete_board_hr" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "공지사항";
				config.allowDuplicate = true;

			} else if( "portletTemplete_requestJob" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "업무요청";
				config.allowDuplicate = true;

			} else if( "portletTemplete_expectedSpendToday" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "금일 주요 지출예정";
				config.allowDuplicate = true;

			} else if( "portletTemplete_divExpenseClaim" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "부서별 경비청구 진행률";
				config.allowDuplicate = true;

			} else if( "portletTemplete_accountingEaProgress" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "회계결재 진행현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_mainAccountionTask" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "주요 회계업무";
				config.allowDuplicate = true;

			} else if( "portletTemplete_myCardUsageHistory" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 4;
				config.minCol = 2;
				config.boxTitle = "나의카드 사용내역";
				config.allowDuplicate = true;

			} else if( "portletTemplete_salesByDepartment" == boxType ) {
								
				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "부서별 판매실적";
				config.allowDuplicate = true;

			} else if( "portletTemplete_salesTrend" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 4;
				config.minCol = 2;
				config.boxTitle = "매출액 추이";
				config.allowDuplicate = true;

			} else if( "portletTemplete_salesStatus" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "매출현황";
				config.allowDuplicate = true;

			} else if( "portletTemplete_monthlySalesPerformance" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "월간판매실적";
				config.allowDuplicate = true;

			} else if( "portletTemplete_inboxCeo" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "받은편지함";
				config.allowDuplicate = true;

			} else {

				return null;
			}

			return config;
		};
		
		// portlet setting html 구성
		var portletSettingDiv = function( portlet ) {
			
			var boxType = portlet.boxType;
			var boxTitle = portlet.boxTitle;
			var div = portlet.div;// 포틀릿 div 객체
			// div > div ( .setting )
			var divSettingTag = document.createElement( "div" );
			divSettingTag.className = "setting";
			div.appendChild( divSettingTag );

			// div > div ( .setting ) > div ( .ptl_info )
			var divInfoTag = document.createElement( "div" );
			divInfoTag.className = "ptl_info";
			divSettingTag.appendChild( divInfoTag );

			// div > div ( .setting ) > div ( .ptl_info ) > a ( .set_btn )
			//if(boxType != "portletTemplete_notice"){
			if(false) {
				var aRegTag = document.createElement( "a" );
				aRegTag.className = "set_btn";
				aRegTag.title = "<%=BizboxAMessage.getMessage("TX000000602","등록")%>";
				aRegTag.style.cursor = "pointer";
				divInfoTag.appendChild( aRegTag );
				
				// div > div ( .setting ) > div ( .ptl_info ) > a ( .set_btn ) - click event
				$( aRegTag ).on( "click", function() {
					var divObj = Pudd( div ).getPuddObject();
					selectedPortlet = divObj;
					
					url = "portletCloudSetPop.do?portalId=&boxType=" + boxType + "&portletKey=" + divObj.portletKey;
					openWindow2(url, "portletSetPop", 602, 602, 1, 1);
				});				
			}

			// div > div ( .setting ) > div ( .ptl_info ) > span ( .name )
			var spanTag = document.createElement( "span" );
			spanTag.className = "name";
			spanTag.textContent = ( boxTitle ? boxTitle : "<%=BizboxAMessage.getMessage("TX000009480","타이틀")%>" );
			divInfoTag.appendChild( spanTag );

			// div > div ( .setting ) > a ( .del_btn )
			var aDelTag = document.createElement( "a" );
			aDelTag.className = "del_btn";
			aDelTag.title = "<%=BizboxAMessage.getMessage("TX000019680","삭제")%>";
			aDelTag.style.cursor = "pointer";
			divSettingTag.appendChild( aDelTag );

			// div > div ( .setting ) > a ( .del_btn ) - click event
			$( aDelTag ).on( "click", function() {

				var portletObj = Pudd( "#portlet" ).getPuddObject();
				portletObj.removePortlet( div );
			});
		};
		
		// portletCallback 함수
		var portletCallback = function( portlet ) {
			
			var boxType = portlet.boxType;
			var boxTitle = portlet.boxTitle;
			var div = portlet.div;// 포틀릿 div 객체

			if( "portletTemplete_iframe_outer" == boxType ) {

				$( div ).addClass( "iframeBox" );

			} else if( "portletTemplete_iframe_banner" == boxType ) {

				$( div ).addClass( "iframeBox" );

			} else if( "portletTemplete_iframe_quick" == boxType ) {

				$( div ).addClass( "iframeBox" );

			} else if( "portletTemplete_mybox" == boxType ) {

				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_board" == boxType ) {

				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_mail_status" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_inbox" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_calendar_horizontal" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_calendar_vertical" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_notice" == boxType ) {

				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_task_status" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_assetGrowthIndex" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_inventoryStatus" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_wehagoService" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_salesPerformance" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_bpNetProfit" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_totalFundStatus" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_boundAgeStatus" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_annualUseManage" == boxType ) {
				
				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_weekWorkingHours" == boxType ) {
				
				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_myWorkStatus" == boxType ) {
				
				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_overTimeApplication" == boxType ) {
				
				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_workingStatus" == boxType ) {
				
				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_etcBox" == boxType ) {
				
				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_board_hr" == boxType ) {
				
				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_requestJob" == boxType ) {

				$( div ).addClass( "titleBox" );
			
			} else if( "portletTemplete_expectedSpendToday" == boxType ) {
				
				$( div ).addClass( "titleBox" );
				
			} else if( "portletTemplete_divExpenseClaim" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_accountingEaProgress" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_mainAccountionTask" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_myCardUsageHistory" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_salesByDepartment" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_salesTrend" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_salesStatus" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_monthlySalesPerformance" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_inboxCeo" == boxType ) {

				$( div ).addClass( "portletBox" );

			} else {
				return;
			}
			
			var getPuddObject = Pudd( div ).getPuddObject();
			var portletInfo = getPuddObject.portletInfo;
			var portletKey = getPuddObject.portletKey;
			
			if(portletInfo == null){
				//기초값 세팅(신규추가)
				$( div ).html( $( "#demo_" + boxType ).val() );
				getPuddObject.portletInfo = portletSetDefaultInfo(boxType);
			}else{
				//기존값 세팅(기존포틀릿)
				fnPortletRender(boxType, portletInfo, portlet.div, portletKey);
			}
			
			portletSettingDiv( portlet );
		};
		
		var portletSetDefaultInfo = function(boxType) {
			
 			var optionInfo = {};
 			optionInfo.useYn = "Y";
 	    	optionInfo.port_name_cn = "";
 	    	optionInfo.port_name_jp = "";
 	    	optionInfo.port_name_en = ""; 	

			if( "portletTemplete_mybox" == boxType ) {
				
				optionInfo.port_name_kr = "내정보";
				optionInfo.displayOption = "all";
				optionInfo.val01 = "Y";
				optionInfo.val02 = "Y";
				optionInfo.val03 = "N";

			} else if( "portletTemplete_inbox" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000001580","받은편지함","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000001580","받은편지함","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000001580","받은편지함","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000001580","받은편지함","cn")%>";
				optionInfo.useYn = "Y";
				optionInfo.val0 = "0";
				optionInfo.val1 = "Y";
				optionInfo.val2 = "10";				

			} else if( "portletTemplete_calendar_horizontal" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","cn")%>";
				optionInfo.val0 = "Y";
				optionInfo.val1 = "Y";
				optionInfo.val2 = "Y";				

			} else if( "portletTemplete_calendar_vertical" == boxType ) {

				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더","cn")%>";
				optionInfo.val0 = "Y";
				optionInfo.val1 = "Y";
				optionInfo.val2 = "Y";					

			} else if( "portletTemplete_iframe_banner" == boxType ) {

				optionInfo.port_name_kr = "배너";
				optionInfo.val0 = "3000";
				optionInfo.val1 = "1000";
				optionInfo.val2 = "fade";
				optionInfo.val3 = "true";
				optionInfo.val4 = "Y";				

			} else if( "portletTemplete_iframe_quick" == boxType ) {

				optionInfo.port_name_kr = "퀵링크";
				optionInfo.val0 = "3000";
				optionInfo.val1 = "left";				

			} else if( "portletTemplete_assetGrowthIndex" == boxType ) {

				optionInfo.port_name_kr = "자산성정성지표";		

			} else if( "portletTemplete_inventoryStatus" == boxType ) {
				
				optionInfo.port_name_kr = "재고현황";		

			} else if( "portletTemplete_bpNetProfit" == boxType ) {
				
				optionInfo.port_name_kr = "경영실적[당기순이익]";		

			} else if( "portletTemplete_boundAgeStatus" == boxType ) {
				
				optionInfo.port_name_kr = "채권연령현황";		

			} else if( "portletTemplete_salesPerformance" == boxType ) {
				
				optionInfo.port_name_kr = "매출실적현황";		

			} else if( "portletTemplete_annualUseManage" == boxType ) {
				
				optionInfo.port_name_kr = "임직원 연차사용관리";		

			} else if( "portletTemplete_weekWorkingHours" == boxType ) {
				
				optionInfo.port_name_kr = "금주 근무시간";		

			} else if( "portletTemplete_myWorkStatus" == boxType ) {
				
				optionInfo.port_name_kr = "나의 근무현황";		

			} else if( "portletTemplete_overTimeApplication" == boxType ) {
				
				optionInfo.port_name_kr = "연장근무신청";		

			} else if( "portletTemplete_workingStatus" == boxType ) {
				
				optionInfo.port_name_kr = "근무현황";		

			} else if( "portletTemplete_etcBox" == boxType ) {
				
				optionInfo.port_name_kr = "기타 컨테이너";		

			} else if( "portletTemplete_board_hr" == boxType ) {
				
				optionInfo.port_name_kr = "공지사항";		

			} else if( "portletTemplete_requestJob" == boxType ) {

				optionInfo.port_name_kr = "업무요청";
			
			} else if( "portletTemplete_expectedSpendToday" == boxType ) {
				
				optionInfo.port_name_kr = "금일 주요 지출예정";
				
			} else if( "portletTemplete_divExpenseClaim" == boxType ) {

				optionInfo.port_name_kr = "부서별 경비청구 진행률";

			} else if( "portletTemplete_accountingEaProgress" == boxType ) {

				optionInfo.port_name_kr = "회계결재 진행현황";

			} else if( "portletTemplete_mainAccountionTask" == boxType ) {

				optionInfo.port_name_kr = "주요 회계업무";

			} else if( "portletTemplete_myCardUsageHistory" == boxType ) {

				optionInfo.port_name_kr = "나의카드 사용내역";		
				
			} else if( "portletTemplete_salesByDepartment" == boxType ) {

				optionInfo.port_name_kr = "부서별 사용내역";	
				
			} else if( "portletTemplete_salesTrend" == boxType ) {

				optionInfo.port_name_kr = "매출액 추이";	
				
			} else if( "portletTemplete_salesStatus" == boxType ) {

				optionInfo.port_name_kr = "매출현황";
				
			} else if( "portletTemplete_monthlySalesPerformance" == boxType ) {

				optionInfo.port_name_kr = "월간판매실적";
				
			} else if( "portletTemplete_inboxCeo" == boxType ) {

				optionInfo.port_name_kr = "받은편지함";
				
			} else {
				return null;
			}
			
			return optionInfo;
			
		};
		
		// portletSetCallback 함수
		var portletSetCallback = function(optionInfo, weatherApiKey) {
			selectedPortlet.portletInfo = JSON.parse(optionInfo);
			selectedPortlet.boxType = selectedPortlet.portletBoxType;
			selectedPortlet.boxTitle = selectedPortlet.portletBoxTitle;
			selectedPortlet.div = selectedPortlet.node;
						
			fnPortletRender(selectedPortlet.portletBoxType, selectedPortlet.portletInfo, selectedPortlet.node, selectedPortlet.portletKey);
			portletSettingDiv( selectedPortlet );
		};
		
		function fnPortletRender(portletBoxType, portletInfo, targetDiv, portletKey){
			$( targetDiv ).attr("portletTp", portletBoxType);
			$( targetDiv ).attr("portletKey", portletKey);
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).html( $( "#demo_" + portletBoxType ).val() );				
			}else{
				
				if(portletBoxType == "portletTemplete_mybox"){
					
					render_portletTemplete_mybox(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_mail_status"){
					
					render_portletTemplete_mail_status(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_inbox"){
					
					render_portletTemplete_inbox(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_calendar_horizontal"){
					
					render_portletTemplete_calendar_horizontal(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_calendar_vertical"){
					
					render_portletTemplete_calendar_vertical(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_iframe_banner"){
					
					render_portletTemplete_iframe_banner(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_iframe_quick"){
					
					render_portletTemplete_iframe_quick(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_iframe_outer"){
					
					render_portletTemplete_iframe_outer(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_assetGrowthIndex"){
					
					chartObject.portletTemplete_assetGrowthIndex = {
						chart : ''
					};
					render_portletTemplete_assetGrowthIndex(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_inventoryStatus"){
					
					chartObject.portletTemplete_inventoryStatus = {
						chart : ''
					};
					render_portletTemplete_inventoryStatus(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_bpNetProfit"){
					
					chartObject.portletTemplete_bpNetProfit = {
						chart : ''
					};
					render_portletTemplete_bpNetProfit(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_boundAgeStatus"){
					
					chartObject.portletTemplete_boundAgeStatus = {
						chart : ''
					};
					render_portletTemplete_boundAgeStatus(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_salesPerformance"){
					
					chartObject.portletTemplete_salesPerformance = {
						chart : ''
					};
					render_portletTemplete_salesPerformance(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_annualUseManage"){
					
					chartObject.portletTemplete_annualUseManage = {
						chart : ''
					};
					render_portletTemplete_annualUseManage(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_weekWorkingHours"){
					
					chartObject.portletTemplete_weekWorkingHours = {
						chart : ''
					};
					render_portletTemplete_weekWorkingHours(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_myWorkStatus"){
					
					chartObject.portletTemplete_myWorkStatus = {
						chart : ''
					};
					render_portletTemplete_myWorkStatus(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_overTimeApplication"){
					
					render_portletTemplete_overTimeApplication(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_workingStatus"){
					
					render_portletTemplete_workingStatus(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_etcBox"){
					
					render_portletTemplete_etcBox(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_board_hr"){
					
					render_portletTemplete_board_hr(portletInfo, targetDiv, portletKey);
					
				} else if( portletBoxType == "portletTemplete_requestJob" ) {

					render_portletTemplete_requestJob(portletInfo, targetDiv, portletKey);
				
				} else if( portletBoxType == "portletTemplete_expectedSpendToday" ) {
					
					render_portletTemplete_expectedSpendToday(portletInfo, targetDiv, portletKey);
					
				} else if( portletBoxType == "portletTemplete_divExpenseClaim" ) {

					chartObject.portletTemplete_divExpenseClaim = {
						chart : ''
					};
					render_portletTemplete_divExpenseClaim(portletInfo, targetDiv, portletKey);

				} else if( portletBoxType == "portletTemplete_accountingEaProgress" ) {
					
					chartObject.portletTemplete_accountingEaProgress = {
						chart : ''
					};
					render_portletTemplete_accountingEaProgress(portletInfo, targetDiv, portletKey);

				} else if( portletBoxType == "portletTemplete_mainAccountionTask" ) {

					render_portletTemplete_mainAccountionTask(portletInfo, targetDiv, portletKey);

				} else if(portletBoxType == "portletTemplete_myCardUsageHistory"){
					
					render_portletTemplete_myCardUsageHistory(portletInfo, targetDiv, portletKey);
					
				} else if(portletBoxType == "portletTemplete_salesByDepartment"){
					
					chartObject.portletTemplete_salesByDepartment = {
						chart : ''
					};
					render_portletTemplete_salesByDepartment(portletInfo, targetDiv, portletKey);
					
				} else if(portletBoxType == "portletTemplete_salesTrend"){
					
					render_portletTemplete_salesTrend(portletInfo, targetDiv, portletKey);
					
				} else if(portletBoxType == "portletTemplete_salesStatus"){
					
					render_portletTemplete_salesStatus(portletInfo, targetDiv, portletKey);
					
				} else if(portletBoxType == "portletTemplete_monthlySalesPerformance"){
					
					chartObject.portletTemplete_monthlySalesPerformance = {
						chart : ''
					};
					render_portletTemplete_monthlySalesPerformance(portletInfo, targetDiv, portletKey);
					
				} else if(portletBoxType == "portletTemplete_inboxCeo"){
					
					render_portletTemplete_inboxCeo(portletInfo, targetDiv, portletKey);
					
				}
			}
		}
		
		function fnSelectPortletUserSet(portletKey, attrName){
			return null;
		}
		
		function fnSetPortletLangName(targetDiv, portletInfo){
			if(portletInfo != null && portletInfo != ""){
				var langName = portletInfo.port_name_kr;
				if(langCode == "en" && portletInfo.port_name_en != ""){
					langName = portletInfo.port_name_en;
				}else if(langCode == "jp" && portletInfo.port_name_jp != ""){
					langName = portletInfo.port_name_jp;
				}else if(langCode == "cn" && portletInfo.port_name_cn != ""){
					langName = portletInfo.port_name_cn;
				}
				$( targetDiv ).find("[name=portletTitle]").html(langName);
			}
		}
		
		/* EBP CEO 포틀릿 랜더 함수 */
		function getChartContainerSize(targetContainer){
			var portletHeight = $(targetContainer).parents(".ptl_content").height();
			
			
			if($(targetContainer).next().length > 0){
				var portletWidth = $(targetContainer).parent("div").width() - $(targetContainer).next().width();
			}else{
				var portletWidth = $(targetContainer).parent("div").width();
			}
			
			return {
				height: portletHeight,
				width: portletWidth
			}
		}
		
		function render_portletTemplete_assetGrowthIndex(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_assetGrowthIndex" ).val());
			drawChart_portletTemplete_assetGrowthIndex();			
		}
		
		function drawChart_portletTemplete_assetGrowthIndex(){
			//assetGrowthIndexChartContainer
			chartObject.portletTemplete_assetGrowthIndex.chart = Highcharts.chart('portletTemplete_assetGrowthIndexContainer', {
				chart: {
			        type: 'area'
			    },
			    legend:{
			    	align: 'bottom'
			    },
			    title: {
			    	text: ''
			    },
			    credits: {
		          enabled: false
		        },
			    xAxis: {
			        categories: ['2015', '2016', '2017', '2018']
			    },
			    yAxis: {
			        title: {
			        	text: ''
			        },
			    	labels: {
			    		enabled: false
			    	}
			    },
			    tooltip: {
			        split: true,
			        valueSuffix: ' millions'
			    },
			    plotOptions: {
			        area: {
			            stacking: 'normal',
			            lineColor: '#666666',
			            lineWidth: 1,
			            marker: {
			                lineWidth: 1,
			                lineColor: '#666666'
			            }
			        }
			    },
			    series: [{
				        data: [502, 635, 809, 947],
				        name: '총자산증가율',
				        showInLegend: false,
						color: '#c7ebfd',
						lineColor: '#7a52fe',
						 marker: {
			                lineWidth: 1,
			                lineColor: '#7a52fe',
							symbol: 'circle'
			            }	
				    },
				    {
				        data: [800, 700, 850, 900],
				        name: '유동자산증가율',
				        showInLegend: false,
						color: '#cffcf7',
						lineColor: '#00c88f',
						 marker: {
			                lineWidth: 1,
			                lineColor: '#00c88f',
							symbol: 'circle'
			            }	
				    },
				    {
				        data: [695, 750, 600, 780],
				        name: '유형자산증가율',
				        showInLegend: false,
						color: '#e8fff2',
						lineColor: '#2ab9fd',
						 marker: {
			                lineWidth: 1,
			                lineColor: '#2ab9fd',
							symbol: 'circle'
			            }	
				    },
				    {
				        data: [795, 650, 620, 880],
				        name: '자기가본증가율',
				        showInLegend: false,
						color: '#f0fdf8',
						lineColor: '#abd600',
						 marker: {
			                lineWidth: 1,
			                lineColor: '#abd600',
							symbol: 'circle'
			            }	
				    },
			    ]
			});
		}
		
		function render_portletTemplete_inventoryStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_inventoryStatus" ).val());
			chartObject.portletTemplete_inventoryStatus.chart = Highcharts.chart('portletTemplete_inventoryStatusContainer', {
				chart: {
			        type: 'area'
			    },
			    legend:{
			    	align: 'bottom'
			    },
			    title: {
			    	text: ''
			    },
			    credits: {
			          enabled: false
			        },
			    xAxis: {
			        categories: ['6', '7', '8', '9', '10', '11', '12']
			    },
			    yAxis: {
			        title: {
			        	text: ''
			        },
			    	labels: {
			    		enabled: false
			    	}
			    },
			    tooltip: {
			        split: true,
			        valueSuffix: ' millions'
			    },
			    plotOptions: {
			        area: {
			            stacking: 'normal',
			            lineColor: '#666666',
			            lineWidth: 1,
			            marker: {
			                lineWidth: 1,
			                lineColor: '#666666'
			            }
			        }
			    },
			   series: [{
				        data: [5, 6, 5, 6, 8, 7, 8],
				        name: '현재재고',
				        showInLegend: false,
						color: '#e6fcfe',
						lineColor: '#357ffe',
						 marker: {
			                lineWidth: 1,
			                lineColor: '#357ffe',
							symbol: 'circle'
			            }
				    },
				    {
				        data: [4.5, 6, 5, 8, 9, 8, 7],
						name: '평균재고',
				        showInLegend: false,
						color: '#e2fbfd',
						lineColor: '#14cfeb',
						 marker: {
			                lineWidth: 1,
			                lineColor: '#14cfeb',
							symbol: 'circle'
			            }	
				    },
				    {
				        data: [8, 4, 3, 5, 6, 7, 5],
				        name: '이월재고',
				        showInLegend: false,
						color: '#e5ebfe',
						 marker: {
			                lineWidth: 1,
			                lineColor: '#7a52fe',
							symbol: 'circle'
			            }	
				    },
			    ]
			});
		}
		
		function render_portletTemplete_bpNetProfit(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_bpNetProfit" ).val());
			drawChart_portletTemplete_bpNetProfit();
		};
		
		function drawChart_portletTemplete_bpNetProfit(){
			
			var target = $("#portletTemplete_bpNetProfitContainer");
			
			var portletWidth = target.parents(".ptl_content").width();
			target.width(portletWidth);
			
			chartObject.portletTemplete_bpNetProfit.chart = Highcharts.chart('portletTemplete_bpNetProfitContainer', {
				 chart: {
				        type: 'column'
				    },
				    legend:{
				    	align: 'bottom'
				    },
				    title: {
				    	text: ''
				    },
				    credits: {
			          enabled: false
			        },
				    xAxis: {
				        categories: ['2014', '2015', '2016', '2017', '2018']
				    },
				    yAxis: {
				        title: {
				        	text: ''
				        },
				    	labels: {
				    		enabled: false
				    	}
				    },
				    tooltip: {
				        split: true,
				        valueSuffix: ' millions'
				    },
				    plotOptions: {
				        area: {
				            stacking: 'normal',
				            lineColor: '#666666',
				            lineWidth: 1,
				            marker: {
				                lineWidth: 1,
				                lineColor: '#666666'
				            }
				        },
				        series: {
		                	pointWidth: 9,
		                 	borderRadius: 5
		                }
				    },
				    series: [{
				        name: 'Profit',
				        data: [
				        	{
		                		name: '',
		                    	color: {
		    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
		                      		stops: [
		                      			[0, '#3EC7C2'],
		                          		[1, '#3370C4']
		                      		]
		                    	},
		                    	y: 130
		                	},
		                  	{
		                		name: '',
		                    	color: {
		    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
		                      		stops: [
		                      			[0, '#3EC7C2'],
		                          		[1, '#3370C4']
		                      		]
		                    	},
		                    	y: 50
		                	},
		                  	{
		                  		name: '',
		                    	color: {
		    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
		                      		stops: [
		                      			[0, '#3EC7C2'],
		                          		[1, '#3370C4']
		                      		]
		                    	},
		                    	y: 90
		                  	},
		                  	{
		                  		name: '',
		                    	color: {
		    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
		                      		stops: [
		                      			[0, '#3EC7C2'],
		                          		[1, '#3370C4']
		                      		]
		                    	},
		                    	y: 190
		                  	},
		                  	{
		                  		name: '',
		                    	color: {
		    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
		                      		stops: [
		                          		[0, '#3EC7C2'],
		                          		[1, '#3370C4']
		                      		]
		                    	},
		                    	y: 60
		                  	}
				        ],
				        dataLabels: {
				        	enabled: true,
				        	format: '{point.y:.1f}'
				        },
				        showInLegend: false
			    }]
			});
		}
		
		function render_portletTemplete_boundAgeStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_boundAgeStatus" ).val());
			drawChart_portletTemplete_boundAgeStatus();			
		}
		
		function drawChart_portletTemplete_boundAgeStatus(){
			var target = $("#portletTemplete_boundAgeStatusContainer");
			
			var portletHeight = target.parents(".ptl_content").height() - 40;
			var portletWidth = target.parents("tr").width() - 152;
			target.width(portletWidth);
		
			chartObject.portletTemplete_boundAgeStatus.chart = Highcharts.chart('portletTemplete_boundAgeStatusContainer', {
			    chart: {
			        type: 'column',
			        height: portletHeight
			    },
			    legend:{
			    	align: 'bottom'
			    },
			    title: {
			    	text: ''
			    },
			    xAxis: {
			        categories: ['01~30일', '31~60일', '61~90일', '91일이상']
			    },
			    yAxis: {
			        title: {
			        	text: ''
			        },
			    	labels: {
			    		enabled: false
			    	}
			    },
			    tooltip: {
			        split: true,
			        valueSuffix: ''
			    },
			    plotOptions: {
			        area: {
			            stacking: 'normal',
			            lineColor: '#666666',
			            lineWidth: 1,
			            marker: {
			                lineWidth: 1,
			                lineColor: '#666666'
			            }
			        },
			        series: {
	                	pointWidth: 20,
	                 	borderRadius: 15
	                }
			    },
			    series: [{
			        name: 'Profit',
			        data: [
	                	{
	                		name: '',
	                    	color: {
	    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
	                      		stops: [
	                          		[0, '#2BFFE0'],
	                          		[1, '#00B9FF']
	                      		]
	                    	},
	                    	y: 63
	                	},
	                  	{
	                		name: '',
	                    	color: {
	    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
	                      		stops: [
	                          		[0, '#32BDFF'],
	                          		[1, '#2E84FF']
	                      		]
	                    	},
	                    	y: 17
	                	},
	                  	{
	                  		name: '',
	                    	color: {
	    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
	                      		stops: [
	                          		[0, '#A277FF'],
	                          		[1, '#704AFF']
	                      		]
	                    	},
	                    	y: 14
	                  	},
	                  	{
	                  		name: '',
	                    	color: {
	    						linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
	                      		stops: [
	                          		[0, '#FE778C'],
	                          		[1, '#FFAD84']
	                      		]
	                    	},
	                    	y: 9
	                  	}
	                ],
			        dataLabels: {
			        	enabled: true,
			        	format: '{point.y:.1f}%'
			        },
			        showInLegend: false
			    }]
			});
		}
		
		/* 매출실적 그래프 전용 아이콘 생성 함수 */
		function renderIcons() {

			  // Move icon
			  if (!this.series[0].icon) {
			    this.series[0].icon = this.renderer.path(['M', -8, 0, 'L', 8, 0, 'M', 0, -8, 'L', 8, 0, 0, 8])
			      .attr({
			        stroke: '#303030',
			        'stroke-linecap': 'round',
			        'stroke-linejoin': 'round',
			        'stroke-width': 2,
			        zIndex: 10
			      })
			      .add(this.series[2].group);
			  }
			  this.series[0].icon.translate(
			    this.chartWidth / 2 - 10,
			    this.plotHeight / 2 - this.series[0].points[0].shapeArgs.innerR -
			      (this.series[0].points[0].shapeArgs.r - this.series[0].points[0].shapeArgs.innerR) / 2
			  );

			  // Exercise icon
			  if (!this.series[1].icon) {
			    this.series[1].icon = this.renderer.path(
			      ['M', -8, 0, 'L', 8, 0, 'M', 0, -8, 'L', 8, 0, 0, 8,
			        'M', 8, -8, 'L', 16, 0, 8, 8]
			    )
			      .attr({
			        stroke: '#ffffff',
			        'stroke-linecap': 'round',
			        'stroke-linejoin': 'round',
			        'stroke-width': 2,
			        zIndex: 10
			      })
			      .add(this.series[2].group);
			  }
			  this.series[1].icon.translate(
			    this.chartWidth / 2 - 10,
			    this.plotHeight / 2 - this.series[1].points[0].shapeArgs.innerR -
			      (this.series[1].points[0].shapeArgs.r - this.series[1].points[0].shapeArgs.innerR) / 2
			  );

			  // Stand icon
			  if (!this.series[2].icon) {
			    this.series[2].icon = this.renderer.path(['M', 0, 8, 'L', 0, -8, 'M', -8, 0, 'L', 0, -8, 8, 0])
			      .attr({
			        stroke: '#303030',
			        'stroke-linecap': 'round',
			        'stroke-linejoin': 'round',
			        'stroke-width': 2,
			        zIndex: 10
			      })
			      .add(this.series[2].group);
			  }

			  this.series[2].icon.translate(
			    this.chartWidth / 2 - 10,
			    this.plotHeight / 2 - this.series[2].points[0].shapeArgs.innerR -
			      (this.series[2].points[0].shapeArgs.r - this.series[2].points[0].shapeArgs.innerR) / 2
			  );
			}
		
		function render_portletTemplete_salesPerformance(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesPerformance" ).val());
			drawChart_portletTemplete_salesPerformance();
		}
		
		function drawChart_portletTemplete_salesPerformance(){
			
			var target = $("#portletTemplete_salesPerformanceContainer");
			
			var portletHeight = target.parents(".ptl_content").height() - 40;
			var portletWidth = target.parents(".ac").width();
			target.width(portletWidth);
			
			chartObject.portletTemplete_salesPerformance.chart = Highcharts.chart('portletTemplete_salesPerformanceContainer', {
			    chart: {
			        plotBackgroundColor: null,
			        plotBorderWidth: null,
			        plotShadow: false,
			        type: 'pie',
			        height: portletHeight
			    },
			    title: {
			        text: '67%<br/>달성률',
			        align: 'center',
			       	verticalAlign: 'middle',
			       	y: 2
			    },
			    credits: {
				   enabled: false
				},
			    tooltip: {
			        pointFormat: '{series.name}: <b>{point.percentage:.0f}%</b>'
			    },
			    plotOptions: {
			        pie: {
			            allowPointSelect: true,
			            cursor: 'pointer',
			            dataLabels: {
			                enabled: false,
			            },
			            size: '100%',
			            showInLegend: false
			        }
			    },
			    legend: {
			    	itemStyle: {
			    		fontSize: '10px'	
			    	}
			    },
			    series: [{
			        name: 'Brands',
			        colorByPoint: true,
			        innerSize: '90%',
			        data: [{
			            name: '달성률',
			            color: '#FF6393',
			            y: 67
			        },{
			        	name: '',
			        	color: '#D6D6D6',
			        	y: 33
			        }]
			    }]
			});
		}
		
		function render_portletTemplete_annualUseManage(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_annualUseManage" ).val());	
			drawChart_portletTemplete_annualUseManage()
		}
		
		function drawChart_portletTemplete_annualUseManage() {
			
			var target = $("#portletTemplete_annualUseManageContainer");
			
			var portletHeight = target.parents(".ptl_content").height() - 17;
			var portletWidth = target.parents(".ptl_content").width() - target.next().width() - 30;
			target.width(portletWidth);
			
			chartObject.portletTemplete_annualUseManage.chart = Highcharts.chart('portletTemplete_annualUseManageContainer', {
			    chart: {
			        plotBackgroundColor: null,
			        plotBorderWidth: null,
			        plotShadow: false,
			        type: 'pie',
			        height: portletHeight
			    },
			    title: {
			        text: '총<br/>45명',
			       	align: 'center',
			       	verticalAlign: 'middle',
			       	y: -4
			    },
			    tooltip: {
			        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
			    },
			    plotOptions: {
			        pie: {
			            allowPointSelect: true,
			            cursor: 'pointer',
			            dataLabels: {
			                enabled: true,
			                distance: 0,
			                format: '{point.percentage:.0f}%',
			                style: {
			                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
			                }
			            },
			            size: '70%'
			        }
			    },
			    series: [{
			        name: 'Brands',
			        colorByPoint: true,
			        innerSize: '70%',
			        data: [{
			            name: null,
			            y: 45,
			            color: "#5AAE8A"
			        }, {
			            name: null,
			            y: 25,
			            color: "#FFA841"
			        }, {
			            name: null,
			            y: 30,
			            color: "#FC4F52"
			        }]
			    }]
			});
		}
		
		function render_portletTemplete_weekWorkingHours(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_weekWorkingHours" ).val());
			drawChart_portletTemplete_weekWorkingHours()
		}
		
		function drawChart_portletTemplete_weekWorkingHours(){
			var target = $("#portletTemplete_weekWorkingHoursContainer");
			var portletHeight = target.parents(".ptl_content").height();
			var portletWidth = target.parents(".ptl_contents").width();
			target.width(portletWidth);
			
			chartObject.portletTemplete_weekWorkingHours.chart = Highcharts.chart('portletTemplete_weekWorkingHoursContainer', {
			    chart: {
			        plotBackgroundColor: null,
			        plotBorderWidth: null,
			        plotShadow: false,
			        type: 'pie',
			        height: portletHeight
			    },
			    title: {
			        text: '45시간',
			        align: 'center',
			       	verticalAlign: 'middle',
			       	y: -17
			    },
			    tooltip: {
			        pointFormat: '{series.name}: <b>{point.percentage:.0f}%</b>'
			    },
			    plotOptions: {
			        pie: {
			            allowPointSelect: true,
			            cursor: 'pointer',
			            dataLabels: {
			                enabled: false,
			            },
			            size: '100%',
			            showInLegend:true
			        }
			    },
			    legend: {
			    	itemStyle: {
			    		fontSize: '10px'	
			    	}
			    },
			    series: [{
			        name: 'Brands',
			        colorByPoint: true,
			        innerSize: '70%',
			        data: [{
			            name: '기본근무',
			            color: '#24A5FF',
			            y: 45
			        }, {
			            name: '연장근무',
			            color: '#4DCCCD',
			            y: 10
			        }, {
			            name: '휴일근무',
			            color: '#FC4F52',
			            y: 25
			        }, {
			        	name: '',
			        	color: '#D6D6D6',
			        	y: 20
			        }
			        ]
			    }]
			});
		}
		
		function render_portletTemplete_myWorkStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_myWorkStatus" ).val());
			drawChart_portletTemplete_myWorkStatus();
		}
		
		function drawChart_portletTemplete_myWorkStatus(){
			var target = $("#portletTemplete_myWorkStatusContainer");
		
			var portletHeight = target.parents(".ptl_content").height();
			var portletWidth = target.parent("div").width() - target.next().width();
			
			target.width(portletWidth);
						
			chartObject.portletTemplete_myWorkStatus.chart = Highcharts.chart('portletTemplete_myWorkStatusContainer', {
			  chart: {
			    type: 'column',
			    height: portletHeight
			  },
			  title: {
			    text: null
			  },
			  xAxis: {
			    categories: ['6일', '7일', '8일', '9일', '10일', '11일', '12일']
			  },
			  yAxis: {
				min: 0,
			    max: 15,
			    tickInterval: 3,
			    title: null
			  },
			  tooltip: {
			    pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
			    shared: true
			  },
			  plotOptions: {
			    column: {
			      stacking: 'normal'
			    }
			  },
			  series: [{
				name: '',
				data: [9, 7, 6, 8, 5, 3, 15],
				showInLegend: false,
				color: '#D6D6D6'
			  },
			  {
			    name: '기본근무시간',
			    data: [0, 6, 8, 6, 8, 6, 0],
			    showInLegend: false,
			    color: '#24A5FF'
			  }, {
			    name: '연장근무시간',
			    data: [0, 2, 1, 1, 2, 6, 0],
			    showInLegend: false,
			    color: '#4DCCCD'
			  }, {
			    name: '휴일근무시간',
			    data: [6, 0, 0, 0, 0, 0, 0],
			    showInLegend: false,
			    color: '#FC4F52'
			  }]
			});
		}
		
		function render_portletTemplete_overTimeApplication(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_overTimeApplication" ).val());
			
			
		}
		
		function render_portletTemplete_workingStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_workingStatus" ).val());
			
			
		}
		
		function render_portletTemplete_etcBox(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_etcBox" ).val());
									
		}
		
		function render_portletTemplete_board_hr(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_board_hr" ).val());
		}
		

		function render_portletTemplete_requestJob(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_requestJob" ).val());
		};
	
		
		function render_portletTemplete_expectedSpendToday(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_expectedSpendToday" ).val());
		};
		
		// 부서별 경비청구 진행률
		function render_portletTemplete_divExpenseClaim(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_divExpenseClaim" ).val());
			drawChart_portletTemplete_divExpenseClaim();
		};
		
		function drawChart_portletTemplete_divExpenseClaim(){
			var portletHeight = $("#portletTemplete_divExpenseClaimContainer").parents(".ptl_content").height();
			var portletWidth = $("#portletTemplete_divExpenseClaimContainer").parents(".ptl_content").width() - $("#portletTemplete_divExpenseClaimContainer").next().width() - 20;
			$("#portletTemplete_divExpenseClaimContainer").width(portletWidth);
			
			chartObject.portletTemplete_divExpenseClaim.chart = Highcharts.chart('portletTemplete_divExpenseClaimContainer', {
			    chart: {
			        plotBackgroundColor: null,
			        plotBorderWidth: null,
			        plotShadow: false,
			        type: 'pie',
			        height: portletHeight
			    },
			    title: {
			        text: '50%',
			        align: 'center',
			       	verticalAlign: 'middle',
			       	y: 8
			    },
			    credits: {
				   enabled: false
				},
			    tooltip: {
			        pointFormat: '{series.name}: <b>{point.percentage:.0f}%</b>'
			    },
			    plotOptions: {
			        pie: {
			            allowPointSelect: true,
			            cursor: 'pointer',
			            dataLabels: {
			                enabled: false,
			            },
			            size: '100%',
			            showInLegend: false
			        }
			    },
			    legend: {
			    	itemStyle: {
			    		fontSize: '10px'	
			    	}
			    },
			    series: [{
			        name: 'Brands',
			        colorByPoint: true,
			        innerSize: '90%',
			        data: [{
			            name: '기본근무',
			            color: '#639EFD',
			            y: 50
			        },{
			        	name: '',
			        	color: '#D6D6D6',
			        	y: 50
			        }]
			    }]
			});
		}


		function render_portletTemplete_accountingEaProgress(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_accountingEaProgress" ).val());
			drawChart_portletTemplete_accountingEaProgress();			
		};
		
		function drawChart_portletTemplete_accountingEaProgress() {
						
			var portletHeight = $("#portletTemplete_accountingEaProgressContainer").parents(".ptl_content").height();
			var portletWidth = $("#portletTemplete_accountingEaProgressContainer").parents(".ptl_content").width() - $("#portletTemplete_accountingEaProgressContainer").next().width() - 20;
			$("#portletTemplete_accountingEaProgressContainer").width(portletWidth);
			
			chartObject.portletTemplete_accountingEaProgress.chart = Highcharts.chart('portletTemplete_accountingEaProgressContainer', {
			    chart: {
			        plotBackgroundColor: null,
			        plotBorderWidth: null,
			        plotShadow: false,
			        type: 'pie',
			        height: portletHeight,
			        margin: [5, 0, 35, 0]
			    },
			    title: {
			        text: '9건',
			        align: 'center',
			       	verticalAlign: 'middle',
			       	y: -5
			    },
			    credits: {
				   enabled: false
				},
			    tooltip: {
			        pointFormat: '{series.name}: <b>{point.percentage:.0f}%</b>'
			    },
			    plotOptions: {
			        pie: {
			            allowPointSelect: true,
			            cursor: 'pointer',
			            dataLabels: {
			                enabled: false,
			            },
			            size: '100%',
			            showInLegend: true
			        }
			    },
			    legend: {
			    	itemStyle: {
			    		fontSize: '10px'	
			    	}
			    },
			    series: [{
			        name: 'Brands',
			        colorByPoint: true,
			        innerSize: '50%',
			        data: [{
			            name: '상신',
			            color: '#24A4FF',
			            y: 50
			        },{
			        	name: '결재중',
			        	color: '#FE7676',
			        	y: 30
			        },{
			        	name: '완료',
			        	color: '#837BD1',
			        	y: 20
			        }]
			    }]
			});
		}


		function render_portletTemplete_mainAccountionTask(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_mainAccountionTask" ).val());
		};
		
		function render_portletTemplete_monthlySalesPerformance(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_monthlySalesPerformance" ).val());
			
			drawChart_portletTemplete_monthlySalesPerformance();
		}
		
		function drawChart_portletTemplete_monthlySalesPerformance(){
			
			var target = $("#portletTemplete_monthlySalesPerformanceContainer");
			
			var portletHeight = target.parents(".ptl_content").height() - 17;
			var portletWidth = target.parents("td").width() - 10;
			target.width(portletWidth);
			
			chartObject.portletTemplete_monthlySalesPerformance.chart = Highcharts.chart('portletTemplete_monthlySalesPerformanceContainer', {
				  chart: {
				    type: 'areaspline',
				    height: portletHeight
				  },
				  title: {
				    text: ''
				  },
			       credits: {
				          enabled: false
				        },
				  legend: {
				    layout: 'vertical',
				    align: 'right',
				    verticalAlign: 'top',
				    x: -100,
				    y: -100,
				    floating: true,
				    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
				  },
				  xAxis: {
				    categories: [
				      '1월',
				      '2월',
				      '3월',
				      '4월',
				      '5월',
				      '6월',
				      '7월',
				      '8월',
				      '9월',
				      '10월',
				      '11월',
				      '12월',
				    ],
				    plotBands: [{ // visualize the weekend
				      from: 4,
				      to: 4,
				      color: '#f35d5a'
				    }]
				  },
				  yAxis: {
				    title: {
				      text: ''
				    }
				  },
				  tooltip: {
				    shared: true,
				    valueSuffix: ''
				  },
				  plotOptions: {
				    areaspline: {
				      fillOpacity: 0.2
				    }
				  },
				  series: [{
				    name: '',
				    data: [30, 40, 32, 51, 45, 11, 16,19,4,8,19,21]
				  }]
				});
		}
		
		/* 나의카드 사용내역 render function */
		function render_portletTemplete_myCardUsageHistory(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_myCardUsageHistory" ).val());
		}
		
		function render_portletTemplete_salesTrend(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesTrend").val());
		}
		
		function render_portletTemplete_salesStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesStatus").val());
			var array = new Array();
			var Data1 = {
				"id" : "SalesStatus_first",
				"Category" : "일기준",
				"Datas1" : 1200,
				"Datas2" : 1400};
			array.push(Data1);
			var Data2 = {
					"id" : "SalesStatus_second",
					"Category" : "월기준",
					"Datas1" : 1200,
					"Datas2" : 1400};
			array.push(Data2);
			var Data3 = {
					"id" : "SalesStatus_third",
					"Category" : "년기준",
					"Datas1" : 1200,
					"Datas2" : 1400};
			array.push(Data3);
			
			array.forEach(function(item) {
                salesStatusGraph(item);
   			 });						
		}
		/*
		 * 공통 그래프 생성 함수 
		 */
				
				
		function CommonAreasplineGraph(){
			Highcharts.chart('monthlySalesPerformance', {
				  chart: {
				    type: 'areaspline'
				  },
				  title: {
				    text: ''
				  },
			       credits: {
				          enabled: false
				        },
				  legend: {
				    layout: 'vertical',
				    align: 'right',
				    verticalAlign: 'top',
				    x: -100,
				    y: -100,
				    floating: true,
				    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
				  },
				  xAxis: {
				    categories: [
				      '1월',
				      '2월',
				      '3월',
				      '4월',
				      '5월',
				      '6월',
				      '7월',
				      '8월',
				      '9월',
				      '10월',
				      '11월',
				      '12월',
				    ],
				    plotBands: [{ // visualize the weekend
				      from: 4,
				      to: 4,
				      color: '#f35d5a'
				    }]
				  },
				  yAxis: {
				    title: {
				      text: ''
				    }
				  },
				  tooltip: {
				    shared: true,
				    valueSuffix: ''
				  },
				  plotOptions: {
				    areaspline: {
				      fillOpacity: 0.2
				    }
				  },
				  series: [{
				    name: '판매액',
				    data: [12500000, 6000000, 11058111, 13799000, 30206100, 10562201, 40000000,25000000,9600000,15421014,19256985,21000000]
				  }]
				});
		}
		
		/* column Graph 생성 함수 */
		function salesStatusGraph(item){
			var chart = Highcharts.chart(item.id, {

				  chart: {
				    type: 'column',
				    width: 120,
				    height: 130
				  },
			       credits: {
			          enabled: false
			        },
				  title: {
				    text: ''
				  },

				  subtitle: {
				    text: ''
				  },

				  legend: {
				    enabled: false,
				    verticalAlign: 'middle',
				    layout: 'vertical'
				  },
				  xAxis: {
				    categories: [item.Category],
				    labels: {
				      x: 0
				    }
				  },

				  yAxis: {
				    allowDecimals: false,
				    title: {
				      text: ''
				    }
				  },

				  series: [{
				    name: '',
				    data: [item.Datas1],
				    color : '#f89e9c'
				  }, {
				    name: '',
				    data: [item.Datas2],
				    color : '#f35d5a'
				  }],

				  responsive: {
				    rules: [{
				      condition: {
				        maxWidth: 20
				      },
				      chartOptions: {
				        legend: {
				          align: 'center',
				          verticalAlign: 'bottom',
				          layout: 'horizontal'
				        },
				        yAxis: {
				          labels: {
				            align: 'left',
				            x: 0,
				            y: -5
				          },
				          title: {
				            text: null
				          }
				        },
				        subtitle: {
				          text: null
				        },
				        credits: {
				          enabled: false
				        }
				      }
				    }]
				  }
				});
		}
	
		
		function render_portletTemplete_salesByDepartment(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesByDepartment" ).val());
			drawChart_portletTemplete_salesByDepartment();
		}
		
		function drawChart_portletTemplete_salesByDepartment(){
			
			var portletHeight = $("#portletTemplete_salesByDepartmentContainer").parents(".ptl_content").height();
			var portletWidth = $("#portletTemplete_salesByDepartmentContainer").parents(".ptl_content").width();
			$("#portletTemplete_salesByDepartmentContainer").width(portletWidth);
			
			chartObject.portletTemplete_salesByDepartment.chart = Highcharts.chart('portletTemplete_salesByDepartmentContainer', {
				  chart: {
				    plotBackgroundColor: null,
				    plotBorderWidth: null,
				    plotShadow: false,
				    type: 'pie',
				    margin :[0,5,55,5],
				    height: portletHeight
				  },
			       credits: {
				          enabled: false
				        },
				        title: {
					        text: '전체<br/>990,000원',
					       	align: 'center',
					       	verticalAlign: 'middle',
					       	floating: true,
					       	y: -27,
					       	x: 0,
					       	style :{
					       		fontSize : "10px",
					       		fontWeight: 'bold'
					       	}
					    },
				  tooltip: {
				    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
				  },
				  plotOptions: {
				    pie: {
				      allowPointSelect: true,
				      innerSize: '60',
				      cursor: 'pointer',
				      dataLabels: {
				        enabled: false
				      },
				      showInLegend: true
				    }
				  },
				  series: [{
				    name: '부서',
				    colorByPoint: true,
				    data: [{
				      name: '영업1팀',
				      y: 61.41
				    }, {
				      name: '영업2팀',
				      y: 11.84
				    }, {
				      name: '영업3팀',
				      y: 10.85
				    }, {
				      name: '영업4팀',
				      y: 4.67
				    }, {
				      name: '영업5팀',
				      y: 4.18
				    }, {
				      name: '영업6팀',
				      y: 7.05
				    }]
				  }]
				});
		}
		
		function render_portletTemplete_inboxCeo(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_inboxCeo" ).val());
		}	
		
		/* EBP CEO END */
		
		function render_portletTemplete_iframe_outer(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_iframe_outer" ).val());

			if(portletInfo != null && portletInfo != "" && portletInfo.linkList != null && portletInfo.linkList.length > 0 && portletInfo.linkList[0].link_url != ""){
				
				if(portletInfo.linkList[0].ssoUseYn == "Y"){
					
					var tblParam = {};
					tblParam.paramTp = "cloud";
					tblParam.ssoType = portletInfo.linkList[0].ssoType;
					tblParam.ssoEmpCtlName = portletInfo.linkList[0].ssoUserId;
					tblParam.ssoCoseqCtlName = portletInfo.linkList[0].ssoCompSeq;
					tblParam.ssoEncryptType = portletInfo.linkList[0].ssoEncryptType;
					tblParam.ssoEncryptKey = portletInfo.linkList[0].ssoEncryptKey;
					tblParam.ssoTimeLink = portletInfo.linkList[0].ssoTimeLink;
					tblParam.ssoEncryptScope = portletInfo.linkList[0].ssoEncryptScope;
					tblParam.ssoErpempnoCtlName = portletInfo.linkList[0].sspErpSeq;
					tblParam.ssoLogincdCtlName = portletInfo.linkList[0].ssoLoginCd;
					tblParam.ssoErpcocdCtlName = portletInfo.linkList[0].ssoErpCompSeq;
					tblParam.ssoEtcCtlName = portletInfo.linkList[0].ssoEtcName;
					tblParam.ssoEtcCtlValue = portletInfo.linkList[0].ssoEtcValue;
					tblParam.url = portletInfo.linkList[0].link_url;
					
					$.ajax({
						type:"post",
					    url: _g_contextPath_ + "/cmm/system/getMenuSSOLinkInfo.do",
					    async: false,
					    dataType: 'json',
					    data: tblParam,
					    success: function(data) {
					    	$( targetDiv ).find("[name=portletTemplete_iframe_outer_list]").html("<iframe src='"+data.ssoUrl+"'></iframe>");
					    },
					    error: function(xhr) { 
					    }
				   });						
					
				}else{
					$( targetDiv ).find("[name=portletTemplete_iframe_outer_list]").html("<iframe src='"+portletInfo.linkList[0].link_url+"'></iframe>");	
				}
				
			}else{
				$( targetDiv ).find("[name=portletTemplete_iframe_outer_list]").html("").addClass("nocon");
			}
		}		
		
		function render_portletTemplete_iframe_banner(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_iframe_banner" ).val());
			
			var portletBannerKey = "portletBanner_" + portletKey;
			
			//demo배너
			if(portletInfo != null && portletInfo == "demo"){
				$( targetDiv ).find("[name=loadingImg]").attr("src", "/gw/Images/portal/demo/main_img01.png");
				$( targetDiv ).find("[name=loadingIframe]").attr("src", "/gw/html/i_banner_portlet.html?portletKey="+portletBannerKey);
				return;
			}			
			
			localStorage.setItem(portletBannerKey ,JSON.stringify(portletInfo));			
			
			if(portletInfo != null && portletInfo != "" && portletInfo.useYn != "N" && portletInfo.linkList != null && portletInfo.linkList.length > 0){
				$( targetDiv ).find("[name=loadingImg]").attr("src", "/gw/cmm/file/fileDownloadProc.do?fileId="+portletInfo.linkList[0].file_id);
				$( targetDiv ).find("[name=loadingIframe]").attr("src", "/gw/html/i_banner.html?portletKey="+portletBannerKey);
	
			}else{
				$( targetDiv ).find("[name=portletTemplete_iframe_banner_list]").html("").addClass("nocon");
			}
		}
		
		function fnBannerImgSetCallback(portletBannerKey){
			$("[portletKey="+portletBannerKey.replace("portletBanner_","")+"] [name=loadingImg]").hide();
			$("[portletKey="+portletBannerKey.replace("portletBanner_","")+"] [name=loadingIframe]").show();			
		}
		
		function render_portletTemplete_iframe_quick(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_iframe_quick" ).val());
			
			//demo배너
			if(portletInfo != null && portletInfo == "demo"){
				$( targetDiv ).find("[name=portletTemplete_iframe_quick_list]").html("<iframe src='/gw/html/i_quick_portlet.html'></iframe>");
				return;
			}			
			
			var portletBannerKey = "portletBannerKey_" + portletKey;
			localStorage.setItem(portletBannerKey ,JSON.stringify(portletInfo));			

			if(portletInfo != null && portletInfo != "" && portletInfo.linkList != null && portletInfo.linkList.length > 0){
				$( targetDiv ).find("[name=portletTemplete_iframe_quick_list]").html("<iframe src='/gw/html/i_quick.html?portletKey="+portletBannerKey+"'></iframe>");
			}else{
				$( targetDiv ).find("[name=portletTemplete_iframe_quick_list]").html("").addClass("nocon");
			}
		}
			
		
		var specificDate = new Date(); 
		specificDate.setDate(specificDate.getDate() -7);			
		
		function render_portletTemplete_calendar_horizontal(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#demo_portletTemplete_calendar_horizontal" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
		}
		
		function render_portletTemplete_calendar_vertical(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#demo_portletTemplete_calendar_vertical" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
		}		
		
		function render_portletTemplete_inbox(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_inbox" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find( "[name=portletTemplete_inbox_list]" ).html("");
				return;
			}			
			
			var tag = '';
			var params = {};
			params.seen = portletInfo.val1;
			
			var apiName = "/gw/emailList.do";
			
			if(portletInfo.val0 == "1"){
				apiName = "/gw/emailTotal.do";
				params.pageSize = portletInfo.val2;
			}else{
				params.count = portletInfo.val2;
			}
			
			$.ajax({
				type: "post",
	            datatype: "json",
	            url: apiName,
	            data: params,
	            async: true,
	            success: function (result) {
	            	var tag = '';
	            	var emailData = null;
	            	
	    			if(portletInfo.val0 == "1"){
		            	if(result.totalMailList){
		            		if(result.totalMailList.Records){
		            			emailData = result.totalMailList.Records;
		            		}
		            	}

		            	emailData = (emailData == null ? [] : emailData);
		            	mail = (result.mail ? result.mail : '');
		            	mailUrl = (result.mailUrl ? result.mailUrl : '');
		            	
	    			}else{
	    				emailData = result.mailList.result.mailList;
		            	mailUrl = result.mailUrl;
		            	mail = result.email;
		            	seen = result.seen;
		            	mailCnt = result.cnt;	    				
	    			}
	            	
	            	if(emailData != null) {
	            		
	            		tag+='<div class="ptl_mail freebScrollY"><ul>';
		            	
						for(var i=0; i<emailData.length; i++) {	
	                		if(portletInfo.val1 == "Y") {					// 미열람 메일만 보기
	                			if(emailData[i].seen == "0") {
	                				tag+='<li class="unlead"><dl>';
	                       			tag+='<dt class="title" onclick="mailInfoPop(' + emailData[i].muid + ',this);"><a href="#n" title="' + emailData[i].subject.replace("<","&lt").replace(">","&gt") + '">' + emailData[i].subject.replace("<","&lt").replace(">","&gt") + '</a></dt>';
	                       			
		                   			if(portletInfo.val0 == "1"){
		                        		tag+='<dd class="from_info">' + emailData[i].mail_from.replace("<","&lt").replace(">","&gt") + '</dd>';
		                        		tag+='<dd class="date">' + emailData[i].rfc822date + '</dd>';
		                   			}else{
		                        		tag+='<dd class="from_info">' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
		                        		tag+='<dd class="date">' + emailData[i].rfc822Date + '</dd>';
		                   			}	                       			

	                        		tag+='</dl></li>';
	                			}
	                		} else {
	                			if(emailData[i].seen == "0") {
	                    			tag+='<li class="unlead"><dl>';
	                    		} else {
	                    			tag+='<li class=""><dl>';
	                    		}
	                    		
	                   			tag+='<dt class="title" onclick="mailInfoPop(' + emailData[i].muid + ',this);"><a href="#n" title="' + emailData[i].subject.replace("<","&lt").replace(">","&gt") + '">' + emailData[i].subject.replace("<","&lt").replace(">","&gt") + '</a></dt>';
	                   			
	                   			if(portletInfo.val0 == "1"){
	                    			tag+='<dd class="from_info">' + emailData[i].mail_from.replace("<","&lt").replace(">","&gt") + '</dd>';
	                    			tag+='<dd class="date">' + emailData[i].rfc822date + '</dd>';
	                   			}else{
	                   				tag+='<dd class="from_info">' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
	                   				tag+='<dd class="date">' + emailData[i].rfc822Date + '</dd>';
	                   			}
	                    		
	                    		
	                    		tag+='</dl></li>';
	                		}
	                		
	                	}
						tag+='</ul></div>';	            		
	            	}
	            	
	            	$( targetDiv ).find( "[name=portletTemplete_inbox_list]" ).html(tag);
	            },
	            error: function (e) {
	            	$( targetDiv ).find( "[name=portletTemplete_inbox_list]" ).html("");
	            }
			});			
		}		
		
		var mail = "";
		var mailUrl = "";
		var email = "";
		var mailcnt = 0;
		var seen = 0;		
		function render_portletTemplete_mail_status(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_mail_status" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find("[name=portletTemplete_mail_status_list]").html("");
				return;
			}			
			
			$.ajax({
				type: "post",
	            url: "/gw/emailCountUsage.do",
	            datatype: "json",
	            async: true,
	            success: function (result) {
	            	
	            	mailUrl = (result.mailUrl || '');
	            	var mailData = result.mailUsageCountData;
	            	var allunseen = (mailData.allunseen || '0');
	            	var mailUseSize = (mailData.mailboxsize || '0');
	            	var mailPercent = (mailData.mailboxPercent || '0');
	            	var total = (mailData.mailboxmaxsize || '0');
	            	var tag = '';
	            	
	            	if(mailData == "{}") {
	            		allunsenn = "-";
	            		mailUseSize = "-";
	            		mailPercent = "-";
	            		total = "-";
	            	}
	            	
	            	tag+='<div class="mdst"><ul>';
	            	
	            	if(portletInfo.val0 == "Y") {
	            		tag += '<li>';
	            		tag += '<dl>';            	
	            		tag += '<dt><%=BizboxAMessage.getMessage("TX000001580","받은편지함")%></dt>';
	                	tag += '<dd><a class=" fwb" href="javascript:fnMailMain()"><span class="text_blue">' + allunseen + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
	                	tag += '</dl>';	
	                	tag += '</li>';
	            	}
	            	
	            	if(portletInfo.val1 == "Y") {
	            		tag += '<li>';
	                	tag += '<dl>';
	                	tag += '<dt><%=BizboxAMessage.getMessage("TX000000478","사용량")%></dt></dt>';
	                	tag += '<dd><span class="fwb text_blue"> ' + mailPercent +  '%</span></dd>';
	                	tag += '</dl>';
	                	tag += '</li>';
	                	tag += '<li>';
	                	tag += '<dl>';
	                	tag += '<dd><span>(<span class="fwb">' + mailUseSize + '</span>/ ' + total + ')</span></dd>';
	                	tag += '</dl>';
	                	tag += '</li>';
	            	}
	            	
	            	tag+='</ul></div>';
	            	
	            	$( targetDiv ).find("[name=portletTemplete_mail_status_list]").html(tag);
	            },
	            error: function (e) {
	            	$( targetDiv ).find("[name=portletTemplete_mail_status_list]").html("");
	            }
			});		
		}		
		
		function render_portletTemplete_mybox(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_mybox" ).val());
			
			if('${empCheckWorkYn}' == "Y" && (portletInfo.val01 == "Y" || portletInfo.val02 == "Y")){

				var comeDt = '${userAttInfo.comeDt}';
				var leaveDt = '${userAttInfo.leaveDt}';
				
				if(comeDt.length == 14){
					$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근")%></em> ' + comeDt.substring(0,4) + '.' + comeDt.substring(4,6) + '.' + comeDt.substring(6,8) + ' ' + comeDt.substring(8,10) + ':' + comeDt.substring(10,12) + ':' + comeDt.substring(12,14) + " " + '&nbsp;&nbsp;');
				}else{
					$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음")%></em>' + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(1);" style="cursor: pointer;"><img alt="" src="/gw/Images/np_myinfo_in_blue.png"></a>' : ''));
				}
				
				if(leaveDt.length == 14){
					$( targetDiv ).find("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근")%></em> ' + leaveDt.substring(0,4) + '.' + leaveDt.substring(4,6) + '.' + leaveDt.substring(6,8) + ' ' + leaveDt.substring(8,10) + ':' + leaveDt.substring(10,12) + ':' + leaveDt.substring(12,14) + " " + '&nbsp;&nbsp;');
				}else{
					$( targetDiv ).find("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000016097","퇴근시간 없음")%></em>' + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(4);" style="cursor: pointer;"><img alt="" src="/gw/Images/np_myinfo_out_blue.png"></a>' : ''));
				}
				
				$( targetDiv ).find("#container").show();
			}
		}
		
		function setWeatherApiKey(apiKey){
			weatherApiKey = apiKey;
		}
		
	</script>

    <script>
    
		puddready( function() {

			var dataStr = '${portletInfo}';
			
			var dataObj = dataStr != "" ? JSON.parse( dataStr ) : null;
			
			if(dataObj != null && dataObj.arrPortlet.length > 0){
				dataObj.arrPortlet.forEach(function(item,idx){
					if(newPortletKey < item.portletKey){
						newPortletKey = item.portletKey;
					}
				});
			}
			
			// create - portlet 생성 함수
			Pudd( "#portlet" ).puddPortlet({
				portletData : dataStr
			,	displayColCount : 10
			,	configCallback : configCallback
			,	portletCallback : portletCallback
			});

		    // save
		    Pudd( "#btnSave" ).on( "click", function() {
		    	
		    	var portletObj = Pudd( "#portlet" ).getPuddObject();
		    	
		    	/*
		    	if($(".portal_con_left .portal_portlet").length == 0 || $(".portal_con_center .portal_portlet").length == 0 || $(".portal_con_right .portal_portlet").length == 0){
		    		alert("<%=BizboxAMessage.getMessage("TX000010584","각 위치항목에 한 개 이상의 포틀릿이 배치되어야 합니다")%>");
		    		return;
		    	}*/		

		    	if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
		     		var tblParam = {};
		     		tblParam.portalId = "${param.portalId}";
		     		tblParam.portletInfo = portletObj.getPortletData();
		     		tblParam.portalHeight = portletObj.getPortletHeight();		     		
		     		
		     		/*
		     		* 날씨 포틀릿을 사용하면 API키를 서버에 보낸다. 
		     		*/
		     		var _portletInfo = JSON.parse(tblParam.portletInfo);	
		     		_portletInfo.arrPortlet.map(function(item){
		     			if(item.boxType == "portletTemplete_weather"){
		     				tblParam.weatherApiKey = weatherApiKey;
		     				return item;
		     			}
		     			return item;
		     		});
		     		
		     		
		     		$.ajax({
		            	type:"post",
		        		url:'portletCloudInsert.do',
		        		datatype:"json",
		                data: tblParam ,
		        		success: function (result) {
		    	    			if(result.value == "1"){
		    	    				opener.reloadGwFrame();
		    	    				self.close();
		    	    			}else{
		    	    				alert("<%=BizboxAMessage.getMessage("TX000002439","권한이 없습니다.")%>");
		    	    			}
		        		    } ,
		    		    error: function (result) { 
		    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		    		}
		        	});
		     		
		    	}
		    });

			Pudd( "#portlet" ).on( "portletinsert", function( e ) {

				var portletTag = e.detail;

				var divObj = Pudd( portletTag ).getPuddObject();
				newPortletKey++;
				divObj.portletKey = newPortletKey;
				divObj.newInsert = true;
				
				// portlet 스크롤 초기화 호출
				var result = Pudd.querySelectAll( ".freebScroll", portletTag );
				result.forEach( function( item, idx ) {

					$(item).mCustomScrollbar({axis:"yx",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
				});

				// portlet 스크롤 초기화 호출
				var result = Pudd.querySelectAll( ".freebScrollX", portletTag );
				result.forEach( function( item, idx ) {

					$(item).mCustomScrollbar({axis:"x",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
				});

				// portlet 스크롤 초기화 호출
				var result = Pudd.querySelectAll( ".freebScrollY", portletTag );
				result.forEach( function( item, idx ) {

					$(item).mCustomScrollbar({axis:"y",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
				});
			});
		});
    </script>
</head>

<body class="ovh">
	<div class="pop_wrap">
	    <div class="pop_head">
	        <h1><%=BizboxAMessage.getMessage("TX000016087","포틀릿설정")%></h1>
	        <a href="#n" class="clo"><img src="/gw/js/portlet/Images/btn/btn_pop_clo01.png" alt="" /></a>
	    </div>			
	        
	    <div class="pop_con portletBg">
	    	<div class="portletGridWrap freebScroll">
				<div id="portlet"></div>
	    	</div>
	    	
	    	<!-- 1. EBP 하단 썸네일 태그 추가 -->
			<!-- portlet thumbnail -->
			<div class="portletThumbnail">
				<div class="portletList freebScrollX_dark">
					<ul class="clear">
						
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_mybox"
								><span>내정보</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_notice"
								><span>통합알림</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_board"
								><span>공지사항[CEO]</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_board_hr"
								><span>공지사항</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_inboxCeo"
								><span>받은편지함[CEO]</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_inbox"
								><span>받은편지함</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_calendar_horizontal"
								><span>일정캘린더</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_iframe_quick"
								><span>퀵링크</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_assetGrowthIndex"
								><span>자산성장성지표</span></li>	
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_inventoryStatus"
								><span>재고현황</span></li>	
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_bpNetProfit"
								><span>경영실적[당기순이익]</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_salesPerformance"
								><span>매출실적 현황</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_wehagoService"
								><span>WEHAGO 서비스</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_totalFundStatus"
								><span>총자금현황</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_boundAgeStatus"
								><span>채권연령현황</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_annualUseManage"
								><span>임직원 연차사용관리</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_weekWorkingHours"
								><span>금주 근무시간</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_myWorkStatus"
								><span>나의 근무현황</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_overTimeApplication"
								><span>연장근무신청</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_workingStatus"
								><span>근무현황</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_etcBox"
								><span>경비 포틀릿</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_requestJob"
								><span>업무요청</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_expectedSpendToday"
								><span>금일 주요 지출예정</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_divExpenseClaim"
								><span>부서별 경비청구 진행률</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_accountingEaProgress"
								><span>회계결재 진행현황</span></li>	
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_mainAccountionTask"
								><span>주요 회계업무</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_myCardUsageHistory"
								><span>나의카드 사용내역</span></li>	
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_salesByDepartment"
								><span>부서별 판매실적</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_salesTrend"
								><span>매출액 추이</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_salesStatus"
								><span>매출현황</span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_monthlySalesPerformance"
								><span>월간판매실적</span></li>													
				</div>
			</div>

			<!-- portlet templete -->
			<div class="portletTemplete" style="display:none;">

				<!-- iframe outer -->
				<textarea id="demo_portletTemplete_iframe_outer" style="display:none;">
					<!--<div class="ptl_content nocon">-->
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<!--<iframe id="" name="" src="http://gwa.duzon.com/" frameborder="0" scrolling="yes" width="100%" height="100%"></iframe>-->
					</div>
				</textarea>

				<!-- iframe banner -->
				<textarea id="demo_portletTemplete_iframe_banner" style="display:none;">
					<div class="ptl_content nocon">
						<!--<iframe id="" name="" src="i_banner.html" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>-->	
					</div>
				</textarea>

				<!-- iframe quick -->
				<textarea id="demo_portletTemplete_iframe_quick" style="display:none;">
					<div class="ptl_content nocon">
						<!--<iframe id="" name="" src="i_quick.html" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>-->	
					</div>
				</textarea>
				
				<!-- mybox -->
				<textarea id="demo_portletTemplete_mybox" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="userinfo">
							<!-- 접속자 정보 -->
							<div class="user">
								<div class="user_pic">
									<div class="bg_pic"></div>
									<span class="img_pic">
										<img src="/gw/js/portlet/Images/bg/pic_Noimg.png" alt="" />
									</span>				
								</div>
								<div class="mb10 name"><%=BizboxAMessage.getMessage("TX900000504","홍길동 대리")%></div>
								<div class="Scon_ts"><%=BizboxAMessage.getMessage("TX000010659","더존비즈온")%><br/><%=BizboxAMessage.getMessage("TX900000505","UC개발본부 > UC개발부> 개발1팀")%></div>
							</div>
							<!-- 출근/퇴근 -->
							<div class="worktime">
								<div id="container">
									<ul class="tabs">
										<li class="active" rel="tab1"><%=BizboxAMessage.getMessage("TX000000813","출근")%></li>
										<li rel="tab2"><%=BizboxAMessage.getMessage("TX000000814","퇴근")%></li>
									</ul>
									<div class="tab_container">
										<div id="tab1" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000000813","출근")%></em> 2015.03.31 <%=BizboxAMessage.getMessage("TX000006547","화요일")%> 08:31:09</div>
										<div id="tab2" class="tab_content" style="display:none"><em><%=BizboxAMessage.getMessage("TX000000814","퇴근")%></em> 2015.03.31 <%=BizboxAMessage.getMessage("TX000006547","화요일")%> 08:31:09</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</textarea>

				

				<!-- mail status -->
				<textarea id="demo_portletTemplete_mail_status" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ma">
						<span><%=BizboxAMessage.getMessage("TX000022828","메일현황")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="mdst">
							<ul>
								<li>
									<dl>
										<dt><%=BizboxAMessage.getMessage("TX000001580","받은편지함")%></dt>
										<dd><a href="#n" class="fwb"><span class="text_text">3</span> 건</a></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt><%=BizboxAMessage.getMessage("TX000022197","사용량")%></dt>
										<dd><a href="#n" class="fwb"><span class="text_blue">1%</span></a></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dd>( <span class="fwb">36.17KB</span> / 1GB )</dd>
									</dl>
								</li>
							</ul>
						</div>
					</div>
				</textarea>

				<!-- inbox -->
				<textarea id="demo_portletTemplete_inbox" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="rm">
						<span><%=BizboxAMessage.getMessage("TX000001580","받은편지함")%></span>
						<span class="text_gray">
							<span class="barline">|</span>
							<em class="text_blue">8</em>/120
						</span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_mail freebScrollY">
							<ul>
								<li class="unlead">
									<dl>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000532","메일 제목이 노출됩니다.")%></a></dt>
										<dd class="from_info"><%=BizboxAMessage.getMessage("TX000000705","관리자")%>(admin@douzone.com)</dd>
										<dd class="date">2018.01.01 17:51:33</dd>
									</dl>
								</li>
								<li class="unlead">
									<dl>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000532","메일 제목이 노출됩니다.")%></a></dt>
										<dd class="from_info"><%=BizboxAMessage.getMessage("TX000000705","관리자")%>(admin@douzone.com)</dd>
										<dd class="date">2018.01.01 17:51:33</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000532","메일 제목이 노출됩니다.")%></a></dt>
										<dd class="from_info"><%=BizboxAMessage.getMessage("TX000000705","관리자")%>(admin@douzone.com)</dd>
										<dd class="date">2018.01.01 17:51:33</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000532","메일 제목이 노출됩니다.")%></a></dt>
										<dd class="from_info"><%=BizboxAMessage.getMessage("TX000000705","관리자")%>(admin@douzone.com)</dd>
										<dd class="date">2018.01.01 17:51:33</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000532","메일 제목이 노출됩니다.")%></a></dt>
										<dd class="from_info"><%=BizboxAMessage.getMessage("TX000021350","관리자")%>(admin@douzone.com)</dd>
										<dd class="date">2018.01.01 17:51:33</dd>
									</dl>
								</li>
							</ul>
						</div>
					</div>
				</textarea>

				
				<!-- calendar horizontal -->
				<textarea id="demo_portletTemplete_calendar_horizontal" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="sc">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000000483","일정")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="ptl_calendar horizontal">
							<div class="calendar_wrap">
								<div class="select_date">
									<a title="이전" class="prev" href="#n"></a>
									<span id="">2015.08</span>
									<a title="다음" class="next" href="#n"></a>
								</div>
	
								<div  class="calender_ta" name="calenderTable">
								  <table cellspacing="0" cellpadding="0">
									<tbody>
									  <tr>
										<th class="sun"><%=BizboxAMessage.getMessage("TX000017876","일")%></th>
										<th><%=BizboxAMessage.getMessage("TX000018121","월")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000676","화")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000677","수")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000678","목")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000679","금")%></th>
										<th class="sat"><%=BizboxAMessage.getMessage("TX000000680","토")%></th>
									  </tr>
									  <tr>
										<td class="sun other_mon"><a name="26" title="">26</a></td>
										<td class="other_mon"><a name="27" title="">27</a></td>
										<td class="other_mon"><a name="28" title="">28</a></td>
										<td class="other_mon"><a name="29" title="">29</a></td>
										<td class="other_mon "><a name="30" title="" class="special_day">30</a></td>
										<td class="other_mon"><a name="31" title="">31</a></td>
										<td class="sat"><a name="1" title="" class="schedule">1</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="2" title="">2</a></td>
										<td><a name="3" title="">3</a></td>
										<td><a name="4" title="">4</a></td>
										<td><a name="5" title="">5</a></td>
										<td><a name="6" title="">6</a></td>
										<td><a name="7" title="">7</a></td>
										<td class="sat"><a name="8" title="">8</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="9" title="">9</a></td>
										<td><a name="10" title="">10</a></td>
										<td><a name="11" title="">11</a></td>
										<td><a name="12" title="">12</a></td>
										<td><a name="13" title="">13</a></td>
										<td><a name="14" title="" class="today">14</a></td>
										<td class="sat"><a name="15" title="">15</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="16" title="">16</a></td>
										<td><a name="17" title="">17</a></td>
										<td><a name="18" title="">18</a></td>
										<td><a name="19" title="">19</a></td>
										<td><a name="20" title="">20</a></td>
										<td><a name="21" title="">21</a></td>
										<td class="sat"><a name="22" title="">22</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="23" title="">23</a></td>
										<td><a name="24" title="">24</a></td>
										<td><a name="25" title="">25</a></td>
										<td><a name="26" title="">26</a></td>
										<td><a name="27" title="" class="selon">27</a></td>
										<td><a name="28" title="">28</a></td>
										<td class="sat"><a name="29" title="">29</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="30" title="">30</a></td>
										<td><a name="31" title="">31</a></td>
										<td class="other_mon"><a name="1" title="">1</a></td>
										<td class="other_mon"><a name="2" title="">2</a></td>
										<td class="other_mon"><a name="3" title="">3</a></td>
										<td class="other_mon"><a name="4" title="">4</a></td>
										<td class="other_mon sat"><a name="5" title="">5</a></td>
									  </tr>
									</tbody>
								  </table>
								</div>                
							</div>

							<div class="horizon_right">
								<!-- 항목셀렉트 -->
								<div class="calendar_select">
									<select class="puddSetup" pudd-style="width:211px;">
										<option value="total" selected="selected"><%=BizboxAMessage.getMessage("TX000010380","전체일정")%></option>
										<option value="indivi"><%=BizboxAMessage.getMessage("TX000004103","개인일정")%></option>
										<option value="share"><%=BizboxAMessage.getMessage("TX000010163","공유일정")%></option>
										<option value="special"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></option>
									</select>
								</div>

								<!-- 리스트 -->
								<div class="calendar_div st1" style="display:block">
									<h3>2017-02-01 <span class="fr mr20"><span class="text_blue">8</span><%=BizboxAMessage.getMessage("TX000000476","건")%></span></h3>
									<div class="calendar_list freebScrollY">
										<ul>
											<li>
												<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
												<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>
												<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
											</li>
											<li>
												<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
												<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>
												<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
											</li>
											<li>
												<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
												<span class="sign purple"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>
												<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
											</li>
											<li>
												<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
												<span class="sign purple"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>
												<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
											</li>
											<li>
												<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
												<span class="sign purple"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>
												<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
											</li>
										</ul>
									</div>
								</div><!--// calendar_div st1-->
							</div>
						</div>
					</div>
				</textarea>

				<!-- calendar vertical -->
				<textarea id="demo_portletTemplete_calendar_vertical" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="sc">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000000483","일정")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="ptl_calendar">
							<div class="calender_wrap">
								<div class="select_date">
									<a title="이전" class="prev" href="#n"></a>
									<span id="">2015.08</span>
									<a title="다음" class="next" href="#n"></a>
								</div>
	
								<div  class="calender_ta" name="calenderTable">
								  <table cellspacing="0" cellpadding="0">
									<tbody>
									  <tr>
										<th class="sun"><%=BizboxAMessage.getMessage("TX000017876","일")%></th>
										<th><%=BizboxAMessage.getMessage("TX000017875","월")%></th>
										<th><%=BizboxAMessage.getMessage("TX000017877","화")%></th>
										<th><%=BizboxAMessage.getMessage("TX000017878","수")%></th>
										<th><%=BizboxAMessage.getMessage("TX000017879","목")%></th>
										<th><%=BizboxAMessage.getMessage("TX000017880","금")%></th>
										<th class="sat"><%=BizboxAMessage.getMessage("TX000017881","토")%></th>
									  </tr>
									  <tr>
										<td class="sun other_mon"><a name="26" title="">26</a></td>
										<td class="other_mon"><a name="27" title="">27</a></td>
										<td class="other_mon"><a name="28" title="">28</a></td>
										<td class="other_mon"><a name="29" title="">29</a></td>
										<td class="other_mon "><a name="30" title="" class="special_day">30</a></td>
										<td class="other_mon"><a name="31" title="">31</a></td>
										<td class="sat"><a name="1" title="" class="schedule">1</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="2" title="">2</a></td>
										<td><a name="3" title="">3</a></td>
										<td><a name="4" title="">4</a></td>
										<td><a name="5" title="">5</a></td>
										<td><a name="6" title="">6</a></td>
										<td><a name="7" title="">7</a></td>
										<td class="sat"><a name="8" title="">8</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="9" title="">9</a></td>
										<td><a name="10" title="">10</a></td>
										<td><a name="11" title="">11</a></td>
										<td><a name="12" title="">12</a></td>
										<td><a name="13" title="">13</a></td>
										<td><a name="14" title="" class="today">14</a></td>
										<td class="sat"><a name="15" title="">15</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="16" title="">16</a></td>
										<td><a name="17" title="">17</a></td>
										<td><a name="18" title="">18</a></td>
										<td><a name="19" title="">19</a></td>
										<td><a name="20" title="">20</a></td>
										<td><a name="21" title="">21</a></td>
										<td class="sat"><a name="22" title="">22</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="23" title="">23</a></td>
										<td><a name="24" title="">24</a></td>
										<td><a name="25" title="">25</a></td>
										<td><a name="26" title="">26</a></td>
										<td><a name="27" title="" class="selon">27</a></td>
										<td><a name="28" title="">28</a></td>
										<td class="sat"><a name="29" title="">29</a></td>
									  </tr>
									  <tr>
										<td class="sun"><a name="30" title="">30</a></td>
										<td><a name="31" title="">31</a></td>
										<td class="other_mon"><a name="1" title="">1</a></td>
										<td class="other_mon"><a name="2" title="">2</a></td>
										<td class="other_mon"><a name="3" title="">3</a></td>
										<td class="other_mon"><a name="4" title="">4</a></td>
										<td class="other_mon sat"><a name="5" title="">5</a></td>
									  </tr>
									</tbody>
								  </table>
								</div>                
							</div>
							
							<!-- 항목셀렉트 -->
							<div class="calendar_select">
								<select class="puddSetup" pudd-style="width:211px;">
									<option value="total" selected="selected"><%=BizboxAMessage.getMessage("TX000010380","전체일정")%></option>
									<option value="indivi"><%=BizboxAMessage.getMessage("TX000004103","개인일정")%></option>
									<option value="share"><%=BizboxAMessage.getMessage("TX000010163","공유일정")%></option>
									<option value="special"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></option>
								</select>
							</div>
							
							<!-- 리스트 -->
							<div class="calendar_div st1" style="display:block">
								<h3>2017-02-01 <span class="fr mr20"><span class="text_blue">8</span><%=BizboxAMessage.getMessage("TX000000476","건")%></span></h3>
								<div class="calendar_list freebScrollY">
									<ul>
										<li>
											<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
											<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>
											<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
										</li>
										<li>
											<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
											<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>
											<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
										</li>
										<li>
											<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
											<span class="sign purple"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>
											<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
										</li>
										<li>
											<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
											<span class="sign purple"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>
											<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
										</li>
										<li>
											<span class="time">02-01 09:30 ~ 02-01 10:30</span> 
											<span class="sign purple"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>
											<span class="txt"><%=BizboxAMessage.getMessage("TX900000527","솔루션 업체 미팅솔루션 업체 미팅")%></span>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</textarea>
				
				<!-- 공지사항 -->
				<textarea id="demo_portletTemplete_board" style="display:none;">
					<div class="ptl_content nocon">
				    	<div class="ptc_box2">
				        <!-- 타이틀 영역 -->
				        	<div class="tit_div pb10">
				            	<h2 class="arr"><a href="#n">공지사항</a></h2>
				            </div>
				            <div class="ScrollY" style="height:184px;">
								<div class="exp_notice">
									<ul>
										<li class="new">통근버스노선표안내 <img src="/gw/ebp/Images/ico/icon_new.png" class="mtImg mCS_img_loaded" alt=""></li>
										<li>2017년 귀속분 연말정산 세법</li>
										<li>더존베이커리 2018년 1월 메뉴</li>
										<li>1월 3주차 주간메뉴 안내</li>
										<li>더존 ICT 그룹과 신라스테이 해</li>
										<li>AT 자격시험 기술감독관 교육</li>
									</ul>
								</div>
							</div>
				    	</div><!-- //ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>

				<!-- notice -->
				<textarea id="demo_portletTemplete_notice" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 통합알림/멘션 -->
						<div class="ptl_mention">
							<!-- 탭 -->
							<ul class="alert_tab clear">
								<li class="on">
									<a href="#n" onclick="return false;" class="tab01_portlet">
									<span class="ico"></span>								
									<span class="txt"><%=BizboxAMessage.getMessage("TX000022368","알림전체")%></span>
									<span class="new"></span>
									</a>
								</li>
								<li>
									<a href="#n" onclick="return false;" class="tab02_portlet">
									<span class="ico"></span>
									<span class="txt"><%=BizboxAMessage.getMessage("TX000021504","알파멘션")%></span>
									<span class="new"></span>
									</a>
								</li>
							</ul>					
			
							<div class="mentionCon freebScrollY">
								<!-- 알림전체 -->
								<div class="tabCon _tab01">
									<ul>                       
										<li class="dayline today"><span><%=BizboxAMessage.getMessage("TX000003149","오늘")%></span> 08.23 <%=BizboxAMessage.getMessage("TX000006548","수요일")%></li>
										<!-- 메일알림-->
										<li class="unread">
											<div class="icon mail"></div>
											<div class="list_con">
												<a href="#n" onclick="return false;" class="title" title="일정등록 홍길동"><%=BizboxAMessage.getMessage("TX900000525","일정등록 홍길동")%></a>
												<dl>
													<dt><%=BizboxAMessage.getMessage("TX900000526","테스트 제목영역")%></dt>
													<dd class="sub_detail">
													- <%=BizboxAMessage.getMessage("TX000001467","받는사람")%> : <%=BizboxAMessage.getMessage("TX000020245","홍길동")%>(kim@douzone.com),<%=BizboxAMessage.getMessage("TX000020245","홍길동")%>(park@douzone.com)<br />
													- <%=BizboxAMessage.getMessage("TX000022377","내용")%> : <%=BizboxAMessage.getMessage("TX000001562","메일내용 밑에 자신만의 서명을 첨부하여 보낼 수 있습니다.")%>
													</dd>
												</dl>
											</div>
											<div class="list_fn">
												<span class="date">10:36</span>
												<a href="#n" onclick="return false;" class="toggle_btn"></a>
											</div>
										</li>
			
										<!-- 결재알림-->
										<li class="unread">
											<div class="icon ea"></div>
											<!-- 내용 -->
											<div class="list_con">
												<a href="#n" onclick="return false;" class="title" title="전자결재 홍길동"><%=BizboxAMessage.getMessage("TX900000519","전자결재 홍길동")%></a>
												<dl>
													<dt><%=BizboxAMessage.getMessage("TX900000524","전자결재 새로운 결재가 도착하였습니다.")%></dt>
													<dd class="sub_detail">
														- <%=BizboxAMessage.getMessage("TX900000523","품의번호 : 더존비즈온-포털-16-00003")%><br />
														- <%=BizboxAMessage.getMessage("TX900000516","제목 : 연차휴가 신청의 건")%><br />
														- <%=BizboxAMessage.getMessage("TX900000521","작성일자 : 2016.03.10 09:30")%><br />
														- <%=BizboxAMessage.getMessage("TX900000520","기안부서/기안자 : 포털/박길동 연구원")%>
													</dd>
												</dl>
											</div>
											<!-- 날짜 및 펼침버튼-->
											<div class="list_fn">
												<span class="date">10:36</span>
												<a href="#n" onclick="return false;" class="toggle_btn"></a>
											</div>
										</li>
									
			
										<li class="dayline"><span>08.22</span><%=BizboxAMessage.getMessage("TX000006547","화요일")%></li>                                    
										<!-- 메일알림-->
										<li class="unread">
											<div class="pic_wrap">
												<div class="pic"></div>
												<div class="div_img">
													<!-- <img src="/gw/js/portlet/Images/bg/pic_Noimg.png" alt=""> -->
													<img src="/gw/js/portlet/Images/temp/temp_pic.png" alt="">
												</div>
											</div>
											<div class="list_con">
												<a href="#n" onclick="return false;" class="title" title="일반대화방 박철민"><%=BizboxAMessage.getMessage("TX900000517","일반대화방 해바라기")%></a>
												<dl>
													<dt><span class="ea"></span><%=BizboxAMessage.getMessage("TX900000516","방화벽 서버 구매요청의 건")%></dt> <!-- 필요 없을 시 삭제 -->
													<dd class="mention_detail ellipsis">
														<span class="msg"></span>
														<span class="mt_marking"><%=BizboxAMessage.getMessage("TX900000506","@홍길동")%></span> <%=BizboxAMessage.getMessage("TX900000505","대리님 결재라인이 잘못되었습니다.")%>
														<a href="#n" onclick="return false;" class="more_btn"><%=BizboxAMessage.getMessage("TX900000518","상세보기")%></a>
													</dd>
												</dl>
											</div>
											<div class="list_fn">
												<span class="date">10:36</span>
												<a href="#n" onclick="return false;" class="toggle_btn"></a>
											</div>
										</li>
										<!-- 메일알림-->
										<li class="unread">
											<div class="pic_wrap">
												<div class="pic"></div>
												<div class="div_img">
													<img src="/gw/js/portlet/Images/bg/pic_Noimg.png" alt="">
												</div>
											</div>
											<div class="list_con">
												<a href="#n" onclick="return false;" class="title" title="일반대화방 박철민"><%=BizboxAMessage.getMessage("TX900000517","일반대화방 해바라기")%></a>
												<dl>
													<dt><span class="ea"></span><%=BizboxAMessage.getMessage("TX900000516","방화벽 서버 구매요청의 건")%></dt> <!-- 필요 없을 시 삭제 -->
													<dd class="mention_detail ellipsis">
														<span class="msg"></span>
														<span class="mt_marking"><%=BizboxAMessage.getMessage("TX900000506","@홍길동")%></span> <%=BizboxAMessage.getMessage("TX900000505","대리님 결재라인이 잘못되었습니다.")%>
														<a href="#n" onclick="return false;" class="more_btn"><%=BizboxAMessage.getMessage("TX900000518","상세보기")%></a>
													</dd>
												</dl>
											</div>
											<div class="list_fn">
												<span class="date">10:36</span>
												<a href="#n" onclick="return false;" class="toggle_btn"></a>
											</div>
										</li>
									</ul>
								</div>
			
								<!-- 알파멘션 -->
								<div class="tabCon _tab02" style="display:none;">
									<ul>													
										<li class="unread">
											<div class="pic_wrap">
												<div class="pic"></div>
												<div class="div_img">
													<img src="/gw/js/portlet/Images/bg/pic_Noimg.png" alt="">
												</div>
											</div>
											<div class="list_con">
												<a href="#n" onclick="return false;" class="title" title="[일반대화방] 홍길동님의 알파멘션"><%=BizboxAMessage.getMessage("TX900000513","[일반대화방] 이정미님의 알파멘션")%></a>
												<dl>
													<dd class="mention_detail ellipsis">
														<span class="msg"></span>
														<span class="mt_marking"><%=BizboxAMessage.getMessage("TX900000506","@홍길동")%></span> <%=BizboxAMessage.getMessage("TX900000505","대리님 결재라인을 잘못 올렸습니다.")%>
													</dd>
												</dl>
											</div>
											<div class="list_fn">
												<span class="date">10:36</span>
												<a href="#n" onclick="return false;" class="toggle_btn"></a>
											</div>
										</li>
										 <li class="unread">
											<div class="pic_wrap">
												<div class="pic"></div>
												<div class="div_img">
													<img src="/gw/js/portlet/Images/bg/pic_Noimg.png" alt="">
												</div>
											</div>
											<div class="list_con">
												<a href="#n" onclick="return false;" class="title" title="[프로젝트대화방] 홍길동님의 알파멘션"><%=BizboxAMessage.getMessage("TX900000513","[프로젝트대화방] 이정미님의 알파멘션")%></a>
												<dl>
													<dd class="mention_detail ellipsis">
														<span class="promsg"></span>
														<span class="mt_marking"><%=BizboxAMessage.getMessage("TX900000506","@홍길동")%></span> <%=BizboxAMessage.getMessage("TX900000505","대리님 결재라인을 잘못 올렸습니다.")%>
													</dd>
												</dl>
											</div>
											<div class="list_fn">
												<span class="date">10:36</span>
												<a href="#n" onclick="return false;" class="toggle_btn"></a>
											</div>
										</li>
									</ul>
								</div>	
								<!-- 태그날짜 :: 사용자 스크롤 시 나타났다 사라지며, 날짜선을 기준으로  .tag_date_c의 값이 변경되어야 합니다. -->
								<div class="tag_date">
									<span class="tag_date_l"></span>
									<span class="tag_date_c">17.02.20 월</span>
									<span class="tag_date_r"></span>
								</div>
							</div>				
						</div>
					</div>
				</textarea>
				
				<!-- 자산성장성지표 -->
				<textarea id="demo_portletTemplete_assetGrowthIndex" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
				    	<div class="ptc_box2">
				            <!-- 타이틀 영역 -->
				            <div class="tit_div">
				              <h2 class="">자산성장성지표 <span class="so">(단위:%)</span></h2>
				            </div>
				            <div class="pt_gr_ta2">
				                <table>
				                  <tbody><tr>
				                    <td>
				                      <div class="gr_div" style="width:200px;height:125px;">
				                        <img src="/gw/ebp/Images/temp/img_graph03.png" alt="" class="">
				                      </div>
				                    </td>
				                  </tr>
				                  <tr>
				                    <td>
				                      <div class="bum_list">
				                        <ul>
				                          <li class="li1">총자산증가율</li>
				                          <li class="li2">유동자산증가율</li>
				                          <li class="li3">유형자산증가율</li>
				                          <li class="li4">자기자본증가율</li>
				                        </ul>
				                      </div>
				
				                    </td>
				                  </tr>
				                </tbody></table>
				            </div>
				          </div><!--// ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
				
				<!-- 재고현황 -->
				<textarea id="demo_portletTemplete_inventoryStatus" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptc_box2">
			            <!-- 타이틀 영역 -->
			            <div class="tit_div">
			              <h2 class="">재고현황 <span class="so">(단위:백만)</span></h2>
			            </div>
			            <div class="pt_gr_ta2">
			                <table>
			                  <tbody><tr>
			                    <td>
			                      <div class="gr_div" style="width:200px;height:125px;">
			                        <img src="/gw/ebp/Images/temp/img_graph04.png" alt="" class="" style="height:auto;margin-top:28px"><!--이미지 스타일 넣은것은 시연용 개발시 삭제-->
			                      </div>
			                    </td>
			                  </tr>
			                  <tr>
			                    <td>
			                      <div class="bum_list2">
			                        <ul>
			                          <li class="li1">
			                            <dl>
			                              <dt>이월재고</dt>
			                              <dd>32,123</dd>
			                            </dl>
			                          </li>
			                          <li class="li2">
			                            <dl>
			                              <dt>현재재고</dt>
			                              <dd>32,123</dd>
			                            </dl>
			                          </li>
			                          <li class="li3">
			                            <dl>
			                              <dt>평균재고</dt>
			                              <dd>32,123</dd>
			                            </dl>
			                          </li>
			                        </ul>
			                      </div>
			
			                    </td>
			                  </tr>
			                </tbody></table>
			            </div>
			          </div><!--// ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
				
				<!-- WEHAGO 서비스 -->
				<textarea id="demo_portletTemplete_wehagoService" style="display:none;">
						<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
		                <div class="ebp_menu">
		                  <div class="em_head">
		                    <ul>
		                      <li class="on" style="background:none;"><a href="#n">WEHAGO 서비스</a></li>
		                    </ul>
		                  </div>
		                  <div class="em_con2">
		                      <!--
		                      wt = WE톡
		                      kc = 경비청구
		                      rt = 10분독서
		                      plus = plus
		                    -->
		                      <ul>
		                        <li class="wt">
		                          <a href="https://www.wehago.com/#/communication2/talk">
		                            <span class="ico_div"></span>
									<span class="ico_bg"></span>
		                            <span class="txt_div">WE톡</span>
		                          </a>
		                        </li>
		                        <li class="kc">
		                          <a href="https://www.wehago.com/#/expense/cardstatement">
		                            <span class="ico_div"></span>
									<span class="ico_bg"></span>
		                            <span class="txt_div">경비청구</span>
		                          </a>
		                        </li>
		                        <li class="rt">
		                          <a href="https://www.wehago.com/#/10mbook">
		                            <span class="ico_div"></span>
									<span class="ico_bg"></span>
		                            <span class="txt_div">10분 독서</span>
		                          </a>
		                        </li>
		                        <li class="plus">
		                          <a href="#n">
		                            <span class="ico_div"></span>
									<span class="ico_bg"></span>
		                          </a>
		                        </li>
		                      </ul>
		                  </div>
		                </div>
					</div>
				</textarea>
				
				<!-- 매출실적현황 -->
				<textarea id="demo_portletTemplete_salesPerformance" style="display:none;">
						<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
				            <div class="ptc_box2">
				            <!-- 타이틀 영역 -->
							<div class="tit_div">
								<h2 class="">2018 매출실적현황</h2>
							</div>
				            <div class="pt_gr_ta1">
				                <table>
				                  <colgroup>
				                    <col width="240">
				                    <col width="">
				                  </colgroup>
				                  <tbody><tr>
				                    <td class="ac">
				                      <div class="gr_div" style="width:210px;height:187px;">
				                        <img src="/gw/ebp/Images/temp/img_graph01.png" alt="" class="">
				                      </div>
				                    </td>
				                    <td>
				                        <div class="pgt_list">
				                            <ul>
				                              <li class="li1">
				                                <dl>
				                                  <dt>목표금액</dt>
				                                  <dd>1,125,000,000</dd>
				                                </dl>
				                              </li>
				                              <li class="li2">
				                                <dl>
				                                  <dt>실적금액</dt>
				                                  <dd>125,000,000</dd>
				                                </dl>
				                              </li>
				                              <li class="li3">
				                                <dl>
				                                  <dt>미달금액</dt>
				                                  <dd>1,000,000,000</dd>
				                                </dl>
				                              </li>
				                            </ul>
				                        </div>
				                    </td>
				                  </tr>
				                </tbody></table>
				            </div>
						</div><!--// ptc_box2 -->
					</div><!--// ptl_content -->
				</textarea>
				
				<!-- 경영실적 당기순이익 -->
				<textarea id="demo_portletTemplete_bpNetProfit" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptc_box2">
			            <!-- 타이틀 영역 -->
			            <div class="tit_div">
			              <h2 class="let1">경영실적[당기순이익] <span class="so">(단위:억원)</span></h2>
			            </div>
			            <div class="pt_gr_ta2">
			                <table>
			                  <tbody><tr>
			                    <td>
			                      <div class="gr_div" style="width:220px;height:157px;margin-top:25px;">
			                        <img src="/gw/ebp/Images/temp/img_graph05.png" alt="" class="" style=""><!--이미지 스타일 넣은것은 시연용 개발시 삭제-->
			                      </div>
			                    </td>
			                  </tr>
			                </tbody></table>
			            </div>
			          </div><!--// ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
				
				<!-- 총자금현황 -->
				<textarea id="demo_portletTemplete_totalFundStatus" style="display:none;">
					<div class="ptl_content nocon">
						<div class="total_mn">
			                <div class="tmn_head">
			                  <h2 style="color:white">총자금현황</h2>
			                  <div class="txt_dl">
			                    <dl>
			                      <dt>기준일자</dt>
			                      <dd class="ml5">2016.07.01&nbsp;am 09:00:00</dd>
			                    </dl>
			                  </div>
			                </div>
			                <div class="tmn_con">
			                  <table>
			                    <colgroup>
			                      <col width="50%">
			                      <col width="">
			                    </colgroup>
			                    <tbody>
								<tr>
			                      <td class="pr10">
			                          <a href="#n" class="now_tmn">
			                            <span>현재시재액</span>
			                          </a>
			                          <div class="mn_div">
			                            13,554,660
			                          </div>
			                          <div class="tmn_ul">
			                            <ul>
			                              <li>
			                                <dl>
			                                  <dt>당일 예상 시재액</dt>
			                                  <dd class="fwb f18">12,674,000</dd>
			                                </dl>
			                              </li>
			                              <li>
			                                <dl>
			                                  <dt>시재액 구성비(%)</dt>
			                                  <dd class="fl ar" style="width:87px;margin-left:38px;"><span class="f13 mr5">현금</span><span class="f18 fwb">25</span><span>%</span></dd>
			                                  <dd><span class="f13 mr5">예적금</span><span class="f18 fwb">50</span><span>%</span></dd>
			                                </dl>
			                              </li>
			                            </ul>
			                          </div>
			                      </td>
			                      <td class="pl10">
			                        <div class="tmn_ul bk_ul">
			                          <ul>
			                            <li>
			                              <dl>
			                                <dt>순 채권금액</dt>
			                                <dd class="fwb f18">12,674,000</dd>
			                              </dl>
			                            </li>
			                            <li>
			                              <dl>
			                                <dt>매출액 <span class="f13">해당일</span></dt>
			                                <dd class="fl ar" style="width:92px;margin-left:38px;"><span class="mr5">전일대비</span><span class="down">10%</span></dd>
			                                <dd class="blue_dd">1,000,000</dd>
			                              </dl>
			                            </li>
			                          </ul>
									  <div class="bg_tmn"></div>
			                        </div>
			
			                        <div class="tmn_ul bk_ul mt5">
			                          <ul>
			                            <li>
			                              <dl>
			                                <dt>순 금융자산</dt>
			                                <dd class="fwb f18">12,674,000</dd>
			                              </dl>
			                            </li>
			                            <li>
			                              <dl>
			                                <dt>매출액 <span class="f13">해당일</span></dt>
			                                <dd class="fl ar" style="width:92px;margin-left:38px;"><span class="mr5">전일대비</span><span class="up">10%</span></dd>
			                                <dd class="red_dd">1,000,000</dd>
			                              </dl>
			                            </li>
			                          </ul>
									  <div class="bg_tmn"></div>
			                        </div>
			                      </td>
			                    </tr>
			                  </tbody></table>
			                </div>
			            </div>
					</div>
				</textarea>
				
				<!-- 부서판매실적 -->
				<textarea id="demo_portletTemplete_boundAgeStatus" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptc_box2">
			            <!-- 타이틀 영역 -->
			  					<div class="tit_div">
			  						<h2 class="">채권연령현황</h2>
			  					</div>
			            <div class="pt_gr_ta1">
			                <table>
			                  <colgroup>
			                    <col width="310">
			                    <col width="">
			                  </colgroup>
			                  <tbody><tr>
			                    <td class="ac">
			                      <div class="gr_div" style="width:240px;height:156px;">
			                        <img src="/gw/ebp/Images/temp/img_graph02.png" alt="" class="">
			                      </div>
			                    </td>
			                    <td>
			                      <div class="cg_list">
			                        <ul>
			                          <li class="li1">
			                            <dl>
			                              <dt>채권회전율</dt>
			                              <dd>11.8<span class="dan">%</span></dd>
			                            </dl>
			                          </li>
			                          <li class="li2">
			                            <dl>
			                              <dt>채권회전일</dt>
			                              <dd>30.8<span class="dan">일</span></dd>
			                            </dl>
			                          </li>
			                        </ul>
			                      </div>
			                    </td>
			                  </tr>
			                </tbody></table>
			            </div>
			            </div><!--// ptc_box2 -->
					</div><!--// ptl_content -->
				</textarea>
			
							
				<!-- 임직원연차사용관리 -->
				<textarea id="demo_portletTemplete_annualUseManage" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="wk">
						<span>임직원 연차사용관리</span>
					</h2>
					<div class="ptl_content">							
						<div class="hraum">	
							<p class="graph"><img src="/gw/ebp/Images/temp/hr_aumgraph.png" alt=""/></p>
							<div class="graph_con">
								<ul>
									<li class="gbg red">조치필요</li>
									<li class="text" style="width:89px;">홍길동 외 8명</li>
									<li class="percent">30%</li>
								</ul>
								<ul>
									<li class="gbg yellow">관리필요</li>
									<li class="text" style="width:89px;">김더존 외 5명</li>
									<li class="percent">25%</li>
								</ul>
								<ul>
									<li class="gbg green">양호</li>
									<li class="text" style="width:89px;">이양호 외 25명</li>
									<li class="percent">45%</li>
								</ul>
							</div>
						</div>
					</div>
				</textarea>
				
				<!-- 금주 근무시간 -->
				<textarea id="demo_portletTemplete_weekWorkingHours" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="wt">
						<span>금주 근무시간</span>
					</h2>
					<div class="ptl_content">					
						<div class="weektime"><img src="/gw/ebp/Images/temp/hr_weektime.png" alt=""/></div>
					</div>		
				</textarea>
				
				<!-- 나의 근무현황 -->
				<textarea id="demo_portletTemplete_myWorkStatus" style="display:none;">
					<h2 class="ws">
						<span>나의 근무현황</span>
						<span class="myworkst_tab">
							<ul>
								<li class="on"><a href="#n" onclick="return false;" class="tab01">주별</a></li>
								<li><a href="#n" onclick="return false;" class="tab02">월별</a></li>
								<li><a href="#n" onclick="return false;" class="tab03">년도별</a></li>
							</ul>
						</span>
					</h2>					
					<div class="ptl_content">
						<!-- 주별 -->
						<div class="myworkst">
							<div class="tabcon _tab01">
								<div class="graph"><img src="/gw/ebp/Images/temp/myworkst_graph01.png" alt=""/></div>
								<div class="wstype">
									<dl class="type01">
										<dt>기본근무</dt>
										<dd>32시간</dd>
									</dl>
									<dl class="type02">
										<dt><span></span>연장근무</dt>
										<dd>7시간</dd>
									</dl>
									<dl class="type03">
										<dt><span></span>휴일근무</dt>
										<dd>6시간</dd>
									</dl>
								</div>
							</div>						
						
							<!-- 월별 -->
							<div class="tabcon _tab02" style="display:none;">
								<div class="graph"><img src="/gw/ebp/Images/temp/myworkst_graph02.png" alt=""/></div>
								<div class="wstype">
									<dl class="type01">
										<dt>기본근무</dt>
										<dd>132시간</dd>
									</dl>
									<dl class="type02">
										<dt><span></span>연장근무</dt>
										<dd>20시간</dd>
									</dl>
									<dl class="type03">
										<dt><span></span>휴일근무</dt>
										<dd>6시간</dd>
									</dl>
								</div>
							</div>

							<!-- 년도별 -->
							<div class="tabcon _tab03" style="display:none;">
								<div class="graph"><img src="/gw/ebp/Images/temp/myworkst_graph03.png" alt=""/></div>
								<div class="wstype">
									<dl class="type01">
										<dt>기본근무</dt>
										<dd>1232시간</dd>
									</dl>
									<dl class="type02">
										<dt><span></span>연장근무</dt>
										<dd>100시간</dd>
									</dl>
									<dl class="type03">
										<dt><span></span>휴일근무</dt>
										<dd>40시간</dd>
									</dl>
								</div>
							</div>

						</div>
					</div>
				</textarea>
				
				<!-- 연장근무 신청 -->
				<textarea id="demo_portletTemplete_overTimeApplication" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>연장근무신청</span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content">							
						<div class="overtime">
							<div class="select">
								<select style="width:100%;">
									<option value="total">전체일정</option>
									<option value="indivi" selected="selected">개인일정</option>
								</select>
							</div>
							<div class="overtimeCon ScrollY" style="height:150px;">
								<ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">홍길동 사원 <span class="text_blue">2시간</span></p>
											<p class="dd">클라우드 전략 보고서 작성</p>
										</a>
									</li>
									<li class="box bg01">대기</li>									
								</ul>
								<ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">이정미 선임 <span class="text_blue">2시간</span></p>
											<p class="dd">Bizbox Alpha 근태관리 화면설계</p>
										</a>
									</li>
									<li class="box bg01">대기</li>									
								</ul>
								<ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">이준혁 주임 <span class="text_blue">2시간</span></p>
											<p class="dd">UC설계팀 주간업무보고서 취합</p>
										</a>
									</li>
									<li class="box bg02">승인</li>									
								</ul>
								<!-- <ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">정현석 과장 <span class="text_blue">2시간</span></p>
											<p class="dd">UC기획팀 주간업무보고서 취합</p>
										</a>
									</li>
									<li class="box bg02">승인</li>									
								</ul> -->
							</div>
						</div>
					</div>	
				</textarea>
				
				<!-- 근무현황 -->
				<textarea id="demo_portletTemplete_workingStatus" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>근무현황</span>
						<span class="ws_more"><a href="#n" class="more" title="더보기">UC기획부</a></span>						
					</h2>
					
					<div class="ptl_content">
						<div class="workst">
							<ol class="bxslider">
								<li>
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											
											<!-- 반복 -->
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>홍길동 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:60%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<!-- //반복 -->

											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이정미 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:50%"></span>
														<span class="col2" style="width:20%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이준혁 주임 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:10%"></span>
														<span class="col2" style="width:20%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>정현석 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:60%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>정명호 차장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:30%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>배현규 사원 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:10%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
								</li>
								<li>
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>김민진 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:20%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>정유민 사원 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:10%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이시은 사원 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:40%"></span>
														<span class="col2" style="width:10%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>허정명 주임 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:50%"></span>
														<span class="col2" style="width:40%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이홍직 수석<span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:20%"></span>
														<span class="col2" style="width:80%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>김재택 차장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:30%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
								</li>
							</ol>
						</div>
					</div>
				</textarea>
				
				<!-- etcBox 경비지출, 재직증명서, 급여내역조회, 개인연말정산 -->
				<textarea id="demo_portletTemplete_etcBox" style="display:none;">
					<div class="portletBox_link">
						<p>
							<a href="#n" class="link01">경비지출</a>
							<a href="#n" class="link03">재직증명서</a>
						</p>
						<p class="pt20">						
							<a href="#n" class="link03">급여내역조회</a>
							<a href="#n" class="link04">개인연말정산</a>
						</p>
					</div>
				</textarea>
				
				<!-- 인사포틀릿(인사담당자) -->
				<textarea id="demo_portletTemplete_board_hr" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span>공지사항</span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content ScrollY">		
						<div class="exp_notice">
							<ul>
								<li class="new"><a href="#n">통근버스노선표안내 <img src="/gw/ebp/Images/ico/icon_new.png" class="mtImg" alt=""/></a></li>
								<li><a href="#n">2017년 귀속분 연말정산 세법</a></li>
								<li><a href="#n">더존베이커리 2018년 1월 메뉴</a></li>
								<li><a href="#n">1월 3주차 주간메뉴 안내</a></li>
								<li><a href="#n">통근버스 노선안내 (노선표 첨부 / 2018. 12. 03(월)부터 시행.)</a></li>
								<li><a href="#n">AT 자격시험 기술감독관 교육</a></li>

							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 업무요청 -->
				<textarea id="demo_portletTemplete_requestJob" style="display:none;">
					<h2 class="wk">
						<span>업무요청</span>
					</h2>
					<div class="ptl_content">
						<div class="JobRequest">
							<ul>
								<li class="bg01">
									<p>경비청구 </br><em>15</em>건</p>
								</li>
								<li class="bg02">
									<span>긴급</span>
									<p>증명서신청 </br><em>15</em>건</p>
								</li>
								<li class="bg03">
									<p>세금계산서 </br><em>15</em>건</p>
								</li>
								<li class="bg04">
									<p>전자계약 </br><em>15</em>건</p>
								</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 금일 주요 지출예정 -->
				<textarea id="demo_portletTemplete_expectedSpendToday" style="display:none;">
					<h2 class="exp">
						<span>금일 주요 지출예정(06/01)</span>
						<span class="exp_more">이체내역</span>
					</h2>					
					<div class="ptl_content">
						<div class="exp_today ScrollY">
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img01.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">06월 직원급여 외 5건</a></li>
								<li class="btn blue">지출완료</li>
							</ul>
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img02.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">외주 용역비 외 3건</a></li>
								<li class="btn red">지출대기</li>
							</ul>
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img03.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">건물임대료 외 4건</a></li>
								<li class="btn red">지출대기</li>
							</ul>
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img04.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">판매수수료 지급 외 11건</a></li>
								<li class="btn gray">지급보류</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 부서별 경비청구 진행률 -->
				<textarea id="demo_portletTemplete_divExpenseClaim" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="exp">
						<span>부서별 경비청구 진행률</span>
					</h2>
					<div class="ptl_content">

						<ul class="exp_progress">
							<li class="graph"><img src="/gw/ebp/Images/temp/ebpExpMain_ptl01.jpg" alt=""/></li>
							<li class="fl mt30 mr20">
								<dl>
									<dt>
										<span class="num">1</span>
										<span>영업사업1팀</span>
										<span class="cl price">100,000,000</span>
									</dt>
									<dd style="width:170px;">
										<div class="progress-linear">
											<div class="progressBg">
												<div class="bar" style="width:100%; background:#5f80e9; border-radius:0px;">
													<span class="percent">100%</span>
												</div>
											</div>
										</div>
									</dd>
								</dl>
								<dl>
									<dt>
										<span class="num">2</span>
										<span>마케팅1팀</span>
										<span class="cl price">100,000,000</span>
									</dt>
									<dd style="width:170px;">
										<div class="progress-linear">
											<div class="progressBg">
												<div class="bar" style="width:72%; background:#6199ff;">
													<span class="percent">72%</span>
												</div>
											</div>
										</div>
									</dd>
								</dl>
								<dl>
									<dt>	
										<span class="num">3</span>
										<span>개발1팀</span>
										<span class="cl price">100,000,000</span>
									</dt>
									<dd style="width:170px;">
										<div class="progress-linear">
											<div class="progressBg">
												<div class="bar" style="width:56%; background:#6fa7f2;">
													<span class="percent">56%</span>
												</div>
											</div>
										</div>
									</dd>
								</dl>
							</li>
						</ul>
					</div>
				</textarea>
				
				<!-- 회계결재 진행현황 -->
				<textarea id="demo_portletTemplete_accountingEaProgress" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ea">
						<span>회계결재 진행현황</span>
					</h2>
					<div class="ptl_content">
						<div class="exp_status">
							<p class="graph"><img src="/gw/ebp/Images/temp/exp_ea.jpg" alt=""/></p>
							<div class="list">
								<ul>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">2018년 5월 자금일보</a>
										<span class="btn blue">완료</span>
									</li>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">영업팀 자금계획 결재의 건</a>
										<span class="btn red">결재중</span>
									</li>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">2017 회계감사자료 지출결의</a>
										<span class="btn purple">상신</span>
									</li>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">자금이체 관련 결재의 건</a>
										<span class="btn blue">완료</span>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</textarea>
				
				<!-- 주요회계업무 -->
				<textarea id="demo_portletTemplete_mainAccountionTask" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span>주요 회계업무</span>
					</h2>
					<div class="ptl_content">
						<div class="exp_major">
							<ul>
								<li class="list"><a href="#n"><span class="major01"></span>월말 결산보고</a></li>
								<li class="day red">1일전</li>
							</ul>
							<ul>
								<li class="list"><a href="#n"><span class="major02"></span>부가세 마감신고</a></li>
								<li class="day red">3일전</li>
							</ul>
							<ul>
								<li class="list"><a href="#n"><span class="major03"></span>고용/산재 변경신고</a></li>
								<li class="day blue">06/20</li>
							</ul>
							<ul>
								<li class="list"><a href="#n"><span class="major04"></span>출장자 마감보고</a></li>
								<li class="day blue">06/25</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 나의카드 사용내역 포틀릿(DEMO) -->
				<textarea id="demo_portletTemplete_myCardUsageHistory" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="cd">
						<span>나의카드 사용내역</span>
					</h2>
					<div class="ptl_content">					
						<div class="ptl_card">
							<div class="card_div">
								<div class="card_div_in">
									<h3 class="sh">신한카드</h3>
									<div class="card_ta">
									<table cellspacing="0" cellpadding="0" border="0">
										<colgroup>
											<col width="75">
											<col width="">
										</colgroup>
										<tr>
											<td>
												<div class="ic"></div>
											</td>
											<td class="td_txt">
												<ul>
													<li class="won">10,000,000,000</li>
													<li class="gun">
														<dl>
															<dt>건수</dt>
															<dd><span class="text_blue">25</span>건</dd>
														</dl>
													</li>
												</ul>
											</td>
										</tr>
										<tr>
											<td colspan="2" class="td_btm">
												<ul>
													<li class="na">LIM HYUNSIK</li>
													<li class="so">GOOD<br>THUR</li>
													<li class="dat">09/24</li>
													<li class="mas">
														<span></span>
													</li>
												</ul>
											</td>
										</tr>
									</table>
								</div>
							</div>
							</div>
								<div class="hang_div">
									<ul>
										<li>
											<dl>
												<dt>접대비</dt>
												<dd>20,000</dd>
											</dl>
										</li>
									</ul>
								</div>
							</div>
						</div>					
				  </textarea>
				  
				  <!-- 부서별 판매실적 포틀릿(DEMO) -->
				  <textarea id="demo_portletTemplete_salesByDepartment" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>부서별판매실적</span>
					</h2>
					<div class="ptl_content">		
					  <div class="gr_div" style="width:226px;height:177px;">
						<img src="/gw/ebp/Images/temp/img_graph07.png" alt="" class="">
					  </div>
					</div>				
				</textarea>
				 
				<!-- 매출액 추이 포틀릿(DEMO)	 -->
				<textarea id="demo_portletTemplete_salesTrend" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>매출액추이</span>
					</h2>
					<div class="ptl_content">
						<div class="ptl_adv_list">
							<ul>
								<li>
									<dl class="dl1">
										<dt>해당일</dt>
										<dd class="red">1,000,000</dd>
									</dl>
									<dl class="dl2">
										<dt>2019.05</dt>
										<dd>
											<span class="txt">전녀대비</span>
											<span class="down">10%</span>	
										</dd>
									</dl>
								</li>
								<li>
									<dl class="dl1">
										<dt>해당월</dt>
										<dd class="red">250,000,000</dd>
									</dl>
									<dl class="dl2">
										<dt>2019.05</dt>
										<dd>
											<span class="txt">전녀대비</span>
											<span class="up">10%</span>	
										</dd>
									</dl>
								</li>
								<li>
									<dl class="dl1">
										<dt>해당년</dt>
										<dd class="red">1,020,250,000</dd>
									</dl>
									<dl class="dl2">
										<dt>2019.05</dt>
										<dd>
											<span class="txt">전녀대비</span>
											<span class="up">40%</span>	
										</dd>
									</dl>
								</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 매출현황 포틀릿(DEMO) -->
				<textarea id="demo_portletTemplete_salesStatus" style="display:none;">
					<h2 class="ws">
						<span>매출현황</span>
						<div class="year_div">
							<ul>
								<li><span class="col" style="background:#f89e9c"></span> <span class="txt">2018년</span></li>
								<li><span class="col" style="background:#f35d5a"></span> <span class="txt">2019년</span></li>
							</ul>
						</div>
					</h2>
					<div class="ptl_content">
						<div class="ptl_adv">
							<div class="adv_div">
								<div class="txt">
									<dl>
										<dt>전년대비</dt>
										<dd class="down">10%</dd>
									</dl>
								</div>
								<div class="gr_div" style="width:130px;height:120px;">
									<img src="/gw/ebp/Images/temp/img_graph08_1.png" alt="" class="">
								</div>
							</div>
							<div class="adv_div">
								<div class="txt">
									<dl>
										<dt>전년대비</dt>
										<dd class="up">10%</dd>
									</dl>
								</div>
								<div class="gr_div" style="width:130px;height:120px;">
									<img src="/gw/ebp/Images/temp/img_graph08_2.png" alt="" class="">
								  </div>
							</div>
							<div class="adv_div">
								<div class="txt">
									<dl>
										<dt>전년대비</dt>
										<dd class="up">45%</dd>
									</dl>
								</div>
								<div class="gr_div" style="width:130px;height:120px;">
									<img src="/gw/ebp/Images/temp/img_graph08_3.png" alt="" class="">
								  </div>
							</div>
						</div>
					</div>
				</textarea>
				
				<!-- 월간판매실적 포틀릿 -->
				<textarea id="demo_portletTemplete_monthlySalesPerformance" style="display:none;">
					<h2 class="ws">
						<span>월간판매실적</span>
					</h2>					
					<div class="ptl_content">
						<div class="ptl_month_sale">
							<table cellspacing="0" cellpadding="0" border="0">
								<colgroup>
									<col width="">
									<col width="109">
								</colgroup>
								<tr>
									<td rowspan="3">
										<div class="dal_tab">
											<ul>
												<li class="on"><a href="#n">이번달</a></li>
												<li><a href="#n">지난달</a></li>
												<li><a href="#n">작년6월</a></li>
											</ul>
										</div>
										<div class="gr_div ml10" style="width:321px;height:135px;">
											<img src="/gw/ebp/Images/temp/img_graph06.png" alt="" class="">
										  </div>
									</td>
									<td class="dal_txt">
										<dl>
											<dt>이번달</dt>
											<dd>30,206,100</dd>
										</dl>
									</td>
								</tr>
								<tr>
									<td class="dal_txt">
										<dl>
											<dt>지난달</dt>
											<dd>13,799,000</dd>
										</dl>
									</td>
								</tr>
								<tr>
									<td class="dal_txt">
										<dl>
											<dt>작년6월</dt>
											<dd>58,935,200</dd>
										</dl>
									</td>
								</tr>
							</table>
						 </div>
					</div>
				</textarea>
				
				<!-- 받은편지함 CEO -->
				<textarea id="demo_portletTemplete_inboxCeo" style="display:none;">
					<div class="ptl_content nocon">
			            <div class="ptc_box2">
			              <!-- 타이틀 영역 -->
			              <div class="tit_div pb10" onclick="onclickTopMenu('ML','MLAAAA00400');">
			                <h2 class="arr"><a href="#n">받은편지함</a></h2>
			              </div>
			            <!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptl_mail ScrollY" style="height:184px;">
							<ul>
								<li class="unlead line">
									<dl>
										<dt class="title"><a href="#n">주간업무보고서 송부</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="unlead line">
									<dl>
										<dt class="title"><a href="#n">견적서와 세금계산서</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">미팅일정 안내</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">더존 뉴스 모니터링 20190508</a></dt>
										<dd class="from_info f11">김성훈A (kppl@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">[공지] 미리 써보는 ONEFFICE Mobile</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">더존 뉴스 모니터링 20190507</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
							</ul>
			            </div>
			          </div><!-- //ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
								
				<!-- temp -->
				<textarea id="demo_portletTemplete_task_status" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span><%=BizboxAMessage.getMessage("TX000007078","프로젝트현황")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<img src="/gw/js/portlet/Images/freeb/temp_pro0.png" style="width:100%;height:100%;">
					</div>
				</textarea>
				
				<!-- real -->
				<textarea id="portletTemplete_mybox" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="userinfo">
							<!-- 접속자 정보 -->
							<div class="user">
								<div class="user_pic">
									<div class="bg_pic"></div>
									<span class="img_pic">
										<img src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" onerror=this.src="/gw/Images/temp/pic_Noimg.png" alt="" />
									</span>				
								</div>
								<div class="mb10 name">${loginVO.name}
								   <c:choose><c:when test="${displayPositionDuty == 'duty'}">${loginVO.classNm}</c:when><c:otherwise>${loginVO.positionNm}</c:otherwise></c:choose>
								 </div>
								<div class="Scon_ts">${empPathNm}</div>
							</div>
							<!-- 출근/퇴근 -->
							<div class="worktime">
								<div id="container" style="display:none;">
									<ul class="tabs">
										<li onclick="$(this).siblings().removeClass('active');$(this).addClass('active');$('#portletTemplete_mybox_tab2').hide();$('#portletTemplete_mybox_tab1').show();" class="active" rel="tab1"><%=BizboxAMessage.getMessage("TX000000813","출근")%></li>
										<li onclick="$(this).siblings().removeClass('active');$(this).addClass('active');$('#portletTemplete_mybox_tab1').hide();$('#portletTemplete_mybox_tab2').show();" rel="tab2"><%=BizboxAMessage.getMessage("TX000000814","퇴근")%></li>
									</ul>
									<div class="tab_container">
										<div id="portletTemplete_mybox_tab1" class="tab_content"></div>
										<div id="portletTemplete_mybox_tab2" class="tab_content" style="display:none"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</textarea>				
				
				<textarea id="portletTemplete_notice" style="display:none;">
					<div class="ptl_content nocon">
						<div class="ptl_mention">
							 <!-- 탭 -->
			                <ul class="alert_tab clear">
			                    <li class="on">
			                        <a href="#n" onclick="return false;" class="tab01">
			                        <span class="ico"></span>								
			                        <span class="txt"><%=BizboxAMessage.getMessage("TX000022368","알림전체")%></span>
			                        <span class="" id="alertNewIcon"></span>
			                        </a>
			                    </li>
			                    <li>
			                        <a href="#n" onclick="return false;" class="tab02">
			                        <span class="ico"></span>
			                        <span class="txt"><%=BizboxAMessage.getMessage("TX000021504","알파멘션")%></span>
			                        <span class="" id="mentionNewIcon"></span>
			                        </a>
			                    </li>
			                </ul>
			
			                <div class="mentionCon freebScrollY">
			                    <!-- 알림전체 -->
			                    <div class="tabCon _tab01">
				                    <ul id="alertListTag">
				                    </ul>                    
			                    </div>
			
			                    <!-- 알파멘션 -->
			                    <div class="tabCon _tab02" style="display:none;">
			                    	<ul id="mentionListTag">
			                    	</ul>                        
			                    </div>	
			                </div>				
			            </div>
					</div>
				</textarea>	
				
				<!-- 자산성장성지표 -->
				<textarea id="portletTemplete_assetGrowthIndex" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
				    	<div class="ptc_box2">
				        	<!-- 타이틀 영역 -->
				            <div class="tit_div">
				              <h2 class="">자산성장성지표 <span class="so">(단위:%)</span></h2>
				            </div>
				            <div class="pt_gr_ta2">
				            	<table>
				                	<tbody>
				                		<tr>
				                    		<td>
						                      <div id="portletTemplete_assetGrowthIndexContainer" graph class="gr_div" style="width:200px;height:125px;">
						                        
						                      </div>
					                    	</td>
					                 	</tr>
						                <tr>
						                	<td>
						                    	<div class="bum_list">
						                        	<ul>
							                        	<li class="li1">총자산증가율</li>
							                        	<li class="li2">유동자산증가율</li>
							                          	<li class="li3">유형자산증가율</li>
							                          	<li class="li4">자기자본증가율</li>
						                        	</ul>
						                      	</div>
						                    </td>
						               	</tr>
				                	</tbody>
				                </table>
				            </div>
				          </div><!--// ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>		
				
				<!-- 재고현황 -->
				<textarea id="portletTemplete_inventoryStatus" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptc_box2">
			            <!-- 타이틀 영역 -->
			            <div class="tit_div">
			              <h2 class="">재고현황 <span class="so">(단위:백만)</span></h2>
			            </div>
			            <div class="pt_gr_ta2">
			                <table>
			                  <tbody><tr>
			                    <td>
			                      <div id="portletTemplete_inventoryStatusContainer" graph class="gr_div" style="width:200px;height:125px;">
			                       
			                      </div>
			                    </td>
			                  </tr>
			                  <tr>
			                    <td>
			                      <div class="bum_list2">
			                        <ul>
			                          <li class="li1">
			                            <dl>
			                              <dt>이월재고</dt>
			                              <dd>32,123</dd>
			                            </dl>
			                          </li>
			                          <li class="li2">
			                            <dl>
			                              <dt>현재재고</dt>
			                              <dd>32,123</dd>
			                            </dl>
			                          </li>
			                          <li class="li3">
			                            <dl>
			                              <dt>평균재고</dt>
			                              <dd>32,123</dd>
			                            </dl>
			                          </li>
			                        </ul>
			                      </div>
			
			                    </td>
			                  </tr>
			                </tbody></table>
			            </div>
			          </div><!--// ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
				
				<!-- 경영실적 당기순이익 -->
				<textarea id="portletTemplete_bpNetProfit" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptc_box2">
			            <!-- 타이틀 영역 -->
			            <div class="tit_div">
			              <h2 class="let1">경영실적[당기순이익] <span class="so">(단위:억원)</span></h2>
			            </div>
			            <div class="pt_gr_ta2">
			                <table>
			                  <tbody><tr>
			                    <td>
			                      <div id="portletTemplete_bpNetProfitContainer" class="gr_div" graph style="width:220px;height:157px;margin-top:25px;">
			                        <!--이미지 스타일 넣은것은 시연용 개발시 삭제-->
			                      </div>
			                    </td>
			                  </tr>
			                </tbody></table>
			            </div>
			          </div><!--// ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
				
				<!-- 부서판매실적 -->
				<textarea id="portletTemplete_boundAgeStatus" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptc_box2">
			            <!-- 타이틀 영역 -->
			  					<div class="tit_div">
			  						<h2 class="">채권연령현황</h2>
			  					</div>
			            <div class="pt_gr_ta1">
			                <table>
			                  <colgroup>
			                    <col width="310">
			                    <col width="">
			                  </colgroup>
			                  <tbody><tr>
			                    <td class="ac">
			                      <div id="portletTemplete_boundAgeStatusContainer" class="gr_div" graph style="width:240px;height:156px;">
			                        
			                      </div>
			                    </td>
			                    <td>
			                      <div class="cg_list">
			                        <ul>
			                          <li class="li1">
			                            <dl>
			                              <dt>채권회전율</dt>
			                              <dd>11.8<span class="dan">%</span></dd>
			                            </dl>
			                          </li>
			                          <li class="li2">
			                            <dl>
			                              <dt>채권회전일</dt>
			                              <dd>30.8<span class="dan">일</span></dd>
			                            </dl>
			                          </li>
			                        </ul>
			                      </div>
			                    </td>
			                  </tr>
			                </tbody></table>
			            </div>
			            </div><!--// ptc_box2 -->
					</div><!--// ptl_content -->
				</textarea>
				
				<!-- 매출실적현황 -->
				<textarea id="portletTemplete_salesPerformance" style="display:none;">
						<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
				            <div class="ptc_box2">
				            <!-- 타이틀 영역 -->
							<div class="tit_div">
								<h2 class="">2018 매출실적현황</h2>
							</div>
				            <div class="pt_gr_ta1">
				                <table>
				                  <colgroup>
				                    <col width="240">
				                    <col width="">
				                  </colgroup>
				                  <tbody><tr>
				                    <td class="ac">
				                      <div id="portletTemplete_salesPerformanceContainer" class="gr_div" graph style="width:210px;height:187px;">
				                  	    <!-- <img src="/gw/ebp/Images/temp/img_graph01.png" alt="" class=""> -->
				                      </div>
				                    </td>
				                    <td>
				                        <div class="pgt_list">
				                            <ul>
				                              <li class="li1">
				                                <dl>
				                                  <dt>목표금액</dt>
				                                  <dd>1,125,000,000</dd>
				                                </dl>
				                              </li>
				                              <li class="li2">
				                                <dl>
				                                  <dt>실적금액</dt>
				                                  <dd>125,000,000</dd>
				                                </dl>
				                              </li>
				                              <li class="li3">
				                                <dl>
				                                  <dt>미달금액</dt>
				                                  <dd>1,000,000,000</dd>
				                                </dl>
				                              </li>
				                            </ul>
				                        </div>
				                    </td>
				                  </tr>
				                </tbody></table>
				            </div>
						</div><!--// ptc_box2 -->
					</div><!--// ptl_content -->
				</textarea>
				
				<!-- 임직원연차사용관리 -->
				<textarea id="portletTemplete_annualUseManage" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="wk">
						<span>임직원 연차사용관리</span>
					</h2>
					<div class="ptl_content">							
						<div class="hraum">							
							<p id="portletTemplete_annualUseManageContainer" graph class="graph">
							
							</p>
							<div class="graph_con">
								<ul>
									<li class="gbg red">조치필요</li>
									<li class="text" style="width:89px;">홍길동 외 8명</li>
									<li class="percent">30%</li>
								</ul>
								<ul>
									<li class="gbg yellow">관리필요</li>
									<li class="text" style="width:89px;">김더존 외 5명</li>
									<li class="percent">25%</li>
								</ul>
								<ul>
									<li class="gbg green">양호</li>
									<li class="text" style="width:89px;">이양호 외 25명</li>
									<li class="percent">45%</li>
								</ul>
							</div>
						</div>
					</div>
				</textarea>
				
				<!-- 금주 근무시간 -->
				<textarea id="portletTemplete_weekWorkingHours" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="wt">
						<span>금주 근무시간</span>
					</h2>
					<div class="ptl_content">					
						<div id="portletTemplete_weekWorkingHoursContainer" graph class="weektime"></div>
					</div>		
				</textarea>
				
				<!-- 나의 근무현황 -->
				<textarea id="portletTemplete_myWorkStatus" style="display:none;">
					<h2 class="ws">
						<span>나의 근무현황</span>
						<span class="myworkst_tab">
							<ul>
								<li class="on"><a href="#n" onclick="return false;" class="tab01">주별</a></li>
								<li><a href="#n" onclick="return false;" class="tab02">월별</a></li>
								<li><a href="#n" onclick="return false;" class="tab03">년도별</a></li>
							</ul>
						</span>
					</h2>					
					<div class="ptl_content">
						<!-- 주별 -->
						<div class="myworkst">
							<div class="tabcon _tab01">
								<div id="portletTemplete_myWorkStatusContainer" graph class="graph">
								
								</div>
								<div class="wstype">
									<dl class="type01">
										<dt>기본근무</dt>
										<dd>32시간</dd>
									</dl>
									<dl class="type02">
										<dt><span></span>연장근무</dt>
										<dd>7시간</dd>
									</dl>
									<dl class="type03">
										<dt><span></span>휴일근무</dt>
										<dd>6시간</dd>
									</dl>
								</div>
							</div>						
						
							<!-- 월별 -->
							<div class="tabcon _tab02" style="display:none;">
								<div class="graph"><img src="../../Images/temp/myworkst_graph02.png" alt=""/></div>
								<div class="wstype">
									<dl class="type01">
										<dt>기본근무</dt>
										<dd>132시간</dd>
									</dl>
									<dl class="type02">
										<dt><span></span>연장근무</dt>
										<dd>20시간</dd>
									</dl>
									<dl class="type03">
										<dt><span></span>휴일근무</dt>
										<dd>6시간</dd>
									</dl>
								</div>
							</div>

							<!-- 년도별 -->
							<div class="tabcon _tab03" style="display:none;">
								<div class="graph"><img src="../../Images/temp/myworkst_graph03.png" alt=""/></div>
								<div class="wstype">
									<dl class="type01">
										<dt>기본근무</dt>
										<dd>1232시간</dd>
									</dl>
									<dl class="type02">
										<dt><span></span>연장근무</dt>
										<dd>100시간</dd>
									</dl>
									<dl class="type03">
										<dt><span></span>휴일근무</dt>
										<dd>40시간</dd>
									</dl>
								</div>
							</div>

						</div>
					</div>
				</textarea>
				
				<!-- 연장근무 신청 -->
				<textarea id="portletTemplete_overTimeApplication" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>연장근무신청</span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content">							
						<div class="overtime">
							<div class="select">
								<select style="width:100%;">
									<option value="total">전체일정</option>
									<option value="indivi" selected="selected">개인일정</option>
								</select>
							</div>
							<div class="overtimeCon ScrollY" style="height:150px;">
								<ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">홍길동 사원 <span class="text_blue">2시간</span></p>
											<p class="dd">클라우드 전략 보고서 작성</p>
										</a>
									</li>
									<li class="box bg01">대기</li>									
								</ul>
								<ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">이정미 선임 <span class="text_blue">2시간</span></p>
											<p class="dd">Bizbox Alpha 근태관리 화면설계</p>
										</a>
									</li>
									<li class="box bg01">대기</li>									
								</ul>
								<ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">이준혁 주임 <span class="text_blue">2시간</span></p>
											<p class="dd">UC설계팀 주간업무보고서 취합</p>
										</a>
									</li>
									<li class="box bg02">승인</li>									
								</ul>
								<!-- <ul>
									<li class="list" style="width:175px;">
										<a href="#n">
											<p class="dt">정현석 과장 <span class="text_blue">2시간</span></p>
											<p class="dd">UC기획팀 주간업무보고서 취합</p>
										</a>
									</li>
									<li class="box bg02">승인</li>									
								</ul> -->
							</div>
						</div>
					</div>	
				</textarea>
				
				<!-- 근무현황 -->
				<textarea id="portletTemplete_workingStatus" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>근무현황</span>
						<span class="ws_more"><a href="#n" class="more" title="더보기">UC기획부</a></span>						
					</h2>
					
					<div class="ptl_content">
						<div class="workst">
							<ol class="bxslider">
								<li>
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											
											<!-- 반복 -->
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>홍길동 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:60%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<!-- //반복 -->

											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이정미 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:50%"></span>
														<span class="col2" style="width:20%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이준혁 주임 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:10%"></span>
														<span class="col2" style="width:20%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>정현석 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:60%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>정명호 차장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:30%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>배현규 사원 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:10%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
								</li>
								<li>
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>김민진 과장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:20%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>정유민 사원 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:10%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이시은 사원 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:40%"></span>
														<span class="col2" style="width:10%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
									<div class="box">
										<table width="100%">
											<colgroup>
												<col width="30" />
												<col width="*" />
											</colgroup>
											<tr>
												<td class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>허정명 주임 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:50%"></span>
														<span class="col2" style="width:40%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>이홍직 수석<span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:20%"></span>
														<span class="col2" style="width:80%"></span>												
													</p>
												</td>
											</tr>
											<tr>
												<td width="30" class="misc">													
													<div class="bg_pic"></div>
													<span class="divi_img"><img src="/gw/ebp/Images/bg/pic_Noimg.png" alt="" /></span>	
												</td>
												<td class="user">
													<p>김재택 차장 <span class="depart">UC기획팀</span> <span class="time"><em>8</em>/36시간</span></p>
													<p class="graph">														
														<span class="col1" style="width:30%"></span>
														<span class="col2" style="width:30%"></span>												
													</p>
												</td>
											</tr>
										</table>
									</div>	
								</li>
							</ol>
						</div>
					</div>
				</textarea>
				
				<!-- etcBox 경비지출, 재직증명서, 급여내역조회, 개인연말정산 -->
				<textarea id="portletTemplete_etcBox" style="display:none;">
					<div class="portletBox_link">
						<p>
							<a href="#n" class="link01">경비지출</a>
							<a href="#n" class="link03">재직증명서</a>
						</p>
						<p class="pt20">						
							<a href="#n" class="link03">급여내역조회</a>
							<a href="#n" class="link04">개인연말정산</a>
						</p>
					</div>
				</textarea>
				
				<!-- 인사포틀릿(인사담당자) -->
				<textarea id="portletTemplete_board_hr" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span>공지사항</span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content ScrollY">		
						<div class="exp_notice">
							<ul>
								<li class="new"><a href="#n">통근버스노선표안내 <img src="/gw/ebp/Images/ico/icon_new.png" class="mtImg" alt=""/></a></li>
								<li><a href="#n">2017년 귀속분 연말정산 세법</a></li>
								<li><a href="#n">더존베이커리 2018년 1월 메뉴</a></li>
								<li><a href="#n">1월 3주차 주간메뉴 안내</a></li>
								<li><a href="#n">통근버스 노선안내 (노선표 첨부 / 2018. 12. 03(월)부터 시행.)</a></li>
								<li><a href="#n">AT 자격시험 기술감독관 교육</a></li>

							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 업무요청 -->
				<textarea id="portletTemplete_requestJob" style="display:none;">
					<h2 class="wk">
						<span>업무요청</span>
					</h2>
					<div class="ptl_content">
						<div class="JobRequest">
							<ul>
								<li class="bg01">
									<p>경비청구 </br><em>15</em>건</p>
								</li>
								<li class="bg02">
									<span>긴급</span>
									<p>증명서신청 </br><em>15</em>건</p>
								</li>
								<li class="bg03">
									<p>세금계산서 </br><em>15</em>건</p>
								</li>
								<li class="bg04">
									<p>전자계약 </br><em>15</em>건</p>
								</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 금일 주요 지출예정 -->
				<textarea id="portletTemplete_expectedSpendToday" style="display:none;">
					<h2 class="exp">
						<span>금일 주요 지출예정(06/01)</span>
						<span class="exp_more">이체내역</span>
					</h2>					
					<div class="ptl_content">
						<div class="exp_today ScrollY">
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img01.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">06월 직원급여 외 5건</a></li>
								<li class="btn blue">지출완료</li>
							</ul>
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img02.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">외주 용역비 외 3건</a></li>
								<li class="btn red">지출대기</li>
							</ul>
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img03.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">건물임대료 외 4건</a></li>
								<li class="btn red">지출대기</li>
							</ul>
							<ul>
								<li class="img"><img src="/gw/ebp/Images/temp/exp_today_img04.jpg" alt=""/></li>
								<li class="text ellipsis"><a href="#n">판매수수료 지급 외 11건</a></li>
								<li class="btn gray">지급보류</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 부서별 경비청구 진행률 -->
				<textarea id="portletTemplete_divExpenseClaim" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="exp">
						<span>부서별 경비청구 진행률</span>
					</h2>
					<div class="ptl_content">

						<ul class="exp_progress">
							<li id="portletTemplete_divExpenseClaimContainer" class="graph">
								
							</li>
							<li class="fl mt30 mr20">
								<dl>
									<dt>
										<span class="num">1</span>
										<span>영업사업1팀</span>
										<span class="cl price">100,000,000</span>
									</dt>
									<dd style="width:170px;">
										<div class="progress-linear">
											<div class="progressBg">
												<div class="bar" style="width:100%; background:#5f80e9; border-radius:0px;">
													<span class="percent">100%</span>
												</div>
											</div>
										</div>
									</dd>
								</dl>
								<dl>
									<dt>
										<span class="num">2</span>
										<span>마케팅1팀</span>
										<span class="cl price">100,000,000</span>
									</dt>
									<dd style="width:170px;">
										<div class="progress-linear">
											<div class="progressBg">
												<div class="bar" style="width:72%; background:#6199ff;">
													<span class="percent">72%</span>
												</div>
											</div>
										</div>
									</dd>
								</dl>
								<dl>
									<dt>	
										<span class="num">3</span>
										<span>개발1팀</span>
										<span class="cl price">100,000,000</span>
									</dt>
									<dd style="width:170px;">
										<div class="progress-linear">
											<div class="progressBg">
												<div class="bar" style="width:56%; background:#6fa7f2;">
													<span class="percent">56%</span>
												</div>
											</div>
										</div>
									</dd>
								</dl>
							</li>
						</ul>
					</div>
				</textarea>
				
				<!-- 회계결재 진행현황 -->
				<textarea id="portletTemplete_accountingEaProgress" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ea">
						<span>회계결재 진행현황</span>
					</h2>
					<div class="ptl_content">
						<div class="exp_status">
							<p class="graph" id="portletTemplete_accountingEaProgressContainer"></p>
							<div class="list">
								<ul>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">2018년 5월 자금일보</a>
										<span class="btn blue">완료</span>
									</li>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">영업팀 자금계획 결재의 건</a>
										<span class="btn red">결재중</span>
									</li>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">2017 회계감사자료 지출결의</a>
										<span class="btn purple">상신</span>
									</li>
									<li>
										<a href="#n" class="fl ellipsis" style="width:170px;">자금이체 관련 결재의 건</a>
										<span class="btn blue">완료</span>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</textarea>
				
				<!-- 주요회계업무 -->
				<textarea id="portletTemplete_mainAccountionTask" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span>주요 회계업무</span>
					</h2>
					<div class="ptl_content">
						<div class="exp_major">
							<ul>
								<li class="list"><a href="#n"><span class="major01"></span>월말 결산보고</a></li>
								<li class="day red">1일전</li>
							</ul>
							<ul>
								<li class="list"><a href="#n"><span class="major02"></span>부가세 마감신고</a></li>
								<li class="day red">3일전</li>
							</ul>
							<ul>
								<li class="list"><a href="#n"><span class="major03"></span>고용/산재 변경신고</a></li>
								<li class="day blue">06/20</li>
							</ul>
							<ul>
								<li class="list"><a href="#n"><span class="major04"></span>출장자 마감보고</a></li>
								<li class="day blue">06/25</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 나의카드 사용내역(REAL) -->
				<textarea id="portletTemplete_myCardUsageHistory" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="cd">
						<span>나의카드 사용내역</span>
					</h2>
					<div class="ptl_content">					
						<div class="ptl_card">
							<div class="card_div">
								<div class="card_div_in">
									<h3 class="sh">신한카드</h3>
									<div class="card_ta">
									<table cellspacing="0" cellpadding="0" border="0">
										<colgroup>
											<col width="75">
											<col width="">
										</colgroup>
										<tr>
											<td>
												<div class="ic"></div>
											</td>
											<td class="td_txt">
												<ul>
													<li class="won">10,000,000,000</li>
													<li class="gun">
														<dl>
															<dt>건수</dt>
															<dd><span class="text_blue">25</span>건</dd>
														</dl>
													</li>
												</ul>
											</td>
										</tr>
										<tr>
											<td colspan="2" class="td_btm">
												<ul>
													<li class="na">LIM HYUNSIK</li>
													<li class="so">GOOD<br>THUR</li>
													<li class="dat">09/24</li>
													<li class="mas">
														<span></span>
													</li>
												</ul>
											</td>
										</tr>
									</table>
								</div>
							</div>
							</div>
								<div class="hang_div">
									<ul>
										<li>
											<dl>
												<dt>접대비</dt>
												<dd>20,000</dd>
											</dl>
										</li>
									</ul>
								</div>
							</div>
						</div>					
					</textarea>
					
				<!-- 부서별판매실적(REAL) -->
				<textarea id="portletTemplete_salesByDepartment" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>부서별판매실적</span>
					</h2>
					<div class="ptl_content">		
						<div class="gr_div" style="width:226px;height:177px;"style="margin: 0 auto" id="portletTemplete_salesByDepartmentContainer">
							<div id="demo"></div>
						</div>
					</div>				
				</textarea>
				
				<!-- 매출액추이(REAL) --> 
				<textarea id="portletTemplete_salesTrend" style="display:none;">
						<!-- 타이틀 영역 -->
					<h2 class="ws">
						<span>매출액추이</span>
					</h2>
					<div class="ptl_content">
						<div class="ptl_adv_list">
							<ul>
								<li>
									<dl class="dl1">
										<dt>해당일</dt>
										<dd class="red">1,000,000</dd>
									</dl>
									<dl class="dl2">
										<dt>2019.05</dt>
										<dd>
											<span class="txt">전녀대비</span>
											<span class="down">10%</span>	
										</dd>
									</dl>
								</li>
								<li>
									<dl class="dl1">
										<dt>해당월</dt>
										<dd class="red">250,000,000</dd>
									</dl>
									<dl class="dl2">
										<dt>2019.05</dt>
										<dd>
											<span class="txt">전녀대비</span>
											<span class="up">10%</span>	
										</dd>
									</dl>
								</li>
								<li>
									<dl class="dl1">
										<dt>해당년</dt>
										<dd class="red">1,020,250,000</dd>
									</dl>
									<dl class="dl2">
										<dt>2019.05</dt>
										<dd>
											<span class="txt">전녀대비</span>
											<span class="up">40%</span>	
										</dd>
									</dl>
								</li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 월간판매실적 (REAL) -->
				<textarea id="portletTemplete_monthlySalesPerformance" style="display:none;">
							<h2 class="ws">
						<span>월간판매실적</span>
					</h2>					
					<div class="ptl_content">
						<div class="ptl_month_sale">
							<table cellspacing="0" cellpadding="0" border="0">
								<colgroup>
									<col width="">
									<col width="109">
								</colgroup>
								<tr>
									<td rowspan="3">
										<div class="dal_tab">
											<ul>
												<li class="on"><a href="#n">이번달</a></li>
												<li><a href="#n">지난달</a></li>
												<li><a href="#n">작년6월</a></li>
											</ul>
										</div>
										<div class="gr_div ml10" style="width:321px;height:135px;">
											<div id="portletTemplete_monthlySalesPerformanceContainer" style="min-width: 310px; height: 160px; margin: 0 auto"></div>
										  </div>
									</td>
									<td class="dal_txt">
										<dl>
											<dt>이번달</dt>
											<dd>30,206,100</dd>
										</dl>
									</td>
								</tr>
								<tr>
									<td class="dal_txt">
										<dl>
											<dt>지난달</dt>
											<dd>13,799,000</dd>
										</dl>
									</td>
								</tr>
								<tr>
									<td class="dal_txt">
										<dl>
											<dt>작년6월</dt>
											<dd>58,935,200</dd>
										</dl>
									</td>
								</tr>
							</table>
						 </div>
					</div>
				</textarea>
				
				<!-- 매출현황 포틀릿  -->
				<textarea id="portletTemplete_salesStatus" style="display:none;">
					<h2 class="ws">
						<span>매출현황</span>
						<div class="year_div">
							<ul>
								<li><span class="col" style="background:#f89e9c"></span> <span class="txt">2018년</span></li>
								<li><span class="col" style="background:#f35d5a"></span> <span class="txt">2019년</span></li>
							</ul>
						</div>
					</h2>
					<div class="ptl_content">
						<div class="ptl_adv">
							<div class="adv_div">
								<div class="txt">
									<dl>
										<dt>전년대비</dt>
										<dd class="down">10%</dd>
									</dl>
								</div>
								<div class="gr_div" style="width:130px;height:120px;">
									<div id="SalesStatus_first"></div>
								  </div>
							</div>

							<div class="adv_div">
								<div class="txt">
									<dl>
										<dt>전년대비</dt>
										<dd class="up">10%</dd>
									</dl>
								</div>
								<div class="gr_div" style="width:130px;height:120px;">
									<div id="SalesStatus_second"></div>
								  </div>
							</div>

							<div class="adv_div">
								<div class="txt">
									<dl>
										<dt>전년대비</dt>
										<dd class="up">45%</dd>
									</dl>
								</div>
								<div class="gr_div" style="width:130px;height:120px;">
									<div id="SalesStatus_third"></div>
								  </div>
							</div>
						</div>
					</div>
				</textarea>
				
				<!-- 받은편지함 CEO -->
				<textarea id="portletTemplete_inboxCeo" style="display:none;">
					<div class="ptl_content nocon">
			            <div class="ptc_box2">
			              <!-- 타이틀 영역 -->
			              <div class="tit_div pb10" onclick="onclickTopMenu('ML','MLAAAA00400');">
			                <h2 class="arr"><a href="#n">받은편지함</a></h2>
			              </div>
			            <!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptl_mail ScrollY" style="height:184px;">
							<ul>
								<li class="unlead line">
									<dl>
										<dt class="title"><a href="#n">주간업무보고서 송부</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="unlead line">
									<dl>
										<dt class="title"><a href="#n">견적서와 세금계산서</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">미팅일정 안내</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">더존 뉴스 모니터링 20190508</a></dt>
										<dd class="from_info f11">김성훈A (kppl@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">[공지] 미리 써보는 ONEFFICE Mobile</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
								<li class="line">
									<dl>
										<dt class="title"><a href="#n">더존 뉴스 모니터링 20190507</a></dt>
										<dd class="from_info f11">관리자(admin@douzone.com)</dd>
									</dl>
								</li>
							</ul>
			            </div>
			          </div><!-- //ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
				
				<textarea id="portletTemplete_inbox" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="rm">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000001580","받은편지함")%></span>
						<a href="javascript:fnMailMain();" class="more" title="더보기"></a>
					</h2>
					<div name="portletTemplete_inbox_list" class="ptl_content nocon">
						<div class="ptl_mail freebScrollY"></div>
					</div>
				</textarea>	
				
				<textarea id="portletTemplete_calendar_vertical" style="display:none;">
					<input type="hidden" name="HidEventDays" value="" />
					<input type="hidden" name="HidYearMonth" value="" />
					<input type="hidden" name="HidHolidays" value="" />
					<input type="hidden" name="HidHolidayList" value="" />
					<input type="hidden" name="HidSelectedDate" value="" />				

					<h2 class="sc">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000000483","일정")%></span>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_calendar">
							<div class="calender_wrap">
							<div name="loadingSchedule" style="display:none;position: absolute;width: 100%;height: 100%;"><img src="/gw/Images/ico/loading_2x.gif" style="margin-left:100px;margin-top:50%;"></div>
								<div class="select_date">
									<a title="이전" class="prev" onclick="calanderPrevNext(-1, this)" href="#"></a>
									<span name="portletTemplete_calendar_calanderDate"></span>
									<a title="다음" class="next" onclick="calanderPrevNext(1, this)" href="#"></a>
								</div>
	
								<div  class="calender_ta" name="portletTemplete_calendar_calenderTable"></div>                
							</div>
							
							<!-- 항목셀렉트 -->
							<div class="calendar_select">
								<select name="portletTemplete_calendar_scheSm" onchange="fnChangeScheduleSelect(this);" class="puddSetup" pudd-style="width:211px;">
									<option value="total" selected="selected"><%=BizboxAMessage.getMessage("TX000010380","전체일정")%></option>
								</select>
							</div>
							
							<!-- 리스트 -->
							<div class="calendar_div st1" style="display:block">
								<h3><span name="portletTemplete_calendar_selectedDate"></span> <span class="fr mr20"><span name="portletTemplete_calendar_selectedCnt" class="text_blue">0</span><%=BizboxAMessage.getMessage("TX000000476","건")%></span></h3>
								<div class="calendar_list freebScrollY">
									<ul name="portletTemplete_calendar_list"></ul>
								</div>
							</div>
						</div>
					</div>
				</textarea>
								
				<textarea id="portletTemplete_calendar_horizontal" style="display:none;">
					<input type="hidden" name="HidEventDays" value="" />
					<input type="hidden" name="HidYearMonth" value="" />
					<input type="hidden" name="HidHolidays" value="" />
					<input type="hidden" name="HidHolidayList" value="" />
					<input type="hidden" name="HidSelectedDate" value="" />					
				
					<h2 class="sc">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000000483","일정")%></span>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_calendar horizontal">
							<div class="calendar_wrap">
							<div name="loadingSchedule" style="display:none;position: absolute;width: 100%;height: 100%;"><img src="/gw/Images/ico/loading_2x.gif" style="margin-left:100px;margin-top:50%;"></div>
								<div class="select_date">
									<a title="이전" class="prev" onclick="calanderPrevNext(-1, this)" href="#"></a>
									<span name="portletTemplete_calendar_calanderDate"></span>
									<a title="다음" class="next" onclick="calanderPrevNext(1, this)" href="#"></a>
								</div>

								<div  class="calender_ta" name="portletTemplete_calendar_calenderTable"></div>                
							</div>

							<div class="horizon_right">
								<div class="calendar_select">
									<select name="portletTemplete_calendar_scheSm" onchange="fnChangeScheduleSelect(this);" class="puddSetup" pudd-style="width:211px;">
										<option value="total" selected="selected"><%=BizboxAMessage.getMessage("TX000010380","전체일정")%></option>
									</select>
								</div>							
	
								<!-- 리스트 -->
								<div class="calendar_div st1" style="display:block">
									<h3><span name="portletTemplete_calendar_selectedDate"></span> <span class="fr mr20"><span name="portletTemplete_calendar_selectedCnt" class="text_blue">0</span><%=BizboxAMessage.getMessage("TX000000476","건")%></span></h3>
									<div class="calendar_list freebScrollY">
										<ul name="portletTemplete_calendar_list"></ul>
									</div>
								</div>								
							</div>
						</div>
					</div>
				</textarea>				

				<textarea id="portletTemplete_iframe_banner" style="display:none;">
					<div name="portletTemplete_iframe_banner_list" class="ptl_content">
						<img name="loadingImg" width="100%" height="100%" src="" alt="" />
						<iframe name="loadingIframe" width="100%" height="100%" src="" style="display:none;" />
					</div>
				</textarea>
				
				<textarea id="portletTemplete_iframe_quick" style="display:none;">
					<div name="portletTemplete_iframe_quick_list" class="ptl_content"></div>
				</textarea>
				
				<textarea id="portletTemplete_iframe_outer" style="display:none;">
					<div name="portletTemplete_iframe_outer_list" class="ptl_content"></div>
				</textarea>	
				
			</div>

		</div><!--// pop_con -->
		
		<div class="portlet_controll">
			<input id="btnSave" type="button" class="puddSetup submit" value="저장" pudd-style="display:block;width:70px;height:24px;margin-bottom:5px;"/>
			<input type="button" onclick="self.close();" class="puddSetup" value="취소" pudd-style="display:block;width:70px;height:24px;"/>
		</div>
	</div><!--// pop_wrap -->
</body>
</html>








