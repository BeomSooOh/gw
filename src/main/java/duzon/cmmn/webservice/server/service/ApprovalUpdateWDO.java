/**
 * ApprovalUpdateWDO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package duzon.cmmn.webservice.server.service;

@SuppressWarnings("serial")
public class ApprovalUpdateWDO  implements java.io.Serializable {
    private java.lang.String approval_id;

    private java.lang.String doc_stat;

    private java.lang.String reject_msg;

    public ApprovalUpdateWDO() {
    }

    public ApprovalUpdateWDO(
           java.lang.String approvalId,
           java.lang.String docStat,
           java.lang.String rejectMsg) {
           this.approval_id = approvalId;
           this.doc_stat = docStat;
           this.reject_msg = rejectMsg;
    }


    /**
     * Gets the approval_id value for this ApprovalUpdateWDO.
     * 
     * @return approval_id
     */
    public java.lang.String getApproval_id() {
        return approval_id;
    }


    /**
     * Sets the approval_id value for this ApprovalUpdateWDO.
     * 
     * @param approval_id
     */
    public void setApproval_id(java.lang.String approvalId) {
        this.approval_id = approvalId;
    }


    /**
     * Gets the doc_stat value for this ApprovalUpdateWDO.
     * 
     * @return doc_stat
     */
    public java.lang.String getDoc_stat() {
        return doc_stat;
    }


    /**
     * Sets the doc_stat value for this ApprovalUpdateWDO.
     * 
     * @param doc_stat
     */
    public void setDoc_stat(java.lang.String docStat) {
        this.doc_stat = docStat;
    }


    /**
     * Gets the reject_msg value for this ApprovalUpdateWDO.
     * 
     * @return reject_msg
     */
    public java.lang.String getReject_msg() {
        return reject_msg;
    }


    /**
     * Sets the reject_msg value for this ApprovalUpdateWDO.
     * 
     * @param reject_msg
     */
    public void setReject_msg(java.lang.String rejectMsg) {
        this.reject_msg = rejectMsg;
    }

    private java.lang.Object __equalsCalc = null;
    @SuppressWarnings("unused")
	public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ApprovalUpdateWDO)) {
        	return false;
        }
        
        ApprovalUpdateWDO other = (ApprovalUpdateWDO) obj;
        
        if (obj == null) {
        	return false;
        }
        
        if (this == obj) {
        	return true;
        }
        
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean equals;
        equals =  
            ((this.approval_id==null && other.getApproval_id()==null) || 
             (this.approval_id!=null &&
              this.approval_id.equals(other.getApproval_id()))) &&
            ((this.doc_stat==null && other.getDoc_stat()==null) || 
             (this.doc_stat!=null &&
              this.doc_stat.equals(other.getDoc_stat()))) &&
            ((this.reject_msg==null && other.getReject_msg()==null) || 
             (this.reject_msg!=null &&
              this.reject_msg.equals(other.getReject_msg())));
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
        if (getApproval_id() != null) {
            hashCode += getApproval_id().hashCode();
        }
        if (getDoc_stat() != null) {
            hashCode += getDoc_stat().hashCode();
        }
        if (getReject_msg() != null) {
            hashCode += getReject_msg().hashCode();
        }
        __hashCodeCalc = false;
        return hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ApprovalUpdateWDO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://service.server.webservice.cmmn.duzon/", "approvalUpdateWDO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("approval_id");
        elemField.setXmlName(new javax.xml.namespace.QName("", "approval_id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("doc_stat");
        elemField.setXmlName(new javax.xml.namespace.QName("", "doc_stat"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reject_msg");
        elemField.setXmlName(new javax.xml.namespace.QName("", "reject_msg"));
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
           @SuppressWarnings("rawtypes") java.lang.Class javaType,  
           javax.xml.namespace.QName xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
        		  javaType, xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           @SuppressWarnings("rawtypes") java.lang.Class javaType,  
           javax.xml.namespace.QName xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
        		  javaType, xmlType, typeDesc);
    }

}
