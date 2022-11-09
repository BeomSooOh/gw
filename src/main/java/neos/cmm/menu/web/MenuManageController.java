package neos.cmm.menu.web;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import neos.cmm.util.AESCipher;
import api.common.dao.APIDAO;
import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.kendo.KItemBase;
import neos.cmm.kendo.KTree;
import neos.cmm.kendo.KTreeItem;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.jstree.NeosTreeUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
/**
 * 
 * @title  메뉴관리
 * @version 
 * @dscription 
 *
 */
@Controller
public class MenuManageController {

	@Resource(name = "treeUtil")
    private NeosTreeUtil treeUtil;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService; 

	 @Resource(name = "commonSql")
	 private CommonSqlDAO commonSql;	
	 
	 @Resource(name = "APIDAO")
	 private APIDAO apiDAO;
	 
	 @Resource(name="CommonOptionManageService")
	 CommonOptionManageService commonOptionManageService;
	 
	 @Resource(name="OrgChartService")
	 OrgChartService orgChartService;
	 
	 @Resource(name = "CompManageService")
	 private CompManageService compService;
	 
	@RequestMapping("/cmm/ssoPostView.do")
	public ModelAndView ssoPostView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		
		Map<String, Object> ssoPostParam = new HashMap<String, Object>();
		
		String ssoPostParamInfo = AESCipher.AES_Decode(params.get("ssoPostParam").toString());
		
		Long reqTime =  Long.parseLong(ssoPostParamInfo.substring(0, 12));
		
		Long nowTime =  Long.parseLong(new SimpleDateFormat("yyyyMMddHHmm").format(new Date())) - 5;
		
		if(nowTime < reqTime){
			
			mv.setViewName("/neos/ssoPostLink");
			
			ssoPostParamInfo = ssoPostParamInfo.substring(12);
			
			for (String value : ssoPostParamInfo.split("▦",-1)) {
				
				String[] valueInfo = value.split("\\|");
				
				if(valueInfo.length > 1){
					ssoPostParam.put(valueInfo[0], valueInfo[1]);
				}
			}
			
			mv.addObject("ssoPostParam", ssoPostParam);
			mv.addObject("loginVO", loginVO);			
		}
		
		return mv; 
	} 

	

	 /**
     * 메뉴 관리 화면으로 이동
     * 
     * @param organVO 
     * @return
     * @throws Exception
     */
	@IncludedInfo(name="메뉴관리 화면",order = 77780 ,gid = 40)
	@RequestMapping("/cmm/system/menuManageView.do")
	public ModelAndView menuManageView(@RequestParam Map<String,Object> params) throws Exception{
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject("LoginVO", user);
		mv.addObject("buildType", CloudConnetInfo.getBuildType());
		
		mv.setViewName("/neos/cmm/System/menu/MenuManageView");
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/system/getAllTopMenuList.do")
	public ModelAndView getAllTopMenuList(@RequestParam Map<String,Object> paramMap) throws Exception{
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		ModelAndView mv = new ModelAndView();
		
		List<Map<String,Object>> list = new ArrayList<>();
		
		if (isAuthenticated) {	
			try{
				paramMap.put("langCode", user.getLangCode());
				
				list = commonSql.list("MenuManageDAO.getAllTopMenuList", paramMap);
				
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}		

		mv.addObject("list", list);
		mv.setViewName("jsonView");		
				
		return mv;		
	}	

	/**
	 * 메뉴정보관리 트리 가져오기
	 * @param paramMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")	
	@RequestMapping("/selectTreeMenu.do")
	public ModelAndView selectTreeMenu(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();	
		
		response.setCharacterEncoding("UTF-8");		
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
					
		paramMap.put("langCode", loginVO.getLangCode());
		
		String type = paramMap.get("type")+"";
		List<Map<String,Object>> list = new ArrayList<>();
		
		if(type.equals("USER")){
			list = commonSql.list("MenuManageDAO.selectTreeMenu", paramMap);			
		}else if(type.equals("ADMIN")){
			list = commonSql.list("MenuManageDAO.selectTreeAdmMenu", paramMap);	
		}

		List<KItemBase> treeList = new ArrayList<KItemBase>();
		
		if (list != null && list.size() > 0) {
			Map<String,Object> root = list.get(0);
			
			KTree tree = new KTree();
			
			
			KTreeItem rootitem = new KTreeItem(root.get("menuNo")+"", root.get("upperMenuNo")+"", root.get("name")+"", "", true, "rootfolder");
			if (!EgovStringUtil.isEmpty(root.get("authMenuNo")+"")) {
				rootitem.setChecked(true);
			}
			tree.setRoot(rootitem);
			
			String url = null;
			String name = null;
			boolean expanded = true;
			
			for(Map<String,Object> map : list) {
				url = map.get("urlPath")+"";
				name = map.get("name")+"";

				KTreeItem item = new KTreeItem(map.get("menuNo")+"",map.get("upperMenuNo")+"", name,url,expanded, map.get("spriteCssClass")+"");
				
				treeList.add(item);
			}
			
		
			tree.addAll(treeList);

			JSONObject json = JSONObject.fromObject(tree.getRoot());
			
		    mv.addObject("menuChartList", json);
		}
		
		mv.setViewName("/neos/cmm/System/menu/include/menuChartList");	
		
		return mv;		
		
	}	

	/**
     * 메뉴의 상세내용을 가져온다.(bizbox A)
     * 
     * @param String startId 
     * @return ModelAndView mv
     * @throws Exception
     */	
	@RequestMapping("/cmm/system/menuInfoView.do")
	public ModelAndView menuInfoView( @RequestParam Map<String,Object> paramMap, HttpServletResponse response ) throws Exception {				
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();
		paramMap.put("loginVO", loginVO);
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("langCode", loginVO.getLangCode());
		Map<String,Object> menuMap  = menuManageService.menuInfoView(paramMap);
		mv.addObject("menuMap", menuMap);
		
		//SSO링크정보 조회
		if(menuMap != null && menuMap.get("ssoUseYn").equals("Y")){
			paramMap.put("linkId", (String)paramMap.get("menuNo"));
		    paramMap.put("linkTp", "gw_menu");
		    paramMap.put("linkSeq", "1");
			@SuppressWarnings("unchecked")
			Map<String,Object> ssoInfo = (Map<String,Object>) commonSql.select("PortalManageDAO.selectSSoInfo", paramMap);			
			mv.addObject("ssoInfo", ssoInfo);			
		}
		
		List<Map<String,Object>> menuComboBoxList = menuManageService.selectMenuComboBoxList(paramMap);
		List<Map<String,Object>> menuOpenCompList = menuManageService.selsetMenuOpenCompList(paramMap);
		
		if(menuComboBoxList.size() > 0) {
			mv.addObject("upperMenuList", menuComboBoxList);			
		}else{
			mv.addObject("upperMenuList", null);	
		}
		
		if(paramMap.get("type").equals("USER") && menuMap != null && menuMap.get("upperMenuNo") != null && menuMap.get("upperMenuNo").equals(0)){		
			List<Map<String,Object>> menuComboBoxSubList = menuManageService.selectMenuComboBoxSubList(paramMap);
			
			if(menuComboBoxSubList.size() > 0) {
				mv.addObject("subMenuList", menuComboBoxSubList);			
			}else{
				mv.addObject("subMenuList", null);	
			}			
		}
		
		String compNameList = "";
		String compSeqList = "";
		int seq = 1;
	    if(menuOpenCompList.size() > 0){
	    	
	    	for(Map<String,Object>map :  menuOpenCompList) {
	    		if(seq == menuOpenCompList.size()) {
		    		compNameList += EgovStringUtil.isNullToString(map.get("compNameList"));
		    		compSeqList += EgovStringUtil.isNullToString(map.get("compSeqList"));
		    	}else{
		    		compNameList += EgovStringUtil.isNullToString(map.get("compNameList"))+",";
		    		compSeqList += EgovStringUtil.isNullToString(map.get("compSeqList"))+",";
		    	}
	    		seq++;
	    	}
	    	mv.addObject("compNameList",compNameList);	
	    	mv.addObject("compSeqList", compSeqList);			
	    }else{
	    	mv.addObject("compNameList", "");	
	    	mv.addObject("compSeqList", "");	
	    }
//		mv.setViewName("/neos/cmm/System/menu/include/MenuInfoView"); 
		mv.setViewName("jsonView");		
		return mv;		
	}	
	
	/**
	 * 하위 메뉴 카운트 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/getChildCnt.do")
	public ModelAndView getChildCnt(@RequestParam Map<String,Object> paramMap) throws Exception {				
			
		ModelAndView mv = new ModelAndView();			
		Map<String, Object> map = new HashMap<String, Object>();		
		
		int resultCnt = menuManageService.getChildCnt(paramMap);
		
		map.put("resultCnt", resultCnt);
				
		mv.setViewName("jsonView");			
		mv.addAllObjects(map);
				
		return mv;
	}
	
	 /**
	  * 메뉴 등록 
	  * @param paramMap
	  * @return
	  * @throws Exception
	  */
	@RequestMapping("/cmm/system/insertMenu.do")
	public ModelAndView insertOrgan(@RequestParam Map<String,Object> paramMap) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("loginVO", loginVO);
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		ModelAndView mv = new ModelAndView();
				
		String result = null;
		try{
			if (isAuthenticated) {
				String menuNo = (String) paramMap.get("menuNo");
				if(menuNo.equals("0")){				
					// 메뉴 추가
					result = menuManageService.insertMenu(paramMap);
				}else{								
					// 메뉴 수정
					result = menuManageService.updateMenu(paramMap);
				}
				
				//SSO설정
				if(paramMap.get("ssoUseYn").equals("Y")){
					paramMap.put("linkId", menuNo);
					paramMap.put("linkTp", "gw_menu");
					paramMap.put("linkSeq", "1");
					commonSql.insert("PortalManageDAO.insertSSoInfo", paramMap);
				}

				mv.addObject("resultMsg", result);
			}
	
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = "fail";
		}
		
		mv.setViewName("jsonView");	
				
		return mv;		
	}
	
    /**
     * 메뉴를 삭제한다.
     * @param paramMap
     * @return
     * @throws Exception
     */
	@RequestMapping("/cmm/system/deleteMenu.do")
	public ModelAndView deleteOrgan(@RequestParam Map<String,Object> paramMap) throws Exception{
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("loginVO", user);
		
		String result = "fail";
		
		if (isAuthenticated) {	
			try{
				result = menuManageService.deleteMenu(paramMap);
//				result = "success";
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}		

		mv.addObject("result", result);
		mv.setViewName("jsonView");		
				
		return mv;		
	}

	/**
	 * bizbox A Top menu에서 url이 없을시 하위 첫번째 메뉴정보 조회
	 * @param req
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/getFirstMenuInfo.do")
    public ModelAndView getFirstMenuInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
        ModelAndView mv = new ModelAndView();           
        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		/** top menu */
		String authCode = loginVO.getAuthorCode();
		
		String[] authArr  = null;
		if (!EgovStringUtil.isEmpty(authCode)) {
			authArr = authCode.split("#");
		}
		
		params.put("authCodeList", authArr);
		
		if (loginVO.getUserSe().equals("MASTER") && loginVO.getCompSeq().equals("")) {
			CommonUtil.getSessionData(request, "compSeq", params);
		} else {
			params.put("compSeq", loginVO.getCompSeq());
		}
			
		params.put("langCode", loginVO.getLangCode());
		params.put("id", loginVO.getId());
		params.put("empSeq", loginVO.getUniqId());
		params.put("deptSeq", loginVO.getOrgnztId());

		String userSe = loginVO.getUserSe();
		
		Map<String, Object> map = new HashMap <String, Object>();
		if (userSe.equals("USER")) {
			map = menuManageService.selectFirstMenuInfo(params);
		} else if (userSe.equals("ADMIN") || userSe.equals("MASTER")) {
			params.put("menuGubun", userSe);
			params.put("menuAuthType", userSe);
			map = menuManageService.selectFirstAdminMenuInfo(params);
		}
		
		mv.addObject("menu", map);

        
        mv.setViewName("jsonView");         
                
        return mv;
    }

	/**
	 * 메뉴 히스토리 가져오는 부분(일단 사용안함)
	 * topGnb.jsp 에서 javascript function으로 있음.
	 * javascript document.domain 설정해도 크로스도메인 우회 가능하므로  getMenuListOfUrl.do 필요하지 않을수 있음.
	 * @param params
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/cmm/system/getMenuListOfUrl.do")
	public void getMenuListOfUrl(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		response.setCharacterEncoding("UTF-8");
		
		String userSe = String.valueOf(params.get("userSe"));
		
		if (EgovStringUtil.isEmpty(userSe)) {
			userSe = "USER";
		}
		
		String urlPath = String.valueOf(params.get("urlPath"));
		
		if (EgovStringUtil.isEmpty(urlPath)) {
			return;
		}
		
		String urlRex = "^((https?):\\/\\/([^:\\/\\s]+)(:([^\\/]*))?)?((\\/[^\\s/\\/]+)*)?\\/([^#\\s\\?]*)(\\?([^#\\s]*))?(#(\\w*))?$";
		urlPath = EgovStringUtil.getStrMatcher(urlPath,urlRex);
		
		if (!EgovStringUtil.isEmpty(urlPath)) {
			String[] pathArr = urlPath.split("\\/");
			if(pathArr != null && pathArr.length>1 && (pathArr[0].equals("gw") || pathArr[0].equals("edms")|| pathArr[0].equals("schedule"))) {
				// /gw/test/tes.do  ->  test/tes.do  변경
				urlPath = urlPath.substring(pathArr[1].length()+1);
			}
		}
		
		params.put("urlPath", urlPath);

		List<Map<String,Object>> list = null;

		if (!EgovStringUtil.isEmpty(userSe)) {

			if (userSe.equals("USER")) {
				list = menuManageService.selectMenuListOfUrl(params);
			} else if (userSe.equals("ADMIN") || userSe.equals("MASTER")) {
				list = menuManageService.selectMenuAdminListOfUrl(params);
			}
		}

		JSONArray json = JSONArray.fromObject(list);
		//크로스사이트 스크립트 (XSS)
		String callback = EgovStringUtil.isNullToString(params.get("callback"));
		
		if (callback != null) {
			  // 외부 입력 내 위험한 문자를 이스케이핑
			callback = callback.replaceAll("<", "&lt;"); 
			callback = callback.replaceAll(">", "&gt;");
		}
		
		response.getWriter().write(callback+"(["+json+"])");
		response.getWriter().flush();
		response.getWriter().close();   

	}
	
	
	
	@RequestMapping("/cmm/system/getMenuListOfMenuNo.do")
	public void getMenuListOfMenuNo(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		response.setCharacterEncoding("UTF-8");
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String userSe = String.valueOf(params.get("userSe"));
		
		params.put("langCode", loginVO.getLangCode());
		
		if (EgovStringUtil.isEmpty(userSe)) {
			userSe = "USER";
		}
		
		List<Map<String,Object>> list = null;

		if (!EgovStringUtil.isEmpty(userSe)) {

			if (userSe.equals("USER")) {
				list = menuManageService.selectMenuListOfMenuNo(params);
			} else if (userSe.equals("ADMIN") || userSe.equals("MASTER")) {
				list = menuManageService.selectMenuAdminListOfUrl(params);
			}
		}

		JSONArray json = JSONArray.fromObject(list);
		
		String callback = EgovStringUtil.isNullToString(params.get("callback"));
		
		if (callback != null) {
			  // 외부 입력 내 위험한 문자를 이스케이핑
			callback = callback.replaceAll("<", "&lt;"); 
			callback = callback.replaceAll(">", "&gt;");
		}
		
		response.getWriter().write(callback+"(["+json+"])");
		response.getWriter().flush();
		response.getWriter().close();   

	}

	 public static String phoneFormat(String phoneNo){
		  
		   if (phoneNo.length() == 0){
		    return phoneNo;
		      }
		   
		      String strTel = phoneNo;
		      String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043",
		                           "051", "052", "053", "054", "055", "061", "062",
		                           "063", "064", "010", "011", "012", "013", "015",
		                           "016", "017", "018", "019", "070", "050"};
		      
		      if (strTel.length() < 9) {
		          return strTel;
		      } else if (strTel.substring(0,2).equals(strDDD[0])) {
		          strTel = strTel.substring(0,2) + '-' + strTel.substring(2, strTel.length()-4)
		               + '-' + strTel.substring(strTel.length() -4, strTel.length());
		      } else if(strTel.substring(0, 3).equals(strDDD[26])){
		    	  strTel = strTel.substring(0,4) + '-' + strTel.substring(4, strTel.length()-4)
		                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
		      } else {
		          for(int i=1; i < strDDD.length; i++) {
		              if (strTel.substring(0,3).equals(strDDD[i])) {
		                  strTel = strTel.substring(0,3) + '-' + strTel.substring(3, strTel.length()-4)
		                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
		              }
		          }
		      }
		      return strTel;
		 }
	 
		public String base64Encode(String str) throws UnsupportedEncodingException {
			byte[] encode = Base64.encodeBase64(str.getBytes());
					
			return new String(encode, "UTF-8");
		}
}
