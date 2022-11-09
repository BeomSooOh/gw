package restful.item.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="contents")
public class ItemVO implements Serializable {
	public List<Map<String, Object>> ItemList = new ArrayList<Map<String,Object>>();

	public List<Map<String, Object>> getItemList() {
		return ItemList;
	}

	public void setItemList(List<Map<String, Object>> itemList) {
		ItemList = itemList;
	}

	@Override
	public String toString() {
		return "ItemVO [ItemList=" + ItemList + "]";
	}
}