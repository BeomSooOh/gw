package neos.cmm.util.jstree;

import java.io.Serializable;

import javax.annotation.Resource;

import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 
 * @title jsTree 내에 attr 부분
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 5. 3.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 3.  박기환        최초 생성
 *
 */
public class Attr implements Serializable {
	@Resource(name="propertyService")
	protected EgovPropertyService propertyService ;
	
	private static final long serialVersionUID = 1L;
	
	private String id = "";
	
	private String rel = "";
	
	private String mdata = "";
	
	private String href = "";
	
	private String nm = "";
	
	private String co_id = "";
	
	private String co_nm = ""; 
	
	private int lowRankCount = 0;
	
	private int ord = 0;
	
	private String contentType = "";
	
	private String icon = "";
	
	private String title = "";
	private String originname = "";
	
	private String crudmYn = "0";
	
	private String mbtlnum = "";

	public String getOriginname() {
		return originname;
	}

	public void setOriginname(String originname) {
		this.originname = originname;
	}

	public Attr(TreeDaoVO treeVO) {		
		this.setTree(treeVO);			
	}

	public Attr(){
		
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getRel() {
		return rel;
	}

	public void setRel(String rel) {
		this.rel = rel;
	}

	public String getMdata() {
		return mdata;
	}

	public void setMdata(String mdata) {
		this.mdata = mdata;
	}

	public String getHref() {
		return href;
	}

	public void setHref(String href) {
		this.href = href;
	}

	public String getNm() {
		return nm;
	}

	public void setNm(String nm) {
		this.nm = nm;
	}

	public String getCo_id() {
		return co_id;
	}

	public void setCo_id(String coId) {
		this.co_id = coId;
	}

	public String getCo_nm() {
		return co_nm;
	}

	public void setCo_nm(String coNm) {
		this.co_nm = coNm;
	}
			
	public int getLowRankCount() {
		return lowRankCount;
	}

	public void setLowRankCount(int lowRankCount) {
		this.lowRankCount = lowRankCount;
	}

	public int getOrd() {
		return ord;
	}

	public void setOrd(int ord) {
		this.ord = ord;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	
	public String getIcon() {
		return icon;
	}
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setIcon(String icon) {			
		this.icon = icon;
	}

	public void setTree(TreeDaoVO tree){
		this.setId(tree.getContentId());
		this.setCo_id(tree.getUpperContentId());
		this.setNm(tree.getContentNm());
		this.setCo_nm(tree.getContentNm());
		this.setHref(tree.getUrl());
		this.setRel(tree.getRel());
		this.setLowRankCount(tree.getLowRankCount());
		this.setOrd(tree.getOrd());
		this.setMdata(tree.getMdata());		
		this.setContentType(tree.getContentType());
		this.setTitle(tree.getContentNm());
		this.setOriginname(tree.getOriginname());
		if(tree.getIcon().length()>0){
			this.setIcon(tree.getIcon());
		}
		this.setCrudmYn(tree.getCrudmYn());
		this.setMbtlnum(tree.getMbtlnum());
	}

	public String getCrudmYn() {
		return crudmYn;
	}

	public void setCrudmYn(String crudmYn) {
		this.crudmYn = crudmYn;
	}

    public String getMbtlnum() {
        return mbtlnum;
    }

    public void setMbtlnum(String mbtlnum) {
        this.mbtlnum = mbtlnum;
    }	
	
}
