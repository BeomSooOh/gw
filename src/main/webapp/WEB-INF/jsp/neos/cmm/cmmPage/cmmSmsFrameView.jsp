<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">

function Submit(){
		if("${billAuthYn}" == "Y"){
			document.frm.submit();
		}else{
			alert("<%=BizboxAMessage.getMessage("TX000017916","SMS 사용 권한이 없습니다. 관리자에게 문의 바랍니다.")%>");
			$(".index_menu").html("<%=BizboxAMessage.getMessage("TX000010113","확장기능")%><br />&nbsp;<%=BizboxAMessage.getMessage("TX000017917","상세메뉴를 선택하세요.")%>");
			$(".index_menu").show();
		}
	}

</script>

<body onload = "Submit()">
<form name="frm" action ="${smsURL}" method="post">
<input type="hidden" name="compSeq" value='${compSeq}' />
<input type="hidden" name="compName" value='${compName}' />
<input type="hidden" name="deptSeq" value='${deptSeq}' />
<input type="hidden" name="deptName" value='${deptName}' />
<input type="hidden" name="empSeq" value='${empSeq}' />
<input type="hidden" name="empName" value='${empName}' />

<input type="hidden" name="phoneList" value='${phoneList}' />
<input type="hidden" name="agentID" value='${agentID}' />
<input type="hidden" name="agentKey" value='${agentKey}' />
<input type="hidden" name="loginDate" value='${loginDate}' />
<input type="hidden" name="serviceFlag" value='${serviceFlag}' />
<input type="hidden" name="addrURL" value='${addrURL}' />
<input type="hidden" name="isAdmin" value='${isAdmin}' />
<input type="hidden" name="RecvFaxNumber" value='${RecvFaxNumber}' />
<input type="hidden" name="CallbackMobileNumber" value='${CallbackMobileNumber}' />
</form>

<div class="sub_index"><p class="index_menu" style="display:none;"></p></div>
</body>