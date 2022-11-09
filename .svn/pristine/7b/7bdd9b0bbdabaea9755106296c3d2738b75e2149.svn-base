<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="main.web.BizboxAMessage"%>
    
<script>

	var alertSearchFlag = true;
	var moreYn = "N";
	var mentionMoreYn = "N";
	var timeStamp = "";
	var mentionTimeStamp = "";
	
	$(document).ready(function() {
		moreYn = "${alertList.result.moreYn}";
		mentionMoreYn = "${mentionList.result.moreYn}";
		
		timeStamp = "${alertList.result.timeStamp}";
		mentionTimeStamp = "${mentionList.result.timeStamp}";
		//알림탭
		$(".alert_tab li").on("click",function(){
			var mapClass = $(this).children().attr("class");
			
			$(".alert_tab li").removeClass('on');
	   		$(this).addClass('on');
	   		$(".tabCon").hide();
	   		$("." + "_" + mapClass).removeClass("animated1s fadeInDown").toggleClass("animated1s fadeInDown").show();
		});
		
		
		var mapClass = $("#alertAll").children().attr("class");
		
		$(".alert_tab li").removeClass('on');
   		$("#alertAll").addClass('on');
   		$(".tabCon").hide();
   		$("." + "_" + mapClass).removeClass("animated1s fadeInDown").toggleClass("animated1s fadeInDown").show();
		
		
		//컨텐츠를 클릭할때(컨텐츠에 타이틀도 포함)
		$(".list_con").on("click",function(){
			$(this).parent().removeClass("unread");
		});
		
		
		// 알림 스크롤 이벤트
		$(".mention_alert_box .m_pop_c").scroll(function(){
			$(".tag_date").css("top",$(this).scrollTop()+10);
			
			TagInAm();
			
			if((this.scrollTop+this.clientHeight) == this.scrollHeight){		    	
				//중복 조회를 방지하기위해 flag값 확인.
				if(alertSearchFlag){
						alertSearchFlag = false;
						fnAlertAdd();	//추가조회
					}
			}		   
		});

		
		//스크롤 끝나면 이벤트
		$(".mention_alert_box .m_pop_c").scrollEnd(function(){
			TagOutAm();
		},1000);
		
		
		
		//알림 등록일자 표시형식 셋팅
		$(".date").each(function(){
			var str = $(this).attr("date");
			if(str != null){
				str = str.substring(0,4) + "." + str.substring(4,6) + "." + str.substring(6,8) + " " + str.substring(8,10) + ":" + str.substring(10,12);
				$(this).html(str);	
			}
		});
		
		
		fnSetMention();
		
		if($("#newMentionIcon").hasClass("new")){
			$("#tab01").css("display","none");
			$("#tab02").css("display","");
			
			if($("#alertAll").hasClass("on")){
				$("#allReadBtn").css("display","");
			}else{
				$("#allReadBtn").css("display","none");
			}
			
			$(".alert_tab li").removeClass('on');
			$("#alertAll").addClass('on');
			$(".tabCon").hide();
			$("." + "_tab02").removeClass("animated1s fadeInDown").toggleClass("animated1s fadeInDown").show();
			
			$("#mentionAlert").addClass("on");
			$("#alertAll").removeClass("on");
		}else{
			
			$("#alertCnt").html("");
			$("#alertCnt").attr("class","");
			
			if($(".alertDiv").length == 0){
				$("#noDate").css("display","");
			}else{
				$("#noDate").css("display","none");
			}
			
			$(".alert_tab li").removeClass('on');
			$("#alertAll").addClass('on');
			$(".tabCon").hide();
			$("." + "_tab01").removeClass("animated1s fadeInDown").toggleClass("animated1s fadeInDown").show();
		}
	});
	
	function fnSetMention(){
		$(".mention_detail").each(function(){
			if($(this).attr("flag") == "false"){
				$(this).attr("flag","true");
				var innerContents = $(this).html();		
				var data = $(this).attr("data");	
				data = JSON.parse(data);
				var eventSubType = $(this).attr("eventSubType");
				
				
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
		
		$(".list_fn").each(function(){			
			var alertId = $(this).attr("alertId");
			var data = $(this).attr("data");
			
			if(data != null){
				data = data.replace(/\'/gi,"&#39;");
				var eventType = $(this).attr("eventType");
				var eventSubType = $(this).attr("eventSubType");
				var moreYn = $(this).attr("moreYn");
				var text = $("#lengthFlag_" + alertId).text();
				var jsonData = JSON.parse(data);
				
				if(jsonData.onefficeYn != "Y"){
					if(($("#ellipsis_" + alertId).length > 0 && $("#ellipsis_" + alertId)[0].scrollWidth > $("#ellipsis_" + alertId).width()) || moreYn == "Y"){
						innerHtml = "<a href='#n' onclick='fnToggleBtnClick(this);' class='toggle_btn' id='toggleBtn_" + alertId + "' data='" + data + "' eventType='" + eventType + "' eventSubType='" + eventSubType + "' alertId='" + alertId + "' flag='false'></a>";
						$(this).append(innerHtml);
					}
				}			
			}
			
		});
		
		//컨텐츠를 클릭할때(컨텐츠에 타이틀도 포함)
		$(".list_con").on("click",function(){
			$(this).parent().removeClass("unread");
		});

	}
	
	function replaceAll(str, searchStr, replaceStr) {
	    return str.split(searchStr).join(replaceStr);
	}
	
	
	//전체읽음
	function allRead(){
		
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
	
	
	
	//펼쳐보기
	function allOpen(){		
		var chk = $("#allOpen"+":checkbox").is(":checked");
		
		if(chk==true){
			$(".toggle_btn").each(function(){
				fnSetDetailInfo(this);
			});	
			
			$(".sub_detail").removeClass("animated1s fadeIn").toggleClass("animated1s fadeIn").show();
			$(".mention_detail").removeClass("animated1s fadeIn ellipsis").toggleClass("animated1s fadeIn");
			$(".toggle_btn").addClass("down");
		}else{
			$(".sub_detail").removeClass("animated1s fadeIn").hide();
			$(".mention_detail").removeClass("animated1s fadeIn ellipsis").toggleClass("ellipsis");
			$(".toggle_btn").removeClass("down");
		}
	};
	
	//스크롤 에니메이션 실행
	function TagInAm(){
		$(".tag_date").removeClass("animated05s fadeOutLeft").addClass("animated05s fadeInLeft").show();
	};
	
	//스크롤 에니메이션 초기화
	function TagOutAm(){
		$(".tag_date").stop().removeClass("animated05s fadeInLeft").addClass("animated05s fadeOutLeft");
	};
	
	
	
	
	
	function fnAlertAdd(){
		var mentionYn = "";
		var sTimeStamp = "";
		
		if($("#alertAll").hasClass("on")){
			if(moreYn != "Y"){
				alertSearchFlag = true;
				return false;
			}				
			mentionYn = "N";
			sTimeStamp = timeStamp;
		}else{
			if(mentionMoreYn != "Y"){
				alertSearchFlag = true;
				return false;
			}				
			mentionYn = "Y";
			sTimeStamp = mentionTimeStamp;
		}
		
		
		var tblParam = {};
		tblParam.mentionYn = mentionYn;
		tblParam.timeStamp = sTimeStamp;
		
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/alertAddInfo.do"/>',
			data: tblParam,
			datatype:"json",			  
			success:function(data){		
				alertSearchFlag = true;
				
				var result = JSON.parse(data.alertList);
				
				if($("#alertAll").hasClass("on")){
					moreYn = result.result.moreYn;
					timeStamp = result.result.timeStamp;
				}else{
					mentionMoreYn = result.result.moreYn;
					mentionTimeStamp = result.result.timeStamp;
				}
				
				setAlertTable(result, mentionYn);
			}  
		});
	}
	
	
	function setAlertTable(result, mentionYn){
		var target = "";
		if(mentionYn == "Y"){
			target = "mentionList_Ul";
		}
		else{
			target = "alertList_Ul";
		}
		
		var innerHtml = "";
		var alertList = result.result.alertList;
		var alertDate = "";
		
		var dateStr = "";
		
		
		for(var i=0;i<alertList.length;i++){
			var innerHtml = "";
			var dateTarget = "";
			if(target == "mentionList_Ul")
				dateTarget = "menTionAllAlert";
			else
				dateTarget = "allAlert";
			
		
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

				
				
				if(mentionYn != "Y"){
					innerHtml += '<li class="dayline allAlert" date="' + alertList[i].createDate + '">';	
					innerHtml += year + "-" + month + "-" + day + " (" + week[varDate.getDay()] + ")";					
					innerHtml += '</li>';
				}else{
					innerHtml += '<li class="dayline menTionAllAlert" date="' + alertList[i].createDate + '">';	
					innerHtml += year + "-" + month + "-" + day + " (" + week[varDate.getDay()] + ")";					
					innerHtml += '</li>';
				}
			} 
			
			
			if(alertList[i].readDate == null || alertList[i].readDate == ""){
				innerHtml += "<li class='unread " + alertList[i].alertId + "' onmouseover='fnSetCurDate(this)' date='" + alertList[i].createDate + "'>";
			}else{
				innerHtml += "<li class='" + alertList[i].alertId + "' onmouseover='fnSetCurDate(this)' date='" + alertList[i].createDate + "'>";
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
			}else if(alertList[i].eventType == "ONEFFICE"){
				innerHtml += '<div class="icon of"></div>';
			}else if(alertList[i].eventType == "CUST"){
				innerHtml += '<div class="icon" style="background: url(/upload/img/custAlertIcon/' + alertList[i].eventType + '_' + alertList[i].eventSubType + '.png)"></div>';
			}
			
			if(alertList[i].webActionType != null && alertList[i].webActionType == "C"){
				innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>\');" data=\'' + alertList[i].data + '\'>';
			}else if(alertList[i].eventType != "MAIL"){						
				
				
				var alertData = JSON.parse(alertList[i].data); 
				if(alertList[i].eventType == "EAPPROVAL" && alertData.mobileViewYn == "N") {
					//전자결재 문서리스트 중 mobileViewYn값이 N이면 문서를 열람할 수 없다. 
					innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>\');" data=\'' + alertList[i].data + '\'>';						
				} else {
					innerHtml += '<div class="list_con" onclick="forwardPageByAlert(\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\',\'' + alertList[i].eventType + '\',\'' + alertList[i].eventSubType + '\',\'' + alertList[i].senderSeq + '\', this);" data=\'' + alertList[i].data + '\'>';
				}
				
			}else{
				innerHtml += '<div class="list_con" onclick="fnMailMove(\'' + alertList[i].mailUid + '\',\'' + alertList[i].email + '\',\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\')" data=\'' + alertList[i].data + '\'>';
			}
				
			innerHtml += '<a href="#n" onclick="return false;" class="title" title="' + alertList[i].message.alertTitle + '">';
			innerHtml += alertList[i].message.alertTitle + '</a>';
			
			if(alertList[i].eventType == 'TALK' || alertList[i].eventType == 'MESSAGE' || alertList[i].eventSubType == 'EA105' || alertList[i].eventSubType == "RP004" || alertList[i].eventSubType == 'PR005' || alertList[i].eventSubType == 'PR006' || alertList[i].eventSubType == 'PR007' || alertList[i].eventSubType == 'BO003' || alertList[i].eventSubType == 'BO004' || alertList[i].eventSubType == 'BO008' || alertList[i].eventSubType == 'BO009' || alertList[i].eventSubType == 'ED009' || alertList[i].eventSubType == 'ED010' || alertList[i].eventSubType == 'SC005' || alertList[i].eventSubType == 'ONE001'){			
				innerHtml += '<dl>';
				innerHtml += '<dd class="mention_detail ellipsis" id="ellipsis_' + alertList[i].alertId + '" data=\'' + alertList[i].data + '\' flag="false" eventSubType="' + alertList[i].eventSubType + '">';
				innerHtml += '<p id="lengthFlag_' + alertList[i].alertId +'" style="display: none;">' + alertList[i].message.alertContent + '</p>';
				innerHtml += '<span class="msg"></span>';
				innerHtml += '' + alertList[i].message.alertContent + '';
				if(alertList[i].message.alertContent.length >= 300){
					innerHtml += '<a href="#n" onclick="return false;" class="more_btn"> <%=BizboxAMessage.getMessage("TX000006020","상세보기")%></a>';
				}
				innerHtml += '<p style="display: none;" id="mentionDetailTitle_' + alertList[i].alertId +'">' + alertList[i].message.alertTitle + '</p>';
				innerHtml += '<p style="display: none;" id="mentionDetailContents_' + alertList[i].alertId +'">' + alertList[i].message.alertContent + '</p>';
				innerHtml += '</dd>';
				innerHtml += '</dl>';
			}
			
			else{
				innerHtml += '<dl>';
				innerHtml += '<dt>' + alertList[i].message.alertContent + '</dt>';
				innerHtml += '<dd class="sub_detail" id="subDetail_' + alertList[i].alertId +'">';
				innerHtml += '</dd>';
				innerHtml += '</dl>';
			}

			
			//알림 등록일자 표시형식 셋팅
			var str = alertList[i].createDate;
			str = str.substring(0,4) + "." + str.substring(4,6) + "." + str.substring(6,8) + " " + str.substring(8,10) + ":" + str.substring(10,12);
			
			innerHtml += '</div>';
			innerHtml += "<div class='list_fn' data='" + alertList[i].data + "' eventType='" + alertList[i].eventType + "' eventSubType='" + alertList[i].eventSubType + "' alertId='" + alertList[i].alertId + "' moreYn='" + alertList[i].moreYn + "'>";
			innerHtml += '<span class="date" date="' + alertList[i].createDate + '">' + str + '</span>';
			innerHtml += '</div>';
			innerHtml += '</li>';
			$("#" + target).append(innerHtml);	
		}
		fnSetMention();
	}
	
	
	function fnToggleBtnClick(e){
		$(e).toggleClass("down");
		$(e).parent().parent().find(".sub_detail").removeClass("animated1s fadeIn").toggleClass("animated1s fadeIn").toggle();
		
		//멘션 접고 펼치기
		if($(e).hasClass("down")){
			$(e).parent().parent().find(".mention_detail").removeClass("ellipsis").toggleClass("animated1s fadeIn");
		}else{
			$(e).parent().parent().find(".mention_detail").removeClass("animated1s fadeIn").toggleClass("ellipsis");
		}
		
		if($(e).attr("flag") == "false" || $(e).attr("flag") == false){
			fnSetDetailInfo(e);
			$(e).attr("flag", "true");
		}
	}
	
	function fnSetDetailInfo(e){
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
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : </span><span id="" class="fl ml5">'+isNull(data.startDate)+' ~ '+isNull(data.endDate)+'</span></td></tr>';
			tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>';
		}else if(eventSubType == "PR013"){
			<%-- tag += '<table class="text_list">';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : </span><span id="" class="fl ml5">'+isNull(data.prjName)+'</span></td></tr>';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000012430","업무명")%> : </span><span id="" class="fl ml5">'+isNull(data.workName)+'</span></td></tr>';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000015246","기간/일수")%> : </span><span id="" class="fl ml5">'+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.jobDays)+')</span></td></tr>';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000329","담당자")%> : </span><span id="" class="fl ml5"><span class="fwb">'+isNull(data.ownerJobedEmpName)+'</span> '+isNull(data.ownerJobedDutyName)+'</span></td></tr>';
			tag += '<tr><td><span class="fl type_tit"><%=BizboxAMessage.getMessage("TX000006753","진행률")%> : </span><span id="" class="fl ml5">'+isNull(data.processRate)+'<span class="type_blue">'+isNull(data.jobStatus)+'</span></span></td></tr>';
			tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>'; --%>
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
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000012088","자원명")%> : </span><span id="" class="fl ml5"><span class="fwb">'+isNull(data.resName)+'</span></td></tr>';
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
<%-- 			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000500","기안부서")%> : </span><span id="" class="fl ml5">'+isNull(data.deptName)+'</span></td></tr>'; --%>
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000499","기안자")%> : </span><span id="" class="fl ml5">'+isNull(data.userName)+'</span></td></tr>';
			tag += '</table><p class="text_box3line">'+isNull(data.contents)+'</p>';
		}else if(eventSubType == "ED001"){
			tag += '<table class="text_list">';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000663","문서번호")%> : </span><span id="" class="fl ml5">'+isNull(data.artNm)+'</span></td></tr>';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000637","등록자")%> : </span><span id="" class="fl ml5">'+isNull(data.senderName)+' <span class="fwb">';
			tag += isNull(data.empNo_v)+'</span> '+isNull(data.posCd_v)+'</span></td></tr>';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000756","업무분류")%> : </span><span id="" class="fl ml5">'+isNull(data.dir_cd)+'</span></td></tr>';
			tag += '</table>';
		}else if(eventSubType == "BO001"){
			tag += '<table class="text_list">';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000007887","게시판명")%> : </span><span id="" class="fl ml5">'+isNull(data.boardTitle)+'</span></td></tr>';
			tag += '</table><p class="text_box3line"><%=BizboxAMessage.getMessage("TX000000145","내용")%> : '+isNull(data.content)+'</p>';
		}else if(eventSubType == "BO002"){
			tag += '<table class="text_list">';
			tag += '<tr><td><span class="fl"><%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> : </span><span id="" class="fl ml5">'+isNull(data.project_name)+'</span></td></tr>';
			tag += '</table><p class="text_box3line">'+isNull(data.content)+'</p>';
		}else if(eventSubType == "MA001"){
			tag += '<table class="text_list">';
			
			if(isNull(data.content) != ""){
				tag += '</table></br><p class="text_box3line"><%=BizboxAMessage.getMessage("TX000000145","내용")%> : '+isNull(data.content)+'</p>';
			}else{
				tag += '</table>';
			}
		}
		
		$("#subDetail_" + alertId).html(tag);
		
	}
	
	//null값 체크(''공백 반환)
	function isNull(obj){
		return (typeof obj != "undefined" && obj != null) ? obj : "";
	}
	
	function fnSetCurDate(e){
		var strDate = $(e).attr("date");
		strDate = strDate.substring(0,8);		

		var week = new Array('<%=BizboxAMessage.getMessage("TX000017876","일")%>', '<%=BizboxAMessage.getMessage("TX000017875","월")%>', '<%=BizboxAMessage.getMessage("TX000017877","화")%>', '<%=BizboxAMessage.getMessage("TX000017878","수")%>', '<%=BizboxAMessage.getMessage("TX000017879","목")%>', '<%=BizboxAMessage.getMessage("TX000017880","금")%>', '<%=BizboxAMessage.getMessage("TX000017881","토")%>');
		var year = strDate.substr(0,4);
		var month = strDate.substr(4,2);
		var day = strDate.substr(6,2);	
		
		var dateTime = year + "-" + month + "-" + day;
		
		var varDate = new Date(dateTime);  // date로 변경

		$("#curDate").html(year + "-" + month + "-" + day + " (" + week[varDate.getDay()] + ")");		
		$("#curMentionDate").html(year + "-" + month + "-" + day + " (" + week[varDate.getDay()] + ")");
	}
</script>


<c:if test="${alertList.resultMessage == 'SUCCESS'}">
<div class="tabCon _tab01" id="tab01">	
		<ul id="alertList_Ul">
			<c:forEach items="${alertList.result.alertList}" var="list" varStatus="c">
				<c:if test="${division != fn:substring(list.createDate,0,8)}">
					<c:set var="division" value="${fn:substring(list.createDate,0,8)}"/>
					<li class="dayline allAlert" date="${list.createDate}">					
						<fmt:parseDate value="${division}" var="dateFmt" pattern="yyyyMMdd"/>
      					<fmt:formatDate value="${dateFmt}"  pattern="yyyy-MM-dd (E)"/>						
					</li>
				</c:if>					
				<li class="alertDiv <c:if test="${empty list.readDate || list.readDate == 'null'}">unread</c:if> ${list.alertId}" onmouseover="fnSetCurDate(this)" date="${list.createDate}">					
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
						<div class="icon sc"></div>
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
					<c:if test="${list.eventSubType == 'GW001'}">
						<div class="icon pass"></div>
					</c:if>
					<c:if test="${list.eventType == 'ONEFFICE'}">
						<div class="icon of"></div>
					</c:if>
					<c:if test="${list.eventType == 'CUST'}">
						<div class="icon" style="background: url(/upload/img/custAlertIcon/${list.eventType}_${list.eventSubType}.png)"></div>
					</c:if>
					
					<!-- 내용 -->
					<c:if test="${list.webActionType == 'C'}">
						<div class="list_con" onclick="alert('<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>');" data='${list.data}'>
					</c:if>
					<c:if test="${list.webActionType != 'C'}">
						<c:if test="${list.eventType != 'MAIL'}">
							<c:choose>
								<%-- 전자결재 알림중 mobileViewYn 값이 N이면 열람할 수 없다. --%>
								<c:when test="${list.eventType == 'EAPPROVAL' && list.mobileViewYn == 'N'}">
									<div class="list_con" onclick="alert('<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>');" data='${list.data}'>
								</c:when>
								<c:otherwise>
									<div class="list_con" onclick="forwardPageByAlert('${list.url}','${list.alertId}','${list.eventType}','${list.eventSubType}','${list.senderSeq}', this);" data='${list.data}'>
								</c:otherwise>
							</c:choose>						
						</c:if>
						<c:if test="${list.eventType == 'MAIL'}">
							<div class="list_con" onclick="fnMailMove('${list.mailUid}','${list.email}','${list.url}','${list.alertId}')" data='${list.data}'>
						</c:if>						
					</c:if>										
					
					<a href="#n" onclick="return false;" class="title" title="${list.message.alertTitle}">
						${list.message.alertTitle}
					</a>
					
					<c:choose>
						<c:when test="${list.eventType == 'TALK' || list.eventType == 'MESSAGE' || list.eventSubType == 'EA105' || list.eventSubType == 'RP004' || list.eventSubType == 'PR005' || list.eventSubType == 'PR006' || list.eventSubType == 'PR007' || list.eventSubType == 'BO003' || list.eventSubType == 'BO004' || list.eventSubType == 'BO008' || list.eventSubType == 'BO009' || list.eventSubType == 'ED009' || list.eventSubType == 'ED010' || list.eventSubType == 'SC005' || list.eventSubType == 'ONE001'}">
							<dl>					
								<dd class="mention_detail ellipsis" id="ellipsis_${list.alertId}" data='${list.data}' flag='false' eventSubType='${list.eventSubType}'>
									<p id="lengthFlag_${list.alertId}" style="display: none;">${list.message.alertContent}</p>
									<span class="msg"></span> 
									${list.message.alertContent}																		
									<c:if test="${fn:length(list.message.alertContent) >= 300}">
										<a href="#n" onclick="return false;" class="more_btn"> 상세보기</a>
									</c:if>
									<p style="display: none;" id="mentionDetailTitle_${list.alertId}">${list.message.alertTitle}</p>
									<p style="display: none;" id="mentionDetailContents_${list.alertId}">${list.message.alertContent}</p>
								</dd>
							</dl>
						</c:when>
						<c:otherwise>
							<dl>
								<dt>${list.message.alertContent}</dt>
								<dd class="sub_detail" id="subDetail_${list.alertId}">
									
								</dd>
							</dl>
						</c:otherwise>
					</c:choose>					
						
					</div>
					<!-- 날짜 및 펼침버튼-->
					<div class="list_fn" data='${list.data}' eventType='${list.eventType}' eventSubType='${list.eventSubType}' alertId='${list.alertId}' moreYn='${list.moreYn}'>
						<span class="date" date="${list.createDate}"></span>
					</div>									
				</li>
			</c:forEach>
		</ul>
		<div class="tag_date">
			<span class="tag_date_l"></span>
			<span class="tag_date_c" id="curDate"></span>
			<span class="tag_date_r"></span>
		</div>	
</div>
</c:if>	
<c:if test="${mentionList.resultMessage == 'SUCCESS'}">
<div class="tabCon _tab02" style="" id="tab02">	
		<ul id="mentionList_Ul">
			<c:forEach items="${mentionList.result.alertList}" var="list" varStatus="c">
				<c:if test="${Mdivision != fn:substring(list.createDate,0,8)}">
					<c:set var="Mdivision" value="${fn:substring(list.createDate,0,8)}"/>
					<li class="dayline menTionAllAlert" date="${list.createDate}">					
						<fmt:parseDate value="${Mdivision}" var="MdateFmt" pattern="yyyyMMdd"/>
      					<fmt:formatDate value="${MdateFmt}"  pattern="yyyy-MM-dd (E)"/>						
					</li>
				</c:if>					
				<li class="mentionDiv <c:if test="${empty list.readDate || list.readDate == 'null'}">unread</c:if> ${list.alertId}" onmouseover="fnSetCurDate(this)" date="${list.createDate}">					
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
						<div class="icon sc"></div>
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
					<c:if test="${list.eventType == 'ONEFFICE'}">
						<div class="icon of"></div>
					</c:if>
					
					<!-- 내용 -->
					<c:if test="${list.webActionType == 'C'}">
						<div class="list_con" onclick="alert('<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>');" data='${list.data}'>
					</c:if>
					<c:if test="${list.webActionType != 'C'}">
						<c:if test="${list.eventType != 'MAIL'}">
							<c:choose>
								<%-- 전자결재 알림중 mobileViewYn 값이 N이면 열람할 수 없다. --%>
								<c:when test="${list.eventType == 'EAPPROVAL' && list.mobileViewYn == 'N'}">
									<div class="list_con" onclick="alert('<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.")%>');" data='${list.data}'>
								</c:when>
								<c:otherwise>
									<div class="list_con" onclick="forwardPageByAlert('${list.url}','${list.alertId}','${list.eventType}','${list.eventSubType}','${list.senderSeq}', this);" data='${list.data}'>
								</c:otherwise>
							</c:choose>		
						</c:if>
						<c:if test="${list.eventType == 'MAIL'}">
							<div class="list_con" onclick="fnMailMove('${list.mailUid}','${list.email}','${list.url}','${list.alertId}')" data='${list.data}'>
						</c:if>						
					</c:if>						
					
					<a href="#n" onclick="return false;" class="title" title="${list.message.alertTitle}">
						${list.message.alertTitle}
					</a>
					
					<c:choose>
						<c:when test="${list.eventType == 'TALK' || list.eventType == 'MESSAGE' || list.eventSubType == 'EA105' || list.eventSubType == 'RP004' || list.eventSubType == 'PR005' || list.eventSubType == 'PR006' || list.eventSubType == 'PR007' || list.eventSubType == 'BO003' || list.eventSubType == 'BO004' || list.eventSubType == 'BO008' || list.eventSubType == 'BO009' || list.eventSubType == 'ED009' || list.eventSubType == 'ED010' || list.eventSubType == 'SC005' || list.eventSubType == 'ONE001'}">
							<dl>								
								<dd class="mention_detail ellipsis" id="ellipsis_${list.alertId}" data='${list.data}' flag='false' eventSubType='${list.eventSubType}'>
									<p id="lengthFlag_${list.alertId}" style="display: none;">${list.message.alertContent}</p>
									<span class="msg"></span> 
									${list.message.alertContent}						
									<c:if test="${fn:length(list.message.alertContent) >= 300}">
										<a href="#n" onclick="return false;" class="more_btn"> 상세보기</a>
									</c:if>
									<p style="display: none;" id="mentionDetailTitle_${list.alertId}">${list.message.alertTitle}</p>
									<p style="display: none;" id="mentionDetailContents_${list.alertId}">${list.message.alertContent}</p>
								</dd>
								
							</dl>
						</c:when>
						<c:otherwise>
							<dl>
								<dt>${list.message.alertContent}</dt>
								<dd class="sub_detail" id="subDetail_${list.alertId}">
									
								</dd>
							</dl>
						</c:otherwise>
					</c:choose>
						
					</div>
					<!-- 날짜 및 펼침버튼-->
					<div class="list_fn" data='${list.data}' eventType='${list.eventType}' eventSubType='${list.eventSubType}' alertId='${list.alertId}' moreYn='${list.moreYn}'>
						<span class="date" date="${list.createDate}"></span>
					</div>									
				</li>
			</c:forEach>
		</ul>
		<div class="tag_date">
			<span class="tag_date_l"></span>
			<span class="tag_date_c" id="curMentionDate"></span>
			<span class="tag_date_r"></span>
		</div>	
</div>
</c:if>
<div class="no_data" style="display: none;" id="noDate">
	<div class="nd_in">
		<img src="/gw/Images/bg/survey_noimg.png" alt="" />										
		<p><%=BizboxAMessage.getMessage("TX900000351","알림이 없습니다.")%></p>
	</div>
</div>