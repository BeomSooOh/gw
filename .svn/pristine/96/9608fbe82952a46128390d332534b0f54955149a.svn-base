/**
 * WS_GRP_RealUserUpdateAlpha.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_GRP_RealUserUpdateAlpha  implements java.io.Serializable {
    private java.lang.String sGRP_CD;

    private int nRealUserCNT;

    private int nRealMailUserCnt;

    public WS_GRP_RealUserUpdateAlpha() {
    }

    public WS_GRP_RealUserUpdateAlpha(
           java.lang.String sGRPCD,
           int nRealUserCNT,
           int nRealMailUserCnt) {
           this.sGRP_CD = sGRPCD;
           this.nRealUserCNT = nRealUserCNT;
           this.nRealMailUserCnt = nRealMailUserCnt;
    }


    /**
     * Gets the sGRP_CD value for this WS_GRP_RealUserUpdateAlpha.
     * 
     * @return sGRP_CD
     */
    public java.lang.String getSGRP_CD() {
        return sGRP_CD;
    }


    /**
     * Sets the sGRP_CD value for this WS_GRP_RealUserUpdateAlpha.
     * 
     * @param sGRP_CD
     */
    public void setSGRP_CD(java.lang.String sGRPCD) {
        this.sGRP_CD = sGRPCD;
    }


    /**
     * Gets the nRealUserCNT value for this WS_GRP_RealUserUpdateAlpha.
     * 
     * @return nRealUserCNT
     */
    public int getNRealUserCNT() {
        return nRealUserCNT;
    }


    /**
     * Sets the nRealUserCNT value for this WS_GRP_RealUserUpdateAlpha.
     * 
     * @param nRealUserCNT
     */
    public void setNRealUserCNT(int nRealUserCNT) {
        this.nRealUserCNT = nRealUserCNT;
    }


    /**
     * Gets the nRealMailUserCnt value for this WS_GRP_RealUserUpdateAlpha.
     * 
     * @return nRealMailUserCnt
     */
    public int getNRealMailUserCnt() {
        return nRealMailUserCnt;
    }


    /**
     * Sets the nRealMailUserCnt value for this WS_GRP_RealUserUpdateAlpha.
     * 
     * @param nRealMailUserCnt
     */
    public void setNRealMailUserCnt(int nRealMailUserCnt) {
        this.nRealMailUserCnt = nRealMailUserCnt;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_GRP_RealUserUpdateAlpha)) {
        	return false;
        }
        WS_GRP_RealUserUpdateAlpha other = (WS_GRP_RealUserUpdateAlpha) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            ((this.sGRP_CD==null && other.getSGRP_CD()==null) || 
             (this.sGRP_CD!=null &&
              this.sGRP_CD.equals(other.getSGRP_CD()))) &&
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
        if (getSGRP_CD() != null) {
            hashCode += getSGRP_CD().hashCode();
        }
        hashCode += getNRealUserCNT();
        hashCode += getNRealMailUserCnt();
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_GRP_RealUserUpdateAlpha.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">WS_GRP_RealUserUpdateAlpha"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SGRP_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "sGRP_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
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
