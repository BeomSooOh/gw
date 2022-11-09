package egovframework.com.uat.uia.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.LoginFailInfoVO;
import egovframework.com.cmm.LoginPolicyNpVO;
import egovframework.com.cop.ems.service.EgovSndngMailRegistService;
import egovframework.com.cop.ems.service.SndngMailVO;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovNumberUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeSpecific;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.OutAuthentication;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 비즈니스 구현 클래스
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
@Service("loginService")
public class EgovLoginServiceImpl extends AbstractServiceImpl implements EgovLoginService {
    
    @Resource(name="loginDAO")
    private LoginDAO loginDAO;
    
    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
    
    /** EgovSndngMailRegistService */
	@Resource(name = "sndngMailRegistService")
    private EgovSndngMailRegistService sndngMailRegistService;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name="EmpManageService")
	EmpManageService empManageService;
	
	@Resource(name="LdapAdapterService")
	public LdapAdapterService ldapManageService;	
	
	
	/**
     * id를 이용해 loginVO 정보를 가져온다.
     * @param vo LoginVO
	 * @return List<LoginVO>
	 * @exception Exception
     */
    public List<LoginVO> selectLoginVO(LoginVO vo) throws Exception{
    	return loginDAO.selectLoginVO(vo);
    }
    
	 /**
	 * id별 사용자 정보 가져온다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public List<LoginVO> selectLoginInfo(LoginVO vo) throws Exception {
    	
    	return loginDAO.selectLoginInfo(vo);
    	    	
    }
	
	/**
     * 2011.08.26
	 * EsntlId를 이용한 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionLoginByEsntlId(LoginVO vo) throws Exception {
    	
    	
    	LoginVO loginVO = loginDAO.actionLoginByEsntlId(vo);
    	
    	// 3. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;
    }
	
    /**
	 * SS) 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 * @author kim seok hwan
	 */
    public LoginVO actionLoginToSSO(LoginVO vo) throws Exception {
    	
    	// 1. 입력한 비밀번호를 암호화한다.
    	String enpassword = EgovFileScrty.encryptPassword(vo.getPassword());
    	vo.setPassword(enpassword);
    	
    	// 2. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
    	LoginVO loginVO = loginDAO.actionLoginToSSO(vo);
    	
    	// 3. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;
    }
    
	 public LoginVO actionLoginToSSONoToken(LoginVO vo) throws Exception {
	    	
	    	// 1. 입력한 비밀번호를 암호화한다.
	    	String enpassword = EgovFileScrty.encryptPassword(vo.getPassword());
	    	vo.setPassword(enpassword);
	    	
	    	// 2. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
	    	LoginVO loginVO = loginDAO.actionLoginToSSONoToken(vo);
	    	
	    	// 3. 결과를 리턴한다.
	    	if (loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")) {
	    		return loginVO;
	    	} else {
	    		loginVO = new LoginVO();
	    	}
	    	
	    	return loginVO;
	    }
    
    /**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
	 public LoginVO actionLogin(LoginVO vo,HttpServletRequest request) throws Exception { 
		 
		//AD연동
		 if(BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapUseYn").equals("Y")){
    		Map<String, Object> ldapParam = new HashMap<String, Object>();
    		ldapParam.put("groupSeq", vo.getGroupSeq());
    		ldapParam.put("loginId", vo.getId());
    		ldapParam.put("loginPasswd", vo.getPassword());
    		Map<String, Object> ldapResult = ldapManageService.ldapAuthCheck(ldapParam);
    		
    		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapLogon").equals("Y")){
        		if(ldapResult != null && ldapResult.get("resultCode").equals("SUCCESS")){
        			vo.setPassword("▦");
        		}else{
        			return new LoginVO();
        		}    			
    		}else{
    			vo.setPassword(CommonUtil.passwordEncrypt(replacePasswd(vo.getPassword())));    			
    		}
    	}
    	//솔트웨어 포털 로그인
    	else if(BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLogin").equals("Y") && !vo.getId().equals(BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassAdmin"))){
			if (!OutAuthentication.checkUserAuthSW(vo.getId(), vo.getPassword())) {
				return new LoginVO();
			}
			else {
				vo.setPassword("▦");
			}
    	}
    	else{
            //1. 입력한 비밀번호를 암호화한다.
    		vo.setPassword(CommonUtil.passwordEncrypt(replacePasswd(vo.getPassword())));
    	}
        // 2. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
    	LoginVO loginVO = loginDAO.actionLogin(vo);
    	//  접근 대역 IP가 아니지만 , 로그인 할 수 있도록 패킷 변조를 할 수 있는 취약점으로 인한 체크 로직 추가
    	 if(loginVO != null) {
 	    	boolean accessFlag = true;
 	    	Map<String, Object> paraMap = new HashMap<String, Object>();
 	    	paraMap.put("empSeq", loginVO.getUniqId());
 	    	paraMap.put("groupSeq", loginVO.getGroupSeq());
 	    	List<Map<String, Object>> empInfoList = commonSql.list("EmpManage.getEmpInfoListAccess", paraMap);
 	    	
 	    	String compList = "";
 	    	String chkCompList = "";
 	    	String compSeqList = "";
 	    	
 	    	for(Map<String, Object> mp : empInfoList){
 	    		if(mp.get("mainDeptYn").toString().equals("Y")){
 	    			compList += "," + mp.get("compSeq"); 
 	    			chkCompList += "," + mp.get("compSeq");
 	    		}
 	    		compSeqList += ",'" + mp.get("compSeq") + "'";
 	    	}
 	    	if(compList.length() > 0 ) {
 	    		compList = compList.substring(1);
 	    	}
 	    	if(compSeqList.length() > 0) {
 	    		compSeqList = compSeqList.substring(1);
 	    	}
 	    	if(chkCompList.length() > 0) {
 	    		chkCompList = chkCompList.substring(1);
 	    	}
 	    	
 	    	paraMap.put("groupSeq", loginVO.getGroupSeq());
 	    	paraMap.put("compSeqList", compSeqList);
 	    	List<Map<String, Object>> compAccessIpList = commonSql.list("AcessManage.compAccessIpList", paraMap);
 	    		
 		    	if(compAccessIpList.size() > 0){
 		    		
 		    		List<Map<String, Object>> checkIpList = new ArrayList<Map<String, Object>>();
 		    		
 		    		for(Map<String, Object> empMap : empInfoList){
 			    		for(Map<String, Object> mp : compAccessIpList){
 			    			if(mp.get("gbnOrg").toString().equals("c")){
 			    				if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString())){
 			    					Map<String, Object> ipMap = new HashMap<String, Object>();
 			    					ipMap.put("startIp", mp.get("startIp"));
 			    					ipMap.put("endIp", mp.get("endIp"));
 			    					checkIpList.add(ipMap);
 			    				}
 			    			}else if(mp.get("gbnOrg").toString().equals("d")){
 			    				Map<String, Object> ipMap = new HashMap<String, Object>();
 			    				if(mp.get("path") != null && !mp.get("path").toString().equals("")){
 			    					String checkPath = "|" + empMap.get("path") + "|";
 			    					if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString()) && checkPath.indexOf("|" + mp.get("path") + "|") != -1){
 			    						ipMap.put("startIp", mp.get("startIp"));
 				    					ipMap.put("endIp", mp.get("endIp"));
 				    					checkIpList.add(ipMap);
 			    					}
 			    				}
 			    				else{
 				    				if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString()) && empMap.get("deptSeq").toString().equals(mp.get("deptSeq").toString())){				    					
 				    					ipMap.put("startIp", mp.get("startIp"));
 				    					ipMap.put("endIp", mp.get("endIp"));
 				    					checkIpList.add(ipMap);
 				    				}	
 			    				}
 			    			}else if(mp.get("gbnOrg").toString().equals("u")){
 			    				if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString()) && empMap.get("deptSeq").toString().equals(mp.get("deptSeq").toString()) && empMap.get("empSeq").toString().equals(mp.get("empSeq").toString())){
 			    					Map<String, Object> ipMap = new HashMap<String, Object>();
 			    					ipMap.put("startIp", mp.get("startIp"));
 			    					ipMap.put("endIp", mp.get("endIp"));
 			    					checkIpList.add(ipMap);
 			    				}
 			    			}
 			    		}
 		    		}
 		    				    		
 		    		int successCnt = 0;
 		    		for(Map<String, Object> mp : checkIpList){
 		    			String startIp = mp.get("startIp") + "";
 		    			String endIp = mp.get("endIp") + "";
 		    			
 		    			String[] ipTemp = startIp.split("\\.");
 		    			Long startIpLong = (Long.parseLong(ipTemp[0]) << 24) + (Long.parseLong(ipTemp[1]) << 16) + (Long.parseLong(ipTemp[2]) << 8) + Long.parseLong(ipTemp[3]);
 		    			ipTemp = endIp.split("\\.");
 		    			Long endIpLong = (Long.parseLong(ipTemp[0]) << 24) + (Long.parseLong(ipTemp[1]) << 16) + (Long.parseLong(ipTemp[2]) << 8) + Long.parseLong(ipTemp[3]);
 		    			ipTemp = CommonUtil.getClientIp(request).split("\\.");
 		    			Long connectIp = (Long.parseLong(ipTemp[0]) << 24) + (Long.parseLong(ipTemp[1]) << 16) + (Long.parseLong(ipTemp[2]) << 8) + Long.parseLong(ipTemp[3]);
 		    			
 		    			if(connectIp >= startIpLong && connectIp <= endIpLong){
 		    				successCnt++;
 		    			}
 		    		}
 		    		if(successCnt > 0) {
 		    			accessFlag = true;
 		    		}
 		    		else {
 		    			accessFlag = false;
 		    		}
 		    		
 		    		if(checkIpList.size() == 0) {
 		    			accessFlag = true;
 		    		}
 		    	}
 		   //  접근 대역 IP가 아니라면 VO에 abnormalApproach 셋팅을 한다
 		   //  return 시 EgovSpringSecurityLoginFilte- doFilter로 이동
 	    	if(accessFlag){}else{loginVO.setIp("abnormalApproach");}
 	    }
    	// 3. 결과를 리턴한다.
    	if(loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")){ 
	    	// 비밀번호 횟수 초과 초기화
    		Map<String, Object> params = new HashMap<String, Object>();
	    	params.put("empSeq", loginVO.getUniqId());
	    	params.put("groupSeq", loginVO.getGroupSeq());
	    	empManageService.initPasswordFailcount(params);

    		return loginVO;
    	}else{
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;
    }
    
    /**
	 * 일반 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionLoginSSO(LoginVO vo) throws Exception {
        
    	LoginVO loginVO = loginDAO.actionLoginSSO(vo);
        
    	if(loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")){
    		return loginVO;
    	}else{
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;
    }
    
    /**
	 * 인증서 로그인을 처리한다
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO actionCrtfctLogin(LoginVO vo) throws Exception {
    	
    	// 1. DN값으로 ID, PW를 조회한다.
    	LoginVO loginVO = loginDAO.actionCrtfctLogin(vo);
    	
    	// 3. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;
    }
    
    /**
	 * 아이디를 찾는다.
	 * @param vo LoginVO
	 * @return LoginVO
	 * @exception Exception
	 */
    public LoginVO searchId(LoginVO vo) throws Exception {

    	// 1. 이름, 이메일주소가 DB와 일치하는 사용자 ID를 조회한다.
    	LoginVO loginVO = loginDAO.searchId(vo);
    	
    	// 2. 결과를 리턴한다.
    	if (loginVO != null && !loginVO.getId().equals("")) {
    		return loginVO;
    	} else {
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;
    }
    
    /**
	 * 비밀번호를 찾는다.
	 * @param vo LoginVO
	 * @return boolean
	 * @exception Exception
	 */
    public boolean searchPassword(LoginVO vo) throws Exception {
    	
    	boolean result = true;
    	
    	// 1. 아이디, 이름, 이메일주소, 비밀번호 힌트, 비밀번호 정답이 DB와 일치하는 사용자 Password를 조회한다.
    	LoginVO loginVO = loginDAO.searchPassword(vo);
    	if (loginVO == null || loginVO.getPassword() == null || loginVO.getPassword().equals("")) {
    		return false;
    	}
    	
    	// 2. 임시 비밀번호를 생성한다.(영+영+숫+영+영+숫=6자리)
    	String newpassword = "";
    	for (int i = 1; i <= 6; i++) {
    		// 영자
    		if (i % 3 != 0) {
    			newpassword += EgovStringUtil.getRandomStr('a', 'z');
    		// 숫자
    		} else {
    			newpassword += EgovNumberUtil.getRandomNum(0, 9);
    		}
    	}
    	
    	// 3. 임시 비밀번호를 암호화하여 DB에 저장한다.
    	LoginVO pwVO = new LoginVO();
    	String enpassword = EgovFileScrty.encryptPassword(newpassword);
    	pwVO.setId(vo.getId());
    	pwVO.setPassword(enpassword);
    	pwVO.setUserSe(vo.getUserSe());
    	loginDAO.updatePassword(pwVO);
    	
    	// 4. 임시 비밀번호를 이메일 발송한다.(메일연동솔루션 활용)
    	SndngMailVO sndngMailVO = new SndngMailVO();
    	sndngMailVO.setDsptchPerson("webmaster");
    	sndngMailVO.setRecptnPerson(vo.getEmail());
    	sndngMailVO.setSj("[MOPAS] 임시 비밀번호를 발송했습니다.");
    	sndngMailVO.setEmailCn("고객님의 임시 비밀번호는 " + newpassword + " 입니다.");
    	sndngMailVO.setAtchFileId("");
    	
    	result = sndngMailRegistService.insertSndngMail(sndngMailVO);
    	
    	return result;
    }
    
    /**
     * 비밀번호를 변경한다.
     * @param vo LoginVO
	 * @return boolean
	 * @exception Exception
     */
    public boolean updatePassword(LoginVO vo){
        try {
            //vo.setPassword(enpassword);
            String siteCode =  CommonCodeSpecific.getCompanyCD() ;
            
            // 1. 입력한 비밀번호를 암호화한다.
            //금융투자협회 사이트 코드  :  10014
            String enpassword  = CommonUtil.passwordEncrypt(vo.getPassword()) ;
            vo.setPassword(enpassword);
            loginDAO.updatePassword(vo);
            return true;
        } catch (Exception e) {
            
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
            return false;
        }
    }

    /**
     * 사무실 팩스번호와 전화번호를 업데이트 하나. 
     */
	@Override
	public boolean updateOfficeNm(HashMap<String, String> paramMap)
			throws Exception {
    try {
        loginDAO.updateOfficeNm(paramMap);
     
          return true;
    	} catch (Exception e) {
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
          return false;
		}
	}
	
	
    /**
	 * 세션 정보를 저장한다.
	 * @param vo LoginVO, String
	 * @return void
	 * @exception Exception
	 */
    public void LoginSessionInfo(LoginVO loginVO) throws Exception {
        String siteCode =  CommonCodeSpecific.getCompanyCD() ;

    	loginDAO.LoginSessionInfo(loginVO);
    	
    }	
	
	
    public String searchLoginSessionId(String emplyrId) throws Exception {
    	String loginSessionId = loginDAO.searchLoginSessionId(emplyrId);

    	// 결과를 리턴한다.
    	if (loginSessionId != null ) {
    		return loginSessionId;
    	} else {
    		loginSessionId = "";
    	}    	
    	
    	return loginSessionId;
    }

    public void deleteLoginSessionId(LoginVO loginVO) throws Exception {
    	loginDAO.deleteLoginSessionId(loginVO);
    }    

    public LoginFailInfoVO selectLoginFailInfo(Map<String, Object> mp) throws Exception {
    	LoginFailInfoVO loginFailinfo = loginDAO.selectLoginFailInfo(mp);

    	// 결과를 리턴한다.
    	if (loginFailinfo != null && !loginFailinfo.getId().equals("") ) {
    		return loginFailinfo;
    	} else {
    		loginFailinfo = new LoginFailInfoVO();
    	}
    	
    	return loginFailinfo;
    }         
    
    public void LoginFailInfo(Map<String, Object> mp) throws Exception {
    	loginDAO.LoginFailInfo(mp);    	
    }    

    public void deleteLoginFailInfo(LoginVO loginVO) throws Exception {
    	loginDAO.deleteLoginFailInfo(loginVO);
    }     

    public void updateLoginFailInfo(String emplyrId) throws Exception {
    	loginDAO.updateLoginFailInfo(emplyrId);
    } 

    public void updateLoginFailInfoInit(String emplyrId) throws Exception {
    	loginDAO.updateLoginFailInfoInit(emplyrId);
    }     
    
    public void updateLoginLock(String emplyrId) throws Exception {
    	loginDAO.updateLoginLock(emplyrId);
    }     
    
    public void updateLoginSuccess(LoginVO loginVO) throws Exception {
    	loginDAO.updateLoginSuccess(loginVO);
    }
    
    public LoginPolicyNpVO searchLoginPolicy(String strSeq) throws Exception {
    	LoginPolicyNpVO loginPolicyVO = loginDAO.searchLoginPolicy(strSeq);

    	// 결과를 리턴한다.
    	if (loginPolicyVO != null && !loginPolicyVO.getSeq().equals("") ) {
    		return loginPolicyVO;
    	} else {
    		loginPolicyVO = new LoginPolicyNpVO();
    	}    	
    	
    	return loginPolicyVO;
    }

	@Override
	public boolean updateUserImg(Map<String, Object> params) {
		try {
			loginDAO.updateUserImg(params);

			return true;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return false;
		}
	}

	@Override
	public boolean updateMainCompany(Map<String, Object> params) {
		try {
			loginDAO.updateMainCompany(params);

			return true;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return false;
		}
	}

	@Override
	public LoginVO selectLoginSessionInfo(LoginVO loginVO) {
		return loginDAO.selectLoginSessionInfo(loginVO);
	}

	@Override
	public boolean updatePasswordMy(LoginVO vo, String type) {
		try {          
            // 비밀번호 암호화
            String enpassword  = CommonUtil.passwordEncrypt(vo.getPassword()) ;
            vo.setPassword(enpassword);
            
            // 기본 비밀번호
            if (type.equals("def")) {
				loginDAO.updatePasswordMy(vo, "def");
			}
            // 결재 비밀번호
            else if (type.equals("app")) {
				loginDAO.updatePasswordMy(vo, "app");
			}
            // 급여 비밀번호
            else {
				loginDAO.updatePasswordMy(vo, "pay");
			}
            
            return true;
        } catch (Exception e) {
            
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
            return false;
        }
	}

	@Override
	public LoginVO passwordCheck(LoginVO vo, String type) throws Exception {
		// 1. 입력한 비밀번호 암호화.
        String enPass = null;
        enPass  = CommonUtil.passwordEncrypt(vo.getPassword()) ;
        vo.setPassword(enPass);

        // 2. 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인.
    	LoginVO loginVO = loginDAO.passwordCheck(vo, type);
    	
    	// 3. 비밀번호 체크결과 리턴.
    	if(loginVO != null && !loginVO.getId().equals("") && !loginVO.getPassword().equals("")){
    		return loginVO;
    	}else{
    		loginVO = new LoginVO();
    	}
    	
    	return loginVO;
	}
	
	public HashMap<String, Object> selectOptionSet(Map<String, Object> mp){
		return loginDAO.selectOptionSet(mp);
	}
	
	/**
	 * 로그인 시 ID 유/무 check 및 옵션 가져오기(ID 존재시) 
	 */
	public boolean loginIdExistCheck(Map<String, Object> mp) throws Exception {
		boolean result = false;
		String loginInfo = loginDAO.selectLoginIdExistCheck(mp); 
	
		if(loginInfo != null) {		// 아이디 값이 존재
			result = true;
		} else {					// 아이디 값이 아예 존재 하지 않음
			result = false;
		}
		
		return result;
	}
	
	// 로그인 실패 카운트
	public String loginOptionResult(Map<String, Object> mp) throws Exception {
		
		// 로그인 통제 옵션 값 가져오기
		mp.put("optionArray", "'cm100','cm101','cm101_1'");
    	List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);		
		
    	// 로그인 통제 옵션 변수
    	String loginOption = null;
    	String[] loginFailValue = null;
    	String loginFailCnt = "0";		// 로그인 실패 횟수 설정 값
    	String loginFailMin = "0";
    	String loginNotUseDay = "0";
    			
    	for(Map<String, Object> items : loginOptionValue) {
    		
    		if(items.get("optionId").equals("cm100")) {	// 로그인/로그아웃 통제
    			loginOption = items.get("optionRealValue").toString();
    		}else if(items.get("optionId").equals("cm101")) {			// 로그인 실패 잠금설정
    			loginFailValue = items.get("optionRealValue").toString().split("\\|");
    			loginFailCnt = loginFailValue[0];
    			if(loginFailValue.length > 1){
    				loginFailMin = loginFailValue[1];
    			}
    		}else if(items.get("optionId").equals("cm101_1")) {			// 로그인 미접속 잠금설정
    			loginNotUseDay = items.get("optionRealValue").toString();
    		}
    	}
    	
    	String failCount = "0";
    	String blockYn = "N";
    	String notUseYn = "N";
    	String remainMin = "|0";
    	
    	mp.put("loginFailMin", loginFailMin);
    	mp.put("loginNotUseDay", loginNotUseDay);
    	Map<String, Object> failInfo = loginDAO.selectLoginFailCount(mp);		// 실패 카운트
    	
    	if(failInfo != null){
    		failCount = failInfo.get("passwdInputFailCount").toString();
    		blockYn = failInfo.get("blockYn").toString();
    		notUseYn = failInfo.get("notUseYn").toString();
    		
    		if(!loginFailMin.equals("0") && !loginFailMin.equals("")) {
    			remainMin = "|" + failInfo.get("remainMin").toString();
    		}
    		
    	}
    	
    	if(loginOption != null && loginOption.equals("1")) {
    		if(!failCount.equals("-1")) {
    			
    			if(notUseYn.equals("Y")){
    				failCount = "longTerm";
    			}
    			
    			if(!loginFailCnt.equals("0")) {
    				// 설정 값과 실패 횟수 같을 때
    				if(failCount.equals(loginFailCnt)) {
    					// 로그인 block 상태
    					int result = loginDAO.updateLoginBlock(mp);
    					
    					if(result > 0) {
    						failCount = "block" + remainMin;
    					}
    				}
    			}
    			
    		}else if(failCount.equals("-1") && blockYn.equals("N")){
				// 로그인 block 상태비활성화
    			mp.put("passwdInputFailCount", "0");
				int result = loginDAO.updateLoginBlock(mp);
				
				if(result > 0) {
					failCount = "0";
				}    			
    			
    		}else {
    			failCount = "block" + remainMin;
    		}
    	} else {
    		failCount = "optionNotUse";
    	}
		return failCount;
	}
	
	public int updateLoginFailCount(Map<String, Object> mp) {
		int result = 0;
		
		result = loginDAO.updateLoginFailCount(mp);
		
		if(result>0){
			//System.out.println("update 성공");
		}
		
		return 0;
	}
	
	public String replacePasswd(String str){

		if(str.indexOf("&nbsp;") != -1) {
			str = str.replaceAll("&nbsp;", " ");}
		if(str.indexOf("&amp;") != -1) {
			str = str.replaceAll("&amp;", "&");}
		if(str.indexOf("&lt;") != -1) {
			str = str.replaceAll("&lt;", "<");}
		if(str.indexOf("&gt;") != -1) {
			str = str.replaceAll("&gt;", ">");}
		if(str.indexOf("&quot;") != -1) {
			str = str.replaceAll("&quot;", "\"");}
		
		return str;
	}
	
	public void updateSpringSecuKey(Map<String, Object> params) throws Exception{
		loginDAO.updateSpringSecuKey(params);
	}	
	
	// 메일아이디로 그룹웨어 아이디 가져오기
	public String selectMailIdToLoginId(Map<String, Object> params) throws Exception {
		return (String)loginDAO.selectMailIdToLoginId(params);
	}
}

	
	


