package derp.interlock.controller;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import bizbox.orgchart.service.vo.LoginVO;
import derp.interlock.service.DerpInterlockService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
public class DerpInterlockController { 

	public static boolean LogOutCheck = false;
	
	@Resource ( name = "DerpInterlockService" )
	private DerpInterlockService derpInterlockService;
	
	@Resource(name = "loginService")
    private EgovLoginService loginService;
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;

	//그룹웨어 사용자 여부 확인
	@RequestMapping(value="/derp/checkUser.do")
	public ModelAndView checkUser(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView(); 
		
		String loginId = (String) paramMap.get("userid");
		String compSeq = (String) paramMap.get("comcode");
		
		if(EgovStringUtil.isEmpty(loginId) || EgovStringUtil.isEmpty(compSeq)) {
			//파라미터 검사
			mv.addObject("isUserYn", "N");
		}else {
			//사용자정보 조회 (재직사용자 기준)
			paramMap.put("loginId", loginId);
			paramMap.put("compSeq", compSeq);
			
			Map<String, Object> result = derpInterlockService.searchUserInfo(paramMap);
			
			if(result != null) {
				mv.addObject("isUserYn", "Y");
			}else {
				mv.addObject("isUserYn", "N");
			}
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	//SSO 인증 API
	@RequestMapping(value="/derp/derpProssLogOn.do")
	public ModelAndView derpProssLogOn(@RequestParam Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView(); 
		
		String loginId = null;
		String compSeq = null;
		try {
			String token = (String) params.get("token");
			String ssoDecKey = AESCipher.AES128EX_Decode(token,"1023497555960596");
			
			String[] keyVal = ssoDecKey.split("▦", -1);
			
			DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
			
			DateTime nowDt = DateTime.now().minusMinutes(2);
			
			DateTime ssoDt = formatter.parseDateTime(keyVal[0]);
			
			if(ssoDt.isAfter(nowDt)){
				loginId = keyVal[1];
				compSeq = keyVal[2];
			}
			
			if(loginId != null && loginId != "" && compSeq != null && compSeq != ""){
				
	        	params.put("loginId", loginId);
	        	params.put("compSeq", compSeq);
	        	Map<String,Object> custInfo = derpInterlockService.searchUserInfo(params);
	        	
	        	if(custInfo != null){
	        		
	        		//native_lang_Code 변경처리
	        		derpInterlockService.setUserLangCode(params);
	        		
	            	/** SSO 처리 **/
	            	LoginVO loginVO = new LoginVO();
	            	loginVO.setUserSe("USER");
	            	loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
	            	loginVO.setCompSeq((String) custInfo.get("organId"));
	            	loginVO.setUniqId((String) custInfo.get("uniqId"));
	            	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	            	
	            	request.getSession().invalidate();
	            	request.getSession().setAttribute("loginVO", resultVO);
	            	
	            	Map<String, Object> mp = new HashMap<String, Object>();
	    	    	mp.put("groupSeq", custInfo.get("groupSeq"));
	    	    	mp.put("compSeq", custInfo.get("compSeq"));
	            	
	            	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
	            	
	            	request.getSession().setAttribute("optionSet", optionSet);
	            	request.getSession().setAttribute("derpProssLogOnYn", "Y");
	            	
	            	request.setAttribute("langCode", resultVO.getLangCode());
	            	
	            	if(params.get("erpToken") != null) {
	            		request.getSession().setAttribute("X-Authenticate-Token", params.get("erpToken"));
	            	}
	            	
	            	mv.setViewName("redirect:/forwardIndex.do");
	        	}else {
	        		mv.setViewName("jsonView");
	    			mv.addObject("resultCode", "FAIL");
	    			return mv;
	        	}
			}else {
				mv.setViewName("jsonView");
    			mv.addObject("resultCode", "FAIL");
    			return mv;
			}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			mv.setViewName("jsonView");
			mv.addObject("resultCode", "FAIL");
			return mv;
		}
		
		return mv;
	}
	
	//메일 계정 정보 및 용량 정보 API
	@RequestMapping(value="/derp/checkMailInfo.do")
	public ModelAndView checkMailInfo(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView(); 
		mv.setViewName( "jsonView" );
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO == null) {
			mv.addObject("result","Session is null!!!");
			return mv;
		}
		
		try {
			String mailApiUrl = getMailPropValue("MAILBOX");
			String apiUrl = mailApiUrl +  "/api/checkMailBoxSize.jsp";
			
			JSONObject jsonParam = new JSONObject();
			jsonParam.put("domain", loginVO.getEmailDomain());
			jsonParam.put("id", loginVO.getEmail());
			
			JSONObject json = JSONObject.fromObject( HttpJsonUtil.execute( "GET", apiUrl, jsonParam) );
					
			mv.addObject("email", jsonParam.get("id") + "@" + jsonParam.get("domain"));
			mv.addObject("used", json.get("mailboxsize"));
			mv.addObject("total", json.get("mailboxmaxsize"));
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			mv.addObject("result","Server Error!!!!");
		}
		return mv;
	}
	
	
	
	public static String getMailPropValue(String key) {
        String result = "";
        try {
	        // 팩토리 생성
	        DocumentBuilderFactory dbfactory = DocumentBuilderFactory.newInstance();
	      //부적절한 XML 외부 개체 참조 (XXE 공격)
	        dbfactory.setFeature("http://xml.org/sax/features/external-general-entities", false);
	        dbfactory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
	        dbfactory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
	        // 빌더 생성
	        DocumentBuilder builder = dbfactory.newDocumentBuilder();
	        // Document오브젝트 취득

	        Document doc = builder.parse(new BufferedInputStream(new FileInputStream("../bizboxaconf/MailClientConfig.xml")));
	        // 루트의 자식 노드 취득
	        Element root = doc.getDocumentElement();
	        
	        NodeList list = root.getElementsByTagName(key);
	        Element cElement = (Element) list.item(0);
	  
	        if(cElement.getFirstChild()!=null) {
	        	result = cElement.getFirstChild().getNodeValue(); 
	        }
	    } catch (Exception e) {
	    	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	    }
        return result;
    }
	
	//PING 서비스 API
	@RequestMapping(value="/derp/checkSession.do")
	public ModelAndView checkSession(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView(); 
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!isAuthenticated || loginVO == null) {
			mv.addObject("resultCode", 401);
		}else {
			mv.addObject("resultCode", 200);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	//로그아웃 API
	@RequestMapping(value="/derp/actionLogout.do")
	public ModelAndView actionLogout(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView(); 
		
		LogOutCheck = true;
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
    	request.getSession().setAttribute("reLoginVO", loginVO);
    	request.getSession().setAttribute("loginVO" , new LoginVO());
    	request.getSession().removeAttribute("loginVO");
		
    	mv.setViewName("redirect:/j_spring_security_logout");
		return mv;
	}
	
	//로그아웃 API
	@RequestMapping(value="/derp/LogoutResult.do")
	public ModelAndView LogoutResult(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView(); 
		
		mv.setViewName("jsonView");
		mv.addObject("resultCode","SUCCESS");
		
		return mv;
	}
	
	
	@RequestMapping("/derp/forwardIndex.do")
	public ModelAndView forwardIndex(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView(); 		
			
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!isAuthenticated || loginVO == null) {
			mv.addObject("resultCode", "FAIL");
		}else {
			mv.addObject("resultCode", "SUCCESS");
		}
		
		mv.setViewName("jsonView");	
		
		return mv;
	}
	
	
	//로그아웃 API
	@RequestMapping("/derp/getMailToken.do")
	public ModelAndView getMailToken(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView(); 		
			
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!isAuthenticated || loginVO == null) {
			mv.addObject("token", "");
		}else {
			try {
				params.put("groupSeq", loginVO.getGroupSeq());
				Map<String, Object> groupInfo = groupManageService.getGroupInfo(params);
				
				String mailUrl = groupInfo.get("mailUrl") + "getToken.do";
				
				JSONObject json = new JSONObject();
				json.put("email", loginVO.getEmail() + "@" + loginVO.getEmailDomain());
				HttpJsonUtil httpJson = new HttpJsonUtil();
				String result = httpJson.execute("GET", mailUrl, json);
				
				JSONObject resultJson = JSONObject.fromObject(JSONSerializer.toJSON(result));
				
				mv.addObject("token", resultJson.get("token"));
			}catch(Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				mv.addObject("token", "");
			}
		}
		
		mv.setViewName("jsonView");	
		
		return mv;
	}
}
