package neos.cmm.systemx.orgchart.web;

import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.common.util.FormatUtil;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.dutyPosition.sercive.DutyPositionManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.orgchart.OrgChartNode;
import neos.cmm.systemx.orgchart.OrgChartSupport;
import neos.cmm.systemx.orgchart.OrgChartTree;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.JsonUtil;
import neos.cmm.util.code.service.SequenceService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class OrgChartController {

	protected Logger logger = Logger.getLogger(super.getClass());

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Resource(name = "SequenceService")
	private SequenceService sequenceService;

	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;

	@Resource(name = "CompManageService")
	private CompManageService compManageService;

	@Resource(name = "EmpManageService")
	private EmpManageService empManageService;
	
	@Resource(name = "ExcelService")
	private ExcelService excelService;
	
	@Resource(name = "CommonOptionManageService")
	CommonOptionManageService commonOptionManageService;	

	@Resource(name = "DutyPositionManageService")
	private DutyPositionManageService dutyPositionService;

	@IncludedInfo(name = "조직도(부서)리스트", order = 130, gid = 60)
	@RequestMapping("/systemx/orgChartList.do")
	public ModelAndView orgChartListView(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		mv = orgChartList(params);

		mv.addObject("params", params);

		mv.setViewName("/neos/cmm/systemx/orgchart/include/orgChartList");

		return mv;
	}

	@IncludedInfo(name = "조직도(부서)리스트", order = 130, gid = 60)
	@RequestMapping("/systemx/orgChartListJT.do")
	public ModelAndView orgChartListJTView(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		// mv = orgChartList(params,response);

		mv.addObject("params", params);

		mv.setViewName("/neos/cmm/systemx/orgchart/include/orgChartListJT");

		return mv;
	}

	@RequestMapping("/systemx/orgChartListJsonData.do")
	public ModelAndView orgChartListJsonData(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		mv = orgChartList(params);

		mv.setViewName("jsonView");

		return mv;
	}

	@IncludedInfo(name = "조직도(사용자)리스트", order = 170, gid = 60)
	@RequestMapping("/systemx/orgChartEmpList.do")
	public ModelAndView orgChartEmpList(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		mv = orgChartList(params);

		mv.addObject("params", params);

		mv.setViewName("/neos/cmm/systemx/orgchart/include/orgChartEmpList");

		return mv;
	}

	@RequestMapping("/systemx/orgChartDeptEmpListPop.do")
	public ModelAndView orgChartDeptEmpList(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		mv = orgChartDeptEmpTreeView();

		mv.addObject("params", params);

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartDeptEmpListPop");

		return mv;
	}

	@RequestMapping("/systemx/orgChartEmpTreeListPop.do")
	public ModelAndView orgChartEmpTreeListPop(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.addObject("params", params);

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartEmpTreeListPop");

		return mv;
	}

	/**
	 * 회사 / 부서 선택 팝업 (공용)
	 * 
	 * @param HttpServletRequest
	 *            req
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "조직도 회사&부서 선택 팝업 (공용)", order = 169, gid = 60)
	@RequestMapping("/systemx/cmmOrgchartSelectDeptPop.do")
	public ModelAndView selectOrganView(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmOrgChartSelectDeptPop");

		return mv;
	}

	/**
	 * 타서비스 배포용(가장 많이 사용할 것으로 판단되는 조직도 팝업)
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "공용 조직도 리스트(사용자선택)", order = 171, gid = 60)
	@RequestMapping("/systemx/cmmOrgChartSelectPop.do")
	public ModelAndView cmmOrgChartSelectPop(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();

		params.put("langCode", loginVO.getLangCode());

		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";

		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		params.put("userSe", loginVO.getUserSe());

		if (EgovStringUtil.isEmpty(params.get("userSe") + "")) {
			params.put("userSe", "USER");
		}

		params.put("workStatus", "999");
		params.put("useYn", "Y");

		mv = orgChartList(params);

		mv.addObject("params", params);

		/** 이미 선택되어진 사원 정보 처리 */
		String selectUserList = params.get("selectUserList") + "";

		if (!EgovStringUtil.isEmpty(selectUserList)) {
			String[] fields = new String[] { "deptSeq", "empSeq" };
			List<Map<String, Object>> list = JsonUtil.getJsonToArray(selectUserList, fields);

			params.put("deptSeqList", list);
			params.put("empSeqList", list);

			Map<String, Object> listMap = empManageService.selectEmpInfo(params, new PaginationInfo());

			if (listMap != null && listMap.get("list") != null) {
				List<Map<String, Object>> rlist = (List<Map<String, Object>>) listMap.get("list");

				mv.addObject("selectEmpList", rlist);
			}
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmOrgChartSelectPop");

		return mv;
	}

	@RequestMapping("/cmm/systemx/cmmOrgChartInnerEmpList.do")
	public ModelAndView cmmOrgChartInnerEmpList(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();

		params.put("langCode", loginVO.getLangCode());
		params.put("workStatus", "999");
		params.put("useYn", "Y");

		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";

		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		params.put("userSe", loginVO.getUserSe());

		if (EgovStringUtil.isEmpty(params.get("userSe") + "")) {
			params.put("userSe", "USER");
		}

		Map<String, Object> listMap = empManageService.selectEmpInfo(params, new PaginationInfo());

		if (listMap != null && listMap.get("list") != null) {
			List<Map<String, Object>> list = (List<Map<String, Object>>) listMap.get("list");

			mv.addObject("empList", list);
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/include/cmmOrgChartInnerEmpList");

		return mv;
	}

	@RequestMapping("/systemx/include/orgChartListChkBox.do")
	public ModelAndView orgChartListViewPop(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		mv = orgChartList(params);

		mv.setViewName("/neos/include/orgChartListChkBox");

		return mv;

	}

//	// 체크박스 리스트 샘플
//	@RequestMapping("/system/orgChartListChk.do")
//	public ModelAndView orgChartListChkView(@RequestParam Map<String, Object> params, HttpServletResponse response)
//			throws Exception {
//		ModelAndView mv = new ModelAndView();
//
//		mv = orgChartListForAuth(params, response);
//
//		mv.setViewName("/neos/include/orgChartListChk");
//
//		return mv;
//
//	}

//	// 팝업 리스트 샘플
//	@RequestMapping("/system/orgChartListPop.do")
//	public ModelAndView orgChartListChkPopView(@RequestParam Map<String, Object> params, HttpServletResponse response)
//			throws Exception {
//		ModelAndView mv = new ModelAndView();
//
//		mv = orgChartListForAuth(params, response);
//
//		mv.setViewName("/neos/include/orgChartListPop");
//
//		return mv;
//
//	}

	public ModelAndView orgChartDeptEmpTreeView()
			throws Exception {

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		List<Map<String, Object>> deptList = OrgChartSupport.getIOrgGrpService().SelectDeptList(loginVO.getGroupSeq(),
				loginVO.getCompSeq(), loginVO.getBizSeq(), loginVO.getLangCode());
		Map<String, Object> deptMap = null;
		if (deptList != null && deptList.size() > 0) {
			deptMap = deptList.get(0);
			mv.addObject("deptMap", deptList.get(0));
		}
		
		String deptSeq = null;
		String deptName = null;
		if(deptMap!=null) {//Null Pointer 역참조
			deptSeq = String.valueOf(deptMap.get("deptSeq"));
			deptName = String.valueOf(deptMap.get("deptName"));
		}
		
		List<Map<String, Object>> list = OrgChartSupport.getIOrgEmpService().SelectEmpList(loginVO.getGroupSeq(),
				loginVO.getCompSeq(), loginVO.getBizSeq(), deptSeq,
				loginVO.getLangCode());

		List<OrgChartNode> pList = new ArrayList<OrgChartNode>();

		for (Map map : list) {
			String seq = null;
			String name = null;

			seq = String.valueOf(map.get("empSeq"));
			name = String.valueOf(map.get("empName"));

			String parentSeq = String.valueOf(map.get("deptSeq"));
			pList.add(new OrgChartNode(seq, parentSeq, name));

		}

		OrgChartTree menu = null;
		
		menu = new OrgChartTree(deptSeq, "0", deptName,
				"g");

		menu.addAll(pList);

		JSONObject json = JSONObject.fromObject(menu.getRoot());

		mv.addObject("orgChartList", json);

		return mv;
	}

	public ModelAndView orgChartList(@RequestParam Map<String, Object> params)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		if (params.get("langCode") == null || params.get("groupSeq") == null) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());

			params.put("groupSeq", loginVO.getGroupSeq());

		}

		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		if (groupMap != null) {
			params.put("groupName", groupMap.get("groupName"));
		}

		/** 조직도 조회 */
		Map<String, Object> bizDeptParams = new HashMap<>();
		bizDeptParams.put("compSeqList", params.get("compSeqList"));
		bizDeptParams.put("groupSeq", params.get("groupSeq"));
		bizDeptParams.put("langCode", params.get("langCode"));
		bizDeptParams.put("gbnOrgList", params.get("gbnOrgList"));

		/** 그룹 이하 전체 조회 여부 */
		String groupAll = params.get("isGroupAll") + "";

		if (!groupAll.equals("Y")) {
			bizDeptParams.put("compSeq", params.get("compSeq"));
		}

		List<Map<String, Object>> list = orgChartService.selectCompBizDeptList(bizDeptParams);

		/** 트리 구조로 변환 */
		Map<String, Object> treeParams = new HashMap<>();
		treeParams.put("groupSeq", params.get("groupSeq"));
		treeParams.put("groupName", params.get("groupName"));
		treeParams.put("compSeq", params.get("compSeq"));
		treeParams.put("isGroupAll", groupAll);

		OrgChartTree tree = orgChartService.getOrgChartTree(list, treeParams);
		JSONObject json = JSONObject.fromObject(tree.getRoot());
		mv.addObject("orgChartList", json);

		return mv;
	}

	@ResponseBody
	@RequestMapping("/cmm/systemx/orgChartListJT.do")
	public Object orgChartListJT(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		if (params.get("langCode") == null || params.get("groupSeq") == null) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("deptSeq", loginVO.getOrgnztId());
		}
		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		params.put("groupName", groupMap.get("groupName"));

		/** 조직도 조회 */
		List<Map<String, Object>> list = orgChartService.getCompBizDeptList(params);

		/** 트리 구조로 변환 */
		List<Map<String, Object>> tree = orgChartService.getOrgChartTreeJT(list, params);
		JSONArray json = JSONArray.fromObject(tree);

		mv.addObject(json);
		mv.setViewName("jsonView");

		return json;
	}

	public Object orgChartListStr(@RequestParam Map<String, Object> params)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		List<Map<String, Object>> groupList = OrgChartSupport.getIOrgGrpService().SelectGroupList(loginVO.getGroupSeq());
		Map<String, Object> groupMap = null;
		if (groupList != null && groupList.size() > 0) {

			for (int i = 0; i < groupList.size(); i++) {

				Map<String, Object> m = groupList.get(i);

				if (m != null) {
					String gSeq = String.valueOf(m.get("groupSeq"));
					if (gSeq != null && gSeq.equals(loginVO.getGroupSeq())) {
						groupMap = m;
						break;
					}
				}
			}
			mv.addObject("groupMap", groupMap);
		}

		String tempGroupSeq = null;
		String tempGroupName = null;
		if(groupMap!=null) {//Null Pointer 역참조
			tempGroupSeq = String.valueOf(groupMap.get("groupSeq"));
			tempGroupName = String.valueOf(groupMap.get("groupName"));
		}
		
		List<Map<String, Object>> list = OrgChartSupport.getIOrgService()
				.SelectCompBizDeptList(tempGroupSeq, loginVO.getLangCode());

		List<OrgChartNode> pList = new ArrayList<OrgChartNode>();

		String groupSeq = "";
		String bizSeq = "";
		String compSeq = "";
		String deptSeq = "";

		/** 회사시퀀스가 처리 */
		String reqCompSeq = params.get("compSeq") + "";
		String compName = null;
		for (Map map : list) {
			String seq = null;
			String name = null;
			String gbnOrg = String.valueOf(map.get("gbnOrg"));

			groupSeq = String.valueOf(map.get("grpSeq"));
			bizSeq = String.valueOf(map.get("bizSeq"));
			compSeq = String.valueOf(map.get("compSeq"));
			deptSeq = String.valueOf(map.get("deptSeq"));

			if (gbnOrg.equals("c")) {
				seq = String.valueOf(map.get("compSeq"));
				name = String.valueOf(map.get("compName"));
			} else if (gbnOrg.equals("b")) {
				seq = String.valueOf(map.get("bizSeq"));
				name = String.valueOf(map.get("bizName"));
			} else if (gbnOrg.equals("d")) {
				seq = String.valueOf(map.get("deptSeq"));
				name = String.valueOf(map.get("deptName"));
			}

			String parentSeq = String.valueOf(map.get("compSeq"));
			String path = String.valueOf(map.get("path"));
			String[] pathArr = path.split("\\|");
			if (pathArr.length == 1) {
				parentSeq = tempGroupSeq;
			} else {
				parentSeq = pathArr[pathArr.length - 2];
			}

			if (EgovStringUtil.isEmpty(reqCompSeq)) {
				pList.add(new OrgChartNode(seq, parentSeq, name, gbnOrg));
			} else {
				String c = String.valueOf(map.get("compSeq"));
				if (reqCompSeq.equals(c)) {

					pList.add(new OrgChartNode(groupSeq, bizSeq, compSeq, deptSeq, seq, parentSeq, name, gbnOrg));

					if (EgovStringUtil.isEmpty(compName) && gbnOrg.equals("c")) {
						compName = name;
					}
				}
			}
		}

		OrgChartTree menu = null;
		if (EgovStringUtil.isEmpty(reqCompSeq)) {
			menu = new OrgChartTree(tempGroupSeq, "0",
					tempGroupName, "g");
		} else {
			menu = new OrgChartTree(reqCompSeq, "0", compName, "c");
		}

		menu.addAll(pList);

		JSONObject json = JSONObject.fromObject(menu.getRoot());

		return json;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/systemx/orgChartData.do")
	public ModelAndView orgChartData(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		List<Map<String, Object>> groupList = OrgChartSupport.getIOrgGrpService().SelectGroupList(loginVO.getGroupSeq());
		Map<String, Object> groupMap = null;
		if (groupList != null && groupList.size() > 0) {

			for (int i = 0; i < groupList.size(); i++) {

				Map<String, Object> m = groupList.get(i);

				if (m != null) {
					String gSeq = String.valueOf(m.get("groupSeq"));
					if (gSeq != null && gSeq.equals(loginVO.getGroupSeq())) {
						groupMap = m;
						break;
					}
				}
			}
			mv.addObject("groupMap", groupMap);
		}

		String tempGroupSeq = null;
		if(groupMap!=null) {//Null Pointer 역참조
			tempGroupSeq = String.valueOf(groupMap.get("groupSeq"));
		}
		
		List<Map<String, Object>> list = OrgChartSupport.getIOrgService()
				.SelectCompBizDeptList(tempGroupSeq, loginVO.getLangCode());

		for (Map map : list) {
			String seq = null;
			String name = null;
			String gbnOrg = String.valueOf(map.get("gbnOrg"));

			if (gbnOrg.equals("c")) {
				seq = String.valueOf(map.get("compSeq"));
				name = String.valueOf(map.get("compName"));
			} else if (gbnOrg.equals("b")) {
				seq = String.valueOf(map.get("bizSeq"));
				name = String.valueOf(map.get("bizName"));
			} else if (gbnOrg.equals("d")) {
				seq = String.valueOf(map.get("deptSeq"));
				name = String.valueOf(map.get("deptName"));
			}

			boolean hasChildren = false;
			for (Map m : list) {
				String parentSeq = null;
				String path = String.valueOf(map.get("path"));
				String[] pathArr = path.split("\\|");
				if (pathArr.length == 1) {
					parentSeq = "0";
				} else {
					parentSeq = pathArr[pathArr.length - 2];
				}
				if (seq.equals(parentSeq)) {
					hasChildren = true;
				}
			}

			String parentSeq = String.valueOf(map.get("compSeq"));
			String path = String.valueOf(map.get("path"));
			String[] pathArr = path.split("\\|");
			if (pathArr.length == 1) {
				parentSeq = "0";
			} else {
				parentSeq = pathArr[pathArr.length - 2];
			}

			map.put("seq", seq);
			map.put("name", name);
			map.put("parentSeq", parentSeq);
			map.put("hasChildren", hasChildren);
		}

		mv.addObject("orgChartList", list);

		mv.setViewName("jsonView");

		return mv;
	}

//	public ModelAndView orgChartListForAuth(@RequestParam Map<String, Object> params, HttpServletResponse response)
//			throws Exception {
//
//		ModelAndView mv = new ModelAndView();
//		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
//
//		List<Map<String, Object>> groupList = OrgChartSupport.getIOrgGrpService().SelectGroupList();
//		Map<String, Object> groupMap = null;
//		if (groupList != null && groupList.size() > 0) {
//
//			for (int i = 0; i < groupList.size(); i++) {
//
//				Map<String, Object> m = groupList.get(i);
//
//				if (m != null) {
//					String gSeq = String.valueOf(m.get("groupSeq"));
//					if (gSeq != null && gSeq.equals(loginVO.getGroupSeq())) {
//						groupMap = m;
//						break;
//					}
//				}
//			}
//			mv.addObject("groupMap", groupMap);
//		}
//
//		// List<Map<String,Object>> list =
//		// OrgChartSupport.getIOrgService().SelectCompBizDeptList(String.valueOf(groupMap.get("groupSeq")),
//		// loginVO.getLangCode());
//
//		Map<String, Object> paramap = new HashMap<String, Object>();
//		paramap.put("groupSeq", String.valueOf(groupMap.get("groupSeq")));
//		paramap.put("langCode", loginVO.getLangCode());
//		paramap.put("authCode", params.get("authorCode"));
//
//		List<Map<String, Object>> list = orgChartService.SelectAuthDeptList(paramap);
//
//		List<OrgChartNode> pList = new ArrayList<OrgChartNode>();
//
//		for (Map map : list) {
//			String seq = null;
//			String name = null;
//			String gbnOrg = String.valueOf(map.get("gbnOrg"));
//			String checked = String.valueOf(map.get("checked"));
//
//			if (gbnOrg.equals("c")) {
//				seq = String.valueOf(map.get("compSeq"));
//				name = String.valueOf(map.get("compName"));
//			} else if (gbnOrg.equals("b")) {
//				seq = String.valueOf(map.get("bizSeq"));
//				name = String.valueOf(map.get("bizName"));
//			} else if (gbnOrg.equals("d")) {
//				seq = String.valueOf(map.get("deptSeq"));
//				name = String.valueOf(map.get("deptName"));
//			}
//
//			String parentSeq = String.valueOf(map.get("compSeq"));
//
//			// 소속 회사 조직도 정보를 갖고 오기 위해 parameter 및 loginVO에서 회사 코드 받아서 비교해야 할 듯
//			if (!parentSeq.equals(loginVO.getCompSeq())) {
//				continue;
//			}
//
//			String path = String.valueOf(map.get("path"));
//			String[] pathArr = path.split("\\|");
//			if (pathArr.length == 1) {
//				parentSeq = String.valueOf(groupMap.get("groupSeq"));
//			} else {
//				parentSeq = pathArr[pathArr.length - 2];
//			}
//			pList.add(new OrgChartNode(seq, parentSeq, name, gbnOrg, checked));
//
//		}
//
//		OrgChartTree menu = new OrgChartTree(String.valueOf(groupMap.get("groupSeq")), "0",
//				String.valueOf(groupMap.get("groupName")), "g");
//		menu.addAll(pList);
//
//		JSONObject json = JSONObject.fromObject(menu.getRoot());
//
//		System.out.println(json);
//
//		mv.addObject("orgChartList", json);
//
//		// mv.setViewName("/neos/cmm/systemx/orgChartList");
//
//		return mv;
//	}

//	/*
//	 * @@ 권한 부여 시 조직도 리스트
//	 */
//	@RequestMapping("/cmm/system/authorOrganView.do")
//	public ModelAndView authorOrganView(@RequestParam Map<String, Object> params, HttpServletResponse response,
//			HttpServletRequest request) throws Exception {
//
//		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
//
//		ModelAndView mv = new ModelAndView();
//
//		params.put("langCode", loginVO.getLangCode());
//
//		String compSeq = params.get("compSeq") + "";
//		String groupSeq = params.get("groupSeq") + "";
//
//		if (EgovStringUtil.isEmpty(compSeq)) {
//			if (loginVO.getId().equals("master")) {
//				CommonUtil.getSessionData(request, "compSeq", params);
//			} else {
//				params.put("compSeq", loginVO.getCompSeq());
//			}
//		}
//		if (EgovStringUtil.isEmpty(groupSeq)) {
//			params.put("groupSeq", loginVO.getGroupSeq());
//		}
//
//		params.put("workStatus", "999");
//		params.put("useYn", "Y");
//
//		mv = orgChartList(params);
//
//		mv.addObject("params", params);
//
//		/** 이미 선택되어진 사원 정보 처리 */
//		String selectUserList = params.get("selectUserList") + "";
//
//		if (EgovStringUtil.isEmpty(selectUserList) == false) {
//			String[] fields = new String[] { "deptSeq", "empSeq" };
//			List<Map<String, Object>> list = JsonUtil.getJsonToArray(selectUserList, fields);
//
//			params.put("deptSeqList", list);
//			params.put("empSeqList", list);
//
//			Map<String, Object> ListMap = empManageService.selectEmpInfo(params, new PaginationInfo());
//
//			if (ListMap != null && ListMap.get("list") != null) {
//				List<Map<String, Object>> rlist = (List<Map<String, Object>>) ListMap.get("list");
//
//				mv.addObject("selectEmpList", rlist);
//			}
//		}
//
//		mv.setViewName("/neos/cmm/System/author/popup/authorOrganView");
//
//		return mv;
//	}

	@IncludedInfo(name = "공용 조직도 리스트(회사,부서선택)", order = 172, gid = 60)
	@RequestMapping("/cmm/systemx/cmmCompDeptSelectPop.do")
	public ModelAndView cmmCompDeptSelectPop(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();

		params.put("langCode", loginVO.getLangCode());

		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		params.put("useYn", "Y");
		if (!EgovStringUtil.isEmpty(compSeq)) {
			mv = orgChartList(params);
		}

		mv.addObject("params", params);

		Map<String, Object> compParams = new HashMap<String, Object>();
		compParams.put("langCode", loginVO.getLangCode());
		compParams.put("compName", params.get("compName"));
		compParams.put("groupSeq", params.get("groupSeq"));

		mv.addObject("compList", compManageService.getCompList(compParams));

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmCompDeptSelectPop");

		return mv;
	}

	@IncludedInfo(name = "공통 조직도(개인/부서+직책+직급)", order = 173, gid = 60)
	@RequestMapping("/cmm/systemx/cmmOcType2Pop.do")
	public ModelAndView cmmOcType2Pop(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();

		String mode = params.get("mode") + "";

		LoginVO loginVO = null;
		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";
		String langCode = params.get("langCode") + "";
		String deptSeq = params.get("deptSeq") + "";
		if (mode.equals("dev")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
			loginVO.setUserSe("USER");
			loginVO.setOrgnztId(params.get("deptSeq") + "");
			params.remove("deptSeq");
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			deptSeq = loginVO.getOrgnztId();
		}

		params.put("focusSeq", deptSeq);

		params.put("langCode", loginVO.getLangCode());

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}

		params.put("useYn", "Y");

		mv = orgChartList(params);

		mv.addObject("params", params);

		Map<String, Object> compParams = new HashMap<String, Object>();
		compParams.put("langCode", loginVO.getLangCode());
		compParams.put("compName", params.get("compName"));
		compParams.put("groupSeq", params.get("groupSeq"));

		params.put("dpType", "POSITION");
		List<Map<String, Object>> poList = dutyPositionService.getCompDutyPositionList(params);
		mv.addObject("poList", poList);
		params.put("dpType", "DUTY");
		List<Map<String, Object>> duList = dutyPositionService.getCompDutyPositionList(params);
		mv.addObject("duList", duList);

		mv.addObject("callback", params.get("callback"));

		String type = params.get("type") + "";
		mv.addObject("type", params.get("type"));
		mv.addObject("compSeq", params.get("compSeq"));

		/** 이미 선택된 조직도 체크 */
		String[] fields = null;
		List<Map<String, Object>> list = null;
		String selectedOrgList = params.get("selectedOrgList") + "";
		if (!EgovStringUtil.isEmpty(selectedOrgList)) {
			selectedOrgList = URLDecoder.decode(selectedOrgList, "UTF-8");
			fields = new String[] { "seq", "deptSeq", "gbn" };
			list = JsonUtil.getJsonToArray(selectedOrgList, fields);

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> eList = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> dList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					String gbn = sMap.get("gbn") + "";
					if (!gbn.equals("m")) {
						if (gbn.equals("g")) {
							sMap.put("seqName", sMap.get("groupName"));}
						if (gbn.equals("c")) {
							sMap.put("seqName", sMap.get("compName"));}
						if (gbn.equals("d")) {
							sMap.put("seqName", sMap.get("deptName"));}
						dList.add(sMap);

					} else if (gbn.equals("m")) {
						eList.add(sMap);
					}
				}

				// 사원 리스트는 groupSeq,compSeq 없을수도 있으므로 db에서 조회하여 가져온다..
				if (eList.size() > 0) {
					Map<String, Object> eParams = new HashMap<>();
					eParams.put("langCode", params.get("langCode"));
					eParams.put("groupSeq", params.get("groupSeq"));
					eParams.put("selectedEmpList", eList);
					mv.addObject("sOrgEmpListJson", JSONArray.fromObject(orgChartService.getEmpSelectedList(eParams)));
				}

				if (dList.size() > 0) {
					mv.addObject("sOrgDeptListJson", JSONArray.fromObject(dList));
				}
			}

		}

		/** 이미 선택되어진 사원 정보 처리 */
		String selectUserList = params.get("selectedList") + "";

		if (!EgovStringUtil.isEmpty(selectUserList)) {
			selectUserList = URLDecoder.decode(selectUserList, "UTF-8");

			if (type.equals("0")) {
				fields = new String[] { "seq", "empName", "compName", "empSeq", "deptSeq", "compSeq", "deptName",
						"dutyName", "gbn", "groupSeq", "groupName", "bizSeq" };
				list = JsonUtil.getJsonToArray(selectUserList, fields);

				if (list != null && list.size() > 0) {
					List<Map<String, Object>> eList = new ArrayList<Map<String, Object>>();
					List<Map<String, Object>> dList = new ArrayList<Map<String, Object>>();
					List<Map<String, Object>> sList = new ArrayList<Map<String, Object>>();
					for (Map<String, Object> sMap : list) {
						String gbn = sMap.get("gbn") + "";
						if (!gbn.equals("m")) {
							if (gbn.equals("g")) {
								sMap.put("seqName", sMap.get("groupName"));
								sMap.remove("deptName");
							} else if (gbn.equals("c")) {
								sMap.put("seqName", sMap.get("compName"));
								sMap.remove("deptName");
							} else if (gbn.equals("d")) {
								sMap.put("seqName", sMap.get("deptName"));
							}
							dList.add(sMap);
						} else if (gbn.equals("m")) {
							eList.add(sMap);
						}
					}
					if (eList.size() > 0) {
						Map<String, Object> eParams = new HashMap<>();
						eParams.put("langCode", params.get("langCode"));
						eParams.put("groupSeq", params.get("groupSeq"));
						eParams.put("selectedEmpList", eList);
						sList = orgChartService.getEmpSelectedList(eParams);
					}

					if (dList.size() > 0) {
						// params.put("selectedDeptList", dList);
						sList.addAll(dList);
					}

					mv.addObject("selectedList", sList);
				}

			} else {
				fields = new String[] { "dpSeq", "dpType", "dpName" };
				list = JsonUtil.getJsonToArray(selectUserList, fields);
			}

			/** 선택된 직책 처리 */
			if (type.equals("1") && poList != null && list != null) {
				for (Map<String, Object> poMap : poList) {
					String dpSeq = poMap.get("dpSeq") + "";
					for (Map<String, Object> dpMap : list) {
						String sDpSeq = dpMap.get("dpSeq") + "";
						if (!EgovStringUtil.isEmpty(dpSeq) && !EgovStringUtil.isEmpty(sDpSeq) && dpSeq.equals(sDpSeq)) {
							poMap.put("checked", "checked");
						}
					}
				}
			}

			/** 선택된 직급 처리 */
			else if (type.equals("2") && duList != null && list != null) {
				for (Map<String, Object> duMap : duList) {
					String dpSeq = duMap.get("dpSeq") + "";
					for (Map<String, Object> dpMap : list) {
						String sDpSeq = dpMap.get("dpSeq") + "";
						if (!EgovStringUtil.isEmpty(dpSeq) && !EgovStringUtil.isEmpty(sDpSeq) && dpSeq.equals(sDpSeq)) {
							duMap.put("checked", "checked");
						}
					}
				}
			}
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmOcType2Pop");

		return mv;
	}

	@IncludedInfo(name = "공통 조직도(개인/부서 선택)", order = 174, gid = 60)
	@RequestMapping("/cmm/systemx/cmmOcType1Pop.do")
	public ModelAndView cmmOcType1Pop(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();

		/**
		 * 개발환경에서 이용할 수 있도록 하기위해 mode를 체크한다.
		 */
		String mode = params.get("mode") + "";
		LoginVO loginVO = null;
		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";
		String langCode = params.get("langCode") + "";
		String deptSeq = params.get("deptSeq") + "";
		if (mode.equals("dev")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
			loginVO.setUserSe("USER");
			loginVO.setOrgnztId(params.get("deptSeq") + "");
			params.remove("deptSeq");

		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			deptSeq = loginVO.getOrgnztId();
		}

		params.put("langCode", loginVO.getLangCode());
		params.put("focusSeq", deptSeq);

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		if (EgovStringUtil.isEmpty(compSeq) && !loginVO.getUserSe().equals("MASTER")) {
			params.put("compSeq", loginVO.getCompSeq());
		}

		params.put("useYn", "Y");

		mv = orgChartList(params);

		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);

		Map<String, Object> compParams = new HashMap<String, Object>();
		compParams.put("langCode", loginVO.getLangCode());
		compParams.put("compName", params.get("compName"));
		compParams.put("groupSeq", params.get("groupSeq"));

		mv.addObject("callback", params.get("callback"));

		mv.addObject("compSeq", params.get("compSeq"));

		String moduleType = params.get("moduleType") + "";
		/** 이미 선택된 조직도 체크 */
		String[] fields = null;
		List<Map<String, Object>> list = null;
		String selectedOrgList = params.get("selectedOrgList") + "";
		if (!EgovStringUtil.isEmpty(selectedOrgList)) {
			selectedOrgList = URLDecoder.decode(selectedOrgList, "UTF-8");

			fields = new String[] { "seq", "deptSeq", "gbn" };
			list = JsonUtil.getJsonToArray(selectedOrgList, fields);

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> eList = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> dList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					String gbn = sMap.get("gbn") + "";

					if (!gbn.equals("m")) {
						if (gbn.equals("g")) {
							sMap.put("seqName", sMap.get("groupName"));}
						if (gbn.equals("c")) {
							sMap.put("seqName", sMap.get("compName"));}
						if (gbn.equals("d")) {
							sMap.put("seqName", sMap.get("deptName"));}
						dList.add(sMap);

					} else if (gbn.equals("m")) {
						eList.add(sMap);
					}
				}

				// 사원 리스트는 groupSeq,compSeq 없을수도 있으므로 db에서 조회하여 가져온다..

				if (eList.size() > 0 && (moduleType.equals("e") || moduleType.equals("ed"))) {
					Map<String, Object> eParams = new HashMap<>();
					eParams.put("langCode", params.get("langCode"));
					eParams.put("groupSeq", params.get("groupSeq"));
					eParams.put("selectedEmpList", eList);
					mv.addObject("sOrgEmpListJson", JSONArray.fromObject(orgChartService.getEmpSelectedList(eParams)));
				}

				if (dList.size() > 0) {
					mv.addObject("sOrgDeptListJson", JSONArray.fromObject(dList));
				}
			}
		}

		/** 이미 선택되어진 사원 정보 처리 */
		String selectUserList = params.get("selectedList") + "";

		if (!EgovStringUtil.isEmpty(selectUserList)) {
			selectUserList = URLDecoder.decode(selectUserList, "UTF-8");

			fields = new String[] { "seq", "empName", "compName", "empSeq", "deptSeq", "compSeq", "deptName",
					"groupSeq", "dutyName", "gbn", "groupName", "bizSeq" };
			list = JsonUtil.getJsonToArray(selectUserList, fields);

			List<Map<String, Object>> rList = new ArrayList<Map<String, Object>>();

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> eList = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> dList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					String gbn = sMap.get("gbn") + "";
					if (!gbn.equals("m")) {
						if (gbn.equals("g")) {
							sMap.put("seqName", sMap.get("groupName"));
							sMap.remove("deptName");
						} else if (gbn.equals("c")) {
							sMap.put("seqName", sMap.get("compName"));
							sMap.remove("deptName");
						} else if (gbn.equals("d")) {
							sMap.put("seqName", sMap.get("deptName"));
						}
						dList.add(sMap);
					} else if (gbn.equals("m")) {
						eList.add(sMap);
					}
				}

				if (dList.size() > 0) {
					// params.put("selectedDeptList", dList);
					rList.addAll(dList);
				}
				if (eList.size() > 0 && (moduleType.equals("e") || moduleType.equals("ed"))) {
					Map<String, Object> eParams = new HashMap<>();
					eParams.put("langCode", params.get("langCode"));
					eParams.put("groupSeq", params.get("groupSeq"));
					eParams.put("selectedEmpList", eList);
					rList.addAll(orgChartService.getEmpSelectedList(eParams));
				}
				mv.addObject("selectedList", rList);
			}
		}

		String duplicateOrgList = params.get("duplicateOrgList") + "";
		if (!EgovStringUtil.isEmpty(duplicateOrgList)) {
			duplicateOrgList = URLDecoder.decode(duplicateOrgList, "UTF-8");
			fields = new String[] { "seq", "deptSeq", "gbn" };
			list = JsonUtil.getJsonToArray(duplicateOrgList, fields);

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> eList = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> dList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					String gbn = sMap.get("gbn") + "";
					if (gbn.equals("d")) {
						dList.add(sMap);
					} else if (gbn.equals("m")) {
						eList.add(sMap);
					}
				}

				// 사원 리스트는 groupSeq,compSeq 없을수도 있으므로 db에서 조회하여 가져온다..

				if (eList.size() > 0 && (moduleType.equals("e") || moduleType.equals("ed"))) {
					Map<String, Object> eParams = new HashMap<>();
					eParams.put("langCode", params.get("langCode"));
					eParams.put("groupSeq", params.get("groupSeq"));
					eParams.put("selectedEmpList", eList);
					mv.addObject("dupOrgEmpListJson",
							JSONArray.fromObject(orgChartService.getEmpSelectedList(eParams)));
				}

				if (dList.size() > 0) {
					mv.addObject("dupOrgDeptListJson", JSONArray.fromObject(dList));
				}
			}
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmOcType1Pop");

		return mv;
	}

	@IncludedInfo(name = "공통 조직도(이메일)", order = 175, gid = 60)
	@RequestMapping("/cmm/systemx/cmmOcType3Pop.do")
	public ModelAndView cmmOcType3Pop(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();

		/**
		 * 개발환경에서 이용할 수 있도록 하기위해 mode를 체크한다.
		 */
		String mode = params.get("mode") + "";
		LoginVO loginVO = null;
		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";
		String langCode = params.get("langCode") + "";
		String deptSeq = params.get("deptSeq") + "";
		if (mode.equals("dev")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
			params.remove("deptSeq");
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			deptSeq = loginVO.getOrgnztId();
		}

		params.put("focusSeq", deptSeq);

		params.put("langCode", loginVO.getLangCode());

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}

		params.put("useYn", "Y");

		mv = orgChartList(params);

		mv.addObject("params", params);

		Map<String, Object> compParams = new HashMap<String, Object>();
		compParams.put("langCode", loginVO.getLangCode());
		compParams.put("compName", params.get("compName"));
		compParams.put("groupSeq", params.get("groupSeq"));

		mv.addObject("callback", params.get("callback"));

		mv.addObject("compSeq", params.get("compSeq"));

		String moduleType = params.get("moduleType") + "";
		/** 이미 선택된 조직도 체크 */
		String[] fields = null;
		List<Map<String, Object>> list = null;
		String selectedOrgList = params.get("selectedOrgList") + "";
		if (!EgovStringUtil.isEmpty(selectedOrgList)) {
			selectedOrgList = URLDecoder.decode(selectedOrgList, "UTF-8");

			fields = new String[] { "seq", "deptSeq", "gbn" };
			list = JsonUtil.getJsonToArray(selectedOrgList, fields);

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> eList = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> dList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					String gbn = sMap.get("gbn") + "";
					if (gbn.equals("d")) {
						dList.add(sMap);
					} else if (gbn.equals("m")) {
						eList.add(sMap);
					}
				}

				// 사원 리스트는 groupSeq,compSeq 없을수도 있으므로 db에서 조회하여 가져온다..

				if (eList.size() > 0 && (moduleType.equals("e") || moduleType.equals("ed"))) {
					params.put("selectedEmpList", eList);
					mv.addObject("sOrgEmpListJson", JSONArray.fromObject(orgChartService.getEmpSelectedList(params)));
				}

				if (dList.size() > 0) {
					mv.addObject("sOrgDeptListJson", JSONArray.fromObject(dList));
				}
			}
		}

		/** 이미 선택되어진 사원 정보 처리 */
		String selectUserList = params.get("selectedList") + "";

		if (!EgovStringUtil.isEmpty(selectUserList)) {
			selectUserList = URLDecoder.decode(selectUserList, "UTF-8");

			fields = new String[] { "seq", "empName", "compName", "empSeq", "deptSeq", "compSeq", "deptName",
					"dutyName", "gbn" };
			list = JsonUtil.getJsonToArray(selectUserList, fields);

			List<Map<String, Object>> rList = new ArrayList<Map<String, Object>>();

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> eList = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> dList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					String gbn = sMap.get("gbn") + "";
					if (gbn.equals("d")) {
						dList.add(sMap);
					} else if (gbn.equals("m")) {
						eList.add(sMap);
					}
				}
				if (dList.size() > 0) {
					params.put("selectedDeptList", dList);
					rList.addAll(orgChartService.getDeptSelectedList(params));
				}
				if (eList.size() > 0 && (moduleType.equals("e") || moduleType.equals("ed"))) {
					params.put("selectedEmpList", eList);
					rList.addAll(orgChartService.getEmpSelectedList(params));
				}
				mv.addObject("selectedList", rList);
			}
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmOcType3Pop");

		return mv;
	}

	@RequestMapping("/cmm/systemx/cmmOcType3InnerEmpList.do")
	public ModelAndView cmmOcType3InnerEmpList(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		params.put("workStatus", "999");
		params.put("useYn", "Y");

		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";

		if (EgovStringUtil.isEmpty(groupSeq) || EgovStringUtil.isEmpty(compSeq)) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("compSeq", loginVO.getCompSeq());
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", loginVO.getUserSe());
		}

		if (EgovStringUtil.isEmpty(params.get("userSe") + "")) {
			params.put("userSe", "USER");
		}

		Map<String, Object> listMap = empManageService.selectEmpInfo(params, new PaginationInfo());

		if (listMap != null && listMap.get("list") != null) {
			List<Map<String, Object>> list = (List<Map<String, Object>>) listMap.get("list");

			mv.addObject("empList", list);
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/include/cmmOcType3InnerEmpList");

		return mv;
	}

	@RequestMapping("/cmm/systemx/cmmOcType3PopSearch.do")
	public ModelAndView cmmOcType3PopSearch(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		params.put("workStatus", "999");
		params.put("useYn", "Y");

		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";

		if (EgovStringUtil.isEmpty(groupSeq) || EgovStringUtil.isEmpty(compSeq)) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("compSeq", loginVO.getCompSeq());
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", loginVO.getUserSe());
		}

		if (EgovStringUtil.isEmpty(params.get("userSe") + "")) {
			params.put("userSe", "USER");
		}
		String tabType = params.get("tabType") + "";
		int searchType = CommonUtil.getIntNvl(params.get("searchType") + "");
		switch (searchType) {
		case 1:
			params.put("compORdeptORempORemail", params.get("searchKeyword"));
			break;
		case 2:
			params.put("compNameORdeptName", params.get("searchKeyword"));
			break;
		case 3:
			params.put("empName", params.get("searchKeyword"));
			break;
		case 4:
			params.put("emailAddr", params.get("searchKeyword"));
			break;
		default:break;
		}
		if (tabType.equals("1")) {
			Map<String, Object> listMap = empManageService.selectEmpInfo(params, new PaginationInfo());

			if (listMap != null && listMap.get("list") != null) {
				List<Map<String, Object>> list = (List<Map<String, Object>>) listMap.get("list");

				mv.addObject("empList", list);
			}
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/include/cmmOcType3InnerEmpList");

		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/systemx/cmmOcType4Pop.do")
	public ModelAndView cmmOcType4Pop(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();

		/**
		 * 팩스에서 호출 한 경우 파라미터로 loginVO대체 (mode = ex(외부호출))
		 */
		String mode = params.get("mode") + "";
		LoginVO loginVO = null;
		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";
		String langCode = params.get("langCode") + "";
		if (mode.equals("ex")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("compSeq", loginVO.getCompSeq());
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("deptSeq", loginVO.getOrgnztId());
			params.put("empSeq", loginVO.getUniqId());
			params.put("adminAuth", loginVO.getUserSe());
			params.put("moduleType", "f");
		}

		params.put("langCode", loginVO.getLangCode());

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		// if (EgovStringUtil.isEmpty(compSeq)) {
		// params.put("compSeq", loginVO.getCompSeq());
		// }

		params.put("useYn", "Y");

		mv = orgChartList(params);

		mv.addObject("params", params);

		Map<String, Object> compParams = new HashMap<String, Object>();
		compParams.put("langCode", loginVO.getLangCode());
		compParams.put("compName", params.get("compName"));
		compParams.put("groupSeq", params.get("groupSeq"));

		mv.addObject("callback", params.get("callback"));

		mv.addObject("compSeq", params.get("compSeq"));

		String moduleType = params.get("moduleType") + "";

		String[] fields = null;
		List<Map<String, Object>> list = null;

		/** 이미 선택되어진 주소록 정보 처리 */
		String selectAddrList = params.get("selectedAddrList") + "";

		if (!EgovStringUtil.isEmpty(selectAddrList)) {
			
			params.put("selectedAddrList", selectAddrList);
			List<Map<String, Object>> selectedAddrList = commonSql.list("OrgChart.getSelectedAddrList", params);
			mv.addObject("selectedAddrList", selectedAddrList);
		}

		/** 이미 선택되어진 사원 정보 처리 */
		String selectList = params.get("selectedOrgList") + "";

		if (!EgovStringUtil.isEmpty(selectList)) {
			
			String[] arrOrgList = selectList.split(",");
			
			List<Map<String, Object>> selectedOrgList = new ArrayList<Map<String, Object>>();
			
			for(int i=0;i<arrOrgList.length;i++){
				String[] orgInfo = arrOrgList[i].split("\\|");
				Map<String, Object> mp = new HashMap<String, Object>();
				
				
				mp.put("groupSeq", orgInfo[0]);
				mp.put("compSeq", orgInfo[1]);
				mp.put("deptSeq", orgInfo[2]);
				mp.put("empSeq", orgInfo[3]);

				
				Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("OrgChart.getSelectedOrgList", mp);
				if(empInfo != null) {
					selectedOrgList.add(empInfo);
				}
			}
			
			if(selectedOrgList.size() > 0) {
				mv.addObject("selectedList", selectedOrgList);
			}
			
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmOcType4Pop");

		return mv;
	}

	@RequestMapping("/cmm/systemx/getAddrGroupListNodes.do")
	public void getAddrGroupListNodes(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		String mode = params.get("mode") + "";
		String langCode = params.get("langCode") + "";
		String empSeq = params.get("empSeq") + "";
		String compSeq = params.get("compSeq") + "";
		String deptSeq = params.get("deptSeq") + "";
		String adminAuth = params.get("adminAuth") + "";
		LoginVO loginVO = null;
		if (mode.equals("ex")) {
			loginVO = new LoginVO();
			loginVO.setLangCode(langCode);
			loginVO.setUniqId(empSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setOrgnztId(deptSeq);
			if (adminAuth.equals("USER")) {
				adminAuth = "";
			}
			loginVO.setUserSe(adminAuth);
			params.put("adminAuth", adminAuth);
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		}

		ModelAndView mv = new ModelAndView();

		response.setCharacterEncoding("UTF-8");
		params.put("langCode", loginVO.getLangCode());

		params.put("empSeq", loginVO.getUniqId());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		if (loginVO.getUserSe().equals("ADMIN")) {
			params.put("adminAuth", loginVO.getUserSe());
		}
		
		params.put("useYN", "Y");
		
		List<Map<String, Object>> list = orgChartService.getAddrGroupList(params);

		Map<String, Object> root = new HashMap<String, Object>();

		root.put("group_seq", "");
		root.put("group_nm", BizboxAMessage.getMessage("TX000000862","전체"));

		root.put("hasChildren", false);
		root.put("expanded", true);
		root.put("folder", "rootfolder");
		root.put("setSpriteCssClass", "folder");
		root.put("nodes", list);

		JSONObject json = JSONObject.fromObject(root);
		//크로스사이트 스크립트 (XSS)
		String callback = EgovStringUtil.isNullToString(params.get("callback"));
		
		if (callback != null) {
			  // 외부 입력 내 위험한 문자를 이스케이핑
			callback = callback.replaceAll("<", "&lt;"); 
			callback = callback.replaceAll(">", "&gt;");
		}

		/** jsonp 는 callback(data) 로 넘겨야 한다. */
		response.getWriter().write(callback + "([" + json + "])");
		response.getWriter().flush();
		response.getWriter().close();
	}

	@RequestMapping("/cmm/systemx/getEmpList.do")
	public ModelAndView getEmpList(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		String mode = params.get("mode") + "";
		String langCode = params.get("langCode") + "";

		LoginVO loginVO = null;
		if (mode.equals("ex")) {
			loginVO = new LoginVO();
			loginVO.setLangCode(langCode);
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		}
		ModelAndView mv = new ModelAndView();
		params.put("langCode", loginVO.getLangCode());

		List<Map<String, Object>> list = orgChartService.getEmpList(params);

		mv.addObject("list", list);
		mv.setViewName("jsonView");

		return mv;
	}

	@RequestMapping("/cmm/systemx/getAddrListNodes.do")
	public ModelAndView getAddrListNodes(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		// LoginVO loginVO =
		// (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();

		List<Map<String, Object>> list = orgChartService.getAddrList(params);

		mv.addObject("list", list);
		mv.setViewName("jsonView");

		return mv;
	}

	@RequestMapping("/cmm/systemx/cmmOcType5Pop.do")
	public ModelAndView cmmOcType5Pop(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();

		/**
		 * 개발환경에서 이용할 수 있도록 하기위해 mode를 체크한다.
		 */
		String mode = params.get("mode") + "";
		LoginVO loginVO = null;
		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";
		String langCode = params.get("langCode") + "";
		if (mode.equals("dev")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		}

		params.put("langCode", loginVO.getLangCode());

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}

		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}

		params.put("useYn", "Y");

		mv = orgChartList(params);

		mv.addObject("params", params);

		String[] fields = null;
		List<Map<String, Object>> list = null;

		/** 이미 선택되어진 주소록 정보 처리(받는사람) */
		String selectRecList = params.get("selectedRecList") + "";

		if (!EgovStringUtil.isEmpty(selectRecList)) {
			selectRecList = URLDecoder.decode(selectRecList, "UTF-8");

			fields = new String[] { "dept_seq", "comp_seq", "emp_seq", "group_seq", "addr_seq", "group_nm", "addr_nm",
					"comp_nm", "dept_nm", "emp_nm", "fax_num", "tel_num", "e_mail", "type" };
			list = JsonUtil.getJsonToArray(selectRecList, fields);

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> sList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					sList.add(sMap);
				}
				if (sList.size() > 0) {
					mv.addObject("selectedRecList", JSONArray.fromObject(sList));
				}
			}
		}

		/** 이미 선택되어진 주소록 정보 처리(참조) */
		String selectRefList = params.get("selectedRefList") + "";

		if (!EgovStringUtil.isEmpty(selectRefList)) {
			selectRefList = URLDecoder.decode(selectRefList, "UTF-8");

			fields = new String[] { "dept_seq", "comp_seq", "emp_seq", "group_seq", "addr_seq", "group_nm", "addr_nm",
					"comp_nm", "dept_nm", "emp_nm", "fax_num", "tel_num", "e_mail", "type" };
			list = JsonUtil.getJsonToArray(selectRefList, fields);

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> sList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					sList.add(sMap);
				}
				if (sList.size() > 0) {
					mv.addObject("selectedRefList", JSONArray.fromObject(sList));
				}
			}
		}

		/** 이미 선택되어진 주소록 정보 처리(숨은참조) */
		String selectHidRefList = params.get("selectedRecList") + "";

		if (!EgovStringUtil.isEmpty(selectHidRefList)) {
			selectHidRefList = URLDecoder.decode(selectHidRefList, "UTF-8");

			fields = new String[] { "dept_seq", "comp_seq", "emp_seq", "group_seq", "addr_seq", "group_nm", "addr_nm",
					"comp_nm", "dept_nm", "emp_nm", "fax_num", "tel_num", "e_mail", "type" };
			list = JsonUtil.getJsonToArray(selectHidRefList, fields);

			if (list != null && list.size() > 0) {
				List<Map<String, Object>> sList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> sMap : list) {
					sList.add(sMap);
				}
				if (sList.size() > 0) {
					mv.addObject("selectedHidRefList", JSONArray.fromObject(sList));
				}
			}
		}

		mv.setViewName("/neos/cmm/systemx/orgchart/pop/cmmOcType5Pop");

		return mv;
	}

	/** 조직도 전체 프로필 (그룹웨어 하단) */
	@RequestMapping("/cmm/systemx/orgChartAllEmpInfo.do")
	public ModelAndView orgChartAllEmpInfo(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		mv.addObject("groupSeq", loginVO.getGroupSeq());
		mv.addObject("empSeq", loginVO.getUniqId());
		mv.addObject("deptSeq", loginVO.getOrgnztId());
		mv.addObject("compSeq", loginVO.getCompSeq());
		mv.addObject("langCode", loginVO.getLangCode());
		
		//조직도 엑셀다운로드 옵션체크
		params.put("optionId", "cm000");
		params.put("compSeq", loginVO.getCompSeq());
		String cmmOptionValue = (String) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
		
		//프로필 생년월일 표시 설정 옵션체크
		params.put("optionId", "cm2200");
		params.put("compSeq", loginVO.getCompSeq());
		String sCm2200 = (String) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
		mv.addObject("sCm2200", sCm2200);
		
		/* 엑셀 다운로드 권한 점검 */
		String licenseCheckYN = FormatUtil.getString( loginVO.getLicenseCheckYn( ) );
		String userSe = FormatUtil.getString( loginVO.getUserSe() );
		cmmOptionValue = FormatUtil.getString( cmmOptionValue );
		
		String excelDownYN = "N";
		
		if(!licenseCheckYN.equals( "2" )){
			if(cmmOptionValue.equals("3")){
				excelDownYN = "Y";
			}
			else if((cmmOptionValue.equals("2") && !userSe.equals("USER"))){
				excelDownYN = "Y";
			} else if((cmmOptionValue.equals("1") && userSe.equals("MASTER"))){
				excelDownYN = "Y";
			}
		}
		
		mv.addObject( "excelDownYn",  excelDownYN);
		
		mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartAllEmpInfoPop");
		return mv;
	}

	/** 부서 유저 정보 가져오기 */
	@RequestMapping("/cmm/systemx/userProfileInfo.do")
	public ModelAndView userPorfileInfo(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		String mode = params.get("mode") + "";

		LoginVO loginVO = null;
		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";
		String langCode = params.get("langCode") + "";
		String empSeq = params.get("empSeq") + "";
		int depth = EgovStringUtil.zeroConvert(params.get("depth"));
		
		if (depth > Integer.MAX_VALUE || depth < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
	        throw new IllegalArgumentException("out of bound");
	    }

		if (mode.equals("dev")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
			loginVO.setUserSe("USER");
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		}

		if (EgovStringUtil.isEmpty(langCode)) {
			params.put("groupSeq", loginVO.getLangCode());
		}
		
		if (EgovStringUtil.isEmpty(params.get("userSe") + "")) {
			params.put("userSe", "USER");
		}

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		params.put("orderFlag", 1);
		params.put("flagMainDeptYn", "N");
		params.put("existMaster", "N");
		params.put("workStatus", "999");
		params.put("useYn", "Y");
		params.put("liteYn", "Y");
		params.put("depth", depth + 1);
		
		if(params.get("searchSelect") != null) {
			String selectBox = params.get("searchSelect").toString();
			
			if(selectBox.equals("empNmSearch")) {
				params.put("nameAndLoginId", params.get("searchContent"));
			} else if(selectBox.equals("deptNmSearch")) {
				params.put("deptName", params.get("searchContent"));
			} else if(selectBox.equals("positionNmSearch")) {
				params.put("positionName", params.get("searchContent"));
			} else if(selectBox.equals("dutyNmSearch")) {
				params.put("dutyName", params.get("searchContent"));
			} else if(selectBox.equals("telNoSearch")) {
				params.put("telNo", params.get("searchContent"));
			} else if(selectBox.equals("mobileSearch")) {
				params.put("mobileNo", params.get("searchContent"));
			}
		}

		mv.addAllObjects(empManageService.selectEmpInfo(params, new PaginationInfo()));

		mv.setViewName("jsonView");

		return mv;

	}
	
	/** 부서 유저 정보 가져오기 */
	@RequestMapping("/cmm/systemx/userProfileInfoListNew.do")
	public ModelAndView userProfileInfoListNew(@RequestParam Map<String, Object> params, HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		String mode = params.get("mode") + "";

		LoginVO loginVO = null;
		String compSeq = params.get("compSeq") + "";
		String groupSeq = params.get("groupSeq") + "";
		String langCode = params.get("langCode") + "";
		String empSeq = params.get("empSeq") + "";
		int depth = EgovStringUtil.zeroConvert(params.get("depth"));
				
		if (depth > Integer.MAX_VALUE || depth < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
	        throw new IllegalArgumentException("out of bound");
	    }

		if (mode.equals("dev")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
			loginVO.setUserSe("USER");
		} else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		}
		params.put("langCode", loginVO.getLangCode());

		if (EgovStringUtil.isEmpty(params.get("userSe") + "")) {
			params.put("userSe", "USER");
		}

		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		params.put("orderFlag", 1);
		params.put("flagMainDeptYn", "N");
		params.put("existMaster", "N");
		params.put("workStatus", "999");
		params.put("useYn", "Y");
		params.put("liteYn", "Y");
		params.put("depth", depth + 1);
		
		params.put("grouppingFlag", "Y");
		
		if(!loginVO.getUserSe().equals("MASTER")) {
			params.put("targetEmpSeq", loginVO.getUniqId());
		}
		
		if(params.get("searchSelect") != null) {
			String selectBox = params.get("searchSelect").toString();
			
			if(selectBox.equals("empNmSearch")) {
				params.put("nameAndLoginId", params.get("searchContent"));
			} else if(selectBox.equals("deptNmSearch")) {
				params.put("deptName", params.get("searchContent"));
			} else if(selectBox.equals("positionNmSearch")) {
				params.put("positionName", params.get("searchContent"));
			} else if(selectBox.equals("dutyNmSearch")) {
				params.put("dutyName", params.get("searchContent"));
			} else if(selectBox.equals("telNoSearch")) {
				params.put("telNo", params.get("searchContent"));
			} else if(selectBox.equals("mobileSearch")) {
				params.put("mobileNo", params.get("searchContent"));
			}
		}

		mv.addObject("list", empManageService.selectEmpInfoListNew(params));

		mv.setViewName("jsonView");

		return mv;

	}
	
	

	/**
	 * 사용자, 부서 선택 공통 팝업. - 가칭. 최초 작성 : 2016-06-21 작성자 : 최 상배 비고 :
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@IncludedInfo(name = "사용자, 부서 선택 공통 팝업 [5.0]", order = 350, gid = 60)
	@RequestMapping("/systemx/orgChart.do")
	public ModelAndView orgChartListVer5(@RequestParam Map<String, Object> params, HttpServletResponse response, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO v = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		String checkUrl1 = request.getScheme()+"://"+request.getServerName() + "/eap/";
		String checkUrl2 = request.getScheme()+"://"+request.getServerName() + "/ea/";	
		String refererUrl = request.getHeader("referer");

		if(refererUrl.indexOf(checkUrl1) != -1 || refererUrl.indexOf(checkUrl2) != -1){
			params.put("eaYn", "Y");
		}		

		if (params.get("langCode") == null) {
			params.put("langCode", v.getLangCode());
		}
		if (EgovStringUtil.isEmpty(params.get("langCode").toString())) {
			params.put("langCode", v.getLangCode());
		}

		if (params.get("groupSeq") == null) {
			params.put("groupSeq", v.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("groupSeq").toString())) {
			params.put("groupSeq", v.getGroupSeq());
		}

		if (params.get("compSeq") == null) {
			params.put("compSeq", v.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("compSeq").toString())) {
			params.put("compSeq", v.getCompSeq());
		}

		if (params.get("deptSeq") == null) {
			params.put("deptSeq", v.getOrgnztId());
		}
		if (EgovStringUtil.isEmpty(params.get("deptSeq").toString())) {
			params.put("deptSeq", v.getOrgnztId());
		}

		if (params.get("empSeq") == null) {
			params.put("empSeq", v.getUniqId());
		}
		if (EgovStringUtil.isEmpty(params.get("empSeq").toString())) {
			params.put("empSeq", v.getUniqId());
		}

		if (params.get("selectMode") == null) {
			params.put("selectMode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectMode").toString())) {
			params.put("selectMode", "");
		}

		if (params.get("selectItem") == null) {
			params.put("selectItem", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectItem").toString())) {
			params.put("selectItem", "");
		}
		
		if (params.get("selectMainTitle") == null) {
			params.put("selectMainTitle", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectMainTitle").toString())) {
			params.put("selectMainTitle", "");
		}

		if (params.get("selectedItems") == null) {
			params.put("selectedItems", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems").toString())) {
			params.put("selectedItems", "");
		}
		
		if (params.get("selectedItems1") == null) {
			params.put("selectedItems1", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems1").toString())) {
			params.put("selectedItems1", "");
		}
		
		if (params.get("selectedItems2") == null) {
			params.put("selectedItems2", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems2").toString())) {
			params.put("selectedItems2", "");
		}		
		
		if (params.get("compFilter") == null) {
			params.put("compFilter", "");
		}
		if (EgovStringUtil.isEmpty(params.get("compFilter").toString())) {
			params.put("compFilter", "");
		}
		if (params.get("nodeChangeEvent") == null) {
			params.put("nodeChangeEvent", "");
		}
		if (EgovStringUtil.isEmpty(params.get("nodeChangeEvent").toString())) {
			params.put("nodeChangeEvent", "");
		}
		if (params.get("callbackParam") == null) {
			params.put("callbackParam", "");
		}		
		if (EgovStringUtil.isEmpty(params.get("callbackParam").toString())) {
			params.put("callbackParam", "");
		}
		
		if (params.get("callback") == null) {
			params.put("callback", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callback").toString())) {
			params.put("callback", "");
		}
		if (params.get("callbackUrl") == null) {
			params.put("callbackUrl", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callbackUrl").toString())) {
			params.put("callbackUrl", "");
		}
		if (params.get("initMode") == null) {
			params.put("initMode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("initMode").toString())) {
			params.put("initMode", "");
		}
		
		if (params.get("noUseDefaultNodeInfo") == null) {
			params.put("noUseDefaultNodeInfo", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseDefaultNodeInfo").toString())) {
			params.put("noUseDefaultNodeInfo", "");
		}
		
		if (params.get("includeDeptCode") == null) {
			params.put("includeDeptCode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("includeDeptCode").toString())) {
			params.put("includeDeptCode", "");
		}
		
		if (params.get("noUseCompSelect") == null) {
			params.put("noUseCompSelect", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseCompSelect").toString())) {
			params.put("noUseCompSelect", "");
		}
		
		if (params.get("noUseDeleteBtn") == null) {
			params.put("noUseDeleteBtn", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseDeleteBtn").toString())) {
			params.put("noUseDeleteBtn", "");
		}
		
		if (params.get("isAllDeptEmpShow") == null) {
			params.put("isAllDeptEmpShow", "true");
		}
		if (EgovStringUtil.isEmpty(params.get("isAllDeptEmpShow").toString())) {
			params.put("isAllDeptEmpShow", "true");
		}
		
		if (params.get("isDuplicate") == null || !params.get("isDuplicate").equals("false")) {
			params.put("isDuplicate", "");
		}else{
			params.put("isDuplicate", "true");
		}
		
		if (params.get("extendSelectAreaCount") == null) {
			params.put("extendSelectAreaCount", "1");
		}
		if (EgovStringUtil.isEmpty(params.get("extendSelectAreaCount").toString())) {
			params.put("extendSelectAreaCount", "1");
		}
		
		if (params.get("extendSelectAreaInfo") == null) {
			params.put("extendSelectAreaInfo", "");
		}
		if (EgovStringUtil.isEmpty(params.get("extendSelectAreaInfo").toString())) {
			params.put("extendSelectAreaInfo", "");
		}
		
		if (params.get("noUseExtendArea") == null) {
			params.put("noUseExtendArea", "true");
		}
		if (EgovStringUtil.isEmpty(params.get("extendSelectAreaInfo").toString())) {
			params.put("extendSelectAreaInfo", "true");
		}
		
		if (params.get("isAllCompShow") == null) {
			params.put("isAllCompShow", "false");
		}
		if (EgovStringUtil.isEmpty(params.get("isAllCompShow").toString())) {
			params.put("isAllCompShow", "false");
		}
		if (params.get("innerReceiveFlag") == null) {
			params.put("innerReceiveFlag", "");
		}else{
			params.put("eaYn", "Y");
		}
		if (params.get("eaYn") == null) {
			params.put("eaYn", "");
		}
		if (params.get("authPopYn") == null) {
			params.put("authPopYn", "");
		}
		
		if (params.get("exMyinfoYn") == null) {
			params.put("exMyinfoYn", "");
		}

		if (params.get("targetDeptSeq") == null) {
			params.put("targetDeptSeq", "");
		}
		
		//조직도 트리오픈 뎁스 설정값 조회
		params.put("orgOpenDepth", commonOptionManageService.getCommonOptionValue(params.get("groupSeq").toString(), params.get("compSeq").toString(), "cm600"));
		
		String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(params.get("groupSeq").toString(), params.get("compSeq").toString(), "cm1900");
		String displayPositionDuty = "";
		
		if(positionDutyOptionValue == null) {
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("0")){
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("1")) {
			displayPositionDuty = "duty";
		}

		params.put("displayPositionDuty", displayPositionDuty);
		
		if(params.get("noUseExtendArea").toString().equals("false")) {
			mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartBucketPopExtend");
		} else {
			mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartBucketPop");
		}		
		
		//사용자 겸직 미사용 팝업의 경우
		if(params.get("empUniqYn") != null && params.get("empUniqYn").equals("Y") && (params.get("selectMode").equals("u") || params.get("selectMode").equals("ud"))){
			
			mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartEmpUniqBucketPop");
			
			//공통조직도팝업 그룹설정 사용
			if(params.get("empUniqGroup") != null && !params.get("empUniqGroup").equals("")){
				
				if(params.get("empUniqGroup").equals("ALL")){
					params.putAll((Map<String, Object>) commonSql.select("OrgChart.getAllCompArray", params));						
				}else{
					//그룹설정값이 있을경우					
					String[] empUniqGroup = params.get("empUniqGroup").toString().split("\\|");
					
					if(empUniqGroup.length > 1){
						if(empUniqGroup[0].equals("G")){
							params.put("grouppingSeq", empUniqGroup[1]);
							params.putAll((Map<String, Object>) commonSql.select("OrgChart.getGrouppingCompArray", params));
						}else{
							params.put("grouppingCompSeq", empUniqGroup[1]);
							params.put("compFilter", empUniqGroup[1]);
							
							String empUniqGroupName = (String) commonSql.select("OrgChart.getGrouppingName", params);
							
							if(empUniqGroupName == null){
								empUniqGroupName = "";
							}
							
							params.put("empUniqGroupName", empUniqGroupName);							
						}
					}						
				}
				
			}else{
				
				String allCompCnt = (String) commonSql.select("OrgChart.getAllCompCnt", params);
				
				//단일회사일 경우 그룹선택 없
				if(allCompCnt.equals("1")) {
					params.put("grouppingCompSeq", v.getCompSeq());
					params.put("compFilter", v.getCompSeq());
					params.put("empUniqGroupName", v.getOrganNm());
					params.put("empUniqGroup", "C|" + v.getCompSeq());					
				}else {
					//그룹설정값이 없을경우 그룹선택
					params.put("userSe", v.getUserSe());
					params.put("loginCompSeq", v.getCompSeq());
					
					@SuppressWarnings("unchecked")
					List<Map<String, Object>> grouppingCompList = commonSql.list("OrgChart.getGrouppingCompList", params);
					
					mv.addObject("grouppingCompList", JSONArray.fromObject(grouppingCompList));
					params.put("empUniqGroupSet", "Y");						
				}
			}				
		}

		mv.addObject("params", params);
		mv.addObject("displayPositionDuty", displayPositionDuty);
		
		return mv;
	}
	
	/**
	 * 사용자, 부서 선택 공통 팝업. - 가칭. 최초 작성 : 2017-07-26 작성자 : 박근우 비고 : 근태사용자만 표시 attend에서 전용 사용
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "사용자, 부서 선택 공통 팝업 [5.0]", order = 350, gid = 60)
	@RequestMapping("/systemx/orgChartAttend.do")
	public ModelAndView orgChartListVerAttend(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO v = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (params.get("langCode") == null) {
			params.put("langCode", v.getLangCode());
		}
		if (EgovStringUtil.isEmpty(params.get("langCode").toString())) {
			params.put("langCode", v.getLangCode());
		}

		if (params.get("groupSeq") == null) {
			params.put("groupSeq", v.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("groupSeq").toString())) {
			params.put("groupSeq", v.getGroupSeq());
		}

		if (params.get("compSeq") == null) {
			params.put("compSeq", v.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("compSeq").toString())) {
			params.put("compSeq", v.getCompSeq());
		}

		if (params.get("deptSeq") == null) {
			params.put("deptSeq", v.getOrgnztId());
		}
		if (EgovStringUtil.isEmpty(params.get("deptSeq").toString())) {
			params.put("deptSeq", v.getOrgnztId());
		}

		if (params.get("empSeq") == null) {
			params.put("empSeq", v.getUniqId());
		}
		if (EgovStringUtil.isEmpty(params.get("empSeq").toString())) {
			params.put("empSeq", v.getUniqId());
		}

		if (params.get("selectMode") == null) {
			params.put("selectMode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectMode").toString())) {
			params.put("selectMode", "");
		}

		if (params.get("selectItem") == null) {
			params.put("selectItem", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectItem").toString())) {
			params.put("selectItem", "");
		}
		
		if (params.get("selectMainTitle") == null) {
			params.put("selectMainTitle", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectMainTitle").toString())) {
			params.put("selectMainTitle", "");
		}

		if (params.get("selectedItems") == null) {
			params.put("selectedItems", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems").toString())) {
			params.put("selectedItems", "");
		}
		
		if (params.get("selectedItems1") == null) {
			params.put("selectedItems1", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems1").toString())) {
			params.put("selectedItems1", "");
		}
		
		if (params.get("selectedItems2") == null) {
			params.put("selectedItems2", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems2").toString())) {
			params.put("selectedItems2", "");
		}		
		
		if (params.get("compFilter") == null) {
			params.put("compFilter", "");
		}
		if (EgovStringUtil.isEmpty(params.get("compFilter").toString())) {
			params.put("compFilter", "");
		}
		if (params.get("nodeChangeEvent") == null) {
			params.put("nodeChangeEvent", "");
		}
		if (EgovStringUtil.isEmpty(params.get("nodeChangeEvent").toString())) {
			params.put("nodeChangeEvent", "");
		}
		if (params.get("callbackParam") == null) {
			params.put("callbackParam", "");
		}		
		if (EgovStringUtil.isEmpty(params.get("callbackParam").toString())) {
			params.put("callbackParam", "");
		}
		
		if (params.get("callback") == null) {
			params.put("callback", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callback").toString())) {
			params.put("callback", "");
		}
		if (params.get("callbackUrl") == null) {
			params.put("callbackUrl", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callbackUrl").toString())) {
			params.put("callbackUrl", "");
		}
		if (params.get("initMode") == null) {
			params.put("initMode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("initMode").toString())) {
			params.put("initMode", "");
		}
		
		if (params.get("noUseDefaultNodeInfo") == null) {
			params.put("noUseDefaultNodeInfo", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseDefaultNodeInfo").toString())) {
			params.put("noUseDefaultNodeInfo", "");
		}
		
		if (params.get("includeDeptCode") == null) {
			params.put("includeDeptCode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("includeDeptCode").toString())) {
			params.put("includeDeptCode", "");
		}
		
		if (params.get("noUseCompSelect") == null) {
			params.put("noUseCompSelect", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseCompSelect").toString())) {
			params.put("noUseCompSelect", "");
		}
		
		if (params.get("noUseDeleteBtn") == null) {
			params.put("noUseDeleteBtn", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseDeleteBtn").toString())) {
			params.put("noUseDeleteBtn", "");
		}
		
		if (params.get("isAllDeptEmpShow") == null) {
			params.put("isAllDeptEmpShow", "true");
		}
		if (EgovStringUtil.isEmpty(params.get("isAllDeptEmpShow").toString())) {
			params.put("isAllDeptEmpShow", "true");
		}
		
		if (params.get("isDuplicate") == null || !params.get("isDuplicate").equals("false")) {
			params.put("isDuplicate", "");
		}else{
			params.put("isDuplicate", "true");
		}
		
		if (params.get("extendSelectAreaCount") == null) {
			params.put("extendSelectAreaCount", "1");
		}
		if (EgovStringUtil.isEmpty(params.get("extendSelectAreaCount").toString())) {
			params.put("extendSelectAreaCount", "1");
		}
		
		if (params.get("extendSelectAreaInfo") == null) {
			params.put("extendSelectAreaInfo", "");
		}
		if (EgovStringUtil.isEmpty(params.get("extendSelectAreaInfo").toString())) {
			params.put("extendSelectAreaInfo", "");
		}
		
		if (params.get("noUseExtendArea") == null) {
			params.put("noUseExtendArea", "true");
		}
		if (EgovStringUtil.isEmpty(params.get("extendSelectAreaInfo").toString())) {
			params.put("extendSelectAreaInfo", "true");
		}
		
		if (params.get("isAllCompShow") == null) {
			params.put("isAllCompShow", "false");
		}
		if (EgovStringUtil.isEmpty(params.get("isAllCompShow").toString())) {
			params.put("isAllCompShow", "false");
		}
		if (params.get("eaYn") == null) {
			params.put("eaYn", "");
		}
		if (params.get("authPopYn") == null) {
			params.put("authPopYn", "");
		}
		
		/* 2017.05.29 장지훈 추가 (직급/직책 옵션값 추가)
		 * positionDutyOptionValue = 0 : 직급 (default)
		 * positionDutyOptionValue = 1 : 직책
		 * */
		String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(params.get("groupSeq").toString(), params.get("compSeq").toString(), "cm1900");
		String displayPositionDuty = "";
		
		//조직도 트리오픈 뎁스 설정값 조회
		params.put("orgOpenDepth", commonOptionManageService.getCommonOptionValue(params.get("groupSeq").toString(), params.get("compSeq").toString(), "cm600"));
		
		if(positionDutyOptionValue == null) {
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("0")){
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("1")) {
			displayPositionDuty = "duty";
		}

		params.put("displayPositionDuty", displayPositionDuty);
		mv.addObject("params", params);
		mv.addObject("displayPositionDuty", displayPositionDuty);
		if(params.get("noUseExtendArea").toString().equals("false")) {
			mv.setViewName("/neos/cmm/systemx/orgchartAttend/pop/orgChartBucketPopExtend");
		} else {
			mv.setViewName("/neos/cmm/systemx/orgchartAttend/pop/orgChartBucketPop");
		}
		
		return mv;
	}

	/**
	 * 사용자, 부서 선택 공통 팝업 테스트 메뉴. - 가칭. 최초 작성 : 2016-06-21 작성자 : 최 상배 비고 :
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "사용자, 부서 선택 공통 팝업 테스트 메뉴", order = 351, gid = 60)
	@RequestMapping("/systemx/orgChartTest.do")
	public ModelAndView orgChartListVer5Test(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartBucketPopTestPage");
		return mv;
	}

	/**
	 * 
	 * 열람을 원하는 부서의 소속된 사원, 부서의 정보를 가져온다.
	 * 
	 * @param params
	 * @param response
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/GetUserDeptProfileListForDept.do")
	public ModelAndView GetUserDeptProfileListForDept(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		if(params.get("compFilter") != null && !params.get("compFilter").equals("")){
			String compFilter = params.get("compFilter").toString().replace("'", "");
			String[] comps = compFilter.split(",");
			compFilter = "";
			for(int i = 0; i < comps.length; i++){
				compFilter += ",'" + comps[i] + "'";
			}
			compFilter = compFilter.substring(1);
			params.put("compFilter", compFilter);
		}
		
		mv.addObject("returnObj", orgChartService.GetUserDeptProfileListForDept(params));
		return mv;
	}
	
	/**
	 * 
	 * 열람을 원하는 부서의 소속된 사원, 부서의 정보를 가져온다.(Attend용)
	 * 
	 * @param params
	 * @param response
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/GetUserDeptProfileListForDeptAttend.do")
	public ModelAndView GetUserDeptProfileListForDeptAttend(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("returnObj", orgChartService.GetUserDeptProfileListForDeptAttend(params));
		return mv;
	}

	/**
	 * 
	 * 검색을 통하여 원하는 부서의 소속된 사원, 부서의 정보를 가져온다.
	 * 
	 * @param params
	 * @param response
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/GetFilterdUserDeptProfileListForDept.do")
	public ModelAndView GetFilterdUserDeptProfileListForDept(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		if(params.get("compFilter") != null && !params.get("compFilter").equals("")){
			String compFilter = params.get("compFilter").toString().replace("'", "");
			String[] comps = compFilter.split(",");
			compFilter = "";
			for(int i = 0; i < comps.length; i++){
				compFilter += ",'" + comps[i] + "'";
			}
			compFilter = compFilter.substring(1);
			params.put("compFilter", compFilter);
		}
		
		mv.addObject("returnObj", orgChartService.GetFilterdUserDeptProfileListForDept(params));
		return mv;
	}

    /**
     * 
     * 검색을 통하여 원하는 부서의 소속된 사원, 부서의 정보를 가져온다.(Attend용)
     * 
     * @param params
     * @param response
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/cmm/systemx/GetFilterdUserDeptProfileListForDeptAttend.do")
    public ModelAndView GetFilterdUserDeptProfileListForDeptAttend(@RequestParam Map<String, Object> params,
            HttpServletResponse response, HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        
        if(params.get("compFilter") != null && !params.get("compFilter").equals("")){
            String compFilter = params.get("compFilter").toString().replace("'", "");
            String[] comps = compFilter.split(",");
            compFilter = "";
            for(int i = 0; i < comps.length; i++){
                compFilter += ",'" + comps[i] + "'";
            }
            compFilter = compFilter.substring(1);
            params.put("compFilter", compFilter);
        }
        
        mv.addObject("returnObj", orgChartService.GetFilterdUserDeptProfileListForDeptAttend(params));
        return mv;
    }
    
	/**
	 * 
	 * 파라미터로 넘어온 부서의 소속된 사원, 부서의 정보를 가져온다.
	 * 
	 * @param params
	 * @param response
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/GetSelectedUserDeptProfileListForDept.do")
	public ModelAndView GetSelectedUserDeptProfileListForDept(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		if(params.get("compFilter") != null && !params.get("compFilter").equals("")){
			
			String compFilter = params.get("compFilter").toString().replace("'", "");
			String[] comps = compFilter.split(",");
			compFilter = "";
			for(int i = 0; i < comps.length; i++){
				compFilter += ",'" + comps[i] + "'";
			}
			compFilter = compFilter.substring(1);
			params.put("compFilter", compFilter);
		}else {
			params.put("compFilter", "\"\"");
		}
		
		mv.addObject("returnObj", orgChartService.GetSelectedUserDeptProfileListForDept(params));
		return mv;
	}

	/**
	 * VER. 5.0 조직도 트리 불러오기
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/cmm/systemx/orgChartListJsTreeView.do")
	public Object orgChartListJsTreeView(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		if (params.get("langCode") == null || params.get("groupSeq") == null) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("deptSeq", loginVO.getOrgnztId());
		}
		if (params.containsKey("str")) {
			params.put("parentSeq", 0);
			params.put("deptSeq", params.get("str"));
		}

		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		params.put("groupName", groupMap.get("groupName"));

		/** 조직도 조회 */
		List<Map<String, Object>> list = orgChartService.GetUserDeptList(params);

		/** 트리 구조로 변환 */
		List<Map<String, Object>> tree = orgChartService.GetUserDeptListJSTree(list, params);
		JSONArray json = JSONArray.fromObject(tree);

		mv.addObject(json);
		mv.setViewName("jsonView");

		return json;
	}

	/**
	 * VER. 5.0 조직도 전체 데이터 트리 불러오기
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/cmm/systemx/orgChartFullListView.do")
	public Object orgChartFullListView(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (params.get("langCode") == null || params.get("langCode").equals("")) {
			params.put("langCode", loginVO.getLangCode());
		}
		
		if (params.get("groupSeq") == null || params.get("groupSeq").equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		if (params.get("deptSeq") == null || params.get("deptSeq").equals("")) {
			params.put("deptSeq", loginVO.getOrgnztId());
		}
		
		if (params.get("compSeq") != null && !params.get("compSeq").equals("")) {
			params.put("depthOption", commonOptionManageService.getCommonOptionValue(params.get("groupSeq") + "", params.get("compSeq").toString(), "cm600"));
		}else {
			params.put("depthOption", commonOptionManageService.getCommonOptionValue(params.get("groupSeq") + "", loginVO.getCompSeq(), "cm600"));	
		}
		
		if(params.get("partYn") != null && params.get("partYn").equals("Y") && params.get("parentSeq") != null && !params.get("parentSeq").equals("") && !params.get("parentSeq").equals("0")) {
			
			String parentSeq = params.get("parentSeq").toString();
			
			String parentDiv = parentSeq.substring(0, 1);
			parentSeq = parentSeq.substring(1);
		
			params.put("gbnOrg", parentDiv);
			params.put("seq", parentSeq);
			
			String parentDeptPath = orgChartService.GetOrgMyDeptPath(params);
			
			params.put("parentDeptPath", parentDeptPath);
			params.put("parentDeptLevel", parentDeptPath.split("\\|").length + 2);
			
			params.put("parentDiv", parentDiv);
			params.put("parentSeq", parentSeq);
			
		}else {
			params.put("deptPath", orgChartService.GetOrgMyDeptPath(params));
			
			if(loginVO == null){
				params.put("userSe", "user");
			}else{
				params.put("userSe", loginVO.getUserSe());	
			}
			
			if(params.get("isAllCompShow").toString( ).equals( "true" ) || params.get("userSe").equals("MASTER")) {
				params.put("userSe", "MASTER");
			} else {
				params.put("userSe", "user");
			}
			
			if(params.get("compFilter") != null && !params.get("compFilter").equals("")){
				String compFilter = params.get("compFilter").toString().replace("'", "");
				String[] comps = compFilter.split(",");
				compFilter = "";
				for(int i = 0; i < comps.length; i++){
					compFilter += ",'" + comps[i] + "'";
				}
				compFilter = compFilter.substring(1);
				params.put("compFilter", compFilter);
			}
		}

		// * 여기부터.
		List<Map<String, Object>> tree = orgChartService.GetOrgFullList(params);
		mv.setViewName("jsonView");
		
		return tree;
	}

	/**
	 * VER. 5.0 조직도 트리 불러오기
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/cmm/systemx/orgChartListJsTreeViewSearch.do")
	public Object orgChartListJsTreeViewSearch(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		ArrayList<String> l = new ArrayList<>();

		l.add("4101");
		l.add("4102");
		l.add("4103");
		l.add("4104");
		JSONArray json = JSONArray.fromObject(l);
		mv.addObject(json);
		mv.setViewName("jsonView");

		return json;
	}

	@ResponseBody
	@RequestMapping("/cmm/systemx/orgChartListJsTreeViewOc.do")
	public Object orgChartListJsTreeViewOc(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		// if (params.get("langCode") == null || params.get("groupSeq") == null)
		// {
		// LoginVO loginVO = (LoginVO)
		// EgovUserDetailsHelper.getAuthenticatedUser();
		// params.put("langCode", loginVO.getLangCode());
		// params.put("groupSeq", loginVO.getGroupSeq());
		// params.put("deptSeq", loginVO.getOrgnztId());
		// }
		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		params.put("groupName", groupMap.get("groupName"));

		/** 조직도 조회 */
		// 급하게 만들게되서 기존 소스 그대로 사용하여 봐꿔야됨 //(getCompList서비스 sql쿼리 둘다)
		List<Map<String, Object>> list = orgChartService.getCompList(params);
		JSONArray json = JSONArray.fromObject(list);

		/** 트리 구조로 변환 */
		// List<Map<String, Object>> tree =
		// orgChartService.GetUserDeptListJSTree(list, params);
		// JSONArray json = JSONArray.fromObject(tree);

		mv.addObject(json);
		mv.setViewName("jsonView");

		return json;
	}

	@RequestMapping("/cmm/systemx/getUserInfo.do")
	public ModelAndView userInfo(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			if (params.get("langCode") == null || params.get("groupSeq") == null) {
				LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
				params.put("langCode", loginVO.getLangCode());
				params.put("groupSeq", loginVO.getGroupSeq());
			}

			result = empManageService.selectEmpInfo(params, new PaginationInfo());

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		mv.setViewName("jsonView");
		mv.addObject("result", result);
		return mv;
	}

	/**
	 * 사용자, 부서 선택 공통 팝업. - 가칭. 최초 작성 : 2016-06-21 작성자 : 최 상배 비고 :
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "사용자, 부서 선택 공통 트리 뷰[5.0]", order = 352, gid = 60)
	@RequestMapping("/systemx/orgChartTreeView.do")
	public ModelAndView orgChartTreeViewVer5(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO v = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartTreeCrossDomain");
		return mv;
	}
	
	
	
	/**
	 * 사용자정보 엑셀 다운로드
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/userInfoExcelExport.do")
	public void userInfoExcelExport(@RequestParam Map<String, Object> params, HttpServletResponse response, HttpServletRequest servletRequest)
			throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		String[] colName = new String[14];
		
		 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	     Calendar c1 = Calendar.getInstance();
		 String strToday = sdf.format(c1.getTime());
		
		String sFileNm = "BizboxA_OrgListAll_" + strToday;
		
		colName[0] = BizboxAMessage.getMessage("TX000000018","회사명");
		colName[1] = BizboxAMessage.getMessage("TX000000068","부서명");
		colName[2] = BizboxAMessage.getMessage("TX000000099","직급");
		colName[3] = BizboxAMessage.getMessage("TX000000105","직책");
		colName[4] = BizboxAMessage.getMessage("TX000000076","사원명") + "(ID)";
		colName[5] = BizboxAMessage.getMessage("TX000000073","전화번호");
		colName[6] = BizboxAMessage.getMessage("TX000000654","휴대전화");		
		colName[7] = BizboxAMessage.getMessage("TX000000074","팩스번호");
		colName[8] = BizboxAMessage.getMessage("TX000000375","주소");
		colName[9] = BizboxAMessage.getMessage("TX000020522","회사메일");
		colName[10] = BizboxAMessage.getMessage("TX000020523","개인메일");
		colName[11] = BizboxAMessage.getMessage("TX000000083","생년월일");
		colName[12] = BizboxAMessage.getMessage("TX000000088","담당업무");
		colName[13] = BizboxAMessage.getMessage("TX000000115","회사주소");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", loginVO.getUserSe());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("compSeq", loginVO.getCompSeq());
		
		//프로필 생년월일 표시 설정 옵션체크('1' = 월-일,   '0' = 년도-월-일)
		params.put("optionId", "cm2200");
		params.put("compSeq", loginVO.getCompSeq());
		String sCm2200 = (String) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
		
		if(sCm2200 == null) {
			sCm2200 = "1";
		}
		
		params.put("cmmOption2200", sCm2200);
		
		List<Map<String, Object>> list = orgChartService.getUserInfoList(params);
		
		excelService.CmmExcelDownload(list, colName, sFileNm, response, servletRequest);
	}
	
	/**
	 * 이미지,사인 일괄등록 양식 다운로드
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/userInfoExcelForm.do")
	public void userInfoExcelForm(@RequestParam Map<String, Object> params, HttpServletResponse response, HttpServletRequest servletRequest)
			throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		if(loginVO.getUserSe().equals("USER")){
			return;
		}else if(loginVO.getUserSe().equals("ADMIN")){
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		String sFileNm = "BizBoxAlpha";
		
		
		int[] colWidth = new int[4];
		String[] colName = new String[4];
		
		colName[0] = BizboxAMessage.getMessage("TX000000335","순번");
		colWidth[0] = 2560;
		
		colName[1] = BizboxAMessage.getMessage("TX000000133","로그인ID");
		colWidth[1] = 5120;
		
		colName[2] = BizboxAMessage.getMessage("TX000000150","사용자명");
		colWidth[2] = 5120;
		
		if(params.get("type").equals("photo")){
			sFileNm += "_ImgUploadForm";
			colName[3] = BizboxAMessage.getMessage("TX800000088","이미지 파일명");
		}else{
			sFileNm += "_SignUploadForm";
			colName[3] = BizboxAMessage.getMessage("TX800000089","사인 파일명");
		}
		
		colWidth[3] = 5120;
		
		

		
		List<Map<String, Object>> list = orgChartService.getUserFormList(params);
		
		excelService.CmmExcelDownloadAddContents(list, colWidth, colName, sFileNm, response, servletRequest);
	}	
	
	/**
	 * 사업장 선택 공통 팝업. - 가칭. 최초 작성 : 2017-03-07 작성자 : 장지훈 비고 :
	 * 
	 * @param params
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/systemx/orgChartBiz.do")
	public ModelAndView orgChartBiz(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO v = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (params.get("langCode") == null) {
			params.put("langCode", v.getLangCode());
		}
		if (EgovStringUtil.isEmpty(params.get("langCode").toString())) {
			params.put("langCode", v.getLangCode());
		}

		if (params.get("groupSeq") == null) {
			params.put("groupSeq", v.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("groupSeq").toString())) {
			params.put("groupSeq", v.getGroupSeq());
		}

		if (params.get("compSeq") == null) {
			params.put("compSeq", v.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("compSeq").toString())) {
			params.put("compSeq", v.getCompSeq());
		}

		if (params.get("deptSeq") == null) {
			params.put("deptSeq", v.getOrgnztId());
		}
		if (EgovStringUtil.isEmpty(params.get("deptSeq").toString())) {
			params.put("deptSeq", v.getOrgnztId());
		}

		if (params.get("empSeq") == null) {
			params.put("empSeq", v.getUniqId());
		}
		if (EgovStringUtil.isEmpty(params.get("empSeq").toString())) {
			params.put("empSeq", v.getUniqId());
		}

		if (params.get("selectItem") == null) {
			params.put("selectItem", "b");
		}
		if (EgovStringUtil.isEmpty(params.get("selectItem").toString())) {
			params.put("selectItem", "b");
		}

		if (params.get("selectedItems") == null) {
			params.put("selectedItems", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems").toString())) {
			params.put("selectedItems", "");
		}
		
		if (params.get("compFilter") == null) {
			params.put("compFilter", "");
		}
		if (EgovStringUtil.isEmpty(params.get("compFilter").toString())) {
			params.put("compFilter", "");
		}
		if (params.get("nodeChangeEvent") == null) {
			params.put("nodeChangeEvent", "");
		}
		if (EgovStringUtil.isEmpty(params.get("nodeChangeEvent").toString())) {
			params.put("nodeChangeEvent", "");
		}
		
		if (params.get("callbackParam") == null) {
			params.put("callbackParam", "");
		}		
		if (EgovStringUtil.isEmpty(params.get("callbackParam").toString())) {
			params.put("callbackParam", "");
		}
		
		if (params.get("callback") == null) {
			params.put("callback", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callback").toString())) {
			params.put("callback", "");
		}
		
		if (params.get("callbackUrl") == null) {
			params.put("callbackUrl", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callbackUrl").toString())) {
			params.put("callbackUrl", "");
		}
		
		if (params.get("initMode") == null) {
			params.put("initMode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("initMode").toString())) {
			params.put("initMode", "");
		}
		
		if (params.get("noUseDefaultNodeInfo") == null) {
			params.put("noUseDefaultNodeInfo", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseDefaultNodeInfo").toString())) {
			params.put("noUseDefaultNodeInfo", "");
		}
		
		if (params.get("includeDeptCode") == null) {
			params.put("includeDeptCode", "");
		}
		if (EgovStringUtil.isEmpty(params.get("includeDeptCode").toString())) {
			params.put("includeDeptCode", "");
		}
		
		if (params.get("noUseCompSelect") == null) {
			params.put("noUseCompSelect", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseCompSelect").toString())) {
			params.put("noUseCompSelect", "");
		}
		
		if (params.get("noUseDeleteBtn") == null) {
			params.put("noUseDeleteBtn", "");
		}
		if (EgovStringUtil.isEmpty(params.get("noUseDeleteBtn").toString())) {
			params.put("noUseDeleteBtn", "");
		}
		
		if (params.get("isAllDeptEmpShow") == null) {
			params.put("isAllDeptEmpShow", "true");
		}
		if (EgovStringUtil.isEmpty(params.get("isAllDeptEmpShow").toString())) {
			params.put("isAllDeptEmpShow", "true");
		}
		
		if (params.get("isDuplicate") == null || !params.get("isDuplicate").equals("false")) {
			params.put("isDuplicate", "");
		}else{
			params.put("isDuplicate", "true");
		}
		
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartBizBucketPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/GetBizProfileListForBiz.do")
	public ModelAndView GetBizProfileListForBiz(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("returnObj", orgChartService.GetBizProfileListForBiz(params));
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/GetFilterdBizProfileListForBiz.do")
	public ModelAndView GetFilterdBizProfileListForBiz(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("returnObj", orgChartService.GetFilterdBizProfileListForBiz(params));
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/GetSelectedBizProfileListBiz.do")
	public ModelAndView GetSelectedBizProfileListBiz(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("returnObj", orgChartService.GetSelectedBizProfileListBiz(params));
		return mv;
	}
	

	@RequestMapping("/cmm/systemx/orgExcelRangeSelectPop.do")
	public ModelAndView orgExcelRangeSelectPop(@RequestParam Map<String, Object> params,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/orgchart/pop/orgChartExcelRangeSelectPop");
		return mv;
	}
	
}
