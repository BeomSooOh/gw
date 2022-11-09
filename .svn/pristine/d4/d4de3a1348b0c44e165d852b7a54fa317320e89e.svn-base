<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script>

    var hidTabType = "TAB1";
    var hidConnectionYn = "N";
    var hidSavedYn = "N";
    var selectedPage=1;
    var atgSyncYn = "N";
    
	$(document).ready(function() {
		
		// 로딩이미지
		$(document).bind("ajaxStart", function () {
			kendo.ui.progress($("body"), true);
		}).bind("ajaxStop", function () {
			kendo.ui.progress($("body"), false);
		});			
		
		
		// 탭
		$("#tabstrip_in").kendoTabStrip({
			animation:  {
				open: {
					effects: ""
				}
			},
			select: onTabSelect
		});
		
	    //동기화방식 셀렉트박스
	    $("#syncType").kendoComboBox({
	        dataSource : {
				data : [{text:"<%=BizboxAMessage.getMessage("TX000022293","전체")%>", value:""},{text:"<%=BizboxAMessage.getMessage("TX000012459","수동")%>", value:"M"}, {text:"<%=BizboxAMessage.getMessage("TX000012458","자동")%>", value:"A"}]
	        },
	        change: fnSyncTypeChange,
	        dataTextField: "text",
	        dataValueField: "value",
	        value:"",
	        index:0
	    });
	    
	    //동기화방식 셀렉트박스
	    $("#syncUserStatus").kendoComboBox({
	        dataSource : {
				data : [{text:"<%=BizboxAMessage.getMessage("TX900000268","동기화대기(입사처리)")%>", value:"new"},{text:"<%=BizboxAMessage.getMessage("TX900000267","동기화대기(동일계정연결)")%>", value:"link"},{text:"<%=BizboxAMessage.getMessage("TX900000266","동기화불가(중복ID)")%>", value:"overlap"},{text:"<%=BizboxAMessage.getMessage("TX900000265","동기화완료")%>", value:"success"}, {text:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:""}]
	        },
	        change: fnSyncTypeChange,
	        dataTextField: "text",
	        dataValueField: "value",
	        value:"",
	        index:0
	    });	    
		
		$("button").kendoButton();
        
        //회사선택 selectBox
        compComInit();
        
        //기본정보 조회
        getLdapSetInfo();
	});
	
	function fnSyncTypeChange(){
		gridRead();
	}
	
	function init(){
		$("#adServerIp").val("");
		$("#syncWay").val("login");
		$("#adUserId").val("");			
		$("#adPassWord").val("");
		$("#adDomain").val("");
		$("#adDomainDir").val("");
		$("#adEmpOuDir").val("");
		$("#adDeptOuDir").val("");
		$("#deptOuType").val("S");
		$("[name=setMode]").show();
		$("[name=syncMode]").hide();
		$("[name=syncModeAtg]").hide();
		$("[name=syncModeGta]").hide();
		
		$("#adDomain").attr("disabled", false);
		$("#syncWay").attr("disabled", false);
		$("#adDomainDir").attr("disabled", false);
		$("#adDeptOuDir").attr("disabled", false);
		$("#deptOuType").attr("disabled", false);
		$("#adEmpOuDir").attr("disabled", false);
		
		$("#btnReset").hide();
		
	}
	
	function getLdapSetInfo(){
		var tblParam = {};
		tblParam.compSeq = $("#com_sel").val();
		
		$("#connectSuccess").hide();
		$("#connectFail").hide();
		hidConnectionYn = "N";
		hidSavedYn = "N";
		atgSyncYn = "N";
		$("#searchKeyword").val("");
		
		kendo.ui.progress($(".sub_contents"), true);
		
 		$.ajax({
        	type:"post",
    		url:'getLdapSetInfo.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {
    			
    			if(result.ldapSetInfo != null){
    				
        			$("[name=setMode]").show();
        			$("[name=syncMode]").hide();    				
        			$("[name=syncModeAtg]").hide();
        			$("[name=syncModeGta]").hide();
    				
    				$("#adServerIp").val(result.ldapSetInfo.adIp);
    				$("#syncWay").val(result.ldapSetInfo.syncMode);
    				$("#adUserId").val(result.ldapSetInfo.userid);
    				$("#adPassWord").val(result.ldapSetInfo.password);
    				$("#adDomain").val(result.ldapSetInfo.adDomain);
    				$("#adDomainDir").val(result.ldapSetInfo.baseDir);
    				$("#adEmpOuDir").val(result.ldapSetInfo.empDir);
    				$("#adDeptOuDir").val(result.ldapSetInfo.deptDir);
    				$("#deptOuType").val(result.ldapSetInfo.deptOuType);
    				
    				//disabled
    				$("#adDomain").attr("disabled", true);
    				$("#syncWay").attr("disabled", true);
    				$("#adDomainDir").attr("disabled", true);
    				$("#adDeptOuDir").attr("disabled", true);
    				$("#deptOuType").attr("disabled", true);
    				$("#adEmpOuDir").attr("disabled", true);
    				$("#btnReset").show();
    				
    				
    				hidSavedYn = "Y";
    				fnConnect("init");
    			}else{
    				init();
    			}
    			
    			setItemMode();
    			
    			kendo.ui.progress($(".sub_contents"), false);
    		} ,
		    error: function (result) {
		    		alert("<%=BizboxAMessage.getMessage("TX000002003", "작업이 실패했습니다.")%>");
		    		kendo.ui.progress($(".sub_contents"), false);
			}
		});
 		
	}	
	
	
	//회사선택 selectBox
	function compComInit() {
		var compSeqSel = $("#com_sel").kendoComboBox({
        	dataSource : ${compListJson},
            dataTextField: "compName",
            dataValueField: "compSeq",
            change: fnCompChange,
            value : "${params.compSeq}",
            index : 0
        }).data("kendoComboBox");
	}
	
	function fnCompChange(){
		$("#TAB1").click();
		getLdapSetInfo();
	}
	
	function onTabSelect(e){
		
		var type = e.item.id;
		
		hidTabType = type;
		
		if(hidTabType =="TAB1"){
			$("[name=setMode]").show();
			$("[name=syncMode]").hide();
			$("[name=syncModeAtg]").hide();
			$("[name=syncModeGta]").hide();
		}else{
			$("[name=setMode]").hide();
			$("[name=syncMode]").show();
			
			if(syncWay.value == "atg"){
				$("[name=syncModeAtg]").show();
				$("[name=syncModeGta]").hide();
				
				if($("#deptOuType").val() == "S"){
					$("#syncModeAtgOu").hide();
				}
				
			}else{
				$("[name=syncModeAtg]").hide();
				$("[name=syncModeGta]").show();
			}
			
			gridRead();
		}
    }
	
	function fnInputCheck(){
		
		if($("#adServerIp").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000264", "AD서버 IP를 입력해 주세요.")%>");
			$("#adServerIp").focus();
			return false;
		}
		
		if($("#adUserId").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000263", "AD접속 계정을 입력해 주세요.")%>");
			$("#adUserId").focus();
			return false;
		}
		
		if($("#adPassWord").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000262", "AD접속 패스워드를 입력해 주세요.")%>");
			$("#adPassWord").focus();
			return false;
		}
		
		if($("#adDomain").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000261", "AD도메인을 입력해 주세요.")%>");
			$("#adDomain").focus();
			return false;
		}
		
		if($("#adDomainDir").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000260", "AD도메인 경로를 입력해 주세요.")%>");
			$("#adDomainDir").focus();
			return false;
		}
		
		if($("#syncWay").val() == "gta" && $("#adDeptOuDir").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000259", "AD조직도연동 OU경로를 입력해 주세요.")%>");
			$("#adDeptOuDir").focus();
			return false;
		}
		
		if($("#syncWay").val() == "gta" && $("#adEmpOuDir").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000258", "AD 퇴사자이동 OU경로를 입력해 주세요.")%>");
			$("#adEmpOuDir").focus();
			return false;
		}
		
		return true;
	}
	
	function fnConnect(type){
		if(fnInputCheck()){

			var tblParam = {};
			tblParam.type = type;
			tblParam.compSeq = $("#com_sel").val();
			
			tblParam.adIp = $("#adServerIp").val();
			tblParam.syncMode = $("#syncWay").val();
			tblParam.userid = $("#adUserId").val();			
			tblParam.password = $("#adPassWord").val();
			tblParam.adDomain = $("#adDomain").val();
			tblParam.baseDir = $("#adDomainDir").val();
			
			tblParam.empDir = $("#adEmpOuDir").val();
			tblParam.deptDir = $("#adDeptOuDir").val();
			tblParam.deptOuType = $("#deptOuType").val();
			
			tblParam.loginIdSyncYn = "Y";
			tblParam.loginPasswdSyncYn = "Y";
			tblParam.emailSyncYn = "Y";
			tblParam.addrSyncYn = "Y";
			tblParam.telNumSyncYn = "Y";
			tblParam.useYn = "Y";
			
	 		$.ajax({
	        	type:"post",
	    		url:'ldapConnectionCheckSave.do',
	    		datatype:"json",
	            data: tblParam ,
	            async: true,
	    		success: function (result) {
    				if(result != null && result.resultCode == "SUCCESS"){
    					$("#connectSuccess").show();
    					$("#connectFail").hide();
    					hidConnectionYn = "Y";
    					
    					if(type == "save"){
    						
    	    				$("#adDomain").attr("disabled", true);
    	    				$("#syncWay").attr("disabled", true);
    	    				$("#adDomainDir").attr("disabled", true);
    	    				$("#adDeptOuDir").attr("disabled", true);
    	    				$("#deptOuType").attr("disabled", true);
    	    				
    	    				if($("#syncWay").val() == "atg" && $("#deptOuType").val() == "S"){
    	    					$("#adEmpOuDir").attr("disabled", false);
    	    				}else{
    	    					$("#adEmpOuDir").attr("disabled", true);
    	    				}
    	    				
    	    				$("#btnReset").show();    						
    						
    						hidSavedYn = "Y";
    						$("#btnReset").show();
    					}
    				}else{
    					$("#connectSuccess").hide();
    					$("#connectFail").show();
    					hidConnectionYn = "N";
    				}
    				
					if(result != null && result.resultCode == "input"){
						$("#adDomain").attr("disabled", false);
						$("#syncWay").attr("disabled", false);
						$("#adDomainDir").attr("disabled", false);
						$("#adDeptOuDir").attr("disabled", false);
						$("#deptOuType").attr("disabled", false);
						$("#adEmpOuDir").attr("disabled", false);        	
					}
	    			
	    			if(type != "init"){
	    				alert(result.result);	
	    			}
	    			
	    		} ,
			    error: function (result) {
	    			if(type != "init"){
	    				alert("<%=BizboxAMessage.getMessage("TX000002003", "작업이 실패했습니다.")%>");	
	    			}			    	
				}
			});			
			
		}
	}
	
	function fnSyncPop(){
		
		if(hidSavedYn == "N"){
			alert("<%=BizboxAMessage.getMessage("TX900000256", "기본정보를 저장해 주세요.")%>");
			return;
		}
		
		if(hidConnectionYn == "N"){
			alert("<%=BizboxAMessage.getMessage("TX900000257", "AD서버에 연결할 수 없습니다.\\n기본정보 설정을 확인해 주세요.")%>");
			return;
		}
		
		if(syncWay.value == "atg"){
			var width = 500;
			var height = 400;
			var windowX = Math.ceil( (window.screen.width  - width) / 2 );
			var windowY = Math.ceil( (window.screen.height - height) / 2 );
			window.open("/gw/systemx/ldapSyncPop.do?compSeq=" + $("#com_sel").val(), "ldapSyncPop", "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=no");
		}else{
			var width = 500;
			var height = 400;
			var windowX = Math.ceil( (window.screen.width  - width) / 2 );
			var windowY = Math.ceil( (window.screen.height - height) / 2 );
			window.open("/gw/systemx/ldapSyncPop.do?compSeq=" + $("#com_sel").val(), "ldapSyncPop", "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=no");				
		}		
	}
	
	function fnAutoSyncSetPop(){
		
		if(hidSavedYn == "N"){
			alert("<%=BizboxAMessage.getMessage("TX900000256", "기본정보를 저장해 주세요.")%>");
			return;
		}		
		
		var width = 690;
		var height = 313;
		var windowX = Math.ceil( (window.screen.width  - width) / 2 );
		var windowY = Math.ceil( (window.screen.height - height) / 2 );
		window.open("/gw/systemx/ldapSyncAutoSetPop.do?compSeq=" + $("#com_sel").val(), "ldapSyncAutoSetPop", "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=no");		
	}
	
	function fnReset(){
		
		if(!confirm("<%=BizboxAMessage.getMessage("TX900000255", "AD서버 동기화 기록 및 부서/사원 연동키가 삭제됩니다.\\n초기화 하시겠습니까?")%>")){
			return;
		}
		
		var tblParam = {};
		tblParam.compSeq = $("#com_sel").val();
		
 		$.ajax({
        	type:"post",
    		url:'resetLdapSetInfo.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {
    			getLdapSetInfo();
    		} ,
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003", "작업이 실패했습니다.")%>");
			}
		});			
	}
	
	function gridDataBound(e) {
	    var grid = e.sender;
	    if (grid.dataSource.total() == 0) {
	        var colCount = grid.columns.length;
	        $(e.sender.wrapper)
	            .find('tbody')
	            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><%=BizboxAMessage.getMessage("TX000017974", "데이터가 존재하지 않습니다.")%></td></tr>');
	    }
	};	
	
	function onCheckAll(chkbox) {
	    if (chkbox.checked == true) {
	    	checkAll('chkLdapUser', true)
	    } else {
	    	checkAll('chkLdapUser', false)
	    } 
	}
	
	
	 function gridRead() {
		 
		selectedPage = 1;
		
		$("#syncModeAtgNew").hide();
		$("#syncModeAtgLink").hide();
		$("#syncModeAtgNewAll").hide();
		$("#syncModeAtgLinkAll").hide();
		
		$("#grid").html("");

		if(syncWay.value == "atg"){
			
			if(syncUserStatus.value == "new" || syncUserStatus.value == "link"){
				
				if(syncUserStatus.value == "new"){
					$("#syncModeAtgNew").show();
					$("#syncModeAtgNewAll").show();
				}else{
					$("#syncModeAtgLink").show();
					$("#syncModeAtgLinkAll").show();
				}
				
				 var grid = $("#grid").kendoGrid({
					 dataSource: dataSource('atg'),
				     navigatable: true,
		   	  		scrollable: true,
		   	  		columnMenu: false,
		   	  		autoBind: true,
		   	  		height: 440,
		   	  		page: selectedPage,
			   	  	pageable: {         
			            change: function (e){
			                selectedPage = e.index;            
			            },          
				 		refresh: true,
				    	pageSizes: [10, 20, 50, 100]
			        },
					dataBound: function(e){ 

					},	   	  		
		   	  		columns: [
	   							{
	   								field:"선택", 
	   								title:"", 
	   								width:34, 
	   								headerTemplate: '<input type="checkbox" id="chkAll" onclick="onCheckAll(this)" />', 
	   								headerAttributes: {style: "text-align:center;vertical-align:middle;"},
	   								template: '<input type="checkbox" name ="chkLdapUser"  value="#=syncSeq#" />',
	   								attributes: {style: "text-align:center;vertical-align:middle;", clickevent : "N"},
	   						  		sortable: false
	   				  			},
				                { field: "syncStatus", title: "<%=BizboxAMessage.getMessage("TX000005461", "연동상태")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "loginId", title: "<%=BizboxAMessage.getMessage("TX000016308", "로그인계정")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "empName", title: "<%=BizboxAMessage.getMessage("TX000018661", "이름")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "emailAddr", title: "<%=BizboxAMessage.getMessage("TX000000949", "메일주소")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "mobileTelNum", title: "<%=BizboxAMessage.getMessage("TX000000008", "핸드폰")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "telNum", title: "<%=BizboxAMessage.getMessage("TX000000073", "전화번호")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "gwDeptName", title: "<%=BizboxAMessage.getMessage("TX900000253", "그룹웨어연동부서")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "syncDate", title: "<%=BizboxAMessage.getMessage("TX900000254", "연동일자")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "errorMsg", title: "<%=BizboxAMessage.getMessage("TX000000644", "비고")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false}
			           		]
				 }).data("kendoGrid");						
				
			}else{
				 var grid = $("#grid").kendoGrid({
					 dataSource: dataSource('atg'),
				     navigatable: true,
		   	  		scrollable: true,
		   	  		columnMenu: false,
		   	  		autoBind: true,
		   	  		height: 440,
		   	  		page: selectedPage,
			   	  	pageable: {         
			            change: function (e){
			                selectedPage = e.index;            
			            },          
				 		refresh: true,
				    	pageSizes: [10, 20, 50, 100]
			        },
					dataBound: function(e){ 

					},	   	  		
		   	  		columns: [
				                { field: "syncStatus", title: "<%=BizboxAMessage.getMessage("TX000005461", "연동상태")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "loginId", title: "<%=BizboxAMessage.getMessage("TX000016308", "로그인계정")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "empName", title: "<%=BizboxAMessage.getMessage("TX000018661", "이름")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "emailAddr", title: "<%=BizboxAMessage.getMessage("TX000000949", "메일주소")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "mobileTelNum", title: "<%=BizboxAMessage.getMessage("TX000000008", "핸드폰")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "telNum", title: "<%=BizboxAMessage.getMessage("TX000000073", "전화번호")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "gwDeptName", title: "<%=BizboxAMessage.getMessage("TX900000253", "그룹웨어연동부서")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "syncDate", title: "<%=BizboxAMessage.getMessage("TX900000254", "연동일자")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false},
				                { field: "errorMsg", title: "<%=BizboxAMessage.getMessage("TX000000644", "비고")%>", /*width:200,*/ headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: false}
			           		]
				 }).data("kendoGrid");						
			}			
		
		}else{
		
			 var grid = $("#grid").kendoGrid({
				 dataSource: dataSource('gta'),
			     navigatable: true,
	   	  		scrollable: true,
	   	  		columnMenu: false,
	   	  		autoBind: true,
	   	  		height: 440,
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
			             	syncInfoPop(selectedItem.syncSeq);
			            });	
					}
				},	   	  		
	   	  		columns: [
			                { field: "syncDate", title: "<%=BizboxAMessage.getMessage("TX900000061", "요청일시")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "syncMode", title: "<%=BizboxAMessage.getMessage("TX900000244", "동기화방식")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "deptNew", title: "<%=BizboxAMessage.getMessage("TX900000247", "부서(등록)")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},  
			                { field: "deptMod", title: "<%=BizboxAMessage.getMessage("TX900000248", "부서(수정)")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true }, 
			                { field: "deptDel", title: "<%=BizboxAMessage.getMessage("TX900000249", "부서(삭제)")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "empNew", title: "<%=BizboxAMessage.getMessage("TX900000250", "사원(등록)")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},  
			                { field: "empMod", title: "<%=BizboxAMessage.getMessage("TX900000251", "사원(수정)")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true }, 
			                { field: "empDel", title: "<%=BizboxAMessage.getMessage("TX900000252", "사원(삭제)")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "empName", title: "<%=BizboxAMessage.getMessage("TX000000761", "요청자")%>", headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true}
		           		]
			 }).data("kendoGrid");

		}		 
		 

	 }

	 var selectedDeptSeq = "";
	 var selectedType = "";
	 
	 function empDeptInfoPop() {
			
		$("#compFilter").val($("#com_sel").val());
		$("input[seq='deptFlag']").val("");

		var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		$("#callback").val("callbackSel");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
		frmPop.submit();
		pop.focus(); 
    } 
	 
    function callbackSel(data) {
    	if(data.returnObj.length > 0){
    		selectedDeptSeq = data.returnObj[0].deptSeq;
    		setTimeout(function(){fnSyncProc(selectedType);}, 300);
    	}
  	}	 
	 
	function fnSyncProc(type){
		
    	if(type == 'check' && $("input:checked[name='chkLdapUser']").length == 0){
    		alert("<%=BizboxAMessage.getMessage("TX000020276","선택 된 항목이 없습니다.")%>");
    		return;
    	}
		
    	if(type == 'all' && $("input[name='chkLdapUser']").length == 0){
    		alert("<%=BizboxAMessage.getMessage("TX900000246", "조회된 항목이 없습니다.")%>");
    		return;
    	}
    	
    	var paramData = {};
    	
    	if($("#syncWay").val() == "atg" && $("#deptOuType").val() == "S"){
    		
    		if(selectedDeptSeq == ''){
    			selectedType = type;
        		empDeptInfoPop();
        		return;    			
    		}else{
    			paramData.selectedDeptSeq = selectedDeptSeq;
    			selectedDeptSeq = "";
    		}
    		
    	}
    	
    	if(type == 'check'){
     		if(!confirm("<%=BizboxAMessage.getMessage("TX000006312", "반영하시겠습니까?")%>")){
     			return;	
     		}    		
    	}else{
     		if(!confirm("<%=BizboxAMessage.getMessage("TX900000245", "전체 반영하시겠습니까?")%>")){
     			return;	
     		}    		    		
    	}
        
        paramData.chkLdapUser = "";
        paramData.compSeq = $("#com_sel").val();
        paramData.syncUserStatus = syncUserStatus.value;
        
        if(type == 'check'){
            $.each($("input:checked[name='chkLdapUser']"), function( index, value ) {
            	paramData.chkLdapUser += (index != 0 ? "," : "") + "'" + value.value + "'";
            });        	
        }else{
        	paramData.chkLdapUser = "all";
        }
        
        kendo.ui.progress($(".sub_contents"), true);
        
	   	 $.ajax({
		     	type:"post",
		 		url:'ldapAtgProc.do',
	            datatype: "json",
	            data: paramData,
		 		success: function (data) {
					if(data.result == "success"){
						alert("<%=BizboxAMessage.getMessage("TX000002019", "반영되었습니다.")%>");
						gridRead();
					}else{
						alert("<%=BizboxAMessage.getMessage("TX000003440", "반영 중 오류가 발생했습니다.")%>");
						gridRead();
						kendo.ui.progress($(".sub_contents"), false);
					}
				},
				error: function (result) {
					alert("<%=BizboxAMessage.getMessage("TX000003440", "반영 중 오류가 발생했습니다.")%>");
					kendo.ui.progress($(".sub_contents"), false);
		 		}
		 	});	         
	}
	 
	 function syncInfoPop(syncSeq){
		 window.open("/gw/systemx/ldapSyncDetailListPop.do?syncSeq=" + syncSeq, "ldapSyncDetailListPop", "width=1000,height=530,scrollbars=yes");
	 }
 
	function dataSource(syncWay){
		
		if(syncWay == 'atg'){
			
			return new kendo.data.DataSource({
		        serverPaging: true,
		        pageSize: 10,
		         transport: { 
		             read:  {
		                 url: 'ldapAtgUserList.do',
		                 dataType: "json",
		                 type: 'post'
		             },
		             parameterMap: function(options, operation) {
		                 options.compSeq = $("#com_sel").val();
		                 options.atgSyncYn = atgSyncYn;
		                 options.syncStatus = $("#syncUserStatus").val();
		                 options.empSearchName = $("#searchKeyword").val();
		                 atgSyncYn = "Y";
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
			
		}else{
			
			return new kendo.data.DataSource({
		        serverPaging: true,
		        pageSize: 10,
		         transport: { 
		             read:  {
		                 url: 'ldapSyncDetailList.do',
		                 dataType: "json",
		                 type: 'post'
		             },
		             parameterMap: function(options, operation) {
		                 options.compSeq = $("#com_sel").val();
		                 options.syncType = $("#syncType").val();
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
			
		}
	}	 
	
	function setItemMode(){
		
		if($("#syncWay").val() == "atg" && $("#deptOuType").val() == "S"){
			$("[name=adEmpOuDirS]").show();
			$("[name=adEmpOuDirM]").hide();
			$("#adEmpOuDir").attr("disabled", false);
		}else{
			$("[name=adEmpOuDirS]").hide();
			$("[name=adEmpOuDirM]").show();
		}
		
	}

</script>
<input type="hidden" id="hidChkId"/>
<input type="hidden" id="hidTabType"/>

<div class="top_box">
	<dl class="dl1">
        <c:if test="${not empty compListJson}">
        <dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
        <dd><input id="com_sel"/></dd>
        </c:if>	
        
		<dt name="syncModeGta" style="display:none;"><%=BizboxAMessage.getMessage("TX900000244", "동기화방식")%></dt>
		<dd name="syncModeGta" style="display:none;"><input type="text" class="" id="syncType" name="syncType"  style="width:160px;" /></dd>
		
		<dt name="syncModeAtg" style="display:none;"><%=BizboxAMessage.getMessage("TX000005461", "연동상태")%></dt>
		<dd name="syncModeAtg" style="display:none;"><input type="text" class="" id="syncUserStatus" name="syncUserStatus"  style="width:160px;" /></dd>
		
		<dt name="syncModeAtg" style="display:none;"><%=BizboxAMessage.getMessage("TX000016214","사원/ID검색")%></dt>
		<dd name="syncModeAtg" style="display:none;"><input type="text" id="searchKeyword" name="searchKeyword" style="width:160px;" onkeydown="if(event.keyCode==13){javascript:gridRead();}"/></dd>		
		
		<dd name="syncMode" style="display:none;"><input type="button" id="textButton" onclick="javascript:gridRead();" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
	</dl>
</div>

<div class="controll_btn pt10 posi_ab" style="right:20px;">
	<div name="setMode">
		<button id="btnReset" type="button" onclick="fnReset();" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX000002960","초기화")%></button>
		<button type="button" onclick="fnConnect('save');" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	</div>
	<button name="syncModeGta" type="button" onclick="fnSyncPop();" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX000020528","조직도 동기화")%></button>
	<button name="syncModeGta" type="button" onclick="fnAutoSyncSetPop();" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX000020529","자동 동기화 설정")%></button>
	
	<button name="syncModeAtg" id="syncModeAtgNew" type="button" onclick="fnSyncProc('check');" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX900000243", "입사처리(선택)")%></button>
	<button name="syncModeAtg" id="syncModeAtgNewAll" type="button" onclick="fnSyncProc('all');" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX900000242", "입사처리(전체)")%></button>
	<button name="syncModeAtg" id="syncModeAtgLink" type="button" onclick="fnSyncProc('check');" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX900000241", "동일계정연결(선택)")%></button>
	<button name="syncModeAtg" id="syncModeAtgLinkAll" type="button" onclick="fnSyncProc('all');" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX900000240", "동일계정연결(전체)")%></button>
	<button name="syncModeAtg" id="syncModeAtgOu" type="button" onclick="fnSyncPop();" class="k-button" style="display:none;"><%=BizboxAMessage.getMessage("TX900000239", "조직구성단위(OU) 설정")%></button>
</div>

<div id="tabstrip_in" class="tab_style">
	<ul class="pt10 mb10">
		<li id="TAB1" class="k-state-active"><%=BizboxAMessage.getMessage("TX000004661", "기본정보")%></li>
		<li id="TAB2"><%=BizboxAMessage.getMessage("TX900000238", "조직도연동")%></li>
	</ul>
</div><!-- //tabstrip_in -->

<div name="setMode">
	<div class="com_ta">
		<table>
			<colgroup>
				<col width="15%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="35%"/>
			</colgroup>
			
			<tr>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX900000237", "AD 서버 IP")%></th>
				<td>
					<input type="text" style="width:100%;" value="" name="adServerIp" id="adServerIp"/>
				</td>
				<th><%=BizboxAMessage.getMessage("TX900000236", "AD연동방향")%></th>
				<td>
					<select style="width:100%;" id="syncWay" onchange="setItemMode();" name="syncWay">
						<option value="login"><%=BizboxAMessage.getMessage("TX900000235", "로그인")%></option>
						<option value="atg"><%=BizboxAMessage.getMessage("TX900000234", "AD -> 그룹웨어")%></option>
						<option value="gta"><%=BizboxAMessage.getMessage("TX900000233", "그룹웨어 -> AD")%></option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX900000232", "AD 접속계정")%></th>
				<td>
					<input type="text" style="width:100%;" value="" name="adUserId" id="adUserId"/>
				</td>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX900000231", "AD 접속패스워드")%></th>
				<td>
					<input autocomplete="new-password" type="password" style="width:100%;" value="" name="adPassWord" id="adPassWord"/>
				</td>
			</tr>			
			
			<tr>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX900000230", "AD 도메인")%></th>
				<td>
					<input type="text" style="width:100%;" value="" name="adDomain" id="adDomain"/>
				</td>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX900000229", "AD 도메인경로")%></th>
				<td>
					<input type="text" style="width:100%;" value="" name="adDomainDir" id="adDomainDir"/>
					<p class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX900000228", "*도메인 distinguishedName 값 입력")%></p>
					<p class="text_blue f11 mt5">(ex : DC=douzone,DC=com)</p>
				</td>
			</tr>
			
			<tr>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX900000227", "AD 조직도연동 OU경로")%></th>
				<td>
					<input type="text" style="width:100%;" value="" name="adDeptOuDir" id="adDeptOuDir"/>
					<p class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX900000226", "*조직도OU distinguishedName 값 입력")%></p>
					<p class="text_blue f11 mt5">(ex : OU=BizboxAlphaOrg,DC=douzone,DC=com)</p>		
				</td>
				<th><%=BizboxAMessage.getMessage("TX900000225", "AD 조직도 연동타입")%></th>
				<td>
					<select style="width:100%;" onchange="setItemMode();" id="deptOuType" name="deptOuType">
						<option value="S"><%=BizboxAMessage.getMessage("TX900000224", "단일 OU구성")%></option>
						<option value="M"><%=BizboxAMessage.getMessage("TX900000223", "다중 OU구성")%></option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /><text name="adEmpOuDirS"><%=BizboxAMessage.getMessage("TX000000067", "부서코드")%></text><text name="adEmpOuDirM"><%=BizboxAMessage.getMessage("TX900000222", "AD 퇴사자이동 OU경로")%></text> 
				</th>
				<td>
					<input type="text" style="width:100%;" value="" name="adEmpOuDir" id="adEmpOuDir"/>
					<p name="adEmpOuDirS" class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX900000221", "*그룹웨어 연동부서코드 (입사처리 부서)")%></p>
					<p name="adEmpOuDirM" class="text_blue f11 mt5"><%=BizboxAMessage.getMessage("TX900000220", "*퇴사자이동OU distinguishedName 값 입력")%></p>
					<p name="adEmpOuDirM" class="text_blue f11 mt5">(ex : OU=BizboxAlphaUser,DC=douzone,DC=com)</p>
					
				</td>
				<th><%=BizboxAMessage.getMessage("TX000016178", "연결확인")%></th>
				<td>
					<div class="controll_btn p0 fl">
						<button onclick="fnConnect('check');" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0"><%=BizboxAMessage.getMessage("TX000000078", "확인")%></button>
					</div>
					<span style="display:none;" class="lh24 ml10 text_blue" id="connectSuccess"><%=BizboxAMessage.getMessage("TX900000219", "! 연결 되었습니다")%></span>
					<span style="display:none;" class="lh24 ml10 text_red" id="connectFail"><%=BizboxAMessage.getMessage("TX900000218", "! 연결 되지 않았습니다")%></span>				
				</td>
			</tr>				
		</table>
	</div>
</div>

<div name="syncMode">
	<div id="grid" class="com_ta2"></div>
</div>

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





















