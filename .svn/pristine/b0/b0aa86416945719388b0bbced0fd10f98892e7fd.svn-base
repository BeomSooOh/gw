<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
	<script type="text/javascript">
	
    var callBack = "${param.callback}" || "";
    var authorCode = "${param.authorCode}" || "";
    var authorType = "${param.authorType}" || "";
    var compSeq = "${param.compSeq}" || "";
    var authorBaseYn = "${param.authorBaseYn}" || "";
    var authorUseYn = "${param.authorUseYn}" || "";
    
    console.log("${result}");
    
    var userSe = '${loginVO.userSe}';
    var loginCompSeq = '${loginVO.compSeq}';
    
		$(document).ready(function() {
			//기본버튼
           $(".controll_btn button").kendoButton();
			
		   $("#popCompSeq").kendoComboBox({
			   dataTextField: "compName",
			   dataValueField: "compSeq",
			   dataSource :${compListJson},
			   value:"${param.compSeq}",
			   filter: "contains",
			   suggest: true
		   });
       		
		   var authorTypeData = new kendo.data.DataSource({
			   data: [{ CODE_NM: "<%=BizboxAMessage.getMessage("TX000000286","사용자")%>", CODE: "001" },  {CODE_NM: "<%=BizboxAMessage.getMessage("TX000000098","부서")%>", CODE: "002" },  {CODE_NM: "<%=BizboxAMessage.getMessage("TX000000705","관리자")%>", CODE: "005" }]
		   });
		   
		   $("#popAuthorType").kendoComboBox({
			   dataSource : authorTypeData,
			   dataTextField: "CODE_NM",
			   dataValueField: "CODE",
			   change : chkAuthorType,
			   index : 0
			});	
		    
		    if(authorType != ""){
// 		    	if(authorType == "005"){
// 		    		authorTypeData.remove(authorTypeData.at(1));
// 		    		authorTypeData.remove(authorTypeData.at(0));
// 		    	}else{
// 		    		authorTypeData.remove(authorTypeData.at(2));	
// 		    	}
// 		    	authorTypeData.sync(); 
		    	
// 		    	if(authorType != "001"){
// 		    		$("input[name=popAuthorBaseYn]").attr("disabled","disabled");
// 		    	}
		    	$("#popCompSeq").data("kendoComboBox").enable(false);
		    	$("#popAuthorType").data("kendoComboBox").value(authorType);
		    	$("#popAuthorType").data("kendoComboBox").enable(false);
		    	$('input:radio[name="popAuthorBaseYn"]:radio[value="'+ authorBaseYn + '"]').prop("checked",true);
		    	$('input:radio[name="popAuthorUseYn"]:radio[value="'+ authorUseYn + '"]').prop("checked",true);
		    }else{
		    	
		    	if(userSe == "MASTER"){
		    		var coCombobox = $("#popCompSeq").data("kendoComboBox");
			    	coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000265","선택")%>", compSeq: "" });
			    	coCombobox.refresh();
			    	coCombobox.select(0);	
		    	}else{
		    		$("#popCompSeq").data("kendoComboBox").value(loginCompSeq);
		    		$("#popCompSeq").data("kendoComboBox").enable(false);
		    	}
		    }
		    
		    
		    chkAuthorType();
	        // 취소
	        $("#btnCancelPop").click(function () { 
	        	layerPopClose();
	        }); 
	        
	    	$("#btnSavePop").click(function() {authorInfoSubmit();});
	    	$("#btnDelPop").click(function() {delAuthorInfo();});
		});
		
		
		function chkAuthorType(){

			if($("#popAuthorType").val() == "001") {
				$("input[name=popAuthorBaseYn]").removeAttr("disabled");
			}else {
				$('input:radio[name="popAuthorBaseYn"]:radio[value="N"]').prop("checked",true);
				$("input[name=popAuthorBaseYn]").attr("disabled","disabled"); 
			}
		}	
		
		
		function authorInfoSubmit(){
			
			if($("#popCompSeq").val() == ""){
				alert("! <%=BizboxAMessage.getMessage("TX000010857","필수 값이 입력되지 않았습니다")%>");
				$("#popCompSeq").focus();
				return;
			}
			
			if($("#popAuthorNmKr").val() == ""){
				alert("! <%=BizboxAMessage.getMessage("TX000010857","필수 값이 입력되지 않았습니다")%>");
				$("#popAuthorNmKr").focus();
				return;
			}
			
			if(!isNumber($("#popAuthorOrder").val())){
				alert("! <%=BizboxAMessage.getMessage("TX000001996","숫자만 입력 가능합니다.")%>");
				$("#popAuthorOrder").focus();
				return;
			}

		    var data = {};
		    data.authorCode = authorCode;
		    data.authorNmKr = $("#popAuthorNmKr").val();
		    data.authorNmEn = $("#popAuthorNmEn").val();
		    data.authorNmJp = $("#popAuthorNmJp").val();
		    data.authorNmCn = $("#popAuthorNmCn").val();
		    data.authorType = $("#popAuthorType").val();
		    data.authorDc = $("#popAuthorDc").val();
		    data.authorOrder = $("#popAuthorOrder").val();
		    data.authorBaseYn = $(':radio[name="popAuthorBaseYn"]:checked').val();
		    data.authorUseYn = $(':radio[name="popAuthorUseYn"]:checked').val();
		    data.comp_seq = $("#popCompSeq").val();
				    
		    
		    if(authorCode != ''){
		    	data.submitType = "update";
		    	var isUpdate = confirm("<%=BizboxAMessage.getMessage("TX000010856","선택한 권한을 수정하시겠습니까?")%>");
		    	if(!isUpdate) return;
		    }else{
		    	data.submitType = "insert";
		    }
		    
		    $.ajax({
		    	type:"post",
		    	url:'<c:url value="/cmm/system/setAuthCode.do" />',
		    	datatype:"json",
		    	data: data,
		    	success:function(data){
		    		var result = data.result;
		    		if(result=="update"){
		    			alert('<%=BizboxAMessage.getMessage("TX000003439","수정되었습니다.")%>');
		    		}else if(result=="insert"){
		    			alert('<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>');
		    		}else{
		    			alert('<spring:message code="fail.common.sql" />');
		    		}
		    		
		    		eval(callBack)();
		            layerPopClose();
				}
		    });
		}
		
		function delAuthorInfo(){
			
		    var arrValue = new Array(1);

		    var arrNew = {};
		    arrNew.authorCode = authorCode;
		    arrValue[0] = eval(arrNew);

			var tblParam = {};
			tblParam.selectedList = JSON.stringify(arrValue);
			
			var isDel = confirm("! "+"<%=BizboxAMessage.getMessage("TX000016374","권한 삭제 시 연결된 메뉴 및 사용자가 모두 초기화 됩니다.　삭제 하시겠습니까?")%>".replace("　","\n"));/*삭제하시겠습니까?*/
			if(!isDel) return;
			
			$.ajax({
				type : "post",
				url  : '<c:url value="/cmm/system/delAuthCode.do" />',
				datatype : "json",
				data : tblParam,
				success:function(data){
					var result = data.result;
					if(result == 'delete'){
						alert('<%=BizboxAMessage.getMessage("TX000002121","삭제 되었습니다.")%>');
						eval(callBack)();
			            layerPopClose();
					}else{
						alert('<%=BizboxAMessage.getMessage("TX000008904","삭제 처리중 오류가 발생하였습니다")%>');
					}
					
				}
			});
		}
	</script>

</head>

<body>
<div class="pop_wrap_dir">

	<div class="pop_con">
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="130"/>
					<col width="90"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
					<td colspan="2"><input id="popCompSeq" style="width:90%;"/></td>					
				</tr>
				<tr>
					<th rowspan="4"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /><%=BizboxAMessage.getMessage("TX000000136","권한명")%></th>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th> 
					<td><input type="text" name="popAuthorNmKr" id="popAuthorNmKr"  style="width:90%;" value="${result.authorNmKr }"/></td>					
				</tr>
				
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000002790","영&nbsp;&nbsp;어")%></th>
					<td><input class="" type="text" id="popAuthorNmEn" name="popAuthorNmEn" value="${result.authorNmEn}" style="width:90%"></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
					<td><input class="" type="text" id="popAuthorNmJp" name="popAuthorNmJp" value="${result.authorNmJp}" style="width:90%"></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
					<td><input class="" type="text" id="popAuthorNmCn" name="popAuthorNmCn" value="${result.authorNmCn}" style="width:90%"></td>
				</tr>
				
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000006303","권한구분")%></th>
					<td colspan="2"><input name="popAuthorType" id="popAuthorType" style="width:100px;"/></td>					
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016352","기본부여")%></th>
					<td colspan="2">
						<input type="radio" value="Y" name="popAuthorBaseYn" id="authorBaseYn1" class="k-radio">
						<label class="k-radio-label radioSel" for="authorBaseYn1"><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
						<input type="radio" value="N" name="popAuthorBaseYn" id="authorBaseYn2" class="k-radio" checked="checked">
						<label class="k-radio-label radioSel ml10" for="authorBaseYn2" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>					</td>					
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
					<td colspan="2">
						<input type="radio" value="Y" name="popAuthorUseYn" id="authorUseYn1" class="k-radio" checked="checked">
						<label class="k-radio-label radioSel" for="authorUseYn1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
						<input type="radio"  value="N" name="popAuthorUseYn" id="authorUseYn2" class="k-radio">
						<label class="k-radio-label radioSel ml10" for="authorUseYn2" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
					</td>					
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
					<td colspan="2"><input type="text" style="width:90%;" name="popAuthorDc" id="popAuthorDc" value="${result.authorDc}"/></td>					
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
					<td colspan="2"><input type="text" style="width:90%;" name="popAuthorOrder" id="popAuthorOrder" value="${result.order_num}"/></td>	
				</tr>
			</table>
		</div>
		
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="btnSavePop" class="" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" id="btnDelPop"class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000000424","삭제")%>" />
			<input type="button" id="btnCancelPop" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->


</div><!-- //pop_wrap -->
</body>
</html>