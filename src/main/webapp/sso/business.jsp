<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.apache.commons.httpclient.HttpClient"%>
<%@page import="org.apache.commons.httpclient.methods.GetMethod"%>
<%@page import="org.apache.commons.httpclient.NameValuePair"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.*"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@include file="agentInfo.jsp"%>
<%
    /**
      * penta라는 context path가 존재한다면 path + "origin value"로 입력한다.
      * ex) String path = "/penta";
      * session.setAttribute("SERVICE_BUSINESS_PAGE", path + "/sso/business.jsp");
      */
    String sendUrl = AUTHORIZATION_URL + "login.html";    
    System.out.println("sendUrl : " + sendUrl);
    System.out.println("business page sessionId : " + session.getId());
    
    String CHECK_SERVER_URL = AUTHORIZATION_URL + "openapi/checkserver";
    String resultCode = "unknown code";
    String resultMessage = "server not response";
    boolean isErrorPage = false;
    try {
        int conTimeOut = 5000;
        int soTimeOut = 5000;
        HttpClient httpClient = new HttpClient();
        GetMethod getMethod = new GetMethod(CHECK_SERVER_URL);
        httpClient.setConnectionTimeout(conTimeOut);
		httpClient.setTimeout(soTimeOut);
        httpClient.executeMethod(getMethod);
        
        String httpResponse = getMethod.getResponseBodyAsString();
        getMethod.releaseConnection();
        
        System.out.println("httpResponse : " + httpResponse);
        
        JSONParser parser = new JSONParser();
        Object object = parser.parse(httpResponse);
        JSONObject jsonObject = (JSONObject)object;
        
        resultCode = (String)jsonObject.get("resultCode");
        resultMessage = (String)jsonObject.get("resultMessage");
        
        System.out.println("resultCode :" + resultCode);
        System.out.println("resultMessage :" + resultMessage);
        
        if(resultCode == null || resultCode.equals("000000") == false) {
            throw new Exception();
        }
        
    } catch (Exception e) {
        isErrorPage = true;
        session.setAttribute("isErrorPage", isErrorPage);
        session.setAttribute("resultCode", resultCode);
        session.setAttribute("resultMessage", resultMessage);
        
        System.out.println(e.toString());
        System.out.println(resultCode);
        System.out.println(resultMessage);
        System.out.println(e.toString());
        
        response.sendRedirect("error.jsp");
    }
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>

<body>
    <form name="sendForm" method="post">
        <input type="hidden" name="agentId" value="<%=agentId%>" />
    </form>

    <script>
        var sendUrl = "<%=sendUrl%>";
        var sendForm = document.sendForm;
        
        sendForm.action = sendUrl;
        sendForm.submit();
    </script>
    
</body>
</html>