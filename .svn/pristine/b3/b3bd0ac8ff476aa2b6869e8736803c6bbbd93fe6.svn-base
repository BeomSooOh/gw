package neos.cmm.erp.sso.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.uat.uia.service.EgovLoginService;
import main.web.BizboxAMessage;
import neos.cmm.erp.sso.service.ErpService;
import bizbox.orgchart.service.vo.LoginVO;


@Controller
public class BizboxErpController {
	@Resource(name="ErpService")
	ErpService erpService;
	
	/** EgovLoginService */
	@Resource(name = "loginService")
    private EgovLoginService loginService;
	
	
	@RequestMapping("/ErpLogOn.do")
	public ModelAndView ErpLogOn(@RequestParam(value="compSeq", required=false) String compSeq, 
								 @RequestParam(value="loginId", required=false) String loginId,  
								 @ModelAttribute("loginVO") LoginVO loginVO, 
	    		                 HttpServletRequest request,
	    		                 ModelMap model) throws Exception {
		
	    ModelAndView mv = new ModelAndView();
		
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("compSeq", compSeq);
    	params.put("loginId", loginId);
    	
    	
    	/** 링크메뉴정보 가져오기 **/
    	Map<String,Object> linkInfo = erpService.selectLinkMenuInfo(params);
    	
    	if (linkInfo != null) {
	    	Map<String,Object> lInfo = new HashMap<String,Object>();
//	    	lInfo.put("no", linkInfo.get("menuNo"));
//	    	lInfo.put("name", linkInfo.get("linkNmKr"));
//	    	lInfo.put("url", linkInfo.get("urlPath"));
//	    	lInfo.put("urlGubun", linkInfo.get("msgTarget"));
	    	lInfo.put("no", "2000000000");
	    	lInfo.put("name", BizboxAMessage.getMessage("TX000000479","전자결재"));
	    	lInfo.put("url", "");
	    	lInfo.put("urlGubun", "eap");
	    	
	    	lInfo.put("mainForward", "");
	    	lInfo.put("gnbMenuNo", "");
	    	lInfo.put("lnbMenuNo", "");
	    	lInfo.put("portletType", "");
	    	
	    	
	    	/** SSO 처리 **/
	    	String userSe = "USER";
	    	loginVO.setUserSe(userSe);
	    	loginVO.setGroupSeq((String) linkInfo.get("groupSeq"));
	    	loginVO.setCompSeq((String) linkInfo.get("compSeq"));
	    	loginVO.setUniqId((String) linkInfo.get("empSeq"));
	    	 	
	    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);
	    	
	    	request.getSession().setAttribute("loginVO", resultVO);
	    	request.getSession().setAttribute("ssoLinkInfo", lInfo);
	    	//RequestContextHolder.getRequestAttributes().setAttribute("loginVO", resultVO, RequestAttributes.SCOPE_SESSION);
	    	
			mv.setViewName("redirect:/bizboxSSO.do");
    	}
    	else{
    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
    	}
    	
		return mv;
	}
	
}
