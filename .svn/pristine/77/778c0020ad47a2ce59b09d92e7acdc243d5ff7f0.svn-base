/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dzutil.js - 웹페이지에 종속적
//						
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


var dzUtil = {

	openWindowCommon : function(strPageURL, nWidth, nHeight, bScrollbar, strName) {

		var objOpenWIn;
		var nWin_Left = (screen.width - nWidth) / 2;
		var nWin_Top  = (screen.height - nHeight) / 2;

		var strWin_Props = '';
		if(bScrollbar)
		{
			strWin_Props = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width='+nWidth+',height='+nHeight+',top='+nWin_Top+',left='+nWin_Left;
		}
		else
		{
			strWin_Props = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width='+nWidth+',height='+nHeight+',top='+nWin_Top+',left='+nWin_Left;
		}

		objOpenWIn = window.open(strPageURL, strName, strWin_Props);
		if(parseInt(navigator.appVersion) >= 4) {objOpenWIn.window.focus();}
	}

};
