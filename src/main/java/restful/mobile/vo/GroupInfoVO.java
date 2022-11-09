package restful.mobile.vo;

import java.io.Serializable;
import java.util.*;

public class GroupInfoVO implements Serializable {
	private String mailUrl	= "";				 //  메일URL
	private String messengerUrl	= "";			 //  메신저URL
	private String mobileUrl	= "";			 //  모바일URL
	private String smsUrl	= "";			 	 //  SMSURL
	private String edmsUrl	= "";			 	 //  EDMS URL
	public Map<String, Object> manualUrl = new HashMap<String, Object>(); //메뉴얼URL
	
	public String getMailUrl() {
		return mailUrl;
	}
	public void setMailUrl(String mailUrl) {
		this.mailUrl = mailUrl;
	}
	public String getMessengerUrl() {
		return messengerUrl;
	}
	public void setMessengerUrl(String messengerUrl) {
		this.messengerUrl = messengerUrl;
	}
	public String getMobileUrl() {
		return mobileUrl;
	}
	public void setMobileUrl(String mobileUrl) {
		this.mobileUrl = mobileUrl;
	}
	public String getSmsUrl() {
		return smsUrl;
	}
	public void setSmsUrl(String smsUrl) {
		this.smsUrl = smsUrl;
	}
	public String getEdmsUrl() {
		return edmsUrl;
	}
	public void setEdmsUrl(String edmsUrl) {
		this.edmsUrl = edmsUrl;
	}
	public Map<String, Object> getManualUrl() {
		return manualUrl;
	}
	public void setManualUrl(Map<String, Object> manualUrl) {
		this.manualUrl = manualUrl;
	}
}
