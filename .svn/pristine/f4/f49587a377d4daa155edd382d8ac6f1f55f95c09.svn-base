<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	$(document).ready(function(){
		
		var content = "<%=BizboxAMessage.getMessage("","매월 {0}일은 비밀번호 만료 일자입니다.")%>" + "<br>" + "<%=BizboxAMessage.getMessage("","비밀번호 만료 후 비밀번호 변경이 필요합니다.")%>"
		content = content.replace("{0}", "${inputAlertValue}");
		$("#contents").html(content);

		fnResizeForm();
	});

	function fnPasswordNext(){
		opener.location.href = "/gw/forwardIndex.do?passwdNext=Y";
		self.close();
	}

	/* [ 사이즈 변경 ] 옵션 값에 따른 페이지 리폼
	-----------------------------------------------*/
	function fnResizeForm() {

		var strWidth = $('.pop_wrap').outerWidth()
		+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);

		$('.pop_wrap').css("overflow","auto");

		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;

		if(isFirefox){

		}if(isIE){

		}if(isEdge){

		}if(isChrome){
		}

		try{
			var childWindow = window.parent;
			childWindow.resizeTo(strWidth, strHeight);
		}catch(exception){
			console.log('window resizing cat not run dev mode.');
		}

	}

</script>

<form id="checkMessage" name="checkMessage" method="post" target="new_popup">
	<input type="hidden" id="resultMessage" name="resultMessage" value=""/>
	<input type="hidden" id="resultContent" name="resultContent" value=""/>
</form>

<input id="type" name="type" type="hidden" value="def"></input>
<input id="type" name="passChangeOption" type="hidden" value="Y"></input>

<div class="pop_wrap password_change2">
	<div id="dialog-form-background" style="display:none; background-color:#FFFFDD;filter:Alpha(Opacity=50); z-Index:8888; width:100%; height:100%; position:absolute; top:1px; cursor:wait" ></div>
	<div class="pop_head">
		<h1 id="title"><%=BizboxAMessage.getMessage("","비밀번호 만료 안내")%></h1>
	</div>
	<!-- //pop_head -->
	<div class="pop_con">
		<div id="contents" style="text-align: center;line-height: 20px;height: 51px;padding-top: 95px;background: url(/gw/Images/bg/error_indexbg.jpg) no-repeat center 15px;"></div>
	</div>

	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" onclick="fnPasswordNext();" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<!-- //pop_wrap -->

