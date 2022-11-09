<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<!--css-->
<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">

<!--js-->
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>

<script>

var dataSource;
var wehagoJoinCompSeq;
var wehagoJoinUrl;

$(document).ready(function() {
	gridRead();
});

function gridRead(){
	var tblParam = {};
	
	tblParam.syncTp = syncTp.value;
	tblParam.compName = compName.value;
	tblParam.compCd = compCd.value;
	tblParam.compRegistNum = compRegistNum.value;
	tblParam.ownerName = ownerName.value;
	
	$.ajax({
		type:"post",
		url:'/gw/systemx/getWehagoSetInfoList.do',
		datatype:"text",
		data:tblParam,
		success:function(data){
			exData = data.wehagoSetInfoList;
			
			dataSource = new Pudd.Data.DataSource({
				data : exData
			,	pageSize : 10000
			,	serverPaging : false
			});
			
			rederGrid();
		}
	});
}

function rederGrid(){
	Pudd("#wehagoGrid").puddGrid({
			dataSource : dataSource
		,	scrollable : true
		,	height : 600
		,	autoScroll : true
		,	sortable : false
		,	resizable : true
		,	ellipsis : false
		,	hoverUse : false
		,	columns : [
				{
					field : "compCd"
				,	title : "<%=BizboxAMessage.getMessage("TX000000017", "회사코드")%>"
				,	width : 30
				,	widthUnit : "%"
				}
			,	{
					field : "compName"
				,	title : "<%=BizboxAMessage.getMessage("TX000000018", "회사명")%>"
				,	minWidth : 250
				}
			,	{
					field:"compRegistNum"
				,	title:"<%=BizboxAMessage.getMessage("TX000000024", "사업자등록번호")%>"
				,	width:130
				}
			,	{
					field:"ownerName"
				,	title:"<%=BizboxAMessage.getMessage("TX000000026", "대표자명")%>"
				,	width:85
				}
			,	{
					title:"<%=BizboxAMessage.getMessage("TX000005461", "연동상태")%>"
				,	width:90
				,	content : {
						template : function( rowData ){
							if(rowData.wehagoKey != ""){
								if(rowData.wehagoSyncYn == "Y"){
									return '<input type="button" style="background:#03a9f4;color:#fff" class="puddSetup" value="연동" />';
								}
								else{
									return '<input type="button" onclick="wehagoInsertOrgEmpChartAll(\''+rowData.compSeq+'\');" class="puddSetup" value="미연동" />';	
								}
								
							}
							else{
								return '<input type="button" onclick="fnSetWehagoSync(\''+rowData.compSeq+'\');" class="puddSetup" value="미연동" />';
							}
							
						}
					}
				}
			,	{
					title:"WEHAGO"
				,	width:80
				,	content : {
						template : function( rowData ){
							if(rowData.wehagoKey != ""){
								return '<img onclick="fnSetWehagoSet(\''+rowData.compSeq+'\');" src="/gw/Images/ico/ico_wehago.png" alt="바로가기" style="cursor:pointer;" />';
							}
							else{
								return '<img src="/gw/Images/ico/ico_wehago_off.png" alt="" />';
							}
							
						}
					}
				}
			]
	});
}

function wehagoInsertOrgEmpChartAll(compSeq) {
	if (!confirm("전체 조직도정보를 전송하시겠습니까?")) {
		return;
	}
	
	var tblParam = {};
	tblParam.compSeq = compSeq;
	
	$.ajax({
		type:"post",
		url:'/gw/systemx/wehagoInsertOrgEmpChartAll.do',
		datatype:"text",
		data:tblParam,
		success:function(data){
			rederGrid();
		}
	});
	
}

function fnSetWehagoSync(compSeq){
	var tblParam = {};
	
	tblParam.compSeq = compSeq;
	
	$.ajax({
			type:"post",
			url:'/gw/systemx/getWehagoJoinUrl.do',
			datatype:"text",
			data:tblParam,
			success:function(data){
				if(data.resultCode == "success"){
					wehagoJoinCompSeq = compSeq;
					wehagoJoinUrl = data.joinUrl;
					console.log('data', data);
					
					var url = "/gw/systemx/wehagoJoinPop.do";
					var pop = openWindow2(url,  "wehagoJoinPop", 1000, 700, 0) ;
					pop.focus();
				}
				else{
					puddAlert("<%=BizboxAMessage.getMessage("", "조직도 또는 사용자 정보가 등록되어 있지 않습니다.")%>")
				}
			}
			
	});
}

function fnSetWehagoSet(compSeq){
	var tblParam = {};
	
	tblParam.compSeq = compSeq;
	
	$.ajax({
			type:"post",
			url:'/gw/systemx/getWehagoJoinUrl.do',
			datatype:"text",
			data:tblParam,
			success:function(data){
				if(data.resultCode == "success"){
					openWindow2(data.joinUrl,  "_blank",  $(window).width(), $(window).height(), 1,1) ;
				}
				else{
					puddAlert("<%=BizboxAMessage.getMessage("", "조직도 또는 사용자 정보가 등록되어 있지 않습니다.")%>")
				}
			}
			
	});
}

function puddAlert(alertMsg){
	var puddDialog = Pudd.puddDialog({
		width : "400"
	,	height : "100"
	,	message : {
			type : "warning"
		,	content : alertMsg.replace(/\n/g, "<br>")
		}
	});
}
</script>

<!-- 컨트롤박스 -->
<div class="top_box">
	<dl>
		<dt><%=BizboxAMessage.getMessage("TX000005461", "연동상태")%></dt>
		<dd>
			<select id="syncTp" onchange="gridRead();" class="puddSetup" style="max-width:250px; min-width:120px;">
				<option value="" selected><%=BizboxAMessage.getMessage("TX000000862", "전체")%></option>
				<option value="on"><%=BizboxAMessage.getMessage("", "연동")%></option>
				<option value="off"><%=BizboxAMessage.getMessage("", "미연동")%></option>
			 </select>	
		</dd>
		<dt><%=BizboxAMessage.getMessage("", "회사명")%></dt>
		<dd><input id="compName" type="text" style="width:150px" onkeydown="if(event.keyCode==13){javascript:gridRead();}"/></dd>
		<dd><input type="button" onclick="gridRead();" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001289", "검색")%>" /></dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724", "상세검색")%> <img id="all_menu_btn" src='/gw/Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<div class="SearchDetail">
	<dl>
		<dt style="width:60px;" class="ar"><%=BizboxAMessage.getMessage("TX000000017", "회사코드")%></dt>
		<dd><input id="compCd" type="text" style="width:120px;" /></dd>						
		<dt style="width:100px;" class="ar"><%=BizboxAMessage.getMessage("TX000000024", "사업자등록번호")%></dt>
		<dd><input id="compRegistNum" type="text" style="width:140px;" /></dd>
		<dt style="width:62px;" class="ar"><%=BizboxAMessage.getMessage("TX000000026", "대표자명")%></dt>
		<dd><input id="ownerName" type="text" style="width:100px;" /></dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div id="wehagoGrid" class="mt14"></div>
</div>