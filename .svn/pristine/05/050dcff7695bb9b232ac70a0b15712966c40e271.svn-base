package neos.cmm.systemx.etc.service.impl;

import java.util.Map;

import neos.cmm.systemx.etc.LogoManageVo;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * 
 * @title 로그 관리 DAO
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
@Repository("LogoManageDAO")
public class LogoManageDAO extends EgovComAbstractDAO {

	/**
	 * 기관ID에 따른 로고 파일 위치를 가져온다.
	 * @param String organId
	 * @return LogoManageVo 
	 * @exception Exception
	 */
	public LogoManageVo selectLogoInfo(String organId) throws Exception{
		return (LogoManageVo)select("LogoManageDAO.selectLogoInfo", organId); 
	}
	
	/**
	 * 로그인 화면의 로고 저장 위치 가져오기
	 * @param 
	 * @return LogoManageVo 
	 * @exception Exception
	 */
	@SuppressWarnings("deprecation")
	public LogoManageVo selectLoginLogoInfo() throws Exception{
		return (LogoManageVo)select("LogoManageDAO.selectLoginLogoInfo", ""); 
	}

	/**  로그인 알림게시판 내용 가져오기 **/
    public String selectLoginNotice() {
        return (String) select("LogoManageDAO.selectLoginNotice", ""); 
    }

    @SuppressWarnings({ "unchecked", "deprecation" })
    public Map<String, Object> getDomainCompInfo(Map<String, Object> paramMap) {
        return (EgovMap) select("LogoManageDAO.getDomainCompInfo", paramMap);
    }

	public Map<String, Object> getCompInfo(Map<String, Object> paramMap) {
		 return (EgovMap) select("LogoManageDAO.getCompInfo", paramMap);
	}
	
}
