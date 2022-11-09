<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>



	<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">	    



<script type="text/javascript">

	var timelineSearchFlag = true;
	var timelineMoreYn = "${alertList.result.moreYn}";
	var timelineTimeStamp = "${alertList.result.timeStamp}";
	
	
	$(document).ready(function() {
		
		$.fn.hasScrollBar = function() {
		    return (this.prop("scrollHeight") == 0 && this.prop("clientHeight") == 0)
		            || (this.prop("scrollHeight") > this.prop("clientHeight"));
		};
		
    
		$('body').attr('class','timeline_bg');
		
    //컨텐츠를 클릭할때(컨텐츠에 타이틀도 포함)
		$(".list_con").on("click",function(){
			$(this).parent().removeClass("unread");
		});

	    //-----------------------------------------------------------------------//
		//타임라인
		timeLineUserSize();//타임라인 로드시 사이즈설정
			
		$(window).resize(function() {
			timeLineUserSize();//타임라인 로드시 리사이즈설정
		});
		//-----------------------------------------------------------------------//


		// 알림 스크롤 이벤트
		$(".timeline_box .m_pop_c2").scroll(function(){
			$(".tag_date2").css("top",$(this).scrollTop()+10);
			
			TagInAm();
			
			if((this.scrollTop+this.clientHeight) == this.scrollHeight){		    	
				//중복 조회를 방지하기위해 flag값 확인.
				if(timelineSearchFlag){
					timelineSearchFlag = false;
						fnAlertListAdd();	//추가조회
					}
			}
		});
		
		//스크롤 끝나면 이벤트
		$(".timeline_box .m_pop_c2").scrollEnd(function(){
			TagOutAm();
		},1000);
	
		setDetailInfo();
		setAlertNew();
		
		
		//알림 등록일자 표시형식 셋팅
		$(".date").each(function(){
			var str = $(this).attr("date");
			str = str.substring(0,4) + "." + str.substring(4,6) + "." + str.substring(6,8) + " " + str.substring(8,10) + ":" + str.substring(10,12);
			$(this).html(str);			
		});
		
		
		if($("#mentionNewIcon").css("display") == ""){
			$('.view_all a').removeClass('on'); //전체보기 on 리무브
			$("#isMention").addClass('on');
			$("#timelineList_ul").html("");
			timelineMoreYn = "Y";
			timelineTimeStamp = "0";
			fnAlertListAdd();
		}
		
	});
	
	//스크롤 에니메이션 실행
    function TagInAm(){
    	$(".tag_date2").removeClass("animated05s fadeOutLeft").addClass("animated05s fadeInLeft").show();
    };
    
    //스크롤 에니메이션 초기화
    function TagOutAm(){
    	$(".tag_date2").stop().removeClass("animated05s fadeInLeft").addClass("animated05s fadeOutLeft");
    };
    
    
    function setAlertNew(){
    	var alertCnt = "${alertCnt}";
    	var mentionCnt = "${alertMentionCnt}";
    	
    	if(alertCnt != "0")
    		$("#alertNewIcon").css("display","");
    	else
    		$("#alertNewIcon").css("display","none");
    	
    	if(mentionCnt != "0")
    		$("#mentionNewIcon").css("display","");
    	else
    		$("#mentionNewIcon").css("display","none");
    }

	    
	
	//타임라인 유저 높이셋팅
	function timeLineUserSize(){
		var posTarget = $('html'),
			topH = $('.header_wrap').height(),
		    posH = posTarget.height(),
		    conH = posH - topH;
		var mpH =$(".mp_head").height();
		    $('.tl_con_left').height(conH);
		    $('.tl_con_center .m_pop_c2').height(conH-15-mpH);
	}
	
	
	//타임라인 스크롤함수
	function timeLineNewCardScroll(t){
		var scTopNow = $('.tl_con_center .m_pop_c2').scrollTop(); //현재스크롤위치
		var newState = t;
		
		if(newState == 1){        // 사라짐
	        $('.new_timeline_card').stop().animate({height:0},200);
	        scHis = scTopNow;
	    }else if(newState == 2){    // 나타남
	        $('.new_timeline_card').stop().animate({height:30},200);
	        scHis = scTopNow;
	    }else{
	        if(Math.abs(scHis - scTopNow) > 160) scHis = scTopNow;
	    }
	}
	
	
	
	function setDetailInfo(){
		$(".mention_detail2").each(function(){		
			if($(this).attr("flag") == "false"){
				$(this).attr("flag","true");
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
			}
		});
		
		$(".sub_detail2").each(function(){
			fnSetDetailInfo(this);
		});
		
		$(".sub_detail2").removeClass("animated1s fadeIn").toggleClass("animated1s fadeIn").show();
		$(".mention_detail2").removeClass("animated1s fadeIn ellipsis").toggleClass("animated1s fadeIn");
		
		if($(".timelineDate").length == 0){
			var innerHtml = '<li class="dayline">';	
			innerHtml += "<%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다.")%>";
			innerHtml += '</li>';
			$("#timelineList_ul").html("");
			$("#timelineList_ul").append(innerHtml);
		}
	}
	
	
	
	function fnSetDetailInfo(e){
		try{
			if($(e).attr("isCheckFlag") == "false"){
				$(e).attr("isCheckFlag","true");
				var data = JSON.parse($(e).attr("data"));
				var eventType = $(e).attr("eventType");
				var eventSubType = $(e).attr("eventSubType");
				var alertId = $(e).attr("alertId");
				var tag = "";
				
				if(eventSubType == "PR001"){
					tag += '<table class="text_list"><tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : </span>';
					tag += '<span id="" class="fl ml5">'+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.prjDays)+')</span></td></tr>';
					tag += '<tr><td><span class="fl">PM : </span><span id="" class="fl ml5"><span class="fwb">'+isNull(data.pmEmpName)+'</span> '+isNull(data.pmPositionName)+'</span></td></tr>';
					tag += '<tr><td><span class="fl imp_tit"><%=BizboxAMessage.getMessage("TX000000758","중요도")%> : </span><span id="" class="fl ml5 star'+data.importDegree+'"></span></td></tr>';
					tag += '<tr><td><span class="fl type_tit"><%=BizboxAMessage.getMessage("TX000006753","진행률")%> : </span><span id="" class="fl ml5">'+isNull(data.processRate);
					tag += '<span class="type_blue">'+isNull(data.prjStatus)+'</span></span></td></tr></table>';
					tag += '<p class="text_box3line">'+isNull(data.dcRmk)+'</p>';
				}else if(eventSubType == "PR011"){
					tag += '<table class="text_list">';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : </span><span id="" class="fl ml5">'+isNull(data.prjName)+'</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : </span><span id="" class="fl ml5">'+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.workDays)+')</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000329","담당자")%> : </span><span id="" class="fl ml5"><span class="fwb">'+isNull(data.ownerEmpName)+'</span> '+isNull(data.ownerDutyName)+'</span></td></tr>';
					tag += '<tr><td><span class="fl type_tit"><%=BizboxAMessage.getMessage("TX000006753","진행률")%> : </span><span id="" class="fl ml5">'+isNull(data.processRate)+'<span class="type_blue">'+isNull(data.workStatus)+'</span></span></td></tr>';
					tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>';
				}else if(eventSubType == "PR013"){
					tag += '<table class="text_list">';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : </span><span id="" class="fl ml5">'+isNull(data.prjName)+'</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000012430","업무명")%> : </span><span id="" class="fl ml5">'+isNull(data.workName)+'</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : </span><span id="" class="fl ml5">'+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.jobDays)+')</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000329","담당자")%> : </span><span id="" class="fl ml5"><span class="fwb">'+isNull(data.ownerJobedEmpName)+'</span> '+isNull(data.ownerJobedDutyName)+'</span></td></tr>';
					tag += '<tr><td><span class="fl type_tit"><%=BizboxAMessage.getMessage("TX000006753","진행률")%> : </span><span id="" class="fl ml5">'+isNull(data.processRate)+'<span class="type_blue">'+isNull(data.jobStatus)+'</span></span></td></tr>';
					tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>';
				}else if(eventSubType == "SC001"){
					tag += '<table class="text_list">';
					
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000720","참여자")%> : </span><span id="" class="fl ml5">';
					
					if(data.schUserList != null){
						var eList = data.schUserList;
						var schUserList = "";
						for(var k=0; k<eList.length; k++) {
							if(k > 0){
								schUserList += ", ";
							}
							schUserList += eList[k].empName + " " + eList[k].dutyName;
						}
						
						tag += schUserList;
					}
					else{
						tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>';
					}
			
					tag += '</span></td></tr>';
					
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000007571","일시")%> : </span><span id="" class="fl ml5">'+isNull(data.startDate)+' ~ '+isNull(data.endDate)+'</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000752","장소")%> : </span><span id="" class="fl ml5">'+isNull(data.schPlace)+'</span></td></tr>';
					
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000012112","자원")%> : </span><span id="" class="fl ml5">';
					if(data.resList != null){
						var rList = data.resList;
						var resList = "";
						for(var l=0; l<rList.length; l++) {
							if(l > 0){
								resList += "<br>";
							}
							resList += '<img src="/gw/Images/ico/resources_ico_on.png" class="dp_ib" style="padding:0 5px 2px 0;" alt="">'+isNull(rList[l].resName);
						}
						
						tag += resList;
					}
					else{
						tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>';
					}
					tag += '</span></td></tr>';
					
					tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>';
				}else if(eventSubType == "RS001"){
					tag += '<table class="text_list">';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000286","사용자")%> : </span><span id="" class="fl ml5">';
					
					if(data.resUserList != null){
						var uList = data.resUserList;
						var userList = "";
						for(var l=0; l<uList.length; l++) {
							if(l > 0){
								userList += ", ";
							}
							userList += isNull(uList[l].empName);
						}
						
						tag += userList;
					}
					else{
						tag += '<%=BizboxAMessage.getMessage("TX000001232","없음")%>';
					}
					tag += '</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000012157","예약기간")%> : </span><span id="" class="fl ml5">'+isNull(data.startDate)+' ~ '+isNull(data.endDate)+'</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000012088","자원명")%> : </span><span id="" class="fl ml5"><span class="fwb">'+isNull(data.resList)+'</span></td></tr>';
					tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>';
				}else if(eventSubType == "RP001"){
					if(data.onefficeYn != "Y"){
						tag += '<table class="text_list">';
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000802","보고일자")%> : </span><span id="" class="fl ml5">'+isNull(data.reportDate)+'</span></td></tr>';
						
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000006607","주요일정")%> : </span><ol id="" class="fl ml20 ol_list">';
						if(data.majorSchedules != null){
							var msList = data.majorSchedules;
							var majorSchedules = "";
							for(var k=0; k<msList.length; k++) {
								majorSchedules += '<li class="pb5">'+msList[k].content+'</li>';
							}
							
							tag += majorSchedules;
						}
						else{
							tag += '<li class="pb5"><%=BizboxAMessage.getMessage("TX000001232","없음")%></li>';
						}
						tag += '</ol></td></tr>';
						
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000672","주요업무")%> : </span><ol id="" class="fl ml20 ol_list">';
						if(data.majorWorks != null){
							var mwList = data.majorWorks;
							var majorWorks = "";
							for(var l=0; l<mwList.length; l++) {
								majorWorks += '<li class="pb5">'+mwList[l].content+'</li>';
							}
							
							tag += majorWorks;
						}
						else{
							tag += '<li class="pb5"><%=BizboxAMessage.getMessage("TX000001232","없음")%></li>';
						}
						tag += '</ol></td></tr>';
						
						tag += '</table>';
					}
				}else if(eventSubType == "RP002"){
					if(data.onefficeYn != "Y"){
						tag += '<div class="con_div_contents"><table class="text_list">';
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000802","보고일자")%> : </span><span id="" class="fl ml5">'+isNull(data.reportDate)+'</span></td></tr>';
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000006610","보고사항")%> : </span><p class="fl mt5 dp_ib text_box3line">'+isNull(data.reportContent)+'</p></td></tr>';
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000002910","특이사항")%> : </span><p class="fl mt5 dp_ib text_box3line">'+isNull(data.note)+'</p></td></tr>';
						tag += '</table>';
					}
				}else if(eventSubType == "RP003"){
					if(data.onefficeYn != "Y"){
						tag += '<table class="text_list">';
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000802","보고일자")%> : </span><span id="" class="fl ml5">'+isNull(data.reportDate)+'</span></td></tr>';
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000006610","보고사항")%> : </span><p class="fl mt5 dp_ib text_box3line">'+isNull(data.reportContent)+'</p></td></tr>';
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000002910","특이사항")%> : </span><p class="fl mt5 dp_ib text_box3line">'+isNull(data.note)+'</p></td></tr>';
						tag += '</table>';
					}
				}else if(eventSubType == "EA101"){
					tag += '<table class="text_list">';
					if(isNull(data.doc_no) != ""){
						tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000018380","품의번호")%> : </span><span id="" class="fl ml5">'+isNull(data.doc_no)+'</span></td></tr>';
					}
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000665","작성일자")%> : </span><span id="" class="fl ml5">('+isNull(data.created_dt)+')</span></td></tr>';
<%-- 					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000500","기안부서")%> : </span><span id="" class="fl ml5">'+isNull(data.deptName)+'</span></td></tr>'; --%>
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000499","기안자")%> : </span><span id="" class="fl ml5">'+isNull(data.userName)+'</span></td></tr>';
					tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>';
				}else if(eventSubType == "ED001"){
					tag += '<table class="text_list">';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000663","문서번호")%> : </span><span id="" class="fl ml5">'+isNull(data.artNm)+'</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX900000354","작성자 : ")%></span><span id="" class="fl ml5">'+isNull(data.senderName)+' <span class="fwb">';
					tag += isNull(data.empNo_v)+'</span> '+isNull(data.posCd_v)+'</span></td></tr>';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000756","업무분류")%> : </span><span id="" class="fl ml5">'+isNull(data.dir_cd)+'</span></td></tr>';
					tag += '</table>';
				}else if(eventSubType == "BO001"){
					tag += '<table class="text_list">';
					tag += '</table><p class="text_box3line">'+isNull(data.content)+'</p>';
				}else if(eventSubType == "BO002"){
					tag += '<table class="text_list">';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : </span><span id="" class="fl ml5">'+isNull(data.project_name)+'</span></td></tr>';
					tag += '</table><p class="text_box3line">'+isNull(data.content)+'</p>';
				}else if(eventSubType == "MA001"){
					tag += '<table class="text_list">';
					tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000001641","보낸사람")%> : </span><span id="" class="fl ml5">'+isNull(data.sendName)+'('+isNull(data.sendEmail)+')</span></td></tr>';
					tag += '</table><p class="text_box3line">'+isNull(data.content)+'</p>';
				}
				
				$(e).html(tag);
			}
		}catch(exception){
			console.log(exception);//오류 상황 대응 부재
		}
	}
	
	//null값 체크(''공백 반환)
	function isNull(obj){
		return (typeof obj != "undefined" && obj != null) ? obj : "";
	}
	
	
	function fnSetCurDateTimeline(e){
		var strDate = $(e).attr("date");
		strDate = strDate.substring(0,8);		

		var week = new Array('<%=BizboxAMessage.getMessage("TX000017876","일")%>', '<%=BizboxAMessage.getMessage("TX000017875","월")%>', '<%=BizboxAMessage.getMessage("TX000017877","화")%>', '<%=BizboxAMessage.getMessage("TX000017878","수")%>', '<%=BizboxAMessage.getMessage("TX000017879","목")%>', '<%=BizboxAMessage.getMessage("TX000017880","금")%>', '<%=BizboxAMessage.getMessage("TX000017881","토")%>');
		
		var year = strDate.substr(0,4);
		var month = strDate.substr(4,2);
		var day = strDate.substr(6,2);	
		
		var dateTime = year + "-" + month + "-" + day;
		
		var varDate = new Date(dateTime);  // date로 변경

		$("#curDateTimeline").html(year + "-" + month + "-" + day + " (" + week[varDate.getDay()] + ")");		
	}
	
	
	
	
	function setTimeLineList(e){
		var targetEventType = $(e).attr("eventType");
		var targetMentionYn = "";
		var isCheck = $(e).hasClass("on");
		if($("#isAll").hasClass("on"))
			targetMentionYn = "N";
		else
			targetMentionYn = "Y";
		
// 		if(targetMentionYn == "N"){
// 			$(".checkFlag").each(function(){
// 				var eventType = $(this).attr("eventType");	
// 				if(isCheck){
// 					if(targetEventType == "mail" && eventType == "MAIL"){
// 						$(this).css("display","");
// 					}else if((targetEventType == "msg" && eventType == "TALK") || (targetEventType == "msg" && eventType == "MESSAGE")){
// 						$(this).css("display","");
// 					}else if(targetEventType == "ea" && eventType == "EAPPROVAL"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "fax" && eventType == "FAX"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "sc" && eventType == "SCHEDULE"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "wk" && eventType == "REPORT"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "bd" && eventType == "BOARD"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "dc" && eventType == "EDMS"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "wkr" && eventType == "REPORT"){
// 						$(this).css("display","");
// 					}else{
// 						$(this).css("display","none");
// 					}
// 				}else{
// 					$(this).css("display","");
// 				}
// 			});
// 		} else if(targetMentionYn == "Y"){
// 			$(".checkFlag").each(function(){
// 				var eventType = $(this).attr("eventType");
// 				var mentionYn = $(this).attr("mentionYn");
				
// 				if(isCheck){
// 					if(targetEventType == "mail" && eventType == "MAIL" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else if((targetEventType == "msg" && eventType == "TALK" && mentionYn == "Y") || (targetEventType == "msg" && eventType == "MESSAGE" && mentionYn == "Y")){
// 						$(this).css("display","");
// 					}else if(targetEventType == "ea" && eventType == "EAPPROVAL" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "fax" && eventType == "FAX" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "sc" && eventType == "SCHEDULE" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "wk" && eventType == "REPORT" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "bd" && eventType == "BOARD" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "dc" && eventType == "EDMS" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else if(targetEventType == "wkr" && eventType == "REPORT" && mentionYn == "Y"){
// 						$(this).css("display","");
// 					}else{
// 						$(this).css("display","none");
// 					}
// 				}else{
// 					if(mentionYn == "Y")
// 						$(this).css("display","");
// 					else
// 						$(this).css("display","none");
// 				}
// 			});
// 		}
		
		
				
		
	}
	
	
	function setTimeLineListMentionYn(){
		var cnt = 0;
		$(".checkClass").each(function(){
			if($(this).hasClass("on")){
				setTimeLineList(this);
			}
			else{
				cnt++;
				if($(".checkClass").length == cnt){
					setTimeLineList(this);
				}
			}
		});
	}
	
	
	
	
	
	function fnAlertListAdd(){
		
		var sTimeStamp = "";
		
		if(timelineMoreYn != "Y"){
			timelineSearchFlag = true;
			return false;
		}				
		sTimeStamp = timelineTimeStamp;		
		
		var tblParam = {};				
		tblParam.timeStamp = sTimeStamp;
		if($("#isMention").hasClass("on"))
			tblParam.mentionYn = "Y";
		
		if($('.checkClass.targetType.on').length == 1){
			tblParam.eventType = $('.checkClass.targetType.on').attr("target");
		}

		
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/alertAddInfo.do"/>',
			data: tblParam,
			datatype:"json",			  
			success:function(data){		
				timelineSearchFlag = true;
				
				var result = JSON.parse(data.alertList);

				timelineMoreYn = result.result.moreYn;
				timelineTimeStamp = result.result.timeStamp;

				setTimelineTable(result);
				
				$(".list_con").on("click",function(){
					$(this).parent().removeClass("unread");
				});
			}  
		});
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	function setTimelineTable(result){
			
			var innerHtml = "";
			var alertList = result.result.alertList;
			var alertDate = "";			
			var dateStr = "";
			
			
			var targetEventType = "";
			
			$(".targetType").each(function(e){
				if($(this).hasClass("on"))
					targetEventType = $(this).attr("eventType");
			});
			
			for(var i=0;i<alertList.length;i++){
				
				var innerHtml = "";
				var dateTarget = "timelineDate";
				
			
				$("." + dateTarget).each(function(){
					var strTmp = $(this).attr("date");
					strTmp = strTmp.substring(0, 8);
					if(dateStr == "")
						dateStr = strTmp;
					else{
						if(strTmp < dateStr)
							dateStr = strTmp;
					}				
				});		
				
				if(dateStr != alertList[i].createDate.substring(0,8)){
					var strDate = alertList[i].createDate.substring(0,8);
					var week = new Array('<%=BizboxAMessage.getMessage("TX000017876","일")%>', '<%=BizboxAMessage.getMessage("TX000017875","월")%>', '<%=BizboxAMessage.getMessage("TX000017877","화")%>', '<%=BizboxAMessage.getMessage("TX000017878","수")%>', '<%=BizboxAMessage.getMessage("TX000017879","목")%>', '<%=BizboxAMessage.getMessage("TX000017880","금")%>', '<%=BizboxAMessage.getMessage("TX000017881","토")%>');
					
					var year = strDate.substr(0,4);
					var month = strDate.substr(4,2);
					var day = strDate.substr(6,2);	
					
					var dateTime = year + "-" + month + "-" + day;
					
					var varDate = new Date(dateTime);  // date로 변경					

					innerHtml += '<li class="dayline timelineDate" date="' + alertList[i].createDate + '">';	
					innerHtml += year + "-" + month + "-" + day + " (" + week[varDate.getDay()] + ")";					
					innerHtml += '</li>';
				} 
				
				
				if(alertList[i].readDate == null || alertList[i].readDate == ""){
					innerHtml += "<li class='unread checkFlag " + alertList[i].alertId + "' onmouseover='fnSetCurDateTimeline(this)' date='" + alertList[i].createDate + "' eventType='" + alertList[i].eventType + "' eventSubType='" + alertList[i].eventSubType + "' mentionYn='" + alertList[i].mentionYn + "'>";
				}else{
					innerHtml += "<li class='checkFlag' onmouseover='fnSetCurDateTimeline(this)' date='" + alertList[i].createDate + "' eventType='" + alertList[i].eventType + "' eventSubType='" + alertList[i].eventSubType + "' mentionYn='" + alertList[i].mentionYn + "'>";
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
					innerHtml += '<div class="icon mail"></div>';
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
				
				if(alertList[i].eventType != "MAIL"){
					innerHtml += '<div class="list_con" onclick="forwardPageByAlert(\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\',\'' + alertList[i].eventType + '\',\'' + alertList[i].eventSubType + '\',\'' + alertList[i].senderSeq + '\', this);" data=\'' + alertList[i].data + '\', this>';
				}else{
					innerHtml += '<div class="list_con" onclick="fnMailMove(\'' + alertList[i].mailUid + '\',\'' + alertList[i].email + '\',\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\')" data=\'' + alertList[i].data + '\'>';
				}
					
				innerHtml += '<a href="#n" onclick="return false;" class="title" title="' + alertList[i].message.alertTitle + '">';
				innerHtml += alertList[i].message.alertTitle + '</a>';
					
				
//	 			innerHtml += '<dl><dt>' + alertList[i].message.alertTitle + '</dt><dd class="sub_detail">' + alertList[i].message.alertContent + '</dd></dl>';
				
				

					innerHtml += '<dl>';
					innerHtml += '<dd class="mention_detail2 ellipsis" data=\'' + alertList[i].data + '\' flag="false" eventSubType="' + alertList[i].eventSubType + '">';
					innerHtml += '<p style="display: none;">' + alertList[i].message.alertContent + '</p>';
					innerHtml += '<span class="msg"></span>';
					innerHtml += '' + alertList[i].message.alertContent + '';
					if(alertList[i].message.alertContent.length >= 300){
						innerHtml += '<a href="#n" onclick="return false;" class="more_btn"> 상세보기</a>';
					}					
					innerHtml += '</dd>';
					innerHtml += '</dl>';
	
				

				
				//알림 등록일자 표시형식 셋팅
				var str = alertList[i].createDate;
				str = str.substring(0,4) + "." + str.substring(4,6) + "." + str.substring(6,8) + " " + str.substring(8,10) + ":" + str.substring(10,12);
				
				innerHtml += '</div>';
				innerHtml += "<div class='list_fn' data='" + alertList[i].data + "' eventType='" + alertList[i].eventType + "' eventSubType='" + alertList[i].eventSubType + "' alertId='" + alertList[i].alertId + "' moreYn='" + alertList[i].moreYn + "'>";
				innerHtml += '<span class="date" date="' + alertList[i].createDate + '">' + str + '</span>';
//	 			if(alertList[i].moreYn == "Y" || alertList[i].message.alertContent.length > 54){
//	 				innerHtml += "<a href=\"#n\" onclick=\"fnToggleBtnClick(this);\" class=\"toggle_btn\" id=\"toggleBtn_" + alertList[i].alertId + "\" data='" + alertList[i].data + "' eventType='" + alertList[i].eventType + "' eventSubType='" + alertList[i].eventSubType + "' alertId='" + alertList[i].alertId + "' flag='false'></a>";
//	 			}
				innerHtml += '</div>';
				innerHtml += '</li>';
				
				
				if(targetEventType == "mail" && alertList[i].eventType == "MAIL"){
					$("#timelineList_ul").append(innerHtml);
				}else if((targetEventType == "msg" && alertList[i].eventType == "TALK") || (targetEventType == "msg" && alertList[i].eventType == "MESSAGE")){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == "ea" && alertList[i].eventType == "EAPPROVAL"){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == "fax" && alertList[i].eventType == "FAX"){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == "sc" && alertList[i].eventType == "SCHEDULE"){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == "wk" && alertList[i].eventType == "REPORT"){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == "bd" && alertList[i].eventType == "BOARD"){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == "dc" && alertList[i].eventType == "EDMS"){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == "wkr" && alertList[i].eventType == "REPORT"){
					$("#timelineList_ul").append(innerHtml);
				}else if(targetEventType == ""){
					$("#timelineList_ul").append(innerHtml);
				}					
			}
			
			setDetailInfo();
			setTimeLineListMentionYn();
			
			
			if(timelineMoreYn == "Y" && !$(".timeline_box .m_pop_c2").hasScrollBar()){
				fnAlertListAdd();
			}
	}

	
	//전체읽음
	function timeLineallRead(){
		
		if(!confirm('<%=BizboxAMessage.getMessage("TX000015831","모든 알림을 읽음 처리할까요?")%>')){
			return;
		}
		
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/alertReadAll.do"/>',
			datatype:"json",			  
			success:function(data){
				if(data.result.resultMessage == "SUCCESS"){		
					$(".m_pop_c ul li").removeClass("unread");
					$(".m_pop_c2 ul li").removeClass("unread");
					$("#alertCnt").attr("class", "");
					$("#alertCnt").html("");		
					$("#newIcon").removeClass("new");
					$("#newMentionIcon").removeClass("new");
			    	$("#alertNewIcon").css("display","none");
			    	$("#mentionNewIcon").css("display","none");
				}else{
					alert("<%=BizboxAMessage.getMessage("TX900000349","모든 알림 읽음 처리 도중 오류가 발생하였습니다.\\n관리자에게 문의바랍니다.")%>");
				}
			},error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			}  
		});		
	}
	
	
	function fnTabClick(target){
		if(target == "A"){
			$("#allReadButton").css("display","");
		}
		else if(target == "M"){
			$("#allReadButton").css("display","none");
		}
	}

</script>

<!-- main timeline 콘텐츠 영역 -->
<div class="main_timeline_wrap">
		
	<div class="tl_con_left">
		<!-- 전체보기 -->
		<div class="view_all">
			<ul><!-- icon_new아이콘 유무 -->
				<li><a href="#n" class="on" id="isAll" onclick="fnTabClick('A');"><%=BizboxAMessage.getMessage("TX000003952","전체보기")%><img src="/gw/Images/ico/icon_new.png" alt="" style="display: none;" id="alertNewIcon"/></a></li>
				<li class="cen">|</li>
				<li><a href="#n" class="" id="isMention" onclick="fnTabClick('M');"><%=BizboxAMessage.getMessage("TX000021504","알파멘션")%><img src="/gw/Images/ico/icon_new.png" alt="" style="display: none;" id="mentionNewIcon"/></a></li>
			</ul>
		</div>
		
		<!-- 상세보기 -->
		<div class="view_nav">
			<ul>
				<!-- li에 on 클래스 넣으면 활성화 -->
				<li class="tl_ico_1 checkClass targetType" eventType="wk" target="PROJECT"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000010151","업무관리")%>"><%=BizboxAMessage.getMessage("TX000010151","업무관리")%></a></li>
				<li class="tl_ico_2 checkClass targetType" eventType="mail" target="MAIL"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000000262","메일")%>"><%=BizboxAMessage.getMessage("TX000000262","메일")%></a></li>
				<li class="tl_ico_3 checkClass targetType" eventType="sc" target="SCHEDULE"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000000483","일정")%>"><%=BizboxAMessage.getMessage("TX000000483","일정")%></a></li>
				<li class="tl_ico_4 checkClass targetType" eventType="msg" target="TALK"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000007934","대화방")%>"><%=BizboxAMessage.getMessage("TX000007934","대화방")%></a></li>
				<li class="tl_ico_5 checkClass targetType" eventType="ea" target="EAPPROVAL"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>"><%=BizboxAMessage.getMessage("TX000000479","전자결재")%></a></li>
				<li class="tl_ico_6 checkClass targetType" eventType="bd" target="BOARD"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000011134","게시판")%>"><%=BizboxAMessage.getMessage("TX000011134","게시판")%></a></li>
				<li class="tl_ico_7 checkClass targetType" eventType="dc" target="DOC"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000018123","문서")%>"><%=BizboxAMessage.getMessage("TX000018123","문서")%></a></li>
<!-- 				<li class="tl_ico_8" eventType=""><a href="#n" id="" title="증명서">증명서</a></li> -->
<!-- 				<li class="tl_ico_9" eventType=""><a href="#n" id="" title="쪽지">쪽지</a></li> -->
				<li class="tl_ico_10 checkClass targetType" eventType="wkr" target="REPORT"><a href="#n" id="" title="<%=BizboxAMessage.getMessage("TX000006611","업무보고")%>"><%=BizboxAMessage.getMessage("TX000006611","업무보고")%></a></li>
			</ul>
		</div>
		<script>
			// 타임라인 nav on/off
			$(function() {
				$('.view_all a').on("click",function(){
					$('.view_all a').removeClass('on'); //전체보기 on 리무브
					$(this).addClass('on');
// 					setTimeLineListMentionYn();
					$("#timelineList_ul").html("");
					timelineMoreYn = "Y";
					timelineTimeStamp = "0";
					fnAlertListAdd();
				})
				
				$('.view_nav ul li').on("click",function(){		
					if(!$(this).hasClass('on')){
						$('.view_nav ul li').removeClass('on'); //상세보기 on 리무브					
						$(this).addClass('on');
					}else{
						$('.view_nav ul li').removeClass('on'); //상세보기 on 리무브
					}
// 					setTimeLineListMentionYn();
					$("#timelineList_ul").html("");
					timelineMoreYn = "Y";
					timelineTimeStamp = "0";
					fnAlertListAdd();
				})	
			});
		</script>
	</div>
	<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<div class="tl_con_center">
		
		<div class="timeline_box">
			<div class="mp_head">
				<input type="button" onclick="timeLineallRead()"value="<%=BizboxAMessage.getMessage("TX000007681","전체읽음")%>" id="allReadButton"/>
			</div>
			<div class="m_pop_box2" style=";">
			
			<div class="m_pop_c2 scroll_y_on">
				<!-- 알림전체 -->
				<div class="tabCon2">
					<ul id="timelineList_ul">
						<c:forEach items="${alertList.result.alertList}" var="list" varStatus="c">
							<c:if test="${division2 != fn:substring(list.createDate,0,8)}">
								<c:set var="division2" value="${fn:substring(list.createDate,0,8)}"/>
								<li class="dayline timelineDate" date="${list.createDate}">					
									<fmt:parseDate value="${division2}" var="dateFmt2" pattern="yyyyMMdd"/>
			      					<fmt:formatDate value="${dateFmt2}"  pattern="yyyy-MM-dd (E)"/>						
								</li>
							</c:if>			
							<li class="<c:if test="${empty list.readDate || list.readDate == 'null'}">unread</c:if> checkFlag ${list.alertId} isMention${list.mentionYn}" date="${list.createDate}" eventType="${list.eventType}" eventSubType="${list.eventSubType}" mentionYn="${list.mentionYn}" onmouseover="fnSetCurDateTimeline(this)">					
								<c:if test="${list.eventType == 'TALK' || list.eventType == 'MESSAGE'}">
									<div class="pic_wrap">
										<div class="pic"></div>
										<div class="div_img">							
											<img src="${profilePath}/${list.senderSeq}_thum.jpg?<%=System.currentTimeMillis()%>" onerror="this.src='/gw/Images/bg/mypage_noimg.png'" >
										</div>
									</div>
								</c:if>
								<c:if test="${list.eventType == 'PROJECT'}">
									<div class="icon sc"></div>
								</c:if>
								<c:if test="${list.eventType == 'MAIL'}">
									<div class="icon mail"></div>
								</c:if>
								<c:if test="${list.eventType == 'RESOURCE'}">
									<div class="icon mail"></div>
								</c:if>
								<c:if test="${list.eventType == 'REPORT'}">
									<div class="icon wkr"></div>
								</c:if>
								<c:if test="${list.eventType == 'EAPPROVAL'}">
									<div class="icon ea"></div>
								</c:if>
								<c:if test="${list.eventType == 'BOARD'}">
									<div class="icon bd"></div>
								</c:if>
								<c:if test="${list.eventType == 'EDMS'}">
									<div class="icon dc"></div>
								</c:if>
								<c:if test="${list.eventType == 'ATTEND'}">
									<div class="icon mail"></div>
								</c:if>
								<c:if test="${list.eventType == 'SCHEDULE'}">
									<div class="icon sc"></div>
								</c:if>
								<c:if test="${list.eventType == 'FAX'}">
									<div class="icon fax"></div>
								</c:if>
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								
								<!-- 내용 -->
								<c:if test="${list.eventType != 'MAIL'}">
									<div class="list_con" onclick="forwardPageByAlert('${list.url}','${list.alertId}','${list.eventType}','${list.eventSubType}','${list.senderSeq}', this);" data='${list.data}'>
								</c:if>
								<c:if test="${list.eventType == 'MAIL'}">
									<div class="list_con" onclick="fnMailMove('${list.mailUid}','${list.email}','${list.url}','${list.alertId}')" data='${list.data}'>
								</c:if>
									<a href="#n" onclick="return false;" class="title" title="${list.message.alertTitle}">
										${list.message.alertTitle}
									</a>

										<dl>											
											<dd class="mention_detail2 ellipsis" data='${list.data}' flag='false' eventSubType='${list.eventSubType}'>
												<p style="display: none;">${list.message.alertContent}</p>
												<span class="msg"></span> 
												${list.message.alertContent}																		
												<c:if test="${fn:length(list.message.alertContent) >= 300}">
													<a href="#n" onclick="return false;" class="more_btn"> <%=BizboxAMessage.getMessage("TX000006020","상세보기")%></a>
												</c:if>
											</dd>
										</dl>
								</div>
								<!-- 날짜 및 펼침버튼-->
								<div class="list_fn" data='${list.data}' eventType='${list.eventType}' eventSubType='${list.eventSubType}' alertId='${list.alertId}' moreYn='${list.moreYn}'>
									<span class="date" date="${list.createDate}"></span>
								</div>									
							</li>
						</c:forEach>
						
					</ul>
	
					<!-- 태그날짜 :: 사용자 스크롤 시 나타났다 사라지며, 날짜선을 기준으로  .tag_date_c의 값이 변경되어야 합니다. -->
					<div class="tag_date2">
						<span class="tag_date_l"></span>
						<span class="tag_date_c" id="curDateTimeline"></span>
						<span class="tag_date_r"></span>
					</div>
				
				</div> <!--// tabCon -->
				
				</div><!--// m_pop_c2 -->
				
				</div>
		</div>
		<!-- 새글있을때 -->
		<div class="new_timeline_card">
			<a href="#n" title="새로 업데이트된 타임라인이 있습니다" /><span class="ntc_txt"><%=BizboxAMessage.getMessage("TX900000355","새로 업데이트된 타임라인이 있습니다.")%></span></a>
		</div>
	</div>
	<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<div class="tl_con_right">

	</div>
	
</div>