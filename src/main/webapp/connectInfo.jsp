<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@page import="org.springframework.web.context.WebApplicationContext"%>

<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>

<%@page import="org.apache.commons.dbcp2.BasicDataSource" %>
<%@page import="java.net.InetAddress" %>

<%@page import="java.net.UnknownHostException" %>

<%@page import="neos.cmm.util.BizboxAProperties"%>

<%@page import="neos.cmm.util.CommonUtil"%>


<%

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);

BasicDataSource dataSource = (BasicDataSource) context.getBean("egov.dataSource");

String clientIp = ((HttpServletRequest)request).getHeader("X-FORWARDED-FOR");  

if ( clientIp == null || clientIp.length( ) == 0 ) {
	clientIp = ((HttpServletRequest)request).getHeader( "Proxy-Client-IP" );
}

if ( clientIp == null || clientIp.length( ) == 0 ) {
	clientIp = ((HttpServletRequest)request).getHeader( "WL-Proxy-Client-IP" );
}

//Custom property 값 ProxyAddYn이 "Y"경우 header 값 체크 추가 (proxy 및 모든 l4 대응 방안)
if(BizboxAProperties.getCustomProperty("BizboxA.ProxyAddYn").equals("Y")) {
	if(clientIp == null || clientIp.length( ) == 0) {
		clientIp = ((HttpServletRequest)request).getHeader( "HTTP_CLIENT_IP" );
	}
	if(clientIp == null || clientIp.length( ) == 0) {
		clientIp = ((HttpServletRequest)request).getHeader( "HTTP_X_FORWARDED_FOR" );
	}
	if(clientIp == null || clientIp.length( ) == 0) {
		clientIp = ((HttpServletRequest)request).getHeader( "X-Real-IP" );
	}
}
if ( clientIp == null || clientIp.length( ) == 0 ) {
	clientIp = request.getRemoteAddr( );
}

if ( clientIp == null ) {
	clientIp = ""; 
}

if(request.getServerName().equals("localhost")){
	clientIp = "127.0.0.1";
}

// 다수개 존재시 첫번째로 처리를 위함. X-Forwarded-For: client, proxy1, proxy2
if (clientIp.equals("") && clientIp.split(",").length > 0) {
	clientIp = clientIp.split(",")[0];
}

System.out.println("connectInfo.jsp > clientIp : "+ clientIp);

InetAddress local = null;
try { 
	local = InetAddress.getLocalHost(); 
	//String ip = local.getHostAddress(); 
	//System.out.println("local ip : "+ip); 
} 
catch (UnknownHostException e1) { 
	CommonUtil.printStatckTrace(e1);//오류메시지를 통한 정보노출
}

%>

<html>

  <head>

    <title>Status</title>

  </head>

  <body>

    <h2>DataSource Settings</h2>

    Client Ip : <%= clientIp %><br />
    
    Server Ip : <%= local.getHostAddress() %><br />

    JDBC URL: <%= dataSource.getUrl() %><br />

    Pool initial size: <%= dataSource.getInitialSize() %><br />

   Pool max active: <%= dataSource.getMaxTotal() %><br />
   
   Pool min idle: <%= dataSource.getMinIdle() %><br />
   
    Pool max idle: <%= dataSource.getMaxIdle() %><br />

    Number of active connections: <%= dataSource.getNumActive() %><br />

    Number of idle connections: <%= dataSource.getNumIdle() %><br />    
    
    

  </body>

</html>