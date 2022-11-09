<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%
/**
 * 
 * @title 메뉴관리 화면
 * @author UC개발부
 * @since 2015. 7. 23.
 * @version 
 * @dscription 메뉴를 관리 하는 화면
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2015. 7. 23.  한용일        최초 생성
 
 *
 */
%>
<script>

var userSe = '${loginVO.userSe}';
var langCode = '${loginVO.langCode}';
var buildType = '${buildType}';

$(document).ready(function() {
	//기본버튼
	$(".controll_btn button").kendoButton();
	
	// 탭
	$("#tabstrip_in").kendoTabStrip({
		animation:  {
			open: {
				effects: ""
			}
		},
		select: onTabSelect
	});	
	

    //기본 탭 선택
    var tabToActivate = $("#USER");
    $("#tabstrip_in").kendoTabStrip().data("kendoTabStrip").activateTab(tabToActivate);
    $("#hidType").val("USER");

    fnComboBoxInit();

	$(function () {
        //Text 버튼
        $(function () {
            // 버튼 이벤트
            // 신규
            $("#btnNew").click(function () { fnNew(); });
            // 저장
            $("#btnSave").click(function () { fnSave(); });
            // 삭제
            $("#btnDel").click(function () { fnDel(); });
            
            $('input[type=radio][name=ssoUseYn]').on('change', function() {
                if($(this).val() == "Y"){
                	$('[name=ssoSection]').show();
                }else{
                	$('[name=ssoSection]').hide();
                }
           });            
            
        });
    });
	
	$('[name=ssoSection]').hide();
});

// Tab select
function onTabSelect(e){
	var type = e.item.id;
	 $("#hidType").val(type);
	
    fnComboBoxInit();
}

// ComboBox init
function fnComboBoxInit(){
	
	var type = $("#hidType").val();
	var topMenuList = [];
	
	$.ajax({
        type:"post",
        url:'<c:url value="/cmm/system/getAllTopMenuList.do" />',
        data:{menuAuthType: type},
        datatype:"json",
        async:false,
        success:function(data){
        	topMenuList = data.list;
        }
    });		
	    
   	$("#upperMenuNo").kendoComboBox();
   	$("#subMenuNo").kendoComboBox();
   	
	// 메뉴 구분 ComboBox
	$("#cboMenuGubun").kendoComboBox({
		dataSource : topMenuList,
		dataTextField: "menuNm",
		dataValueField: "menuGubun",
		change :  sel_gubun,
		index: 0
	});	    
	
	var ddlActType  = NeosCodeUtil.getCodeList("COM518");
	var CODE_NM = buildType == "cloud" ? getCodeName(langCode) : "CODE_NM";
	
	// 메뉴 구분 ComboBox
	$("#urlGubun").kendoComboBox({
		dataSource : ddlActType,
		dataTextField: CODE_NM,
		dataValueField: "CODE",
		index: 0
	});	
	
	var coCombobox = $("#urlGubun").data("kendoComboBox");
	
	if(buildType == 'cloud'){
		if(CODE_NM == 'CODE_EN'){
			coCombobox.dataSource.insert(0, { "CODE_EN": "<%=BizboxAMessage.getMessage("TX000010822","선택안함")%>", "CODE": "" });
		}else if(CODE_NM == 'CODE_CN'){
			coCombobox.dataSource.insert(0, { "CODE_CN": "<%=BizboxAMessage.getMessage("TX000010822","선택안함")%>", "CODE": "" });
		}else if(CODE_NM == 'CODE_KR'){
			coCombobox.dataSource.insert(0, { "CODE_KR": "<%=BizboxAMessage.getMessage("TX000010822","선택안함")%>", "CODE": "" });
		}else if(CODE_NM == 'CODE_JP'){
			coCombobox.dataSource.insert(0, { "CODE_JP": "<%=BizboxAMessage.getMessage("TX000010822","선택안함")%>", "CODE": "" });
		}else{
			coCombobox.dataSource.insert(0, { "CODE_NM": "<%=BizboxAMessage.getMessage("TX000010822","선택안함")%>", "CODE": "" });
		}
	}else{
		coCombobox.dataSource.insert(0, { "CODE_NM": "<%=BizboxAMessage.getMessage("TX000010822","선택안함")%>", "CODE": "" });
	}

	coCombobox.refresh();
	coCombobox.select(0);
	
    sel_gubun();
    
}

var menuGubun ="";
var treeViewLeft= null;

// 메뉴 구분 ComboBox change
function sel_gubun(){
		
	var type = $("#hidType").val();
	menuGubun = $("#cboMenuGubun").val();
	$("#menuGubun").val(menuGubun);
	$.ajax({
        type:"post",
        url:'<c:url value="/selectTreeMenu.do" />',
        data:{menuGubun:menuGubun, type: type},
        datatype:"html",            
        success:function(data){
            $("#menu_tree").html(data);
            
        }
    });	 
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/system/menuInfoView.do"/>',
		data:{"menuNo":0,"menuGubun":menuGubun, type: type},
		datatype:"text",
		success:function(data){	
			
		 	if(data.upperMenuList){
	 		 	$("#upperMenuNo").kendoComboBox({
		 		dataSource : data.upperMenuList,
		 		dataTextField: "upperMenuNm",
		 		dataValueField: "upperMenuNo",
		 		index:0
		 		});	 
		 	}

			$("#hidUpperMenuNo").val($("#upperMenuNo").val());
			
			fnNew();
		}
	});
} 	

// Tree select
function onSelect(e){
	
	var dataItem = this.dataItem(e.node);
	
		
	var menu_no = dataItem.seq;
	var menuGubun = $("#cboMenuGubun").val();
	var type = $("#hidType").val();
	$("#ssoEncryptKeyLength").html("");
	
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/system/menuInfoView.do"/>',
		data:{"menuNo":menu_no,"menuGubun":menuGubun, "type":type},
		datatype:"text",
		success:function(data){
			
			if(data.menuMap){
				$('#menuNo').val(data.menuMap.menuNo);    //메뉴코드
				$('#menuNameKr').val(data.menuMap.menuNmKr);  //메뉴명(한국어)
				$('#menuNameEn').val(data.menuMap.menuNmEn);  //메뉴명(영어)
				$('#menuNameJp').val(data.menuMap.menuNmJp);  //메뉴명(일본어)
				$('#menuNameCn').val(data.menuMap.menuNmCn);  //메뉴명(중국어)
				$('#urlPath').val(data.menuMap.urlPath);  //URL
				$("#urlGubun").data("kendoComboBox").value(data.menuMap.urlGubun);
				$('input:radio[name="useChk"]:radio[value="'+ data.menuMap.useYn + '"]').prop("checked",true);
				$("#menuDc").val(data.menuMap.menuDc);
				$("#menuOrdr").val(data.menuMap.menuOrdr);
				$("#upperMenuNo").data("kendoComboBox").value(data.menuMap.upperMenuNo);
				
				//최상위메뉴 기본메뉴설정
				if(data.menuMap.upperMenuNo != null && data.menuMap.upperMenuNo == 0 && $("#hidType").val() == 'USER'){
					
		 		 	$("#subMenuNo").kendoComboBox({
				 		dataSource : data.subMenuList,
				 		dataTextField: "menuNm",
				 		dataValueField: "menuNo",
				 		index:0
				 		});	 					
					
					$("#subMenuNo").data("kendoComboBox").value(data.menuMap.openMenuNo);					
					$("#subMenu").show();
					$("#upperMenu").hide();
				}
				else{
					$("#subMenu").hide();
					$("#upperMenu").show();
				}
				
				$('input:radio[name="publicYn"]:radio[value="'+ data.menuMap.publicYn + '"]').prop("checked",true);
				
				if(data.menuMap.ssoUseYn == "Y" && data.ssoInfo != null){
					$('[name=ssoSection]').show();
					$('input:radio[name="ssoUseYn"]:radio[value="Y"]').prop("checked",true);
					$('input:radio[name="ssoType"]:radio[value="'+ data.ssoInfo.ssoType + '"]').prop("checked",true);
					$('#ssoEmpCtlName').val(data.ssoInfo.ssoEmpCtlName);
					$('#ssoLogincdCtlName').val(data.ssoInfo.ssoLogincdCtlName);
					$('#ssoCoseqCtlName').val(data.ssoInfo.ssoCoseqCtlName);
					$('#ssoErpempnoCtlName').val(data.ssoInfo.ssoErpempnoCtlName);
					$('#ssoErpcocdCtlName').val(data.ssoInfo.ssoErpcocdCtlName);
					
					$('#ssoEtcCtlName').val(data.ssoInfo.ssoEtcCtlName);
					$('#ssoEtcCtlValue').val(data.ssoInfo.ssoEtcCtlValue);
					
					$("#ssoEncryptType").val(data.ssoInfo.ssoEncryptType);
					$('#ssoEncryptKey').val(data.ssoInfo.ssoEncryptKey);
					$("#ssoTimeLink").val(data.ssoInfo.ssoTimeLink);
					
					$.each($("input[name=encChkSel]"), function(i, v){
						if(data.ssoInfo.ssoEncryptScope.substring(i,i+1)=="1") $(v).prop("checked", true);
					});
					
					ssoEncryptTypeChange();
					
				}else{
					$('[name=ssoSection]').hide();
					$('input:radio[name="ssoUseYn"]:radio[value="N"]').prop("checked",true);
					$('input:radio[name="ssoType"]:radio[value="GET"]').prop("checked",true);
					$('#ssoEmpCtlName').val("");
					$('#ssoLogincdCtlName').val("");
					$('#ssoCoseqCtlName').val("");
					$('#ssoErpempnoCtlName').val("");
					$('#ssoErpcocdCtlName').val("");
					
					$('#ssoEtcCtlName').val("");
					$('#ssoEtcCtlValue').val("");
					
					$("#ssoEncryptType").val("");
					$('#ssoEncryptKey').val("");
					$("#ssoTimeLink").val("");
					$("input[name='encChkSel']").prop("checked",false);
				}
				
				$("#compList").val(data.compNameList);
				$("#hidSelectOrgId").val(data.compSeqList);
				$("#hidOrginUseYn").val(data.menuMap.useYn);
				chkPublic(data.menuMap.publicYn);
				 
				 var combobox = $("#upperMenuNo").data("kendoComboBox");
				 combobox.enable(false);

			}
		}
	});
	
}; 

// 신규 초기화
function fnNew() {
	
	
	$('#menuNo').val("");    //메뉴코드
	$('#menuNameKr').val("");  //메뉴명(한국어)
	$('#menuNameEn').val("");  //메뉴명(영어)
	$('#menuNameJp').val("");  //메뉴명(일본어)
	$('#menuNameCn').val("");  //메뉴명(중국어)
	$('#urlPath').val("");  //URL
	$('input:radio[name="useChk"]:radio[value="Y"]').prop("checked",true);
	$("#menuDc").val("");
	$("#menuOrdr").val("");
	$("#upperMenuNo").data("kendoComboBox").value($("#hidUpperMenuNo").val());
	$("#compList").val("");
	$("#hidOrginUseYn").val("");
	
	$('input:radio[name="ssoUseYn"]:radio[value="N"]').prop("checked",true);
	$('input:radio[name="ssoType"]:radio[value="GET"]').prop("checked",true);
	$("#ssoEmpCtlName").val("");
	//$("#ssoPwdCtlName").val("");
	$("#ssoLogincdCtlName").val("");
	$("#ssoCoseqCtlName").val("");
	$("#ssoErpempnoCtlName").val("");
	$("#ssoErpcocdCtlName").val("");
	
	$("#ssoEtcCtlName").val("");
	$("#ssoEtcCtlValue").val("");
	
	$("#ssoEncryptType").val("");
	$("#ssoEncryptKey").val("");
	$("#ssoTimeLink").val("00");
	$("input[name='encChkSel']").prop("checked",false);
	
	$("#subMenu").hide();
	$("#upperMenu").show();			
	
	 var combobox = $("#upperMenuNo").data("kendoComboBox");
	 combobox.enable(true);
	
	//selected treeview cancle
	var treeview = $("#treeview").data("kendoTreeView");
	if(treeview != null){
		treeview.select().find("span.k-state-selected")
		        .removeClass("k-state-selected");
	}
	chkPublic("Y");
	$("#ssoEncryptKeyLength").html("");
}

//저장
function fnSave() {
	if($("#upperMenuNo").data("kendoComboBox").value() == "") {
		alert("<%=BizboxAMessage.getMessage("TX000010821","상위메뉴를 선택해 주세요")%>");
		$("#upperMenuNo").focus();
		return;
	}
	
	if($("#menuNameKr").val() == "") {
// 		alert("메뉴명을 입력해주세요.");
		alert("! <%=BizboxAMessage.getMessage("TX000010857","필수 값이 입력되지 않았습니다")%>");
		$("#menuNameKr").focus();
		return;
	}

    if($(':radio[name="publicYn"]:checked').val() == "N"){
    	if($("#compList").val() == ""){
//     		alert("메뉴 사용범위를 선택해주세요.");
    		alert("<%=BizboxAMessage.getMessage("TX000010857","필수 값이 입력되지 않았습니다")%>");
    		$("#compList").focus();
    		return false;
    	}
    }
    
    //암호화키 Byte체크 (16/24/32만가능)
    if($(':radio[name="ssoUseYn"]:checked').val() == "Y" && $("[name=encChkSel]:checked").length > 0){
    	
    	var ssoEncryptKeyByteLength = unescape(encodeURIComponent($("#ssoEncryptKey").val())).length;
    	
    	if($("#ssoEncryptType").val() == "AES128" && ssoEncryptKeyByteLength != 16){
    		alert("<%=BizboxAMessage.getMessage("TX900000109","AES128(CBC) 암호화키는 16 Byte만 사용 가능합니다.")%>");
    		setByteLength();
    		$("#ssoEncryptKey").focus();
    		return;  		
    		
    	}else if($("#ssoEncryptType").val() == "AES128_ECB" && ssoEncryptKeyByteLength != 16 && ssoEncryptKeyByteLength != 24 && ssoEncryptKeyByteLength != 32){
    		alert("<%=BizboxAMessage.getMessage("TX900000110","AES128(ECB) 암호화키는 16/24/32 Byte만 사용 가능합니다.")%>");
    		setByteLength();
    		$("#ssoEncryptKey").focus();
    		return;
    		
    	}else if($("#ssoEncryptType").val() == "AES256" && ssoEncryptKeyByteLength != 16 && ssoEncryptKeyByteLength != 24 && ssoEncryptKeyByteLength != 32){
    		alert("<%=BizboxAMessage.getMessage("","AES256(CBC) 암호화키는 16/24/32 Byte만 사용 가능합니다.")%>");
    		setByteLength();
    		$("#ssoEncryptKey").focus();
    		return;
    		
    	}        	
    }

	var nameList = {};
	var arrName = [];


	nameList.menuNm = $("#menuNameKr").val();
	nameList.langKind = "kr";
	arrName.push(nameList);

	
	nameList = {};
	nameList.menuNm = $("#menuNameEn").val();
	nameList.langKind = "en";
	arrName.push(nameList);



	nameList = {};
	nameList.menuNm = $("#menuNameJp").val();
	nameList.langKind = "jp";
	arrName.push(nameList);


	nameList = {};
	nameList.menuNm = $("#menuNameCn").val();
	nameList.langKind = "cn";
	arrName.push(nameList);

	
	var tblParam = {};
	tblParam.menuNo = $("#menuNo").val() || "0";    // 메뉴번호
	tblParam.upperMenuNo = $("#upperMenuNo").val(); // 상위메뉴번호
	if($("#subMenuNo").val() != "")
		tblParam.openMenuNo = $("#subMenuNo").val(); // 기본메뉴
	tblParam.menuNmList = JSON.stringify(arrName);  // 메뉴명 리스트
	tblParam.urlPath = $("#urlPath").val();  // 메뉴 url
	tblParam.urlGubun = $("#urlGubun").val();  // 메뉴 url 구분
	tblParam.useChk = $(':radio[name="useChk"]:checked').val(); // 사용여부
	tblParam.publicYn = $(':radio[name="publicYn"]:checked').val(); // 공개여부
	tblParam.menuDc = $("#menuDc").val();    // 설명
	tblParam.menuOrdr = $("#menuOrdr").val(); // 정렬
	tblParam.menuGubun = $("#menuGubun").val(); //메뉴 구분
	tblParam.orgIds = $("#hidSelectOrgId").val();  // 사용범위 회사 리스트
	tblParam.type =  $("#hidType").val();   // Tab 타입 (USER or 관리자)
	tblParam.ssoUseYn =  $(':radio[name="ssoUseYn"]:checked').val();  //sso 사용여부
	tblParam.ssoType = $(':radio[name="ssoType"]:checked').val();  //sso 연동방식
	tblParam.ssoEmpCtlName = $("#ssoEmpCtlName").val();
	tblParam.ssoPwdCtlName = "";//$("#ssoPwdCtlName").val();
	tblParam.ssoLogincdCtlName = $("#ssoLogincdCtlName").val();
	tblParam.ssoCoseqCtlName = $("#ssoCoseqCtlName").val();
	tblParam.ssoErpempnoCtlName = $("#ssoErpempnoCtlName").val();
	tblParam.ssoErpcocdCtlName = $("#ssoErpcocdCtlName").val();
	
	tblParam.ssoEtcCtlName = $("#ssoEtcCtlName").val();
	tblParam.ssoEtcCtlValue = $("#ssoEtcCtlName").val() != "" ? $("#ssoEtcCtlValue").val() : "";
	
	tblParam.ssoEncryptType = $("#ssoEncryptType").val();
	tblParam.ssoEncryptKey = $("#ssoEncryptKey").val();
	tblParam.ssoTimeLink = $("#ssoTimeLink").val();
	var ssoEncryptScope=""; 
	
	$.each($("input[name=encChkSel]"), function(i, v){
		if(v.checked)
			ssoEncryptScope += "1";
		else 
			ssoEncryptScope+="0";
	});
	tblParam.ssoEncryptScope = ssoEncryptScope;
	
    var useChk = $(':radio[name="useChk"]:checked').val();
    var hidOrginUseYn = $("#hidOrginUseYn").val();
    
    if(hidOrginUseYn == "Y" && useChk == "N"){
    	var childCnt =  fnChildCnt(tblParam);
    	if(childCnt == 999){
    		alert("<%=BizboxAMessage.getMessage("TX000010820","하위메뉴 카운트 가져오는중 오류가 발생하였습니다")%>");
    		return;
    	}
    	if(childCnt > 0 ){
    		var isDel = confirm("<%=BizboxAMessage.getMessage("TX000010819","하위 메뉴가 존재합니다. (미사용으로 변경 시 하위메뉴 사용 불가)")%>");
    		if(!isDel) return;
    	}
    }
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/system/insertMenu.do"/>',
		data:tblParam,
		datatype:"json",
		success:function(data){
			if(data.resultMsg) {
				if(data.resultMsg == "success"){
					alert("<%=BizboxAMessage.getMessage("TX000015756","저장하였습니다.")%>");
					
					//대메뉴추가
					if(tblParam.menuNo == "0" && tblParam.upperMenuNo == "0"){
						fnComboBoxInit();
					}else{
						sel_gubun();	
					}
					
				}else if(data.resultMsg == "fail"){
					alert("<%=BizboxAMessage.getMessage("TX000002596","저장에 실패하였습니다")%>");
				}
			}	
		},error:function(data){
			alert("<%=BizboxAMessage.getMessage("TX000002596","저장에 실패하였습니다")%>");
		}
	});
}

// 삭제
function fnDel() {
	
	if($("#menuNo").val() == '') {
		alert("<%=BizboxAMessage.getMessage("TX000007574","메뉴를 선택해주세요.")%>");
		return;
	}
	
	var tblParam = {};
	tblParam.menuNo = $("#menuNo").val();
	tblParam.type = $("#hidType").val();
	
	var childCnt =  fnChildCnt(tblParam);
	if(childCnt == 999){
		alert("<%=BizboxAMessage.getMessage("TX000010820","하위메뉴 카운트 가져오는중 오류가 발생하였습니다")%>");
		return;
	}
	if(childCnt > 0 ){
		alert("        ! <%=BizboxAMessage.getMessage("TX000010818","하위 메뉴가 존재합니다. 하위 메뉴를 먼저 삭제 하신 후 진행하세요.")%>");
		return;
	}
	if(confirm("! <%=BizboxAMessage.getMessage("TX000010817","삭제 시 해당 메뉴를 사용할 수 없습니다. 선택한 메뉴를 삭제 하시겠습니까?")%>")){
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/system/deleteMenu.do"/>',
			data: tblParam,
			datatype:"json",
			success:function(data){
				if(data.result){
					if(data.result == "success") {
						alert("<%=BizboxAMessage.getMessage("TX000014096","삭제하였습니다.")%>");
						
						//대메뉴 삭제
						if($("#upperMenuNo").val() == "0"){
							fnComboBoxInit();							
						}else{
							sel_gubun();	
						}
						
					}
				}
			},error:function(data){
				 alert("<%=BizboxAMessage.getMessage("TX000010815","삭제하는데 실패하였습니다")%>");
			}
		});
	};
	
}

// 하위메뉴 카운트 조회 
function fnChildCnt(tblParam){
	var cnt = 999;
	try {
		$.ajax({
			type :"post",
			url : '<c:url value="/cmm/system/getChildCnt.do"/>',
			data : tblParam,
			datatype :"json",
			async: false,
			success:function(data){		
				cnt = data.resultCnt;
			},error:function(data){
				
			}
		});
	}catch (e) {

    }
	return cnt;
}
//메뉴 사용범위 선택 팝업
function fncOpenOcPop(){
	
	window.open("", "openOcPop", "width=300,height=510,scrollbars=no") ;
	
    var frmData = document.openOcPop;
    
	$('#openOcPop input[name="selectedItems"]').val($('#hidSelectOrgId').val());
	
	frmData.submit();
	
}

//메뉴 사용범위 선택 callback
function fnCallbackData(data) {
	
	var orgListName = '';
	var orgListId = '';
	var len = data.returnObj.length;
	
	$.each(data.returnObj , function (idx,val) {		
		if(idx == len - 1) {
			orgListName += val.compName;
			orgListId += val.selectedId;
		}else{
			orgListName += val.compName+',';
			orgListId += val.selectedId+',';
		}
	});
	
	$('#compList').val(orgListName);
	$('#hidSelectOrgId').val(orgListId);
}

function chkPublic(value){

	var publicYn = $(':radio[name="publicYn"]:checked').val(); // 공개여부
	$('input:radio[name="publicYn"]:radio[value="'+ value + '"]').prop("checked",true);
	if(value == "Y") {
		$("#divCompList").hide();
		$( "td.tdUse" ).removeClass("pd6 pt10" );
		
	}else {
		$("#divCompList").show();
		$( "td.tdUse" ).addClass( "pd6 pt10" );
	}
	
}	

function number_filter(str_value){
	return str_value.replace(/[^0-9]/gi, ""); 
}

function setByteLength(){
	$("#ssoEncryptKeyLength").html(unescape(encodeURIComponent($("#ssoEncryptKey").val())).length + " Byte");
}

function howToPop(objId){
	
	var popTitle = "";
	
	if(objId=="ssoTimeLinkPop"){
		popTitle = "<%=BizboxAMessage.getMessage("TX900000111","기준시간 표시")%>";
	}else{
		popTitle = "<%=BizboxAMessage.getMessage("TX900000112","고정코드 입력방법")%>";
	}
	
	$("#" + objId).kendoWindow({
		draggable: true,
       	resizable: true,
       	width: '400px',
       	height: 'auto',
       	title: popTitle,
       	modal: true 
   	}).data("kendoWindow").center().open();
	
}

function ssoEncryptTypeChange(){
	
	if($("#ssoEncryptType").val() == ""){
		$("input[name=encChkSel]").prop("checked",false).prop("disabled",true);
		$("#ssoEncryptKey").prop("disabled",true).val("");
		$("#ssoTimeLink").prop("disabled",true).val("");
	}else{
		$("input[name=encChkSel]").prop("disabled",false);
		$("#ssoEncryptKey").prop("disabled",false);
		$("#ssoTimeLink").prop("disabled",false);
	}
	
}

function getCodeName(langCode){
	
	if(langCode != null){
		
		switch(langCode.toUpperCase()){
			
			case 'EN':
				return 'CODE_EN';
				break;
			case 'CN':
				return 'CODE_CN';
				break;
			case 'JP':
				return 'CODE_JP';
				break;
			case 'KR':
				return 'CODE_KR';
				break;
			default:
				return 'CODE_NM';
				break;
		}
	}else{
		return 'CODE_NM';
	}
}


</script>
<!-- 탭 속성  (type)-->
<input type="hidden" id="hidType"/>
<input type="hidden" id="hidUpperMenuNo" />
<input type="hidden" id="hidSelectOrgId"/>
<input type="hidden" id="menuNo" name="menuNo"/>
<input type="hidden" id="hidOrginUseYn" name="hidOrginUseYn"/>

					<div id="" class="controll_btn pt10 posi_ab" style="right:20px;">
						<button type="button" id="btnNew" class="k-button"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
						<button type="button" id="btnSave" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
						<button type="button" id="btnDel" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
					</div>
					
					<div id="tabstrip_in" class="tab_style">						
						<ul class="pt10 mb10">
							<li id="USER" class="k-state-active"><%=BizboxAMessage.getMessage("TX000000286","사용자")%></li>
							<li id="ADMIN"><%=BizboxAMessage.getMessage("TX000000705","관리자")%></li>
						</ul>
					</div><!-- //tabstrip_in -->					
					
					<div class="sub_contents_wrap">						
						<div class="twinbox col_dcdcdc">
							<table>
								<colgroup>
									<col width="320"/>
									<col />
								</colgroup>
								<tr>
									<td class="twinbox_td p0">
										<div class="record_tabSearch">
											<p class="tit_p fl mt6 mr8"><%=BizboxAMessage.getMessage("TX000016300","메뉴 분류")%></p><input id="cboMenuGubun" style="width:130px;">
										</div>
										<div id="menu_tree"></div>
									
									</td>
									<td class="twinbox_td">
										<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016297","메뉴 상세정보")%></p>										
											<div class="com_ta">	
											<input type="hidden" id="menuGubun" name="menuGubun"/>							
												<table>
												
													<colgroup>
														<col width="10%"/>
														<col width="10%"/>
														<col width=""/>
													</colgroup>
													
													<tr id="upperMenu">
														<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000006001","상위메뉴")%></th>
														<td><input id="upperMenuNo" name="upperMenuNo" style="width:50%;"/></td>
													</tr>
													
													<tr id="subMenu" style="display:none;">
														<th colspan="2"> <%=BizboxAMessage.getMessage("TX000017933","기본페이지")%></th>
														<td><input id="subMenuNo" name="subMenuNo" style="width:50%;"/></td>
													</tr>	
																					
													<tr>
														<th rowspan="4"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000120","메뉴명")%></th>
														<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
														<td><input type="text" name="menuNameKr" id="menuNameKr"  required="required" style="width:95%"></td>
													</tr>
													
													<tr>
													  <th><%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
													  <td><input type="text" name="menuNameEn" id="menuNameEn" style="width:95%"></td>
													</tr>
													
													<tr>
													  <th><%=BizboxAMessage.getMessage("TX000005586","일어")%></th>
													  <td><input type="text" name="menuNameJp" id="menuNameJp" style="width:95%"></td>
													</tr>
													
													<tr>
													  <th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
													  <td><input type="text" name="menuNameCn" id="menuNameCn" style="width:95%"></td>
													</tr>
													
													<tr>
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000016301","메뉴 URL")%></th>
														<td>
															<input id="urlGubun" name="urlGubun" style="width:auto;"/>
															<input class="mr8" type="text" name="urlPath" id="urlPath" style="width:60%">
														</td>
													</tr>
													
													<tr>
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000016298","메뉴 사용여부")%></th>
														<td>
															<input type="radio" name="useChk" id="radio_u1" class="k-radio" checked="checked" value="Y">
															<label class="k-radio-label radioSel" for="radio_u1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
															<input type="radio" name="useChk" id="radio_u2" class="k-radio" value="N" >
															<label class="k-radio-label radioSel ml10" for="radio_u2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
														</td>
													</tr>		
																			
													<tr>
														<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000016299","메뉴 사용범위")%></th>
														<td class="tdUse">
															<input type="radio" name="publicYn" id="public_radio_u1" class="k-radio" checked="checked" value="Y" onclick="chkPublic('Y');">
															<label class="k-radio-label radioSel" for="public_radio_u1"><%=BizboxAMessage.getMessage("TX000000862","전체")%></label>
															<input type="radio" name="publicYn" id="public_radio_u2" class="k-radio" value="N" onclick="chkPublic('N');">
															<label class="k-radio-label radioSel ml10" for="public_radio_u2"><%=BizboxAMessage.getMessage("TX000000265","선택")%></label>
															
															<div class="mt7" id="divCompList" style="display: none;">
																<input class="p0" type="text" id="compList" style="width:60%" readonly="readonly">
																<div id="" class="controll_btn p0">
																	 <button id="btnAuth" onclick="fncOpenOcPop();"><%=BizboxAMessage.getMessage("TX000001702","찾기")%></button>
																</div>
															</div>
														</td>
													</tr>
													
													<tr>
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000000016","설명")%></th>
														<td><input type="text" name="menuDc" id="menuDc" style="width:95%"></td>
													</tr>
													
													<tr>
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000000043","정렬")%></th>
														<td><input type="text" name="menuOrdr" id="menuOrdr" style="width:100px" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'></td>
													</tr>
													
													<tr>
														<th colspan="2">SSO <%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
														<td>
															<input type="radio" name="ssoUseYn" id="sso_radio_u1" class="k-radio" value="Y" >
															<label class="k-radio-label radioSel" for="sso_radio_u1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
															<input type="radio" name="ssoUseYn" id="sso_radio_u2" class="k-radio" value="N" checked="checked" >
															<label class="k-radio-label radioSel ml10" for="sso_radio_u2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
															<div id="" class="controll_btn p0 ml10" style="display: none;">
																<button id=""><%=BizboxAMessage.getMessage("TX000006520","설정")%></button>
															</div>
														</td>
													</tr>
					
												</table>
											</div>
											
										<p class="tit_p" name="ssoSection" style="margin-top:20px;"><%=BizboxAMessage.getMessage("TX900000113","SSO연동 상세정보")%></p>										
											<div class="com_ta" name="ssoSection">	
												<table>
													<colgroup>
														<col width="10%"/>
														<col width="10%"/>
														<col width="25%"/>
														<col width="45%"/>
														<col width="10%"/>
													</colgroup>
													
													<tr name="ssoSection">
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000016175","연동방식")%></th>
														<td colspan="3">
															<input type="radio" name="ssoType" id="ssoTypeGet" class="k-radio" value="GET" checked="checked" >
															<label class="k-radio-label radioSel" for="ssoTypeGet">GET</label>
															<input type="radio" name="ssoType" id="ssoTypePost" class="k-radio" value="POST">
															<label class="k-radio-label radioSel ml10" for="ssoTypePost">POST</label>
														</td>
													</tr>
													
													<tr name="ssoSection">
														<th colspan="2"><%=BizboxAMessage.getMessage("TX900000114","암호화 방식")%></th>
														<td colspan="3">
															<select onchange="ssoEncryptTypeChange();" id="ssoEncryptType" name="ssoEncryptType" style="width:200px">
																<option value=""><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
																<option value="AES128">AES128(CBC)</option>
																<option value="AES128_ECB">AES128(ECB)</option>
																<option value="AES256">AES256(CBC)</option>
															</select>
														</td>
													</tr>
													
													<tr name="ssoSection">
														<th colspan="2"><%=BizboxAMessage.getMessage("TX900000115","암호화 key")%></th>
														<td colspan="3">
															<input type="text" id="ssoEncryptKey" name="ssoEncryptKey" style="width:200px" onkeyup='setByteLength();' /> <span id="ssoEncryptKeyLength"></span>
														</td>
													</tr>	
																									
													<tr name="ssoSection">
														<th colspan="2"><%=BizboxAMessage.getMessage("TX900000116","기준시간")%></th>
														<td colspan="3">
															<select id="ssoTimeLink" name="ssoTimeLink" style="width:200px">
																<option value=""><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
																<option value="01">yMdHms(14<%=BizboxAMessage.getMessage("TX000005067","자리")%>)</option>
																<option value="02">y-M-d H:m:s(19<%=BizboxAMessage.getMessage("TX000005067","자리")%>)</option>
																<option value="03">Timestamp(13<%=BizboxAMessage.getMessage("TX000005067","자리")%>)</option>
															</select>
															<img src="/gw/Images/ico/ico_explain.png" onclick="howToPop('ssoTimeLinkPop');" style="cursor:pointer;">															 
														</td>
													</tr>
													
													<tr name="ssoSection">
														<th rowspan="7" colspan="2"><%=BizboxAMessage.getMessage("TX900000117","파라미터 설정")%></th>
														<th style="text-align:center">Key</th>
														<th style="text-align:center">Value</th>
														<th style="text-align:center"><%=BizboxAMessage.getMessage("TX900000118","암호화")%></th>
													</tr>
													
													<tr name="ssoSection">
														<td style="text-align:center">
															<input type="text" id="ssoEmpCtlName" style="width:100%;" />
														</td>
														
														<td style="text-align:center; position:relative;">
															<span style="position:absolute; left:10px; top:13px;">=</span>
															<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000000357","사원코드")%></span>
														</td>															
														
														<td style="text-align:center">
															<input type="checkbox" name="encChkSel" /> 
														</td>														
													</tr>																	
													
													<tr name="ssoSection">
														<td style="text-align:center">
															<input type="text" id="ssoLogincdCtlName" style="width:100%;" />
														</td>

														<td style="text-align:center; position:relative;">
															<span style="position:absolute; left:10px; top:13px;">=</span>
															<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000016308","로그인계정")%></span>
														</td>															
														
														<td style="text-align:center">
															<input type="checkbox" name="encChkSel" />
														</td>														
													</tr>
													
													<tr name="ssoSection">
														<td style="text-align:center">
															<input type="text" id="ssoCoseqCtlName" style="width:100%;" />
														</td>
														
														<td style="text-align:center; position:relative;">
															<span style="position:absolute; left:10px; top:13px;">=</span>
															<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></span>
														</td>														

														<td style="text-align:center">
															<input type="checkbox" name="encChkSel" />
														</td>														
													</tr>
													
													<tr name="ssoSection">
														<td style="text-align:center">
															<input type="text" id="ssoErpempnoCtlName" style="width:100%;" />
														</td>

														<td style="text-align:center; position:relative;">
															<span style="position:absolute; left:10px; top:13px;">=</span>
															<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></span>
														</td>														
														
														<td style="text-align:center">
															<input type="checkbox" name="encChkSel" />
														</td>														
													</tr>		
													
													<tr name="ssoSection">
														<td style="text-align:center">
															<input type="text" id="ssoErpcocdCtlName" style="width:100%;" />
														</td>
														<td style="text-align:center; position:relative;">
															<span style="position:absolute; left:10px; top:13px;">=</span>
															<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000004237","ERP회사코드")%></span>
														</td>
														<td style="text-align:center">
															<input type="checkbox" name="encChkSel" />
														</td>														
													</tr>
													
													<tr name="ssoSection">
														<td style="text-align:center">
															<input type="text" id="ssoEtcCtlName" style="width:100%;text-align:center;" placeholder="<%=BizboxAMessage.getMessage("TX900000119","고정코드명")%>">
														</td>
														<td style="text-align:center; position:relative;">
															<span style="position:absolute; left:10px; top:13px;">=</span>
															<input type="text" id="ssoEtcCtlValue" style="width:80%;text-align:center;" placeholder="<%=BizboxAMessage.getMessage("TX900000120","고정코드값")%>">
															<img src="/gw/Images/ico/ico_explain.png" onclick="howToPop('ssoEtcCtlValueSetPop');" style="cursor:pointer;">
														</td>
														<td style="text-align:center">
															<input type="checkbox" name="encChkSel" />
														</td>														
													</tr>																																								
					
												</table>
											</div>											
											
									</td>
								</tr>
							</table>
						</div>
					</div><!-- 콘텐츠 영역 end -->
					
					
<div id="ssoEtcCtlValueSetPop" class="pop_wrap_dir" style="display:none;">

	<div class="pop_con p0" style="margin:10px;">
		<p class="f12 mt5">&lt;<%=BizboxAMessage.getMessage("TX900000121","치환")%> Value&gt;</p>
		<p class="f12 mt5">$log_id$ = <%=BizboxAMessage.getMessage("TX000016308","로그인계정")%></p>
		<p class="f12 mt5">$emp_cd$ = <%=BizboxAMessage.getMessage("TX000000357","사원코드")%></p>
		<p class="f12 mt5">$comp_cd$ = <%=BizboxAMessage.getMessage("TX000000017","회사코드")%></p>
		<p class="f12 mt5">$erp_comp_cd$ = <%=BizboxAMessage.getMessage("TX000004237","ERP회사코드")%></p>
		<p class="f12 mt5">$erp_id$ = <%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></p>
		<p class="f12 mt5">$yyyyMMddHHmmss$ = <%=BizboxAMessage.getMessage("TX900000122","현재시간")%> ex) 20180915130000</p>
		<p class="f12 mt5">$y-M-d H:m:s$ = <%=BizboxAMessage.getMessage("TX900000122","현재시간")%> ex) 2018-09-15 13:00:00</p>
		<p class="f12 mt5">$time_stamp$ = <%=BizboxAMessage.getMessage("TX900000123","타임스템프")%> ex) 1537016400000</p>
		
		<p class="text_red f12 mt15"><%=BizboxAMessage.getMessage("TX900000124","* 고정코드입력하여사용시, 아래예시와같이전달됩니다.")%></p>
		<p class="f12 mt5">ex) $log_id$ㅣ$comp_cd$ㅣ1001</p> 
		<p class="text_blue f12 mt5">http://www.abc/com/sso.cust.do ? Dkey = adminㅣ3000ㅣ1001</p>
	</div>
	
</div>

<div id="ssoTimeLinkPop" class="pop_wrap_dir" style="display:none;">

	<div class="pop_con p0" style="margin:10px;">
		<p class="text_red f12 mt5"><%=BizboxAMessage.getMessage("TX900000125","* 암호화시, value 값앞에기준시간이포함됩니다.")%></p>
		<p class="text_red f12 mt5">ex) 20180101091133(기준시간) , douzone(<%=BizboxAMessage.getMessage("TX000016308","로그인계정")%>)</p>
		<p class="text_blue f12 mt5">http://www.abc/com/sso.cust.do? key= 20180101091133douzone&</p>
	</div>
	
</div>

<form id="openOcPop" name="openOcPop" method="post" action="/gw/systemx/orgChart.do" target="openOcPop">
  <input name="selectMode" value="oc" type="hidden"/>
  <input name="selectItem" value="m" type="hidden"/>
  <input name="callback" value="fnCallbackData" type="hidden"/>
  <input name="selectedItems" value="" type="hidden"/>
</form>  
       