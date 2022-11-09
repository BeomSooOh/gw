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
		// 배너슬라이드
		 $('.Mbanner_Bic').bxSlider({
			  auto: true,       // 자동 실행 여부
			  autoHover: true,  // 마우스 오버시 정지
			  mode: 'fade',// 가로 방향 수평 슬라이드 (horizontal(좌우), vertical(상하)', 'fade(제자리)') 
			  autoHover: true,  // 마우스 오버시 정지
			  pager:false,        // 하단 이미지 보기 버튼 
			  pause: 10000,     // 이미지 변환속도
			  speed: 700        // 이동 속도를 설정		  
		  });
		});
</script>


<div>	
	<ul class="Mbanner_Bic">
		<li><a href="http://www.duzon.com/product/groupware/gw01_biz_01" target="_black"><img src="<c:url value='/Images/temp/main_img01.png' />" alt="" /></a></li>
		<li><a href="http://www.duzon.com/product/erp/erp02_icube_01" target="_black"><img src="<c:url value='/Images/temp/main_img02.png' />" alt="" /></a></li> 
	</ul>
</div>
