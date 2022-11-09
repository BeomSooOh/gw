package neos.cmm.ex.visitor.vo;

import java.util.Map;

public class EaDocInterlockVO {
	private String formId;
	private String processId;
	private String approKey;
	private String docId;
	private String docTitle;
	private String docContent;
	private String interlockUrl;
	private String interlockName;
	private String interlockNameEn;
	private String interlockNameJp;
	private String interlockNameCn;
	private String tId;
	private String origin;
	private String eaType;
	private String personMinusAnnvCnt;
	private String langCode;
	private String attItemCode;
	public Map<String, Object> extraOption; /* 시간외근무 옵션 */
	
	public String getFormId() {
		return formId;
	}
	
	public void setFormId(String formId) {
		this.formId = formId;
	}
	
	public String getProcessId() {
		return processId;
	}
	
	public void setProcessId(String processId) {
		this.processId = processId;
	}
	
	public String getApproKey() {
		return approKey;
	}
	
	public void setApproKey(String approKey) {
		this.approKey = approKey;
	}
	
	public String getDocId() {
		return docId;
	}
	
	public void setDocId(String docId) {
		this.docId = docId;
	}
	
	public String getDocTitle() {
		return docTitle;
	}
	
	public void setDocTitle(String docTitle) {
		this.docTitle = docTitle;
	}
	
	public String getDocContent() {
		return docContent;
	}
	
	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}
	
	public String getInterlockUrl() {
		return interlockUrl;
	}
	
	public void setInterlockUrl(String interlockUrl) {
		this.interlockUrl = interlockUrl;
	}
	
	public String getInterlockName() {
		return interlockName;
	}
	
	public void setInterlockName(String interlockName) {
		this.interlockName = interlockName;
	}
	
	public String getInterlockNameEn() {
		return interlockNameEn;
	}
	
	public void setInterlockNameEn(String interlockNameEn) {
		this.interlockNameEn = interlockNameEn;
	}
	
	public String getInterlockNameJp() {
		return interlockNameJp;
	}
	
	public void setInterlockNameJp(String interlockNameJp) {
		this.interlockNameJp = interlockNameJp;
	}
	
	public String getInterlockNameCn() {
		return interlockNameCn;
	}
	
	public void setInterlockNameCn(String interlockNameCn) {
		this.interlockNameCn = interlockNameCn;
	}
	
	public String gettId() {
		return tId;
	}
	
	public void settId(String tId) {
		this.tId = tId;
	}
	
	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getEaType() {
		return eaType;
	}

	public void setEaType(String eaType) {
		this.eaType = eaType;
	}

	public String getPersonMinusAnnvCnt() {
		return personMinusAnnvCnt;
	}

	public void setPersonMinusAnnvCnt(String personMinusAnnvCnt) {
		this.personMinusAnnvCnt = personMinusAnnvCnt;
	}	
	
	public String getLangCode() {
		return langCode;
	}

	public void setLangCode(String langCode) {
		this.langCode = langCode;
	}
	
	public String getAttItemCode() {
		return attItemCode;
	}

	public void setAttItemCode(String attItemCode) {
		this.attItemCode = attItemCode;
	}		
	
	public Map<String, Object> getExtraOption() {
		return extraOption;
	}

	public void setExtraOption(Map<String, Object> extraOption) {
		this.extraOption = extraOption;
	}	
	
}
