/**
 * WS_GRP_RealUserUpdate2.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_GRP_RealUserUpdate2  implements java.io.Serializable {
    private int nGrpID;

    private int nRealUserCNT;

    private int nRealMailUserCnt;

    public WS_GRP_RealUserUpdate2() {
    }

    public WS_GRP_RealUserUpdate2(
           int nGrpID,
           int nRealUserCNT,
           int nRealMailUserCnt) {
           this.nGrpID = nGrpID;
           this.nRealUserCNT = nRealUserCNT;
           this.nRealMailUserCnt = nRealMailUserCnt;
    }


    /**
     * Gets the nGrpID value for this WS_GRP_RealUserUpdate2.
     * 
     * @return nGrpID
     */
    public int getNGrpID() {
        return nGrpID;
    }


    /**
     * Sets the nGrpID value for this WS_GRP_RealUserUpdate2.
     * 
     * @param nGrpID
     */
    public void setNGrpID(int nGrpID) {
        this.nGrpID = nGrpID;
    }


    /**
     * Gets the nRealUserCNT value for this WS_GRP_RealUserUpdate2.
     * 
     * @return nRealUserCNT
     */
    public int getNRealUserCNT() {
        return nRealUserCNT;
    }


    /**
     * Sets the nRealUserCNT value for this WS_GRP_RealUserUpdate2.
     * 
     * @param nRealUserCNT
     */
    public void setNRealUserCNT(int nRealUserCNT) {
        this.nRealUserCNT = nRealUserCNT;
    }


    /**
     * Gets the nRealMailUserCnt value for this WS_GRP_RealUserUpdate2.
     * 
     * @return nRealMailUserCnt
     */
    public int getNRealMailUserCnt() {
        return nRealMailUserCnt;
    }


    /**
     * Sets the nRealMailUserCnt value for this WS_GRP_RealUserUpdate2.
     * 
     * @param nRealMailUserCnt
     */
    public void setNRealMailUserCnt(int nRealMailUserCnt) {
        this.nRealMailUserCnt = nRealMailUserCnt;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_GRP_RealUserUpdate2)) {
        	return false;
        }
        WS_GRP_RealUserUpdate2 other = (WS_GRP_RealUserUpdate2) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            this.nGrpID == other.getNGrpID() &&
            this.nRealUserCNT == other.getNRealUserCNT() &&
            this.nRealMailUserCnt == other.getNRealMailUserCnt();
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
        hashCode += getNRealUserCNT();
        hashCode += getNRealMailUserCnt();
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_GRP_RealUserUpdate2.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdate2"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NGrpID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NRealUserCNT");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "nRealUserCNT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NRealMailUserCnt");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "nRealMailUserCnt"));
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
