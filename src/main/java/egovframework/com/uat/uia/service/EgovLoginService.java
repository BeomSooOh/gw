package egovframework.com.uat.uia.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import bizbox.orgchart.service.vo.LoginVO;

//import org.tempuri.UserAuthLoginWDO;
//import org.tempuri.UserAuthWDO;

import egovframework.com.cmm.LoginPolicyNpVO;
import egovframework.com.cmm.LoginFailInfoVO;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 비즈니스 인터페이스 클래스
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
 *  </pre>
 */
public interface EgovLoginService {
	
	/**
     * id를 이용해 loginVO 정보를 가져온다.
     * @param vo LoginVO
	 * @return List<LoginVO>
	 * @exception Exception
     */
    public List<LoginVO> selectLoginVO(LoginVO vo) throws Exception;
   
	/**
	 * id별 사용자 정보 가져온다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public List<LoginVO> selectLoginInfo(LoginVO vo) throws Exception;
	
	/**
     * 2011.08.26
	 * EsntlId를 이용한 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionLoginByEsntlId(LoginVO vo) throws Exception;
	
	/**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @param request 
	 * @return LoginVO
	 * @exception Exception
	 */
    LoginVO actionLogin(LoginVO vo, HttpServletRequest request) throws Exception;
    
    /**
	 * SSO 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    LoginVO actionLoginSSO(LoginVO vo) throws Exception;
    
    /**
	 * 인증서 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    LoginVO actionCrtfctLogin(LoginVO vo) throws Exception;
    
    /**
	 * 아이디를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    LoginVO searchId(LoginVO vo) throws Exception;
    
    /**
	 * 비밀번호를 찾는다.
	 * @param vo LoginVO
	 * @return boolean
	 * @exception Exception
	 */
    boolean searchPassword(LoginVO vo) throws Exception;

	public LoginVO actionLoginToSSO(LoginVO loginVO) throws Exception;
	
	public LoginVO actionLoginToSSONoToken(LoginVO loginVO) throws Exception;
	
	/**
     * 비밀번호를 변경한다.
     * @param vo LoginVO
	 * @return boolean
	 * @exception Exception
     */
    public boolean updatePassword(LoginVO vo);
    
    // 마이페이지 > 개인정보 수정 > 비밀번호 변경 (type : 기본(def), 결재(app), 급여(pay))
    public boolean updatePasswordMy(LoginVO vo, String type);
    
    // 마이페이지 > 개인정보 수정 > 비밀번호 변경 > 기존 비밀번호 체크 (type : 기본(def), 결재(app), 급여(pay))
    public LoginVO passwordCheck(LoginVO vo, String type) throws Exception;
    
    public boolean updateUserImg(Map<String,Object> params);
    
    
    /**
     * 사용자 기본회사 변경(모바일)
     * @param params
     * @return
     */
    public boolean updateMainCompany(Map<String,Object> params);

    /**
     * 웹 서비스 로그인 처리
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
     */
//    public UserAuthWDO actionLoginWS(LoginVO loginVO) throws Exception;
    
    /**
     * 사무실 전화번호와 팩스 넘버를 업데이트 한다. 
     *<pre>
     * 1. MethodName	:  updateOfficeNm
     * 2. Description	: URI  -
     *                    Menu - 
     * ------- 개정이력(Modification Information) ----------
     *    작성일            작성자         작성정보
     *    2013. 5. 21.     pdsystem       최초작성
     *  -----------------------------------------------------
     *</pre>
     * @param vo
     * @return
     */
    public boolean updateOfficeNm(HashMap<String, String> paramMap) throws Exception ;
    
    /**
	 * 로그인 중복 방지 위한 세션 저장 처리.
	 * @param vo LoginVO, String
	 * @return void
	 * @exception Exception
	 */    
	public void LoginSessionInfo(LoginVO loginVO) throws Exception ;

	// 로그인 세션 id 추출
	public String searchLoginSessionId(String emplyrId) throws Exception ;

	// 로그인 세션 id 삭제
	public void deleteLoginSessionId(LoginVO loginVO) throws Exception ; 	
	
	// 로그인 실패 회수 처리
	public LoginFailInfoVO selectLoginFailInfo(Map<String, Object> mp) throws Exception ;		
	public void LoginFailInfo(Map<String, Object> mp) throws Exception ; 
	public void deleteLoginFailInfo(LoginVO loginVO) throws Exception ;
	public void updateLoginFailInfo(String emplyrId) throws Exception ;
	public void updateLoginLock(String emplyrId) throws Exception ;	
	public void updateLoginSuccess(LoginVO loginVO) throws Exception ;	
	public void updateLoginFailInfoInit(String emplyrId) throws Exception ;
    public LoginPolicyNpVO searchLoginPolicy(String strSeq) throws Exception;
	public LoginVO selectLoginSessionInfo(LoginVO loginVO);
	public HashMap<String, Object> selectOptionSet(Map<String, Object> mp);
	public String loginOptionResult(Map<String, Object> mp) throws Exception;
	public boolean loginIdExistCheck(Map<String, Object> mp) throws Exception;
	public int updateLoginFailCount(Map<String, Object> mp) throws Exception;
	public void updateSpringSecuKey(Map<String,Object> params) throws Exception ;
	
	// Email 아이디로 그룹웨어 ID 가져오기
	public String selectMailIdToLoginId(Map<String, Object> params) throws Exception;
}
