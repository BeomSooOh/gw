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
    <link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/pudd.css?ver=20201021">
	<link rel="stylesheet" type="text/css" href="/gw/ebp/css/portlet.css">
	
    <!--js-->
	<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.84.min.js"></script>    
	<script type="text/javascript" src="/gw/js/portlet/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common.js?ver=20201021"></script>
    <script type="text/javascript" src="/gw/js/portlet/Scripts/common_freeb.js?ver=20201021"></script>
    <script type="text/javascript" src="/gw/js/Highcharts-6.1.0/highcharts.js"></script>
    
    <!-- mCustomScrollbar -->
    <script type="text/javascript" src="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>
    <script type="text/javascript" src="/gw/js/mCustomScrollbar/jquery.mousewheel.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.css"/>
    

    <script>
	
    	var langCode = '${loginVO.langCode}';
    	var eaType = '${loginVO.eaType}';
    	var portletUserSetListStr = '${portletUserSetList}';
    	var portletUserSetListDiv = document.createElement( "div" );
    	
    	/* WEHAGO 서비스 필요 변수 START */
    	var wehagoId = "";
		var serviceCode = "";
		var cno = "";
		var device_id = "10ac0b6f";
		var domain = "http://ebpdemo.bizboxa.com";
		var softwareName = "bizbox";
    	/* WEHAGO 서비스 필요 변수 END*/
    	
    	if(portletUserSetListStr != ""){
    		$.each( jQuery.parseJSON(portletUserSetListStr), function( key, value ) {
    			fnInsertPortletUserSet(value);
    		});    		
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

			} else if( "portletTemplete_mybox" == boxType ) {

				$( div ).addClass( "portletBox" );
				render_portletTemplete_mybox(portletInfo, div, portletKey);

			} else if( "portletTemplete_board" == boxType ) {

				$( div ).addClass( "portletBox" );
				render_portletTemplete_board(portletInfo, div, portletKey);

			} else if( "portletTemplete_inbox" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_inbox(portletInfo, div, portletKey);

			} else if( "portletTemplete_calendar_horizontal" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_calendar(portletInfo, div, boxType, portletKey);

			} else if( "portletTemplete_calendar_vertical" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_calendar(portletInfo, div, boxType, portletKey);

			} else if( "portletTemplete_notice" == boxType ) {

				$( div ).addClass( "portletBox" );
				render_portletTemplete_notice(portletInfo, div, portletKey);

			} else if("portletTemplete_assetGrowthIndex" == boxType ){
				
				$( div ).addClass( "portletBox" );
				render_portletTemplete_assetGrowthIndex(portletInfo, div, portletKey);
				
			} else if("portletTemplete_inventoryStatus" == boxType){
				
				$( div ).addClass( "portletBox" );
				render_portletTemplete_inventoryStatus(portletInfo, div, portletKey);
				
			} else if("portletTemplete_bpNetProfit" == boxType){
				
				$( div ).addClass( "portletBox" );
				render_portletTemplete_bpNetProfit(portletInfo, div, portletKey);
				
			} else if("portletTemplete_boundAgeStatus" == boxType){
				
				$( div ).addClass( "portletBox" );
				render_portletTemplete_boundAgeStatus(portletInfo, div, portletKey);
				
			} else if("portletTemplete_salesPerformance" == boxType){
				
				$( div ).addClass( "portletBox" );
				render_portletTemplete_salesPerformance(portletInfo, div, portletKey);
				
			} else if("portletTemplete_wehagoService" == boxType){
				
				$( div ).addClass( "portletBox" );
				render_portletTemplete_wehagoService(portletInfo, div, portletKey);
				
			} else if("portletTemplete_totalFundStatus" == boxType){
				
				$( div ).addClass( "portletBox" );
				render_portletTemplete_totalFundStatus(portletInfo, div, portletKey);
				
			} else if("portletTemplete_annualUseManage" == boxType){
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_annualUseManage(portletInfo, div, portletKey);
				
			} else if("portletTemplete_weekWorkingHours" == boxType){
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_weekWorkingHours(portletInfo, div, portletKey);
				
			} else if("portletTemplete_myWorkStatus" == boxType){
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_myWorkStatus(portletInfo, div, portletKey);
				
			} else if("portletTemplete_overTimeApplication" == boxType){
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_overTimeApplication(portletInfo, div, portletKey);
				
			} else if("portletTemplete_workingStatus" == boxType){
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_workingStatus(portletInfo, div, portletKey);
				
			} else if("portletTemplete_etcBox" == boxType){
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_etcBox(portletInfo, div, portletKey);
				
			} else if("portletTemplete_board_hr" == boxType){
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_board_hr(portletInfo, div, portletKey);
				
			} else if( "portletTemplete_requestJob" == boxType ) {
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_requestJob(portletInfo, div, portletKey);
			
			} else if( "portletTemplete_expectedSpendToday" == boxType ) {
				
				$( div ).addClass( "titleBox" );
				render_portletTemplete_expectedSpendToday(portletInfo, div, portletKey);
				
			} else if( "portletTemplete_divExpenseClaim" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_divExpenseClaim(portletInfo, div, portletKey);

			} else if( "portletTemplete_accountingEaProgress" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_accountingEaProgress(portletInfo, div, portletKey);

			} else if( "portletTemplete_mainAccountionTask" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_mainAccountionTask(portletInfo, div, portletKey);

			} else if( "portletTemplete_myCardUsageHistory" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_myCardUsageHistory(portletInfo, div, portletKey);
			} else if( "portletTemplete_salesByDepartment" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_salesByDepartment(portletInfo, div, portletKey);
			} else if( "portletTemplete_salesTrend" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_salesTrend(portletInfo, div, portletKey);
			} else if( "portletTemplete_salesStatus" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_salesStatus(portletInfo, div, portletKey);
				
			} else if( "portletTemplete_monthlySalesPerformance" == boxType ) {

				$( div ).addClass( "titleBox" );
				render_portletTemplete_monthlySalesPerformance(portletInfo, div, portletKey);
				
			} else if( "portletTemplete_inboxCeo" == boxType ) {

				$( div ).addClass( "portletBox" );
				render_portletTemplete_inboxCeo(portletInfo, div, portletKey);
				
			} else {

				return;
			}
		};
		
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
			
			// 공유일정
			if(portletInfo.val1 == "Y") {
				params.share = "Y";
				$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").append("<option value='share'><%=BizboxAMessage.getMessage("TX000010163","공유일정")%></option>");
			} else {
				params.share = "N";
			}
			// 기념일
			if(portletInfo.val2 == "Y") {
				params.special = "Y";
				$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").append("<option value='special'><%=BizboxAMessage.getMessage("TX000007381","기념일")%></option>");
			} else {
				params.special = "N";
			}
			
			// 개인일정
			if(portletInfo.val0 == "Y") {
				$( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").append("<option value='indivi' selected='selected'><%=BizboxAMessage.getMessage("TX000004103","개인일정")%></option>");
				params.indivi = "Y";
				params.share = "N";
				params.special = "N";
			} else {
				params.indivi = "N";
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
	                $( targetDiv ).find("[name=portletTemplete_calendar_selectedCnt]").html(result.scheduleContents.length);
	                
	                fnDrawScheduleContent(result.scheduleContents, targetDiv);
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
	        html += "<th class='sun'><%=BizboxAMessage.getMessage("TX000000437","일")%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005657","월")%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005658","화")%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005659","수")%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000003627","목")%></th>";
	        html += "<th><%=BizboxAMessage.getMessage("TX000005661","금")%></th>";
	        html += "<th class='sat'><%=BizboxAMessage.getMessage("TX000005662","토")%></th>";
	        html += "</tr>";

	        while (date1 < date2) {

	            var classStr = "";

	            if (date1.getFullYear() == yyyy && (date1.getMonth() + 1) == MM && date1.getDate() == dd) {
	                classStr = "today selon";

	                if (days.indexOf(getyyyyMMdd(date1)) > -1) {
	                    classStr += " selon";
	                }
					
	            } else if (days.indexOf(getyyyyMMdd(date1)) > -1) {
	                classStr = " schedule";
	            } else if(holiDay.indexOf(getyyyyMMdd(date1)) > -1) {
	            	classStr += " special_day";
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
	    	var url = "<c:url value='http://"+location.host+"/schedule/Views/Common/mCalendar/detail?seq="+scheduleSeq+"'/>";
	  		openWindow2(url,  "pop", 833, 711,"yes", 1);
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
                     $( targetDiv ).find("[name=portletTemplete_calendar_selectedCnt]").html(result.scheduleContents.length);		             
		             
	 				 fnDrawScheduleContent(result.scheduleContents, targetDiv);
	 				 
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
	    
	    
	    function calanderDateSelectBind(result, targetDiv) {
	    	
	    	var data = result.scheduleContents;
	    	
	    	$( targetDiv ).find("[name=portletTemplete_calendar_list]").html("");
	    	
	        var tag = "";
	        var selectDay = $(".selon").attr("name");	        
			var selectDate = selectDay.split("|");
		    var selectYear = selectDate[0];
		    var selectMonth = selectDate[1];
		    var selectDay = selectDate[2];
		    
		    selectMonth < 10 ? "0" + selectMonth : selectMonth;
			selectDay < 10 ? "0" + selectDay : selectDay;
			   
			var day = selectYear + "-" + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + "-" + (selectDay < 10 ? "0" + selectDay : selectDay);
			
			var holidayList = JSON.parse($( targetDiv ).find("[name=HidHolidayList]").val());
	   
	   		for(var i=0; i<holidayList.length; i++) {
				if(holidayList[i].hDay.indexOf(day.replace(/\-/g,'')) > -1) {
					tag += '<li>';
					tag += '<span class="txt text_red">' + holidayList[i].title + '</span>';
					tag += '</li>';
				}
			}
	        
            $( targetDiv ).find("[name=portletTemplete_calendar_selectedDate]").html(day);
            $( targetDiv ).find("[name=portletTemplete_calendar_selectedCnt]").html(data.length);
	   		
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
		            
		            if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "total") {
		            	 tag += '<li>';
		  				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		  					tag += '<span class="time">' + specialDate + '</span>';
		  				} else {
		  					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		  				}
		  				
		    				if(data[i].gbnCode == "E") {
		    					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		    				} else if(data[i].gbnCode == "M") {
		    					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		    				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		    					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		    				}
		    				
		    				if(data[i].gbnCode == "w") {
		    					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		  				} else if(data[i].gbnCode == "b") {
		  					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
		  				} else {
		  					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
		  					tag += "<a title=\"" + data[i].schTitle + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		  				}
		 				tag += '</li>';
		            } else if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "indivi") {
		            	if(data[i].gbnCode == "E") {
		            		 tag += '<li>';
		      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		      					tag += '<span class="time">' + specialDate + '</span>';
		      				} else {
		      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		      				}
		      				
		        				if(data[i].gbnCode == "E") {
		        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		        				} else if(data[i].gbnCode == "M") {
		        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		        				}
		        				
		        				if(data[i].gbnCode == "w") {
		        					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
		      				} else {
		      					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
		      					tag += "<a title=\"" + data[i].schTitle + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		      				}
		     				tag += '</li>';
		            	}
		            } else if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "share") {
		            	if(data[i].gbnCode == "M") {
		            		 tag += '<li>';
		      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		      					tag += '<span class="time">' + specialDate + '</span>';
		      				} else {
		      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		      				}
		      				
		        				if(data[i].gbnCode == "E") {
		        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		        				} else if(data[i].gbnCode == "M") {
		        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		        				}
		        				
		        				if(data[i].gbnCode == "w") {
		        					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
		      				} else {
		      					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
		      					tag += "<a title=\"" + data[i].schTitle + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		      				}
		     				tag += '</li>';
		            	}
		            } else if($(targetDiv).find("[name=portletTemplete_calendar_scheSm]").val() == "special") {
		            	if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		            		 tag += '<li>';
		      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		      					tag += '<span class="time">' + specialDate + '</span>';
		      				} else {
		      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		      				}
		      				
		        				if(data[i].gbnCode == "E") {
		        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		        				} else if(data[i].gbnCode == "M") {
		        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		        				}
		        				
		        				if(data[i].gbnCode == "w") {
		        					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
		      				} else {
		      					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
		      					tag += "<a title=\"" + data[i].schTitle + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		      				}
		     				tag += '</li>';
		            	}
		            }
	            }
	        } else {
	        	
	        	if(tag == '') {
	        		tag += '<li>';
	    			tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000000776","일정없음")%></span>';
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
		function fnDrawScheduleContent(data, targetDiv) {
			
			var holidayList = JSON.parse($( targetDiv ).find("[name=HidHolidayList]").val());
			
			var tag = '';
			
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
		            
		            if($( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").val() == "total") {
		            	 tag += '<li>';
		  				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		  					tag += '<span class="time">' + specialDate + '</span>';
		  				} else {
		  					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		  				}
		  				
		    				if(data[i].gbnCode == "E") {
		    					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		    				} else if(data[i].gbnCode == "M") {
		    					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		    				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		    					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		    				}
		    				
		    				if(data[i].gbnCode == "w") {
		    					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		  				} else if(data[i].gbnCode == "b") {
		  					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
		  				} else {
		  					tag += "<a title=\"" + data[i].schTitle + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		  				}
		 				tag += '</li>';
		            } else if($( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").val() == "indivi") {
		            	if(data[i].gbnCode == "E") {
		            		 tag += '<li>';
		      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		      					tag += '<span class="time">' + specialDate + '</span>';
		      				} else {
		      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		      				}
		      				
		        				if(data[i].gbnCode == "E") {
		        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		        				} else if(data[i].gbnCode == "M") {
		        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		        				}
		        				
		        				if(data[i].gbnCode == "w") {
		        					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
		      				} else {
		      					tag += "<a title=\"" + data[i].schTitle + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + data[i].schTitle + "</span></a>";
		      				}
		     				tag += '</li>';
		            	}
		            } else if($( targetDiv ).find("[name=portletTemplete_calendar_scheSm]").val() == "share") {
		            	if(data[i].gbnCode == "M") {
		            		 tag += '<li>';
		      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
		      					tag += '<span class="time">' + specialDate + '</span>';
		      				} else {
		      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
		      				}
		      				
		        				if(data[i].gbnCode == "E") {
		        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		        				} else if(data[i].gbnCode == "M") {
		        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		        				}
		        				
		        				if(data[i].gbnCode == "w") {
		        					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
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
		        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인")%></span>';	
		        				} else if(data[i].gbnCode == "M") {
		        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유")%></span>';
		        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
		        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일")%></span>';
		        				}
		        				
		        				if(data[i].gbnCode == "w") {
		        					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></span>';
		      				} else if(data[i].gbnCode == "b") {
		      					tag += '<span class="txt">' + data[i].schTitle + '<%=BizboxAMessage.getMessage("TX000001672","생일")%></span>';
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
	    			tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000000776","일정없음")%></span>';
	    			tag += '</li>';	
	        	}
			}
			
			$( targetDiv ).find("[name=portletTemplete_calendar_list]").html(tag);
			
			freebScroll();
		}
			
		
		var specificDate = new Date(); 
		specificDate.setDate(specificDate.getDate() -7);		
		
		function render_portletTemplete_mybox(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_mybox" ).val());
			
			if('${empCheckWorkYn}' == "Y"){
				
				var comeDt = '${userAttInfo.comeDt}';
				var leaveDt = '${userAttInfo.leaveDt}';				
				
				if(portletInfo.val01 == "Y" || portletInfo.val02 == "Y"){
					
					if(comeDt.length == 14){
						$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근")%></em> ' + comeDt.substring(0,4) + '.' + comeDt.substring(4,6) + '.' + comeDt.substring(6,8) + ' ' + comeDt.substring(8,10) + ':' + comeDt.substring(10,12) + ':' + comeDt.substring(12,14) + " " + '&nbsp;&nbsp;');
					}else{
						$( targetDiv ).find("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음")%></em>' + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(1,0);" style="cursor: pointer;"><img alt="" src="/gw/Images/np_myinfo_in_blue.png"></a>' : ''));
					}
					
					if(leaveDt.length == 14){
						$( targetDiv ).find("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근")%></em> ' + leaveDt.substring(0,4) + '.' + leaveDt.substring(4,6) + '.' + leaveDt.substring(6,8) + ' ' + leaveDt.substring(8,10) + ':' + leaveDt.substring(10,12) + ':' + leaveDt.substring(12,14) + " " + '&nbsp;&nbsp;');
					}else{
						$( targetDiv ).find("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000016097","퇴근시간 없음")%></em>' + (portletInfo.val01 == 'Y' ? ' <a onclick="fnAttendCheck(4,0);" style="cursor: pointer;"><img alt="" src="/gw/Images/np_myinfo_out_blue.png"></a>' : ''));
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
				
		var mail = "";
		var mailUrl = "";
		var email = "";
		var mailcnt = 0;
		var seen = 0;		
				
		// 메일 메뉴 이동
		function fnMailMain(){
			onclickTopMenu(200000000,'<%=BizboxAMessage.getMessage("TX000000262","메일")%>', mailUrl + '?ssoType=GW', 'mail');
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
			
			var apiName = "emailList.do";
			
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
			
			try {readMailPop.focus(); } catch(e){
				console.log(e);//오류 상황 대응 부재
			}
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
	    			//alert("<%=BizboxAMessage.getMessage("TX000010954","읽음처리 실패")%>");
			    	console.log("<%=BizboxAMessage.getMessage("TX000010954","읽음처리 실패")%>");
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
		        					
		        					if(dataList[i].is_new_yn == "Y"){
		        						tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" name="newIconImage" />';
		        					}
		        					
		        				}else{
		        					tag += '<li>';
		        				}
		        				
		        				if(dataList[i].replyCnt == "0") {
		        					tag += "<a title=\"" + dataList[i].art_title + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ");fnReadCheck(this);\">" + dataList[i].art_title + "</a>";	
		        				} else {
		        					tag += "<a title=\"" + dataList[i].art_title + " ( " + dataList[i].replyCnt + " ) " + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ")\">" + dataList[i].art_title + " ( " + dataList[i].replyCnt + " ) " + "</a>";
		        				}
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
			console.log(catSeq + "/" + artSeq);
			var url = "<c:url value='http://"+location.host+"/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq+"'/>";
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
				for(;;){
					if(innerContents.indexOf("|&gt;@") != -1 && innerContents.indexOf("@&lt;|") != -1){
						var name = innerContents.substring(innerContents.indexOf(",name=")+7, innerContents.indexOf("@&lt;|")-1);
						var empSeq = innerContents.substring(innerContents.indexOf("|&gt;@empseq=")+14, innerContents.indexOf(",name=")-1);
						if(empSeq == "${loginVO.uniqId}"){
							innerContents = innerContents.slice(0,innerContents.indexOf("|&gt;@")) + '<span style="color:#00b97a;">' + name + '</span>' + innerContents.slice(innerContents.indexOf("@&lt;|")+6);
						}else{
							innerContents = innerContents.slice(0,innerContents.indexOf("|&gt;@")) + '<span class="mt_marking">' + name + '</span>' + innerContents.slice(innerContents.indexOf("@&lt;|")+6);
						}
					}
					else{					
						break;
					}
				}
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
						innerHtml += '<li class="dayline today"><span><%=BizboxAMessage.getMessage("TX000003149","오늘")%></span>' + displayDate + ' ' + getWeekDay(alertDate) + '</li>';
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
				}
				
				if(alertList[i].webActionType != null && alertList[i].webActionType == "C"){
					innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>\');" data=\'' + alertList[i].data + '\'>';
				}else if(alertList[i].eventType != "MAIL"){
					
					var alertData = JSON.parse(alertList[i].data); 
					if(alertList[i].eventType == "EAPPROVAL" && alertData.mobileViewYn == "N") {
						//비영리 전자결재 문서리스트 중 mobileViewYn값이 N이면 문서를 열람할 수 없다. 
						innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>\');" data=\'' + alertList[i].data + '\'>';						
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
				tag += '<%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.prjDays)+')' + '<br>';			
				tag += 'PM : '+isNull(data.pmEmpName)+' '+isNull(data.pmPositionName)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000006753","진행률")%> : '+isNull(data.processRate)+ '<br>';
				tag += isNull(data.prjStatus)+ '<br>';
				tag += isNull(data.dcRmk)+ '<br>';
			}else if(eventSubType == "PR011"){
				tag += '<%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : '+isNull(data.prjName)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.workDays)+')'+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000329","담당자")%> : '+isNull(data.ownerEmpName)+' '+isNull(data.ownerDutyName)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000006753","진행률")%> : '+isNull(data.processRate)+isNull(data.workStatus)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "PR013"){
				tag += '<%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : '+isNull(data.prjName)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000012430","업무명")%> : '+isNull(data.workName)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.jobDays)+')'+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000329","담당자")%> : '+isNull(data.ownerJobedEmpName)+isNull(data.ownerJobedDutyName)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000006753","진행률")%> : '+isNull(data.processRate)+isNull(data.jobStatus)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "SC001"){

				tag += '<%=BizboxAMessage.getMessage("TX000000720","참여자")%> : ';
				
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
					tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>'+ '<br>';
				}
				
				tag += '<%=BizboxAMessage.getMessage("TX000007571","일시")%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000752","장소")%> : '+isNull(data.schPlace)+ '<br>';
				
				tag += '<%=BizboxAMessage.getMessage("TX000012112","자원")%> : ';
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
					tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>'+ '<br>';
				}
				
				tag += isNull(data.contents);
			}else if(eventSubType == "RS001"){
				tag += '<%=BizboxAMessage.getMessage("TX000000286","사용자")%> : ';
				
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
					tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>'+ '<br>';
				}
				tag += '<%=BizboxAMessage.getMessage("TX000012157","예약기간")%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000012088","자원명")%> : '+isNull(data.resName)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "RP001"){
				if(data.onefficeYn != "Y"){
					tag += '<%=BizboxAMessage.getMessage("TX000000802","보고일자")%> : '+isNull(data.reportDate)+ '<br>';
					
					tag += '<%=BizboxAMessage.getMessage("TX000006607","주요일정")%> : ';
					if(data.majorSchedules != null){
						var msList = data.majorSchedules;
						var majorSchedules = "";
						for(var k=0; k<msList.length; k++) {
							majorSchedules += msList[k].content;
						}
						
						tag += majorSchedules+ '<br>';
					}
					else{
						tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>'+ '<br>';
					}
	
					tag += '<%=BizboxAMessage.getMessage("TX000000672","주요업무")%> : ';
					if(data.majorWorks != null){
						var mwList = data.majorWorks;
						var majorWorks = "";
						for(var l=0; l<mwList.length; l++) {
							majorWorks += mwList[l].content;
						}
						
						tag += majorWorks+ '<br>';
					}
					else{
						tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>'+ '<br>';
					}
				}
			}else if(eventSubType == "RP002"){
				if(data.onefficeYn != "Y"){
					tag += '<%=BizboxAMessage.getMessage("TX000000802","보고일자")%> : '+isNull(data.reportDate)+ '<br>';
					tag += '<%=BizboxAMessage.getMessage("TX000006610","보고사항")%> : '+isNull(data.reportContent)+ '<br>';
					tag += '<%=BizboxAMessage.getMessage("TX000002910","특이사항")%> : '+isNull(data.note)+ '<br>';
				}
			}else if(eventSubType == "RP003"){
				if(data.onefficeYn != "Y"){
					tag += '<%=BizboxAMessage.getMessage("TX000000802","보고일자")%> : '+isNull(data.reportDate)+ '<br>';
					tag += '<%=BizboxAMessage.getMessage("TX000006610","보고사항")%> : '+isNull(data.reportContent)+ '<br>';
					tag += '<%=BizboxAMessage.getMessage("TX000002910","특이사항")%> : '+isNull(data.note)+ '<br>';
				}
			}else if(eventSubType == "EA101"){
				if(isNull(data.doc_no) != ""){
					tag += '<%=BizboxAMessage.getMessage("TX000018380","품의번호")%> : '+isNull(data.doc_no)+ '<br>';
				}
				tag += '<%=BizboxAMessage.getMessage("TX000000665","작성일자")%> : ('+isNull(data.created_dt)+')'+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000499","기안자")%> : '+isNull(data.userName)+ '<br>';
				tag += isNull(data.contents);
			}else if(eventSubType == "ED001"){
				tag += '<%=BizboxAMessage.getMessage("TX000000663","문서번호")%> : '+isNull(data.artNm)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("","작성자 : ")%>'+isNull(data.senderName);
				tag += isNull(data.empNo_v)+' '+isNull(data.posCd_v)+ '<br>';
				tag += '<%=BizboxAMessage.getMessage("TX000000756","업무분류")%> : '+isNull(data.dir_cd)+ '<br>';
			}else if(eventSubType == "BO001"){
				tag += isNull(data.content);
			}else if(eventSubType == "BO002"){
				tag += '<%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : '+isNull(data.project_name)+ '<br>';
				tag += isNull(data.content);
			}else if(eventSubType == "MA001"){
				var sContent = isNull(data.content);
				if(sContent != ""){
					if(sContent.length < 48)
						tag += "</br><%=BizboxAMessage.getMessage("TX000000145","내용")%> : " + sContent;
					else
						tag += "</br><%=BizboxAMessage.getMessage("TX000000145","내용")%> : " + sContent.substring(0,48) + "...";
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
			var week = new Array('<%=BizboxAMessage.getMessage("TX000006545","일요일")%>', '<%=BizboxAMessage.getMessage("TX000006546","월요일")%>', '<%=BizboxAMessage.getMessage("TX000006547","화요일")%>', '<%=BizboxAMessage.getMessage("TX000006548","수요일")%>', '<%=BizboxAMessage.getMessage("TX000006549","목요일")%>', '<%=BizboxAMessage.getMessage("TX000006550","금요일")%>', '<%=BizboxAMessage.getMessage("TX000000821","토요일")%>'); 
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
							contentStr = "<%=BizboxAMessage.getMessage("TX000010924","출근 가능시간이 아닙니다.　(출근 가능시간")%>".replace("　","\n")+" : " + inTime + ")";
						}
						if(type == "4"){
							contentStr = "<%=BizboxAMessage.getMessage("TX000010923","퇴근 가능시간이 아닙니다.　(퇴근 가능시간")%>".replace("　","\n")+" : " + outTime + ")";
						}
						
						Pudd.puddDialog({width:550, height:150, message:{type:"error", content:contentStr}});		    				
	    			}
	            },
	            error: function (e) {
	            }
	        });
		}
		
		function fnAttendConfirm(type){
			
			var contentStr;
			
			if(type == 1){
				contentStr = "<%=BizboxAMessage.getMessage("TX000010928","출근 체크 하시겠습니까?")%>";
			}
			else if(type == 4){
				contentStr = "<%=BizboxAMessage.getMessage("TX000010927","퇴근 체크 하시겠습니까?")%>";
			}
			
			// puddDialog 함수
			Pudd.puddDialog({
				width : 350
			,	height : 100
			,	modal : true		// 기본값 true
			,	draggable : false	// 기본값 true
			,	resize : false		// 기본값 false
			,	header : {
					title : "<%=BizboxAMessage.getMessage("TX000016109","출퇴근체크")%>"
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
						,	value : "<%=BizboxAMessage.getMessage("TX000019752","확인")%>"
						,	clickCallback : function( puddDlg ) {
								puddDlg.showDialog( false );
								// 추가적인 작업 내용이 있는 경우 이곳에서 처리
								fnAttendCheckProc(type);
							}
						}
					,	{
							attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
						,	value : "<%=BizboxAMessage.getMessage("TX000019660","취소")%>"
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
	            	   
	            	   Pudd.puddDialog({width:550, height:150, message:{type:"success", content:data.resultMessage}});			            	   
	            	   
	            	   if(type == "1"){
	            		   $("#portletTemplete_mybox_tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근")%></em> ' + attendDate + " " + '&nbsp;&nbsp;');
	            		   $("#portletTemplete_mybox_tab1").find("a").remove();   
	            	   }
	            	   else if(type == "4"){
	            		   $("#portletTemplete_mybox_tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근")%></em> ' + attendDate + " " + '&nbsp;&nbsp;');
	            		   $("#portletTemplete_mybox_tab2").find("a").remove();
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
		
		/* EBP CEO 포틀릿 랜더 함수 */
		function render_portletTemplete_assetGrowthIndex(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_assetGrowthIndex" ).val());
			//assetGrowthIndexChartContainer
			setTimeout(function(){
				Highcharts.chart('assetGrowthIndexChartContainer', {
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
			}, 500);
		}
		
		function render_portletTemplete_inventoryStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_inventoryStatus" ).val());
			setTimeout(function(){
				Highcharts.chart('inventoryStatusContainer', {
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
			},500)
		}
		
		function render_portletTemplete_bpNetProfit(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_bpNetProfit" ).val());
			setTimeout(function(){
				Highcharts.chart('bpNetProfitContainer', {
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
			},500)
		};
		
		function render_portletTemplete_boundAgeStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_boundAgeStatus" ).val());
			setTimeout(function(){
				var target = $("#portletTemplete_boundAgeStatusContainer");
				var portletHeight = target.parents(".ptl_content").height() - 40;
				
				if(target.parents("tr").width() != 0) {
					var portletWidth = target.parents("tr").width() - 152;
					target.width(portletWidth);
				}
								
				Highcharts.chart('portletTemplete_boundAgeStatusContainer', {
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
			        credits: {
			          enabled: false
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
		                	pointWidth: 11,
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
			},500)
			
		}
				
		function render_portletTemplete_salesPerformance(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesPerformance" ).val());
			setTimeout(function(){
				var target = $("#salesPerformanceContainer");
				
				var portletHeight = target.parents(".ptl_content").height() - 40;
				
				if(target.parents(".ac").width() != 0){
					var portletWidth = target.parents(".ac").width();
					target.width(portletWidth);
				}
				
				Highcharts.chart('salesPerformanceContainer', {
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
			}, 500)
			

		}
		
		function render_portletTemplete_totalFundStatus(portletInfo, targetDiv, portletKey) {
			$( targetDiv ).html($( "#portletTemplete_totalFundStatus" ).val());
		}
		
		function render_portletTemplete_wehagoService(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_wehagoService" ).val());
		}
		
		function render_portletTemplete_annualUseManage(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_annualUseManage" ).val());
			
			setTimeout(function(){
				var target = $("#portletTemplete_annualUseManageContainer");
				
				var portletHeight = target.parents(".ptl_content").height() - 17;
				
				if(target.parents("ptl_content").width() != 0) {
					var portletWidth = target.parents(".ptl_content").width() - 244;
					target.width(portletWidth);
				}
				
				Highcharts.chart('portletTemplete_annualUseManageContainer', {
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
				    credits: {
			          enabled: false
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
			},500);
		}
		
		function render_portletTemplete_weekWorkingHours(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_weekWorkingHours" ).val());
									
			setTimeout(function(){
				var portletHeight = $("#weekWorkingHoursContainer").parents(".ptl_content").height();
				Highcharts.chart('weekWorkingHoursContainer', {
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
				        	showInLegend: false,
				        	name: '남은근무',
				        	color: '#D6D6D6',
				        	y: 20
				        }
				        ]
				    }]
				});
			},500);
		}
		
		function render_portletTemplete_myWorkStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_myWorkStatus" ).val());
						
			setTimeout(function(){
				var target = $("#myWorkingStatusContainer");
				
				var portletHeight = target.parents(".ptl_content").height();				
				
				
				if(target.parents("ptl_content").width() != 0) {
					var portletWidth = target.parent("div").width() - 108;
					target.width(portletWidth);
				}
				
				Highcharts.chart('myWorkingStatusContainer', {
				  chart: {
				    type: 'column',
				    height: portletHeight
				  },
				  title: {
				    text: null
				  },
				  credits: {
			        enabled: false
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
			},500);
			
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
						
			setTimeout(function(){
				var portletHeight = $("#portletTemplete_divExpenseClaimContainer").parents(".ptl_content").height();
				
				var portletWidth = $("#portletTemplete_divExpenseClaimContainer").parents(".ptl_content").width() - 300;
				$("#portletTemplete_divExpenseClaimContainer").width(portletWidth);
				
				
				Highcharts.chart('portletTemplete_divExpenseClaimContainer', {
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
			}, 500)
			
		}


		function render_portletTemplete_accountingEaProgress(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_accountingEaProgress" ).val());
			
			setTimeout(function(){
				var portletHeight = $("#accountingEaProgressContainer").parents(".ptl_content").height();
				
				var portletWidth = $("#accountingEaProgressContainer").parents(".ptl_content").width() - 280;
				$("#accountingEaProgressContainer").width(portletWidth);
								
				Highcharts.chart('accountingEaProgressContainer', {
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
			},500);
		};


		function render_portletTemplete_mainAccountionTask(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_mainAccountionTask" ).val());
		};
		
		function render_portletTemplete_monthlySalesPerformance(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_monthlySalesPerformance" ).val());
			
			setTimeout(function(){ 
				CommonAreasplineGraph();}, 200);
		}
		
		function render_portletTemplete_salesStatus(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesStatus" ).val());
			
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
			
			setTimeout(function(){ 
				array.forEach(function(item) {
	                salesStatusGraph(item);
	   			 }); }, 200);
		}
		
		function render_portletTemplete_salesTrend(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesTrend" ).val());
		}
		
		function render_portletTemplete_myCardUsageHistory(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_myCardUsageHistory" ).val());
		}
		
		function render_portletTemplete_salesByDepartment(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_salesByDepartment" ).val());
			
			setTimeout(function(){ 
				CommonPieGraph(); 
			}, 200);
		}
		
		function render_portletTemplete_inboxCeo(portletInfo, targetDiv, portletKey){
			$( targetDiv ).html($( "#portletTemplete_inboxCeo" ).val());
		}
		
		function CommonPieGraph(){
			
			Highcharts.chart('salesByDepartment', {
				  chart: {
				    plotBackgroundColor: null,
				    plotBorderWidth: null,
				    plotShadow: false,
				    type: 'pie',
				    margin :[0,5,55,5]
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
		
		function CommonAreasplineGraph(){
			var target = $("#monthlySalesPerformance");
			
			var portletHeight = target.parents(".ptl_content").height() - 17;
			var portletWidth = target.parents("td").width() - 10;
			target.width(portletWidth);
			Highcharts.chart('monthlySalesPerformance', {
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
				    name: '2018년',
				    data: [item.Datas1],
				    color : '#f89e9c'
				  }, {
				    name: '2019년',
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
		
		/* WEHAGO 서비스 호출 함수 START */
		function wehagoService(target){
			serviceCode = target;
			
			var tblParam = {};
			
			$.ajax({
				type:"post",
			    url: "/gw/getSignature.do",
			    async: false,
			    dataType: 'json',
			    data: tblParam,
			    success: function(data) { 
			    	if(data.cno == ''){
		    			alert("wehago 연동되어있지 않습니다.");
		    		}else if(data.wehagoId == ''){
		    			openWindow2("/gw/systemx/wehagoLogin.do",  "wehagoSignInPop", 450, 200, 0, 0 );
		    		}else{
		    			wehagoId = data.wehagoId;
		    			cno = data.cno;
		    			getSSOToken(data);
		    		}
			    },
			    error: function(xhr) { 
			      console.log('FAIL : ', xhr);
			    }
		   });
		}
		
		function getSSOToken(data){
			
			var tblParam = {};
			tblParam.device_id = device_id;
			tblParam.token_sign = data.tokenSign;
			tblParam.cno = cno;
			
			$.ajax({
				type:"post",
			    url: "http://dev.api0.wehago.com/auth/temporarily/createToken",
			    data: tblParam,
			    dataType: 'json',
			    beforeSend : function(xhr){
		            xhr.setRequestHeader("signature", data.signature);
		            xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		        },
			    success: function(data) { 
			    	getWehagoServiceUrlInfo(data);
			    },
			    error: function(xhr) { 
			      console.log('FAIL : ', xhr);
			    }
		   });
		}
		
		function getWehagoServiceUrlInfo(data){
			
			var tblParam = {};
			tblParam.token = data.resultData.thirdparty_a_token;
			tblParam.wehagoId = wehagoId;
			tblParam.cno = cno;
			tblParam.serviceCd = serviceCode;
			tblParam.domain = domain;
			tblParam.softwareName = softwareName;
			
			$.ajax({
				type:"post",
			    url: "/gw/getWehagoServiceInfo.do",
			    async: false,
			    dataType: 'json',
			    data: tblParam,
			    success: function(data) { 
			    	wehagoServicePop(data);
			    },
			    error: function(xhr) { 
			      console.log('FAIL : ', xhr);
			    }
		   });
		}
		
		
		function wehagoServicePop(data){
			var url = "http://dev.wehago.com/#/sso/service?security_param=" + encodeURIComponent(data.security_param) + "&software_name=" + data.softwareName + "&domain=" + data.domain;
			window.open(url,"");
		}
		/* WEHAGO 서비스 호출 함수 END */
		
		/* 메뉴 이동 함수 START */
		function onclickTopMenu(moduleId, menuId){
			parent.window.parent.dews.ui.openMenu(moduleId, menuId);
		}
		/* 메뉴 이동 함수 END */
		
		/* EBP RENDER FUNCTION END */
	</script>

    <script>
    
		$(document).ready(function () {
			
			setTimeout(function(){
				$(".ScrollY").mCustomScrollbar({axis:"y",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
			},500);
			
			/*
			* CEO 포털일때 바디태그에 클래스를 추가한다.
			*/
			
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
			/*
			$(".portletDiv").css("visibility","visible");
			var aniTime = ['animated05s','animated1s','animated15s'];
			var delayTime = ['delay05s','delay1s','delay15s'];

			$.each( $(".portletDiv > div"), function( key, value ) {
				var randomTime = Math.round(( Math.ceil((Math.random() * 3)) % aniTime.length ));
				var random2Time = Math.round(( Math.ceil((Math.random() * 3)) % delayTime.length ));
				$(value).addClass("fadeIn").addClass(aniTime[randomTime]).addClass(delayTime[random2Time]);

		    	});
	
			setTimeout(function(){ $(".portletDiv > div").removeClass("fadeIn animated05s animated1s animated15s delay05s delay1s delay15s"); },3000);
			*/
		});
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
			                        <span class="txt"><%=BizboxAMessage.getMessage("TX000022368","알림전체") %></span>
			                        <span class="" id="alertNewIcon"></span>
			                        </a>
			                    </li>
			                    <li>
			                        <a href="#n" onclick="return false;" class="tab02">
			                        <span class="ico"></span>
			                        <span class="txt"><%=BizboxAMessage.getMessage("TX000021504","알파멘션") %></span>
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
				
				<textarea id="portletTemplete_inbox" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 style="cursor:pointer;" onclick="fnMailMain();" class="rm">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000001580","받은편지함")%></span>
						<a href="javascript:void(0)" class="more" onclick="onclickTopMenu('ML','MLAAAA00400');" title="<%=BizboxAMessage.getMessage("TX000018197","더보기")%>"></a>
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

					<h2 class="sc" onclick="javascript:onclickTopCustomMenu(300000000,'<%=BizboxAMessage.getMessage("TX000000483","일정")%>', '', '', '', 'N');" style="cursor:pointer;">
						<span name="portletTitle"><%=BizboxAMessage.getMessage("TX000000483","일정")%></span>
						<a href="#n" class="more" title="<%=BizboxAMessage.getMessage("TX000018197","더보기")%>"></a>
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
									<option value="total"><%=BizboxAMessage.getMessage("TX000010380","전체일정")%></option>
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
				
					<h2 class="sc" onclick="javascript:onclickTopCustomMenu(300000000,'<%=BizboxAMessage.getMessage("TX000000483","일정")%>', '', '', '', 'N');" style="cursor:pointer;">
						<span name="portletTitle">일정</span>
						<a href="#n" class="more" title="<%=BizboxAMessage.getMessage("TX000018197","더보기")%>"></a>
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
										<option value="total"><%=BizboxAMessage.getMessage("TX000010380","전체일정")%></option>
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
				
				<!-- EBP CEO PORTLET START -->
				<!-- 자산성장성지표 -->
				<textarea id="portletTemplete_assetGrowthIndex" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
				    	<div class="ptc_box2">
				        	<!-- 타이틀 영역 -->
				            <div class="tit_div" style="cursor:pointer" onclick="onclickTopMenu('FI','AACASR00400');">
				              <h2 class="">자산성장성지표 <span class="so">(단위:%)</span></h2>
				            </div>
				            <div class="pt_gr_ta2">
				            	<table>
				                	<tbody>
				                		<tr>
				                    		<td>
						                      <div id="assetGrowthIndexChartContainer" class="gr_div" style="width:200px;height:125px;">
						                        
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
			                      <div id="inventoryStatusContainer" class="gr_div" style="width:200px;height:125px;">
			                       
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
			            <div class="tit_div" style="cursor:pointer" onclick="onclickTopMenu('FI','GLDFSM00300');">
			              <h2 class="let1">경영실적[당기순이익] <span class="so">(단위:억원)</span></h2>
			            </div>
			            <div class="pt_gr_ta2">
			                <table>
			                  <tbody><tr>
			                    <td>
			                      <div id="bpNetProfitContainer" class="gr_div" style="width:220px;height:157px;margin-top:25px;">
			                        <!--이미지 스타일 넣은것은 시연용 개발시 삭제-->
			                      </div>
			                    </td>
			                  </tr>
			                </tbody></table>
			            </div>
			          </div><!--// ptc_box2 -->
					</div><!--//ptl_content -->
				</textarea>
				
				<!-- 총자금현황 -->
				<textarea id="portletTemplete_totalFundStatus" style="display:none;">
					<div class="ptl_content nocon">
						<div class="total_mn">
			                <div class="tmn_head">
			                  <h2 style="color:white; cursor:pointer;" onclick="onclickTopMenu('TR','TMFFPM00200');">총자금현황</h2>
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
				
				<!-- 채권연령현황 -->
				<textarea id="portletTemplete_boundAgeStatus" style="display:none;">
					<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptc_box2">
			            <!-- 타이틀 영역 -->
			  					<div class="tit_div">
			  						<h2 class="" style="cursor:pointer;" onclick="onclickTopMenu('FI','AREARC00400');">채권연령현황</h2>
			  					</div>
			            <div class="pt_gr_ta1">
			                <table>
			                  <colgroup>
			                    <col width="310">
			                    <col width="">
			                  </colgroup>
			                  <tbody><tr>
			                    <td class="ac">
			                      <div id="portletTemplete_boundAgeStatusContainer" class="gr_div" style="width:240px;height:156px;">
			                        
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
				
				<!-- WEHAGO 서비스 -->
				<textarea id="portletTemplete_wehagoService" style="display:none;">
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
		                          <a href="javascript:void(0);" onClick="wehagoService('communication2')">
		                            <span class="ico_div"></span>
									<span class="ico_bg"></span>
		                            <span class="txt_div">WE톡</span>
		                          </a>
		                        </li>
		                        <li class="kc">
		                          <a href="javascript:void(0);" onClick="wehagoService('expensepersonalcard')">
		                            <span class="ico_div"></span>
									<span class="ico_bg"></span>
		                            <span class="txt_div">경비청구</span>
		                          </a>
		                        </li>
		                        <li class="rt">
		                          <a href="javascript:void(0);" onClick="wehagoService('10mbook')">
		                            <span class="ico_div"></span>
									<span class="ico_bg"></span>
		                            <span class="txt_div">10분 독서</span>
		                          </a>
		                        </li>
		                        <li class="plus">
		                          <a href="javascript:void(0)" onClick="wehagoService('main')">
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
				<textarea id="portletTemplete_salesPerformance" style="display:none;">
						<div class="ptl_content nocon">
						<!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
				            <div class="ptc_box2">
				            <!-- 타이틀 영역 -->
							<div class="tit_div">
								<h2 class="" style="cursor:pointer;" onclick="onclickTopMenu('CO','CCACIA00100');">2018 매출실적현황</h2>
							</div>
				            <div class="pt_gr_ta1">
				                <table>
				                  <colgroup>
				                    <col width="240">
				                    <col width="">
				                  </colgroup>
				                  <tbody><tr>
				                    <td class="ac">
				                      <div id="salesPerformanceContainer" class="gr_div" style="width:210px;height:187px;">
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
				
				<!-- 공지사항 -->
				<textarea id="portletTemplete_board" style="display:none;">
					<div class="ptl_content nocon">
				    	<div class="ptc_box2">
				        <!-- 타이틀 영역 -->
				        	<div class="tit_div pb10" onclick="onclickTopMenu('BD','BDAAAA00100');">
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
				
				<!-- 임직원연차사용관리 -->
				<textarea id="portletTemplete_annualUseManage" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="wk" onclick="onclickTopMenu('HR','PAMESR02500');" style="cursor:pointer;">
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
					<h2 class="wt" onclick="onclickTopMenu('HR','PAMESR03100');" style="cursor:pointer;">
						<span>금주 근무시간</span>
					</h2>
					<div class="ptl_content">					
						<div id="weekWorkingHoursContainer" graph class="weektime"></div>
					</div>		
				</textarea>
				
				<!-- 나의 근무현황 -->
				<textarea id="portletTemplete_myWorkStatus" style="display:none;">
					<h2 class="ws">
						<span onclick="onclickTopMenu('HR','PAMODM00400');" style="cursor:pointer;">나의 근무현황</span>
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
								<div id="myWorkingStatusContainer" graph class="graph">
								
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
						<a href="javascript:void(0)" class="more" title="더보기" onclick="onclickTopMenu('HR','PAMAAH00200');"></a>
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
						<span class="ws_more"><a href="javascript:void(0)" class="more" title="더보기" onclick="onclickTopMenu('HR','PAMODM00700');">UC기획부</a></span>						
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
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
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
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
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
													<span class="divi_img"><img src="../../../Images/bg/pic_Noimg.png" alt="" /></span>	
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
							<a href="javascript:void(0)" onclick="onclickTopMenu('TR','TMFBDM00100');" class="link01">경비지출</a>
							<a href="javascript:void(0)" onclick="onclickTopMenu('HR','PAMCEM00200');" class="link03">재직증명서</a>
						</p>
						<p class="pt20">						
							<a href="javascript:void(0)" onclick="onclickTopMenu('HR','PBMPAR00200');" class="link03">급여내역조회</a>
							<a href="javascript:void(0)" onclick="onclickTopMenu('TX','TSMYET00100');" class="link04">개인연말정산</a>
						</p>
					</div>
				</textarea>
				
				<!-- 인사포틀릿(인사담당자) -->
				<textarea id="portletTemplete_board_hr" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="bd">
						<span>공지사항</span>
						<a href="javascript:void(0)" class="more" title="더보기" onclick="onclickTopMenu('BD','BDAAAA00100');"></a>
					</h2>
					<div class="ptl_content ScrollY">		
						<div class="exp_notice">
							<ul>
								<li class="new"><a href="#n">통근버스노선표안내 <img src="../../Images/ico/icon_new.png" class="mtImg" alt=""/></a></li>
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
						<span style="cursor:pointer;" onclick="onclickTopMenu('BM','NPBBES00600');">금일 주요 지출예정(06/01)</span>
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
					<h2 class="exp" style="cursor:pointer;" onclick="onclickTopMenu('TR','TMFFIO00200');">
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
					<h2 class="ea" style="cursor:pointer;" onclick="onclickTopMenu('EA','EAAAAB00200');">
						<span>회계결재 진행현황</span>
					</h2>
					<div class="ptl_content">
						<div class="exp_status">
							<p class="graph" id="accountingEaProgressContainer"></p>
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
					<h2 class="bd" style="cursor:pointer;" onclick="onclickTopMenu('BD','BDAAAC00100');">
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
				
				<!-- 나의카드 사용내역 포틀릿 --> 
				<textarea id="portletTemplete_myCardUsageHistory" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="cd" onclick="onclickTopMenu('TR','TMFBDM00200');" style="cursor:pointer">
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
				
				<!-- 부서별판매실적 포틀릿 -->
				<textarea id="portletTemplete_salesByDepartment" style="display:none;">
					<!-- 타이틀 영역 -->
					<h2 class="ws" onclick="onclickTopMenu('CR','MSTAOP00200');" style="cursor:pointer;">
						<span>부서별판매실적</span>
					</h2>
					<div class="ptl_content">		
						<div class="gr_div" style="width:100%;height:100%;" id="salesByDepartment" style="margin: 0 auto">
					  </div>
					</div>				
				</textarea>
				
				<!-- 매출액 추이 포틀릿 -->
				<textarea id="portletTemplete_salesTrend" style="display:none;">
						<!-- 타이틀 영역 -->
					<h2 class="ws" onclick="onclickTopMenu('CR','RPTSOA00300');" style="cursor:pointer">
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
				
				
				<!-- 월간판매실적 포틀릿 -->
				<textarea id="portletTemplete_monthlySalesPerformance" style="display:none;">
					<h2 class="ws" onclick="onclickTopMenu('CR','RPTSOA00200');" style="cursor:pointer;">
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
											<div id="monthlySalesPerformance" style="min-width: 310px; height: 160px; margin: 0 auto"></div>
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
						<span onclick="onclickTopMenu('FI','GLDFSM00300');" style="cursor:pointer">매출현황</span>
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
			                <h2 class="arr"><a href="javascript:void(0)">받은편지함</a></h2>
			              </div>
			            <!-- 컨텐츠 영역 :: 최초 컨텐츠 미설정 시 .ptl_content가 비어있으면  .nocon 클래스 생성-->
			            <div class="ptl_mail ScrollY " style="height:184px;">
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
				
				<!-- EBP CEO PORTLET END -->

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















