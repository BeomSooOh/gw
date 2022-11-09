/**
 * Grp_USetupResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

@SuppressWarnings("serial")
public class Grp_USetupResponse  implements java.io.Serializable {
    private int grp_USetupResult;

    public Grp_USetupResponse() {
    }

    public Grp_USetupResponse(int grpUSetupResult) {
           this.grp_USetupResult = grpUSetupResult;
    }


    /**
     * Gets the grp_USetupResult value for this Grp_USetupResponse.
     * 
     * @return grp_USetupResult
     */
    public int getGrp_USetupResult() {
        return grp_USetupResult;
    }


    /**
     * Sets the grp_USetupResult value for this Grp_USetupResponse.
     * 
     * @param grp_USetupResult
     */
    public void setGrp_USetupResult(int grpUSetupResult) {
        this.grp_USetupResult = grpUSetupResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Grp_USetupResponse)) {
        	return false;
        }
        Grp_USetupResponse other = (Grp_USetupResponse) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals =  
            this.grp_USetupResult == other.getGrp_USetupResult();
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
        hashCode += getGrp_USetupResult();
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Grp_USetupResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">Grp_USetupResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grp_USetupResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "Grp_USetupResult"));
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
