package restful.fund.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("FundDAO")
public class FundDAO extends EgovComAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getSmartMenuAuthList(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> result = null;
		
		result = list("FundDAO.SmartMenuAuthListSelect", params);
		
		
		
		return list("FundDAO.SmartMenuAuthListSelect", params);
	}
}
