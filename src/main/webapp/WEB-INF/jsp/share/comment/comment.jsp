<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<link rel="stylesheet" type="text/css" href="/gw/css/common.css?ver=20201021">
<link rel="stylesheet" type="text/css" href="/gw/css/mention.css?ver=20201021">

<c:if test="${params.pageType != 'inner'}">
<script type="text/javascript" src="/gw/js/jquery-1.9.1.min.js"></script>
</c:if>

<c:if test="${params.moduleGbnCode == 'oneffice'}">
<script type="text/javascript" src="/gw/oneffice/js/oneffice_comment_style.js?ver=20201021"></script>
</c:if>

<c:if test="${params.scriptAppend != null && params.scriptAppend != ''}">
<script type="text/javascript" src="${params.scriptAppend}?ver=20201021"></script>
</c:if>

<script type="text/javascript">

		var selectedEditorBox;
		var selectedComment;
		var UPLOAD_COMPLITE = false;
		var attachFile = [];
		var recvEmpList = [];
		
	    //첨부파일 용량, 갯수제한
	    var availCapac = "${groupPathInfo.availCapac}";
	    var totalCapac = "${groupPathInfo.totalCapac}";
	    var limitFileCount = "${groupPathInfo.limitFileCount}";
	    
	    //확장자제한 및 허용파일갯수
	    var allowExtention = "${allowExtention}";
	    var blockExtention = "${blockExtention}";	    
	    
		var companyInfo = {};
		companyInfo.groupSeq = "${loginVO.groupSeq}";
		companyInfo.compSeq = "${loginVO.compSeq}";
		companyInfo.bizSeq = "${loginVO.bizSeq}";
		companyInfo.deptSeq = "${loginVO.orgnztId}";
		companyInfo.empSeq = "${loginVO.uniqId}";
		companyInfo.emailAddr = "${loginVO.email}";
		companyInfo.emailDomain = "${loginVO.emailDomain}";		
		
		function searchCommentList(){
			
			<c:if test="${params.writeOnly == 'Y'}">
			sizeInitDelay();
			return;
			</c:if>			
			
			uploaderReset();
			
			<c:if test="${params.regYn != 'N'}">
			selectedEditorBox = $("[name=editorTop]");
			$("[name=editorTop] .textDiv").html("");
			$("[name=editorTop] [name=fileGroup]").html("");
			$("[name=editorTop]").attr("file_id","");
	        $("[name=editorTop]").find("[name=fileCnt]").html($("[name=editorTop]").find(".fileGroup li[file_type=old],[file_type=new]").length);
	        $("[name=editorTop]").show();
	        $("#guardDiv").height(0);
			</c:if>
			
			var reqData = {};
			var header = {};
			var tblParam = {};

			tblParam.companyInfo = companyInfo;
			tblParam.langCode = "${loginVO.langCode}";
			tblParam.moduleGbnCode = "${params.moduleGbnCode}";
			tblParam.moduleSeq = "${params.moduleSeq}";
			tblParam.commentType = "${params.commentType}";
			tblParam.commentSeq = "";
			
			tblParam.sort = "${params.sort}"; //정렬방식(D : 최신순, A : 등록순)
			tblParam.searchWay = "${params.searchWay}"; //조회방향(D : 하위, U : 상위)
			
			if(tblParam.sort == ""){
				tblParam.sort = "A";
			}
			
			if(tblParam.searchWay == ""){
				tblParam.searchWay = "D";
			}			
			
			tblParam.pageSize = 1000;
			
			reqData.header = header;
			reqData.body = tblParam;
			
			$.ajax({
	        	type: "post",
	    		url: '<c:url value="/api/SearchCommentList.do"/>',
	    		contentType: "application/json",
	    		data: JSON.stringify(reqData) ,
	    		async: false,
	    		success: function (data) {
	    			
	    			$(".commentView").addClass("replyIn").html("");
	    			
	    			if(data.result != null && data.result.commentList != null && data.result.commentList.length > 0){
	    				$.each(data.result.commentList, function( key, commentInfo ) {
	    					commentAppend(commentInfo);
	    				});
	    			}
	    			
	    			sizeInitDelay();
	    		} ,
			    error: function (data) {
					//오류
			    }
	    	});
		}
		
		function convertTextToHtmlMention(text){
			
			if(text.indexOf("|>@empseq=\"") > -1){
				
				var startIdx = text.indexOf("|>@empseq=\"");
				var endIdx = text.indexOf("\"@<|");
				
				
				var resultHtml = text.substr(0,startIdx);
				
				var userInfo = text.substr(startIdx + 11, endIdx-startIdx-11).split("\",name=\"");
				
				if(userInfo.length == 2){

					var model_mention = $("#editorBoxModel [name=mentionSpan]").clone();
					
					if(userInfo[0] == "${loginVO.uniqId}"){
						$(model_mention).addClass("myMention");
					}else{
						$(model_mention).addClass("opMention");
					}
					
					$(model_mention).attr("empseq",userInfo[0]);
					$(model_mention).attr("value",userInfo[1]);
					resultHtml = resultHtml + $(model_mention)[0].outerHTML;
				}
				
				resultHtml = resultHtml + text.substr(endIdx + 4);
				
				return convertTextToHtmlMention(resultHtml);
				
				
			}else{
				return text;
			}
		}
		
		function commentAppend(obj){
			var model = $("#editorBoxModel [name=commentDiv]").clone();

			$(model).attr("comment_seq",obj.commentSeq);
			$(model).attr("top_level_comment_seq",obj.topLevelCommentSeq);
			$(model).attr("parent_comment_seq",obj.parentCommentSeq == null ? "" : obj.parentCommentSeq);
			$(model).attr("depth",obj.depth);
			$(model).find(".createDate").html(obj.createDate);
			
			// 댓글 등록 사용자 팝업 호출 함수
			$(model).find("[name=toEmpProfile]").click(function(){
				openEmpProfileInfo(obj.compSeq, obj.deptSeq, obj.createSeq);
			})
			
			//대댓글
			if(obj.parentCommentSeq != null && obj.parentCommentSeq != ""){
				$(model).addClass("reply");
			}

			if(obj.useYn == "Y"){
				$(model).attr("comp_seq",obj.compSeq);
				$(model).attr("dept_seq",obj.deptSeq);
				$(model).attr("emp_seq",obj.createSeq);
				$(model).attr("emp_name",obj.empName);
				$(model).attr("file_id",obj.fileId == null ? "" : obj.fileId);
				$(model).find(".userName").html(obj.empName);
				
				var replaceContents = convertUserWriteTagToText(obj.contents);
				replaceContents = replaceAllPkg(replaceContents,"\n","</br>");
				
				//링크처리
				replaceContents = replaceURLWithHTMLLinks(replaceContents);
				
				$(model).find(".chatMsg").html(convertTextToHtmlMention(replaceContents));
				$(model).find(".userImg img").attr("src", "${profilePath}/" + obj.createSeq + "_thum.jpg");
				
				//버튼처리
				if("${params.adminAuthYn}" == "Y"){
					
				}else if(obj.createSeq != "${loginVO.uniqId}"){
					
					//관리자 처리
					if("${params.adminAuthYn}" == "D"){
						$(model).find("[name=liEdt]").remove();
					}else if("${params.adminAuthYn}" == "E"){
						$(model).find("[name=liDel]").remove();
					}else{
						$(model).find("[name=liEdt]").remove();
						$(model).find("[name=liDel]").remove();						
					}
					
				}
				
				//첨부파일 바인딩
				if(obj.fileList.length > 0){
					var model_file = $("#editorBoxModel [name=chatEtc]").clone();
					$(model_file).find(".file_group li").remove();
					
					//이미지 미리보기 바인딩
			        <c:if test="${params.imgPreYn != 'N'}">
					var imgFilter = /jpg|gif|jpeg|png/i;
	   				$.each(obj.fileList, function( key, fileInfo ) {
	   		           if (imgFilter.test(fileInfo.fileExtsn)) {  
	      					var model_file_li = $("#editorBoxModel [name=file_img]").clone();
	       					$(model_file_li).find("img").attr("src", "/gw/cmm/file/fileDownloadProc.do?fileId=" + fileInfo.fileId + "&fileSn=" + fileInfo.fileSn);
	       					$(model_file).find(".file_group").append(model_file_li);
	   		           }   			
	   				});
	   				</c:if>
					
					//첨부파일 리스트 바인딩
	   				$.each(obj.fileList, function( key, fileInfo ) {
	   					var model_file_li = $("#editorBoxModel [name=fl]").clone();
	   					
	   					$(model_file_li).attr("file_id",fileInfo.fileId);
	   					$(model_file_li).attr("file_sn",fileInfo.fileSn);
	   					$(model_file_li).attr("path_seq",fileInfo.pathSeq);
	   					$(model_file_li).attr("file_extsn",fileInfo.fileExtsn);
	   					$(model_file_li).attr("file_size",fileInfo.fileSize);
	   					$(model_file_li).attr("original_file_name",fileInfo.originalFileName + (fileInfo.fileExtsn == "" ? "" : "." + fileInfo.fileExtsn));
	   					$(model_file_li).find(".fl img").attr("src", getIconFile(fileInfo.fileExtsn));
	   					$(model_file_li).find(".fl a").html(fileInfo.originalFileName + (fileInfo.fileExtsn == "" ? "" : "." + fileInfo.fileExtsn) + "<span> (" + byteConvertor(fileInfo.fileSize) + ")</span>");
	   					$(model_file).find(".file_group").append(model_file_li);
	   				});
					
					$(model).find(".chatMsg").after(model_file);
				}				
			}else{
				$(model).find(".chatMsg").css("color","darkgray");
				$(model).find(".chatMsg").html("<%=BizboxAMessage.getMessage("TX900000581","삭제된 댓글입니다.")%>");
				$(model).find(".commentBtn").remove();
				$(model).find(".userImg").remove();				
			}
			
			$(".commentView").append(model);
			
		}
		
		function convertUserWriteTagToText(text) {
			
			text = replaceAllPkg(text, "<", "&lt;");
			text = replaceAllPkg(text, ">", "&gt;");
			
			// 멘션 처리
			text = replaceAllPkg(text, "@&lt;", "@<");
			text = replaceAllPkg(text, "|&gt;", "|>");
			
			return text;
			
		}
		
		function saveCommentWiteOnly(){
			selectedEditorBox = $("[editor_mode=top]"); 
			searchCommentRecvEmpList();
		}
		
		function saveCommentReulstAlert(result){
			<c:if test="${params.writeOnly == 'Y'}">
		    if(parent.CommentReulstAlert != null){
		    	parent.CommentReulstAlert(result);
		    }
		    
		    if (typeof CommentReulstAlert == 'function') { 
		    	CommentReulstAlert(result);
		    }		    
			</c:if>	
		}
		
		function saveComment(obj){
			
			selectedEditorBox = $(obj).parents("[editor_mode=edt],[editor_mode=rpy],[editor_mode=top]");
			
			if($(selectedEditorBox).find("[name=mentionSpan]").length == 0 && $(selectedEditorBox).find(".textDiv").text().trim() == "" && $(selectedEditorBox).find(".fileGroup li").length == 0){
				alert("<%=BizboxAMessage.getMessage("TX900000580","저장할 컨텐츠가 없습니다.")%>");
				return;
			}else{
				
				if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
					fnAttFileUpload();	
				}
			}
		}
		
		function insertCommonComment(){
			
			var reqData = {};
			var header = {};
			var tblParam = {};
			
			tblParam.companyInfo = companyInfo;
			
			tblParam.positionCode = "${loginVO.positionCode}";
			tblParam.dutyCode = "${loginVO.classCode}";
			tblParam.langCode = "${loginVO.langCode}";
			tblParam.moduleGbnCode = "${params.moduleGbnCode}";
			tblParam.highGbnCode = "${params.highGbnCode}";
			tblParam.middleGbnCode = "${params.middleGbnCode}";	
			tblParam.moduleSeq = "${params.moduleSeq}";
			tblParam.commentType = "${params.commentType}";
			tblParam.commentSeq = $(selectedEditorBox).attr("comment_seq");
			tblParam.topLevelCommentSeq = $(selectedEditorBox).attr("top_level_comment_seq");
			tblParam.parentCommentSeq = $(selectedEditorBox).attr("parent_comment_seq");
			tblParam.depth = parseInt($(selectedEditorBox).attr("depth"));
			tblParam.fileId = $(selectedEditorBox).attr("file_id");
			
			//이벤트정보 입력
			var eventInfo = {};
			eventInfo.alertYn = <c:choose><c:when test="${params.alertYn=='N'}">"N"</c:when><c:otherwise>"Y"</c:otherwise></c:choose>;//	string	알림 발송 유무("Y/N")
			eventInfo.pushYn = <c:choose><c:when test="${params.pushYn=='N'}">"N"</c:when><c:otherwise>"Y"</c:otherwise></c:choose>;//	string	푸시 발송 유무("Y/N")
			eventInfo.talkYn = <c:choose><c:when test="${params.talkYn=='N'}">"N"</c:when><c:otherwise>"Y"</c:otherwise></c:choose>;//	string	대화 발송 유무("Y/N")
			eventInfo.mailYn = <c:choose><c:when test="${params.mailYn=='N'}">"N"</c:when><c:otherwise>"Y"</c:otherwise></c:choose>;//	string	메일 발송 유무("Y/N")
			eventInfo.smsYn = <c:choose><c:when test="${params.smsYn=='N'}">"N"</c:when><c:otherwise>"Y"</c:otherwise></c:choose>;//	string	SMS 발송 유무("Y/N")
			eventInfo.portalYn = <c:choose><c:when test="${params.portalYn=='N'}">"N"</c:when><c:otherwise>"Y"</c:otherwise></c:choose>;//	string	알림 발송 유무("Y/N")
			eventInfo.timelineYn = "Y";//	string	타임라인 발송 유무("Y/N")
			eventInfo.recvEmpBulk = "";//	string	특정 수신 집합 코드
			
			if(tblParam.parentCommentSeq == null || tblParam.parentCommentSeq == ""){
				//일반댓글일 경우 전체 수신리스트 반영
				eventInfo.recvEmpList = recvEmpList;//	array	수신자 리스트	
			}else{
				
				eventInfo.recvEmpList = [];
				
				//대댓글일 경우 원댓글 작성자만 추가
				var parentCommentDiv = $("[name=commentDiv][comment_seq="+tblParam.parentCommentSeq+"]");
				
				if(parentCommentDiv.length > 0){
					var parentCommentUserInfo = {};
					parentCommentUserInfo.groupSeq = "${loginVO.groupSeq}";
					parentCommentUserInfo.compSeq = $(parentCommentDiv).attr("comp_seq");
					parentCommentUserInfo.deptSeq = $(parentCommentDiv).attr("dept_seq");
					parentCommentUserInfo.empSeq = $(parentCommentDiv).attr("emp_seq");
					parentCommentUserInfo.langCode = "kr";
					parentCommentUserInfo.pushYn = "Y";
					eventInfo.recvEmpList.push(parentCommentUserInfo);
				}
			}
			
			eventInfo.recvMentionEmpList = [];//	array	멘션 대상자 리스트
			eventInfo.url = "${params.url}";//	string	상세 조회 바로가기 url
			eventInfo.ignoreCntYn = "Y";//	카운트 갱신 생략여부("Y/N")
			
			var model_contents = $(selectedEditorBox).find(".textDiv").clone();
			
			//멘션처리
			if($(selectedEditorBox).find(".textDiv input.mentionSpan").length > 0){
				
				$.each($(model_contents).find("input.mentionSpan"), function( key, value ) {
					$(value).replaceWith("|>@empseq=\"" + $(value).attr("empseq") + "\",name=\"" + $(value).attr("value") + "\"@<|");
					
					//멘션수신리스트 세팅
					if($(value).attr("compseq") != ""){
						var recvMentionEmp = {};
						recvMentionEmp.groupSeq = "${loginVO.groupSeq}";
						recvMentionEmp.compSeq = $(value).attr("compseq");
						recvMentionEmp.deptSeq = $(value).attr("deptseq");
						recvMentionEmp.empSeq = $(value).attr("empseq");
						eventInfo.recvMentionEmpList.push(recvMentionEmp);
						
						//recvMentionEmp.langCode = "kr";
						//recvMentionEmp.pushYn = "Y";						
						//eventInfo.recvEmpList.push(recvMentionEmp);
					}else{
						var recvMentionEmp = {};
						recvMentionEmp.groupSeq = "${loginVO.groupSeq}";
						recvMentionEmp.compSeq = "";
						recvMentionEmp.deptSeq = "";
						recvMentionEmp.empSeq = $(value).attr("empseq");
						eventInfo.recvMentionEmpList.push(recvMentionEmp);
						
						//recvMentionEmp.langCode = "kr";
						//recvMentionEmp.pushYn = "Y";							
						//eventInfo.recvEmpList.push(recvMentionEmp);
					}
				});
			}
			
			$(model_contents).html(replaceAllPkg($(model_contents).html(), "\n", ""));
			$(model_contents).html(replaceAllPkg($(model_contents).html(), "<p><br></p>", "<br>"));
			
			$.each($(model_contents).find("div"), function( key, value ) {
				$(value).replaceWith("\n" + $(value).html());
			});
			
			$.each($(model_contents).find("p"), function( key, value ) {
				$(value).replaceWith("\n" + $(value).html());
			});
			
			$.each($(model_contents).find("br"), function( key, value ) {
				$(value).replaceWith("\n");
			});
			
			if($(model_contents).text().indexOf("\n") == 0){
				tblParam.contents = $(model_contents).text().substring(1);
			}else{
				tblParam.contents = $(model_contents).text();
			}
	
			tblParam.commentPassword = "";
			tblParam.empName = "";

			//이벤트 데이터 입력
			var eventData = {};
			
			//영리전자결재 
			if(tblParam.moduleGbnCode == "eap"){
				
				eventInfo.eventType = "EAPPROVAL";
				eventInfo.eventSubType = "EA105";
				
				eventData.title = "${params.title.replace("\"","&quot;")}";
				eventData.title = replaceAllPkg(eventData.title, "&quot;", "\"");
				eventData.title = decodeURIComponent(eventData.title);
				eventData.userSeq = "${params.userSeq}";//	string	기안자,결재자 empSeq
				eventData.menu_id = "${params.menu_id}";//	string	결재함 아이디
				eventData.migYn = "${params.migYn}";//	string	이전문서 여부
				eventData.doc_no = "${params.doc_no.replace("\"","&quot;")}";
				eventData.doc_no = replaceAllPkg(eventData.doc_no, "&quot;", "\"");
				eventData.doc_no = decodeURIComponent(eventData.doc_no);
				eventData.doc_id = tblParam.moduleSeq;
				eventData.rep_dt = "${params.rep_dt}";
				eventData.created_dt = "${params.created_dt}";
				eventData.doc_comment = tblParam.contents;
				eventData.comment_seq = tblParam.commentSeq;			
				
			} else{
				
				eventInfo.eventType = "${params.eventType}";
				eventInfo.eventSubType = "${params.eventSubType}";
				
				var eventDataParam = "${params.eventData.replace("\"","&quot;")}";
				eventDataParam = replaceAllPkg(eventDataParam, "&quot;", "\"");
				
				$.each(eventDataParam.split("▦"), function(index, value){
					
					var eventParamInfo = value.split("|");
					
					if(eventParamInfo.length > 1){
						
						var eventParamValue = eventParamInfo[1];
						
						/*
						if(eventParamValue == "{empSeq}"){
							
							eventParamValue = "${loginVO.uniqId}";
							
						}else if(eventParamValue == "{commentSeq}"){
							
							eventParamValue = tblParam.commentSeq;
							
						}else if(eventParamValue == "{contents}"){
							
							eventParamValue = tblParam.contents;
							
						}
						*/
						
						eval("eventData."+eventParamInfo[0] + " = eventParamValue");
						
					}
				});
			}
		
			eventInfo.data = eventData;//	object	모듈-항목별 추가 데이터
			tblParam.event = eventInfo;
			reqData.header = header;
			reqData.body = tblParam;
			
			$.ajax({
	        	type: "post",
	    		url: '<c:url value="/api/InsertComment.do"/>',
	    		contentType: "application/json",
	    		data: JSON.stringify(reqData) ,
	    		success: function (data) {
	    			if(data.resultCode == "0"){
	    				searchCommentList();
	    				saveCommentReulstAlert("success");
	    			}else{
	    				saveCommentReulstAlert("fail");
	    			}
	    		} ,
			    error: function (data) {
					//오류
			    	saveCommentReulstAlert("fail");
			    }
	    	});
		}
		
		//기존첨부파일 삭제
		function deleteOldFiles(){
			if($(selectedEditorBox).find("li[file_type=del]").length > 0){
				
				var tblParam = {};
				tblParam.fileSn = "";
				tblParam.fileId = $(selectedEditorBox).attr("file_id");
				
				$.each( $(selectedEditorBox).find("li[file_type=del]"), function( key, value ) {
					tblParam.fileSn += (key == 0 ? "" : ",") + $(value).attr("file_sn");
				});
				
				$.ajax({
		        	type: "post",
		    		url: '<c:url value="/updateAttachDetail.do"/>',
		    		datatype: "json",
		    		data: tblParam ,
		    		success: function (data) {
		    			if(data.result == "1"){
		    				searchCommentRecvEmpList();
		    			}else{
		    				alert("<%=BizboxAMessage.getMessage("TX900000572","첨부파일을 삭제할 권한이 없습니다.")%>");
		    			}
		    		} ,
				    error: function (data) {
				    	alert("<%=BizboxAMessage.getMessage("TX900000573","첨부파일을 삭제중 오류가 발생했습니다.")%>");
				    }
		    	});				
				
			}else{
				searchCommentRecvEmpList();	
			}
		}
		
		//신규첨부파일 체크 및 업로드
	    function fnAttFileUpload() {
	    	
	        if (attachFile.length == 0){
	        	deleteOldFiles();
	        }else{
	            var path = '<c:url value="/ajaxFileUploadProcComment.do" />';
	            var abort = false;
	            var formData = new FormData();
	            
	            for (var x = 0; x < attachFile.length; x++) {
	                formData.append("file" + x, attachFile[x]);
	            }
	            
	            formData.append("absolPath", "${params.absolPath}");
				formData.append("moduleGbnCode", "${params.moduleGbnCode}");
				formData.append("moduleSeq", "${params.moduleSeq}");
	            formData.append("fileId", $(selectedEditorBox).attr("file_id"));
	            
	            fnSetProgress();

	            var AJAX = $.ajax({
	                url: path,
	                type: 'POST',
	                xhr: function () {
	                    myXhr = $.ajaxSettings.xhr();

	                    if (myXhr.upload) {
	                        myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
	                        myXhr.abort;
	                    }
	                    return myXhr;
	                },
	                success: completeHandler = function (data) {
	                    fnRemoveProgress();
						UPLOAD_COMPLITE = true;
						$(selectedEditorBox).attr("file_id", data.fileId);
						deleteOldFiles();
	                },
	                error: errorHandler = function () {

	                    if (abort) {
	                        alert('<%=BizboxAMessage.getMessage("TX000002483","업로드를 취소하였습니다.")%>');
	                    } else {
	                        alert('<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>');
	                    }

	                    UPLOAD_COMPLITE = false;
	                    fnRemoveProgress();
	                },
	                data: formData,
	                cache: false,
	                contentType: false,
	                processData: false
	            });

	            parent.document.getElementById("UploadAbort").onclick = function () {
	                fnRemoveProgress();
	                abort = true;
	                AJAX.abort();
	            };
	        }	
	    }
		
	    function progressHandlingFunction(e) {
	        if (e.lengthComputable) {
	        	document.getElementById("uploadStat").innerHTML = parseInt((e.loaded / e.total) * 100);
	        	document.getElementById("uploadStatByte").innerHTML = parseInt((e.loaded/1000)) + "/" + parseInt((e.total/1000));
	        }
	    }
	    
	    function fnSetProgress() {
	        if (parent.document.getElementById("UploadProgress") != null) {
	        	parent.document.getElementById('UploadProgress').style.display = 'block';  
	        } else {
				var newDiv = document.createElement("div");        	
	        	
	            var progTag = "<div id='UploadProgress' style='position: absolute;width: 100%;background-color: red;height: 200%;z-index: 99999;top: 0;background: white;opacity: 0.8;'>";
	            progTag += "<div style='padding-top: 100px;'>";
	            progTag += "<div style='text-align: center;  width: 100%; height:122px;'>";
	            progTag += "<p style='font-size: 20px;  font-family:initial;'>" + '<%=BizboxAMessage.getMessage("TX000016116","첨부파일 업로드중")%>' + "</p>";
		        progTag += "<p style='padding: 20px;font-size: 30px;font-family:initial;'><span id='uploadStat'>0</span>  %</p>";
		        progTag += "<p style='font-size:15px;font-family:initial;'>( <span id='uploadStatByte'>0/0</span> ) KByte</p>";
		        progTag += "<p style='padding-top: 10px;'><input id='UploadAbort' style='font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#000000;color:#FFFFFF;padding:0 8px; height:30px; border-bottom:1px solid #909090;line-height:22px;' type='button' value='" + '<%=BizboxAMessage.getMessage("TX000002947","취소")%>' + "' /></p>";
	            progTag += "</div>";   
	            
	            newDiv.innerHTML  = progTag;
	            
	            parent.document.getElementsByTagName("body")[0].appendChild(newDiv);
	        }
	    }

	    function fnRemoveProgress() {
	    	parent.document.getElementById('UploadProgress').style.display = 'none';
	    }		
		
	    function handleFileSelect(evt) {
	    	
	        evt.stopPropagation();
	        evt.preventDefault();
	        
	        var files = evt.target.files;

	        var overlabCheck = true;
	        
	        for (var i = 0, f; f = files[i]; i++) {

	            if(limitFileCount != "" && limitFileCount != "0" && limitFileCount <= $(selectedEditorBox).find("[name=editorFile]").length){
	            	alert("<%=BizboxAMessage.getMessage("TX900000582","업로드 제한 파일 갯수를 초과하였습니다.\\n(설정 갯수 :")%>" + limitFileCount + "개)");
	            	overlabCheck = false;
	            	return;
	            }
	            
	            if(overlabCheck && availCapac != "" && availCapac != "0" && f.size > (availCapac*1048576)){
	            	alert("<%=BizboxAMessage.getMessage("TX900000577","업로드 개당 제한 용량을 초과하였습니다.\\n(설정용량:")%>" + availCapac +"MB)");
	            	overlabCheck = false;
	            	return;
	            }
	            
	            if(overlabCheck && totalCapac != "" && totalCapac != "0"){
	            	var totalCapacNow = f.size;
	            	
	        		$.each($(selectedEditorBox).find("[name=editorFile]"), function( key, value ) {
	        			if(!isNaN(parseInt($(value).attr("file_size")))){
	        				totalCapacNow += parseInt($(value).attr("file_size"));
	        			}
					});
	        		
	        		if(totalCapacNow > (totalCapac*1048576)){
	        			alert("<%=BizboxAMessage.getMessage("TX900000577","업로드 전체용량을 초과하였습니다.\\n(설정용량:")%>" + totalCapac +"MB)");
		            	overlabCheck = false;
		            	return;	        			
	        		}
	            }	            

	        	if(overlabCheck){
	        		
	        		var file_name = ConvertSystemSourcetoHtml(f.name);

	        		$.each($(selectedEditorBox).find("li[file_type=old],[file_type=new]"), function( key, value ) {
						
						if(file_name == $(value).attr("original_file_name")){
		                    alert("<%=BizboxAMessage.getMessage("TX000007512","같은파일이 이미 첨부되었습니다.")%>" + "\r\n[" + f.name + "]");
		                    overlabCheck = false;
		                    return;
						}
					});
	        	}
	        	
	            //업로드 제한 확장자 체크
	            if(overlabCheck){
	            	var extsn = getExtensionOfFilename(f.name);
	            	
	        		if(allowExtention != "" && ("|" + allowExtention + "|").indexOf("|" + extsn.substring(1) + "|") == -1){
	        			var alertPermit = "<%=BizboxAMessage.getMessage("","허용되지 않은 확장자입니다.\\n[허용확장자 : {0}]")%>";
	        			overlabCheck = false;
	        			alert(alertPermit.replace("{0}", allowExtention.replace(/\|/g, ", ")));
	        			return;
	        		}else if(blockExtention != "" && ("|" + blockExtention + "|").indexOf("|" + extsn.substring(1) + "|") > -1){
	        			var alertLimit = "<%=BizboxAMessage.getMessage("","제한된 확장자입니다.\\n[제한확장자 : {0}]")%>";
	        			overlabCheck = false;
	        			alert(alertLimit.replace("{0}", blockExtention.replace(/\|/g, ", ")));
	        			return;
	        		}else if(extsn == -1){
	        			overlabCheck = false;
	        			alert("<%=BizboxAMessage.getMessage("TX900000589","확장자가 없는 파일은 첨부할 수 없습니다.")%>");
	        			return;
	        		}
	            }
	        	
	        	if(overlabCheck){

	        		attachFile.push(f);

	                var fileEx = "";
	                var lastDot = f.name.lastIndexOf('.');
	                
	                if(lastDot > 0){
	                	fileEx = f.name.substr(lastDot + 1);
	                }
	                
	                var model_file = $("#editorBoxModel [name=editorFile]").clone();
	                $(model_file).attr("file_type", "new");
	                $(model_file).attr("original_file_name", ConvertSystemSourcetoHtml(f.name));
	                $(model_file).attr("file_size", f.size);
	                $(model_file).find("[name=icon]").attr("src", getIconFile(fileEx));
	                $(model_file).find(".fileTxt").html(ConvertSystemSourcetoHtml(f.name) + "<span> (" + byteConvertor(f.size) + ")</span>");
	                $(selectedEditorBox).find("[name=fileGroup]").append(model_file);
	                $(selectedEditorBox).find("[name=fileGroup]").show();
	        	}
	        }
	        
	      	$('#uploadFile').val("");
	        
	        //첨부파일 전체카운트 세팅
	        $(selectedEditorBox).find("[name=fileCnt]").html($(selectedEditorBox).find(".fileGroup li[file_type=old],[file_type=new]").length);
	        
			//에디터 사이즈 갱신
	        sizeInitDelay();
	    }
	    
	    function getIconFile(fileEx){
	       	
	           var file_name;

	           //확장자정규식
	           var expBmp = /bmp/i;
	           var expCsv = /csv/i;
	           var expGif = /gifx/i;
	           var expHwp = /hwp/i;
	           var expJpg = /jpg|jpeg/i;
	           var expPdf = /pdf/i;
	           var expPng = /png/i;
	           var expTif = /tif/i;
	           var expWord = /word/i;
	           var expXls = /xls|xlsx/i;
	           var expZip = /zip/i;

	           if (expBmp.test(fileEx)) {
	               file_name = "ico_bmp";
	           } else if (expCsv.test(fileEx)) {
	               file_name = "ico_csv";
	           } else if (expGif.test(fileEx)) {
	               file_name = "ico_gif";
	           } else if (expHwp.test(fileEx)) {
	               file_name = "ico_hwp";
	           } else if (expJpg.test(fileEx)) {
	               file_name = "ico_jpg";
	           } else if (expPdf.test(fileEx)) {
	               file_name = "ico_pdf";
	           } else if (expPng.test(fileEx)) {
	               file_name = "ico_png";
	           } else if (expTif.test(fileEx)) {
	               file_name = "ico_tif";
	           } else if (expWord.test(fileEx)) {
	               file_name = "ico_word";
	           } else if (expXls.test(fileEx)) {
	               file_name = "ico_xls";
	           } else if (expZip.test(fileEx)) {
	               file_name = "ico_zip";
	           } else {
	               file_name = "ico_etc";
	           }
	           
	           return "/gw/Images/mention/" + file_name + ".png";
	    }	    
	    
	    function delFile(target) { //파일삭제
	    		    	
	    	var targetObj = $(target).parents("[name=editorFile]");
	    	
	    	if($(targetObj).attr("file_type") == "new"){
	    		
		        var attachTemp = [];
	    		
				$.each( attachFile, function( key, value ) {
					if(ConvertSystemSourcetoHtml(value.name) != $(targetObj).attr("original_file_name")){
						attachTemp.push(value);
					}
				});
		        
		        attachFile = attachTemp;
		        $(targetObj).remove();
		        $('#uploadFile').val("");
		        
	    	}else{
	    		//기존파일 삭제
	    		$(targetObj).attr("file_type", "del").hide();
	    	}
	        
	        //첨부파일 전체카운트 세팅
	        $(selectedEditorBox).find("[name=fileCnt]").html($(selectedEditorBox).find(".fileGroup li[file_type=old],[file_type=new]").length);
	    }
	    
	    function ConvertSystemSourcetoHtml(str){
		   	 str = str.replace(/</g,"&lt;");
		   	 str = str.replace(/>/g,"&gt;");
		   	 str = str.replace(/\"/g,"&quot;");
		   	 str = str.replace(/\'/g,"&#39;");
		   	 str = str.replace(/\n/g,"<br />");
		   	 return str;
	  	}
	    
	    function byteConvertor(bytes) {
	    	bytes = parseInt(bytes);
	    	var s = ['Byte', 'KB', 'MB', 'GB', 'TB', 'PB'];
	    	var e = Math.floor(Math.log(bytes)/Math.log(1024));
	    	if(e == "-Infinity") return "0 "+s[0]; 
	    	else return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
	    }
	    
		$(document).ready(function() {
			
			<c:if test="${params.writeOnly != 'Y'}">
			//첨부파일 선택 이벤트
			document.getElementById('uploadFile').addEventListener('change', handleFileSelect, false);
			
			//타이틀 화살표 폴딩기능
			$(".commentTitle").on("click",function(){
				$(this).find("span").toggleClass('on');
				$(".commentView").toggle();
			});
			
			//첨부파일 접고펴기
			$(".fileModifyTit").on("click",function(){
				$(this).toggleClass("on");
				$(this).parent().parent().find(".fileGroup").toggle();
			});
			
			//첨부파일 파일찾기 액션(임시) :: 개발 적용 시 삭제
			$('#fileUpload').on("click",function() {
				selectedEditorBox = $(this).parents("[editor_mode=edt],[editor_mode=rpy],[editor_mode=top]");
			  	$('#uploadFile').click();
			});
			</c:if>
			
			mentionEventSet();
			
			searchCommentList();

			sizeInitDelay();
			
		});
		
		function mentionEventSet(){
			$(".textDiv").bind("click", function(event) {
				
				var textPosi = window.getSelection().getRangeAt(0).startOffset;
				var contentsLengthNow = window.getSelection().getRangeAt(0).startContainer.length;				
				
				if(window.getSelection().getRangeAt(0).startContainer.textContent.substr(textPosi-1,1) == "@"){
					<c:if test="${params.mentionYn != 'N'}">
					searchEmptyCnt = 0;
					$(".mentionListBox").attr("searchStartIdx", textPosi);
					$(".mentionListBox").attr("contentsLength", contentsLengthNow);					
					</c:if>					
				}else{
					removeMention();
				}				
			});
			
			$(".textDiv").bind("paste", function(e) {
				if(e.originalEvent.clipboardData == null){
					pasteHtmlAtCaret(ConvertSystemSourcetoHtml(window.clipboardData.getData("Text")));
				}else{
					pasteHtmlAtCaret(ConvertSystemSourcetoHtml(e.originalEvent.clipboardData.getData('Text')));
				}
				
				return false;
			});
			
			$(".textDiv").bind("keydown", function(event) {
				if($(".mentionListBox").css("display") != "none"){
					if(event.which == 38 || event.which == 40 || event.which == 13){
						  return false;
					  }					
				}else{

				}
			});
			
			$(".textDiv").bind("keyup", function(event) {
				
				if(event.which == 8 || event.which == 46){
					searchEmptyCnt = 0;
				}
					
				if($(".mentionListBox").css("display") != "none"){
					
					  if(event.which == 38){
						  //위쪽 방향키  
						  if($(".mentionListBox li.on").prev().length > 0){
							  var liTo = $(".mentionListBox li.on").prev();
							  $(".mentionListBox li.on").removeClass("on");
							  $(liTo).addClass("on");
							  $(liTo)[0].scrollIntoView(false);							  
						  }
						  
						  return false;
						  
					  }else if(event.which == 40){
						  //아래쪽 방향키
						  if($(".mentionListBox li.on").next().length > 0){
							  var liTo = $(".mentionListBox li.on").next();
							  $(".mentionListBox li.on").removeClass("on");
							  $(liTo).addClass("on");
							  $(liTo)[0].scrollIntoView(false);
						  }
						  
						  return false;
						  
					  }else if(event.which == 13){
						  //멘션 사용자 삽입
						  appendMention($(".mentionListBox li.on"));
						  return false;
						  
					  }else if(event.which == 27 || event.which == 37 || event.which == 39){
						  //좌우 방향키, ESC 입력 시 멘션리스트 숨김
						  removeMention();				  
						  return false;
					  }
				}
				
				var searchStartIdx = $(".mentionListBox").attr("searchStartIdx");
				var contentsLength = $(".mentionListBox").attr("contentsLength");
				var textPosi = window.getSelection().getRangeAt(0).startOffset;
				var contentsLengthNow = window.getSelection().getRangeAt(0).startContainer.length;
	
				if(searchStartIdx != ""){
					if(contentsLength < contentsLengthNow){
						if(searchEmptyCnt > 2){
							removeMention();						
						}else{
							$( ".mentionListBox" ).css("top",$(this).offset().top + 76).css("left",$(this).offset().left);
							textDivFocus = this;
							searchMentionList(window.getSelection().getRangeAt(0).startContainer.textContent.substr(searchStartIdx,contentsLengthNow - contentsLength));							
						}

					}else if(contentsLength > contentsLengthNow){
						//좌우 방향키, ESC 입력 시 멘션리스트 숨김
						removeMention();	  
					}else if(contentsLength = contentsLengthNow){
						searchEmptyCnt = 0;
						$( ".mentionListBox" ).hide();
						$(".mentionListBox").attr("searchStartIdx", textPosi);
						$(".mentionListBox").attr("contentsLength", contentsLengthNow);			  
					}
					
				}else if(window.getSelection().getRangeAt(0).startContainer.textContent.substr(textPosi -1,1) == "@"){
					<c:if test="${params.mentionYn != 'N'}">
					searchEmptyCnt = 0;
					$(".mentionListBox").attr("searchStartIdx", textPosi);
					$(".mentionListBox").attr("contentsLength", contentsLengthNow);					
					</c:if>
				}
				
			});			
		}

		var textDivFocus;
		var searchSeq = 0;
		var searchEmptyCnt = 0;
		
		function appendMention(obj){
			
			var model_mention = $("#editorBoxModel [name=mentionSpan]").clone();
			
			if($(obj).attr("empseq") == "${loginVO.uniqId}"){
				$(model_mention).addClass("myMention");
			}else{
				$(model_mention).addClass("opMention");
			}
			
			$(model_mention).attr("compseq",$(obj).attr("compseq"));
			$(model_mention).attr("deptseq",$(obj).attr("deptseq"));
			$(model_mention).attr("empseq",$(obj).attr("empseq"));
			$(model_mention).attr("value",$(obj).attr("empname"));
			
			removeMention();
			$(textDivFocus).focus();
			pasteHtmlAtCaret("<mention hidden='true'/>");
			removeSearchText();
			pasteHtmlAtCaret($(model_mention)[0].outerHTML);
			
			//가상화 브라우져 버그조치
			setTimeout(function(){ removeMention(); }, 100);
		}

		function replaceSelectionWithHtml(html) {
		    var range;
		    if (window.getSelection && window.getSelection().getRangeAt) {
		        range = window.getSelection().getRangeAt(0);
		        range.deleteContents();
		        var div = document.createElement("div");
		        div.innerHTML = html;
		        var frag = document.createDocumentFragment(), child;
		        while ( (child = div.firstChild) ) {
		            frag.appendChild(child);
		        }
		        range.insertNode(frag);
		    } else if (document.selection && document.selection.createRange) {
		        range = document.selection.createRange();
		        range.pasteHTML(html);
		    }
		}		
		
		function removeSearchText(){
			var textDivHtml = $(textDivFocus).html();
			var removeMentionIdx = textDivHtml.indexOf("<mention hidden=\"true\"></mention>");
			var atSignIdx = textDivHtml.substr(0,removeMentionIdx).lastIndexOf("@");
			$(textDivFocus).html(textDivHtml.substr(0,atSignIdx) + textDivHtml.substr(removeMentionIdx + 33));
			placeCaretAtEnd();
			//$(textDivFocus).focusEnd();
			setTimeout(function(){ placeCaretAtEnd(); }, 100);
		}
		
		function placeCaretAtEnd() {
			$(textDivFocus).focus();
		    if (typeof window.getSelection != "undefined"
		            && typeof document.createRange != "undefined") {
		        var range = document.createRange();
		        range.selectNodeContents(textDivFocus);
		        range.collapse(false);
		        var sel = window.getSelection();
		        sel.removeAllRanges();
		        sel.addRange(range);
		    } else if (typeof document.body.createTextRange != "undefined") {
		        var textRange = document.body.createTextRange();
		        textRange.moveToElementText(textDivFocus);
		        textRange.collapse(false);
		        textRange.select();
		    }
		}
		
		$.fn.focusEnd = function() {
		    $(this).focus();
		    var tmp = $('<span />').appendTo($(this)),
		        node = tmp.get(0),
		        range = null,
		        sel = null;

		    if (document.selection) {
		        range = document.body.createTextRange();
		        range.moveToElementText(node);
		        range.select();
		    } else if (window.getSelection) {
		        range = document.createRange();
		        range.selectNode(node);
		        sel = window.getSelection();
		        sel.removeAllRanges();
		        sel.addRange(range);
		    }
		    tmp.remove();
		    return this;
		}
		
		function pasteHtmlAtCaret(html) {
			
			var sel, range;
		    
		    if (window.getSelection) {
		        sel = window.getSelection();
		        if (sel.getRangeAt && sel.rangeCount) {
		            range = sel.getRangeAt(0);
		            range.deleteContents();
		            var el = document.createElement("div");
		            el.innerHTML = html;
		            var frag = document.createDocumentFragment(), node, lastNode;
		            while ( (node = el.firstChild) ) {
		                lastNode = frag.appendChild(node);
		            }
		            range.insertNode(frag);

		            if (lastNode) {
		                range = range.cloneRange();
		                range.setStartAfter(lastNode);
		                range.collapse(true);
		                sel.removeAllRanges();
		                sel.addRange(range);
		            }
		        }
		    } else if (document.selection && document.selection.type != "Control") {
		        document.selection.createRange().pasteHTML(html);
		    }
		}
		
		function removeMention(){
			searchEmptyCnt = 0;
			$( ".mentionListBox" ).hide();
			$(".mentionListBox").attr("searchStartIdx", "");
			$(".mentionListBox").attr("contentsLength", "");			
		}
		
		function searchMentionList(empName){
			
			if(empName.match(/[ㄱ-ㅎ|ㅏ-ㅣ]/)){
				return;
			}
			
			var tblParam = {};
			tblParam.compFilter = "${params.compFilterMen}";
			tblParam.deptFilter = "${params.deptFilterMen}";
			tblParam.empFilter = "${params.empFilterMen}";
			tblParam.empName = empName;
			
			searchSeq++;
			tblParam.searchSeq = searchSeq;
			
			$.ajax({
	        	type: "post",
	    		url: '<c:url value="/getMentionList.do"/>',
	    		datatype: "json",
	    		async: true,
	    		data: tblParam ,
	    		success: function (result) {
	    			
	    			//비동기 마지막 호출만 처리
	    			if(result.searchSeq == searchSeq){
		    			//멘션리스트 초기화
		    			$(".mentionListBox ul").html("");
		    			
		    			if(result.mentionList.length > 0){
		    				
		    				$.each( result.mentionList, function( key, value ) {
		    					$(".mentionListBox ul").append("<li onmouseup='removeMention();' onmousedown='appendMention(this);' compseq='" + value.compSeq + "' deptseq='" + value.deptSeq + "' empseq='" + value.empSeq + "' empname='" + value.empName + "' " + (key == 0 ? " class='on'" : "") + "><div class='mentionImg'><img " + (value.picFileYn == "Y" ? "onerror='this.src=\"/gw/Images/temp/pic_Noimg.png\"' src='${profilePath}/" + value.empSeq + "_thum.jpg'" : "src=\"/gw/Images/temp/pic_Noimg.png\"'") + " width='100%' /><span class='imgCover'></span></div><dl class='mentionInfo'><dt>" + value.dispEmpName + "</dt><dd>" + value.dispDeptName + "</dd></dl></li>");
		    				});	    				
		    				
		    				searchEmptyCnt = 0;
		    				$( ".mentionListBox" ).show();
		    			}else{
		    				searchEmptyCnt++;
		    				$( ".mentionListBox" ).hide();
		    			}	    				
	    			}
	    			
	    		} ,
			    error: function (result) {
			    	if(result.searchSeq == searchSeq){
			    		$( ".mentionListBox" ).hide();	
			    	}
			    }
	    	});			
		}
		
		function searchCommentRecvEmpList(){
			
			if(recvEmpList.length > 0){
				insertCommonComment();
				return;
			}
			
			var tblParam = {};
			tblParam.compFilter = "${params.compFilter}";
			tblParam.deptFilter = "${params.deptFilter}";
			tblParam.empFilter = "${params.empFilter}";
			
			$.ajax({
	        	type: "post",
	    		url: '<c:url value="/getCommentRecvEmpList.do"/>',
	    		datatype: "json",
	    		async: true,
	    		data: tblParam ,
	    		success: function (result) {
	    			if(result.recvEmpList != null && result.recvEmpList.length > 0){
	    				recvEmpList = result.recvEmpList;
	    			}
	    			
	    			insertCommonComment();
	    		} ,
			    error: function (result) {
			    	alert("<%=BizboxAMessage.getMessage("TX900000576","수신자 리스트 조회 시 오류가 발생했습니다.")%>");
			    	saveCommentReulstAlert("fail");
			    }
	    	});
		}
		
		//멘션 리사이즈
		$(window).resize(function () {
			sizeInit();
		});
		
		function sizeInitDelay(){
			setTimeout(function(){ sizeInit(); }, 200);	
		}		
		
		//멘션 요소에 필요한 사이즈를 제공하는 함수
		function sizeInit(){
			
			var viewSizeWidth = $(".mentionContainer").width();
			
			<c:if test="${params.writeOnly != 'Y'}">
			var correction = 180;
			var correctionFileName = 305;
			var correctionEditFileName = 60;
			var correctionImg = 245;
			var correctionTextDiv = 163;
			var correctionTextDivReply = 205;
			$(".chatMsg").width(viewSizeWidth-correction);//텍스트영역
			$(".chatEtc").width(viewSizeWidth-correction);//첨부영역
			
			$(".type1 .chatEtc").width(viewSizeWidth-correction + 140);//첨부영역
			$(".type1 .reply .chatEtc").width(viewSizeWidth-correction + 115);//첨부영역
			$(".type2 .chatEtc").width(viewSizeWidth-correction + 110);//첨부영역
			$(".type2 .reply .chatEtc").width(viewSizeWidth-correction + 75);//첨부영역
			
			$(".file_txt").width(viewSizeWidth-correctionFileName);//첨부파일 텍스트영역
			$(".textDiv").width(viewSizeWidth-correctionTextDiv);//작성영역
			$("[name=commentDiv].reply .textDiv").width(viewSizeWidth-correctionTextDivReply);//작성영역(대댓글보정)
			
			
			$(".cloneHiddenText").width(viewSizeWidth-correctionTextDiv);//작성복사영역
			$(".fileTxt").css("max-width",viewSizeWidth-correctionEditFileName);//작성영역 첨부파일 텍스트영역
			
			if((viewSizeWidth-correction) < 400){
				$(".file_img img").width(viewSizeWidth-correctionImg);//이미지 최대지원 사이즈보다 작을 경우 비율적으로 줄여주기
			};			
			</c:if>			
			
			<c:if test="${params.writeOnly == 'Y'}">
			$(".mentionContainer").css("height", "100%");
			$(".textDiv").width(viewSizeWidth-50);//작성영역
			$(".textDiv").height($(".mentionContainer").height()-45);//작성영역
			</c:if>
			
			//height abjust when iframe mode.
			if(frameElement != null && $(frameElement).attr("forceHeight") == null){
				frameElement.height = $(document).height();
			}
			
		};		
		
		function editorAppend(obj, mode){
			$(selectedComment).find(".commentBtn").show();
			$("[name=editorBoxClone]").remove();

			var model = $("#editorBoxModel [name=editorBox]").clone();
			$(model).attr("name", "editorBoxClone");
			$(model).addClass(mode);
			
			selectedComment = $(obj).parents(".commentDiv");
			
			if(mode=='editWrap'){
				//수정
				$(model).attr("editor_mode", "edt");
				$(model).attr("comment_seq", $(selectedComment).attr("comment_seq"));
				$(model).attr("top_level_comment_seq", $(selectedComment).attr("top_level_comment_seq"));
				$(model).attr("parent_comment_seq", $(selectedComment).attr("parent_comment_seq"));
				$(model).attr("depth", $(selectedComment).attr("depth"));
				$(model).attr("file_id", $(selectedComment).attr("file_id"));
				
				//기존 컨텐츠 처리
				$(model).find(".textDiv").html($(selectedComment).find(".chatMsg").html());
				
				//기존 첨부파일 처리
  				$.each($(selectedComment).find("li[name=fl]"), function( key, fileInfo ) {
  					
	                var model_file = $("#editorBoxModel [name=editorFile]").clone();
	                $(model_file).attr("file_type", "old");
	                var file_name = $(fileInfo).attr("original_file_name");
	                
	                $(model_file).attr("file_id",$(fileInfo).attr("file_id"));
	                $(model_file).attr("file_sn",$(fileInfo).attr("file_sn"));
	                $(model_file).attr("path_seq",$(fileInfo).attr("path_seq"));
	                $(model_file).attr("file_size",$(fileInfo).attr("file_size"));
	                $(model_file).attr("original_file_name",file_name);
	                
	                $(model_file).find("[name=icon]").attr("src", getIconFile($(fileInfo).attr("file_extsn")));
	                $(model_file).find(".fileTxt").html(ConvertSystemSourcetoHtml(file_name) + "<span> (" + byteConvertor($(fileInfo).attr("file_size")) + ")</span>");
	                
	                $(model).find("[name=fileGroup]").append(model_file);
	                $(model).find("[name=fileGroup]").show();
  					
  				});
				
  				$(model).find("[name=fileCnt]").html($(selectedComment).find("li[name=fl]").length);
				
				$(selectedComment).append(model);
				selectedEditorBox = model;
				
				//가드Div 높이값 세팅
				$("#guardDiv").height($("[name=editorTop]").height());
				
			}else{
				//대댓글
				$(model).attr("editor_mode", "rpy");
				$(model).attr("comment_seq", "");
				
				if($(selectedComment).attr("top_level_comment_seq") == ""){
					$(model).attr("top_level_comment_seq", $(selectedComment).attr("comment_seq"));
				}else{
					$(model).attr("top_level_comment_seq", $(selectedComment).attr("top_level_comment_seq"));
				}
				
				$(model).attr("parent_comment_seq", $(selectedComment).attr("comment_seq"));
				$(model).attr("depth", parseInt($(selectedComment).attr("depth")) + 1);
				$(model).attr("file_id", "");
				
				//기본멘션 추가
				var model_mention = $("#editorBoxModel [name=mentionSpan]").clone();
				
				if($(selectedComment).attr("emp_seq") == "${loginVO.uniqId}"){
					$(model_mention).addClass("myMention");
				}else{
					$(model_mention).addClass("opMention");
				}				
				
				$(model_mention).attr("compseq",$(selectedComment).attr("comp_seq"));
				$(model_mention).attr("deptseq",$(selectedComment).attr("dept_seq"));
				$(model_mention).attr("empseq",$(selectedComment).attr("emp_seq"));
				
				$(model_mention).attr("value",$(selectedComment).attr("emp_name"));
				$(model).find(".textDiv").html($(model_mention)[0].outerHTML);
				
				$(selectedComment).after(model);
				selectedEditorBox = model;
				
			}
			
			mentionEventSet();
			$(obj).parents(".commentBtn").hide();
			$("[name=editorTop]").hide();
			
			//에디터 사이즈 갱신
			sizeInitDelay();
			
		}
		
		function editorRemove(obj){
			$(selectedComment).find(".commentBtn").show();
			$(obj).parents("[name=editorBoxClone]").remove();
			$("[name=editorTop]").show();
			$("#guardDiv").height(0);
			selectedEditorBox = $("[name=editorTop]");
			uploaderReset();
		}
		
		function uploaderReset(){
			attachFile = [];
			$('#uploadFile').val("");			
		}
		
		function fileDownload(obj, type){
			
			if(type == "def"){
				type = $($(obj).parents("li").find(".fr a")[0]).attr("name");
				if(type == "file_save"){
					type = "direct";
				}else if(type == "file_viewer"){
					type = "viewer";
				}
			}
			
			if(type == "direct"){
				if("${activxYn}" == 'Y'){
					var fileUrl = window.location.protocol + "//" + location.host + "/gw/cmm/file/fileDownloadProc.do?fileId=" + $(obj).parents("li").attr("file_id") + "&fileSn=" + $(obj).parents("li").attr("file_sn");
					goForm(fileUrl, "${loginVO.id}", $(obj).parents("li").attr("original_file_name"));
				}else{
					this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=" + $(obj).parents("li").attr("file_id") + "&fileSn=" + $(obj).parents("li").attr("file_sn");	
				}
			}else if(type == "viewer"){
    			var checkExtsn = "|hwp|doc|docx|ppt|pptx|xls|xlsx|";
    			<c:choose>
    			<c:when test="${inlineViewYn == 'N'}">
    			var checkExtsnInline = "";
    			</c:when>
    			<c:otherwise>
    			var checkExtsnInline = "|jpeg|bmp|gif|jpg|png|pdf|";
    			</c:otherwise>
    			</c:choose>    			
    			if(checkExtsnInline.indexOf("|" + $(obj).parents("li").attr("file_extsn").toLowerCase() + "|") != -1){
    				var timestamp = new Date().getTime();
    			 	var docViewrPopForm = document.docViewrPopForm;
    			 	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=yes,menubar=no");
    			 	docViewrPopForm.action = "/gw/cmm/file/fileDownloadProc.do";
    			 	docViewrPopForm.target = "docViewerPop" + timestamp ;
    			 	docViewrPopForm.pathSeq.value = "";
    			 	docViewrPopForm.fileId.value = $(obj).parents("li").attr("file_id");
    			 	docViewrPopForm.fileSn.value = $(obj).parents("li").attr("file_sn");
    			 	docViewrPopForm.moduleTp.value = "gw";
    			 	docViewrPopForm.submit();				
    			}else if(checkExtsn.indexOf("|" + $(obj).parents("li").attr("file_extsn").toLowerCase() + "|") != -1){
    				var timestamp = new Date().getTime();
    			 	var docViewrPopForm = document.docViewrPopForm;
    			 	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
    			 	docViewrPopForm.action = "/gw/docViewerPop.do";
    			 	docViewrPopForm.target = "docViewerPop" + timestamp ;
    			 	docViewrPopForm.groupSeq.value = "${loginVO.groupSeq}";
    			 	docViewrPopForm.fileId.value = $(obj).parents("li").attr("file_id");
    			 	docViewrPopForm.fileSn.value = $(obj).parents("li").attr("file_sn");
    			 	docViewrPopForm.moduleTp.value = "gw";
    			 	docViewrPopForm.submit();    				
    			}else{
    				<c:choose>
    				<c:when test="${inlineViewYn == 'N'}">
    				alert("해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자 : hwp, doc, docx, ppt, pptx, xls, xlsx]");
    				</c:when>
    				<c:otherwise>
    				alert("<%=BizboxAMessage.getMessage("TX900000575","해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자 : 이미지, pdf, hwp, doc, docx, ppt, pptx, xls, xlsx]")%>");
    				</c:otherwise>
    				</c:choose>    				
    				return;
    			}				
			}
		}
		
	    var PimonAXObj;
		
	    function goForm(url, loginId, fileNm){
	    	
	    	if(loginId == null || loginId == ""){
	    		alert("<%=BizboxAMessage.getMessage("TX000017930","파일 다운로드 권한이 없습니다.")%>");
	    	}else{
	    		try{
	    			if(PimonAXObj == null)
	    			PimonAXObj = PimonAX.ElevatePimonX();
	    			
	    			PimonAXObj.FileDownLoad(url, loginId, fileNm, '${pageContext.session.id}'); // 다운로드파일경로, UserID	
	    		}catch(e){
	    			if(e.number != -2147023673)
	    			alert("<%=BizboxAMessage.getMessage("TX000017931","파일 다운로드는 IE브라우져에서만 가능합니다.")%>");	
	    		}
	    	}
		}
		
		function deleteComment(obj){
			if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){

				var reqData = {};
				var header = {};
				var tblParam = {};

				tblParam.companyInfo = companyInfo;
				tblParam.langCode = "${loginVO.langCode}";
				tblParam.commentSeq = $(obj).parents(".commentDiv").attr("comment_seq");
				tblParam.topLevelCommentSeq = $(obj).parents(".commentDiv").attr("top_level_comment_seq");
				
				reqData.header = header;
				reqData.body = tblParam;
				
				$.ajax({
		        	type: "post",
		    		url: '<c:url value="/api/DeleteComment.do"/>',
		    		contentType: "application/json",
		    		data: JSON.stringify(reqData) ,
		    		success: function (data) {
		    			if(data.resultCode == "0"){
		    				//$(obj).parents(".commentDiv").remove();
		    				searchCommentList();
		    			}else if(data.resultCode == "-1"){
		    				alert(data.resultMessage);
		    			}
		    		} ,
				    error: function (data) {
						//오류
				    }
		    	});				
			}
		}
		
		function replaceURLWithHTMLLinks(text) {
		    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i;
		    return text.replace(exp,"<a style='color: blue;cursor: pointer;text-decoration: underline;' href='javascript:fnContentsLinkPop(\"$1\")'>$1</a>"); 
		}
		
		function fnContentsLinkPop(linkUrl){
			
			var pop = window.open(linkUrl, "_blank");

			try {pop.focus(); } catch(e){
				console.log(e);//오류 상황 대응 부재
			}
			return pop;			
			
		}
		
		function replaceAllPkg(str, searchStr, replaceStr) {
			
			if(str == null){
				return "";
			}
			
		    return str.split(searchStr).join(replaceStr);
		    
		}
		
		function getExtensionOfFilename(filename) { 
			var _fileLen = filename.length; 
			var _lastDot = filename.lastIndexOf('.'); 
			// 확장자 명만 추출한 후 소문자로 변경
			var _fileExt = filename.substring(_lastDot, _fileLen).toLowerCase(); 
			
			// 확장자 없는 파일 업로드 제한
			if(_lastDot == -1){
				return -1;
			}
			
			return _fileExt; 
		} 		
		
		// 댓글 등록 사용자 정보 팝업
		function openEmpProfileInfo (comp_seq, dept_seq, emp_seq) {

			if (comp_seq == null && dept_seq == null) {
				alert("외부계정은 프로필 상세팝업을 제공하지 않습니다.");
				return;
			}								
			
			var paramUrl = "?compSeq=" + comp_seq + "&deptSeq=" + dept_seq + "&empSeq=" + emp_seq ;
	
			var url = '/gw/empProfileInfo.do' + paramUrl;
			
			var winHeight = document.body.clientHeight;	// 현재창의 높이
			var winWidth = document.body.clientWidth;	// 현재창의 너비
			var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
			var winY = window.screenY || window.screenTop || 0;	// 현재창의 y좌표
			
			var popWidth = 520;
			var popHeight = 241;
			
			var popX = winX + (winWidth - popWidth)/2;
			var popY = winY + (winHeight - popHeight)/2;
			
			window.open(url, "사용자프로필", "width="+popWidth+",height="+popHeight+",scrollbars=0,top="+popY+ ",left="+popX);
			
		}
			
	</script>	
</head>

<body> 
	<div style="margin:0 auto;">
	<!-- UI Start -------------------------------------------------------------------------------------------------->
	<div class="mentionContainer ${params.styleTp}">
		<!-- comment box -->
		<div class="commentBox">
			<!-- editor Box -->
			<div <c:if test="${params.regYn == 'N'}">style="display:none;"</c:if> name="editorTop" editor_mode="top" comment_seq="" top_level_comment_seq="" parent_comment_seq="" depth="1"  parent_comment_seq="" file_id="" class="editorBox">
				<!-- 작성영역 -->
				<div class="editTextBox">
					<div class="textDiv" id="textDiv" contenteditable="true" tabindex="0" style="-webkit-ime-mode:active; -moz-ime-mode:active; -ms-ime-mode:active; ime-mode:active;"></div>
					<textarea class="cloneHiddenText hidden"></textarea>
					
					<c:if test="${params.writeOnly != 'Y'}">
					<div class="textBtn">
						<a onclick="saveComment(this);" href="javascript:void(0)" class="submitBtn"><%=BizboxAMessage.getMessage("TX000001256","저장")%></a>
					</div>
					</c:if>
				</div>
				
				<!-- 첨부파일영역 -->
				<c:if test="${params.writeOnly != 'Y'}">
				<div class="editFileBox" <c:if test="${params.attachYn == 'N'}">style="display:none;"</c:if>>
					<!-- file title -->
					<div class="fileTitle">
						<span class="fileModifyTit"><%=BizboxAMessage.getMessage("TX000005188","파일첨부")%></span>
						<div class="fileModifyInfo">
							<span><%=BizboxAMessage.getMessage("TX000008712","파일 갯수")%></span>
							<span name="fileCnt" class="fwb text_blue">0</span><%=BizboxAMessage.getMessage("TX000001633","개")%>
						</div>
						<div class="fileUploadBtn">
							<a href="#n" onclick="$('#uploadFile').click();" class=""><%=BizboxAMessage.getMessage("TX000007481","파일찾기")%></a>
							<input id="uploadFile" name="uploadFile" multiple="multiple" type="file" class="hidden">
						</div>
					</div>
					<ul name="fileGroup" class="fileGroup"></ul>
				</div>
				</c:if>
			</div>
			
			<!-- comment view :: replyIn은 댓글생성시 붙여줍니다. 처음엔 없는 클래스임. -->
			<div class="commentView"></div>
			
			<!-- 가드Div -->
			<div id="guardDiv"></div>
			
		</div>
	</div>
	<!-- UI End -------------------------------------------------------------------------------------------------->	
	</div>
	
	<!-- 멘션목록 -->
	<div class="mentionListBox" style="z-index:9999;" searchStartIdx="" contentsLength="" >
		<ul></ul>
	</div>			
	
	<!-- Model -->
	<div  id="editorBoxModel" style="display:none;">
	
		<!-- 댓글 -->
		<div name="commentDiv" class="commentDiv" >
	    	<div class="userProfile">
	    	
				<c:if test="${params.styleTp != 'type1'}">
			    	<div class="userImg" style= "cursor: pointer;" name="toEmpProfile">
			    		<img src="/gw/Images/temp/pic_Noimg.png" onerror="this.src='/gw/Images/temp/pic_Noimg.png'" width="36px" />
			    		<span class="imgCover"></span>
			    	</div>	    		 
		    	</c:if>
			    <div class="userName" style= "cursor: pointer;" name="toEmpProfile"></div>
		    	<div class="createDate"></div>
		    	<div class="commentBtn">
		    		<ul>
						<c:if test="${params.rpyYn != 'N'}">		    		
		    			<li name="liRpy"><a onclick="editorAppend(this,'editorBox');" href="javascript:void(0)" class="ico_rpy" title="<%=BizboxAMessage.getMessage("TX000003728","댓글")%>"></a></li>
		    			</c:if>		    		
						<c:if test="${params.modYn != 'N'}">
		    			<li name="liEdt"><a onclick="editorAppend(this,'editWrap');" href="javascript:void(0)" class="ico_edt" title="<%=BizboxAMessage.getMessage("TX000005669","수정")%>"></a></li>
						</c:if>
						<c:if test="${params.delYn != 'N'}">
		    			<li name="liDel"><a onclick="deleteComment(this);" href="javascript:void(0)" class="ico_del" title="<%=BizboxAMessage.getMessage("TX000019680","삭제")%>"></a></li>
						</c:if>
		    		</ul>
		    	</div>
	    	</div>
	    	
	    	<div class="userChat">
	    		<div class="chatBox">
	    			<div class="chatBox_in">
						<div class="chatBox_lt"></div><div class="chatBox_rt"></div><div class="chatBox_lb"></div><div class="chatBox_rb"></div>
						<span class="chatMsg"></span>
					</div>
	    		</div>
	    	</div>
	    </div>	
	
		<!-- 에디터 -->
	   	<div name="editorBox">
	    	<div class="editorBox">
				<div class="editTextBox">
					<div class="textDiv" contenteditable="true" tabindex="0" style="-webkit-ime-mode:active; -moz-ime-mode:active; -ms-ime-mode:active; ime-mode:active;"></div>
					<textarea class="cloneHiddenText hidden"></textarea>
					<div class="textBtn">
						<a onclick="saveComment(this);" href="javascript:void(0)" class="submitBtn"><%=BizboxAMessage.getMessage("TX000001256","저장")%></a>
					</div>
				</div>
				
				<div class="editFileBox" <c:if test="${params.attachYn == 'N'}">style="display:none;"</c:if>>
					<div class="fileTitle">
						<span class="fileModifyTit"><%=BizboxAMessage.getMessage("TX000005188","파일첨부")%></span>
						<div class="fileModifyInfo">
							<span><%=BizboxAMessage.getMessage("TX000008712","파일 갯수")%></span>
							<span name="fileCnt" class="fwb text_blue">0</span><%=BizboxAMessage.getMessage("TX000001633","개")%>
						</div>
						<div class="fileUploadBtn">
							<a href="#n" onclick="$('#uploadFile').click();" class=""><%=BizboxAMessage.getMessage("TX000007481","파일찾기")%></a>
						</div>
					</div>
					<ul name="fileGroup" class="fileGroup"></ul>
				</div>							
				
				<div class="editCloseBtn">
		    		<ul>
		    			<li><a onclick="editorRemove(this);" href="javascript:void(0)" class="ico_clo" title="<%=BizboxAMessage.getMessage("TX000021232","닫기")%>"></a></li>
		    		</ul>
		    	</div>
			</div>
		</div>
		
		<!-- 댓글 첨부 -->
		<span name="chatEtc" class="chatEtc">
			<ul class="file_group">
				<li name="file_img">
	        		<a href="javascript:void(0)" class="file_img">
	        			<img src="" class="">
        			</a>
       			</li>
	        	<li name="fl">
	        		<div class="fl">
	        			<img src="" alt="" class="fl">
	        			<a onclick="fileDownload(this, 'def');" href="#n" class="file_txt fl ellipsis" title=""></a>
	        		</div>
	        		<div class="fr clear">
						<c:if test="${downloadType == '0'}">
	        			<a name="file_save" onclick="fileDownload(this, 'direct');" href="javascript:void(0)" class="fl text_blue f11"><%=BizboxAMessage.getMessage("TX000022068","PC저장")%></a>
	        			<span class="span_line">|</span>
	        			<a name="file_viewer" onclick="fileDownload(this, 'viewer');" href="javascript:void(0)" class="fl text_blue f11"><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>						
						</c:if>
						<c:if test="${downloadType == '1'}">
						<a name="file_save" onclick="fileDownload(this, 'direct');" href="javascript:void(0)" class="fl text_blue f11"><%=BizboxAMessage.getMessage("TX000022068","PC저장")%></a>
						</c:if>
						<c:if test="${downloadType == '2'}">
						<a name="file_viewer" onclick="fileDownload(this, 'viewer');" href="javascript:void(0)" class="fl text_blue f11"><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>
						</c:if>												
	        		</div>
	        	</li>
	        </ul>
		</span>
		
		<!-- 에디터 첨부 -->
        <li name="editorFile">
        	<img name="icon" src="" class="fl">
	        <a href="#n" class="fileTxt ellipsis" title=""><span></span></a>
	        <a href="#n" title="삭제" class="del_file">
	        	<img src="/gw/Images/mention/close_btn01.png" alt="" onclick="delFile(this);">
	       	</a>
        </li>
		
		<!-- 멘션 -->
		<input type="button"  name="mentionSpan" class="mentionSpan" contenteditable="true" compseq="" deptseq="" empseq="" />
	</div>
	
	<c:if test="${activxYn == 'Y'}">
	<OBJECT id="PimonAX"
		  classid="clsid:D5EC7744-CA4E-42C0-BF49-3A6F2B225A32"
		  codebase="/gw/js/activeX/plugin/PimonFileCtrl.cab#version=2017.1.3.1"
		  width=0 
		  height=0 
		  align=center 
		  hspace=0 
		  vspace=0
	>
	</OBJECT>
	</c:if>	
	
	
<form id="docViewrPopForm" name="docViewrPopForm" method="post">
    <input type="hidden" name="groupSeq" />
    <input type="hidden" name="fileId" />
    <input type="hidden" name="fileSn" />
    <input type="hidden" name="moduleTp" />
    <input type="hidden" name="pathSeq" />
    <input type="hidden" name="inlineView" value="Y" />
</form>
	
</body>