package neos.migration.suite.controller;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import api.comment.vo.CommentVO;
import api.common.exception.APIException;
import api.common.helper.LogHelper;
import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.util.CommonUtil;
import neos.migration.suite.service.CommentMigService;
import neos.migration.suite.service.ExecuteMigService;
import neos.migration.suite.vo.SuiteBaseInfoVO;
import neos.migration.suite.vo.SuiteDBCnntVO;

@Controller
public class ExecuteMigController {
	
	private Logger LOG = LogManager.getLogger(this.getClass());

	private String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	
	@Resource(name = "ExecuteMigService")
	ExecuteMigService executeMigService;
	
	@Resource(name = "CommentMigService")
	private CommentMigService commentMigService;
	
	private String codeHead = "systemx.comment";

	
	@RequestMapping("/mig/executeMig.do")
	public ModelAndView executeMig(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) {
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		mv.addObject("loginVo", loginVo);
		mv.setViewName("/migration/suite/mig/InputMig");
		return mv;
	}
	
	
	@RequestMapping("/mig/GetSuiteServerInfo.do")
	public ModelAndView getSuiteServerInfo(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {

 			resultMap = executeMigService.getSuiteServerInfo(paramMap);
 			
		} catch (Exception e) {
			
			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter(sw));
			String exceptionAsStrting = sw.toString();			
			LOG.error("Call by GetSuiteServerInfo.do  : " + exceptionAsStrting);
		}
		
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		
		return mv;
	}
	
		
	// mssql DB 연결 확인
	@RequestMapping(value = "/mig/dbConnectConfirm.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public HashMap<String, String> dbConnectConfirm(@RequestParam(required = true) Map<String, Object> paramMap) throws Exception  {
		
		HashMap<String, String> mv = new HashMap<String, String>();		
		
		String dpServerIP = EgovStringUtil.isNullToString(paramMap.get("dbAddr"));
		String dbServerID = EgovStringUtil.isNullToString(paramMap.get("dbLoginId"));
		String dbServerPW = EgovStringUtil.isNullToString(paramMap.get("dbLoginPwd"));
		String dataBaseNm = EgovStringUtil.isNullToString(paramMap.get("dbName"));	 // databasename명
		
		//DB url 셋팅
		String url = "jdbc:sqlserver://"+dpServerIP+";databasename="+dataBaseNm;
		
		try{
			Connection connection = null;
			Class.forName(driver);
			connection = DriverManager.getConnection(url, dbServerID, dbServerPW);		
			
			// 반환 데이터 
			mv.put("result", "1");  // 접속성공  result =1
			connection.close();
			
		} catch(Exception e){
			LOG.error("dbConnectConfirm-error " + driver + " url : " + url, "connection " + e);
			mv.put("result", "-1");  // 접속 실패  result = -1 
		}
		
		LOG.info(" dbConnectConfirm-success 접속정보 : " + url);
		
		return  mv;
	}
	
	// 스위트 문서 정보 호출
	@RequestMapping(value = "/mig/suiteDocCount.do", method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView suiteDocCount(@ModelAttribute("suiteBaseInfoVO") SuiteBaseInfoVO suiteBaseInfoVO, HttpServletRequest request)	throws Exception  {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		try {	
			// DB 데이터베이스명
			if ("build".equals(suiteBaseInfoVO.getBuildType())) {
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");					// 구축형
			} else if("cloud".equals(suiteBaseInfoVO.getBuildType())) {
				suiteBaseInfoVO.setDbName("pangaea");						// 클라우드형 
			}
			
			String url = "jdbc:sqlserver://"+suiteBaseInfoVO.getDbIp()+";databasename="+suiteBaseInfoVO.getDbName();
			
			// suite 정보 획득
			SuiteDBCnntVO suiteDBCnntVO = new SuiteDBCnntVO();
			
			suiteDBCnntVO.setDriver(driver);
			suiteDBCnntVO.setUrl(url);
			suiteDBCnntVO.setUserId(suiteBaseInfoVO.getDbUserId());
			suiteDBCnntVO.setPassWord(suiteBaseInfoVO.getDbPassword());
			
			if ("build".equals(suiteBaseInfoVO.getBuildType())) {
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");	// 구축형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 구축형 " + suiteBaseInfoVO);
			} else { 
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("databasename")));	// 클라우드형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 클라우드형  " + suiteBaseInfoVO);
			}
			// 클라우드 구분자 설정 pangaea > NeoBizBoxS2_0000XX 변경
			String DBurl = "jdbc:sqlserver://"+suiteBaseInfoVO.getDbIp()+";databasename="+suiteBaseInfoVO.getDbName();
			suiteDBCnntVO.setUrl(DBurl);
			
			// 문서 갯수 확인 
			Map<String, Object> param = new HashMap<String, Object>();
			
			int grpId = suiteBaseInfoVO.getGrpId();			
			param.put("grpId", grpId);
			param.put("loginVo", loginVo);
			
			// T_MIG_INFO에서 저장된 문서함 menu_id와 doc_id를 가져옴
			Map<String, Object> elecDocObj = executeMigService.selectTmigInfoDoc(param);
			
			if(elecDocObj != null) {
				String menuId = (String) elecDocObj.get("menuId");
				String docId = (String) elecDocObj.get("docId");
				
				if(menuId != null) {
					param.put("menuId", menuId);
				}
				
				if(docId != null) {
					param.put("docId", docId);
				}
			}
			
			//Suite 종결 문서 갯수 , 권한승인함 데이터 갯수, 결재보관함 뷰어 히스토리 데이터  갯수 호출
			Map<String, Object> selectSuiteDocCount = executeMigService.selectSuiteDocCount(suiteDBCnntVO, suiteBaseInfoVO, param);
			Map<String, Object> selectAuthApproveDocCount = executeMigService.selectAuthApproveDocCount(suiteDBCnntVO, suiteBaseInfoVO);
			Map<String, Object> selectViewDocCount = executeMigService.selectViewDocCount(suiteDBCnntVO, suiteBaseInfoVO);

			
			List<Map<String, Object>> selectAlphaDocumentBoxList = executeMigService.selectAlphaDocBoxList(param);
			
			LOG.info(" 문서 갯수  : " + selectSuiteDocCount.get("suiteDoc"));
			
			mv.addObject("suiteDoc",selectSuiteDocCount.get("suiteDoc"));
			mv.addObject("authApproveDoc",selectAuthApproveDocCount.get("authApproveDoc"));
			mv.addObject("viewDoc",selectViewDocCount.get("viewDoc"));

			mv.addObject("alphaDocumentBoxList", selectAlphaDocumentBoxList);
			mv.addObject("result", "1");
			mv.setViewName("jsonView");

		} catch(NumberFormatException e) {
			LOG.error(" 에러 : " + e);
		} catch (Exception e) {
			LOG.error(" 에러 : " + e);
		}
		
		return mv;
	}
	
	// 스위트 menu_id에 맞는 doc_id 조회, 1000개씩 끊어서 가져옴
	@RequestMapping(value = "/mig/suiteDocId.do", method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView suiteDocId(@ModelAttribute("suiteBaseInfoVO") SuiteBaseInfoVO suiteBaseInfoVO, HttpServletRequest request)	throws Exception  {
			
		ModelAndView mv = new ModelAndView();
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		try {	
			// DB 데이터베이스명
			if ("build".equals(suiteBaseInfoVO.getBuildType())) {
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");					// 구축형
			} else if("cloud".equals(suiteBaseInfoVO.getBuildType())) {
				suiteBaseInfoVO.setDbName("pangaea");						// 클라우드형 
			}
			
			String url = "jdbc:sqlserver://"+suiteBaseInfoVO.getDbIp()+";databasename="+suiteBaseInfoVO.getDbName();
			
			// suite 정보 획득
			SuiteDBCnntVO suiteDBCnntVO = new SuiteDBCnntVO();
			
			suiteDBCnntVO.setDriver(driver);
			suiteDBCnntVO.setUrl(url);
			suiteDBCnntVO.setUserId(suiteBaseInfoVO.getDbUserId());
			suiteDBCnntVO.setPassWord(suiteBaseInfoVO.getDbPassword());
			
			if ("build".equals(suiteBaseInfoVO.getBuildType())) {
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");	// 구축형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 구축형 " + suiteBaseInfoVO);
			} else { 
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("databasename")));	// 클라우드형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 클라우드형  " + suiteBaseInfoVO);
			}
			// 클라우드 구분자 설정 pangaea > NeoBizBoxS2_0000XX 변경
			String DBurl = "jdbc:sqlserver://"+suiteBaseInfoVO.getDbIp()+";databasename="+suiteBaseInfoVO.getDbName();
			suiteDBCnntVO.setUrl(DBurl);
			
			// 마이그레이션 재시작 여부 값
			boolean checkRestartMig = suiteBaseInfoVO.isCheckRestartMig();
			
			// 문서 갯수 확인 
			Map<String, Object> param = new HashMap<String, Object>();
			
			int grpId = suiteBaseInfoVO.getGrpId();
			String recordDocCnt = suiteBaseInfoVO.getRecordDocCnt();
		
			param.put("grpId", grpId);
			param.put("loginVo", loginVo);
			param.put("startCnt", recordDocCnt);
			param.put("endCnt", Integer.parseInt(recordDocCnt) + 999);
			param.put("suiteMenuId", suiteBaseInfoVO.getSuiteMenuId());
			
			if(checkRestartMig) {
				
				// T_MIG_INFO에서 저장된 문서함 menu_id와 doc_id를 가져옴
				Map<String, Object> elecDocObj = executeMigService.selectTmigInfoDoc(param);
				
				if(elecDocObj != null) {
					String docId = (String) elecDocObj.get("docId");
					
					if(docId != null) {
						param.put("docId", docId);
					}
				}
			}
			
			//Suite 결재보관함에 있는 문서들의 docId를 조회
			List<Map<String, Object>> selectSuiteDocIdList = executeMigService.selectSuiteDocId(suiteDBCnntVO, param);
			
			// selectAlphaElecDocList 쿼리에 doc_id 전달 할수있도록 값 변경
			String docIdList = executeMigService.convertDocIdList(selectSuiteDocIdList);
			param.put("docIdList", docIdList);
			
			//Alpha 전자결재 teag_appdoc 에서 docId를 이용하여 조회
			List<Map<String, Object>> selectAlphaElecDocList = executeMigService.selectAlphaElecDocList(param);
			
//			LOG.info(" 문서 갯수  : " + selectSuiteDocCount.get("suiteDoc"));
//			
//			mv.addObject("suiteDoc",selectSuiteDocCount.get("suiteDoc"));
//			mv.addObject("alphaDocumentBoxList", selectAlphaDocumentBoxList);
			mv.addObject("result", "1");
			mv.addObject("elecDocList", selectAlphaElecDocList);
			mv.setViewName("jsonView");
	
		} catch(NumberFormatException e) {
			LOG.error(" 에러 : " + e);
		} catch (Exception e) {
			LOG.error(" 에러 : " + e);
		}
		
		return mv;
	}
	
	// 변환한 전자결재문서들이 권한승인함 및 뷰어 히스토리 테이블에 데이터가 있을경우 insert
	@RequestMapping(value = "/mig/insertAuthApproveViewDoc.do", method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView insertAuthApproveViewDoc(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)	throws Exception  {
			
		ModelAndView mv = new ModelAndView();
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		SuiteBaseInfoVO suiteBaseInfoVO = new SuiteBaseInfoVO();
		String buildType = EgovStringUtil.isNullToString(paramMap.get("buildType"));
		String dbIp = EgovStringUtil.isNullToString(paramMap.get("dbIp"));
		String dbUserId = EgovStringUtil.isNullToString(paramMap.get("dbUserId"));
		String dbPassword = EgovStringUtil.isNullToString(paramMap.get("dbPassword"));
		String docIdList = EgovStringUtil.isNullToString(paramMap.get("docIdList"));
		String failDocIdList = EgovStringUtil.isNullToString(paramMap.get("failDocIdList"));
		int grpId = Integer.parseInt((String) paramMap.get("grpId"));
		
		suiteBaseInfoVO.setBuildType(buildType);
		suiteBaseInfoVO.setDbIp(dbIp);
		suiteBaseInfoVO.setDbUserId(dbUserId);
		suiteBaseInfoVO.setDbPassword(dbPassword);
		suiteBaseInfoVO.setGrpId(grpId);

		try {	
			// DB 데이터베이스명
			if ("build".equals(buildType)) {
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");					// 구축형
			} else if("cloud".equals(buildType)) {
				suiteBaseInfoVO.setDbName("pangaea");						// 클라우드형 
			}
			
			String url = "jdbc:sqlserver://"+ dbIp +";databasename="+suiteBaseInfoVO.getDbName();
			
			// suite 정보 획득
			SuiteDBCnntVO suiteDBCnntVO = new SuiteDBCnntVO();
			
			suiteDBCnntVO.setDriver(driver);
			suiteDBCnntVO.setUrl(url);
			suiteDBCnntVO.setUserId(dbUserId);
			suiteDBCnntVO.setPassWord(dbPassword);
			
			if ("build".equals(buildType)) {
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");	// 구축형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 구축형 " + suiteBaseInfoVO);
			} else { 
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("databasename")));	// 클라우드형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 클라우드형  " + suiteBaseInfoVO);
			}
			// 클라우드 구분자 설정 pangaea > NeoBizBoxS2_0000XX 변경
			String DBurl = "jdbc:sqlserver://"+ dbIp +";databasename="+suiteBaseInfoVO.getDbName();
			LOG.info("DBUrl: ", DBurl);
			suiteDBCnntVO.setUrl(DBurl);
			
			// 문서 갯수 확인 
			Map<String, Object> param = new HashMap<String, Object>();
			
			//int grpId = suiteBaseInfoVO.getGrpId();
		
			param.put("grpId", grpId);
			param.put("loginVo", loginVo);
			param.put("docIdList", docIdList);
			param.put("suiteMenuId", paramMap.get("suiteMenuId"));
			
			LOG.info("suiteDBCnntVO: ", suiteDBCnntVO.toString());
			LOG.info("param: ", param.toString());

			//Suite "TEDG_DOC_AUTH", "TEAD_DOC_READ" 테이블에 전달받은 파라미터의 doc_id에 맞는 데이터가 있는지 조회
			List<Map<String, Object>> selectAuthApproveDocList = executeMigService.selectAuthApproveDocList(suiteDBCnntVO, param);
			List<Map<String, Object>> selectViewDocList = executeMigService.selectViewDocList(suiteDBCnntVO, param);
			
			LOG.info("selectAuthApproveDocList: " + selectAuthApproveDocList.toString());
			LOG.info("selectViewDocList: "+ selectViewDocList.toString());

			// 조회한 데이터의 doc_id 값으로 Alpha art_seq_no를 구함
			List<Map<String, Object>> selectElecDocArtList = executeMigService.selectElecDocArtList(param);
			LOG.info("selectElecDocArtList: "+ selectElecDocArtList.toString());

			// 해당 doc_id에 맞는 "TEDG_DOC_AUTH" 테이블에 데이터가 있을경우 Alpha "BPM_ART_PERM" 테이블에 insert
			if(selectAuthApproveDocList.size() > 0) {
				
				for(int k = 0, lenK = selectElecDocArtList.size(); k < lenK; k++) {

					for(int i = 0, len = selectAuthApproveDocList.size(); i < len; i++) {
						
						if(selectElecDocArtList.get(k).get("outerKey").equals(EgovStringUtil.isNullToString(selectAuthApproveDocList.get(i).get("docId")))) {

							String confirmUserId = EgovStringUtil.isNullToString(selectAuthApproveDocList.get(i).get("confirmUserId"));
							String confirmYn = EgovStringUtil.isNullToString(selectAuthApproveDocList.get(i).get("confirmYn"));
							
							param.put("artSeqNo", selectElecDocArtList.get(k).get("artSeqNo"));
							param.put("compId", selectElecDocArtList.get(k).get("compId"));
							param.put("outerKey", selectElecDocArtList.get(k).get("outerKey"));
							
							if(confirmYn.equals("1") && !confirmUserId.equals("")) {
								param.put("approvalId", confirmUserId);
								param.put("permState", "A");
							}else {
								param.put("approvalId", null);
								param.put("permState", "R");
							}
							
							param.put("permId", selectAuthApproveDocList.get(i).get("requestUserId"));
							param.put("regDate", selectAuthApproveDocList.get(i).get("createdDt"));
							param.put("approvalDate", selectAuthApproveDocList.get(i).get("modifyDt"));
							
							executeMigService.insertAlphaAuthApproveDoc(param);
						}
						
					}
				}
							
			}
			
			// 해당 doc_id에 맞는 "TEDG_DOC_READ" 테이블에 데이터가 있을경우 Alpha "BPM_READ_RECORD" 테이블에 insert
			if(selectViewDocList.size() > 0) {
				
				for(int k = 0, lenK = selectElecDocArtList.size(); k < lenK; k++) {
					
					for(int i = 0, len = selectViewDocList.size(); i < len; i++) {
						
						if(selectElecDocArtList.get(k).get("outerKey").equals(EgovStringUtil.isNullToString(selectViewDocList.get(i).get("docId")))) {
							
							param.put("artSeqNo", selectElecDocArtList.get(k).get("artSeqNo"));
							
							param.put("mbrId", selectViewDocList.get(i).get("userId"));
							param.put("regDate", selectViewDocList.get(i).get("lastReadDt"));
							executeMigService.insertAlphaViewDoc(param);
						}
					}
				}
			}
			
			//Alpha T_MIG_INFO 테이블에 현재까지 진행한 문서함 menu_id 및 doc_id 정보를 저장
			String[] docIdListSplit = docIdList.split(",");
			if(docIdListSplit.length > 0) {
				param.put("docId", docIdListSplit[docIdListSplit.length - 1]);
			}else {
				param.put("docId", docIdList);
			}
			param.put("suiteMenuId", paramMap.get("suiteMenuId"));
			
			executeMigService.updateDocIdTmigInfo(param);
			
			
			// 실패한 문서id를 db에 저장
			param.put("failDocIdList", failDocIdList);
			executeMigService.updateFailDocId(param);
			
			mv.addObject("result", "1");
			
			// 몇개나 실패했는지 알수없음
			mv.addObject("authDocSuccessCnt", selectAuthApproveDocList.size());
			mv.addObject("viewDocSuccessCnt", selectViewDocList.size());

			mv.setViewName("jsonView");
	
		} catch(NumberFormatException e) {
			LOG.error(" insertAuthApproveViewDoc ERROR : " + e);
		} catch (Exception e) {
			LOG.error(" insertAuthApproveViewDoc ERROR : " + e);
			mv.addObject("result", null);
		}
		
		return mv;
	}
	
	/* 마이그레이션 시작 버튼 클릭 시
	 *  BPM_ART_PERM
	 *  
	 *  위 테이블 초기화
	 */
	@RequestMapping(value = "/mig/cleanAlphaBpmTable.do", method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView cleanAlphaBpmTable(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)	throws Exception  {
			
		ModelAndView mv = new ModelAndView();
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		

		try {	

			// 문서 갯수 확인 
			Map<String, Object> param = new HashMap<String, Object>();
					
			param.put("loginVo", loginVo);
			
			LOG.info("param: ", param.toString());

			//executeMigService.deleteBpmArt(param);
			executeMigService.deleteBpmArtPerm(param);
			//executeMigService.deleteBpmAttachFile(param);
			//executeMigService.deleteBpmReadRecord(param);

			mv.addObject("result", "1");
			
			mv.setViewName("jsonView");
	
		} catch(NumberFormatException e) {
			LOG.error(" cleanAlphaBpmTable ERROR : " + e);
		} catch (Exception e) {
			LOG.error(" cleanAlphaBpmTable ERROR : " + e);
			mv.addObject("result", null);
		}
		
		return mv;
	}
	
	// Suite 게시판, 문서 댓글 조회 
	@RequestMapping(value = "/mig/SuiteSelectBoardDocComment.do", method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView SuiteSelectBoardDocComment(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)	throws Exception  {
			
		ModelAndView mv = new ModelAndView();
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		SuiteBaseInfoVO suiteBaseInfoVO = new SuiteBaseInfoVO();
		String buildType = EgovStringUtil.isNullToString(paramMap.get("buildType"));
		String dbIp = EgovStringUtil.isNullToString(paramMap.get("dbIp"));
		String dbUserId = EgovStringUtil.isNullToString(paramMap.get("dbUserId"));
		String dbPassword = EgovStringUtil.isNullToString(paramMap.get("dbPassword"));
		String docIdList = EgovStringUtil.isNullToString(paramMap.get("docIdList"));
		int grpId = Integer.parseInt((String) paramMap.get("grpId"));
		Map<String, Object> param = new HashMap<String, Object>();
		
		suiteBaseInfoVO.setBuildType(buildType);
		suiteBaseInfoVO.setDbIp(dbIp);
		suiteBaseInfoVO.setDbUserId(dbUserId);
		suiteBaseInfoVO.setDbPassword(dbPassword);
		suiteBaseInfoVO.setGrpId(grpId);

		try {	
			// DB 데이터베이스명
			if ("build".equals(buildType)) {
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");					// 구축형
			} else if("cloud".equals(buildType)) {
				suiteBaseInfoVO.setDbName("pangaea");						// 클라우드형 
			}
			
			String url = "jdbc:sqlserver://"+ dbIp +";databasename="+suiteBaseInfoVO.getDbName();
			
			// suite 정보 획득
			SuiteDBCnntVO suiteDBCnntVO = new SuiteDBCnntVO();
			
			suiteDBCnntVO.setDriver(driver);
			suiteDBCnntVO.setUrl(url);
			suiteDBCnntVO.setUserId(dbUserId);
			suiteDBCnntVO.setPassWord(dbPassword);
			
			if ("build".equals(buildType)) {
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName("NeoBizBoxS2");	// 구축형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 구축형 " + suiteBaseInfoVO);
			} else { 
				Map<String, Object> selectSuiteCompanyInfoC = executeMigService.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
				suiteBaseInfoVO.setGrpCd(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_cd")));
				suiteBaseInfoVO.setGrpNm(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("grp_nm")));
				suiteBaseInfoVO.setDbName(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("databasename")));	// 클라우드형
				suiteBaseInfoVO.setDomain(EgovStringUtil.isNullToString(selectSuiteCompanyInfoC.get("domain")));
				
				LOG.info(" 클라우드형  " + suiteBaseInfoVO);
			}
			// 클라우드 구분자 설정 pangaea > NeoBizBoxS2_0000XX 변경
			String DBurl = "jdbc:sqlserver://"+ dbIp +";databasename="+suiteBaseInfoVO.getDbName();
			LOG.info("DBUrl: ", DBurl);
			suiteDBCnntVO.setUrl(DBurl);
			
			//Suite 게시판 댓글 조회
			List<Map<String, Object>> selectSuiteBoardCommentList = executeMigService.selectSuiteBoardCommentList(suiteDBCnntVO, param);
			
			//Suite 문서 댓글 조회
			List<Map<String, Object>> selectSuiteDocCommentList = executeMigService.selectSuiteDocCommentList(suiteDBCnntVO, param);

			mv.addObject("result", "1");
			mv.addObject("selectSuiteBoardCommentList", selectSuiteBoardCommentList);
			mv.addObject("selectSuiteDocCommentList", selectSuiteDocCommentList);
			mv.setViewName("jsonView");
	
		} catch(NumberFormatException e) {
			LOG.error(" SuiteSelectBoardDocComment ERROR : " + e);
		} catch (Exception e) {
			LOG.error(" SuiteSelectBoardDocComment ERROR : " + e);
			mv.addObject("result", null);
		}
		
		return mv;
	}
		
    /*
     * post 호출 및 json 응답
     * 댓글 등록/수정
     */
	@RequestMapping(value="/mig/InsertCommentMig.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse InsertCommentMig(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT001";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		try {
			
			CommentVO commentVo = new CommentVO();
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			commentVo.setEmpSeq(body.get("empSeq").toString());
			
			commentVo.setLangCode(body.get("langCode").toString());
			commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
			commentVo.setModuleSeq(body.get("moduleSeq").toString());
			commentVo.setCommentType(body.get("commentType").toString());
			commentVo.setCommentSeq(body.get("commentSeq").toString());
			commentVo.setParentCommentSeq(body.get("parentCommentSeq").toString());
			commentVo.setContents(body.get("contents").toString());
			commentVo.setHighGbnCode(body.get("highGbnCode").toString());
			commentVo.setMiddleGbnCode(body.get("middleGbnCode").toString());
			commentVo.setEmpName(body.get("empName").toString());
			commentVo.setCommentPassword(body.get("commentPassword").toString());
			commentVo.setDutyCode(body.get("dutyCode").toString());
			commentVo.setPositionCode(body.get("positionCode").toString());
			commentVo.setFileId(body.get("fileId").toString());
			commentVo.setCompSeq(body.get("compSeq").toString());
			commentVo.setBizSeq(body.get("bizSeq").toString());
			commentVo.setDeptSeq(body.get("deptSeq").toString());
			commentVo.setGroupSeq(body.get("groupSeq").toString());
			
			commentVo.setDepth((int)body.get("depth"));
			commentVo.setTopLevelCommentSeq(body.get("topLevelCommentSeq").toString());
			commentVo.setEvent((Map<String,Object>)body.get("event"));
			commentVo.setCreateDate(body.get("createDate").toString());
			
			if("".equals(body.get("empName").toString())) {
				commentVo.setCreateIp(CommonUtil.getClientIp(servletRequest));
			}
			 LOG.info("InsertComment" + "-start " + LogHelper.getRequestString(request));
			 Map<String,Object> result = commentMigService.insertComment(commentVo);	
			 response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 LOG.info("InsertComment" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 LOG.error("InsertComment" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 LOG.error("InsertComment" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		return response;		
	}
	
	/* 게시판, 문서 댓글 이관 전 공통 댓글 테이블 백업
	 *  T_CO_COMMENT
	 *  T_CO_COMMENT_COUNT
	 *  위 테이블 백업
	 */
	@RequestMapping(value = "/mig/backupCommentTable.do", method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView backupCommentTable(@RequestParam Map<String, Object> paramMap, HttpServletRequest request)	throws Exception  {
			
		ModelAndView mv = new ModelAndView();
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		

		try {	

			Map<String, Object> param = new HashMap<String, Object>();
					
			param.put("loginVo", loginVo);
			
			LOG.info("param: ", param.toString());
			
			SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMddHHmmss");
					
			Calendar time = Calendar.getInstance();
			       
			String format_time1 = format1.format(time.getTime());
			        
			param.put("commentTableName", "t_co_comment_bak" + format_time1);
			param.put("commentCountTableName", "t_co_comment_count_bak" + format_time1);
			
			executeMigService.createCommentTableBackup(param);
			executeMigService.createCommentCountTableBackup(param);


			mv.addObject("result", "1");
			mv.addObject("commentBackupTableName", param.get("commentTableName"));
			mv.addObject("commentCountBackupTableName", param.get("commentCountTableName"));

			mv.setViewName("jsonView");
	
		} catch(NumberFormatException e) {
			LOG.error(" backupCommentTable ERROR : " + e);
		} catch (Exception e) {
			LOG.error(" backupCommentTable ERROR : " + e);
			mv.addObject("result", null);
		}
		
		return mv;
	}
	
	/* T_MIG_INFO에 저장된 문서함 id, 문서 id 값을 리턴
	 *  
	 */
	@RequestMapping(value = "/mig/backupBPMTable.do", method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView backupBPMTable(@RequestBody Map<String, Object> paramMap, HttpServletRequest request)	throws Exception  {
			
		ModelAndView mv = new ModelAndView();
		LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {	
			
			Map<String, Object> param = new HashMap<>();
			
			param.put("loginVo", loginVo);
			
			LOG.info("param: ", param.toString());
			
			SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMddHHmmss");
					
			Calendar time = Calendar.getInstance();
			       
			String format_time1 = format1.format(time.getTime());
			
			// T_MIG_INFO에서 저장된 문서함 menu_id와 doc_id를 가져옴
			Map<String, Object> elecDocObj = executeMigService.selectTmigInfoDoc(param);

			mv.addObject("result", "1");
			mv.addObject("menuId", elecDocObj.get("menuId"));
			mv.addObject("docId", elecDocObj.get("docId"));
			
			mv.setViewName("jsonView");
	
		} catch(NumberFormatException e) {
			LOG.error(" backupBPMTable ERROR : " + e);
		} catch (Exception e) {
			LOG.error(" backupBPMTable ERROR : " + e);
			mv.addObject("result", null);
		}
		
		return mv;
	}

	
}


