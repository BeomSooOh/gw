<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%@page import="neos.cmm.util.BizboxAProperties"%>
<%String allDownLoadLimit = BizboxAProperties.getCustomProperty("BizboxA.Cust.allDownLoadLimit");%>

<head>
	<!--css-->
	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/common.css?ver=20201021">
	<link rel="stylesheet" type="text/css" href="/gw/css/attachments.css?ver=20201021">
	    
	<!--js-->
	<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jquery-ui-1.12.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/attachments.js?ver=20201021"></script>
	<script type="text/javascript" src="/gw/js/exif.js"></script>

	<script type="text/javascript" language="javascript">
	
		var buildType = "${buildType}"; 
		var pathSeq = '${pathSeq}';
		var groupSeq = '${groupSeq}';
		var uploadMode = '${uploadMode}';
		var activeYn = "${activxYn}";
		var edriveYn = "${showPath}";
		var publicCheckYn = "${params.publicCheckYn}";
		var publicCheckTp = "${params.publicCheckTp}";
	    var downloadType = "${downloadType}";
	    var allDownLoadLimit = "<%=allDownLoadLimit%>";
	    
	    //첨부파일 용량, 갯수제한
	    var availCapac = "${groupPathInfo.availCapac}";
	    var totalCapac = "${groupPathInfo.totalCapac}";
	    var limitFileCount = "${groupPathInfo.limitFileCount}";	
	    
	    //확장자제한 및 허용파일갯수
	    var allowExtention = "${allowExtention}";
	    var blockExtention = "${blockExtention}";
	    var allowFileCnt = "${allowFileCnt}";	  
	    
	    //자동첨부 관련
	    var deleteYn = "${deleteYN}";
	    var fileNms = "${fileNms}";
	    var fileKey = "${fileKey}";	    
	    var autoFileSizeList = "${autoFileSizeList}";
		
		var selectedFileInfo;
		var viewType = "${viewType}";
		var Bindinglist = [];
		var attachFile = [];
		var cntFile = 0;
		var allFileCnt = 0;
		var allFileSize = 0;
		var checkLimitCnt = 0;
		var UPLOAD_COMPLITE = false;
		var tempPath = "";
		var tempFolder = "";
		var UploadCallback = "";
		
		var listRowCnt = 0;
		
		var gwVolumeSize = "${gwVolumeInfo.gwVolume}";
		var gwTotalFileSize = "${gwVolumeInfo.totalFileSize}";
		
		var loginVO = "${loginVO.uniqId}";
		
		//dzUpDownloaderArea
		if(parent.document.getElementById("uploaderView") != null){
			parent.document.getElementById("uploaderView").setAttribute("scrolling", "no");
		}
		
		//리사이즈
		$(window).resize(function () {
			fnSetFileAreaHeight();
		});		
		
		$(document).ready(function () {
			
			init();
			
	        if(parent.fnLoadCallback != null){
	        	parent.fnLoadCallback();
	        }
	        
		});
		
		function init(){
			
			fnSetFileAreaHeight();
			
			if(viewType == ""){
				viewType = "Thumbnail";
			}
			
	        if(allowFileCnt != "")
	        	limitFileCount = allowFileCnt;
	        
	        if(availCapac == "0" || availCapac == 0)
	        	availCapac = (5120 * 1024 * 1024);
	        else
	        	availCapac = availCapac * 1024 * 1024;
	        
	        if("${allowFileSize}" != ""){
	        	availCapac = "${allowFileSize}" * 1024 * 1024;
	        }
	        
	        if(totalCapac == "0" || totalCapac == 0)
	        	totalCapac = "";
	        else
	        	totalCapac = totalCapac * 1024 * 1024
	        if(limitFileCount == "0" || limitFileCount == 0)
	        	limitFileCount = "";
	        
	        if(fileKey != ""){
	        	tempFolder = fileKey;
	        	tempPath = "${pathMp.absolPath}/uploadTemp/" + tempFolder;
	        }else{
	            //임시폴더키 생성
	            var rndstr = new RndStr();
	            rndstr.setType('0'); //숫자
	            rndstr.setStr(20);   //10자리
	            tempFolder = rndstr.getStr();
	            tempPath = "${params.absolPath}/uploadTemp/" + tempFolder;
	        }
	        
		    //첨부파일보기설정(문서뷰어, 파일다운)
		    //downloadType : -1 -> 미선택
		 	//downloadType : 0 -> 문서뷰어+파일다운
		 	//downloadType : 1 -> 파일다운
		 	//downloadType : 2 -> 문서뷰어
		    if(downloadType == "-1" || downloadType == "1"){
		    	$("[name=fileDownloadBtn_view]").remove();
		    }
	        
		    if(downloadType == "-1" || downloadType == "2"){
		    	$("[name=fileDownloadBtn_down]").remove();
		    	$("[name=allDownBtn]").remove();
		    }
	        
	        $("#dzDownloaderDiv").click(function (e) {
	        	$("[name=dzDownloaderPopModel]").hide();
	        });
	        
	        if(uploadMode == "U"){
	        	fileAppendEventSet();
	        }
	        
	        fnClearBinding();
	        
	        if(fileKey != ""){
	        	addAutoAttach();
	        }
	        
		}
		
		function fnSetFileAreaHeight(){
			
			if(frameElement != null){
				$("#dzUpDownloaderArea").css("height", $(frameElement).height() - 36);
			}else{
				$("#dzUpDownloaderArea").css("height", $(window).height() - 36);
			}
			
			//리스트형 재정렬 
			if(viewType == "List"){
				fnListTypeRefreshWidth();
			}
			
		}

		function fnSelectFileIconList(type){
			
			if(viewType != type){
				viewType = type;
				
				fnClearBinding();
				fnBinding();
			}
			
			fnSetFileAreaHeight();
		}
		
		function fnDownLoadFileListBinding(fileList){
			if(fileList != null && fileList.length > 0){
				Bindinglist = fileList.slice();
				fnBinding();
			}
		}
		
		function fnAttFileListBinding(fileList){
			if(fileList != null && fileList.length > 0){
				Bindinglist = fileList.slice();
				fnBinding();				
			}
		}		
		
	    function fnBinding() {
	    	
	    	fnClearBinding();
	    	
	    	if(Bindinglist == null){
	    		return;	
	    	}
	    	
	        $("#fileGroup").html("");
	        $("#productList").html("");
	        cntFile = 0;
	        checkLimitCnt = Bindinglist.length;
	        
	        if (Bindinglist != null && Bindinglist.length > 0) {
	        	
	        	fnAppendFileList(Bindinglist);
	        	
	        }
	        
	    	if(allDownLoadLimit == "99"){
	    		allDownLoadLimit = "30";
	    	}
	        
	    }
	    
	    function fnAppendFileList(fileList){
	    	
            $.each(fileList, function (i, t) {
            	
            	fnAppendFileInfo(i, t);
            	
            });	   
            
            cntFile = Bindinglist.length;
            
    		setTimeout(function(){ 
    			
    			fnSetAllFileSize();
    			
    	        if(allFileSize/1024/1024 > parseInt(allDownLoadLimit) || loginVO == ""){
    	        	$("[name=allDownBtn]").remove();
    	        }
    		
    		}, 150);
	    	
	    }

	    var temp777;
	    function fnAppendFileInfo(i, t){
	    	
	    	if(t.fileDiv == "D"){
	    		return;
	    	}
	    	
        	var model_file = $("#dzDownloaderModel [name=dzDownloader" + viewType + "Model]").clone();
        
        	if(t.fileSn == null || t.fileSn == ""){
        		t.fileSn = $("[fileunit=Y][fileid=" + t.fileId.replace(/\./g,'\\.') + "]").length.toString();
        	}

        	$(model_file).attr("fileid", t.fileId);
        	$(model_file).attr("filesn", t.fileSn);
        	
        	var fileNm = ConvertSystemSourcetoHtml(t.fileNm);
        	
        	if(viewType == "Detail" && edriveYn == "1" && t.filePath != null && t.filePath != ""){
        		fileNm = ConvertSystemSourcetoHtml(t.filePath);
        		$(model_file).find("[name=fileNm]").html(fileNm);
        	}else if(viewType == "List"){
        		$(model_file).find("[name=fileNm]").html(getWithoutExtensionOfFilename(fileNm));
        		$(model_file).find("[name=fileExt]").html(getExtensionOfFilename(fileNm));
        	}else{
        		$(model_file).find("[name=fileNm]").html(fileNm);	
        	}
        	
        	if(t.fileSize != null && t.fileSize != 0){
        		$(model_file).find("[name=fileSize]").html(" (" + byteConvertor(t.fileSize) + ")");	
        	}
        	
        	var aTagName = $(model_file).find("a").last();
        	
        	if(viewType == "List"){
        		aTagName.attr("title", fileNm + $(model_file).find("[name=fileSize]").text());
        	}else{
        		aTagName.attr("title", $(aTagName).text());	
        	}
        	
    		if(publicCheckYn == "Y"){
    			
    			var publicDisabled = "";
    			
    			if(publicCheckTp == "Y" || publicCheckTp == "N"){
    				t.filePublicYn = publicCheckTp;
    				publicDisabled = 'onclick="return false;" disabled';
    			}
    			
    			if(uploadMode == "D"){
    				
    				if(viewType == "Thumbnail"){
    					
    					$(model_file).find("[name=filePublicBtn]").html('<input ' + publicDisabled + ' type="checkbox" ' + (t.filePublicYn == "Y" ? 'checked' : '') + ' name="inp_chk_' + viewType + i + '" id="inp_chk_' + viewType + i + '" style="visibility: hidden;" /><label class="" for="inp_chk_' + viewType + i + '"><img src="/gw/Images/ico/ico_public.png" class="" alt="<%=BizboxAMessage.getMessage("","공개")%>" title="<%=BizboxAMessage.getMessage("","공개")%>"/></label>');
    					
    				}else{
    					
    					if(t.filePublicYn == "Y"){
    						$(model_file).find("[name=filePublicBtn]").html('<img src="/gw/Images/ico/ico_chk_blue01.png" alt="<%=BizboxAMessage.getMessage("TX000001076","공개")%>" title="<%=BizboxAMessage.getMessage("TX000001076","공개")%>" style="cursor:default;"/>');
    					}else{
    						$(model_file).find("[name=filePublicBtn]").html('<img src="/gw/Images/ico/ico_chk_gray01.png" alt="<%=BizboxAMessage.getMessage("TX000022684","비공개")%>" title="<%=BizboxAMessage.getMessage("TX000022684","비공개")%>" style="cursor:default;"/>');
    					}
    					
    				}
    				        				
    			}else{
    				
    				/*
    				if(publicDisabled != "" && viewType != "Thumbnail"){
    					
    					if(t.filePublicYn == "Y"){
    						$(model_file).find("[name=filePublicBtn]").html('<img src="/gw/Images/ico/ico_chk_blue01.png" alt="<%=BizboxAMessage.getMessage("TX000001076","공개")%>" title="<%=BizboxAMessage.getMessage("TX000001076","공개")%>" style="cursor:default;"/>');
    					}else{
    						$(model_file).find("[name=filePublicBtn]").html('<img src="/gw/Images/ico/ico_chk_gray01.png" alt="<%=BizboxAMessage.getMessage("TX000022684","비공개")%>" title="<%=BizboxAMessage.getMessage("TX000022684","비공개")%>" style="cursor:default;"/>');
    					}
    					
    				}else{
    					$(model_file).find("[name=filePublicBtn]").html('<input ' + publicDisabled + ' onchange="fnChangePublicCheck(this);" type="checkbox" ' + (t.filePublicYn == "Y" ? 'checked' : '') + ' name="inp_chk_' + viewType + i + '" id="inp_chk_' + viewType + i + '" style="visibility: hidden;" /><label class="" for="inp_chk_' + viewType + i + '">' + (viewType == "Thumbnail" ? '<img src="/gw/Images/ico/ico_public.png" class="" alt="<%=BizboxAMessage.getMessage("","공개")%>" title="<%=BizboxAMessage.getMessage("","공개")%>"/>' : '') + '</label>');
    					
    					if(viewType == "Thumbnail" && publicDisabled == ""){
    						$(model_file).find("[name=filePublicBtn]").css("z-index","1");
    					}
    				}
    				*/
    				
					$(model_file).find("[name=filePublicBtn]").html('<input ' + publicDisabled + ' onchange="fnChangePublicCheck(this);" type="checkbox" ' + (t.filePublicYn == "Y" ? 'checked' : '') + ' name="inp_chk_' + viewType + i + '" id="inp_chk_' + viewType + i + '" style="visibility: hidden;" /><label class="" for="inp_chk_' + viewType + i + '">' + (viewType == "Thumbnail" ? '<img src="/gw/Images/ico/ico_public.png" class="" alt="<%=BizboxAMessage.getMessage("","공개")%>" title="<%=BizboxAMessage.getMessage("","공개")%>"/>' : '') + '</label>');
					
					if(viewType == "Thumbnail" && publicDisabled == ""){
						$(model_file).find("[name=filePublicBtn]").css("z-index","1");
					}
    				
    			}
    			
    		}else{
    			$(model_file).find("[name=filePublicBtn]").remove();
    		}
    		
    		if(uploadMode == "D"){
    			$(model_file).find("[name=fileDelBtn]").remove();
    		}else if(t.fileUrl == ""){
    			
    			if(t.fileDeleteYn == "N"){
    				$(model_file).find("[name=fileDelBtn]").remove();
    			}
    			
    			$(model_file).find("[name=fileDownloadBtn]").remove();
    			$(model_file).find("[name=fileDownloadA]").attr("onclick", "");
    		}
        	
        	if(viewType == "Thumbnail"){
        		var fileClass = fncGetFileClass(t.fileDiv, fileNm);
        		
        		if(fileClass == "img"){
    				<c:choose>
    				<c:when test="${params.drmUseYn == 'Y'}">
    				$(model_file).find("[name=fileExtImg]").addClass("file_img2");
    				</c:when>
    				<c:otherwise>
        			var img = document.createElement("img");
        			img.width = "87";
        			img.height = "87";
         			img.src = t.fileThumUrl;
         			
        			img.onerror = function(){
        				$(this).parent().addClass("file_img2");
        				$(this).remove();
        			} 

  		            $(model_file).find("[name=fileExtImg]").append(img);    				
    				</c:otherwise>
    				</c:choose>	        			
        		}else{
        			$(model_file).find("[name=fileExtImg]").addClass(fileClass);	
        		}
        		
        		$("[name=fileSetThumbnail]").append(model_file);
        		
        	}else if(viewType == "List"){
        		
        		$(model_file).find("[name=fileDownloadA]").addClass(fncGetFileClassList(fileNm));
        		
        		var lastUl = $("[name=fileSetList] [name^=fileSetListU]");
        		
        		if(lastUl.last().find("li").length == listRowCnt){
        			
        			var modelUl = $("#dzDownloaderModel [name=dzDownloaderListUlModel]").clone();
        			
        			$(modelUl).find("div").attr("name", "fileSetListU" + (lastUl.length + 1));
        			$(modelUl).find("div").append(model_file);
        			$("[name=fileSetList]").append(modelUl);
        			
        			//동적 UL에대한 이벤트 갱신 
        			fileAppendEventSetList();
        			
        		}else{
        			
        			if(lastUl.first().find("li").length < listRowCnt){
        				lastUl.first().append(model_file);
        			}else{
        				lastUl.last().append(model_file);	
        			}
        			
        		}
        		
        	}else if(viewType == "Detail"){
        		
        		$(model_file).find("[name=fileDownloadA]").addClass(fncGetFileClassList(fileNm));
        		$("[name=fileSetDetail] [name=fileSetListU1]").append(model_file);
        		
        	}	    	
	    }
	    
	    function fnClearBinding(){
	    	
	    	if(publicCheckYn == "Y" && viewType != "Thumbnail"){
	    		$("[name=filePublicTop]").show();
	    	}else{
	    		$("[name=filePublicTop]").hide();
	    	}
	    	
	    	fnFileSet();
	    	$("[name=fileSetThumbnail],[name=fileSetListU1],[name=fileSetListU2]").html("");
	    	$("[name=fileSetList] [name=dzDownloaderListUlModel]").remove();
	    	
	    }
	    
	    function fnFileSet(){
	    	
	    	$("[name=fileSetEmpty],[name=fileSetThumbnail],[name=fileSetList],[name=fileSetDetail]").hide();
	    	
	    	if(uploadMode == "U" && allFileCnt == 0){
	    		$("[name=fileSetEmpty]").show();
	    	}else{
	    		$("[name=fileSet" + viewType + "]").show();	
	    	}
	    	
	    	if(viewType == "List"){
	    		listRowCnt = Math.floor(($("#dzUpDownloaderArea").height()-26-(publicCheckYn == "Y" ? 30 : 0))/21);
	    	}
	    		    	
	    }
	    
	    function fnAttachInfo(obj, mode, event){
	    	
	    	var infoFileId = $(obj).parents("[fileunit=Y]").attr("fileid");
	    	
	    	if(infoFileId == null || infoFileId.indexOf("addFile_") > -1){
	    		return;
	    	}
	    	
	    	selectedFileInfo = fnGetFileInfoFromId(infoFileId, $(obj).parents("[fileunit=Y]").attr("filesn"));
	    	
	    	if(selectedFileInfo == null){
	    		alert("<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>");
	    		return;
	    	}
	    	
	    	if(mode == "pop"){
	    		fnDzDownloaderPop(obj, event);
	    	}else if(mode == "down"){
	    		fnAttachDown();
	    	}else if(mode == "view"){
	    		fnAttachView();
	    	}
	    	
	    }
	    
	    function fnDzDownloaderPop(obj, event){
	    	
		    //첨부파일보기설정(문서뷰어, 파일다운)
		    //downloadType : -1 -> 미선택
		 	//downloadType : 0 -> 문서뷰어+파일다운
		 	//downloadType : 1 -> 파일다운
		 	//downloadType : 2 -> 문서뷰어
		 	if(downloadType == "-1"){
		 		
		 	}else if(downloadType == "-1"){
		 		
		 	}else if(downloadType == "1"){
		 		fnAttachDown();
		 	}else if(downloadType == "2"){
		 		fnAttachView();
		 	}else{
		 		
	    		setTimeout(function(){ 
	    			
	    	        var dzDownloaderPopModel = $("[name=dzDownloaderPopModel]");
	    	        dzDownloaderPopModel.css('z-index', 10000);
	    	        /* dzDownloaderPopModel.css('top', $(obj).offset().top);
	    	        dzDownloaderPopModel.css('left', $(obj).offset().left); */
	    	        dzDownloaderPopModel.css('top', event.clientY);
	    	        dzDownloaderPopModel.css('left', event.clientX);
	    	        dzDownloaderPopModel.fadeIn('500');
	    	        dzDownloaderPopModel.fadeTo('10', 1.9);
	    	        dzDownloaderPopModel.show();
	    		
	    		}, 100);	 		 		
		 	}
	    }
	    
	    function fnAttachInfoPop(mode){
	    	
	    	if(selectedFileInfo == null){
	    		alert("<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>");
	    		return;
	    	}
	    	
			if(mode == "down"){
	    		
	    		fnAttachDown();
	    		
	    	}else if(mode == "view"){
	    		
	    		fnAttachView();
	    		
	    	}
	    	
	    }	    
	    
	    function fnAttachView(){
			var extsn = getExtensionOfFilename(selectedFileInfo.fileNm);
			
			var checkExtsn = ".hwp.hwpx.doc.docx.ppt.pptx.xls.xlsx";
			<c:choose>
			<c:when test="${inlineViewYn == 'N'}">
			var checkExtsnInline = "";
			</c:when>
			<c:otherwise>
			var checkExtsnInline = ".jpeg.bmp.gif.jpg.png.pdf";
			</c:otherwise>
			</c:choose>			
			if(checkExtsnInline.indexOf(extsn) != -1){
				fnInlineView(selectedFileInfo.fileUrl, selectedFileInfo.fileNm, selectedFileInfo.fileId);
			}else if(checkExtsn.indexOf(extsn) != -1){
				fnDocViewerPop(selectedFileInfo.fileUrl, selectedFileInfo.fileNm, selectedFileInfo.fileId);
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000575","해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자 : 이미지, pdf, hwp, hwpx, doc, docx, ppt, pptx, xls, xlsx]")%>");
				return;
			}	    	
	    }
	    
	    function fnAttFileList() {
	    	
	    	var tblParam = {};
	    	
	    	var attachfilelist = "";
	    	var attachpathlist = "";
	    	var deletefilelist = "";
	    	var deletekeylist = "";
	    	var deletesnlist = "";
	    	var dzUploaderInfoList = [];
	    	
            $.each(Bindinglist, function (i, t) {
            	
            	var dzUploaderInfo = {};
            	var dzUploadFileNm = t.fileNm.replace(/&#39;/g,"\'");
            	
            	dzUploaderInfo.viewOrder = i;
            	
            	if(publicCheckTp == "Y" || publicCheckTp == "N"){
            		t.filePublicYn = publicCheckTp;
            	}
            	
            	if(t.fileDiv == "N" || t.fileDiv == "A"){
            		
            		if((t.fileDiv == "N" && UPLOAD_COMPLITE) || t.fileDiv == "A"){
                		dzUploaderInfo.fileDiv = "N";
                		dzUploaderInfo.fileId = "";
                		dzUploaderInfo.fileNm = dzUploadFileNm;
                		dzUploaderInfo.filePublicYn = (t.filePublicYn == "Y" ? "Y" : "N");
                		
                		attachfilelist += (attachfilelist == "" ? "" : "|") + dzUploadFileNm;
                		attachpathlist += (attachpathlist == "" ? "" : "|") + (t.filePath == null || t.filePath == "" ? dzUploadFileNm : t.filePath);
                		
                		dzUploaderInfoList.push(dzUploaderInfo);            			
            		}
            		
            	}else if(t.fileDiv == "D"){
            		
            		dzUploaderInfo.fileDiv = "D";
            		dzUploaderInfo.fileId = t.fileId;
            		dzUploaderInfo.fileNm = dzUploadFileNm;
            		dzUploaderInfo.filePublicYn = (t.filePublicYn == "Y" ? "Y" : "N");
            		
            		deletefilelist += (deletefilelist == "" ? "" : "|") + dzUploadFileNm;
            		deletekeylist += (deletekeylist == "" ? "" : "|") + t.fileId;
            		deletesnlist += (deletesnlist == "" ? "" : "|") + (t.fileSn == null || t.fileSn == "" ? "0" : t.fileSn);
            		
            		dzUploaderInfoList.push(dzUploaderInfo);            		
            		
            	}else{
            		dzUploaderInfo.fileDiv = "M";
            		dzUploaderInfo.fileId = t.fileId;
            		dzUploaderInfo.fileNm = dzUploadFileNm;
            		dzUploaderInfo.filePublicYn = (t.filePublicYn == "Y" ? "Y" : "N");

            		dzUploaderInfoList.push(dzUploaderInfo);                 		
            	}
            	
            });	  	    	
	    	
            tblParam.dzUploaderInfoList = dzUploaderInfoList;
	    	tblParam.attachfilelist = attachfilelist;
	    	tblParam.attachpathlist = attachpathlist;
	    	tblParam.deletefilelist = deletefilelist;
	    	tblParam.deletekeylist = deletekeylist;
	    	tblParam.deletesnlist = deletesnlist;
	    	tblParam.tempfolder = tempPath;
	        
	        return tblParam;
	    }	    

	    function getFileNmList(){
	    	
	    	var fileNmList = "";
	    	
			$.each(Bindinglist.filter(function(x) { return x.fileDiv != "D"}), function (i, t) {
				
				fileNmList += (fileNmList == "" ? "" : "|") + t.fileNm;
 	
 			});
	    	
	    	return fileNmList;
	    }
	    
	    function getUploadFileCnt(){
	   	 	return allFileCnt;    	 
	    }

	    function fnAttFileUpload() {

	        if (attachFile.length == 0 || UPLOAD_COMPLITE) {
	            return true;
	        }

	        if (attachFile.length > 0) {

	            var path = '<c:url value="/ajaxFileUploadProc.do" />';
	            var abort = false;
	            var formData = new FormData();
	           	var nfcFileNames = "";
	            
	            for (var x = 0; x < attachFile.length; x++) {
	                formData.append("file" + x, attachFile[x]);
	                nfcFileNames += (nfcFileNames == "" ? "" : "|") +  btoa(unescape(encodeURIComponent(attachFile[x].name)));
	            }
	            
	            formData.append("nfcFileNames", nfcFileNames);
	            formData.append("tempFolder", tempFolder);
	            formData.append("pathSeq", fileKey != "" ? "0" : pathSeq);
	            formData.append("groupSeq", groupSeq);     
	            formData.append("targetPathSeq", pathSeq);
				formData.append("uploadMode", uploadMode);
	    	    
	            fnSetProgress();

	            var AJAX = $.ajax({
	                url: path,
	                type: 'POST',
		        	timeout:600000,
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
												
						//2021-06-30 업로드 되지않은 파일을 Bindinglist에서 제거
						Bindinglist = Bindinglist.filter( function(element, index){
							if(Bindinglist[index].fileId.indexOf("addFile") > -1){
								if(data.attachFileNm.indexOf(Bindinglist[index].filePath) > -1){
									return element;
								}
							}else{
								return element;
							}
						})
						
						//콜백함수 호출
				        if (UploadCallback != "") {
				        	parent.eval(UploadCallback);
				        }
						
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
	        
	        return false;
	    }
	    
	    function fnRemoveProgress() {
	    	parent.document.getElementById('UploadProgress').style.display = 'none';
	    }	    
	    
	    function progressHandlingFunction(e) {
	        if (e.lengthComputable) {
	        	parent.document.getElementById("uploadStat").innerHTML = parseInt((e.loaded / e.total) * 100);
	        	parent.document.getElementById("uploadStatByte").innerHTML = parseInt((e.loaded/1000)) + "/" + parseInt((e.total/1000));
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
	    
	    function getAttTotalSize(){
	    	return allFileSize/1024/1024;
	    }
	    
	    function changePublicCheckTp(publicCheckTpTo){

	    	publicCheckTp = publicCheckTpTo;
	    	
	    	var viewTypeOld = viewType;
	    	
	    	viewType = "";
	    	
	    	fnSelectFileIconList(viewTypeOld);
	    	
	    }	    

	    function fnDownloadAll(){

	    	if(Bindinglist.length > 0){
	    		var fileIdList = "";
	    		var fileSnList = "";
	    		var moduleTp = "";
	    		for(var i=0;i<Bindinglist.length;i++){
	    			var fileUrl = Bindinglist[i].fileUrl;    			
	    			
	    			
	    			var fileSn = "";
	    			
	    			fileIdList += "|" + Bindinglist[i].fileId;    			
	    			
	    			if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1 || fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){    	
	    				moduleTp += "|gw";
	    				fileSn = getQueryVariable(fileUrl, 'fileSn');
	    				if(fileSn == "" || fileSn == null)
	    					fileSnList += "|0";
	    				else
	    					fileSnList += "|" + fileSn;
	    	    	}    	    	 	    	
	    	    	//게시판 url예외처리
	    	    	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
	    	    		moduleTp += "|board";
	    	    		fileSnList += "|0";
	    	    	}
	    	    	
	    	    	//문서 url예외처리
	    	    	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
	    	    		
	    	    		if(fileUrl.indexOf("oldArtNo") != -1){
		    	    		moduleTp += "|doc_old";
		    	    		fileSnList += "|" + getQueryVariable(fileUrl, 'oldArtNo');
	    	    		}else{
		    	    		moduleTp += "|doc";
		    	    		fileSnList += "|0";
	    	    		}		    	    		

	    	    	}
	    					
	    	    	//결재문서 url예외처리
	    	    	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
	    	    		moduleTp += "|bpm";
	    	    		fileSnList += "|0";
	    	    	}    			
	    			
	    		}
	    		
	    		var tblParam = {};
	    		tblParam.fileIdList = fileIdList.substring(1);
	    		tblParam.fileSnList = fileSnList.substring(1);
	    		tblParam.moduleTp = moduleTp.substring(1);
	    			
	    		$.ajax({
	    	     	type:"post",
	    	 		url:'<c:url value="/ajaxAllFileDownloadProc.do" />',
	    	 		datatype:"text",
	    	 		data: tblParam,
	    	 		success: function (data) {
	    	 			
	    	 			if(data.resultCode == "SUCCESS"){
	    	 				window.location.href = "./ajaxAllFileDownload.do";
	    	 			}else{
	    	 				alert('<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>');
	    	 			}
	    	 			
	    			},
	    			error: function (result) {
	    				alert('<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>');
	    	 		}
	    	 	});
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
	    
		var TX900000585 = "<%=BizboxAMessage.getMessage("TX900000585","E드라이브 연동으로 파일 드레그가 불가합니다.")%>";
		var TX900000578 = "<%=BizboxAMessage.getMessage("TX900000578","E드라이브 연동으로 파일첨부는 IE브라우져만 지원합니다.")%>";
		var TX900000582 = "<%=BizboxAMessage.getMessage("TX900000582","업로드 제한 파일 갯수를 초과하였습니다.\\n(설정 갯수 :")%>";
		var TX900000588 = "<%=BizboxAMessage.getMessage("TX900000588","업로드 파일명은 255바이트 이하만 가능합니다.\\n파일명 변경 후 다시 시도해 주세요.")%>";
		var TX900000583 = "<%=BizboxAMessage.getMessage("TX900000583","업로드 개당 제한 용량을 초과하였습니다.\\n(설정용량:")%>";
		var TX900000577 = "<%=BizboxAMessage.getMessage("TX900000577","업로드 전체용량을 초과하였습니다.\\n(설정용량:")%>";
		var TX000007512 = "<%=BizboxAMessage.getMessage("TX000007512","같은파일이 이미 첨부되었습니다.")%>";
		var TX900000586 = "<%=BizboxAMessage.getMessage("TX900000586","용량이 부족하여 첨부파일 업로드가 불가합니다.")%>";
		var TX900000306 = "<%=BizboxAMessage.getMessage("TX900000306","관리자에게 문의하세요.")%>";
		var TX900000587 = "<%=BizboxAMessage.getMessage("TX900000587","[잔여용량 : 0GB]")%>";
		var TX900000590 = "<%=BizboxAMessage.getMessage("TX900000590","업로드 가능한 확장자가 아닙니다.\\n업로드 가능 확장자:")%>";
		var TX900000589 = "<%=BizboxAMessage.getMessage("TX900000589","확장자가 없는 파일은 첨부할 수 없습니다.")%>";
		var TX000011283 = "<%=BizboxAMessage.getMessage("TX000011283","선택하신 {0} 확장자를 가진 파일은 업로드 하실 수 없습니다.")%>";
		
		var alertLimit = "<%=BizboxAMessage.getMessage("","제한된 확장자입니다.\\n[제한확장자 : {0}]")%>";
		var alertPermit = "<%=BizboxAMessage.getMessage("","허용되지 않은 확장자입니다.\\n[허용확장자 : {0}]")%>";
	
	</script>

</head>

<body>

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

<div id="dzDownloaderDiv" class="tb_addfile">
	<table class="Addfile">
		<tbody>
			<tr id="attachFileTop">
				<td class="addfile_top">					
					<span class="fl bold"><%=BizboxAMessage.getMessage("TX000006498","일반첨부파일")%></span>
					<c:if test="${uploadMode == 'U'}">
					<span class="fileuplode"><input id="fileUpload" type="button" class="puddSetup small_btn" value="<%=BizboxAMessage.getMessage("TX000007481","파일찾기")%>" /></span>
					</c:if>					
					<input id="uploadFile" name="uploadFile" multiple="multiple" type="file" style="display:none" />					
					<span name="allFileCnt" class="blue_bold pl5">0</span><span name="allFileEa" class="blue pr5"><%=BizboxAMessage.getMessage("TX000001633","개")%></span><span name="allFileSize">(0 KB)</span>
					
					<c:if test="${uploadMode == 'D'}">		
						<div class="fr file_iconList">
							<ul>
								
								<li><a href="javascript:fnSelectFileIconList('Thumbnail');" class="thumbnail" title="<%=BizboxAMessage.getMessage("TX000015620","썸네일 보기")%>"></a></li>
								<li><a href="javascript:fnSelectFileIconList('List');" class="list" title="<%=BizboxAMessage.getMessage("TX000015621","리스트 보기")%>"></a></li>
								<li><a href="javascript:fnSelectFileIconList('Detail');" class="detail" title="<%=BizboxAMessage.getMessage("TX000007394","자세히 보기")%>"></a></li>
								<li><a name="allDownBtn" href="javascript:fnDownloadAll();" class="alldown" title="<%=BizboxAMessage.getMessage("TX000013952","전체다운로드")%>"></a></li>
								
							</ul>
						</div>
					</c:if>
				</td>
			</tr>

			<tr class="big_tr">
				<td class="addfile_bot">

					<div id="dzUpDownloaderArea" class="filebox mi135">
					
						<!-- Empty -->
						<div name="fileSetEmpty">
					    	<div class="file_add_bot">
					        	<div class="file_add_bot_dis">
					            	<span class="fileplus_ico"><%=BizboxAMessage.getMessage("TX000007511","파일을 마우스로 끌어 추가해주세요.")%></span>
					        	</div>
					    	</div>						
						</div>

						<!-- 썸네일 -->
						<div name="fileSetThumbnail" class="file_add_bot p0" style="display:none;"></div>
						
						<!-- 목록형 (조회,작성)-->
						<div name="fileSetList" class="file_add_bot deList" style="display:none;">
							<ul class="file_group fl" style="height:100%;">
								<li name="filePublicTop" style="border-bottom: 1px solid #bebebe;padding:2px 0px 3px 2px;">
									<p class="left brn"><img src="/gw/Images/ico/ico_public.png" class="pt3" alt="<%=BizboxAMessage.getMessage("","공개")%>" title="<%=BizboxAMessage.getMessage("","공개")%>"/></p>
									<p class="ac"><%=BizboxAMessage.getMessage("TX000017908","첨부파일정보")%></p>	
								</li>
								
								<div name="fileSetListU1" class="pt5 pb5"></div>		
							</ul>
							<ul class="file_group fl" style="height:100%;">
								<li name="filePublicTop" style="border-bottom: 1px solid #bebebe;padding:2px 0px 3px 2px;">
									<p class="left brn"><img src="/gw/Images/ico/ico_public.png" class="pt3" alt="<%=BizboxAMessage.getMessage("","공개")%>" title="<%=BizboxAMessage.getMessage("","공개")%>"/></p>
									<p class="ac"><%=BizboxAMessage.getMessage("TX000017908","첨부파일정보")%></p>	
								</li>
								
								<div name="fileSetListU2" class="pt5 pb5"></div>		
							</ul>							
						</div>							
						
						<!-- 자세히(작성,조회) -->		
						<div name="fileSetDetail" class="file_add_bot" style="display:none;">								
							<ul  class="file_group">
								<li name="filePublicTop" style="border-bottom: 1px solid #bebebe;padding:2px 0px 3px 2px;">
									<p class="left brn"><img src="/gw/Images/ico/ico_public.png" class="pt3" alt="<%=BizboxAMessage.getMessage("","공개")%>" title="<%=BizboxAMessage.getMessage("","공개")%>"/></p>
									<p class="ac"><%=BizboxAMessage.getMessage("TX000017908","첨부파일정보")%></p>	
								</li>
								
								<div name="fileSetListU1" class="pt5 pb5" style="text-overflow:ellipsis;overflow: hidden;white-space:nowrap;"></div>
							</ul>
						</div>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>

<!-- Model -->
<div  id="dzDownloaderModel" style="display:none;">

	<ul fileunit="Y" name="dzDownloaderThumbnailModel" class="file_set">
		<li class="file_disp">
			<span name="filePublicBtn" class="checkOn ml5"></span> 
			<div name="fileDownloadBtn" class="downfile_modal">
				<ul>
					<li><a name="fileDownloadBtn_down" href="javascript:" onclick="fnAttachInfo(this, 'down', event);"><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a></li>
					<li><a name="fileDownloadBtn_view" href="javascript:" onclick="fnAttachInfo(this, 'view', event);"><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a></li>
				</ul>
			</div>									
			<div name="fileExtImg" class=""></div>
			<div onclick="fnDeleteFile(this);" name="fileDelBtn" class="file_delete"></div>
		</li>
		<c:if test="${downloadType == '-1' or downloadType == '2'}">
			<li class="file_name">
		</c:if>	
		<c:if test="${downloadType != '-1' and downloadType != '2'}">
			<li class="file_name" onclick="fnAttachInfo(this, 'down', event);">
		</c:if>	
			<a href="#n" title=""><span name="fileNm"></span><br><span name="fileSize"></span></a>
		</li>
	</ul>
	
	<ul name="dzDownloaderListUlModel" class="file_group fl" style="height:100%;">
		<li name="filePublicTop" style="width:100%;border-bottom: 1px solid #bebebe;padding:2px 0px 3px 2px;">
			<p class="left brn"><img src="/gw/Images/ico/ico_public.png" class="pt3" alt="<%=BizboxAMessage.getMessage("","공개")%>" title="<%=BizboxAMessage.getMessage("","공개")%>"/></p>
			<p class="ac"><%=BizboxAMessage.getMessage("TX000017908","첨부파일정보")%></p>	
		</li>
		
		<div class="pt5 pb5"></div>		
	</ul>	
	
	<li fileunit="Y" name="dzDownloaderListModel" class="clear">
		<span name="filePublicBtn" class="fl"></span>
		<a name="fileDownloadA" href="javascript:" onclick="fnAttachInfo(this, 'pop', event);" class="fl ellipsis pl20" title="" style="max-width:0px;"><span name="fileNm"></span></span></a>
		<span class="fl" name="fileExt"></span>
		<span class="fl" name="fileSize"></span>
		<img onclick="fnDeleteFile(this);" name="fileDelBtn" src="/gw/Images/btn/close_btn01.png" class="imgPointer fl pr10 pl5 pt4" alt=""/>
	</li>
	
	<li fileunit="Y" name="dzDownloaderDetailModel" class="clear">
		<span name="filePublicBtn" class="fl"></span>
		<a name="fileDownloadA" href="javascript:" onclick="fnAttachInfo(this, 'pop', event);" class="pl20" title="" style="display:inline-block;"><span name="fileNm"></span><span name="fileSize"></span></a>
		<img onclick="fnDeleteFile(this);" name="fileDelBtn" src="/gw/Images/btn/close_btn01.png" class="imgPointer mtImg pr10 pl5 pt4" alt=""/>
	</li>

</div>

<!-- 목록형,자세히형 리스트 클릭 시 저장/뷰어열기 레이어팝업  -->
<div name="dzDownloaderPopModel" class="downfile_sel_pop posi_ab" style="display:none;">
	<ul>
		<li><a href="javascript:" onclick="fnAttachInfoPop('down');"><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a></li>
		<li><a href="javascript:" onclick="fnAttachInfoPop('view');"><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a></li>
	</ul>
</div>

<div name="dzFileNamePopModel" class="dz_file_name_tool_tip posi_ab" style="display:none;"></div>

<form id="docViewrPopForm" name="docViewrPopForm" method="post">
    <input type="hidden" name="groupSeq" />
    <input type="hidden" name="fileId" />
    <input type="hidden" name="fileSn" />
    <input type="hidden" name="moduleTp" />
    <input type="hidden" name="pathSeq" />
    <input type="hidden" name="inlineView" value="Y" />
</form>

</body>