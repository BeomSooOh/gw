<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	$(document).ready(function() {
		//기본버튼
          $(".controll_btn button").kendoButton();
	
		//첨부파일	
        $("#files").kendoUpload({
        	localization: {
	            select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
	        }
        });

		//조회년도 셀렉트박스	
		
		var date = new Date();
    	var currentYear = date.getFullYear();
    	
    	if("${Year}" != ""){
    		currentYear = parseInt("${Year}");
		}
    	
    	
    	$("#hYear").kendoComboBox({
            dataSource : {
    			data : [currentYear-1,currentYear,currentYear+1]
            },
            value:currentYear
        });

		
		if("${Year}" != ""){
			$("#hYear").val("${Year}");
		}
		
		
		if("${holidayList}" == "[]"){
			var InnerHTML = "";
			$("#holidayListTable").html("");
			InnerHTML += "<tr><td colspan='3'><%=BizboxAMessage.getMessage("TX000016284","모든 법정공휴일이 등록되어 있습니다.")%></td></tr>";
			
			$("#holidayListTable").html(InnerHTML);
		}
	});
	
	
	function reSethYear(){
	    var currentYear = parseInt($("#hYear").val());
	    $("#hYear").kendoComboBox({
	        dataSource : {
				data : [currentYear-1,currentYear,currentYear+1]
	        },
	        value:currentYear
	    });
	    
	    var tblParam = {};
	    tblParam.hYear = $("#hYear").val();
	    $.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/legalHolidayRegPop.do" />',
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
	    
	    
	function setHolidayListTable(data){
		$("#holidayListTable").html("");
		
		var InnerHtml = "";
		
		for(var i=0;i<data.length;i++){
			var checkboxId = "check" + data[i].hDay + "|" + data[i].title;
			InnerHtml += "<tr><td><input type='checkbox' name='check' id='" + checkboxId + "' class='k-checkbox'>";
			InnerHtml += "<label class='k-checkbox-label bdChk' for='" + checkboxId + "'></label></td>";
			InnerHtml += "<td>" + data[i].hDay + "</td><td>" + data[i].title + "</td></tr>";
		}
		if(data.length == 0)
			InnerHtml += "<tr><td colspan='3'><%=BizboxAMessage.getMessage("TX000016284","모든 법정공휴일이 등록되어 있습니다.")%></td></tr>";
			
		$("#holidayListTable").html(InnerHtml);
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
		var cnt = 0;
		var arrHolidayInfo = "";
		for(var i=0; i<$('input[name=check]').length;i++){
			var id = $('input[name=check]')[i].id;
			if(document.getElementById(id).checked){
				cnt++;
				arrHolidayInfo += "&" + id.replace("check","");
			}
		}
		
		if(cnt > 0 ){
			var tblParam = {};
			
			tblParam.arrHolidayInfo = arrHolidayInfo.substring(1);
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/saveLegalHolidayInfo.do" />',
				datatype:"json",
				data: tblParam,
				success:function(data){				
					if(data.holidayCnt > 0){
						if(confirm("<%=BizboxAMessage.getMessage("TX000010622","중복되는 공휴일이 {0}건 존재합니다. 　기존 공휴일 삭제 후 등록하시겠습니까?")%>".replace("{0}",data.holidayCnt).replace("　","\n"))){
							fnSaveProc(arrHolidayInfo);
						}
					}
					else{
						if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>"))
							fnSaveProc(arrHolidayInfo);
					}
				},			
				error : function(e){	//error : function(xhr, status, error) {
					alert("error");	
				}
			});
		}
		else{
			alert("<%=BizboxAMessage.getMessage("TX000016375","공휴일을 선택해 주세요.")%>");
		}
	}
		
		
	function fnSaveProc(arrHolidayInfo){
		var tblParam = {};
		tblParam.arrHolidayInfo = arrHolidayInfo.substring(1);
		tblParam.saveFlag = "Y";
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/saveLegalHolidayInfo.do" />',
			datatype:"json",
			data: tblParam,
			success:function(data){				
				alert("<%=BizboxAMessage.getMessage("TX000015449","등록되었습니다.")%>");
				opener.fnSearch();
				self.close();
			},			
			error : function(e){	//error : function(xhr, status, error) {
				alert("error");	
			}
		});
	}
</script>


<body class="">
<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016261","법정공휴일 등록")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	<div class="pop_con">

		<div class="fl mb10" style="width:100%;">
			<span class="fl"><input id="hYear" style="width:100px;" onchange="reSethYear();"/></span>			
			<c:if test="${userSe == 'MASTER'}">
				<span class="fr mt5"><%=BizboxAMessage.getMessage("TX000016450","※ 법정공휴일의 적용범위는 전체회사입니다.")%></span>
			</c:if>
		</div>
		
		<!-- 테이블 -->
		<div class="com_ta2 ">
			<table>
				<colgroup>
					<col width="34"/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>
						<input type="checkbox" name="all_chk" id="all_chk" class="k-checkbox" onclick="fnCheckAll();">
						<label class="k-checkbox-label bdChk" for="all_chk"></label>
					</th>
					<th><%=BizboxAMessage.getMessage("TX000000634","일자")%></th>
					<th><%=BizboxAMessage.getMessage("TX000016376","공휴일명")%></th>
				</tr>
			</table>
		</div>

		<div class="com_ta2 ova_sc bg_lightgray" style="height:296px;">
			<table>
				<colgroup>
					<col width="34"/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tbody id="holidayListTable">
				<c:forEach items="${holidayList}" var="c">
				<tr>
					<td>
						<input type="checkbox" name="check" id="check${c.hDay}|${c.title}" class="k-checkbox">
						<label class="k-checkbox-label bdChk" for="check${c.hDay}|${c.title}"></label>
					</td>
					<td>${c.hDay }</td>
					<td>${c.title }</td>
				</tr>	
				</c:forEach>	
				</tbody>					
			</table>
		</div>
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave();"/>
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript:window.close();"/>
		</div>
	</div><!-- //pop_foot -->


</div><!-- //pop_wrap -->
</body>