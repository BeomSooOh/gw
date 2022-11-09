/*
* 파일명 : oneffice_mobile_http.js
* 내용 : http 통신관련 라이브러리 (Ajax 사용)
* 작성일 : 2019 -06-24
**/
var mobile_http = {

	hybridBaseData:null,
	createRequest: function() {

		var request = null;

		try
		{

			try{
				request = new XMLHttpRequest();
			} catch(ms){
				try{
					request = new ActiveXObject("Msxml2.XMLHTTP");
				} catch(otherms){
					try{
						request = new ActiveXObject("Microsoft.XMLHTTP");
					} catch(failed){}
				}
			}
			if(request == null){
				alert("Request Error! Please Retry!");
			}
			return request;
			
		}
		catch (e)
		{
			return request;
		}

	},



	/*
		::: Ajax :::

		ex)
		mobile_http.ajax({

			type: "post",
			url: "http://www.daum.net",
			async: true,
			data: {"name":"Tom","age":"19"},
			dataType: "json",					//json,html,xml (response 데이터 형태 정의)
			timeout: 30000,						//millisec (request 응답 대기 최시 시간 - 초과시 request abort)
			loading_screen: true,				//로딩 스크린 사용 여부(로딩 시 배경에 반투명 스크린이 덮여지며, 로딩스크린이 있는동안에는 화면 구성요소 선택 불가)
			loading_image_url: "",				//로딩 이미지 사용 여부(loading_screen 이 true 인경우만 이미지 삽입 가능) : 설정안하면 "/editor_path/image/loading-image.gif" 가 기본
			loading_image_size: [],
			success: function(responseData) {

				//console.dir(responseData);
			
			},
			error: function(e) {
				//console.dir(e);
			}

		});
	*/
	loading_screen: true,
	loading_image_url: g_dzEditorBasePath + "image/loading-image.gif",		//로딩 이미지로 사용할 이미지경로
	loading_image_size: [48,48],											//위 이미지 사이드[가로,세로], 단위: 픽셀
	
	bHybrid:false,
	ajax: function(param) {

		try
		{
			var hybridData =(typeof(param.data) != "undefined") ? param.data : {};
//			if(false){
			if(mobile_http.hybridBaseData!=null){
//				console.log(mobile_http.hybridBaseData);
				
				var gwdata = (typeof(param.data) != "undefined" && param.data != "") ? param.data : {};
				gwdata["companyInfo"] = { 
						   "compSeq": mobile_http.hybridBaseData.companyInfo.compSeq,
						   "bizSeq": mobile_http.hybridBaseData.companyInfo.bizSeq,
						   "deptSeq": mobile_http.hybridBaseData.companyInfo.deptSeq,
						   "emailDomain": mobile_http.hybridBaseData.companyInfo.emailDomain,
						   "emailAddr": mobile_http.hybridBaseData.companyInfo.emailAddr
					   };
				hybridData = { 
						   "header":{ 
							   "token": mobile_http.hybridBaseData.header.token,
							   "mobileId": mobile_http.hybridBaseData.header.mobileId,
							   "loginId": mobile_http.hybridBaseData.header.loginId,
							   "appType": mobile_http.hybridBaseData.header.appType,
							   "osType": mobile_http.hybridBaseData.header.osType,
							   "tId": ((typeof(param.pid) != "undefined") ? param.pid : "" ) + this._timeStamp(), //mobile_http.hybridBaseData.header.tId,
							   "pId": (typeof(param.pid) != "undefined") ? param.pid : ""
							   },
						   "body":gwdata,
					};
				
				mobile_http.bHybrid=true;
			}
				
			var request				= this.createRequest();
			if(typeof(request) == "undefined" || request == null) return;

			var type				= (typeof(param.type) != "undefined") ? param.type.toLowerCase() : "post";
			var url                 = mobile_http.bHybrid?mobile_http.getProtocolUrl(param.pid):param.url;
			var async				= (typeof(param.async) != "undefined") ? param.async : true;
			var dataType			= (typeof(param.dataType) != "undefined") ? param.dataType : "html";
			//var data				= (typeof(param.data) != "undefined") ? param.data : {};
			var data				= hybridData;
			var successFunc				= (typeof(param.success) != "undefined") ? param.success : function(){};
			var errorFunc				= (typeof(param.error) != "undefined") ? param.error : function(){};
			var timeout				= (typeof(param.timeout) != "undefined" && param.timeout > 0) ? param.timeout : 10000;

			if(typeof(param.loading_screen) != "undefined")			this.loading_screen = param.loading_screen;
			//if(typeof(param.loading_image_url) != "undefined")		this.loading_image_url = param.loading_image_url;
			if(typeof(param.loading_image_size) != "undefined" && param.loading_image_size.length)		this.loading_image_size = param.loading_image_size;

			var bShowLoading		= (typeof(param.bShowLoading) != "undefined") ? param.bShowLoading : true;	
			var bFormData = (typeof(FormData) != "undefined" && data instanceof FormData);
			var strParam = null;
			
//			if (objOnefficeLoader.m_bHybrid === true) {
//				bShowLoading = false;
//			}
			
			if(bFormData) {
				strParam = data;
			}
			else if(typeof(data) === "object" ) {
				
				if(!mobile_http.bHybrid){
					var str = [];
					for(var idx in data) {
						str.push(idx + "=" + encodeURIComponent(data[idx]));
					}
					var strParam = str.join("&");
					if(type == "get" && strParam != "") {
						url += "?" + encodeURI(strParam);
					}
				}else{
					strParam = data
				}
				
				
			} else {
				strParam = data;
			}
				
			
			
			//noCache
			try {
				
				if(type == "get" && !mobile_http.bHybrid) {
					var currTime = new Date().getTime();				
					if(url.indexOf("?") >= 0) {
						url += "&_t="+currTime;
					} else {
						url += "?_t="+currTime;
					}				
				}
					
			} catch (e) {}
			
			mobile_http.log("url : "+url);
//			alert(url)
			if(mobile_http.bHybrid){
				request.open("post", url, async);
			}else{
				request.open(type, url, async);
			}
			
			if(mobile_http.bHybrid){
				request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
			}
			
			if(mobile_http.bHybrid){
				if(bFormData) {
					//request.setRequestHeader("Content-type","multipart/form-data");
				}else if(dataType == "json ") {
					request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
				}else if(dataType == "form-data"){
					request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				}
				else if(type == "post") {
					request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
					//request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				}
			}else{
				if(bFormData) {
					//request.setRequestHeader("Content-type","multipart/form-data");
				} else if(dataType == "json" && strParam.indexOf("{") == 0) {
					request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
				}
				else if(type == "post") {
					request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				}
			}
			
			
			//timeout 구현
			var reqTimer = setTimeout(function() {
				mobile_http.log("HttpReqeust Timeout!");
				mobile_http.hideLoading();
				request.abort();
				return;
			}, timeout);


			if(bShowLoading === true) {
				this.showLoading();
			}

			request.onreadystatechange = function() {
				if(request.readyState == 4) // request finished and response is ready
				{
					if(bShowLoading === true) {
						mobile_http.hideLoading();
					}
					mobile_http.log("HttpReqeust Complete");
					//timeout핸들제거
					clearTimeout(reqTimer);

					if(request.status == 200) //OK
					{
						mobile_http.log("HttpReqeust Result : Success");
						
						//응답결과 받기
						var responseData = (dataType == "xml") ? request.responseXML : request.responseText;

						
						mobile_http.log("response dataType:"+typeof(responseData));
						//console.dir(responseData);

						if(dataType == "json") {
							responseData = mobile_http.parseJSON(responseData);
						}
//						alert(JSON.stringify(responseData))
						//성공처리
						if(objOnefficeLoader.m_bDev){
							successFunc(responseData);
						}else{
							successFunc(responseData.result);
						}
						

					} else {

						mobile_http.log("HttpReqeust Result : Fail");
						
						var errorData = {
							status: request.status,
							msg: "response error"
						};

						//실패처리
						errorFunc(errorData.status);

					}

				}

			};
		
			if(g_browserCHK.mobile) {
				setTimeout(function() {
					if(type == "post") {
						if(objOnefficeLoader.m_bDev){
							request.send(strParam);
						}else{
							request.send(JSON.stringify(data));
						}
					} else {
//						alert(JSON.stringify(data)); 
						request.send(JSON.stringify(data));
					}
				},270);
			} else {
				if(type == "post") {
					request.send(strParam);
				} else {
					request.send();
				}
			}

		}
		catch (e)
		{
			alert(e)
			mobile_http.error("ajax error:", e); 
		}


	},
	
	ajaxJSON: function(urlPath, jsonData, param) {

		try
		{
			var successFunc				= (param && typeof(param.success) != "undefined") ? param.success : function(){};
			var errorFunc				= (param && typeof(param.error) != "undefined") ? param.error : function(){};
			var timeout				= (param && typeof(param.timeout) != "undefined" && param.timeout > 0) ? param.timeout : 10000;
			
			var request				= this.createRequest();
			if(typeof(request) == "undefined" || request == null) return;
			
			request.open("POST", urlPath, true);

			//timeout
			var reqTimer = setTimeout(function() {
				try
				{
					mobile_http.hideLoading();
					request.abort();
					dlog("request timeout");
					return;
				}
				catch (e) {}
			}, timeout);
			
			this.showLoading();

			request.onreadystatechange = function() {

				if(request.readyState == 4) // request finished and response is ready
				{
					mobile_http.hideLoading();
					
					mobile_http.log("HttpReqeust Complete");

					//timeout핸들제거
					clearTimeout(reqTimer);

					if(request.status == 200) //OK
					{
						mobile_http.log("HttpReqeust Result : Success");
						
						//응답결과 받기
						var responseData = mobile_http.parseJSON(request.responseText);

						//성공처리
						successFunc(responseData);
					}
					else
					{
						mobile_http.log("HttpReqeust Result : Fail");
						var errorData = {
							status: request.status,
							msg: "response error"
						};

						//실패처리
						errorFunc(errorData);
					}
				}
			};
			request.onerror = function() {
				clearTimeout(reqTimer);
				dlog("request Error");
			};

			request.setRequestHeader("Content-type","application/json; charset=UTF-8");

			request.send(JSON.stringify(jsonData));

		}
		catch (e)
		{
			mobile_http.error("ajaxJSON error:", e); 
		}

	},

	//unload event 에서 사용
    beacon: function(param) {

        try
        {
			var type				= "post";
			var url					= param.url;
			var dataType			= (typeof(param.dataType) != "undefined") ? param.dataType : "html";
			var data				= (typeof(param.data) != "undefined") ? param.data : {};
			var bShowLoading		= (typeof(param.bShowLoading) != "undefined") ? param.bShowLoading : true;	
			var bFormData 			= (typeof(FormData) != "undefined" && data instanceof FormData);

			if(bShowLoading === true) {
				mobile_http.hideLoading();
			}

			if(!bFormData && typeof(data) === "object") {
				var str = [];
				for(var idx in data) {
					str.push(idx + "=" + encodeURIComponent(data[idx]));
				}
				data = str.join("&");
			}

			if(bFormData) {
			} else if(dataType == "json" && data.indexOf("{") == 0) {
				data = new Blob([data], { type: "application/json; charset=UTF-8" });
			}
			else {
				data = new Blob([data], { type: "application/x-www-form-urlencoded" });
			}

			var status = navigator.sendBeacon(url, data);
			return status;
        }
        catch(e)
        {
            mobile_http.error("beacon error:", e); 
        }

    },
	
	readFile: function(filePath, param) {

		try
		{
			var successFunc			= (param && typeof(param.success) != "undefined") ? param.success : function(){};
			var errorFunc			= (param && typeof(param.error) != "undefined") ? param.error : function(){};
			var timeout				= (param && typeof(param.timeout) != "undefined" && param.timeout > 0) ? param.timeout : 10000;
			
			var request = this.createRequest();
			if(typeof(request) == "undefined" || request == null) return;
			
			request.open("GET", filePath, true);
			
			//timeout
			var reqTimer = setTimeout(function() {
				try
				{
					mobile_http.hideLoading();
					request.abort();
					dlog("request timeout");
					return;
				}
				catch (e) {}
			}, timeout);
			
			this.showLoading();
			
			request.onreadystatechange = function ()
			{
				if(request.readyState === 4)
				{
					mobile_http.hideLoading();
					
					mobile_http.log("HttpReqeust Complete");

					//timeout핸들제거
					clearTimeout(reqTimer);

					if(request.status === 200 || request.status == 0) //OK
					{
						mobile_http.log("HttpReqeust Result : Success");

						//성공처리
						successFunc(request.responseText);
					}
					else
					{
						mobile_http.log("HttpReqeust Result : Fail");
						
						var errorData = {
							status: request.status,
							msg: "response error"
						};

						//실패처리
						errorFunc(errorData);
					}
				}
			};
			request.onerror = function() {
				clearTimeout(reqTimer);
				dlog("request Error");
			};
			
			request.send(null);
		}
		catch (e)
		{
			mobile_http.error("readFile error:", e); 
		}

	},

	//Json 파싱
	parseJSON: function(jsonTEXT) {

		try
		{
			
			if(typeof(jsonTEXT) === "object") 
				return jsonTEXT;
			
			//JSON 객체가 있으면(IE8이상, 그 외 브라우저) JSON객체를 이용해 파싱한다.
			if(typeof(JSON) != "undefined") {
				try {
					return JSON.parse(jsonTEXT);
				} catch (e) {
				
					//JSON.parse 에서 에러가 발생하면 eval 로 다시 시도한다.
					try {
						return eval("("+jsonTEXT+")");	
					} catch (e) {
						mobile_http.error("Json Parsing error1:", e); 
						return {};
					}
				
				}			

			//JSON객체가 없으면(IE7이하) eval 을 이용해 파싱한다.
			} else {

				try {
					return eval("("+jsonTEXT+")");	
				} catch (e) {
					mobile_http.error("Json Parsing error2:", e); 
					return {};
				}
				
			}

		}
		catch (e)
		{
			mobile_http.error("Json Parsing error3:", e); 
			return {};
		}

	},

	loading_images: [
		g_dzEditorBasePath + "image/oneffice_loading_00.gif",
		g_dzEditorBasePath + "image/oneffice_loading_01.gif",
		g_dzEditorBasePath + "image/oneffice_loading_02.gif",
		g_dzEditorBasePath + "image/oneffice_loading_03.gif",
		g_dzEditorBasePath + "image/oneffice_loading_04.gif",
		g_dzEditorBasePath + "image/oneffice_loading_05.gif"
	],
	
    getRandomLoadingImage: function() {
		return this.loading_images[Math.floor(Math.random() * this.loading_images.length)];
	},
	
	loadingScreenObj: null,
	loadingImageObj: null,
	loadingImageTimer: null,
	showLoading: function(delayTime) {

		try
		{

			if(this.loading_screen !== true) return;

			//로딩 배경 스크린 그리기
			this.loadingScreenObj = g_objLayerKit.getLayerDocument().getElementById("dze_idx_loading_screen_obj");
			if(this.loadingScreenObj == null) {
				this.loadingScreenObj = g_objLayerKit.getLayerDocument().createElement("div");
				this.loadingScreenObj.id					= "dze_idx_loading_screen_obj";
				this.loadingScreenObj.style.position		= "absolute";
				this.loadingScreenObj.style.left			= "0";
				this.loadingScreenObj.style.top				= "0";
				this.loadingScreenObj.style.width			= "100%";
				this.loadingScreenObj.style.height			= "100%";
				this.loadingScreenObj.style.backgroundColor	= "gray";
				this.loadingScreenObj.style.opacity			= "0";
				this.loadingScreenObj.style.zIndex			= "30001";
				g_objLayerKit.getLayerDocument().body.appendChild(this.loadingScreenObj);
			}
			
			if(mobile_http.loadingImageTimer != null) {
				cleaarTimeout(mobile_http.loadingImageTimer);
				mobile_http.loadingImageTimer = null;
			}
			
			this.loadingScreenObj.style.display				= "block";
			this.resizeLoadingScreen();
			
			this.loading_image_url = this.getRandomLoadingImage();
//			this.loading_image_size = [75, 75];

			if (this.loading_image_url != "") {
				// 로딩 배경 스크린 내 로딩 이미지 그리기
				this.loadingImageObj = g_objLayerKit.getLayerDocument().getElementById("dze_idx_loading_image_obj");
				
				// 이미지 객체가 없는경우 생성
				if (this.loadingImageObj == null) {
					this.loadingImageObj						= g_objLayerKit.getLayerDocument().createElement("div");
					this.loadingImageObj.id						= "dze_idx_loading_image_obj";
					this.loadingImageObj.style.backgroundSize   = "auto 100%";
					this.loadingImageObj.style.position			= "fixed";
//					this.loadingImageObj.style.left				= "0";
//					this.loadingImageObj.style.top				= "0";
					this.loadingImageObj.style.width			= this.loading_image_size[0]+"px";
					this.loadingImageObj.style.height			= this.loading_image_size[1]+"px";
					this.loadingImageObj.style.zIndex			= "30002";
					
					var translateY = -(this.loading_image_size[1]/2);
					var translateX = -(this.loading_image_size[0]/2);
					
					mobile_http.loadingImageObj.style.top = "50%";
					mobile_http.loadingImageObj.style.left = "50%";
					mobile_http.loadingImageObj.style.transform = "translate(-50%, -50%)";
					mobile_http.loadingImageObj.style.msTransform = "translate(-50%, -50%)";
					mobile_http.loadingImageObj.style.WebkitTransform = "translate(-50%, -50%)";
					
					g_objLayerKit.getLayerDocument().body.appendChild(this.loadingImageObj);
				}
				
				this.loadingImageObj.style.backgroundImage	= "url(" + this.loading_image_url + ")";
				this.loadingImageObj.style.display = "block";
				this.setPositionLoadingImage();
				this.addLoadingImageEvent();
			}
			
			var delayT = (fnObjectCheckNull(delayTime) === true) ? 30000 : delayTime;
			//30초 후에는 항상 닫히기...(오류방지)
			mobile_http.loadingImageTimer = setTimeout(function() {
				mobile_http.hideLoading();
				mobile_http.loadingImageTimer = null;
			},delayT);

		}
		catch (e)
		{
		}


	},
	addLoadingImageEvent: function() {

		try
		{
			
			if(g_objLayerKit.getLayerWindow().attachEvent) {
//				g_objLayerKit.getLayerWindow().attachEvent("onscroll", mobile_http.setPositionLoadingImage);
				g_objLayerKit.getLayerWindow().attachEvent("onscroll", mobile_http.resizeLoadingScreen);
//				g_objLayerKit.getLayerWindow().attachEvent("onresize", mobile_http.setPositionLoadingImage);
				g_objLayerKit.getLayerWindow().attachEvent("onresize", mobile_http.resizeLoadingScreen);
			} else {
//				g_objLayerKit.getLayerWindow().addEventListener("scroll", mobile_http.setPositionLoadingImage, false);
				g_objLayerKit.getLayerWindow().addEventListener("scroll", mobile_http.resizeLoadingScreen, false);
//				g_objLayerKit.getLayerWindow().addEventListener("resize", mobile_http.setPositionLoadingImage, false);
				g_objLayerKit.getLayerWindow().addEventListener("resize", mobile_http.resizeLoadingScreen, false);
			}

		}
		catch (e)
		{
		}

	},
	resizeLoadingScreen: function() {

		try
		{
			
			//백스크린 객체가 없거나, 화면에 출력되어있지 않으면 종료
			mobile_http.loadingScreenObj = g_objLayerKit.getElementById("dze_idx_loading_screen_obj");
			if(mobile_http.loadingScreenObj == null || mobile_http.loadingScreenObj.style.display == "none") {
				return;
			}

			var backScreenWidth = 0;
			var backScreenHeight = 0;

			//스크린 사이즈를 "0"으로 수정한다.
			mobile_http.loadingScreenObj.style.width = backScreenWidth+ "px";
			mobile_http.loadingScreenObj.style.height = backScreenHeight + "px";

			if(g_objLayerKit.getLayerDocument().documentElement.scrollWidth) {
				backScreenWidth = g_objLayerKit.getLayerDocument().documentElement.scrollWidth;
			}
			if(g_objLayerKit.getLayerDocument().documentElement.scrollHeight) {
				backScreenHeight = g_objLayerKit.getLayerDocument().documentElement.scrollHeight;
			}

			//높이값 보정
			//크롬에서 최대창일때 높이가 최대 높이로 안되고, 컨텐츠가 있는 부분까지만 높이로 계산되므로 innerHeight(현재 보이는 부분의 윈도우창 내부 높이값)가 더 클땐 이를 이용해 대체한다.
			if(g_objLayerKit.getLayerWindow().innerHeight) {
				if(g_objLayerKit.getLayerWindow().innerHeight > backScreenHeight) {
					backScreenHeight = g_objLayerKit.getLayerWindow().innerHeight;
				}
			}
			if(g_objLayerKit.getLayerDocument().documentElement.clientHeight) {
				if(g_objLayerKit.getLayerDocument().documentElement.clientHeight > backScreenHeight) {
					backScreenHeight = g_objLayerKit.getLayerDocument().documentElement.clientHeight;
				}
			}		
			if(g_objLayerKit.getLayerDocument().body.scrollWidth) {
				if(g_objLayerKit.getLayerDocument().body.scrollWidth > backScreenWidth) {
					backScreenWidth = g_objLayerKit.getLayerDocument().body.scrollWidth;
				}
			}
			if(g_objLayerKit.getLayerDocument().body.scrollHeight) {
				if(g_objLayerKit.getLayerDocument().body.scrollHeight > backScreenHeight) {
					backScreenHeight = g_objLayerKit.getLayerDocument().body.scrollHeight;
				}
			}

			mobile_http.loadingScreenObj.style.width = backScreenWidth+ "px";
			mobile_http.loadingScreenObj.style.height = backScreenHeight + "px";

		}
		catch (e)
		{
		}


	},
	setPositionLoadingImage: function() {

		try
		{			
			
			mobile_http.loadingImageObj = g_objLayerKit.getElementById("dze_idx_loading_image_obj");
			if(mobile_http.loadingImageObj == null || mobile_http.loadingImageObj.style.display != "block") return;
			
			mobile_http.loadingImageObj.style.position = "fixed";
			mobile_http.loadingImageObj.style.top = "50%";
			mobile_http.loadingImageObj.style.left = "50%";
			mobile_http.loadingImageObj.style.transform = "translate(-50%, -50%)";
			mobile_http.loadingImageObj.style.msTransform = "translate(-50%, -50%)";
			mobile_http.loadingImageObj.style.WebkitTransform = "translate(-50%, -50%)";
		   
			
		}
		catch (e)
		{
		}


	},

	hideLoading: function() {

		try
		{

			if(this.loading_screen !== true) return;

			if(this.loadingImageTimer) {
				clearTimeout(this.loadingImageTimer);
			}
			/*
			if(this.loadingImageObj != null) {
				this.loadingImageObj.style.display				= "none";
			}
			if(this.loadingScreenObj != null) {
				this.loadingScreenObj.style.display				= "none";
			}

			this.loadingImageTimer = null;
			*/
		   
			this.loadingImageTimer = null;

			setTimeout(function() {
				
				//0.1초후에도 여전히 null이면 완전히 제거한다.
				if(mobile_http.loadingImageTimer === null) {

					if(mobile_http.loadingImageObj != null) {
						dzeJ(mobile_http.loadingImageObj).fadeOut(300);
					}
					if(mobile_http.loadingScreenObj != null) {
						mobile_http.loadingScreenObj.style.display				= "none";
					}

				}

			},100);			   

		}
		catch (e)
		{
		}


	},
	
	
	
	
	
	//------------------------------------------------------ 디버깅 관련-----------------------------------------------------------------------
//	debug: false,
	checkDebuggingStatus: function() {
		if(dzeEnvConfig.bDebugging === true) {
			return true;
		} else {
			return false;
		}
	},
	error: function(msg,e) {

		if(this.checkDebuggingStatus() !== true) return;

		//console 이 있는경우만 수행한다.(IE9이하에서 콘솔창 열지 않은 경우 console 객체가 없어 스크립트 에러발생)
		if(typeof(console) != "undefined") {
			try {
				console.error(msg, e); 		
			} catch (e) {}			
		}

	},

	log: function(msg) {

		if(this.checkDebuggingStatus() !== true) return;

		//console 이 있는경우만 수행한다.(IE9이하에서 콘솔창 열지 않은 경우 console 객체가 없어 스크립트가 중단되므로 이를 방지하기 위해)
		if(typeof(console) !== "undefined") {

			try {
				console.log("[DZE_HTTP:"+mobile_http.getCurrTime()+"] "+msg);	
			} catch (e) {
				mobile_http.error("Error",e);
			}
		}

	},
	getCurrTime: function() {

		try
		{			
	  
		  var d = new Date();
		  var year = d.getFullYear();
		  var month = d.getMonth() + 1;
			if(month < 10) month = "0"+month;
		  var day = d.getDate();
			if(day < 10) day = "0"+day;
		  var hour = d.getHours();
			if(hour < 10) hour = "0"+hour;
		  var minute = d.getMinutes();
			if(minute < 10) minute = "0"+minute;
		  var second = d.getSeconds();
			if(second < 10) second = "0"+second;
		  
		  return ""+year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second;	

		}
		catch (e)
		{
			return "";
		}
			

	},
	getProtocolUrl : function (pid) {
	    var protocolList = mobile_http.hybridBaseData.protocolList;
	    var pUrl = "";

	    for (i = 0; i < protocolList.length; i++) {
	        if (protocolList[i].protocolId == pid) {
	            pUrl = protocolList[i].protocolUrl;
	            break;
	        }
	    }

	    return pUrl;
	},
	  _timeStamp: function () {
	        return Math.floor(new Date().getTime() / 1000);
	}
};