
; (function($)
{
    $.fn.getOnlyNumericValue = function(data)
    {
        var iLength = data.length;
        var TempValue = "";
        var ReturnValue = "";

        for (var i = 0; i < iLength; ++i)
        {
            TempValue = data.charCodeAt(i);

            if ((TempValue > 47 || TempValue <= 31) && TempValue < 58)
            {
                ReturnValue += String.fromCharCode(TempValue);
            }
        }

        return ReturnValue;
    };

    $.fn.koreanMoney = function(optiondata)
    {
        var options = $.extend({}, $.fn.koreanMoney.defaults, optiondata);

        // '만', '억', '조', '경', '해', '시', '양', '구', '간', '정'
        var price_num = new Array("", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구");
        var price_unit = new Array("", "십", "백", "천", "만 ", "십만 ", "백만 ", "천만 ", "억 ", "십억 ", "백억 ", "천억 ", "조 ", "십조 ", "백조", "천조", "경 ", "십경 ", "백경", "천경");

        var price_array = new Array();
        var price = String(Number($(this).getOnlyNumericValue($(this).val())) * options.StandardPrice);

        iLength = price.length;
        var ReturnValue = "";

        for (i = 0; i < iLength; i++)
            price_array[i] = price.substr(i, 1);

        var code = iLength;
        var TempUnit;

        for (i = 0; i < iLength; i++)
        {
            code--;
            TempUnit = "";

            if (price_num[price_array[i]] != "")
            {
                TempUnit = price_unit[code];

                if (code > 4)
                {
                    if ((Math.floor(code / 4) == Math.floor((code - 1) / 4) && price_num[price_array[i + 1]] != "") || (Math.floor(code / 4) == Math.floor((code - 2) / 4) && price_num[price_array[i + 2]] != ""))
                        TempUnit = price_unit[code].substr(0, 1);
                }
            }

            ReturnValue += price_num[price_array[i]] + TempUnit;
        }

        if (options.ShowUnit)
        {
            if (options.symbol + ReturnValue == "")
                return price_unit[options.StandardPrice.length - 1];
            else
                return options.symbol + ReturnValue;
        }
        else
            return options.symbol + ReturnValue;
    };

    $.fn.koreanMoney.defaults = {
        symbol: "",
        StandardPrice: 1,
        ShowUnit: false
    };

})(jQuery);