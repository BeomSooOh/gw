package api.ext.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;

import api.common.model.APIResponse;
import api.ext.service.ExtService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.comp.service.ExCodeOrgService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.ReturnPath;
import neos.cmm.vo.ConnectionVO;

import java.security.MessageDigest;
import duzon.cmmn.webservice.server.service.DZContServiceProxy;

import org.tempuri.UserAuthWDO;

import cloud.CloudConnetInfo;


@Controller
public class ExtController {
	
	private static final Logger logger = LoggerFactory.getLogger(ExtController.class);
	 
	@Resource(name="ExtService")
	private ExtService extService;
	
	@Resource(name = "loginService")
    private EgovLoginService loginService;
	
	@Resource(name = "CompManageService")
	private CompManageService compManageService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
		
	@RequestMapping(value="/ext/ExtToken", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getExtToken(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴결과
		response = extService.ExtToken(paramMap);
		
		
		return response;
		
	}
	
	@RequestMapping("/outProcessLogOn.do")
	public ModelAndView outProcessLogOn(
			                    @RequestParam(value="erpSeq", required=false) String erpSeq, 
								@RequestParam(value="empSeq", required=false) String empSeq, 
								@RequestParam(value="compSeq", required=false) String compSeq,
								@RequestParam(value="compCd", required=false) String compCd,
								@RequestParam(value="groupSeq", required=false) String groupSeq,
								@RequestParam(value="deptSeq", required=false) String deptSeq,
								@RequestParam(value="deptCd", required=false) String deptCd,
								@RequestParam(value="erpCompSeq", required=false) String erpCompSeq, 
								@RequestParam(value="loginId", required=false) String loginId, 
								@RequestParam(value="kicpaNum", required=false) String kicpaNum,
								@RequestParam(value="module", required=false) String module,
								
			 					@RequestParam(value="mod", required=false) String mod, 
			 					@RequestParam(value="contentsEnc", required=false) String contentsEnc,
			 					@RequestParam(value="contentsStr", required=false) String contentsStr,
			 					@RequestParam(value="subjectStr", required=false) String subjectStr,
			 					
			 					@RequestParam Map<String,Object> paramMap,
			 					@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                HttpServletRequest request,
	    		                ModelMap model) throws Exception {
		
		if(groupSeq == null || groupSeq.equals("")) {
	    	String serverName = request.getServerName();
	    	Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
	    	
	    	if(jedisMp != null && jedisMp.get("groupSeq") != null) {
	    		groupSeq = jedisMp.get("groupSeq").toString();	
	    	}
		}
		
		request.getSession().setAttribute("loginVO", null);
		
	    ModelAndView mv = new ModelAndView();
	    /** 비즈박스A 그룹,회사코드 조회하기 **/
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("groupSeq", groupSeq);
    	params.put("erpSeq", erpSeq);
    	params.put("empSeq", empSeq);
    	params.put("loginId", loginId);
    	params.put("compSeq", compSeq);
    	params.put("compCd", compCd);
    	
    	//compCd 우선순위 처리를 위해 compSeq 초기화
    	if(compCd != null && !compCd.equals("")) {
    		params.put("compSeq", "");	
    	}    	
    	
    	params.put("erpCompSeq", erpCompSeq);
    	params.put("module", module);
    	params.put("kicpaNum", kicpaNum);
    	
    	if(mod == null || mod.equals("")) {
    		paramMap.put("mod", "W");
    	}
    	
    	if(erpSeq == null && empSeq == null && loginId == null && kicpaNum == null) {
    		mv.setViewName("jsonView");
    		mv.addObject("error", "인증키 누락됨");
    		return mv;
    	}
    	
    	Map<String,Object> empInfo = extService.ExtErpInfo(params);
    	
    	if (empInfo != null) {
    		Map<String,Object> outProcessInfo = new HashMap<>();
    		
    		outProcessInfo.putAll(paramMap);
    		outProcessInfo.remove("erpSeq");
    		outProcessInfo.remove("empSeq");
    		outProcessInfo.remove("compSeq");
    		outProcessInfo.remove("groupSeq");
    		outProcessInfo.remove("deptSeq");
    		outProcessInfo.remove("deptCd");
    		outProcessInfo.remove("erpCompSeq");
    		outProcessInfo.remove("loginId");
    		outProcessInfo.remove("kicpaNum");
    		outProcessInfo.remove("erpSeq");
    		outProcessInfo.remove("module");
    		
    		//DERP 토큰처리 
    		if(request.getHeader("X-Authenticate-Token") != null){
    			outProcessInfo.put("X-Authenticate-Token", request.getHeader("X-Authenticate-Token"));
    		}
    		
    		if(contentsEnc != null && !contentsEnc.equals("")){    				
				contentsEnc = contentsEnc.replaceAll("\u00A0"," ");
				outProcessInfo.put("contentsEnc", contentsEnc);	
			}else{
				outProcessInfo.put("contentsEnc", "O");
			}
    		
    		//결재본문 정보체크
    		if(contentsStr != null){
    			contentsStr = contentsStr.replaceAll("\u00A0"," ");        		
        		outProcessInfo.put("contentsStr", contentsStr);    			
    		}else{
    			outProcessInfo.put("contentsStr", "");
    		}
    		//문서제목 정보체크
    		if(subjectStr != null){
    			subjectStr = subjectStr.replaceAll("\u00A0"," ");
        		outProcessInfo.put("subjectStr", subjectStr);    			
    		}else{
    			outProcessInfo.put("subjectStr", "");
    		}
    		
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) empInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) empInfo.get("compSeq"));
	    	loginVO.setUniqId((String) empInfo.get("empSeq"));
	    	loginVO.setEaType((String) empInfo.get("eaType"));
	    	
	    	if(deptSeq != null && !deptSeq.equals("")){
	    		loginVO.setOrgnztId(deptSeq);
	    	}else if(deptCd != null && !deptCd.equals("")){
	    		loginVO.setDept_seq(deptCd);
	    	}
	    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().invalidate();
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("outProcessInfo", outProcessInfo);
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", empInfo.get("groupSeq"));
	    	mp.put("compSeq", empInfo.get("compSeq"));
	    	
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
        	
        	request.getSession().setAttribute("groupSeq", resultVO.getGroupSeq());
        	request.getSession().setAttribute("loginId", resultVO.getId());
        	request.getSession().setAttribute("compSeq", resultVO.getOrganId());
        	request.getSession().setAttribute("deptSeq", resultVO.getOrgnztId());
	    	
	    	mv.setViewName("redirect:/bizboxOut.do");
    	}
    	else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
    	
		return mv;
		
	}
	
	@RequestMapping("/outProcessEncLogOn.do")
	public ModelAndView outProcessEncLogOn(
			                    @RequestParam(value="erpSeq", required=false) String erpSeq, 
								@RequestParam(value="empSeq", required=false) String empSeq, 
								@RequestParam(value="compSeq", required=false) String compSeq,
								@RequestParam(value="compCd", required=false) String compCd,
								@RequestParam(value="groupSeq", required=false) String groupSeq,
								@RequestParam(value="deptSeq", required=false) String deptSeq,
								@RequestParam(value="deptCd", required=false) String deptCd,
								@RequestParam(value="erpCompSeq", required=false) String erpCompSeq, 
								@RequestParam(value="loginId", required=false) String loginId, 
								@RequestParam(value="kicpaNum", required=false) String kicpaNum,
								@RequestParam(value="aesType", required=false) String aesType,
								@RequestParam(value="aesKey", required=false) String aesKey,
								@RequestParam(value="module", required=false) String module,
			 					@RequestParam(value="mod", required=false) String mod, 
			 					@RequestParam(value="contentsEnc", required=false) String contentsEnc,
			 					@RequestParam(value="contentsStr", required=false) String contentsStr,
			 					@RequestParam(value="subjectStr", required=false) String subjectStr,
			 					
			 					@RequestParam Map<String,Object> paramMap,
			 					@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                HttpServletRequest request,
	    		                ModelMap model) throws Exception {
		
		if(groupSeq == null || groupSeq.equals("")) {
	    	String serverName = request.getServerName();
	    	Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
	    	
	    	if(jedisMp != null && jedisMp.get("groupSeq") != null) {
	    		groupSeq = jedisMp.get("groupSeq").toString();	
	    	}
		}		
		
		ModelAndView mv = new ModelAndView();
		
		boolean failSt = false;
		
		if(erpSeq != null && !erpSeq.equals("")){
			erpSeq = AESCipher.AESEX_ExpirDecode(aesType, erpSeq, aesKey, 60);

			if(erpSeq.equals("")) {
				failSt = true;
			}
		}
		
		if(empSeq != null && !empSeq.equals("")){
			empSeq = AESCipher.AESEX_ExpirDecode(aesType, empSeq, aesKey, 60);
			
			if(empSeq.equals("")) {
				failSt = true;		
			}
		}

		if(loginId != null && !loginId.equals("")){
			loginId = AESCipher.AESEX_ExpirDecode(aesType, loginId, aesKey, 60);
			
			if(loginId.equals("")) {
				failSt = true;		
			}
		}
		
		if(kicpaNum != null && !kicpaNum.equals("")){
			kicpaNum = AESCipher.AESEX_ExpirDecode(aesType, kicpaNum, aesKey, 60);
			
			if(kicpaNum.equals("")) {
				failSt = true;		
			}
		}
		
		if(failSt) {
			mv.addObject("login_error","SSO");
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		request.getSession().setAttribute("loginVO", null);
	    
	    /** 비즈박스A 그룹,회사코드 조회하기 **/
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("groupSeq", groupSeq);
    	params.put("erpSeq", erpSeq);
    	params.put("empSeq", empSeq);
    	params.put("loginId", loginId);
    	params.put("compSeq", compSeq);
    	params.put("compCd", compCd);
    	
    	//compCd 우선순위 처리를 위해 compSeq 초기화
    	if(compCd != null && !compCd.equals("")) {
    		params.put("compSeq", "");	
    	}     	
    	
    	params.put("erpCompSeq", erpCompSeq);
    	params.put("module", module);
    	params.put("kicpaNum", kicpaNum);
    	
    	if(mod == null || mod.equals("")) {
    		mod ="W";
    	}
    	
    	if(erpSeq == null && empSeq == null && loginId == null && kicpaNum == null) {
    		mv.setViewName("jsonView");
    		mv.addObject("error", "인증키 누락됨");
    		return mv;
    	}
    	
    	Map<String,Object> empInfo = extService.ExtErpInfo(params);
    	
    	if (empInfo != null) {
    		Map<String,Object> outProcessInfo = new HashMap<>();
    		
    		outProcessInfo.putAll(paramMap);
    		outProcessInfo.remove("erpSeq");
    		outProcessInfo.remove("empSeq");
    		outProcessInfo.remove("compSeq");
    		outProcessInfo.remove("groupSeq");
    		outProcessInfo.remove("deptSeq");
    		outProcessInfo.remove("deptCd");
    		outProcessInfo.remove("erpCompSeq");
    		outProcessInfo.remove("loginId");
    		outProcessInfo.remove("kicpaNum");
    		outProcessInfo.remove("erpSeq");
    		outProcessInfo.remove("module");    		
    		
    		if(contentsEnc != null && !contentsEnc.equals("")){    				
				contentsEnc = contentsEnc.replaceAll("\u00A0"," ");
				outProcessInfo.put("contentsEnc", contentsEnc);	
			}else{
				outProcessInfo.put("contentsEnc", "O");
			}
    		
    		//결재본문 정보체크
    		if(contentsStr != null){
    			contentsStr = contentsStr.replaceAll("\u00A0"," ");        		
        		outProcessInfo.put("contentsStr", contentsStr);    			
    		}else{
    			outProcessInfo.put("contentsStr", "");
    		}
    		//문서제목 정보체크
    		if(subjectStr != null){
    			subjectStr = subjectStr.replaceAll("\u00A0"," ");
        		outProcessInfo.put("subjectStr", subjectStr);    			
    		}else{
    			outProcessInfo.put("subjectStr", "");
    		}
    		
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) empInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) empInfo.get("compSeq"));
	    	loginVO.setUniqId((String) empInfo.get("empSeq"));
	    	loginVO.setEaType((String) empInfo.get("eaType"));
	    	
	    	if(deptSeq != null && !deptSeq.equals("")){
	    		loginVO.setOrgnztId(deptSeq);
	    	}else if(deptCd != null && !deptCd.equals("")){
	    		loginVO.setDept_seq(deptCd);
	    	}
	    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().invalidate();
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("outProcessInfo", outProcessInfo);
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", empInfo.get("groupSeq"));
	    	mp.put("compSeq", empInfo.get("compSeq"));
	    	
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
	    	
	    	mv.setViewName("redirect:/bizboxOut.do");
    	}
    	else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
    	
		return mv;
		
	}	
	
	@RequestMapping("/outLogOn.do")
	public ModelAndView outLogOn(			                  
								@RequestParam(value="userid", required=false) String userid,
								@RequestParam(value="password", required=false) String password,
			 					@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                HttpServletRequest request,
	    		                ModelMap model) throws Exception {
		
		//html특수기호 (&nbsp; 치환처리)
//		contentsStr = contentsStr.replaceAll("\u00A0"," ");
//		contentsEnc = contentsEnc.replaceAll("\u00A0"," ");
		request.getSession().setAttribute("loginVO", null);
		password = password == null ? "" : password;
		
	    ModelAndView mv = new ModelAndView();
	    /** 비즈박스A 그룹,회사코드 조회하기 **/
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("loginId", userid);    	
    	params.put("loginPasswd", CommonUtil.passwordEncrypt(replacePasswd(password)));

    	Map<String,Object> empInfo = extService.ExtErpInfo(params);
    	
    	if (empInfo != null) {    	
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) empInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) empInfo.get("compSeq"));
	    	loginVO.setUniqId((String) empInfo.get("empSeq"));
	    	loginVO.setEaType((String) empInfo.get("eaType"));
		    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().invalidate();
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("outLogOn", "Y");
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", empInfo.get("groupSeq"));
	    	mp.put("compSeq", empInfo.get("compSeq"));
	    	
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
	    	
	    	mv.setViewName("redirect:/bizboxOutLogOn.do");
    	}
    	else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
    	
		return mv;
		
	}
	
	
	@RequestMapping("/outLogOnPass.do")
	public ModelAndView outLogOnPass(			                  
								@RequestParam(value="userid", required=false) String userid,
			 					@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                HttpServletRequest request,
	    		                ModelMap model) throws Exception {
		
		//html특수기호 (&nbsp; 치환처리)
//		contentsStr = contentsStr.replaceAll("\u00A0"," ");
//		contentsEnc = contentsEnc.replaceAll("\u00A0"," ");
		request.getSession().setAttribute("loginVO", null);
		
	    ModelAndView mv = new ModelAndView();
	    /** 비즈박스A 그룹,회사코드 조회하기 **/
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("loginId", userid);    	

    	Map<String,Object> empInfo = extService.ExtErpInfo(params);
    	
    	if (empInfo != null) {    	
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) empInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) empInfo.get("compSeq"));
	    	loginVO.setUniqId((String) empInfo.get("empSeq"));
	    	loginVO.setEaType((String) empInfo.get("eaType"));
		    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().invalidate();
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("outLogOn", "Y");
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", empInfo.get("groupSeq"));
	    	mp.put("compSeq", empInfo.get("compSeq"));
	    	
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
	    	
	    	mv.setViewName("redirect:/bizboxOutLogOn.do");
    	}
    	else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
    	
		return mv;
		
	}
	
	public String replacePasswd(String str){
		//&nbsp;
		if(str.indexOf("&nbsp;") != -1) {
			str = str.replaceAll("&nbsp;", " ");
		}
		if(str.indexOf("&amp;") != -1) {
			str = str.replaceAll("&amp;", "&");
		}
		if(str.indexOf("&lt;") != -1) {
			str = str.replaceAll("&lt;", "<");
		}
		if(str.indexOf("&gt;") != -1) {
			str = str.replaceAll("&gt;", ">");
		}
		if(str.indexOf("&quot;") != -1) {
			str = str.replaceAll("&quot;", "\"");
		}
		
		return str;
	}
	
	
	@RequestMapping("/outProssLogOn.do")
	public ModelAndView outProssLogOn(@RequestParam(value="erpSeq", required=false) String erpSeq, 
								@RequestParam(value="empSeq", required=false) String empSeq, 
								@RequestParam(value="compSeq", required=false) String compSeq, 
								@RequestParam(value="groupSeq", required=false) String groupSeq,
								@RequestParam(value="loginId", required=false) String loginId, 
			 					@RequestParam(value="approKey", required=false) String approKey, 
			 					@RequestParam(value="erpDiv", required=false) String erpDiv, 
			 					@RequestParam(value="fcode", required=false) String fcode, 
			 					@RequestParam(value="formId", required=false) String formId, 
			 					@RequestParam(value="callId", required=false, defaultValue="-1") String callId,
			 					@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                HttpServletRequest request,
	    		                ModelMap model) throws Exception {
		
		request.getSession().setAttribute("loginVO", null);
		
	    ModelAndView mv = new ModelAndView();
		
	    //String[] split = approKey.split("_");
	    
	    /** 비즈박스A 그룹,회사코드 조회하기 **/
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("groupSeq", groupSeq);
    	params.put("erpSeq", erpSeq);
    	params.put("empSeq", empSeq);
    	params.put("loginId", loginId);
    	params.put("compSeq", compSeq);
    	//params.put("erpSeq", split[0]);
    	
    	Map<String,Object> empInfo = extService.ExtErpInfo(params);
    	
    	
    	
    	if (empInfo != null) {
    		empInfo.put("approvalId", approKey);
    		empInfo.put("formAppKind", fcode);
    		empInfo.put("formId", formId);
    		empInfo.put("callId", callId);
    		String formKind = "ea0090";	//Smart자금관리
    		if (erpDiv.equals("I")) {
    			//아이큐브
    			formKind = "ea0023";
    		}
    		else if (erpDiv.equals("U")) {
    			//erp_iu
    			formKind = "ea0024";
    		}
    		else if (erpDiv.equals("O")) {
    			//타시스템 외부연동
    			formKind = "ea0000";
    		}
    		empInfo.put("formKind", formKind);
    		
    		
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) empInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) empInfo.get("compSeq"));
	    	loginVO.setUniqId((String) empInfo.get("empSeq"));
	    	loginVO.setEaType((String) empInfo.get("eaType"));
	    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("fmInfo", empInfo);
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", empInfo.get("groupSeq"));
	    	mp.put("compSeq", empInfo.get("compSeq"));
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
	    	
	    	mv.setViewName("redirect:/bizboxFM.do");
    	}
    	else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
    	
		return mv;
		
	}
	
	static Boolean paramEnc = false;
	
	@RequestMapping("/FMLogOn.do")
	public ModelAndView FMLogOn(@RequestParam(value="loginId", required=false) String erpSeq, 
								@RequestParam(value="empSeq", required=false) String empSeq,
								@RequestParam(value="deptSeq", required=false) String deptSeq,
								@RequestParam(value="deptCd", required=false) String deptCd,
								@RequestParam(value="loginIdEnc", required=false) String loginIdEnc,
								@RequestParam(value="empSeqEnc", required=false) String empSeqEnc,
								@RequestParam(value="aesKey", required=false) String aesKey,
								@RequestParam(value="paramEncSet", required=false) String paramEncSet,
								@RequestParam(value="compSeq", required=false) String compSeq,
			 					@RequestParam(value="approKey", required=false) String approKey, 
			 					@RequestParam(value="erpDiv", required=false) String erpDiv, 
			 					@RequestParam(value="fcode", required=false) String fcode,
			 					@RequestParam(value="callId", required=false, defaultValue="-1") String callId,
			 					@RequestParam(value="ccode", required=false) String ccode,
			 					@RequestParam(value="module", required=false) String module,
			 					@RequestParam(value="cdCompany", required=false) String cdCompany,
			 					@RequestParam(value="cdPc", required=false) String cdPc,
			 					@RequestParam(value="noDocu", required=false) String noDocu ,
			 					@RequestParam(value="docId", required=false) String docId,
			 					@RequestParam(value="formId", required=false) String formId,
			 					@RequestParam(value="mod", required=false) String mod,
			 					@RequestParam(value="refDocId", required=false) String refDocId,
			 					@RequestParam(value="groupSeq", required=false) String groupSeq,
			 					@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                HttpServletRequest request,
	    		                ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.FMLogOnEnc").equals("Y")) {
			
			//이력상태 변경
			if(paramEncSet != null){
				if(paramEncSet.equals("true")){
					paramEnc = true;
				}else{
					paramEnc = false;
				}
			}
			
			//파라미터 암호화 이력이 있을경우 평문 초기화
			if(paramEnc){
				erpSeq = "";
				empSeq = "";
			}

			if(loginIdEnc != null && !loginIdEnc.equals("")){
				if(!paramEnc) {
					paramEnc = true;
				}
				
				erpSeq = AESCipher.AES128EX_ExpirDecode(loginIdEnc, aesKey, 60);
				
				if(erpSeq.equals("")) {
					ReturnPath.scriptClose(request, BizboxAMessage.getMessage("TX800000002","사용자 인증정보가 유효하지 않거나 만료되었습니다."));
					mv.setViewName("neos/cmm/message"); 
					return mv;		
				}
			}
			
			if(empSeqEnc != null && !empSeqEnc.equals("")){
				
				if(!paramEnc) {
					paramEnc = true;
				}
				empSeq = AESCipher.AES128EX_ExpirDecode(empSeqEnc, aesKey, 60);
				
				if(empSeq.equals("")) {
					ReturnPath.scriptClose(request, BizboxAMessage.getMessage("TX800000002","사용자 인증정보가 유효하지 않거나 만료되었습니다."));
					mv.setViewName("neos/cmm/message"); 
					return mv;		
				}			
			}
		}else {
			
			if(loginIdEnc != null && !loginIdEnc.equals("")){
			
				loginIdEnc = AESCipher.AES128EX_ExpirDecode(loginIdEnc, aesKey, 60);
				
				if(loginIdEnc.equals("")) {
					erpSeq = "";
				}
			}	
			
			if(empSeqEnc != null && !empSeqEnc.equals("")){
				
				empSeqEnc = AESCipher.AES128EX_ExpirDecode(empSeqEnc, aesKey, 60);
				
				if(empSeqEnc.equals("")) {
					empSeq = "";
				}			
			}			
			
		}
		
		request.getSession().setAttribute("loginVO", null);
		
	    /** 비즈박스A 그룹,회사코드 조회하기 **/
    	Map<String,Object> params = new HashMap<String,Object>();
    	
    	if(groupSeq == null || groupSeq.equals("")){
    		//도메인 정보로 groupSeq 조회
    		String serverName = request.getServerName();
        	Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
        	logger.info("search GroupSeq by Domain : " + jedisMp + "   serverName : " + serverName);
        	if(jedisMp != null){
        		groupSeq = jedisMp.get("groupSeq") + "";
        	}
    	}
    	
    	params.put("groupSeq", groupSeq);
    	
    	//erpSeq로 처리
    	if(!EgovStringUtil.isNullToString(erpSeq).equals("")){
    		params.put("erpSeq", erpSeq);
    		
    		if(!EgovStringUtil.isNullToString(ccode).equals("")){
    			params.put("ccode", ccode);
    			params.put("module", module);    			
    		}else{ //ccode 없을때  (erp 에서는 2개회사 gw 에서는 1개회사 사용시 예외처리 )
    			if(!EgovStringUtil.isNullToString(cdCompany).equals("")){
    				ccode = cdCompany;    			
        		}
    			if(!EgovStringUtil.isNullToString(compSeq).equals("")){
    				params.put("erpCompSeq", compSeq);  			
        		}
    			if(!EgovStringUtil.isNullToString(module).equals("")){
    				params.put("module", module);  			
        		}    			
    		}
    	}else{
    		params.put("empSeq", empSeq);
    		params.put("compSeq", compSeq);
    	}
    	
    	
    	if(EgovStringUtil.isNullToString(erpDiv).equals("I")) {
    		params.put("erpTypeCode", "iCUBE");
    	} else if(EgovStringUtil.isNullToString(erpDiv).equals("U")) {
    		params.put("erpTypeCode", "ERPiU");
    	}
    	
    	Map<String,Object> empInfo = extService.ExtErpInfo(params);
    	
    	if (empInfo != null) {
    		empInfo.put("approvalId", approKey);
    		empInfo.put("formAppKind", fcode);
    		empInfo.put("callId", callId);
    		empInfo.put("docId", docId);
    		empInfo.put("formId", formId);
    		empInfo.put("mod", mod);
    		empInfo.put("refDocId", refDocId);
    		
    		String formKind = "ea0090";	//Smart자금관리
    		if (erpDiv.equals("I")) {
    			
    			//Smart자금관리
    			// 아래 코드는 icube 측에서 고정 코드로 스마트자금관리로 관리됨으로 양식 조회시 icube 연동으로 조회되지 않음
    			// 박성수 차장님 요청으로 해당 코드에 대해서 고정하도록 처리.
    			// 2019.06.28 한용일 수정.
    			if (fcode != null && (fcode.equals("ba1000") || fcode.equals("ba2000") || fcode.equals("ba3000"))) {
    				formKind = "ea0090";
    				
    			} else {
    				//아이큐브
    				formKind = "ea0023";
    				
    			}
    			
    		}
    		else if (erpDiv.equals("U")) {
    			//erp_iu
    			formKind = "ea0024";
    			approKey = ccode + "_" +cdPc + "_" + noDocu;
    			empInfo.put("approvalId", approKey);
    		}
    		else if (erpDiv.equals("O")) {
    			//타시스템 외부연동
    			formKind = "ea0000";
    		}
    		empInfo.put("formKind", formKind);
    		
    		
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) empInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) empInfo.get("compSeq"));
	    	loginVO.setUniqId((String) empInfo.get("empSeq"));
	    	loginVO.setEaType((String) empInfo.get("eaType"));
	    	
	    	if(deptSeq != null && !deptSeq.equals("")){
	    		loginVO.setOrgnztId(deptSeq);
	    	}else if(deptCd != null && !deptCd.equals("")){
	    		loginVO.setDept_seq(deptCd);
	    	}	    	
    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("fmInfo", empInfo);
	    	request.getSession().setAttribute("groupSeq", resultVO.getGroupSeq());
	    	request.getSession().setAttribute("loginId", resultVO.getId());
	    	request.getSession().setAttribute("compSeq", resultVO.getOrganId());
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	request.getSession().setAttribute("deptSeq", resultVO.getOrgnztId());
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", empInfo.get("groupSeq"));
	    	mp.put("compSeq", empInfo.get("compSeq"));
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
	    	
        	mv.setViewName("redirect:/bizboxFM.do");
    	}
    	else{
			String errMsg = BizboxAMessage.getMessage("TX800000003","사원정보를 조회하지 못하였습니다.");
			ReturnPath.scriptClose(request, errMsg);
			mv.setViewName("neos/cmm/message"); 
    	}
    	
		return mv;
		
	}
	
	/**
	 * IU 전용 결재연동 
	 */
	@RequestMapping("/FMLogOnIU.do")
	public ModelAndView FMLogOnIU(@RequestParam(value="login_id", required=false) String erpSeq, // 로그인사원번호
								@RequestParam(value="deptSeq", required=false) String deptSeq,
								@RequestParam(value="deptCd", required=false) String deptCd,			
								@RequestParam(value="approKey", required=false) String approKey, 
			 					@RequestParam(value="erpDiv", required=false) String erpDiv, 
			 					@RequestParam(value="fcode", required=false) String fcode,
			 					@RequestParam(value="callId", required=false, defaultValue="-1") String callId,
			 					@RequestParam(value="cd_company", required=false) String ccode,  // 회사코드
			 					@RequestParam(value="module", required=false) String module,
			 					@RequestParam(value="cd_pc", required=false) String cdPc,        // 회계단위
			 					@RequestParam(value="no_docu", required=false) String noDocu ,   // 전표번호
			 					@RequestParam(value="docId", required=false) String docId, 
			 					@RequestParam(value="mod", required=false) String mod,
			 					@RequestParam(value="refDocId", required=false) String refDocId,
			 					@RequestParam(value="groupSeq", required=false) String groupSeq,
			 					@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                HttpServletRequest request,
	    		                ModelMap model) throws Exception {
		
		request.getSession().setAttribute("loginVO", null);
		
		
//
//1.뉴턴스(tims,suit) URL 형태
//도메인주소/KOR_WEBROOT/SRC/CM/TIMS/index.aspx?cd_company=회사코드&cd_pc=회계단위&no_docu=전표번호&login_id=로그인사원번호
//
//2.뉴턴스(Alpha)URL 형태
//도메인주소/gw/FMLogOn.do?loginId=로그인사원번호&erpDiv=U&fcode=폼코드&callId=1&ccode=회사코드&module=ac&cdPc=회계단위&noDocu=전표번호
//
		
		String moduleVal = "ac";
	    ModelAndView mv = new ModelAndView();
			    
	    /** 비즈박스A 그룹,회사코드 조회하기 **/
    	Map<String,Object> params = new HashMap<String,Object>();
    	
    	//erpSeq로 처리
    	if(!EgovStringUtil.isNullToString(erpSeq).equals("")){
    		params.put("erpSeq", erpSeq);
    		
    		if(!EgovStringUtil.isNullToString(ccode).equals("")){
    			params.put("ccode", ccode);
    			params.put("module", moduleVal);    			
    		}    		
    	}
    	if(EgovStringUtil.isNullToString(erpSeq).equals("")){
    		mod ="W";
    	}
    	params.put("cdCompany", ccode);
    	params.put("cdPc", cdPc);
    	params.put("noDocu", noDocu);
    	params.put("groupSeq", groupSeq);
    	
    	Map<String,Object> empInfo = extService.ExtErpInfo(params);
    	
    	
    	if (empInfo != null) {
    		
    		params.put("groupSeq", empInfo.get("groupSeq"));
    		params.put("compSeq", empInfo.get("compSeq"));
    		
    		Map<String, Object> erpinfo = compManageService.getErpConInfo_ac(params);
        	ConnectionVO		conVo				= new ConnectionVO();
    		//erp회사 리스트 조회.
    		ServletContext sc = request.getSession().getServletContext();
    		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
    		
    		if(erpinfo != null && !EgovStringUtil.isNullToString(ccode).equals("")){
    			//erp서버 정보 가져오기.
    			conVo.setDriver(EgovStringUtil.isNullToString(erpinfo.get("driver")));
    			conVo.setUrl(EgovStringUtil.isNullToString(erpinfo.get("url")));
    			conVo.setDatabaseType(EgovStringUtil.isNullToString(erpinfo.get("database_type")));
    			conVo.setSystemType(EgovStringUtil.isNullToString(erpinfo.get("erp_type_code")));
    			conVo.setUserId(EgovStringUtil.isNullToString(erpinfo.get("userid")));
    			conVo.setPassWord(EgovStringUtil.isNullToString(erpinfo.get("password")));
    			
    			String serviceName = "ExCodeOrg"+conVo.getSystemType()+"Service";
    			org.apache.log4j.Logger.getLogger( ExtController.class ).info("serviceName  : " + serviceName);
    			// 양식코드 조회 
    			ExCodeOrgService exCodeOrgService = (ExCodeOrgService)act.getBean(serviceName);
    			Map<String, Object> aaData = exCodeOrgService.GetFiGwDocInfo(params, loginVO, conVo);
    			fcode = EgovStringUtil.isNullToString(aaData.get("fcode"));
    		}
    		
    		empInfo.put("approvalId", approKey);
    		empInfo.put("formAppKind", fcode);
    		empInfo.put("callId", callId);
    		empInfo.put("docId", docId);
    		empInfo.put("mod", mod);   
    		empInfo.put("refDocId", refDocId);   
			approKey = ccode + "_" +cdPc + "_" + noDocu;
			empInfo.put("approvalId", approKey);
    		empInfo.put("formKind", "ea0024");    		
    		
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) empInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) empInfo.get("compSeq"));
	    	loginVO.setUniqId((String) empInfo.get("empSeq"));
	    	loginVO.setEaType((String) empInfo.get("eaType"));
	    	
	    	if(deptSeq != null && !deptSeq.equals("")){
	    		loginVO.setOrgnztId(deptSeq);
	    	}else if(deptCd != null && !deptCd.equals("")){
	    		loginVO.setDept_seq(deptCd);
	    	}	    	
	    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("fmInfo", empInfo);
	    	
	    	
	    	request.getSession().setAttribute("groupSeq", resultVO.getGroupSeq());
	    	request.getSession().setAttribute("loginId", resultVO.getId());
	    	request.getSession().setAttribute("compSeq", resultVO.getOrganId());
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", empInfo.get("groupSeq"));
	    	mp.put("compSeq", empInfo.get("compSeq"));
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
	    	
        	mv.setViewName("redirect:/bizboxFM.do");
    	}
    	else{
//    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			String errMsg = BizboxAMessage.getMessage("TX800000003","사원정보를 조회하지 못하였습니다.");
//			ReturnPath.actionPath(request, errMsg,"redirect:/uat/uia/egovLoginUsr.do");
//			mv.setViewName("neos/cmm/message");
			ReturnPath.scriptClose(request, errMsg);
			mv.setViewName("neos/cmm/message"); 
    	}
		return mv;
		
	}
	
	@RequestMapping("/ExtLogOn.do")
	public ModelAndView ExtLogOn(@RequestParam(value="token", required=false) String token, 
								 @RequestParam(value="groupSeq", required=false) String groupSeq,
								 @ModelAttribute("loginVO") LoginVO loginVO, 
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
		request.getSession().setAttribute("loginVO", null);
		
	    ModelAndView mv = new ModelAndView();
		
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("token", token);
    	params.put("groupSeq", groupSeq);
    	
    	/** SSO 링크정보 가져오기 **/
    	Map<String,Object> linkInfo = extService.ExtSSO(params);
    	
    	if (linkInfo.get("ret").equals(1)) {
    		String targetPage = (String) linkInfo.get("targetPage");
    		String urlPath = (String) linkInfo.get("urlPath");
    		
	    	Map<String,Object> lInfo = new HashMap<String,Object>();
	    	lInfo.put("no", linkInfo.get("menuNo"));
	    	lInfo.put("name", linkInfo.get("gnbMenuNm"));
	    	lInfo.put("url", linkInfo.get("urlPath"));
	    	lInfo.put("urlGubun", linkInfo.get("targetPage"));
	    	lInfo.put("mainForward", "");
	    	lInfo.put("gnbMenuNo", linkInfo.get("gnbMenuNo"));
	    	lInfo.put("lnbMenuNo", linkInfo.get("menuNo"));
	    	lInfo.put("portletType", "");
	    	
	    	lInfo.put("popYn", linkInfo.get("popYn"));
	    	lInfo.put("popUrl", linkInfo.get("urlPath2"));
	    	
	    	
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) linkInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) linkInfo.get("compSeq"));
	    	loginVO.setUniqId((String) linkInfo.get("empSeq"));
	    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("extLinkInfo", lInfo);
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", linkInfo.get("groupSeq"));
	    	mp.put("compSeq", linkInfo.get("compSeq"));
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
        	
	    	if (targetPage.toLowerCase().equals("main")) {
	    		mv.setViewName("redirect:/userMain.do");
	    	}
	    	else {
	    		mv.setViewName("redirect:/bizboxExt.do");
	    	}
	    	
	    	request.getSession().setAttribute("forceLogoutYn", "N");
	    	
    	}
    	else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
    	
		return mv;
		
	}
	
	
	@RequestMapping("/ExtLogIn.do")
	public ModelAndView ExtLogIn(@RequestParam(value="grpSeq", required=false) String groupSeq, 
								 @RequestParam(value="compSeq", required=false) String compSeq, 
								 @RequestParam(value="empSeq", required=false) String empSeq, 
								 @RequestParam(value="linkSeq", required=false) String linkSeq,
								 @ModelAttribute("loginVO") LoginVO loginVO, 
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Map<String,Object> params = new HashMap<String,Object>();
    	params.put("groupSeq", groupSeq);
    	params.put("compSeq", compSeq);
    	params.put("empSeq", empSeq);
    	params.put("linkSeq", linkSeq);
    	
    	Map<String,Object> ssoInfo = extService.ExtSSOInfo(params);
		
		String str = "A61B1WHLY81W611VQN3TNDOPXW4VB7JA";
		
    	MessageDigest md = MessageDigest.getInstance("MD5"); 
		md.update(str.getBytes()); 

		byte byteData[] = md.digest();

		StringBuffer sb = new StringBuffer(); 

		for(int i = 0 ; i < byteData.length ; i++){
			sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
		}

		String erpSeq = (String) ssoInfo.get("extCode");
    	
    	UserAuthWDO uaWDO = new UserAuthWDO();
    	uaWDO.setGroup_cd("3");
    	uaWDO.setCompany_cd(erpSeq);
    	uaWDO.setLogin_cd((String) ssoInfo.get("loginId"));
    	uaWDO.setKey(sb.toString());
    	
    	DZContServiceProxy dzService = new DZContServiceProxy();
    	String ret = dzService.sendContSSO(uaWDO);
    	
    	mv.setViewName("redirect:" + ret);
    	
    	
		return mv;
		
	}
	
	
	@RequestMapping("/EnpassLogOn.do")
	public ModelAndView EnpassLogOn(@RequestParam(value="pType", required=false) String pType,
									@RequestParam(value="pSeq", required=false) String pSeq,
									@RequestParam(value="pMenu", required=false) String pMenu,
									@RequestParam(value="groupSeq", required=false) String groupSeq,
									@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                  	HttpServletRequest request,
	    		                  	HttpServletResponse response,
	    		                  	ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		HttpSession session = request.getSession(true);

		Map<String,Object> ssoMap = new HashMap<String,Object>();
		String ssoId = (String)session.getAttribute("_enpass_id_");
		ssoMap = (HashMap)session.getAttribute("_enpass_attr_");
		
		if(ssoId == null || ssoId.equals("")) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		}
		else {
			String userSe = "SW";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setUniqId(ssoId);
	    	loginVO.setGroupSeq(groupSeq);
	    	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO); 	
	    	resultVO.setUserSe("USER");
	    	
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", resultVO.getGroupSeq());
	    	mp.put("compSeq", resultVO.getComp_id());
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
	    	request.getSession().setAttribute("optionSet", optionSet);
	    	
	    	if(pType.equals("main")){
	    		mv.setViewName("redirect:/userMain.do");
	    		return mv;
	    	}
	    	
	    	Map<String,Object> params = new HashMap<String,Object>();
	    	params.put("pType", pType);
	    	params.put("pMenu", pMenu);
	    	params.put("groupSeq", groupSeq);
	    	
	    	Map<String,Object> linkInfo = extService.SWLinkInfo(params);
	    	
	    	Map<String,Object> lInfo = new HashMap<String,Object>();
	    	lInfo.put("no", linkInfo.get("menuNo"));
	    	lInfo.put("name", linkInfo.get("linkNmKr"));
	    	lInfo.put("url", linkInfo.get("urlPath"));
	    	lInfo.put("urlGubun", linkInfo.get("urlGubun"));
	    	lInfo.put("mainForward", "");
	    	lInfo.put("gnbMenuNo", linkInfo.get("gnbMenuNo"));
	    	lInfo.put("lnbMenuNo", linkInfo.get("menuNo"));
	    	lInfo.put("portletType", "");
	    	
	    	if(pSeq.equals("0")) {
	    		lInfo.put("popYn", "N");
	    	}
	    	else {
	    		lInfo.put("popYn", "Y");
	    		
	    		String popUrl = "";
	    		
//	    		if(popUrl.equals("main")) {
//	    			
//	    		}
//	    		else {
//	    			
//	    		}
	    		
	    		lInfo.put("popUrl", linkInfo.get("urlPath"));
	    	}

	    	request.getSession().setAttribute("enpassLinkInfo", lInfo);
	    	
	    	mv.setViewName("redirect:/bizboxSW.do");
		}
		return mv;
	}
	
	
	@RequestMapping("/EnpassLogOn2.do")
	public ModelAndView EnpassLogOn2(@RequestParam Map<String,Object> paramMap, 
									@ModelAttribute("loginVO") LoginVO loginVO, 
	    		                  	HttpServletRequest request,
	    		                  	HttpServletResponse response,
	    		                  	ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		String ssoId = "";
		
		if(paramMap.get("ssoId") != null) {
			ssoId = paramMap.get("ssoId").toString();
		}else if(request.getSession().getAttribute("_enpassKey_") != null) {
			ssoId = request.getSession().getAttribute("_enpassKey_").toString();
			request.getSession().removeAttribute("_enpassKey_");
		}
		
		if(ssoId == null || ssoId.equals("")) {
			mv.addObject("alertMsg", BizboxAMessage.getMessage("TX800000004","SSO인증키가 존재하지 않습니다."));
	    	mv.addObject("rURL", request.getScheme() + "://"+request.getServerName()+":"+request.getServerPort()+"/gw/uat/uia/egovLoginUsr.do");
	    	return mv;			
		}
		else {
			String userSe = "SW";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setUniqId(ssoId);
	    	loginVO.setGroupSeq(paramMap.get("groupSeq") + "");
	    	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	if(resultVO.getUniqId() == null){
	    		mv.addObject("alertMsg", BizboxAMessage.getMessage("TX800000005","SSO인증대상이 존재하지 않습니다."));
		    	mv.addObject("rURL", request.getScheme() + "://"+request.getServerName()+":"+request.getServerPort()+"/gw/uat/uia/egovLoginUsr.do");
		    	return mv;		    		
	    	}
	    	
	    	resultVO.setUserSe("USER");
	    	
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
	    	
	    	
	    	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", resultVO.getGroupSeq());
	    	mp.put("compSeq", resultVO.getOrganId());
	    	
	    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
	    	request.getSession().setAttribute("optionSet", optionSet);
	    	
	    	if(paramMap.get("pType").equals("main")){
		    	mv.addObject("rURL", request.getScheme() + "://"+request.getServerName()+":"+request.getServerPort()+"/gw/userMain.do");
		    	return mv;
	    	}
	    	
	    	Map<String,Object> params = new HashMap<String,Object>();
	    	params.put("pType", paramMap.get("pType"));
	    	params.put("pMenu", paramMap.get("pMenu"));
	    	params.put("groupSeq", resultVO.getGroupSeq());
	    	
	    	Map<String,Object> linkInfo = extService.SWLinkInfo(params);
	    	
	    	if(linkInfo == null) {
	    		mv.addObject("alertMsg", BizboxAMessage.getMessage("TX800000006","요청한 메뉴정보가 존재하지 않습니다."));
		    	mv.addObject("rURL", request.getScheme() + "://"+request.getServerName()+":"+request.getServerPort()+"/gw/userMain.do");
		    	mv.setViewName("jsonView");
		    	return mv;	    		
	    	}
	    	    	
	    	Map<String,Object> lInfo = new HashMap<String,Object>();
	    	lInfo.put("no", linkInfo.get("menuNo"));
	    	lInfo.put("name", linkInfo.get("linkNmKr"));
	    	lInfo.put("url", linkInfo.get("urlPath"));
	    	lInfo.put("urlGubun", linkInfo.get("urlGubun"));
	    	lInfo.put("mainForward", "");
	    	lInfo.put("gnbMenuNo", linkInfo.get("gnbMenuNo"));
	    	lInfo.put("lnbMenuNo", linkInfo.get("menuNo"));
	    	lInfo.put("portletType", "");
	    	
	    	if(paramMap.get("pSeq").equals("0")) {
	    		lInfo.put("popYn", "N");
	    	}
	    	else {
	    		lInfo.put("popYn", "Y");
	    		
	    		String popUrl = "";
	    		if(paramMap.get("pType").equals("mail")) {
	    			popUrl = linkInfo.get("urlPath") + "readMailPopApi.do?muid=" + paramMap.get("pSeq") + "&email=" + resultVO.getEmail() + "@" + resultVO.getEmailDomain();
	    		}
	    		else if(paramMap.get("pType").equals("edms")) {
	    			popUrl = request.getScheme() + "://" + request.getServerName()+":"+request.getServerPort() + "/edms/board/viewPost.do?boardNo=" + paramMap.get("pSeq") + "&artNo=" + paramMap.get("pMenu");
	    		}
	    		else {
	    			popUrl = request.getScheme() + "://" + request.getServerName()+":"+request.getServerPort() + "/ea/edoc/eapproval/docCommonDraftView.do?multiViewYN=Y&diSeqNum=0000000001&miSeqNum=0000000001&diKeyCode=" + paramMap.get("pSeq");
	    		}
	    		
	    		lInfo.put("popUrl", popUrl);
	    	}
	    	request.getSession().setAttribute("enpassLinkInfo", lInfo);
	    	mv.addObject("rURL", request.getScheme() + "://"+request.getServerName()+":"+request.getServerPort()+"/gw/bizboxSW.do");
	    	mv.addObject("alertMsg", "");
		}
		
		return mv;
	}
	
	
	@RequestMapping("/OuterLogOn.do")
	public ModelAndView OuterLogOn(@RequestParam(value="LOGIN_ID", required=false) String loginId,  
								   @RequestParam(value="MENU_URL", required=false) String menuUrl, 
								   @RequestParam(value="IU_KEY", required=false) String iuKey, 
								   @RequestParam(value="IU_ERP", required=false) String iuErp, 
								   @RequestParam(value="FORM_ID", required=false) String formId, 
								   @RequestParam(value="DOC_ID", required=false) String docId,
								   @RequestParam(value="groupSeq", required=false) String groupSeq,
								   @ModelAttribute("loginVO") LoginVO loginVO, 
	    		                   HttpServletRequest request,
	    		                   ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
    	/** SSO 처리 **/
    	String userSe = "SW";
    	loginVO.setUserSe(userSe);
    	loginVO.setUniqId(loginId);
    	loginVO.setGroupSeq(groupSeq);
    	
    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
    	
    	request.getSession().setAttribute("loginVO", resultVO);
    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
    	
    	Map<String, Object> mp = new HashMap<String, Object>();
    	mp.put("groupSeq", resultVO.getGroupSeq());
    	mp.put("compSeq", resultVO.getComp_id());
    	
    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
    	request.getSession().setAttribute("optionSet", optionSet);
    	
    	
    	String rURL = request.getScheme() +"://" + request.getServerName();
    	rURL += "/ea/interface/erpGwLink.do?";
    	rURL += "menu=" + menuUrl;
    	rURL += "&form_id=" + formId;
    	rURL += "&id=" + loginId;
    	rURL += "&isPopup=Y";
    	rURL += "&IU_KEY=" + iuKey;
    	rURL += "&IU_ERP=" + iuErp;
    	rURL += "&approKey=" + iuKey;
    	rURL += "&docId=" + docId;
    	
    	Map<String,Object> lInfo = new HashMap<String,Object>();
    	lInfo.put("rURL", rURL);
    	
    	request.getSession().setAttribute("outerLinkInfo", lInfo);

    	
    	mv.setViewName("redirect:/bizboxOuter.do");
    	
    	
		return mv;
		
	}
	
	
	@RequestMapping("/OuterLogOn2.do")
	public ModelAndView OuterLogOn2(@RequestParam(value="groupSeq", required=false) String groupSeq, 
								  @RequestParam(value="compSeq", required=false) String compSeq, 
								  @RequestParam(value="empSeq", required=false) String empSeq, 
								  @RequestParam(value="approKey", required=false) String linkSeq, 
								  @RequestParam(value="formId", required=false) String formId,
								  @ModelAttribute("loginVO") LoginVO loginVO, 
	    		                  HttpServletRequest request,
	    		                  ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
    	/** SSO 처리 **/
    	String userSe = "USER";
    	loginVO.setUserSe(userSe);
    	loginVO.setGroupSeq(groupSeq);
    	loginVO.setCompSeq(compSeq);
    	loginVO.setUniqId(empSeq);
    	
    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
    	
    	request.getSession().setAttribute("loginVO", resultVO);
    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
    	
    	Map<String, Object> mp = new HashMap<String, Object>();
    	mp.put("groupSeq", resultVO.getGroupSeq());
    	mp.put("compSeq", resultVO.getComp_id());
    	
    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
    	request.getSession().setAttribute("optionSet", optionSet);
    	String targetUrl = "";
    	mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		return mv;
	}
	
	
	@RequestMapping("/TimsLogOn.do")
	public ModelAndView TimsLogOn(@RequestParam(value="groupSeq", required=false) String groupSeq, 
								  @RequestParam(value="compSeq", required=false) String compSeq, 
								  @RequestParam(value="empSeq", required=false) String empSeq, 
								  @RequestParam(value="approKey", required=false) String linkSeq, 
								  @RequestParam(value="formId", required=false) String formId,
								  @ModelAttribute("loginVO") LoginVO loginVO, 
	    		                  HttpServletRequest request,
	    		                  ModelMap model) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
    	/** SSO 처리 **/
    	String userSe = "USER";
    	loginVO.setUserSe(userSe);
    	loginVO.setGroupSeq(groupSeq);
    	loginVO.setCompSeq(compSeq);
    	loginVO.setUniqId(empSeq);
    	
    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
    	
    	request.getSession().setAttribute("loginVO", resultVO);
    	request.getSession().setAttribute("langCode", resultVO.getLangCode());
    	
    	Map<String, Object> mp = new HashMap<String, Object>();
    	mp.put("groupSeq", resultVO.getGroupSeq());
    	mp.put("compSeq", resultVO.getComp_id());
    	
    	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
    	request.getSession().setAttribute("optionSet", optionSet);
    	
//    	Map<String,Object> lInfo = new HashMap<String,Object>();
//    	lInfo.put("no", linkInfo.get("menuNo"));
//    	lInfo.put("name", linkInfo.get("gnbMenuNm"));
//    	lInfo.put("url", linkInfo.get("urlPath"));
//    	lInfo.put("urlGubun", linkInfo.get("targetPage"));
//    	lInfo.put("mainForward", "");
//    	lInfo.put("gnbMenuNo", linkInfo.get("gnbMenuNo"));
//    	lInfo.put("lnbMenuNo", linkInfo.get("menuNo"));
//    	lInfo.put("portletType", "");
//    	
//    	lInfo.put("popYn", linkInfo.get("popYn"));
//    	lInfo.put("popUrl", linkInfo.get("urlPath2"));
//    	request.getSession().setAttribute("extLinkInfo", lInfo);
    	
    	String targetUrl = "";
    	
    	//mv.setViewName("redirect:" + targetUrl);
    	mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	
    	
		return mv;
		
	}
	
	
	@RequestMapping("/getExPortletInfo.do")
	@ResponseBody
	public APIResponse getExPortletInfo(@RequestBody Map<String, Object> paramMap, HttpServletRequest request ) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = extService.getExPortletInfo(paramMap, request);
		
		return response;
	}
	
	@RequestMapping(value="/sessionTest" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public String sessionTest(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
	
		String result = "";
		
		if(params.get("type").equals("get")) {
			result = (String)request.getSession().getAttribute(params.get("key").toString());
		}else {
			request.getSession().setAttribute(params.get("key").toString(), params.get("val"));
			result = "success!";
		}		

		return result;		
	}	
	
}
