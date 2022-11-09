<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>

<script>
$(document).ready(function() {
	
	fnBindGrid("init");

});

var allCount = 0;

//결재라인 설정 리스트
function fnBindGrid(type) {
	
	if(type == "init"){
		$("#compSeq").val("");
		$("#empName").val("");
		$("#dpName").val("");
		$("#deptName").val("");
	}
	
    var data = {};
    data.compSeq = $("#compSeq").val();
    data.empName = $("#empName").val();
    data.dpName = $("#dpName").val();
    data.deptName = $("#deptName").val();
    
	$.ajax({
		type : "post",
		url : "getAuthorMasterList.do",
		dataType : "json",
		data : data,
		async : false,
		success : function(result) {
			
			if(type == "init"){
				allCount = result.list.length;	
			}
			
			var dataSource = new Pudd.Data.DataSource({
				 
				data : result.list		// 직접 data를 배열로 설정하는 옵션 작업할 것			 
			,	pageSize : 10			// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
			,	serverPaging : false
			
			});
			
			Pudd( "#grid" ).puddGrid({	 
				dataSource : dataSource	 
			,	scrollable : true	 
			,	resizable : true	
		    ,	pageSize : 10
		    ,	pageable : {
					buttonCount : 10 
				}
			,	columns : [
					{
						field : "gridCheckBox"		// grid 내포 checkbox 사용할 경우 고유값 전달
					,	width : 34
					,	editControl : {
							type : "checkbox"
						,	basicUse : true
						}
					}			 
				,	{
						field : "compName"
					,	title : "<%=BizboxAMessage.getMessage("TX000000047","회사")%>"
					}
				,	{
						field : "deptName"
					,	title : "<%=BizboxAMessage.getMessage("TX000000098","부서")%>"
					,	width : 18
					,	widthUnit : "%"
					,	tooltip : {

							alwaysShow : true		// 말줄임 여부와 관계없이 tooltip 보여줄 것인지 설정, 기본값 false
						,	showAtClientX : true	// toolTip 보여주는 위치가 mouse 움직이는 X 좌표 기준 여부, 기본값 false ( toolTip 부모객체 기준 )
						,	attributes : { style : "text-align:left;" }
			 
							// @param : row에 해당되는 Data
						,	template : function( rowData ) {
							
								return rowData.deptPathName;
			 
							}
						}
					}
				,	{
						field:"positionName"
					,	title:"<%=BizboxAMessage.getMessage("TX000000099","직급")%>" 
					,	width : 18
					,	widthUnit : "%"
					}
				,	{
						field:"dutyName"
					,	title:"<%=BizboxAMessage.getMessage("TX000000105","직책")%>"
					,	width : 20
					,	widthUnit : "%"
					}
				,	{
						field:"empName"
					,	title:"<%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%>"
					,	width : 20
					,	widthUnit : "%"
					}
				]
			});			
			
		}, 
		error : function(result) {
			alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
		}
	});

}

/* 공통 팝업 호출 */
function fnAdd() {
	$("[name=compFilter]").val($("#compSeq").val());
	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
	frmPop.target = "cmmOrgPop";
	frmPop.method = "post";
	frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
	frmPop.submit();
	pop.focus();
}


function callbackSel(jons){	
	if(jons.isSave){
		var tblParam = {};
		tblParam.selectedList = JSON.stringify(jons.returnObj);
		tblParam.masterUseYn = 'Y';    
		fnUpdate(tblParam);	
	}  
}

function fnDel(){
	
	var dataCheckedRow = Pudd( "#grid" ).getPuddObject().getGridCheckedRowData( "gridCheckBox" );
	
    if(dataCheckedRow && dataCheckedRow.length == 0) {
		alert("<%=BizboxAMessage.getMessage("TX000010849","삭제할 사용자를 선택하세요")%>");
		return false ;
	}
    if(allCount == dataCheckedRow.length){
    	alert("<%=BizboxAMessage.getMessage("TX000010848","마스터권한은 최소 한 명 이상 존재해야 합니다")%>");
    	return;
    }
	
    var selectedList = [];
    
    $.each(dataCheckedRow, function (i, t) {
    	
    	var selectedInfo = {};
    	selectedInfo.empSeq = t.empSeq;
    	selectedList.push(selectedInfo);
    	
    });
    
	var tblParam = {};
	tblParam.selectedList = JSON.stringify(selectedList);
	tblParam.masterUseYn = 'N';
	
	var isDel = confirm("<%=BizboxAMessage.getMessage("TX000016303","마스터 권한을 삭제하시겠습니까?")%>");
	if(!isDel) return;
	
	fnUpdate(tblParam);
}

function fnUpdate(tblParam){
	var mode = '<%=BizboxAMessage.getMessage("TX000000424","삭제")%>';
	if(tblParam.masterUseYn =='Y'){
		mode = '<%=BizboxAMessage.getMessage("TX000000602","등록")%>';
	}

	$.ajax({
		type : "post",
		url  : "updateAuthorMaster.do",
		datatype : "json",
		data : tblParam,
		success:function(data){
			var result = data.result;
			
			if(result > 0){
				alert("<%=BizboxAMessage.getMessage("TX000010847","권한이 {0} 되었습니다")%>".replace("{0}",mode));
				fnBindGrid("init");
			}else{
				alert(mode + '<%=BizboxAMessage.getMessage("TX000016126","중 오류가 발생했습니다.")%>');
			}
			
		}, 
		error : function(result) {
			alert(mode + '<%=BizboxAMessage.getMessage("TX000016126","중 오류가 발생했습니다.")%>');
		}
	});
}

function fnDeptPop(){
	$("[name=compFilter]").val($("#compSeq").val());
	var pop = window.open("", "cmmDeptPop", "width=799,height=769,scrollbars=no");
	$("#callback").val("callbackSelDept");
	frmDeptPop.target = "cmmDeptPop";
	frmDeptPop.method = "post";
	frmDeptPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
	frmDeptPop.submit();
	pop.focus(); 
}

function callbackSelDept(data) {
	if(data.returnObj.length > 0){
		$("#deptName").val(data.returnObj[0].deptName);
		fnBindGrid("search");
	}
}


</script>

<!-- 사용자 단일 선택 폼 기본 형  -->
<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do'/>">
	<input type="hidden" name="selectMode" width="500" value="u" />
	<input type="hidden" name="isAllCompShow" width="500" value="true" />
	<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
	<input type="hidden" name="selectItem" width="500" value="m" />
	<input type="hidden" name="callback" width="500" value="callbackSel" />
	<input type="hidden" name="selectedItems" id="selectedItems" width="500" value="" />
	<input type="hidden" name="noUseDeleteBtn" width="500" value="true" />
	<input type="hidden" id="compFilter" name="compFilter" value=""/>
</form>

<form id="frmDeptPop" name="frmDeptPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="d" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="" />
	<input type="hidden" name="deptSeq" value="" seq="deptFlag"/>
	<input type="hidden" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
</form>

<div class="top_box">
	<dl class="dl1">
		<dt style="" class="ar"><%=BizboxAMessage.getMessage("TX000005664","회사선택")%></dt>
		<dd>
			<select id="compSeq" onchange="fnBindGrid('search');">
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<c:forEach var="items" items="${compList}">
					<option value="${items.compSeq}">${items.compName}</option>
				</c:forEach>
			</select>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000016219","사용자/ID")%></dt>
		<dd><input id="empName" type="text" style="width:150px;" class="puddSetup" value="" onkeyup="javascript:if(event.keyCode==13){fnBindGrid('search');}" /></dd>
		<dd><input type="button" onclick="fnBindGrid('search');" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='/gw/Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<div class="SearchDetail">
	<dl>	
		<dt style="width:60px;"><%=BizboxAMessage.getMessage("TX000000098","부서")%></dt>
		<dd><input id="deptName" type="text" style="width:140px;" class="puddSetup" value="" onkeyup="javascript:if(event.keyCode==13){fnBindGrid('search');}" /></dd>
		<dd class="ml4"><input type="button" value="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" onclick="fnDeptPop();"></dd>
		<dt style="width:70px;"><%=BizboxAMessage.getMessage("TX000015243","직급/직책")%></dt>
		<dd><input id="dpName" type="text" style="width:150px;" class="puddSetup" value="" onkeyup="javascript:if(event.keyCode==13){fnBindGrid('search');}" /></dd>
	</dl>  
</div>


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="btn_div">
		<div class="left_div">	
			<p class="tit_p mb5 mt5"><%=BizboxAMessage.getMessage("TX000016304","마스터 권한 사용자 목록")%></p>
		</div>
		<div class="right_div">
			<input type="button" onclick="fnAdd();" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000016373","권한 추가")%>" />
			<input type="button" onclick="fnDel();" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000424","삭제")%>" />
		</div>	
	</div>	
	<div id="grid"></div>				

</div><!-- //sub_contents_wrap -->					

