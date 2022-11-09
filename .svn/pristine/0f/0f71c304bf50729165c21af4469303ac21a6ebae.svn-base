package acc.money.service.impl;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.util.CommonUtil;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Service;

import acc.money.dao.AccMoneyAuthDAO;
import acc.money.service.AccMoneyAuthService;
import bizbox.orgchart.service.vo.LoginVO;

@Service("AccMoneyAuthService")
public class AccMoneyAuthServiceImpl implements AccMoneyAuthService {

	/* 변수정의 */
	/* 변수정의 - DAO */
	@Resource(name = "AccMoneyAuthDAO")
	private AccMoneyAuthDAO accMoneyAuthDAO;

	/* 변수정의 - 로그 */
	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(this
			.getClass());

	/* 조회 */
	/* 조회 - 부서별 권한자 조회 */
	public List<Map<String, Object>> DeptAuthEmpListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> DeptAuthEmpListInfoSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> DeptAuthEmpListInfoSelect");

		return result;
	}

	/* 조회 - 권한목록 검색 조회 */
	public List<Map<String, Object>> AuthListInfoSearchSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthListInfoSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			/* 조회 */
			params.put("langCode", loginVO.getLangCode());
			result = accMoneyAuthDAO.AuthListInfoSearchSelect(loginVO, params);

		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthListInfoSelect");

		return result;
	}
	
	/* 조회 - 권한목록 조회 */
	public List<Map<String, Object>> AuthListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthListInfoSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		String userSe = null;
		
		try {
			/* 조회 */
			userSe = loginVO.getUserSe();
			
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", userSe);
			params.put("compSeq", loginVO.getCompSeq());
			
			result = accMoneyAuthDAO.AuthListInfoSelect(loginVO, params);

		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthListInfoSelect");

		return result;
	}

	/* 조회 - 권한대상자 조회 */
	public List<Map<String, Object>> AuthEmpListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpListInfoSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			result = accMoneyAuthDAO.AuthEmpListInfoSelect(loginVO, params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpListInfoSelect");

		return result;
	}

	/* 조회 - 메뉴목록 조회 */
	public List<Map<String, Object>> AuthMenuListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuListInfoSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			/* 조회 */
			result = accMoneyAuthDAO.AuthMenuListInfoSelect(loginVO, params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuListInfoSelect");

		return result;
	}

	/* 조회 - ERP 조직도 정보 조회 */
	public List<Map<String, Object>> ErpDeptListInfoSelect(LoginVO loginVO,
			Map<String, Object> params, ConnectionVO conVo) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> ErpDeptListInfoSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			/* 조회 */
			result = accMoneyAuthDAO.ErpDeptListInfoSelect(loginVO, params,
					conVo);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> ErpDeptListInfoSelect");

		return result;
	}

	/* 조회 - GW ERP 정보 조회 */
	public List<Map<String, Object>> GWErpInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> GWErpInfoSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		/* erp 타입 및 정보 셋팅 */
		params.put("erpType", "iCUBE");
		params.put("erpGubun", "ac");
		params.put("groupSeq", loginVO.getGroupSeq());

		try {
			/* 조회 */
			result = accMoneyAuthDAO.GWErpInfoSelect(loginVO, params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> GWErpInfoSelect");

		return result;
	}	
	
	/* 조회 - 권한 맵핑 (erp 조직도, 메뉴) 조회 */
	public List<Map<String, Object>> AuthMappingData(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthMappingData");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			/* 조회 */
			result = accMoneyAuthDAO.AuthMappingData(loginVO, params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> GWErpInfoSelect");

		return result;
	}
	
	/* 조회 - 권한 사용자 조회 */
	public List<Map<String, Object>> AccPopAuthUserSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AccPopAuthUserSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			/* 조회 */
			params.put("langCode", loginVO.getLangCode());
			
			if(loginVO.getUserSe().equals("MASTER")) {
				params.put("userSe", "MASTER");
			} else if(loginVO.getUserSe().equals("ADMIN")) {
				params.put("userSe", "ADMIN");
				params.put("compSeq", loginVO.getCompSeq());
			}
			
			result = accMoneyAuthDAO.AccPopAuthUserSelect(loginVO, params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AccPopAuthUserSelect");

		return result;
	}
	
	/* 조회 - 조직도 검색 조회 */
	public List<Map<String, Object>> AuthEmpListInfoSearchSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpListInfoSearchSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			/* 조회 */
			params.put("langCode", loginVO.getLangCode());
			params.put("groupSeq", loginVO.getGroupSeq());
			result = accMoneyAuthDAO.AuthEmpListInfoSearchSelect(loginVO, params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpListInfoSearchSelect");

		return result;
	}
	
	/* 조회 - GW erp 맵핑된 회사 가져오기  */
	public List<Map<String, Object>> AccGWCompSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AccGWCompSelect");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		/* 변수정의 */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			/* 조회 */
			params.put("langCode", loginVO.getLangCode());
			params.put("groupSeq", loginVO.getGroupSeq());
			result = accMoneyAuthDAO.AccGWCompSelect(loginVO, params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AccGWCompSelect");

		return result;
	}
	
	/* 생성 */
	/* 생성 - 권한 생성 */
	public Map<String, Object> AuthInfoInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthInfoInsert");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();
		String authCodeResult = null;
		try {


			/* 권한코드 생성 */
			authCodeResult = accMoneyAuthDAO.AuthInfoInsert(loginVO, params);
			result.put("authCode", authCodeResult);
			

		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthInfoInsert");

		return result;
	}

	/* 생성 - 권한 대상자 생성 */
	public Map<String, Object> AuthEmpInfoInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpInfoInsert");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();
		String insertAuthEmp = null;
		String deleteAuthEmp = null;
		Map<String, Object> items = null;
		List<Map<String, Object>> baseParam = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> changeParam = new ArrayList<Map<String,Object>>();
		
		try {
			params.put("empSeq", loginVO.getUniqId());
//			params.put("compSeq", loginVO.getCompSeq());
//			params.put("deptSeq", loginVO.getOrgnztId());
			
			
			String paramsInfo = params.get("info").toString();
			
			JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
					.toJSON(paramsInfo));
			
			String changeAuth = jsonObject.get("changeAuth").toString();
			
			JSONArray userArray = jsonObject.getJSONArray("userArray");
			
			for(int i=0; i<userArray.size(); i++) {
				JSONObject userInfo = userArray.getJSONObject(i);
				items = new HashMap<String, Object>();
				if(userInfo.get("baseAuthCode").toString().equals("")) {
					items.put("authEmp", userInfo.get("authEmp").toString());
					items.put("authCode", changeAuth);
					items.put("authComp", userInfo.get("authComp").toString());
					items.put("authDept", userInfo.get("authDept").toString());
					baseParam.add(items);
				} else {
					
					items.put("authCode", changeAuth);
					items.put("authEmp", userInfo.get("authEmp").toString());
					items.put("authComp", userInfo.get("authComp").toString());
					items.put("authDept", userInfo.get("authDept").toString());
					items.put("baseAuthCode", userInfo.get("baseAuthCode").toString());
					changeParam.add(items);
				}
			}
			if(baseParam.size() > 0) {
				insertAuthEmp = accMoneyAuthDAO.AuthEmpInfoInsert(loginVO, baseParam);
				result.put("result", insertAuthEmp);
			}
			
			if(changeParam.size() > 0) {
				deleteAuthEmp = accMoneyAuthDAO.AuthEmpInfoDelete(loginVO, changeParam);
				result.put("result", deleteAuthEmp);
			}
			
			
					
			
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpInfoInsert");

		return result;
	}

	/* 생성 - 권한 메뉴, ERP 조직도 생성 */
	public Map<String, Object> AuthMenuDeptInfoInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuDeptInfoInsert");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> items = null;
		List<Map<String, Object>> insertParam = new ArrayList<Map<String,Object>>();
		
		try {
			String paramsInfo = params.get("info").toString();
			
			JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
					.toJSON(paramsInfo));
			
			JSONArray erpInfo = jsonObject.getJSONArray("erpInfo");
			JSONArray menuJsonArray = jsonObject.getJSONArray("menuArray");
			String insertResult = null;
			String authCode = jsonObject.get("authCode").toString();
			
			for(int i=0; i<menuJsonArray.size(); i++) {
				for(int j=0; j<erpInfo.size(); j++) {
					items = new HashMap<String, Object>();
					JSONObject info = erpInfo.getJSONObject(j);
					
					items.put("authCode", authCode);
					items.put("menuCode", menuJsonArray.get(i));
					items.put("gwCompSeq", info.get("gwCompSeq").toString());
					items.put("erpComp", info.get("erpComp").toString());
					items.put("erpBiz", info.get("erpBiz").toString());
					items.put("erpCompName", info.get("erpCompNm").toString());
					items.put("erpBizName", info.get("erpBizNm").toString());
					insertParam.add(items);
				}
			}
			
			
			insertResult = accMoneyAuthDAO.AuthMenuDeptInfoInsert(loginVO, insertParam);
			
			result.put("insertResult", insertResult);
			
			LOG.debug(insertParam);

			
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuDeptInfoInsert");

		return result;
	}
	
	/* 생성 - 사용자 지정 권한*/
	public 	Map<String, Object> AuthUserInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthUserInsert");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> items = null;
		List<Map<String, Object>> changeParam = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> baseParam = new ArrayList<Map<String,Object>>();
		
		try {
			String paramsInfo = params.get("info").toString();
			
			JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
					.toJSON(paramsInfo));
			
			JSONArray userJsonArray = jsonObject.getJSONArray("userInfoArray");
			JSONArray menuJsonArray = jsonObject.getJSONArray("menuArray");
			JSONArray erpInfo = jsonObject.getJSONArray("erpInfoArray");
			JSONArray compArray = jsonObject.getJSONArray("compArray");
			String insertResult = null;
			
			for(int i=0; i<userJsonArray.size(); i++) {
				JSONObject userInfo = userJsonArray.getJSONObject(i);
				for(int j=0; j<menuJsonArray.size(); j++) {
					for(int k=0; k<erpInfo.size(); k++) {
						items = new HashMap<String, Object>();
						JSONObject info = erpInfo.getJSONObject(k);
						if(userInfo.get("baseAuthCode").toString().equals("")) {
							items.put("langCode", loginVO.getLangCode());
							items.put("authEmp", userInfo.get("authEmp").toString());
							items.put("authCode", userInfo.get("authComp").toString() + "_" + userInfo.get("authDept").toString() + "_" + userInfo.get("authEmp").toString());
							items.put("authComp", userInfo.get("authComp").toString());
							items.put("authDept", userInfo.get("authDept").toString());
							items.put("menuCode", menuJsonArray.get(j));
							items.put("gwCompSeq", info.get("gwCompSeq").toString());
							items.put("erpComp", info.get("erpComp").toString());
							items.put("erpBiz", info.get("erpBiz").toString());
							items.put("erpCompName", info.get("erpCompNm").toString());
							items.put("erpBizName", info.get("erpBizNm").toString());							
							items.put("compArray",compArray);
							baseParam.add(items);
						} else {
							items.put("langCode", loginVO.getLangCode());
							items.put("authCode", userInfo.get("authComp").toString() + "_" + userInfo.get("authDept").toString() + "_" + userInfo.get("authEmp").toString());
							items.put("authEmp", userInfo.get("authEmp").toString());
							items.put("authComp", userInfo.get("authComp").toString());
							items.put("authDept", userInfo.get("authDept").toString());
							items.put("menuCode", menuJsonArray.get(j));
							items.put("gwCompSeq", info.get("gwCompSeq").toString());
							items.put("erpComp", info.get("erpComp").toString());
							items.put("erpBiz", info.get("erpBiz").toString());
							items.put("erpCompName", info.get("erpCompNm").toString());
							items.put("erpBizName", info.get("erpBizNm").toString());
							items.put("baseAuthCode", userInfo.get("baseAuthCode").toString());
							items.put("compArray",compArray);
							changeParam.add(items);
						}
					}
				}
				
			}
			
			if(baseParam.size() > 0) {
				insertResult = accMoneyAuthDAO.AuthUserInsert(loginVO, baseParam);
			}
			
			if(changeParam.size() > 0) {
				accMoneyAuthDAO.AuthUserDelete(loginVO, changeParam);
			}
			
			result.put("insertResult", insertResult);
			
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthUserInsert");

		return result;
	}
	
	/* 수정 */
	/*수정 - 권한 erp 조직도 수정*/
	public Map<String, Object> AuthMenuDeptInfoUpdate(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuDeptInfoUpdate");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> items = null;
		List<Map<String, Object>> insertParam = new ArrayList<Map<String,Object>>();
		int resultInt = 0;
		
		try {
			String paramsInfo = params.get("info").toString();
			
			JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
					.toJSON(paramsInfo));
			
			JSONArray erpInfo = jsonObject.getJSONArray("erpInfo");
			JSONArray menuJsonArray = jsonObject.getJSONArray("menuArray");
			JSONArray compArray = jsonObject.getJSONArray("compArray");
			
			String authCode = jsonObject.get("authCode").toString();
			String authName = jsonObject.get("authName").toString();
			String authEtc = jsonObject.get("authEtc").toString();
			
			for(int i=0; i<menuJsonArray.size(); i++) {
				for(int j=0; j<erpInfo.size(); j++) {
					items = new HashMap<String, Object>();
					JSONObject info = erpInfo.getJSONObject(j);
					
					items.put("compArray", compArray);
					items.put("authEtc", authEtc);
					items.put("authName", authName);
					items.put("authCode", authCode);
					items.put("menuCode", menuJsonArray.get(i));
					items.put("gwCompSeq", info.get("gwCompSeq").toString());
					items.put("erpComp", info.get("erpComp").toString());
					items.put("erpBiz", info.get("erpBiz").toString());
					items.put("erpCompName", info.get("erpCompNm").toString());
					items.put("erpBizName", info.get("erpBizNm").toString());
					insertParam.add(items);
				}
			}
			
			resultInt = accMoneyAuthDAO.AuthMenuDeptInfoUpdate(loginVO, insertParam);
			
			if(resultInt == 1) {
				result.put("update", "success");
			} else {
				result.put("update", "fail");
			}
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuDeptInfoUpdate");

		return result;		
	}

	/* 삭제 */
	/* 삭제 - 권한 대상자 삭제 */
	public Map<String, Object> AuthEmpInfoDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpInfoDelete");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthEmpInfoDelete");

		return result;
	}

	/* 삭제 - 권한 메뉴, ERP 조직도 삭제 */
	public Map<String, Object> AuthMenuDeptInfoDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuDeptInfoDelete");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();
		int resultInt = 0;
		
		try {
			resultInt = accMoneyAuthDAO.AuthMenuDeptInfoDelete(loginVO, params);

			if(resultInt == 1) {
				result.put("delete", "success");
			} else {
				result.put("delete", "fail");
			}
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AuthMenuDeptInfoDelete");

		return result;
	}

	/* 삭제 - 유저 권한 삭제 */
	public Map<String, Object> AccUserAuthDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - AccMoneyAuthService >> AccUserAuthDelete");
		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> params >> "
				+ params.toString());

		Map<String, Object> result = new HashMap<String, Object>();
		int resultInt = 0;
		
		try {
			resultInt = accMoneyAuthDAO.AccUserAuthDelete(loginVO, params);

			if(resultInt == 1) {
				result.put("delete", "success");
			} else {
				result.put("delete", "fail");
			}
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [AMAUTH] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [AMAUTH] INFO - AccMoneyAuthService >> AccUserAuthDelete");

		return result;
	}
}
