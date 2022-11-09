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
		<h1><%=BizboxAMessage.getMessage("TX000021440","�λ��̵�")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	
	<div class="pop_con">
		<p class="tit_p"><%=BizboxAMessage.getMessage("TX900000128","���� �׸�")%></p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="100"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000098","�μ�")%></th>
					<td>
					<input type="text" style="width:200px;" id="deptName" value=""/> 					
					<div class="controll_btn p0">
						<button id="" onclick="fnCmmOrgPop();"><%=BizboxAMessage.getMessage("TX000000265","����")%></button>
						<input type="hidden" id="newDeptSeq" name="newDeptSeq" value="">
					</div>
					<p class="f11 mt5" id="deptPath"></p></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000099","����")%></th>
					<td>
						<input id="positionCode" name="positionCode"
									style="width: 200px;" placeholder="<%=BizboxAMessage.getMessage("TX000000265","����")%>" />
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000105","��å")%></th>
					<td>
						<input id="dutyCode" name="dutyCode"
									style="width: 200px;" placeholder="<%=BizboxAMessage.getMessage("TX000000265","����")%>" />
					</td>
				</tr>
			</table>
		</div><!--// com_ta -->
		<br />
		<p class="mt10">- <%=BizboxAMessage.getMessage("TX000022166","���� �� ������� �μ�, ����, ��å ������ �ϰ��� ���� ó�� �մϴ�.")%></p>
		<p class="mt10">- <%=BizboxAMessage.getMessage("TX000022166","���� �μ� ������ ���� �˴ϴ�.")%></p>
	</div><!-- //pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","Ȯ��")%>" onclick="ok();"/>
			<input type="button"  class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","���")%>" onclick="fnClose();"/>
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
	    	var pathName = rtnDeptPath(data.returnObj[0].pathName);     //�μ� ���� �ѷ���
	    	
	    	$("#deptPath").html(pathName);
	    }
    	
  	}
	
	
	function fnClose(){
		if(confirm("<%=BizboxAMessage.getMessage("TX900000129","�λ��̵� ó���� ����Ͻðڽ��ϱ�?")%>")){
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
			alert("<%=BizboxAMessage.getMessage("TX900000131","������ ������ ������ �ּ���.")%>")
     		return false;
     	}else{
     		
     		var msg = "<%=BizboxAMessage.getMessage("TX900000130","���õ� �������(�μ�,����,��å)��(��) �ϰ� ���� ó���մϴ�.")%> \n"
     		   msg += "<%=BizboxAMessage.getMessage("TX000013946","���� �Ͻðڽ��ϱ�?")%>"
     		    
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
     		 			alert("<%=BizboxAMessage.getMessage("TX000002073","����Ǿ����ϴ�.")%>");
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

