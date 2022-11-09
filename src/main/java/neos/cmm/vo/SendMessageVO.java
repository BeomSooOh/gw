package neos.cmm.vo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SendMessageVO {
	
	public String[] recvEmpSeq;
	private String content = "";
	private String contentType = "0";
	private String secuYn = "N";
	private String receiptYn = "N";
	private String reserveDate = "";
	private String fileId = "";
	public List<Map<String, Object>> link = new ArrayList<>();
	private String linkMsgId = "";
	private String msgId = "";
	private String encryptionYn = "N";
	
	
	public String[] getRecvEmpSeq() {
		return recvEmpSeq;
	}
	public void setRecvEmpSeq(String[] recvEmpSeq) {
		this.recvEmpSeq = recvEmpSeq;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public String getSecuYn() {
		return secuYn;
	}
	public void setSecuYn(String secuYn) {
		this.secuYn = secuYn;
	}
	public String getReceiptYn() {
		return receiptYn;
	}
	public void setReceiptYn(String receiptYn) {
		this.receiptYn = receiptYn;
	}
	public String getReserveDate() {
		return reserveDate;
	}
	public void setReserveDate(String reserveDate) {
		this.reserveDate = reserveDate;
	}
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public List<Map<String, Object>> getLink() {
		return link;
	}
	public void setLink(List<Map<String, Object>> link) {
		this.link = link;
	}
	public String getLinkMsgId() {
		return linkMsgId;
	}
	public void setLinkMsgId(String linkMsgId) {
		this.linkMsgId = linkMsgId;
	}
	public String getMsgId() {
		return msgId;
	}
	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}
	public String getEncryptionYn() {
		return encryptionYn;
	}
	public void setEncryptionYn(String encryptionYn) {
		this.encryptionYn = encryptionYn;
	}
	
	public Map<String, Object> getData(){
		Map<String, Object> result = new HashMap<>();
		
		result.put("recvEmpSeq", this.recvEmpSeq);
		result.put("content", this.content);
		result.put("contentType", this.contentType);
		result.put("secuYn", this.secuYn);
		result.put("receiptYn", this.receiptYn);
		result.put("reserveDate", this.reserveDate);
		result.put("fileId", this.fileId);
		result.put("link", this.link);
		result.put("linkMsgId", this.linkMsgId);
		result.put("msgId", this.msgId);
		result.put("encryptionYn", this.encryptionYn);
		
		return result;
	}
	
	
}