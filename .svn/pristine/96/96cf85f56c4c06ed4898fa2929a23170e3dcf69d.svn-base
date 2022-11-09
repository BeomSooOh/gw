//  This file is part of the jQuery moneyModify Plugin.
// jquery.formatCurrency.js 과 같이 사용해야 합니다.

; (function($)
{

    $.fn.moneyModify = function(optiondata)
    {
        var options = $.extend({}, $.fn.moneyModify.defaults, optiondata);

        return this.each(function()
        {
            var Money = $(this);

            Money.val(($.trim(Money.val()) == "") ? 0 : Money.val());

            Money.css("text-align", options.align)
            .blur(function(e)
            {
                $(this).val(Math.floor(Number(Money.val().replace(/\,/gi, "")) / (options.limitamount)) * options.limitamount);
                $(this).formatCurrency({ colorize: true, negativeFormat: '-%s%n', roundToDecimalPlace: 0, symbol: "" });
            })
            .keyup(function(e)
            {
                var e = window.event || e;
                var keyUnicode = e.charCode || e.keyCode;
                if (e !== undefined)
                {
                    switch (keyUnicode)
                    {
                        case 16: break; // Shift
                        case 27: this.value = ''; break; // Esc: clear entry
                        case 35: break; // End
                        case 36: break; // Home
                        case 37: break; // cursor left
                        case 38: break; // cursor up
                        case 39: break; // cursor right
                        case 40: break; // cursor down
                        case 78: break; // N (Opera 9.63+ maps the "." from the number key section to the "N" key too!) (See: http://unixpapa.com/js/key.html search for ". Del")
                        case 110: break; // . number block (Opera 9.63+ maps the "." from the number block to the "N" key (78) !!!)
                        case 190: break; // .
                        default: $(this).formatCurrency({ colorize: true, negativeFormat: '-%s%n', roundToDecimalPlace: 0, symbol: "" });
                    }
                }
            });

            if (options.minusimage != "")
            {
                Money.before("<img src=\"" + options.minusimage + "\" /> ");
                Money.prev().css("cursor", "pointer")
                .click(function(e)
                {
                    var val = (Number(Money.val().replace(/\,/gi, "")) - options.limitamount);

                    if (options.negative)
                        Money.val(val);
                    else
                        Money.val((val < 0) ? 0 : val);

                    Money.formatCurrency({ colorize: true, negativeFormat: '-%s%n', roundToDecimalPlace: 0, symbol: "" });
                });
            }

            if (options.plusimage != "")
            {
                Money.after(" <img src=\"" + options.plusimage + "\" />");
                Money.next().css("cursor", "pointer")
                .click(function(e)
                {
                    Money.val((Number(Money.val().replace(/\,/gi, "")) + options.limitamount));
                    Money.formatCurrency({ colorize: true, negativeFormat: '-%s%n', roundToDecimalPlace: 0, symbol: "" });
                });
            }
        });
    };

    $.fn.moneyModify.defaults = {
        minusimage: "",
        plusimage: "",
        align: "right",
        negative: false,
        limitamount: 100
    };

})(jQuery);