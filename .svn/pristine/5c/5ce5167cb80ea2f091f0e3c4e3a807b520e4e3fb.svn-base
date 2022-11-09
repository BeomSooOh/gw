package neos.cmm.systemx.orgchart;
   
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

import net.sf.json.JSONObject;

public class OrgChartNode {
	public String groupSeq;
	public String compSeq;
	public String compName;
	public String bizSeq;
	public String deptSeq;
	public String seq;
	public String parentSeq;
	public String name;
	public String gbn;
	public String checked;
	public String spriteCssClass;
	public String pathName;	

    public int orderNum = 0;

	public boolean expanded = true;
	public int depth;
	public List<OrgChartNode> nodes;
	
	public OrgChartNode() {
		
	}
	
	public OrgChartNode(String seq,  String parentSeq, String name) {
		this.seq = seq;
		this.parentSeq = parentSeq;
		this.name = name;
		depth = 0;
		nodes = new ArrayList<OrgChartNode>();
		this.setSpriteCssClass("file"); 
	}
	
	public OrgChartNode(String seq, String parentSeq, String name, String gbn) {
		this.seq = seq;
		this.parentSeq = parentSeq;
		this.name = name;
		this.gbn = gbn;
		depth = 0;
		nodes = new ArrayList<OrgChartNode>();
	}

	public OrgChartNode(String seq, String parentSeq, String name, String gbn, String checked) {
		this.seq = seq;
		this.parentSeq = parentSeq;
		this.name = name;
		this.gbn = gbn;
		this.checked = checked;
		depth = 0;
		nodes = new ArrayList<OrgChartNode>();
	}	
	

	public OrgChartNode(String groupSeq, String bizSeq, String compSeq, String deptSeq, String seq, String parentSeq, String name, String gbn) {
		this.groupSeq = groupSeq;
		this.compSeq = compSeq;
		this.bizSeq = bizSeq;
		this.deptSeq = deptSeq;
		this.seq = seq;
		this.parentSeq = parentSeq;
		this.name = name;
		this.gbn = gbn;
		depth = 0;
		nodes = new ArrayList<OrgChartNode>();
	}
	
	public String getSpriteCssClass() {
		return spriteCssClass;
	}
	
	public void setSpriteCssClass(String spriteCssClass) {
		this.spriteCssClass = spriteCssClass;
	}
	public String getGbn() {
		return gbn;
	}

	public void setGbn(String gbn) {
		this.gbn = gbn;
	}
	
	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getParentSeq() {
		return parentSeq;
	}

	public void setParentSeq(String parentSeq) {
		this.parentSeq = parentSeq;
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

	public List<OrgChartNode> getNodes() {
		return nodes;
	}

	public void setNodes(List<OrgChartNode> nodes) {
		this.nodes = nodes;
	}

	public int size() {
		return nodes.size();
	}

	public void add(OrgChartNode item) {
		if (nodes.size() > 0) {
			this.setSpriteCssClass("folder");
		} else{
			this.setSpriteCssClass("file"); 
		}
		
		if (seq.equals(item.parentSeq)) {
			item.depth = depth + 1;
			nodes.add(item);
			return;
		}
		

		Iterator<OrgChartNode> iter = nodes.iterator();
		while (iter.hasNext()) {
			iter.next().add(item);
		}
		
		sortOrderNum();
	}
	
	/**
	 * order num 로 오름차순 정렬
	 */
	public void sortOrderNum() {
		Collections.sort(nodes, new Comparator<OrgChartNode>(){
			public int compare(OrgChartNode obj1, OrgChartNode obj2)
			{
				return (obj1.getOrderNum() < obj2.getOrderNum()) ? -1: (obj1.getOrderNum() > obj2.getOrderNum()) ? 1:0 ;
			}
		}); 
	}
	
	public JSONObject getJSONObject() {
		JSONObject json = new JSONObject();
		
		json.put("seq", seq);
		json.put("parentSeq", parentSeq);
		json.put("name", name);
		json.put("depth", depth);
		json.put("checked", checked);
		
		
		return json;
	}

	public String toString() {

		StringBuffer sb = new StringBuffer();

		for (int i = 0, n = depth * 4; i < n; i++) {
			sb.append(" ");
		}
		sb.append("seq:").append(seq).append(", ");
		sb.append("parentSeq:").append(parentSeq).append(", ");
		sb.append("name:").append(name).append(", ");
		sb.append("checked:").append(checked).append(", ");
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

	public String getGroupSeq() {
		return groupSeq;
	}

	public String getCompSeq() {
		return compSeq;
	}

	public String getBizSeq() {
		return bizSeq;
	}

	public void setGroupSeq(String groupSeq) {
		this.groupSeq = groupSeq;
	}

	public void setCompSeq(String compSeq) {
		this.compSeq = compSeq;
	}

	public void setBizSeq(String bizSeq) {
		this.bizSeq = bizSeq;
	}

	public String getDeptSeq() {
		return deptSeq;
	}

	public void setDeptSeq(String deptSeq) {
		this.deptSeq = deptSeq;
	}

	public String getCompName() {
		return compName;
	}

	public void setCompName(String compName) {
		this.compName = compName;
	}

	public int getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(int orderNum) {
		this.orderNum = orderNum;
	}	
	
	public String getPathName() {
        return pathName;
    }

    public void setPathName(String pathName) {
        this.pathName = pathName;
    }
}
   
