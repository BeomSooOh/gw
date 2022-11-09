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
 * @title 접근가능IP설정
 * @author UC개발부
 * @since 2017. 03. 08.
 * @version
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2017. 03. 08.  주성덕        최초 생성
 
 *
 */
%>
<script>
$(document).ready(function() {
	setAccessIpTable();
});


function fnAdd(isInit){
	var accessId = "";
	if(!isInit)
		accessId = $("#accessId").val();
	else{
		$("#accessIpTable tr").removeClass("on");
		$("#accessId").val("");
		setAccessRelateTable();
	}
	var url = "/gw/cmm/systemx/accessIpRegPop.do?accessId=" + accessId;
	var pop = window.open(url, "accessIpRegPop", "width=447,height=310,scrollbars=no");
}


function chkAll() {
	var chkDoc = document.getElementsByName("access_chk");
	if(document.getElementById("inp_chk").checked)
    	allCheckBox(chkDoc, true);
	else
		allCheckBox(chkDoc, false);
}

function chkAll2() {
	var chkDoc = document.getElementsByName("relateChk");
	if(document.getElementById("inp_chk2").checked)
    	allCheckBox(chkDoc, true);
	else
		allCheckBox(chkDoc, false);
}





function setAccessIpTable(){
	var tblParam = {};
	$("#accessId").val("");
	$("#accessRelateTable").html("");
	if($("#ddlCompList").val() != "0")
		tblParam.compSeq = $("#ddlCompList").val();
	if($("#useYn").val() != "0")
		tblParam.useYn = $("#useYn").val();
	tblParam.searchTxt = $("#searchTxt").val();
	
	$.ajax({
    	type:"post",
		url:'getAccessIpList.do',
		datatype:"json",
        data: tblParam ,
		success: function (result) {  
					setAccessIpTableInnerHTML(result.accessIpList);
		    	} ,
	    error: function (result) { 
	    		}
	});
	
	function setAccessIpTableInnerHTML(accessIpList){
		$("#accessIpTable").html("");
		
		var innerHtml = '<colgroup><col width="34"/><col width=""/><col width="26%"/><col width="26%"/><col width="18%"/></colgroup>';
		for(var i=0;i<accessIpList.length;i++){
			innerHtml += '<tr accessId="' + accessIpList[i].accessId + '" ';
			innerHtml += 'groupSeq="' + accessIpList[i].groupSeq + '" ';
			innerHtml += 'compSeq="' + accessIpList[i].compSeq + '" ';
			innerHtml += 'startIp="' + accessIpList[i].startIp + '" ';
			innerHtml += 'endIp="' + accessIpList[i].endIp + '" ';
			innerHtml += 'orderNum="' + accessIpList[i].orderNum + '" ';
			innerHtml += 'useYn="' + accessIpList[i].useYn + '">';
			innerHtml += '<td><input type="checkbox" id="chk_' + accessIpList[i].accessId + '" name="access_chk" value="' + accessIpList[i].accessId + '" />';
			innerHtml += '<label for="chk_' + accessIpList[i].accessId + '" style=\"display: none;\"> </label>';
			innerHtml += '</td><td>' + accessIpList[i].compName + '</td>';
			innerHtml += '<td>' + accessIpList[i].startIp + '</td>';
			innerHtml += '<td>' + accessIpList[i].endIp + '</td>';
			if(accessIpList[i].useYn == "Y")
				innerHtml += '<td>' + '<%=BizboxAMessage.getMessage("TX000000180","사용")%>' + '</td>';
			else
				innerHtml += '<td>' + '<%=BizboxAMessage.getMessage("TX000001243","미사용")%>' + '</td>';
			innerHtml += '</tr>';
		}
		
		$("#accessIpTable").html(innerHtml);
		
		$("#accessIpTable tr").bind({
			click: function(){
				$("#accessId").val($(this).attr("accessId"));
				
				//전체 tr 초기화
				$("#accessIpTable tr").removeClass("on");
				//선택 tr 변경
				$(this).addClass("on");
				setAccessRelateTable();
				$("#compFilter").val($(this).attr("compSeq"));
			 },
			dblclick: function(){
				fnAdd(false);
			}
		});
	}
	
}

function deleteProc(){
	if(!checkBoxSelected(document.getElementsByName("access_chk")) ) {
		alert("<%=BizboxAMessage.getMessage("TX000002319","삭제할 항목을 선택하여 주세요.")%>");			
		return false ;						
	}
	var list = document.getElementsByName("access_chk");
    var chkedList =   checkBoxSelectedValue(list) ;
    
    var delAccessIds = "";
    for(var i=0;i<chkedList.length;i++){
    	delAccessIds += "," +  chkedList[i];
    }
    if(delAccessIds.length > 0)
    	delAccessIds = delAccessIds.substring(1);
    
    
    var tblParam = {};	
	tblParam.delAccessIds = delAccessIds;
	
	if(confirm("<%=BizboxAMessage.getMessage("TX000021952","IP대역을 삭제 시 설정 된 사용자 정보도 삭제됩니다.")%>\n<%=BizboxAMessage.getMessage("TX000002068","삭제 하시겠습니까?")%>")){
		$.ajax({
	    	type:"post",
			url:'deleteAccessIp.do',
			datatype:"json",
	        data: tblParam ,
			success: function (result) {  
						alert("<%=BizboxAMessage.getMessage("TX000002074","삭제 되었습니다.")%>");
						setAccessIpTable();
						setAccessRelateTable();
			    	} ,
		    error: function (result) { 
		    		}
		});
	}
}


//사원/부서선택 공통팝업
function fnUserDeptPop () {
	if($("#accessId").val() == ""){
		alert("<%=BizboxAMessage.getMessage("TX000021953","IP대역을 선택해 주세요.")%>");		
		return false;
	}	
	$("#selectMode").val("ud");
	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
	$("#callback").val("callbackSel");
	frmPop.target = "cmmOrgPop";
	frmPop.method = "post";
	frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
	frmPop.submit();
	pop.focus(); 
 }
 
function callbackSel(data){
	
	if(data.returnObj.length > 0){
		// 사용자,부서 정보 저장
		var selectList = data.returnObj;
		
		var accessId = $("#accessId").val();
		var arrGbnOrg = "";
		var arrCompSeq = "";
		var arrDeptSeq = "";
		var arrEmpSeq = "";
		
		for(var i=0;i<selectList.length;i++){
			arrGbnOrg += "," + selectList[i].empDeptFlag;
			arrCompSeq += "," + selectList[i].compSeq; 
			arrDeptSeq += "," + selectList[i].deptSeq;
			arrEmpSeq += "," + selectList[i].empSeq;
		}
		
		if(arrGbnOrg.length > 0){
			arrGbnOrg = arrGbnOrg.substring(1);
			arrCompSeq = arrCompSeq.substring(1);
			arrDeptSeq = arrDeptSeq.substring(1);
			arrEmpSeq = arrEmpSeq.substring(1);
		}
		
		var tblParam = {};	
		tblParam.accessId = accessId;
		tblParam.arrGbnOrg = arrGbnOrg;
		tblParam.arrCompSeq = arrCompSeq;
		tblParam.arrDeptSeq = arrDeptSeq;
		tblParam.arrEmpSeq = arrEmpSeq;
		
		$.ajax({
	    	type:"post",
			url:'AccessRelateSaveProc.do',
			datatype:"json",
	        data: tblParam ,
			success: function (result) {  
						if(arrGbnOrg.length > 0){
							alert("<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>");
						}
						setAccessRelateTable();
			    	} ,
		    error: function (result) { 
		    		}
		});
	}
	
}


function setAccessRelateTable(){
	var accessId = $("#accessId").val();
	var tblParam = {};	
	tblParam.accessId = accessId;
	tblParam.searchTxt = $("#searchRelateTxt").val();
	
	$.ajax({
    	type:"post",
		url:'GetAccessRelateInfo.do',
		datatype:"json",
        data: tblParam ,
		success: function (result) {  
					drawAccessRelateTable(result.list);					
		    	} ,
	    error: function () { 
	    		}
	});
}


function drawAccessRelateTable(list){
	$("#accessRelateTable").html("");
	$("#selectedItems").val("");
	var innerHtml = "";
	
	innerHtml += '<colgroup><col width="34"/><col width="30%"/><col width="30%"/><col width=""/></colgroup>';
	var selectedItems = "";
	for(var i=0;i<list.length;i++){		
		innerHtml += '<tr><td>';
		innerHtml += '<input type="checkbox" id="relate_' + list[i].idx + '" value="' + list[i].idx + '" name="relateChk" />';
		innerHtml += '<label for="relate_' + list[i].idx + '" style=\"display: none;\"></label>';
		innerHtml += '</td>';
		if(list[i].gbnOrg == "c")
			innerHtml += '<td>' + list[i].compName + '</td>';
		else
			innerHtml += '<td>' + list[i].deptName + '</td>';	
		if(list[i].gbnOrg == "u"){
			innerHtml += '<td>' + list[i].positionName + "/" + list[i].dutyName +'</td>';		
			innerHtml += '<td>' + list[i].empName + "(" + list[i].loginId + ")" +'</td>';
		}else{
			innerHtml += '<td></td>';		
			innerHtml += '<td></td>';
		}
		innerHtml += '</tr>';
		
		if(list[i].gbnOrg == "d")
			selectedItems += "," + list[i].groupSeq + "|" + list[i].compSeq + "|" + list[i].deptSeq + "|0|d";
		else if(list[i].gbnOrg == "u")
			selectedItems += "," + list[i].groupSeq + "|" + list[i].compSeq + "|" + list[i].deptSeq + "|" + list[i].empSeq + "|u";
		else if(list[i].gbnOrg == "c")
			selectedItems += "," + list[i].groupSeq + "|" + list[i].compSeq + "|" + "0" + "|" + "0" + "|c";
	}
	if(selectedItems.length > 0)
		$("#selectedItems").val(selectedItems.substring(1))
		
	$("#accessRelateTable").html(innerHtml);
	
}


function deleteRelateProc(){
	if(!checkBoxSelected(document.getElementsByName("relateChk")) ) {
		alert("<%=BizboxAMessage.getMessage("TX000002319","삭제할 항목을 선택하여 주세요.")%>");		
		return false ;						
	}
	var list = document.getElementsByName("relateChk");
    var chkedList =   checkBoxSelectedValue(list) ;
    
    var delRelateIds = "";
    for(var i=0;i<chkedList.length;i++){
    	delRelateIds += "," +  chkedList[i];
    }
    if(delRelateIds.length > 0)
    	delRelateIds = delRelateIds.substring(1);
    
    
    var tblParam = {};	
	tblParam.delRelateIds = delRelateIds;
	tblParam.accessId = $("#accessId").val();
	
	if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제 하시겠습니까?")%>")){
		$.ajax({
	    	type:"post",
			url:'deleteAccessRelate.do',
			datatype:"json",
	        data: tblParam ,
			success: function (result) {  
						alert("<%=BizboxAMessage.getMessage("TX000002074","삭제 되었습니다.")%>");
						setAccessRelateTable();
			    	} ,
		    error: function (result) { 
		    		}
		});
	}
}

</script>
<form id="frmPop" name="frmPop"> 
		<input type="hidden" name="selectedItems" id="selectedItems" value="" />
		<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do" />
		<input type="hidden" name="selectMode" id="selectMode" value="ud" />
		<input type="hidden" name="selectItem" value="m" />
		<input type="hidden" id="callback" name="callback" value="" />
		<input type="hidden" id="compFilter" name="compFilter" value="" />
		<input type="hidden" id="targetDeptSeq" name="targetDeptSeq" value="" />
		<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 

</form>

<div class="top_box">
	<input type="hidden" value="" id="accessId" />
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
		<dd>
			<select class="selectmenu" style="width:150px;" id="ddlCompList" onchange="setAccessIpTable();">
				<c:if test="${params.userSe != 'ADMIN'}">
					<option value="0" selected="selected"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				</c:if>
				<c:forEach items="${compList}" var="list">
					<option value="${list.compSeq}">${list.compName}</option>
				</c:forEach>
			</select>									
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000020281","사용여부")%></dt>
		<dd>
			<select class="selectmenu" style="width:80px;" id="useYn" onchange="setAccessIpTable();">
				<option value="0"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="Y" selected="selected"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
				<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
			</select>									
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000245","사용IP")%></dt>
		<dd>
			<input id="searchTxt" class="" type="text" value="" placeholder="" style="width:162px;" onkeydown="if(event.keyCode==13){javascript:setAccessIpTable();}">
		</dd>
		<dd class="mr40"><input id="btnSearch" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="setAccessIpTable();"/></dd>
	</dl>
</div>

<p class="text_blue mt20"><%=BizboxAMessage.getMessage("","※ IP대역 등록 후 사용자/부서 설정 시, 설정 된 사용자/부서는 해당 IP대역에서만 그룹웨어(WEB/PC메신저) 접속이 가능합니다. (겸직 사용자의 경우 겸직 회사에 모두 반영)")%></p>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="twinbox mt15">
	<table>
		<colgroup>
	<col style="width:50%;" />
	<col />
</colgroup>
<tr>
	<td class="twinbox_td p0">
		<div class="pl15 pr15 clear">
			<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000021954","IP 대역 목록")%></p>
			
			<div class="controll_btn fr">
				<button id="btnAdd" onclick="fnAdd(true);"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
				<button id="btnDel" onclick="deleteProc();"><%=BizboxAMessage.getMessage("TX000005668","삭제")%></button>
			</div>
		</div>
		
		<!-- 테이블 -->
		<div class="com_ta2 sc_head ml15 mr15">
			<table>
				<colgroup>
					<col width="34"/>
					<col width=""/>
					<col width="26%"/>
					<col width="26%"/>
					<col width="18%"/>
				</colgroup>
				<tr>
					<th>
						<input type="checkbox" id="inp_chk" onclick="chkAll();"/>
						<label for="inp_chk"></label>
					</th>
					<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
					<th><%=BizboxAMessage.getMessage("TX000006878","시작 IP")%></th>
					<th><%=BizboxAMessage.getMessage("TX000006879","종료 IP")%></th>
					<th><%=BizboxAMessage.getMessage("TX000020281","사용여부")%></th>
				</tr>
			</table>
		</div>
		
		<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc2" style="height:477px;">
			<table id="accessIpTable">
				<colgroup>
					<col width="34"/>
					<col width=""/>
					<col width="26%"/>
					<col width="26%"/>
					<col width="18%"/>
				</colgroup>							
			</table>	
		</div>
	</td>
	<td class="twinbox_td p0">
		
		<div class="tb_borderB pl15 pr15 clear bg_lightgray">
			<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000000286","사용자")%> / <%=BizboxAMessage.getMessage("TX000000098","부서")%></p>
			<!-- <p class="tit_p fl mt14">IP접속 사용자/ 접속 부서 목록</p> -->
			<div class="fl ml10 mt9 clear">
				<input id="searchRelateTxt" class="fl" type="text" value="" placeholder="" style="text-indent:8px;width:162px;" onkeydown="if(event.keyCode==13){javascript:setAccessRelateTable();}">
				<a href="#n" class="fl btn_search" onclick="setAccessRelateTable();"></a>
			</div>
		</div>
		
		<div class="pl15 pr15 clear">
			<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000000286","사용자")%> / <%=BizboxAMessage.getMessage("TX000016250","부서 목록")%> </p>
			
			<div class="controll_btn fr">
				<button onclick="fnUserDeptPop();"><%=BizboxAMessage.getMessage("TX000000286","사용자")%>/<%=BizboxAMessage.getMessage("TX000002687","부서 선택")%></button>
				<button id="btnOrgDel" onclick="deleteRelateProc();"><%=BizboxAMessage.getMessage("TX000005668","삭제")%></button>
			</div>
		</div>
		
		<!-- 테이블 -->
		<div class="com_ta2 sc_head ml15 mr15">
			<table>
				<colgroup>
					<col width="34"/>
					<col width="30%"/>
					<col width="30%"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>
						<input type="checkbox" id="inp_chk2" onclick="chkAll2();"/>
						<label for="inp_chk2"></label>
					</th>
					<th><%=BizboxAMessage.getMessage("TX000016055","회사/부서")%></th>
					<th><%=BizboxAMessage.getMessage("TX000015243","직급/직책")%></th>
					<th><%=BizboxAMessage.getMessage("TX000016217","사용자명(ID)")%></th>
					
				</tr>
			</table>
		</div>
		
		<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc2" style="height:419px;">
			<table id="accessRelateTable">
				<colgroup>
					<col width="34"/>
					<col width="30%"/>
					<col width="30%"/>
					<col width=""/>
				</colgroup>
						
					</table>	
				</div>
			</td>
		</tr>
	</table>
</div>



</div><!-- //sub_contents_wrap -->