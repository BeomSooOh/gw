<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<script type="text/javascript" src='<c:url value="/js/datatables/jquery.dataTables.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.select.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.scroller.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.rowReorder.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/datatables/dataTables.fixedHeader.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ex/CommonEX.js"></c:url>'></script>

	<script type="text/javascript">
		$(document).ready(function() {	

		});
		/* 확인 */
		function fnCodeEventButton_Accept() {
			if (window['${ViewBag.callBack}']) {
				/* 콜백이 있는 경우 */
				var result = {};
				result.empCode = ($('#hidEmpCode').val() || '');
				result.empName = ($('#hidEmpName').val() || '');
				/* 필수 반환값 확인 */
				if (result.empCode == '') {
					alert('<%=BizboxAMessage.getMessage("TX000002009","선택된 항목이 없습니다")%>');
					return;
				}
				/* 콜백수행 */
				window['${ViewBag.callBack}']('emp', result);
				/* 레이어 종료 */
				layerPopClose();
				return;
			} else {
				/* 콟백이 없는 경우 */
				/* 레이어 종료 */
				layerPopClose();
				return;
			}
		}
		
		/* 행선택 이벤트 */
		function fnCodeEventSelect_Row(data) {
			$('#hidEmpCode').val(data.erpEmpSeq);
			$('#hidEmpName').val(data.erpEmpNm);
			return;
		}

		/* 행선택 이벤트 */
		function fnCodeEventDbClick_Row(data) {
			$('#hidEmpCode').val(data.erpEmpSeq);
			$('#hidEmpName').val(data.erpEmpNm);
			fnCodeEventButton_Accept();
		}
		
		function onSelect(e){
			var compSeq = e.id;
			var compName = e.innerText.replace(e.id, '');
			$("#hidCompCode").val(compSeq); 
			$("#hidCompName").val(compName);
			
			
			var table = document.getElementById("exCompListTable");
			var tr = table.getElementsByTagName("tr");
			for(var i=0; i<tr.length; i++)
				tr[i].style.background = "white";
			e.style.backgroundColor = "#E6F4FF";
		}
		
		function ok(){
			opener.fnSetErpCompInfo($("#hidCompCode").val(), $("#hidCompName").val(), "${index}");
			self.close();
		}
		
		function fnSearch(){
			var txtSearch = $("#txtSearchStr").val();
			var tblParam = {};
			tblParam.txtSearch = txtSearch;
			tblParam.driver = $("#driver").val();
			tblParam.url = $("#url").val();
			tblParam.dbType = $("#dbtype").val();
			tblParam.erpVer = $("#erpver").val();
			tblParam.dbId = $("#dbid").val();
			tblParam.dbPwd = $("#dbpwd").val();
			tblParam.index = $("#index").val();
			$.ajax({
				type : 'post',
				url : '<c:url value="/cmm/systemx/getExCompList.do" />',
				datatype : 'json',
				async : true,
				data : tblParam,
				success : function(data) {
					setExCompListTable(data.compList, data.serviceName);
				}
			});
		}
		
		function setExCompListTable(compList, serviceName){
			$("#compListTable").html("");
			var innerHTML = "";
			for(var i=0;i<compList.length;i++){
				if(serviceName == "ExCodeOrgERPiUService"){
					innerHTML += "<tr onclick='onSelect(this);' id='" + compList[i].CD_COMPANY + "' name='" + compList[i].NM_COMPANY + "' ondblclick='ok();' >";
					innerHTML += "<td>" + compList[i].CD_COMPANY + "</td>";
					innerHTML += "<td>" + compList[i].NM_COMPANY + "</td>";
					innerHTML += "</tr>"
				}
				else if(serviceName == "ExCodeOrgiCUBEService"){
					innerHTML += "<tr onclick='onSelect(this);' id='" + compList[i].CO_CD + "' name='" + compList[i].CO_NM + "' ondblclick='ok();' >";
					innerHTML += "<td>" + compList[i].CO_CD + "</td>";
					innerHTML += "<td>" + compList[i].CO_NM + "</td>";
					innerHTML += "</tr>"
				}
			}
			$("#compListTable").html(innerHTML);
		}
	</script>

</head>
<body>
<div class="pop_wrap" style="538px;">
	<input type="hidden" id="hidCompCode"></input>
	<input type="hidden" id="hidCompName"></input>
	
	<input type="hidden" id="driver" value="${param.driver }"></input>
	<input type="hidden" id="url" value="${param.url }"></input>
	<input type="hidden" id="dbtype" value="${param.dbType }"></input>
	<input type="hidden" id="erpver" value="${param.erpVer }"></input>
	<input type="hidden" id="dbid" value="${param.dbId }"></input>
	<input type="hidden" id="dbpwd" value="${param.dbPwd }"></input>
	<input type="hidden" id="index" value="${param.index }"></input>
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000006182","ERP회사 선택")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con div_form">
		<!-- 검색영역 -->
		<div class="top_box pr10">
			<dl>
				<dt><%=BizboxAMessage.getMessage("TX000000018","회사명")%></dt>
				<dd><input id="txtSearchStr" type="text" style="width:150px;" value=""/></dd>
				<dd><input type="button" id="btnPopupSearch" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="fnSearch();" /></dd>
			</dl>
		</div>

		<!-- 테이블 -->
		<div class="com_ta2 mt14">
			<table>
				<colgroup>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<thead>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000022","ERP코드")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
					</tr>
				</thead>
			</table>		
			</div>

			<div class="com_ta2 scroll_y_on bg_lightgray" style="height:333px;">
			<table class="brtn" id="exCompListTable">
				<colgroup>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tbody id="compListTable">	
					<c:forEach items="${compList}" var="c">
						<c:if test="${serviceName == 'ExCodeOrgERPiUService'}">
	                        <tr onclick="onSelect(this);" id="${c.CD_COMPANY}" name="${c.NM_COMPANY}" ondblclick="ok();">
								<td>${c.CD_COMPANY}</td>
								<td>${c.NM_COMPANY}</td>
							</tr>   
						</c:if>
						<c:if test="${serviceName == 'ExCodeOrgiCUBEService'}">
	                        <tr onclick="onSelect(this);" id="${c.CO_CD}" name="${c.CO_NM}" ondblclick="ok();">
								<td>${c.CO_CD}</td>
								<td>${c.CO_NM}</td>
							</tr>   
						</c:if>             
                    </c:forEach>			
				</tbody>
			</table>		
		</div>
	

	</div><!--// pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="ok();"/>
			<input type="button" id="btnClose" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript:self.close();"/>
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->
</body>









