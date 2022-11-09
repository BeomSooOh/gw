/**
 * DZContServiceImplServiceSoapBindingStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package duzon.cmmn.webservice.server.service.impl;

public class DZContServiceImplServiceSoapBindingStub extends org.apache.axis.client.Stub implements duzon.cmmn.webservice.server.service.DZContService {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
    private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[3];
        _initOperationDesc1();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("UpdateApprovalDoc");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "arg0"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "approvalUpdateWDO"), duzon.cmmn.webservice.server.service.ApprovalUpdateWDO.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "returnWDO"));
        oper.setReturnClass(duzon.cmmn.webservice.server.service.ReturnWDO.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("callECont");
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("sendContSSO");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("", "arg0"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://tempuri.org/", "UserAuthWDO"), org.tempuri.UserAuthWDO.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("", "return"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[2] = oper;

    }

    public DZContServiceImplServiceSoapBindingStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public DZContServiceImplServiceSoapBindingStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
	public DZContServiceImplServiceSoapBindingStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
        if (service == null) {
            super.service = new org.apache.axis.client.Service();
        } else {
            super.service = service;
        }
        ((org.apache.axis.client.Service)super.service).setTypeMappingVersion("1.2");
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            javax.xml.namespace.QName qName2;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            qName = new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "approvalUpdateWDO");
            cachedSerQNames.add(qName);
            cls = duzon.cmmn.webservice.server.service.ApprovalUpdateWDO.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "returnWDO");
            cachedSerQNames.add(qName);
            cls = duzon.cmmn.webservice.server.service.ReturnWDO.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://tempuri.org/", "UserAuthWDO");
            cachedSerQNames.add(qName);
            cls = org.tempuri.UserAuthWDO.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

    }

    protected org.apache.axis.client.Call createCall() throws java.rmi.RemoteException {
        try {
            org.apache.axis.client.Call cCall = super._createCall();
            if (super.maintainSessionSet) {
                cCall.setMaintainSession(super.maintainSession);
            }
            if (super.cachedUsername != null) {
                cCall.setUsername(super.cachedUsername);
            }
            if (super.cachedPassword != null) {
                cCall.setPassword(super.cachedPassword);
            }
            if (super.cachedEndpoint != null) {
                cCall.setTargetEndpointAddress(super.cachedEndpoint);
            }
            if (super.cachedTimeout != null) {
                cCall.setTimeout(super.cachedTimeout);
            }
            if (super.cachedPortName != null) {
                cCall.setPortName(super.cachedPortName);
            }
            java.util.Enumeration keys = super.cachedProperties.keys();
            while (keys.hasMoreElements()) {
                java.lang.String key = (java.lang.String) keys.nextElement();
                cCall.setProperty(key, super.cachedProperties.get(key));
            }
            // All the type mapping information is registered
            // when the first call is made.
            // The type mapping information is actually registered in
            // the TypeMappingRegistry of the service, which
            // is the reason why registration is only needed for the first call.
            synchronized (this) {
                if (firstCall()) {
                    // must set encoding style before registering serializers
                    cCall.setEncodingStyle(null);
                    for (int i = 0; i < cachedSerFactories.size(); ++i) {
                        java.lang.Class cls = (java.lang.Class) cachedSerClasses.get(i);
                        javax.xml.namespace.QName qName =
                                (javax.xml.namespace.QName) cachedSerQNames.get(i);
                        java.lang.Object x = cachedSerFactories.get(i);
                        if (x instanceof Class) {
                            java.lang.Class sf = (java.lang.Class)
                                 cachedSerFactories.get(i);
                            java.lang.Class df = (java.lang.Class)
                                 cachedDeserFactories.get(i);
                            cCall.registerTypeMapping(cls, qName, sf, df, false);
                        }
                        else if (x instanceof javax.xml.rpc.encoding.SerializerFactory) {
                            org.apache.axis.encoding.SerializerFactory sf = (org.apache.axis.encoding.SerializerFactory)
                                 cachedSerFactories.get(i);
                            org.apache.axis.encoding.DeserializerFactory df = (org.apache.axis.encoding.DeserializerFactory)
                                 cachedDeserFactories.get(i);
                            cCall.registerTypeMapping(cls, qName, sf, df, false);
                        }
                    }
                }
            }
            return cCall;
        }
        catch (java.lang.Throwable t) {
            throw new org.apache.axis.AxisFault("Failure trying to get the Call object", t);
        }
    }

    public duzon.cmmn.webservice.server.service.ReturnWDO updateApprovalDoc(duzon.cmmn.webservice.server.service.ApprovalUpdateWDO arg0) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call cCall = createCall();
        cCall.setOperation(_operations[0]);
        cCall.setUseSOAPAction(true);
        cCall.setSOAPActionURI("");
        cCall.setEncodingStyle(null);
        cCall.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        cCall.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        cCall.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        cCall.setOperationName(new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "UpdateApprovalDoc"));

        setRequestHeaders(cCall);
        setAttachments(cCall);
 try {        java.lang.Object resp = cCall.invoke(new java.lang.Object[] {arg0});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(cCall);
            try {
                return (duzon.cmmn.webservice.server.service.ReturnWDO) resp;
            } catch (java.lang.Exception exception) {
                return (duzon.cmmn.webservice.server.service.ReturnWDO) org.apache.axis.utils.JavaUtils.convert(resp, duzon.cmmn.webservice.server.service.ReturnWDO.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public java.lang.String callECont() throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call cCall = createCall();
        cCall.setOperation(_operations[1]);
        cCall.setUseSOAPAction(true);
        cCall.setSOAPActionURI("");
        cCall.setEncodingStyle(null);
        cCall.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        cCall.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        cCall.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        cCall.setOperationName(new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "callECont"));

        setRequestHeaders(cCall);
        setAttachments(cCall);
 try {        java.lang.Object resp = cCall.invoke(new java.lang.Object[] {});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(cCall);
            try {
                return (java.lang.String) resp;
            } catch (java.lang.Exception exception) {
                return (java.lang.String) org.apache.axis.utils.JavaUtils.convert(resp, java.lang.String.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public java.lang.String sendContSSO(org.tempuri.UserAuthWDO arg0) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call cCall = createCall();
        cCall.setOperation(_operations[2]);
        cCall.setUseSOAPAction(true);
        cCall.setSOAPActionURI("");
        cCall.setEncodingStyle(null);
        cCall.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        cCall.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        cCall.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        cCall.setOperationName(new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "sendContSSO"));

        setRequestHeaders(cCall);
        setAttachments(cCall);
 try {        java.lang.Object resp = cCall.invoke(new java.lang.Object[] {arg0});

        if (resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)resp;
        }
        else {
            extractAttachments(cCall);
            try {
                return (java.lang.String) resp;
            } catch (java.lang.Exception exception) {
                return (java.lang.String) org.apache.axis.utils.JavaUtils.convert(resp, java.lang.String.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

}
