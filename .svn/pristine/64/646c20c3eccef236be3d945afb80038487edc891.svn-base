
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>


<script>
var imgFile = null;
var imgUrl = "";
$(document).ready(function() {	
	
	$("button").kendoButton();  
	
	if("${params.ssoYn}" == 'Y'){
		document.getElementById("ssoUseYn").checked = true;
	}
		
	fnSsoUseYn();
	
	
	if("${params.fileId}" != "")
		$("#btnimg").attr("src","/gw/cmm/file/fileDownloadProc.do?fileId=${params.fileId}&fileSn=0");
	if("${params.newFileId}" != "")
		$("#btnimg").attr("src","/gw/cmm/file/fileDownloadProc.do?fileId=${params.newFileId}&fileSn=0");
	
	
	
	$("#pUserId").val(isNull("${params.pUserId}"));
	$("#pCompCd").val(isNull("${params.pCompCd}"));
	$("#pPwd").val(isNull("${params.pPwd}"));
	$("#pErpEmpCd").val(isNull("${params.pErpEmpCd}"));
	$("#pLoginCd").val(isNull("${params.pLoginCd}"));
	$("#pErpCompCd").val(isNull("${params.pErpCompCd}"));
	
});


function fnclose(){
	self.close();
}


function fnSsoUseYn(){
	if(document.getElementById("ssoUseYn").checked){
		$("#ssoOpDiv").show();
	}
	else
		$("#ssoOpDiv").hide();
}

function ok(){
	if("${params.baseYn}" == "Y"){
		var orderNum = $("#orderNum").val();
		var displayYn = "";		
		var seq = "${params.seq}"
		if(document.getElementById("displayYn").checked)
			displayYn = "Y";
		else
			displayYn = "N";
		
		opener.setBtnInfo(orderNum, displayYn, seq);
	}
	else{
		if($("#btnNm").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000017962","버튼명을 입력해 주세요.")%>");
			$("#btnNm").focus();
			return false;
		}
		
		
		var footBtnSeq = "${params.footBtnSeq}";
		var portalId = "${params.portalId}";
		var linkId = "${params.linkId}";
		var fileId = "${params.fileId}";
		var btnNm = $("#btnNm").val();
		var linkUrl = $("#linkUrl").val();
		var orderNum = $("#orderNum").val();
		var displayYn = "";
		var displayNm = "";
		if(document.getElementById("displayYn").checked){
			displayYn = "Y";
			displayNm = "<%=BizboxAMessage.getMessage("TX000009160","노출")%>";
		}
		else{
			displayYn = "N";
			displayNm = "<%=BizboxAMessage.getMessage("TX000017963","미노출")%>";
		}
			
		var ssoYn= "";
		if(document.getElementById("ssoUseYn").checked)
			ssoYn = "Y";
		else
			ssoYn = "N";
		
		
		var ssoType= "";
		if(document.getElementById("ssoType").checked)
			ssoType = "GET";
		else
			ssoType = "POST";
		
		
		
		
		var pUserId = $("#pUserId").val();
		var pPwd = $("#pPwd").val();
		var pLoginCd = $("#pLoginCd").val();
		var pCompCd = $("#pCompCd").val();
		var pErpEmpCd = $("#pErpEmpCd").val();
		var pErpCompCd = $("#pErpCompCd").val();
		var baseYn = "N";
		var newYn = "${params.newYn}";
		var newFileId = "";
		
		
		var formData = new FormData();
		var img = $("#btnImgUpload")[0];
		
		if(img.files[0] != null){
			formData.append("file", img.files[0]);
			formData.append("pathSeq", "900");	//이미지 폴더
			formData.append("relativePath", "/footBtn"); // 상대 경로
		 
			$.ajax({
	            url: _g_contextPath_ + "/cmm/file/fileUploadProc.do",
	            type: "post",
	            dataType: "json",
	            data: formData,
	            // cache: false,
	            processData: false,
	            contentType: false,
	            async: false,
	            success: function(data) {
	            	newFileId=data.fileId;
	            },
	            error: function (result) { 
		    			alert("<%=BizboxAMessage.getMessage("TX000017964","파일업로드실패")%>");
		    			return false;
		    		}
	         });
		}
		
		opener.setAddBtnInfo(footBtnSeq,portalId,linkId,btnNm,linkUrl,orderNum,displayYn,ssoYn,ssoType,pUserId,pPwd,pLoginCd,pCompCd,pErpEmpCd,pErpCompCd,baseYn,newYn,displayNm,imgUrl,newFileId,fileId);
		
	}
	self.close();
}



function btnImgUpload(value){
	
	if(value.files && value.files[0]) 
	{
		var reader = new FileReader();

		reader.onload = function (e) {
			$('#btnimg').attr('src', e.target.result);
			imgUrl = e.target.result;
		}	
		reader.readAsDataURL(value.files[0]);
		imgFile = value.files[0];
		
	}
}

function fnAddBtnClick(){
		$(".hidden_file_add").click();
}



//null값 체크(''공백 반환)
function isNull(obj){
	return (typeof obj != "undefined" && obj != null) ? obj : "";
}
</script>


<div class="pop_wrap resources_reservation_wrap" style="width:600px;">

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000017965","버튼정보")%></h1>
	</div>
	<!-- //pop_head -->
	
	<c:if test="${params.baseYn == 'Y'}">
	<div class="pop_con">
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="110"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000017966","버튼명")%></th>
					<td>${params.btnNm}</td>						
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000017967","아이콘")%></th>
					<td>${params.imgUrl}</td>
				</tr>												
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000125","정렬순서")%></th>
					<td>
						<input id="orderNum" type="text" value="${params.orderNum}" style="width: 95%;" />
					</td>
				</tr>	
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000009801","노출여부")%></th>
					<td>
						<input type="radio" id="displayYn" name="displayYn" value="Y" class="k-radio" checked="checked" />
						<label class="k-radio-label radioSel" for="displayYn"><%=BizboxAMessage.getMessage("TX000009160","노출")%></label>
						<input type="radio" id="displayYn2" name="displayYn" value="N" class="k-radio" <c:if test="${params.displayYn == 'N'}">checked</c:if> />
						<label class="k-radio-label radioSel ml10" for="displayYn2"><%=BizboxAMessage.getMessage("TX000017963","미노출")%></label>				
					</td>
				</tr>				
			</table>
		</div>			
	</div>		
	</c:if>	
	
	
	
	
	
	
	
	<c:if test="${params.baseYn == 'N'}">
	<div class="pop_con">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="130"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000017966","버튼명")%></th>
						<td><input style="width:90%;" type="text" id="btnNm" value="${params.btnNm}"/></td>
					</tr>
				
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000017967","아이콘")%></th>
						<td>
							<img id=btnimg alt="" width="20" height="20">
							&nbsp;&nbsp;
							<button id="" onclick="fnAddBtnClick();" style="float: center;"><%=BizboxAMessage.getMessage("TX000005667","등록")%> </button>&nbsp;&nbsp;<%=BizboxAMessage.getMessage("TX000017968","(20*20 픽셀)")%></td>
							<p id="p_File">
								<input type="file" id="btnImgUpload" class="hidden_file_add" name="btnImgUpload" onchange="btnImgUpload(this);"/>
							</p>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016305","링크URL")%></th>
						<td><input style="width:90%;" type="text" id="linkUrl" value="${params.linkUrl}"/></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000125","정렬순서")%></th>
						<td><input style="width:90%;" type="text" id="orderNum" value="${params.orderNum}"/></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000009801","노출여부")%></th>
						<td>
							<input type="radio" id="displayYn" name="displayYn" value="Y" class="k-radio" checked="checked" />
							<label class="k-radio-label radioSel" for="displayYn"><%=BizboxAMessage.getMessage("TX000009160","노출")%></label>
							<input type="radio" id="displayYn2" name="displayYn" value="N" class="k-radio" <c:if test="${params.displayYn == 'N'}">checked</c:if> />
							<label class="k-radio-label radioSel ml10" for="displayYn2"><%=BizboxAMessage.getMessage("TX000017963","미노출")%></label>								
						</td>
					</tr>	
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016405","SSO연동")%></th>
						<td>
							<input type="radio" id="ssoUseYn" name="ssoUseYn" value="Y" class="k-radio" onclick="fnSsoUseYn()" />
							<label class="k-radio-label radioSel" for="ssoUseYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
							<input type="radio" id="ssoUseYn2" name="ssoUseYn" value="N" class="k-radio" checked="checked" onclick="fnSsoUseYn()"/>
							<label class="k-radio-label radioSel ml10" for="ssoUseYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>								
						</td>
					</tr>										
										
				</table>
			</div>
			
			<div style="height:10px" ></div>
			
			
<!-- 			<div style="display:none;"> -->
<!-- 			<div style="height:20px" ></div> -->
<!-- 			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000017969","SSO설정")%></p> -->
<!-- 			</div> -->
			
			<div class="com_ta" id="ssoOpDiv">
				<table>
					<colgroup>
						<col width="130"/>
						<col width="160"/>
						<col width="130"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016174","연동타입")%></th>
						<td colspan="3">
							<input type="radio" id="ssoType" name="ssoType" value="GET" class="k-radio" checked="checked"/>
							<label class="k-radio-label radioSel" for="ssoType"><%=BizboxAMessage.getMessage("TX000016419","GET 방식")%></label>
							<input type="radio" id="ssoType2" name="ssoType" value="POST" class="k-radio" <c:if test="${params.ssoType == 'POST'}">checked</c:if>/>
							<label class="k-radio-label radioSel ml10" for="ssoType2"><%=BizboxAMessage.getMessage("TX000016408","POST 방식")%></label>								
						</td>
					</tr>
				
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000017970","User ID")%></th>
						<td><input style="width:90%;" type="text" id="pUserId"/></td>
						<th><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></th>
						<td><input style="width:90%;" type="text" id="pCompCd"/></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000017971","Password")%></th>
						<td><input style="width:90%;" type="text" id="pPwd"/></td>
						<th><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></th>
						<td><input style="width:90%;" type="text" id="pErpEmpCd"/></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000017972","LOGIN_CD")%></th>
						<td><input style="width:90%;" type="text" id="pLoginCd"/></td>
						<th><%=BizboxAMessage.getMessage("TX000004237","ERP회사코드")%></th>
						<td><input style="width:90%;" type="text" id="pErpCompCd"/></td>
					</tr>				
				</table>
			</div>

			
		</div>
		</c:if>	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok()"/> 
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();"/>
		</div>
	</div>	
</div>