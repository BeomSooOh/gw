var attachMode = "";
var agentType = "etc";
var attTotalSize = 0;

//자동첨부 바인드
function addAutoAttach(){
	
	var autoArray = fileNms.split('|');
	var autoFileSizeArrayList = autoFileSizeList.split('|');
		
	for(var i=0;i<autoArray.length;i++){
		if(autoArray[i] != ""){    		
        	var fileId = "addFile_" + cntFile;
            var pushData = {};
            pushData.fileDiv = "A";
    	    pushData.fileId= fileId;
    	    pushData.fileSn= "0";
       		pushData.fileNm= ConvertSystemSourcetoHtml(autoArray[i]);
       		pushData.filePath= "";
       		pushData.fileSize= autoFileSizeArrayList[i];
       		pushData.fileThumUrl= "";
       		pushData.fileUrl= "";
       		pushData.filePublicYn = "Y";
       		pushData.fileDeleteYn = deleteYn;
       		Bindinglist.push(pushData);
        	cntFile++;    		
    	}
	}
    
    if(cntFile > 0){
    	fnBinding();
    }
    
}	

function fnDeleteFile(obj){
	
	var deleteTarget = $(obj).parents("[fileunit=Y]");
	
	var fileId = deleteTarget.attr("fileid");
	var fileSn = deleteTarget.attr("filesn");
	
	$(deleteTarget).remove();
	
	var resultBindinglist = Bindinglist.filter(function(x) { return x.fileId == fileId && x.fileSn == fileSn});
	
	if(resultBindinglist.length > 0){
		if(resultBindinglist[0].fileDiv == "N"){
			removeByKey(Bindinglist, fileId, fileSn);
		}else{
			resultBindinglist[0].fileDiv = "D";	
		}
	}
	
	removeByKey(attachFile, fileId, fileSn);
	
	fnSetAllFileSize();
	
	uploadFile.value = "";
}

function removeByKey(array, fileId, fileSn){
    array.some(function(item, index) {
    	(array[index]["fileId"] == fileId && array[index]["fileSn"] == fileSn) ? !!(array.splice(index, 1)) : false;
    });
}

function fileAppendEventSet(){
	
    var agent = navigator.userAgent.toLowerCase();
    
    if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) || (agent.indexOf("edge") != -1)) {
    	agentType = "ie";
    }
	
    //첨부 파일 추가
    var dropZone = document.getElementById('dzDownloaderDiv');

    if (document.addEventListener && window.File != undefined) {//addEventListener함수를 제공해주는지 여부에 따라 분기
        dropZone.addEventListener('dragover', handleDragOver, false);
        dropZone.addEventListener('drop', handleFileSelect, false);
        document.getElementById('uploadFile').addEventListener('change', handleFileSelect, false);
    }

    $('#fileUpload').click(function () { //파일첨부 클릭
        if (document.addEventListener && window.File != undefined) {
            attachMode = "click";
            $('#uploadFile').click();
        } else {
            product_line_add();
        }
    });
    
    //sortable
    $("[name=fileSetThumbnail]").sortable({
        connectWith: "[name=fileSetThumbnail]",
        update: function(e, ui) {
        	fnRefreshSort();
        }
    }).disableSelection();
    
    $("[name=fileSetDetail] [name=fileSetListU1]").sortable({
        connectWith: "[name=fileSetDetail] [name=fileSetListU1]",
        update: function(e, ui) {
        	fnRefreshSort();
        }
    }).disableSelection();
    
    fileAppendEventSetList();
	
}

function fileAppendEventSetList(){
	
    $("[name=fileSetList] [name^=fileSetListU]").sortable({
        connectWith: "[name=fileSetList] [name^=fileSetListU]",
        update: function(e, ui) {
        	fnRefreshSort();
        }
    }).disableSelection();	
}

function fnRefreshSort(){
	
	$.each($("[fileunit=Y]"), function (i, t) {
		
		var targetFileId = $(t).attr("fileid");
		var targetFileSn = $(t).attr("filesn");
		
		var targetFileInfo = Bindinglist.filter(function(x) { return x.fileId == targetFileId && x.fileSn == targetFileSn});
		
		if(targetFileInfo.length > 0){
			targetFileInfo[0].viewOrder = i;
		}		
		
	});
	
	//Bindinglist 재정렬
	Bindinglist.sort(function (a, b) {
		  if (a.viewOrder > b.viewOrder) {
		    return 1;
		  }
		  if (a.viewOrder < b.viewOrder) {
		    return -1;
		  }

		  return 0;
	});
	
}

function handleFileSelect(evt) {
	
    evt.stopPropagation();
    evt.preventDefault();
    
    var clientPath = "";
    
    if(edriveYn == "1"){
    	
    	if(agentType != "ie"){
    		alert(TX900000578);
    		return;		    		
    	}
    	
    	if(attachMode == "drag"){
			alert(TX900000585);
		    setTimeout("fileUpload.click();" , 10); 
			return;    		
    	}
    	
		//클라이언트 첨부파일 경로
		clientPath = uploadFile.value;
		
		if(clientPath.indexOf("C:\\fakepath") > -1){
			alert("E드라이브 연동으로 브라우져 설정변경이 필요합니다.\r\n#. 도구 > 인터넷옵션 > 보안 > 사용자지정수준\r\n> 파일을 서버에 업로드할 때 로컬 디렉터리 경로 포함(사용)");
			return;
		}		
    	
    }

    if (attachMode == "click") { //파일첨부 클릭
        var files = evt.target.files;
        attachMode = "";
    } else if (attachMode == "drag") { //파일첨부 드래그
        var files = evt.dataTransfer.files; // FileList object.
        attachMode = "";
    } else {
        return;
    }
    
    var overlabCheck = true;
    
    for (var i = 0, f; f = files[i]; i++) {

        
        if(overlabCheck){
        	
            //클라이언트 파일경로 세팅
            if(edriveYn == "1" && clientPath != ""){
            	var idx = clientPath.indexOf("\\" + f.name) + f.name.length + 1;
            	f.filePath = clientPath.substr(0,idx);
            	clientPath = clientPath.substr(idx + 2);
            }else{
            	f.filePath = f.name;
            }

            if(limitFileCount != "" && limitFileCount < (Bindinglist.filter(function(x) { return x.fileDiv != "D"}).length + 1)){
            	alert(TX900000582 + limitFileCount + "개)");
            	overlabCheck = false;
            }
            
            if(overlabCheck){
            	if(f.name.replace(/[\0-\x7f]|([0-\u07ff]|(.))/g,"$&$1$2").length > 255){
            		alert(TX900000588);
            		overlabCheck = false;	
            	}
            }	            
            
            if(overlabCheck){
	        	if(availCapac != "" && f.size > availCapac){
	        		alert(TX900000583 + availCapac/1024/1024 +"MB)");
	        		
	        		overlabCheck = false;
	        	}else{
	        		attTotalSize += parseInt(f.size); 
	        	}
            }
        	
            if(overlabCheck){
	            if(totalCapac != "" && parseInt(totalCapac) < attTotalSize){
	            	attTotalSize -= parseInt(f.size); 
	            	alert(TX900000577 + totalCapac/1024/1024 +"MB)");
	        		overlabCheck = false;
	            }
            }
            
            if(overlabCheck){
	            for (var j = 0; j < attachFile.length; j++) {
	                if (f.name == attachFile[j].name) {
	                    alert(TX000007512 + "\r\n" + f.name);
	                    overlabCheck = false;
	                }
	            }
            }
            
            if(overlabCheck && buildType == "cloud"){
            	var gwVolume = gwVolumeSize;
            	var totalFileSize = gwTotalFileSize;
            	
            	if( Number((attTotalSize/1024/1024/1024)) + Number(totalFileSize) > Number(gwVolume)){
            		alert(TX900000586 + "\r\n" + TX900000306 + " " + TX900000587);
                    overlabCheck = false;
            	}
            }
            
            //업로드 제한 확장자 체크
            if(overlabCheck){
            	var extsn = getExtensionOfFilename(f.name);
            	
        		if(allowExtention != "" && ("|" + allowExtention + "|").indexOf("|" + extsn.substring(1) + "|") == -1){
        			overlabCheck = false;
        			alert(alertPermit.replace("{0}", allowExtention.replace(/\|/g, ", ")));
        		}else if(blockExtention != "" && ("|" + blockExtention + "|").indexOf("|" + extsn.substring(1) + "|") > -1){
        			overlabCheck = false;
        			alert(alertLimit.replace("{0}", blockExtention.replace(/\|/g, ", ")));
        		}else if(extsn == -1){
        			overlabCheck = false;
        			alert(TX900000589);
        		}
        		
            }
            
            if (overlabCheck) {
            	
            	var fileId = "addFile_" + cntFile;
            	var fileSn = "0";
            	
            	f.fileId = fileId;
            	f.fileSn = fileSn;
            	
                attachFile.push(f);
                
                var pushData = {};
                pushData.fileDiv = "N";
   		     	pushData.fileId= fileId;
   		     	pushData.fileSn= fileSn;
		   		pushData.fileNm= ConvertSystemSourcetoHtml(f.name);
		   		pushData.filePath= f.filePath;
		   		pushData.fileSize= f.size;
		   		pushData.fileThumUrl= "";
		   		pushData.fileUrl= "";
		   		pushData.filePublicYn = "Y";
		   		
		   		Bindinglist.push(pushData);
		   		fnAppendFileInfo(cntFile, pushData);
		   		
		   		//rotateImgFileIsNotCorrect(f, Bindinglist, viewType);
		   		
		        if (f.name.match(/[^=(\"|\')]*(jpg|gif|jpeg|png)/i)) {

		            var reader = new FileReader();
		            reader.onload = (function (theFile) {
		                return function (e) {
		                	
		                	var resultFileInfo = Bindinglist.filter(function(x) { return x.fileId == theFile.fileId && x.fileSn == theFile.fileSn});
		                	
		                	if(resultFileInfo.length > 0){
		                		resultFileInfo[0].fileThumUrl = e.target.result;
		                		
		                		if(viewType == "Thumbnail"){
		                			$("[fileunit=Y][fileid="+theFile.fileId.replace(/\./g,'\\.')+"][filesn="+theFile.fileSn+"] [name=fileExtImg] img").attr("src", e.target.result);
		                		}
		                		
		                	}
		                	
		                };
		            })(f);
		            reader.readAsDataURL(f);
		        		}		   		
                
                cntFile++;
            	
          	}
        }
    }
    
    fnSetAllFileSize();
}

function fnChangePublicCheck(obj){
	
	var checkTarget = $(obj).parents("[fileunit=Y]");
	
	var fileId = checkTarget.attr("fileid");
	var fileSn = checkTarget.attr("filesn");
	
	var resultFileInfo = Bindinglist.filter(function(x) { return x.fileId == fileId && x.fileSn == fileSn});
	
	if(resultFileInfo.length > 0){
		resultFileInfo[0].filePublicYn = $(obj).is(":checked") ? "Y" : "N";
	}
	
}

function fnSetAllFileSize(){
	
	allFileSize = 0;
	attTotalSize = 0;
	
	var aliveBindingList = Bindinglist.filter(function(x) { return x.fileDiv != "D"});
	
	$.each(aliveBindingList, function (i, t) {
		
		if(isNumber(t.fileSize)){
			allFileSize += parseInt(t.fileSize);
			attTotalSize += parseInt(t.fileSize);
		}
		
	});

	allFileCnt = aliveBindingList.length;
	
	$("[name=allFileCnt]").html(allFileCnt);
	
	if(allFileCnt == 0){
		$("[name=allFileSize]").html("(0 KB)");
		attTotalSize = 0;
	}else{
		
		$("[name=allFileSize]").html("(" + byteConvertor(allFileSize) + ")");
	}
	
	fnFileSet();
	
	//리스트형 재정렬 
	if(viewType == "List"){
		fnListTypeRefreshArea();
		fnListTypeRefreshWidth();
	}else{
		fnRefreshSort();	
	}
}

function fnListTypeRefreshArea(){
	
	var areaIdx = 1;
	var rowIdx = 0;
	
    $.each(Bindinglist, function (i, t) {
    	
    	var fileUnit = $("[name=fileSetList] [fileunit=Y][fileid=" + t.fileId.replace(/\./g,'\\.') + "][filesn=" + t.fileSn + "]");
    	
    	if(fileUnit.length > 0){
    		
    		fileUnit.appendTo("[name=fileSetList] [name=fileSetListU" + areaIdx + "]");
    		rowIdx++;
    		
    		if(rowIdx == listRowCnt){
    			areaIdx++;
    			rowIdx = 0;
    		}
    		
    	}
    	
    });
    
    //empty area remove
    $.each($("[name=fileSetList] [name=dzDownloaderListUlModel]"), function (i, t) {
    	
    	if($(t).find("[fileunit=Y]").length == 0){
    		$(t).remove();
    	}
    	
    });
    
}

function fnListTypeRefreshWidth(){
	
	var fileSetListUlWidth = Math.floor($("#dzDownloaderDiv").width()/2) - 2;
	
	var fileSetListUl = $("[name=fileSetList] ul");
	
	fileSetListUl.width(fileSetListUlWidth);
	
	$("[name=fileSetList]").width(fileSetListUlWidth*fileSetListUl.length);
	
    $.each($("[name=fileSetList] [fileunit=Y]"), function (i, t) {
    	var fileNmWidth = fileSetListUlWidth;
    	var filePublicBtnWidth = $(t).find("[name=filePublicBtn]").width();
    	var fileExtWidth = $(t).find("[name=fileExt]").width();
    	var fileSizeWidth = $(t).find("[name=fileSize]").width();
    	var fileDelBtnWidth = 0;
    	
    	if($(t).find("[name=fileDelBtn]").length > 0){
    		fileDelBtnWidth = 65;
    	}else{
    		fileDelBtnWidth = 40;
    	}
    	
    	fileNmWidth = fileNmWidth - filePublicBtnWidth - fileExtWidth - fileSizeWidth - fileDelBtnWidth;
    	
    	$(t).find("[name=fileDownloadA]").css("max-width", fileNmWidth);
    	
    });	

}

function specialCharRemove(value) {
    var pattern = /[^(가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9)]/gi;   // 특수문자 제거
    return value.replace(pattern, "").replace(/\(/gi,"bk_l").replace(/\)/gi,"bk_r");
}

function handleDragOver(evt) { //파일첨부 드래그앤드랍
    attachMode = "drag";
    evt.stopPropagation();
    evt.preventDefault();
    evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
}

function fnAttachDown(){
	
	if(activeYn == "Y"){
		
		var activeFileUrl = selectedFileInfo.fileUrl;
		
		if(selectedFileInfo.fileUrl.toUpperCase().indexOf('http') < 0){
			activeFileUrl = window.location.protocol + "//" + location.host + selectedFileInfo.fileUrl;
		}
		
		goForm(activeFileUrl, loginId, resultFileInfo.fileNm);	    		
		
	}else{
		
		//selectedFileInfo.fileSn = "";
		
  		var moduleTp = "";
  		var fileId = selectedFileInfo.fileId;
  		var fileSn = selectedFileInfo.fileSn;
  		
  		if(selectedFileInfo.fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
  			fileId = getQueryVariable(selectedFileInfo.fileUrl, 'fileId');
  			fileSn = getQueryVariable(selectedFileInfo.fileUrl, 'fileSn');	    	

  			moduleTp = "gw";
	    	
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
			
    	}
    	else if(selectedFileInfo.fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
    		fileId = getQueryVariable(selectedFileInfo.fileUrl, 'fileId');
    		fileSn = getQueryVariable(selectedFileInfo.fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
    	}
    	
    	//게시판 url예외처리
    	else if(selectedFileInfo.fileUrl.indexOf("edms/board/downloadFile.do") != -1){
    		
      		//비세션일 경우 공통다운로드 경로 제공 불가(외부계정용)
      		if(loginVO == "" || loginVO == null){
      	  		this.location.href = selectedFileInfo.fileUrl;
      	        return false;  			
      		}
    		
    		moduleTp = "board";
    	}
    	
    	//문서 url예외처리
    	else if(selectedFileInfo.fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
    		
    		if(selectedFileInfo.fileUrl.indexOf("oldArtNo") != -1){
    			moduleTp = "doc_old";
    			fileSn = getQueryVariable(selectedFileInfo.fileUrl, 'oldArtNo');
    		}else{
    			moduleTp = "doc";	
    		}
    	}
    	
    	//문서 url예외처리
    	else if(selectedFileInfo.fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
    		moduleTp = "bpm";
    	}
  		
  		//그외는 gw다운로드로 통일
  		else{
  			fileId = getQueryVariable(selectedFileInfo.fileUrl, 'fileId');
  			fileSn = getQueryVariable(selectedFileInfo.fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
  		}
  		
  		this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=" + fileId + "&fileSn=" + fileSn + "&moduleTp=" + moduleTp + "&pathSeq=" + pathSeq;
        return false;	    		
		
	}
	
}



function fnDocViewerPop(fileUrl, fileNm, fileId){
	var fileSn = "";
	var moduleTp = "";
	
	if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
    	fileId = getQueryVariable(fileUrl, 'fileId');
    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
    	moduleTp = "gw";
		if(fileSn == "" || fileSn == null)
			fileSn = "0";
	}
	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
		fileId = getQueryVariable(fileUrl, 'fileId');
    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
    	moduleTp = "gw";
		if(fileSn == "" || fileSn == null)
			fileSn = "0";
	}
	
	//게시판 url예외처리
	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
		moduleTp = "board";
	}
	
	//문서 url예외처리
	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
		if(fileUrl.indexOf("oldArtNo") != -1){
			moduleTp = "doc_old";
			fileSn = getQueryVariable(fileUrl, 'oldArtNo');
		}else{
			moduleTp = "doc";	
		}		
	}
	
	//문서 url예외처리
	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
		moduleTp = "bpm";
	}
	
	var timestamp = new Date().getTime();
 	var docViewrPopForm = document.docViewrPopForm;
 	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
 	docViewrPopForm.action = "/gw/docViewerPop.do";
 	docViewrPopForm.target = "docViewerPop" + timestamp ;
 	docViewrPopForm.groupSeq.value = groupSeq;
 	docViewrPopForm.fileId.value = fileId;
 	docViewrPopForm.fileSn.value = fileSn;
 	docViewrPopForm.moduleTp.value = moduleTp;
 	docViewrPopForm.submit();
}

function fnInlineView(fileUrl, fileNm, fileId){
	
  	var fileSn = "";
	var moduleTp = "";
	
	if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
    	fileId = getQueryVariable(fileUrl, 'fileId');
    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
    	moduleTp = "gw";
		if(fileSn == "" || fileSn == null)
			fileSn = "0";
  	}
  	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
  		fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
  	}

  	//게시판 url예외처리
  	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
  		moduleTp = "board";
  	}
  	
  	//문서 url예외처리
  	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
  		
		if(fileUrl.indexOf("oldArtNo") != -1){
			moduleTp = "doc_old";
			fileSn = getQueryVariable(fileUrl, 'oldArtNo');
		}else{
			moduleTp = "doc";	
		}	
		
  	}
  	
  	//문서 url예외처리
  	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
  		moduleTp = "bpm";
  	}
	
	//그외는 gw다운로드로 통일
	else{
		fileId = getQueryVariable(fileUrl, 'fileId');
    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
    	moduleTp = "gw";
		if(fileSn == "" || fileSn == null)
			fileSn = "0";
	}
	
	var timestamp = new Date().getTime();
 	var docViewrPopForm = document.docViewrPopForm;
 	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=yes,menubar=no");
 	docViewrPopForm.action = "/gw/cmm/file/fileDownloadProc.do";
 	docViewrPopForm.target = "docViewerPop" + timestamp ;
 	docViewrPopForm.pathSeq.value = pathSeq;
 	docViewrPopForm.fileId.value = fileId;
 	docViewrPopForm.fileSn.value = fileSn;
 	docViewrPopForm.moduleTp.value = moduleTp;
 	docViewrPopForm.submit();		
}



function getQueryVariable(fileUrl, strPara) {
    var params = {};
    fileUrl.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str, key, value) { params[key] = value; });
    return params[strPara];
}   

function fnGetFileInfoFromId(fileId, fileSn){
	var resultFileInfo = Bindinglist.filter(function(x) { return x.fileId == fileId && x.fileSn == fileSn});
	
	if(resultFileInfo.length > 0){
		return resultFileInfo[0];
	}else{
		return null;
	}
}

function isNumber(s) {
  s += ''; // 문자열로 변환
  s = s.replace(/^\s*|\s*$/g, ''); // 좌우 공백 제거
  if (s == '' || isNaN(s)) return false;
  return true;
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

function getWithoutExtensionOfFilename(filename){
	var _lastDot = filename.lastIndexOf('.');
	
	if(_lastDot > -1){
		return filename.substring(0,_lastDot)
	}else{
		return filename;
	}
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
	var s = ['BYTE', 'KB', 'MB', 'GB', 'TB', 'PB'];
	var e = Math.floor(Math.log(bytes)/Math.log(1024));
	if(e == "-Infinity") return "0 "+s[0]; 
	else return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
}

//파일클래스
function fncGetFileClass(fileDiv, fileEx) {
	
	if(fileEx.indexOf('.') != -1){    	
		fileEx = fileEx.split('.')[fileEx.split('.').length-1]
	}
	else{
		return "file_etc";
	}
	
	if (fileEx.match(/[^=(\"|\')]*(jpg|gif|jpeg|png)/i)) {
		
		if(fileDiv == "A"){
			return "file_img2";
		}else{
			return "img";	
		}
		
	}
	
    var fileClass;

    //확장자정규식
    var expHwp = /hwp/i;
    var expZip = /zip/i;
    var expDoc = /doc|docx/i;
    var expPpt = /ppt|pptx/i;
    var expMp4 = /mp4/i;
    var expWav = /wav/i;
    var expWma = /wma/i;
    var expTif = /tif/i;
    var expGul = /gul/i;
    var expAi = /ai/i;
    var expPsd = /psd/i;
    var expHtm = /htm|html/i;
    var expFlv = /flv/i;
    var expMpg = /mpg/i;
    var expMpeg = /mpeg/i;
    var expAsf = /asf/i;
    var expMov = /mov/i;
    var expWmv = /wmv/i;
    var expPdf = /pdf/i;
    var expTxt = /txt/i;
    var expMp3 = /mp3/i;
    var expAvi = /avi/i;
    var expXls = /xls|xlsx/i;

    if (expHwp.test(fileEx)) {
        fileClass = "file_hwp";
    } else if (expZip.test(fileEx)) {
        fileClass = "file_zip";
    } else if (expDoc.test(fileEx)) {
        fileClass = "file_doc";
    } else if (expPpt.test(fileEx)) {
        fileClass = "file_ppt";
    } else if (expMp4.test(fileEx)) {
        fileClass = "file_mp4";
    } else if (expWav.test(fileEx)) {
        fileClass = "file_wav";
    } else if (expWma.test(fileEx)) {
        fileClass = "file_wma";
    } else if (expTif.test(fileEx)) {
        fileClass = "file_tif";
    } else if (expGul.test(fileEx)) {
        fileClass = "file_gul";
    } else if (expAi.test(fileEx)) {
        fileClass = "file_ai";
    } else if (expPsd.test(fileEx)) {
        fileClass = "file_psd";
    } else if (expHtm.test(fileEx)) {
        fileClass = "file_htm";
    } else if (expFlv.test(fileEx)) {
        fileClass = "file_flv";
    } else if (expMpg.test(fileEx)) {
        fileClass = "file_mpg";
    } else if (expMpeg.test(fileEx)) {
        fileClass = "file_mpeg";
    } else if (expAsf.test(fileEx)) {
        fileClass = "file_asf";
    } else if (expMov.test(fileEx)) {
        fileClass = "file_mov";
    } else if (expWmv.test(fileEx)) {
        fileClass = "file_wmv";
    } else if (expPdf.test(fileEx)) {
        fileClass = "file_pdf";
    } else if (expTxt.test(fileEx)) {
        fileClass = "file_txt";
    } else if (expAvi.test(fileEx)) {
        fileClass = "file_avi";
    } else if (expXls.test(fileEx)) {
        fileClass = "file_xls";
    } else {
        fileClass = "file_etc";
    }
    return fileClass;
}	   

function fncGetFileClassList(fileEx){
   	
	var fileClass;
	
   	if(fileEx.indexOf('.') != -1){    	
   		
   		fileEx = fileEx.split('.')[fileEx.split('.').length-1];
   		
        //확장자정규식
        var expBmp = /bmp/i;
        var expCsv = /csv/i;
        var expGif = /gif|gifx/i;
        var expHwp = /hwp/i;
        var expJpg = /jpg|jpeg/i;
        var expPdf = /pdf/i;
        var expPng = /png/i;
        var expTif = /tif/i;
        var expWord = /word|doc|docx/i;
        var expXls = /xls|xlsx/i;
        var expZip = /zip/i;
        var expPpt = /ppt|pptx/i;
        var expTxt = /txt/i;

        if (expBmp.test(fileEx)) {
            fileClass = "ico_bmp";
        } else if (expCsv.test(fileEx)) {
            fileClass = "ico_csv";
        } else if (expGif.test(fileEx)) {
            fileClass = "ico_gif";
        } else if (expHwp.test(fileEx)) {
            fileClass = "ico_hwp";
        } else if (expJpg.test(fileEx)) {
            fileClass = "ico_jpg";
        } else if (expPdf.test(fileEx)) {
            fileClass = "ico_pdf";
        } else if (expPng.test(fileEx)) {
            fileClass = "ico_png";
        } else if (expTif.test(fileEx)) {
            fileClass = "ico_tif";
        } else if (expWord.test(fileEx)) {
            fileClass = "ico_word";
        } else if (expXls.test(fileEx)) {
            fileClass = "ico_xls";
        } else if (expZip.test(fileEx)) {
            fileClass = "ico_zip";
        } else if (expPpt.test(fileEx)) {
            fileClass = "ico_ppt";
        } else if (expTxt.test(fileEx)) {
            fileClass = "ico_txt";
        } else {
            fileClass = "ico_etc";
        }   		
   		
   	}
   	else{
   		fileClass = "ico_etc";
   	}

   return fileClass;
    
}


function RndStr() {
    this.str = '';
    this.pattern = /^[a-zA-Z0-9]+$/;

    this.setStr = function (n) {
        if (!/^[0-9]+$/.test(n)) n = 0x10;
        this.str = '';
        for (var i = 0; i < n - 1; i++) {
            this.rndchar();
        }
    }

    this.setType = function (s) {
        switch (s) {
            case '1': this.pattern = /^[0-9]+$/; break;
            case 'A': this.pattern = /^[A-Z]+$/; break;
            case 'a': this.pattern = /^[a-z]+$/; break;
            case 'A1': this.pattern = /^[A-Z0-9]+$/; break;
            case 'a1': this.pattern = /^[a-z0-9]+$/; break;
            default: this.pattern = /^[a-zA-Z0-9]+$/;
        }
    }

    this.getStr = function () {
        return this.str;
    }

    this.rndchar = function () {
        var rnd = Math.round(Math.random() * 1000);

        if (!this.pattern.test(String.fromCharCode(rnd))) {
            this.rndchar();
        } else {
            this.str += String.fromCharCode(rnd);
        }
    }
}

// 익스플로러에서 모바일에서 촬영한 이미지 첨부시 회전하는 현상 수정 함수
// @author 김택주 연구원
// @Params {
//	files: 첨부된 이미지 파일
//	BindingList: 첨부파일 리스트
//  viewType: 섬네일, 자세히, 목록 구분 값
// }
//
function rotateImgFileIsNotCorrect(files, Bindinglist, viewType) {
	
    var reader = new FileReader();
    
    reader.onload = (function (theFile) {
        return function (e) {
        	        	
        	EXIF.getData( theFile, function(){

        	    var styleTransForm = '';
        	    
            	var resultFileInfo = Bindinglist.filter(function(x) { return x.fileId == theFile.fileId && x.fileSn == theFile.fileSn});
            	var agent = navigator.userAgent.toLowerCase();
            	
            	if((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)){
            		
            		var orientation = EXIF.getTag( theFile, "Orientation" );
            		
            		console.log( orientation );
            		
            		styleTransForm = setCssTransformFromOrientation(orientation);
            	}
        	    
        		if(viewType == "Thumbnail"){

        			var $jqueryObj = $("[fileunit=Y][fileid="+theFile.fileId.replace(/\./g,'\\.')+"][filesn="+theFile.fileSn+"] [name=fileExtImg] img");
        			$jqueryObj.attr("src", e.target.result);
        			$jqueryObj.css("transform", styleTransForm);

        		}
        	});
        };
    })(files);
    reader.readAsDataURL(files);	
}

// 익스플로러일 경우 이미지 파일 회전 보정
// @author 김택주 연구원
// @params {
//   orientation: 첨부한 이미지의 회전 정보 값
// }
function setCssTransformFromOrientation(orientation){
	
	switch( orientation ) {
	
		// @details 이미지 회전값이 0인경우 ( 정방향 )
		case 1 :
			return "rotate( 0deg )";
			
			// @details 이미지 회전값이 180 기운 경우
		case 3 :
			return "rotate( 180deg )";
			
			// @details 이미지 회전값이 270 기운 경우 ( 왼쪽으로 90 기운 경우 )
		case 6 :
			return "rotate( 90deg )";
			
			// @details 이미지 회전값이 90 기운 경우
		case 8 :
			return "rotate( 270deg )";
			
		default:
			return '';
	}
}
