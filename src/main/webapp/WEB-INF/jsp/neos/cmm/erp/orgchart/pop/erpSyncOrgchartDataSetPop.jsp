<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>


   <!--css-->
	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="/gw/js/Scripts/jqueryui/jquery-ui.css"/>
    	<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="/gw/js/pudd/Script/pudd/pudd-1.1.189.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/common.js"></script>

 <script type="text/javascript">
 	var loadingbarFlag1 = false;
 	var loadingbarFlag2 = false;
 	var loadingbarFlag3 = false;	//트리뷰+그리드 로딩바 시작~종료시 사용변수
 	
 	var erpIuPositionSet = "";
 	var erpIuDutySet = "";			//직급,직책 설정값 저장 변수
 	
 	var gwLicenseCount = 0;
 	var mailLicenseCount = 0;		//추가 라이센스 카운트 변수
 	var gwResignCount = 0;
 	
 	var licenseInfo;
 
 	var type = 10; //0:초기화,  10: 사업장, 20: 부서 신규, 21:부서 삭제, 30:사원입사, 31:사원정보수정, 32:사원퇴사, 33:사원휴직, 40:사원회사정보
 	var syncCnt = 0;
 	
 	var resignEmpCnt = 0;
 	var resignEmpList = [];
 	
 	var erpEmpCnt = 0;
 	
    $(document).ready(function() {
    	
		// 동기화 아이디 셋팅
		<c:if test="${params.loginIdType == 1}">	// ERP 사원
			$("#idOptionValue").html("<span class='text_blue'>ERP <%=BizboxAMessage.getMessage("","사번")%></span><%=BizboxAMessage.getMessage("","이 그룹웨어 사용자 ID로 등록됩니다.")%>");
		</c:if>
		
		<c:if test="${params.loginIdType == 2}">	// Email 아이디
			$("#idOptionValue").html("<span class='text_blue'>ERP Email-ID</span><%=BizboxAMessage.getMessage("","가 그룹웨어 사용자 ID로 등록됩니다.")%>");
		</c:if>
		
		$("#btnEmpInit").attr("disabled",true);		//사원 초기화버튼 초기 미사용처리
		
		
		//----------버튼 이벤트 정의 start-------------
		
		//	취소버튼 클릭 이벤트
		$("#btnCancel").on("click",function(e) {
			setConfirm("<%=BizboxAMessage.getMessage("TX000002340","취소하시겠습니까?")%></br><%=BizboxAMessage.getMessage("","진행중인 데이터는 반영되지 않습니다.")%>","question", true, 0);
		});	
		$("#btnCancel2").on("click",function(e) {
			setConfirm("<%=BizboxAMessage.getMessage("TX000002340","취소하시겠습니까?")%></br><%=BizboxAMessage.getMessage("","진행중인 데이터는 반영되지 않습니다.")%>","question", true, 0);
		});
		
		//erp조직도 동기화 결과확인 버튼
		$("#btnApplyOrg").on("click",function(e) {			
			saveTempOrg();
		});
		
		//erp사원 동기화 결과확인 버튼
		$("#btnApplyEmp").on("click",function(e) {
			saveTempEmp();
		});
		
		
		//erp사원 초기화 버튼
		$("#btnEmpInit").on("click",function(e) {
			fnEmpInit();
		});
		
		//검색 버튼
		$("#btnSearch").on("click",function(e) {
			getEmpList();
		});
		
		//완료 버튼
		$("#btnSave").on("click",function(e) {	
			if($("#listType").val() == "erp"){
				setAlert("<%=BizboxAMessage.getMessage("","결과확인 후 사용자 반영이 가능합니다.")%>", "warning", false);
				return;
			}
			
			if(licenseInfo.realGwCount + gwLicenseCount > licenseInfo.totalGwCount || (licenseInfo.realMailCount + mailLicenseCount > (licenseInfo.totalMailCount + (licenseInfo.totalGwCount - licenseInfo.realGwCount + gwLicenseCount)))){
				var cnt1 = (licenseInfo.totalGwCount - licenseInfo.realGwCount) + (licenseInfo.totalMailCount - licenseInfo.realMailCount);	//잔여 라이선스
				if(cnt1 < 0){
					cnt1 = 0;
				}
				var cnt2 = gwLicenseCount + mailLicenseCount;	//대기라이선스 카운트
				setAlert("<%=BizboxAMessage.getMessage("","그룹웨어 라이선스 초과되어 조직도 연동 불가합니다.")%></br>[<span class='fwb'><%=BizboxAMessage.getMessage("","잔여 라이선스")%>:<span class='text_red'>" + cnt1 +"</span>, <%=BizboxAMessage.getMessage("","대기 사용자")%>:<span class='text_blue'>" + cnt2 + "</span></span>]", "warning", false);
				return
			}
			
			if(resignEmpCnt > 0){
				setAlert("<%=BizboxAMessage.getMessage("","퇴사자가 포함된 경우, 퇴사처리 완료 후 반영이 가능합니다.")%>", "warning", false);
			}else{			
				setConfirm("<%=BizboxAMessage.getMessage("","전체 사용자 모두 그룹웨어에 등록하시겠습니까?")%></br>(<%=BizboxAMessage.getMessage("","오류항목은 반영되지 않습니다.")%>)","question", false, 2);
			}
		});
		
		
		//선택반영 버튼
		$("#btnSave2").on("click",function(e) {	
			if($("#listType").val() == "erp"){
				setAlert("<%=BizboxAMessage.getMessage("","결과확인 후 사용자 반영이 가능합니다.")%>", "warning", false);
				return;
			}

			if(noEmpMap.keys().length == 0){
				setAlert("<%=BizboxAMessage.getMessage("","반영할 사용자를 선택해주세요.")%>", "warning", false);
				return;
			}
			
			setConfirm("<%=BizboxAMessage.getMessage("","선택한 사용자를 그룹웨어에 등록하시겠습니까?")%></br>(<%=BizboxAMessage.getMessage("","오류항목은 반영되지 않습니다.")%>)","question", false, 1);
		});		
		//----------버튼 이벤트 정의 end-------------
		
    	
		
		//----- 조직도시작------//
		setProgressBar(); //로딩바
		erpDeptManageTreeInit();
		deptManageTreeInit('<c:url value="/erp/orgchart/deptManageOrgChartListJT.do" />');
		//----- 조직도시작 끝------//
		
		
		//----- 사원시작------//		
		getEmpList();	//erp사용자 리스트 조회		
		getGwLicenseCnt();	//그룹웨어 라이센스 카운트 조회
		//----- 사원시작------//		
		
		
	});//-----// $(document).ready 끝

	function bsNext(th){

		if ($(th).parent().parent().hasClass("bs_foot1"))
		{
			if($("#orgListType").val() == "erp"){
				setAlert("<%=BizboxAMessage.getMessage("","조직도 연동 설정 완료 후 다음 Step으로 이동 가능합니다.")%>", "warning", false);
				return;
			}
			
			$(".bs_set_step.st1").addClass("animated05s fadeOutLeft").hide(500);
			setTimeout(function(){$(".bs_set_step.st1").removeClass("animated05s fadeOutLeft")},500);
			$(".bs_set_step.st2").addClass("animated05s fadeInRight").show();
			setTimeout(function(){$(".bs_set_step.st2").removeClass("animated05s fadeInRight")},500);
			$(".bs_foot1").hide();
			$(".bs_foot2").show();
		}else if ($(th).parent().parent().hasClass("bs_foot2"))
		{
			$(".bs_set_step.st2").addClass("animated05s fadeOutLeft").hide(500);
			setTimeout(function(){$(".bs_set_step.st2").removeClass("animated05s fadeOutLeft")},500);
			$(".bs_set_step.st3").addClass("animated05s fadeInRight").show();
			setTimeout(function(){$(".bs_set_step.st3").removeClass("animated05s fadeInRight")},500);
			$(".bs_foot2").hide();
			$(".bs_foot3").show();
		}
		
	};
	
	
	function erpDeptManageTreeInit() {
		
		var tblParam = {};
		tblParam.syncSeq = $("#syncSeq").val() || '';;
		tblParam.erpSyncTime = $("#erpSyncTime").val() || '';;
		tblParam.compSeq = $("#compSeq").val() || '';
		tblParam.searchDept = "";
		tblParam.deptSeq = "";
		tblParam.includeDeptCode = true;
		tblParam.useYn = "Y";
		tblParam.firstYn = $("#firstYn").val() || '';
		tblParam.orgListType = $("#orgListType").val() || '';
		
		 $.ajax({
	     	type:"post",
	 		url:'<c:url value="/erp/orgchart/erpDeptOrgchartListJT.do" />',
	 		datatype:"text",
	 		data:tblParam,
	 		success: function (data) {
	 			drawTreeView('Treeview1', data);	
	 			loadingbarFlag1 = true;
			}
	 	});
	}
	
	
	function deptManageTreeInit(url) {
			
			var tblParam = {};
			tblParam.compSeq = $("#compSeq").val() || '';
			tblParam.erpSyncTime = $("#erpSyncTime").val() || '';;
			tblParam.syncSeq = $("#syncSeq").val() || '';;
			tblParam.searchDept = "";
			tblParam.deptSeq = "";
			tblParam.includeDeptCode = true;
			tblParam.useYn = "Y";
			
			 $.ajax({
		     	type:"post",
		 		url:url,
		 		datatype:"text",
		 		data:tblParam,
		 		success: function (data) {
		 			drawTreeView('Treeview2', data);		
		 			loadingbarFlag2 = true;
				}
		 	});
		}
	
	
	
	
	function drawTreeView(targetId, data){
		var dataSource2 = new Pudd.Data.DataSource({
			 
			data : exData = data.treeData
				,	pageSize : 9999
				,	serverPaging : false
			});
		
			Pudd( "#" + targetId ).puddTreeView({
				dataSource : dataSource2
			,	height : 440				// px, 설정 없으면 높이에 맞게 자동증감
			,	checkboxAutoSet : true
			,	dataNameField : "text"		// tree item name field
			,	dataFolderField : "isFolder"	// tree folder 여부
			,	dataStateField : "state"	// state { opened : boolean, selected : boolean, checked : boolean }
			,	dataIconField : "icon"		// tree item icon - 설정 없으면 folder 아이콘
			,	dataChildrenField : "children"	// tree sub folder & item
			,	dataNameAttributeField : "textAttribute"
			});
	}
	
	
	function setProgressBar(){
		var puddObj = Pudd( "#progressBar" ).getPuddObject();
		if( puddObj ) {
			puddObj.clearIntervalSet();
		}
		Pudd( "#progressBar" ).puddProgressBar({
				progressType : "loading"
			,	attributes : { style:"width:70px; height:70px;" }
			,	strokeColor : "#84c9ff"	// progress 색상
			,	strokeWidth : "3px"	// progress 두께
			,	textAttributes : { style : "" }		// text 객체 속성 설정
			,	percentText : "loading"	// loading 표시 문자열 설정 - progressType : loading, juggling 인 경우만 해당
			,	percentTextColor : "#84c9ff"
			,	percentTextSize : "12px"
			,	backgroundLayerAttributes : { style : "background-color:#000;filter:alpha(opacity=20);opacity:0.2;width:100%;height:100%;position:fixed;top:0px; left:0px;" }
			,	progressCallback : function( progressBarObj ) {
			 		if( loadingbarFlag1 && loadingbarFlag2 && loadingbarFlag3)	return 100;
			 		else	return 0;
				}
		});
	}
	
	function getEmpList() {
		setEmpListGrid();
	}
	
	
	function setEmpListGrid(){
		
		loadingbarFlag3 = true;
// 		setProgressBar(); //로딩바
		
		$("#deptEmpName").val($("#searchValue1").val());
		$("#workStatus").val($("#searchValue3").val());
		$("#erpErrCode").val($("#searchValue4").val());
		
		noEmpMap.clear();
		
		var dataSource = new Pudd.Data.DataSource({
			pageSize : 10	// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
		,	serverPaging : true
		,	request : {
				url : 'erpSyncEmpList.do'
			,	type : 'post'
			,	dataType : "json"
			,	parameterMapping : function( data ) {	
					data.orgListType = $("#orgListType").val();
					data.listType = $("#listType").val();
					data.groupSeq = $("#groupSeq").val();
					data.compSeq = $("#compSeq").val();
					data.erpSyncTime = $("#erpSyncTime").val();
					data.syncSeq = $("#syncSeq").val();
					data.loginIdType = $("#loginIdType").val();
					data.startSyncTime = $("#startSyncTime").val();
					data.endSyncTime = $("#endSyncTime").val();
					data.firstYn = $("#firstYn").val();
					data.deptJoinTotalCount = $("#deptJoinTotalCount").val();
					data.deptModifyTotalCount = $("#deptModifyTotalCount").val();
					data.empJoinTotalCount = $("#empJoinTotalCount").val();
					data.empModifyTotalCount = $("#empModifyTotalCount").val();
					data.empResignTotalCount = $("#empResignTotalCount").val();
					data.deptJoinCnt = $("#deptJoinCnt").val();
					data.deptModifyCnt = $("#deptModifyCnt").val();
					data.empJoinCnt = $("#empJoinCnt").val();
					data.empResignCnt = $("#empResignCnt").val();
					data.empModifyCnt = $("#empModifyCnt").val();
					data.noEmpList = $("#noEmpList").val();
					data.deptName = $("#deptName").val();
					data.empName = $("#empName").val();
					data.deptEmpName = $("#deptEmpName").val();
					data.workStatus = $("#workStatus").val();
					data.erpErrCode = $("#erpErrCode").val();
					data.posiSetCode = erpIuPositionSet;
					data.dutySetCode = erpIuDutySet;
		          	return data;
				}
			}
		,	result : {
			data : function( data ) {
				
				gwLicenseCount = 0;
				mailLicenseCount = 0;
				
				erpIuPositionSet = data.params.erpIuPositionSet;
				erpIuDutySet = data.params.erpIuDutySet;
				
				if(data.detailCountList != null){
					for(var i=0;i<data.detailCountList.length;i++){
						if(data.detailCountList[i].edResultCode == "0" && data.detailCountList[i].resultCode == "0"){
							if(data.detailCountList[i].licenseCheckYn == 1)	gwLicenseCount++;
							else if(data.detailCountList[i].licenseCheckYn == 2)	mailLicenseCount++;
						}
					}
					
					resignEmpCnt = 0;
					for(var i=0;i<data.detailCountList.length;i++){
						if(data.detailCountList[i].resultCode == "7"){
							resignEmpCnt++;
						}
					}
				}
				
				erpEmpCnt = data.totalCount;
				
				if(erpEmpCnt == 0){
					$("#erpLicenseTag").html("<%=BizboxAMessage.getMessage("","ERP 연동 대기 사용자")%> : [<span class='text_blue'>0</span> / <span class=''>"+ erpEmpCnt +"</span>]");
				}
				
				loadingbarFlag3 = true;
								
				return data.detailList;
			}
		,	totalCount : function( response ) {
				return response.totalCount;
			}
		,	error : function( response ) {
				alert( "error - Pudd.Data.DataSource.read, status code - " + response.status );
			}
		}
		});
		
		
		Pudd("#grid1").puddGrid({
			dataSource : dataSource	
		,   height : 310
		,	scrollable : true		 
		,	sortable : true	
		,	resizable : true
		,	ellipsis : false
		,	serverPaging : true
		,	pageable : {
			buttonCount : 10
			,	pageList : [ 10, 20, 30, 40, 50 ]
			}
		,columns : [
				{
						field : "chk"
					,	width : 34						
					,	editControl : {
						 	type : "checkbox"							
						,	basicUse : true
						,	header : {							 
							initControl : function( controlObj ) {	
								controlObj.attr( "id", "checkAll" );
								
								var puddObj = Pudd( $(controlObj) ).getPuddObject();
								puddObj.on( "click", function( e ) {
									setCheckAll("checkAll");
								});
							}
						}
						,	content : {
							initControl : function( controlObj, rowData ) {
								if($("#listType").val() == "temp"){
									controlObj.attr( "id", rowData.empSeq );
									controlObj.attr( "name", "checkEmp" );
									
									var puddObj = Pudd( $(controlObj) ).getPuddObject();
									puddObj.on( "click", function( e ) {
										setNoEmpMap(rowData.empSeq);
									});
								}
							}
						}
					}
					
				}
				,{
				 	field : "empName"	
				 ,	title : "<%=BizboxAMessage.getMessage("TX000000076","사원명")%>"	
				 ,  width : 9
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									return rowData.nmKor == null ? "" : rowData.nmKor;
								}else if("${params.erpType}" == "icube"){
									return rowData.korNm == null ? "" : rowData.korNm;
								}else if("${params.erpType}" == "gerp"){
									return rowData.nmKor == null ? "" : rowData.nmKor;
								}
							}if($("#listType").val() == "temp"){
								return rowData.empName == null ? "" : rowData.empName;
							}
						}
					}
				}
				,{
				 	field : "deptName"		
				 ,	title : "<%=BizboxAMessage.getMessage("TX000000068","부서명")%>"	
				 ,  width : 9
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {	
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									return rowData.cdDeptName == null ? "" : rowData.cdDeptName;
								}else if("${params.erpType}" == "icube"){
									return rowData.deptCdName == null ? "" : rowData.deptCdName;
								}else if("${params.erpType}" == "gerp"){
									return rowData.cdDeptName == null ? "" : rowData.cdDeptName;
								}
							}if($("#listType").val() == "temp"){
								return rowData.deptName == null ? "" : rowData.deptName;
							}
						}
					}
				}
				,{
				 	field : "emailId"	
				 ,	title : "<%=BizboxAMessage.getMessage("TX000016287","메일ID")%>"	
				 ,  width : 9
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {		
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									return rowData.noEmail == null ? "" : rowData.noEmail;
								}else if("${params.erpType}" == "icube"){
									return rowData.emalAdd == null ? "" : rowData.emalAdd;
								}else if("${params.erpType}" == "gerp"){
									return rowData.nmEmail == null ? "" : rowData.nmEmail;
								}
							}if($("#listType").val() == "temp"){
								return rowData.emailAddr == null ? "" : rowData.emailAddr;
							}
						}
					}
				}
				,{
					field : "erpEmpSeq"
				 ,	title : "<%=BizboxAMessage.getMessage("","ERP사번")%>"	
				 ,  width : 9
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {	
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									return rowData.noEmp == null ? "" : rowData.noEmp;
								}else if("${params.erpType}" == "icube"){
									return rowData.empCd == null ? "" : rowData.empCd;
								}else if("${params.erpType}" == "gerp"){
									return rowData.noEmp == null ? "" : rowData.noEmp;
								}
							}if($("#listType").val() == "temp"){
								return rowData.erpEmpSeq == null ? "" : rowData.erpEmpSeq;
							}
						}
					}
				}
				,{
					field : "positionCode"
				 ,	title : "<%=BizboxAMessage.getMessage("TX000018672","직급")%>"	
				 ,  width : 8
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									if(erpIuPositionSet == "cdDutyResp"){
										return rowData.cdDutyRespName == null ? "" : rowData.cdDutyRespName;
									}else if(erpIuPositionSet == "cdDutyRank"){
										return rowData.cdDutyRankName == null ? "" : rowData.cdDutyRankName;
									}else{
										return rowData.cdDutyStepName == null ? "" : rowData.cdDutyStepName;
									}
								}else if("${params.erpType}" == "icube"){
									if(erpIuPositionSet == "cdDutyStep"){
										return rowData.hclsCdName == null ? "" : rowData.hclsCdName;
									}else{
										return rowData.hrspCdName == null ? "" : rowData.hrspCdName;
									}
								}else if("${params.erpType}" == "gerp"){
									if(erpIuPositionSet == "cdDutyResp"){
										return rowData.cdDutyRespName == null ? "" : rowData.cdDutyRespName;
									}else if(erpIuPositionSet == "cdDutyRank"){
										return rowData.cdDutyRankName == null ? "" : rowData.cdDutyRankName;
									}else{
										return rowData.cdDutyStepName == null ? "" : rowData.cdDutyStepName;
									}								
								}
							}if($("#listType").val() == "temp"){
								return rowData.positionCodeName == null ? "" : rowData.positionCodeName;
							}
						}
					}
				}
				,{
					field : "dutyCode"
				 ,	title : "<%=BizboxAMessage.getMessage("TX000000105","직책")%>"	
				 ,  width : 8
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {	
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									if(erpIuDutySet == "cdDutyStep"){
										return rowData.cdDutyStepName == null ? "" : rowData.cdDutyStepName;
									}else if(erpIuDutySet == "cdDutyRank"){
										return rowData.cdDutyRankName == null ? "" : rowData.cdDutyRankName;
									}else{
										return rowData.cdDutyRespName == null ? "" : rowData.cdDutyRespName;
									}
								}else if("${params.erpType}" == "icube"){
									if(erpIuDutySet == "cdDutyStep"){
										return rowData.hclsCdName == null ? "" : rowData.hclsCdName;
									}else{
										return rowData.hrspCdName == null ? "" : rowData.hrspCdName;
									}
								}else if("${params.erpType}" == "gerp"){
									if(erpIuDutySet == "cdDutyStep"){
										return rowData.cdDutyStepName == null ? "" : rowData.cdDutyStepName;
									}else if(erpIuDutySet == "cdDutyRank"){
										return rowData.cdDutyRankName == null ? "" : rowData.cdDutyRankName;
									}else{
										return rowData.cdDutyRespName == null ? "" : rowData.cdDutyRespName;
									}							
								}
							}if($("#listType").val() == "temp"){
								return rowData.dutyCodeName == null ? "" : rowData.dutyCodeName;
							}
						}
					}
				}
				,{
					field : "workStatus"
				 ,	title : "<%=BizboxAMessage.getMessage("","근무구분")%>"
				 ,  width : 9
				 , widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {	
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									if(rowData.cdIncom == "001")	return "<%=BizboxAMessage.getMessage("TX000010068","재직")%>";
									else if(rowData.cdIncom == "002")	return "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>";
									else if(rowData.cdIncom == "099")	return "<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>";
								}else if("${params.erpType}" == "icube"){
									return rowData.enrlFgName == null ? "" : rowData.enrlFgName;
								}else if("${params.erpType}" == "gerp"){
									if(rowData.cdIncom == "1")	return "<%=BizboxAMessage.getMessage("TX000010068","재직")%>";
									else if(rowData.cdIncom == "2")	return "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>";
									else if(rowData.cdIncom == "3")	return "<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>";
								}
							}if($("#listType").val() == "temp"){
								return rowData.workStatusName == null ? "" : rowData.workStatusName;
							}
						}
					}
				}
				,{
					field : "statusCode"
				 ,	title : "<%=BizboxAMessage.getMessage("TX000004789","고용형태")%>"
				 ,  width : 9
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {	
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									if(rowData.cdEmp == "001")	return "<%=BizboxAMessage.getMessage("TX000004791","상용직")%>";
									else if(rowData.cdEmp == "002")	return "<%=BizboxAMessage.getMessage("TX000004792","일용직")%>";
									else return "";
								}else if("${params.erpType}" == "icube"){
									if(rowData.emplFg == "001")	return "<%=BizboxAMessage.getMessage("TX000004791","상용직")%>";
									else if(rowData.emplFg == "002")	return "<%=BizboxAMessage.getMessage("TX000004792","일용직")%>";
									else return "";
								}else if("${params.erpType}" == "gerp"){
									if(rowData.cdEmp == "1")	return "<%=BizboxAMessage.getMessage("TX000004791","상용직")%>";
									else if(rowData.cdEmp == "2")	return "<%=BizboxAMessage.getMessage("TX000004792","일용직")%>";
									else return "";
								}
							}if($("#listType").val() == "temp"){
								return rowData.statusCodeName == null ? "" : rowData.statusCodeName;
							}
						}
					}
				}
				,{
					field : "jobCode"
				 ,	title : "<%=BizboxAMessage.getMessage("TX900000395","직군/직종")%>"
				 ,  width : 9
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {		
							if($("#listType").val() == "erp"){
								if("${params.erpType}" == "iu"){
									return rowData.cdDutyTypeName == null ? "" : rowData.cdDutyTypeName;
								}else if("${params.erpType}" == "icube"){
									return rowData.htypCdName == null ? "" : rowData.htypCdName;
								}else if("${params.erpType}" == "gerp"){
									return rowData.cdDutyTypeName == null ? "" : rowData.cdDutyTypeName;
								}
							}if($("#listType").val() == "temp"){
								return rowData.jobCodeName == null ? "" : rowData.jobCodeName;
							}
						}
					}
				}
				,{
					field : "licenseCheckYn"
				 ,	title : "<%=BizboxAMessage.getMessage("TX000017941","라이선스")%>"
				 ,  width : 8
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {		
							if($("#listType").val() == "erp"){
								$("#erpLicenseTag").html("<%=BizboxAMessage.getMessage("","ERP 연동 대기 사용자")%> : [<span class='text_blue'>0</span> / <span class=''>"+ erpEmpCnt +"</span>]");
								return "";
							}if($("#listType").val() == "temp"){
								$("#erpLicenseTag").html("<%=BizboxAMessage.getMessage("","ERP 연동 대기 사용자")%> : [<span class='text_blue'>"+ (gwLicenseCount + mailLicenseCount + resignEmpCnt) +"</span> / <span class=''>"+ erpEmpCnt +"</span>]"); 
								return rowData.licenseCheckYnName == null ? "" : rowData.licenseCheckYnName;
							}
						}
					}
				}
				,{
					field : "resultCode"
				 ,	title : "<%=BizboxAMessage.getMessage("TX000001748","결과")%>"
				 ,  width : 8
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {		
							if($("#listType").val() == "erp"){
								return "";
							}if($("#listType").val() == "temp"){
								if(rowData.edResultCode == "6" || rowData.edResultCode == "30" || rowData.edResultCode == "40" || rowData.edResultCode == "50"){
									return "<%=BizboxAMessage.getMessage("TX000006506","오류")%>";
								}else if(rowData.resultCode == "20"){
									return "<%=BizboxAMessage.getMessage("TX000000815","정상")%>";
								}else if(rowData.resultCode == "2"){
									return "<%=BizboxAMessage.getMessage("TX900000393","퇴사자")%>";
								}else if(rowData.resultCode == "3"){
									return "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>";
								}else if(rowData.resultCode == "0"){
									return "<%=BizboxAMessage.getMessage("TX000000815","정상")%>";
								}else if(rowData.resultCode == "7"){
									return "<%=BizboxAMessage.getMessage("TX000012773","퇴사")%>";
								}else if(rowData.resultCode != "0"){
									return "<%=BizboxAMessage.getMessage("TX000006506","오류")%>";
								}else{
									return "";
								}
							}
						}
					}
				}
				,{
					field : "errDesc"
				 ,	title : "<%=BizboxAMessage.getMessage("TX900000216","오류상세")%>"	
				 ,  width : 8
				 ,  widthUnit : "%"
				 ,	content : {
						template : function( rowData ) {		
							if($("#listType").val() == "erp"){
								return "";
							}if($("#listType").val() == "temp"){
								if(rowData.edResultCode == "6"){
									return "<%=BizboxAMessage.getMessage("","부서 정보 없음")%>";
								}else if(rowData.edResultCode == "10"){
									return "<%=BizboxAMessage.getMessage("","사업장 정보 없음")%>";
								}else if(rowData.edResultCode == "30"){
									return "<%=BizboxAMessage.getMessage("","직책 없음")%>";
								}else if(rowData.edResultCode == "40"){
									return "<%=BizboxAMessage.getMessage("","직급 없음")%>";
								}else if(rowData.edResultCode == "50"){
									return "<%=BizboxAMessage.getMessage("","직급, 직책 없음")%>";
								}else if(rowData.edResultCode == "70"){
									return "<%=BizboxAMessage.getMessage("","직급, 직책, 메일 ID 없음")%>";
								}else if(rowData.edResultCode == "80"){
									return "<%=BizboxAMessage.getMessage("","직책, 메일 ID 없음")%>";
								}else if(rowData.edResultCode == "90"){
									return "<%=BizboxAMessage.getMessage("","직급, 메일 ID 없음")%>";
								}else if(rowData.resultCode == "20"){
									return "<%=BizboxAMessage.getMessage("TX900000387","ERP 사원정보 변경")%>";
								}else if(rowData.resultCode == "1"){
									return "<%=BizboxAMessage.getMessage("TX000003226","변경")%>";
								}else if(rowData.resultCode == "2"){
									return "<%=BizboxAMessage.getMessage("TX000004490","퇴사처리")%>";
								}else if(rowData.resultCode == "7"){
									for(var i=0;i<resignEmpList.length;i++){
										if(resignEmpList[i] == rowData.empSeq){
											return '<button id="" type="button" disabled="disabled"><%=BizboxAMessage.getMessage("","퇴사 완료")%></button>';
										}
									}									
									return '<button id="resignBtn_' + rowData.empSeq + '" type="button" onclick="fnResign(\'' + rowData.erpEmpSeq + '\',\'' + rowData.compSeq + '\')"><%=BizboxAMessage.getMessage("TX000004490","퇴사처리")%></button>';
								}else if(rowData.resultCode == "3"){
									return "<%=BizboxAMessage.getMessage("TX000006260","대결자지정")%>";
								}else if(rowData.resultCode == "10"){
									return "<%=BizboxAMessage.getMessage("TX900000369","사업장 정보 없음")%>";
								}else if(rowData.resultCode == "4"){
									return "<%=BizboxAMessage.getMessage("","메일 ID 없음")%>";
								}else if(rowData.resultCode == "5"){
									return "<%=BizboxAMessage.getMessage("TX900000370","로그인 ID 중복")%>";
								}else if(rowData.resultCode == "30"){
									return "<%=BizboxAMessage.getMessage("TX900000384","그룹웨어 라이센스 초과")%>";
								}else if(rowData.resultCode == "40"){
									return "<%=BizboxAMessage.getMessage("TX900000383","메일 라이센스 초과")%>";
								}else if(rowData.resultCode == "11"){
									return "<%=BizboxAMessage.getMessage("TX900000382","메일 ID 중복")%>";
								}else if(rowData.resultCode == "0"){
									return "";
								}
							}
						}
					}
				}
				]
				,	progressBar : {
					progressType : "loading"
				,	attributes : { style:"width:70px; height:70px;" }
				,	strokeColor : "#84c9ff"	// progress 색상
				,	strokeWidth : "3px"	// progress 두께
				,	percentText : "loading"	// loading 표시 문자열 설정 - progressType loading 인 경우만
				,	percentTextColor : "#84c9ff"
				,	percentTextSize : "12px"
				,	backgroundLayerAttributes : { style : "background-color:#fff;filter:alpha(opacity=0);opacity:0;width:100%;height:100%;position:fixed;top:0px; left:0px;" }
				}
				,	loadCallback : function( headerTable, contentTable, footerTable, gridObj ) {
					if($("#listType").val() == "erp"){ 
						var rowLength = contentTable.rows.length;
						if( rowLength <= 0 ) return;
						for( var i=0; i<rowLength; i++ ) {
							var trObj = Pudd.getInstance( contentTable.rows[ i ] );
							var tdObjCheckbox = Pudd.getInstance( contentTable.rows[ i ].cells[ 0 ] );
							tdObjCheckbox.checkboxObj.hide();
						}
					}else if($("#listType").val() == "temp"){ 
						var rowLength = contentTable.rows.length;
						if( rowLength <= 0 ) return;
				 
						for( var i=0; i<rowLength; i++ ) {
							var trObj = Pudd.getInstance( contentTable.rows[ i ] );
							var tdObjCheckbox = Pudd.getInstance( contentTable.rows[ i ].cells[ 0 ] );
							
							if(trObj.rowData.edResultCode == "6" || trObj.rowData.edResultCode == "10" || trObj.rowData.edResultCode == "30" || trObj.rowData.edResultCode == "40" || trObj.rowData.edResultCode == "50" || trObj.rowData.resultCode == "1" || trObj.rowData.resultCode == "2" || trObj.rowData.resultCode == "7" || trObj.rowData.resultCode == "3" || trObj.rowData.resultCode == "10" || trObj.rowData.resultCode == "4" || trObj.rowData.resultCode == "5" || trObj.rowData.resultCode == "30" || trObj.rowData.resultCode == "40" || trObj.rowData.resultCode == "11"){
								trObj.addClass( "text_red" );
								tdObjCheckbox.checkboxObj.hide();
							}else if( trObj.rowData.resultCode == '20') {
								trObj.addClass( "text_blue" );
							}	 
						}
						
						setCheckBox();
					}
				}
			});
	}
	
	function setAlert(msg, type, closeFlag){
		//type -> success, warning		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';		
			
		var puddDialog = Pudd.puddDialog({	
			width : 500	// 기본값 300
		,	height : 100	// 기본값 400		 
		,	message : {		 
				type : type
				,content : titleStr
			},
			footer : {
				 
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
					,	value : '<%=BizboxAMessage.getMessage("TX000019752", "확인")%>'
					,	clickCallback : function( puddDlg ) {
							if(closeFlag == "empTempSave"){
								puddDialog.showDialog(false);
								$("#btnEmpInit").attr("disabled",false);
			 					$("#search2").show();
			 					$("#search2-1").show();
			 					Pudd( "#searchValue3" ).getPuddObject().setSelectedIndex( 0 );
			 					Pudd( "#searchValue4" ).getPuddObject().setSelectedIndex( 0 );
			 					$("#page").val("1");
			 					getEmpList();
			 					ddlWorkStatusItemSet($("#listType").val());
							}else if(closeFlag){
								window.self.close();			//현재창 닫음
							}else{
								puddDialog.showDialog(false);
							}
						}
					}				
				]				
			}
		});			
		$("#btnConfirm").focus();	
	}
	
	
	
	function setConfirm(msg, type, closeFlag, btnType){
		//btnType -> 0:일반, 1:선택반영, 2:전체반영
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';		
			
		var puddDialog = Pudd.puddDialog({	
			width : 500	// 기본값 300
		,	height : 100	// 기본값 400		 
		,	message : {		 
				type : type
				,content : titleStr
			},
			footer : {
				 
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
					,	value : '<%=BizboxAMessage.getMessage("TX000019752", "확인")%>'
					,	clickCallback : function( puddDlg ) {
							puddDlg.showDialog( false );
							if(closeFlag)	window.self.close();
							
							if(btnType == "1" || btnType == "2"){
								if(btnType == "1"){
									setNoEmpList();
								}								
								
								$("#page").val("1");
								loadingbarFlag3 = false;
								setProgressBar(); //로딩바
								saveOrgchart();
							}
						}
					},
					{
						attributes : {style : "margin-left:5px;"}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnCancel"}// control 자체 객체 속성 설정
					,	value : '<%=BizboxAMessage.getMessage("", "취소")%>'
					,	clickCallback : function( puddDlg ) {
							puddDlg.showDialog( false );
						}
					}					
				]				
			}
		});			
		$("#btnConfirm").focus();
	}
	
	
	function saveTempOrg() {
		
		loadingbarFlag1 = false;
	 	loadingbarFlag2 = false;
	 	noEmpMap.clear();
	 	
		setProgressBar(); //로딩바
		
		$.ajax({
 			type:"post",
 			url:"erpSyncOrgchartTempSaveProc.do",
 			datatype:"json",
 			data: {groupSeq:$("#groupSeq").val(),compSeq:$("#compSeq").val(), erpSyncTime:$("#erpSyncTime").val(), firstYn:$("#firstYn").val()},
 			success:function(data){
 				var code = data.resultCode;
 				if (code == '0') {
 					var syncSeq = data.syncSeq;
 					$("#syncSeq").val(syncSeq);
 					$("#orgListType").val("temp");
 					
 					//결과 그리기(erp,그룹웨어 조직도)
 					deptManageTreeInit('<c:url value="/erp/orgchart/erpTempDeptOrgchartListJT.do" />'); 
 					erpDeptManageTreeInit();
 					
 					
 					setAlert('<%=BizboxAMessage.getMessage("","그룹웨어 조직도에 반영되었습니다.")%>', "success", false);
 				}else if(code == '2'){
 					loadingbarFlag1 = true;
 					loadingbarFlag2 = true;
 					setAlert('<%=BizboxAMessage.getMessage("","반영할 데이터가 존재하지 않습니다.")%>', "warning", false);
 				}else{
 					loadingbarFlag1 = true;
 					loadingbarFlag2 = true;
 					setAlert('<%=BizboxAMessage.getMessage("","조직도 반영 중 오류가 발생했습니다.")%>', "error", false);
 				}
 			},			
 			error : function(e){
 				alert("saveTempOrg error");	
 			}
 		});	
	}
	
	
	
	
	function saveTempEmp() {			
			loadingbarFlag3 = false;
			setProgressBar(); //로딩바
			
			$("#deptEmpName").val($("#searchValue1").val());
			$("#workStatus").val($("#searchValue3").val());
			$("#erpErrCode").val($("#searchValue4").val());

			var data = jQuery("#orgForm").serialize();
			
		$.ajax({ 
 			type:"post",
 			url:"erpSyncEmpTempSaveProc.do",
 			datatype:"json",
 			data: data,
 			success:function(data){
 				if(data.resultCode == null || data.resultCode == '') {
 					alert("data.resultCode : " + data.resultCode);
 				} else if(data.resultCode == '0') {
 					
 					$("#page").val(parseInt($("#page").val())+1);
 					
 					saveTempEmp();
 					
 				} else if(data.resultCode == '99') {
 					loadingbarFlag3 = true;
 					$("#listType").val("temp");
 					setAlert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>', "success", "empTempSave");
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
	
	
	function getGwLicenseCnt(){
		$.ajax({
 			type:"post",
 			url:'<c:url value="/cmm/systemx/license/LicenseCountShow.do" />',
 			datatype:"text",
 			success:function(data){
 				var innerHtml = "";
 				if(data.licenseCount.resultCode == "success") {
 					innerHtml = "<%=BizboxAMessage.getMessage("TX900000097","실사용자")%> :  GW [ <span class='text_blue'>" + data.licenseCount.realGwCount + "</span> / " + data.licenseCount.totalGwCount + " ] ,  Mail [ <span class='text_blue'>" + data.licenseCount.realMailCount + "</span> / " + data.licenseCount.totalMailCount + "] ,  <%=BizboxAMessage.getMessage("TX000017901","비라이선스")%> [ <span class='text_blue'>" + data.licenseCount.realNotLicenseCount + "</span> ] ";
 				}
	 			$("#gwLicenseTag").html(innerHtml);
	 			licenseInfo = data.licenseCount;
 			}
 		});
	}

	
	function fnEmpInit(){
		
		$("#searchValue1").val("");
		noEmpMap.clear();
		Pudd( "#searchValue3" ).getPuddObject().setSelectedIndex( 0 );
		Pudd( "#searchValue4" ).getPuddObject().setSelectedIndex( 0 );
		
		loadingbarFlag3 = true;
		
		var tblParam = {};
		tblParam.syncSeq = $("#syncSeq").val() || '';;

		 $.ajax({
	     	type:"post",
	 		url:'<c:url value="/erp/orgchart/erpEmpInit.do" />',
	 		datatype:"text",
	 		data:tblParam,
	 		success: function (data) {
	 			$("#listType").val("erp");
	 			getEmpList();
	 			
	 			$("#btnEmpInit").attr("disabled",true);
				$("#search2").hide();
				$("#search2-1").hide();
				Pudd( "#searchValue3" ).getPuddObject().setSelectedIndex( 0 );
				Pudd( "#searchValue4" ).getPuddObject().setSelectedIndex( 0 );
				ddlWorkStatusItemSet($("#listType").val());
	 			setAlert('<%=BizboxAMessage.getMessage("","초기화되었습니다.")%>', "success", false);
			}
	 	});
	}
	
	
	
	// 임시 저장 데이터 그룹웨어 실제 반영
	function saveOrgchart() {
		
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
// 	 					$("#empResignTotalCount").val(data.empResignTotalCount||'0');
// 	 					$("#empResignCnt").val(data.empResignTotalCount||'0');
						$("#empResignTotalCount").val(resignEmpList.length);
						$("#empResignCnt").val(resignEmpList.length);
 					}
 					
 					var moreYn = data.moreYn;
 					
 					if(moreYn == 'N' && type != 40) {
 						setSaveType();
 						$("#page").val("1");
 					} else if(moreYn == 'N' && type == 40 && syncCnt == 0) {
 						loadingbarFlag3 = true;
 	 					setAlert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>', "success", true);
 						if(opener != null && opener.firstList != null){
 							opener.firstList();
 						}					
 						return;
 					} else {
 						$("#page").val(parseInt($("#page").val())+1);
 					}
 					if(moreYn != 'N' || type < 50) {
 						saveOrgchart();
 					}
 				} else if(data.resultCode == '99') {
 					loadingbarFlag3 = true;
 					setAlert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>', "success", true);
					if(opener != null && opener.firstList != null){
						opener.firstList();
					}
 				}
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
 					loadingbarFlag3 = true;
 					setAlert('<%=BizboxAMessage.getMessage("TX000002073","저장 되었습니다.")%>', "success", true);
					if(opener != null && opener.firstList != null){
						opener.firstList();
					}					
					return;
 				}
 			}
 		});
	}
	
	function  setNoEmpList(){
		var noEmpList = "";
		for(var i in noEmpMap.keys()) {
			noEmpList += ",'"+noEmpMap.keys()[i]+"'";
		}
		if(noEmpList.length > 0){
			noEmpList = noEmpList.substring(1);
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
	
	
	function setResignEmpInfo(empSeq){
		$("#resignBtn_" + empSeq).html("<%=BizboxAMessage.getMessage("","퇴사 완료")%>");
		$("#resignBtn_" + empSeq).attr("disabled","disabled");
		resignEmpCnt--;
		resignEmpList.push(empSeq);
	}
	
	
	function ddlWorkStatusItemSet(orgListType){
		
		Pudd( "#searchValue3" ).getPuddObject().removeOption( 1 );
		Pudd( "#searchValue3" ).getPuddObject().removeOption( 1 );
		Pudd( "#searchValue3" ).getPuddObject().removeOption( 1 );
		
		if(orgListType == "erp"){
			if("${params.erpType}" == "iu"){
				Pudd( "#searchValue3" ).getPuddObject().addOption( "099", "<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>" );
				Pudd( "#searchValue3" ).getPuddObject().addOption( "002", "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>" );
				Pudd( "#searchValue3" ).getPuddObject().addOption( "001", "<%=BizboxAMessage.getMessage("TX000010068","재직")%>" );
			}else if("${params.erpType}" == "icube"){
				Pudd( "#searchValue3" ).getPuddObject().addOption( "J05", "<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>" );
				Pudd( "#searchValue3" ).getPuddObject().addOption( "J03", "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>" );
				Pudd( "#searchValue3" ).getPuddObject().addOption( "J01", "<%=BizboxAMessage.getMessage("TX000010068","재직")%>" );
			}else if("${params.erpType}" == "gerp"){
				Pudd( "#searchValue3" ).getPuddObject().addOption( "3", "<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>" );
				Pudd( "#searchValue3" ).getPuddObject().addOption( "2", "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>" );
				Pudd( "#searchValue3" ).getPuddObject().addOption( "1", "<%=BizboxAMessage.getMessage("TX000010068","재직")%>" );
			}
		}else{
			Pudd( "#searchValue3" ).getPuddObject().addOption( "001", "<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>" );
			Pudd( "#searchValue3" ).getPuddObject().addOption( "004", "<%=BizboxAMessage.getMessage("TX000010067","휴직")%>" );
			Pudd( "#searchValue3" ).getPuddObject().addOption( "999", "<%=BizboxAMessage.getMessage("TX000010068","재직")%>" );
		}
	}
	
	
	function setNoEmpMap(id){
		
		var puddObj = Pudd( "#" + id ).getPuddObject();		 
		var bChecked = puddObj.getChecked();
		
		
		if(bChecked){
			noEmpMap.put(id, id);
		}else{
			noEmpMap.remove(id);
		}
	}
	
	function setCheckAll(id){
		
		var rowData = Pudd( "#grid1" ).getPuddObject().getGridData();
		
		var puddObj = Pudd( "#" + id ).getPuddObject();		 
		var bChecked = puddObj.getChecked();
		
		for( var i in rowData ) {
			
			if($("#" + rowData[i].empSeq).length > 0 && $("#" + rowData[i].empSeq).css("display") != "none"){ //체크박스 유무 확인
				if(bChecked){
					noEmpMap.put(rowData[i].empSeq, rowData[i].empSeq);	
				}else{
					noEmpMap.remove(rowData[i].empSeq);
				}
			}
		}
	}
	
	function setCheckBox(){
		for(var i in noEmpMap.keys()){
			var puddObj = Pudd( "#" + noEmpMap.keys()[i] ).getPuddObject();
			
			if(puddObj){
				puddObj.setChecked( true );
			}
		}
	}
	
	
	/* [Map] declare javascipt hashmap prototype
	========================================*/
	Map = function () {
		this.map = new Object();
	};
	Map.prototype = {
		put: function (key, value) {
			this.map[key] = value;
		},
		get: function (key) {
			return this.map[key];
		},
		containsKey: function (key) {
			return key in this.map;
		},
		containsValue: function (value) {
			for (var prop in this.map) {
				if (this.map[prop] == value) return true;
			}
			return false;
		},
		isEmpty: function (key) {
			return (this.size() == 0);
		},
		clear: function () {
			for (var prop in this.map) {
				delete this.map[prop];
			}
		},
		remove: function (key) {
			delete this.map[key];
		},
		keys: function () {
			var keys = new Array();
			for (var prop in this.map) {
				keys.push(prop);
			}
			return keys;
		},
		values: function () {
			var values = new Array();
			for (var prop in this.map) {
				values.push(this.map[prop]);
			}
			return values;
		},
		size: function () {
			var count = 0;
			for (var prop in this.map) {
				count++;
			}
			return count;
		}
	};
	
	var noEmpMap = new Map();	//선택사용자 저장변수(map)
</script>

<body>
<div class="pop_wrap" style="width:898px">
	<div id="progressBar"></div>

	<form id="orgForm">
		<input type="hidden" id="page" name="page" value="1" />
		<input type="hidden" id="pageSize" name="pageSize" value="1000000" />	
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
		<input type="hidden" id="deptName" name="deptName" value="" />
		<input type="hidden" id="empName" name="empName" value="" />
		<input type="hidden" id="deptEmpName" name="deptEmpName" value="" />
		<input type="hidden" id="workStatus" name="workStatus" value="" />
		<input type="hidden" id="erpErrCode" name="erpErrCode" value="" />
	</form>

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000020528","조직도 동기화")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con posi_re" style="height:675px;">
		<div class="bs_set_step st1" >
			<div class="Pop_border p15 mb15" style="background:#f0f6fd;">
				<p class="tit_p mb8"><%=BizboxAMessage.getMessage("","최초ERP 조직도 연동 및 업데이트 시, 기존 조직도는 삭제처리 되지 않고, 변경된 정보만 업데이트 됩니다.")%></p>
				<p class="tit_p mb8"><%=BizboxAMessage.getMessage("","조직도 연동 결과 확인 후, ERP 사원 연동이 가능합니다.")%></p>
				<p class="tit_p mb0"><%=BizboxAMessage.getMessage("","ERP 정보가 변경된 경우, 결과 확인버튼을 다시 클릭해주세요.")%></p>
				<ul class="bum_organ_ul">
					<li><span class="col1"></span><span class="txt">: <%=BizboxAMessage.getMessage("TX900000394","정상")%></span></li>
					<li><span class="col2"></span><span class="txt">: <%=BizboxAMessage.getMessage("TX000000424","삭제")%></span></li>
					<li><span class="col3"></span><span class="txt">: <%=BizboxAMessage.getMessage("TX000003101","신규")%></span></li>
					<li><span class="col4"></span><span class="txt">: <%=BizboxAMessage.getMessage("TX000006506","오류")%></span></li>
				</ul>
			</div>
			<div class="bs_tab tab2 mb10">
				<ul>
					<li class="on">
						<a href="#n">1. <%=BizboxAMessage.getMessage("TX000007170","ERP 조직도 연동")%></a>
						<span class="arr_semo"></span>
					</li>
					<li>
						<a href="#n">2. <%=BizboxAMessage.getMessage("TX000007171","ERP 사원 연동")%></a>
						<span class="arr_semo"></span>
					</li>
				</ul>
			</div>
			<div class="btn_div mt0">
				<div class="right_div">
					<input id="btnApplyOrg" type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000021947","결과 확인")%>"/>
				</div>
			</div>
			<div class="bs_tw_ta">
				<table style="table-layout:fixed;">
					<colgroup>
						<col width="50%">
						<col width="">
					</colgroup>
					<tr>
						<td class="vt">
							<div class="formTable">
								<table>
									<tr>
										<th>ERP</th>
									</tr>
									<tr>
										<td style="height:440px">
											<div id="Treeview1" class="treeview" class="ml15"></div>								
										</td>
									</tr>
								</table>
							</div><!--// formTable -->
						</td>
						<td>
							<div class="formTable">
								<table>
									<tr>
										<th><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></th>
									</tr>
									<tr>
										<td style="height:440px">
											<div id="Treeview2" class="treeview" class="ml15"></div>
										</td>
									</tr>
								</table>
							</div><!--// formTable -->
						</td>
					</tr>
				</table>
			</div><!--// bs_tw_ta -->
			
		</div><!--// bs_set_step1 -->

		<div class="bs_set_step st2" style="display:none;">
			<div class="Pop_border p15 mb15" style="background:#f0f6fd;">
				<p class="tit_p mb5" id="idOptionValue"></p>
				<p class="tit_p mb5"><%=BizboxAMessage.getMessage("","ERP 조직도 연동시, 연동 대기자가 잔여 라이선스를 초과하지 않도록 해야 합니다.")%></p>
				<p class="tit_p mb5"><span class="text_red"><%=BizboxAMessage.getMessage("","ERP 조직도 연동 시, ERP에서 퇴직 처리된 사용자는 그룹웨어에서 퇴사 처리 진행이 필요합니다")%></span></p>
				<p class="tit_p mb5"><%=BizboxAMessage.getMessage("","[결과확인] 후 ERP 사원 연동 결과를 확인할 수 있으며, [초기화] 시 결과 확인 전으로 조회가능합니다.")%></p>
				<p class="tit_p mb5"><%=BizboxAMessage.getMessage("","전체 반영 시, 연동된 사용자 모두 그룹웨어로 반영되며, 선택 반영 시 선택 사용자만 그룹웨어로 반영됩니다.")%></p>
				<p class="tit_p mb0"><span class="text_red"><%=BizboxAMessage.getMessage("","그룹웨어에 등록된 사용자의 경우, 정보 업데이트 시 메일 ID값은 업데이트 되지 않습니다.")%></span></p>
			</div>
			<div class="bs_tab tab2 mb10">
				<ul>
					<li>
						<a href="#n">1. <%=BizboxAMessage.getMessage("TX000007170","ERP 조직도 연동")%></a>
						<span class="arr_semo"></span>
					</li>
					<li class="on">
						<a href="#n">2. <%=BizboxAMessage.getMessage("TX000007171","ERP 사원 연동")%></a>
						<span class="arr_semo"></span>
					</li>
				</ul>
			</div>

			<!-- 기본 검색바 -->
			<div class="top_box">
				<dl>
					<dt><%=BizboxAMessage.getMessage("","부서/사원명")%></dt>
					<dd><input type="text" style="width:120px;" class="puddSetup" value="" id="searchValue1" onkeydown="if(event.keyCode==13){getEmpList();}"/></dd>					
					<dt id="search1"><%=BizboxAMessage.getMessage("TX000007182","근무구분")%></dt>
					<dd id="search1-1">
						<c:if test="${params.erpType == 'iu'}">
							<select class="puddSetup" pudd-style="width:120px;" id="searchValue3"/>
								<option value=""><%=BizboxAMessage.getMessage("TX000022293","전체")%></option>
								<option value="001"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
								<option value="002"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
								<option value="099"><%=BizboxAMessage.getMessage("TX000021243","퇴직")%></option>
							</select>
						</c:if>
						<c:if test="${params.erpType == 'icube'}">
							<select class="puddSetup" pudd-style="width:120px;" id="searchValue3"/>
								<option value=""><%=BizboxAMessage.getMessage("TX000022293","전체")%></option>
								<option value="J02"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
								<option value="J03"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
								<option value="J05"><%=BizboxAMessage.getMessage("TX000021243","퇴직")%></option>
							</select>
						</c:if>
						<c:if test="${params.erpType == 'gerp'}">
							<select class="puddSetup" pudd-style="width:120px;" id="searchValue3"/>
								<option value=""><%=BizboxAMessage.getMessage("TX000022293","전체")%></option>
								<option value="1"><%=BizboxAMessage.getMessage("TX000010068","재직")%></option>
								<option value="2"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></option>
								<option value="3"><%=BizboxAMessage.getMessage("TX000021243","퇴직")%></option>
							</select>
						</c:if>
					</dd>
					<dt id="search2" style="display:none;"><%=BizboxAMessage.getMessage("TX000001748","결과")%></dt>
					<dd id="search2-1" style="display:none;">
						<select class="puddSetup" pudd-style="width:120px;" id="searchValue4"/>
							<option value=""><%=BizboxAMessage.getMessage("TX000022293","전체")%></option>
							<option value="0"><%=BizboxAMessage.getMessage("TX900000394","정상")%></option>
							<option value="4"><%=BizboxAMessage.getMessage("TX000006506","오류")%></option>
							<option value="3"><%=BizboxAMessage.getMessage("TX900000393","퇴사자")%></option>
						</select>
					</dd>
					<dd><input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" id="btnSearch"/></dd>
				</dl>
			</div>

			<div class="btn_div">
				<div class="left_div">
					<p class="tit_p mt5 mb0" id="erpLicenseTag">
						<%=BizboxAMessage.getMessage("","ERP 연동 대기 사용자")%> : [<span class='text_blue'> 0 </span>]
					</p>
				</div>
				<div class="right_div">
					<p class="tit_p fl mt5 mb0 mr10" id="gwLicenseTag"></p>
					<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000002960","초기화")%>" id="btnEmpInit"/>
					<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000021947","결과 확인")%>" id="btnApplyEmp"/>
				</div>
			</div>
			<div id="grid1">
							
			</div>
	

		</div><!--// bs_set_step2 -->


	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12 bs_foot1">
			<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000003164","다음")%>" onclick="bsNext(this);" />
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000019660","취소")%>" id="btnCancel"/>
		</div>
		<div class="btn_cen pt12  bs_foot2" style="display:none;">
			<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("","선택반영")%>" id="btnSave2"/>
			<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("","전체반영")%>" id="btnSave"/>
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000019660","취소")%>" id="btnCancel2"/>
		</div>

	</div><!-- //pop_foot -->
</div><!--// pop_wrap -->

<div id="ProgressBar"></div>

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
		  <input name="target" value="erpSyncEmp" type="hidden"/>
	</form> 


</body>
</html>