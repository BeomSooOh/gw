package neos.cmm.erp.task;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.scheduling.annotation.Async;

import bizbox.orgchart.service.vo.LoginVO;
import bizbox.orgchart.util.JedisClient;
import cloud.CloudConnetInfo;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.erp.dao.ErpOrgchartDAO;
import neos.cmm.erp.dao.ErpOrgchartDAOCreator;
import neos.cmm.erp.orgchart.service.ErpOrgchartSyncService;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CollectionUtils;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import neos.cmm.util.code.service.SequenceService;

public class OrgSyncAutoTask {
//	private Logger logger = Logger.getLogger(this.getClass());
	private static Log logger = LogFactory.getLog(OrgSyncAutoTask.class);
	@Resource(name = "ErpOrgchartSyncService")
	private ErpOrgchartSyncService erpOrgchartSyncService;
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	@Resource(name="OrgAdapterService")
	OrgAdapterService orgAdapterService;	
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	/* ERP 조직도 자동 동기화  */
	@SuppressWarnings("unchecked")
	@Async
	public void pollingOrgSyncAuto() throws Exception{		
		
		if(!BizboxAProperties.getProperty("BizboxA.mode").equals("live") || !BizboxAProperties.getProperty("BizboxA.ReserveMessageTimer").equals("0")) {
			return;
		}
		
		JedisClient jedis = CloudConnetInfo.getJedisClient();
		
		List<Map<String, String>> list = jedis.getCustInfoList();
		
		for(Map<String, String> mp : list){
			
			if(mp.get("OPERATE_STATUS") != null && mp.get("OPERATE_STATUS").equals("20")) {
				Map<String, Object> erpAutoSyncTempParams = new HashMap<String, Object>();
				Map<String, Object> erpAutoSyncResult = new HashMap<String, Object>();
				List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
				logger.debug("OrgSyncTask.pollingOrgSyncAuto start....");
				
				result = erpOrgchartSyncService.pollingOrgSyncAuto(mp.get("GROUP_SEQ"));
				
				for(Map<String, Object> temp : result) {
					/* temp 테이블 생성 */
					if(temp.get("result").equals("success")) {
						logger.debug("OrgSyncTaskAuto temp table save start....");
						erpAutoSyncTempParams = erpOrgchartEmpAutoTempStart((Map<String, Object>)temp.get("params"));
						logger.debug("OrgSyncTaskAuto temp table save end....");
					}
					
					/* 동기화 시작 */
					if(temp != null) {
						if(temp.get("result").equals("success")) {
							logger.debug("OrgSyncTaskAuto OrgChart Sync start....");
							erpAutoSyncResult = erpOrgchartEmpAutoSyncStart(erpAutoSyncTempParams);
							logger.debug("OrgSyncTaskAuto erpAutoSyncResult : " + erpAutoSyncResult.get("result"));
							logger.debug("OrgSyncTaskAuto erpAutoSyncResult Message: " + erpAutoSyncResult.get("resultMessage"));
							logger.debug("OrgSyncTaskAuto OrgChart Sync end....");
							
							//erp조직도 직급/직책 동기화 진행
							Map<String, Object> params = new HashMap<String, Object>();
							params.put("groupSeq", ((Map<String, Object>)temp.get("params")).get("groupSeq"));
							params.put("compSeq", ((Map<String, Object>)temp.get("params")).get("compSeq"));
							String resultCode = erpOrgchartSyncService.erpSyncDutyPosiSaveProc(params);
							
							//조직도 자동 동기화 상태값 완료값으로 변경
							params.put("orgAutoSyncStatus", "C");
							commonSql.update("ErpOrgchartDAO.updateOrgAutoSyncStatus", params);
							
							logger.debug("OrgSyncTask.pollingErpSyncDutyPosiSaveProc resultCode : " + resultCode);
						} else {
							logger.debug("OrgSyncTaskAuto Not Using....");
						}
					}
					
				}
				
				logger.debug("OrgSyncTask.pollingOrgSyncAuto end.....");				
			}
		}
	}
	
	/*
	 * 동기화 진행 전 temp 테이블 생성
	 * */
	public Map<String, Object> erpOrgchartEmpAutoTempStart(Map<String, Object> params) throws Exception{
		logger.info("erpOrgchartEmpAutoTempStart Start....");
		Map<String, Object> data = new HashMap<String, Object>();
		
		try{
			String groupSeq = params.get("groupSeq")+"";
			String compSeq = params.get("compSeq")+"";
			
			if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(compSeq)) {
				
				//조직도 자동 동기화 상태값 진행중으로 변경
				params.put("orgAutoSyncStatus", "L");
				commonSql.update("ErpOrgchartDAO.updateOrgAutoSyncStatus", params);
				
				/* 부서(사업장) 임시테이블 생성 */
				params.put("value", "erpSyncSeq");
				String erpSyncSeq = sequenceService.getSequence(params);
				params.put("syncSeq", erpSyncSeq);
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
				
			
				//erpOrgchartSyncService.setErpSync(params);
			
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
	
				erpOrgchartSyncService.setTempdeptOrgchart(params);
				
				/* 사원정보 임시테이블 생성 */
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
	
				
				/** ERP,그룹웨어 코드 맵핑 데이터 조회 
				 *  재직구분, 라이센스
				 * */
				List<Map<String,Object>> typeList = erpOrgchartSyncService.selectErpGwJobCodeList(params);
	
				params.put("typeList", typeList);
				
				
				//자동동기화시 erp퇴사자는 제외하고 조회 
				//자동동기화시 퇴사자처리하지 않음.
				String resignCodeStr = erpOrgchartSyncService.selectErpResignCodeStr(params);
				params.put("resignCodeStr", resignCodeStr);
				
				
				/** ERP 사원 정보 리스트 조회 */
				PaginationInfo paginationInfo = new PaginationInfo();
				int page = EgovStringUtil.zeroConvert("1");
				
				paginationInfo.setCurrentPageNo(page);
				paginationInfo.setPageSize(1000000);
				paginationInfo.setRecordCountPerPage(1000000); 
				params.put("updateErp", "Y");
				Map<String,Object> erpEmpInfo = erpOrgchartDAO.selectErpEmpListOfPage(params, paginationInfo);
				
				logger.debug("erpEmpInfo : " + erpEmpInfo);
				
				@SuppressWarnings("unchecked")
				List<Map<String,Object>> empList = (List<Map<String,Object>>)erpEmpInfo.get("list");
				logger.debug("empList : " + empList);
				
				params.put("empList", empList);
				
				/** ERP 사원정보를 그룹웨어로 동기화시 신규 입사자 로그인 ID 생성 규칙 조회 */
				String optionValue = erpOrgchartSyncService.getCmmOptionValue(compSeq, "cm1102");
				
				if (optionValue != null && !optionValue.equals("0")) {
					params.put("loginIdType", optionValue); //1:erp 사원번호, 2: 이메일
				} else {
					params.put("loginIdType", "1");	// 설정 안되어 있을경우 erp 사원번호 기본값
				}
								
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
				
				// 직급/직책 필수여부값 체크
				String dutyPosiOption = erpOrgchartSyncService.getCmmOptionValue(compSeq, "cm1130");
				params.put("dutyPosiOption", dutyPosiOption);
				
				// 그룹웨어 초기 비밀번호 설정옵션
				String passwdOption = erpOrgchartSyncService.getCmmOptionValue(compSeq, "cm1140");
				params.put("passwdOption", passwdOption);
				
				erpOrgchartSyncService.setTempEmp(params);
				
				/* erp 설정 기본 정보 넘겨주기 위해 */
				data.put("groupSeq", params.get("groupSeq"));
				data.put("compSeq", params.get("compSeq"));
				data.put("langCode", params.get("langCode"));
				data.put("syncStatus", params.get("syncStatus"));
				data.put("autoYn", params.get("autoYn"));
				data.put("erpSyncDate", params.get("erpSyncDate"));
				data.put("syncSeq", erpSyncSeq);
				data.put("orgSyncDate", params.get("endSyncTime"));
//				data.put("endSyncTime", params.get("endSyncTime"));
//				data.put("startSyncTime", params.get("startSyncTime"));
			}
		} catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			logger.error("! [erpAutoSync] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		return data;
	}
	
	public Map<String, Object> erpOrgchartEmpAutoSyncStart(Map<String, Object> params) throws Exception {
		logger.debug("erpOrgchartEmpAutoSyncStart Start....");
		
		Map<String, Object> erpSyncResult = new HashMap<String, Object>();
		List<Map<String, Object>> changeEmpComp = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> changeEmpAuth = new ArrayList<Map<String,Object>>();
		
		try{
			Map<String, Object> result = new HashMap<String, Object>();
			
			String groupSeq = params.get("groupSeq")+"";
			
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
			
			
			//잔여라이센스 확인
			erpOrgchartSyncService.licenseCheck(params);
			
			/* 사업장 */
			result = erpOrgchartSyncService.setBiz(params);
			params.put("deptJoinCnt", result.get("deptJoinTotalCount") == null ? "0" : result.get("deptJoinTotalCount"));
			params.put("deptModifyCnt", result.get("deptModifyTotalCount") == null ? "0" : result.get("deptModifyTotalCount"));
			params.put("empJoinCnt", result.get("empJoinTotalCount") == null ? "0" : result.get("empJoinTotalCount"));
			params.put("empModifyCnt", result.get("empModifyTotalCount") == null ? "0" : result.get("empModifyTotalCount"));
			params.put("empResignCnt", "0");	//퇴사처리는 수동으로만 진행되도록 기획 변경되어 자동동기화시 퇴사처리 카운트 0으로 고정
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
			
//			if(result.get("deleteList") != null) {
//				changeEmpAuth = (List<Map<String, Object>>)result.get("insertAuthList");
//				erpOrgchartSyncService.insertAuthList(changeEmpAuth);
//			}
			
			if(result.get("weddingDayReSetList") != null && !result.get("weddingDayReSetList").toString().equals("")) {
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("empSeqArr", result.get("weddingDayReSetList").toString().split(","));
				paramMap.put("groupSeq", groupSeq);
				erpOrgchartSyncService.reSetWeddingDay(paramMap);
			}
			
			erpOrgchartSyncService.setErpSync(params);
			
			/* 사원퇴사 : 퇴사 처리 관련하여(영리/비영리 전자결재 등 처리) 기능 수정으로 추후 개발해야됨. */
			result = new HashMap<>();
			result.put("resultCode", "0");
			result.put("moreYn", "N");
			
			erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			params.put("erpOrgchartDAO", erpOrgchartDAO);
			
			//퇴사처리는 수동으로만 가능하도록 기획변경 되어 주석처리
//			erpOrgchartSyncService.setEmpResign(params);			
//			erpOrgchartSyncService.setErpSync(params);
			erpOrgchartSyncService.setEmpOrderText(params);
			erpOrgchartSyncService.setMainCompYn(params);	//t_co_emp_Dept -> main_comp_yn 보정처리
//			
//			/* 사원휴직 : 휴직 처리 관련하여(대결자지정) 기능 수정으로 추후 개발해야됨. */
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
					
//					erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
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
		return erpSyncResult;
	}
	
	public void pollingGerpSyncAuto() throws Exception{
		/** ERP 회사 정보 동기화 진행 */
		String erpCompSyncYn = BizboxAProperties.getCustomProperty("BizboxA.Gerp.Sync.compSyncUseYn");
		if (!erpCompSyncYn.equals("Y")) {
			logger.info("OrgSyncTask.pollingGerpSyncAuto gerp sync use = N");
			//mv.addObject("result", "fail");
			return;
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
			
			ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
			
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
			
			
//			erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
			
			List<Map<String,Object>> successEmpList = erpOrgchartSyncService.selectSyncSuccessTmpEmpList(params);
			
			params.put("timeType", "MI");
			params.put("time", "-1"); // 60초 전으로 동기화 완료처리. 다음번 동기화 대상이 되지 않음.
			if (successEmpList != null) {
				for(Map<String,Object> map : successEmpList) {
					params.put("erpEmpSeq", map.get("erpEmpSeq"));
					params.put("erpCompSeq", map.get("erpCompSeq"));
					
//					erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
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
				
				//erpOrgchartSyncService.setErpSync(params);
			
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
				int page = EgovStringUtil.zeroConvert("0");
				
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
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			logger.error("! [erpAutoSync] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		return data;
	}
}
