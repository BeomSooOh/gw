package restful.messenger.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.systemx.secondCertificate.service.SecondCertificateService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.code.CommonCodeUtil;
import neos.cmm.util.OutAuthentication;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import restful.com.service.AttachFileService;
import restful.messenger.service.MessengerService;
import restful.messenger.vo.MessengerLoginVO;
import restful.messenger.vo.MessengerResultList;
import restful.mobile.vo.GroupInfoVO;
import restful.mobile.vo.RestfulRequest;
import api.common.model.APIResponse;
import bizbox.orgchart.util.JedisClient;
import bizbox.statistic.data.dto.ActionDTO;
import bizbox.statistic.data.dto.CreatorInfoDTO;
import bizbox.statistic.data.enumeration.EnumActionStep1;
import bizbox.statistic.data.enumeration.EnumActionStep2;
import bizbox.statistic.data.enumeration.EnumActionStep3;
import bizbox.statistic.data.enumeration.EnumDevice;
import bizbox.statistic.data.enumeration.EnumModuleName;
import bizbox.statistic.data.service.ModuleLogService;
import cloud.CloudConnetInfo;

import egovframework.com.sym.log.clg.service.LoginLog;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;

/**
 * RestfulController.java 클래스
 *
 * @author 송준석
 * @since 2015. 8. 19.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *  
 * </pre>
 */


@Controller
public class MessengerController {

    private static final Log LOG = LogFactory.getLog(MessengerController.class);
    
    @Resource(name="LdapAdapterService")
	public LdapAdapterService ldapManageService;
    
	@Resource(name="MessengerService")
	private MessengerService messengerService;	
	
	@Resource(name = "loginService")
    private EgovLoginService loginService;	
	
	@Resource(name="GroupManageService")
	GroupManageService groupManageService;
	
	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name="SecondCertificateService")
    private SecondCertificateService SecondCertificateService;
	
    /*
     * post 호출 및 json 응답
     * 로그인 처리
     */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/MessengerLoginWS", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public MessengerResultList getLoginListPost(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		MessengerResultList resultList  = new MessengerResultList();
		Map<String, Object> reBody =  request.getBody();
		
		//외부SSO 패스워드 정책 예외처리용
		boolean outSSOYn = false;
		
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
		String sIpAddress = "";
		String buildType = CloudConnetInfo.getBuildType();
		
		//클라우드 개통상태 체크
		if(buildType.equals("cloud")) {
    		JedisClient jedis = CloudConnetInfo.getJedisClient();
    		Map<String, Object> dbInfo = jedis.getParamMapByMobileId(groupSeq);
    		if(dbInfo != null && !dbInfo.get("OPERATE_STATUS").equals("20")){	
    			
    			resultList.setResultCode("LOGIN000");
    			
    			if(dbInfo.get("OPERATE_STATUS").equals("0")) {
    				resultList.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 개통대기 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("10")) {
					resultList.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 개통중 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("19")) {
					resultList.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 개통완료 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("30")) {
					resultList.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 일시정지 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("90")) {
					resultList.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 점검 상태입니다. 관리자에게 문의해주세요."));
				}else {
					resultList.setResultMessage(BizboxAMessage.getMessage("TX800000032","클라우드 서비스 중지 상태입니다. 관리자에게 문의해주세요."));
				}
    			return resultList;	    			
    		}
		}	
		
		if(reBody.get("ipAddress") != null) {
			sIpAddress = (String) reBody.get("ipAddress");
		}
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);
		
		
		if( groupSeq == null || groupSeq.length() == 0 || 
			loginId == null  || loginId.length() == 0 ||
			loginPassword == null || loginPassword.length() == 0 ) {

			MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
			return resultList;
		}
		
		//외부 API인증 체크
		if(!outApiAuthentication.equals("99")) {
			
			if(OutAuthentication.outApiAuthentication(loginId, loginPassword)) {
				outApiAuthentication = "▦";
			}
			
		}
		
		if(outApiAuthentication.equals("▦")) {
			
			enpassword = "▦";
			outSSOYn = true;
			
		}else if (sEnpassYn.equals("Y") && !loginId.equals(BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassAdmin"))) {
			if (!OutAuthentication.checkUserAuthSW(loginId, loginPassword)) {
				String errCode = "LOGIN000";
				
				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", errCode);
				return resultList;
			}
			else {
				enpassword = "▦";
				outSSOYn = true;
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
    				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", errCode);
    				return resultList;	
        		}    			
    		}else{
    			enpassword = CommonUtil.passwordEncrypt(loginPassword);	
    		}
		}
		else{
			enpassword = CommonUtil.passwordEncrypt(loginPassword);	
		}
		
		MessengerLoginVO restVO = new MessengerLoginVO();
		restVO.setGroupSeq(groupSeq);
		restVO.setLoginId(loginId);
		restVO.setLoginPassword(enpassword);
		
		try {

			// 아이디 존재 여부 확인 및 로그인 통제 옵션 값
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("loginId", loginId);
			mp.put("groupSeq", groupSeq);
			
	    	boolean loginIdExistCheck = loginService.loginIdExistCheck(mp); 
	    	
	    	// 로그인 block 상태
	    	String loginStatus = null;
			
	    	if(loginIdExistCheck) { // 아이디가 존재
	    		loginStatus = loginService.loginOptionResult(mp);
	    	}else{
	    		MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
	    		return resultList;	
	    	}			
	    	
	    	if(loginStatus.contains("block")) {
	    		MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN002");
				return resultList;	
	    	}else if(loginStatus.equals("longTerm")) {
	    		resultList.setResultCode("LOGIN008");
	    		resultList.setResultMessage(BizboxAMessage.getMessage("TX800000035","장기간 미접속으로 잠금처리되었습니다.") + " " +  BizboxAMessage.getMessage("TX000018544","관리자에게 문의하시기 바랍니다."));
				return resultList;	
	    	}
	    	
	    	if (!enpassword.equals("▦") && !sEnpassYn.equals("Y") && !sLdapLogonYn.equals("Y")) {
				String strLoginPassword = messengerService.selectLoginPassword(restVO);
				
				if(strLoginPassword == null) {
					resultList.setResultCode("UC0000");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
					return resultList;
				}else if( !strLoginPassword.equals(enpassword)){			
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
					
					// 로그인 실패 카운트 증가
					if(loginIdExistCheck) { // 아이디가 존재
						loginService.updateLoginFailCount(mp);
			    	}	
					
					return resultList;				
				}	    		
	    	}
			
	    	
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<MessengerLoginVO> pckgList = messengerService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				List<Map<String,Object>> loginVOList = messengerService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);	
					
					restVO.setCompanyList(loginVOList);
					restVO.setBuildType(buildType);
					
					
					//사용자권한 존재여부 체크					
					Map<String, Object> authParam = new HashMap<String, Object>();
					authParam.put("groupSeq", restVO.getGroupSeq());
					authParam.put("compSeq", restVO.getCompSeq());
					authParam.put("deptSeq", restVO.getDeptSeq());
					authParam.put("empSeq", restVO.getEmpSeq());
					
					Map<String, Object> authMap = (Map<String, Object>) commonSql.select("restDAO.selectEmpAuthList_new", authParam);
//                    System.out.println("MessengerLoginWS selectEmpAuthList_new empAuth = " + authMap.get("empAuth"));
					if(authMap == null || authMap.get("empAuth") == null || authMap.get("empAuth").equals("")){
						resultList.setResultCode("UC0000");
						resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));						
						
						return resultList;
					}
					
					//멀티도메인(메일)사용의 경우 해당회사 메일도메인 주소 조회 후 재셋팅
					if(restVO.getEmailDomain() != null && restVO.getEmailDomain().equals("/mail2/")){
						Map<String, Object> para = new HashMap<String, Object>();
						para.put("compSeq", restVO.getCompSeq());
						Map<String, Object> res = (Map<String, Object>) commonSql.select("CompManage.getComp", para);
						restVO.setEmailDomai(res.get("compMailUrl") + "");
					}
					
					//IP접근제한 체크
					if(!sIpAddress.equals("")){
						boolean checkIp = CheckAccessIp(sIpAddress, restVO);
						if(!checkIp){
							MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN003");
							return resultList;
						}
					}
					
					// 전자결재 암호 입력 사용 여부 
					String pwdCode = CommonCodeUtil.getCodeName("APVPWD", "ISPWD") ; 
					if(EgovStringUtil.isEmpty(pwdCode)) {
						pwdCode = "1" ; //결재시 비밀번호 체크
					}
					
					restVO.setPassword_yn(pwdCode); // 결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
					//restVO.setEaType("0");      // 전자결재 타입( 0: NP, 1: suite )					
					
					Map<String,Object> pa = new HashMap<String,Object>();
					pa.put("ip", BizboxAProperties.getProperty("BizboxA.Mqtt.ip"));
					pa.put("port", BizboxAProperties.getProperty("BizboxA.Mqtt.port"));
					restVO.setMqttInfo(pa);
					
					
					// 알림설정 정보 가져오기
					List<Map<String,Object>> alertList = messengerService.selectAlertInfo(restVO);
					
					restVO.setAlertList(alertList);
					
					
					resultList.setResult(restVO);
					Map<String,Object> p = new HashMap<String,Object>();
					
					for(Map<String,Object> map : loginVOList) {
						/* 회사로고 이미지 */
						p.put("groupSeq", groupSeq);
						p.put("orgSeq", map.get("compSeq"));
						p.put("osType", osType);
						p.put("appType", appType);

						List list = messengerService.selectOrgImgList(p);

						map.put("logoData",list);
					}
					
					/** 모듈 url 정보 */
					p.put("groupSeq", groupSeq);
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
							manualUrlKr = manualUrl + "/user/ko/messenger";
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
					List<Map<String, Object>> optionList =  messengerService.selectOptionListMessanger(p);
					
					restVO.setOptionList(optionList);
					
					LoginLog loginLog = new LoginLog();
					loginLog.setLoginId(restVO.getEmpSeq());
					
					if(sIpAddress.equals("")){
						sIpAddress = CommonUtil.getClientIp(servletRequest);
					}
					
					/* 비밀번호 설정규칙 값 추가 */
					/*
					 * I : 최초로그인
					 * C : 옵션 변경
					 * P : 통과
					 * D : 만료기간 
					 * T : 알림기간
					 * */
					
					//SSO 예외처리 
					if(outSSOYn) {
						restVO.setPasswdStatusCode("P");
					}else {
						restVO.setPasswdStatusCode(messengerService.getPasswdStatusCode(p));	
					}
					
					Map<String, Object> passwdOption = new HashMap<String, Object>();
					String message = "";
					String langCode = restVO.getNativeLangCode();
					
					if(restVO.getPasswdStatusCode().equals("N")) {
						restVO.setPasswdStatusCode("P");
					}
					
					if(restVO.getPasswdStatusCode().equals("P")) {
						passwdOption.put("message", BizboxAMessage.getMessage("TX800000104","정상적으로 로그인 되었습니다."));
					} else if(restVO.getPasswdStatusCode().equals("I")) {
						message = BizboxAMessage.getMessage("TX800000105", "그룹웨어에 처음 로그인 하셨습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서버스가 이용 가능합니다.", langCode);
						passwdOption.put("message", message);
					} else if(restVO.getPasswdStatusCode().equals("C")) {
						message = BizboxAMessage.getMessage("TX800000106", "시스템관리자에 의해 비밀번호 설정규칙이 변경되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						passwdOption.put("message", message);
					} else if(restVO.getPasswdStatusCode().equals("D")) {
						message = BizboxAMessage.getMessage("", "비밀번호가 만료되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						passwdOption.put("message", message);
					} else if(restVO.getPasswdStatusCode().equals("R")) {
						message = BizboxAMessage.getMessage("TX800000108", "시스템관리자에 의해 비밀번호가 초기화되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.", langCode);
						passwdOption.put("message", message);
					}
					
					restVO.setPasswdStatus(passwdOption);
					
					//이차인증 사용유무 셋팅
					Map<String, Object> paraMp = new HashMap<String, Object>();	    
				    paraMp.put("groupSeq", groupSeq);
				    paraMp.put("empSeq", restVO.getEmpSeq());
				    Map<String, Object> secondCertInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", paraMp);
				    if(secondCertInfo.get("useYn").equals("Y") && secondCertInfo.get("scUseYn").equals("Y")){
				    	restVO.setUseTwoFactorAuthenticationYn("Y");
				    	
				    	//qr코드 데이터 셋팅
				    	paraMp.put("type", "L");
				    	paraMp.put("msgYn", "Y");
				    	Map<String, Object> result = SecondCertificateService.setQrCodeInfo(paraMp);
				    	if(result != null){
				    		result.remove("type");
				    	}
				    	restVO.setQrMap(result);
				    }else{
				    	restVO.setUseTwoFactorAuthenticationYn("N");
				    	restVO.setQrMap(null);
				    }
					
					//게시판 롤업기능 사용유무 셋팅
					Map<String, Object> para = new HashMap<String, Object>();
					para.put("groupSeq", restVO.getGroupSeq());
					
					para.put("optionId", "msg1900");
					Map<String, Object> optionMap1 = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", para);
					para.put("optionId", "msg1910");
					Map<String, Object> optionMap2 = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", para);
					//para.put("optionId", "msg1920");
					//Map<String, Object> optionMap3 = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", para);
					
					if(optionMap1 != null && optionMap1.get("val").toString().equals("1")){
						if(optionMap2 != null && !optionMap2.get("val").toString().equals("")){
							restVO.setBdRollingYn("Y");
						}else{
							restVO.setBdRollingYn("N");
						}
					}else{
						restVO.setBdRollingYn("N");
					}
					
					loginLog.setLoginIp(sIpAddress);
					loginLog.setLoginMthd("MESSENGER_LOGIN");
					loginLog.setErrOccrrAt("N");
					loginLog.setErrorCode("");
					loginLog.setGroupSeq(restVO.getGroupSeq());
					commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
					commonSql.update("EmpManageService.initPasswordFailcount", p);
					
					resultList.setResultCode("SUCCESS");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));		
					
					//로그인 로그(운영일경우에만 처리)
			    	if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
			        	ActionDTO action = new ActionDTO(EnumActionStep1.Login, EnumActionStep2.ActionNone, EnumActionStep3.ActionNone);
			
			    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
			    		creatorInfo.setEmpSeq(restVO.getEmpSeq());
			    		creatorInfo.setCompSeq(restVO.getCompSeq());
			    		creatorInfo.setDeptSeq(restVO.getDeptSeq());
			    		creatorInfo.setGroupSeq(restVO.getGroupSeq());
			    		
			    		JSONObject actionID = new JSONObject();
			    		actionID.put("emp_seq", restVO.getEmpSeq());
			    		
			    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_LOGIN, creatorInfo, action, actionID, sIpAddress, EnumDevice.PC);
			    	}
				}else{
					resultList.setResultCode("UC0000");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
				}				
							
			} else {
				resultList.setResultCode("UC0000");
				resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
			}
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			LOG.error("API 목록 조회 중 에러 : " + e.getMessage());
			resultList.setResultCode("LOGIN001");
			resultList.setResultMessage(BizboxAMessage.getMessage("","로그인시 문제가 발생하였습니다."));
		}

		return resultList;		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/CheckTwoFactorAuthentication", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse CheckTwoFactorAuthentication(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		APIResponse response = new APIResponse();
		
		
		Map<String, Object> reBody =  request.getBody();	
		reBody.put("type", "L");
		Map<String, Object> resultMap = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertInfo", reBody);		
		
		if(resultMap == null){
			response.setResultCode("ERR002");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000109","유효하지 않은 QR코드 입니다."));
			return response;
		}else if(resultMap.get("empDevCnt").toString().equals("0")){
			response.setResultCode("ERR004");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000110","이차인증을 위해 기기 등록이 필요하여 웹 페이지로 이동합니다."));
			return response;
		}
		
		String status = resultMap.get("status") + "";
		
		if(status.equals("S")){
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다."));
		}else if(status.equals("D")){
			response.setResultCode("ERR001");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000111","등록된 본인 인증기기가 아니므로 인증할 수 없습니다.\n관리자에게 문의하세요."));
		}else if(status.equals("F")){
			response.setResultCode("ERR003");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000112","이차인증 중 오류가 발생하였습니다."));
		}else if(status.equals("A")){
			response.setResultCode("ERR004");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000110","이차인증을 위해 기기 등록이 필요하여 웹 페이지로 이동합니다."));
		}else if(status.equals("H")){
			response.setResultCode("ERR005");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000113","이미 승인 대기중인 기기입니다.\n관리자에게 문의해주세요."));
		}else{
			response.setResultCode("ERR000");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000114","이차인증 확인 중입니다."));
		}
		
		return response;
	}

	@SuppressWarnings("unchecked")
	private boolean CheckAccessIp(String ipAddress, MessengerLoginVO loginVO) {
		//로그인 통제IP조회
		boolean accessFlag = true;
		try{
	    	Map<String, Object> paraMap = new HashMap<String, Object>();
	    	paraMap.put("empSeq", loginVO.getEmpSeq());
	    	paraMap.put("groupSeq", loginVO.getGroupSeq());
	    	List<Map<String, Object>> empInfoList = commonSql.list("EmpManage.getEmpInfoListAccess", paraMap);
	    	
	    	String compList = "";
	    	String compSeqList = "";
	    	
	    	
	    	for(Map<String, Object> mp : empInfoList){
	    		if(mp.get("mainDeptYn").toString().equals("Y")){
	    			compList += "," + mp.get("compSeq"); 
	    		}
	    		compSeqList += ",'" + mp.get("compSeq") + "'";
	    	}
	    	if(compList.length() > 0 ) {
	    		compList = compList.substring(1);
	    	}
	    	if(compSeqList.length() > 0) {
	    		compSeqList = compSeqList.substring(1);
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
		    			ipTemp = ipAddress.split("\\.");
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
		}catch(Exception e){
			accessFlag = false;
		}
	    	
		return accessFlag;
	} 
	
	public Map<String, Object> getPasswordOption(MessengerLoginVO restVO) {
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
    			
    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {
    				
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
    				
    				// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전 비밀번호, 6:키보드 일련배열
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
							termLength = BizboxAMessage.getMessage("TX000016780","3자리" + " ");
						}else if(inputLimitValue.indexOf("|4_4|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000016782","4자리" + " ");
						}else if(inputLimitValue.indexOf("|4_5|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000016784","5자리" + " ");
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
    	
    	result.put("inputDigitResult", inputDigitResult);
    	
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
    	
    	result.put("inputDueValueResult", inputDueValueResult);
		
		return result;
	}	
	
}
