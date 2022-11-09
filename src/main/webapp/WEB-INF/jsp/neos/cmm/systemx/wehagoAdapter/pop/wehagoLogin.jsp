<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="https://static.wehago.com/support/wehagoLogin-1.0.5.min.js" charset="utf-8"></script>

<body>

<div class="pop_wrap" style="border: none;">
	<div class="pop_head">
		<h1>WEHAGO 계정 그룹웨어 연동</h1>
	</div>	
	
	<div class="pop_con" style="padding-top: 40px;">

		<!-- 위하고 호출 -->
		<div style="width:100%;">
		
		    <!-- 위하고 아이디로 로그인 버튼 노출 영역 -->
		    <div id="wehago_id_login" style="text-align:center;"></div>
		    <!-- // 위하고 아이디로 로그인 버튼 노출 영역 -->
		    <script type="text/javascript">
		        // 설정정보를 초기화하고 연동을 준비
		        var wehago_id_login = new wehago_id_login({
		            app_key: "4B6250655368566D597133743677397A",  			// AppKey
		            service_code: "bizbox",						  			// ServiceCode
		            redirect_uri: window.location.origin + "/gw/systemx/wehagoLoginCallback.do",  	// Callback URL
		            mode: "${mode}",
		        });
		
		        var state = wehago_id_login.getUniqState();
		        wehago_id_login.setButton("white", 1, 40);
		        wehago_id_login.setDomain(window.location.origin);
		        wehago_id_login.setState(state);
		        wehago_id_login.setPopup();  // 위하고 로그인페이지를 팝업으로 띄울경우
		        wehago_id_login.init_wehago_id_login();
		    </script>
		
		</div>
		
	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="puddSetup" onclick="self.close();" value="취소" />
		</div>
	</div><!-- //pop_foot -->
</div><!--// pop_wrap -->





</body>