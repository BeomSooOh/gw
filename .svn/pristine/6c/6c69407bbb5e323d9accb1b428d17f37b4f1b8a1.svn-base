<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
		$(document).ready(function() {	
			
			popupAutoResize();
			
			<c:if test="${params.resultCode < 1}">
				<c:if test="${params.resultCode == -1}">
					alert("<%=BizboxAMessage.getMessage("TX900000212","연동된 정보가 없습니다.")%>\n<%=BizboxAMessage.getMessage("TX900000213","연동정보를 확인하여 주세요.")%>");
				</c:if>
				window.close();
			</c:if>

			//탭
			var tab = $("#tabstrip").kendoTabStrip({
				animation:  {
					open: {
						effects: ""
					}
				},
				select:function(e) {
					popupAutoResize();
				}
			});
			
			// 근무구분 코드 맵핑
			<c:if test="${not empty syncWorkCodeList}">
				<c:forEach items="${syncWorkCodeList}" var="list" varStatus="c">
					$("#gw_code_sel${c.count}").kendoComboBox({
				        dataSource : {
							data : ${gwWorkCodeListJson}
				        },
				        dataTextField: "gwCodeName",
				        dataValueField: "gwCode",
				        <c:if test="${not empty list.gwCode}">
				        value:'${list.gwCode}'
				        </c:if>
				        <c:if test="${empty list.gwCode}">
				        value:999
				        </c:if>
				        
				    });
				</c:forEach>
			</c:if>
			
			// 상용직
			<c:if test="${not empty syncRegularCodeList}">
				<c:forEach items="${syncRegularCodeList}" var="list" varStatus="c">
					$("#gw_li_re_sel${c.count}").kendoComboBox({
				        dataSource : {
							data : ${licenseListJson}
				        },
				        dataTextField: "gwCodeName",
				        dataValueField: "gwCode",
				        enable:true,
				        <c:if test="${not empty list.gwCode}">
				        value:'${list.gwCode}'
				        </c:if>
				        <c:if test="${empty list.gwCode}">
				        value:1
				        </c:if>
				    });
				</c:forEach>
			</c:if>
			
			// 일용직
			<c:if test="${not empty syncDayCodeList}">
				<c:forEach items="${syncDayCodeList}" var="list" varStatus="c">
					$("#gw_li_day_sel${c.count}").kendoComboBox({
				        dataSource : {
							data : ${licenseListJson}
				        },
				        dataTextField: "gwCodeName",
				        dataValueField: "gwCode",
				        enable:true,
				        <c:if test="${not empty list.gwCode}">
				        value:'${list.gwCode}'
				        </c:if>
				        <c:if test="${empty list.gwCode}">
				        value:1
				        </c:if>
				    });
				</c:forEach>
			</c:if>
			
			//기본버튼
           $(".controll_btn button").kendoButton();
		
			$("#saveBtn").on("click", function(e) {
				/* var info = "ERP 설정한 정보로 기초 설정 연동 됩니다.\n저장 하시겠습니까?"; */
				var info = '<%=BizboxAMessage.getMessage("TX000021966","설정된 기초 정보 값을 변경하시겠습니까?\\n변경 시 기존 정보 삭제되며,\\n변경된 정보로 재 반영됩니다.")%>';
				if(confirm(info) == true) {
					makeData();
					$("#form").submit();
				}
			});
			
			$("#cancelBtn").on("click", function(e) {
				var info = '<%=BizboxAMessage.getMessage("TX000021967","기초설정이 완료되어야\\n조직도 동기화를 사용 가능합니다.\\n설정을 취소하시겠습니까?")%>';
				if(confirm(info) == true) {
					window.close();
				}
			});
		
		});
		
		function makeData() {
			var data = {};
			var codeList = [];
			var msg = '<%=BizboxAMessage.getMessage("TX900000214","연동된 정보가 없습니다.\\n연동정보를 확인하여 주세요.")%>';
			
			var erpCode10 = $("input[name=erpCode10]");
			var gwCode10= $("input[name=gwCode10]");
			var erpCodeName10= $("input[name=erpCodeName10]");
			var isCheck = false; // 하나라도 선택되어야 한다.
			for(var i = 0; i < erpCode10.length; i++) {
				var code={};
				code.erpCode=erpCode10[i].value;
				code.gwCode=gwCode10[i].value;
				code.erpCodeName =erpCodeName10[i].value;
				code.codeType="10";
				codeList.push(code);
				if (code.gwCode != '0') {
					isCheck = true;
				}
			}
			if (isCheck == false) {
				alert(msg);
				return;
			}
			
			isCheck = false;
			
			var erpCode20 = $("input[name=erpCode20]");
			var gwCode20= $("input[name=gwCode20]");
			var erpCodeName20= $("input[name=erpCodeName20]");
			for(var i = 0; i < erpCode20.length; i++) {
				var code={};
				code.erpCode=erpCode20[i].value;
				code.gwCode=gwCode20[i].value;
				code.erpCodeName=erpCodeName20[i].value;
				code.codeType="20";
				codeList.push(code);
				if (code.gwCode != '0') {
					isCheck = true;
				}
			}
			if (isCheck == false) {
				alert(msg);
				return;
			}
			isCheck = false;
			
			var erpCode30 = $("input[name=erpCode30]");
			var gwCode30= $("input[name=gwCode30]");
			var erpCodeName30= $("input[name=erpCodeName30]");
			for(var i = 0; i < erpCode30.length; i++) {
				var code={};
				code.erpCode=erpCode30[i].value;
				code.gwCode=gwCode30[i].value;
				code.erpCodeName=erpCodeName30[i].value;
				code.codeType="30";
				codeList.push(code);
				if (code.gwCode != '0') {
					isCheck = true;
				}
			}
			if (isCheck == false) {
				alert(msg);
				return;
			}
			data.codeList = codeList;
			
			$("#data").val(JSON.stringify(data));
			
		}
		
		function popupAutoResize() {
		     setTimeout(function() {
		        var heightOffset = window.outerHeight - window.innerHeight;
		        var widthOffset = window.outerWidth - window.innerWidth;
		        var height = document.getElementById("content").clientHeight + heightOffset;
		        var width = document.getElementById("content").clientWidth + widthOffset;
		        window.resizeTo(width, height);
		    }, 100);
		}   
		
		
</script>
<div id="content" class="pop_wrap" style="width:600px">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000020527","연동 기초 설정")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/btn/btn_pop_clo01.png' />" alt="" /></a>
		</div>	
			
	<form id="form" name="form" method="post" action="erpSyncBaseDataSetPopSaveProc.do">
		<input type="hidden" id="groupSeq" name="groupSeq" value="${params.groupSeq }" />
		<input type="hidden" id="compSeq" name="compSeq" value="${params.compSeq }" />
		<input type="hidden" id="data" name="data" value="" />
		<div class="pop_con">
			<div class="tab_set">
				<div class="tab_style" id="tabstrip">
					<!-- tab -->
					<ul>
						<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000013514","ERP코드설정")%></li>
						<li><%=BizboxAMessage.getMessage("TX000021939","라이선스 설정")%></li>
					</ul>
					
					<!-- ERP코드연동 -->
					<div class="tab1 ovh">
						<div class="btn_div m0 pt10 pb10 pl15 pr15 borderB">
							<div class="left_div">
								<div class="trans_top_btn">
									<div class="option_top">
										<ul>
											<li class="tit_li"><%=BizboxAMessage.getMessage("TX000021940","근무구분 코드 맵핑")%></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						
						<div id="" class="pl15 pr15 pb15 clear" style="display:;">
							<div class="fl mt10" style="width:263px;">
								<div class="trans_top_btn mb10">
									<div class="option_top">
										<ul>
											<li class="tit_li">ERP</li>
										</ul>
									</div>
								</div>
								<!-- 테이블 -->
								<div class="com_ta4 cursor_p non_head hover_no">
									<table>
										<c:if test="${empty syncWorkCodeList }">
										<tr><td><%=BizboxAMessage.getMessage("TX000001063","데이터가 없습니다.")%></td></tr>
										</c:if>
										<c:if test="${not empty syncWorkCodeList }">
										<c:forEach items="${syncWorkCodeList}" var="list">
										<tr><td>${list.erpCodeName}<input type="hidden" name="erpCodeName10" value="${list.erpCodeName}" /><input type="hidden" name="erpCode10" value="${list.erpCode}" /></td></tr>
										</c:forEach>
										</c:if>
									</table>
								</div>
							</div>
							
							<div class="fl mt10 ml10" style="width:263px;">
								<div class="trans_top_btn mb10">
									<div class="option_top">
										<ul>
											<li class="tit_li"><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></li>
										</ul>
									</div>
								</div>
								<!-- 테이블 -->
								<div class="com_ta4 cursor_p non_head hover_no">
									<table>
										<c:forEach items="${syncWorkCodeList}" var="list" varStatus="c">
										<tr><td><input id="gw_code_sel${c.count}" name="gwCode10" style="width:120px;" value="${list.gwCode}" /></td></tr>
										</c:forEach>
									</table>
								</div>
							</div>
						</div>
					</div>
					
					
					
					<!-- 사용 라이선스 설정 -->
					<div class="tab2 ovh">
						<div class="btn_div m0 pt10 pb10 pl15 pr15 borderB">
							<div class="left_div">
								<div class="trans_top_btn">
									<div class="option_top">
										<ul>
											<li class="tit_li"><%=BizboxAMessage.getMessage("TX000004791","상용직")%></li>
											<li class="tit_li" style="margin-left:222px;"><%=BizboxAMessage.getMessage("TX000004792","일용직")%></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						
						<div id="" class="pl15 pr15 pb15 clear">
							<div class="fl mt10" style="width:263px;">
								<div class="trans_top_btn mb10">
									<div class="option_top">
										<ul>
											<li class="tit_li"><%=BizboxAMessage.getMessage("TX900000215","ERP 직군유형")%></li>
											<li class="tit_li" style="margin-left:27px;"><%=BizboxAMessage.getMessage("TX000017941","라이선스")%></li>
										</ul>
									</div>
								</div>
								<!-- 테이블 -->
								<div class="com_ta4 cursor_p non_head hover_no scroll_y_on" style="height:223px;">
									<table>
										<colgroup>
											<col width="" />
											<col width="50%" />
										</colgroup>
										<c:forEach items="${syncRegularCodeList}" var="list" varStatus="c">
										<tr><td>${list.erpCodeName}<input type="hidden" name="erpCodeName20" value="${list.erpCodeName}" /><input type="hidden" name="erpCode20" value="${list.erpCode}" /></td><td><input name="gwCode20" id="gw_li_re_sel${c.count}" style="width:100px;" value="${list.gwCode}"/></td></tr>
										</c:forEach>
									</table>
								</div>
							</div>
							
							<div class="fl mt10 ml10" style="width:263px;">
								<div class="trans_top_btn mb10">
									<div class="option_top">
										<ul>
											<li class="tit_li"><%=BizboxAMessage.getMessage("TX900000215","ERP 직군유형")%></li>
											<li class="tit_li" style="margin-left:27px;"><%=BizboxAMessage.getMessage("TX000017941","라이선스")%></li>
										</ul>
									</div>
								</div>
								<!-- 테이블 -->
								<div class="com_ta4 cursor_p non_head hover_no scroll_y_on" style="height:223px;">
									<table>
										<colgroup>
											<col width="" />
											<col width="50%" />
										</colgroup>
										<c:forEach items="${syncDayCodeList}" var="list" varStatus="c">
										<tr><td>${list.erpCodeName}<input type="hidden" name="erpCodeName30" value="${list.erpCodeName}" /><input type="hidden" name="erpCode30" value="${list.erpCode}" /></td><td><input name="gwCode30" id="gw_li_day_sel${c.count}" style="width:100px;" value="${list.gwCode}" /></td></tr>
										</c:forEach>
									</table>
								</div>
							</div>
						</div>
					</div>
		
				</div><!--// tab_style -->
			</div><!--// tab_set -->
		</div><!--// pop_con -->
	</form>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="" id="saveBtn" value="<%=BizboxAMessage.getMessage("TX000001256", "저장")%>" />
				<input type="button" class="gray_btn" id="cancelBtn" value="<%=BizboxAMessage.getMessage("TX000002947", "취소")%>" />
			</div>
		</div><!-- //pop_foot -->
</div><!--// pop_wrap -->