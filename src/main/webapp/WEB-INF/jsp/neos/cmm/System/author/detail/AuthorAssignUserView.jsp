<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%
/**
 * 
 * @title 권한부여관리 화면
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2015. 6. 04.  송준석        최초 생성
 * 2016. 8. 04   이혜영        수정
 */
%>
<script>

var dutyPositionOption = "${displayPositionDuty}";

$(function(){
	
	//기본버튼
	$(".controll_btn button").kendoButton();
	
	$("#searchTextRelate").bind({
		keyup : function(event){
			if(event.keyCode==13){
				fnDetailGrid();
			}
		}
	
	});

	$("#btnTree").click(function() {fnOrgChart();});
	$("#btnDel").click(function() {fnDelAuthorRelate();});
		
// 		BindKendoUserGrid();  
});


//권한  리스트
function fnDetailGrid() {
	   
	var tblParam = {};
	tblParam.searchTextRelate = $("#searchTextRelate").val();
	tblParam.authorCode = $("#selAuthorCode").val();
	tblParam.authorType = $("#selAuthorType").val();
	tblParam.compSeq = $("#selCompSeq").val();
	
	$.ajax({
		type : "post",
		url  : "<c:url value='/cmm/system/getAuthorRelateList.do'/>",
		dataType : "json",
		data : tblParam,
		async : false,
		success : function(result) {
			if (result.list) {
				var list = result.list;
				var nlen = list.length;
				var Html = "";
				for (var nfor = 0; nfor < nlen; nfor++) {
					Html += "<tr authorCode=\'" + list[nfor].authorCode + "\'";
					Html += " empSeq=\'" + list[nfor].empSeq +"\'";
					Html += " deptSeq=\'" + list[nfor].deptSeq +"\'";
					Html += " compSeq=\'" + list[nfor].compSeq +"\'>";
					Html += "<td><input name=\'inp_chk\' class=\'k-checkbox\' id=\'" + list[nfor].selectedItem + "\' type=\'checkbox\'>";
					Html += "<label class=\'k-checkbox-label chkSel2\' for=\'" + list[nfor].selectedItem + "\'></label></td>";
					Html += "<td>" + list[nfor].deptName + "</td>";
					if(dutyPositionOption == "position") {
						Html += "<td>" + list[nfor].positionNm + "</td>";
					} else {
						Html += "<td>" + list[nfor].dutyNm + "</td>";
					}
					
					Html += "<td>" + list[nfor].empName + "(" + list[nfor].loginId + ")</td>";
					Html += "</tr>";
					
				}
				if(nlen == 0){
					Html += "<tr><td colspan='4'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
				}

				$("#detailTList").html(Html);
			}
		}, 
		error : function(result) {
			alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
		}
	});
	
	
	$("#detailTList .k-checkbox").bind({
		click: function(){
			//선택 tr 변경
			var tr = $(this).parents("tr");
			if ( this.checked == true )  {
				$(tr).addClass("on");	
			}else{
	 			$(tr).removeClass("on");				
			}
		 }
	});
}


function selfReload() {
// 	BindKendoUserGrid();
	fnDetailGrid();
}	

</script>

<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do'/>">
	<input type="hidden" name="selectMode" width="500" value="u" />
	<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
	<input type="hidden" name="selectItem" width="500" value="m" />
	<input type="hidden" name="callback" width="500" value="callbackSel" />
	<input type="hidden" name="compSeq" id="compSeq"  value="" />
	<input type="hidden" name="compFilter" id="compFilter" value="" />
	<input type="hidden" name="initMode" id="initMode" value="true" />
	<input type="hidden" name="noUseDefaultNodeInfo" id="noUseDefaultNodeInfo" value="true" />
	<input type="hidden" name="selectedItems" id="selectedItems" value="" />
	<input type="hidden" name="eaYn" id="eaYn" value="Y" />
	<input type="hidden" name="authPopYn" id="authPopYn" value="Y" />
	<!-- 권한부여관리 공통팝업플레그(해당팝업은 조직도 표시/미표시 구분없이 모든사용자 조회되어야함) --> 
</form>


										<div class="tb_borderB pl15 pr15 clear">
											<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000016028","사용자 목록")%> </p>
											
											<div class="controll_btn fr">
												<button type="button" id="btnTree"><%=BizboxAMessage.getMessage("TX000005190","사용자선택")%></button>
												<button type="button" id="btnDel"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
											</div>
										</div>

										<div class="tb_borderB pl15 pr15 clear bg_lightgray">
											<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000000286","사용자")%></p>
											<div class="fl ml10 mt9 clear">
												<input class="fl" type="text" value="" placeholder="" style="text-indent:8px;width:162px;" name="searchTextRelate" id="searchTextRelate">
												<a href="#n" class="fl btn_search" onclick="javascript:fnDetailGrid();" ></a>
											</div>
										</div>	
	 
										<!-- 테이블 -->
										<div class="com_ta2 mt15 ml15 mr15">
											<table>
												<colgroup>
													<col width="34"/>
													<col width=""/>
													<col width=""/>
													<col width="167"/>
												</colgroup>
												<tr>
													<th>
														<input type="checkbox" name="all_chk" id="all_chk" class="k-checkbox" onClick="chkAll('all_chk','inp_chk');">
														<label class="k-checkbox-label chkSel" for="all_chk"></label>
													</th>
													<th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
									 				<c:if test="${displayPositionDuty eq 'position'}">
														<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
													</c:if>
													<c:if test="${displayPositionDuty eq 'duty'}">
														<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
													</c:if>
													<th><%=BizboxAMessage.getMessage("TX000016217","사용자명(ID)")%></th>
													
												</tr>
											</table>
										</div>
										
										<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc" style="height:419px;overflow-y:scroll;">
											<table>
												<colgroup>
													<col width="34"/>
													<col width=""/>
													<col width=""/>
													<col width="150"/>
												</colgroup>
												<tbody id="detailTList"></tbody>
											</table>	
										</div>
				
