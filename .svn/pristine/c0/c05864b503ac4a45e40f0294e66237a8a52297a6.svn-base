package neos.cmm.systemx.etc.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.systemx.etc.LogoManageVo;
import neos.cmm.systemx.etc.service.LogoManageService;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

/**
 * 
 * @title 로고관리 service
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
@SuppressWarnings("deprecation")
@Service("LogoManageService")
public class LogoManageServiceImpl extends AbstractServiceImpl implements LogoManageService {

	@Resource(name = "LogoManageDAO")
	private LogoManageDAO logoManageDAO; 
	
	/**
	 * 기관ID에 따른 로고 파일 위치를 가져온다.
	 * @param String organId
	 * @return LogoManageVo 
	 * @exception Exception
	 */
	public LogoManageVo selectLogoInfo(String organId) throws Exception{
		
		return logoManageDAO.selectLogoInfo(organId);
	}
	
	/**
	 * 로그인 화면의 로고 저장 위치 가져오기
	 * @param 
	 * @return LogoManageVo 
	 * @exception Exception
	 */
	public LogoManageVo selectLoginLogoInfo() throws Exception{
		return logoManageDAO.selectLoginLogoInfo();		
	}

	/** 로그인 알림사항 가져오기 **/
    @Override
    public String selectLoginNotice() throws Exception {
        return  logoManageDAO.selectLoginNotice();  
    }

    @Override
    public Map<String, Object> getDomainCompInfo(Map<String, Object> paramMap) {
        return logoManageDAO.getDomainCompInfo(paramMap);
    }

	@Override
	public Map<String, Object> getCompInfo(Map<String, Object> paramMap) {
		 return logoManageDAO.getCompInfo(paramMap);
	}
}
