var menu = {};

menu.topMenuInfo = {};

menu.leftMenuList = [];

menu.directUrlArray = [];

menu.edmsDomain = null;

menu.isFirstMenu = true;

menu.callMenuInfo = {};


menu.directUrlId = null;

menu.docParameters = {};

var mainmenu = {};

var pageFlag = true;

var firstMenu = "";

var exceptMenuType = "";

var edmsCategoryList = "";

var dirGroupNo = "";

var refreshIntervalId;

var detailUrl = "";

var openMenuDepth = "";

var eaMenuCntYn = "";

var currentNode = null;

var flag = false;

var menuSetTimeID = "";

/** top 메뉴 클릭 **/
mainmenu.clickTopBtn = function(no, name, url, urlGubun, email){
	
	$("#no").val(no);
	$("#name").val(name);
	$("#url").val(url);
	$("#urlGubun").val(urlGubun);
	
	$("#topMenuList").find("a[name=topMenu]").each(function(){
		$(this).removeClass("on");
	});	
	$("#topMenu" + no).addClass("on");
	
	if (urlGubun == 'mail' || urlGubun == 'adminMail') {
		form.action="bizboxMail.do";
	}else if (urlGubun == 'mailex') {
		form.action="bizboxMailEx.do";
	}else {
		form.action="bizbox.do";
	}
	
	form.submit();
	
};


mainmenu.mainToLnbMenu = function(no, name, url, urlGubun, email, portletType, gnbMenuNo, lnbMenuNo, lnbName , mainForward){
	
	$("#no").val(no);
	$("#name").val(name);
	$("#url").val(url);
	$("#urlGubun").val(urlGubun);
	$("#portletType").val(portletType);
	$("#gnbMenuNo").val(gnbMenuNo);
	$("#lnbMenuNo").val(lnbMenuNo);
	$("#lnbName").val(lnbName);
	$("#mainForward").val(mainForward);
	
		
	$("#topMenuList").find("a[name=topMenu]").each(function(){
		$(this).removeClass("on");
	});
	$("#topMenu" + no).addClass("on");
	
	if (urlGubun == 'mail' || urlGubun == 'adminMail') {
		form.action="bizboxMail.do";
	}else if (urlGubun == 'mailex') {
		form.action="bizboxMailEx.do";
	}else {
		form.action="bizbox.do";
	}	
	
	form.submit();
	
};


/** 초기화 **/
menu.init = function() {
	
	menu.leftMenuList = [];
	menu.isFirstMenu = true;
	menu.callMenuInfo = {};
	menu.docParameters = {};
	menu.directUrlArray = [];
	
};


/** top 메뉴 클릭 **/
menu.clickTopBtn = function(no, name, url, urlGubun, menuGubun) {
	if (urlGubun == 'mail') {
		menu.go(urlGubun, url);
		return;
	} else if(urlGubun == 'noticeMail') {
		openWindow2(url, name, 980, 680, 1, 1);
		return;
	}
		
	menu.init();
	
	menu.topMenuInfo = {};	
	menu.topMenuInfo.name = name;
	menu.topMenuInfo.menuNo = no;
	
	
	var manualModule = "";
	var manualType = "lnb";
	
	if(localStorage.getItem("manualUrl") == null || localStorage.getItem("manualUrl") != ""){
		
		if(manualUserSe == "USER"){
			
			if(no == "200000000"){
				manualModule = "mail";
			}else if(no == "300000000"){
				manualModule = "schedule";
			}else if(no == "400000000"){
				manualModule = "project";
			}else if(no == "500000000"){
				manualModule = "board";
			}else if(no == "600000000"){
				manualModule = "document";
			}else if(no == "700000000"){
				manualModule = "attend";
			}else if(no == "800000000"){
				manualModule = "mypage";
			}else if(no == "2000000000"){
				manualModule = "eap";
			}else if(no == "100000000"){
				manualModule = "ea";
			}else if(no == "900000000"){
				manualModule = "gw";
			}else if(no == "1000000000"){
				manualModule = "exp";
			}
					
		}else{
			
			manualType = "lnb_adm";
			
			if(no == "300000000"){
				manualModule = "schedule";
			}else if(no == "400000000"){
				manualModule = "project";
			}else if(no == "920000000"){
				manualModule = "mypage";
			}else if(no == "930000000"){
				manualModule = "attend";
			}else if(no == "200000000"){
				manualModule = "mail";
			}else if(no == "210000000"){
				manualModule = "amail";
			}else if(no == "500000000" || no == "1500000000"){
				manualModule = "board";
			}else if(no == "600000000" || no == "2100000000"){
				manualModule = "document";
			}else if(no == "700000000" || no == "1700000000"){
				manualModule = "eap";
			}else if(no == "800000000" || no == "1100000000"){
				manualModule = "ea";
			}else if(no == "810000000" || no == "1810000000"){
				manualModule = "exp";
			}else if(no == "900000000" || no == "1900000000"){
				manualModule = "setting";
			}else if(no == "910000000" || no == "1800000000"){
				manualModule = "gw";
			}
		}		
	}
	
	if(manualModule != ""){
		if($("#portalDiv").val() == "cloud"){
			name = name + "<a href='#' onclick=\"onlineManualPop('" + manualType + "','" + manualModule + "')\" class='tit_help'></a>";
		}else{
			name = name + "<img onclick=\"onlineManualPop('" + manualType + "','" + manualModule + "')\" src=\"/gw/Images/ico/ico_LNBmanual.png\" class=\"mtImg pl5\" style='cursor:pointer' />";		
		}		
	}
	
	if($("#portalDiv").val() == "cloud"){
		$(".lnb_title").html(name);	
	}else{
		$(".sub_nav_title").html(name);	
	}
	
	menu.topMenuInfo.url = url;
	menu.topMenuInfo.urlGubun = urlGubun;
	menu.setLeftMenu(no);
	
	$("#topMenuList").find("a[name=topMenu]").each(function(){
		$(this).removeClass("on");
	});
	$("#topMenu" + no).addClass("on");
};


menu.timeline = function(target){
	
	menu.leftMenuList = [];
	menu.isFirstMenu = false;
	menu.callMenuInfo = {};
	
	if (target == "timeline") {
		form.action="timeline.do";
	} else if (target == "totalSearch") {
		form.action="totalSearch.do";
	}
	else {
		form.action="userMain.do";
	}
	
	form.submit();
	
};

menu.totalsearch = function(){
	
	menu.leftMenuList = [];
	menu.isFirstMenu = false;
	menu.callMenuInfo = {};

	//form.action="totalSearch.do";
	var boardType = "1";
	
	
	
	if($("#topMenu100000000").hasClass("on") == true){ // 비영리 전자결재 100000000
		boardType = "7";
	}else if($("#topMenu2000000000").hasClass("on") == true){ // 영리 전자결재
		boardType = "6";
	}else if($("#topMenu300000000").hasClass("on") == true){ // 일정
		boardType = "3";
	}else if($("#topMenu400000000").hasClass("on") == true){ // 업무관리
		boardType = "2";
	}else if($("#topMenu500000000").hasClass("on") == true){ // 게시판 500000000
		boardType = "9";
	}else if($("#topMenu600000000").hasClass("on") == true){ // 문서 600000000
		boardType = "8";
	}else if($("#topMenu200000000").hasClass("on") == true){ // 메일 200000000
		boardType = "0";
	}

	formSearch.tsearchKeyword.value = $("#tsearch").val()+"^^^"+boardType;

	formSearch.submit();
	
};


/** 메인에서 페이지 이동 **/
menu.mainforwardPage = function(url) {
	
	if (url == null || url == '') {
		//alert('1');
		//alert("죄송합니다. 서비스 준비중입니다.");
		return;
	}
	
	if (forwardType == 'main') {
		$("#mainForward").val("mainForward");
		$("#url").val(url);
		form.submit();
	}
	
};



/** 한글 기안 팝업 **/
menu.approvalPopup = function(popType, param, popName) {
	
	if(ncCom_Empty(popName)) {
		popName = "popDocApprovalEdit";
	}
	if(popType == "POP_ONE_DOCVIEW") {
		param= "multiViewYN=N&"+param;
	}else {
		param= "multiViewYN=Y&"+param;
    }
	
	var uri = "/ea/edoc/eapproval/docCommonDraftView.do?"+ param;
	
	return openWindow2(uri,  popName,  _g_aproval_width_, _g_aproval_heigth_, 1,1) ;
	
};


/** 알림 데이터 조회 폴링방식 
 *  알림 카운트만 조회하도록 변경. 한용일.
 * **/
menu.alertPolling = function() {
	
	setTimeout(function(){
		$.ajax({ 
			type:"post",
			url: _g_contextPath_ + "/alertCnt.do", 
			datatype:"text",
			complete: menu.alertPolling,
			success:function(data){	
				
				if (data.alertCnt != null) {
					var cnt = parseInt(data.alertCnt);
					if (cnt > 0) {
						$("#alertCnt").attr("class", "alert_cnt");
						$("#alertCnt").html(cnt);
					}
				}
				//$("#alertBox").html(data); 
			},
			error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
		});
	}, 600000); // 10분 
	
}; 

/** 1회용 알림 카운트 조회 **/
//알림 멘션 적용으로인한 신규생성함수
menu.alertUnreadCnt = function() {
	$.ajax({ 
		type:"post",
		url: _g_contextPath_ + "/alertUnreadCnt.do", 
		datatype:"text",
		success:function(data){
			if(data.alertMentionCnt > 0){
				$("#alertCnt").attr("class", "alert_cnt");
				$("#alertCnt").html("@");
				$("#newMentionIcon").addClass("new");
			}			
			else if (data.alertNotifyYn != null) {
				var alertNotifyYn = data.alertNotifyYn;				
				if (alertNotifyYn == "Y" ) {
					$("#alertCnt").attr("class", "alert_cnt");
					$("#alertCnt").html("N");
				}		
				
				if(data.alertMentionCnt < 1){
					$("#newMentionIcon").removeClass("new");
				}
			}
		},
		error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
	});
};


//알림 멘션 적용으로인한 신규생성함수
menu.alertUnreadPolling = function() {
	
	setTimeout(function(){
		$.ajax({ 
			type:"post",
			url: _g_contextPath_ + "/alertUnreadCnt.do", 
			datatype:"text",
			success:function(data){					
				if(data.alertMentionCnt > 0){
					$("#alertCnt").attr("class", "alert_cnt");
					$("#alertCnt").html("@");
					$("#newMentionIcon").addClass("new");
				}			
				else if (data.alertNotifyYn != null) {
					var alertNotifyYn = data.alertNotifyYn;				
					if (alertNotifyYn == "Y" ) {
						$("#alertCnt").attr("class", "alert_cnt");
						$("#alertCnt").html("N");
					}
					
					if(data.alertMentionCnt < 1){
						$("#newMentionIcon").removeClass("new");
					}
				}
			},
			error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
		});
	}, 600000); // 10분 
	
}; 






/** 1회용 알림 카운트 조회 **/
menu.alertCnt = function() {
	$.ajax({ 
		type:"post",
		url: _g_contextPath_ + "/alertCnt.do", 
		datatype:"text",
		complete: menu.alertPolling,
		success:function(data){	
			
			if (data.alertCnt != null) {
				var cnt = parseInt(data.alertCnt);
				if (cnt > 0) {
					$("#alertCnt").attr("class", "alert_cnt");
					$("#alertCnt").html(cnt);
				}
			}
			//$("#alertBox").html(data); 
		},
		error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
	});
};

/** 1회용 알림 데이터 조회 **/
menu.alertInfo = function() {	
	if(mentionUseYnFlag == "Y"){
		if(alertFlag){
			$("#alertBox").html("");
			$.ajax({ 
				type:"post",
				url: _g_contextPath_ + "/alertInfo.do", 
				datatype:"text",
				success:function(data){
					alertFlag = false;
					$("#alertBox").html(data); 
				},
				error: function(xhr) { 
			      console.log('FAIL : ', xhr);
				}
			});
		}
	}else{
		$.ajax({ 
			type:"post",
			url: _g_contextPath_ + "/alertInfo.do", 
			datatype:"text",
			success:function(data){								
				$("#alertBox").html(data); 
			},
			error: function(xhr) { 
		      console.log('FAIL : ', xhr);
			}
		});
	}
};


/** 알림 읽음 처리 및 페이지 이동 처리 
 * 
 * alertSeq 	: 알림 seq -> t_co_alert
 * forwardType  : 메인, 서브
 * type  		: 페이지 이동 종류(NOTICE 또는 메뉴 구분 MENU001 ..)
 * gnbMenuNo	: 상단 메뉴 번호
 * lnbMenuNo	: 왼쪽 메뉴 번호(선택 할 메뉴)
 * url			: iframe 보여질 페이지 url
 * urlGubun		: 컨네이터명(edms,gw, project, schedule)
 * seq			: 게시판 번호 -> 게시판 메뉴는 DB 없고, 게시판 솔루션에서 개발한 API를 호출하여 즉시 만들기 때문에 메뉴번호가 아닌 seq를 소분류 메뉴와 합산하여 정하기 위한 seq
 * name			: 메뉴명
 * 
 * */
menu.moveAndReadCheck = function(alertSeq, forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
	
	//console.log('menu.moveAndReadCheck('+alertSeq+', '+forwardType+', '+type+', '+gnbMenuNo+', '+lnbMenuNo+', '+url+', '+urlGubun+', '+seq+', '+name+')');
	
	if (alertSeq != null && alertSeq.length > 0) {
		menu.alertReadCheck(alertSeq);
	}
	
	menu.move(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name);
	
	menu.hideGbnPopup();
	
}

menu.moveAndReadCheck2 = function(alertSeq, forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
	
	//console.log('menu.moveAndReadCheck2('+alertSeq+', '+forwardType+', '+type+', '+gnbMenuNo+', '+lnbMenuNo+', '+url+', '+urlGubun+', '+seq+', '+name+')');
	
	if (alertSeq != null && alertSeq.length > 0) {
		menu.alertReadCheck(alertSeq);
	}
	
	menu.clickTimeline(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name)
	
	menu.hideGbnPopup();
	
}


/** 알림 읽첨 처리 db  **/
menu.alertReadCheck = function(alertSeq) {
	$.ajax({
	    url: _g_contextPath_ + "/alertReadCheckProc.do",
	    dataType: 'json',
	    data:{alertSeq:alertSeq},
	    success: function(data) { 
	    	//console.log(data);
	    },
	    error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
   });
};


/** 페이지 이동 */
menu.move = function(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
	
	//console.log('menu.move('+forwardType+', '+type+', '+gnbMenuNo+', '+lnbMenuNo+', '+url+', '+urlGubun+', '+seq+', '+name+')');
		
	// 공지사항은 게시판으로 선택될 메뉴 시퀀스를 만들어줘야함(2단메뉴 + 시퀀스)
	if (type == 'NOTICE' || type == 'MENU005') {
		if (seq != null && seq != '') {
			lnbMenuNo = parseInt(lnbMenuNo)+parseInt(seq);
		}
		url = "/board" + url + "&menu_no=" + lnbMenuNo;
		urlGubun = "edms";
	}else if(type == 'MENU006'){
		
		if (seq != null && seq != '') {
			lnbMenuNo = seq;
		}
		url = "/doc" + url + "&menu_no=" + lnbMenuNo;
		urlGubun = "doc";
	}
	// 일정은 선택될 메뉴 시퀀스를 만들어줘야함
	else if (type == 'MENU003') {
		lnbMenuNo = "301080000";
		urlGubun = "schedule";
		//url = "/schedule/" + url;
	}
	
	if (forwardType == 'main') {
		$("#mainForward").val("mainForward");
		$("#url").val(url);
		$("#urlGubun").val(urlGubun);
		$("#gnbMenuNo").val(gnbMenuNo);
		$("#no").val(gnbMenuNo);
		$("#name").val(name);
		$("#lnbMenuNo").val(lnbMenuNo);
		
		form.submit();
	} else {
		// bixbox.do
		menu.forwardFromMain(type, gnbMenuNo, lnbMenuNo, url, urlGubun, name,'');
	}
	
};

menu.clickTimeline = function(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name){
	
	//console.log('menu.clickTimeline('+forwardType+', '+type+', '+gnbMenuNo+', '+lnbMenuNo+', '+url+', '+urlGubun+', '+seq+', '+name+')');
	
	$("#mainForward").val(forwardType);
	$("#url").val(url);
	$("#urlGubun").val(urlGubun);
	$("#gnbMenuNo").val(gnbMenuNo);
	$("#no").val(gnbMenuNo);
	$("#name").val(name);
	$("#lnbMenuNo").val(lnbMenuNo);
	
	if (urlGubun == 'mail') {
		form.action="bizboxMail.do";
	} else if (urlGubun == 'mailex') {
		form.action="bizboxMailEx.do";
	} else {
		form.action="bizbox.do";
	}
	
	form.submit();
	
};


/** 메인에서 페이지 이동 신규 **/
menu.mainMove = function(type, urlPath, seq) {
	
	//console.log('menu.mainMove('+type+', '+urlPath+', '+seq+')');
	
	if(type.toLowerCase() == "schedule"){
	      $("#mainForward").val("mainForward");
		  $("#url").val("/schedule" + urlPath);
		  $("#urlGubun").val("schedule");
		  $("#gnbMenuNo").val("300000000");
		  $("#lnbMenuNo").val("301040000_all");
		  $("#no").val("300000000");
		  $("#portletType").val("schedule");
		  $("#name").val("일정");
		  $("#lnbName").val("");		
		  form.action="bizbox.do";
		  form.submit();
	}else{
		$.ajax({
		    url: _g_contextPath_ + "/mainPortletLnb.do",
		    dataType: 'json',
		    data:{langCode:'kr', portletType:type},
		    success: function(data) { 
		      var portlet = data.portletInfo;
		       
		      //console.log("portlet",portlet);
		      $("#mainForward").val("mainForward");
			  $("#url").val(urlPath);
			  $("#urlGubun").val(portlet.lnbMenuGubun);
			  $("#gnbMenuNo").val(portlet.gnbMenuNo);
			  $("#no").val(portlet.gnbMenuNo);
			  $("#portletType").val(type);
			  $("#name").val(portlet.gnbMenuNm);
			  $("#lnbName").val(portlet.lnbMenuNm);
			   
			  var lnbMenuNo = portlet.lnbMenuNo;
			  
			  // 공지사항은 게시판으로 선택될 메뉴 시퀀스를 만들어줘야함(2단메뉴 + 시퀀스)
			  if (type == 'NOTICE') {
				  
				  if (seq != null && seq != '') {
					  
					  if(seq == "501040000" || seq == "501030000"){
						  lnbMenuNo = seq;
					  }else{
						  lnbMenuNo = lnbMenuNo + "_" + seq;  
					  }
				  }
			  }
			  
			  if(type == "DOCUMENT"){
				  if (seq != null && seq != '') {
					  lnbMenuNo = lnbMenuNo + "_" + seq;  
				  }
			  }
			  
			  if(type == "PROJECT"){
				  lnbMenuNo = 401010000;
			  }
			  
			  $("#lnbMenuNo").val(lnbMenuNo);
			  if (portlet.lnbMenuGubun == 'mail') {
				  form.action="bizboxMail.do";
			  } else {
				  form.action="bizbox.do";
			  }
			  form.submit();
		      
		    },
		    error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
	   });		
	}
};


/** 메인 iframe에서 페이지 이동 **/    
menu.forwardFromMain = function(portletType, gnbMenuNo, lnbMenuNo, url, urlGubun, menuNm , lnbName , mainForward) { 
	//console.log('menu.forwardFromMain('+portletType+', '+gnbMenuNo+', '+lnbMenuNo+', '+url+', '+urlGubun+', '+menuNm+', '+lnbName+', '+mainForward+')');
	
	// 상세조회 URL
	detailUrl = url;
	
	// 왼쪽 메뉴 붙이기
	$("#sub_nav_jstree").html(""); 
	
	if(url != null && url != ""){
		mainForward = "mainForward";	
	}	
	
	$("#topMenuList").find("a[name=topMenu]").each(function(){
		$(this).removeClass("on");
	});	
	$("#topMenu" + gnbMenuNo).addClass("on");
	
	$.ajax({
		type:"post",
		url: _g_contextPath_ + "/cmm/system/getMenu2Depth.do",
		data:{startWith : gnbMenuNo}, 
		datatype:"json",			 
		success:function(data){
			
			if(data != null && data.sessionYn == "N"){
				menu.fnRedirectLogon();
				return;
			}			
			
			var items = "";	
			var menuNo = [];
			var menuType = "";
			var userSe = data.userSe;
			var seq = 0;
			openMenuDepth = data.openMenuDepth;
			eaMenuCntYn = data.eaMenuCnt
			if (data.depth2Menu) {
				
				$.each(data.depth2Menu,function (index,val){
					items += "<div class='sub_2dep' id='"+index+'dep'+"'><span  class='"+val.expendClass+"'>"+val.name+"</span></div>";			

					/* 특정 매뉴는 api를 호출하기때문에 예외처리(게시판 , 문서 , 프로젝트관리 , 웹팩스)*/
					if((val.childCount > 0) || ((val.menuNo == "501000000") || (val.menuNo == "505000000") || (val.menuNo == "601000000") || (val.menuNo == "901000000") || (val.menuNo == "390000000") || (val.menuNo == "507000000") || (val.menuNo == "1507000000") || (val.menuNo == "1501000000") || (val.menuNo == "1505000000") || (val.menuNo == "1100020000") || (val.menuNo == "1100030000") ) ) {
						if(val.menuNo == "601000000" && userSe == "USER") {
							items += "<div id='"+val.menuNo+"'class='sub_2dep_in btn_ul'></div>";
						} else {
							items += "<div id='"+val.menuNo+"'class='sub_2dep_in'></div>";
						}
						
					}
					menuNo[index] = val.menuNo ;	
										
					if(val.urlPath != "" && val.childCount == 0 ){
						var obj = {};
						
						obj = {urlGubun: val.urlGubun , url : val.urlPath , menuNo : val.menuNo , text : val.name, ssoUseYn : val.ssoUseYn , seq : seq};
						menu.directUrlArray.push(obj);
												
						menu.directUrlId = val.menuNo;
						$(document).on('click',"#"+index+'dep',function () {
							fncDirectUrl(obj.seq);
						});
						
						seq++;
					}
					
				});
												
				$("#sub_nav_jstree").html(items);
				
				if(menuNm == ""){
					
					if($("#portalDiv").val() == "cloud"){
						menuNm = $("#topMenuList li.on a").html();
					}else{
						menuNm = $("#topMenuList li a.on").html();	
					}
					
					if(menuNm == null){
						menuNm = "";
					}
				}

				menu.topMenuInfo = {};
	
				menu.topMenuInfo.name = menuNm;
				
				menu.topMenuInfo.menuNo = gnbMenuNo;
		
				var manualType = "lnb";
				var manualModule = "";
				
				if(localStorage.getItem("manualUrl") == null || localStorage.getItem("manualUrl") != ""){
					if(manualUserSe == "USER"){
						
						if(gnbMenuNo == "200000000"){
							manualModule = "mail";
						}else if(gnbMenuNo == "300000000"){
							manualModule = "schedule";
						}else if(gnbMenuNo == "400000000"){
							manualModule = "project";
						}else if(gnbMenuNo == "500000000"){
							manualModule = "board";
						}else if(gnbMenuNo == "600000000"){
							manualModule = "document";
						}else if(gnbMenuNo == "700000000"){
							manualModule = "attend";
						}else if(gnbMenuNo == "800000000"){
							manualModule = "mypage";
						}else if(gnbMenuNo == "2000000000"){
							manualModule = "eap";
						}else if(gnbMenuNo == "100000000"){
							manualModule = "ea";
						}else if(gnbMenuNo == "900000000"){
							manualModule = "gw";
						}else if(gnbMenuNo == "1000000000"){
							manualModule = "exp";
						}
								
					}else{
						
						manualType = "lnb_adm";
						
						if(gnbMenuNo == "300000000"){
							manualModule = "schedule";
						}else if(gnbMenuNo == "400000000"){
							manualModule = "project";
						}else if(gnbMenuNo == "920000000"){
							manualModule = "mypage";
						}else if(gnbMenuNo == "930000000"){
							manualModule = "attend";
						}else if(gnbMenuNo == "200000000"){
							manualModule = "mail";
						}else if(gnbMenuNo == "210000000"){
							manualModule = "amail";
						}else if(gnbMenuNo == "500000000" || gnbMenuNo == "1500000000"){
							manualModule = "board";
						}else if(gnbMenuNo == "600000000" || gnbMenuNo == "2100000000"){
							manualModule = "document";
						}else if(gnbMenuNo == "700000000" || gnbMenuNo == "1700000000"){
							manualModule = "eap";
						}else if(gnbMenuNo == "800000000" || gnbMenuNo == "1100000000"){
							manualModule = "ea";
						}else if(gnbMenuNo == "810000000" || gnbMenuNo == "1810000000"){
							manualModule = "exp";
						}else if(gnbMenuNo == "900000000" || gnbMenuNo == "1900000000"){
							manualModule = "setting";
						}else if(gnbMenuNo == "910000000" || gnbMenuNo == "1800000000"){
							manualModule = "gw";
						}
					}						
				}				
				
				if(manualModule != ""){
					if($("#portalDiv").val() == "cloud"){
						menuNm = menuNm + "<a href='#' onclick=\"onlineManualPop('" + manualType + "','" + manualModule + "')\" class='tit_help'></a>";
					}else{
						menuNm = menuNm + "<img onclick=\"onlineManualPop('" + manualType + "','" + manualModule + "')\" src=\"/gw/Images/ico/ico_LNBmanual.png\" class=\"mtImg pl5\" style='cursor:pointer' />";		
					}		
				}
				
				if($("#portalDiv").val() == "cloud"){
					$(".lnb_title").html(menuNm);
					$(".lnb_title").removeClass("ma ea dc st sc ds wk gt bd mp mg et nt");
					$(".lnb_title").addClass(data.menuImgClass);
				}else{
					$(".sub_nav_title").html(menuNm);
					$(".side_wrap").removeClass("ma ea dc st sc ds wk gt bd mp mg et nt");
					$(".side_wrap").addClass(data.menuImgClass);		
				}				
														
				for(var idx = 0 ; idx < menuNo.length; idx++) {
					//전자결재 일 경우
					if(menuNo[idx] == "2002000000" || menuNo[idx] == "2001000000") {
						menuType = "eaBox";
					}else if(menuNo[idx] == "301000000") {
						menuType = "schedule";							
					}else if(menuNo[idx] == "501000000" || menuNo[idx] == "1501000000") {
						menuType = "edms";
					}else if(menuNo[idx] == "505000000" || menuNo[idx] == "1505000000") {
						menuType = "project";
					}else if(menuNo[idx] == "601000000") {
						urlGubun = "doc";
						menuType = "doc";
					}else if(menuNo[idx] == "507000000" || menuNo[idx] == "1507000000"){
						menuType = "bookMark";
					}else if(menuNo[idx] == "1100020000"){
						urlGubun = "project";
						menuType = "kissG";
					}else if(menuNo[idx] == "1100030000"){
						urlGubun = "project";
						menuType = "kissA";
					}  
					else {
						menuType = "";
					}
					menu.setForwardLnb(menuNo[idx],lnbMenuNo,gnbMenuNo,url,urlGubun,menuType,mainForward ,portletType);					
				}
				
				var parMenuNo = lnbMenuNo;
				
				if(portletType == 'NOTICE'){
					var noticeMenuNo = lnbMenuNo.split('_');
					
					//예외처리
					if(noticeMenuNo.length == 2){
						lnbMenuNo = parseInt(noticeMenuNo[0])+parseInt(noticeMenuNo[1]);
						parMenuNo = noticeMenuNo[0]; 
					}
				}else if(urlGubun == 'doc'){
					var noticeMenuNo = lnbMenuNo.split('_');
					
					//예외처리
					if(noticeMenuNo.length == 2){
						lnbMenuNo = noticeMenuNo[1];
						parMenuNo = noticeMenuNo[0];
					}
				}

				
				menuSetTimeID = setTimeout("checkMenu('" + lnbMenuNo + "')", 1500);
			}
		} 
	});
}

function checkMenu(lnbMenuNo){
	if($("#" + lnbMenuNo).length == 0 && lnbMenuNo != '501030000' && lnbMenuNo != '501040000'){
		//alert("메뉴가 존재하지 않습니다.");
		detailUrl = "";
	}
	if(lnbMenuNo == '501030000' && lnbMenuNo == '501040000'){
		detailUrl = "";
	}
}

menu.setForwardLnb = function(upperMenuNo,lnbMenuNo,gnbMenuNo,url,urlGubun,menuType,mainForward ,portletType) {
	
	//console.log('menu.setForwardLnb('+upperMenuNo+','+lnbMenuNo+','+gnbMenuNo+','+url+','+urlGubun+','+menuType+','+mainForward+' ,'+portletType+')');
	
	var parMenuNo = lnbMenuNo;
	
	if(portletType == 'NOTICE'){
		var noticeMenuNo = lnbMenuNo.split('_');
		
		//예외처리
		if(noticeMenuNo.length == 2){
			lnbMenuNo = parseInt(noticeMenuNo[0])+parseInt(noticeMenuNo[1]);
			parMenuNo = noticeMenuNo[0]; 
		}
	}else if(urlGubun == 'doc'){
		var noticeMenuNo = lnbMenuNo.split('_');
		
		//예외처리
		if(noticeMenuNo.length == 2){
			lnbMenuNo = noticeMenuNo[1];
			parMenuNo = noticeMenuNo[0];
		}
	}
	
	var mainForwardCheck = ""
		mainForwardCheck = mainForward;
	$('#'+upperMenuNo).jstree({
	'core' : {
		  'data' : {
		   'url' :  _g_contextPath_ + '/cmm/system/getJsTreeList.do',
		   'cache' : false,
		   'dataType': 'JSON',
		   'data' : function (node) {
				  if(node.id != "#") {
					   if(node.id == '602010000' || node.original.exceptGubun == 'eaCategory' || node.id == '605000200' || node.id == '1605000200' || node.id == '2103000200' || node.id == '607010000') {
						   // 문서 > 전자결재 > 카테고리별 문서관리 하위에 트리를 만들기 위해 예외처리
						   menuType = 'eaCategory';
					   }					   
					   if(menu.docParameters.dirRootNode != 'undifined' || menu.docParameters.dirRootNode != null){
						   // 카테고리 분류 Root노드가 아닐경우 
						   menu.docParameters.dirRootNode = 'childeNodes';
					   }
				  }
			      return {'upperMenuNo' : (node.id == "#" ? upperMenuNo : node.id ) 
			    	  ,'level' : (node.id == "#" ? "1" : node.original.level )  
			    	  ,'firstDepthMenuNo' : gnbMenuNo , 'menuType' :  menuType 
			    	  ,'dir_group_no' : (menu.docParameters.dirGroupNo == null ? 0 : menu.docParameters.dirGroupNo)/*뷴류선택  카테고리 그룹No 업무분류(0) 카테고리(그룹번*/
			    	  ,'dir_type' :( menu.docParameters.dirType == null ? "W" : menu.docParameters.dirType)/*뷴류선택 카테고리 Type 업무뷴류(W) 카테고리(C)*/
			    	  ,'dir_rootNode' : (menu.docParameters.dirRootNode == null ? "root" : menu.docParameters.dirRootNode)}/*Root 폴더를 만들기 위해 필요한 파라미터*/
			   }
			  }
			}})
		.bind("loaded.jstree", function(event, data) {
			// 트리 Load 시		
			
			$('#'+upperMenuNo).jstree("open_all");
			
			var menuNoSubStringRange = gnbMenuNo == '2000000000' ? 2 : 3;
			if(upperMenuNo.toString().substring(0,menuNoSubStringRange) == parMenuNo.toString().substring(0,menuNoSubStringRange)){	
				setTimeout(function(){
					var activeDepth2Menu = $("#"+lnbMenuNo).parents('.sub_2dep_in').prev();
					//activeDepth2Menu.addClass("active");
					activeDepth2Menu.next(".sub_2dep_in").show();			
				}, 900);
			}			
			
			//문서 > 일반문서 예외처리 (별도 api 제공)
			if(upperMenuNo == '601000000' && $("#userSe").val() == 'USER'){
				//일반 문서 메뉴 일 경우 분류선택 Button
				menu.fnGetEdmsGroupContens();		
				var categoryListBox = "<a href='#n' onClick='' class='type_btn'>"+NeosUtil.getMessage("TX000007942","분류선택")+"</a><div id='' class='type_list' style='width:160px;'>"+edmsCategoryList+"</div>"; 
				$('#'+upperMenuNo).html(categoryListBox);
				$('#rootClass').addClass('select_item');
			}	
			//사내게시판 일경우 상태 hidden 노드 hide처리
			if(upperMenuNo == '501000000' && $("#userSe").val() == 'USER'){
				nodeHide(data);
			}
			
			//$(this).jstree("open_all");
			$(this).jstree('select_node', '#'+lnbMenuNo);
		})
		.bind("after_open.jstree", function(event,data) {
				var activeDepth2Menu = $("#"+lnbMenuNo).parents('.sub_2dep_in').prev();
				//activeDepth2Menu.addClass("active");
				//activeDepth2Menu.next(".sub_2dep_in").show();
				
				if($(this).jstree(true).get_node('#'+lnbMenuNo, true) && !flag){
					$(this).jstree(true).get_node('#'+lnbMenuNo, true).children('.jstree-anchor').focus();				
					$(this).jstree('select_node', '#'+lnbMenuNo);
				}
		})
		.bind("select_node.jstree", function(event, data) {
			flag = true;
			/*
			//메인 iframe 호출 시 모든노드를 펼친후 찾는다.
			if( mainForwardCheck == 'mainForward'){
				menu.callMenuInfo.menuNo = lnbMenuNo ;
				menu.go(urlGubun,url);
				mainForwardCheck = 'leftForward';
			}else{
				menu.onSelect(data);
			}*/
			menu.onSelect(data);
			menu.getLeftMenuHistory(data);
		})
		.bind("refresh.jstree", function(event, data) { 
				//refresh 하면 분류선택 버튼이 없어지기 떄문에 function다시 호출하여 버튼 생성
				if(upperMenuNo == '601000000'){
					//일반 문서 메뉴 일 경우 분류선택 Button
					menu.fnGetEdmsGroupContens();
					var categoryListBox = "<a href='#n' class='type_btn'>"+NeosUtil.getMessage("TX000007942","분류선택")+"</a><div id='' class='type_list' style='width:160px;'>"+edmsCategoryList+"</div>"; 
					$('#'+upperMenuNo).html(categoryListBox);
					$('#rootClass').removeClass('select_item');

					$("#"+upperMenuNo).jstree("open_all");	
				}
				//사내게시판 일경우 상태 hidden 노드 hide처리
				if(upperMenuNo == '501000000' && $("#userSe").val() == 'USER'){
					nodeHide(data);
				}
				//새로고침 후 선택 노드 색상처리
				if(currentNode != null)
					$("#" + currentNode).addClass("jstree-clicked");
				currentNode = null;
		})
		.bind("ready.jstree", function(event, data){
			if(openMenuDepth != "" && openMenuDepth != "0"){
				$("#"+upperMenuNo).jstree("close_all");
				for(var i=1;i<openMenuDepth;i++){
					$("li[aria-level='"+i+"']").each(function(){
						$("#"+upperMenuNo).jstree("open_node", this);
					});
				}
				data.instance._open_to(lnbMenuNo);				
			}	
			
			if(lnbMenuNo == "501030000"){
				menu.go("edms", "/board/viewBoardNewArt.do");
				detailUrl = "";
			}else if(lnbMenuNo == "501040000"){
				menu.go("edms", "/board/viewBoardNewNotice.do");
				detailUrl = "";
			}
			
	
			//전자결재 결재함 카운트 조회
			if((gnbMenuNo == '2000000000' || gnbMenuNo == '100000000') && (upperMenuNo == '101000000' || upperMenuNo == '102000000' || upperMenuNo == '2002000000' || upperMenuNo == '103000000')){
				if(eaMenuCntYn == "Y"){
					clearInterval(refreshIntervalId);
					menu.refleshMenuCnt(upperMenuNo);
					refreshIntervalId = setInterval("menu.refleshMenuCnt('" + upperMenuNo + "')", 60000);  //15초마다 카운트 조회
				}
			}else{
				if(typeof(rootMenuNo) == "undefined" || (rootMenuNo != '2000000000' && rootMenuNo != '100000000'))
					clearInterval(refreshIntervalId);	//전자결재 페이지가 아니면 타이머 종료
			}
		});
	
		
};

/** 
 * 왼쪽 메뉴 히스토리 가져오기 위한 ajax
 * 
 * 번호  메뉴명
 * 100 전자결재
 * 110  ㄴ문서함
 * 111    ㄴ결대대시함
 * 
 */
menu.getMenuHistoryOfMenuNo = function(no, callbackFunction) {
	
	
	$.ajax({
	    url: _g_contextPath_ + "/cmm/system/getMenuListOfMenuNo.do",
	    dataType: 'jsonp',
	    data:{menuNo:no},
	    jsonpCallback: "myCallback",
	    success: function(data) { 
	      //console.log('SUCESS : ', data);  
	      
	      if (data.length > 0) {  
	    	  
	    	  if (callbackFunction != null && callbackFunction != undefined) {
	    		callbackFunction(data);  
	    	  } else {
	    	  
		    	  var jsonArr = data[0];
		    	  
		    	  if (jsonArr != [] && jsonArr.length > 0) {
		    		  
		    		  var topMenu = jsonArr[0];
		    		  
		    		  var callMenu = jsonArr[jsonArr.length-1];
		    		  
		    		  // LNB 동일
		    		  if (menu.topMenuInfo.menuNo != null && menu.topMenuInfo.menuNo != '' 
		    			  && menu.topMenuInfo.menuNo == topMenu.menuNo) {
		    			  
		    			  menu.menuSelect(callMenu);
		    			  
		    			  
		    			  menu.getLeftMenuHistory(callMenu.menuNo);
		    			  
		    			   
		    		  } 
		    		  // LNB 다름. GNB 이동후 LNB 호출하고 page view 처리
		    		  else {
		    			  
		    			  menu.init();
		    			  
		    			  menu.isFirstMenu = false;
		    			  
		    			  menu.topMenuInfo.menuNo = topMenu.menuNo;
		    			  
		    			  menu.callMenuInfo = callMenu;
		    			 
		    			  menu.setLeftMenu(topMenu.menuNo);
		    			  
		    		  }
		    		  
		    		  menu.go(callMenu.urlGubun, callMenu.urlPath);
		    	  }
		      } 
	      }
	    },
	    error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
   });
	
};


/** contents 페이지 이동 **/
menu.forward = function(url) {
	
	if (url == null || url == '') {
		//alert('3');
		//alert("죄송합니다. 서비스 준비중입니다.");
		return;
	}
	
	$.ajax({
	    url: _g_contextPath_ + "/cmm/system/getMenuListOfUrl.do",
	    dataType: 'jsonp',
	    data:{langCode:'kr', urlPath:url},
	    jsonpCallback: "myCallback",
	    success: function(data) { 
	    	//alert("contents 페이지 이동 : " + JSON.stringify(data));
	      //console.log('SUCESS : ', data);  
	      
	      if (data.length > 0) {  
	    	  
	    	  var jsonArr = data[0];
	    	  
	    	  if (jsonArr != [] && jsonArr.length > 0) {
	    		  
	    		  var topMenu = jsonArr[0];
	    		  
	    		  var callMenu = jsonArr[jsonArr.length-1];
	    		  
	    		  // LNB 동일
	    		  if (menu.topMenuInfo.menuNo != null && menu.topMenuInfo.menuNo != '' 
	    			  && menu.topMenuInfo.menuNo == topMenu.menuNo) {
	    			  
	    			  menu.menuSelect(callMenu);
	    			  
	    			  
	    			  menu.getLeftMenuHistory(callMenu.menuNo);
	    			  
	    			   
	    		  } 
	    		  // LNB 다름. GNB 이동후 LNB 호출하고 page view 처리
	    		  else {
	    			  
	    			  menu.init();
	    			  
	    			  menu.isFirstMenu = false;
	    			  
	    			  menu.topMenuInfo.menuNo = topMenu.menuNo;
	    			  
	    			  menu.callMenuInfo = callMenu;
	    			 
	    			  menu.setLeftMenu(topMenu.menuNo);
	    			  
	    		  }
	    		  
	    		  menu.go(callMenu.urlGubun, callMenu.urlPath);
	    	  }
	      } 
	    },
	    error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
   });
	
};


/** 페이지 이동후 kendo tree 메뉴에서 선택하기(버튼이 선택된 형태로 하기 위해) **/
menu.menuSelect = function(item) {
	
	var treeview = $("#sub_nav").data("kendoTreeView");
				 	
	/* treeview에서 select 처리하여 선택처리*/
	//console.log("item.seq : " + item.menuNo);
		
	/* 전부 펼치기(펼치지 않으면 데이터를 못받아옴) */
	treeview.expand(".k-item");
			
	var dataItem = treeview.dataSource.get(item.menuNo);
	var node = treeview.findByUid(dataItem.uid);
	treeview.select(node);
	
	/* 메뉴히스토리 남기기 */
	//menu.getLeftMenuHistory(item.menuNo);
	menu.topMenuInfo.url = item.urlPath;
	menu.topMenuInfo.urlGubun = item.urlGubun;
	
	/* 선택된 메뉴를 제외한 나머지 닫기 */
	var parentNode = treeview.dataItem(treeview.parent(node));
	if (parentNode != null) {
		menu.menuClose(parentNode);
	}
	
};


/** 선택된 메뉴를 제왼 나머지 소분류 메뉴 닫기 **/
menu.menuClose = function(node) {
	
	var treeview = $("#sub_nav").data("kendoTreeView");
	var view = treeview.dataSource.view();
	
	var nodes = menu.getTreeChildNodes(view);	
	
	for(var i = 0; i < nodes.length; i++) {
		var n = nodes[i];
		if (n.seq != node.seq) {
			treeview.collapse(treeview.findByText(n.name));
		}
	}
	
}


/** iframe forward url **/
menu.go = function(urlGubun, url, menuNo, name, ssoYn) {
	
	//console.log('menu.go('+urlGubun+','+url+','+menuNo+','+name+','+ssoYn+')');
	
	if(url != null && url.indexOf("/home/mainHome_projBoard.do") != -1){
		urlGubun = "edms";
	}
	
	
	//SSO Link
	if(ssoYn == "Y"){
		
		var tblParam = {};
		tblParam.linkId = menuNo;
		tblParam.linkTp = "gw_menu";
		tblParam.linkSeq = "1";
		tblParam.url = url;
		
		$.ajax({
			type:"post",
		    url: _g_contextPath_ + "/cmm/system/getMenuSSOLinkInfo.do",
		    async: false,
		    dataType: 'json',
		    data: tblParam,
		    success: function(data) { 
		    	url = data.ssoUrl;
		    },
		    error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
	   });		
		
	}
	
	if(url == null || url.trim() == ""){
		return;
	}
	
	if(urlGubun == 'link_pop'){
		var pop = openWindow2(url,  "_blank",  $(window).width(), $(window).height(), 1,1) ;
		if(pop == null){
			alert(NeosUtil.getMessage("","팝업 차단 기능이 설정되어있습니다.") + "\n" + NeosUtil.getMessage("","차단 기능을 해제(팝업허용) 한 후 다시 이용해 주십시오."));
		}
	}else {
		
		if(urlGubun == 'link_iframe'){
			urlGubun = "";
		}
		
	    if (urlGubun != null && urlGubun != '' && urlGubun != 'mail') {
			var params = "";
			if(url != null && url != '') {
				var len = url.indexOf("?");
				if (len > -1) {
					params = "&menu_no="+menu.callMenuInfo.menuNo;
				} else {
					params = "?menu_no="+menu.callMenuInfo.menuNo;
				}
			}
			$("#_content").attr("src","/"+urlGubun + url +params);
		}else {
			$("#_content").attr("src", url);
		}
	    
	    //확장기능(키컴페이지) 도움말 링크버튼 추가 예외처리
	    checkManualForKicom(url);
	}
	
};  

function checkManualForKicom(url){
	$(".btn_manual").remove();
	
	var name = "";	
	if(url.indexOf("cmmSmsFrameView.do?ServiceFlag=SMSRESULT") != -1){
		//문자전송내역		
		if(url.indexOf("&adminYn=Y") != -1){
			name = "gw_cmm_cmmPage_cmmSmsFrameView_do_ServiceFlag_SMSRESULT_admin";
		}else{
			name = "gw_cmm_cmmPage_cmmSmsFrameView_do_ServiceFlag_SMSRESULT";
		}
	}else if(url.indexOf("cmmSmsFrameView.do?ServiceFlag=SMS") != -1){
		//문자보내기
		name = "gw_cmm_cmmPage_cmmSmsFrameView_do_ServiceFlag_SMS";		        
	}else if(url.indexOf("smsMonthStatisView") != -1){
		//문자통계
		name = "gw_api_sms_web_admin_smsMonthStatisView";
	}else if(url.indexOf("BizBoxWebFax/FSPage.aspx") != -1){		
		if(url.indexOf("&addrURL=") != -1){
			//웹팩스(팩스보내기)
			name = "gw_api_fax_web_sendFax";
		}else{
			//팩스내역관리
			name = "gw_api_fax_web_admin_sendFaxList";
		}
	}
	
	if(name != ""){		
		name = name.replace("/?","?").replace(/\//gi,"_").replace(/\./gi,"_");
		
		if(name.length > 0){
			if(name.substr(0,1) == "_"){
				name = name.substr(1);
			}
			
			name = name.split("?")[0];
			
		}
		var tag = "<div class=\"btn_manual\" onclick=\"onlineManualPop('" + name + "', null)\">도움말</div>";	
		$("#_sub_contents").prepend(tag);
	}
	
	
}



menu.contentReload = function() {
	$("#_content").attr("src",$("#_content").attr("src"));
};  
 

/** 
 * LNB 2Depth메뉴 jquery로 가져오기
 * 
 * */
menu.setLeftMenu = function(no) {	
	
	$("#sub_nav_jstree").empty();
	

	$.ajax({
		type:"post",
		url: _g_contextPath_ + "/cmm/system/getMenu2Depth.do",
		data:{startWith : no}, 
		datatype:"json",			 
		success:function(data){	
			
			if(data != null && data.sessionYn == "N"){
				menu.fnRedirectLogon();
				return;
			}
			
			if($("#portalDiv").val() == "cloud"){
				$(".lnb_title").removeClass("ma ea dc st sc ds wk gt bd mp mg et nt");
				$(".lnb_title").addClass(data.menuImgClass);				
			}else{
				$(".side_wrap").removeClass("ma ea dc st sc ds wk gt bd mp mg et nt");
				$(".side_wrap").addClass(data.menuImgClass);
			}
			
			var userSe = data.userSe;
			var items = "";	
			var menuNo = [];
			var menuType = "";
			var seq = 0;
			openMenuDepth = data.openMenuDepth;
			eaMenuCntYn = data.eaMenuCnt;
			
			if (data.depth2Menu) {
				
				$.each(data.depth2Menu,function (index,val){		
					items += "<div class='sub_2dep' id='"+index+'dep'+"'><span  class='"+val.expendClass+"'>"+val.name+"</span></div>";				
					
					if(index == 0) {
						firstMenu = val.menuNo ;
					}
					
					if((val.urlPath != null || val.urlPath != "") && val.childCount == 0){
						var obj = {};
						
						obj = {urlGubun: val.urlGubun , url : val.urlPath , menuNo : val.menuNo , text : val.name, ssoUseYn : val.ssoUseYn , seq : seq};
						menu.directUrlArray.push(obj);
						menu.directUrlId = val.menuNo;
						$(document).on('click',"#"+index+'dep',function () {
							fncDirectUrl(obj.seq);
						});
						
						seq++;
					}
					
					/* 특정 매뉴는 api를 호출하기때문에 예외처리(게시판 , 문서 , 프로젝트관리 , 웹팩스)*/
					if((val.menuNo == "901000000") || (val.childCount > 0) || (val.menuNo == "501000000") || (val.menuNo == "505000000") || (val.menuNo == "601000000") || (val.menuNo == "390000000") || (val.menuNo == "507000000") || (val.menuNo == "1507000000") || (val.menuNo == "1501000000") || (val.menuNo == "1505000000") || (val.menuNo == "1100020000") || (val.menuNo == "1100030000") ) {
						if(val.menuNo == "601000000" && userSe == "USER") {
							items += "<div id='"+val.menuNo+"'class='sub_2dep_in btn_ul'></div>";
						} else {
							items += "<div id='"+val.menuNo+"'class='sub_2dep_in'></div>";
						}
						
					}
									
					menuNo[index] = val.menuNo ;
				});
												
				$("#sub_nav_jstree").html(items);
				
				
				//하위 Level 메뉴가 없는 Depth2 메뉴가 하나 일경우 
				if(menu.directUrlArray.length > 0 ) {
					if(menu.directUrlArray[0].urlGubun != "link_pop")
						fncDirectUrl(0);
				}
				
				//각각 							
				for(var i = 0 ; i < menuNo.length; i++) {
					if(menuNo[i] == "2002000000" || menuNo[i] == "2001000000") {
						menuType = "eaBox";
					}else if(menuNo[i] == "501000000" || menuNo[i] == "1501000000") {
						menuType = "edms";
					}else if(menuNo[i] == "505000000" || menuNo[i] == "1505000000") {
						menuType = "project";
					}else if(menuNo[i] == "601000000" && $("#userSe").val() == 'USER') {
						menuType = "doc";
					}else if(menuNo[i] == "390000000") {
						menuType = "prjSchedule";
					}else if(menuNo[i] == "507000000" || menuNo[i] == "1507000000") {
						menuType = "bookMark";
					}else if(menuNo[i] == "1100020000") {
						menuType = "kissG";
					}else if(menuNo[i] == "1100030000") {
						menuType = "kissA";
					}else{	
						menuType = "";
					}
					
					menu.setMenuDepth(no,menuNo[i],menuType);
				}
			}
		} 
	});
		
};

function fncDirectUrl(seq) {
	menu.go(menu.directUrlArray[seq].urlGubun, menu.directUrlArray[seq].url, menu.directUrlArray[seq].menuNo, menu.directUrlArray[seq].text, menu.directUrlArray[seq].ssoUseYn);
	menu.leftMenuList.push({name:menu.directUrlArray[seq].text, url:menu.directUrlArray[seq].url});
}

function fnSubMenuLink(par_menu_id){
	if($("#" + par_menu_id + " li").length > 0){
		$("#" + $("#" + par_menu_id + " li")[0].id).jstree("select_node", "#" + $("#" + par_menu_id + " li")[0].id);
	}else{
	    setTimeout( function() {
		fnSubMenuLink(par_menu_id);	
	    }, 100); 
	}
}

function nodeHide(data){
	if(data && data.instance && data.instance._model && data.instance._model.data){
		for(key in data.instance._model.data){
			if(data.instance._model.data[key]['state']['hidden']){
				console.log(key + " hidden :" + data.instance._model.data[key]['state']['hidden']);
				$("#" + key).hide();
			}
			
		}	
	}
}

menu.setMenuDepth = function (rootMenuNo,upperMenuNo,menuType) {	
	$('#'+upperMenuNo).jstree({
		'core' : {
			  'data' : {
			   'url' :  _g_contextPath_ + '/cmm/system/getJsTreeList.do',
		   	   'cache' : false,
			   'dataType': 'JSON',
			   'data' : function (node) {
				  //alert(JSON.stringify(node));
				  menu.docParameters.dirRootNode = null;
				 
				  if(node.id != "#") {					   
					  if(node.id == '602010000' || node.original.exceptGubun == 'eaCategory' || node.id == '605000200' || node.id == '1605000200' || node.id == '2103000200' || node.id == '607010000') {
						   // 문서 > 전자결재 > 카테고리별 문서관리 하위에 트리를 만들기 위해 예외처리
						   menuType = 'eaCategory';
					   } else if(node.id == '301030000' || node.id == '301040000' || node.id == '301050000' || node.id == '301060000') {
						   menuType = 'schedule';
					   } else if(node.id == '390000000') {
						   menuType = 'prjSchedule';
					   }
					   
					   if(menu.docParameters.dirRootNode != 'undifined' || menu.docParameters.dirRootNode != null){
						   // 카테고리 분류 Root노드가 아닐경우 
						   menu.docParameters.dirRootNode = 'childeNodes';
					   }
				  }
			      return {'upperMenuNo' : (node.id == "#" ? upperMenuNo : node.id ) 
			    	  ,'level' : (node.id == "#" ? "1" : node.original.level )  
			    	  ,'firstDepthMenuNo' : rootMenuNo , 'menuType' :  menuType 
			    	  ,'dir_group_no' : (menu.docParameters.dirGroupNo == null ? 0 : menu.docParameters.dirGroupNo)/*뷴류선택  카테고리 그룹No 업무분류(0) 카테고리(그룹번*/
			    	  ,'dir_type' :( menu.docParameters.dirType == null ? "W" : menu.docParameters.dirType)/*뷴류선택 카테고리 Type 업무뷴류(W) 카테고리(C)*/
			    	  ,'dir_rootNode' : (menu.docParameters.dirRootNode == null ? "root" : menu.docParameters.dirRootNode)
			    	  ,'scheduleSeq' : (node.id == "#" ? "0" : node.original.scheduleSeq)}/*Root 폴더를 만들기 위해 필요한 파라미터*/
			   }
			  }
			}})
			.bind("loaded.jstree", function(event, data) {
				//jsTree가 Load 될때
				//사용자 : 문서 > 일반문서의 경우 트리 펼치지 않는다.
				if(upperMenuNo != '601000000' || $("#userSe").val() != 'USER'){
					$(this).jstree("open_all");	
				}
				//탑 메뉴 호출시 첫번째 메뉴 선택
				if(firstMenu == upperMenuNo) {					
					//첫번째 Depth메뉴 펼치기
					var firstMenuDiv = $(".sub_2dep:first");
					//firstMenuDiv.addClass("active");
					firstMenuDiv.next(".sub_2dep_in").show();
					
					var tempArray = data.instance._model.data;
					var tempUrlGubun = "";
					if(tempArray[Object.keys(tempArray)[0]].original != null)
						tempUrlGubun = tempArray[Object.keys(tempArray)[0]].original.urlGubun;
					
					if(tempUrlGubun == 'link_pop' || tempUrlGubun == 'link_iframe'){
						// 외부링크
						menu.go("gw", "/cmm/cmmPage/CmmPageView.do?menuNm=" + menu.topMenuInfo.name);
					}else{
						// 첫번째 노드 select
						var tempMenuNo = $(this).find("ul > li:first")[0].id;
						if(tempMenuNo == "301030000" || tempMenuNo == "301040000"){
							fnSubMenuLink(tempMenuNo);
						}else{
							// 첫번째 노드 select
							$(this).jstree("select_node", "ul > li:first");
						}
					}
				}
				
				//문서 > 일반문서 예외처리 (별도 api 제공)
				if(upperMenuNo == '601000000' && $("#userSe").val() == 'USER'){
					//일반 문서 메뉴 일 경우 분류선택 Button
					menu.fnGetEdmsGroupContens();		
					var categoryListBox = "<a href='#n' onClick='' class='type_btn'>"+NeosUtil.getMessage("TX000007942","분류선택")+"</a><div id='' class='type_list' style='width:160px;'>"+edmsCategoryList+"</div>"; 
					$('#'+upperMenuNo).append(categoryListBox);
					$('#rootClass').addClass('select_item');

					//모두 펼치기
					//사용자 : 문서 > 일반문서의 경우 트리 펼치지 않는다.
					//$("#"+upperMenuNo).jstree("open_all");	
				}	
				//사내게시판 일경우 상태 hidden 노드 hide처리
				if(upperMenuNo == '501000000' && $("#userSe").val() == 'USER'){
					nodeHide(data);
				}
					
			})
			.bind("select_node.jstree", function(event, data) {
				menu.onSelect(data);	
				menu.getLeftMenuHistory(data);				
			})
			.bind("open_node.jstree", function(event, data) {
				if(upperMenuNo == '601000000' && $("#userSe").val() == 'USER'){
					if(openMenuDepth != "" && openMenuDepth != "0"){//해당 depth까지만 오픈
						for(id in data.instance._model.data){
							if(data.instance._model.data[id]['parents'].length < parseInt(openMenuDepth) && id != '#'){
								$('#'+upperMenuNo).jstree("open_node", $("#" + id));	
							}
						}
					}else{//전체 오픈
						for(id in data.instance._model.data){
							if(id != '#'){
								$('#'+upperMenuNo).jstree("open_node", $("#" + id));	
							}
						}
					}
				}
			})
			.on('click', '.jstree-anchor', function (e) {
			    $(this).jstree(true).toggle_node(e.target);
			  })
			.bind("refresh.jstree", function(event, data) { 
				//refresh 하면 분류선택 버튼이 없어지기 떄문에 function다시 호출하여 버튼 생성
				if(upperMenuNo == '601000000'){
					//일반 문서 메뉴 일 경우 분류선택 Button
					menu.fnGetEdmsGroupContens();
					var categoryListBox = "<a href='#n' class='type_btn' style='top:10px;left:0px;'>"+NeosUtil.getMessage("TX000007942","분류선택")+"</a><div id='' class='type_list' style='width:160px;'>"+edmsCategoryList+"</div>"; 
					$('#'+upperMenuNo).append(categoryListBox);
					$('#rootClass').removeClass('select_item');

					$("#"+upperMenuNo).jstree("open_all");
				}
				//사내게시판 일경우 상태 hidden 노드 hide처리
				if(upperMenuNo == '501000000' && $("#userSe").val() == 'USER'){
					nodeHide(data);
				}
				//새로고침 후 선택 노드 색상처리
				if(currentNode != null)
					$("#" + currentNode).addClass("jstree-clicked");
				currentNode = null;
			})
			.bind("ready.jstree", function(event, data){
				
				//사용자 : 문서 > 일반문서의 경우
				if(upperMenuNo == '601000000' && $("#userSe").val() == 'USER'){
					for(id in data.instance._model.data){
						if(data.instance._model.data[id].original){
							if(openMenuDepth != "1"){//1 depth로 설정되어있을 경우엔 그냥 두면 된다
								$('#'+upperMenuNo).jstree("open_node", $("#" + id));
							}
						}
					}
					
				}else{//이외
					if(openMenuDepth != "" && openMenuDepth != "0"){
						$("#"+upperMenuNo).jstree("close_all");
						for(var i=1;i<openMenuDepth;i++){
							$("li[aria-level='"+i+"']").each(function(){
								$("#"+upperMenuNo).jstree("open_node", this);
							});
						}
					}					
				}
				//전자결재 결재함 카운트 조회				
				if(typeof(rootMenuNo) != "undefined" && (rootMenuNo == '2000000000' || rootMenuNo == '100000000') && (upperMenuNo == '101000000' || upperMenuNo == '102000000' || upperMenuNo == '2002000000' || upperMenuNo == '103000000')){
					if(eaMenuCntYn == "Y"){
						clearInterval(refreshIntervalId);
						menu.refleshMenuCnt(upperMenuNo);
						refreshIntervalId = setInterval("menu.refleshMenuCnt('" + upperMenuNo + "')", 60000);  //15초마다 카운트 조회
					}
				}
				else{
					if(typeof(rootMenuNo) == "undefined" || (rootMenuNo != '2000000000' && rootMenuNo != '100000000'))
						clearInterval(refreshIntervalId);	//전자결재 페이지가 아니면 타이머 종료
				}
			});	
};

menu.fnGetEdmsGroupContens = function() {
	$.ajax({
		type:"post",
		async: false,
		url: _g_contextPath_ + "/cmm/system/getEdmsContetnsGroup.do",
		datatype:"json",			 
		success:function(data){
			var html = "";
			html += "<ul><li  id='rootClass' class=''><a href='#n' onclick=\"fnSelectCategory(\'601000000\',\'0\',\'W\')\";>"+NeosUtil.getMessage("TX000000756","업무분류")+"</a></li>";
			if(data != null){
				$.each(data,function (idx,val){
					var selectClass = "";
					if(menu.docParameters.dirGroupNo == val.dir_group_no){
						selectClass = "select_item";
					}
					html += "<li class='"+selectClass+"'><a href='#n' onclick=\"fnSelectCategory(\'601000000\',\'"+val.dir_group_no+"\',\'C\')\";>"+val.dir_group_nm+"</a></li>";
				});
			}
			html += "</ul>";
			edmsCategoryList = html ;

		},error:function(xhr) {
			console.log("FAIL",xhr);
		}
	});

};

function fnSelectCategory(jstree,parameter,type) {
	menu.docParameters.dirGroupNo = parameter;
	menu.docParameters.dirType = type;
	
	$('#'+jstree).jstree(true).refresh();
}


/** treeview에서 현재 위치한 메뉴 재클릭시 
 * 이벤트 실행이 안되어(페이지 리로드) 일반 이벤트 등록으로 처리
 *  
*/
menu.onclickLnb = function(e) {
	
	
	var tv = $("#sub_nav").data("kendoTreeView");
					
	var selectedNode = tv.select();
					
	var item = tv.dataItem(selectedNode);

	if (item != null && item != 'undifind') {
		var urlPath = item.urlPath;
		
		if (urlPath != null && urlPath != '') {
			var iframeUrl = $("#_content").attr("src");
			if (iframeUrl.indexOf(urlPath) > 0) {
				menu.contentReload();
			}
		}
	}
	
}


/** 왼쪽 메뉴명 이미지 설정 **/
menu.setSideWrapClass = function(data) {
	
	var jsonArr = data[0];
	if (jsonArr[0] != null) {
		var className = jsonArr[0].menuImgClass;
 		$(".side_wrap").attr("class", "side_wrap " + className + " k-pane k-scrollable");
	}
	
}


/** 사용자 이미지 업로드 **/
menu.userImgUpload = function(data, className) {
	
	$.ajax({ 
        type: "POST",
        url: "cmm/file/profileUploadProc.do",  
        //enctype: 'multipart/form-data', 
        processData: false,
	    contentType: false,
        data: data, 
        success: function (e) {  
           var fileId = e.fileId;
		   if (fileId != null && fileId != '') {
			   var data = {picFileId : fileId};
			   menu.userImgUpdate(data);
			   $("."+className).attr("src", "cmm/file/fileDownloadProc.do?fileId="+fileId+"&fileSn=0");
			   
			   setTimeout('menu.reloadUserInfoIframe()',500);
			    
		   }  
        },  
        error:function (e) { 
        	console.log(e); 
        }
	});
	
};


/** 사용자 이미지 변경시 iframe 페이지는 리로드 **/
menu.reloadUserInfoIframe = function() {
	
	 $("#iframeUserInfo").attr("src",$("#iframeUserInfo").attr("src"));
	 
};


/** 겸직 변경하기 */
menu.changePosition = function(seq) {
	
	$.ajax({ 
        type: "POST", 
        url: "systemx/changeUserPositionProc.do", 
        data: {seq : seq}, 
        success: function (e) {  
         if (e.result == 1) {
        	 location.href = 'userMain.do';
         } 
        },  
        error:function (e) {   
        	console.log(e); 
        } 
	});
	
};
 

/** 사용자 이미지 DB 업데이트 **/ 
menu.userImgUpdate = function(data) {
	
	 $.ajax({ 
        type: "POST",
        url: "cmm/systemx/userPicUpdateProc.do", 
        data: data, 
        success: function (e) {  
          //console.log(e);
        },  
        error:function (e) { 
        	console.log(e);
        } 
    });
  
}; 


/** 나의메뉴설정 조회 **/
menu.myMenu = function() {
	
	 $.ajax({ 
        type: "POST",
        url: "myMenu.do", 
        success: function (e) {  
          //console.log(e);
          
          $("#myMenu").html(e);
          
          
        },  
        error:function (e) { 
        	console.log(e);
        } 
    });
  
};


/** 하위 자식 노드 가져오기 **/
menu.getTreeChildNodes = function (nodes) {
	
	var node, childNodes;
    var _nodes = [];

    for (var i = 0; i < nodes.length; i++) {
		node = nodes[i];
		_nodes.push(node);
		
		if (node.hasChildren) {
			childNodes = menu.getTreeChildNodes(node.items);
			
			if (childNodes.length > 0){
				_nodes = _nodes.concat(childNodes);
			} 
		} 
	}

    return _nodes;

};

/** 왼쪽 메뉴 히스토리  **/
menu.getLeftMenuHistory = function(data) {
	

	var lastNode = data.node;
	var Depth2MenuName = "";
	
	if(lastNode != null) {

		var len = lastNode.parents.length;
		
		if(lastNode.parent != '#'){
			Depth2MenuName  = $("#"+lastNode.parents[len-2]).parent().parent().prev().find('span').text();
		}else {
			Depth2MenuName  = $("#"+lastNode.id).parent().parent().prev().find('span').text();
		}		
		
		menu.leftMenuList = [];		
		menu.leftMenuList.push({name:lastNode.text, url:lastNode.original.urlPath});
		
		
		//console.log(lastNode);
		
		if(lastNode.parent != '#') {
			while(true) {
				
			try {

				var parentId = lastNode.parent;
			    var jtreeNodesId = $('#'+parentId).closest('div').attr("id");
			    var node = $("#"+jtreeNodesId).jstree(true).get_node(parentId);		    
			    var menuClass = node.menuClass;
				
				//console.log("menuClass : " + menuClass);
				
				if (menuClass != null && menuClass != '' && menuClass != 'null') {
					$(".side_wrap").attr("class", "side_wrap " + menuClass);
				}
				
			    //console.log(node);
			    menu.leftMenuList.push({name:node.text, url:node.original.urlPath});			    
			    
			    if(lastNode.id == lastNode.parent){
			    	node = $("#"+jtreeNodesId).jstree(true).get_node(lastNode.parents[1]);	
			    }
			    		    
			    if(node.parent != '#') {
			    	lastNode = node ;
			    	continue;
				}else {
					break;
				}
			}catch(exception) {
					break;
				} 
			}
			  
		}

		//Depth 레벨이 2Lv 일 경우 상위노드를 찾아 넣어준다.
		menu.leftMenuList.push({name:Depth2MenuName, url:''});
		
	}
};
	

/** 왼쪽 메뉴 선택 **/
menu.onSelect = function(e) {
	
	var item = e.node.original;
	
	var param = {};
	param.menuNo = item.id;
	param.menuNm = item.text;					
	
	$.ajax({
		type:"post",
		url: _g_contextPath_ + "/cmm/system/menuUseHistory.do",
		datatype:"json",
		data: param,
		success:function(data, textStatus, xhr){
			if(data != null && data.sessionYn == null){
				location.href = "/gw/forwardIndex.do?maxSessionOut=Y";
			}else if(data != null && data.sessionYn == "N"){
				menu.fnRedirectLogon();
				return;
			}else{
				//선택된 메뉴의 상위메뉴 화살표 css 변경
				var upperObj = $("#" + item.id).parent().parent().prev();
				var upperId = upperObj.attr("id");

				if(upperId != undefined){
					$("#" + upperId).addClass("on");
				}
				
				if(detailUrl != ""){
					var url = detailUrl;
					detailUrl = "";
				}else{
					var url = item.urlPath;
				}
				
				var urlGubun = item.urlGubun;
				var exceptGubun = item.exceptGubun;
				var seq = item.id;
				
				menu.callMenuInfo = {menuNo:seq, urlGugun:urlGubun, urlPath:url};

				if (url != null && url != '') {
					menu.go(urlGubun, url, item.id, item.text, item.ssoUseYn);
				}else if( (exceptGubun == 'edms' || exceptGubun == 'eaCategory' || exceptGubun == 'doc' || exceptGubun == 'schedule') && url == '') {
					//게시판 형식이 폴더 형식일때 페이지 이동 차단
					return;
				}else {  //url없는 메뉴 선택시 페이지 이동 차단. 
						return;
				}	
				
			}
		},
		error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
	});	
};


/** 알림 팝업(div) 숨기기 **/
menu.hideGbnPopup = function(popType) {
	
	var profile_box = $(".profile_box").css("display");
	if (profile_box == 'block' && popType != 1) {
		$(".profile_box").css("display", "none");
	}
	
	if(mentionUseYnFlag == "Y"){
		var alert_box = $(".mention_alert_box").css("display");
		if (alert_box == 'block' && popType != 2) {
			$(".mention_alert_box").css("display", "none");
		}
	}else{
		var alert_box = $(".alert_box").css("display");
		if (alert_box == 'block' && popType != 2) {
			$(".alert_box").css("display", "none");
		}
	}
	
	var mymenu_box = $(".mymenu_box").css("display");
	if (mymenu_box == 'block' && popType != 3) {
		$(".mymenu_box").css("display", "none");
	}
	
};

//문서 : 분류선택 클릭 Live 이벤트
$(document).on('click','.type_btn',function(){
	if($(".type_list").css("display") == "none"){
		$(".type_list").show();								
	}else{
		$(".type_list").hide();	
	}
});

//클릭메뉴 초기화
$(document).on("click",".jstree-anchor",function(){
    var This = $(this);
    $(".jstree-anchor").removeClass("jstree-clicked");
    This.addClass("jstree-clicked");
});

menu.refleshMenuCnt = function(upperMenuNo){	
	//미결함, 수신참조함 카운팅		
		$.ajax({ 
			type:"post",
			url: _g_contextPath_ + "/refleshMenuCnt.do", 
			datatype:"text",
			data:{"upperMenuNo" : upperMenuNo},
			success:function(data){
				if(data.loginVO == null){
					location.href = _g_contextPath_ + "/bizbox.do";
				}else{				
					if(data.boxCntList != null){
						var boxCntList = JSON.parse(data.boxCntList);
						if(boxCntList.result != null){
							var menuCntList = boxCntList.result.boxList;
							if (menuCntList != null && menuCntList.length > 0) {		
								for(var i=0;i<menuCntList.length;i++){							
									var innerText = parent.$("#" + menuCntList[i].menuId + "_anchor").text();
									var lIndex =  innerText.lastIndexOf("(");
									var rIndex =  innerText.lastIndexOf(")");
									
									if(rIndex > lIndex && (!isNaN(innerText.substring(lIndex+1,rIndex)) || innerText.substring(lIndex+1,rIndex).indexOf('/') != -1)){
										innerText = innerText.substring(0,lIndex);
									}
									
									var clickedTp = $("#" + menuCntList[i].menuId + " a").hasClass("jstree-clicked");
									if(menuCntList[i].displayCnt != "")
										$("#" + menuCntList[i].parMenuId).jstree('set_text', $('#' + menuCntList[i].parMenuId).jstree(true).get_node("[id='" + menuCntList[i].menuId + "_anchor" + "']"), innerText + "(" + menuCntList[i].displayCnt + ")");
									else
										$("#" + menuCntList[i].parMenuId).jstree('set_text', $('#' + menuCntList[i].parMenuId).jstree(true).get_node("[id='" + menuCntList[i].menuId + "_anchor" + "']"), innerText);
									
									if(!clickedTp){
										$("#" + menuCntList[i].menuId + " a").removeClass("jstree-clicked");
									}
		
								}
								
								//leftMenuList 카운트 갱신
								if(menu.leftMenuList.length > 0 && $("#sub_nav_jstree li[aria-selected=true] a.jstree-clicked").length > 0){
									menu.leftMenuList[0].name = $("#sub_nav_jstree li[aria-selected=true] a.jstree-clicked").text();	
								}						
							}
						}
					}
				}
			},
			error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
		});
}

menu.fnCmmMenuReflesh = function(jstreeId){
	
	var jstreeIdObj = $('#sub_nav_jstree #' + jstreeId);
	
	if(jstreeIdObj.length > 0){

		var clickedNode = $("#sub_nav_jstree .jstree-clicked");
		var clickedNodeId = "";
		
		if(clickedNode.length > 0){
			clickedNodeId = clickedNode[0].id;
			currentNode = clickedNodeId;
		}
		
		jstreeIdObj.jstree("deselect_all");
		jstreeIdObj.jstree(true).refresh();
		
		if(clickedNodeId != ""){
			$("#sub_nav_jstree #" + clickedNodeId).addClass("jstree-clicked");	
		}
		
	}
	
}

mainmenu.refleshPortletList = function() {
	try {
		fnDrawMainPortal();
	} catch (e) {console.log(e);//오류 상황 대응 부재
	}
	
}

menu.fnRedirectLogon = function(){
	//로그인 페이지로 이동
	var msg = NeosUtil.getMessage("TX000015982","세션이 만료되었습니다.");
	alert(msg);
	
	window.location.href = '/gw/uat/uia/egovLoginUsr.do';
}
