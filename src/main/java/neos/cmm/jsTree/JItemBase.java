package neos.cmm.jsTree;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class JItemBase {
	protected String id = null;
	protected String text = null;
	protected int depth = 0;
	protected String parentId = null;
	

	protected Map<String,Object> state = new HashMap<>();
	protected List<JItemBase> children = new ArrayList<JItemBase>();


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

    
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public List<JItemBase> getChildren() {
		return children;
	}

	public void setChildren(List<JItemBase> children) {
		this.children = children;
	}

	public int getDepth() {
		return depth;
	}

	public void add(JItemBase item) {
		if (id.equals(((JItemBase)item).parentId)) {
			item.depth = depth + 1;
			children.add(item);
			return;
		}

		Iterator<JItemBase> iter = children.iterator();
		while (iter.hasNext()) {
			iter.next().add(item);
		}
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public Map<String, Object> getState() {
		return state;
	}

	public void setState(Map<String, Object> state) {
		this.state = state;
	}

	
	
}
