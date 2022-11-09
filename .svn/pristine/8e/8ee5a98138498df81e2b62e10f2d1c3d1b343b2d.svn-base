/**
 * GrpInfo_SResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

@SuppressWarnings("serial")
public class GrpInfo_SResponse  implements java.io.Serializable {
    private org.tempuri.GrpInfo_SResponseGrpInfo_SResult grpInfo_SResult;

    public GrpInfo_SResponse() {
    }

    public GrpInfo_SResponse(
           org.tempuri.GrpInfo_SResponseGrpInfo_SResult grpInfoSResult) {
           this.grpInfo_SResult = grpInfoSResult;
    }


    /**
     * Gets the grpInfo_SResult value for this GrpInfo_SResponse.
     * 
     * @return grpInfo_SResult
     */
    public org.tempuri.GrpInfo_SResponseGrpInfo_SResult getGrpInfo_SResult() {
        return grpInfo_SResult;
    }


    /**
     * Sets the grpInfo_SResult value for this GrpInfo_SResponse.
     * 
     * @param grpInfo_SResult
     */
    public void setGrpInfo_SResult(org.tempuri.GrpInfo_SResponseGrpInfo_SResult grpInfoSResult) {
        this.grpInfo_SResult = grpInfoSResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GrpInfo_SResponse)) {
        	return false;
        }
        GrpInfo_SResponse other = (GrpInfo_SResponse) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this.grpInfo_SResult==null && other.getGrpInfo_SResult()==null) || 
             (this.grpInfo_SResult!=null &&
              this.grpInfo_SResult.equals(other.getGrpInfo_SResult())));
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
        if (getGrpInfo_SResult() != null) {
            hashCode += getGrpInfo_SResult().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GrpInfo_SResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">GrpInfo_SResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grpInfo_SResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "GrpInfo_SResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">>GrpInfo_SResponse>GrpInfo_SResult"));
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
