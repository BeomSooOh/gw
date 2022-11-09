<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
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
	});
	
	</script>	


	<!-- main 콘텐츠 영역 -->
	<div class="system_main" style="min-height: 0px;">
		
		<div class="sm_top mb8">			
			<!-- 회사정보 -->
			<div class="sm_top_left mr8">
				<div class="company_name">
					<div class="user_pic">
						<div class="bg_pic"></div>
						<span class="img_pic">
							<img class="userImg" src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" alt="" onerror="this.src='Images/temp/pic_Noimg.png'" />
						</span>				
					</div>

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
						
			<!-- 상세메뉴영역 -->			
			<div class="sm_top_cen" style="width:724px;">
				<div class="admin_txt">
					<div class="con"><span style="color:#0b6ab2;">‘<%=BizboxAMessage.getMessage("TX000010138","관리자페이지")%>’</span><%=BizboxAMessage.getMessage("TX000000772","입니다.")%><br>&nbsp;&nbsp; <%=BizboxAMessage.getMessage("TX000007347","상세메뉴를 선택하세요")%></div>
				</div>
			</div>
		</div>
	</div>
	<!-- // main 콘텐츠 영역 end -->
