package neos.cmm.systemx.empdept.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import bizbox.orgchart.service.vo.EmpDeptMultiVO;
import bizbox.orgchart.service.vo.EmpDeptVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.comp.service.ExCodeOrgService;
import neos.cmm.systemx.dutyPosition.sercive.DutyPositionManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.empdept.service.EmpDeptManageService;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.orgAdapter.dao.OrgAdapterDAO;
import neos.cmm.systemx.orgchart.OrgChartNode;
import neos.cmm.systemx.orgchart.OrgChartSupport;
import neos.cmm.systemx.orgchart.OrgChartTree;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class EmpDeptManageController {
	
	@Resource(name = "CommonOptionManageService")
	CommonOptionManageService commonOptionManageService;	
	
	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;	
	
	@Resource(name = "OrgAdapterDAO")
    private OrgAdapterDAO orgAdapterDAO;	
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
    @Resource(name="EmpManageService")
    private EmpManageService empManageService;
    
    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
    
    @Resource(name = "CompManageService")
	private CompManageService compService;
    
    @Resource(name = "EmpDeptManageService")
    private EmpDeptManageService empDeptManageService;
    
	@Resource(name = "DutyPositionManageService")
	private DutyPositionManageService dutyPositionService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@Resource(name="LicenseService")
	private LicenseService licenseService;
	
	private ConnectionVO		conVo				= new ConnectionVO();
    
	@RequestMapping("/cmm/systemx/empDeptInfoPop.do")
	public ModelAndView empDeptInfoPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("groupMap", groupMap);
		
		String compSeq = params.get("compSeq")+"";
		String groupSeq = params.get("groupSeq")+"";
		params.put("langCode", loginVO.getLangCode());
		
		if (EgovStringUtil.isEmpty(compSeq)) {
			if (loginVO.getUserSe().equals("MASTER")) {
				 CommonUtil.getSessionData(request, "compSeq", params);
			} else {
				 params.put("compSeq", loginVO.getCompSeq());
			}
		}
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		params.put("dpType", "DUTY");
		List<Map<String, Object>> dutyList = dutyPositionService.getCompDutyPositionList(params);
		
		params.put("dpType", "POSITION");
		List<Map<String, Object>> positionList = dutyPositionService.getCompDutyPositionList(params);
		
		mv.addObject("dutyList", dutyList);
		mv.addObject("positionList", positionList);
		
		String deptSeq = params.get("deptSeq")+"";
		 
		Map<String,Object> empListMap = empManageService.selectEmpInfo(params, new PaginationInfo());
		
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> list = (List<Map<String, Object>>) empListMap.get("list");
		
		
		if (list != null && list.size() > 0) {
			Map<String, Object> map = list.get(0);
			if (map != null) {
				map.put("deptSeq", deptSeq);
			}
			
			if (!EgovStringUtil.isEmpty(deptSeq)) {
				mv.addObject("infoMap", list.get(0)); 
			}
		}
		
		mv.addObject("compSeq", params.get("compSeq"));
		if(!EgovStringUtil.isEmpty(params.get("flag")+"")){
			mv.addObject("flag", "Y");
		}
		/** 조직도 조회 */
		List<Map<String,Object>> listMap = orgChartService.selectCompBizDeptList(params);
		
		/** 트리 구조로 변환 */
		OrgChartTree tree = orgChartService.getOrgChartTree(listMap, params);
		JSONObject json = JSONObject.fromObject(tree.getRoot());
		mv.addObject("orgChartList", json);
		
		MessageUtil.getRedirectMessage(mv, request);
		 
		mv.setViewName("/neos/cmm/systemx/empdept/pop/empDeptInfoPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/empDeptRemoveProc.do")
	public ModelAndView empDeptRemoveProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());
		
		ModelAndView mv = new ModelAndView(); 
		mv.addAllObjects(orgAdapterService.empDeptRemoveAdapter(params));
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/empDeptInfoSaveProc.do")
	public ModelAndView empDeptInfoSaveProc(@RequestParam Map<String,Object> params, HttpServletRequest request, RedirectAttributes ra) throws Exception {
				
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("eaType", loginVO.getEaType());
		params.put("createSeq", loginVO.getUniqId());
		params.put("callType", "saveEmpDept");
		
		mv.addAllObjects(orgAdapterService.empSaveAdapter(params));
		
		// mailSync호출
		if(params.get("compSeq") != null){
			orgAdapterService.mailUserSync(params);    					
		} 			
		
		mv.setViewName("jsonView");
		
		return mv;
	}

	private String empDeptInfoSave(Map<String,Object> params, 
		EmpDeptVO empDeptVO, EmpDeptMultiVO empDeptMultiVO) {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String result = "";
		
		String workStatus = "";
		
		if(params.get("workStatus") != null){
			workStatus = params.get("workStatus") + "";
			if(!workStatus.equals("999")) {
				params.put("useYn", "N");
			}
			else {
				params.put("useYn","Y");
			}
		}
				
				
		String oldDeptSeq = params.get("deptSeq") + "";
		
		empDeptMultiVO.setLangCode("kr");
		params.put("langCode", loginVO.getLangCode());
	
//		String bizSeq = params.get("bizSeq")+"";
		String compSeq = params.get("compSeq")+"";
		String deptSeq = params.get("deptSeq")+"";
		String empSeq = params.get("empSeq")+"";
		String deptSeqNew = params.get("deptSeqNew")+"";
		String groupSeq = params.get("groupSeq")+"";
		
		//bizSeq setting (선택 부서의 bizseq로 셋팅)
		String sBizSeq = "";
		if(!deptSeqNew.equals("")){
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("deptSeq", deptSeqNew);
			sBizSeq = empManageService.getbizSeq(para);
		}
		else{
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("deptSeq", deptSeq);
			sBizSeq = empManageService.getbizSeq(para);
		}
		
		
		String bizSeq = sBizSeq;		
		
		if (EgovStringUtil.isEmpty(bizSeq)) {
			bizSeq = loginVO.getBizSeq();
		}
		
		params.put("bizSeq", bizSeq);
		empDeptVO.setBizSeq(bizSeq);
		empDeptMultiVO.setBizSeq(bizSeq);
		
		empDeptVO.setEditerSeq(loginVO.getUniqId());
		empDeptMultiVO.setEditerSeq(loginVO.getUniqId());
		
		if(EgovStringUtil.isEmpty(groupSeq)){
			params.put("groupSeq", loginVO.getGroupSeq());
			empDeptVO.setGroupSeq(loginVO.getGroupSeq());
			empDeptMultiVO.setGroupSeq(loginVO.getGroupSeq());
		}
		
		boolean bool = false;
		
		Map<String,Object> paramsMap = new HashMap<String, Object>();
		
		paramsMap.put("compSeq", compSeq);
		paramsMap.put("empSeq", empSeq);
		paramsMap.put("groupSeq", params.get("groupSeq"));
		paramsMap.put("langCode", params.get("langCode"));
		paramsMap.put("deptSeq", deptSeqNew);
		paramsMap.put("oldDeptSeq", params.get("deptSeq"));
		paramsMap.put("flagMainDeptYn", "Y");
		

		Map<String,Object> sListMap = empManageService.selectEmpInfo(paramsMap, new PaginationInfo());
		
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> list = (List<Map<String, Object>>) sListMap.get("list");	
		
		/** update */
		if (deptSeq.equals(deptSeqNew) && list != null && list.size() > 0) {
			if(!params.get("oldMainDeptYn").toString().equals(params.get("mainDeptYn").toString())){
				//주부서 등록시 해당회사에 다른 주부서가 존재하는지 체크 
				if(params.get("mainDeptYn") != null){
					if(params.get("mainDeptYn").toString().equals("N")){
						int mainDeptCnt = empDeptManageService.checkMainDept(params);
						//기존 주부서는 부부서로 변경.
						if(mainDeptCnt != 0){
							result = "-1";
							return result;
						}
					}
					if(params.get("mainDeptYn").toString().equals("Y")){
						int mainDeptCnt = empDeptManageService.checkMainDept(params);
						//기존 주부서는 부부서로 변경.
						if(mainDeptCnt != 0){
							empDeptManageService.setMainDept(params);
						}
						commonSql.update("CompManage.updateEmpAuthMainDept", params);
					}
				}
			}			
			
			bool = OrgChartSupport.getIOrgEditService().UpdateEmpDept(empDeptVO);
			if (bool) {
				bool = OrgChartSupport.getIOrgEditService().UpdateEmpDeptMulti(empDeptMultiVO);
				result = "success.common.update";
			} else {
				result = "fail.common.update";
			}
		} 
		/** insert delete */
		else {
			//추가하는 부서가 이미 추가되어있는 부서인지 확인.
			int empDeptCnt = empDeptManageService.checkEmpDeptInfo(params);
			if(empDeptCnt != 0){
				result = "-3";
				return result;
			}
			
			
			
			if (EgovStringUtil.isEmpty(deptSeq)) {
				//주부서 등록시 해당회사에 다른 주부서가 존재하는지 체크 
				if(params.get("mainDeptYn") != null){
					if(params.get("mainDeptYn").toString().equals("Y")){
						int mainDeptCnt = empDeptManageService.checkMainDept(params);
						//기존 주부서는 부부서로 변경.
						if(mainDeptCnt != 0){
							empDeptManageService.setMainDept(params);
						}
					}
					if(params.get("mainDeptYn").toString().equals("N")){
						int mainDeptCnt = empDeptManageService.checkMainDept(params);
						//부부서 등록시 해당 회사에 주부서가 존재 하지 않으면 등록 불가.
						if(mainDeptCnt == 0){
							result = "-2";
							return result;
						}
					}
				}
			}
			
			if(!compSeq.equals(params.get("compSeqOld")+"")){
				//주부서 등록시 해당회사에 다른 주부서가 존재하는지 체크 
				if(params.get("mainDeptYn") != null){
					if(params.get("mainDeptYn").toString().equals("Y")){
						int mainDeptCnt = empDeptManageService.checkMainDept(params);
						//기존 주부서는 부부서로 변경.
						if(mainDeptCnt != 0){
							empDeptManageService.setMainDept(params);
						}
					}
					if(params.get("mainDeptYn").toString().equals("N")){
						int mainDeptCnt = empDeptManageService.checkMainDept(params);
						//부부서 등록시 해당 회사에 주부서가 존재 하지 않으면 등록 불가.
						if(mainDeptCnt == 0){
							result = "-2";
							return result;
						}
					}
				}
			}
			
			empDeptVO.setUseYn("Y");
			if(params.get("mainDeptYn") != null) {
				empDeptVO.setMainDeptYn(params.get("mainDeptYn").toString());
			}
			empDeptMultiVO.setUseYn("Y");
			
			empDeptVO.setDeptSeq(deptSeqNew);
			empDeptMultiVO.setDeptSeq(deptSeqNew);
			
			
			Map<String, Object> paraMap = new HashMap<String, Object>();
			paraMap.put("empSeq", empDeptVO.getEmpSeq());
			paraMap.put("deptSeq", deptSeq);
			
			Map<String, Object> infoMap = (Map<String, Object>) commonSql.select("EmpDeptManage.getEmpDept", paraMap);
			
			if(infoMap != null){
				if(infoMap.get("orderNum") != null && !infoMap.get("orderNum").toString().equals("")) {
					empDeptVO.setOrderNum(infoMap.get("orderNum").toString());
				}
				else {
					empDeptVO.setOrderNum("100");
				}
			}else{
				empDeptVO.setOrderNum("100");
			}
			
			
			bool = OrgChartSupport.getIOrgEditService().InsertEmpDept(empDeptVO);
			
			if (bool) {
				bool = OrgChartSupport.getIOrgEditService().InsertEmpDeptMulti(empDeptMultiVO);
			}
			

			if (bool && !EgovStringUtil.isEmpty(deptSeq)) {
				
				empDeptManageService.deleteEmpDept(params);
				
				if(params.get("compSeqOld") != null){
					String compSeqOld = params.get("compSeqOld")+"";
					
					//기존 권한 삭제후 기본권한 재 부여.
					empDeptManageService.deleteEmpAuth(params);	//부서권한만 삭제
					if(params.get("mainDeptYn").toString().equals("Y")){						
						empDeptManageService.updateEmpAuthor(params); // 기존 권한 변경된 dept_seq로 update
						params.put("deptSeq", deptSeqNew);
						params.put("deptAuth", "Y");
						empDeptManageService.insertBaseAuth(params);
					}

				}				
			}
			
			if (bool && EgovStringUtil.isEmpty(deptSeq) && !EgovStringUtil.isEmpty(deptSeqNew)){				
				params.put("deptSeq", deptSeqNew);
				if(!params.get("mainDeptYn").toString().equals("Y") || loginVO.getEaType().equals("ea")){
					empDeptManageService.insertBaseAuth(params);
				}
				else{
					//신규등록하는 부서가 주부서일 경우
					//해당 회사에 부서가 하나도 존재 하지 않으면 기본부여권한만 추가
					//해당 회사에 기존 주부서가 존재하면 기본부여권한의 부서권한만 추가.
					String empInfoCnt = (String) commonSql.select("CompManage.getEmpInfoList", params);
					if(!empInfoCnt.equals("1")){
						params.put("deptAuth", "Y");
						commonSql.update("CompManage.updateEmpAuthDept", params);
					}
					empDeptManageService.insertBaseAuth(params);					
				}
				
				
			}
			
			deptSeq = deptSeqNew;
			params.put("deptSeq", deptSeq);
			if (bool) {
				result = "success.common.insert";
			} else {
				result = "fail.common.insert";
				return result;
			}
		}
		
		//사원부서정렬텍스트 업데이트 (t_co_emp_dept -> order_text)
		commonSql.update("EmpDeptManage.updateEmpDeptOrderText", params);
		
		
		
		//메신저표시여부(t_co_emp_dept)가 Y일 경우 개인정보(t_co_emp)에 메신저사용여부 Y로 셋팅
		if(params.get("messengerDisplayYn").toString().equals("Y")){
			empDeptManageService.updateMessengerUseYn(params);
		}		
		
		//주부서일 경우 겸직부서 재직상태(t_co_emp_comp) insert/update
		
		if(params.get("mainDeptYn") != null){
			if(params.get("mainDeptYn").toString().equals("Y")){
				String tempCompSeq = "";
				if(params.get("compSeq") != null){
					if(!params.get("compSeq").toString().equals("") && !params.get("compSeq").toString().equals(params.get("compSeqOld").toString())){
						tempCompSeq = params.get("compSeqOld").toString();
						params.put("compSeqOld", params.get("compSeq").toString());
					}
				}
				Map<String,Object> erpMap = compService.getErpEmpInfo(params);
				if(params.get("erpEmpNum") != null){
					if(params.get("erpEmpNum").toString().equals("")) {
						params.put("erpEmpNum", null);
					}
				}
				if(params.get("checkWorkYn") != null){
					params.put("checkWork", params.get("checkWorkYn"));
				}				
				
				if(params.get("deptSeqNew") != null){
					if(!params.get("deptSeqNew").toString().equals("")){
						params.put("deptSeq", params.get("deptSeqNew").toString());
					}
				}
				
				if(erpMap != null){		
					if(params.get("compSeq") != null){
						if(!params.get("compSeq").toString().equals("")){
							params.put("compSeqOld", tempCompSeq);
							
							paramsMap.put("compSeq", params.get("compSeqOld"));
							paramsMap.put("deptSeq", "");
							paramsMap.put("oldDeptSeq", "");							

							Map<String,Object> empListMap = empManageService.selectEmpInfo(paramsMap, new PaginationInfo());
							
							@SuppressWarnings("unchecked")
							List<Map<String,Object>> empList = (List<Map<String, Object>>) empListMap.get("list");	
							
							if(empList.size() == 0)	{
								params.put("compSeqOld", tempCompSeq);
								compService.deleteErpEmpInfo(params);
							}
						}
					}	
					if(params.get("deptSeqNew") != null){
						if(!params.get("deptSeqNew").toString().equals("")) {
							params.put("deptSeq", params.get("deptSeqNew"));
						}
					}					
					params.put("compSeqOld", params.get("compSeq"));
					compService.updateErpEmpInfo(params);
					
					//근태사용유무가 Y인 경우 다른 겸직회사의 근태사용유무 값 N으로 셋팅
					if((params.get("checkWork")+"").equals("Y")){
						compService.updateErpEmpCheckWorkInfo(params);
					}
				}
				else{
					if(params.get("compSeq") != null){
						if(!params.get("compSeq").toString().equals("")){
							params.put("compSeqOld", tempCompSeq);
							
							paramsMap.put("compSeq", params.get("compSeqOld"));
							paramsMap.put("deptSeq", "");
							paramsMap.put("oldDeptSeq", "");							

							Map<String,Object> empListMap = empManageService.selectEmpInfo(paramsMap, new PaginationInfo());
							
							@SuppressWarnings("unchecked")
							List<Map<String,Object>> empList = (List<Map<String, Object>>) empListMap.get("list");	
							
							if(empList.size() == 0){
								
								compService.deleteErpEmpInfo(params);
								
							}
						}
					}				
					params.put("useYn","Y");
					compService.insertErpEmpInfo(params);
					params.remove("useYn");
					
					//근태사용유무가 Y인 경우 다른 겸직회사의 근태사용유무 값 N으로 셋팅
					if((params.get("checkWork")+"").equals("Y")){
						compService.updateErpEmpCheckWorkInfo(params);
					}
				}
				
				
				//근무조 정보 변경(변경된 부서로 변경)
				Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("empSeq", empSeq);
				mp.put("compSeq", params.get("compSeq"));
				mp.put("newDeptSeq", params.get("deptSeqNew"));	
				mp.put("oldDeptSeq", oldDeptSeq);
				//mp.put("", value)
				
				commonSql.update("EmpDeptManage.UpdateWorkTeam", mp);
				commonSql.update("EmpDeptManage.UpdateWorkTeamHistory", mp);
				commonSql.update("EmpDeptManage.UpdateAttRegulate", mp);
				commonSql.update("EmpDeptManage.UpdateAccessEmpInfo", mp);
			}
			else{
				paramsMap.put("compSeq", params.get("compSeqOld"));
				paramsMap.put("deptSeq", "");
				paramsMap.put("oldDeptSeq", "");							

				Map<String,Object> empListMap = empManageService.selectEmpInfo(paramsMap, new PaginationInfo());
				
				@SuppressWarnings("unchecked")
				List<Map<String,Object>> empList = (List<Map<String, Object>>) empListMap.get("list");	
				if(empList.size() == 0) {
					compService.deleteErpEmpInfo(params);
				}
			}
		}
		
		
		//기본 로그인회사의 주부서(부부서가 존재하지 않는)를 다른회사로 겸직처리 했을때
		//기본 로그인회사 정보 변경(t_co_emp 테이블 main_comp_seq 컬럼)
		if(params.get("mainCompSeqChangeYn") != null){
			if(params.get("mainCompSeqChangeYn").toString().equals("Y")){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("empSeq", params.get("empSeq") + "");
				map.put("mainCompSeqOld", params.get("compSeqOld") + "");
				map.put("mainCompSeq", params.get("compSeq") + "");
				
				empDeptManageService.setEmpMainCompSeq(map);
			}
		}
			
		
		return result;
	}
	
	@RequestMapping("/cmm/systemx/empDeptInfoSaveProcAjax.do")
	public ModelAndView empDeptInfoSaveProcAjax(@RequestParam Map<String,Object> params, HttpServletRequest request, 
			EmpDeptVO empDeptVO, EmpDeptMultiVO empDeptMultiVO) throws Exception {
		
		ModelAndView mv = new ModelAndView(); 
		
		String result = empDeptInfoSave(params, empDeptVO, empDeptMultiVO);
		
		mv.addObject("result", egovMessageSource.getMessage(result));
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@IncludedInfo(name="사원부서연결", order = 160 ,gid = 60)
	@RequestMapping("/systemx/empDeptManageView.do")
    public ModelAndView empDeptManageView(@RequestParam Map<String,Object> params, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		params.put("myCompSeq", loginVO.getCompSeq());
		String compSeq = params.get("compSeq") + "";
//		
		if(!loginVO.getUserSe().equals("MASTER")){
			if (EgovStringUtil.isEmpty(compSeq)) {
				compSeq = loginVO.getCompSeq();	
			}	
		}
		
		params.put("compSeq", compSeq);
		
		//request.setAttribute("compSeq", compSeq);
		
		String groupSeq = params.get("groupSeq")+"";
		params.put("langCode", loginVO.getLangCode());
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
//		params.put("dpType", "DUTY");
//		List<Map<String,Object>> dutyList = compService.getCompDutyPositionList(params);
//		for(Map<String,Object> map : dutyList) {
//			map.put("deptDutyCode", map.get("dpSeq"));
//			map.put("deptDutyCodeName", map.get("dpName"));
//		}
//		
//		params.put("dpType", "POSITION");
//		List<Map<String,Object>> positionList = compService.getCompDutyPositionList(params);
//		for(Map<String,Object> map : positionList) {
//			map.put("deptPositionCode", map.get("dpSeq"));
//			map.put("deptPositionCodeName", map.get("dpName"));
//		}
//		
//		mv.addObject("dutyList", JSONArray.fromObject(dutyList));
//		mv.addObject("positionList", JSONArray.fromObject(positionList));
		
		/** 관리자 권하을 갖고 있는 회사정보 가져오기 */
		List<Map<String,Object>> compList = null;
		String userSe = loginVO.getUserSe();
		params.put("userSe", userSe);
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			
			if (userSe.equals("ADMIN")) {
				params.put("empSeq", loginVO.getUniqId());
				compList = compService.getCompListGroupping(params);
			}else if(userSe.equals("MASTER")){
				compList = compService.getCompListAuth(params);
			}
			
//			String compSeqList = "";
//			for(int i = 0; i < compList.size(); i++) {
//				compSeqList += "'"+compList.get(i).get("compSeq")+"'";
//				if (i < compList.size()-1) {
//					compSeqList += ",";
//				}
//			}
//			
//			params.put("compSeqList", compSeqList);
			JSONArray json = JSONArray.fromObject(compList);
			mv.addObject("compListJson", json);
		}
		
		/** 관리자모드에서 조직도를 보여줄때 권한을 갖고 있는 회사만 가져오기  */
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		mv.addObject("groupMap", groupMap);
		
		List<Map<String,Object>> list = orgChartService.selectCompBizDeptList(params);
		
//		System.out.println(list);
		
		List<OrgChartNode> pList = new ArrayList<OrgChartNode>();
		
		String bizSeq = "";
		String deptSeq = "";
		
		/** 회사시퀀스가 처리 */
		String reqCompSeq = params.get("compSeq")+"";
		String compName = null;
		for(Map map : list) {
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
				parentSeq = groupSeq;
			} else {
				parentSeq = pathArr[pathArr.length-2];
			}
			
			if (EgovStringUtil.isEmpty(reqCompSeq)) {
				pList.add(new OrgChartNode(groupSeq, bizSeq, compSeq, deptSeq, seq, parentSeq, name, gbnOrg));
			} else {
				String c =  String.valueOf(map.get("compSeq"));
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
			menu = new OrgChartTree(groupSeq, "0", groupMap.get("groupName")+"", "g");
		} else {
			menu = new OrgChartTree(reqCompSeq, "0", compName, "c");
		} 
		
		menu.addAll(pList);

		JSONObject json = JSONObject.fromObject(menu.getRoot());
		
//		System.out.println(json);
		
		/* 2017.05.29 장지훈 추가 (직급/직책 옵션값 추가)
		 * positionDutyOptionValue = 0 : 직급 (default)
		 * positionDutyOptionValue = 1 : 직책
		 * */
		String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1900");
		String displayPositionDuty = "";
		
		
		if(positionDutyOptionValue == null) {
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("0")){
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("1")) {
			displayPositionDuty = "duty";
		}

		mv.addObject("displayPositionDuty", displayPositionDuty);
		
		mv.addObject("orgChartList", json);
		
//		OrgChartController occ = new OrgChartController();
//		mv.addObject("orgChartList", occ.orgChartList(params, response).getModelMap().get("orgChartList"));
		
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}
		
		
		mv.setViewName("/neos/cmm/systemx/empdept/empDeptManageView");
		mv.addObject("loginVO", loginVO);
		mv.addObject("params", params);
		return mv;		
	}
	
	@RequestMapping("/cmm/systemx/empDeptData.do")
	public void empDeptData(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {

		response.setCharacterEncoding("UTF-8");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("langCode", loginVO.getLangCode());
		
		String groupSeq = params.get("groupSeq")+"";
		
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		Map<String,Object> listMap = empManageService.selectEmpInfo(params, new PaginationInfo());
	
		if (listMap != null) {
			List<Map<String,Object>> list = (List<Map<String, Object>>) listMap.get("list");
			JSONArray jsonArr = JSONArray.fromObject(list);
			response.getWriter().write(jsonArr.toString());
			response.getWriter().flush();
		}
	 
	}
	
	@RequestMapping("/cmm/systemx/empDeptInfo.do")
	public ModelAndView empDeptInfo(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("langCode", loginVO.getLangCode());
		
//		String compSeq = params.get("compSeq")+"";
		String groupSeq = params.get("groupSeq")+"";
		
//		if (EgovStringUtil.isEmpty(compSeq)) {
//			params.put("compSeq", loginVO.getCompSeq());
//		}
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		String empSeq = params.get("empSeq")+"";
		
		if (!EgovStringUtil.isEmpty(empSeq)) {
			Map<String,Object> listMap = empManageService.selectEmpInfo(params, new PaginationInfo());
			Map<String,Object> tempList = new HashMap<String,Object>();		// 한번 불러온 회사 직급,직책 정보 저장

			if (listMap != null) {
				List<Map<String,Object>> list = (List<Map<String, Object>>) listMap.get("list");
				mv.addObject("deptInfoList", list);

				/** 직급 직책 리스트 조회. 회사마다 다름. */
				if (list != null) {
					for(Map<String,Object> map : list) {
						Map<String,Object> p = new HashMap<String, Object>();
						p.put("langCode", loginVO.getLangCode());
						p.put("compSeq", map.get("compSeq"));
						p.put("groupSeq", groupSeq);

						p.put("dpType", "DUTY");
						if (tempList.get(map.get("compSeq")+"_DUTY") == null) {		// 조회한 직급,직책인지 확인
							List<Map<String,Object>> d = dutyPositionService.getCompDutyPositionList(p);
							map.put("dutyList", d);
							tempList.put(map.get("compSeq")+"_DUTY", d);
						} else {
							map.put("dutyList", tempList.get(map.get("compSeq")+"_DUTY"));
						}

						p.put("dpType", "POSITION");
						if (tempList.get(map.get("compSeq")+"_POSITION") == null) {	// 조회한 직급,직책인지 확인
							List<Map<String,Object>> l = dutyPositionService.getCompDutyPositionList(p);
							map.put("positionList", l);
							tempList.put(map.get("compSeq")+"_POSITION", l);
						} else {
							map.put("positionList", tempList.get(map.get("compSeq")+"_POSITION"));
						}

					}
				}
			}
		}
		
		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/systemx/empdept/include/empDeptInfo");
		
		return mv;
	 
	}
	
	
	@RequestMapping("/cmm/systemx/getPositionDutyListJson.do")
	public ModelAndView getPositionDutyListJson(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("langCode", loginVO.getLangCode());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("dpType", "DUTY");
		List<Map<String,Object>> list = dutyPositionService.getCompDutyPositionList(params);

		List<Map<String,Object>> dutyList = new ArrayList<Map<String,Object>>();
		String type = params.get("dpType")+"";
		for(Map<String,Object> map : list) {
			map.put("deptDutyCode", map.get("dpSeq"));
			map.put("deptDutyCodeName", map.get("dpName"));
			dutyList.add(map);
		}

		params.put("dpType", "POSITION");
		list = dutyPositionService.getCompDutyPositionList(params);
		List<Map<String,Object>> posList = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> map : list) {
			map.put("deptPositionCode", map.get("dpSeq"));
			map.put("deptPositionCodeName", map.get("dpName"));
			posList.add(map);
		}

		mv.addObject("dutyList", JSONArray.fromObject(dutyList));
		mv.addObject("posList", JSONArray.fromObject(posList));

		mv.setViewName("jsonView");

		return mv;
		
	 
	}
	
	/**
	 * 직급, 또는 직책 리스트 조회
	 * @param params
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/getCompDPListJson.do")
	public ModelAndView getCompDPListJson(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String mode = params.get("mode")+""; 
		
		LoginVO loginVO = null;
		String compSeq = params.get("compSeq")+"";
		String groupSeq = params.get("groupSeq")+"";
		String langCode = params.get("langCode")+"";
		
		if (mode.equals("dev")) {
			loginVO = new LoginVO();
			loginVO.setGroupSeq(groupSeq);
			loginVO.setCompSeq(compSeq);
			loginVO.setLangCode(langCode);
		} else {
			loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		}
		
		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		params.put("langCode", loginVO.getLangCode());
		List<Map<String,Object>> list = dutyPositionService.getCompDutyPositionList(params);

		mv.addObject("list", JSONArray.fromObject(list));

		mv.setViewName("jsonView");

		return mv;
		
	 
	}
	
	@RequestMapping("/cmm/systemx/empDeptInfoJson.do")
	public ModelAndView empDeptInfoJson(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("langCode", loginVO.getLangCode());
		
		
		
		mv.setViewName("jsonView");
		
		return mv;
		
		
	}
	
	
	@RequestMapping("/cmm/systemx/ExEmpPop.do")
	public ModelAndView ExEmpPop(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		mv.addAllObjects(params);
		
		mv.setViewName("/neos/cmm/systemx/empdept/pop/ExEmpPop");
		
		return mv;
		
		
	}
	
	
	
	
	@ExceptionHandler(IllegalArgumentException.class)
	@RequestMapping("/cmm/systemx/getExEmpList.do")
	public ModelAndView getExEmpList(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		//erp회사 리스트 조회.
		ServletContext sc = request.getSession().getServletContext();
		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
		
		
		
		try {
			String driver = "";
			String url = "";
			String dataBaseType = "";
			String systemType = "";
			String userid = "";
			String password = "";
			
			/*ex 시스템정보 */
			//params.put("groupSeq", loginVO.getGroupSeq());
			List<Map<String, Object>> list = compService.getErpConList(params);
			
			if(list.size() != 0){
				driver = list.get(0).get("driver") + "";
				url = list.get(0).get("url") + "";
				dataBaseType = list.get(0).get("databaseType") + "";
				systemType = list.get(0).get("erpTypeCode") + "";
				userid = list.get(0).get("userid") + "";
				password = list.get(0).get("password") + "";	
				
				params.put("erpCompSeq", list.get(0).get("erpCompSeq"));
				
				//erp서버 정보 가져오기.
				conVo.setDriver(driver);
				conVo.setUrl(url);			
				conVo.setDatabaseType(dataBaseType);
				conVo.setSystemType(systemType);
				conVo.setUserId(userid);
				conVo.setPassWord(password);
				
				String serviceName = "ExCodeOrg"+conVo.getSystemType()+"Service";
				
				ExCodeOrgService exCodeOrgService = (ExCodeOrgService)act.getBean(serviceName);
				params.put("loginVO", loginVO);	
				
				// 조회
				List<Map<String, Object>> aaData = exCodeOrgService.getExEmpList(params, loginVO, conVo);

				// 반환처리
				mv.addObject("empList", aaData);
			}
			else {
				mv.addObject("result", BizboxAMessage.getMessage("TX000011769","ERP연결 정보가 존재하지 않습니다"));
			}
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		mv.setViewName("jsonView");
		
		return mv;
		
		
	}
	
	
	
	
	
	
	
	@RequestMapping("/cmm/systemx/getEmpErpInfo.do")
	public ModelAndView getEmpErpInfo(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> erpMap = compService.getErpEmpInfo(params);
		params.put("compSeq", params.get("compSeqOld"));	
		int empDeptCnt = (int) commonSql.select("EmpDeptManage.checkMainDept2", params);		
		int empDeletCheckCnt = (int) commonSql.select("EmpDeptManage.empDeletCheckCnt", params);
		
		Map<String, Object> empDeptMap = empDeptManageService.selectEmpDeptInfo(params);
		
		//주회사여부 가져오기
		String mainCompYn = empDeptManageService.getMainCompYn(params);
		
		//선택회사의 주부서 시퀀스 가져오기
		String mainDeptSeq = empDeptManageService.getMainDeptSeq(params);
		
		mv.addObject("empDeptCnt", empDeptCnt);
		mv.addObject("empDeletCheckCnt", empDeletCheckCnt);
		mv.addObject("erpMap", erpMap);
		mv.addObject("mainCompYn", mainCompYn);
		mv.addObject("mainDeptSeq", mainDeptSeq);
		mv.addObject("messengerDisplayYn", empDeptMap == null ? "" : empDeptMap.get("messengerDisplayYn"));
		
		mv.setViewName("jsonView");
		
		return mv;
		
		
	}
	
	
	@RequestMapping("/cmm/systemx/checkMessengerUseYn.do")
	public ModelAndView checkMessengerUseYn(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		empDeptManageService.setMessengerDisplayYn(params);
						
		List<Map<String, Object>> list = compService.checkMessengerUseYn(params);
		
		int checkCnt = 0;
		
		if(params.get("value").equals("N")) {
			
			for(Map<String,Object> map : list){
				if(map.get("messengerDisplayYn") != null){
					if(map.get("messengerDisplayYn").toString().equals("N")) {
						checkCnt++;
					}
				}
			}
			
			if(list.size() == checkCnt) {
				mv.addObject("result", "Y");
			}
			else {
				mv.addObject("result", "N");
			}
			
		} else if(params.get("value").equals("Y")) {
			
			params.put("groupSeq", loginVO.getGroupSeq());
			Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmp", params);
												
			for(Map<String,Object> map : list){
				if(map.get("messengerDisplayYn") != null){
					if(map.get("messengerDisplayYn").toString().equals("Y")) {
						checkCnt++;
					}
				}
			}
			
			if(checkCnt == 1 && (empInfo.get("messengerUseYn") != null && empInfo.get("messengerUseYn").equals("N"))) {
				mv.addObject("result", "Y");
			}
			else {
				mv.addObject("result", "N");
			}
		}
					
		mv.setViewName("jsonView");		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/updateEmpMessengerUse.do")
	public ModelAndView updateEmpMessengerUse(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		empDeptManageService.updateMessengerUseYn(params);
			
		mv.setViewName("jsonView");		
		return mv;
		
	}
	
	
	@RequestMapping("/cmm/systemx/setMessengerUseYn.do")
	public ModelAndView setMessengerUseYn(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(params.get("value") != null){
			if(params.get("value").toString().equals("N")){
				empDeptManageService.setMessengerUseYn(params);
			}
			else if(params.get("value").toString().equals("Y")){
				empDeptManageService.setMessengerUseYnMainDept(params);
			}
		}
		
		
	
		mv.setViewName("jsonView");		
		return mv;
		
	}
	
	@RequestMapping("/cmm/systemx/getExEmpNoList.do")
	public ModelAndView getExEmpNoList(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("langCode", loginVO.getLangCode());
		Map<String, Object> mp = (Map<String, Object>) commonSql.select("EmpManage.selectExEmpErpNoList",params);
		
		mv.addObject("result", mp);
	
		mv.setViewName("jsonView");		
		return mv;
		
	}
	
	
	
	
	@RequestMapping("/cmm/systemx/erpEmpNoCheckPop.do")
	public ModelAndView erpEmpNoCheckPop(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("empInfo", params.get("empInfo"));
		
		mv.setViewName("/neos/cmm/systemx/empdept/pop/erpEmpNoCheckPop");
		
		return mv;				
	}
	
}
