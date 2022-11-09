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

<script>
	var searchFlag = "";
	$(document).ready(function() {
		compComInit();
		deptManageTreeInit();
		/* 
		$("#workStatus").kendoComboBox({
			index: 0
		});
		 */
	});
	
	//회사선택 selectBox
	function compComInit() {
		var compSeqSel = $("#com_sel").kendoComboBox({
        	dataSource : ${compListJson},
            dataTextField: "compName",
            dataValueField: "compSeq",
            change: compChange,
            index : 0
        }).data("kendoComboBox");
	}
	
	
	// 조직도 트리 생성
	function deptManageTreeInit() {
		$("#orgTreeView").attr('class','jstreeSet tree_auto'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
		var compSeq = $("#com_sel").val() || '';
		var useYn = "Y";
		var bizDisplayYn = "Y" ;
		
        $('#orgTreeView').jstree({ 
        	'core' : { 
        		'data' : {
            		'url' : '<c:url value="/cmm/systemx/deptManageOrgChartListJT.do" />',
            		//'url' : '<c:url value="/cmm/systemx/orgChartListJT.do" />',
            		'cache' : false,
            		'dataType': 'JSON',
	        			'data' : function (node) { 
	        				return {'parentSeq' : (node.id == "#" ? 0 : node.id), 'compSeq' : compSeq, 'searchDept' : '', 'deptSeq' : '', 'includeDeptCode' : true, useYn : useYn, bizDisplayYn : bizDisplayYn, eaYn : 'N'};
	        				//return {'parentSeq' : (node.id == "#" ? 0 : node.id)}
	        			},
	        			'success' : function (n) {
	        				setLiAttr(n[0]);
	        			}
        		},
        		'animation' : false 
        	}
        })
        .bind("loaded.jstree", function (event, data) {
        	$(this).jstree("open_all");
		})
		.bind("select_node.jstree", function (event, data) {
			// node가 select될때 처리될 event를 적어줍니다.​
			var dataList = data.node.original;
			var seq = OJT_fnGetCompensId(dataList.id);
			var org = dataList.gbnOrg;
			//alert(JSON.stringify(dataList));
			
			fnUserInfoList(seq, org);
		});		
	}
	
	function fnSetScrollToNode(nodeId) {
		var jstree = document.getElementById('orgTreeView');
		var toY = getPosition(document.getElementById("d"+nodeId)).y;
		var offset = jstree.offsetHeight / 2;
		var topV = toY - offset;
		
		// alert('y : ' +  toY + '\nx : ' + offset + '\ntopV : ' + topV );
		
		$(".jstreeSet").animate({
			scrollTop : (toY/2)
		}, 200); // 이동
	}
	
	function setLiAttr(n){
		for(var i=0;i<n.children.length;i++){
			setLiAttr(n.children[i]);	
		}
		n.li_attr['class'] = n.tIcon;
		return;
	}
	
	//회사 변경 이벤트
	function compChange() {
		$('#orgTreeView').jstree("destroy").empty();
		$("#userInfo").html("");
		document.getElementById('all_chk').checked = false;
		deptManageTreeInit();
	}
	
	/* [노드 아이디 반환] 노드 아이디 보정하여 반환
	---------------------------------------------------------*/
	function OJT_fnGetCompensId(id){
		return id.substring(1);
	}
	
	
	
	function fnUserInfoList(seq, org) {
		searchFlag = "O";
		$("#userInfo").html("");
		
    	var param = {};

    	if(org != "d"){
    		return;
    	}
    	
    	param.deptSeq = seq;
    	param.orderFlag = "1";
    	param.existMaster = 'N';
    	param.compSeq = $("#com_sel").val();
    	
    	//eaType 파라미터가 있어야 주부서,부부서 모두 조회
    	//eaType 값 자체는 주부서,부부서 구분값으로만 쓰임. 
    	param.eaType = "NONE";
    	if($("#workStatus").val() != "all")
    		param.workStatus = $("#workStatus").val();
    	
    	$.ajax({
    		type : "post",
    		url : '<c:url value="/cmm/systemx/getUserInfo.do" />',
    		data : param,
    		datatype : "json",
    		success : function(data){
    			if(data != null || data != "") {
    				var resultList = data.result.list;
    				if(resultList.length > 0) {
    					fnUserInfoDraw(data.result.list);
    				}else{    					
    					var tag = '<tr><td colspan="6"><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다.")%></td></tr>';
    					$("#userInfo").html(tag);
    				}
    			}
    		}
    	
    	});    
    }
	
	function fnUserInfoDraw(userInfo) {
    	
    	var tag = '';
    	var empNameList = '';
    	for(var i=0; i<userInfo.length; i++) {	
    		var id = userInfo[i].deptSeq + "|" + userInfo[i].empSeq;
    		tag += '<tr>';
    		tag += '<td><input type=\"checkbox\" name=\"chk_emp\" id=\"chk_' + userInfo[i].empSeq + '▦' + userInfo[i].deptSeq + '▦' + userInfo[i].empName + '\" />';
    		tag += '<label for=\"chk_' + userInfo[i].empSeq + '\" style=\"display:none;\" ></label>';
    		tag += '</td>';
    		tag += '<td>' + userInfo[i].deptName + '</td>';
    		tag += '<td>' + userInfo[i].empName + '(' + userInfo[i].loginId + ')' + '</td>';
    		tag += '<td>' + userInfo[i].positionCodeName + '</td>';
    		tag += '<td>' + userInfo[i].dutyCodeName + '</td>';
    		tag += '<td>';
    		
    		if(userInfo[i].workStatus == "999"){
    			tag += "<%=BizboxAMessage.getMessage("TX000010068","재직")%>";  
    		}    			
   			else if(userInfo[i].workStatus == "004"){
   				tag += "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>";
   			}    			
       		else{
       			tag += "<%=BizboxAMessage.getMessage("TX000008312","퇴직")%>";
       		}
    		
    		tag += '</td>';
    		tag += '</tr>';
    	}
    	$("#userInfo").html(tag);
    }

	
	function fnSearchEmpInfo(){
		searchFlag = "B";
		$('#orgTreeView').jstree("deselect_all");
		$("#userInfo").html("");
		
    	var param = {};
    	
    	param.orderFlag = "1";
    	param.existMaster = 'N';
    	param.nameAndLoginIdAndDeptName = $("#txtSearch").val();
    	param.positionName = $("#txtPositionNm").val();
    	param.dutyName = $("#txtDutyNm").val();
    	param.compSeq = $("#com_sel").val();
    	if($("#workStatus").val() != "all")
    		param.workStatus = $("#workStatus").val();
    	
    	//eaType 파라미터가 있어야 주부서,부부서 모두 조회
    	//eaType 값 자체는 주부서,부부서 구분값으로만 쓰임. 
    	param.eaType = "NONE";
    	
    	$.ajax({
    		type : "post",
    		url : '<c:url value="/cmm/systemx/getUserInfo.do" />',
    		data : param,
    		datatype : "json",
    		success : function(data){
    			if(data != null || data != "") {
    				var resultList = data.result.list;
    				if(resultList.length > 0) {
    					fnUserInfoDraw(data.result.list);
    				}else{    					
    					var tag = '<tr><td colspan="6"><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다.")%></td></tr>';
    					$("#userInfo").html(tag);
    				}
    			}
    		}
    	
    	}); 
	}
	
	//체크박스 선택시 toggle
	function chkAll(allChkName, chkName) {
		var chkDoc = document.getElementsByName(chkName);

		var allChkName = document.getElementsByName(allChkName);
	    allCheckBox(chkDoc, allChkName[0].checked);
	}
	
	function empMovePop(){
		if(!checkBoxSelected(document.getElementsByName("chk_emp")) ) {
			alert("<%=BizboxAMessage.getMessage("TX000008781","사용자를 선택해 주세요.")%>");
			return false ;
		}
			
		var list = document.getElementsByName("chk_emp");
	    var chkedList =   checkBoxSelectedIndex(list) ;
	    
	    var empInfoList = "";
	    
	    for (var i=0;i<chkedList.length;i++){
	    	empInfoList += "|" + list[chkedList[i]].id.replace('chk_','');	
	    }
	    
	    empInfoList = empInfoList.substring(1);
	    
	    var selCompSeq = $("#com_sel").val();
	    
	    
	    $("#formEmpInfoList").val(empInfoList);
	    $("#formCompSeq").val(selCompSeq);
	    
	    //비영리경우 선택된 사용자의 미결문서 체크
	    var param = {};
	    
	    var empSeqList = "";
		var deptSeqList = "";
		var empNmList = "";
		
	    param.empInfoList = empInfoList;
	    var flag = true;
		if("${loginVO.eaType}" == "ea"){
			$.ajax({
	    		type : "post",
	    		url : '<c:url value="/cmm/systemx/checkEaDocList.do" />',
	    		data : param,
	    		async : false,
	    		datatype : "json",
	    		success : function(data){
	    			if(data.checkEmpList.length > 0){	    				
	    				arrEmpInfoList = data.checkEmpList.split("|");
	    				for(var i=0; i<arrEmpInfoList.length;i++){
	    					var arrEmpInfo = arrEmpInfoList[i].split("▦");
	    					empSeqList += "," + arrEmpInfo[0];
	    					deptSeqList += "," + arrEmpInfo[1];
	    					empNmList += "," + arrEmpInfo[2];
	    				}
	    				empSeqList = empSeqList.substring(1);
	    				deptSeqList = deptSeqList.substring(1);
	    				empNmList = empNmList.substring(1);
	    				
	    				if(!confirm("<%=BizboxAMessage.getMessage("TX900000126","미결문서 및 부재설정이 존재하는 사용자는 부서이동이 불가합니다.부서이동 정보를 제외 후 진행 하시겠습니까?")%> [<%=BizboxAMessage.getMessage("TX900000127","미결문서 진행 확인 사용자")%> : " + empNmList + "]")){
		    				flag = false;
		    			}else{
		    				$("#formEaEmpSeqList").val(empSeqList);
		    				$("#formEaDeptSeqList").val(deptSeqList);
		    				$("#formEaEmpNmList").val(empNmList);
		    			}
	    			}	    			
	    		}	    	
	    	});
		}
	    
	    if(flag){
			var pop = window.open("", "empMovePop", "width=519,height=350,scrollbars=no");
			frmEmpMove.target = "empMovePop";
			frmEmpMove.method = "post";
			frmEmpMove.action = "<c:url value='/cmm/systemx/empMovePopView.do'/>";
			frmEmpMove.submit();
			pop.focus();
	    }
	    
	}
</script>



<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
		<dd>
			<input id="com_sel" name='com_sel' style="min-width:150px;">
			</input>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></dt>
		<dd>
			<select class="selectmenu" style="width:120px;" id="workStatus">
				<option value="all" ><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="999" selected="selected"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
				<option value="004"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
				<option value="001"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></option>
			</select>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%>/<%=BizboxAMessage.getMessage("TX000000068","부서명")%></dt>
		<dd><input type="text" id="txtSearch" style="width:150px;" onkeydown="if(event.keyCode==13){javascript:fnSearchEmpInfo();}"/></dd>
		<dd class="mr40"><input id="" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="fnSearchEmpInfo();"/></dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>"/></span>
</div>

<div class="SearchDetail">
	<dl>
		<dt><%=BizboxAMessage.getMessage("TX000018672","직급")%></dt>
		<dd class="mr20"><input type="text" id="txtPositionNm" style="width:150px;"/></dd>
		<dt class="ar" style="width:59px;"><%=BizboxAMessage.getMessage("TX000000105","직책")%></dt>
		<dd class="mr20"><input type="text" id="txtDutyNm" style="width:150px;"/></dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	
	<div class="posi_re btn_div">		
		<div class="left_div">							
			<h5><%=BizboxAMessage.getMessage("TX000004804","사원목록")%></h5>
		</div>			
		<div class="right_div">
			<div class="controll_btn p0">										
				<span class="pt3"><%=BizboxAMessage.getMessage("TX000021950","※ 변경 할 사용자를 선택 후 [인사이동]버튼을 눌러 부서, 직급, 직책을 변경하여 주세요.")%></span>
				<button id="" onclick="empMovePop();"><%=BizboxAMessage.getMessage("TX000021440","인사이동")%></button>
			</div>
		</div>				
	</div>

	<!-- 콘텐츠영역 -->
	<div class="twinbox">
		<table>
			<colgroup>
				<col width="350" />
				<col width=""/>
			</colgroup>
			<tr>
				<td class="twinbox_td p0">
					<div id="orgTreeView" class="jstreeSet" style="width:350px; height:573px;"></div>
				</td>
				<td class="twinbox_td">
					<!-- 테이블 -->
					<div class="com_ta2 sc_head">
						<table>
							<colgroup>
								<col width="34"/>
								<col width="25%"/>
								<col width="25%"/>
								<col width="15%"/>
								<col width="15%"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th>								
									<input type="checkbox" name="all_chk" id="all_chk" onClick="chkAll('all_chk','chk_emp');"/>
									<label for="all_chk"></label>
								</th>
								<th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
								<th><%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%></th>
								<th><%=BizboxAMessage.getMessage("TX000018672","직급")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
								<th><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></th>													
							</tr>
						</table>
					</div>
					
					<div class="com_ta2 ova_sc2 cursor_p bg_lightgray" style="height:518px;">
						<table>
							<colgroup>													
								<col width="34"/>
								<col width="25%"/>
								<col width="25%"/>
								<col width="15%"/>
								<col width="15%"/>
								<col width=""/>
							</colgroup>		
							<tbody id="userInfo">
								<tr>
									<td colspan="6"><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다.")%></td>
								</tr>
							</tbody>					
						</table>	
					</div>
				</td>
			</tr>
		</table>
	</div>
	<form id="frmEmpMove" name="frmEmpMove">
	  <input name="formCompSeq" id="formCompSeq" type="hidden"/>
	  <input name="formEmpInfoList" id="formEmpInfoList" type="hidden"/>
	  <input name="formEaEmpSeqList" id="formEaEmpSeqList" type="hidden"/>
	  <input name="formEaDeptSeqList" id="formEaDeptSeqList" type="hidden"/>
	  <input name="formEaEmpNmList" id="formEaEmpNmList" type="hidden"/>
	</form>	
</div>