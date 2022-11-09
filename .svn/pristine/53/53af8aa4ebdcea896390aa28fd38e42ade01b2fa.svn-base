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
		var title = "${title}";
		var content = "${content}";

		if(content == "") {
			$(".Pop_border").hide();
		}

		if(title == "<%=BizboxAMessage.getMessage("TX000022470","필수 입력 값이 입력 되지 않았습니다.")%>") {
			$(".p10").removeClass("Pop_border");
			$(".p10").css("text-align", "center");
		} else if(title == "<%=BizboxAMessage.getMessage("TX000022476","비밀번호가 정상적으로 변경되었습니다.")%>") {
			opener.window.close();
		}


		$("#title").html(title);
		$("#content").append(content);


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
		<div class="fwb ac">
		    <p class="Alertbg lh18 al" id="title"></span></p>
	    </div>

	    <div class="Pop_border p10"><!-- style="margin:10px 60px;" -->
		    <ul class="pl20 lh20" id="content">
<!-- 		    <li>- 최소 <span class="text_blue">8</span>자리 이상 <span class="text_blue">16</span>자리 이하로 입력해 주세요.</li>
		    <li>- <span class="text_blue">숫자, 영문(소문자)</span>를 포함해 주세요.</li>
		    <li>- <span class="text_blue">생년월일, 아이디</span>가 포함되어 있습니다.</li> -->
		    </ul>
	    </div>



<!-- 		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<div class="Alertbg">
						<div class="result_con">

							<dt id="content" class="lh18"></dt>
							<dd class="fwb detail lh18 Pop_border p15" id="result" style="margin:5px 0 0 -40px;"></dd>
						</dl>
					</div>
					<div class="fl fwb detail lh18 Pop_border p15" id="result"></div>
				</td>
			</tr>
			<tr>
				<td>
					<span class="fl fwb detail lh18 Pop_border p15" id="result"></span>
				</td>
			</tr>
		</table> -->
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000019752","확인")%>" id="btnOk" />
		</div>
	</div>
</div>

