package api.msg.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("MsgDAO")
public class MsgDAO extends EgovComAbstractDAO {

	public String getMsgMenuVer(Map<String, Object> paramMap) {
	
		String result = (String) select("MsgDAO.selectMenuVersion", paramMap);
	
		return result;
	}
	
	public List<Map<String, Object>> getMsgMenuList(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> result = list("MsgDAO.selectMenuList", paramMap);
	
		return result;
	}
	
	public List<Map<String, Object>> getSubMenuList(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> result = list("MsgDAO.selectSubMenuList", paramMap);
	
		return result;
	}
	
	public String getSSOToken(Map<String, Object> paramMap) {
		
		String result = (String) select("MsgDAO.getSSOToken", paramMap);
	
		return result;
	}

	public List<Map<String, Object>> getMsgBaseMenuList(Map<String, Object> param) {

		List<Map<String, Object>> result = list("MsgDAO.selectBaseMenuList", param);
		
		return result;
		
	} 
}
