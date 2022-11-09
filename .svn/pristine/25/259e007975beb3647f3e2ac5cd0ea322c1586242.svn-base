<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	$(document).ready(function() {
		// 버튼 이벤트 초기화
		fnButtonInit();
	});
	
	// 버튼 이벤트 초기화
	function fnButtonInit() {
		$("#ok").click(function() {
			var selectExcelRange = $("input[name='radi']:checked").val();
			
			fnExcelDownlod(selectExcelRange);
		});
		
		$("#cancel").click(function() {
			fnCancel();
		});
	}
	
	// 엑셀 다운로드
	function fnExcelDownlod(selectExcelRange) {
		self.location.href="/gw/cmm/systemx/userInfoExcelExport.do?selectExcelRange=" + selectExcelRange;		
	}
	
	// 취소버튼
	function fnCancel() {
		self.close();
	}
</script>

<div class="pop_wrap" style="width:368px;">
	<div class="pop_head">
		<h1>Bizbox Alpha</h1>
	</div><!-- //pop_head -->
	
	<div class="pop_con">
		<p class="mb10 fwb"><%=BizboxAMessage.getMessage("TX900000491","※ 저장할 범위를 선택하세요")%></p>
		<div class="top_box">
			<div class="top_box_in">
				<input type="radio" id="radi1" name="radi" class="ml50" checked="checked" value="myComp"/>
				<label for="radi1"><%=BizboxAMessage.getMessage("TX900000490","내 회사")%></label>
				<input type="radio" id="radi2" name="radi" class="ml50" value="allComp"/>
				<label for="radi2"><%=BizboxAMessage.getMessage("TX000022006","전체회사")%></label>
			</div>
		</div>
	</div><!-- //pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="ok" name="" class="" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
			<input type="button" id="cancel" name="" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->