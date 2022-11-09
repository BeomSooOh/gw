package egovframework.com.sym.ccm.cde.web;

import java.util.List;

import javax.annotation.Resource;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.service.CmmnDetailCode;
import egovframework.com.sym.ccm.cca.service.CmmnCodeVO;
import egovframework.com.sym.ccm.cca.service.EgovCcmCmmnCodeManageService;
import egovframework.com.sym.ccm.ccc.service.CmmnClCodeVO;
import egovframework.com.sym.ccm.ccc.service.EgovCcmCmmnClCodeManageService;
import egovframework.com.sym.ccm.cde.service.CmmnDetailCodeVO;
import egovframework.com.sym.ccm.cde.service.EgovCcmCmmnDetailCodeManageService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

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
public class EgovCcmCmmnDetailCodeManageController {

	@Resource(name = "CmmnDetailCodeManageService")
    private EgovCcmCmmnDetailCodeManageService cmmnDetailCodeManageService;

	@Resource(name = "CmmnClCodeManageService")
    private EgovCcmCmmnClCodeManageService cmmnClCodeManageService;

	@Resource(name = "EgovCcmCmmnCodeManageService")
    private EgovCcmCmmnCodeManageService cmmnCodeManageService;
	
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
    @RequestMapping(value="/sym/ccm/cde/EgovCcmCmmnDetailCodeRemove.do")
	public ModelAndView deleteCmmnDetailCode (	@ModelAttribute("cmmnDetailCode") CmmnDetailCode cmmnDetailCode
			) throws Exception {
    	int result = -9;
		ModelAndView mv = new ModelAndView();	

		try{
			cmmnDetailCodeManageService.deleteCmmnDetailCode(cmmnDetailCode);
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
    @RequestMapping(value="/sym/ccm/cde/EgovCcmCmmnDetailCodeRegist.do")
	public ModelAndView insertCmmnDetailCode	(@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("cmmnDetailCode") CmmnDetailCode cmmnDetailCode
			) throws Exception {

    	int result = -9;
		ModelAndView mv = new ModelAndView();		    	
		// ------------------------
    	// TOTO  validation check
			//String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");
    		//if (sCmd.equals("Regist")) {}
		// ------------------------		
		
		CmmnDetailCode vo = cmmnDetailCodeManageService.selectCmmnDetailCodeDetail(cmmnDetailCode);
    	if(vo != null){
    		 result = -1;
    	}else{
	    	cmmnDetailCode.setFrstRegisterId(loginVO.getUniqId());
	    	cmmnDetailCodeManageService.insertCmmnDetailCode(cmmnDetailCode);	
	    	result = 0;
    	}
    	
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		//mv.addAllObjects(resultMap);   // object 를 풀어서 개별 등록  data.result
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
	@IncludedInfo(name="공통상세코드", listUrl="/sym/ccm/cde/EgovCcmCmmnDetailCodeList.do", order = 970 ,gid = 60)
    @RequestMapping(value="/sym/ccm/cde/EgovCcmCmmnDetailCodeList.do")
	public String selectCmmnDetailCodeList (@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("searchVO") CmmnDetailCodeVO searchVO
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
		
        List detailCodeList = cmmnDetailCodeManageService.selectCmmnDetailCodeList(searchVO);
		JSONArray  jsonArr = JSONArray.fromObject(detailCodeList);
		model.addAttribute("resultList", jsonArr);
        
        int totCnt = cmmnDetailCodeManageService.selectCmmnDetailCodeListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);
        /* =====================================================  */
        //  등록/수정시 코드 조회
		CmmnClCodeVO searchClCodeVO;
		searchClCodeVO = new CmmnClCodeVO();
		searchClCodeVO.setRecordCountPerPage(999999);
		searchClCodeVO.setFirstIndex(0);
		searchClCodeVO.setSearchCondition("CodeList");		
        List cmmnClCodeList = (List)cmmnClCodeManageService.selectCmmnClCodeList(searchClCodeVO);
		jsonArr = JSONArray.fromObject(cmmnClCodeList);
		model.addAttribute("cmmnClCodeList", jsonArr);
		
        CmmnCodeVO searchCodeVO;
        searchCodeVO = new CmmnCodeVO();
        searchCodeVO.setRecordCountPerPage(999999);
        searchCodeVO.setFirstIndex(0);
        searchCodeVO.setSearchCondition("clCode");
        searchCodeVO.setSearchKeyword(null);
		
        // 전체를 가져와서 jsp 에서 가공하여 사용한다.  compare id =  CL_CODE
        List cmmnCodeList = cmmnCodeManageService.selectCmmnCodeList(searchCodeVO);
		jsonArr = JSONArray.fromObject(cmmnCodeList);
		model.addAttribute("cmmnCodeList", jsonArr);
        /* =====================================================  */
        
        return "egovframework/com/sym/ccm/cde/EgovCcmCmmnDetailCodeList";
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
    @RequestMapping(value="/sym/ccm/cde/EgovCcmCmmnDetailCodeModify.do")
	public ModelAndView pdateCmmnDetailCode (@ModelAttribute("loginVO") LoginVO loginVO
			, @ModelAttribute("cmmnDetailCode") CmmnDetailCode cmmnDetailCode
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
			cmmnDetailCode.setLastUpdusrId(loginVO.getUniqId());
	    	cmmnDetailCodeManageService.updateCmmnDetailCode(cmmnDetailCode);
	    	result = 0;
		}catch(Exception e){
    		result = -9;
    	}

		mv.setViewName("jsonView");
		mv.addObject("result", result);
		return mv;		
    }

}