<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>



<style>


    .portal_main_wrap{overflow:hidden;position:relative;width:960px;min-height:696px;margin:15px auto 0 auto;}
    .portal_con_center .portal_cc_top{float:left;width:568px;}
    .portal_con_center .portal_cc_left{float:left;width:280px;}
    .portal_con_center .portal_cc_right{float:left;width:280px;margin-left:8px !important;}
    .portal_portlet{background-color:white;cursor: move;border:1px solid #c7c7c7;margin-bottom: 8px !important;width:565px;}
    .portal_portlet .portlet_img{margin:5px;}
    .portal_portlet .portlet_img_not_use{margin:5px;opacity: 0.1;}
    .portal_portlet .link_sts{position:absolute;left:70px;margin-top:10px;font-weight:bold;}
      
    
</style>


<script>
var delList = "";
var delLinkList = "";
$(document).ready(function() {
	settingFootBtnTable();

});

function settingFootBtnTable(){
	
	var tblParam = {};
		
		tblParam.portalId = "${params.portalId}";
		var footBtnList;
		$.ajax({
    	type:"post",
		url:'getFootBotnList.do',
		datatype:"json",
        data: tblParam ,
        async: false,
		success: function (result) {
			footBtnList = result.portletBtnList;
		    } ,
	    error: function (result) { 
	    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	    		}
	});	
	
	if(footBtnList.length > 0){
		var innerHTML = "";
		$("#footBtnTable").html("");
		for(var i=0;i<footBtnList.length;i++){
			innerHTML += "<div id='btnTable" + footBtnList[i].footbtnSeq + "' btnNm='" + footBtnList[i].btnNm + "' imgUrl='" + footBtnList[i].imgUrl + "' linkUrl='" + footBtnList[i].linkUrl + "' orderNum='" + footBtnList[i].orderNum + "' displayYn='" + footBtnList[i].displayYn + "' ssoYn='"+ footBtnList[i].ssoUse +"' ssoType='"+ footBtnList[i].ssoType +"' pUserId='"+ footBtnList[i].ssoEmpCtlName +"' pPwd='"+ footBtnList[i].ssoPwdCtlName +"' pLoginCd='"+ footBtnList[i].ssoLogincdCtlName +"' pCompCd='"+ footBtnList[i].ssoCoseqCtlName +"' pErpEmpCd='"+ footBtnList[i].ssoErpempnoCtlName +"' pErpCompCd='"+ footBtnList[i].ssoErpcocdCtlName +"' baseYn='"+ footBtnList[i].baseYn +"' footBtnSeq='"+ footBtnList[i].footbtnSeq +"' portalId='"+ footBtnList[i].portalId +"' name='btnTable' linkId='"+ footBtnList[i].linkId +"' fileId='"+footBtnList[i].fileId+"' newFileId=''>";
			innerHTML += "<tr ondblclick='fnBtnModifyPop(" + JSON.stringify(footBtnList[i]) + "," + footBtnList[i].footbtnSeq + ")' id='btnItem"+ footBtnList[i].footbtnSeq +"'>";
			//체크박스
			innerHTML += "<td align='center'>";
			if(footBtnList[i].baseYn != 'Y')
				innerHTML += "<input id='checkbox"+ footBtnList[i].footbtnSeq +"' name='checkList' type='checkbox' onclick='fnCheck(this)' seq='"+footBtnList[i].footbtnSeq+"' linkId='"+footBtnList[i].linkId+"'>";	
			innerHTML += "</td>";
			
			//버튼이름
			innerHTML += "<td align='left'>";
			if(footBtnList[i].baseYn == 'Y')
				innerHTML += "&nbsp;<img src=\'" + footBtnList[i].imgUrl + "\' width='20' height='20' id='btnImg"+footBtnList[i].footbtnSeq+"'/>" + footBtnList[i].btnNm;
			else
				innerHTML += "&nbsp;<img src=\'/gw/cmm/file/fileDownloadProc.do?fileId="+footBtnList[i].fileId+"&fileSn=0' width='20' height='20' id='btnImg"+footBtnList[i].footbtnSeq+"'/>" + footBtnList[i].btnNm;	
			innerHTML += "<input type='file' id='imgFile"+footBtnList[i].footbtnSeq+"' class='hidden_file_add' />";
			innerHTML += "</td>";
			
			//링크url
			innerHTML += "<td align='left'>";
			if(footBtnList[i].baseYn != 'Y')
				innerHTML += "&nbsp;" + footBtnList[i].linkUrl;
			innerHTML += "</td>";
			
			//정렬
			innerHTML += "<td align='center' id='orderNum" + footBtnList[i].footbtnSeq +"'>" + footBtnList[i].orderNum + "</td>";
			
			//노출여부
			innerHTML += "<td align='center' id='displayNm" + footBtnList[i].footbtnSeq +"'>" + footBtnList[i].displayNm + "</td>";
			
			innerHTML += "<tr></div>";
		}
		$("#footBtnTable").html(innerHTML);
	}
	
}



function fnBtnModifyPop(btnInfo, seq){

	var targetDiv = $("#btnTable" + seq);
	
	
	$("#seq").val(seq);
	$("#btnNm").val(targetDiv.attr("btnNm"));
	$("#imgUrl").val(targetDiv.attr("imgUrl"));
	$("#linkId").val(targetDiv.attr("linkId"));
	$("#linkUrl").val(targetDiv.attr("linkUrl"));
	$("#orderNum").val(targetDiv.attr("orderNum"));
	$("#displayYn").val(targetDiv.attr("displayYn"));
	$("#ssoYn").val(targetDiv.attr("ssoYn"));
	$("#ssoType").val(targetDiv.attr("ssoType"));
	$("#pUserId").val(targetDiv.attr("pUserId"));
	$("#pPwd").val(targetDiv.attr("pPwd"));
	$("#pLoginCd").val(targetDiv.attr("pLoginCd"));
	$("#pCompCd").val(targetDiv.attr("pCompCd"));
	$("#pErpEmpCd").val(targetDiv.attr("pErpEmpCd"));
	$("#pErpCompCd").val(targetDiv.attr("pErpCompCd"));
	$("#fileId").val(targetDiv.attr("fileId"));
	$("#newFileId").val(targetDiv.attr("newFileId"));
	$("#baseYn").val(btnInfo.baseYn);
	
	
	if(btnInfo.baseYn == "Y"){
		var pop = openWindow2("", "footBtnModifyPop", 600, 275, 1, 1);
		footBtnModifyPop.target = "footBtnModifyPop";
		footBtnModifyPop.method = "post";
		footBtnModifyPop.action = "<c:url value='/cmm/systemx/portal/footBtnModifyPop.do'/>";
		footBtnModifyPop.submit();
		pop.focus();
	}		
		
	else{
		var pop = openWindow2("", "footBtnModifyPop", 600, 370,1 ,1);
		footBtnModifyPop.target = "footBtnModifyPop";
		footBtnModifyPop.method = "post";
		footBtnModifyPop.action = "<c:url value='/cmm/systemx/portal/footBtnModifyPop.do'/>";
		footBtnModifyPop.submit();
		pop.focus();
	}
}



function setBtnInfo(orderNum, displayYn, seq){
	$("#orderNum" + seq).html(orderNum);
	if(displayYn == "Y")
		$("#displayNm" + seq).html("노출");
	else
		$("#displayNm" + seq).html("미노출");
	
	
	$("#btnTable" + seq).attr("orderNum", orderNum);
	$("#btnTable" + seq).attr("displayYn", displayYn);
}





function ok(){

	var btnTable = $("div[name=btnTable]");
	var baseBtnInfo = [];
	var addBtnInfo = [];
	
	for(var i=0;i<btnTable.length;i++){		
		//패키지 기본 버튼정보 저장.
		if(($("#" + btnTable[i].id).attr("baseYn")) == "Y"){
			var btnInfo = {};
			btnInfo.orderNum = $("#" + btnTable[i].id).attr("orderNum");
			btnInfo.displayYn = $("#" + btnTable[i].id).attr("displayYn");
			btnInfo.footBtnSeq = $("#" + btnTable[i].id).attr("footBtnSeq");
			btnInfo.portalId = $("#" + btnTable[i].id).attr("portalId");
			baseBtnInfo.push(btnInfo);
		}
		
		else{
			var btnInfo = {};
			btnInfo.footBtnSeq = $("#" + btnTable[i].id).attr("footbtnSeq");
			btnInfo.portalId = $("#" + btnTable[i].id).attr("portalId");
			btnInfo.btnNm = $("#" + btnTable[i].id).attr("btnNm");
			btnInfo.linkId = $("#" + btnTable[i].id).attr("linkId");
			btnInfo.baseYn = $("#" + btnTable[i].id).attr("baseYn");
			btnInfo.displayYn = $("#" + btnTable[i].id).attr("displayYn");
			btnInfo.orderNum = $("#" + btnTable[i].id).attr("orderNum");
			btnInfo.imgUrl = $("#" + btnTable[i].id).attr("imgUrl");
			
			btnInfo.linkUrl = $("#" + btnTable[i].id).attr("linkUrl");
			btnInfo.ssoYn = $("#" + btnTable[i].id).attr("ssoYn");
			
			btnInfo.ssoType = $("#" + btnTable[i].id).attr("ssoType");
			btnInfo.ssoUrl = $("#" + btnTable[i].id).attr("linkUrl");
			btnInfo.pUserId = $("#" + btnTable[i].id).attr("pUserId");
			btnInfo.pPwd = $("#" + btnTable[i].id).attr("pPwd");
			btnInfo.pLoginCd = $("#" + btnTable[i].id).attr("pLoginCd");
			btnInfo.pCompCd = $("#" + btnTable[i].id).attr("pCompCd");
			btnInfo.pErpEmpCd = $("#" + btnTable[i].id).attr("pErpEmpCd");
			btnInfo.pErpCompCd = $("#" + btnTable[i].id).attr("pErpCompCd");
			btnInfo.ssoYn = $("#" + btnTable[i].id).attr("ssoYn");
			btnInfo.fileId = $("#" + btnTable[i].id).attr("fileId");
			btnInfo.newFileId = $("#" + btnTable[i].id).attr("newFileId");
			
 		    addBtnInfo.push(btnInfo);
		}
		
		
	}
	
	if(delList.length > 0)
		delList = delList.substring(1);
	if(delLinkList.length > 0)
		delLinkList = delLinkList.substring(1);
	
	
	if(!confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
		return false;
	}
	
	var tblParam = {};
	tblParam.baseBtnInfo = JSON.stringify(baseBtnInfo);
	tblParam.addBtnInfo = JSON.stringify(addBtnInfo);
	tblParam.delList = delList;
	tblParam.delLinkList = delLinkList;
	tblParam.portalId = "${params.portalId}";
	$.ajax({
	type:"post",
	url:'saveFootBtnListInfo.do',
	datatype:"json",
    data: tblParam ,
    async: false,
	success: function (result) {			
			self.close();
	    } ,
    error: function (result) { 
    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
    		}
	});	
}


function btnAdd(){
	
	$("#seq").val("");
	$("#btnNm").val("");
	$("#imgUrl").val("");
	$("#linkUrl").val("");
	$("#orderNum").val("");
	$("#displayYn").val("");
	$("#ssoYn").val("");
	$("#ssoType").val("");
	$("#pUserId").val("");
	$("#pPwd").val("");
	$("#pLoginCd").val("");
	$("#pCompCd").val("");
	$("#pErpEmpCd").val("");
	$("#pErpCompCd").val("");
	$("#baseYn").val("N");
	$("#newFileId").val("");
	
	
	
	
	
	var pop = openWindow2("", "footBtnModifyPop", 600, 370,1 ,1);
	footBtnModifyPop.target = "footBtnModifyPop";
	footBtnModifyPop.method = "post";
	footBtnModifyPop.action = "<c:url value='/cmm/systemx/portal/footBtnModifyPop.do'/>";
	footBtnModifyPop.submit();
	pop.focus();
}




function setAddBtnInfo(footBtnSeq,portalId,linkId,btnNm,linkUrl,orderNum,displayYn,ssoUseYn,ssoType,pUserId,pPwd,pLoginCd,pCompCd,pErpEmpCd,pErpCompCd,baseYn,newYn,displayNm,imgUrl,newFileId,fileId){	
	if(newYn == "Y"){
		var footBtnInfo = {};
		footBtnInfo.baseYn = baseYn;
		footBtnInfo.btnNm = btnNm;
		footBtnInfo.displayNm = displayNm;
		footBtnInfo.displayYn = displayYn;
		footBtnInfo.footbtnSeq = footBtnSeq;
		footBtnInfo.imgUrl = "";
		footBtnInfo.linkId = linkId;
		footBtnInfo.orderNum = orderNum;
		footBtnInfo.portalId = portalId;
		
		var innerHTML = "";
		innerHTML += "<div id='btnTable" + footBtnSeq + "' btnNm='" + btnNm + "' imgUrl='' linkUrl='" + linkUrl +"' orderNum='" + orderNum + "' displayYn='" + displayYn + "' ssoYn='"+ssoUseYn+"' ssoType='"+ssoType+"' pUserId='"+pUserId+"' pPwd='"+pPwd+"' pLoginCd='"+pLoginCd+"' pCompCd='"+pCompCd+"' pErpEmpCd='"+pErpEmpCd+"' pErpCompCd='"+pErpCompCd+"' baseYn='"+ baseYn +"' footBtnSeq='"+ footBtnSeq +"' portalId='"+ portalId +"' name='btnTable' linkId='"+linkId +"' fileId='"+fileId+"' newFileId='"+newFileId+"'>";
		innerHTML += "<tr ondblclick='fnBtnModifyPop(" + JSON.stringify(footBtnInfo) + "," + footBtnSeq + ")' id='btnItem"+ footBtnSeq +"'>";
		//체크박스
		innerHTML += "<td align='center'>";
		innerHTML += "<input id='checkbox"+ footBtnSeq +"' name='checkList' type='checkbox' seq='"+footBtnSeq+"' onclick='fnCheck(this)' linkId='"+linkId+"'>";	
		innerHTML += "</td>";
		

		//버튼이름
		innerHTML += "<td align='left'>";
		innerHTML += "&nbsp;<img src='"+imgUrl+"' width='20' height='20' id='btnImg"+footBtnSeq+"'/>" + btnNm;
		innerHTML += "<input type='file' id='imgFile"+footBtnSeq+"' class='hidden_file_add' />";
		innerHTML += "</td>";
		
		//링크url
		innerHTML += "<td align='left'>";
		innerHTML += "&nbsp;" + linkUrl;
		innerHTML += "</td>";
		
		//정렬
		innerHTML += "<td align='center' id='orderNum" + footBtnSeq +"'>" + orderNum + "</td>";
		
		//노출여부
		innerHTML += "<td align='center' id='displayNm" + footBtnSeq +"'>" + displayNm + "</td>";
		
		innerHTML += "<tr></div>";
		
		
		$("#footBtnTable").html($("#footBtnTable").html() + innerHTML);
	}
	else{
		$("#btnTable" + footBtnSeq).attr("btnNm", btnNm);
		$("#btnTable" + footBtnSeq).attr("linkUrl", linkUrl);
		$("#btnTable" + footBtnSeq).attr("orderNum", orderNum);
		$("#btnTable" + footBtnSeq).attr("displayYn", displayYn);
		$("#btnTable" + footBtnSeq).attr("ssoYn", ssoUseYn);
		$("#btnTable" + footBtnSeq).attr("ssoType", ssoType);
		$("#btnTable" + footBtnSeq).attr("pUserId", pUserId);		
		$("#btnTable" + footBtnSeq).attr("pPwd", pPwd);
		$("#btnTable" + footBtnSeq).attr("pLoginCd", pLoginCd);
		$("#btnTable" + footBtnSeq).attr("pCompCd", pCompCd);
		$("#btnTable" + footBtnSeq).attr("portalId", portalId);
		$("#btnTable" + footBtnSeq).attr("newFileId", newFileId);
		
		
		if(newFileId != ""){
			$("#btnImg" + footBtnSeq).attr("src","/gw/cmm/file/fileDownloadProc.do?fileId="+newFileId+"&fileSn=0");
		}
		
		
		$("#orderNum" + footBtnSeq).html(orderNum);
		$("#displayNm" + footBtnSeq).html(displayNm);
	}
}


function fnCheck(obj){
	var checked = $(obj)[0].checked;
	
	if($(obj).attr("name") == "all"){
		$("input[type=checkbox][name=checkList]").prop("checked",checked);
	}else{
		if($("input[type=checkbox][name=checkList]:not(:checked)").length == 0){
			$("input[type=checkbox][name=all]").prop("checked",true);
		}else{
			$("input[type=checkbox][name=all]").prop("checked",false);
		}
	}
}



function fnDel(){	
	 $.each($("input[type=checkbox][name=checkList]:checked"), function (i, t) {    	
    	if($(t).attr("linkId") != "0"){
    		delList += "," + $(t).attr("seq");
    		delLinkList += ",'" + $(t).attr("linkId")+"'";
    	}
    	
    	$("#btnTable" + $(t).attr("seq")).remove();
    	$("#btnItem" + $(t).attr("seq")).remove();    	
    });
	 
	 
	 
	 
	 
}
function fnclose(){
	self.close();
}
</script>







<div class="pop_wrap resources_reservation_wrap" style="width:600px;">

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016087","포틀릿설정")%></h1>
	</div>
	<!-- //pop_head -->

	<div class="pop_con">
		<p class="tit_p"><%=BizboxAMessage.getMessage("TX000017973","링크버튼")%>
		<input style="float: right;" type="button" value="<%=BizboxAMessage.getMessage("TX000000424","삭제")%>" onclick="fnDel();"/>
		<input style="float: right;" type="button" value="<%=BizboxAMessage.getMessage("TX000000602","등록")%>" onclick="btnAdd();"/>
		</p>
		

			<div class="com_ta2">
				<table>
					<colgroup>
						<col width="30"/>
						<col width="150"/>
						<col width="230"/>
						<col width="50"/>
						<col width=""/>
					</colgroup>
					<thead>
						<tr>
							<th><input id='checkbox' name='all' type='checkbox' onclick='fnCheck(this)'></th>
							<th><%=BizboxAMessage.getMessage("TX000017966","버튼명")%></th>
							<th><%=BizboxAMessage.getMessage("TX000017966","버튼명")%></th>
							<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
							<th><%=BizboxAMessage.getMessage("TX000009801","노출여부")%></th>
						</tr>
					</thead>
				</table>		
			</div>

			<div class="com_ta2 scroll_y_on bg_lightgray" style="height:320px;">
				<table class="brtn">
					<colgroup>
						<col width="30"/>
						<col width="150"/>
						<col width="230"/>
						<col width="50"/>
						<col width=""/>
					</colgroup>
					<tbody id="footBtnTable">
						<td colspan="5"><%=BizboxAMessage.getMessage("TX000017974","데이터가 존재하지 않습니다.")%></td>
					</tbody>
				</table>		
			</div>
	</div>		
	
	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok();"/> 
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();"/>
		</div>
	</div>	

	<form id="footBtnModifyPop" name="footBtnModifyPop">
		<input type="hidden" name="seq" id="seq">		
		<input type="hidden" name="btnNm" id="btnNm">
		<input type="hidden" name="linkId" id="linkId">
		<input type="hidden" name="linkUrl" id="linkUrl">
		<input type="hidden" name="imgUrl" id="imgUrl">
		<input type="hidden" name="orderNum" id="orderNum">
		<input type="hidden" name="displayYn" id="displayYn">
		<input type="hidden" name="ssoYn" id="ssoYn">
		<input type="hidden" name="ssoType" id="ssoType">
		<input type="hidden" name="pUserId" id="pUserId">
		<input type="hidden" name="pPwd" id="pPwd">
		<input type="hidden" name="pLoginCd" id="pLoginCd">
		<input type="hidden" name="pCompCd" id="pCompCd">
		<input type="hidden" name="pErpEmpCd" id="pErpEmpCd">
		<input type="hidden" name="pErpCompCd" id="pErpCompCd">
		<input type="hidden" name="baseYn" id="baseYn">
		<input type="hidden" name="portalId" id="portalId" value="${params.portalId}">
		<input type="hidden" name="fileId" id="fileId">	
		<input type="hidden" name="newFileId" id="newFileId">
	</form>
	
	
</div>

