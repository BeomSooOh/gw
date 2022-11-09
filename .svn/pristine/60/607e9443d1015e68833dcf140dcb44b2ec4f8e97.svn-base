package restful.item.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import restful.item.dao.ItemDAO;
import restful.item.service.ItemService;

@Service("ItemService")
public class ItemServiceImpl implements ItemService{
	@Resource(name = "ItemDAO")
	private ItemDAO itemDAO;
	
	public List<Map<String, Object>> getItemList(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> itemList = new ArrayList<Map<String, Object>>();
		
		itemList = itemDAO.getItemList(params);
		
		return itemList;
	}
}
