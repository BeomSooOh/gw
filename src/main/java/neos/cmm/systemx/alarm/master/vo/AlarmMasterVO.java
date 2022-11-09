package neos.cmm.systemx.alarm.master.vo;

public class AlarmMasterVO {
	private String comp_seq;
	private String grp_seq;
	private String alert;
	private String push;
	private String talk;
	private String mail;
	private String sms;
	private String portal_yn;
	private String timeline_yn;
	private String modify_seq;
	private String modify_date;
	
	public String getComp_seq() {
		return comp_seq;
	}
	public void setComp_seq(String compSeq) {
		this.comp_seq = compSeq;
	}
	public String getGrp_seq() {
		return grp_seq;
	}
	public void setGrp_seq(String grpSeq) {
		this.grp_seq = grpSeq;
	}
	public String getAlert() {
		return alert;
	}
	public void setAlert(String alert) {
		this.alert = alert;
	}
	public String getPush() {
		return push;
	}
	public void setPush(String push) {
		this.push = push;
	}
	public String getTalk() {
		return talk;
	}
	public void setTalk(String talk) {
		this.talk = talk;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getSms() {
		return sms;
	}
	public void setSms(String sms) {
		this.sms = sms;
	}
	public String getPortal_yn() {
		return portal_yn;
	}
	public void setPortal_yn(String portalYn) {
		this.portal_yn = portalYn;
	}
	public String getTimeline_yn() {
		return timeline_yn;
	}
	public void setTimeline_yn(String timelineYn) {
		this.timeline_yn = timelineYn;
	}
	public String getModify_seq() {
		return modify_seq;
	}
	public void setModify_seq(String modifySeq) {
		this.modify_seq = modifySeq;
	}
	public String getModify_date() {
		return modify_date;
	}
	public void setModify_date(String modifyDate) {
		this.modify_date = modifyDate;
	}
	
	@Override
	public String toString() {
		return "AlarmMasterVO [comp_seq=" + comp_seq + ", grp_seq=" + grp_seq
				+ ", alert=" + alert + ", push=" + push + ", talk=" + talk
				+ ", mail=" + mail + ", sms=" + sms + ", portal_yn="
				+ portal_yn + ", timeline_yn=" + timeline_yn + ", modify_seq="
				+ modify_seq + ", modify_date=" + modify_date + "]";
	}
}
