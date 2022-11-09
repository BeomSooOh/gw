<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="main.web.BizboxAMessage"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<body>




<div class="pop_wrap">
	<div id="dialog-form-background" style="display:none; background-color:#FFFFDD;filter:Alpha(Opacity=50); z-Index:8888; width:100%; height:100%; position:absolute; top:1px; cursor:wait" ></div>
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000021440","인사이동")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	
	<div class="pop_con">
		<p class="tit_p"><%=BizboxAMessage.getMessage("TX900000128","변경 항목")%></p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="100"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
					<td>
					<input type="text" style="width:200px;" id="deptName" value=""/> 					
					<div class="controll_btn p0">
						<button id="" onclick="fnCmmOrgPop();"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
						<input type="hidden" id="newDeptSeq" name="newDeptSeq" value="">
					</div>
					<p class="f11 mt5" id="deptPath"></p></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
					<td>
						<input id="positionCode" name="positionCode"
									style="width: 200px;" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" />
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
					<td>
						<input id="dutyCode" name="dutyCode"
									style="width: 200px;" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" />
					</td>
				</tr>
			</table>
		</div><!--// com_ta -->
		<br />
		<p class="mt10">- <%=BizboxAMessage.getMessage("TX000022166","선택 한 사용자의 부서, 직급, 직책 정보를 일괄로 변경 처리 합니다.")%></p>
		<p class="mt10">- <%=BizboxAMessage.getMessage("TX000022166","기존 부서 권한은 삭제 됩니다.")%></p>
	</div><!-- //pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="ok();"/>
			<input type="button"  class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();"/>
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->

<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="d" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="" />
	<input type="hidden" id="compFilter" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>
</body>

<script type="text/javascript">
	var compSeq = "${compSeq}";
	var empList = "${formEmpInfoList}";	
	
	$(document).ready(function() {
		setPosition(compSeq, 'POSITION');
		setDuty(compSeq, 'DUTY');
	});


	function setPosition(compSeq, dpType){
		
		var dataSource = new kendo.data.DataSource({
	    	 transport: { 
	             read:  {
	                 url: 'getDutyPositionListData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.compSeq = compSeq;    
	                 options.dpType = dpType;
	                 return options;
	             }
	         }, 
	         schema:{
	 			data: function(response) {
	 	  	      return response.dpList;
	 	  	    }
	 	  	  }
	     });
		
	    $("#positionCode").kendoComboBox({
	    	dataSource : dataSource,
	        dataTextField: "dpName",
	        dataValueField: "dpSeq",
	        height: "100",
	        value : "${infoMap.deptPositionCode}",
            change: function (e) {
            	if(e.sender.selectedIndex == -1)
            		e.sender.value("");
            }	        
	    });
	
	}
	
	function setDuty(compSeq, dpType){
		
		var dataSource = new kendo.data.DataSource({
	    	 transport: { 
	             read:  {
	                 url: 'getDutyPositionListData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.compSeq = compSeq;    
	                 options.dpType = dpType;
	                 return options;
	             }
	         }, 
	         schema:{
	 			data: function(response) {
	 	  	      return response.dpList;
	 	  	    }
	 	  	  }
	     });
	
	    $("#dutyCode").kendoComboBox({
	    	dataSource : dataSource,
	        dataTextField: "dpName",
	        dataValueField: "dpSeq",
	        height: "100",
	        value : "${infoMap.deptDutyCode}",
            change: function (e) {
            	if(e.sender.selectedIndex == -1)
            		e.sender.value("");
            }
	        
	    });
	    
		
	}
	
	
	function fnCmmOrgPop(){
		$("#compFilter").val(compSeq);
		var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		$("#callback").val("callbackSel");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
		frmPop.submit();
		pop.focus();
    }
	
	
	
	function callbackSel(data) {
		if(data.returnObj.length > 0){
	    	$("#deptName").val(data.returnObj[0].deptName);
	    	$("#newDeptSeq").val(data.returnObj[0].deptSeq);
	    	var pathName = rtnDeptPath(data.returnObj[0].pathName);     //부서 상위 뿌려줌
	    	
	    	$("#deptPath").html(pathName);
	    }
    	
  	}
	
	
	function fnClose(){
		if(confirm("<%=BizboxAMessage.getMessage("TX900000129","인사이동 처리를 취소하시겠습니까?")%>")){
			self.close();
		}
	}
	
	function rtnDeptPath(pathName){
    	var deptName = '';
        var pathNameS = pathName.split('|');
        for(i = 0; i < pathNameS.length; i ++){
            if(i == pathNameS.length-1){
                deptName += '<em class="text_blue">'+pathNameS[i]+'</em>';
            }else{
                deptName += pathNameS[i]+' > ';
            }               
        }
        return deptName;
    }

	function ok(){
		if($("#positionCode").val() == "" && $("#dutyCode").val() == "" && ($("#newDeptSeq").val() == "" || $("#deptName").val() == "")){
			alert("<%=BizboxAMessage.getMessage("TX900000131","변경할 정보를 선택해 주세요.")%>")
     		return false;
     	}else{
     		
     		var msg = "<%=BizboxAMessage.getMessage("TX900000130","선택된 사용자의(부서,직급,직책)를(을) 일괄 변경 처리합니다.")%> \n"
     		   msg += "<%=BizboxAMessage.getMessage("TX000013946","진행 하시겠습니까?")%>"
     		    
     		if(confirm(msg)){
     			var param = {};
     			
     			param.empList = empList;
     			param.newDeptSeq = $("#newDeptSeq").val();
     			param.newPositonCode = $("#positionCode").val();
     			param.newDutyCode = $("#dutyCode").val();
     			param.compSeq = compSeq;
     			param.eaEmpSeqList = "${formEaEmpSeqList}";
     			param.eaDeptSeqList = "${formEaDeptSeqList}";
     			param.eaEmpNmList = "${formEaEmpNmList}";
     			state(1);
     			$.ajax({
     		     	type:"post",
     		 		url:'<c:url value="/cmm/systemx/empMoveSaveProc.do"/>',
     		 		data:param,
     		 		datatype:"text",
     		 		success: function (data) {     		 			
     		 			alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
     		 			state(0);
     		 			opener.compChange();
     		 			self.close();
     		 		},
     	            error: function (e) {     	            	
     	                alert("error");
     	                state(0);
     	            }
     		 	});
     		}
     	}
    		
     	
	}
</script>
</html>

