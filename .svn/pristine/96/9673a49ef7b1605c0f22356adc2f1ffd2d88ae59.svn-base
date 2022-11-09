package api.hdcs.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;


@Repository("HdcsDAO")
public class HdcsDAO extends EgovComAbstractDAO {

	public Map<String, Object> selectGroupPath(Map<String, Object> paramMap) {
		
		Map<String, Object> result = (Map<String, Object>) select("HdcsDAO.selectGroupPath", paramMap);
	
		return result;
	}
	
	public Map<String, Object> selectAttachFileInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> result = (Map<String, Object>) select("HdcsDAO.selectAttachFileDetail", paramMap);
	
		return result;
	}
	
}