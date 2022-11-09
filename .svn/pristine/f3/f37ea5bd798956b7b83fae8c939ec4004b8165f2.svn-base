package restful.mobile.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import cloud.CloudConnetInfo;

import api.common.model.APIResponse;
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
import egovframework.com.sym.log.clg.service.LoginLog;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.OutAuthentication;
import restful.com.service.AttachFileService;
import restful.mobile.service.RestfulService;
import restful.mobile.service.ResultList;
import restful.mobile.vo.GroupInfoVO;
import restful.mobile.vo.RestfulRequest;
import restful.mobile.vo.RestfulRequestHeader;
import restful.mobile.vo.RestfulVO;
import restful.mobile.vo.ResultVO;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.secondCertificate.service.impl.SecondCertificateServiceImpl;

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
public class RestfulController {

    private static final Log LOG = LogFactory.getLog(RestfulController.class);
    
    @Resource(name="LdapAdapterService")
	public LdapAdapterService ldapManageService;
    
	@Resource(name="RestfulService")
	private RestfulService restfulService;	
	
	@Resource(name = "loginService")
    private EgovLoginService loginService;	
	
	@Resource(name="GroupManageService")
	GroupManageService groupManageService;
	
	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name="EmpManageService")
	EmpManageService empManageService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="OrgAdapterService")
	OrgAdapterService orgAdapterService;	
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
    /*
     * post 호출 및 json 응답
     * 로그인 처리
     */
	@RequestMapping(value="/loginWS", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultList getLoginListPost(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		
		ResultList resultList  = new ResultList();
		Map<String, Object> reBody =  request.getBody();
		
		String groupSeq = (String) reBody.get("groupSeq");
		String loginId = (String) reBody.get("loginId");
		String loginPassword = (String) reBody.get("loginPassword");
		String osType = (String) reBody.get("osType");
		String appType = (String) reBody.get("appType");
		String appVer = (String) reBody.get("appVer");
		String programCd = (String) reBody.get("programCd");
		String model = (String) reBody.get("model");
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);
		
		
		if( groupSeq == null || groupSeq.length() == 0 || 
				loginId == null  || loginId.length() == 0 ||
				loginPassword == null || loginPassword.length() == 0 ) {

			MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
			return resultList;
		}		

		
		RestfulVO restVO = new RestfulVO();
		restVO.setGroupSeq(groupSeq);
		restVO.setLoginId(loginId);
		
        String enpassword  = CommonUtil.passwordEncrypt(loginPassword) ;
		restVO.setLoginPassword(enpassword);
		 
		
		
		/*************/
		
		
		try {
			
			// 아이디 존재 여부 확인 및 로그인 통제 옵션 값
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("loginId", loginId);
			mp.put("groupSeq", groupSeq);
			
	    	boolean loginIdExistCheck = loginService.loginIdExistCheck(mp); 
	    	
	    	// 로그인 block 상태
	    	String loginStatus = null;
	    	String loginIdCheck = null;
			
	    	if(loginIdExistCheck) { // 아이디가 존재
	    		loginIdCheck = loginId;
	    		mp.put("loginId", loginIdCheck);
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
	    		resultList.setResultMessage(BizboxAMessage.getMessage("TX800000115","장기간 미접속으로 잠금처리되었습니다. 관리자에게 문의하시기 바랍니다."));
				return resultList;	
	    	}
			
			String strLoginPassword = restfulService.selectLoginPassword(restVO);
			
			if(strLoginPassword == null || strLoginPassword.equals("") || !strLoginPassword.equals(enpassword)){			
				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
				
				// 로그인 실패 카운트 증가
				if(loginIdExistCheck) { // 아이디가 존재
					loginService.updateLoginFailCount(mp);
		    	}	
				
				return resultList;				
			}
			
			List<RestfulVO> pckgList = restfulService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				restVO.setEaType(pckgList.get(0).getEaType());
				List<Map<String,Object>> loginVOList = restfulService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);
					restVO.setCompanyList(loginVOList);
					
					/** 하이브리드웹 서버에서 사용될 정보 */
					restVO.setLoginCompanyId(restVO.getCompSeq());
					restVO.setLoginUserId(restVO.getLoginId());
					restVO.setAppVer(appVer);
					restVO.setOsType(osType);
					restVO.setAppType(appType);
					restVO.setProgramCd(programCd);
					restVO.setModel(model);
					restVO.setPassword_yn("1");
					
					Map<String,Object> pa = new HashMap<String,Object>();
					pa.put("ip", BizboxAProperties.getProperty("BizboxA.Mqtt.ip"));
					pa.put("port", BizboxAProperties.getProperty("BizboxA.Mqtt.port"));
					restVO.setMqttInfo(pa); 
					 
					resultList.setResult(restVO);
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
					Map<String,Object> groupMap = orgChartService.getGroupInfo(p);
					if (groupMap != null) {

						GroupInfoVO groupVO = new GroupInfoVO();
						groupVO.setSmsUrl(EgovStringUtil.nullConvert(groupMap.get("smsUrl")+""));
						groupVO.setMobileUrl(EgovStringUtil.nullConvert(groupMap.get("mobileUrl")+""));
						groupVO.setEdmsUrl(EgovStringUtil.nullConvert(groupMap.get("edmsUrl")+""));
						groupVO.setMailUrl(EgovStringUtil.nullConvert(groupMap.get("mailUrl")+""));
						groupVO.setMessengerUrl(EgovStringUtil.nullConvert(groupMap.get("messengerUrl")+""));
						
						restVO.setGroupInfo(groupVO);
					}
					
					LoginLog loginLog = new LoginLog();
					loginLog.setLoginId(restVO.getEmpSeq());
					loginLog.setLoginIp(CommonUtil.getClientIp(servletRequest));
					loginLog.setLoginMthd("MOBILE_LOGIN");
					loginLog.setErrOccrrAt("N");
					loginLog.setErrorCode("");					
					commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
					
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.common.", "SUCCESS");										
				}else{
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.common.", "UC0000");
			}
		} catch (Exception e) {
			LOG.error("API 목록 조회 중 에러 : " + e.getMessage());
			MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN001");
		}

		return resultList;		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/loginWSN", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultList getLoginListPost2(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		ResultList resultList  = new ResultList();
		Map<String, Object> reBody =  request.getBody();
		
		Logger.getLogger( SecondCertificateServiceImpl.class ).debug( "RestfulController loginWSN body: " + reBody);
		
		//외부SSO 패스워드 정책 예외처리용
		boolean outSSOYn = false;
		
		String sEnpassYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLogin");
		String sLdapLogonYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapLogon");
		String sLdapUseYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapUseYn");
		String groupSeq = (String) reBody.get("groupSeq");
		String loginId = (String) reBody.get("loginId");

		String loginPassword = reBody.get("loginPassword") == null ? "" : (String) reBody.get("loginPassword");
		String enpassword = reBody.get("ignorePasswdYn") != null && reBody.get("ignorePasswdYn").equals("Y") ? "▦" : "";
		
		String osType = (String) reBody.get("osType");
		String appType = (String) reBody.get("appType");
		String token = (String) reBody.get("token");
		String appVer = (String) reBody.get("appVer");
		String programCd = (String) reBody.get("programCd");
		String model = (String) reBody.get("model");
		String deviceRegId = reBody.get("deviceRegId") == null ? "" : reBody.get("deviceRegId").toString();
		String appConfirmYn = "N";
		
		String kNum = reBody.get("kNum") == null ? "" : (String) reBody.get("kNum");	//로그인 아이디/패스워드 암호화 키값 인덱스 (해당 인덱스에 해당하는 키값 조회 t_co_second_cert_encrypt)
		
		if(!kNum.equals("")) {
			//암호화 키값 조회
			Map<String, Object> encMap = new HashMap<String, Object>();
			encMap.put("groupSeq", groupSeq);
			encMap.put("keyNum", kNum);
			Map<String, Object> result = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertKey", encMap);
			String encKey = (String) result.get("key");
			
			loginId = AESCipher.AES256_Decode_UTF8(loginId, encKey);
			loginPassword = AESCipher.AES256_Decode_UTF8(loginPassword, encKey);
		}
		
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);
		
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
		

		
		if(!enpassword.equals("▦")) {
			
			if( groupSeq == null || groupSeq.length() == 0 || 
					loginId == null  || loginId.length() == 0 ||
					loginPassword == null || loginPassword.length() == 0 ) {

				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
				return resultList;
			}
			
			String outApiAuthentication = BizboxAProperties.getCustomProperty("BizboxA.Cust.outApiAuthentication");
			
			//외부 API인증 체크
			if(!outApiAuthentication.equals("99")) {
				
				if(OutAuthentication.outApiAuthentication(loginId, loginPassword)) {
					outApiAuthentication = "▦";
					outSSOYn = true;
				}
				
			}			
			
			if(outApiAuthentication.equals("▦")) {
				
				enpassword = "▦";
				
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
				enpassword  = CommonUtil.passwordEncrypt(loginPassword);	
			}			
		}
		
		RestfulVO restVO = new RestfulVO();
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
	    		MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
	    		return resultList;	
	    	}			
	    	
	    	if(loginStatus.contains("block")) {
	    		MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN002");
				return resultList;	
	    	}else if(loginStatus.equals("longTerm")) {
	    		resultList.setResultCode("LOGIN008");
	    		resultList.setResultMessage(BizboxAMessage.getMessage("TX800000115","장기간 미접속으로 잠금처리되었습니다. 관리자에게 문의하시기 바랍니다."));
				return resultList;
	    	}	    	
	    	
	    	if (!enpassword.equals("▦") && !sEnpassYn.equals("Y") && !sLdapLogonYn.equals("Y")) {
				String strLoginPassword = restfulService.selectLoginPassword(restVO);

				if(strLoginPassword == null || strLoginPassword.equals("") || !strLoginPassword.equals(enpassword)){			
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
					
					// 로그인 실패 카운트 증가
					if(loginIdExistCheck) { // 아이디가 존재
						loginService.updateLoginFailCount(loginMp);
			    	}	
					
					return resultList;			
				}
	    	}
			
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<RestfulVO> pckgList = restfulService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				restVO.setEaType(pckgList.get(0).getEaType());
				
				List<Map<String,Object>> loginVOList = restfulService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);
					restVO.setCompanyList(loginVOList);
					restVO.setBuildType(buildType);
					
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
					authParam.put("langCode", restVO.getNativeLangCode());
					
					Map<String, Object> authMap = (Map<String, Object>) commonSql.select("restDAO.selectEmpAuthList_new", authParam);
					
					if(authMap == null || authMap.get("empAuth") == null){
						resultList.setResultCode("UC0000");
						resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
						
						return resultList;
					}
					
					//Function List 조회
					restVO.setFunctionList(commonSql.list("restDAO.selectEmpFunctionList", authParam));
					
					//업무보고 근무시간, 모바일 출근체크 사용여부 (임시로 공통코드에 사용유무값 셋팅)
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("groupSeq", restVO.getGroupSeq());				
					params.put("empSeq", restVO.getEmpSeq());
					Map<String, Object> optionMap = (Map<String, Object>) commonSql.select("restDAO.selectExtOptionList", params);
					
					restVO.setUseReportAttendTime(optionMap.get("useReportAttendTime") == null ? "N" : (String)optionMap.get("useReportAttendTime"));
					restVO.setOnefficeReportUseYn(optionMap.get("onefficeReportUseYn") == null ? "N" : (String)optionMap.get("onefficeReportUseYn"));
					
					//출퇴근 사용시 사용자별 출근체크가능여부 확인 후 버튼 노출여부 결정
					JSONObject json = new JSONObject();
					json.put("accessType", "mobile");
					json.put("groupSeq", restVO.getGroupSeq());
					json.put("compSeq", restVO.getCompSeq());
					json.put("deptSeq", restVO.getDeptSeq());
					json.put("empSeq", restVO.getEmpSeq());
					
					String serverName = CommonUtil.getApiCallDomain(requests);
					String apiUrl = serverName + "/attend/external/api/gw/commuteCheckPermit";
							
					//사용자별 출근체크가능 여부 확인 API
					net.sf.json.JSONObject resultJson = CommonUtil.getPostJSON(apiUrl, json.toString());
					
					if(resultJson != null && resultJson.get("result").equals("SUCCESS")) {
						restVO.setUseMobileWorkCheck("Y");
					}else {
						restVO.setUseMobileWorkCheck("N");
					}
					
					// 전자결재 암호 입력 사용 여부
					restVO.setPassword_yn("1"); // 결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
					
					Map<String,Object> pa = new HashMap<String,Object>();
					pa.put("ip", BizboxAProperties.getProperty("BizboxA.Mqtt.ip"));
					pa.put("port", BizboxAProperties.getProperty("BizboxA.Mqtt.port"));
					restVO.setMqttInfo(pa); 
					 
					resultList.setResult(restVO);
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
					 * N : 알림(1회)
					 * */
					
					String passwdStatusCodeOld = restVO.getPasswdStatusCode();
					
					//SSO 예외처리 
					if(outSSOYn) {
						restVO.setPasswdStatusCode("P");
						passwdStatusCodeOld = "P";
					}else {
						restVO.setPasswdStatusCode(restfulService.getPasswdStatusCode(p));		
					}
					
					Map<String, Object> passwdResult = new HashMap<String, Object>();
					Map<String, Object> passwdOptions = new HashMap<String, Object>();
					String langCode = restVO.getNativeLangCode();
					String content = "";
					String title = "";
					
					/* 옵션 값 데이터 */
					passwdOptions = getPasswordOption(restVO);
					
					if(restVO.getPasswdStatusCode() != null && restVO.getPasswdStatusCode().contains("N")) {
						
						if(passwdStatusCodeOld != null && passwdStatusCodeOld.equals("N")) {
							restVO.setPasswdStatusCode("P");
						}else {
							String[] passwdStatusCodeArray = restVO.getPasswdStatusCode().split("\\|");
								
							title = BizboxAMessage.getMessage("","비밀번호 만료 안내");
							content = BizboxAMessage.getMessage("","매월 {0}일은 비밀번호 만료 일자입니다.") + "\r\n" + BizboxAMessage.getMessage("","비밀번호 만료 후 비밀번호 변경이 필요합니다.");
							
							if(passwdStatusCodeArray.length > 1) {
								content = content.replace("{0}", passwdStatusCodeArray[1]);
							}
							
							restVO.setPasswdStatusCode("N");
						}
					}
					
					if(passwdStatusCodeOld != null && restVO.getPasswdStatusCode() != null && passwdStatusCodeOld.equals("N") && restVO.getPasswdStatusCode().contains("N")) {
						restVO.setPasswdStatusCode("P");
					}
					
					if(passwdOptions != null) {
						passwdResult.put("passwdOption", passwdOptions);
					}
					
					if(restVO.getPasswdStatusCode().equals("P") || restVO.getPasswdStatusCode().equals("N")) {
						
						if(restVO.getPasswdStatusCode().equals("P")) {
							
							title = BizboxAMessage.getMessage("TX800000116","로그인 성공");
							content = BizboxAMessage.getMessage("TX800000104","정상적으로 로그인 되었습니다.");
							
						}
						
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
								    	if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && (devList.size() == 0 || ((Map<String, Object>)devList.get(0)).get("appConfrimCnt").toString().equals("0")) && secondCertInfo.get("range").toString().equals("M")){
											//app최초로그인인증처리사용여부(appConfirmYn)옵션값에 따른 자동기기등록 처리
								    		appConfirmYn = "Y";
								    		Map<String, Object> devRegInfo = setDevRegInfo(request, restVO, deviceRegId);
								    		deviceRegId = devRegInfo.get("oriDeviceRegId") + "";
								    		devRegInfo.remove("oriDeviceRegId");
								    		
								    		restVO.setDevRegInfo(devRegInfo);
								    		restVO.setUseTwoFactorAuthenticationYn("N"); 
								    		restVO.setUseDeviceRegYn("N");
								    	}else{
								    		if(!deviceRegId.equals("") && devList.size() != 0){
								    			restVO.setUseDeviceRegYn("Y");
								    			resultList.setResultCode("LOGIN007");
								    			resultList.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
								    		}else{
									    		restVO.setUseDeviceRegYn("Y");
										    	restVO.setUseTwoFactorAuthenticationYn("N");									    	
										    	resultList.setResultCode("LOGIN003");
												resultList.setResultMessage(BizboxAMessage.getMessage("TX800000118","이차인증 기기등록 후 로그인 가능합니다."));
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
						    				resultList.setResultCode("LOGIN004");
						    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000119","승인요청 중인 이차인증 기기입니다."));
						    			}else if(status.equals("D")){
						    				restVO.setUseDeviceRegYn("Y");
						    				resultList.setResultCode("LOGIN005");
						    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000120","승인요청이 반려된 이차인증 기기입니다."));
						    			}else if(status.equals("C")){
						    				
						    				if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && devType.equals("2") && secondCertInfo.get("range").toString().equals("M")){
						    					restVO.setUseDeviceRegYn("N");
						    					restVO.setAppConfirmYn("N");
							    				resultList.setResultCode("LOGIN009");
							    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000121","해지된 인증기기입니다. 모바일 앱 재설치 후 사용가능합니다."));
							    				return resultList;
						    				}else{
						    					restVO.setUseDeviceRegYn("Y");
							    				resultList.setResultCode("LOGIN006");
							    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000122","해지된 이차인증 기기입니다."));
						    				}
						    			}else{
							    			restVO.setUseDeviceRegYn("Y");
							    			resultList.setResultCode("LOGIN007");
							    			resultList.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
							    		}
								    }else{
								    	restVO.setUseDeviceRegYn("N");
								    }
								    
								    if(restVO.getUseDeviceRegYn().equals("Y")){
								    	resultList.setResult(restVO);
								    	return resultList;
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
						content = BizboxAMessage.getMessage("TX000022473", "그룹웨어에 처음 로그인 하셨습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서버스가 이용 가능합니다.", langCode);
						
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
					} else if(restVO.getPasswdStatusCode().equals("T")) {
						title = BizboxAMessage.getMessage("", "비밀번호 변경 안내", langCode);
						content = BizboxAMessage.getMessage("", "비밀번호 사용 기한이 지났습니다.\n비밀번호 설정 규칙에 따라 변경 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					}
					
					restVO.setPasswdStatus(passwdResult);
					
					loginLog.setLoginIp(ipAddress);
					loginLog.setLoginMthd("MOBILE_LOGIN");
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
			    		
			    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_LOGIN, creatorInfo, action, actionID, ipAddress, EnumDevice.Mobile);
			    	}
					
					//별도앱 인증을 위한 토큰정보 저장
					try{
						if(token != null && !token.equals("")){
							p.put("groupSeq", groupSeq);
							p.put("empSeq", restVO.getEmpSeq());
							p.put("osType", osType);
							p.put("appType", appType);
							p.put("token", token);
							commonSql.delete("EmpManageService.deleteOldToken", p);
							commonSql.insert("EmpManageService.insertNewToken", p);							
							
						}						
					} catch (Exception e) {
						CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					}					
					
				}else{
					resultList.setResultCode("UC0000");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				resultList.setResultCode("UC0000");
				resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
			}
		} catch (Exception e) {
			LOG.error("API 목록 조회 중 에러 : " + e.getMessage());
			resultList.setResultCode("LOGIN001");
			resultList.setResultMessage(BizboxAMessage.getMessage("TX000014274","로그인시 문제가 발생하였습니다."));
		}

		return resultList;		
	}
	
	
	@RequestMapping(value="/loginCheck", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse loginCheck(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		Map<String, Object> reBody =  request.getBody();
		APIResponse response = new APIResponse();
		
		Logger.getLogger( SecondCertificateServiceImpl.class ).debug( "RestfulController loginWSN body: " + reBody);
		
		String groupSeq = (String) reBody.get("groupSeq");
		String loginId = (String) reBody.get("loginId");
		String loginPassword = reBody.get("loginPassword") == null ? "" : (String) reBody.get("loginPassword");
		String enpassword  = CommonUtil.passwordEncrypt(loginPassword) ;
		String tId = (String)  (request.getHeader()).gettId();

		
		String buildType = CloudConnetInfo.getBuildType();
		
		//클라우드 개통상태 체크 
		if(buildType.equals("cloud")) {
    		JedisClient jedis = CloudConnetInfo.getJedisClient();
    		Map<String, Object> dbInfo = jedis.getParamMapByMobileId(groupSeq);
    		if(dbInfo != null && !dbInfo.get("OPERATE_STATUS").equals("20")){		
    			response.setResultCode("LOGIN000");
    			
    			if(dbInfo.get("OPERATE_STATUS").equals("0")) {
    				response.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 개통대기 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("10")) {
					response.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 개통중 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("19")) {
					response.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 개통완료 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("30")) {
					response.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 일시정지 상태입니다. 관리자에게 문의해주세요."));
				}else if(dbInfo.get("OPERATE_STATUS").equals("90")) {
					response.setResultMessage(BizboxAMessage.getMessage("","클라우드 서비스 점검 상태입니다. 관리자에게 문의해주세요."));
				}else {
					response.setResultMessage(BizboxAMessage.getMessage("TX800000032","클라우드 서비스 중지 상태입니다. 관리자에게 문의해주세요."));
				}

    			return response;	    			
    		}
		}
				
		RestfulVO restVO = new RestfulVO();
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
	    		MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN000");
	    		return response;	
	    	}			
	    	
	    	if(loginStatus.contains("block")) {
	    		MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN002");
				return response;	
	    	}else if(loginStatus.equals("longTerm")) {
	    		response.setResultCode("LOGIN008");
	    		response.setResultMessage(BizboxAMessage.getMessage("TX800000115","장기간 미접속으로 잠금처리되었습니다. 관리자에게 문의하시기 바랍니다."));
				return response;
	    	}	    	
			
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<RestfulVO> pckgList = restfulService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				List<Map<String,Object>> loginVOList = restfulService.selectLoginVO(restVO);
				Map<String, Object> result = new HashMap<String, Object>();

				if(loginVOList.size()>0){		
					result.put("empSeq", ((Map<String, Object>)loginVOList.get(0)).get("empSeq"));
					response.setResultCode("SUCCESS");
					response.setResult(result);
					response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				}else{
					response.setResultCode("UC0000");
					response.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
					MessageUtil.setApiMessage(response, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				response.setResultCode("UC0000");
				response.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
			}
		} catch (Exception e) {
			LOG.error("API 목록 조회 중 에러 : " + e.getMessage());
			response.setResultCode("LOGIN001");
			response.setResultMessage(BizboxAMessage.getMessage("TX000014274","로그인시 문제가 발생하였습니다."));
		}

		return response;		
	}
	
	
	
	
	@RequestMapping(value="/getSecuInfo", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSecuInfo(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> resultInfo = new HashMap<String, Object>();
		
		try {
			Map<String, Object> devRegInfo = new HashMap<String, Object>();
			Map<String, Object> passwdResult = new HashMap<String, Object>();
			String appConfirmYn = "N";
			String passwdStatusCode = "P";
			
			Map<String, Object> reBody =  request.getBody();
			String groupSeq = (String) reBody.get("groupSeq");
			String loginId = (String) reBody.get("loginId");
			String deviceRegId = reBody.get("deviceRegId") == null ? "" : reBody.get("deviceRegId").toString();
			
			RestfulVO restVO = new RestfulVO();
			restVO.setGroupSeq(groupSeq);
			restVO.setLoginId(loginId);
			restVO.setLoginPassword("▦");	
		
			// 아이디 존재 여부 확인 및 로그인 통제 옵션 값
			Map<String, Object> loginMp = new HashMap<String, Object>();
			loginMp.put("loginId", loginId);
			loginMp.put("groupSeq", groupSeq);

			/*
	    	// 로그인 block 상태
	    	String loginStatus = null;
			
			loginMp.put("loginId", loginId);
			loginStatus = loginService.loginOptionResult(loginMp);			
	    	
	    	if(loginStatus.contains("block")) {
				//실패횟수 초과 	
	    	}else if(loginStatus.equals("longTerm")) {
	    		//장기간 미접속으로 잠금
	    	}
	    	*/
			
			List<RestfulVO> pckgList = restfulService.actionLoginMobile(restVO);
			restVO = pckgList.get(0);	  
			
			//업무보고 근무시간, 모바일 출근체크 사용여부 (임시로 공통코드에 사용유무값 셋팅)
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("groupSeq", restVO.getGroupSeq());				
			params.put("empSeq", restVO.getEmpSeq());
			
			@SuppressWarnings("unchecked")
			Map<String, Object> optionMap = (Map<String, Object>) commonSql.select("restDAO.selectExtOptionList", params);
			
			String useReportAttendTime = optionMap.get("useReportAttendTime") == null ? "N" : (String)optionMap.get("useReportAttendTime");
			//restVO.setUseMobileWorkCheck(optionMap.get("useMobileWorkCheck") == null ? "N" : (String)optionMap.get("useMobileWorkCheck"));
			 
			Map<String,Object> p = new HashMap<String,Object>();
			p.put("groupSeq", groupSeq);
			p.put("empSeq", restVO.getEmpSeq());
			p.put("passwdStatusCode", restVO.getPasswdStatusCode());
			p.put("passwdDate", restVO.getPasswdDate());

			restVO.setPasswdStatusCode(restfulService.getPasswdStatusCode(p));
			passwdStatusCode = restVO.getPasswdStatusCode();
			
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
						    	if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && (devList.size() == 0 || ((Map<String, Object>)devList.get(0)).get("appConfrimCnt").toString().equals("0")) && secondCertInfo.get("range").toString().equals("M")){
									//app최초로그인인증처리사용여부(appConfirmYn)옵션값에 따른 자동기기등록 처리
						    		appConfirmYn = "Y";
						    		devRegInfo = setDevRegInfo(request, restVO, deviceRegId);
						    	}
						    }
						}
				    }
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
			Map<String,Object> passwdOptions = getPasswordOption(restVO);
			
			if(passwdOptions != null) {
				passwdResult.put("passwdOption", passwdOptions);
			}
			
			resultInfo.put("passwdStatusCode", passwdStatusCode);
			resultInfo.put("passwdStatus", passwdResult);
			resultInfo.put("appConfirmYn", appConfirmYn);
			resultInfo.put("devRegInfo", devRegInfo);
			resultInfo.put("useReportAttendTime", useReportAttendTime);
			
			result.put("result", resultInfo);
			result.put("resultCode", "SUCCESS");
			result.put("resultMessage", BizboxAMessage.getMessage("TX000011955","성공하였습니다"));			
						
		}catch(Exception ex) {
			result.put("result", resultInfo);
			result.put("resultCode", "LOGIN001");
			result.put("resultMessage", BizboxAMessage.getMessage("TX800000124","호출 시 문제가 발생하였습니다."));					
		}

		return result;		
	}	

	@RequestMapping(value="/loginToken", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultList getLoginListToken(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		ResultList resultList  = new ResultList();
		Map<String, Object> reBody =  request.getBody();
		
		
		String groupSeq = (String) reBody.get("groupSeq");
		String osType = (String) reBody.get("osType");
		String appType = (String) reBody.get("appType");
		String token = (String) reBody.get("token");
		String appVer = (String) reBody.get("appVer");
		String programCd = (String) reBody.get("programCd");
		String model = (String) reBody.get("model");		
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);
		
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
		
		if( groupSeq == null || groupSeq.equals("") || token == null  || token.equals("")) {
			MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
			return resultList;
		}		
		
		RestfulVO restVO = new RestfulVO();
		restVO.setGroupSeq(groupSeq);
		
		if(token != null){
			restVO.setLoginToken(token);	
		}
		
		try {
			
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<RestfulVO> pckgList = restfulService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				restVO.setEaType(pckgList.get(0).getEaType());
				List<Map<String,Object>> loginVOList = restfulService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);
					restVO.setCompanyList(loginVOList);
					restVO.setBuildType(buildType);
					
					/** 하이브리드웹 서버에서 사용될 정보 */
					restVO.setLoginCompanyId(restVO.getCompSeq());
					restVO.setLoginUserId(restVO.getLoginId());
					restVO.setAppVer(appVer);
					restVO.setOsType(osType);
					restVO.setAppType(appType);
					restVO.setProgramCd(programCd);
					restVO.setModel(model);
					restVO.setPassword_yn("1"); // 결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
					
					Map<String,Object> pa = new HashMap<String,Object>();
					pa.put("ip", BizboxAProperties.getProperty("BizboxA.Mqtt.ip"));
					pa.put("port", BizboxAProperties.getProperty("BizboxA.Mqtt.port"));
					restVO.setMqttInfo(pa); 
					 
					resultList.setResult(restVO);
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
						title = BizboxAMessage.getMessage("TX800000116","로그인 성공");
						content = BizboxAMessage.getMessage("TX800000104","정상적으로 로그인 되었습니다.");
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
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
					}
					
					/* 옵션 값 데이터 */
					passwdOptions = getPasswordOption(restVO);
					
					if(passwdOptions != null) {
						passwdResult.put("passwdOption", passwdOptions);
					}
					
					restVO.setPasswdStatus(passwdResult);
					loginLog.setLoginIp(CommonUtil.getClientIp(servletRequest));
					loginLog.setLoginMthd("MOBILE_TOKEN_LOGIN");
					loginLog.setErrOccrrAt("N");
					loginLog.setErrorCode("");	
					loginLog.setGroupSeq(restVO.getGroupSeq());
					
					commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
					commonSql.update("EmpManageService.initPasswordFailcount", p);
					
					resultList.setResultCode("SUCCESS");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
					
				}else{
					resultList.setResultCode("TOKEN0003");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX800000125","토큰이 존재하지 않습니다."));
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				resultList.setResultCode("TOKEN0003");
				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000125","토큰이 존재하지 않습니다."));
			}
		} catch (Exception e) {
			LOG.error("API 목록 조회 중 에러 : " + e.getMessage());
			resultList.setResultCode("LOGIN001");
			resultList.setResultMessage(BizboxAMessage.getMessage("TX000014274","로그인시 문제가 발생하였습니다."));
		}

		return resultList;		
	}
	
	@RequestMapping(value="/logoutToken", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultList getLogoutToken(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		Map<String, Object> reBody =  request.getBody();
		
		ResultList resultList  = new ResultList();
		
		Map<String,Object> p = new HashMap<String,Object>();
		p.put("groupSeq", (String) reBody.get("groupSeq"));
		p.put("delToken", (String) reBody.get("token"));
		
		commonSql.delete("EmpManageService.deleteOldToken", p);
		
		resultList.setResultCode("SUCCESS");
		resultList.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));			

		
		return resultList;

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
	    						
	    						inputDigitResult = BizboxAMessage.getMessage("TX000010842","최소") + min + " " + BizboxAMessage.getMessage("TX000022609","자리 이상 ") + max + " " + BizboxAMessage.getMessage("TX000022610","자리 이하로 입력해 주세요.");
	    						
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
	    				adapterParam.put("compSeq", resultVO.getOrganId());
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
    				adapterParam.put("compSeq", resultVO.getOrganId());
    				adapterParam.put("deptSeq", resultVO.getOrgnztId());
    				adapterParam.put("createSeq", resultVO.getUniqId());
    				adapterParam.put("loginPasswdNew", nPWD);	
    					
    				orgAdapterService.empSaveAdapter(adapterParam);
	    			
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
     * 패스워드 변경
     */
	@RequestMapping(value="/UpdateUserPwd", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO UpdateUserPwd(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,			
								@RequestBody RestfulRequest request
							) throws Exception {
		
		ResultVO resultList  = new ResultVO();

		Map<String, Object> reBody =  request.getBody();
		
		String loginId = (String) reBody.get("loginId");
		String oldPwd = (String) reBody.get("oPWD");
		String newPwd = (String) reBody.get("nPWD");
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);		
		
		
		LoginVO loginVO = null;
		try {
			loginVO = new LoginVO();

			loginVO.setId(loginId);
			oldPwd = EgovFileScrty.encryptPassword(oldPwd);
			loginVO.setPassword(oldPwd);
			loginVO.setUserSe("USER");

			LoginVO resutlLoginVO = loginService.actionLogin(loginVO, servletRequest);

			if(resutlLoginVO!=null){
				
				Map<String, Object> adapterParam = new HashMap<String,Object>();
				adapterParam.put("groupSeq", resutlLoginVO.getGroupSeq());
				adapterParam.put("callType", "updatePasswd");
				adapterParam.put("empSeq", resutlLoginVO.getUniqId());
				adapterParam.put("compSeq", resutlLoginVO.getCompSeq());
				adapterParam.put("deptSeq", resutlLoginVO.getOrgnztId());
				adapterParam.put("createSeq", resutlLoginVO.getUniqId());
				adapterParam.put("loginPasswdNew", newPwd);	
					
				Map<String, Object> adapterResult = orgAdapterService.empSaveAdapter(adapterParam);

				if(adapterResult.get("resultCode").equals("SUCCESS")){
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.password.", "UP0010");
				}else{
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.password.", "UP0020");					
				}
			}else{
				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.password.", "UP0020");
			}
		} catch (Exception e) {
			LOG.error("API 패스워드 변경 에러 : " + e.getMessage());
			MessageUtil.setApiMessage(resultList, servletRequest, "systemx.password.", "UP0020");
		}

		return resultList;		
	} 	

	
    /*
     * post 호출 및 json 응답
     * 기본로그인회사 변경
     */
	@RequestMapping(value="/UpdateMainCompany", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO UpdateMainCompany(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		
		
		ResultVO resultList  = new ResultVO();
		
		Map<String, Object> reBody =  request.getBody();
		
		String empSeq = (String) (request.getHeader()).getEmpSeq();
		String compSeq = (String) reBody.get("compSeq");
		String groupSeq = (String) (request.getHeader()).getGroupSeq();
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);		
		
		Map<String, Object> params = new HashMap<String,Object>();
		
		params.put("empSeq", empSeq);
		params.put("compSeq", compSeq);
		params.put("groupSeq", groupSeq);
		
		try {
			if(!EgovStringUtil.isEmpty(empSeq) && 
					!EgovStringUtil.isEmpty(compSeq)) {
				boolean bool = loginService.updateMainCompany(params);
				
				if (bool) {
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.user.comp.", "UP2010");
				} else {
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.user.comp.", "UP2020");
				}
				
			} else {
				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.user.comp.", "UP2020");
			}
			
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			
			MessageUtil.setApiMessage(resultList, servletRequest, "systemx.user.comp.", "UP2020");
		}
		
		
		return resultList;		
	} 	

	
	@RequestMapping(value="/UpdateUserImg", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO UpdateUserImg(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		
		
		ResultVO resultList  = new ResultVO();
		
		Map<String, Object> reBody =  request.getBody();
		
		String empSeq = (String) (request.getHeader()).getEmpSeq();
		String fileId = (String) reBody.get("fileId");
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);		
		
		Map<String, Object> params = new HashMap<String,Object>();
		
		params.put("empSeq", empSeq);
		params.put("picFileId", fileId);
		
		try {
			if(!EgovStringUtil.isEmpty(empSeq) && 
					!EgovStringUtil.isEmpty(fileId)) {
				boolean bool = loginService.updateUserImg(params);
				
				if (bool) {
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.pic.", "UP1010");
				} else {
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.pic.", "UP1020");
				}
			} else {
				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.pic.", "UP1020");
			}
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			MessageUtil.setApiMessage(resultList, servletRequest, "systemx.pic.", "UP1020");
		}
		return resultList;		
	} 
	
	 
	
	@RequestMapping("/ConvertImgBox.do")
	public ModelAndView ConvertImgBox( MultipartHttpServletRequest multiRequest,@RequestParam Map<String, Object> paramMap,  HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//파일 체크
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		if (files.isEmpty()) {
			resultMap.put("resultCode", "ERROR001");
			resultMap.put("resultMessage", BizboxAMessage.getMessage("TX000012040","파일이 존재하지 않습니다"));
		}
		if(files.size() == 1){		
			Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
			MultipartFile file = null;
			while (itr.hasNext()) {
				Entry<String, MultipartFile> entry = itr.next();
				file = entry.getValue();
			}
			
			String groupSeq = "";
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("osType", NeosConstants.SERVER_OS);
			param.put("pathSeq", "900");
			
			if(paramMap.get("groupSeq") != null){
				groupSeq = paramMap.get("groupSeq").toString();
				param.put("groupSeq", groupSeq);	
			}
			
			Map<String, Object> mp = (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", param);		

			String fileNm = EgovDateUtil.today("yyyy-MM-dd HHmmss");
			
			String fileExt = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")+1);
			
			String saveFilePath = mp.get("absolPath") + "/ConvertImgBox/" + paramMap.get("empSeq") + "/" + fileNm + "." + fileExt;
			
			EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath));
			
			String perspectFlag = paramMap.get("perspectFlag") == null ? "" : paramMap.get("perspectFlag").toString();
			String distortionOpt  = paramMap.get("distortionOpt") == null ? "" : paramMap.get("distortionOpt").toString();
			
			
			String url = "";
			url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/gw/convertImgBoxView.do?groupSeq=" + groupSeq + "&fileName=" + fileNm + "." + fileExt + "&empSeq=" + paramMap.get("empSeq") + "&perspectFlag=" + perspectFlag + "&distortionOpt=" + distortionOpt;
			
			resultMap.put("resultCode", "SUCCESS");
			resultMap.put("resultMessage", url);

		}
		
		mv.addAllObjects(resultMap);
		mv.setViewName("jsonView");
		
		return mv;		
	} 
	

	
	/**
	 * 한글을 UTF-8 형태 문자로 변환한다. (ex.과학 => %EA%B3%BC%ED%95%99)
	 * @param korean
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public String KorToUTF8 (String korean) throws UnsupportedEncodingException {
		return URLEncoder.encode(korean, "UTF-8");
	}
	
	/**
	 * 해당 문자가 숫자인지 판단한다.
	 * @param s
	 * @return
	 */
	public boolean isNumeric(String s) {
		if(EgovStringUtil.isEmpty(EgovStringUtil.nullConvert(s))) {
			return true;
		} else {
			java.util.regex.Pattern pattern = Pattern.compile("[+-]?\\d+"); 
			return pattern.matcher(s).matches(); 
		}
	} 

	/**
	 * 해당 문자가 숫자인지 판단한다.
	 * @param s
	 * @return
	 */
	public boolean isNumeric(int s) {
		String conv = String.valueOf(s);
		
		if(EgovStringUtil.isEmpty(EgovStringUtil.nullConvert(conv))) {
			return true;
		} else {
			java.util.regex.Pattern pattern = Pattern.compile("[+-]?\\d+"); 
			return pattern.matcher(conv).matches(); 
		}
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
    				
    				inputDueValue = temp.get("optionRealValue").toString();

        			if(inputDueValue != null && !inputDueValue.equals("")){
        				
        				if(inputDueValue.split("▦").length > 1) {
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
    				inputDueValueResult = BizboxAMessage.getMessage("","매월") + " " + inputAlertValue + BizboxAMessage.getMessage("","일 만료(종료)");
    			}else {
        			if(!inputDueValue.equals("0")) {
        				inputDueValueResult = inputDueValue + BizboxAMessage.getMessage("TX000022929","일");
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
	
	
	
	@RequestMapping(value="/getAlarmItemDetail", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse getCalendarList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();		
		APIResponse response = new APIResponse();		
		try{
			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("groupSeq", reHeader.getGroupSeq());
			param.put("compSeq", reBody.get("compSeq"));
			param.put("langCode", reBody.get("langCode"));
			param.put("detailCode", reBody.get("detailCode"));
			
			Map<String, Object> item = (Map<String, Object>) commonSql.select("alarmAdminMenu.selectAlarmItemMenuDetail", param);
			
			response.setResult(item);
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
	
		return response;		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/twoFactorAuthentication", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse secondCertification(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest req
							) throws Exception {
		
	
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();		
		APIResponse response = new APIResponse();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		String uuid = reBody.get("uuid") + "";
		String kNum = reBody.get("kNum") + "";
		String auSeq = reBody.get("auSeq") + "";
	    String deviceRegId = reBody.get("deviceRegId") == null ? "" : reBody.get("deviceRegId")+"";
	    String empSeq = "";
		
		try{
			param.put("groupSeq", reHeader.getGroupSeq());
		    
		    //키번호에따른 키값 조회
			param.put("keyNum", kNum);
			Map<String, Object> keyMp = (Map<String, Object>) commonSql.select("SecondCertManage.getEncryptKey", param); 
			
			//uuid 복호화 
			uuid = AESCipher.AES256_Decode(uuid, keyMp.get("key").toString());
			
			param.put("seq", auSeq);
//			param.put("type", "L");
			Map<String, Object> scInfoMap = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertInfo", param);
			if(scInfoMap == null){
				response.setResult(null);
				response.setResultCode("ERR001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000128","유효하지않은 QR코드 입니다."));
				
				return response;
			}
			
			empSeq = scInfoMap.get("empSeq").toString();
			param.remove("seq");
			param.remove("type");
			
			
			//이차인증 qr코드가 맞는지 확인
			if(!scInfoMap.get("type").equals("L")){
				response.setResult(null);
				response.setResultCode("ERR003");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000129","이차인증 QR코드가 아닙니다."));
				
				Map<String, Object> mp = new HashMap<String, Object>();		
		    	mp.put("status", "A");	    	
		    	mp.put("empSeq", empSeq);
		    	mp.put("groupSeq", reHeader.getGroupSeq());
				commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
				
				return response;
			}
			
			
		    //등록된 본인 인증기기가 맞는지 체크
		    Map<String, Object> mp = new HashMap<String, Object>();
		    mp.put("empSeq", empSeq);
		    mp.put("deviceNum", deviceRegId);
		    mp.put("status", "P");
		    mp.put("groupSeq", reHeader.getGroupSeq());
		    mp.put("devType", "1");
		    
		    List<Map<String, Object>> devList = commonSql.list("SecondCertManage.selectSecondCertDeviceList", mp);
		    mp.remove("devType");
		    List<Map<String, Object>> devList2 = commonSql.list("SecondCertManage.selectSecondCertDeviceList", mp);
		    
		    if(devList.size() == 0){ 
		    	mp.put("status", "R");
		    	devList = commonSql.list("SecondCertManage.selectSecondCertDeviceList", mp);
		    	
		    	if(devList2.size() != 0){
		    		mp.put("status", "T");
			    	mp.put("empSeq", empSeq);
					commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
			    	
			    	response.setResult(null);
					response.setResultCode("ERR005");
					response.setResultMessage(BizboxAMessage.getMessage("TX800000130","사용기기로는 이차인증 로그인이 불가합니다."));
		    	}else if(devList.size() != 0){
		    		mp.put("status", "H");
			    	mp.put("empSeq", empSeq);
					commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
			    	
			    	response.setResult(null);
					response.setResultCode("ERR004");
					response.setResultMessage(BizboxAMessage.getMessage("TX800000131","이미 승인 대기중인 기기 입니다."));
		    	}else{
			    	mp.put("status", "D");
			    	mp.put("empSeq", empSeq);
					commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
			    	
			    	response.setResult(null);
					response.setResultCode("ERR002");
					response.setResultMessage(BizboxAMessage.getMessage("TX800000132","등록된 본인 인증기기가 아닙니다."));
		    	}
				
				return response;
		    }
		    
			//복호화된 uuid및 인증 시퀀스 번호로 유효성여부 체크.
			param.put("uuid", uuid);
			param.put("seq", auSeq);
			param.put("status", "S");
			param.put("empSeq", empSeq);
			int checkValidateCnt = commonSql.update("SecondCertManage.ConfirmSecondCertInfo", param);
			
			//checkValidateCnt > 0 -> 인증성공
			//checkValidateCnt = 0 -> 인증실패
			if(checkValidateCnt > 0){
				//해당 디바이스 인증시간 업데이트
				commonSql.update("SecondCertManage.updateDeviceAuthDate", mp);				
				
				response.setResult(null);
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다."));
			}else{
				mp.clear();
		    	mp.put("status", "X");	    	
		    	mp.put("empSeq", empSeq);
		    	mp.put("groupSeq", reHeader.getGroupSeq());
				commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
				
				response.setResult(null);
				response.setResultCode("ERR001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000128","유효하지않은 QR코드 입니다."));
			}	
		}catch(Exception e){
			Map<String, Object> mp = new HashMap<String, Object>();		
	    	mp.put("status", "F");	    	
	    	mp.put("empSeq", empSeq);
	    	mp.put("groupSeq", reHeader.getGroupSeq());
			commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
			 
			response.setResult(null);
			response.setResultCode("ERR000");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000133","인차인증 중 오류가 발생하였습니다."));
		}
		return response;		
	}
	
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/twoFactorAuthenticationDeviceReg", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse twoFactorAuthenticationDeviceReg(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest req
							) throws Exception {
		
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();		
		APIResponse response = new APIResponse();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		String deviceRegId = reBody.get("deviceRegId") + "";
		String oldDeviceRegId = reBody.get("oldDeviceRegId") == null ? "" : (String)reBody.get("oldDeviceRegId");
		String kNum = reBody.get("kNum") + "";
		String auSeq = reBody.get("auSeq") + "";
	    String appType = reBody.get("appType") + "";
	    String osType = reBody.get("osType") + "";
	    String model = reBody.get("model") + "";
	    String groupSeq = reHeader.getGroupSeq();
	    String empSeq = "";
	    String loginId = reBody.get("loginId") + "";
	    String loginPasswd = reBody.get("loginPasswd") + "";
	    String devType = reBody.get("type") + "";
	    
	    
	    try{
	    		    	//키번호에따른 키값 조회
			param.put("keyNum", kNum);
			param.put("groupSeq", groupSeq);
			Map<String, Object> keyMp = (Map<String, Object>) commonSql.select("SecondCertManage.getEncryptKey", param); 
			
			//디바이스ID 복호화
			deviceRegId = AESCipher.AES256_Decode(deviceRegId, keyMp.get("key").toString());
			
			//최초등록시 빈값
			if(!oldDeviceRegId.equals("")) {
				oldDeviceRegId = AESCipher.AES256_Decode(oldDeviceRegId, keyMp.get("key").toString());
			}
			
			param.put("seq", auSeq);
			Map<String, Object> scInfoMap = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertInfo", param);
			if(scInfoMap == null){
				response.setResult(null);
				response.setResultCode("ERR006");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000128","유효하지않은 QR코드 입니다."));
				
				return response;
			}			
			
			empSeq = scInfoMap.get("empSeq") + "";
			
			
			//기기등록 qr코드가 맞는지 확인.
			if(!scInfoMap.get("type").toString().equals("D")){
				response.setResult(null);
				response.setResultCode("ERR007");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000128","인증기기등록 QR코드가 아닙니다."));
				
				Map<String, Object> mp = new HashMap<String, Object>();		
		    	mp.put("status", "A");	    	
		    	mp.put("empSeq", empSeq);
		    	mp.put("groupSeq", groupSeq);
				commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
				
				return response;
			}
			
			//사용자정보 존재유무 확인
			Map<String, Object> sMap = new HashMap<String, Object>();
	    	sMap.put("loginId", loginId);
	    	sMap.put("loginPasswd", loginPasswd);
	    	sMap.put("groupSeq", groupSeq);
	    	
	    	Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmpInfoByIdPwd", sMap);
	    	
	    	if(empInfo == null){
	    		Map<String, Object> mp = new HashMap<String, Object>();		
		    	mp.put("status", "E");	    	
		    	mp.put("empSeq", empSeq);
		    	mp.put("groupSeq", groupSeq);
				commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
				 
				response.setResult(null);
				response.setResultCode("ERR005");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000135","사용자 정보가 일치하지 않습니다."));
				
				return response;
	    	}
			
			
			
			//사용자정보로 등록된 인증기기리스트 조회
		    Map<String, Object> mp = new HashMap<String, Object>();
//		    mp.put("empSeq", empSeq);
		    mp.put("groupSeq", groupSeq);
		    mp.put("isRegYn", "Y");
			List<Map<String, Object>> devList = commonSql.list("SecondCertManage.selectUsedDeviceInfo", mp);
			
			
			//2차인증 옵션값조회
			Map<String, Object> scOptionMap = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertOption", param);
			int chkDevCnt = Integer.parseInt(scOptionMap.get("deviceCnt").toString());
			
			
			String statusCode = "";
			
			//등록된 인증기기가 없을경우 성공처리
			if(devList.size() == 0){
				statusCode = "S";
			}
			else{
				for(Map<String, Object> devMp : devList){
					if(devMp.get("deviceNum").toString().equals(oldDeviceRegId)){
						//등록된 본인인증기기가 아님
						if(!devMp.get("empSeq").toString().equals(empSeq)){						
							statusCode = "M";
						}
						//사용기기->인증기기 변경불가
						else if(devType.equals("1") && !devMp.get("type").equals("1")){
							statusCode = "W";
						}
						//승인대기 중인 인증기기
						else if(devMp.get("status").toString().equals("R")){						
							statusCode = "H";
						}						
						//이미등록된 기기
						else if(devType.equals("2") && devMp.get("empSeq").toString().equals(empSeq)){						
							statusCode = "Q";  
						}
						break;					
					}
				}
				//이차인증 기기등록 성공처리("S")
				if(statusCode.equals("")){
					statusCode = "S";
				}
			}
			
			
			if(statusCode.equals("S")){
				
				String devStatus = scOptionMap.get("approvalYn").toString().equals("Y") ? "R" : "P";
				
				//이차인증기기 등록테이블 저장.
				Map<String, Object> scDevInfoMap = new HashMap<String, Object>();
				scDevInfoMap.put("groupSeq", groupSeq);
				scDevInfoMap.put("deviceNum", deviceRegId);
				scDevInfoMap.put("empSeq", empSeq);
				scDevInfoMap.put("compSeq", groupSeq);
				scDevInfoMap.put("devType", devType);
				scDevInfoMap.put("status", devStatus);
				scDevInfoMap.put("appType", appType);
				scDevInfoMap.put("osType", osType);
				scDevInfoMap.put("deviceName", model);
				scDevInfoMap.put("deviceNickName", "");
				scDevInfoMap.put("desc", "");
				
				
				//사용자 회사시퀀스(주회사 시퀀스) 조회
				Map<String, Object> empMap = (Map<String, Object>) commonSql.select("EmpManage.selectEmp", scDevInfoMap);
				scDevInfoMap.put("compSeq", empMap.get("mainCompSeq"));
				
				//인증기기 등록/변경일 경우 기존 인증기기 데이터 삭제후 저장
				if(devType.equals("1")) {
					commonSql.delete("SecondCertManage.deleteSecondCertDeviceInfo", scDevInfoMap);
				}
				
				commonSql.insert("SecondCertManage.insertSecondCertDeviceInfo", scDevInfoMap);			
			}
			
			//이차인증 정보상태값 업데이트
			Map<String, Object> paraMap = new HashMap<String, Object>();
			paraMap.put("groupSeq", groupSeq);
			paraMap.put("seq", auSeq);
			paraMap.put("status", statusCode);
			paraMap.put("empSeq", empSeq);
			paraMap.put("type", "D");
			int checkValidateCnt = commonSql.update("SecondCertManage.ConfirmSecondCertInfo", paraMap);
			
			//checkValidateCnt > 0 -> 인증성공
			//checkValidateCnt = 0 -> 인증실패
			if(checkValidateCnt > 0){
				String resultCode = "";
				String resultMsg = "";
				response.setResult(null);
				
				if(statusCode.equals("W")){
					resultCode = "ERR001";
					resultMsg = BizboxAMessage.getMessage("TX800000136","기존 사용기기를 해치 후 인증기기로 등록 가능합니다.");
				}else if(statusCode.equals("H")){
					resultCode = "ERR002";
					resultMsg = BizboxAMessage.getMessage("TX800000137","등록한 인증기기가 승인 대기 중에 있습니다.");
				}else if(statusCode.equals("Q")){
					resultCode = "ERR003";
					resultMsg = BizboxAMessage.getMessage("TX800000138","이미 등록된 기기입니다.");
				}else if(statusCode.equals("M")){
					resultCode = "ERR004";
					resultMsg = BizboxAMessage.getMessage("TX800000132","등록된 본인 인증기기가 아닙니다.");
				}else{
					resultCode = "SUCCESS";
					resultMsg = BizboxAMessage.getMessage("TX000011955","성공하였습니다.");
				}
				
				response.setResultCode(resultCode);
				response.setResultMessage(resultMsg);
			}else{
				mp.clear();
		    	mp.put("status", "X");	    	
		    	mp.put("empSeq", empSeq);
		    	mp.put("groupSeq", reHeader.getGroupSeq());
				commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
				
				response.setResult(null);
				response.setResultCode("ERR006");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000128","유효하지않은 QR코드 입니다."));
			}			
	    }catch(Exception e){
			Map<String, Object> mp = new HashMap<String, Object>();		
	    	mp.put("status", "F");	    	
	    	mp.put("empSeq", empSeq);
	    	mp.put("groupSeq", groupSeq);
			commonSql.update("SecondCertManage.ConfirmSecondCertInfo", mp);
			 
			response.setResult(null);
			response.setResultCode("ERR000");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000139","이차인증 기기등록 중 오류가 발생하였습니다."));
		}		
		return response;		
	}
	
	
	
	
	@RequestMapping(value="/empPersonnelCardInfo", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse empPersonnelCardInfo(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest req
							) throws Exception {
		
		Map<String, Object> reBody =  request.getBody();
		RestfulRequestHeader reHeader = request.getHeader();		
		APIResponse response = new APIResponse();
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		
		try{
			String groupSeq = reHeader.getGroupSeq();
		    String empSeq = reBody.get("empSeq") == null ? "" : reBody.get("empSeq").toString();
		    String compSeq = reBody.get("compSeq") == null ? "" : reBody.get("compSeq").toString();
		    String targetEmpSeq = reBody.get("targetEmpSeq") == null ? "" : reBody.get("targetEmpSeq").toString();
		    
		    param.put("groupSeq", groupSeq);
		    param.put("empSeq", empSeq);
		    param.put("compSeq", compSeq);
		    param.put("targetEmpSeq", targetEmpSeq);
		    
		    
		    Map<String, Object> result = restfulService.checkEmpPersonnelCardInfo(param);
		    
		    
		    //filePath 파라미터 미사용처리로 빈값으로만 셋팅
//		    if(result.get("filePath") != null && !"".equals(result.get("filePath").toString())){
//		    	String domain = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort();
//		    	String url = "/gw/cmm/file/personnelCardPdfViewer.do?fileId=" + result.get("fileId") + "&groupSeq=" + groupSeq + "&empSeq=" + empSeq + "&compSeq=" + compSeq + "&isRestFul=Y";
//		    	result.put("filePath", domain + url);
//		    }
		    
		    response.setResultCode("SUCCESS");
		    response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다."));
		    response.setResult(result);
	    }catch(Exception e){
	    	response.setResultCode("CO0000");
	    	response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));
		}		
		return response;		
	}
	
	
	private Map<String, Object> setDevRegInfo(RestfulRequest request, RestfulVO restVO, String deviceId) {
		
		Map<String, Object> reBody =  request.getBody();
		
		Map<String, Object> devRegInfo = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("groupSeq", restVO.getGroupSeq());	
		
		String deviceRegId = commonSql.select("MsgDAO.getToken", params) + "";
		deviceRegId = deviceRegId.replaceAll("-", "");
		
		deviceRegId = deviceId.equals("") ? deviceRegId : deviceId;

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
		String key = keyInfoMap.get("key") + "";
		
		//디바이스ID 복호화
		deviceRegId = AESCipher.AES256_Encode(deviceRegId, keyInfoMap.get("key").toString());
		
		devRegInfo.put("deviceRegId", deviceRegId);
		devRegInfo.put("kNum", keyNum);
		
		return devRegInfo;
	}
	
	
	@RequestMapping(value="/getCustInfoList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse getCustInfoList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest req
							) throws Exception {
		
		APIResponse response = new APIResponse();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try{
			
			JedisClient jedis = CloudConnetInfo.getJedisClient();
			List<Map<String, String>> list = jedis.getCustInfoList();
		    
			result.put("custInfoList", list);
			
		    response.setResultCode("SUCCESS");
		    response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다."));
		    response.setResult(result);
	    }catch(Exception e){
	    	response.setResultCode("CO0000");
	    	response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));
		}		
		return response;		
	}
	
	
	
	@RequestMapping(value="/getMenuList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse getMenuList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest req
							) throws Exception {
		
		APIResponse response = new APIResponse();
		Map<String, Object> params = new HashMap<>();
		
		try{
			Map<String, Object> reBody =  request.getBody();
			params.put("groupSeq", (request.getHeader()).getGroupSeq());
			params.put("menuList", reBody.get("menuList"));
			params.put("langCode", reBody.get("langCode"));
			
			List<Map<String, Object>> resultList = commonSql.list("restDAO.getMenuList", params);
			
			response.setResultCode("SUCCESS");
		    response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다."));
			response.setResult(resultList);
	    }catch(Exception e){
	    	response.setResultCode("CO0000");
	    	response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));
		}		
		return response;		
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/loginWSNEnc", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultList loginWSNEnc(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request,
								HttpServletRequest requests
							) throws Exception {
		
		ResultList resultList  = new ResultList();
		Map<String, Object> reBody =  request.getBody();
		
		Logger.getLogger( SecondCertificateServiceImpl.class ).debug( "RestfulController loginWSN body: " + reBody);
		
		//외부SSO 패스워드 정책 예외처리용
		boolean outSSOYn = false;
		
		String sEnpassYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLogin");
		String sLdapLogonYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapLogon");
		String sLdapUseYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapUseYn");
		String groupSeq = (String) reBody.get("groupSeq");
		String loginId = (String) reBody.get("loginId");
		String loginPassword = reBody.get("loginPassword") == null ? "" : (String) reBody.get("loginPassword");
		String kNum = (String) reBody.get("kNum");	//로그인 아이디/패스워드 암호화 키값 인덱스 (해당 인덱스에 해당하는 키값 조회 t_co_second_cert_encrypt)
		
		String enpassword = reBody.get("ignorePasswdYn") != null && reBody.get("ignorePasswdYn").equals("Y") ? "▦" : "";
		
		String osType = (String) reBody.get("osType");
		String appType = (String) reBody.get("appType");
		String token = (String) reBody.get("token");
		String appVer = (String) reBody.get("appVer");
		String programCd = (String) reBody.get("programCd");
		String model = (String) reBody.get("model");
		String deviceRegId = reBody.get("deviceRegId") == null ? "" : reBody.get("deviceRegId").toString();
		String appConfirmYn = "N";
		
		String tId = (String)  (request.getHeader()).gettId();
		resultList.settId(tId);
		
		String buildType = CloudConnetInfo.getBuildType();
		
		
		//암호화 키값 조회
		Map<String, Object> encMap = new HashMap<String, Object>();
		encMap.put("groupSeq", groupSeq);
		encMap.put("keyNum", kNum);
		Map<String, Object> result = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertKey", encMap);
		String encKey = (String) result.get("key");
		
		loginId = AESCipher.AES256_Decode(loginId, encKey);
		loginPassword = AESCipher.AES256_Decode(loginPassword, encKey);
		
		
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
		

		
		if(!enpassword.equals("▦")) {
			
			if( groupSeq == null || groupSeq.length() == 0 || 
					loginId == null  || loginId.length() == 0 ||
					loginPassword == null || loginPassword.length() == 0 ) {

				MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
				return resultList;
			}
			
			String outApiAuthentication = BizboxAProperties.getCustomProperty("BizboxA.Cust.outApiAuthentication");
			
			//외부 API인증 체크
			if(!outApiAuthentication.equals("99")) {
				
				if(OutAuthentication.outApiAuthentication(loginId, loginPassword)) {
					outApiAuthentication = "▦";
					outSSOYn = true;
				}
				
			}			
			
			if(outApiAuthentication.equals("▦")) {
				
				enpassword = "▦";
				
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
				enpassword  = CommonUtil.passwordEncrypt(loginPassword);	
			}			
		}
		
		RestfulVO restVO = new RestfulVO();
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
	    		MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
	    		return resultList;	
	    	}			
	    	
	    	if(loginStatus.contains("block")) {
	    		MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN002");
				return resultList;	
	    	}else if(loginStatus.equals("longTerm")) {
	    		resultList.setResultCode("LOGIN008");
	    		resultList.setResultMessage(BizboxAMessage.getMessage("TX800000115","장기간 미접속으로 잠금처리되었습니다. 관리자에게 문의하시기 바랍니다."));
				return resultList;
	    	}	    	
	    	
	    	if (!enpassword.equals("▦") && !sEnpassYn.equals("Y") && !sLdapLogonYn.equals("Y")) {
				String strLoginPassword = restfulService.selectLoginPassword(restVO);

				if(strLoginPassword == null || strLoginPassword.equals("") || !strLoginPassword.equals(enpassword)){			
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.login.", "LOGIN000");
					
					// 로그인 실패 카운트 증가
					if(loginIdExistCheck) { // 아이디가 존재
						loginService.updateLoginFailCount(loginMp);
			    	}	
					
					return resultList;			
				}
	    	}
			
	    	restVO.setScheme(requests.getScheme() + "://");
	    	
			List<RestfulVO> pckgList = restfulService.actionLoginMobile(restVO);
			
			if(pckgList != null && pckgList.size() > 0) {
				
				restVO.setEaType(pckgList.get(0).getEaType());
				
				List<Map<String,Object>> loginVOList = restfulService.selectLoginVO(restVO);

				if(loginVOList.size()>0){

					restVO = pckgList.get(0);
					restVO.setCompanyList(loginVOList);
					restVO.setBuildType(buildType);
					
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
					authParam.put("langCode", restVO.getNativeLangCode());
					
					Map<String, Object> authMap = (Map<String, Object>) commonSql.select("restDAO.selectEmpAuthList", authParam);
					
					if(authMap == null || authMap.get("empAuth") == null){
						resultList.setResultCode("UC0000");
						resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
						
						return resultList;
					}
					
					//Function List 조회
					restVO.setFunctionList(commonSql.list("restDAO.selectEmpFunctionList", authParam));
					
					//업무보고 근무시간, 모바일 출근체크 사용여부 (임시로 공통코드에 사용유무값 셋팅)
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("groupSeq", restVO.getGroupSeq());				
					params.put("empSeq", restVO.getEmpSeq());
					Map<String, Object> optionMap = (Map<String, Object>) commonSql.select("restDAO.selectExtOptionList", params);
					
					restVO.setUseReportAttendTime(optionMap.get("useReportAttendTime") == null ? "N" : (String)optionMap.get("useReportAttendTime"));
					restVO.setOnefficeReportUseYn(optionMap.get("onefficeReportUseYn") == null ? "N" : (String)optionMap.get("onefficeReportUseYn"));
					
					//출퇴근 사용시 사용자별 출근체크가능여부 확인 후 버튼 노출여부 결정
					JSONObject json = new JSONObject();
					json.put("accessType", "mobile");
					json.put("groupSeq", restVO.getGroupSeq());
					json.put("compSeq", restVO.getCompSeq());
					json.put("deptSeq", restVO.getDeptSeq());
					json.put("empSeq", restVO.getEmpSeq());
					
					String serverName = CommonUtil.getApiCallDomain(requests);
					String apiUrl = serverName + "/attend/external/api/gw/commuteCheckPermit";
							
					//사용자별 출근체크가능 여부 확인 API
					net.sf.json.JSONObject resultJson = CommonUtil.getPostJSON(apiUrl, json.toString());
					
					if(resultJson != null && resultJson.get("result").equals("SUCCESS")) {
						restVO.setUseMobileWorkCheck("Y");
					}else {
						restVO.setUseMobileWorkCheck("N");
					}
					
					
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
					
					//메뉴리스트 조회 (모바일 메뉴 다국어 처리용)
					/*
					if(reBody.get("menuList") != null) {
						Map<String,Object> para = new HashMap<String,Object>();
						para.put("groupSeq", groupSeq);
						para.put("langCode", restVO.getNativeLangCode());
						para.put("menuList", reBody.get("menuList"));
						
						restVO.setMenuList(commonSql.list("restDAO.getMenuList", para));
					}
					*/
					 
					resultList.setResult(restVO);
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
					 * N : 알림(1회)
					 * */
					
					String passwdStatusCodeOld = restVO.getPasswdStatusCode();
					
					//SSO 예외처리 
					if(outSSOYn) {
						restVO.setPasswdStatusCode("P");
						passwdStatusCodeOld = "P";
					}else {
						restVO.setPasswdStatusCode(restfulService.getPasswdStatusCode(p));		
					}
					
					Map<String, Object> passwdResult = new HashMap<String, Object>();
					Map<String, Object> passwdOptions = new HashMap<String, Object>();
					String langCode = restVO.getNativeLangCode();
					String content = "";
					String title = "";
					
					/* 옵션 값 데이터 */
					passwdOptions = getPasswordOption(restVO);
					
					if(restVO.getPasswdStatusCode() != null && restVO.getPasswdStatusCode().contains("N")) {
						
						if(passwdStatusCodeOld != null && passwdStatusCodeOld.equals("N")) {
							restVO.setPasswdStatusCode("P");
						}else {
							String[] passwdStatusCodeArray = restVO.getPasswdStatusCode().split("\\|");
								
							title = BizboxAMessage.getMessage("","비밀번호 만료 안내");
							content = BizboxAMessage.getMessage("","매월 {0}일은 비밀번호 만료 일자입니다.") + "\r\n" + BizboxAMessage.getMessage("","비밀번호 만료 후 비밀번호 변경이 필요합니다.");
							
							if(passwdStatusCodeArray.length > 1) {
								content = content.replace("{0}", passwdStatusCodeArray[1]);
							}
							
							restVO.setPasswdStatusCode("N");
						}
					}
					
					if(passwdStatusCodeOld != null && restVO.getPasswdStatusCode() != null && passwdStatusCodeOld.equals("N") && restVO.getPasswdStatusCode().contains("N")) {
						restVO.setPasswdStatusCode("P");
					}
					
					if(passwdOptions != null) {
						passwdResult.put("passwdOption", passwdOptions);
					}
					
					if(restVO.getPasswdStatusCode().equals("P") || restVO.getPasswdStatusCode().equals("N")) {
						
						if(restVO.getPasswdStatusCode().equals("P")) {
							
							title = BizboxAMessage.getMessage("TX800000116","로그인 성공");
							content = BizboxAMessage.getMessage("TX800000104","정상적으로 로그인 되었습니다.");
							
						}
						
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
								    	if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && (devList.size() == 0 || ((Map<String, Object>)devList.get(0)).get("appConfrimCnt").toString().equals("0")) && secondCertInfo.get("range").toString().equals("M")){
											//app최초로그인인증처리사용여부(appConfirmYn)옵션값에 따른 자동기기등록 처리
								    		appConfirmYn = "Y";
								    		Map<String, Object> devRegInfo = setDevRegInfo(request, restVO, deviceRegId);
								    		deviceRegId = devRegInfo.get("oriDeviceRegId") + "";
								    		devRegInfo.remove("oriDeviceRegId");
								    		
								    		restVO.setDevRegInfo(devRegInfo);
								    		restVO.setUseTwoFactorAuthenticationYn("N"); 
								    		restVO.setUseDeviceRegYn("N");
								    	}else{
								    		if(!deviceRegId.equals("") && devList.size() != 0){
								    			restVO.setUseDeviceRegYn("Y");
								    			resultList.setResultCode("LOGIN007");
								    			resultList.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
								    		}else{
									    		restVO.setUseDeviceRegYn("Y");
										    	restVO.setUseTwoFactorAuthenticationYn("N");									    	
										    	resultList.setResultCode("LOGIN003");
												resultList.setResultMessage(BizboxAMessage.getMessage("TX800000118","이차인증 기기등록 후 로그인 가능합니다."));
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
						    				resultList.setResultCode("LOGIN004");
						    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000119","승인요청 중인 이차인증 기기입니다."));
						    			}else if(status.equals("D")){
						    				restVO.setUseDeviceRegYn("Y");
						    				resultList.setResultCode("LOGIN005");
						    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000120","승인요청이 반려된 이차인증 기기입니다."));
						    			}else if(status.equals("C")){
						    				
						    				if(secondCertInfo.get("appConfirmYn").toString().equals("Y") && devType.equals("2") && secondCertInfo.get("range").toString().equals("M")){
						    					restVO.setUseDeviceRegYn("N");
						    					restVO.setAppConfirmYn("N");
							    				resultList.setResultCode("LOGIN009");
							    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000121","해지된 인증기기입니다. 모바일 앱 재설치 후 사용가능합니다."));
							    				return resultList;
						    				}else{
						    					restVO.setUseDeviceRegYn("Y");
							    				resultList.setResultCode("LOGIN006");
							    				resultList.setResultMessage(BizboxAMessage.getMessage("TX800000122","해지된 이차인증 기기입니다."));
						    				}
						    			}else{
							    			restVO.setUseDeviceRegYn("Y");
							    			resultList.setResultCode("LOGIN007");
							    			resultList.setResultMessage(BizboxAMessage.getMessage("TX800000117","본인의 인증기기가 아닙니다."));
							    		}
								    }else{
								    	restVO.setUseDeviceRegYn("N");
								    }
								    
								    if(restVO.getUseDeviceRegYn().equals("Y")){
								    	resultList.setResult(restVO);
								    	return resultList;
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
						content = BizboxAMessage.getMessage("TX000022473", "그룹웨어에 처음 로그인 하셨습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서버스 이용이 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("C")) {
						title = BizboxAMessage.getMessage("TX000022593", "비밀번호 설정규칙 변경 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000106", "시스템관리자에 의해 비밀번호 설정규칙이 변경되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스 이용이 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("D")) {
						title = BizboxAMessage.getMessage("", "비밀번호 만료 안내", langCode);
						content = BizboxAMessage.getMessage("", "비밀번호가 만료되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스 이용이 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("R")) {
						title = BizboxAMessage.getMessage("TX000022591", "비밀번호 재설정 안내", langCode);
						content = BizboxAMessage.getMessage("TX800000108", "시스템관리자에 의해 비밀번호가 초기화되었습니다.\n비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스 이용이 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					} else if(restVO.getPasswdStatusCode().equals("T")) {
						title = BizboxAMessage.getMessage("", "비밀번호 변경 안내", langCode);
						content = BizboxAMessage.getMessage("", "비밀번호 사용 기한이 지났습니다.\n비밀번호 설정 규칙에 따라 변경 가능합니다.", langCode);
						
						passwdResult.put("content", content);
						passwdResult.put("title", title);
					}
					
					restVO.setPasswdStatus(passwdResult);
					
					loginLog.setLoginIp(ipAddress);
					loginLog.setLoginMthd("MOBILE_LOGIN");
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
			    		
			    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_LOGIN, creatorInfo, action, actionID, ipAddress, EnumDevice.Mobile);
			    	}
					
					//별도앱 인증을 위한 토큰정보 저장
					try{
						if(token != null && !token.equals("")){
							p.put("groupSeq", groupSeq);
							p.put("empSeq", restVO.getEmpSeq());
							p.put("osType", osType);
							p.put("appType", appType);
							p.put("token", token);
							commonSql.delete("EmpManageService.deleteOldToken", p);
							commonSql.insert("EmpManageService.insertNewToken", p);							
							
						}						
					} catch (Exception e) {
						CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					}					
					
				}else{
					resultList.setResultCode("UC0000");
					resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
					MessageUtil.setApiMessage(resultList, servletRequest, "systemx.common.", "UC0000");
				}				
							
			} else {
				resultList.setResultCode("UC0000");
				resultList.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
			}
		} catch (Exception e) {
			LOG.error("API 목록 조회 중 에러 : " + e.getMessage());
			resultList.setResultCode("LOGIN001");
			resultList.setResultMessage(BizboxAMessage.getMessage("TX000014274","로그인시 문제가 발생하였습니다."));
		}

		return resultList;		
	}
}

