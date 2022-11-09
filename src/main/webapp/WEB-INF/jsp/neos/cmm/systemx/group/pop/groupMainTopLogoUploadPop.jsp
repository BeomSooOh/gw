<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>
<style type="text/css">  
	html {overflow:hidden;}  
</style>


<script>
	$(document).ready(function() {
		var result = '${resultCode}';
		var imgArr = [];
		imgArr[0] = ${mainTopImg};
		
		if (result == 'SUCCESS') {
			onSuccess();		
		}
		else if(result != ""){
			alert('${resultMessage}');
			self.close();
		}
		
		
		//이미지등록	
		for ( i = 1; i<= $(".file_chum_box").size(); i++ ){
			$("#inp_files"+i).kendoUpload({
				multiple: false,
				localization: {
					select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
				},
				async: {
	                saveUrl: '<c:url value="/cmm/systemx/group/test.do"/>',	//임시 save url
	                removeUrl: '<c:url value="/cmm/systemx/group/test.do"/>', //임시 remove url
	                autoUpload: false
	            },
	            select: onSelect,
				files: imgArr[i-1],
				remove: onRemove			
			});	
			
			if(imgArr[i-1].length > 0){
				$("#btndown_inp_files" + i).show();
				$("#btndown_inp_files" + i).attr("fileId", imgArr[i-1][0].fileId);
			}
		}
			
		$("#okBtn").on("click", ok);
		
		fnSetResize();
	});
	
	function fnDown(e){
		this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=" + $(e).attr("fileId");
	    return false;
	}
	
	
	//팝업 하단 크기 조절
	function fnSetResize() {
		
		try{		
			var isFirefox = typeof InstallTrigger !== 'undefined';
			var isIE = /*@cc_on!@*/false || !!document.documentMode;
			var isEdge = !isIE && !!window.StyleMedia;
			var isChrome = !!window.chrome && !!window.chrome.webstore;
			
			if(isFirefox){
				
			}if(isIE){
				$(".pop_foot").css("width", "100%");
				$(".pop_foot").css("position","static");
			}if(isEdge){
				
			}if(isChrome){
			}

			//window.resizeTo(strWidth, strHeight);	
		}catch(exception){
			console.log('window resizing cat not run dev mode.');
		}
	}
	
	
	function onSelect(e){
		
		window.setTimeout(function() {
	        $(".k-upload-selected").hide()
	    }, 1);
		
		var files = e.files;
	    var acceptedFiles = [".jpg", ".jpeg", ".bmp", ".gif", ".png"];
	    var isAcceptedImageFormat = ($.inArray(files[0].extension.toLowerCase(), acceptedFiles)) != -1;

	    if (!isAcceptedImageFormat) {
	       e.preventDefault();
	       alert("<%=BizboxAMessage.getMessage("TX000010638","이미지 파일이 아닙니다.　지원 형식(jpg, jpeg, bmp, gif, png)")%>".replace("　","\n"));
	    }
	}
	
	
	function onRemove(e){
		
		if(e.files[0].fileId != null){		
			if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
				$.ajax({
					type:"post",
					url:_g_contextPath_+"/cmm/systemx/orgDeleteImage.do",
					datatype:"json",
					async:false,
					data: {imgType:e.sender.name, orgSeq:'${orgSeq}', file_Id : e.files[0].fileId},
					success:function(data){					
						alert("<%=BizboxAMessage.getMessage("TX000009833","정상적으로 삭제되었습니다")%>");
						location.reload();
					},			
					error : function(e){	//error : function(xhr, status, error) {
						alert("error");	
					}
				});
			}
			else
				e.preventDefault();
		}	
		else{
		}
	}
		
		
	function ok() {
		
		if($(".k-upload-selected").length > 0){
			document.form.submit();
		}
		else{
			alert("<%=BizboxAMessage.getMessage("TX000010637","정상적으로 저장되었습니다")%>");
			self.close();
		}
	}
	
	
	function onSuccess(){
		var fileList = "${fileList}";
		var arrFileList = fileList.split(';');
		
		for(var i=0;i<arrFileList.length;i++){
			var fileInfo = arrFileList[i].split('|');
			var fileNm = fileInfo[0];
			var fileId = fileInfo[1];
			
			if (fileId != null && fileId != '') {
				

				$.ajax({
					type:"post",
					url:_g_contextPath_+"/cmm/systemx/orgUploadImage.do",
					datatype:"json",
					async:false,
					data: {imgType:fileNm,orgSeq:'${orgSeq}',fileId : fileId},
					success:function(data){					
					},			
					error : function(e){	//error : function(xhr, status, error) {
						alert("error1");	
					}
				});				
				
			}
		}
			
		alert("<%=BizboxAMessage.getMessage("TX000010637","정상적으로 저장되었습니다")%>");
		self.close();

	}
</script>





<div class="pop_wrap" style="width:598px;">
	<form id="form" name="form" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cmm/file/fileUploadProc.do">
	<input type="hidden" id="orgSeq" name="orgSeq" value="${orgSeq}" >
	<input type="hidden" id="compSeq" name="compSeq" value="${compSeq }">	
	<input type="hidden" id="imgType" name="imgType" value="${imgType}" >
	<input type="hidden" id="callback" name="callback" value="${callback}" >
	<input type="hidden" id="pathSeq" name="pathSeq" value="900" > 
	<input type="hidden" id="dataType" name="dataType" value="page" >
	<input type="hidden" id="isNewId" name="isNewId" value="true" >
	<input type="hidden" id="page" name="page" value="/cmm/systemx/groupMainTopLogoUploadPop.do" >	
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></h1>
		<a href="#n" class="clo"><img src="../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">	
		<p class="mb10"><%=BizboxAMessage.getMessage("TX000016452","※ 메인상단로고 등록")%></p>
		<div class="com_ta2 hover_no">
			<table>
				<colgroup>
					<col width="160"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000001071","위치")%></th>
					<th><%=BizboxAMessage.getMessage("TX000005188","파일첨부")%></th>
				</tr>
				<tr>
					<td class="le"><%=BizboxAMessage.getMessage("TX000016315","로그인 로고")%>&nbsp;<img id="btndown_inp_files1" style="display: none;cursor:pointer;" onclick="fnDown(this);" src="/gw/Images/btn/btn_download01.png" alt="" /> <br /> <span class="f11 text_gray">(140*38)</span> </td>
					<td>
						<div class="file_chum_box">
							<input name="IMG_COMP_LOGO" id="inp_files1" type="file"/>
						</div>			
					</td>
				</tr>
			</table>
		
		</div>
	</div><!-- //pop_con -->

	<div class="pop_foot" style="position:initial;">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" id="okBtn" name="okBtn"/>
			<input type="button" class="gray_btn" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>"/>
		</div>
	</div><!-- //pop_foot -->
	</form>
</div><!-- //pop_wrap -->