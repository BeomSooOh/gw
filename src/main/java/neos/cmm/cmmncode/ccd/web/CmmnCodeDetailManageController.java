package neos.cmm.cmmncode.ccd.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.ccm.ccc.service.EgovCcmCmmnClCodeManageService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.cmmncode.ccd.service.CmmnCodeDetailManageService;
import neos.cmm.cmmncode.ccm.service.CmmnCodeDetail;
import neos.cmm.cmmncode.cct.service.CmmnCodeManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import net.sf.json.JSONArray;

/**
 * 
 * 공통상세코드에 관한 요청을 받아 서비스 클래스로 요청을 전달하고 서비스클래스에서 처리한 결과를 웹 화면으로 전달을 위한 Controller를 정의한다
 * @author 공통서비스 개발팀 이중호
 * @since 2009.04.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.04.01  이중호          최초 생성
 *   2011.8.26	정진오			IncludedInfo annotation 추가
 *
 * </pre>
 */

@Controller
public class CmmnCodeDetailManageController {

	@Resource(name = "CmmnCodeDetailManageService")
    private CmmnCodeDetailManageService cmmnCodeDetailManageService;

	@Resource(name = "CmmnClCodeManageService")
    private EgovCcmCmmnClCodeManageService cmmnClCodeManageService;

	@Resource(name = "CmmnCodeManageService")
    private CmmnCodeManageService cmmnCodeManageService;
	
    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	@Autowired
	private DefaultBeanValidator beanValidator;
    
	/**
	 * 공통상세코드를 삭제한다.
	 * @param loginVO
	 * @param cmmnDetailCode
	 * @param model
	 * @return "forward:/sym/ccm/cde/EgovCcmCmmnDetailCodeList.do"
	 * @throws Exception
	 */
    @RequestMapping(value="/cmm/cmmncode/ccd/CmmnCodeDetailRemove.do")
	public ModelAndView deleteCmmnCodeDetail (	@ModelAttribute("cmmnCodeDetail") CmmnCodeDetail cmmnCodeDetail
			) throws Exception {
    	int result = -9;
		ModelAndView mv = new ModelAndView();	

		try{
			cmmnCodeDetailManageService.deleteCmmnCodeDetail(cmmnCodeDetail);
			result= 0;
		}catch(Exception e){
			result = -9;
		}
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		//mv.addAllObjects(resultMap);   // object 를 풀어서 개별 등록  data.result
		return mv;	
      
	}

	/**
	 * 공통상세코드를 등록한다.
	 * @param loginVO
	 * @param cmmnDetailCode
	 * @param cmmnCode
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/sym/ccm/cde/EgovCcmCmmnDetailCodeRegist"
	 * @throws Exception
	 */
    @RequestMapping(value="/cmm/cmmncode/ccd/CmmnCodeDetailRegist.do")
	public ModelAndView insertCmmnCodeDetail	(@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("cmmnCodeDetail") CmmnCodeDetail cmmnCodeDetail
			) throws Exception {

    	int result = -9;
		ModelAndView mv = new ModelAndView();		    	
		// ------------------------
    	// TOTO  validation check
			//String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
    		//if (sCmd.equals("Regist")) {}
		// ------------------------		
		
		CmmnCodeDetail vo = cmmnCodeDetailManageService.selectCmmnCodeDetailDetail(cmmnCodeDetail);
    	if(vo != null){
    		 result = -1;
    	}else{
	    	cmmnCodeDetail.setFrstRegisterId(loginVO.getUniqId());
	    	cmmnCodeDetailManageService.insertCmmnCodeDetail(cmmnCodeDetail);	
	    	result = 0;
    	}
    	
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		//mv.addAllObjects(resultMap);   // object 를 풀어서 개별 등록  data.result
		return mv;	
    }
    
    @IncludedInfo(name="공통상세코드", order = 970 ,gid = 60)
    @RequestMapping("/cmm/cmmncode/ccd/CmmnCodeDetailList.do")
	public ModelAndView selectCmmnCodeDetailList (@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();

        // 전체를 가져와서 jsp 에서 가공하여 사용한다.  compare id =  CL_CODE
        List<Map<String,Object>> cmmnCodeList = cmmnCodeManageService.selectCmmnCodeList(params);
        //model.addAttribute("cmmnCodeList", CmmnCodeList);
		mv.addObject("cmmnCodeList", cmmnCodeList);
		
		
		mv.setViewName("/neos/cmm/cmmncode/ccd/CmmnCodeDetailList");
		return mv;
	}

    /**
	 * 공통상세코드 목록을 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model
     * @return "egovframework/com/sym/ccm/cde/EgovCcmCmmnDetailCodeList"
     * @throws Exception
     */

    @RequestMapping(value="/cmm/cmmncode/ccd/CmmnCodeDetailList2.do")
    @ResponseBody
    public ModelAndView selectCmmnCodeDetailList2 (@RequestParam Map<String, Object> paramMap, ModelMap model) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	String fromDate= "" ;
    	String toDate= "" ;
    	
    		toDate = DateUtil.getCurrentDate("yyyyMMdd");
    		fromDate = DateUtil.getFormattedDateMonthAdd(toDate, "yyyyMMdd", "yyyyMMdd", -1);
    		paramMap.put("fromDate", fromDate);
    		paramMap.put("toDate", toDate);
    		
    	PaginationInfo paginationInfo = new PaginationInfo();
    	int pageSize =  10;
    	int page = 1 ;
    	String temp = (String)paramMap.get("pageSize");
    	if (!EgovStringUtil.isEmpty(temp )  ) {
    		pageSize = Integer.parseInt(temp) ;
    	}
    	temp = (String)paramMap.get("page") ;
    	if (!EgovStringUtil.isEmpty(temp )  ) {
    		page = Integer.parseInt(temp) ;
    	}
    	
    	paginationInfo.setPageSize(pageSize);
    	paginationInfo.setCurrentPageNo(page);
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	paramMap.put("loginvo", loginVO);
    	paramMap.put("langCode", loginVO.getLangCode());
    	
    	try{
    		Map<String, Object> map =cmmnCodeDetailManageService.selectCmmnCodeDetailList(paramMap, paginationInfo);
    		//model.addAttribute("resultList", CmmnCodeList);
    		JSONArray  jsonArr = JSONArray.fromObject(map);
    		model.addAttribute("resultList", jsonArr);
    				
    		//  ---------------------------
    		//  등록/수정시 코드 조회
    		//CmmnCodeDetailVO searchVO;
    		//searchVO = new CmmnCodeDetailVO();
    		//searchVO.setRecordCountPerPage(999999);
    		//searchVO.setFirstIndex(0);
    		//searchVO.setSearchCondition("CodeList"); 
    		//List CmmnCodeDetailList = cmmnCodeDetailManageService.selectCmmnCodeDetailList(searchVO);

    		//jsonArr = JSONArray.fromObject(CmmnCodeDetailList);
    		//model.addAttribute("cmmnCodeDetailList", jsonArr);
    		mv.setViewName("jsonView");
    		mv.addAllObjects(map);
    	}catch(Exception e){
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
        return mv;
	}

    
	/**
	 * 공통상세코드를 수정한다.
	 * @param loginVO
	 * @param cmmnDetailCode
	 * @param bindingResult
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/sym/ccm/cde/EgovCcmCmmnDetailCodeModify"
	 * @throws Exception
	 */
    @RequestMapping(value="/cmm/cmmncode/ccd/CmmnCodeDetailModify.do")
	public ModelAndView pdateCmmnCodeDetail (@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("cmmnCodeDetail") CmmnCodeDetail cmmnCodeDetail
			//, BindingResult bindingResult
			//, Map commandMap
			) throws Exception {

    	int result = -9;	
		ModelAndView mv = new ModelAndView();
		
		//String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		/*
        beanValidator.validate(cmmnDetailCode, bindingResult);
		if (bindingResult.hasErrors()){
    		CmmnDetailCode vo = cmmnDetailCodeManageService.selectCmmnDetailCodeDetail(cmmnDetailCode);
    		model.addAttribute("cmmnDetailCode", vo);
    		return "egovframework/com/sym/ccm/cde/EgovCcmCmmnDetailCodeModify";
		}
		*/
		try{
			cmmnCodeDetail.setLastUpdusrId(loginVO.getUniqId());
	    	cmmnCodeDetailManageService.updateCmmnCodeDetail(cmmnCodeDetail);
	    	result = 0;
		}catch(Exception e){
    		result = -9;
    	}

		mv.setViewName("jsonView");
		mv.addObject("result", result);
		return mv;		
    }
    
    @RequestMapping("/cmm/cmmncode/ccd/selectCodePopupView.do")
	public ModelAndView selectCodePopupView (@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		
    	ModelAndView mv = new ModelAndView();
		
    	mv.setViewName("/neos/cmm/cmmncode/ccd/selectCodePopupView");
		
    	return mv;
	}
    
    /*@RequestMapping("/cmm/cmmncode/ccd/selectCodePopupView.do")
	public String selectIdCheck(@ModelAttribute("MemberInfo") MemberInfo memberInfo, ModelMap model) throws Exception{
		
		if(memberInfo.getEmplyrId().length()>0){
			//공백 제거
			memberInfo.setEmplyrId(EgovStringUtil.removeWhitespace(memberInfo.getEmplyrId()));			
			
			MemberInfo idChek = memberManageService.searchMemberId(memberInfo);
			
			if(idChek==null){
				model.addAttribute("idChk", "yes");
				model.addAttribute("emplyrId", memberInfo.getEmplyrId());
			}else {
				model.addAttribute("idChk", "no");				
			}									
			
		}
		
		return "/neos/cmm/cmmncode/ccd/selectCodePopupView";
	}*/
    /*
	@RequestMapping("/cmm/system/selectIdCheck.do")
	public String selectIdCheck(@ModelAttribute("MemberInfo") MemberInfo memberInfo, ModelMap model) throws Exception{
		
		if(memberInfo.getEmplyrId().length()>0){
			//공백 제거
			memberInfo.setEmplyrId(EgovStringUtil.removeWhitespace(memberInfo.getEmplyrId()));			
			
			MemberInfo idChek = memberManageService.searchMemberId(memberInfo);
			
			if(idChek==null){
				model.addAttribute("idChk", "yes");
				model.addAttribute("emplyrId", memberInfo.getEmplyrId());
			}else {
				model.addAttribute("idChk", "no");				
			}									
			
		}
		
		return "/popup/neos/cmm/System/member/MemberIdCheckView";
	}
    */

}