package neos.cmm.menu.vo;
   
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONObject;

public class MenuChartNode {
	public String menuNo;
	public String menuGubun;
	public String upperMenuNo;
	public String name;
	public String checked;
	public boolean expanded = true;	
	public int depth;
	public List<MenuChartNode> nodes;
	
	public MenuChartNode() {
		
	}
	
	public MenuChartNode(String menuNo, String upperMenuNo, String name, String menuGubun, String checked) {
		this.menuNo = menuNo;
		this.upperMenuNo = upperMenuNo;
		this.name = name;
		this.menuGubun = menuGubun;
		this.checked = checked;		
		depth = 0;
		nodes = new ArrayList<MenuChartNode>();
	}

	public String getMenuNo() {
		return menuNo;
	}

	public void setMenuNo(String menuNo) {
		this.menuNo = menuNo;
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public List<MenuChartNode> getNodes() {
		return nodes;
	}

	public void setNodes(List<MenuChartNode> nodes) {
		this.nodes = nodes;
	}	
	
	public int size() {
		return nodes.size();
	}
	
	public void add(MenuChartNode item) {
		if (menuNo.equals(item.upperMenuNo)) {
			item.depth = depth + 1;
			nodes.add(item);
			return;
		}

		Iterator<MenuChartNode> iter = nodes.iterator();
		while (iter.hasNext()) {
			iter.next().add(item);
		}
	}
	
	public JSONObject getJSONObject() {
		JSONObject json = new JSONObject();
		
		json.put("menuNo", menuNo);
		json.put("upperMenuNo", upperMenuNo);
		json.put("name", name);
		json.put("depth", depth);		
		return json;
	}

	public String toString() {

		StringBuffer sb = new StringBuffer();

		for (int i = 0, n = depth * 4; i < n; i++) {
			sb.append(" ");
		}
		sb.append("menuNo:").append(menuNo).append(", ");
		sb.append("upperMenuNo:").append(upperMenuNo).append(", ");
		sb.append("name:").append(name).append(", ");
		sb.append("nodes:").append(size()).append("\n");

		return sb.toString();
	}
	
	public boolean isExpanded() {
		return expanded;
	}

	public void setExpanded(boolean expanded) {
		this.expanded = expanded;
	}

	public String getChecked() {
		return checked;
	}

	public void setChecked(String checked) {
		this.checked = checked;
	}	
}
   
