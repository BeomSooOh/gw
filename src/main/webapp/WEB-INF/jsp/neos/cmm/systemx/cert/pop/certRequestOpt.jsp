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
	        $("#btnClose").click(function () { fnClose(); });			//닫기버튼
        });
   		
   		//신규등록
   		if ('${param.type}' == "new") {
     		$("#btnSave").show();
        }
        else {
			//상세조회일 경우 컨트롤 수정불가하도록 처리.
			$("#btnClose").show();
			$("#btnSelectUser").attr("disabled", "disabled");
			$("#txtVisitCO").attr("readonly", "readonly");
			$("#txtVisitNM").attr("readonly", "readonly");
			$("#txtVisitAim").attr("readonly", "readonly");
			$("#txtVisitHP").attr("readonly", "readonly");
			$("#txtVisitCarNo").attr("readonly", "readonly");
			$("#txtVisitCnt").attr("readonly", "readonly");
			$("#txtVisitDt1").attr("readonly", "readonly");
			$("#ddlStartHour").attr("disabled", "disabled");
			$("#ddlStartMin").attr("disabled", "disabled");
			$("#txtETC").attr("readonly", "readonly");
		}
   		
   		//컨트롤초기화
   		fnControlInit();
   		
		//기본버튼
	    $(".controll_btn button").kendoButton();
	});//document ready end
	
	
	//저장
	function fnSave(){
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
        if ($("#txtVisitDt1").val() == "") {
            alert("<%=BizboxAMessage.getMessage("TX000010898","방문날짜를 입력하세요")%>");
            return false;
        }

        var param = {};
        var sFrDt = $("#txtVisitDt1").val();
        var sToDt = "";
		var sDist = "1";
		var sHour = $("#ddlStartHour").val();
		var sMin = $("#ddlStartMin").val();
	
		
        param.man_comp_seq = $("#hidCoSeq").val();
        param.man_emp_seq = $("#hidUserSeq").val();
        //param.req_co_id = "100084";
        //param.req_user_id = "200753";
        param.visitor_co = $("#txtVisitCO").val();
        param.visitor_nm = $("#txtVisitNM").val();
        param.visit_aim = $("#txtVisitAim").val();
        param.visit_hp = $("#txtVisitHP").val();
        param.visit_car_no = $("#txtVisitCarNo").val();
        param.visit_cnt = $("#txtVisitCnt").val();
        param.fr_dt = sFrDt.replace(/-/gi, "");
        param.to_dt = sToDt.replace(/-/gi, "");
        param.visit_tm_fr = sDist == "1" ? sHour + (sMin == "" ? "00" : sMin) : "";
        param.visit_tm_to = "";
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
    				alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
    				opener.BindListGrid();
    				self.close();
    		    } ,
   		    error: function (result) { 
   		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
  		    		}
    	});	        
    
	}
	
	
	//컨트롤 초기화
	function fnControlInit(){

	}   

	
	//닫기버튼
	function fnClose(){
		self.close();
	}
	
</script>


<div class="pop_wrap_dir" style="width:458px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000006685","옵션설정")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo02.png" alt="" /></a>
	</div>	
	
		
	<div class="pop_con">


			<div class="com_ta">
				<table>
					<colgroup>
						<col width="135"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000007177","개인정보입력")%></th>
						<td class="">
							<input type="radio" name="inp_radi" id="inp_radi1" class="k-radio" checked="checked">
							<label class="k-radio-label radioSel" for="inp_radi1"><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
							<input type="radio" name="inp_radi" id="inp_radi2" class="k-radio">
							<label class="k-radio-label radioSel" for="inp_radi2" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000007178","알림팝업 내용")%></th>
						<td>
							<textarea style="height:100px;width:98%;padding:5px;"></textarea>
						</td>
					</tr>
				</table>
			</div>

	</div><!--// pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!--// pop_wrap -->
<div class="modal"></div>