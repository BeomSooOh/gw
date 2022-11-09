package neos.cmm.systemx.license.service;

import java.util.Map;

public interface LicenseService {
	
	void resetLicense();
	
	String updateDBLicenseKey(Map<String, Object> params) throws Exception;
	
	/* 라이센스 카운트 가져오기 */
	Map<String, Object> LicenseCountShow(Map<String, Object> params) throws Exception;
	
	/* 입사처리, 사원정보 수정 라이센스 체크 */
	Map<String, Object> LicenseAddCheck(Map<String, Object> params) throws Exception;
}
