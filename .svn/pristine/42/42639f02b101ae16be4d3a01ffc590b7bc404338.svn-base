
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Iterator"%>
<%@page import="egovframework.com.utl.fcc.service.EgovStringUtil"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Enumeration"%>
<html>
<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />" ></script>
<%
	HashMap<String, String> msgInfo = (HashMap<String, String>)request.getAttribute("MSGINFO") ;
	String mode = msgInfo.get("MODE") ;
	String message = msgInfo.get("MSG") ;
	String uri = msgInfo.get("URI");
	String param = msgInfo.get("PARAM");
	String script = msgInfo.get("SCRIPT");
	String width = msgInfo.get("WIDTH");
	String height = msgInfo.get("HEIGHT");

	String[] temp = null ;
	if( mode.equals("script")) {
		
		out.println("<script language=\"javascript\">" ) ;

		out.println(message);
		out.println("</script>") ;
		return ;
	}

	if("action".equals(mode)) {

		out.println("<script language=\"javascript\"> \n" ) ;
		out.println( "function DOC_LOAD() { \n");
		if( !EgovStringUtil.isEmpty(message) )
			out.println( message +"\n");

		out.println( "frmMain.method= \"post\" ; \n");
		out.println( "frmMain.action= \""+uri+"\" ;\n");
		out.println( "frmMain.submit(); \n");
		out.println("}\n");
		out.println("</script>") ;
		out.println("<body onLoad = 'DOC_LOAD();'>") ;
		out.println("<form name = \"frmMain\" >\n");
		Enumeration  pnames  = request.getParameterNames() ;

		String key = "" ;
		Object value = "" ;
		while (pnames.hasMoreElements()) {
            key = (String) pnames.nextElement();
            value = request.getParameter(key);
            out.println("<input type = 'hidden' name = '"+key+"' value = '"+value+"'>\n");

        }
		out.println("</form>\n");
		out.println("</body>") ;
		return ;
	}

	if( "load".equals(mode)) {
		out.println("<script language=\"javascript\"> \n" ) ;
		out.println( "function DOC_LOAD() { \n");
		out.println( message +"\n");

		out.println("}\n");
		out.println("</script>") ;
		out.println("<body onLoad = 'DOC_LOAD();'>") ;
		out.println(script);
		out.println("</body>") ;
		return ;
	}

	if( "html".equals(mode)) {
		out.println(message) ;
		return ;
	}
	
	if( "popup".equals(mode)) {
		out.println("<script language=\"javascript\"> \n" ) ;
		out.println( "function DOC_LOAD() { \n");
		//out.println( "    alert('test'); \n");
		out.println( "  window.open('"+uri+"', 'popCmmMessage', 'width=" + width + "', 'height=" + height +"' , 'scrollbars=1', 'resizable=1');" ); 
		out.println( "  self.close(); \n");
		out.println("}\n");
		out.println("</script>\n") ;
		out.println("<body onLoad = 'DOC_LOAD();'>\n") ;
		out.println("</body>") ;
		return ;
	}

%>
	</html>