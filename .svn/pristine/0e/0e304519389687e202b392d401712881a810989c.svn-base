<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>



<style>
.portal_main_wrap {
	overflow: hidden;
	position: relative;
	width: 960px;
	min-height: 696px;
	margin: 15px auto 0 auto;
}

.portal_con_center .portal_cc_top {
	float: left;
	width: 568px;
}

.portal_con_center .portal_cc_left {
	float: left;
	width: 280px;
}

.portal_con_center .portal_cc_right {
	float: left;
	width: 280px;
	margin-left: 8px !important;
}

.portal_portlet {
	background-color: white;
	cursor: move;
	border: 1px solid #c7c7c7;
	margin-bottom: 8px !important;
	width: 565px;
}

.portal_portlet .portlet_img {
	margin: 5px;
}

.portal_portlet .portlet_img_not_use {
	margin: 5px;
	opacity: 0.1;
}

.portal_portlet .link_sts {
	position: absolute;
	left: 70px;
	margin-top: 10px;
	font-weight: bold;
}
</style>

<script>

	//로딩이미지
	$(document).bind("ajaxStart", function () {
		kendo.ui.progress($(".pop_wrap"), true);
	}).bind("ajaxStop", function () {
		kendo.ui.progress($(".pop_wrap"), false);
	});	
	
	var ImgMode = "";
	var ImgKey = "";
	var NewLinkId = "${portletSetInfo.linkId}";
	var link_obj = opener.$(".portal_main_wrap [portlet_tp=${params.portletTp}][portlet_key=${params.portletKey}]");
	var linkTp = "";

	$(document).ready(function() {
				
		//I-FRAME 설정
		if("${params.portletTp}" == "top_if" || "${params.portletTp}" == "lr_if" || "${params.portletTp}" == "cn_if"){
			$("[name=if_set]").show();
			linkTp = "if_set";
		}else{
			if("${params.portletTp}" == "qu_bn"){
				$("[name=qu_set],[name=link_set]").show();
				linkTp = "qu_set";
			}else{
				$("[name=bn_set],[name=link_set]").show();
				
				linkTp = "bn_set";
			}
			
		    $("#sortable").kendoSortable({
		        connectWith: "#sortable",
		        placeholder: placeholder,
		        change: refreshSeq        
		    });
		    
			//첨부파일처리.	
			$("#file_upload").kendoUpload({
				async: {
	            	saveUrl: _g_contextPath_+'/cmm/file/fileUploadProc.do',
	                autoUpload: true
	            },
	            localization: {
					select: "<%=BizboxAMessage.getMessage("TX000000602","등록")%>"
				},
	            showFileList: false,
	            upload:function(e) { 
					var dataType = 'json';
					var pathSeq = '900';
					var relativePath = '/portal';
					
					var params = "dataType=" + dataType;
					params += "&pathSeq=" + pathSeq;
					params += "&relativePath=" + relativePath;
					
	            	e.sender.options.async.saveUrl = _g_contextPath_+'/cmm/file/fileUploadProc.do?'+params;
	            	
	            	var inputName =  $(e.sender).attr("name");
	            	
	            	$('#'+inputName+"_INP").val(e.files[0].name);
	            },
	            success: onSuccess
			});	
		}
		
		//프로젝트 포틀릿 일때 조회범위 값 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_pj' || portletSetInfo.portletTp == 'cn_pj'}">
		 var opValue = "${portletSetInfo.val0}";
		 var arrOpValue = opValue.split(",");
		 
		 for(var i=0;i<arrOpValue.length;i++){
				var id = "val0" + arrOpValue[i];
				document.getElementById(id).checked = true;
		 }
		 
		</c:if>	
		
		
		//공지사항 포틀릿 게시판 아이디 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_nb' || portletSetInfo.portletTp == 'cn_nb' || portletSetInfo.portletTp == 'top_nb'}">
		var opValue = "${portletSetInfo.val0}";
		$("#boardId").val(opValue);
		
		</c:if>
		
		<c:if test="${portletSetInfo.portletTp == 'lr_user'}">
			fnAttendCheck();
		</c:if>
		
		
		
		//결재현황(비영리) 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_ea_ea_count'}">
		var opValue = "${portletSetInfo.val0}";
	
		if(opValue != "") {
			var checkArray = opValue.split("|");
			
			if(checkArray[0] == "Y") {
				document.getElementById("val00").setAttribute("checked", true);
			}
			if(checkArray[1] == "Y") {
				document.getElementById("val01").setAttribute("checked", true);
			}
			if(checkArray[2] == "Y") {
				document.getElementById("val02").setAttribute("checked", true);
			}
			if(checkArray[3] == "Y") {
				document.getElementById("val03").setAttribute("checked", true);
			}
			if(checkArray[4] == "Y") {
				document.getElementById("val04").setAttribute("checked", true);
			}
			if(checkArray[5] == "Y") {
				document.getElementById("val05").setAttribute("checked", true);
			}
		}
		
		</c:if>
		
		//전자결재 영리 포틀릿 일때 조회범위 값 셋팅
		<c:if test="${portletSetInfo.portletTp == 'top_ea' || portletSetInfo.portletTp == 'lr_ea' || portletSetInfo.portletTp == 'cn_ea'}">
		var opValue = '${portletSetInfo.val0}';
		var opValueStr = "";		
		
		if(opValue != ""){
			
			if(opValue[0] === "[") {
				var opValueArray = JSON.parse(opValue).sort(function(a, b){
					return a.order - b.order;
				});	
				
				opValueArray.forEach(function(item){
					opValueStr += item.menu_seq + ",";
				});
				
				tblParam = {};
				tblParam.opValue = opValueStr.slice(0,-1);
				
			} else {
				tblParam = {};
				tblParam.opValue = opValue;
			}
					
			$.ajax({
	        	type:"post",
	    		url:'getEaBoxPortletInfo.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (data) {
		    			$("#listBox").html("");
		    			var InnerHTML = "";
		    			var orderDataList = [];
		    			
		    			if(opValue[0] === "[") {
		    				opValueArray.forEach(function(item, index) {
			    				for(var i = 0; i < data.list.length; i++) {
			    					if(item.menu_seq == data.list[i].menuNo) {
			    						orderDataList.push(data.list[i]);
			    					}
			    				}
			    			});	
		    			} else {
		    				orderDataList = data.list;
		    			}   			
		    					    			
		    			for(var i=0;i<orderDataList.length;i++){	
		    				var targetID = orderDataList[i].menuNo;
		    	    		InnerHTML += "<li id='" + targetID + "' name='eaBox'>";
		    	    		InnerHTML += orderDataList[i].menuNm
		    	    		InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""+ targetID +"\")'>";
		    	    		InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
		    	    		InnerHTML += "</a></li>";
		    			}
		    			$("#listBox").html(InnerHTML);
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
		}
		</c:if>

		//전자결재 비영리 포틀릿 일때 조회범위 값 셋팅
		<c:if test="${portletSetInfo.portletTp == 'top_ea_ea' || portletSetInfo.portletTp == 'lr_ea_ea' || portletSetInfo.portletTp == 'cn_ea_ea'}">
		var opValue = "${portletSetInfo.val0}";
		
		
		if(opValue != ""){
			
			if(opValue[0] === "[") {
				var opValueArray = JSON.parse(opValue).sort(function(a, b){
					return a.order - b.order;
				});	
				
				opValueArray.forEach(function(item){
					opValueStr += item.menu_seq + ",";
				});
				
				tblParam = {};
				tblParam.opValue = opValueStr.slice(0,-1);
				
			} else {
				tblParam = {};
				tblParam.opValue = opValue;
			}
												
			$.ajax({
	        	type:"post",
	    		url:'getEaBoxPortletInfo.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (data) {
		    			$("#listBox").html("");
		    			var InnerHTML = "";
						var orderDataList = [];
		    			
						if(opValue[0] === "[") {
		    				opValueArray.forEach(function(item, index) {
			    				for(var i = 0; i < data.list.length; i++) {
			    					if(item.menu_seq == data.list[i].menuNo) {
			    						orderDataList.push(data.list[i]);
			    					}
			    				}
			    			});	
		    			} else {
		    				orderDataList = data.list;
		    			}
		    			
		    			for(var i=0;i<data.list.length;i++){	
		    				var targetID = data.list[i].menuNo;
		    	    		InnerHTML += "<li id='" + targetID + "' name='eaBox'>";
		    	    		InnerHTML += data.list[i].menuNm
		    	    		InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""+ targetID +"\")'>";
		    	    		InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
		    	    		InnerHTML += "</a></li>";
		    			}
		    			$("#listBox").html(InnerHTML);
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
		}
		</c:if>
		
		//전자결재 결재양식 포틀릿 일때 조회범위 값 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_form'}">
		var opValue = "${portletSetInfo.val0}";
		
		if(opValue != ""){
			tblParam = {};
			tblParam.opValue = opValue
			
			$.ajax({
	        	type:"post",
	    		url:'getEaFormPortletInfo.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (data) {
		    			$("#listBox").html("");
		    			var InnerHTML = "";
		    			for(var i=0;i<data.list.length;i++){	
		    				var targetID = data.list[i].formId;
		    	    		InnerHTML += "<li id='" + targetID + "' name='eaForm'>";
		    	    		InnerHTML += data.list[i].formNm
		    	    		InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""+ targetID +"\")'>";
		    	    		InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
		    	    		InnerHTML += "</a></li>";
		    			}
		    			$("#listBox").html(InnerHTML);
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
		}
		</c:if>
		
		//전자결재(비) 결재양식  포틀릿 일때 조회범위 값 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_ea_form'}">
		var opValue = "${portletSetInfo.val0}";
		
		if(opValue != ""){
			tblParam = {};
			tblParam.opValue = opValue
			
			$.ajax({
	        	type:"post",
	    		url:'getNonEaFormPortletInfo.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (data) {
		    			$("#listBox").html("");
		    			var InnerHTML = "";
		    			for(var i=0;i<data.list.length;i++){	
		    				var targetID = data.list[i].formId;
		    	    		InnerHTML += "<li id='" + targetID + "' name='nonEaForm'>";
		    	    		InnerHTML += data.list[i].formNm
		    	    		InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""+ targetID +"\")'>";
		    	    		InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
		    	    		InnerHTML += "</a></li>";
		    			}
		    			$("#listBox").html(InnerHTML);
	    		    } ,
			    error: function (result) { 
			    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
	    	});	
		}
		</c:if>
		
		
		//날씨 포틀릿 일때 날씨지역 조회 및 기상청 API Key값 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_weather' || portletSetInfo.portletTp == 'cn_weather'}">
			var opValue = "${portletSetInfo.val0}";
			
			//console.log(opValue);
			
			if(opValue == "") {
				opValue = "60,127";		
			}
			
			var ddlActType = NeosCodeUtil.getCodeList("cm1010"); 
		    $("#weatherCity").kendoComboBox({
		        dataSource : ddlActType,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        value: opValue
		    });
		    
		    $.ajax({
  				type: "post",
    			url: "getWeatherApiKey.do",
    			dataType: "json",
    			success: function(data){
    				$("#weatherApiKey").val(data.weatherApiKey);
    			},
  				error: function(data){
  					console.log(data);
				}	
			});
		    
		    $('#weatherCity').data('kendoComboBox').value(opValue);
		</c:if>
		
		
		//연말정산 포틀릿 일때 메신저 날개 옵션 조회 및 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_tax' || portletSetInfo.portletTp == 'cn_tax'}">
			var opValue = "${portletSetInfo.val0}";
			
			$.ajax({
	        	type:"post",
	    		url:'getTaxMessengerCheck.do',
	    		datatype:"json",
	    		success: function (data) {
		    		var result = data.list.taxMsnYn;
		    		
		    		if(result == "Y") {
		    			$("input:radio[name=messengerUseYn]:input[value=Y]").attr("checked", true);
		    		} else {
		    			$("input:radio[name=messengerUseYn]:input[value=N]").attr("checked", true);
		    		}
	   		    } ,
			    error: function (result) { 
	    			alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	    		}
	    	});
		</c:if>
		
		
		//메일 포틀릿 일때 메일함 조회 및 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_em' || portletSetInfo.portletTp == 'cn_em' || portletSetInfo.portletTp == 'top_em'}">
			var opValue = "${portletSetInfo.val0}";
			var ddlActType = NeosCodeUtil.getCodeList("cm1020"); 
		    $("#mailSelect").kendoComboBox({
		        dataSource : ddlActType,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        value: opValue
		    });
		    
			var Combobox = $("#mailSelect").data("kendoComboBox");
		    
		    // Combobox.dataSource.insert(0, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000001580", "받은편지함")%>", CODE: "0" });
		    Combobox.refresh();
		    
		    
		    if(opValue == "")	
		    	$('#mailSelect').data('kendoComboBox').value("0");
		    else
		    	$('#mailSelect').data('kendoComboBox').value(opValue);
		</c:if>	
		
		//일정 포틀릿 일때 일정 기본옵션 변경 및 셋팅
		<c:if test="${portletSetInfo.portletTp == 'lr_so' || portletSetInfo.portletTp == 'cn_so'}">
		
			//일정캘린더 일정표시 옵션 초기화하기 위해 페이지 랜더시 호출한다.
			settingCalenderDefaultOption();
			
			var defaultOption = "${portletSetInfo.val3}";
			
			if(defaultOption) {
				$("input[name=defaultCalenderType]").prop("checked", false);
				switch  (defaultOption){
					case "private":
						$($("input[name=defaultCalenderType]")[1]).prop("checked", true);
						break;
					case "share":
						$($("input[name=defaultCalenderType]")[2]).prop("checked", true);
						break;
					case "special":
						$($("input[name=defaultCalenderType]")[3]).prop("checked", true);
						break;
					case "all": 
						$($("input[name=defaultCalenderType]")[0]).prop("checked", true);
						break;
				}
			}
			
			//일정캘린더 일정표시 옵션 변경시 기본값 설정이 변경된다.
			$("input[name=calenderOptionCheckbox]").change(function() {
				settingCalenderDefaultOption("setting");
			});
		
		</c:if>
		
		setPortletInfo();
		
		// 라디오 버튼 이벤트 (내정보-높이 변경)
		fnRadioButtonEvent();
		
		// 라디오 버튼 이벤트 (배너 - 슬라이드/리스트)
		fnBannerOption();
		
		
	});
	
	function settingCalenderDefaultOption() {
		/*
		* #val00 == 전체개인일정
		* #val01 == 전체공유일정
		* #val02 == 기념일	
		*/
		var optionCheck = [];
		var checkDefaultRadio = false;
		
		// 라디오 태그 초기화
		$("input[name=defaultCalenderType]").prop("checked",false);
		$("input[name=defaultCalenderType]").attr("disabled",false);
		
		// 일정표시 체크박스 정보를 조회
		optionCheck[0] = !$("#val00").is(":checked");
		optionCheck[1] = !$("#val01").is(":checked");
		optionCheck[2] = !$("#val02").is(":checked");
		
		optionCheck.forEach(function(item, index){
			
			$($("input[name=defaultCalenderType]")[index + 1]).attr("disabled", optionCheck[index]);
			
			// 기념일 체크시 전체일정 disable 설정을 한다. 
			if(index == 2) {
				if(optionCheck[0] && optionCheck[1] && !optionCheck[2]) {
					$($("input[name=defaultCalenderType]")[0]).attr("disabled", true);
				} else if(optionCheck[0] && optionCheck[1] && optionCheck[2]) {
					$("input[name=defaultCalenderType]").attr("disabled", true);
				}
				
			
				// default 선택을 하기위해 추가한 로직
				for(var i = 0; $("input[name=defaultCalenderType]").length > i; i++){
					var target = $("input[name=defaultCalenderType]")[i];
					
					// checkDefaultRadio 플래그는 default 기본옵션이 선택되어있는지 판별하는 플래그
					// 현재 옵션이 disable이 아니고 default로 선택한 옵션이 없다면 선택 
					if($(target).prop("disabled") == false && checkDefaultRadio == false) {
						
						// 일정표시 옵션이 전체 선택일때 기본값 설정을 개인일정을 default로 설정한다.
						if(i === 0 && (optionCheck[0] === false && optionCheck[1] === false && optionCheck[2] === false)) {
							continue;
						}
						
						$(target).prop("checked", true);
						checkDefaultRadio = true;
						
					}
					
				}
			}
		});
	}
	
	function fnAttendCheck() {
		$.ajax({
        	type:"post",
    		url:'getAttendCheck.do',
    		datatype:"json",
    		success: function (data) {
	    		var result = data.list.secomUse;
	    		
	    		if(result == "Y") {
	    			//document.getElementById("val03").style.display="none";
	    			//document.getElementById("autoAttend").style.display="none";
	    			$('#val03').prop('disabled', true);
	    			//autoAttend
	    		} else {
	    			//document.getElementById("val03").css();
	    		}
   		    } ,
		    error: function (result) { 
    			alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
    		}
    	});	
	}
	
	// 하이오 버튼 이벤트 (내정보-높이 변경)
	function fnRadioButtonEvent() {
		$("input[name='displayOption']").click(function(){
			if($(this).val() == "all") {
				$("#abjustHeight").val("224");
				$("#attendCheck").show();
			} else if ($(this).val() == "attend") {
				$("#abjustHeight").val("60");
				$("#attendCheck").show();
			} else if ($(this).val() == "profile") {
				$("#abjustHeight").val("164");
				
				$("#attendCheck").hide();
			}
		});
	}
	
	function fnBannerOption() {
		$("input[name='imageChoice']").click(function(){
			if($(this).val() == "Y") {
				$("#bannerOption").show();
			} else if ($(this).val() == "N") {
				$("#bannerOption").hide();
			}
		});
	}
	
	function refreshSeq(){
	    $.each($("#sortable span[name=link_seq]"), function (i, t) {
	    	$(t).html(i+1);
	    	
	    	$(t).closest("div").attr("link_seq", $(t).text());
	    });		
	}
	
	function fnbutton(mode, obj){
		ImgMode = mode;
		
		if(mode == "add"){
			$("#file_upload").click();
		}else if (mode == "img"){
			ImgKey = $(obj).parent().attr("link_seq");
			$("#file_upload").click();
		}else if (mode == "del"){
			
			$(obj).parent().remove();
			refreshSeq();
			
		}else if (mode == "set"){
			var url = "portletLinkPop.do?linkSeq=" + $(obj).parent().attr("link_seq");
			openWindow2(url, "portletLinkPop", 652, 385, 1, 1);			
		}		
		
	}

	function fnImageAdd(file_id, url){
		
		if(ImgMode == "add"){
			$("#portlet_model .portal_portlet").attr("file_id", file_id);
			$("#portlet_model img").attr("src", url);
			
			//키생성
			var link_seq = 1;
			
		    $.each($("#sortable .portal_portlet"), function (i, t) {
		    	  var value = parseFloat($(t).attr("link_seq"));
		    	  link_seq = (value >= link_seq) ? (value + 1) : link_seq;
		    });

		    $("#sortable").append($("#portlet_model .portal_portlet").attr("link_seq",link_seq).clone());			
			
		    refreshSeq();
			
		}else if(ImgMode == "img"){
			$("#sortable .portal_portlet[link_seq=" + ImgKey + "]").attr("file_id", file_id)
			$("#sortable .portal_portlet[link_seq=" + ImgKey + "]").find("img").attr("src", url);
		}
		
	}
	
	function onSuccess(e) {
		if (e.operation == "upload") {
			var fileId = e.response.fileId;
			if (fileId != null && fileId != '') {
				fnImageAdd(fileId, "/gw/cmm/file/fileDownloadProc.do?fileId="+fileId+"&fileSn=0");
			} else {
				alert(e.response);
			}
		}
	}	
	
	function placeholder(e) {
	    return $("<div class='portal_portlet' style='background-color:black;opacity:0.2;width:" + $(e).width() + "px;height:" + $(e).height() + "px;''></div>");
	}	
	
	function setPortletInfo(){
		$("input[name=useYn]").val(["${portletSetInfo.useYn}"]);
		
 		if(linkTp == "bn_set"){
 			var bn_pause = '${portletSetInfo.val0}';
 			var bn_speed = "${portletSetInfo.val1}";
 			var bn_move = "${portletSetInfo.val2}";
 			var bn_btn = "${portletSetInfo.val3}";
 			$("#bn_pause").val(bn_pause == "" ? "3000" : bn_pause);
 			$("#bn_speed").val(bn_speed == "" ? "1000" : bn_speed);
 			$("input[name=moveTp]").val([bn_move == "" ? "fade" : bn_move]);
 			$("input[name=moBtn]").val([bn_btn == "" ? "true" : bn_btn]);
 		}else if(linkTp == "qu_set"){
 			var qu_pause = '${portletSetInfo.val0}';
 			var bn_dirtp = "${portletSetInfo.val1}";
 			$("#qu_pause").val(qu_pause == "" ? "3000" : qu_pause);
 			$("input[name=dirTp]").val([bn_dirtp == "" ? "left" : bn_dirtp]);
 		}		
	}
	
	function fnGetLinkList(){
		
		var LinkList = new Array();
		
	    $.each($("#sortable .portal_portlet"), function (i, t) {
	    	
	    	var link_info = {};
	    	
	    	link_info.link_seq = $(t).attr("link_seq");
	    	link_info.link_nm = $(t).attr("link_nm");
	    	

	    	
	    	link_info.file_id = $(t).attr("file_id");
	    	link_info.use_yn = $(t).attr("use_yn");
	    	link_info.show_from = $(t).attr("show_from");
	    	link_info.show_to = $(t).attr("show_to");
	    	link_info.ssoUseYn = $(t).attr("ssoUseYn");
	    	link_info.ssoType = $(t).attr("ssoType");
	    	link_info.ssoUserId = $(t).attr("ssoUserId");
	    	link_info.ssoCompSeq = $(t).attr("ssoCompSeq");
	    	
	    	link_info.ssoEncryptType = $(t).attr("ssoEncryptType");
	    	link_info.ssoEncryptKey = $(t).attr("ssoEncryptKey");
	    	link_info.ssoTimeLink = $(t).attr("ssoTimeLink");
	    	link_info.ssoEncryptScope = $(t).attr("ssoEncryptScope");
	    	
	    	link_info.sspErpSeq = $(t).attr("sspErpSeq");
	    	link_info.ssoLoginCd = $(t).attr("ssoLoginCd");
	    	link_info.ssoErpCompSeq = $(t).attr("ssoErpCompSeq");

	    	link_info.ssoEtcName = $(t).attr("ssoEtcName");
	    	link_info.ssoEtcValue = $(t).attr("ssoEtcValue");
	    	
			if("${params.portletTp}" == "top_if" || "${params.portletTp}" == "lr_if" || "${params.portletTp}" == "cn_if"){
				if(link_info.ssoUseYn == "Y"){
					link_info.link_url = $("#if_url").val();
					LinkList.push(link_info);	
				}
			}else{
				link_info.link_url = $(t).attr("link_url");
				LinkList.push(link_info);
			}	    	
	    	
	    });
		
		return LinkList;
	}
	

	// 저장
	function fnSavePortal(){
		
 		if(confirm("<%=BizboxAMessage.getMessage("TX000004920", "저장하시겠습니까?")%>")){
	 		var tblParam = {};
	 		
	 		tblParam.portalId = "${params.portalId}";
	 		tblParam.portletTp = "${params.portletTp}";
	 		tblParam.portletKey = "${params.portletKey}";
	 		tblParam.linkId = null;
	 		tblParam.useYn = $("input[name=useYn]:checked").val();
	 		tblParam.abjustHeight = $("#abjustHeight").val();
	 		tblParam.ifUrl = "";
	 		tblParam.linkList = JSON.stringify(new Array());
	 		tblParam.val0 = "";
	 		tblParam.val1 = "";
	 		tblParam.val2 = "";
	 		tblParam.val3 = "";
	 		tblParam.val4 = "";	 
	 		tblParam.port_name_kr = "";
	 		tblParam.port_name_cn = "";
	 		tblParam.port_name_jp = "";
	 		tblParam.port_name_en = "";
	 		
	 		
	 		//배너, 아이프레임 포틀릿 파라미터 셋팅
	 		<c:if test="${portletSetInfo.portletTp == 'top_sl' || portletSetInfo.portletTp == 'lr_bn' || portletSetInfo.portletTp == 'cn_bn' || portletSetInfo.portletTp == 'cn_if' || portletSetInfo.portletTp == 'lr_if' || portletSetInfo.portletTp == 'qu_bn' || portletSetInfo.portletTp == 'top_if'}">
		 		
	 			if($("#if_url").val() !="") {
	 				
	 				var text = $("#if_url").val();
	 				var hangleUrl = text.replace(/[^ㄱ-ㅎ가-힣]/gi,"");
	 				var url = $("#if_url").val().replace(hangleUrl, encodeURI(hangleUrl));
	 				var url1 = url.replace(/%/gi, "^");
	 				
	 			}
	 		
		 		tblParam.linkId = NewLinkId;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = url1;
		 		tblParam.linkList = JSON.stringify(fnGetLinkList());
		 		tblParam.val0 = "";
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";
		 		tblParam.port_name_kr = "배너";
		 		tblParam.port_name_cn = "";
		 		tblParam.port_name_jp = "";
		 		tblParam.port_name_en = "banner";
		 		
		 		if(linkTp == "bn_set"){
		 			tblParam.val0 = $("#bn_pause").val();
		 			tblParam.val1 = $("#bn_speed").val();
		 			tblParam.val2 = $("input[name=moveTp]:checked").val();
		 			tblParam.val3 = $("input[name=moBtn]:checked").val();
		 		}else if(linkTp == "qu_set"){
		 			tblParam.val0 = $("#qu_pause").val();
		 			tblParam.val1 = $("input[name=dirTp]:checked").val();
		 		}
		 		
		 		// 배너방식 
		 		if($("input[name='imageChoice']:checked").val() == "Y") {
		 			tblParam.val4 = "slide";	
		 		}  else if($("input[name='imageChoice']:checked").val() == "N") {
		 			tblParam.val4 = "list";
		 		}
	 		</c:if>
	 		
	 		
	 		//공지사항 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_nb' || portletSetInfo.portletTp == 'cn_nb' || portletSetInfo.portletTp == 'top_nb'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = $("#boardID").val();
		 		tblParam.val1 = $("#boardName").val();
		 		tblParam.val2 = $("#boardCount").val();
		 		
		 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if($("#portletKrName").val() == "" || $("#boardName").val() =="" || ($("#boardCount").val() == 0 || $("#boardCount").val() == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
		 		
	 		</c:if>
	 		
	 		//문서 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_doc' || portletSetInfo.portletTp == 'cn_doc' || portletSetInfo.portletTp == 'top_doc'}">
	 		
		 		if($("#portletKrName").val() == "" || $("#docName").val() =="" || ($("#docCount").val() == 0 || $("#docCount").val() == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 		 	return;
		 		}
			
				tblParam.linkId= null;
				tblParam.useYn= $("input[name=useYn]:checked").val();
				tblParam.adjustHeight= $("#abjustHeight").val();
				tblParam.ifUrl= "";
				tblParam.linkList= JSON.stringify(new Array());
				tblParam.val0= $("#docID").val();
				tblParam.val1= $("#docName").val();
				tblParam.val2= $("#docCount").val();
				tblParam.val3= $("#docLvl").val();
				tblParam.port_name_kr= $("#portletKrName").val();
				tblParam.port_name_cn= $("#portletCnName").val();
				tblParam.port_name_jp= $("#portletJpName").val();
				tblParam.port_name_en= $("#portletEnName").val();
	 		
	 		</c:if>
	 		
	 		
	 		//내정보 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_user' || portletSetInfo.portletTp == 'cn_user'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = "";
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";
		 		tblParam.val3 = "";
		 		tblParam.port_name_kr = "내정보";
		 		tblParam.port_name_cn = "";
		 		tblParam.port_name_jp = "";
		 		tblParam.port_name_en = "";
		 		
		 		//  표시옵션 (val00)
		 		if($("input[name='displayOption']:checked").val() == "all") {
		 			tblParam.val0 = "all";	
		 		}  else if($("input[name='displayOption']:checked").val() == "attend") {
		 			tblParam.val0 = "attend";
		 		} else if($("input[name='displayOption']:checked").val() == "profile") {
		 			tblParam.val0 = "profile";
		 		}
		 		
		 		/* 출퇴근체크 */
		 		// 출퇴근 사용
		 		if(document.getElementById("val01").checked){
		 			tblParam.val1 = "Y";
		 		}

		 		// 시간표시
		 		if(document.getElementById("val02").checked) {
		 			tblParam.val2 = "Y";
		 		}
		 		
		 		// 자동출근처리
		 		if(document.getElementById("val03").checked) {
		 			tblParam.val3 = "Y";
		 		}
		 		
		 		tblParam.val4 = "";
		 		
		 	
	 		</c:if>
	 		
	 		
	 		
	 		//설문조사 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_rs' || portletSetInfo.portletTp == 'cn_rs'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = "";
		 		tblParam.val1 = "";
		 		if(document.getElementById("rsArea").checked)
		 			tblParam.val0 = "ING";
		 		else
		 			tblParam.val0 = "ALL";
		 		tblParam.val1 = $("#val01").val();
		 		tblParam.val2 = "";
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 	
		 		tblParam.port_name_kr = "설문조사";
		 		tblParam.port_name_cn = "";
		 		tblParam.port_name_jp = "";
		 		tblParam.port_name_en = "";
	 		</c:if>
	 		
	 		
	 		//노트 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_no' || portletSetInfo.portletTp == 'cn_no'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = $("#val00").val();
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 	
		 		tblParam.port_name_kr = "노트";
		 		tblParam.port_name_cn = "";
		 		tblParam.port_name_jp = "";
		 		tblParam.port_name_en = "note";
	 		</c:if>
	 		
	 		
	 		
	 		
	 		//프로젝트 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_pj' || portletSetInfo.portletTp == 'cn_pj'}">
	 			var opValue = "";
	 			if(document.getElementById("val00").checked)
	 				opValue += ",0";
	 			if(document.getElementById("val01").checked)
	 				opValue += ",1";
	 			
	 			if(document.getElementById("val02").checked)
	 				opValue += ",2";
	 			
	 			if(document.getElementById("val03").checked)
	 				opValue += ",3";
	 			
	 			if(document.getElementById("val04").checked)
	 				opValue += ",4";
	 			
	 			if(document.getElementById("val05").checked)
	 				opValue += ",5";
	 		
	 			if(opValue.length > 0 )
	 				opValue = opValue.substring(1);
	 			
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = opValue;
		 		tblParam.val1 = $("#val2").val();
		 		tblParam.val2 = "";
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 	
	 		</c:if>
	 		
	 		
	 		
	 		
	 		//메일 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_em' || portletSetInfo.portletTp == 'cn_em' || portletSetInfo.portletTp == 'top_em'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = $('#mailSelect').data('kendoComboBox').value();
		 		tblParam.val1 = "";
		 		tblParam.val2 = $("#val02").val();
		 		if(document.getElementById("val01").checked)
		 			tblParam.val1 = "Y";
		 		else 
		 			tblParam.val1 = "N";
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if($("#portletKrName").val() == "" || $('#mailSelect').data('kendoComboBox').value() == "" || ($("#val02").val() == "0" || $("#val02").val() == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>
	 		
	 		
	 		
	 		//전자결재 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'top_ea' || portletSetInfo.portletTp == 'lr_ea' || portletSetInfo.portletTp == 'cn_ea'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		var eaBoxList = $("li[name=eaBox]");
		    	menuNoList = "";
		    	for(var i=0;i<eaBoxList.length;i++){
		    		menuNoList += "," + eaBoxList[i].id;
		    	}		    	
		    	if(menuNoList.length > 0)
		    		menuNoList = menuNoList.substring(1);		 		
		 		
		    	var menuNoListArray = menuNoList.split(",");
		 		var menuNoListOrderJson = menuNoListArray.map(function(item, index) {
		 			return {menu_seq: item, order: index}
		 		});
		    	
		    	tblParam.val0 = JSON.stringify(menuNoListOrderJson);
		    			    	
		 		tblParam.val1 = $("#listCnt").val();
		 		if($("input[name='displayOption']:checked").val() == "Y") {
		 			tblParam.val2 = "Y";	
		 		} else {
		 			tblParam.val2 = "N";
		 		}
		 			 		
		 		// 조회범위 첫번째 menu_seq 값만 따로 저장 
		 		// 메인 페이지의 더보기 링크 전용 시퀀스 값
		 		tblParam.val3 = menuNoListOrderJson[0].menu_seq;
		 		tblParam.val4 = "";	 	
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if($("#portletKrName").val() == "" || (menuNoList.length == 0 || menuNoList == "") || ($("#listCnt").val() == 0 || $("#listCnt").val() == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>
	 		
	 		//전자결재 양식 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_form'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		var eaFormList = $("li[name=eaForm]");
		    	formIdList = "";
		    	for(var i=0;i<eaFormList.length;i++){
		    		formIdList += "," + eaFormList[i].id;
		    	}		    	
		    	if(formIdList.length > 0)
		    		formIdList = formIdList.substring(1);		 		
		 		tblParam.val0 = formIdList;
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";		 			 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 	
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if($("#portletKrName").val() == "" || (formIdList.length == 0 || formIdList == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>
	 		
	 		//전자결재(비영리) 양식 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_ea_form'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		var nonEaFormList = $("li[name=nonEaForm]");
		    	formIdList = "";
		    	for(var i=0;i<nonEaFormList.length;i++){
		    		formIdList += "," + nonEaFormList[i].id;
		    	}		    	
		    	if(nonEaFormList.length > 0)
		    		formIdList = formIdList.substring(1);		 		
		 		tblParam.val0 = formIdList;
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";		 			 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 	
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if($("#portletKrName").val() == "" || (formIdList.length == 0 || formIdList == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>
	 		
	 		
	 		//전자결재(비영리) 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'cn_ea_ea' || portletSetInfo.portletTp == 'top_ea_ea' || portletSetInfo.portletTp == 'lr_ea_ea'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());		 			 		
		 		var eaBoxList = $("li[name=eaBox]");
		    	menuNoList = "";
		    	for(var i=0;i<eaBoxList.length;i++){
		    		menuNoList += "," + eaBoxList[i].id;
		    	}		    	
		    	if(menuNoList.length > 0)
		    		menuNoList = menuNoList.substring(1);		 		
		 		tblParam.val0 = menuNoList;
		 		tblParam.val1 = $("#listCnt").val();
		 		if($("input[name='displayOption']:checked").val() == "Y") {
		 			tblParam.val2 = "Y";	
		 		} else {
		 			tblParam.val2 = "N";
		 		}
		 			 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 	
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if($("#portletKrName").val() == "" || (menuNoList.length == 0 || menuNoList == "") || ($("#listCnt").val() == 0 || $("#listCnt").val() == "")) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
		 		
				
	 		</c:if>
	 		
	 		
	 		
	 		
	 		//날씨 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_weather' || portletSetInfo.portletTp == 'cn_weather'}">
		 		
		 		// API 키가 인증된 키인지 인증 플래그 값을 가져온다.
				var isWeatherApi = $("#weatherApiKey").attr("isWeatherApi");
				
				// API 인증 플래그가 undefined, null, "false" 일경우 저장을 하지 않는다.
				if(isWeatherApi === undefined || isWeatherApi === null || isWeatherApi === "false"){
					alert("<%=BizboxAMessage.getMessage("","날씨 API키 인증이 완료되지 않았습니다.")%>");
					return;
				}
	 		
	 			tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 =$('#weatherCity').data('kendoComboBox').value();
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";		 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";	 	
		 		tblParam.port_name_kr = "날씨";
		 		tblParam.port_name_cn = "";
		 		tblParam.port_name_jp = "";
		 		tblParam.port_name_en = "weather";
		 		tblParam.weatherApiKey = $("#weatherApiKey").val() == null ? "" : $("#weatherApiKey").val();
	 		</c:if>
	 		
	 		//전자결재 현황 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_ea_count' || portletSetInfo.portletTp == 'cn_ea_count'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = "";
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";		 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if(document.getElementById("val00").checked) {
		 			tblParam.val0 = "Y";
		 		}
		 		
		 		if(document.getElementById("val01").checked) {
		 			tblParam.val1 = "Y";
		 		}
		 		
		 		if(document.getElementById("val02").checked) {
		 			tblParam.val2 = "Y";
		 		}
		 		
// 		 		if(document.getElementById("val03").checked) {
// 		 			tblParam.val3 = "Y";
// 		 		}
		 		
		 		if(document.getElementById("val04").checked) {
		 			tblParam.val4 = "Y";
		 		}
		 		
		 		if($("#portletKrName").val() == "" || (!document.getElementById("val00").checked && !document.getElementById("val01").checked && !document.getElementById("val02").checked)  ) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>

	 		//전자결재(비영리) 현황 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_ea_ea_count' || portletSetInfo.portletTp == 'cn_ea_ea_count'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = "";
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";		 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		var selectEaBox = "";
		 		
		 		// 결재대기문서
		 		if(document.getElementById("val00").checked) {
		 			selectEaBox += "Y";
		 		} else {
		 			selectEaBox += "N";
		 		}
		 		
		 		// 결재 완료문서
		 		if(document.getElementById("val01").checked) {
		 			selectEaBox += "|Y";
		 		} else {
		 			selectEaBox += "|N";
		 		}
		 		
		 		// 결재반려문서
		 		if(document.getElementById("val02").checked) {
		 			selectEaBox += "|Y";
		 		} else {
		 			selectEaBox += "|N";
		 		}
		 		
		 		// 상신문서
		 		if(document.getElementById("val03").checked) {
		 			selectEaBox += "|Y";
		 		} else {
		 			selectEaBox += "|N";
		 		}
		 		
		 		// 열람문서
		 		if(document.getElementById("val04").checked) {
		 			selectEaBox += "|Y";
		 		} else {
		 			selectEaBox += "|N";
		 		}
		 		
		 		// 결재예정문서
		 		if(document.getElementById("val05").checked) {
		 			selectEaBox += "|Y";
		 		} else {
		 			selectEaBox += "|N";
		 		}
		 		
		 		tblParam.val0 = selectEaBox;
		 		
		 		// 진행중
		 		if(document.getElementById("val06").checked) {
		 			tblParam.val1 =  "Y";
		 		}
		 		
		 		if($("#portletKrName").val() == "" || selectEaBox == "N|N|N|N|N|N"  ) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>	 		
	 		
	 		//메일 현황 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_em_count' || portletSetInfo.portletTp == 'cn_em_count'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = "";
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";		 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if(document.getElementById("val00").checked) {
		 			tblParam.val0 = "Y";
		 		}
		 		
		 		if(document.getElementById("val01").checked) {
		 			tblParam.val1 = "Y";
		 		}
		 		
		 		if($("#portletKrName").val() == "" || (!document.getElementById("val00").checked && !document.getElementById("val01").checked)) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>
	 		
	 		//일정캘린더 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_so' || portletSetInfo.portletTp == 'cn_so'}">
		 		tblParam.linkId = null;
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.abjustHeight = $("#abjustHeight").val();
		 		tblParam.ifUrl = "";
		 		tblParam.linkList = JSON.stringify(new Array());
		 		tblParam.val0 = "";
		 		tblParam.val1 = "";
		 		tblParam.val2 = "";		 		
		 		tblParam.val3 = "";
		 		tblParam.val4 = "";
		 		
		 		// 전체개인일정
		 		if(document.getElementById("val00").checked) {
		 			tblParam.val0 = "Y";
		 		}
		 		
		 		// 전체공유일정
		 		if(document.getElementById("val01").checked) {
		 			tblParam.val1 = "Y";
		 		}
		 		
		 		// 기념일
		 		if(document.getElementById("val02").checked) {
		 			tblParam.val2 = "Y";
		 		}
		 		
		 		// 기본 옵션 설정
				tblParam.val3 = $("input:radio[name=defaultCalenderType]:checked").val() == undefined ? 
		 			null : $("input:radio[name=defaultCalenderType]:checked").val();
		 		
		 		tblParam.port_name_kr = $("#portletKrName").val();
		 		tblParam.port_name_cn = $("#portletCnName").val();
		 		tblParam.port_name_jp = $("#portletJpName").val();
		 		tblParam.port_name_en = $("#portletEnName").val();
		 		
		 		if($("#portletKrName").val() == "" || (!document.getElementById("val00").checked && !document.getElementById("val01").checked && !document.getElementById("val02").checked)) {
		 			alert("<%=BizboxAMessage.getMessage("TX000020928", "필수값이 입력되지 않았습니다.")%>");
		 			return;
		 		}
	 		</c:if>
	 		
	 		//연말정산 포틀릿 파라미터 정의
	 		<c:if test="${portletSetInfo.portletTp == 'lr_tax' || portletSetInfo.portletTp == 'cn_tax'}">
		 		tblParam.useYn = $("input[name=useYn]:checked").val();
		 		tblParam.messengerUseYn = $("input[name=messengerUseYn]:checked").val();
		 		tblParam.linkList = JSON.stringify(new Array());
	 		</c:if>
	 			 		
	 		
	 		$.ajax({
	        	type:"post",
	    		url:'portletSetInsert.do',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (result) {
	    				if(opener != null){
	    					if("${portletSetInfo.linkId}" == "0"){
	    						NewLinkId = result.value;
	    					}
	    					
	    					if($("input[name=useYn]:checked").val() == "Y"){
	    						$(link_obj).children("img").removeClass("portlet_img_not_use").addClass("portlet_img");
	    						$(link_obj).find("[name=not_use_str]").addClass("hide");
	    					}else{
	    						$(link_obj).children("img").removeClass("portlet_img").addClass("portlet_img_not_use");
	    						$(link_obj).find("[name=not_use_str]").removeClass("hide");	    						
	    					}
	    					
	    					if("${portletSetInfo.resizeYn}" == 'Y'){
	    						
		    					if("${params.portletTp}" != "top_if" && "${params.portletTp}" != "lr_if" && "${params.portletTp}" != "cn_if" && $("#sortable .portal_portlet").length > 0){
		    						$(link_obj).children("img").attr("src",$($("#sortable .portal_portlet")[0]).find("img").attr("src"));
		    					}else{
		    						$(link_obj).children("img").attr("src","/gw/Images/portal/${params.portletTp}.png");
		    					}
	    						
	    						var abjustHeightSet = $("#abjustHeight").val() * 0.8;
	    						$(link_obj).children("img")[0].height = abjustHeightSet;
	    					}
	    				}
	    				
	    				fnclose();
	    		    } ,
			    error: function (result) { 
			    	alert("<%=BizboxAMessage.getMessage("TX000002003", "작업이 실패했습니다.")%>");	
			    	}
				});
	 		
	 		
		}
	}

	function fnclose() {
		self.close();
	}

	//전자결재 결재함 선택 팝업
	function fnEaBoxPop() {
		var eaBoxList = $("li[name=eaBox]");

		menuNoList = "";

		for (var i = 0; i < eaBoxList.length; i++) {
			menuNoList += "," + eaBoxList[i].id;
		}

		if (menuNoList.length > 0)
			menuNoList = menuNoList.substring(1);

		var url = "portletEaBoxListPop.do?menuNoList=" + menuNoList;
		openWindow2(url, "portletEaBoxListPop", 502, 700, 1, 1);
	}
	

	//전자결재(비) 결재함 선택 팝업
	function fnNonEaBoxPop() {
		var eaNonBoxList = $("li[name=nonEaBox]");

		formIdList = "";

		for (var i = 0; i < eaNonBoxList.length; i++) {
			formIdList += "," + eaNonBoxList[i].id;
		}

		if (formIdList.length > 0)
			formIdList = formIdList.substring(1);

		var url = "portletEaTreePop.do?formIdList=" + formIdList;
		openWindow2(url, "portletEaTreePop", 502, 700, 1, 1);
	}
	
	//게시판 트리 선택 팝업
	function fnBoardListPop() {
// 		var eaBoxList = $("li[name=eaBox]");

// 		menuNoList = "";

// 		for (var i = 0; i < eaBoxList.length; i++) {
// 			menuNoList += "," + eaBoxList[i].id;
// 		}

// 		if (menuNoList.length > 0)
// 			menuNoList = menuNoList.substring(1);

		//var url = "portletEaBoxListPop.do?menuNoList=" + menuNoList;
		var url = "portletBoardListPop.do?";
		openWindow2(url, "portletEaBoxListPop", 502, 700, 1, 1);
	}
	
	function fnDocListPop() {
		var url = "portletDocListPop.do?";
		openWindow2(url,"portletEaBoxListPop", 502, 700, 1, 1);
	}
	
	function docTreeCallBack(dir_cd, dir_lvl, dir_type, dir_nm) {
		$("#docID").val(dir_cd);
		$("#docName").val(dir_nm);
		$("#docType").val(dir_type);
		$("#docLvl").val(dir_lvl);
	}

	function eaBoxCallBack(treeCheckList) {
		var checkEaBoxList = JSON.parse(treeCheckList);
		console.log(JSON.stringify(checkEaBoxList));
		var InnerHTML = "";
		$("#listBox").html("");
		for (var i = 0; i < checkEaBoxList.length; i++) {
			if (checkEaBoxList[i].seq == '2002000000' || checkEaBoxList[i].seq == '101000000' || checkEaBoxList[i].seq == '102000000' || checkEaBoxList[i].seq == '100000000') {
				continue;
			} else {
				var targetID = checkEaBoxList[i].seq;
				InnerHTML += "<li id='" + targetID + "' name='eaBox'>";
				InnerHTML += checkEaBoxList[i].name;
				InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""
						+ targetID + "\")'>";
				InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
				InnerHTML += "</a></li>";
			}
		}

		$("#listBox").html(InnerHTML);
	}
	
	function boardTreeCallBack(boardID, boardNm) {
		var board = boardID;
		var boardName = boardNm;
		
		$("#boardID").val(boardID);
		$("#boardName").val(boardName);

			
	}

	function delAppli(target) {
		$("#" + target).remove();
	}
	
	function fnNameCheck() {
		var checkFlag = false;
		if($("portletKrName").val() == "") {
			return true;
		}
		
		return false;
		
	}
	
	function fnEaFormPop() {
		var eaFormList = $("li[name=eaForm]");

		formIdList = "";

		for (var i = 0; i < eaFormList.length; i++) {
			formIdList += "," + eaFormList[i].id;
		}

		if (formIdList.length > 0)
			formIdList = formIdList.substring(1);

		var url = "portletEaFormListPop.do?formIdList=" + formIdList;
		//var url = "portletBoardListPop.do?menuNoList=" + menuNoList;
		openWindow2(url, "portletEaFormListPop", 502, 700, 1, 1);
	}
	
	
	
	
	function eaFormCallBack(treeCheckList) {
		var checkEaBoxList = JSON.parse(treeCheckList);
		
		var InnerHTML = "";
		$("#listBox").html("");
		for (var i = 0; i < checkEaBoxList.length; i++) {
			if(checkEaBoxList[i].spriteCssClass != "folder") {
				var targetID = checkEaBoxList[i].seq;
				InnerHTML += "<li id='" + targetID + "' name='eaForm'>";
				InnerHTML += checkEaBoxList[i].name;
				InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""
						+ targetID + "\")'>";
				InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
				InnerHTML += "</a></li>";	
			}
		}

		$("#listBox").html(InnerHTML);
	}
	
	function eaNonFormCallBack(treeCheckList) {
		var checkNonEaBoxList = JSON.parse(treeCheckList);
		//alert(treeCheckList);
		var InnerHTML = "";
		$("#listBox").html("");
		for (var i = 0; i < checkNonEaBoxList.length; i++) {
			if(checkNonEaBoxList[i].spriteCssClass != "folder") {
				var targetID = checkNonEaBoxList[i].seq;
				InnerHTML += "<li id='" + targetID + "' name='nonEaForm'>";
				InnerHTML += checkNonEaBoxList[i].name;
				InnerHTML += "<a class='close_btn' href='javascript:delAppli(\""
						+ targetID + "\")'>";
				InnerHTML += "<img src='/gw/Images/ico/sc_multibox_close.png'></img>";
				InnerHTML += "</a></li>";	
			}
		}

		$("#listBox").html(InnerHTML);
	}
	
	function weatherApiCheck(){
		var weatherApiKey = $("#weatherApiKey").val()
		var _date = new Date();
						
		var tblParam = {
			weatherApiKey: weatherApiKey,
			weatherCity: $("#weatherCity").val(),
			location: "71,132",
			baseDate: new Date().toISOString().slice(0,10).replace(/-/gi,""),
			baseTime: "0210"
		}
	
		$.ajax({
			type:"post",
   			url:'/gw/cmm/systemx/weather/getWeather.do',
   			datatype:"json",
	        data: tblParam ,
   			success: function (data){
   				$("#testResultContainer").empty();
   				if(data.result.response.header.resultCode == "00") {
   					alert("<%=BizboxAMessage.getMessage("TX900000001", "연결성공")%>");
   					
   					// API 연동이 성공하면 성공 플래그를 저장한다.
	   				$("#weatherApiKey").attr("isWeatherApi","true");
   					
   					$("#testResultContainer").append("<span style='color:blue; font-size: 10px;'><%=BizboxAMessage.getMessage("TX900000002", "* 연결에 성공하였습니다.")%></span>");
   				}else if(data.result.response.header.resultCode == "30" || data.result.response.header.resultCode == "10") {
   					alert("<%=BizboxAMessage.getMessage("TX900000003", "API Key를 확인해주세요.")%>");
   					
   					//API 연동이 실패하면 실패 플래그를 저장한다.
	   				$("#weatherApiKey").attr("isWeatherApi","false");
   					
   					$("#testResultContainer").append("<span style='color:red; font-size: 10px;'><%=BizboxAMessage.getMessage("TX900000003", "* API Key를 확인해주세요.")%></span>");
   				}
   			},
   			error: function (result){
   				alert("<%=BizboxAMessage.getMessage("TX900000004", "연결 중 에러가 발생하였습니다.")%>");
   			}
		});
	}
</script>

<div class="pop_wrap resources_reservation_wrap" style="height: 100%; border: none; overflow-y: auto;">

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016087", "포틀릿설정")%></h1>
	</div>
	<!-- //pop_head -->

	<c:if
		test="${portletSetInfo.portletTp == 'top_sl' || portletSetInfo.portletTp == 'lr_bn' || portletSetInfo.portletTp == 'cn_bn' || portletSetInfo.portletTp == 'cn_if' || portletSetInfo.portletTp == 'lr_if' || portletSetInfo.portletTp == 'qu_bn' || portletSetInfo.portletTp == 'top_if'}">

		<div class="pop_con">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000004661", "기본정보")%></p>

			<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016088", "포틀릿구분")%></th>
						<td>${portletSetInfo.portletNm}</td>
						<th><%=BizboxAMessage.getMessage("TX000000028", "사용여부")%></th>
						<td>
							<input type="radio" id="useYn" name="useYn" value="Y" class="" checked="checked" /> <label for="useYn"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
							<input type="radio" id="useYn2" name="useYn" value="N" class="ml10" /> <label for="useYn2"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
						</td>
					</tr>
					
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016400", "가로사이즈(px)")%></th>
						<td>${portletSetInfo.width}</td>
						<th><%=BizboxAMessage.getMessage("TX000016193", "세로사이즈(px)")%></th>
						<td>
							<input onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"	<c:if test="${portletSetInfo.resizeYn == 'N'}">disabled</c:if> id="abjustHeight" type="text" style="width: 50px;" value="${portletSetInfo.abjustHeight}" />
						</td>
					</tr>
					
					<tr name='bn_set' style="display:none;">
						<th><%=BizboxAMessage.getMessage("TX900000005", "배너방식")%></th>
						<td colspan="3">
							<input type="radio" id="slide" name="imageChoice" value="Y" checked <c:if test="${portletSetInfo.val4 == 'slide'}">checked</c:if> /> <label for="slide"><%=BizboxAMessage.getMessage("TX900000006", "슬라이드")%></label>
							<input type="radio" id="imageList" name="imageChoice" value="N" <c:if test="${portletSetInfo.val4 == 'list'}">checked</c:if> class="ml10"/> <label for="imageList"><%=BizboxAMessage.getMessage("TX000005559", "리스트")%></label>
						</td>
					</tr>
					
				</table>
				
				<table id="bannerOption" <c:if test="${portletSetInfo.val4 == 'list'}">style="display:none;"</c:if>>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					
					<tr name="bn_set" style="display: none;">
						<th class="brtn"><%=BizboxAMessage.getMessage("TX000016257", "변환주기(ms)")%></th>
						<td class="brtn"><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" id="bn_pause" type="text" style="width: 50px;" value="" /></td>
						<th class="brtn"><%=BizboxAMessage.getMessage("TX000016258", "변환속도(ms)")%></th>
						<td class="brtn"><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" id="bn_speed" type="text" style="width: 50px;" value="" /></td>
					</tr>
					<tr name="bn_set" style="display: none;">
						<th><%=BizboxAMessage.getMessage("TX000016156", "이미지선택버튼")%></th>
						<td>
							<input type="radio" id="moBtnY" name="moBtn" value="true" class="" checked="checked" /> <label for="moBtnY"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
							<input type="radio" id="moBtnN" name="moBtn" value="false" class="ml10" /> <label for="moBtnN"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
						</td>
						<th><%=BizboxAMessage.getMessage("TX000016256", "변환타입")%></th>
						<td>
							<input type="radio" id="moveTp1" name="moveTp" value="fade" checked="checked" /> <label	for="moveTp1"><%=BizboxAMessage.getMessage("TX000016090", "페이딩")%></label>
							<br>
							<input type="radio" id="moveTp2" name="moveTp" value="horizontal" /> <label for="moveTp2"><%=BizboxAMessage.getMessage("TX000016129", "좌우")%></label>
							<br>
							<input type="radio" id="moveTp3" name="moveTp" value="vertical" /> <label for="moveTp3"><%=BizboxAMessage.getMessage("TX000016204", "상하")%></label>
						</td>
					</tr>
					<tr name="qu_set" style="display: none;">
						<th class="brtn"><%=BizboxAMessage.getMessage("TX000016160", "이동주기(ms)")%></th>
						<td class="brtn"><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" id="qu_pause" type="text" style="width: 50px;" value="" /></td>
						<th class="brtn"><%=BizboxAMessage.getMessage("TX000016161", "이동방향")%></th>
						<td class="brtn">
							<input type="radio" id="dirTp1" name="dirTp" value="left" checked="checked" /> <label for="dirTp1"><%=BizboxAMessage.getMessage("TX000007911", "왼쪽")%></label>
							<input type="radio" id="dirTp2" name="dirTp" value="right" class="ml10"/> <label for="dirTp2"><%=BizboxAMessage.getMessage("TX000007909", "오른쪽")%></label>
						</td>
					</tr>
					<tr name="if_set" style="display: none;margin-top:-1px;">
						<th class="brtn">I-Frame URL</th>
						<td colspan="3" class="brtn"><input id="if_url" type="text" value="${portletSetInfo.ifUrl}" style="width: 95%;" /></td>
					</tr>
					
					<tr name="if_set" style="display:none;">
						<th><%=BizboxAMessage.getMessage("TX000016405","SSO연동")%></th>
						<td>
							<div class="controll_btn" style="padding:0px;" link_seq="-1">
								<button onclick="fnbutton('set',this)"><%=BizboxAMessage.getMessage("TX000017969", "SSO설정")%></button>	
							</div>
						</td>
					</tr>						
				</table>
			</div>

			<div name="link_set" style="display: none;">
				<div class="clear">
					<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016262", "배너설정")%></p>
					<div class="controll_btn mt8">
						<button id=""  onclick="fnbutton('add','')"><%=BizboxAMessage.getMessage("TX000017975", "배너추가")%></button>
					</div>
				</div>

				<div id="sortable" class="portal_cc_top">
				
					<c:if test="${(params.portletTp == 'top_if' || params.portletTp == 'lr_if' || params.portletTp == 'cn_if')}">
						<c:if test="${portletLinkList == null || portletLinkList.size() == 0}">
							<div link_seq="-1" link_nm=""
								link_url="" file_id=""
								use_yn="" show_from=""
								show_to="" ssoUseYn="N"
								ssoType="" ssoUserId=""
								ssoCompSeq=""
								ssoPwd=""
								sspErpSeq=""
								ssoLoginCd=""
								ssoErpCompSeq=""
								ssoEncryptType=""
								ssoEncryptKey=""
								ssoTimeLink=""
								ssoEtcName=""
								ssoEtcValue=""
								ssoEncryptScope="" class="portal_portlet">
							</div>
						</c:if>				
					</c:if>

					<c:forEach var="items" items="${portletLinkList}">
						<div link_seq="${items.linkSeq}" link_nm="${items.linkNm}"
							link_url="${items.linkUrl}" file_id="${items.fileId}"
							use_yn="${items.useYn}" show_from="${items.showFrom}"
							show_to="${items.showTo}" ssoUseYn="${items.ssoUseYn}"
							ssoType="${items.ssoType}" ssoUserId="${items.ssoEmpCtlName}"
							ssoCompSeq="${items.ssoCoseqCtlName}"
							ssoPwd="${items.ssoPwdCtlName}"
							sspErpSeq="${items.ssoErpempnoCtlName}"
							ssoLoginCd="${items.ssoLogincdCtlName}"
							ssoErpCompSeq="${items.ssoErpcocdCtlName}"
							ssoEncryptType="${items.ssoEncryptType}"
							ssoEncryptKey="${items.ssoEncryptKey}"
							ssoTimeLink="${items.ssoTimeLink}"
							ssoEtcName="${items.ssoEtcCtlName}"
							ssoEtcValue="${items.ssoEtcCtlValue}"
							ssoEncryptScope="${items.ssoEncryptScope}" class="portal_portlet">
							<span name="link_seq"
								style="padding: 15px; font-size: 10pt; font-weight: bold;">${items.sort}</span>
							<img
								class="portlet_img<c:if test="${items.useYn == 'N' || items.showYn == 'N'}">_not_use</c:if>"
								src="/gw/cmm/file/fileDownloadProc.do?fileId=${items.fileId}&fileSn=0"
								width="200" height="${portletSetInfo.abjustHeightSet}">
							<span class="link_sts"> <c:if test="${items.useYn == 'N'}"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></c:if>
								<c:if test="${items.useYn == 'Y' && items.showYn == 'N'}"><%=BizboxAMessage.getMessage("TX000010583", "기간만료")%></c:if>
							</span>
							<input onclick="fnbutton('img',this)" style="margin-left: 50px;" type="button" value="<%=BizboxAMessage.getMessage("TX000016157", "이미지변경")%>" />
							<input onclick="fnbutton('set',this)" type="button" value="<%=BizboxAMessage.getMessage("TX000006443", "링크설정")%>" />
							<input onclick="fnbutton('del',this)" type="button"	value="<%=BizboxAMessage.getMessage("TX000000424", "삭제")%>" />
						</div>
					</c:forEach>
				</div>
			</div>

		</div>
	</c:if>


	<c:if
		test="${portletSetInfo.portletTp != 'top_sl' && portletSetInfo.portletTp != 'lr_bn' && portletSetInfo.portletTp != 'cn_bn' && portletSetInfo.portletTp != 'cn_if' && portletSetInfo.portletTp != 'lr_if' && portletSetInfo.portletTp != 'qu_bn' && portletSetInfo.portletTp != 'top_if'}">

		<div class="pop_con">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000004661", "기본정보")%></p>

			<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016088", "포틀릿구분")%></th>
						<td>${portletSetInfo.portletNm}</td>
						<th><%=BizboxAMessage.getMessage("TX000000028", "사용여부")%></th>
						<td>
							<input type="radio" id="useYn" name="useYn" value="Y" class="" checked="checked" /> <label for="useYn"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
							<input type="radio" id="useYn2" name="useYn" value="N" class="ml10" /> <label for="useYn2"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016400", "가로사이즈(px)")%></th>
						<td>${portletSetInfo.width}</td>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016193", "세로사이즈(px)")%></th>
						<td>
							<input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)"	<c:if test="${portletSetInfo.resizeYn == 'N'}">disabled</c:if> id="abjustHeight" type="text" style="width: 50px;" value="${portletSetInfo.abjustHeight}" />
						</td>
					</tr>
				</table>
			</div>

			<div style="height: 20px"></div>

			<!-- 				   공지사항(프로필) 포틀릿 옵션정보정의  -->
			<c:if test="${portletSetInfo.portletTp == 'lr_nb' || portletSetInfo.portletTp == 'cn_nb' || portletSetInfo.portletTp == 'top_nb'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>
							
				<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="controll_btn mt8">
					<button id="" onclick="fnBoardListPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
				</div>
				
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
							<td>
								<input type="text" style="width: 100%;" id="boardName" value="<c:if test="${portletSetInfo.val1 != ''}">${portletSetInfo.val1 }</c:if>"/>
								<input type="hidden" id="boardID" value="<c:if test="${portletSetInfo.val0 != ''}">${portletSetInfo.val0 }</c:if>" />
							</td>
						</tr>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
							<td><input type="text" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="width: 40%;" id="boardCount" value="<c:if test="${portletSetInfo.val2 != ''}">${portletSetInfo.val2 }</c:if>" /></td>
						</tr>
					</table>
				</div>
			</c:if>




			<!-- 내정보(프로필) 포틀릿 옵션정보정의 -->
			<c:if
				test="${portletSetInfo.portletTp == 'lr_user' || portletSetInfo.portletTp == 'cn_user'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000007", "표시옵션")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="radio" name="displayOption" id="all" value="all" checked <c:if test="${portletSetInfo.val0 == 'all'}">checked</c:if> /> <label for="all"><%=BizboxAMessage.getMessage("TX000004225", "모두표시")%></label>
								<input type="radio" name="displayOption" id="attend" value="attend" <c:if test="${portletSetInfo.val0 == 'attend'}">checked</c:if> class="ml10" /> <label for="attend"><%=BizboxAMessage.getMessage("", "출퇴근영역만 표시")%></label>
								<input type="radio" name="displayOption" id="profile" value="profile" <c:if test="${portletSetInfo.val0 == 'profile'}">checked</c:if> class="ml10" /> <label for="profile"><%=BizboxAMessage.getMessage("", "프로필영역만 표시")%></label>
							</td>
						</tr>
						<tr id="attendCheck" <c:if test="${portletSetInfo.val0 == 'profile'}"> style='display:none'</c:if> >
						
							<th><%=BizboxAMessage.getMessage("TX000016109", "출퇴근체크")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="attendOption" id="val01" <c:if test="${portletSetInfo.val1 == 'Y'}">checked</c:if> /> <label for="val01"><%=BizboxAMessage.getMessage("TX000016110", "출퇴근사용")%></label>
								<input type="checkbox" name="attendOption" id="val02" class="ml10" <c:if test="${portletSetInfo.val2 == 'Y'}">checked</c:if> /> <label for="val02"><%=BizboxAMessage.getMessage("TX900000008", "시간표시")%></label>
								<input type="checkbox" name="attendOption" id="val03" class="ml10" <c:if test="${portletSetInfo.val3 == 'Y'}">checked</c:if> /> <span id="autoAttend"><label for="val03"><%=BizboxAMessage.getMessage("TX900000009", "자동출근처리 (당일 최초 로그인 시)")%></label></span>
							</td>
						
						</tr>
					</table>
				</div>
			</c:if>


			<!-- 	             설문조사 포틀릿 옵션정보정의 -->
			<c:if
				test="${portletSetInfo.portletTp == 'lr_rs' || portletSetInfo.portletTp == 'cn_rs'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%>
				</p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
							<td>
								<input type="radio" id="rsArea" name="rsArea" value=""	class="" checked="checked" /> <label for="rsArea"><%=BizboxAMessage.getMessage("TX000000475", "진행중")%></label>
								<input type="radio" id="rsArea2" name="rsArea" value=""	class="ml10"	<c:if test="${portletSetInfo.val0 == 'ALL'}">checked</c:if> /> <label for="rsArea2"><%=BizboxAMessage.getMessage("TX000016137", "전체(지난 설문 포함)")%></label>
							</td>
						</tr>

						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
							<td><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" type="text" style="width: 50px;" id="val01" value="${portletSetInfo.val1}" /> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>
						</tr>
					</table>
				</div>
			</c:if>



			<!-- 	             일정(일정캘린더) 포틀릿 옵션정보정의 -->
			<c:if
				test="${portletSetInfo.portletTp == 'lr_so' || portletSetInfo.portletTp == 'cn_so'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>
				
				<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						
						<tr id="attendCheck">
					    	<th><img alt="" src="/gw/Images/ico/ico_check01.png"><%=BizboxAMessage.getMessage("TX000000483", "일정")%><%=BizboxAMessage.getMessage("TX000003801", "표시")%></th>
					        <td align="left" style="border-left: 0px;">
					          <input type="checkbox" id="val00" name="calenderOptionCheckbox" <c:if test="${portletSetInfo.val0 == 'Y'}">checked</c:if> /> <label for="val00"><%=BizboxAMessage.getMessage("TX000018850", "전체개인일정")%></label>
					          <input type="checkbox" id="val01" name="calenderOptionCheckbox" class="ml10" <c:if test="${portletSetInfo.val1 == 'Y'}">checked</c:if> /> <label for="val01"><%=BizboxAMessage.getMessage("TX000018969", "전체공유일정")%></label>
					          <input type="checkbox" id="val02" name="calenderOptionCheckbox" class="ml10" <c:if test="${portletSetInfo.val2 == 'Y'}">checked</c:if> /> <label for="val02"><%=BizboxAMessage.getMessage("TX000007381", "기념일")%></label>
					        </td>
					    </tr>
					    <tr>
					        <th><%=BizboxAMessage.getMessage("", "기본값설정")%></th>
					        <td align="left" style="border-left: 0px;">
					          <input type="radio" name="defaultCalenderType" id="defalutCalenderOption_all" value="all" /><label for="defalutCalenderOption_all"><%=BizboxAMessage.getMessage("TX000010380", "전체일정")%></label>
					          <input type="radio" name="defaultCalenderType" id="defalutCalenderOption_private" checked="checked" value="private" class="ml10" /><label for="defalutCalenderOption_private">&nbsp;<%=BizboxAMessage.getMessage("TX000004103", "개인일정")%></label>
					          <input type="radio" name="defaultCalenderType" id="defalutCalenderOption_share" value="share" class="ml10" /><label for="defalutCalenderOption_share"><%=BizboxAMessage.getMessage("TX000010163", "공유일정")%></label>
					          <input type="radio" name="defaultCalenderType" id="defalutCalenderOption_special" value="special" class="ml10" /><label for="defalutCalenderOption_special"><%=BizboxAMessage.getMessage("TX000007381", "기념일")%></label>	
					        </td>
					    </tr>

					</table>
				</div>
			</c:if>



			<!-- 	             노트(노트) 포틀릿 옵션정보정의 -->
			<c:if
				test="${portletSetInfo.portletTp == 'lr_no' || portletSetInfo.portletTp == 'cn_no'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
							<td><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" type="text" style="width: 50px;" id="val00" value="${portletSetInfo.val0}" /> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>
						</tr>
					</table>
				</div>
			</c:if>
			
			
			<!-- 문서 포틀릿 옵션정보정의 -->
			<c:if test="${portletSetInfo.portletTp == 'lr_doc' || portletSetInfo.portletTp == 'cn_doc' || portletSetInfo.portletTp == 'top_doc'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120" />
								<col width="150" />
								<col width="120" />
								<col width="" />
							</colgroup>
							<tr>
								<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
								<td>
									<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
								</td>
								<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
								<td>
									<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
								</td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
								<td>
									<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
								</td>
								<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
								<td>
									<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
								</td>
							</tr>
						</table>
					</div>			
						
					<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
					<div class="controll_btn mt8">
						<button id="reg_document_btn" onclick="fnDocListPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
					</div>					
						
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120" />
								<col width="" />
							</colgroup>
							<tr>
								<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
								<td>
									<input type="text" style="width: 100%;" id="docName" value="<c:if test="${portletSetInfo.val1 != ''}">${portletSetInfo.val1 }</c:if>"/>
									<input type="hidden" id="docID" value="<c:if test="${portletSetInfo.val0 != ''}">${portletSetInfo.val0 }</c:if>" />
									<input type="hidden" id="docType" value=""/>
									<input type="hidden" id="docLvl" value="<c:if test="${portletSetInfo.val3 != ''}">${portletSetInfo.val3 }</c:if>"/>
								</td>
							</tr>
							<tr>
								<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
								<td><input type="text" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="width: 40%;" id="docCount" value="<c:if test="${portletSetInfo.val2 != ''}">${portletSetInfo.val2 }</c:if>" /></td>
							</tr>
						</table>
					</div>
			</c:if>



			<!-- 	             전자결재(전자결재) 포틀릿 옵션정보정의 -->
			<c:if test="${portletSetInfo.portletTp == 'top_ea' || portletSetInfo.portletTp == 'lr_ea' || portletSetInfo.portletTp == 'cn_ea'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>				
				
				<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="controll_btn mt8">
					<button id="" onclick="fnEaBoxPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
				</div>
				
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
							<td>
								<ul class="multibox p0 m0 mr5" style="width: 100%;" id="listBox">

								</ul>
							</td>
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX900000010", "기안자명 표시")%></th>
							<td>
								<input type="radio" name="displayOption" id="displayOptionY" value="Y" <c:if test="${portletSetInfo.val2 == 'Y'}">checked</c:if> /> <label for="displayOptionY"><%=BizboxAMessage.getMessage("TX000018619", "사용")%></label>
								<input type="radio" name="displayOption" id="displayOptionN" value="N" <c:if test="${portletSetInfo.val2 == 'N'}">checked</c:if> class="ml10" /> <label for="displayOptionN"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
							</td>
						</tr>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
							<td><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" type="text" style="width: 50px;" id="listCnt" value="${portletSetInfo.val1}" /> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>
						</tr>
					</table>
				</div>
			</c:if>


			<!-- 	             전자결재(전자결재-비영리) 포틀릿 옵션정보정의 -->
			<c:if test="${portletSetInfo.portletTp == 'cn_ea_ea' || portletSetInfo.portletTp == 'top_ea_ea' || portletSetInfo.portletTp == 'lr_ea_ea'}">

				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
 				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>
			
								
				<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>					
				<div class="controll_btn mt8">
					<button id="" onclick="fnEaBoxPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
				</div>
				
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
							<td>
								<ul class="multibox p0 m0 mr5" style="width: 100%;" id="listBox">

								</ul>
							</td>
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX900000010", "기안자명 표시")%></th>
							<td>
								<input type="radio" name="displayOption" value="Y" id="displayOptionY" <c:if test="${portletSetInfo.val2 == 'Y'}">checked</c:if> /> <label for="displayOptionY"><%=BizboxAMessage.getMessage("TX000018619", "사용")%></label>
								<input type="radio" name="displayOption" value="N" id="displayOptionN" <c:if test="${portletSetInfo.val2 == 'N'}">checked</c:if> /> <label for="displayOptionN"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
							</td>
						</tr>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
							<td><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" type="text" style="width: 50px;" id="listCnt" value="${portletSetInfo.val1}" /> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>
						</tr>
					</table>
				</div>
			</c:if>


			<!-- 	             프로젝트(업무관리) 포틀릿 옵션정보정의 -->
			<c:if test="${portletSetInfo.portletTp == 'lr_pj' || portletSetInfo.portletTp == 'cn_pj'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>
			
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<p><input type="checkbox" /> <%=BizboxAMessage.getMessage("TX000003025", "전체선택")%></p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="opValue" id="val01" /> <label for="val01"><%=BizboxAMessage.getMessage("TX000000735", "진행")%></label>
							</td>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" / name="opValue" id="val00" /> <label for="val00"><%=BizboxAMessage.getMessage("TX000010935", "대기")%></label>
							</td>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="opValue" id="val03" /> <label for="val03"><%=BizboxAMessage.getMessage("TX000010934", "지연")%></label>
							</td>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="opValue" id="val04" /> <label for="val04"><%=BizboxAMessage.getMessage("TX000003206", "보류")%></label>
							</td>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="opValue" id="val02" /> <label for="val02"><%=BizboxAMessage.getMessage("TX000001288", "완료")%></label>
							</td>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="opValue" id="val05" /> <label for="val05"><%=BizboxAMessage.getMessage("TX000002947", "취소")%></label>
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
							<td colspan="6"><input onkeydown="return onlyNumber(event)"	onkeyup="removeChar(event)" type="text" style="width: 50px;" id="val2" value="${portletSetInfo.val1}" /> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>
						</tr>
					</table>
				</div>
			</c:if>


			<!-- 	             메일() 포틀릿 옵션정보정의 -->

			<c:if test="${portletSetInfo.portletTp == 'lr_em' || portletSetInfo.portletTp == 'cn_em' || portletSetInfo.portletTp == 'top_em'}">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
			
			<div class="com_ta">
			<table>
				<colgroup>
					<col width="120" />
					<col width="150" />
					<col width="120" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
					<td>
						<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
					</td>
					<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
					<td>
						<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
					<td>
						<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
					</td>
					<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
					<td>
						<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
					</td>
				</tr>
			</table>
			</div>
			
			<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%>  </p>
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="120"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016130", "조회범위")%></th>
						<td class="pd6">
							<select id="mailSelect" name="mailSelect" style="width: 156px;" />
						</td>
						<td style="border-left: 0px;" align="left">
							<input type="checkbox" id="val01" <c:if test="${portletSetInfo.val1 == 'Y'}">checked</c:if>/> <label for="val01"><%=BizboxAMessage.getMessage("TX900000011", "미열람메일만 보기")%></label>	
						</td>
					</tr>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000016282", "목록수")%></th>
						<td colspan="3"><input onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" type="text" style="width: 50px;" id="val02" value="${portletSetInfo.val2}"/> <%=BizboxAMessage.getMessage("TX000001633", "개")%></td>					
					</tr>	
				</table>
			</div>
			</c:if>
			



			<!-- 	             날씨 포틀릿 옵션정보정의 -->
			<c:if test="${portletSetInfo.portletTp == 'lr_weather' || portletSetInfo.portletTp == 'cn_weather'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%>
				</p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000006274", "날씨지역")%></th>
							<td class="pd6">
								<select id="weatherCity" name="weatherCity"	style="width: 156px;" />
							</td>
						</tr>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000012", "API 발급키")%></th>
							<td class="pd6">
								<input id="weatherApiKey" type="text" style="width: 350px;"/>
								<input type="button" class="gray_btn" onclick="weatherApiCheck()" value="<%=BizboxAMessage.getMessage("TX000016178", "연결확인")%>"/>
								<div id="testResultContainer"></div>
							</td>
						</tr>
					</table>
				</div>
			</c:if>
			
			
			<!--  전자결재 현황 포틀릿 -->
			<c:if test="${portletSetInfo.portletTp == 'lr_ea_count' || portletSetInfo.portletTp == 'cn_ea_count'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>
				
				<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000002975", "결재함")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="displayOption" id="val00" <c:if test="${portletSetInfo.val0 == 'Y'}">checked</c:if> /> <label for="val00"><%=BizboxAMessage.getMessage("TX000005555", "미결함")%></label>
								<input type="checkbox" name="displayOption" id="val01" <c:if test="${portletSetInfo.val1 == 'Y'}">checked</c:if> class="ml10"/> <label for="val01"><%=BizboxAMessage.getMessage("TX000010091", "예결함")%></label>
								<input type="checkbox" name="displayOption" id="val02" <c:if test="${portletSetInfo.val2 == 'Y'}">checked</c:if> class="ml10"/> <label for="val02"><%=BizboxAMessage.getMessage("TX000018507", "수신참조함")%></label>
							<%-- 	<input type="checkbox" name="displayOption" id="val03" <c:if test="${portletSetInfo.val3 == 'Y'}">checked</c:if> /> <%=BizboxAMessage.getMessage("", "수신상신함")%> --%>
								
							</td>
						</tr>
						
						<tr>
							<th><%=BizboxAMessage.getMessage("TX900000013", "결재요청문서 상태")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="displayOption" id="val04" <c:if test="${portletSetInfo.val4 == 'Y'}">checked</c:if> /> <label for="val04"><%=BizboxAMessage.getMessage("TX000005556", "상신함")%></label>
							</td>
						</tr>
						
					</table>
				</div>
			</c:if>

			<!--  전자결재(비영리) 현황 포틀릿 -->
			<c:if test="${portletSetInfo.portletTp == 'lr_ea_ea_count' || portletSetInfo.portletTp == 'cn_ea_ea_count'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>
				
				<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000002975", "결재함")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="displayOption" id="val00"  /> <label for="val00"><%=BizboxAMessage.getMessage("TX000008298", "결재대기문서")%></label>
								<input type="checkbox" name="displayOption" id="val01"  /> <label for="val01"><%=BizboxAMessage.getMessage("TX000010199", "결재완료문서")%></label>
								<input type="checkbox" name="displayOption" id="val02"  /> <label for="val02"><%=BizboxAMessage.getMessage("TX000010198", "결재반려문서")%></label>
								<input type="checkbox" name="displayOption" id="val03"  /> <label for="val03"><%=BizboxAMessage.getMessage("TX000010204", "상신문서")%></label>
								<input type="checkbox" name="displayOption" id="val04"  /> <label for="val04"><%=BizboxAMessage.getMessage("TX000010201", "열람문서")%></label>
								<input type="checkbox" name="displayOption" id="val05"  /> <label for="val05"><%=BizboxAMessage.getMessage("TX000010200", "결재예정문서")%></label>
							</td>
						</tr>
						
						<tr>
							<th><%=BizboxAMessage.getMessage("TX900000013", "결재요청문서 상태")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="displayOption" id="val06" <c:if test="${portletSetInfo.val1 == 'Y'}">checked</c:if> /> <label for="val06"><%=BizboxAMessage.getMessage("TX000000475", "진행중")%></label>
							</td>
						</tr>
						
					</table>
				</div>
			</c:if>
			
			<!--  메일 현황 포틀릿 -->
			<c:if
				test="${portletSetInfo.portletTp == 'lr_em_count' || portletSetInfo.portletTp == 'cn_em_count'}">
				
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>
				
				<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000014", "메일현황 내역")%></th>
							<td align="left" style="border-left: 0px;">
								<input type="checkbox" name="displayOption" id="val00" <c:if test="${portletSetInfo.val0 == 'Y'}">checked</c:if> /> <label for="val00"><%=BizboxAMessage.getMessage("TX000001580", "받은편지함")%></label>
								<input type="checkbox" name="displayOption" id="val01" <c:if test="${portletSetInfo.val1 == 'Y'}">checked</c:if> class="ml10"/> <label for="val01"><%=BizboxAMessage.getMessage("TX000000478", "사용량")%></label>
							</td>
						</tr>
					</table>
				</div>
			</c:if>
			
			<!--  결재양식 포틀릿 -->
			<c:if test="${portletSetInfo.portletTp == 'lr_form' || portletSetInfo.portletTp == 'cn_lr_form'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>			
				
				<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="controll_btn mt8">
					<button id=""  onclick="fnEaFormPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
				</div>
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000015", "기본 결재양식")%></th>
							<td>
								<ul class="multibox p0 m0 mr5" style="width: 100%;" id="listBox">

								</ul>
							</td>
							</td>
						</tr>
					</table>
				</div>
			</c:if>
			
			<!--  결재양식 포틀릿(비영리) -->
			<c:if test="${portletSetInfo.portletTp == 'lr_ea_form' || portletSetInfo.portletTp == 'cn_lr_ea_form'}">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006458", "포틀릿")%> <%=BizboxAMessage.getMessage("TX000000878", "명")%></p>
				
				<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="150" />
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000005584", "한글")%></th>
						<td>
							<input id="portletKrName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmKr}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002789", "중국어")%></th>
						<td>
							<input id="portletCnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmCn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000002790", "영어")%></th>
						<td>
							<input id="portletEnName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmEn}" />
						</td>
						<th><%=BizboxAMessage.getMessage("TX000002788", "일본어")%></th>
						<td>
							<input id="portletJpName" type="text" style="width: 100%;" value="${portletSetInfo.portletNmJp}" />
						</td>
					</tr>
				</table>
				</div>			
				
				<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				<div class="controll_btn mt8">
					<button id="" onclick="fnNonEaBoxPop();"><%=BizboxAMessage.getMessage("TX000000602", "등록")%></button>
				</div>					
				
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX900000015", "기본 결재양식")%></th>
							<td>
								<ul class="multibox p0 m0 mr5" style="width: 100%;" id="listBox">

								</ul>
							</td>
							</td>
						</tr>
					</table>
				</div>
			</c:if>
			
			<!-- 연말정산 포틀릿 옵션정보정의  -->
			<c:if test="${portletSetInfo.portletTp == 'lr_tax' || portletSetInfo.portletTp == 'cn_tax'}">							
				<p class="tit_p mt20 fl"><%=BizboxAMessage.getMessage("TX000016167", "옵션정보")%></p>
				
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="120" />
							<col width="" />
						</colgroup>
						<tr>
							<th><img alt="" src="/gw/Images/ico/ico_check01.png"> <%=BizboxAMessage.getMessage("TX000020985", "메신저 날개메뉴")%></th>
							<td>
								<input type="radio" id="useYn3" name="messengerUseYn" value="Y" class="" /> <label for="useYn3"><%=BizboxAMessage.getMessage("TX000000180", "사용")%></label>
								<input type="radio" id="useYn4" name="messengerUseYn" value="N" class="ml10" /> <label for="useYn4"><%=BizboxAMessage.getMessage("TX000001243", "미사용")%></label>
							</td>
						</tr>						
					</table>
				</div>
			</c:if>
			
		</div>
	</c:if>

	<!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button"
				value="<%=BizboxAMessage.getMessage("TX000001256", "저장")%>"
				onclick="fnSavePortal();" /> <input type="button" class="gray_btn"
				value="<%=BizboxAMessage.getMessage("TX000002947", "취소")%>"
				onclick="fnclose();" />
		</div>
	</div>

</div>

<div id="portlet_model" style="display: none;">
	<div link_seq="0" link_nm="" link_url="" file_id="0" use_yn="Y"
		show_from="" show_to="" ssoUseYn="" ssoType="" ssoUserId=""
		ssoCompSeq="" ssoPwd="" sspErpSeq="" ssoLoginCd="" ssoErpCompSeq=""
		class="portal_portlet">
		<span name="link_seq"
			style="padding: 15px; font-size: 10pt; font-weight: bold;"></span> <img
			class="portlet_img" src="" width="200"
			height="${portletSetInfo.abjustHeightSet}"> <span
			class="link_sts"></span> <input onclick="fnbutton('img',this)"
			style="margin-left: 50px;" type="button"
			value="<%=BizboxAMessage.getMessage("TX000016157", "이미지변경")%>" /> <input
			onclick="fnbutton('set',this)" type="button"
			value="<%=BizboxAMessage.getMessage("TX000006443", "링크설정")%>" /> <input
			onclick="fnbutton('del',this)" type="button"
			value="<%=BizboxAMessage.getMessage("TX000000424", "삭제")%>" />
	</div>

	<input name="IMG_PORTAL_BANNER" id="file_upload" type="file" />
</div>