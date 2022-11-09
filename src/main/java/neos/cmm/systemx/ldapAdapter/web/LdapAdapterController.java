package neos.cmm.systemx.ldapAdapter.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.kendo.KItemBase;
import neos.cmm.kendo.KTree;
import neos.cmm.kendo.KTreeItem;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;
import neos.cmm.systemx.ldapAdapter.dao.LdapAdapterDAO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import neos.cmm.systemx.comp.service.CompManageService;


@Controller
public class LdapAdapterController {
	
	@Resource(name="LdapAdapterService")
	public LdapAdapterService ldapManageService;
	
	@Resource(name = "LdapAdapterDAO")
    private LdapAdapterDAO ldapAdapterDAO;	
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@Resource(name = "CompManageService")
	private CompManageService compService;	
	
	@RequestMapping("/systemx/ldapManageView.do")
    public ModelAndView ldapManageView(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		String userSe = loginVO.getUserSe();
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("userSe", userSe);
		paramMap.put("compSeq", loginVO.getCompSeq());
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("loginId", loginVO.getId());
			
			if (userSe.equals("ADMIN")) {
				paramMap.put("empSeq", loginVO.getUniqId());
			}
			compList = compService.getCompListAuth(paramMap);
		}
		
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		mv.addObject("params", paramMap);
		
		mv.setViewName("/neos/cmm/systemx/ldapAdapter/ldapManageView");
		
		return mv;
	}
	
	@RequestMapping(value="/systemx/ldapSyncAutoSetPop.do")
	public ModelAndView erpSyncAutoSetPop(HttpServletRequest request, @RequestParam Map<String,Object> params) {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}

		Map<String,Object> ldapSetInfo = ldapAdapterDAO.getLdapSetInfo(params);
		
		if(ldapSetInfo != null){
			mv.addObject("ldapSetInfo", ldapSetInfo);
		}
		
		mv.addObject("compSeq", params.get("compSeq"));
		mv.setViewName("/neos/cmm/systemx/ldapAdapter/pop/ldapSyncAutoSetPop");

		return mv;
	}
	
	@RequestMapping(value="/systemx/ldapSyncPop.do")
	public ModelAndView ldapSyncPop(HttpServletRequest request, @RequestParam Map<String,Object> params) throws NamingException {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/ldapAdapter/pop/ldapSyncPop");

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}

		Map<String,Object> ldapSetInfo = ldapAdapterDAO.getLdapSetInfo(params);
		
		if(ldapSetInfo != null){
			
			if(ldapSetInfo.get("syncMode").equals("atg")){
				
				mv.setViewName("/neos/cmm/systemx/ldapAdapter/pop/ldapSyncPopAtg");
				
				params.putAll(ldapSetInfo);
					
				List<Map<String,Object>> list = ldapManageService.ldapOuListInfo(ldapSetInfo);
				
				//키데이터 정리
				ldapManageService.ldapGarbageCheck(params);
				
				List<KItemBase> treeList = new ArrayList<KItemBase>();
				
				if (list != null && list.size() > 0) {
					
					params.put("orgDiv", "D");	
					String ldapKeyList = ldapManageService.ldapKeyList(params);
					
					KTree tree = new KTree();
					tree.setRoot(new KTreeItem("0","0", ldapSetInfo.get("deptDir").toString() ,true, "rootfolder", "", "", "", "", "", ""));

					for(Map<String,Object> map : list) {

						KTreeItem item = new KTreeItem(map.get("id").toString(), map.get("upperId").toString(), map.get("name").toString(), true, "folder", map.get("key").toString(), map.get("distinguishedName").toString(),"","","","");
						
						if(ldapKeyList != null && ldapKeyList.indexOf("," + map.get("key").toString() + ",") > -1){
							item.setChecked(true);	
						}else{
							item.setChecked(false);
						}

						treeList.add(item);
					}
					
					tree.addAll(treeList);
					
					JSONObject json = JSONObject.fromObject(tree.getRoot());
					mv.addObject("treeList", json);					
				} 		
				
			}else{
				if(ldapSetInfo.get("deptOuType").equals("M")){
					ldapSetInfo.put("ldapDeptCnt", ldapAdapterDAO.selectLdapDeptCnt(params));
				}
				ldapSetInfo.put("ldapEmpCnt", ldapAdapterDAO.selectLdapEmpCnt(params));				
			}			

			mv.addObject("ldapSetInfo", ldapSetInfo);
		}
		
		mv.addObject("compSeq", params.get("compSeq"));
		

		return mv;
	}
	
	@RequestMapping("/systemx/ldapAtgUserList.do")
    public ModelAndView ldapAtgUserList(@RequestParam Map<String,Object> params) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		if (!loginVO.getUserSe().equals("MASTER")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		if(params.get("atgSyncYn").equals("N")){
			Map<String,Object> ldapSetInfo = ldapAdapterDAO.getLdapSetInfo(params);
			
			if(ldapSetInfo != null){
				params.putAll(ldapSetInfo);
				ldapManageService.ldapGarbageUserCheck(params);
				ldapManageService.ldapGetAdUserInfo(params);
			}			
		}
		
		ModelAndView mv = new ModelAndView();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		String noPage = params.get("isNoPage")+"";
		
		if (!noPage.equals("true")) {
			int page = EgovStringUtil.zeroConvert(params.get("page"));
			int pageSize = EgovStringUtil.zeroConvert(params.get("pageSize"));
			
			if (page > Integer.MAX_VALUE || page < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			
			if (pageSize > Integer.MAX_VALUE || pageSize < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			
			paginationInfo.setCurrentPageNo(page);
			paginationInfo.setPageSize(pageSize);
		}
		
		Map<String,Object> listMap = ldapManageService.ldapAtgUserList(params, paginationInfo);
		mv.addAllObjects(listMap);
		mv.setViewName("jsonView");
		
		return mv;
	}	
	
	@RequestMapping(value="/systemx/ldapSyncDetailListPop.do")
	public ModelAndView ldapSyncDetailListPop(HttpServletRequest request, @RequestParam Map<String,Object> params) {

		ModelAndView mv = new ModelAndView();

		mv.addObject("syncSeq", params.get("syncSeq"));
		mv.setViewName("/neos/cmm/systemx/ldapAdapter/pop/ldapSyncDetailListPop");

		return mv;
	}	
	
	
	
	@RequestMapping("/systemx/ldapConnectionCheckSave.do")
    public ModelAndView ldapConnectionCheckSave(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}
		
		//ldap연결상태 체크
		Map<String, Object> ldapConnectionCheck = ldapManageService.ldapConnectionCheck(params);
		
		//저장일경우
		if(ldapConnectionCheck.get("resultCode").equals("SUCCESS") && params.get("type").equals("save")){
			
			if(params.get("syncMode").equals("atg") && params.get("deptOuType").equals("S")){
				
				//기본매핑부서 설정
				params.put("deptCd", params.get("empDir"));
				String deptSeq = ldapAdapterDAO.selectDeptSeqFomDeptCd(params);
				
				if(deptSeq != null){
					
					Map<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("orgDiv", "D");
					paramMap.put("gwSeq", "syncDept");
					paramMap.put("usn", "syncDept");
					paramMap.put("adName", params.get("deptDir"));
					paramMap.put("relateDeptSeq", deptSeq);
					paramMap.put("compSeq", params.get("compSeq"));
					
					ldapAdapterDAO.setLdapKey(paramMap);
					
				}else{
					ldapConnectionCheck.put("result", BizboxAMessage.getMessage("TX800000066","부서코드가 유효하지 않습니다."));
					ldapConnectionCheck.put("resultCode", "fail");	
					mv.addAllObjects(ldapConnectionCheck);
					return mv;
				}		
				
			}
						
			if(ldapAdapterDAO.insertLdapConnectionSet(params)){
				ldapConnectionCheck.put("result", BizboxAMessage.getMessage("TX800000067","AD 기본정보 저장 완료"));
				ldapConnectionCheck.put("resultCode", "SUCCESS");
			}else{
				ldapConnectionCheck.put("result", BizboxAMessage.getMessage("TX800000068","기본정보 저장 실패"));
				ldapConnectionCheck.put("resultCode", "fail");				
			}
		}
		
		mv.addAllObjects(ldapConnectionCheck);
		return mv;
	}
	
	@RequestMapping("/systemx/updateLdapSchSet.do")
    public ModelAndView ldapSchSave(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}
		
		ldapAdapterDAO.updateLdapSchSet(params);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/systemx/resetLdapSetInfo.do")
    public ModelAndView resetLdapSetInfo(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}
		
		ldapAdapterDAO.resetLdapSetInfo(params);
		
		mv.setViewName("jsonView");
		
		return mv;
	}		
	
	@RequestMapping("/systemx/getLdapSetInfo.do")
    public ModelAndView getLdapSetInfo(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}
		
		mv.addObject("ldapSetInfo", ldapAdapterDAO.getLdapSetInfo(params));
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/systemx/ldapSyncProcess.do")
    public ModelAndView ldapSyncProcess(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}
		
		try{
			if(params.get("orgDiv").equals("D")){
				ldapManageService.ldapDeptSave(params);
			}else{
				ldapManageService.ldapEmpSave(params);
			}
			
			mv.addObject("resultCode", "SUCCESS");
		}catch(Exception e){
			mv.addObject("resultCode", "fail");
		}

		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/systemx/createLdapSyncListInfo.do")
    public ModelAndView createLdapSyncListInfo(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}
		
		List<Map<String,Object>> syncNewList = ldapAdapterDAO.selectLdapSyncTargetList(params);
		
		if(syncNewList != null && syncNewList.size() > 0){
			String newSyncSeq = UUID.randomUUID().toString().replace("-", "");
			params.put("syncSeq", newSyncSeq);
			params.put("syncMode", "M");
			ldapAdapterDAO.insertLdapReq(params);
			mv.addObject("newSyncSeq",newSyncSeq);
		}
		
		mv.addObject("syncNewList",syncNewList);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/systemx/ldapAuthCheck.do")
    public ModelAndView ldapAuthCheck(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		params.put("groupSeq", params.get("groupSeq"));
		mv.addAllObjects(ldapManageService.ldapAuthCheck(params));
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/systemx/ldapSyncDetailList.do")
	public ModelAndView ldapSyncDetailList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		if (!loginVO.getUserSe().equals("MASTER")) {
			params.put("compSeq", loginVO.getCompSeq());
		}		
		
		ModelAndView mv = new ModelAndView();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		String noPage = params.get("isNoPage")+"";
		
		if (!noPage.equals("true")) {
			paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
			paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
		}
		
		Map<String,Object> listMap = ldapManageService.ldapSyncDetailList(params, paginationInfo);
		mv.addAllObjects(listMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/systemx/ldapSyncDetail.do")
	public ModelAndView ldapSyncDetail(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		if (!loginVO.getUserSe().equals("MASTER")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		ModelAndView mv = new ModelAndView();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		String noPage = params.get("isNoPage")+"";
		
		if (!noPage.equals("true")) {
			paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
			paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
		}
		
		Map<String,Object> listMap = ldapManageService.ldapSyncDetail(params, paginationInfo);
		mv.addAllObjects(listMap);
		mv.setViewName("jsonView");
		
		return mv;
	}

	@RequestMapping("/systemx/insertOuInfo.do")
	public ModelAndView insertOuInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		if (!loginVO.getUserSe().equals("MASTER")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		ModelAndView mv = new ModelAndView();

		mv.setViewName("jsonView");
		
		JSONArray pTEAG = JSONArray.fromObject(params.get("ouInfo"));
		
		//키데이터 정리
		ldapManageService.ldapGarbageCheck(params);
		
		String usnArray = ",";
		
		for (int i = 0; i < pTEAG.size(); i++) {
			JSONObject jsonOb = JSONObject.fromObject(pTEAG.get(i));
			
			if(!jsonOb.get("interlock_url").equals("")){
				Map<String,Object> item =  new HashMap<String,Object>();
				item.put("groupSeq",loginVO.getGroupSeq());
				item.put("compSeq",params.get("compSeq"));
				item.put("deptName",jsonOb.get("name"));
				item.put("seq",jsonOb.get("seq"));
				item.put("parentSeq",jsonOb.get("parentSeq"));
				item.put("usn",jsonOb.get("interlock_url"));
				item.put("adName",jsonOb.get("interlock_width"));
				ldapManageService.insertOuInfo(item);
				usnArray = usnArray + jsonOb.get("interlock_url") + ",";
			}
		}
		
		params.put("usnArray", usnArray);
		ldapManageService.ldapdeleteRemoveLdapKey(params);
		
		mv.addObject("result","success");
		
		return mv;
	}
	
	@RequestMapping("/systemx/ldapAtgProc.do")
	public ModelAndView ldapAtgProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		if (!loginVO.getUserSe().equals("MASTER")) {
			params.put("compSeq", loginVO.getCompSeq());
		}

		if(params.get("syncUserStatus").equals("link")){
			ldapAdapterDAO.updateLdapEmpLinkSeq(params);
		}else{
			ldapManageService.insertLdapAtgNewUserList(params);
		}
		
		mv.addObject("result","success");
		
		return mv;
	}	
	
	
	
	

}
