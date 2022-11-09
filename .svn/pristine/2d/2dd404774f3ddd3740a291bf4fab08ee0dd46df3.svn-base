//******************************************************************************************************
// Name : /Pub/Jss/Currency.js
// Auth : 박지철
// Date : 2011.02.16
// Desc : 통화표시 관련 Script
//        jquery.alphanumeric.js, jquery.formatCurrency.js, jquery.koreanMoney.js 와 같이 사용해야 함
//******************************************************************************************************
Currency = {

    SetCurrencyControl: function(optiondata)
    {
        var options = $.extend({}, CurrencyOptions, optiondata);

        $("#" + options.CurrencyControl).numeric();
        $("#" + options.CurrencyControl).css("text-align", options.Align);

        $("#" + options.CurrencyControl).die();

        $("#" + options.CurrencyControl).live("blur", function(event)
        {
            $("#" + options.CurrencyControl).formatCurrency({ colorize: true, negativeFormat: '-%s%n', roundToDecimalPlace: 0, symbol: options.Symbol });

            if (options.koreanControl != "")
                $("#" + options.koreanControl).html($("#" + options.CurrencyControl).koreanMoney({ StandardPrice: options.StandardPrice, ShowUnit: options.ShowUnit }));
        })
        .live("keydown", function(event)
        {
            $("#" + options.CurrencyControl).formatCurrency({ colorize: true, negativeFormat: '-%s%n', roundToDecimalPlace: 0, symbol: options.Symbol });
        })
        .live("keyup", function(event)
        {
            $("#" + options.CurrencyControl).formatCurrency({ colorize: true, negativeFormat: '-%s%n', roundToDecimalPlace: 0, symbol: options.Symbol });

            if (options.koreanControl != "")
                $("#" + options.koreanControl).html($("#" + options.CurrencyControl).koreanMoney({ StandardPrice: options.StandardPrice, ShowUnit: options.ShowUnit }));
        });
    },
    GetToPrice: function(data, cipher)
    {
    	if( data == undefined || data == "") return 0 ;
    	data = data+"";
    	var minus = data.substring(0,1) ;
    	if ( minus == "-") {
    		data = data.substring(1, data.length) ;
    	}else {
    		minus = "" ;
    	}
        var TempValue = data.toString();
        TempValue = TempValue.replace(/,/g, "");
        TempValue = parseInt(TempValue, 10);

        if (isNaN(TempValue))
            return data;

        TempValue = TempValue.toString();
        var iLength = TempValue.length;

        if (iLength < 4)
            return minus+data;

        if (cipher == undefined)
            cipher = 3;

        cipher = Number(cipher);
        count = iLength / cipher;

        var slice = new Array();

        for (var i = 0; i < count; i++)
        {
            if (i * cipher >= iLength) break;
            slice[i] = TempValue.slice((i + 1) * -cipher, iLength - (i * cipher));
        }

        var revslice = slice.reverse();
        return minus + revslice.join(',');
    },
    GetOnlyNumeric: function(data)
    {
        var iLength = data.length;
        var TempValue = "";
        var ReturnValue = "";

        for (var i = 0; i < iLength; i++)
        {
            TempValue = data.charCodeAt(i);

            if ((TempValue > 47 || TempValue <= 31) && TempValue < 58)
                ReturnValue += String.fromCharCode(TempValue);
        }

        return ReturnValue;
    },
    GetTradeMoney: function(data, blank)
    {
        var price_unit = new Array("", "만", "억", "조", "경", "해", "시", "양", "구", "간", "정");
        var TradeMoney = Currency.GetOnlyNumeric($.trim(data.toString()));
        var moneyLength = TradeMoney.length;
        var blockCount = parseInt(moneyLength / 4, 10);
        var modCount = moneyLength % 4;

        if (modCount > 0) {
            blockCount++;
        }

        if (modCount == 0) {
            modCount = 4;
        }

        var result = "";
        var temp = "";

        for (var i = 0; i < blockCount; i++) {

            if (i == 0) {
                temp = TradeMoney.substr(0, modCount);
            } else {
                temp = TradeMoney.substr(modCount + (4 * (i - 1)), 4);
            }

            if (temp != "0000") {
                temp = parseInt(temp, 10) + "";

                if (temp.length == 4) {
                    temp = temp.substr(0, 1) + "," + temp.substr(1, 3);
                }

                temp += price_unit[blockCount - (i + 1)];

                if (blank) {
                    temp += " ";
                }

                result += temp;
            }
        }

        return result;
    }
};

CurrencyOptions = {
    Symbol: "",
    Align: "right",
    CurrencyControl: "",
    koreanControl: "",
    StandardPrice: 1,
    ShowUnit: false
};