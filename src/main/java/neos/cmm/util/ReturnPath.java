package neos.cmm.util;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.com.utl.fcc.service.EgovStringUtil;

public class ReturnPath {
	public static void historyBack( HttpServletRequest request,  String msg ) {
		Map<String, String> resultMap   = new  HashMap<String, String>();

		resultMap.put("MODE", "script") ;
		resultMap.put("MSG", "alert('"+msg+"'); history.back(-1); ") ;
		resultMap.put("srcMsg", msg);
		request.setAttribute("MSGINFO", resultMap) ;
	}
	public static void scriptAlert( HttpServletRequest request,  String msg ) {
		Map<String, String> resultMap   = new  HashMap<String, String>();

		resultMap.put("MODE", "script") ;
		resultMap.put("MSG", "alert('"+msg+"'); ") ;

		request.setAttribute("MSGINFO", resultMap) ;
	}
	public static void  scriptHtml(HttpServletRequest request,  String msg ) {
		Map<String, String> resultMap   = new  HashMap<String, String>();

		resultMap.put("MODE","html") ;
		resultMap.put("MSG", msg);

		request.setAttribute("MSGINFO", resultMap) ;
	}
	public static void  scriptClose(HttpServletRequest request,  String msg ) {
		Map<String, String> resultMap   = new  HashMap<String, String>();

		resultMap.put("MODE","script") ;
		resultMap.put("MSG", "alert('"+msg+"'); \n  self.close();") ;
		resultMap.put("srcMsg", msg);
		request.setAttribute("MSGINFO", resultMap) ;
	}
	public static void  scriptPath(HttpServletRequest request,  String msg, String uri ) {
		Map<String, String> resultMap   = new  HashMap<String, String>();

		resultMap.put("MODE", "script") ;
		if( !EgovStringUtil.isEmpty(msg) ) {
			resultMap.put("MSG", "alert('"+msg+"'); \n document.location.href =\""+uri+"\";") ;
			resultMap.put("srcMsg", msg);

		}else {
			resultMap.put("MSG", "document.location.href =\""+uri+"\";") ;
		}
		resultMap.put("srcUri", uri);

		request.setAttribute("MSGINFO", resultMap) ;
	}
	public static void  scriptPath(HttpServletRequest request,   String uri ) {
		scriptPath(request, "", uri);
	}
	public static void  script(HttpServletRequest request,  String str) {
		Map<String, String> resultMap   = new  HashMap<String, String>();

		resultMap.put("MODE", "script") ;
		resultMap.put("MSG", str) ;
		request.setAttribute("MSGINFO", resultMap) ;
	}

	public static void  actionPath(HttpServletRequest request,  String msg, String uri  , String param) {
		Map<String, String> resultMap   = new  HashMap<String, String>();
		if( !EgovStringUtil.isEmpty(msg) ) {
			resultMap.put("MSG", "alert('"+msg+"'); ") ;
		}

		resultMap.put("MODE", "action") ;
		resultMap.put("PARAM", param) ;
		resultMap.put("URI", uri) ;
		request.setAttribute("MSGINFO", resultMap) ;
	}

	public static void  actionPath(HttpServletRequest request,  String uri  , String param) {
		actionPath(request, "", uri, param) ;
	}
	public static void  actionPath(HttpServletRequest request,  String uri) {
		actionPath(request, "", uri, "") ;
	}
	public static void  docLoad(HttpServletRequest request,  String str, String script) {
		Map<String, String> resultMap   = new  HashMap<String, String>();
		resultMap.put("MODE", "load") ;
		resultMap.put("MSG", str) ;
		resultMap.put("SCRIPT", script) ;
		request.setAttribute("MSGINFO", resultMap) ;
	}

	public static void  docLoad(HttpServletRequest request,  String str) {
		docLoad(request, str, "");
	}

	public static Map<String, Object> historyBackMap(String msg ) {

		Map<String, String> dataMap   = new  HashMap<String, String>();
		Map<String, Object> resultMap = new  HashMap<String, Object>();

		dataMap.put("MODE", "script") ;
		dataMap.put("MSG", "alert('"+msg+"'); history.back(-1); ") ;
		resultMap.put("MSGINFO", dataMap);
		return resultMap;
	}

	public static Map<String, Object> scriptPathMap(String msg, String uri ) {
		Map<String, String> dataMap   = new  HashMap<String, String>();
		Map<String, Object> resultMap = new  HashMap<String, Object>();

		dataMap.put("MODE", "script") ;
		if( !EgovStringUtil.isEmpty(msg) ) {
			dataMap.put("MSG", "alert('"+msg+"'); \n document.location.href =\""+uri+"\";") ;
		}else {
			dataMap.put("MSG", "document.location.href =\""+uri+"\";") ;
		}
		resultMap.put("MSGINFO", dataMap);
		return resultMap;
	}

	public static void scriptPopup( HttpServletRequest request,  String uri, String width, String height ) {
		Map<String, String> resultMap   = new  HashMap<String, String>();
		resultMap.put("MODE", "popup") ;
		resultMap.put("URI", uri) ;
		resultMap.put("WIDTH", width) ;
		resultMap.put("HEIGHT", height) ;
		request.setAttribute("MSGINFO", resultMap) ;
		
	}
}

