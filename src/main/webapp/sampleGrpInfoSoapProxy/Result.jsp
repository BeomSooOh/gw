<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<HTML>
<HEAD>
<TITLE>Result</TITLE>
</HEAD>
<BODY>
<H1>Result</H1>

<jsp:useBean id="sampleGrpInfoSoapProxyid" scope="session" class="org.tempuri.GrpInfoSoapProxy" />
<%
if (request.getParameter("endpoint") != null && request.getParameter("endpoint").length() > 0)
sampleGrpInfoSoapProxyid.setEndpoint(request.getParameter("endpoint"));
%>

<%
String method = request.getParameter("method");
int methodID = 0;
if (method == null) methodID = -1;

if(methodID != -1) methodID = Integer.parseInt(method);
boolean gotMethod = false;

try {
switch (methodID){ 
case 2:
        gotMethod = true;
        java.lang.String getEndpoint2mtemp = sampleGrpInfoSoapProxyid.getEndpoint();
if(getEndpoint2mtemp == null){
%>
<%=getEndpoint2mtemp %>
<%
}else{
        String tempResultreturnp3 = org.eclipse.jst.ws.util.JspUtils.markup(String.valueOf(getEndpoint2mtemp));
        %>
        <%= tempResultreturnp3 %>
        <%
}
break;
case 5:
        gotMethod = true;
        String endpoint_0id=  request.getParameter("endpoint8");
            java.lang.String endpoint_0idTemp = null;
        if(!endpoint_0id.equals("")){
         endpoint_0idTemp  = endpoint_0id;
        }
        sampleGrpInfoSoapProxyid.setEndpoint(endpoint_0idTemp);
break;
case 10:
        gotMethod = true;
        org.tempuri.GrpInfoSoap getGrpInfoSoap10mtemp = sampleGrpInfoSoapProxyid.getGrpInfoSoap();
if(getGrpInfoSoap10mtemp == null){
%>
<%=getGrpInfoSoap10mtemp %>
<%
}else{
        if(getGrpInfoSoap10mtemp!= null){
        String tempreturnp11 = getGrpInfoSoap10mtemp.toString();
        %>
        <%=tempreturnp11%>
        <%
        }}
break;
case 13:
        gotMethod = true;
        String sGrpCD_1id=  request.getParameter("sGrpCD18");
            java.lang.String sGrpCD_1idTemp = null;
        if(!sGrpCD_1id.equals("")){
         sGrpCD_1idTemp  = sGrpCD_1id;
        }
        String sGrpPW_2id=  request.getParameter("sGrpPW20");
            java.lang.String sGrpPW_2idTemp = null;
        if(!sGrpPW_2id.equals("")){
         sGrpPW_2idTemp  = sGrpPW_2id;
        }
        String sUserCD_3id=  request.getParameter("sUserCD22");
            java.lang.String sUserCD_3idTemp = null;
        if(!sUserCD_3id.equals("")){
         sUserCD_3idTemp  = sUserCD_3id;
        }
        String sUserPW_4id=  request.getParameter("sUserPW24");
            java.lang.String sUserPW_4idTemp = null;
        if(!sUserPW_4id.equals("")){
         sUserPW_4idTemp  = sUserPW_4id;
        }
        String sIP_5id=  request.getParameter("sIP26");
            java.lang.String sIP_5idTemp = null;
        if(!sIP_5id.equals("")){
         sIP_5idTemp  = sIP_5id;
        }
        String sMachineName_6id=  request.getParameter("sMachineName28");
            java.lang.String sMachineName_6idTemp = null;
        if(!sMachineName_6id.equals("")){
         sMachineName_6idTemp  = sMachineName_6id;
        }
        String sOSVersion_7id=  request.getParameter("sOSVersion30");
            java.lang.String sOSVersion_7idTemp = null;
        if(!sOSVersion_7id.equals("")){
         sOSVersion_7idTemp  = sOSVersion_7id;
        }
        String bSetupVerDownloaderCheck_8id=  request.getParameter("bSetupVerDownloaderCheck32");
        boolean bSetupVerDownloaderCheck_8idTemp  = Boolean.valueOf(bSetupVerDownloaderCheck_8id).booleanValue();
        String sSetupVerDownloader_9id=  request.getParameter("sSetupVerDownloader34");
            java.lang.String sSetupVerDownloader_9idTemp = null;
        if(!sSetupVerDownloader_9id.equals("")){
         sSetupVerDownloader_9idTemp  = sSetupVerDownloader_9id;
        }
        org.tempuri.GrpLogonResponseGrpLogonResult grpLogon13mtemp = sampleGrpInfoSoapProxyid.grpLogon(sGrpCD_1idTemp,sGrpPW_2idTemp,sUserCD_3idTemp,sUserPW_4idTemp,sIP_5idTemp,sMachineName_6idTemp,sOSVersion_7idTemp,bSetupVerDownloaderCheck_8idTemp,sSetupVerDownloader_9idTemp);
if(grpLogon13mtemp == null){
%>
<%=grpLogon13mtemp %>
<%
}else{
%>
<TABLE>
<TR>
<TD COLSPAN="3" ALIGN="LEFT">returnp:</TD>
<TR>
<TD WIDTH="5%"></TD>
<TD COLSPAN="2" ALIGN="LEFT">_any:</TD>
<TD>
<%
if(grpLogon13mtemp != null){
org.apache.axis.message.MessageElement[] type_any16 = grpLogon13mtemp.get_any();
        String temp_any16 = null;
        if(type_any16 != null){
        java.util.List list_any16= java.util.Arrays.asList(type_any16);
        temp_any16 = list_any16.toString();
        }
        %>
        <%=temp_any16%>
        <%
}%>
</TD>
</TABLE>
<%
}
break;
case 36:
        gotMethod = true;
        String nGrpID_10id=  request.getParameter("nGrpID41");
        int nGrpID_10idTemp  = Integer.parseInt(nGrpID_10id);
        String sGrpCD_11id=  request.getParameter("sGrpCD43");
            java.lang.String sGrpCD_11idTemp = null;
        if(!sGrpCD_11id.equals("")){
         sGrpCD_11idTemp  = sGrpCD_11id;
        }
        String sGrpPW_12id=  request.getParameter("sGrpPW45");
            java.lang.String sGrpPW_12idTemp = null;
        if(!sGrpPW_12id.equals("")){
         sGrpPW_12idTemp  = sGrpPW_12id;
        }
        String sGrpDatePW_13id=  request.getParameter("sGrpDatePW47");
            java.lang.String sGrpDatePW_13idTemp = null;
        if(!sGrpDatePW_13id.equals("")){
         sGrpDatePW_13idTemp  = sGrpDatePW_13id;
        }
        org.tempuri.GrpInfo_SResponseGrpInfo_SResult grpInfo_S36mtemp = sampleGrpInfoSoapProxyid.grpInfo_S(nGrpID_10idTemp,sGrpCD_11idTemp,sGrpPW_12idTemp,sGrpDatePW_13idTemp);
if(grpInfo_S36mtemp == null){
%>
<%=grpInfo_S36mtemp %>
<%
}else{
%>
<TABLE>
<TR>
<TD COLSPAN="3" ALIGN="LEFT">returnp:</TD>
<TR>
<TD WIDTH="5%"></TD>
<TD COLSPAN="2" ALIGN="LEFT">_any:</TD>
<TD>
<%
if(grpInfo_S36mtemp != null){
org.apache.axis.message.MessageElement[] type_any39 = grpInfo_S36mtemp.get_any();
        String temp_any39 = null;
        if(type_any39 != null){
        java.util.List list_any39= java.util.Arrays.asList(type_any39);
        temp_any39 = list_any39.toString();
        }
        %>
        <%=temp_any39%>
        <%
}%>
</TD>
</TABLE>
<%
}
break;
case 49:
        gotMethod = true;
        String nGrpID_14id=  request.getParameter("nGrpID54");
        int nGrpID_14idTemp  = Integer.parseInt(nGrpID_14id);
        org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult getMsgVideoConferenceUserInfo49mtemp = sampleGrpInfoSoapProxyid.getMsgVideoConferenceUserInfo(nGrpID_14idTemp);
if(getMsgVideoConferenceUserInfo49mtemp == null){
%>
<%=getMsgVideoConferenceUserInfo49mtemp %>
<%
}else{
%>
<TABLE>
<TR>
<TD COLSPAN="3" ALIGN="LEFT">returnp:</TD>
<TR>
<TD WIDTH="5%"></TD>
<TD COLSPAN="2" ALIGN="LEFT">_any:</TD>
<TD>
<%
if(getMsgVideoConferenceUserInfo49mtemp != null){
org.apache.axis.message.MessageElement[] type_any52 = getMsgVideoConferenceUserInfo49mtemp.get_any();
        String temp_any52 = null;
        if(type_any52 != null){
        java.util.List list_any52= java.util.Arrays.asList(type_any52);
        temp_any52 = list_any52.toString();
        }
        %>
        <%=temp_any52%>
        <%
}%>
</TD>
</TABLE>
<%
}
break;
case 56:
        gotMethod = true;
        String nGrpID_15id=  request.getParameter("nGrpID59");
        int nGrpID_15idTemp  = Integer.parseInt(nGrpID_15id);
        String sGrpCD_16id=  request.getParameter("sGrpCD61");
            java.lang.String sGrpCD_16idTemp = null;
        if(!sGrpCD_16id.equals("")){
         sGrpCD_16idTemp  = sGrpCD_16id;
        }
        String sGrpPW_17id=  request.getParameter("sGrpPW63");
            java.lang.String sGrpPW_17idTemp = null;
        if(!sGrpPW_17id.equals("")){
         sGrpPW_17idTemp  = sGrpPW_17id;
        }
        String sGrpDatePW_18id=  request.getParameter("sGrpDatePW65");
            java.lang.String sGrpDatePW_18idTemp = null;
        if(!sGrpDatePW_18id.equals("")){
         sGrpDatePW_18idTemp  = sGrpDatePW_18id;
        }
        String sDBIP_19id=  request.getParameter("sDBIP67");
            java.lang.String sDBIP_19idTemp = null;
        if(!sDBIP_19id.equals("")){
         sDBIP_19idTemp  = sDBIP_19id;
        }
        String sDBNM_20id=  request.getParameter("sDBNM69");
            java.lang.String sDBNM_20idTemp = null;
        if(!sDBNM_20id.equals("")){
         sDBNM_20idTemp  = sDBNM_20id;
        }
        String sDBManUserID_21id=  request.getParameter("sDBManUserID71");
            java.lang.String sDBManUserID_21idTemp = null;
        if(!sDBManUserID_21id.equals("")){
         sDBManUserID_21idTemp  = sDBManUserID_21id;
        }
        String sDBManUserPW_22id=  request.getParameter("sDBManUserPW73");
            java.lang.String sDBManUserPW_22idTemp = null;
        if(!sDBManUserPW_22id.equals("")){
         sDBManUserPW_22idTemp  = sDBManUserPW_22id;
        }
        String sWWWRoot_23id=  request.getParameter("sWWWRoot75");
            java.lang.String sWWWRoot_23idTemp = null;
        if(!sWWWRoot_23id.equals("")){
         sWWWRoot_23idTemp  = sWWWRoot_23id;
        }
        String sUploadPathAbsolute_24id=  request.getParameter("sUploadPathAbsolute77");
            java.lang.String sUploadPathAbsolute_24idTemp = null;
        if(!sUploadPathAbsolute_24id.equals("")){
         sUploadPathAbsolute_24idTemp  = sUploadPathAbsolute_24id;
        }
        int GRP_CDB56mtemp = sampleGrpInfoSoapProxyid.GRP_CDB(nGrpID_15idTemp,sGrpCD_16idTemp,sGrpPW_17idTemp,sGrpDatePW_18idTemp,sDBIP_19idTemp,sDBNM_20idTemp,sDBManUserID_21idTemp,sDBManUserPW_22idTemp,sWWWRoot_23idTemp,sUploadPathAbsolute_24idTemp);
        String tempResultreturnp57 = org.eclipse.jst.ws.util.JspUtils.markup(String.valueOf(GRP_CDB56mtemp));
        %>
        <%= tempResultreturnp57 %>
        <%
break;
case 79:
        gotMethod = true;
        String nGrpID_25id=  request.getParameter("nGrpID82");
        int nGrpID_25idTemp  = Integer.parseInt(nGrpID_25id);
        String sVerupVer_26id=  request.getParameter("sVerupVer84");
            java.lang.String sVerupVer_26idTemp = null;
        if(!sVerupVer_26id.equals("")){
         sVerupVer_26idTemp  = sVerupVer_26id;
        }
        String nRealUserCNT_27id=  request.getParameter("nRealUserCNT86");
        int nRealUserCNT_27idTemp  = Integer.parseInt(nRealUserCNT_27id);
        int grp_USetup79mtemp = sampleGrpInfoSoapProxyid.grp_USetup(nGrpID_25idTemp,sVerupVer_26idTemp,nRealUserCNT_27idTemp);
        String tempResultreturnp80 = org.eclipse.jst.ws.util.JspUtils.markup(String.valueOf(grp_USetup79mtemp));
        %>
        <%= tempResultreturnp80 %>
        <%
break;
case 88:
        gotMethod = true;
        String nGrpID_28id=  request.getParameter("nGrpID91");
        int nGrpID_28idTemp  = Integer.parseInt(nGrpID_28id);
        String sVerupVer_29id=  request.getParameter("sVerupVer93");
            java.lang.String sVerupVer_29idTemp = null;
        if(!sVerupVer_29id.equals("")){
         sVerupVer_29idTemp  = sVerupVer_29id;
        }
        String nRealUserCNT_30id=  request.getParameter("nRealUserCNT95");
        int nRealUserCNT_30idTemp  = Integer.parseInt(nRealUserCNT_30id);
        int grp_MGWSetup88mtemp = sampleGrpInfoSoapProxyid.grp_MGWSetup(nGrpID_28idTemp,sVerupVer_29idTemp,nRealUserCNT_30idTemp);
        String tempResultreturnp89 = org.eclipse.jst.ws.util.JspUtils.markup(String.valueOf(grp_MGWSetup88mtemp));
        %>
        <%= tempResultreturnp89 %>
        <%
break;
case 97:
        gotMethod = true;
        String nGrpID_31id=  request.getParameter("nGrpID102");
        int nGrpID_31idTemp  = Integer.parseInt(nGrpID_31id);
        String nRealUserCNT_32id=  request.getParameter("nRealUserCNT104");
        int nRealUserCNT_32idTemp  = Integer.parseInt(nRealUserCNT_32id);
        org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult WS_GRP_RealUserUpdate97mtemp = sampleGrpInfoSoapProxyid.WS_GRP_RealUserUpdate(nGrpID_31idTemp,nRealUserCNT_32idTemp);
if(WS_GRP_RealUserUpdate97mtemp == null){
%>
<%=WS_GRP_RealUserUpdate97mtemp %>
<%
}else{
%>
<TABLE>
<TR>
<TD COLSPAN="3" ALIGN="LEFT">returnp:</TD>
<TR>
<TD WIDTH="5%"></TD>
<TD COLSPAN="2" ALIGN="LEFT">_any:</TD>
<TD>
<%
if(WS_GRP_RealUserUpdate97mtemp != null){
org.apache.axis.message.MessageElement[] type_any100 = WS_GRP_RealUserUpdate97mtemp.get_any();
        String temp_any100 = null;
        if(type_any100 != null){
        java.util.List list_any100= java.util.Arrays.asList(type_any100);
        temp_any100 = list_any100.toString();
        }
        %>
        <%=temp_any100%>
        <%
}%>
</TD>
</TABLE>
<%
}
break;
case 106:
        gotMethod = true;
        String nGrpID_33id=  request.getParameter("nGrpID111");
        int nGrpID_33idTemp  = Integer.parseInt(nGrpID_33id);
        String nRealUserCNT_34id=  request.getParameter("nRealUserCNT113");
        int nRealUserCNT_34idTemp  = Integer.parseInt(nRealUserCNT_34id);
        String nRealMailUserCnt_35id=  request.getParameter("nRealMailUserCnt115");
        int nRealMailUserCnt_35idTemp  = Integer.parseInt(nRealMailUserCnt_35id);
        org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result WS_GRP_RealUserUpdate2106mtemp = sampleGrpInfoSoapProxyid.WS_GRP_RealUserUpdate2(nGrpID_33idTemp,nRealUserCNT_34idTemp,nRealMailUserCnt_35idTemp);
if(WS_GRP_RealUserUpdate2106mtemp == null){
%>
<%=WS_GRP_RealUserUpdate2106mtemp %>
<%
}else{
%>
<TABLE>
<TR>
<TD COLSPAN="3" ALIGN="LEFT">returnp:</TD>
<TR>
<TD WIDTH="5%"></TD>
<TD COLSPAN="2" ALIGN="LEFT">_any:</TD>
<TD>
<%
if(WS_GRP_RealUserUpdate2106mtemp != null){
org.apache.axis.message.MessageElement[] type_any109 = WS_GRP_RealUserUpdate2106mtemp.get_any();
        String temp_any109 = null;
        if(type_any109 != null){
        java.util.List list_any109= java.util.Arrays.asList(type_any109);
        temp_any109 = list_any109.toString();
        }
        %>
        <%=temp_any109%>
        <%
}%>
</TD>
</TABLE>
<%
}
break;
case 117:
        gotMethod = true;
        String nGRP_ID_36id=  request.getParameter("nGRP_ID120");
        int nGRP_ID_36idTemp  = Integer.parseInt(nGRP_ID_36id);
        String sGRP_CD_37id=  request.getParameter("sGRP_CD122");
            java.lang.String sGRP_CD_37idTemp = null;
        if(!sGRP_CD_37id.equals("")){
         sGRP_CD_37idTemp  = sGRP_CD_37id;
        }
        String sLOGIN_ID_38id=  request.getParameter("sLOGIN_ID124");
            java.lang.String sLOGIN_ID_38idTemp = null;
        if(!sLOGIN_ID_38id.equals("")){
         sLOGIN_ID_38idTemp  = sLOGIN_ID_38id;
        }
        String sUSER_NM_39id=  request.getParameter("sUSER_NM126");
            java.lang.String sUSER_NM_39idTemp = null;
        if(!sUSER_NM_39id.equals("")){
         sUSER_NM_39idTemp  = sUSER_NM_39id;
        }
        sampleGrpInfoSoapProxyid.WS_HELPDESK_USER_INSERT(nGRP_ID_36idTemp,sGRP_CD_37idTemp,sLOGIN_ID_38idTemp,sUSER_NM_39idTemp);
break;
case 128:
        gotMethod = true;
        String nGrpID_40id=  request.getParameter("nGrpID133");
        int nGrpID_40idTemp  = Integer.parseInt(nGrpID_40id);
        org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult WS_GRP_GetTagFreeLicenseKey128mtemp = sampleGrpInfoSoapProxyid.WS_GRP_GetTagFreeLicenseKey(nGrpID_40idTemp);
if(WS_GRP_GetTagFreeLicenseKey128mtemp == null){
%>
<%=WS_GRP_GetTagFreeLicenseKey128mtemp %>
<%
}else{
%>
<TABLE>
<TR>
<TD COLSPAN="3" ALIGN="LEFT">returnp:</TD>
<TR>
<TD WIDTH="5%"></TD>
<TD COLSPAN="2" ALIGN="LEFT">_any:</TD>
<TD>
<%
if(WS_GRP_GetTagFreeLicenseKey128mtemp != null){
org.apache.axis.message.MessageElement[] type_any131 = WS_GRP_GetTagFreeLicenseKey128mtemp.get_any();
        String temp_any131 = null;
        if(type_any131 != null){
        java.util.List list_any131= java.util.Arrays.asList(type_any131);
        temp_any131 = list_any131.toString();
        }
        %>
        <%=temp_any131%>
        <%
}%>
</TD>
</TABLE>
<%
}
break;
}
} catch (Exception e) { 
%>
Exception: <%= org.eclipse.jst.ws.util.JspUtils.markup(e.toString()) %>
Message: <%= org.eclipse.jst.ws.util.JspUtils.markup(e.getMessage()) %>
<%
return;
}
if(!gotMethod){
%>
result: N/A
<%
}
%>
</BODY>
</HTML>