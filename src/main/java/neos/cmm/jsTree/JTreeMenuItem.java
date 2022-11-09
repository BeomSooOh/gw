package neos.cmm.jsTree;

import java.util.HashMap;
import java.util.Map;

public class JTreeMenuItem extends JItemBase{
	private String menuGubun = null;
	private String menuClass = null;
	private String urlPath = null;
	private String urlGubun = null;
	private boolean children = false;
		
	public JTreeMenuItem(String id, String parent, String name, boolean opened, boolean selected, boolean disabled , String menuGubun, String menuClass ,String urlPath , String urlGubun ,boolean children) {
		super.id = id;
		super.parentId = parent;
		super.text = name;
		this.menuGubun = menuGubun;
		this.menuClass = menuClass;
		this.urlPath = urlPath;
		this.urlGubun = urlGubun;
		this.children = children;
		
		Map<String,Object> tempMap = new HashMap<>();
		tempMap.put("opened", opened );
		tempMap.put("selected", selected );
		tempMap.put("disabled", disabled );
		super.setState(tempMap);
		
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

	public boolean isChildren() {
		return children;
	}

	public void setChildren(boolean children) {
		this.children = children;
	}
	
	
	
	
}
