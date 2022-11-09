package neos.cmm.systemx.dept.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import restful.com.controller.AttachFileController;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import api.poi.controller.ExcelController;
import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.BizMultiVO;
import bizbox.orgchart.service.vo.BizVO;
import bizbox.orgchart.service.vo.DeptMultiVO;
import bizbox.orgchart.service.vo.DeptVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.dept.service.DeptManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.img.service.FileUploadService;
import neos.cmm.systemx.orgchart.OrgChartSupport;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.CommonCodeUtil;
import neos.cmm.util.code.service.SequenceService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import api.drm.service.DrmService;

@Controller
public class DeptManageController {
	
	//private static final Logger logger = LoggerFactory.getLogger(ExcelController.class);
	
	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;		
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name = "DeptManageService")
	private DeptManageService deptManageService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
	@Resource(name = "FileUploadService")
	private FileUploadService fileUploadService;
    
    /** 임시 */
    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
    
    @Resource(name = "CompManageService")
	private CompManageService compService;
    
    @Resource(name="SequenceService")
    private SequenceService sequenceService;
    
	@Resource(name="ExcelService")
	private ExcelService excelService;    
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@Resource(name="EmpManageService")
    private EmpManageService empManageService;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name = "attachFileController")
	private AttachFileController attachFileController;
	
	@Resource(name = "DrmService")
	private DrmService drmService;	
	
	
	@IncludedInfo(name="조직도정보관리", order = 120 ,gid = 60)
	@RequestMapping("/cmm/systemx/deptManageView.do")
	public ModelAndView deptManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
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
		
		/** 부서 조회 */
		//List<Map<String,Object>> list = orgChartService.selectCompBizDeptListAdmin(params);
		//OrgChartTree tree = orgChartService.getOrgChartTree(list, params);
		//JSONArray deptListJson = JSONArray.fromObject(tree.getRoot());
		//mv.addObject("deptListJson", deptListJson);
		//System.out.println(deptListJson);
		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);
		
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}
		
		mv.setViewName("/neos/cmm/systemx/dept/deptManageView");
		
		return mv;
	}

	//조직도 정보관리 트리(추가)
	@ResponseBody
	@RequestMapping("/cmm/systemx/deptManageOrgChartListForAdmin.do")
	public Object deptManageOrgChartListForAdmin(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		if (params.get("langCode") == null || params.get("groupSeq") == null) {
			params.put("langCode", loginVO.getLangCode());
			params.put("groupSeq", loginVO.getGroupSeq());			
		}
		
		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		params.put("groupName", groupMap.get("groupName"));

		if(params.get("deptSeq") != null) {
			params.put("deptPath", orgChartService.GetOrgMyDeptPathAdmin(params));
		}
			
		
		/** 조직도 조회 */
		//List<Map<String, Object>> list = orgChartService.getCompBizDeptList(params);
		List<Map<String, Object>> list = orgChartService.getCompBizDeptListForAdmin(params);
		JSONArray json = JSONArray.fromObject(list);

		mv.addObject(json);
		mv.setViewName("jsonView");
		
		return json;
	}
	
	//조진도관리 트리
	@ResponseBody
	@RequestMapping("/cmm/systemx/deptManageOrgChartListJT.do")
	public Object deptManageOrgChartListJT(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> groupMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> tree = new ArrayList<Map<String,Object>>();
		JSONArray deptListJson = new JSONArray();
		
		try {
			
			//관리자일경우 자신이 속한 회사로 조회, 마스터일 경우 선택한 회사를 조회
			if(loginVO.getUserSe().equals("ADMIN")){
				params.put("compSeq", loginVO.getCompSeq());
			}
			
			if(params.get("langCode") == null || params.get("groupSeq") == null) {
				params.put("langCode", loginVO.getLangCode());
				params.put("groupSeq", loginVO.getGroupSeq());			
			}
			//그룹정보 조회
			groupMap = orgChartService.getGroupInfo(params);
			params.put("groupName", groupMap.get("groupName"));
			
			if(!params.get("deptSeq").equals("")) {
				params.put("deptPath", orgChartService.GetOrgMyDeptPathAdmin(params));
			}

			tree = orgChartService.getdeptManageOrgChartListJT(params);
			deptListJson = JSONArray.fromObject(tree);
		
		} catch (Exception e) {
			
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			
			groupMap = new HashMap<String, Object>();
			list = new ArrayList<Map<String,Object>>();
			tree = new ArrayList<Map<String,Object>>();
			
			deptListJson = new JSONArray();
			
		}
		
		mv.addObject(deptListJson);
		mv.setViewName("jsonView");
		
		
		return deptListJson;
	}
	
	@RequestMapping("/cmm/systemx/deptInfo.do")
	public ModelAndView deptInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("langCode", loginVO.getLangCode());
		params.put("groupSeq", loginVO.getGroupSeq());
		
		/** 부서장 선택 컬럼 사용여부 (sk D&D 사용) 2016.09.26 장지훈 추가 */
		//mv.addObject("")
		List<Map<String, String>> captain = CommonCodeUtil.getCodeList("deptCaptain");
		/* 클라우드에서 부서장 선택컬럼이 모두 노출되는 오류를 방지하기 위하여 다음과 같이 변경 2022-07-25*/
		if(captain != null && captain.size() > 0) {
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
		
		/** 상위부서 목록 
		List<Map<String,Object>> parentList = deptManageService.getParentDept(params);
		mv.addObject("parentList", parentList);*/
		
		/** 회사 관련 이미지 가져오기 
		params.put("orgSeq", String.valueOf(params.get("deptSeq")));
		List<Map<String,Object>> imgList = fileUploadService.getOrgImg(params);
		if (imgList != null) {
			Map<String,Object> imgMap = new HashMap<String,Object>();
			for(Map map : imgList) {
				String key = String.valueOf(map.get("imgType")); 
				imgMap.put(key, map);
			}
			
			mv.addObject("imgMap", imgMap);
		}*/
		
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
		
		//System.out.println(captain);
		mv.setViewName("/neos/cmm/systemx/dept/include/deptInfo");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/getParentDept.do")
	public ModelAndView getParentDept(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		paramMap.put("langCode", loginVO.getLangCode());
		
		List<Map<String,Object>> parentList = deptManageService.getParentDept(paramMap);
		
		mv.setViewName("jsonView");
		mv.addObject("parentList", parentList);
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/deptInfoSaveProc.do")
	public ModelAndView deptInfoSaveProc(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("createSeq", loginVO.getUniqId());
		
		//조직도 공통어뎁터 호출
		mv.addAllObjects(orgAdapterService.deptSaveAdapter(paramMap));
			
		mv.setViewName("jsonView");
		return mv;
	}
	

	
	
	
	
	@RequestMapping("/cmm/systemx/deptCompSortSaveProc.do")
	public ModelAndView deptCompSortSaveProc(@RequestParam Map<String,Object> paramMap, HttpServletResponse response, HttpServletRequest request) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String result = egovMessageSource.getMessage("success.common.update");
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("createSeq", loginVO.getUniqId());
		paramMap.put("modifySeq", loginVO.getUniqId());
		paramMap.put("useYn", "Y");
		paramMap.put("sortType", "ASC");
		
		String[] sortFields = request.getParameterValues("sortField");
		
		if (sortFields != null && sortFields.length == 5) {
			/** 중복체크 */
			Map<String,String> duMap = new HashMap<String,String>();
			for(String s : sortFields) {
				duMap.put(s, s);
			}
			
			if (duMap.size() != 5) {
				result = egovMessageSource.getMessage("fail.common.duplication"); 
			} else {
				/** 데이터 저장 */
				try {
					for(int i = 0; i < sortFields.length; i++) {
						paramMap.put("sortField", sortFields[i]);
						paramMap.put("orderNum", i+1);
						deptManageService.insertCompEmpSort(paramMap);
					}
				} catch (Exception e) {
					result = egovMessageSource.getMessage("fail.common.update");
				}
			}
		}

		ModelAndView mv = new ModelAndView();
		
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/deptCompEmpSortPop.do")
	public ModelAndView deptCompEmpSortPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		/** 공용코드 사용자정렬 리스트 조회 */
		params.put("code", "COM502");
		params.put("langCode", loginVO.getLangCode());
		List<Map<String,Object>> sortList = deptManageService.selectCompSortList(params);
		mv.addObject("sortList", sortList);
		
		mv.addObject("compSeq", params.get("compSeq"));
		
		mv.setViewName("/neos/cmm/systemx/dept/pop/deptCompEmpSortPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/deptInfoData.do")
	public ModelAndView deptInfoData(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("langCode", loginVO.getLangCode());
		params.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		mv.addObject("groupMap", groupMap);
		
		/** 부서정보 조회 */
		Map<String,Object> deptMap = deptManageService.selectDeptInfo(params);
		mv.addObject("deptMap", deptMap);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/deptListPop.do")
	public ModelAndView deptListPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("langCode", loginVO.getLangCode());
		
		String compSeq = params.get("compSeq").toString();
		
		if (EgovStringUtil.isEmpty(compSeq)) {
		
			if (loginVO.getUserSe().equals("MASTER")) {
				 request.setAttribute("compSeq", CommonUtil.getSessionData(request, "compSeq", mv));
			} else {
				 mv.addObject("compSeq", loginVO.getCompSeq());
				 request.setAttribute("compSeq", compSeq);
			}			
		}
		
		
		mv.addObject("idx", params.get("idx"));
		
		mv.setViewName("/neos/cmm/systemx/dept/pop/deptListPop");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/deptSortSaveProc.do")
	public ModelAndView deptSortSaveProc(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		JSONArray ja = JSONArray.fromObject(paramMap.get("list"));
		
		String newParentDeptSeq = paramMap.get("newParentDeptSeq")+"";
		
		String result = egovMessageSource.getMessage("systemx.comp.CP0003");
		
		try{
			/** 상위 부서 변경 update */
			if (!EgovStringUtil.isEmpty(newParentDeptSeq)) {
				DeptVO deptVO = new DeptVO();
				deptVO.setGroupSeq(loginVO.getGroupSeq());
				deptVO.setDeptSeq(paramMap.get("deptSeq")+"");
				deptVO.setParentDeptSeq(newParentDeptSeq);
				deptVO.setEditerSeq(loginVO.getUniqId());
				
				/** 조직도 path 구하기 */
				JSONArray parentList = JSONArray.fromObject(paramMap.get("parentList"));
				StringBuffer sb = new StringBuffer();
				for(int i = 0 ; i < parentList.size() ; i++) {
					JSONObject item = JSONObject.fromObject(parentList.get(i));
					sb.append(item.get("seq"));
					if (i < parentList.size()-1) {
						sb.append("|");
					}
				}
				deptVO.setPath(sb.toString());
				
				OrgChartSupport.getIOrgEditService().UpdateDept(deptVO);
			}

			/** 순서 DB update */
			List<Map<String,Object>> updateList = new ArrayList<Map<String,Object>>();
			for(int i = 0 ; i < ja.size() ; i++) {
				JSONObject json = JSONObject.fromObject(ja.get(i));
				Map<String,Object> map = new HashMap<String,Object>();

				if (EgovStringUtil.isEmpty(json.get("groupSeq")+"") || 
						EgovStringUtil.isEmpty(json.get("compSeq")+"") || 
						EgovStringUtil.isEmpty(json.get("bizSeq")+"") || 
						EgovStringUtil.isEmpty(json.get("seq")+"")) {
					continue;
				}
				map.put("groupSeq", json.get("groupSeq"));
				map.put("compSeq", json.get("compSeq"));
				map.put("bizSeq", json.get("bizSeq"));
				map.put("deptSeq", json.get("seq"));
				map.put("modifySeq", loginVO.getUniqId());
				map.put("orderNum", i);
				
				deptManageService.updateDeptOrderNum(map);
				updateList.add(map);
			}
			
			Map<String, Object> deptMp = new HashMap<String, Object>();
			deptMp.put("updateList", updateList);
			
			
			

		} catch (Exception e) {
			result = egovMessageSource.getMessage("fail.common.update");
		}
		
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	@RequestMapping("/cmm/systemx/deptInsertProc.do")
	public ModelAndView deptInsertProc(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpSession session) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		//조직도 공통어뎁터 호출
		mv.addAllObjects(orgAdapterService.deptSaveAdapter(params));
			
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/bizInsertProc.do")
	public ModelAndView bizInsertProc(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpSession session) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String deptName = String.valueOf(params.get("deptName"));
		
		JSONObject parentItem = JSONObject.fromObject(params.get("parentItem"));
		
		String pGroupSeq = String.valueOf(params.get("pGroupSeq"));
		String pCompSeq = String.valueOf(params.get("pCompSeq"));
		String pBizSeq = String.valueOf(params.get("pBizSeq"));
		String pDeptSeq = String.valueOf(params.get("pDeptSeq"));
		String deptSeq = String.valueOf(params.get("deptSeq2"));
		String deptDisplayName = String.valueOf(params.get("deptDisplayName"));
		String orderNum = String.valueOf(params.get("orderNum"));
		String gbnOrg = String.valueOf(params.get("gbnOrg"));
		
		String compRegistNum = String.valueOf(params.get("compRegistNum"));		//사업자번호
		String compNum = String.valueOf(params.get("compNum"));					//법인번호
		String telNum = String.valueOf(params.get("telNum"));					//전화
		String faxNum = String.valueOf(params.get("faxNum"));					//팩스
		String homepgAddr = String.valueOf(params.get("homepgAddr"));			//홈페이지
		String zipCode = String.valueOf(params.get("zipCode"));					//우편번호
		String displayYn = String.valueOf(params.get("displayYn"));				//기본사업장여부
		String useYn = String.valueOf(params.get("useYn"));						//사용여부
		
		String ownerName = String.valueOf(params.get("ownerName"));				//대표자명
		String bizCondition = String.valueOf(params.get("bizCondition"));		//등록자시퀀스
		String item = String.valueOf(params.get("item"));						//종목
		String addr = String.valueOf(params.get("addr"));						//우편주소 
		String detailAddr = String.valueOf(params.get("detailAddr"));			//상세주소
		
		
		if (gbnOrg.equals("c")) {
			pGroupSeq = loginVO.getGroupSeq();
			pBizSeq = pCompSeq;
			pDeptSeq = "0";
		}
		
		if (deptDisplayName.isEmpty()) {
			deptDisplayName = deptName;
		}
		
		if (orderNum.isEmpty()) {
			orderNum = "99999";
		}
		
		
		String newDeptSeq = deptSeq;
		//String newDeptSeq = pCompSeq+sequenceService.getSequence("orgchart");
		
		BizVO bizVO = new BizVO();
		bizVO.setGroupSeq(pGroupSeq);
		bizVO.setCompSeq(pCompSeq);
		bizVO.setBizSeq(newDeptSeq);
		bizVO.setCompRegistNum(compRegistNum);
		bizVO.setCompNum(compNum);
		bizVO.setTelNum(telNum);
		bizVO.setFaxNum(faxNum);
		bizVO.setHomepgAddr(homepgAddr);
		bizVO.setZipCode(zipCode);
		bizVO.setDisplayYn(displayYn);
		bizVO.setOrder(orderNum);
		bizVO.setUseYn(useYn);
		bizVO.setEditerSeq(loginVO.getUniqId());
		bizVO.setNativeLangCode(loginVO.getLangCode());

		OrgChartSupport.getIOrgEditService().InsertBiz(bizVO);
		
		
		BizMultiVO bixMultiVO = new BizMultiVO();
		bixMultiVO.setGroupSeq(pGroupSeq);
		bixMultiVO.setCompSeq(pCompSeq);
		bixMultiVO.setBizSeq(newDeptSeq);
		bixMultiVO.setBizName(deptName);
		bixMultiVO.setOwnerName(ownerName);
		bixMultiVO.setBizCondition(bizCondition);
		bixMultiVO.setItem(item);
		bixMultiVO.setAddr(addr);
		bixMultiVO.setDetailAddr(detailAddr);
		bixMultiVO.setLangCode(loginVO.getLangCode());
		bixMultiVO.setUseYn("Y");
		bixMultiVO.setEditerSeq(loginVO.getUniqId());

		boolean bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bixMultiVO);
		
		
		pBizSeq = newDeptSeq;
		
		DeptVO deptVO = new DeptVO();
		deptVO.setGroupSeq(pGroupSeq);
		deptVO.setCompSeq(pCompSeq);
		deptVO.setBizSeq(pBizSeq);
		deptVO.setDeptSeq(newDeptSeq);
		deptVO.setParentDeptSeq(pDeptSeq);
		deptVO.setUseYn("Y");
		deptVO.setOrder(orderNum);
		deptVO.setEditerSeq(loginVO.getUniqId());
		deptVO.setNativeLangCode(loginVO.getLangCode());
		
		OrgChartSupport.getIOrgEditService().InsertDept(deptVO);
		
		
		DeptMultiVO deptMultiVO = new DeptMultiVO();
		deptMultiVO.setGroupSeq(pGroupSeq);
		deptMultiVO.setCompSeq(pCompSeq);
		deptMultiVO.setBizSeq(pBizSeq);
		deptMultiVO.setDeptSeq(newDeptSeq);
		deptMultiVO.setParentDeptSeq(pDeptSeq);
		deptMultiVO.setDeptName(deptName);
		deptMultiVO.setDeptDisplayName(deptDisplayName);
		deptMultiVO.setLangCode(loginVO.getLangCode());
		deptMultiVO.setUseYn("Y");
		deptMultiVO.setEditerSeq(loginVO.getUniqId());
		
		boolean bool2 = OrgChartSupport.getIOrgEditService().InsertDeptMulti(deptMultiVO);
		
		
		mv.addObject("result", "0");
		mv.addObject("resultMsg", egovMessageSource.getMessage("success.common.insert"));
						
		mv.setViewName("jsonView");
		
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/deptRemoveProc.do")
	public ModelAndView deptRemoveProc(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpSession session) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
				
		//조직도 공통어뎁터 호출
		mv.addAllObjects(orgAdapterService.deptRemoveAdapter(params));
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/GetSearchDeptList.do")
	public ModelAndView GetSearchDeptList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		try {
			resultList = orgChartService.GetSearchDeptListAdmin(params);
		} catch (Exception e) {
			resultList = new ArrayList<Map<String, Object>>();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		mv.setViewName("jsonView");
		mv.addObject("list", resultList);
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/deptRegBatchPop.do")
	public ModelAndView deptRegBatchPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("groupMap", groupMap);
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", userSe);
			if (userSe.equals("ADMIN")) {
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
		
		mv.setViewName("/neos/cmm/systemx/dept/pop/deptRegBatchPop");
		
		return mv;
	}
	
	
	@RequestMapping(value = "/cmm/systemx/deptExcelValidate.do", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView procExcelToJSON(HttpServletRequest request) throws Exception {

		
		  ModelAndView mv = new ModelAndView();
		
		  //logger.info("CONTROLLER BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		  LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		
		  
		  Map<String,Object> resultMap = new HashMap<String, Object>();
	
		  // SET LOCAL VALUE
		  List<Map<String,Object>> excelContentList = null; 	  
	
		  try {
			  String osType = NeosConstants.SERVER_OS;
			  
			  Map<String, Object> param = new HashMap<String, Object>();
			  param.put("groupSeq", loginVO.getGroupSeq());
			  param.put("pathSeq", "0");
			  param.put("osType", osType);
			  
			  Map<String, Object> pathMap = groupManageService.selectGroupPath(param);
			  
			  String savePath = "";
			  
			  if(pathMap.size() == 0) {
				  savePath = File.separator;
			  }
			  else {
				  savePath = pathMap.get("absolPath") + "/exceltemp/";
			  }
			  
			  File dir = new File(savePath);
			  
			  if(!dir.exists()){
			         dir.mkdir();
	  		  }
	
			  MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // NAME IN JSP FORM
	
			  if (mFile != null && mFile.getSize() > 0) {
				  String saveFileName  = mFile.getOriginalFilename();
	
				  long fileSize   = mFile.getSize();
	
				  if (fileSize > 0 && !saveFileName.equals("")) {
					 saveFileName = savePath + saveFileName;					 

					 EgovFileUploadUtil.saveFile(mFile.getInputStream(), new File(saveFileName));
					 					 
					 int index = mFile.getOriginalFilename().lastIndexOf(".");
						
					 String fileExt = mFile.getOriginalFilename().substring(index + 1);
					 String newName = mFile.getOriginalFilename().substring(0, index);				
						
					 //DRM 체크
					 drmService.drmConvert("U", "", "E", savePath, newName, fileExt);
					 
				     excelContentList = excelService.procExtractExcelTemp(saveFileName);
				     
				     File path = new File(savePath);
			   			File[] fileList = path.listFiles();
			   			
			   			for(File file: fileList){
			   				if(file.getName().equals(mFile.getOriginalFilename())){
			   					file.delete();
			   				}
			   			}
				     
				  }
				  
				  if (excelContentList != null && excelContentList.size() > 0) {
					  Calendar cal = Calendar.getInstance();
					  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
					  String ts = sdf.format(cal.getTime());
					  
					  Map<String, Object> compInfoMap = (Map<String, Object>) commonSql.select("DeptManage.getCompInfoByCd", deptManageService.checkExcelData(excelContentList.get(0)).put("groupSeq", loginVO.getGroupSeq()));
					  
					  
					  
					  //관리자일 경우 소속 회사의 조직도만 업로드 가능.
					  //업로드 대상 회사와 관리자 소속 회사 체크 후 미일치시 리턴.
					  if(loginVO.getUserSe().equals("ADMIN")){
						  if(!compInfoMap.get("compSeq").toString().equals(loginVO.getCompSeq())){
							  resultMap.put("retMsg", "errorAdminAuth");
							  mv.addAllObjects(resultMap);
							  mv.setViewName("jsonView");
							  return mv;
						  }
					  }					  
					  
					  for (int i = 0 ; i < excelContentList.size() ; i++) {
						  Map<String,Object> paramMap = deptManageService.checkExcelData(excelContentList.get(i));
						  paramMap.put("batchSeq", ts);
						  paramMap.put("groupSeq", loginVO.getGroupSeq());
						  paramMap.put("createSeq", loginVO.getUniqId());
						  
						  Map<String, Object> compInfo = (Map<String, Object>) commonSql.select("DeptManage.getCompInfoByCd", paramMap);
						  paramMap.put("compSeq", compInfo.get("compSeq") + "");
						  
						  commonSql.insert("OrgChart.insertDeptBatch", paramMap);
					  }
					  
					  //biz_seq값 셋팅
					  Map<String, Object> mp = new HashMap<String, Object>();
					  mp.put("retKey", ts);							  
					  commonSql.update("OrgChart.setDeptBizBatch", mp);

					  resultMap.put("retMsg", "success");
					  resultMap.put("retKey", ts);
				  }
				  else {
					  resultMap.put("retMsg", "fail");
					  resultMap.put("retKey", "0");
				  }
			  }
			  
		  } catch (Exception ex) {
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			  resultMap.put("retMsg", "fail");
		  }
	
		  // SET JSON
		  JSONArray arrExcelContentList = new JSONArray();
	
		  arrExcelContentList = JSONArray.fromObject(excelContentList);

		  resultMap.put("retData", arrExcelContentList);

		  mv.addAllObjects(resultMap);
		  mv.setViewName("jsonView");
		  return mv;
	}	
	
	
	@RequestMapping("/cmm/systemx/getDeptBatchInfo.do")
	public ModelAndView getDeptBatchInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());

		ModelAndView mv = new ModelAndView();
		
		List<Map<String, Object>> list = deptManageService.getDeptBatchInfo(params);
		
		mv.addObject("deptBatchList", list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/saveDeptBatch.do")
	public ModelAndView saveDeptBatch(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		String retKey = (String) params.get("retKey");
		String jsonStr = (String)params.get("saveList");
		
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> saveList = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>(){});
		String strDeptSeq = "";
		String strParDeptSeq = "";
		
		for(Map<String,Object> map : saveList){
			strDeptSeq += ",'" + map.get("seq").toString().split(",")[0] + "'";
			strParDeptSeq += ",'" + map.get("seq").toString().split(",")[1] + "'";
		}
		 
		if(strDeptSeq.length() > 0) {
			strDeptSeq = strDeptSeq.substring(1);
		}
		if(strParDeptSeq.length() > 0) {
			strParDeptSeq = strParDeptSeq.substring(1);
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("strDeptSeq", strDeptSeq);
		param.put("strParDeptSeq", strParDeptSeq);
		param.put("retKey", retKey);		
	
		List<Map<String, Object>> deptSaveList = deptManageService.getSelectedDeptBatchInfo(param);
		
		String strErrorSeq = "";
		String strSuccessSeq = "";
		String strBatchSeq = "";
		
		for(Map<String, Object> map : deptSaveList){
			
			Map<String, Object> deptInfo = new HashMap<String, Object>();
			deptInfo.putAll(map);
			deptInfo.put("groupSeq", loginVO.getGroupSeq());
			deptInfo.put("createSeq", loginVO.getUniqId());
			deptInfo.put("deptCd", map.get("deptSeq"));
			
			if(map.get("orderNum").equals("")){
				deptInfo.put("orderNum", map.get("seq"));	
			}else{
				deptInfo.put("orderNum", map.get("orderNum"));
			}
			
			deptInfo.put("zipCode", map.get("zipCode"));
			deptInfo.put("addr", map.get("addr"));
			deptInfo.put("detailAddr", map.get("detailAddr"));
			deptInfo.put("innerReceiveYn", map.get("innerReceiveYn"));
			deptInfo.put("standardCode", map.get("standardCode"));
			deptInfo.put("senderName", map.get("senderName"));
			
			deptInfo.put("bizDisplay", "Y");
			deptInfo.put("useYn", "Y");
			deptInfo.put("deptDisplayYn", "Y");
			deptInfo.put("deptSeq", "");
			
			//사업장 추가
			if(map.get("deptType").equals(BizboxAMessage.getMessage("TX000000811","사업장"))){
				deptInfo.put("teamYn", "N");
				deptInfo.put("deptType", "B");
				deptInfo.put("bizNickname", map.get("deptNickname"));
				// 신규 사업장으로 등록
				deptInfo.put("bizSeqDef", map.get("bizSeq"));
                deptInfo.put("bizSeq", "");
			}else{
				deptInfo.put("deptType", "D");
				if(map.get("deptType").equals(BizboxAMessage.getMessage("TX000011782","임시부서"))){
					deptInfo.put("teamYn", "T");
				}else if(map.get("deptType").equals(BizboxAMessage.getMessage("TX000000639","팀"))){
					deptInfo.put("teamYn", "Y");
				}else{
					deptInfo.put("teamYn", "N");
				}
				deptInfo.put("deptNickname", map.get("deptNickname"));
				
				if(map.get("parentDeptSeq").equals(map.get("deptSeq").toString())){
					if(map.get("deptPath").toString().split("\\|").length > 1){
						//사업장 하위 최상위 부서
						deptInfo.put("parentDeptSeq", "0");
						Map<String, Object> innerParam = new HashMap<String, Object>();
						innerParam.put("bizCd", map.get("deptPath").toString().split("\\|")[0]);
						innerParam.put("compSeq", map.get("compSeq"));
						deptInfo.put("bizSeq", (String)commonSql.select("DeptManage.getBizSeqFromBizCd", innerParam));
					}else{
						//기본사업장 하위 최상위 부서
						deptInfo.put("parentDeptSeq", "0");
						deptInfo.put("bizSeq", deptInfo.get("compSeq"));						
					}
				}else{
					//하위 부서
					Map<String, Object> innerParam = new HashMap<String, Object>();
					innerParam.put("deptCd", map.get("parentDeptSeq"));						
					innerParam.put("compSeq", map.get("compSeq"));
					deptInfo.put("parentDeptSeq", (String)commonSql.select("DeptManage.getDeptSeqFromDeptCd", innerParam));	
					deptInfo.put("bizSeq", (String)commonSql.select("DeptManage.getBizSeqFromDeptCd", innerParam));
				}				
			}
			
			Map<String,Object> deptSaveAdapterResult = orgAdapterService.deptSaveAdapter(deptInfo);
			
			if(deptSaveAdapterResult.get("resultCode").equals("fail")){
				strErrorSeq += "&" + map.get("deptSeq").toString() + "," + map.get("parentDeptSeq").toString() + "," + map.get("deptPath").toString() + "error";
			}
			else{
				strSuccessSeq += "&" + map.get("deptSeq").toString() + "," + map.get("parentDeptSeq").toString() + "," + map.get("deptPath").toString();
				strBatchSeq += "," + map.get("seq").toString();				
			}
		}
		
		//임시테이블 데이터 삭제
		if(strBatchSeq.length() > 0){
			param.put("strBatchSeq", strBatchSeq.substring(1));
			deptManageService.deleteDeptBatchInfo(param);
		}
		
		if(strSuccessSeq.length() > 0 ) {
			strSuccessSeq = strSuccessSeq.substring(1);
		}
		
		if(strErrorSeq.length() > 0 ) {
			strErrorSeq = strErrorSeq.substring(1);
		}
		
		mv.addObject("strSuccessSeq", strSuccessSeq);
		mv.addObject("strErrorSeq", strErrorSeq);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	public boolean insertDept(Map<String,Object> map){
		boolean bool = false;
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(map.get("deptType").equals(BizboxAMessage.getMessage("TX000000811","사업장"))){
			BizVO bizVO = new BizVO();
			bizVO.setBizSeq(map.get("bizSeq") + "");
			bizVO.setGroupSeq(loginVO.getGroupSeq());
			bizVO.setCompSeq(map.get("compSeq") + "");
			bizVO.setCompRegistNum("");
			bizVO.setCompNum("");
			bizVO.setDisplayYn("Y");
			bizVO.setUseYn("Y");
			bizVO.setNativeLangCode("kr");
			bizVO.setZipCode("");
			
			OrgChartSupport.getIOrgEditService().InsertBiz(bizVO);
			
			BizMultiVO bizMultiVO = new BizMultiVO();
			bizMultiVO.setBizSeq(map.get("bizSeq") + "");
			bizMultiVO.setLangCode("kr");
			bizMultiVO.setGroupSeq(loginVO.getGroupSeq());
			bizMultiVO.setCompSeq(map.get("compSeq") + "");
			bizMultiVO.setBizName(map.get("deptName") + "");
			bizMultiVO.setOwnerName("");
			bizMultiVO.setAddr("");
			bizMultiVO.setDetailAddr("");
			bizMultiVO.setUseYn("Y");
			
			bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bizMultiVO);
			
			if(!EgovStringUtil.isEmpty(map.get("deptNameEn")+"")){
				bizMultiVO.setLangCode("en");
				bizMultiVO.setBizName(map.get("deptNameEn").toString());
				bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bizMultiVO);
			}
			if(!EgovStringUtil.isEmpty(map.get("deptNameJp")+"")){
				bizMultiVO.setLangCode("jp");
				bizMultiVO.setBizName(map.get("deptNameJp").toString());
				bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bizMultiVO);
			}
			if(!EgovStringUtil.isEmpty(map.get("deptNameCn")+"")){
				bizMultiVO.setLangCode("cn");
				bizMultiVO.setBizName(map.get("deptNameCn").toString());
				bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bizMultiVO);
			}
			
			if(bool){
				String bizCd = map.get("bizSeq") + "";
				Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("bizCd", bizCd);
				mp.put("sealFileId", "");
				mp.put("bizSeq", map.get("bizSeq") + "");
				commonSql.update("DeptManage.UpdateBizAddInfomation", mp);
			}
		}		
		
		else{
				DeptVO deptVO = new DeptVO();
				deptVO.setGroupSeq(loginVO.getGroupSeq());
				deptVO.setCompSeq(map.get("compSeq") + "");
				deptVO.setBizSeq(map.get("bizSeq") + "");
				deptVO.setDeptSeq(map.get("deptSeq") + "");
				deptVO.setDeptCd(map.get("deptSeq") + "");
				deptVO.setParentDeptSeq(map.get("parentDeptSeq") + "");
				deptVO.setUseYn("Y");
				deptVO.setOrder(map.get("seq") + "");
				if(deptVO.getOrder() != null && deptVO.getOrder().equals("")) {
					deptVO.setOrder(null);
				}
				deptVO.setEditerSeq(loginVO.getUniqId());
				deptVO.setNativeLangCode(loginVO.getLangCode());
				deptVO.setVirDeptYn("N");
				deptVO.setTeamYn("N");	
				
				if(map.get("deptType").equals(BizboxAMessage.getMessage("TX000000639","팀"))){			
					deptVO.setTeamYn("Y");
				}
				else if(map.get("deptType").equals(BizboxAMessage.getMessage("TX000011782","임시부서"))){
					deptVO.setVirDeptYn("Y");
				}
				
				//부서유형 체크
				//상위부서 = '임시' 일경우 하위부서로 '임시'만 등록가능
				//상위부서 = '팀' 일경우 하위부서로 '팀'만 등록가능
				if(!(map.get("parentDeptSeq") + "").equals("0")){
					Map<String, Object> deptInfomap = new HashMap<String, Object>();
					deptInfomap.put("deptSeq", map.get("parentDeptSeq") + "");		
					deptInfomap = deptManageService.getDeptInfo(deptInfomap);
					
					
					String pVirDeptYn = deptInfomap.get("virDeptYn") + "";
					String pTeamYn = deptInfomap.get("teamYn") + "";
					
					if(pVirDeptYn.equals("Y") && !deptVO.getVirDeptYn().equals("Y")){
						return false;
					}
					
					if(pTeamYn.equals("Y") && !deptVO.getTeamYn().equals("Y")){
						return false;
					}
					
				}
				
				OrgChartSupport.getIOrgEditService().InsertDept(deptVO);					
				
				DeptMultiVO deptMultiVO = new DeptMultiVO();
				deptMultiVO.setGroupSeq(loginVO.getGroupSeq());
				deptMultiVO.setCompSeq(map.get("compSeq") + "");
				deptMultiVO.setBizSeq(map.get("bizSeq") + "");
				deptMultiVO.setDeptSeq(map.get("deptSeq") + "");
				deptMultiVO.setParentDeptSeq(map.get("parentDeptSeq") + "");
				deptMultiVO.setDeptName(map.get("deptName") + "");
				deptMultiVO.setDeptDisplayName("");
				deptMultiVO.setLangCode(loginVO.getLangCode());
				deptMultiVO.setUseYn("Y");
				deptMultiVO.setEditerSeq(loginVO.getUniqId());
				
				bool = OrgChartSupport.getIOrgEditService().InsertDeptMulti(deptMultiVO);
				
				if(!EgovStringUtil.isEmpty(map.get("deptNameEn") + "")){
					deptMultiVO.setLangCode("en");
					deptMultiVO.setDeptName(map.get("deptNameEn").toString());
					bool = OrgChartSupport.getIOrgEditService().InsertDeptMulti(deptMultiVO);
				}
				if(!EgovStringUtil.isEmpty(map.get("deptNameJp") + "")){
					deptMultiVO.setLangCode("jp");
					deptMultiVO.setDeptName(map.get("deptNameJp").toString());
					bool = OrgChartSupport.getIOrgEditService().InsertDeptMulti(deptMultiVO);
				}
				if(!EgovStringUtil.isEmpty(map.get("deptNameCn") + "")){
					deptMultiVO.setLangCode("cn");
					deptMultiVO.setDeptName(map.get("deptNameCn").toString());
					bool = OrgChartSupport.getIOrgEditService().InsertDeptMulti(deptMultiVO);
				}
				
				//상위부서정보 담고있는 컬럼(display_dept_seq) 값 update
				Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("compSeq", deptVO.getCompSeq());
				mp.put("deptSeq", deptVO.getDeptSeq());
				mp.put("deptDisplayYn", "Y");
				commonSql.update("DeptManage.UpdateDisplayDeptSeq", mp);
				
		//		if(map.get("deptType").equals("사업장")){
		//			BizVO bizVO = new BizVO();
		//			bizVO.setGroupSeq(loginVO.getGroupSeq());
		//			bizVO.setCompSeq(map.get("compSeq")+"");
		//			bizVO.setBizSeq(map.get("deptSeq")+"");
		//			bizVO.setCompRegistNum(null);
		//			bizVO.setCompNum(null);
		//			bizVO.setTelNum(null);
		//			bizVO.setFaxNum(null);
		//			bizVO.setHomepgAddr(null);
		//			bizVO.setZipCode(null);
		//			bizVO.setDisplayYn("N");
		//			bizVO.setOrder(map.get("seq")+"");
		//			bizVO.setUseYn("Y");
		//			bizVO.setEditerSeq(loginVO.getUniqId());
		//			bizVO.setNativeLangCode(loginVO.getLangCode());
		//
		//			OrgChartSupport.getIOrgEditService().InsertBiz(bizVO);
		//			
		//			
		//			BizMultiVO bixMultiVO = new BizMultiVO();
		//			bixMultiVO.setGroupSeq(loginVO.getGroupSeq());
		//			bixMultiVO.setCompSeq(map.get("compSeq")+"");
		//			bixMultiVO.setBizSeq(map.get("deptSeq")+"");
		//			bixMultiVO.setBizName(map.get("deptName") + "");
		//			bixMultiVO.setOwnerName(null);
		//			bixMultiVO.setBizCondition(null);
		//			bixMultiVO.setItem(null);
		//			bixMultiVO.setAddr(null);
		//			bixMultiVO.setDetailAddr(null);
		//			bixMultiVO.setLangCode(loginVO.getLangCode());
		//			bixMultiVO.setUseYn("Y");
		//			bixMultiVO.setEditerSeq(loginVO.getUniqId());
		//
		//			bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bixMultiVO);
		////			
		////			if(!EgovStringUtil.isEmpty(map.get("deptNameEn")+"")){
		////				bixMultiVO.setLangCode("en");
		////				bixMultiVO.setBizName(map.get("deptNameEn").toString());
		////				bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bixMultiVO);
		////			}
		////			if(!EgovStringUtil.isEmpty(map.get("deptNameJp")+"")){
		////				bixMultiVO.setLangCode("jp");
		////				bixMultiVO.setBizName(map.get("deptNameJp").toString());
		////				bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bixMultiVO);
		////			}
		////			if(!EgovStringUtil.isEmpty(map.get("deptNameCn")+"")){
		////				bixMultiVO.setLangCode("cn");
		////				bixMultiVO.setBizName(map.get("deptNameCn").toString());
		////				bool = OrgChartSupport.getIOrgEditService().InsertBizMulti(bixMultiVO);
		////			}
		//			
		//		}
				
				
			}
		
		
		
		return bool;
	}
	
	
	@RequestMapping("/cmm/systemx/checkDeptSeq.do")
	public ModelAndView checkDeptSeq(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		if(!params.get("deptType").toString().equals("B")){
			Map<String, Object> deptMap = (Map<String, Object>) commonSql.select("DeptManage.selectDeptCd", params);
			if(deptMap == null) {
				mv.addObject("result", "1");
			}
			else {
				mv.addObject("result", "0");
			}
		}else{
			Map<String, Object> deptMap = (Map<String, Object>) commonSql.select("DeptManage.selectBizCd", params);
			if(deptMap == null) {
				mv.addObject("result", "1");
			}
			else {
				mv.addObject("result", "0");
			}
		}
		
		
		
		mv.setViewName("jsonView");
		
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/deptBatchPreviewPop.do")
	public ModelAndView deptBatchPreviewPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", params.get("targetCompSeq").toString());
		params.put("langCode", loginVO.getLangCode());
		
		List<Map<String,Object>> list = deptManageService.getDeptBatchPreviewList(params);
		String batchSeq = "";
		String batchBizSeq = "";
		
		for(Map<String,Object> map : list){
			if(!map.get("batchSeq").toString().equals("")){
				batchSeq += "|" + map.get("id").toString();
				if(map.get("id").toString().equals(map.get("bizSeq").toString())) {
					batchBizSeq += "|" + "b";
				}
				else {
					batchBizSeq += "|" + "d";
				}
			}
			
		}
		
		if(batchSeq.length() > 0){
			batchSeq = batchSeq.substring(1);
			batchBizSeq = batchBizSeq.substring(1);
		}
		
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}
		
		
		mv.addObject("batchSeq", batchSeq);
		mv.addObject("batchBizSeq", batchBizSeq);
		mv.addObject("targetCompSeq", params.get("targetCompSeq"));
		mv.addObject("retKey", params.get("retKey"));
		mv.setViewName("/neos/cmm/systemx/dept/pop/deptBatchPreviewPop");
		
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/deleteDeptBatchInfo.do")
	public ModelAndView deleteDeptBatchInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		deptManageService.deleteDeptBatchInfo(params);
		
		mv.setViewName("jsonView");		
		
		return mv;
	}
	
}
