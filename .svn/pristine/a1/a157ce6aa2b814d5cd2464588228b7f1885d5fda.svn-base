/**
 * WS_GRP_RealUserUpdateResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_GRP_RealUserUpdateResponse  implements java.io.Serializable {
    private org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult WS_GRP_RealUserUpdateResult;

    public WS_GRP_RealUserUpdateResponse() {
    }

    public WS_GRP_RealUserUpdateResponse(
           org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult sWSGRPRealUserUpdateResult) {
           this.WS_GRP_RealUserUpdateResult = sWSGRPRealUserUpdateResult;
    }


    /**
     * Gets the WS_GRP_RealUserUpdateResult value for this WS_GRP_RealUserUpdateResponse.
     * 
     * @return WS_GRP_RealUserUpdateResult
     */
    public org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult getWS_GRP_RealUserUpdateResult() {
        return WS_GRP_RealUserUpdateResult;
    }


    /**
     * Sets the WS_GRP_RealUserUpdateResult value for this WS_GRP_RealUserUpdateResponse.
     * 
     * @param WS_GRP_RealUserUpdateResult
     */
    public void setWS_GRP_RealUserUpdateResult(org.tempuri.WS_GRP_RealUserUpdateResponseWS_GRP_RealUserUpdateResult sWSGRPRealUserUpdateResult) {
        this.WS_GRP_RealUserUpdateResult = sWSGRPRealUserUpdateResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_GRP_RealUserUpdateResponse)) {
        	return false;
        }
        WS_GRP_RealUserUpdateResponse other = (WS_GRP_RealUserUpdateResponse) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this.WS_GRP_RealUserUpdateResult==null && other.getWS_GRP_RealUserUpdateResult()==null) || 
             (this.WS_GRP_RealUserUpdateResult!=null &&
              this.WS_GRP_RealUserUpdateResult.equals(other.getWS_GRP_RealUserUpdateResult())));
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
        if (getWS_GRP_RealUserUpdateResult() != null) {
            hashCode += getWS_GRP_RealUserUpdateResult().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_GRP_RealUserUpdateResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdateResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WS_GRP_RealUserUpdateResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdateResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdateResponse>WS_GRP_RealUserUpdateResult"));
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
