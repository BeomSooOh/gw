package restful.mullen.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import egovframework.com.sym.log.clg.service.LoginLog;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.OutAuthentication;
import net.sf.json.JSONObject;
import restful.mobile.service.RestfulService;
import restful.mobile.vo.GroupInfoVO;
import restful.mobile.vo.RestfulRequest;
import restful.mobile.vo.RestfulRequestHeader;
import restful.mobile.vo.RestfulVO;
import restful.mobile.vo.ResultVO;
import restful.mullen.constants.ConstantBiz;
import restful.mullen.service.MullenFriendService;
import restful.mullen.service.MullenService;
import restful.mullen.util.MullenUtil;
import restful.mullen.vo.MullenAuthStatus;
import restful.mullen.vo.MullenLoginResponse;
import restful.mullen.vo.MullenLoginVO;
import restful.mullen.vo.MullenUser;

@Controller
@RequestMapping("/mullen")
public class MullenController {
	private Logger logger = Logger.getLogger(MullenController.class);
	
	@Resource(name = "loginService")
    private EgovLoginService loginService;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="EmpManageService")
	EmpManageService empManageService;
	
	@Resource(name="OrgAdapterService")
	OrgAdapterService orgAdapterService;
	
	@Resource(name="MullenService")
	MullenService mullenService;
	
	@Resource(name="MullenFriendService")
	MullenFriendService mullenFriendService;
	
	@Resource(name="RestfulService")
	private RestfulService restfulService;
	
	@Resource(name="LdapAdapterService")
	public LdapAdapterService ldapManageService;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	/*
	 * post 호출 및 json 응답
	 * 로그인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/loginMullen", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public MullenLoginResponse getMullenLogin(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		MullenLoginResponse loginResponse  = new MullenLoginResponse();
		Map<String, Object> reBody =  request.getBody();
		
		logger.debug("/loginMullen Request Body: " + JSONObject.fromObject(reBody).toString());
		
		String outApiAuthentication = BizboxAProperties.getCustomProperty("BizboxA.Cust.outApiAuthentication");
		String sEnpassYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLogin");
		String sLdapLogonYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapLogon");
		String sLdapUseYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapUseYn");
		String groupSeq = (String) reBody.get("groupSeq");
		String loginId = (String) reBody.get("loginId");
		String loginPassword = (String) reBody.get("loginPassword");
		String enpassword = "";
		String osType = (String) reBody.get("osType");
		String appType = (String) reBody.get("appType");
		String token = (String) reBody.get("token");
		String appVer = (String) reBody.get("appVer");
		String programCd = (String) reBody.get("programCd");
		String model = (String) reBody.get("model");
		String deviceRegId = reBody.get("deviceRegId") == null ? "" : reBody.get("deviceRegId").toString();
		String appConfirmYn = "N";
		
		String tId = (String)  (request.getHeader()).gettId();
		loginResponse.settId(tId);
		
		String buildType = CloudConnetInfo.getBuildType();
		
		if( groupSeq == null || groupSeq.length() == 0 || 
				loginId == null  || loginId.length() == 0 ||
				loginPassword == null || loginPassword.length() == 0 ) {

			MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
			logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
			return loginResponse;
		}
		///////////////////////////////////////// 멀린 로그인 관련 추가_20181218 /////////////////////////
		//로그인 아이디가 이메일이면 계정등록 완료됐는지 판단후  login_id 조회후 세팅
		MullenAuthStatus mullenAuthStatus = null;
		if(MullenUtil.validateEmailAddr(loginId)) {//로그인 아이디가 이메일 이면
			HashMap<String, Object> params = new HashMap<>();
			String[] emailAddrs = loginId.split("@");
			params.put("groupSeq", groupSeq);
			params.put("outMail", emailAddrs[0]);
			params.put("outDomain", emailAddrs[1]);
			params.put("emailYn", "Y");
			mullenAuthStatus = mullenService.getAuthStatus(params);
		}else {//로그인 아이디가 멀린코드이면
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", groupSeq);
			params.put("empSeq", loginId);
			params.put("emailYn", "N");
			mullenAuthStatus = mullenService.getAuthStatus(params);
		}
		if(mullenAuthStatus == null || (mullenAuthStatus != null && "Y".equals(mullenAuthStatus.getEmailYn()) && !ConstantBiz.MULLEN_AUTH_STATUS_400.equals(mullenAuthStatus.getStatus()))) {
			MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
			logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
			return loginResponse;
		}
		boolean isAccountRegistYn = ConstantBiz.MULLEN_AUTH_STATUS_400.equals(mullenAuthStatus.getStatus());
		String emailLoginYn = mullenAuthStatus.getEmailYn();
		String emailAddr = "";
		if("Y".equals(emailLoginYn)) {
			emailAddr = loginId;
			loginId = mullenAuthStatus.getEmpSeq();
		}
		//////////////////////////////////// 멀린 추가 //////////////////////////////////////////////
		
		//외부 API인증 체크
		if(!outApiAuthentication.equals("99")) {
			
			if(OutAuthentication.outApiAuthentication(loginId, loginPassword)) {
				outApiAuthentication = "▦";
			}
			
		}		
		
		if(outApiAuthentication.equals("▦")) {
			
			enpassword = "▦";
			
		}else if (sEnpassYn.equals("Y") && !loginId.equals(BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassAdmin"))) {
			if (!OutAuthentication.checkUserAuthSW(loginId, loginPassword)) {
				String errCode = "LOGIN000";
				
				MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", errCode);
				logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
				return loginResponse;
			}
			else {
				enpassword = "▦";
			}
		}
		else if(sLdapUseYn.equals("Y") && !loginId.equals(BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapAdmin"))){
			Map<String, Object> ldapParam = new HashMap<String, Object>();
    		ldapParam.put("groupSeq", groupSeq);
    		ldapParam.put("loginId", loginId);
    		ldapParam.put("loginPasswd", loginPassword);
    		Map<String, Object> ldapResult = ldapManageService.ldapAuthCheck(ldapParam);
    		
    		if(sLdapLogonYn.equals("Y")){
        		if(ldapResult != null && ldapResult.get("resultCode").equals("SUCCESS")){
        			enpassword = "▦";
        		}else{
    				String errCode = "LOGIN000";
    				MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", errCode);
    				logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
    				return loginResponse;	
        		}    			
    		}else{
    			enpassword = CommonUtil.passwordEncrypt(loginPassword);	
    		}
		}
		else{
			enpassword  = CommonUtil.passwordEncrypt(loginPassword);	
		}
		
		MullenLoginVO restVO = new MullenLoginVO();
		restVO.setGroupSeq(groupSeq);
		restVO.setLoginId(loginId);
		restVO.setLoginPassword(enpassword);
		
		try {
			
			// 아이디 존재 여부 확인 및 로그인 통제 옵션 값
			Map<String, Object> loginMp = new HashMap<String, Object>();
			loginMp.put("loginId", loginId);
			loginMp.put("groupSeq", groupSeq);
			
	    	boolean loginIdExistCheck = loginService.loginIdExistCheck(loginMp); 
	    	
	    	// 로그인 block 상태
	    	String loginStatus = null;
	    	String loginIdCheck = null;
			
	    	if(loginIdExistCheck) { // 아이디가 존재
	    		loginIdCheck = loginId;
	    		loginMp.put("loginId", loginIdCheck);
	    		loginStatus = loginService.loginOptionResult(loginMp);
	    	}else{
	    		MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
	    		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
	    		return loginResponse;	
	    	}			
	    	
	    	if(loginStatus.contains("block")) {
	    		MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN002");
	    		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
				return loginResponse;	
	    	}else if(loginStatus.equals("longTerm")) {
	    		loginResponse.setResultCode("LOGIN008");
	    		loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000115","장기간 미접속으로 잠금처리되었습니다. 관리자에게 문의하시기 바랍니다."));
	    		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
				return loginResponse;
	    	}	    	
	    	
	    	if (!enpassword.equals("▦") && !sEnpassYn.equals("Y") && !sLdapLogonYn.equals("Y")) {
				String strLoginPassword = mullenService.selectLoginPassword(restVO);

				if(strLoginPassword == null || strLoginPassword.equals("") || !strLoginPassword.equals(enpassword)){			
					MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
					
					// 로그인 실패 카운트 증가
					if(loginIdExistCheck) { // 아이디가 존재
						loginService.updateLoginFailCount(loginMp);
			    	}	
					logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
					return loginResponse;			
				}
	    	}
			
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<MullenLoginVO> pckgList = mullenService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				List<Map<String,Object>> loginVOList = mullenService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);
					restVO.setCompanyList(loginVOList);
					restVO.setBuildType(buildType);
					
					//멀린관련 추가
					if("Y".equals(emailLoginYn)) {
						//restVO.setLoginIdEmail(emailAddr);
						restVO.setLoginId(emailAddr);
					}else {
						//restVO.setLoginIdCode(loginId);
					}
					restVO.setAccountRegistYn(isAccountRegistYn ? "Y" : "N");
					
					/** 하이브리드웹 서버에서 사용될 정보 */
					restVO.setLoginCompanyId(restVO.getCompSeq());
					restVO.setLoginUserId(restVO.getLoginId());
					restVO.setAppVer(appVer);
					restVO.setOsType(osType);
					restVO.setAppType(appType);
					restVO.setProgramCd(programCd);
					restVO.setModel(model);

					
					//사용자권한 존재여부 체크					
					Map<String, Object> authParam = new HashMap<String, Object>();
					authParam.put("groupSeq", restVO.getGroupSeq());
					authParam.put("compSeq", restVO.getCompSeq());
					authParam.put("deptSeq", restVO.getDeptSeq());
					authParam.put("empSeq", restVO.getEmpSeq());
					
					Map<String, Object> authMap = (Map<String, Object>) commonSql.select("restDAO.selectEmpAuthList", authParam);
					if(authMap == null || authMap.get("empAuth") == null || authMap.get("empAuth").equals("")){
						loginResponse.setResultCode("UC0000");
						loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
						logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
						return loginResponse;
					}
					
					//업무보고 근무시간, 모바일 출근체크 사용여부 (임시로 공통코드에 사용유무값 셋팅)
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("groupSeq", restVO.getGroupSeq());					
					Map<String, Object> optionMap = (Map<String, Object>) commonSql.select("restDAO.selectExtOptionList", params);
					
					restVO.setUseReportAttendTime(optionMap.get("useReportAttendTime") == null ? "N" : (String)optionMap.get("useReportAttendTime"));
					restVO.setUseMobileWorkCheck(optionMap.get("useMobileWorkCheck") == null ? "N" : (String)optionMap.get("useMobileWorkCheck"));
					
					
					// 전자결재 암호 입력 사용 여부
					/*
					String pwdCode = CommonCodeUtil.getCodeName("APVPWD", "ISPWD") ; 
					if(EgovStringUtil.isEmpty(pwdCode)) {
						pwdCode = "1" ; //결재시 비밀번호 체크
					}
					*/
					String pwdCode = "0";
					if(restVO.getApprPasswd().length() > 0) {
						pwdCode = "1";
					}
					
					restVO.setPassword_yn(pwdCode); // 결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
					//restVO.setEaType("0");      // 전자결재 타입( 0: NP, 1: suite )					
					
					Map<String,Object> pa = new HashMap<String,Object>();
					pa.put("ip", BizboxAProperties.getProperty("BizboxA.Mqtt.ip"));
					pa.put("port", BizboxAProperties.getProperty("BizboxA.Mqtt.port"));
					restVO.setMqttInfo(pa); 
					 
					loginResponse.setResult(restVO);
					Map<String,Object> p = new HashMap<String,Object>();
					
					for(Map<String,Object> map : loginVOList) {
						/* 회사로고 이미지 */
						p.put("groupSeq", groupSeq);
						p.put("orgSeq", map.get("compSeq"));
						p.put("osType", osType);
						p.put("appType", appType);

						List list = restfulService.selectOrgImgList(p);

						map.put("logoData",list);
					}
					
					/** 모듈 url 정보 */
					p.put("groupSeq", groupSeq);
					p.put("eaType", restVO.getEaType());
					p.put("empSeq", restVO.getEmpSeq());
					p.put("passwdStatusCode", restVO.getPasswdStatusCode());
					p.put("passwdDate", restVO.getPasswdDate());
					Map<String,Object> groupMap = orgChartService.getGroupInfo(p);
					if (groupMap != null) {

						GroupInfoVO groupVO = new GroupInfoVO();
						groupVO.setSmsUrl(EgovStringUtil.nullConvert(groupMap.get("smsUrl")+""));
						groupVO.setMobileUrl(EgovStringUtil.nullConvert(groupMap.get("mobileUrl")+""));
						groupVO.setEdmsUrl(EgovStringUtil.nullConvert(groupMap.get("edmsUrl")+""));
						groupVO.setMailUrl(EgovStringUtil.nullConvert(groupMap.get("mailUrl")+""));
						groupVO.setMessengerUrl(EgovStringUtil.nullConvert(groupMap.get("messengerUrl")+""));
						
						String manualUrl = EgovStringUtil.nullConvert(groupMap.get("manualUrl")+"");
						
						String manualUrlKr = "";
						String manualUrlEn = "";
						String manualUrlJp = "";
						String manualUrlCn = "";
						
						if(!manualUrl.equals("")){
							manualUrlKr = manualUrl + "/user/ko/mobile";
						}
						Map<String, Object> manualMp = new HashMap<String, Object>();
						manualMp.put("kr", manualUrlKr);
						manualMp.put("en", manualUrlEn);
						manualMp.put("jp", manualUrlJp);
						manualMp.put("cn", manualUrlCn);
						
						groupVO.setManualUrl(manualMp);
						
						restVO.setGroupInfo(groupVO);
					}
					
					/** 2017.01.02 장지훈 추가(옵션값 가져오기) */
					List<Map<String, Object>> optionList = restfulService.selectOptionListMobile(p);
					
					restVO.setOptionList(optionList);
					
					LoginLog loginLog = new LoginLog();
					loginLog.setLoginId(restVO.getEmpSeq());
					
					String ipAddress = "";
					
					if(reBody.get("ipAddress") != null && !reBody.get("ipAddress").equals("")){
						ipAddress = (String) reBody.get("ipAddress");
					}
					
					/* 비밀번호 설정규칙 값 추가 */
					/*
					 * I : 최초로그인
					 * C : 옵션 변경
					 * P : 통과
					 * D : 만료기간
					 * T : 안내기간 
					 * */
					restVO.setPasswdStatusCode(restfulService.getPasswdStatusCode(p));
					
					Map<String, Object> passwdResult = new HashMap<String, Object>();
					Map<String, Object> passwdOptions = new HashMap<String, Object>();
					String langCode = restVO.getNativeLangCode();
					String content = "";
					String title = "";
					
					if(restVO.getPasswdStatusCode().equals("P")) {
						title = BizboxAMessage.getMessage("TX800000116","로그인 성공");
						content = BizboxAMessage.getMessage("TX800000104","정상적으로 로그인 되었습니다.");
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
						
						//이차인증 관련 정보 셋팅
						Map<String, Object> paraMp = new HashMap<String, Object>();	    
					    paraMp.put("groupSeq", groupSeq);
					    paraMp.put("empSeq", restVO.getEmpSeq());
					    Map<String, Object> secondCertInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", paraMp);
						
					    
					    if(secondCertInfo.get("useYn").toString().equals("Y")){
						    //이차인증 범위가 WEB만 사용하는 경우는 체크하지않음.
						    //이차인증범위     range : W(WEB), M(App),  A(Web+Messenger_App)
						    String devType = "1";
						    if(!secondCertInfo.get("range").toString().equals("W")){

								if(secondCertInfo.get("scMobileUseYn").equals("Y")){														
								    						    
								    //디바이스 등록 대상 여부
								    List<Map<String, Object>> devList = commonSql.list("SecondCertManage.selectSecondCertDeviceList", paraMp);
								    
								    if(deviceRegId.equals("") || (devList.size() == 0 && (secondCertInfo.get("scWebUseYn").equals("Y") || secondCertInfo.get("scMobileUseYn").equals("Y")))){
								    	if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && deviceRegId.equals("") && (devList.size() == 0 || ((Map<String, Object>)devList.get(0)).get("appConfrimCnt").toString().equals("0")) && secondCertInfo.get("range").toString().equals("M")){
											//app최초로그인인증처리사용여부(appConfirmYn)옵션값에 따른 자동기기등록 처리
								    		appConfirmYn = "Y";
								    		
								    		Map<String, Object> devRegInfo = setDevRegInfo(request, restVO);
								    		deviceRegId = devRegInfo.get("oriDeviceRegId") + "";
								    		devRegInfo.remove("oriDeviceRegId");
								    		restVO.setDevRegInfo(devRegInfo);
								    		
								    		restVO.setUseTwoFactorAuthenticationYn("N"); 
								    		restVO.setUseDeviceRegYn("N");
								    	}else{
								    		if(!deviceRegId.equals("") && devList.size() != 0){
								    			restVO.setUseDeviceRegYn("Y");
								    			loginResponse.setResultCode("LOGIN007");
								    			loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
								    		}else{
									    		restVO.setUseDeviceRegYn("Y");
										    	restVO.setUseTwoFactorAuthenticationYn("N");									    	
										    	loginResponse.setResultCode("LOGIN003");
												loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000118","이차인증 기기등록 후 로그인 가능합니다."));
								    		}
								    	}
								    }else if(devList.size() > 0 && (secondCertInfo.get("scWebUseYn").equals("Y") || secondCertInfo.get("scMobileUseYn").equals("Y"))){
								    	String status = "";						    	
								    	for(Map<String, Object> mp : devList){
								    		if(mp.get("deviceNum").equals(deviceRegId)){
								    			status = mp.get("status") + "";
								    			devType = mp.get("type") + "";
								    			break;
								    		}
								    	}
								    	
								    	//이차인증 웹 사용여부
										if(devType.equals("1")) {
											restVO.setUseTwoFactorAuthenticationYn(secondCertInfo.get("scWebUseYn") + "");
										}
										else {
											restVO.setUseTwoFactorAuthenticationYn("N");
										}
								    	
								    	
								    	if(status.equals("P")){
						    				restVO.setUseDeviceRegYn("N");
						    			}else if(status.equals("R")){
						    				restVO.setUseDeviceRegYn("Y");
						    				loginResponse.setResultCode("LOGIN004");
						    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000119","승인요청 중인 이차인증 기기입니다."));
						    			}else if(status.equals("D")){
						    				restVO.setUseDeviceRegYn("Y");
						    				loginResponse.setResultCode("LOGIN005");
						    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000120","승인요청이 반려된 이차인증 기기입니다."));
						    			}else if(status.equals("C")){
						    				
						    				if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && devType.equals("2") && secondCertInfo.get("range").toString().equals("M")){
						    					restVO.setUseDeviceRegYn("N");
						    					restVO.setAppConfirmYn("N");
							    				loginResponse.setResultCode("LOGIN009");
							    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000121","해지된 인증기기입니다. 모바일 앱 재설치 후 사용가능합니다."));
							    				logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
							    				return loginResponse;
						    				}else{
						    					restVO.setUseDeviceRegYn("Y");
							    				loginResponse.setResultCode("LOGIN006");
							    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000122","해지된 이차인증 기기입니다."));
						    				}
						    			}else{
							    			restVO.setUseDeviceRegYn("Y");
							    			loginResponse.setResultCode("LOGIN007");
							    			loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
							    		}
								    }else{
								    	restVO.setUseDeviceRegYn("N");
								    }
								    
								    if(restVO.getUseDeviceRegYn().equals("Y")){
								    	loginResponse.setResult(restVO);
								    	logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
								    	return loginResponse;
								    }			
								}else{
									restVO.setUseTwoFactorAuthenticationYn("N");
									restVO.setUseDeviceRegYn("N");
								}
						    }else{
						    	restVO.setUseTwoFactorAuthenticationYn("N");
								restVO.setUseDeviceRegYn("N");
						    }
					    }else{
					    	restVO.setUseTwoFactorAuthenticationYn("N");
							restVO.setUseDeviceRegYn("N");
					    }
					    
					    restVO.setAppConfirmYn(appConfirmYn);
					    
					    //이차인증 통과 기기의경우 token정보 저장
					    if(restVO.getUseTwoFactorAuthenticationYn().equals("Y") && restVO.getUseDeviceRegYn().equals("N")){
					    	Map<String, Object> scMap = new HashMap<String, Object>();
					    	scMap.put("groupSeq", groupSeq);
					    	scMap.put("empSeq", restVO.getEmpSeq());
					    	scMap.put("deviceNum", deviceRegId);
					    	scMap.put("token", token);
					    	
					    	commonSql.update("SecondCertManage.updateDeviceTokenInfo", scMap);
					    }
						
					} else if(restVO.getPasswdStatusCode().equals("I")) {
						title = BizboxAMessage.getMessage("TX000022472", "최초 로그인 비밀번호 변경 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000105", "그룹웨어에 처음 로그인 하셨습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서버스가 이용 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("C")) {
						title = BizboxAMessage.getMessage("TX000022593", "비밀번호 설정규칙 변경 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000106", "시스템관리자에 의해 비밀번호 설정규칙이 변경되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("D")) {
						title = BizboxAMessage.getMessage("", "비밀번호 만료 안내", langCode);
						content = BizboxAMessage.getMessage("", "비밀번호가 만료되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("R")) {
						title = BizboxAMessage.getMessage("TX000022591", "비밀번호 재설정 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000108", "시스템관리자에 의해 비밀번호가 초기화되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					}
					
					/* 옵션 값 데이터 */
					passwdOptions = getPasswordOption(restVO);
					
					if(passwdOptions != null) {
						passwdResult.put("passwdOption", passwdOptions);
					}
					
					
					restVO.setPasswdStatus(passwdResult);
					
					loginLog.setLoginIp(ipAddress);
					loginLog.setLoginMthd("MOBILE_LOGIN");
					loginLog.setErrOccrrAt("N");
					loginLog.setErrorCode("");	
					loginLog.setGroupSeq(restVO.getGroupSeq());
					
					commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
					commonSql.update("EmpManageService.initPasswordFailcount", p);
					
					loginResponse.setResultCode("SUCCESS");
					loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
					
					//별도앱 인증을 위한 토큰정보 저장
					try{
						if(token != null && !token.equals("")){
							p.put("groupSeq", groupSeq);
							p.put("empSeq", restVO.getEmpSeq());
							p.put("osType", osType);
							p.put("appType", appType);
							p.put("token", token);
							empManageService.initToken(p);
						}						
					} catch (Exception e) {
						loginResponse.setResultCode("TOKEN0000");
						loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000123","토큰 저장 시 문제가 발생하였습니다."));						
					}					
					
				}else{
					loginResponse.setResultCode("UC0000");
					loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
					MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				loginResponse.setResultCode("UC0000");
				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
			}
		} catch (Exception e) {
			logger.error("API 목록 조회 중 에러 : " + e.getMessage());
			loginResponse.setResultCode("LOGIN001");
			loginResponse.setResultMessage(BizboxAMessage.getMessage("","로그인시 문제가 발생하였습니다."));
		}
		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
		return loginResponse;		
	}
	/*
	 * post 호출 및 json 응답
	 * 인증메일 전송
	 * 0. 이메일 유효성 판단
	 * 1. 이메일 DB등록 (T_CO_EMP [out_mail, out_domain]
	 * 2. 인증메일 템플릿 생성 
	 * 3. 인증메일 전송
	 */
	@RequestMapping(value="/sendAuthEmail", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO sendAuthEmail(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/sendAuthEmail Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/sendAuthEmail Request Body: " + JSONObject.fromObject(reBody).toString());
		
		//Validation
		if(!validateForSendAuthEmail(reBody, response)) {
			logger.debug("/sendAuthEmail Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", (String)reBody.get("groupSeq"));
			params.put("empSeq", (String)reBody.get("loginIdCode"));
			String emailAddr = (String)reBody.get("emailAddr");
			params.put("emailAddr", emailAddr);
			String[] emailAddrs = emailAddr.split("@");
			
			params.put("outMail", emailAddrs[0]);
			params.put("outDomain", emailAddrs[1]);
			params.put("resourcePath", servletRequest.getSession().getServletContext().getRealPath(""));
			
			//인증메일 전송처리 (이메일 DB 등록, 인증메일 템플릿 생성, 인증메일 전송)
			if(mullenService.processSendAuthEmail(params)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("TX800000143","인증메일 전송 실패"));
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		logger.debug("/sendAuthEmail Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	private boolean validateForSendAuthEmail(Map<String, Object> reBody, ResultVO response) {
		
		if(!reBody.containsKey("groupSeq")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [groupSeq] in body");
			return false;
		}
		if(!reBody.containsKey("loginIdCode")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [loginIdCode] in body");
			return false;
		}
		if(!reBody.containsKey("emailAddr")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [emailAddr] in body");
			return false;
		}
		String emailAddr = (String) reBody.get("emailAddr");
		
		//이메일 유효성 검사
		if(!reBody.containsKey("emailAddr") || StringUtils.isBlank(emailAddr) || !MullenUtil.validateEmailAddr(emailAddr)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("TX800000144","유효하지 않은 이메일 입니다."));
			return false;
		}
		
		return true;
	}
	/*
	 * post 호출 및 json 응답
	 * 인증 메일 확인
	 */
	@RequestMapping(value="/confirmAuthEmail", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO confirmAuthEmail(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/confirmAuthEmail Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/confirmAuthEmail Request Body: " + JSONObject.fromObject(reBody).toString());
		
		//Validation
		if(!validateForConfirmAuthEmail(reBody, response)) {
			logger.debug("/confirmAuthEmail Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", (String)reBody.get("groupSeq"));
			params.put("loginIdCode", (String)reBody.get("loginIdCode"));
			params.put("emailAddr", (String)reBody.get("emailAddr"));
			
			//인증 메일 확인 처리
			boolean isSuccess = mullenService.processConfirmAuthEmail(params);
			
			if(isSuccess) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));	
			}else {
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("TX800000145","인증실패"));
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/confirmAuthEmail Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	private boolean validateForConfirmAuthEmail( Map<String, Object> reBody, ResultVO response) {
		if(!reBody.containsKey("groupSeq")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [groupSeq] in body");
			return false;
		}
		if(!reBody.containsKey("loginIdCode")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [loginIdCode] in body");
			return false;
		}
		if(!reBody.containsKey("emailAddr")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [emailAddr] in body");
			return false;
		}
		return true;
	}
	/*
	 * post 호출 및 json 응답
	 * 계정등록 처리
	 */
	@RequestMapping(value="/registAccount", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO registAccount(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		//Validation
		if(!validateForRegistAccount( reBody, response)) {
			logger.debug("/registAccount Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", (String)reBody.get("groupSeq"));
			params.put("loginIdCode", (String)reBody.get("loginIdCode"));
			params.put("empSeq", (String)reBody.get("loginIdCode"));
			params.put("emailAddr", (String)reBody.get("emailAddr"));
			params.put("newName", (String)reBody.get("userName"));
			params.put("password", (String)reBody.get("password"));
			params.put("passwordConfirm", (String)reBody.get("passwordConfirm"));
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			//계정 등록 처리.
			boolean isSuccess = mullenService.processRegistAccount(params, response);
			
			if(isSuccess) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));	
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		logger.debug("/registAccount Response: " + JSONObject.fromObject(response).toString());
		
		return response;		
	}
	private boolean validateForRegistAccount( Map<String, Object> reBody,
			ResultVO response) {
		if(!reBody.containsKey("groupSeq")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [groupSeq] in body");
			return false;
		}
		if(!reBody.containsKey("loginIdCode")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [loginIdCode] in body");
			return false;
		}
		if(!reBody.containsKey("userName")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [userName] in body");
			return false;
		}
		String userName = (String) reBody.get("userName");
		if(StringUtils.isBlank(userName)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("EMPTY[userName]");
			return false;
		}
		if(!reBody.containsKey("emailAddr")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [emailAddr] in body");
			return false;
		}
		String emailAddr = (String) reBody.get("emailAddr");
		if(!MullenUtil.validateEmailAddr(emailAddr)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("TX800000146","이메일 형식이 아닙니다."));
			return false;
		}
		if(!reBody.containsKey("password")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [password] in body");
			return false;
		}
		if(!reBody.containsKey("passwordConfirm")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [passwordConfirm] in body");
			return false;
		}
		String password = (String) reBody.get("password");
		String passwordConfirm = (String) reBody.get("passwordConfirm");
		if(!password.equals(passwordConfirm)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("password != passwordConfirm");
			return false;
		}
		//사용자 비밀번호 변경 API와 패스워드 정책 맞춰야함.
		if(!MullenUtil.validationPasswd(password)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("최소6 자리 이상 12 자리 이하로 입력해 주세요.\\n영문(소문자),숫자를 포함해 주세요.");
			return false;
		}
		return true;
	}
	/*
	 * post 호출 및 json 응답
	 * 사용자명 변경
	 */
	@RequestMapping(value="/modifyUserName", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO modifyUserName(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/modifyUserName Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/modifyUserName Request Body: " + JSONObject.fromObject(reBody).toString());
		
		//Validation
		if(!validateForModifyUserName(reBody, response)) {
			logger.debug("/modifyUserName Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", (String)reBody.get("groupSeq"));
			params.put("empSeq", (String)reBody.get("loginIdCode"));
			params.put("newName", (String)reBody.get("newName"));
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			
			logger.debug("MullenController modifyUserName body: " + reBody);
			
			//사용자명 변경 로직
			if(mullenService.modifyUserName(params) > 0) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("TX800000147","존재하지 않는 사용자"));
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		logger.debug("/modifyUserName Response: " + JSONObject.fromObject(response).toString());
		
		return response;		
	}
	//사용자명 유효성 판단.
	private boolean validateForModifyUserName(Map<String, Object> reBody, ResultVO response) {
		
		if(!reBody.containsKey("loginIdCode")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [loginIdCode]");
			return false;
		}
		
		if(!reBody.containsKey("newName")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [newName]");
			return false;
		}
		
		String newName = (String) reBody.get("newName");
		
		if(StringUtils.isBlank(newName)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("TX800000148","유효하지 않은 사용자명 입니다."));
			return false;
		}
		
		return true;
	}
	
	/* 
	 * 정규식 확인 메서드
	 * 
	 * */
	public boolean fnRegExpression(Pattern regExpression, String modPass) {
		Matcher match = regExpression.matcher(modPass);
		
		boolean result = match.find();
		
		return result;
	}
	/* 핸드폰 번호 정규화 */
	public static String phoneFormat(String phoneNo){
		  
	   if (phoneNo.length() == 0){
	    return phoneNo;
	      }
	   
	      String strTel = phoneNo;
	      String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043",
	                           "051", "052", "053", "054", "055", "061", "062",
	                           "063", "064", "010", "011", "012", "013", "015",
	                           "016", "017", "018", "019", "070", "050"};
	      
	      if (strTel.length() < 9) {
	          return strTel;
	      } else if (strTel.substring(0,2).equals(strDDD[0])) {
	          strTel = strTel.substring(0,2) + '-' + strTel.substring(2, strTel.length()-4)
	               + '-' + strTel.substring(strTel.length() -4, strTel.length());
	      } else if(strTel.substring(0, 3).equals(strDDD[26])){
	    	  strTel = strTel.substring(0,4) + '-' + strTel.substring(4, strTel.length()-4)
	                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
	      } else {
	          for(int i=1; i < strDDD.length; i++) {
	              if (strTel.substring(0,3).equals(strDDD[i])) {
	                  strTel = strTel.substring(0,3) + '-' + strTel.substring(3, strTel.length()-4)
	                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
	              }
	          }
	      }
	      return strTel;
	 }
	
	private Map<String, Object> setDevRegInfo(RestfulRequest request, MullenLoginVO restVO) {
		
		Map<String, Object> reBody =  request.getBody();
		
		Map<String, Object> devRegInfo = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("groupSeq", restVO.getGroupSeq());	
		
		String deviceRegId = commonSql.select("MsgDAO.getToken", params) + "";
		deviceRegId = deviceRegId.replaceAll("-", "");

		devRegInfo.put("oriDeviceRegId", deviceRegId);
		
		params.put("deviceNum", deviceRegId);
		params.put("empSeq", restVO.getEmpSeq());
		params.put("compSeq", restVO.getCompSeq());
		params.put("devType", "2");
		params.put("status", "P");
		params.put("appType", reBody.get("appType"));
		params.put("osType", reBody.get("osType"));
		params.put("deviceName", "My Device");
		params.put("deviceNickName", "");
		params.put("desc", "");
		params.put("tken", reBody.get("token"));
		
		//인증기기등록 처리
		commonSql.insert("SecondCertManage.insertSecondCertDeviceInfo", params);
		
				
		Map<String, Object> keyMap = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertKeyNum", params);
		String keyNum =  keyMap.get("keyNum") + "";
		
		params.put("keyNum", keyNum);
		Map<String, Object> keyInfoMap = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertKey", params);
		
		//디바이스ID 복호화
		deviceRegId = AESCipher.AES256_Encode(deviceRegId, keyInfoMap.get("key").toString());
		
		devRegInfo.put("deviceRegId", deviceRegId);
		devRegInfo.put("kNum", keyNum);
		
		return devRegInfo;
	}

	public Map<String, Object> getPasswordOption(MullenLoginVO restVO) {
		Map<String, Object> result = new HashMap<String, Object>();
	
		String passwdOptionUseYN = "";
		String inputDigitValue = "";
		String inputRuleValue = "";
		String inputLimitValue = "";
		String inputDueOptionValue = "";
		String inputAlertValue = "";
		String inputDueValue = "";
		String inputBlockTextValue = "";
		
		/* 결과 오류 변수 선언 */
		String inputDigitResult = "";
		String inputRuleResult = "";
		String inputLimitResult = "";
		String inputDueValueResult = "";
	
		
		/* 비밀번호 옵션 체크 */
		/* 옵션 확인 */
		try{
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("option", "cm20");
			mp.put("groupSeq", restVO.getGroupSeq());
			List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);
			
			
			for(Map<String, Object> temp : loginOptionValue) {
				// 비밀번호 설정규칙 사용 여부
				if(temp.get("optionId").equals("cm200")) {
					if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
						passwdOptionUseYN = "N";
						break;
					} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
						passwdOptionUseYN = "Y";
					}
				}
				
				// 비밀번호 만료 일자
				if(temp.get("optionId").equals("cm201")) {
					
    				String cm201Val = temp.get("optionRealValue").toString();
    				
        			if(cm201Val != null && !cm201Val.equals("")){
        				
        				if(cm201Val.split("▦").length > 1) {
        					inputDueOptionValue = inputDueValue.split("▦")[0];
        					inputDueValue = inputDueValue.split("▦")[1];
        				}
        				
	    				//안내기간, 만료기간 고도화 처리 (수정예정)
	    				String[] cm201Array = inputDueValue.split("\\|");
	    				if(cm201Array.length > 1){
	    					inputAlertValue = cm201Array[0];
	    					inputDueValue = cm201Array[1];
	    				}else{
	    					inputDueValue = cm201Array[0];
	    				}
        			}
				}
				
				// 비밀번호 입력 자리수 설정
				if(temp.get("optionId").equals("cm202")) {
					inputDigitValue = temp.get("optionRealValue").toString();
				}
				
				// 입력규칙값
				if(temp.get("optionId").equals("cm203")) {
					inputRuleValue = temp.get("optionRealValue").toString();
				}
	
				// 입력제한값
				if(temp.get("optionId").equals("cm204")) {
					inputLimitValue = temp.get("optionRealValue").toString();
				}
				
				// 입력제한단어
				if(temp.get("optionId").equals("cm205")) {
					inputBlockTextValue = temp.get("optionRealValue").toString();
				}    			
				
			}
			
			// 비밀번호 설정 옵션값 체크
			if(passwdOptionUseYN.equals("Y")) {
				// 자릿수 설정
				if(!inputDigitValue.equals("")) {
					String[] digit = inputDigitValue.split("\\|");
					
					if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){
					
						String min = digit[0];
						String max = digit[1];
						
						if(max.equals("0")) {
							max = "16";
						}
						
						String minStr = BizboxAMessage.getMessage("TX000010842","최소");
						String maxStr = BizboxAMessage.getMessage("TX000002618","최대");
						inputDigitResult = minStr + " " + min + " / " + maxStr + " " + max;
					}
				}
				
				if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {			// 입력 규칙값 미사용
					// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
					if(inputRuleValue.indexOf("0") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)") + ",";
					} 
					
					if(inputRuleValue.indexOf("1") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)") + ",";
					}
					
					if(inputRuleValue.indexOf("2") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자") + ",";
					}
					
					if(inputRuleValue.indexOf("3") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자") + ",";
					}
				}
				
    			if(inputDueOptionValue.equals("m")) {
    				inputDueValueResult = BizboxAMessage.getMessage("","매월") + " "	+ inputAlertValue + BizboxAMessage.getMessage("","일 만료(종료)");    				
    			}else {
        			if(!inputDueValue.equals("0")) {
        				inputDueValueResult = inputDueValue + BizboxAMessage.getMessage("TX000000437","일");
        			} else {
        				inputDueValueResult = BizboxAMessage.getMessage("TX000004167","제한없음");
        			}
    			}
				
				if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {
					
					inputLimitValue = "|" + inputLimitValue + "|";
					
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("empSeq", restVO.getEmpSeq());
					params.put("groupSeq", restVO.getGroupSeq());
					params.put("langCode", restVO.getNativeLangCode());
					params.put("compSeq", restVO.getCompSeq());
					
					/* 사용자 정보 가져오기 */
		    		// 사원 정보 (비밀번호 변경 옵션 값에 필요)
		    		Map<String, Object> infoMap = empManageService.selectEmpInfo(params, new PaginationInfo());
		    		List<Map<String,Object>> list = (List<Map<String, Object>>) infoMap.get("list");
		    		Map<String,Object> map = list.get(0);
		    		
					
					// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전비밀번호, 6:키보드일련배열
					if(inputLimitValue.indexOf("|0|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디") + ",";
					}
					
					if(inputLimitValue.indexOf("|1|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번") + ",";
					}
					
					if(inputLimitValue.indexOf("|2|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화") + ",";
					} 
					
					if(inputLimitValue.indexOf("|3|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일") + ",";
					}
					
					if(inputLimitValue.indexOf("|4|") > -1) {
						
						String termLength = "";
						
						if(inputLimitValue.indexOf("|4_3|") > -1) {
							termLength = "3자리 ";
						}else if(inputLimitValue.indexOf("|4_4|") > -1) {
							termLength = "4자리 ";
						}else if(inputLimitValue.indexOf("|4_5|") > -1) {
							termLength = "5자리 ";
						}
						
			    		inputLimitResult += termLength + BizboxAMessage.getMessage("","연속문자") + ",";
			    		inputLimitResult += termLength + BizboxAMessage.getMessage("","반복문자") + ",";
					}
	
					if(inputLimitValue.indexOf("|5|") > -1) {
			    		inputLimitResult += BizboxAMessage.getMessage("","직전 비밀번호") + ",";
					}
					
					if(inputLimitValue.indexOf("|6|") > -1) {
			    		inputLimitResult += BizboxAMessage.getMessage("","키보드 일련배열") + ",";
					}					
				}
				
				if(!inputBlockTextValue.equals("")){
					inputLimitResult += BizboxAMessage.getMessage("","추측하기 쉬운단어") + ",";
				}
				
				result.put("useOption" , "Y");
			} else if(passwdOptionUseYN.equals("N")) {
	    		result.put("useOption" , "N");
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		if(inputDigitResult.length() > 0) {
			result.put("inputDigitResult", inputDigitResult);
		} else {
			result.put("inputDigitResult", "");
		}
		
		if(inputRuleResult.length() > 0) {
			result.put("inputRuleResult", inputRuleResult.substring(0, inputRuleResult.length() -1));
		} else {
			result.put("inputRuleResult", "");
		}
		
		if(inputLimitResult.length() > 0) {
			result.put("inputLimitResult", inputLimitResult.substring(0, inputLimitResult.length() -1));
		} else {
			result.put("inputLimitResult", "");
		}
		
		if(inputDueValueResult.length() > 0) {
			result.put("inputDueValueResult", inputDueValueResult);
		} else {
			result.put("inputDueValueResult", "");
		}
		
		return result;
	}

	@RequestMapping(value="/loginToken", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public MullenLoginResponse getLoginListToken(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		MullenLoginResponse response  = new MullenLoginResponse();
		Map<String, Object> reBody =  request.getBody();
		
		logger.debug("/loginMullen Request Body: " + JSONObject.fromObject(reBody).toString());
		
		String groupSeq = (String) reBody.get("groupSeq");
		String osType = (String) reBody.get("osType");
		String appType = (String) reBody.get("appType");
		String token = (String) reBody.get("token");
		String appVer = (String) reBody.get("appVer");
		String programCd = (String) reBody.get("programCd");
		String model = (String) reBody.get("model");		
		
		String tId = (String)  (request.getHeader()).gettId();
		response.settId(tId);
		
		String buildType = CloudConnetInfo.getBuildType();
		
		if( groupSeq == null || groupSeq.equals("") || token == null  || token.equals("")) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN000");
			logger.debug("/loginMullen Response: " + JSONObject.fromObject(response).toString());
			return response;
		}		
		
		MullenLoginVO restVO = new MullenLoginVO();
		restVO.setGroupSeq(groupSeq);
		
		if(token != null){
			restVO.setLoginToken(token);	
		}
		
		try {
			
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<MullenLoginVO> pckgList = mullenService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				List<Map<String,Object>> loginVOList = mullenService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);
					restVO.setCompanyList(loginVOList);
					restVO.setBuildType(buildType);
					
					/**
					 * 멀린 관련 추가_20181220
					 */
					HashMap<String, Object> params = new HashMap<>();
					params.put("groupSeq", groupSeq);
					params.put("empSeq", restVO.getLoginIdCode());
					params.put("emailYn", "N");
					MullenAuthStatus mullenAuthStatus = mullenService.getAuthStatus(params);
					boolean isAccountRegistYn = ConstantBiz.MULLEN_AUTH_STATUS_400.equals(mullenAuthStatus.getStatus());
					restVO.setAccountRegistYn(isAccountRegistYn ? "Y" : "N");
					
					/** 하이브리드웹 서버에서 사용될 정보 */
					restVO.setLoginCompanyId(restVO.getCompSeq());
					restVO.setLoginUserId(restVO.getLoginId());
					restVO.setAppVer(appVer);
					restVO.setOsType(osType);
					restVO.setAppType(appType);
					restVO.setProgramCd(programCd);
					restVO.setModel(model);
			
					String pwdCode = "0";
					if(restVO.getApprPasswd().length() > 0) {
						pwdCode = "1";
					}
					
					restVO.setPassword_yn(pwdCode); // 결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
					
					Map<String,Object> pa = new HashMap<String,Object>();
					pa.put("ip", BizboxAProperties.getProperty("BizboxA.Mqtt.ip"));
					pa.put("port", BizboxAProperties.getProperty("BizboxA.Mqtt.port"));
					restVO.setMqttInfo(pa); 
					 
					response.setResult(restVO);
					Map<String,Object> p = new HashMap<String,Object>();
					
					for(Map<String,Object> map : loginVOList) {
						/* 회사로고 이미지 */
						p.put("groupSeq", groupSeq);
						p.put("orgSeq", map.get("compSeq"));
						p.put("osType", osType);
						p.put("appType", appType);

						List list = restfulService.selectOrgImgList(p);
						map.put("logoData",list);
					}
					
					/** 모듈 url 정보 */
					p.put("groupSeq", groupSeq);
					p.put("eaType", restVO.getEaType());
					p.put("empSeq", restVO.getEmpSeq());
					p.put("passwdDate", restVO.getPasswdDate());
					Map<String,Object> groupMap = orgChartService.getGroupInfo(p);
					if (groupMap != null) {

						GroupInfoVO groupVO = new GroupInfoVO();
						groupVO.setSmsUrl(EgovStringUtil.nullConvert(groupMap.get("smsUrl")+""));
						groupVO.setMobileUrl(EgovStringUtil.nullConvert(groupMap.get("mobileUrl")+""));
						groupVO.setEdmsUrl(EgovStringUtil.nullConvert(groupMap.get("edmsUrl")+""));
						groupVO.setMailUrl(EgovStringUtil.nullConvert(groupMap.get("mailUrl")+""));
						groupVO.setMessengerUrl(EgovStringUtil.nullConvert(groupMap.get("messengerUrl")+""));
						
						String manualUrl = EgovStringUtil.nullConvert(groupMap.get("manualUrl")+"");
						
						String manualUrlKr = "";
						String manualUrlEn = "";
						String manualUrlJp = "";
						String manualUrlCn = "";
						
						if(!manualUrl.equals("")){
							manualUrlKr = manualUrl + "/user/ko/mobile";
						}
						Map<String, Object> manualMp = new HashMap<String, Object>();
						manualMp.put("kr", manualUrlKr);
						manualMp.put("en", manualUrlEn);
						manualMp.put("jp", manualUrlJp);
						manualMp.put("cn", manualUrlCn);
						
						groupVO.setManualUrl(manualMp);
						
						restVO.setGroupInfo(groupVO);
					}
					
					/** 2017.01.02 장지훈 추가(옵션값 가져오기) */
					List<Map<String, Object>> optionList = restfulService.selectOptionListMobile(p);
					
					restVO.setOptionList(optionList);
					
					LoginLog loginLog = new LoginLog();
					loginLog.setLoginId(restVO.getEmpSeq());
					
					String ipAddress = ((HttpServletRequest)servletRequest).getHeader("X-FORWARDED-FOR"); 
					
					if ( ipAddress == null || ipAddress.length( ) == 0 ) {
						ipAddress = ((HttpServletRequest)servletRequest).getHeader( "Proxy-Client-IP" );
					}
					
					if ( ipAddress == null || ipAddress.length( ) == 0 ) {
						ipAddress = ((HttpServletRequest)servletRequest).getHeader( "WL-Proxy-Client-IP" ); // 웹로직?
					}
					
					//Custom property 값 ProxyAddYn이 "Y"경우 header 값 체크 추가 (proxy 및 모든 l4 대응 방안)
					if(BizboxAProperties.getCustomProperty("BizboxA.ProxyAddYn").equals("Y")) {
						if(ipAddress == null || ipAddress.length( ) == 0) {
							ipAddress = ((HttpServletRequest)request).getHeader( "HTTP_CLIENT_IP" );
						}
						if(ipAddress == null || ipAddress.length( ) == 0) {
							ipAddress = ((HttpServletRequest)request).getHeader( "HTTP_X_FORWARDED_FOR" );
						}
						if(ipAddress == null || ipAddress.length( ) == 0) {
							ipAddress = ((HttpServletRequest)request).getHeader( "X-Real-IP" );
						}
					}
					if ( ipAddress == null || ipAddress.length( ) == 0 ) {
						ipAddress = servletRequest.getRemoteAddr( );
					}
					
					if ( ipAddress == null ) {
						ipAddress = ""; 
					}
					
					/* 비밀번호 설정규칙 값 추가 */
					/*
					 * I : 최초로그인
					 * C : 옵션 변경
					 * P : 통과
					 * D : 만료기간 
					 * */
					Map<String, Object> passwdResult = new HashMap<String, Object>();
					Map<String, Object> passwdOptions = new HashMap<String, Object>();
					String langCode = restVO.getNativeLangCode();
					String content = "";
					String title = "";
					
					if(restVO.getPasswdStatusCode().equals("P")) {
						title = "로그인 성공";
						content = "정상적으로 로그인 되었습니다.";
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("I")) {
						title = BizboxAMessage.getMessage("", "최초 로그인 비밀번호 변경 안내", langCode);
						content = BizboxAMessage.getMessage("", "그룹웨어에 처음 로그인 하셨습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서버스가 이용 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("C")) {
						title = BizboxAMessage.getMessage("", "비밀번호 설정규칙 변경 안내", langCode);
						content = BizboxAMessage.getMessage("", "시스템관리자에 의해 비밀번호 설정규칙이 변경되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("D")) {
						title = BizboxAMessage.getMessage("", "비밀번호 만료 안내", langCode);
						content = BizboxAMessage.getMessage("", "비밀번호가 만료되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					}
					
					/* 옵션 값 데이터 */
					passwdOptions = getPasswordOption(restVO);
					
					if(passwdOptions != null) {
						passwdResult.put("passwdOption", passwdOptions);
					}
					
					restVO.setPasswdStatus(passwdResult);
					loginLog.setLoginIp(ipAddress);
					loginLog.setLoginMthd("MOBILE_TOKEN_LOGIN");
					loginLog.setErrOccrrAt("N");
					loginLog.setErrorCode("");	
					loginLog.setGroupSeq(restVO.getGroupSeq());
					
					commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
					commonSql.update("EmpManageService.initPasswordFailcount", p);
					
					response.setResultCode("SUCCESS");
					response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
					
				}else{
					response.setResultCode("TOKEN0003");
					response.setResultMessage("토큰이 존재하지 않습니다.");
					MessageUtil.setApiMessage(response, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				response.setResultCode("TOKEN0003");
				response.setResultMessage("토큰이 존재하지 않습니다.");
			}
		} catch (Exception e) {
			logger.error("API 목록 조회 중 에러 : " + e.getMessage());
			response.setResultCode("LOGIN001");
			response.setResultMessage(BizboxAMessage.getMessage("","로그인시 문제가 발생하였습니다."));
		}

		logger.debug("/loginMullen Response: " + JSONObject.fromObject(response).toString());
		return response;		
	}
	
	public Map<String, Object> getPasswordOption(RestfulVO restVO) {
		Map<String, Object> result = new HashMap<String, Object>();

		String passwdOptionUseYN = "";
		String inputDigitValue = "";
		String inputRuleValue = "";
		String inputLimitValue = "";
		
		String inputDueOptionValue = "";
		String inputAlertValue = "";
		String inputDueValue = "";
		String inputBlockTextValue = "";
		
		/* 결과 오류 변수 선언 */
		String inputDigitResult = "";
		String inputRuleResult = "";
		String inputLimitResult = "";
		String inputDueValueResult = "";

		
    	/* 비밀번호 옵션 체크 */
    	/* 옵션 확인 */
    	try{
    		Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("option", "cm20");
    		mp.put("groupSeq", restVO.getGroupSeq());
    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);
    		
    		
    		for(Map<String, Object> temp : loginOptionValue) {
    			// 비밀번호 설정규칙 사용 여부
    			if(temp.get("optionId").equals("cm200")) {
    				if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
    					passwdOptionUseYN = "N";
    					break;
    				} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
    					passwdOptionUseYN = "Y";
    				}
    			}
    			
    			// 비밀번호 만료 일자
    			if(temp.get("optionId").equals("cm201")) {
    				String cm201Val = temp.get("optionRealValue").toString();
    				
        			if(cm201Val != null && !cm201Val.equals("")){
        				
        				if(cm201Val.split("▦").length > 1) {
        					inputDueOptionValue = inputDueValue.split("▦")[0];
        					inputDueValue = inputDueValue.split("▦")[1];
        				}
        				
	    				//안내기간, 만료기간 고도화 처리 (수정예정)
	    				String[] cm201Array = inputDueValue.split("\\|");
	    				if(cm201Array.length > 1){
	    					inputAlertValue = cm201Array[0];
	    					inputDueValue = cm201Array[1];
	    				}else{
	    					inputDueValue = cm201Array[0];
	    				}
        			}
    			}
    			
    			// 비밀번호 입력 자리수 설정
    			if(temp.get("optionId").equals("cm202")) {
    				inputDigitValue = temp.get("optionRealValue").toString();
    			}
    			
    			// 입력규칙값
    			if(temp.get("optionId").equals("cm203")) {
    				inputRuleValue = temp.get("optionRealValue").toString();
    			}

    			// 입력제한값
    			if(temp.get("optionId").equals("cm204")) {
    				inputLimitValue = temp.get("optionRealValue").toString();
    			}
    			
    			// 입력제한단어
    			if(temp.get("optionId").equals("cm205")) {
    				inputBlockTextValue = temp.get("optionRealValue").toString();
    			}    			
    			
    		}
    		
    		// 비밀번호 설정 옵션값 체크
    		if(passwdOptionUseYN.equals("Y")) {
    			// 자릿수 설정
				if(!inputDigitValue.equals("")) {
					String[] digit = inputDigitValue.split("\\|");
					
					if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){
					
						String min = digit[0];
						String max = digit[1];
						
						if(max.equals("0")) {
							max = "16";
						}
						
						String minStr = BizboxAMessage.getMessage("TX000010842","최소");
						String maxStr = BizboxAMessage.getMessage("TX000002618","최대");
						inputDigitResult = minStr + " " + min + " / " + maxStr + " " + max;
					}
				}
    			
    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {			// 입력 규칙값 미사용
    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
    				if(inputRuleValue.indexOf("0") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)") + ",";
    				} 
    				
    				if(inputRuleValue.indexOf("1") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)") + ",";
    				}
    				
    				if(inputRuleValue.indexOf("2") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자") + ",";
    				}
    				
    				if(inputRuleValue.indexOf("3") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자") + ",";
    				}
    			}
    			
    			if(inputDueOptionValue.equals("m")) {
    				inputDueValueResult = BizboxAMessage.getMessage("","매월") + " "	+ inputAlertValue + BizboxAMessage.getMessage("","일 만료(종료)");    				
    			}else {
        			if(!inputDueValue.equals("0")) {
        				inputDueValueResult = inputDueValue + BizboxAMessage.getMessage("TX000000437","일");
        			} else {
        				inputDueValueResult = BizboxAMessage.getMessage("TX000004167","제한없음");
        			}
    			}    			
    			
    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {
    				
    				inputLimitValue = "|" + inputLimitValue + "|";
    				
    				Map<String, Object> params = new HashMap<String, Object>();
    				
    				params.put("empSeq", restVO.getEmpSeq());
    				params.put("groupSeq", restVO.getGroupSeq());
    				params.put("langCode", restVO.getNativeLangCode());
    				params.put("compSeq", restVO.getCompSeq());
    				
    				/* 사용자 정보 가져오기 */
    	    		// 사원 정보 (비밀번호 변경 옵션 값에 필요)
    	    		Map<String, Object> infoMap = empManageService.selectEmpInfo(params, new PaginationInfo());
    	    		List<Map<String,Object>> list = (List<Map<String, Object>>) infoMap.get("list");
    	    		Map<String,Object> map = list.get(0);
    	    		
    				
    				// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전비밀번호, 6:키보드일련배열
					if(inputLimitValue.indexOf("|0|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디") + ",";
    				}
					
					if(inputLimitValue.indexOf("|1|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번") + ",";
    				}
					
					if(inputLimitValue.indexOf("|2|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화") + ",";
    				} 
					
					if(inputLimitValue.indexOf("|3|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일") + ",";
    				}
					
					if(inputLimitValue.indexOf("|4|") > -1) {
						
						String termLength = "";
						
						if(inputLimitValue.indexOf("|4_3|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000016780","3자리") + " ";
						}else if(inputLimitValue.indexOf("|4_4|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000016782","4자리") + " ";
						}else if(inputLimitValue.indexOf("|4_5|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000016784","5자리") + " ";
						}
						
			    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022602","연속문자") + ",";
			    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022603","반복문자") + ",";
    				}

					if(inputLimitValue.indexOf("|5|") > -1) {
			    		inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호") + ",";
    				}
					
					if(inputLimitValue.indexOf("|6|") > -1) {
			    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열") + ",";
    				}					
    			}
    			
    			if(!inputBlockTextValue.equals("")){
    				inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어") + ",";
    			}
    			
    			result.put("useOption" , "Y");
    		} else if(passwdOptionUseYN.equals("N")) {
	    		result.put("useOption" , "N");
    		}
    	} catch(Exception e) {
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	if(inputDigitResult.length() > 0) {
    		result.put("inputDigitResult", inputDigitResult);
    	} else {
    		result.put("inputDigitResult", "");
    	}
    	
    	if(inputRuleResult.length() > 0) {
    		result.put("inputRuleResult", inputRuleResult.substring(0, inputRuleResult.length() -1));
    	} else {
    		result.put("inputRuleResult", "");
    	}
    	
    	if(inputLimitResult.length() > 0) {
    		result.put("inputLimitResult", inputLimitResult.substring(0, inputLimitResult.length() -1));
    	} else {
    		result.put("inputLimitResult", "");
    	}
    	
    	if(inputDueValueResult.length() > 0) {
    		result.put("inputDueValueResult", inputDueValueResult);
    	} else {
    		result.put("inputDueValueResult", "");
    	}
		
		return result;
	}
	
	@RequestMapping(value="/logoutToken", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public MullenLoginResponse getLogoutToken(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		Map<String, Object> reBody =  request.getBody();
		
		MullenLoginResponse response  = new MullenLoginResponse();
		
		Map<String,Object> p = new HashMap<String,Object>();
		p.put("groupSeq", (String) reBody.get("groupSeq"));
		p.put("delToken", (String) reBody.get("token"));
		
		if(empManageService.delToken(p)){
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));			
		}else{
			response.setResultCode("TOKEN0001");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000126","토큰 삭제 시 문제가 발생하였습니다."));
		}
		
		return response;

	}
	/*
	 * post 호출 및 json 응답
	 * 패스워드 변경
	 */
	@RequestMapping(value="/UpdateUserPwdNew", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO UpdateUserPwdNew(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,			
								@RequestBody RestfulRequest request
							) throws Exception {
		
		ResultVO resultList  = new ResultVO();

		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/UpdateUserPwdNew Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/UpdateUserPwdNew Request Body: " + JSONObject.fromObject(reBody).toString());
		
		String passwdOptionUseYN = "";
		String inputDigitValue = "";
		String inputRuleValue = "";
		String inputLimitValue = "";
		String inputBlockTextValue = "";
		String regExpression = "";
		
		/* 결과 오류 변수 선언 */
		String inputDigitResult = "";
		String inputRuleResult = "";
		String inputLimitResult = "";
		
		String returnInputRuleResult = "";
		String returnInputLimitResult = "";
		
		
		boolean regExpressionFlag = false;
		boolean passwdSave = false;
		
	
		try {
			LoginVO loginVO = new LoginVO();

			/* 기존 비밀번호 체크 */
			String loginId = (String) reBody.get("loginId");
			String oPWD = (String) reBody.get("oPWD");
			String nPWD = (String) reBody.get("nPWD");
			String groupSeq = (String) reHeader.getGroupSeq();

			/*
			 * 멀린 비밀번호 변경 로직 추가_20190109
			 */
			if(StringUtils.isEmpty(groupSeq)) {
				groupSeq = "Mullen";	
			}
			if(MullenUtil.validateEmailAddr(loginId)) {//로그인 아이디가 이메일 이면 loginId -> empSeq로 변경처리
				HashMap<String, Object> params = new HashMap<>();
				params.put("groupSeq", groupSeq);
				params.put("emailAddr", loginId);
				MullenUser mullenUser = mullenService.getMullenUserInfoByEmailAddr(params);
				if(mullenUser == null || StringUtils.isEmpty(mullenUser.getEmpSeq())) {
					resultList.setResultCode("fail");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000017854","존재하지 않는 사용자 입니다.", "kr"));
					return resultList;
				}else {
					loginId = mullenUser.getEmpSeq();
				}
			}
	        loginVO.setPassword(oPWD);
	        loginVO.setId(loginId);
	        loginVO.setUserSe("USER");
	        loginVO.setGroupSeq(groupSeq);

	        // 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
	    	LoginVO resultVO = loginService.actionLogin(loginVO, servletRequest);
			
	    	String langCode = resultVO.getLangCode();
	    	
	    	// 비밀번호 일치
	    	if(resultVO.getId() != null){
				/* 옵션 확인 */
	    		Map<String, Object> mp = new HashMap<String, Object>();
	    		mp.put("option", "cm20");
	    		mp.put("groupSeq", groupSeq);
	    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);
				
	    		// 메일 싱크를 위한 정보
		    	Map<String, Object> mailParam = new HashMap<String, Object>();
		    	mailParam.put("groupSeq", groupSeq);
		    	mailParam.put("compSeq", resultVO.getOrganId());				
				Map<String, Object> mailInfo = (Map<String, Object>) commonSql.select("EmpManage.getMailInfo", mailParam);
	    		
	    		for(Map<String, Object> temp : loginOptionValue) {
	    			// 비밀번호 설정규칙 사용 여부
	    			if(temp.get("optionId").equals("cm200")) {
	    				if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
	    					passwdOptionUseYN = "N";
	    					break;
	    				} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
	    					passwdOptionUseYN = "Y";
	    				}
	    			}
	    			
	    			// 비밀번호 입력 자리수 설정
	    			if(temp.get("optionId").equals("cm202")) {
	    				inputDigitValue = temp.get("optionRealValue").toString();
	    			}
	    			
	    			// 입력규칙값
	    			if(temp.get("optionId").equals("cm203")) {
	    				inputRuleValue = temp.get("optionRealValue").toString();
	    			}

	    			// 입력제한값
					if(temp.get("optionId").equals("cm204")) {
						inputLimitValue = temp.get("optionRealValue").toString();
					}
					
	    			// 입력제한단어
					if(temp.get("optionId").equals("cm205")) {
						inputBlockTextValue = temp.get("optionRealValue").toString();
					}					
					
	    		}
	    		
	    		Pattern p = null;		// 정규식
	    		
	    		// 비밀번호 설정 옵션값 체크
	    		if(passwdOptionUseYN.equals("Y")) {
	    			
    				if(!inputDigitValue.equals("")) {

    					String[] digit = inputDigitValue.split("\\|");
    					
    					if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){
    					
	    					String min = digit[0];
	    					String max = digit[1];
	    					
	    					if(max.equals("0")) {
	    						max = "16";
	    					}
	    					
	    					if(nPWD.length() < Integer.parseInt(min) || nPWD.length() > Integer.parseInt(max)) {
	    						
	    						inputDigitResult = BizboxAMessage.getMessage("TX000010842","최소") + min + " " + BizboxAMessage.getMessage("TX000022609", "자리 이상") + max + " " + BizboxAMessage.getMessage("TX000022610","자리 이하로 입력해 주세요.");
	    						
	    					}
    					}
    				}	    			
	    			
	    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {
	    				
	    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
	    				if(inputRuleValue.indexOf("0") > -1) {
	    					regExpression = ".*[A-Z]+.*";
	    					
	    					p = Pattern.compile(regExpression);
	    					
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)", langCode) + ",";
	    					}
	    				} 
	    				
	    				if(inputRuleValue.indexOf("1") > -1) {
						regExpression = ".*[a-z]+.*";
	    					
						p = Pattern.compile(regExpression);
						
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleValue.indexOf("2") > -1) {
						regExpression = ".*[0-9]+.*";
	    					
						p = Pattern.compile(regExpression);
						
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleValue.indexOf("3") > -1) {
	    					regExpression = ".*[^가-힣a-zA-Z0-9].*";
	    					
	    					p = Pattern.compile(regExpression);
	    					
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleResult.length() > 0) {
	    					returnInputRuleResult = inputRuleResult.substring(0, inputRuleResult.length() - 1) + BizboxAMessage.getMessage("TX000022611","를 포함해 주세요.");
	    				}
	    			}
	    			
	    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {
	    				
	    				inputLimitValue = "|" + inputLimitValue + "|";
	    				
	    				Map<String, Object> params = new HashMap<String, Object>();
	    				
	    				params.put("empSeq", resultVO.getUniqId());
	    				params.put("groupSeq", resultVO.getGroupSeq());
	    				params.put("langCode", resultVO.getLangCode());
	    				params.put("compSeq", resultVO.getOrganId());
	    				
	    				/* 사용자 정보 가져오기 */
	    	    		// 사원 정보 (비밀번호 변경 옵션 값에 필요)
	    	    		Map<String, Object> infoMap = empManageService.selectEmpInfo(params, new PaginationInfo());
	    	    		List<Map<String,Object>> list = (List<Map<String, Object>>) infoMap.get("list");
	    	    		Map<String,Object> map = list.get(0);
	    				
	    	    		// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전 비밀번호, 6:키보드 일련배열
	    	    		if(inputLimitValue.indexOf("|0|") > -1) {
	    					String loginIdCheck = map.get("loginId").toString();
	    					
	    					if(nPWD.indexOf(loginIdCheck) > -1) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디", langCode) + ",";
	    					}
	    				}
					
	    	    		if(inputLimitValue.indexOf("|1|") > -1) {
	    	    			String erpNum = map.get("erpEmpNum") != null ? map.get("erpEmpNum").toString() : "";
						
	    					if(nPWD.indexOf(erpNum) > -1 && !erpNum.equals("")) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번", langCode) + ",";
	    					}
	    				}
					
	    	    		if(inputLimitValue.indexOf("|2|") > -1) {
	    	    			String phoneNum = map.get("mobileTelNum") != null ? map.get("mobileTelNum").toString().replaceAll("-", "") : "";
	    					
	    	    			String phoneNumPattern = "";
	    	    			String[] phoneArray = null;
	    	    			String middleNum = "";
	    	    			String endNum = "";
						
	    	    			if(!phoneNum.equals("")) {
	    	    				phoneNumPattern = phoneFormat(phoneNum);
	    	    				phoneArray = phoneNumPattern.split("-");
							
								if(phoneArray.length > 2) {
									middleNum = phoneArray[1];
									endNum = phoneArray[2];
								} else if(phoneArray.length == 1 && phoneArray[0].length() > 3){
									middleNum = phoneArray[0];
									endNum = phoneArray[0];
								}
								
								if(!middleNum.equals("") && !endNum.equals("")){
									if(nPWD.indexOf(middleNum) > -1 || nPWD.indexOf(endNum) > -1) {
										inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화", langCode) + ",";
									}
								}								
	    	    			}
	    				} 
					
	    	    		if(inputLimitValue.indexOf("|3|") > -1) {
	    	    			String birthDay = map.get("bday") != null ? map.get("bday").toString() : "0000-00-00";
	    					
							if(!birthDay.equals("0000-00-00")) {
								String[] yearMonthDay = birthDay.split("-");
								String year = yearMonthDay[0];
								String monthDay = yearMonthDay[1] + yearMonthDay[2];
								String residentReg = year.substring(2,4) + monthDay;
								
								if(nPWD.indexOf(year) > -1 || nPWD.indexOf(monthDay) > -1 || nPWD.indexOf(residentReg) > -1) {
									inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일", langCode) + ",";
								}
							}
	    				}
					
	    	    		if(inputLimitValue.indexOf("|4|") > -1) {
	    					int nSamePass1 = 1; //연속성(+) 카운드
		 				    int nSamePass2 = 1; //반복성(+) 카운드
		 				    int blockCnt = 3;
		 				    
		 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
		 				    	blockCnt = 4;
		 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
		 				    	blockCnt = 5;
		 				    }		 				    
		 				    
		 				    for(int j=1; j < nPWD.length(); j++){
		 				    	int tempA = (int) nPWD.charAt(j-1);
		 				    	int tempB = (int) nPWD.charAt(j);
		 				    	
		 				    	if(tempA - (tempB-1) == 0 ) {
		 				    		nSamePass1++;
		 				    	}else{
		 				    		nSamePass1 = 1;
		 				    	}
		 				    	
		 				    	if(tempA - tempB == 0) {
		 				    		nSamePass2++;
		 				    	}else{
		 				    		nSamePass2 = 1;
		 				    	}
		 				    	
		 				    	if(nSamePass1 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리") + " " + BizboxAMessage.getMessage("TX000022602","연속문자", langCode) + ",";
		 				    		break;
		 				    	}
		 				    	
		 				    	if(nSamePass2 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리") + " " + BizboxAMessage.getMessage("TX000022603","반복문자", langCode) + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}
	    	    		
	    	    		if(inputLimitValue.indexOf("|5|") > -1) {
	    	    			if(map.get("prevLoginPasswd").equals(CommonUtil.passwordEncrypt(nPWD))){
	    	    				inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호", langCode) + ",";	
	    	    			}
	    				}	    	    		
	    	    		
	    	    		if(inputLimitValue.indexOf("|6|") > -1 && nPWD.length() > 1) {
	    	    			
	    	    			int nSamePass1 = 1; //연속성(+) 카운드
	    	    			int nSamePass2 = 1; //연속성(-) 카운드
		 				    int blockCnt = 3;
		 				    String keyArray = "`1234567890-=!@#$%^&*()_+qwertyuiopasdfghjkl;'zxcvbnm,./";
		 				    String newPasswdLow = nPWD.toLowerCase();
		 				    
		 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
		 				    	blockCnt = 4;
		 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
		 				    	blockCnt = 5;
		 				    }
		 				    
		 				    for(int j=1; j < newPasswdLow.length(); j++){
		 				    	int tempA = keyArray.indexOf(newPasswdLow.charAt(j-1));
		 				    	int tempB = keyArray.indexOf(newPasswdLow.charAt(j));
		 				    	
		 				    	if(tempA == -1 || tempB == -1){
		 				    		nSamePass1 = 1;
		 				    		nSamePass2 = 1;
		 				    	}else{
		 				    		
		 				    		if((tempB-tempA) == 1){
		 				    			nSamePass1++;
		 				    		}else{
		 				    			nSamePass1 = 1;
		 				    		}
		 				    		
		 				    		if((tempA-tempB) == 1){
		 				    			nSamePass2++;
		 				    		}else{
		 				    			nSamePass2 = 1;
		 				    		}		 				    		
		 				    	}
		 				    	
		 				    	if(nSamePass1 >= blockCnt || nSamePass2 >= blockCnt) {
		 				    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열", langCode) + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}		    	    		
	    			}
	    			
	    			if(!inputBlockTextValue.equals("")){
	    				
	    				inputBlockTextValue = "|" + inputBlockTextValue + "|";
	    				
	    				if(inputBlockTextValue.indexOf("|" + nPWD + "|") != -1){
	    					inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어", langCode) + ",";
	    				}

}		    			
	    			
					if(inputLimitResult.length() > 0) {
						returnInputLimitResult = inputLimitResult.substring(0, inputLimitResult.length() - 1) + BizboxAMessage.getMessage("TX800000127","가 포함되어 있습니다.");
					}	    			
	    			
	    			String result = inputDigitResult + "\n" + returnInputRuleResult + "\n" + returnInputLimitResult;
	    			
	    			if(result.equals("\n\n")) {
	    				passwdSave = true;
	    			} else {
	    				passwdSave = false;
	    			}
	    			
	    			if(passwdSave) {
	    				
	    				Map<String, Object> adapterParam = new HashMap<String,Object>();
	    				adapterParam.put("groupSeq", resultVO.getGroupSeq());
	    				adapterParam.put("callType", "updatePasswd");
	    				adapterParam.put("empSeq", resultVO.getUniqId());
	    				adapterParam.put("compSeq", resultVO.getCompSeq());
	    				adapterParam.put("deptSeq", resultVO.getOrgnztId());
	    				adapterParam.put("createSeq", resultVO.getUniqId());
	    				adapterParam.put("loginPasswdNew", nPWD);	
	    					
	    				Map<String, Object> adapterResult = orgAdapterService.empSaveAdapter(adapterParam);
	    				
		    			if(mailInfo.get("compEmailYn") != null && mailInfo.get("compEmailYn").equals("Y")){
		    				Map<String, Object> params = new HashMap<String, Object>();
		    				params.put("groupSeq", groupSeq);
		    				orgAdapterService.mailUserSync(params);	 		    				
		    			}
	    				
		    			resultList.setResultCode("SUCCESS");
		    			resultList.setResultMessage(BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다", langCode));
	    			} else {
	    				resultList.setResultCode("fail");
		    			resultList.setResultMessage(result.substring(0, result.length()-1));
	    			}
	    			
	    		} else if(passwdOptionUseYN.equals("N")) {
	    			
    				Map<String, Object> adapterParam = new HashMap<String,Object>();
    				adapterParam.put("groupSeq", resultVO.getGroupSeq());
    				adapterParam.put("callType", "updatePasswd");
    				adapterParam.put("empSeq", resultVO.getUniqId());
    				adapterParam.put("compSeq", resultVO.getCompSeq());
    				adapterParam.put("deptSeq", resultVO.getOrgnztId());
    				adapterParam.put("createSeq", resultVO.getUniqId());
    				adapterParam.put("loginPasswdNew", nPWD);	
    					
    				Map<String, Object> adapterResult = orgAdapterService.empSaveAdapter(adapterParam);
	    			
	    			if(mailInfo.get("compEmailYn") != null && mailInfo.get("compEmailYn").equals("Y")){
	    				Map<String, Object> params = new HashMap<String, Object>();
	    				params.put("groupSeq", groupSeq);
	    				orgAdapterService.mailUserSync(params);	    				
	    			}
	    			
	    			resultList.setResultCode("SUCCESS");
	    			resultList.setResultMessage(BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다", langCode));

	    		}
	    		
			} else {		// 비밀번호 불일치
				resultList.setResultCode("fail");
				resultList.setResultMessage(BizboxAMessage.getMessage("TX000004152","기존 비밀번호가 일치하지 않습니다.", langCode));
			}
	    	
	    	
	    	
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			resultList.setResultCode("CO0000");
			resultList.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return resultList;		
	}
	/*
	 * post 호출 및 json 응답
	 * 1명 입사 처리
	 * 개발자 전용 API
	 
	@RequestMapping(value="/addEmp", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO addEmp(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			
			//입사 처리
			String resultCode = mullenService.processAddEmp(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
			
			response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		return response;		
	}
	
	 * post 호출 및 json 응답
	 * 대량입사 처리
	 * 개발자 전용 API
	 
	@RequestMapping(value="/addBulkEmp", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO addBulkEmp(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("filePath", reBody.get("filePath"));
			
			//대량 입사 처리
			String resultCode = mullenService.processAddBulkEmp(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
			
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		return response;		
	}
	
	 * post 호출 및 json 응답
	 * 1명 삭제 처리
	 * 개발자 전용 API
	 
	@RequestMapping(value="/delEmp", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO delEmp(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			
			//삭제 처리
			String resultCode = mullenService.processDelEmp(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
			
			response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		return response;		
	}
	
	 * post 호출 및 json 응답
	 * 대량삭제 처리
	 * 개발자 전용 API
	 
	@RequestMapping(value="/delBulkEmp", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO delBulkEmp(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("filePath", reBody.get("filePath"));
			
			//대량 삭제 처리
			String resultCode = mullenService.processDelBulkEmp(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
			
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		return response;		
	}
	
	 * post 호출 및 json 응답
	 * t_co_mullen 테이블에서 my_group_id가 null인 사용자 가져와서 myGroup생성 API 호출후 해당 사용자 myGroupId 업데이트
	 * 개발자 전용 API
	 
	@RequestMapping(value="/modifyMyGroupId", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO modifyMyGroupId(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			
			//테이블에서 my_group_id가 null인 사용자 가져와서 myGroup생성 API 호출후 해당 사용자 myGroupId 업데이트
			mullenService.processModifyMyGroupId(params);
			
			response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		return response;		
	}
	*/
	/*
	 * post 호출 및 json 응답
	 * 친구요청
	 */
	@RequestMapping(value="/reqFriend", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO reqFriend(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/reqFriend Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/reqFriend Request Body: " + JSONObject.fromObject(reBody).toString());
		
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("oppoEmpSeq", reBody.get("oppoEmpSeq"));
			
			//친구요청 호출
			String resultCode = mullenFriendService.processReqFriend(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/reqFriend Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	/*
	 * post 호출 및 json 응답
	 * 받은신청목록
	 */
	@RequestMapping(value="/recvReqList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse recvReqList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/recvReqList Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/recvReqList Request Body: " + JSONObject.fromObject(reBody).toString());
		
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			
			//받은신청목록 호출
			HashMap<String, Object> resultObj = mullenFriendService.getRecvReqList(params);
			
			String resultCode = (String) resultObj.get("resultCode");
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				HashMap<String, Object> resultMap = new HashMap<>();
				resultMap.put("list", resultObj.get("resultList"));
				response.setResult(resultMap);
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/recvReqList Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	/*
	 * post 호출 및 json 응답
	 * 보낸신청목록
	 */
	@RequestMapping(value="/sendReqList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse sendReqList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/sendReqList Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/sendReqList Request Body: " + JSONObject.fromObject(reBody).toString());
		
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			
			//보낸신청목록 호출
			HashMap<String, Object> resultObj = mullenFriendService.getSendReqList(params);
			
			String resultCode = (String) resultObj.get("resultCode");
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				HashMap<String, Object> resultMap = new HashMap<>();
				resultMap.put("list", resultObj.get("resultList"));
				response.setResult(resultMap);
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/sendReqList Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	/*
	 * post 호출 및 json 응답
	 * 보낸신청취소
	 */
	@RequestMapping(value="/cancelSendReq", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO cancelSendReq(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/cancelSendReq Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/cancelSendReq Request Body: " + JSONObject.fromObject(reBody).toString());
		
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("cancelEmpSeq", reBody.get("cancelEmpSeq"));
			
			//보낸신청취소 호출
			String resultCode = mullenFriendService.processCancelSendReq(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/cancelSendReq Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	/*
	 * post 호출 및 json 응답
	 * 친구거절
	 */
	@RequestMapping(value="/rejectRecvReq", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO rejectRecvReq(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/rejectRecvReq Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/rejectRecvReq Request Body: " + JSONObject.fromObject(reBody).toString());
		
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("rejectEmpSeq", reBody.get("rejectEmpSeq"));
			
			//친구거절 호출
			String resultCode = mullenFriendService.processRejectRecvReq(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/rejectRecvReq Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	/*
	 * post 호출 및 json 응답
	 * 친구수락 (수락버튼 클릭 및 QR코드 친구추가요청시 호출됨)
	 */
	@RequestMapping(value="/acceptFriend", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO acceptFriend(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/acceptFriend Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/acceptFriend Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("oppoEmpSeq", reBody.get("oppoEmpSeq"));
			params.put("acceptType", reBody.get("acceptType"));
			
			//친구수락 호출
			String resultCode = mullenFriendService.processAcceptFriend(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/acceptFriend Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	/*
	 * post 호출 및 json 응답
	 * 친구삭제
	 */
	@RequestMapping(value="/removeFriend", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO removeFriend(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/removeFriend Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/removeFriend Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("oppoEmpSeq", reBody.get("oppoEmpSeq"));
			
			//친구삭제 호출
			String resultCode = mullenFriendService.processRemoveFriend(params);
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "mullen.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/removeFriend Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	
	
	
	
	
	
	/*
	 * post 호출 및 json 응답
	 * 계정등록 처리 (멀린3차)
	 */
	@RequestMapping(value="/addUser", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO addUser(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		//Validation
		if(!validateForaddUser(reHeader, reBody, response)) {
			logger.debug("/registAccount Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		
		String empSeq = reHeader.getEmpSeq();
		String outMail = reBody.get("emailAddr").toString().split("@")[0];
		String outDomain = reBody.get("emailAddr").toString().split("@")[1];
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("loginIdCode", (String)reBody.get("loginIdCode"));
			params.put("emailAddr", reBody.get("emailAddr"));
			params.put("outMail", outMail);
			params.put("outDomain", outDomain);
			params.put("newName", (String)reBody.get("userName"));
			params.put("password", (String)reBody.get("password"));
			params.put("passwordConfirm", (String)reBody.get("passwordConfirm"));
			params.put("empSeq", empSeq);
			params.put("mobileTelNum", (String)reBody.get("mobileTelNum"));
			
			//등록자, 등록대상자 다른경우 groupId 조회 
			if(!params.get("loginIdCode").equals(empSeq)) {
				params.put("groupId", mullenService.getGroupId(params));
			}
			
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			//계정 등록 처리.
			boolean isSuccess = mullenService.processAddUser(params, response);
			
			
			
			if(isSuccess) {			
				//조직구성 테이블 셋팅
				isSuccess = mullenService.setMullenGroupInfo(params, response);
				if(isSuccess) {
					response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
					response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				}
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
	
		logger.debug("/registAccount Response: " + JSONObject.fromObject(response).toString());
		
		return response;		
	}
	
	private boolean validateForaddUser(RestfulRequestHeader reHeader, Map<String, Object> reBody,
			ResultVO response) {
		if(reHeader.getGroupSeq() == null || reHeader.getGroupSeq().equals("")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [groupSeq] in header");
			return false;
		}
		if(!reBody.containsKey("loginIdCode")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [loginIdCode] in body");
			return false;
		}
		if(!reBody.containsKey("userName")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [userName] in body");
			return false;
		}
		String userName = (String) reBody.get("userName");
		if(StringUtils.isBlank(userName)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("EMPTY[userName]");
			return false;
		}
		if(!reBody.containsKey("emailAddr")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [emailAddr] in body");
			return false;
		}
		String emailAddr = (String) reBody.get("emailAddr");
		if(!MullenUtil.validateEmailAddr(emailAddr)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("TX800000146","이메일 형식이 아닙니다."));
			return false;
		}
		if(!reBody.containsKey("password")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [password] in body");
			return false;
		}
		if(!reBody.containsKey("passwordConfirm")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [passwordConfirm] in body");
			return false;
		}
		String password = (String) reBody.get("password");
		String passwordConfirm = (String) reBody.get("passwordConfirm");
		if(!password.equals(passwordConfirm)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("password != passwordConfirm");
			return false;
		}
		
		//사용자 비밀번호 변경 API와 패스워드 정책 맞춰야함.
//		if(!MullenUtil.validationPasswd(password)) {
//			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
//			response.setResultMessage("최소6 자리 이상 12 자리 이하로 입력해 주세요.\\n영문(소문자),숫자를 포함해 주세요.");
//			return false;
//		}
		return true;
	}
	
	
	
	/*
	 * post 호출 및 json 응답
	 * 중복확인(계정아이디/멀린코드)
	 */
	@RequestMapping(value="/validationCheck", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO validationCheck(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());

		if(reHeader.getGroupSeq() == null || reHeader.getGroupSeq().equals("")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [groupSeq] in header");
			return response;
		}
		
		if(!reBody.containsKey("type")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [type] in body");
			return response;
		}
		String type = (String) reBody.get("type");
		if(StringUtils.isBlank(type)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("EMPTY[userName]");
			return response;
		}
		
		if(!reBody.containsKey("id")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [id] in body");
			return response;
		}
		String id = (String) reBody.get("id");
		if(StringUtils.isBlank(id)) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("EMPTY[userName]");
			return response;
		}
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("type", type);
			params.put("id", id);
			
			//계정아이디/멀린코드 중복확인
			boolean validationCheck = mullenService.validationCheck(params, response);
			
			if(validationCheck) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("","사용 가능한 계정/코드 입니다."));	
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		
		return response;		
	}
	
	
	
	/*
	 * post 호출 및 json 응답
	 * 로그인
	 */
	@RequestMapping(value="/mullenLogin", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public MullenLoginResponse mullenLogin(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		MullenLoginResponse loginResponse  = new MullenLoginResponse();
		Map<String, Object> reBody =  request.getBody();
		
		logger.debug("/loginMullen Request Body: " + JSONObject.fromObject(reBody).toString());
		
		String outApiAuthentication = BizboxAProperties.getCustomProperty("BizboxA.Cust.outApiAuthentication");
		String sEnpassYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLogin");
		String sLdapLogonYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapLogon");
		String sLdapUseYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapUseYn");
		String groupSeq = (String) reBody.get("groupSeq");
		String loginId = (String) reBody.get("loginId");
		String loginPassword = (String) reBody.get("loginPassword");
		String enpassword = "";
		String osType = (String) reBody.get("osType");
		String appType = (String) reBody.get("appType");
		String token = (String) reBody.get("token");
		String appVer = (String) reBody.get("appVer");
		String programCd = (String) reBody.get("programCd");
		String model = (String) reBody.get("model");
		String deviceRegId = reBody.get("deviceRegId") == null ? "" : reBody.get("deviceRegId").toString();
		String appConfirmYn = "N";
		
		String tId = (String)  (request.getHeader()).gettId();
		loginResponse.settId(tId);
		
		String buildType = CloudConnetInfo.getBuildType();
		
		if( groupSeq == null || groupSeq.length() == 0 || 
				loginId == null  || loginId.length() == 0 ||
				loginPassword == null || loginPassword.length() == 0 ) {

			MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
			logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
			return loginResponse;
		}
		///////////////////////////////////////// 멀린 로그인 관련 추가_20181218 /////////////////////////
		//로그인 아이디가 이메일이면 계정등록 완료됐는지 판단후  login_id 조회후 세팅
		MullenAuthStatus mullenAuthStatus = null;
		if(MullenUtil.validateEmailAddr(loginId)) {//로그인 아이디가 이메일 이면
			HashMap<String, Object> params = new HashMap<>();
			String[] emailAddrs = loginId.split("@");
			params.put("groupSeq", groupSeq);
			params.put("outMail", emailAddrs[0]);
			params.put("outDomain", emailAddrs[1]);
			params.put("emailYn", "Y");
			mullenAuthStatus = mullenService.checkAuthStatus(params);
		}else {//로그인 아이디가 멀린코드이면
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", groupSeq);
			params.put("empSeq", loginId);
			params.put("emailYn", "N");
			mullenAuthStatus = mullenService.checkAuthStatus(params);
		}
		if(mullenAuthStatus == null || (mullenAuthStatus != null && "Y".equals(mullenAuthStatus.getEmailYn()) && !ConstantBiz.MULLEN_AUTH_STATUS_400.equals(mullenAuthStatus.getStatus()))) {
			MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
			logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
			return loginResponse;
		}
		boolean isAccountRegistYn = ConstantBiz.MULLEN_AUTH_STATUS_400.equals(mullenAuthStatus.getStatus());
		String emailLoginYn = mullenAuthStatus.getEmailYn();
		String emailAddr = "";
		if("Y".equals(emailLoginYn)) {
			emailAddr = loginId;
			loginId = mullenAuthStatus.getEmpSeq();
		}
		//////////////////////////////////// 멀린 추가 //////////////////////////////////////////////
		
		//외부 API인증 체크
		if(!outApiAuthentication.equals("99")) {
			
			if(OutAuthentication.outApiAuthentication(loginId, loginPassword)) {
				outApiAuthentication = "▦";
			}
			
		}		
		
		if(outApiAuthentication.equals("▦")) {
			
			enpassword = "▦";
			
		}else if (sEnpassYn.equals("Y") && !loginId.equals(BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassAdmin"))) {
			if (!OutAuthentication.checkUserAuthSW(loginId, loginPassword)) {
				String errCode = "LOGIN000";
				
				MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", errCode);
				logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
				return loginResponse;
			}
			else {
				enpassword = "▦";
			}
		}
		else if(sLdapUseYn.equals("Y") && !loginId.equals(BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapAdmin"))){
			Map<String, Object> ldapParam = new HashMap<String, Object>();
    		ldapParam.put("groupSeq", groupSeq);
    		ldapParam.put("loginId", loginId);
    		ldapParam.put("loginPasswd", loginPassword);
    		Map<String, Object> ldapResult = ldapManageService.ldapAuthCheck(ldapParam);
    		
    		if(sLdapLogonYn.equals("Y")){
        		if(ldapResult != null && ldapResult.get("resultCode").equals("SUCCESS")){
        			enpassword = "▦";
        		}else{
    				String errCode = "LOGIN000";
    				MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", errCode);
    				logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
    				return loginResponse;	
        		}    			
    		}else{
    			enpassword = CommonUtil.passwordEncrypt(loginPassword);	
    		}
		}
		else{
			enpassword  = CommonUtil.passwordEncrypt(loginPassword);	
		}
		
		MullenLoginVO restVO = new MullenLoginVO();
		restVO.setGroupSeq(groupSeq);
		restVO.setLoginId(loginId);
		restVO.setLoginPassword(enpassword);
		
		try {
			
			// 아이디 존재 여부 확인 및 로그인 통제 옵션 값
			Map<String, Object> loginMp = new HashMap<String, Object>();
			loginMp.put("loginId", loginId);
			loginMp.put("groupSeq", groupSeq);
			
	    	boolean loginIdExistCheck = loginService.loginIdExistCheck(loginMp); 
	    	
	    	// 로그인 block 상태
	    	String loginStatus = null;
	    	String loginIdCheck = null;
			
	    	if(loginIdExistCheck) { // 아이디가 존재
	    		loginIdCheck = loginId;
	    		loginMp.put("loginId", loginIdCheck);
	    		loginStatus = loginService.loginOptionResult(loginMp);
	    	}else{
	    		MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
	    		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
	    		return loginResponse;	
	    	}			
	    	
	    	if(loginStatus.contains("block")) {
	    		MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN002");
	    		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
				return loginResponse;	
	    	}else if(loginStatus.equals("longTerm")) {
	    		loginResponse.setResultCode("LOGIN008");
	    		loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000115","장기간 미접속으로 잠금처리되었습니다. 관리자에게 문의하시기 바랍니다."));
	    		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
				return loginResponse;
	    	}	    	
	    	
	    	if (!enpassword.equals("▦") && !sEnpassYn.equals("Y") && !sLdapLogonYn.equals("Y")) {
				String strLoginPassword = mullenService.selectLoginPassword(restVO);

				if(strLoginPassword == null || strLoginPassword.equals("") || !strLoginPassword.equals(enpassword)){			
					MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.login.", "LOGIN000");
					
					// 로그인 실패 카운트 증가
					if(loginIdExistCheck) { // 아이디가 존재
						loginService.updateLoginFailCount(loginMp);
			    	}	
					logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
					return loginResponse;			
				}
	    	}
			
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<MullenLoginVO> pckgList = mullenService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				List<Map<String,Object>> loginVOList = mullenService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);
					restVO.setCompanyList(loginVOList);
					restVO.setBuildType(buildType);
					
					//멀린관련 추가
					if("Y".equals(emailLoginYn)) {
						//restVO.setLoginIdEmail(emailAddr);
						restVO.setLoginId(emailAddr);
					}else {
						//restVO.setLoginIdCode(loginId);
					}
					restVO.setAccountRegistYn(isAccountRegistYn ? "Y" : "N");
					
					/** 하이브리드웹 서버에서 사용될 정보 */
					restVO.setLoginCompanyId(restVO.getCompSeq());
					restVO.setLoginUserId(restVO.getLoginId());
					restVO.setAppVer(appVer);
					restVO.setOsType(osType);
					restVO.setAppType(appType);
					restVO.setProgramCd(programCd);
					restVO.setModel(model);

					
					//사용자권한 존재여부 체크					
					Map<String, Object> authParam = new HashMap<String, Object>();
					authParam.put("groupSeq", restVO.getGroupSeq());
					authParam.put("compSeq", restVO.getCompSeq());
					authParam.put("deptSeq", restVO.getDeptSeq());
					authParam.put("empSeq", restVO.getEmpSeq());
					
					Map<String, Object> authMap = (Map<String, Object>) commonSql.select("restDAO.selectEmpAuthList", authParam);
					if(authMap == null || authMap.get("empAuth") == null || authMap.get("empAuth").equals("")){
						loginResponse.setResultCode("UC0000");
						loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
						logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
						return loginResponse;
					}
					
					//업무보고 근무시간, 모바일 출근체크 사용여부 (임시로 공통코드에 사용유무값 셋팅)
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("groupSeq", restVO.getGroupSeq());					
					Map<String, Object> optionMap = (Map<String, Object>) commonSql.select("restDAO.selectExtOptionList", params);
					
					restVO.setUseReportAttendTime(optionMap.get("useReportAttendTime") == null ? "N" : (String)optionMap.get("useReportAttendTime"));
					restVO.setUseMobileWorkCheck(optionMap.get("useMobileWorkCheck") == null ? "N" : (String)optionMap.get("useMobileWorkCheck"));
					
					
					// 전자결재 암호 입력 사용 여부
					/*
					String pwdCode = CommonCodeUtil.getCodeName("APVPWD", "ISPWD") ; 
					if(EgovStringUtil.isEmpty(pwdCode)) {
						pwdCode = "1" ; //결재시 비밀번호 체크
					}
					*/
					String pwdCode = "0";
					if(restVO.getApprPasswd().length() > 0) {
						pwdCode = "1";
					}
					
					restVO.setPassword_yn(pwdCode); // 결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
					//restVO.setEaType("0");      // 전자결재 타입( 0: NP, 1: suite )					
					
					Map<String,Object> pa = new HashMap<String,Object>();
					pa.put("ip", BizboxAProperties.getProperty("BizboxA.Mqtt.ip"));
					pa.put("port", BizboxAProperties.getProperty("BizboxA.Mqtt.port"));
					restVO.setMqttInfo(pa); 
					 
					loginResponse.setResult(restVO);
					Map<String,Object> p = new HashMap<String,Object>();
					
					for(Map<String,Object> map : loginVOList) {
						/* 회사로고 이미지 */
						p.put("groupSeq", groupSeq);
						p.put("orgSeq", map.get("compSeq"));
						p.put("osType", osType);
						p.put("appType", appType);

						List list = restfulService.selectOrgImgList(p);

						map.put("logoData",list);
					}
					
					/** 모듈 url 정보 */
					p.put("groupSeq", groupSeq);
					p.put("eaType", restVO.getEaType());
					p.put("empSeq", restVO.getEmpSeq());
					p.put("passwdStatusCode", restVO.getPasswdStatusCode());
					p.put("passwdDate", restVO.getPasswdDate());
					Map<String,Object> groupMap = orgChartService.getGroupInfo(p);
					if (groupMap != null) {

						GroupInfoVO groupVO = new GroupInfoVO();
						groupVO.setSmsUrl(EgovStringUtil.nullConvert(groupMap.get("smsUrl")+""));
						groupVO.setMobileUrl(EgovStringUtil.nullConvert(groupMap.get("mobileUrl")+""));
						groupVO.setEdmsUrl(EgovStringUtil.nullConvert(groupMap.get("edmsUrl")+""));
						groupVO.setMailUrl(EgovStringUtil.nullConvert(groupMap.get("mailUrl")+""));
						groupVO.setMessengerUrl(EgovStringUtil.nullConvert(groupMap.get("messengerUrl")+""));
						
						String manualUrl = EgovStringUtil.nullConvert(groupMap.get("manualUrl")+"");
						
						String manualUrlKr = "";
						String manualUrlEn = "";
						String manualUrlJp = "";
						String manualUrlCn = "";
						
						if(!manualUrl.equals("")){
							manualUrlKr = manualUrl + "/user/ko/mobile";
						}
						Map<String, Object> manualMp = new HashMap<String, Object>();
						manualMp.put("kr", manualUrlKr);
						manualMp.put("en", manualUrlEn);
						manualMp.put("jp", manualUrlJp);
						manualMp.put("cn", manualUrlCn);
						
						groupVO.setManualUrl(manualMp);
						
						restVO.setGroupInfo(groupVO);
					}
					
					/** 2017.01.02 장지훈 추가(옵션값 가져오기) */
					List<Map<String, Object>> optionList = restfulService.selectOptionListMobile(p);
					
					restVO.setOptionList(optionList);
					
					LoginLog loginLog = new LoginLog();
					loginLog.setLoginId(restVO.getEmpSeq());
					
					String ipAddress = "";
					
					if(reBody.get("ipAddress") != null && !reBody.get("ipAddress").equals("")){
						ipAddress = (String) reBody.get("ipAddress");
					}
					
					/* 비밀번호 설정규칙 값 추가 */
					/*
					 * I : 최초로그인
					 * C : 옵션 변경
					 * P : 통과
					 * D : 만료기간
					 * T : 안내기간 
					 * */
					restVO.setPasswdStatusCode(restfulService.getPasswdStatusCode(p));
					
					Map<String, Object> passwdResult = new HashMap<String, Object>();
					Map<String, Object> passwdOptions = new HashMap<String, Object>();
					String langCode = restVO.getNativeLangCode();
					String content = "";
					String title = "";
					
					if(restVO.getPasswdStatusCode().equals("P")) {
						title = BizboxAMessage.getMessage("TX800000116","로그인 성공");
						content = BizboxAMessage.getMessage("TX800000104","정상적으로 로그인 되었습니다.");
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
						
						//이차인증 관련 정보 셋팅
						Map<String, Object> paraMp = new HashMap<String, Object>();	    
					    paraMp.put("groupSeq", groupSeq);
					    paraMp.put("empSeq", restVO.getEmpSeq());
					    Map<String, Object> secondCertInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", paraMp);
						
					    
					    if(secondCertInfo.get("useYn").toString().equals("Y")){
						    //이차인증 범위가 WEB만 사용하는 경우는 체크하지않음.
						    //이차인증범위     range : W(WEB), M(App),  A(Web+Messenger_App)
						    String devType = "1";
						    if(!secondCertInfo.get("range").toString().equals("W")){

								if(secondCertInfo.get("scMobileUseYn").equals("Y")){														
								    						    
								    //디바이스 등록 대상 여부
								    List<Map<String, Object>> devList = commonSql.list("SecondCertManage.selectSecondCertDeviceList", paraMp);
								    
								    if(deviceRegId.equals("") || (devList.size() == 0 && (secondCertInfo.get("scWebUseYn").equals("Y") || secondCertInfo.get("scMobileUseYn").equals("Y")))){
								    	if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && deviceRegId.equals("") && (devList.size() == 0 || ((Map<String, Object>)devList.get(0)).get("appConfrimCnt").toString().equals("0")) && secondCertInfo.get("range").toString().equals("M")){
											//app최초로그인인증처리사용여부(appConfirmYn)옵션값에 따른 자동기기등록 처리
								    		appConfirmYn = "Y";
								    		
								    		Map<String, Object> devRegInfo = setDevRegInfo(request, restVO);
								    		deviceRegId = devRegInfo.get("oriDeviceRegId") + "";
								    		devRegInfo.remove("oriDeviceRegId");
								    		restVO.setDevRegInfo(devRegInfo);
								    		
								    		restVO.setUseTwoFactorAuthenticationYn("N"); 
								    		restVO.setUseDeviceRegYn("N");
								    	}else{
								    		if(!deviceRegId.equals("") && devList.size() != 0){
								    			restVO.setUseDeviceRegYn("Y");
								    			loginResponse.setResultCode("LOGIN007");
								    			loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
								    		}else{
									    		restVO.setUseDeviceRegYn("Y");
										    	restVO.setUseTwoFactorAuthenticationYn("N");									    	
										    	loginResponse.setResultCode("LOGIN003");
												loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000118","이차인증 기기등록 후 로그인 가능합니다."));
								    		}
								    	}
								    }else if(devList.size() > 0 && (secondCertInfo.get("scWebUseYn").equals("Y") || secondCertInfo.get("scMobileUseYn").equals("Y"))){
								    	String status = "";						    	
								    	for(Map<String, Object> mp : devList){
								    		if(mp.get("deviceNum").equals(deviceRegId)){
								    			status = mp.get("status") + "";
								    			devType = mp.get("type") + "";
								    			break;
								    		}
								    	}
								    	
								    	//이차인증 웹 사용여부
										if(devType.equals("1")) {
											restVO.setUseTwoFactorAuthenticationYn(secondCertInfo.get("scWebUseYn") + "");
										}
										else {
											restVO.setUseTwoFactorAuthenticationYn("N");
										}
								    	
								    	
								    	if(status.equals("P")){
						    				restVO.setUseDeviceRegYn("N");
						    			}else if(status.equals("R")){
						    				restVO.setUseDeviceRegYn("Y");
						    				loginResponse.setResultCode("LOGIN004");
						    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000119","승인요청 중인 이차인증 기기입니다."));
						    			}else if(status.equals("D")){
						    				restVO.setUseDeviceRegYn("Y");
						    				loginResponse.setResultCode("LOGIN005");
						    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000120","승인요청이 반려된 이차인증 기기입니다."));
						    			}else if(status.equals("C")){
						    				
						    				if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && devType.equals("2") && secondCertInfo.get("range").toString().equals("M")){
						    					restVO.setUseDeviceRegYn("N");
						    					restVO.setAppConfirmYn("N");
							    				loginResponse.setResultCode("LOGIN009");
							    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000121","해지된 인증기기입니다. 모바일 앱 재설치 후 사용가능합니다."));
							    				logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
							    				return loginResponse;
						    				}else{
						    					restVO.setUseDeviceRegYn("Y");
							    				loginResponse.setResultCode("LOGIN006");
							    				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000122","해지된 이차인증 기기입니다."));
						    				}
						    			}else{
							    			restVO.setUseDeviceRegYn("Y");
							    			loginResponse.setResultCode("LOGIN007");
							    			loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
							    		}
								    }else{
								    	restVO.setUseDeviceRegYn("N");
								    }
								    
								    if(restVO.getUseDeviceRegYn().equals("Y")){
								    	loginResponse.setResult(restVO);
								    	logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
								    	return loginResponse;
								    }			
								}else{
									restVO.setUseTwoFactorAuthenticationYn("N");
									restVO.setUseDeviceRegYn("N");
								}
						    }else{
						    	restVO.setUseTwoFactorAuthenticationYn("N");
								restVO.setUseDeviceRegYn("N");
						    }
					    }else{
					    	restVO.setUseTwoFactorAuthenticationYn("N");
							restVO.setUseDeviceRegYn("N");
					    }
					    
					    restVO.setAppConfirmYn(appConfirmYn);
					    
					    //이차인증 통과 기기의경우 token정보 저장
					    if(restVO.getUseTwoFactorAuthenticationYn().equals("Y") && restVO.getUseDeviceRegYn().equals("N")){
					    	Map<String, Object> scMap = new HashMap<String, Object>();
					    	scMap.put("groupSeq", groupSeq);
					    	scMap.put("empSeq", restVO.getEmpSeq());
					    	scMap.put("deviceNum", deviceRegId);
					    	scMap.put("token", token);
					    	
					    	commonSql.update("SecondCertManage.updateDeviceTokenInfo", scMap);
					    }
						
					} else if(restVO.getPasswdStatusCode().equals("I")) {
						title = BizboxAMessage.getMessage("TX000022472", "최초 로그인 비밀번호 변경 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000105", "그룹웨어에 처음 로그인 하셨습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서버스가 이용 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("C")) {
						title = BizboxAMessage.getMessage("TX000022593", "비밀번호 설정규칙 변경 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000106", "시스템관리자에 의해 비밀번호 설정규칙이 변경되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("D")) {
						title = BizboxAMessage.getMessage("", "비밀번호 만료 안내", langCode);
						content = BizboxAMessage.getMessage("", "비밀번호가 만료되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("R")) {
						title = BizboxAMessage.getMessage("TX000022591", "비밀번호 재설정 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000108", "시스템관리자에 의해 비밀번호가 초기화되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					}
					
					/* 옵션 값 데이터 */
					passwdOptions = getPasswordOption(restVO);
					
					if(passwdOptions != null) {
						passwdResult.put("passwdOption", passwdOptions);
					}
					
					
					restVO.setPasswdStatus(passwdResult);
					
					
					//이용약관 관련정보 셋팅(퍼블릭만 적용 - appType = 31,32)
					if(appType.equals("31") || appType.equals("32")) {
						mullenService.setMullenAgreeMent(restVO);
					}
					
					loginLog.setLoginIp(ipAddress);
					loginLog.setLoginMthd("MOBILE_LOGIN");
					loginLog.setErrOccrrAt("N");
					loginLog.setErrorCode("");	
					loginLog.setGroupSeq(restVO.getGroupSeq());
					
					commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
					commonSql.update("EmpManageService.initPasswordFailcount", p);
					
					loginResponse.setResultCode("SUCCESS");
					loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
					
					//별도앱 인증을 위한 토큰정보 저장
					try{
						if(token != null && !token.equals("")){
							p.put("groupSeq", groupSeq);
							p.put("empSeq", restVO.getEmpSeq());
							p.put("osType", osType);
							p.put("appType", appType);
							p.put("token", token);
							empManageService.initToken(p);
						}						
					} catch (Exception e) {
						loginResponse.setResultCode("TOKEN0000");
						loginResponse.setResultMessage(BizboxAMessage.getMessage("TX800000123","토큰 저장 시 문제가 발생하였습니다."));						
					}					
					
				}else{
					loginResponse.setResultCode("UC0000");
					loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
					MessageUtil.setApiMessage(loginResponse, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				loginResponse.setResultCode("UC0000");
				loginResponse.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
			}
		} catch (Exception e) {
			logger.error("API 목록 조회 중 에러 : " + e.getMessage());
			loginResponse.setResultCode("LOGIN001");
			loginResponse.setResultMessage(BizboxAMessage.getMessage("","로그인시 문제가 발생하였습니다."));
		}
		logger.debug("/loginMullen Response: " + JSONObject.fromObject(loginResponse).toString());
		return loginResponse;		
	}
	
	
	/*
	 * post 호출 및 json 응답
	 * 멀린 조직구성 리스트 조회
	 */
	@RequestMapping(value="/mullenGroupList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse mullenGroupList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try {
			HashMap<String, Object> params = new HashMap<>();
			
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			
			response.setResult(mullenService.getMullenGroupList(params));
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;		
	}
	
		
	/*
	 * post 호출 및 json 응답
	 * 멀린 핸드폰 번호 변경
	 */
	@RequestMapping(value="/updateMobileTelNum", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse updateMobileTelNum(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try {
			HashMap<String, Object> params = new HashMap<>();
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("mobileTelNum", reBody.get("mobileTelNum"));
			
			mullenService.updateMobileTelNum(params);
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;		
	}
	
	
	/*
	 * post 호출 및 json 응답
	 * 조직원 찾기
	 */
	@RequestMapping(value="/searchMullenUser", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse searchMullenUser(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try {
			HashMap<String, Object> params = new HashMap<>();
			
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("searchText", reBody.get("searchText"));
			
			response.setResult(mullenService.searchMullenUser(params));
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;		
	}
	
	
	/*
	 * post 호출 및 json 응답
	 * 구성원 등록 요청
	 */
	@RequestMapping(value="/reqGroup", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse reqGroup(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try {
			HashMap<String, Object> params = new HashMap<>();
			
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("targetEmpSeq", reBody.get("targetEmpSeq"));
			params.put("status", ConstantBiz.MULLEN_GROUP_REQUEST_TYPE_100);
			
			mullenService.reqGroup(params);
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;		
	}
	
	
	
	/*
	 * post 호출 및 json 응답
	 * 구성원 등록 요청 수락/거절
	 */
	@RequestMapping(value="/reqHandling", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse reqHandling(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try {
			HashMap<String, Object> params = new HashMap<>();
			
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("seq", reBody.get("seq"));
			params.put("status", reBody.get("status"));
			
			boolean isSuccess = mullenService.reqHandling(params, response);
			
			if(isSuccess) {
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;		
	}
	
	
	
	
	/*
	 * post 호출 및 json 응답
	 * 구성원 요청 리스트
	 */
	@RequestMapping(value="/reqList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse reqList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try {
			HashMap<String, Object> params = new HashMap<>();
			
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("listType", reBody.get("listType"));
			
			response.setResult(mullenService.reqList(params, response));
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;		
	}
	
	
	/*
	 * post 호출 및 json 응답
	 * 구성원 나가기
	 */
	@RequestMapping(value="/outGroup", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse outGroup(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/registAccount Request Body: " + JSONObject.fromObject(reBody).toString());
		
		try {
			HashMap<String, Object> params = new HashMap<>();
			
			if(!reBody.containsKey("langCode")) {
				params.put("langCode", "kr");	
			}else {
				params.put("langCode", (String)reBody.get("langCode"));
			}
			
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			
			mullenService.outGroup(params);
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;		
	}
	
	
	
	/*
	 * post 호출 및 json 응답
	 * 패스워드 변경
	 */
	@RequestMapping(value="/UpdateMullenUserPwd", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO UpdateMullenUserPwd(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,			
								@RequestBody RestfulRequest request
							) throws Exception {
		
		ResultVO resultList  = new ResultVO();

		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/UpdateUserPwdNew Request Header: " + JSONObject.fromObject(reHeader).toString());
		logger.debug("/UpdateUserPwdNew Request Body: " + JSONObject.fromObject(reBody).toString());
		
		String passwdOptionUseYN = "";
		String inputDigitValue = "";
		String inputRuleValue = "";
		String inputLimitValue = "";
		String inputBlockTextValue = "";
		String regExpression = "";
		
		/* 결과 오류 변수 선언 */
		String inputDigitResult = "";
		String inputRuleResult = "";
		String inputLimitResult = "";
		
		String returnInputRuleResult = "";
		String returnInputLimitResult = "";
		
		
		boolean regExpressionFlag = false;
		boolean passwdSave = false;
		
	
		try {
			LoginVO loginVO = new LoginVO();

			/* 기존 비밀번호 체크 */
			String loginId = (String) reBody.get("loginId");
			String oPWD = (String) reBody.get("oPWD");
			String nPWD = (String) reBody.get("nPWD");
			String groupSeq = (String) reHeader.getGroupSeq();

			/*
			 * 멀린 비밀번호 변경 로직 추가_20190109
			 */
			if(StringUtils.isEmpty(groupSeq)) {
				groupSeq = "Mullen";	
			}
			if(MullenUtil.validateEmailAddr(loginId)) {//로그인 아이디가 이메일 이면 loginId -> empSeq로 변경처리
				HashMap<String, Object> params = new HashMap<>();
				params.put("groupSeq", groupSeq);
				params.put("emailAddr", loginId);
				MullenUser mullenUser = mullenService.getMullenUserInfoByEmailAddr(params);
				if(mullenUser == null || StringUtils.isEmpty(mullenUser.getEmpSeq())) {
					resultList.setResultCode("fail");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000017854","존재하지 않는 사용자 입니다.", "kr"));
					return resultList;
				}else {
					loginId = mullenUser.getEmpSeq();
				}
			}
	        loginVO.setPassword(oPWD);
	        loginVO.setId(loginId);
	        loginVO.setUserSe("USER");
	        loginVO.setGroupSeq(groupSeq);

	        // 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
	    	LoginVO resultVO = loginService.actionLogin(loginVO, servletRequest);
			
	    	String langCode = resultVO.getLangCode();
	    	
	    	// 비밀번호 일치
	    	if(resultVO.getId() != null){
				/* 옵션 확인 */
	    		Map<String, Object> mp = new HashMap<String, Object>();
	    		mp.put("option", "cm20");
	    		mp.put("groupSeq", groupSeq);
	    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);
				
	    		// 메일 싱크를 위한 정보
		    	Map<String, Object> mailParam = new HashMap<String, Object>();
		    	mailParam.put("groupSeq", groupSeq);
		    	mailParam.put("compSeq", resultVO.getOrganId());				
				Map<String, Object> mailInfo = (Map<String, Object>) commonSql.select("EmpManage.getMailInfo", mailParam);
	    		
	    		for(Map<String, Object> temp : loginOptionValue) {
	    			// 비밀번호 설정규칙 사용 여부
	    			if(temp.get("optionId").equals("cm200")) {
	    				if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
	    					passwdOptionUseYN = "N";
	    					break;
	    				} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
	    					passwdOptionUseYN = "Y";
	    				}
	    			}
	    			
	    			// 비밀번호 입력 자리수 설정
	    			if(temp.get("optionId").equals("cm202")) {
	    				inputDigitValue = temp.get("optionRealValue").toString();
	    			}
	    			
	    			// 입력규칙값
	    			if(temp.get("optionId").equals("cm203")) {
	    				inputRuleValue = temp.get("optionRealValue").toString();
	    			}

	    			// 입력제한값
					if(temp.get("optionId").equals("cm204")) {
						inputLimitValue = temp.get("optionRealValue").toString();
					}
					
	    			// 입력제한단어
					if(temp.get("optionId").equals("cm205")) {
						inputBlockTextValue = temp.get("optionRealValue").toString();
					}					
					
	    		}
	    		
	    		Pattern p = null;		// 정규식
	    		
	    		// 비밀번호 설정 옵션값 체크
	    		if(passwdOptionUseYN.equals("Y")) {
	    			
    				if(!inputDigitValue.equals("")) {

    					String[] digit = inputDigitValue.split("\\|");
    					
    					if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){
    					
	    					String min = digit[0];
	    					String max = digit[1];
	    					
	    					if(max.equals("0")) {
	    						max = "16";
	    					}
	    					
	    					if(nPWD.length() < Integer.parseInt(min) || nPWD.length() > Integer.parseInt(max)) {
	    						
	    						inputDigitResult = BizboxAMessage.getMessage("TX000010842","최소") + min + " " + BizboxAMessage.getMessage("TX000022609", "자리 이상") + max + " " + BizboxAMessage.getMessage("TX000022610","자리 이하로 입력해 주세요.");
	    						
	    					}
    					}
    				}	    			
	    			
	    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {
	    				
	    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
	    				if(inputRuleValue.indexOf("0") > -1) {
	    					regExpression = ".*[A-Z]+.*";
	    					
	    					p = Pattern.compile(regExpression);
	    					
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)", langCode) + ",";
	    					}
	    				} 
	    				
	    				if(inputRuleValue.indexOf("1") > -1) {
						regExpression = ".*[a-z]+.*";
	    					
						p = Pattern.compile(regExpression);
						
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleValue.indexOf("2") > -1) {
						regExpression = ".*[0-9]+.*";
	    					
						p = Pattern.compile(regExpression);
						
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleValue.indexOf("3") > -1) {
	    					regExpression = ".*[^가-힣a-zA-Z0-9].*";
	    					
	    					p = Pattern.compile(regExpression);
	    					
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleResult.length() > 0) {
	    					returnInputRuleResult = inputRuleResult.substring(0, inputRuleResult.length() - 1) + BizboxAMessage.getMessage("TX000022611","를 포함해 주세요.");
	    				}
	    			}
	    			
	    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {
	    				
	    				inputLimitValue = "|" + inputLimitValue + "|";
	    				
	    				Map<String, Object> params = new HashMap<String, Object>();
	    				
	    				params.put("empSeq", resultVO.getUniqId());
	    				params.put("groupSeq", resultVO.getGroupSeq());
	    				params.put("langCode", resultVO.getLangCode());
	    				params.put("compSeq", resultVO.getOrganId());
	    				
	    				/* 사용자 정보 가져오기 */
	    	    		// 사원 정보 (비밀번호 변경 옵션 값에 필요)
	    	    		Map<String, Object> infoMap = empManageService.selectEmpInfo(params, new PaginationInfo());
	    	    		List<Map<String,Object>> list = (List<Map<String, Object>>) infoMap.get("list");
	    	    		Map<String,Object> map = list.get(0);
	    				
	    	    		// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전 비밀번호, 6:키보드 일련배열
	    	    		if(inputLimitValue.indexOf("|0|") > -1) {
	    					String loginIdCheck = map.get("loginId").toString();
	    					
	    					if(nPWD.indexOf(loginIdCheck) > -1) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디", langCode) + ",";
	    					}
	    				}
					
	    	    		if(inputLimitValue.indexOf("|1|") > -1) {
	    	    			String erpNum = map.get("erpEmpNum") != null ? map.get("erpEmpNum").toString() : "";
						
	    					if(nPWD.indexOf(erpNum) > -1 && !erpNum.equals("")) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번", langCode) + ",";
	    					}
	    				}
					
	    	    		if(inputLimitValue.indexOf("|2|") > -1) {
	    	    			String phoneNum = map.get("mobileTelNum") != null ? map.get("mobileTelNum").toString().replaceAll("-", "") : "";
	    					
	    	    			String phoneNumPattern = "";
	    	    			String[] phoneArray = null;
	    	    			String middleNum = "";
	    	    			String endNum = "";
						
	    	    			if(!phoneNum.equals("")) {
	    	    				phoneNumPattern = phoneFormat(phoneNum);
	    	    				phoneArray = phoneNumPattern.split("-");
							
								if(phoneArray.length > 2) {
									middleNum = phoneArray[1];
									endNum = phoneArray[2];
								} else if(phoneArray.length == 1 && phoneArray[0].length() > 3){
									middleNum = phoneArray[0];
									endNum = phoneArray[0];
								}
								
								if(!middleNum.equals("") && !endNum.equals("")){
									if(nPWD.indexOf(middleNum) > -1 || nPWD.indexOf(endNum) > -1) {
										inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화", langCode) + ",";
									}
								}								
	    	    			}
	    				} 
					
	    	    		if(inputLimitValue.indexOf("|3|") > -1) {
	    	    			String birthDay = map.get("bday") != null ? map.get("bday").toString() : "0000-00-00";
	    					
							if(!birthDay.equals("0000-00-00")) {
								String[] yearMonthDay = birthDay.split("-");
								String year = yearMonthDay[0];
								String monthDay = yearMonthDay[1] + yearMonthDay[2];
								String residentReg = year.substring(2,4) + monthDay;
								
								if(nPWD.indexOf(year) > -1 || nPWD.indexOf(monthDay) > -1 || nPWD.indexOf(residentReg) > -1) {
									inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일", langCode) + ",";
								}
							}
	    				}
					
	    	    		if(inputLimitValue.indexOf("|4|") > -1) {
	    					int nSamePass1 = 1; //연속성(+) 카운드
		 				    int nSamePass2 = 1; //반복성(+) 카운드
		 				    int blockCnt = 3;
		 				    
		 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
		 				    	blockCnt = 4;
		 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
		 				    	blockCnt = 5;
		 				    }		 				    
		 				    
		 				    for(int j=1; j < nPWD.length(); j++){
		 				    	int tempA = (int) nPWD.charAt(j-1);
		 				    	int tempB = (int) nPWD.charAt(j);
		 				    	
		 				    	if(tempA - (tempB-1) == 0 ) {
		 				    		nSamePass1++;
		 				    	}else{
		 				    		nSamePass1 = 1;
		 				    	}
		 				    	
		 				    	if(tempA - tempB == 0) {
		 				    		nSamePass2++;
		 				    	}else{
		 				    		nSamePass2 = 1;
		 				    	}
		 				    	
		 				    	if(nSamePass1 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리") + " " + BizboxAMessage.getMessage("TX000022602","연속문자", langCode) + ",";
		 				    		break;
		 				    	}
		 				    	
		 				    	if(nSamePass2 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리") + " " + BizboxAMessage.getMessage("TX000022603","반복문자", langCode) + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}
	    	    		
	    	    		if(inputLimitValue.indexOf("|5|") > -1) {
	    	    			if(map.get("prevLoginPasswd").equals(CommonUtil.passwordEncrypt(nPWD))){
	    	    				inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호", langCode) + ",";	
	    	    			}
	    				}	    	    		
	    	    		
	    	    		if(inputLimitValue.indexOf("|6|") > -1 && nPWD.length() > 1) {
	    	    			
	    	    			int nSamePass1 = 1; //연속성(+) 카운드
	    	    			int nSamePass2 = 1; //연속성(-) 카운드
		 				    int blockCnt = 3;
		 				    String keyArray = "`1234567890-=!@#$%^&*()_+qwertyuiopasdfghjkl;'zxcvbnm,./";
		 				    String newPasswdLow = nPWD.toLowerCase();
		 				    
		 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
		 				    	blockCnt = 4;
		 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
		 				    	blockCnt = 5;
		 				    }
		 				    
		 				    for(int j=1; j < newPasswdLow.length(); j++){
		 				    	int tempA = keyArray.indexOf(newPasswdLow.charAt(j-1));
		 				    	int tempB = keyArray.indexOf(newPasswdLow.charAt(j));
		 				    	
		 				    	if(tempA == -1 || tempB == -1){
		 				    		nSamePass1 = 1;
		 				    		nSamePass2 = 1;
		 				    	}else{
		 				    		
		 				    		if((tempB-tempA) == 1){
		 				    			nSamePass1++;
		 				    		}else{
		 				    			nSamePass1 = 1;
		 				    		}
		 				    		
		 				    		if((tempA-tempB) == 1){
		 				    			nSamePass2++;
		 				    		}else{
		 				    			nSamePass2 = 1;
		 				    		}		 				    		
		 				    	}
		 				    	
		 				    	if(nSamePass1 >= blockCnt || nSamePass2 >= blockCnt) {
		 				    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열", langCode) + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}		    	    		
	    			}
	    			
	    			if(!inputBlockTextValue.equals("")){
	    				
	    				inputBlockTextValue = "|" + inputBlockTextValue + "|";
	    				
	    				if(inputBlockTextValue.indexOf("|" + nPWD + "|") != -1){
	    					inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어", langCode) + ",";
	    				}

}		    			
	    			
					if(inputLimitResult.length() > 0) {
						returnInputLimitResult = inputLimitResult.substring(0, inputLimitResult.length() - 1) + BizboxAMessage.getMessage("TX800000127","가 포함되어 있습니다.");
					}	    			
	    			
	    			String result = inputDigitResult + "\n" + returnInputRuleResult + "\n" + returnInputLimitResult;
	    			
	    			if(result.equals("\n\n")) {
	    				passwdSave = true;
	    			} else {
	    				passwdSave = false;
	    			}
	    			
	    			if(passwdSave) {
	    				
	    				Map<String, Object> adapterParam = new HashMap<String,Object>();
	    				adapterParam.put("groupSeq", resultVO.getGroupSeq());
	    				adapterParam.put("callType", "updatePasswd");
	    				adapterParam.put("empSeq", resultVO.getUniqId());
	    				adapterParam.put("compSeq", resultVO.getCompSeq());
	    				adapterParam.put("deptSeq", resultVO.getOrgnztId());
	    				adapterParam.put("createSeq", resultVO.getUniqId());
	    				adapterParam.put("loginPasswdNew", nPWD);	
	    					
	    				Map<String, Object> adapterResult = orgAdapterService.empSaveAdapter(adapterParam);
	    				
		    			if(mailInfo.get("compEmailYn") != null && mailInfo.get("compEmailYn").equals("Y")){
		    				Map<String, Object> params = new HashMap<String, Object>();
		    				params.put("groupSeq", groupSeq);
		    				orgAdapterService.mailUserSync(params);	 		    				
		    			}
	    				
		    			resultList.setResultCode("SUCCESS");
		    			resultList.setResultMessage(BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다", langCode));
	    			} else {
	    				resultList.setResultCode("fail");
		    			resultList.setResultMessage(result.substring(0, result.length()-1));
	    			}
	    			
	    		} else if(passwdOptionUseYN.equals("N")) {
	    			
    				Map<String, Object> adapterParam = new HashMap<String,Object>();
    				adapterParam.put("groupSeq", resultVO.getGroupSeq());
    				adapterParam.put("callType", "updatePasswd");
    				adapterParam.put("empSeq", resultVO.getUniqId());
    				adapterParam.put("compSeq", resultVO.getCompSeq());
    				adapterParam.put("deptSeq", resultVO.getOrgnztId());
    				adapterParam.put("createSeq", resultVO.getUniqId());
    				adapterParam.put("loginPasswdNew", nPWD);	
    					
    				Map<String, Object> adapterResult = orgAdapterService.empSaveAdapter(adapterParam);
	    			
	    			if(mailInfo.get("compEmailYn") != null && mailInfo.get("compEmailYn").equals("Y")){
	    				Map<String, Object> params = new HashMap<String, Object>();
	    				params.put("groupSeq", groupSeq);
	    				orgAdapterService.mailUserSync(params);	    				
	    			}
	    			
	    			resultList.setResultCode("SUCCESS");
	    			resultList.setResultMessage(BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다", langCode));

	    		}
	    		
			} else {		// 비밀번호 불일치
				resultList.setResultCode("fail");
				resultList.setResultMessage(BizboxAMessage.getMessage("TX000004152","기존 비밀번호가 일치하지 않습니다.", langCode));
			}
	    	
	    	
	    	
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			resultList.setResultCode("CO0000");
			resultList.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return resultList;		
	}
	
	
	
	
	/*
	 * post 호출 및 json 응답
	 * 계정삭제 처리 (멀린3차)
	 */
	@RequestMapping(value="/deleteUser", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO deleteUser(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		ResultVO response = new ResultVO();
	
		RestfulRequestHeader reHeader = request.getHeader();
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		
		if(reHeader.getGroupSeq() == null || reHeader.getGroupSeq().equals("")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [groupSeq] in header");
			return response;
		}else if(reHeader.getEmpSeq() == null || reHeader.getEmpSeq().equals("")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [empSeq] in header");
			return response;
		}
		
		try{
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			
			//계정 삭제 처리(use_yn = 'D', 개인정보 초기화, 멀린그룹관련 정보 초기화)
			int empCnt = mullenService.deleteUser(params, response);
			
			if(empCnt > 0) {			
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}else {
				response.setResultCode(ConstantBiz.MULLEN_DELETE_EMP_ERROR_DEL001);
				response.setResultMessage(BizboxAMessage.getMessage("","삭제할 대상이 존재하지 않습니다."));
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		logger.debug("/registAccount Response: " + JSONObject.fromObject(response).toString());
		return response;		
	}
	
	
	/*
	 * post 호출 및 json 응답
	 * 이용약관 처리 - 동의/철회 (멀린3차)
	 */
	@RequestMapping(value="/setMullenAgreement", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse setMullenAgreement(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		APIResponse response = new APIResponse();
	
		RestfulRequestHeader reHeader = request.getHeader();
		Map<String, Object> reBody =  request.getBody();
		
		List<Map<String, Object>> agreementInfo = new ArrayList<Map<String, Object>>( );
		
		logger.debug("/registAccount Request Header: " + JSONObject.fromObject(reHeader).toString());
		
		if(reHeader.getGroupSeq() == null || reHeader.getGroupSeq().equals("")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [groupSeq] in header");
			return response;
		}else if(reHeader.getEmpSeq() == null || reHeader.getEmpSeq().equals("")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [empSeq] in header");
			return response;
		}else if(reBody.get("agreementInfo") == null || reBody.get("agreementInfo").equals("")) {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [agreementInfo] in body");
			return response;
		}
		
		try{
			
			agreementInfo = (List<Map<String, Object>>) reBody.get("agreementInfo");
			
			HashMap<String, Object> params = new HashMap<>();
			params.put("groupSeq", reHeader.getGroupSeq());
			params.put("empSeq", reHeader.getEmpSeq());
			params.put("agreementInfo", agreementInfo);
			
			mullenService.setMullenAgreeMent(params);
			
			response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(agreementInfo);
			
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		logger.debug("/registAccount Response: " + JSONObject.fromObject(response).toString());
		return response;		
	}
}

