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
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.84.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.min.js"></script>
   <script src="/gw/js/neos/NeosUtil.js"></script>
   
   
   <script type="text/javascript">
		$(document).ready(function() {
			pop_position();
			$(window).resize(function() { 
					pop_position();
			});
			

			if("${nickNameOptionValue}" == "1"){				
				$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID01.png");
			}else if("${nickNameOptionValue}" == "2"){				
				$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID02.png");
			}else if("${nickNameOptionValue}" == "3"){				
				$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID03.png");
			}else if("${nickNameOptionValue}" == "4"){				
				$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID04.png");
			}
			
			
			
			//라디오 선택에 따른 이미지 체인지
			Pudd( 'input[type="radio"][name="Rai00"]' ).on( "click", function( e ) {
				
				var val = Pudd( 'input[type="radio"][name="Rai00"][checked]' ).getPuddObject().val();
				
				$("#exIDbox").removeClass("animated05s fadeInRight").addClass("animated05s fadeOutLeft");
				
				//이미지 애니메이션 체인지
				setTimeout(function(){
					if(val == "1"){
						$("#exIDbox").removeClass("animated05s fadeOutLeft").addClass("animated05s fadeInRight");
						$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID01.png");
					}else if(val == "2"){
						$("#exIDbox").removeClass("animated05s fadeOutLeft").addClass("animated05s fadeInRight");
						$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID02.png");
					}else if(val == "3"){
						$("#exIDbox").removeClass("animated05s fadeOutLeft").addClass("animated05s fadeInRight");
						$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID03.png");
					}else if(val == "4"){
						$("#exIDbox").removeClass("animated05s fadeOutLeft").addClass("animated05s fadeInRight");
						$("#exIDbox img").attr("src","/gw/Images/temp/fax_exID04.png");
					}
				},200);
			});
			
		});

		
		function fnSave(){
			var param = {};			
			param.value = $(".radi:checked").val();
			$.ajax({
				type: "POST"
					, contentType: "application/json; charset=utf-8"
					, url : "<c:url value='/api/fax/web/master/saveFaxNickNameOption'/>"
					, data : JSON.stringify(param)
					, dataType : "json"
					, success : function(result) {						
						var puddDlgObj = window.parent.puddDlgObj;
						puddDlgObj.showDialog( false );
					}
			});
		}
		
		function fnClose(){
			var puddDlgObj = window.parent.puddDlgObj;
			puddDlgObj.showDialog( false );
		}
	</script>
	</head>
	
	
	
	<body class="">
		<div class="pop_wrap_dir" style="width:800px;">
			<div class="pop_head posi_re">
				<h1><%=BizboxAMessage.getMessage("TX900000432","별칭표시 설정")%></h1>
				<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
				<div class="posi_ab" style="top:8px;right:20px;">
					<input type="button" id="" class="puddSetup" style="" value="<%=BizboxAMessage.getMessage("TX000005666","저장")%>" onclick="fnSave();"/>
					<input type="button" id="" class="puddSetup" style="" value="<%=BizboxAMessage.getMessage("TX000002972","닫기")%>" onclick="fnClose();"/>
				</div>
			</div>
			
			<div class="pop_con" style="">
				<!-- 박스 -->
				<div class="twinbox">
					<table width="100%" style="min-height:0;table-layout:fixed">
						<colgroup>
							<col style="width:200px;" />
							<col />
						</colgroup>
						<tr>
							<td class="twinbox_td p0 ovh">										
								<div class="tb_borderB pl15 pr15 clear bg_lightgray">
									<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX900000431","별칭 등 표시 예시")%></p>
								</div>
								<!-- 옵션 미리보기 -->
								<div id="exIDbox">
									<img src="/gw/Images/temp/fax_exID01.png" />
									<!-- 
									<img src="../../../Images/temp/fax_exID02.png" />
									<img src="../../../Images/temp/fax_exID03.png" />
									<img src="../../../Images/temp/fax_exID04.png" />
									 -->
								</div>
							</td>
							
							<td class="twinbox_td p0">																			
								<div class="tb_borderB pl15 pr15 clear bg_lightgray">
									<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX900000430","별칭표시 상세 설정")%></p>
								</div>
								<!-- 설정 -->
								<div class="p15">
									<dl>
										<dt class="mb10"><input type="radio" name="Rai00" class="puddSetup radi" value="1" pudd-label="<%=BizboxAMessage.getMessage("TX000000074","팩스번호")%>" <c:if test="${nickNameOptionValue == '1'}">checked="checked"</c:if> /></dt>
										<dd class="f11 text_gray mb20">: <%=BizboxAMessage.getMessage("TX900000429","팩스번호 별 별칭이 등록되어 있어도, 사용자 화면에서는 별칭이 보이지 않습니다.")%></dd>
										<dt class="mb10"><input type="radio" name="Rai00" class="puddSetup radi" value="2" pudd-label="<%=BizboxAMessage.getMessage("TX900000428","팩스번호(별칭)")%>" <c:if test="${nickNameOptionValue == '2'}">checked="checked"</c:if> /></dt>
										<dd class="f11 text_gray mb20">: <%=BizboxAMessage.getMessage("TX900000427","등록된 별칭이 위와 같은 형식으로 표시됩니다. 입력하지 않은 경우는 팩스번호만 노출됩니다.")%></dd>
										<dt class="mb10"><input type="radio" name="Rai00" class="puddSetup radi" value="3" pudd-label="<%=BizboxAMessage.getMessage("TX900000426","별칭(팩스번호)")%>" <c:if test="${nickNameOptionValue == '3'}">checked="checked"</c:if> /></dt>
										<dd class="f11 text_gray mb20">: <%=BizboxAMessage.getMessage("TX900000425","등록된 별칭이 위와 같은 형식으로 표시됩니다. 입력하지 않은 경우는 팩스번호만 노출됩니다.")%></dd>
										<dt class="mb10"><input type="radio" name="Rai00" class="puddSetup radi" value="4" pudd-label="<%=BizboxAMessage.getMessage("TX000000402","별칭")%>" <c:if test="${nickNameOptionValue == '4'}">checked="checked"</c:if> /></dt>
										<dd class="f11 text_gray">: <%=BizboxAMessage.getMessage("TX900000424","등록된 별칭만 사용자 화면에서 표시됩니다. 다만 별칭을 입력하지 않은 경우는 팩스번호가 노출됩니다.")%></dd>
									</dl>
								</div>
								
								<!-- 안내문구 -->
								<div class="mt10 p15 borderT">
									<%=BizboxAMessage.getMessage("TX900000421","※ 설정된 표시방식은")%> <span class="text_red"><%=BizboxAMessage.getMessage("TX900000422","Web방식에서만 적용")%></span><%=BizboxAMessage.getMessage("TX900000423","되며, Mobile은 팩스번호로 표시됩니다.")%>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="modal"></div>
	</body>
</html>