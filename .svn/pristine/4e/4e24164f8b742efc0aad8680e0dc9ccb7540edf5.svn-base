package neos.cmm.systemx.commonOption.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import main.web.BizboxAMessage;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.commonOption.vo.CommonOptionManageVO;
import neos.cmm.systemx.etc.service.LogoManageService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CloudCommonCodeUtil;
import neos.cmm.util.code.service.impl.CommonCodeDAO;
import net.sf.json.JSONArray;

/**
 *<pre>
 * 1. Package Name	: neos.cmm.system.commonOption.web
 * 2. Class Name	: CommonOptionManagerController.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2013. 7. 12.     doban7       최초작성
 *  -----------------------------------------------------
 *</pre>
 */
@Controller
public class CommonOptionManagerController {

    private static final Log LOG = LogFactory.getLog(CommonOptionManagerController.class);
    
    @Resource(name="LogoManageService")
    private LogoManageService logoManageService;
    
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
    @Resource(name="CommonOptionManageService")
    CommonOptionManageService commonOptionManageService;
    
    @Resource(name = "EgovFileMngService")
    private EgovFileMngService fileService;
    
    @Resource(name="MenuManageService")
	private MenuManageService menuManageService;
    
    @Resource(name="loginService")
	EgovLoginService loginService;
    
    @Resource(name="CommonCodeDAO")
    CommonCodeDAO commonCodeDAO;
    
    @IncludedInfo(name="공통옵션관리", order = 200 ,gid = 60)
    @RequestMapping("/cmm/system/CommonOptionManageView.do")
    public ModelAndView CommonOptionManage( @ModelAttribute("CommonOptionManageVO") CommonOptionManageVO optionManage, ModelMap model ) throws Exception{
        
        ModelAndView mv = new ModelAndView();
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
                            
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        
        if(!isAuthenticated) {
        	if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99"){
        		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon"));
        	}else{
        		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");	
        	}
            return mv;
        }
        
		
		if (isAuthenticated) {	        
        
			CommonOptionManageVO resultMap = new CommonOptionManageVO();			
			try {							
				resultMap = commonOptionManageService.selectCommonOption();	
			} catch (Exception e) {
//				resultMap = new HashMap<String,Object>();
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				LOG.error(e);
			}
			
			mv.addObject("optionList", resultMap);						
			mv.setViewName("/neos/cmm/System/commonOption/CommonOptionManagerViewNew");				
		}
        
        return mv;

    }

    @RequestMapping("/cmm/system/InsertCommonOption.do")
    public ModelAndView InsertCommonOption(@ModelAttribute("CommonOptionManageVO") CommonOptionManageVO optionManage, HttpServletRequest req, ModelAndView mv) throws Exception{
        
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
                            
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        
        if(!isAuthenticated) {
        	
        	if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99"){
        		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon"));
        	}else{
        		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");	
        	}
            
            return mv;
        } 

		Map<String, Object> resultmap = new HashMap<String, Object>();
		String result = "";				    	    	
		
		if(isAuthenticated) {
			
			String submitType = optionManage.getSubmitType();
			
			if(submitType.equals("insert")){
				result = commonOptionManageService.insertCommonOption(optionManage);
			}else if(submitType.equals("update")){
				result = commonOptionManageService.updateCommonOption(optionManage);
			}
			
		}
		
		resultmap.put("result", result);	        
        
		mv.setViewName("jsonView");		
				
		mv.addAllObjects(resultmap);
				
		return mv;	

    }    
    
    // 공통옵션 뷰 불러오기
    @RequestMapping("/cmm/system/CommonOptionManageViewNew.do")
    public ModelAndView CommonOptionManageNew(@RequestParam Map<String,Object> params) throws Exception{
        
        ModelAndView mv = new ModelAndView();

        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
        
        List<Map<String, Object>> compList = null;		// 회사 목록 
        params.put("groupSeq", loginVO.getGroupSeq());
        params.put("langCode", loginVO.getLangCode());
        params.put("compSeq", loginVO.getOrganId());
        params.put("empSeq", loginVO.getUniqId());
        params.put("userSe", loginVO.getUserSe());
        params.put("gubun", "1");
        
        // 회사 목록 (select box 값)
        compList = commonOptionManageService.getCompList(params);
        
        JSONArray compListJson = JSONArray.fromObject(compList);
        
        mv.addObject("compListJson", compListJson);
        mv.addObject("loginVO", loginVO);
        mv.setViewName("/neos/cmm/System/commonOption/CommonOptionManagerViewNew");		
        return mv;

    }
    
    // 공통옵션 값 가져오기
    @RequestMapping("/cmm/system/CommonOptionList.do")
    public ModelAndView CommonOptionList(@RequestParam Map<String,Object> params) throws Exception{
        
        ModelAndView mv = new ModelAndView();

        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        List<Map<String, Object>> optionList = null;	// 공통옵션 값
        String erpSyncResult = "Y";						// erp 조직도 연동 옵션값을 위한 변수
        
        params.put("groupSeq", loginVO.getGroupSeq());
        params.put("langCode", loginVO.getLangCode());
        params.put("sLangCode", loginVO.getLangCode());
        params.put("empSeq", loginVO.getGroupSeq());
        params.put("userSe", loginVO.getGroupSeq()); 
        params.put("gubun", params.get("gubun"));		// 그룹/회사 구분    1: 그룹, 2: 회사
        params.put("compSeq", params.get("compSeq"));	// 회사선택 값
        
        //구분(WEB,공통) 두가지가 같은 키값(cm)사용으로 인한 조회쿼리 분기처리.
        if(params.get("typeText") != null && params.get("typeText").toString().equals(BizboxAMessage.getMessage("TX000006671","공통"))){
        	params.put("cmFlag","Y");
        }
        
        // 공통옵션 값 가져오기
        optionList = commonOptionManageService.getOptionList(params);
        
        // ERP 조직도 연동 셋팅 값 확인 (1회사 1 ERP 정책)
        if((params.get("optionId") == null || params.get("optionId").equals("")) && params.get("gubun").equals("2")) {
        	List<Map<String, Object>> erpSyncCompList = new ArrayList<Map<String, Object>>();
        	Map<String, Object> selectErpSyncComp = new HashMap<String, Object>();
        	
        	params.put("achrGbn", "hr");
        	
        	// 전체 erp 연동 회사 
        	erpSyncCompList = commonOptionManageService.getErpSyncCompList(params);
        	
        	// 선택 회사 erp 연동정보
        	selectErpSyncComp = commonOptionManageService.getNewErpSyncComp(params);
        	
        	/* 
        	 * erpSyncResult (erp 조직도 연동 셋팅 결과값)
        	 * C: erp 연동정보 필요 
        	 * Y: erp 연동 가능
        	 * N: erp 연동 불가(erp연동정보 중복)  
        	 *  */

        	if(selectErpSyncComp == null) {
        		erpSyncResult = "C";
        	} else {
        		for(Map<String, Object> temp : erpSyncCompList) {
            		
            		if(!temp.get("compSeq").equals(selectErpSyncComp.get("compSeq")) 
            				&& temp.get("erpType").equals(selectErpSyncComp.get("erpType")) 
            				&& temp.get("url").equals(selectErpSyncComp.get("url"))
            				&& temp.get("erpCompSeq").equals(selectErpSyncComp.get("erpCompSeq"))
            				&& temp.get("useYn").equals("Y")
            				&& temp.get("orgSyncStatus").equals("C")) {
            			erpSyncResult = "N";
            			String useCompInfo = temp.get("compName").toString() + "(" + temp.get("erpCompSeq").toString() + ")";
            			mv.addObject("useCompInfo", useCompInfo);
            			break;
            		} else {
            			erpSyncResult = "Y";
            		}
            	}
        	}
        	
        }
        
        
        JSONArray optionListJson = JSONArray.fromObject(optionList);
		
        mv.addObject("erpSyncResult", erpSyncResult);
        mv.addObject("optionListJson", optionListJson);
        
        mv.setViewName("jsonView");
        return mv;
    }
    
    // 공통옵션 설정 값 가져오기
    @RequestMapping("/cmm/system/CommonOptionSettingValue.do")
    public ModelAndView CommonOptionSettingValue(@RequestParam Map<String,Object> params) throws Exception{
        
        ModelAndView mv = new ModelAndView();

        //System.out.println("param : " + params);
        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        //params.put("compSeq", params.get("compSeq"));
        
        List<Map<String, Object>> optionValue = null;
        
        params.put("langCode", loginVO.getLangCode());
        
        optionValue = commonOptionManageService.getOptionSettingValue(params);
        
        
        JSONArray optionValueJson = JSONArray.fromObject(optionValue);
        
        mv.addObject("optionValue", optionValue);
        mv.addObject("optionValueJson", optionValueJson);		
        
        
        mv.setViewName("jsonView");
        return mv;
    }
    
	// 공통옵션 설정 값 저장하기
    @RequestMapping("/cmm/system/CommonOptionSave.do")
    public ModelAndView CommonOptionSave(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception{
        
        ModelAndView mv = new ModelAndView();
        
        String optionId = params.get("optionId") + "";
        boolean isCmRebuild = false; 
        
        if(optionId.equals("com100") || optionId.equals("com101") || optionId.equals("com200") || optionId.equals("com201") || optionId.equals("210") || optionId.equals("com300") || optionId.equals("com301") || optionId.equals("com500") || optionId.equals("com501") || optionId.equals("com600") || optionId.equals("com220") || optionId.equals("com700") || optionId.equals("com701")){
        	isCmRebuild = true;
        	params.put("cmFlag", "Y");
        }
        
        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        params.put("groupSeq", loginVO.getGroupSeq());
        params.put("langCode", loginVO.getLangCode());
        params.put("userSe", loginVO.getGroupSeq());
        params.put("empSeq", loginVO.getUniqId());
        
        commonOptionManageService.setOptionSave(params);

        //패스워드 만료기한 변경일 경우 사용자 패스워드 변경일자 초기화
        /*
        if(params.get("optionId").equals("cm201")){
        	commonOptionManageService.resetEmpPwdDate(params);
        }
        */
        
        // 직급/직책 옵션 변경 시 order_text 값 변경
        if(params.get("optionId").equals("cm1900")) {
        	commonOptionManageService.changeOrderDutyPosition(params);
        }
        
        if(params.get("optionId").equals("cm200") && params.get("optionValue").equals("0")) {
        	params.put("passwdStatusCode", "P");
        	commonOptionManageService.changePasswdStausCode(params);
        } else if(params.get("optionId").equals("cm200") && params.get("optionValue").equals("1")) {
        	params.put("passwdStatusCode", "C");
        	commonOptionManageService.changePasswdStausCode(params);
        }
        
        // 패스워드 설정 변경 시 
        if(params.get("optionId").equals("cm202") || params.get("optionId").equals("cm203") || params.get("optionId").equals("cm204")) {
        	params.put("passwdStatusCode", "C");
        	commonOptionManageService.changePasswdStausCode(params);
        }
        
        // 쪽지/대화방 저장
        if(params.get("optionId").equals("appPathSeq810")) {
        	params.put("optionId", "appPathSeq800");
        	commonOptionManageService.setOptionSave(params);
        }
        
        // 조직도 사업장 표시 일경우 기존 사업장 일괄 조직도 표시/미표시 처리 
        if(params.get("optionId").equals("cm800")) {
        	String displayYn = params.get("optionValue").toString().equals("1") ? "Y" : "N";
        	params.put("displayYn", displayYn);
        	
        	commonOptionManageService.changeBizDisplayYn(params);
        }
        
       	//공통옵션 리빌드
        try {
        	CloudCommonCodeUtil.cmmOptionInit(commonCodeDAO, loginVO.getGroupSeq());
        }catch(Exception e) {
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
        }
        
        //세션 공통옵션 리셋팅
        Map<String, Object> mp = new HashMap<String, Object>();
    	mp.put("groupSeq", loginVO.getGroupSeq());
    	mp.put("compSeq", loginVO.getOrganId());
        
        mv.setViewName("jsonView");
        return mv;
    }
    
    @RequestMapping("/cmm/system/getErpOptionValue.do")
    public ModelAndView getErpOptionValue(@RequestParam Map<String,Object> params) throws Exception{
        
        ModelAndView mv = new ModelAndView();

        Map<String, Object> map = commonOptionManageService.getErpOptionValue(params);
        
        mv.addObject("option", map);		
        
        mv.setViewName("jsonView");
        return mv;
    }
}
 

