<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="main.web.BizboxAMessage"%>
<%
	// 웹에디터에서 전달하는 이미지 경로(src)
	String imgSrc = (null == request.getParameter("imgSrc")) ? "" : request.getParameter("imgSrc");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Bizbox Alpha</title>
    
	<!--css-->
    <link rel="stylesheet" type="text/css" href="/gw/css/common.css?ver=20201021">
    <link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
	
    <!--js-->
    <script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/common.js"></script>
    
    <script src="/gw/js/dzBox_files/svg.min.js" type="text/javascript"></script>
	<script src="/gw/js/dzBox_files/dzbox.js" type="text/javascript"></script>
	<script src="/gw/js/dzBox_files/dzdisplay.js" type="text/javascript"></script>
	<script src="/gw/js/dzBox_files/dzutil.js" type="text/javascript"></script>
	<script src="/gw/js/dzBox_files/jquery-1.9.1.min.js" type="text/javascript"></script>
    <style>
    	#convert1 table{width:400px !important;}
    	#convert2 table{width:400px !important;}
    	#convert3 table{width:400px !important;}
    </style>
<script>
	var convertType = "web";
	var mobileImgUrl = "";	
	var convertExt = "";
	var startOption = 0;
	var selectIndex = 0;
	var failCnt = 0;
	var convertFlag = "0";	
	
	$(window).load(function() {	 

		  var strWidth;

		  var strHeight;

		  //innerWidth / innerHeight / outerWidth / outerHeight 지원 브라우저 

		  if ( window.innerWidth && window.innerHeight && window.outerWidth && window.outerHeight ) {

		    strWidth = $('#container').outerWidth() + (window.outerWidth - window.innerWidth);

		    strHeight = $('#container').outerHeight() + (window.outerHeight - window.innerHeight);

		  }

		  else {

		    var strDocumentWidth = $(document).outerWidth();

		    var strDocumentHeight = $(document).outerHeight();

		 

		    window.resizeTo ( strDocumentWidth, strDocumentHeight );

		 

		    var strMenuWidth = strDocumentWidth - $(window).width();

		    var strMenuHeight = strDocumentHeight - $(window).height();

		 

		    strWidth = $('#container').outerWidth() + strMenuWidth;

		    strHeight = $('#container').outerHeight() + strMenuHeight;

		  }

		 

		  //resize 

		  window.resizeTo( strWidth + 1, strHeight + 1);

		 

		});
	
	
	
	
	function convertImageToTable() {
		
		var fileValue = $("#dzBoxImgUploadBtn").val().split("\\");	
		var filePath = "";
		
		if($("#dzBoxImgUploadBtn").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX900000538","파일을 선택해주세요")%>");	
			$("#converting").attr("converting","false");						
			return false;
		}
		else{		
			for(var i=0;i<fileValue.length-1;i++){
				filePath += fileValue[i] + "/";
			}	
			var fileName = fileValue[fileValue.length-1];
		
			var tblParam = {};
			tblParam.filePath = filePath;
			tblParam.fileNm = fileName;
			
			
			if($("#dzBoxImgUploadBtn").val() != ""){
					var formData = new FormData();
					var pic = $("#dzBoxImgUploadBtn")[0];
					
					formData.append("file", pic.files[0]);
					formData.append("pathSeq", "900");	//이미지 폴더
					formData.append("relativePath", "/imgFormTest/"); // 상대 경로
					formData.append("empSeq", "");
					formData.append("imgConvertYn", "Y")
					$.ajax({
						url:'/gw/cmm/file/profileUploadProc.do',
		                type: "post",
		                dataType: "json",
		                data: formData,
		                // cache: false,
		                processData: false,
		                contentType: false,		                
		                success: function(data) {
		                	$("#picFileIdNew").val(data.fileId);
		               		tblParam.fileId = $("#picFileIdNew").val();		
		                	if(convertExt == "image"){              		
			               		convertImgToJson(tblParam);
		                	}else{
		                		convertDocToJson(tblParam);
		                	}
		                },
		                error: function (result) { 
				    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
				    			return false;
				    		}
		            });
			}		
		}
	}
	
	function convertImgToJson(tblParam){
		$.ajax({
	     	type:"post",
	 		url:'/gw/formBox.do',
	 		datatype:"text",
	 		data:tblParam,
	 		success: function (data) { 			
	 			
	 			document.frmData["hdnJsonData"].value = data.convertData1;
	 			document.frmData["hdnJsonData1"].value = data.convertData2;
	 			document.frmData["hdnJsonData2"].value = data.convertData3;
	 			document.getElementById("resultTable").innerHTML = "";
	 			document.getElementById("drawing").innerHTML = "";
	 			
	 			fnSetTagDisplay("2");
	 			fnSetResultTagDisplay("1");
	 			
	 			setTimeout("imageDisplay();", 500);
			},
			error: function (result) {
	 			alert("error");
	 		}
	 	});
	}
	
	
	function convertDocToJson(tblParam){
		$.ajax({
	     	type:"post",
	 		url:'/gw/formDocBox.do',
	 		datatype:"text",
	 		data:tblParam,	 		
	 		success: function (data) { 			
// 	 			alert(data.saveLocalPath);
				var img = new Image();
				
				img.onload = function(){
					convertDocImgToJson(data.saveLocalPath);
	 		    	var imgSrc = location.protocol + "//" + location.host + "/" + data.saveLocalPath.replace("/home/", "/").replace("NAS_File","") + "document_0001.jpg";
	 		    	$('#targetImg').attr('src', imgSrc);
		 			fnSetTagDisplay("2");
				}
				
				img.onerror = function (){
					fnSetTagDisplay("0");
					$("#convertFail").css("display", "block");
					fnSetResultTagDisplay("3");
					$("#converting").attr("converting","false");
				}
				
				img.src = location.protocol + "//" + location.host + "/" + data.saveLocalPath.replace("/home/", "/").replace("NAS_File","") + "document_0001.jpg";		
 		    	
			},
			error: function (result) {
	 			alert("error");
	 		}
	 	});
	}
	
	
	function fnInit(){
		mobileImgUrl = "";	
		convertExt = "";
		startOption = 0;
		selectIndex = 0;
		failCnt = 0;
		convertFlag = "0";	
		
		
		document.frmData["hdnImgSrc"].value = "";
		document.frmData["hdnJsonData"].value = "";
		document.frmData["hdnJsonData1"].value = "";
		document.frmData["hdnJsonData2"].value = "";
		document.frmData["jsonData1"].value = "";
		document.frmData["jsonData2"].value = "";
		document.frmData["jsonData3"].value = "";
		
		$("#resultTable").html("");
		
		$("#convert1").html("");
		$("#convert2").html("");
		$("#convert3").html("");
		
		$("#convertLi1").removeClass("on");
		$("#convertLi2").removeClass("on");
		$("#convertLi3").removeClass("on");
		
		$("#convertLi1").removeClass("error");
		$("#convertLi2").removeClass("error");
		$("#convertLi3").removeClass("error");
		
		fnSetTagDisplay("0");
		fnSetResultTagDisplay("0");
	}
	
	function convertDocImgToJson(path){
		var tblPara = {};				
		tblPara.saveLocalPath = path;
		$.ajax({
	     	type:"post",
	 		url:'/gw/formDocToJson.do',
	 		datatype:"text",
	 		data:tblPara,
	 		success: function (data) {
	 			if(data.convertData1 == null || data.convertData1 == "undefined"){
					data.convertData1 = "";
				}
				if(data.convertData2 == null || data.convertData2 == "undefined"){
					data.convertData2 = "";
				}
				if(data.convertData3 == null || data.convertData3 == "undefined"){
					data.convertData3 = "";
				}
				
				document.frmData["hdnJsonData"].value = data.convertData1;
	 			document.frmData["hdnJsonData1"].value = data.convertData2;
	 			document.frmData["hdnJsonData2"].value = data.convertData3;
	 			document.getElementById("resultTable").innerHTML = "";
	 			document.getElementById("drawing").innerHTML = "";
	 			
	 			fnSetTagDisplay("2");
	 			fnSetResultTagDisplay("1");
	 			
	 			setTimeout("imageDisplay();", 500);
			},
			error: function (result) {
	 			alert("error");
	 		}
	 	});
	}
	
	
	
	
	function imageDisplay() {
// 		dzDisplay.displayWidth = document.getElementById("viewArea").clientWidth;

		var viewAreaWidth = document.getElementById("viewArea").clientWidth;
		if( viewAreaWidth > 400 ) {

			var paddingLeft = ( viewAreaWidth - 400 ) / 2;

			$( "#drawing" ).css( "padding-left", paddingLeft );
			dzDisplay.displayWidth = 400;

		} else {

			dzDisplay.displayWidth = 400;
		}

		dzDisplay.show(document.frmData["hdnJsonData"].value, function(){	
			
			if( 0 == dzBox.tbSize.length ) {
				failCnt++;
				$("#convertLi" + (startOption+1)).addClass("error");
				if(failCnt == 3){
					$("#convertFail").css("display", "block");
					fnSetResultTagDisplay("3");
					$("#converting").attr("converting","false");
					return;
				}
			}
			
			$('#resultTable table').each(function(index) {

				$(this).css("margin-left", "auto");
				$(this).css("margin-right", "auto");
				
				fnSetResultTagDisplay("2");
				
				$("#convert" + (startOption + 1)).html($("#resultTable").html());
				$('li div br').first().remove();				
				$("#converting").attr("converting","false");
				
				var zoomSizeHeight = 58/document.getElementById("convert" + (startOption+1)).clientHeight;				
				var zoomSizeWidth = 62/document.getElementById("convert" + (startOption+1)).clientWidth;
				
				var zoomScrollHeight = 58/document.getElementById("convert" + (startOption+1)).scrollWidth;
				var zoomScrollWidth = 62/document.getElementById("convert" + (startOption+1)).scrollWidth;

				var zoomScrollSize = zoomScrollHeight < zoomScrollWidth ? zoomScrollHeight : zoomScrollWidth;
				var zoomSize = zoomSizeHeight < zoomSizeWidth ? zoomSizeHeight : zoomSizeWidth;

				
				if( 0 == index ) {

					$("#convert" + (startOption+1)).css("zoom",(zoomSize < zoomScrollSize ? zoomSize : zoomScrollSize));
				}
				
				dzBox.setDisplayWidth(null);
				
				dzBox.setApplyTableWidth("100%");
			
				var tableHTML = "";
				for(var i in dzBox.tbSize) {
			
					var dataInfo = dzBox.dataAnalysis(i, true);
			
					tableHTML += dzBox.getTableHTMLCode(dataInfo);
					tableHTML += "<p><br /></p>";
				}

				if(startOption == 0)
					document.frmData["jsonData1"].value = tableHTML;
				else if(startOption == 1)
					document.frmData["jsonData2"].value = tableHTML;
				else if(startOption == 2)
					document.frmData["jsonData3"].value = tableHTML;

				if(startOption == 2){
					startOption = 0;
					convertFlag = "1";
				}
			});

			if(startOption < 2){
				if(convertFlag == "0"){
					startOption++;
					document.frmData["hdnJsonData"].value = document.frmData["hdnJsonData" + startOption].value;				
					fnSetResultTagDisplay("1");
					document.getElementById("resultTable").innerHTML = "";
		 			document.getElementById("drawing").innerHTML = "";
					setTimeout("imageDisplay();", 500);
				}else{
					convertFlag = "0";
					setResultViewTable();
				}
			}
		});
	}
	
	
	function applyImageToTable() {
		var tableHTML = "";
		
		if(selectIndex == 1)
			tableHTML = document.frmData["jsonData1"].value;
		else if(selectIndex == 2)
			tableHTML = document.frmData["jsonData2"].value;
		else if(selectIndex == 3)
			tableHTML = document.frmData["jsonData3"].value;
	
		opener.dzeEnvConfig.fnAddHTMLContent(tableHTML, null, 0, 0);
		window.close();
	}
	</script>
	
	<script>
	$(document).ready(function() {
		
		$('.resultViewTable li').on("click",function(){
			$('.resultViewTable li').removeClass('on');
			$(this).addClass('on');
			
			
			$("#resultTable").html($(this).html());
			$("#resultTable").prepend("<br />");
			$("#resultTable").find('div').css("zoom", "");
			
			selectIndex = $(this).attr("selectIndex");
		});
	
		$("#imgMobileBox").click(function() {
			dzUtil.openWindowCommon("/gw/mobileImgListPopView.do", 800, 620, false, "popImgMobile");
		});
	
	
		var imgHTML = '<img src="" id="targetImg" style="max-width: 100%;max-height: 710px;"/>';
		document.getElementById("imgArea").innerHTML = imgHTML;

		// 웹에디터에서 전달된 이미지 src 경로가 있는 경우 확인
		var imgSrc = $("#hdnImgSrc").val();
		if( "" != imgSrc ) {
			$('#targetImg').attr('src', imgSrc);
			convertType = "url";
			
			fnSetTagDisplay("1")
			
			setTimeout("convertStart();", 500);	
		}
	});
	
	function setResultViewTable(){
		$("#resultTable").html($("#convert1").html());
		$("#resultTable").prepend("<br />");
		$("#resultTable").find('div').css("zoom", "");
		
		selectIndex = 1;
		
		$("#convertLi1").addClass("on");
	}
	
	
	function selectDzBoxImg(){
		$("#dzBoxImgUploadBtn").click();
	}
	
	function dzBoxImgChange(value){
		if(value.files && value.files[0]) 
		{
			fnInit();
			var fileNm = value.files[0].name;
			
			var fileType = fileNm.substring(fileNm.lastIndexOf('.')+1, fileNm.length);
			fileType = fileType.toLowerCase(); 
			
			if(fileType == 'jpg' || fileType == 'gif' || fileType == 'png' || fileType == 'jpeg' || fileType == 'bmp'){			
				var reader = new FileReader();
		
				reader.onload = function (e) {
					$('#targetImg').attr('src', e.target.result);
				}	
				reader.readAsDataURL(value.files[0]);
				convertType = "web";
				convertExt = "image";
				
				fnSetTagDisplay("1");
				
				setTimeout("convertStart();", 500);
				
			}else if(fileType == 'hwp' || fileType == 'hwpx' || fileType == 'doc' || fileType == 'docx' || fileType == 'ppt' || fileType == 'pptx' || fileType == 'xls' || fileType == 'xlsx'){
				convertType = "web";
				convertExt = "doc";
				
				fnSetTagDisplay("3");
				
				setTimeout("convertStart();", 500);
				
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000539","지원하지 않는 확장잡니다.")%>");
			}
		}
	}
	
	
	function convertStart(){
		if($("#converting").attr("converting") == "false") {
			$("#converting").attr("converting", "true");
		} else {
			if($("#converting").attr("converting") == "true") {
				alert("<%=BizboxAMessage.getMessage("TX900000534","진행 중입니다")%>");
				return;
			} else {
				$("#converting").attr("converting", "true");
			}
		}

		if(convertType == "web"){
			convertImageToTable();
		}else if(convertType == "mobile"){
			convertImageFromMobile();
		}else if(convertType == "url"){
			convertImageFromURL();
		}
	}
	
	
	function callbackMobileImg(imgUrl){
			fnInit();
			
			convertType = "mobile";
			mobileImgUrl = imgUrl;
			$('#targetImg').attr('src', imgUrl);			
			fnSetTagDisplay("1");			
			
			setTimeout("convertStart();", 500);	
	}
	
	
	function convertImageFromMobile(){
	
		var tblParam = {};
		tblParam.imgUrl = "/home/" + mobileImgUrl;
		$.ajax({
			type:"post",
			url:'/gw/ConvertImgFromMobile.do',
			datatype:"json",
			data: tblParam,
			success:function(data){		
				
				if(data.convertData1 == null || data.convertData1 == "undefined"){
					data.convertData1 = "";
				}
				if(data.convertData2 == null || data.convertData2 == "undefined"){
					data.convertData2 = "";
				}
				if(data.convertData3 == null || data.convertData3 == "undefined"){
					data.convertData3 = "";
				}
				
				document.frmData["hdnJsonData"].value = data.convertData1;
	 			document.frmData["hdnJsonData1"].value = data.convertData2;
	 			document.frmData["hdnJsonData2"].value = data.convertData3;
	 			document.getElementById("resultTable").innerHTML = "";
	 			document.getElementById("drawing").innerHTML = "";
	 			
	 			fnSetTagDisplay("2");
	 			fnSetResultTagDisplay("1");
	 			
	 			setTimeout("imageDisplay();", 500);		
			},			
			error : function(e){	//error : function(xhr, status, error) {
				alert("error");	
			}
		});
	}
	
	function convertImageFromURL(){
	
		var tblParam = {};
		tblParam.imgSrc = $("#hdnImgSrc").val();
		$.ajax({
			type:"post",
			url:'/gw/imgSrcToJson.do',
			datatype:"json",
			data: tblParam,
			success:function(data){
	
	 			
	 			document.frmData["hdnJsonData"].value = data.convertData1;
	 			document.frmData["hdnJsonData1"].value = data.convertData2;
	 			document.frmData["hdnJsonData2"].value = data.convertData3;
	 			document.getElementById("resultTable").innerHTML = "";
	 			document.getElementById("drawing").innerHTML = "";
	 			
	 			fnSetTagDisplay("2");
	 			fnSetResultTagDisplay("1");
	 			
	 			setTimeout("imageDisplay();", 500);
	 			
			},			
			error : function(e){	//error : function(xhr, status, error) {
				alert("error");	
			}
		});
	}
		

	function fnClose(){
		self.close();
	}
	
	
	function fnSetTagDisplay(mode){		
		//기본화면
		if(mode == "0"){
			$("#imgArea").css("display", "none");
			$("#targetImg").css("display", "none");
			$("#imgDesc").css("display", "block");
			$("#imgLoading").css("display", "none");
		}
		//이미지 업로딩
		else if(mode == "1"){
			$("#imgArea").css("display", "block");
			$("#targetImg").css("display", "");
			$("#imgDesc").css("display", "none");
			$("#imgLoading").css("display", "block");
		}
		//이미지 업로드 완료 및 문서 업로딩,컨버팅 완료
		else if(mode == "2"){
			$("#imgArea").css("display", "block");
			$("#targetImg").css("display", "");
			$("#imgDesc").css("display", "none");
			$("#imgLoading").css("display", "none");
		}
		//문서 업로딩 및 컨버팅
		else if(mode == "3"){
			$("#imgArea").css("display", "none");
			$("#targetImg").css("display", "none");
			$("#imgDesc").css("display", "none");
			$("#imgLoading").css("display", "block");
		}		
	}
	
	function fnSetResultTagDisplay(mode){
		//기본화면
		if(mode == "0"){
			$("#convertLoading").css("display", "none");
			$("#convertFail").css("display", "none");
			$("#convertDesc").css("display", "block");
			$("#drawing").css("display", "none");
			$("#resultTable").css("display", "none");
			$("#resultViewTable").css("display", "none");
			$("#convertFail").css("display", "none");
		}
		else if(mode == "1"){
			$("#convertLoading").css("display", "block");
			$("#convertFail").css("display", "none");
			$("#convertDesc").css("display", "none");
			$("#drawing").css("display", "block");
			$("#resultTable").css("display", "none");
			$("#resultViewTable").css("display", "block");
			$("#convertFail").css("display", "none");
		}
		else if(mode == "2"){
			$("#convertLoading").css("display", "none");
			$("#convertFail").css("display", "none");
			$("#convertDesc").css("display", "none");
			$("#drawing").css("display", "none");
			$("#resultTable").css("display", "block");
			$("#resultViewTable").css("display", "block");
			$("#convertFail").css("display", "none");
		}
		else if(mode == "3"){
			$("#convertLoading").css("display", "none");
			$("#convertFail").css("display", "none");
			$("#convertDesc").css("display", "none");
			$("#drawing").css("display", "none");
			$("#resultTable").css("display", "none");
			$("#resultViewTable").css("display", "none");
			$("#convertFail").css("display", "block");			
		}
	}
</script>

</head>

<body>
<div class="pop_wrap" style="width:1160px;" id="container">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900000541","양식추출")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con doc_converter">
		<div class="btn_top p0">
			<ul class="fl">
				<li>
					<!-- 내컴퓨터 이미지 선택 -->
					<a href="#n" id="imgWebBox" class="imgWebBox" onclick="selectDzBoxImg();"><span class="ico"></span><%=BizboxAMessage.getMessage("TX900000542","내컴퓨터 이미지 선택")%></a>
					<input type="file" id="dzBoxImgUploadBtn" style="display: none;" onchange="dzBoxImgChange(this);">
					<input type="hidden" id="picFileIdNew">
				</li>
				<li>
					<!-- 모바일 이미지 선택 -->
					<a href="#n" id="imgMobileBox" class="imgMobileBox"><span class="ico"></span><%=BizboxAMessage.getMessage("TX900000543","모바일 이미지 선택")%></a>
				</li>
			</ul>
			<ul class="fr">
				<!-- 적용 버튼 --> 				
				<a href="#n" id="btnApply" class="btnApply" onclick="applyImageToTable();"><span class="ico"></span><%=BizboxAMessage.getMessage("TX000006211","적용")%></a>
				<input id="converting" converting="false" style="display: none;"/>				
				<!-- 창닫기 버튼 -->
				<a href="#n" id="btnClose" class="btnClose" onclick="fnClose();"><span class="ico"></span><%=BizboxAMessage.getMessage("TX000019099","창닫기")%></a>
			</ul>
		</div>
		<div class="doc_converter_tit clear">
			<div class="fl" style="width:570px;"><h5><%=BizboxAMessage.getMessage("TX900000544","파일 이미지 미리보기")%></h5></div>
			<div class="fl ml20"><h5><%=BizboxAMessage.getMessage("TX900000541","양식추출")%></h5></div>
		</div>
		<table width="100%" height="720px;" cellspacing="0" cellpadding="0">
			<tbody>
				<tr>
					<!-- 미리보기박스 -->
					<td class="left_td">
						<div id="imgArea" style="width:570px; display: none; text-align: center; padding-top: 1px;"><img src="" id="targetImg" style="max-width: 100%;max-height: 700px; padding-top: 20px;"></div>
						
						<!-- 문서변환 안내 -->
						<div class="doc_converter_dis" style="display:block;" id="imgDesc">
							<div class="text01"><%=BizboxAMessage.getMessage("TX900000545","다양한 문서 및 이미지 양식 추출과<br />비즈박스 에코 이용하여 촬영한 문서 및 그린 문서의 양식 추출")%></div>
							<div class="text02"><%=BizboxAMessage.getMessage("TX900000546","양식에 작성되어 있는<span class='text_blue fwb'>표의 라인 및 좌표를 추출</span>하여<br />비즈박스 웹 에디터를 사용하는 <span class='fwb'>모든 곳에서 사용</span>할 수 있습니다.")%></div>
							<div class="textbox">
								<span class="fwb f13">※ <%=BizboxAMessage.getMessage("TX900000547","주의사항")%></span><br />								
								<%=BizboxAMessage.getMessage("TX900000548","·문서촬영 시 양식용지와 배경색을 다르게 하여 여백 15~16Pixel유지")%><br />
								<%=BizboxAMessage.getMessage("TX900000549","·파일 미리보기 내 문서양식 깨짐현상 발생 시 양식크기 수정 후 재추출")%><br />								
								<%=BizboxAMessage.getMessage("TX900000550","·암호화 문서, 배포용 문서 지원이 불가능한 파일 확장자는 추출이 불가")%><br />
								<%=BizboxAMessage.getMessage("TX900000551","·지원가능 파일확장자(HWP,DOC,DOCX,XLS,XLSX,PPT,PPTX)")%>
							</div>
						</div>
						
						<!-- 문서변환 로딩 -->
						<div class="doc_converter_loading" style="display:none; height:720px;" id="imgLoading">
							<div class="modal_ab"></div>
							<div class="line-top"></div><div class="line-left"></div><div class="line-bot"></div><div class="line-right"></div>
							<div class="load_spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>
							<div class="load_img_from"><div class="load_img_to"></div><div class="text"><%=BizboxAMessage.getMessage("TX900000552","문서를 이미지로 변환중입니다.")%></div></div>
						</div>
					</td>
					
					<!-- 여백 -->
					<td class="cen_td"></td>
					
					<!-- 양식추출박스 -->
					<td id="viewArea"class="right_td">
						<div id="drawingParent" style="">
							<div id="drawing" class="drawing" style="display:none;height: 580px;"></div>
						</div>
						<div id="resultTable" style="display: none; height: 570px; padding: 10px; width: 80%; margin-left:auto; margin-right:auto;"></div>
						<div id="resultViewTable" class="resultViewTable" style="display:none;">
							<ul>
								<li class="on" selectIndex="1" id="convertLi1" style="vertical-align:top;"><div id="convert1"></div></li>
								<li selectIndex="2" id="convertLi2" style="vertical-align:top;"><div id="convert2"></div></li>
								<li selectIndex="3" id="convertLi3" style="vertical-align:top;"><div id="convert3"></div></li>
							</ul>
						</div>					
						
						<!-- 문서추출 안내 -->
						<div class="doc_extraction_dis" style="display:block;" id="convertDesc">
							<div class="text01"><%=BizboxAMessage.getMessage("TX900000553","문서 및 이미지 첨부 시 첨부된 파일 내 표가 추출됩니다.<br /><span class='f12 fwn'>정확한 양식 추출을 위해 <span class='text_red fwb'>3가지 타입</span>의 양식을 추출합니다.</span>")%></div>
						</div>
						
						<!-- 문서인식불가 -->
						<div class="doc_notRecognized" style="display:none;" id="convertFail">
							<div class="text01"><%=BizboxAMessage.getMessage("TX900000554","첨부한 피일은 <span class='text_red'>인식이 불가</span>한 파일입니다.<br /><span class='f12 fwn'>하단의 주의사항을 읽어보시고 문서 및 이미지를 다시 첨부해주세요.</span>")%></div>
							<div class="textbox">
								<span class="fwb f13">※ <%=BizboxAMessage.getMessage("TX900000547","주의사항")%></span><br />
								<%=BizboxAMessage.getMessage("TX900000548","·문서촬영 시 양식용지와 배경색을 다르게 하여 여백 15~16Pixcel유지")%><br />
								<%=BizboxAMessage.getMessage("TX900000549","·파일 미리보기 내 문서양식 깨짐현상 발생 시 양식크기 수정 후 재추출")%><br />
								<%=BizboxAMessage.getMessage("TX900000550","·암호화 문서, 배포용 문서 지원이 불가능한 파일 확장자는 추출이 불가")%><br />
								<%=BizboxAMessage.getMessage("TX900000551","·지원가능 파일확장자(HWP,DOC,DOCX,XLS,XLSX,PPT,PPTX)")%><br />
							</div>
						</div>	
						
						<!-- 문서추출 로딩 -->
						<div class="doc_extraction_loading" style="display:none;" id="convertLoading">
							<div class="load_spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>
							<div class="load_img_wrap">
								<div class="load_img_from"></div>
								<div class="load_img_to"></div>
								<div class="text"><%=BizboxAMessage.getMessage("TX900000555","양식 추출 중입니다.")%></div>
							</div>
						</div>
					</td>
					<form name="frmData" method="post" action="" onsubmit="return false;" style="display: none;">
						<input type="hidden" id="hdnImgSrc" name="hdnImgSrc" value="<%=imgSrc%>" />
						<input type="hidden" name="hdnJsonData" value="" />
						<input type="hidden" name="hdnJsonData1" value="" />
						<input type="hidden" name="hdnJsonData2" value="" />
						
						<input type="hidden" name="jsonData1" value="" />
						<input type="hidden" name="jsonData2" value="" />
						<input type="hidden" name="jsonData3" value="" />
					</form>	
				</tr>
			</tbody>
		</table>
		
	</div><!-- //pop_con -->	
</div><!-- //pop_wrap -->
</body>
</html>