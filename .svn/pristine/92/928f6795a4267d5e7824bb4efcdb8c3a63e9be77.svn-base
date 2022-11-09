<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	var formHtml = '';
	var compSeqFilter = '${params.compSeq}';
	
   	$(document).ready(function() {
		
   		form.compFilter.value = compSeqFilter;
   		
   		//버튼 이벤트 설정
   		$(function () {
        	$("#btnSearch").click(function () { fnSearch(); });		//조회버튼
            $("#btnSave").click(function () { fnSave(); });			//저장버튼
            $("#btnAdd").click(function () { fnAdd(); });			//추가버튼
            $("#btnAlarm").click(function () { fnOrgChart(); });			//알람버튼
            
        });
   		
		//기본버튼
	    $(".controll_btn button").kendoButton();
		
	    fnGetCertFormSelectBox();

	});
   	
   	function fnGetCertFormSelectBox(){
   		
   		$("#t_certGubun").empty();
   		
   		var rParam = {};
		rParam.manageFlag = "Y";
   		
	   	 $.ajax({
	     	type:"post",
	 		url:'<c:url value="/systemx/getCertificateList.do"/>',
	 		datatype:"text",
	 		data: rParam,
	 		success: function (data) {
	 			$.each(data.certList, function( key, value ) {
	 				
	 				$("#t_certGubun")[0].add(new Option(value.formNm, value.formSeq));
	 				fnGetCerFormYN(value.formSeq);
	 			});   
	 			fnAlarmList();
			    },
			    error: function (result) {
	 			alert("<%=BizboxAMessage.getMessage("TX000016125","증명서 구분 가져오기 실패")%>");
	 		}
	 	});
   	}

   	function fnAlarmList(){
   		var rParam = {};
		rParam.formSeq = $("#t_certGubun").val();
		 
		$.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/getCertificateAlarmList.do"/>',
    		datatype:"text",
			data: rParam,
    		success: function (data) {
    			$("#alarm_list").val(data.ret.alarmList);
    			$("#selectedItems").val(data.ret.orgList);
   		    },
		    error: function (result) { 
    			
    		}
    	});
   	}
   	
   	
  	//회사코드에 따른 증명서 유무 확인
   	function fnGetCerFormYN(formSeq){
   		var rParam = {};
		rParam.formSeq = formSeq;
		
   		$.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/getCertificateCompForm.do"/>',
    		datatype:"text",
    		data: rParam,
    		success: function (data) {},
		    error: function (result) {
    			console.log("fail");
    		}
    	});
   	}
   	
	function fnEditorLoadCallback(){
		console.log("fnEditorLoadCallback");
		fnSearch();
	}

   
	
	//검색
	function fnSearch(){
		var rParam = {};
		rParam.formSeq = $("#t_certGubun").val();
		 
		$.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/certFromData.do"/>',
    		datatype:"text",
			data: rParam,
    		success: function (data) {
    			fData = data.formData;
   				
   				BindFrom(fData);
   				form.formSeq.value = (fData.formSeq);
   				$("#form_name").val(fData.formNm);
   				$("#form_name_en").val(fData.formNmEn);
   				$("#form_name_cn").val(fData.formNmCn);
   				$("#form_name_jp").val(fData.formNmJp);
   				$("#use_yn").val(fData.useYn);
   				$("#form_lang").val(fData.formLangCode);
   		    },
		    error: function (result) { 
    			alert("<%=BizboxAMessage.getMessage("TX000017937","검색에 실패하였습니다.")%>");
    		}
    	});
	}
    
    
    function BindFrom(fData){
    	formHtml = fData.formContent;
    	$("#editorView")[0].contentWindow.fnEditorHtmlLoad(formHtml);
    }
    
    function clickToInsertImageHtml(contentValue){
    	var imgHtml = "";
    	if(contentValue == "_DF26_"){
    		imgHtml = '<img id="_DF26_" src="/gw/Images/temp/_DF26_.jpg" alt="" width="76"/>';
    	}else if(contentValue == "_DF27_"){
    		imgHtml = '<img id="_DF27_" src="/gw/Images/temp/_DF27_.jpg" alt="" width="76"/>';
    	}else if(contentValue == "_DF28_"){
    		imgHtml = '<img id="_DF28_" src="/gw/Images/temp/_DF28_.jpg" alt="" width="76"/>';
    	}else if(contentValue == "_DF29_"){
    		imgHtml = '<img id="_DF29_" src="/gw/Images/temp/_DF29_.jpg" alt="" width="160"/>';
    	}else if(contentValue == "_DF30_"){
    		imgHtml = '<img id="_DF30_" src="/gw/Images/temp/_DF30_.jpg" alt="" width="124"/>';
    	}
    	clickToInsertHtml(imgHtml);
    }


    function clickToInsertHtml(contentValue){
    	$("#editorView")[0].contentWindow.fnInsertHtml(contentValue);
    }
	
	//저장
	function fnSave(){
		var rParam = {};
		var aParam = {};
		
		if(form.formSeq.value == "N"){
			rParam.formSeq = form.formSeq.value;
			if($("#form_name").val() == ""){
				$("#form_name").focus();
				alert("<%=BizboxAMessage.getMessage("TX000017938","증명서명은 필수 입력사항입니다.")%>");
				return false;
			}
			rParam.formNm = $("#form_name").val();
			rParam.formNmEn = $("#form_name_en").val();
			rParam.formNmCn = $("#form_name_cn").val();
			rParam.formNmJp = $("#form_name_jp").val();
			rParam.useYn = $("#use_yn").find('option:selected').val();
			rParam.formContent = $("#editorView")[0].contentWindow.fnEditorContents();
			rParam.formLangCode = $("#form_lang").find('option:selected').val();
		}else{
			rParam.formSeq = $("#t_certGubun").val();
			rParam.formNm = $("#form_name").val();
			rParam.formNmEn = $("#form_name_en").val();
			rParam.formNmCn = $("#form_name_cn").val();
			rParam.formNmJp = $("#form_name_jp").val();
			rParam.useYn = $("#use_yn").find('option:selected').val();
			rParam.formContent = $("#editorView")[0].contentWindow.fnEditorContents();
			rParam.formLangCode = $("#form_lang").find('option:selected').val();
		}
		
		aParam.formSeq = $("#t_certGubun").val();
		aParam.certAlarmList = $("#certAlarmList").val();
		$.ajax({
         	type:"post",
         	url:'<c:url value="/systemx/setCertificateAlarm.do"/>',
     		datatype:"text",
     		data : aParam,
     		success: function (data) {
     			//setDataList(data.certList);
     		},
 		    error: function (result) { 
     			
     		}
     	});
		
		$.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/updateCertificateForm.do"/>',
    		datatype:"text",
			data: rParam,
    		success: function (data) {
    			alert(data.ret.resultMessage);
    			if(form.formSeq.value == "N"){
    				fnGetCertFormSelectBox();
    			}else{
    				$("#t_certGubun").find('option[value='+rParam.formSeq+']').text(rParam.formNm);
    			}
   		    },
		    error: function (result) { 
    			alert("<%=BizboxAMessage.getMessage("TX000017939","증명서 양식 저장 실패")%>");
    		}
    	});
	}
	
	function fnAdd(){
		$("#form_name").val("");
		$("#form_name_en").val("");
		$("#form_name_cn").val("");
		$("#form_name_jp").val("");
		$("#use_yn").val("Y");
		$("#editorView")[0].contentWindow.fnEditorHtmlLoad("");
		$("#form_lang").val("kr");
		form.formSeq.value = "N";
	}
	
	/* 알람 설정을 위한 조직도 팝업 */
	function fnOrgChart() {		
		var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		form.target = "cmmOrgPop";
		form.method = "post";
		form.action = "<c:url value='/systemx/orgChart.do'/>";
		form.submit();
		pop.focus();
	}
	
	//담당자 선택팝업 콜백함수
	function callbackSel(data) {
   		// 조직도 정보 저장
   		fnCertAlarmAdd(data);
   }
	
	function fnCertAlarmAdd(data){
		var rParam = {};
		
		var orgInfo = data.returnObj;
		
		var certAlarmList = "";
		var certAlarmView = "";
		
		for(var i=0; i < orgInfo.length; i++) {
			
			if(certAlarmList == ""){
				certAlarmList += $("#t_certGubun").val()+"|"+orgInfo[i].empSeq+"|"+orgInfo[i].compSeq+"|"+orgInfo[i].empDeptFlag;
			}else{
				certAlarmList += ","+$("#t_certGubun").val()+"|"+orgInfo[i].empSeq+"|"+orgInfo[i].compSeq+"|"+orgInfo[i].empDeptFlag;
			}
			
			if(certAlarmView == ""){
				certAlarmView += orgInfo[i].empName+" "+orgInfo[i].positionName;
			}else{
				certAlarmView += "/"+orgInfo[i].empName+" "+orgInfo[i].positionName;
			}
			
		
			
		}
		
		$("#alarm_list").val(certAlarmView);
		$("#certAlarmList").val(certAlarmList);
		
		var selectedOrgItem = "";
		for(var i=0; i < orgInfo.length; i++) {
			var path = "";
			path = orgInfo[i].groupSeq + "|" + orgInfo[i].compSeq + "|" + orgInfo[i].deptSeq + "|" + orgInfo[i].empSeq + "|u";
			selectedOrgItem += path + ",";
		}
		
		$("#selectedItems").val(selectedOrgItem);

	}
	
    
</script>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="top_box">
		<dl>
			<dt><%=BizboxAMessage.getMessage("TX000001014","증명서구분")%></dt>
			<dd>
				<select id="t_certGubun" onchange="fnSearch();fnAlarmList();" style=" margin-right:5px; float:left;">
			</dd>
			<dd><input type="button" id="btnSearch" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
		</dl>
	</div>

	<div class="btn_div m0 cl">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				<button id="btnAdd"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
				<button id="btnSave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
			</div>
		</div>
	</div>

	<div class="twinbox">
		<table> 
			<colgroup>
				<col width="30%"/>
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="50%"/>
								<col />
							</colgroup>
							<tr>
								<th><img src="${pageContext.request.contextPath}/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000018161","증명서명")%>(<%=BizboxAMessage.getMessage("TX000002787","한국어")%>)</th>
								<td>
								<input type="text" id="form_name" name="form_name" value=""/>
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000018161","증명서명")%>(<%=BizboxAMessage.getMessage("TX000002790","영어")%>)</th>
								<td>
								<input type="text" id="form_name_en" name="form_name_en" value=""/>
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000018161","증명서명")%>(<%=BizboxAMessage.getMessage("TX000002789","중국어")%>)</th>
								<td>
								<input type="text" id="form_name_cn" name="form_name_cn" value=""/>
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000018161","증명서명")%>(<%=BizboxAMessage.getMessage("TX000002788","일본어")%>)</th>
								<td>
								<input type="text" id="form_name_jp" name="form_name_jp" value=""/>
								</td>
							</tr>
							<tr>
								<th><img src="${pageContext.request.contextPath}/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000274","사용유무")%></th>
								<td>
									<select id="use_yn" name="use_yn">
									<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
									<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
									</select>
								</td>
							</tr>
							<tr>
								<th colspan="2" style="text-align:center;"><%=BizboxAMessage.getMessage("TX000018162","알림대상자")%></th>
							</tr>
							<tr>
								<td colspan="2">
									<textarea type="text" id="alarm_list" name="alarm_list" style="width:100%;overflow-y:auto;" rows="3" readonly></textarea>
									<div id="" class="controll_btn" style="padding:0px 0px;align:center;">
										<button id="btnAlarm"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</td>
				<td rowspan="2" class="twinbox_td">
					<iframe id="editorView" src="/gw/editorView.do" style="min-width:100%;height: 800px;"></iframe>
				</td>
			</tr>
			<tr>
				<td class="twinbox_td">
				
					<div class="com_ta" style="height:500px;overflow:auto;border-right:1px;">
						<table>
							<colgroup>
								<col width="50%"/>
								<col />
							</colgroup>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX900000445","양식사용언어")%></th>
								<td>
									<select id="form_lang" name="form_lang">
									<option value="kr"><%=BizboxAMessage.getMessage("TX000002787","한국어")%></option>
									<option value="en"><%=BizboxAMessage.getMessage("TX000002790","영어")%></option>
									<option value="cn"><%=BizboxAMessage.getMessage("TX000002789","중국어")%></option>
									<option value="jp"><%=BizboxAMessage.getMessage("TX000002788","일본어")%></option>
									</select>
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000978","성명")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF01_');">_DF01_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000002814","주민등록번호")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF02_');">_DF02_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000375","주소")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF03_');">_DF03_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000001020","직위")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF04_');">_DF04_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF05_');">_DF05_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000069","부서약칭")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF34_');">_DF34_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000001001","재직기간")%>(기간)</th>
								<td><a href="javascript:clickToInsertHtml('_DF06_');">_DF06_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000001001","재직기간")%>(개월수)</th>
								<td><a href="javascript:clickToInsertHtml('_DF32_');">_DF32_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000005594","퇴직일자")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF33_');">_DF33_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000110","입사일")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF22_');">_DF22_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000001005","제출처")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF07_');">_DF07_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000088","담당업무")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF08_');">_DF08_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000003584","용도")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF09_');">_DF09_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000953","발급번호")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF10_');">_DF10_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000710","년도")%>(YYYY)</th>
								<td><a href="javascript:clickToInsertHtml('_DF31_');">_DF31_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000001004","제출예정일")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF11_');">_DF11_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000005812","사업장주소")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF12_');">_DF12_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000046","사업장명")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF13_');">_DF13_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF14_');">_DF14_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000024","사업자번호")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF15_');">_DF15_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF18_');">_DF18_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000961","사번")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF19_');">_DF19_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000019","회사약칭")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF20_');">_DF20_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000051","사업장약칭")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF21_');">_DF21_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000004999","발급일자")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF23_');">_DF23_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF24_');">_DF24_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000083","생년월일")%></th>
								<td><a href="javascript:clickToInsertHtml('_DF25_');">_DF25_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000027","법인인감")%></th>
								<td><a href="javascript:clickToInsertImageHtml('_DF26_');">_DF26_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000060","사용인감")%></th>
								<td><a href="javascript:clickToInsertImageHtml('_DF27_');">_DF27_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000016059","회사직인")%></th>
								<td><a href="javascript:clickToInsertImageHtml('_DF28_');">_DF28_</a></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000023","양식로고")%></th>
								<td><a href="javascript:clickToInsertImageHtml('_DF29_');">_DF29_</a></td>
							</tr>							
							<%-- <tr>
								<th><%=BizboxAMessage.getMessage("TX000000023","사원이미지")%></th>
								<td><a href="javascript:clickToInsertImageHtml('_DF30_');">_DF30_</a></td>
							</tr> --%>
							
						</table>
					</div>
				
				</td>
			</tr>
		</table>
	</div>

</div><!-- //sub_contents_wrap -->

<form id="form" name="form" action="" method="post">  
	<input type="hidden" id="formSeq" name="formSeq" value="N" />
	<input type="hidden" id="certAlarmList" name="certAlarmList" value="" />
	<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do'/>">
	<input type="hidden" name="selectMode" width="500" value="u" />
	<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
	<input type="hidden" name="selectItem" width="500" value="m" />
	<input type="hidden" name="callback" width="500" value="callbackSel" />
	<input type="hidden" name="compSeq" id="compSeq"  value="" />
	<input type="hidden" name="compFilter" id="compFilter" value="" />
	<input type="hidden" name="initMode" id="initMode" value="" />
	<input type="hidden" name="noUseDefaultNodeInfo" id="noUseDefaultNodeInfo" value="" />
	<input type="hidden" name="selectedItems" id="selectedItems" value="" />
</form>