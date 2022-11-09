package api.common.model;

import java.util.List;
import java.util.Map;

public class EventRequest {
	private String eventType;
	
	private String eventSubType;
	
	private String groupSeq;
	
	private String compSeq;
	
	private String senderSeq;
	
	private String seq;
	
	private String subSeq;
	
	public List<Map<String, Object>> recvEmpList;
	
	public Map<String, Object> data;
	
	private String url;
	
	private String alertYn;
	
	private String pushYn;
	
	private String talkYn;
	
	private String mailYn;
	
	private String smsYn;
	
	private String portalYn;
	
	private String timelineYn;
	
	private String recvEmpBulk;
	
	public List<String> recvEmpBulkList;
	
	public List<Map<String, Object>> recvMentionEmpList;
	
	private String langCode;
	
	private String ignoreCntYn;

	public String getEventType() {
		return eventType;
	}

	public void setEventType(String type) {
		this.eventType = type;
	}

	public String getEventSubType() {
		return eventSubType;
	}

	public void setEventSubType(String subType) {
		this.eventSubType = subType;
	}

	public String getGroupSeq() {
		return groupSeq;
	}

	public void setGroupSeq(String groupSeq) {
		this.groupSeq = groupSeq;
	}

	public String getCompSeq() {
		return compSeq;
	}

	public void setCompSeq(String compSeq) {
		this.compSeq = compSeq;
	}

	public String getSenderSeq() {
		return senderSeq;
	}

	public void setSenderSeq(String senderSeq) {
		this.senderSeq = senderSeq;
	}

	public List<Map<String, Object>> getRecvEmpList() {
		return recvEmpList;
	}

	public void setRecvEmpList(List<Map<String, Object>> recvEmpList) {
		this.recvEmpList = recvEmpList;
	}
	
	public void addRecvEmpList(Map<String, Object> recvEmp) {
		this.recvEmpList.add(recvEmp);
	}

	public Map<String, Object> getData() {
		return data;
	}

	public void setData(Map<String, Object> data) {
		this.data = data;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getSubSeq() {
		return subSeq;
	}

	public void setSubSeq(String subSeq) {
		this.subSeq = subSeq;
	}

	public String getAlertYn() {
		return alertYn;
	}

	public void setAlertYn(String alertYn) {
		this.alertYn = alertYn;
	}

	public String getPushYn() {
		return pushYn;
	}

	public void setPushYn(String pushYn) {
		this.pushYn = pushYn;
	}

	public String getTalkYn() {
		return talkYn;
	}

	public void setTalkYn(String talkYn) {
		this.talkYn = talkYn;
	}

	public String getMailYn() {
		return mailYn;
	}

	public void setMailYn(String mailYn) {
		this.mailYn = mailYn;
	}

	public String getSmsYn() {
		return smsYn;
	}

	public void setSmsYn(String smsYn) {
		this.smsYn = smsYn;
	}

	public String getPortalYn() {
		return portalYn;
	}

	public void setPortalYn(String portalYn) {
		this.portalYn = portalYn;
	}

	public String getTimelineYn() {
		return timelineYn;
	}

	public void setTimelineYn(String timelineYn) {
		this.timelineYn = timelineYn;
	}

	public String getRecvEmpBulk() {
		return recvEmpBulk;
	}

	public void setRecvEmpBulk(String recvEmpBulk) {
		this.recvEmpBulk = recvEmpBulk;
	}

	public List<Map<String, Object>> getRecvMentionEmpList() {
		return recvMentionEmpList;
	}

	public void setRecvMentionEmpList(List<Map<String, Object>> recvMentionEmpList) {
		this.recvMentionEmpList = recvMentionEmpList;
	}

	public String getLangCode() {
		return langCode;
	}

	public void setLangCode(String langCode) {
		this.langCode = langCode;
	}

	public List<String> getRecvEmpBulkList() {
		return recvEmpBulkList;
	}

	public void setRecvEmpBulkList(List<String> recvEmpBulkList) {
		this.recvEmpBulkList = recvEmpBulkList;
	}

	public String getIgnoreCntYn() {
		return ignoreCntYn;
	}

	public void setIgnoreCntYn(String ignoreCntYn) {
		this.ignoreCntYn = ignoreCntYn;
	}

	@Override
	public String toString() {
		return "EventRequest [eventType=" + eventType + ", eventSubType=" + eventSubType
				+ ", groupSeq=" + groupSeq + ", compSeq=" + compSeq 
				+ ", senderSeq=" + senderSeq + ", recvEmpList=" 
				+ recvEmpList + ", data=" + data + ", url=" + url + "]";
	}
}
