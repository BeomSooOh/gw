
//==========================================================================
// Web SQL Database 관련 함수
//==========================================================================

var NextS;
var ua = navigator.userAgent.toLowerCase(); _setBaseData

if (typeof (NEXTS) == 'undefined') NEXTS = {};

//$.support.cors = true;
//$.mobile.allowCrossDomainPages = true;

NEXTS = function () {
    var t = this;
    t.options = {
        os: { iphone: /iphone/.test(ua), ipad: /ipad/.test(ua), android: /android/.test(ua) },
        mDev: (ua.match(/iphone|ipod|android|windows ce|blackberry|symbian|windows phone|webos|opera mini|opera mobi|polaris|iemobile|lgtelecom|nokia|sonyericsson/i) != null || ua.match(/lg|samsung|samsung/) != null ? true : false),
        width: screen.availWidth,
        height: screen.availHeight,
        testUrl: 'localhost',
        testMode: false,
        errMode: true
    }
}

NEXTS.prototype = {
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

    init: function (o) {
        var to = this.options;

        to.width = this._getWidth();
        to.height = this._getHeight();

        for (var k in o) {
            to[k] = o[k];
            if (k == 'testUrl') to.testMode = (location.host.indexOf(to.testUrl) > -1 ? true : false)
        }
    },


    /********************************************/
    /* goto                                     */
    /********************************************/

    /* 홈이동 */
    gotoHome: function (p) {
        this._callApp('goto;Home;' + (p ? p : '') + ';');
    },

    /* Application 이동 */
    gotoApp: function () {
        this._callApp('goto;App;');
    },

    /* 특정 HybridWeb으로 이동 */
    gotoPage: function (pgUrl, push, PL, PbgUrl, LbgUrl, barColor) {
        if (this.options.testMode) {
            location.href = '/WebApp' + pgUrl;
            return;
        }

        this._callApp('goto;Page;' + pgUrl + ';' + (push ? push : 'current') + ';' + (PL ? PL : '') + ';' + (PbgUrl ? PbgUrl : '') + ';' + (LbgUrl ? LbgUrl : '') + ';' + (barColor ? barColor : '') + ';');
    },

    /* Push된 WebView Pop 처리 */
    gotoPop: function (p) {
        this._callApp('goto;Pop;' + (p ? p : '') + ';');
    },

    /* 특정 URL로 이동 */
    gotoUrl: function (url, typ) {
        if (this.options.testMode) {
            location.href = url; return;
        }
        this._callApp('goto;Url;' + url + ';' + (typ ? typ : 'ex') + ';');
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
        this._callApp('goto;File;' + ext + ';' + encodeURI(path) + ';' + encodeURI(fileNm) + ';');
    },

    /* 설정 이동 */
    gotoSet: function () {
        this._callApp('goto;Set;');
    },


    /********************************************/
    /* exit                                     */
    /********************************************/

    /* Application 종료 */
    exitApp: function () {
        this._callApp('exit;App;');
    },

    /* 로그아웃 */
    exitLogin: function () {
        this._callApp('exit;Login;');
    },

    /* WebView 종료 */
    exitWeb: function () {
        this._callApp('exit;Web;');
    },

    /* 로딩화면 제거 */
    exitLoad: function () {
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

        if (NextS.options.testMode) {
            if (NextS.callback) eval(NextS.callback)();
            NextS.callback = null;
            return;
        }
        this._callApp('call;BaseData;_setBaseData;');
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
        //console.log(gwPath + ' : 요청', 5000);

        try { /*setMask();*/ } catch (e) { }

        var tId = callback + this._timeStamp();
        this.jsonParam = this._setParamGW(tId, pId, jParam);
        this.callback = callback;
        this.errCallback = errCallback;
        //if (cacheTF && this.dbUse) this._checkCache(tId, gwPath, this.jsonParam, callback, errCallback);
        //else this._callServer(tId, gwPath, this.jsonParam, callback, errCallback);
        this._callGW(tId, pId, this.jsonParam, callback, errCallback);
    },

    /* 앱에 데이터 요청 */
    callAPP: function (pId, jParam, callback) {
        jParam.appCode = 'MsgSend';
        this.etcData = jParam;
        this.callback = callback;

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
        fParam.header.token = this.baseData.result.token;
        fParam.header.companyId = this.baseData.result.companyId;
        fParam.header.userId = this.baseData.result.userId;
        fParam.header.osType = this.baseData.result.osType;
        fParam.header.programCd = this.baseData.result.programCd;
        fParam.header.deviceId = this.baseData.result.deviceId;
        fParam.header.tId = tId;
        fParam.header.pId = pId;
        fParam.body = jParam;
        //console.log("[서버요청JSON] \n" + JSON.stringify(fParam));
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
                    //console.log('call;Server;' + gwPath + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';');
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
        //console.log("_callServer:" + pId + '?' + jsonParam);
        //alert(jsonParam);
        //console.log(gwPath + ' : 서버호출 시작 : ' + jsonParam, 5000);
        if (localStorage.getItem("protocolList")) {// && pId != 'ES01') {
            if (this.dbUse) {
                this._execSql("insert into worklist(tId, path, param, rparam, callback, errCallback, state) values(?,?,?,?,?,?,?)"
                , [String(tId), pId, '', jsonParam, callback, errCallback, '1']
                , function () {
                    //console.log('call;Server;' + gwPath + ';' + '_getFnc' + ';' + '_setFnc' + ';' + tId + ';',10000);
                    //console.log(pId + '. _callGW(protocolList, dbUse=true, insert into worklist) - Suc : ');
                }
                , function (t, e) {
                    //console.log(pId + ' _callGW(protocolList, dbUse=true, insert into worklist) - Err : ' + e.message);
                });

                this.rdb.push({ tId: tId, tData: { "gwPath": pId, "param": jsonParam, "callback": callback, "errCallback": errCallback} });

            }

            // 앱로그 테스트용 추가 (2014.03.20, 차민수)
            //if (!NextS.options.testMode) location.href = 'log://' + pId + ';' + jsonParam;
//            alert('log://' + pId + ';' + jsonParam);
            console.log('log://' + pId + ';' + jsonParam);
            $.ajax({
                type: 'POST',
                dataType: "text",
                contentType: "application/json",
                url: getProtocolUrl(pId),
                data: jsonParam,
                timeout: 60000,
                success: function (data) {
                    //if (!NextS.options.testMode) location.href = 'log://' + pId + ';_callGW - Success!!!';
                    //console.log('log://' + pId + ';_callGW(protocolList, ajax) - Success!!!');
                    _setFnc(data);
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    //if (!NextS.options.testMode) location.href = 'log://' + pId + ';_callGW - Error(' + xhr.status + ')!!!';
                    //console.log(pId + ' _callGW(ajaxOptions) - Err : ' + xhr.status);
                    //console.log(pId + ' _callGW(ajaxOptions) - Err : ' + ajaxOptions);
                    //console.log(pId + ' _callGW(protocolList, ajax) - Err : ' + thrownError);
                    //console.log(pId + ' _callGW(protocolList, ajax, callback) - Err : ' + errCallback);
                    //eval(errCallback)(data);

                    //data = { "resultCode": "1", "resultMessage": "네트워크가 불안정 합니다.\n(" + ajaxOptions + ")", "tId": "", "nowDateTime": "", "result": {} }
                    //_setFnc(JSON.stringify(data));
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
        this._callApp('call;Gps;' + callback + ';');
    },


    /********************************************/
    /* UC Navigation                            */
    /********************************************/

    /* UC 이동 */
    gotoUC: function (cd) {
        this._callApp('goto;UC;' + cd + ';');
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
        this._callApp('goto;OrgSrch;_getData;');
    },


    /* 이메일 쓰기로 이동 */
    gotoEmailSend: function (tEmail, tSubject, tContents) {
        var jData = {};
        jData.EMAIL = tEmail;
        jData.SUBJECT = (tSubject ? tSubject : '');
        jData.CONTENTS = (tContents ? tContents : '');
        jData.appCode = 'gotoEmailSend';
        this.etcData = jData;
        this._callApp('goto;EmailSend;_getData;');
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

        location.href = 'app://' + cmd;
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

    /* KeyValue 조회 */
    getValue: function (arrData, callback) {

        var jData = {};
        jData.key = arrData;
        jData.appCode = 'getValue';
        this.etcData = jData;
        this.callback = callback;
        this._callApp('get;Value;_getData;_setData');
    },

    /* KeyValue 세팅 */
    setValue: function (arrData, callback) {

        var jData = {};
        jData.key = arrData;
        jData.appCode = 'setValue';
        this.etcData = jData;
        this.callback = callback;
        this._callApp('set;Value;_getData;_setData');
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
            //console.log(sql);
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

        if ($('.ui-mobile') != null)
            xWidth = parseInt($('.ui-mobile').css('width'));

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

        if ($('.ui-mobile') != null)
            xHeight = parseInt($('.ui-mobile').css('height'));

        return xHeight;
    }
}

NextS = new NEXTS;



var o = {
    testMode: (location.host.indexOf(NextS.options.testUrl) > -1 ? true : false)
};

NextS.init(o);
NextS._initDB();
_setBaseData(localStorage.baseData);

//if (NextS.options.testMode) _setBaseData('{"resultCode":"0","resultMessage":"성공하였습니다.","token":"942824d9-6279-4e51-81a7-a68bd29abb5f","loginBase":{"companyId":"dev","loginId":"cjrain","programType":"INITECH","appVersion":"130","osType":"IOS","osVersion":"5.000000","model":"iPad","password":"1111","deviceId":"F57EDA9B-3539-4752-8F2E-187BBF122018","latitude":0,"longitude":0},"serverUrl":"http://ssm.duzoncnt.com:8810/Initech","result":{"pushYn":"N","pushValidYn":"N","contentVersion":[{"contentType":"js","version":"41","path":"/js","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012071611242662.zip"},{"contentType":"image","version":"6","path":"/image","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012070311335347.zip"},{"contentType":"html","version":"34","path":"/html","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012071610064909.zip"},{"contentType":"css","version":"4","path":"/css","contentUrl":"http://ssm.duzoncnt.com:8810/ZipFile/2012071610065573.zip"}],"DataVersion":[]}}');
//if (NextS.options.testMode) _setBaseData('{"result" : {"pushAnswerYn" : "1","pushYnInfo" : null,"ucCd" : null,"bizBoxSyncData" : {"companyId" : "7","deptId" : "2547","grpId" : "3","userId" : "2542","bizBoxCompanyList" : [ {"companyId" : "7","companyNm" : "더존Next","deptId" : "2547"} ]},"xTalkSyncData" : {},"nonUc" : {},"userId" : "pcsgod","userName" : "","orgChartYn" : "1","bizBaseData" : {"orderShippedYn" : "0","compList" : [ {"compCd" : "1001","compName" : "(주)더존넥스트"}, {"compCd" : "8001","compName" : "키컴"}, {"compCd" : "8002","compName" : "신제품개발부"}, {"compCd" : "8003","compName" : "전자금융사업본부"}, {"compCd" : "8004","compName" : "융합전략기획부"}, {"compCd" : "8005","compName" : "인사관리팀"}, {"compCd" : "8007","compName" : "IS연구소"}, {"compCd" : "8008","compName" : "IDC사업부"}, {"compCd" : "8009","compName" : "IDC운영팀"}, {"compCd" : "8010","compName" : "경영서비스팀"}, {"compCd" : "8011","compName" : "채권법무팀"}, {"compCd" : "8012","compName" : "재경팀"}, {"compCd" : "8013","compName" : "총무／구매팀"}, {"compCd" : "8014","compName" : "홍보부"}, {"compCd" : "8015","compName" : "프로젝트관리팀"} ],"bizInfoData" : {"prdAccounts" : "10","daAccbegin" : "20130101","daAccend" : "20131231","prdAccountsYn" : null,"cdCom" : "1001","nmCom" : "(주)더존넥스트","cdPlace" : "1000|","nmPlace" : "(주)더존넥스트|","erpType" : "2"}},"contentVersion" : [ {"contentType" : "*","version" : "1","path" : "/APP3","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716543472.zip"}, {"contentType" : "*","version" : "1","path" : "/APP2","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716543200.zip"}, {"contentType" : "*","version" : "1","path" : "/APP1","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716542869.zip"}, {"contentType" : "*","version" : "1","path" : "/APP","contentUrl" : "http://ssm.duzoncnt.com:9560/Contents/2013020716542579.zip"} ],"dataVersion" : [ ],"token" : "4BB6AB52-B73A-4B6C-B385-4FF7A7210F82","osType" : "02","appVer" : "1.0","deviceId" : "ffffffff-bb32-4e4e-0033-c5870033c587","programCd" : "01"},"tId" : "p1","resultCode" : "0","resultMessage" : "성공하였습니다."}');

function _setBaseData(sRst) {
    //alert("_setBaseData : \n\n" + sRst);
    try {
        NextS.baseData = JSON.parse(sRst);
        localStorage.baseData = sRst;
        if (NextS.callback) eval(NextS.callback)();
    } catch (e) { }
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
            alert(jRst.resultMessage);
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
                //console.log('getProtocolUrl : ' + pUrl);
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

if (openDatabase) { NextS.dbUse = true; }
