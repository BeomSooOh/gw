<%@ page import="java.io.*" %>
<%@page import="neos.cmm.util.CommonUtil"%>
<%!
public void setCookie ( HttpServletResponse response, String sName, String sValue )
{
	Cookie c = new Cookie( sName, sValue );
	c.setPath( "/" );
	response.addCookie(c);
}	

public String getCookie ( HttpServletRequest request, String sName )
{
	Cookie[] cookies = request.getCookies();	
	if ( cookies != null ) 
	{	
		for (int i=0; i < cookies.length; i++) 
		{
			String name = cookies[i].getName();
			if( name != null && name.equals(sName) ) 
			{
				return cookies[i].getValue();
			}
		}
	}
	return null;	
}	

public String toHangul( String str )        
{
	if ( str == null )
    	return null;
    	
    String newstr=null;	
    try {	
		newstr = new String( str.getBytes("8859_1"), "KSC5601" );
	}	
	catch (Exception e )
    {  CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출   
    }
        
	if ( newstr!=null && str.length() == newstr.length() )  // ÀÌ¹Ì encoding µÈ °ÍÀÌ¾úÀ¸¸é ¿ø¹®À» »ç¿ëÇÑ´Ù.
		return str;
	else
		return newstr;
}

public String toEng( String str )        
{
	if ( str == null )
    	return null;
    	
    String newstr=null;	
    try {	
		newstr = new String( str.getBytes("KSC5601"), "8859_1" );
	}	
	catch (Exception e )
    {  CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출   
    }
        
	if ( newstr!=null && str.length() == newstr.length() )  // ÀÌ¹Ì encoding µÈ °ÍÀÌ¾úÀ¸¸é ¿ø¹®À» »ç¿ëÇÑ´Ù.
		return str;
	else
		return newstr;
}

%>	