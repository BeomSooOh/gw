<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script>
$(document).ready(function() {
	
	//기본버튼
    $(".controll_btn button").kendoButton();

	
	//직책 셀렉트박스
// 	var a = eval("${positionList}");
// 	alert(JSON.stringify(a));
// 	alert(JSON.stringify(${positionList}));
	
	$("#dutyCode").kendoDropDownList();
    $("#positionCode").kendoDropDownList();

	
	
	
	    $("#tel_company").kendoComboBox({
	        dataSource : {
				data : ["02","..."]
	        },
	        value:"02"
	    });
	    
	    
	    
	    
	    
	

	var inline = new kendo.data.HierarchicalDataSource({
        data: [${orgChartList}],
        schema: {
            model: {
            	id: "seq",
                children: "nodes"
            } 
        }
	});
	
	 $("#treeview").kendoTreeView({
         dataSource: inline,
         select: onSelectTree,
         dataTextField: ["name"],
         dataValueField: ["seq", "gbn"]
      }); 
}); 



//트리뷰 선택 처리
function onSelectTree(e) {
   var item = e.sender.dataItem(e.node);
   callbackOrgChart(item);
}

function callbackOrgChart(item) {
	var compSeq = '${compSeq}';
	
	if (item.gbn == 'd') {
		var deptSeq = item.seq;
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/deptInfoData.do" />',
			data:{compSeq:compSeq, gbnOrg:item.gbn, deptSeq:deptSeq},
			datatype:"json",			
			success:function(data){								
				
				if (data.deptMap) {
					var seq = data.deptMap.deptSeq;
					var name = data.deptMap.deptName;
					var tel = data.deptMap.telNum;
					var zipCode = data.deptMap.zipCode;
					var addr = data.deptMap.addr;
					var detailAddr = data.deptMap.detailAddr;
					
					$("#deptSeqNew").val(seq);
					$("#deptName").val(name);
					$("#telNum").val(tel);
					$("#zipCode").val(zipCode);
					$("#addr").val(addr);
					$("#detailAddr").val(detailAddr);
				}
			}
		});
	}
}

</script> 
	
	<body>
	<form id="basicForm" name="basicForm" action="empDeptInfoSaveProc.do" method="post">
<div class="pop_wrap" style="width:998px;">
	<input id="groupSeq" name="groupSeq" value="${infoMap.groupSeq}" type="hidden" />
	<input id="compSeq" name="compSeq" value="${infoMap.compSeq}" type="hidden" />
	<input id="bizSeq" name="bizSeq" value="${infoMap.bizSeq}" type="hidden" />
	<input id="empSeq" name="empSeq" value="${infoMap.empSeq}" type="hidden" />
	<input id="deptSeq" name="deptSeq" value="${infoMap.deptSeq}" type="hidden" />
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000017921","겸직부서찾기")%></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div>	
	
	<div class="pop_con">
		<div class="trans_nrw">

			<div class="tree_title">
				<h2><%=BizboxAMessage.getMessage("TX000017922","겸직부서 선택")%></h2>
			</div>

			<!-- 조직도 -->
			<div class="treeCon">									
				<div id="treeview" class="tree_icon" style="height:467px;"></div>
			</div> 	
		</div>

		<div class="trans_mid" style="width:694px; height:485px; overflow:auto;">
			<div class="btn_top2">
				<h2><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></h2>
			</div>

			<!-- 기본정보 테이블 -->
			<div class="com_ta">
				<table>
					<colgroup>
							<col width="115"/>
							<col width="232"/>
							<col width="115"/>
							<col width=""/>
					</colgroup>
					<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
							<td>
<!-- 								<input id="positionCode" name="dutyCode" style="width:206px" /> -->
								<select id="positionCode" name="positionCode">
								 	<option value=""><%=BizboxAMessage.getMessage("TX000000265","선택")%></option>
								 	<c:forEach items="${positionList}" var="list">
								 		<option value="${list.dpSeq}" <c:if test="${list.dpSeq == infoMap.deptPositionCode}">selected</c:if> >${list.dpName}</option>
								 	</c:forEach>
								</select>
							</td>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
							<td>
<!-- 								<input id="dutyCode" style="width:206px" /> -->
								<select id="dutyCode" name="dutyCode">
									<option value=""><%=BizboxAMessage.getMessage("TX000000265","선택")%></option>
									<c:forEach items="${dutyList}" var="list">
								 		<option value="${list.dpSeq}" <c:if test="${list.dpSeq == infoMap.deptDutyCode}">selected</c:if> >${list.dpName}</option>
								 	</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000006108","겸직부서")%>1</th>
							<td colspan="3">
								<input type="text" id="deptName" name="deptName" value="${infoMap.deptName}" style="width:388px;">
								<input id="deptSeqNew" name="deptSeqNew" type="hidden" value="${infoMap.deptSeq}" />
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016136","전화번호(회사)")%></th>
							<td colspan="3">
								<input type="text" id="telNum" name="telNum" value="${infoMap.telNum}"/>
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000004113","주소(회사)")%></th>
							<td colspan="3" class="pd6">
								<input type="text" id="zipCode" name="zipCode" value="${infoMap.deptZipCode}" style="width:88px;"> 
								<div id="" class="controll_btn p0">
									<button id=""><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
								</div>
								
								<div class="mt5">
									<input class="mr5" type="text" id="addr" name="addr" value="${infoMap.deptAddr}" style="float:left; width:40%;"/>
									<input type="text" id="detailAddr" name="detailAddr" value="${infoMap.deptDetailAddr}" style="float:left; width:55%;"/>
								</div>
							</td>
						</tr>
				</table>
			</div>
		
			<div class="btn_top2 mt12">
				<h2><%=BizboxAMessage.getMessage("TX000017923","그룹웨어 설정정보")%></h2>
			</div>
			
			<div class="com_ta">
				<table>
					<colgroup>
							<col width="115"/>
							<col width="232"/>
							<col width="115"/>
							<col width=""/>
					</colgroup>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/> " alt="" /> <%=BizboxAMessage.getMessage("TX000003435","표시여부")%></th>
						<td colspan="3">
							<ul class="yb_ul">
								<li>
									<span><%=BizboxAMessage.getMessage("TX000017924","조직도 표시여부")%></span>
									<input type="radio" id="orgchartDisplayYn" name="orgchartDisplayYn" value="Y"  class="k-radio" checked="checked"/>
									<label class="k-radio-label radioSel" for="orgchartDisplayYn"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label>
									<input type="radio" name="orgchartDisplayYn" value="N" id="cjd_radi2" class="k-radio" <c:if test="${infoMap.orgchartDisplayYn == 'N'}">checked</c:if>/>
									<label class="k-radio-label radioSel ml10" for="cjd_radi2"><%=BizboxAMessage.getMessage("TX000017925","미표용")%></label> <br />
								</li>
								<li>
									<span><%=BizboxAMessage.getMessage("TX000017961","메신저 표시여부")%></span>
									<input type="radio" id="messengerDisplayYn" name="messengerDisplayYn" value="Y"  class="k-radio" checked="checked"/>
									<label class="k-radio-label radioSel" for="msj_radi1"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label>
									<input type="radio" name="messengerDisplayYn" value="N" id="msj_radi2" class="k-radio" <c:if test="${infoMap.messengerDisplayYn == 'N'}">checked</c:if>/>
									<label class="k-radio-label radioSel ml10" for="msj_radi2"><%=BizboxAMessage.getMessage("TX000017925","미표용")%></label> <br />	
								</li>
							</ul>
						</td>
					</tr>
				</table>	
			</div>


		</div><!--// trans_mid -->

	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave();"/>
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();"/>
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->
</form>
</body>
	
<script>
$(document).ready(function() {

	
	var validator = $("#basicForm").kendoValidator().data("kendoValidator");
	
	 $("basicForm").submit(function(event) {
            event.preventDefault();
            if (validator.validate()) {
                status.text("Hooray! Your tickets has been booked!")
                    .removeClass("invalid")
                    .addClass("valid");
            } else {
                status.text("Oops! There is invalid data in the form.")
                    .removeClass("valid")
                    .addClass("invalid");
            }
        });
	 
	 if("${flag}" == "Y"){
		 $("#deptSeq_1", opener.document).val($("#deptSeqNew").val());
			$("#deptSeq", opener.document).val($("#deptSeqNew").val());
			opener.$("#positionCode").data("kendoComboBox").value($("#positionCode").val());
//			$("#positionCode", opener.document).val($("#positionCode").val());
			opener.$("#dutyCode").data("kendoComboBox").value($("#dutyCode").val());
//			$("#dutyCode", opener.document).val($("#dutyCode").val());
			$("#deptName_1", opener.document).val($("#deptName").val());
			$("#telNum", opener.document).val($("#telNum").val());
			$("#deptZipCode", opener.document).val($("#zipCode").val());
			$("#deptAddr", opener.document).val($("#addr").val());
			$("#deptDetailAddr", opener.document).val($("#detailAddr").val());
			
			var orgchartDisplayYn = $("input[name=orgchartDisplayYn]:checked").val();
			$("input[name=orgchartDisplayYn][value=" + orgchartDisplayYn + "]", opener.document).attr("checked", true);
			
			var orgchartDisplayYn = $("input[name=messengerDisplayYn]:checked").val();
			$("input[name=messengerDisplayYn][value=" + orgchartDisplayYn + "]", opener.document).attr("checked", true);
			       		
			window.close();
	 }
});

function fnClose(){
	window.close();
}



function fnSave(){
	if($("#deptSeqNew").val() == '' && $("#deptSeqNew").val() == null){
		alert("<%=BizboxAMessage.getMessage("TX000004739","부서를 선택해 주세요.")%>");
		return false;
	}
	
	var empSeq = $("#empSeq").val();
	if (empSeq != null && empSeq != '') {
		document.basicForm.submit();	       					
	} else {
			$("#deptSeq_1", opener.document).val($("#deptSeqNew").val());
			$("#deptSeq", opener.document).val($("#deptSeqNew").val());
			opener.$("#positionCode").data("kendoComboBox").value($("#positionCode").val());
// 			$("#positionCode", opener.document).val($("#positionCode").val());
			opener.$("#dutyCode").data("kendoComboBox").value($("#dutyCode").val());
// 			$("#dutyCode", opener.document).val($("#dutyCode").val());
			$("#deptName_1", opener.document).val($("#deptName").val());
			$("#telNum", opener.document).val($("#telNum").val());
			$("#deptZipCode", opener.document).val($("#zipCode").val());
			$("#deptAddr", opener.document).val($("#addr").val());
			$("#deptDetailAddr", opener.document).val($("#detailAddr").val());
			
			var orgchartDisplayYn = $("input[name=orgchartDisplayYn]:checked").val();
			$("input[name=orgchartDisplayYn][value=" + orgchartDisplayYn + "]", opener.document).attr("checked", true);
			
			var orgchartDisplayYn = $("input[name=messengerDisplayYn]:checked").val();
			$("input[name=messengerDisplayYn][value=" + orgchartDisplayYn + "]", opener.document).attr("checked", true);
			       		
			window.close();
	}
}

</script>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<!-- 
	
<div id="example">
	<form id="basicForm" name="basicForm" action="empDeptInfoSaveProc.do" method="post">
        <div class="demo-section k-header">
        	<div id="tickets">
				<input id="groupSeq" name="groupSeq" value="${infoMap.groupSeq}" type="hidden" />
				<input id="compSeq" name="compSeq" value="${infoMap.compSeq}" type="hidden" />
				<input id="bizSeq" name="bizSeq" value="${infoMap.bizSeq}" type="hidden" />
				<input id="empSeq" name="empSeq" value="${infoMap.empSeq}" type="hidden" />
				<input id="empSeq" name="deptSeq" value="${infoMap.deptSeq}" type="hidden" />
				 
				<div class="fLeft" style="width:30%">
					<h3>겸직부서 선택</h3>
							
						<div id="treeview" class="tree_icon" style="height:467px;"></div>

		             
		             
		             
		             
				</div>   
				  
				<div class="fLeft" style="width:60%;padding-left:30px">				 
	                <h4>기본정보 </h4>   
	                <ul id="fieldlist">  
	                    <li> 
	                        <label for="positionCode">직급</label>
	                        <select id="positionCode" name="positionCode">
							 	<option value="">선택</option>
							 	<c:forEach items="${positionList}" var="list">
							 		<option value="${list.dpSeq}" <c:if test="${list.dpSeq == infoMap.deptPositionCode}">selected</c:if> >${list.dpName}</option>
							 	</c:forEach>
							</select>
	                    </li>
	                    <li> 
	                        <label for="dutyCode">직책</label>
	                        <select id="dutyCode" name="dutyCode">
								<option value="">선택</option>
								<c:forEach items="${dutyList}" var="list">
							 		<option value="${list.dpSeq}" <c:if test="${list.dpSeq == infoMap.deptDutyCode}">selected</c:if> >${list.dpName}</option>
							 	</c:forEach>
							</select>
	                    </li>
	                    <li>  
	                        <label for="deptSeqNew">겸직부서</label>
	                        <input id="deptName" value="${infoMap.deptName}" />
	                        <input id="deptSeqNew" name="deptSeqNew" type="hidden" value="${infoMap.deptSeq}" />
	                    </li>
	                    <li> 
	                        <label for="telNum">전화번호(회사)</label>
	                        <input id="telNum" name="telNum" value="${infoMap.telNum}" />
	                    </li>
	                    <li>
	                        <label for="zipCode">회사주소</label>
	                    	<input id="zipCode" name="zipCode" value="${infoMap.deptZipCode}" /> <button id="findZip" class="saveBtn">찾기</button>
	                        <p><input id="addr" name="addr" value="${infoMap.deptAddr}" /></p>
	                        <p><input id="detailAddr" name="detailAddr" value="${infoMap.deptDetailAddr}" /></p>
	                    </li> 
	                    
	                <h4>그룹웨어 설정정보</h4>
	                <ul id="fieldlist">
	                    <li> 
	                        <label for="orgchartDisplayYn">조직도표시여부</label>
	                        <input type="radio" id="orgchartDisplayYn" name="orgchartDisplayYn" value="Y" checked />사용 <input type="radio" name="orgchartDisplayYn" value="N" <c:if test="${infoMap.orgchartDisplayYn == 'N'}">checked</c:if> />미사용
	                        
	                    </li> 
	                    <li> 
	                        <label for="messengerDisplayYn">메신저표시여부</label>
	                        <input type="radio" id="messengerDisplayYn" name="messengerDisplayYn" value="Y" checked />사용 <input type="radio" name="messengerDisplayYn" value="N" <c:if test="${infoMap.messengerDisplayYn == 'N'}">checked</c:if> />미사용
	                    </li>
	                </ul>
		        <div> 
		            <button class="k-button k-primary saveBtn" type="button">저장</button> <button class="k-button k-primary cancelBtn" type="button">취소</button>
			    </div> 
                </div>
            </div>
        </div>
    </form>
            <script>
	            $(document).ready(function() {
	            	
	            	$(".cancelBtn").kendoButton({
		       			 click: function(e) {
		       				
		       				window.close();
		       			 }
		       		 }); 
	            	
	            	$(".saveBtn").kendoButton({
		       			 click: function(e) {
		       				var empSeq = $("#empSeq").val();
		       				if (empSeq != null && empSeq != '') {
								document.basicForm.submit();	       					
		       				} else {
		       					
			       					$("#deptSeq_1", opener.document).val($("#deptSeqNew").val());
			       					$("#deptSeq", opener.document).val($("#deptSeqNew").val());
			       					$("#positionCode", opener.document).val($("#positionCode").val());
			       					$("#dutyCode", opener.document).val($("#dutyCode").val());
			       					$("#deptName_1", opener.document).val($("#deptName").val());
			       					$("#telNum", opener.document).val($("#telNum").val());
			       					$("#deptZipCode", opener.document).val($("#zipCode").val());
			       					$("#deptAddr", opener.document).val($("#addr").val());
			       					$("#deptDetailAddr", opener.document).val($("#detailAddr").val());
			       					
			       					var orgchartDisplayYn = $("input[name=orgchartDisplayYn]:checked").val();
			       					$("input[name=orgchartDisplayYn][value=" + orgchartDisplayYn + "]", opener.document).attr("checked", true);
			       					
			       					var orgchartDisplayYn = $("input[name=messengerDisplayYn]:checked").val();
			       					$("input[name=messengerDisplayYn][value=" + orgchartDisplayYn + "]", opener.document).attr("checked", true);
		       						       		
			       					window.close();
		       				}
		       				 
		       			 }
		       		 }); 
	            	
	            	var validator = $("#basicForm").kendoValidator().data("kendoValidator");
	            	
	            	 $("basicForm").submit(function(event) {
	                        event.preventDefault();
	                        if (validator.validate()) {
	                            status.text("Hooray! Your tickets has been booked!")
	                                .removeClass("invalid")
	                                .addClass("valid");
	                        } else {
	                            status.text("Oops! There is invalid data in the form.")
	                                .removeClass("valid")
	                                .addClass("invalid");
	                        }
	                    });
	            });
	            
            </script>
			
			<style>
                #fieldlist {
                    margin: 0;
                    padding: 0;
                }

                #fieldlist li {
                    list-style: none;
                    padding-bottom: .7em;
                    text-align: left;
                }

                #fieldlist label {
                    display: block;
                    padding-bottom: .3em;
                    font-weight: bold;
                    text-transform: uppercase;
                    font-size: 12px;
                    color: #444;
                }

                #fieldlist li.status {
                    text-align: center;
                }

                #fieldlist li .k-widget:not(.k-tooltip),
                #fieldlist li .k-textbox {
                    margin: 0 5px 5px 0;
                }

                .confirm {
                    padding-top: 1em;
                }

                .valid {
                    color: green;
                }

                .invalid {
                    color: red;
                }

                #fieldlist li input[type="checkbox"] {
                    margin: 0 5px 0 0;
                }

                span.k-widget.k-tooltip-validation {
                    display; inline-block;
                    width: 160px;
                    text-align: left;
                    border: 0;
                    padding: 0;
                    margin: 0;
                    background: none;
                    box-shadow: none;
                    color: red;
                }

                .k-tooltip-validation .k-warning {
                    display: none;
                }

                 .fLeft {  
                	float:left; 
                }
            </style>

</div>
            
            
            
       -->
