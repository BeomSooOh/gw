<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
    	$(document).ready(function() {
    		
    		//버튼 이벤트
            $(function () {
                $("#btnSave").click(function () { fnSave(); });				//저장버튼
                $("#btnSelectUser").click(function () { fnUserPop(); });	//유저선택 버튼
                $("#btnClose").click(function () { fnClose(); });			//닫기버튼
            });
    		
    		//type : new -> 저장버튼
    		//else       -> 닫기버튼
    		if ('${param.type}' == "new") {
                $("#btnSave").show();
            }
   		 	else {
   		 		//상세조회시 컨트롤 수정불가 처리
   		 		$("#btnClose").show();
   		 		$("#txtManUserNM").attr("disabled", "disabled");
  	            $("#txtVisitCO").attr("disabled", "disabled");
  	            $("#txtVisitNM").attr("disabled", "disabled");
  	            $("#txtVisitAim").attr("disabled", "disabled");
  	            $("#txtVisitHP").attr("disabled", "disabled");
  	            $("#txtVisitCarNo").attr("disabled", "disabled");
  	            $("#txtVisitCnt").attr("disabled", "disabled");
  	            $("#txtETC").attr("disabled", "disabled");
  	            $("#btnSelectUser").attr("disabled", "disabled");
  	            $("#txtVisitDt1").attr("disabled", "disabled");
  	            $("#txtVisitDt2").attr("disabled", "disabled");
   	        }
    		
    		//컨트롤 초기화
    		fnControlInit();
    		
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    
			//방문시간
		    $("#txtVisitDt1").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });
		    $("#txtVisitDt2").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });
		    
		});//document ready end
		
		//컨트롤 초기화
		function fnControlInit(){
			var r_no = '${param.r_no}';
			
			var dateObj = new Date();
			var year = dateObj.getFullYear();
			var month = dateObj.getMonth()+1;
			var day = dateObj.getDate();
			var today = year + "-" + month + "-" + day;

	        //$("#hidRNo").val() = r_no;
	        $("#txtReqUserNM").val("");
	        $("#txtAppInfo").val("");
	        $("#txtVisitCO").val("");
	        $("#txtVisitNM").val("");
	        $("#txtVisitAim").val("");
	        $("#txtVisitHP").val("");
	        $("#txtVisitCarNo").val("");
	        $("#txtVisitCnt").val("0");
	        $("#txtVisitDt1").val(today);
	        $("#txtVisitDt2").val(today);
	        $("#txtETC").val("");

	        if ('${param.r_no}' != "0") {
	            fnGetVisitor();
	        }
		}
		
		
		//데이터 조회
		function fnGetVisitor(){
			var param = {};
			param.nRNo = '${param.r_no}';
			param.pDist = 2;
			param.pFrDT = $("#txtVisitDt1").val();
			param.pToDT = $("#txtVisitDt1").val();
			param.pType = 'search';
			param.startNum = 0;
			param.endNum = 1;
			
			$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/ex/visitor/GetVisitor.do"/>',
	    		datatype:"json",
	            data: param ,
	    		success: function (result) {
	    				fnSetData(result);
	    		    } ,
    		    error: function (result) { 
    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
   		    		}
	    	});
		}
		
		//조회된 데이터 셋팅
		function fnSetData(res) {
	        $("#txtManUserNM").val(res.man_comp_name + "/" + res.man_dept_name + "/" + res.man_emp_name);
	        if (res.approver_comp_name != null && res.approver_comp_name != "") {
	            $("#txtAppInfo").val(res.approver_comp_name + "/" + res.approver_emp_name);
	        }
	        $("#txtVisitCO").val(res.visitor_co);
	        $("#txtVisitNM").val(res.visitor_nm);
	        $("#txtVisitAim").val(res.visit_aim);
	        $("#txtVisitHP").val(res.visit_hp);
	        $("#txtVisitCarNo").val(res.visit_car_no);
	        $("#txtVisitCnt").val(res.visit_cnt);
	        $("#txtVisitDt1").val(res.visit_dt_fr);
	        $("#txtVisitDt2").val(res.visit_dt_to);
	        $("#txtETC").val(res.etc);
	        //fnGetAppInfo(res[0].r_no, 0);
	    }
		
		
		//닫기
		function fnClose(){
			self.close();
		}
		
		
		//저장
		function fnSave() {

	        if ($("#txtManUserNM").val() == "") {
	            alert("<%=BizboxAMessage.getMessage("TX000010901","담당자를 지정해주세요")%>");
	            return false;
	        }
	        if ($("#txtVisitCO").val() == "") {
	            alert("<%=BizboxAMessage.getMessage("TX000010900","방문자 회사를 입력하세요")%>");
	            return false;
	        }
	        if ($("#txtVisitNM").val() == "") {
	            alert("<%=BizboxAMessage.getMessage("TX000010899","방문자 성명을 입력하세요")%>");
	            return false;
	        }
	        if ($("#txtVisitDt1").val() == "" || $("#txtVisitDt2").val() == "") {
	            alert("<%=BizboxAMessage.getMessage("TX000010898","방문날짜를 입력하세요")%>");
	            return false;
	        }
	        if ($("#txtVisitDt1").val() > $("#txtVisitDt2").val()){
	        	alert("<%=BizboxAMessage.getMessage("","방문 시작날짜가 방문 종료날짜보다 큽니다.")%>");
	            return false;
	        }

	        
	        var param = {};
	        var sFrDt = $("#txtVisitDt1").val();
	        var sToDt = $("#txtVisitDt2").val();
			var sDist = "2";
			
	        param.man_comp_seq = $("#hidCoSeq").val();
	        param.man_emp_seq = $("#hidUserSeq").val();
	        //param.req_co_id = "100084";
	        //param.req_user_id = "200753";
	        param.visitor_co = $("#txtVisitCO").val();
	        param.visitor_nm = $("#txtVisitNM").val();
	        param.visit_aim = $("#txtVisitAim").val();
	        param.visit_hp = $("#txtVisitHP").val();
	        param.visit_car_no = $("#txtVisitCarNo").val();
	        param.visit_cnt = $("#txtVisitCnt").val() == "" ? "0" : $("#txtVisitCnt").val();
	        param.fr_dt = sFrDt.replace(/-/gi, "");
	        param.to_dt = sToDt.replace(/-/gi, "");
	        param.note = $("#txtETC").val();
	        param.distinct = sDist;
	        param.sInTime = "";
            param.sOutTime = "";
	        
	        
	       
            $.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/ex/visitor/InsertVisitor.do"/>',
	    		datatype:"json",
	            data: param ,
	    		success: function (cnt) {
	    				opener.fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>","success",1500);
	    				opener.fnGetListData();
	    				self.close();
	    		    } ,
    		    error: function (result) { 
    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
   		    		}
	    	});
	    }
		
		
		//닫기
		function fnClose(){
			self.close();
		}
		
		//유저선택 팝업
		function fnUserPop () {
			//cmmOrgEmpDeptPop('','e','s','','','');
			
			var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
			frmPop.submit();
			pop.focus();
	     }
	
		//유저선택 콜백 함수
		function callbackSel(data) {
			if(data.returnObj[0].empSeq != null){
		   		$("#txtManUserNM").val(data.returnObj[0].deptName + "/" + data.returnObj[0].dutyName + "/" + data.returnObj[0].empName);
		   		$("#hidCoSeq").val(data.returnObj[0].compSeq);
		   		$("#hidUserSeq").val(data.returnObj[0].empSeq);
			
	   		
	   		
		   		var param = {};
				param.nRNo = '${param.r_no}';
				param.nManCoSeq = $("#hidCoSeq").val();
				
				//선택 유저의 승인자 조회.
				$.ajax({
		        	type:"post",
		    		url:'<c:url value="/cmm/ex/visitor/GetAppInfo.do"/>',
		    		datatype:"json",
		            data: param ,
		    		success: function (result) {
			                    $("#txtAppInfo").val(result.app_grade_name + "/" + result.app_emp_name);
		    		    } ,
	    		    error: function (result) { 
	    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	   		    		}
		    	});
			}
			
	  }   
    </script>


<div class="pop_wrap" style="width:550px;">

		<input type="hidden" id="hidCoSeq" name="hidCoSeq" />
		<input type="hidden" id="hidUserSeq" name="hidUserSeq" />
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000010109","외주인원")%></h1>
			<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
		</div>
		
		<div class="pop_con">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="130"/>
						<col width=""/>
					</colgroup>
					<tr id="">
						<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000329","담당자")%></th>
						<td>
							<input type="text" id="txtManUserNM" name="txtManUserNM" style="width:250px;" readonly="readonly"/>
							<div id="" class="controll_btn p0">
								<button type="button" id="btnSelectUser"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
							</div>
						</td>
					</tr>
					<tr id="" style="display: none;">
						<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000005924","승인자")%></th>
						<td><input type="text" id="txtAppInfo" name="txtAppInfo" style="width:334px;" readonly="readonly"/></td>
					</tr>
					<tr id="">
						<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000016265","방문자 회사")%></th>
						<td><input type="text" id="txtVisitCO" name="txtVisitCO" style="width:334px;"/></td>
					</tr>
					<tr id="">
						<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000016266","방문자 성명")%></th>
						<td><input type="text" id="txtVisitNM" name="txtVisitNM" style="width:272px;"/></td>
					</tr>
					<tr id="">
						<th><%=BizboxAMessage.getMessage("TX000016269","방문목적")%></th>
						<td><input type="text" id="txtVisitAim" name="txtVisitAim" style="width:334px;"/></td>
					</tr>
					<tr id="">
						<th><%=BizboxAMessage.getMessage("TX000001495","연락처")%></th>
						<td><input type="text" id="txtVisitHP" name="txtVisitHP" style="width:272px;"/></td>
					</tr>
					<tr id="">
						<th><%=BizboxAMessage.getMessage("TX000004850","차량번호")%></th>
						<td><input type="text" id="txtVisitCarNo" name="txtVisitCarNo" style="width:272px;"/></td>
					</tr>
					<tr id="">
						<th><%=BizboxAMessage.getMessage("TX000016267","방문인원")%></th>
						<td><input type="text" id="txtVisitCnt" name="txtVisitCnt" style="width:128px;" value="0"/></td>
					</tr>
					<tr id="">
						<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000016268","방문시간")%></th>
						<td>
							<input id="txtVisitDt1" class="dpWid"/> ~
							<input id="txtVisitDt2" class="dpWid"/>
						</td>
					</tr>
					<tr id="">
						<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
						<td><input type="text" id="txtETC" name="txtETC" style="width:334px;"/></td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" id="btnSave" style="display:none;"/>
				<input id="btnClose" type="button" value="<%=BizboxAMessage.getMessage("TX000002972","닫기")%>" style="display:none;"/>
			</div>
		</div>
	</div><!-- //pop_wrap -->
	
	
	<form id="frmPop" name="frmPop">
		<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
		<input type="hidden" name="selectMode" value="u" /><br>
		<input type="hidden" name="selectItem" value="s" /><br>
		<input type="hidden" id="callback" name="callback" value="" />
		<input type="hidden" name="deptSeq" value=""/>
		<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
	</form>