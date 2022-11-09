/**
 * GetMsgVideoConferenceUserInfo.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class GetMsgVideoConferenceUserInfo  implements java.io.Serializable {
    private int nGrpID;

    public GetMsgVideoConferenceUserInfo() {
    }

    public GetMsgVideoConferenceUserInfo(
           int nGrpID) {
           this.nGrpID = nGrpID;
    }


    /**
     * Gets the nGrpID value for this GetMsgVideoConferenceUserInfo.
     * 
     * @return nGrpID
     */
    public int getNGrpID() {
        return nGrpID;
    }


    /**
     * Sets the nGrpID value for this GetMsgVideoConferenceUserInfo.
     * 
     * @param nGrpID
     */
    public void setNGrpID(int nGrpID) {
        this.nGrpID = nGrpID;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GetMsgVideoConferenceUserInfo)) {
        	return false;
        }
        GetMsgVideoConferenceUserInfo other = (GetMsgVideoConferenceUserInfo) obj;

        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = this.nGrpID == other.getNGrpID();
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
        hashCode += getNGrpID();
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GetMsgVideoConferenceUserInfo.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">GetMsgVideoConferenceUserInfo"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NGrpID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"));
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
