package neos.cmm.menu.vo;
   
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class MenuTreeNode {
	protected String id  = null;
	protected String upperMenuNo  = null;
	protected String text  = null;
	public String menuGubun = null;
	public String menuClass = null;
	public String urlPath = null;
	public String urlGubun = null;
	public int depth = 0 ;
	public List<MenuTreeNode> children  = null;
	public Map<String,Object> state = null;
	
	
	public Map<String,Object> setState(boolean selected , boolean opened , boolean  disabled) {

		Map<String,Object> state = new HashMap<>();
		
		state.put("selected",selected);
		state.put("opened",opened);
		state.put("disabled",disabled);
		
		return state;
	}
	
	public MenuTreeNode() {
		
	}
	
	public MenuTreeNode(String menuNo, String upperMenuNo, String name, String menuGubun,String menuClass , String urlPath ,String urlGubun, boolean selected, boolean opened, boolean disabled) {
		this.id = menuNo;
		this.upperMenuNo = upperMenuNo;
		this.text = name;
		this.menuGubun = menuGubun;
		this.state = setState(selected,opened,disabled);	
		this.menuClass = menuClass;	
		this.urlPath = urlPath;	
		this.urlGubun = urlGubun;	
		depth = 0;
		children = new ArrayList<MenuTreeNode>();
	}

	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public List<MenuTreeNode> getChildren() {
		return children;
	}

	public void setChildren(List<MenuTreeNode> children) {
		this.children = children;
	}

	public String getMenuGubun() {
		return menuGubun;
	}

	public void setMenuGubun(String menuGubun) {
		this.menuGubun = menuGubun;
	}

	public String getUpperMenuNo() {
		return upperMenuNo;
	}

	public void setUpperMenuNo(String upperMenuNo) {
		this.upperMenuNo = upperMenuNo;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}
	
	public int size() {
		return children.size();
	}

	public void add(MenuTreeNode item) {
		if (id.equals(item.upperMenuNo)) {
			item.depth = depth + 1;
			children.add(item);
			return;
		}

		Iterator<MenuTreeNode> iter = children.iterator();
		while (iter.hasNext()) {
			iter.next().add(item);
		}
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

	public Map<String, Object> getState() {
		return state;
	}

	public void setState(Map<String, Object> state) {
		this.state = state;
	}
	
}
