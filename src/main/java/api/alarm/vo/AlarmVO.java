package api.alarm.vo;

public class AlarmVO {
	private String compSeq;
	private String groupSeq;
	private String tId;
	private String pId;
	private String alertType;
	private String alertYN;
	private String pushYN;
	private String talkYN;
	private String mailYN;
	private String smsYN;
	private String portalYN;
	private String timelineYN;
	private String modifySeq;
	
	public String gettId() {
		return tId;
	}
	public void settId(String tId) {
		this.tId = tId;
	}
	public String getpId() {
		return pId;
	}
	public void setpId(String pId) {
		this.pId = pId;
	}
	public String getCompSeq() {
		return compSeq;
	}
	public void setCompSeq(String compSeq) {
		this.compSeq = compSeq;
	}
	public String getGroupSeq() {
		return groupSeq;
	}
	public void setGroupSeq(String groupSeq) {
		this.groupSeq = groupSeq;
	}
	public String getAlertType() {
		return alertType;
	}
	public void setAlertType(String alertType) {
		this.alertType = alertType;
	}
	public String getAlertYN() {
		return alertYN;
	}
	public void setAlertYN(String alertYN) {
		this.alertYN = alertYN;
	}
	public String getPushYN() {
		return pushYN;
	}
	public void setPushYN(String pushYN) {
		this.pushYN = pushYN;
	}
	public String getTalkYN() {
		return talkYN;
	}
	public void setTalkYN(String talkYN) {
		this.talkYN = talkYN;
	}
	public String getMailYN() {
		return mailYN;
	}
	public void setMailYN(String mailYN) {
		this.mailYN = mailYN;
	}
	public String getSmsYN() {
		return smsYN;
	}
	public void setSmsYN(String smsYN) {
		this.smsYN = smsYN;
	}
	public String getPortalYN() {
		return portalYN;
	}
	public void setPortalYN(String portalYN) {
		this.portalYN = portalYN;
	}
	public String getTimelineYN() {
		return timelineYN;
	}
	public void setTimelineYN(String timelineYN) {
		this.timelineYN = timelineYN;
	}
	public String getModifySeq() {
		return modifySeq;
	}
	public void setModifySeq(String modifySeq) {
		this.modifySeq = modifySeq;
	}
	@Override
	public String toString() {
		return "AlarmVO [compSeq=" + compSeq + ", groupSeq=" + groupSeq
				+ ", alertType=" + alertType + ", alertYN=" + alertYN
				+ ", pushYN=" + pushYN + ", talkYN=" + talkYN + ", mailYN="
				+ mailYN + ", smsYN=" + smsYN + ", portalYN=" + portalYN
				+ ", timelineYN=" + timelineYN + ", modifySeq=" + modifySeq
				+ "]";
	}
	
	
}
