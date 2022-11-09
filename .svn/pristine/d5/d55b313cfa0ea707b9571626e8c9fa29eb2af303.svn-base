/**
 * WS_GRP_RealUserUpdateAlphaResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_GRP_RealUserUpdateAlphaResponse  implements java.io.Serializable {
    private org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult WS_GRP_RealUserUpdateAlphaResult;

    public WS_GRP_RealUserUpdateAlphaResponse() {
    }

    public WS_GRP_RealUserUpdateAlphaResponse(
           org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult sWSGRPRealUserUpdateAlphaResult) {
           this.WS_GRP_RealUserUpdateAlphaResult = sWSGRPRealUserUpdateAlphaResult;
    }


    /**
     * Gets the WS_GRP_RealUserUpdateAlphaResult value for this WS_GRP_RealUserUpdateAlphaResponse.
     * 
     * @return WS_GRP_RealUserUpdateAlphaResult
     */
    public org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult getWS_GRP_RealUserUpdateAlphaResult() {
        return WS_GRP_RealUserUpdateAlphaResult;
    }


    /**
     * Sets the WS_GRP_RealUserUpdateAlphaResult value for this WS_GRP_RealUserUpdateAlphaResponse.
     * 
     * @param WS_GRP_RealUserUpdateAlphaResult
     */
    public void setWS_GRP_RealUserUpdateAlphaResult(org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult sWSGRPRealUserUpdateAlphaResult) {
        this.WS_GRP_RealUserUpdateAlphaResult = sWSGRPRealUserUpdateAlphaResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_GRP_RealUserUpdateAlphaResponse)) {
        	return false;
        }
        WS_GRP_RealUserUpdateAlphaResponse other = (WS_GRP_RealUserUpdateAlphaResponse) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this.WS_GRP_RealUserUpdateAlphaResult==null && other.getWS_GRP_RealUserUpdateAlphaResult()==null) || 
             (this.WS_GRP_RealUserUpdateAlphaResult!=null &&
              this.WS_GRP_RealUserUpdateAlphaResult.equals(other.getWS_GRP_RealUserUpdateAlphaResult())));
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
        if (getWS_GRP_RealUserUpdateAlphaResult() != null) {
            hashCode += getWS_GRP_RealUserUpdateAlphaResult().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_GRP_RealUserUpdateAlphaResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdateAlphaResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WS_GRP_RealUserUpdateAlphaResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdateAlphaResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdateAlphaResponse>WS_GRP_RealUserUpdateAlphaResult"));
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
