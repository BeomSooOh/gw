<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>	
	
<script type="text/javascript">
	var selectedPage=1;
	var optionValue = "${optionValue}";
	
	
	$(document).ready(function() {
		//기본버튼
	    $(".controll_btn button").kendoButton();
		$("#btnSelDept").kendoButton();
	    
        $("#btnNew").click(function () { fnNew(); });
        $("#btnSave").click(function () { fnSave(); });
        $("#btnDel").click(function () { fnDel(); });
        $("#btnSearch").click(function () { fnSearch(); });
        $("#btnSelDept").click(function () { fnUserDeptPop(); });
		
			    
	    //var ddlUseYn = NeosCodeUtil.getCodeList("ADDR001");
	    var ddlUseYn = NeosCodeUtil.getCodeMultiList("ADDR001",langCode.toLowerCase());
	    $("#tdSearchUseYn").kendoComboBox({
	        dataSource : ddlUseYn,
	        dataTextField: "CODE_NM",
	        dataValueField: "CODE",
	        index: 0
	    });
	    
	    if("${authDiv}" != "USER")
	    	$("#authDiv").html("<%=BizboxAMessage.getMessage("TX000010881","관리자 등록건 보기")%>");
	    else
	    	$("#authDiv").html("<%=BizboxAMessage.getMessage("TX000010880","내가 등록한 그룹 보기")%>");
	    
	    
	    var ddlDivType = NeosCodeUtil.getCodeMultiList("mp0007",langCode.toLowerCase());
	    var dataSource = [{
			"CODE_EN": "",
			"CODE_NM": "<%=BizboxAMessage.getMessage("TX000000862","전체")%>",
			"CODE_ID": "mp0007",
			"CODE_DC": null,
			"CODE": "0"
		}];
		
		if(ddlDivType){
			dataSource = dataSource.concat(ddlDivType);	
		}
		
		    $("#ddlGroupDiv1").kendoComboBox({
		        dataSource : dataSource,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        value: "0"
		    });
	    
		fnNew();
	    ControlInit();
	    BindListGrid();
	    ddlGroupChange();	    
    });//document ready end  
	
    
	function ddlGroupChange(){
    	curValue = getAddrGroupDiv();

    	if(curValue == 10 ){
    		$("#groupDivC").prop("checked","checked")
			$("#openArea").val("${list.compName}"); 	
			$("#hidGbnList").val("c");
			$("#hidSeqList").val("${compSeq}");
			$("#btnSelDept").hide();
			$("#openAreaimg").hide();
    	}
    	else if(curValue == 20){
    		$("#groupDivO").prop("checked","checked")
			$("#openArea").val(""); 	
			$("#hidGbnList").val("b");
			$("#hidSeqList").val("");
			$("#btnSelDept").show();
			$("#openAreaimg").show();
    	}
    	else if(curValue == 50){
			$("#openArea").val(""); 	
			$("#hidGbnList").val("c");
			$("#hidSeqList").val("");
			$("#btnSelDept").show();
			$("#openAreaimg").show();
    	}
    	else if(curValue == 30 ){
    		$("#groupDivU").prop("checked","checked")
			$("#openArea").val("${list.empName}"); 	
			$("#hidGbnList").val("m");
			$("#hidSeqList").val("${empSeq}");
			$("#btnSelDept").hide();
			$("#openAreaimg").hide();
    	}
    }	
    
    
    function ControlInit(){
    	$("#openAreaimg").hide();
    	
    	$("#groupDivU").prop("checked","checked")
    	
    	$("#txtGroupNm").val("");
    	$("#openArea").val("");
    	$("#txtGroupDesc").val("");
    	document.getElementById("useYn_Y").checked = true;
    	document.getElementById("useYn_N").checked = false;
	    	
    	$("#hidGroupId").val("0");
    	$("#hidempSeq").val("");
    	$("#hidcompSeq").val("");
    	$("#hidGbnList").val("");
    	$("#hidSeqList").val("");
    	
    	$("#btnSelDept").hide();
    	$("#btnMove").hide();
    	
    	$("#hidSeqList").val("0");
    	
    	$("#txtGroupNm").attr("readonly", false);
		$("#txtGroupDesc").attr("readonly", false);
		
		$("#selectedItems").val("");
		$("#orderNum").val("");
    }
    
    
  //전체 체크박스 
	function onCheckAll(chkbox) {
		
		var grid = $("#grid").data("kendoGrid");
			
	    if (chkbox.checked == true) {
	    	checkAll(grid, 'chkAddrSel', true);
	    	
	    } else {
	    	checkAll(grid, 'chkAddrSel', false);
	    }
	};
	
	/**
	* 체크박스 선택
	* @param checks
	* @param isCheck
	*/
	function checkAll(grid, checks, isCheck){
		var fobj = document.getElementsByName(checks);
		var style = "";
		if(fobj == null) return;
		if(fobj.length){
			for(var i=0; i < fobj.length; i++){
				if(fobj[i].disabled==false){
					fobj[i].checked = isCheck;
					CommonKendo.setChecked(grid, fobj[i]);
				}
			}
		}else{
			if(fobj.disabled==false){
				fobj.checked = isCheck;
			}
		}
	}
    
    
	//grid셋팅
    function BindListGrid(){
    	ControlInit();
		var grid = $("#grid").kendoGrid({
			columns: [
						{
							field:"chkbox", 
							width:34, 
							headerTemplate: '<input type="checkbox" name="checkAll" id="checkAll" class="k-checkbox" onclick="onCheckAll(this)"><label class="k-checkbox-label radioSel" for="checkAll"></label>', 
							headerAttributes: {style: "text-align:center;vertical-align:middle;"},
							template: '<input type="checkbox" name="chkAddrSel" seq="#=addr_group_seq#" id="#=addr_group_seq#" userEmpSeq="#=userEmpSeq#" create_seq="#=create_seq#" value="#=addr_group_seq#" class="k-checkbox"/><label id="lb_#=addr_group_seq#" class="k-checkbox-label radioSel" for="#=addr_group_seq#"></label>',
							attributes: {style: "text-align:center;vertical-align:middle;"},
								sortable: false
						},
			  			{
					  		title:"<%=BizboxAMessage.getMessage("TX000000214","구분")%>",
					  		field:"addr_group_tp_nm",
					  		width:60, 
					  		headerAttributes: {style: "text-align: center;"}, 
					  		attributes: {style: "text-align: center;"},
			  			},
			  			{
			  				title:"<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>",
			  				field:"addr_group_nm",
					  		headerAttributes: {style: "text-align: center;"}, 
					  		attributes: {style: "text-align: center;"},
			  			},
			  			{
			  				title:"<%=BizboxAMessage.getMessage("TX000005901","주소록수")%>",
			  				field:"cntAddr",
							width:80, 
					  		headerAttributes: {style: "text-align: center;"}, 
					  		attributes: {style: "text-align: center;"},
			  			},
			  			{
			  				title:"<%=BizboxAMessage.getMessage("TX000000637","등록자 ")%>" + "(ID)",
			  				field:"create_nm2",
					  		width:100, 
					  		headerAttributes: {style: "text-align: center;"}, 
					  		attributes: {style: "text-align: center;"},
			  			},
			  			{
			  				title:"<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>",
			  				field:"use_yn2",
					  		width:100, 
					  		headerAttributes: {style: "text-align: center;"}, 
					  		attributes: {style: "text-align: center;"},
			  			}
			  			
					],
					dataSource: dataSource,
					height:295,
					selectable: "single",
					groupable: false,
					columnMenu:false,
					editable: false,
					sortable: true,
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
							
							//선택 item
							var selectedItem = e.sender.dataItem(e.sender.select());
							
							//데이타 조회 fucntion 호출
							fnSetGroupInfo(selectedItem);
						});		
						
						if("${authDiv}" == "USER"){
							var checkedBox = $("input:checkbox[name='chkAddrSel']");							
							checkedBox.each(function (index,val){	
								if($(this).attr("create_seq") != $(this).attr("userEmpSeq")){
									var seq = $(this).attr("seq");
									$("#" + seq).remove();
									$("#lb_" + seq).remove();
								}
							});	
						}
					}				    
				}).data("kendoGrid");
	}
	
	function fnNew(){
		ControlInit();
		ddlGroupChange();
		$("#btnSave").show();
		$("#hidIU").val("I");
		
		
		$("#groupDivO").prop("disabled", false);
		$("#groupDivU").prop("disabled", false);
		if("${optionValue}" == "1" || "${authDiv}" != "USER"){
			$("#groupDivC").prop("disabled", false);
		}else{
			$("#groupDivC").prop("disabled", true);
		}
		
// 		$("#ddlGroupDiv").data("kendoComboBox").enable(true);
	}
	
	function fnSave(){
		
		if($("#txtGroupNm").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000005902","그룹명은 필수 입력입니다.")%>");
			return false;
		}
		
		if($("#hidSeqList").val() == "" || $("#hidSeqList").val() == null){
			alert("<%=BizboxAMessage.getMessage("TX000010878","공개범위를 지정해 주세요")%>");
			return false;
		}
		
		if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
			var tblParam = {};
			
			tblParam.addr_group_id = $("#hidGroupId").val();
		    tblParam.addr_group_tp = getAddrGroupDiv();
		    tblParam.addr_group_nm = $("#txtGroupNm").val();
		    tblParam.addr_group_desc = $("#txtGroupDesc").val();
		    tblParam.gbnList = $("#hidGbnList").val();
		    tblParam.seqList = $("#hidSeqList").val();
		    tblParam.orderNum = $("#orderNum").val() == "" ? "999" : $("#orderNum").val();
		    
		    if(getAddrGroupDiv() == "10")
		    	tblParam.selectedItems = "${compSeq}";
		    else
		    	tblParam.selectedItems = $("#selectedItems").val();	
		    
		    if(document.getElementById("useYn_Y").checked)
		    	tblParam.useYn = 'Y';
		    else
		    	tblParam.useYn = 'N';
		    
		    $.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/mp/addr/InsertAddrGroupInfo.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (cnt) {
	    				fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000002120","저장 되었습니다.")%>","success",1500)
	    				ControlInit();
	    				BindListGrid();
	    				fnNew();
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	 
		    
		}
		
	    
	}
	
	function fnSearch(){
		BindListGrid();
		fnNew();
	}
	
	function fnSetGroupInfo(data){
		
		setAddrGroupDiv(data.addr_group_tp);	
		
		
		$("#txtGroupNm").val(data.addr_group_nm);
		$("#txtGroupDesc").val(data.addr_group_desc);
		$("#hidGroupId").val(data.addr_group_seq);
		$("#hidIU").val("U");
		$("#hidCntAddr").val(data.cntAddr);
		$("#orderNum").val(data.order_num);
		
		if(data.use_yn == 'Y'){
			document.getElementById("useYn_Y").checked = true;
			document.getElementById("useYn_N").checked = false;
		}
		else{
			document.getElementById("useYn_Y").checked = false;
			document.getElementById("useYn_N").checked = true;
		}
	
		if(data.addr_group_tp == "20" || data.addr_group_tp == "50"){
			$("#btnSelDept").show();
			$("#openAreaimg").show();
		}
		else{
			$("#btnSelDept").hide();
			$("#openAreaimg").hide();
		}
			
		if(data.create_seq == "${empSeq}" || "${authDiv}" != "USER"){
			$("#btnNew").show();
			$("#btnSave").show();
			
			$("#txtGroupNm").attr("readonly", false);
			$("#txtGroupDesc").attr("readonly", false);
		}
		else{
			$("#btnNew").show();
			$("#btnSave").hide();
			
			$("#txtGroupNm").attr("readonly", true);
			$("#txtGroupDesc").attr("readonly", true);
		}
		
		
		if(data.addr_group_tp == "20" || data.addr_group_tp == "50")
		{
			var tblParam = {};
			tblParam.addr_group_seq = data.addr_group_seq;
			
			$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/mp/addr/getAddrPublic.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (data) {
	    				var list = data.list;
	    				var orgNmList = "";
	    				var orgDivList = "";
	    				var orgSeqList = "";	    
	    				var selectedItems = "";
	    				for(var i=0;i<list.length;i++){
	    					orgNmList += "," + list[i].emp_name;
	    					orgDivList += "," + list[i].org_div;
	    					orgSeqList += "," + list[i].org_seq;
	    					selectedItems += "," + list[i].selectedItems;
	    				}
	    				$("#openArea").val(orgNmList.substring(1));
	    				$("#hidGbnList").val(orgDivList.substring(1));
	    				$("#hidSeqList").val(orgSeqList.substring(1));
	    				$("#selectedItems").val(selectedItems.substring(1));
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});
		
		}
		else if(data.addr_group_tp == "10"){
			setAddrGroupDiv("10");
			$("#openArea").val("${list.compName}"); 	
			$("#hidGbnList").val("c");
			$("#hidSeqList").val("${compSeq}");
			$("#selectedItems").val("");
		}
    	
		else if(data.addr_group_tp == "30"){
			setAddrGroupDiv("30");
			$("#openArea").val(data.create_nm); 	
			$("#hidGbnList").val("m");
			$("#hidSeqList").val(data.create_seq);
			$("#selectedItems").val("");
		}
		
		$("#groupDivC").prop("disabled", true);
		$("#groupDivO").prop("disabled", true);
		$("#groupDivU").prop("disabled", true);
	}
	
	var dataSource = new kendo.data.DataSource({
	   	  serverPaging: true,
	   	  pageSize: 10, 
	   	  transport: {
	   	    read: {
	   	      type: 'post',
	   	      dataType: 'json',
	   	      url: '<c:url value="/cmm/mp/addr/getAddrGroupList.do"/>'
	   	    },
	   	    parameterMap: function(data, operation) {
	   	    	data.txtSearchGroupNm = $("#txtSearchGroupNm").val();
	   	    	data.addrGroupTp = $("#ddlGroupDiv1").val();
	   	    	if($("#tdSearchUseYn").data("kendoComboBox").value() != 'ALL')
	   	    		data.useYN = $("#tdSearchUseYn").data("kendoComboBox").value();
	   	    	if(document.getElementById("my_addr").checked)
	   	    		data.chkMyGroup = "1";
	   	    	return data ;
	   	    }
	   	  },
	   	  schema: {
	   	    data: function(response) {
	   	      return response.list;
	   	    },
	   	 	total: function(response) {
			        return response.totalCount;
		      	}
	   	  }
 	  });
	
	
	function fnDel(){
		
		var checkedBox = $("input:checkbox[name='chkAddrSel']:checked");	
		
		if(checkedBox.length == "0"){
			alert("<%=BizboxAMessage.getMessage("TX900000295","삭제할 항목을 선택해주세요.")%>");
			return false;
		}else{
			if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>\n<%=BizboxAMessage.getMessage("TX900000296","(주소록 그룹에 포함된 주소록은 일괄 삭제처리 됩니다.)")%>")){
				var tblParam = {};
				
				var arrGroupSeqList = "";
	    		
    			
    			$("input:checkbox[name='chkAddrSel']:checked").each(function (index,val){	
    				arrGroupSeqList += ",'" + $(this).attr("seq") + "'";
				});	
    			arrGroupSeqList = arrGroupSeqList.substring(1);
				tblParam.arrGroupSeqList = arrGroupSeqList;
				
				$.ajax({
		        	type:"post",
		    		url:'<c:url value="/cmm/mp/addr/DeleteAddrGroupListInfo.do"/>',
		    		datatype:"json",
		            data: tblParam ,
		    		success: function (cnt) {
		    				fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000002121","삭제 되었습니다.")%>","success",1500)
		    				ControlInit();
		    				BindListGrid();
		    				fnNew();
		    		    } ,
				    error: function (result) { 
				    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
				    		}
		    	});	
			}
			else
				return false;
		}
		
		
	}
	
	
	//공개범위 선택팝업
	function fnUserDeptPop () {
// 		var url = "/gw/cmm/systemx/cmmOcType1Pop.do?callback=callbackSel";
//     	var pop = window.open("", "pop", "width=668,height=606,scrollbars=no");
// 		frmPop.target = "pop";
// 		frmPop.method = "post";
// 		frmPop.action = url; 
// 		frmPop.submit(); 
// 		frmPop.target = ""; 
//     	pop.focus();  
		
		if(getAddrGroupDiv() == "50")
			$("#selectMode").val("oc");		
		else
			$("#selectMode").val("ud");

		var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		$("#callback").val("callbackSel");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
		frmPop.submit();
		pop.focus(); 
     }

	//담당자 선택팝업 콜백함수
	function callbackSel(data) {
   		var txtUserDept = "";
   		var gbnList = "";
   		var seqList = "";
   		
//    		for(var i=0;i<arr.length;i++){
//    			if(arr[i].empSeq == null){
//    				if(arr[i].deptSeq == null){
//    					txtUserDept += "," + arr[i].compName;
//    					gbnList += "," + arr[i].gbn;
//    					seqList += "," + arr[i].seq;
//    				}
// 				else{
// 					txtUserDept += "," + arr[i].deptName;
// 					gbnList += "," + arr[i].gbn;
//    					seqList += "," + arr[i].seq;
// 				}
   					
//    			}
//    			else{
//    				txtUserDept += "," + arr[i].empName;
//    				gbnList += "," + arr[i].gbn;
// 				seqList += "," + arr[i].seq;
//    			}
//    				if(arr[i].gbn == "c"){
//    					txtUserDept += "," + arr[i].compName;
// 					gbnList += "," + arr[i].gbn;
// 					seqList += "," + arr[i].seq;
//    				}
//    				else if(arr[i].gbn == "d"){
//    					txtUserDept += "," + arr[i].deptName;
// 					gbnList += "," + arr[i].gbn;
//     				seqList += "," + arr[i].seq;
//    				}
//    				else if(arr[i].gbn == "m"){
//    					txtUserDept += "," + arr[i].empName;
//     				gbnList += "," + arr[i].gbn;
//  					seqList += "," + arr[i].seq;
//    				}
//    		}
//    		$("#hidGbnList").val(gbnList.substring(1));
// 		$("#hidSeqList").val(seqList.substring(1));
//    		$("#openArea").val(txtUserDept.substring(1));
   		var selectedItems = "";
   		
   		if(data.returnObj.length > 0 ){
   			
   			if(getAddrGroupDiv() == "20"){
	   			for(var i=0;i<data.returnObj.length;i++){
	   				if(data.returnObj[i].empDeptFlag == "c"){
	   					txtUserDept += "," + data.returnObj[i].compName;
						gbnList += "," + data.returnObj[i].empDeptFlag;
						seqList += "," + data.returnObj[i].compSeq;
						selectedItems += "," + data.returnObj[i].superKey;
	   				}
	   				else if(data.returnObj[i].empDeptFlag == "d"){
	   					txtUserDept += "," + data.returnObj[i].deptName;
						gbnList += "," + data.returnObj[i].empDeptFlag;
	    				seqList += "," + data.returnObj[i].deptSeq;
	    				selectedItems += "," + data.returnObj[i].groupSeq + "|" + data.returnObj[i].compSeq + "|" + data.returnObj[i].deptSeq + "|0|d";
	   				}
	   				else if(data.returnObj[i].empDeptFlag == "u"){
	   					txtUserDept += "," + data.returnObj[i].empName;
	    				gbnList += ",m";
	 					seqList += "," + data.returnObj[i].empSeq;
	 					selectedItems += "," + data.returnObj[i].groupSeq + "|" + data.returnObj[i].compSeq + "|" + data.returnObj[i].deptSeq + "|" + data.returnObj[i].empSeq + "|u";
	   				}	   				
	   			}
   			}
   			
   			else if(getAddrGroupDiv() == "50"){
	   			for(var i=0;i<data.returnObj.length;i++){
   					txtUserDept += "," + data.returnObj[i].compName;
					gbnList += ",c";
					seqList += "," + data.returnObj[i].selectedId;
					selectedItems += "," + + data.returnObj[i].groupSeq + "|" + data.returnObj[i].compSeq + "|0|0|c";
	   			}
   			}
   		}
   		
   		$("#hidGbnList").val(gbnList.substring(1));
		$("#hidSeqList").val(seqList.substring(1));
   		$("#openArea").val(txtUserDept.substring(1));
   		$("#selectedItems").val(selectedItems.substring(1));
  }   
	
	
	function getAddrGroupDiv(){
		if($("#groupDivC").prop("checked")){
			return 10;
		}else if($("#groupDivO").prop("checked")){
			return 20;
		}else if($("#groupDivU").prop("checked")){
			return 30;
		}
	}
	
	
	function setAddrGroupDiv(div){
		if(div == "10"){
			$("#groupDivC").prop("checked","checked")
		}else if(div == "20"){
			$("#groupDivO").prop("checked","checked")
		}else if(div == "30"){
			$("#groupDivU").prop("checked","checked")
		} 
	}
	
	function fnSetSnackbar(msg, type, duration){
		var puddActionBar = Pudd.puddSnackBar({
			type	: type
		,	message : msg
		,	duration : 1500
		});
	}
</script>
			<!-- 검색박스 -->
			<div class="top_box">
				


				
				<input type="hidden" id="hidGroupId" name="hidGroupId" value="0"/>
				<input type="hidden" id="hidempSeq" name="hideempSeq"/>
				<input type="hidden" id="hidcompSeq" name="hidcompSeq"/>
				<input type="hidden" id="hidGbnList" name="hidGbnList"/>
				<input type="hidden" id="hidSeqList" name="hideSeqList"/>
				<input type="hidden" id="hidIU" value="I"/>
				<input type="hidden" id="hidCntAddr" value="0"/>
				<dl>					
					<dt class="ar en_w70" style="width:50px;"><%=BizboxAMessage.getMessage("TX000000214","구분")%></dt>
					<dd><input id="ddlGroupDiv1" class="kendoComboBox" style="width:80px" onchange="BindListGrid();"/></dd>
				
					<dt><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
					<dd><input id="tdSearchUseYn" class="kendoComboBox" style="width:100px" onchange="fnSearch();"/></dd>
					
					<dt class="ar en_w70" style="width:60px;"><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></dt>
					<dd><input type="text" style="width:150px" id="txtSearchGroupNm" onkeydown="if(event.keyCode==13){javascript:fnSearch();}"/></dd>
					
					<dd>
						<input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
					</dd>
				</dl>
			</div>
			

			<!-- 컨텐츠내용영역 -->
			<div class="sub_contents_wrap">

				<div class="btn_div m0">
					<div class="left_div">
						<div id="" class="pt15">
							<input type="checkbox" name="inp_chk" id="my_addr" class="k-checkbox" onclick="fnSearch();"> <label class="k-checkbox-label chkSel" for="my_addr" id="authDiv"></label>
						</div>
					</div>
					<div class="right_div">
						<!-- 컨트롤버튼영역 -->
						<div class="controll_btn">
						<button id="btnNew"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
						<button id="btnSave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
						<button id="btnMove"><%=BizboxAMessage.getMessage("TX000003021","이동")%></button>
						<button id="btnDel"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
					</div>	
					</div>
				</div>
				
				<div class="twinbox">
					<table style="min-height: auto;">
						<colgroup>
							<col width="50%" />
							<col />
						</colgroup>
						<tr>
							<td class="twinbox_td">
								<!-- 그리드 리스트 -->
								<div id="grid"></div>
							</td>
							<td class="twinbox_td">
								<div class="com_ta">
									<table>
										<colgroup>
											<col width="30%" />
											<col />
										</colgroup>
										<tr>
<%-- 											<th><%=BizboxAMessage.getMessage("TX000005900","그룹구분")%></th> --%>
<!-- 											<td><input type="text" id="ddlGroupDiv" style="width:180px;" /></td> -->
											
											
											<th><%=BizboxAMessage.getMessage("TX000005900","그룹구분")%></th>
											<td>
<!-- 												<input type="radio" name="groupDiv" id="groupDivU" class="k-radio" checked="checked"> -->
<!-- 												<label class="k-radio-label" for="groupDivU">개인</label>		 -->
<!-- 												<input type="radio" name="groupDiv" id="groupDivO" class="k-radio" onclick="ddlGroupChange();"> -->
<!-- 												<label class="k-radio-label ml10" for="groupDivO">공용</label>	 -->
<!-- 												<input type="radio" name="groupDiv" id="groupDivC" class="k-radio"> -->
<!-- 												<label class="k-radio-label ml10" for="groupDivC">회사</label> -->
												
												
												
												<input type="radio" name="groupDiv" id="groupDivU" value="30" class="k-radio" checked="checked" onclick="ddlGroupChange();" /> 
												<label class="k-radio-label radioSel" for="groupDivU"><%=BizboxAMessage.getMessage("TX000002835","개인")%></label>
												<input type="radio" name="groupDiv" id="groupDivO" value="20" class="k-radio" onclick="ddlGroupChange();" /> 
												<label class="k-radio-label radioSel" for="groupDivO"><%=BizboxAMessage.getMessage("TX000002836","공용")%></label>
<%-- 												<c:if test="${optionValue == '1' || authDiv != 'USER' }"> --%>
												<input type="radio" name="groupDiv" id="groupDivC" value="10" class="k-radio" onclick="ddlGroupChange();" /> 
												<label class="k-radio-label radioSel" for="groupDivC"><%=BizboxAMessage.getMessage("TX000018429","회사")%></label>
<%-- 												</c:if> 											 --%>
											</td>
											
										</tr>
										<tr>
											<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
											<td><input type="text" style="width:90%;" placeholder="<%=BizboxAMessage.getMessage("TX000016368","그룹명을 입력해주세요")%>" id="txtGroupNm"/></td>
										</tr>
										<tr>
											<th><img src="../../../Images/ico/ico_check01.png" alt="" id="openAreaimg"/> <%=BizboxAMessage.getMessage("TX000000707","공개범위")%></th>
											<td>
												<input type="text" style="width:90%;" placeholder="<%=BizboxAMessage.getMessage("TX000016377","공개범위를 선택해주세요")%>" readonly="readonly" id="openArea"/>
												<button id="btnSelDept"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
											</td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000935","그룹설명")%></th>
											<td><input type="text" style="width:90%;" id="txtGroupDesc"/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
											<td><input type="text" style="width:90%;" id="orderNum" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'/></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
											<td>
												<input type="radio" name="erp_u1u2" id="useYn_Y" class="k-radio" checked="checked">
												<label class="k-radio-label radioSel" for="useYn_Y"><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
												<input type="radio" name="erp_u1u2" id="useYn_N" class="k-radio">
												<label class="k-radio-label radioSel ml10" for="useYn_N"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</div>
				
									
			</div><!-- //sub_contents_wrap -->
			
			
			<form id="frmPop" name="frmPop"> 
<!-- 					<input type="hidden" id="type" name="type" value="" />  -->
<!-- 					<input type="hidden" id="moduleType" name="moduleType" value="ed" /> -->
<!-- 					<input type="hidden" id="selectType" name="selectType" value="m" /> -->
<!-- 					<input type="hidden" id="selectedList" name="selectedList" value="" /> -->
<!-- 					<input type="hidden" id="selectedOrgList" name="selectedOrgList" value="" /> -->
<!-- 					<input type="hidden" id="duplicateOrgList" name="duplicateOrgList" value ="" /> -->

			
						<input type="hidden" name="selectedItems" id="selectedItems" value="" />
						<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do" />
						<input type="hidden" name="selectMode" id="selectMode" value="ud" />
						<input type="hidden" name="selectItem" value="m" />
						<input type="hidden" id="callback" name="callback" value="" />
						<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 

				</form>
