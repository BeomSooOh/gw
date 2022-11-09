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
	$(document).ready(function(){

	var slider = $('.bxslider').bxSlider({
		auto: true,        // 자동 실행 여부
		controls: false,   // 좌,우 컨트롤 버튼 숨기기/보이기
		speed: 700,        // 이동 속도를 설정	
		pause: 5000,     // 이미지 변환속도
		mode: 'fade',     // 가로 방향 수평 슬라이드 (horizontal(좌우), vertical(상하)', 'fade(제자리)') 
		autoHover: true,  // 마우스 오버시 정지
		//pager:true,        // 하단 이미지 보기 버튼 
		//controls:false,      // 좌,우 컨트롤 버튼 숨기기/보이기
		//autoControls:false,  //  슬라이드 시작/멈춤 
		onSliderLoad: function () {
			$('.bx-pager-link').click(function () {
				var i = $(this).data('slide-index');
				slider.goToSlide(i);
				slider.stopAuto();
				slider.startAuto();
				return false;
			});
		}
	});
});
</script>
	
<style>
.bx-wrapper .bx-viewport {border:5px solid #82c0ed; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
</style>

<div class="Mbanner">	
	<ul class="bxslider">
		<li><a href="http://www.duzon.com/product/erp/erp01_smarta_01" target="_blank" class="Mbanner_line"><img src="<c:url value='/Images/temp/Mbanner_L_01.png' />" alt="" /></a></li>
		<li><a href="http://www.duzon.com/company/about/about01_idea_01" target="_blank" class="Mbanner_line2"><img src="<c:url value='/Images/temp/Mbanner_L_02.png' />" alt="" /></a></li>
		<li><a href="http://www.duzon.com/company/about/about01_idea_01" target="_blank"><img src="<c:url value='/Images/temp/Mbanner_L_03.png' />" alt="" /></a></li>
		<li><a href="http://www.duzon.com/company/ir_info/ir_info01_info_01" target="_blank"><img src="<c:url value='/Images/temp/Mbanner_L_04.png' />" alt="" /></a></li>	 
	</ul>
<div>