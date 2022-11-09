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

<script type="text/javascript">
	$(document).ready(function() {
		var result = '${resultCode}';
		var imgArr = [];
		var type = "${type}";
		imgArr[0] = ${LOGO_01P1102xdpi};
		imgArr[1] = ${LOGO_02P1102xdpi};
		imgArr[2] = ${LOGO_01P1101hdpi};
		imgArr[3] = ${LOGO_02P1101hdpi};
		imgArr[4] = ${LOGO_01P1201hdpi};
		imgArr[5] = ${LOGO_02P1201hdpi};
		
		if (result == 'SUCCESS') {
			alert("<%=BizboxAMessage.getMessage("TX000010637","정상적으로 저장되었습니다")%>");
			
			setOrgImgArr('${fileList}', '${imgType}');				
 			window.close();			
		}
		else if(result != ""){
			alert("<%=BizboxAMessage.getMessage("TX000010637","정상적으로 저장되었습니다")%>");
			self.close();
		}
		
		
		//기본버튼
		$(".controll_btn button").kendoButton();
			
			for ( i = 1; i<= $(".file_chum_box").size(); i++ )
			{
			//이미지등록	
				$("#inp_files"+i).kendoUpload({
					multiple: false,
					localization: {
						select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
					},
					async: {
		                saveUrl: '<c:url value="/cmm/systemx/group/test.do"/>',
		                removeUrl: '<c:url value="/cmm/systemx/group/test.do"/>',
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
					data: {imgType:e.sender.name, orgSeq:'${orgSeq}', file_Id : e.files[0].fileId, target:'P', type:"${type}"},
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
	
	// Phone 이미지 배열 db 입력
    function setOrgImgArr(data, imgType) {
    	//data = Pxxdpi_p|1856;Pxxdpi_p|1856;Pxxdpi_p|1856
    	if (data != null && data != '') {
    		$.ajax({
				type:"post",
				url:_g_contextPath_+"/cmm/systemx/orgUploadImage.do",
				datatype:"json",
				async:false,
				data: {fileList:data, orgSeq:'${orgSeq}', imgType:imgType, type:"${type}"},
				success:function(data){
					
				},			
				error : function(e){	//error : function(xhr, status, error) {
					alert("error");	
				}
		});
    	}
    }
</script>

<div class="pop_wrap" style="width:638px;">
	<form id="form" name="form" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cmm/file/fileUploadProc.do">	
	<input type="hidden" id="orgSeq" name="orgSeq" value="${orgSeq}" />
	<input type="hidden" id="compSeq" name="compSeq" value="${compSeq }" />	
	<input type="hidden" id="imgType" name="imgType" value="${imgType}" />
	<input type="hidden" id="callback" name="callback" value="${callback}" />
	<input type="hidden" id="type" name="type" value="${type}" />
	<input type="hidden" id="pathSeq" name="pathSeq" value="900" /> 
	<input type="hidden" id="dataType" name="dataType" value="page" />
	<input type="hidden" id="isNewId" name="isNewId" value="true" />
	<input type="hidden" id="page" name="page" value="/cmm/systemx/groupPhLogoUploadPop.do" > 
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></h1>
		<a href="#n" class="clo"><img src="../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">	
		<p class="mb10"><%=BizboxAMessage.getMessage("TX000016451","※ 모바일 브라우저 별 지원 이미지 사이즈 입니다.")%></p>
		<div class="com_ta2 hover_no">
			<table>
				<colgroup>
					<col width="100"/>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th colspan="2"><%=BizboxAMessage.getMessage("TX000016212","사이즈")%></th>
					<th><%=BizboxAMessage.getMessage("TX000005188","파일첨부")%></th>
				</tr>
				<tr>
					<td rowspan="2">Android<br />(Phone)</td>
					<td class="le"><%=BizboxAMessage.getMessage("TX000016315","로그인 로고")%>&nbsp;<img id="btndown_inp_files1" style="display: none;cursor:pointer;" onclick="fnDown(this);" src="/gw/Images/btn/btn_download01.png" alt="" /> <br /> <span class="f11 text_gray">(362*58)</span></td>
					<td>
						<div class="file_chum_box">
							<input name="LOGO_01P1102xdpi" id="inp_files1" type="file"/>
						</div>			
					</td>
				</tr>
				<tr>
					<td class="le"><%=BizboxAMessage.getMessage("TX000016292","메인 상단 로고")%>&nbsp;<img id="btndown_inp_files2" style="display: none;cursor:pointer;" onclick="fnDown(this);" src="/gw/Images/btn/btn_download01.png" alt="" /> <br /> <span class="f11 text_gray">(236*38)</span></td>
					<td>
						<div class="file_chum_box">
							<input name="LOGO_02P1102xdpi" id="inp_files2" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td rowspan="2">iOS<br />(Phone)</td>
					<td class="le"><%=BizboxAMessage.getMessage("TX000016315","로그인 로고")%>&nbsp;<img id="btndown_inp_files3" style="display: none;cursor:pointer;" onclick="fnDown(this);" src="/gw/Images/btn/btn_download01.png" alt="" /> <br /> <span class="f11 text_gray">(318*52)</span></td>
					<td>
						<div class="file_chum_box">
							<input name="LOGO_01P1101hdpi" id="inp_files3" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td class="le"><%=BizboxAMessage.getMessage("TX000016292","메인 상단 로고")%>&nbsp;<img id="btndown_inp_files4" style="display: none;cursor:pointer;" onclick="fnDown(this);" src="/gw/Images/btn/btn_download01.png" alt="" /> <br /> <span class="f11 text_gray">(212*34)</span></td>
					<td>
						<div class="file_chum_box">
							<input name="LOGO_02P1101hdpi" id="inp_files4" type="file"/>
						</div>					
					</td>
				</tr>
				<tr>
					<td rowspan="2">iOS<br />(Pad)</td>
					<td class="le"><%=BizboxAMessage.getMessage("TX000016315","로그인 로고")%> &nbsp;<img id="btndown_inp_files5" style="display: none;cursor:pointer;" onclick="fnDown(this);" src="/gw/Images/btn/btn_download01.png" alt="" /><br /> <span class="f11 text_gray">(498*80)</span></td>
					<td>
						<div class="file_chum_box">
							<input name="LOGO_01P1201hdpi" id="inp_files5" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td class="le"><%=BizboxAMessage.getMessage("TX000016292","메인 상단 로고")%>&nbsp;<img id="btndown_inp_files6" style="display: none;cursor:pointer;" onclick="fnDown(this);" src="/gw/Images/btn/btn_download01.png" alt="" /> <br /> <span class="f11 text_gray">(274*44)</span></td>
					<td>
						<div class="file_chum_box">
							<input name="LOGO_02P1201hdpi" id="inp_files6" type="file"/>
						</div>						
					</td>
				</tr>
				
			
<!-- 				<tr> -->
<!-- 					<td class="not_fir le">186 X 61</td> -->
<!-- 					<td> -->
<!-- 						<div class="file_chum_box"> -->
<!-- 							<input name="P1102hdpi" id="inp_files7" type="file"/> -->
<!-- 						</div>						 -->
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td rowspan="2">IOS</td> -->
<!-- 					<td class="le">240 X 60</td> -->
<!-- 					<td> -->
<!-- 						<div class="file_chum_box"> -->
<!-- 							<input name="L1201ldpi" id="inp_files8" type="file"/> -->
<!-- 						</div>						 -->
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td class="not_fir le">149 X 39</td> -->
<!-- 					<td> -->
<!-- 						<div class="file_chum_box"> -->
<!-- 							<input name="P1101ldpi" id="inp_files9" type="file"/> -->
<!-- 						</div>						 -->
<!-- 					</td> -->
<!-- 				</tr> -->
			</table>
		
		</div>
	</div><!-- //pop_con -->

	<div class="pop_foot" style="position:initial;">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" id="okBtn"/>
			<input type="button" class="gray_btn" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
	</form>
</div><!-- //pop_wrap -->