/**
 * WS_GRP_RealUserUpdate2Response.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_GRP_RealUserUpdate2Response  implements java.io.Serializable {
    private org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result WS_GRP_RealUserUpdate2Result;

    public WS_GRP_RealUserUpdate2Response() {
    }

    public WS_GRP_RealUserUpdate2Response(
           org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result sWSGRPRealUserUpdate2Result) {
           this.WS_GRP_RealUserUpdate2Result = sWSGRPRealUserUpdate2Result;
    }


    /**
     * Gets the WS_GRP_RealUserUpdate2Result value for this WS_GRP_RealUserUpdate2Response.
     * 
     * @return WS_GRP_RealUserUpdate2Result
     */
    public org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result getWS_GRP_RealUserUpdate2Result() {
        return WS_GRP_RealUserUpdate2Result;
    }


    /**
     * Sets the WS_GRP_RealUserUpdate2Result value for this WS_GRP_RealUserUpdate2Response.
     * 
     * @param WS_GRP_RealUserUpdate2Result
     */
    public void setWS_GRP_RealUserUpdate2Result(org.tempuri.WS_GRP_RealUserUpdate2ResponseWS_GRP_RealUserUpdate2Result sWSGRPRealUserUpdate2Result) {
        this.WS_GRP_RealUserUpdate2Result = sWSGRPRealUserUpdate2Result;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_GRP_RealUserUpdate2Response)) {
        	return false;
        }
        WS_GRP_RealUserUpdate2Response other = (WS_GRP_RealUserUpdate2Response) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this.WS_GRP_RealUserUpdate2Result==null && other.getWS_GRP_RealUserUpdate2Result()==null) || 
             (this.WS_GRP_RealUserUpdate2Result!=null &&
              this.WS_GRP_RealUserUpdate2Result.equals(other.getWS_GRP_RealUserUpdate2Result())));
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
        if (getWS_GRP_RealUserUpdate2Result() != null) {
            hashCode += getWS_GRP_RealUserUpdate2Result().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_GRP_RealUserUpdate2Response.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdate2Response"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WS_GRP_RealUserUpdate2Result");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "WS_GRP_RealUserUpdate2Result"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdate2Response>WS_GRP_RealUserUpdate2Result"));
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
