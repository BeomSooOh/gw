package neos.cmm.kendo;

public class KTreeItem extends KItemBase{
	private String name = null;
	private String type = null;
	private String reDate = null;
	private String preserve = null;    // 기록물철 보존기간 추가
	private String urlPath = null;
	private String urlGubun = null;
	
	
	// 양식 form 관련 항목
	private String interlock_url = null;
	private String interlock_width = null;
	private String interlock_height = null;
	private String form_tp = null;
	private String form_d_tp = null;
	private String doc_width = null;
	
	public KTreeItem(String seq, String parentSeq, String name, String urlPath, boolean expanded, String spriteCssClass) {
		super.seq = seq;
		super.parentSeq = parentSeq;
		this.name = name;
		this.urlPath = urlPath;
		super.expanded = expanded;
		super.spriteCssClass = spriteCssClass;
	}
	
	// 기록물철 보존기간 추가 , 트리 노드  type (archive 일때만 선택되도록 )  
	public KTreeItem(String seq, String parentSeq, String name, String type, String reDate, String preserve , boolean expanded, String spriteCssClass, String urlPath) {
		super.seq = seq;
		super.parentSeq = parentSeq;
		this.name = name;
		this.type = type;
		this.reDate = reDate;
		this.setPreserve(preserve);
		super.expanded = expanded;
		super.spriteCssClass = spriteCssClass;
		this.urlPath = urlPath;
		
	}
	
	// 양식 트리 노드  type  
	public KTreeItem(String seq, String parentSeq, String name, boolean expanded, String spriteCssClass, String interlockUrl, String interlockWidth, String interlockHeight, String formTp, String formDTp, String docWidth) {
		super.seq = seq;
		super.parentSeq = parentSeq;
		this.name = name;
		super.expanded = expanded;
		super.spriteCssClass = spriteCssClass;
		this.interlock_url = interlockUrl;
		this.interlock_width = interlockWidth;
		this.interlock_height = interlockHeight;
		this.form_tp = formTp;
		this.form_d_tp = formDTp;
		this.doc_width = docWidth;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	public String getUrlPath() {
		return urlPath;
	} 

	public void setUrlPath(String urlPath) {
		this.urlPath = urlPath;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getReDate() {
		return reDate;
	}

	public void setReDate(String reDate) {
		this.reDate = reDate;
	}

    public String getPreserve() {
        return preserve;
    }

    public void setPreserve(String preserve) {
        this.preserve = preserve;
    }

	public String getUrlGubun() {
		return urlGubun;
	}

	public void setUrlGubun(String urlGubun) {
		this.urlGubun = urlGubun;
	}
	
	public String getInterlock_url() {
		return interlock_url;
	}

	public void setInterlock_url(String interlockUrl) {
		this.interlock_url = interlockUrl;
	}

	public String getInterlock_width() {
		return interlock_width;
	}

	public void setInterlock_width(String interlockWidth) {
		this.interlock_width = interlockWidth;
	}

	public String getInterlock_height() {
		return interlock_height;
	}

	public void setInterlock_height(String interlockHeight) {
		this.interlock_height = interlockHeight;
	}

	public String getForm_tp() {
		return form_tp;
	}

	public void setForm_tp(String formTp) {
		this.form_tp = formTp;
	}

	public String getForm_d_tp() {
		return form_d_tp;
	}

	public void setForm_d_tp(String formDTp) {
		this.form_d_tp = formDTp;
	}

	public String getDoc_width() {
		return doc_width;
	}

	public void setDoc_width(String docWidth) {
		this.doc_width = docWidth;
	}
	
}
