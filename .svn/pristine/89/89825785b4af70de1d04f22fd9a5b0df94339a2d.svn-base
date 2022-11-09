package api.ext.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("ExtDAO")
public class ExtDAO extends EgovComAbstractDAO {

	public String getExtToken(Map<String, Object> paramMap) {
		
		String result = (String) select("ExtDAO.getExtToken", paramMap);
	
		return result;
	} 
	
	public Map<String, Object> getExtSSO(Map<String, Object> paramMap) {
		
		Map<String, Object> result = (Map<String, Object>) select("ExtDAO.getExtSSO", paramMap);
	
		return result;
	} 
	
	public Map<String, Object> getExtInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> result = (Map<String, Object>) select("ExtDAO.getExtInfo", paramMap);
	
		return result;
	}  
	
	public Map<String, Object> getErpInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> result = (Map<String, Object>) select("ExtDAO.getErpInfo", paramMap);
	
		return result;
	} 
	
	public Map<String, Object> getSWLinkInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> result = (Map<String, Object>) select("ExtDAO.getSWLinkInfo", paramMap);
	
		return result;
	}  
}
