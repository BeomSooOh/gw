/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dze_ext_uploader.js -	내/외부 업로드 기능 처리
// 
// dze_ui_config.js 에서 bUseImageExtUpload 값을 true로 설정할 경우 업로드 시 아래의 함수들이 수행됨.
//						
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


var g_objExtUploader = new function() {

	var nEditNumber = 0;
	var dze_ext_upload_list = [];
	var dze_allow_upload_file_extension = ["gif","jpg","jpeg","png","bmp"];
	
	
	// 여러 이미지들을 한번에 삽입할 때 사용되는 함수 : Drag & Drop 삽입
	this.initWithUploadList = function(nEditNumber, uploadList) {
//		console.log(nEditNumber+"] UploadList Count - "+uploadList.length);

		nEditNumber = nEditNumber;
		dze_ext_upload_list = uploadList;
		
		g_objExtUploader.onStartUploadList();
	};
	
	this.onStartUploadList = function() {
//		console.log("onStartUploadList");
		
		try {
			if(dze_ext_upload_list.length > 0) {

				var xhr = new XMLHttpRequest();
				xhr.open("POST", dzeEnvConfig.strUploadImageURL, true);

				//60초동안 응답 없으면 중단
				var xhrTimer = setTimeout(function() {
					try
					{
						xhr.abort();
//						console.log("xhr timeout");
						return;
					}
					catch (e) {
//						console.log("xhrTimer Error: "+e);
					}
				}, 60000);

				xhr.onload = function() {

					clearTimeout(xhrTimer);

					var result = this.responseText;
//					console.log("file upload result: "+result);

					var resultData = duzon_http.parseJSON(result);
					if(resultData.result != "success") {
						alert(ID_RES_DIALOG_ALERT_UPLOAD_ERROR);
						return;
					}

					//에디터에 이미지 삽입
					var imgHtml = "<img src='"+resultData.url+"' />";
					dragDropInsertHTML(imgHtml, nEditNumber);

					//업로드 성공 기록
					DZE_UPLOAD_EVENT.setComplete(nEditNumber, resultData);
					g_objUndoRedo.registerUndoRedoStack(0, nEditNumber);

					//남은 파일 재 전송
					g_objExtUploader.onStartUploadList();

				};
				xhr.onerror = function() {
					clearTimeout(xhrTimer);
//					console.log("xhr Error");
				};


//				console.log("type:"+typeof(dze_ext_upload_list));

				var destFile = dze_ext_upload_list.shift();

//				console.log("destFile------------");
//				console.log("업로드 할 파일 개수2 : "+dze_ext_upload_list.length);

				var fileExt = destFile.name.split(".").pop().toLowerCase();
				if(!inArray(fileExt,dze_allow_upload_file_extension)) {
					try
					{
						clearTimeout(xhrTimer);
						xhr.abort();
						alert("\"" + destFile.name + "\" " + ID_RES_CONST_STRING_CANNOT_UPLOAD_FILE_TYPE + " "+dze_allow_upload_file_extension.join(", "));
						return;
					}
					catch (e) {
//						console.log("onStartUploadItem Error: "+e);
					}
				}

				var formData = new FormData();
				formData.append("dze_upimage_file", destFile);
				formData.append("type", "dnd_upload_image");
				xhr.send(formData);
			}
		} catch(e) {
//			console.log("onStartUploadList error: "+e);
		}
	};
	
	
	// 단일 이미지 업로드 시 사용되는 함수 : 파일 경로로 업로드
	this.initWithUploadItem = function(uploadForm, isBackground) {
		try {
			if(typeof(isBackground) === "undefined")
				var isBackground = false;

			if(isBackground) {
				var iframeObj = g_objLayerKit.getElementById("ifrmImageFileUploadTarget");
				if(iframeObj.attachEvent) {
					iframeObj.attachEvent("onload", g_objExtUploader.onStartUploadItemForBGImage);
				} else {
					iframeObj.addEventListener("load", g_objExtUploader.onStartUploadItemForBGImage);
				}
			}
			else
			{
				//upload iframe 에 onload 이벤트리스너 등록
				var iframeObj = g_objLayerKit.getElementById("idx_dze_upload_iframe");

				if(iframeObj.attachEvent) {
					iframeObj.attachEvent("onload", g_objExtUploader.onStartUploadItem);
				} else {
					iframeObj.addEventListener("load", g_objExtUploader.onStartUploadItem);
				}
			}

			uploadForm.submit();
			
		} catch(e) {
//			console.log("initWithUploadItem Error: "+e);
		}
	};
	
	this.onStartUploadItem = function() {
		try
		{
			var dlg = GetOpendImageInsertDlg();	//UCDOC-1324, 이미지 삽입
			if(!dlg) return;

			var textDoc	= g_objLayerKit.getElementById(dlg.idx_dze_upload_iframe).contentWindow.document.body.innerHTML;

			var resultData = duzon_http.parseJSON(textDoc);
			if(resultData.result != "success") {
				alert(ID_RES_DIALOG_ALERT_UPLOAD_ERROR);

				if(dlg.callback)
				{
					dlg.callback(false);
					dlg.callback = null;
				}
				return;
			}

			//업로드 성공 기록
			DZE_UPLOAD_EVENT.setComplete(duzon_dialog.nEditNumber, resultData);

			// url
			var urls = Array.isArray(resultData.url) ? resultData.url : [resultData.url];
			var filenames = Array.isArray(resultData.filename) ? resultData.filename : [resultData.filename];

			var images = dlg.arrImgFromFile;
			if(!urls || !images || images.length !== urls.length)
			{
				dalert("");	//UCDOC-1324, 이미지 삽입
			}
			
			var len = Math.min(images.length, urls.length);

			for(var i = 0; i < len; i++)
			{
				if(images[i] && urls[i])
				{
					images[i].src = urls[i];	//서버에 업로드한 url 값으로 src 변경 (UCDOC-1324)
				}
			}

			if(dlg.callback)
			{
				dlg.callback(true);
				dlg.callback = null;
			}
		}
		catch (e)
		{
			dalert(e);
//			console.log("onStartUploadItem Error: "+e);
		}
	};
	
	// 배경 이미지 업로드 시 호출되는 함수
	this.onStartUploadItemForBGImage = function() {
		try
		{
			var textDoc = g_objLayerKit.getElementById("ifrmImageFileUploadTarget").contentWindow.document.body.innerHTML;

			var resultData = duzon_http.parseJSON(textDoc);
			if(resultData.result != "success") {
				alert(ID_RES_DIALOG_ALERT_UPLOAD_ERROR);
				g_strBackgroundImageURL = null;
				return;
			}

			g_strBackgroundImageURL = resultData.url;
			g_objLayerKit.getElementById("txtReadBackgroundImageURL").value = resultData.url;
		}
		catch(e)
		{
			g_strBackgroundImageURL = null;
			g_objLayerKit.getElementById("txtReadBackgroundImageURL").value = "";

//			console.log("onStartUploadItemForBGImage Error: "+e);
		}
	};
	
	// 클립보드 이미지를 복사하여 붙여넣는 경우 호출되는 함수
	this.pasteImageFromClipboard = function(evnt, nEditNumber) {
//		console.log("---pasteImageFromClipboard start-----");

		try
		{
			if(window.addEventListener) {
				//IE
				if(g_bBrowserType_IE || g_bBrowserType_FF) {
//					console.log("---IE-FF----");

					//시간차 실행해야 에디터에 삽입된 내용을 정상적으로 가져올 수 있으므로 setTimeout 을 사용한다.
					setTimeout(function() {
						//에디터에 삽입된 내용중 img 를 검사한다.
						var srcData = g_objEditorDocument[nEditNumber].body.getElementsByTagName("img");

						for(var i = 0; i < srcData.length; i++) {
							//src 경로가 data:image 로 시작하면 이미지소스이므로 캐치하여 POST로 전송(업로딩) 한다.
							var Exp = /^data:image\/png;base64,/i;
							if ( Exp.test( srcData[i].src ) ) {
//								console.log(srcData[i].src);

								var xhr = new XMLHttpRequest();
								xhr.open("POST", dzeEnvConfig.strSavePasteImageURL,true);

								xhr.onload = function() {
									var textDoc = this.responseText;
//									console.log("file upload result: "+textDoc);

									var resultData = duzon_http.parseJSON(textDoc);
//									console.log(resultData);

									if(resultData.result == "success") {
										resultData.url = getFullUrlFromPath(resultData.url);
										srcData[i].src = resultData.url;

										//업로드 성공 기록
										DZE_UPLOAD_EVENT.setComplete(nEditNumber, resultData);
										g_objUndoRedo.registerUndoRedoStack(0, nEditNumber);
									}
								};

								xhr.onerror = function() {
									   alert("Error");
								};

								// prepare FormData
								var formData = new FormData();
								formData.append("dze_upimage_data", srcData[i].src);
								xhr.send(formData);

								break;
							}
						}
					},0);
				}
				else if(g_bBrowserType_WK || g_bBrowserType_OP)	//Others
				{
					//클립보드 데이터 가져오기
					var pastedText = "";
					if (evnt.clipboardData && evnt.clipboardData.getData) {
						pastedText = evnt.clipboardData.getData('text/plain');
					}

//					console.log("---pastedText-----");
//					console.log(pastedText);

					//pastedText 에 값이 있는경우는 클립보드에 이미지외 다른 텍스트가 존재하는경우이므로 이 경우는 제외 (순수한 이미지만 있는경우 붙여넣기 실행)
					if(pastedText !== "") {
						
						//이미지 삽입 후 잘못된 이미지 경로는 제거
						//시간차 실행해야 에디터에 삽입된 내용을 정상적으로 가져올 수 있으므로 setTimeout 을 사용한다.
						setTimeout(function() {
								//에디터에 삽입된 내용중 img 를 검사한다.
								var srcData = g_objEditorDocument[nEditNumber].body.getElementsByTagName("img");

								for(var i = 0; i < srcData.length; i++) {
									//src 경로가 file:// 로 시작하면 이미지소스 제거
									var Exp = /^file:\/\//i;
									if ( Exp.test( srcData[i].src ) ) {
										srcData[i].parentNode.removeChild(srcData[i]);
									}
								}
						},0);

						return;
					}

					
					//--- 클립보드 이미지 서버로 전송 시작
					var xhr = new XMLHttpRequest();
					xhr.open("POST", dzeEnvConfig.strSavePasteImageURL,true);

					xhr.onload = function() {
						var textDoc = this.responseText;
//						console.log("file upload result: "+textDoc);

						var resultData = duzon_http.parseJSON(textDoc);
//						console.log(resultData);

						if(resultData.result == "success") {
							resultData.url = getFullUrlFromPath(resultData.url);
							var imgHtml = "<img src='"+resultData.url+"' />";
							addHTMLContent(imgHtml, null, 0, nEditNumber);

							//업로드 성공 기록
							DZE_UPLOAD_EVENT.setComplete(nEditNumber, resultData);
							g_objUndoRedo.registerUndoRedoStack(0, nEditNumber);
						}
					};
					xhr.onerror = function() {
							alert("Error");
					};

					//클립보드 이미지 읽기
					var items = (evnt.clipboardData  || evnt.originalEvent.clipboardData).items;

					var blob = null;
					for (var i = 0; i < items.length; i++) {
						if (items[i].type.indexOf("image") === 0) {
							blob = items[i].getAsFile();
						}
					}
					if (blob !== null) {
//						console.log("blob isgood");

						var reader = new FileReader();
						reader.onload = function(evnt) {
							var formData = new FormData();
							formData.append("dze_upimage_data", evnt.target.result);
							xhr.send(formData);
						};
						
						reader.readAsDataURL(blob);
					}
				}
			}

//			console.log("---pasteImageFromClipboard End-----");
		}
		catch(e)
		{
//			console.log("pasteInsertImageFromClipboard error: "+e);
		}
	};
	
	
	
	/* Util Function */
	
	this.getFullUrlFromURL = function(path) {
		try {
			var url = "";
			if (path.indexOf("http://") == 0 || 
				path.indexOf("https://") == 0 || 
				path.indexOf("//") == 0) {
			  url = path;
			} else {
				if(path.indexOf("/") == 0) {
					url = document.location.origin + path;
				} else {
					url = document.location.href.substring(0, location.href.lastIndexOf('/')) + "/" + path;
				}
			}	
			return url;
		} catch(e) {
//			console.log("getFullUrlFromURL error: "+e);
		}
	};
	
};