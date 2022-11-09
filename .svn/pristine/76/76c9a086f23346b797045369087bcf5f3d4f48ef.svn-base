<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%@ page import="neos.cmm.util.BizboxAProperties"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    
	<c:if test="${ClosedNetworkYn != 'Y'}">
		<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>
	</c:if>  
	
	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/aes.js?ver=20201021"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/securityEncUtil.js"></script>
	
	<script type="text/javascript">
		var empSignfileId = "${infoMap.signFileId}";
		
    	$(document).ready(function(){
		    //기본버튼
			$("button").kendoButton();    					
			//사진등록임시
			$(".phogo_add_btn").on("click",function(){
				$(".hidden_file_add").click();
			});
			//사인등록임시
			$(".sign_add_btn").on("click",function(){
				if(${loginVO.eaType == 'eap'}) {
					fnSignImgPop();
				} else {
					$(".hidden_file_add2").click();
				} 
				//$(".hidden_file_add2").click();
			});
			//

			$("#phone1").kendoComboBox({
				dataSource : {
				    data : ["010","011","016","017","018","019"]
				},
				value:"010"
			});

			$("#fax1").kendoComboBox({
				dataSource : {
				    data : ["02","031","032","033","041","042","043","044","051","052","053","054","055","061","062","063","064","070","0505"]
				},
				value:"02"
			});

			$("#hometel1").kendoComboBox({
				dataSource : {
				    data : ["02","031","032","033","041","042","043","044","051","052","053","054","055","061","062","063","064","070","0505"]
				},
				value:"02"
			});

			$("#comptel1").kendoComboBox({
				dataSource : {
				    data : ["02","031","032","033","041","042","043","044","051","052","053","054","055","061","062","063","064","070","0505"]
				},
				value:"02"
			});


			$("#language").kendoComboBox({
				dataSource : {
				    data : ["<%=BizboxAMessage.getMessage("TX000002787","한국어")%>","<%=BizboxAMessage.getMessage("TX000002790","영어")%>","<%=BizboxAMessage.getMessage("TX000002789","중국어")%>","<%=BizboxAMessage.getMessage("TX000002788","일본어")%>"]
				},
				value:"<%=BizboxAMessage.getMessage("TX000002787","한국어")%>"
			});

			$("#birthdayYn1").kendoComboBox({
				dataSource : {
				    data : ["<%=BizboxAMessage.getMessage("TX000001076","공개")%>","<%=BizboxAMessage.getMessage("TX000003402","비공개")%>"]
				},
				value:"<%=BizboxAMessage.getMessage("TX000001076","공개")%>"
			});

			// 결혼기념일
		    $("#wedding_date").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });		

		    
		    // 생년월일
		    $("#birthday_date").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });

			//프로필사진등록	
			$("#photofiles").kendoUpload({
				multiple: false,
				localization: {
					select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
			    }
			});

			//사인	
			$("#sign").kendoUpload({
				multiple: false,
				localization: {
					select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
			    }
			});

					    	
			if($("#weddingYn").val() == "Y"){
	    		$("#hideYn").show();	    		
	    	}
	    	if($("#weddingYn").val() == "N"){
	    		$("#hideYn").hide();
	    	}
	    
	    	if("${infoMap.mainCompLoginYn}" == "N"){
	    		$("#mainCompLogin").hide();
	    		document.getElementById("mainCompLoginN").checked = true;
	    	}else{
	    		document.getElementById("mainCompLoginY").checked = true;
	    	}
	    	setLangWidth();

			//외부메일 세팅
			setOutMailInfo();
			
			// 사인이미지 최초 호출
			if(${loginVO.eaType == 'eap'}) {
				fnSignImgInit();	
			}
			
    	});
    	
    	function fnSignImgInit() {
    		if("${infoMap.signType}" == "img") {
    			$("#signTypeClass").hide();	
    			$("#Delbtn_sign").show();
    			$("#img_signFileIdNew").show();
    			signType = "img";
    		} else {
    			var empName = $("#empNameKr").val();
    			signType = "${infoMap.signType}";
    			
    			if(signType == "stamp_de_div") {
    				$("#signStamp").hide();
    			} else {
    				$("#signStamp").show();
    			}
    			
    			$("#Delbtn_sign").css("display", "none");
    			$("#signTypeClass").attr("class", "${infoMap.signType}");
    			$("#signTypeClass").show();	
    			$("#signName").text(empName);
    			$("#img_signFileIdNew").hide();
    			$("#Delbtn_sign").hide();
    		}
    	}
    	
    	function setMainComp(){
    		if(document.getElementById("mainCompLoginN").checked){
    			$("#mainCompLogin").hide();
    		}else{
    			$("#mainCompLogin").show();
    		}    		
    	}
    	
    	function setOutMailInfo(){
    		
			$("#outDomain").on("change",function(){
				if($("#outDomain").val() != ""){
					$("#outDomainText").hide();
					$("#outDomainText").val($("#outDomain").val());
				}else{
					$("#outDomainText").show();
					$("#outDomainText").val("");
					$("#outDomainText").focus();
				}
			});
    		
			var userOutMail = "${infoMap.outMail}";
			var userOutDomain = "${infoMap.outDomain}";
			
			if(userOutMail != "" && userOutDomain != ""){
				$("#outEmail").val(userOutMail);
				$("#outDomainText").val(userOutDomain);
				$("#outDomain").val(userOutDomain);
				
				if($("#outDomain").val() != ""){
					$("#outDomainText").hide();
				}
			}
    	}
    	
    	function emailCheck(emailAddr){

    		var reg_email=/^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[@]{1}[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[.]{1}[A-Za-z]{2,5}$/;
    		
    		if (emailAddr.search(reg_email) == -1){
    		   return false;
    		}
    		
    		return true;
    	}
    	
    	function setLangWidth(){
    		var lang = "${infoMap.nativeLangCode}";
    		if(lang == "en"){
    			$("#langWidth").attr("width","150");
    		}
    	}
    	
    	function fn_pwdPop(type){
			url = "/gw/uat/uia/passwordCheckPop.do?type=" + type + "&pageInfo=myInfoManage";
			var w = 685;
			var h = 405;
			var left = (screen.width/2)-(w/2);
			var top = (screen.height/2)-(h/2);
			var pop = window.open(url, "popup_window", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + "");
    	}
    	
    	function fn_save()
    	{	
    		
    		<c:if test="${userRestricted.outMail == null}">
	    		//외부메일 검증
	    		if($("#outEmail").val() != ""){
	    			if(!emailCheck($("#outEmail").val() + "@" + $("#outDomainText").val())){
	    				alert("<%=BizboxAMessage.getMessage("TX000002513","메일주소 형식이 바르지 않습니다.")%>");
	    				$("#outEmail").focus();
	    				return;
	    			}
	    		}else{
	    			$("#outDomainText").val("");
	    		}
			</c:if>    		
    		
    		<c:if test="${userRestricted.mainWork == null}">
	    		//담당업무 길이제한
	    	    if($("#mainWork").val().length > 128){
					alert("<%=BizboxAMessage.getMessage("TX900000290","담당업무 최대길이는 128입니다.")%>");
					$("#mainWork").focus();
					return;
	    		}
    		</c:if>
    		
    		// 필수 체크 값 체크이벤트
			var checkAlert = fnCheckOption();
			if(checkAlert == "") {
				
				<c:if test="${userRestricted.anniversaryOpen == null}">
					if(document.getElementById("open1").checked)
						$("#privateYn").val("Y");
					else
						$("#privateYn").val("N");
				</c:if>					
				
				if($("#weddingYn").val() == "N"){
					$("#wedding_date").val("");
				}
				
				if(${loginVO.eaType == 'eap'}) {
					
					$("#signType").val(signType);
				}
				
				if($("#picFileId_New").val() != ""){
					var formData = new FormData();
	   	 			var pic = $("#picFileId_New")[0];
	    				
	   	 			formData.append("file", pic.files[0]);
	   	 			formData.append("pathSeq", "910");	//이미지 폴더
	   	 			formData.append("relativePath", ""); // 상대 경로
	    				 
	   	 			$.ajax({
	   	                 url: _g_contextPath_ + "/cmm/file/profileUploadProc.do",
	   	                 type: "post",
	   	                 dataType: "json",
	   	                 data: formData,
	   	                 async:false,
	   	                 processData: false,
	   	                 contentType: false,
	   	                 success: function(data) {
	   	                		$("#picFileIdNew").val(data.fileId);
	   	                 },
	   	                 error: function (result) { 
	   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
	   	 		    			return false;
	   	 		    		}
	   	             });
				}
         		
				if($("#signFileId_New").val() != ""){
					var formData = new FormData();
	   	 			var pic = $("#signFileId_New")[0];
	    				
	   	 			formData.append("file", pic.files[0]);
	   	 			formData.append("pathSeq", "900");	//이미지 폴더
	   	 			formData.append("relativePath", "photo"); // 상대 경로
	    				 
	   	 			$.ajax({
	   	                 url: _g_contextPath_ + "/cmm/file/fileUploadProc.do",
	   	                 type: "post",
	   	                 dataType: "json",
	   	                 data: formData,
	   	                 // cache: false,
	   	                 processData: false,
	   	                 contentType: false,
	   	              	 async:false,
	   	                 success: function(data) {
								$("#signFileIdNew").val(data.fileId);								
	   	                 },
	   	                 error: function (result) { 
	   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
	   	 		    			return false;
	   	 		    		}
	   	             });
				}
				
				if(${loginVO.eaType == 'eap'} && $("#signFileId_New").val() != "" && signImgFlag) {
					var formData = new FormData();
	   	 			var pic = $("#signFileId_New")[0];
	    				
	   	 			formData.append("file", pic.files[0]);
	   	 			formData.append("pathSeq", "900");	//이미지 폴더
	   	 			formData.append("relativePath", "photo"); // 상대 경로
	    				 
	   	 			$.ajax({
	   	                 url: _g_contextPath_ + "/cmm/file/fileUploadProc.do",
	   	                 type: "post",
	   	                 dataType: "json",
	   	                 data: formData,
	   	                 // cache: false,
	   	                 processData: false,
	   	                 contentType: false,
	   	              	 async:false,
	   	                 success: function(data) {
								$("#signFileIdNew").val(data.fileId);								
	   	                 },
	   	                 error: function (result) { 
	   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
	   	 		    			return false;
	   	 		    		}
	   	             });
				}
				
				if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
					$("#secuStrBase").val(btoa(unescape(encodeURIComponent($("#logonPw").val()))));
					document.basicForm.submit();
				} else {
					return;
				}
			} else {
				fnPopAlert(checkAlert);
				return;
			}
			
			
		}
    	
    	function fn_picImgDel()
    	{
			document.getElementById('picFileIdNew').value = '';
   			var picFileImg = document.getElementById('img_picFileIdNew');
   			picFileImg.src = "${pageContext.request.contextPath}/Images/bg/mypage_noimg.png";
           	$("#Delbtn_pic").hide();
           	$("#picTxt").show();
           	$("#Delbtn_pic").hide();
           	
           	$("#p_File").html("");
			var innerHTML = "<input type='file' id='picFileId_New' class='hidden_file_add' name='picFileIdNew' onchange='profileImgUpload(this);'/>";
			$("#p_File").html(innerHTML);			
    		return false;
    	}
    	
    	function fn_signImgDel()
    	{
   			
           	$("#Delbtn_sign").hide();
           	$("#Delbtn_sign").hide();

           	$("#p_File2").html("");
			var innerHTML = "<input type='file' id='signFileId_New' class='hidden_file_add2' name='signFileIdNew' onchange='signImgUpload(this);'/>";
			$("#p_File2").html(innerHTML);
			
			if(${loginVO.eaType == 'eap'}) {
				$("#img_signFileIdNew").css("display", "none");
				if(signType == "img") {
	    			$("#signTypeClass").show();
	    			$("#signTypeClass").attr("class", "stamp_de_div");
	    			$("#signName").text($("#empNameKr").val());
	    			$("#signStamp").hide();
	    			signImgFlag = false;
	    			signType = "stamp_de_div";
	    			
	    		} else {
	    			if(signType == "stamp_de_div") {
	    				$("#signStamp").hide();	
	    			} else {
	    				$("#signStamp").show();
	    			}
	    			
	    		}
			} else {
				var picSignImg = document.getElementById('img_signFileIdNew');
	   			picSignImg.src = "${pageContext.request.contextPath}/Images/bg/sign_noimg.png";
				document.getElementById('signFileIdNew').value = '';
			}
    		
   			
    		return false;
    	}
    	
    	function fn_signImgDelCallBack()
    	{
   			document.getElementById('signFileIdNew').value = '';
   			var picSignImg = document.getElementById('img_signFileIdNew');
   			picSignImg.src = "${pageContext.request.contextPath}/Images/bg/sign_noimg.png";
           	$("#Delbtn_sign").hide();
           	$("#Delbtn_sign").hide();

           	$("#p_File2").html("");
			var innerHTML = "<input type='file' id='signFileId_New' class='hidden_file_add2' name='signFileIdNew' onchange='signImgUpload(this);'/>";
			$("#p_File2").html(innerHTML);
    		return false;
    	}
    	
    	
    	function phoneCheck(obj) {
   			 var n = obj.value.replace(/\-/g, "");
   	   	       var len = n.length;
   	   	       var number=n;
   	   	       if(len > 3){
   	   	         number=n.substring(0, 3)+"-";
   	   	         if(len > 3 && len < 7){
   	   	           number+=n.substring(3);
   	   	         }else if(len > 6 && len < 11){
   	   	           number+=n.substring(3, 6)+"-"+n.substring(6);
   	   	         }else if(len == 11){
   	   	           number+=n.substring(3, 7)+"-"+n.substring(7);
   	   	         }
   	   	       }
   	   	       obj.value = number;	
   	      
  	     }
    	
    function setWedding(){
    	if($("#weddingYn").val() == "Y"){
    		var d = new Date();
            var s =leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2);
            $("#wedding_date").val(s);
    		$("#hideYn").show();
    	}
    	if($("#weddingYn").val() == "N"){
    		$("#hideYn").hide();
    	}
    }
    
    function setLunar(){
    	if($("#lunarYn").val() != ""){
    		var d = new Date();
            var s =leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2);
            if($("#birthday_date").val() == ""){
            	$("#birthday_date").val(s);
            }
    		$("#bdayYn").show();
    	}else{
    		$("#bdayYn").hide();
    	}
    }
    
    function leadingZeros(n, digits) {
        var zero = '';
        n = n.toString();
        if (n.length < digits) {
            for (i = 0; i < digits - n.length; i++)
                zero += '0';
        }
        return zero + n;
    }

	function fnCheckOption() {
		var checkConfirm = '';
		
		if("${userRequired.picImg}" == "Y" && $("#picFileIdNew").val() == "" && $("#img_picFileIdNew").attr("src") == "/gw/Images/bg/mypage_noimg.png") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000000082","사진")%>,';
		}
		
		if(${loginVO.eaType == 'eap'}) {
			if("${userRequired.signImg}" == "Y") {
				
				//  && 
				if(signType == "img") {
					if($("#signFileIdNew").val() == "" && $("#Old_signFileId").val() != "" && signImgFlag) {
						checkConfirm += '<%=BizboxAMessage.getMessage("TX000000086","사인")%>,';
					}
				} else {
					if(signType == "") {
						checkConfirm += '<%=BizboxAMessage.getMessage("TX000000086","사인")%>,';
					}
				}
				
					
			}
		} else {
			if("${userRequired.signImg}" == "Y" && $("#signFileIdNew").val() == "" && $("#Old_signFileId").val() != "") {
				checkConfirm += '<%=BizboxAMessage.getMessage("TX000000086","사인")%>,';	
			}
		} 
		
		if("${userRequired.mainWork}" == "Y" && $("#mainWork").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000000088","담당업무")%>,';	
		}
		
		if("${userRequired.empName}" == "Y" && $("#empNameKr").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000000277","이름")%>,';
		}
		
		if("${userRequired.telNum}" == "Y" && $("#comptel").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000016136","전화번호(회사)")%>,';	
		}
		
		if("${userRequired.homeTelNum}" == "Y" && $("#hometel").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000004107","전화번호(집)")%>,';	
		}
		
		if("${userRequired.addr}" == "Y" && $("#compZipCode").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000004113","주소(회사)")%>,';	
		}
		
		if("${userRequired.homeAddr}" == "Y" && $("#zipCode").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000004110","주소(집)")%>,';	
		}
		
		if("${userRequired.faxNum}" == "Y" && $("#fax").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000000074","팩스번호")%>,';
		}
		
		if("${userRequired.mobileTelNum}" == "Y" && $("#phone").val() == "") {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000000654","휴대전화")%>,';
		}
		
		if("${userRequired.outMail}" == "Y" && ($("#outEmail").val() == "" || $("#outDomainText").val() == "")) {
			checkConfirm += '<%=BizboxAMessage.getMessage("TX000020523","개인메일")%>,';
		}
		
		if(checkConfirm != ""){
			return checkConfirm.slice(0, -1);	
		}
		
		return checkConfirm;
	}
	
	// 코드 유형 및 기본값 선택 팝업 호출
	function fnPopAlert(result) {
		$("#resultMessage").val(result);
		var url = '<c:url value="/cmm/cmmPage/cmmCheckPop.do?"/>';
		var w = 520;
		var h = 206;
		var left = (screen.width/2)-(w/2);
		var top = (screen.height/2)-(h/2);
		  
		var pop = window.open('', "popup_window",
				"width=520,height=205, left=" + left + ", top=" + top + ", location=no");
		
		checkMessage.method = "post";
		checkMessage.action = url; 
		checkMessage.submit(); 
	    pop.focus();   

	}
	
	var signType = "";
	function fnSignImgPop() {
		// 기존 선택된 사인 이미지
		if(signType == "") {
			signType = "${infoMap.signType}";	
		}
		
        window.open("", "singImgPop", "width=430,height=350,scrollbars=yes") ;
        
        var frmData = document.signPopForm ;
        
        frmData.target = "singImgPop";
		$('input[name="stamp"]').val(signType);
		$('input[name="empName"]').val($("#empNameKr").val());
		$('input[name="groupSeq"]').val("${infoMap.groupSeq}");
		$('input[name="langCode"]').val("${infoMap.nativeLangCode}");
		$('input[name="empSeq"]').val("${infoMap.empSeq}");
		$('input[name="compSeq"]').val("${infoMap.compSeq}");
		
		frmData.submit();
	}
	
	
	function getImgSrc(){
		return $("#img_signFileIdNew").attr("src");
	}
	
	function getSignFileId(){
		return empSignfileId;
	}
	
	var signImgFlag = false;
	function fnCallBack(signTypeCallback) {
		$("#signType").val(signTypeCallback);
		
		signType = signTypeCallback;
		
		var empName = $("#empNameKr").val();
		
		if(signTypeCallback != "img") {
			$("#img_signFileIdNew").hide();
			$("#signTypeClass").show();	
			
			$("#signTypeClass").attr("class", signTypeCallback);
			$("#signName").text(empName);
			$("#Delbtn_sign").hide();
			
			if(signTypeCallback == "stamp_de_div") {
				$("#signStamp").hide();
			} else {
				$("#signStamp").show();
			}
			
			signImgFlag = false;

		} else {
			console.log("img");
			$("#signTypeClass").hide();
		}
	}
	
	function fnCallBackImg(signTypeCallback, imgSrc, signImgValue, signFileId) {
		signType = "img";
		
		if(typeof signImgValue == "undefined") {
			signImgFlag = false;
		} else {
			signImgFlag = true;	
		}
		
		$("#signFileIdNew").val(signFileId);
		$("#signTypeClass").hide();	
		$("#img_signFileIdNew").show();
		$("#signType").val(signTypeCallback);
		$("#Delbtn_sign").show();
		$("#img_signFileIdNew").attr("src", imgSrc);
	}
	</script>
    <script id="treeview-template" type="text/kendo-ui-template">
	        #: item.text #
	</script>
</head>

<style>
.iframe_wrap{min-width:1100px;}
</style>

<form id="signPopForm" name="signPopForm" method="post" action="/gw/cmm/systemx/signPop.do" target="popup_window">
  <input name="page" value="myPage" type="hidden"/>
  <input name="stamp" value="" type="hidden"/>
  <input name="empName" value="" type="hidden"/>
  <input name="groupSeq" value="" type="hidden"/>
  <input name="langCode" value="" type="hidden"/>
  <input name="empSeq" value="" type="hidden"/>
  <input name="compSeq" value="" type="hidden"/>  
</form>


<form id="checkMessage" name="checkMessage" method="post" target="popup_window">
	<input type="hidden" id="resultMessage" name="resultMessage" value=""/>
	<input type="hidden" id="resultContent" name="resultContent" value="<%=BizboxAMessage.getMessage("TX900000292","필수값이입력되지않았습니다.")%>"/>
</form>

<body>

	<div class="btn_div">
		<div class="left_div"><h5><%=BizboxAMessage.getMessage("TX000016397","개인정보")%></h5></div>
		<div class="right_div">
			<div id="" class="controll_btn p0"><button sel_mode="view" onclick="fnEditBtn();"><%=BizboxAMessage.getMessage("TX000001179","수정")%></button></div>
		</div>
	</div>


	<div class="sub_contents_wrap sub_contents_border">
	<form id="basicForm" name="basicForm" action="myInfosaveProc.do" method="post" onsubmit="return false;">
		<!-- 왼쪽 콘텐츠-->
		<div class="sub_left" style="border: none;"> 
			<div class="mb20" style="padding:15px 14px;">
				
			<ul>
				<li class="mypage_file">
					<p class="imgfile" id="">
						<span class="posi_re dp_ib">
							<img id="img_picFileIdNew" src="${profilePath}/${infoMap.empSeq}_thum.jpg?<%=System.currentTimeMillis()%>" onerror="this.src='/gw/Images/bg/mypage_noimg.png';noImgSet('img');$('#picTxt').show();" />
							<c:if test="${userRestricted.picImg == null}">
							<span sel_mode="edit" class="txt" id="picTxt" style="display:none;"><%=BizboxAMessage.getMessage("TX000020286","사진을 등록해 주세요")%> <br /> (120*160)</span>
							<a sel_mode="edit" style="display:none;" href="#n" class="del_btn" title="삭제" id="Delbtn_pic" onclick="return fn_picImgDel();"></a>					
							</c:if>	
						</span>
					</p> 
				</li>
				<li class="mt7 controll_btn p0">
					<div class="mypage_file_upload">	
						<p id="p_File">
							<input type="file" id="picFileId_New" class="hidden_file_add" name="picFileIdNew" onchange="profileImgUpload(this);"/>
						</p>
						<span id="checkOptionPhoto" style="display:none" sel_mode="edit">
						<c:if test="${userRequired.picImg == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if>
						</span>
						<c:if test="${userRestricted.picImg == null}">
						<div sel_mode="edit" style="display:none;">
						<button id="photoRegButton" class="phogo_add_btn"><%=BizboxAMessage.getMessage("TX000016206","사진등록/변경")%></button>
						</div>
						</c:if>							
						<input id="picFileIdNew" name="picFileId" type="hidden" value="${infoMap.picFileId}" />
						<input id="Old_picFileId" name="Old_picFileId" type="hidden" value="${infoMap.picFileId}"/>
					</div>
				</li>
			</ul>
			<!-- 사인 등록 -->
			<ul class="mt20">
				<li class="mypage_file_sign">
					<div class="sign" id="">
						<div class="sign_sel">
							<div id="signTypeImg" class="cen" >
		                        <p id="signTypeClass" class="stamp_de_div" style="display:none">
		                            <span id="signName"></span><span id="signStamp" class=""><%=BizboxAMessage.getMessage("TX900000291","인")%></span>
		                        </p>
								<c:if test="${infoMap.signFileId ne NULL}">
									<img id="img_signFileIdNew"
										src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${infoMap.signFileId}&fileSn=0' />"
										onerror="this.src='/gw/Images/bg/mypage_noimg.png';noImgSet('sign');"
										/>
								</c:if>	
								<c:if test="${infoMap.signFileId eq NULL}">
									<img id="img_signFileIdNew"
										src="<c:url value='/Images/bg/sign_noimg.png' />"
										/>
								</c:if>
								<c:if test="${userRestricted.signImg == null}">
									<div sel_mode="edit" style="display:none;">
									<a href="#n" class="del_btn" title="삭제" id="Delbtn_sign" onclick="return fn_signImgDel();"></a>
									</div>
								</c:if>	
							</div>
						</div>
					</div>
				</li>
				<li class="mt7 controll_btn p0">							
					<div class="mypage_file_upload">	
						<p id="p_File2">
							<input type="file" id="signFileId_New" class="hidden_file_add2" name="signFileIdNew" onchange="signImgUpload(this);"/>
						</p>
						<span id="checkOptionSign"><c:if test="${userRequired.signImg == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span>
						<c:if test="${userRestricted.signImg == null}">
						<div sel_mode="edit" style="display:none;">
						<button id="signRegButton" class="sign_add_btn"><%=BizboxAMessage.getMessage("TX000016210","사인등록/변경")%></button>
						</div>
						</c:if>							
						<input id="signFileIdNew" name="signFileId" type="hidden" value="${infoMap.signFileId}" />
						<input id="Old_signFileId" name="Old_signFileId" type="hidden" value="${infoMap.signFileId}"/>
					</div>
				</li>
			</ul>
			</div>
		</div>
		<!-- 왼쪽 콘텐츠 end -->
		<input type="hidden" id="empSeq" name="empSeq" value="${infoMap.empSeq}"/>
		<input type="hidden" id="erpEmpNum" name="erpEmpNum" value="${erpMap.erpEmpSeq}"/>
		<input type="hidden" id="signType" name="signType" value=""/>
		<input type="hidden" id="secuStrBase" name="secuStrBase" value=""/>
		
		<!-- 오른쪽 콘텐츠-->
		<div class="sub_con">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="8%"/>
						<col width="10%"/>
						<col width="35%"/>
						<col width="15%"/>	 <!-- id="langWidth"	-->	
						<col width="32%"/>
					</colgroup>
					<tr>
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000000110","입사일")%></th>
						<td>${infoMap.joinDay}</td>
						<th><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></th>
						<td>${erpMap.erpEmpSeq}</td>
					</tr>
					<tr>
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000000075","아이디")%></th>
						<td>${infoMap.loginId}</td>
						<th><%=BizboxAMessage.getMessage("TX000000949","메일주소")%></th>
						<td><c:if test="${infoMap.emailAddr != '' && infoMap.emailDomain != '' }">${infoMap.emailAddr}@${infoMap.emailDomain }</c:if> </td>
					</tr>
					<tr>
						<th rowspan="4"><span id="checkOptionName"><c:if test="${userRequired.empName == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
						<th><span id="checkOptionNameKr"><c:if test="${userRequired.empName == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
						<td>
							<span <c:if test="${userRestricted.empName == null}">sel_mode="view"</c:if>><c:out value="${infoMap.empNameKr}"/></span>	
							<c:if test="${userRestricted.empName == null}">
							<input sel_mode="edit" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.empNameKr}"/>" name="empNameKr" id="empNameKr"/>
							</c:if>
						</td>
						<th><span id="checkOptionSex"></span><%=BizboxAMessage.getMessage("TX000000081","성별")%></th>
						<td>
							<span sel_mode="view">
							<c:if test="${infoMap.genderCode == 'F'}"><%=BizboxAMessage.getMessage("TX000007647","여자")%></c:if>
							<c:if test="${infoMap.genderCode == 'M'}"><%=BizboxAMessage.getMessage("TX000007648","남자")%></c:if>
							</span>
							
							<div sel_mode="edit" style="display:none;">
								<input type="radio" name="mf" id="mf1" class="k-radio" value="F" <c:if test="${infoMap.genderCode == 'F' || infoMap.genderCode == ''}">checked</c:if>/>
								<label class="k-radio-label radioSel" for="mf1"><%=BizboxAMessage.getMessage("TX000007647","여자")%></label>
								<input type="radio" name="mf" id="mf2" class="k-radio" value="M" <c:if test="${infoMap.genderCode == 'M'}">checked</c:if>/>
								<label class="k-radio-label radioSel ml10" for="mf2"><%=BizboxAMessage.getMessage("TX000007648","남자")%></label>
							</div>
						</td>
					</tr>
					<tr>
					  <th><%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
					  <td>
						<span <c:if test="${userRestricted.empName == null}">sel_mode="view"</c:if>><c:out value="${infoMap.empNameEn}"/></span>	
						<c:if test="${userRestricted.empName == null}">
						<input sel_mode="edit" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.empNameEn}"/>" name="empNameEn" id="empNameEn"/>
						</c:if>
					  </td>
					  <th><%=BizboxAMessage.getMessage("TX000015416","로그인 비밀번호")%></th>
					  <td>
					  	<c:if test="${userRestricted.password_def == 'Y'}"><%=BizboxAMessage.getMessage("TX000003352","수정불가")%></c:if>
						<div id="" class="controll_btn p0" <c:if test="${userRestricted.password_def == 'Y'}">style="display:none;"</c:if>>
							<button id="" onclick="fn_pwdPop('def');"><%=BizboxAMessage.getMessage("TX000003226","변경")%></button>
						</div>						
					  </td>
					</tr>
					<tr>
					  <th><%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
					  <td>
						<span <c:if test="${userRestricted.empName == null}">sel_mode="view"</c:if>><c:out value="${infoMap.empNameJp}"/></span>	
						<c:if test="${userRestricted.empName == null}">
						<input sel_mode="edit" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.empNameJp}"/>" name="empNameJp" id="empNameJp"/>
						</c:if>					  
					  </td>
					  <th><%=BizboxAMessage.getMessage("TX000015415","결재 비밀번호")%></th>
					  <td>
					  	<c:if test="${userRestricted.password_app == 'Y'}"><%=BizboxAMessage.getMessage("TX000003352","수정불가")%></c:if>
						<div id="" class="controll_btn p0" <c:if test="${userRestricted.password_app == 'Y'}">style="display:none;"</c:if>>
							<button id="btnAppPwd" onclick="fn_pwdPop('app');"><%=BizboxAMessage.getMessage("TX000003226","변경")%></button>
						</div>
					  </td>
					</tr>
					<tr>
					  <th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
					  <td>
						<span <c:if test="${userRestricted.empName == null}">sel_mode="view"</c:if>><c:out value="${infoMap.empNameCn}"/></span>	
						<c:if test="${userRestricted.empName == null}">
						<input sel_mode="edit" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.empNameCn}"/>" name="empNameCn" id="empNameCn"/>
						</c:if>						  
					  </td>
					  <th><%=BizboxAMessage.getMessage("TX000016355","급여 비밀번호")%></th>
					  <td>
					  	<c:if test="${userRestricted.password_pay == 'Y'}"><%=BizboxAMessage.getMessage("TX000003352","수정불가")%></c:if>
						<div id="" class="controll_btn p0" <c:if test="${userRestricted.password_pay == 'Y'}">style="display:none;"</c:if>>
							<button id="btnPayPwd" onclick="fn_pwdPop('pay');"><%=BizboxAMessage.getMessage("TX000003226","변경")%></button>
						</div>
					  </td>
					</tr>
					<tr>
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
						<td>${infoMap.deptName}</td>
						
						<th><span id="checkOptionWork"><c:if test="${userRequired.mainWork == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000000088","담당업무")%></th>
						<td>
							<span <c:if test="${userRestricted.mainWork == null}">sel_mode="view"</c:if>><c:out value="${infoMap.mainWork}"/></span>	
							<c:if test="${userRestricted.mainWork == null}">
							<input sel_mode="edit" type="text" value="<c:out value="${infoMap.mainWork}"/>" style="width:100%;display:none;" id="mainWork" name="mainWork" />
							</c:if>							
						</td>
					</tr>
					<tr>
						<th colspan="2"> <%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
						<td>${infoMap.positionCodeName}</td>
						<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
						<td>${infoMap.dutyCodeName}</td>
					</tr>									
					<tr>
						<th colspan="2">
							<span id="checkOptionCompTel"><c:if test="${userRequired.telNum == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000016136","전화번호(회사)")%>
						</th>
						<td>
							<span <c:if test="${userRestricted.telNum == null}">sel_mode="view"</c:if>><c:out value="${infoMap.telNum}"/></span>	
							<c:if test="${userRestricted.telNum == null}">
							<input sel_mode="edit" id="comptel" name="comptel" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.telNum}"/>"/>
							</c:if>								
						</td>
						<th><span id="checkOptionHomeTel"><c:if test="${userRequired.homeTelNum == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000004107","전화번호(집)")%></th>
						<td>
							<span <c:if test="${userRestricted.homeTelNum == null}">sel_mode="view"</c:if>><c:out value="${infoMap.homeTelNum}"/></span>	
							<c:if test="${userRestricted.homeTelNum == null}">
							<input  id="comptel" name="comptel" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.telNum}"/>"/>
							<input sel_mode="edit" id="hometel" name="hometel" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.homeTelNum}"/>"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th colspan="2"><span id="checkOptionPhone"><c:if test="${userRequired.mobileTelNum == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
						<td>
							<span <c:if test="${userRestricted.mobileTelNum == null}">sel_mode="view"</c:if>><c:out value="${infoMap.mobileTelNum}"/></span>	
							<c:if test="${userRestricted.mobileTelNum == null}">
							<input sel_mode="edit" id="phone" name="phone" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.mobileTelNum}"/>"/>
							</c:if>
						</td>
						<th><span id="checkOptionFax"><c:if test="${userRequired.faxNum == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
						<td>
							<span <c:if test="${userRestricted.faxNum == null}">sel_mode="view"</c:if>><c:out value="${infoMap.faxNum}"/></span>	
							<c:if test="${userRestricted.faxNum == null}">
							<input sel_mode="edit" id="fax" name="fax" type="text" style="width:100%;display:none;" value="<c:out value="${infoMap.faxNum}"/>"/>
							</c:if>						
						</td>
					</tr>
					<tr>
						<th colspan="2"><span  id="checkOptionCompAddress"><c:if test="${userRequired.addr == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000004113","주소(회사)")%></th>
						<td colspan="3" class="pd6">
						
							<span <c:if test="${userRestricted.addr == null}">sel_mode="view"</c:if>>${infoMap.deptZipCode}</span>	
							<c:if test="${userRestricted.addr == null}">
								<input sel_mode="edit" type="text" value="${infoMap.deptZipCode}" style="width:88px;display:none;" id="compZipCode" name="compZipCode" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="<%=BizboxAMessage.getMessage("TX000000009","우편번호")%>"</c:if>>
								<c:if test="${ClosedNetworkYn != 'Y'}">
									<div sel_mode="edit" class="controll_btn p0" style="display:none;">
										<button id="btnCompZip" onclick="fnZipPop(this);"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
									</div>							
								</c:if>
							</c:if>							
							
							<div class="mt5">
								<span <c:if test="${userRestricted.addr == null}">sel_mode="view"</c:if>><c:out value="${infoMap.deptAddr}"/> <c:out value="${infoMap.deptDetailAddr}"/></span>	
								<c:if test="${userRestricted.addr == null}">
								<input sel_mode="edit" class="mr5" type="text" id="comp_addr" name="comp_addr" value="<c:out value="${infoMap.deptAddr}"/>" style="float:left; width:40%;display:none;"/>
								<input sel_mode="edit" type="text" id="comp_detailaddr" name="comp_detailaddr" value="<c:out value="${infoMap.deptDetailAddr}"/>" style="float:left; width:57%;display:none;"/>
								</c:if>										
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2"><span id="checkOptionHomeAddress"><c:if test="${userRequired.homeAddr == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span> <%=BizboxAMessage.getMessage("TX000004110","주소(집)")%></th>
						<td colspan="3" class="pd6">
						
							<span <c:if test="${userRestricted.homeAddr == null}">sel_mode="view"</c:if>>${infoMap.zipCode}</span>	
							<c:if test="${userRestricted.homeAddr == null}">
								<input sel_mode="edit" type="text" value="${infoMap.zipCode}" style="width:88px;display:none;" id="zipCode" name="zipCode" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="<%=BizboxAMessage.getMessage("TX000000009","우편번호")%>"</c:if>>
								<c:if test="${ClosedNetworkYn != 'Y'}">
									<div sel_mode="edit" class="controll_btn p0" style="display:none;">
										<button id="btnZip" onclick="fnZipPop(this);"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
									</div>							
								</c:if>
							</c:if>							
							
							<div class="mt5">
								<span <c:if test="${userRestricted.homeAddr == null}">sel_mode="view"</c:if>><c:out value="${infoMap.addr}"/> <c:out value="${infoMap.detailAddr}"/></span>	
								<c:if test="${userRestricted.homeAddr == null}">
								<input sel_mode="edit" class="mr5" type="text" id="home_addr" name="home_addr" value="<c:out value="${infoMap.addr}"/>" style="float:left; width:40%;display:none;"/>
								<input sel_mode="edit" type="text" id="home_detailaddr" name="home_detailaddr" value="<c:out value="${infoMap.detailAddr}"/>" style="float:left; width:57%;display:none;"/>
								</c:if>									
							</div>
						</td>
					</tr>
					 <tr>						
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000000083","생년월일")%></th>
					   <td>
							<span <c:if test="${userRestricted.homeAddr == null}">sel_mode="view"</c:if>>${infoMap.bday}
								<c:if test="${infoMap.bday != null && infoMap.bday != ''}">
									<c:choose>
									<c:when test="${infoMap.lunarYn == 'Y'}">
									(<%=BizboxAMessage.getMessage("TX000005617","양력")%>)
									</c:when>
									<c:otherwise>
									(<%=BizboxAMessage.getMessage("TX000005616","음력")%>)
									</c:otherwise>
									</c:choose>
								</c:if>
							</span>							
								
							<c:if test="${userRestricted.bday == null}">
							<div sel_mode="edit" style="display:none;">
								<select onchange="setLunar();" id="lunarYn" name="lunarYn" style="width:70px;<c:if test="${userRestricted.bday == 'Y'}">display:none;</c:if>">							
									<option value="" ><%=BizboxAMessage.getMessage("TX000000265","선택")%></option>
								 	<option value="Y" <c:if test="${'Y' == infoMap.lunarYn}">selected</c:if>><%=BizboxAMessage.getMessage("TX000005617","양력")%></option>
								 	<option value="N" <c:if test="${'N' == infoMap.lunarYn}">selected</c:if>  ><%=BizboxAMessage.getMessage("TX000005616","음력")%></option>
								</select>
								<span id="bdayYn" style="<c:if test="${infoMap.bday == null}">display:none;</c:if>"><input id="birthday_date" name="birthday_date" value="${infoMap.bday}" class="dpWid" /></span>							
							</div>
							</c:if>							   
						</td>
						<th><%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></th>
						<td>
						
							<span <c:if test="${userRestricted.weddingDay == null}">sel_mode="view"</c:if>>
								<c:choose>
								<c:when test="${infoMap.weddingYn == 'Y' && infoMap.weddingDay != null && infoMap.weddingDay != ''}">
								${infoMap.weddingDay}
								</c:when>
								<c:otherwise>
								<%=BizboxAMessage.getMessage("TX000006273","미혼")%>
								</c:otherwise>
								</c:choose>
							</span>	

							<c:if test="${userRestricted.weddingDay == null}">
							<div sel_mode="edit" style="display:none;">
								<select id="weddingYn" name="weddingYn" onchange="setWedding();" style="width:70px;">
								 	<option value="N"><%=BizboxAMessage.getMessage("TX000006273","미혼")%></option>
								 	<option value="Y" <c:if test="${'Y' == infoMap.weddingYn}">selected</c:if> ><%=BizboxAMessage.getMessage("TX000006272","기혼")%></option>
								</select>
								<span id="hideYn"><input class="dpWid" id="wedding_date" name="wedding_date" value="${infoMap.weddingDay}" class="dpWid" /></span>
							</div>
							</c:if>
							
						</td>	
					</tr>
					<tr>	
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000016354","기념일 공개 여부")%></th>						
						<td>
						
							<span <c:if test="${userRestricted.anniversaryOpen == null}">sel_mode="view"</c:if>>
								<c:choose>
								<c:when test="${infoMap.privateYn == 'Y'}">
								<%=BizboxAMessage.getMessage("TX000001076","공개")%>
								</c:when>
								<c:otherwise>
								<%=BizboxAMessage.getMessage("TX000003402","비공개")%>
								</c:otherwise>
								</c:choose>
							</span>
							
							<c:if test="${userRestricted.anniversaryOpen == null}">
								<div sel_mode="edit" style="display:none;">
									<input type="radio" name="open" id="open1" class="k-radio" value="Y" <c:if test="${infoMap.privateYn == 'Y' }">checked</c:if>  />
									<label class="k-radio-label radioSel" for="open1"><%=BizboxAMessage.getMessage("TX000001076","공개")%></label>
									<input type="radio" name="open" id="close2" class="k-radio"  value="N" <c:if test="${infoMap.privateYn == 'N' }">checked</c:if> />
									<label class="k-radio-label radioSel ml10" for="close2"><%=BizboxAMessage.getMessage("TX000003402","비공개")%></label>
									<input type="hidden" id="privateYn" name="privateYn"/>
								</div>
							</c:if>														
							
						</td>
						<th><%=BizboxAMessage.getMessage("TX000000090","사용언어")%></th>
						<td>	
							<span sel_mode="view">
							 	<c:forEach items="${langList}" var="list">
							 		<c:if test="${list.detailCode == infoMap.nativeLangCode}">${list.detailName}</c:if>
							 	</c:forEach>
							</span>
							
							<div sel_mode="edit" style="display:none;">						
								<select id="nativeLangCode" name="nativeLangCode">
								 	<c:forEach items="${langList}" var="list">
								 		<option value="${list.detailCode}" <c:if test="${list.detailCode == infoMap.nativeLangCode}">selected</c:if> >${list.detailName}</option>
								 	</c:forEach>
								</select>
								<input type="hidden" id="oldLangCode" name="oldLangCode" value="${infoMap.nativeLangCode}" />
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2"><%=BizboxAMessage.getMessage("TX000003909","기본로그인회사")%></th>
						<td colspan="3">	

							<span sel_mode="view">
								<c:choose>
								<c:when test="${infoMap.mainCompLoginYn == 'Y'}">
								 	<c:forEach items="${selectList}" var="list">
								 		<c:if test="${list.compSeq == infoMap.mainCompSeq}">${list.compName}</c:if>
								 	</c:forEach>
								</c:when>
								<c:otherwise>
								<%=BizboxAMessage.getMessage("TX000018611","미사용")%>
								</c:otherwise>
								</c:choose>							
							</span>
							
							<div sel_mode="edit" style="display:none;">
								<input type="radio" name="mainCompLoginYn" id="mainCompLoginY" class="k-radio" value="Y" onclick="setMainComp();"/>
								<label class="k-radio-label radioSel" for="mainCompLoginY"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
								<input type="radio" name="mainCompLoginYn" id="mainCompLoginN" class="k-radio"  value="N" onclick="setMainComp();"/>
								<label class="k-radio-label radioSel ml10" for="mainCompLoginN"><%=BizboxAMessage.getMessage("TX000018611","미사용")%></label>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="hidden" id="privateYn" name="privateYn"/>
								<input type="hidden" id="oriMainCompSeq" name="oriMainCompSeq" value="${infoMap.mainCompSeq}"/>
								<span id="mainCompLogin">
									<select id="mainCompSeq" name="mainCompSeq" style="width:200px;">								
									 	<c:forEach items="${selectList}" var="list">
									 		<option value="${list.compSeq}" <c:if test="${list.compSeq == infoMap.mainCompSeq}">selected </c:if> >${list.compName}</option>
									 	</c:forEach>
									</select>
								</span>		
							</div>
						</td>	
					</tr>
					<tr>
						<th colspan="2"><span id="checkOptionMail"><c:if test="${userRequired.outMail == 'Y'}"><img src=${pageContext.request.contextPath}/Images/ico/ico_check01.png alt="" /></c:if></span><%=BizboxAMessage.getMessage("TX000020288","개인메일")%></th>
						<td colspan="3">
						
						
							<span <c:if test="${userRestricted.outMail == null}">sel_mode="view"</c:if>>
								<c:choose>
								<c:when test="${infoMap.outMail != null && infoMap.outDomain != null && infoMap.outMail != '' && infoMap.outDomain != ''}">
								${infoMap.outMail}@${infoMap.outDomain}
								</c:when>
								<c:otherwise>
								<%=BizboxAMessage.getMessage("TX000010915","미설정")%>								
								</c:otherwise>
								</c:choose>
							</span>						
						
							<c:if test="${userRestricted.outMail == null}">
								<div sel_mode="edit" style="display:none;">
									<input type="text" value="" style="width:150px;" id="outEmail" name="outEmail"/>
									@
									<input type="text" value="" style="width:100px;" id="outDomainText" name="outDomainText"/>
									<select id="outDomain" name="outDomain">
										<option value="" selected ><%=BizboxAMessage.getMessage("TX000001021","직접입력")%></option>
										<option value="naver.com">naver.com</option>
										<option value="hanmail.net">hanmail.net</option>
										<option value="nate.com">nate.com</option>
										<option value="gmail.com">gmail.com</option>
										<option value="hotmail.com">hotmail.com</option>
										<option value="lycos.co.kr">lycos.co.kr</option>
										<option value="empal.com">empal.com</option>
										<option value="dreamwiz.com">dreamwiz.com</option>
										<option value="korea.com">korea.com</option>
									</select>
								</div>
							</c:if>							
						</td>										
					</tr>					
				</table>
			</div>
			
			<div sel_mode="edit" style="display:none;" class="btn_cen mt20">
				<input tabindex="0" role="button" aria-disabled="false" onclick="fn_save();" type="button" data-role="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>"></input>
				<input onclick="fn_cancel();" type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>"></input>
			</div>
			
		</div>
		<!-- 오른쪽 컨텐츠 end-->
	</form>
	</div>
	
	<div id="dialogContent" style="display:none;text-align: center;">
		<br/>
		<span style="font-size: 15px;"><%=BizboxAMessage.getMessage("TX000014886","로그인 패스워드를 입력하세요.")%></span>
		<br/>
		<input id="logonPw" onkeydown="if(event.keyCode==13){javascript:$('#btnConfirm').click();}" onfocus="$('#dialogContentErrorMSg').html('');$(this).css('border-color','');" autocomplete="new-password" type="password" style="  margin-top: 20px; margin-bottom: 5px; height: 30px;  text-align: center; font-size: 15px;  width: 270px;cursor: pointer;" placeholder="<%=BizboxAMessage.getMessage("TX000004122","패스워드")%>" />
		<br/>
		<span id="dialogContentErrorMSg" style="font-size:12px;color:red;"></span>
	</div>
</body>
</html>

<script>

	$(document).ready(function() {		
		var picFileImg = document.getElementById('img_picFileIdNew');
		var signFileImg = document.getElementById('img_signFileIdNew');
		
		if("${userRestricted.password_def}" == 'Y'){		
			if(document.getElementById('picFileIdNew').value == ''){
				document.getElementById('img_picFileIdNew').src = '/gw/Images/bg/mypage_noimg.png';
				$("#picTxt").show();
				$("#Delbtn_pic").hide();
			} else {
				$("#picTxt").hide();
				$("#Delbtn_pic").show();
			}
		}
		
		if(signFileImg != null && document.getElementById('signFileIdNew').value == ''){
			$("#signImgId").show();
			$("#Delbtn_sign").hide();
		} else {
			if(${loginVO.eaType == 'eap'}) {
				if(signType == "" || signType == "img") {
					$("#Delbtn_sign").show();
				} else {
					$("#Delbtn_sign").hide();	
				}
			} else {
				$("#Delbtn_sign").show();	
			}
			
		}
		
		$("#nativeLangCode").kendoDropDownList();
		$("#mainCompSeq").kendoDropDownList();
		
		if("${infoMap.picFileId}" == ""){
       	 $("#Delbtn_pic").hide();
        }	                 
        if("${infoMap.signFileId}" == ""){
       	 $("#Delbtn_sign").hide();
        }
        
        
        var zipCd = "${infoMap.zipCode}";
	   	 var deptZipCd = "${infoMap.deptZipCode}";

	   	 
	   	 if(zipCd.indexOf('-') == -1){
	   		 $("#home_zipcode1").val(zipCd.substring(0,3));
	       	 $("#home_zipcode2").val(zipCd.substring(3));
	   	 }
	   	 else{
	   		 var arrZip = zipCd.split("-");
	       	 $("#home_zipcode1").val(arrZip[0]);
	       	 $("#home_zipcode2").val(arrZip[1]);
	   	 }
	   	 
	   	 
	   	 if(deptZipCd.indexOf('-') == -1){
	   		 $("#comp_zipcode1").val(deptZipCd.substring(0,3));
	       	 $("#comp_zipcode2").val(deptZipCd.substring(3));
	   	 }
	   	 else{
	   		 var arrDeptZip = deptZipCd.split("-");
	       	 $("#comp_zipcode1").val(arrDeptZip[0]);
	       	 $("#comp_zipcode2").val(arrDeptZip[1]);
	   	 }
	   	 
	   	$("#wedding_date").attr("readonly", true);
	   	$("#birthday_date").attr("readonly", true);
	   	
	   	if("${loginVO.licenseCheckYn}" == "2")
			$("#menuHistory").css("display","none");
	   	
	   	if("${saveFlag}" != ""){
	   		var puddActionBar = Pudd.puddSnackBar({
				type	: 'success'		// success, error, warning, info
			,	message : "<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>"
			,	duration : 1500
			});
	   	}
	});
	
	function fnEditBtn(){
		
		<c:if test="${userRestricted.password_def == 'Y'}">
		$("[sel_mode=view]").hide();
		$("[sel_mode=edit]").show();
		
		if(document.getElementById('picFileIdNew').value == ''){
			document.getElementById('img_picFileIdNew').src = '/gw/Images/bg/mypage_noimg.png';
			$("#picTxt").show();
			$("#Delbtn_pic").hide();
		} else {
			$("#picTxt").hide();
			$("#Delbtn_pic").show();
		}
		
		return;
		</c:if>
		
		// 객체로 전달하는 경우 - dialog content 영역의 자식으로 추가됨
		var divContent = document.getElementById( "dialogContent" );
		 
		Pudd.puddDialog({
			width : 500
		,	height : 100
		,	modal : true
		,	draggable : false
		,	resize : false
		,	body : {
					content : divContent
				,	contentCallback : function( contentDiv ) {
					$("#logonPw").val("");
					$("#logonPw").focus();
				}
			}
		 
		,	footer : {
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
					,	value : "<%=BizboxAMessage.getMessage("TX000019752","확인")%>"
					,	clickCallback : function( puddDlg ) {
						
							if($("#logonPw").val() == ""){
								$("#logonPw").val("");
								$("#logonPw").css("border-color","red");
								$("#dialogContentErrorMSg").html('<%=BizboxAMessage.getMessage("TX000012059","패스워드를 입력해 주십시오.")%>');
								return;
							} 
							
							var param = {};
							var ParamEncType ='<%=BizboxAProperties.getCustomProperty("BizboxA.Cust.LoginParamEncType")%>'
							param.userSe = "${loginVO.userSe}";
							param.groupSeq = "${loginVO.groupSeq}";
							param.compSeq = "${loginVO.compSeq}";
							param.deptSeq = "${loginVO.orgnztId}";
							param.empSeq = "${loginVO.uniqId}";
							param.type = "def";
							param.onlyCheck = "Y";
							switch(ParamEncType){
							case  'AES' :
								param.secuStrBase = securityEncUtil.securityEncrypt($("#logonPw").val(),0);
								break;
							default:
								param.secuStrBase = btoa(unescape(encodeURIComponent($("#logonPw").val())));
							    break;
							}
	
							$.ajax({
								type: "POST"
								, data: param
								, url: '<c:url value="/loginPwCheck.do" />'
								, success: function(result) {
									if(result.result > 0) {
										$("[sel_mode=view]").hide();
										$("[sel_mode=edit]").show();
										
										if(document.getElementById('picFileIdNew').value == ''){
											document.getElementById('img_picFileIdNew').src = '/gw/Images/bg/mypage_noimg.png';
											$("#picTxt").show();
											$("#Delbtn_pic").hide();
										} else {
											$("#picTxt").hide();
											$("#Delbtn_pic").show();
										}
										
										puddDlg.showDialog( false );
									} else {
										$("#logonPw").val("");
										$("#logonPw").css("border-color","red");
										$("#dialogContentErrorMSg").html('<%=BizboxAMessage.getMessage("TX000001812","패스워드가 일치하지 않습니다.")%>');
										return;									
										
									}
								}
								, error: function(result) {
									alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
								}
							});							
						}
					}
				,	{
						attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
					,	value : "<%=BizboxAMessage.getMessage("TX000002947","취소")%>"
					,	clickCallback : function( puddDlg ) {
							puddDlg.showDialog( false );
						}
					}
				]
			}
		});		
	}
	
	function fn_cancel(){
		$("#img_picFileIdNew").attr("src","${profilePath}/${infoMap.empSeq}_thum.jpg?<%=System.currentTimeMillis()%>");
		$("#picFileIdNew").val("${infoMap.picFileId}");
		
		$("#img_signFileIdNew").attr("src","/gw/cmm/file/fileDownloadProc.do?fileId=${infoMap.signFileId}&fileSn=0");
		
		$("#signFileIdNew").val("${infoMap.signFileId}");		
		
		var picFileImg = document.getElementById('img_picFileIdNew');
		var signFileImg = document.getElementById('img_signFileIdNew');
		
		if("${userRestricted.password_def}" == 'Y'){		
			if(document.getElementById('picFileIdNew').value == ''){
				document.getElementById('img_picFileIdNew').src = '/gw/Images/bg/mypage_noimg.png';
				$("#picTxt").show();
				$("#Delbtn_pic").hide();
			} else {
				$("#picTxt").hide();
				$("#Delbtn_pic").show();
			}
		}
		
		if(signFileImg != null && document.getElementById('signFileIdNew').value == ''){
			$("#signImgId").show();
			$("#Delbtn_sign").hide();
		} else {
			if(${loginVO.eaType == 'eap'}) {
				if(signType == "" || signType == "img") {
					$("#Delbtn_sign").show();
				} else {
					$("#Delbtn_sign").hide();	
				}
			} else {
				$("#Delbtn_sign").show();	
			}
			
		}
		
		
		if("${loginVO.eaType}" == 'eap') {
			fnSignImgInit();
		}

		
		$("[sel_mode=view]").show();
		$("[sel_mode=edit]").hide();
	}
	
	function onSuccess(e) {
		if (e.operation == "upload") {
			var fileId = e.response.fileId;
			var name = e.sender.name;
			$("#"+name).val(fileId);
			
			$("#img_"+name).attr("src","<c:url value='/cmm/file/fileDownloadProc.do' />?fileId="+fileId+"&fileSn=0");
			
			if(name == "picFileIdNew"){
				$("#Delbtn_pic").show();
				$("#picTxt").hide();
				$("#Delbtn_pic").show();
			}
			if(name == "signFileIdNew"){
				$("#Delbtn_sign").show();
				$("#Delbtn_sign").show();
			}
		}
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

                if(target.id == "btnCompZip"){
	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('compZipCode').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('comp_addr').value = fullAddr;
	
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById('comp_detailaddr').focus();
                }
                else{
                	// 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('zipCode').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('home_addr').value = fullAddr;
	
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById('home_detailaddr').focus();
                }
                	
            }
        }).open();

    }
	
	
	function profileImgUpload(value){
		
		if(value.files && value.files[0])
		{
			if(value.files[0].type.indexOf("image") > -1){
				
				var reader = new FileReader();

				reader.onload = function (e) {
					$('#img_picFileIdNew').attr('src', e.target.result);
				}
			
				reader.readAsDataURL(value.files[0]);
				
				$("#Delbtn_pic").show();
				$("#picTxt").hide();
				
			}else{
				
		    	var checkExtMsg = "<%=BizboxAMessage.getMessage("TX000010638","이미지 파일이 아닙니다 지원 형식({0})")%>";
		    	checkExtMsg = checkExtMsg.replace("{0}","jpg, jpeg, bmp, gif, png").replace("　","\n");				
				alert(checkExtMsg);
				fn_picImgDel();
				
			}
		}
	}
	
	
	function signImgUpload(value){
		
		if(value.files && value.files[0]) 
		{
			var reader = new FileReader();

			reader.onload = function (e) {
				$('#img_signFileIdNew').attr('src', e.target.result);
				$("#signImgId").hide();
			}
		
			reader.readAsDataURL(value.files[0]);
			
			$("#Delbtn_sign").show();
		}
	}
	
	function noImgSet(type){
		
		if(type == "sign") 
		{
			$("#Delbtn_sign").hide();
		}else{
			$("#Delbtn_pic").hide();
			$("#picTxt").show();			
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