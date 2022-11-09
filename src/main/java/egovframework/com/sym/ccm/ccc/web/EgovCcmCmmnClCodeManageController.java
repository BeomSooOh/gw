package egovframework.com.sym.ccm.ccc.web;

import java.util.List;
import javax.annotation.Resource;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.sym.ccm.ccc.service.CmmnClCode;
import egovframework.com.sym.ccm.ccc.service.CmmnClCodeVO;
import egovframework.com.sym.ccm.ccc.service.EgovCcmCmmnClCodeManageService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
/**
 * 
 * 공통분류코드에 관한 요청을 받아 서비스 클래스로 요청을 전달하고 서비스클래스에서 처리한 결과를 웹 화면으로 전달을 위한 Controller를 정의한다
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
public class EgovCcmCmmnClCodeManageController {
	@Resource(name = "CmmnClCodeManageService")
    private EgovCcmCmmnClCodeManageService cmmnClCodeManageService;
    
    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	@Autowired
	private DefaultBeanValidator beanValidator;
    
	/**
	 * 공통분류코드를 삭제한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param model
	 * @return "forward:/sym/ccm/ccc/EgovCcmCmmnClCodeList.do"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeRemove.do")
	public ModelAndView deleteCmmnClCode ( //@ModelAttribute("loginVO") LoginVO loginVO,
			 CmmnClCode cmmnClCode
			//, ModelMap model
			) throws Exception {

    	int result = -9;
		ModelAndView mv = new ModelAndView();	
		try{
			cmmnClCodeManageService.deleteCmmnClCode(cmmnClCode);
    		result = 0;
    	}catch(Exception e){
    		result = -9;
    	}

		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		return mv;	
	}

	/**
	 * 공통분류코드를 등록한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param bindingResult
	 * @return "egovframework/com/sym/ccm/ccc/EgovCcmCmmnClCodeRegist"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeRegist.do")
	public ModelAndView insertCmmnClCode (@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("cmmnClCode") CmmnClCode cmmnClCode
			//, BindingResult bindingResult , ModelMap model
			) throws Exception {  

    	int result = -9;
		ModelAndView mv = new ModelAndView();	

        //beanValidator.validate(cmmnClCode, bindingResult);
		//if (bindingResult.hasErrors()){
    	//	return "egovframework/com/sym/ccm/ccc/EgovCcmCmmnClCodeRegist";
		//}
    	//if   ( cmmnClCode.getClCode()== null	||"".equals(cmmnClCode.getClCode())) {   
		if(	EgovStringUtil.isEmpty(cmmnClCode.getClCode()) ) {
	    	result = -8;
    	
    	}else{
			CmmnClCode vo = cmmnClCodeManageService.selectCmmnClCodeDetail(cmmnClCode);
			if(vo != null){
				result = -1;
			}else{
				cmmnClCode.setFrstRegisterId(loginVO.getUniqId());
				cmmnClCodeManageService.insertCmmnClCode(cmmnClCode);
		    	result = 0;				
			}
		}
	
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		//mv.addAllObjects(resultMap);   // object 를 풀어서 개별 등록  data.result
		return mv;	
    }

	/**
	 * 공통분류코드 상세항목을 조회한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param model
	 * @return "egovframework/com/sym/ccm/ccc/EgovCcmCmmnClCodeDetail"
	 * @throws Exception
	@RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeDetail.do")
 	public String selectCmmnClCodeDetail (@ModelAttribute("loginVO") LoginVO loginVO
 			, CmmnClCode cmmnClCode
 			, ModelMap model
 			) throws Exception {
		CmmnClCode vo = cmmnClCodeManageService.selectCmmnClCodeDetail(cmmnClCode);
		model.addAttribute("result", vo);
		
		return "egovframework/com/sym/ccm/ccc/EgovCcmCmmnClCodeDetail";
	}
	 */

	/**
	 * 공통분류코드를 수정한다.
	 * @param clCode
	 * @return ModelAndView
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/ccc/selectCmmnClCodeDc.do")
	public ModelAndView selectCmmnClCodeDc (@RequestParam(required = true) String clCode) throws Exception {
    	
    	String clCodeDc = null;
    	int result = -9;
		ModelAndView mv = new ModelAndView();			
		
		if(EgovStringUtil.isEmpty(clCode)){
			result = -9;

		}else{
			try{		
				clCodeDc = cmmnClCodeManageService.selectCmmnClCodeDc(clCode);  // CmmnClCodeManageDAO.selectCmmnClCodeDc
				result = 0;
			}catch(Exception e){
				result = -9;
			}			
		}
		mv.setViewName("jsonView");
		mv.addObject("clCodeDc", clCodeDc);	// data.clCodeDc
		mv.addObject("result", result);	// data.result
		
		return mv;	 
    }
    

    /**
	 * 공통분류코드 목록을 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model
     * @return "egovframework/com/sym/ccm/ccc/EgovCcmCmmnClCodeList"
     * @throws Exception
     */
	@IncludedInfo(name="공통분류코드", listUrl="/sym/ccm/ccc/EgovCcmCmmnClCodeList.do", order = 960 ,gid = 60)
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeList.do")
	public String selectCmmnClCodeList (@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("searchVO") CmmnClCodeVO searchVO
			, ModelMap model
			) throws Exception {
    	/** EgovPropertyService.sample */
    	searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
    	searchVO.setPageSize(propertiesService.getInt("pageSize"));

    	/** pageing */
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());
		
		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
        List cmmnCodeList = cmmnClCodeManageService.selectCmmnClCodeList(searchVO);
		JSONArray  jsonArr = JSONArray.fromObject(cmmnCodeList);
		model.addAttribute("resultList", jsonArr);        
        
        int totCnt = cmmnClCodeManageService.selectCmmnClCodeListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);
        
        return "egovframework/com/sym/ccm/ccc/EgovCcmCmmnClCodeList"; 
	}

	/**
	 * 공통분류코드를 수정한다.
	 * @param loginVO
	 * @param cmmnClCode
	 * @param bindingResult
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/sym/ccm/ccc/EgovCcmCmmnClCodeModify"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/ccc/EgovCcmCmmnClCodeModify.do")
	public ModelAndView updateCmmnClCode (@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("administCode") CmmnClCode cmmnClCode
			//, BindingResult bindingResult
			//, Map commandMap
			//, ModelMap model
			) throws Exception {
    	
    	int result = -9;
		ModelAndView mv = new ModelAndView();	
		
		/*
		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
		
		//if(EgovStringUtil.isEmpty(sCmd)){
		if(sCmd.equals("Modify")) {
            //beanValidator.validate(cmmnCode, bindingResult);
    		//if (bindingResult.hasErrors()){
        	//	CmmnClCode vo = cmmnClCodeManageService.selectCmmnClCodeDetail(cmmnClCode);
        	//	model.addAttribute("cmmnClCode", vo);
    		cmmnClCode.setLastUpdusrId(loginVO.getUniqId());
	    	cmmnClCodeManageService.updateCmmnClCode(cmmnClCode);
	    	result = 0;
    	}else{
    	    result = -8;  		
    	}
    	*/
		try{		
    		cmmnClCode.setLastUpdusrId(loginVO.getUniqId());
	    	cmmnClCodeManageService.updateCmmnClCode(cmmnClCode);
			result = 0;
		}catch(Exception e){
			result = -9;
		}
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		
		return mv;	 
    }
	
}