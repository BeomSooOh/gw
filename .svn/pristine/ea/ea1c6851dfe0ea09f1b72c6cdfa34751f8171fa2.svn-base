/**
 * WS_GRP_GetTagFreeLicenseKeyResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_GRP_GetTagFreeLicenseKeyResponse  implements java.io.Serializable {
    private org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult WS_GRP_GetTagFreeLicenseKeyResult;

    public WS_GRP_GetTagFreeLicenseKeyResponse() {
    }

    public WS_GRP_GetTagFreeLicenseKeyResponse(
           org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult sWSGRPGetTagFreeLicenseKeyResult) {
           this.WS_GRP_GetTagFreeLicenseKeyResult = sWSGRPGetTagFreeLicenseKeyResult;
    }


    /**
     * Gets the WS_GRP_GetTagFreeLicenseKeyResult value for this WS_GRP_GetTagFreeLicenseKeyResponse.
     * 
     * @return WS_GRP_GetTagFreeLicenseKeyResult
     */
    public org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult getWS_GRP_GetTagFreeLicenseKeyResult() {
        return WS_GRP_GetTagFreeLicenseKeyResult;
    }


    /**
     * Sets the WS_GRP_GetTagFreeLicenseKeyResult value for this WS_GRP_GetTagFreeLicenseKeyResponse.
     * 
     * @param WS_GRP_GetTagFreeLicenseKeyResult
     */
    public void setWS_GRP_GetTagFreeLicenseKeyResult(org.tempuri.WS_GRP_GetTagFreeLicenseKeyResponseWS_GRP_GetTagFreeLicenseKeyResult sWSGRPGetTagFreeLicenseKeyResult) {
        this.WS_GRP_GetTagFreeLicenseKeyResult = sWSGRPGetTagFreeLicenseKeyResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_GRP_GetTagFreeLicenseKeyResponse)) {
        	return false;
        }
        WS_GRP_GetTagFreeLicenseKeyResponse other = (WS_GRP_GetTagFreeLicenseKeyResponse) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this.WS_GRP_GetTagFreeLicenseKeyResult==null && other.getWS_GRP_GetTagFreeLicenseKeyResult()==null) || 
             (this.WS_GRP_GetTagFreeLicenseKeyResult!=null &&
              this.WS_GRP_GetTagFreeLicenseKeyResult.equals(other.getWS_GRP_GetTagFreeLicenseKeyResult())));
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
        if (getWS_GRP_GetTagFreeLicenseKeyResult() != null) {
            hashCode += getWS_GRP_GetTagFreeLicenseKeyResult().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_GRP_GetTagFreeLicenseKeyResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_GetTagFreeLicenseKeyResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WS_GRP_GetTagFreeLicenseKeyResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_GetTagFreeLicenseKeyResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_GetTagFreeLicenseKeyResponse>WS_GRP_GetTagFreeLicenseKeyResult"));
        elemField.setMinOccurs(0);
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
