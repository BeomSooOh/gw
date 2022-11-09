package api.fax.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.util.EgovUserDetailsHelper;
import api.common.model.APIResponse;
import api.fax.service.FaxService;
import bizbox.orgchart.service.vo.LoginVO;

@Controller
public class FaxController {
	
	@Resource(name="FaxService")
	private FaxService faxService;
	
	@RequestMapping(value="/fax/web/master/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse webMaster(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			@PathVariable String serviceName, @RequestBody Map<String, Object> request){

		return faxService.action(servletRequest, request, "MASTER", serviceName);
	}
	
	@RequestMapping(value="/fax/web/admin/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse webAdmin(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			@PathVariable String serviceName, @RequestBody Map<String, Object> request){
		//System.out.println("request : " + request);
		//System.out.println("serviceName : " + serviceName);
		//System.out.println("servletRequest : " + servletRequest);
		return faxService.action(servletRequest, request, "ADMIN", serviceName);
	}
	
	@RequestMapping(value="/fax/web/user/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse webUser(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			@PathVariable String serviceName, @RequestBody Map<String, Object> request){
		
		return faxService.action(servletRequest, request, "USER", serviceName);
	}
	
	@RequestMapping(value="/fax/mobile/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse mobile(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			@PathVariable String serviceName, @RequestBody Map<String, Object> request){
		
		return faxService.action4m(servletRequest, request, serviceName);
	}
	
	@RequestMapping(value="/fax/Send", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse send(MultipartHttpServletRequest servletRequest, HttpServletResponse servletResponse){
		
		return faxService.faxSend(servletRequest);
	}
	
	
	@RequestMapping(value="/fax/download/{agentId}/{agentKey}/{sendType}/{faxKey}/{fileNum}", method=RequestMethod.GET)
	public void download(HttpServletRequest reqeust, HttpServletResponse response
			, @PathVariable("agentId") String agentId, @PathVariable("agentKey") String agentKey
			, @PathVariable("sendType") String sendType, @PathVariable("faxKey") String faxKey
			, @PathVariable("fileNum") String fileNum) {
		
		faxService.download(response, agentId, agentKey, sendType, faxKey, fileNum);
	}
	
	@RequestMapping(value="/fax/alarm", method=RequestMethod.POST)
	public void alarm(HttpServletRequest servletRequest, HttpServletResponse servletResponse,
			@RequestBody String request) {
		
		faxService.alarm(request);
	}
	
	/**	2016.03.10 장지훈
	 * faxMasterView (팩스 연동설정 화면 가져오기)
	 * @param params
	 * @return
	 */
	@RequestMapping(value="/fax/web/master/faxMasterView")
	public ModelAndView faxMasterView(@RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/fax/faxMasterView");
		
		return mv;
	}
	
	
	/** 2016.03.10 장지훈
	 * getFaxInfo : 팩스 아이디, 팩스비밀번호, 사용 여부 가져오기 
	 * @param params
	 * 					faxSeq : 팩스 시퀀스
	 * @return
	 */
	@RequestMapping(value="/fax/web/master/getFaxInfo")
	public ModelAndView getFaxInfo(@RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result = faxService.getFaxInfo(params);

		mv.addObject("faxInfo", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * popFaxChargeInfo : 요금안내 팝업창 호출 
	 * @return
	 */
	@RequestMapping(value = "/fax/web/master/popFaxChargeInfo")
	public ModelAndView popFaxChargeInfo() {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/fax/pop/popFaxChargeInfo");
		
		return mv;
	}
	
	// 팩스번호회사설정 페이지 호출
	@RequestMapping(value="/fax/web/master/setFaxNumAndCompView")
	public ModelAndView setFaxNumAndCompView(@RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/fax/faxNumAndCompView");
		
		return mv;
	}
	
	// 팩스 아이디, 팩스 번호 리스트 조회
	@RequestMapping(value="/fax/web/master/getFaxIDAndNO")
	public ModelAndView getFaxIDAndNO(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		//System.out.println("getFaxIDAndNO : " + params);
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result = faxService.getFaxIDAndNO(servletRequest, params);

		mv.setViewName("jsonView");
		mv.addAllObjects(result);

		return mv;
	}
	
	// 회사 설정 리스트 조회
	@RequestMapping(value="/fax/web/master/getFaxComp")
	public ModelAndView getFaxComp(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		//System.out.println("getFaxComp : " + params);
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result = faxService.getFaxComp(servletRequest, params);

		mv.setViewName("jsonView");
		mv.addAllObjects(result);

		//System.out.println("controller : " + result);
		return mv;
	}
	
	// 팩스 번호연결 설정 View (관리자화면)
	@RequestMapping(value="/fax/web/admin/faxNumConnectView")
	public ModelAndView faxNumConnectView(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)servletRequest.getSession().getAttribute("loginVO");
		
		
		mv.addObject("groupSeq", (loginVO.getGroupSeq() == null ? "0"
				: loginVO.getGroupSeq()));
		mv.addObject("empSeq",
				(loginVO.getUniqId() == null ? "0" : loginVO.getUniqId()));
		mv.addObject("deptSeq", (loginVO.getOrgnztId() == null ? "0"
				: loginVO.getOrgnztId()));
		mv.addObject("compSeq", (loginVO.getCompSeq() == null ? "0"
				: loginVO.getCompSeq()));
		mv.addObject("langCode", (loginVO.getLangCode() == null ? "kr"
				: loginVO.getLangCode()));
		mv.addObject("userSe",
				(loginVO.getUserSe() == null ? "" : loginVO.getUserSe()));
		
		mv.setViewName("/neos/cmm/ex/fax/admin/faxNumConnectView");
		
		return mv;
	}
	
	// 부서/사원 선택 (시퀀스 값으로 이름 값 변환해서 보내기)
	@RequestMapping(value="/fax/web/admin/getNameChange")
	public ModelAndView getNameChange(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
		APIResponse response = null;
		ModelAndView mv = new ModelAndView();
		//System.out.println("이름값 변환 컨트롤러 : " + params);
		
		response = faxService.getNameChange(params);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/fax/web/master/popSMSCompanySelect.do")
	public ModelAndView popSMSCompanySelect(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/fax/pop/popSMSCompanySelect");
		
		return mv;
	}

//	@RequestMapping("/fax/web/master/setSmsComp.do")
//	public ModelAndView setSmsComp(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
//		APIResponse response = null;
//		ModelAndView mv = new ModelAndView();
//		
//		Map<String, Object> result = new HashMap<String, Object>();
//		
//		result = faxService.setSmsComp(servletRequest, params);
//
//		mv.setViewName("jsonView");
//		mv.addAllObjects(result);
//		
//		return mv;
//	}
	
	
	
	//팩스별칭옵션 팝업
	@RequestMapping("/fax/web/master/FaxNickNameOptionPop.do")
	public ModelAndView FaxNickNameOptionPop(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(loginVO == null){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		//별치표시 설정값 조회
		params.put("groupSeq", loginVO.getGroupSeq());
		String optionValue = faxService.getFaxNickNameOption(params);
		
		mv.addObject("nickNameOptionValue", optionValue);
		mv.setViewName("/neos/cmm/ex/fax/pop/FaxNickNameOptionPop");
		
		return mv;
	}
	
	//팩스별칭설정팝업
	@RequestMapping("/fax/web/master/FaxNickNameSetPop.do")
	public ModelAndView FaxNickNameSetPop(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params) {
		ModelAndView mv = new ModelAndView();
		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(loginVO == null){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		mv.addAllObjects(params);
		mv.addObject("nickName", faxService.getFaxNickName(params));

		mv.setViewName("/neos/cmm/ex/fax/pop/FaxNickNameSetPop");
		
		return mv;
	}
}
