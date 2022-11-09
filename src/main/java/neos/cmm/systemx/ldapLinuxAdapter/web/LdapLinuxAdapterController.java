package neos.cmm.systemx.ldapLinuxAdapter.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.naming.directory.DirContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.dept.service.DeptManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.ldapLinuxAdapter.service.LdapLinuxContextManagerService;
import neos.cmm.systemx.ldapLinuxAdapter.service.LdapLinuxSearchService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;

@Controller
public class LdapLinuxAdapterController {
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "DeptManageService")
	private DeptManageService deptManageService;
	
	@Resource(name="EmpManageService")
    private EmpManageService empManageService;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name="LdapLinuxContextManagerService")
	private LdapLinuxContextManagerService ldapLinuxContextManagerService;
	
	@Resource(name="LdapLinuxSearchService")
	private LdapLinuxSearchService LdapLinuxSearchService;
	
	private static final String USERID = "cn=admin,dc=top";
	private static final String PASSWD = "duzon@1234";
	private static final String URL = "ldap://14.41.55.213:389";
	private static final String SEARCHBASE = "dc=top";
	private static final String SEARCHFILTER = "(&(objectClass=*))";

	@IncludedInfo(name="LDAP조직도연동테스트dwchun", order = 120 ,gid = 60)
	@RequestMapping("/cmm/systemx/ldapLinuxAdapterView.do")
	public ModelAndView ldapLinuxAdapterView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}

		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		mv.addObject("groupMap", groupMap);
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", userSe);
			
			if (userSe.equals("ADMIN")) {
				params.put("compSeq", loginVO.getCompSeq());
				params.put("empSeq", loginVO.getUniqId());
			}
			compList = compService.getCompListAuth(params);
		}
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		
		/** 현재 회사 선택 */
		String compSeq = params.get("compSeq")+"";
		if (EgovStringUtil.isEmpty(compSeq) ) {
			if(loginVO.getUserSe().equals("MASTER")){
				//마스터일경우 회사선택 가능
				if(compList!=null) {//Null Pointer 역참조
				params.put("compSeq", compList.get(0).get("compSeq"));
				}
			}else{
				//admin일경우 자기가 속한 회사 선택 
				params.put("compSeq", loginVO.getCompSeq());	
			}	
		}
		
		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);
		
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}
		
		mv.setViewName("/neos/cmm/systemx/ldapLinuxAdapter/ldapLinuxAdapterView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/ldapLinuxAdapterInfo.do")
	public ModelAndView ldapLinuxAdapterInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("langCode", loginVO.getLangCode());
		params.put("groupSeq", loginVO.getGroupSeq());
		
		/** 부서장 선택 컬럼 사용여부 (sk D&D 사용) 2016.09.26 장지훈 추가 */
		//mv.addObject("")
		List<Map<String, String>> captain = CommonCodeUtil.getCodeList("deptCaptain");
		
		if(captain != null) {
			mv.addObject("deptCaptain", "Y");
			params.put("deptCaptain", "Y");
		} else {
			mv.addObject("deptCaptain", "N");
			params.put("deptCaptain", "N");
		}
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		mv.addObject("groupMap", groupMap);
		
		/** 부서/사업장 정보 조회 */
		Map<String,Object> deptMap = deptManageService.selectDeptBizInfo(params);
		mv.addObject("deptMap", deptMap);
		
		Map<String,Object> deptMultiMap = deptManageService.selectDeptBizInfoLangMulti(params);
		mv.addObject("deptMultiMap",deptMultiMap);
		
		/** 부서장 정보 조회*/
		if(params.get("deptCaptain").equals("Y") && deptMap != null && deptMap.get("deptManager") != null) {
			String captainSeqInfo = deptMap.get("deptManager").toString();
			String captainDeptSeq = captainSeqInfo.split("\\|")[0];
			String captainEmpSeq = captainSeqInfo.split("\\|")[1];
			
			params.put("deptSeq", captainDeptSeq);
			params.put("empSeq", captainEmpSeq);

			Map<String, Object> infoMap = empManageService.selectEmpInfo(params);
			String captainInfo = infoMap.get("deptName") + " " + infoMap.get("positionCodeName") + " " + infoMap.get("empName");
			mv.addObject("captainInfo", captainInfo);
		}

		/** 회사 다국어 정보 가져오기 */
		params.put("mainYn", "Y");	// 회사에서 선택한 주사용언어
		params.put("subYn", "Y");   // 회사에서 선택한 부사용언어	
		
		if (deptMap != null) {
			params.put("compSeq", deptMap.get("compSeq"));
		}
		List<Map<String,Object>> langList = orgChartService.getCompLangList(params);
		mv.addObject("langList", langList);
		
		/** ERP조직도 연동 옵션값 가져오기 2016.12.29 장지훈 추가 */
		if (deptMap != null) {
			params.put("option", "cm1100");
			
			Map<String, Object> erpOptions = commonOptionManageService.getErpOptionValue(params);
			
			if(erpOptions.get("optionRealValue").equals("0")) {
				mv.addObject("erpUse", "N");
			} else {
				mv.addObject("erpUse", "Y");
			}			
		}
		
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}

		mv.addObject("eaType", loginVO.getEaType());
		mv.setViewName("/neos/cmm/systemx/ldapLinuxAdapter/include/ldapLinuxAdapterInfo");
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("/cmm/systemx/ldapLinuxAdapterOrgChartListJT.do")
	public Object ldapLinuxAdapterOrgChartListJT(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		List<Map<String, Object>> tree = new ArrayList<Map<String,Object>>();
		JSONArray deptListJson = new JSONArray();
		
		DirContext context = ldapLinuxContextManagerService.getContext(USERID, PASSWD, URL);

		try {
			tree = LdapLinuxSearchService.search(context, SEARCHBASE, SEARCHFILTER);
			deptListJson = JSONArray.fromObject(tree);
		} 
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			tree = new ArrayList<Map<String,Object>>();
			deptListJson = new JSONArray();
		}
		
		mv.addObject(deptListJson);
		mv.setViewName("jsonView");
		
		return deptListJson;
	}
}
