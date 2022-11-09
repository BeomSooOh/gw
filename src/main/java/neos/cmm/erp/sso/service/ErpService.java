package neos.cmm.erp.sso.service;

import java.util.Map;


public interface ErpService {

	/**
	 * 메신저 링크메뉴 버전 조회
	 * @param request
	 * @return
	 */
	public Map<String, Object> selectEmpInfo(Map<String, Object> paramMap);
	
	/**
	 * 메신저 링크메뉴 리스트 조회
	 * @param request
	 * @return
	 */
	public Map<String, Object> selectLinkMenuInfo(Map<String, Object> paramMap);

}
