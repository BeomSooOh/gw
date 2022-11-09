//------------------------------------------------------------------------------------------------------
// 공통팝업들
//------------------------------------------------------------------------------------------------------


function DialogClass() {

    this.openDialog = _openDialog;
    this.closeDialog = _closeDialog;
    this.showMessage = _showMessage;
    this.closeMessage = _closeMessage;
    this.getParseResponseText = _getParseResponseText;
    this.printDialog = _printDialog;
}


function _openDialog(url, nWidth, nHeight, sTitle) {

    $("#dialog").dialog("destroy");

    $("#dialog-modal").dialog({
        width: nWidth,
        height: nHeight,
        modal: true,
        resizable: false,
        title: sTitle,
        open: function () {
            var digframe = document.getElementById('popViewPage');
            digframe.contentWindow.document.write("<div style='width:100%; height:100%; z-index:9999; text-align:center; vertical-align:middle;'><table style='width:100%; height:100%;'><tr><td align='center'><img src='/images/common/loading.gif' style='line-height:100px; vertical-align:middle;'><td></tr></table></div>");
            digframe.contentWindow.location.href = url;

            if ($("#Editor").length > 0 || $("#NbbUploader").length > 0) {
                if ($("#viewLoading2").length > 0) {
                    $("#viewLoading2").css("width", "100%");
                    $("#viewLoading2").css("height", "100%");
                    $("#viewLoading2").css("top", $(window).scrollTop());
                    $("#ifLoading2").css("top", $(window).scrollTop()); 
                    $("#viewLoading2").fadeIn(500);
                }
            }
        },
        beforeclose: function (event, ui) {
            var digframe = document.getElementById('popViewPage');
            digframe.contentWindow.location.href = "about:blank";
            if ($("#viewLoading2").length > 0) {
                $("#viewLoading2").fadeOut(500);
            }
        }

    });


}

function _closeDialog() {
    $("#dialog-modal").dialog("close");
}


function _showMessage(errMsg) {
    $("#dialog-text").attr("innerHTML", errMsg);

    $("#dialog").dialog("destroy");
    $("#dialog-message").dialog({
        modal: true,
        buttons: {
            Ok: function () {
                $(this).dialog('close');
            }
        }
    });
}


function _closeMessage() {
    $("#dialog-message").dialog("close");

}

function _getParseResponseText(res) {
    var msg = res.responseText.match(/\<title\>(.*)\<\/title\>/gi)[0];
    msg = msg.replace(/<(\/?)title>/gi, "");

    return msg;
}



function _printDialog(url, nWidth, nHeight, sTitle) {

    $("#dialog").dialog("destroy");

    $("#dialog-modal").dialog({
        width: nWidth,
        height: nHeight,
        modal: false,
        resizable: true,
        title: sTitle,

        open: function () {
            ifrmCode.document.write("Loading..."); ifrmCode.location.href = url;

            if ($("#activex").length > 0) {
                $("#activex").block({ message: null });
            }
        },
        beforeclose: function (event, ui) {
            ifrmCode.location.href = "about:blank";

            if ($("#activex").length > 0) {
                $("#activex").unblock();
            }
        },
        buttons: {
            "인쇄": function () {

                $("#ifrmCode").focus();
                $("#ifrmCode").printArea();
            }
        }
    });


}