/**
 * WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult  implements java.io.Serializable, org.apache.axis.encoding.AnyContentType {
    public org.apache.axis.message.MessageElement [] _any;

    public WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult() {
    }

    public WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult(
           org.apache.axis.message.MessageElement [] any) {
           this._any = any;
    }


    /**
     * Gets the _any value for this WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult.
     * 
     * @return _any
     */
    public org.apache.axis.message.MessageElement [] get_any() {
        return _any;
    }


    /**
     * Sets the _any value for this WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult.
     * 
     * @param _any
     */
    public void set_any(org.apache.axis.message.MessageElement [] any) {
        this._any = any;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult)) {
        	return false;
        }
        WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult other = (WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this._any==null && other.get_any()==null) || 
             (this._any!=null &&
              java.util.Arrays.equals(this._any, other.get_any())));
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
        if (get_any() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(get_any());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(get_any(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">>WS_GRP_RealUserUpdateAlphaResponse>WS_GRP_RealUserUpdateAlphaResult"));
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
