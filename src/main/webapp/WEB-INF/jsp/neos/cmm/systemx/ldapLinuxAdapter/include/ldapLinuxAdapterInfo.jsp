<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script>

	$(document).ready(function(){
	    //기본버튼
		$("button").kendoButton();    			
		    
		//탭
		$("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: "fadeIn"
				}
			},
			select: tabStripClick
		});
		
		$("#teamYn").kendoComboBox();
		fnParentDeptList();
		
		if($("#parentDeptSeq").val() == '')
			$("#btnDeptPop").hide();
		else
			$("#btnDeptPop").show();
		
		$("#orgChartButton").click(function(){
			CallOrgPop();
		});		
		
		var data = [
					{ text: "<%=BizboxAMessage.getMessage("TX000000098","부서")%>", value: "D" },
					{ text: "<%=BizboxAMessage.getMessage("TX000000811","사업장")%>", value: "B" }

				];
		$("#deptType").kendoComboBox({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: data,
			change: deptTypeChange,
			index: 0
		});
		
		var displayData = [
					{ text: "<%=BizboxAMessage.getMessage("TX000003801","표시")%>", value: "Y" },
					{ text: "<%=BizboxAMessage.getMessage("TX000006392","미표시")%>", value: "N" }

				];
		
		
		$("#bizDisplay").kendoComboBox({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: displayData,
			index: 0
		});
		
		

		if("${deptMap.deptType}" == "B"){
			$("#deptType").data("kendoComboBox").value("B");
			$("#bizDisplay").data("kendoComboBox").value("${deptMap.displayYn}");
			
			$(".comp_type").show();	
			$("#deptDetailType").hide();
			
			$("#bizDisplayZone").show();
			$("#btnDeptPop").hide();
		}
		
		$("#btnSeal").on("click",function(){
			$("#fileUpload01").click();
		})
		
		var imgBizSeal = document.getElementById('IMG_BIZ_SEAL_IMG'); 	

		if('${deptMap.sealFileId}' == '')
			$("#IMG_BIZ_SEAL_IMG").attr("style","visibility:hidden");
		else			
			$("#IMG_BIZ_SEAL_DEL").attr("style", "visivility:visible");	
		
		if("${deptMap.deptType}" == "V"){
			$("#orgDisplayYn").show();
		}else{
			$("#orgDisplayYn").hide();
		}
		
		/** 20161229 장지훈 추가 (공통옵션-ERP조직도 연동) */
		fnErpOption();
		
		if("${deptMap.deptType}" == "B"){
			$("#innerReceiveTag").hide();
			
			if($("#standardCodeTag").length > 0)
				$("#standardCodeTag").hide();
		}else{
			$("#innerReceiveTag").show();
			
			if($("#standardCodeTag").length > 0)
				$("#standardCodeTag").show();
		}
		
		
		$("#deptName").keyup(function(){
			if($("#deptSeq2").val() == ""){
				$("#deptNickname").val($("#deptName").val());
				$("#bizNickname").val($("#deptName").val());
			}
		});
		
		
		if("${deptMap.deptType}" == "E"){
			var ddl =  $("#teamYn").data("kendoComboBox");
			
			if(ddl.dataSource.data().length == "3"){	
				ddl.dataSource.add({ text: "결재전용부서", value: "E" });
			}


			$("#teamYn").data("kendoComboBox").value("E");
	         
			$('#teamYn').data('kendoComboBox').enable(false);			
			
		}else if("${deptMap.deptType}" == ""){			
			var ddl =  $("#teamYn").data("kendoComboBox");
			if(ddl.dataSource.data().length == "3"){	
				ddl.dataSource.add({ text: "결재전용부서", value: "E" });
			}
		}		
		else{
			var ddl =  $("#teamYn").data("kendoComboBox");
	        var oldData = ddl.dataSource.data();
	        ddl.dataSource.remove(oldData[oldData.length - 1]); //remove last item
	        
			if("${deptMap.deptType}" == "T"){
				$("#teamYn").data("kendoComboBox").value("Y");				
			}else if("${deptMap.deptType}" == "V"){
				$("#teamYn").data("kendoComboBox").value("T");				
			}
		}
	});
	
	function tabStripClick(e) {
		//현재 탭 index 저장
		tabType = $(e.item).index();	
    }

	

	function CallOrgPop() {
		
		var url = "<c:url value='/html/common/cmmOrgPop.jsp'/>"; 
		var pop = window.open("", "cmmOrgPop", "width=768,height=800,scrollbars=no");

		frmPop2.target = "cmmOrgPop";
		frmPop2.method = "post";
		frmPop2.action = url; 
		frmPop2.submit(); 
		frmPop2.target = ""; 
	    pop.focus();   
    }
	
	function callbackSel(item) {
		if(item.isSave) {
			$("#c_selectedItems").val(item.returnObj[0].superKey);
		}
		var captainInfo = item.returnObj[0].deptName + " " + item.returnObj[0].empName + " " + item.returnObj[0].positionName; 
		
		$("#deptCaptain").val(captainInfo);
		$("#captainEmpSeq").val(item.returnObj[0].empSeq);
		$("#captainDeptSeq").val(item.returnObj[0].deptSeq);
		//alert(JSON.stringify(item));
	}
	
	function fnParentDeptList() {
		$("#bs_sel").val('${deptMap.parentDeptName}');
		$("#parentDeptSeq").val('${deptMap.parentDeptSeq}');
		
		if("${deptMap.deptType}" == "D"){
			$('#teamYn').data('kendoComboBox').value("N")
		}
		else if("${deptMap.deptType}" == "T"){
			$('#teamYn').data('kendoComboBox').value("Y")	
		}
		else if("${deptMap.deptType}" == "V"){
			$('#teamYn').data('kendoComboBox').value("T")
		}
    }
	
	function setParentDeptList(parentList) {
	    $("#bs_sel").kendoComboBox({
	    	dataTextField: "deptName",
            dataValueField: "deptSeq",
	        dataSource: parentList,
	        value: '${deptMap.parentDeptSeq}',
	        change: deptChange,
	        filter: "contains",
	        suggest: true
	    });
	}
	
	function deptChange() {
		$("#parentDeptSeq").val($("#bs_sel").val());
	}

	function fnZipPop(target) {
		new daum.Postcode({
            oncomplete: function(data) {
            	
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수 

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

             	// 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipCode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('addr').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('detailAddr').focus();
                	
            }
        }).open();
    }
	
	function checkDeptSeq(id) {
		if (id == ""){
			$("#info").prop("class", "");
            $("#info").html("");
            $("#chkSeq").val("false");
		}
        if (id != null && id != '') {
        	if(id == "0"){
            	$("#info").prop("class", "fl text_red f11 mt5 ml10");
                $("#info").html("! <%=BizboxAMessage.getMessage("TX000009762","사용 불가능한 코드 입니다")%>");
                $("#chkSeq").val("false");
            }
        	else{
        		var deptType = $('#deptType').data('kendoComboBox').value();
	            $.ajax({
	                type: "post",
	                url: "checkDeptSeq.do",
	                datatype: "text",
	                data: { deptCd: id , deptType : deptType, compSeq: $("#com_sel").val(), deptSeq : $("#deptSeq2").val()},
	                success: function (data) {
	                    if (data.result == "1") {
	                    	$("#info").prop("class", "fl text_blue f11 mt5 ml10");
	                        $("#info").html("* <%=BizboxAMessage.getMessage("TX000009763","사용 가능한 코드 입니다")%>");
	                        $("#chkSeq").val("true");
	                    }                    
	                    else {
	                    	$("#info").prop("class", "fl text_red f11 mt5 ml10");
	                        $("#info").html("! <%=BizboxAMessage.getMessage("TX000010757","코드가 중복되었습니다")%>");
	                        $("#chkSeq").val("false");
	                    }
	                    
	                    
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error");
	                }
	            });
            }
        }      
    }
	
// 	function test() {
// 		$("#teamYn").kendoComboBox({
//             dataTextField: "text",
//             dataValueField: "value",                
//                 dataSource: [
//               { text: "Item1", value: "1" },
//               { text: "Item2", value: "2" }
//             ]
//         });
		
// 		alert($("#teamYn").val());
// 	}

	function openPopEmpSort() {
		var url = "<c:url value='/cmm/systemx/deptCompEmpSortPop.do'/>";             
        var popup = window.open(url+"?compSeq=${deptMap.compSeq}", "compEmpSortPop", 'toolbar=no, scrollbar=no, width=260, height=150, resizable=no, status=no');
        popup.focus();
        //<button id="sortBtn" onclick="openPopEmpSort()">사용자 정렬</button>
	}
	
	
	function deptTypeChange(){
		if($("#deptType").data("kendoComboBox").value() == "B"){
			isTypeChange = true;		
			$('#orgTreeView').jstree("deselect_all");
			$('#orgTreeView').jstree('select_node', 'ul > li:first'); 
			
			$("#parentDeptSeq").val("0");
			
			newDept();
			isTypeChange = false;			
			
			 $(".comp_type").show();	
			 $("#deptDetailType").hide();			 
			 
			 $("#bizDisplayZone").show();
			 
			var innerHtml = "<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt=\"\" />" + "<%=BizboxAMessage.getMessage("TX000000048","사업장코드")%>"; 
			$("#deptSeqZone").html(innerHtml);
			innerHtml = "<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt=\"\" />" + "<%=BizboxAMessage.getMessage("TX000000046","사업장명")%>";
			$("#deptNmZone").html(innerHtml);
			innerHtml = "<%=BizboxAMessage.getMessage("TX000000051","사업장약칭")%>";
			$("#nickNameZone").html(innerHtml);
			
			$("#innerReceiveTag").hide();
			
			if($("#standardCodeTag").length > 0)
				$("#standardCodeTag").hide();
		}else{
			$(".comp_type").hide();
			$("#deptDetailType").show();
			
			$("#bizDisplayZone").hide();
			var innerHtml = "<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt=\"\" />" + "<%=BizboxAMessage.getMessage("TX000000067","부서코드")%>"; 
			$("#deptSeqZone").html(innerHtml);
			innerHtml = "<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt=\"\" />" + "<%=BizboxAMessage.getMessage("TX000000068","부서명")%>";
			$("#deptNmZone").html(innerHtml);
			innerHtml = "<%=BizboxAMessage.getMessage("TX000000069","부서약칭")%>";
			$("#nickNameZone").html(innerHtml);
			$("#innerReceiveTag").show();
			
			if($("#standardCodeTag").length > 0)
				$("#standardCodeTag").show();
		}
		
		
		checkDeptSeq($("#deptCd").val());
	}
	
	function dllOnChange(){		
		if($('#teamYn').data('kendoComboBox').value() == "T"){
			$("#orgDisplayYn").show();
		}else{
			$("#orgDisplayYn").hide();
		}
		
		if($('#teamYn').data('kendoComboBox').value() == "N"){
			$("#innerReceiveTag").show();
		}else{
			$("#innerReceiveTag").hide();
		}
	}
	
	
	// 공통옵션 - erp 조직도연동
	function fnErpOption() {	
		var erpOptions = "${erpUse}";
		if(erpOptions == "Y") {
			
			$("#erpUse").show();		
			$("#bs_sel").attr("disabled", true);
			$("#btnDeptPop").hide();
			//$("#teamYn").removeAttr('disabled');
			//$("select[name=teamYn]").attr("disabled","disabled");
			
			if("${deptMap.deptType}" == "D"){
				$('#teamYn').data('kendoComboBox').value("부서")
			}
			else if("${deptMap.deptType}" == "T"){
				$('#teamYn').data('kendoComboBox').value("팀")	
			}
			else if("${deptMap.deptType}" == "V"){
				$('#teamYn').data('kendoComboBox').value("임시")
			}
			
			$("#teamYn").kendoComboBox({enable:false});
			$("input[name='useYn']").attr("disabled", true);
			
			$("#excelDept").data("kendoButton").enable(false);
			$("#newDept").data("kendoButton").enable(false);
			$("#removeDept").data("kendoButton").enable(false);
			
// 			$("#newDept").attr("disabled", true);
// 			$("#removeDept").attr("disabled", true);
		} else if(erpOptions == "N") {
			$("#erpUse").hide();		
		
			$("#excelDept").data("kendoButton").enable(true);
			$("#newDept").data("kendoButton").enable(true);
			$("#removeDept").data("kendoButton").enable(true);
		}
	}

</script>

<form id="frmPop2" name="frmPop2">  
<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do' />">
<input type="hidden" name="selectMode" width="500" value="u"/> 
<input type="hidden" name="selectItem" width="500" value="s"/> 
<input type="hidden" name="selectedItems" width="500" value="" id="c_selectedItems"/>
<input type="hidden" name="callback" width="500" value="callbackSel"/>
<input type="hidden" name="callbackUrl" width="500" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/>
</form>

<form id="basicForm" name="basicForm"  onsubmit="return false;">
	<input type="hidden" id="chkSeq" name="chkSeq" value="" />
	<c:if test="${deptMap.deptType != 'B'}">
		<input type="hidden" id="deptSeq" name="deptSeq" value="${deptMap.deptSeq}" />
	</c:if>
	<c:if test="${deptMap.deptType == 'B'}">
		<input type="hidden" id="deptSeq" name="deptSeq" value="${deptMap.bizSeq}" />
	</c:if>
	<input type="hidden" id="groupSeq" name="groupSeq" value="${deptMap.groupSeq}" />	
	<input type="hidden" id="bizSeq" name="bizSeq" value="${deptMap.bizSeq}" />
	<input type="hidden" id="oldBizSeq" name="oldBizSeq" value="${deptMap.bizSeq}" />
	<input type="hidden" id="isChangeParentSeq" name="isChangeParentSeq" value="N" />
	<input type="hidden" id="compSeq" name="compSeq" value="${deptMap.compSeq}" />
	<input type="hidden" id="parentDeptSeq" name="parentDeptSeq" value="${deptMap.parentDeptSeq}" />
	<input type="hidden" id="empDeptOrderList" name="empDeptOrderList" value=""/>
	
	<div class="tab_div brn" id="tabstrip">
		<ul>
			<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></li>
			<li><%=BizboxAMessage.getMessage("TX000016249","부서원정보")%></li>
		</ul>
		<p class="fr posi_re text_blue" id="erpUse" style="display:none;top: -26px;right: 35px;">ERP 조직도 연동 사용 중</p>
		<!-- 기본정보 탭 -->
		<div class="tab_div_in">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="120"/>
						<col width="90"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000004939","상위부서")%></th>
						<td colspan="4">
							<input type="text" id="bs_sel" style="width:90%" readonly="readonly"/>
							<button id="btnDeptPop" class="k-button" onclick="deptPop();"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002921","유형")%></th>
						<td colspan="4">
							<input id="deptType" style="width:100px"/>
							<em id="deptDetailType">
								<span class="ml20"><%=BizboxAMessage.getMessage("TX000000793","상세")%></span>	
								<select id="teamYn" name="teamYn"  class="mr10" style="width:130px" onchange="dllOnChange();"> 
									<option value="N" <c:if test="${deptMap.deptType == 'D'}">selected</c:if> ><%=BizboxAMessage.getMessage("TX000000098","부서")%></option>
									<option value="Y" <c:if test="${deptMap.deptType == 'T'}">selected</c:if> ><%=BizboxAMessage.getMessage("TX000000639","팀")%></option>
				                  	<option value="T" <c:if test="${deptMap.deptType == 'V'}">selected</c:if> ><%=BizboxAMessage.getMessage("TX000016149","임시")%></option>
				                  	<option value="E" <c:if test="${deptMap.deptType == 'E'}">selected</c:if> ><%=BizboxAMessage.getMessage("","결재전용부서")%></option>
								</select>
							</em>
							<em id="orgDisplayYn">
								조직도 미표시
								<input type="checkbox" <c:if test="${deptMap.displayYn == 'N'}">checked</c:if> id="deptDisplayYn" name="deptDisplayYn"/>
							</em>							
						</td>
					</tr>
					<tr>
						<c:if test="${deptMap.deptType != 'B'}">
						<th id="deptSeqZone"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000067","부서코드")%></th>
						</c:if>
						<c:if test="${deptMap.deptType == 'B'}">
						<th id="deptSeqZone"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000048","사업장코드")%></th>
						</c:if>
						<td colspan="4">
							<c:if test="${deptMap.deptType != 'B'}">
								<input class="fl" type="hidden" id="deptSeq2" name="deptSeq" value="${deptMap.deptSeq}" style="width:162px" disabled/>
								<input class="fl" type="text" id="deptCd" name="deptCd" value="${deptMap.deptCd}" style="width:162px" onkeyup="checkDeptSeq(this.value);"/>
							</c:if>
							<c:if test="${deptMap.deptType == 'B'}">
								<input class="fl" type="hidden" id="deptSeq2" name="deptSeq" value="${deptMap.bizSeq}" style="width:162px" disabled/>
								<input class="fl" type="text" id="deptCd" name="deptCd" value="${deptMap.deptCd}" style="width:162px" onkeyup="checkDeptSeq(this.value);"/>
							</c:if>
							<p id="info" class="fl text_blue f11 mt5 ml10"></p>	
							<!-- <p class="fl text_red f11 mt5 ml10">! 코드가 중복되었습니다.</p>  사용 안할경우 p태그 주석처리-->
							<!-- <p class="fl text_blue f11 mt5 ml10">* 사용 가능한 코드 입니다.</p>  사용 안할경우 p태그 주석처리-->
						</td>
					</tr>
<!-- 					<tr> -->
<%-- 						<th> <%=BizboxAMessage.getMessage("TX000016251","부서CD")%></th> --%>
<!-- 						<td colspan="4"> -->
<%-- 							<input class="fl" type="text" id="deptCd" name="deptCd" value="${deptMap.deptCd}" style="width:162px"/> --%>
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<c:if test="${deptMap.deptType != 'B'}">
						<th rowspan="4" id="deptNmZone"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
						</c:if>
						<c:if test="${deptMap.deptType == 'B'}">
						<th rowspan="4" id="deptNmZone"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000046","사업장명")%></th>
						</c:if>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
						<td colspan="3"><input type="text" id="deptName" name="deptName" value="${deptMultiMap.deptName}" style="width:98%"/></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790","영&nbsp;&nbsp;어")%></th>
						<td colspan="3"><input class="" type="text" id="deptNameEn" name="deptNameEn" value="${deptMultiMap.deptNameEn}" style="width:98%"></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
						<td colspan="3"><input class="" type="text" id="deptNameJp" name="deptNameJp" value="${deptMultiMap.deptNameJp}" style="width:98%"></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
						<td colspan="3"><input class="" type="text" id="deptNameCn" name="deptNameCn" value="${deptMultiMap.deptNameCn}" style="width:98%"></td>
					</tr>
					<tr id="deptAcronym">
						<c:if test="${deptMap.deptType != 'B'}">
							<th id="nickNameZone"><%=BizboxAMessage.getMessage("TX000000069","부서약칭")%></th>
							<td colspan="4"><input class="" type="text" id="deptNickname" name="deptNickname" value="${deptMultiMap.deptNickname}" style="width:98%"></td>
						</c:if>
						<c:if test="${deptMap.deptType == 'B'}">
							<th id="nickNameZone"><%=BizboxAMessage.getMessage("TX000000051","사업장약칭")%></th>
							<td colspan="4"><input class="" type="text" id="bizNickname" name="bizNickname" value="${deptMultiMap.deptNickname}" style="width:98%"></td>
						</c:if>
					</tr>
					<c:if test="${eaType == 'ea'}">
					<tr id="innerReceiveTag" style="display: none;">						
						<th><%=BizboxAMessage.getMessage("","대내수신여부")%></th>
						<td colspan="4">		
							<select id="innerReceiveYn" name="innerReceiveYn" style="width:70px;">							
							 	<option value="Y" ><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
							 	<option value="N" <c:if test="${deptMap.innerReceiveYn == 'N'}">selected</c:if>><%=BizboxAMessage.getMessage("TX000018611","미사용")%></option>
							</select>					
						</td>						
					</tr>
					</c:if>
					<c:if test="${eaType == 'ea'}">
					<tr id="standardCodeTag">						
						<th><%=BizboxAMessage.getMessage("TX000016132","정부기준코드")%></th>
						<td colspan="4">		
							<input class="" type="text" id="standardCode" name="standardCode" value="${deptMap.standardCode}" style="width:98%">					
						</td>						
					</tr>
					</c:if>
		
					<c:if test="${eaType == 'ea'}">
					<tr id="deptSenderName">
						<th><%=BizboxAMessage.getMessage("TX000008951","발신인명")%></th>
						<td colspan="4"><input class="" type="text" id="senderName" name="senderName" value="${deptMultiMap.senderName}" style="width:98%"></td>
					</tr>
					</c:if>
					<tr id="deptUseYn">
						<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
						<td colspan="4">
							<input type="radio" name="useYn" id="use_radio_u1" value="Y" class="k-radio" checked="checked"/>
							<label class="k-radio-label radioSel" for="use_radio_u1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
							<input type="radio" name="useYn" id="use_radio_u2" value="N" class="k-radio" <c:if test="${deptMap.useYn == 'N'}">checked</c:if> />
							<label class="k-radio-label radioSel" for="use_radio_u2" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000005964","사용안함")%></label>
						</td>
					</tr>
					<tr id="bizDisplayZone" style="display: none;">
						<th><%=BizboxAMessage.getMessage("TX000017924","조직도 표시여부")%></th>
						<td colspan="4">
							<input id="bizDisplay" name="bizDisplay" style="width:100px"/>
						</td>	
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
						<td colspan="2"><input class="" type="text" id="orderNum" name="orderNum" value="${deptMap.orderNum}" style="width:98%" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000375","주소")%></th>
						<td colspan="2">
							<input type="text" id="zipCode" name="zipCode"  value="${deptMap.zipCode}" style="width:88px;" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="우편번호"</c:if>>
								<div class="controll_btn p0" <c:if test="${ClosedNetworkYn == 'Y'}">style="display: none;"</c:if>>
									<button id="bizZip" onclick="fnZipPop(this);"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
								</div>
							<br />
							<input type="text" style="width:92%" id="addr" name="addr" class="mt5" value="${deptMultiMap.addr}"/>
							<input type="text" value="${deptMultiMap.detailAddr}" style="width:92%" id="detailAddr" name="detailAddr" class="mt5" value=""/>
						</td>
					</tr>
					
					<!-- TO DO : 코드 추가 -->
					<c:set var="captain" value="${deptCaptain}"/>
					<c:if test="${captain eq 'Y' }">
					<tr id="captainRow">
						<th><%=BizboxAMessage.getMessage("TX000016247","부서장")%></th>
						<td colspan="4"><input type="text" id="deptCaptain" value="${captainInfo}" readonly="readonly";/>&nbsp;&nbsp;<button id="orgChartButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button></td>
						<input type="hidden" value="" id="captainEmpSeq" name="captainEmpSeq"/>
						<input type="hidden" value="" id="captainDeptSeq" name="captainDeptSeq"/>
					</tr>
					</c:if>
					</table>
				</div>
					
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="110"/>
						<col width=""/>
						<col width="110"/>
						<col width="265"/>
					</colgroup>	
					<!-- 부서유형 사업장 선택시 comp_type 클래스를 show 처리해주세요. 기본 hide -->
					<tr class="comp_type">
						<th colspan="4" class="brtn brrn"><%=BizboxAMessage.getMessage("TX000016224","사업장 추가 정보")%></th>
					</tr>
					<tr class="comp_type">
						<th><%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>
						<td><input class="" type="text" id="ownerName" name="ownerName" value="${deptMultiMap.ownerName}" style="width:250px;"></td>
												
						<th rowspan="3"><%=BizboxAMessage.getMessage("TX000018684","인감등록")%></th>
						<td rowspan="3">
							<div class="stemp_img_box posi_re" style="float:none;margin:0 auto;">
								<img id="IMG_BIZ_SEAL_IMG" alt="" width="80" height="80" src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${deptMap.sealFileId}&fileSn=0' />" >							
								<a href="#n" class="del_btn" style="visibility: hidden;" id="IMG_BIZ_SEAL_DEL" name="IMG_BIZ_SEAL" onclick="fn_ImgDel(this)"></a>
								<input type="hidden" id="IMG_BIZ_SEAL_fileID" name="IMG_BIZ_SEAL_fileID" value="${deptMap.sealFileId}">
								<input type="hidden" id="IMG_BIZ_SEAL_newYN" name="IMG_BIZ_SEAL_newYN" value="N">							
							</div>
							<div id="" class="controll_btn cen file_cen" style="width:100%">
							<p id="p_File">
								<input type="file" id="fileUpload01" class="hidden_file_add" name="IMG_BIZ_SEAL" onchange="sealUpload(this);"/>
							</p>
							<button id="btnSeal" class="phogo_add_btn ac"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
							<input id="IMG_BIZ_SEAL_SEQ" name="IMG_BIZ_SEAL_SEQ" type="hidden"/>
						</div>
						</td>
					</tr>
					<tr class="comp_type">
						<th><%=BizboxAMessage.getMessage("TX000000024","사업자번호")%></th>
						<td><input class="" type="text" id="compRegistNum" name="compRegistNum" value="${deptMap.compRegistNum}" style="width:250px;"></td>
					</tr>
					<tr class="comp_type">
						<th><%=BizboxAMessage.getMessage("TX000000025","법인번호")%></th>
						<td><input class="" type="text" id="compNum" name="compNum" value="${deptMap.compNum}" style="width:250px;"></td>
					</tr>				
				</table>
			</div>
		</div>
		
		
		<!-- 부서원정보 탭 -->
		<div class="tab_div_in">
			<!-- 테이블 -->
			<div class="com_ta2">
				<table>
					<colgroup>
						<col width="140"/>
						<col width="140"/>
						<col width=""/>
						<col width="140"/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
						<th><%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
						
					</tr>
				</table>
			</div>
			<div class="com_ta2 bg_lightgray ova_sc" style="height: 500px">
				<table>
					<colgroup>
						<col width="140" />
						<col width="140" />
						<col width="" />
						<col width="140" />
					</colgroup>
					<tbody id="userInfo">
							
					</tbody>
				</table>
			</div>
		</div>
	</div>
	


 <script>

    $(document).ready(function() {
	     /* $(".file_stemp").kendoUpload({
	         async: {
	             saveUrl: '<c:url value="/cmm/systemx/orgUploadImage.do" />',
	             removeUrl: '<c:url value="/cmm/systemx/compRemoveImage.do" />',
	             autoUpload: true
	         },
	         multiple: false,
	         upload:function(e) {
			 var inputName =  $(e.sender).attr("name");
			 var img_seq = $('#'+inputName).val();
			 var dept_seq = '${deptMap.deptSeq}';
	         e.sender.options.async.saveUrl = '<c:url value="/cmm/systemx/orgUploadImage.do" />'+"?imgSeq=" + img_seq+"&orgSeq="+dept_seq;
	         }

       }); */	  
// 	  $("#teamYn").kendoComboBox({
// 			  change: fnTypeSelect
// 	  });
	  
	  $("#nativeLangCode").kendoComboBox();
	  
	 $(".file_stemp").kendoUpload({
	            async: {
	            	saveUrl: _g_contextPath_+'/cmm/file/fileUploadProc.do',
	                autoUpload: true
	            },
	            showFileList: false,
	            upload:function(e) { 
					var dataType = 'json';
					var pathSeq = '900';
					var relativePath = '/stamp';
					
					var params = "dataType=" + dataType;
					params += "&pathSeq=" + pathSeq;
					params += "&relativePath=" + relativePath;
					
	            	e.sender.options.async.saveUrl = _g_contextPath_+'/cmm/file/fileUploadProc.do?'+params;
	            	
	            	var inputName =  $(e.sender).attr("name");
	            	
	            	$('#'+inputName+"_INP").val(e.files[0].name);
	            	
	            },
	            success: onSuccess
        	}); 
	 

	 
	 function onSuccess(e) {
			if (e.operation == "upload") {
				var fileId = e.response.fileId;
				if (fileId != null && fileId != '') {
					
					var inputName =  $(e.sender).attr("name");

					$.ajax({
						type:"post",
						url:_g_contextPath_+"/cmm/systemx/orgUploadImage.do",
						datatype:"json",
						data: {imgType:inputName,orgSeq:'${deptMap.deptSeq}',fileId : fileId},
						success:function(data){
							var dUrl = "/gw/cmm/file/fileDownloadProc.do?fileId="+fileId+"&fileSn=0";
							$('#'+inputName+"_IMG").attr("src",dUrl);
							
							//alert(data.result);
						},			
						error : function(e){	//error : function(xhr, status, error) {
							alert("error");	
						}
					});	
					
					
				} else {
					alert(e.response);
				}
				
			}
		}  
       
       // 파일업로드 버튼 custom... kendo ui 그대로 사용하지 않아 몇가지 css를 변경해야됨..
        $(".k-dropzone").find("em").html("");			// 안내문구 제거
        $(".k-upload-button").css("float","left");
        $(".k-upload-button").find("span").html("찾기"); 	// 선택 버튼 한글명
        $(".k-upload-status-total").css({"line-height":""});
        $(".k-upload-status-total").css({"float":""});
        $(".k-dropzone").css({"padding":""});
        
        fnUserInfoList();
        
    });
    
    
    function fnUserInfoList() {
    	
    	var param = {};
    	var dept = $("#deptSeq").val();    	
    	var deptType = "${deptMap.deptType}";
    	
    	if(dept == "" || dept == null || deptType == "B"){
    		return;
    	}
    	
    	param.deptSeq = dept;
    	param.orderFlag = "1";
    	param.useYn = 'Y';
    	param.existMaster = 'N';
    	param.compSeq = $("#compSeq").val();
    	
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
    				}
    			}
    		}
    	
    	});
    
    }
    
    function fnUserInfoDraw(userInfo) {
    	
    	var tag = '';
    	
    	for(var i=0; i<userInfo.length; i++) {	
    		var id = userInfo[i].deptSeq + "|" + userInfo[i].empSeq;
    		tag += '<tr>';
    		tag += '<td>' + userInfo[i].positionCodeName + '</td>';
    		tag += '<td>' + userInfo[i].dutyCodeName + '</td>';
    		tag += '<td>' + userInfo[i].empName2 + '</td>';
    		tag += '<td><input type=\"text\" onkeydown=\'return onlyNumber(event)\' onkeyup=\'removeChar(event)\' id=\'' + id + '\' name=\'' + id + '\' value=\'' + isNull(userInfo[i].orderNum) + '\'></td>';
    		tag += '</tr>';
    	}
    	
    	$("#userInfo").html(tag);
    }
    
  //null값 체크(''공백 반환)
	function isNull(obj){
		return (typeof obj != "undefined" && obj != null && obj != "null") ? obj : "";
	}
  
  
  
	function fn_ImgDel(target)
	{			 			
		$('#'+target.id).attr("style","visibility:hidden");
 		$('#'+target.name+"_IMG").attr("style","visibility:hidden");	
 		$('#'+target.name+"_fileID").val("");
 		$('#'+target.name+"_newYN").val("N");
 		
 		var innerHTML = "";
 		innerHTML = "<input type='file' id='fileUpload01' class='hidden_file_add' name='IMG_BIZ_SEAL' onchange='sealUpload(this);'/>";		
 		
 		$("#p_File").html("");		
		$("#p_File").html(innerHTML);
	}
	
	
	function sealUpload(value){
  	  if(value.files && value.files[0]) 
		{
			var reader = new FileReader();

			reader.onload = function (e) {
				$('#IMG_BIZ_SEAL_IMG').attr('src', e.target.result);
				$("#IMG_BIZ_SEAL_IMG").attr("style","visibility:visible");
			}
		
			reader.readAsDataURL(value.files[0]);
			
			$("#IMG_BIZ_SEAL_DEL").attr("style", "visivility:visible");
		}
    }
</script>


