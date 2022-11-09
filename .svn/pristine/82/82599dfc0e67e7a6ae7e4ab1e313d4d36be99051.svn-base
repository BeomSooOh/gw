<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>
	var selectedPage=1;
	var mailUrl = "";
	
	$(document).ready(function() {
// 		shoutCutTitleChange('사원정보관리');
		 $("#positionCode").kendoComboBox();
		 $("#dutyCode").kendoComboBox();

		 $("#workStatus").kendoComboBox({
	        	dataTextField: "text",
	            dataValueField: "value",
	            dataSource: [{text:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:""},{text:"<%=BizboxAMessage.getMessage("TX000010068","재직")%>", value:"999"},{text:"<%=BizboxAMessage.getMessage("TX000008312","퇴직")%>", value:"001"},{text:"<%=BizboxAMessage.getMessage("TX000010067","휴직")%>", value:"004"}]
	     }); 
		 
		 
		 $("#useYn").kendoComboBox();
		 $("#useYn").val("");
		 $("#workTeam").kendoComboBox();
		
		 
		//라이선스
		$("#sygb_sel").kendoComboBox();
		 
		 // 마스터의 경우 회사선택 comboBox 추가
		 <c:if test="${loginVO.userSe == 'MASTER'}">
		    $("#com_sel").kendoComboBox({
		    	dataTextField: "compName",
	            dataValueField: "compSeq",
		        dataSource :${compListJson},
		        index : 0,
		        change: gridRead,
		         filter: "contains",
		        suggest: true
		    }); 
		    
		    var coCombobox = $("#com_sel").data("kendoComboBox");
		    var cnt = $("#com_sel").data("kendoComboBox").dataSource.data().length
		    coCombobox.dataSource.insert(cnt, { compName: "<%=BizboxAMessage.getMessage("TX000003833","미지정")%>", compSeq: "NONE" });
			coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
		    coCombobox.refresh();
		    coCombobox.select(0);
		    
		 </c:if>
		 
		 // 검색
		 $("#primaryTextButton").kendoButton({
			 click: function(e) {
				 gridRead();
			}
		 });
			
		 // 입사처리 
		 $("#addEmp").kendoButton({
			 click: function(e) {
				 empInfoPop();
			 }
		 });
		 
		 // 퇴사처리 
		 $("#retireEmp").kendoButton({
			 click: function(e) {
				 empResignProc();
			 }
		 });
		 
		// 삭제 
		 $("#empDelBtn").kendoButton({
			 click: function(e) {
				 empDeletePop();
			 }
		 });
		 
		 
		 //일괄등록
		 $("#batchAddEmp").kendoButton({
			 click: function(e) {
				 openWindow2("empRegBatchPop.do", "empRegBatchPop", 1000, 800, 0);
			 }
		 });
		
		 // 근무조
		 $("#changeWorkTeam").kendoButton({
			 click: function(e) {
				 alert("<%=BizboxAMessage.getMessage("TX000010669","개발예정입니다.")%>");
			 }
		 });
		 
		 // 사원정보 엑셀저장 
		 $("#saveExcelBtn").kendoButton({
			 click: function() {
				 empExcelDownloadProc();
			 }
		 })
		 
		 var window = $("#window");
		 
		 window.kendoWindow({
			 width: "350px",
			 title: "<%=BizboxAMessage.getMessage("TX000010668","로그인 ID 변경")%>",
			 visible: false,
			 actions: [
			           "Close"
			           ]
		 });
		 
		 // 아이디변경
		 $("#changeId").kendoButton({
			 click: function(e){
				 empChangeIdProc();
			 }
		 });
		 
		 // 패스워드초기화
		 $("#changePass").kendoButton({
			 click: function(e){
				 empChangePassProc();
			 }
		 });		 
		 
		 $("#changeIdClose").kendoButton({
			 click: function(e) {
				 window.data("kendoWindow").close();
			 }
		 });		
			 

		 
		 $("#changeIdOk").kendoButton({
			 click: function(e) {
				 var loginId = $("#changeLoginId").val();
				 var empSeq = $("#loginIdEmpSeq").val();
				 updateLoginId(loginId, empSeq);
				 
				 gridRead();
				 
				 window.data("kendoWindow").close();
			 }
		 });
		 
		 $("#workStatus").data("kendoComboBox").value("999");
		 
         $("#empDeleteLayer").kendoWindow({
             width: "400px",
             title: "<%=BizboxAMessage.getMessage("TX000002649","사용자삭제")%>",
             visible: false,
             actions: [
                 "Minimize",
                 "Maximize",
                 "Close"
             ],
         }).data("kendoWindow").center().close();

		 
    	gridRead();
	});
	
	var findPasswdCheckList = '${findPasswdEmpList}';
	
	function fnFindPasswdCheck(){
		
		if(findPasswdCheckList != "" && findPasswdCheckList != "[]"){
			var url = "/gw/cmm/systemx/empChangePassReqPop.do";
			var w = 750;
			var h = 520;
			var left = (screen.width/2)-(w/2);
			var top = (screen.height/2)-(h/2);
			var pop = window.open(url, "findPasswdPop", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + ", scrollbars=0,resizable=0");
			pop.focus();			
		}
	}	
	
	function onClose(){
		
	}
	
	 function gridRead(type) {
		 
		 if($("#com_sel").val() == "NONE"){
			 $("#removeEmp").show();
			 $("#retireEmp").hide();
			 $("#empDelBtn").hide();
			 $("#workStatus").data("kendoComboBox").value("001");
			 $("#workStatus").data("kendoComboBox").enable(false);
		 }else{
			 $("#removeEmp").hide();
			 $("#retireEmp").show();
			 $("#empDelBtn").show();
			 $("#workStatus").data("kendoComboBox").enable(true);
		 }
		 
		 if(type=='search'){
			 selectedPage = 1;
			 $('#grid').data('kendoGrid').dataSource.page(0);
			 return;
		 }else{
		 	$.ajax({
	 			type:"post",
	 			url:'<c:url value="/cmm/systemx/license/LicenseCountShow.do" />',
	 			datatype:"text",
	 			success:function(data){
	 				var innerHtml = "";
	 				console.log("licenseCheck : " + JSON.stringify(data));
	 				if(data.licenseCount.resultCode == "success") {
	 					
	 					$("#cntInfoTag_1").html("<span class='text_blue'>" + data.licenseCount.realGwCount + "</span> / " + data.licenseCount.totalGwCount);
	 					$("#cntInfoTag_2").html("<span class='text_blue'>" + data.licenseCount.realMailCount + "</span> / " + data.licenseCount.totalMailCount);
	 					$("#cntInfoTag_3").html("<span class='text_blue'>" + data.licenseCount.realNotLicenseCount + "</span>");
	 					
	 					if(findPasswdCheckList != "" && findPasswdCheckList != "[]"){
	 						$("#findReqPopBtn").show();
	 					}
	 					
	 				} else {
	 					//innerHtml = "라이센스정보 조회 실패";
	 				}
 	 				
	 				//$("#cntInfoTag").html(innerHtml);
	 			},
	 			error:function(data){
	 				//$("#cntInfoTag").html("라이센스정보 조회 실패");
	 			}
	 		});			 
		 }		 
		
		 var grid = $("#grid").kendoGrid({
				 dataSource: gridDataSource,
			     sortable: true ,
	 		     selectable: true,
			     navigatable: true,
	   	  		scrollable: true,
	   	  		columnMenu: false,
	   	  		autoBind: true,
	   	  		page: selectedPage,
		   	  	pageable: {         
		            change: function (e){
		                selectedPage = e.index;            
		            },          
			 		refresh: true,
			    	pageSizes: [10, 20, 50, 100]
		        },
				dataBound: function(e){ 
					$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
							$("#grid tr[data-uid]").removeClass("k-state-selected");
							$(this).addClass("k-state-selected");
			            });
			            
					if($("#com_sel").val() != "NONE"){
						$("#grid tr[data-uid]").dblclick(function(){
			            	var selectedItem = e.sender.dataItem(e.sender.select());
			            	empInfoPop(selectedItem.compSeq, selectedItem.empSeq);
			            });	
						$("#grid tr[data-uid]").click(function(){
			            	var selectedItem = e.sender.dataItem(e.sender.select());
			            	$("#layerEmpName").html(selectedItem.empName);
			            	$("#layerLoginId").html(selectedItem.loginId);
			            });
					}
				},	   	  		
	   	  		columns: [
                            { field: "compName", title: "<%=BizboxAMessage.getMessage("TX000000047","회사")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true  },
			                { field: "deptName", title: "<%=BizboxAMessage.getMessage("TX000000098","부서")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true  },
			                { field: "deptPositionCodeName", title: "<%=BizboxAMessage.getMessage("TX000000099","직급")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true }, 
			                { field: "deptDutyCodeName", title: "<%=BizboxAMessage.getMessage("TX000000105","직책")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true}, 
			                { field: "empName2", title: "<%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%>", width:200, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "emailAddr", title: 'Mail ID', width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "workStatusNm", title: "<%=BizboxAMessage.getMessage("TX000003305","재직여부")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true }, 
			                { field: "useYn2", title: "<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "licenseCheck", title: "<%=BizboxAMessage.getMessage("TX000017941","라이선스")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true}
		           		]
			 }).data("kendoGrid");
	 }
	 
	 var gridDataSource = new kendo.data.DataSource({
		serverPaging: true,
        pageSize: 10,
         transport: { 
             read:  {
                 url: 'empListDataNew.do',
                 dataType: "json",
                 type: 'post'
             },
             parameterMap: function(options, operation) {
                 options.groupSeq = '1';
                 options.mainDeptYn = 'Y';
                 options.nameAndLoginId = $("#searchKeyword").val();
                 options.positionCode = $("#positionCode").val();
                 options.dutyCode = $("#dutyCode").val();
                 options.deptName = $("#deptName").val();
                 options.workStatus = $("#workStatus").val();
                 options.useYn = $("#useYn").val();
                 options.workTeam = $("#workTeam").val();
                 options.compSeq = "${loginVO.userSe}" == "MASTER" ? $("#com_sel").val() : "${loginVO.compSeq}";
                 options.positionDutyName = $("#positionDutyName").val();
                 options.existMaster = "N";
                 options.searchDeptSeq = $("#searchDeptSeq").val();
                 if($("#sygb_sel").val() != "0"){
                	 options.licenseCheckYn = $("#sygb_sel").val();
                 }                    
                 if (operation !== "read" && options.models) {
                     return {models: kendo.stringify(options.models)};
                 }
                 
                 return options;
             }
         }, 
         schema:{
            data: function(response) {
              return response.list;
            },
            total: function(response) {
              return response.totalCount;
            }
          }
	 });
	 
	 
	 function compChange(e) {
			$("#compSeq").val($("#com_sel").val());
			
			document.form.compSeq.value = $("#com_sel").val();
			document.form.submit();
	}
	 
	 function getChkEmp() {
		var grid = $("#grid").data("kendoGrid");
		var selectedItem = grid.dataItem(grid.select());
		
		if (selectedItem == null) {
			alert("<%=BizboxAMessage.getMessage("TX000006205","사원을 선택하세요.")%>");
			return null;
		}
		else {
			return selectedItem;
		}
	 }
	 
     function empInfoPop(compSeq, empSeq) {
    	 var url = "empInfoPop.do?compSeq="+compSeq+"&empSeq="+encodeURIComponent(empSeq);
    	 var pop = openWindow2(url,  "empInfoPop", 1000, 800, 1, 1) ;
    	 pop.focus();
     }
     
     function removeEmp(selectRow) {
    	 if (selectRow != null) {
    		 $.ajax({
 	 			type:"post",
 	 			url:"empRemoveDataCheck.do",
 	 			datatype:"json",
 	 			data: {empSeq : selectRow.empSeq, deptSeq : selectRow.deptSeq, compSeq : selectRow.compSeq, groupSeq : selectRow.groupSeq},
 	 			success:function(data){
 	 				if (data.result) {
 	 					var r = data.result;
 	 					if (r == '0') {
 	 						removeEmpInfo(selectRow);
 	 						
 	 					} else if (r == '1') {
 	 						alert("<%=BizboxAMessage.getMessage("TX000010667","상신 또는 결재중인 문서가 존재합니다")%>");
 	 					} else if (r == '2') {
 	 						alert("<%=BizboxAMessage.getMessage("TX000010666","부부서 정보가 존재합니다. 부부서 정보를 모두 삭제하세요.")%>");
 	 					} else if (r == '-1') {
 	 						alert("<%=BizboxAMessage.getMessage("TX000010665","삭제 권한이 없습니다")%>");
 	 					}
 	 				}
 	 			},			
 	 			error : function(e){
 	 				alert("error");	
 	 			}
 	 		});	
    		 
    		 
    	 } else {
    		 alert("<%=BizboxAMessage.getMessage("TX000006218","선택된 사원이 없습니다.")%>");
    	 }
     }
     
     function removeEmpInfo(selectRow) {
    	 $.ajax({
	 			type:"post",
	 			url:"empRemoveProc.do",
	 			datatype:"json",
	 			data: {empSeq : selectRow.empSeq, deptSeq : selectRow.deptSeq, compSeq : selectRow.compSeq, groupSeq : selectRow.groupSeq},
	 			success:function(data){
	 				alert(data.result);
	 				if (data.resultCode != "fail") {
	 					gridRead();	
	 				}
	 			},			
	 			error : function(e){
	 				alert("error");	
	 			}
	 		});	
     }
	  	
	  	function empResignProc(){
	  		
	  		var selectRow = getChkEmp();
			if(selectRow == null){
				return;
			}	  		
	  		else{
				var compNm = selectRow.compName;
				var compSeq = selectRow.compSeq;
				var deptNm = selectRow.deptName;
				var deptSeq = selectRow.deptSeq;
				var loginId = selectRow.loginId;
				var empNm = selectRow.empName;
				var dutyCodeNm = selectRow.deptDutyCodeName;
				var positionCodeNm = selectRow.deptPositionCodeName;
				var empSeq = selectRow.empSeq;
				var groupSeq = selectRow.groupSeq;
				
				openWindow2("",  "empResignPop", 1100, 581, 1, 1) ;
				
		        var frmData = document.empResignPop ;		        
		        
				$('input[name="compSeq"]').val(compSeq);
				$('input[name="compNm"]').val(compNm);
				$('input[name="deptNm"]').val(deptNm);
				$('input[name="deptSeq"]').val(deptSeq);
				$('input[name="groupSeq"]').val(groupSeq);
				$('input[name="loginId"]').val(loginId);
				$('input[name="empNm"]').val(empNm);
				$('input[name="dutyCodeNm"]').val(dutyCodeNm);
				$('input[name="positionCodeNm"]').val(positionCodeNm);
				$('input[name="empSeq"]').val(empSeq);
				
				frmData.submit();				
				
				
				
// 	  			var url = "empResignPop.do?compSeq="+compSeq+"&compNm="+compNm+"&deptNm="+deptNm+"&deptSeq="+deptSeq+"&groupSeq="+groupSeq+"&loginId="+loginId+"&empNm="+empNm+"&dutyCodeNm="+dutyCodeNm+"&positionCodeNm="+positionCodeNm+"&empSeq="+empSeq;
// 	  			var pop = openWindow2(url, "empResignPop", 798, 581, 0);
// 	  	    	var pop = window.open(url, "empResignPop", "width=798,height=581,scrollbars=yes");
// 	  	    	pop.focus();
	  		}
	  	}
	  	
		function empChangeIdProc(){
			
			var selectRow = getChkEmp();
			
			if(selectRow == null){
				return;
			}
	  		else{
				var compNm = selectRow.compName;
				var deptNm = selectRow.deptName;
				var loginId = selectRow.loginId;
				var empNm = selectRow.empName;
				var dutyCodeNm = selectRow.deptDutyCodeName;
				var positionCodeNm = selectRow.deptPositionCodeName;
				var empSeq = selectRow.empSeq;
				var compSeq = selectRow.compSeq;
				var groupSeq = selectRow.groupSeq;
				var deptSeq = selectRow.deptSeq;
				
				window.open("", "changIdPop", "width=800,height=355,scrollbars=no") ;		         
		        var frmData = document.changIdPop ;		        
		        
				$('input[name="compNm"]').val(compNm);
				$('input[name="deptNm"]').val(deptNm);
				$('input[name="loginId"]').val(loginId);
				$('input[name="empNm"]').val(empNm);
				$('input[name="dutyCodeNm"]').val(dutyCodeNm);
				$('input[name="positionCodeNm"]').val(positionCodeNm);
				$('input[name="empSeq"]').val(empSeq);
				$('input[name="compSeq"]').val(compSeq);
				$('input[name="deptSeq"]').val(deptSeq);
				
				frmData.submit();				
	  		}
	  	}
		
		function empChangePassProc(){
			
			var selectRow = getChkEmp();
			
			if(selectRow == null){
				return;
			}
	  		else{
				var compNm = selectRow.compName;
				var deptNm = selectRow.deptName;
				var loginId = selectRow.loginId;
				var empNm = selectRow.empName;
				var dutyCodeNm = selectRow.deptDutyCodeName;
				var positionCodeNm = selectRow.deptPositionCodeName;
				var empSeq = selectRow.empSeq;
				var compSeq = selectRow.compSeq;
				var groupSeq = selectRow.groupSeq;
				var deptSeq = selectRow.deptSeq;
				
				window.open("", "changPassPop", "width=800,height=355,scrollbars=no") ;		         
		        var frmData = document.changPassPop ;		        
		        
				$('input[name="compNm"]').val(compNm);
				$('input[name="deptNm"]').val(deptNm);
				$('input[name="loginId"]').val(loginId);
				$('input[name="empNm"]').val(empNm);
				$('input[name="dutyCodeNm"]').val(dutyCodeNm);
				$('input[name="positionCodeNm"]').val(positionCodeNm);
				$('input[name="empSeq"]').val(empSeq);
				$('input[name="compSeq"]').val(compSeq);
				$('input[name="deptSeq"]').val(deptSeq);
				
				frmData.submit();				
	  		}
	  	}		

		function fnDeptPop(){
	    	$("#compFilter").val($("#com_sel").val());
			var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
			frmPop.submit();
			pop.focus(); 
		}
		
		function callbackSel(data) {
			if(data.returnObj.length > 0){
				<c:if test="${loginVO.userSe == 'MASTER'}">
					$("#com_sel").data("kendoComboBox").value(data.returnObj[0].compSeq);		    
			 	</c:if>
				
				$("#deptName").val(data.returnObj[0].deptName);
				$("#searchDeptSeq").val(data.returnObj[0].deptSeq);
			}else{
				$("#deptName").val("");
				$("#searchDeptSeq").val("");
			}
		}
		
		function fnDelete(){
			
			var selectRow = getChkEmp();
			
			if(selectRow != null){
				 if (confirm("<%=BizboxAMessage.getMessage("TX000010660","선택된 사용자 정보를 삭제하시겠습니까?")%>")) {
					 if($("#com_sel").val() == "NONE"){
						 removeEmpInfo(selectRow);
					 }else{
						 removeEmp(selectRow);	 
					 }
				 }				
			}
		}
		
		function empDeletePop(){
			var selectRow = getChkEmp();
			if(selectRow == null){
				return;
			}
			
			var paramData = {};
	        paramData.empSeq = selectRow.empSeq;
	        $.ajax({
	            type:"post",
	            url:"checkMasterAuth.do",
	            datatype:"json",
	            data: paramData,
	            success:function(data){
					if(data.masterAuthCnt == 0){
						alert("해당 사용자는 삭제 할 수 없습니다.\n(<%=BizboxAMessage.getMessage("TX000010848","마스터권한은 최소 한 명 이상 존재해야 합니다")%>)");
						return;
					}else{
						$("#empDeleteLayer").data("kendoWindow").open();
					}
	            }          
	        });
		}	
		
		function empDeleteProc(){
			//삭제 로직순서
			//미결문서결재처리-퇴사프로세스-삭제프로세스
			//
			
			var selectRow = getChkEmp();
			//미결문서조회
			var paramData = {};
	        var isAll = "Y";
	        paramData.isEmpDelProc = "Y";
	        paramData.empSeq = selectRow.empSeq;
	        paramData.deptSeq = selectRow.deptSeq;
	        $.ajax({
	            type:"post",
	            url:"empResignDocData.do",
	            datatype:"json",
	            data: paramData,
	            beforeSend: function() {	              
	                $('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
	            },
	            success:function(data){
	            	if(data.result == "-1"){
	            		$('html').css("cursor","auto");
	            		if("${loginVO.eaType}" == "eap"){
	            			
	            			var msg = "<%=BizboxAMessage.getMessage("TX900000098","필수결재라인 및 결재문서가 존재 할 경우 삭제 할 수 없습니다.")%>\n";
	            			msg += "<%=BizboxAMessage.getMessage("TX900000139","퇴사처리 진행 후 삭제 가능합니다.")%>";
	            			
	            			alert(msg);
	            			
	            		}else{
	            			
	            			var msg = "<%=BizboxAMessage.getMessage("TX900000099","처리되지 않은 결재 문서가 존재하여 삭제 할 수 없습니다.")%>\n";
	            			msg += "<%=BizboxAMessage.getMessage("TX900000140","결재 완료 후 진행해주세요.")%>"
	            			
	            			alert(msg);
	            			            		
	            		}
	            		$("#empDeleteLayer").data("kendoWindow").close();
	            	}
	            	else{
	            		mailUrl = data.mailUrl;
	            		empResignDelProc(selectRow);	
	            	}

	            },          
	            error : function(e){
	            	$('html').css("cursor","auto");
	                alert("<%=BizboxAMessage.getMessage("TX900000100","미결문서조회 중 오류가 발생하였습니다.")%>");	                
	            }
	        });
		}
		
		function layerClose(){
			$("#empDeleteLayer").data("kendoWindow").close();
		}
		
		function fnMultiAppDocApprovalProc(data, selectRow){
			var tblParam = {};
	        var gridJson = makeJsonData(data);
	        tblParam.docInfoArr = gridJson;
	        tblParam.docLineSts = "30";
	        tblParam.resignEmp = selectRow.empSeq;
	        tblParam.resignDept = selectRow.deptSeq;
	        tblParam.resignComp = selectRow.compSeq;
	        tblParam.resignGroup = selectRow.groupSeq;
	        
	        $.ajax({
	            type:"post",
	            url:'/eap/ea/docpop/EAAppDocResignApprovalUpdate.do',
	            datatype:"json",
	            data: tblParam,
	            success:function(data){            	
	                empResignProc(selectRow);	                
	            }
	            ,error : function(data){
	            	$('html').css("cursor","auto");
	                alert("<%=BizboxAMessage.getMessage("TX900000101","미결문서 일괄 결재중 오류가 발생하였습니다.")%>");	                
	            }
	        });
		}
		
		
		function makeJsonData(data){
			var docInfoArray = new Array();  
			for(var i=0;i<data.length;i++){
				var docInfo = new Object();
				docInfo.DOC_ID = data[i].DOC_ID;
				docInfo.USER_NM = data[i].USER_NM;
				docInfo.DEPT_ID = data[i].DEPT_ID;
				docInfo.READYN = data[i].READYN;
				docInfo.DOC_TITLE = data[i].DOC_TITLE;
				docInfo.REP_DT = data[i].REP_DT;
				docInfo.CREATED_NM = data[i].CREATED_NM;
				docInfo.OPERYN = data[i].OPERYN;
				docInfo.FORM_NM = data[i].FORM_NM;
				docInfo.CREATED_DT = data[i].CREATED_DT;
				docInfo.USER_ID = data[i].USER_ID;
				docInfo.FORM_ID = data[i].FORM_ID;
				docInfo.CO_ID = data[i].CO_ID;
				docInfo.TRAY_DOC_ID = "";
				docInfo.DOC_TITLE_ORIGIN = "";
				docInfo.DOC_STS = data[i].DOC_STS;
				docInfo.FORM_MODE = data[i].FORM_MODE;
				docInfo.DOC_NO = data[i].DOC_NO;
				docInfo.REP_DT_120 = data[i].REP_DT_120;
				docInfoArray.push(docInfo);				
			}
			var totalObj = new Object();
			var jsonStr = JSON.stringify(docInfoArray);
			return jsonStr;
		}
		
		
		function empResignDelProc(selectRow){
			var tblParam = {};
			tblParam.empSeq = selectRow.empSeq;
			tblParam.compSeq = selectRow.compSeq;
			tblParam.deptSeq = selectRow.deptSeq;
			tblParam.resignDate = "";
			tblParam.isAll = "Y";
			tblParam.isDeptDel = "Y";
			tblParam.mustKyulPk = "";
			tblParam.mustKyulEmpSeq = "";
			tblParam.docPk = "";
			tblParam.docEmpSeq = "";
			tblParam.boardPk = "";
			tblParam.boardEmpSeq = "";
			tblParam.isMasterAuth = "N";
			tblParam.masterSubEmpSeq = "";
			tblParam.mailDelYn = "Y";
			tblParam.empRemoveFlag = "Y";
			
			var rtnCode = '';
			
			$.ajax({
	 			type:"post",
	 			url:"empResignProcFinish.do", //신규
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				
	 				if(data.resultCode == "SUCCESS"){
	 					empDeleteAllProc(selectRow);	 					
	 				}else{
	 					alert(data.result);
	 				}	 				
	 				
	 			},			
	 			error : function(e){
	 				$('html').css("cursor","auto");
	 				alert("<%=BizboxAMessage.getMessage("TX000010689","퇴사처리중 오류가 발생했습니다.")%>");	
	 			}
	 		});	
		}
		
		function empDeleteAllProc(selectRow){
			$.ajax({
	 			type:"post",
	 			url:"empRemoveProc.do",
	 			datatype:"json",
	 			data: {empSeq : selectRow.empSeq, deptSeq : selectRow.deptSeq, compSeq : selectRow.compSeq, groupSeq : selectRow.groupSeq, mailUrl : mailUrl},
	 			success:function(data){
	 				$('html').css("cursor","auto");
	 				alert(data.result);
	 				if (data.resultCode != "fail") {
	 					$("#empDeleteLayer").data("kendoWindow").close();
	 					gridRead();	
	 				}
	 			},			
	 			error : function(e){
	 				$('html').css("cursor","auto");
	 				alert("error");	
	 			}
	 		});			
		}
		
		function empExcelDownloadProc() {	
			var param = {
				userSe: "${loginVO.userSe}",
				compSeq: null, 
				workStatus: null,
				searchKeyword: null,
				deptName: null,
				positionDuty: null,
				useYn: null,                   
				licenseCheckYn: null
			};
			
			var url = null;
			
            param.compSeq = "${loginVO.userSe}" == "MASTER" ? $("#com_sel").val() : "${loginVO.compSeq}";
			param.workStatus = $("#workStatus").val();
			param.searchKeyword = encodeURI(encodeURIComponent($("#searchKeyword").val()));
			param.deptName = encodeURI(encodeURIComponent($("#deptName").val()));
			param.positionDutyName = encodeURI(encodeURIComponent($("#positionDutyName").val()));
			param.useYn = $("#useYn").val();
			param.licenseCheckYn = $("#sygb_sel").val() == "0" ? "" : $("#sygb_sel").val();
			
			url = "empExcelDownProc.do?";
			url += "compSeq=" + param.compSeq + "&workStatus=" + param.workStatus + "&searchKeyword=" + param.searchKeyword;
			url += "&deptName=" + param.deptName + "&positionDutyName=" + param.positionDutyName + "&useYn=" + param.useYn;
			url += "&licenseCheckYn=" + param.licenseCheckYn;
			
			document.location.href = url;
		
		}
</script>

<div class="top_box">

	<dl class="dl1">
<c:if test="${loginVO.userSe == 'MASTER'}">
			<dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
			<dd><input id="com_sel"	></dd>
</c:if>		
		<dt class="sawon"><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></dt>
		<dd>
			<input id="workStatus" name="workStatus" style="width:98px">
				
			</input>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000016217","사용자명(ID)")%> / Mail ID</dt>
		<dd><input type="text" id="searchKeyword" name="searchKeyword" style="width:160px;" onkeydown="if(event.keyCode==13){javascript:gridRead('search');}"/></dd>
		<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="gridRead('search');" /></dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>"/></span>
</div>

<div class="SearchDetail">
	<dl>
		<dt class="sawon"><%=BizboxAMessage.getMessage("TX000000098","부서")%></dt>
		<dd class="mr20">
			<input type="text" style="width:146px" readonly="readonly" id="deptName" name="deptName" onkeydown="if(event.keyCode==13){javascript:gridRead('search');}" />
			<input id="searchDeptSeq" type="hidden" value="">
			<input id="" type="button" class="btn_style01" value="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" onclick="fnDeptPop();">
		</dd>
		<dt class="sawon"><%=BizboxAMessage.getMessage("TX000015243","직급/직책")%></dt>
		<dd><input type="text" style="width:146px" id="positionDutyName" name="positionDutyName" onkeydown="if(event.keyCode==13){javascript:gridRead('search');}"/></dd>
		
		<dt class="sawon" style="width:70px;"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
		<dd class="mr20">
		<select id="useYn" name="useYn" style="width:147px">
			<option value="" selected="selected"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
			<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
			<option value="N"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
		</select>
		</dd>
		<dt class="sawon"><%=BizboxAMessage.getMessage("TX000017941","라이선스")%></dt>
		<select id="sygb_sel" name="sygb_sel" style="width:98px">
			<option value="0"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
			<option value="1"><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></option>
			<option value="2"><%=BizboxAMessage.getMessage("TX000000262","메일")%></option>
			<option value="3"><%=BizboxAMessage.getMessage("TX000017901","비라이선스")%></option>
		</select>		
	</dl>
</div>
<div class="sub_contents_wrap" id="bodyDiv">

	<div class="com_ta" style="margin-top: 10px;">
		<table>
			<colgroup>
				<col width="40%">
				<col width="40%">
				<col width="20%">
			</colgroup>
			<tbody>
				<tr>
					<th class="cen" style="font-weight: bold;"><%=BizboxAMessage.getMessage("GWLANG000001","그룹웨어 라이선스<br>(전체+메일 사용 가능)") %></th>
					<th class="cen" style="font-weight: bold;"><%=BizboxAMessage.getMessage("GWLANG000002","메일 전용 라이선스<br>(메일만 사용 가능)") %></th>
					<th class="cen" style="font-weight: bold;"><%=BizboxAMessage.getMessage("TX000017901","비라이선스") %></th>
				</tr>
				<tr>
					<td class="cen" id="cntInfoTag_1" style="padding: 0px;"><img src="/gw/Images/ico/loading.gif" style="width: 15px;"></td>
					<td class="cen" id="cntInfoTag_2" style="padding: 0px;"><img src="/gw/Images/ico/loading.gif" style="width: 15px;"></td>
					<td class="cen" id="cntInfoTag_3" style="padding: 0px;"><img src="/gw/Images/ico/loading.gif" style="width: 15px;"></td>
				</tr>
			</tbody>
		</table>
	</div>	

	<div class="btn_div">
		<div class="right_div">
			<div id="" class="controll_btn">
				<img style="display:none;cursor:pointer;" id="findReqPopBtn" src="/gw/Images/ico/ico_organ_online.png" style="cursor:pointer;" class="mtImg" onclick="fnFindPasswdCheck();" title="<%=BizboxAMessage.getMessage("","비밀번호 초기화 요청")%>" alt="<%=BizboxAMessage.getMessage("","비밀번호 초기화 요청")%>"> &nbsp;
				<button id="saveExcelBtn" class="k-button"><%=BizboxAMessage.getMessage("TX000006928","엑셀저장") %></button>
				<button id="changeId" class="k-button"><%=BizboxAMessage.getMessage("TX000016416","ID변경")%></button>
				<button id="changePass" class="k-button"><%=BizboxAMessage.getMessage("TX900000145","비밀번호 초기화")%></button>		    
				<button id="addEmp" class="k-button"><%=BizboxAMessage.getMessage("TX000004488","입사처리")%></button>
				<button id="batchAddEmp" class="k-button"><%=BizboxAMessage.getMessage("TX000006323","일괄등록")%></button>
				<button id="retireEmp" class="k-button"><%=BizboxAMessage.getMessage("TX000004490","퇴사처리")%></button>
				<c:if test="${loginVO.userSe == 'MASTER'}">
				<button id="empDelBtn" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
				</c:if>
				<button style="display:none;" id="removeEmp" class="k-button" onclick="fnDelete();"><%=BizboxAMessage.getMessage("TX000003991","완전삭제")%></button>
			</div>
		</div>
	</div>
	<div id="grid" class="com_ta2"></div>
	
</div><!-- //sub_contents_wrap -->

<!-- 삭제 레이어팝업 -->
<div class="pop_wrap_dir" id="empDeleteLayer" style="display:none">	
	<div class="pop_con">
		<em id="" class="text_red f11 mt7">!</em> 
		<%=BizboxAMessage.getMessage("TX900000102","선택한 사용자")%> <em id="" class="text_blue f11 mt5">[<em id="layerEmpName"></em>(<em id="layerLoginId"></em>)]</em><%=BizboxAMessage.getMessage("TX900000103","를 삭제하시겠습니까?")%>
		</br></br></br>
		<em id="" class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("","※ 삭제 시 겸직된 모든 회사 정보가 삭제 처리됩니다.")%></em></br>
		<em id="" class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX900000104","※ 사용자 삭제는 자동 퇴사처리 후 진행됩니다.")%></em></br>
		<em class="f11 mt5">&nbsp;&nbsp;&nbsp;&nbsp;- <%=BizboxAMessage.getMessage("TX900000105","메일 정보는 삭제 처리되며, 복원 할 수 없습니다.")%></em></br>
		<em class="f11 mt5">&nbsp;&nbsp;&nbsp;&nbsp;- <%=BizboxAMessage.getMessage("TX900000106","진행 중인 결재문서가 있는 경우 일괄 결재 처리 됩니다.")%></em></br>
		<em class="f11 mt5">&nbsp;&nbsp;&nbsp;&nbsp;- <%=BizboxAMessage.getMessage("TX900000107","지정 받은 권한은 자동 삭제처리 됩니다.")%></em></br>
		<em id="" class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX900000108","※삭제된 사용자는 복원 할 수 없습니다.")%></em></br>
	</div><!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="empDeleteProc();" />
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="layerClose();"/>
		</div>
	</div><!-- //pop_foot -->	
</div><!-- //pop_wrap -->


<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="d" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="" />
	<input type="hidden" name="deptSeq" value="" seq="deptFlag"/>
	<input type="hidden" id="compFilter" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>


<form id="changIdPop" name="changIdPop" method="post" action="/gw/cmm/systemx/empChangeIdPop.do" target="changIdPop">
  <input name="compNm" value="" type="hidden"/>
  <input name="deptNm" value="" type="hidden"/>
  <input name="loginId" value="" type="hidden"/>
  <input name="empNm" value="" type="hidden"/>
  <input name="dutyCodeNm" value="" type="hidden"/>
  <input name="positionCodeNm" value="" type="hidden"/>
  <input name="empSeq" value="" type="hidden"/>  
  <input name="compSeq" value="" type="hidden"/>
  <input name="deptSeq" value="" type="hidden"/>
</form>

<form id="changPassPop" name="changPassPop" method="post" action="/gw/cmm/systemx/empChangePassPop.do" target="changPassPop">
  <input name="compNm" value="" type="hidden"/>
  <input name="deptNm" value="" type="hidden"/>
  <input name="loginId" value="" type="hidden"/>
  <input name="empNm" value="" type="hidden"/>
  <input name="dutyCodeNm" value="" type="hidden"/>
  <input name="positionCodeNm" value="" type="hidden"/>
  <input name="empSeq" value="" type="hidden"/>  
  <input name="compSeq" value="" type="hidden"/>
  <input name="deptSeq" value="" type="hidden"/>
</form>

<form id="empResignPop" name="empResignPop" method="post" action="/gw/cmm/systemx/empResignPop.do" target="empResignPop">
  <input name="compSeq" value="" type="hidden"/>
  <input name="compNm" value="" type="hidden"/>
  <input name="deptNm" value="" type="hidden"/>
  <input name="deptSeq" value="" type="hidden"/>
  <input name="groupSeq" value="" type="hidden"/>
  <input name="loginId" value="" type="hidden"/>
  <input name="empNm" value="" type="hidden"/>  
  <input name="dutyCodeNm" value="" type="hidden"/>
  <input name="positionCodeNm" value="" type="hidden"/>
  <input name="empSeq" value="" type="hidden"/>
</form>                         
