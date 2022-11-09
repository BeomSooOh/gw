<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href="/gw/css/main.css?ver=20201021">

	<script type="text/javascript">
	
	$(document).ready(function() {
		
		$(".hidden_file_add1").on("change",function (){
			
			/* IE 10 버젼 이하에서 작동이 안될 수 있음. 추후 다른 방법으로 변경 예정. */
			var formData = new FormData();
			var pic = $("#userPic1")[0];
			
			formData.append("file", pic.files[0]);
			formData.append("pathSeq", "910");	//이미지 폴더
			formData.append("relativePath", ""); // 상대 경로
			 
	        menu.userImgUpload(formData, "userImg");

	    });
		
		//사진등록임시
		$(".btn_add").on("click",function(){
			$(".hidden_file_add1").click();
		})
		
		fnFindPasswdCheck();
		fnBackupServiceCheck();
		
	});
	
	function fn_Helpdesk(){
		
        var agent = navigator.userAgent.toLowerCase();
       	openWindow2("https://helpdesk.douzone.com/html/gw/default.aspx?aParam=${helpParam}",  "HelpDesk",  $(window).width(), $(window).height(), 1,1);
       	
	}
	
	var findPasswdCheckList = '${findPasswdEmpList}';
	
	function fnFindPasswdCheck(){
		
		if(findPasswdCheckList != "" && findPasswdCheckList != "[]"){
			var url = "/gw/cmm/systemx/empChangePassReqPop.do";
			var w = 750;
			var h = 520;
			var left = (screen.width/2)-(w/2);
			var top = (screen.height/2)-(h/2);
			var pop = window.open(url, "findPasswdPop", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + ", scrollbars=0,resizable=0");
			pop.focus();			
		}
	}
	
	function fnBackupServiceCheck(){
		
		if(typeof(backupServiceInfo) == "object"){
			
			if(localStorage.getItem("backupServiceInfo") != null && localStorage.getItem("backupServiceInfo").indexOf("|" + backupServiceInfo.backupSeq + "|") > -1){
				return;
			}
			
			var url = "/gw/cmm/systemx/backupServiceInfoPop.do";
			var w = 600;
			var h = 400;
			var left = (screen.width/2)-(w/2);
			var top = (screen.height/2)-(h/2);
			var pop = window.open(url, "backupServicePop", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + ", scrollbars=0,resizable=0");
			pop.focus();
			
		}
		
	}

	
	</script>	


	<!-- main 콘텐츠 영역 -->
	<div class="system_main">
		
		<div class="sm_top mb8">			
			<!-- 회사정보 -->
			<div class="sm_top_left mr8">
				<div class="company_name">
					<div class="user_pic">
						<div class="bg_pic"></div>
						<span class="img_pic">
							<img class="userImg" src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" alt="" onerror="this.src='Images/temp/pic_Noimg.png'" />
							<!-- <img src="../../../Images/bg/pic_Noimg.png" alt="" /> 프로필이미지가 없을경우 입니다.-->
						</span>				
					</div>
					
<!-- 					<p class="text_white"><strong>회사이름</strong></p> -->
					<c:if test="${userType eq 'MASTER'}">
					<div class="btn_cen">
						<a href="#n" id="fileUpload" class="btn_add"><%=BizboxAMessage.getMessage("TX000016208","사진 등록")%></a>
						<input name="userPic1" class="hidden_file_add1" id="userPic1" style="top: -1000px; position: absolute;" type="file">
<!-- 						<input id="uploadFile" name="uploadFile" multiple="multiple" type="file" class="hidden"> -->
					</div>
					</c:if>
					<c:if test="${userType eq 'USER'}">
						<c:if test="${displayPositionDuty eq 'position'}">
							<p class="text_white mb10"><strong>${loginVO.name} <c:if test="${not empty loginVO.positionNm && loginVO.positionNm != 'null'}">${loginVO.positionNm}</c:if></strong></p>
						</c:if>
						<c:if test="${displayPositionDuty eq 'duty'}">
							<p class="text_white mb10"><strong>${loginVO.name} <c:if test="${not empty loginVO.classNm && loginVO.classNm != 'null'}">${loginVO.classNm}</c:if></strong></p>	
						</c:if>
					
					
					<c:if test="${not empty optionValue && optionValue != 'null'}">
						<div class="text_white Scon_ts">${empPathNm}</div>
					</c:if>
					
					<c:if test="${empty optionValue || optionValue == 'null'}">
						<div class="text_white Scon_ts">${loginVO.orgnztNm}</div>
					</c:if>
					</c:if>
					
				</div>


				<div class="company_info">
					<p class="company_time"><span><%=BizboxAMessage.getMessage("TX000016114","최종접속")%></span> ${logVO.creatDt}</p>
					<dl>
					    <!--  UBA-100498 고객사요청으로 그룹코드 감춤 2022.07.27 -->					
						<dt style="display:none"><%=BizboxAMessage.getMessage("TX000000001","그룹코드")%></dt>
						<dd style="display:none">${groupMap.groupSeq} </dd>
						<dt><%=BizboxAMessage.getMessage("TX000000004","업로드절대경로")%></dt>
						<dd>${serverInfo[0].absolPath}</dd>
						<dt><%=BizboxAMessage.getMessage("TX000016365","그룹웨어 셋업버전")%></dt>
						<c:if test="${groupMap.setupVersion eq '' }" >
						<dd>&nbsp;</dd>
						</c:if>
						<c:if test="${groupMap.setupVersion ne '' }" >
						<dd>${groupMap.setupVersion }</dd>
						</c:if>
						
						<dt><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></dt>
						<dd>${groupMap.groupName} </dd>
					</dl>
				</div>
			</div>
						
			<!-- 전자결재 관리 -->
			<div class="sm_top_cen mr8">
				<c:if test="${eaType == 'eap'}">
					<a href="#" onclick="onclickTopMenu(1700000000,'<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>', '/admin/option/EAOptionInfo.do', 'eap')">
				</c:if>
				<c:if test="${eaType == 'ea'}">
					<a href="#" onclick="onclickTopCustomMenu(1100000000,'<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>', '', 'ea', '', 'N');">
				</c:if>
					<dl>
						<dt><%=BizboxAMessage.getMessage("TX000016141","전자결재 관리")%></dt>
						<dd><%=BizboxAMessage.getMessage("TX000016371","그룹 및 회사별 전자결재 옵션을")%><br/>  
							<%=BizboxAMessage.getMessage("TX000016195","설정하고 관리할 수 있습니다.")%></dd>
					</dl>
				</a>
			</div>

			<!-- 시스템설정 -->
			<div class="sm_top_right">
				<a href="#" onclick="onclickTopMenu(1900000000,'<%=BizboxAMessage.getMessage("TX000007033","시스템설정")%>', '', '')">
					<dl>
						<dt><%=BizboxAMessage.getMessage("TX000007033","시스템설정")%></dt>
						<dd><%=BizboxAMessage.getMessage("TX000016362","그룹정보등록  및")%><br/>
							<%=BizboxAMessage.getMessage("TX000016063","회사별 관리를 할 수 있습니다.")%></dd>
					</dl>
				</a>
			</div>
		</div>

		<div class="helpdesk mb10">
			<%-- <h2><%=BizboxAMessage.getMessage("TX000002971","고객만족센터")%></h2> --%>
			<h2>DT 온라인 고객센터</h2>
			<div class="helpdesk_btn controll_btn"><button onclick="fn_Helpdesk();"><%=BizboxAMessage.getMessage("TX000016277","문의글 등록")%></button></div>
		</div>			

		<div class="sm_bot">			
			<!-- 고객만족센터 -->
			<div class="sm_bot_left mr8">
				<div class="sys_notice">
					<h2 class="noticebg"><%=BizboxAMessage.getMessage("TX000003178","공지사항")%></h2>
					<%-- <a class="title_more" href="#n" title="<%=BizboxAMessage.getMessage("TX000006348","더보기")%>"><img src="<c:url value='/Images/ico/icon_Mmore.png' />" alt="더보기"/></a> --%>
					<!-- <div class="con">
						<dl>			
							<dt class="title"><a href="#" class="new">워크샵 참여에 대한 참여여부 설문조사</a><img src="../../../Images/ico/icon_new.png" alt="new"/></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>
							<dt class="title"><a href="#" class="new">워크샵 참여에 대한 참여여부 설문조사서를 올려드립니다. 워크샵 참여에 대한 참여여부 설문조사서를 올려드립니다.</a><img src="../../../Images/ico/icon_new.png" alt="new"/></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>			
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>			
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사서를 올려드립니다.</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>
						<dl>			
							<dt class="title"><a href="#">워크샵 참여에 대한 참여여부 설문조사</a></dt>
							<dd class="date">2015-08-30</dd>
						</dl>						
					</div> -->
					<!--<div class="sys_notice_no"><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></div> -->
					<div class="sys_notice_no">
						<p><a href="https://helpdesk.douzone.com/user/board/notice/listView.do?menuId=C001" target="_blank">온라인 고객센터의 공지사항 페이지 바로가기</a></p>
					</div>
					
				</div>
			</div>
			
			<!-- FAQ -->
			<div class="sm_bot_right">			
				<div class="sys_notice">
					<h2 class="faqbg">FAQ</h2>
					<%-- <a class="title_more" href="#n" title="<%=BizboxAMessage.getMessage("TX000006348","더보기")%>"><img src="<c:url value='/Images/ico/icon_Mmore.png' />" alt="더보기"/></a> --%>
					<!-- <div class="con">
						<dl>			
							<dt class="title"><a href="#" class="faq_wid">[일정] 워크샵 참여에 대한 참여여부 설문조사</a><img src="../../../Images/ico/icon_new.png" alt="new"/></dt>
						</dl>
						<dl>
							<dt class="title"><a href="#" class="faq_wid">[전자결재] 워크샵 참여에 대한 참여여부 설문조사서를 올려드립니다.워크샵 참여에 대한 참여여부 설문조사서를 올려드립니다.</a></dt>
						</dl>
						<dl>
							<dt class="title"><a href="#" class="faq_wid">[메일] 워크샵 참여에 대한 참여여부 설문조사</a></dt>
						</dl>
						<dl>
							<dt class="title"><a href="#" class="faq_wid">워크샵 참여에 대한 참여여부 설문조사</a></dt>
						</dl>
						<dl>			
							<dt class="title"><a href="#" class="faq_wid">워크샵 참여에 대한 참여여부 설문조사</a></dt>
						</dl>
					</div> -->
					<!-- <div class="sys_notice_no"><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></div>  -->
					<div class="sys_notice_no">
						<p><a href="https://helpdesk.douzone.com/user/board/question/listView.do?menuId=C002" target="_blank">온라인 고객센터의 FAQ 페이지 바로가기</a></p>
					</div>
				</div>
			</div>

		</div>
	</div>
	<!-- // main 콘텐츠 영역 end -->
