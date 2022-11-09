package egovframework.com.uat.uia.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Repository;

import bizbox.orgchart.service.vo.LoginVO;
//import org.tempuri.UserAuthWDO;

import egovframework.com.cmm.LoginPolicyNpVO;
import egovframework.com.cmm.LoginFailInfoVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 DAO 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *  
 * <pre>
 * << 개정이력(Modification Information) >> 
 * 
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성 
 *  2011.08.26  서준식          EsntlId를 이용한 로그인 추가
 *  2012.08.29	박기환			id별 사용자 정보 가져오기 추가
 *  </pre>
 */
@Repository("loginDAO")
public class LoginDAO extends EgovComAbstractDAO {
	
	/** log */
    protected static final Log LOG = LogFactory.getLog(LoginDAO.class);
    
    /**
     * id를 이용해 loginVO 정보를 가져온다.
     * @param vo LoginVO
	 * @return List<LoginVO>
	 * @exception Exception
     */
    public List<LoginVO> selectLoginVO(LoginVO vo) throws Exception{
    	return (List<LoginVO>)list("loginDAO.selectLoginVO", vo);    	
    }
    
    
    /**
     * 2011.08.26
	 * EsntlId를 이용한 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionLoginByEsntlId(LoginVO vo) throws Exception {
    	return (LoginVO)select("loginDAO.ssoLoginByEsntlId", vo);
    }
    
    
	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionLogin(LoginVO vo) throws Exception {
    	return (LoginVO)select("loginDAO.actionLogin", vo);
    }
    
    
    /**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionLoginSSO(LoginVO vo) throws Exception {
    	return (LoginVO)select("loginDAO.actionLoginSSO", vo);
    }
    
    
	/**
	 * SSO 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionLoginToSSO(LoginVO vo) throws Exception {
    	return (LoginVO)select("loginDAO.actionLoginToSSO", vo);
    }
    
    public LoginVO actionLoginToSSONoToken(LoginVO vo) throws Exception {
    	return (LoginVO)select("loginDAO.actionLoginToSSONoToken", vo);
    }
    
    /**
	 * 인증서 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionCrtfctLogin(LoginVO vo) throws Exception {
    	
    	return (LoginVO)select("loginDAO.actionCrtfctLogin", vo);
    }
    
    /**
	 * 아이디를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO searchId(LoginVO vo) throws Exception {
    	
    	return (LoginVO)select("loginDAO.searchId", vo);
    }
    
    /**
	 * 비밀번호를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO searchPassword(LoginVO vo) throws Exception {
    	
    	return (LoginVO)select("loginDAO.searchPassword", vo);
    }
    
    /**
	 * 변경된 비밀번호를 저장한다.
	 * @param vo LoginVO
	 * @exception Exception
	 */
    public void updatePassword(LoginVO vo) throws Exception {
    	update("loginDAO.updatePassword", vo);
    }
    
    /**
	 * id별 사용자 정보 가져온다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public List<LoginVO> selectLoginInfo(LoginVO vo) throws Exception {    	    	
    	return (List<LoginVO>)list("loginDAO.selectLoginInfo", vo);
    }

    /**
     * 모바일 웹서비스 로그인 처리 
     *<pre>
     * 1. MethodName	:  actionLoginWS
     * 2. Description	: URI  -
     *                    Menu - 
     * ------- 개정이력(Modification Information) ----------
     *    작성일            작성자         작성정보
     *    2013. 2. 20.      문의형         최초작성
     *  -----------------------------------------------------
     *</pre>
     * @param loginVO
     * @return
     * @throws Excpetion
     */
    public void updateOfficeNm(HashMap<String, String> paramMap) throws Exception {
    	update("loginDAO.updateOfficeNm", paramMap);
    }
    
    /**
	 * 세션 정보를 저장한다.
	 * @param vo LoginVO, String
	 * @return void
	 * @exception Exception
	 */
    public void LoginSessionInfo(LoginVO loginVO) throws Exception {
    	insert("loginDAO.loginSessionInfo", loginVO);
    }    
    
    // 로그인 세션 id 추출
    public String searchLoginSessionId(String emplyrId) throws Exception {
    	return (String)select("loginDAO.searchLoginSessionId" , emplyrId);
    }     

    // 로그인 세션 id 삭제
    public void deleteLoginSessionId(LoginVO loginVO) throws Exception {
    	//update("loginDAO.deleteLoginSessionId" , loginVO);
    	delete("loginDAO.cmpltDeleteLoginSessionId" , loginVO);
    }  
    
    
    // 로그인 오류 회수 지정
    public void LoginFailInfo(Map<String, Object> mp) throws Exception {
    	insert("loginDAO.LoginFailInfo", mp);
    }    
    
    // 로그인 오류 회수 수정
    public void updateLoginFailInfo(String emplyrId) throws Exception {
    	update("loginDAO.updateLoginFailInfo" , emplyrId);
    }     

    // 로그인 오류 회수 수정
    public void updateLoginFailInfoInit(String emplyrId) throws Exception {
    	update("loginDAO.updateLoginFailInfoInit" , emplyrId);
    } 
    
    // 로그인 오류 회수 수정
    public void updateLoginLock(String emplyrId) throws Exception {
    	update("loginDAO.updateLoginLock" , emplyrId);
    }     
    
    // 로그인 오류 회수 수정
    public void updateLoginSuccess(LoginVO loginVO) throws Exception {
    	update("loginDAO.updateLoginSuccess" , loginVO);
    } 
    
    // 로그인 오류 회수 삭제
    public void deleteLoginFailInfo(LoginVO loginVO) throws Exception {
    	delete("loginDAO.deleteLoginFailInfo" , loginVO);
    }    

    // 로그인 오류 회수 추출
    public LoginFailInfoVO selectLoginFailInfo(Map<String, Object> mp) throws Exception {
    	return (LoginFailInfoVO)select("loginDAO.selectLoginFailInfo" , mp);
    }    

    public String selectLoginLock(String emplyrId) throws Exception {
    	return (String)select("loginDAO.selectLoginLock" , emplyrId);
    }    
    
    public LoginPolicyNpVO searchLoginPolicy(String strSeq) throws Exception {
    	return (LoginPolicyNpVO)select("loginDAO.searchLoginPolicy" , strSeq);
    }


	public void updateUserImg(Map<String, Object> params) {
		update("loginDAO.updateUserImg" , params);
    }


	public void updateMainCompany(Map<String, Object> params) {
		update("loginDAO.updateMainCompany" , params);
		
	}


	public LoginVO selectLoginSessionInfo(LoginVO loginVO) {
		return (LoginVO)select("loginDAO.selectLoginSessionInfo" , loginVO);
	}
	
	// 마이페이지 > 개인정보 수정 > 비밀번호 변경 (type : 기본(def), 결재(app), 급여(pay))
	public void updatePasswordMy(LoginVO vo, String type) throws Exception {
    	// 기본 비밀번호 
		if (type.equals("def")) {
			update("loginDAO.updatePasswordDef", vo);
		}
		// 결재 비밀번호
		else if (type.equals("app")) {
			update("loginDAO.updatePasswordApp", vo);
		}
		// 급여 비밀번호
		else {
			update("loginDAO.updatePasswordPay", vo);
		}
    }
	
	// 마이페이지 > 개인정보 수정 > 비밀번호 변경 > 기존 비밀번호 확인 (type : 기본(def), 결재(app), 급여(pay))
	public LoginVO passwordCheck(LoginVO vo, String type) throws Exception {
    	// 기본 비밀번호 
		if (type.equals("def")) {
			return (LoginVO)select("loginDAO.passwordCheckDef", vo);
		}
		// 결재 비밀번호
		else if (type.equals("app")) {
			return (LoginVO)select("loginDAO.passwordCheckApp", vo);
		}
		// 급여 비밀번호
		else {
			return (LoginVO)select("loginDAO.passwordCheckPay", vo);
		}
    }
	
	public HashMap<String, Object> selectOptionSet(Map<String, Object> mp){
		
		HashMap<String, Object> option = new HashMap<String, Object>();
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> listMap = list("loginDAO.selectOption", mp);
		
		if(listMap != null && listMap.size() > 0){
			for (Map<String, Object> map : listMap) {
				option.put((String)map.get("optionId"), map.get("optionValue") == null ? (String)map.get("optionDValue") : (String)map.get("optionValue"));
			}
		}
		
		return option;
	}	
	
	public String selectLoginIdExistCheck(Map<String, Object> mp){
		String result = (String)select("loginDAO.selectLoginIdExistCheck", mp);
		
		return result;
	}
	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectLoginFailCount(Map<String, Object> mp) {
		return (Map<String, Object>)select("loginDAO.selectLoginFailCount", mp);
	}
	
	
	public int updateLoginFailCount(Map<String, Object> mp) {
		int result = (int)update("loginDAO.updateLoginFailCount", mp);
		
		return result;
	}
	
	
	public int updateLoginBlock(Map<String, Object> mp) {
		int result = (int)update("loginDAO.updateLoginBlock", mp);
		
		return result;
	}
	
	public String selectPasswdChangeDate(String loginId) {
		String passwdChangeDate = (String)select("loginDAO.selectPasswdChangeDate", loginId);
		return passwdChangeDate;
	}
	
    public void updateSpringSecuKey(Map<String, Object> params) throws Exception {
    	update("loginDAO.updateSpringSecuKey", params);
    }
	
    public String selectMailIdToLoginId(Map<String, Object> params) throws Exception {
    	return (String)select("loginDAO.selectMailIdToLoginId", params);
    }
}
