package egovframework.com.sec.security.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeSpecific;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import cloud.CloudConnetInfo;
import bizbox.orgchart.service.vo.LoginVO;
import bizbox.orgchart.util.JedisClient;
import bizbox.statistic.data.dto.ActionDTO;
import bizbox.statistic.data.dto.CreatorInfoDTO;
import bizbox.statistic.data.enumeration.EnumActionStep1;
import bizbox.statistic.data.enumeration.EnumActionStep2;
import bizbox.statistic.data.enumeration.EnumActionStep3;
import bizbox.statistic.data.enumeration.EnumDevice;
import bizbox.statistic.data.enumeration.EnumModuleName;
import bizbox.statistic.data.service.ModuleLogService;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.log.clg.service.EgovLoginLogService;
import egovframework.com.sym.log.clg.service.LoginLog;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.rte.fdl.string.EgovStringUtil;
import main.web.BizboxAMessage;

import java.util.UUID;

/**
 * 
 * @author 공통서비스 개발팀 서준식
 * @since 2011. 8. 29.
 * @version 1.0
 * @see
 *
 * <pre>
 * 개정이력(Modification Information) 
 * 
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2011. 8. 29.    서준식        최초생성
 *  
 *  </pre>
 */

public class EgovSpringSecurityLoginFilter implements Filter{
	private FilterConfig config;
	
	protected final static Log LOG = LogFactory.getLog(EgovSpringSecurityLoginFilter.class);
	
	public void destroy() {
		return;
	}


	@SuppressWarnings("unchecked")
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		//로그인 URL
 		String loginURL = config.getInitParameter("loginURL");
		loginURL = loginURL.replaceAll("\r", "").replaceAll("\n", "");	// 2011.10.25 보안점검 후속조치
		
		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(config.getServletContext());
		EgovLoginService loginService = (EgovLoginService) act.getBean("loginService");
		EgovLoginLogService loginLogService = (EgovLoginLogService)act.getBean("EgovLoginLogService");
		EgovMessageSource egovMessageSource = (EgovMessageSource)act.getBean("egovMessageSource");
		
		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpServletResponse httpResponse = (HttpServletResponse)response;
		HttpSession session = httpRequest.getSession();
		String isRemotelyAuthenticated = null;

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String requestURL = ((HttpServletRequest)request).getRequestURI();
		LoginVO tempVO = (LoginVO)session.getAttribute("loginVO");
		
		//메일전용 라이센스 접근권한 처리
		if(loginVO != null && loginVO.getLicenseCheckYn().equals("2")){
			
			String mailApiList = "|/gw/uat/uia/serverSessionReset.do|/gw/uat/uia/actionLogin.do|/gw/uat/uia/egovLoginUsr.do|/gw/systemx/changeUserPositionProc.do|/gw/forwardIndex.do|/gw/bizboxMailEx.do|/gw/getPositionList.do|/gw/cmm/systemx/myInfoManage.do|/gw/cmm/file/fileDownloadProc.do|/gw/cmm/file/fileDownloadProc.do|/gw/cmm/systemx/myInfosaveProc.do|/gw/cmm/file/profileUploadProc.do|/gw/cmm/systemx/orgChartAllEmpInfo.do|/gw/cmm/systemx/orgChartFullListView.do|/gw/cmm/systemx/userProfileInfo.do|/gw/bizboxPasswdChange.do|/gw/uat/uia/passwordCheckPop.do|/gw/uat/uia/passwordChangeCheck.do|/gw/cmm/cmmPage/cmmCheckPop.do|/gw/bizboxPasswdChange.do|/gw/loginPwCheck.do";
			
			if(!mailApiList.contains(requestURL)){
				httpResponse.sendRedirect("/gw/bizboxMailEx.do");
				chain.doFilter(request, response);
				return;
			}
		}
		
		if(requestURL.contains("/MsgLogOn")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/ExtLogOn")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/FMLogOn")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/outLogOn")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/outLogOnPass")) {
			chain.doFilter(request, response);
			return;
		}
		
		
		if(requestURL.contains("/outProssLogOn")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/outProcessLogOn")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/bizboxSW")) {
			chain.doFilter(request, response);
			return;
		}
		

		if(requestURL.contains("/SetGerpSession")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/reLogonProc")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(requestURL.contains("/oneffice.do")) {
			if(tempVO == null && httpRequest.getHeader("bizboxa-oneffice-token") != null) {
				chain.doFilter(request, response);
				return;
			}
		}
		
		if(requestURL.contains("/CustLogOn")) {
			chain.doFilter(request, response);
			return;
		}
		
		
		//이차인증 로그인에따른 파라미터 처리
		if(httpRequest.getParameter("isScLogin") != null && httpRequest.getParameter("isScLogin").equals("Y")){
			session.setAttribute("ScTargetEmpSeq", "Y");
		}
		
		if(tempVO != null && session.getAttribute("isLocallyAuthenticated") == null){

			loginVO = tempVO;
			
			//세션 로그인 
			session.setAttribute("loginVO", loginVO);
			session.removeAttribute("masterLogon");
			
			//로컬 인증결과 세션에 저장
			session.setAttribute("isLocallyAuthenticated", "true");
			//스프링 시큐리티 로그인 
			Map<String, Object> springParam = new HashMap<String, Object>();
			String springSecurityKey = UUID.randomUUID().toString().replace("-", "").substring(6);
			springParam.put("empSeq", loginVO.getUniqId());
			springParam.put("springSecurityKey", springSecurityKey + "USER");
			springParam.put("groupSeq", loginVO.getGroupSeq());
			try {
				loginService.updateSpringSecuKey(springParam);
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			String springSecuCompSeq = loginVO.getOrganId() == null ? "_" : loginVO.getOrganId();
			String springSecuDeptSeq = loginVO.getOrgnztId() == null ? "_" : loginVO.getOrgnztId();
			String compAccessDomain = request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());
			
			String uri = httpRequest.getContextPath() + "/j_spring_security_check?j_username=USER$" + springSecuCompSeq + "$" + springSecuDeptSeq + "$" + loginVO.getGroupSeq() + "$" + loginVO.getGroupSeq() + springSecurityKey + "$" + CommonUtil.getClientIp(request) + "$" + compAccessDomain + "&j_password=" + loginVO.getUniqId();
			httpResponse.sendRedirect(uri);
			
			return;
		}
		/** MsgLogOn 끝 **/
		
		
		if (session != null) {
			isRemotelyAuthenticated = (String)session.getAttribute("isRemotelyAuthenticated");
			LoginVO sessionLoginVO = (LoginVO)session.getAttribute("loginVO");
			
//			System.out.println("#### sessionLoginVO : " + sessionLoginVO);

			/** loginVO session 저장하기 
			 *  actionLogin 통해 로그인을 했더라도 loginVO에는 간략한 정보만 가지고 있음
			 *  j_spring_security_check 타야지만 그외정보(compSeq,groupSeq 등) 조회
			 *  따라서 loginVO에서 유효성 체크하고 false 일때 인증받은 loginVO로 셋팅한다.
			 * */
			if (sessionLoginVO != null && loginVO != null && !EgovStringUtil.isEmpty(loginVO.getId())
					&& !EgovStringUtil.isEmpty(loginVO.getUserSe())
					&& !EgovStringUtil.isEmpty(loginVO.getGroupSeq())
					&& !EgovStringUtil.isEmpty(loginVO.getCompSeq())
					&& loginVO != sessionLoginVO) {

				session.setAttribute("loginVO", loginVO);
			}

		}
		
		String paramUserID = httpRequest.getParameter("id") ;
		if (requestURL.contains("/uat/uia/actionLogin") && loginVO != null && !EgovStringUtil.isEmpty(paramUserID) ) {
			if (  !loginVO.getId().equals(paramUserID) ) {
				EgovUserDetailsHelper.reSetAuthenticatedUser() ;
				//session.invalidate();
			}
		}

		
		//스프링 시큐리티 인증이 처리 되었는지 EgovUserDetailsHelper.getAuthenticatedUser() 메서드를 통해 확인한다.
		//context-common.xml 빈 설정에 egovUserDetailsSecurityService를 등록 해서 사용해야 정상적으로 동작한다.
		if(EgovUserDetailsHelper.getAuthenticatedUser() == null){
			
			if(isRemotelyAuthenticated != null && isRemotelyAuthenticated.equals("true")){
				try{
					//세션 토큰 정보를 가지고 DB로부터 사용자 정보를 가져옴
					loginVO = (LoginVO)session.getAttribute("loginVOForDBAuthentication");				
					loginVO = loginService.actionLoginByEsntlId(loginVO);
					
					if(loginVO != null && loginVO.getId() != null && !loginVO.getId().equals("")){				
						//세션 로그인 
						session.setAttribute("loginVO", loginVO);
						session.removeAttribute("masterLogon");
						
						//로컬 인증결과 세션에 저장
						session.setAttribute("isLocallyAuthenticated", "true");
						//스프링 시큐리티 로그인 
						Map<String, Object> springParam = new HashMap<String, Object>();
						String springSecurityKey = UUID.randomUUID().toString().replace("-", "").substring(6);
						springParam.put("empSeq", loginVO.getUniqId());
						springParam.put("springSecurityKey", springSecurityKey + "USER");
						springParam.put("groupSeq", loginVO.getGroupSeq());
						loginService.updateSpringSecuKey(springParam);
						
						String compAccessDomain = request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());
						String uri = httpRequest.getContextPath() + "/j_spring_security_check?j_username=USER$_$_$" + loginVO.getGroupSeq() + "$" + loginVO.getGroupSeq() + springSecurityKey + "$" + CommonUtil.getClientIp(request) + "$" + compAccessDomain + "&j_password=" + loginVO.getUniqId();
						httpResponse.sendRedirect(uri);
						return;
					}
					
				}catch(Exception ex){
					//DB인증 예외가 발생할 경우 로그를 남기고 로컬인증을 시키지 않고 그대로 진행함.
					LOG.debug("Local authentication Fail : " + ex.getMessage());
					RequestDispatcher dispatcher = httpRequest.getRequestDispatcher( loginURL);
					dispatcher.forward(httpRequest, httpResponse);
					
					chain.doFilter(request, response);							
					return;		
				}
				
			}else if(isRemotelyAuthenticated == null){
				if(requestURL.contains("/uat/uia/actionLogin")){
					
					String nativeLangCode = "kr";
					
					if(session.getAttribute("nativeLangCode") != null) {
						nativeLangCode = session.getAttribute("nativeLangCode").toString();
					}
					
					session.setAttribute("isLoginPage", "Y");
					
					if(CommonCodeSpecific.getHttpsYN().equals("Y") && !request.isSecure()) {
						httpResponse.sendRedirect(loginURL);
						return ;
					}

					loginVO = new LoginVO();
				    
			    	// BASE64 Des
			    	try{

			    		String loginParamEncType = BizboxAProperties.getCustomProperty("BizboxA.Cust.LoginParamEncType");
			    		String inputLoginId = httpRequest.getParameter("id") + httpRequest.getParameter("id_sub1") + httpRequest.getParameter("id_sub2");
			    		
			    		//21년 11월 24일 이지케어텍 고객사에서 패스워드 암호화 처리 관련 요청 사항 처리
			    		//요청 사항: 
			    		// 1. 기존 암호화 키보다 더 복잡한 키 적용 요청
			    		// 2. JSP 파일에 암호화 키를 하드코딩이 아닌 서버에서 내려주는 방식으로 처리
			    		String ezcaretechYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.ezcaretechYn");
			    		
			    		if(loginParamEncType.equals("BASE64")) {
			        		loginVO.setId(new String(org.apache.commons.codec.binary.Base64.decodeBase64(inputLoginId.getBytes("UTF-8")), "UTF-8"));
			        		loginVO.setPassword(new String(org.apache.commons.codec.binary.Base64.decodeBase64(httpRequest.getParameter("password").getBytes("UTF-8")), "UTF-8"));
			    		}else if(loginParamEncType.equals("NONE")) {
			        		loginVO.setId(inputLoginId);
			        		loginVO.setPassword(httpRequest.getParameter("password"));    			
			    		}else {
			    			Boolean completeKeyFlag = ezcaretechYn.equals("Y") ? true : false;
			    			
			        		loginVO.setId(AESCipher.AES128SCRIPT_Decode(inputLoginId, completeKeyFlag));
		        			loginVO.setPassword(AESCipher.AES128SCRIPT_Decode(httpRequest.getParameter("password"), completeKeyFlag));  
			        			
			    		}			    		
			    		
			    	}catch(Exception e){
			    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			    	}				    
				    
			    	loginVO.setUserSe("USER");
			    	loginVO.setGroupSeq(httpRequest.getSession().getAttribute("loginGroupSeq")+"");
			    	
			    	if(httpRequest.getParameter("groupSeq") != null && httpRequest.getParameter("groupSeq").length() > 0){
			    		//클라우드 로그인시 사용자입력한 그룹아이디는
			    		//그룹시퀀스가아닌 모바일아이디를 입력받는 형식으로 jedis에서 모바일ID로 DB정보 조회 후 셋팅.
			    		JedisClient jedis = CloudConnetInfo.getJedisClient();
			    		Map<String, Object> dbInfo = jedis.getParamMapByMobileId(httpRequest.getParameter("groupSeq"));
			    		if(dbInfo != null){
			    			
			    			//개통상태체크
			    			if(!dbInfo.get("OPERATE_STATUS").equals("20")) {
			    				if(dbInfo.get("OPERATE_STATUS").equals("0")) {
			    					httpRequest.setAttribute("message", BizboxAMessage.getMessage("","클라우드 서비스 개통대기 상태입니다. 관리자에게 문의해주세요.", nativeLangCode));
			    				}else if(dbInfo.get("OPERATE_STATUS").equals("10")) {
			    					httpRequest.setAttribute("message", BizboxAMessage.getMessage("","클라우드 서비스 개통중 상태입니다. 관리자에게 문의해주세요.", nativeLangCode));
			    				}else if(dbInfo.get("OPERATE_STATUS").equals("19")) {
			    					httpRequest.setAttribute("message", BizboxAMessage.getMessage("","클라우드 서비스 개통완료 상태입니다. 관리자에게 문의해주세요.", nativeLangCode));
			    				}else if(dbInfo.get("OPERATE_STATUS").equals("30")) {
			    					httpRequest.setAttribute("message", BizboxAMessage.getMessage("","클라우드 서비스 일시정지 상태입니다. 관리자에게 문의해주세요.", nativeLangCode));
			    				}else if(dbInfo.get("OPERATE_STATUS").equals("90")) {
			    					httpRequest.setAttribute("message", BizboxAMessage.getMessage("","클라우드 서비스 점검 상태입니다. 관리자에게 문의해주세요.", nativeLangCode));
			    				}else {
			    					httpRequest.setAttribute("message", BizboxAMessage.getMessage("TX800000032","클라우드 서비스 중지 상태입니다. 관리자에게 문의해주세요.", nativeLangCode));
			    				}
								RequestDispatcher dispatcher = httpRequest.getRequestDispatcher(loginURL);
								dispatcher.forward(httpRequest, httpResponse);
								chain.doFilter(request, response);
								return;			    				
			    			}
			    			
			    			httpRequest.getSession().setAttribute("scGroupSeq", dbInfo.get("GROUP_SEQ").toString());
			    			loginVO.setGroupSeq(dbInfo.get("GROUP_SEQ").toString());
			    		}
			    		else{
			    			httpRequest.getSession().setAttribute("scGroupSeq", "");
			    			loginVO.setGroupSeq("");
			    		}
			    	}
			    	
					try {
						Map<String, Object> loginMp = new HashMap<String, Object>();
						loginMp.put("loginId", loginVO.getId());
						loginMp.put("groupSeq", loginVO.getGroupSeq());
						
						// 아이디 존재 여부 확인 및 로그인 통제 옵션 값
				    	boolean loginIdExistCheck = loginService.loginIdExistCheck(loginMp); 
				    	
				    	// 로그인 block 상태
				    	String loginStatus = null;
				    	String loginId = null;
				    	
						
				    	if(loginIdExistCheck) { // 아이디가 존재
				    		loginId = loginVO.getId();
				    		loginStatus = loginService.loginOptionResult(loginMp);
				    	}
				    	
				    	//Null Pointer 역참조
				    	if(loginStatus != null && (loginStatus.contains("block") || loginStatus.equals("longTerm"))) {
				    		loginVO = null;
				    	} else {
				    		loginVO = loginService.actionLogin(loginVO, httpRequest);
				    	}

						if(loginVO != null && loginVO.getId() != null && !loginVO.getId().equals("")){
							
							httpRequest.getSession().setAttribute("scUserPwd", httpRequest.getParameter("password"));
							
							//접속기록 저장
							LoginLog loginLog = new LoginLog();
							loginLog.setLoginId(loginVO.getUniqId());
							
					        String clientIp = CommonUtil.getClientIp(request);

							//MASTER 패스워드로 로그인 시
							if(loginVO.getPassword() != null && loginVO.getPassword().equals("MASTER")){
								session.setAttribute("masterLogon", "Y");
							}else{
								loginLog.setLoginIp(clientIp);
								loginLog.setLoginMthd("WEB_LOGIN");
								loginLog.setErrOccrrAt("N");
								loginLog.setErrorCode("");
								loginLog.setGroupSeq(loginVO.getGroupSeq());
								loginLogService.logInsertLoginLog(loginLog);
								
								session.removeAttribute("masterLogon");
							}
							//  접근 대역 IP가 아니라면 VO에 abnormalApproach 셋팅
							if(loginVO.getIp() != null && loginVO.getIp().equals("abnormalApproach")){
								httpRequest.setAttribute("message", "접속 할 수 없는 IP대역 입니다.그룹웨어 관리자 에게 문의하세요.");
								RequestDispatcher dispatcher = httpRequest.getRequestDispatcher(loginURL);
								dispatcher.forward(httpRequest, httpResponse);
								return;
							}
							//세션 로그인 
							session.setAttribute("loginVO", loginVO);
							
							//옵션정보
							Map<String, Object> mp = new HashMap<String, Object>();
					    	mp.put("groupSeq", loginVO.getGroupSeq());
					    	mp.put("compSeq", loginVO.getOrganId());
							
							Map<String, Object> optionSet = loginService.selectOptionSet(mp);
							session.setAttribute("optionSet", optionSet);
							session.setAttribute("langCode", loginVO.getLangCode());
							
							//로컬 인증결과 세션에 저장
							session.setAttribute("isLocallyAuthenticated", "true");
							//스프링 시큐리티 로그인 
							Map<String, Object> springParam = new HashMap<String, Object>();
							String springSecurityKey = UUID.randomUUID().toString().replace("-", "").substring(6);
							springParam.put("empSeq", loginVO.getUniqId());
							springParam.put("springSecurityKey", springSecurityKey + "USER");
							springParam.put("groupSeq", loginVO.getGroupSeq());
							loginService.updateSpringSecuKey(springParam);
							

							//로그인 로그(운영일경우에만 처리)
							if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
					        	ActionDTO action = new ActionDTO(EnumActionStep1.Login, EnumActionStep2.ActionNone, EnumActionStep3.ActionNone);
					
					    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
					    		creatorInfo.setEmpSeq(loginVO.getUniqId());
					    		creatorInfo.setCompSeq(loginVO.getOrganId());
					    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
					    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
					    		
					    		JSONObject actionID = new JSONObject();
					    		actionID.put("emp_seq", loginVO.getUniqId());
					    		
					    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_LOGIN, creatorInfo, action, actionID, clientIp, EnumDevice.Web);
					    	}
							
							String compAccessDomain = request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());
							
							String uri = httpRequest.getContextPath() + "/j_spring_security_check?j_username=USER$_$_$" + loginVO.getGroupSeq() + "$" + loginVO.getGroupSeq() + springSecurityKey + "$" + clientIp + "$" + compAccessDomain + "&j_password=" + loginVO.getUniqId();
							httpResponse.sendRedirect(uri);
						}else{
							
							if(loginStatus != null && loginStatus.contains("block")) {//Null Pointer 역참조
								
								String[] blockInfo = loginStatus.split("\\|");
								
								if(blockInfo.length > 1 && !blockInfo[1].equals("0")) {
									httpRequest.setAttribute("message", BizboxAMessage.getMessage("TX800000033","로그인 실패 횟수 초과로 잠금 처리되었습니다.", nativeLangCode) + "\n" + blockInfo[1] + BizboxAMessage.getMessage("TX800000034","분 후 재시도해주세요.", nativeLangCode));
								}else {
									httpRequest.setAttribute("message", BizboxAMessage.getMessage("TX800000033","로그인 실패 횟수 초과로 잠금 처리되었습니다.", nativeLangCode) + "\n" + BizboxAMessage.getMessage("", "하단의 비밀번호 찾기 메뉴를 통해 비밀번호 초기화 후 이용 가능하며 \n 이후에도 로그인 불가시 관리자에게 문의하시기 바랍니다.", nativeLangCode));
								}
								
							}else if(loginStatus != null && loginStatus.equals("longTerm")) {//Null Pointer 역참조
								httpRequest.setAttribute("message", BizboxAMessage.getMessage("TX800000035","장기간 미접속으로 잠금처리되었습니다.", nativeLangCode) + BizboxAMessage.getMessage("TX000018544","관리자에게 문의하시기 바랍니다.", nativeLangCode));
							} else {
								httpRequest.setAttribute("message", BizboxAMessage.getMessage("TX000020302","로그인 정보가 올바르지 않습니다.", nativeLangCode));
								
								// 로그인 실패 카운트 증가
								if(loginIdExistCheck && !loginStatus.equals("block")) { // 아이디가 존재
									Map<String, Object> mp = new HashMap<String, Object>();
									mp.put("loginId", loginId);
									mp.put("groupSeq", loginMp.get("groupSeq"));
									
									loginService.updateLoginFailCount(mp);
						    	}
								
							}
					    
							//사용자 정보가 없는 경우 로그인 화면으로 redirect 시킴
							RequestDispatcher dispatcher = httpRequest.getRequestDispatcher( loginURL);
							dispatcher.forward(httpRequest, httpResponse);
							request.setAttribute("isBlock", true);
							chain.doFilter(request, response);
							
							return;							
						}
	
					} catch (Exception ex) {
						//DB인증 예외가 발생할 경우 로그인 화면으로 redirect 시킴
						httpRequest.setAttribute("message", BizboxAMessage.getMessage("TX000020302","로그인 정보가 올바르지 않습니다.", nativeLangCode));
						RequestDispatcher dispatcher = httpRequest.getRequestDispatcher(loginURL);
						dispatcher.forward(httpRequest, httpResponse);
						chain.doFilter(request, response);
						return;
					}
					return;		
				}

			}
		}
		chain.doFilter(request, response);
		return;
	}

	public void init(FilterConfig filterConfig) throws ServletException {

		this.config = filterConfig;
		
	}

}
