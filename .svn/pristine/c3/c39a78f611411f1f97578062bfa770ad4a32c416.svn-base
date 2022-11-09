<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.Properties"%>
<%@page import="com.saltware.enpass.client.EnpassClient"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>


<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<title> </title>
</head>

<body>
<%
	EnpassClient client = new EnpassClient( request, response);
	
	try{
		System.out.println("*================== [Enpass EnpassClient START");
		if( !client.doLogin() ) {
			System.out.println("*================== [Enpass LOGIN FAIL");
			return ; 
		}		
	}
	catch(Exception e){
		System.out.println("*================== [Enpass Error : " + e.getMessage());
	}

	String ret = null;
	String ssoId = null;
	HashMap ssoMap = null;
	String userTpId = null;
	System.out.println("*================== [Enpass START");
	ssoId = (String)session.getAttribute("_enpass_id_");
	System.out.println("*================== [ssoId : " + ssoId);
	ssoMap = (HashMap)session.getAttribute("_enpass_attr_");
	System.out.println("*================== [ssoMap : " + ssoMap.toString());
	System.out.println("*================== [Enpass END");
	if( ssoId != null ) {
		ret = "succ";
	} else {
		ret = "fail";
	}
	
	request.getSession().removeAttribute("_enpass_id_");
	request.getSession().removeAttribute("_enpass_attr_");
	request.getSession().removeAttribute("_enpass_assertion_");
%>

<script type="text/javascript">
	$(document).ready(function() {		
		setTimeout("processLogOn()", 1500);		
	});
	
	var Request = function()
	{
	    this.getParameter = function( name )
	    {
	        var rtnval = '';
	        var nowAddress = unescape(location.href);
	        var parameters = (nowAddress.slice(nowAddress.indexOf('?')+1,nowAddress.length)).split('&');

	        for(var i = 0 ; i < parameters.length ; i++)
	        {
	            var varName = parameters[i].split('=')[0];
	            if(varName.toUpperCase() == name.toUpperCase())
	            {
	                rtnval = parameters[i].split('=')[1];
	                break;
	            }
	        }
	        return rtnval;
	    }
	}

	var request = new Request();
	
	function processLogOn() {
		var param = {};

		param.ssoId = document.getElementById("loginCd").value;
		param.pType = request.getParameter("pType");
		param.pSeq = request.getParameter("pSeq");
		if(request.getParameter("pSeq") == "0") {
			param.pMenu = "0";
		}
		else {
			param.pMenu = request.getParameter("pMenu");
		}
		
		$.ajax({
			type:"POST"
			, dataType: "json"
			, url:"/gw/EnpassLogOn2.do"
			, data: param
			, success: function(result) {
				location.href = result.rURL;
			}
			, error: function (request, status, error){
                alert("code:"+request.status+"\n"+"error:"+error);
            }
		});
	}
	
	function moveLogOn(url) {
	}
</script>

<input type="hidden" id="ret" name="ret" value="<%=ret%>">
<input type="hidden" id="loginCd" name="loginCd" value="<%=ssoId%>">

</body>
</html>