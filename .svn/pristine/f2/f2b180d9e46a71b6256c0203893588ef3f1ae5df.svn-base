package org.tempuri;

import neos.cmm.util.CommonUtil;

public class GrpInfoSoapProxy implements org.tempuri.GrpInfoSoap {
  private String _endpoint = null;
  private org.tempuri.GrpInfoSoap grpInfoSoap = null;
  
  public GrpInfoSoapProxy() {
    _initGrpInfoSoapProxy();
  }
  
  public GrpInfoSoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initGrpInfoSoapProxy();
  }
  
  private void _initGrpInfoSoapProxy() {
    try {
      grpInfoSoap = (new org.tempuri.GrpInfoLocator()).getGrpInfoSoap();
      if (grpInfoSoap != null) {
    	  
        if (_endpoint != null) {
          ((javax.xml.rpc.Stub)grpInfoSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        }
        else {
          _endpoint = (String)((javax.xml.rpc.Stub)grpInfoSoap)._getProperty("javax.xml.rpc.service.endpoint.address");
        }
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) { 
    	CommonUtil.printStatckTrace(serviceException);//오류메시지를 통한 정보노출
    }
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (grpInfoSoap != null) {
      ((javax.xml.rpc.Stub)grpInfoSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    }
    
  }
  
  public org.tempuri.GrpInfoSoap getGrpInfoSoap() {
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap;
  }
  
  public org.tempuri.GrpLogonResponseGrpLogonResult grpLogon(java.lang.String sGrpCD, java.lang.String sGrpPW, java.lang.String sUserCD, java.lang.String sUserPW, java.lang.String sIP, java.lang.String sMachineName, java.lang.String sOSVersion, boolean bSetupVerDownloaderCheck, java.lang.String sSetupVerDownloader) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.grpLogon(sGrpCD, sGrpPW, sUserCD, sUserPW, sIP, sMachineName, sOSVersion, bSetupVerDownloaderCheck, sSetupVerDownloader);
  }
  
  public org.tempuri.GrpInfo_SResponseGrpInfo_SResult grpInfo_S(int nGrpID, java.lang.String sGrpCD, java.lang.String sGrpPW, java.lang.String sGrpDatePW) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.grpInfo_S(nGrpID, sGrpCD, sGrpPW, sGrpDatePW);
  }
  
  public org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult getMsgVideoConferenceUserInfo(int nGrpID) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.getMsgVideoConferenceUserInfo(nGrpID);
  }
  
  public int GRP_CDB(int nGrpID, java.lang.String sGrpCD, java.lang.String sGrpPW, java.lang.String sGrpDatePW, java.lang.String sDBIP, java.lang.String sDBNM, java.lang.String sDBManUserID, java.lang.String sDBManUserPW, java.lang.String sWWWRoot, java.lang.String sUploadPathAbsolute) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.GRP_CDB(nGrpID, sGrpCD, sGrpPW, sGrpDatePW, sDBIP, sDBNM, sDBManUserID, sDBManUserPW, sWWWRoot, sUploadPathAbsolute);
  }
  
  public int grp_USetup(int nGrpID, java.lang.String sVerupVer, int nRealUserCNT) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.grp_USetup(nGrpID, sVerupVer, nRealUserCNT);
  }
  
  public int grp_MGWSetup(int nGrpID, java.lang.String sVerupVer, int nRealUserCNT) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.grp_MGWSetup(nGrpID, sVerupVer, nRealUserCNT);
  }
  
  public org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult WS_GRP_RealUserUpdate(int nGrpID, int nRealUserCNT) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.WS_GRP_RealUserUpdate(nGrpID, nRealUserCNT);
  }
  
  public org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result WS_GRP_RealUserUpdate2(int nGrpID, int nRealUserCNT, int nRealMailUserCnt) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.WS_GRP_RealUserUpdate2(nGrpID, nRealUserCNT, nRealMailUserCnt);
  }
  
  public org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult WS_GRP_RealUserUpdateAlpha(java.lang.String sGRPCD, int nRealUserCNT, int nRealMailUserCnt) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.WS_GRP_RealUserUpdateAlpha(sGRPCD, nRealUserCNT, nRealMailUserCnt);
  }
  
  public void WS_HELPDESK_USER_INSERT(int nGRPID, java.lang.String sGRPCD, java.lang.String sLOGINID, java.lang.String sUSERNM) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    grpInfoSoap.WS_HELPDESK_USER_INSERT(nGRPID, sGRPCD, sLOGINID, sUSERNM);
  }
  
  public org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult WS_GRP_GetTagFreeLicenseKey(int nGrpID) throws java.rmi.RemoteException{
    if (grpInfoSoap == null) {
      _initGrpInfoSoapProxy();
    }
    return grpInfoSoap.WS_GRP_GetTagFreeLicenseKey(nGrpID);
  }
  
  
}