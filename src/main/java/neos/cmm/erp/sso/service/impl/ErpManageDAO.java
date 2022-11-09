package neos.cmm.erp.sso.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;


@Repository("ErpManageDAO")
public class ErpManageDAO extends EgovComAbstractDAO {

	public Map<String, Object> selectEmpInfo(Map<String, Object> paramMap) {
	
		Map<String, Object> result = (Map<String, Object>) select("ErpManageDAO.selectEmpInfo", paramMap);
	
		return result;
	}
	
	public Map<String, Object> selectLinkMenuInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> result = (Map<String, Object>) select("ErpManageDAO.selectLinkMenuInfo", paramMap);
	
		return result;
	} 
}
