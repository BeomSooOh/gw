package neos.cmm.erp.orgchart.controller;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.jdbc.ScriptRunner;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.erp.dao.ErpOrgchartDAO;
import neos.cmm.erp.dao.ErpOrgchartDAOCreator;
import neos.cmm.erp.orgchart.service.ErpOrgchartSyncService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CollectionUtils;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import neos.cmm.util.code.service.SequenceService;
import neos.cmm.util.code.service.impl.CommonCodeDAO;
import net.sf.json.JSONArray;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;

@Controller
public class ErpSyncOrgchartController {
//	private Logger logger = Logger.getLogger(this.getClass());
	private static Log logger = LogFactory.getLog(ErpSyncOrgchartController.class);
	
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "ErpOrgchartSyncService")
	private ErpOrgchartSyncService erpOrgchartSyncService;
	
	@Resource(name = "CommonCodeDAO")
	private CommonCodeDAO commonCodeDAO;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name = "SequenceService")
	private SequenceService sequenceService;
	
	@Resource(name = "CommonOptionManageService")
	private CommonOptionManageService commonOptionManageService;
	
	@Resource(name = "LicenseService")
	private LicenseService licenseService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="OrgAdapterService")
	OrgAdapterService orgAdapterService;	
	
	private Map<String, Object> getErpDbInfo(Map<String, Object> params) {
		@SuppressWarnings("unchecked")
		Map<String,Object> erpDbInfo = (Map<String, Object>) commonSql.select("ErpManageDAO.selectErpInfo", params);

		return erpDbInfo;
		
	}
	
	@SuppressWarnings("unchecked")
	@IncludedInfo(name="ERP조직도연동설정", order = 260 ,gid = 60)
	@RequestMapping(value="/erp/orgchart/erpSyncDetailView.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncDetailList(HttpServletRequest request, HttpServletResponse response, 
			@RequestParam Map<String,Object> params, RedirectAttributes ra) {
		logger.info("erpSyncDetailList  params : " + params);

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());

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
		
		String compSeq = params.get("compSeq")+"";
		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
			compSeq = loginVO.getCompSeq();
		}
		
		params.put("langCode", loginVO.getLangCode());
		
		/** Erp 동기화 상세 리스트 조회  */
		PaginationInfo paginationInfo = new PaginationInfo();
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int pageSize = EgovStringUtil.zeroConvert(params.get("pageSize"));
		if (page == 0) {
			page = 1;
		}
		if (pageSize == 0) {
			pageSize = 10;
		}
		
		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(pageSize);
		paginationInfo.setRecordCountPerPage(10); 
		
		
		params.put("syncStatus", "C");
		Map<String,Object>  detailListInfo = erpOrgchartSyncService.selectErpSyncDetailList(params, paginationInfo);
		
		List<Map<String,Object>> detailList = (List<Map<String,Object>>)detailListInfo.get("list");
		List<Map<String, Object>> realDetailList = new ArrayList<Map<String, Object>>();
		
		for(Map<String, Object> temp : detailList) {
			if(temp.get("syncDate") != null) {
				realDetailList.add(temp);
			}
		}
		
		//자동동기화 설정값 조회
		params.put("selectCompSeq", compSeq);
		Map<String, Object> autoSyncInfo = (Map<String, Object>) commonSql.select("ErpOrgchartDAO.selectErpSyncAutoList", params);
		
		mv.addObject("detailList", realDetailList);
		mv.addObject("paginationInfo", paginationInfo);
		mv.addObject("autoSyncInfo", autoSyncInfo);
		
		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/erp/orgchart/erpSyncDetailView");

		return mv;
	}

	@RequestMapping(value="/erp/orgchart/pop/erpSyncAutoSetPop.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncAutoSetPop(HttpServletRequest request, HttpServletResponse response, 
			@RequestParam Map<String,Object> params, RedirectAttributes ra) {
		logger.info("erpSyncAutoSetPop  params : " + params);

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());

		/** 회사 리스트 조회 */
		List<Map<String,Object>> erpSyncAutoList = null;
		erpSyncAutoList = erpOrgchartSyncService.selectErpSyncAutoList(params);
		
		if(erpSyncAutoList.size() > 0) {
			mv.addObject("erpSyncAuto", "Y");
			mv.addObject("erpSyncAutoList", erpSyncAutoList.get(0));
		} else {
			mv.addObject("erpSyncAuto", "N");
		}
		
		mv.addObject("compSeq", params.get("selectCompSeq").toString());
		mv.setViewName("/neos/cmm/erp/orgchart/pop/erpSyncAutoSetPop");

		return mv;
	}
	
	@RequestMapping(value="/erp/orgchart/pop/erpSyncAutoSetSave.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncAutoSetSave(HttpServletRequest request, HttpServletResponse response, 
			@RequestParam Map<String,Object> params, RedirectAttributes ra) {
		logger.info("erpSyncAutoSetPop  params : " + params);

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("empSeq", loginVO.getUniqId());
		
		try{
			if(params.get("saveFlag").toString().equals("insert")) {
				erpOrgchartSyncService.insertErpSyncAutoList(params);
			} else if(params.get("saveFlag").toString().equals("update")) {
				erpOrgchartSyncService.updateErpSyncAutoList(params);
			}
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	@SuppressWarnings("null")
	@IncludedInfo(name="ERP 연동 기초 설정", order = 261 ,gid = 60)
	@RequestMapping(value="/erp/orgchart/erpSyncBaseDataSetPop.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncBaseDataSetPop(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		logger.info("erpSyncBaseDataSetPop  params : " + params);

		String groupSeq = params.get("groupSeq")+"";
		String compSeq = params.get("compSeq")+"";
		
		if (!EgovStringUtil.isEmpty(params.get("selectCompSeq")+"")) {
			compSeq = params.get("selectCompSeq")+"";
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(compSeq)) {
			compSeq = loginVO.getCompSeq();
		}
		
		params.put("compSeq", compSeq);
		params.put("langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();
			
		// 인사
		params.put("achrGbn", "hr");
		Map<String,Object> dbInfo = getErpDbInfo(params);

		try{
			if (dbInfo != null) {
				params.put("erpType", dbInfo.get("erpType"));
				// ERP DAO 생성
				ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				params.put("cdCompany", dbInfo.get("erpCompSeq"));

				/** 근무구분 코드 조회 */
				// ERP 근무구분 코드 조회(사원 리스트에서 group by로 조회)
				List<Map<String,Object>> erpWorkCodeList = erpOrgchartDAO.selectErpEmpWorkCodeList(params);
				List<Map<String,Object>> syncWorkCodeList = erpOrgchartSyncService.selectErpSyncWorkCodeList(erpWorkCodeList, params);
				logger.debug("syncWorkCodeList : " + syncWorkCodeList);

				mv.addObject("syncWorkCodeList", syncWorkCodeList);
				
				/** 그룹웨어 근무구분 코드 조회 */
				params.put("code", "COM517");
				params.put("aliasCode", "gwCode");
				params.put("aliasName", "gwCodeName");
				
				List<Map<String,Object>> gwWorkCodeList = erpOrgchartSyncService.selectCommonCodeList(params);

				if(gwWorkCodeList == null) {
					Map<String,Object> dMap = new HashMap<>();
					dMap.put("gwCode", "999");
					dMap.put("gwCodeName", BizboxAMessage.getMessage("TX000010068","재직"));
					gwWorkCodeList.add(0, dMap);
				}
				
				
				mv.addObject("gwWorkCodeList", gwWorkCodeList);
				JSONArray gwWorkCodeListJson = JSONArray.fromObject(gwWorkCodeList);
				mv.addObject("gwWorkCodeListJson", gwWorkCodeListJson);

				/** 직군조회 */
				List<Map<String,Object>> regularCodeList = erpOrgchartDAO.selectErpJobCodeList(params);
				List<Map<String,Object>> dayCodeList = erpOrgchartDAO.selectErpJobCodeList(params);
				
				// 상용직 조회 
				params.put("codeType", "20");
				List<Map<String,Object>> syncRegularCodeList = erpOrgchartSyncService.selectErpSyncJobCodeList(regularCodeList, params);
				mv.addObject("syncRegularCodeList", syncRegularCodeList);
				
				// 일용직 조회 
				params.put("codeType", "30");
				List<Map<String,Object>> syncDayCodeList = erpOrgchartSyncService.selectErpSyncJobCodeList(dayCodeList, params);
				mv.addObject("syncDayCodeList", syncDayCodeList);
				
				// 직급직책 셋팅값 조회
				params.put("codeType", "40");
				List<Map<String,Object>> syncDutyPosiCodeList = erpOrgchartSyncService.selectSyncDutyPosiCodeList(params);
				mv.addObject("syncDutyPosiCodeList", syncDutyPosiCodeList);
				
				logger.debug("syncRegularCodeList : " + syncRegularCodeList);
				logger.debug("syncDayCodeList : " + syncDayCodeList);
				
				// 라이센스 리스트
				params.put("code", "COM530");
				params.put("aliasCode", "gwCode");
				params.put("aliasName", "gwCodeName");
				
				List<Map<String,Object>> licenseList = erpOrgchartSyncService.selectCommonCodeList(params);

				if (licenseList == null) {
					Map<String,Object> dMap = new HashMap<>();
					dMap.put("gwCode", "1");
					dMap.put("gwCodeName", BizboxAMessage.getMessage("TX000005020","그룹웨어"));
					licenseList.add(0, dMap);
				}
				
				mv.addObject("licenseList", licenseList);
				JSONArray licenseListJson = JSONArray.fromObject(licenseList);
				mv.addObject("licenseListJson", licenseListJson);

			} else {
				params.put("resultCode", "-1");
			}
			
			/** redirect 메세지 처리 */
			String resultCode = params.get("resultCode")+"";
			if (!EgovStringUtil.isEmpty(resultCode) && !resultCode.equals("-1")) {
				if (resultCode.equals("0")) {
					mv.addObject("msg", BizboxAMessage.getMessage("TX000022275","저장 되었습니다."));
				} else {
					mv.addObject("msg", BizboxAMessage.getMessage("TX000005212","저장 실패하였습니다."));
				}
				
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		


		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/erp/orgchart/pop/erpSyncBaseDataSetPop");

		return mv;
	}
	
	@RequestMapping(value="/erp/orgchart/erpSyncBaseDataSetPopSaveProc.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncBaseDataSetPopSaveProc(HttpServletRequest request, HttpServletResponse response, 
			@RequestParam Map<String,Object> params) {
		
		ModelAndView mv = new ModelAndView();
		String groupSeq = params.get("groupSeq")+"";
		String compSeq = params.get("compSeq")+"";
		String data = params.get("data")+"";
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if (!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(compSeq)) {

			ObjectMapper mapper = new ObjectMapper();

			Map<String, Object> map = new HashMap<String, Object>();

			try {
				map = mapper.readValue(data, Map.class);
				logger.debug("json data : " + map);
				
				map.put("groupSeq", groupSeq);
				map.put("compSeq", compSeq);
				map.put("editorSeq", loginVO.getUniqId());
				map.put("editorIp", CommonUtil.getClientIp(request));
				map.put("langCode", loginVO.getLangCode());
				params.put("langCode", loginVO.getLangCode());
				params.put("editorSeq", loginVO.getUniqId());

				if (map != null) {
					List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("codeList");
					if (list != null) {
						/** erp gw 맵핑 코드 모두 삭제(회사기준) */
						erpOrgchartSyncService.deleteErpSyncCodeList(params);
						
						params.put("achrGbn", "hr");
						Map<String,Object> dbInfo = getErpDbInfo(params);
						String erpType = dbInfo.get("erpType").toString();
						map.put("erpType", erpType);						
						
						erpOrgchartSyncService.insertErpSyncCodeList(map);
					}
				}
				
				/** 직급 / 직책  데이터 가져오기 */
				params.put("achrGbn", "hr");
				Map<String,Object> dbInfo = getErpDbInfo(params);
				if(dbInfo != null) {
					params.put("cdCompany", dbInfo.get("erpCompSeq"));
					ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
					
					params.put("codeType", "40");
					List<Map<String, Object>> list = commonSql.list("ErpOrgchartDAO.getDutyPosionOptionInfo", params);
					
					for(Map<String, Object> mp : list) {
						if(mp.get("gwCode").toString().equals("1")) {
							if(mp.get("erpCode").toString().equals("1")){
								params.put("erpIuPositionSet", "cdDutyStep");
							}else if(mp.get("erpCode").toString().equals("2")){
								params.put("erpIuPositionSet", "cdDutyResp");
							}else if(mp.get("erpCode").toString().equals("3")){
								params.put("erpIuPositionSet", "cdDutyRank");
							}
						}else if(mp.get("gwCode").toString().equals("2")) {
							if(mp.get("erpCode").toString().equals("1")){
								params.put("erpIuDutySet", "cdDutyStep");
							}else if(mp.get("erpCode").toString().equals("2")){
								params.put("erpIuDutySet", "cdDutyResp");
							}else if(mp.get("erpCode").toString().equals("3")){
								params.put("erpIuDutySet", "cdDutyRank");
							}
						}
					}
										
					/* 직책 */
					List<Map<String,Object>> dutyList = erpOrgchartDAO.selectErpDutyCodeList(params);
					if(dutyList != null) {
						params.put("dutyList", dutyList);
					}
					
					/* 직급 */
					List<Map<String,Object>> positionList = erpOrgchartDAO.selectErpPositionCodeList(params);
					if(positionList != null) {
						params.put("positionList", positionList);
						
					}
					
					params.put("erpType", dbInfo.get("erpType"));
					erpOrgchartSyncService.setCompDutyPosition(params);
				} 
			} catch (JsonParseException e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			} catch (JsonMappingException e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			} catch (IOException e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		mv.setViewName("jsonView");
		
		return mv;
		
	}
	
	@SuppressWarnings("unused")
	@IncludedInfo(name="ERP 조직도 동기화", order = 262 ,gid = 60)
	@RequestMapping(value="/erp/orgchart/erpSyncOrgchartDataSetPop.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncOrgchartDataSetPop(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		logger.info("erpSyncOrgchartDataSetPop  params : " + params);

		String groupSeq = params.get("groupSeq")+"";
		String compSeq = params.get("selectCompSeq")+"";
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(compSeq)) {
			compSeq = loginVO.getCompSeq();
		}
		
		params.put("langCode", loginVO.getLangCode());
		
//		params.put("compSeq","ICUBETEST");
//		params.put("compSeq","ES1");
		params.put("compSeq",compSeq);

		ModelAndView mv = new ModelAndView();

		params.put("achrGbn", "hr");
		Map<String,Object> dbInfo = getErpDbInfo(params);
		params.put("cdCompany", dbInfo.get("erpCompSeq"));

		if (dbInfo != null) { 

			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);

			/** 동기화 시작 시간 조회 */
			String erpSyncTime = erpOrgchartDAO.selectErpCurrentTime();
			params.put("endSyncTime", erpSyncTime);	// 2016-11-25 08:40:44

			String orgSyncDate = dbInfo.get("orgSyncDate")+"";
			if (EgovStringUtil.isEmpty(orgSyncDate)) {
				orgSyncDate = "2000-01-01 00:00:00";
				params.put("firstYn", "Y");
			} else {
				params.put("firstYn", "N");
			} 

			params.put("startSyncTime", orgSyncDate);	// 동기화 마지막 일자
			params.put("erpType", dbInfo.get("erpType"));

		} else {
			params.put("resultCode", "-1");
		}
		
		/** redirect 메세지 처리 */
		
		String resultCode = params.get("resultCode")+"";
		if (!EgovStringUtil.isEmpty(resultCode) && !resultCode.equals("-1")) {
			//MessageUtil.getRedirectMessage(mv, request, messageKey);
		}
		
		/** ERP 사원정보를 그룹웨어로 동기화시 신규 입사자 로그인 ID 생성 규칙 조회 */
		String optionValue = getCmmOptionValue(compSeq, "cm1102");
		
		if (optionValue != null && !optionValue.equals("0")) {
			params.put("loginIdType", optionValue); //1:erp 사원번호, 2: 이메일
		} else {
			params.put("loginIdType", "1");	// 설정 안되어 있을경우 erp 사원번호 기본값
		}

		mv.addObject("params", params);

		mv.setViewName("/neos/cmm/erp/orgchart/pop/erpSyncOrgchartDataSetPop");

		return mv;
	}
	
	@RequestMapping("/erp/orgchart/erpDeptOrgchartListJT.do")
	public ModelAndView erpDeptOrgchartListJT(@RequestParam Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 response.setContentType("text/html;charset=UTF-8"); 
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> groupMap = new HashMap<String, Object>();
		List<Map<String, Object>> tree = new ArrayList<Map<String,Object>>();
		
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
			
			
			if(params.get("groupSeq") == null) {
				params.put("groupSeq", loginVO.getGroupSeq());
			}
			
			if(params.get("compSeq") == null) {
				params.put("compSeq", loginVO.getCompSeq());
			}
			
			// 인사
			params.put("achrGbn", "hr");
			Map<String,Object> dbInfo = getErpDbInfo(params);

			if (dbInfo != null) {
				// ERP DAO 생성
				ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				params.put("cdCompany", dbInfo.get("erpCompSeq"));
				
				List<Map<String,Object>> orgList = new ArrayList<>();
				
				List<Map<String,Object>> erpCompList = erpOrgchartDAO.selectErpCompList(params);
				logger.debug("erpCompList : " + erpCompList);
				if(erpCompList != null) {
					orgList.addAll(erpCompList);
				}
			
				params.remove("saveYn");
				List<Map<String,Object>> erpBizList = erpOrgchartDAO.selectErpBizList(params);
				logger.debug("erpBizList : " + erpBizList);
				if(erpBizList != null) {
					orgList.addAll(erpBizList);
				}

				List<Map<String,Object>> erpDeptList = erpOrgchartDAO.selectErpDeptList(params);
				logger.debug("erpDeptList : " + erpDeptList);
				if(erpDeptList != null) {
					orgList.addAll(erpDeptList);
				}

				params.put("isCompPath", "Y"); //  path 정보에 회사부터 시작하도록 
				List<Map<String,Object>> erpDeptPathList = erpOrgchartDAO.selectErpDeptPathList(params);
				
				Map<String,Object> pathInfo = CollectionUtils.getListToMap(erpDeptPathList, "deptSeq");
				
				tree = erpOrgchartSyncService.getErpdeptOrgchartListJT(orgList,pathInfo, params);
			}
		
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		mv.addObject("treeData", tree);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("/erp/orgchart/erpTempDeptOrgchartListJT.do")
	public ModelAndView erpTempDeptOrgchartListJT(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<Map<String, Object>> tree = new ArrayList<Map<String,Object>>();
		
		try {
			
			//관리자일경우 자신이 속한 회사로 조회, 마스터일 경우 선택한 회사를 조회
			if(loginVO.getUserSe().equals("ADMIN")){
				params.put("compSeq", loginVO.getCompSeq());
			}
			
			if(params.get("langCode") == null || params.get("groupSeq") == null) {
				params.put("langCode", loginVO.getLangCode());
				params.put("groupSeq", loginVO.getGroupSeq());			
			}
			
			tree = erpOrgchartSyncService.getErpdeptOrgchartTempListJT(params);
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		mv.addObject("treeData", tree);
		mv.setViewName("jsonView");
		
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("/erp/orgchart/erpSyncChkFirstApply.do")
	public Object erpSyncChkFirstApply(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String compSeq = params.get("compSeq")+"";
		
		String messageKey = null;
		String firstYn = "N";
		
		if (EgovStringUtil.isEmpty(compSeq)) {
			messageKey="erp.orgchart.first.compSeq";
		} else {
			params.put("startNum", "0");
			params.put("endNum", "1");
			params.put("syncStatus", "C");
			
			List<Map<String, Object>> list = erpOrgchartSyncService.selectErpSyncDetailList(params);
			
			if (list != null && list.size() > 0) {
				//
			} else {
				messageKey="erp.orgchart.first.yes";
				firstYn = "Y";
			}
		}
		
		if (!EgovStringUtil.isEmpty(messageKey)) {
			//mv.addObject("result", MessageUtil.getMessage(request, messageKey));
		} else {
			mv.addObject("result",null);
		}
		mv.addObject("firstYn",firstYn);
		
		mv.setViewName("jsonView");
		
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("/erp/orgchart/erpSyncChkBaseData.do")
	public Object erpSyncChkBaseData(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		String baseDataYn = "Y";

		List<Map<String, Object>> list = erpOrgchartSyncService.selectErpGwJobCodeList(params);

		if (list != null && list.size() > 0) {
			//
		} else {
			baseDataYn = "N";
		}

		mv.addObject("baseDataYn",baseDataYn);
		
		mv.setViewName("jsonView");
		
		
		return mv;
	}
	
	@RequestMapping(value="/erp/orgchart/erpSyncOrgchartTempSaveProc.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncOrgchartTempSaveProc(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("resultCode", "1");
		String groupSeq = params.get("groupSeq")+"";
		String compSeq = params.get("compSeq")+"";
		if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(compSeq)) {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());
			params.put("editorSeq", loginVO.getUniqId());
			params.put("editorIp", CommonUtil.getClientIp(request));
			
			
			params.put("value", "erpSyncSeq");
			String erpSyncSeq = sequenceService.getSequence(params);
			params.put("syncSeq", erpSyncSeq);
			
			params.put("syncStatus", "R"); // 준비
			params.put("autoYn", "N"); //
			params.put("erpSyncDate", params.get("endSyncTime")); // 
			erpOrgchartSyncService.setErpSync(params);
			
			params.put("achrGbn", "hr");
			Map<String,Object> dbInfo = getErpDbInfo(params);
				
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("cdCompany", dbInfo.get("erpCompSeq"));
			params.put("erpType", dbInfo.get("erpType"));
			
			List<Map<String,Object>> orgList = new ArrayList<>();
			
			List<Map<String,Object>> erpBizList = erpOrgchartDAO.selectErpBizList(params);
			logger.debug("erpBizList : " + erpBizList);
			if(erpBizList != null) {
				orgList.addAll(erpBizList);
			}

			List<Map<String,Object>> erpDeptList = erpOrgchartDAO.selectErpDeptList(params);
			logger.debug("erpDeptList : " + erpDeptList);
			if(erpDeptList != null) {
				orgList.addAll(erpDeptList);
			}
			
			List<Map<String,Object>> erpDeptPathList = erpOrgchartDAO.selectErpDeptPathList(params);
			Map<String,Object> pathInfo = CollectionUtils.getListToMap(erpDeptPathList, "deptSeq");
			
			params.put("erpBizList", erpBizList);
			params.put("erpDeptList", erpDeptList);
			params.put("pathInfo", pathInfo);

			List<Map<String,Object>> resultList = erpOrgchartSyncService.setTempdeptOrgchart(params);
			
			if (resultList.size() > 0) {
				mv.addObject("resultCode", "0");
				mv.addObject("syncSeq", erpSyncSeq);
			}else {
				mv.addObject("resultCode", "2");
			}
		}
		
		mv.setViewName("jsonView");
		
		return mv;
		
	}
	
	@RequestMapping(value="/erp/orgchart/erpSyncEmpList.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncEmpList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		logger.info("erpSyncEmpList  params : " + params);

		String groupSeq = params.get("groupSeq")+"";
		String compSeq = params.get("compSeq")+"";
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(compSeq)) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		params.put("langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();
		
		String listType = params.get("listType").toString();
		
		Map<String,Object> erpEmpInfo = new HashMap<>();
		Map<String,Object> erpEmpCountInfo = new HashMap<>();
		Map<String, Object> licenseCountCheck = new HashMap<>();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		PaginationInfo paginationCountInfo = new PaginationInfo();
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int pageSize = EgovStringUtil.zeroConvert(params.get("pageSize"));
		if (page == 0) {
			page = 1;
		}
		if (pageSize == 0) {
			pageSize = 10;
		}
		
		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(pageSize);
		paginationInfo.setRecordCountPerPage(10); 
		
		paginationCountInfo.setCurrentPageNo(1);
		paginationCountInfo.setPageSize(1000000);
		paginationCountInfo.setRecordCountPerPage(10);
		
		params.put( "autoYn", "N" );
		
		if (listType.equals("erp")) {
			
			params.put("achrGbn", "hr");
			
			Map<String,Object> dbInfo = getErpDbInfo(params);
				
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			
			params.put("cdCompany", dbInfo.get("erpCompSeq"));
			
			if(BizboxAProperties.getCustomProperty("BizboxA.Cust.erpIuPositionDutySet").equals("Y")){
				params.put("erpIuPositionSet", BizboxAProperties.getCustomProperty("BizboxA.Cust.erpIuPositionSet"));
				params.put("erpIuDutySet", BizboxAProperties.getCustomProperty("BizboxA.Cust.erpIuDutySet"));
			}else{
				
				params.put("codeType", "40");
				List<Map<String, Object>> list = commonSql.list("ErpOrgchartDAO.getDutyPosionOptionInfo", params);
				
				for(Map<String, Object> mp : list) {
					if(mp.get("gwCode").toString().equals("1")) {
						if(mp.get("erpCode").toString().equals("1")){
							params.put("erpIuPositionSet", "cdDutyStep");
						}else if(mp.get("erpCode").toString().equals("2")){
							params.put("erpIuPositionSet", "cdDutyResp");
						}else if(mp.get("erpCode").toString().equals("3")){
							params.put("erpIuPositionSet", "cdDutyRank");
						}
					}else if(mp.get("gwCode").toString().equals("2")) {
						if(mp.get("erpCode").toString().equals("1")){
							params.put("erpIuDutySet", "cdDutyStep");
						}else if(mp.get("erpCode").toString().equals("2")){
							params.put("erpIuDutySet", "cdDutyResp");
						}else if(mp.get("erpCode").toString().equals("3")){
							params.put("erpIuDutySet", "cdDutyRank");
						}
					}
				}			
			}
			
			erpEmpInfo = erpOrgchartDAO.selectErpEmpListOfPage(params, paginationInfo);
			
			params.put("erpType", dbInfo.get("erpType"));
		
		} else {
			try {
				licenseCountCheck = licenseService.LicenseCountShow(params);
			} catch(Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			//사용자연동항목 옵션조회
			String syncItem = getCmmOptionValue((String)params.get("compSeq"), "cm1120");
			//8:사원명
			if(syncItem.indexOf("8") == -1) {
				params.put("empNameSyncYn", "N");
			}else {
				params.put("empNameSyncYn", "Y");
			}
			
			erpEmpInfo = erpOrgchartSyncService.selectTmpEmpList(params, paginationInfo);
			
			
			//ERP연동 대기사용자 집계를 위해 전체리스트 재조회
			erpEmpCountInfo = erpOrgchartSyncService.selectTmpEmpList(params, paginationCountInfo);
			
			
			List<Map<String,Object>> detailList1 = (List<Map<String,Object>>)erpEmpInfo.get("list");
			int gwCount = 0;
			int mailCount = 0;
			int totalGwLicense = Integer.parseInt(licenseCountCheck.get("totalGwCount").toString());
			int totalMailLicense = Integer.parseInt(licenseCountCheck.get("totalMailCount").toString());
			int realTotalMailLicense = Integer.parseInt(licenseCountCheck.get("realMailCount").toString());
			int realTotalGwLicense = Integer.parseInt(licenseCountCheck.get("realGwCount").toString());
			
			if (realTotalGwLicense > Integer.MAX_VALUE || realTotalGwLicense < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			
			if (realTotalMailLicense > Integer.MAX_VALUE || realTotalMailLicense < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			
			if(licenseCountCheck.get("executeYn").equals("1")){
				for(Map<String, Object> temp : detailList1) {
					// 정상
					if(temp.get("resultCode").equals("0") && temp.get("licenseCheckYn").equals("1")) {
						gwCount++;
						if(totalGwLicense < realTotalGwLicense + gwCount) {
							temp.put("resultCode", "30");
							erpOrgchartSyncService.updateLicenseValue(temp);
						}
					}
				}
			}
			
			if(licenseCountCheck.get("executeMailYn").equals("1")){
				for(Map<String, Object> temp : detailList1) {
					if(temp.get("resultCode").equals("0") && temp.get("licenseCheckYn").equals("2")){
						mailCount++;
						if(totalMailLicense < realTotalMailLicense + mailCount) {
							temp.put("resultCode", "40");
							erpOrgchartSyncService.updateLicenseValue(temp);
						}
					}
				}
			
			}
		}
		
		logger.debug("erpEmpInfo : " + erpEmpInfo);
		
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> detailList = (List<Map<String,Object>>)erpEmpInfo.get("list");
		List<Map<String,Object>> detailCountList = (List<Map<String,Object>>)erpEmpCountInfo.get("list");
		
		mv.addObject("totalCount", erpEmpInfo.get("totalCount"));
		mv.addObject("detailList", detailList);
		mv.addObject("detailCountList", detailCountList);
		mv.addObject("paginationInfo", paginationInfo);
		mv.addObject("params", params);
		

		mv.setViewName("jsonView");

		return mv;
	}
	
	@RequestMapping(value="/erp/orgchart/erpSyncEmpTempSaveProc.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncEmpTempSaveProc(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("resultCode", "1");
		
		String groupSeq = params.get("groupSeq")+"";
		String compSeq = params.get("compSeq")+"";
		String syncSeq = params.get("syncSeq")+"";
		
		if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(compSeq)
				&& !EgovStringUtil.isEmpty(syncSeq)) {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());
			params.put("editorSeq", loginVO.getUniqId());
			
			params.put("achrGbn", "hr");
			Map<String,Object> dbInfo = getErpDbInfo(params);
				
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("cdCompany", dbInfo.get("erpCompSeq"));
			params.put("erpType", dbInfo.get("erpType"));
			
			/** ERP,그룹웨어 코드 맵핑 데이터 조회 
			 *  재직구분, 라이센스
			 * */
			List<Map<String,Object>> typeList = erpOrgchartSyncService.selectErpGwJobCodeList(params);

			params.put("typeList", typeList);
			
			// 직급/직책 필수여부값 체크
			String dutyPosiOption = getCmmOptionValue(compSeq, "cm1130");
			params.put("dutyPosiOption", dutyPosiOption);
			
			// 그룹웨어 초기 비밀번호 설정옵션
			String passwdOption = getCmmOptionValue(compSeq, "cm1140");
			params.put("passwdOption", passwdOption);
			
			/** ERP 사원 정보 리스트 조회 */
			PaginationInfo paginationInfo = new PaginationInfo();
			int page = EgovStringUtil.zeroConvert(params.get("page"));
			
			paginationInfo.setCurrentPageNo(page);
			paginationInfo.setPageSize(10);
			paginationInfo.setRecordCountPerPage(10); 
			
			/** 직위,직급 선택 */
			params.put("codeType", "40");
			List<Map<String, Object>> list = commonSql.list("ErpOrgchartDAO.getDutyPosionOptionInfo", params);
			
			for(Map<String, Object> mp : list) {
				if(mp.get("gwCode").toString().equals("1")) {
					if(mp.get("erpCode").toString().equals("1")){
						params.put("erpIuPositionSet", "cdDutyStep");
					}else if(mp.get("erpCode").toString().equals("2")){
						params.put("erpIuPositionSet", "cdDutyResp");
					}else if(mp.get("erpCode").toString().equals("3")){
						params.put("erpIuPositionSet", "cdDutyRank");
					}
				}else if(mp.get("gwCode").toString().equals("2")) {
					if(mp.get("erpCode").toString().equals("1")){
						params.put("erpIuDutySet", "cdDutyStep");
					}else if(mp.get("erpCode").toString().equals("2")){
						params.put("erpIuDutySet", "cdDutyResp");
					}else if(mp.get("erpCode").toString().equals("3")){
						params.put("erpIuDutySet", "cdDutyRank");
					}
				}
			}
			
			/** ERP 사원정보를 그룹웨어로 동기화시 신규 입사자 로그인 ID 생성 규칙 조회 */
			String optionValue = getCmmOptionValue(compSeq, "cm1102");
			
			if (optionValue != null && !optionValue.equals("0")) {
				params.put("loginIdType", optionValue); //1:erp 사원번호, 2: 이메일
			} else {
				params.put("loginIdType", "1");	// 설정 안되어 있을경우 erp 사원번호 기본값
			}
			
			
			Map<String,Object> erpEmpInfo = null; 
			
			try {
				erpEmpInfo = erpOrgchartDAO.selectErpEmpListOfPage(params, paginationInfo);
			}catch(Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			logger.debug("erpEmpInfo : " + erpEmpInfo);
			
			@SuppressWarnings("unchecked")
			List<Map<String,Object>> empList = (List<Map<String,Object>>)erpEmpInfo.get("list");
			logger.debug("empList : " + empList);
			
			params.put("empList", empList);
			
			
			//중복 결과확인을 위한 기존 연동임시테이블 삭제처리
			if(params.get("page").toString().equals("1")) {
				commonSql.delete("ErpOrgchartDAO.deleteTmpEmp", params);
				commonSql.delete("ErpOrgchartDAO.deleteTmpEmpMulti", params);
				commonSql.delete("ErpOrgchartDAO.deleteTmpEmpDept", params);
				commonSql.delete("ErpOrgchartDAO.deleteTmpEmpDeptMulti", params);
			}
			
			List<Map<String,Object>> resultList = erpOrgchartSyncService.setTempEmp(params);
			
			if (resultList != null && resultList.size() > 0) {
				mv.addObject("resultCode", "0");
			} else {
				mv.addObject("resultCode", "99");
			}
			
		}
		
		mv.setViewName("jsonView");
		
		return mv;
		
	}
	
	
	@RequestMapping(value="/erp/orgchart/erpSyncOrgchartSaveProc.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncOrgchartSaveProc(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		
		
		logger.debug("erpSyncOrgchartSaveProc.do");
		logger.debug("params : " + params);
		
		
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> changeEmpComp = new ArrayList<Map<String,Object>>();
		//List<Map<String, Object>> changeEmpAuth = new ArrayList<Map<String,Object>>();
		mv.addObject("resultCode", "1");
		
		String groupSeq = params.get("groupSeq")+"";
		String compSeq = params.get("compSeq")+"";
		String syncSeq = params.get("syncSeq")+"";
		int type = Integer.parseInt(params.get("type")+"");
		//String endSyncTime = params.get("endSyncTime")+"";
		
		params.remove("erpErrCode");
		
		try{
			if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(compSeq)
					&& !EgovStringUtil.isEmpty(syncSeq)) {
				
				LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				params.put("editorSeq", loginVO.getUniqId());
				params.put("langCode", loginVO.getLangCode());
				
				params.put("achrGbn", "hr");
				
				ErpOrgchartDAO erpOrgchartDAO = null;
				Map<String,Object> dbInfo = getErpDbInfo(params);
				if (dbInfo != null) {
					params.put("erpCompSeq", dbInfo.get("erpCompSeq"));
					params.put("dbUrl", dbInfo.get("url"));
					params.put("erpType", dbInfo.get("erpType"));
				}
				
				logger.debug("params : " + params);
				
				Map<String, Object> result = null;
				switch (type) {
				case 0:	// 데이터 삭제 
//					params.put("syncStatus", "I"); // 준비
//					params.put("syncDate", DateUtil.getToday("yyyy-MM-dd HH:mm:ss")); // 준비
//					erpOrgchartSyncService.setErpSync(params);	// 동기화 진행상황 저장
//					result = erpOrgchartSyncService.initOrgchart(params);
					break;
				case 10:	// 사업장 
					result = erpOrgchartSyncService.setBiz(params);
					erpOrgchartSyncService.setErpSync(params);
					break;
				case 20: //부서정보 신규 등록
					result = erpOrgchartSyncService.setDept(params);
					erpOrgchartSyncService.setErpSync(params);
					break;
				case 21: //부서정보 삭제처리(사용안함)
					erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
					params.put("erpOrgchartDAO", erpOrgchartDAO);
					result = erpOrgchartSyncService.setDeptUpdate(params);
					erpOrgchartSyncService.setErpSync(params);
					break;
				case 22: // 부서변경
					result = erpOrgchartSyncService.setDeptInfoUpdate(params);
					erpOrgchartSyncService.setErpSync(params);
					break;
				case 30: // 사원정보
					erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
					params.put("eaType", loginVO.getEaType());
					params.put("erpOrgchartDAO", erpOrgchartDAO);
					result = erpOrgchartSyncService.setEmp(params);
					erpOrgchartSyncService.setErpSync(params);
					break;
				case 31: // 사원정보수정
					erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
					params.put("eaType", loginVO.getEaType());
					params.put("erpOrgchartDAO", erpOrgchartDAO);
					result = erpOrgchartSyncService.setEmpUpdate(params);
					
					if(result.get("deleteList") != null) {
						changeEmpComp = (List<Map<String, Object>>)result.get("deleteList");
						erpOrgchartSyncService.deleteEmpDept(changeEmpComp);
					}
					
//					if(result.get("deleteList") != null) {
//						changeEmpAuth = (List<Map<String, Object>>)result.get("insertAuthList");
//						erpOrgchartSyncService.insertAuthList(changeEmpAuth);
//					}
					
					if(result.get("weddingDayReSetList") != null && !result.get("weddingDayReSetList").toString().equals("")) {
						Map<String, Object> paramMap = new HashMap<String, Object>();
						paramMap.put("empSeqArr", result.get("weddingDayReSetList").toString().split(","));
						paramMap.put("groupSeq", groupSeq);
						erpOrgchartSyncService.reSetWeddingDay(paramMap);
					}
					
					erpOrgchartSyncService.setErpSync(params);
					break;
				case 32: // 사원퇴사 : 퇴사 처리 관련하여(영리/비영리 전자결재 등 처리) 기능 수정으로 추후 개발해야됨.
					result = new HashMap<>();
					result.put("resultCode", "0");
					result.put("moreYn", "N");
					
					//퇴사처리는 수동으로만 가능하도록 기획변경 되어 주석처리
//					erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
//					params.put("eaType", loginVO.getEaType());
//					params.put("erpOrgchartDAO", erpOrgchartDAO);
//					erpOrgchartSyncService.setEmpResign(params);
//					
//					erpOrgchartSyncService.setErpSync(params);
					break;
				case 33: // 사원휴직 : 휴직 처리 관련하여(대결자지정) 기능 수정으로 추후 개발해야됨.
					result = new HashMap<>();
					result.put("resultCode", "0");
					result.put("moreYn", "N");
					break;
				case 40: // 사원회사정보
					result = erpOrgchartSyncService.setEmpComp(params);
					
					erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
					params.put("syncStatus", "C");
					params.put("orgSyncStatus", "C");
					params.put("orgSyncDate", erpOrgchartDAO.selectErpCurrentTime( ));
					params.put("syncDate", erpOrgchartDAO.selectErpCurrentTime( ));
					params.put( "autoYn", "N" );
					
					params.put("timeType", "SS");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
					params.put("time", "1");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
					
				
					//erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
					
//					List<Map<String,Object>> successEmpList = erpOrgchartSyncService.selectSyncSuccessTmpEmpList(params);
					
					params.put("timeType", "MI");
					params.put("time", "-1"); // 60초 전으로 동기화 완료처리. 다음번 동기화 대상이 되지 않음.
//					if (successEmpList != null) {
//						for(Map<String,Object> map : successEmpList) {
//							params.put("erpEmpSeq", map.get("erpEmpSeq"));
//							params.put("erpCompSeq", map.get("erpCompSeq"));
//							
//							erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
//							erpOrgchartSyncService.updateErp(params);
//						}
//					}
					erpOrgchartSyncService.updateErp(params);
					erpOrgchartSyncService.setErpSync(params);
					erpOrgchartSyncService.erpSyncDutyPosiSaveProc(params);
					erpOrgchartSyncService.setEmpOrderText(params);
					erpOrgchartSyncService.setMainCompYn(params);	//t_co_emp_Dept -> main_comp_yn 보정처리
					
					/** 메일 동기화 */
					orgAdapterService.mailUserSync(params);
					
					//조직도 동기화 상태값 완료값으로 변경
					params.put("orgAutoSyncStatus", "C");
					commonSql.update("ErpOrgchartDAO.updateOrgAutoSyncStatus", params);
					
					break;
					
					default:break;
				}
				
				
				
				mv.addAllObjects(result);

			}
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		mv.setViewName("jsonView");
		
		return mv;
		
	}
	
	
	@RequestMapping(value="/erp/orgchart/erpSyncDutyPosiSaveProc.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncDutyPosiSaveProc(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		
		//필요파라미터 compSeq, groupSeq
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("resultCode", erpOrgchartSyncService.erpSyncDutyPosiSaveProc(params));
		mv.setViewName("jsonView");

		return mv;
	}
	
	
	@RequestMapping(value="/erp/orgchart/selectErpSyncResignParam.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView selectErpSyncResignParam(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String, Object> resignParam = new HashMap<String, Object>();
		
		try {
			resignParam = erpOrgchartSyncService.selectErpSyncResignParam(params);
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		mv.addObject("resignParam", resignParam);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	private String getCmmOptionValue(String compSeq, String option) {
		/** ERP 옵션 조회 */
		try {
			Map<String,Object> optionParams = new HashMap<>();
			optionParams.put("option", option);
			optionParams.put("compSeq", compSeq);
			Map<String, Object> erpOptions = commonOptionManageService.getErpOptionValue(optionParams);
			if (erpOptions != null && erpOptions.get("optionRealValue") != null) {
				return (String)erpOptions.get("optionRealValue");
			}
		}
		catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return null;
	}
	
	@IncludedInfo(name="ERP 연동 기초 설정", order = 261 ,gid = 60)
	@RequestMapping(value="/erp/orgchart/erpSyncProjectSetPop.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncProjectSetPop(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {

		String compSeq = params.get("selectCompSeq").toString();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
			
		if (EgovStringUtil.isEmpty(compSeq)) {
			compSeq = loginVO.getCompSeq();
		}
		
		params.put("compSeq", compSeq);
		params.put("langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();
			
		// 회계
		params.put("achrGbn", "ac");
		Map<String,Object> dbInfo = getErpDbInfo(params);
		
		if(dbInfo != null){
			mv.addObject("erpSyncYn", "Y");
			mv.addObject("erpInfo", dbInfo);
		}else{
			mv.addObject("erpSyncYn", "N");
		}
		
		/*
		try{
			if (dbInfo != null) {
				params.put("erpType", dbInfo.get("erpType"));
				// ERP DAO 생성
				ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				params.put("cdCompany", dbInfo.get("erpCompSeq"));

				//List<Map<String,Object>> erpWorkCodeList = erpOrgchartDAO.selectErpEmpWorkCodeList(params);
				//List<Map<String,Object>> syncWorkCodeList = erpOrgchartSyncService.selectErpSyncWorkCodeList(erpWorkCodeList, params);
				
				mv.addObject("erpSyncYn", "Y");
				
			}else{
				mv.addObject("erpSyncYn", "N");
			}
		} catch(Exception e) {
			mv.addObject("erpSyncYn", "N");
		}
		*/
		
		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/erp/orgchart/pop/erpSyncProjectSetPop");

		return mv;
	}	
	
	@RequestMapping(value="/erp/orgchart/selectErpProjectSync.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView selectErpProjectSync(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		//compSeq=0001, termTp=1, pmSeq=123123144530, pmCompSeq=0001, pmDeptSeq=123123144487
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("achrGbn", "ac");
		
		Map<String,Object> dbInfo = getErpDbInfo(params);
		
		if(dbInfo != null){
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("erpType", dbInfo.get("erpType"));
			
			// ERP DAO 생성
			params.put("cdCompany", dbInfo.get("erpCompSeq"));
			List<Map<String,Object>> erpProjectList = erpOrgchartDAO.selectErpProjectList(params);
			
			if(erpProjectList != null && erpProjectList.size() > 0){
				
				String suuid = UUID.randomUUID().toString().replaceAll("-", "");
				
				Map<String,Object> erpTemp = new HashMap<>();
				params.put("syncSeq", suuid);
				erpTemp.putAll(params);
				erpTemp.put("erpProjectList", erpProjectList);
				
				//기존데이터 삭제
				commonSql.delete("ProjectManageDAO.deleteErpProjectTemp", params);
				
				//임시테이블에 저장
				commonSql.insert("ProjectManageDAO.insertErpProjectTemp", erpTemp);
				
				//신규,수정 카운트 조회
				//@SuppressWarnings("unchecked")
				//Map<String,Object> syncCnt = (Map<String,Object>) commonSql.select("ProjectManageDAO.selectErpSyncCnt", params);
				//syncCnt.put("syncSeq", suuid);
				
				params.put("searchTp", "new");
				List<Map<String,Object>> syncNewList = (List<Map<String, Object>>) commonSql.list("ProjectManageDAO.selectErpSyncList", params);
				
				//params.put("searchTp", "mod");
				//List<Map<String,Object>> syncModList = (List<Map<String, Object>>) commonSql.list("ProjectManageDAO.selectErpSyncList", params);				
				//mv.addObject("syncModList", syncModList);
				
				mv.addObject("syncNewList", syncNewList);

			}
		}
		
		mv.setViewName("jsonView");
		return mv;
	}	
	
	
	@IncludedInfo(name="ERP회사연동설정", order = 270 ,gid = 60)
	@RequestMapping(value="/erp/orgchart/erpSyncCompDetailView.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncCompDetailView(HttpServletRequest request, HttpServletResponse response, 
			@RequestParam Map<String,Object> params, RedirectAttributes ra) {
		logger.info("erpSyncCompDetailView  params : " + params);

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());

		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
//		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", userSe);
			if (userSe.equals("ADMIN")) {
				params.put("empSeq", loginVO.getUniqId());
			}
//			compList = compService.getCompListAuth(params);
		}
//		mv.addObject("compList", compList);
//		JSONArray json = JSONArray.fromObject(compList);
//		mv.addObject("compListJson", json);
		
//		String compSeq = params.get("compSeq")+"";
//		if (EgovStringUtil.isEmpty(compSeq)) {
//			params.put("compSeq", loginVO.getCompSeq());
//			compSeq = loginVO.getCompSeq();
//		}
		
		params.put("langCode", loginVO.getLangCode());
		
		/** Erp 동기화 상세 리스트 조회  */
		PaginationInfo paginationInfo = new PaginationInfo();
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int pageSize = EgovStringUtil.zeroConvert(params.get("pageSize"));
		if (page == 0) {
			page = 1;
		}
		if (pageSize == 0) {
			pageSize = 10;
		}
		
		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(pageSize);
		paginationInfo.setRecordCountPerPage(10); 
		
		
		Map<String,Object>  detailListInfo = erpOrgchartSyncService.selectErpSyncCompDetailList(params, paginationInfo);
		
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> detailList = (List<Map<String,Object>>)detailListInfo.get("list");
		
		mv.addObject("detailList", detailList);
		mv.addObject("paginationInfo", paginationInfo);
		
		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/erp/orgchart/erpSyncCompDetailView");

		return mv;
	}
	
	@IncludedInfo(name="ERP 회사 동기화 팝업", order = 272 ,gid = 60)
	@RequestMapping(value="/erp/orgchart/erpSyncCompDataSetPop.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncCompDataSetPop(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		logger.info("erpSyncCompDataSetPop  params : " + params);

		String groupSeq = params.get("groupSeq")+"";
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		params.put("langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();

		params.put("achrGbn", "hr");
		Map<String,Object> dbInfo = erpOrgchartSyncService.getGerpDbInfo(params);
		params.put("syncGroupSeq", dbInfo.get("syncGroupSeq"));

		if (dbInfo != null) { 

			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);

			/** 동기화 시작 시간 조회 */
			String erpSyncTime = erpOrgchartDAO.selectErpCurrentTime();
			params.put("endSyncTime", erpSyncTime);	// 2016-11-25 08:40:44

			String erpSyncDate = dbInfo.get("erpSyncDate")+"";
			if (EgovStringUtil.isEmpty(erpSyncDate)) {
				erpSyncDate = "2000-01-01 00:00:00";
				params.put("firstYn", "Y");
			} else {
				params.put("firstYn", "N");
			} 


			params.put("startSyncTime", erpSyncDate);	// 동기화 마지막 일자

		}
		
		/** redirect 메세지 처리 */
		
		String resultCode = params.get("resultCode")+"";
		if (!EgovStringUtil.isEmpty(resultCode) && !resultCode.equals("-1")) {
			//
		}
		

		mv.addObject("params", params);

		mv.setViewName("/neos/cmm/erp/orgchart/pop/erpSyncCompDataSetPop");

		return mv;
	}
	
	@RequestMapping(value="/erp/orgchart/erpSyncCompList.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncCompList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		logger.info("erpSyncCompList  params : " + params);

		String groupSeq = params.get("groupSeq")+"";
		//String compSeq = params.get("compSeq")+"";
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		params.put("langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();
		
		String listType = params.get("listType").toString();
		
		Map<String,Object> erpCompInfo = new HashMap<>();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int pageSize = EgovStringUtil.zeroConvert(params.get("pageSize"));
		if (page == 0) {
			page = 1;
		}
		if (pageSize == 0) {
			pageSize = 10;
		}
		
		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(pageSize);
		paginationInfo.setRecordCountPerPage(10); 
		
		if (listType.equals("erp")) {
			
			Map<String,Object> dbInfo = erpOrgchartSyncService.getGerpDbInfo(params);
				
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			
			erpCompInfo = erpOrgchartDAO.selectErpCompListOfPage(params, paginationInfo);
			
			params.put("erpType", dbInfo.get("erpType"));
		
		} else {
			erpCompInfo = erpOrgchartSyncService.selectTmpCompList(params, paginationInfo);
		}
		
		logger.debug("erpCompInfo : " + erpCompInfo);
		
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> detailList = (List<Map<String,Object>>)erpCompInfo.get("list");
		
		mv.addObject("detailList", detailList);
		mv.addObject("paginationInfo", paginationInfo);
		mv.addObject("params", params);
		

		mv.setViewName("/neos/cmm/erp/orgchart/pop/include/erpSyncCompList");

		return mv;
	}
	
	@RequestMapping(value="/erp/orgchart/erpSyncCompTempSaveProc.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncCompTempSaveProc(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("resultCode", "1");
		
		String groupSeq = params.get("groupSeq")+"";
		String syncSeq = params.get("syncSeq")+"";
		
		if(EgovStringUtil.isEmpty(syncSeq)){ 
			params.put("value", "erpSyncSeq");
			syncSeq = sequenceService.getSequence(params);
		}
		
		params.put("syncSeq", syncSeq);
		
		if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(syncSeq)) {
			
			/** 회사 도메인 가져오기 */
			String compDomain = BizboxAProperties.getProperty("BizboxA.groupware.domin");	
			if (StringUtils.isNotEmpty(compDomain)) {
				String[] split = compDomain.split("/");				
				compDomain = split[split.length-1];
				params.put("compDomain", compDomain);
			}
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());
			params.put("editorSeq", loginVO.getUniqId());
			
			Map<String,Object> dbInfo = erpOrgchartSyncService.getGerpDbInfo(params);
				
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("erpType", dbInfo.get("erpType"));
			
			/** ERP 사원 정보 리스트 조회 */
			PaginationInfo paginationInfo = new PaginationInfo();
			int page = EgovStringUtil.zeroConvert(params.get("page"));
			
			paginationInfo.setCurrentPageNo(page);
			paginationInfo.setPageSize(100);
			paginationInfo.setRecordCountPerPage(10); 
			
			Map<String,Object> erpCompInfo = erpOrgchartDAO.selectErpCompListOfPage(params, paginationInfo);
			
			logger.debug("erpCompInfo : " + erpCompInfo);
			
			@SuppressWarnings("unchecked")
			List<Map<String,Object>> compList = (List<Map<String,Object>>)erpCompInfo.get("list");
			logger.debug("compList : " + compList);
			
			params.put("compList", compList);
			
			
			
			List<Map<String,Object>> resultList = erpOrgchartSyncService.setTempComp(params);
			
			if (resultList != null && resultList.size() > 0) {
				mv.addObject("resultCode", "0");
				mv.addObject("syncSeq", syncSeq);
			} else {
				mv.addObject("resultCode", "99");
			}
			
		}
		
		mv.setViewName("jsonView");
		
		return mv;
		
	}
	
	@RequestMapping(value="/erp/orgchart/erpSyncCompSaveProc.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncCompSaveProc(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		
		logger.debug("erpSyncCompSaveProc.do");
		logger.debug("params : " + params);
		
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("resultCode", "1");
		
		String groupSeq = params.get("groupSeq")+"";
		String syncSeq = params.get("syncSeq")+"";
		
		try{
			if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(syncSeq)) {
				
				LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				params.put("loginVO", loginVO);
				params.put("editorSeq", loginVO.getUniqId());
				params.put("langCode", loginVO.getLangCode());
				
				params.put("achrGbn", "hr");
				
				Map<String,Object> dbInfo = erpOrgchartSyncService.getGerpDbInfo(params);
				if (dbInfo != null) {
					params.put("erpCompSeq", dbInfo.get("erpCompSeq"));
					params.put("dbUrl", dbInfo.get("url"));
					params.put("erpType", dbInfo.get("erpType"));
				}
				
				logger.debug("params : " + params);

				Map<String, Object> result = null;
//				params.put("syncStatus", "I"); // 준비
				params.put("syncDate", DateUtil.getToday("yyyy-MM-dd HH:mm:ss")); // 준비
//				erpOrgchartSyncService.setErpCompSync(params);	// 동기화 진행상황 저장
				
				params.put("dbInfo", dbInfo);
				
				result = erpOrgchartSyncService.setComp(params);
				
				
//				erpOrgchartSyncService.setErpCompSync(params);

				params.put("syncStatus", "C");
				params.put("orgSyncStatus", "C");
				params.put("erpSyncDate", params.get("endSyncTime"));
				params.put("compJoinCnt", result.get("compJoinTotalCount"));
				params.put("compModifyCnt", result.get("compModifyTotalCount"));
				params.put("autoYn", "Y");

				erpOrgchartSyncService.setErpCompList(params);
				
				/** ERP 회사 맵핑 정보 저장 */
				erpOrgchartSyncService.setErpCompSync(params);

				mv.addAllObjects(result);

			}
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		

		mv.setViewName("jsonView");
		
		return mv;
		
	}

	@IncludedInfo(name="ERP 연동 기초 설정", order = 261 ,gid = 60)
	@RequestMapping(value="/erp/orgchart/erpSyncPartnerSetPop.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpSyncPartnerSetPop(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {

		String compSeq = params.get("selectCompSeq").toString();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
			
		if (EgovStringUtil.isEmpty(compSeq)) {
			compSeq = loginVO.getCompSeq();
		}
		
		params.put("compSeq", compSeq);
		params.put("langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();
			
		// 회계
		params.put("achrGbn", "ac");
		Map<String,Object> dbInfo = getErpDbInfo(params);
		
		if(dbInfo != null){
			mv.addObject("erpSyncYn", "Y");
			mv.addObject("erpInfo", dbInfo);
		}else{
			mv.addObject("erpSyncYn", "N");
		}
		
		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/erp/orgchart/pop/erpSyncPartnerSetPop");

		return mv;
	}		

	@RequestMapping(value="/erp/orgchart/selectErpPartnerSync.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView selectErpPartnerSync(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		//compSeq=0001, termTp=1, pmSeq=123123144530, pmCompSeq=0001, pmDeptSeq=123123144487
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("achrGbn", "ac");
		
		Map<String,Object> dbInfo = getErpDbInfo(params);
		
		if(dbInfo != null){
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("erpType", dbInfo.get("erpType"));
			
			// ERP DAO 생성
			params.put("cdCompany", dbInfo.get("erpCompSeq"));
			List<Map<String,Object>> erpPartnerList = erpOrgchartDAO.selectErpPartnerList(params);
			
			if(erpPartnerList != null && erpPartnerList.size() > 0){
				
				String suuid = UUID.randomUUID().toString().replaceAll("-", "");
				
				Map<String,Object> erpTemp = new HashMap<>();
				params.put("syncSeq", suuid);
				erpTemp.putAll(params);
				erpTemp.put("erpPartnerList", erpPartnerList);
				
				//기존데이터 삭제
				commonSql.delete("PartnerManageDAO.deleteErpPartnerTemp", params);
				
				//임시테이블에 저장
				commonSql.insert("PartnerManageDAO.insertErpPartnerTemp", erpTemp);
				
				//신규,수정 카운트 조회
				//@SuppressWarnings("unchecked")
				//Map<String,Object> syncCnt = (Map<String,Object>) commonSql.select("ProjectManageDAO.selectErpSyncCnt", params);
				//syncCnt.put("syncSeq", suuid);
				
				params.put("searchTp", "new");
				List<Map<String,Object>> syncNewList = (List<Map<String, Object>>) commonSql.list("PartnerManageDAO.selectErpSyncList", params);
				
				//params.put("searchTp", "mod");
				//List<Map<String,Object>> syncModList = (List<Map<String, Object>>) commonSql.list("ProjectManageDAO.selectErpSyncList", params);				
				//mv.addObject("syncModList", syncModList);
				
				mv.addObject("syncNewList", syncNewList);

			}
		}
		
		mv.setViewName("jsonView");
		return mv;
	}				

	
		
	@RequestMapping(value="/erp/orgchart/gerpSync.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView gerpSync(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		
		/** ERP 회사 정보 동기화 진행 */
		String erpCompSyncYn = BizboxAProperties.getCustomProperty("BizboxA.Gerp.Sync.compSyncUseYn");
		if (!erpCompSyncYn.equals("Y")) {
			mv.addObject("result", "fail");
			return mv;
		}
		
		/** 회사 동기화 */
		Map<String,Object> resultMap = gerpSyncComp();
		
		resultMap.put("erpTypeCode", resultMap.get("erpType"));
		resultMap.put("orgSyncDate", resultMap.get("endSyncTime"));
		
		logger.debug("OrgSyncTask.pollingGerpSyncAuto start....");
		
		/** 조직도 동기화 대상 조회 */
		List<Map<String,Object>> list = erpOrgchartSyncService.getErpCompList(resultMap);
		
		for (Map<String,Object> map : list) {
			Map<String,Object> compMap = CollectionUtils.convertEgovMapToMap(map);
			
			compMap.put("orgSyncDate", resultMap.get("endSyncTime"));
			compMap.put("startSyncTime", resultMap.get("startSyncTime"));
			compMap.put("endSyncTime", resultMap.get("endSyncTime"));
			compMap.put("syncSeq", resultMap.get("syncSeq"));
			
			String firstYn = resultMap.get("firstYn")+"";
			
			/** 최초 동기화여부  */
			compMap.put("updateErp", firstYn.equals("N") ? "Y" : null);
			
			/* temp 테이블 생성 */
			gerpSyncTemp(compMap);

			/* 동기화 시작 */
			gerpSyncOrg(compMap);
		}

		logger.debug("OrgSyncTask.pollingGerpSyncAuto end.....");
		
		mv.addObject("result", "success");
		
		mv.setViewName("jsonView");
		
		return mv;
		
	}
	
	public Map<String, Object> gerpSyncOrg(Map<String, Object> params) {
		logger.debug("erpOrgchartEmpAutoSyncStart Start....");
		
		Map<String, Object> erpSyncResult = new HashMap<String, Object>();
		
		try{
			Map<String, Object> result = new HashMap<String, Object>();
			
			params.put("achrGbn", "hr");
			Map<String,Object> dbInfo = erpOrgchartSyncService.getErpDbInfo(params);
			params.put("cdCompany", dbInfo.get("erpCompSeq"));
			params.put("erpType", dbInfo.get("erpType"));
			params.put("erpCompSeq", dbInfo.get("erpCompSeq"));
			params.put("dbUrl", dbInfo.get("url"));	
			
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			
			/* 데이터 삭제 */
			params.put("syncStatus", "I"); // 준비
			params.put("syncDate", DateUtil.getToday("yyyy-MM-dd HH:mm:ss")); // 준비
			erpOrgchartSyncService.setErpSync(params);	// 동기화 진행상황 저장
			result = erpOrgchartSyncService.initOrgchart(params);
			
			/* 사업장 */
			result = erpOrgchartSyncService.setBiz(params);
			params.put("deptJoinCnt", result.get("deptJoinTotalCount") == null ? "0" : result.get("deptJoinTotalCount"));
			params.put("deptModifyCnt", result.get("deptModifyTotalCount") == null ? "0" : result.get("deptModifyTotalCount"));
			params.put("empJoinCnt", result.get("empJoinTotalCount") == null ? "0" : result.get("empJoinTotalCount"));
			params.put("empModifyCnt", result.get("empModifyTotalCount") == null ? "0" : result.get("empModifyTotalCount"));
			params.put("empResignCnt", result.get("empResignCount") == null ? "0" : result.get("empResignCount"));
			erpOrgchartSyncService.setErpSync(params);
			
			/* 부서정보 신규 등록 */
			result = erpOrgchartSyncService.setDept(params);
			erpOrgchartSyncService.setErpSync(params);
			
//			/* 부서정보 삭제처리(사용안함) */
//			result = setDeptUpdate(params);
//			setErpSync(params);
//			
			/* 사원정보 */
			//params.put("eaType", loginVO.getEaType());

			result = erpOrgchartSyncService.setEmp(params);
			
			erpOrgchartSyncService.setErpSync(params);
			
			/* 사원정보수정 */
//			//params.put("eaType", loginVO.getEaType());
			result = erpOrgchartSyncService.setEmpUpdate(params);
			erpOrgchartSyncService.setErpSync(params);
			
			/* 사원퇴사 : 퇴사 처리 관련하여(영리/비영리 전자결재 등 처리) 기능 수정으로 추후 개발해야됨. */
//			result = new HashMap<>();
//			result.put("resultCode", "0");
//			result.put("moreYn", "N");
//			
//			/* 사원휴직 : 휴직 처리 관련하여(대결자지정) 기능 수정으로 추후 개발해야됨. */
			result = new HashMap<>();
			result.put("resultCode", "0");
			result.put("moreYn", "N");

			/* 사원회사정보 */
			result = erpOrgchartSyncService.setEmpComp(params);
			params.put("syncStatus", "C");
			params.put("orgSyncStatus", "C");
			params.put("orgSyncDate", params.get("orgSyncDate"));
			
			erpOrgchartSyncService.setErpSync(params);
			
			erpOrgchartSyncService.updateErp(params);
			
			params.put("timeType", "SS");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
			params.put("time", "1");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
			
			
			erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
			
			List<Map<String,Object>> successEmpList = erpOrgchartSyncService.selectSyncSuccessTmpEmpList(params);
			
			params.put("timeType", "MI");
			params.put("time", "-1"); // 60초 전으로 동기화 완료처리. 다음번 동기화 대상이 되지 않음.
			if (successEmpList != null) {
				for(Map<String,Object> map : successEmpList) {
					params.put("erpEmpSeq", map.get("erpEmpSeq"));
					params.put("erpCompSeq", map.get("erpCompSeq"));
					
					erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
				}
			}
			
			erpSyncResult.put("result", "success");
			erpSyncResult.put("resultMessage", "erpSyncComplete");
		}catch(Exception e) {
			erpSyncResult.put("result", "error");
			
			
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			logger.error("! [erpOrgchartEmpAutoSyncStart] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			erpSyncResult.put("resultMessage", CommonUtil.getStatckTrace(e));
			throw e;
		}
		
		logger.debug("erpOrgchartEmpAutoSyncStart End....");
		return erpSyncResult;
	}
	
	private Map<String,Object> gerpSyncComp() {
		String groupSeq = BizboxAProperties.getCustomProperty("BizboxA.Gerp.Sync.GroupSeq");
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("groupSeq", groupSeq);
		mp.put("value", "erpSyncSeq");
		String syncSeq = sequenceService.getSequence(mp);

		Map<String,Object> params = new HashMap<>();
		params.put("syncSeq", syncSeq);
		params.put("groupSeq", groupSeq);

		try {
			/** 회사 정보 임시 저장 */
			if(!EgovStringUtil.isEmpty(groupSeq)) {

				/** 회사 도메인 가져오기 */
				String compDomain = BizboxAProperties.getProperty("BizboxA.groupware.domin");	
				if (StringUtils.isNotEmpty(compDomain)) {
					String[] split = compDomain.split("/");				
					compDomain = split[split.length-1];
					params.put("compDomain", compDomain);
				}

				LoginVO loginVO = new LoginVO();
				loginVO.setLangCode("kr");
				loginVO.setUniqId("system");
				params.put("langCode", loginVO.getLangCode());
				params.put("editorSeq", loginVO.getUniqId());
				params.put("loginVO", loginVO);

				Map<String,Object> dbInfo = erpOrgchartSyncService.getGerpDbInfo(params);
				
				ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				
				/** 동기화 시작 시간 조회 */
				String erpSyncTime = erpOrgchartDAO.selectErpCurrentTime();
				params.put("endSyncTime", erpSyncTime);	// 2016-11-25 08:40:44

				String erpSyncDate = dbInfo.get("erpSyncDate")+"";
				if (EgovStringUtil.isEmpty(erpSyncDate)) {
					erpSyncDate = "2000-01-01 00:00:00";
					params.put("firstYn", "Y");
				} else {
					params.put("firstYn", "N");
				} 


//				params.put("startSyncTime", erpSyncDate);	// 동기화 마지막 일자
				params.put("startSyncTime", "2017-08-31 00:00:00");	// 동기화 마지막 일자
				

				params.put("erpType", dbInfo.get("erpType"));

				/** ERP 사원 정보 리스트 조회 */
				PaginationInfo paginationInfo = new PaginationInfo();
//				int page = EgovStringUtil.zeroConvert(params.get("page"));

				paginationInfo.setCurrentPageNo(1);
				paginationInfo.setPageSize(1000);
				paginationInfo.setRecordCountPerPage(10); 

				Map<String,Object> erpCompInfo = erpOrgchartDAO.selectErpCompListOfPage(params, paginationInfo);

				logger.debug("erpCompInfo : " + erpCompInfo);

				@SuppressWarnings("unchecked")
				List<Map<String,Object>> compList = (List<Map<String,Object>>)erpCompInfo.get("list");
				logger.debug("compList : " + compList);

				params.put("compList", compList);

				erpOrgchartSyncService.setTempComp(params);

			}

			if(!EgovStringUtil.isEmpty(groupSeq)) {

				params.put("achrGbn", "hr");

				Map<String,Object> dbInfo = erpOrgchartSyncService.getGerpDbInfo(params);
				if (dbInfo != null) {
					params.put("erpCompSeq", dbInfo.get("erpCompSeq"));
					params.put("dbUrl", dbInfo.get("url"));
					params.put("erpType", dbInfo.get("erpType"));
				}

				logger.debug("params : " + params);

				Map<String, Object> result = null;
				//				params.put("syncStatus", "I"); // 준비
				params.put("syncDate", DateUtil.getToday("yyyy-MM-dd HH:mm:ss")); // 준비
				//				erpOrgchartSyncService.setErpCompSync(params);	// 동기화 진행상황 저장

				params.put("dbInfo", dbInfo);

				result = erpOrgchartSyncService.setComp(params);


				//				erpOrgchartSyncService.setErpCompSync(params);

				params.put("syncStatus", "C");
				params.put("orgSyncStatus", "C");
				params.put("erpSyncDate", params.get("endSyncTime"));
				params.put("compJoinCnt", result.get("compJoinTotalCount"));
				params.put("compModifyCnt", result.get("compModifyTotalCount"));
				params.put("autoYn", "Y");

				erpOrgchartSyncService.setErpCompList(params);

				/** ERP 회사 맵핑 정보 저장 */
				erpOrgchartSyncService.setErpCompSync(params);


			}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return params;

	}
	
	public Map<String, Object> gerpSyncTemp(Map<String, Object> params) throws Exception{
		logger.info("erpOrgchartEmpAutoTempStart Start....");
		Map<String, Object> data = new HashMap<String, Object>();
		
		try{
			String groupSeq = params.get("groupSeq")+"";
			String compSeq = params.get("compSeq")+"";
			
			if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(compSeq)) {
				/* 부서(사업장) 임시테이블 생성 */
				params.put("langCode", "kr");
				params.put("syncStatus", "R"); // 준비
				params.put("autoYn", "Y"); //
				params.put("erpSyncDate", params.get("endSyncTime")); 
				
				
				params.put("achrGbn", "hr");
				Map<String,Object> dbInfo = erpOrgchartSyncService.getErpDbInfo(params);
					
				ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				params.put("cdCompany", dbInfo.get("erpCompSeq"));
				params.put("erpType", dbInfo.get("erpType"));
				params.put("erpCompSeq", dbInfo.get("erpCompSeq"));
				params.put("dbUrl", dbInfo.get("url"));
				
				List<Map<String,Object>> orgList = new ArrayList<>();
				
				Map<String,Object> requestParams = new HashMap<>();
				requestParams.put("cdCompany", params.get("cdCompany"));
				requestParams.put("firstYn", params.get("firstYn"));
				requestParams.put("updateErp", params.get("updateErp"));
				requestParams.put("orgSyncDate", params.get("orgSyncDate"));
				requestParams.put("startSyncTime", params.get("startSyncTime"));
				requestParams.put("endSyncTime", params.get("endSyncTime"));
				requestParams.put("syncSeq", params.get("syncSeq"));
				
				List<Map<String,Object>> erpBizList = erpOrgchartDAO.selectErpBizList(requestParams);
				logger.debug("erpBizList : " + erpBizList);
				if(erpBizList != null) {
					orgList.addAll(erpBizList);
				}
	
				List<Map<String,Object>> erpDeptList = erpOrgchartDAO.selectErpDeptList(requestParams);
				logger.debug("erpDeptList : " + erpDeptList);
				if(erpDeptList != null) {
					orgList.addAll(erpDeptList);
				}
				
				List<Map<String,Object>> erpDeptPathList = erpOrgchartDAO.selectErpDeptPathList(params);
				Map<String,Object> pathInfo = CollectionUtils.getListToMap(erpDeptPathList, "deptSeq");
				
				params.put("erpBizList", erpBizList);
				params.put("erpDeptList", erpDeptList);
				params.put("pathInfo", pathInfo);
	
				erpOrgchartSyncService.setTempdeptOrgchart(params);
				
				/** ERP,그룹웨어 코드 맵핑 데이터 조회 
				 *  재직구분, 라이센스
				 * */
				List<Map<String,Object>> typeList = erpOrgchartSyncService.selectErpGwJobCodeList(params);
	
				params.put("typeList", typeList);
				
				/** ERP 사원 정보 리스트 조회 */
	
				
				PaginationInfo paginationInfo = new PaginationInfo();
				//int page = EgovStringUtil.zeroConvert("0");
				
				paginationInfo.setCurrentPageNo(1);
				paginationInfo.setPageSize(10);
				paginationInfo.setRecordCountPerPage(100); 
//				requestParams.put("updateErp", "Y");
				requestParams.put("autoYn", "N");
				requestParams.put("startSyncTime", params.get("startSyncTime"));
				requestParams.put("endSyncTime", params.get("endSyncTime"));
				Map<String,Object> erpEmpInfo = erpOrgchartDAO.selectErpEmpListOfPage(requestParams, paginationInfo);
				
				logger.debug("erpEmpInfo : " + erpEmpInfo);
				
				@SuppressWarnings("unchecked")
				List<Map<String,Object>> empList = (List<Map<String,Object>>)erpEmpInfo.get("list");
//				logger.debug("empList : " + empList);
				
				params.put("empList", empList);
				
				/** ERP 사원정보를 그룹웨어로 동기화시 신규 입사자 로그인 ID 생성 규칙 조회 */
				String optionValue = erpOrgchartSyncService.getCmmOptionValue(compSeq, "cm1102");
				
				if (optionValue != null && !optionValue.equals("0")) {
					params.put("loginIdType", optionValue); //1:erp 사원번호, 2: 이메일
				} else {
					params.put("loginIdType", "1");	// 설정 안되어 있을경우 erp 사원번호 기본값
				}
				
				params.put("dutyType", "0"); // 직급 표시...
				
				erpOrgchartSyncService.setTempEmp(params);
				
				/* erp 설정 기본 정보 넘겨주기 위해 */
				data.put("groupSeq", params.get("groupSeq"));
				data.put("compSeq", params.get("compSeq"));
				data.put("langCode", params.get("langCode"));
				data.put("syncStatus", params.get("syncStatus"));
				data.put("autoYn", params.get("autoYn"));
				data.put("erpSyncDate", params.get("erpSyncDate"));
				data.put("syncSeq", params.get("syncSeq"));
				data.put("orgSyncDate", params.get("endSyncTime"));
//				data.put("endSyncTime", params.get("endSyncTime"));
//				data.put("startSyncTime", params.get("startSyncTime"));
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		return data;
	}
	
	@RequestMapping(value="/erp/orgchart/erpOrgchartSyncStart.do" , method={ RequestMethod.POST, RequestMethod.GET})
	public ModelAndView erpOrgchartSyncStart(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) {
		ModelAndView mv = new ModelAndView();
		
		erpOrgchartEmpAutoSyncStart(params);
		
		return mv;
	}
	
	
	@SuppressWarnings("unchecked")
	@Async
	public void erpOrgchartEmpAutoSyncStart(Map<String, Object> params) {
		logger.debug("erpOrgchartEmpAutoSyncStart Start....");
		
		Map<String, Object> erpSyncResult = new HashMap<String, Object>();
		List<Map<String, Object>> changeEmpComp = new ArrayList<Map<String,Object>>();
		//List<Map<String, Object>> changeEmpAuth = new ArrayList<Map<String,Object>>();
		
		try{
			Map<String, Object> result = new HashMap<String, Object>();
			
			//String groupSeq = params.get("groupSeq")+"";
			//String compSeq = params.get("compSeq")+"";
			
			params.put("achrGbn", "hr");
			Map<String,Object> dbInfo = erpOrgchartSyncService.getErpDbInfo(params);
			params.put("cdCompany", dbInfo.get("erpCompSeq"));
			params.put("erpType", dbInfo.get("erpType"));
			params.put("erpCompSeq", dbInfo.get("erpCompSeq"));
			params.put("dbUrl", dbInfo.get("url"));	
			params.put("eaType", "eap");
			
			String erpSyncDate = dbInfo.get("orgSyncDate")+"";
			if (EgovStringUtil.isEmpty(erpSyncDate)) {
				erpSyncDate = "2000-01-01 00:00:00";
				params.put("firstYn", "Y");
			} else {
				params.put("firstYn", "N");
			}
			params.put( "startSyncTime", erpSyncDate );
			
			ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put( "erpOrgchartDAO", erpOrgchartDAO );
			/* 데이터 삭제 */
			params.put("syncStatus", "I"); // 준비
			params.put("syncDate", DateUtil.getToday("yyyy-MM-dd HH:mm:ss")); // 준비
			erpOrgchartSyncService.setErpSync(params);	// 동기화 진행상황 저장
//			result = erpOrgchartSyncService.initOrgchart(params);
			
			/* 사업장 */
			result = erpOrgchartSyncService.setBiz(params);
			params.put("deptJoinCnt", result.get("deptJoinTotalCount") == null ? "0" : result.get("deptJoinTotalCount"));
			params.put("deptModifyCnt", result.get("deptModifyTotalCount") == null ? "0" : result.get("deptModifyTotalCount"));
			params.put("empJoinCnt", result.get("empJoinTotalCount") == null ? "0" : result.get("empJoinTotalCount"));
			params.put("empModifyCnt", result.get("empModifyTotalCount") == null ? "0" : result.get("empModifyTotalCount"));
			params.put("empResignCnt", result.get("empResignCount") == null ? "0" : result.get("empResignCount"));
			erpOrgchartSyncService.setErpSync(params);
			
			/* 부서정보 신규 등록 */
			result = erpOrgchartSyncService.setDept(params);
			erpOrgchartSyncService.setErpSync(params);
			
//			/* 부서정보 삭제처리(사용안함) */
			result = erpOrgchartSyncService.setDeptUpdate(params);
			erpOrgchartSyncService.setErpSync(params);

			/* 부서변경 */
			result = erpOrgchartSyncService.setDeptInfoUpdate(params);
			erpOrgchartSyncService.setErpSync(params);
			
			/* 사원정보 */
			erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("erpOrgchartDAO", erpOrgchartDAO);
			result = erpOrgchartSyncService.setEmp(params);
			erpOrgchartSyncService.setErpSync(params);
			
			/* 사원정보수정 */
			erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("erpOrgchartDAO", erpOrgchartDAO);
			result = erpOrgchartSyncService.setEmpUpdate(params);
			
			if(result.get("deleteList") != null) {
				changeEmpComp = (List<Map<String, Object>>)result.get("deleteList");
				erpOrgchartSyncService.deleteEmpDept(changeEmpComp);
			}
			
			erpOrgchartSyncService.setErpSync(params);
			
			/* 사원퇴사 : 퇴사 처리 관련하여(영리/비영리 전자결재 등 처리) 기능 수정으로 추후 개발해야됨. */
			result = new HashMap<>();
			result.put("resultCode", "0");
			result.put("moreYn", "N");
			
			erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("erpOrgchartDAO", erpOrgchartDAO);
			erpOrgchartSyncService.setEmpResign(params);
			
			erpOrgchartSyncService.setErpSync(params);

			/* 사원휴직 : 휴직 처리 관련하여(대결자지정) 기능 수정으로 추후 개발해야됨. */
			result = new HashMap<>();
			result.put("resultCode", "0");
			result.put("moreYn", "N");

			/* 사원회사정보 */
			result = erpOrgchartSyncService.setEmpComp(params);
			params.put("syncStatus", "C");
			params.put("orgSyncStatus", "C");
			params.put("orgSyncDate", erpOrgchartDAO.selectErpCurrentTime( ));
			params.put("timeType", "SS");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
			params.put("time", "1");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
			
			List<Map<String,Object>> successEmpList = erpOrgchartSyncService.selectSyncSuccessTmpEmpList(params);
			
			params.put("timeType", "MI");
			params.put("time", "-1"); // 60초 전으로 동기화 완료처리. 다음번 동기화 대상이 되지 않음.
			if (successEmpList != null) {
				for(Map<String,Object> map : successEmpList) {
					params.put("erpEmpSeq", map.get("erpEmpSeq"));
					params.put("erpCompSeq", map.get("erpCompSeq"));
					erpOrgchartSyncService.updateErp(params);
				}
				params.put( "erpCompSeq", dbInfo.get("erpCompSeq") );
				erpOrgchartSyncService.updateErp(params);
			}
			
			erpOrgchartSyncService.setErpSync(params);
			orgAdapterService.mailUserSync(params);
			
			erpSyncResult.put("result", "success");
			erpSyncResult.put("resultMessage", "erpSyncComplete");
			
		}catch(Exception e) {
			erpSyncResult.put("result", "error");
			
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			logger.error("! [erpOrgchartEmpAutoSyncStart] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			erpSyncResult.put("resultMessage", CommonUtil.getStatckTrace(e));
			throw e;
		}
		logger.debug("erpOrgchartEmpAutoSyncStart End....");
	}
	
	
	
	//그룹웨어 조직도 트리(erp 조직도연동)
	@RequestMapping("/erp/orgchart/deptManageOrgChartListJT.do")
	public ModelAndView deptManageOrgChartListJT(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> groupMap = new HashMap<String, Object>();
		//List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> tree = new ArrayList<Map<String,Object>>();
		
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

			tree = erpOrgchartSyncService.getGwdeptOrgchartListJT(params);
		
		} catch (Exception e) {
			
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			
			groupMap = new HashMap<String, Object>();
			//list = new ArrayList<Map<String,Object>>();
			tree = new ArrayList<Map<String,Object>>();
			
		}
		
		mv.addObject("treeData", tree);
		mv.setViewName("jsonView");
		
		
		return mv;
	}
	
	
	
	//erp 사원연동 결과확인 데이터 초기화
	@RequestMapping("/erp/orgchart/erpEmpInit.do")
	public ModelAndView erpEmpInit(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		commonSql.delete("ErpOrgchartDAO.deleteTmpEmp", params);
		commonSql.delete("ErpOrgchartDAO.deleteTmpEmpMulti", params);
		commonSql.delete("ErpOrgchartDAO.deleteTmpEmpDept", params);
		commonSql.delete("ErpOrgchartDAO.deleteTmpEmpDeptMulti", params);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	@RequestMapping ( "/erp/orgchart/erpSyncScriptProc.do" )
	public ModelAndView erpSyncScriptProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
    		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		Map<String, Object> erpConnectInfo = (Map<String, Object>) commonSql.select("CompManage.getErpConInfo_hr", params);
		
		if(erpConnectInfo != null && erpConnectInfo.get("erp_type_code").equals("ERPiU")) {
			try {
    			Class.forName((String)erpConnectInfo.get("driver"));
    	        
    			String url = (String)erpConnectInfo.get("url");
    			String id = (String)erpConnectInfo.get("userid");
    			String pwd = (String)erpConnectInfo.get("password");
    			
    	        
    	        Connection con = DriverManager.getConnection(url, id, pwd);
    	        ScriptRunner sr = new ScriptRunner(con);
    	        Reader reader = new BufferedReader(new FileReader(ErpSyncOrgchartController.class.getResource("").getPath() + "erpSyncScript/mssql/iu/erpSyncScript_IU_MSSQL.sql"));
    	        sr.runScript(reader);
    	        con.close();
    	        
    	        mv.addObject("resultCode", "SUCCESS");
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	            mv.addObject("resultCode", "ERROR");
	            mv.addObject("resultMsg", e.toString());
	        }
		}else {
			mv.addObject("resultCode", "ERROR");
            mv.addObject("resultMsg", "check Params....");
		}
	        
        return mv;
	}
}


