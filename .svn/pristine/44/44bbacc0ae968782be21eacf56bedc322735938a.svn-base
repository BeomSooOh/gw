package neos.cmm.kendo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class KItemBase {
	protected String seq = null;
	protected int depth = 0;
	protected String parentSeq = null;
	public boolean expanded = true;
	public String spriteCssClass =null;
	public boolean checked = false;
	
	protected List<KItemBase> items = new ArrayList<KItemBase>();
	
	public boolean isChecked() {
		return checked;
	}

	public void setChecked(boolean checked) {
		this.checked = checked;
	}

	public boolean isExpanded() {
		return expanded;
	}

	public void setExpanded(boolean expanded) {
		this.expanded = expanded;
	}
    

	public void add(KItemBase item) {
		if (seq.equals(((KItemBase)item).parentSeq)) {
			item.depth = depth + 1;
			items.add(item);
			return;
		}

		Iterator<KItemBase> iter = items.iterator();
		while (iter.hasNext()) {
			iter.next().add(item);
		}
	}

	public String getSeq() {
		return seq;
	}

	public int getDepth() {
		return depth;
	}

	public String getParentSeq() {
		return parentSeq;
	}

	public List<KItemBase> getItems() {
		return items;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public void setParentSeq(String parentSeq) {
		this.parentSeq = parentSeq;
	}
	
	public void setItems(List<KItemBase> items) {
		this.items = items;
	}

    public String getSpriteCssClass() {
        return spriteCssClass;
    }

    public void setSpriteCssClass(String spriteCssClass) {
        this.spriteCssClass = spriteCssClass;
    }
	
	
}
