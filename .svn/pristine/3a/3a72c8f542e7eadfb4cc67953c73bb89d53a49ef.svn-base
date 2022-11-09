<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@page import="main.web.BizboxAMessage"%>

<!--jsTree css-->
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/jsTree/style.min.css'/>">
<!--jsTree js-->
<script type="text/javascript"
	src="<c:url value='/js/jsTree/jstree.min.js'/>"></script>

<script type="text/javascript">
		var type = 10; //0:초기화,  10: 사업장, 20: 부서 신규, 21:부서 삭제, 30:사원입사, 31:사원정보수정, 32:사원퇴사, 33:사원휴직, 40:사원회사정보
// 		var groupSeq = "${params.groupSeq}";
// 		var compSeq = "${params.compSeq}";
// 		var syncSeq = "${params.syncSeq}";
	
		$(document).ready(function() {	
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
					var firstMessage = '<%=BizboxAMessage.getMessage("TX900000373", "그룹웨어 기존 조직도 는 삭제됩니다.\\n진행 하시겠습니까?")%>';
					if(!confirm(firstMessage)) {
						return;
					}
				}
				
				saveTempOrg();
				
			});
			
			$("#btnApplyEmp").on("click",function(e) {
				
				var listType = $("#orgListType").val();

 				$("#listType").val("temp");
 				
				if (listType == 'erp') {
					alert('<%=BizboxAMessage.getMessage("TX000021944", "조직도 연동 설정 완료 후\\n결과확인이 가능합니다.")%>');
				} else {
					var firstYn = $("#firstYn").val();
					if (firstYn == 'Y') {
						var firstMessage = '<%=BizboxAMessage.getMessage("TX900000373", "그룹웨어 기존 조직도 는 삭제됩니다.\\n진행 하시겠습니까?")%>';
						if(!confirm(firstMessage)) {
							return;
						}
					}
					
					saveTempEmp();
				}
				
			});
			
			$("#btnSave").on("click",function(e) {
				
				var message = '<%=BizboxAMessage.getMessage("TX000021945", "저장하시겠습니까?\\n(오류 항목은 반영되지 않습니다)")%>';
				if(confirm(message)) {
					 $("#page").val("1");
					 saveOrgchart();
				}
				
			});
			
			$("#btnSearch").on("click",function(e) {
				getEmpList();
				
			});
			
			$("#btnCancel").on("click",function(e) {
				fnclose();
			});			
			
			$("#btnNext").on("click",function(e) {
				
				var listType = $("#orgListType").val();
				
				if (listType == 'erp') {
					alert('<%=BizboxAMessage.getMessage("TX000021946", "조직도 연동 설정 완료 후\\n 다음 Step으로 이동 가능 합니다.")%>');
					
				} else {
					var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");
					tabStrip.select(tabStrip.tabGroup.children("li").eq(1));
				
					$("#btnNext").hide();
				}
			});
			
			activeDirectoryDeptManageTreeInit();
			deptManageTreeInit('<c:url value="/cmm/systemx/deptManageOrgChartListJT.do" />');
			
			
			//getEmpList();
		 
		});
		
		function fnclose(){
			self.close();
		}			
		
		function checkAll(box) {
			$("input[name=noEmp]:checkbox").prop("checked", $(box).prop("checked"));
		}
		 
		function activeDirectoryDeptManageTreeInit() {
			$("#erpOrgTreeView").attr('class','jstreeSet'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
			var groupSeq = $("#groupSeq").val() || '';
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
	            		'url' : '<c:url value="/activeDirectory/orgchart/activeDirectoryDeptOrgchartListJT.do" />',
	            		//'url' : '<c:url value="/cmm/systemx/orgChartListJT.do" />',
	            		'cache' : false,
	            		'dataType': 'JSON',
		        			'data' : function (node) { 
		        				return {'firstYn':firstYn, 'syncSeq':syncSeq, 'orgListType' : orgListType, 'erpSyncTime' : erpSyncTime, 'parentSeq' : (node.id == "#" ? 0 : node.id), 'compSeq' : compSeq, 'searchDept' : searchDept, 'deptSeq' : '', 'includeDeptCode' : true, useYn : useYn};
		        				//return {'parentSeq' : (node.id == "#" ? 0 : node.id)}
		        			},
		        			'success' : function (n) {
		        				//트리 클릭시 조회 로직을 타기 때문에 조회가 성공하면 검색조건 초기화
		        				// $("#hidSearchDept").val('');
		        				//console.log(n);
		        				for(var i = 0; i < n.length; i++)
		        			    {
		        					n[i].li_attr['class'] = n[i].tIcon;	    
		        					n[i].resultCode = n[i].resultCode;	
		        			    }
		        				
		        				// height가 0px 로 변경되는 문제로..
		        				//$("#erpOrgTreeView").css('height','539px');
		        				getEmpList();
		        			    return n;
		        			}
	        		},
	        		'animation' : false 
	        	}
	        })
	        .bind("loaded.jstree", function (event, data) {
				//console.log("loaded.jstree");
	        	// load후 처리될 event를 적어줍니다.
	        	//fnMyDeptInfo();
	
	        	$(this).jstree("open_all");
	        	//fnSetScrollToNode(varDeptSeq);
			})
			.bind("select_node.jstree", function (event, data) {
				// node가 select될때 처리될 event를 적어줍니다.​
				//var dataList = data.node.original;
				//var seq = OJT_fnGetCompensId(dataList.id);
				//var org = dataList.gbnOrg;
				//alert(JSON.stringify(dataList));			
				//getDeptInfo(seq, org);	
				//console.log(data);
				var cl = data.node.li_attr['class'];
				if(cl == 'text_red') {
					alert("부서 코드 중복");
				} else if(cl == 'text_gray2') {
					alert("부서 사용안함");
				}
			});
			/*
			.bind("open_node.jstree", function (event, data) {
				console.log("open_node.jstree");
				// node가 open 될때 처리될 event를 적어줍니다.​
			})
			.bind("dblclick.jstree", function (event) {
				console.log("dblclick.jstree");
				// node가 더블클릭 될때 처리될 event를 적어줍니다.​​
			});
			*/
		}
		
		function deptManageTreeInit(url) {
			$("#orgTreeView").attr('class','jstreeSet'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
			var compSeq = $("#compSeq").val() || '';
			var erpSyncTime = $("#erpSyncTime").val() || '';
			var syncSeq = $("#syncSeq").val() || '';
			var searchDept = '';
			var useYn = 'Y';
			
			console.log("compSeq : " + compSeq + ", syncSeq : " + syncSeq + ", ");
			
	        $('#orgTreeView').jstree({ 
	        	'core' : { 
	        		'data' : {
	            		'url' : url,
	            		//'url' : '<c:url value="/cmm/systemx/orgChartListJT.do" />',
	            		'cache' : false,
	            		'dataType': 'JSON',
		        			'data' : function (node) { 
		        				return {'syncSeq':syncSeq, 'erpSyncTime' : erpSyncTime, 'parentSeq' : (node.id == "#" ? 0 : node.id), 'compSeq' : compSeq, 'searchDept' : searchDept, 'deptSeq' : '', 'includeDeptCode' : true, useYn : useYn};
		        				//return {'parentSeq' : (node.id == "#" ? 0 : node.id)}
		        			},
		        			'success' : function (n) {
		        				//트리 클릭시 조회 로직을 타기 때문에 조회가 성공하면 검색조건 초기화
		        				// $("#hidSearchDept").val('');
		        				
		        				for(var i = 0; i < n.length; i++)
		        			    {
		        					n[i].li_attr['class'] = n[i].tIcon;	        					
		        			    }
		        				
		        				// height가 0px 로 변경되는 문제로..
		        				//$("#orgTreeView").css('height','539px');
		        				
		        			    return n;
		        			}
	        		},
	        		'animation' : false 
	        	}
	        })
	        .bind("loaded.jstree", function (event, data) {
				//console.log("loaded.jstree");
	        	// load후 처리될 event를 적어줍니다.
	        	//fnMyDeptInfo();
	
	        	$(this).jstree("open_all");
	        	
	        	//fnSetScrollToNode(varDeptSeq);
			})
			.bind("select_node.jstree", function (event, data) {
				// node가 select될때 처리될 event를 적어줍니다.​
				//var dataList = data.node.original;
				//var seq = OJT_fnGetCompensId(dataList.id);
				//var org = dataList.gbnOrg;
				//alert(JSON.stringify(dataList));			
				//getDeptInfo(seq, org);			
			});
			/*
			.bind("open_node.jstree", function (event, data) {
				console.log("open_node.jstree");
				// node가 open 될때 처리될 event를 적어줍니다.​
			})
			.bind("dblclick.jstree", function (event) {
				console.log("dblclick.jstree");
				// node가 더블클릭 될때 처리될 event를 적어줍니다.​​
			});
			*/
		}
		
		function chkFirstApply() {
			var message = null;
			 $.ajax({
	 			type:"post",
	 			url:"activeDirectorySyncChkFirstApply.do",
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
			
			//openWindow(url,  width, height, strScroll )
			NeosUtil.openWindow('erpSyncOrgchartTestPop.do?'+params, '810px', '800px', 'N');
		}
		
		function saveTempOrg() {
			$.ajax({
	 			type:"post",
	 			url:"activeDirectorySyncOrgchartTempSaveProc.do",
	 			datatype:"json",
	 			async:false,
	 			data: {groupSeq:$("#groupSeq").val(),compSeq:$("#compSeq").val(), erpSyncTime:$("#erpSyncTime").val(), firstYn:$("#firstYn").val(), syncSeq:$("#syncSeq").val()},
	 			success:function(data){
	 				var code = data.resultCode;
	 				if (code == '0') {
	 					
	 					var syncSeq = data.syncSeq;
	 					$("#syncSeq").val(syncSeq);
	 					$("#orgListType").val("temp");
	 					
	 					$('#orgTreeView').jstree("destroy").empty();
	 					deptManageTreeInit('<c:url value="/activeDirectory/orgchart/activeDirectoryTempDeptOrgchartListJT.do" />'); 
	 					
	 					// 결과 그리기..
	 					$('#erpOrgTreeView').jstree("destroy").empty();
	 					activeDirectoryDeptManageTreeInit();
	 					alert('<%=BizboxAMessage.getMessage("TX000022275", "저장 되었습니다.")%>');
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
	 			url:"activeDirectoryEmpList.do",
	 			datatype:"json",
	 			async:"false",
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
	 			url:"activeDirectoryEmpList.do",
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
	 					alert('<%=BizboxAMessage.getMessage("TX000022275", "저장 되었습니다.")%>');
	 					$("#page").val("1");
	 					$("#tempEmpResult").val("Y");
	 					getEmpList();
	 					
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
		
		// 임시 저장 데이터 그룹웨어 실제 반영
		function saveOrgchart() {
			$("#uploadSpin").show();
			
  			var data = jQuery("#orgForm").serialize();
  			data +="&type="+type;		// 1: 사업장, 2: 부서, 3:사원
			$.ajax({ 
	 			type:"post",
	 			url:"activeDirectorySyncOrgchartSaveProc.do",
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
	 					} else if(moreYn == 'N' && type == 40) {
	 						$("#uploadSpin").hide();
	 						
	 						alert('<%=BizboxAMessage.getMessage("TX000022275", "저장 되었습니다.")%>');
	 						self.close();
	 						if(opener != null && opener.firstList != null){
	 							opener.firstList();
	 						}
	 						
	 						return;
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
	 					alert('<%=BizboxAMessage.getMessage("TX000022275", "저장 되었습니다.")%>');
						} else {
							$("#uploadSpin").hide();
						}
					},
					error : function(e) {
						$("#uploadSpin").hide();
						alert("saveOrgchart error");
					}
				});
	}

	//0:초기화,  10: 사업장, 20: 부서 신규, 21:부서 삭제, 30:사원입사, 31:사원정보수정, 32:사원퇴사, 33:사원휴직, 40:사원회사정보
	function setSaveType() {
		switch (type) {
		case 0:
			type = 10;
			break;
		case 10:
			type = 20;
			break;
		case 20:
			type = 21;
			break;
		case 21:
			type = 22;
			break;	
 		case 22:
			type = 30;
			break;
		case 30:
			type = 31;
			break;
		case 31:
			type = 32;
			break;
		case 32:
			type = 40;
			break;	
		case 40:
			type = 50;
			break;

// 		case 30:
// 			type = 31;
// 			break;
// 		case 31:
// 			type = 40;
// 			break;
// 		case 40:
// 			type = 50;
// 			break;
		default:
			type = 50;
			break;
		}
	}

	function setNoEmpList() {
		var list = $("input[name=noEmp]:checked");
		var noEmpList = "";
		for (var i = 0; i < list.length; i++) {
			noEmpList += "'" + list[i].value + "'";
			if (i < list.length - 1) {
				noEmpList += ",";
			}
		}
		$("#noEmpList").val(noEmpList);
	}

	function fnResign(erpEmpSeq) {
		var param = {};
		param.erpEmpSeq = erpEmpSeq;

		$.ajax({
			type : "post",
			url : "selectErpSyncResignParam.do",
			datatype : "json",
			data : param,
			success : function(result) {
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
				var param = "compSeq=" + compSeq + "&compNm=" + compNm
						+ "&deptNm=" + deptNm + "&deptSeq=" + deptSeq
						+ "&groupSeq=" + groupSeq + "&loginId=" + loginId
						+ "&empNm=" + empNm + "&dutyCodeNm=" + dutyCodeNm
						+ "&positionCodeNm=" + positionCodeNm + "&empSeq="
						+ empSeq;
				var url = "<c:url value='/cmm/systemx/empResignPop.do?'/>"
						+ param

				var pop = window.open(url, "empResignPop",
						"width=950,height=581,scrollbars=yes");
				pop.focus();
			},
			error : function(e) {
				console.log("resign popup param error");
			}
		});

	}
</script>

<form id="orgForm" name="orgForm">
	<input type="hidden" id="page" name="page" value="1" /> <input
		type="hidden" id="orgListType" name="orgListType" value="erp" /> <input
		type="hidden" id="listType" name="listType" value="erp" />
<%-- 	
		<input type="hidden" id="groupSeq" name="groupSeq" value="${params.groupSeq}" />
		<input type="hidden" id="compSeq" name="compSeq" value="${params.compSeq}" />
		<input type="hidden" id="erpSyncTime" name="erpSyncTime" value="${params.erpSyncTime}" />
		<input type="hidden" id="syncSeq" name="syncSeq" value="${params.syncSeq}" />
		<input type="hidden" id="startSyncTime" name="startSyncTime" value="${params.startSyncTime}" />
		<input type="hidden" id="endSyncTime" name="endSyncTime" value="${params.endSyncTime}" />
		<input type="hidden" id="firstYn" name="firstYn" value="${params.firstYn}" />
--%>

		<input type="hidden" id="groupSeq" name="groupSeq" value="${params.groupSeq}" />
		<input type="hidden" id="compSeq" name="compSeq" value="${params.compSeq}" />
		<input type="hidden" id="syncSeq" name="syncSeq" value="${params.syncSeq}" />
		
		<input type="hidden" id="erpSyncTime" name="erpSyncTime" value="" />
		<input type="hidden" id="startSyncTime" name="startSyncTime" value="2017-08-25 17:16:27" />
		<input type="hidden" id="endSyncTime" name="endSyncTime" value="2017-08-28 22:29:33" />
		<input type="hidden" id="firstYn" name="firstYn" value="Y" />
		<input type="hidden" id="tempEmpResult" name="tempEmpResult" value="N" />

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

	<div class="pop_wrap" style="width: 900px; height: 780px">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX900000374","AD Data 연동 설정")%></h1>
			<a href="#n" class="clo"><img
				src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		</div>

		<div class="pop_con">
			<div class="tab_set">
				<div class="tab_style" id="tabstrip">
					<!-- tab -->
					<ul>
						<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000007170","ERP 조직도 연동")%></li>
						<li><%=BizboxAMessage.getMessage("TX000007171","ERP 사원 연동")%></li>
					</ul>

					<!-- ERP조직도연동 -->
					<div class="tab1 p15 pt0 ovh">
						<div class="fl mt10" style="width: 413px;">
							<div class="trans_top_btn mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li"><%=BizboxAMessage.getMessage("TX900000375","ERP 조직도")%></li>
									</ul>
								</div>
							</div>
							<div class="box_div p0">
								<div id="erpOrgTreeView" class="jstreeSet"
									style="height: 539px;"></div>
							</div>
						</div>
						<div class="fl mt10 ml10" style="width: 413px;">
							<div class="trans_top_btn mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li"><%=BizboxAMessage.getMessage("TX900000376","그룹웨어 조직도")%></li>
									</ul>
									<div id="" class="controll_btn"
										style="padding: 0px; float: right;">
										<button id="btnApplyOrg" type="button"><%=BizboxAMessage.getMessage("TX000021947","결과확인")%></button>
									</div>
								</div>
							</div>
							<div class="box_div p0">
								<!--
									ERP조직도에 연동된 경우 text_blue 클래스를 사용하여 색상을 표시해줍니다.
									퍼블리싱 된 트리참조.
									-->
								<div id="orgTreeView" class="jstreeSet" style="height: 539px;"></div>
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
									<button id="btnApplyEmp" type="button"><%=BizboxAMessage.getMessage("TX000021947","결과확인")%></button>
									<!-- <button id="">반영</button> -->
								</div>
							</div>
						</div>

						<div id="" class="pl15 pr15 pb15 clear" style="min-height: 539px;">

							<div class="trans_top_btn mt10 mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li"><%=BizboxAMessage.getMessage("TX900000377","ERP 사원목록")%></li>
									</ul>
								</div>
							</div>
							<div class="top_box pr10 mb10">
								<dl>
									<dt><%=BizboxAMessage.getMessage("TX000000068","부서명")%></dt>
									<dd>
										<input id="deptName" name="deptName" type="text"
											style="width: 150px;" value=""
											onkeydown="if(event.keyCode==13){javascript:getEmpList();}" />
									</dd>
									<dt><%=BizboxAMessage.getMessage("TX000000076","사원명")%></dt>
									<dd>
										<input id="empName" name="empName" type="text"
											style="width: 150px;" value=""
											onkeydown="if(event.keyCode==13){javascript:getEmpList();}" />
									</dd>
									<dd>
										<input type="button" id="btnSearch" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
									</dd>
								</dl>
								<div id="uploadSpin"
									style="position: relative; display: none; left: 350px; top: 300px;">
									<strong class="k-upload-status k-upload-status-total"><spna
											id="uploadSts"></spna>Loading...<span
										class="k-icon k-loading"></span></strong>
								</div>
							</div>

							<div id="divEmpList" style=""></div>

						</div>
					</div>

				</div>
				<!--// tab_style -->
			</div>
			<!--// tab_set -->
		</div>
		<!--// pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="" id="btnNext" value="<%=BizboxAMessage.getMessage("TX000003164","다음")%>" /> <input
					type="button" class="gray_btn" id="btnCancel" value="<%=BizboxAMessage.getMessage("TX000019660","취소")%>" /> <input
					type="button" class="" id="btnSave" value="<%=BizboxAMessage.getMessage("TX000001288","완료")%>" />
			</div>
		</div>
		<!-- //pop_foot -->
	</div>
	<!--// pop_wrap -->
</form>