package neos.cmm.util.code;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import bizbox.orgchart.util.JedisClient;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.service.impl.CommonCodeDAO;

@Controller
@RequestMapping(value="/cmm/system/")
public class CommonCode {
	@Resource(name = "CommonCodeDAO")
	private CommonCodeDAO commonCodeDAO;
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;

	@Resource(name = "LicenseService")
	private LicenseService licenseService;

	
	
	/**
	 * 코드 리스트 조회
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonCodeList.do")
	public ModelAndView getCodeList(String codeID) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String langCode = "";
		if(loginVO == null) {
			langCode = "kr";
		}
		else {
			langCode = loginVO.getLangCode();
		}
		
		
		List<Map<String, String>> list = CommonCodeUtil.getCodeList( codeID, langCode) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}
	
	/**
	 * 코드 리스트 조회(다국어)
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonCodeMultiList.do")
	public ModelAndView getCodeMultiList(String codeID, String langCode) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getCodeList(codeID, langCode) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}
	
	/**
	 * 코드 리스트 조회(Child/다국어)
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonChildCodeMultiList.do")
	public ModelAndView getChildCodeMultiList(String codeID, String langCode) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getChildCodeList(codeID, langCode) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}
	
	/**
	 * 코드 리스트 조회(Child)
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonChildCodeList.do")
	public ModelAndView getChildCodeList(String codeID) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getChildCodeList( codeID) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}
	
	/**
	 * 코드 리스트 조회(Child)
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonChildCodeListAll.do")
	public ModelAndView getChildCodeListAll() throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getChildCodeListAll( ) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}	
	

	/**
	 * 코드이름 조회
	 * @param codeId
	 * @param code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonCodeName.do")
	public ModelAndView getCodeName(String codeId, String code) throws Exception {
		ModelAndView mv = new ModelAndView();
		String codeName = CommonCodeUtil.getCodeName( codeId, code) ;
		mv.setViewName("jsonView");
		mv.addObject("codeName", codeName);
		return mv;
	}

	
	/**
	 * 코드이름 조회(Child)
	 * @param codeId
	 * @param code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonChildCodeName.do")
	public ModelAndView getChildCodeName(String codeId, String code) throws Exception {
		ModelAndView mv = new ModelAndView();
		String codeName = CommonCodeUtil.getChildCodeName( codeId, code) ;
		mv.setViewName("jsonView");
		mv.addObject("codeName", codeName);
		return mv;
	}
	
	/**
	 * 코드캐쉬 초기화
	 * @throws Exception
	 */
	@RequestMapping("commonCodeReBuild.do")
	public ModelAndView getCodeReBuild(String groupSeq) throws Exception {
		
		ModelAndView mv =  new ModelAndView();
		mv.setViewName("jsonView");
		
		if(groupSeq == null || groupSeq.equals("")){
			return mv;
		}
		else{
			try {
				CommonCodeUtil.reBuild(commonCodeDAO, groupSeq) ;
				mv.addObject("errorCode", "0");
			}catch( Exception e ) {
				mv.addObject("errorCode", "1");
			}
			return mv;
		}
	}
	
	
	
	@RequestMapping("commonCodeReBuildAll.do")
	public ModelAndView commonCodeReBuildAll(String groupSeq) throws Exception {
		ModelAndView mv =  new ModelAndView();

			
		JedisClient jedis = CloudConnetInfo.getJedisClient();
		
		List<Map<String, String>> list = jedis.getCustInfoList();

		for(Map<String, String> mp : list){
			try {
				if(mp.get("OPERATE_STATUS") != null && mp.get("OPERATE_STATUS").equals("20")) {
					CommonCodeUtil.reBuild(commonCodeDAO, mp.get("GROUP_SEQ")) ;
					CommonCodeUtil.initCmmOption(commonCodeDAO, mp.get("GROUP_SEQ")) ;
				}
			}catch(Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		
		mv.setViewName("jsonView");
		mv.addObject("errorCode", "0");
		
		return mv;

	}
	
	/**
	 * 프로퍼티캐쉬 초기화
	 * @throws Exception
	 */
	@RequestMapping("propertiesReBuild.do")
	public ModelAndView propertiesReBuild() throws Exception {
		ModelAndView mv =  new ModelAndView();
		mv.setViewName("jsonView");
		try {
			BizboxAProperties.resetProperty();
			licenseService.resetLicense();
			
			mv.addObject("result", "ok");
		}catch( Exception e ) {
			mv.addObject("result", "fail : " + e.getMessage());
		}		
		return mv;
	}	
	
	/**
	 * 급여명세서 기초프로시저 수정 쿼리 반영
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping ("erpPayProcedureReBuild.do")
	public ModelAndView test ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName( "jsonView" );
		
		Map<String, Object> mp = (Map<String, Object>) commonSql.select("CompManage.getErpConectInfo", params);
		
		if(params.get("compCd") == null || params.get("groupSeq") == null){
			mv.addObject("resultCode","params Error");
			return mv;
		}else if(mp == null || !mp.get("databaseType").equals("mssql")){
			mv.addObject("resultCode","erpInfo is null");
			return mv;
		}else if(!mp.get("erpTypeCode").equals("ERPiU")){
			mv.addObject("resultCode","erpTypeCode is " + mp.get("erpTypeCode"));
			return mv;
		}else{		
			String url = (String)mp.get("url");
			Connection conn = null;
			Statement stmt = null;
			Class.forName((String)mp.get("driver"));
			conn = DriverManager.getConnection(url, (String)mp.get("userid"), (String)mp.get("password"));
			stmt = conn.createStatement();
	
			String query1 = "";
			String query2 = "";
			String query3 = "";
			String query4 = "";
			String query5 = "";
			
			String delQuery1 = "DROP PROCEDURE [NEOE].[UP_HR_PAY_LIST_EMP_S_GW]";
			String delQuery2 = "DROP PROCEDURE [NEOE].[UP_HR_PAY_LIST_FORM_S_GW]";
			String delQuery3 = "DROP PROCEDURE [NEOE].[UP_HR_PAY_LIST_S_GW]";
			String delQuery4 = "DROP PROCEDURE [NEOE].[UP_HR_PAY_LIST_TPPAY_S_GW]";
			String delQuery5 = "DROP PROC [NEOE].[UP_HR_PAYRPT_S_GW]";
	
			
			query1 += "CREATE PROCEDURE [NEOE].[UP_HR_PAY_LIST_EMP_S_GW]																							\n";
			query1 += "(																																			\n";
			query1 += "	@P_CD_COMPANY  		NVARCHAR(7),																										\n";
			query1 += "	@P_NO_EMP			NVARCHAR(10)																										\n";
			query1 += ")																																			\n";
			query1 += "AS																																		\n";
			query1 += "																																			\n";
			query1 += "SELECT	E.CD_COMPANY,					--회사코드																							\n";
			query1 += "		E.CD_BIZAREA,					--사업장코드																								\n";
			query1 += "		E.CD_DEPT,						--부서코드																								\n";
			query1 += "		D.NM_DEPT,						--부서명																								\n";
			query1 += "		E.NO_EMP,						--사번																								\n";
			query1 += "		E.NM_KOR,						--이름																								\n";
			query1 += "		CASE WHEN ISNULL(E.DT_ENTER, '') <> '' 																								\n";
			query1 += "			 THEN LEFT(E.DT_ENTER, 4) + '/' + SUBSTRING(E.DT_ENTER, 5, 2) + '/' + RIGHT(E.DT_ENTER, 2)										\n";
			query1 += "			 ELSE ''																														\n";
			query1 += "		END DT_ENTER,					--입사일자 																								\n";
			query1 += "		E.CD_DUTY_RESP,					--직책																								\n";
			query1 += "		CD1.NM_SYSDEF NM_DUTY_RESP,		--직책명																								\n";
			query1 += "		E.CD_DUTY_STEP,					--직급																								\n";
			query1 += "		CD2.NM_SYSDEF NM_DUTY_STEP		--직급명																								\n";
			query1 += "																																			\n";
			query1 += "FROM	MA_EMP E																															\n";
			query1 += "LEFT OUTER JOIN MA_DEPT D ON E.CD_COMPANY = D.CD_COMPANY AND E.CD_DEPT = D.CD_DEPT														\n";
			query1 += "LEFT OUTER JOIN MA_CODEDTL CD1 ON E.CD_COMPANY = CD1.CD_COMPANY AND E.CD_DUTY_RESP = CD1.CD_SYSDEF AND CD1.CD_FIELD = 'HR_H000052'		\n";
			query1 += "LEFT OUTER JOIN MA_CODEDTL CD2 ON E.CD_COMPANY = CD2.CD_COMPANY AND E.CD_DUTY_STEP = CD2.CD_SYSDEF AND CD2.CD_FIELD = 'HR_H000003'		\n";
			query1 += "WHERE	E.CD_COMPANY = @P_CD_COMPANY 																										\n";
			query1 += "AND		E.NO_EMP = @P_NO_EMP 																											\n";
			query1 += "																																			\n";
			query1 += "return																																	\n";
	
			
			query2 += "CREATE PROCEDURE [NEOE].[UP_HR_PAY_LIST_FORM_S_GW]																			\n";
			query2 += "(																																\n";
			query2 += "	@P_CD_COMPANY  	NVARCHAR(7)																									\n";
			query2 += ")																																\n";
			query2 += "AS																															\n";
			query2 += "																																\n";
			query2 += "SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED																				\n";
			query2 += "SET NOCOUNT ON																												\n";
			query2 += "																																\n";
			query2 += "SELECT	TP_REPORT, 																											\n";
			query2 += "		NM_REPORT,																												\n";
			query2 += "		TP_EMP,																													\n";
			query2 += "		ISNULL(YN_DEFAULT, 'N') YN_DEFAULT																						\n";
			query2 += "		--ISNULL(YN_DEFAULT1, 'N') YN_DEFAULT1, 																				\n";
			query2 += "		--ISNULL(YN_DEFAULT2, 'N') YN_DEFAULT2																					\n";
			query2 += "FROM 	HR_PREPHEADER																											\n";
			query2 += "WHERE 	CD_COMPANY = @P_CD_COMPANY 																							\n";
			query2 += "GROUP BY TP_REPORT, NM_REPORT, TP_EMP, ISNULL(YN_DEFAULT, 'N'), ISNULL(YN_DEFAULT1, 'N'), ISNULL(YN_DEFAULT2, 'N')			\n";
			query2 += "ORDER BY TP_REPORT;																											\n";	

			
			query3 += "CREATE PROCEDURE [NEOE].[UP_HR_PAY_LIST_S_GW]									\n";					
			query3 += "			(													          		\n";
			query3 += "				@P_CD_COMPANY  		NVARCHAR(7),				          		\n";
			query3 += "				@P_NO_EMP			NVARCHAR(10),				          		\n";
			query3 += "				@P_CD_BIZAREA		NVARCHAR(15),				          		\n";
			query3 += "				@P_YM_FROM			NVARCHAR(6),				          		\n";
			query3 += "				@P_YM_TO			NVARCHAR(6),				          		\n";
			query3 += "				@P_TYPE				NVARCHAR(3) = NULL			          		\n";
			query3 += "			)													          		\n";
			query3 += "			AS												              		\n";
			query3 += "																          		\n";
			query3 += "			IF @P_TYPE = '002'								              		\n";
			query3 += "			BEGIN												          		\n";
			query3 += "				SELECT	P.YM									          		\n";
			query3 += "				FROM	HR_PCALCPAY P							          		\n";
			query3 += "				INNER JOIN HR_PTITLE T							          		\n";
			query3 += "				ON	P.CD_COMPANY = T.CD_COMPANY					          		\n";
			query3 += "				AND P.CD_BIZAREA = T.CD_BIZAREA					          		\n";
			query3 += "				AND P.CD_EMP = T.CD_EMP							          		\n";
			query3 += "				AND P.YM = T.YM									          		\n";
			query3 += "				AND P.NO_SEQ = T.NO_SEQ							          		\n";
			query3 += "				AND P.TP_EMP = T.TP_EMP							          		\n";
			query3 += "				AND P.TP_PAY = T.TP_PAY							          		\n";
			query3 += "				INNER JOIN HR_BCLOSE C							          		\n";
			query3 += "				ON	P.CD_COMPANY	= C.CD_COMPANY 				          		\n";
			query3 += "				AND P.CD_BIZAREA = C.CD_BIZAREA 				          		\n";
			query3 += "				AND P.CD_EMP = C.CD_EMP 						          		\n";
			query3 += "				AND P.YM = C.YM 								          		\n";
			query3 += "				AND P.NO_SEQ = C.NO_SEQ							          		\n";
			query3 += "				AND P.TP_EMP = C.TP_EMP 						          		\n";
			query3 += "				AND P.TP_PAY = C.TP_PAY							          		\n";
			query3 += "				AND C.TP_CLOSE = '001'							          		\n";
			query3 += "				AND ISNULL(C.DT_CLOSE, '') <> ''				          		\n";
			query3 += "				WHERE	P.CD_COMPANY = @P_CD_COMPANY 			          		\n";
			query3 += "				AND		P.NO_EMP = @P_NO_EMP 					          		\n";
			query3 += "				AND		T.CD_BIZAREA = @P_CD_BIZAREA 			          		\n";
			query3 += "				AND		P.YM BETWEEN @P_YM_FROM AND @P_YM_TO	          		\n";
			query3 += "				GROUP BY P.YM									          		\n";
			query3 += "				ORDER BY P.YM									          		\n";
			query3 += "			END												              		\n";
			query3 += "			ELSE												          		\n";
			query3 += "			BEGIN												          		\n";
			query3 += "				SELECT	P.YM, 									          		\n";
			query3 += "						T.NO_SEQ,								          		\n";
			query3 += "						T.DT_PAY, 								          		\n";
			query3 += "						T.TP_PAY,								          		\n";
			query3 += "						T.NM_TITLE								          		\n";
			query3 += "				FROM	HR_PCALCPAY P							          		\n";
			query3 += "				INNER JOIN HR_PTITLE T							          		\n";
			query3 += "				ON	P.CD_COMPANY = T.CD_COMPANY					          		\n";
			query3 += "				AND P.CD_BIZAREA = T.CD_BIZAREA					          		\n";
			query3 += "				AND P.CD_EMP = T.CD_EMP							          		\n";
			query3 += "				AND P.YM = T.YM									          		\n";
			query3 += "				AND P.NO_SEQ = T.NO_SEQ							          		\n";
			query3 += "				AND P.TP_EMP = T.TP_EMP							          		\n";
			query3 += "				AND P.TP_PAY = T.TP_PAY							          		\n";
			query3 += "				INNER JOIN HR_BCLOSE C							          		\n";
			query3 += "				ON	P.CD_COMPANY	= C.CD_COMPANY 				          		\n";
			query3 += "				AND P.CD_BIZAREA = C.CD_BIZAREA 				          		\n";
			query3 += "				AND P.CD_EMP = C.CD_EMP 						          		\n";
			query3 += "				AND P.YM = C.YM 								          		\n";
			query3 += "				AND P.NO_SEQ = C.NO_SEQ							          		\n";
			query3 += "				AND P.TP_EMP = C.TP_EMP 						          		\n";
			query3 += "				AND P.TP_PAY = C.TP_PAY							          		\n";
			query3 += "				AND C.TP_CLOSE = '001'							          		\n";
			query3 += "				AND ISNULL(C.DT_CLOSE, '') <> ''				          		\n";
			query3 += "				WHERE	P.CD_COMPANY = @P_CD_COMPANY 			          		\n";
			query3 += "				AND		P.NO_EMP = @P_NO_EMP 					          		\n";
			query3 += "				AND		T.CD_BIZAREA = @P_CD_BIZAREA 			          		\n";
			query3 += "				AND		P.YM BETWEEN @P_YM_FROM AND @P_YM_TO	          		\n";
			query3 += "																          		\n";
			query3 += "				ORDER BY P.YM, T.DT_PAY, T.NO_SEQ, T.TP_PAY	              		\n";
			query3 += "			END	;																\n";
			
			
			query4 += "CREATE PROCEDURE [NEOE].[UP_HR_PAY_LIST_TPPAY_S_GW]		\n";
			query4 += "(															\n";
			query4 += "	@P_CD_COMPANY  	NVARCHAR(7)								\n";
			query4 += ")															\n";
			query4 += "AS														\n";
			query4 += "SET NOCOUNT ON											\n";
			query4 += "															\n";
			query4 += "SELECT	CD_SYSDEF CODE,									\n";
			query4 += "		NM_SYSDEF NAME										\n";
			query4 += "FROM 	MA_CODEDTL											\n";
			query4 += "WHERE 	CD_COMPANY = @P_CD_COMPANY 						\n";
			query4 += "AND		CD_FIELD = 'HR_P000014'							\n";
			query4 += "ORDER BY CD_SYSDEF;										\n";
			
			query5 += "CREATE PROC [NEOE].[UP_HR_PAYRPT_S_GW]																																																	\n";
			query5 += "(																																																											\n";
			query5 += "	@P_CD_COMPANY		NVARCHAR(7),																																																		\n";
			query5 += "	@P_YM				NVARCHAR(6),																																																		\n";
			query5 += "	@P_NO_EMP			NVARCHAR(10),																																																		\n";
			query5 += "	@P_DT_PAY			NVARCHAR(8),																																																		\n";
			query5 += "	@P_TP_REPORT		NVARCHAR(3),																																																		\n";
			query5 += "	@P_TP_PAY			NVARCHAR(3) = '',																																																	\n";
			query5 += "	@P_NO_SEQ			INT = 0																																																				\n";
			query5 += ")																																																											\n";
			query5 += "AS																																																										\n";
			query5 += "SET NOCOUNT ON																																																							\n";
			query5 += "DECLARE																																																									\n";
			query5 += "		@V_CNT				INT,																																																			\n";
			query5 += "																																																											\n";
			query5 += "		@V_CHK_CNT			INT,																																																			\n";
			query5 += "		@V_CD_RHEADER		NVARCHAR(3),																																																	\n";
			query5 += "																																																											\n";
			query5 += "		@V_INJUCK_CODE		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE1		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE2		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE3		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE4		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE5		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE6		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE7		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE8		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE9		NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE10	NVARCHAR(20),																																																	\n";
			query5 += "		@V_INJUCK_CODE11	NVARCHAR(20),																																																	\n";
			query5 += "																																																											\n";
			query5 += "		@V_INJUCK_NAME		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME1		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME2		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME3		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME4		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME5		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME6		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME7		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME8		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME9		NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME10	NVARCHAR(50),																																																	\n";
			query5 += "		@V_INJUCK_NAME11	NVARCHAR(50)																																																	\n";
			query5 += "																																																											\n";
			query5 += "SET @V_CNT = 0																																																							\n";
			query5 += "DECLARE @GTB_HR_PPSRPT TABLE																																																				\n";
			query5 += "(																																																											\n";
			query5 += "	고용형태		NVARCHAR(3),																																																			\n";
			query5 += "	사원구분		NVARCHAR(3),																																																			\n";
			query5 += "	급여구분		NVARCHAR(3),																																																			\n";
			query5 += "																																																											\n";
			query5 += "	AM_PAY01	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY02	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY03	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY04	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY05	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY06	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY07	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY08	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY09	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY10	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY11	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY12	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY13	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY14	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY15	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY16	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY17	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY18	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY19	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY20	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY21	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY22	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY23	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY24	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY25	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY26	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY27	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY28	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY29	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY30	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY31	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY32	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY33	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY34	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY35	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY36	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY37	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY38	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY39	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_PAY40	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT01	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT02	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT03	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT04	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT05	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT06	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT07	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT08	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT09	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT10	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT11	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT12	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT13	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT14	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT15	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT16	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT17	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT18	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT19	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT20	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT21	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT22	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT23	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT24	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT25	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT26	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT27	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT28	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT29	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT30	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT31	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT32	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT33	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT34	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT35	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT36	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT37	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT38	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT39	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_DEDUCT40	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_01		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_02		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_03		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_04		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_05		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_06		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_07		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_08		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_09		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_10		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_11		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_12		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_13		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_14		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_15		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_16		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_17		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_18		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_19		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_20		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_21		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_22		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_23		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_24		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_25		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_26		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_27		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_28		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_29		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_30		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_31		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_32		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_33		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_34		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_35		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_36		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_37		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_38		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_39		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PAY_40		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_01		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_02		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_03		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_04		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_05		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_06		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_07		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_08		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_09		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_10		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_11		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_12		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_13		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_14		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_15		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_16		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_17		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_18		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_19		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_20		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_21		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_22		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_23		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_24		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_25		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_26		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_27		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_28		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_29		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_30		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_31		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_32		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_33		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_34		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_35		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_36		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_37		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_38		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_39		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	DEDU_40		NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_TEMP		NUMERIC(17, 4)DEFAULT(0), 																																																	\n";
			query5 += "	AM_INCOMTAX	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	AM_RESIDTAX	NUMERIC(17,4)	DEFAULT(0), 																																																\n";
			query5 += "	PRIMARY KEY(고용형태, 사원구분, 급여구분)																																																\n";
			query5 += ")																																																											\n";
			query5 += "INSERT INTO @GTB_HR_PPSRPT																																																				\n";
			query5 += "(																																																											\n";
			query5 += "	고용형태, 사원구분, 급여구분,																																																			\n";
			query5 += "	AM_PAY01,AM_PAY02,AM_PAY03,AM_PAY04,AM_PAY05,AM_PAY06,AM_PAY07,AM_PAY08,AM_PAY09,AM_PAY10,																																				\n";
			query5 += "	AM_PAY11,AM_PAY12,AM_PAY13,AM_PAY14,AM_PAY15,AM_PAY16,AM_PAY17,AM_PAY18,AM_PAY19,AM_PAY20,																																				\n";
			query5 += "	AM_PAY21,AM_PAY22,AM_PAY23,AM_PAY24,AM_PAY25,AM_PAY26,AM_PAY27,AM_PAY28,AM_PAY29,AM_PAY30,																																				\n";
			query5 += "	AM_PAY31,AM_PAY32,AM_PAY33,AM_PAY34,AM_PAY35,AM_PAY36,AM_PAY37,AM_PAY38,AM_PAY39,AM_PAY40,																																				\n";
			query5 += "	AM_DEDUCT01,AM_DEDUCT02,AM_DEDUCT03,AM_DEDUCT04,AM_DEDUCT05,AM_DEDUCT06,AM_DEDUCT07,AM_DEDUCT08,AM_DEDUCT09,AM_DEDUCT10,																												\n";
			query5 += "	AM_DEDUCT11,AM_DEDUCT12,AM_DEDUCT13,AM_DEDUCT14,AM_DEDUCT15,AM_DEDUCT16,AM_DEDUCT17,AM_DEDUCT18,AM_DEDUCT19,AM_DEDUCT20,																												\n";
			query5 += "	AM_DEDUCT21,AM_DEDUCT22,AM_DEDUCT23,AM_DEDUCT24,AM_DEDUCT25,AM_DEDUCT26,AM_DEDUCT27,AM_DEDUCT28,AM_DEDUCT29,AM_DEDUCT30,																												\n";
			query5 += "	AM_DEDUCT31,AM_DEDUCT32,AM_DEDUCT33,AM_DEDUCT34,AM_DEDUCT35,AM_DEDUCT36,AM_DEDUCT37,AM_DEDUCT38,AM_DEDUCT39,AM_DEDUCT40,																												\n";
			query5 += "	AM_INCOMTAX, AM_RESIDTAX																																																				\n";
			query5 += ")																																																											\n";
			query5 += "SELECT	P.CD_EMP, P.TP_EMP, P.TP_PAY,																																																	\n";
			query5 += "		SUM(P.AM_PAY01) AM_PAY01, SUM(P.AM_PAY02) AM_PAY02, SUM(P.AM_PAY03) AM_PAY03, SUM(P.AM_PAY04) AM_PAY04, SUM(P.AM_PAY05) AM_PAY05,																									\n";
			query5 += "		SUM(P.AM_PAY06) AM_PAY06, SUM(P.AM_PAY07) AM_PAY07, SUM(P.AM_PAY08) AM_PAY08, SUM(P.AM_PAY09) AM_PAY09, SUM(P.AM_PAY10) AM_PAY10,																									\n";
			query5 += "		SUM(P.AM_PAY11) AM_PAY11, SUM(P.AM_PAY12) AM_PAY12, SUM(P.AM_PAY13) AM_PAY13, SUM(P.AM_PAY14) AM_PAY14, SUM(P.AM_PAY15) AM_PAY15,																									\n";
			query5 += "		SUM(P.AM_PAY16) AM_PAY16, SUM(P.AM_PAY17) AM_PAY17, SUM(P.AM_PAY18) AM_PAY18, SUM(P.AM_PAY19) AM_PAY19, SUM(P.AM_PAY20) AM_PAY20,																									\n";
			query5 += "		SUM(P.AM_PAY21) AM_PAY21, SUM(P.AM_PAY22) AM_PAY22, SUM(P.AM_PAY23) AM_PAY23, SUM(P.AM_PAY24) AM_PAY24, SUM(P.AM_PAY25) AM_PAY25,																									\n";
			query5 += "		SUM(P.AM_PAY26) AM_PAY26, SUM(P.AM_PAY27) AM_PAY27, SUM(P.AM_PAY28) AM_PAY28, SUM(P.AM_PAY29) AM_PAY29, SUM(P.AM_PAY30) AM_PAY30,																									\n";
			query5 += "		SUM(P.AM_PAY31) AM_PAY31, SUM(P.AM_PAY32) AM_PAY32, SUM(P.AM_PAY33) AM_PAY33, SUM(P.AM_PAY34) AM_PAY34, SUM(P.AM_PAY35) AM_PAY35,																									\n";
			query5 += "		SUM(P.AM_PAY36) AM_PAY36, SUM(P.AM_PAY37) AM_PAY37, SUM(P.AM_PAY38) AM_PAY38, SUM(P.AM_PAY39) AM_PAY39, SUM(P.AM_PAY40) AM_PAY40,																									\n";
			query5 += "		SUM(P.AM_DEDUCT01) AM_DEDUCT01, SUM(P.AM_DEDUCT02) AM_DEDUCT02, SUM(P.AM_DEDUCT03) AM_DEDUCT03, SUM(P.AM_DEDUCT04) AM_DEDUCT04, SUM(AM_DEDUCT05) AM_DEDUCT05,																		\n";
			query5 += "		SUM(P.AM_DEDUCT06) AM_DEDUCT06, SUM(P.AM_DEDUCT07) AM_DEDUCT07, SUM(P.AM_DEDUCT08) AM_DEDUCT08, SUM(P.AM_DEDUCT09) AM_DEDUCT09, SUM(AM_DEDUCT10) AM_DEDUCT10,																		\n";
			query5 += "		SUM(P.AM_DEDUCT11) AM_DEDUCT11, SUM(P.AM_DEDUCT12) AM_DEDUCT12, SUM(P.AM_DEDUCT13) AM_DEDUCT13, SUM(P.AM_DEDUCT14) AM_DEDUCT14, SUM(AM_DEDUCT15) AM_DEDUCT15,																		\n";
			query5 += "		SUM(P.AM_DEDUCT16) AM_DEDUCT16, SUM(P.AM_DEDUCT17) AM_DEDUCT17, SUM(P.AM_DEDUCT18) AM_DEDUCT18, SUM(P.AM_DEDUCT19) AM_DEDUCT19, SUM(AM_DEDUCT20) AM_DEDUCT20,																		\n";
			query5 += "		SUM(P.AM_DEDUCT21) AM_DEDUCT21, SUM(P.AM_DEDUCT22) AM_DEDUCT22, SUM(P.AM_DEDUCT23) AM_DEDUCT23, SUM(P.AM_DEDUCT24) AM_DEDUCT24, SUM(AM_DEDUCT25) AM_DEDUCT25,																		\n";
			query5 += "		SUM(P.AM_DEDUCT26) AM_DEDUCT26, SUM(P.AM_DEDUCT27) AM_DEDUCT27, SUM(P.AM_DEDUCT28) AM_DEDUCT28, SUM(P.AM_DEDUCT29) AM_DEDUCT29, SUM(AM_DEDUCT30) AM_DEDUCT30,																		\n";
			query5 += "		SUM(P.AM_DEDUCT31) AM_DEDUCT31, SUM(P.AM_DEDUCT32) AM_DEDUCT32, SUM(P.AM_DEDUCT33) AM_DEDUCT33, SUM(P.AM_DEDUCT34) AM_DEDUCT34, SUM(AM_DEDUCT35) AM_DEDUCT35,																		\n";
			query5 += "		SUM(P.AM_DEDUCT36) AM_DEDUCT36, SUM(P.AM_DEDUCT37) AM_DEDUCT37, SUM(P.AM_DEDUCT38) AM_DEDUCT38, SUM(P.AM_DEDUCT39) AM_DEDUCT39, SUM(AM_DEDUCT40) AM_DEDUCT40,																		\n";
			query5 += "		SUM(P.AM_INCOMTAX) AM_INCOMTAX, SUM(P.AM_RESIDTAX) AM_RESIDTAX																																										\n";
			query5 += "FROM	HR_PCALCPAY P																																																						\n";
			query5 += "INNER JOIN HR_BCLOSE C																																																					\n";
			query5 += "ON		P.CD_COMPANY	= C.CD_COMPANY AND P.CD_BIZAREA = C.CD_BIZAREA AND P.CD_EMP = C.CD_EMP AND P.TP_EMP = C.TP_EMP AND P.TP_PAY = C.TP_PAY AND P.YM = C.YM AND P.NO_SEQ = C.NO_SEQ													\n";
			query5 += "AND		C.TP_CLOSE		= '001' AND (C.DT_CLOSE IS NOT NULL AND C.DT_CLOSE <> '' AND DT_CLOSE <> '00000000')																															\n";
			query5 += "INNER JOIN HR_PTITLE T																																																					\n";
			query5 += "ON		P.CD_COMPANY	= T.CD_COMPANY AND P.CD_BIZAREA = T.CD_BIZAREA AND P.TP_EMP = T.TP_EMP AND P.CD_EMP = T.CD_EMP																													\n";
			query5 += "AND		P.TP_PAY			= T.TP_PAY AND P.YM = T.YM AND P.NO_SEQ = T.NO_SEQ AND (T.DT_PAY = @P_DT_PAY OR @P_DT_PAY IS NULL OR @P_DT_PAY = '')																						\n";
			query5 += "WHERE	P.CD_COMPANY	= @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP																																							\n";
			query5 += "																																																											\n";
			query5 += "--수정일자 : 2011.03.15				수정자 : 변영석																																														\n";
			query5 += "--수정내용 : 조회조건 (급여구분) 추가에 따른 수정																																															\n";
			query5 += "--AND		P.TP_PAY IN ('001', '002', '003')																																																\n";
			query5 += "--AND	(P.TP_PAY = @P_TP_PAY OR @P_TP_PAY = '')																																															\n";
			query5 += "AND P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																									\n";
			query5 += "AND P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																									\n";
			query5 += "																																																											\n";
			query5 += "GROUP BY P.CD_EMP, P.TP_EMP, P.TP_PAY																																																		\n";
			query5 += "																																																											\n";
			query5 += "SELECT	@V_CNT = COUNT(급여구분)																																																		\n";
			query5 += "FROM	@GTB_HR_PPSRPT																																																						\n";
			query5 += "																																																											\n";
			query5 += "IF @V_CNT > 0																																																								\n";
			query5 += "BEGIN																																																										\n";
			query5 += "	DECLARE 																																																								\n";
			query5 += "			@V_고용형태		NVARCHAR(3),																																																	\n";
			query5 += "			@V_사원구분		NVARCHAR(3),																																																	\n";
			query5 += "			@V_급여구분		NVARCHAR(3),																																																	\n";
			query5 += "			@V_공제구분		NVARCHAR(3),																																																	\n";
			query5 += "			@V_출력코드		NVARCHAR(3),																																																	\n";
			query5 += "			@V_지급공제코드	NVARCHAR(3),																																																	\n";
			query5 += "			@V_저장할필드명	NVARCHAR(10),																																																	\n";
			query5 += "			@V_금액필드명		NVARCHAR(10)																																																\n";
			query5 += "																																																											\n";
			query5 += "	DECLARE @V_CUR CURSOR 																																																					\n";
			query5 += "	SET @V_CUR = CURSOR FOR																																																					\n";
			query5 += "		SELECT 	CD.CD_EMP, CD.TP_EMP, CD.TP_PAY, FM.TP_PDREPORT, FM.CD_REPORT, CD.CD_CPAYDEDUCT																																				\n";
			query5 += "		FROM	HR_PREPFORM FM																																																				\n";
			query5 += "		LEFT OUTER JOIN 																																																					\n";
			query5 += "				(																																																							\n";
			query5 += "				SELECT	CD.CD_COMPANY, CD.CD_EMP, CD.TP_EMP, CD.TP_PAY, CD.TP_PAYDEDUCT, CD.CD_CPAYDEDUCT,CD.CD_PAYDEDUCT																													\n";
			query5 += "				FROM	HR_PCALCHEAD CD																																																		\n";
			query5 += "				INNER JOIN 																																																					\n";
			query5 += "						(																																																					\n";
			query5 += "						SELECT	CD_COMPANY, CD_EMP, TP_EMP, TP_PAY, MAX(YM) YM 																																								\n";
			query5 += "						FROM	HR_PCALCHEAD      																																															\n";
			query5 += "						WHERE	CD_COMPANY = @P_CD_COMPANY AND YM   <= @P_YM																																								\n";
			query5 += "						AND		TP_PAY IN (SELECT DISTINCT 급여구분 FROM @GTB_HR_PPSRPT)																																					\n";
			query5 += "						GROUP BY CD_COMPANY, CD_EMP, TP_EMP, TP_PAY																																											\n";
			query5 += "						) MAXH																																																				\n";
			query5 += "				ON  		CD.CD_COMPANY	= MAXH.CD_COMPANY AND CD.YM = MAXH.YM AND CD.CD_EMP = MAXH.CD_EMP																																\n";
			query5 += "				AND		CD.TP_EMP		= MAXH.TP_EMP AND CD.TP_PAY = MAXH.TP_PAY																																							\n";
			query5 += "				) CD																																																						\n";
			query5 += "		ON 		FM.CD_COMPANY  = CD.CD_COMPANY AND FM.TP_PDREPORT = CD.TP_PAYDEDUCT AND FM.CD_PAYDEDUCT  = CD.CD_PAYDEDUCT																													\n";
			query5 += "		WHERE	FM.CD_COMPANY  = @P_CD_COMPANY AND  FM.TP_REPORT  = @P_TP_REPORT  																																							\n";
			query5 += "		AND		FM.CD_PAYDEDUCT NOT IN ('STX', 'JTX', 'NTX') AND FM.TP_PDREPORT IN ('001', '002')																																			\n";
			query5 += "		ORDER BY CD.CD_EMP ASC, CD.TP_EMP ASC, CD.TP_PAY, FM.TP_PDREPORT ASC, CONVERT(INT, FM.CD_RSEQ) ASC, FM.CD_REPORT ASC, FM.CD_PAYDEDUCT ASC																							\n";
			query5 += "		 																																																									\n";
			query5 += "	OPEN @V_CUR																																																								\n";
			query5 += "	FETCH NEXT FROM @V_CUR																																																					\n";
			query5 += "	INTO @V_고용형태, @V_사원구분, @V_급여구분, @V_공제구분, @V_출력코드, @V_지급공제코드																																					\n";
			query5 += "																																																											\n";
			query5 += "	WHILE (@@FETCH_STATUS = 0)																																																				\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_저장할필드명 = ''																																																			\n";
			query5 += "		SET @V_금액필드명 = ''																																																				\n";
			query5 += "																																																											\n";
			query5 += "		UPDATE	@GTB_HR_PPSRPT																																																				\n";
			query5 += "		SET		AM_TEMP	= 0																																																					\n";
			query5 += "		WHERE	고용형태		= @V_고용형태																																																\n";
			query5 += "		AND		사원구분		= @V_사원구분																																																\n";
			query5 += "		AND		급여구분		= @V_급여구분																																																\n";
			query5 += "																																																											\n";
			query5 += "		-- 지급																																																								\n";
			query5 += "		IF(@V_공제구분 = '001')																																																				\n";
			query5 += "		BEGIN																																																								\n";
			query5 += "			UPDATE	@GTB_HR_PPSRPT																																																			\n";
			query5 += "			SET	AM_TEMP	= ISNULL(																																																			\n";
			query5 += "						CASE																																																				\n";
			query5 += "							WHEN 	@V_지급공제코드 = '001' THEN AM_PAY01	WHEN	@V_지급공제코드 = '002' THEN AM_PAY02																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '003' THEN AM_PAY03	WHEN	@V_지급공제코드 = '004' THEN AM_PAY04																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '005' THEN AM_PAY05	WHEN	@V_지급공제코드 = '006' THEN AM_PAY06																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '007' THEN AM_PAY07	WHEN	@V_지급공제코드 = '008' THEN AM_PAY08																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '009' THEN AM_PAY09	WHEN	@V_지급공제코드 = '010' THEN AM_PAY10																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '011' THEN AM_PAY11	WHEN	@V_지급공제코드 = '012' THEN AM_PAY12																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '013' THEN AM_PAY13	WHEN	@V_지급공제코드 = '014' THEN AM_PAY14																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '015' THEN AM_PAY15	WHEN	@V_지급공제코드 = '016' THEN AM_PAY16																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '017' THEN AM_PAY17	WHEN	@V_지급공제코드 = '018' THEN AM_PAY18																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '019' THEN AM_PAY19	WHEN	@V_지급공제코드 = '020' THEN AM_PAY20																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '021' THEN AM_PAY21	WHEN	@V_지급공제코드 = '022' THEN AM_PAY22																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '023' THEN AM_PAY23	WHEN	@V_지급공제코드 = '024' THEN AM_PAY24																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '025' THEN AM_PAY25	WHEN	@V_지급공제코드 = '026' THEN AM_PAY26																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '027' THEN AM_PAY27	WHEN	@V_지급공제코드 = '028' THEN AM_PAY28																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '029' THEN AM_PAY29	WHEN	@V_지급공제코드 = '030' THEN AM_PAY30																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '031' THEN AM_PAY31	WHEN	@V_지급공제코드 = '032' THEN AM_PAY32																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '033' THEN AM_PAY33	WHEN	@V_지급공제코드 = '034' THEN AM_PAY34																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '035' THEN AM_PAY35	WHEN	@V_지급공제코드 = '036' THEN AM_PAY36																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '037' THEN AM_PAY37	WHEN	@V_지급공제코드 = '038' THEN AM_PAY38																													\n";
			query5 += "							WHEN	@V_지급공제코드 = '039' THEN AM_PAY39	WHEN	@V_지급공제코드 = '040' THEN AM_PAY40																													\n";
			query5 += "						END, 0)																																																				\n";
			query5 += "			WHERE	고용형태		= @V_고용형태																																															\n";
			query5 += "			AND		사원구분		= @V_사원구분																																															\n";
			query5 += "			AND		급여구분		= @V_급여구분																																															\n";
			query5 += "																																																											\n";
			query5 += "			IF(@V_출력코드 = '001')																																																			\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_01 = ISNULL(PAY_01, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '002')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_02 = ISNULL(PAY_02, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '003')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_03 = ISNULL(PAY_03, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '004')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_04 = ISNULL(PAY_04, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '005')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_05 = ISNULL(PAY_05, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '006')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_06 = ISNULL(PAY_06, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '007')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_07 = ISNULL(PAY_07, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '008')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_08 = ISNULL(PAY_08, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '009')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_09 = ISNULL(PAY_09, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '010')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_10 = ISNULL(PAY_10, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '011')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_11 = ISNULL(PAY_11, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '012')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_12 = ISNULL(PAY_12, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '013')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_13 = ISNULL(PAY_13, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '014')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_14 = ISNULL(PAY_14, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '015')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_15 = ISNULL(PAY_15, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '016')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_16 = ISNULL(PAY_16, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '017')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_17 = ISNULL(PAY_17, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '018')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_18 = ISNULL(PAY_18, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '019')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_19 = ISNULL(PAY_19, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '020')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_20 = ISNULL(PAY_20, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '021')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_21 = ISNULL(PAY_21, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '022')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_22 = ISNULL(PAY_22, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '023')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_23 = ISNULL(PAY_23, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '024')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_24 = ISNULL(PAY_24, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '025')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_25 = ISNULL(PAY_25, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '026')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_26 = ISNULL(PAY_26, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '027')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_27 = ISNULL(PAY_27, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '028')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_28 = ISNULL(PAY_28, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '029')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_29 = ISNULL(PAY_29, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '030')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_30 = ISNULL(PAY_30, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '031')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_31 = ISNULL(PAY_31, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '032')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_32 = ISNULL(PAY_32, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '033')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_33 = ISNULL(PAY_33, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '034')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_34 = ISNULL(PAY_34, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '035')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_35 = ISNULL(PAY_35, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '036')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_36 = ISNULL(PAY_36, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '037')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_37 = ISNULL(PAY_37, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '038')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_38 = ISNULL(PAY_38, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '039')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_39 = ISNULL(PAY_39, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '040')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET PAY_40 = ISNULL(PAY_40, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "		END																																																									\n";
			query5 += "		-- 공제																																																								\n";
			query5 += "		ELSE IF(@V_공제구분 = '002')																																																		\n";
			query5 += "		BEGIN																																																								\n";
			query5 += "			UPDATE	@GTB_HR_PPSRPT																																																			\n";
			query5 += "			SET	AM_TEMP	= ISNULL(																																																			\n";
			query5 += "						CASE																																																				\n";
			query5 += "							WHEN 	@V_지급공제코드 = '001' THEN AM_DEDUCT01	WHEN	@V_지급공제코드 = '002' THEN AM_DEDUCT02																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '003' THEN AM_DEDUCT03	WHEN	@V_지급공제코드 = '004' THEN AM_DEDUCT04																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '005' THEN AM_DEDUCT05	WHEN	@V_지급공제코드 = '006' THEN AM_DEDUCT06																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '007' THEN AM_DEDUCT07	WHEN	@V_지급공제코드 = '008' THEN AM_DEDUCT08																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '009' THEN AM_DEDUCT09	WHEN	@V_지급공제코드 = '010' THEN AM_DEDUCT10																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '011' THEN AM_DEDUCT11	WHEN	@V_지급공제코드 = '012' THEN AM_DEDUCT12																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '013' THEN AM_DEDUCT13	WHEN	@V_지급공제코드 = '014' THEN AM_DEDUCT14																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '015' THEN AM_DEDUCT15	WHEN	@V_지급공제코드 = '016' THEN AM_DEDUCT16																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '017' THEN AM_DEDUCT17	WHEN	@V_지급공제코드 = '018' THEN AM_DEDUCT18																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '019' THEN AM_DEDUCT19	WHEN	@V_지급공제코드 = '020' THEN AM_DEDUCT20																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '021' THEN AM_DEDUCT21	WHEN	@V_지급공제코드 = '022' THEN AM_DEDUCT22																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '023' THEN AM_DEDUCT23	WHEN	@V_지급공제코드 = '024' THEN AM_DEDUCT24																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '025' THEN AM_DEDUCT25	WHEN	@V_지급공제코드 = '026' THEN AM_DEDUCT26																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '027' THEN AM_DEDUCT27	WHEN	@V_지급공제코드 = '028' THEN AM_DEDUCT28																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '029' THEN AM_DEDUCT29	WHEN	@V_지급공제코드 = '030' THEN AM_DEDUCT30																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '031' THEN AM_DEDUCT31	WHEN	@V_지급공제코드 = '032' THEN AM_DEDUCT32																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '033' THEN AM_DEDUCT33	WHEN	@V_지급공제코드 = '034' THEN AM_DEDUCT34																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '035' THEN AM_DEDUCT35	WHEN	@V_지급공제코드 = '036' THEN AM_DEDUCT36																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '037' THEN AM_DEDUCT37	WHEN	@V_지급공제코드 = '038' THEN AM_DEDUCT38																											\n";
			query5 += "							WHEN	@V_지급공제코드 = '039' THEN AM_DEDUCT39	WHEN	@V_지급공제코드 = '040' THEN AM_DEDUCT40																											\n";
			query5 += "						END, 0)																																																				\n";
			query5 += "			WHERE	고용형태		= @V_고용형태																																															\n";
			query5 += "			AND		사원구분		= @V_사원구분																																															\n";
			query5 += "			AND		급여구분		= @V_급여구분																																															\n";
			query5 += "																																																											\n";
			query5 += "			IF(@V_출력코드 = '001')																																																			\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '002')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '003')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '004')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '005')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '006')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '007')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '008')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '009')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '010')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '011')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '012')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '013')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '014')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '015')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '016')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '017')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '018')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '019')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '020')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '021')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '022')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '023')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '024')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '025')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '026')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '027')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '028')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '029')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '030')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '031')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '032')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '033')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '034')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '035')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '036')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '037')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '038')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '039')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "			ELSE IF(@V_출력코드 = '040')																																																	\n";
			query5 += "				UPDATE	@GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_TEMP, 0) WHERE 고용형태 = @V_고용형태 AND 사원구분 = @V_사원구분 AND 급여구분 = @V_급여구분																\n";
			query5 += "		END																																																									\n";
			query5 += "																																																											\n";
			query5 += "		FETCH NEXT FROM @V_CUR																																																				\n";
			query5 += "		INTO @V_고용형태, @V_사원구분, @V_급여구분, @V_공제구분, @V_출력코드, @V_지급공제코드																																				\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	CLOSE @V_CUR																																																							\n";
			query5 += "	DEALLOCATE @V_CUR																																																						\n";
			query5 += "																																																											\n";
			query5 += "	-- 소득세																																																								\n";
			query5 += "	DECLARE @V_CD_REPORT	NVARCHAR(3)																																																		\n";
			query5 += "																																																											\n";
			query5 += "	SELECT	@V_CD_REPORT = CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'STX'																																																			\n";
			query5 += "																																																											\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_INCOMTAX, 0)																																					\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	--급여 소득세 계산																																																						\n";
			query5 += "	SET @V_CD_REPORT = NULL	--초기화																																																		\n";
			query5 += "																																																											\n";
			query5 += "	SELECT	@V_CD_REPORT	= CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'STX1'																																																		\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	--상여 소득세 계산																																																						\n";
			query5 += "	SET @V_CD_REPORT = NULL	--초기화																																																		\n";
			query5 += "																																																											\n";
			query5 += "	SELECT	@V_CD_REPORT	= CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'STX2'																																																		\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "																																																											\n";
			query5 += "	--연월차 소득세 계산																																																					\n";
			query5 += "	SET @V_CD_REPORT = NULL	--초기화																																																		\n";
			query5 += "																																																											\n";
			query5 += "	SELECT	@V_CD_REPORT	= CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'STX3'																																																		\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_INCOMTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	-- 주민세																																																								\n";
			query5 += "	SELECT	@V_CD_REPORT	= CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'JTX'																																																			\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_RESIDTAX, 0)																																					\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	--급여 주민세 계산																																																						\n";
			query5 += "	SET @V_CD_REPORT = NULL																																																					\n";
			query5 += "																																																											\n";
			query5 += "	SELECT	@V_CD_REPORT	= CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'JTX1'																																																		\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '001'																															\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	--상여 주민세 계산																																																						\n";
			query5 += "	SET @V_CD_REPORT = NULL																																																					\n";
			query5 += "																																																											\n";
			query5 += "	SELECT	@V_CD_REPORT	= CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'JTX2'																																																		\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '002'																															\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "																																																											\n";
			query5 += "	--연월차 주민세 계산																																																					\n";
			query5 += "	SET @V_CD_REPORT = NULL																																																					\n";
			query5 += "																																																											\n";
			query5 += "	SELECT	@V_CD_REPORT	= CD_REPORT																																																		\n";
			query5 += "	FROM	HR_PREPFORM 																																																					\n";
			query5 += "	WHERE	CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		TP_PDREPORT		= '002'																																																			\n";
			query5 += "	AND		CD_PAYDEDUCT	= 'JTX3'																																																		\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_REPORT IS NOT NULL)																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		IF(@V_CD_REPORT = '001')																																																			\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_01 = ISNULL(DEDU_01, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '002')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_02 = ISNULL(DEDU_02, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '003')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_03 = ISNULL(DEDU_03, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '004')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_04 = ISNULL(DEDU_04, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '005')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_05 = ISNULL(DEDU_05, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '006')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_06 = ISNULL(DEDU_06, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '007')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_07 = ISNULL(DEDU_07, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '008')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_08 = ISNULL(DEDU_08, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '009')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_09 = ISNULL(DEDU_09, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '010')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_10 = ISNULL(DEDU_10, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '011')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_11 = ISNULL(DEDU_11, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '012')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_12 = ISNULL(DEDU_12, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '013')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_13 = ISNULL(DEDU_13, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '014')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_14 = ISNULL(DEDU_14, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '015')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_15 = ISNULL(DEDU_15, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '016')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_16 = ISNULL(DEDU_16, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '017')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_17 = ISNULL(DEDU_17, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '018')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_18 = ISNULL(DEDU_18, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '019')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_19 = ISNULL(DEDU_19, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '020')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_20 = ISNULL(DEDU_20, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '021')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_21 = ISNULL(DEDU_21, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '022')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_22 = ISNULL(DEDU_22, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '023')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_23 = ISNULL(DEDU_23, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '024')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_24 = ISNULL(DEDU_24, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '025')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_25 = ISNULL(DEDU_25, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '026')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_26 = ISNULL(DEDU_26, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '027')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_27 = ISNULL(DEDU_27, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '028')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_28 = ISNULL(DEDU_28, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '029')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_29 = ISNULL(DEDU_29, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '030')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_30 = ISNULL(DEDU_30, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '031')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_31 = ISNULL(DEDU_31, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '032')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_32 = ISNULL(DEDU_32, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '033')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_33 = ISNULL(DEDU_33, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '034')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_34 = ISNULL(DEDU_34, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '035')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_35 = ISNULL(DEDU_35, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '036')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_36 = ISNULL(DEDU_36, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '037')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_37 = ISNULL(DEDU_37, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '038')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_38 = ISNULL(DEDU_38, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '039')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_39 = ISNULL(DEDU_39, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "		ELSE IF(@V_CD_REPORT = '040')																																																		\n";
			query5 += "			UPDATE @GTB_HR_PPSRPT SET DEDU_40 = ISNULL(DEDU_40, 0) + ISNULL(AM_RESIDTAX, 0) WHERE 급여구분 = '003'																															\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "END																																																										\n";
			query5 += "																																																											\n";
			query5 += "--  인적정보 조회																																																							\n";
			query5 += "SET	@V_CNT	= 1																																																							\n";
			query5 += "SET	@V_CHK_CNT = 0																																																						\n";
			query5 += "SET	@V_CD_RHEADER = '000'																																																				\n";
			query5 += "																																																											\n";
			query5 += "SELECT	@V_CHK_CNT = COUNT(CD_RHEADER) FROM	HR_PREPHEADER																																												\n";
			query5 += "WHERE	CD_COMPANY	= @P_CD_COMPANY AND TP_REPORT = @P_TP_REPORT AND TP_REPFORM = '002' AND	YN_CHECK = 'Y'																																	\n";
			query5 += "																																																											\n";
			query5 += "WHILE (@V_CNT <= @V_CHK_CNT)																																																				\n";
			query5 += "BEGIN																																																										\n";
			query5 += "	SELECT	@V_CD_RHEADER =  ISNULL(MIN(F.CD_RHEADER), '')																																													\n";
			query5 += "	FROM	HR_PREPHEADER F																																																					\n";
			query5 += "	WHERE	F.CD_COMPANY	= @P_CD_COMPANY																																																	\n";
			query5 += "	AND		F.TP_REPORT		= @P_TP_REPORT																																																	\n";
			query5 += "	AND		F.TP_REPFORM	= '002'																																																			\n";
			query5 += "	AND		F.YN_CHECK		= 'Y'																																																			\n";
			query5 += "	AND		F.CD_RHEADER	> @V_CD_RHEADER																																																	\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CD_RHEADER IS NULL OR @V_CD_RHEADER = '') 																																														\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_CNT = @V_CNT + 1																																																				\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	SET @V_INJUCK_CODE = ''																																																					\n";
			query5 += "	SET @V_INJUCK_NAME = ''																																																					\n";
			query5 += "																																																											\n";
			query5 += "	-- 직위																																																									\n";
			query5 += "	IF @V_CD_RHEADER = '001'																																																				\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = P.CD_DUTY_RANK, 																																															\n";
			query5 += "				@V_INJUCK_NAME = (SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY = @P_CD_COMPANY AND CD_FIELD = 'HR_H000002' AND CD_SYSDEF = P.CD_DUTY_RANK)																				\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 직책																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '002'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = P.CD_DUTY_RESP, 																																															\n";
			query5 += "				@V_INJUCK_NAME = (SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY = @P_CD_COMPANY AND CD_FIELD = 'HR_H000052' AND CD_SYSDEF = P.CD_DUTY_RESP)																				\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 직급호봉																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '003'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = '', 																																																		\n";
			query5 += "				@V_INJUCK_NAME = ISNULL((SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY = @P_CD_COMPANY AND CD_FIELD = 'HR_H000003' AND CD_SYSDEF = P.CD_DUTY_STEP), '') + ISNULL(P.CD_PAY_STEP, '')										\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 입사일자																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '004'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = DT_ENTER																																																	\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 상여율																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '005'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = CONVERT(NVARCHAR, ISNULL(RT_BONUS, 0))																																										\n";
			query5 += "		FROM	HR_PBONUS																																																					\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP AND NO_SEQ = 1																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 사원구분																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '006'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = P.TP_EMP,																																																	\n";
			query5 += "				@V_INJUCK_NAME = (SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY = @P_CD_COMPANY AND CD_FIELD = 'HR_P000009' AND CD_SYSDEF = P.TP_EMP)																					\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 월급																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '007'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = CONVERT(NVARCHAR, AM_MPAY)																																													\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 일급																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '008'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = CONVERT(NVARCHAR, AM_DPAY)																																													\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 시급																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '009'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = CONVERT(NVARCHAR, AM_TPAY)																																													\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 연봉																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '010'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = CONVERT(NVARCHAR, AM_YPAY)																																													\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 퇴사일자																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '011'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = CASE WHEN DT_RETIRE IS NULL OR DT_RETIRE = '00000000' THEN '' ELSE DT_RETIRE END																															\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 주민번호																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '012'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = NO_RES																																																		\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 직종																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '013'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = P.CD_JOB_SERIES, 																																															\n";
			query5 += "				@V_INJUCK_NAME = (SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY	= @P_CD_COMPANY AND CD_FIELD = 'HR_H000053' AND CD_SYSDEF = P.CD_JOB_SERIES)																			\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 직무																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '014'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = P.CD_DUTY_WORK, 																																															\n";
			query5 += "				@V_INJUCK_NAME = (SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY	= @P_CD_COMPANY AND CD_FIELD = 'HR_H000039' AND CD_SYSDEF = P.CD_DUTY_WORK)																				\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "																																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 통상임금																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '015'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = SUM(ISNULL(P.AM_ORDINARY, 0))																																												\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 근무조																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '016'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = (SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY = @P_CD_COMPANY AND CD_FIELD = 'HR_G000001' AND CD_SYSDEF = CD_PART)																					\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 직군																																																								    \n";
			query5 += "	ELSE IF @V_CD_RHEADER = '017'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = P.CD_DUTY_TYPE, 																																															\n";
			query5 += "				@V_INJUCK_NAME = (SELECT NM_SYSDEF FROM MA_CODEDTL WHERE CD_COMPANY	= @P_CD_COMPANY AND CD_FIELD = 'HR_H000004' AND CD_SYSDEF = P.CD_DUTY_TYPE)																				\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "	END																																																										\n";
			query5 += "	-- CC																																																									\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '018'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	TOP 1 																																																						\n";
			query5 += "				@V_INJUCK_CODE = P.CD_CC, 																																																	\n";
			query5 += "				@V_INJUCK_NAME = (SELECT NM_CC FROM MA_CC WHERE CD_COMPANY = @P_CD_COMPANY AND CD_CC = P.CD_CC)																																\n";
			query5 += "		FROM	HR_PCALCPAY P																																																				\n";
			query5 += "		WHERE	P.CD_COMPANY = @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP 																																						\n";
			query5 += "		AND		P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																						\n";
			query5 += "		AND		P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																							\n";
			query5 += "		ORDER BY P.TP_PAY ASC, P.NO_SEQ ASC																																																	\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 퇴사일자																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '019'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_NAME = CASE WHEN DT_RETIRE IS NULL OR DT_RETIRE = '00000000' THEN '' ELSE DT_RETIRE END																															\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "	-- 프로젝트																																																								\n";
			query5 += "	ELSE IF @V_CD_RHEADER = '020'																																																			\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SELECT	@V_INJUCK_CODE = CD_PJT,																																																	\n";
			query5 += "				@V_INJUCK_NAME = ( SELECT NM_PROJECT FROM SA_PROJECTH WHERE CD_COMPANY = @P_CD_COMPANY AND NO_PROJECT = CD_PJT )																											\n";
			query5 += "		FROM	MA_EMP																																																						\n";
			query5 += "		WHERE	CD_COMPANY = @P_CD_COMPANY AND NO_EMP = @P_NO_EMP																																											\n";
			query5 += "	END																																																										\n";
			query5 += "																																																											\n";
			query5 += "	IF(@V_CNT = 1)																																																							\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE1 = @V_INJUCK_CODE  SET @V_INJUCK_NAME1 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 2)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE2 = @V_INJUCK_CODE  SET @V_INJUCK_NAME2 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 3)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE3 = @V_INJUCK_CODE  SET @V_INJUCK_NAME3 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 4)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE4 = @V_INJUCK_CODE  SET @V_INJUCK_NAME4 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 5)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE5 = @V_INJUCK_CODE  SET @V_INJUCK_NAME5 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 6)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE6 = @V_INJUCK_CODE  SET @V_INJUCK_NAME6 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 7)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE7 = @V_INJUCK_CODE  SET @V_INJUCK_NAME7 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 8)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE8 = @V_INJUCK_CODE  SET @V_INJUCK_NAME8 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 9)																																																						\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE9 = @V_INJUCK_CODE  SET @V_INJUCK_NAME9 = @V_INJUCK_NAME																																							\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 10)																																																					\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE10 = @V_INJUCK_CODE  SET @V_INJUCK_NAME10 = @V_INJUCK_NAME																																						\n";
			query5 += "	END																																																										\n";
			query5 += "	ELSE IF(@V_CNT = 11)																																																					\n";
			query5 += "	BEGIN																																																									\n";
			query5 += "		SET @V_INJUCK_CODE11 = @V_INJUCK_CODE  SET @V_INJUCK_NAME11 = @V_INJUCK_NAME																																						\n";
			query5 += "	END																																																										\n";
			query5 += "				  																																																							\n";
			query5 += "	SET @V_CNT = @V_CNT + 1																																																					\n";
			query5 += "																																																											\n";
			query5 += "END																																																										\n";
			query5 += "																																																											\n";
			query5 += "-- 0 : 급여양식																																																							\n";
			query5 += "SELECT	DISTINCT																																																						\n";
			query5 += "		FM.TP_PDREPORT,																																																						\n";
			query5 += "		FM.CD_REPORT,																																																						\n";
			query5 += "		FM.NM_REPORT,																																																						\n";
			query5 += "		CONVERT(INT, FM.CD_RSEQ) CD_RSEQ,																																																	\n";
			query5 += "		0 AM_PAY																																																							\n";
			query5 += "FROM	HR_PREPFORM FM																																																						\n";
			query5 += "WHERE	FM.CD_COMPANY		= @P_CD_COMPANY																																																	\n";
			query5 += "AND		FM.TP_REPORT		= @P_TP_REPORT																																																\n";
			query5 += "ORDER BY FM.TP_PDREPORT ASC, CONVERT(INT, FM.CD_RSEQ) ASC, FM.CD_REPORT ASC																																								\n";
			query5 += "																																																											\n";
			query5 += "-- 1 : 타이틀과 사원정보																																																					\n";
			query5 += "SELECT	TOP 1																																																							\n";
			query5 += "		P.NO_EMP, E.NM_KOR, P.CD_BIZAREA, (SELECT NM_BIZAREA FROM MA_BIZAREA WHERE CD_COMPANY = @P_CD_COMPANY AND CD_BIZAREA = P.CD_BIZAREA) NM_BIZAREA,																					\n";
			query5 += "		P.CD_DEPT, (SELECT NM_DEPT FROM MA_DEPT WHERE CD_COMPANY = @P_CD_COMPANY AND CD_DEPT = P.CD_DEPT) NM_DEPT,																															\n";
			query5 += "		P.CD_DUTY_STEP, P.CD_PAY_STEP,  E.NO_EMAIL,																																															\n";
			query5 += "		E.NO_RES NO_RES, T.DC_RMK1, T.DC_RMK2, T.TP_PAY, P.DC_RMK3,																																											\n";
			query5 += "		@V_INJUCK_CODE1 INJUCK_CODE1, @V_INJUCK_CODE2 INJUCK_CODE2, @V_INJUCK_CODE3 INJUCK_CODE3, @V_INJUCK_CODE4 INJUCK_CODE4, @V_INJUCK_CODE5 INJUCK_CODE5, 																				\n";
			query5 += "		@V_INJUCK_CODE6 INJUCK_CODE6, @V_INJUCK_CODE7 INJUCK_CODE7, @V_INJUCK_CODE8 INJUCK_CODE8, @V_INJUCK_CODE9 INJUCK_CODE9, @V_INJUCK_CODE10 INJUCK_CODE10, @V_INJUCK_CODE11 INJUCK_CODE11,												\n";
			query5 += "		@V_INJUCK_NAME1 INJUCK_NAME1, @V_INJUCK_NAME2 INJUCK_NAME2, @V_INJUCK_NAME3 INJUCK_NAME3, @V_INJUCK_NAME4 INJUCK_NAME4, @V_INJUCK_NAME5 INJUCK_NAME5, 																				\n";
			query5 += "		@V_INJUCK_NAME6 INJUCK_NAME6, @V_INJUCK_NAME7 INJUCK_NAME7, @V_INJUCK_NAME8 INJUCK_NAME8, @V_INJUCK_NAME9 INJUCK_NAME9, @V_INJUCK_NAME10 INJUCK_NAME10, @V_INJUCK_NAME11 INJUCK_NAME11												\n";
			query5 += "FROM	HR_PCALCPAY P																																																						\n";
			query5 += "INNER JOIN MA_EMP E																																																						\n";
			query5 += "ON		P.CD_COMPANY	= E.CD_COMPANY AND P.NO_EMP = E.NO_EMP																																											\n";
			query5 += "INNER JOIN HR_PTITLE T																																																					\n";
			query5 += "ON		P.CD_COMPANY	= T.CD_COMPANY AND P.CD_BIZAREA = T.CD_BIZAREA AND P.CD_EMP = T.CD_EMP AND P.TP_EMP = T.TP_EMP																													\n";
			query5 += "AND		P.TP_PAY			= T.TP_PAY AND P.YM = T.YM AND P.NO_SEQ = T.NO_SEQ AND (T.DT_PAY = @P_DT_PAY OR @P_DT_PAY IS NULL OR @P_DT_PAY = '')																						\n";
			query5 += "INNER JOIN HR_BCLOSE C																																																					\n";
			query5 += "ON		T.CD_COMPANY	= C.CD_COMPANY AND T.YM = C.YM AND T.CD_BIZAREA = C.CD_BIZAREA AND T.CD_EMP = C.CD_EMP AND T.TP_EMP = C.TP_EMP AND T.TP_PAY = C.TP_PAY AND P.YM = C.YM AND T.NO_SEQ = C.NO_SEQ									\n";
			query5 += "AND		C.TP_CLOSE		= '001' AND (C.DT_CLOSE IS NOT NULL AND C.DT_CLOSE <> '' AND DT_CLOSE <> '00000000')																															\n";
			query5 += "WHERE	P.CD_COMPANY	= @P_CD_COMPANY AND P.YM = @P_YM AND P.NO_EMP = @P_NO_EMP																																							\n";
			query5 += "AND P.TP_PAY = CASE WHEN @P_TP_PAY = '' THEN P.TP_PAY ELSE @P_TP_PAY END																																									\n";
			query5 += "AND P.NO_SEQ = CASE WHEN @P_NO_SEQ > 0 THEN @P_NO_SEQ ELSE P.NO_SEQ END																																									\n";
			query5 += "																																																											\n";
			query5 += "ORDER BY P.TP_PAY																																																							\n";
			query5 += "																																																											\n";
			query5 += "-- 2 : 급여																																																								\n";
			query5 += "SELECT	T.PAY_01, T.PAY_02, T.PAY_03, T.PAY_04, T.PAY_05, T.PAY_06, T.PAY_07, T.PAY_08, T.PAY_09, T.PAY_10,																																\n";
			query5 += "		T.PAY_11, T.PAY_12, T.PAY_13, T.PAY_14, T.PAY_15, T.PAY_16, T.PAY_17, T.PAY_18, T.PAY_19, T.PAY_20,																																	\n";
			query5 += "		T.PAY_21, T.PAY_22, T.PAY_23, T.PAY_24, T.PAY_25, T.PAY_26, T.PAY_27, T.PAY_28, T.PAY_29, T.PAY_30,																																	\n";
			query5 += "		T.PAY_31, T.PAY_32, T.PAY_33, T.PAY_34, T.PAY_35, T.PAY_36, T.PAY_37, T.PAY_38, T.PAY_39, T.PAY_40,																																	\n";
			query5 += "		(T.PAY_01+ T.PAY_02+ T.PAY_03+ T.PAY_04+ T.PAY_05+ T.PAY_06+ T.PAY_07+ T.PAY_08+ T.PAY_09+ T.PAY_10+																																\n";
			query5 += "		T.PAY_11+ T.PAY_12+ T.PAY_13+ T.PAY_14+ T.PAY_15+ T.PAY_16+ T.PAY_17+ T.PAY_18+ T.PAY_19+ T.PAY_20+																																	\n";
			query5 += "		T.PAY_21+ T.PAY_22+ T.PAY_23+ T.PAY_24+ T.PAY_25+ T.PAY_26+ T.PAY_27+ T.PAY_28+ T.PAY_29+ T.PAY_30+																																	\n";
			query5 += "		T.PAY_31+ T.PAY_32+ T.PAY_33+ T.PAY_34+ T.PAY_35+ T.PAY_36+ T.PAY_37+ T.PAY_38+ T.PAY_39+ T.PAY_40) TOTPAY,																															\n";
			query5 += "		T.DEDU_01, T.DEDU_02, T.DEDU_03, T.DEDU_04, T.DEDU_05, T.DEDU_06, T.DEDU_07, T.DEDU_08, T.DEDU_09, T.DEDU_10,																														\n";
			query5 += "		T.DEDU_11, T.DEDU_12, T.DEDU_13, T.DEDU_14, T.DEDU_15, T.DEDU_16, T.DEDU_17, T.DEDU_18, T.DEDU_19, T.DEDU_20,																														\n";
			query5 += "		T.DEDU_21, T.DEDU_22, T.DEDU_23, T.DEDU_24, T.DEDU_25, T.DEDU_26, T.DEDU_27, T.DEDU_28, T.DEDU_29, T.DEDU_30,																														\n";
			query5 += "		T.DEDU_31, T.DEDU_32, T.DEDU_33, T.DEDU_34, T.DEDU_35, T.DEDU_36, T.DEDU_37, T.DEDU_38, T.DEDU_39, T.DEDU_40,																														\n";
			query5 += "		(																																																									\n";
			query5 += "		T.DEDU_01+ T.DEDU_02+ T.DEDU_03+ T.DEDU_04+ T.DEDU_05+ T.DEDU_06+ T.DEDU_07+ T.DEDU_08+ T.DEDU_09+ T.DEDU_10+																														\n";
			query5 += "		T.DEDU_11+ T.DEDU_12+ T.DEDU_13+ T.DEDU_14+ T.DEDU_15+ T.DEDU_16+ T.DEDU_17+ T.DEDU_18+ T.DEDU_19+ T.DEDU_20+																														\n";
			query5 += "		T.DEDU_21+ T.DEDU_22+ T.DEDU_23+ T.DEDU_24+ T.DEDU_25+ T.DEDU_26+ T.DEDU_27+ T.DEDU_28+ T.DEDU_29+ T.DEDU_30+																														\n";
			query5 += "		T.DEDU_31+ T.DEDU_32+ T.DEDU_33+ T.DEDU_34+ T.DEDU_35+ T.DEDU_36+ T.DEDU_37+ T.DEDU_38+ T.DEDU_39+ T.DEDU_40																														\n";
			query5 += "		) TOTDEDUCT,																																																						\n";
			query5 += "		(T.PAY_01+ T.PAY_02+ T.PAY_03+ T.PAY_04+ T.PAY_05+ T.PAY_06+ T.PAY_07+ T.PAY_08+ T.PAY_09+ T.PAY_10+																																\n";
			query5 += "		T.PAY_11+ T.PAY_12+ T.PAY_13+ T.PAY_14+ T.PAY_15+ T.PAY_16+ T.PAY_17+ T.PAY_18+ T.PAY_19+ T.PAY_20+																																	\n";
			query5 += "		T.PAY_21+ T.PAY_22+ T.PAY_23+ T.PAY_24+ T.PAY_25+ T.PAY_26+ T.PAY_27+ T.PAY_28+ T.PAY_29+ T.PAY_30+																																	\n";
			query5 += "		T.PAY_31+ T.PAY_32+ T.PAY_33+ T.PAY_34+ T.PAY_35+ T.PAY_36+ T.PAY_37+ T.PAY_38+ T.PAY_39+ T.PAY_40) -																																\n";
			query5 += "		(																																																									\n";
			query5 += "		T.DEDU_01+ T.DEDU_02+ T.DEDU_03+ T.DEDU_04+ T.DEDU_05+ T.DEDU_06+ T.DEDU_07+ T.DEDU_08+ T.DEDU_09+ T.DEDU_10+																														\n";
			query5 += "		T.DEDU_11+ T.DEDU_12+ T.DEDU_13+ T.DEDU_14+ T.DEDU_15+ T.DEDU_16+ T.DEDU_17+ T.DEDU_18+ T.DEDU_19+ T.DEDU_20+																														\n";
			query5 += "		T.DEDU_21+ T.DEDU_22+ T.DEDU_23+ T.DEDU_24+ T.DEDU_25+ T.DEDU_26+ T.DEDU_27+ T.DEDU_28+ T.DEDU_29+ T.DEDU_30+																														\n";
			query5 += "		T.DEDU_31+ T.DEDU_32+ T.DEDU_33+ T.DEDU_34+ T.DEDU_35+ T.DEDU_36+ T.DEDU_37+ T.DEDU_38+ T.DEDU_39+ T.DEDU_40																														\n";
			query5 += "		) GPAY																																																								\n";
			query5 += "FROM	(																																																									\n";
			query5 += "		SELECT	SUM(ISNULL(PAY_01, 0)) PAY_01, SUM(ISNULL(PAY_02, 0)) PAY_02, SUM(ISNULL(PAY_03, 0)) PAY_03, SUM(ISNULL(PAY_04, 0)) PAY_04, SUM(ISNULL(PAY_05, 0)) PAY_05,																	\n";
			query5 += "				SUM(ISNULL(PAY_06, 0)) PAY_06, SUM(ISNULL(PAY_07, 0)) PAY_07, SUM(ISNULL(PAY_08, 0)) PAY_08, SUM(ISNULL(PAY_09, 0)) PAY_09, SUM(ISNULL(PAY_10, 0)) PAY_10,																	\n";
			query5 += "				SUM(ISNULL(PAY_11, 0)) PAY_11, SUM(ISNULL(PAY_12, 0)) PAY_12, SUM(ISNULL(PAY_13, 0)) PAY_13, SUM(ISNULL(PAY_14, 0)) PAY_14, SUM(ISNULL(PAY_15, 0)) PAY_15,																	\n";
			query5 += "				SUM(ISNULL(PAY_16, 0)) PAY_16, SUM(ISNULL(PAY_17, 0)) PAY_17, SUM(ISNULL(PAY_18, 0)) PAY_18, SUM(ISNULL(PAY_19, 0)) PAY_19, SUM(ISNULL(PAY_20, 0)) PAY_20,																	\n";
			query5 += "				SUM(ISNULL(PAY_21, 0)) PAY_21, SUM(ISNULL(PAY_22, 0)) PAY_22, SUM(ISNULL(PAY_23, 0)) PAY_23, SUM(ISNULL(PAY_24, 0)) PAY_24, SUM(ISNULL(PAY_25, 0)) PAY_25,																	\n";
			query5 += "				SUM(ISNULL(PAY_26, 0)) PAY_26, SUM(ISNULL(PAY_27, 0)) PAY_27, SUM(ISNULL(PAY_28, 0)) PAY_28, SUM(ISNULL(PAY_29, 0)) PAY_29, SUM(ISNULL(PAY_30, 0)) PAY_30,																	\n";
			query5 += "				SUM(ISNULL(PAY_31, 0)) PAY_31, SUM(ISNULL(PAY_32, 0)) PAY_32, SUM(ISNULL(PAY_33, 0)) PAY_33, SUM(ISNULL(PAY_34, 0)) PAY_34, SUM(ISNULL(PAY_35, 0)) PAY_35,																	\n";
			query5 += "				SUM(ISNULL(PAY_36, 0)) PAY_36, SUM(ISNULL(PAY_37, 0)) PAY_37, SUM(ISNULL(PAY_38, 0)) PAY_38, SUM(ISNULL(PAY_39, 0)) PAY_39, SUM(ISNULL(PAY_40, 0)) PAY_40,																	\n";
			query5 += "				SUM(ISNULL(DEDU_01, 0)) DEDU_01, SUM(ISNULL(DEDU_02, 0)) DEDU_02, SUM(ISNULL(DEDU_03, 0)) DEDU_03, SUM(ISNULL(DEDU_04, 0)) DEDU_04, SUM(ISNULL(DEDU_05, 0)) DEDU_05,														\n";
			query5 += "				SUM(ISNULL(DEDU_06, 0)) DEDU_06, SUM(ISNULL(DEDU_07, 0)) DEDU_07, SUM(ISNULL(DEDU_08, 0)) DEDU_08, SUM(ISNULL(DEDU_09, 0)) DEDU_09, SUM(ISNULL(DEDU_10, 0)) DEDU_10,														\n";
			query5 += "				SUM(ISNULL(DEDU_11, 0)) DEDU_11, SUM(ISNULL(DEDU_12, 0)) DEDU_12, SUM(ISNULL(DEDU_13, 0)) DEDU_13, SUM(ISNULL(DEDU_14, 0)) DEDU_14, SUM(ISNULL(DEDU_15, 0)) DEDU_15,														\n";
			query5 += "				SUM(ISNULL(DEDU_16, 0)) DEDU_16, SUM(ISNULL(DEDU_17, 0)) DEDU_17, SUM(ISNULL(DEDU_18, 0)) DEDU_18, SUM(ISNULL(DEDU_19, 0)) DEDU_19, SUM(ISNULL(DEDU_20, 0)) DEDU_20,														\n";
			query5 += "				SUM(ISNULL(DEDU_21, 0)) DEDU_21, SUM(ISNULL(DEDU_22, 0)) DEDU_22, SUM(ISNULL(DEDU_23, 0)) DEDU_23, SUM(ISNULL(DEDU_24, 0)) DEDU_24, SUM(ISNULL(DEDU_25, 0)) DEDU_25,														\n";
			query5 += "				SUM(ISNULL(DEDU_26, 0)) DEDU_26, SUM(ISNULL(DEDU_27, 0)) DEDU_27, SUM(ISNULL(DEDU_28, 0)) DEDU_28, SUM(ISNULL(DEDU_29, 0)) DEDU_29, SUM(ISNULL(DEDU_30, 0)) DEDU_30,														\n";
			query5 += "				SUM(ISNULL(DEDU_31, 0)) DEDU_31, SUM(ISNULL(DEDU_32, 0)) DEDU_32, SUM(ISNULL(DEDU_33, 0)) DEDU_33, SUM(ISNULL(DEDU_34, 0)) DEDU_34, SUM(ISNULL(DEDU_35, 0)) DEDU_35,														\n";
			query5 += "				SUM(ISNULL(DEDU_36, 0)) DEDU_36, SUM(ISNULL(DEDU_37, 0)) DEDU_37, SUM(ISNULL(DEDU_38, 0)) DEDU_38, SUM(ISNULL(DEDU_39, 0)) DEDU_39, SUM(ISNULL(DEDU_40, 0)) DEDU_40															\n";
			query5 += "		FROM	@GTB_HR_PPSRPT																																																				\n";
			query5 += "		) T																																																									\n";
			query5 += "-- 3 : 근태																																																								\n";
			query5 += "SELECT	SUM(T.TM_01)  TM_01, SUM(T.TM_02)  TM_02, SUM(T.TM_03)  TM_03, SUM(T.TM_04)  TM_04, SUM(T.TM_05)  TM_05,																														\n";
			query5 += "		SUM(T.TM_06)  TM_06, SUM(T.TM_07)  TM_07, SUM(T.TM_08)  TM_08, SUM(T.TM_09)  TM_09, SUM(T.TM_10)  TM_10,																															\n";
			query5 += "																																																											\n";
			query5 += "		SUM(T.TM_11)  TM_11, SUM(T.TM_12)  TM_12, SUM(T.TM_13)  TM_13, SUM(T.TM_14)  TM_14, SUM(T.TM_15)  TM_15,																															\n";
			query5 += "		SUM(T.TM_16)  TM_16, SUM(T.TM_17)  TM_17, SUM(T.TM_18)  TM_18, SUM(T.TM_19)  TM_19, SUM(T.TM_20)  TM_20																																\n";
			query5 += "FROM	(																																																									\n";
			query5 += "		SELECT	CASE	WHEN W.CD_REPORT  = '001' THEN ISNULL(W.TM, 0) ELSE 0 END TM_01,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '002' THEN ISNULL(W.TM, 0) ELSE 0 END TM_02,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '003' THEN ISNULL(W.TM, 0) ELSE 0 END TM_03,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '004' THEN ISNULL(W.TM, 0) ELSE 0 END TM_04,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '005' THEN ISNULL(W.TM, 0) ELSE 0 END TM_05,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '006' THEN ISNULL(W.TM, 0) ELSE 0 END TM_06,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '007' THEN ISNULL(W.TM, 0) ELSE 0 END TM_07,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '008' THEN ISNULL(W.TM, 0) ELSE 0 END TM_08,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '009' THEN ISNULL(W.TM, 0) ELSE 0 END TM_09,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '010' THEN ISNULL(W.TM, 0) ELSE 0 END TM_10,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '011' THEN ISNULL(W.TM, 0) ELSE 0 END TM_11,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '012' THEN ISNULL(W.TM, 0) ELSE 0 END TM_12,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '013' THEN ISNULL(W.TM, 0) ELSE 0 END TM_13,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '014' THEN ISNULL(W.TM, 0) ELSE 0 END TM_14,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '015' THEN ISNULL(W.TM, 0) ELSE 0 END TM_15,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '016' THEN ISNULL(W.TM, 0) ELSE 0 END TM_16,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '017' THEN ISNULL(W.TM, 0) ELSE 0 END TM_17,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '018' THEN ISNULL(W.TM, 0) ELSE 0 END TM_18,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '019' THEN ISNULL(W.TM, 0) ELSE 0 END TM_19,																																					\n";
			query5 += "				CASE	WHEN W.CD_REPORT  = '020' THEN ISNULL(W.TM, 0) ELSE 0 END TM_20																																						\n";
			query5 += "		FROM	(																																																							\n";
			query5 += "				SELECT	T.CD_REPORT, T.CD_PAYDEDUCT,																																														\n";
			query5 += "						CASE	WHEN T.CD_PAYDEDUCT IN ('WE002', 'WE004', 'WE006') OR (SUBSTRING(T.CD_PAYDEDUCT, 1, 2) = 'WT' AND T.CD_PAYDEDUCT <> 'WTOT') THEN																			\n";
			query5 += "								 NEOE.FN_HR_CONVERT_HOUR_DECIMAL(TM) 																																										\n";
			query5 += "								ELSE T.TM																																																	\n";
			query5 += "						END TM																																																				\n";
			query5 += "				FROM	(																																																					\n";
			query5 += "						SELECT	FM.CD_REPORT, FM.CD_PAYDEDUCT, ISNULL(NEOE.FN_HR_WTMTOTRPT(@P_CD_COMPANY, @P_YM, @P_NO_EMP, FM.CD_PAYDEDUCT), 0) TM																							\n";
			query5 += "						FROM	HR_PREPFORM FM																																																\n";
			query5 += "						WHERE	FM.CD_COMPANY		= @P_CD_COMPANY																																											\n";
			query5 += "						AND		FM.TP_REPORT		= @P_TP_REPORT																																											\n";
			query5 += "						AND		FM.TP_PDREPORT		= '003'																																													\n";
			query5 += "						) T																																																					\n";
			query5 += "				) W																																																							\n";
			query5 += "		) T																																																									\n";
			query5 += "																																																											\n";
			query5 += "-- 4 : 인적정보																																																							\n";
			query5 += "SELECT	TOP 11 																																																							\n";
			query5 += "		A.CD_RHEADER, 																																																						\n";
			query5 += "		B.NM_SYSDEF NM_RHEADER, 																																																			\n";
			query5 += "		CASE																																																								\n";
			query5 += "			WHEN	A.CD_RHEADER = '001' 	THEN	'CD_DUTY_RANK'																																											\n";
			query5 += "			WHEN	A.CD_RHEADER = '002'	THEN	'CD_DUTY_RESP'																																											\n";
			query5 += "			WHEN	A.CD_RHEADER = '003'	THEN	'CD_DUTY_STEP'																																											\n";
			query5 += "			WHEN	A.CD_RHEADER = '004'	THEN	'DT_ENTER'																																												\n";
			query5 += "			WHEN	A.CD_RHEADER = '005'	THEN	'RT_BONUS'																																												\n";
			query5 += "			WHEN	A.CD_RHEADER = '006'	THEN	'TP_EMP'																																												\n";
			query5 += "			WHEN	A.CD_RHEADER = '007'	THEN	'AM_MPAY'																																												\n";
			query5 += "			WHEN	A.CD_RHEADER = '008'	THEN	'AM_DPAY'																																												\n";
			query5 += "			WHEN	A.CD_RHEADER = '009'	THEN	'AM_TPAY'																																												\n";
			query5 += "			WHEN	A.CD_RHEADER = '010'	THEN	'AM_YPAY'																																												\n";
			query5 += "			WHEN	A.CD_RHEADER = '011'	THEN	'DT_RETIRE'																																												\n";
			query5 += "		END SORT																																																							\n";
			query5 += "FROM 	HR_PREPHEADER A																																																						\n";
			query5 += "LEFT OUTER JOIN MA_CODEDTL B																																																				\n";
			query5 += "ON 		A.CD_COMPANY 	= B.CD_COMPANY AND B.CD_FIELD 	= 'HR_P000005' AND	A.CD_RHEADER = B.CD_SYSDEF																																	\n";
			query5 += "WHERE	A.CD_COMPANY 	= @P_CD_COMPANY																																																		\n";
			query5 += "AND		A.TP_REPORT 		= @P_TP_REPORT																																																\n";
			query5 += "AND		A.TP_REPFORM 	= '002'		-- 인적구분 : 001 : 대장, 002 : 명세서 																																							    \n";
			query5 += "AND		A.YN_CHECK 		= 'Y'																																																			\n";
			query5 += " ORDER BY A.CD_RHEADER ASC																																																				\n";
			query5 += "																																																											\n";
			query5 += "SET NOCOUNT OFF																																																							\n";
			query5 += "RETURN;																																																									\n";
			
			
			
			try{		
				stmt.executeQuery(delQuery1);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try{		
				stmt.executeQuery(delQuery2);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try{		
				stmt.executeQuery(delQuery3);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try{		
				stmt.executeQuery(delQuery4);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try{		
				stmt.executeQuery(delQuery5);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			try{
				stmt.executeQuery(query1);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			try{
				stmt.executeQuery(query2);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			try{
				stmt.executeQuery(query3);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			try{
				stmt.executeQuery(query4);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			try{
				stmt.executeQuery(query5);
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		
		
		return mv;		
	}
}
