package neos.cmm.systemx.cmmCode.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.cmmCode.service.CmmCodeManageService;
import neos.cmm.util.CommonUtil;

@Controller
public class CmmCodeManageController {
	
	@Resource(name = "CmmCodeManageService")
	private CmmCodeManageService cmmCodeManageService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	

	/** EgovMessageSource */
	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	/**
	 * 공통코드 목록 페이지를 호출한다.
     * @param Map<String, Object> paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping("/cmm/systemx/CmmCodeList.do")
	public ModelAndView selectCmmnCodeList (@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		mv.setViewName("/neos/cmm/systemx/cmmCode/cmmCodeList"); 
		return mv;
	}
    
    /**
	 * 공통코드 목록을 조회한다.
     * @param Map<String, Object> paramMap
     * @return Json
     * @throws Exception
     */
    @RequestMapping(value="/cmm/systemx/CmmCodeListData.do")
   	@ResponseBody
   	public ModelAndView CmmCodeListData (@RequestParam Map<String, Object> paramMap, ModelMap model) throws Exception{
   		ModelAndView mv = new ModelAndView();
   				
   		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
   		paramMap.put("loginvo", loginVO);
   		paramMap.put("langCode", loginVO.getLangCode());
   		
   		List<Map<String, Object>> codeList = new ArrayList<>();
   		
   		try{
   			codeList =cmmCodeManageService.cmmCodeList(paramMap);
   	        //model.addAttribute("resultList", CmmnCodeList);
   		}catch(Exception e){
   			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
   		}
   		
           
   		mv.setViewName("jsonView");
   		mv.addObject("resultList",codeList);
   		return mv;
   	}
    
    /**
	 * 공통코드 저장 한다.
     * @param Map<String, Object> paramMap
     * @return Json
     * @throws Exception
     */
    @RequestMapping(value="/cmm/systemx/CmmCodeSaveProc.do")
   	@ResponseBody
   	public ModelAndView CmmCodeSaveProc (@RequestParam Map<String, Object> paramMap, ModelMap model) throws Exception{
   		ModelAndView mv = new ModelAndView();
   				
   		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
   		paramMap.put("loginVO", loginVO);
   		
   		//CRUD 타입
   		String crudType = paramMap.get("crudType")+"";
   		Map<String,Object> result = new HashMap<>();
		
   		//새로 저장할 시
		if(crudType.equals("I")){	
	   		result = cmmCodeManageService.cmmCodeSaveProc(paramMap);
		//수정
		}else if(crudType.equals("U")){
			result = cmmCodeManageService.cmmCodeUpdateProc(paramMap);
		}
           
   		mv.setViewName("jsonView");
   		mv.addObject("result", result.get("cnt")+"");
   		return mv;
   	}
    
    /**
	 * 공통코드 삭제 한다.
     * @param Map<String, Object> paramMap
     * @return Json
     * @throws Exception
     */
    @RequestMapping(value="/cmm/systemx/CmmCodeDel.do")
   	@ResponseBody
   	public ModelAndView CmmCodeDelProc (@RequestParam Map<String, Object> paramMap, ModelMap model) throws Exception{
   		ModelAndView mv = new ModelAndView();
   				
   		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
   		paramMap.put("loginVO", loginVO);
   		
   		//CRUD 타입
   		String items = paramMap.get("items")+"";
   		
   		if(!items.isEmpty()){
	   		String[] checkItem = items.split(",");
	   		
	   		for(int i = 0; i < checkItem.length; i++ ){
	   			paramMap.put("codeId", checkItem[i]);
	   			cmmCodeManageService.cmmCodeDelete(paramMap);
	   		}
   		}  	   		
           
   		mv.setViewName("jsonView");
   		return mv;
   	}
    
    /**
	 * 공통코드 상세목록 페이지를 호출한다.
     * @param Map<String, Object> paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping("/cmm/systemx/CmmCodeDetailList.do")
	public ModelAndView selectCmmnDetailCodeList (@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		mv.setViewName("/neos/cmm/systemx/cmmCode/cmmCodeDetailList"); 
		return mv;
	}
    
    /**
	 * 공통코드상세 목록을 조회한다.
     * @param Map<String, Object> paramMap
     * @return Json
     * @throws Exception
     */
    @RequestMapping(value="/cmm/systemx/CmmCodeDetailListData.do")
   	@ResponseBody
   	public ModelAndView CmmDetailCodeListData (@RequestParam Map<String, Object> paramMap, ModelMap model) throws Exception{
   		ModelAndView mv = new ModelAndView();
   				
   		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
   		paramMap.put("loginvo", loginVO);
   		paramMap.put("langCode", loginVO.getLangCode());
   		
   		List<Map<String, Object>> codeDetailList = new ArrayList<>();
   		
   		try{
   			codeDetailList =cmmCodeManageService.cmmCodeDetailList(paramMap);
   			//codeList =cmmCodeManageService.cmmCodeList(paramMap);
   		}catch(Exception e){
   			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
   		}
   		
           
   		mv.setViewName("jsonView");
   		mv.addObject("resultList",codeDetailList);
   		//mv.addObject("codeList", codeList);
   		return mv;
   	}
    
    /**
	 * 공통코드 코드유형 선택 팝업을 호출한다.
     * @param Map<String, Object> paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping("/cmm/systemx/CmmCodeSelectPop.do")
	public ModelAndView selectCmmnCodePop (@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/cmmCode/pop/cmmCodeSelPop"); 
		return mv;
	}
    
    /**
	 * 공통코드 목록을 조회한다.
     * @param Map<String, Object> paramMap
     * @return Json
     * @throws Exception
     */
    @RequestMapping(value="/cmm/systemx/CmmGetCodeList.do")
   	@ResponseBody
   	public ModelAndView CmmGetCodeList (@RequestParam Map<String, Object> paramMap) throws Exception{
   		ModelAndView mv = new ModelAndView();
   				
   		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
   		paramMap.put("langCode", loginVO.getLangCode());
   		
   		List<Map<String, Object>> codeList = new ArrayList<>();
   		
   		try{
   			codeList =cmmCodeManageService.cmmGetCodeList(paramMap);
   	        //model.addAttribute("resultList", CmmnCodeList);
   		}catch(Exception e){
   			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
   		}
   		
           
   		mv.setViewName("jsonView");
   		mv.addObject("resultList",codeList);
   		return mv;
   	}    
    

}
