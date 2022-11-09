<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css?ver=20201021">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/mention.css?ver=20201021">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/mCustomScrollbar/jquery.mCustomScrollbar.css">

<c:if test="${params.heightResizeYn == 'Y'}">
<script type="text/javascript">

	window.onload = function(){
		if(frameElement != null){
			frameElement.height = document.body.scrollHeight;
		}		
	}

</script>
</c:if>

<body> 
	<div style="margin:0 auto;">
	<div class="mentionContainer type1">
		<div class="commentBox">
			<div class="commentView">
				<c:forEach var="items" items="${commentList}">
					<div name="commentDiv" class="commentDiv<c:if test="${items.depth != '1'}"> reply</c:if>">
						<c:if test="${items.useYn == 'N'}">
					    	<div class="userProfile">
						    	<div class="createDate">${items.createDate}</div>
					    	</div>
					    	<div class="userChat">
					    		<div class="chatBox">
					    			<div class="chatBox_in">
										
										<span class="chatMsg" style="color: darkgray;">삭제된 댓글입니다.</span>
									</div>
					    		</div>
					    	</div>						
						</c:if>
						<c:if test="${items.useYn != 'N'}">
					    	<div class="userProfile">
						    	<div class="userName">${items.empName}</div>
						    	<div class="createDate">${items.createDate}</div>
					    	</div>
					    	<div class="userChat">
					    		<div class="chatBox">
					    			<div class="chatBox_in">
										<div class="chatBox_lt"></div><div class="chatBox_rt"></div><div class="chatBox_lb"></div><div class="chatBox_rb"></div>
										<span class="chatMsg">${items.contents}</span>
										
										<c:if test="${items.fileList.size() > 0}">
											<span name="chatEtc" class="chatEtc" style="width: 100%;">
												<ul class="file_group">
													<c:forEach var="files" items="${items.fileList}">
														<li name="fl">
											        		<div class="fl">
											        			<img src="/gw/Images/mention/${files.iconName}.png" alt="" class="fl">
											        			<span style="margin:0 0 0 5px;padding:1px 0;">${files.originalFileName}.${files.fileExtsn}</span><span> (${files.fileSizeName})</span></a>
											        		</div>
											        	</li>												
													</c:forEach>
										        </ul>
											</span>
										</c:if>									
									</div>
					    		</div>
					    	</div>
				    	</c:if>
					</div>					
				</c:forEach>
			</div>
		</div>
	</div>
	</div>
</body>