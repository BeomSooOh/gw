/**
 * DZContServiceImplServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package duzon.cmmn.webservice.server.service.impl;

public class DZContServiceImplServiceLocator extends org.apache.axis.client.Service implements duzon.cmmn.webservice.server.service.impl.DZContServiceImplService {

    public DZContServiceImplServiceLocator() {
    }


    public DZContServiceImplServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public DZContServiceImplServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for DZContServiceImplPort
    private java.lang.String DZContServiceImplPort_address = "https://econtract.bill36524.com:9443/service/DZContService";
    //private java.lang.String DZContServiceImplPort_address = "http://172.16.112.17:8091/service/DZContService";

    public java.lang.String getDZContServiceImplPortAddress() {
        return DZContServiceImplPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String DZContServiceImplPortWSDDServiceName = "DZContServiceImplPort";

    public java.lang.String getDZContServiceImplPortWSDDServiceName() {
        return DZContServiceImplPortWSDDServiceName;
    }

    public void setDZContServiceImplPortWSDDServiceName(java.lang.String name) {
        DZContServiceImplPortWSDDServiceName = name;
    }

    public duzon.cmmn.webservice.server.service.DZContService getDZContServiceImplPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(DZContServiceImplPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getDZContServiceImplPort(endpoint);
    }

    public duzon.cmmn.webservice.server.service.DZContService getDZContServiceImplPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            duzon.cmmn.webservice.server.service.impl.DZContServiceImplServiceSoapBindingStub stub = new duzon.cmmn.webservice.server.service.impl.DZContServiceImplServiceSoapBindingStub(portAddress, this);
            stub.setPortName(getDZContServiceImplPortWSDDServiceName());
            return stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setDZContServiceImplPortEndpointAddress(java.lang.String address) {
        DZContServiceImplPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (duzon.cmmn.webservice.server.service.DZContService.class.isAssignableFrom(serviceEndpointInterface)) {
                duzon.cmmn.webservice.server.service.impl.DZContServiceImplServiceSoapBindingStub stub = new duzon.cmmn.webservice.server.service.impl.DZContServiceImplServiceSoapBindingStub(new java.net.URL(DZContServiceImplPort_address), this);
                stub.setPortName(getDZContServiceImplPortWSDDServiceName());
                return stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("DZContServiceImplPort".equals(inputPortName)) {
            return getDZContServiceImplPort();
        }
        else  {
            java.rmi.Remote stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) stub).setPortName(portName);
            return stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://impl.service.server.webservice.cmmn.duzon/", "DZContServiceImplService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://impl.service.server.webservice.cmmn.duzon/", "DZContServiceImplPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("DZContServiceImplPort".equals(portName)) {
            setDZContServiceImplPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
