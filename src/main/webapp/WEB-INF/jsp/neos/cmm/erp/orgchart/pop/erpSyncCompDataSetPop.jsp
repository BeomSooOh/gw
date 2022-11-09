<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

	<script type="text/javascript">
		var type = 0; //0:초기화,  10: 사업장, 20: 부서 신규, 21:부서 삭제, 30:사원입사, 31:사원정보수정, 32:사원퇴사, 33:사원휴직, 40:사원회사정보
	
	
		$(document).ready(function() {	
			
			<c:if test="${params.resultCode < 1}">
				<c:if test="${params.resultCode == -1}">
					alert('<%=BizboxAMessage.getMessage("TX900000405","ERP 회사 연동 정보가 잘못되었습니다.")%>');
				</c:if>
				window.close();
			</c:if>
			console.log('${params.loginIdType}');
			
			
			
			
			//탭
			$("#tabstrip").kendoTabStrip({
				animation:  {
					open: {
						effects: ""
					}
				}
			});
			
			//기본버튼
           $(".controll_btn button").kendoButton();
			
			
			$("#btnApplyComp").on("click",function(e) {
					
					saveTempComp();
				
			}); 
			
			$("#btnSave").on("click",function(e) {
				
				var message = '<%=BizboxAMessage.getMessage("TX000021945","저장하시겠습니까?\\n(오류 항목은 반영되지 않습니다)")%>';
				if(confirm(message)) {
					 $("#page").val("1");
					 saveComp();
				}
				
			});
			
			$("#btnSearch").on("click",function(e) {
				getCompList();
				
			});
			
			$("#btnCancel").on("click",function(e) {
				fnclose();
			});			
			
			$("#btnNext").on("click",function(e) {
				
				var listType = $("#orgListType").val();
				
				if (listType == 'erp') {
					alert('<%=BizboxAMessage.getMessage("TX000021946","조직도 연동 설정 완료 후\\n 다음 Step으로 이동 가능 합니다.")%>');
					
				} else {
					var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");
					tabStrip.select(tabStrip.tabGroup.children("li").eq(1));
				
					$("#btnNext").hide();
				}
			});
			
			getCompList();
		 
		});
		
		function saveComp() {
			$("#uploadSpin").show();
			
  			var data = jQuery("#orgForm").serialize();
			$.ajax({ 
	 			type:"post",
	 			url:"erpSyncCompSaveProc.do",
	 			datatype:"json",
	 			data: data,
	 			success:function(data){
	 				if(data.resultCode == null || data.resultCode == '') {
	 					alert("data.resultCode : " + data.resultCode);
	 					$("#uploadSpin").hide();
	 				} else if(data.resultCode == '99') {
		 				$("#compJoinTotalCount").val(data.compJoinTotalCount||'0');
		 				$("#compModifyTotalCount").val(data.compModifyTotalCount||'0');
	 				} else {
	 					//$("#uploadSpin").hide();
	 				}
	 				$("#uploadSpin").hide();
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 				alert("saveComp error");	
	 			}
	 		});	
			
			
		}
		
		function fnclose(){
			self.close();
		}			
		
		function checkAll(box) {
			$("input[name=noEmp]:checkbox").prop("checked", $(box).prop("checked"));
		}
		 
		
		function chkFirstApply() {
			var message = null;
			 $.ajax({
	 			type:"post",
	 			url:"erpSyncChkFirstApply.do",
	 			datatype:"json",
	 			async:false,
	 			data: {groupSeq:$("#groupSeq").val(),compSeq:$("#compSeq").val()},
	 			success:function(data){
	 				message = data.result;
	 				$("#firstYn").val(data.firstYn);
	 			},			
	 			error : function(e){
	 				alert("error");	
	 			}
	 		});	 
			 
			return message;
		}
		
		function fn_list(currentPage){	
		   $("#page").val(currentPage);
		   getCompList();
		}
		
		function getCompList() {
  			$("#uploadSpin").show();
			
  			var data = jQuery("#orgForm").serialize();
  			
			$.ajax({ 
	 			type:"post",
	 			url:"erpSyncCompList.do",
	 			datatype:"json",
	 			data: data,
	 			success:function(data){
	 				$("#divCompList").html(data);
	 				$("#uploadSpin").hide();
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 				alert("getCompList error");	
	 			}
	 		});	
		}
		
		function saveTempComp() {
  			$("#uploadSpin").show();
  			
  			// 일부 선택 결과보기
  			// setNoEmpList();
			
  			var data = jQuery("#orgForm").serialize();
  			
			$.ajax({ 
	 			type:"post",
	 			url:"erpSyncCompTempSaveProc.do",
	 			datatype:"json",
	 			data: data,
	 			success:function(data){
	 				if(data.resultCode == null || data.resultCode == '') {
	 					alert("data.resultCode : " + data.resultCode);
	 					$("#uploadSpin").hide();
	 				} else if(data.resultCode == '0') {
	 					
	 					$("#page").val(parseInt($("#page").val())+1);
	 					$("#syncSeq").val(data.syncSeq);
	 					
	 					saveTempComp();
	 					
	 				} else if(data.resultCode == '99') {
	 					$("#listType").val("temp");
	 					$("#uploadSpin").hide();
	 					alert('<%=BizboxAMessage.getMessage("TX000022275","저장 되었습니다.")%>');
	 					$("#page").val("1");
	 					getCompList();
	 					
	 				} else {
	 					$("#uploadSpin").hide();
	 				}
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 				alert("saveTempComp error");	
	 			}
	 		});	
		}
		
		/* function  setNoEmpList(){
			var list = $("input[name=noEmp]:checked");
			var noEmpList = "";
			for(var i = 0; i < list.length; i++) {
				noEmpList += "'"+list[i].value+"'";
				if(i < list.length-1) {
					noEmpList +=",";
				}
			}
			$("#noEmpList").val(noEmpList);
		} */
	</script>
	
	<form id="orgForm" name="orgForm">
		<input type="hidden" id="page" name="page" value="1" />
		<input type="hidden" id="orgListType" name="orgListType" value="erp" />
		<input type="hidden" id="listType" name="listType" value="erp" />
		<input type="hidden" id="groupSeq" name="groupSeq" value="${params.groupSeq}" />
		<input type="hidden" id="erpSyncTime" name="erpSyncTime" value="${params.erpSyncTime}" />
		<input type="hidden" id="syncSeq" name="syncSeq" value="${params.syncSeq}" />
		<input type="hidden" id="loginIdType" name="loginIdType" value="${params.loginIdType}" />
		<input type="hidden" id="startSyncTime" name="startSyncTime" value="${params.startSyncTime}" />
		<input type="hidden" id="endSyncTime" name="endSyncTime" value="${params.endSyncTime}" />
		<input type="hidden" id="firstYn" name="firstYn" value="${params.firstYn}" />
		<input type="hidden" id="compJoinTotalCount" name="compJoinTotalCount" value="0" />
		<input type="hidden" id="compModifyTotalCount" name="compModifyTotalCount" value="0" />
		
	<div class="pop_wrap" style="width:900px;height:780px">  
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX900000406","ERP Data 연동 설정")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		</div>	
			
		<div class="pop_con">
			<div class="tab_set">
				<div class="tab_style" id="tabstrip">
					<!-- tab -->
					<ul>
						<li class="k-state-active"><%=BizboxAMessage.getMessage("TX900000408","ERP 회사 연동")%></li>
					</ul>
					
					<!-- ERP회사연동 -->
					<div class="tab4 ovh">
						<div class="btn_div m0 pt10 pb10 pl15 pr15 borderB">
							<div class="left_div">
								<div class="trans_top_btn">
									<div class="option_top">
										<ul>
											<li class="text_blue" id="idOptionValue"></li>
										</ul>
									</div>
								</div>
							</div>
							<div class="right_div">
								<div id="" class="controll_btn p0">
									<button id="btnApplyComp" type="button" ><%=BizboxAMessage.getMessage("TX000021947","결과확인")%></button>
									<!-- <button id="">반영</button> -->
								</div>
							</div>
						</div>
						
						<div id="" class="pl15 pr15 pb15 clear"  style="min-height:539px;">
						
							<div class="trans_top_btn mt10 mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li"><%=BizboxAMessage.getMessage("TX900000407","ERP 회사목록")%></li>
									</ul>
								</div>
							</div>
							<div class="top_box pr10 mb10">
								<!-- <dl>
									<dt>부서명</dt>
									<dd><input id="deptName" name="deptName" type="text" style="width:150px;" value="" onkeydown="if(event.keyCode==13){javascript:getCompList();}"/></dd>
									<dt>사원명</dt>
									<dd><input id="empName" name="empName" type="text" style="width:150px;" value="" onkeydown="if(event.keyCode==13){javascript:getCompList();}"/></dd>
									<dd><input type="button" id="btnSearch" value="검색" /></dd> 
								</dl> -->
								<div id="uploadSpin" style="position: relative;display:none; left:350px; top:300px;"><strong class="k-upload-status k-upload-status-total"><spna id="uploadSts"></spna>Loading...<span class="k-icon k-loading"></span></strong></div>
							</div> 
							
							<div id="divCompList" style="">
							
							</div>
							
						</div>
					</div>
		
				</div><!--// tab_style -->
			</div><!--// tab_set -->
		</div><!--// pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" id="btnCancel" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
				<input type="button" class="" id="btnSave" value="<%=BizboxAMessage.getMessage("TX000001288","완료")%>" />
			</div>
		</div><!-- //pop_foot -->
	</div><!--// pop_wrap -->
		</form>