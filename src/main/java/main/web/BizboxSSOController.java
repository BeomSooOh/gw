package main.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import main.service.MainService;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;

import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import api.fax.util.AES128Util;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.log.clg.service.LoginLog;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.util.AESCipher;
import neos.cmm.util.SEEDCipher;
import neos.cmm.util.UtilCryptoOuter;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
public class BizboxSSOController {
	@Resource(name="MainService")
	MainService mainService;
	
	@Resource(name="OrgChartService")
	OrgChartService orgChartService;
	
	@Resource(name="EmpManageService")
	EmpManageService empManageService;
	
	@Resource(name="GroupManageService")
	GroupManageService groupManageService;
	
	/** EgovLoginService */
	@Resource(name = "loginService")
    private EgovLoginService loginService;
	
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	
	@RequestMapping("/MsgLogOn.do")
	public ModelAndView MsgLogOn(@RequestParam(value="linkType", required=false) String linkType,
 
								 @RequestParam(value="ssoToken", required=false) String ssoToken, 
								 @ModelAttribute("loginVO") LoginVO loginVO, 
								 @RequestParam Map<String,Object> para,
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		// SSO확인작업
		if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.MsgIgnoreOutSSO").equals("Y") && !BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLogin").equals("Y") && !BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon").equals("99")) {
			
			if(request.getSession().getAttribute("custSSO") == null) {
				mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon"));

				request.getSession().setAttribute("custSSO", "Y");
				
				request.getSession().setAttribute("linkType", linkType);
				request.getSession().setAttribute("ssoToken", ssoToken);
				return mv;
			} else {
				request.getSession().setAttribute("custSSO", null);
				linkType = request.getSession().getAttribute("linkType").toString();
				ssoToken = request.getSession().getAttribute("ssoToken").toString();
			}
		}
		
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("linkType", linkType);
    	params.put("ssoToken", ssoToken);
    	params.put("groupSeq", para.get("groupSeq"));
    	
    	/** 링크메뉴정보 가져오기 **/
    	Map<String,Object> linkInfo = mainService.selectLinkMenuInfo(params);
    	
    	if (Integer.parseInt(String.valueOf(linkInfo.get("ret"))) > 0) {
    		
    		//메뉴얼 링크 버튼인 경우 리다이렉트 처리
    		if(linkInfo.get("msgTarget").toString().equals("manual")){
    			Map<String, Object> mp = new HashMap<String, Object>();
    			mp.put("groupSeq", linkInfo.get("groupSeq"));
    			Map<String, Object> groupInfo = groupManageService.getGroupInfo(mp);
    			if(groupInfo != null){
    				mv.setViewName("redirect:/manual.do?type=lnb&name=messenger");
    				return mv;
    			}
    		}
	    	
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) linkInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) linkInfo.get("compSeq"));
	    	loginVO.setUniqId((String) linkInfo.get("empSeq"));
	    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	//출퇴근 체크 
	    	if(linkInfo.get("linkKind").equals("A")) {
	    		
				String jsonParam =	 "{\"empSeq\":\"" + resultVO.getUniqId() + "\", \"deptSeq\":\"" + resultVO.getOrgnztId() + "\", \"compSeq\":\"" + resultVO.getOrganId() + "\", \"groupSeq\":\"" + resultVO.getGroupSeq() + "\", \"connectExtIp\":\"" + CommonUtil.getClientIp(request) + "\", \"connectIp\":\"" + linkInfo.get("loginIp") + "\", \"gbnCode\":\"" + linkInfo.get("linkParam") + "\"}";
				String apiUrl = CommonUtil.getApiCallDomain(request) + "/attend/external/api/gw/insertComeLeaveEventMessenger";

				JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
				HttpJsonUtil httpJson = new HttpJsonUtil();
				@SuppressWarnings("static-access")
				String empAttCheck = httpJson.execute("POST", apiUrl, jsonObject2);
				
				Map<String, Object> map = new HashMap<String, Object>();
				ObjectMapper mapper = new ObjectMapper();
				map = mapper.readValue(empAttCheck, new TypeReference<Map<String, String>>(){});			
				mv.addAllObjects(map);			    		
	    		mv.setViewName("jsonView");

	    		return mv;	    		
	    		
	    	}
    		
	    	Map<String,Object> lInfo = new HashMap<String,Object>();
	    	lInfo.put("no", linkInfo.get("menuNo"));
	    	lInfo.put("name", linkInfo.get("linkNmKr"));
	    	lInfo.put("url", linkInfo.get("urlPath"));
	    	lInfo.put("urlGubun", linkInfo.get("msgTarget"));
	    	lInfo.put("mainForward", "");
	    	lInfo.put("gnbMenuNo", linkInfo.get("gnbMenuNo"));
	    	lInfo.put("lnbMenuNo", linkInfo.get("lnbMenuNo"));
	    	lInfo.put("portletType", "");
	    	
	    	lInfo.put("linkType", linkType);
	    	lInfo.put("ssoToken", ssoToken);
	    	lInfo.put("eventType", linkInfo.get("eventType"));
	    	lInfo.put("eventSubType", linkInfo.get("eventSubType"));
	    	lInfo.put("msgTargetFlag", para.get("msgTargetFlag"));
	    	lInfo.put("messengerViewType", linkInfo.get("messengerViewType"));
	    	lInfo.put("moduleTp", linkInfo.get("moduleTp"));
	    	
	    	String msgTarget = (String) linkInfo.get("msgTarget");
	    	
	    	//외부URL연결
	    	if (msgTarget.toLowerCase().equals("out_link")){
	    		lInfo.put("url", linkInfo.get("linkParam"));
	    	}
	    	
	    	request.getSession().invalidate();
	    	
			request.getSession().setAttribute("firstGnbRenderTp", "SSO");
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("ssoLinkInfo", lInfo);
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", linkInfo.get("groupSeq"));
	    	mp.put("compSeq", linkInfo.get("compSeq"));
	    	
        	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
        	request.getSession().setAttribute("langCode", resultVO.getLangCode());
        	request.setAttribute("langCode", resultVO.getLangCode());
        	
	    	if (msgTarget.toLowerCase().equals("main")){
	    		mv.setViewName("redirect:/userMain.do");
	    	}else if (msgTarget.toLowerCase().equals("tax")){ //메신저 날개 연말정산 링크 추가
	    		mv.setViewName("redirect:http://stax.duzon.com");
	    	}else{
	    		mv.setViewName("redirect:/bizboxSSO.do");
	    	}
	    	
	    	request.getSession().setAttribute("forceLogoutYn", "N");
	    	
    	}
    	else{
    		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99"){
        		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon"));
        	}else{
        		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
        	}
    	}
    	
		return mv;
	}
	
	@RequestMapping("/SetGerpSession.do")
	public ModelAndView SetGerpSession(@RequestParam(value="ssoToken", required=false) String ssoToken, 
	    		                 HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("ssoToken", ssoToken);

    	Map<String,Object> ssoInfo = mainService.selectTokenInfo(params);
    	
    	try{
        	if(ssoInfo != null){
        		
    	    	/** SSO 처리 **/
    	    	String userSe = "USER";
    	    	LoginVO loginVO = new LoginVO();
    	    	loginVO.setUserSe(userSe);
    	    	loginVO.setGroupSeq((String) ssoInfo.get("groupSeq"));
    	    	loginVO.setCompSeq((String) ssoInfo.get("compSeq"));
    	    	loginVO.setUniqId((String) ssoInfo.get("empSeq"));
    	    	 	
    	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);    		
    	    	request.getSession().invalidate();
    	    	request.getSession().setAttribute("loginVO", resultVO);
    	    	
    	    	Map<String, Object> mp = new HashMap<String, Object>();
    	    	mp.put("groupSeq", ssoInfo.get("groupSeq"));
    	    	mp.put("compSeq", ssoInfo.get("compSeq"));
        		
            	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
            	request.getSession().setAttribute("optionSet", optionSet);
            	request.getSession().setAttribute("langCode", resultVO.getLangCode());
            	request.setAttribute("langCode", resultVO.getLangCode());
				request.getSession().setAttribute("SetGerpSession", "Y");
            	
				mv.setViewName("redirect:/forwardIndex.do");
				return mv;
            	
        	}else{
        		mv.addObject("result : ","No users or tokens have expired.");
        	}    		
    	}catch(Exception e){
    		mv.addObject("result : ",e.getMessage());
    	}
    	
    	mv.setViewName("jsonView");
    	
		return mv;
	}	

	@RequestMapping("/CustLogOn.do")
	public ModelAndView CustLogOn(
								 @ModelAttribute("loginVO") LoginVO loginVO, 
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
		request.getSession().setAttribute("loginVO", null);
	    ModelAndView mv = new ModelAndView();
    	Map<String,Object> params = new HashMap<String,Object>();
    	
    	String ssoId = (String) request.getSession().getAttribute("SSO_ID");
    	
    	if(ssoId != null){
        	params.put("ssoToken", ssoId);
			if(BizboxAProperties.getCustomProperty("BizboxA.Cust.skFlag").equals("Y")){
				params.put("skFlag", "Y");	
			}
        	Map<String,Object> custInfo = mainService.selectCustInfo(params);
        	
        	if(custInfo != null){
            	/** SSO 처리 **/
            	String userSe = "USER";
            	loginVO.setUserSe(userSe);
            	loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
            	loginVO.setCompSeq((String) custInfo.get("compSeq"));
            	loginVO.setUniqId((String) custInfo.get("empSeq"));
            	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
            	request.getSession().invalidate();
            	request.getSession().setAttribute("firstGnbRenderTp", "SSO");
            	request.getSession().setAttribute("loginVO", resultVO);
            	
            	Map<String, Object> mp = new HashMap<String, Object>();
    	    	mp.put("groupSeq", custInfo.get("groupSeq"));
    	    	mp.put("compSeq", custInfo.get("compSeq"));
            	
            	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
            	request.getSession().setAttribute("optionSet", optionSet);
            	request.setAttribute("langCode", resultVO.getLangCode());
            	
            	//접속기록 저장
				LoginLog loginLog = new LoginLog();
				loginLog.setLoginId(loginVO.getUniqId());
				loginLog.setLoginIp(CommonUtil.getClientIp(request));
				loginLog.setLoginMthd("WEB_LOGIN_CUST");
				loginLog.setErrOccrrAt("N");
				loginLog.setErrorCode("");
				loginLog.setGroupSeq(loginVO.getGroupSeq());
				commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
            	mv.setViewName("redirect:/userMain.do");
            	
        	}else if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogOnFailAlert").equals("Y")) {
        		mv.addObject("alertMsg","그룹웨어 사용 권한이 없습니다.");
        		mv.addObject("html","관리자에게 문의 바랍니다.");
        		mv.setViewName("/neos/alertContents");
        	}else{        		
        		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
        	}
    	}else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
    	request.getSession().setAttribute("forceLogoutYn", "N");
    	
		return mv;
		
	}
	
	
	@RequestMapping("/ChangeEbpSession.do")
	public ModelAndView ChangeEbpSession(
								@RequestParam Map<String,Object> params,
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
	    ModelAndView mv = new ModelAndView();
	    LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
	    
    	String changeCompSeq = (String) params.get("compSeq");
    	String changeLangCode = (String) params.get("langCode");
    	
    	if(!EgovStringUtil.isEmpty(changeCompSeq) && !EgovStringUtil.isEmpty(changeLangCode) && loginVO != null){
            	/** SSO 처리 **/
            	String userSe = "USER";
            	loginVO.setUserSe(userSe);
            	loginVO.setCompSeq((String) changeCompSeq);
            	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
            	
            	if(resultVO.getUniqId() == null) {
            		mv.setViewName("jsonView");
            		mv.addObject("resultCode","SESSION003");
            		mv.addObject("resultMsg", BizboxAMessage.getMessage("TX000021830","입력 파라미터 값이 올바르지 않습니다."));
            		Logger.getLogger( BizboxSSOController.class ).debug( "ChangeEbpSession.SESSION003 : " + BizboxAMessage.getMessage("TX000021830","입력 파라미터 값이 올바르지 않습니다.") );
            		return mv;
            	}
            	
            	resultVO.setLangCode(changeLangCode);
            	request.getSession().invalidate();
            	request.getSession().setAttribute("loginVO", resultVO);
            	
            	Map<String, Object> mp = new HashMap<String, Object>();
    	    	mp.put("groupSeq", loginVO.getGroupSeq());
    	    	mp.put("compSeq", changeCompSeq);
            	
            	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
            	request.getSession().setAttribute("optionSet", optionSet);
            	request.getSession().setAttribute("outLogOn", "Y");
            	request.setAttribute("langCode", changeLangCode);
            	
            	//접속기록 저장
				LoginLog loginLog = new LoginLog();
				loginLog.setLoginId(loginVO.getUniqId());
				loginLog.setLoginIp(CommonUtil.getClientIp(request));
				loginLog.setLoginMthd("WEB_LOGIN_CUST");
				loginLog.setErrOccrrAt("N");
				loginLog.setErrorCode("");
				loginLog.setGroupSeq(loginVO.getGroupSeq());
				commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog); 
				
				request.getSession().setAttribute("ChangeEbpSession","Y");
				
				mv.setViewName("redirect:/bizboxOutLogOn.do");	
        }else {
        	mv.setViewName("jsonView");
        	if(loginVO == null) {
        		mv.addObject("resultCode","SESSION001");
        		mv.addObject("resultMsg", BizboxAMessage.getMessage("TX000009248","로그인한 세션이 종료되었습니다."));
        		Logger.getLogger( BizboxSSOController.class ).debug( "ChangeEbpSession.SESSION001 : " + BizboxAMessage.getMessage("TX000009248","로그인한 세션이 종료되었습니다.") );
        	}else {
        		mv.addObject("resultCode","SESSION002");
        		mv.addObject("resultMsg", BizboxAMessage.getMessage("TX000021600","필수 파라미터가 누락되었습니다.") );
        		Logger.getLogger( BizboxSSOController.class ).debug( "ChangeEbpSession.SESSION002 : " + BizboxAMessage.getMessage("TX000021600","필수 파라미터가 누락되었습니다.") );
        	}
        }
		return mv;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/CustEncLogOn.do")
	public ModelAndView CustEncLogOn(
								@RequestParam Map<String,Object> params,
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
		request.getSession().setAttribute("loginVO", null);
	    ModelAndView mv = new ModelAndView();
	    mv.setViewName("redirect:/uat/uia/actionLogout.do");
    	
	    String ssoKey = "";
	    String ssoId = null;
	    String url = "";
	    String mainForward = "";
	    String bizboxaToken = request.getHeader("bizboxa-token");
	    
	    //IOS 브라우저 팝업 SSO연결을 위한 GET파라미터 조회추가
	    if(bizboxaToken == null && params.get("bizboxa-token") != null) {
	    	
	    	bizboxaToken = params.get("bizboxa-token").toString();
	    	
	    	String encKey = "91584538416524987548152156489712";
	    	
	    	if(params.get("kNum") != null) {
	    		String[] encKeyStr = ("hjdidsflkndlkjgnwekljgnewklrgjne|njnuifwbuebsdbajbfhgbrwubfebdjgh|irwnndsjkngejgnlkenjdangjkhasiwq|eqicjsvhsnxklsjsudeidhdumsjfeenc|kdjdwndiddnejrlfjsdjkdsngnqivxkk|dkaayshcyeisnvoegsuzmfudkswocksd|palfucjrgdbhjbdxldgkdgnebbeflnaa|ndgjdhgnajdnsyfugberuabgjlarbjbr|cxvoijbosdfjonwfjihwnkldfnhwnhjr|dfnkjbhnwfhwiounhriwnidsfnidngid|||||||").split("\\|");
	    		encKey = encKeyStr[Integer.parseInt(params.get("kNum").toString())];
	    	}
	    	
	    	bizboxaToken = AESCipher.AES256_Decode_UTF8(bizboxaToken, encKey);
	    	
    		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
    		
    		DateTime nowDt = DateTime.now().minusMinutes(5);
    		
    		DateTime ssoDt = formatter.parseDateTime(bizboxaToken.substring(0, 14));
    		
    		if(ssoDt.isAfter(nowDt)){
    			bizboxaToken = bizboxaToken.substring(14);
    		}else {
    			bizboxaToken = "";
    		}
	    }
	    
	    Logger.getLogger( BizboxSSOController.class ).debug( "BizboxSSOController.CustEncLogOn.do  params : " + params );
	    Logger.getLogger( BizboxSSOController.class ).debug( "BizboxSSOController.CustEncLogOn.do  bizboxaToken : " + bizboxaToken );
	    
	    try{
	    	//Empass
	    	if(request.getSession().getAttribute("_enpassKey_") != null) {
	    		ssoId = request.getSession().getAttribute("_enpassKey_").toString();
	    		request.getSession().removeAttribute("_enpassKey_");
	    	}else if(bizboxaToken != null && !bizboxaToken.equals("")){
	    		//모바일 token 기반 SSO처리
	    		Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
	    		String mobileGatewayUrl = groupInfo.get("mobileGatewayUrl") + "";
	    		String mobileId = groupInfo.get("mobileId") + "";
	    		Map<String, Object> searchTokenInfo = CommonUtil.SearchTokenInfo(bizboxaToken, mobileGatewayUrl, mobileId);
	    		
	    		if(searchTokenInfo != null && searchTokenInfo.get("resultCode").equals("0")){
					Map<String, Object> resultInfo = (Map<String, Object>) searchTokenInfo.get("result");
					Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmpInfoByEmpSeq", resultInfo);

					ssoId = empInfo.get("loginId") + "";
					url = params.get("url").toString();
				}
	    	}else {
		    	params.put("ssoKey", ((String)params.get("ssoKey")).replace(" ", "+"));
		    	
		    	String aesKey = "1023497555960596";
		    	//하드코드된 중요정보: 암호화 키
		    	Properties prop = new Properties();
		    	aesKey = aesKey == null ? (String)prop.getProperty("key") : "1023497555960596";//하드코드된 중요정보: 암호화 키
		    	
		    	if(params.get("groupSeq") != null && !params.get("groupSeq").equals("") && params.get("encKeyType") != null && params.get("encKeyType").equals("custom")) {
		    		aesKey = AESCipher.AES_GetKey(params.get("groupSeq").toString());
		    	}
		    	
		    	ssoKey = AESCipher.AES128EX_Decode((String) params.get("ssoKey"), aesKey);
		    	
		    	String[] keyVal = ssoKey.split("▦", -1);
		    	
		    	if(keyVal.length < 2) {
		    		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
		    		
		    		DateTime nowDt = DateTime.now().minusMinutes(2);
		    		
		    		DateTime ssoDt = formatter.parseDateTime(ssoKey.substring(0, 14));
		    		
		    		if(ssoDt.isAfter(nowDt)){
		    			ssoId = ssoKey.substring(14);
		    		}	    		
		    	}else {
		    		
		    		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
		    		
		    		DateTime nowDt = DateTime.now().minusMinutes(2);
		    		
		    		DateTime ssoDt = formatter.parseDateTime(keyVal[0]);
		    		
		    		if(ssoDt.isAfter(nowDt)){
		    			ssoId = keyVal[1];
		    			
		    			if(keyVal.length > 2){
		    				url = keyVal[2];
		    				params.put("url", url);
		    			}else if(params.get("url") != null) {
		    				url = params.get("url").toString();
		    			}
		    		}
		    	}	    		
	    	}
	    	
	    }catch(Exception e){
	    	mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
	    	return mv;
	    }
	    
    	if(ssoId != null && ssoId != ""){
        	params.put("ssoToken", ssoId);
        	Map<String,Object> custInfo = mainService.selectCustInfo(params);
        	
        	if(custInfo != null){
            	/** SSO 처리 **/
            	LoginVO loginVO = new LoginVO();
            	loginVO.setUserSe("USER");
            	loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
            	loginVO.setCompSeq((String) custInfo.get("compSeq"));
            	loginVO.setUniqId((String) custInfo.get("empSeq"));
            	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
            	request.getSession().invalidate();
            	request.getSession().setAttribute("firstGnbRenderTp", "SSO");
            	request.getSession().setAttribute("loginVO", resultVO);
            	
            	Map<String, Object> mp = new HashMap<String, Object>();
    	    	mp.put("groupSeq", custInfo.get("groupSeq"));
    	    	mp.put("compSeq", custInfo.get("compSeq"));
            	
            	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
            	request.getSession().setAttribute("optionSet", optionSet);
            	request.setAttribute("langCode", resultVO.getLangCode());
            	
            	//접속기록 저장
				LoginLog loginLog = new LoginLog();
				loginLog.setLoginId(loginVO.getUniqId());
				loginLog.setLoginIp(CommonUtil.getClientIp(request));
				loginLog.setLoginMthd("WEB_LOGIN_CUST");
				loginLog.setErrOccrrAt("N");
				loginLog.setErrorCode("");
				loginLog.setGroupSeq(loginVO.getGroupSeq());
				commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
				
				if(params.get("pType") != null) {
					
		    		if(!params.get("pType").equals("main") && !params.get("pType").equals("")) {
		    			
		    			if(params.get("pSeq") != null && !params.get("pSeq").equals("0")) {
		    				
		    				//상세조회 
		    	    		if(params.get("pType").equals("mail")) {
		    	    			url = resultVO.getUrl() + "readMailPopApi.do?muid=" + params.get("pSeq") + "&email=" + resultVO.getEmail() + "@" + resultVO.getEmailDomain();
		    	    		}
		    	    		else if(params.get("pType").equals("edms")) {
		    	    			url = request.getScheme() + "://" + request.getServerName()+":"+request.getServerPort() + "/edms/board/viewPost.do?boardNo=" + params.get("pSeq") + "&artNo=" + params.get("pMenu");
		    	    		}
		    	    		else if(params.get("pType").equals("ea")) {
		    	    			url = request.getScheme() + "://" + request.getServerName()+":"+request.getServerPort() + "/ea/edoc/eapproval/docCommonDraftView.do?multiViewYN=Y&diSeqNum=0000000001&miSeqNum=0000000001&diKeyCode=" + params.get("pSeq");
		    	    		}
		    	    		else if(params.get("pType").equals("eap")) {
		    	    			url = request.getScheme() + "://" + request.getServerName()+":"+request.getServerPort() + "/eap/ea/docpop/EAAppDocViewPop.do?doc_id=" + params.get("pSeq") + "&form_id=" + params.get("pMenu");
		    	    		}		    	    		
		    	    		
		    	    		params.put("url", url);
		    				
		    			}else {
		    				
		    				params.put("linkType", "L");
		    				params.put("eventType", "");
		    				params.put("eventSubType", "");
		    				
		    				//대메뉴이동 
		    				if(params.get("pType").equals("mail")){
		    					params.put("urlGubun", "mail");
		    					params.put("no", "200000000");
		    					params.put("name", BizboxAMessage.getMessage("TX000000262","메일"));
		    					params.put("lnbName", "");
		    					params.put("url", resultVO.getUrl());
		    				}else if(params.get("pType").equals("edms")){
		    					params.put("urlGubun", "edms");
		    					params.put("no", "500000000");
		    					params.put("name", BizboxAMessage.getMessage("TX000011134","게시판"));
		    					params.put("lnbName", "");
		    					params.put("url", "");		    					
		    				}else if(params.get("pType").equals("ea")){
		    					params.put("urlGubun", "ea");
		    					params.put("no", "100000000");
		    					params.put("name", BizboxAMessage.getMessage("TX000000479","전자결재"));
		    					params.put("lnbName", "");
		    					params.put("url", "");			    					
		    				}else if(params.get("pType").equals("eap")){
		    					params.put("urlGubun", "eap");
		    					params.put("no", "2000000000");
		    					params.put("name", BizboxAMessage.getMessage("TX000000479","전자결재"));
		    					params.put("lnbName", "");
		    					params.put("url", "");			    					
		    				}
		    				
		    				mainForward = "mainForward";
		    				
		    			}
		    		}					
				}
				
				if(params.get("mainForward") != null) {
					mainForward = params.get("mainForward").toString();
				}
				
				if(!url.equals("") || mainForward.equals("mainForward")) {
					
					if(!mainForward.equals("mainForward")) {
						params.put("urlGubun", "sessionRedirect");	
					}
					
					request.getSession().setAttribute("ssoLinkInfo", params);
					mv.setViewName("redirect:/forwardIndex.do");
					
				}else {
					mv.setViewName("redirect:/userMain.do");
				}
				
				request.getSession().setAttribute("forceLogoutYn", "N");
            	
        	}
    	}
    	
		return mv;
	}	
	
	
	@RequestMapping("/CustSeedEncLogOn.do")
	public ModelAndView CustSeedEncLogOn(
								@RequestParam Map<String,Object> params,
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
		request.getSession().setAttribute("loginVO", null);
	    ModelAndView mv = new ModelAndView();
    	
	    String ssoKey = "";
	    String ssoId = null;
	    
	    try{

	    	ssoKey = SEEDCipher.getSeedDec((String) params.get("ssoKey"));
	    	
	    	String[] keyVal = ssoKey.split("▦", -1);
	    	
	    	if(keyVal.length > 1){
	    		
	    		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	    		
	    		DateTime nowDt = DateTime.now().minusMinutes(2);
	    		
	    		DateTime ssoDt = formatter.parseDateTime(keyVal[0]);
	    		
	    		if(ssoDt.isAfter(nowDt)){
	    			ssoId = keyVal[1];
	    		}
	    	}
	    	
	    }catch(Exception e){
	    	mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
	    	return mv;
	    }
	    
    	if(ssoId != null && ssoId != ""){
        	params.put("ssoToken", ssoId);
        	Map<String,Object> custInfo = mainService.selectCustInfo(params);
        	
        	if(custInfo != null){
            	/** SSO 처리 **/
            	LoginVO loginVO = new LoginVO();
            	loginVO.setUserSe("USER");
            	loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
            	loginVO.setCompSeq((String) custInfo.get("compSeq"));
            	loginVO.setUniqId((String) custInfo.get("empSeq"));
            	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
            	request.getSession().invalidate();
            	request.getSession().setAttribute("firstGnbRenderTp", "SSO");
            	request.getSession().setAttribute("loginVO", resultVO);
            	
            	Map<String, Object> mp = new HashMap<String, Object>();
    	    	mp.put("groupSeq", custInfo.get("groupSeq"));
    	    	mp.put("compSeq", custInfo.get("compSeq"));
            	
            	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
            	request.getSession().setAttribute("optionSet", optionSet);
            	request.setAttribute("langCode", resultVO.getLangCode());
            	
            	//접속기록 저장
				LoginLog loginLog = new LoginLog();
				loginLog.setLoginId(loginVO.getUniqId());
				loginLog.setLoginIp(CommonUtil.getClientIp(request));
				loginLog.setLoginMthd("WEB_LOGIN_CUST");
				loginLog.setErrOccrrAt("N");
				loginLog.setErrorCode("");
				loginLog.setGroupSeq(loginVO.getGroupSeq());
				commonSql.insert("LoginLogDAO.logInsertLoginLog", loginLog);
            	
            	mv.setViewName("redirect:/userMain.do");	
            	
            	request.getSession().setAttribute("forceLogoutYn", "N");
            	
        	}else{        		
        		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
        	}
    	}else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
		return mv;
	}
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/extSSOLogin.do")
	public ModelAndView extSSOLogin(@RequestParam Map<String,Object> para, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();

		try{
			String token = AES128Util.AES_Decode(para.get("token")+"");
			String moduleTp = para.get("moduleTp") + "";
			String type = para.get("type") + "";
			
			String checkTime = token.substring(0, 14);
			String loginId = token.substring(14);
			String groupSeq = para.get("groupSeq") + "";
			
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("checkTime", checkTime);
			mp.put("id", loginId);
			mp.put("groupSeq",  groupSeq);
			mp.put("moduleTp", moduleTp);
			mp.put("type", type);
			
			//토큰정보 유효성 체크.
			LoginVO loginVO = (LoginVO) commonSql.select("loginDAO.extActionLogin", mp);
			
			//외부링크 정보 조회
			Map<String, Object> linkInfo = (Map<String, Object>) commonSql.select("ExtDAO.getLinkInfo", mp);
			
			Map<String,Object> lInfo = new HashMap<String,Object>();
	    	lInfo.put("no", linkInfo.get("menuNo"));
	    	lInfo.put("name", linkInfo.get("linkNmKr"));
	    	if(type.equals("view") && moduleTp.equals("ea")){
	    		lInfo.put("url", linkInfo.get("urlPath") + "?diKeyCode=" + para.get("docId"));
	    	}else{
	    		lInfo.put("url", linkInfo.get("urlPath"));
	    	}
	    	lInfo.put("urlGubun", linkInfo.get("target"));
	    	lInfo.put("mainForward", "");
	    	lInfo.put("gnbMenuNo", linkInfo.get("gnbMenuNo"));
	    	lInfo.put("lnbMenuNo", linkInfo.get("lnbMenuNo"));
	    	lInfo.put("portletType", "");
	    	lInfo.put("linkType", linkInfo.get("type"));
	    	
	    	lInfo.put("messengerViewType", linkInfo.get("viewType"));
	    	
	    	lInfo.put("eventType", "");
	    	lInfo.put("eventSubType", "");	    	
	    	lInfo.put("moduleTp", linkInfo.get("target"));
			
			request.getSession().invalidate();
			request.getSession().setAttribute("firstGnbRenderTp", "SSO");
	    	request.getSession().setAttribute("loginVO", loginVO);
	    	request.getSession().setAttribute("ssoLinkInfo", lInfo);
	
	    	mp.put("compSeq", loginVO.getOrganId());
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
	    	request.getSession().setAttribute("optionSet", optionSet);
	    	request.getSession().setAttribute("langCode", loginVO.getLangCode());
	    	request.setAttribute("langCode", loginVO.getLangCode());
			
	    	mv.setViewName("redirect:/bizboxSSO.do");
	    	
		}catch(Exception e){		
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		}
		
		return mv;
	}
	
	
	@RequestMapping("/CustSSOLogin.do")
	public ModelAndView CustSSOLogin(@RequestParam Map<String,Object> para, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		String systemKey = BizboxAProperties.getCustomProperty( "BizboxA.CustSSOLoginSystemKey" );
		String contentsKey = BizboxAProperties.getCustomProperty( "BizboxA.CustSSOLogincontentsKey" );
		String ts = "";
		String system = "";
		String contents = "";
		String empNo = "";
		boolean isOk = true;
		
		try{			
			UtilCryptoOuter uco = new UtilCryptoOuter();			
			
			uco.setKey(BizboxAProperties.getCustomProperty( "BizboxA.CustSSOLoginDecryptKey" ));			
			String ssoKey = uco.decrypt3DES((para.get("PM_SABUN") + ""));
			String[] arrKey = ssoKey.split("&");
			for(int i=0; i<arrKey.length; i++){
				String[] keyValue = arrKey[i].split("=");
				if(keyValue[0].equals("ts")){
					ts = keyValue[1];
				}else if(keyValue[0].equals("system")){
					system = keyValue[1];
				}else if(keyValue[0].equals("contents")){
					contents = keyValue[1];
				}else if(keyValue[0].equals("empNo")){
					empNo = keyValue[1];
				}
			}
			if(!system.equals(systemKey)) {
				isOk = false;
			}
			else if(!contents.equals(contentsKey)) {
				isOk = false;
			}
			
			//SSO로직 시작
			if(isOk){
				Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("empNo", empNo);
				mp.put("ts", ts);
				
				LoginVO loginVO = (LoginVO) commonSql.select("loginDAO.CustActionLogin", mp);
				
				request.getSession().invalidate();
				request.getSession().setAttribute("firstGnbRenderTp", "SSO");
		    	request.getSession().setAttribute("loginVO", loginVO);
		
		    	mp.put("compSeq", loginVO.getOrganId());
		    	mp.put("groupSeq", loginVO.getGroupSeq());
		    	
		    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
		    	request.getSession().setAttribute("optionSet", optionSet);
		    	request.getSession().setAttribute("langCode", loginVO.getLangCode());
		    	request.setAttribute("langCode", loginVO.getLangCode());
		    	
		    	mv.setViewName("redirect:/userMain.do");
		    	
		    	request.getSession().setAttribute("forceLogoutYn", "N");
		    	
			}else{
				mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			}
		
		}catch(Exception e){
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		}
		return mv;
	}
	
	public static JSONObject getPostJSON(String url, String data) {
		StringBuilder sbBuf = new StringBuilder();
		HttpURLConnection con = null;
		BufferedReader brIn = null;
		OutputStreamWriter wr = null;
		String line = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("POST");
			con.setConnectTimeout(5000);
			con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			con.setDoOutput(true);
			con.setDoInput(true);

			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			brIn = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			while ((line = brIn.readLine()) != null) {
				sbBuf.append(line);
			}
			// System.out.println(sbBuf);

			JSONObject rtn = JSONObject.fromObject(sbBuf.toString());

			sbBuf = null;

			return rtn;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		} finally {
			try {
				if(wr!=null) {//Null Pointer 역참
				wr.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(brIn!=null) {//Null Pointer 역참
				brIn.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(con!=null) {//Null Pointer 역참
				con.disconnect();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}	
}
