package neos.cmm.kendo;
import java.util.Iterator;
import java.util.List;

public class KTree {
	
	KItemBase root;
	
	public KItemBase getRoot() {
		return root;
	}

	public void setRoot(KItemBase root) {
		this.root = root;
	}

	public void add(KItemBase item) {
		root.add(item);
	}

	public void addAll(List<KItemBase> list) {
		Iterator<KItemBase> iter = list.iterator();
		while (iter.hasNext()) {
			add(iter.next());
		}
	}

	public String toString() {
		return toString(root);
	}

	public String toString(KItemBase node) {
		StringBuffer sb = new StringBuffer();
		sb.append(node.toString());

		Iterator<KItemBase> iter = node.items.iterator();
		while (iter.hasNext()) {
			sb.append(toString(iter.next()));
		}

		return sb.toString();
	}

}
    
