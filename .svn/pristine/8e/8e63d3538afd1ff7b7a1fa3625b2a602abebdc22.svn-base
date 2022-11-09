/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// nexts json 포맷으로 변경(iOS) --- from nexts-1.0.5.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var NextS;
var ua = navigator.userAgent.toLowerCase(); _setBaseData // <== ??? 이거 왜 이 위치에 있는 것 ???

// 원본코드 - 주석처리
//if( typeof (NEXTS) == 'undefined' ) NEXTS = {};


// 원본코드 - var 변수 선언 추가
//NEXTS = function() {
var NEXTS = function() {

    var t = this;
    t.options = {
        os: { iphone: /iphone/.test(ua), ipad: /ipad/.test(ua), android: /android/.test(ua) },
        mDev: (ua.match(/iphone|ipod|android|windows ce|blackberry|symbian|windows phone|webos|opera mini|opera mobi|polaris|iemobile|lgtelecom|nokia|sonyericsson/i) != null || ua.match(/lg|samsung|samsung/) != null ? true : false),
        width: screen.availWidth,
        height: screen.availHeight,
        testUrl: 'localhost',
        testMode: false,
        errMode: true,
        callback: '',
        iosVersion: iosCheckVersion() // ios8 관련 수정
    };
    t.memBridgeCallbackFnc = '';
}


NEXTS.prototype = {

	// 원본코드 - 변경사항 없음
    cnt: 0,
    baseData: '',
    tId: null,
    jsonParam: '',
    callback: null,
    runtime: false,
    errCallback: null,
    gwID: '',
    gwPath: '',
    dbUse: false,
    protocolUse: false,
    db: null,
    rdb: [],
    etcData: '',
    baseCallFalg: localStorage.getItem("baseCallFalg") == null ? 1 : localStorage.getItem("baseCallFalg"),  // ios8 관련 수정 => 1: 인코딩 요청, 2: 인코딩 없이 요청, 3: 인코딩 응답 성공, 4: 인코딩 없이 응답 성공

	// 원본코드 - 변경사항 없음
    init: function (o) {
        var to = this.options;

        to.width = this._getWidth();
        to.height = this._getHeight();

        for (var k in o) {
            to[k] = o[k];
            if (k == 'testUrl') to.testMode = (location.host.indexOf(to.testUrl) > -1 ? true : false)
        }
    },

	// 원본코드 - 변경사항 없음
	isAndroid : function() {

        return this.options.os.android;
    },


	// --------------------------------------------------------------------------- //
	// getBaseData
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
	call_getBaseData : function( callback ) {

		//if( this.isAndroid() ) {
		//} else {

			this._setCallbackCommon( "callback_getBaseData", function( resultObj ) {

				if( "function" === typeof callback ) {

					callback.call( this, resultObj );
				}
			});

			var jsonObj = {
				"command" : "getBaseData",
				"taskId" : "",
				"returnFunction" : "callback_getBaseData",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
		//}
	},


	// --------------------------------------------------------------------------- //
	// 홈이동
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
    gotoHome : function( p ) {

        //if( this.isAndroid() ) {

        //    if (p) {
        //        window.NextSBridge.gotoHome(p);
        //    } else {
        //        window.NextSBridge.gotoHome();
		//	}
			
        //} else {

			// 원본코드
			//this._callApp('goto;Home;' + (p ? p : '') + ';');
			//
			// 변경코드
			var jsonObj = {
				"command" : "gotoHome",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// 특정 HybridWeb으로 이동
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
	//
	// 원본코드 - param json 규약에 맞게 변경
	//gotoPage : function( pgUrl, push, PL, PbgUrl, LbgUrl, barColor ) {
	//
	// @subUrl - 컨텐츠 루트 이항의 경로(/로 시작) 또는 외부 url(http로 시작)
	// @pushYn - "n" : 현재 화면에서 로딩, "y" : 새화면으로 네비게이션 후 로딩
	// @screenImg - 페이지가 로드되기 전 표시할 이미지 경로, 컨텐츠 루트 이후의 이미지 경로(/로 시작)
	// @title - @pushYn 값이 "y" 인 경우
	//
	gotoPage : function( subUrl, pushYn, screenImg, title ) {

        if( this.options.testMode ) {

			//location.href = '/WebApp' + pgUrl;
			return;
		}
		
        //if( this.isAndroid() ) {

        //    if (PL) {
        //        window.NextSBridge.gotoPage(pgUrl, push, PL);
        //    } else {
        //        window.NextSBridge.gotoPage(pgUrl, push);
		//	}

        //} else {

			// 원본코드
			//this._callApp('goto;Page;' + pgUrl + ';' + (push ? push : 'current') + ';' + (PL ? PL : '') + ';' + (PbgUrl ? PbgUrl : '') + ';' + (LbgUrl ? LbgUrl : '') + ';' + (barColor ? barColor : '') + ';');
			//
			// 변경코드
			pushYn = ( 'undefined' != typeof pushYn ) ? pushYn : "n";

			var jsonObj = {
				"command" : "gotoPage",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {
					pushYn : pushYn,
					subUrl : subUrl,
					screenImg : screenImg,
					title : title
				}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// 앱설정화면으로 이동
	//
	// iOS : 변경 처리 - Y, 명령 실행하면 Bizbox App에서 설정 화면이 뒤로 가기 누르면 그떄 보임 - 정상
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
	gotoSet : function() {

        //if( this.isAndroid() ) {

		//	window.NextSBridge.gotoSet();
			
        //} else {
			
			// 원본코드
			//this._callApp('goto;Set;');
			//
			// 변경코드
			var jsonObj = {
				"command" : "gotoSet",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// Application 종료
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
	exitApp : function() {

        //if( this.isAndroid() ) {

		//	window.NextSBridge.exitApp();
			
        //} else {

			// 원본코드
			//this._callApp('exit;App;');
			//
			// 변경코드
			var jsonObj = {
				"command" : "exitApp",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// 로그아웃
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
    exitLogin : function() {

        //if( this.isAndroid() ) {

		//	window.NextSBridge.exitLogin();
			
        //} else {

			// 원본코드
			//this._callApp('exit;Login;');
			//
			// 변경코드
			var jsonObj = {
				"command" : "logout",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// KeyValue 조회
	// - custom 성격 key, value set/get
	//
	// iOS : 변경 처리 - 진행중
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
	//
	// =======================================================================================> iOS 패치 받으면 처리되는 것, array 확인할 것
	//
    getValue: function(strKey, callback) {
        var jData = {};
        jData.key = strKey;
        jData.appCode = 'getValue';
        this.etcData = jData;
        this.callback = callback;

        //if( NextS.isAndroid() ) {

        //    value = window.NextSBridge.getValue(JSON.stringify(jData));
		//	_setData(value);
			
        //} else {

			this._setCallbackCommon( "callback_getValue", function( resultObj ) {

				if( "function" === typeof callback ) {

					callback.call( this, resultObj );
				}
			});

			// 원본코드
			//this._callApp('get;Value;_getData;_setData');
			//
			// 변경코드
			var jsonObj = {
				command: "get",
				taskId: "",
				returnFunction: "callback_getValue",
				param: {key: strKey}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// KeyValue 세팅
	// - custom 성격 key, value set/get
	//
	// iOS : 변경 처리 - 진행중
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
    setValue: function(arrData, callback) {
        var jData = {};
        jData.key = arrData;
        jData.appCode = 'setValue';
        this.etcData = jData;
        this.callback = callback;

        //if( this.isAndroid() ) {

        //    value = window.NextSBridge.setValue(value);
		//	_setData(value);
			
        //} else {

			// 원본코드
			//this._callApp('set;Value;_getData;_setData');
			// 변경코드
			var jsonObj = {
				command: "set",
				taskId: "",
				returnFunction: "callback_setValue",
				param: {key:  arrData.key, val: arrData.val}
				//"param" : { "key" :  "testField", "val" : ["testFieldVal", "testFieldVal2"] }// 배열형식
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// pickPhoto
	//
	// iOS : 변경 처리 - iOS 작업 완료 후 확인할 것
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //


	// --------------------------------------------------------------------------- //
	// backHistory
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
    backHistory : function() {

        //if( this.isAndroid() ) {
        //} else {

			// 변경코드
			var jsonObj = {
				"command" : "backHistory",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// backNavi
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
    backNavi : function() {

        //if( this.isAndroid() ) {
        //} else {

			// 변경코드
			var jsonObj = {
				"command" : "backNavi",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// captureAndSketch
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
    captureAndSketch : function() {

        //if( this.isAndroid() ) {
        //} else {

			// 변경코드
			var jsonObj = {
				"command" : "captureAndSketch",
				"taskId" : "",
				"returnFunction" : "",
				"param" : {}
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// selectOrg
	//
	// iOS : 변경 처리 - Y
	// android : 변경 처리 - N, 확인할 것
	// --------------------------------------------------------------------------- //
	//
	// @selectMode - multi 여러개 선택 가능, single 하나만 선택가능, none 선택모드 아님
	// @selectDeptMode - 부서/직원 모두선택 select, 부서만 선택 dept, 직원만 선택 none
	// @oldSelectedList - 기 선택되어져있던 리스트
	//
    selectOrg : function( selectMode, selectDeptMode, oldSelectedList, callback ) {

        //if( this.isAndroid() ) {
        //} else {

			this._setCallbackCommon( "callback_selectOrg", function( resultObj ) {

				if( "function" === typeof callback ) {

					if( resultObj && ( "Y" == resultObj.selectedYn ) ) {

						callback.call( this, resultObj.selectedList );

					} else {

						callback.call( this, null );
					}
				}
			});

			var param = {};
			param.selectMode = selectMode;
			param.selectDeptMode = selectDeptMode;
			param.oldSelectedList = oldSelectedList;
	
			// 변경코드
			var jsonObj = {
				"command" : "selectOrg",
				"taskId" : "",
				"returnFunction" : "callback_selectOrg",
				"param" : param
			};
			this._callAppByJsonFormat( jsonObj );
        //}
    },


	// --------------------------------------------------------------------------- //
	// Application 이동
	//
	// json 연동 규약에 없음(iOS), android는 있는지 확인할 것
	// --------------------------------------------------------------------------- //
    //gotoApp : function() {
	//	this._callApp('goto;App;');
    //},


	// --------------------------------------------------------------------------- //
	// 신규코드
	//
	// callback 공통 처리 함수 - 일단 iOS 인 경우 처리
	// --------------------------------------------------------------------------- //
	_setCallbackCommon : function( callbackName, callback ) {

		//if( this.isAndroid() ) {
        //} else {
			window[ callbackName ] = function( result ) {

				if( "0" != result.errorCode ) {

					if( "function" === typeof callback ) {

						callback.call( this, null );
					}

					return;
				}

				var resultObj = result.result;
				if( "function" === typeof callback ) {

					callback.call( this, resultObj );
				}
			}
		//}
	},









    /* Push된 WebView Pop 처리 */
    gotoPop: function (p) {
        if (this.isAndroid()) {
            if (p) {
                window.NextSBridge.gotoPop(p);
            } else {
                window.NextSBridge.gotoPop();
            }
        } else {
            this._callApp('goto;Pop;' + (p ? p : '') + ';');
        }
    },

    /* 특정 URL로 이동 */
    gotoUrl: function (url, typ) {
        if (this.options.testMode) {
            location.href = url; return;
        }

        if (this.isAndroid()) {
            /**
            * typ 변수는 안드로이드 앱에서는 의미없기 때문에 무시함.
            */
            window.NextSBridge.gotoUrl(url);
        } else {
            this._callApp('goto;Url;' + url + ';' + (typ ? typ : 'ex') + ';');
        }
    },



    /* 뒤로 이동(History Back) */
    gotoBack: function (p) {
        if (p) { p(); return; } history.back();
    },

    /* 뒤로 이동(Andoid H/W Back Event Capture) */
    setAndroidBack: function (p) {
        this.pathAndroidBack = p;
    },
    androidBack: function () {
        this.gotoBack(this.pathAndroidBack);
    },

    /* 파일 뷰어 이동 */
    gotoFile: function (ext, path, fileNm) {
        try { if (!fileNm) fileNm = path.match(/\w+\.(\w+)?$/g); } catch (e) { fileNm = ''; }
        try { if (!ext) ext = path.match(/.+\.(\w+)?$/)[1]; } catch (e) { ext = ''; }
        if (this.isAndroid()) {
            /**
            * 안드로이드에서 첫번째 파라메터에 'map'이라는 이름으로 넘긴다면
            * 구글 지도를 보여주기 때문에, 두번째 파라메터는 gps 좌표를 넘겨야 함.
            * 그 외에는 앱에서 파일 이름을 기준으로 알아서 체크하기 때문에 의미없음.
            */
            window.NextSBridge.gotoFile('app', encodeURI(path), encodeURI(fileNm));
        } else {
            this._callApp('goto;File;' + ext + ';' + encodeURI(path).replace(/\(/g, "%28").replace(/\)/g, "%29") + ';' + encodeURI(fileNm).replace(/\(/g, "%28").replace(/\)/g, "%29") + ';');
        }
    },

    /* 스케치뷰 이동 */
    gotoCaptureMemo: function (custom_button, callback) {
        if (this.isAndroid()) {
            window.NextSBridge.gotoCaptureMemo();   //구현전
        } else {
            this._callApp('goto;capture_memo;' + (custom_button ? custom_button : '') + ';' + (callback ? callback : '') + ';');
        }
    },

    /* 메뉴 열기 */
    gotoMenu: function () {
        if (this.isAndroid()) {
            window.NextSBridge.gotoShowMenu();      //구현전
        } else {
            this._callApp('show_menu;');
        }
    },

    /* 대화방 가기 */
    gotoChat: function (emp_seq) {
        if (this.isAndroid()) {
            window.NextSBridge.gotoChat();          //구현전
        } else {
            this._callApp('goto;chat_send;emp_seq=' + (emp_seq ? emp_seq : '') + ';');
        }
    },

    /********************************************/
    /* exit                                     */
    /********************************************/


    /* WebView 종료 */
    exitWeb: function () {
        if (this.isAndroid()) {
            window.NextSBridge.exitWeb();
        } else {
            this._callApp('exit;Web;');
        }
    },

    /* 로딩화면 제거 */
    exitLoad: function () {
        if (this.isAndroid()) {
            /**
            * 안드로이드에서는 해당 동작을 구현해놓지 않았기 때문에 무시.
            */
            return;
        }
        this._callApp('exit;Load;');
    },


    /********************************************/
    /* Common Navigation                        */
    /********************************************/

    /* 기본정보 요청 */
    callBaseData: function (callback) {
        if (NextS.runtime) return;
        NextS.runtime = true;
        try { setMask(); } catch (e) { }
        this.callback = callback;
        NextS.callback = callback;
        if (NextS.options.testMode) {
            if (NextS.callback) eval(NextS.callback)();
            NextS.callback = null;
            return;
        }

        if (this.isAndroid()) {
            var strBaseData = window.NextSBridge.callBaseData();
            _setBaseData(strBaseData);
        } else {
            // ios8 관련 수정
            if (NextS.options.iosVersion >= 8) {
                // ios 버젼이 8 이상일때.
                this._callApp(encodeURIComponent('call;BaseData;_setBaseData;'));

                // 인코딩해서 응답이 오는지 확인후 안오면 재요청.
                callBaseDataReRequest();
            } else {
                // ios 버젼이 8보다 작을때 (안드로이드 포함.)
                this._callApp('call;BaseData;_setBaseData;');
            }
        }
    },

    /* 기본데이타 세팅 */
    //        _setBaseData: function (sRst) {
    //            this.baseData = JSON.parse(sRst);
    //            localStorage.baseData = sRst;
    //            if (this.callback) eval(this.callback);
    //        },

    /* 서버에 데이터 요청 (New) */
    callServer: function (gwPath, jParam, callback, errCallback, cacheTF) {
        //console.log(gwPath + ' : 요청', 5000);
        try { setMask(); } catch (e) { }

        var _timeStamp = callback + this._timeStamp();
        var pId = this._urlTest(gwPath) ? '' : gwPath;
        gwPath = this._urlTest(gwPath) ? gwPath : this.baseData.serverUrl;
        //this.tId = this._timeStamp();
        //this.gwPath = NextS.baseData.serverUrl + '/' + gwPath;
        this.jsonParam = this._setParam(pId, jParam, _timeStamp);
        this.callback = callback;
        this.errCallback = errCallback;

        if (cacheTF && this.dbUse) this._checkCache(_timeStamp, gwPath, this.jsonParam, callback, errCallback);
        else this._callServer(_timeStamp, gwPath, this.jsonParam, callback, errCallback);
    },

    /* 서버에 데이터 요청 (gw) */
    callGW: function (pId, jParam, callback, errCallback, cacheTF) {
        try {
            var tId = callback + this._timeStamp();
            this.jsonParam = this._setParamGW(tId, pId, jParam);
            this.callback = callback;
            this.errCallback = errCallback;

            this._callGW(tId, pId, this.jsonParam, callback, errCallback);
        } catch (e) {
            alert('error call gw');
        }
    },

    /* 앱에 데이터 요청 */
    callAPP: function (pId, jParam, callback) {
        jParam.appCode = 'MsgSend';
        this.etcData = jParam;
        this.callback = callback;

        /**
        * 현재는 안드로이드 앱에서 데이터 가져오는 부분이 미구현되어 있기 때문에 일단 무시처리함.
        */
        if (this.isAndroid()) {
            return;
        }
        this._callApp('call;App;' + pId + ';' + '_getData' + ';' + '_setData' + ';');
    },

    /* 서버에 데이터 요청 (gw) */
    callSM: function (pId, hParam, bParam, callback, errCallback, cacheTF) {
        //console.log(gwPath + ' : 요청', 5000);

        try { /*setMask();*/ } catch (e) { }

        var _timeStamp = callback + this._timeStamp();
        //var pId = this._urlTest(gwPath) ? '' : gwPath;
        //gwPath = this._urlTest(gwPath) ? gwPath : this.baseData.serverUrl;
        //this.tId = this._timeStamp();
        //this.gwPath = NextS.baseData.serverUrl + '/' + gwPath;
        this.jsonParam = this._setParamGW(pId, hParam, bParam, _timeStamp);
        //console.log('서버에 보내는 파람 = ' + JSON.stringify(this.jsonParam));
        this.callback = callback;
        this.errCallback = errCallback;

        //if (cacheTF && this.dbUse) this._checkCache(_timeStamp, gwPath, this.jsonParam, callback, errCallback);
        //else this._callServer(_timeStamp, gwPath, this.jsonParam, callback, errCallback);
        this._callSM(_timeStamp, pId, this.jsonParam, callback, errCallback);
    },

    callBridge: function (jsonParam) {
        var param = jsonParam;
        if (typeof jsonParam != 'object') {
            try {
                param = JSON.parse(jsonParam);
            } catch (e) {
                console.log("Convert to json object failed." + e);
                return;
            }
        }

        //callback 함수명을 가로채서 저장해두고(NextS.options.callback)
        //_setFnc2로 재 설정. window가 아닌 다른 객체에 저장해놓은 함수를
        //호출할 수 있게 하기 위해선 실제 비즈니스 로직의 callback함수 호출을
        //javascript에서 할 필요가 있음.
        NextS.memBridgeCallbackFnc = param.callback;
        param.callback = 'callbackBridge';

        param = JSON.stringify(param);

        if (this.isAndroid()) {
            window.NextSBridge.callBridge(param);
        } else {
            this._callApp('callBridge;' + param);
        }
    },

    callBarcode: function (callback) {
        //this.debug('[callBarcode] : param callback=' + callback);
        window.NextSBridge.callBarcode(callback);
    },

    _urlTest: function (url) {
        urlregex = /^(https?:\/\/)/;
        return urlregex.test(url);
    },

    /* Parameter 정의 */
    _setParam: function (pId, jParam, _timeStamp) {
        //console.log('_setParam : ' + JSON.stringify(jParam), 5000);
        var fParam = { "header": { "token": "", "companyId": "", "loginId": "", "deviceId": "", "pId": "", "tId": "" }, "body": {} };

        fParam.header.tId = _timeStamp;
        fParam.header.token = this.baseData.token;
        fParam.header.companyId = this.baseData.loginBase.companyId;
        fParam.header.loginId = this.baseData.loginBase.loginId;
        fParam.header.deviceId = this.baseData.loginBase.deviceId;
        fParam.header.pId = pId;
        fParam.body = jParam;

        return JSON.stringify(fParam);
    },

    /* Parameter 정의 (gw) */
    _setParamGW: function (tId, pId, jParam) {
        var fParam = { "header": {}, "body": {} };

        if (this.baseData.result.groupSeq == 'duzon') {
            fParam.header.mobileId = 'douzone'
        } else {
            fParam.header.mobileId = this.baseData.result.groupSeq;
        }
        
        fParam.header.loginId = this.baseData.result.loginUserId;
        fParam.header.token = this.baseData.result.token;
        fParam.header.tId = tId;
        fParam.header.pId = pId;
        fParam.header.osType = this.baseData.result.osType;
        fParam.header.appType = this.baseData.result.appType; //"22";
        fParam.body = jParam;
        //alert("[서버요청JSON] \n" + JSON.stringify(fParam));
        
        return JSON.stringify(fParam);
    },

    /* Parameter 정의 (gw) */
    _setParamSM: function (pId, hParam, bParam, _timeStamp) {

        //console.log('_setParam : ' + JSON.stringify(jParam), 5000);
        var fParam = { "header": { "token": "", "companyId": "", "userId": "", "osType": "", "programCd": "", "deviceId": "", "tId": "", "pId": "", "comCd": "", "placeCd": "", "cdIdx": "", "mnUnit": "", "arrT": "", "arrM": "", "chooseCompanyCd": "", "page": "" }, "body": {} };
        fParam.header.token = this.baseData.result.token;
        fParam.header.companyId = this.baseData.result.companyId;
        fParam.header.userId = this.baseData.result.userId;
        fParam.header.osType = this.baseData.result.osType;
        fParam.header.programCd = this.baseData.result.programCd;
        fParam.header.deviceId = this.baseData.result.deviceId;
        fParam.header.tId = _timeStamp;
        fParam.header.pId = pId;
        fParam.header.comCd = this.baseData.result.bizBaseData.bizInfoData.cdCom;
        fParam.header.placeCd = this.baseData.result.bizBaseData.bizInfoData.cdPlace;
        fParam.header.cdIdx = hParam.cdIdx;
        fParam.header.mnUnit = hParam.mnUnit;
        fParam.header.arrT = hParam.arrT;
        fParam.header.arrM = hParam.arrM;
        //        fParam.header.chooseCompanyCd = hParam.chooseCompanyCd;
        fParam.header.page = hParam.page;
        fParam.body = bParam;
        console.log("[서버요청JSON] \n" + JSON.stringify(fParam));

        return JSON.stringify(fParam);
    },

    /* Check Cashe */
    _checkCache: function (tId, gwPath, jsonParam, callback, errCallback) {
        //console.log(gwPath + ' : 캐시 체크 : ' + jsonParam, 5000);

        this._execSql("select callback, cache from worklist where path = ? AND param = ? AND state = 2 AND dt > datetime('now','-1 minutes');"
            , [gwPath, jsonParam]
            , function (t, r) {
                if (r.rows.length > 0) {
                    //console.log(gwPath + ' : 캐시가 적용됩니다.', 5000);
                    eval(r.rows.item(0).callback)(JSON.parse(r.rows.item(0).cache));
                    return;
                }
                NextS._callServer(tId, gwPath, jsonParam, callback, errCallback);
            }, function (t, e) {
                //console.log("select tId" + "\n\n" + e.message, 5000); 
            });

    },

    /* Server Call */
    // param 값만 {"h[a-zA-Z0-9_:"-|,]*|"[a-zA-Z0-9_]*":|[{|}|"|:|,]
    // param tId,기호 제외  "tID":[0-9]*}|"[a-zA-Z0-9_]*":|"|{|}|\\|,
    _callServer: function (tId, gwPath, jsonParam, callback, errCallback) {
        //alert("_callServer:" + gwPath + '?' + jsonParam);
        //console.log(gwPath + ' : 서버호출 시작 : ' + jsonParam, 5000);
        if (this.options.testMode) {

            if (this.dbUse) {
                this._execSql("insert into worklist(tId, path, param, rparam, callback, errCallback, state) values(?,?,?,?,?,?,?)"
                , [String(tId), gwPath, '', jsonParam, callback, errCallback, '1']
                , function () {
                    //console.log('call;Server;' + gwPath + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';',10000);
                }
                , function (t, e) {
                    //console.log(e.message, 5000);
                });

                this.rdb.push({ tId: tId, tData: { "gwPath": gwPath, "param": jsonParam, "callback": callback, "errCallback": errCallback} });

            }

            $.ajax({
                type: 'POST',
                datatype: "text",
                url: "/proxy",
                data: { 'url': gwPath, 'param': jsonParam },
                success: function (data) {
                    //                    alert("실제응답:" + data);
                    //                    data = { "resultCode": "0", "resultMessage": "성공하였습니다.", "tId": "1343024358", "result": { "checkYn": "Y", "appVersion": "0", "url": "http://www.naver.com", "notice": "테스트 입니다", "version": "1", "function": [{ "functionCode": "PROTOCOL0000", "enableYn": "Y"}], "protocol": [{ "taskCode": "TASK0000", "protocolCode": "PROTOCOL0000", "protocolUrl": "http://ssm.duzoncnt.com:8810/intro/Login" }, { "taskCode": "TASK0001", "protocolCode": "PROTOCOL0001", "protocolUrl": "/html/app.html"}]} };
                    //                    data.tId = tId;
                    //                    data.resultCode = "1";
                    //                    data = JSON.stringify(data);
                    _setFnc(data);
                },
                error: function (rst) { }
            });

            return;
        }

        if (this.dbUse) {
            this._execSql("insert into worklist(tId, path, param, rparam, callback, errCallback, state) values(?,?,?,?,?,?,?)"
                , [String(tId), gwPath, '', jsonParam, callback, errCallback, '1']
                , function () {
                    // console.log('call;Server;' + gwPath + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';');
                    NextS._callApp('call;Server;' + gwPath + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';');
                }
                , function (t, e) {
                    //console.log(e.message, 5000);
                });

            this.rdb.push({ tId: tId, tData: { "gwPath": gwPath, "param": jsonParam, "callback": callback, "errCallback": errCallback} });

            return;
        }

        this._callApp('call;Server;' + gwPath + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';');
    },

    /* GW Call */
    // param 값만 {"h[a-zA-Z0-9_:"-|,]*|"[a-zA-Z0-9_]*":|[{|}|"|:|,]
    // param tId,기호 제외  "tID":[0-9]*}|"[a-zA-Z0-9_]*":|"|{|}|\\|,
    _callGW: function (tId, pId, jsonParam, callback, errCallback) {

        if (localStorage.getItem("protocolList")) {// && pId != 'ES01') {
            if (this.dbUse) {
                this._execSql("insert into worklist(tId, path, param, rparam, callback, errCallback, state) values(?,?,?,?,?,?,?)"
                , [String(tId), pId, '', jsonParam, callback, errCallback, '1']
                , function () {
                }
                , function (t, e) {
                });
                this.rdb.push({ tId: tId, tData: { "gwPath": pId, "param": jsonParam, "callback": callback, "errCallback": errCallback} });
            }

            // 앱로그 테스트용 추가 (2014.03.20, 차민수)
            // console.log('log://' + pId + ';' + jsonParam);
            $.ajax({
                type: 'POST',
                dataType: "text",
                contentType: "application/json",
                url: getProtocolUrl(pId),
                data: jsonParam,
                async: true,
                timeout: 60000,
                success: function (data) {
                    _setFnc(data);
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    //data = { "resultCode": "1", "resultMessage": "네트워크가 불안정 합니다.\n(" + ajaxOptions + ")", "tId": "", "nowDateTime": "", "result": {} }
                    //_setFnc(JSON.stringify(data));
                    alert('_call GW error');
                }

            });

            return;
        }

        if (this.dbUse) {
            this._execSql("insert into worklist(tId, path, param, rparam, callback, errCallback, state) values(?,?,?,?,?,?,?)"
                , [String(tId), pId, '', jsonParam, callback, errCallback, '1']
                , function () {
                    //console.log('call;Server;' + gwPath + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';');
                    NextS._callApp('call;GW;' + pId + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';');
                    //console.log(pId + ' _callGW(protocolList-X, dbUse=true, insert into worklist) - Suc : ');
                }
                , function (t, e) {
                    //console.log(pId + ' _callGW(protocolList-X, dbUse=true, insert into worklist) - Err : ' + e.message);
                });

            this.rdb.push({ tId: tId, tData: { "gwPath": pId, "param": jsonParam, "callback": callback, "errCallback": errCallback} });

            return;
        }

        //console.log('_callGW(_callApp call) - Suc : ' + pId + '(tId : ' + tId + ')');
        this._callApp('call;GW;' + pId + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';');
    },

    /* 보류!!!
    _getFnc: function () {
    try {   //Android용 호출
    object.returnValue(this.jsonParam);
    } catch (e) { }

    return this.jsonParam;
    },

    _setFnc: function (sRst) {
    var jRst = JSON.parse(sRst);

    eval(this.callback)(jRst);
    },
    */

    /* GPS정보 */
    callGps: function (callback) {
        if (this.isAndroid()) {
            var gpsValue = window.NextSBridge.callGps();
            callback(gpsValue);
        } else {
            this._callApp('call;Gps;' + callback + ';');
        }
    },


    /********************************************/
    /* UC Navigation                            */
    /********************************************/

    /* UC 이동 */
    gotoUC: function (cd) {

        if (this.isAndroid()) {
            window.NextSBridge.gotoUC(cd);
        } else {
            this._callApp('goto;UC;' + cd + ';');
        }
    },

    /* 모바일 그룹웨어 이동 */
    gotoMgw: function () {
        this._callApp('goto;Mgw;');
    },

    /* 조직도 이동 */
    gotoOrg: function () {
        this._callApp('goto;Org;');
    },

    /* 쪽지 이동 */
    gotoMsg: function (key) {
        this._callApp('goto;Msg;' + key + ';');
    },

    /* 쪽지 쓰기로 이동 */
    gotoMsgSend: function (tid, tnm, tdp, tco, tmsg) {
        var jData = {};
        jData.ID = tid;
        jData.NM = tnm;
        jData.DEPID = tdp;
        jData.COMPID = tco;
        jData.MSG = (tmsg ? tmsg : '');
        jData.appCode = 'gotoMsgSend';
        this.etcData = jData;
        this._callApp('goto;MsgSend;_getData;');
    },

    /* 조직도 이름 검색 */
    callOrgSrch: function (tnm, callback) {
        var jData = {};
        jData.NM = tnm;
        jData.appCode = 'callOrgSrch';
        //alert(JSON.stringify(jData));
        this.callback = callback;
        this.etcData = jData;
        this._callApp('call;OrgSrch;_getData;_setData;');
    },


    /* 조직도 이름 검색 화면이동 */
    gotoOrgSrch: function (tid, tnm, callback) {
        var jData = {};
        jData.ID = tid;
        jData.NM = tnm;
        jData.appCode = 'gotoOrgSrch';
        //alert(JSON.stringify(jData));
        this.callback = callback;
        this.etcData = jData;

        if (NextS.isAndroid()) {
            window.NextSBridge.gotoOrgSrch(JSON.stringify(jData));
        } else {
            this._callApp('goto;OrgSrch;_getData;');
        }
    },


    /* 이메일 쓰기로 이동 */
    gotoEmailSend: function (tEmail, tSubject, tContents) {
        var jData = {};
        jData.EMAIL = tEmail;
        jData.SUBJECT = (tSubject ? tSubject : '');
        jData.CONTENTS = (tContents ? tContents : '');
        jData.appCode = 'gotoEmailSend';
        this.etcData = jData;

        if (NextS.isAndroid()) {
            window.NextSBridge.gotoEmailSend(JSON.stringify(jData));
        } else {
            this._callApp('goto;EmailSend;_getData;');
        }
    },



    /********************************************/
    /* Common Function                          */
    /********************************************/

    /* Application Call */
    _callApp: function (cmd) {

        if (this.options.testMode) {
            console.log('app://' + cmd, 5000);
            return;
        }

        //console.log('app://' + cmd, 5000);
        console.log('app://' + cmd);

        // ios8 관련 수정 => baseData를 인코딩으로 요청하여 성공한 경우 이후 요청도 인코딩...
        if (cmd.indexOf("_setBaseData") < 0 && NextS.baseCallFalg == 3) {
            cmd = encodeURIComponent(cmd);
        }

        location.href = 'app://' + cmd;
    },

	// --------------------------------------------------------------------------- //
	// 신규코드
	//
	// json 포맷 call 요청(iOS)
	// --------------------------------------------------------------------------- //
    _callAppByJsonFormat : function( jsonObj ) {

		if (this.options.testMode) {
			return;
		}

		function _base64Encode( str ) {

			return btoa( unescape( encodeURIComponent( str ) ) );
		}

		function _base64Decode( base64Str ) {

			return decodeURIComponent( escape( atob( base64Str ) ) );
		}


		// 임시 주석 - 내용 확인 후 설정할 것
		//
        // ios8 관련 수정 => baseData를 인코딩으로 요청하여 성공한 경우 이후 요청도 인코딩...
		//if (cmd.indexOf("_setBaseData") < 0 && NextS.baseCallFalg == 3) {
		//	cmd = encodeURIComponent(cmd);
		//}


		var jsonStr = JSON.stringify( jsonObj );
		var base64Str = _base64Encode( jsonStr );
		location.href = 'nexts://' + base64Str;
		// 디코딩 사용하게 될 경우가 있다면 아래 함수 사용할 것
		//var decodeStr = _base64Decode( base64Str );
		//console.log('decode : ' + decodeStr);
    },

    /* callback 처리 */
    _callback: function () {

    },

	/* 기본데이타 조회 */
    getBaseData: function (key) {
        var retData;
        try {
            retData = this.baseData.result[key];
        } catch (e) {
            //console.log("error == > " + key, 5000);
        }

        return retData;
    },

    setBaseData: function (key, val, callback) {
        try {
            //alert(key);
            //alert(eval('this.baseData.'+key));
            this.baseData.result[key] = val;
            localStorage.baseData = JSON.stringify(this.baseData);

            if (callback) eval(callback)();
        } catch (e) {
            //console.log("error == > " + key, 5000);
        }
    },


    /* DB생성 */
    _initDB: function () {
        if (!openDatabase) {
            //console.log("WebSQL 사용불가", 5000);
            NextS.dbUse = false;
            return;
        }
        //this.db = openDatabase('NSDB', '1.0', 'NSDB', '1*1024*1024');
        try {
            NextS.db = openDatabase('NSDB', '', 'NSDB', '1048576');
            var dbVer = "2.0";

            switch (NextS.db.version) {
                case dbVer: NextS.dbUse = true; break;
                default:
                    this._execSql('DROP TRIGGER trg_worklist_insert', [], function () {
                        //console.log('DROP TRIGGER OK!', 5000); 
                    }, function (t, e) {
                        //console.log("DROP TRIGGER" + "\n\n" + e.message, 5000);
                    });
                    this._execSql('DROP TABLE worklist', [], function () {
                        //console.log('DROP TABLE OK!', 5000);
                    }, function (t, e) {
                        //console.log("DROP TABLE" + "\n\n" + e.message, 5000); 
                    });
                    this._execSql('DROP TABLE protocolList', [], function () {
                        //console.log('DROP TABLE OK!', 5000);
                    }, function (t, e) {
                        //console.log("DROP TABLE" + "\n\n" + e.message, 5000); 
                    });
                    //NextS.db.version = dbVer;
                    NextS.db.changeVersion(NextS.db.version, dbVer, function (t) { NextS._initTable(); });
            }

        } catch (e) {
            this.dbUse = false;
            //alert("_initDB Error : " + e.Message, 5000);
        }
    },

    /* Table생성 */
    _initTable: function () {
        try {
            this._execSql('CREATE TABLE IF NOT EXISTS worklist(tId TEXT, path TEXT, param TEXT, rparam TEXT, callback TEXT, errCallback TEXT, dt DATETIME DEFAULT CURRENT_TIMESTAMP, state INTEGER, cache TEXT);'
            //                + ' CREATE TRIGGER trg_worklist_insert BEFORE INSERT ON worklist FOR EACH ROW BEGIN DELETE FROM worklist WHERE path = NEW.path AND callback = NEW.callback; END;'
            //+ ' CREATE TABLE IF NOT EXISTS protocolList(protocalId TEXT, protocalUrl TEXT);'
                , [], function () {
                    NextS._initTrigger();
                    //NextS._initTable2();
                }, function (t, e) {
                    //alert("TABLE CREATE" + "\n\n" + e.message, 5000);
                });
            this._execSql('CREATE TABLE IF NOT EXISTS protocolList(protocolId TEXT, protocolUrl TEXT);'
                            , [], function () {
                                //
                            }, function (t, e) {
                                //alert("TABLE CREATE" + "\n\n" + e.message, 5000);
                            });
        } catch (e) { NextS.dbUse = false; }

    },
    _initTrigger: function () {
        try {
            NextS._execSql('CREATE TRIGGER IF NOT EXISTS trg_worklist_insert BEFORE INSERT ON worklist FOR EACH ROW BEGIN DELETE FROM worklist WHERE path = NEW.path AND param = NEW.param; END;'
                , [], function () {
                    NextS.dbUse = true;
                }, function (t, e) {
                    //alert("CREATE TRIGGER" + "\n\n" + e.message, 5000); 
                });
        } catch (e) { NextS.dbUse = false; }
    },


    /* executeSql */
    _execSql: function (sql, data, onSuccess, onError) {

        if (!openDatabase) {
            //console.log("WebSQL 사용불가", 5000);
            //alert("WebSQL 사용불가");
            return;
        }
        this.db.transaction(function (tx) {
            //alert(sql);
            tx.executeSql(sql, data, onSuccess, onError);
        });
    },

    /* TimeStamp */
    _timeStamp: function () {
        return Math.floor(new Date().getTime() / 1000);
    },


    _getWidth: function () {
        xWidth = null;
        if (window.screen != null)
            xWidth = window.screen.availWidth;

        if (window.innerWidth != null)
            xWidth = window.innerWidth;

        if (document.body != null)
            xWidth = document.body.clientWidth;

		// 원본코드
		//if ($('.ui-mobile') != null)
		//	xWidth = parseInt($('.ui-mobile').css('width'));
		//
		// 변경코드
		if( $('.ui-mobile').length > 0 ) {
			xWidth = parseInt($('.ui-mobile').css('width'));
		}


        return xWidth;
    },

    _getHeight: function () {
        xHeight = null;
        if (window.screen != null)
            xHeight = window.screen.availHeight;

        if (window.innerHeight != null)
            xHeight = window.innerHeight;

        if (document.body != null)
            xHeight = document.body.clientHeight;

		// 원본코드
		//if ($('.ui-mobile') != null)
		//	xHeight = parseInt($('.ui-mobile').css('height'));
		//
		// 변경코드
		if( $('.ui-mobile').length > 0 ) {
			xHeight = parseInt($('.ui-mobile').css('height'));
		}

        return xHeight;
    }
}

NextS = new NEXTS;



var o = {
    testMode: (location.host.indexOf(NextS.options.testUrl) > -1 ? true : false)
};

NextS.init(o);
NextS._initDB();

_setBaseData(localStorage.baseData, true);

//if (NextS.options.testMode) _setBaseData('{"resultCode":"0","resultMessage":"성공하였습니다.","token":"942824d9-6279-4e51-81a7-a68bd29abb5f","loginBase":{"companyId":"dev","loginId":"cjrain","programType":"INITECH","appVersion":"130","osType":"IOS","osVersion":"5.000000","model":"iPad","password":"1111","deviceId":"F57EDA9B-3539-4752-8F2E-187BBF122018","latitude":0,"longitude":0},"serverUrl":"http://ssm.duzoncnt.com:8810/Initech","result":{"pushYn":"N","pushValidYn":"N","contentVersion":[{"contentType":"js","version":"41","path":"/js","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012071611242662.zip"},{"contentType":"image","version":"6","path":"/image","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012070311335347.zip"},{"contentType":"html","version":"34","path":"/html","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012071610064909.zip"},{"contentType":"css","version":"4","path":"/css","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012071610065573.zip"}],"DataVersion":[]}}');
//if (NextS.options.testMode) _setBaseData('{"result" : {"pushAnswerYn" : "1","pushYnInfo" : null,"ucCd" : null,"bizBoxSyncData" : {"companyId" : "7","deptId" : "2547","grpId" : "3","userId" : "2542","bizBoxCompanyList" : [ {"companyId" : "7","companyNm" : "더존Next","deptId" : "2547"} ]},"xTalkSyncData" : {},"nonUc" : {},"userId" : "pcsgod","userName" : "","orgChartYn" : "1","bizBaseData" : {"orderShippedYn" : "0","compList" : [ {"compCd" : "1001","compName" : "(주)더존넥스트"}, {"compCd" : "8001","compName" : "키컴"}, {"compCd" : "8002","compName" : "신제품개발부"}, {"compCd" : "8003","compName" : "전자금융사업본부"}, {"compCd" : "8004","compName" : "융합전략기획부"}, {"compCd" : "8005","compName" : "인사관리팀"}, {"compCd" : "8007","compName" : "IS연구소"}, {"compCd" : "8008","compName" : "IDC사업부"}, {"compCd" : "8009","compName" : "IDC운영팀"}, {"compCd" : "8010","compName" : "경영서비스팀"}, {"compCd" : "8011","compName" : "채권법무팀"}, {"compCd" : "8012","compName" : "재경팀"}, {"compCd" : "8013","compName" : "총무／구매팀"}, {"compCd" : "8014","compName" : "홍보부"}, {"compCd" : "8015","compName" : "프로젝트관리팀"} ],"bizInfoData" : {"prdAccounts" : "10","daAccbegin" : "20130101","daAccend" : "20131231","prdAccountsYn" : null,"cdCom" : "1001","nmCom" : "(주)더존넥스트","cdPlace" : "1000|","nmPlace" : "(주)더존넥스트|","erpType" : "2"}},"contentVersion" : [ {"contentType" : "*","version" : "1","path" : "/APP3","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716543472.zip"}, {"contentType" : "*","version" : "1","path" : "/APP2","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716543200.zip"}, {"contentType" : "*","version" : "1","path" : "/APP1","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716542869.zip"}, {"contentType" : "*","version" : "1","path" : "/APP","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716542579.zip"} ],"dataVersion" : [ ],"token" : "4BB6AB52-B73A-4B6C-B385-4FF7A7210F82","osType" : "02","appVer" : "1.0","deviceId" : "ffffffff-bb32-4e4e-0033-c5870033c587","programCd" : "01"},"tId" : "p1","resultCode" : "0","resultMessage" : "성공하였습니다."}');

function _setBaseData(sRst, localStorageUse) {
    // ios8 관련 수정 : ios버젼이 8이상이면서 localStorage.baseData를 이용한 호출이 아닌 경우..
    if (NextS.options.iosVersion >= 8 && !localStorageUse) {

        if (NextS.baseCallFalg == 1) {
            // 인코딩 요청으로 응답을 받은 경우
            NextS.baseCallFalg = 3;
            localStorage.setItem("baseCallFalg", 3);
        }
        else if (NextS.baseCallFalg == 2) {
            // 인코딩 없이 응답을 받은 경우
            //NextS.baseCallFalg = 4;
            localStorage.setItem("baseCallFalg", 1);
        }
    }
    try {
        NextS.baseData = JSON.parse(sRst);
        localStorage.baseData = sRst;
        if (NextS.callback != null) eval(NextS.callback)();
    } catch (e) {
    }
}

function _getFnc(tId) {

    var jsonParam = NextS.jsonParam;

    if (NextS.dbUse) {
        NextS._execSql("select path, rparam from worklist where tId = ?;", [tId], function (t, r) {
            if (r.rows.length > 0) {
                //console.log(r.rows.item(0).path + ' : param App전송 : ' + r.rows.item(0).rparam, 5000);
                jsonParam = r.rows.item(0).rparam;
                //alert('_getFnc : \n\n' + r.rows.item(0).rparam);
            } else {
                //console.log('??? : param App전송 못보냄', 5000);
            }
        }, function (t, e) {
            //console.log("select getFnc" + "\n\n" + e.message, 5000);
        });

        /*
        for (var i in NextS.rdb) {
        if (NextS.rdb[i].tId == tId) {
        jsonParam = NextS.rdb[i].tData.param;
        //NextS.rdb[i].pop();
        //console.log(JSON.stringify(NextS.rdb), 10000);
        }
        }
        */
    }
    try {   //Android용 호출
        object.returnValue(jsonParam);
    } catch (e) { }

    //console.log(' : param App전송완료 : ' + jsonParam, 5000);

    return jsonParam;
}

function _getButton() {
    var jsonParam = NextS.jsonParam;

    try {   //Android용 호출
        object.returnSelButton(jsonParam);
    } catch (e) { }

    return jsonParam;
}

function _getWheel() {
    var jsonParam = NextS.jsonParam;

    try {   //Android용 호출
        object.returnSelWheel(jsonParam);
    } catch (e) { }

    return jsonParam;
}

function _setData(sRst) {
    //alert('setData = ' + sRst);
    eval(NextS.callback)(sRst);
}

function _setFnc(sRst) {
    //alert('_setFnc : ' + sRst);

    NextS.runtime = false;

    var jRst = JSON.parse(sRst);
    var path = '';
    //try { clearMask(); } catch (e) { }
    if (jRst.resultCode != "0") {

        //로그아웃 발생시(UC6003), 다른기기 접속시(UC6001) ----- 자체 로그아웃 함수
        //        if ((jRst.resultCode == "UC6003" || jRst.resultCode == "UC6001") && logoutFnc) {
        //            eval(logoutFnc)(jRst.resultMessage);
        //                return;
        //        }

        if (jRst.resultMessage.length > 0 && NextS.options.errMode) {
            localStorage.setItem("errCode", jRst.resultCode);
            console.log('[NEXTS] v1.0.5 err code [' + jRst.resultCode + '] err msg : [' + jRst.resultMessage + ']');
            console.log(JSON.stringify(jRst))
            if (typeof (_ajaxErrFlow) === 'function') {
                _ajaxErrFlow(jRst.resultCode, jRst.resultMessage);
            }
            if (fncCloseLoadingMask) {
                fncCloseLoadingMask();
            }
        }

        //로그아웃 발생시(UC6003), 다른기기 접속시(UC6001) ----- 공용 로그아웃 함수
        if (jRst.resultCode == "UC6003" || jRst.resultCode == "UC6001" || jRst.resultCode == "COM0015") {//추후 UC6001 사용 안하고 COM0015로 사용할 예정
            NextS.exitLogin();
            //            NextS.gotoHome('fncMainLogout');
            return;
        }

        if (NextS.dbUse) {
            NextS._execSql("select errCallback from worklist where tId = ?;", [jRst.tId], function (t, r) {
                if (r.rows.length > 0) {
                    //console.log(r.rows.item(0).path + ' : param App전송 : ' + r.rows.item(0).rparam, 5000);
                    try {
                        eval(r.rows.item(0).errCallback)(jRst);
                    } catch (e) {
                        //alert('_setFnc 시 Error 발생!!');
                    }
                } else {
                    eval(NextS.errCallback)(jRst);
                    //console.log('??? : param App전송 못보냄', 5000);
                }
            }, function (t, e) {
                //console.log("select getFnc" + "\n\n" + e.message, 5000);
            });

        } else {
            eval(NextS.errCallback)(jRst);
        }

        try { clearMask(); } catch (e) { }

        return;
    }

    if (!NextS.dbUse) {
        eval(NextS.callback)(jRst);
        return;
    }

    NextS._execSql("select path, callback from worklist where tId = ?;", [jRst.tId], function (t, r) {
        if (r.rows.length > 0) {
            //console.log(r.rows.item(0).path + ' : callback 보내기 : ' + r.rows.item(0).callback, 10000);
            path = r.rows.item(0).path;
            eval(r.rows.item(0).callback)(jRst);
        } else {
            //console.log('??? : callback 못보냄', 5000);
            eval(NextS.callback)(jRst);
        }
    }, function (t, e) {
        //console.log("select callback" + "\n\n" + e.message, 5000);
    });


    NextS._execSql("update worklist set cache = ?, state = 2, dt = datetime('now') where tId = ?;", [sRst, jRst.tId], function () {
        //console.log(path + ' : cache 저장 : OK!!!', 5000);
    }, function (t, e) {
        //console.log(path + ' : cache 저장 오류 : ' + e.message, 5000);
    });

    //eval(NextS.callback)(jRst);
}

function callbackBridge(data) {
    //alert('app response type=' + (typeof data) + ', data=' + data);
    var objData = data;
    if (typeof data == 'string') {
        objData = JSON.parse(data);
    }

    var callbackNm = NextS.memBridgeCallbackFnc;
    if (callbackNm.indexOf('.') != -1) {                //함수명에 '.'이 있으면 특정 object에 있는 함수라고 가정
        //namespace.obj1.obj2.function 과 같은 형태
        var arrCallPath = callbackNm.split('.');
        var curObj = window;                            //window에서 먼저 namespace 객체를 찾고
        for (var i = 0; i < arrCallPath.length; i++) {  //loop를 돌면서 마지막 항목까지 객체를 타고 들어감.
            curObj = curObj[arrCallPath[i]];
            if (!curObj) {
                console.log('지정한 namespace 경로에 해당 함수를 찾을 수 없음. path=' + callbackNm);
                return null;
            }
        }
        //loop가 끝나면 마지막에 있는 함수 호출.
        curObj(objData);
    } else {
        window[callbackNm](objData);
    }
}

function _getData() {
    //alert('_getDate() = ' + JSON.stringify(NextS.etcData)); 
    jsonParam = JSON.stringify(NextS.etcData);
    try {   //Android용 호출
        object.returnAppData(jsonParam);
    } catch (e) { }
    return jsonParam;
}

function androidBack() {
    NextS.gotoBack(NextS.pathAndroidBack);
}

function getProtocolUrl(pid) {
    var protocolList = JSON.parse(localStorage.getItem("protocolList"));
    var pUrl = "";

    if (NextS.dbUse) {
        NextS._execSql("select protocolUrl from protocolList where protocolId = ?;", [pid], function (t, r) {
            if (r.rows.length > 0) {
                pUrl = r.rows.item(0).protocolUrl;
                //alert('getProtocolUrl : ' + pUrl);
                return pUrl;
            }
        }, function (t, e) {
            //console.log("select getFnc" + "\n\n" + e.message, 5000);
        });
    }

    for (i = 0; i < protocolList.length; i++) {
        if (protocolList[i].protocolId == pid) {
            pUrl = protocolList[i].protocolUrl;
            break;
        }
    }

    return pUrl;
}

// ios8 관련 수정 : 기본정보 요청 응답 확인 및 재요청
function callBaseDataReRequest() {

    // 인코딩 요청으로 응답을 받은경우
    if (NextS.baseCallFalg == 3) {
        return;
    }

    setTimeout(function () {
        // alert('setTimeout');

        // 인코딩 요청으로 응답을 받지 못한경우
        if (NextS.baseCallFalg == 1) {

            NextS.baseCallFalg = 2; // 인코딩 없이 재요청
            // console.log("인코딩 없이 재요청 >> test : NextS._callApp('call;BaseData;_setBaseData;');");
            // alert("인코딩 없이 재요청 >> test : NextS._callApp('call;BaseData;_setBaseData;');");
            NextS._callApp('call;BaseData;_setBaseData;');

        }
    }, 1000);     // 문제 발생시 시간조절 필요
}

// ios8 관련 수정: ios 버젼 체크
function iosCheckVersion() {
    var start = ua.indexOf('os');

    if (/(iphone|ipad)/i.test(ua) && start > -1) {
        return window.Number(ua.substr(start + 3, 3).replace('_', '.'));
    }

    return 0;
}

//if (openDatabase) { NextS.dbUse = true; }