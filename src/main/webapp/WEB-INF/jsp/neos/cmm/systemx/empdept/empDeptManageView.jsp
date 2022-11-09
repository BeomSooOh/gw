<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<c:if test="${ClosedNetworkYn != 'Y'}">
	<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>
</c:if>

<script type="text/javascript">
	var empDeptInfoMap = null;
	var empDeptIndex = 0;
	var empMainCompSeq = "";
	var empMainDeptYn = "";
	var empCheckWorkYn = "";
	var empWorkStatus = "";
	var curEmpRow;
	var curEmpDeptRow;
	var dutyPositionOption = "${displayPositionDuty}";
	var empLicenseCheckYn = "";
	var arrCompSeq = [];
	var empDeptCnt = 0;
	var isNew = true;
	var checkEaDept = 0;
	var empDeletCheckCnt = 0;


	var checkEmpDeptCnt = 0;
	var checkEmpCnt = 0;

		$(document).ready(function() {
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    $("#workStatus").kendoComboBox();
		    $("#useYn").kendoComboBox();
		    $("#mainDeptYn").kendoComboBox();
		    $("#positionCode").kendoComboBox();
		    $("#dutyCode").kendoComboBox();
		    $("#checkWorkYn").kendoComboBox();
		    $("#workStatus2").kendoComboBox();

		 	// 마스터의 경우 회사선택 comboBox 추가
			<c:if test="${loginVO.userSe == 'MASTER'}">
			    $("#com_sel").kendoComboBox({
			    	dataTextField: "compName",
		            dataValueField: "compSeq",
			        dataSource :${compListJson},
//	 		        value:"${params.compSeq}",
					index : 0,
			        change: setCompSeq,
			         filter: "contains",
			        suggest: true
		    });

		    var coCombobox = $("#com_sel").data("kendoComboBox");
 		    coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
		    var cnt = $("#com_sel").data("kendoComboBox").dataSource.data().length;
		    coCombobox.dataSource.insert(cnt, { compName: "<%=BizboxAMessage.getMessage("TX000003833","미지정")%>", compSeq: "NONE" });
		    coCombobox.refresh();

		    if("${params.myCompSeq}"){
		    	coCombobox.value("${params.myCompSeq}");
		    }else{
		    	coCombobox.select(0);
		    }

			 </c:if>

			 $("#compSeq").val("${params.compSeq}");
			 $("#com_sel2").kendoComboBox({
			    	dataTextField: "compName",
		            dataValueField: "compSeq",
			        dataSource :${compListJson},
			        filter: "contains",
			        suggest: true,
		            change: function(e) {

		            	if(e.sender.selectedIndex == -1){
		            		e.sender.value("");
		            	}else{
		                    setPosDuty();
		            	}
		            }
			 });

			$("#workStatus").val("999");
			$("#useYn").val("");
			getEmpList();
		});


		function compChange(e) {
			alert(e);
		}

		function setCompSeq(){
			$("#compSeq").val($("#com_sel").val());
			getEmpList();
		}

		function getEmpList(){
			initEmpDeptInfo();
			$("#empSeq").val("");
			$("#empDeptTable").html("");
			var tblParam = {};
			<c:if test="${loginVO.userSe == 'MASTER'}">
				tblParam.compSeq = $("#com_sel").val();
			</c:if>
			<c:if test="${loginVO.userSe != 'MASTER'}">
				tblParam.compSeq = "${params.compSeq}";
			</c:if>
			tblParam.nameAndLoginId = $("#txtEmpNmId").val();
			tblParam.deptSeq = $("#deptSeq2").val();
			tblParam.deptName = $("#deptName2").val();
			tblParam.positionDutyName = $("#txtPosDuty").val();
			tblParam.workStatus = $("#workStatus2").data("kendoComboBox").value();
			tblParam.useYn = $("#useYn").val();
			tblParam.searchTp = "empDeptList";

			$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/getEmpInfoListNew.do" />',
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				setEmpListGrid(data.empList);
	 			},
	 			error : function(e){	//error : function(xhr, status, error) {
	 				alert("error");
	 			}
	 		});
		}

		function setEmpListGrid(empMap){
			var innerHTML = "";

			for(var i=0;i<empMap.length;i++){
				innerHTML += "<tr onclick='getEmpInfo(this.id, this)' id='" + empMap[i].empSeq + "'>";
				innerHTML += "<td>" + empMap[i].loginId + "</td>";
				if(empMap[i].empName != null)
					innerHTML += "<td>" + empMap[i].empName + "</td>";
				else
					innerHTML += "<td></td>";
				innerHTML += "</tr>";
			}
			$("#empListTable").html(innerHTML);
		}

		function getEmpInfo(e, target){
			initEmpDeptInfo();
			var tblParam = {};
			tblParam.compSeq = $("#compSeq").val();
			tblParam.empSeq = e;
			tblParam.empDeptFlag = "Y";
			$("#empSeq").val(e);

			var table = document.getElementById("empListTable");
			var tr = table.getElementsByTagName("tr");
			for(var i=0; i<tr.length; i++)
				tr[i].style.background = "white";
			target.style.backgroundColor = "#E6F4FF";

			$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/getEmpInfoList.do" />',
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				//회사 겸직 갯수 구하기.
	 				//주회사 드랍다운리스트 활성/비활성을 위해
	 				arrCompSeq = [];
	 				for (var i = 0; i < data.empList.length; i++) {
	 					var flag = true;
	 					for (var j = 0; j < arrCompSeq.length; j++) {
		 				    if(arrCompSeq[j] == data.empList[i].compSeq){
		 				    	flag = false;
		 				    	break;
		 				    }
		 				}
	 					if(flag){
	 						arrCompSeq.push(data.empList[i].compSeq);
	 					}
	 				}


	 				setEmpDeptTable(data.empList);
	 			},
	 			error : function(e){	//error : function(xhr, status, error) {
	 				alert("error");
	 			}
	 		});
		}

		function getEmpInfoSet(e){
			initEmpDeptInfo();
			var tblParam = {};
			tblParam.compSeq = $("#compSeq").val();
			tblParam.empSeq = e;
			tblParam.empDeptFlag = "Y";
			$("#empSeq").val(e);

			$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/getEmpInfoList.do" />',
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				setEmpDeptTable(data.empList);
	 			},
	 			error : function(e){	//error : function(xhr, status, error) {
	 				alert("error");
	 			}
	 		});
		}

		function setEmpDeptTable(empMap){
			var innerHTML = "";
			empDeptInfoMap = empMap;

			empLicenseCheckYn = empMap[0].licenseCheckYn;
// 			if(empLicenseCheckYn == "2" || empLicenseCheckYn == "3")
// 				$("#trEaDisplay").hide();
// 			else
// 				$("#trEaDisplay").show();

			for(var i=0;i<empMap.length;i++){
				innerHTML += "<tr onclick='setEmpDeptInfo(this)' id='" + i + "' empDeptCnt='" + empMap[i].empDeptCnt + "' empCnt='" + empMap[i].empCnt + "' groupSeq='" + empMap[i].groupSeq + "' compSeq='" + empMap[i].compSeq + "' deptSeq='" + empMap[i].deptSeq + "' empSeq='" + empMap[i].empSeq + "' loginId='" + empMap[i].loginId + "' compName='" + empMap[i].compName + "' deptName='" + empMap[i].deptName + "' empName='" + empMap[i].empName + "' deptDutyCodeName='" + empMap[i].deptDutyCodeName + "' deptPositionCodeName='" + empMap[i].deptPositionCodeName + "'>"
				innerHTML += "<td name='flagCompSeq" + empMap[i].compSeq + "'>" + empMap[i].compName + "</td>";
				if(empMap[i].deptName == null)
					innerHTML += "<td></td>";
				else
					innerHTML += "<td>" + empMap[i].deptName + "</td>";

				if(empMap[i].mainCompYn == "Y")
					innerHTML += "<td><%=BizboxAMessage.getMessage("TX900000132","주회사")%></td>";
				else
					innerHTML += "<td><%=BizboxAMessage.getMessage("TX900000133","부회사")%></td>";

				if(empMap[i].mainDeptYn == "Y")
					innerHTML += "<td><%=BizboxAMessage.getMessage("TX000006209","주부서")%></td>";
				else if(empMap[i].mainDeptYn == "N")
					innerHTML += "<td><%=BizboxAMessage.getMessage("TX000006210","부부서")%></td>";
				else
					innerHTML += "<td></td>";

				if(dutyPositionOption == "position") {
					if(empMap[i].deptPositionCodeName == null)
						innerHTML += "<td></td>";
					else
						innerHTML += "<td>" + empMap[i].deptPositionCodeName + "</td>";
				} else {
					if(empMap[i].deptDutyCodeName == null)
						innerHTML += "<td></td>";
					else
						innerHTML += "<td>" + empMap[i].deptDutyCodeName + "</td>";
				}

				innerHTML += "</tr>";
			}
			$("#empDeptTable").html(innerHTML);
		}

		function setEmpDeptInfo(e){
			empDeptIndex = e.id
			var empDeptInfo = empDeptInfoMap[e.id];
			var empErpNo = "";

			empMainCompSeq = empDeptInfo.mainCompSeq;
			empMainDeptYn = empDeptInfo.mainDeptYn;

			isNew = false;

			var tblParam = {};
			tblParam.compSeqOld = empDeptInfo.compSeq;
			tblParam.deptSeq = empDeptInfo.deptSeq;
			tblParam.flagOldDeptSeq = true;
			tblParam.empSeq = $("#empSeq").val();
			$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/getEmpErpInfo.do" />',
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				if(data.erpMap != null){
	 					$("#erpEmpNum").val(data.erpMap.erpEmpSeq);
	 					$("#erpCompSeq").val(data.erpMap.erpCompSeq);
	 					empErpNo = data.erpMap.erpEmpSeq;
	 					if(data.erpMap.workStatus != null){
	 						$("#workStatus").data("kendoComboBox").value(data.erpMap.workStatus);
	 						empWorkStatus = data.erpMap.workStatus;
	 					}
	 					if(data.erpMap.checkWorkYn != null){
	 						$("#checkWorkYn").data("kendoComboBox").value(data.erpMap.checkWorkYn);
	 						empCheckWorkYn = data.erpMap.checkWorkYn;
	 					}
	 				}
	 				else{
	 					$("#erpEmpNum").val("");
	 					$("#erpCompSeq").val("");
	 					$("#workStatus").data("kendoComboBox").value(empDeptInfo.workStatus);
	 					if(empDeptInfo.checkWorkYn != null)
	 						$("#checkWorkYn").data("kendoComboBox").value(empDeptInfo.checkWorkYn);
	 				}
	 				if(empDeptInfo.mainDeptYn == "N"){
	 					$("#workStatus").data("kendoComboBox").enable(false);
	 					$("#checkWorkYn").data("kendoComboBox").enable(false);
	 				}
	 				else{
	 					$("#workStatus").data("kendoComboBox").enable();
	 					$("#checkWorkYn").data("kendoComboBox").enable();
	 				}

	 				if(empDeptInfo.eaYn == "Y"){
	 					$("#trEaDisplay").show();
	 				}else{
	 					$("#trEaDisplay").hide();
	 				}
	 				$("#mainDeptSeq").val(data.mainDeptSeq);


	 				if(arrCompSeq.length == 1){
	 					$("#mainCompYn").attr("disabled", true);
	 				}else{
	 					$("#mainCompYn").attr("disabled", false);
	 				}
	 				empDeptCnt = data.empDeptCnt;
	 				empDeletCheckCnt = data.empDeletCheckCnt;
	 				
	 				if(data.messengerDisplayYn){
	 					if(data.messengerDisplayYn == 'Y') {
	 						document.getElementById("messengerDisplayYn").checked = true;
	 						document.getElementById("cjd_radi2").checked = false;
	 					} else if(data.messengerDisplayYn == 'N'){
	 						document.getElementById("messengerDisplayYn").checked = false;
	 						document.getElementById("cjd_radi2").checked = true;
	 					}
	 					
	 				}
	 			},
	 			error : function(e){	//error : function(xhr, status, error) {
// 	 				alert("error");
	 			}
	 		});





			var table = document.getElementById("empDeptTable");
			var tr = table.getElementsByTagName("tr");
			for(var i=0; i<tr.length; i++)
				tr[i].style.background = "white";
			e.style.backgroundColor = "#E6F4FF";


			$("#com_sel2").data("kendoComboBox").value(empDeptInfo.compSeq);
			$("#com_sel2").data("kendoComboBox").enable(false);
			$("#groupSeq").val(empDeptInfo.groupSeq);
			$("#compSeq").val(empDeptInfo.compSeq);
			$("#compSeqOld").val(empDeptInfo.compSeq);
			$("#deptName").val(empDeptInfo.deptName);
			$("#deptSeq").val(empDeptInfo.deptSeq);
			$("#deptSeqNew").val(empDeptInfo.deptSeq);

			$("#mainCompYn").val(empDeptInfo.mainCompYn);
			if(empDeptInfo.mainCompYn != 'Y' && empDeptInfo.mainCompYn != 'N'){
				$("#mainCompYn").val('N');
			}
			
			
			$("#mainDeptYn").data("kendoComboBox").value(empDeptInfo.mainDeptYn);



			$("#oldMainDeptYn").val(empDeptInfo.mainDeptYn);

			setPosition(empDeptInfo.compSeq, "POSITION");
			setDuty(empDeptInfo.compSeq, "DUTY");

			$("#positionCode").data("kendoComboBox").value(empDeptInfo.deptPositionCode);
			$("#dutyCode").data("kendoComboBox").value(empDeptInfo.deptDutyCode);

			$("#zipCode").val(empDeptInfo.deptZipCode);
			$("#addr").val(empDeptInfo.deptAddr);
			$("#detailAddr").val(empDeptInfo.deptDetailAddr);

			$("#telNum").val(empDeptInfo.telNum);
			$("#faxNum").val(empDeptInfo.faxNum);

			checkEaDept = 0;

			//결재전용 부서 및 결재전용조직도표시 값에따른 처리
			if(empDeptInfo.eaYn == "Y"){
				$('input[name=orgchartDisplayYn]').attr("disabled",true);
				$('input[name=messengerDisplayYn]').attr("disabled",true);
				$("#mainDeptYn").data("kendoComboBox").enable(false);
			}else{
				$('input[name=orgchartDisplayYn]').attr("disabled", false);
				$('input[name=messengerDisplayYn]').attr("disabled", false);
				$("#mainDeptYn").data("kendoComboBox").enable();
			}

			if(empDeptInfo.eaDisplayYn == "Y"){
				$("#eaDisplayY").prop("checked", true);
			}else{
				$("#eaDisplayN").prop("checked", true);
			}

			if(empDeptInfo.licenseCheckYn == "2"){
				$("#messengerDisplayYn").attr("disabled", true);
				$("#cjd_radi2").attr("disabled", true);

				$("#orgchartDisplayYn").attr("disabled", false);
				$("#cjd_radi1").attr("disabled", false);
			}
			else if(empDeptInfo.licenseCheckYn == "3"){
				$("#messengerDisplayYn").attr("disabled", true);
				$("#cjd_radi2").attr("disabled", true);

				$("#orgchartDisplayYn").attr("disabled", true);
				$("#cjd_radi1").attr("disabled", true);
			}
			else{
				if(empDeptInfo.eaYn != "Y"){
					$("#messengerDisplayYn").attr("disabled", false);
					$("#cjd_radi2").attr("disabled", false);

					$("#orgchartDisplayYn").attr("disabled", false);
					$("#cjd_radi1").attr("disabled", false);
				}
			}





			if(empDeptInfo.orgchartDisplayYn == "Y"){
				document.getElementById("orgchartDisplayYn").checked = true;
				$('input[name=eaDisplayYn]').attr("disabled",true);
			}
			else{
				document.getElementById("cjd_radi1").checked = true;
				$('input[name=eaDisplayYn]').attr("disabled",false);
			}

			if($("#mainDeptYn").data("kendoComboBox").value() == "Y"){
				$("#eaDisplayN").prop("checked", true);
				$('input[name=eaDisplayYn]').attr("disabled",true);
			}


			if(empDeptInfo.messengerDisplayYn == "Y")
				document.getElementById("messengerDisplayYn").checked = true;
			else
				document.getElementById("cjd_radi2").checked = true;

			if($("#mainDeptYn").val() == "Y"){
				$("#erpPopImg").attr("style","visibility: visible");
			}
			else if($("#mainDeptYn").val() == "N"){
				$("#erpPopImg").attr("style","visibility: hidden");
				erpInfoReload();
			}


			//권한이 없을경우 보기용테이블 셋팅
			var compCombo = $("#com_sel2").data("kendoComboBox");
			if (compCombo.selectedIndex === -1){
				$("#empDeptDetailTable").hide();
				$("#noAuthTable").show();

				$("#btnSave").hide();
				$("#btnDelete").hide();

				$("#compName_noAuth").html(empDeptInfo.compName);
				$("#deptName_noAuth").html(empDeptInfo.deptName);
				$("#erpNo_noAuth").html(empErpNo);
				if(empDeptInfo.mainDeptYn == "Y")
					$("#mainDeptYn_noAuth").html("<%=BizboxAMessage.getMessage("TX000006209","주부서")%>");
				else
					$("#mainDeptYn_noAuth").html("<%=BizboxAMessage.getMessage("TX000006210","부부서")%>");
				$("#posi_noAuth").html(empDeptInfo.deptPositionCodeName);
				$("#duty_noAuth").html(empDeptInfo.deptDutyCodeName);
				$("#deptPh_noAuth").html(empDeptInfo.telNum);
				$("#deptFax_noAuth").html(empDeptInfo.faxNum);
				if(empDeptInfo.workStatus == "999")
					$("#workStatus_noAuth").html("<%=BizboxAMessage.getMessage("TX000010068","재직")%>");
				else if(empDeptInfo.workStatus == "001")
					$("#workStatus_noAuth").html("<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>");
				else if(empDeptInfo.workStatus == "004")
					$("#workStatus_noAuth").html("<%=BizboxAMessage.getMessage("TX000021244","휴직")%>");
				else
					$("#workStatus_noAuth").html("");
				if(empDeptInfo.checkWorkYn == "Y")
					$("#checkWorkYn_noAuth").html("<%=BizboxAMessage.getMessage("TX000006211","적용")%>");
				else
					$("#checkWorkYn_noAuth").html("<%=BizboxAMessage.getMessage("TX000006212","미적용")%>");
				if(empDeptInfo.orgchartDisplayYn == "Y")
					$("#orgDisplay_noAuth").html("<%=BizboxAMessage.getMessage("TX000019921","예")%>");
				else
					$("#orgDisplay_noAuth").html("<%=BizboxAMessage.getMessage("TX000022353","아니오")%>");
				if(empDeptInfo.messengerDisplayYn)
					$("#messenger_noAuth").html("<%=BizboxAMessage.getMessage("TX000019921","예")%>");
				else
					$("#messenger_noAuth").html("<%=BizboxAMessage.getMessage("TX000022353","아니오")%>");
			}else{
				$("#empDeptDetailTable").show();
				$("#noAuthTable").hide();

				$("#btnSave").show();
				$("#btnDelete").show();
			}

			checkEmpDeptCnt = $(e).attr("empDeptCnt");
			checkEmpCnt = $(e).attr("empCnt");

			setEmpDeptResignInfo(e);
		}

		function setEmpDeptResignInfo(e){
			$('#resignPop [name="groupSeq"]').val($(e).attr("groupSeq"));
			$('#resignPop [name="compSeq"]').val($(e).attr("compSeq"));
			$('#resignPop [name="deptSeq"]').val($(e).attr("deptSeq"));
			$('#resignPop [name="empSeq"]').val($(e).attr("empSeq"));
			$('#resignPop [name="loginId"]').val($(e).attr("loginId"));
			$('#resignPop [name="compNm"]').val($(e).attr("compName"));
			$('#resignPop [name="deptNm"]').val($(e).attr("deptName"));
			$('#resignPop [name="empNm"]').val($(e).attr("empName"));
			$('#resignPop [name="dutyCodeNm"]').val($(e).attr("deptDutyCodeName"));
			$('#resignPop [name="positionCodeNm"]').val($(e).attr("deptPositionCodeName"));
		}

		function erpInfoReload(){
			var tblParam = {};
			tblParam.compSeqOld = $("#com_sel2").val();
			tblParam.empSeq = $("#empSeq").val();
			$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/getEmpErpInfo.do" />',
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				if(data.erpMap != null){
	 					$("#erpEmpNum").val(data.erpMap.erpEmpSeq);
	 					$("#erpCompSeq").val(data.erpMap.erpCompSeq);
	 				}
	 				else{
	 					$("#erpEmpNum").val("");
	 					$("#erpCompSeq").val("");
	 				}
	 			},
	 			error : function(e){	//error : function(xhr, status, error) {
// 	 				alert("error");
	 			}
	 		});
		}

		function onchangeDept(){
			if($("#mainDeptYn").data("kendoComboBox").value() == "Y"){
				$("#erpPopImg").attr("style","visibility: visible");

				$("#workStatus").data("kendoComboBox").enable();
				$("#checkWorkYn").data("kendoComboBox").enable();

				fnClickEvent(null);
			}
			else if($("#mainDeptYn").data("kendoComboBox").value() == "N"){
				$("#erpPopImg").attr("style","visibility: hidden");

				if(empWorkStatus != "")
					$("#workStatus").data("kendoComboBox").value(empWorkStatus);
				if(empCheckWorkYn != "")
					$("#checkWorkYn").data("kendoComboBox").value(empCheckWorkYn);
				$("#workStatus").data("kendoComboBox").enable(false);
				$("#checkWorkYn").data("kendoComboBox").enable(false);
				erpInfoReload();
				fnClickEvent(null);
			}
		}


		function initEmpDeptInfo(){
			$("#empDeptDetailTable").show();
			$("#noAuthTable").hide();

			$("#btnSave").show();
			$("#btnDelete").show();

			$("#com_sel2").data("kendoComboBox").value("");
			$("#com_sel2").data("kendoComboBox").enable(true);
			<c:if test="${loginVO.userSe == 'MASTER'}">
			$("#compSeq").val("");
			</c:if>
			$("#compSeqOld").val("");
			$("#deptName").val("");
			$("#deptSeq").val("");
			$("#deptSeqNew").val("");
			$("#erpEmpNum").val("");
			$("#erpCompSeq").val("");
			$("#mainDeptYn").data("kendoComboBox").value("Y");

			$("#zipCode").val("");
			$("#addr").val("");
			$("#detailAddr").val("");

			$("#telNum").val("");
			$("#faxNum").val("");

			$("#workStatus").data("kendoComboBox").value("999");
			$("#checkWorkYn").data("kendoComboBox").value("N");


			$("#erpPopImg").attr("style","visibility: visible");
			document.getElementById("orgchartDisplayYn").checked = true;
			document.getElementById("messengerDisplayYn").checked = true;


			$("#messengerDisplayYn").attr("disabled", false);
			$("#cjd_radi2").attr("disabled", false);

			$("#orgchartDisplayYn").attr("disabled", false);
			$("#cjd_radi1").attr("disabled", false);

			var table = document.getElementById("empDeptTable");
			var tr = table.getElementsByTagName("tr");
			for(var i=0; i<tr.length; i++)
				tr[i].style.background = "white";

			$("#workStatus").data("kendoComboBox").enable();
			$("#checkWorkYn").data("kendoComboBox").enable();

			$('input[name=eaDisplayYn]').attr("disabled",true);
			$("#eaDisplayN").prop("checked", true);

			$("#mainDeptYn").data("kendoComboBox").enable();


			$("#trEaDisplay").hide();
			$("#mainCompYn").attr("disabled", false);

			empDeptCnt = 0;
			checkEaDept = 0;

			isNew = true;
		}


		function setPosition(compSeq, dpType){
	    	var dataSource = null;
	    	dataSource = new kendo.data.DataSource({
		    	 transport: {
		             read:  {
		                 url: '<c:url value="/cmm/systemx/getDutyPositionListData.do" />',
		                 dataType: "json",
		                 type: 'post'
		             },
		             parameterMap: function(options, operation) {
		                 options.compSeq = compSeq;
		                 options.dpType = dpType;
		                 return options;
		             }
		         },
		         schema:{
		 			data: function(response) {
		 	  	      return response.dpList;
		 	  	    }
		 	  	  }
		     });

	        $("#positionCode").kendoComboBox({
	        	dataSource : dataSource,
	            dataTextField: "dpName",
	            dataValueField: "dpSeq",
	            value : "",
	            change: function (e) {
	            	if(e.sender.selectedIndex == -1)
	            		e.sender.value("");
	            }

	        });

	    }


		function setDuty(compSeq, dpType){

	    	var dataSource = new kendo.data.DataSource({
		    	 transport: {
		             read:  {
		                 url: '<c:url value="/cmm/systemx/getDutyPositionListData.do" />',
		                 dataType: "json",
		                 type: 'post'
		             },
		             parameterMap: function(options, operation) {
		                 options.compSeq = compSeq;
		                 options.dpType = dpType;
		                 return options;
		             }
		         },
		         schema:{
		 			data: function(response) {
		 	  	      return response.dpList;
		 	  	    }
		 	  	  }
		     });


	        $("#dutyCode").kendoComboBox({
	        	dataSource : dataSource,
	            dataTextField: "dpName",
	            dataValueField: "dpSeq",
	            value : "",
	            change: function (e) {
	            	if(e.sender.selectedIndex == -1)
	            		e.sender.value("");
	            }
	        });


	    }


		function setPosDuty(){
			var compSeq = $("#com_sel2").val();
			if(compSeq != "")
				$("#compSeq").val(compSeq);
			$("#deptSeqNew").val("");
			$("#deptName").val("");
			$("#erpEmpNum").val("");
			$("#erpCompSeq").val("");


			var tblParam = {};
			tblParam.compSeqOld = $("#com_sel2").val();
			tblParam.empSeq = $("#empSeq").val();
			$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/getEmpErpInfo.do" />',
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				if(data.erpMap != null){
	 					$("#erpEmpNum").val(data.erpMap.erpEmpSeq);
	 					$("#erpCompSeq").val(data.erpMap.erpCompSeq);
	 					$("#workStatus").data("kendoComboBox").value(data.erpMap.workStatus);
	 					$("#checkWorkYn").data("kendoComboBox").value(data.erpMap.checkWorkYn);
	 					empWorkStatus = data.erpMap.workStatus;
	 					empCheckWorkYn = data.erpMap.checkWorkYn;
	 				}
	 				if(data.empDeptCnt > 0){
 						$("#mainDeptYn").data("kendoComboBox").value("N");
 						$("#workStatus").data("kendoComboBox").enable(false);
 						$("#checkWorkYn").data("kendoComboBox").enable(false);
 						empDeptCnt = data.empDeptCnt;
	 				}
	 				else{
	 					$("#mainDeptYn").data("kendoComboBox").value("Y");
	 					$("#mainDeptYn").data("kendoComboBox").enable(false);
	 					$("#workStatus").data("kendoComboBox").enable();
	 					$("#checkWorkYn").data("kendoComboBox").enable();
	 				}

	 				$("#mainCompYn").val(data.mainCompYn);


	 				if(arrCompSeq.length == 1 && arrCompSeq[0] == $("#com_sel2").val()){
	 					$("#mainCompYn").val("Y");
	 					$("#mainCompYn").attr("disabled", true);
	 				}else{
	 					$("#mainCompYn").attr("disabled", false);
	 				}
	 			},
	 			error : function(e){	//error : function(xhr, status, error) {
	 				alert("error");
	 			}
	 		});

			setPosition(compSeq, "POSITION");
			setDuty(compSeq, "DUTY");
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


		function empDeptInfoPop() {
//	 			공개범위 선택팝업
			if($("#deptSeqNew").val() != ""){
				for(var i=0; i<$('input[name=deptSeq]').length; i++)
					$('input[name=deptSeq]')[i].value = $("#deptSeqNew").val();
			}
			else{
				for(var i=0; i<$('input[name=deptSeq]').length; i++)
					$('input[name=deptSeq]')[i].value = $("#deptSeq").val();
			}

			if($("#com_sel2").val() != ""){
				$("#compFilter").val($("#com_sel2").val());
			}


			var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
			frmPop.submit();
			pop.focus();
	    }

		function empDeptInfoPop2() {
			for(var i=0; i<$('input[name=deptSeq]').length; i++)
				$('input[name=deptSeq]')[i].value = "";

			var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel2");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
			frmPop.submit();
			pop.focus();
    }

		function callbackSel(date){
			var selectedList = date.returnObj[0];
			if(selectedList.eaYn == "Y"){
				if(empDeptCnt <= 1){
					if(empDeptCnt == 0){
						checkEaDept = -1;
					}
					else{
						if(!isNew){
							checkEaDept = -2;
						}else{
							checkEaDept = 0;
						}
					}
				}else{
					if(empMainDeptYn == "Y" && !isNew){
						checkEaDept = -3;
					}else{
						checkEaDept = 0;
					}
				}

				//결재전용 부서 및 결재전용조직도표시 값에따른 처리
					$('input[name=orgchartDisplayYn]').attr("disabled",true);
					$('input[name=messengerDisplayYn]').attr("disabled",true);

					document.getElementById("cjd_radi1").checked = true;
					document.getElementById("cjd_radi2").checked = true;

					$('input[name=eaDisplayYn]').attr("disabled",false);
					$("#eaDisplayY").prop("checked", true);

					$("#mainDeptYn").data("kendoComboBox").value("N");
					$("#mainDeptYn").data("kendoComboBox").enable(false);

					$("#trEaDisplay").show();
			}else{
				$('input[name=orgchartDisplayYn]').attr("disabled", false);
				$('input[name=messengerDisplayYn]').attr("disabled", false);

				$('input[name=eaDisplayYn]').attr("disabled",true);
				$("#eaDisplayN").prop("checked", true);

				if(empDeptCnt > 0 ){
					$("#mainDeptYn").data("kendoComboBox").enable();
				}

				$("#trEaDisplay").hide();
			}

			$("#deptName").val(selectedList.deptName);
			$("#deptSeqNew").val(selectedList.deptSeq);
			$("#compSeq").val(selectedList.compSeq);
			$("#com_sel2").data("kendoComboBox").value(selectedList.compSeq);
		}

		function callbackSel2(date){
			var selectedList = date.returnObj[0];
			$("#deptName2").val(selectedList.deptName);
			$("#deptSeq2").val(selectedList.deptSeq);
		}


		function ok(target){
			
			//target = 0    ->  사원부서연결 페이지 저장인 경우
			//target = 1    ->  결재권한 처리 팝업(비영리)에서 콜백함수로 호출인 경우
			
			
			if($("#empSeq").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000007613","사원을 선택해주세요")%>");
				return false;
			}

			if($("#com_sel2").data("kendoComboBox").value() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000010785","회사를 선택해 주세요")%>");
				return false;
			}

			if($("#compSeq").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000010785","회사를 선택해 주세요")%>");
				return false;
			}
			if($("#deptSeq").val() == "" && $("#deptSeqNew").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000004739","부서를 선택해 주세요")%>");
				return false;
			}
			if($("#deptName").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000004739","부서를 선택해 주세요")%>");
				return false;
			}
			if($("#positionCode").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000010706","직급을 선택해 주세요")%>");
				return false;
			}
			if($("#dutyCode").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000010705","직책을 선택해 주세요")%>");
				return false;
			}

			if(checkEaDept != 0){
				if(checkEaDept == -1){
					alert("<%=BizboxAMessage.getMessage("TX900000134","주부서 추가 후 결재전용부서 등록 가능합니다.")%>");
				}else if(checkEaDept == -2){
					alert("<%=BizboxAMessage.getMessage("TX900000135","주부서만 있는 경우 결재전용부서로 변경 할 수 없습니다.")%>");
				}else if(checkEaDept == -3){
					alert("<%=BizboxAMessage.getMessage("TX900000136","주부서는 결재전용 부서로 변경 할 수 없습니다.")%>");
				}
				return false;
			}

			
			//비영리 부서변경의 경우 결재 권한 처리여부 확인
			if("${loginVO.eaType}" == "ea" && $("#deptSeq").val() != "" && $("#deptSeq").val() != $("#deptSeqNew").val()){				
				if(target != "1" && checkEaDocCount() > 0){
					if(confirm("결재 권한 처리 항목이 존재합니다.\n대체자 설정을 진행하시겠습니까?")){
						$("#changeDept").val("Y");
						var pop = window.open("", "empResignPop", "width=950,height=581,scrollbars=no");
						resignPop.target = "empResignPop";
						resignPop.method = "post";
						resignPop.action = "<c:url value='/cmm/systemx/empResignPop.do'/>";
						resignPop.submit();
						pop.focus();
						$("#changeDept").val("");
						return;
					}else{
						return;
					}
				}
			}
			

			if(target == "1" || confirm("<%=BizboxAMessage.getMessage("TX000001979","저장 하시겠습니까?")%>")){

				if($("#compSeqOld").val() == "" && $("#compSeq").val() != "")
					$("#compSeqOld").val($("#compSeq").val());

				var mainCompSeqChangeYn = 'N';

				if($('td[name=flagCompSeq' + $("#compSeqOld").val() +']').length == 1){
					if($("#compSeq").val() != ""){
						if($("#compSeqOld").val() != $("#compSeq").val() && empMainCompSeq == $("#compSeqOld").val()){
							mainCompSeqChangeYn = 'Y';
						}
					}
				}

				$("#messengerDisplayYn").attr("disabled", false);
				$("#cjd_radi2").attr("disabled", false);

				$("#orgchartDisplayYn").attr("disabled", false);
				$("#cjd_radi1").attr("disabled", false);

				$("#com_sel2").data("kendoComboBox").enable(true);

				$('input[name=eaDisplayYn]').attr("disabled",false);

				$("#mainDeptYn").data("kendoComboBox").enable(true);

				$("#mainCompYn").attr("disabled", false);

				var formData = $("#empDeptInfoForm").serialize();
				formData += "&mainCompSeqChangeYn=" + mainCompSeqChangeYn
				$.ajax({
					type:"post",
					url:'<c:url value="/cmm/systemx/empDeptInfoSaveProc.do" />',
					datatype:"json",
					data: formData,
					success:function(data){
						if(data.resultCode == "fail"){
							alert(data.result);
							getEmpInfoSet($("#empSeq").val());
						} else{
							alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>")
							var cnt = 0;
							for(var i=0; i<arrCompSeq.length; i++){
								if(arrCompSeq[i] == $("#com_sel2").data("kendoComboBox").value()){
									cnt++;
								}
							}
							if(cnt == 0){
								arrCompSeq.push($("#com_sel2").data("kendoComboBox").value());
							}



							getEmpInfoSet($("#empSeq").val());
						}
					},
					error : function(e){	//error : function(xhr, status, error) {
					}
				});
			}
		}

		function fnEmpDeptRemove(){
			if($("#deptSeq").val() == ""){
				alert("<%=BizboxAMessage.getMessage("TX000010642","삭제할 부서를 선택해 주세요")%>");
				return false;
			}

// 			if($('td[name=flagCompSeq' + $("#compSeqOld").val() +']').length == 1){
// 				alert("주부서만 있는 경우 부서정보를 삭제 할 수 없습니다.\n            (해당 부서 삭제를 원하시는 경우\n         부서를 추가하신 후 삭제하여 주세요.)");
// 			}

			else{

				if(checkEmpDeptCnt == 1 || empDeletCheckCnt == 0){

					var msg = "<%=BizboxAMessage.getMessage("TX900000137","해당 회사의 주부서를 삭제하려면 퇴사처리가 필요합니다.")%>\n";
					   msg += "<%=BizboxAMessage.getMessage("TX000013946","진행하시겠습니까?")%>\n"

					if(confirm(msg)){
						var pop = window.open("", "empResignPop", "width=950,height=581,scrollbars=no");
						resignPop.target = "empResignPop";
						resignPop.method = "post";
						resignPop.action = "<c:url value='/cmm/systemx/empResignPop.do'/>";
						resignPop.submit();
						pop.focus();
					}
				}




				else if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
					var tblParam = {};
					tblParam.compSeq = $("#compSeqOld").val();
					tblParam.deptSeq = $("#deptSeq").val();
					tblParam.empSeq = $("#empSeq").val();
					tblParam.mainDeptYn = $("#mainDeptYn").val();

					$.ajax({
			 			type:"post",
			 			url:'<c:url value="/cmm/systemx/empDeptRemoveProc.do" />',
			 			datatype:"json",
			 			data: tblParam,
			 			success:function(data){
			 				alert(data.result.replace("　","\n"));

			 				if(data.resultCode != "fail"){
			 					if(data.empDeptCnt == "0"){
			 						if("${loginVO.userSe}" == "MASTER" && $("#compSeqOld").val() != $("#com_sel").val())
			 							getEmpInfoSet($("#empSeq").val());
			 						else
			 							$("#searchButton").click();
			 					}
			 					else
		 							getEmpInfoSet($("#empSeq").val());
			 				}
			 			},
			 			error : function(e){	//error : function(xhr, status, error) {
			 				alert("error");
			 			}
			 		});
				}
			}
		}

		function fnErpEmpPop(){
			var compSeq = $("#com_sel2").val();
			if(compSeq == ""){
				return;
			}

			var urladdr = "<c:url value='/cmm/systemx/ExEmpPop.do'/>?compSeq=" + compSeq + "&groupSeq=" + "${loginVO.groupSeq}" + "&empSeq=" + $("#empSeq").val();
	    	openWindow2(urladdr,  "fnErpEmpPop", 340, 560, 0) ;
		}

		function setEmpErpNo(no, erpCompSeq){
			$("#erpEmpNum").val(no);
			$("#erpCompSeq").val(erpCompSeq);
		}



		function checkMessenger(value){
			if($("#empSeq").val() != ""){
				var tblParam = {};
				tblParam.empSeq = $("#empSeq").val();
				tblParam.deptSeq = $("#deptSeq").val();
				tblParam.value = value;
				
				if(value == "N"){
					$.ajax({
			 			type:"post",
			 			url:'<c:url value="/cmm/systemx/checkMessengerUseYn.do" />',
			 			datatype:"json",
			 			data: tblParam,
			 			success:function(data){
			 				
			 				// 대화방/쪽지 조직도표시 설정 아니오 선택시
			 				if(data.result == "Y"){
			 					if(confirm('<%=BizboxAMessage.getMessage("TX000010640","모든 부서의 대화방/쪽지 조직도 표시 여부가 아니오인 경우 메신저를 사용할 수 없습니다. 메신저 사용여부를 미사용 처리 하시겠습니까?")%>'.replace("　","\n"))){
			 						setMessengerUseYn('N');
			 					}
			 					else{
			 						alert("<%=BizboxAMessage.getMessage("TX000010639","주 부서의 메신저 표시를 [예]로 설정합니다")%>");
			 						setMessengerUseYn('Y');
			 						if($("#mainDeptYn").val() == 'Y'){
			 							document.getElementById("messengerDisplayYn").checked = true;
			 							empDeptInfoMap[empDeptIndex].messengerDisplayYn = 'Y';
			 						}
			 					}
			 				}
			 				
			 			},
			 			error : function(e){
			 				alert("error");
			 			}
			 		});
				} else if(value == "Y") {
					$.ajax({
			 			type:"post",
			 			url:'<c:url value="/cmm/systemx/checkMessengerUseYn.do" />',
			 			datatype:"json",
			 			data: tblParam,
			 			success:function(data){
			 				// 대화방/쪽지 조직도표시 설정 예 선택시
			 				if(data.result == "Y") {
			 					if(confirm("'대화방/쪽지 조직도표시' 여부 '사용'시 메신저를 사용 할 수 있습니다. 메신저 사용여부도 변경 하시겠습니까?".replace("　","\n"))){
			 						updateEmpMessengerUse();
			 					}
			 				}
			 			},
			 			error : function(e){
			 				alert("error");
			 			}
			 		});
				}
			}
		}

		function setMessengerUseYn(value){
			var tblParam = {};
			if(value == 'N'){
				tblParam.empSeq = $("#empSeq").val();
				tblParam.value = value;
				$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/setMessengerUseYn.do" />',
		 			datatype:"json",
		 			data: tblParam,
		 			success:function(data){

		 			},
		 			error : function(e){
		 				alert("error");
		 			}
		 		});
			}
			else{
				tblParam.empSeq = $("#empSeq").val();
				tblParam.compSeq = $("#com_sel2").val();
				tblParam.value = value;
				$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/setMessengerUseYn.do" />',
		 			datatype:"json",
		 			data: tblParam,
		 			success:function(data){

		 			},
		 			error : function(e){
		 				alert("error");
		 			}
		 		});
			}

		}
		
		function updateEmpMessengerUse() {
			var tblParam = {};
			tblParam.empSeq = $("#empSeq").val();
			
			$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/updateEmpMessengerUse.do" />',
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){

	 			},
	 			error : function(e){
	 				alert("error");
	 			}
	 		});
		}

		function fnClickEvent(value){
			if(value == null){
				value = document.getElementById("orgchartDisplayYn").checked ? "Y" : "N";
			}

			if($("#mainDeptYn").data("kendoComboBox").value() == "N"){
				if(value == "Y"){
					$("#eaDisplayN").prop("checked", true)
					$('input[name=eaDisplayYn]').attr("disabled",true);
				}else{
					$('input[name=eaDisplayYn]').attr("disabled",false);
				}
			}else{
				$("#eaDisplayN").prop("checked", true)
				$('input[name=eaDisplayYn]').attr("disabled",true);
			}
		}


		function workStatusOnchange(){
			if($("#workStatus").data("kendoComboBox").value() == "001"){
				$("#mainCompYn").val("N");
				$("#mainCompYn").attr("disabled", true);
			}else{
				$("#mainCompYn").attr("disabled", false);
			}
		}
		
		
		
		// 결재 권한 처리여부카운트 조회(비영리)
		function checkEaDocCount(){
			
			var urlList = [];
			urlList.push("/ea/user/relation/getLineList.do");
			urlList.push("/ea/user/relation/getAbsentList.do");
			urlList.push("/ea/user/relation/getApprovalList.do");
			urlList.push("/ea/user/relation/getArchiveList.do");
			urlList.push("/ea/user/relation/getDeliveryAuthList.do");
			urlList.push("/ea/user/relation/getSignAuthList.do");
			
			var docCount = 0;
			
			for(var i=0; i<urlList.length; i++){			
				
				var url = urlList[i] + "?empSeq=" + $("#empSeq").val() + "&deptSeq=" + $("#deptSeq").val() + "&compSeq=" + $("#compSeq").val() + "&langCode=" + "${loginVO.langCode}";
							
				$.ajax({
		            type:"POST",
		            url:url,
		            contentType: "application/json",
		            datatype:"json",
		            async:false,
		            success:function(data){

		            	if(i == "0"){
		            		docCount += data.templateLineList.length + data.appLineList.length + data.auditLineList.length;
		            	}else if(i == "1"){
		            		docCount += data.absentList.length;
		            	}else if(i == "2"){
		            		docCount += data.approvalStandingList.length + data.approvalStandByList.length + data.approvalAfterAppList.length + data.approvalAuditAppList.length;
		            	}else if(i == "3"){
		            		docCount += data.getArchiveList.length;
		            	}else if(i == "4"){
		            		docCount += data.getDeliveryAuthList.length;
		            	}else if(i == "5"){
		            		docCount += data.getSignAuthList.length;
		            	}
		            }         
		        });
			}
			
			return docCount;
		}
</script>

<div class="top_box">
	<dl>
		<c:if test="${loginVO.userSe == 'MASTER'}">
		<dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
		<dd><input  id="com_sel"  /></dd>
		</c:if>
		<dt class="sawon"><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></dt>
		<dd>
			<select id="workStatus2" name="workStatus2" style="width:98px" >
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="999" selected="selected"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
				<option value="001"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></option>
				<option value="004"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
			</select>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000016213","사원명/ID 검색")%></dt>
		<dd><input type="text" class=""id="txtEmpNmId"  style="width:150px;" placeholder="<%=BizboxAMessage.getMessage("TX000016213","사원명/ID 검색")%>" onkeydown="if(event.keyCode==13){javascript:getEmpList();}"/></dd>
		<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="getEmpList()"/></dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>"/></span>
</div>

<div class="SearchDetail mb14">
	<dl>
		<dt class="sawon"><%=BizboxAMessage.getMessage("TX000000098","부서")%></dt>
		<dd class="mr20" style="width:180px;">
			<input class="" type="text" value="" style="width:150px" id="deptName2" name="deptName2" readonly="readonly">
			<input class="" type="hidden" value="" style="width:150px" id="deptSeq2" name="deptSeq2">
			<a href="#" class="btn_ico_search" onclick="empDeptInfoPop2();"></a>
		</dd>
		<dt style="width:65px;"><%=BizboxAMessage.getMessage("TX000015243","직급/직책")%></dt>
		<dd class="mr20"><input class="" type="text" value="" style="width:150px" id="txtPosDuty"></dd>

		<dt style="width:65px;"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
		<dd class="mr20">
		<select id="useYn" name="useYn" style="width:100px">
			<option value="" selected="selected"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
			<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
			<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
		</select>
		</dd>
	</dl>
</div>

<div class="sub_contents_wrap mt14" id="dataDiv">

	<div class="twinbox">
		<table style="min-height: auto;">
			<colgroup>
				<col width="30%">
				<col>
			</colgroup>
			<tbody>
				<tr>

					<!-- 왼쪽 -->
					<td class="twinbox_td ">
						<div class="com_ta2">
							<table>
								<colgroup>
									<col width="120"/>
									<col width=""/>
								</colgroup>
								<tbody>
									<tr>
										<th><%=BizboxAMessage.getMessage("TX000016418","ID")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000076","사원명")%></th>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="com_ta2 scroll_y_on bg_lightgray" style="height:519px;">
							<table class="brtn">
								<colgroup>
									<col width="120"/>
									<col width=""/>
								</colgroup>
								<tbody id="empListTable">

								</tbody>
							</table>
						</div>
					</td>


					<!-- 오른쪽 -->
					<td class="twinbox_td">
						<div class="btn_div m0 mb5">
							<div class="left_div">
							<p class="tit_p m0 mt5"><%=BizboxAMessage.getMessage("TX000016253","부서 정보목록")%></p>
							</div>
							<div class="right_div">
								<div id="" class="controll_btn p0">
									<button id="" class="k-button" onclick="initEmpDeptInfo();"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
									<button id="btnSave" class="k-button" onclick="ok('0');"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
									<button id="btnDelete" class="k-button" onclick="fnEmpDeptRemove();"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
								</div>
							</div>
						</div>

						<div class="com_ta2">
							<table>
								<colgroup>
									<col width="200"/>
									<col width="150"/>
									<col width="150"/>
									<col width="100"/>
									<col width=""/>
								</colgroup>
								<thead>
									<tr>
										<th><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
										<th><%=BizboxAMessage.getMessage("TX900000132","주회사")%></th>
										<th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>
										<c:if test="${displayPositionDuty eq 'position'}">
											<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
										</c:if>
										<c:if test="${displayPositionDuty eq 'duty'}">
											<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
										</c:if>

									</tr>
								</thead>
							</table>
						</div>

						<div class="com_ta2 scroll_y_on bg_lightgray" style="height:148px;">
							<table class="brtn">
								<colgroup>
									<col width="200"/>
									<col width="150"/>
									<col width="150"/>
									<col width="100"/>
									<col width=""/>
								</colgroup>
								<tbody id="empDeptTable">

								</tbody>
							</table>
						</div>

						<p class="tit_p mt30"><%=BizboxAMessage.getMessage("TX000006208","상세정보")%></p>
						<form action='<c:url value="/cmm/systemx/empDeptInfoSaveProc.do" />' id="empDeptInfoForm" name="empDeptInfoForm" method="post" onsubmit="return false;">
						<div class="com_ta dod_search" id="empDeptDetailTable">
							<input type="hidden" id="groupSeq" name="groupSeq">
							<input type="hidden" id="compSeq" name="compSeq">
							<input type="hidden" id="compSeqOld" name="compSeqOld">
							<input type="hidden" id="empSeq" name="empSeq">
							<input type="hidden" id="mainDeptSeq" name="mainDeptSeq">
							<table>
								<colgroup>
									<col width="120"/>
									<col />
									<col width="120"/>
									<col />
								</colgroup>
								<tr>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
									<td><input  id="com_sel2" style="width:157px" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>"/></td>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
									<td>
										<input class="" type="text" value="" style="width:130px;" id="deptName" name="deptName" readonly="readonly">
										<input class="" type="hidden" value="" id="deptSeq" name="deptSeq">
										<input class="" type="hidden" id="deptSeqNew" name="deptSeqNew">
										<a class="btn_sear" href="#" onclick="empDeptInfoPop();"></a>
									</td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></th>
									<td colspan="3">
										<input class="" type="text" value="" style="width:130px" id="erpEmpNum" name="erpEmpNum" readonly="readonly">
										<input class="" type="hidden" value="" id="erpCompSeq" name="erpCompSeq">
										<a class="btn_sear" href="#" id="erpPopImg" onclick="fnErpEmpPop();" style="visibility: hidden;"></a>
									</td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX900000132","주회사")%></th>
									<td>
										<dd class="mr20">
										<select id="mainCompYn" name="mainCompYn" style="width:157px">
											<option value="Y"><%=BizboxAMessage.getMessage("TX900000132","주회사")%></option>
											<option value="N"><%=BizboxAMessage.getMessage("TX900000133","부회사")%></option>
										</select>
										</dd>
									</td>
									<th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>
									<td>
										<dd class="mr20">
										<select id="mainDeptYn" name="mainDeptYn" style="width:157px" onchange="onchangeDept();">
											<option value="Y"><%=BizboxAMessage.getMessage("TX000006209","주부서")%></option>
											<option value="N"><%=BizboxAMessage.getMessage("TX000006210","부부서")%></option>
										</select>
										<input type="hidden" id="oldMainDeptYn" name="oldMainDeptYn">
										</dd>
									</td>
								</tr>
								<tr>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
									<td><input  id="positionCode" name="positionCode" style="width:157px" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>"/></td>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
									<td><input  id="dutyCode" name="dutyCode" style="width:157px" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>"/></td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000016246","부서전화")%></th>
									<td><input type="text" value="" style="width:157px;" id="telNum" name="telNum"></td>
									<th><%=BizboxAMessage.getMessage("TX000016243","부서팩스")%></th>
									<td><input type="text" value="" style="width:157px;" id="faxNum" name="faxNum"></td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></th>
									<td>
										<select id="workStatus" name="workStatus" style="width:157px" onchange="workStatusOnchange();">
											<option value="999" selected="selected"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
											<option value="001"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></option>
											<option value="004"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
										</select>
									</td>
									<th><%=BizboxAMessage.getMessage("TX000000111","근태여부")%></th>
									<td>
										<select id="checkWorkYn" name="checkWorkYn" style="width:157px">
											<option value="Y"><%=BizboxAMessage.getMessage("TX000006211","적용")%></option>
											<option value="N"><%=BizboxAMessage.getMessage("TX000006212","미적용")%></option>
										</select>
									</td>
								</tr>
								<tr style="display: none;">
									<th><%=BizboxAMessage.getMessage("TX000000375","주소")%></th>
									<td colspan="3">
										<input type="text" value="" style="width:88px;" id="zipCode" name="zipCode" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="<%=BizboxAMessage.getMessage("TX000000009","우편번호")%>"</c:if>>
										<div id="" class="controll_btn p0" <c:if test="${ClosedNetworkYn == 'Y'}">style="display: none;"</c:if>>
											<button id="" onclick="fnZipPop();"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
										</div>
										<div class="mt5">
											<input class="mr5" type="text" value="" style="float:left; width:41%;" id="addr" name="addr"/>
											<input type="text" value="" style="float:left; width:55%;" id="detailAddr" name="detailAddr"/>
										</div>
									</td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000006215","조직도표시")%></th>
									<td>
										<input type="radio" name="orgchartDisplayYn" id="orgchartDisplayYn" class="k-radio"  checked="checked" value="Y" onclick="fnClickEvent('Y');">
										<label class="k-radio-label radioSel" for="orgchartDisplayYn" style=""><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
										<input type="radio" name="orgchartDisplayYn" id="cjd_radi1" class="k-radio" value="N" onclick="fnClickEvent('N');">
										<label class="k-radio-label radioSel" for="cjd_radi1" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
									</td>
									<th><%=BizboxAMessage.getMessage("TX000007934","대화방")%>/<%=BizboxAMessage.getMessage("TX000000260","쪽지")%><br><%=BizboxAMessage.getMessage("TX000006215","조직도표시")%></th>
									<td>
										<input type="radio" name="messengerDisplayYn" id="messengerDisplayYn" class="k-radio"  checked="checked" value="Y" onclick="checkMessenger('Y')">
										<label class="k-radio-label radioSel" for="messengerDisplayYn" style=""><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
										<input type="radio" name="messengerDisplayYn" id="cjd_radi2" class="k-radio" value="N" onclick="checkMessenger('N')">
										<label class="k-radio-label radioSel" for="cjd_radi2" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
									</td>
								</tr>
								<tr id="trEaDisplay" style="display: none;">
									<th><%=BizboxAMessage.getMessage("TX900000138","결재 전용")%></br><%=BizboxAMessage.getMessage("TX000006215","조직도표시")%></th>
									<td colspan="3">
										<input type="radio" name="eaDisplayYn" id="eaDisplayY" class="k-radio" value="Y">
										<label class="k-radio-label radioSel" for="eaDisplayY" style=""><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
										<input type="radio" name="eaDisplayYn" id="eaDisplayN" class="k-radio" value="N" checked="checked">
										<label class="k-radio-label radioSel" for="eaDisplayN" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
									</td>
								</tr>
							</table>
						</div>


						<div class="com_ta dod_search" id="noAuthTable" style="display: none;">
							<table>
								<colgroup>
									<col width="120"/>
									<col />
									<col width="120"/>
									<col />
								</colgroup>
								<tr>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
									<td id="compName_noAuth"></td>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
									<td id="deptName_noAuth"></td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></th>
									<td id="erpNo_noAuth"></td>

									<th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>
									<td id="mainDeptYn_noAuth"></td>
								</tr>
								<tr>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
									<td id="posi_noAuth"></td>
									<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
									<td id="duty_noAuth"></td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000016246","부서전화")%></th>
									<td id="deptPh_noAuth"></td>
									<th><%=BizboxAMessage.getMessage("TX000016243","부서팩스")%></th>
									<td id="deptFax_noAuth"></td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></th>
									<td id="workStatus_noAuth"></td>
									<th><%=BizboxAMessage.getMessage("TX000000111","근태여부")%></th>
									<td id="checkWorkYn_noAuth"></td>
								</tr>
								<tr>
									<th><%=BizboxAMessage.getMessage("TX000006215","조직도표시")%></th>
									<td id="orgDisplay_noAuth"></td>
									<th><%=BizboxAMessage.getMessage("TX000007934","대화방")%>/<%=BizboxAMessage.getMessage("TX000000260","쪽지")%><br><%=BizboxAMessage.getMessage("TX000006215","조직도표시")%></th>
									<td id="messenger_noAuth"></td>
								</tr>
							</table>
						</div>
						</form>
					</td>
				</tr>
			</tbody>
		</table>
	</div>


</div><!-- //sub_contents_wrap -->


<%-- <form id="frmPop" name="frmPop"> --%>
<!-- 	<input type="hidden" id="type" name="type" value="" /> <input -->
<!-- 		type="hidden" id="moduleType" name="moduleType" value="d" /> <input -->
<!-- 		type="hidden" id="selectType" name="selectType" value="s" /> <input -->
<!-- 		type="hidden" id="selectedList" name="selectedList" value="" /> <input -->
<!-- 		type="hidden" id="selectedOrgList" name="selectedOrgList" value="" /> -->
<!-- 	<input type="hidden" id="duplicateOrgList" name="duplicateOrgList" -->
<!-- 		value="" /> -->
<%-- </form> --%>

<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="d" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="" />
	<input type="hidden" name="deptSeq" value=""/>
	<input type="hidden" id="compFilter" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="eaYn" value="Y"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/>
</form>

<form name="resignPop" id="resignPop" method="post">
    <input type="hidden" name="groupSeq" value="" />
    <input type="hidden" name="compSeq" value="" />
    <input type="hidden" name="deptSeq" value="" />
    <input type="hidden" name="empSeq" value="" />
    <input type="hidden" name="loginId" value="" />
    <input type="hidden" name="compNm" value="" />
    <input type="hidden" name="deptNm" value="" />
    <input type="hidden" name="empNm" value="" />
    <input type="hidden" name="dutyCodeNm"  value="" />
    <input type="hidden" name="positionCodeNm"  value="" />
    <input type="hidden" name="isEmpDeptPop"  value="Y" />
    <input type="hidden" name="changeDept" id="changeDept" value="" />
</form>


