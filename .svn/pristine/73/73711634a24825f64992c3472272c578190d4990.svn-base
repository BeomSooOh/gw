<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="https://static.wehago.com/support/wehagoLogin-1.0.5.min.js" charset="utf-8"></script>


<script type="text/javascript">
    // 설정정보를 초기화하고 연동을 준비
    var wehago_id_login = new wehago_id_login({
        app_key: "4B6250655368566D597133743677397A",  			// AppKey
        service_code: "bizbox",						  			// ServiceCode
        redirect_uri: window.location.origin + "/gw/systemx/wehagoLoginCallback.do",  	// Callback URL
        mode: "${mode}",										// dev-개발, live-운영 (기본값=live, 운영 반영시 생략 가능합니다.)
    });

    wehago_id_login.get_wehago_userprofile("wehagoSignInCallback()");

    // 위하고 사용자 프로필 조회 이후 프로필 정보를 처리할 callback function
    function wehagoSignInCallback() {
    	
    	var wehago_id = wehago_id_login.getProfileData('wehago_id');
    	var user_no = wehago_id_login.getProfileData('user_no');
    	
        $("#_wehago_id").text(wehago_id);
        $("#_user_no").text(user_no);
        
       	var tblParam = {};
       	
       	tblParam.wehagoId = wehago_id;
       	tblParam.userNo = user_no;
       	
       	$.ajax({
       			type:"post",
       			url:'/gw/systemx/wehagoSignInCallback.do',
       			datatype:"text",
       			data:tblParam,
       			success:function(data){
       				
       				if(data.resultCode == "success"){
       					alert("그룹웨어계정과 연결이 완료되었습니다.");
       				}else{
       					alert("로그인하신 WEHAGO계정은 그룹웨어와 연결된 계정이 아닙니다.");
       				}
       				
       				//self.close();
       				
       			}
       	});		
        
    }

</script>

<body>

<div class="pop_wrap" style="border: none;">
	<div class="pop_head">
		<h1>WEHAGO 로그인</h1>
	</div>
	
	<div class="pop_con">
	
		<div class="p15 mb15 lh20" style="background:#f2f2f2;">
			<p class="text_blue fwb">[WEHAGO 계정정보]</p>
		    <div style="padding: 5px;">WEHAGO ID : <label id="_wehago_id"></label> / USER NO : <label id="_user_no"></label></div>
		    <div style="padding: 5px;"></div>		
		</div>	
		
	</div><!--// pop_con -->	
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="puddSetup" onclick="self.close();" value="취소" />
		</div>
	</div><!-- //pop_foot -->	

</div><!--// pop_wrap -->

</body>





