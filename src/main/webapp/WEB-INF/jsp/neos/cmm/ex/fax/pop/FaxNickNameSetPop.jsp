<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
	<%@page import="main.web.BizboxAMessage"%>


<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.84.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.min.js"></script>
   <script src="/gw/js/neos/NeosUtil.js"></script>
   
   
   <script type="text/javascript">
   		var faxSeq = "${faxSeq}";
   		var faxNo = "${faxNo}";   	
   		var nickName = "${nickName}";
   
	   $(document).ready(function() {
			pop_position();
			$(window).resize(function() { 
					pop_position();
			});
			
			$("#cnt").html(nickName.length);
		});
	   
	   
	   function fnClose(){
		   var puddDlgObj = window.parent.puddDlgObj;
			puddDlgObj.showDialog( false );
	   }
	   
	   
	   function fnSave(){
			var param = {};
			param.faxSeq = faxSeq;
			param.faxNo = faxNo
			param.nickName = $("#txtNickName").val();
			
			$.ajax({
				type: "POST"
					, contentType: "application/json; charset=utf-8"
					, url : "<c:url value='/api/fax/web/master/saveFaxNickName'/>"
					, data : JSON.stringify(param)
					, dataType : "json"
					, success : function(result) {
						parent.fnFaxNoListTableGrid();
						var puddDlgObj = window.parent.puddDlgObj;
						puddDlgObj.showDialog( false );
					}
			});
		}
	   
	   function fnKeyup(){
		   if(String($("#txtNickName").val()).length > 30)
			   $("#cnt").html(30);
		   else
		   	$("#cnt").html(String($("#txtNickName").val()).length);
	   }
	</script>
	</head>
	<body class="">
		<div class="pop_wrap_dir" style="width:467px;">
			<div class="pop_head posi_re">
				<h1><%=BizboxAMessage.getMessage("TX900000434","별칭 등록 및 수정")%></h1>
				<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
				<div class="posi_ab" style="top:8px;right:20px;">
					<input type="button" id="" class="puddSetup" style="" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave();"/>
					<input type="button" id="" class="puddSetup" style="" value="<%=BizboxAMessage.getMessage("TX000002972","닫기")%>" onclick="fnClose();"/>
				</div>
			</div>
			
			<div class="pop_con" style="">
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000402","별칭")%></th>
							<td class="pr0">
								<input type="text" class="puddSetup" pudd-style="width:83%" value="${nickName}" id="txtNickName" maxlength="30" onkeyup="fnKeyup();"/>
								<span class="dp_ib text_gray vb">(<span id="cnt" class="">0</span>/30)</span>
							</td>
						</tr>
					</table>	
				</div>

				<div class="mt10">
					<div><%=BizboxAMessage.getMessage("TX900000433","※ 입력 글자수는 띄어쓰기 및 기호 포함 글자 수 <span class='text_red'>30자 이내</span>로 등록 가능합니다.")%></div>
				</div>
			</div>
		</div>
		<div class="modal"></div>
	</body>
</html>