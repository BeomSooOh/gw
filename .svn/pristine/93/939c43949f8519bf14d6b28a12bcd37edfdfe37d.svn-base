package neos.cmm.systemx.etc.service;

import java.util.Map;

import neos.cmm.systemx.etc.LogoManageVo;

/**
 * 
 * @title 로고관리 service interface
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 8. 27.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 8. 27.  박기환        최초 생성
 *
 */
public interface LogoManageService {

	/**
	 * 기관ID에 따른 로고 파일 위치를 가져온다.
	 * @param String organId
	 * @return LogoManageVo 
	 * @exception Exception
	 */
	public LogoManageVo selectLogoInfo(String organId) throws Exception;
	
	/**
	 * 로그인 화면의 로고 저장 위치 가져오기
	 * @param 
	 * @return LogoManageVo 
	 * @exception Exception
	 */
	public LogoManageVo selectLoginLogoInfo() throws Exception;

    public String selectLoginNotice() throws Exception;

    public Map<String, Object> getDomainCompInfo(Map<String, Object> paramMap);

	public Map<String, Object> getCompInfo(Map<String, Object> paramMap);
}
