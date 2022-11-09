<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>

	$(document).ready(function() {
		
		compComInit();
		
		if("${params.addYn}" == "0"){
			setPortalInfo();	
		}
		
	});
	
	//회사선택 selectBox
	function compComInit() {
		
		//포털구분코드 로드
		if("${params.BuildType}" == "cloud"){
			$("#portalDiv").append("<option "+("${portalInfo.portalDiv}" == "cloud" ? "selected" : "")+" value='" + "" + "'>" + "<%=BizboxAMessage.getMessage("TX800000226","A타입")%>" + "</option>");
			$("#portalDiv").append("<option "+("${portalInfo.portalDiv}" == "cloud" ? "selected" : "")+" value='" + "cloud" + "'>" + "CLOUD" + "</option>");
		}
		else{
			$("#portalDiv").append("<option "+("${portalInfo.portalDiv}" == "" ? "selected" : "")+" value='" + "" + "'>" + "<%=BizboxAMessage.getMessage("TX800000226","A타입")%>" + "</option>");
			$("#portalDiv").append("<option "+("${portalInfo.portalDiv}" == "cloud" ? "selected" : "")+" value='" + "cloud" + "'>" + "<%=BizboxAMessage.getMessage("TX800000227","B타입")%>" + "</option>");
		}
		
		if("${params.addYn}" == "1" || "${portalInfo.compSeq}" != "0"){
			<c:if test="${not empty compListJson}">
		    $("#com_sel").kendoComboBox({
		    	dataTextField: "compName",
	            dataValueField: "compSeq",
		        dataSource :${compListJson},
		        height: "100",
		        value: "${portalInfo.compSeq}",
		        filter: "contains",
		        suggest: true
		    });
		    
		    var deptComData = $("#com_sel").data("kendoComboBox");
		    deptComData.refresh();
		    deptComData.select(0);
		    
		    if("${params.addYn}" != "1")
		    	deptComData.value("${portalInfo.compSeq}");
			</c:if>			
		}else{
		    $("#com_sel").kendoComboBox({
		    	dataTextField: "compName",
	            dataValueField: "compSeq",
		        dataSource : "",
		        value: "${params.compSeq}",
		        filter: "contains",
		        suggest: true
		    });
		    
		    var deptComData = $("#com_sel").data("kendoComboBox");
		    deptComData.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "0" });
		    deptComData.refresh();
		    
		    $("input[name=useYn]").attr("disabled","");
		}
	}
	
	function setPortalInfo(){
 		$("#portalNm").val("${portalInfo.portalNm}");
 		$("#com_sel").val("${portalInfo.compSeq}");
 		$("input[name=useYn]").val(["${portalInfo.useYn}"]);
	}
	
	function fnSavePortal(){
		
		if("${portalInfo.portalDiv}" != $("#portalDiv").val()){
			alert("<%=BizboxAMessage.getMessage("TX900000492","포털 타입이 변경되어 포틀릿 재설정이 필요합니다.")%>");
		}
		
 		if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
	 		var tblParam = {};
	 		
	 		if("${params.addYn}" == "1"){
	 			tblParam.portalId = "0";	
	 		}else{
	 			tblParam.portalId = "${params.portalId}";
	 		}
	 		
	 		tblParam.portalNm = $("#portalNm").val();
	 		tblParam.portalType = $("#portalType").val();
	 		tblParam.portalDiv = $("#portalDiv").val();	 		
	 		tblParam.compSeq = $("#com_sel").val();
	 		tblParam.useYn = $("input[name=useYn]:checked").val();
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'portalInsert.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {
	    			if(result.value == "1"){
	    				
	    				if(opener != null){
	    					opener.BindKendoGrid();
	    				}
	    				
	    				fnclose();
	    			}else{
	    				alert("<%=BizboxAMessage.getMessage("TX000002439","권한이 없습니다.")%>");
	    			}
	    			//BindKendoGrid();
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
 		}			
	}
	
    function fnclose(){
    	self.close();
    }	
	

</script>

<div class="pop_wrap resources_reservation_wrap" style="width:800px;">

		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000006335","포털설정")%></h1>
		</div>
		<!-- //pop_head -->

		<div class="pop_con">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></p>
			
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="130"/>
						<col width=""/>
						<col width="120"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /><%=BizboxAMessage.getMessage("TX000006442","적용회사")%></th>
						<td>
							<dl>
								<dd><input id="com_sel" style="width:96%"></dd>
							</dl>
						</td>					
						<th><%=BizboxAMessage.getMessage("TX000006336","포털구분")%></th>
						<td>
							<select id="portalDiv" style="width:96%;" onchange="alert('<%=BizboxAMessage.getMessage("","포털 타입이 변경되어 포틀릿 재설정이 필요합니다.")%>');"></select>
							<input type="hidden" id="portalType" name="portalType"  value="${portalInfo.portalType}" />
						</td>
					</tr>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /><%=BizboxAMessage.getMessage("TX000006337","포털명")%></th>
						<td><input type="text" value="" style="width:96%" id="portalNm" name="groupIp"/></td>
						<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
						<td>
							<input type="radio" id="useYn" name="useYn" value="Y" class="k-radio" checked="checked" />
							<label class="k-radio-label radioSel" for="useYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
							<input type="radio" id="useYn2" name="useYn" value="N" class="k-radio" />
							<label class="k-radio-label radioSel ml10" for="useYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>				
						</td>
					</tr>
					<tr style="display:none;">
						<th><%=BizboxAMessage.getMessage("TX000000121","소스경로")%></th>
						<td colspan="3"><input type="text" style="width:76%" value="" name="groupDisplayName" id="groupDisplayName" onkeyup="stringToByte();" placeholder="<%=BizboxAMessage.getMessage("TX000016107","커스터마이징 포털 URL")%>"/> <a id="titleByte" style="vertical-align: bottom;"></a></td>
					</tr>
				</table>
			</div>
		</div>
		
		
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSavePortal();" /> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();" />
			</div>
		</div>
		

		
	</div>











                
  