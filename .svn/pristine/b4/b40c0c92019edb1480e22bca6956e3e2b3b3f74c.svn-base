

//----------------------------//
//*----- 전역 변수 선언 -----*//
//----------------------------//

//*----- 프레임 영역 관련 전역 변수 -----*//

var ncDoc;				// document 참조




var isESC 	= false;		// ESC 키 프레스 여부
var isOpened 	= false;
var countESC 	= 0;

var MyObj 	= new Object;		// 이벤트 스타일 적용을 위한 전역변수 form
var ncImgAuth;
var rClick_func = "";			// 오른쪽 마우스 클릭시 호출한 사용자 함수명
var posX;				// 오른쪽 마우스 클릭시 마우스의 X 좌표
var posY;				// 오른쪽 마우스 클릭시 마우스의 Y 좌표
var _g_PrevOEl = null ;


//document.onkeydown = sub_CtrlPress;
//document.onmousedown = sub_LockDown;

//*----- 이벤트 스타일 관련 함수(Frm 필수) -----*//
var strDateSeparate = "-";
var errColor = "yellow";

function ncFrm_Style()
{

	var colFrm = 	document.getElementsByTagName("FORM")
	var colImg = 	document.getElementsByTagName("IMG")

	var oFrm;
	var oEl;
	var strFormat;
	var className ;
//	ncFrm_Timeout();

	for(var i=0; i<colImg.length; i++)
		colImg[i].setAttribute("align","absmiddle");

	for( var k=0; k<colFrm.length; k++)
	{
		//colFrm[k].onreset = sub_EvtReset;
		if( typeof( colFrm[k].getAttribute("setMask") ) != "undefined" )
		{
			oFrm = colFrm[k];
			for(var i=0; i<oFrm.length; i++)
			{
				oEl = oFrm.elements[i];
				strFormat = oEl.getAttribute("format");
				
				className = sub_ClassName(oEl);
				switch( className) {
					case "iNum" :
					case "iNum3D" :
					case "iNumB" :
						sub_ChkNumFormat(oEl);
						break;
					case "iDate" :
					case "iDate3D" :
					case "iDateB" :
						sub_ChkDateFormat(oEl);
						break;
					case "iTime" :
					case "iTime3D" :
					case "iTimeB" :
						sub_ChkTimeFormat(oEl);
						break;
					case "iSsn" :
					case "iSsn3D" :
					case "iSsnB" :
						oEl.setAttribute("maxlength", "14", 0);
						break;
					case "iMask" :
					case "iMask3D" :
					case "iMaskB" :
						strFormat = oEl.getAttribute("format");
						oEl.setAttribute("maxlength", strFormat.length, 0);
						break;
				}

				switch( className )
				{
					case "iNum"	:
					case "iNum3D"	:
					case "iNumB"	:
					case "iFull"	:
					case "iFull3D"	:
					case "iFullB"	:
					case "iHan"	:
					case "iHan3D"	:
					case "iHanB"	:
					case "iDate"	:
					case "iDate3D"	:
					case "iDateB"	:
					case "iTime"	:
					case "iTime3D"	:
					case "iTimeB"	:
					case "iDigit"	:
					case "iDigit3D"	:
					case "iDigitB"	:
					case "iSsn"	:
					case "iSsn3D"	:
					case "iSsnB"	:
					case "iStr"	:
					case "iStr3D"	:
					case "iStrB"	:
					case "iMask"	:
					case "iMask3D"	:
					case "iMaskB"	:
						oEl.ffocus	= oEl.onfocus;
						oEl.fblur	= oEl.onblur;
						oEl.fkeyPress	= oEl.onkeypress;
						oEl.fkeyUp	= oEl.onkeyup;						
						oEl.onfocus	= sub_EvtFocus;
						oEl.onblur	= sub_EvtBlur;
						oEl.onkeypress	= sub_EvtKeyPress;
						oEl.onkeyup	= sub_EvtKeyUp;
						break;
				}
			}
		}
	}
/*
	function ncFrm_OneStyle(arg)  {
		switch( arg.className) {
				case "iNum" :
				case "iNum3D" :
				case "iNumB" :
					sub_ChkNumFormat(arg);
					break;
				case "iDate" :
				case "iDate3D" :
				case "iDateB" :
					
					sub_ChkDateFormat(arg);
					break;
				case "iTime" :
				case "iTime3D" :
				case "iTimeB" :
					sub_ChkTimeFormat(arg);
					break;
				case "iSsn" :
				case "iSsn3D" :
				case "iSsnB" :
					arg.setAttribute("maxlength", "14", 0);
					break;
				case "iMask" :
				case "iMask3D" :
				case "iMaskB" :
					strFormat = arg.getAttribute("format");
					arg.setAttribute("maxlength", strFormat.length, 0);
					break;
			}

			switch( arg.className )
			{
				case "iNum"	:
				case "iNum3D"	:
				case "iNumB"	:
				case "iFull"	:
				case "iFull3D"	:
				case "iFullB"	:
				case "iHan"	:
				case "iHan3D"	:
				case "iHanB"	:
				case "iDate"	:
				case "iDate3D"	:
				case "iDateB"	:
				case "iTime"	:
				case "iTime3D"	:
				case "iTimeB"	:
				case "iDigit"	:
				case "iDigit3D"	:
				case "iDigitB"	:
				case "iSsn"	:
				case "iSsn3D"	:
				case "iSsnB"	:
				case "iStr"	:
				case "iStr3D"	:
				case "iStrB"	:
				case "iMask"	:
				case "iMask3D"	:
				case "iMaskB"	:
					arg.ffocus	= arg.onfocus;
					arg.fblur	= arg.onblur;
					arg.fkeyPress	= arg.onkeypress;
					arg.fkeyUp	= arg.onkeyup;						
					arg.onfocus	= sub_EvtFocus;
					arg.onblur	= sub_EvtBlur;
					arg.onkeypress	= sub_EvtKeyPress;
					arg.onkeyup	= sub_EvtKeyUp;
					break;
			}
		}
*/


	//*********************************************************************
	// Method	: String.rightTrim
	// Purpose	: Trims trailing whitespace chars
	// Inputs	: None
	// Returns	: String
	//*********************************************************************
	String.prototype.rightTrim = function (){
		var objRegExp = /^([\w\W]*)(\b\s*[　]*[ ]*)$/;
		if(objRegExp.test(this))
		{
			return this.replace(objRegExp,'$1');
		}
		return this;
	}

	//*********************************************************************
	// Method	: String.leftTrim
	// Purpose	: Trims leading whitespace chars
	// Inputs	: None
	// Returns	: String
	//*********************************************************************
	/*
	String.prototype.leftTrim = function ()
	{
		var objRegExp = /^(\s*[　]*)(\b[\w\W]*)$/;
		if(objRegExp.test(this))
		{
			return this.replace(objRegExp,'$2');
		}
		return this;
	}
	*/
	String.prototype.leftTrim = function (){
		var objRegExp = /^(\s*[　]*)(\b[\w\W]*)$/;
		if(objRegExp.test(this))
		{
			return this.replace(objRegExp,'$2');
		}
		return this;
	}

	//*********************************************************************
	// Method	: String.trim
	// Purpose	: Removing leading and trailing space.
	// Inputs	: None
	// Returns	: String
	//*********************************************************************

	String.prototype.trim = function (){
		var objRegExp = /^(\s*[　]*[ ]*)$/;
		if(objRegExp.test(this))
		{
			var strValue = this.replace(objRegExp,'');
			if( strValue.length == 0 ) return strValue;
		}

		objRegExp = /^(\s*[　]*[ ]*)([\w\W]*)(\b\s*[　]*[ ]*$)/;
		if(objRegExp.test(this))
		{
			return this.replace(objRegExp,'$2');
		}
		return this;
	}

	//*********************************************************************
	// Method	: String.trimAll
	// Purpose	: Removing all space.
	// Inputs	: None
	// Returns	: String
	//*********************************************************************
	String.prototype.trimAll = function (){
		var objRegExp = /\s+|\s+$|　| /g;
		if(objRegExp.test(this))
		{
			return this.replace(objRegExp,'');
		}

		return this;
	}

	//*********************************************************************
	// Method	: String.specialChr
	// Purpose	: Special Chracter Replace
	// Inputs	: None
	// Returns	: String
	//*********************************************************************
	String.prototype.specialChr = function ()
	{
		var objRegExp = /\"|\&|\+|\'|\<|\>/g;
		var retStr    = this;

		if(objRegExp.test(this))
		{
			retStr = this.replace(/\"/g,'%22');
			retStr = this.replace(/\&/g,'%26');
			retStr = this.replace(/\+/g,'%2B');
			retStr = this.replace(/\'/g,'%27');
			retStr = this.replace(/\</g,'%26lt');
			retStr = this.replace(/\>/g,'%26gt');
		}

		return retStr;
	}

	//*********************************************************************
	// Method	: String.toInt
	// Purpose	: String to Integer
	// Inputs	: None
	// Returns	: Integer
	//*********************************************************************
	String.prototype.toInt = function ()
	{
		var objRegExp = /,/g;
		var retStr    = this;

		if(objRegExp.test(this))
		{
			retStr = this.replace(objRegExp,"");
		}

		return parseInt(retStr,10);
	}

	//*********************************************************************
	// Method	: String.toFloat
	// Purpose	: String to Float
	// Inputs	: None
	// Returns	: Float
	//*********************************************************************
	String.prototype.toFloat = function ()
	{
		var objRegExp = /,/g;
		var retStr    = this;

		if(objRegExp.test(this))
		{
			retStr = this.replace(objRegExp,"");
		}

		return parseFloat(retStr);
	}
}

//*----- 입력 필드 / 읽기전용 필드 리셋 -----*//
function ncFrm_ResetField(argObj, argClass)
{
	if (argClass.substr(0,1)=="i"){		//입력필드
		argObj.readOnly = false
		argObj.disabled = false
	}
	else if (argClass.substr(0,1)=="r"){	//읽기전용필드
		argObj.readOnly = true
		argObj.disabled = true
	}
	else {
		alert("Class 설정이 안되었습니다.")
		return;
	}
	argObj.className = argClass
}

function ncFrm_ResetAllField(argObj, argClass){
	for (var i=0; i<argObj.length; i++)
		ncFrm_ResetField(argObj[i], argClass)
}

//------------------------------------------//
//*----- 공통 및 SUB Window 관리 함수 -----*//
//------------------------------------------//



//*====================================================================
// Function	: errProcess
// Purpose	: Error Handler
// Inputs	: Input Object
// Returns	: false
//*====================================================================
function errProcess( argEl )
{
	argEl.style.backgroundColor = errColor;

	_g_PrevOEl = argEl ;
	return(false);
}

//-----------------------------------------------//
//*----- 관리자 사용 함수 (prefix : sub_ ) -----*//
//-----------------------------------------------//



function sub_ChkNumFormat(oEl)
{
	var max;
	var strFormat = oEl.getAttribute("format");
	var val;
	var rest;

	if( strFormat == null || strFormat == "") {
		max = oEl.getAttribute("maxlength");
		max = parseInt(max);
		
		val = Math.floor(max / 3);
		rest = max % 3;
		
		if(rest != 0)
			oEl.setAttribute("maxlength", max + val, 0);
		else
			oEl.setAttribute("maxlength", max + val - 1, 0);
		

		if( oEl.value == "" ) oEl.value = "0";
	} else {
		var decNum = strFormat.substr(0,2) - 0;
		var floatNum = strFormat.substr(2,2) - 0;

		max = decNum - floatNum;
		val = Math.floor(max / 3);
		rest = max % 3;

		if(rest != 0)
			oEl.setAttribute("maxlength", max + val + 1 + floatNum, 0);
		else
			oEl.setAttribute("maxlength", max + val + floatNum, 0);
			
		var temp = "";
		
		for(var i=0; i<floatNum; i++) temp += "0";
		
		if( oEl.value == "" ) oEl.value = "0." + temp;
	}
}

function sub_ChkTimeFormat(oEl) {
	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format");

	switch(strFormat) {
		case "H" :
		case "M" :
		case "S" :
			oEl.setAttribute("maxlength", "2", 0);
			break;
		case "HM" :
			oEl.setAttribute("maxlength", "5", 0);
			break;
		default :
			oEl.setAttribute("maxlength", "8", 0);
	}
}

function sub_ChkDateFormat(oEl) {

	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format");
	var len;
	switch(strFormat) {
		case "Y" 	:
		case "Y_0"	: len = "4"; break;
		case "M" 	:
		case "D" 	:
		case "M_0" 	:
		case "D_0" 	: len = "2"; break;
		case "YM" 	:
		case "YM_0" 	: len = "7"; break;
		case "DM" 	: len = "5"; break;
		case "0"	:
		default 	: len = "10";
	}
	
	oEl.setAttribute("maxlength", len, 0);
}

function sub_EvtFocus(e)
{
	
	var oEl		 = sub_EventObject(e);
	
	if(_g_PrevOEl != null && _g_PrevOEl != oEl   ) {
		var curOEl = _g_PrevOEl;
		_g_PrevOEl = null ;
		curOEl.value = "" ;
		curOEl.select();
		
		return   ;
	}
	_g_PrevOEl = null ;
	
	var strClass	= sub_ClassName(oEl);

	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format");
	var strValue  = oEl.value.trim();
	var strFilter	= "";
	switch( strClass )
	{

	case "iDate"	:
	case "iDate3D"	:
	case "iDateB"	:
	case "iTime"	:
	case "iTime3D"	:
	case "iTimeB"	:
	case "iSsn"	:
	case "iSsn3D"	:
	case "iSsnB"	:
			oEl.style.imeMode = "disabled";
			break;
	case "iMask"	:
	case "iMask3D"	:
	case "iMaskB"	:
	case "iNum"	:
	case "iNum3D"	:
	case "iNumB"	:
	case "iStr"	:
	case "iStr3D"	:
	case "iStrB"	:
		//oEl.style.imeMode = "active"; break;
			oEl.style.imeMode = "inactive"; break;
	case "iDigit"	:
	case "iDigit3D"	:
	case "iDigitB"	:
			oEl.style.imeMode = "disabled";
			break;

	case "iFull"	:
	case "iFull3D"	:
	case "iFullB"	:
			//topSpace.document.all.IMECtrl.Conv('F'); break;
	case "iHan"	:
	case "iHan3D"	:
	case "iHanB"	:
			oEl.style.imeMode = "active";
			//topSpace.document.all.IMECtrl.Conv('H');
			break;
	}

	if( strFilter != "" && strValue != "" )
	{
		if( (strClass == "iDigit" || strClass == "iDigit3D" || strClass == "iDigitB") && strFormat == "0" )
		{
			var oRegExp	= new RegExp(strFilter);
			strValue	= strValue.replace(oRegExp, '$2');
		}
		else
		{
			var oRegExp	= new RegExp(strFilter,"g");			
			strValue	= strValue.replace(oRegExp, "");
		}

		//*******************************************
		// Remove Mask
		//*******************************************
		oEl.value = strValue;
	}
	oEl.select();

	//*******************************************
	// Perform Original onfocus event handler
	//*******************************************
	if( oEl.ffocus && oEl.ffocus() == false )
	{
		sub_PreventEvent(e);
		return;
	}
}

function sub_EvtReset(e)
{
	sub_StopBubble(e);
	sub_PreventEvent(e);
}

function sub_EvtBlur(e)
{
	var oEl		=  sub_EventObject(e);
	var strClass	= sub_ClassName(oEl);
	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format");
	var strNextEvent = oEl.getAttribute("nextEvent") ;
	var strValue	= oEl.value;
	if( strValue.trimAll() == "" ) {
		oEl.style.backgroundColor = "";
		if(strNextEvent != null && strNextEvent != "") eval( "window."+strNextEvent);
		return false;
	}
	switch( strClass )
	{
	case "iDate"	:
	case "iDate3D"	:
	case "iDateB"	:
			strValue = sub_DateValidation(oEl);
			if( strValue == null || typeof(strValue) == "undefined") {
				errProcess(oEl);
				return false;
			}
			strValue = sub_MaskDate(strFormat, strValue);
			break;
	case "iTime"	:
	case "iTime3D"	:
	case "iTimeB"	:
			var oRegExp;

			switch(strFormat)
			{
			case "H" 	: oRegExp = /^([0-2][0-9])$/;
						strValue = sub_MaskTime(strValue, strFormat);
						
						if(  ( strValue != "" && !oRegExp.test(strValue) ) || strValue  >= "24"  )
						{
							alert("시간 입력 오류입니다!");
							errProcess(oEl);
							return false;
						}
				break;
			case "M" 	:
			case "S" 	:
				oRegExp = /^([0-5][0-9])$/; break;
			case "HM" 	: oRegExp = /^([0-2][0-9]):([0-5][0-9])$/; break;
			default 	: oRegExp = /^([0-2][0-9]):([0-5][0-9]):([0-5][0-9])$/;
			}

			strValue = sub_MaskTime(strValue, strFormat);
			
			if( strValue != "" && !oRegExp.test(strValue) )
			{
				alert("시간 입력 오류입니다!");
				errProcess(oEl);
				return false;
			}
			break;

	case "iSsn"	:
	case "iSsn3D"	:
	case "iSsnB"	:
			var oRegExp	= /^([0-9]{6})\-([0-9]{7})$/;
			strValue = sub_MaskSSN(strValue);

//			if( strValue != "" && !oRegExp.test(strValue) )
//			{
//				alert("주민번호 입력 오류입니다!");
//				errProcess(oEl);
//				return;
//			}
			break;
	case "iMask"	:
	case "iMask3D"	:
	case "iMaskB"	:
	//		strValue = sub_MaskCustom(strValue, strFormat);
			break;
	case "iNum"	:
	case "iNum3D"	:
	case "iNumB"	:

			if(strValue.indexOf(".") >= 0) {
				var strTmp;
				var len = parseInt(strFormat.substr(2,2));
				strTmp = strValue.split(".");
				if(strTmp[1].length > len) {
					strTmp[1] = strTmp[1].substr(0,len);
				}
				oEl.value = strTmp.join(".");

			}
			strValue = sub_MaskNumber(oEl);
			break;
	case "iDigit"	:
	case "iDigit3D" :
	case "iDigitB"	:

			if( strFormat != "" )
			{
				var strMask	= "";
				var intMaskLen	= oEl.maxLength - strValue.length;

				for( var i=0; i<intMaskLen; i++ )
					strMask += strFormat;

				strValue = strMask + strValue;
			}
			break;
	case "iFull"	:
	case "iFull3D"	:
	case "iFullB"	:
			//topSpace.document.all.IMECtrl.Conv('N'); break;
	case "iHan"	:
	case "iHan3D"	:
	case "iHanB"	:
			//topSpace.document.all.IMECtrl.Conv('E'); break;
	}
	if(strNextEvent != null && strNextEvent != "") eval( "window."+strNextEvent);
	//*******************************************
	// Set Masked Value
	//*******************************************
	oEl.value = strValue;

	//*******************************************
	// Reset Error Color
	//*******************************************
	oEl.style.backgroundColor = '';

	//*******************************************
	// Perform Original onblur event handler
	//*******************************************
	if( oEl.fblur && oEl.fblur() == false )
	{
		sub_PreventEvent(e);
		return;
	}
	
	
}

function sub_EvtKeyPress(e)
{
	var oEl		=  sub_EventObject(e);
	var strClass	= sub_ClassName(oEl);
	var strValue 	= oEl.value;
	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format");
	var strFilter	= "";

	oEl.style.backgroundColor = '#DEFDD2'

	switch( strClass )
	{

	case "iSsn"	:
	case "iSsn3D"	:
	case "iSsnB"	:
	case "iDigit"	:
	case "iDigit3D"	:
	case "iDigitB"	:
	case "iTime"	:
	case "iTime3D"	:
	case "iTimeB"	:
	case "iDate"	:
	case "iDate3D"	:
	case "iDateB"	:
			strFilter = "[0-9]";
			break;
	case "iNum"	:
	case "iNum3D"	:
	case "iNumB"	:
			var isInteger	= ( strFormat.length == 4 )? false : true;
	
			if(strValue.indexOf(".") > 0) {
				
				var floatNum = strFormat.substr(2,2) - 0;
				var arrStr = strValue.split(".");
				//if( oEl.getAttribute("maxlength") > strValue.length && arrStr[1].length == floatNum) { return false;}
			}

			if(isInteger) {
				max = parseInt( oEl.getAttribute("maxlength") ) ;
				if(max < strValue.length && sub_KeyCode(e) != 46 && sub_KeyCode(e) != 8) return false ;
			}
			if( !isInteger   && strValue.indexOf(".") < 0 && sub_KeyCode(e) != 46) {
				
				var decNum = strFormat.substr(0,2) - 0;
				var floatNum = strFormat.substr(2,2) - 0;
				var diff = decNum - floatNum;
				var len = ((diff % 3) != 0)? diff + Math.floor((diff / 3)) : diff + (Math.floor(diff / 3) - 1);
			
				if(strValue.length == len) return false;
			}
			strFilter	= ( isInteger )? "[\\-(0-9)]" : "[\\-(0-9).]";
			break;
	case "iMask"	:
	case "iMask3D"	:
	case "iMaskB"	:
	
			var strTemp;
			
			if(strValue.length == strFormat.length)
				strTemp = strFormat.charAt(0);
			else
				strTemp = strFormat.charAt(oEl.value.length);

			if(strTemp == "-" || strTemp == "." || strTemp == ":" || strTemp == "_") return false;

			strFilter = (strTemp == "$") ? "[0-9a-zA-Z]" : "[0-9\\s]";
			break;
	}

	
	
	//*******************************************
	// Input 타입별 입력 데이터를 제한한다
	//*******************************************
	if( strFilter != "" ) {
		var oRegExp = new RegExp(strFilter);
		var strKey;
		var keyCode = sub_KeyCode(e) ;
		strKey	= String.fromCharCode(keyCode);
		if( keyCode != 0 && keyCode != 8 && strKey != "\r" && !oRegExp.test(strKey) ) {	
			
			sub_PreventEvent(e);
		}
		sub_SetKeyCode(e, strKey) ;
	}

	//*******************************************
	// Perform Original onkeypress event handler
	//*******************************************
	
	if( oEl.fkeyPress && oEl.fkeyPress() == false )
	{
		
		sub_PreventEvent(e);
		return;
	}
}

function sub_EvtKeyUp(e)
{

	if( strKeys.indexOf(sub_KeyCode(e)+";") > -1 ) return;
	
	var oEl		=  sub_EventObject(e);
	var strClass	=sub_ClassName(oEl);
	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format");
	var strValue	= oEl.value;

	switch( strClass )
	{

	case "iDate"	:
	case "iDate3D"	:
	case "iDateB"	:
			strValue = sub_MaskDate(strFormat, strValue); break;
	case "iTime"	:
	case "iTime3D"	:
	case "iTimeB"	:
			strValue = sub_MaskTime(strValue, strFormat); break;
	case "iNum"	:
	case "iNum3D"	:
	case "iNumB"	:
			var isInteger	= ( strFormat.length == 4 )? false : true;
			strValue	= ( isInteger )? sub_InsCommaInt(strValue) : sub_InsCommaFloat(strValue);
			break;
	case "iSsn"	:
	case "iSsn3D"	:
	case "iSsnB"	:
			strValue	= sub_MaskSSN(strValue); break;
	case "iMask"	:
	case "iMask3D"	:
	case "iMaskB"	:
			strValue	= sub_MaskCustom(strValue, strFormat); break;
	case "iStr"	:
	case "iStr3D"	:
	case "iStrB"	:			
	
			if( strFormat != "" )
			{
				strValue = ( strFormat.toLowerCase() == "uppercase" )? strValue.toUpperCase() : strValue.toLowerCase();
			}
			
			break;
	default :
			sub_AutoSkip(e, oEl, strValue);
			if( oEl.fkeyUp && oEl.fkeyUp() == false )
				sub_PreventEvent(e);
			return;
	}

	if(escape(strValue.substr(strValue.length - 1, 1)).substr(0,2) != "%u") oEl.value = strValue;
	
	//*******************************************
	// Perform AutoSkip
	//*******************************************
	sub_AutoSkip(e, oEl, strValue);



	//*******************************************
	// Perform Original onkeyup event handler
	//*******************************************
	if( oEl.fkeyUp && oEl.fkeyUp() == false )
	{
		sub_PreventEvent(e);
		return;
	}

}

function sub_MaskCustom(argValue, argFormat) {

	argValue = argValue.toUpperCase();
	var strValue = "";
	var pos = 0;
	var tmp = "";

	for(var i=0; i<argValue.length; i++) {

		if(argValue.charAt(i) != "-" && argValue.charAt(i) != "." && argValue.charAt(i) != ":" && argValue.charAt(i) != "_") {
			tmp = argFormat.charAt(pos + 1);
			if(tmp == "-" || tmp == "." || tmp == ":" || tmp == "_") {
				strValue += argValue.charAt(i) + tmp;
				pos = pos + 2;
			} else {
				strValue += argValue.charAt(i);
				pos++;
			}
		}
	}

	return strValue;
}

function sub_DateValidation(argEl)
{
	var oEl		= argEl;
	var oForm	= oEl.form;
	var oRegExp	= new RegExp("\\" + strDateSeparate);
	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format").toUpperCase();
	var strTmp	= oEl.value;

	while( oRegExp.test( strTmp ) )
	{
		strTmp	= strTmp.replace(oRegExp, "");
	}

	var intLen	= strTmp.length;

	switch( strFormat )
	{
	case "Y"	:
		if( intLen != 4 ) { alert("년도(YYYY) 입력 오류입니다."); return(null); }
		break;
	case "M"	:
	case "D"	:
		if( intLen > 2 )
		{
			var errMsg = ( strFormat == "M" )? "월(MM) 입력 오류입니다." : "일(DD) 입력 오류입니다.";
			alert(errMsg);
			return(null);
		}

		var oColl = window.document.all.tags("INPUT");
		var oEnum = new Enumerator(oColl);
		var index = 0;
		for (; !oEnum.atEnd(); oEnum.moveNext())
		{
			if ( oEnum.item() == oEl ) break;
			index++;
		}

		if( strFormat == "M" )
		{
			if( !sub_MonthValidation(strTmp.toInt()) ) return(null);
		}
		else
		{
			var intYear	= oColl[index-2].value.toInt();
			var intMM	= oColl[index-1].value.toInt();
			var intDD	= strTmp.toInt();

			if( !sub_DayValidation(intYear, intMM, intDD) ) return(null);
		}
		if( intLen == 1 ) strTmp = "0" + strTmp
		break;
	case "YM"	:
		if( intLen != 6 ) { alert("년월(YYYYMM) 입력 오류입니다."); return(null); }
		if( !sub_MonthValidation(strTmp.substr(4,2).toInt()) ) return(null);
		break;
	case "DM"	:
		if( intLen != 4 ) { alert("일월(DDMM) 입력 오류입니다."); return(null); }
		if( !sub_MonthValidation(strTmp.substr(2,2).toInt()) ) return(null);
		if( strTmp.substr(0,2).toInt() > 31) { alert("존재하지 않는 날짜(DD) 입니다."); return(null);}
		break;
	case "0"	:		
		var intYear	= strTmp.substr(0,4).toInt();
		var intMM	= strTmp.substr(4,2).toInt();
		var intDD	= strTmp.substr(6,2).toInt();
		
		if(intMM == 0) {
			if(intDD != 0) {
				alert("일자(DD) 입력 오류입니다.");
				return(null);
			}
		} else {
			if(intDD != 0) {
				if( !sub_MonthValidation(intMM) ) return(null);
				if( !sub_DayValidation(intYear, intMM, intDD) ) return(null);
			}
		}
		
		break;
	default		:
		if( intLen != 8 ) { alert("일자(YYYYMMDD) 입력 오류입니다."); return; }

		var intYear	= strTmp.substr(0,4).toInt();
		var intMM	= strTmp.substr(4,2).toInt();
		var intDD	= strTmp.substr(6,2).toInt();
		
		if( !sub_MonthValidation(intMM) ) return(null);
		
		if( !sub_DayValidation(intYear, intMM, intDD) ) return(null);
		break;
	}

	return(strTmp);
}

function sub_MonthValidation(argIntMM)
{
	var oRegExp = ( argIntMM.toString().length == 1 )? /[1-9]/ : /(10)|(11)|(12)/;

	if( !oRegExp.test(argIntMM) )
	{
		alert("존재하지 않는 날짜(MM) 입니다.");
		return(false);
	}
	return(true);
}

function sub_DayValidation(argIntYear, argIntMM, argIntDD)
{
	var intDateRange= 0;

	switch( argIntMM )
	{
	case 2	: intDateRange = (!(argIntYear % 4) && (argIntYear % 100) || !(argIntYear % 400)) ? 29 : 28; break;
	case 4	:
	case 6	:
	case 9	:
	case 11	: intDateRange = 30; break;
	default : intDateRange = 31; break;
	}

	if( argIntDD > intDateRange || argIntDD < 1 )
	{
		alert("존재하지 않는 날짜(DD) 입니다.");
		return(false);
	}
	return(true);
}

function sub_MaskDate(argFormat, argValue)
{
	var oRegExp;
	var strTmp;
	
	argFormat = argFormat.toUpperCase();
	strTmp = argValue.replace(eval("/\\" + strDateSeparate + "/g"), "");

	if( argFormat == "Y" || argFormat == "M" || argFormat == "D")
	{
		return(strTmp);
	}
	else if( argFormat == "YM" )
	{
		oRegExp	= /([0-9]{4})([0-9]{0,2})/;
		strTmp	= strTmp.replace(oRegExp, "$1" + strDateSeparate + "$2");
	}
	else if( argFormat == "DM") {
		oRegExp	= /([0-9]{2})([0-9]{0,2})/;
		strTmp	= strTmp.replace(oRegExp, "$1" + strDateSeparate + "$2");
	}
	else
	{
		if( strTmp.length == 8 )
		{
			oRegExp	= /([0-9]{4})([0-9]{2})([0-9]{2})/;
			strTmp	= strTmp.replace(oRegExp, "$1" + strDateSeparate + "$2" + strDateSeparate + "$3");
		}
		else
		{
			oRegExp	= eval("/([0-9]{4})\\" + strDateSeparate + "?([0-9]{2})([0-9]{0,2})/");
			if( oRegExp.test(strTmp) )
			{
				strTmp	= strTmp.replace(oRegExp, "$1" + strDateSeparate + "$2" + strDateSeparate + "$3");
			}
			else
			{
				oRegExp	= eval("/([0-9]{4})\\" + strDateSeparate + "?([0-9]{0,2})/");
				strTmp	= strTmp.replace(oRegExp, "$1" + strDateSeparate + "$2");
			}
		}
	}

	return(strTmp);
}

function sub_MaskNumber(argEl)
{
	var oEl		= argEl;
	var strFormat	= ( oEl.getAttribute("format") == null )? "" : oEl.getAttribute("format");
	var isInteger	= ( strFormat.length == 4 )? false : true;

	if( !isInteger )
	{
		var strArr;
		var strInt;
		var strDec;
		var strVal	= oEl.value;
		var intDecLen	= strFormat.substr(2,2).toInt();
		var strExp	= ".[0-9]{" + intDecLen + "}"
		var oRegExp	= new RegExp(strExp);

		if( strVal.indexOf(".") > -1 )
		{
			strArr = strVal.split(".");
			strInt = strArr[0];
			strDec = "." + strArr[1];
		}
		else
		{
			strInt = strVal;
			strDec = ".";
		}

		while( !oRegExp.test(strDec) )
			strDec += "0";

		return(sub_InsCommaFloat(strInt + strDec));
	}
	else
		return(sub_InsCommaInt(oEl.value));
}

function sub_MaskTime(argValue, argFormat)
{
	var strValue = argValue.replace(/:/g, "");
	var oRegExp;

	switch(argFormat)
	{
		case "H" :
		case "M" :
		case "S" :
			oRegExp	= /(\d{2})/;
			strValue= strValue.replace(oRegExp, "$1");
			break;
		case "HM" :
			oRegExp	= /(\d{2})(\d{0,2})/;
			strValue= strValue.replace(oRegExp, "$1:$2");
			break;
		default :
			if( strValue.length == 6 )
			{
				oRegExp	= /(\d{2})(\d{0,2})(\d{0,2})/;
				strValue= strValue.replace(oRegExp, "$1:$2:$3");
			}
			else
			{
				oRegExp	= /:?(\d{2})(\d{0,2})/g;
				while( oRegExp.test(strValue) )
				{
					strValue = strValue.replace(oRegExp, "$1:$2")
				}
			}
	}

	return(strValue);
}

function sub_MaskSSN(argValue)
{
	var oRegExp	= /(\d{6})(\d{0,7})/;
	var strTemp	= argValue.replace("-", "");

	return(strTemp.replace(oRegExp, "$1-$2"));
}

function sub_InsCommaInt(argStr)
{

	var oRegExp	= /(-?[0-9]+)([0-9]{3})/;
	argStr		= argStr.toString().replace(/,/g, "");

	while( oRegExp.test(argStr) )
	{
		argStr = argStr.replace(oRegExp, "$1,$2");
	}

	return argStr;
}

function sub_InsCommaFloat(argStr)
{
	var strArr;
	var strInt;
	var strDec;

	argStr = argStr.toString();

	if( argStr.indexOf(".") > -1 )
	{
		strArr = argStr.split(".");
		strInt = strArr[0];
		strDec = "." + strArr[1];
	}
	else
	{
		strInt = argStr;
		strDec = "";
	}

	strInt = sub_InsCommaInt(strInt);
	return(strInt + strDec);
}

function sub_DelComma(argStr)
{
	var oRegExp	= /,/g;
	argStr		= argStr.toString();

	while( oRegExp.test(argStr) )
	{
		argStr = argStr.replace(oRegExp, "");
	}

	return argStr;
}


//*----- 날짜 체크(년월일 합쳐진 필드) -----*//
function sub_DateFull(argYear, argMonth, argDate){
//	구버젼 : comDate_Chk(argYear, argMonth, argDate)

	if(isNaN(argYear) || isNaN(argMonth) || isNaN(argDate)) return false;

	cDate = new Array(29, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	if(argMonth<1 || argMonth>12) return false;
	if(argDate<1 || argDate>cDate[argMonth]) {
		if(argMonth==2) {
			if(((argYear%4==0) && (argYear%100!=0)) || (argYear%400==0)) {
				if(argDate>=1 && argDate<=cDate[0]) return true;
			}
			else {
				if(argDate>=1 && argDate<=cDate[argMonth]) return true;
			}
		}
		return false;
	}
	return true;
}

//*----- 날짜 체크(년월일 분리된 필드) -----*//
function sub_DateSep(argDateCheck, argYear, argMonth){
//	구버젼 : txtDate_Sub(argDateCheck, argYear, argMonth)
	src = event.srcElement
	switch (argDateCheck) {
	case "YM" :
		if (parseFloat(argMonth) > 12 || parseFloat(argMonth) < 1) {
			alert("정확한 월을 입력하여 주십시오.");src.value = "";src.focus()
		};
		break;
	case "M" :
		if (parseFloat(src.value) > 12 || parseFloat(src.value) < 1) {
			alert("정확한 월을 입력하여 주십시오.");src.value = "";src.focus()
		};
		break;
	case "D" :
		switch (parseFloat(argMonth)) {
		case 2 : dateRange = (!(argYear % 4) && (argYear % 100) || !(argYear % 400)) ? 29 : 28; break;
		case 4:
		case 6:
		case 9:
		case 11:  dateRange = 30; break
		default : dateRange = 31
		}
		if (parseFloat(src.value) > dateRange || parseFloat(src.value) < 1) {
			alert("정확한 일을 입력하여 주십시오.");src.value = "";src.focus()
		};
		break;
	default :
	}
	if (src.value.length == 1) src.value = "0" + src.value
}

//*--  필드 AutoSkip  --*//
//*====================================================================
// Function	: sub_AutoSkip
// Purpose	: 입력 커서 자동 이동
// Inputs	: None
// Returns	: None
//*====================================================================

var strKeys = "8;16;46;37;38;39;40;33;34;35;36;45;229;21;27;17;18;20;91;"


function sub_AutoSkip(e, argEl, argValue)
{
	
	var arrEl = argEl.form.elements;

	if (argEl.getAttribute("end") != null || argEl.getAttribute("END") != null) return;

	if( argValue == null  || sub_KeyCode(e)==13 || typeof(argValue) == "undefined" ) return(false);

	//*******************************************
	// 방향키는 무시한다
	//*******************************************
	if( strKeys.indexOf(sub_KeyCode(e)+";") > -1 ) return;
	
	if(argEl.maxLength < 0 ) return ;

	if( argValue.length  >=  argEl.maxLength )
	{
		var i=0
		while( argEl != arrEl[i] )  i++

		if( (i+1) != arrEl.length )
		{
			while(  ( arrEl[i+1].type		== "hidden" )	||
				( arrEl[i+1].type		== "button" )	||
				( arrEl[i+1].type		== "checkbox" ) ||
				( arrEl[i+1].type		== "radio" )	||
				( arrEl[i+1].tagName		== "FIELDSET" ) ||
				( arrEl[i+1].tagName		== "OBJECT" )	||
				( arrEl[i+1].tagName		== "APPLET" )	||
				( arrEl[i+1].className.substr(0,1) == "r"  )	||
				( arrEl[i+1].style.display	== "none" )	||
				( arrEl[i+1].style.visibility	== "hidden" )	||
				( arrEl[i+1].disabled		== true )  )
			{
				i++
				if( (i+1) == arrEl.length ) return;
			}
		}
		else
		{
			arrEl[i].focus();
			return(false);
		}

		arrEl[i+1].focus();

		var strTagName = arrEl[i+1].tagName;
		if( strTagName != "SELECT")
		{
			arrEl[i+1].select();
		}
		else if( strTagName == "SELECT" )
		{
			if( arrEl[i+1].value == null || arrEl[i+1].selectedIndex == -1 )
    				arrEl[i+1].value = "";
		}
	}
}

//*--  공통화면 drag 관련 --*//

function sub_MouseMoveCom(e) {

	if ((1 == event.button) && (elDragged != null)) {
		var intTop = event.clientY + document.body.scrollTop;
		var intLeft = event.clientX + document.body.scrollLeft;

		var intLessTop  = 0;
		var intLessLeft = 0;
		var elCurrent = elDragged.offsetParent;

		while (elCurrent.offsetParent != null) {
			intLessTop += elCurrent.offsetTop;
			intLessLeft += elCurrent.offsetLeft;
			elCurrent = elCurrent.offsetParent;
		}

		var mTop = parseInt(selfWin.style.top)
		var mLeft = parseInt(selfWin.style.left)

		selfWin.style.top = mTop + intTop  - intLessTop - elDragged.y
		selfWin.style.left = mLeft + intLeft - intLessLeft - elDragged.x

		sub_PreventEvent(e);
	}
}

function sub_CheckDrag(elCheck) {
	while (elCheck != null) {
		if ( elCheck.className.substr(0,9) =="sComTitle")
			return elCheck;
		elCheck = elCheck.parentElement;
	}
	return null;
}

function sub_MouseDownCom() {

	var elCurrent = sub_CheckDrag(event.srcElement);


	if (null != elCurrent) {
		elDragged = elCurrent;
		elDragged.x = event.offsetX;
		elDragged.y = event.offsetY;

		var op = event.srcElement;

		if ((elDragged != op.offsetParent) && (elDragged != event.srcElement)) {
			while (op != elDragged) {
				elDragged.x += op.offsetLeft;
				elDragged.y += op.offsetTop;
				op = op.offsetParent;
			}
		}
	}
}

function sub_SelectCom() {
	return (null == sub_CheckDrag(event.srcElement) && (elDragged!=null));
}

function sub_MouseUpCom() {
	var TOP = parseInt(selfWin.style.top);
	if (TOP < 0) {
		selfWin.style.top = 0;
	}
	if (TOP > 444) {
		selfWin.style.top = 425;
	}
	var LEFT = parseInt(selfWin.style.left);
	if (LEFT > 744 ) {
		selfWin.style.left = 707;
	}
	if (LEFT < -5 ) {
		selfWin.style.left = 0;
	}

	elDragged = null;
}

function sub_Wheel() {
	var obj = event.srcElement;
	if (event.wheelDelta >= 120) {
		obj.scrollUp();
	}
	else if (event.wheelDelta <= -120) {
		obj.scrollDown();
	}
}

function sub_Event(e) {
	 var evt = e || window.event;
	 return evt ;

}

function sub_EventObject(e) {
	var evt  = sub_Event(e) 
	var evtObject =	evt.target ||  evt.srcElement;

	 return evtObject ;

}
function sub_KeyCode(e) {
	var result = ""; 
    if(typeof(e) != "undefined") 
        result = e.which; 
    else 
        result = event.keyCode; 

    return result ;
}
function sub_PreventEvent(e) {
	if(typeof(e) != "undefined") 
		e.preventDefault() ;
    else 
		event.returnValue=false ; 
}
function sub_StopBubble(e) {
	if (e){
		e.stopPropagation();
	} else {
		window.event.cancelBubble = true;
	}
}
function sub_SetKeyCode(e, argCharCode) {
	if(typeof(e) != "undefined")  {
		//e.charCode = argCharCode.charCodeAt(0) ;
    } else  {
		event.keyCode = argCharCode.charCodeAt(0) ;	
	}
}

function sub_ClassName(argEl) {
	var className = "" ;
	var arrClassName ;
	className = argEl.className ;
	arrClassName = className.split(" ");
	return arrClassName[0];
}
