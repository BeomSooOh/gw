package neos.cmm.menu.web;

import java.util.Iterator;
import java.util.List;

import neos.cmm.menu.vo.MenuChartNode;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class MenuChartTree {
	MenuChartNode root;

	public MenuChartNode getRoot() {
		return root;
	}

	public void setRoot(MenuChartNode root) {
		this.root = root;
	}

	public MenuChartTree() {
		root = new MenuChartNode("0", "0", "ROOT", "g", "");
	}
	

	public void add(MenuChartNode item) {
		root.add(item);
	}

	public void addAll(List<MenuChartNode> list) {
		Iterator<MenuChartNode> iter = list.iterator();
		while (iter.hasNext()) {
			add(iter.next());
		}
	}

	public String toString() {
		return toString(root);
	}

	public String toString(MenuChartNode node) {
		StringBuffer sb = new StringBuffer();
		sb.append(node.toString());

		Iterator<MenuChartNode> iter = node.nodes.iterator();
		while (iter.hasNext()) {
			sb.append(toString(iter.next()));
		}

		return sb.toString();
	}
	
	public JSONArray getJSONArray(MenuChartNode node) {
		JSONArray jsonArray = new JSONArray();
		jsonArray.add(node.getJSONObject());

		Iterator<MenuChartNode> iter = node.nodes.iterator();
		while (iter.hasNext()) {
			jsonArray.add(getJSONArray(iter.next()));
		}

		return jsonArray;
	}
	
	public JSONArray getJSONArray() {
		return getJSONArray(root);
	}
	
	
	public JSONObject getJSONObject() {
		return getJSONObject(root);
	}
	
	public JSONObject getJSONObject(MenuChartNode node) {
		JSONObject json = new JSONObject();
		json.put("categoryName", node.getName());
		
		Iterator<MenuChartNode> iter = node.nodes.iterator();
		if (iter.hasNext()) {
			json.put("subCategories", node.getName());
		}
		return json;
	}
	
}
    
