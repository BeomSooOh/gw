/**
 * Grp_MGWSetupResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

@SuppressWarnings("serial")
public class Grp_MGWSetupResponse  implements java.io.Serializable {
    private int grp_MGWSetupResult;

    public Grp_MGWSetupResponse() {
    }

    public Grp_MGWSetupResponse(int grpMGWSetupResult) {
           this.grp_MGWSetupResult = grpMGWSetupResult;
    }


    /**
     * Gets the grp_MGWSetupResult value for this Grp_MGWSetupResponse.
     * 
     * @return grp_MGWSetupResult
     */
    public int getGrp_MGWSetupResult() {
        return grp_MGWSetupResult;
    }


    /**
     * Sets the grp_MGWSetupResult value for this Grp_MGWSetupResponse.
     * 
     * @param grp_MGWSetupResult
     */
    public void setGrp_MGWSetupResult(int grpMGWSetupResult) {
        this.grp_MGWSetupResult = grpMGWSetupResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Grp_MGWSetupResponse)) {
        	return false;
        }
        Grp_MGWSetupResponse other = (Grp_MGWSetupResponse) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            this.grp_MGWSetupResult == other.getGrp_MGWSetupResult();
        __equalsCalc = null;
        return equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int hashCode = 1;
        hashCode += getGrp_MGWSetupResult();
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Grp_MGWSetupResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">Grp_MGWSetupResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grp_MGWSetupResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "Grp_MGWSetupResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.Class javaType,  
           javax.xml.namespace.QName xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            javaType, xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.Class javaType,  
           javax.xml.namespace.QName xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            javaType, xmlType, typeDesc);
    }

}
