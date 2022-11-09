<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	var clone;
	var empSignFileIdNew = "";

	$(document).ready(function() {
	    //첨부파일
	    empSignFileIdNew = opener.getSignFileId();
	    
	    
	    $(".file_input_button").on("click",function(){
	        $(this).next().click();
	    });
	
	    // 버튼보이기
	    $(".sign_sel .clear").hide();
	    
	    $(".sign_sel .sign_upload").mouseover(function(){
            $(".sign_sel .clear").show();
        }).mouseout(function(){
	      $(".sign_sel .clear").hide();
	    });
	
	     // 이미지 선택        
	    $('.sign_sel ul li').click(function(){
	    	if($(this).find('.ico_check').length > 0){
				$('.ico_check').detach();
			}else{
				var children = $(".sign_sel").find('li');		
				$.each(children, function(item,index){
					$('.ico_check').detach();			
				});
				$(this).append("<span class='ico_check'></span>");			
			}
	    }); 
	     
	    $("#saveBtn").click(function(){
	    	fnSave();
	    });
	    
		$("#cancelBtn").click(function(){
	    	window.close();
	    });
		
		// 사인이미지 셋팅 값
		fnInit();
		
		$("#signFileId_New1").change(function(){
		    clone = $(this).clone();
		});
		
		
		setImgSrc();
	});
	
	function setImgSrc(){
		$("#img_signFileIdNew").attr("src",opener.getImgSrc());
	}
	
	function fnInit() {
		var signTypeClass = "${signInfo.stamp}";

		$("#stampDeName").text("${signInfo.empName}");
		$("#stampName").text("${signInfo.empName}");
		$("#stamp2Name").text("${signInfo.empName}");
		$("#stamp3Name").text("${signInfo.empName}");
		$("#stamp4Name").text("${signInfo.empName}");
		
		$(".ico_check").remove();
		
		if(signTypeClass == "img") {
			$("#img_signFileIdNew").closest("div").append("<span class='ico_check'></span>");
			
		} else {
			$("." + signTypeClass).closest("li").append("<span class='ico_check'></span>");	
			$("#" + signTypeClass + "Name").text("${signInfo.empName}");
		}
		
	}
	
	/* 사인 이미지 저장 */
	var signType = "";
	function fnSave() {
		signType = $(".ico_check").closest("li").find("p").attr("class");
		
		if($(".ico_check").length == 0) {
			alert("<%=BizboxAMessage.getMessage("TX000015373","이미지를 선택하세요.")%>");
			return;
		}
		
		if(typeof signType == "undefined") {
			signType = "img";
			var src = $("#img_signFileIdNew").attr("src");
			var fileId = empSignFileIdNew;
			
			if(document.getElementById("signFileId_New1").files.length > 0) {
			
				var formData = new FormData();
 				var pic = $("#signFileId_New1")[0];
 			
 				formData.append("file", pic.files[0]);
 	 			formData.append("pathSeq", "900");	//이미지 폴더
 	 			formData.append("relativePath", ""); // 상대 경로
 					 
 	 			$.ajax({
 	                 url: _g_contextPath_ + "/cmm/file/fileUploadProc.do",
 	                 type: "post",
 	                 dataType: "json",
 	                 data: formData,
 	                 async:false,
 	                 // cache: false,
 	                 processData: false,
 	                 contentType: false,
 	                 success: function(data) {
 	                		$("#picFileIdNew").val(data.fileId);
 	                		fileId = data.fileId;								
 	                 },
 	                 error: function (result) { 
 	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
 			    			return false;
 			    		}
 	             });
 			
			}
 			
 			
			
 			opener.fnCallBackImg(signType, src, '', fileId);
			window.close();
		} else {
			opener.fnCallBack(signType); 
			window.close();
		}
	}
	
	function signImgUpload(value){
		if(value.files && value.files[0]) 
		{
			if(value.files[0].name.indexOf(".") > -1){
				var extName = value.files[0].name.substring(value.files[0].name.lastIndexOf(".")+1);
				if(("|jpeg|jpg|jpg|png|").indexOf("|" + extName.toLowerCase() + "|") < 0){
					alert("<%=BizboxAMessage.getMessage("TX000005878","이미지 형식의 파일을 선택하십시오.")%>\n[jpeg, jpg, png]");
					return;
				}
				
			}else{
				alert("<%=BizboxAMessage.getMessage("TX000005878","이미지 형식의 파일을 선택하십시오.")%>\n[jpeg, jpg, png]");
				return;
			}
			
			var reader = new FileReader();

			reader.onload = function (e) {
				$('#img_signFileIdNew').attr('src', e.target.result);
				$("#signImgId").hide();
			}
		
			reader.readAsDataURL(value.files[0]);
			
			$("#Delbtn_sign").show();
			$("#signTxt").hide();
		}
	}

	
	function noImgSet(type){
		
		if(type == "sign") 
		{
			$("#Delbtn_sign").hide();
			$("#signTxt").show();
		}else{
			$("#Delbtn_pic").hide();
			$("#picTxt").show();			
		}
	}	
</script>

<div class="pop_wrap" style="width:408px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016206","사진등록/변경")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

    <div class="pop_con">	
		<p class="lh18"><%=BizboxAMessage.getMessage("TX900000293","※  선택된 사인이미지가 결재 시 반영됩니다.")%> <br/>
       &nbsp;&nbsp;&nbsp; <%=BizboxAMessage.getMessage("TX900000294","별도 사인 이미지를 등록하시려면 사인등록 버튼을 선택해주세요.")%> </p>
		<div class="mt14 ml15 sign_sel">
			<ul>
                <li>
                    <span class='ico_check'></span>
                    <div class="cen">
                        <p class="stamp_de_div" style="height:80px;">
                        	<span id="stampDeName" class="stamp_de">이훈</span>
                        </p>
                    </div>
                </li>
                <li>
                    <div class="cen">
                        <p class="stamp">
                            <span id="stampName">이훈</span><span class="">인</span>
                        </p>
                    </div>
                </li>
                <li>
                    <div class="cen">
                        <p class="stamp2">
                            <span id="stamp2Name">해바라기</span><span class="">인</span>
                        </p>
                    </div>
                </li>
            </ul>
            <ul>
                <li>
                    <div class="cen">
                        <p class="stamp3">
                            <span id="stamp3Name">홍길동</span><span class="">인</span>
                        </p>
                    </div>
                </li>
                <li>
                    <div class="cen">
                        <p class="stamp4">
                            <span id="stamp4Name">ABCDEFG</span><span class="">인</span>
                        </p>
                    </div>
                </li>
               
                <li class="sign_upload">
                    <div class="cen">
	                    <c:if test="${infoMap.signFileId ne NULL}">
							<img id="img_signFileIdNew"	src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${infoMap.signFileId}&fileSn=0' />"	onerror="this.src='/gw/Images/bg/mypage_noimg.png'"	/>
						</c:if>
						
						<c:if test="${infoMap.signFileId eq NULL}">
							<img id="img_signFileIdNew"	src="<c:url value='/Images/bg/sign_noimg.png' />" alt="" />
						</c:if>
                    </div>
                    <div class="clear">
						<div class="file_input_div">
							<input type="button" value="<%=BizboxAMessage.getMessage("TX000021930","사인등록")%>" class="file_input_button" />
							<input type="file" id="signFileId_New1" class="hidden_file_add2" name="signFileIdNew1" onchange="signImgUpload(this);"/>
						</div>
					</div>
                </li>
            </ul>		
		</div>
	</div><!-- //pop_con -->

	<input type="hidden" id="empSeq" value="${infoMap.uniqId}"/>
	<input type="hidden" id="fileId" value=""/>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input id="saveBtn" type="button" value="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" />
			<input id="cancelBtn" type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000019660","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->