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
		
		function req() {
    		var head=$("#head").val();
    		var body=$("#body").val();
    		var uriStr = $("#uriStr").val();
    		$.ajax({
    			type:"POST",
    			url:"/gw/gwApiTest.do",
    			datatype:"text",
    			data: {head:head, body:body, uri:uriStr},
    			success:function(d){
    				$("#result").val(d);
    			},			 
    			error : function(e){	//error : function(xhr, status, error) {
    				alert("error");	
    			}
    		});	   
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
		<div class="comp_sub_con" id="comp_info" style="margin-left:-1px;height:100%; width: 100%">
		
			<form id="apiForm"> 
				<table style="height:100%; width: 100%">
					<colgroup>
						<col width="10%">
						<col width="40%">
						<col width="50%">
					</colgroup>
					<tr>
						<td style="text-align:center">uri</td>
						<td><input type="text" id="uriStr" name="uriStr" style="width:100%;" /></td>
						<td style="text-align:center">
							result
						</td>
					</tr>
					<tr>  
						<td style="text-align:center">head</td>
						<td><textarea type="text" id="head" name="head" style="width:100%; height:400px" ></textarea></td>
						<td rowspan="2">
							<textarea type="text" id="result" name="result" style="width:90%; height:800px" ></textarea>
						</td>
					</tr>
					<tr>
						<td style="text-align:center">body</td>
						<td><textarea type="text" id="body" name="body" style="width:100%; height:400px" ></textarea></td>
					</tr>
				
				</table>
			
				<!-- <p>
				uri : <input type="text" id="uri" name="uri" />
				</p>
				<p style="margin-top:10px">
				head : <textarea type="text" id="head" name="head" style="width:300px; height:300px" ></textarea>
				</p>
				<p style="margin-top:10px">
				body : <textarea type="text" id="body" name="body" style="width:300px; height:300px" ></textarea>
				</p> -->
			</form>
			<div style="text-align:center;margin-top:10px">
				<button type="button" onclick="req()" style="width:100px;height:20px"><%=BizboxAMessage.getMessage("TX000017308","요청")%></button>
			</div>
		</div>
		
		
		<!-- <div class="comp_sub_con" id="comp_info" style="margin-left:-1px;height:100%">333
			result : <textarea type="text" id="result" name="result" style="width:300px; height:300px" ></textarea>
		</div> -->
	</div>
</div>

<script type="text/javascript"> 
 	var address ="http://localhost:8080/gw";
    $("#treeview").kendoTreeView({
				template: kendo.template($("#treeview-template").html()),
				dataSource: [
				    {
						text: "loginWS", expanded: true, spriteCssClass: "folder", urlPath:address+"/restful/loginWS" 
					}
			], 
			select:onSelect
			});
            
     function onSelect(e) {
        var dataItem = this.dataItem(e.node);
		$("#uriStr").val(dataItem.urlPath);
	  }   
           
   
</script>
    
</body>

</html>
