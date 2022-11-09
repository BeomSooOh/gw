<%@page import="org.springframework.web.servlet.ModelAndView"%>
<%@page import="egovframework.com.cmm.util.EgovUserDetailsHelper"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />
	
	<!-- 파비콘 -->
    <link rel="icon" href="<c:url value='/Images/ico/favicon.ico'/>" type="image/x-ico" />
    <link rel="shortcut icon" href="<c:url value='/Images/ico/favicon.ico'/>" type="image/x-ico" />

	<!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/layout.css' />">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/contents.css' />">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/mail.css' />">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css' />"> 
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
    
    <style>
	    .k-sprite {background-image: url("/gw/Images/ico/ico_tree_folder.png");}
		.rootfolder{background-position: 0 0; }
		.folder{background-position: 0 -16px; }
		.pdf{background-position: 0 -32px; }
		.html{background-position: 0 -48px; }
		.file{background-position: 0 -64px; }
	  	.sub_contents_border{overflow:hidden;}    	
	  	#treeview{padding:20px;}
	</style>
	
    <script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js' />"></script>

    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.core.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
	
    <!--js-->
    <script type="text/javascript" src="<c:url value='/js/Scripts/common.js' />"></script>
    
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.main.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/systemx/systemx.menu.js' />"></script>
    
    <!-- 메인 js -->
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script>
	
	<!-- 나모웹에디터 -->
	<script type="text/javascript" src="/crosseditor/js/namo_scripteditor.js"></script>
	
	<script id="treeview-template" type="text/kendo-ui-template">
	        #: item.text #
	</script>
	
    
	<script type="text/javascript">
		$(document).ready(function() {
			
				  
		});
		
		// 메인 페이지 이동 개선
		function mainMove(type, urlPath, seq) {
			menu.mainMove(type, urlPath, seq);
		}
		
	
	</script> 
	
	
     
</head>	 
    
<body> 
<div class="sub_contents_wrap" style="height:100%">
	
	<div class="sub_contents_border" style="height:100%">
		
		<div class="sub_left">
			<c:if test="${loginVO.userSe == 'MASTER'}">
			<div class="sb_btn_top">
				<div class="btn_top" style="">
					<div class="controll_btn" style="padding:0px;">						
						<input type="text"id="appendNodeText" class="" style="width:76px;"/>
						<button class="" id="appendComp"><img src="<c:url value='/Images/ico/ic_plus.png'/>" alt="" style="vertical-align: initial;"/><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
						<button class="" id="removeComp"><img src="<c:url value='/Images/ico/ic_minus.png'/>" alt=""  style="vertical-align: initial;"/><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
					</div>
				</div>
			</div>
			</c:if>
			
			<div class="comp_search">
        	<h2>Sample Page Main</h2>
			</div> 
			<div id="treeview"></div>
		</div>		
		<div class="comp_sub_con" id="comp_info" style="margin-left:-1px;height:100%">
			<iframe id="contents" style="width:100%;height:100%">
			
			</iframe>
		</div>
	</div>
</div>

<script type="text/javascript"> 
 
    $("#treeview").kendoTreeView({
				template: kendo.template($("#treeview-template").html()),
				dataSource: [
				    {
						text: "<%=BizboxAMessage.getMessage("TX000000693","파일")%>", expanded: true, spriteCssClass: "rootfolder", items: [
							{text: "<%=BizboxAMessage.getMessage("TX000017903","공통업로더")%>", expanded: false, spriteCssClass: "folder", urlPath:"duzonUploader.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000017902","공통다운로더")%>", expanded: false, spriteCssClass: "folder", urlPath:"duzonDownloader.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000013872","파일업로드")%>", expanded: false, spriteCssClass: "folder", urlPath:"fileUpload.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000013872","파일업로드")%>(auto false)", expanded: false, spriteCssClass: "folder", urlPath:"fileUploadAutoFalse.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000011049","파일압축다운")%>", expanded: false, spriteCssClass: "folder", urlPath:"fileDown.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000003519","엑셀업로드")%>", expanded: false, spriteCssClass: "folder", urlPath:"excelUpload.jsp"}
						]
					},
					{
						text: "<%=BizboxAMessage.getMessage("TX000001715","에디터")%>", expanded: true, spriteCssClass: "rootfolder", items: [
							{text: "<%=BizboxAMessage.getMessage("TX000011048","나모웹에디터")%>", expanded: false, spriteCssClass: "folder", urlPath:"crosseditor.jsp"}
						]
					},
					{
						text: "API", expanded: true, spriteCssClass: "rootfolder", items: [
							{text: "<%=BizboxAMessage.getMessage("TX000011047","edms 게시판")%>", expanded: false, spriteCssClass: "folder", urlPath:"edmsGetUserBoardList.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000011046","edms 문서")%>", expanded: false, spriteCssClass: "folder", urlPath:"edmsGetDoc.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000011045","PC메신저 링크 관련")%>", expanded: false, spriteCssClass: "folder", urlPath:"msgLink.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000011044","edms 조직도 동기화")%>", expanded: false, spriteCssClass: "folder", urlPath:"edmsOrgSync.jsp"},
							{text: "관리자키 발급/등록", expanded: false, spriteCssClass: "folder", urlPath:"createLicenseKey.jsp"}
						]
					},
					{
						text: "<%=BizboxAMessage.getMessage("TX000011043","팝업")%>", expanded: true, spriteCssClass: "rootfolder", items: [
							/* {text: "조직도사용자선택팝업", expanded: false, spriteCssClass: "folder", urlPath:"userSelect.jsp"}, */
							/* {text: "조직도회사부서선택팝업", expanded: false, spriteCssClass: "folder", urlPath:"compDeptSelect.jsp"}, */
							{text: "<%=BizboxAMessage.getMessage("TX000011042","IE 팝업 종류")%>", expanded: false, spriteCssClass: "folder", urlPath:"popup.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000017914","조직도개인/부서팝업")%>", expanded: false, spriteCssClass: "folder", urlPath:"cmmOcType1.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000017915","조직도개인/부서/직책/직급팝업")%>", expanded: false, spriteCssClass: "folder", urlPath:"cmmOcType2.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000011041","조직도이메일")%>", expanded: false, spriteCssClass: "folder", urlPath:"cmmOcType3.jsp"},
							{text: "<%=BizboxAMessage.getMessage("TX000011040","주소록팩스")%>", expanded: false, spriteCssClass: "folder", urlPath:"cmmOcType4.jsp"}
						]
					},
					{
						text: "<%=BizboxAMessage.getMessage("TX000011039","사이트확인")%>", expanded: true, spriteCssClass: "rootfolder", items: [
							{text: "gwa.duzon.com", expanded: false, spriteCssClass: "folder", urlPath:"siteValid.jsp"},
								{text: "mgwa.duzon.com", expanded: false, spriteCssClass: "folder", urlPath:"siteValid2.jsp"}
						]
					}
			],
			select:onSelect
			});
            
     function onSelect(e) {
        var dataItem = this.dataItem(e.node);
		$("#contents").attr("src",dataItem.urlPath);
	  }   
           
   
</script>


<%=request.getHeader("User-Agent")%>
    
</body>

</html>
