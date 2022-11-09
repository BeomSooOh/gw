<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

    <!--css-->
	<link rel="stylesheet" type="text/css" href="gw/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="gw/css/common.css?ver=20201021">
	    
    <!--js-->
    <script type="text/javascript" src="/gw/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="/gw/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/Scripts/common.js"></script>
    
    
    

<body>
<input type="hidden" id="accessId" value="${accessIpInfo.accessId}">
<div class="pop_wrap" style="width:448px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900000092","IP 대역 등록")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	<div class="pop_con">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="30%"/>
						<col />
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000018429","회사")%></th>
						<td>
							<select class="selectmenu" style="width:154px;" id="ddlCompList">
								<c:forEach items="${compList}" var="list">
									<option value="${list.compSeq}">${list.compName}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th><img src="/gw/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000006878","시작 IP")%></th>
						<td>
<%-- 							<input value="${startIp_1}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="startIp_1" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","1")'/> .  --%>
<%-- 							<input value="${startIp_2}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="startIp_2" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","2")'/> .  --%>
<%-- 							<input value="${startIp_3}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="startIp_3" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","3")'/> .  --%>
<%-- 							<input value="${startIp_4}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="startIp_4" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","4")'/> --%>
							<div class="ip_adress"> 
								<input type="text" maxlength="3" class="onlythree" id="startIp_1" value="${startIp_1}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","1")'/>.
								<input type="text" maxlength="3" class="onlythree" id="startIp_2" value="${startIp_2}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","2")'/>.
								<input type="text" maxlength="3" class="onlythree" id="startIp_3" value="${startIp_3}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","3")'/>.
								<input type="text" maxlength="3" class="onlythree" id="startIp_4" value="${startIp_4}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("startIp","4")'/>
							</div>
						</td>
					</tr>
					<tr>
						<th><img src="/gw/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000006879","종료 IP")%></th>
						<td>
<%-- 							<input value="${endIp_1}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="endIp_1" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","1")'/> .  --%>
<%-- 							<input value="${endIp_2}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="endIp_2" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","2")'/> .  --%>
<%-- 							<input value="${endIp_3}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="endIp_3" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","3")'/> .  --%>
<%-- 							<input value="${endIp_4}" type="text" maxlength="3" class="ac" style="width:30px;text-indent:0;" id="endIp_4" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","4")'/> --%>
							<div class="ip_adress"> 
								<input type="text" maxlength="3" class="onlythree" id="endIp_1" value="${endIp_1}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","1")'/>.
								<input type="text" maxlength="3" class="onlythree" id="endIp_2" value="${endIp_2}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","2")'/>.
								<input type="text" maxlength="3" class="onlythree" id="endIp_3" value="${endIp_3}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","3")'/>.
								<input type="text" maxlength="3" class="onlythree" id="endIp_4" value="${endIp_4}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event); nextTarget("endIp","4")'/>
							</div>
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000018620","사용여부")%></th>
						<td>
							<input type="radio" name="inp_radio" id="useYn_Y" class="" checked="">
							<label for="useYn_Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
							<input type="radio" name="inp_radio" id="useYn_N" class="ml10" <c:if test="${accessIpInfo.useYn == 'N'}">checked</c:if> />
							<label for="useYn_N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000019823","정렬")%></th>
						<td><input type="text" style="width:162px;" id="orderNum" value="${accessIpInfo.orderNum}" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' maxlength="11"/></td>
					</tr>
				</table>
			
			</div>
	

	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok();"/>
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();" />
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->





</body>
<script type="text/javascript">
	$(document).ready(function() {
		$("#ddlCompList").val("${accessIpInfo.compSeq}");
	});
	
	$(function(){
		$(".onlythree").keyup(function () {    
			if (this.value.length == this.maxLength) {    
				$(this).next('.onlythree').focus();    
			}    
		});
	});

	function ok(){
		if($("#startIp_1").val() == "" || $("#startIp_2").val() == "" || $("#startIp_3").val() == "" || $("#startIp_4").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000021207","필수 값이 입력되지 않았습니다.")%>");
			return false;
		}
		
		if($("#endIp_1").val() == "" || $("#endIp_2").val() == "" || $("#endIp_3").val() == "" || $("#endIp_4").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000021207","필수 값이 입력되지 않았습니다.")%>");
			return false;
		}
		
		
		
		var tblParam = {};
		tblParam.startIp = $("#startIp_1").val() + "." + $("#startIp_2").val() + "." + $("#startIp_3").val() + "." + $("#startIp_4").val();
		tblParam.endIp = $("#endIp_1").val() + "." + $("#endIp_2").val() + "." + $("#endIp_3").val() + "." + $("#endIp_4").val();
		if(document.getElementById("useYn_Y").checked)
			tblParam.useYn ="Y";
		else
			tblParam.useYn ="N";
		tblParam.compSeq = $("#ddlCompList").val();
		tblParam.orderNum = $("#orderNum").val();	
		tblParam.accessId = $("#accessId").val();
		
		
		var ipPattern = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;

		var startIp = tblParam.startIp;
		var endIp = tblParam.endIp;
		
		if(!ipPattern.test(startIp) || !ipPattern.test(endIp)){
			alert("<%=BizboxAMessage.getMessage("TX900000093","IP주소 형식이 올바르지 않습니다.")%>");
			return;
		}
		//IP 범위 확인
		var startIpArr = startIp.split("."); 
		var endIpArr = endIp.split("."); 
		if(startIpArr.length == endIpArr.length){
			var pastFlag = false;
			for(var i=0 ; i < startIpArr.length ; i++){
				if(pastFlag==true){continue;}
				if(pastFlag==false){
					if(startIpArr[i]==endIpArr[i]){pastFlag = false;}
					if(parseInt(startIpArr[i])>parseInt(endIpArr[i])){alert("<%=BizboxAMessage.getMessage("TX900000094","올바른 대역대를 입력해 주세요.")%>");return;}
				}
				if(parseInt(startIpArr[i])<parseInt(endIpArr[i])){pastFlag = true;}
				if(startIpArr[i]==endIpArr[i]){pastFlag = false;}
			}
		}
		
		
		
		
		
		
		if(confirm("<%=BizboxAMessage.getMessage("TX000001979","저장 하시겠습니까?")%>")){
			$.ajax({
	        	type:"post",
	    		url:'accessIpSaveProc.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {  
	    					alert("<%=BizboxAMessage.getMessage("TX000002120","저장 되었습니다.")%>");
	    					opener.setAccessIpTable();
	    					self.close();
	    		    	} ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});
		}
		
	}
	
	function fnClose(){
		if(confirm("<%=BizboxAMessage.getMessage("TX900000095","IP대역 등록을 취소 하시겠습니까?")%>")){
			self.close();
		}
	}
	
	
	function nextTarget(target, index){
		if(index < 4){
			if($("#"+target+"_"+index).val().length == 3){
				index++;
				$("#"+target+"_"+index).focus();
				$("#"+target+"_"+index).select();
			}
		}
	}
</script>

</html>
