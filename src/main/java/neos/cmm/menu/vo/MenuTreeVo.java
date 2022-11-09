package neos.cmm.menu.vo;

import java.util.HashMap;
import java.util.Map;


/**
 * 
 * @title jsTree Vo
 * @author UC개발부 개발1팀
 * @since 2016. 6. 16.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2016. 6. 16.  이두승     최초 생성
 *
 */
public class MenuTreeVo {
	
	private String id ; 
	private String text;
	private String menuNo ;
	private String urlPath;
	private String urlGubun;
	private String menuGubun;
	private String menuClass;
	private String exceptGubun;
	private String ssoUseYn;
	private boolean children;
	private int level;
	private String scheduleSeq;
	
	public Map<String,Object> state = new HashMap<>();	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getMenuNo() {
		return menuNo;
	}

	public void setMenuNo(String menuNo) {
		this.menuNo = menuNo;
	}


	public String getUrlPath() {
		return urlPath;
	}

	public void setUrlPath(String urlPath) {
		this.urlPath = urlPath;
	}

	public String getUrlGubun() {
		return urlGubun;
	}

	public void setUrlGubun(String urlGubun) {
		this.urlGubun = urlGubun;
	}

	public String getMenuGubun() {
		return menuGubun;
	}

	public void setMenuGubun(String menuGubun) {
		this.menuGubun = menuGubun;
	}

	public String getMenuClass() {
		return menuClass;
	}

	public void setMenuClass(String menuClass) {
		this.menuClass = menuClass;
	}

	public Map<String, Object> getState() {
		return state;
	}

	public void setState(Map<String, Object> state) {
		this.state = state;
	}

	public boolean isChildren() {
		return children;
	}

	public void setChildren(boolean children) {
		this.children = children;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public String getExceptGubun() {
		return exceptGubun;
	}
	
	public String getSsoUseYn() {
		return ssoUseYn;
	}	
	
	public void setSsoUseYn(String ssoUseYn) {
		this.ssoUseYn = ssoUseYn;
	}	

	public void setExceptGubun(String exceptGubun) {
		this.exceptGubun = exceptGubun;
	}
		
	public String getScheduleSeq() {
		return scheduleSeq;
	}

	public void setScheduleSeq(String scheduleSeq) {
		this.scheduleSeq = scheduleSeq;
	}		
	
}
