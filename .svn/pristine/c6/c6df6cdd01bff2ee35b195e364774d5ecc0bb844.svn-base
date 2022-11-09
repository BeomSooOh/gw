/**
 * GRP_CDBResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

@SuppressWarnings("serial")
public class GRP_CDBResponse  implements java.io.Serializable {
    private int GRP_CDBResult;

    public GRP_CDBResponse() {
    }

    public GRP_CDBResponse(int grpCdbResult) {
           this.GRP_CDBResult = grpCdbResult;
    }


    /**
     * Gets the GRP_CDBResult value for this GRP_CDBResponse.
     * 
     * @return GRP_CDBResult
     */
    public int getGRP_CDBResult() {
        return GRP_CDBResult;
    }


    /**
     * Sets the GRP_CDBResult value for this GRP_CDBResponse.
     * 
     * @param GRP_CDBResult
     */
    public void setGRP_CDBResult(int grpCdbResult) {
        this.GRP_CDBResult = grpCdbResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GRP_CDBResponse)) {
        	return false;
        }
        GRP_CDBResponse other = (GRP_CDBResponse) obj;

        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = this.GRP_CDBResult == other.getGRP_CDBResult();
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
        hashCode += getGRP_CDBResult();
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GRP_CDBResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">GRP_CDBResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("GRP_CDBResult");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "GRP_CDBResult"));
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
