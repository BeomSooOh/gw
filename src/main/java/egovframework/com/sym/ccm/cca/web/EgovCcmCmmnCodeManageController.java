package egovframework.com.sym.ccm.cca.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
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
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.ccm.cca.service.CmmnCode;
import egovframework.com.sym.ccm.cca.service.CmmnCodeVO;
import egovframework.com.sym.ccm.cca.service.EgovCcmCmmnCodeManageService;
import egovframework.com.sym.ccm.ccc.service.CmmnClCodeVO;
import egovframework.com.sym.ccm.ccc.service.EgovCcmCmmnClCodeManageService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import net.sf.json.JSONArray;

/**
 * 
 * 공통코드에 관한 요청을 받아 서비스 클래스로 요청을 전달하고 서비스클래스에서 처리한 결과를 웹 화면으로 전달을 위한 Controller를 정의한다
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
public class EgovCcmCmmnCodeManageController {

	@Resource(name = "EgovCcmCmmnCodeManageService")
    private EgovCcmCmmnCodeManageService cmmnCodeManageService;

	@Resource(name = "CmmnClCodeManageService")
    private EgovCcmCmmnClCodeManageService cmmnClCodeManageService;
	
    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	@Autowired
	private DefaultBeanValidator beanValidator;

    private static final Logger LOG = Logger.getLogger(EgovCcmCmmnCodeManageController.class.getName());
	/**
	 * 공통코드를 삭제한다.  
	 *  Edward : 미사용 obj 주석처리. 필요시 추가할것.  
	 * @param loginVO
	 * @param cmmnCode
	 * @param model
	 * @return "forward:/sym/ccm/cca/EgovCcmCmmnCodeList.do"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/cca/EgovCcmCmmnCodeRemove.do")
	public ModelAndView deleteCmmnCode (//@ModelAttribute("loginVO") LoginVO loginVO,
			 CmmnCode cmmnCode
			//, ModelMap model
			) throws Exception {

    	int result = -9;
		ModelAndView mv = new ModelAndView();	
		try{
			cmmnCodeManageService.deleteCmmnCode(cmmnCode);
    		result = 0;
    	}catch(Exception e){
    		LOG.error( "  Delete Error : "+e.getMessage());
    		result = -9;
    	}

		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		return mv;	
	}

	/**
	 * 공통코드를 등록한다.
	 * @param loginVO
	 * @param cmmnCode
	 * @param bindingResult
	 * @param model
	 * @return "egovframework/com/sym/ccm/cca/EgovCcmCmmnCodeRegist"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/cca/EgovCcmCmmnCodeRegist.do") 
	public ModelAndView insertCmmnCode (// @ModelAttribute("loginVO") LoginVO loginVO, 
			@ModelAttribute("cmmnCode") CmmnCode cmmnCode
			//, BindingResult bindingResult
			//, ModelMap model
			) throws Exception {    

    	int result = -9;
		ModelAndView mv = new ModelAndView();	

        //beanValidator.validate(cmmnCode, bindingResult);
		//if (bindingResult.hasErrors()){		}
    	if   (cmmnCode.getClCode() == null		||cmmnCode.getClCode().equals("")) {
	    	result = -8;
    	
    	}else{
    		
        	// 1. Spring Security 사용자권한 처리
        	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        	
        	if(isAuthenticated) {
            	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();     

        		try{		                	
        	    	cmmnCode.setFrstRegisterId(loginVO.getUniqId());
        	    	cmmnCodeManageService.insertCmmnCode(cmmnCode);
        	    	result = 0;
        		}catch(Exception e){
        			result = -9;
        		}
        	}else{
    	    	result = 100;    		
        	}
    	}
    	

		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		return mv;	    	
    }

	/**
	 * 공통코드 상세항목을 조회한다.
	 * @param loginVO
	 * @param cmmnCode
	 * @param model
	 * @return "egovframework/com/sym/ccm/cca/EgovCcmCmmnCodeDetail"
	 * @throws Exception
	@RequestMapping(value="/sym/ccm/cca/EgovCcmCmmnCodeDetail.do")
 	public String selectCmmnCodeDetail (@ModelAttribute("loginVO") LoginVO loginVO
 			, CmmnCode cmmnCode
 			, ModelMap model
 			) throws Exception {
		CmmnCode vo =cmmnCodeManageService.selectCmmnCodeDetail(cmmnCode);
		model.addAttribute("result", vo);
		
		return "egovframework/com/sym/ccm/cca/EgovCcmCmmnCodeDetail";
	}
	 */

	/**
	 * 공통분류코드를 수정한다.
	 * @param clCode
	 * @return ModelAndView
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/cca/EgovCcmCmmnCodeDc.do")
	public ModelAndView selectCcmCmmnCodeDc (@RequestParam(required = true) String codeId) throws Exception {
    	
    	String codeIdDc = null;
    	int result = -9;
		ModelAndView mv = new ModelAndView();			
		
		if(EgovStringUtil.isEmpty(codeId)){
			result = -9;

		}else{
			try{	  	
				codeIdDc = cmmnCodeManageService.selectCcmCmmnCodeDc(codeId);  //  CmmnCodeManageDAO.selectCcmCmmnCodeDc
				result = 0;
			}catch(Exception e){
				result = -9;
			}			
		}
		mv.setViewName("jsonView");
		mv.addObject("codeIdDc", codeIdDc);	// data.clCodeDc
		mv.addObject("result", result);	// data.result
		
		return mv;	 
    }
    /**
	 * 공통코드 목록을 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model
     * @return "egovframework/com/sym/ccm/cca/EgovCcmCmmnCodeList"
     * @throws Exception
     */
	//@IncludedInfo(name="공통코드", listUrl="/sym/ccm/cca/EgovCcmCmmnCodeList.do", order = 980 ,gid = 60)
    @RequestMapping(value="/sym/ccm/cca/EgovCcmCmmnCodeList.do")
	public String selectCmmnCodeList (//@ModelAttribute("loginVO") LoginVO loginVO,
			@ModelAttribute("searchVO") CmmnCodeVO searchVO
			, ModelMap model
			) throws Exception {
    	/** EgovPropertyService.sample */
    	/*searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
    	searchVO.setPageSize(propertiesService.getInt("pageSize"));

    	*//** pageing *//*
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());
		
		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
        List CmmnCodeList =cmmnCodeManageService.selectCmmnCodeList(searchVO);
        //model.addAttribute("resultList", CmmnCodeList);
		JSONArray  jsonArr = JSONArray.fromObject(CmmnCodeList);
		model.addAttribute("resultList", jsonArr);
        
        int totCnt =cmmnCodeManageService.selectCmmnCodeListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);
        
        //  ---------------------------
        //  등록/수정시 코드 조회
		CmmnClCodeVO searchClCodeVO;
		searchClCodeVO = new CmmnClCodeVO();
		searchClCodeVO.setRecordCountPerPage(999999);
		searchClCodeVO.setFirstIndex(0);
		searchClCodeVO.setSearchCondition("CodeList"); 
        List CmmnClCodeList = cmmnClCodeManageService.selectCmmnClCodeList(searchClCodeVO);

		jsonArr = JSONArray.fromObject(CmmnClCodeList);
		model.addAttribute("cmmnClCodeList", jsonArr);*/
        //  ---------------------------
        //
        
        return "egovframework/com/sym/ccm/cca/EgovCcmCmmnCodeList";  // edward 이녀석 통일 필요..   prefix로 '/'을 추가? 
	}
	
    @RequestMapping(value="/sym/ccm/cca/EgovCcmCmmnCodeList2.do")
	@ResponseBody
	public ModelAndView selectCmmnCodeList2 (@RequestParam Map<String, Object> paramMap, ModelMap model) throws Exception{
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
		
		try{
			Map<String, Object> map =cmmnCodeManageService.selectCmmnCodeList(paramMap, paginationInfo);
	        //model.addAttribute("resultList", CmmnCodeList);
			JSONArray  jsonArr = JSONArray.fromObject(map);
			model.addAttribute("resultList", jsonArr);
	                
	        //  ---------------------------
	        //  등록/수정시 코드 조회
			CmmnClCodeVO searchClCodeVO;
			searchClCodeVO = new CmmnClCodeVO();
			searchClCodeVO.setRecordCountPerPage(999999);
			searchClCodeVO.setFirstIndex(0);
			searchClCodeVO.setSearchCondition("CodeList"); 
	        List cmmnClCodeList = cmmnClCodeManageService.selectCmmnClCodeList(searchClCodeVO);
	
			jsonArr = JSONArray.fromObject(cmmnClCodeList);
			model.addAttribute("cmmnClCodeList", jsonArr);
			mv.setViewName("jsonView");
			mv.addAllObjects(map);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return mv;
	}

	/**
	 * 공통코드를 수정한다.
	 * @param loginVO
	 * @param cmmnCode
	 * @param bindingResult
	 * @param commandMap
	 * @param model
	 * @return "egovframework/com/sym/ccm/cca/EgovCcmCmmnCodeModify"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/ccm/cca/EgovCcmCmmnCodeModify.do")
	public ModelAndView updateCmmnCode ( //@ModelAttribute("loginVO") LoginVO loginVO,
			@ModelAttribute("cmmnCode") CmmnCode cmmnCode
			//, BindingResult bindingResult
			, Map commandMap
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
        	//	CmmnCode vo =cmmnCodeManageService.selectCmmnCodeDetail(cmmnCode);
        	//	model.addAttribute("cmmnCode", vo);
    		cmmnCode.setLastUpdusrId(loginVO.getUniqId());
	    	cmmnCodeManageService.updateCmmnCode(cmmnCode);
	    	result = 0;
    	}else{
    	    result = -8;  		
    	}
    	*/

    	// 1. Spring Security 사용자권한 처리
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	
    	if(isAuthenticated) {
        	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();     

    		try{		  
    			cmmnCode.setLastUpdusrId(loginVO.getUniqId());
    			cmmnCodeManageService.updateCmmnCode(cmmnCode);
    			result = 0;
    		}catch(Exception e){
    			result = -9;
    		}
    	}else{
	    	result = 100;    		
    	}
    	

		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		
		return mv;	   
    }
	
}