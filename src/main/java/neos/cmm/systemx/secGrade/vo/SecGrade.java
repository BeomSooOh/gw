package neos.cmm.systemx.secGrade.vo;

import java.util.Date;

public class SecGrade {
	private String id;
	private String parent;
	private String text;
	private String secNameKr;
	private String secNameEn;
	private String secNameJp;
	private String secNameCn;
	private int secDepth;
	private String compSeq;
	private String module;
	private int secOrder;
	private String etc;
	private String useYn;
	private String iconYn;
	private String createSeq;
	public Date createDate;
	private String modifySeq;
	public Date modifyDate;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getParent() {
		return parent;
	}
	public void setParent(String parent) {
		this.parent = parent;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	
	public String getSecNameKr() {
		return secNameKr;
	}
	public void setSecNameKr(String secNameKr) {
		this.secNameKr = secNameKr;
	}
	public String getSecNameEn() {
		return secNameEn;
	}
	public void setSecNameEn(String secNameEn) {
		this.secNameEn = secNameEn;
	}
	public String getSecNameJp() {
		return secNameJp;
	}
	public void setSecNameJp(String secNameJp) {
		this.secNameJp = secNameJp;
	}
	public String getSecNameCn() {
		return secNameCn;
	}
	public void setSecNameCn(String secNameCn) {
		this.secNameCn = secNameCn;
	}
	public int getSecDepth() {
		return secDepth;
	}
	public void setSecDepth(int secDepth) {
		this.secDepth = secDepth;
	}
	public String getCompSeq() {
		return compSeq;
	}
	public void setCompSeq(String compSeq) {
		this.compSeq = compSeq;
	}
	public String getModule() {
		return module;
	}
	public void setModule(String module) {
		this.module = module;
	}
	public int getSecOrder() {
		return secOrder;
	}
	public void setSecOrder(int secOrder) {
		this.secOrder = secOrder;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getCreateSeq() {
		return createSeq;
	}
	public void setCreateSeq(String createSeq) {
		this.createSeq = createSeq;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public String getModifySeq() {
		return modifySeq;
	}
	public void setModifySeq(String modifySeq) {
		this.modifySeq = modifySeq;
	}
	public Date getModifyDate() {
		return modifyDate;
	}
	public void setModifyDate(Date modifyDate) {
		this.modifyDate = modifyDate;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	public String getIconYn() {
		return iconYn;
	}
	public void setIconYn(String iconYn) {
		this.iconYn = iconYn;
	}
	
}
