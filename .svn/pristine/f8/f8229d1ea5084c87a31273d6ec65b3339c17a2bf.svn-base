<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

	<!--jsTree css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/jsTree/style.min.css'/>">
  	<!--jsTree js-->
	<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js'/>"></script>

	<script type="text/javascript">
		var type = 10; //0:초기화,  10: 사업장, 20: 부서 신규, 21:부서 삭제, 30:사원입사, 31:사원정보수정, 32:사원퇴사, 33:사원휴직, 40:사원회사정보
		var syncCnt = 0;
	
		$(document).ready(function() {	
			
			<c:if test="${params.resultCode < 1}">
				<c:if test="${params.resultCode == -1}">
					alert('<%=BizboxAMessage.getMessage("TX900000214","연동된 정보가 없습니다.\\n연동정보를 확인하여 주세요.")%>');
				</c:if>
				window.close();
			</c:if>
			console.log(${params.loginIdType});
			// 동기화 아이디 셋팅
			<c:if test="${params.loginIdType == 1}">	// ERP 사원
				$("#idOptionValue").html("<%=BizboxAMessage.getMessage("TX000021941","※ ERP 사번이 그룹웨어 사용자 ID로 등록됩니다.")%>");
			</c:if>
			
			<c:if test="${params.loginIdType == 2}">	// Email 아이디
				$("#idOptionValue").html("<%=BizboxAMessage.getMessage("TX000021942","※ ERP Email ID가 그룹웨어 사용자 ID로 등록됩니다.")%>");
			</c:if>
			
			
			
			//탭
			$("#tabstrip").kendoTabStrip({
				animation:  {
					open: {
						effects: ""
					}
				}
			});
			
			//기본버튼
           $(".controll_btn button").kendoButton();
			
			$("#btnApplyOrg").on("click",function(e) {
				var message = chkFirstApply();
				
				
				var firstYn = $("#firstYn").val();
				if (firstYn == 'Y') {
					var firstMessage = '<%=BizboxAMessage.getMessage("TX000021943","그룹웨어 기존 조직도는 유지됩니다.\\n진행 하시겠습니까?")%>';
					if(!confirm(firstMessage)) {
						return;
					}
				}
				
				
				
				saveTempOrg();
				
				
			});
			
			$("#btnApplyEmp").on("click",function(e) {
				
				var listType = $("#orgListType").val();
				
				if (listType == 'erp') {
					alert('<%=BizboxAMessage.getMessage("TX000021944","조직도 연동 설정 완료 후\\n결과확인이 가능합니다.")%>');
				} else {
					var firstYn = $("#firstYn").val();
					if (firstYn == 'Y') {
						var firstMessage = '<%=BizboxAMessage.getMessage("TX000021943","그룹웨어 기존 조직도는 유지됩니다.\\n진행 하시겠습니까?")%>';
						if(!confirm(firstMessage)) {
							return;
						}
					}
					
					saveTempEmp();
				}
				
			});
			
			$("#btnSave").on("click",function(e) {
				
				var message = '<%=BizboxAMessage.getMessage("TX000021945","저장하시겠습니까?\\n(오류 항목은 반영되지 않습니다)")%>';
				if(confirm(message)) {
					 $("#page").val("1");
					 saveOrgchart();
				}
				
			});
			
			$("#btnSearch").on("click",function(e) {
				searchBtnClick();
			});
			
			$("#btnCancel").on("click",function(e) {
				fnclose();
			});			
			
			$("#btnNext").on("click",function(e) {
				
				var listType = $("#orgListType").val();
				
				if (listType == 'erp') {
					alert('<%=BizboxAMessage.getMessage("TX000021946","조직도 연동 설정 완료 후\\n 다음 Step으로 이동 가능 합니다.")%>');
					
				} else {
					var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");
					tabStrip.select(tabStrip.tabGroup.children("li").eq(1));
				
					$("#btnNext").hide();
				}
			});
		
			
			erpDeptManageTreeInit();
			deptManageTreeInit('<c:url value="/cmm/systemx/deptManageOrgChartListJT.do" />');
			
			
			getEmpList();
		 
		});
		
		function searchBtnClick(){
			$("#page").val("1");
			getEmpList();
		}
		
		
		
		function fnclose(){
			self.close();
		}			
		
		function checkAll(box) {
			$("input[name=noEmp]:checkbox").prop("checked", $(box).prop("checked"));
		}
		 
		function erpDeptManageTreeInit() {
			$("#erpOrgTreeView").attr('class','jstreeSet'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
			var compSeq = $("#compSeq").val() || '';
			var erpSyncTime = $("#erpSyncTime").val() || '';
			var orgListType = $("#orgListType").val() || '';
			var syncSeq = $("#syncSeq").val() || '';
			var firstYn = $("#firstYn").val() || '';
			var searchDept = '';
			var useYn = 'Y';
			
	        $('#erpOrgTreeView').jstree({ 
	        	'core' : { 
	        		'data' : {
	            		'url' : '<c:url value="/erp/orgchart/erpDeptOrgchartListJT.do" />',
	            		'cache' : false,
	            		'dataType': 'JSON',
		        			'data' : function (node) { 
		        				return {'firstYn':firstYn, 'syncSeq':syncSeq, 'orgListType' : orgListType, 'erpSyncTime' : erpSyncTime, 'parentSeq' : (node.id == "#" ? 0 : node.id), 'compSeq' : compSeq, 'searchDept' : searchDept, 'deptSeq' : '', 'includeDeptCode' : true, useYn : useYn};
		        			},
		        			'success' : function (n) {
		        				for(var i = 0; i < n.length; i++)
		        			    {
		        					n[i].li_attr['class'] = n[i].tIcon;	    
		        					n[i].resultCode = n[i].resultCode;	
		        			    }
		        				
		        			    return n;
		        			}
	        		},
	        		'animation' : false 
	        	}
	        })
	        .bind("loaded.jstree", function (event, data) {
	        	$(this).jstree("open_all");
			})
			.bind("select_node.jstree", function (event, data) {
				var cl = data.node.li_attr['class'];
				if(cl == 'text_red') {
					alert("<%=BizboxAMessage.getMessage("TX000006997","부서코드 중복")%>");
				} else if(cl == 'text_gray2') {
					alert("<%=BizboxAMessage.getMessage("TX000005964","사용안함")%>");
				}
			});
		}
		
		function deptManageTreeInit(url) {
			$("#orgTreeView").attr('class','jstreeSet'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
			var compSeq = $("#compSeq").val() || '';
			var erpSyncTime = $("#erpSyncTime").val() || '';
			var syncSeq = $("#syncSeq").val() || '';
			var searchDept = '';
			var useYn = 'Y';
			
	        $('#orgTreeView').jstree({ 
	        	'core' : { 
	        		'data' : {
	            		'url' : url,
	            		'cache' : false,
	            		'dataType': 'JSON',
		        			'data' : function (node) { 
		        				return {'syncSeq':syncSeq, 'erpSyncTime' : erpSyncTime, 'parentSeq' : (node.id == "#" ? 0 : node.id), 'compSeq' : compSeq, 'searchDept' : searchDept, 'deptSeq' : '', 'includeDeptCode' : true, useYn : useYn};
		        			},
		        			'success' : function (n) {
		        				//트리 클릭시 조회 로직을 타기 때문에 조회가 성공하면 검색조건 초기화
		        				setLiAttr(n[0]);		        				
		        			    return n;
		        			}
	        		},
	        		'animation' : false 
	        	}
	        })
	        .bind("loaded.jstree", function (event, data) {
	        	$(this).jstree("open_all");
			})
			.bind("select_node.jstree", function (event, data) {
			});
		}
		
		function setLiAttr(n){
			for(var i=0;i<n.children.length;i++){
				setLiAttr(n.children[i]);	
			}
			n.li_attr['class'] = n.tIcon;
			return;
		}
		
		function chkFirstApply() {
			var message = null;
			 $.ajax({
	 			type:"post",
	 			url:"erpSyncChkFirstApply.do",
	 			datatype:"json",
	 			async:false,
	 			data: {groupSeq:$("#groupSeq").val(),compSeq:$("#compSeq").val()},
	 			success:function(data){
	 				message = data.result;
	 				$("#firstYn").val(data.firstYn);
	 			},			
	 			error : function(e){
	 				alert("error");	
	 			}
	 		});	 
			 
			return message;
		}
		
		function goPreOrgSync() {
			var params = jQuery("#orgForm").serialize();
			NeosUtil.openWindow('erpSyncOrgchartTestPop.do?'+params, '810px', '800px', 'N');
		}
		
		function saveTempOrg() {
			$.ajax({
	 			type:"post",
	 			url:"erpSyncOrgchartTempSaveProc.do",
	 			datatype:"json",
	 			async:false,
	 			data: {groupSeq:$("#groupSeq").val(),compSeq:$("#compSeq").val(), erpSyncTime:$("#erpSyncTime").val(), firstYn:$("#firstYn").val()},
	 			success:function(data){
	 				var code = data.resultCode;
	 				if (code == '0') {
	 					
	 					var syncSeq = data.syncSeq;
	 					$("#syncSeq").val(syncSeq);
	 					$("#orgListType").val("temp");
	 					
	 					$('#orgTreeView').jstree("destroy").empty();
	 					deptManageTreeInit('<c:url value="/erp/orgchart/erpTempDeptOrgchartListJT.do" />'); 
	 					
	 					// 결과 그리기..
	 					$('#erpOrgTreeView').jstree("destroy").empty();
	 					erpDeptManageTreeInit();	 					
	 					alert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>');
	 					$("#btnApplyOrg").hide();
	 				}
	 			},			
	 			error : function(e){
	 				alert("saveTempOrg error");	
	 			}
	 		});	
		}
		
		function fn_list(currentPage){	
		   $("#page").val(currentPage);
		   getEmpList();
		}
		
		function getEmpList() {
  			$("#uploadSpin").show();
			
  			var data = jQuery("#orgForm").serialize();
  			
			$.ajax({ 
	 			type:"post",
	 			url:"erpSyncEmpList.do",
	 			datatype:"json",
	 			data: data,
	 			success:function(data){
	 				$("#divEmpList").html(data);
	 				$("#uploadSpin").hide();
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 				alert("getEmpList error");	
	 			}
	 		});	
		}
		
		function saveTempEmp() {
  			$("#uploadSpin").show();
  			
  			// 일부 선택 결과보기
  			setNoEmpList();
			
  			var data = jQuery("#orgForm").serialize();
  			
			$.ajax({ 
	 			type:"post",
	 			url:"erpSyncEmpTempSaveProc.do",
	 			datatype:"json",
	 			data: data,
	 			success:function(data){
	 				if(data.resultCode == null || data.resultCode == '') {
	 					alert("data.resultCode : " + data.resultCode);
	 					$("#uploadSpin").hide();
	 				} else if(data.resultCode == '0') {
	 					
	 					$("#page").val(parseInt($("#page").val())+1);
	 					
	 					saveTempEmp();
	 					
	 				} else if(data.resultCode == '99') {
	 					$("#listType").val("temp");
	 					$("#uploadSpin").hide();
	 					alert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>');
	 					$("#btnApplyEmp").hide();
	 					
	 					if("${params.erpType}" == "iu"){
		 					$("#dtCdIncom").remove();
		 					$("#ddCdIncom").remove();	
		 					setErpStateDDL();
	 					}
	 					$("#page").val("1");
	 					getEmpList();
	 					$("#btnSave").show();	 					
	 				} else {
	 					$("#uploadSpin").hide();
	 				}
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 				alert("saveTempEmp error");	
	 			}
	 		});	
		}
		
		
		function setErpStateDDL(){
			var innerHtml = "";
			innerHtml += '<dt id="dtErrCode"><%=BizboxAMessage.getMessage("TX900000216","오류상세")%></dt>';
			innerHtml += '<dd id="ddErrCode">';
			innerHtml += '<select class="kendoComboBox" id="erpErrCode" name="erpErrCode" style="width: 115px" onchange="searchBtnClick();">';
			innerHtml += '<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>';
			innerHtml += '<option value="0"><%=BizboxAMessage.getMessage("TX900000217","정상(입사+변경+퇴사)")%></option>';
			innerHtml += '<option value="1"><%=BizboxAMessage.getMessage("TX000021938","입사")%></option>';
			innerHtml += '<option value="2"><%=BizboxAMessage.getMessage("TX000003226","변경")%></option>';
			innerHtml += '<option value="3"><%=BizboxAMessage.getMessage("TX000021243","퇴직")%></option>';
			innerHtml += '<option value="4"><%=BizboxAMessage.getMessage("TX000006506","오류")%></option>';
			innerHtml += '</select>';
			innerHtml += '</dd>';
			$("#dlTag1").prepend(innerHtml) ;
		}
		
		// 임시 저장 데이터 그룹웨어 실제 반영
		function saveOrgchart() {
			$("#uploadSpin").show();
			
  			var data = jQuery("#orgForm").serialize();
  			data +="&type="+type;		// 1: 사업장, 2: 부서, 3:사원
			$.ajax({ 
	 			type:"post",
	 			url:"erpSyncOrgchartSaveProc.do",
	 			datatype:"json",
	 			data: data,
	 			success:function(data){
	 				if(data.resultCode == null || data.resultCode == '') {
	 					alert("data.resultCode : " + data.resultCode);
	 					$("#uploadSpin").hide();
	 				} else if(data.resultCode == '0') {
	 					
	 					if (type == '10') {
		 					$("#deptJoinTotalCount").val(data.deptJoinTotalCount||'0');
		 					$("#deptJoinCnt").val(data.deptJoinTotalCount||'0');
		 					$("#deptModifyTotalCount").val(data.deptModifyTotalCount||'0');
		 					$("#deptModifyCnt").val(data.deptModifyTotalCount||'0');
		 					$("#empJoinTotalCount").val(data.empJoinTotalCount||'0');
		 					$("#empJoinCnt").val(data.empJoinTotalCount||'0');
		 					$("#empModifyTotalCount").val(data.empModifyTotalCount||'0');
		 					$("#empModifyCnt").val(data.empModifyTotalCount||'0');
		 					$("#empResignTotalCount").val(data.empResignTotalCount||'0');
		 					$("#empResignCnt").val(data.empResignTotalCount||'0');
	 					}
	 					
	 					var moreYn = data.moreYn;
	 					
	 					if(moreYn == 'N' && type != 40) {
	 						setSaveType();
	 						$("#page").val("1");
	 					} else if(moreYn == 'N' && type == 40 && syncCnt == 0) {
	 						//erp 직급/직책 동기화처리
	 						syncCnt++;
	 						setErpDutyPosiInfo();
	 						
	 					}
	 					
	 					else {
	 						$("#page").val(parseInt($("#page").val())+1);
	 					}
	 					
	 					if(moreYn != 'N' || type < 50) {
	 						saveOrgchart();
	 					} else {
	 						// alert("");
	 					}
	 					
	 				} else if(data.resultCode == '99') {
	 					$("#uploadSpin").hide();
	 					alert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>');
	 					self.close();
						if(opener != null && opener.firstList != null){
							opener.firstList();
						}
	 				} else {
	 					$("#uploadSpin").hide();
	 				}
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 				self.close();
					if(opener != null && opener.firstList != null){
						opener.firstList();
					}	
	 			}
	 		});	
		}
		
		
		
		// 임시 저장 데이터 그룹웨어 실제 반영
		function saveOrgchart222() {
			
			var tblParam = {};
			tblParam.groupSeq = $("#groupSeq").val();
			tblParam.syncSeq = $("#syncSeq").val();
			tblParam.compSeq = $("#compSeq").val();
			tblParam.langCode = "kr";  //동기화시 기본 언어는 한글로 고정
			tblParam.syncStatus = "R";
			tblParam.autoYn = "Y";
						
			$.ajax({ 
	 			type:"post",
	 			url:"erpOrgchartSyncStart.do",
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 				self.close();
					if(opener != null && opener.firstList != null){
						opener.firstList();
					}	
	 			}
	 		});	
		}
		
		
		function setErpDutyPosiInfo(){
			
			var tblParam = {};
			tblParam.compSeq = $("#compSeq").val();
			tblParam.groupSeq = $("#groupSeq").val();
			
			$.ajax({ 
	 			type:"post",
	 			url:"erpSyncDutyPosiSaveProc.do",
	 			datatype:"json",
	 			data: tblParam,
	 			success:function(data){
	 				if(data.resultCode == "0"){
		 				$("#uploadSpin").hide();						
						alert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>');
						self.close();
						if(opener != null && opener.firstList != null){
							opener.firstList();
						}					
						return;
	 				}else{
	 					$("#uploadSpin").hide();
	 				}
	 			},			
	 			error : function(e){ 
	 				$("#uploadSpin").hide();
	 			}
	 		});
		}
		
		
		//0:초기화,  10: 사업장, 20: 부서 신규, 21:부서 삭제, 30:사원입사, 31:사원정보수정, 32:사원퇴사, 33:사원휴직, 40:사원회사정보
		function setSaveType() {
			switch(type) {
				case 0: type=10; 	break;
				case 10: type=20;	break;
				case 20: type=21;	break;
				case 21: type=22;	break;
				case 22: type=30;	break;
				case 30: type=31;	break;
				case 31: type=32;	break;
				case 32: type=33;	break;
				case 33: type=40;	break;
				case 40: type=50;	break;
				default: type=50; 	break;
			}
		}
		
		function  setNoEmpList(){
			var list = $("input[name=noEmp]:checked");
			var noEmpList = "";
			for(var i = 0; i < list.length; i++) {
				noEmpList += "'"+list[i].value+"'";
				if(i < list.length-1) {
					noEmpList +=",";
				}
			}
			$("#noEmpList").val(noEmpList);
		}
		
		function fnResign(erpEmpSeq, compSeq) {
			var param = {};
			param.erpEmpSeq = erpEmpSeq;
			param.compSeq = compSeq;
			
			$.ajax({
				type:"post",
	 			url:"selectErpSyncResignParam.do",
	 			datatype:"json",
	 			data: param,
	 			success:function(result){
	 				//console.log(JSON.stringify(result));
	 				var resignParam = result.resignParam;
		  	    	
		  	    	var compNm = resignParam.compName;
					var compSeq = resignParam.compSeq;
					var deptNm = resignParam.deptName;
					var deptSeq = resignParam.deptSeq;
					var loginId = resignParam.loginId;
					var empNm = resignParam.empName;
					var dutyCodeNm = resignParam.deptDutyCodeName;
					var positionCodeNm = resignParam.deptPositionCodeName;
					var empSeq = resignParam.empSeq;
					var groupSeq = resignParam.groupSeq;
					
					window.open("", "empResignPop", "width=950,height=581,scrollbars=yes") ;		         
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
	 			},			
	 			error : function(e){ 
	 				console.log("resign popup param error");	
	 			}
			});
			
		}
	</script>
	
	<form id="orgForm" name="orgForm">
		<input type="hidden" id="page" name="page" value="1" />
		<input type="hidden" id="orgListType" name="orgListType" value="erp" />
		<input type="hidden" id="listType" name="listType" value="erp" />
		<input type="hidden" id="groupSeq" name="groupSeq" value="${params.groupSeq}" />
		<input type="hidden" id="compSeq" name="compSeq" value="${params.compSeq}" />
		<input type="hidden" id="erpSyncTime" name="erpSyncTime" value="${params.erpSyncTime}" />
		<input type="hidden" id="syncSeq" name="syncSeq" value="${params.syncSeq}" />
		<input type="hidden" id="loginIdType" name="loginIdType" value="${params.loginIdType}" />
		<input type="hidden" id="startSyncTime" name="startSyncTime" value="${params.startSyncTime}" />
		<input type="hidden" id="endSyncTime" name="endSyncTime" value="${params.endSyncTime}" />
		<input type="hidden" id="firstYn" name="firstYn" value="${params.firstYn}" />
		<input type="hidden" id="deptJoinTotalCount" name="deptJoinTotalCount" value="0" />
		<input type="hidden" id="deptModifyTotalCount" name="deptModifyTotalCount" value="0" />
		<input type="hidden" id="empJoinTotalCount" name="empJoinTotalCount" value="0" />
		<input type="hidden" id="empModifyTotalCount" name="empModifyTotalCount" value="0" />
		<input type="hidden" id="empResignTotalCount" name="empResignTotalCount" value="0" />
		<input type="hidden" id="deptJoinCnt" name="deptJoinCnt" value="0" />
		<input type="hidden" id="deptModifyCnt" name="deptModifyCnt" value="0" />
		<input type="hidden" id="empJoinCnt" name="empJoinCnt" value="0" />
		<input type="hidden" id="empResignCnt" name="empResignCnt" value="0" />
		<input type="hidden" id="empModifyCnt" name="empModifyCnt" value="0" />
		
		<input type="hidden" id="noEmpList" name="noEmpList" value="" />
	
	<div class="pop_wrap" style="width:900px;height:780px">  
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000018163","ERP조직도연동설정")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		</div>	
			
		<div class="pop_con">
			<div class="tab_set">
				<div class="tab_style" id="tabstrip">
					<!-- tab -->
					<ul>
						<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000018203","ERP 조직도 연동")%></li>
						<li ><%=BizboxAMessage.getMessage("TX000007171","ERP 사원 연동")%></li>
					</ul>
					
					<!-- ERP조직도연동 -->
					<div class="tab1 p15 pt0 ovh">
						<div class="fl mt10" style="width:413px;">
							<div class="trans_top_btn mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li">ERP</li>
									</ul>
								</div>
							</div>
							<div class="box_div p0">
								<div id="erpOrgTreeView" class="jstreeSet" style="height:539px;"></div>
							</div>
						</div>
						<div class="fl mt10 ml10" style="width:413px;">
							<div class="trans_top_btn mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li"><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></li>
									</ul>
									<div id="" class="controll_btn" style="padding:0px;float:right;">
										<button id="btnApplyOrg" type="button"><%=BizboxAMessage.getMessage("TX000021947","결과확인")%></button>
									</div>
								</div>
							</div>
							<div class="box_div p0">
								<div id="orgTreeView" class="jstreeSet" style="height:539px;"></div>
							</div>
						</div>
					</div>
					
					<!-- ERP사원연동 -->
					<div class="tab4 ovh">
						<div class="btn_div m0 pt10 pb10 pl15 pr15 borderB">
							<div class="left_div">
								<div class="trans_top_btn">
									<div class="option_top">
										<ul>
											<li class="text_blue" id="idOptionValue"></li>
										</ul>
									</div>
								</div>
							</div>
							<div class="right_div">
								<div id="" class="controll_btn p0">
									<button id="btnApplyEmp" type="button" ><%=BizboxAMessage.getMessage("TX000021947","결과확인")%></button>
								</div>
							</div>
						</div>
						
						<div id="" class="pl15 pr15 pb15 clear"  style="min-height:539px;">
							<div style="position:fixed;top:60%;left:47%;"><div id="uploadSpin" style="display:none;"><strong class="k-upload-status k-upload-status-total" ><spna id="uploadSts"></spna>Loading...<span class="k-icon k-loading"></span></strong></div></div>
							<div class="trans_top_btn mt10 mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li"><%=BizboxAMessage.getMessage("TX000006105","ERP사원")%></li>
									</ul>
								</div>
							</div>
							<div class="top_box pr10 mb10">
								<dl id="dlTag1">
									<c:if test="${params.erpType == 'iu'}">
									<dt id="dtCdIncom"><%=BizboxAMessage.getMessage("TX000003300","재직구분")%></dt>
									<dd id="ddCdIncom">									
										<select class="kendoComboBox" id="cdIncom" name="cdIncom" style="width: 100px" onchange="searchBtnClick();">
											<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
											<option value="001"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
											<option value="002"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
											<option value="099"><%=BizboxAMessage.getMessage("TX000021243","퇴직")%></option>
										</select>
									</dd>
									</c:if>
									<dt><%=BizboxAMessage.getMessage("TX000000068","부서명")%></dt>
									<dd><input id="deptName" name="deptName" type="text" style="width:150px;" value="" onkeydown="if(event.keyCode==13){javascript:searchBtnClick();}"/></dd>
									<dt><%=BizboxAMessage.getMessage("TX000000076","사원명")%></dt>
									<dd><input id="empName" name="empName" type="text" style="width:150px;" value="" onkeydown="if(event.keyCode==13){javascript:searchBtnClick();}"/></dd>
									<dd><input type="button" id="btnSearch" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd> 
								</dl>
								
							</div> 							
							<div id="divEmpList" style="">
							
							</div>
							
						</div>
					</div>
		
				</div><!--// tab_style -->
			</div><!--// tab_set -->
		</div><!--// pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="" id="btnNext" value="<%=BizboxAMessage.getMessage("TX000003164","다음")%>" />
				<input type="button" class="gray_btn" id="btnCancel" value="<%=BizboxAMessage.getMessage("TX000019660","취소")%>" />
				<input type="button" style="display:none;" class="" id="btnSave" value="<%=BizboxAMessage.getMessage("TX000001288","완료")%>" />
			</div>
		</div><!-- //pop_foot -->
	</div><!--// pop_wrap -->
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