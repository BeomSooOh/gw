package neos.cmm.systemx.etc.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import neos.cmm.systemx.etc.service.LogoManageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import neos.cmm.util.BizboxAProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * 
 * @title 로고 이미지 변경을 위한 메뉴 controller
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 8. 27.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 8. 27.  박기환        최초 생성
 *
 */
@Controller
public class LogoManageController {

	@Resource(name="LogoManageService")
    protected LogoManageService logoManageService;
	
	/**
     * 로고 이미지 변경 관리 화면 이동
     * 
     * @param model
     * @return String
     * @throws Exception
     */    	
	@IncludedInfo(name="로고관리",order = 110006 ,gid = 40)
	@RequestMapping("/cmm/system/logoManageView.do")
    public String logoManageView(HttpServletRequest req, ModelMap model) throws Exception {
    	
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        
        if(!isAuthenticated) {
        	
        	if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99"){
        		return BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon");
        	}else {
        		return "redirect:/uat/uia/egovLoginUsr.do";
        	}
        } 			

        
        
        String memberType = req.getParameter("type");                
        
        model.addAttribute("type", memberType);
		model.addAttribute("LoginVO", user);
		
		return "/neos/cmm/System/member/MemberManageView";
    }
}
