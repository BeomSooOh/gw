<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.135.min.js"></script>
<link rel="stylesheet" type="text/css" href="/gw/js/portlet/css/pudd.css?ver=20201021">

<script>

	var patchList = ${result};

	$(document).ready(function() {
		
		var dataSource = new Pudd.Data.DataSource({
			data : patchList
		,	pageSize : 10
		,	serverPaging : false

		});
	 
		Pudd( "#grid" ).puddGrid({
		 
				dataSource : dataSource
			,	scrollable : false
			,	sortable : false
			,	sortPageSame : false		// 기본값 true : 페이지 번호 변경없음, false : sorting 컬럼 클릭시 1페이지로 이동
			, 	hoverUse : false  
			,	pageable : {
					buttonCount : 10
				,	pageList : [ 10, 20, 30, 40, 50 ]
				}
			,	resizable : false	// 기본값 false
			,	ellipsis : false
			,	hoverClick : false	// 기본값 true
			,	columns : [
					{
						field : "boxVer"
					,	title : "<%=BizboxAMessage.getMessage("TX000001095","버전")%>"
					,	width : 50
					}
				,	{
						field : "updateStartDate"
					,	title : "<%=BizboxAMessage.getMessage("TX000007407","시작일시")%>"
					,	width : 100
					}
				,	{
						field : "updateEndDate"
					,	title : "<%=BizboxAMessage.getMessage("TX000007408","종료일시")%>"
					,	width : 100
					}				
				,	{
						field:"updateResultCode"
					,	title:"<%=BizboxAMessage.getMessage("TX000001748","결과")%>"
					,	width : 50
					,	content : {
							template : function( rowData ) {
								
								if(rowData.updateResultCode == "SUCCESS"){
									return "<%=BizboxAMessage.getMessage("TX000011981","성공")%>";
								}else if(rowData.updateResultCode == "FAIL"){
									return "<%=BizboxAMessage.getMessage("TX000006510","실패")%>";	
								}else{
									return "";
								}
		 					}
						}
					}
				,	{
						field:"deptName"
					,	title:"<%=BizboxAMessage.getMessage("TX000000068","부서명")%>"
					,	width:90
					
					,	tooltip : {
						alwaysShow : true		// 말줄임 여부와 관계없이 tooltip 보여줄 것인지 설정, 기본값 false
					,	showAtClientX : true	// toolTip 보여주는 위치가 mouse 움직이는 X 좌표 기준 여부, 기본값 false ( toolTip 부모객체 기준 )
					,	attributes : { style : "text-align:left;" }
		 
						// @param : row에 해당되는 Data
					,	template : function( rowData ) {
							
							if(rowData.deptPathName != ""){
								return rowData.deptPathName;	
							}else{
								return "부서정보 없음";
							}
		 
						}
					}					
					
					}
				,	{
						field:"positionName"
					,	title:"<%=BizboxAMessage.getMessage("TX000015243","직급/직책")%>"
					,	width:90
					}				
				,	{
						field:"empName"
					,	title:"<%=BizboxAMessage.getMessage("TX000018368","담당자")%>"
					,	width:70
					}
				,	{
						field:"userIp"
					,	title:"IP"
					,	width:90
					}				
				]
		});		
		
	});
</script>

<div id="grid"></div>