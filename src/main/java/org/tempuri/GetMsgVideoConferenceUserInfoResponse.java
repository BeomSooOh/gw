/**
 * GetMsgVideoConferenceUserInfoResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class GetMsgVideoConferenceUserInfoResponse  implements java.io.Serializable {
    private org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult getMsgVideoConferenceUserInfoResult;

    public GetMsgVideoConferenceUserInfoResponse() {
    }

    public GetMsgVideoConferenceUserInfoResponse(
           org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult getMsgVideoConferenceUserInfoResult) {
           this.getMsgVideoConferenceUserInfoResult = getMsgVideoConferenceUserInfoResult;
    }


    /**
     * Gets the getMsgVideoConferenceUserInfoResult value for this GetMsgVideoConferenceUserInfoResponse.
     * 
     * @return getMsgVideoConferenceUserInfoResult
     */
    public org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult getGetMsgVideoConferenceUserInfoResult() {
        return getMsgVideoConferenceUserInfoResult;
    }


    /**
     * Sets the getMsgVideoConferenceUserInfoResult value for this GetMsgVideoConferenceUserInfoResponse.
     * 
     * @param getMsgVideoConferenceUserInfoResult
     */
    public void setGetMsgVideoConferenceUserInfoResult(org.tempuri.GetMsgVideoConferenceUserInfoResponseGetMsgVideoConferenceUserInfoResult getMsgVideoConferenceUserInfoResult) {
        this.getMsgVideoConferenceUserInfoResult = getMsgVideoConferenceUserInfoResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GetMsgVideoConferenceUserInfoResponse)) {
        	return false;
        }
        GetMsgVideoConferenceUserInfoResponse other = (GetMsgVideoConferenceUserInfoResponse) obj;

        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this.getMsgVideoConferenceUserInfoResult==null && other.getGetMsgVideoConferenceUserInfoResult()==null) || 
             (this.getMsgVideoConferenceUserInfoResult!=null &&
              this.getMsgVideoConferenceUserInfoResult.equals(other.getGetMsgVideoConferenceUserInfoResult())));
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
        if (getGetMsgVideoConferenceUserInfoResult() != null) {
            hashCode += getGetMsgVideoConferenceUserInfoResult().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GetMsgVideoConferenceUserInfoResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">GetMsgVideoConferenceUserInfoResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getMsgVideoConferenceUserInfoResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "GetMsgVideoConferenceUserInfoResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">>GetMsgVideoConferenceUserInfoResponse>GetMsgVideoConferenceUserInfoResult"));
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
