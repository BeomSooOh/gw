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
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2015. 6. 04.  송준석        최초 생성
 * 2016. 8. 04   이혜영        수정
 */
%>

<script>

var userSe = '${loginVO.userSe}';
var compSeq = '${loginVO.compSeq}';

$(document).ready(function() {
	//기본버튼
	$(".controll_btn button").kendoButton();
	
	// 탭
	$("#tabstrip").kendoTabStrip({
		animation:  {
			open: {
				effects: ""
			}
		}
	});
	
	//권한구분 셀렉트박스
    $("#searchAuthorType").kendoComboBox({
        dataSource : {
			data : [ { name: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", id:"" },     
			         { name: "<%=BizboxAMessage.getMessage("TX000000286","사용자")%>", id:"001" },     
			         { name: "<%=BizboxAMessage.getMessage("TX000000098","부서")%>", id:"002" },     
// 			         { name: "직책", id:"003" },
// 			         { name: "직급", id:"004" },
			         { name: "<%=BizboxAMessage.getMessage("TX000000705","관리자")%>", id:"005" } 
			        ]
        },
		dataTextField: "name",
		dataValueField: "id",
		index: 0,
		change : fnGrid
    });	
	
	
	// 마스터의 경우 회사선택 comboBox 추가
	if(userSe == 'MASTER'){
		$("#com_sel").kendoComboBox({
			dataTextField: "compName",
			dataValueField: "compSeq",
			dataSource :${compListJson},
//		        value:"${params.compSeq},
            change: fnGrid,
            filter: "contains",
            suggest: true
        }); 
		    
		var coCombobox = $("#com_sel").data("kendoComboBox");
		coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
		coCombobox.refresh();
		coCombobox.select(0);	
	}	 
	
    // 기본부여여부
    $("#searchAuthorBaseYn").kendoComboBox({
        dataSource : [{ CODE_NM: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", CODE: "" }, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000002850","예")%>", CODE: "Y" }, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000002849","아니요")%>", CODE: "N" }],
        dataTextField: "CODE_NM",
        dataValueField: "CODE",
		index: 0,
		change : fnGrid
    });	    
	
	
// 	AuthorListGrid();
	fnGrid();
	assignInfo("codeType", "001");
});

// 권한 부여  dataSource
// var dataSourceRelat = new kendo.data.DataSource({
// 	serverPaging: true,
// 	transport: {
// 		read: {
// 			type: 'post',
// 			dataType: 'json',
// 			url: '<c:url value="/cmm/system/getAuthorRelateList.do"/>'
// 		},
// 		parameterMap: function(data, operation) {
// 			var searchTextRelate = $("#searchTextRelate").val();
// 			var authorCode = $("#selAuthorCode").val();
// 			var authorType = $("#selAuthorType").val();
			
// 			data.searchTextRelate = searchTextRelate ;
// 			data.authorCode = authorCode ;
// 			data.authorType = authorType ;
// 			return data ;
// 		}
// 	},
// 	schema: {
// 		data: function(response) {
// 			return response.list;
// 		},
// 		total: function(response) {
// 			return response.list.length;
// 		}
// 	}
// });	


//권한  리스트
function fnGrid() {
	   
	$("#selAuthorCode").val("");
	$("#selAuthorType").val("");
	$("#selCompSeq").val("");
	assignInfo();
	
	var tblParam = {};
	tblParam.searchKeyword = $("#searchKeyword").val();
	tblParam.searchAuthorType = $("#searchAuthorType").val();
	tblParam.searchAuthorBaseYn = $("#searchAuthorBaseYn").val();
	tblParam.searchAuthorUseYn = "Y";
	tblParam.comp_seq = $("#com_sel").val();
  	
	$.ajax({
		type : "post",
		url  : "<c:url value='/cmm/system/authorCodeList.do'/>",
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
					Html += " authorNm=\'" + list[nfor].authorNm +"\'";
					Html += " authorType=\'" + list[nfor].authorType +"\'";
					Html += " authorBaseYn=\'" + list[nfor].authorBaseYn +"\'";
					Html += " authorUseYn=\'" + list[nfor].authorUseYn +"\'";
					Html += " compSeq=\'" + list[nfor].compSeq +"\'>";
					Html += "<td>" + list[nfor].authorNm + "</td>";
					Html += "<td>" + list[nfor].authorTypeNm + "</td>";
					Html += "<td>" + list[nfor].compNm + "</td>";
					Html += "<td>" + list[nfor].authorBaseYnNm + "</td>";
					Html += "</tr>";
				}
				if(nlen == 0){
					Html += "<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
				}

				$("#tList").html(Html);
			}
		}, 
		error : function(result) {
			alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
		}
	});
	
	
	$("#tList tr").bind({
		click: function(){
			var Item = {};
			Item.authorCode = $(this).attr("authorCode");
			Item.authorNm = $(this).attr("authorNm");
			Item.authorType = $(this).attr("authorType");
			Item.authorBaseYn = $(this).attr("authorBaseYn");
			Item.authorUseYn = $(this).attr("authorUseYn");
			Item.compSeq = $(this).attr("compSeq");
			
			//전체 tr 초기화
			$("#tList tr").removeClass("on");
			//선택 tr 변경
			$(this).addClass("on");
    		
	    	$("#selAuthorCode").val(Item.authorCode);
	    	$("#selAuthorType").val(Item.authorType);
	    	$("#selCompSeq").val(Item.compSeq);
	    	
	    	assignInfo();
    		
		 }
	});
}


function assignInfo(){

	var authorCode = $("#selAuthorCode").val();
	var authorType = $("#selAuthorType").val();
	
	var url ='<c:url value="/cmm/system/authorAssignUserView.do"/>';
// 	if(authorType == "001"){
// 		url = '<c:url value="/cmm/system/authorAssignUserView.do"/>';
// 	}else 
	if(authorType == "002"){	
		url = '<c:url value="/cmm/system/authorAssignDeptView.do"/>';
	}else if(authorType == "003" || authorType == "004"){
		url = '<c:url value="/cmm/system/authorAssignClassView.do"/>';
	}
// 	else if(authorType == "005"){	
// 		url = '<c:url value="/cmm/system/authorAssignAdminView.do"/>';
// 	}
		
    if(url == ""){
    	return;
    }
    
    $.ajax({
        type:"post",
        url:url,
        data:{"authorCode":authorCode,"authorType":authorType},
        datatype:"html",            
        success:function(data){
            $("#divList").html(data);
            selfReload(); 
        }
    });		
	
}   

/* 공통 팝업 호출 */
function fnOrgChart() {
	getAuthorRelateList();
	if($("#selCompSeq").val() == ""){
		alert("<%=BizboxAMessage.getMessage("TX000010855","권한을 선택해 주세요")%>");
		return;
	}
	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
	frmPop.target = "cmmOrgPop";
	frmPop.method = "post";
	frmPop.compFilter.value = $("#selCompSeq").val();
	frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
	frmPop.submit();
	pop.focus();
}

function callbackSel(jons){
    
    if(!jons.isSave){
    	return;
    }
    
    if(jons.returnObj.length == 0){
    	return;
    }
    
    var tblParam = {};
    
    tblParam.authorCode = $("#selAuthorCode").val();
    tblParam.authorType = $("#selAuthorType").val();
    tblParam.selectedList = JSON.stringify(jons.returnObj);

	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/system/insertAuthorRelate.do" />',
		datatype:"json",
		data: tblParam,
		success:function(data){
			var result = data.result;
			
			if(result == "insert"){		
				//기관을 저장 하였습니다.
				alert('<%=BizboxAMessage.getMessage("TX000018685","권한을 등록 하였습니다.")%>');			
				   
				selfReload();
				
			}else{
				//sql 에러가 발생했습니다! error code: {0}, error msg: {1}
				alert('<%=BizboxAMessage.getMessage("TX000010687","sql 에러가 발생했습니다")%>');
				
				selfReload();
			}																		 
		}
	});
	
}

function getAuthorRelateList(){
 
	var tblParam = {};
    
	tblParam.authorCode = $("#selAuthorCode").val();
	tblParam.authorType = $("#selAuthorType").val();
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/system/getAuthorRelateGroup.do" />',
		datatype:"json",
		data: tblParam,
		async: false,
		success:function(data){
			var result = data.result;
			$("#selectedItems").val(result);	
		}
	});
	
}

function fnDelAuthorRelate(){
	
	var authorType = $("#selAuthorType").val();
	var typeName = "<%=BizboxAMessage.getMessage("TX000000286","사용자")%>";
	if(authorType == "002"){
		typeName = "<%=BizboxAMessage.getMessage("TX000000098","부서")%>";
	}
	
	var chkbox = $("#detailTList .k-checkbox");
	
	if(!checkBoxSelected(chkbox) ) {
		alert("! "+"<%=BizboxAMessage.getMessage("TX000010854","삭제할 {0}를 선택 해 주세요")%>".replace("{0}",typeName));
		return false ;
	}
	
    var chkedList = checkBoxSelectedIndex(chkbox) ;
    
	var len = chkbox.length ;
	var cnt = chkedList.length ;

    var arrValue = new Array(cnt);

	var index  = 0 ;

	if(chkbox.length > 0){
		for ( var i = 0 ; i < len ; i++ ) {
			if ( chkbox[i].checked == true )  {
				var target = $(chkbox[i]);
				var tr = target.parents("tr");
			    var arrNew = {};
			    arrNew.AUTHORCODE = tr.attr("authorCode");
			    arrNew.COMP_SEQ = tr.attr("compSeq");
			    arrNew.DEPT_SEQ = tr.attr("deptSeq");
			    arrNew.EMP_SEQ = tr.attr("empSeq");
			    
			    arrValue[index] = eval(arrNew);
			    index = index + 1;
			}
		}
	}
	

	var chkArray = [];
	var chkDeptArray = [];
			
// 	var grid = $("#grid_relate").data("kendoGrid");
// 	var checkList = CommonKendo.getChecked(grid);
       
// 	if (checkList.length == 0) {
// 		alert("삭제할 "+ typeName+"를 선택 해 주세요");
// 		return;
// 	}
	
	var tmp2 = "<%=BizboxAMessage.getMessage("TX000016198","선택한 {0}의 권한을 삭제하시겠습니까?")%>";
	tmp2 = tmp2.replace("{0}",typeName);
	var isDel = confirm(tmp2);/*삭제하시겠습니까?*/
			
	if(!isDel) return false;
        
	var tblParam = {};
// 	var gridJson = CommonKendo.getTreeCheckedToJson(grid);
	tblParam.authorCode = $("#selAuthorCode").val();
	tblParam.selectedList = JSON.stringify(arrValue);
// 	tblParam.selectedList = gridJson;
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/system/deleteAuthorRelate.do" />',
		datatype:"json",
		data: tblParam,
		success:function(data){
			var result = data.result;
			alert('<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>');
			
			selfReload();
		}
	});
}

//체크박스 선택시 toggle
function chkAll(allChkName, chkName) {
	var chkDoc = document.getElementsByName(chkName);

	var allChkName = document.getElementsByName(allChkName);
    allCheckBox(chkDoc, allChkName[0].checked);
}

</script>
<input type="hidden" id="selAuthorCode" />
<input type="hidden" id="selAuthorType" />
<input type="hidden" id="selCompSeq" />
<c:if test="${loginVO.userSe != 'MASTER'}"> 
<input type="hidden" id="com_sel" val="${loginVO.compSeq}"/>
</c:if>

					<div class="top_box">
						<dl class="dl1">
						<c:if test="${loginVO.userSe == 'MASTER'}"> 
							<dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
							<dd><input id="com_sel" /></dd>
						</c:if>	
							<dt><%=BizboxAMessage.getMessage("TX000000136","권한명")%></dt>
							<dd style="width:190px;">
<%-- 							    <input type="text" class="fl" name="searchKeyword" id="searchKeyword"  style="width:162px;" placeholder="전체" value="${searchKeyword}" onkeyup="javascript:if(event.keyCode==13){searchGrid(); return false;}" /> --%>
								<input class="" type="text" placeholder="" style="width:162px;" name="searchKeyword" id="searchKeyword" onkeyup="javascript:if(event.keyCode==13){fnGrid(); return false;}">
							</dd>
							<dd class="mr40"><input id="" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="javascript:fnGrid();"/></dd>
						</dl>
						<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='<c:url value='/Images/ico/ico_btn_arr_down01.png'/>'/></span>
					</div>
					
					<div class="SearchDetail">
						<dl>
							<dt><%=BizboxAMessage.getMessage("TX000006303","권한구분")%></dt>
							<dd class="mr20">
								<input id="searchAuthorType" name="searchAuthorType" style="width:98px;"/>
							</dd>
							<dt><%=BizboxAMessage.getMessage("TX000006305","기본부여여부")%></dt>
							<dd class="mr20">
							    <input id="searchAuthorBaseYn" name="searchAuthorBaseYn" style="width:98px;"/>
							</dd>
<!-- 							<dt>사용여부</dt> -->
<!-- 							<dd class="mr5"> -->
<!-- 							    <input id="searchAuthorUseYn" name="searchAuthorUseYn" style="width:98px;"/> -->
<!-- 							</dd> -->
						</dl>
					</div>						
                        
					<!-- 컨텐츠내용영역 -->
					<div class="sub_contents_wrap">		
					
						<div class="twinbox mt15">
							<table>
								<colgroup>
									<col style="width:55%;" />
									<col />
								</colgroup>
								<tr>
									<td class="twinbox_td p0">
										<div class="pl15 pr15 clear">
											<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000015963","권한목록")%></p>
										</div>
<!-- 										<div id="grid" class="mt14"></div> -->
										<!-- 테이블 -->
										<div class="com_ta2 ml15 mr15">
											<table>
												<colgroup>
													<col width=""/>
													<col width=""/>
													<col width=""/>
													<col width="107"/>
												</colgroup>
												<tr>
													<th><%=BizboxAMessage.getMessage("TX000000136","권한명")%></th>
													<th><%=BizboxAMessage.getMessage("TX000006303","권한구분")%></th>
													<th><%=BizboxAMessage.getMessage("TX000006442","적용회사")%></th>
													<th><%=BizboxAMessage.getMessage("TX000016352","기본부여")%></th>
												</tr>
											</table>
										</div>
										
										<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc" style="height:477px;overflow-y:scroll;">
											<table>
												<colgroup>
													<col width=""/>
													<col width=""/>
													<col width=""/>
													<col width="90"/>
												</colgroup>
												<tbody id="tList"></tbody>
											</table>	
										</div>
									</td>
									<td class="twinbox_td p0">
									    <div class=""  id="divList"> <!-- auth_op1 사용자 -->	
												 
										</div>	
																					
										<!-- 테이블 -->
<!-- 										<div class="com_ta2 ml15 mr15"> -->
<!-- 											<table> -->
<%-- 												<colgroup> --%>
<%-- 													<col width="34"/> --%>
<%-- 													<col width=""/> --%>
<%-- 													<col width=""/> --%>
<%-- 													<col width="167"/> --%>
<%-- 												</colgroup> --%>
<!-- 												<tr> -->
<!-- 													<th> -->
<!-- 														<input type="checkbox" name="all_chk" id="all_chk" class="k-checkbox"> -->
<!-- 														<label class="k-checkbox-label chkSel" for="all_chk"></label> -->
<!-- 													</th> -->
<!-- 													<th>부서명</th> -->
<!-- 													<th>직급</th> -->
<!-- 													<th>사용자명(ID)</th> -->
													
<!-- 												</tr> -->
<!-- 											</table> -->
<!-- 										</div> -->
										
<!-- 										<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc" style="height:477px;overflow-y:scroll;"> -->
<!-- 											<table> -->
<%-- 												<colgroup> --%>
<%-- 													<col width="34"/> --%>
<%-- 													<col width=""/> --%>
<%-- 													<col width=""/> --%>
<%-- 													<col width="150"/> --%>
<%-- 												</colgroup> --%>
<!-- 												<tr> -->
<!-- 													<td> -->
<!-- 														<input type="checkbox" name="inp_chk" id="inp_chk1" class="k-checkbox"> -->
<!-- 														<label class="k-checkbox-label chkSel2" for="inp_chk1"></label> -->
<!-- 													</td> -->
<!-- 													<td>개발1팀</td> -->
<!-- 													<td>과장</td> -->
<!-- 													<td>홍길동(gildong)</td> -->
<!-- 												</tr> -->
<!-- 											</table>	 -->
<!-- 										</div> -->
									</td>
								</tr>
							</table>
						</div>
														

					</div><!-- //sub_contents_wrap -->	