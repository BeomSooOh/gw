/**
 * WS_HELPDESK_USER_INSERT.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class WS_HELPDESK_USER_INSERT  implements java.io.Serializable {
    private int nGRP_ID;

    private java.lang.String sGRP_CD;

    private java.lang.String sLOGIN_ID;

    private java.lang.String sUSER_NM;

    public WS_HELPDESK_USER_INSERT() {
    }

    public WS_HELPDESK_USER_INSERT(
           int nGRPID,
           java.lang.String sGRPCD,
           java.lang.String sLOGINID,
           java.lang.String sUSERNM) {
           this.nGRP_ID = nGRPID;
           this.sGRP_CD = sGRPCD;
           this.sLOGIN_ID = sLOGINID;
           this.sUSER_NM = sUSERNM;
    }


    /**
     * Gets the nGRP_ID value for this WS_HELPDESK_USER_INSERT.
     * 
     * @return nGRP_ID
     */
    public int getNGRP_ID() {
        return nGRP_ID;
    }


    /**
     * Sets the nGRP_ID value for this WS_HELPDESK_USER_INSERT.
     * 
     * @param nGRP_ID
     */
    public void setNGRP_ID(int nGRPID) {
        this.nGRP_ID = nGRPID;
    }


    /**
     * Gets the sGRP_CD value for this WS_HELPDESK_USER_INSERT.
     * 
     * @return sGRP_CD
     */
    public java.lang.String getSGRP_CD() {
        return sGRP_CD;
    }


    /**
     * Sets the sGRP_CD value for this WS_HELPDESK_USER_INSERT.
     * 
     * @param sGRP_CD
     */
    public void setSGRP_CD(java.lang.String sGRPCD) {
        this.sGRP_CD = sGRPCD;
    }


    /**
     * Gets the sLOGIN_ID value for this WS_HELPDESK_USER_INSERT.
     * 
     * @return sLOGIN_ID
     */
    public java.lang.String getSLOGIN_ID() {
        return sLOGIN_ID;
    }


    /**
     * Sets the sLOGIN_ID value for this WS_HELPDESK_USER_INSERT.
     * 
     * @param sLOGIN_ID
     */
    public void setSLOGIN_ID(java.lang.String sLOGINID) {
        this.sLOGIN_ID = sLOGINID;
    }


    /**
     * Gets the sUSER_NM value for this WS_HELPDESK_USER_INSERT.
     * 
     * @return sUSER_NM
     */
    public java.lang.String getSUSER_NM() {
        return sUSER_NM;
    }


    /**
     * Sets the sUSER_NM value for this WS_HELPDESK_USER_INSERT.
     * 
     * @param sUSER_NM
     */
    public void setSUSER_NM(java.lang.String sUSERNM) {
        this.sUSER_NM = sUSERNM;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof WS_HELPDESK_USER_INSERT)) {
        	return false;
        }
        WS_HELPDESK_USER_INSERT other = (WS_HELPDESK_USER_INSERT) obj;
        if (this == obj) {
        	return true;
        }
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals = 
            this.nGRP_ID == other.getNGRP_ID() &&
            ((this.sGRP_CD==null && other.getSGRP_CD()==null) || 
             (this.sGRP_CD!=null &&
              this.sGRP_CD.equals(other.getSGRP_CD()))) &&
            ((this.sLOGIN_ID==null && other.getSLOGIN_ID()==null) || 
             (this.sLOGIN_ID!=null &&
              this.sLOGIN_ID.equals(other.getSLOGIN_ID()))) &&
            ((this.sUSER_NM==null && other.getSUSER_NM()==null) || 
             (this.sUSER_NM!=null &&
              this.sUSER_NM.equals(other.getSUSER_NM())));
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
        hashCode += getNGRP_ID();
        if (getSGRP_CD() != null) {
            hashCode += getSGRP_CD().hashCode();
        }
        if (getSLOGIN_ID() != null) {
            hashCode += getSLOGIN_ID().hashCode();
        }
        if (getSUSER_NM() != null) {
            hashCode += getSUSER_NM().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(WS_HELPDESK_USER_INSERT.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">WS_HELPDESK_USER_INSERT"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NGRP_ID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "nGRP_ID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SGRP_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "sGRP_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SLOGIN_ID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "sLOGIN_ID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SUSER_NM");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "sUSER_NM"));
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
