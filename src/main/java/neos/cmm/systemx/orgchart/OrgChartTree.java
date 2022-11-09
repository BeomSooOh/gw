package neos.cmm.systemx.orgchart;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import cloud.CloudConnetInfo;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


import bizbox.orgchart.service.IOrgService;
import bizbox.orgchart.service.impl.OrgServiceImpl;
import bizbox.orgchart.util.JedisClient;

public class OrgChartTree {
	OrgChartNode root;

	public OrgChartNode getRoot() {
		return root;
	}

	public void setRoot(OrgChartNode root) {
		this.root = root;
	}

	public OrgChartTree() {
		root = new OrgChartNode("0", "0", "ROOT", "g");
	}
	
	public OrgChartTree(String seq, String parentSeq, String name, String gbn) {
		root = new OrgChartNode(seq, "", "", "", seq, parentSeq, name, gbn);
	}

	public void add(OrgChartNode item) {
		root.add(item);
	}

	public void addAll(List<OrgChartNode> list) {
		Iterator<OrgChartNode> iter = list.iterator();
		while (iter.hasNext()) {
			add(iter.next());
		}
		root.setSpriteCssClass("rootfolder"); 
	}

	public String toString() {
		return toString(root);
	}

	public String toString(OrgChartNode node) {
		StringBuffer sb = new StringBuffer();
		sb.append(node.toString());

		Iterator<OrgChartNode> iter = node.nodes.iterator();
		while (iter.hasNext()) {
			sb.append(toString(iter.next()));
		}

		return sb.toString();
	}
	
	public JSONArray getJSONArray(OrgChartNode node) {
		JSONArray jsonArray = new JSONArray();
		jsonArray.add(node.getJSONObject());

		Iterator<OrgChartNode> iter = node.nodes.iterator();
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
	
	public JSONObject getJSONObject(OrgChartNode node) {
		JSONObject json = new JSONObject();
		json.put("categoryName", node.getName());
		
		Iterator<OrgChartNode> iter = node.nodes.iterator();
		if (iter.hasNext()) {
			json.put("subCategories", node.getName());
		}
		return json;
	}
	
	
	
	
	
	
	
	
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args) {
//		JedisClient jedis = CloudConnetInfo.getJedisClient();
//		IOrgService s = new OrgServiceImpl("mariadb", "jdbc:mysql://172.16.110.24:13306/neos?useUnicode=true&characterEncoding=utf-8", "neos", "neos", jedis);
//		
//		List<Map<String,Object>> list = s.SelectCompBizDeptList("1", "kr");
//		
//		List<OrgChartNode> pList = new ArrayList<OrgChartNode>();
//		
//		for(Map map : list) {
//			String seq = null;
//			String name = null;
//			String gbnOrg = String.valueOf(map.get("gbnOrg"));
//			
//			if (gbnOrg.equals("c")) {
//				seq = String.valueOf(map.get("compSeq"));
//				name = String.valueOf(map.get("compName"));
//			} else if (gbnOrg.equals("b")) {
//				seq = String.valueOf(map.get("bizSeq"));
//				name = String.valueOf(map.get("bizName"));
//			} else if (gbnOrg.equals("d")) {
//				seq = String.valueOf(map.get("deptSeq"));
//				name = String.valueOf(map.get("deptName"));
//			}
//			
//			String parentSeq = String.valueOf(map.get("compSeq"));
//			String path = String.valueOf(map.get("path"));
//			String[] pathArr = path.split("\\|");
//			if (pathArr.length == 1) {
//				parentSeq = "0";
//			} else {
//				parentSeq = pathArr[pathArr.length-2];
//			}
//			pList.add(new OrgChartNode(seq, parentSeq, name, "g"));
//			
//		}
//		
//		OrgChartTree menu = new OrgChartTree();
//		menu.addAll(pList);
//
//		//JSONObject json = JSONObject.fromObject(menu.getRoot());
//		
//	}
//	
}
    
