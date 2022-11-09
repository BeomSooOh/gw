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
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/common.css?ver=20201021">
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/animate.css">
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/pudd.css?ver=20201021">
	<link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/portlet.css?ver=20201021">
	<script type="text/javascript" src="/gw/js/portlet/Scripts/pudd/pudd-1.1.11.min.js"></script>

    <!--js-->
    <script type="text/javascript" src="/gw/js/portlet/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/portlet/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="/gw/js/portlet/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common.js?ver=20201021"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common_freeb.js?ver=20201021"></script>
    
    <!-- mCustomScrollbar -->
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.css">
    <script type="text/javascript" src="/gw/js/portlet/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>
    
    <script>
    
		var WeatherJson = [
			{ "img": '36.png', "kr": '맑음', "en": 'sunny', "jp": '晴れ', "cn": '', "gb": '晴' },
			{ "img": '33.png', "kr": '구름조금', "en": 'a little cloudy', "jp": '雲が少ない', "cn": '', "gb": '少云' },
			{ "img": '28.png', "kr": '구름많음', "en": 'very cloudy', "jp": '雲が多い', "cn": '', "gb": '多云' },
			{ "img": '26.png', "kr": '흐림', "en": 'cloudy', "jp": '曇り', "cn": '', "gb": '阴' },
			{ "img": '29.png', "kr": '맑음', "en": 'sunny', "jp": '晴れ', "cn": '', "gb": '晴' },						//저녁 
			{ "img": '34.png', "kr": '구름조금', "en": 'a little cloudy', "jp": '雲が少ない', "cn": '', "gb": '少云' },    //저녁 
			{ "img": '29.png', "kr": '구름많음', "en": 'very cloudy', "jp": '雲が多い', "cn": '', "gb": '多云' },    	    //저녁
	   		{ "img": '12.png', "kr": '비', "en": 'rain', "jp": '雨', "cn": '', "gb": '雨' },
	   		{ "img": '5.png', "kr": '눈/비', "en": 'snow/rain', "jp": '雪/雨', "cn": '', "gb": '雪/雨' },
	        { "img": '16.png', "kr": '눈', "en": 'snow', "jp": '雪', "cn": '', "gb": '雪' }
		];  
	
		var langCode = '${loginVO.langCode}';
		var eaType = '${loginVO.eaType}';	
    
    	var selectedPortlet;
    	var newPortletKey = 0;
    	
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
		});
		
		// 포틀릿 랜더시 스크립트 방지 목적
    	function escapeHtml(html) {  
    		var entityMap = { 
				'&': '&amp;', 
				'<': '&lt;', 
				'>': '&gt;', 
				'"': '&quot;', 
				"'": '&#39;', 
				'/': '&#x2F;', 
				'`': '&#x60;', 
				'=': '&#x3D;' 
    		};

    		return html.replace(/[&<>"'`=\/]/g, function (s) { return entityMap[s]; });
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

				config.defaultRow = 1;
				config.defaultCol = 1;
				config.maxRow = 20;
				config.maxCol = 10;
				config.minRow = 1;
				config.minCol = 1;
				config.boxTitle = "iframe";
				config.allowDuplicate = true;

			} else if( "portletTemplete_iframe_banner" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 5;
				config.maxCol = 10;
				config.minRow = 1;
				config.minCol = 1;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX900000498","배너")%>";
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

			} else if( "portletTemplete_weather" == boxType ) {

				config.defaultRow = 1;
				config.defaultCol = 2;
				config.maxRow = 4;
				config.maxCol = 4;
				config.minRow = 1;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000016704","날씨")%>";
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
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000011134","게시판")%>";
				config.allowDuplicate = true;

			} else if("portletTemplete_doc" == boxType) {
				
				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000018123","문서")%>";
				config.allowDuplicate = true;
				
			} else if( "portletTemplete_sign_form" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000010095","결재양식")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_sign_status" == boxType ) {

				config.defaultRow = 1;
				config.defaultCol = 2;
				config.maxRow = 1;
				config.maxCol = 10;
				config.minRow = 1;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000022827","결재현황")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_web_sign" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_note" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000010157","노트")%>";
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

			} else if( "portletTemplete_survey" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000002747","설문조사")%>";
				config.allowDuplicate = true;

			} else if( "portletTemplete_calendar_horizontal" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 4;
				config.maxRow = 2;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 4;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더")%>(<%=BizboxAMessage.getMessage("TX900000499","가로형")%>)";
				config.allowDuplicate = true;

			} else if( "portletTemplete_calendar_vertical" == boxType ) {

				config.defaultRow = 4;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 2;
				config.minRow = 4;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("TX000022829","일정캘린더")%>(<%=BizboxAMessage.getMessage("TX900000500","세로형")%>)";
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

			} else if( "portletTemplete_task_status" == boxType ) {

				config.defaultRow = 2;
				config.defaultCol = 2;
				config.maxRow = 10;
				config.maxCol = 10;
				config.minRow = 2;
				config.minCol = 2;
				config.boxTitle = "<%=BizboxAMessage.getMessage("","업무현황")%>";
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
			if(boxType != "portletTemplete_notice"){
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

			} else if( "portletTemplete_weather" == boxType ) {

				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_mybox" == boxType ) {

				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_board" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if("portletTemplete_doc" == boxType) {
				
				$( div ).addClass("titleBox");
			
			} else if( "portletTemplete_sign_form" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_sign_status" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_web_sign" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_note" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_mail_status" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_inbox" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_survey" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_calendar_horizontal" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_calendar_vertical" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else if( "portletTemplete_notice" == boxType ) {

				$( div ).addClass( "portletBox" );

			} else if( "portletTemplete_task_status" == boxType ) {

				$( div ).addClass( "titleBox" );

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

			} else if( "portletTemplete_board" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000011134","게시판","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000011134","게시판","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000011134","게시판","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000011134","게시판","cn")%>";
				optionInfo.val0 = "<%=BizboxAMessage.getMessage("TX000018234","최근공지글")%>";
				optionInfo.val1 = "501040000";
				optionInfo.val2 = "10";

			} else if( "portletTemplete_sign_status" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000022827","결재현황","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000022827","결재현황","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000022827","결재현황","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000022827","결재현황","cn")%>";
				optionInfo.val00 = true;
				optionInfo.val01 = false;
				optionInfo.val02 = true;
				optionInfo.val04 = false;
				optionInfo.val03 = false;
				optionInfo.val05 = false;
				optionInfo.val06 = false;

			} else if( "portletTemplete_mail_status" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000022828","메일현황","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000022828","메일현황","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000022828","메일현황","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000022828","메일현황","cn")%>";
				optionInfo.val0 = "Y";
				optionInfo.val1 = "Y";

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

			} else if( "portletTemplete_sign_form" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000010095","결재양식","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000010095","결재양식","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000010095","결재양식","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000010095","결재양식","cn")%>";

			} else if( "portletTemplete_web_sign" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000000479","전자결재","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000000479","전자결재","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000000479","전자결재","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000000479","전자결재","cn")%>";
				
			} else if( "portletTemplete_note" == boxType ) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000010157","노트","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000010157","노트","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000010157","노트","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000010157","노트","cn")%>";
				
			} else if( "portletTemplete_survey" == boxType ){
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000002747","설문조사","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000002747","Survey","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000002747","アンケート","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000002747","问卷调查","cn")%>";
				
			} else if("portletTemplete_doc" == boxType) {
				
				optionInfo.port_name_kr = "<%=BizboxAMessage.getMessage("TX000008627","문서","kr")%>";
				optionInfo.port_name_en = "<%=BizboxAMessage.getMessage("TX000008627","문서","en")%>";
				optionInfo.port_name_jp = "<%=BizboxAMessage.getMessage("TX000008627","문서","jp")%>";
				optionInfo.port_name_cn = "<%=BizboxAMessage.getMessage("TX000008627","문서","cn")%>";
				
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
					
				}else if(portletBoxType == "portletTemplete_sign_form"){
					
					render_portletTemplete_sign_form(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_sign_status"){
					
					render_portletTemplete_sign_status(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_web_sign"){
					
					render_portletTemplete_web_sign(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_mail_status"){
					
					render_portletTemplete_mail_status(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_inbox"){
					
					render_portletTemplete_inbox(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_calendar_horizontal"){
					
					render_portletTemplete_calendar_horizontal(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_calendar_vertical"){
					
					render_portletTemplete_calendar_vertical(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_note"){
					
					render_portletTemplete_note(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_weather"){
					
					render_portletTemplete_weather(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_iframe_banner"){
					
					render_portletTemplete_iframe_banner(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_iframe_quick"){
					
					render_portletTemplete_iframe_quick(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_iframe_outer"){
					
					render_portletTemplete_iframe_outer(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_board"){
					
					render_portletTemplete_board(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_doc"){
					
					render_portletTemplete_doc(portletInfo, targetDiv, portletKey);
					
				}else if(portletBoxType == "portletTemplete_survey"){
					
					render_portletTemplete_survey(portletInfo, targetDiv, portletKey);
					
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
		
		function render_portletTemplete_survey(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#demo_portletTemplete_survey" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
		}
		
		function render_portletTemplete_board(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_board" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find("[name=portletTemplete_board_list]").html("");
				return;
			}				
			
			$(targetDiv).find("[name=portletTemplete_board_more]").attr("href", "javascript:mainMove('NOTICE','/board/viewBoard.do?boardNo="+portletInfo.val1+"','"+portletInfo.val1+"');");
			
			var tblParams = {};
			tblParams.boardNo = portletInfo.val1;
			tblParams.count = portletInfo.val2;
			$.ajax({
				type: "post",
				
		         url: '/gw/boardPortlet.do',
		         datatype: "json",
		         data: tblParams,
		         async: true,
		         success: function (result) {
		        	var boardParam = result.boardParams;
		        	fnDrawBoard(boardParam, portletInfo, targetDiv);
		         },
		         error: function (e) {
		        	 $( targetDiv ).find("[name=portletTemplete_board_list]").html("");
		         }
			});			
		}
		
	    function fnDrawBoard(param, portletInfo, targetDiv) {
	    	
	    	var boardHeader = {};
	    	var boardBody = {};
	    	var boardCompany = {};
	    	var gubun = '';
	    	var searchEmpSeq = new Array();
	    	
	    	boardHeader.groupSeq = param.header.groupSeq;
	    	boardHeader.empSeq = param.header.empSeq;
	    	boardHeader.tId = param.header.tId;
	    	boardHeader.pId = param.header.pId;
	    	boardCompany.compSeq = param.body.companyInfo.compSeq;
	    	boardCompany.bizSeq = param.body.companyInfo.bizSeq;
	    	boardCompany.deptSeq = param.body.companyInfo.deptSeq;
	    	boardBody.companyInfo = boardCompany;
	    	boardBody.langCode = param.body.langCode;
	    	boardBody.loginId = param.body.loginId;
	    	boardBody.boardNo = param.body.boardNo;
	    	boardBody.searchEmpSeq = searchEmpSeq;
	    	boardBody.searchField = param.body.searchField;
	    	boardBody.searchValue = param.body.searchValue;
	    	boardBody.currentPage = "1";
	    	boardBody.countPerPage = parseInt(param.body.countPerPage);
	    	boardBody.mobileReqDate = param.body.mobileReqDate;
	    	boardBody.cat_remark = param.body.cat_remark;
	    	boardBody.type = param.body.type;
	    	boardBody.remark_no = param.body.remark_no;
	    	boardBody.serverReq = "W";
	    	
	    	var total = {};
	    	var url = "/edms/board/viewBoard.do";
	    	
	    	//최근 게시글, 공지글 예외처리
	    	if(portletInfo.val1 == "501030000")
	    		url = "/edms/board/viewBoardNewArt.do";
	    	else if(portletInfo.val1 == "501040000")
	    		url = "/edms/board/viewBoardNewNotice.do";
	    	
	    	total.header = boardHeader;
	    	total.body = boardBody;
	    	
	 		$.ajax({
				type: "post",
				contentType :"application/json;",
		         url: url,
		         datatype: "json",
		         data: JSON.stringify(total),
		         async: true,
		         success: function (result) {
		        	
		        	var tag = '';
		        	var boardList = JSON.parse(result)
		        	if(boardList.resultCode == "0") {
		        		var dataList = boardList.result.artList;
		        		
		        		if(dataList != null) {
		        			tag+='<div class="ptl_board freebScrollY"><ul>';
		        			for(var i=0; i<dataList.length; i++) {
		        				if(dataList[i].is_new_yn == "Y" && dataList[i].readYn == "N") {
		        					tag += '<li class="new" >';		
		        					tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" />';
		        				} else {
		        					tag += '<li>';
		        				}
		        				if(dataList[i].replyCnt == "0") {
		        					tag += "<a title=\"" + escapeHtml(dataList[i].art_title) + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ")\">" + escapeHtml(dataList[i].art_title) + "</a>";	
		        				} else {
		        					tag += "<a title=\"" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ")\">" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "</a>";
		        				}
		        			}
		        			tag+='</ul></div>';		            		
		        		}
		        	}
		        	
		        	$( targetDiv ).find("[name=portletTemplete_board_list]").html(tag);
		         },
		         error: function (e) {
		        	 $( targetDiv ).find("[name=portletTemplete_board_list]").html("");
		         }
			});
	    }		
	    
		function render_portletTemplete_doc(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_doc" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find("[name=portletTemplete_doc_list]").html("");
				return;
			}				
			
			$(targetDiv).find("[name=portletTemplete_doc_more]").attr("onclick", "mainMove('DOCUMENT','/doc/viewDocDir.do?dir_cd="+portletInfo.val1+"','"+portletInfo.val1+"');");
			
			var tblParams = {};
			tblParams.dir_cd = portletInfo.val1;
			tblParams.dir_lvl = portletInfo.val3;
			tblParams.count = portletInfo.val4;
						
			$.ajax({
				type: "post",
		         url: '/gw/docPortlet.do',
		         datatype: "json",
		         data: tblParams,
		         async: true,
		         success: function (result) {
		        	var docParam = result.docParams;
		        	fnDrawDoc(docParam, portletInfo, targetDiv);
		         },
		         error: function (e) {
		        	 $( targetDiv ).find("[name=portletTemplete_doc_list]").html("");
		         }
			});		
		}
		
		function fnDrawDoc (param, portletInfo, targetDiv) {
			var gubun = '';
			var searchEmpSeq = new Array();
			var total = {};
			var url = "/edms/doc/viewDocDir.do";
			   	
			var docCompany = {
		   		compSeq: param.body.companyInfo.compSeq,
		   		bizSeq: param.body.companyInfo.bizSeq,
	    		deptSeq: param.body.companyInfo.deptSeq
		   	}
			   	
		   	var docHeader = {
		   		groupSeq: param.header.groupSeq,
		   		empSeq: param.header.empSeq,
		   		tId: param.header.tId,
		   		pId: param.header.pId
		   	}
		   	
		   	var docBody = {
				companyInfo: docCompany,
				langCode: param.body.langCode,
				dir_cd: param.body.dir_cd,
				dir_lvl: param.body.dir_lvl,
				dir_type: "W",
				loginId: param.body.loginId,
				searchField: param.body.searchField,
				searchValue: param.body.searchValue,
				countPerPage: param.body.countPerPage,
				mobileReqDate: param.body.mobileReqDate,
				currentPage: "1"
		   	};
			   	
		   	var docCompany = {
		   		compSeq: param.body.companyInfo.compSeq,
		   		bizSeq: param.body.companyInfo.bizSeq
		   	}
		   	
		   	    	
		   	total.header = docHeader;
		   	total.body = docBody;
		   	
			$.ajax({
				type: "post",
				contentType :"application/json;",
		        url: url,
		        datatype: "json",
		        data: JSON.stringify(total),
		        async: true,
		        success: function (result) {		        	
		        	var tag = '';
		        	var docList = JSON.parse(result);
		        	if(docList.result == "false"){
		       			tag = "<div class='ptl_board freebScrollY'><ul><li><%=BizboxAMessage.getMessage("","본 문서함에 대한 읽기 권한이 없습니다.")%></li></ul></div>";
		       			
		       			$(targetDiv).find("[name=portletTemplete_doc_more]").removeAttr("onclick");
		       			
		        	}else if(docList.resultCode == "0") {
		        		var dataList = docList.result.artList;
		        		
		        		if(dataList != null) {
		        			tag+='<div class="ptl_board freebScrollY"><ul>';
		        			for(var i=0; i<dataList.length; i++) {
		        				if(dataList[i].is_new_yn == "Y" && dataList[i].readYn == "N") {
		        					tag += '<li class="new" >';		
		        					tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" />';
		        				} else {
		        					tag += '<li>';
		        				}
		        				if(dataList[i].replyCnt == "0") {
		        					tag += "<a title=\"" + escapeHtml(dataList[i].art_title) + "\" href=\"javascript:void(0);\" onclick=\"fnDocPop('" + docBody.dir_type + "', " + dataList[i].art_seq_no + ")\">" + escapeHtml(dataList[i].art_title) + "</a>";	
		        				} else {
		        					tag += "<a title=\"" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "\" href=\"javascript:void(0);\" onclick=\"fnDocPop('" + docBody.dir_type + "', " + dataList[i].art_seq_no + ")\">" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "</a>";
		        				}
		        			}
		        			tag+='</ul></div>';		            		
		        		}
		        	}
		        	
		        	if(param.body.showAuthority == "N") {
		        		$(targetDiv).css("display","none");
		        	}
		        	
		        	$( targetDiv ).find("[name=portletTemplete_doc_list]").html(tag);
		    	},
		        error: function (e) {
		    		$( targetDiv ).find("[name=portletTemplete_doc_list]").html("");
		        }
			});
	    }   
		
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
		
		function fnGetWeatherDetailInfo(getItemNm, weatherArray){
			var _data;		
			weatherArray.forEach(function(item){
				if(item.category == getItemNm){
					_data = item.fcstValue;
				}
			});
			
			return _data;
		}
		
		function checkWeatherStorage(locationChangeFlag){		
			var data = JSON.parse(sessionStorage.getItem("bizWeather"));
			
			if(data.header == "00" && locationChangeFlag != true){
				var baseTimes = ["0210","0510","0810","1110","1410","1710","2010","2310"];
				var dateObj = new Date();
				var nowDate = dateObj.getDate();
				var reqDate = new Date(data.reqDate).getDate();
								
				var nowTime = dateObj.getHours().toString() + dateObj.getMinutes().toString();
			    var baseTime = null;
			    
			    for(var i = baseTimes.length - 1; i >= 0; i--) {
			    	var baseTimeDateObj = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), baseTimes[i].substring(0, 2), baseTimes[i].substring(2, 4));
			    	//console.log(_date.getTime() - baseTimeDateObj.getTime());
			    	
			    	if(dateObj.getTime() - baseTimeDateObj.getTime() > 0) {
			    		baseTime = baseTimes[i - 1]
			    		break;
			    	}
			    }
			    
			    // 기상청 API 요청 날짜와 요청 시간이 같으면 기상청 API를 요청하지 않는다.
			    if(nowDate == reqDate && baseTime == data.baseTime) {
			    	return false;
			    } else {
			    	return true;
			    }
				
			}
			return true;
		}
		
		function fnGetWeatherMultiLang(sky, pty) {
			//sky: 하늘상태(1: 맑음, 2: 구름조금, 3: 구름많음, 4: 흐림)
			//pty: 강수형태(0: 강수없음, 1: 비, 2: 비/눈, 3: 눈, 4: 소나기)		
			if(pty != 0) {
				// 소나기가 추가되어 소나기일 경우 1번인 비로 맵핑
				pty = pty == 4 ? 1 : pty;
				return WeatherJson[Number(pty) + 6];
			}
			
			var curHour = new Date().getHours();
			
			if(curHour < 18 || sky == "4"){
				return WeatherJson[Number(sky) - 1];
			}else{
				return WeatherJson[Number(sky) + 3];
			}		
		}
		
		function render_portletTemplete_weather(portletInfo, targetDiv, portletKey, locationChangeFlag){
			var _date;
			var weatherCity = "";
			var location = "";
			var requestParam;
			
			var optionVal = fnSelectPortletUserSet(portletKey, "custValue0");
			
			if(optionVal != null && optionVal != ""){
				var optionInfo = optionVal.split("|");
				
				if(optionInfo.length == 5){
					weatherCity = optionInfo[0];
					
					if(langCode == "kr"){
						location = optionInfo[1];
					}else if(langCode == "en" && optionInfo[2] != ""){
						location = optionInfo[2];
					}else if(langCode == "jp" && optionInfo[3] != ""){
						location = optionInfo[3];
					}else if(langCode == "cn" && optionInfo[4] != ""){
						location = optionInfo[4];
					}else{
						location = optionInfo[1];
					}
				}
			}else if(portletInfo != null && portletInfo != ""){
				weatherCity = portletInfo.val0;
				location = portletInfo.val1;						
			}
			
			$( targetDiv ).html($( "#portletTemplete_weather" ).val());
			$( targetDiv ).find("[name=portletTemplete_weather_location]").attr("weatherCity", weatherCity);
			$( targetDiv ).find("[name=portletTemplete_weather_location]").html(location);
			
			//세션 스토리지 확인
			if(sessionStorage.getItem("bizWeather") == null || checkWeatherStorage(locationChangeFlag)){
								
			    if(weatherCity == null || weatherCity == ""){
			    	weatherCity = "60,127"; // 기본값 서울(woeid)
			    	location = "<%=BizboxAMessage.getMessage("TX000011881","서울")%>";
			    }
			    
			    _date = new Date();
			    var baseTimes = ["0210","0510","0810","1110","1410","1710","2010","2310"];	
			    var nowTime = _date.getHours().toString() + _date.getMinutes().toString();
			    var baseTime = null;
			    
			    
			    for(var i = baseTimes.length - 1; i >= 0; i--) {
			    	var baseTimeDateObj = new Date(_date.getFullYear(), _date.getMonth(), _date.getDate(), baseTimes[i].substring(0, 2), baseTimes[i].substring(2, 4));
			    	//console.log(_date.getTime() - baseTimeDateObj.getTime());
			    	
			    	if(_date.getTime() - baseTimeDateObj.getTime() > 0) {
			    		baseTime = baseTimes[i - 1]
			    		break;
			    	}
			    }
			    			    			    
			    //['0200','0500','0800']
			 	// baseTime 설정 
			 	/*
				if(_date.getHours() < 3){
					baseTime = "2000";
				}else if(_date.getHours() < 5){
					baseTime = "2300";
				}else{
					baseTime = Math.round(_date.getHours() / 3) * 3 - 4; 
					
					if(baseTime < 10){
						baseTime = "0" + baseTime + "00";
					}else{
						baseTime = baseTime + "00";
					}
				}
			    */
			    
			    requestParam = {
					baseDate: new Date().toISOString().slice(0,10).replace(/-/gi,""),
					baseTime: baseTime,
					location: weatherCity
				}
			    
			   	console.log(requestParam);
	
			    $.ajax({
		            url: "/gw/cmm/systemx/weather/getWeather.do",
		            type: "POST",
		            data: requestParam,
					dataType: "json",
		            success: function (_data) {		            	
		            	var data = _data.result.response;
		            	
		            	console.log(_data);
		            	
						if(data.header.resultCode == "00"){
							resultJson = {
								header: data.header.resultCode,
								headerMsg: data.header.resultMsg,
								baseDate: data.body.items.item[0].baseDate,
								baseTime: baseTime,
								fcstTime: data.body.items.item[0].fcstTime,
								pty: fnGetWeatherDetailInfo("PTY",data.body.items.item),
								sky: fnGetWeatherDetailInfo("SKY",data.body.items.item),
								t3h: fnGetWeatherDetailInfo("T3H",data.body.items.item),
								reqDate: new Date()
							};
							resultJson.multi = fnGetWeatherMultiLang(resultJson.sky, resultJson.pty);
						}else{
							resultJson = {
								header: data.header.resultCode,
								headerMsg: data.header.resultMsg
							}
						}
						console.log(resultJson)
						sessionStorage.setItem("bizWeather", JSON.stringify(resultJson));
						fnSetWeatherInfo(targetDiv, resultJson);
		            },
		            error: function (jqXHR, textStatus, ex) {
		            	_date = new Date();
						resultJson = {
							header: "30",	
							headerMsg: '<%=BizboxAMessage.getMessage("TX000003199","접속이 원활하지 않습니다.")%>'
						};					
						//localStorage.setItem("bizWeather", JSON.stringify(resultJson));
						fnSetWeatherInfo(targetDiv, resultJson);
		           	}
		        });
			}else{
				fnSetWeatherInfo(targetDiv);
			}
		}
		
		function fnConvertWeatherNm(multi) {
			switch (langCode) {
		        case 'kr':
		            return multi.kr;
		            break;
		        case 'jp':
		            return multi.jp;
		            break;
		        case 'en':
		            return multi.en;
		            break;
		        case 'cn':
		            return multi.cn;
		            break;
		        case 'gb':
		            return multi.gb;
		            break;
		        default:
		            return multi.kr;
		    }
		}	
		
		//날씨정보 setting
		function fnSetWeatherInfo(targetDiv, resultJson) {
			
			if(!resultJson) {
				resultJson = JSON.parse(sessionStorage.getItem("bizWeather"));
			}
			
			var imgUrl = "<c:url value='/Images/UC/weather_source/' />";
			if (resultJson != null && resultJson.header == "00") {
		        $( targetDiv ).find("[name=portletTemplete_weather_img]").attr("src", imgUrl + resultJson.multi.img);
		        $( targetDiv ).find("[name=portletTemplete_weather_temp]").html(resultJson.t3h);
		       	$( targetDiv ).find("[name=portletTemplete_weather_desc]").html(fnConvertWeatherNm(resultJson.multi));
		       	
		       	sessionStorage.removeItem("bizWeather");
		       	sessionStorage.setItem("bizWeather", JSON.stringify(resultJson));
		    }else{
		    	var storageBeforWeather = JSON.parse(sessionStorage.getItem("bizWeather"));
		    	
		    	// 로컬스토리지에 이전 날씨 정상적인 정보가 있으면 이전 날씨 정보를 보여준다. 
		    	if((storageBeforWeather !== undefined || storageBeforWeather !== "" || storageBeforWeather !== null)) {
		    		$( targetDiv ).find("[name=portletTemplete_weather_img]").attr("src", imgUrl + storageBeforWeather.multi.img);
			        $( targetDiv ).find("[name=portletTemplete_weather_temp]").html(storageBeforWeather.t3h);
			       	$( targetDiv ).find("[name=portletTemplete_weather_desc]").html(fnConvertWeatherNm(storageBeforWeather.multi));
			    	$( targetDiv ).find("[name=portletTemplete_weather_desc]").css("max-width","80px");
			    	//$( targetDiv ).find("[name=portletTemplete_weather_temp]").css("background","");
		    	} else {
		    		// 로컬스토리지에 이전 날씨 오류 정보가 있으면 오류 날씨 이미지를 보여준다.
		    		$( targetDiv ).find("[name=portletTemplete_weather_img]").attr("src", imgUrl + "25.png");
		    	}
		    	
		    	fnSetWeatherError(resultJson);
		    }
		    $("#weather0").hide();
		    $("#weather1").show();
		}
		
		/* 로컬스토리지에 에러 로그 저장 */
		function fnSetWeatherError(resultJson) {
			var result = resultJson;
			result["nowDate"] = new Date();
			localStorage.setItem("bizWeatherError", JSON.stringify(result));
		}		
		
		function render_portletTemplete_note(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_note" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
		
			$.ajax({
			   type:"POST",
		       contentType: "application/json; charset=utf-8",
		       dataType: "json",
		       async: true,
		       url: '/schedule/WebNote/SearchNoteList',
		       data: JSON.stringify({"companyInfo":'', "deptSeq":'' , "empSeq":'', "langCode":'kr', "folderSeq":'', "sechText":''}),
		       success: function(result) {
		    	   
		    	   var noteData = result.result;
		    	   var tag = '';
		    	   
		    	   if(noteData.length == 0) {
		           		tag += '<div class="main_nocon">';
		           		tag += '<table style="background-color:white;">';
		        		tag += '<tr>';
		        		tag += '<td>';
		        		var url = "/Views/Common/note/noteList";	
		        		tag += "<a href=\"javascript:void(0);\" onclick=\"mainMove('NOTE', '" + url + "','')\"><%=BizboxAMessage.getMessage("TX000018942","노트등록")%></a>";
		        		tag += '<br />';
		        		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000015471","노트를 등록하세요.")%></span>';
		        		tag += '</td>';
		        		tag += '</tr>';
		        		tag += '</table>';
		        		tag += '</div>';	    		   
		    	   } else {
		    		   tag+='<div class="ptl_board freebScrollY"><ul>';
		    		   for(var i=0; i<noteData.length; i++) {
		    		   	   var strDate = noteData[i].createDate;
		    			   var createDate = strDate.substring(0,4) + '-' + strDate.substring(4,6) + '-' + strDate.substring(6,8); 
							createDate = new Date(createDate);
							
		    				if(createDate.getTime() > specificDate.getTime()) {
		    					tag += '<li class="new">';	
		    					tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" />';
		    				} else {
		    					tag += '<li>';
		    				}
		    				var url = "/Views/Common/note/noteList.do?noteSeq=" + noteData[i].noteSeq;	
		  					tag += "<a title=\"" + noteData[i].noteTitle + "\" href=\"javascript:void(0);\" onclick=\"fnNotePop(" + noteData[i].noteSeq + ")\"><span class=\"txt\">" + noteData[i].noteTitle + "</span></a>";
		    				tag += '</li>';
		    		   }
		    		   tag+='</ul></div>';
		    	   }
		    	   $("[name=portletTemplete_note_list]").html(tag);
		       }, 
		       error:function(e) {
		    	   $("[name=portletTemplete_note_list]").html("");
		       }
			});			
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
		
		function render_portletTemplete_web_sign(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_web_sign" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			if(portletInfo != null && portletInfo != "" && portletInfo.val0 != ""){
				
				if(eaType == "ea"){
					$(targetDiv).find("[name=portletTemplete_web_sign_more]").attr("href", "javascript:fnEventMainMoveNon('"+portletInfo.val0+"');");
				}else{
					$(targetDiv).find("[name=portletTemplete_web_sign_more]").attr("href", "javascript:fnEventMainMove('"+portletInfo.val0+"');");
				}
				
				var optionValue = "";
				var tblParams = {};
				
				if(Array.isArray(portletInfo.val0) === true) {
					portletInfo.val0.forEach(function(item){
						optionValue += item.menu_seq + ",";
					});
					tblParams.val0 = optionValue.slice(0,-1);
				} else {
					tblParams.val0 = portletInfo.val0;
				}
				
				tblParams.val1 = portletInfo.val1;
				
				var apiName = eaType == "ea" ? "/ea/edoc/main/EaPortletCloudList.do" : "/eap/ea/edoc/main/EaPortletCloudList.do";
				
				$.ajax({
					type: "post",
		            url: apiName,
		            datatype: "json",
		            data: tblParams,
		            async: true,
		            success: function (result) {
		            	
		            	var eapPortletDocList = JSON.parse(result.EaPortletDocList);
		            			            	
		            	if(eapPortletDocList.length > 0) {
		            		
		            		var tag = '';
		            		
		            		tag+='<div class="ptl_approval freebScrollY"><ul>';
		            		
		            		if(eaType == "ea"){
		            			
			            		/* [시작] */
			                	for(var i=0; i<eapPortletDocList.length; i++) {
			                		tag += '<li>';
			                		tag += '<dl>';
			                	       /* [아이콘] */
			                        switch(eapPortletDocList[i].docSts) {
			                        	//미결
			                        	case '002' : tag += '<dd class="sign bg_orange"><%=BizboxAMessage.getMessage("TX000003976","미결")%></dd>'
			                				break;
			                            //협조
			                            case '003' : tag += '<dd class="sign bg_orange"><%=BizboxAMessage.getMessage("TX000003976","미결")%></dd>'
			                       			break;  
		                          		//기결
		                          	    case '008' : tag += '<dd class="sign gray"><%=BizboxAMessage.getMessage("TX000004824","종결")%></dd>'
			                       			break;
		                                //반려
		                                case '007' : tag += '<dd class="sign bg_red2"><%=BizboxAMessage.getMessage("TX000002954","반려")%></dd>'
		                           			break;
		                                //회수
		                                case '005' : tag += '<dd class="sign bg_darkgray"><%=BizboxAMessage.getMessage("TX000003999","회수")%></dd>'
		                           			break;
		                                //보류
		                                case '004' : tag += '<dd class="sign bg_yellow2"><%=BizboxAMessage.getMessage("TX000003206","보류")%></dd>'
		                                	break;
			                        	default :  '<dd class="sign gray"></dd>'
			                        		break;
			                        }
			                		
			                        /* [작성부서 기안자] 문서제목 [신규 아이콘] */
			                        tag += '<dt class="title">';
			                        if ((eapPortletDocList[i].docTitle || '') != '') {
			                            tag += '<a href="#" title="' + escapeHtml(eapPortletDocList[i].docTitle) + '" onclick="javascript:fnEventDocTitleNon(\'' + eapPortletDocList[i].docId + '\')">' + (tblParams.val2 == 'Y' ? '[' + eapPortletDocList[i].empName + ']' : '' ) + escapeHtml(eapPortletDocList[i].docTitle) + '</a>';
			                            if ((eapPortletDocList[i].readYN || '') == 'N') {
			                                tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" />';
			                            }
			                        } else {
			                            tag += '';
			                        }
			                        tag += '</dt>';
			
			                        /* [기안일자] */
			                        tag += '<dd class="date">';
			                        if ((eapPortletDocList[i].repDt || '') != '') {
			                            tag += ncCom_Date(eapPortletDocList[i].repDt.substr(0,8) , "SYMD");
			                        } else {
			                            tag += '';
			                        }			                        
			                        tag += '</dd>';
			
			                        /* [첨부파일 아이콘] */
			                        tag += '<dd class="file">';
			                        if ((eapPortletDocList[i].attachCnt || '') > 0) {
			                            tag += '<img src="' + '<c:url value="/Images/ico/ico_file.png" />' + '" alt="첨부파일">';
			                        } else {
			                            tag += '';
			                        }
			                        tag += '</dd></dl></li>';
			                	}		            			
		            			
		            		}else{
		            			/* [시작] */
		                    	for(var i=0; i<eapPortletDocList.length; i++) {
		                    		tag += '<li>';
		                    		tag += '<dl>';
		                    		/* [아이콘] */
		                            switch(eapPortletDocList[i].RET_ITEM_CD) {
		                            	//상신
		                            	case '10' : tag += '<dd class="sign blue">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                            		break;
		                            	//미결
		                            	case '20' : tag += '<dd class="sign orange">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//기결
		                            	case '30' : tag += '<dd class="sign gray">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//기결
		                            	case '40' : tag += '<dd class="sign bluegreen">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//반려
		                            	case '50' : tag += '<dd class="sign red">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//반려
		                            	case '51' : tag += '<dd class="sign red">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//참조
		                            	case '60' : tag += '<dd class="sign purple">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//예결
		                            	case '70' : tag += '<dd class="sign yellow">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//후결
		                            	case '80' : tag += '<dd class="sign bluegreen">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//전결
		                            	case '90' : tag += '<dd class="sign bluegreen">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//수신
		                            	case '100' : tag += '<dd class="sign orange">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//보류
		                            	case '110' : tag += '<dd class="sign gray">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//시행
		                            	case '120' : tag += '<dd class="sign blue">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;
		                            	//회람
		                            	case '130' : tag += '<dd class="sign purple">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
		                    				break;                	
		                            	default :  '<dd class="sign gray"></dd>'
		                            		break;
		                            }
		                    		
		                    		tag += '<dt class="title">';
		                    		if ((eapPortletDocList[i].DISP_TITLE || '') != '') {
		                                /* [작성부서 기안자] 문서제목 [신규아이콘] - [작성부서 기안자] 문서제목 */
		                    			if(portletInfo.val2 == "Y"){
		                    				tag += '<a title="' + escapeHtml(eapPortletDocList[i].DISP_TITLE) + '" href="#" onclick="javascript:fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ')">' + escapeHtml(eapPortletDocList[i].DISP_TITLE) + '</a>';
		                                } else {
		                                	tag += '<a title="' + escapeHtml(eapPortletDocList[i].DOC_TITLE_ORIGIN) + '" href="#" onclick="javascript:fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ')">' + escapeHtml(eapPortletDocList[i].DOC_TITLE_ORIGIN) + '</a>';
		                                }
		                                
		                                /* [작성부서 기안자] 문서제목 [신규아이콘] -  [신규아이콘] */
		                                if ((eapPortletDocList[i].READYN || '') == 'N') {
		                                    tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" />';
		                                }
		                            } else {
		                                tag += '';
		                            }
		                    		tag += '</dt>';

		                    		/* [기안일자] */
		                            tag += '<dd class="date">';
		                            if ((eapPortletDocList[i].REP_DT || '') != '') {
		                                tag += eapPortletDocList[i].REP_DT;
		                            } else {
		                                tag += '';
		                            }		                    		
		                            tag += '</dd>';

		                    		/* [첨부파일 아이콘] */
		                            tag += '<dd class="file">';
		                            if ((eapPortletDocList[i].DISP_ATTACH || '') == 'attach') {
		                                tag += '<img src="' + '<c:url value="/Images/ico/ico_file.png" />' + '" alt="첨부파일">';
		                            } else {
		                                tag += '';
		                            }		                            
		                            tag += '</dd></dl></li>';
		                    	}		            			
		            		}
		            		
		            		tag+='</ul></div>';
		            		$(targetDiv).find("[name=portletTemplete_web_sign_list]").html(tag);
		            		
		            	} else {
		            		$(targetDiv).find("[name=portletTemplete_web_sign_list]").html("");
		            	}
		            },
		            error: function (e) {
		            	$(targetDiv).find("[name=portletTemplete_web_sign_list]").html("");
		            }
				});				
			}else{
				$(targetDiv).find("[name=portletTemplete_web_sign_list]").html("");
			}
		}		
		
		function render_portletTemplete_sign_status(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_sign_status" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html("");
				return;
			}			
			
			var apiName = eaType == "ea" ? "/gw/nonEaInfoCount.do" : "/gw/eapInfoCount.do";
			
			$.ajax({
				type: "post",
	            url: apiName,
	            datatype: "json",
	            async: true,
	            success: function (result) {

	            	var tag = '';
	               	
	               	if(result.eapInfoCount != null && result.eapInfoCount.resultCode == "SUCCESS") {
	               		
	               		var eapInfoCountData = result.eapInfoCount.result.boxList;
	               		
	               		var eaBox1 = "";
	               		var eaBox2 = "";
	               		var eaBox3 = "";
	               		var eaBox4 = "";
	               		var eaBox5 = "";
	               		var eaBox6 = "";
	               		
	               		var menuName1 = "";
	               		var menuName2 = "";
	               		var menuName3 = "";
	               		var menuName4 = "";		
	               		var menuName5 = "";
	               		var menuName6 = "";
	               		
	               		if(eapInfoCountData.length > 0){
	               			
	               			tag+='<div class="mdst"><ul>';
	               			
	               			if(eaType == "ea"){
	               				
	                       		for(var i=0; i<eapInfoCountData.length; i++) {
	                       			if(eapInfoCountData[i].menuId == "102010000") {
	                       				eaBox1 = eapInfoCountData[i].alramCnt;
	                       				menuName1 = eapInfoCountData[i].menuName;
	                       			} else if(eapInfoCountData[i].menuId == "102030000") {
	                       				eaBox2 = eapInfoCountData[i].docCnt;
	                       				menuName2 = eapInfoCountData[i].menuName;
	                       			} else if(eapInfoCountData[i].menuId == "102040000") {
	                       				eaBox3 = eapInfoCountData[i].docCnt;
	                       				menuName3 = eapInfoCountData[i].menuName;
	                       			} else if(eapInfoCountData[i].menuId == "101030000") {
	                       				eaBox4 = eapInfoCountData[i].alramCnt;
	                       				menuName4 = eapInfoCountData[i].menuName;
	                       			} else if(eapInfoCountData[i].menuId == "101060000") {
	                       				eaBox5 = eapInfoCountData[i].alramCnt;
	                       				menuName5 = eapInfoCountData[i].menuName;
	                       			} else if(eapInfoCountData[i].menuId == "102020000") {
	                       				eaBox6 = eapInfoCountData[i].alramCnt;
	                       				menuName6 = eapInfoCountData[i].menuName;
	                       			}
	                       		}
	                       		
	                       		if(portletInfo.val00) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName1 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102010000\');" class=" fwb"><span class="text_red">' + eaBox1 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		} 
	                       		
	                       		if(portletInfo.val01) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName2 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102030000\');" class=" fwb"><span class="text_red">' + eaBox2 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                       		
	                       		if(portletInfo.val02) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName3 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102040000\');" class=" fwb"><span class="text_blue">' + eaBox3 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                          		
	                       		if(portletInfo.val03) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName4 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'101030000\');" class=" fwb"><span class="text_blue">' + eaBox4 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                        		
	                       		if(portletInfo.val04) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName5 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'101060000\');" class=" fwb"><span class="text_blue">' + eaBox5 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                        		
	                       		if(portletInfo.val05) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName6 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102020000\');" class=" fwb"><span class="text_blue">' + eaBox6 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}	               				
	               				
	               			}else{
	               				for(var i=0; i<eapInfoCountData.length; i++) {
			               			if(eapInfoCountData[i].menuId == "2002020000") {
			               				eaBox1 = eapInfoCountData[i].alramCnt;
			               				menuName1 = eapInfoCountData[i].menuName;
			               			} else if(eapInfoCountData[i].menuId == "2002030000") {
			               				eaBox2 = eapInfoCountData[i].alramCnt;
			               				menuName2 = eapInfoCountData[i].menuName;
			               			} else if(eapInfoCountData[i].menuId == "2002090000") {
			               				eaBox3 = eapInfoCountData[i].alramCnt;
			               				menuName3 = eapInfoCountData[i].menuName;
			               			} else if(eapInfoCountData[i].menuId == "2002010000") {
			               				eaBox5 = eapInfoCountData[i].alramCnt;
			               				menuName5 = eapInfoCountData[i].menuName;
			               			}
			               		}	
	               				
			               		if(portletInfo.val00) {
			               			tag+='<li>';
			                      		tag+='<dl>';
			                      		tag+='<dt>' + menuName1 + '</dt>';
			                      		tag+='<dd><a href="javascript:fnEventMainMove(\'2002020000\');" class=" fwb"><span class="text_red">' + eaBox1 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
			                      		tag+='</dl>';
			                      		tag+='</li>';
			               		} 
			               		
			               		if(portletInfo.val01) {
			               			tag+='<li>';
			                      		tag+='<dl>';
			                      		tag+='<dt>' + menuName2 + '</dt>';
			                      		tag+='<dd><a href="javascript:fnEventMainMove(\'2002030000\');" class=" fwb"><span class="text_red">' + eaBox2 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
			                      		tag+='</dl>';
			                      		tag+='</li>';
			               		}
			               		
			               		if(portletInfo.val02) {
			               			tag+='<li>';
			                      		tag+='<dl>';
			                      		tag+='<dt>' + menuName3 + '</dt>';
			                      		tag+='<dd><a href="javascript:fnEventMainMove(\'2002090000\');" class=" fwb"><span class="text_blue">' + eaBox3 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
			                      		tag+='</dl>';
			                      		tag+='</li>';
			               		}
			                  		
		                  		if(portletInfo.val04) {
		                  			tag+='<li>';
		                      		tag+='<dl>';
		                      		tag+='<dt><%=BizboxAMessage.getMessage("TX000000475","진행중")%></dt>';
		                      		tag+='<dd><a href="javascript:fnEventMainMove(\'2002010000\');" class=" fwb"><span class="text_blue">' + eaBox5 + '</span><%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>';
		                      		tag+='</dl>';
		                      		tag+='</li>';
		                  		}	               				
	               			}
	                  		tag+='</ul></div>';		               		
	               		}
	               	}
	            	
	               	$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html(tag);
	            },
	            error: function (e) {
	            	$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html("");
	            }
			});			
		}		

		function render_portletTemplete_sign_form(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_sign_form" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$(targetDiv).find("[name=portletTemplete_sign_form_list]").html("");
				return;
			}			
			
			var optionVal = fnSelectPortletUserSet($( targetDiv ).attr("portletKey"), "custValue0");
			
			if(optionVal != null || (portletInfo != null && portletInfo != "" && portletInfo.val0 != "")){
				var tblParams = {};

				if(optionVal != null){
					tblParams.opValue = optionVal;
				}else{
					tblParams.opValue = portletInfo.val0;
				}
				
				var apiName = eaType == "ea" ? "/gw/nonEaFormList.do" : "/gw/eaFormList.do";
				
				$.ajax({
					type: "post",
		            url: apiName,
		            datatype: "json",
		            data: tblParams,
		            async: true,
		            success: function (result) {
		            	
		            	var eaFormData = result.list;
		            	
		            	if(eaFormData.length > 0) {
		            		
			            	var tag = '<div class="ptl_list freebScrollY">';
			            	tag+='<ul>';		            		
		            		
		            		for(var i=0; i<eaFormData.length; i++) {
		            			if(eaFormData[i].spriteCssClass != "folder") {
		            				if(eaType == "ea"){
		            					tag += "<li name='eaForm' id='" + eaFormData[i].CODE + "'>";
		            					tag += "<a href='#' title=\"" + escapeHtml(eaFormData[i].CODE_NM) + "\" onclick='formOpen_main(" + JSON.stringify(eaFormData[i]) + ")'>" + escapeHtml(eaFormData[i].CODE_NM) + "</a>";
		            						
		            				}else{
		            					tag += "<li name='eaForm' id='" + eaFormData[i].formId + "'>";
		            					tag += "<a href='#' title=\"" + escapeHtml(eaFormData[i].formNm) + "\" onclick='fn_set(" + JSON.stringify(eaFormData[i]) + ")'>" + escapeHtml(eaFormData[i].formNm) + "</a>";
		            				}
		            				tag += "</li>";	
		            			}
		            		}		            			
		            		
			            	tag+='</ul></div>';
			            	$(targetDiv).find("[name=portletTemplete_sign_form_list]").html(tag);		            		
		            	}else{
		            		$(targetDiv).find("[name=portletTemplete_sign_form_list]").html("");
		            	}
		            },
		            error: function (e) {
		            	console.log("error:fnDrawEaFormPortlet() " + e);
		            }
				}); 				
			}else{
				$(targetDiv).find("[name=portletTemplete_sign_form_list]").html("");
			}
		}		
		
		function render_portletTemplete_mybox(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_mybox" ).val());
			
			if('${empCheckWorkYn}' == "Y" && (portletInfo.val01 == "Y" || portletInfo.val02 == "Y")){

				var comeDt = '${userAttInfo.comeDt}';
				var leaveDt = '${userAttInfo.leaveDt}';
				
				if(comeDt.length == 14){
					var comeTime = portletInfo.val02 == 'Y' ? comeDt.substring(0,4) + '.' + comeDt.substring(4,6) + '.' + comeDt.substring(6,8) + ' ' + comeDt.substring(8,10) + ':' + comeDt.substring(10,12) + ':' + comeDt.substring(12,14) : '';
					$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근")%></em> ' + comeTime + " " + '&nbsp;&nbsp;');
				}else{
					$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음")%></em>' + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(1);" style="cursor: pointer;"><img alt="" src="/gw/Images/np_myinfo_in_blue.png"></a>' : ''));
				}
				
				if(leaveDt.length == 14){
					var leaveTime = portletInfo.val02 == 'Y' ? leaveDt.substring(0,4) + '.' + leaveDt.substring(4,6) + '.' + leaveDt.substring(6,8) + ' ' + leaveDt.substring(8,10) + ':' + leaveDt.substring(10,12) + ':' + leaveDt.substring(12,14) : '';
					$( targetDiv ).find("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근")%></em> ' + leaveTime + " " + '&nbsp;&nbsp;');
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
	    	
			<!-- portlet thumbnail -->
			<div class="portletThumbnail">
				<div class="portletList freebScrollX_dark">
					<ul class="clear">
						
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_mybox"
								><span><%=BizboxAMessage.getMessage("TX000016693","내정보")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_notice"
								><span><%=BizboxAMessage.getMessage("TX000021503","통합알림")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>4</em></span></li>		
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_sign_form"
								><span><%=BizboxAMessage.getMessage("TX000010095","결재양식")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_sign_status"
								><span><%=BizboxAMessage.getMessage("TX000022827","결재현황")%><em>(<%=BizboxAMessage.getMessage("TX900000502","영리")%>/<%=BizboxAMessage.getMessage("TX900000503","비영리")%>)<br /><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>1</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_web_sign"
								><span><%=BizboxAMessage.getMessage("TX000000479","전자결재")%><em>(<%=BizboxAMessage.getMessage("TX900000502","영리")%>/<%=BizboxAMessage.getMessage("TX900000503","비영리")%>)<br /><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>						
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_mail_status"
								><span><%=BizboxAMessage.getMessage("TX000022828","메일현황")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>1</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_inbox"
								><span><%=BizboxAMessage.getMessage("TX000001580","받은편지함")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_board"
								><span><%=BizboxAMessage.getMessage("TX000011134","게시판")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_survey"
								><span><%=BizboxAMessage.getMessage("TX000002747","설문조사")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_calendar_horizontal"
								><span><%=BizboxAMessage.getMessage("TX000022829","일정캘린더")%><em>(<%=BizboxAMessage.getMessage("TX900000499","가로형")%>)<br /><%=BizboxAMessage.getMessage("TX000016738","가로")%>4x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_calendar_vertical"
								><span><%=BizboxAMessage.getMessage("TX000022829","일정캘린더")%><em>(<%=BizboxAMessage.getMessage("TX900000500","세로형")%>)<br /><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>4</em></span></li>
								
						<!--								
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_task_status"
								><span>업무현황<em>가로2x세로2</em></span></li>
						-->		
								
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_note"
								><span><%=BizboxAMessage.getMessage("TX000010157","노트")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_doc"
								><span><%=BizboxAMessage.getMessage("TX000018123","문서")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_weather"
								><span><%=BizboxAMessage.getMessage("TX000016704","날씨")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>1</em></span></li>						
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_iframe_banner"
								><span><%=BizboxAMessage.getMessage("TX900000498","배너")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>2x<%=BizboxAMessage.getMessage("TX000016739","세로")%>2</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_iframe_quick"
								><span><%=BizboxAMessage.getMessage("TX000016104","퀵링크")%><em><%=BizboxAMessage.getMessage("TX000016738","가로")%>10x<%=BizboxAMessage.getMessage("TX000016739","세로")%>1</em></span></li>
						<li class="dragPortletThumb"
								pudd-portlet-box-type="portletTemplete_iframe_outer"
								><span>iframe<em>(<%=BizboxAMessage.getMessage("GWLANG000003","외부링크")%>)<br /><%=BizboxAMessage.getMessage("TX000016738","가로")%>1x<%=BizboxAMessage.getMessage("TX000016739","세로")%>1</em></span></li>
					</ul>
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

				<!-- weather -->
				<textarea id="demo_portletTemplete_weather" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="ptl_weather">
							<div style="" id="weather1">
								<!-- 날씨이미지 -->
								<div class="ptl_weather_ico"><img src="/gw/js/portlet/Images/freeb/weather_source/12.png"></div>
								<!-- 날씨정보 -->
								<div class="ptl_weather_info">
									<div class="weather_location">
										<span class="loc_txt01"><%=BizboxAMessage.getMessage("TX000011881","서울")%></span>
									</div>
									<div class="weather_celsius">
										<span>5</span>
									</div>
									<p class="weather_desc"><%=BizboxAMessage.getMessage("TX000010950","비")%></p>
								</div>
							</div>
							<p align="center" id="weather0" style="display: none;"><img src="/gw/js/portlet/Images/freeb/weather_source/loading.gif" style="opacity: 0.2;" alt=""></p>
						</div>
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

				<!-- board -->
				<textarea id="demo_portletTemplete_board" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span><%=BizboxAMessage.getMessage("TX000011134","게시판")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_board freebScrollY">
							<ul>
								<li class="new">
									<a title="게시판 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000506","게시판 제목이 노출됩니다.")%></a>
									<img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new">
								</li>
								<li>
									<a title="게시판 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000506","게시판 제목이 노출됩니다.")%></a>
									<img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new">
								</li>
								<li><a title="게시판 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000506","게시판 제목이 노출됩니다.")%></a></li>
							</ul>
						</div>
					</div>
				</textarea>
				
				<!-- 문서 포틀릿 -->
				<textarea id="demo_portletTemplete_doc" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span><%=BizboxAMessage.getMessage("TX000018123","문서")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_board freebScrollY">
							<ul>
								<li class="new">
									<a title="문서 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000501","문서 제목이 노출됩니다.")%></a>
									<img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new">
								</li>
								<li class="new">
									<a title="문서 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000501","문서 제목이 노출됩니다.")%></a>
									<img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new">
								</li>
								<li><a title="문서 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000501","문서 제목이 노출됩니다.")%></a></li>
							</ul>
						</div>
					</div>
				</textarea>

				<!-- sign form -->
				<textarea id="demo_portletTemplete_sign_form" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ea">
						<span><%=BizboxAMessage.getMessage("TX000010095","결재양식")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="ptl_list freebScrollY">
							<ul>
								<li><a href="#n" title="양식명이 들어갑니다."><%=BizboxAMessage.getMessage("TX000003030","기안서")%></a></li>
								<li><a href="#n" title="양식명이 들어갑니다."><%=BizboxAMessage.getMessage("TX000022701","품의서")%></a></li>
								<li><a href="#n" title="양식명이 들어갑니다."><%=BizboxAMessage.getMessage("TX000018760","지출결의")%></a></li>
								<li><a href="#n" title="양식명이 들어갑니다."><%=BizboxAMessage.getMessage("TX000017269","휴가신청서")%></a></li>
								<li><a href="#n" title="양식명이 들어갑니다."><%=BizboxAMessage.getMessage("TX000017270","휴직신청서")%></a></li>
							</ul>
						</div>
					</div>
				</textarea>

				<!-- sign status -->
				<textarea id="demo_portletTemplete_sign_status" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ea">
						<span><%=BizboxAMessage.getMessage("TX000022827","결재현황")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<div class="mdst">
							<ul>
								<li>
									<dl>
										<dt><%=BizboxAMessage.getMessage("TX000005555","미결함")%></dt>
										<dd><a href="#n" class="fwb"><span class="text_red">17</span> <%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt><%=BizboxAMessage.getMessage("TX000005560","수신참조함")%></dt>
										<dd><a href="#n" class="fwb"><span class="text_blue">145</span> <%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt><%=BizboxAMessage.getMessage("TX000000475","진행중")%></dt>
										<dd><a href="#n" class="fwb"><span class="text_blue">11</span> <%=BizboxAMessage.getMessage("TX000000476","건")%></a></dd>
									</dl>
								</li>
							</ul>
						</div>
					</div>
				</textarea>

				<!-- web sign -->
				<textarea id="demo_portletTemplete_web_sign" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ea">
						<span><%=BizboxAMessage.getMessage("TX000000479","전자결재")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_approval freebScrollY">
							<ul>
								<li class="new">
									<dl class="nosign">
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000502","[개발1팀 홍길동] 20150410 휴가신청를 올려드립니다.")%></a><img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new"/></dt>
										<dd class="date">15.04.08</dd>
										<dd class="file"><img src="/gw/js/portlet/Images/ico/ico_file.png" alt="첨부파일"></dd>
									</dl>
								</li>
								<li class="new">
									<dl>
										<dd class="sign red"><%=BizboxAMessage.getMessage("TX000002954","반려")%></dd>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000502","[개발1팀 홍길동] 20150410 휴가신청를 올려드립니다.")%></a><img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new"/></dt>
										<dd class="date">15.04.10</dd>
										<dd class="file"><img src="/gw/js/portlet/Images/ico/ico_file.png" alt="첨부파일"></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dd class="sign gray"><%=BizboxAMessage.getMessage("TX000004824","종결")%></dd>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000502","[개발1팀 홍길동] 20150410 휴가신청를 올려드립니다.")%></a></dt>
										<dd class="date">15.04.08</dd>
										<dd class="file"><img src="/gw/js/portlet/Images/ico/ico_file.png" alt="첨부파일"></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dd class="sign orange"><%=BizboxAMessage.getMessage("TX000003976","미결")%></dd>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000502","[개발1팀 홍길동] 20150410 휴가신청를 올려드립니다.")%></a><img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new"/></dt>
										<dd class="date">15.04.08</dd>
										<dd class="file"><img src="/gw/js/portlet/Images/ico/ico_file.png" alt="첨부파일"></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dd class="sign blue"><%=BizboxAMessage.getMessage("TX000000735","진행")%></dd>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000502","[개발1팀 홍길동] 20150410 휴가신청를 올려드립니다.")%></a><img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new"/></dt>
										<dd class="date">15.04.08</dd>
										<dd class="file"><img src="/gw/js/portlet/Images/ico/ico_file.png" alt="첨부파일"></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dd class="sign yellow"><%=BizboxAMessage.getMessage("TX000001870","예결")%></dd>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000502","[개발1팀 홍길동] 20150410 휴가신청를 올려드립니다.")%></a><img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new"/></dt>
										<dd class="date">15.04.08</dd>
										<dd class="file"><img src="/gw/js/portlet/Images/ico/ico_file.png" alt="첨부파일"></dd>
									</dl>
								</li>
								<li>
									<dl>
										<dd class="sign green"><%=BizboxAMessage.getMessage("TX000001227","후결")%></dd>
										<dt class="title"><a href="#n"><%=BizboxAMessage.getMessage("TX900000502","[개발1팀 홍길동] 20150410 휴가신청를 올려드립니다.")%></a><img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new"/></dt>
										<dd class="date">15.04.08</dd>
										<dd class="file"><img src="/gw/js/portlet/Images/ico/ico_file.png" alt="첨부파일"></dd>
									</dl>
								</li>
							</ul>
						</div>
					</div>
				</textarea>

				<!-- note -->
				<textarea id="demo_portletTemplete_note" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="nt">
						<span><%=BizboxAMessage.getMessage("TX000010157","노트")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_board freebScrollY">
							<ul>
								<li class="new">
									<a title="노트 제목이 노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다노출됩니다." href="javascript:void(0);">
										<%=BizboxAMessage.getMessage("TX900000503","노트 제목이 노출됩니다.")%>
									</a>
									<img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new">
								</li>
								<li>
									<a title="노트 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000503","노트 제목이 노출됩니다.")%></a>
									<img src="/gw/js/portlet/Images/ico/icon_new.png" alt="new" class="new">
								</li>
								<li><a title="노트 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000503","노트 제목이 노출됩니다.")%></a></li>
								<li><a title="노트 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000503","노트 제목이 노출됩니다.")%></a></li>
								<li><a title="노트 제목이 노출됩니다." href="javascript:void(0);"><%=BizboxAMessage.getMessage("TX900000503","노트 제목이 노출됩니다.")%></a></li>
							</ul>
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

				<!-- survey -->
				<textarea id="demo_portletTemplete_survey" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="su">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000002747","설문조사")%></span>
						<a href="#n" class="more" title="더보기"></a>
					</h2>
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
						<div class="ptl_survey">
							<div class="question freebScroll">
								<!-- 설문예시 -->
								<%=BizboxAMessage.getMessage("TX900000530","테스트 질문입니다.")%><br />
								<!-- //설문예시 -->
							</div>
							<div class="btn_cen">
								<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000000907","참여")%>" />
								<input type="button" class="puddSetup gray_btn" value="<%=BizboxAMessage.getMessage("TX000001748","결과")%>" />
							</div>
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
														- <%=BizboxAMessage.getMessage("TX900000522","제목 : 연차휴가 신청의 건")%><br />
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
				
				<!-- 문서 포틀릿 -->
				<textarea id="portletTemplete_doc" style="display:none;">
					<h2 name="portletTemplete_doc_more" style="cursor:pointer;" class="bd">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000008627","문서")%></span>
						<a href="#n" class="more" title="<%=BizboxAMessage.getMessage("TX000018197","더보기")%>"></a>
					</h2>
					<div name="portletTemplete_doc_list" class="ptl_content nocon">
						<div class="ptl_board freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_web_sign" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ea">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000000479","전자결재")%></span>
						<a name="portletTemplete_web_sign_more" href="#" class="more" title="더보기"></a>
					</h2>
					<div name="portletTemplete_web_sign_list" class="ptl_content nocon">
						<div class="ptl_approval freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_sign_form" style="display:none;">
					<h2 class="ea">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000010095","결재양식")%></span>
						<a class="title_more" href="#" title="">
							<img class="settingBtn" src="/gw/Images/portal/setting.png" alt="" />
						</a>
					</h2>
					<div name="portletTemplete_sign_form_list" class="ptl_content nocon">
						<div class="ptl_list freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_sign_status" style="display:none;">
					<h2 class="ea">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000022827","결재현황")%></span>
						<c:choose><c:when test="${loginVO.eaType == 'ea'}">
						<a href="javascript:onclickTopCustomMenu(100000000,'전자결재', '', 'ea', '', 'N');" class="more" title="더보기"></a>
						</c:when><c:otherwise>
						<a href="javascript:mainmenu.mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>', '/ea/eadoc/EaDocList.do', 'eap', '', 'main', '2000000000', '2002010000', '<%=BizboxAMessage.getMessage("TX000005556","상신함")%>', 'main');" class="more" title="더보기"></a>
						</c:otherwise></c:choose>						
					</h2>
					<div name="portletTemplete_sign_status_list" class="ptl_content nocon">
						<div class="mdst"></div>
					</div>
				</textarea>	
				
				<textarea id="portletTemplete_mail_status" style="display:none;">
					<h2 class="ma">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000022828","메일현황")%></span>
						<a href="javascript:fnMailMain();" class="more" title="더보기"></a>
					</h2>
					<div name="portletTemplete_mail_status_list" class="ptl_content nocon">
						<div class="mdst"></div>
					</div>
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
				
				<textarea id="portletTemplete_board" style="display:none;">
					<h2 class="bd">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000011134","게시판")%></span>
						<a name="portletTemplete_board_more" href="#n" class="more" title="더보기"></a>
					</h2>
					<div name="portletTemplete_board_list" class="ptl_content nocon">
						<div class="ptl_board freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_survey" style="display:none;">
					<iframe name="설문조사" src="/edms/board/getMainSurveyList.do" onerror="mainEmptyPage.do?page=poll" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
				</textarea>								
				
				<textarea id="portletTemplete_note" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="nt">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000010157","노트")%></span>
						<a href="javascript:parent.mainMove('NOTE','/Views/Common/note/noteList','')" class="more" title="더보기"></a>
					</h2>
					<div name="portletTemplete_note_list" class="ptl_content nocon">
						<div class="ptl_board freebScrollY"></div>
					</div>
				</textarea>				
				
				<textarea id="portletTemplete_weather" style="display:none;">
					<div class="ptl_content nocon">
						<div class="ptl_weather">
							<img class="settingBtn" style="position:absolute; top:10px;right:10px;" src="/gw/Images/portal/setting.png" alt="">						
							<!-- 날씨이미지 -->
							<div class="ptl_weather_ico"><img name="portletTemplete_weather_img" src="/gw/js/portlet/Images/freeb/weather_source/loading.gif"></div>
							<!-- 날씨정보 -->
							<div class="ptl_weather_info">
								<div class="weather_location">
									<span weatherCity="" name="portletTemplete_weather_location" class="loc_txt01"></span>
								</div>
								<div class="weather_celsius">
									<span name="portletTemplete_weather_temp"></span>
								</div>
								<p name="portletTemplete_weather_desc" class="weather_desc"></p>
							</div>
						</div>
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
			<input id="btnSave" type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" pudd-style="display:block;width:70px;height:24px;margin-bottom:5px;"/>
			<input type="button" onclick="self.close();" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>"" pudd-style="display:block;width:70px;height:24px;"/>
		</div>
	</div><!--// pop_wrap -->
</body>
</html>








