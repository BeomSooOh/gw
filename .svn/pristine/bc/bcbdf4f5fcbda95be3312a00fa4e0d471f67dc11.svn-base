/*************************************************************************************
 *                     onefficeMGW :: Oneffice Mobile GW                             *
 *************************************************************************************/
var onefficeMGW = {
    //Prop
	// 1: 최근, 2: 중요, 3: 공유, 9 : 휴지통
    getFileList:function(getFolderSeq, listType, nBrowserMode, searchStr, requestCallback, searchStorage, listCount, bShowLoading) {
		try {
			if(typeof(listType) === "undefined") {
				var listType = "";
			}
			if(typeof(nBrowserMode) === "undefined") {
				var nBrowserMode = "";
			}
			if(typeof(searchStr) === "undefined") {
				var searchStr = "";
			}
			if(typeof(searchStorage) === "undefined") {
				var searchStorage = "myoneffice";
			}
			if(typeof(listCount) === "undefined") {
				var listCount = 50;
			}
			
			if (fnObjectCheckNull(bShowLoading) === true) {
				bShowLoading = true;
			}
			
			oneffice.onLoadListToServer = true;

			switch(nBrowserMode) 
			{
			case CLOUD_CONST_BROWSER_MODE_RECENT/*1*/:		// 최근
			{
				
//				var njson = { 
//						"header":{ 
//					           "token":mobile_http.hybridBaseData.header.token,
//					           "mobileId":mobile_http.hybridBaseData.header.mobileId,
//					           "loginId":mobile_http.hybridBaseData.header.loginId,
//					           "appType":mobile_http.hybridBaseData.header.appType,
//					           "osType":mobile_http.hybridBaseData.header.osType,
//					           "tId":mobile_http.hybridBaseData.header.tId,
//					           "pId":"P544"
//					        },
//					        "body":{ 
//					        	 "list_count":listCount
//					        },
//					        "companyInfo":{ 
//					           "compSeq": mobile_http.hybridBaseData.companyInfo.compSeq,
//					           "bizSeq": mobile_http.hybridBaseData.companyInfo.bizSeq,
//					           "deptSeq": mobile_http.hybridBaseData.companyInfo.deptSeq
//					        }
//						};
//				var strnjson = JSON.stringify(njson);
//				alert(strnjson);
//				$.ajax({
//			        type : 'GET',
//			        url : ONEFFICE_SERVER_API_GET_RECENT_DOCUMENT_LIST,
//			        data : { 
//				        "header":{ 
//				           "token":mobile_http.hybridBaseData.header.token,
//				           "mobileId":mobile_http.hybridBaseData.header.mobileId,
//				           "loginId":mobile_http.hybridBaseData.header.loginId,
//				           "appType":mobile_http.hybridBaseData.header.appType,
//				           "osType":mobile_http.hybridBaseData.header.osType,
//				           "tId":mobile_http.hybridBaseData.header.tId,
//				           "pId":"P544"
//				        },
//				        "body":{ 
//				        	 "list_count":listCount
//				        },
//				        "companyInfo":{ 
//				           "compSeq": mobile_http.hybridBaseData.companyInfo.compSeq,
//				           "bizSeq": mobile_http.hybridBaseData.companyInfo.bizSeq,
//				           "deptSeq": mobile_http.hybridBaseData.companyInfo.deptSeq
//				        }
//			        },
//					dataType: "json",
//					contentType:"application/json",
//			        success : function (data) {
//			            if (data) {
//			                alert("SUCCES"); 
//			            } else {
//			                alert("NOT DATA");
//			            }             
//			        },
//			        error : function(e){
//			        	
//			        	alert("errorCode : "+JSON.stringify(e))
//			        }
//
//
//			    });
				
				mobile_http.ajax({
					type: "get",
					url: ONEFFICE_SERVER_API_GET_RECENT_DOCUMENT_LIST,
					async: true,
					data: {"list_count":listCount},
					dataType: "json",
					timeout: 30000,
					pid: "P544",
					loading_screen: bShowLoading,
					loading_image_url: "",
					loading_image_size: [],
					success: function(responseData) {
						oneffice.onLoadListToServer = false;
						
						if (responseData === null || responseData.result !== "success") {
							onefficeMGW.onErrorCheckSession(function() {
								mobileToast.show("GET_RECENT_DOCUMENT_LIST_FAIL");
							});
							
							return;
						}
						var contentList = onefficeMGW.arrangNewRecentDataToContentList(responseData.data);
						//var contentList = onefficeMGW.convertDataToContentList();
						
						if (typeof(requestCallback) === "function") {
							requestCallback(contentList);
						}
					},
					error: function(e) {
						oneffice.onLoadListToServer = false;
						
						checkNetworkStatus();
						
						dalert(e);
					}
				});
			}
				break;
			case CLOUD_CONST_BROWSER_MODE_FAVORITE/*2*/:		// 중요
			{
				mobile_http.ajax({
					type: "get",
					url: ONEFFICE_SERVER_API_GET_IMPORTANTDOCUMENT_LIST,
					async: true,
					data: "",
					dataType: "json",
					timeout: 30000,
					pid:"P541",
					loading_screen: bShowLoading,
					loading_image_url: "",
					loading_image_size: [],
					success: function(responseData) {
						oneffice.onLoadListToServer = false;
						
						if (responseData === null || responseData.result !== "success") {
							onefficeMGW.onErrorCheckSession(function() {
								mobileToast.show("GET_IMPORTANTDOCUMENT_LIST_FAIL");
							});
							
							return ;
						}
						
						var contentList = onefficeMGW.convertDataToContentList(responseData.data);
						
						if (typeof(requestCallback) === "function") {
							requestCallback(contentList);
						}
					},
					error: function(e) {
						oneffice.onLoadListToServer = false;
						
						checkNetworkStatus();
						
						dalert(e);
					}
				});
			}
				break;
			case CLOUD_CONST_BROWSER_MODE_SHARE/*3*/:		// 공유
			case CLOUD_CONST_BROWSER_MODE_MY_SHARE_LIST:
			case CLOUD_CONST_BROWSER_MODE_SHARED_BY_LIST:
			{
				mobile_http.ajax({
					type: "get",
					url: ONEFFICE_SERVER_API_GET_SHARE_DOCUMENT_LIST,
					async: true,
					data: {},
					dataType: "json",
					timeout: 30000,
					pid: "P548",
					loading_screen: bShowLoading,
					loading_image_url: "",
					loading_image_size: [],
					success: function(responseData) {
						oneffice.onLoadListToServer = false;
						
						if (responseData === null || responseData.result !== "success") {
							onefficeMGW.onErrorCheckSession(function() {
								mobileToast.show("GET_SHARE_DOCUMENT_LIST_FAIL");
							});
							
							return ;
						}
						
						var contentList = onefficeMGW.convertDataToContentList(responseData.data);
						
						if (typeof(requestCallback) === "function") {
							requestCallback(contentList);
						}
					},
					error: function(e) {
						oneffice.onLoadListToServer = false;
						
						checkNetworkStatus();
						
						dalert(e);
					}
				});
			}
				break;
			case CLOUD_CONST_BROWSER_MODE_SECURITY/*4*/:		// 보안
			{
				mobile_http.ajax({
					type: "get",
					url: ONEFFICE_SERVER_API_GET_SECURITYDOCUMENT_LIST,
					async: true,
					data: "",
					dataType: "json",
					timeout: 30000,
					pid:"P546",
					loading_screen: bShowLoading,
					loading_image_url: "",
					loading_image_size: [],
					success: function(responseData) {
						oneffice.onLoadListToServer = false;
						
						if (responseData === null || responseData.result !== "success") {
							onefficeMGW.onErrorCheckSession(function() {
								mobileToast.show("GET_SECUITYDOCUMENT_LIST_FAIL");
							});
							
							return ;
						}
						
						var contentList = onefficeMGW.convertDataToContentList(responseData.data);
						
						if (typeof(requestCallback) === "function") {
							requestCallback(contentList);
						}
					},
					error: function(e) {
						oneffice.onLoadListToServer = false;
						
						checkNetworkStatus();
						
						dalert(e);
					}
				});
			}
				break;
			case CLOUD_CONST_BROWSER_MODE_TRASHBOX/*9*/:		// 휴지통
			{
				mobile_http.ajax({
					type: "get",
					url: ONEFFICE_SERVER_API_GET_TRASH_LIST,
					async: true,
					data: "",
					dataType: "json",
					timeout: 30000,
					pid:"P550",
					loading_screen: bShowLoading,
					loading_image_url: "",
					loading_image_size: [],
					success: function(responseData) {
						oneffice.onLoadListToServer = false;
						
						if (responseData === null || responseData.result !== "success") {
							onefficeMGW.onErrorCheckSession(function() {
								mobileToast.show("GET_TRASH_LIST_FAIL");
							});
							
							return ;
						}
						
						var contentList = onefficeMGW.convertDataToContentList(responseData.data);
						
						if (typeof(requestCallback) === "function") {
							requestCallback(contentList);
						}
					},
					error: function(e) {
						oneffice.onLoadListToServer = false;
						
						checkNetworkStatus();
						
						dalert(e);
					}
				});
			}
				break;
			default:	// 클라우드 CLOUD_CONST_BROWSER_MODE_MYONEFFICE, CLOUD_CONST_BROWSER_MODE_SEARCH_RESULT, CLOUD_CONST_BROWSER_MODE_UNIFIED_SEARCH
			{
				if(searchStr && searchStr.length > 0) {
					mobile_http.ajax({
						type: "get",
						url: ONEFFICE_SERVER_API_GET_SEARCH_DOCUMENT_LIST,
						async: true,
						data: {"keyword":searchStr, "storage":searchStorage},	// 통합 검색이 진행되면 share 폴더 요청 가능
						dataType: "json",
						timeout: 30000,
						pid: "P545",
						loading_screen: bShowLoading,
						loading_image_url: "",
						loading_image_size: [],
						success: function(responseData) {
							oneffice.onLoadListToServer = false;
							
							if (responseData === null || responseData.result !== "success") {
								onefficeMGW.onErrorCheckSession(function() {
									mobileToast.show("GET_SEARCH_DOCUMENT_LIST_FAIL");
								});
								
								return ;
							}

							var contentList = onefficeMGW.convertDataToContentList(responseData.data);

							if(typeof(requestCallback) === "function")
								requestCallback(contentList);
						},
						error: function(e) {
							oneffice.onLoadListToServer = false;
							
							checkNetworkStatus();
							
							dalert(e);
						}
					});
				} 
				else 
				{
					mobile_http.ajax({
						type: "get",
						url: ONEFFICE_SERVER_API_GET_DOCUMENT_LIST,
						async: true,
						data: {"folder_no":getFolderSeq},
						dataType: "json",
						timeout: 30000,
						pid: "P539",
						loading_screen: bShowLoading,
						loading_image_url: "",
						loading_image_size: [],
						success: function(responseData) {
							oneffice.onLoadListToServer = false;
							
							if (responseData === null || responseData.result !== "success") {
								onefficeMGW.onErrorCheckSession(function() {
									// [lsg] oneffice.do로 접근할 경우, redirect 처리까지 임시로 에러 출력 제한
									if (document.location.href.indexOf(oneffice.drivePath) > 0) {
										mobileToast.show("GET_DOCUMENT_LIST_FAIL");
									}
								});
								
								return ;
							}
							
							var contentList = onefficeMGW.convertDataToContentList(responseData.data, listType);
							
							if (typeof(requestCallback) === "function") {
								requestCallback(contentList);
							}
						},
						error: function(e) {
							oneffice.onLoadListToServer = false;
							
							checkNetworkStatus();
							
							dalert(e);
						}
					});
				}
			}
				break;
			}
		} catch(e) {
			dalert(e);
		}
	},
	
	getMyInfo: function (requestCallback, bErrorCheck) {
		try {
			if (typeof (bErrorCheck) == "undefined") {
				var bErrorCheck = true;
			}

			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_MY_INFO,
				async: true,
				data: {},
				dataType: "json",
				timeout: 30000,
				pid: "P542",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				bShowLoading: false,
				success: function (responseData) {
					if (bErrorCheck === true) {
						if (responseData === null || responseData.result !== "success") {
							onefficeMGW.onErrorCheckSession(function () {
								mobileToast.show("GET_MY_INFO_FAIL");
							});
							
							return;
						}
					}
					
					//---- 전체 Y로 변경 (20181205)
					//responseData.data.report_yn = "Y";
					
					if (typeof (requestCallback) === "function") {
						requestCallback(responseData.data);
					}
				},
				error: function (e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch (e) {
			dalert(e);
		}
	},

	setAccessDocument: function(fileSeq, accessPerm, accessStatus, accessTime, requestCallback) {
		try {
			var asyncMode = (accessStatus === "0") ? false : true;
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_ACCESS_DOCUMENT,
				async: asyncMode,
				data: {"doc_no":fileSeq, "access_perm":accessPerm, "access_status":accessStatus, "sess_time":accessTime},
				dataType: "json",
				timeout: 30000,
				pid: "P524",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				bShowLoading: false,
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						oneffice.onErrorCheckSession(function(){
							cmnCtrlToast.showToastMsg(null, "POST_ACCESS_DOCUMENT_FAIL", 2, "screen_center");	
						});
						return ;
					}

					if(typeof(requestCallback) === "function")
						requestCallback(responseData.data);
				},
				error: function (e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch (e) {
			dalert(e);
		}
	},

	arrangNewRecentDataToContentList: function(data, listType)   {
		try {
			var contentList = [];

			for(var i = 0 ; i < data.length ; i++) 
			{
				var content = onefficeCommon.convertDataToContent(data[i]);

				if(listType == "folder" && content.type != "0") continue;
				if(listType == "file" && content.type != "1") continue;
				if(content.security_key.length > 1 || parseInt( content.security_key, 10) > 0 ) {
					content.security_key = 1;
				} else {
					content.security_key = 0;
				}

				if(listType == "folder" && content.type != "0") continue;
				if(listType == "file" && content.type != "1") continue;

				const found = contentList.find(tempcontent => tempcontent.seq === content.seq)

				if (listType === "1") {
					if (content.owner_id != oneffice_cloud_myInfoData.id) {
						continue;
					}
				}

				if (listType === "2") {
					if (content.owner_id == oneffice_cloud_myInfoData.id) {
						continue;
					}

				}

				//중복 Doc_no 제거
				if (found && (listType === 1 || listType === 0)) {
					if (found.share_count == 0 && content.share_count > 0)
					{
						console.log("found" + found);
						const idx = contentList.indexOf(found);
						if (idx > -1) {
							contentList.splice(idx, 1);
							contentList.push(content);			
						}
					}					
					continue;
				}
				
				contentList.push(content);
			}

			return contentList;
		} catch(e) {
			dalert(e);
		}
	},

    convertDataToContentList: function(data, listType) {
		try {
			var contentList = [];

			for (var i = 0 ; i < data.length ; i++) {
				var content = onefficeMGW.convertDataToContent(data[i]);
				
				if(listType == "folder" && content.type != "0") continue;
				if(listType == "file" && content.type != "1") continue;

				const found = contentList.find(tempcontent => tempcontent.doc_no === content.doc_no)

				if (found) {
					console.log("found" + found);
				}
				
				contentList.push(content);
			}
			
			return contentList;
		} catch(e) {
			dalert(e);
		}
	},
	
	convertDataToContent: function(data) {
		try {
			if (typeof(data.doc_no) === "undefined") {
				// doc_no가 없는 경우는 다른 무엇도 의미가 없으므로...
				return null;
			}
			
			var content = onefficeMGW.newFileContent();
			var date = new Date();
			
			content.seq = data.doc_no;
			content.type = (data.doc_type) ? data.doc_type : 0;
			content.folderSeq = (data.folder_no) ? data.folder_no : "";
			content.regdate = (data.reg_date) ? data.reg_date : date.getTime();
			content.subject = (data.doc_name) ? data.doc_name : "";
			content.content = (data.content) ? data.content : "";
			content.content_size = (data.content_size) ? data.content_size : 0;
			content.owner_id = (data.owner_id) ? data.owner_id : "";
			content.owner_login_id = (data.owner_login_id) ? data.owner_login_id : "";
			content.owner_name = (data.owner_name) ? data.owner_name : "";
			content.owner_org_id = (data.owner_org_id) ? data.owner_org_id : "";
			content.owner_org_name = (data.owner_org_name) ? data.owner_org_name : "";
			content.keyword = (data.keyword) ? data.keyword : "";
			content.readonly = (data.readonly) ? data.readonly : 0;
			content.moddate = (data.mod_date) ? data.mod_date : date.getTime();
			content.accessdate = (data.access_date) ? data.access_date : date.getTime();
			content.important = (data.important) ? data.important : 0;
			content.deleted = (data.deleted) ? data.deleted : "";
			
			// share attribute
			if (fnObjectCheckNull(data.share_count) === false) {
				content.share_count = data.share_count;
			} else if (fnObjectCheckNull(data.share_date) === false) {
				// share count는 리턴 data에 포함되지 않음
				// share_data가 있는 경우 공유문서이기 때문에 share count에 최소값 적용
				content.share_count = 1;
			} else {
				content.share_count = 0;
			}
			
//			if (content.share_count * 1 > 0) {
//				// share count가 1 이상이면 share info 다시 가져옴
//				onefficeMGW.getShareInfo(content.seq, function(arrData) {
//					var objShareInfo;
//					
//					arrData.forEach(function(objData) {
//						objShareInfo = {
//							share_date: objData.share_date,
//							share_id: objData.share_id,
//							share_perm: objData.share_perm,
//							share_type: objData.share_type
//						};
//						
//						content.share_data.push(objShareInfo);
//					});
//				}, false);
//			} else {
//				// share count가 0이면 share_data를 채울 필요 없음
//			}
			
			content.my_id = (data.my_id) ? data.my_id : "";
			content.security_key = (data.security_key) ? data.security_key : 0;
			content.strThumbnail = (data.thumbnail && data.thumbnail.length) ? data.thumbnail : "";
			
			// pass
			content.mobile_gateway_url	= data.mobile_gateway_url;
			content.gw_url				= data.gw_url;
			
			return content;
		} catch(e) {
			dalert(e);
		}
	},
	
	newFileContent: function() {
		try {
			return {
				"type": 1,	// doc_type
				"seq" : "",	// doc_no
				"folderSeq": "",	// folder_no
				"subject" : "",	// doc_name
				"content": "",	// content
				"content_size": 0,	// content_size
				"owner_id": "",	// owner_id
				"owner_login_id": "",	// owner_login_id
				"owner_name": "",	// owner_name
				"owner_org_id": "",	// owner_org_id
				"owner_org_name": "",	// owner_org_name
				"keyword": "",	// keyword
				"readonly": 0,	// readonly
				"regdate": "",	// reg_date
				"moddate": "",	// mod_date
				"accessdate": "",	// access_date
				"important": 0,	// important
				"deleted": 0,		// deleted
				"share_count": "",	// share_count
				"share_data": [],	// share_data	share_count에 따라 문서의 share info를 다시 가져와서 데이터 채움
				"security_key": "0",	// security_key
				"strThumbnail" : ""	//thumbnail
			};
		} catch(e) {
			dalert(e);
		}
	},
	
	getFolderContent: function(folderSeq, requestCallback, bAsync) {
		try {
			if (fnObjectCheckNull(bAsync) === true) {
				bAsync = true;
			}
			
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_GET_DOCUMENT,
				async: bAsync,
				data: {"doc_no":folderSeq},
				dataType: "json",
				timeout: (bAsync === true) ? 30000 : 5000,
				pid: "P536",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_FOLDER_CONTENT_FAIL");
						});
						
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(onefficeMGW.convertDataToContent(responseData.data));
					}
				},
				error: function(e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getFolderPathInfo: function(folderArray, folderSeq, requestCallback) {
		try {
			var folderPathArray = folderArray;

			if(folderSeq != "") {
				onefficeMGW.getFolderContent(folderSeq, function(responseData){
					var folderInfo = responseData;

					folderPathArray.unshift([folderInfo.seq,folderInfo.subject]);

					if(folderInfo.folderSeq == "") {
						
						folderPathArray.unshift(["","MY ONEFFICE"]);
						
						if(typeof(requestCallback) === "function")
							requestCallback(folderPathArray);
					} else {
						onefficeMGW.getFolderPathInfo(folderPathArray, folderInfo.folderSeq, requestCallback);
					}
				});
			} else {
				folderPathArray.push(["","MY ONEFFICE"]);
				if(typeof(requestCallback) === "function")
					requestCallback(folderPathArray);
			}
		} catch(e) {
			dalert(e);
		}
	},
	
	checkCreateFolderName: function(strFolderName, strFolderSeq, fnCallback) {
		try {
			if (strFolderName == "") {
				mobileToast.show("폴더명을 입력해주세요.");
				
				return false;
			}
			
			switch (oneffice_cloud_currFolderSeq * 1) {
				case 12003:			// 공유문서함
				case 12016:			// 공유한 문서
				case 12017:			// 공유받은 문서
				case 12002:			// 중요문서함
				case 12004:			// 보안문서함
				case 12009:			// 휴지통
				case 12010:			// 검색?
				case 12011:			// 통합검색?
					strFolderSeq = "";
					
					break;
			}
			
			onefficeMGW.createFolderContent(strFolderSeq, strFolderName, function() {
				if (fnObjectCheckNull(fnCallback) === false && typeof(fnCallback) === "function") {
					fnCallback(strFolderSeq);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	createFolderContent: function(folderSeq, folderName, requestCallback, errorCallback) {
		try {
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_CREATE_FOLDER,
				async: true,
				data: {"folder_no":folderSeq, "doc_name":folderName},
				dataType: "json",
				timeout: 30000,
				pid: "P530",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("POST_CREATE_FOLDER_FAIL");
						});
						
						return ;
					}
					
					oneffice.m_bFolderChangeUpdate = true;
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData.data.doc_no);
					}
				},
				error: function(e) {
					if (typeof(errorCallback) === "function"){
						errorCallback(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	checkRenameFile: function(objFileContent, strNewName, fnCallback) {
		try  {
			if (strNewName.trim() === "") {
				mobileToast.show("변경할 이름을 입력해주세요.");
				
				return false;
			}
			
			onefficeMGW.renameDocument(objFileContent, strNewName, function() {
				if (fnObjectCheckNull(fnCallback) === false && typeof(fnCallback) === "function") {
					fnCallback();
				}
			}, function() {
//				console.log("rename failed....");
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	renameDocument: function(fileContent, newName, successCallback, errorCallback) {
		try {
			var bFolder = (fileContent.fileType === '0') ? true : false;
			
			var objDocInfo = getBaseDocInfo(fileContent.seq, fileContent.parentFolderSeq);
			objDocInfo.subject = newName;

			if (bFolder === true) {
				onefficeMGW.saveFolderContent(objDocInfo, function(responseData) {
					if(typeof(successCallback) === "function")
						successCallback();
				}, function(e) {
					if(typeof(errorCallback) === "function")
						errorCallback();
				});
			} else {
				onefficeMGW.saveFileContent(objDocInfo, function(responseData) {
					if(typeof(successCallback) === "function")
						successCallback();
					
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(responseData, CLOUD_CONST_HISTORY_ACTIONCODE_RENAME);
				}, function(e) {
					if(typeof(errorCallback) === "function")
						errorCallback();
				});
			}
		} catch(e) {
			dalert(e);
		}
	},
	
	saveFileContent: function(fileContent, requestCallback, errorCallback, bAsync) {
		try 
		{
			var mgr = oneffice.getListViewMgr();//misty - 2018.08.20
			if(fnObjectCheckNull(fileContent.readonly) === true)
				fileContent.readonly = 0;
			
			var bLoading = false;
			
			if (typeof(bAsync) === "undefined") {
				bAsync = true;
			}
			
			var dataArray = {
				doc_no: fileContent.seq,
				folder_no: fileContent.folderSeq,
				doc_name: fileContent.subject,
				content: fileContent.content,
				readonly: fileContent.readonly,
				important: fileContent.important
			};
			
			if (fnObjectCheckNull(fileContent.security_key) === false && fileContent.security_key != "0") {
				dataArray["security_key"] = fileContent.security_key;
			}
			
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_UPDATE_DOCUMENT,
				async: bAsync,
				data: dataArray,
				dataType: "json",
				timeout: 30000,
				pid: "P556",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				bShowLoading: bLoading,
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							//cmnCtrlToast.showToastMsg(null, "POST_UPDATE_DOCUMENT_FAIL", 2, "screen_center");
							onefficeCommon.showServerErrorDialog();
							onefficeUtil.showDocSubject();
							onefficeUtil.updateProgressBar(true, true);
						});
						
						return ;
					}

					if (typeof(requestCallback) === "function") {
						if (dataArray.content && g_objSupport.bThumbListView && ( (mgr == null) || (!(mgr && mgr.m_nChecLstInitMode)))) {
							convertWebSrc();
							g_objThumbMgr.uploadThumbProcess(oneffice_cloud_currNEditNumber,bAsync);//misty - 2018.08.24
						}
						
						requestCallback(responseData.data.doc_no);
					}
				},
				error: function(e) {
					onefficeMGW.onErrorCheckSession(function() {
						//duzon_dialog.showToastMessage(null, "POST_UPDATE_DOCUMENT_ERROR", 2, "screen_center");
						onefficeCommon.showServerErrorDialog();
						onefficeUtil.showDocSubject();
						onefficeUtil.updateProgressBar(true, true);
					});
					
					if (typeof(errorCallback) === "function") {
						errorCallback(e);
					}
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	saveFolderContent: function(folderContent, requestCallback, errorCallback) {
		try {
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_UPDATE_FOLDER,
				async: true,
				data: {"doc_no":folderContent.seq, "folder_no":folderContent.folderSeq, "doc_name":folderContent.subject, "important":folderContent.important},
				dataType: "json",
				timeout: 30000,
				pid: "P557",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("POST_UPDATE_FOLDER_FAIL");
						});
						
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData.data.doc_no);
					}
				},
				error: function(e) {
					if (typeof(errorCallback) === "function") {
						errorCallback(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	checkFileName: function(strFileName, strFolderSeq, bCheckFile) {
		try {
			return new Promise(function(resolve, reject) {
				if (fnObjectCheckNull(strFolderSeq) === true) {
					switch (oneffice_cloud_currFolderSeq * 1) {
						case 12003:			// 공유문서함
						case 12016:			// 공유한 문서
						case 12017:			// 공유받은 문서
						case 12002:			// 중요문서함
						case 12004:			// 보안문서함
						case 12009:			// 휴지통
						case 12010:			// 검색?
						case 12011:			// 통합검색?
							strFolderSeq = "";
							
							break;
							
						default:
							strFolderSeq = "";
							
							break;
					}
				}
				
				if (fnObjectCheckNull(bCheckFile) === true) {
					bCheckFile = true;
				}
				
				onefficeMGW.getFileList(strFolderSeq, "", CLOUD_CONST_BROWSER_MODE_MYONEFFICE, "", function(arrDocList) {
					if(fnObjectCheckNull(arrDocList) === true) {
						resolve(null);
					}
					
					var arrDuplicatedFiles = [];
					var objFileInfo;
					var strName;
					var nIndex;
					var nSuffixIndex;
					
					for (var index = 0; index < arrDocList.length; index++) {
						objFileInfo = arrDocList[index];
						
						if ((bCheckFile === true) ? objFileInfo.type * 1 === 1 : objFileInfo.type * 1 === 0
								&& objFileInfo.subject.indexOf(strFileName) === 0) {
							
							strName = objFileInfo.subject;
							
							if (strName === strFileName) {
								arrDuplicatedFiles.push(0);
							} else if (strName.indexOf("(") > 0 && strName.substring(0, strName.indexOf("(")) === strFileName) {
								nIndex = strName.substring(strName.indexOf("(") + 1, strName.indexOf(")")) * 1;
								
								if (isNaN(nIndex) === false && arrDuplicatedFiles.indexOf(nIndex) < 0) {
									arrDuplicatedFiles.push(nIndex);
								}
							}
						}
					}
					
					if (arrDuplicatedFiles.length === 0) {
						resolve(nSuffixIndex);
					}
					
					arrDuplicatedFiles.sort(function(nFirst, nSecond) {
						return nFirst - nSecond;
					});
					
					if (arrDuplicatedFiles.some(function(nSuffix, nIndex) {
						nSuffixIndex = nIndex;
						
						if (nSuffix !== nIndex) {
							resolve(nSuffixIndex);
							
							return true;
						}
					}) === false) {
						resolve(nSuffixIndex + 1);
					}
				});
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	getDocumentList: function(strFolderSeq) {
		try {
			var objResponse;
			
			onefficeMGW.getFileList(strFolderSeq, "", CLOUD_CONST_BROWSER_MODE_MYONEFFICE, "", function(objResponseData) {
				objResponse = objResponseData;
			}, "", "", false);
			
			return objResponse;
		} catch (e) {
			dalert(e);
		}
	},
	
	onCreateNewFile: function(strSubject, strContents, strFolderSeq, fnCallBack) {
		try {
			onefficeMGW.onCreateNewFileContent(strSubject, strContents, strFolderSeq, fnCallBack);
		} catch (e) {
			dalert(e);
		}
	},
	
	onCreateNewFileContent: function(subject, strContents, strFolderSeq, fnCallBack) {
		try {
			switch (strFolderSeq * 1) {
				case 12003:			// 공유문서함
				case 12016:			// 공유한 문서
				case 12017:			// 공유받은 문서
				case 12002:			// 중요문서함
				case 12004:			// 보안문서함
				case 12009:			// 휴지통
				case 12010:			// 검색?
				case 12011:			// 통합검색?
					strFolderSeq = "";
					
					break;
			}
			
			onefficeMGW.createFileContent(strFolderSeq, subject, strContents, function(responseData) {
				var fileSeq = responseData;
				
				if (fileSeq) {
					fnCallBack(fileSeq);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
    createFileContent: function(folderSeq, docName, content, requestCallback, errorCallback) {
		try {

			if(content == "" || content == oneffice.emptyContent) {
			    content = oneffice.emptyServerContent;
			}

			mobile_http.ajax({				
				type: "post",
				url: ONEFFICE_SERVER_API_POST_CREATE_DOCUMENT,
				async: true,
				data: {"folder_no":folderSeq, "doc_name":docName, "content":content},
				dataType: "json",
				timeout: 30000,
				pid: "P529",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("POST_CREATE_DOCUMENT_FAIL");
						});
						
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData.data.doc_no);
					}
					
					// 사용기록 서버 등록
					onefficeMGW.accessUserFunction("createDoc");
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(responseData.data.doc_no, CLOUD_CONST_HISTORY_ACTIONCODE_NEWDOC);
				},
				error: function(e) {
					if (typeof(errorCallback) === "function") {
						errorCallback(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getFileContent: function (fileSeq, requestCallback, errorCallback, securityKey, groupSeq, bErrorCheck) {
		try {
			if (typeof (groupSeq) == "undefined") {
				var groupSeq = onefficeUtil.getRequestParameter("groupseq");
			}

			var errorCheck = (fnObjectCheckNull(bErrorCheck) == true) ? false : bErrorCheck;

			var dataArray = {};
			dataArray["doc_no"] = fileSeq;
			if (fnObjectCheckNull(groupSeq) === false)
				dataArray["groupSeq"] = groupSeq;
			if (fnObjectCheckNull(securityKey) === false)
				dataArray["security_key"] = securityKey;

			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_GET_DOCUMENT,
				async: true,
				data: dataArray,
				dataType: "json",
				timeout: 30000,
				pid: "P536",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function (responseData) {
					if (responseData === null || responseData.result !== "success" || !responseData.data) {
						onefficeMGW.onErrorCheckSession(function () {
							if (errorCheck) {
								requestCallback(null);
								
								return;
							}
							
							mobileToast.show("권한이 없거나<br/>없는 문서입니다.");
						});
						
						return;
					}
					
					if (typeof (requestCallback) === "function") {
						requestCallback(onefficeMGW.convertDataToContent(responseData.data), responseData);
					}
				},
				error: function (e) {
					if (typeof (errorCallback) === "function") {
						errorCallback(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	// bAct => true: 중요문서 설정, false: 중요문서 해제
	setFavorite: function(strDocSeq, strFolderSeq, bAct) {
		try {
			var objDocInfo = getBaseDocInfo(strDocSeq, strFolderSeq);
			objDocInfo.important = (bAct === true) ? 1 : 0;
			
			onefficeMGW.saveFileContent(objDocInfo, function(responseData) {
				if (responseData === strDocSeq) {
					mobileToast.show("중요문서 " + ((bAct === true) ? "설정" : "해제") + "되었습니다.", MOBILE_TOAST.INFO);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	// bAct => true: 읽기전용, false: 편집가능
	setReadonly: function(strDocSeq, strFolderSeq, bAct) {
		try {
			var objDocInfo = getBaseDocInfo(strDocSeq, strFolderSeq);
			objDocInfo.readonly = (bAct === true) ? 1 : 0;
			
			onefficeMGW.saveFileContent(objDocInfo, function(responseData) {
				if (responseData === strDocSeq) {
					if (bAct === true) {
						mobileToast.show("읽기 전용 설정되었습니다.", MOBILE_TOAST.INFO);
						
						// History 서버 등록
						onefficeMGW.accessDocumentHistory(strDocSeq, CLOUD_CONST_HISTORY_ACTIONCODE_READONLY_ON);
					} else {
						mobileToast.show("읽기 전용 해제되었습니다.", MOBILE_TOAST.INFO);
						
						// History 서버 등록
						onefficeMGW.accessDocumentHistory(strDocSeq, CLOUD_CONST_HISTORY_ACTIONCODE_READONLY_OFF);
					}
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getContainsImportantShareInList: function(arrFileList) {
		/*
		 * 0 - 일반 문서만 포함
		 * 1 - 일반/중요 문서 > 중요면서 공유일 경우 중요로 처리
		 * 2 - 중요 문서만 포함
		 * 3 - 일반/공유 문서 > 중요 문서가 아예 없을 경우
		 * 4 - 공유 문서만 포함
		 * 5 - 중요/공유 문서 포함
		 * 6 - 폴더만
		 * 7 - 폴더 포함
		 */
		try {
			var nStar = 0;
			var nShared = 0;
			var nTotal = arrFileList.length;
			var objFileInfo;
			
			for (var i = 0 ; i < nTotal ; i++) {
				objFileInfo = arrFileList[i];
				
				if (objFileInfo.fileType * 1 === 0) {		// 폴더
					if (nTotal > 1) {
						return 7;
					} else {
						return 6;
					}
				} else {
					if (objFileInfo.docData.bStar * 1 === 1) {		// 중요 문서
						nStar++;
					}
					
					if (objFileInfo.nShareCount > 0) {		// 공유 문서
						nShared++;
					}
				}
			}
			
			if (nStar > 0 || nShared > 0) {
				if (nShared === 0) {
					if (nStar === nTotal) {
						return 2;
					}
					
					return 1;
				} else if (nStar === 0) {
					if (nShared === nTotal) {
						return 4;
					}
					
					return 3;
				} else {
					return 5;
				}
			}
			
			return 0;
		} catch(e) {
			dalert(e);
		}
	},
	
	deleteFile: function(fileSeq, requestCallback, errorCallback, bAsync) {
		try {
			var async = (fnObjectCheckNull(bAsync)) ? true : bAsync;
			
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_DELETE_DOCUMENT,
				async: async,
				data: {"doc_no":fileSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P531",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_DELETE_DOCUMENT_FAIL");
						});
						
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData.data.doc_no);
					}
					
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(responseData.data.doc_no, CLOUD_CONST_HISTORY_ACTIONCODE_DELETE);
				},
				error: function(e) {
					if (typeof(errorCallback) === "function") {
						errorCallback(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
    deleteFolder: function(folderSeq, requestCallback, errorCallback) {
		try {
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_DELETE_FOLDER,
				async: true,
				data: {"doc_no":folderSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P532",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_DELETE_FOLDER_FAIL");	
						});
						
						return ;
					}
					
					oneffice.m_bFolderChangeUpdate = true;
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData.data.doc_no);
					}
				},
				error: function(e) {
					if (typeof(errorCallback) === "function") {
						errorCallback(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
    deleteTrashDocument: function(fileSeq, requestCallback, bAsync) {
		try {
			if (fnObjectCheckNull(bAsync) === true) {
				bAsync = true;
			}
			
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_DELETE_TRASH_DOCUMENT,
				async: bAsync,
				data: {"doc_no":fileSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P533",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_DELETE_TRASH_DOCUMENT_FAIL");
						});
						
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData);
					}
					
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(responseData.data.doc_no, CLOUD_CONST_HISTORY_ACTIONCODE_REMOVE);
				},
				error: function(e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
    emptyTrashbox: function(requestCallback) {
		try {
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_EMPTY_TRASH,
				async: true,
				data: {},
				dataType: "json",
				timeout: 30000,
				pid: "P534",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_EMPTY_TRASH_FAIL");
						});
						
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData);
					}
				},
				error: function(e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
	recoverDeletedDocument: function(fileSeq, requestCallback) {
		try {
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_RECOVER_TRASH_DOCUMENT,
				async: true,
				data: {"doc_no":fileSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P551",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_RECOVER_TRASH_DOCUMENT_FAIL");
						});
						
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData);
					}
					
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(responseData.data.doc_no, CLOUD_CONST_HISTORY_ACTIONCODE_RESTORE);
				},
				error: function(e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
	shareDocument: function(strFileSeq, nShareType, strShareID, strSharePerm, fnSuccess, fnError) {
		try {
			var shareData = {"doc_no":strFileSeq, "share_type":nShareType, "share_id":strShareID, "share_perm":strSharePerm};
			
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_SHARE_DOCUMENT,
				async: true,
				data: shareData,
				dataType: "json",
				timeout: 30000,
				pid: "P553",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("POST_SHARE_DOCUMENT_FAIL");
						});
						
						if (typeof(fnError) === "function") {
							fnError();
						}
						
						return ;
					}
					
					if (typeof(fnSuccess) === "function") {
						fnSuccess(responseData.data.doc_no);
					}
					
					// 사용기록 서버 등록
					onefficeMGW.accessUserFunction("shareDoc");
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(strFileSeq, CLOUD_CONST_HISTORY_ACTIONCODE_SHARE, JSON.stringify(shareData));
				},
				error: function(e) {
					if (typeof(fnError) === "function") {
						fnError();
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
    unshareDocument: function(strFileSeq, nShareType, strShareID, fnCallback) {
		try {
			var shareData = {"doc_no":strFileSeq, "share_type":nShareType, "share_id":strShareID};
			
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_UNSHARE_DOCUMENT,
				async: true,
				data: shareData,
				dataType: "json",
				timeout: 30000,
				pid: "P554",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("POST_UNSHARE_DOCUMENT_FAIL");
						});
						
						return ;
					}
					
					if (typeof(fnCallback) === "function") {
						fnCallback(responseData.data.doc_no);
					}
					
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(strFileSeq, CLOUD_CONST_HISTORY_ACTIONCODE_UNSHARE, JSON.stringify(shareData));
				},
				error: function(e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
	onErrorCheckSession: function(fnCallback) {
		try {
			onefficeMGW.checkSession(function(responseData) {
				if (responseData !== null && responseData.result == "success" && responseData.data.login == "1") {
					if (typeof(fnCallback) === "function") {
						fnCallback();
					}
				} else {
					// 로그인 상태가 아닐 경우, 로그인 세션으로 이동
					var strMsg = "세션이 만료되어 재 로그인이 필요합니다.<br/>로그인 하신 후 다시 시도하시기 바랍니다.";
					
					var arrButtonInfo = [
						{
							name: "확인",
							func: function() {
								mobileDlg.hideDialog();
								NextS.exitLogin();
							}
						}
					];
					
					mobileDlg.showDialog(mobileDlg.DIALOG_TYPE.ALERT, strMsg, null, arrButtonInfo);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	checkSession: function(requestCallback) {
		try {
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_CHECK_SESSION,
				async: true,
				data: {},
				dataType: "json",
				timeout: 30000,
				pid:"P527",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						// checkSession에서 다시 onErrorCheckSession을 호출하게 될 경우 무한루프 발생 > 그냥 에러 출력
//						dlog(responseData);
						requestCallback(null);
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData);
					}
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} else {
						requestCallback(null);
					}
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	accessUserFunction: function(functionCall) {
		try {
			var userInfoTypes = onefficeCommon.getUserInfoOsAppType();
			var groupSeq = onefficeUtil.getRequestParameter("groupseq");
			var objData = {"os_type":userInfoTypes.os_type, "app_type":userInfoTypes.app_type, "call_url":functionCall};
			
			if (fnObjectCheckNull(groupSeq) === false) {
				objData["groupSeq"] = groupSeq;
			}
			
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_ACCESS_USER_FUNCTION,
				async: true,
				data: objData,
				dataType: "json",
				timeout: 30000,
				pid: "P526",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				bShowLoading: false,
				success: function(responseData) {
					dlog("accessUserFunction Response : " + responseData.result);
				},
				error: function(e) {
					dlog("error:accessUserFunction");
					checkNetworkStatus();
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	accessDocumentHistory: function(strFileSeq, strActionCode, objActionData, nRetryCount) {
		try {
			if (fnObjectCheckNull(nRetryCount)) {
				nRetryCount = 0;
			}
			
			if (fnObjectCheckNull(oneffice_cloud_myInfoData)) {
				if (nRetryCount >= 3) {		// 3회까지만 시도하고 중단
					return ;
				}
				
				setTimeout(function() {
					onefficeMGW.accessDocumentHistory(strFileSeq, strActionCode, objActionData, nRetryCount + 1);
				}, 100);
				
				return ;
			}
			
			// GPS 좌표를 실제로 가져오는 케이스가 적어서 우선 막아놓음
//			onefficeCommon.getGPSLocation(function(gpsInfo) {
			// ip 서버에서 저장해주는 방식으로 변경
			var deviceInfo = onefficeCommon.getDeviceInfo();
			var userName = (oneffice_cloud_myInfoData.duty_name) ? oneffice_cloud_myInfoData.name+" "+oneffice_cloud_myInfoData.duty_name : oneffice_cloud_myInfoData.name;
			
			var dataArray = {"doc_no":strFileSeq, "action_user":oneffice_cloud_myInfoData.id, "action_user_name":userName, "action_code":strActionCode, "device_info":deviceInfo.device_type};
			
			if (fnObjectCheckNull(objActionData) === false) {
				dataArray["action_data"] = objActionData;
			}
			
//			if(fnObjectCheckNull(gpsInfo) === false && gpsInfo !== "")
//				dataArray["user_gps"] = gpsInfo;

			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_ACCESS_DOCUMENT_HISTORY,
				async: true,
				data: dataArray,
				dataType: "json",
				timeout: 30000,
				pid: "P525",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				bShowLoading: false,
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("ONEFFICE_SERVER_API_POST_ACCESS_DOCUMENT_HISTORY");
						});
						
						return ;
					}
				},
				error: function(e) {
					dlog("error:accessDocumentHistory");
					checkNetworkStatus();
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getShareInfo: function(strFileSeq, fnCallback, bShowLoading) {
		try {
			if (fnObjectCheckNull(bShowLoading) === true) {
				bShowLoading = true;
			}
			
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_SHARE_INFO,
				async: true,
				data: {"doc_no":strFileSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P549",
				loading_screen: bShowLoading,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_SHARE_INFO_FAIL");
						});
						
						return ;
					}
					
					if (typeof(fnCallback) === "function") {
						fnCallback(responseData.data);
					}
				},
				error: function(e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getDocumentShareOpenURL: function(strFileSeq, strGroupSeq, strRef) {
		try {
			var strOpenURL = "/gw/oneffice/" + oneffice.getEditModeDocPath(strFileSeq, strGroupSeq, strRef);
			var strDomain = "http://" + ((mobile_http.hybridBaseData !== null) ? mobile_http.hybridBaseData.result.compDomain : "");
			
			// domain URL에 모드에 따라 가변적인 URL을 가져와서 반환
			return strDomain + strOpenURL;
		} catch(e) {
			dalert(e);
		}
	},
	
	getSecurityInfo: function(strFileSeq, strPassword, fnSuccess, fnError) {
		try {
			if (onefficeCommon.isOnefficeGuideDoc(strFileSeq)) {
				fnSuccess(0);
				
				return ;
			}

			var strSecKey = fnObjectCheckNull(strPassword) ? "" : strPassword;
			var strGroupSeq = onefficeUtil.getRequestParameter("groupseq");

			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_GET_SECURITY_INFO,
				async: true,
				data: (fnObjectCheckNull(strGroupSeq)) ? {"doc_no":strFileSeq, "security_key":strSecKey} : {"doc_no":strFileSeq, "security_key":strSecKey, "groupSeq":strGroupSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P547",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("삭제되었거나, 권한이 변경된 문서입니다.");
							
							if (typeof(fnError) === "function") {
								fnError();
							}
						});
						
						return ;
					}
					
					if (responseData.status > 0) {
						oneffice.currFileSecurityStatus = true;
					}
					
					// 0 : 일반 문서 (securityKey 미전달)
					// 1 : 보안 문서 (securityKey 미전달)
					// 2 : 보안 문서면서 암호 일치
					// 3 : 보안 문서면서 암호 불일치
					if (typeof(fnSuccess) === "function") {
						fnSuccess(responseData.status);
					}
				},
				error: function(e) {
					if (typeof(fnError) === "function") {
						fnError(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	// bAct => 0: 보안문서 암호 해제, 1: 보안문서 암호 설정, 2: 보안문서 암호 변경
	setSecurityPassword: function(strDocSeq, strFolderSeq, bAct, strPassword, strNewPassword, fnCallback) {
		try {
			var objDocInfo = getBaseDocInfo(strDocSeq, strFolderSeq);
			
			switch (bAct) {
				case 0:		objDocInfo.security_key = "";				break;
				case 1:		objDocInfo.security_key = strPassword;		break;
				case 2:		objDocInfo.security_key = strNewPassword;	break;
			}
			
			onefficeMGW.saveFileContent(objDocInfo, function(responseData) {
				if (responseData === strDocSeq) {
					oneffice.currFileSecurityStatus = true;
					
					var nHistoryCode;
					
					if (bAct == 0) {
						nHistoryCode = CLOUD_CONST_HISTORY_ACTIONCODE_SECURITY_OFF;
						oneffice.currFileSecurityStatus = false;
					} else if (bAct == 1) {
						nHistoryCode = CLOUD_CONST_HISTORY_ACTIONCODE_SECURITY_ON;
					} else {
						nHistoryCode = CLOUD_CONST_HISTORY_ACTIONCODE_SECURITY_CHANGE;
					}
					
					// History 서버 등록
					onefficeMGW.accessDocumentHistory(responseData, nHistoryCode);
					
					if (typeof(fnCallback) === "function") {
						fnCallback(responseData);
					}
					
					var strMsg;
					
					switch (bAct) {
						case 0:		strMsg = ID_RES_CONST_STRING_UNSET_COMPLETE_PASSWORD;		break;
						case 1:		strMsg = ID_RES_CONST_STRING_SET_COMPLETE_PASSWORD;			break;
						case 2:		strMsg = ID_RES_CONST_STRING_CHANGE_COMPLETE_PASSWORD;		break;
					}
					
					mobileToast.show(strMsg, MOBILE_TOAST.INFO);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getSearchUserInfoList: function(optionValue, searchText, requestCallback) {
		try {
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_SEARCH_USER_INFO_LIST,
				async: true,
				data: {"option":optionValue, "txt_search":searchText},
				dataType: "json",
				timeout: 30000,
				pid: "P552",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("ONEFFICE_SERVER_API_GET_SEARCH_USER_INFO_LIST");
						});
						
						return ;
					}
					
					var userList = responseData.data;
					
					if (typeof(requestCallback) === "function") {
						requestCallback(userList);
					}
				},
				error: function(e) {
					dlog("error:getSearchUserInfoList");
					
					if (dzeEnvConfig.bDebugging && typeof(requestCallback) === "function") {
						var userList = [
							{"org_name": "팀원","login_id": "sokm83","id": "707010012173","org_id": "4412","path_name": "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원","comp_id": "6","name": "이수길","pic": "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg","duty_name": "선임연구원"},
							{"org_name":"포털","login_id":"ohk0307","id":"707010014418","org_id":"4102","path_name":"더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털","comp_id":"6","name":"아이유","pic":"http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg","duty_name":"부총경리"},
							{"org_name":"포털","login_id":"ohk0306","id":"707010014804","org_id":"4102","path_name":"더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털","comp_id":"6","name":"윤보미","pic":"http://www.mrtt.news/news/photo/201811/1322_5433_2725.jpg","duty_name":"대주주"},
							{"org_name": "팀원","login_id": "jjy83","id": "707010012172","org_id": "4412","path_name": "더존비즈온|더존비즈온|ES부문|UC사업본부|그룹웨어사업부|팀원","comp_id": "6","name": "정지영","pic": "https://newsimg.sedaily.com/2017/11/02/1ONFB1IWM0_1.jpg","duty_name": "선임연구원"},
							{"org_name":"포털","login_id":"kyu07","id":"707010014419","org_id":"4102","path_name":"더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털","comp_id":"6","name":"곽윤우","pic":"http://image.sportsseoul.com/2017/12/07/news/20171207013514_2.jpg","duty_name":"부총경리"},
							{"org_name":"포털","login_id":"ysj06","id":"707010014801","org_id":"4102","path_name":"더존비즈온|더존비즈온|UC개발본부|UC개발부|개발1팀|포털","comp_id":"6","name":"윤성준","pic":"http://image.chosun.com/sitedata/image/201610/06/2016100602363_0.jpg","duty_name":"대주주"}
						];
						
						requestCallback(userList);
					} else {
						checkNetworkStatus();
					}
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	copyFileToFolder: function(fileSeq, folderSeq, requestCallback, errorCallback) {
		try {
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_SERVER_API_POST_COPY_DOCUMENT,
				async: true,
				data: {"doc_no":fileSeq, "folder_no":folderSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P528",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function(){
							mobileToast.show( "POST_COPY_DOCUMENT_FAIL");	
						});
						return ;
					}

					if(typeof(requestCallback) === "function") {
						if(responseData.data.new_doc_no)
							requestCallback(responseData.data.new_doc_no);
						else if(responseData.data.doc_no)
							requestCallback(responseData.data.doc_no);
					}
					
					// 사용기록 서버 등록
					onefficeMGW.accessUserFunction("copyDoc");
					if(responseData.data.new_doc_no) {
						// History 서버 등록
						onefficeMGW.accessDocumentHistory(responseData.data.new_doc_no, CLOUD_CONST_HISTORY_ACTIONCODE_NEWDOC);
						onefficeMGW.accessDocumentHistory(fileSeq, CLOUD_CONST_HISTORY_ACTIONCODE_MAKE_COPY);
					} else {
						// History 서버 등록
						onefficeMGW.accessDocumentHistory(fileSeq, CLOUD_CONST_HISTORY_ACTIONCODE_MAKE_COPY);
					}
				},
				error: function(e) {
					if (typeof(errorCallback) === "function") {
						errorCallback(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getEmpListWithinDept: function(strDeptSeq, fnSuccess, fnError) {
		try {
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_EMPLIST_WITNIN_DEPT,
				async: true,
				data: {"dept_no":strDeptSeq},
				dataType: "json",
				timeout: 30000,
				pid: "P540",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_EMPLIST_WITNIN_DEPT_FAIL");
						});
						
						return ;
					}
					
					if (typeof(fnSuccess) === "function") {
						fnSuccess(responseData.data);
					}
				},
				error: function(e) {
					if (typeof(fnError) === "function") {
						fnError(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	sendMail: function(recvEmpList, subjectStr, contentStr, strFrom) {
		try {
            if(!subjectStr) subjectStr = "[ONEFFICE]";

			var objFormData = new FormData();
			objFormData.append("subject", subjectStr);      //제목
			objFormData.append("from", strFrom);            //보내는 사람
			objFormData.append("email", strFrom);           //세션에 저장된 (LoginVO) 이메일 주소
			objFormData.append("htmlContents", contentStr);
			objFormData.append("file_name_list", "");
			
            //받는사람
			var strTo = "";
			
			for (var i = 0;  i < recvEmpList.length; i++) {
				strTo += recvEmpList[i].empName;
				strTo += " ";
				strTo += "<" + recvEmpList[i].email + ">";

				if(i < recvEmpList.length - 1)
                {
                    strTo += ",";
                }
				strTo = recvEmpList[i].email;
			}
			
			objFormData.append("to", strTo);						//받는 사람, 구분자는 ","
			
			var ndata ={
					
					"mail_kind": "",
					"to": strTo,
					"receiptNotific": "0",
					"htmlContents": contentStr,
					"eachTrans": "0",
					"expirationDate": "",
					"securitymailpass": "",
					"subject": subjectStr,
					"cc":"",
					"bcc": "",
					"from": strFrom,
					"fileId": "",
					"langCode": "kr",
					"fileNameList": "",
					"securitymailuse": "",
					"toBeDeleted": "false",
					"importantmailuse": "0",
					} ;
				
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_GW_API_SEND_MAIL,
				async: true,
				data: ndata,
//				dataType: "form-data",
				dataType: "json",
				timeout: 30000,
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				pid:"P219",
				bShowLoading: false,
				success: function(responseData) {
					var json = JSON.parse(responseData);
					
					if (json && json.result == "0"
							&& json.resultCode == "0"
							&& json.resultMessage.toLowerCase() == "success") {
						//success
					} else {
						//fail
						onefficeMGW.onErrorCheckSession(function() {
							setTimeout(function() {
								mobileToast.show("메일 전송에 실패 하였습니다");
							}, 2000);
						});
						
						return;
					}
				},
				error: function(e) {
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
    },
	
    sendNote: function(recvEmpList, contentStr) {
		try {
			var bodyHeaderStr = {
				companyInfo: mobile_http.hybridBaseData.companyInfo,
				recvEmpSeq: recvEmpList,
				content: contentStr,
				contentType: "0",
				secuYn: "N",
				receiptYn: "N",
				reserveDate: "",
				fileId: "",
				link: [],
				linkMsgId: "",
				msgId: "",
				encryptionYn: "N",
			};
			
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_GW_API_SEND_NOTE,
				async: true,
				data: bodyHeaderStr,
				dataType: "json",
				timeout: 30000,
				pid: "P239",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					
				},
				error: function(e) {
					if (typeof(fnError) === "function") {
						fnError(e);
					}
					
					checkNetworkStatus();
					
					dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	getImageContent: function(docseq, requestCallback) {
		try {
			
//			var doc_seq = docseq.split('-')[0];
//			return 'http://'+mobile_http.hybridBaseData.result.compDomain+'/upload/onefficeFile/'+mobile_http.hybridBaseData.result.empSeq+'/'+doc_seq+'/'+docseq;
			
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_ATTACHMENTDATA,
				data: {"seq":docseq},
				dataType: "json",
				timeout: 3000,
				pid: "P535",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if(!responseData || responseData==null){
						requestCallback(null);
						return;
					} 
					
					if (responseData.result !== "success") {
						return ;
					}
					
					if (typeof(requestCallback) === "function") {
						requestCallback(responseData.data);
					}
				},
				error: function(e) {
					checkNetworkStatus();
					//dalert(e);
				}
			});
		} catch(e) {
			dalert(e);
		}
	},
	
	// 문서 본문 content만 저장하기 때문에 folderSeq, subject는 필요없음
	saveFile: function(strDocSeq, strFolderSeq, subject, content, nEditNumber, callback, bAsync, errCallback) {
		try {
			if(!strDocSeq) {
				return;
			}
			
			if (g_readonlyMode === true) {
				mobileToast.show(ID_RES_CONST_STRING_OPENED_READ_ONLY_DOCUMENT, MOBILE_TOAST.WARNING);
				return null;
			}
			
			if (typeof(bAsync) === "undefined") {
				bAsync = true;
			}
			
			var objDocInfo = getBaseDocInfo(strDocSeq, strFolderSeq);
			objDocInfo.content = content;
			
			onefficeMGW.saveFileContent(objDocInfo, function(responseData) {
				
				oneffice.parentFileContent.content = content;
				
				if (typeof(callback) === "function") {
					callback(responseData);
				}
				
				if (responseData == strDocSeq) {
					onefficeMGW.setAccessDocument(strDocSeq, "W", "1", 360, function(aceessData) {
						if (aceessData.access_perm == "R") {
							dzeLayoutControl.setReadonlyMode(true, nEditNumber);
							
							mobileToast.show(ID_RES_CONST_STRING_CHANGED_TO_READ_ONLY, MOBILE_TOAST.INFO);
						}
					});
					
					// History 서버 등록
					onefficeCommon.accessDocumentHistory(responseData, CLOUD_CONST_HISTORY_ACTIONCODE_MODIFY);
				}
			}, function(e) {
				if (typeof(errCallback) === "function") {
					errCallback();
				}
			}, bAsync);
		} catch(e) {
			dalert(e);
		}
	},
	
	setCurrFileInfo: function(fileSeq, folderSeq, subject, regdate, moddate) {
		try {
			oneffice.currFileSeq = fileSeq;
			oneffice.parentFileContent.seq = fileSeq;
			oneffice.currFolderSeq = folderSeq;
			oneffice.parentFileContent.folderSeq = folderSeq;
			oneffice.currFileSubject = subject;
			oneffice.parentFileContent.subject = subject;
			
			if(typeof(regdate) == "object") {
				oneffice.currFileRegDate = getFullDateFromTimeStamp(regdate.time);
			} else {
				oneffice.currFileRegDate = regdate;
			}
			oneffice.parentFileContent.regdate = oneffice.currFileRegDate;
                        
			if(typeof(moddate) != "undefined") {				
				if(typeof(moddate) == "object") {
					oneffice.currFileModDate = getFullDateFromTimeStamp(moddate.time);
				} else {				
					oneffice.currFileModDate = moddate;
				}
			} else {
				oneffice.currFileModDate = duzon_http.getCurrTime();
			}
			oneffice.parentFileContent.moddate = oneffice.currFileModDate;
                        
			//onefficeUtil.showDocSubject();
		} catch(e) {
			dalert(e);
		}
	},
	
	getBizboxReportList: function(strKind, objDateInfo, fnSuccess, fnError) {
		try {
			var reqData = {
				startDate: objDateInfo.startDate,
				endDate: objDateInfo.endDate,
				kind: strKind,
				readYn: "",
				searchTargetUserNm: "",
				searchTitle: "",
				state: "",
				type: "",
				pageSize: 30,
				
			};
			
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_GW_API_GET_BIZBOX_REPORT_LIST,
				async: true,
				data: reqData,
				dataType: "json",
				pid: "P040",
				timeout: 30000,
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData === null) {
						onefficeMGW.onErrorCheckSession(function() {
							mobileToast.show("GET_BIZBOX_REPORT_LIST_FAIL");
						});
						
						return ;
					}
					
					if (typeof(fnSuccess) === "function") {
						fnSuccess(responseData.reportList);
						return;
					}
				},
				error: function(e) {
					checkNetworkStatus();
					
					fnError(e);
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	
	getBizboxReportContent: function(objReportsInfo, objContentsInfo, fnCallback) {	
		try {
			if (objReportsInfo.seq.length === 0) {
				fnCallback(objContentsInfo);
				return;
			}
			
			var strReportSeq = objReportsInfo.seq.shift();
			
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_GW_API_GET_BIZBOX_REPORT_INFO + "?report_no=" + strReportSeq,
				async: true,
				dataType: "json",
				data: {"report_no":strReportSeq},
				timeout: 30000,
				pid:"P512",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (responseData.result !== "success") {
						fnCallback(objContentsInfo);
						return;
					}
					
					var content = responseData.data.contents;
					objContentsInfo.content.push(content);
					objContentsInfo.subject.push(objReportsInfo.title.shift());
					objContentsInfo.emp_name.push(objReportsInfo.emp_name.shift());
					
					onefficeMGW.getBizboxReportContent(objReportsInfo, objContentsInfo, fnCallback);
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} else {
						mobileToast.show("보고서 조회에 실패했습니다.", MOBILE_TOAST.ERROR);
						fnCallback(objContentsInfo);
					}
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	
	insertBizboxReport: function(strType, strState, objTargetInfo, strReportDate, strTitle, objContent, arrRefererList, fnSuccess, fnError) {
		try {
			var reqData = {
				reportSeq:		"0",
				type:			strType,
				state:			strState,
				targetCompSeq:	objTargetInfo.compSeq,
				targetEmpSeq:	objTargetInfo.empSeq,
				reportDate:		strReportDate,
				title:			strTitle,
				contentsList:	objContent,
				refererList:	arrRefererList,
				onefficeYn:		'Y'
			};
			
			mobile_http.ajax({
				type: "post",
				url: ONEFFICE_GW_API_GET_BIZBOX_REPORT_LIST,
				async: true,
				data: reqData,
				dataType: "json",
				pid: "P042",
				timeout: 30000,
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					
					if (typeof(fnSuccess) === "function") {
						fnSuccess(responseData.reportList);
						return;
					}
					
					if (responseData.resultCode !== "0") {
						fnError();
						return;
					}
					
					if (typeof(fnSuccess) === "function") {
						fnSuccess(responseData.result);
					}
				},
				error: function(e) {
					checkNetworkStatus();
					
					fnError(e);
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	
	getCommentList: function(objCommentInfo, fnCallback) {	
		try {
			
			mobile_http.ajax({
				type: "get",
				url: null,
				async: true,
				dataType: "json",
				data: objCommentInfo,
				timeout: 30000,
				pid:"P383",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (!responseData.commentList) {
						fnCallback(objCommentInfo);
						return;
					}
					
					fnCallback(responseData.commentList);
					
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} else {
						mobileToast.show("댓글 조회에 실패했습니다.", MOBILE_TOAST.ERROR);
						fnCallback(objCommentInfo);
					}
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	
	updateComment: function(objCommentInfo, fnCallback) {	
		try {
			
			mobile_http.ajax({
				type: "get",
				url: null,
				async: true,
				dataType: "json",
				data: objCommentInfo,
				timeout: 30000,
				pid:"P384",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (!responseData) {
						//fnCallback(objCommentInfo);
						return;
					}
					
					fnCallback(responseData);
					
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} else {
						mobileToast.show("댓글저장에 실패했습니다.", MOBILE_TOAST.ERROR);
						fnCallback(objCommentInfo);
					}
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	deleteComment: function(objCommentInfo, fnCallback) {	
		try {
			
			mobile_http.ajax({
				type: "get",
				url: null,
				async: true,
				dataType: "json",
				data: objCommentInfo,
				timeout: 30000,
				pid:"P386",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (!responseData) {
						//fnCallback(objCommentInfo);
						return;
					}
					
					fnCallback(responseData);
					
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} else {
						mobileToast.show("댓글삭제에 실패했습니다.", MOBILE_TOAST.ERROR);
						fnCallback(objCommentInfo);
					}
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	getCommentCount: function(objCommentInfo, fnCallback, bShowLoading) {	
		try {
			if (fnObjectCheckNull(bShowLoading) === true) {
				bShowLoading = true;
			}
			
			mobile_http.ajax({
				type: "get",
				url: null,
				async: true,
				dataType: "json",
				data: objCommentInfo,
				timeout: 30000,
				pid:"P385",
				loading_screen: bShowLoading,
				loading_image_url: "",
				loading_image_size: [],
				success: function(responseData) {
					if (!responseData) {
						//fnCallback(objCommentInfo);
						return;
					}
					
					fnCallback(responseData);
					
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} else {
						//mobileToast.show("댓글저장에 실패했습니다.", MOBILE_TOAST.ERROR);
						fnCallback(objCommentInfo);
					}
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	
	getDocumentAccessInfo: function(fileSeq, requestCallback) {
		try {
			
			mobile_http.ajax({
				type: "get",
				url: ONEFFICE_SERVER_API_GET_DOCUMENT_ACCESS_INFO,
				async: true,
				dataType: "json",
				data: {doc_no:fileSeq},
				timeout: 30000,
				pid:"P537",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				
				success: function(responseData) {
					if (responseData === null || responseData.result !== "success") {
						oneffice.onErrorCheckSession(function(){
							cmnCtrlToast.showToastMsg(null, "POST_ACCESS_DOCUMENT_FAIL", 2, "screen_center");	
						});
						return ;
					}

					if(typeof(requestCallback) === "function")
						requestCallback(responseData.data);
					
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} 
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	
	getSearchTotalList: function(searchStr, requestCallback) {
		try {
			var reqData = {
					
//					tsearchKeyword: "가나다",
//					tsearchSubKeyword: "",
//					boardType: "1",
//					listType: "6",
//					listTypes: "",
//					fromDate: "",
//					toDate: "",
//					dateDiv: "",
//					detailSearchYn: "N",
//					selectDiv: "S",
//					orderDiv:"B",
//					pageIndex: "1",
//					hrSearchYn: "N",
//					hrEmpSeq:"",
					
					tsearchKeyword : searchStr,
					tsearchSubKeyword : "",
					boardType : "1",
					listType: "12",
					listTypes:"",
					positionCode : mobile_http.hybridBaseData.result.positionCode,
					orgnztPath : mobile_http.hybridBaseData.result.orgnztPath,
					classCode : mobile_http.hybridBaseData.result.dutyCode,
					orderDiv : "B",
					detailSearchYn : "N",
					selectDiv : "S",
					dateDiv : "",
					fromDate : "",
					toDate : "",
					pageSize :"50",
					pageIndex : "1",
					filePageSize : "",
					onefficePageSize : "50",
					fileTabDiv : "전체",
					syncTime : "0",
					hrSearchYn: "N",
					hrEmpSeq:"",
			};
			
			mobile_http.ajax({
				type: "post",
				url: "",
				async: true,
				dataType: "json",
				data: reqData,
				timeout: 30000,
				pid:"P340",
				loading_screen: true,
				loading_image_url: "",
				loading_image_size: [],
				
				success: function(responseData) {
					
					if (!responseData.onefficeList) {
						return;
					}
					requestCallback(responseData.onefficeList);
					
				},
				error: function(e) {
					if (getNetworkStatus() === false) {
						checkNetworkStatus();
					} 
				}
			});		
		} catch (e) {
			dalert(e);
		}
	},
	
	
};