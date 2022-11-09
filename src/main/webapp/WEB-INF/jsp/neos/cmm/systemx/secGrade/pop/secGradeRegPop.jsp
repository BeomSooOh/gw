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

<link rel="stylesheet" type="text/css" href="<c:url value='/js/pudd/css/pudd.css' />" />
<link rel="stylesheet" type="text/css" href="<c:url value='/js/pudd/css/re_pudd.css' />" />
<script type="text/javascript" src="<c:url value='/js/pudd/js/pudd-1.1.179.min.js' />"></script>

<script>
	var isSaving = false;
	var isDuplCheck = "${params.popMode}" == "u" ? true : false;
	var popMode = "${params.popMode}";
	var selectedCompSeq = "${params.selectedCompSeq}";
	var selectedUseModule = "${params.selectedUseModule}";
	var selectedNodeId = "${params.selectedNodeId}";
	var selectedNodeParent = "${params.selectedNodeParent}";
	var selectedNodeParentText = "${params.selectedNodeParentText}";
	var selectedNodeSecDepth = "${params.selectedNodeSecDepth}";
	var selectedNodeUseYn = "${params.selectedNodeUseYn}";
	var selectedNodeIconYn = "${params.selectedNodeIconYn}";
	var selectedNodeSecOrder = "${params.selectedNodeSecOrder}";
	var selectedNodeEtc = "${params.selectedNodeEtc}";
	var selectedNodeSecNameKr = "${params.selectedNodeSecNameKr}";
	var selectedNodeSecNameEn = "${params.selectedNodeSecNameEn}";
	var selectedNodeSecNameJp = "${params.selectedNodeSecNameJp}";
	var selectedNodeSecNameCn = "${params.selectedNodeSecNameCn}";
	
    $(document).ready(function () {  
    	var paramSet = {};
		paramSet.popMode = popMode || '';
		paramSet.selectedCompSeq = selectedCompSeq || '';
		paramSet.selectedUseModule = selectedUseModule || '';
		paramSet.selectedNodeParent = selectedNodeParent || '';
		paramSet.selectedNodeParentText = selectedNodeParentText || '';
		paramSet.selectedNodeSecDepth = selectedNodeSecDepth || '';
		paramSet.selectedNodeUseYn = selectedNodeUseYn || '';
		paramSet.selectedNodeSecOrder = selectedNodeSecOrder || '';
		paramSet.selectedNodeEtc = selectedNodeEtc || '';
		paramSet.selectedNodeSecNameKr = selectedNodeSecNameKr || '';
		paramSet.selectedNodeSecNameEn = selectedNodeSecNameEn || '';
		paramSet.selectedNodeSecNameJp = selectedNodeSecNameJp || '';
		paramSet.selectedNodeSecNameCn = selectedNodeSecNameCn || '';
        
		//회사선택 비활성화 처리
		disableComp(paramSet.selectedNodeParent, paramSet.selectedNodeSecDepth);
    });
  	
    //노드를 선택 했다면 회사선택 SelectBox 비활성화
    function disableComp(selectedNodeParent, selectedNodeSecDepth){
    	if((selectedNodeParent && selectedNodeSecDepth > 0) || '${params.userSe}'=='ADMIN'){
    		$("#compSeq").attr("disabled", true);	
    	}
    	
    }
    function isNumberOnlyPlus(v) {
    	
        var reg = /^(\s|\d)+$/;
        return reg.test(v);
    }

    function isNumber(v) {
        var reg = /^[-|+]?\d+$/;
        return reg.test(v);
    }
    //저장버튼 유효성 검사
    function validation(){
    	//등급코드 필수
    	if($("#secId").val().length == 0){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002009","등급코드는 필수 입력 입니다.")%>"
				}			 
			});
    		return false;
    	}
    	<%-- 
    	//등급코드는 숫자만 가능
    	if("${params.popMode}" == "c" && !isNumberOnlyPlus($("#secId").val())){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","등급코드는 숫자만 가능합니다")%>"
				}			 
			});
    		return false;
    	}
    	
    	//등급코드는 상위등급코드 보다 무조건 커야함
    	if("${params.popMode}" == "c" && selectedNodeParent && parseInt(selectedNodeParent) >= parseInt($("#secId").val())) {
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("","등급코드는 상위등급코드 보다 커야 합니다.")%>"
				}			 
			});
    		return false;
    	}
    	 --%>
    	//등급코드 중복체크
    	if(!isDuplCheck){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002010","등급코드가 중복되었습니다.")%>"
				}			 
			});
    		return false;
    	}
    	//등급코드
    	if($("#secId").val().length > 32){
    		var puddDialog = Pudd.puddDialog({
					width : 400,
					message : {
						type : "warning",
						content : "<%=BizboxAMessage.getMessage("TX800002011","등급코드는 32자를 넘을 수 없습니다.")%>"
					}			 
			});
    		return false;
    	}
    	//정렬순서 숫자만, 5자리
    	if($("#secOrder").val()!="" && !isNumber($("#secOrder").val())){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002012","정렬순서는 숫자만 입력 가능합니다.")%>"
				}			 
			});	
    		return false;
    	}
    	if($("#secOrder").val().length > 65){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002013","정렬순서는 65자리를 초과 할 수 없습니다.")%>"
				}			 
			});
    		return false;
    	}
    	//등급명 필수
    	if($("#secNameKr").val().length == 0){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002014","등급명(한국어)은 필수 입력 입니다.")%>"
				}			 
			});
    		return false;
    	}
    	//등급명 128자리
    	if($("#secNameKr").val().length > 128){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002015","등급명(한국어)은 128자리를 초과 할 수 없습니다.")%>"
				}			 
			});
    		return false;
    	}
    	if($("#secNameEn").val().length > 128){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002016","등급명(영어)은 128자리를 초과 할 수 없습니다.")%>"
				}			 
			});
    		return false;
    	}
    	if($("#secNameJp").val().length > 128){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002018","등급명(일본어)은 128자리를 초과 할 수 없습니다.")%>"
				}			 
			});
    		return false;
    	}
    	if($("#secNameCn").val().length > 128){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002017","등급명(중국어)은 128자리를 초과 할 수 없습니다.")%>"
				}			 
			});
    		return false;
    	}
    	//비고 500자
    	if($("#etc").val().length > 500){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002019","비고는 500자리를 초과 할 수 없습니다.")%>"
				}			 
			});
    		return false;
    	}
    	
    	return true;
    }
    //저장
    function fnSave(){
    	
    	if(isSaving){
    		var puddDialog = Pudd.puddDialog({
				width : 400,
				message : {
					type : "warning",
					content : "<%=BizboxAMessage.getMessage("TX800002020","저장 중 입니다.")%>"
				}			 
			});
    		return;
    	}
    	
    	if(!validation()){
    		isSaving = false;
    		return;
    	}
    	
    	var basicForm = $('#basicForm');
    	var disabled = basicForm.find(':input:disabled').removeAttr('disabled');
    	var serialized = basicForm.serialize();
    	disabled.attr('disabled','disabled');
    	
    	isSaving = true;
    	
    	if(popMode=="c"){
    		//신규등록
    		$.ajax({ 
    			type:"POST",
    			url: '<c:url value="/cmm/systemx/secGrade/regSecGrade.do" />',
    			datatype:"json",
    			async: true,
    			data: serialized,
    			success:function(data){
    				if(data.resultCode=="SUCCESS"){
    					
    					fnCall_CallbackFunc();
    					
    				}else if(data.resultCode!="LOGIN004"){
    					isSaving = false;
    					console.log(data);
    				}
    				
    				if(data.resultCode=="LOGIN004"){//loginVO NULL
    					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
    						window.parent.location.href = "/gw/userMain.do";	
    					}
    				}
    				
    			},error: function(result) {
    				isSaving = false;
    				console.log(result);
    			}  
    		});
    	}else if(popMode=="u"){
    		var useYn = $(':radio[name="useYn"]:checked').val();
    		if(useYn == "Y"){//사용여부가 Y 일땐 바로 수정 호출
    			//수정호출
    			modifySecGrade(serialized);
        			
    		}else{//사용여부가 미사용이면 아래 보안등급목록 삭제가능 여부 API 호출을 통해서 기안양식에 기본값으로 사용중인지 확인하여 그렇다면 컨펌 얼럿 창을 보여주고
    			//보안등급목록 삭제가능 여부
    			var params = {
   					"secId" : selectedNodeId,
   					"parent" :selectedNodeParent,
   					"module" : selectedUseModule,
   					"compSeq" : selectedCompSeq,
   					"secDepth" : selectedNodeSecDepth
   				}; 
    			$.ajax({ 
    				type:"POST",
    				url: '<c:url value="/cmm/systemx/secGrade/canUnUseSecGrade.do" />',
    				datatype:"json",
    				async: true,
    				data: params,
    				success:function(data){
    					if(data.resultCode=="SUCCESS"){
    						
    						if(data.result.callBackYn == "Y"){
    							if(confirm(data.result.typeMessage)){
        							params['callBackUrl'] = data.result.callBackUrl;
        							params['dataRemoveYn'] = 'N';
        							params['type'] = data.result.type;
        							//전자결재 콜백 API 호출
        							$.ajax({ 
        								type:"POST",
        								url: '<c:url value="/cmm/systemx/secGrade/removeSecGrade.do" />',
        								datatype:"json",
        								async: true,
        								data: params,
        								success:function(data){
        									if(data.resultCode=="SUCCESS"){
        										//수정호출
        		    			    			modifySecGrade(serialized);				
        										
        									}else if(data.resultCode!="LOGIN004"){
        										alert(data.resultMessage);
        										isSaving = false;
        									}
        									
        									if(data.resultCode=="LOGIN004"){//loginVO NULL
        										if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
        											window.parent.location.href = "/gw/userMain.do";	
        										}
        									}
        								},error: function(result) {
        									console.log(result);
        									isSaving = false;
        								}  
        							});	
        						}else{
        							isSaving = false;
        						}   							
    						}else{
    							//수정호출
    			    			modifySecGrade(serialized);
    						}
    						
    					}else if(data.resultCode!="LOGIN004"){
    						alert(data.resultMessage);
    						isSaving = false;
    					}
    					
    					if(data.resultCode=="LOGIN004"){//loginVO NULL
    						if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
    							window.parent.location.href = "/gw/userMain.do";	
    						}
    					}
    				},error: function(result) {
    					isSaving = false;
    					console.log(result);
    				}  
    			});    			
    		}
    	}
    }
    
  	//수정 처리
    function modifySecGrade(serialized){
    	$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/modifySecGrade.do" />',
			datatype:"json",
			async: true,
			data: serialized,
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					
					fnCall_CallbackFunc();
					
				}else if(data.resultCode!="LOGIN004"){
					isSaving = false;
					console.log(data);
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				
			},error: function(result) {
				isSaving = false;
				console.log(result);
			}  
		});
	}
    
    function fnCall_CallbackFunc() {
    	
    	var puddDialog = Pudd.puddDialog({
			width : 400,
			message : {
				type : "success",
				content : "<%=BizboxAMessage.getMessage("TX000002120","저장 되었습니다.")%>"
			},
			defaultClickCallback : function (puddDlg){
				window.opener["callbackChangeSecGrade"]();
				window.close();
				isSaving = false;			
			}
		});
		
	}
    function fnClose(){
    	<%-- if(confirm("<%=BizboxAMessage.getMessage("TX000010703","취소 하시겠습니까?")%>")==true){ --%>
    		self.close();
    	/* }else{
    		return;
    	} */
    }
    //등급코드 중복체크
    function checkSecId(secId) {
    	if(!secId){
    		$("#secIdDup").prop("class", "text_red f11 mt5");
            $("#secIdDup").html("<%=BizboxAMessage.getMessage("TX800002021","등급코드를 입력해주세요.")%>");
    		return;
    	}
    	<%-- if("${params.popMode}" == "c" && !isNumberOnlyPlus($("#secId").val())){
    		$("#secIdDup").prop("class", "text_red f11 mt5");
            $("#secIdDup").html("<%=BizboxAMessage.getMessage("","등급코드는 숫자만 가능합니다.")%>");
    		return;
    	}
    	
    	//등급코드는 상위등급코드 보다 무조건 커야함
    	if("${params.popMode}" == "c" && selectedNodeParent && parseInt(selectedNodeParent) >= parseInt(secId)) {
    		$("#secIdDup").prop("class", "text_red f11 mt5");
            $("#secIdDup").html("<%=BizboxAMessage.getMessage("","등급코드는 상위등급코드 보다 커야 합니다.")%>");
            return;
    	}
    	 --%>
    	if(secId.length > 32){
    		$("#secIdDup").prop("class", "text_red f11 mt5");
            $("#secIdDup").html("<%=BizboxAMessage.getMessage("TX800002011","등급코드는 32자를 넘을 수 없습니다.")%>");
    		return;
    	}
    	//중복체크
		$.ajax({ 
			type:"POST",
			url: '<c:url value="/cmm/systemx/secGrade/secGrade.do" />',
			datatype:"json",
			async: true,
			data: {
				"secId" : secId
			},
			success:function(data){
				if(data.resultCode=="SUCCESS"){
					
					if(data.result.secGrade == null){
						$("#secIdDup").prop("class", "text_blue f11 mt5");
                        $("#secIdDup").html("<%=BizboxAMessage.getMessage("TX000007084","사용 가능한 코드 입니다.")%>");
                        isDuplCheck = true;
					}else {
						$("#secIdDup").prop("class", "text_red f11 mt5");
			            $("#secIdDup").html("<%=BizboxAMessage.getMessage("TX000010757","코드가 중복되었습니다.")%>");
			            isDuplCheck = false;
					}
					
				}else if(data.resultCode!="LOGIN004"){
					console.log(data);
					isDuplCheck = false;
				}
				
				if(data.resultCode=="LOGIN004"){//loginVO NULL
					if(!alert("<%=BizboxAMessage.getMessage("TX000008260","로그아웃된 상태입니다. 로그인을 하세요")%>")){
						isDuplCheck = false;
						window.parent.location.href = "/gw/userMain.do";	
					}
				}
				
			},error: function(result) {
				isDuplCheck = false;
				console.log(result);
			}  
		});
    }
</script>

<form id="basicForm" name="basicForm" action="empInfoSaveProc.do" method="post" onsubmit="return false;">
	<div class="pop_wrap" style="width:798px;">
	<div class="pop_head">
		<h1>
		<c:if test="${params.popMode == 'c'}"><%=BizboxAMessage.getMessage("TX800002022","보안등급 등록")%></c:if>
		<c:if test="${params.popMode == 'u'}"><%=BizboxAMessage.getMessage("TX800002023","보안등급 수정")%></c:if>
		</h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">		
		<div class="top_box">
			<div class="top_box_in lh16">
				<p class="text_blue fwb mb5">[<%=BizboxAMessage.getMessage("TX800002024","보안등급 등록")%>]</p>
				<p class="tit_p m0"><%=BizboxAMessage.getMessage("TX800002025","사용할 보안등급을 등록 할 수 있습니다.")%></p>
				<p class="tit_p m0"><%=BizboxAMessage.getMessage("TX800002026","등록된 보안등급에 사용자 설정시 등급에 따라 문서를 열람 할 수 있습니다.")%></p>
			</div>
		</div>

		<div class="com_ta mt14">
			<table>
				<colgroup>
					<col width="80"/>
					<col width="80"/>
					<col width="31.8%"/>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
					<td>
						<select id="compSeq" name="compSeq" class="puddSetup" pudd-style="width:216px" <c:if test="${params.popMode == 'u'}">disabled</c:if>>
							<c:forEach var="comp" items="${compList}" varStatus="status">
								<option value="${comp.compSeq}" <c:if test="${params.selectedCompSeq == comp.compSeq}">selected</c:if>>${comp.compName}</option>
							</c:forEach>
						</select>
					</td>
					<th><%=BizboxAMessage.getMessage("TX800002027","사용모듈")%></th>
					<td>
						<select id="useModule" name="useModule" class="puddSetup" style="width: 216px;" pudd-style="min-width:120px;" <c:if test="${params.popMode == 'u'}">disabled</c:if>>
							<c:forEach var="module" items="${moduleList}" varStatus="status">
								<option value="${module.CODE}" <c:if test="${params.selectedUseModule == module.CODE}">selected</c:if>>${module.CODE_NM}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX800002028","상위등급")%></th>
					<td><input type="text" pudd-style="width:100%" class="puddSetup" id="parentText" value="${params.selectedNodeParentText.replace('(선택불가)','')}" disabled/>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000017967","아이콘")%></th>
					<td>
						<input type="radio" id="iconYnY" name="iconYn" value="Y" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000003801","표시")%>" <c:if test="${params.selectedNodeIconYn == 'Y'}">checked</c:if>  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/>
						<input type="radio" id="iconYnN" name="iconYn" value="N"  class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000006392","미표시")%>" <c:if test="${params.selectedNodeIconYn == 'N'}">checked</c:if> <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/>
					</td>
				</tr>
				<tr>
					<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>"/><%=BizboxAMessage.getMessage("TX800002029","등급코드")%></th>
					<td><input type="text" pudd-style="width:100%;" name="secId" id="secId" class="puddSetup" style="width: 216px;" value="${params.selectedNodeId}" <c:if test="${params.popMode == 'u'}">disabled</c:if> onkeyup="checkSecId(this.value);"/></td>
					<td colspan="2">
						<p id="secIdDup"></p>
					</td>
				</tr>
				<tr>
					<th rowspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /><%=BizboxAMessage.getMessage("TX000003771","등급명")%></th>
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
					<td><input type="text" class="puddSetup"  pudd-style="width:100%;" id="secNameKr" name="secNameKr" value="${params.selectedNodeSecNameKr}"  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/></td>
					<th><%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
					<td><input type="text" class="puddSetup" pudd-style="width:100%;" id="secNameEn" name="secNameEn" value="${params.selectedNodeSecNameEn}"  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
					<td><input type="text" class="puddSetup" pudd-style="width:100%;"  id="secNameJp" name="secNameJp" value="${params.selectedNodeSecNameJp}"  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/></td>
					<th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
					<td><input type="text" class="puddSetup" pudd-style="width:100%;"  id="secNameCn" name="secNameCn" value="${params.selectedNodeSecNameCn}"  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/></td>
				</tr>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX800002030","선택가능여부")%></th>
					<td>
						<input type="radio" id="useYnY" name="useYn" value="Y" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000006469","가능")%>" <c:if test="${params.selectedNodeUseYn == 'Y'}">checked</c:if>  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/>
						<input type="radio" id="useYnN" name="useYn" value="N" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000006470","불가능")%>" <c:if test="${params.selectedNodeUseYn == 'N'}">checked</c:if>  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000000125","정렬순서")%></th>
					<td><input type="text" id="secOrder" name="secOrder" class="puddSetup"  pudd-style="width:100%;" value="${params.selectedNodeSecOrder}"  <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/></td>
				</tr>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
					<td colspan="3">
						<input type="text" class="puddSetup" pudd-style="width:100%;" id="etc" name="etc" value="${params.selectedNodeEtc}" <c:if test="${params.selectedCompSeq == '0' && params.userSe == 'ADMIN'}">disabled</c:if>/>
					</td>
				</tr>
			</table>
		</div>


	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<c:if test="${params.selectedCompSeq != '0' || params.userSe != 'ADMIN'}">
			<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave();" />
			</c:if> 
			<input type="button" class="puddSetup gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();" />
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
	<input type="hidden" id="upperSecId" name="upperSecId" value="${params.selectedNodeParent}"/>
	<input type="hidden" id="upperSecDepth" name="upperSecDepth" value="${params.selectedNodeSecDepth}"/>
	<input type="hidden" id="prevSelectedCompSeq" name="prevSelectedCompSeq" value="${params.selectedCompSeq}"/>
	
</form>