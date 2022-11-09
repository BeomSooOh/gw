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

<%
	String portletTp = request.getParameter("portletTp");
	String portalId = request.getParameter("portalId");
	String portletKey = request.getParameter("portletKey");
	String position = request.getParameter("position");
%>
	
<script>

$(document).ready(function() {
	fnInitWeather();	
	fnButtonEvent();
	$("#weatherCity").val("${weatherCity}");
});

function fnInitWeather() {
	var langCode = '${langCode}'
	var ddlActType = NeosCodeUtil.getCodeList("cm1010"); 
		
	var tag = '';
	var isBothLoctaion = false;
	
	// 클라우드 고객사는 이전 야후 지역코드를 가지고 있어 레디스 리빌드시 기상청 및 야후 지역코드 둘다 가져옴
	// 클라우드 레디스DB에 야후 지역코드를 삭제하면 해당 로직도 삭제 해야함
	if(ddlActType.length > 1) {
		if(ddlActType[0].CODE.indexOf(',') !== -1 || ddlActType[1].CODE.indexOf(',') !== -1){
			isBothLoctaion = true;
		}
	}
		
	
	for(var i=0; i<ddlActType.length; i++) {
		// 클라우드 고객사는 이전 야후 지역코드를 가지고 있어 레디스 리빌드시 기상청 및 야후 지역코드 둘다 가져옴
		// 둘다 가져올 경우 야후 지역코드는 리스트 노출 되지 않도록 수정
		// 클라우드 레디스DB에 야후 지역코드를 삭제하면 해당 로직도 삭제 해야함
		if(isBothLoctaion  && ddlActType[i].CODE.indexOf(',') === -1){
			continue;
		}
		var codeLangname = ddlActType[i].CODE_NM + "|" + ddlActType[i].CODE_EN + "|" + ddlActType[i].CODE_JP + "|" + ddlActType[i].CODE_CN;
		
		if(langCode == "kr") {
			tag += '<option langName="' + codeLangname + '" value=' + ddlActType[i].CODE + '>' + ddlActType[i].CODE_NM + '</option>'	;
		}
		
		if(langCode == "en") {
			tag += '<option langName="' + codeLangname + '" value=' + ddlActType[i].CODE + '>' + ddlActType[i].CODE_EN + '</option>';	
		}
		
		if(langCode == "cn") {
			tag += '<option langName="' + codeLangname + '" value=' + ddlActType[i].CODE + '>' + ddlActType[i].CODE_CN + '</option>';	
		}
		
		if(langCode == "jp") {
			tag += '<option langName="' + codeLangname + '" value=' + ddlActType[i].CODE + '>' + ddlActType[i].CODE_JP + '</option>';	
		}
		
	}
	$("#weatherCity").append(tag);

}

function fnButtonEvent() {
	$("#btn_save").click(function() {
		fnSave();
	});
	
	$("#btn_cancel").click(function() {
		self.close();
	});	
}

function fnSave() {
	var selectedElmsIds = '';
	var selectedElms = $('#orgTreeView_oc').jstree("get_selected", true);
	$.each(selectedElms, function() {
	    
	    selectedElmsIds += ','+ (this.id);
	});
	
	if(selectedElmsIds.length > 0)
		selectedElmsIds = selectedElmsIds.substring(1);	

	var param = {};
	param.portletTp= "<%= portletTp %>";
	param.portalId  ="<%= portalId %>";
	param.portletKey=  "<%= portletKey %>";
	param.position  ="<%= position %>";
	
	if("<%= position %>" == "0"){
		param.custValue0=$("#weatherCity").val() + "|" + $("#weatherCity option:selected").attr("langName");
	}else{
		param.custValue0=$("#weatherCity").val();
	}

	$.ajax({
		type: "post",
        url: '<c:url value="/cmm/systemx/setUserPortlet.do" />',
        datatype: "json",
        async: false,
        data: param,
        success: function (data) {
        	alert('<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>');
        	opener.fnDrawWeatherPortlet(param, "<%= position %>", true);
        },
        error: function (e) {

        }
	});
	fnCancel();
}

function fnCancel() {
	self.close();
}
</script>

<div class="pop_head">
	<h1><%=BizboxAMessage.getMessage("TX000016087", "포틀릿설정")%></h1>
</div>
<div class="com_ta">
	<table>
		<colgroup>
			<col width="110" />
			<col width="" />
		</colgroup>
		<tr>
			<th><%=BizboxAMessage.getMessage("TX000006274", "날씨지역")%></th>
			<td class="pd6">
				<select id="weatherCity" name="weatherCity" style="width: 156px;" />
			</td>
		</tr>
	</table>
</div>

<div class="pop_foot">
	<div class="btn_cen pt12">
		<input type="button" id="btn_save" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" /> <input
			type="button" id="btn_cancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
	</div>
</div>