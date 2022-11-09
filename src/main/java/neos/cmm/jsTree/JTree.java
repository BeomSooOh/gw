package neos.cmm.jsTree;
import java.util.Iterator;
import java.util.List;

public class JTree {
	
	JItemBase root;
	
	public JItemBase getRoot() {
		return root;
	}

	public void setRoot(JItemBase root) {
		this.root = root;
	}

	public void add(JItemBase item) {
		root.add(item);
	}

	public void addAll(List<JItemBase> list) {
		Iterator<JItemBase> iter = list.iterator();
		while (iter.hasNext()) {
			add(iter.next());
		}
	}

	public String toString() {
		return toString(root);
	}

	public String toString(JItemBase node) {
		StringBuffer sb = new StringBuffer();
		sb.append(node.toString());

		Iterator<JItemBase> iter = node.children.iterator();
		while (iter.hasNext()) {
			sb.append(toString(iter.next()));
		}

		return sb.toString();
	}

}
    
