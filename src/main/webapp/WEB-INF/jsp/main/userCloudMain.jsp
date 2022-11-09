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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    
    <!--css-->
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/common.css?ver=20201021">
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/animate.css">
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/pudd.css?ver=20201021">
	<link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/portlet.css?ver=20201021">

    <!--js-->
	<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.84.min.js"></script>    
	<script type="text/javascript" src="/gw/js/portlet/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common.js?ver=20201021"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common_freeb.js?ver=20201021"></script>
    
    <!-- mCustomScrollbar -->
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.css">
    <script type="text/javascript" src="/gw/js/portlet/Scripts/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>
	
    <script>
   
    	var userMenuList = JSON.parse('${userMenuList}');
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
    	var portletUserSetListStr = '${portletUserSetList}';
    	var portletUserSetListDiv = document.createElement( "div" );
    	    	    	    	
    	if(portletUserSetListStr != ""){
    		$.each( jQuery.parseJSON(portletUserSetListStr), function( key, value ) {
    			fnInsertPortletUserSet(value);
    		});    		
    	}
    	
    	// 포틀릿 랜더시 스크립트 방지 목적
    	function escapeHtml(html) {  
    		var entityMap = { 
    			//'&': '&amp;', 
    			'<': '&lt;', 
    			'>': '&gt;', 
    			'"': '&quot;', 
    			//"'": '&#39;', 
    			'/': '&#x2F;', 
    			'`': '&#x60;', 
    			'=': '&#x3D;',
    			'&#39;': "'",
    			'&quot;':'"'
    		};

    		return html.replace(/[<>"`=\/]|(&quot;)|(&#39;)/g, function (s) { return entityMap[s]; });
    		//return html.replace(/[<>"`=\/]/g, function (s) { return entityMap[s]; });
    	}
    	
		function fnInsertPortletUserSet(info){
			
			$(portletUserSetListDiv).find("[portletKey="+info.portletKey+"]").remove();
			
			var portletUserinfo = document.createElement( "div" );
			
    		$.each( info, function( keyName, keyValue ) {
    			$(portletUserinfo).attr( keyName, keyValue );
    		});
			
    		$(portletUserSetListDiv).append( portletUserinfo );			
		}
		
		function fnSelectPortletUserSet(portletKey, attrName){
			return $(portletUserSetListDiv).find("[portletKey="+portletKey+"]").attr(attrName);
		}
    
		// setViewPortlet 함수
		var setViewPortlet = function( div, boxType, portletInfo, portletKey ) {
			
			if( "portletTemplete_iframe_outer" == boxType ) {

				$( div ).addClass( "iframeBox" );
				render_portletTemplete_iframe_outer(portletInfo, div, portletKey);

			} else if( "portletTemplete_iframe_banner" == boxType ) {

				$( div ).addClass( "iframeBox" );
				render_portletTemplete_iframe_banner(portletInfo, div, portletKey);

			} else if( "portletTemplete_iframe_quick" == boxType ) {

				$( div ).addClass( "iframeBox" );
				render_portletTemplete_iframe_quick(portletInfo, div, portletKey);

			} else if( "portletTemplete_weather" == boxType ) {

				$( div ).addClass( "portletBox" );
				render_portletTemplete_weather(portletInfo, div, portletKey, false);

			} else if( "portletTemplete_mybox" == boxType ) {

				$( div ).addClass( "portletBox" );
				render_portletTemplete_mybox(portletInfo, div, portletKey);

			} else if( "portletTemplete_board" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_board(portletInfo, div, portletKey);

			} else if ("portletTemplete_doc" == boxType) {
				
				$(div).addClass("titleBox");
				render_portletTemplete_doc(portletInfo, div, portletKey);
				
			} else if( "portletTemplete_sign_form" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_sign_form(portletInfo, div, portletKey);
				

			} else if( "portletTemplete_sign_status" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_sign_status(portletInfo, div, portletKey);

			} else if( "portletTemplete_web_sign" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_web_sign(portletInfo, div, portletKey);

			} else if( "portletTemplete_note" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_note(portletInfo, div, portletKey);

			} else if( "portletTemplete_mail_status" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_mail_status(portletInfo, div, portletKey);

			} else if( "portletTemplete_inbox" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_inbox(portletInfo, div, portletKey);

			} else if( "portletTemplete_survey" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_survey(portletInfo, div, portletKey);

			} else if( "portletTemplete_calendar_horizontal" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_calendar(portletInfo, div, boxType, portletKey);

			} else if( "portletTemplete_calendar_vertical" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_calendar(portletInfo, div, boxType, portletKey);

			} else if( "portletTemplete_notice" == boxType ) {

				$( div ).addClass( "portletBox" );
				render_portletTemplete_notice(portletInfo, div, portletKey);

			} else if( "portletTemplete_task_status" == boxType ) {

				$( div ).addClass( "titleBox" );

			} else {

				return;
			}
		};
		
		
		function checkUserPortletAuth(menuNo){
			var authCheck = false;
			for(var i=0;i<userMenuList.length;i++){
				if(userMenuList[i].menuNo == menuNo){
					authCheck = true;
					break;
				}
			}		
			return authCheck;
		}
		
		function render_portletTemplete_iframe_outer(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_iframe_outer" ).val());

			if(portletInfo != null && portletInfo != "" && portletInfo.useYn != "N" && portletInfo.linkList != null && portletInfo.linkList.length > 0 && portletInfo.linkList[0].link_url != ""){
				
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
				
				if(portletInfo.linkList[0].link_url != ""){
					
					$( targetDiv ).find("[name=loadingImg]").css("cursor","pointer");
					$( targetDiv ).find("[name=loadingImg]").click(function(){
						fnMoveSSOLink(portletInfo.linkList[0]);
					});
				}

				if(portletInfo.linkList.length > 1){
					$( targetDiv ).find("[name=loadingIframe]").attr("src", "/gw/html/i_banner.html?portletKey="+portletBannerKey);	
				}
				
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
			
			var portletBannerKey = "portletBanner_" + portletKey;
			localStorage.setItem(portletBannerKey ,JSON.stringify(portletInfo));			

			if(portletInfo != null && portletInfo != "" && portletInfo.useYn != "N" && portletInfo.linkList != null && portletInfo.linkList.length > 0){
				$( targetDiv ).find("[name=portletTemplete_iframe_quick_list]").html("<iframe src='/gw/html/i_quick.html?portletKey="+portletBannerKey+"'></iframe>");
			}else{
				$( targetDiv ).find("[name=portletTemplete_iframe_quick_list]").html("").addClass("nocon");
			}
		}	
		
		function fnMoveSSOLink(obj){
			
			if(obj.ssoUseYn == "Y"){
				var tblParam = {};
				tblParam.paramTp = "cloud";
				tblParam.ssoType = obj.ssoType;
				tblParam.ssoEmpCtlName = obj.ssoUserId;
				tblParam.ssoCoseqCtlName = obj.ssoCompSeq;
				tblParam.ssoEncryptType = obj.ssoEncryptType;
				tblParam.ssoEncryptKey = obj.ssoEncryptKey;
				tblParam.ssoTimeLink = obj.ssoTimeLink;
				tblParam.ssoEncryptScope = obj.ssoEncryptScope;
				tblParam.ssoErpempnoCtlName = obj.sspErpSeq;
				tblParam.ssoLogincdCtlName = obj.ssoLoginCd;
				tblParam.ssoErpcocdCtlName = obj.ssoErpCompSeq;
				tblParam.ssoEtcCtlName = obj.ssoEtcName;
				tblParam.ssoEtcCtlValue = obj.ssoEtcValue;
				tblParam.url = obj.link_url;
				
				$.ajax({
					type:"post",
				    url: _g_contextPath_ + "/cmm/system/getMenuSSOLinkInfo.do",
				    async: false,
				    dataType: 'json',
				    data: tblParam,
				    success: function(data) {
				    	openWindow2(data.ssoUrl,  "_blank",  $(window).width(), $(window).height(), 1,1);
				    },
				    error: function(xhr) { 
				      console.log('FAIL : ', xhr);
				    }
			   });		
			}else{
				openWindow2(obj.link_url,  "_blank",  $(window).width(), $(window).height(), 1,1);
			}
		}
		
		function render_portletTemplete_calendar(portletInfo, targetDiv, boxType, portletKey){
			$( targetDiv ).html($( "#" + boxType ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			var params = {};
			var defaultCalenderType = portletInfo.val3 == null ? "private" : portletInfo.val3;
			
			var selector = defaultCalenderType === "all" || defaultCalenderType === undefined ? "selected='selected'" : "";
			$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").append("<option value='all'" + selector + "><%=BizboxAMessage.getMessage("TX000010380","전체일정",(String) request.getAttribute("langCode"))%></option>");
			
			// 개인일정
			if(portletInfo.val0 == "Y") {
				
				var selector = defaultCalenderType === "private" || defaultCalenderType === undefined ? "selected='selected'" : "";
				$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").append("<option value='indivi'" + selector + "><%=BizboxAMessage.getMessage("TX000004103","개인일정",(String) request.getAttribute("langCode"))%></option>");
				params.indivi = "Y";
				params.share = "N";
				params.special = "N";
				
			} else {
				params.indivi = "N";
			}
			
			// 공유일정
			if(portletInfo.val1 == "Y") {
				
				var selector = defaultCalenderType === "share" ? "selected='selected'" : "";
				params.share = "Y";
				$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").append("<option value='share'" + selector + "><%=BizboxAMessage.getMessage("TX000010163","공유일정",(String) request.getAttribute("langCode"))%></option>");
			} else {
				params.share = "N";
			}
			
			// 기념일
			if(portletInfo.val2 == "Y") {
				
				/* var today = new Date();
				var year = today.getFullYear();
				var month = today.getMonth() + 1 < 10 ? "0" + (today.getMonth() + 1) : today.getMonth() + 1;
				var day = today.getDate() < 10 ? "0" + today.getDate() : today.getDate();
				
				params.startDate = year + '' + month + '' + day; */
				
				if(portletInfo.val0 === "N" && portletInfo.val1 === "N") {

					$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").children().remove()
					
				}
				
				var selector = defaultCalenderType === "special" ? "selected='selected'" : "";
				params.special = "Y";
				$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").append("<option value='special'" + selector + "><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></option>");
			} else {
				params.special = "N";
			}
			
			if(defaultCalenderType === "private") {
				params.selectBox = "indivi";
			} else if(defaultCalenderType === "share") {
				params.selectBox = "share";
			} else if(defaultCalenderType === "special") {
				params.selectBox = "special";
			} else {
				params.selectBox = "all";
			}
			
			$( targetDiv ).find("[name=loadingSchedule]").show();

			$.ajax({
				type: "post",
	            url: "schedulePortlet.do",
	            datatype: "json",
	            data: params,
	            async: true,
	            success: function (result) {         	
	            	$( targetDiv ).find("[name=loadingSchedule]").hide();
	            		            	
	            	var HidEventDays = result.HidEventDays;
	            	var HidYearMonth = result.HidYearMonth;
	            	var HidHoliDays = result.holidays;
	            	var holidayList = result.holidayList;
	            	
	            	$( targetDiv ).find("[name=HidEventDays]").val(HidEventDays);
	            	$( targetDiv ).find("[name=HidYearMonth]").val(HidYearMonth);
	            	$( targetDiv ).find("[name=HidHolidays]").val(HidHoliDays);
	            	$( targetDiv ).find("[name=HidHolidayList]").val(JSON.stringify(holidayList));
	            	$( targetDiv ).find("[name=portletTemplete_calendar_calanderDate]").html(HidYearMonth);
	            	
	                //일정표시여부 체크
	                var today = new Date();
	                if (HidEventDays != null) {
	                    var yyyyMM = HidYearMonth.split('.');
	                    CalanderInit(yyyyMM[0], yyyyMM[1], HidEventDays, HidHoliDays, today.getFullYear(), today.getMonth() + 1, today.getDate(), targetDiv);
	                }	
	                
	                var selectDate = today.getFullYear() + "-" + (today.getMonth() + 1 < 10 ? "0" + (today.getMonth() + 1) : (today.getMonth() + 1)) 
	                	+ "-" + (today.getDate() + 1 < 10 ? "0" + today.getDate() : today.getDate());
	                	
	                $( targetDiv ).find("[name=portletTemplete_calendar_selectedDate]").html(selectDate);
	                	                
	                calanderDateSelectBind(result, targetDiv);
	            },
	            error: function (e) {
	            	$( targetDiv ).find("[name=loadingSchedule]").hide();
	            }
			
			});
		}
		
		// 캘린더 그려주기(최초)
	    function CalanderInit(year, month, days, holiDay, yyyy, MM, dd, targetDiv) {
			
	        var html = "";

	        var date0 = new Date(year + "-" + month + "-01");
	        var date1 = date0;
	        var date2 = new Date();

	        for (var i = 0; i < 7; i++) {
	            var temp0 = new Date(date0.setDate(date0.getDate() - 1));

	            if (temp0.getDay() == 0) {
	                date1 = temp0;
	            }
	        }

	        date0 = new Date(year + "-" + month + "-01");
	        date0 = new Date(date0.setMonth(date0.getMonth() + 1));
	        date0 = new Date(date0.setDate(date0.getDate() -1));

	        for (var i = 0; i < 7; i++) {
	            var temp1 = new Date(date0.setDate(date0.getDate() + 1));

	            if (temp1.getDay() == 6) {
	                date2 = new Date(temp1.setDate(temp1.getDate() + 1));
	            }
	        }

	        var cnt = 0;

	        html += "<table cellpadding='0' cellspacing='0'>";
	        html += "<tbody>";
	        html += "<tr>";
	        html += "<th class='sun'><%=BizboxAMessage.getMessage("TX000000437","일",(String) request.getAttribute("langCode"))%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005657","월",(String) request.getAttribute("langCode"))%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005658","화",(String) request.getAttribute("langCode"))%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005659","수",(String) request.getAttribute("langCode"))%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005660","목",(String) request.getAttribute("langCode"))%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005661","금",(String) request.getAttribute("langCode"))%></th>";
	        html += "<th class='sat'><%=BizboxAMessage.getMessage("TX000005662","토",(String) request.getAttribute("langCode"))%></th>";
	        html += "</tr>";

	        while (date1 < date2) {

	            var classStr = "";

	          	//메뉴권한이 없을 경우 처리 - 일정
				if(checkUserPortletAuth(301000000)){
			 		if (date1.getFullYear() == yyyy && (date1.getMonth() + 1) == MM && date1.getDate() == dd) {
		                classStr = "today selon";
	
		                if (days.indexOf(getyyyyMMdd(date1)) > -1) {
		                    classStr += " schedule";
		                }
						
		            } else if (days.indexOf(getyyyyMMdd(date1)) > -1) {
		                classStr = " schedule";
		            } else if(holiDay.indexOf(getyyyyMMdd(date1)) > -1) {
		            	classStr += " special_day";
		            }
				}
	            
	           

	            if (cnt == 0) {
	                html += "<tr><td class='sun'><a href='#none' onclick='calanderDateSelect(this.name, this);' name=" + date1.getFullYear() + "|" + (date1.getMonth() + 1) + "|" + date1.getDate() + " class='" + classStr + "' title=''>" + date1.getDate() + "</a></td>";
	            } else if (cnt == 6) {
	                html += "<td class='sat'><a href='#none' onclick='calanderDateSelect(this.name, this);' name=" + date1.getFullYear() + "|" + (date1.getMonth() + 1) + "|" + date1.getDate() + " class='" + classStr + "' title=''>" + date1.getDate() + "</a></td></tr>";
	            } else {
	                html += "<td><a href='#none' onclick='calanderDateSelect(this.name, this);' name=" + date1.getFullYear() + "|" + (date1.getMonth() + 1) + "|" + date1.getDate() + " class='" + classStr + "' title=''>" + date1.getDate() + "</a></td>";
	            }

	            date1 = new Date(date1.setDate(date1.getDate() + 1));
	            cnt++;

	            if(cnt == 7){
	                cnt = 0;
	            }
	        }

	        html += "</table>";
	        
	        $( targetDiv ).find("[name=portletTemplete_calendar_calenderTable]").html(html);	        

	    }
		
	    // 일정 팝업
	    function fnSchedulePop(scheduleSeq) {
	    	var url = "/schedule/Views/Common/mCalendar/detail?seq="+scheduleSeq;
	  		openWindow2(url,  "pop", 1200, 711,"yes", 1);
	    }		
		
	    // 특정 날 선택
	    function calanderDateSelect(date, thisDiv) {
	    	var targetDiv = $(thisDiv).closest("div[portletKey]");
	 	    var selectDate = date.split("|");
	 	    var selectYear = selectDate[0];
	 	    var selectMonth = selectDate[1];
	 	    var selectDay = selectDate[2];
	 	   
	 		selectMonth < 10 ? "0" + selectMonth : selectMonth;
	 	   	selectDay < 10 ? "0" + selectDay : selectDay;
	 	   
	 	   	var day = selectYear + "-" + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + "-" + (selectDay < 10 ? "0" + selectDay : selectDay); 
	 	   
	 	   
	 	  	$(targetDiv).find('[name=portletTemplete_calendar_calenderTable] table td a').removeClass('selon');
	 	  	$(targetDiv).find('a[name="' + date + '"]').addClass('selon');
	 	   
	        if (date == "") {
	        	date = $(targetDiv).find('[name=HidSelectedDate]').val();
	        }

	        var selectvalue = date.split('|');
	        var url = "schedulePortlet.do"; 	   
	 		var tblParam = {};
	     	    
	        tblParam.scheduleCheckDate = selectvalue[0].toString() + (selectvalue[1] < 10 ? "0" + selectvalue[1].toString() : selectvalue[1].toString()) + (selectvalue[2] < 10 ? "0" + selectvalue[2].toString() : selectvalue[2].toString());
	       	tblParam.startDate= selectvalue[0].toString() + ((parseInt(selectvalue[1])-1) < 10 ? "0" + (parseInt(selectvalue[1])-1).toString() : (parseInt(selectvalue[1])-1).toString()) + (selectvalue[2] < 10 ? "0" + selectvalue[2].toString() : selectvalue[2].toString()); 
	       	
	       	if(selectvalue[1]=="12") {
	       		selectvalue[0] = parseInt(selectvalue[0])+1;
	       		selectvalue[1]="0";
	       	}

	    	if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "total") {
	       		tblParam.all = "Y";
	       	}
	    		
	    	if($(targetDiv).find("[name=portletTemplete_calendar_scheSm] option[value=indivi]").length > 0){
	    		tblParam.indivi = "Y";
	    	}else{
	    		tblParam.indivi = "N";
	    	}
	    		
    		if($(targetDiv).find("[name=portletTemplete_calendar_scheSm] option[value=share]").length > 0){
    			tblParam.share = "Y";
    		}else{
    			tblParam.share = "N";
    		}
    		
    		if($(targetDiv).find("[name=portletTemplete_calendar_scheSm] option[value=special]").length > 0){
    			tblParam.special = "Y";
    		}else{
    			tblParam.special = "N";
    		}	    		

    		tblParam.selectBox = $(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val();
	       		
	       	tblParam.endDate=selectvalue[0].toString() + ((parseInt(selectvalue[1])+1) < 10 ? "0" + (parseInt(selectvalue[1])+1).toString() : (parseInt(selectvalue[1])+1).toString()) + (selectvalue[2] < 10 ? "0" + selectvalue[2].toString() : selectvalue[2].toString());
	         
	       	$( targetDiv ).find("[name=loadingSchedule]").show();
	         $.ajax({
	             type: "POST"
	             , url: url
	             , data: tblParam
	 	         , async: true
	             , success: function (result) {
	             
	            	 $( targetDiv ).find("[name=loadingSchedule]").hide();
	            	 $( targetDiv ).find("[name=portletTemplete_calendar_selectedDate]").html(day);
	            	 
	 				calanderDateSelectBind(result, targetDiv);
	 				$(targetDiv).find('[name=HidSelectedDate]').val(selectvalue[0] + "|" + selectvalue[1] + "|" + selectvalue[2]);
	 				 
	             }
	             , error: function (reult) {
	            	 $( targetDiv ).find("[name=loadingSchedule]").hide();
	             }
	         });
	     }
	    

	    function calanderPrevNext(page, thisDiv) {
	    	
	    	var targetDiv = $(thisDiv).closest("div[portletKey]");
	    	
	 	   var today = new Date();
	 	   
	        var thisDate = $( targetDiv ).find("[name=portletTemplete_calendar_calanderDate]").html().split('.');
	        var nextDate = new Date(thisDate[0] + "-" + thisDate[1]);

	        nextDate = new Date(nextDate.setMonth(nextDate.getMonth() + page));
	        var nextMonth = nextDate.getMonth() + 1;

	        if (nextMonth < 10) {
	            nextMonth = "0" + nextMonth;
	        }

	        if(page != 0) {
	     	   CalanderRefresh(nextDate.getFullYear(), nextMonth, today.getFullYear(), today.getMonth() + 1, today.getDate(), page, targetDiv);   
	        } else {
	     	   CalanderRefresh(nextDate.getFullYear(), nextMonth, 0, today.getMonth() + 1, today.getDate(), page, targetDiv);
	        }
	        

	        $( targetDiv ).find("[name=portletTemplete_calendar_calanderDate]").html(nextDate.getFullYear() + "." + nextMonth);
	    }
	    
	    // 캘린더 다시 그려주기
	    function CalanderRefresh(year, month, yyyy, MM, dd, page, targetDiv) {
	 	
	        var html = "";

	        var date0 = new Date(year + "-" + month + "-01");
	        var date1 = date0;
	        var date2 = new Date();
	        var day = "";
	        
	        for (var i = 0; i < 7; i++) {
	            var temp0 = new Date(date0.setDate(date0.getDate() - 1));

	            if (temp0.getDay() == 0) {
	                date1 = temp0;
	            }
	        }

	        date0 = new Date(year + "-" + month + "-01");
	        date0 = new Date(date0.setMonth(date0.getMonth() + 1));
	        date0 = new Date(date0.setDate(date0.getDate() - 1));

	        for (var i = 0; i < 7; i++) {
	            var temp1 = new Date(date0.setDate(date0.getDate() + 1));

	            if (temp1.getDay() == 6) {
	                date2 = new Date(temp1.setDate(temp1.getDate() + 1));
	            }
	        }
	        
	        var url = "schedulePortlet.do";

	        var tblParam = {};
	        tblParam.startDate = getyyyyMMdd(date1);
	        tblParam.endDate = getyyyyMMdd(date2);

	        if (yyyy != 0) {
	            tblParam.toDay = yyyy.toString() + (MM < 10 ? "0" + MM.toString() : MM.toString()) + (dd < 10 ? "0" + dd.toString() : dd.toString());
	        } else {
	     	   var selectDay = $( targetDiv ).find(".selon").attr("name");	     	   
	 	       var selectDate = selectDay.split("|");
	 	   	   var selectYear = selectDate[0];
	 	   	   var selectMonth = selectDate[1];
	 	   	   var selectDay = selectDate[2];
	 	   	    
	 	   	   selectMonth < 10 ? "0" + selectMonth : selectMonth;
	 	   	   selectDay < 10 ? "0" + selectDay : selectDay;
	 	   		   
	 	   	   day = selectYear + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + (selectDay < 10 ? "0" + selectDay : selectDay); 	
	     	   tblParam.scheduleCheckDate = day;
	            tblParam.toDay = day;
	        }
	        
    		if($(targetDiv).find("[name=portletTemplete_calendar_scheSm] option[value=indivi]").length > 0){
    			tblParam.indivi = "Y";
    		}else{
    			tblParam.indivi = "N";
    		}
    		
    		if($(targetDiv).find("[name=portletTemplete_calendar_scheSm] option[value=share]").length > 0){
    			tblParam.share = "Y";
    		}else{
    			tblParam.share = "N";
    		}
    		
    		if($(targetDiv).find("[name=portletTemplete_calendar_scheSm] option[value=special]").length > 0){
    			tblParam.special = "Y";
    		}else{
    			tblParam.special = "N";
    		}
    		
    		tblParam.selectBox = $(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val();
			
    		$( targetDiv ).find("[name=loadingSchedule]").show();
    		
	        $.ajax({
	            type: "POST"
	            , url: url
	            , data: tblParam
	 	        , async: true
	            , success: function (result) {
	            	
	            		$( targetDiv ).find("[name=loadingSchedule]").hide();
	         	   
	            	   if(page != 0) {
	            			CalanderInit(year, month, result.HidEventDays, result.holidays, yyyy, MM, dd, targetDiv);  
	            			
	            			// 다음달 혹은 이전달로 변경시 1일을 고정으로 선택되도록 한다.
            				var date = year + "|" + Number(month) + "|" + "1";
            				calanderDateSelect(date, targetDiv);
            				
	            	   } else {
	            			var year1 = day.substring(0, 4);
	            			var month1 = day.substring(4,6);
	            			var date1 = day.substring(6,8);
	            			
	            		    CalanderInit(year1, month1, result.HidEventDays, result.holidays, year1, month1, date1, targetDiv);
	            	   }
	                
	                if(page == "0") {
	             	   calanderDateSelectBind(result, targetDiv);
	                }
	            }
	            , error: function (reult) {
	            	$( targetDiv ).find("[name=loadingSchedule]").hide();
	            }

	        });
	    }
	    
	    // 캘린더 셀렉박스 변경
	    function fnChangeScheduleSelect(thisDiv) {
	    	var targetDiv = $(thisDiv).closest("div[portletKey]");
	    	calanderPrevNext(0, targetDiv);
	    }
	    
	    // 일정 카운터 및 컨텐츠 렌더 함수
	    function calanderDateSelectBind(result, targetDiv) {
	    	
	    	//메뉴권한이 없을 경우 처리 - 일정
			if(!checkUserPortletAuth(301000000)){
				return;
			}
	    	
	    	var data = result.scheduleContents;
	    	
	    	$( targetDiv ).find("[name=portletTemplete_calendar_list]").html("");
	    	
	        var tag = "";
	        var selectDay = $(".selon").attr("name");	        
			var selectDate = selectDay.split("|");
		    var selectYear = selectDate[0];
		    var selectMonth = selectDate[1];
		    var selectDay = selectDate[2];
		    
		   	var langPackText = {
   				TX000002835: "<%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%>",
   				TX000012110: "<%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%>",
   				TX000007381: "<%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%>",
   				TX000003963: "<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%>",
   				TX000001672: "<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%>",
		   	}
		    
		    selectMonth < 10 ? "0" + selectMonth : selectMonth;
			selectDay < 10 ? "0" + selectDay : selectDay;
			   
			var day = selectYear + "-" + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + "-" + (selectDay < 10 ? "0" + selectDay : selectDay);
			
			var holidayList = [];
			
			if(result.holidayList != undefined) {
				holidayList = result.holidayList;
			}
			
	   		for(var i=0; i<holidayList.length; i++) {
				if(holidayList[i].hDay.indexOf(day.replace(/\-/g,'')) > -1) {
					tag += '<li>';
					tag += '<span class="txt text_red">' + holidayList[i].title + '</span>';
					tag += '</li>';
				}
			}
	        
            $( targetDiv ).find("[name=portletTemplete_calendar_selectedDate]").html(day);
            
          	//selectBox 데이터를 조회하여 카운터 수를 보정한다. 
            var scheduleContentsCount = 0;
            var selectBox = $(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val();
            
            if(selectBox === "all") {
            	scheduleContentsCount = data.length;
            } else {
            	for(var item in data){
                	if(selectBox === "share" && data[item].gbnCode === "M"){
                		scheduleContentsCount += 1;
                    } else if ((selectBox === "indivi" && data[item].gbnCode === "E") || (selectBox === "indivi" && data[item].gbnCode === "M")){
                    	scheduleContentsCount += 1;
                    } else if (selectBox === "special" && (data[item].gbnCode === "b" || data[item].gbnCode === "w")) {
                    	scheduleContentsCount += 1;
                    }
                }	
            }
            
            $( targetDiv ).find("[name=portletTemplete_calendar_selectedCnt]").html(scheduleContentsCount);
	   		
	        if (data.length > 0) {
	        	
	        	for (var i = 0; i < data.length; i++) {
					var startDateFormat = data[i].startDate;
					var endDateFormat = data[i].endDate;

					
					var sYear = startDateFormat.substring(0, 4);
					var sMonth = startDateFormat.substring(4, 6);
					var sDay = startDateFormat.substring(6, 8);
					var sHour = startDateFormat.substring(8, 10);
					var sMin = startDateFormat.substring(10, 12);
					
					var eYear = endDateFormat.substring(0, 4);
					var eMonth = endDateFormat.substring(4, 6);
					var eDay = endDateFormat.substring(6, 8);
					var eHour = endDateFormat.substring(8, 10);
					var eMin = endDateFormat.substring(10, 12);
					
		            var startDate = sMonth + "-" + sDay + " " + sHour + ":" + sMin;
		            var endDate =  eMonth + "-" + eDay + " " + eHour + ":" + eMin;
		            var specialDate = sMonth + "-" + sDay;
		            
		            if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "all") {
		            	 tag += '<li>';
		  				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		  					tag += '<span class="time">' + specialDate + '</span>';
		  				} else {
		  					if(data[i].alldayYn && data[i].alldayYn === 'Y') {
		  						tag += '<span class="time">ALLDay</span>';
		  					} else {
		  						tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		  					}		  					
		  				}
		  				
	    				if(data[i].gbnCode == "E") {
	    					tag += '<span class="sign green">' + langPackText["TX000002835"] + '</span>';	
	    				} else if(data[i].gbnCode == "M") {
	    					tag += '<span class="sign blue">' + langPackText["TX000012110"] + '</span>';
	    				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
	    					tag += '<span class="sign gray">' + langPackText["TX000007381"] + '</span>';
	    				}
		    				
		    			if(data[i].gbnCode == "w") {
		    				tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
		  				} else if(data[i].gbnCode == "b") {
		  					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
		  				} else {
		  					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
		  				}
		 				tag += '</li>';
		            } else if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "indivi") {
	            		tag += '<li>';
	            		if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		  					tag += '<span class="time">' + specialDate + '</span>';
		  				} else {
		  					if(data[i].alldayYn && data[i].alldayYn === 'Y') {
		  						tag += '<span class="time">ALLDay</span>';
		  					} else {
		  						tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		  					}		  					
		  				}
      				
        				if(data[i].gbnCode == "E") {
        					tag += '<span class="sign green">' + langPackText["TX000002835"] + '</span>';	
        				} else if(data[i].gbnCode == "M") {
        					tag += '<span class="sign blue">' + langPackText["TX000012110"] + '</span>';
        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
        					tag += '<span class="sign gray">' + langPackText["TX000007381"] + '</span>';
        				}
        				
        				if(data[i].gbnCode == "w") {
        					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
	      				} else if(data[i].gbnCode == "b") {
	      					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
	      				} else {
	      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	      				}
	     				tag += '</li>';
		            } else if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "share") {
		            	if(data[i].gbnCode == "M") {
		            		
		            		tag += '<li>';
		            		if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
			  					tag += '<span class="time">' + specialDate + '</span>';
			  				} else {
			  					if(data[i].alldayYn && data[i].alldayYn === 'Y') {
			  						tag += '<span class="time">ALLDay</span>';
			  					} else {
			  						tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
			  					}		  					
			  				}
		      				
	        				if(data[i].gbnCode == "E") {
	        					tag += '<span class="sign green">' + langPackText["TX000002835"] + '</span>';	
	        				} else if(data[i].gbnCode == "M") {
	        					tag += '<span class="sign blue">' + langPackText["TX000012110"] + '</span>';
	        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
	        					tag += '<span class="sign gray">' + langPackText["TX000007381"] + '</span>';
	        				}
		        				
	        				if(data[i].gbnCode == "w") {
	        					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
		      				} else {
		      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
		      				}
		     				tag += '</li>';
		            	}
		            } else if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "special") {
		            	if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		            		tag += '<li>';
		      				
		            		if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
			  					tag += '<span class="time">' + specialDate + '</span>';
			  				} else {
			  					if(data[i].alldayYn && data[i].alldayYn === 'Y') {
			  						tag += '<span class="time">ALLDay</span>';
			  					} else {
			  						tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
			  					}		  					
			  				}
		      						        				
		        			if(data[i].gbnCode == "w") {
		        					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
		      				}

		     				tag += '</li>';
		            	}
		            }
	            }
	        } else {
	        	
	        	if(tag == '') {
	        		tag += '<li>';
	    			tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000000776","일정없음",(String) request.getAttribute("langCode"))%></span>';
	    			tag += '</li>';	
	        	}
	        	
	        }

	        $( targetDiv ).find("[name=portletTemplete_calendar_list]").html(tag);
	        
	        freebScroll();
	    }	    
	    
	    // 날짜 형식 
	   	function getyyyyMMdd(date) {

	        var MM = date.getMonth() + 1;
	        var dd = date.getDate();

	        if(MM < 10){
	            MM = "0" + MM;
	        }
	        
	        if(dd < 10){
	            dd = "0" + dd;
	        }
	        return date.getFullYear() + MM.toString() + dd.toString();
	    }			
		
		// 일정 그려주기
		// calanderDateSelectBind 함수로 대체
		/*
		function fnDrawScheduleContent(data, targetDiv) {
			
			var holidayList = JSON.parse($( targetDiv ).find("[name=HidHolidayList]").val());
			
			var tag = '';
			
			var langPackText = {
   				TX000002835: "<%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%>",
   				TX000012110: "<%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%>",
   				TX000007381: "<%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%>",
   				TX000003963: "<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%>",
   				TX000001672: "<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%>",
		   	}
			
			for(var i=0; i<holidayList.length; i++) {
				 var selectDay = $( targetDiv ).find(".selon").attr("name");
				 var selectDate = selectDay.split("|");
			     var selectYear = selectDate[0];
			     var selectMonth = selectDate[1];
			     var selectDay = selectDate[2];
			     
			     selectMonth < 10 ? "0" + selectMonth : selectMonth;
				 selectDay < 10 ? "0" + selectDay : selectDay;
				   
				 var day = selectYear + "-" + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + "-" + (selectDay < 10 ? "0" + selectDay : selectDay); 
			
				if(holidayList[i].hDay.indexOf(day.replace(/\-/g,'')) > -1) {
					tag += '<li>';
					tag += '<span class="txt text_red">' + holidayList[i].title + '</span>';
					tag += '</li>';
				}
			}

			if(data.length > 0) {
				for(var i=0; i<data.length; i++) {
					var startDateFormat = data[i].startDate;
					var endDateFormat = data[i].endDate;
					
					var sYear = startDateFormat.substring(0, 4);
					var sMonth = startDateFormat.substring(4, 6);
					var sDay = startDateFormat.substring(6, 8);
					var sHour = startDateFormat.substring(8, 10);
					var sMin = startDateFormat.substring(10, 12);
					
					var eYear = endDateFormat.substring(0, 4);
					var eMonth = endDateFormat.substring(4, 6);
					var eDay = endDateFormat.substring(6, 8);
					var eHour = endDateFormat.substring(8, 10);
					var eMin = endDateFormat.substring(10, 12);
					
		            var startDate = sMonth + "-" + sDay + " " + sHour + ":" + sMin;
		            var endDate =  eMonth + "-" + eDay + " " + eHour + ":" + eMin;
		            var specialDate = sMonth + "-" + sDay;
		            
		            if($( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").val() == "all") {
		            	 tag += '<li>';
		  				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		  					tag += '<span class="time">' + specialDate + '</span>';
		  				} else {
		  					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		  				}
		  				
		    				if(data[i].gbnCode == "E") {
		    					tag += '<span class="sign green">' + langPackText["TX000002835"] + '</span>';	
		    				} else if(data[i].gbnCode == "M") {
		    					tag += '<span class="sign blue">' + langPackText["TX000012110"] + '</span>';
		    				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		    					tag += '<span class="sign gray">' + langPackText["TX000007381"] + '</span>';
		    				}
		    				
		    				if(data[i].gbnCode == "w") {
		    					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
		  				} else if(data[i].gbnCode == "b") {
		  					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
		  				} else {
		  					tag += "<a title=\"" + data[i].schTitle + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		  				}
		 				tag += '</li>';
		            } else if($( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").val() == "indivi") {
	            		tag += '<li>';
	      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
	      					tag += '<span class="time">' + specialDate + '</span>';
	      				} else {
	      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
	      				}
      				
        				if(data[i].gbnCode == "E") {
        					tag += '<span class="sign green">' + langPackText["TX000002835"] + '</span>';	
        				} else if(data[i].gbnCode == "M") {
        					tag += '<span class="sign blue">' + langPackText["TX000012110"] + '</span>';
        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
        					tag += '<span class="sign gray">' + langPackText["TX000007381"] + '</span>';
        				}
        				
        				if(data[i].gbnCode == "w") {
	        					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
	      				} else if(data[i].gbnCode == "b") {
	      					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
	      				} else {
	      					tag += "<a title=\"" + data[i].schTitle + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
	      				}
	     				tag += '</li>';
		            } else if($( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").val() == "share") {
		            	if(data[i].gbnCode == "M") {
		            		 tag += '<li>';
		      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		      					tag += '<span class="time">' + specialDate + '</span>';
		      				} else {
		      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		      				}
		      				
		        				if(data[i].gbnCode == "E") {
		        					tag += '<span class="sign green">' + langPackText["TX000002835"] + '</span>';	
		        				} else if(data[i].gbnCode == "M") {
		        					tag += '<span class="sign blue">' + langPackText["TX000012110"] + '</span>';
		        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		        					tag += '<span class="sign gray">' + langPackText["TX000007381"] + '</span>';
		        				}
		        				
	        				if(data[i].gbnCode == "w") {
	        					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
		      				} else {
		      					tag += "<a title=\"" + data[i].schTitle + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		      				}
		     				tag += '</li>';
		            	}
		            } else if($( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").val() == "special") {
		            	if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
	            			tag += '<li>';
		      				
	            			if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		      					tag += '<span class="time">' + specialDate + '</span>';
		      				} else {
		      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		      				}
		      				
		      				if(data[i].gbnCode == "E") {
	        					tag += '<span class="sign green">' + langPackText["TX000002835"] + '</span>';	
	        				} else if(data[i].gbnCode == "M") {
	        					tag += '<span class="sign blue">' + langPackText["TX000012110"] + '</span>';
	        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
	        					tag += '<span class="sign gray">' + langPackText["TX000007381"] + '</span>';
	        				}
		        				
	        				if(data[i].gbnCode == "w") {
	        					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000003963"] + '</span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + langPackText["TX000001672"] + '</span>';
		      				} else {
		      					tag += "<a title=\"" + data[i].schTitle + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		      				}
		     				tag += '</li>';
		            	}
		            }
				}	
			} else {
				if(tag == '') {
	        		tag += '<li>'; 
	    			tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000000776","일정없음",(String) request.getAttribute("langCode"))%></span>';
	    			tag += '</li>';	
	        	}
			}
			
			$( targetDiv ).find("[name=portletTemplete_calendar_list]").html(tag);
			
			freebScroll();
		}
		*/
		
		function render_portletTemplete_survey(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_survey" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			$( targetDiv ).find("iframe").hide();

			//메뉴권한이 없을 경우 처리 - 설문조사
			if(!checkUserPortletAuth(502010000)){
				return;
			}
			
			$( targetDiv ).find("iframe").on("load", function() {
				$( targetDiv ).find("iframe").contents().find(".ptl h2").remove();
				$( targetDiv ).find("iframe").show();
			});

		}
		
		function render_portletTemplete_note(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_note" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//메뉴권한이 없을 경우 처리 - 노트
			if(!checkUserPortletAuth(303010000)){
				$( targetDiv ).find("[name=portletTemplete_note_list]").html("");
				return;
			}
			
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
		        		tag += "<a href=\"javascript:void(0);\" onclick=\"mainMove('NOTE', '" + url + "','')\"><%=BizboxAMessage.getMessage("TX000018942","노트등록",(String) request.getAttribute("langCode"))%></a>";
		        		tag += '<br />';
		        		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000015471","노트를 등록하세요.",(String) request.getAttribute("langCode"))%></span>';
		        		tag += '</td>';
		        		tag += '</tr>';
		        		tag += '</table>';
		        		tag += '</div>';	    		   
		    	   } else {
		    		   tag+='<div class="ptl_board freebScrollY"><ul>';
		    		   for(var i=0; i<noteData.length; i++) {
		  					tag += "<li><a title=\"" + noteData[i].noteTitle + "\" href=\"javascript:void(0);\" onclick=\"fnNotePop(" + noteData[i].noteSeq + ")\"><span class=\"txt\">" + noteData[i].noteTitle + "</span></a></li>";
		    		   }
		    		   tag+='</ul></div>';
		    	   }
		    	   $("[name=portletTemplete_note_list]").html(tag);
		    	   
		    	   freebScroll();
		       }, 
		       error:function(e) {
		    	   $("[name=portletTemplete_note_list]").html("");
		       }
			});			
		}
		
		function fnNotePop(noteSeq) {
			var url = "/schedule/Views/Common/note/noteList.do?noteSeq="+noteSeq;
	  		openWindow2(url,  "pop", 1000, 711, "no", 1) ;
		}
		
		var specificDate = new Date(); 
		specificDate.setDate(specificDate.getDate() -7);		
		
		function fnGetWeatherDetailInfo(getItemNm, weatherArray){
			var _data;		
			weatherArray.forEach(function(item){
				if(item.category == getItemNm){
					_data = item.fcstValue;
				}
			});
			
			return _data;
		}
		
		function checkWeatherStorage(locationChangeFlag, portletKey){
			var storageSaveName = "bizWeather_" + portletKey
			var data = JSON.parse(sessionStorage.getItem(storageSaveName));
			
			if(data.header == "00" && locationChangeFlag != true){
				//var baseTimes = ["0210","0510","0810","1110","1410","1710","2010","2310"];
				var dateObj = new Date();
				var nowDate = dateObj.getDate();
				var reqDate = new Date(data.reqDate).getDate();
								
				var nowTime = dateObj.getHours().toString() + dateObj.getMinutes().toString();
			    var baseTime = null;			    
			    var nowTime = '';
			    
			    if(dateObj.getMinutes() > 30) {
			    	var nowHour = dateObj.getHours() < 10 ? "0" + dateObj.getHours().toString() : dateObj.getHours().toString();
			    	nowTime = nowHour + "30";
			    } else {
			    	var nowHour = dateObj.getHours() - 1 < 10 ? "0" + (dateObj.getHours() - 1).toString() : (dateObj.getHours() - 1).toString();
			    	nowTime = nowHour + "30";
			    }
			    
			 	// 기상청 API 요청 날짜와 요청 시간이 같으면 기상청 API를 요청하지 않는다.
	            if(nowDate !== reqDate || data.baseTime !== nowTime) {
	            	return true;                
	            } else {
	                return false;
	            }
			    
			}
			return true;
		}
		
		function fnGetWeatherMultiLang(sky, pty) {
			//sky: 하늘상태(1: 맑음, 2: 구름조금, 3: 구름많음, 4: 흐림)
			//pty: 강수형태(0: 강수없음, 1: 비, 2: 비/눈, 3: 눈, 4: 소나기, 5: 빗방울(5), 6:빗방울/눈날림(6), 7: 눈날림(7))		
			if(pty != 0) {
				// 소나기가 추가되어 소나기일 경우 1번인 비로 맵핑
				// 빗방울, 빗방울/눈날림, 눈날림의 겨우 기존 이미지에 맵핑
				if(pty == 4 || pty == 5){
					pty = 1;
				} else if(pty == 6) {
					pty = 2;
				} else if(pty == 7) {
					pty = 3;
				} else if(pty > 7) {
					pty = 0;
				}
				
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
			
			var storageSaveName = "bizWeather_" + portletKey;
			
			//세션 스토리지 확인
			if(sessionStorage.getItem(storageSaveName) == null || checkWeatherStorage(locationChangeFlag, portletKey)){
								
			    if(weatherCity == null || weatherCity == ""){
			    	weatherCity = "60,127"; // 기본값 서울(woeid)
			    	location = "<%=BizboxAMessage.getMessage("TX000011881","서울",(String) request.getAttribute("langCode"))%>";
			    }
			    
			    _date = new Date();
			    var baseTimes = ["0210","0510","0810","1110","1410","1710","2010","2310"];	
			    var nowTime = _date.getHours().toString() + _date.getMinutes().toString();
			    var baseTime = null;
			    			    
			    if(_date.getMinutes() < 30) {
			    	if(_date.getHours() - 1 < 10){
			    		baseTime = "0" + (_date.getHours() - 1).toString() + "30";
			    	} else {
			    		baseTime = (_date.getHours() - 1).toString() + "30";
			    	}			    	
			    } else {
			    	if(_date.getHours() < 10) {
			    		baseTime = "0" + (_date.getHours() - 1).toString() + "30";
			    	} else {
			    		baseTime = _date.getHours().toString() + "30";	
			    	}
			    }
			    
			    requestParam = {
					baseDate: new Date().toISOString().slice(0,10).replace(/-/gi,""),
					baseTime: baseTime,
					location: weatherCity
				}
	
			    $.ajax({
		            url: "cmm/systemx/weather/getWeather.do",
		            type: "POST",
		            data: requestParam,
					dataType: "json",
		            success: function (_data) {		            	
		            	var data = _data.result.response;
		            			            	
						if(data.header.resultCode == "00"){
							
							var pty = [];
							var sky = [];
							var t1h = [];
							
							data.body.items.item.forEach(function(item){
								if(item.category == "PTY") {
									pty.push(item);
								} else if(item.category == "SKY") {
									sky.push(item);
								} else if(item.category == "T1H") {
									t1h.push(item);
								}
							});
														
							resultJson = {
								header: data.header.resultCode,
								headerMsg: data.header.resultMsg,
								baseDate: data.body.items.item[0].baseDate,
								baseTime: baseTime,
								fcstTime: data.body.items.item[0].fcstTime,
								pty: pty[0].fcstValue,
								sky: sky[0].fcstValue,
								t1h: t1h[0].fcstValue,
								reqDate: new Date(),
								multi: { "img": '36.png', "kr": '맑음', "en": 'sunny', "jp": '晴れ', "cn": '', "gb": '晴' }
							};
							resultJson.multi = fnGetWeatherMultiLang(resultJson.sky, resultJson.pty);
						}else{
							resultJson = {
								header: data.header.resultCode,
								headerMsg: data.header.resultMsg
							}
						}
						sessionStorage.setItem(storageSaveName, JSON.stringify(resultJson));
						fnSetWeatherInfo(targetDiv, portletKey, resultJson);
		            },
		            error: function (jqXHR, textStatus, ex) {
		            	_date = new Date();
						resultJson = {
							header: "30",	
							headerMsg: '<%=BizboxAMessage.getMessage("TX000003199","접속이 원활하지 않습니다.",(String) request.getAttribute("langCode"))%>'
						};					
						//localStorage.setItem("bizWeather", JSON.stringify(resultJson));
						fnSetWeatherInfo(targetDiv, portletKey, resultJson);
		           	}
		        });
			}else{
				fnSetWeatherInfo(targetDiv, portletKey);
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
		
		function fnSetWeatherInfo(targetDiv, portletKey, resultJson) {
			var storageSaveName = "bizWeather_" + portletKey;
			
			if(!resultJson) {
				resultJson = JSON.parse(sessionStorage.getItem(storageSaveName));
			}
			
			var imgUrl = "<c:url value='/Images/UC/weather_source/' />";
			if (resultJson != null && resultJson.header == "00") {
		        $( targetDiv ).find("[name=portletTemplete_weather_img]").attr("src", imgUrl + resultJson.multi.img);
		        $( targetDiv ).find("[name=portletTemplete_weather_temp]").html(resultJson.t1h);
		       	$( targetDiv ).find("[name=portletTemplete_weather_desc]").html(fnConvertWeatherNm(resultJson.multi));
		       	
		       	sessionStorage.removeItem(storageSaveName);
		       	sessionStorage.setItem(storageSaveName, JSON.stringify(resultJson));
		    }else{
		    	var storageBeforWeather = JSON.parse(sessionStorage.getItem(storageSaveName));
		    	
		    	// 로컬스토리지에 이전 날씨 정상적인 정보가 있으면 이전 날씨 정보를 보여준다. 
		    	if((storageBeforWeather !== undefined || storageBeforWeather !== "" || storageBeforWeather !== null) && storageBeforWeather.header === "00") {
		    		$( targetDiv ).find("[name=portletTemplete_weather_img]").attr("src", imgUrl + storageBeforWeather.multi.img);
			        $( targetDiv ).find("[name=portletTemplete_weather_temp]").html(storageBeforWeather.t1h);
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
			sessionStorage.setItem("bizWeatherError", JSON.stringify(result));
		}
		
		function render_portletTemplete_mybox(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_mybox" ).val());
			
			if('${empCheckWorkYn}' == "Y"){
				
				var comeDt = '${userAttInfo.comeDt}';
				var leaveDt = '${userAttInfo.leaveDt}';				
				
				if(portletInfo.val01 == "Y" || portletInfo.val02 == "Y"){
					
					if(comeDt.length == 14){
						var comeTime = portletInfo.val02 == 'Y' ? comeDt.substring(0,4) + '.' + comeDt.substring(4,6) + '.' + comeDt.substring(6,8) + ' ' + comeDt.substring(8,10) + ':' + comeDt.substring(10,12) + ':' + comeDt.substring(12,14) : '';
						$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근",(String) request.getAttribute("langCode"))%></em> ' + comeTime + " " + '&nbsp;&nbsp;');
					}else{
						$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음",(String) request.getAttribute("langCode"))%></em>' + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(1,0);" style="cursor: pointer;"><img id="inBtn" alt="" src="/gw/Images/np_myinfo_in_blue.png"></a>' : ''));
					}
					
					if(leaveDt.length == 14){
						var leaveTime = portletInfo.val02 == 'Y' ? leaveDt.substring(0,4) + '.' + leaveDt.substring(4,6) + '.' + leaveDt.substring(6,8) + ' ' + leaveDt.substring(8,10) + ':' + leaveDt.substring(10,12) + ':' + leaveDt.substring(12,14) : '';
						$( targetDiv ).find("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근",(String) request.getAttribute("langCode"))%></em> ' + leaveTime + " " + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(4,0);" style="cursor: pointer;"><img id="outBtn" alt="" src="/gw/Images/np_myinfo_out_blue.png"></a>' : ''));
					}else{
						$( targetDiv ).find("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000016097","퇴근시간 없음",(String) request.getAttribute("langCode"))%></em>' + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(4,0);" style="cursor: pointer;"><img id="outBtn" alt="" src="/gw/Images/np_myinfo_out_blue.png"></a>' : ''));
					}
					
					$( targetDiv ).find("#container").show();
				}
				
				//자동출근처리
				if(portletInfo.val03 == "Y" && comeDt == ""){
					
					var attAlertDate = localStorage.getItem("attAlertDate");
					var attAlertToDay = new Date().toISOString().substr(0,10) + "${loginVO.uniqId}";
					
					if(attAlertDate == null || attAlertDate != attAlertToDay){
						fnAttendCheck(1, 1);
					}
				}					
			}
		}
		
		function render_portletTemplete_notice(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_notice" ).val());

			fnDrawAlertPortlet();
			
		}
		
		function render_portletTemplete_web_sign(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_web_sign" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
						
			if(portletInfo != null && portletInfo != "" && portletInfo.useYn != "N" && portletInfo.val0 != ""){
				
				var optionValue = "";
				var tblParams = {};
				var mainMoveSeq = "";
				
				//전자결재 포틀릿 조회범위 설정을 하지 않을 시 val0 프로퍼티가 정의되지 않는다. 
				if(portletInfo.val0 === undefined) {
					$(targetDiv).find("[name=portletTemplete_web_sign_list]").html("");
					return;
				}
				
				//메뉴권한이 없을 경우 처리 - 전자결재(영리)
				if(eaType == 'eap' && !checkUserPortletAuth(2000000000)){
					$( targetDiv ).find("[name=portletTemplete_web_sign_list]").html("");
					return;
				}
				
				//메뉴권한이 없을 경우 처리 - 전자결재(비영리)
				if(eaType == 'ea' && !checkUserPortletAuth(100000000)){
					$( targetDiv ).find("[name=portletTemplete_web_sign_list]").html("");
					return;
				}
				
				if(typeof portletInfo.val0 === "object") {
					portletInfo.val0.forEach(function(item){
						optionValue += item.menu_seq + ",";
					});
					tblParams.val0 = optionValue.slice(0,-1);
					mainMoveSeq = portletInfo.val0[0].menu_seq;
				} else {
					tblParams.val0 = portletInfo.val0;
					mainMoveSeq = portletInfo.val0.split(",")[0];
				}
								
				tblParams.val1 = portletInfo.val1;
				tblParams.val2 = portletInfo.val2;
				tblParams.iframe = "N";
				
				if(eaType == "ea"){
			    	$(targetDiv).find("[name=portletTemplete_web_sign_more]").attr("onclick", "fnEventMainMoveNon('"+mainMoveSeq+"');");
				}else{
			    	$(targetDiv).find("[name=portletTemplete_web_sign_more]").attr("onclick", "fnEventMainMove('"+mainMoveSeq+"');");
				}
								
				var apiName = eaType == "ea" ? "/ea/edoc/main/EaPortletCloudList.do" : "/eap/ea/edoc/main/EaPortletCloudList.do";
				
				$.ajax({
					type: "post",
		            url: apiName,
		            datatype: "json",
		            data: tblParams,
		            async: true,
		            success: function (result) {
		            	//console.log(result);
		            	var eapPortletDocList = result.EaPortletDocList !== "" ? JSON.parse(result.EaPortletDocList) : "";
		            	
		            	if(eapPortletDocList.length > 0) {
		            		
		            		var tag = '';
		            		
		            		tag+='<div class="ptl_approval freebScrollY"><ul>';
		            		
		            		if(eaType == "ea"){
		            			
			            		/* [비영리 시작] */
			                	for(var i=0; i<eapPortletDocList.length; i++) {
			                		
			                		//삭제문서인 경우 미표시
			                		if(eapPortletDocList[i].docSts == "d"){
			    						continue;
			    					}
			                		
			                		var newContents = false;
			                		
		                            if ((eapPortletDocList[i].readYN || '') == 'N') {
		                            	newContents = true;
		                            	tag += '<li class="new">';
		                            }else{
		                            	tag += '<li>';	
		                            }
			                		
			                		tag += '<dl>';
			                	       /* [아이콘] */
			                        switch(eapPortletDocList[i].docSts) {
			                        	//미결
			                        	case '002' : tag += '<dd class="sign bg_orange"><%=BizboxAMessage.getMessage("TX000003976","미결",(String) request.getAttribute("langCode"))%></dd>'
			                				break;
			                            //협조
			                            case '003' : tag += '<dd class="sign bg_orange"><%=BizboxAMessage.getMessage("TX000003976","미결",(String) request.getAttribute("langCode"))%></dd>'
			                       			break;  
		                          		//기결
		                          	    case '008' : tag += '<dd class="sign gray"><%=BizboxAMessage.getMessage("TX000004824","종결",(String) request.getAttribute("langCode"))%></dd>'
			                       			break;
		                                //반려
		                                case '007' : tag += '<dd class="sign bg_red2"><%=BizboxAMessage.getMessage("TX000002954","반려",(String) request.getAttribute("langCode"))%></dd>'
		                           			break;
		                                //회수
		                                case '005' : tag += '<dd class="sign bg_darkgray"><%=BizboxAMessage.getMessage("TX000003999","회수",(String) request.getAttribute("langCode"))%></dd>'
		                           			break;
		                                //보류
		                                case '004' : tag += '<dd class="sign bg_yellow2"><%=BizboxAMessage.getMessage("TX000003206","보류",(String) request.getAttribute("langCode"))%></dd>'
		                                	break;
			                        	default :  '<dd class="sign gray"></dd>'
			                        		break;
			                        }
			                		
			                        /* [작성부서 기안자] 문서제목 [신규 아이콘] */
			                        tag += '<dt class="title">';
			                        
			                        if(eapPortletDocList[i].emergencyFlag == "1") {
		                    			tag += '<img src="/ea/Images/ico/ico_emergency.png" alt="긴급아이콘" style="float:left; padding-top: 5px; padding-right: 2px;" />';
		                    		}
			                        
			                        if ((eapPortletDocList[i].docTitle || '') != '') {
			                            tag += '<a href="#" title="' + escapeHtml(eapPortletDocList[i].docTitle) + '" onclick="fnEventDocTitleNon(\'' + eapPortletDocList[i].docId + '\');fnReadCheck(this);">' + (tblParams.val2 == 'Y' ? '[' + eapPortletDocList[i].empName + '] ' : '' ) + escapeHtml(eapPortletDocList[i].docTitle) + '</a>';
			                            if (newContents) {
			                                tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" name="newIconImage" />';
			                            }
			                        } else {
			                            tag += '';
			                        }
			                        tag += '</dt>';

			                        /* [기안일자] */
			                        tag += '<dd class="date">';
			                        if ((eapPortletDocList[i].repDt || '') != '') {
			                            tag += ncCom_Replace(ncCom_Date(eapPortletDocList[i].repDt.substr(0,8) , "SYMD"), ".", "-");
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
		                    		
			                		var newContents = false;
			                		
		                            if ((eapPortletDocList[i].READYN || '') == 'N') {
		                            	newContents = true;
		                            	tag += '<li class="new">';
		                            }else{
		                            	tag += '<li>';	
		                            }		                    		
		                    		
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
		                            	//예결
		                            	case '71' : tag += '<dd class="sign yellow">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
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
		                    		
		                    		if(eapPortletDocList[i].emergencyFlag == "1") {
		                    			tag += '<img src="/eap/Images/ico/ico_emergency.png" alt="긴급아이콘" style="float:left; padding-top: 5px; padding-right: 2px;" />';
		                    		}
		                    		
		                    		if ((eapPortletDocList[i].DISP_TITLE || '') != '') {
		                                /* [작성부서 기안자] 문서제목 [신규아이콘] - [작성부서 기안자] 문서제목 */
		                    			if(tblParams.val2 == "Y"){
		                    				tag += '<a title="' + escapeHtml(eapPortletDocList[i].DISP_TITLE) + '" href="#" onclick="fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ');fnReadCheck(this);">' + escapeHtml(eapPortletDocList[i].DISP_TITLE) + '</a>';
		                                } else {
		                                	tag += '<a title="' + escapeHtml(eapPortletDocList[i].DOC_TITLE_ORIGIN) + '" href="#" onclick="fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ');fnReadCheck(this);">' + escapeHtml(eapPortletDocList[i].DOC_TITLE_ORIGIN) + '</a>';
		                                }
		                                
		                                /* [작성부서 기안자] 문서제목 [신규아이콘] -  [신규아이콘] */
		                                if (newContents) {
		                                    tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" name="newIconImage" />';
		                                }
		                            } else {
		                                tag += '';
		                            }
		                    		tag += '</dt>';
		                            
		                            /* [기안일자] */
		                            tag += '<dd class="date">';
		                            if ((eapPortletDocList[i].REP_DT || '') != '') {
		                                tag += ncCom_Replace(eapPortletDocList[i].REP_DT, ".", "-");
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
		            		
		            		freebScroll();
		            		
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
	        window.open(url, 'AppDoc', 'menubar=0,resizable=1,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
	    }
		
		// 전자결재 팝업보기(비영리)
	    function fnEventDocTitleNon( c_dikeycode ) {
	    	var obj = {
	    		diKeyCode : c_dikeycode
	    	};
	    	var param = NeosUtil.makeParam(obj);
	    	
	    	neosPopup("POP_ONE_DOCVIEW_MAIN", param);  
	    }		
		
		// 더보기(전자결재 메뉴 이동)
		function fnEventMainMove(menuNo) {
			
			if(menuNo != "" && menuNo.split(",").length > 1)
				menuNo = menuNo.split(",")[0];				
			
	   		mainmenu.mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/ea/eadoc/EaDocList.do', 'eap', '', 'main', '2000000000', menuNo, '<%=BizboxAMessage.getMessage("TX000010094","결재요청문서",(String) request.getAttribute("langCode"))%>', 'main');
		}
		
		// 더보기(전자결재(비영리) 메뉴 이동)
		function fnEventMainMoveNon(menuNo) {
			var langPackText = {
				TX000000479: "<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>",
				TX000008298: "<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>"
			};
			
			if(menuNo != "" && menuNo.split(",").length > 1)
				menuNo = menuNo.split(",")[0];				
			
			if(menuNo == "102010000") {		// 결재대기문서
				mainmenu.mainToLnbMenu('100000000', langPackText["TX000000479"], '/neos/edoc/eapproval/approvalbox/standingList.do', 'ea', '', 'main', '100000000', menuNo, langPackText["TX000008298"], 'main');
			} else if(menuNo == "102030000") {		// 결재완료문서 
				mainmenu.mainToLnbMenu('100000000', langPackText["TX000000479"], '/neos/edoc/eapproval/approvalbox/finishList.do', 'ea', '', 'main', '100000000', menuNo, langPackText["TX000008298"], 'main');
			} else if(menuNo == "102040000") {		// 결재반려문서
				mainmenu.mainToLnbMenu('100000000', langPackText["TX000000479"], '/neos/edoc/eapproval/approvalbox/returnList.do', 'ea', '', 'main', '100000000', menuNo, langPackText["TX000008298"], 'main');
			} else if(menuNo == "102020000") {		// 결재예정문서
				mainmenu.mainToLnbMenu('100000000', langPackText["TX000000479"], '/neos/edoc/eapproval/approvalbox/standbyList.do', 'ea', '', 'main', '100000000', menuNo, langPackText["TX000008298"], 'main');
			} else if(menuNo == "101030000") {		// 상신문서
				mainmenu.mainToLnbMenu('100000000', langPackText["TX000000479"], '/neos/edoc/eapproval/reportstoragebox/draftDoc.do', 'ea', '', 'main', '100000000', menuNo, langPackText["TX000008298"], 'main');
			} else if(menuNo == "101060000") {		// 열람문서
				mainmenu.mainToLnbMenu('100000000', langPackText["TX000000479"], '/neos/edoc/eapproval/reportstoragebox/readingList.do', 'ea', '', 'main', '100000000', menuNo, langPackText["TX000008298"], 'main');		
			}
		}		
		
		function render_portletTemplete_sign_form(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_sign_form" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			var optionVal = fnSelectPortletUserSet(portletKey, "custValue0");
			
			//세팅값이 없을경우 처리
			if((optionVal == null || optionVal == "") && (portletInfo == null || portletInfo == "")){
				$(targetDiv).find("[name=portletTemplete_sign_form_list]").html("");
				return;
			}
			
			//메뉴권한이 없을 경우 처리 - 결재양식(영리)
			if(eaType == 'eap' && !checkUserPortletAuth(2001010000)){
				$( targetDiv ).find("[name=portletTemplete_sign_form_list]").html("");
				return;
			}
			
			//메뉴권한이 없을 경우 처리 - 결재양식(비영리)
			if(eaType == 'ea' && !checkUserPortletAuth(101010000)){
				$( targetDiv ).find("[name=portletTemplete_sign_form_list]").html("");
				return;
			}
			
			if(optionVal != null || (portletInfo != null && portletInfo != "" && portletInfo.useYn != "N" && portletInfo.val0 != "")){
				var tblParams = {};

				if(optionVal != null){
					tblParams.opValue = optionVal;
				}else if(portletInfo.val0 != null){
					tblParams.opValue = portletInfo.val0;
				}else {
					tblParams.opValue = "";
				}
				
				var apiName = eaType == "ea" ? "nonEaFormList.do" : "eaFormList.do";
				
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
			            	
			            	freebScroll();
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
				
		function render_portletTemplete_sign_status(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_sign_status" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html("");
				return;
			}					
			
			//메뉴권한이 없을 경우 처리 - 결재현황(영리)
			if(eaType == 'eap' && !checkUserPortletAuth(2000000000)){
				$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html("");
				return;
			}	
			
			//메뉴권한이 없을 경우 처리 - 결재현황(비영리)
			if(eaType == 'ea' && !checkUserPortletAuth(100000000)){
				$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html("");
				return;
			}
			
			var apiName = eaType == "ea" ? "nonEaInfoCount.do" : "eapInfoCount.do";
			
			$.ajax({
				type: "post",
	            url: apiName,
	            datatype: "json",
	            async: true,
	            success: function (result) {

	            	var tag = '';
	            	var langPackText = {
           				TX000000476: "<%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%>"
	            	}
	               	
	               	if(result.eapInfoCount != null && result.eapInfoCount.resultCode == "SUCCESS") {
	               		
	               		var eapInfoCountData = result.eapInfoCount.result.boxList;
	               		
	               		var eaBox1 = "0";
	               		var eaBox2 = "0";
	               		var eaBox3 = "0";
	               		var eaBox4 = "0";
	               		var eaBox5 = "0";
	               		var eaBox6 = "0";
	               		
	               		var menuName1 = "";
	               		var menuName2 = "";
	               		var menuName3 = "";
	               		var menuName4 = "";		
	               		var menuName5 = "";
	               		var menuName6 = "";
	               		
	               		if(eapInfoCountData.length > 0){
	               			
	               			tag+='<div class="mdst"><ul>';
	               			
	               			if(eaType == "ea"){
	               				
	    	               		menuName1 = "<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>";		// 결재대기문서 (102010000)
	    	               		menuName2 = "<%=BizboxAMessage.getMessage("TX000010199","결재완료문서",(String) request.getAttribute("langCode"))%>";		// 결재완료문서 (102030000)
	    	               		menuName3 = "<%=BizboxAMessage.getMessage("TX000010198","결재반려문서",(String) request.getAttribute("langCode"))%>";		// 결재반려문서 (102040000)
	    	               		menuName4 = "<%=BizboxAMessage.getMessage("TX000010204","상신문서",(String) request.getAttribute("langCode"))%>";		// 상신문서 (101030000)
	    	               		menuName5 = "<%=BizboxAMessage.getMessage("TX000010201","열람문서",(String) request.getAttribute("langCode"))%>";		// 열람문서 (101060000)
	    	               		menuName6 = "<%=BizboxAMessage.getMessage("TX000010200","결재예정문서",(String) request.getAttribute("langCode"))%>";		// 결재예정문서 (102020000)	    	               				
	               				
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
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102010000\');" class=" fwb"><span class="text_red">' + eaBox1 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		} 
	                       		
	                       		if(portletInfo.val01) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName2 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102030000\');" class=" fwb"><span class="text_red">' + eaBox2 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                       		
	                       		if(portletInfo.val02) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName3 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102040000\');" class=" fwb"><span class="text_blue">' + eaBox3 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                          		
	                       		if(portletInfo.val03) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName4 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'101030000\');" class=" fwb"><span class="text_blue">' + eaBox4 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                        		
	                       		if(portletInfo.val04) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName5 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'101060000\');" class=" fwb"><span class="text_blue">' + eaBox5 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}
	                        		
	                       		if(portletInfo.val05) {
	                       			tag+='<li>';
	                           		tag+='<dl>';
	                           		tag+='<dt>' + menuName6 + '</dt>';
	                           		tag+='<dd><a href="javascript:fnEventMainMoveNon(\'102020000\');" class=" fwb"><span class="text_blue">' + eaBox6 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
	                           		tag+='</dl>';
	                           		tag+='</li>';
	                       		}	               				
	               				
	               			}else{
	               				
	                       		var menuId1 = "0";		// 미결함(메뉴 이름 변경 경우)
	                       		var menuId2 = "0";		// 예결함(메뉴 이름 변경 경우)
	                       		var menuId3 = "0";		// 수신참조함(메뉴 이름 변경 경우)
	                       		var menuId4 = "0";		
	                       		var menuId5 = "0";		// 결재요청문서(메뉴 이름 변경 경우)  	   
	                       		
	                       		var menuName1 = "미결함";
	                       		var menuName2 = "예결함";
	                       		var menuName3 = "수신참조함";
	                       		var menuName5 = "결재요청문서";
	                       		var groupSeq = "${loginVO.groupSeq}";

			               		for(var i=0; i<eapInfoCountData.length; i++) {
			               			if(eapInfoCountData[i].menuId == "2002020000") {
			               				eaBox1 = eapInfoCountData[i].alramCnt;
			               				menuName1 = eapInfoCountData[i].menuName;
			               				menuId1 = eapInfoCountData[i].menuId;
			               			} else if(eapInfoCountData[i].menuId == "2002030000") {
			               				eaBox2 = eapInfoCountData[i].alramCnt;
			               				menuName2 = eapInfoCountData[i].menuName;
			               				menuId2 = eapInfoCountData[i].menuId;
			               			} else if(eapInfoCountData[i].menuId == "2002090000") {
			               				eaBox3 = eapInfoCountData[i].alramCnt;
			               				menuName3 = eapInfoCountData[i].menuName;
			               				menuId3 = eapInfoCountData[i].menuId;
			               			} else if(eapInfoCountData[i].menuId == "2002010000" || (groupSeq == "arario" && eapInfoCountData[i].menuId === "2019042232")) {
			               				eaBox5 = eapInfoCountData[i].alramCnt;
			               				menuName5 = eapInfoCountData[i].menuName;
			               				menuId5 = eapInfoCountData[i].menuId;
			               			}
			               		}  			               		
	               				
			               		if(portletInfo.val00) {
			               			tag+='<li>';
			                      		tag+='<dl>';
			                      		tag+='<dt>' + menuName1 + '</dt>';
			                      		tag+='<dd><a href="javascript:fnEventMainMove(\'' + menuId1 + '\');" class=" fwb"><span class="text_red">' + eaBox1 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
			                      		tag+='</dl>';
			                      		tag+='</li>';
			               		} 
			               		
			               		if(portletInfo.val01) {
			               			tag+='<li>';
			                      		tag+='<dl>';
			                      		tag+='<dt>' + menuName2 + '</dt>';
			                      		tag+='<dd><a href="javascript:fnEventMainMove(\'' + menuId2 + '\');" class=" fwb"><span class="text_red">' + eaBox2 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
			                      		tag+='</dl>';
			                      		tag+='</li>';
			               		}
			               		
			               		if(portletInfo.val02) {
			               			tag+='<li>';
			                      		tag+='<dl>';
			                      		tag+='<dt>' + menuName3 + '</dt>';
			                      		tag+='<dd><a href="javascript:fnEventMainMove(\'' + menuId3 + '\');" class=" fwb"><span class="text_blue">' + eaBox3 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
			                      		tag+='</dl>';
			                      		tag+='</li>';
			               		}
			                  		
		                  		if(portletInfo.val04) {
		                  			tag+='<li>';
		                      		tag+='<dl>';
		                      		tag+='<dt><%=BizboxAMessage.getMessage("TX000000475","진행중",(String) request.getAttribute("langCode"))%></dt>';
		                      		tag+='<dd><a href="javascript:fnEventMainMove(\'' + menuId5 + '\');" class=" fwb"><span class="text_blue">' + eaBox5 + '</span>' + langPackText["TX000000476"] + '</a></dd>';
		                      		tag+='</dl>';
		                      		tag+='</li>';
		                  		}	               				
	               			}
	                  		tag+='</ul></div>';		               		
	               		}
	               	}
	            	
	               	$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html(tag);
	               	$( targetDiv ).find("[name=portletTemplete_sign_status_list]").addClass("freebScroll");
	               	freebScroll();
	            },
	            error: function (e) {
	            	$( targetDiv ).find("[name=portletTemplete_sign_status_list]").html("");
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
			
			//메뉴권한이 없을 경우 처리 - 메일현황 
			if(!checkUserPortletAuth(200000000)){
				$( targetDiv ).find("[name=portletTemplete_mail_status_list]").html("");
				return;
			}
			
			
			$.ajax({
				type: "post",
	            url: "emailCountUsage.do",
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
	            		tag += '<dt><%=BizboxAMessage.getMessage("TX000001580","받은편지함",(String) request.getAttribute("langCode"))%></dt>';
	                	tag += '<dd><a class=" fwb" href="javascript:fnMailMain()"><span class="text_blue">' + allunseen + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
	                	tag += '</dl>';	
	                	tag += '</li>';
	            	}
	            	
	            	if(portletInfo.val1 == "Y") {
	            		tag += '<li>';
	                	tag += '<dl>';
	                	tag += '<dt><%=BizboxAMessage.getMessage("TX000000478","사용량",(String) request.getAttribute("langCode"))%></dt></dt>';
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
	            	
	            	freebScroll();
	            },
	            error: function (e) {
	            	$( targetDiv ).find("[name=portletTemplete_mail_status_list]").html("");
	            }
			});		
		}
		
		// 메일 메뉴 이동
		function fnMailMain(){
			onclickTopMenu(200000000,'<%=BizboxAMessage.getMessage("TX000000262","메일",(String) request.getAttribute("langCode"))%>', mailUrl + '?ssoType=GW', 'mail');
		}
		
		function render_portletTemplete_inbox(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_inbox" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);

			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find( "[name=portletTemplete_inbox_list]" ).html("");	
				return;
			}			
			
			//메뉴권한이 없을 경우 처리 - 받은편지함
			if(!checkUserPortletAuth(200000000)){
				$( targetDiv ).find("[name=portletTemplete_inbox_list]").html("");
				return;
			}
			
			var tag = '';
			var params = {};
			params.seen = portletInfo.val1;
			
			var apiName = "portletEmailList.do";
			
			if(portletInfo.val0 == "1"){
				apiName = "emailTotal.do";
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
		                        		tag+='<dd class="date">' + emailData[i].rfc822date.substring(2,10) + '</dd>';	                       				
	                       			}else{
		                        		tag+='<dd class="from_info">' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
		                        		tag+='<dd class="date">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';	                       				
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
    	                    		tag+='<dd class="date">' + emailData[i].rfc822date.substring(2,10) + '</dd>';	                       				
                       			}else{
    	                    		tag+='<dd class="from_info">' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
    	                    		tag+='<dd class="date">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';	                       				
                       			}	                   			

	                    		tag+='</dl></li>';
	                		}
	                		
	                	}
						tag+='</ul></div>';	            		
	            	}
	            	
	            	$( targetDiv ).find( "[name=portletTemplete_inbox_list]" ).html(tag);
	            	
	            	if($( targetDiv ).find( "[name=portletTemplete_inbox_list] ul li" ).length > 0){
	            		freebScroll();	
	            	}else{
	            		$( targetDiv ).find( "[name=portletTemplete_inbox_list]" ).html("");	
	            	}
	            	
	            },
	            error: function (e) {
	            	$( targetDiv ).find( "[name=portletTemplete_inbox_list]" ).html("");
	            }
			});			
		}
		
		// 메일 팝업
		function mailInfoPop(muid, obj){
			var gwDomain = window.location.host + (window.location.port == "" ? "" : (":" + window.location.port));
			openWindowPop( mailUrl + "readMailPopApi.do?gwDomain=" + gwDomain + "&email=" + mail + "&muid=" + muid + "&seen=0&userSe=USER","readMailPopApi",1020,700,1,1,"");
			fnSavePortal(muid);
			$(obj).closest("li.unlead").removeClass("unlead");
		}
		
		var readMailPop;
		function openWindowPop(url,  windowName, width, height, strScroll, strResize, position ){
			windowX = Math.ceil( (window.screen.width  - width) / 2 );
			windowY = Math.ceil( (window.screen.height - height) / 2 );
			if(strResize == undefined || strResize == '') {
				strResize = 0 ;
			}
			
			readMailPop = parent.window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll+", resizable="+ strResize);
			
			try {readMailPop.focus(); } catch(e){}
			return readMailPop;
		}		
		
		// 읽음처리
		function fnSavePortal(muid){
	 		var tblParam = {};
	 		tblParam.mailUrl = mailUrl;
	 		tblParam.muids = muid;
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'emailSetSeenFlag.do',
	    		datatype:"json",
	            data: tblParam ,
	            async: true,
	    		success: function (result) {

	   		    } ,
			    error: function (result) { 
			    	console.log("<%=BizboxAMessage.getMessage("TX000010954","읽음처리 실패",(String) request.getAttribute("langCode"))%>");
	    		}
	    	});
		}		
		
		function render_portletTemplete_board(portletInfo, targetDiv, portletKey){
			
			$( targetDiv ).html($( "#portletTemplete_board" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find("[name=portletTemplete_board_list]").html("");
				return;
			}
			
			//메뉴권한이 없을 경우 처리 - 게시판
			if(!checkUserPortletAuth(501000000)){
				$( targetDiv ).find("[name=portletTemplete_board_list]").html("");
				return;
			}
			
			/*			
	    	$(targetDiv).find("[name=portletTemplete_board_more]").on("click",function(){
	    		mainMove("NOTICE","/board/viewBoard.do?boardNo=" + portletInfo.val1, portletInfo.val1);
	    	});*/
	    	
	    	$(targetDiv).find("[name=portletTemplete_board_more]").attr("onclick", "mainMove('NOTICE','/board/viewBoard.do?boardNo="+portletInfo.val1+"','"+portletInfo.val1+"');");
	    	
			var tblParams = {};
			tblParams.boardNo = portletInfo.val1;
			tblParams.count = portletInfo.val2;
			$.ajax({
				type: "post",
				
		         url: 'boardPortlet.do',
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
		        				
		        				if(dataList[i].readYn == "N"){
		        					tag += '<li class="new" >';
		        				}else{
		        					tag += '<li>';
		        				}
		        				
		        				if(dataList[i].replyCnt == "0") {
		        					tag += '<dl>';		        					
		        					tag += '	<dt class="title">';
		        					tag += "		<a title=\"" + escapeHtml(dataList[i].art_title) + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ");fnReadCheck(this);\">" + escapeHtml(dataList[i].art_title) + "</a>";
		        					if(dataList[i].readYn == "N"){
			        					tag += '	<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" class="new" />';
			        				}
		        					tag += '	</dt>';
		        					tag += '	<dd class="date">' + ncCom_Date(dataList[i].write_date.substr(0,8), "SYMD", "-") + '</dd>';
		        					if(dataList[i].add_file_yn == "Y") {
		        						tag += '	<dd class="file"><img src="/gw/Images/ico/ico_file.png" alt="첨부파일" ></dd>';
		        					}
		        					tag += '</dl>';
		        				
		        				} else {
		        					tag += '<dl>';		        					
		        					tag += '	<dt class="title">';
		        					tag += "		<a title=\"" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ")\">" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "</a>";
		        					if(dataList[i].readYn == "N"){
			        					tag += '	<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" class="new" />';
			        				}
		        					tag += '	</dt>';
		        					tag += '	<dd class="date">' + ncCom_Date(dataList[i].write_date.substr(0,8), "SYMD", "-") + '</dd>';
		        					if(dataList[i].add_file_yn == "Y"){
		        						tag += '	<dd class="file"><img src="/gw/Images/ico/ico_file.png" alt="첨부파일" ></dd>';	
		        					}
		        					tag += '</dl>';
		        				}
		        				
		        				tag += '</li>';
		        			}
		        			tag+='</ul></div>';		            		
		        		}
		        	}
		        	
		        	$( targetDiv ).find("[name=portletTemplete_board_list]").html(tag);
		        	
		        	freebScroll();
		         },
		         error: function (e) {
		        	 $( targetDiv ).find("[name=portletTemplete_board_list]").html("");
		         }
			});
	    }
	    
		// 게시판 팝업
		function fnBoardPop(catSeq, artSeq) {
			//console.log(catSeq + "/" + artSeq);
			var url = "/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq;
			openWindow2(url,  "pop", 1200, 711,"yes", 1) ;
		}	
		
		// 문서 포틀릿 렌더링 함수
		function render_portletTemplete_doc(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_doc" ).val());
			fnSetPortletLangName(targetDiv, portletInfo);
			
			//세팅값이 없을경우 처리
			if(portletInfo == null || portletInfo == ""){
				$( targetDiv ).find("[name=portletTemplete_doc_list]").html("");
				return;
			}				
			
			//메뉴권한이 없을 경우 처리 - 문서
			if(!checkUserPortletAuth(601000000)){
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
		         url: 'docPortlet.do',
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
		       			tag = "<div class='ptl_board freebScrollY'><ul><li><%=BizboxAMessage.getMessage("TX900000365","본 문서함에 대한 읽기 권한이 없습니다.",(String) request.getAttribute("langCode"))%></li></ul></div>";
		       			
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
		
		// 문서 팝업
		function fnDocPop(dir_type, art_seq_no) {
			var url = "/edms/doc/viewPost.do?artNo="+art_seq_no+"&dir_type="+dir_type;
			openWindow2(url,  "pop", 1200, 711,"yes", 1) ;
		}	
		
		function fn_set(data){
			
			var item = jQuery.parseJSON(JSON.stringify(data));
				
	        var intWidth = item.docWidth;
	        var intHeight = screen.height - 100;

	        var url = "/eap/ea/eadocpop/EAAppDocPop.do?form_id=" + item.formId;
	        var target = "AppDocW";

	        if (item.interlockUrl != "") {
	     		var connector = (item.interlockUrl.indexOf("?") < 0 ? "?" : "&");
	        	url = item.interlockUrl + connector + "form_id=" + item.formId + "&form_tp=" + item.formDTp + "&doc_width=" + item.docWidth;
	            target = "";

	            if (item.interlockWidth != "") {
	                intWidth = item.interlockWidth;
	            }

	            if (item.interlockHeight != "") {
	                intHeight = eval(item.interlockHeight);
	            }
	        }

	        var intLeft = screen.width / 2 - intWidth / 2;
	        var intTop = screen.height / 2 - intHeight / 2 - 40;

	        window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
	        
		}
		
		function formOpen_main (data) {
			var item = jQuery.parseJSON(JSON.stringify(data));
			var template_key = item.CODE;
			var formInfo = getFormDetailInfo(item.CODE);
			
			var C_CIKIND = formInfo.C_CIKIND;
			
			var intLeft = screen.width / 2 - intWidth / 2;
		    var intTop = screen.height / 2 - intHeight / 2 - 40;
			var intWidth  = formInfo.C_ISURLWIDTH;
			var intHeight = formInfo.C_ISURLHEIGHT;
			
			if(intWidth == "") {
				intWidth = "990";
			}
			
			if(intHeight == "") {
				intHeight = "990";
			}
			
			var target = "AppForm";
			if(formInfo.C_LNKCODE == "LNK001"){ /** 연동여부 ***/
				var obj = {
					template_key : template_key,
					c_cikind : C_CIKIND
			    };
					
			    var param = NeosUtil.makeParam(obj);
			    var dataParam = formInfo.C_URLPARAM || "";
			    var url = formInfo.C_TIREGISTPAGEURL + "?" + param + "&" + dataParam;
		        
			    if(formInfo.C_ISURLPOP == "1"){ // 팝업여부
			    	window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
			    }else{
			    	document.location.href = url;
			    }
			}else if (formInfo.C_LNKCODE == "LNK002"){
					if (formInfo.C_TIREGISTPAGEURL != "") {
			        	/* interlock_url dp "?" 가 포함된 경우와 포함되지 않은 경우 처리 */
			     		var connector = (formInfo.C_TIREGISTPAGEURL.indexOf("?") < 0 ? "?" : "&");
			        	url = formInfo.C_TIREGISTPAGEURL + connector + "form_id=" + template_key + "&form_tp=" + formInfo.FORM_D_TP + "&doc_width=" + formInfo.C_ISURLWIDTH + "&eaType=ea";
			        	window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop );
			        }else{
			    		var obj = {template_key : template_key};
			    		var param = NeosUtil.makeParam(obj);
			    		neosPopup('POP_DOCWRITE_MAIN', param) ;
			        }        
			}else{
				var obj = {template_key : template_key};
				var param = NeosUtil.makeParam(obj);
				neosPopup('POP_DOCWRITE_MAIN', param) ;
			}
		}
		
		function getFormDetailInfo(c_tikeycode){
			var data = {c_tikeycode : c_tikeycode};
			var result = {};
		    $.ajax({
		        type:"post",
		        url:'/ea/neos/edoc/eapproval/reportstoragebox/getFormInfo.do',
		        datatype:"json",
		        data : data,
		        async : false,
		        success:function(data){       
		        	result = data.result;
		            
		        }   
		    });
		    return result;
		}
		
		function fnUserPortletSet(data) {
			var portletDiv = $(data).closest("div[portletKey]");
			var portletTp = $(portletDiv).attr("portletTp");
			
			var params = "&portalId=${portalId}&portletTp=" + portletTp + "&portletKey=" + $(portletDiv).attr("portletKey") + "&position=0";
			
			if(portletTp == "portletTemplete_sign_form"){
				var eaFormList = $("li[name=eaForm]");
				var formIdList = "";
				
				for (var i = 0; i < eaFormList.length; i++) {
					formIdList += "," + eaFormList[i].id;
				}				
				
				if (formIdList.length > 0)
					formIdList = formIdList.substring(1);
				
				if(eaType == "ea"){
					var url = "portletNonEaFormUserSetPop.do?formIdList=" + formIdList + params;
					openWindow2(url, "portletEaFormListPop", 502, 700, 1, 1);					
				}else{
					var url = "portletEaFormUserSetPop.do?formIdList=" + formIdList + params;
					openWindow2(url, "portletEaFormListPop", 502, 700, 1, 1);
				}
			}else if(portletTp == "portletTemplete_weather") {
				var weatherCity = $(portletDiv).find("[name=portletTemplete_weather_location]").attr("weatherCity");
				var url = "portletWeatherUserSetPop.do?weatherId=" + weatherCity + params;
				openWindow2(url, "portletWeatherUserSetPop", 502, 200, 1, 1);	
			}
		}		
		
		/*사용자설정 콜백*/
		function fnDrawEaFormPortlet(resultInfo, position){
			fnInsertPortletUserSet(resultInfo);
			render_portletTemplete_sign_form(null, $("[portletkey="+resultInfo.portletKey+"]"), resultInfo.portletKey);
		}
		
		function fnDrawWeatherPortlet(resultInfo, position, locationChangeFlag){
			fnInsertPortletUserSet(resultInfo);
			render_portletTemplete_weather(null, $("[portletkey="+resultInfo.portletKey+"]"), resultInfo.portletKey, locationChangeFlag);
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
		
		var alMoreYn = "Y";	//전체알림 추가조회여부
		var mtMoreYn = "Y"; //멘션 추가조회여부
		var timeSp = ""; //타임스템프(알림조회기준시간)
		var mentionTimeSp = ""; //타임스템프 멘션용				
		function fnDrawAlertPortlet(){
			
			if(alMoreYn == "Y" || mtMoreYn == "Y"){		
				var tblParam = {};
				tblParam.alMoreYn  = alMoreYn;
				tblParam.mtMoreYn  = mtMoreYn;
				tblParam.timeSp = timeSp;
				tblParam.mentionTimeSp  = mentionTimeSp ;
				
				$.ajax({ 
					type:"POST",
					url: '<c:url value="/getAlertList.do"/>',
					datatype:"json",	
					data: tblParam,
					success:function(data){		
						if(data.alertList != null){
							setAlertPortlet(data.alertList.result, "alertListTag");
							alMoreYn = data.alertList.result.moreYn;
							timeSp = data.alertList.result.timeStamp;
						}
						if(data.mentionList != null){
							setAlertPortlet(data.mentionList.result, "mentionListTag");
							mtMoreYn = data.mentionList.result.moreYn;
							mentionTimeSp = data.mentionList.result.timeStamp;
						}
						setAlertPortletEvent();
					}  
				});
			}
		}
		
		function setAlertPortletEvent(){
			$(".list_con").each(function(){
				var innerContents = $(this).html();	
				//console.log(innerContents)
				for(;;){
					//console.log('for 문 진입: ', innerContents.indexOf("|&gt;@"), innerContents.indexOf("@&lt;|"));
					if(innerContents.indexOf("|&gt;@") != -1 && innerContents.indexOf("@&lt;|") != -1){
						var name = innerContents.substring(innerContents.indexOf(",name=")+7, innerContents.indexOf("@&lt;|")-1);
						//console.log('name: ', name, innerContents.indexOf(",name=")+7, innerContents.indexOf("@&lt;|")-1);
						var empSeq = innerContents.substring(innerContents.indexOf("|&gt;@empseq=")+14, innerContents.indexOf(",name=")-1);
						//console.log('empSeq: ', empSeq, innerContents.indexOf("|&gt;@empseq=")+14, innerContents.indexOf(",name=")-1);
						if(empSeq == "${loginVO.uniqId}"){
							innerContents = innerContents.slice(0,innerContents.indexOf("|&gt;@")) + '<span style="color:#00b97a;">' + name + '</span>' + innerContents.slice(innerContents.indexOf("@&lt;|")+6);
						}else{
							innerContents = innerContents.slice(0,innerContents.indexOf("|&gt;@")) + '<span class="mt_marking">' + name + '</span>' + innerContents.slice(innerContents.indexOf("@&lt;|")+6);
						}
						
						//console.log('innerContents: ', innerContents);
					}
					else{					
						break;
					}
				}
				//console.log('innerContents 완료 : ', innerContents);
				$(this).html(innerContents);
			});
			
			
			//알림탭
	    	$(".alert_tab li").on("click",function(){
	    		var mapClass = $(this).children().attr("class");
	    		
	    		$(".alert_tab li").removeClass('on');
		   		$(this).addClass('on');
		   		$(".tabCon").hide();
		   		$("." + "_" + mapClass).removeClass("animated1s fadeInDown").toggleClass("animated1s fadeInDown").show();
	    	});
	    				
			//컨텐츠를 클릭할때(컨텐츠에 타이틀도 포함)
			$(".list_con").on("click",function(){
				$(this).parent().removeClass("unread");
			});
			
			//접고 펼치기
			$(".toggle_portlet_btn").on("click",function(){
				$(this).toggleClass("down");
				$(this).parent().parent().find(".sub_portlet_detail").removeClass("animated1s fadeIn").toggleClass("animated1s fadeIn").toggle();
				
				//멘션 접고 펼치기
				if($(this).hasClass("down")){
					$(this).parent().parent().find(".mention_portlet_detail").removeClass("ellipsis").toggleClass("animated1s fadeIn");
				}else{
					$(this).parent().parent().find(".mention_portlet_detail").removeClass("animated1s fadeIn").toggleClass("ellipsis");
				}
			});
			
			// 알림 스크롤 이벤트
			$(".mention_alert_box .mentionCon").scroll(function(){
				$(".tag_date").css("top",$(this).scrollTop()+10);				
				TagInAm();			
			});

			//스크롤 끝나면 이벤트
			$(".mention_alert_box .mentionCon").scrollEnd(function(){
				TagOutAm();
			},1000);
		}
		
		function setAlertPortlet(alertInfo, target){
			var today = getTodayDate();
			var checkDate = "";
			var checkCnt = 0;
			
			var alertList = alertInfo.alertList;
			var innerHtml = "";
			
			var newCnt = 0;
			
			for(var i=0; i<alertList.length; i++){
				var alertDate = alertList[i].createDate.substring(0, 8);
				var displayDate = alertDate.substring(4,6) + "." + alertDate.substring(6,8) 
				
				if(alertDate != checkDate){
					checkDate = alertDate;
					if(today == alertDate){
						innerHtml += '<li class="dayline today"><span><%=BizboxAMessage.getMessage("TX000003149","오늘",(String) request.getAttribute("langCode"))%></span>' + displayDate + ' ' + getWeekDay(alertDate) + '</li>';
					}else{
						innerHtml += '<li class="dayline"><span>' + displayDate + '</span>' + getWeekDay(alertDate) + '</li>';
					}
					
				}
				if(alertList[i].readDate == null || alertList[i].readDate == ""){
					innerHtml += '<li class="unread">';
					newCnt++;
				}else{
					innerHtml += '<li class="">';
				}
				
				if(alertList[i].eventType == "TALK" || alertList[i].eventType == "MESSAGE"){
					innerHtml += '<div class="pic_wrap">';
					innerHtml += '<div class="pic"></div>';
					innerHtml += '<div class="div_img">';					
					innerHtml += '<img src="${profilePath}/' + alertList[i].senderSeq + '_thum.jpg" onerror="this.src=\'/gw/Images/bg/mypage_noimg.png\'" >';
					innerHtml += '</div>';
					innerHtml += '</div>';				
				}else if(alertList[i].eventType == "PROJECT"){
					innerHtml += '<div class="icon sc"></div>';
				}else if(alertList[i].eventType == "MAIL"){
					innerHtml += '<div class="icon mail"></div>';
				}else if(alertList[i].eventType == "RESOURCE"){
					innerHtml += '<div class="icon sc"></div>';
				}else if(alertList[i].eventType == "REPORT"){
					innerHtml += '<div class="icon wkr"></div>';
				}else if(alertList[i].eventType == "EAPPROVAL"){
					innerHtml += '<div class="icon ea"></div>';
				}else if(alertList[i].eventType == "BOARD"){
					innerHtml += '<div class="icon bd"></div>';
				}else if(alertList[i].eventType == "EDMS"){
					innerHtml += '<div class="icon dc"></div>';
				}else if(alertList[i].eventType == "ATTEND"){
					innerHtml += '<div class="icon dc"></div>';
				}else if(alertList[i].eventType == "SCHEDULE"){
					innerHtml += '<div class="icon sc"></div>';
				}else if(alertList[i].eventType == "FAX"){
					innerHtml += '<div class="icon fax"></div>';
				}else if(alertList[i].eventSubType == "GW001"){
					innerHtml += '<div class="icon pass"></div>';
				}else if(alertList[i].eventType == "ONEFFICE"){
					innerHtml += '<div class="icon of"></div>';
				}else if(alertList[i].eventType == "CUST"){
					innerHtml += '<div class="icon" style="background: url(/upload/img/custAlertIcon/' + alertList[i].eventType + '_' + alertList[i].eventSubType + '.png)"></div>';
				}
				
				if(alertList[i].webActionType != null && alertList[i].webActionType == "C"){
					innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.",(String) request.getAttribute("langCode"))%>\');" data=\'' + alertList[i].data + '\'>';
				}else if(alertList[i].eventType != "MAIL"){
					
					var alertData = JSON.parse(alertList[i].data); 
					if(alertList[i].eventType == "EAPPROVAL" && alertData.mobileViewYn == "N") {
						//비영리 전자결재 문서리스트 중 mobileViewYn값이 N이면 문서를 열람할 수 없다. 
						innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.",(String) request.getAttribute("langCode"))%>\');" data=\'' + alertList[i].data + '\'>';						
					} else {
						innerHtml += '<div class="list_con" onclick="forwardPageByAlert(\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\',\'' + alertList[i].eventType + '\',\'' + alertList[i].eventSubType + '\',\'' + alertList[i].senderSeq + '\', this);" data=\'' + alertList[i].data + '\'>';
					}
					
				}else{
					innerHtml += '<div class="list_con" onclick="fnMailMove(\'' + alertList[i].mailUid + '\',\'' + alertList[i].email + '\',\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\')" data=\'' + alertList[i].data + '\'>';
				}
				
				innerHtml += '<a href="#n" onclick="return false;" class="title" title="' + alertList[i].message.alertTitle + '">' + alertList[i].message.alertTitle + '</a>';
				innerHtml += '<dl>';
				innerHtml += getAlertContentsHtml(alertList[i], target);
				innerHtml += '</dl></div>';
				
				innerHtml += '<div class="list_fn">';
				innerHtml += '<span class="date">' + alertList[i].createDate.substring(8, 10) + ':' + alertList[i].createDate.substring(10, 12) + '</span>';
				if(checkEventType(alertList[i].eventType, alertList[i].eventSubType)){
					innerHtml += '<a href="#n" onclick="return false;" class="toggle_portlet_btn"></a>';
				}
				innerHtml += '</div>';
				innerHtml += '</li>';
			}
			$("#" + target).append(innerHtml);
			
			
			if(target == "alertListTag" && newCnt > 0){
				$("#alertNewIcon").addClass("new");
			}else if(target == "mentionListTag" && newCnt > 0){
				$("#mentionNewIcon").addClass("new");
			}
		}
		
		function checkEventType(eventType, eventSubType){
			if(eventType == "TALK" || eventType == "MESSAGE"){		
				return true;
			}else{
				if(eventSubType == "MA001" || eventSubType == "BO002" ||eventSubType == "BO001" ||eventSubType == "ED001" ||eventSubType == "EA101" ||eventSubType == "RP003" ||eventSubType == "RP002" ||eventSubType == "RP001" ||eventSubType == "RS001" ||eventSubType == "SC001" ||eventSubType == "PR013" ||eventSubType == "PR011" ||eventSubType == "PR001"){
					return true;
				}else{
					return false;	
				}			
			}
			
		}
		
		
		function getAlertContentsHtml(alertInfo, target){
			var data = JSON.parse(alertInfo.data);
			var eventType = alertInfo.eventType;
			var eventSubType = alertInfo.eventSubType;
			var alertId = alertInfo.alertId;
			var tag = "";
			
			var langPackText = {
				TX000015246: "<%=BizboxAMessage.getMessage("TX000015246","기간/일수",(String) request.getAttribute("langCode"))%>",
				TX000006753: "<%=BizboxAMessage.getMessage("TX000006753","진행률",(String) request.getAttribute("langCode"))%>",
				TX000000352: "<%=BizboxAMessage.getMessage("TX000000352","프로젝트명",(String) request.getAttribute("langCode"))%>",
				TX000000329: "<%=BizboxAMessage.getMessage("TX000000329","담당자",(String) request.getAttribute("langCode"))%>",
				TX000012430: "<%=BizboxAMessage.getMessage("TX000012430","업무명",(String) request.getAttribute("langCode"))%>",
				TX000001232: "<%=BizboxAMessage.getMessage("TX000001232","없음",(String) request.getAttribute("langCode"))%>",
				TX000000802: "<%=BizboxAMessage.getMessage("TX000000802","보고일자",(String) request.getAttribute("langCode"))%>",
				TX000006610: "<%=BizboxAMessage.getMessage("TX000006610","보고사항",(String) request.getAttribute("langCode"))%>",
				TX000002910: "<%=BizboxAMessage.getMessage("TX000002910","특이사항",(String) request.getAttribute("langCode"))%>",
				TX000000145: "<%=BizboxAMessage.getMessage("TX000000145","내용",(String) request.getAttribute("langCode"))%>"
			};
			
			
			if(eventType == "TALK" || eventType == "MESSAGE"){			
				tag += '<dd class="mention_portlet_detail ellipsis">';
			}
			else{
				if(eventSubType == "MA001"){
					tag += '<dt title="' + alertInfo.message.alertContent + '">' + alertInfo.message.alertContent + '</dt>';
					tag += '<dd class="sub_portlet_detail" title="' + data.content + '">';
				}else{
					tag += '<dt>' + alertInfo.message.alertContent + '</dt>';
					tag += '<dd class="sub_portlet_detail">';
				}
			}
			
			if(eventSubType == "PR001"){
				tag += langPackText["TX000015246"] + ' : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.prjDays)+')' + '<br>';			
				tag += 'PM : '+isNull(data.pmEmpName)+' '+isNull(data.pmPositionName)+ '<br>';
				tag += langPackText["TX000006753"] + ' : '+isNull(data.processRate)+ '<br>';
				tag += isNull(data.prjStatus)+ '<br>';
				tag += isNull(data.dcRmk)+ '<br>';
			}else if(eventSubType == "PR011"){
				tag += langPackText["TX000000352"] + ' : '+isNull(data.prjName)+ '<br>';
				tag += langPackText["TX000015246"] + ' : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.workDays)+')'+ '<br>';
				tag += langPackText["TX000000329"] + ' : '+isNull(data.ownerEmpName)+' '+isNull(data.ownerDutyName)+ '<br>';
				tag += langPackText["TX000006753"] + ' : '+isNull(data.processRate)+isNull(data.workStatus)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "PR013"){
				tag += langPackText["TX000000352"] + ' : '+isNull(data.prjName)+ '<br>';
				tag += langPackText["TX000012430"] + ' : '+isNull(data.workName)+ '<br>';
				tag += langPackText["TX000015246"] + ' : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.jobDays)+')'+ '<br>';
				tag += langPackText["TX000000329"] + ' : '+isNull(data.ownerJobedEmpName)+isNull(data.ownerJobedDutyName)+ '<br>';
				tag += langPackText["TX000006753"] + ' : '+isNull(data.processRate)+isNull(data.jobStatus)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "SC001"){

				tag += '<%=BizboxAMessage.getMessage("TX000000720","참여자",(String) request.getAttribute("langCode"))%> : ';
				
				if(data.schUserList != null){
					var eList = data.schUserList;
					var schUserList = "";
					for(var k=0; k<eList.length; k++) {
						if(k > 0){
							schUserList += ', ';
						}
						schUserList += eList[k].empName + " " + eList[k].dutyName;
					}
					
					tag += schUserList+ '<br>';
				}
				else{
					tag += langPackText["TX000001232"] + '<br>';
				}
				
				tag += '<%=BizboxAMessage.getMessage("TX000007571","일시",(String) request.getAttribute("langCode"))%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000752","장소",(String) request.getAttribute("langCode"))%> : '+isNull(data.schPlace)+ '<br>';
				
				tag += '<%=BizboxAMessage.getMessage("TX000012112","자원",(String) request.getAttribute("langCode"))%> : ';
				if(data.resList != null){
					var rList = data.resList;
					var resList = "";
					for(var l=0; l<rList.length; l++) {
						if(l > 0){
							resList += "<br>";
						}
						resList += isNull(rList[l].resName);
					}
					
					tag += resList+ '<br>';
				}
				else{
					tag += langPackText["TX000001232"] + '<br>';
				}
				
				tag += isNull(data.contents);
			}else if(eventSubType == "RS001"){
				tag += '<%=BizboxAMessage.getMessage("TX000000286","사용자",(String) request.getAttribute("langCode"))%> : ';
				
				if(data.resUserList != null){
					var uList = data.resUserList;
					var userList = "";
					for(var l=0; l<uList.length; l++) {
						if(l > 0){
							userList += ", ";
						}
						userList += isNull(uList[l].empName);
					}
					
					tag += userList+ '<br>';
				}
				else{
					tag += langPackText["TX000001232"] + '<br>';
				}
				tag += '<%=BizboxAMessage.getMessage("TX000012157","예약기간",(String) request.getAttribute("langCode"))%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000012088","자원명",(String) request.getAttribute("langCode"))%> : '+isNull(data.resName)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "RP001"){
				if(data.onefficeYn != "Y"){
					tag += '<%=BizboxAMessage.getMessage("TX000000802","보고일자",(String) request.getAttribute("langCode"))%> : '+isNull(data.reportDate)+ '<br>';
					
					tag += '<%=BizboxAMessage.getMessage("TX000006607","주요일정",(String) request.getAttribute("langCode"))%> : ';
					if(data.majorSchedules != null){
						var msList = data.majorSchedules;
						var majorSchedules = "";
						for(var k=0; k<msList.length; k++) {
							majorSchedules += msList[k].content;
						}
						
						tag += majorSchedules+ '<br>';
					}
					else{
						tag += langPackText["TX000001232"] + '<br>';
					}
	
					tag += '<%=BizboxAMessage.getMessage("TX000000672","주요업무",(String) request.getAttribute("langCode"))%> : ';
					if(data.majorWorks != null){
						var mwList = data.majorWorks;
						var majorWorks = "";
						for(var l=0; l<mwList.length; l++) {
							majorWorks += mwList[l].content;
						}
						
						tag += majorWorks+ '<br>';
					}
					else{
						tag += langPackText["TX000001232"] + '<br>';
					}
				}
			}else if(eventSubType == "RP002"){
				if(data.onefficeYn != "Y"){
					tag += langPackText["TX000000802"] + ' : '+isNull(data.reportDate)+ '<br>';
					tag += langPackText["TX000006610"] + ' : '+isNull(data.reportContent)+ '<br>';
					tag += langPackText["TX000002910"] + ' : '+isNull(data.note)+ '<br>';
				}
			}else if(eventSubType == "RP003"){
				if(data.onefficeYn != "Y"){
					tag += langPackText["TX000000802"] + ' : '+isNull(data.reportDate)+ '<br>';
					tag += langPackText["TX000006610"] + ' : '+isNull(data.reportContent)+ '<br>';
					tag += langPackText["TX000002910"] + ' : '+isNull(data.note)+ '<br>';
				}
			}else if(eventSubType == "EA101"){
				if(isNull(data.doc_no) != ""){
					tag += '<%=BizboxAMessage.getMessage("TX000018380","품의번호",(String) request.getAttribute("langCode"))%> : '+isNull(data.doc_no)+ '<br>';
				}
				tag += '<%=BizboxAMessage.getMessage("TX000000665","작성일자",(String) request.getAttribute("langCode"))%> : ('+isNull(data.created_dt)+')'+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000499","기안자",(String) request.getAttribute("langCode"))%> : '+isNull(data.userName)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "ED001"){
				tag += '<%=BizboxAMessage.getMessage("TX000000663","문서번호",(String) request.getAttribute("langCode"))%> : '+isNull(data.artNm)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("","작성자 : ",(String) request.getAttribute("langCode"))%>'+isNull(data.senderName);
				tag += isNull(data.empNo_v)+' '+isNull(data.posCd_v)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000756","업무분류",(String) request.getAttribute("langCode"))%> : '+isNull(data.dir_cd)+ '<br>';
			}else if(eventSubType == "BO001"){
				tag += isNull(data.content);
			}else if(eventSubType == "BO002"){
				tag += '<%=BizboxAMessage.getMessage("TX000000352","프로젝트명",(String) request.getAttribute("langCode"))%> : '+isNull(data.project_name)+ '<br>';
				tag += isNull(data.content);
			}else if(eventSubType == "MA001"){
				var sContent = isNull(data.content);
				if(sContent != ""){
					if(sContent.length < 48)
						tag += "</br>" + langPackText["TX000000145"] + " : " + sContent;
					else
						tag += "</br>" + langPackText["TX000000145"] + " : " + sContent.substring(0,48) + "...";
				}
			}else if(eventType == "TALK" || eventType == "MESSAGE"){
				tag += alertInfo.message.alertContent;		
			}
			
			tag += '</dd>';
			
			return tag;
		}
		
		//null값 체크(''공백 반환)
		function isNull(obj){
			return (typeof obj != "undefined" && obj != null) ? obj : "";
		}
		
		
		function getWeekDay(date){
			var week = new Array('<%=BizboxAMessage.getMessage("TX000006545","일요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006546","월요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006547","화요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006548","수요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006549","목요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006550","금요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000000821","토요일",(String) request.getAttribute("langCode"))%>'); 
			var year = date.substr(0,4);
			var month = date.substr(4,2);
			var day = date.substr(6,2);	
			
			var dateTime = year + "-" + month + "-" + day;
			
			var varDate = new Date(dateTime);  // date로 변경
			
			return week[varDate.getDay()];
		}
		
		function getTodayDate(){
			var date = new Date(); 
			var year = date.getFullYear();
			var month = new String(date.getMonth()+1);
			var day = new String(date.getDate()); 
			// 한자리수일 경우 0을 채워준다. 
			if(month.length == 1)
			  month = "0" + month; 

			if(day.length == 1)
			  day = "0" + day; 
			var toDay = year + "" + month + "" + day;
			return toDay;
		}
		
		//출퇴근 체크(가능시간확인)
		var ipAddr = "";
		var localIpAddr = "";
		
		function fnAttendCheck(type, autoCheck){
			
			var time = "";
			var attendTimeInfo = null;
			var resultCode = "";
			var param = {};

			param.compSeq = "${loginVO.compSeq}";
			param.empSeq = "${loginVO.uniqId}";
			
			var d = new Date();
			param.weekSeq = d.getDay();
			
			$.ajax({
	            type: "post",
	            url: '<c:url value="/cmm/systemx/getAttendTimeInfo.do" />',
	            datatype: "json",
	            async: false,
	            data: param,
	            success: function (data) {
	            	
	            	var flag = false;
	            	attendTimeInfo = data.attendTimeInfo;
	            	ipAddr = data.ipAddr;
	            	localIpAddr = data.localIpAddr;
	            	time = data.now;
	            	
	    			//근태기준시간설정 체크 
	    			if(type == "1" && attendTimeInfo != null){	
	    				if(attendTimeInfo.comePassTimeStart <= time && attendTimeInfo.commPassTimeEnd >= time){
	    					flag = true;
	    				}
	    			}
	    			else if(type == "4" && attendTimeInfo != null){
	    				if(attendTimeInfo.leavePassTimeStart <= time && attendTimeInfo.leavePassTimeEnd >= time){
	    					flag = true;
	    				}
	    			}
	    			
	    			if(flag){
	    				
	    				if(autoCheck == 1){
							var attAlertToDay = new Date().toISOString().substr(0,10) + "${loginVO.uniqId}";
							localStorage.setItem("attAlertDate", attAlertToDay);
	    				}
	    				
	    				fnAttendConfirm(type);
	    				
	    			}else if(autoCheck == 0){
						var inTime = attendTimeInfo.comePassTimeStart.substring(0,2) + ":" + attendTimeInfo.comePassTimeStart.substring(2,4) + " ~ " + attendTimeInfo.commPassTimeEnd.substring(0,2) + ":" + attendTimeInfo.commPassTimeEnd.substring(2,4);
						var outTime = attendTimeInfo.leavePassTimeStart.substring(0,2) + ":" + attendTimeInfo.leavePassTimeStart.substring(2,4) + " ~ " + attendTimeInfo.leavePassTimeEnd.substring(0,2) + ":" + attendTimeInfo.leavePassTimeEnd.substring(2,4);			
						var contentStr;
						
						if(type == "1"){
							contentStr = "<%=BizboxAMessage.getMessage("TX000010924","출근 가능시간이 아닙니다.　(출근 가능시간",(String) request.getAttribute("langCode"))%>".replace("　","\n")+" : " + inTime + ")";
						}
						if(type == "4"){
							contentStr = "<%=BizboxAMessage.getMessage("TX000010923","퇴근 가능시간이 아닙니다.　(퇴근 가능시간",(String) request.getAttribute("langCode"))%>".replace("　","\n")+" : " + outTime + ")";
						}
						
						Pudd.puddDialog({
							width:550, 
							height:150, 
							footer: {
								buttons: [{
									attributes : {},
									controlAttributes : { id : "btnConfirm", class : "submit" },
									value : "<%=BizboxAMessage.getMessage("TX000019752","확인",(String) request.getAttribute("langCode"))%>",
									clickCallback : function( puddDlg ) {
										puddDlg.showDialog( false );
									}
								}]
							},
							message:{type:"error", content:contentStr}
						});		    				
	    			}
	            },
	            error: function (e) {
	            }
	        });
		}
		
		function fnAttendConfirm(type){
			
			var contentStr;
			
			if(type == 1){
				contentStr = "<%=BizboxAMessage.getMessage("TX000010928","출근 체크 하시겠습니까?",(String) request.getAttribute("langCode"))%>";
			}
			else if(type == 4){
				contentStr = "<%=BizboxAMessage.getMessage("TX000010927","퇴근 체크 하시겠습니까?",(String) request.getAttribute("langCode"))%>";
			}
			
			// puddDialog 함수
			Pudd.puddDialog({
				width : 350
			,	height : 100
			,	modal : true		// 기본값 true
			,	draggable : false	// 기본값 true
			,	resize : false		// 기본값 false
			,	header : {
					title : "<%=BizboxAMessage.getMessage("TX000016109","출퇴근체크",(String) request.getAttribute("langCode"))%>"
				,	align : "center"	// left, center, right
				,	minimizeButton : false	// 기본값 false
				,	maximizeButton : false	// 기본값 false
				,	closeButton : true	// 기본값 true
				,	closeCallback : function( puddDlg ) {
						// close 버튼은 내부에서 showDialog( false ) 실행함 - 즉, 닫기 처리는 내부에서 진행됨
						// 추가적인 작업 내용이 있는 경우 이곳에서 처리
					}
				}
			,	body : {
					// dialog content 문자열
					content : contentStr
				,	contentCallback : function( contentDiv ) {
						//  content 내용에 입력 컨트롤 등을 추가하여 제어가 필요한 경우 이 부분에서 처리
					}
				}
			,	footer : {
					buttons : [
						{
							attributes : {}// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
						,	value : "<%=BizboxAMessage.getMessage("TX000019752","확인",(String) request.getAttribute("langCode"))%>"
						,	clickCallback : function( puddDlg ) {
								puddDlg.showDialog( false );
								// 추가적인 작업 내용이 있는 경우 이곳에서 처리
								fnAttendCheckProc(type);
							}
						}
					,	{
							attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
						,	value : "<%=BizboxAMessage.getMessage("TX000019660","취소",(String) request.getAttribute("langCode"))%>"
						,	clickCallback : function( puddDlg ) {
								puddDlg.showDialog( false );
								// 추가적인 작업 내용이 있는 경우 이곳에서 처리
							}
						}
					]
				}
			});			
		}
		
		function fnAttendCheckProc(type){
			
		 	var tblParam = {};
		 	tblParam.gbnCode = type.toString();		        
 			$.ajax({
 	        	type:"post",
 	    		url:'insertComeLeaveEventApi.do',
 	    		datatype:"json",
 	            data: tblParam ,
 	            async: false,
	            success: function (data) { 
	               if(data.resultCode == "SUCCESS"){
	            	   var attendDate = data.result.substring(0,4) + '.' + data.result.substring(4,6) + '.' + data.result.substring(6,8) + ' ' + data.result.substring(8,10) + ':' + data.result.substring(10,12) + ':' + data.result.substring(12,14);
	            	   
	            	   Pudd.puddDialog({
	            		   width:550, 
	            		   height:150, 
	            		   message: {
	            			   type:"success", 
	            			   content:data.resultMessage
	            		   },
	            		   footer: {
	            			   buttons: [{
	            				   attributes: {},
	            				   controlAttributes: {id: "btnConfirm", class: "submit"},
	            				   value : "<%=BizboxAMessage.getMessage("TX000019752","확인",(String) request.getAttribute("langCode"))%>",
	            				   clickCallback : function( puddDlg ) {
		   						   		puddDlg.showDialog( false );
		   						   }
	            			   }]
	            		   }
	            	   });			            	   
	            	   
	            	   if(type == "1"){
	            		   $("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근",(String) request.getAttribute("langCode"))%></em> ' + attendDate + " " + '&nbsp;&nbsp;');
	            		   $("#portletTemplete_mybox_tab1").find("a").remove();   
	            	   }
	            	   else if(type == "4"){
	            		   $("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근",(String) request.getAttribute("langCode"))%></em> ' + attendDate + " " + ' <a onclick="fnAttendCheck(4,0);" style="cursor: pointer;"><img id="outBtn" alt="" src="/gw/Images/np_myinfo_out_blue.png"></a>');
// 	            		   $("#portletTemplete_mybox_tab2").find("a").remove();
	            	   }
	            	   
	               }
	               else{
	            	   alert(data.resultMessage + "(" + data.resultCode + ")");
	               }
	            },
	            error: function (e) {
	            }
	        });			
		}
		
		function fnReadCheck(obj){
			
			var selectedNewContent = $(obj).closest("li.new");
			
			if(selectedNewContent.length > 0){
				$(selectedNewContent).removeClass("new");
				$(selectedNewContent).find("[name=newIconImage]").remove();
			}
			
		}
		
		function commuteCheckPermit(callback) {
			var tblParam = {};	 
			
			tblParam.accessType = "web";
			tblParam.groupSeq = "${loginVO.groupSeq}";
			tblParam.compSeq = "${loginVO.compSeq}";
			tblParam.deptSeq = "${loginVO.orgnztId}";
			tblParam.empSeq = "${loginVO.uniqId}";
						
 			$.ajax({
 	        	type:"post",
 	        	contentType :"application/json;",
 	    		url:'/attend/external/api/gw/commuteCheckPermit',
 	    		dataType:"json",
 	            data: JSON.stringify(tblParam),
 	            async: false,
	            success: function (data) { 
	            	if(data != null && data.result != "SUCCESS" && callback) {
	            		callback();
	            	}
	            },
	            error: function (e) {
	            }
	        });
		}
		
		
	</script>

    <script>
    
		$(document).ready(function () {

			var dataStr = '${portletInfo}';

			$("#portletView").css( "position", "relative" );
			var $portletDiv = $("#portletView .portletDiv");

			// json parse
			var jsonObj = JSON.parse( dataStr );

			// portlet 구성
			var arrPortlet = jsonObj.arrPortlet;
			for( var i in arrPortlet ) {
				
				var portlet = arrPortlet[i];

				var divPortlet = document.createElement( "div" );
				$( divPortlet ).css( "position", "absolute" );
				$( divPortlet ).css( "left", portlet.left );
				$( divPortlet ).css( "top", portlet.top );

				$( divPortlet ).addClass( "row" + portlet.sizeRow );
				$( divPortlet ).addClass( "col" + portlet.sizeCol );
				
				$( divPortlet ).attr("portletTp", portlet.boxType);
				$( divPortlet ).attr("portletKey", portlet.portletKey);

				setViewPortlet( divPortlet, portlet.boxType, portlet.portletInfo, portlet.portletKey );

				$portletDiv.append( divPortlet );
			}

			// portlet 내부에서 pudd 컨트롤 사용하는 경우 있으면 초기화 진행
			Pudd.initControl();
								
			commuteCheckPermit(function() {
				$("#inBtn").remove();
				$("#outBtn").remove();
			});
			
			//사용자별 메뉴권한에 따른 포틀릿 더보기 이벤트처리
			setPortletMoreClickEvent();
		});
		
		function setPortletMoreClickEvent(){
			if(!checkUserPortletAuth("303010000")){
				$(".noteMoreClick").attr("onclick","");
			}
			
			if(!checkUserPortletAuth("301000000")){
				$(".scheduleMoreClick").attr("onclick","");
			}
			
			
			if(eaType == "eap"){
				if(!checkUserPortletAuth("2001010000")){
					$(".approvalFormSetting").attr("onclick","");
				}				
				if(!checkUserPortletAuth("2000000000")){
					$(".approvalSignStatus").attr("onclick","");
				}				
			}else{
				if(!checkUserPortletAuth("101010000")){
					$(".approvalFormSetting").attr("onclick","");
				}				
				if(!checkUserPortletAuth("100000000")){
					$(".approvalSignStatus").attr("onclick","");
				}
			}	
			
			if(!checkUserPortletAuth("200000000")){
				$(".mailMoreClick").attr("onclick","");
			}
			
			if(!checkUserPortletAuth("200000000")){
				$(".MailListMoreClick").attr("onclick","");
			}		
		}
    </script>
</head>
	<div class="main_wrap">
			<div id="portletView" class="portletGrid grid10 nonGrid">
				<!-- <div class="portletDiv" style="height:${portalHeight}px;visibility:hidden;"></div> -->
				<div class="portletDiv" style="height:${portalHeight}px;"></div>
			</div>
	    	
			<!-- portlet templete -->
			<div class="portletTemplete" style="display:none;">
				
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
										<li onclick="$(this).siblings().removeClass('active');$(this).addClass('active');$('#portletTemplete_mybox_tab2').hide();$('#portletTemplete_mybox_tab1').show();" class="active" rel="tab1">출근</li>
										<li onclick="$(this).siblings().removeClass('active');$(this).addClass('active');$('#portletTemplete_mybox_tab1').hide();$('#portletTemplete_mybox_tab2').show();" rel="tab2">퇴근</li>
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
			                        <span class="txt"><%=BizboxAMessage.getMessage("TX000000893","알림",(String) request.getAttribute("langCode")) %></span>
			                        <span class="" id="alertNewIcon"></span>
			                        </a>
			                    </li>
			                    <li>
			                        <a href="#n" onclick="return false;" class="tab02">
			                        <span class="ico"></span>
			                        <span class="txt"><%=BizboxAMessage.getMessage("TX000023088","멘션",(String) request.getAttribute("langCode")) %></span>
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
				
				<textarea id="portletTemplete_web_sign" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 style="cursor:pointer;" name="portletTemplete_web_sign_more" class="ea">
						<span name="portletTitle">전자결재</span>
						<a href="#" class="more"></a>
					</h2>
					<div name="portletTemplete_web_sign_list" class="ptl_content nocon">
						<div class="ptl_approval freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_sign_form" style="display:none;">
					<h2 class="ea">
						<span name="portletTitle">결재양식</span>
						<a class="title_more" href="#">
							<img onclick="fnUserPortletSet(this);" style="cursor:pointer;" src="/gw/Images/portal/setting.png" alt="" class="approvalFormSetting"/>
						</a>
					</h2>
					<div name="portletTemplete_sign_form_list" class="ptl_content nocon">
						<div class="ptl_list freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_sign_status" style="display:none;">
					<h2 style="cursor:pointer;"
					<c:choose><c:when test="${loginVO.eaType == 'ea'}">
					onclick="onclickTopCustomMenu(100000000,'전자결재', '', 'ea', '', 'N');"
					</c:when><c:otherwise>
					onclick="mainmenu.mainToLnbMenu('2000000000', '전자결재', '/ea/eadoc/EaDocList.do', 'eap', '', 'main', '2000000000', '2002010000', '상신함', 'main');"
					</c:otherwise></c:choose>
					 class="ea approvalSignStatus">
						<span name="portletTitle">결재현황</span>
						<a href="#n" class="more"></a>
					</h2>
					<div name="portletTemplete_sign_status_list" class="ptl_content">
						<div class="mdst"></div>
					</div>
				</textarea>	
				
				<textarea id="portletTemplete_mail_status" style="display:none;">
					<h2 style="cursor:pointer;" onclick="fnMailMain();" class="ma" class="mailMoreClick">
						<span name="portletTitle">메일현황</span>
						<a href="#n" class="more"></a>
					</h2>
					<div name="portletTemplete_mail_status_list" class="ptl_content nocon">
						<div class="mdst"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_inbox" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 style="cursor:pointer;" onclick="fnMailMain();" class="rm MailListMoreClick">
						<span name="portletTitle">받은편지함</span>
						<a href="#n" class="more"></a>
					</h2>
					<div name="portletTemplete_inbox_list" class="ptl_content nocon">
						<div class="ptl_mail freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_board" style="display:none;">
					<h2 name="portletTemplete_board_more" style="cursor:pointer;" class="bd">
						<span name="portletTitle">게시판</span>
						<a href="#n" class="more"></a>
					</h2>
					<div name="portletTemplete_board_list" class="ptl_content nocon">
						<div class="ptl_board freebScrollY"></div>
					</div>
				</textarea>
				
				<!-- 문서 포틀릿 -->
				<textarea id="portletTemplete_doc" style="display:none;">
					<h2 name="portletTemplete_doc_more" style="cursor:pointer;" class="bd">
						<span name="portletTitle">문서</span>
						<a href="#n" class="more"></a>
					</h2>
					<div name="portletTemplete_doc_list" class="ptl_content nocon">
						<div class="ptl_board freebScrollY"></div>
					</div>
				</textarea>
				
				<textarea id="portletTemplete_survey" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 onclick="" class="su">
						<span name="portletTitle">설문조사</span>
					</h2>
					<div name="portletTemplete_survey" class="ptl_content">
						<iframe name="설문조사" src="/edms/board/getMainSurveyList.do?show_title_yn=N" onerror="mainEmptyPage.do?page=poll" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>	
					</div>					
				</textarea>								
				
				<textarea id="portletTemplete_note" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 onclick="mainMove('NOTE','/Views/Common/note/noteList','');" style="cursor:pointer;" class="nt noteMoreClick">
						<span name="portletTitle">노트</span>
						<a href="#n" class="more"></a>
					</h2>
					<div name="portletTemplete_note_list" class="ptl_content nocon">
						<div class="ptl_board freebScrollY"></div>
					</div>
				</textarea>				
				
				<textarea id="portletTemplete_weather" style="display:none;">
					<div class="ptl_content nocon">
						<div class="ptl_weather">
							<img onclick="fnUserPortletSet(this);" style="cursor:pointer;position:absolute; top:10px;right:10px;" src="/gw/Images/portal/setting.png" alt="">						
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

					<h2 class="sc scheduleMoreClick" onclick="javascript:onclickTopCustomMenu(300000000,'일정', '', '', '', 'N');" style="cursor:pointer;" >
						<span name="portletTitle">일정</span>
						<a href="#n" class="more"></a>
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
								<select name="portletTemplete_calendar_scheSm" onchange="fnChangeScheduleSelect(this);" style="width:211px;cursor:pointer;">
									<!-- <option value="total">전체일정</option> -->
								</select>
							</div>
							
							<!-- 리스트 -->
							<div class="calendar_div st1" style="display:block">
								<h3><span name="portletTemplete_calendar_selectedDate"></span> <span class="fr mr20"><span name="portletTemplete_calendar_selectedCnt" class="text_blue">0</span>건</span></h3>
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
				
					<h2 class="sc scheduleMoreClick" onclick="javascript:onclickTopCustomMenu(300000000,'일정', '', '', '', 'N');" style="cursor:pointer;">
						<span name="portletTitle">일정</span>
						<a href="#n" class="more"></a>
					</h2>
					<div class="ptl_content nocon">
						<div class="ptl_calendar horizontal">
							<div class="calendar_wrap">
							<div name="loadingSchedule" style="display:none;position: absolute;width: 100%;height: 100%;"><img src="/gw/Images/ico/loading_2x.gif" style="margin-left:50%;margin-top:50px;"></div>
								<div class="select_date">
									<a title="이전" class="prev" onclick="calanderPrevNext(-1, this)" href="#"></a>
									<span name="portletTemplete_calendar_calanderDate"></span>
									<a title="다음" class="next" onclick="calanderPrevNext(1, this)" href="#"></a>
								</div>

								<div  class="calender_ta" name="portletTemplete_calendar_calenderTable"></div>                
							</div>

							<div class="horizon_right">
								<div class="calendar_select">
									<select name="portletTemplete_calendar_scheSm" onchange="fnChangeScheduleSelect(this);" style="width:211px;cursor:pointer;">
										<!-- <option value="total">전체일정</option> -->
									</select>
								</div>							
	
								<!-- 리스트 -->
								<div class="calendar_div st1" style="display:block">
									<h3><span name="portletTemplete_calendar_selectedDate"></span> <span class="fr mr20"><span name="portletTemplete_calendar_selectedCnt" class="text_blue">0</span>건</span></h3>
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
	</div>















