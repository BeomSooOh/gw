<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script>

<script type="text/javascript">
	$(document).ready(function() {
	// quick
		$("#Mquick").als({
			visible_items: 5,
			scrolling_items: 1,
			orientation: "horizontal",
			circular: "yes",
			autoscroll: "yes",
			interval: 5000,
			direction: "left"
		});	
	});	
</script>

<div class="main_quick">
	<div id="Mquick">
		<span class="als-prev"><img src="<c:url value='/Images/btn/btn_quick_prev.png' />" alt="이전" /></span>
		<div class="als-viewport">
			<ul class="als-wrapper">
				<li class="als-item"><a href="http://www.duzon.com/edusemina/new_company/newc01_main" target="_blank"><img src="<c:url value='/Images/temp/quick01.png' />" alt="신설법인 경영도우미" /></a></li>
				<li class="als-item"><a href="http://www.duzon.com/company/media/media01_notice_01?type=view&articleNum=425&pageNumber=1&rowNum=1" target="_blank"><img src="<c:url value='/Images/temp/quick02.png' />" alt="더존홈페이지 개편안내" /></a></li>
				<li class="als-item"><a href="http://smart.eduzon.co.kr/course/course_view.asp?CourseSeq=471&CourseCode=&ClassCode=&ModuleNum=01&LessonNum=&SetClassCode=A01002&AttendSeq=&SessionID=689564792&UserID=&UserSeq=&mKey=&ConWidth=&ConHeight=&ConPlayer=&PreviewFlag=&src=image&kw=00001B" target="_blank"><img src="<c:url value='/Images/temp/quick03.png' />" alt="2015년 부가가치세신고 실무강좌" /></a></li>
				<li class="als-item"><a href="http://www.duzon.com/company/media/media06_event_08" target="_blank"><img src="<c:url value='/Images/temp/quick04.png' />" alt="하계직무연수 안내" /></a></li>
				<li class="als-item"><a href="http://www.duzon.com/company/media/media06_event_06" target="_blank"><img src="<c:url value='/Images/temp/quick05.png' />" alt="더존 Smart A 클라우드 에디션 7가지 효익" /></a></li>
				<li class="als-item"><a href="http://www.duzon.com/company/support/support01_info_01" target="_blank"><img src="<c:url value='/Images/temp/quick06.png' />" alt="더존 전국  IT 코디센터" /></a></li>
				<li class="als-item"><a href="http://www.duzon.com/product/efax/efax01_green_01" target="_blank"><img src="<c:url value='/Images/temp/quick07.png' />" alt="더존 그린팩스" /></a></li>
				<li class="als-item"><a href="https://as.duzon.co.kr/seminar/seminar159.asp" target="_blank"><img src="<c:url value='/Images/temp/quick08.png' />" alt="통합정보화 솔루션구축 방안 세미나" /></a></li>
				<li class="als-item"><a href="https://as.duzon.co.kr/seminar/seminar158.asp" target="_blank"><img src="<c:url value='/Images/temp/quick09.png' />" alt="정보화 추진 전략 세미나" /></a></li>
				<li class="als-item"><a href="https://as.duzon.co.kr/qna/qna_01.asp?cd_board=0002&cd_service=0014" target="_blank"><img src="<c:url value='/Images/temp/quick10.png' />" alt="더존 온라인 고객센터" /></a></li>
				<li class="als-item"><a href="http://duzon.ygoon.com/" target="_blank"><img src="<c:url value='/Images/temp/quick11.png' />" alt="더존 임직원할인몰" /></a></li>
			</ul>
		</div>
		<span class="als-next"><img src="<c:url value='/Images/btn/btn_quick_next.png' />" alt="다음" /></span>
	</div>
</div>