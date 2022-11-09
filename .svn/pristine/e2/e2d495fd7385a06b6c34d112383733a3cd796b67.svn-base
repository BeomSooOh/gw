package neos.cmm.systemx.license.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("LicenseDAO")
public class LicenseDAO extends EgovComAbstractDAO {
	
	/* 라이센스 카운트 가져오기 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> LicenseCountShow(Map<String, Object> params) throws Exception {
		Map<String, Object> licenseCount = new HashMap<String, Object>();
		
		licenseCount = (Map<String, Object>)select("LicenseDAO.LicenseCountShow", params);
		
		return licenseCount;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGroupInfo(Map<String, Object> params) throws Exception {
		
		return (Map<String, Object>)select("LicenseDAO.getGroupInfo", params);
		
	}
	
	public void updateLicenseKey(Map<String, Object> params) throws Exception {
		
		update("LicenseDAO.updateLicenseKey", params);
		
	}	
	
}
