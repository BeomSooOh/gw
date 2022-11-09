<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
<%@page import="main.web.BizboxAMessage"%>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
$(document).ready(function() {
	//기본버튼
    $(".controll_btn button").kendoButton();
    $("#useYn").kendoComboBox();

    
    var date = new Date();
    var currentYear = date.getFullYear();
    $("#hYear").kendoComboBox({
        dataSource : {
			data : [currentYear-1,currentYear,currentYear+1]
        },
        value:currentYear
    });
    
    
    
    $("#comp_sel").kendoComboBox({
	    	dataTextField: "compName",
	        dataValueField: "compSeq",
	        dataSource :${compListJson},
	        filter: "contains",
	        suggest: true,
	        index: 0
	 });
    if("${loginVO.userSe}" == "MASTER"){
		 var co2Combobox = $("#comp_sel").data("kendoComboBox");			    
		 co2Combobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "0" });
		 co2Combobox.refresh();
		 co2Combobox.select(0);
     }
	 
	 
	 
	 $("#comp_sel1").kendoComboBox({
	    	dataTextField: "compName",
	        dataValueField: "compSeq",
	        dataSource :${compListJson},
	         filter: "contains",
	        suggest: true
	 });	 
	 var co2Combobox1 = $("#comp_sel1").data("kendoComboBox");			    
	 co2Combobox1.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "0" });
	 co2Combobox1.refresh();
	 co2Combobox1.select(0);
    
	 
	 
	 
    
    //일자
    $("#hDay").kendoDatePicker({
    	format: "yyyy-MM-dd"
    });
    
    fnNew();
});	


function fnSearch(){
	fnNew();
	
	var tblParam = {};
	tblParam.compSeq = $("#comp_sel1").val();
	if($("#useYn").val() != "0")
		tblParam.useYn = $("#useYn").val();
	tblParam.txtHiliday = $("#txtHiliday").val();
	tblParam.hYear = $("#hYear").val();
	
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/systemx/getHolidayList.do" />',
		datatype:"json",
		data: tblParam,
		success:function(data){
			setHolidayListTable(data.holidayList);
		},			
		error : function(e){	//error : function(xhr, status, error) {
			alert("error");	
		}
	});	
}
	
	
function setHolidayListTable(holidayList){
	$("#holidayListTable").html("");
	
	var InnerHTML = "";
	for(var i=0;i<holidayList.length;i++){
		var holidaySeq = holidayList[i].hDay + "|" + holidayList[i].compSeq;
		var checkboxId = "check" + holidayList[i].hDay + "|" + holidayList[i].compSeq;
		InnerHTML += "<tr onclick='getHolidayInfo(this)' id='" + holidaySeq + "')><td>";
		if("${loginVO.userSe}" == "MASTER"){
			InnerHTML += "<input type='checkbox' name='check' id='" + checkboxId + "' class='k-checkbox' />";
			InnerHTML += "<label class='k-checkbox-label bdChk' for='" + checkboxId + "'></label>";
		}
		else{
			if(holidayList[i].compSeq != "0"){
				InnerHTML += "<input type='checkbox' name='check' id='" + checkboxId + "' class='k-checkbox' />";
				InnerHTML += "<label class='k-checkbox-label bdChk' for='" + checkboxId + "'></label>";
			}
		}
		InnerHTML += "</td><td>" + holidayList[i].hDay + "</td>";
		InnerHTML += "</td><td>" + holidayList[i].title + "</td>";
		InnerHTML += "</td><td>" + holidayList[i].useArea + "</td>";
		InnerHTML += "</td><td>" + holidayList[i].useYn + "</td></tr>";
	}
	$("#holidayListTable").html(InnerHTML);
}

function reSethYear(){
    var currentYear = parseInt($("#hYear").val());
    $("#hYear").kendoComboBox({
        dataSource : {
			data : [currentYear-1,currentYear,currentYear+1]
        },
        value:currentYear
    });
    fnSearch();
}


function getHolidayInfo(e){
	
	var table = document.getElementById("holidayListTable");
	var tr = table.getElementsByTagName("tr");
	for(var i=0; i<tr.length; i++)
		tr[i].style.background = "white";
	e.style.backgroundColor = "#E6F4FF";
	
	var hDay = e.id.split("|")[0];
	var compSeq = e.id.split("|")[1];
	
	var tblParam = {};
	tblParam.hDay = hDay;
	tblParam.compSeq = compSeq;	//전체일때 는 compSeq = 0로 넘겨줌.
	
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/systemx/getHolidayInfo.do" />',
		datatype:"json",
		data: tblParam,
		success:function(data){
			fnNew();
			$("#title").attr("disabled",false);
			$("#hDay").data("kendoDatePicker").enable(false);
			$("#comp_sel").data("kendoComboBox").enable(true);
			
			
			$("#hDay").val(data.holidayInfo.hDay);
			$("#title").val(data.holidayInfo.title);
			$("#comp_sel").data("kendoComboBox").value(data.holidayInfo.compSeq);
			$("#hidHolidaySeq").val(data.holidayInfo.hDay + "|" + data.holidayInfo.compSeq)
			
			if(data.holidayInfo.useYn == "Y")
				document.getElementById("useY").checked = true;
			else
				document.getElementById("useN").checked = true;		
			
			settingLegalHoliday(compSeq, data.legalYn);
		},			
		error : function(e){	//error : function(xhr, status, error) {
			alert("error");	
		}
	});	
	
	
}
	
	
	
function settingLegalHoliday(compSeq, legalYn){
		if(legalYn == "Y"){
			$("#title").attr("disabled","disabled");
			$("#hDay").data("kendoDatePicker").enable(false);
			$("#comp_sel").data("kendoComboBox").enable(false);
			$("#useY").attr("disabled", true);
			$("#useN").attr("disabled", true);
			
			if("${loginVO.userSe}" != "MASTER"){				
				$("#btnSave").hide();	
				if(compSeq == "0")
					$("#comp_sel").data("kendoComboBox").text("<%=BizboxAMessage.getMessage("TX000000862","전체")%>");
			}
			else{
				$("#btnSave").show();				
			}
		}
		
		
		else{
			if("${loginVO.userSe}" != "MASTER"){
				if(compSeq == "0"){
					$("#btnSave").hide();
					$("#title").attr("disabled","disabled");
					$("#hDay").data("kendoDatePicker").enable(false);
					$("#comp_sel").data("kendoComboBox").enable(false);
					$("#useY").attr("disabled", true);
					$("#useN").attr("disabled", true);
					$("#comp_sel").data("kendoComboBox").text("<%=BizboxAMessage.getMessage("TX000000862","전체")%>");
				}
				else
					$("#btnSave").show();
			}
			
		}
}










function fnNew(){
	var date = new Date();
    var currentDate = leadingZeros(date.getFullYear(), 4) + '-' +
	        leadingZeros(date.getMonth() + 1, 2) + '-' +
	        leadingZeros(date.getDate(), 2);
	
	$("#hDay").val(currentDate);
	$("#title").val("");
	$("#comp_sel").data("kendoComboBox").select(0);
	$("#hidHolidaySeq").val("")
	document.getElementById("useY").checked = true;	
	
	
	var table = document.getElementById("holidayListTable");
	var tr = table.getElementsByTagName("tr");
	for(var i=0; i<tr.length; i++)
		tr[i].style.background = "white";
	
	
	document.getElementById("all_chk").checked = false;
	
	
	$("#title").attr("disabled",false);
	$("#hDay").data("kendoDatePicker").enable(true);
	$("#comp_sel").data("kendoComboBox").enable(true);
	
	$("#btnDel").show();
	$("#btnSave").show();
	
	$("#useY").attr("disabled", false);
	$("#useN").attr("disabled", false);
}


function leadingZeros(n, digits) {
    var zero = '';
    n = n.toString();

    if (n.length < digits) {
        for (i = 0; i < digits - n.length; i++)
            zero += '0';
    }
    return zero + n;
}

function fnCheckAll(){
	var isChecked;
	if(document.getElementById("all_chk").checked)
		isChecked = true;
	else
		isChecked = false;
	
	for(var i=0; i<$('input[name=check]').length;i++){
		var id = $('input[name=check]')[i].id;
		document.getElementById(id).checked = isChecked;
	}
}

function fnSave(){
	
	if($("#hDay").val() == "" || $("#title").val() == ""){
		alert("<%=BizboxAMessage.getMessage("TX000010620","필수값이 입력 되지 않았습니다")%>");
		return false;		
	}
	else{
		if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
			var tblParam = {};
			tblParam.hDay = $("#hDay").val();
			tblParam.title = $("#title").val();
			tblParam.compSeq = $("#comp_sel").val();
			tblParam.hidHolidaySeq = $("#hidHolidaySeq").val();
			if(document.getElementById("useY").checked)
				tblParam.useYn = "Y";
			else
				tblParam.useYn = "N";
			
			
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/saveHolidayInfo.do" />',
				datatype:"json",
				data: tblParam,
				success:function(data){
					if(data.result == "0"){
						alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
					}
					else{
						alert("<%=BizboxAMessage.getMessage("TX000010619","중복된 공휴일이 존재합니다")%>");
					}
					fnSearch();
				},			
				error : function(e){	//error : function(xhr, status, error) {
					alert("error");	
				}
			});	
		}
	}
	
	
}
	
function fnDel(){
	var cnt = 0;
	var arrHolidayInfo = "";
	for(var i=0; i<$('input[name=check]').length;i++){
		var id = $('input[name=check]')[i].id;
		if(document.getElementById(id).checked){
			cnt++;
			arrHolidayInfo += "&" + id.replace("check","");
		}
	}
	if(cnt == 0){
		alert("<%=BizboxAMessage.getMessage("TX000010618","삭제할 공휴일을 선택해 주세요")%>");
	}
	else{
		if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
			var tblParam = {};
			tblParam.arrHolidayInfo = arrHolidayInfo.substring(1);
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/delHolidayInfo.do" />',
				datatype:"json",
				data: tblParam,
				success:function(data){				
					alert("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>");				
					fnSearch();
				},			
				error : function(e){	//error : function(xhr, status, error) {
					alert("error");	
				}
			});
		}
	}
}
	
function legalHolidayRegPop(){
	var url = "<c:url value='/cmm/systemx/legalHolidayRegPop.do'/>?Year=" + $("#hYear").val();          
	openWindow2(url,  "legalHolidayRegPop", 698, 480, 0) ;
}
</script>
</head>










<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000006307","적용범위")%></dt>
		<dd><input id="comp_sel1" /></dd>
		<dt><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
		<dd>
		<select id="useYn" name="useYn" style="width:100px;">
			<option value="0"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
			<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
			<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
		</select>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000016376","공휴일명")%></dt>
		<dd><input class="" type="text" value="" style="width:162px" id="txtHiliday" name="txtHiliday"></dd>
		<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="fnSearch();"/></dd>
	</dl>
</div>

<div class="sub_contents_wrap" style="">
	<div class="twinbox mt14">
		<table>
			<colgroup>
				<col style="width:60%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<div class="btn_div m0 mb15">
						<div class="left_div">
							<%=BizboxAMessage.getMessage("TX000000630","조회년도")%>
							<input id="hYear" style="width:100px;" onchange="reSethYear();"/>
						</div>
						<div class="right_div">
							<div id="" class="controll_btn p0">
								<button id="" class="k-button" onclick="legalHolidayRegPop();"><%=BizboxAMessage.getMessage("TX000016261","법정공휴일 등록")%></button>
							</div>
						</div>
					</div>
					
					<!-- 테이블 -->
					<div class="com_ta2">
						<table>
							<colgroup>
								<col width="34"/>
								<col width="90"/>
								<col width="120"/>
								<col width="130"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th>
									<input type="checkbox" name="all_chk" id="all_chk" class="k-checkbox" onclick="fnCheckAll();"/>
									<label class="k-checkbox-label bdChk" for="all_chk"></label>
								</th>
								<th><%=BizboxAMessage.getMessage("TX000000634","일자")%></th>
								<th><%=BizboxAMessage.getMessage("TX000016376","공휴일명")%></th>
								<th><%=BizboxAMessage.getMessage("TX000006307","적용범위")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
							</tr>
						</table>
					</div>
					
					<div class="com_ta2 bg_lightgray ova_sc" style="height:480px;">
						<table>
							<colgroup>
								<col width="34"/>
								<col width="90"/>
								<col width="120"/>
								<col width="130"/>
								<col width=""/>
							</colgroup>
							<!-- 
							<tr>
								<td colspan="4" class="nocon" style="height:480px;">데이터가 존재하지 않습니다.</td>
							</tr>		 
							-->
							<tbody id="holidayListTable">
							<c:forEach items="${holidayList}" var="c">
			                	<tr onclick="getHolidayInfo(this)" id="${c.hDay}|${c.compSeq}">
									<td>
										<c:if test="${loginVO.userSe == 'MASTER'}">
											<input type="checkbox" name="check" id="check${c.hDay}|${c.compSeq}" class="k-checkbox" />
											<label class="k-checkbox-label bdChk" for="check${c.hDay}|${c.compSeq}"></label>
										</c:if>
										<c:if test="${loginVO.userSe == 'ADMIN'}">
											<c:if test="${c.compSeq != '0'}">
												<input type="checkbox" name="check" id="check${c.hDay}|${c.compSeq}" class="k-checkbox" />
												<label class="k-checkbox-label bdChk" for="check${c.hDay}|${c.compSeq}"></label>
											</c:if>
										</c:if>
									</td>
									<td>${c.hDay }</td>
									<td>${c.title }</td>
									<td>${c.useArea }</td>
									<td>${c.useYn }</td>
								</tr>            
		                  	</c:forEach>
		                  	</tbody>
						</table>
					</div>
					
				</td>
				<td class="twinbox_td">
					<div class="btn_div m0 mb15">
						<div class="right_div">
							<div id="" class="controll_btn p0">
								<button id="" class="k-button" onclick="fnNew();"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
								<button id="btnDel" class="k-button" onclick="fnDel();"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
							</div>
						</div>
					</div>
					
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000634","일자")%></th>
								<td>									
									<p id="hidHday" style="visibility: hidden;"></p><p id="pHday" style=""><input id="hDay" style="width:184px;"/></p>
									<input id="hidHolidaySeq" type="hidden" />
								</td>
							</tr>
							<tr>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000016376","공휴일명")%></th>
								<td><input class="" id="title" type="text" value="" style="width:182px"></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000006307","적용범위")%></th>
								<td><input id="comp_sel" style="width:182px;"/></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td>
									<input type="radio" name="radio_u1u2" id="useY" class="k-radio" checked="checked">
									<label class="k-radio-label radioSel" for="useY"><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
									<input type="radio" name="radio_u1u2" id="useN" class="k-radio">
									<label class="k-radio-label radioSel ml10" for="useN"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
								</td>
							</tr>
						</table>
					</div>
					
					<div class="btn_cen">
						<input id="btnSave" type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave();"/>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div><!-- //sub_contents_wrap -->
