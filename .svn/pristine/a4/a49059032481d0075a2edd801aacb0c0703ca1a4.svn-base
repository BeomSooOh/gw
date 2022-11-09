/************************************************************************
 * 2016-09-22  그룹포탈 관계사형 Gnb 관련 스크립트.
그룹포탈에서 만들어준 스크립트를 사용하지 않고 메뉴 목록 및 css, image 등 리소스를 별도로 관리한다.
http://int.toktok.sk.com/CmnWeb/common/js/flashwrite_skmr.js
************************************************************************/

/***
//MenuService 데이터
var _groupPortalGnbObject = {
    "M": [{ "I": "P0000001", "N": "SK경영", "C": "CON1$0$$/Management/TopMgmt/_Layouts/Top/ListTopMgmt.aspx", "S": "0" }
         , { "I": "P0000069", "N": "SK미디어센터", "C": "CON1$0$$/skmedia/Lists/SK_Exclusive2/WebZineList.aspx", "S": "0" }
         , { "I": "P0000133", "N": "Biz&Info", "C": "CON1$0$$/bizinfo/newskri/_layouts/main/skrimain.aspx", "S": "0" }
         , { "I": "P0000093", "N": "SK라이프", "C": "CON1$0$$/sklife/Card/Lists/FC_Notice/AllItems.aspx", "S": "0" }]
};
***/

var _groupPortalGnbObject = {
    "P0000001": "COMMUNITY$0$$/Board/HighFive",
    "P0000069": "COMMUNITY$0$$/Extension/MagazineSK_Main",
    "P0000133": "COMMUNITY$0$$/Board/pubboard",
    "P0000093": "COMMUNITY$0$$/Board/card_notice"
};
var GroupPortalGnbResources = {
    Search: "통합검색",
    MemberSearch: "구성원검색",
    P0000001: "SK경영",
    P0000069: "SK미디어센터",
    P0000133: "SK커뮤니티",
    P0000093: "SK라이프"
};

function fn_SetGroupPortalGnbResources(lang) {
    if (lang == 'en') {
        GroupPortalGnbResources = {
            Search: "Search",
            MemberSearch: "FInd Person",
            P0000001: "SK Management",
            P0000069: "SK Media Center",
            P0000133: "SK Community",
            P0000093: "SK Life"
        };
    }
    else if (lang == 'zh') {
        GroupPortalGnbResources = {
            Search: "综合检索",
            MemberSearch: "成员检索",
            P0000001: "SK经营",
            P0000069: "SK媒体中心",
            P0000133: "SK Community",
            P0000093: "SK生活"
        };
    }
};
var _groupPortalgwpsitemap = { "INT": "http://int.toktok.sk.com", "PORTAL": "http://toktok.sk.com", "CON1": "http://con1.toktok.sk.com", "CON2": "http://con2.toktok.sk.com", "MAGAZINE": "http://magazine.sk.com", "COMMUNITY": "http://portal.toktok.sk.com" };
var _groupPortalgwpowaurl = "http://mail.sk.com/owa/";

GroupPortalMenu = function () { };
GroupPortalMenu.prototype =
{
    MemberFlag: false,
    SearchFlag: false,
    Initialize: function () {
        var lang = 'ko';
        if (typeof gwpcurrentlanguage != "undefined") {
            lang = gwpcurrentlanguage;
            $('#gwpGnb').addClass(lang);
            if (lang != 'ko') {
                fn_SetGroupPortalGnbResources(lang);
                $('#text_GroupPortal_SearchMember').val(GroupPortalGnbResources.MemberSearch);
                $('#text_GroupPortal_TotalSearch').val(GroupPortalGnbResources.Search);

                $('#a_Menu_P0000001').text(GroupPortalGnbResources.P0000001);
                $('#a_Menu_P0000069').text(GroupPortalGnbResources.P0000069);
                $('#a_Menu_P0000133').text(GroupPortalGnbResources.P0000133);
                $('#a_Menu_P0000093').text(GroupPortalGnbResources.P0000093);
            }
        }
    },
    HomeClick: function () {
        // 2013-10-15 김우성 SKTL에서 window.top이 number 변수인 괴상한 상황 발견됨...
        if (typeof (window.top) != "undefined" && typeof (window.top) == "object") {
            //window.top.location.href = _groupPortalgwpsitemap["PORTAL"] + "/main.aspx";
            window.top.location.href = _groupPortalgwpsitemap["PORTAL"];
        }
        else {
            //window.location.href = _groupPortalgwpsitemap["PORTAL"] + "/main.aspx";
            window.location.href = _groupPortalgwpsitemap["PORTAL"];
        }
    },
    EthicsClick: function () {
        window.open('https://ethics.sk.co.kr/Kor/Main.aspx', '_blank', '');
    },
    CheckSearchMembers: function () {
        var n = $('#text_GroupPortal_SearchMember').val();
        if (typeof n != "undefined" && n == '') {
            $('#text_GroupPortal_SearchMember').val(GroupPortalGnbResources.MemberSearch);
            this.MemberFlag = false;
        }
    },
    CheckTotalSearch: function () {
        var n = $('#text_GroupPortal_TotalSearch').val();
        if (typeof n != "undefined" && n == '') {
            $('#text_GroupPortal_TotalSearch').val(GroupPortalGnbResources.Search);
            this.SearchFlag = false;
        }
    },
    SearchMembers: function () {
        var n = $('#text_GroupPortal_SearchMember').val();

        var minChars = 2;
        if (n.length > 0 && n.length < minChars) {
            alert(MultiLanguageScript.PleaseInputAtLeastNChars.replace("{0}", minChars));
        }
        else {
            fn_GNB_SearchMembers(n);
        }
    },
    TotalSearch: function () {
        var n = $('#text_GroupPortal_TotalSearch').val();
        var kwd = encodeURI(n);
        fn_GNB_SearchMain(kwd);
    },
    QuickmenuClick: function (value) {
        fn_GNB_goQuick(value);
    },
    MovingPage: function (id) {
        var url;
        if (typeof (id) != "undefined" && _groupPortalGnbObject[id] != null) {
            var array = _groupPortalGnbObject[id].split('$');
            var siteUrl = "";
            if (typeof (_groupPortalgwpsitemap) != "undefined" && _groupPortalgwpsitemap != null) {
                siteUrl = _groupPortalgwpsitemap[array[0]];
            }
            if (typeof (array[3]) != "undefined" && _groupPortalgwpsitemap != null && array[3].length > 0) {
                url = siteUrl + array[3];
            }

            if (typeof (url) == "undefined" || url.length == 0) {
                return;
            }

            if (typeof (array[1]) != "undefined" && array[1] == '1') {
                var feature = "";
                if (typeof (array[2]) != "undefined" && array[2].length > 0) {
                    feature = array[2];
                }
                window.open(url, '', feature);
            }
            else {
                document.location.href = url;
            }
        }
    }
};

var GroupPortalMenuControl = new GroupPortalMenu();


(function () {
    var ie = !!(window.attachEvent && !window.opera);
    var wk = /webkit\/(\d+)/i.test(navigator.userAgent) && (RegExp.$1 < 525);
    var fn = [];
    var run = function () { for (var i = 0; i < fn.length; i++) fn[i](); };
    var d = document;
    d.ready = function (f) {
        if (!ie && !wk && d.addEventListener)
            return d.addEventListener('DOMContentLoaded', f, false);
        if (fn.push(f) > 1) return;
        if (ie)
            (function () {
                try {
                    d.documentElement.doScroll('left');
                    try {
                        run();
                    }
                    catch (e) { }
                }
                catch (err) { setTimeout(arguments.callee, 0); }
            })();
        else if (wk)
            var t = setInterval(function () {
                if (/^(loaded|complete)$/.test(d.readyState))
                    clearInterval(t), run();
            }, 0);
    };
})();
document.ready(function () {
    /*
    var div = document.createElement("div");
    div.setAttribute("style", "display:none;");
    div.innerHTML = "<object id=\"OutlookNateOnBizLauncher\" classid=\"CLSID:8415C70B-E653-40DB-BA9E-D5AFFF758DEA\" codebase=\"" + _groupPortalgwpsitemap["INT"] + "/cmnweb/common/cab/sk.mail.messenger.launcher.cab#version=1,0,0,2\" width=\"0\" height=\"0\"></object>";
    document.body.appendChild(div);
    */
});

function fn_GNB_SearchMembers(n) {
    var feature = "width=998,height=633,directories=0,location=0,menubar=0,resizable=0,scrollbars=0,status=0,titlebar=0,toolbar=0";
    GwpOpenCenter(_groupPortalgwpsitemap["COMMUNITY"] + "/YellowPage/YellowPage.aspx?AllCompanyYN=Y&SearchCondition=" + encodeURIComponent(n), "yellowpage", "width=1096,height=730,directories=0,location=0,menubar=0,resizable=0,scrollbars=0,status=0,titlebar=0,toolbar=0");
}/* 구성원찾기 */

function fn_GNB_goQuick(q) {
    if (q == "mail") {
        if (typeof (_GwpCookie) != "undefined" && _GwpCookie.mail == "outlook") {
            var launcher = document.getElementById("OutlookNateOnBizLauncher");
            if (launcher) {
                var outlookopen = launcher.launchOutlook();
                if (outlookopen == false) {
                    if (typeof (gwpcurrentlanguage) != "undefined" && gwpcurrentlanguage == "en") {
                        alert("Outlook is not installed on your computer.");
                    }
                    else if (typeof (gwpcurrentlanguage) != "undefined" && ggwpcurrentlanguage == "zh") {
                        alert("?有安?Outlook。");
                    }
                    else {
                        alert("아웃룩이 설치되어 있지 않습니다.");
                    }
                }
            }
        }
        else {
            try {
                var popup = window.open(_groupPortalgwpowaurl, "OWA", "");
                popup.focus();
            } catch (e) { }
        }
    }
    else if (q == "yellowpage") {
        var feature = "width=998,height=633,directories=0,location=0,menubar=0,resizable=0,scrollbars=0,status=0,titlebar=0,toolbar=0";
        GwpOpenCenter(_groupPortalgwpsitemap["COMMUNITY"] + "/YellowPage/YellowPage.aspx?AllCompanyYN=Y", "yellowpage", "width=1096,height=730,directories=0,location=0,menubar=0,resizable=0,scrollbars=0,status=0,titlebar=0,toolbar=0");
    }
    else if (q == "authentication") {
        try {
            var popup = window.open("http://sso.sk.com:10000/certcenter/main.html", "AuthenticationCenter", "");
            popup.focus();
        } catch (e) { }
    }
    else if (q == "mobile") {
        try {
            var popup = window.open("http://m.toktok.sk.com", "mobile", "");
            popup.focus();
        } catch (e) { }
    }
    else if (q == "messenger") {
        var launcher = document.getElementById("OutlookNateOnBizLauncher");
        if (launcher) {
            var nateonbizopen = launcher.launchNateOnBiz();
            if (nateonbizopen == false) {
                if (typeof (gwpcurrentlanguage) != "undefined" && gwpcurrentlanguage == "en") {
                    alert("NateOn Biz is not installed on your computer.");
                }
                else if (typeof (gwpcurrentlanguage) != "undefined" && gwpcurrentlanguage == "zh") {
                    alert("?有安?NateOn Biz。");
                }
                else {
                    alert("NateOn Biz가 설치되어 있지 않습니다.");
                }
            }
        }
    }
}
/* 퀵메뉴["mail", "messenger", "yellowpage", "authentication", "mobile"] */

function fn_GNB_SearchMain(keyword) {
    if (keyword == "" || keyword.length == 0) {
        keyword = "sk";
    }

    var url = _groupPortalgwpsitemap["PORTAL"] + "/search/search.aspx?kwd=" + keyword;

    location.href = url;
    if (window.event) window.event.returnValue = false;
    return false;
}

function GwpOpenCenter(sURL, sName, sFeatures) {
    if (sFeatures.toLowerCase().indexOf('top') == -1 && sFeatures.toLowerCase().indexOf('left') == -1) {
        var features = sFeatures.split(/,/g);
        var width = -1; var height = -1;
        if (features.length && features.length > 0) {
            for (var idx in features) {
                if (features[idx].toLowerCase().indexOf("width") != -1) width = features[idx].match(/\d+/g);
                else if (features[idx].toLowerCase().indexOf("height") != -1) height = features[idx].match(/\d+/g);
                if (width != -1 && height != -1) break;
            }
        }
        var left = (window.screen.width - parseInt(width)) / 2;
        var top = (window.screen.height - parseInt(height)) / 2;
        sFeatures += ",left=" + left + ",top=" + top;
        try {
            var popup = window.open(sURL, sName, sFeatures);
            popup.focus();
        } catch (e) { }
    }
}
