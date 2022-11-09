package duzon.cmmn.webservice.server.service;

import neos.cmm.util.CommonUtil;

public class DZContServiceProxy implements duzon.cmmn.webservice.server.service.DZContService {
  private String _endpoint = null;
  private duzon.cmmn.webservice.server.service.DZContService dZContService = null;
  
  public DZContServiceProxy() {
    _initDZContServiceProxy();
  }
  
  public DZContServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initDZContServiceProxy();
  }
  
  private void _initDZContServiceProxy() {
    try {
      dZContService = (new duzon.cmmn.webservice.server.service.impl.DZContServiceImplServiceLocator()).getDZContServiceImplPort();
      if (dZContService != null) {
        if (_endpoint != null) {
          ((javax.xml.rpc.Stub)dZContService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        }
        else {
          _endpoint = (String)((javax.xml.rpc.Stub)dZContService)._getProperty("javax.xml.rpc.service.endpoint.address");
        }
      }
      
    }
    catch (javax.xml.rpc.ServiceException e) {
    	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    }
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (dZContService != null) {
      ((javax.xml.rpc.Stub)dZContService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    }
    
  }
  
  public duzon.cmmn.webservice.server.service.DZContService getDZContService() {
    if (dZContService == null) {
      _initDZContServiceProxy();
    }
    return dZContService;
  }
  
  public duzon.cmmn.webservice.server.service.ReturnWDO updateApprovalDoc(duzon.cmmn.webservice.server.service.ApprovalUpdateWDO arg0) throws java.rmi.RemoteException{
    if (dZContService == null) {
      _initDZContServiceProxy();
    }
    return dZContService.updateApprovalDoc(arg0);
  }
  
  public java.lang.String callECont() throws java.rmi.RemoteException{
    if (dZContService == null) {
      _initDZContServiceProxy();
    }
    return dZContService.callECont();
  }
  
  public java.lang.String sendContSSO(org.tempuri.UserAuthWDO arg0) throws java.rmi.RemoteException{
    if (dZContService == null) {
      _initDZContServiceProxy();
    }
    return dZContService.sendContSSO(arg0);
  }
  
  
}