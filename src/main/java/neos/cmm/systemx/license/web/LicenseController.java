package neos.cmm.systemx.license.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.util.CommonUtil;

@Controller
public class LicenseController {
	/* 로그 설정 */
	Logger LOG = LogManager.getLogger(this.getClass());
	
	/* 변수 정의 서비스 */
	@Resource(name = "LicenseService")
	private LicenseService licenseService;
	
	/* 라이센스 카운트 표시 */
	@RequestMapping("/cmm/systemx/license/LicenseCountShow.do")
	public ModelAndView LicenseCountShow(@RequestParam Map<String, Object> params) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		/* 세션 값 */
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		/* 변수선언 */
		/* 라이센스 카운트 */
		Map<String, Object> licenseCount = new HashMap<String, Object>();
		
		try {
			params.put("groupSeq", loginVO.getGroupSeq());
			licenseCount = licenseService.LicenseCountShow(params);
			
		} catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [LicenseController] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.addObject("licenseCount", licenseCount);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/* 라이센스 체크 */
	@RequestMapping("/cmm/systemx/license/LicenseAddCheck.do")
	public ModelAndView LicenseCheck(@RequestParam Map<String, Object> params) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		/* 세션 값 */
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		/* 변수선언 */
		/* 라이센스 카운트 */
		Map<String, Object> licenseCount = new HashMap<String, Object>();
		/* 라이센스 체크 */
		Map<String, Object> licenseCheck = new HashMap<String, Object>();
		
		try {
			params.put("groupSeq", loginVO.getGroupSeq());
			licenseCount = licenseService.LicenseCountShow(params);
			
			params.put("licenseCount", licenseCount);
			params.get("licenseGubun");
			
			licenseCheck = licenseService.LicenseAddCheck(params);
		} catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [LicenseController] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.addObject("licenseCheck", licenseCheck);
		mv.setViewName("jsonView");
		
		return mv;
	}
}
