/**
 * GrpInfoLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class GrpInfoLocator extends org.apache.axis.client.Service implements org.tempuri.GrpInfo {

    public GrpInfoLocator() {
    }


    public GrpInfoLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public GrpInfoLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for GrpInfoSoap
    private java.lang.String GrpInfoSoap_address = "http://license.bizboxa.com/neobizboxws/grpinfo.asmx";

    public java.lang.String getGrpInfoSoapAddress() {
        return GrpInfoSoap_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String GrpInfoSoapWSDDServiceName = "GrpInfoSoap";

    public java.lang.String getGrpInfoSoapWSDDServiceName() {
        return GrpInfoSoapWSDDServiceName;
    }

    public void setGrpInfoSoapWSDDServiceName(java.lang.String name) {
        GrpInfoSoapWSDDServiceName = name;
    }

    public org.tempuri.GrpInfoSoap getGrpInfoSoap() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(GrpInfoSoap_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getGrpInfoSoap(endpoint);
    }

    public org.tempuri.GrpInfoSoap getGrpInfoSoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            org.tempuri.GrpInfoSoapStub stub = new org.tempuri.GrpInfoSoapStub(portAddress, this);
            stub.setPortName(getGrpInfoSoapWSDDServiceName());
            return stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setGrpInfoSoapEndpointAddress(java.lang.String address) {
        GrpInfoSoap_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (org.tempuri.GrpInfoSoap.class.isAssignableFrom(serviceEndpointInterface)) {
                org.tempuri.GrpInfoSoapStub stub = new org.tempuri.GrpInfoSoapStub(new java.net.URL(GrpInfoSoap_address), this);
                stub.setPortName(getGrpInfoSoapWSDDServiceName());
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
        if ("GrpInfoSoap".equals(inputPortName)) {
            return getGrpInfoSoap();
        }
        else  {
            java.rmi.Remote stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) stub).setPortName(portName);
            return stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://tempuri.org/", "GrpInfo");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://tempuri.org/", "GrpInfoSoap"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("GrpInfoSoap".equals(portName)) {
            setGrpInfoSoapEndpointAddress(address);
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
