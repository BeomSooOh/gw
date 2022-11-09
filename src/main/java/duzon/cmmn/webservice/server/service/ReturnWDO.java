/**
 * ReturnWDO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package duzon.cmmn.webservice.server.service;

public class ReturnWDO  implements java.io.Serializable {
    private java.lang.String result_code;

    private java.lang.String result_msg;

    private java.lang.String result_url;

    public ReturnWDO() {
    }

    public ReturnWDO(
           java.lang.String resultCode,
           java.lang.String resultMsg,
           java.lang.String resultUrl) {
           this.result_code = resultCode;
           this.result_msg = resultMsg;
           this.result_url = resultUrl;
    }


    /**
     * Gets the result_code value for this ReturnWDO.
     * 
     * @return result_code
     */
    public java.lang.String getResult_code() {
        return result_code;
    }


    /**
     * Sets the result_code value for this ReturnWDO.
     * 
     * @param result_code
     */
    public void setResult_code(java.lang.String resultCode) {
        this.result_code = resultCode;
    }


    /**
     * Gets the result_msg value for this ReturnWDO.
     * 
     * @return result_msg
     */
    public java.lang.String getResult_msg() {
        return result_msg;
    }


    /**
     * Sets the result_msg value for this ReturnWDO.
     * 
     * @param result_msg
     */
    public void setResult_msg(java.lang.String resultMsg) {
        this.result_msg = resultMsg;
    }


    /**
     * Gets the result_url value for this ReturnWDO.
     * 
     * @return result_url
     */
    public java.lang.String getResult_url() {
        return result_url;
    }


    /**
     * Sets the result_url value for this ReturnWDO.
     * 
     * @param result_url
     */
    public void setResult_url(java.lang.String resultUrl) {
        this.result_url = resultUrl;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ReturnWDO)) { return false; }
        ReturnWDO other = (ReturnWDO) obj;
        if (this == obj) { {
        	return true; }
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals =  
            ((this.result_code==null && other.getResult_code()==null) || 
             (this.result_code!=null &&
              this.result_code.equals(other.getResult_code()))) &&
            ((this.result_msg==null && other.getResult_msg()==null) || 
             (this.result_msg!=null &&
              this.result_msg.equals(other.getResult_msg()))) &&
            ((this.result_url==null && other.getResult_url()==null) || 
             (this.result_url!=null &&
              this.result_url.equals(other.getResult_url())));
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
        if (getResult_code() != null) {
            hashCode += getResult_code().hashCode();
        }
        if (getResult_msg() != null) {
            hashCode += getResult_msg().hashCode();
        }
        if (getResult_url() != null) {
            hashCode += getResult_url().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ReturnWDO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "returnWDO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("result_code");
        elemField.setXmlName(new javax.xml.namespace.QName("", "result_code"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("result_msg");
        elemField.setXmlName(new javax.xml.namespace.QName("", "result_msg"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("result_url");
        elemField.setXmlName(new javax.xml.namespace.QName("", "result_url"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
