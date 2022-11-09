package neos.cmm.systemx.author.web;

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
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.SessionVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.kendo.KItemBase;
import neos.cmm.kendo.KTree;
import neos.cmm.kendo.KTreeItem;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.author.service.AuthorManageService;
import neos.cmm.systemx.author.vo.SearchVo;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 
 * @title 권한 관리 Coltroller
 * @version 
 * @dscription 
 * 
 */
@Controller
@SessionAttributes(types=SessionVO.class)
public class AuthorManageController {

	private static final Log LOG = LogFactory.getLog(AuthorManageController.class);
	
    @Resource(name = "AuthorManageService")
    private AuthorManageService authorManageService;
    
    @Resource(name = "CompManageService")
	private CompManageService compService;
    
    @Resource(name="MenuManageService")
	private MenuManageService menuManageService;
    
	@Resource(name = "CommonOptionManageService")
	CommonOptionManageService commonOptionManageService;    
    
    /**
     * 권한코드관리 화면
     * @param params
     * @return
     * @throws Exception
     */
	@IncludedInfo(name="권한코드관리 화면",order = 110002 ,gid = 40)
	@RequestMapping("/cmm/system/authorManageView.do")
	public ModelAndView authorManageView(@RequestParam Map<String,Object> params) throws Exception{		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		String compSeq = params.get("compSeq") + "";
//		
		if(!loginVO.getUserSe().equals("MASTER")){
			if (EgovStringUtil.isEmpty(compSeq)) {
				compSeq = loginVO.getCompSeq();	
			}	
		}

		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", userSe);
		compList = compService.getCompListAuth(params);
		
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		
		params.put("compSeq", compSeq);
		mv.addObject("loginVO", loginVO);
		
		mv.setViewName("/neos/cmm/System/author/AuthorManageView");
		
		return mv;
	}

	/**
	 * 권한코드 리스트 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/authorCodeList.do")
	public ModelAndView authorCodeList(@RequestParam Map<String, Object> paramMap) throws Exception{
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();		

		paramMap.put("group_seq", user.getGroupSeq());
		paramMap.put("langCode", user.getLangCode());
		paramMap.put("userSe", user.getUserSe());
		paramMap.put("compSeq", user.getCompSeq());
		
		String compSeq = paramMap.get("comp_seq")+"";
		/** 현재 회사 선택 */
		if (EgovStringUtil.isEmpty(compSeq)) {
			if(user.getUserSe().equals("MASTER")){
//				paramMap.put("comp_seq", "0");	
			}else{
				paramMap.put("comp_seq", user.getCompSeq());	
			}
		}
		
		if (isAuthenticated) {	
		
			Map<String,Object> resultMap = null;			
			try {							
				resultMap = authorManageService.selectAuthorList(paramMap);		
			} catch (Exception e) {
				resultMap = new HashMap<String,Object>();
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				LOG.error(e);
			}
			mv.setViewName("jsonView");
			mv.addAllObjects(resultMap);	// data.result			
			
		}
				

		return mv;
	}	
	
	/**
	 * 권한 등록/수정 팝업
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/AuthorCodeInfoPop.do")
    public ModelAndView AuthorCodeInfoPop(@RequestParam Map<String,Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		List<Map<String,Object>> compList = null;
		Map<String,Object> params = new HashMap<String,Object> ();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", loginVO.getUserSe());
		
		compList = compService.getCompListAuth(params);
		
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		
		mv.addObject("loginVO", loginVO);
		
		Map<String, Object> map = new HashMap<String, Object>();
		paramMap.put("langCode", loginVO.getLangCode());
		
		String authorCode = paramMap.get("authorCode") + "" ;
		if (!EgovStringUtil.isEmpty(authorCode)) {
			Map<String, Object> resultAuthor = authorManageService.selectAuthorInfo(paramMap);
			map.put("result", resultAuthor);
		}
		
		map.put("param", paramMap);
		mv.setViewName("/neos/cmm/System/author/detail/AuthorCodeInfo");
				
		mv.addAllObjects(map);
		return mv;	
	}
	
	/**
	 * 권한 코드 상세 정보 보기
	 * @param paramMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/getAuthCode.do")
	public ModelAndView selectAuthorInfo(@RequestParam Map<String, Object> paramMap, ModelMap model) throws Exception {				
		
		ModelAndView mv = new ModelAndView();			
		Map<String, Object> map = new HashMap<String, Object>();	
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("lang_code", user.getLangCode());
		Map<String, Object> resultAuthor = authorManageService.selectAuthorInfo(paramMap);
		
		map.put("result", resultAuthor);
				
		mv.setViewName("jsonView");			
		mv.addAllObjects(map);
				
		return mv;
	}
	
	
	 /**
     * 권한 정보를 삭제한다.
     * 
     * @param AuthorManage authorManage
     * @param ModelAndView mv  
     * @return
     * @throws Exception
     */
	@RequestMapping("/cmm/system/delAuthCode.do")
	public ModelAndView deleteAuthorInfo(@RequestParam Map<String, Object> paramMap, ModelAndView mv) throws Exception{
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		Map<String, Object> resultmap = new HashMap<String, Object>();
		String result = "";				    	    	
	
		if(isAuthenticated) {
			try{
				result = authorManageService.deleteAuthCode(paramMap);	
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				LOG.error(e);
			}
		}
		
		resultmap.put("result", result);
		mv.setViewName("jsonView");		
				
		mv.addAllObjects(resultmap);
		return mv;	
	}		
	

	/**
	 * 권한 코드 등록
	 * @param authorManage
	 * @param req
	 * @param mv
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/setAuthCode.do")
	public ModelAndView setAuthCode(@RequestParam Map<String, Object> paramMap, HttpServletRequest req, ModelAndView mv) throws Exception{
		
    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		Map<String, Object> resultmap = new HashMap<String, Object>();
		String result = "";				    	    	
		
		paramMap.put("langCode" , user.getLangCode());
		paramMap.put("emp_seq" , user.getUniqId());
		paramMap.put("group_seq" , user.getGroupSeq());
		
		if(isAuthenticated) {
		
			try{
				String submitType = req.getParameter("submitType");
				
				/** 현재 회사 선택 */
				if (EgovStringUtil.isEmpty((String) paramMap.get("comp_seq"))) {
					if(!user.getUserSe().equals("MASTER")){
						paramMap.put("comp_seq" , user.getCompSeq());	
					}else{
						paramMap.put("comp_seq" , "0");
					}
				}
				
				if(submitType.equals("insert")){
					result = authorManageService.insertAuthCode(paramMap);
				}else if(submitType.equals("update")){
					result = authorManageService.updateAuthCode(paramMap);
				}
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				//System.out.println(e);
				LOG.error(e);
			}			
		}
		
		resultmap.put("result", result);			
		
		mv.setViewName("jsonView");		
				
		mv.addAllObjects(resultmap);
				
		return mv;	
    }
	
	/**
	 * 권한부여관리
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name="권한부여관리 화면",order = 110003 ,gid = 50)
	@RequestMapping("/cmm/system/authorAssignManageView.do")
	public ModelAndView authorAssignManageView(@RequestParam Map<String,Object> params) throws Exception{		
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		
		String compSeq = params.get("compSeq") + "";
//		
		if(!loginVO.getUserSe().equals("MASTER")){
			if (EgovStringUtil.isEmpty(compSeq)) {
				compSeq = loginVO.getCompSeq();	
			}	
		}

		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", userSe);
		compList = compService.getCompListAuth(params);
		
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		
		params.put("compSeq", compSeq);
		mv.addObject("loginVO", loginVO);
		
		mv.setViewName("/neos/cmm/System/author/AuthorAssignManageView");
		
		return mv;
	}	
		
	/**
     * 권한부여관리(사용자 권한 부여)
     * 
     * @param RolesManage rolesManage
     * @param ModelAndView mv  
     * @return
     * @throws Exception
     */	
	@RequestMapping("/cmm/system/authorAssignUserView.do")
	public ModelAndView authorAssignUserView(@ModelAttribute("SearchVo")SearchVo searchVo, ModelMap model) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(isAuthenticated) {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

			String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1900");
			String displayPositionDuty = "";
			
			if(positionDutyOptionValue == null || positionDutyOptionValue.equals("")) {
				displayPositionDuty = "position";
			} else if(positionDutyOptionValue.equals("0")){
				displayPositionDuty = "position";
			} else if(positionDutyOptionValue.equals("1")) {
				displayPositionDuty = "duty";
			}	
			
	        mv.addObject("displayPositionDuty", displayPositionDuty);
			mv.setViewName("/neos/cmm/System/author/detail/AuthorAssignUserView");
			
		}else {
        	if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99"){
        		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon"));
        	}else{
        		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");	
        	}        	
		}
		
		return mv;		
	}	
	
	
	
	/**
     * 권한부여관리(부서 권한 부여)
     * 
     * @param RolesManage rolesManage
     * @param ModelAndView mv  
     * @return
     * @throws Exception
     */	
	@RequestMapping("/cmm/system/authorAssignDeptView.do")
	public ModelAndView authorAssignDeptView(@ModelAttribute("SearchVo")SearchVo searchVo, ModelMap model) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        
        if(!isAuthenticated) {
        	if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99"){
        		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon"));
        	}else{
        		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");	
        	}        	
            return mv;
        }		
		
		mv.setViewName("/neos/cmm/System/author/detail/AuthorAssignDeptView");
		
		return mv;		
	}	

	/**
	 * 권한부여 리스트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/getAuthorRelateList.do")
	public ModelAndView getAuthorRelateList(@RequestParam Map<String, Object> paramMap) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();		
			
		paramMap.put("langCode", loginVO.getLangCode());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			paramMap.put("compSeq", loginVO.getCompSeq());	
		}
		
		if (isAuthenticated) {	
					
			Map<String,Object> resultMap = null;			
			try {							
				resultMap = authorManageService.selectAuthorRelateList(paramMap);		
			} catch (Exception e) {
				resultMap = new HashMap<String,Object>();
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				LOG.error(e);
			}

			mv.setViewName("jsonView");
			mv.addAllObjects(resultMap);	// data.result			
			
		}

		return mv;
	}	
	
	/**
	 * 권한 부여 리스트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/getAuthorRelateGroup.do")
	public ModelAndView getAuthorRelateGroup(@RequestParam Map<String, Object> paramMap) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();		
			
		paramMap.put("langCode", loginVO.getLangCode());
		
		if (isAuthenticated) {	
					
			String resultMap = null;			
			try {							
				resultMap = authorManageService.getAuthorRelateGroup(paramMap);		
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				LOG.error(e);
			}

			mv.addObject("result", resultMap);
			mv.setViewName("jsonView");
		}

		return mv;
	}	

	/**
     * 권한부여관리(직급/직책 권한 부여)
     * 
     * @param RolesManage rolesManage
     * @param ModelAndView mv  
     * @return
     * @throws Exception
     */	
	@RequestMapping("/cmm/system/authorAssignClassView.do")
	public String authorAssignClassView(@RequestParam Map<String, Object> paramMap) throws Exception{	
    	
      	return "/neos/cmm/System/author/detail/AuthorAssignClassView";		
	}	

	/**
	 * 권한부여 직책/직급 리스트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/authorAssignClassList.do")
	public ModelAndView authorAssignClassList(@RequestParam Map<String, Object> paramMap) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();		

   		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			paramMap.put("compSeq", loginVO.getCompSeq());	
		}
		
		Map<String,Object> resultMap = null;		
		if (isAuthenticated) {
			try {							
				resultMap = authorManageService.selectAuthorClassList(paramMap);
			} catch (Exception e) {
				resultMap = (Map<String, Object>) new HashMap<String,Object>();
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				LOG.error(e);
			}

			mv.setViewName("jsonView");
			mv.addAllObjects(resultMap);	// data.result			
			
		}

		return mv;
	}	
	
	/** 
	 * 권한 부여 등록 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/insertAuthorRelate.do")
	public ModelAndView insertAuthorRelate(@RequestParam Map<String, Object> paramMap) throws Exception{
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> resultmap = new HashMap<String, Object>();
		String result = "";
		try{
			if (isAuthenticated) {
				result = authorManageService.insertAuthorRelate(paramMap);	 
			}
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		resultmap.put("result", result);
		
		mv.setViewName("jsonView");		
		mv.addAllObjects(resultmap);
				
		return mv;		
	}	

	/**
	 * 권한부여관리(직책/직급 권한 부여, 등록/수정/삭제)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/insertClassAuth.do")
	public ModelAndView insertClassAuth(@RequestParam Map<String, Object> paramMap) throws Exception{
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> resultmap = new HashMap<String, Object>();				
		Map<String, Object> tempMap = new HashMap<String, Object>();
		String result = "";

		if (isAuthenticated) {		
		
			String[] authClass= ((String) paramMap.get("authClass")).split(",");	
			String authorCode= (String)paramMap.get("authorCode") ;
			String authorTypeCode= (String)paramMap.get("authorTypeCode") ;
			
			if( authorTypeCode.equals("003")) {
				authorTypeCode = "1"; // 직책
			}
			else { 
				authorTypeCode = "2"; // 직급
			}
			
			if( authClass.length > 0 ){
	
				// 기존 저장된 부서권한 삭제 후 신규 insert
				paramMap.put("authorTypeCode", authorTypeCode);
				result = authorManageService.deleteAuthorClass(paramMap);
	
			    for(int i = 0 ; i < authClass.length ; i++){
			        if(authClass[i].trim().equals("")){
			            continue;
			        }
			        tempMap.clear();
			        tempMap.put("authClass", authClass[i]);
			        tempMap.put("authorCode", authorCode);
			        tempMap.put("authorTypeCode", authorTypeCode);
			        
					result = authorManageService.insertAuthorClass(tempMap);
			    }		

			}

		}
		
		resultmap.put("result", result);
		
		mv.setViewName("jsonView");		
		mv.addAllObjects(resultmap);
				
		return mv;		
	}		
	
	/**
	 * 권한 부여 삭제 
	 * @param mv
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/deleteAuthorRelate.do")
	public ModelAndView deleteAuthorRelate(ModelAndView mv, @RequestParam Map<String, Object> paramMap) throws Exception{

		Map<String, Object> resultmap = new HashMap<String, Object>();
		String result = "";		
		try {
			 result = authorManageService.deleteAuthorRelate(paramMap);
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}		
		
		resultmap.put("result", result);
		
		mv.setViewName("jsonView");		
				
		mv.addAllObjects(resultmap);
				
		return mv;	
	}	

	/**
	 * 메뉴권한 등록 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/saveAuthMenu.do")
	public ModelAndView saveAuthMenu(@RequestParam Map<String, Object> paramMap) throws Exception{
		
		
        ModelAndView mv = new ModelAndView();
		
		Map<String, Object> resultmap = new HashMap<String, Object>();
		String result = "";

		try{
			result = authorManageService.insertAuthorMenu(paramMap);
			result = "insert";
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}				
			
		resultmap.put("result", result);
		mv.setViewName("jsonView");
		mv.addAllObjects(resultmap);
		
		return mv;	
		
	}	
	
	/**
	 * 권한-메뉴 트리 뷰
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/authorMenuTreeView.do")
	public ModelAndView authorMenuTreeView(@RequestParam Map<String,Object> params, ModelMap model) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();

		params.put("langCode", loginVO.getLangCode());
		
		String compSeq = params.get("compSeq")+"";
		String groupSeq = params.get("groupSeq")+"";
		
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		String menuGubun = (String) params.get("menuGubun");

		params.put("isAdmin","Y");
		List<Map<String,Object>> list = authorManageService.selectMenuTreeList(params);
		
		List<KItemBase> treeList = new ArrayList<KItemBase>();
		
		if (list != null && list.size() > 0) {
			Map<String,Object> root = list.get(0);
			
			KTree tree = new KTree();

			KTreeItem rootitem = null;
			if (EgovStringUtil.isEmpty(menuGubun)) {
				rootitem = new KTreeItem(root.get("upperMenuNo")+"", root.get("upperMenuNo")+"", BizboxAMessage.getMessage("TX000000862","전체"), "", true, "rootfolder");
			}else{
				rootitem = new KTreeItem(root.get("menuNo")+"", root.get("upperMenuNo")+"", root.get("name")+"", "", true, "rootfolder");
				if (!EgovStringUtil.isEmpty(root.get("authMenuNo")+"")) {
					rootitem.setChecked(true);
				}
			}
			tree.setRoot(rootitem);
			
			String url = null;
			String name = null;
			
			String authMenuNo = null; 
			boolean checked = false; 
			boolean expanded = true;
			for(Map<String,Object> map : list) {
				url = map.get("urlPath")+"";
				name = map.get("name")+"";
				authMenuNo = map.get("authMenuNo")+"";
				
				if (!EgovStringUtil.isEmpty(authMenuNo)) {
					checked = true;
				} else {
					checked = false;
				}
				
				KTreeItem item = new KTreeItem(map.get("menuNo")+"",map.get("upperMenuNo")+"", name,url,expanded, map.get("spriteCssClass")+"");
				item.setChecked(checked);
				
				treeList.add(item);
			}
			
			tree.addAll(treeList);

			JSONObject json = JSONObject.fromObject(tree.getRoot());
			mv.addObject("treeList", json);
			
		} 
		
		mv.setViewName("/neos/cmm/System/author/detail/AuthorMenuTreeView");
		return mv;		
	}	

	/**
	 * 마스터 권한설정 화면 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/authorMasterManageView.do")
	public ModelAndView masterAuthorManageView(@RequestParam Map<String,Object> params) throws Exception{		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe( );
		List<Map<String, Object>> compList = null;
		if ( userSe != null && userSe.equals( "MASTER" ) ) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
			params.put( "langCode", loginVO.getLangCode( ) );
			params.put( "userSe", userSe );
			compList = compService.getCompListAuth( params );
		}
		mv.addObject( "compList", compList );		
		
		mv.setViewName("/neos/cmm/System/author/AuthorMasterManageView");
		
		return mv;
	}
	
	/**
	 * 마스터 권한자 리스트
	 * @param params
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/getAuthorMasterList.do")
	public ModelAndView getMasterAuthorList(@RequestParam Map<String,Object> params) throws Exception{		
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("langCode", loginVO.getLangCode());
		
		Map<String,Object> resultMap = null;			
		try {							
			resultMap = authorManageService.getAuthorMasterList(params);		
		} catch (Exception e) {
			resultMap = new HashMap<String,Object>();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			LOG.error(e);
		}
		mv.setViewName("jsonView");
		mv.addAllObjects(resultMap);	// data.result	
		return mv;
	}
	
	/**
	 * 마스터권한 수정 (삭제/등록) 
	 * @param mv
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/updateAuthorMaster.do")
	public ModelAndView deleteAuthorMaster(ModelAndView mv, @RequestParam Map<String, Object> paramMap) throws Exception{

		Map<String, Object> resultmap = new HashMap<String, Object>();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("createSeq", loginVO.getUniqId());
		int result = 0;		
		try {
			result = authorManageService.updateAuthorMaster(paramMap);
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}		
		
		resultmap.put("result", result);
		mv.setViewName("jsonView");		
		mv.addAllObjects(resultmap);
				
		return mv;	
	}	
}
