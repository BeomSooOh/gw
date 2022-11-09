<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>


<link rel="stylesheet" type="text/css" href="<c:url value='/css/jsTree/style.min.css' />" />
<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>

<script type="text/javascript">


$(document).ready(function() {
	
	var langCode = "${loginVO.langCode}";
	var kendoCulture = "ko-KR";
	
	if(langCode == "en"){
		kendoCulture = "en-US";
	}else if(langCode == "jp"){
		kendoCulture = "ja-JP";
	}else if(langCode == "cn"){
		kendoCulture = "zh-CN";
	}
		
	$("#workStatus").kendoComboBox({
		index: 0
	});
	
	
	//시작날짜
    $("#txtFrDt").kendoDatePicker({
    	format: "yyyy-MM-dd",
    	culture: kendoCulture
    });
    
    //종료날짜
    $("#txtToDt").kendoDatePicker({
    	format: "yyyy-MM-dd",
    	culture: kendoCulture
    });

 	// 기간 셋팅
    fnInitDatePicker(30);
	
	//회사선택 selectBox	
	compComInit();	
	
	gridRead();
});

var dataSource = new kendo.data.DataSource({
    serverPaging: true,
    pageSize: 10,
     transport: { 
         read:  {
             url: 'empMoveHistoryData.do',
             dataType: "json",
             type: 'post'
         },
         parameterMap: function(options, operation) {                 
             options.compSeq = $("#com_sel").val();
             options.startDate = $("#txtFrDt").val();
             options.endDate = $("#txtToDt").val();
             options.empName = $("#empName").val();
             options.empSeq = $("#empSeq").val();
             options.searchPosi = $("#txtPosition").val();
             options.searchDuty = $("#txtDuty").val();
             options.deptName = $("#deptName").val();
             options.deptSeq = $("#deptSeq").val();
             options.searchWorkStatus = $("#workStatus").val();
           	 return options;
         }
     }, 
     schema:{
        data: function(response) {
          return response.list;
        },
        total: function(response) {
          return response.totalCount;
        }
      }
 });
 
function gridDataBound(e) {
    var grid = e.sender;
    if (grid.dataSource.total() == 0) {
        var colCount = grid.columns.length;
        $(e.sender.wrapper)
            .find('tbody')
            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다.")%></td></tr>');
    }
};

function gridRead() {

	 var grid = $("#grid").kendoGrid({
			 dataSource: dataSource,
		     sortable: true ,
		     selectable: true,
		     navigatable: true,
		     pageable: {
		    	 refresh: true,
		    	 pageSizes: true
		    },
  	  		scrollable: true,
  	  		columnMenu: false,
  	  		autoBind: true,		
  	  		height: 583,
  	  		dataBound: gridDataBound,
  	  		columns: [{
  	  			field: "modifyDate",
  	  			title: "<%=BizboxAMessage.getMessage("TX000002743","변경일")%>",
  	  			headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  			sortable: true
  	  		},
  	  		{
  	  			field: "compName",
	  			title: "<%=BizboxAMessage.getMessage("TX000000018","회사명")%>",
  				headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  			sortable: true
  	  		},
  	  		{
  	  			field: "empName",
	  			title: "<%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%>",
  				headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  			sortable: true
  	  		},
  	  		{
  	  			field: "workStatus",
	  			title: "<%=BizboxAMessage.getMessage("TX000003305","재직여부")%>",
  				headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  			sortable: true
  	  		},
  	  		{
  	  			title: "<%=BizboxAMessage.getMessage("TX000007475","변경 후")%>",
  	  			headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
	  			attributes: {style: "text-align: center; vertical-align: middle;"},
	  			sortable: true,
  	  			columns: [{
  	  				field: "newDeptPathNm2",
  	  				title: "<%=BizboxAMessage.getMessage("TX000000068","부서")%>",
  	  				headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  	  			sortable: true
  	  			},
  	  			{
  	  				field: "newPositionNm",
	  				title: "<%=BizboxAMessage.getMessage("TX000018672","직급")%>",
  					headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  	  			sortable: true
  	  			},
  	  			{
  	  				field: "newDutyNm",
	  				title: "<%=BizboxAMessage.getMessage("TX000000105","직책")%>",
  					headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  	  			sortable: true
  	  			}]
  	  		},
  	  		{
  	  			title: "<%=BizboxAMessage.getMessage("TX000007476","변경 전")%>",
	  	  		headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
	  			attributes: {style: "text-align: center; vertical-align: middle;"},
	  			sortable: true,
  	  			columns: [{
  	  				field: "oldDeptPathNm2",
	  				title: "<%=BizboxAMessage.getMessage("TX000000068","부서")%>",
  					headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
  	  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
  	  	  			sortable: true
	  			},
	  			{
	  				field: "oldPositionNm",
  					title: "<%=BizboxAMessage.getMessage("TX000018672","직급")%>",
					headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
	  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
	  	  			sortable: true
	  			},
	  			{
	  				field: "oldDutyNm",
  					title: "<%=BizboxAMessage.getMessage("TX000000105","직책")%>",
					headerAttributes: {style: "text-align: center; vertical-align: middle;"}, 
	  	  			attributes: {style: "text-align: center; vertical-align: middle;"},
	  	  			sortable: true
	  			}]
  	  		}]
		 }).data("kendoGrid");

}


//회사선택 selectBox
function compComInit() {
	var compSeqSel = $("#com_sel").kendoComboBox({
    	dataSource : ${compListJson},
        dataTextField: "compName",
        dataValueField: "compSeq",
        change: gridRead,
        index : 0
    }).data("kendoComboBox");
	
	if("${loginVO.userSe}" == "MASTER"){
		var coCombobox = $("#com_sel").data("kendoComboBox");
	    var cnt = $("#com_sel").data("kendoComboBox").dataSource.data().length    
		coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
	    coCombobox.refresh();
	    coCombobox.select(1);
	}
}


//기간 셋팅
function fnInitDatePicker(dayGap) {
	// Object Date add prototype
	Date.prototype.ProcDate = function () {
		var yyyy = this.getFullYear().toString();
		var mm = (this.getMonth() + 1).toString(); //
		var dd = this.getDate().toString();
		return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-'
				+ (dd[1] ? dd : "0" + dd[0]);
	};

	var toD = new Date();
	$('#txtToDt').val(toD.ProcDate());

	
	var fromD = new Date(toD.getFullYear(), toD.getMonth(),
			toD.getDate()-dayGap);
	
	$('#txtFrDt').val(fromD.ProcDate());
}

function fnDeptPop(){
	$("[name=compFilter]").val($("#compSeq").val());
	var pop = window.open("", "cmmDeptPop", "width=799,height=769,scrollbars=no");
	frmDeptPop.target = "cmmDeptPop";
	frmDeptPop.method = "post";
	frmDeptPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
	frmDeptPop.submit();
	pop.focus(); 
}


function fnEmpPop(){
	$("[name=compFilter]").val($("#compSeq").val());
	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
	frmEmpPop.target = "cmmOrgPop";
	frmEmpPop.method = "post";
	frmEmpPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
	frmEmpPop.submit();
	pop.focus(); 
}

function callbackDeptSel(data) {
	if(data.returnObj.length > 0){		
		$("#deptName").val(data.returnObj[0].deptName);
		$("#deptSeq").val(data.returnObj[0].deptSeq);		
	}
}

function callbackEmpSel(data){
	if(data.returnObj.length > 0){		
		$("#empName").val(data.returnObj[0].empName);
		$("#empSeq").val(data.returnObj[0].empSeq);		
	}
}

function initDeptSeq(){
	$("#deptSeq").val("");
}

function initEmpSeq(){
	$("#empSeq").val("");
}


function fnExcelDown(){

	var compSeq = $("#com_sel").val();
	var startDate = $("#txtFrDt").val();
	var endDate = $("#txtToDt").val();
	var empName = $("#empName").val();
	var empSeq = $("#empSeq").val();
	var searchPosi = $("#txtPosition").val();
	var searchDuty = $("#txtDuty").val();
	var deptName = $("#deptName").val();
	var deptSeq = $("#deptSeq").val();
	var searchWorkStatus = $("#workStatus").val();
	
	var paraStr = "?compSeq=" + compSeq + "&startDate=" + startDate + "&endDate=" + endDate + "&empName=" + empName + "&empSeq=" + empSeq + "&searchPosi=" + searchPosi + "&searchDuty=" + searchDuty +"&deptName=" + deptName + "&deptSeq=" + deptSeq + "&searchWorkStatus=" + searchWorkStatus;
	
	self.location.href="/gw/cmm/systemx/empMoveHistoryExcelDown.do" + paraStr;
	
}
</script>

<div class="top_box">										
	<dl>
		<dt class="ar" style="width:40px;"><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
		<dd>
			<input id="com_sel" name='com_sel' style="min-width:150px;">
			</input>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000696","기간")%></dt>
		<dd>
			<div class="dal_div">
				<input id="txtFrDt" class="dpWid"/>
			</div>
			~
			<div class="dal_div">
				<input id="txtToDt" class="dpWid"/>
			</div>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%></dt>
		<dd style="width:160px;">
			<input id="empName" class="" type="text" value="" placeholder="" style="width:130px;" onkeyup="initEmpSeq();">
			<input id="empSeq" type="hidden">
			<a href="#" class="btn_search" onclick="fnEmpPop();"></a>
		</dd>
		<dd><input id="searchButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="gridRead();"/></dd>
	</dl>								
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>"/></span>
</div>

<div class="SearchDetail">
	<dl>
		<dt style="width:40px;"><%=BizboxAMessage.getMessage("TX000018672","직급")%></dt>
		<dd><input id="txtPosition" type="text" value="" style="width:150px;" /></dd>
		<dt style="width:53px;"><%=BizboxAMessage.getMessage("TX000000105","직책")%></dt>
		<dd><input id="txtDuty" type="text" value="" style="width:150px;" /></dd>
		<dt style="width:60px;"><%=BizboxAMessage.getMessage("TX000000068","부서명")%></dt>
		<dd>
			<input id="deptName" type="text" value="" style="width:160px;" onkeyup="initDeptSeq();"/>
			<input id="deptSeq" type="hidden">
			<input id="" type="button" class="" value="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" onclick="fnDeptPop();">
		</dd>
		<dt class="sawon" style="margin-left: 25px"><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></dt>
		<dd class="mr20">
			<select id="workStatus" name="workStatus" style="width:98px">
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="999" selected="selected"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
				<option value="001"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></option>
				<option value="004"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
			</select>
		</dd>		
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">	
	<div class="btn_div">
		<div class="left_div">
			<p class="tit_p m0 mt7"><%=BizboxAMessage.getMessage("TX000016028","사용자 목록")%></p>
		</div>

		<div class="right_div">
			<div class="controll_btn p0">
				<button id="" onclick="fnExcelDown();"><%=BizboxAMessage.getMessage("TX000002977","엑셀")%></button>
			</div>
		</div>
	</div>
		
	<div id="grid" class="com_ta2"></div>
</div>

<form id="frmDeptPop" name="frmDeptPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="d" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" name="callback" value="callbackDeptSel" />
	<input type="hidden" name="deptSeq" value="" seq="deptFlag"/>
	<input type="hidden" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>

<form id="frmEmpPop" name="frmEmpPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url2" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="u" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" name="callback" value="callbackEmpSel" />
	<input type="hidden" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>