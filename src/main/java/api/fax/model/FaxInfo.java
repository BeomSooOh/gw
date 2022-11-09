package api.fax.model;

public class FaxInfo {
	/**
	 * Bill36524ID
	 */
	private String Bill36524ID;
	/**
	 * 공백으로 표시
	 */
	private String VendorID;
	/**
	 * 제목
	 */
	private String Subject;
	/**
	 * 발송일자 (YYYYMMDDHHMMSS)
	 * NOW 즉시 발송
	 */
	private String SendTime;
	
	public String getBill36524ID() {
		return Bill36524ID;
	}
	public void setBill36524ID(String bill36524id) {
		Bill36524ID = bill36524id;
	}
	public String getVendorID() {
		return VendorID;
	}
	public void setVendorID(String vendorID) {
		VendorID = vendorID;
	}
	public String getSubject() {
		return Subject;
	}
	public void setSubject(String subject) {
		Subject = subject;
	}
	public String getSendTime() {
		return SendTime;
	}
	public void setSendTime(String sendTime) {
		SendTime = sendTime;
	}
}
