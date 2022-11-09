package restful.item.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("ItemDAO")
public class ItemDAO extends EgovComAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getItemList(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> result = null;
		
		result = list("ItemDAO.getItemList", params);
		
		return result;
	}
}
