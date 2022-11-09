/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// browser.js -	브라우저 종류 검사 및 버전 검사
//						
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


var PLATFORMTYPE = {
	NONE : 0,
	WIN32 : 1,
	WIN64 : 2,
	MAC : 3,
	MAC_INTEL : 4
 };

 var BROWSERTYPE = {
	NONE : 0,
	IE : 1,//EXPLORER
	CR : 2,//Chrome
	SF : 3,//SAFARI 
	EG : 4,//EDGE
	OP : 5,//OPERA
	FF : 6//Firefox
 };

function cm_bwcheck()
{	

	this.m_AgentInfo = {
		platform : PLATFORMTYPE.NONE
		,browser : BROWSERTYPE.NONE
		//,nVersion: 10,
	};
	
	this.getPlatformType = function(strPlatform)
	{
		switch(strPlatform)
		{
			default:
			case "win32":	return PLATFORMTYPE.WIN32;
			break;
			case "win64":	return PLATFORMTYPE.WIN64;
			break;
			case "mac":		return PLATFORMTYPE.MAC;
			break;
			case "macintel":	return PLATFORMTYPE.MAC_INTEL;
			break;
		}
	};

	this.getBrowserType = function(strBrowser)
	{
		switch(strPlatform)
		{			
			case "firefox":	return BROWSERTYPE.FF;
			break;
			case "safari":	return BROWSERTYPE.SF;
			break;
			case "webkit":	return BROWSERTYPE.WK;
			break;
			case "edge":	return BROWSERTYPE.EG;
			break;
			case "opera":	return BROWSERTYPE.OP;
			break;			
			case "chorme":	return BROWSERTYPE.CR;
			break;

		}
	};
	
	this.isMacPC = function()
	{
		if(g_browserCHK.m_AgentInfo.platform == PLATFORMTYPE.MAC_INTEL)
			return true;
			
		return false;
	};
	
	this.isWebView = function()
	{
		if(g_browserCHK.iOS) {
			if(g_browserCHK.sf)
				return false;
			else
				return true;
		} else if(g_browserCHK.android) {
			if(g_browserCHK.agent.indexOf("; wv)") > -1)
				return true;
			else
				return false;
		} else
			return false;
	};

	this.agent = navigator.userAgent.toLowerCase();
	
	var strTmpAgent = this.agent.split(" ");

	this.ff = this.edge = this.wk = this.cr = this.op = false;

	this.ff = (this.agent.indexOf("firefox") > -1);

	this.wk = (this.agent.indexOf("webkit") > -1);
	this.cr = false;
	this.sf = false;
	if(this.wk)
	{
		if(this.agent.indexOf("chrome") > -1) {
			this.cr = true;
		} else if(this.agent.indexOf("safari") > -1) {
			this.sf = true;
		}
	}

	this.op = (this.agent.indexOf("opera") > -1);

	this.edge = (this.agent.indexOf("edge") > -1);

	//mobile set
	var filter = "win16|win32|win64|mac|macintel";
	this.mobile = false;
	this.iOS = false;
	this.android = false;
	this.iPad = false;
	this.androidtablet = false;
	if (navigator.platform)
	{
		var strPlatform = navigator.platform.toLowerCase();
		if (filter.indexOf(strPlatform) < 0) 
		{	//mobile
			this.mobile = true;
			
			if (this.agent.indexOf("iphone") > -1 || this.agent.indexOf("ipad") > -1 || this.agent.indexOf("ipot") > -1) 
			{
				this.iOS = true;
				
				if(this.agent.indexOf("ipad") > -1) {
					this.iPad = true;
				}
			}
			
			if (this.agent.indexOf("android") > -1)
			{
				this.android = true;
				
				if (this.agent.indexOf("mobile") == -1) {
					this.androidtablet = true;
				}
			}
		} 
		else 
		{
			//pc
			this.m_AgentInfo.platform = this.getPlatformType(strPlatform);
			//this.m_AgentInfo.browser = this.getBroserType(strTmpAgent[10]);			
		}
	}
	
	if(this.ff || this.wk || this.op){}
	else
	{
		this.ie10 = (this.agent.indexOf("msie 10") > -1);
		this.ie9 = (this.agent.indexOf("msie 9") > -1 && !this.ie10);
		this.ie8 = (this.agent.indexOf("msie 8") > -1 && !this.ie9 && !this.ie10);
		this.ie7 = (this.agent.indexOf("msie 7") > -1 && !this.ie8 && !this.ie9 && !this.ie10);
		this.ie6 = (this.agent.indexOf("msie 6") > -1 && !this.ie7 && !this.ie8 && !this.ie9 && !this.ie10);

		if(this.ie6 || this.ie7 || this.ie8 || this.ie9 || this.ie10){}
		else
		{
			if(this.agent.indexOf("mozilla/5.0") > -1)
			{
				this.ie11 = true;
			}
		}

		this.ie = (this.ie6 || this.ie7 || this.ie8 || this.ie9 || this.ie10 || this.ie11);
	}


	if(this.ie)
	{
		if(this.ie6) { this.verInfo = 6; }
		else if(this.ie7) { this.verInfo = 7; }
		else if(this.ie8) { this.verInfo = 8; }
		else if(this.ie9) { this.verInfo = 9; }
		else if(this.ie10) { this.verInfo = 10; }
		else if(this.ie11) { this.verInfo = 11; }
	}

	if(this.ff)
	{
		this.verInfo = 99;
	}

	this.bw = (this.ie || this.ff || this.wk || this.op);


	if(navigator.userLanguage)
	{
		this.language = navigator.userLanguage.toLowerCase();
	}
	else if (navigator.language)
	{
		this.language = navigator.language.toLowerCase();
	}
	else
	{
		this.language = null;
	}

	return this;
}

var g_browserCHK = new cm_bwcheck();
