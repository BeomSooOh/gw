/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// loadlayer.js - layer loading
//				
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


if("" == dzeUiConfig.strCustomLanguageSetAndLoad)
{
	if("ko" == g_browserCHK.language)
	{
		g_strBrowserLanguage = g_browserCHK.language;
	}
	else if("ko-kr" == g_browserCHK.language)
	{
		g_strBrowserLanguage = ID_LANGUAGE_TYPE_KO;
	}
	else if("en" == g_browserCHK.language)
	{
		g_strBrowserLanguage = g_browserCHK.language;
	}
	else if("ja" == g_browserCHK.language)
	{
		g_strBrowserLanguage = g_browserCHK.language;
	}
//	else if("zh" == g_browserCHK.language)// 번체
//	{
//		g_strBrowserLanguage = g_browserCHK.language;
//	}
	else if("zh-cn" == g_browserCHK.language)// 간체
	{
		g_strBrowserLanguage = g_browserCHK.language;
	}
	else
	{
		g_strBrowserLanguage = ID_LANGUAGE_TYPE_EN;
	}
}
else
{
	var allowLang = [ID_LANGUAGE_TYPE_KO, ID_LANGUAGE_TYPE_EN, ID_LANGUAGE_TYPE_JA, ID_LANGUAGE_TYPE_ZH_CN];
	if(inArray(dzeUiConfig.strCustomLanguageSetAndLoad.toLowerCase(),allowLang)) {
		g_strBrowserLanguage = dzeUiConfig.strCustomLanguageSetAndLoad.toLowerCase();
	} else {
		g_strBrowserLanguage = ID_LANGUAGE_TYPE_EN;
	}
	
}

document.write('<link rel="stylesheet" href="' + dzeEnvConfig.strPath_CSS + 'menuwin.css" type="text/css">');
document.write('<link rel="stylesheet" href="' + dzeEnvConfig.strPath_CSS + 'proplayer.css" type="text/css">');
document.write('<link rel="stylesheet" href="' + dzeEnvConfig.strPath_CSS + 'webeditor.css" type="text/css">');
document.write('<link rel="stylesheet" href="' + dzeEnvConfig.strPath_CSS + 'menu_ribbon.css" type="text/css">');

document.write('<script type="text/javascript" src="' + dzeEnvConfig.strPath_JS + 'res/' + g_strBrowserLanguage + '/resource.js"></scrip' +'t>');
