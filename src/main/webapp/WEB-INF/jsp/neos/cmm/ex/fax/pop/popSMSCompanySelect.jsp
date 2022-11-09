<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<%
	String smsCompSeqList = request.getParameter("smsCompSeqList").toString();
%>

	<script type="text/javascript">
		var smsCompSeqList = "<%= smsCompSeqList %>";
	
		$(document).ready(function() {	
			//기본버튼
			$(".controll_btn button").kendoButton();
			
			// 회사목록 가져오기
			fnGetCompanyList();
			
			// 버튼 이벤트
			fnButtonEvent();
		}); 
		
		// 회사 목록 가져오기
		function fnGetCompanyList() {
			var param = {};
			param.gubun = "compName";
			param.search = $("#searchCompName").val();
			$.ajax({
				type: "POST"  
				, url :"<c:url value='/api/fax/web/master/getFaxComp'/>"
				, data : param
				, dataType : "json"
				, success : function(result) {
					fnGetCompanyListDraw(result.faxComp);
					console.log(JSON.stringify(result.faxComp));
				},
				error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:"
							+ request.responseText + "\n" + "error:" + error);
				}
			});
		}
		
		// 회사 목록 그려주기
		function fnGetCompanyListDraw(data) {
			var length = data.length; 
			var tag = '';
			
			if(length =="0") {
				
			} else {
				for(var i=0; i<length; i++) {
					tag += '<tr>';
					tag += '<td>';
					tag += '<input type="checkbox" class="check_compList" id="' + data[i].comp_seq + '" value="' + data[i].comp_seq + '|' + data[i].comp_name + '" />';
					tag += '</td>';
					tag += '<td>' + data[i].comp_name + '</td>';
					tag += '<td>' + data[i].sms_id + '</td>';
					tag += '</tr>';
				}
			}
			
			$("#compList").html(tag);
			
			if(length > 0) {
				fnCheckEvent();	
			}
			
		}
		
		// 기존 회사 체크
		function fnCheckEvent() {
			var smsCompSeqArray = smsCompSeqList.split("|");
			
			for(var i=0; i<smsCompSeqArray.length; i++) {
				$("#compList input[type='checkbox']").each(function(){
					if(smsCompSeqArray[i] == $(this).attr("id")) {
						$(this).prop("checked", true);
					} 
				});
			}
		}
		
		// 버튼 이벤트 등록
		function fnButtonEvent() {
			$("#cancelButton").click(function(){
				fnCancelButton();
			});
			
			$("#okButton").click(function(){
				fnOkButton();
			});
			
			$("#searchButton").click(function() {
				fnGetCompanyList();
			});
			
			$("#searchCompName").keydown(function(e) { 
				if (e.keyCode == 13) {
					fnGetCompanyList();
				}
			});
			
			$("#allCheck").click(function(){
				if($(this).prop("checked")){
					$(".check_compList").prop("checked", true);
				} else {
					$(".check_compList").prop("checked", false);
				}
			});
		}
		
		// 저장버튼 클릭
		function fnOkButton() {
			var compArray = new Array();
			
			$("#compList input:checkbox").each(function(){
				var info = {};
				if($(this).prop("checked")) {
					info.compSeq = $(this).val().split("|")[0];
					info.compName = $(this).val().split("|")[1];
					compArray.push(info);
				}
				
			});
			window.close();
			opener.fnCallBack(compArray);
			
		}
		
		// 취소버튼 클릭
		function fnCancelButton() {
			window.close();
		}
	</script>

<div class="pop_wrap" style="538px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000005664","회사선택")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con div_form">
		<!-- 검색영역 -->
		<div class="top_box pr10">
			<dl>
				<dt><%=BizboxAMessage.getMessage("TX000000018","회사명")%></dt>
				<dd><input id="searchCompName" type="text" style="width:150px;" value=""/></dd>
				<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
			</dl>
		</div>

		<!-- 테이블 -->
		<div class="com_ta2 mt14">
			<table>
				<colgroup>
					<col width="34">
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" id="allCheck"/></th>
						<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
						<th><%=BizboxAMessage.getMessage("TX000016276","문자/팩스 계정")%></th>
					</tr>
				</thead>
			</table>		
			</div>

			<div class="com_ta2 scroll_y_on bg_lightgray" style="height:333px;">
			<table class="brtn">
				<colgroup>
					<col width="34" />
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tbody id="compList">
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000001</td> -->
<!-- 						<td>더존비즈온</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000002</td> -->
<!-- 						<td>더존다스</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000001</td> -->
<!-- 						<td>더존비즈온</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000002</td> -->
<!-- 						<td>더존다스</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000001</td> -->
<!-- 						<td>더존비즈온</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000002</td> -->
<!-- 						<td>더존다스</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000001</td> -->
<!-- 						<td>더존비즈온</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000002</td> -->
<!-- 						<td>더존다스</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000001</td> -->
<!-- 						<td>더존비즈온</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<td><input type="checkbox" /></td> -->
<!-- 						<td>000001</td> -->
<!-- 						<td>더존비즈온</td> -->
<!-- 					</tr> -->
				</tbody>
			</table>		
		</div>
	

	</div><!--// pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="okButton" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
			<input type="button" id="cancelButton" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->
