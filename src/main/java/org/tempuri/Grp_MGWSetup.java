/**
 * Grp_MGWSetup.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package org.tempuri;

public class Grp_MGWSetup  implements java.io.Serializable {
    private int nGrpID;

    private java.lang.String sVerupVer;

    private int nRealUserCNT;

    public Grp_MGWSetup() {
    }

    public Grp_MGWSetup(
           int nGrpID,
           java.lang.String sVerupVer,
           int nRealUserCNT) {
           this.nGrpID = nGrpID;
           this.sVerupVer = sVerupVer;
           this.nRealUserCNT = nRealUserCNT;
    }


    /**
     * Gets the nGrpID value for this Grp_MGWSetup.
     * 
     * @return nGrpID
     */
    public int getNGrpID() {
        return nGrpID;
    }


    /**
     * Sets the nGrpID value for this Grp_MGWSetup.
     * 
     * @param nGrpID
     */
    public void setNGrpID(int nGrpID) {
        this.nGrpID = nGrpID;
    }


    /**
     * Gets the sVerupVer value for this Grp_MGWSetup.
     * 
     * @return sVerupVer
     */
    public java.lang.String getSVerupVer() {
        return sVerupVer;
    }


    /**
     * Sets the sVerupVer value for this Grp_MGWSetup.
     * 
     * @param sVerupVer
     */
    public void setSVerupVer(java.lang.String sVerupVer) {
        this.sVerupVer = sVerupVer;
    }


    /**
     * Gets the nRealUserCNT value for this Grp_MGWSetup.
     * 
     * @return nRealUserCNT
     */
    public int getNRealUserCNT() {
        return nRealUserCNT;
    }


    /**
     * Sets the nRealUserCNT value for this Grp_MGWSetup.
     * 
     * @param nRealUserCNT
     */
    public void setNRealUserCNT(int nRealUserCNT) {
        this.nRealUserCNT = nRealUserCNT;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Grp_MGWSetup)) {
        	return false;
        }
        Grp_MGWSetup other = (Grp_MGWSetup) obj;
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
            ((this.sVerupVer==null && other.getSVerupVer()==null) || 
             (this.sVerupVer!=null &&
              this.sVerupVer.equals(other.getSVerupVer()))) &&
            this.nRealUserCNT == other.getNRealUserCNT();
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
        if (getSVerupVer() != null) {
            hashCode += getSVerupVer().hashCode();
        }
        hashCode += getNRealUserCNT();
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Grp_MGWSetup.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://tempuri.org/", ">Grp_MGWSetup"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NGrpID");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "nGrpID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SVerupVer");
        elemField.setXmlName(new javax.xml.namespace.QName("http://tempuri.org/", "sVerupVer"));
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
