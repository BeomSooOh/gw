
NextS.topPop = function (txt, delay) {
    if (delay) delay = 3000;
    if ($('.topPop').length == 0) {
        tag = '<div class="topPop" style="z-index:100;text-align:left;padding:0px 5px 0px 5px;position:absolute;left:0px;top:0px;margin-top: 0px;width:100%;-webkit-transition-property:margin-top;-webkit-transition-duration:1.0s;background: #ff0000;color: #ffffff;"></div>';
        $('body').append(tag);
    }
    tag = '<div style="width:100%">==> ' + txt + '</div>'
    $(tag).appendTo($('.topPop')).delay(delay+3000).slideUp(500); //.remove();
}

NextS.maskScr = function(){

}

NextS.uiHeight = function (e) {
    NextS.options.width = NextS._getWidth();
    NextS.options.height = NextS._getHeight();

    width = NextS.options.width;
    height = NextS.options.height;

    //    tag = "width : " + NextS._getWidth();
    //    tag += "<br> height : " + height;
    //    $("#scr").html(tag);

    //$(".ui-mobile").css("width", width).css("height", height);
    $("body").css("width", width).css("height", height);
    $(":jqmData(role='page')").css("width", width).css("height", height);
    //$("#bg").css("width", width).css("height", height);

    //console.log($("body").height());
    var $page = $(":jqmData(role='page')"); //$(e);
    var tTH = [];
    var tC = [];
    $page.find(":jqmData(height)").each(function () {
        var $this = $(this);
        var tH = $this.jqmData("height");
        var tGr = $this.jqmData("group");

        if (!tGr) tGr = 0;

        if (!tTH[tGr]) {
            tTH[tGr] = 0;
            tC[tGr] = 0;
        }

        //console.log("(1) " + $this.attr("id") + " : " + tH);
        if (tH == "0") {
            $this.hide();
        } else if (tH != "*") {
            //console.log('(2) tTH[' + tGr + '] : ' + tTH[tGr]);
            tTH[tGr] += parseInt(tH);
            $this.css("height", tH);
            $this.show();
        } else {
            tC[tGr] += 1;
            $this.addClass("nextHeight");
            $this.show();
        }

        //console.log("(3) height : " + $this.jqmData("height"));
        //console.log('(4) tTH[' + tGr + '] : ' + tTH[tGr]);
        //console.log('(5) tC[' + tGr + '] : ' + tC[tGr]);
        //        if ($this.hasClass("ui-height")) {
        //            NextS.topPop($this.jqmData("height"), 5000);
        //        } else {
        //            NextS.topPop($this.jqmData("height"), 5000);
        //        }
    });

    //console.log('tTH : ' + tTH);
    //console.log('tC : ' + tC);

    //for (i = 0; i < tTH.length; i++) {
    $page.find(".nextHeight").each(function () {
        var $this = $(this);
        var tGr = $this.jqmData("group");
        if (tC[tGr] > 0) {
            var nH = (NextS.options.height - tTH[tGr]) / tC[tGr];
            $this.css("height", nH);
            //console.log('nH : ' + nH);
        }
    });


    //    $("#txTop").html(" (" + $("#aaa").width() + " * " + $("#aaa").height() + ") ");
    //    $("#txContents").html(" (" + $("#bbb").width() + " * " + $("#bbb").height() + ") ");
    //    $("#txContents2").html(" (" + $("#ccc").width() + " * " + $("#ccc").height() + ") ");
    //    $("#txContents3").html(" (" + $("#ddd").width() + " * " + $("#ddd").height() + ") ");
    //    $("#txBottom").html(" (" + $("#eee").width() + " * " + $("#eee").height() + ") ");


}

NextS.uiHeightOrientation = function () {
    //NextS.topPop("orientationchange", 1000);
    //alert("orientationchange");
    NextS.uiHeight(this);
}

NextS.uiHeightResize = function () {
    //NextS.topPop("resize", 1000);
    //alert("resize");
    NextS.uiHeight(this);
}

NextS.callDatePick = function (defaultDate, callback) {
    NextS.callback = callback;
    NextS._callApp('call;DatePick;' + defaultDate + ';_setData;');
}

NextS.callSelButton = function (title, selData, cancelView, callback) {
    var jParam = {};
    jParam.title = title;
    jParam.data = selData;

    NextS.jsonParam = JSON.stringify(jParam);
    NextS.callback = callback;
    NextS._callApp('call;SelButton;_getButton;_setData;' + cancelView + ';');
}

NextS.callSelWheel = function (defaultSelect, selData, callback) {
    var jParam = {};
    jParam.defaultSelect = defaultSelect;
    jParam.data = selData;

    NextS.jsonParam = JSON.stringify(jParam);
    NextS.callback = callback;
    NextS._callApp('call;SelWheel;_getWheel;_setData;');
}

try {
    $(":jqmData(role='page')").live("pageshow", function (event) {
        NextS.uiHeight(this);
    });
} catch (e) { }

//window.addEventListener('orientationchange', NextS.uiHeightOrientation, false);
//window.addEventListener('resize', NextS.uiHeightResize, false);







/************************************************* 팝업 관련 시작 ***************************************************/

(function ($, window, undefined) {
    if (!window.NextS) {
        window.NextS = {};
    }

    NextS.popup = function () {
        var that = this;
        that.option = {
            layerName: '_modal_layer',
            topZIndex: 0,
            baseZIndex: -1,
            stackZIndex: [],
            modalStyle: {}
        };

        that.init();
    };

    NextS.popup.prototype = {

        init: function (cssStyle) {
            var that = this,
                modalStyle;

            modalStyle = that.option.modalStyle;

            //기본 스타일 설정
            modalStyle = {
                display: 'none',
                position: 'absolute',
                width: '100%',
                height: '100%',
                background: '#484848',
                opacity: '0.5',
                left: 0,
                top: 0
            };

            //파라메터로 받은 style 설정
            if (cssStyle) {
                if (typeof cssStyle === 'string') {
                    modalStyle = cssStyle;
                } else if (typeof cssStyle === 'object') {
                    for (tmpValue in cssStyle) {
                        modalLayer[tmpValue] = cssStyle[tmpValue];
                    }
                }
            }

            that.option.modalStyle = modalStyle;
        },

        //팝업을 화면에서 보이기
        show: function (popupId) {
            if (!this._isExistPopupId(popupId)) { return; }
            $('#' + popupId).show();
            $('#' + popupId + that.option.layerName).show();
        },

        //팝업을 화면에서 숨기기
        hide: function (popupId) {
            if (!this._isExistPopupId(popupId)) { return; }
            $('#' + popupId).hide();
            $('#' + popupId + that.option.layerName).hide();
        },

        //팝업을 띄워주는 기능.
        open: function (popupId, cssStyle, handler, refId) {
            if (!this._isExistPopupId(popupId)) { return; }
            var that = this,
                popup = document.getElementById(popupId),
                modalLayer = document.createElement('div'),
                defaultStyle,       //init시에 설정된 기본 modal layer 스타일
                tmpZIndex,          //현재 DOM에서 가장 높은 z-index값( 이보다 더 큰 값이 이번에 열릴 팝업의 z-index로 설정)
                tmpValue,           //for in 에서 사용할 임시 저장 공간
                $modalLayer, $popup;        //jquery로 rapping

            if (that.option.baseZIndex === -1) {
                //가장 큰 z-index값 저장
                that.option.baseZIndex = that.option.topZIndex = that._getBaseZIndex();
            }
            defaultStyle = that.option.modalStyle;

            //z-index값을 결정
            tmpZIndex = parseInt(that.option.topZIndex);

            //model layer id 설정
            modalLayer.id = popupId + that.option.layerName;

            $modalLayer = $(modalLayer);
            $popup = $(popup);

            $modalLayer.css('z-index', parseInt(tmpZIndex) + 1);

            if (cssStyle) {
                if (typeof cssStyle === 'string') {
                    $modalLayer.addClass(cssStyle);
                } else if (typeof cssStyle === 'object') {
                    for (tmpValue in cssStyle) {
                        $modalLayer.css(tmpValue, cssStyle[tmpValue]);
                    }
                }
            } else {
                if (typeof defaultStyle === 'string') {
                    $modalLayer.addClass(defaultStyle);
                } else if (typeof defaultStyle === 'object') {
                    for (tmpValue in defaultStyle) {
                        $modalLayer.css(tmpValue, defaultStyle[tmpValue]);
                    }
                }
            }

            that.option.topZIndex = parseInt(tmpZIndex) + 2;

            //팝업 속성 설정
            $popup.css('z-index', that.option.topZIndex);

            //modal 레이어 추가
            if (refId) {
                $('#' + refId).prepend($modalLayer);
            } else {
                $('body').prepend($modalLayer);
            }

            //handler 등록
            if (handler) {
                $modalLayer.click(function () {
                    handler();
                });
            } else {
                $modalLayer.click(function () {
                    that.close(popupId);
                });
            }

            //stack에 해당 팝업 기억
            that.option.stackZIndex[that.option.stackZIndex.length] = { id: popupId, zIndex: that.option.topZIndex };

            //show
            $modalLayer.show();
            $popup.show();
        },

        //열린 팝업을 닫아주는 기능
        close: function (popupId) {
            if (!this._isExistPopupId(popupId)) { return; }
            var that = this;

            that._delete(popupId);
            that._clearModalLayer(popupId);

            that._pack();
            that.option.topZIndex = that._max();
        },

        //파라메터로 받는 팝업과 그보다 z-index값이 높은 팝업을 모두 닫는 기능
        closeAboveAll: function (popupId) {
            if (!this._isExistPopupId(popupId)) { return; }
            var that = this,
                i,
                tmpStackZIndex,
                pos;

            tmpStackZIndex = that.option.stackZIndex;

            pos = that._search(popupId);
            if (!(pos >= 0)) { return; }

            for (i = pos; i < tmpStackZIndex.length; i += 1) {
                that._clearModalLayer(tmpStackZIndex[i].id);
            }

            that.option.stackZIndex.length = pos;
            that.option.topZIndex = that._max();
        },

        closeAll: function () {
            var that = this,
                i,
                tmpStackZIndex,
                $modalLayer, $popup;

            tmpStackZIndex = that.option.stackZIndex;
            for (i = 0; i < tmpStackZIndex.length; i += 1) {
                that._clearModalLayer(tmpStackZIndex[i].id);
            }

            that.opion.stackZIndex.length = 0;
            that.option.topZIndex = that.option.baseZIndex;
        },

        //DOM을 뒤져 z-index값 중 가장 큰 값을 반환
        _getBaseZIndex: function () {
            var that = this,
                maxZIndex = 0,
                tempZIndex = 0;

            var $divList = $('div').filter(function (i, item) {
                return $(item).css('z-index') !== 'auto';
            });

            for (var i = 0; i < $divList.length; i += 1) {
                tempZIndex = $divList.eq(i).css("z-index");

                if (tempZIndex > maxZIndex) {
                    maxZIndex = tempZIndex;
                }
            }
            return maxZIndex;
        },

        //z-index값 중 가장 큰 값을 구함
        _max: function () {
            var that = this,
                i,                      //for count
                tmpStackZIndex,         //temp stackZIndex
                result;                 //save max value

            result = 0;
            tmpStackZIndex = that.option.stackZIndex;
            for (i = 0; i < tmpStackZIndex.length; i += 1) {
                if (tmpStackZIndex[i].zIndex > result) {
                    result = tmpStackZIndex[i].zIndex;
                }
            }

            return result;
        },

        //stackZIndex 에서 해당하는 이름을 찾아 삭제. DOM 삭제 X. 레이어를 삭제할 경우는 _clearModalLayer를 사용.
        _delete: function (popupId) {
            var that = this,
                i,                      //for count
                tmpStackZIndex,         //temp stackZIndex
                pos;

            tmpStackZIndex = that.option.stackZIndex;
            pos = that._search(popupId);
            if (pos >= 0) {
                tmpStackZIndex.splice(pos, 1);
            }
        },

        //해당하는 팝업 ID의 레이어를 DOM에서 삭제한다.
        _clearModalLayer: function (popupId) {
            var that = this,
                $popup, $modalLayer;

            $popup = $('#' + popupId);
            $modalLayer = $('#' + popupId + that.option.layerName);

            $popup.hide();
            $popup.css('z-index', '');
            $modalLayer.remove();
        },

        //stackZIndex 배열 값을 정렬함(오름차순)
        _sort: function () {
            var that = this,
                tmpStackZIndex;

            tmpStackZIndex = that.option.stackZIndex;
            tmpStackZIndex.sort(function (a, b) {
                return a.zIndex - b.zIndex;
            });
        },

        //활성화된(화면에 보여지는) 팝업중에 id로 열린 팝업을 찾고 sort된 stackZIndex 배열의 pos값을 돌려줌, 없으면 undefined
        _search: function (popupId) {
            var that = this,
                i,
                tmpStackZIndex;

            tmpStackZIndex = that.option.stackZIndex;
            that._sort();
            for (i = 0; i < tmpStackZIndex.length; i += 1) {
                if (tmpStackZIndex[i].id === popupId) {
                    return i;
                }
            }

            return undefined;
        },

        //stackZIndex 배열과, 열린 팝업들의 z-Index값을 공백없이 맞춘다.
        //단 DOM의 z-index값들은 stackZIndex의 값들과 일치한다고 가정.
        _pack: function () {
            var that = this,
                i,
                tmpStackZIndex;

            that._sort();
            tmpStackZIndex = that.option.stackZIndex;

            //0번째 값은 비교 필요X
            for (i = 1; i < tmpStackZIndex.length; i += 1) {
                //[i] 와 [i-1]번째 zindex값의 차가 2인지 확인.
                if ((parseInt(tmpStackZIndex[i - 1].zIndex)) !== parseInt(tmpStackZIndex[i].zIndex - 2)) {

                    tmpStackZIndex[i].zIndex = parseInt(tmpStackZIndex[i - 1].zIndex) + 2;
                    $('#' + tmpStackZIndex[i].id).css('z-index', parseInt(tmpStackZIndex[i].zIndex));
                    $('#' + tmpStackZIndex[i].id + that.option.layerName).css('z-index', parseInt(tmpStackZIndex[i].zIndex) - 1);
                }
            }
        },

        _isExistPopupId: function (popupId) {
            if (!popupId) {
                alert("popupId는 반드시 필요합니다.");
                return false;
            }
            return true;
        }
    };

    NextS.popup = new NextS.popup();

})(jQuery, window);

/********************************************* 팝업 관련 끝 ******************************************************/

/********************************************* 탭 레이아웃 관련 시작 ***********************************************/

(function ($, window, undefined) {
    if (!window.NextS) {
        window.NextS = {};
    }

    NextS.tabLayout = function (tabsObj) {
        this.tabsObj = tabsObj;
        this.$tabBtns = '';
        this.$tabContents = '';
        this.pastState = '';
        this.init();
    };

    NextS.tabLayout.prototype = {
        ///<summary>
        /// DOM의 ID들과 function들을 입력받아 Tab Layout으로 동작하도록 구성해 줌
        /// <param nmae="tabsObj">Tab Layout을 구성하는 DOM의 ID들과 function을 가진 object</param>
        ///</summary>
        ///<example> This sample shows how to set the tabsObj parameter.
        /// <code>
        /// {
        ///     group: "groupId",
        ///     style: {
        ///             selected: "cssClassName"
        ///          },
        ///     tabs: [
        ///             {
        ///                 tabId:"domTitleId",
        ///                 contentId: "domContentId",
        ///                 event: {    //optional
        ///                             btnClick: function(){},
        ///                             executeBefore: function(){},
        ///                             executeAfter: function(){}
        ///                         }
        ///             },
        ///             {...},
        ///           ]
        /// }
        /// </code>
        /// </example>
        init: function () {
            var that = this, result;
            if (typeof (result = that._isExists(this.tabsObj)) !== 'boolean') {
                alert('Tab Layout :: ' + result);
                return;
            }

            //dom에서 해당하는 변수들 값을 체움
            that.$tabBtns = $(that._getIds('tabId'));
            that.$tabContents = $(that._getIds('contentId'));

            //tab event 설정
            that.$tabBtns.each(function (i, item) {
                $(item).unbind('click').bind('click', function () {
                    //탭핑 이벤트가 새로 넘어오면 입력받은 이벤트를 적용
                    var tmpId, tab;
                    tmpId = $(item).attr('id');
                    tab = that._getTab(tmpId);

                    if (tab.event && tab.event.btnClick) {
                        return tab.event.btnClick;
                    }
                    //없으면 기본 이벤트를 적용
                    return function (event) {
                        var targetId,
                            tab;

                        targetId = (event.target || event.srcElement).id;

                        tab = that._getTab(tmpId);
                        if (tab.event && tab.event.executeBefore) {
                            tab.event.executeBefore();
                        }

                        that.select(targetId);

                        if (tab.event && tab.event.executeAfter) {
                            tab.event.executeAfter();
                        }

                        event.preventDefault();
                    }
                } ());
            });

            that._groupVisible(true);
            that.select(0);
        },

        select: function (target) {
            if (typeof target === 'number' && !(target > -1)) {
                return;
            }

            this._showButtons(target);
            this._showContent(target);
        },

        //
        show: function () {
            var target = this.pastState;

            this.select((target || 0));

            this._groupVisible(true);
        },

        hide: function () {
            var $tabBtns = this.$tabBtns,
                $tabContents = this.$tabContents,
                tabsObj = this.tabsObj;

            if (tabsObj.style && tabsObj.style.selected) {
                this.pastState = $tabBtns.filter('.' + tabsObj.style.selected).attr('id');
            } else {
                this.pastState = $tabContents.filter(':visible').attr('id');
                this.pastState = $tabBtns.filter('#' + this._getTabId(this.pastState)).attr('id');
            }

            this._groupVisible(false);

            $tabBtns.hide();
            $tabContents.hide();
        },

        close: function () {
            this._groupVisible(false);

            this.$tabBtns.hide();
            this.$tabContents.hide();

            this.$tabBtns.each(function (i, item) {
                $(item).unbind('click');
            });

            this.tabsObj = null;
            this.$tabBtns = null;
            this.$tabContents = null;
            this.pastState = null;
        },

        _groupVisible: function (bool) {
            if (this.tabsObj.groupId) {
                if (bool) {
                    $('#' + this.tabsObj.groupId).show();
                } else {
                    $('#' + this.tabsObj.groupId).hide();
                }
            }
        },

        _setSelectedStyle: function (target) {
            var item;
            if (!(this.tabsObj.style && this.tabsObj.style.selected)) {
                return;
            }

            if (typeof target === 'string') {
                item = this.$tabBtns.filter('#' + target);
                if (item.length) {
                    this.$tabBtns.removeClass(this.tabsObj.style.selected);
                    item.addClass(this.tabsObj.style.selected);
                }
            } else if (typeof target === 'number') {
                if (!(target >= this.$tabBtns.length)) {
                    this.$tabBtns.removeClass(this.tabsObj.style.selected);
                    this.$tabBtns.eq(target).addClass(this.tabsObj.style.selected);
                }
            }
        },

        _showButtons: function (target) {
            this._setSelectedStyle(target);
            this.$tabBtns.show();
        },

        _showContent: function (target) {
            var tabId;
            if (typeof target === 'number' && !(target > -1)) {
                return;
            }

            if (typeof target === 'string') {
                tabId = this._getContentId(target);
                if (tabId) {
                    this.$tabContents.filter(':visible').hide();
                    this.$tabContents.filter('#' + tabId).show();
                }
            } else if (typeof target === 'number') {
                if (!(target >= this.$tabContents.length)) {
                    this.$tabContents.filter(':visible').hide();
                    this.$tabContents.eq(target).show();
                }
            }
        },

        //tabId를 이용하여 tab object를 구함
        _getTab: function (tabId) {
            var i, tabs;
            tabs = this.tabsObj.tabs;

            for (i = 0; i < tabs.length; i += 1) {
                if (tabs[i].tabId === tabId) {
                    return tabs[i];
                }
            }

            return undefined;
        },

        //탭 id를 이용하여 contentId를 구함.
        _getContentId: function (tabId) {
            var i, tabs;
            tabs = this.tabsObj.tabs;
            for (i = 0; tabs.length; i += 1) {
                if (tabs[i].tabId === tabId) {
                    return tabs[i].contentId;
                }
            }
            return undefined;
        },

        //content id를 이용하여 tabId를 구함.
        _getTabId: function (contentId) {
            var i, tabs;
            tabs = this.tabsObj.tabs;
            for (i = 0; tabs.length; i += 1) {
                if (tabs[i].contentId === contentId) {
                    return tabs[i].tabId;
                }
            }
            return undefined;
        },

        _isExists: function () {
            var obj = this.tabsObj,
                tabs, i;

            if (!(typeof obj === 'object')) {
                return '데이터가 객체가 아닙니다.';
            }
            if (!this.tabsObj.tabs) {
                return 'Tab이 없습니다.';
            }

            tabs = obj.tabs;

            for (i = 0; i < tabs.length; i += 1) {
                if (!(tabs[i].tabId && tabs[i].contentId)) {
                    return '' + (i + 1) + '번째 Tab 또는 Content 의 ID가 없습니다.';
                }
            }

            return true;
        },

        //tabs의 tabId, 또는 contentId를 연결된 문자열로 반환
        _getIds: function (idType) {
            var str = '',
                i,
                tabs,
                item;

            tabs = this.tabsObj.tabs;
            for (i = 0; i < tabs.length; i += 1) {
                item = tabs[i];
                str += '#' + item[idType] + ',';
            }
            str = str.substring(0, str.lastIndexOf(','));
            return str;
        }
    };

    //NextS.tabLayout = new NextS.tabLayout();
})(jQuery, window);

/********************************************* 탭 레이아웃 관련 끝 ***********************************************/
