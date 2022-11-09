<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>


<script type="text/javascript">
	$(document).ready(function() {
		var result = "${result}";
		var content = "${content}";
		
		$("#result").html(result);
		$("#content").html(content);
		
		$("#btnOk").click(function() {
			window.close();
		});
		
		fnResizeForm();
	});
	
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

<div class="pop_wrap color_pop_wrap" style="width:518px;">
	<div class="pop_head">
		<h1>Bizbox Alpha</h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class="Alertbg" style="background-position:0 35%;">
						<dl class="result_con">
							
							<dt id="content"></dt>
							<dd class="fwb detail">[ <span class="text_blue" id="result"></span> ]</dd>
						</dl>
					</span>		
				</td>
			</tr>
		</table>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000019752","확인")%>" id="btnOk" />
		</div>
	</div>
</div>

