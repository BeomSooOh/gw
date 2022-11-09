<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
	<%@page import="main.web.BizboxAMessage"%>
	
	<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/Script/pudd/pudd-1.1.189.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.min.js"></script>    
   <script src="/gw/js/neos/NeosUtil.js"></script>
   
    <script>
    
    var exData = [];
	var dataSource;
    
    $(document).ready(function() {
    	
    });
    
    
    
    
    puddready( function() {
			// Data 생성
			var codeData = ${compListJson};
			 

			
			// Pudd DataSource 매핑
			var dataSourceComboBox = new Pudd.Data.DataSource({
			 
				data : codeData
			});
			 
			Pudd( "#com_sel" ).puddComboBox({
			 
					attributes : { style : "width:200px;" }// control 부모 객체 속성 설정
				,	controlAttributes : { id : "exAreaSelectBox" }// control 자체 객체 속성 설정
				,	dataSource : dataSourceComboBox
				,	dataValueField : "compSeq"
				,	dataTextField : "compName"
				,	disabled : false
				,	scrollListHide : false
			 
					// Pudd SelectBox는 내부에서 UI 부분을 재구성하여 표현하는 관계로 제공되는 이벤트만 설정가능
					// 이벤트 설정을 하고자 하는 경우 아래 주석를 해제하고 해당 이벤트 설정하면 됨
					// 제공되는 이벤트 : change
				//,	eventCallback : {
				//		"change" : function( e ) {
				//			console.log( "change" );
				//		}
				//	}
			});
			var puddObj = Pudd( "#com_sel" ).getPuddObject();
			
			if("${loginVO.userSe}" != "MASTER"){
		//sh_modi_20220916 마스터권한이 아닌경우, 로그인한 회사찾아서 셀렉트박스에서 선택되도록 변경
		//		puddObj.setSelectedIndex(0);
				
				var loginCompIndex  = 0;
					for(var i = 0; i< codeData.length; i++){
						if(codeData[i].compSeq == "${loginVO.compSeq}"){
							loginCompIndex = i;
						}					
					}
		
				puddObj.setSelectedIndex(loginCompIndex);
				$("#com_sel").hide();
			}else{
				var puddObj = Pudd( "#com_sel" ).getPuddObject();
			    puddObj.addOption( "", "<%=BizboxAMessage.getMessage("TX000000862", "전체")%>", 0);				    
				puddObj.setSelectedIndex(0);
			}
			
			gridRead();
		});
    
    
    function gridRead(){
    	var tblParam = {};
    	
    	tblParam.compSeq = Pudd( "#com_sel" ).getPuddObject().val();
    	tblParam.fReqDate = $("#txtFrDt").val();
    	tblParam.tReqDate = $("#txtToDt").val();
    	tblParam.status = $("#status").val();
    	tblParam.reqId = $("#reqId").val();
    	tblParam.deviceType = $("#deviceType").val();       
    	
    	
    	$.ajax({
 			type:"post",
 			url:'<c:url value="/cmm/systemx/devApprovalList.do" />',
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
 				exData = data.list;
 				
 				dataSource = new Pudd.Data.DataSource({			 
	        			data : exData			// 직접 data를 배열로 설정하는 옵션 작업할 것		 
	        		,	pageSize : 20			// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
	        		,	serverPaging : false
	        	});
	        	setDate();
	        	$("#btnApproval").attr("disabled", true);
	    		$("#btnReject").attr("disabled", true);
 			}        		        	
 		});
    }
    
    
    function setDate(){
		Pudd("#grid").puddGrid({
			dataSource : dataSource
		,	height : 500
		,	pageable : {
			buttonCount : 10
			,pageList : [ 10, 20, 30, 40, 50 ]
		}
		,	scrollable : true
		,	columns : [
				{
						field : "chk"		// grid 내포 checkbox 사용할 경우 고유값 전달
					,	width : 15
					,	content : {
						template : function(rowData) {
															
							if(rowData.status == "P")
								return "";
							else{
								var html = '<input onclick="fnCheckBoxClick()" type="checkbox" value="1" class="puddSetup boxClass" seq="' + rowData.seq + '" id="chk_' + rowData.seq + '" />';
								return html;
							}
						}
					}
				}
			,	{
						field : "compName"
					,	title : "<%=BizboxAMessage.getMessage("TX000018385", "회사명")%>"
					,	width : 50
				}
			,	{
						field : "data2"
					,	title : "<%=BizboxAMessage.getMessage("TX900000058", "요청자(ID)")%>"
					,	width : 100
					,	content : {
						template : function(rowData) {
							var html = "<p onclick=\"openEmpProfileInfoPop('" + rowData.compSeq + "', '" + rowData.deptSeq + "', '" + rowData.empSeq + "')\">" + rowData.reqId + "</p>"; 
							return html;
						}
					}
				}
			,	{
						field : "deviceName"
					,	title : "<%=BizboxAMessage.getMessage("TX900000059", "인증기기명칭")%>"
					,	width : 100	 
					,	content : {
						template : function(rowData) {
							var html = '';
							if(rowData.type == "1")
								html = '<img src="/gw/Images/ico/ico_phone.png" class="mr5">' + rowData.deviceName;
							else
								html = '<img src="/gw/Images/ico/ico_phone_user.png" class="mr5">' + rowData.deviceName;
							return html;
						}
					}
				}
			,	{
						field : "appName"
					,	title : "<%=BizboxAMessage.getMessage("TX900000060", "인증기기Type")%>"
					,	width : 100
	      		}
			,	{
						field : "requestDate"
					,	title : "<%=BizboxAMessage.getMessage("TX900000061", "요청일시")%>"
					,	width : 100
      			}
  			,	{
         				field : "confirmDate"
					,	title : "<%=BizboxAMessage.getMessage("TX000007536", "승인일시")%>"
         			,	width : 120
      			}
	      	,	{
	         			field : "statusMulti"
	         		,	title : "<%=BizboxAMessage.getMessage("TX000018400", "승인상태")%>"
	         		,	width : 100
	         		,	content : {
							template : function(rowData) {
								var html = "";
								if(rowData.status == "C"){
									html = '<span class="mr5">' + rowData.statusMulti + '</span><input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000966", "사유")%>" onclick=fnDescPop("' + rowData.seq + '") style="height:19px;"/>';
								}else{
									html = '<span class="mr5">' + rowData.statusMulti + '</span>';
								}
								return html;
							}
						}
				}
  			]
    		,	loadCallback : function( headerTable, contentTable, footerTable, gridObj ) {
				 
				// grid 에 dataSource 전달되지 않은 경우는 skip
				if( ! gridObj.optObject.dataSource ) return;
		 
				var totalCount = gridObj.optObject.dataSource.totalCount;
				if( 0 == totalCount ) {
		 
					var colCount = gridObj.gridColCount();
					if( 0 == colCount ) return;
		 
					var trObj = new Pudd.Element( "tr" );
					var tdObj = new Pudd.Element( "td" );
					tdObj.attr( "colspan", colCount );
					tdObj.text( '<%=BizboxAMessage.getMessage("TX000010608", "데이터가 존재하지 않습니다")%>' );
		 
					trObj.append( tdObj );
					gridObj.contentTableTbodyObj.append( trObj );
				}
			}
		});
	}
    
    
    function fnCheckBoxClick(){
    	var checkFlag = false;
    	$(".boxClass").each(function(){
    		if(Pudd( this ).getPuddObject().getChecked()){
    			checkFlag = true;
    		}
    	});
    	
    	if(checkFlag){
    		$("#btnApproval").attr("disabled", false);
    		$("#btnReject").attr("disabled", false);			 
    	}else{
    		$("#btnApproval").attr("disabled", true);
    		$("#btnReject").attr("disabled", true);
    	}
 	}
    
    function fnSetStatus(status){
 		//status=P  	승인
 		//status=C		해지
    	var seqList = "";
    	
    	$(".boxClass").each(function(){
 			if(Pudd( this ).getPuddObject().getChecked())
 				seqList += "," + $(this).attr("seq");
 		});
    	if(seqList.length > 0){
    		seqList = seqList.substring(1);
    	}
    	
    	if(status == "C"){

	    	var contentHtml = '<input type="text" id="desc" class="puddSetup" pudd-style="width:100%;" value="" placeholder="<%=BizboxAMessage.getMessage("TX900000062", "반려 사유를 입력해주세요.")%>"/>';
	    	
			Pudd.puddDialog({
					width : 400					
				,	header : {
						title : "<%=BizboxAMessage.getMessage("TX000001326", "반려사유")%>"
					,	align : "left"	// left, center, right						
				}
				,	body : {
						content : contentHtml
				}
				,	footer : {
			 
					buttons : [
						{
							attributes : {}// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
						,	value : "<%=BizboxAMessage.getMessage("TX000019752", "확인")%>"
						,	clickCallback : function( puddDlg ) {
								var tblParam = {};
								tblParam.seqList = seqList;
								tblParam.status = status;
								tblParam.desc = $("#desc").val();
								
								$.ajax({
									type : "post",
									url : '<c:url value="/cmm/systemx/setSecondCertDevStatus.do" />',
									datatype : "text",
									data : tblParam,
									success : function(data) {
										puddDlg.showDialog( false );
						 				setScAlert("<%=BizboxAMessage.getMessage("TX900000063", "반려되었습니다.")%>", "success");
									}
								});
							}
						}
					,	{
							attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
						,	value : "<%=BizboxAMessage.getMessage("TX000002947", "취소")%>"
						,	clickCallback : function( puddDlg ) {
								puddDlg.showDialog( false );
								// 추가적인 작업 내용이 있는 경우 이곳에서 처리
							}
						}
					]
				}
			}); 
    	}else{
    		var tblParam = {};
	        tblParam.seqList = seqList;
	        tblParam.status = status;
	        
	        if(seqList != ""){
	        	$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/setSecondCertDevStatus.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			success:function(data){
		 				if(data.resultCode == "FAIL"){
		 					setScAlert("<%=BizboxAMessage.getMessage("TX900000064", "사용기기 등록 가능개수가 초과되어 승인 할 수 없습니다.")%>", "warning");
		 				}else{
		 					setScAlert("<%=BizboxAMessage.getMessage("TX900000065", "승인되었습니다.")%>", "success");		 					
		 				}
		 			}        		        	
		 		});
	        }
    	}
 	}
    
    
    function fnDescPop(seq){		
		var tblParam = {};
		tblParam.seq = seq				
		
		var contentHtml = "";
		
		$.ajax({
			type : "post",
			url : '<c:url value="/cmm/systemx/secondCertDescInfo.do" />',
			datatype : "text",
			data : tblParam,
			success : function(data) {
				contentHtml = '<input type="text" id="descContent" placeholder="<%=BizboxAMessage.getMessage("TX900000066", "사유를 입력하지 않았습니다.")%>" class="puddSetup" pudd-style="width:100%;" value="' + data.desc + '" readonly="readonly"/>';
				
				var puddDialog = Pudd.puddDialog({
						width : 400
					,	header : {
							title : "<%=BizboxAMessage.getMessage("TX900000067", "해지사유")%>"
						,	align : "left"	// left, center, right						
					}
					,	body : {
							content : contentHtml
					}
					,	footer : {
				 
						buttons : [
							{
								attributes : {}// control 부모 객체 속성 설정
							,	controlAttributes : { id : "btnDesc", class : "submit" }// control 자체 객체 속성 설정
							,	value : "<%=BizboxAMessage.getMessage("TX000000078", "확인")%>"
							,	clickCallback : function( puddDlg ) {
									puddDialog.showDialog( false );
								}
							}
						]
					}
				});
			}
		});
 	}
    
    
    function setScAlert(msg, type){
		//type -> success, warning
		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';

		
		var puddDialog = Pudd.puddDialog({	
				width : 550	// 기본값 300
			,	message : {		 
					type : type
				,	content : titleStr
				},
		footer : {
			 
			buttons : [
				{
					attributes : {}// control 부모 객체 속성 설정
				,	controlAttributes : { id : "alertConfirm", class : "submit" }// control 자체 객체 속성 설정
				,	value : "<%=BizboxAMessage.getMessage("TX000000078", "확인")%>"
				}
			]
		}
		});			
		$( "#alertConfirm" ).click(function() {
			gridRead();
			puddDialog.showDialog( false );			
		});			
	
	}
    </script>
    
</head>

<!-- 검색 -->
<div class="top_box">
	<dl>
		<c:if test="${loginVO.userSe == 'MASTER'}">
			<dt><%=BizboxAMessage.getMessage("TX000018429","회사")%></dt>
			<dd>
<!-- 				<input id="com_sel"	> -->
				<div id="com_sel"></div>
			</dd>
		</c:if>
		<c:if test="${loginVO.userSe != 'MASTER'}">
<%-- 			<input id="com_sel" type="hidden" value="${loginVO.organId}"></input> --%>
			<div id="com_sel"></div>
		</c:if>
		
		<dt><%=BizboxAMessage.getMessage("TX000000989", "요청일")%></dt>
		<dd>
<!-- 			<input id="txtFrDt" class="dpWid"/> -->
			<input id="txtFrDt" type="text" class="puddSetup" pudd-type="datepicker" pudd-day-name="true" value="" />
			~
			<input id="txtToDt" type="text" class="puddSetup" pudd-type="datepicker" pudd-day-name="true" value="" />
<!-- 			<input id="txtToDt" class="dpWid"/> -->
		</dd>
		<dt style=""><%=BizboxAMessage.getMessage("TX900000058", "요청자(ID)")%></dt>
		<dd>
			<input id="reqId" type="text" value="" style="width: 152px;" onkeydown="if(event.keyCode==13){javascript:gridRead();}"/>
		</dd>		
		<dd>
			<input id="searchButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001289", "검색")%>" onclick="gridRead();"/>
		</dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724", "상세검색")%> <img id="all_menu_btn"
		src='/gw/Images/ico/ico_btn_arr_down01.png' /></span>
</div>

<div class="SearchDetail">
	<dl>
		<dt><%=BizboxAMessage.getMessage("TX000018400","승인상태")%></dt>
		<dd>
			<select class="puddSetup" pudd-style="width:100px;" id="status" />
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="P"><%=BizboxAMessage.getMessage("TX000012128","승인완료")%></option>
				<option value="R" selected="selected"><%=BizboxAMessage.getMessage("TX000018131","승인요청")%></option>
				<option value="C"><%=BizboxAMessage.getMessage("TX900000068","해지")%></option>				
			</select>
		</dd>		
		<dt class="ml25"><%=BizboxAMessage.getMessage("TX900000060", "인증기기 Type")%></dt>
		<dd>
			<select class="puddSetup" pudd-style="width:100px;" id="deviceType" />
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="Phone">Phone</option>		
				<option value="Tablet">Tablet</option>
			</select>
		</dd>
	</dl>
</div>


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">	
	<div class="btn_div">
        <div class="right_div">
            <input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000798", "승인")%>" disabled="disabled" id="btnApproval" onclick="fnSetStatus('P');"/>
            <input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000002954", "반려")%>" disabled="disabled" id="btnReject" onclick="fnSetStatus('C');"/>
        </div>
    </div>
	<div id="grid"></div>
</div>



</html>