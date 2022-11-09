package acc.money.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Repository;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("AccMoneyAuthDAO")
public class AccMoneyAuthDAO extends EgovComAbstractDAO {

	/* 변수정의 */
	/* 변수정의 - 로그 */
	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(this.getClass());
	private SqlSessionFactory sqlSessionFactory;

	// 세션 팩토리 객체를 생성하고 그 결과를 리턴해주는 메서드
	private boolean connect(ConnectionVO conVo) {
		boolean result = false;
		try {
			// 환경 설정 파일의 경로를 문자열로 저장
			String resource = "egovframework/sqlmap/config/"
					+ conVo.getDatabaseType()
					+ "/erpOrgAuth/erpOrgAuth-mybatis-config.xml";

			Properties props = new Properties();
			props.put("databaseType", conVo.getDatabaseType());
			props.put("driver", conVo.getDriver());
			props.put("url", conVo.getUrl());
			props.put("username", conVo.getUserId());
			props.put("password", conVo.getPassWord());
			props.put("erpTypeCode", conVo.getSystemType());
			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader(resource);
			// reader 객체의 내용을 가지고 SqlSessionFactory 객체 생성
			// sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader,
			// props);
			if (sqlSessionFactory == null) {
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(
						reader, props);
			} else {
				sqlSessionFactory = null;
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(
						reader, props);
			}
			result = true;
		} catch (Exception e) {
			LOG.error("세션 팩토리 생성 실패:" + e.getMessage());
		}

		return result;
	}

	/* 조회 */
	/* 조회 - 부서별 권한자 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> DeptAuthEmpListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
				
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.DeptAuthEmpListInfoSelect", params);
		return result;
	}

	/* 조회 - 권한목록 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AuthListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}		

		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AuthListInfoSelect", params);
		return result;
	}
	
	/* 조회 - 권한목록  검색 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AuthListInfoSearchSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AuthListInfoSearchSelect", params);
		return result;
	}

	/* 조회 - 권한대상자 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AuthEmpListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AuthEmpListInfoSelect", params);
		return result;
	}

	/* 조회 - 메뉴목록 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AuthMenuListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		params.put("langCode", loginVO.getLangCode());
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AuthMenuListInfoSelect", params);
		return result;
	}

	/* 조회 - ERP 조직도 정보 조회 */
	public List<Map<String, Object>> ErpDeptListInfoSelect(LoginVO loginVO,
			Map<String, Object> params, ConnectionVO conVo) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		/* 별도처리 ( ERP 데이터 조회 필요 ) */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		connect(conVo);

		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession();
		try {
			if(params.get("userSe").equals("ADMIN")) {
				result = session.selectList("ErpDeptListInfoAdminSelect", params);
			} else {
				result = session.selectList("ErpDeptListInfoSelect", params);
			}
			
			session.close();
		} catch (Exception e) {
			LOG.error("데이터 가져오기 실패 : " + e.getMessage());
		} finally {
			session.close();
		}

		return result;
	}

	/* 조회 - GW ERP 정보 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> GWErpInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list("AccMoneyAuthDAO.GWErpInfoSelect", params);
		return result;
	}
	
	/* 조회 - GW ERP 정보 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AuthMappingData(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AuthMappingData", params);
		return result;
	}
	
	/* 조회 - 권한 사용자 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AccPopAuthUserSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AccPopAuthUserSelect", params);
		return result;
	}
	
	/* 조회 - 조직도 검색 조회 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AuthEmpListInfoSearchSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AuthEmpListInfoSearchSelect", params);
		return result;
	}
	
	/* 조회 - GW erp 맵핑된 회사 가져오기 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> AccGWCompSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = (List<Map<String, Object>>) list(
				"AccMoneyAuthDAO.AccGWCompSelect", params);
		return result;
	}

	/* 생성 */
	/* 생성 - 권한 생성 */
	public String AuthInfoInsert(LoginVO loginVO, Map<String, Object> params)
			throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		String result = "";
		
		String paramsInfo = params.get("compSeq").toString();
		
		JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
				.toJSON(paramsInfo));
		
		
		JSONArray compArray = jsonObject.getJSONArray("compSeq");
		@SuppressWarnings("unchecked")
		Map<String, Object> authCode = (Map<String, Object>)select("AccMoneyAuthDAO.AccAuthCodeSelect", params);

		params.put("accMoneyAuthSeq", authCode.get("accMoneyAuthSeq"));
		for(int i=0; i<compArray.size(); i++) {
			JSONObject compSeq = compArray.getJSONObject(i);
			
			params.put("compSeq", compSeq.get("compSeq"));
			
			result = (String)insert("AccMoneyAuthDAO.AuthInfoInsert", params);
		}
		
		int cnt = update("AccMoneyAuthDAO.AuthInfoInsertMulti", params);
		
		result = authCode.get("accMoneyAuthSeq").toString();
		
		if(cnt>0) {
			return result;
		} else {
			result = "fail";
		}

		return result;
	}

	/* 생성 - 권한 대상자 생성 */
	public String AuthEmpInfoInsert(LoginVO loginVO, List<Map<String, Object>> params)
			throws Exception {
		
		String groupSeq = "";
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			groupSeq = loginVO.getGroupSeq();
		}		
		
		String result = "";
		int cnt = 0;
		for(int i=0; i<params.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			cnt = update("AccMoneyAuthDAO.AuthEmpInfoInsert", params.get(i));
		}
		
		
		if(cnt>0) {
			result = "success";
		} else {
			result = "fail";
		}
		return result;
	}
	
	/* 생성 - 권한 대상자 삭제 후 추가 */
	public String AuthEmpInfoDelete(LoginVO loginVO, List<Map<String, Object>> params)
			throws Exception {

		String groupSeq = "";
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			groupSeq = loginVO.getGroupSeq();
		}
		
		String result = "";
		int cnt = 0;
		
		for(int i=0; i<params.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			cnt = delete("AccMoneyAuthDAO.AuthEmpInfoDelete", params.get(i));
		}
		
		for(int i=0; i<params.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			cnt = update("AccMoneyAuthDAO.AuthEmpInfoInsert", params.get(i));
		}
		
		if(cnt>0) {
			result = "success";
		} else {
			result = "fail";
		}
		return result;
	}

	/* 생성 - 권한 메뉴, ERP 조직도 생성 */
	public String AuthMenuDeptInfoInsert(LoginVO loginVO,
			List<Map<String, Object>> params) throws Exception {

		String result = "";
		
		String groupSeq = "";
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			groupSeq = loginVO.getGroupSeq();
		}		
		
		for(int i=0; i<params.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			int cnt = update("AccMoneyAuthDAO.AuthMenuDeptInfoInsert",
					params.get(i));
			if(cnt>0) {
				result = "success";
			} else {
				result = "fail";
			}
		}
		
		
		return result;
	}
	
	/* 생성 - 사용자 지정권한 생성 */
	public String AuthUserInsert(LoginVO loginVO,
			List<Map<String, Object>> params) throws Exception {

		String result = "";
		
		String groupSeq = "";
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			groupSeq = loginVO.getGroupSeq();
		}		
		
		JSONArray compArray = (JSONArray)params.get(0).get("compArray");

		result = params.get(0).get("authCode").toString();
		
		for(int i=0; i<compArray.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			JSONObject compSeq = compArray.getJSONObject(i);
			
			params.get(0).put("gwCompSeq", compSeq.get("compSeq"));
			
			insert("AccMoneyAuthDAO.AuthUserInsert",
					params.get(0));
		}

		insert("AccMoneyAuthDAO.AuthUserInsertMulti",
				params.get(0));

		insert("AccMoneyAuthDAO.AuthEmpInfoInsert",
				params.get(0));
		
	
		for(int i=0; i<params.size(); i++) {
			insert("AccMoneyAuthDAO.AuthMenuDeptInfoInsert",
					params.get(i));
		}
		
		return result;
	}
	
	/* 수정 */
	/*수정 - 권한 erp 조직도 수정*/
	public int AuthMenuDeptInfoUpdate(LoginVO loginVO,
			List<Map<String, Object>> params) throws Exception {

		String groupSeq = "";
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			groupSeq = loginVO.getGroupSeq();
		}
		
		int result=0;
		/* 삭제 : 삭제한 row 수 */
		delete("AccMoneyAuthDAO.AuthMenuDeptInfoMenuDelete", params.get(0));
		delete("AccMoneyAuthDAO.AuthMenuDeptInfoAuthDelete", params.get(0));
		JSONArray compArray = (JSONArray)params.get(0).get("compArray");
		
		for(int i=0; i<compArray.size(); i++) {
			JSONObject compSeq = compArray.getJSONObject(i);
			
			params.get(i).put("gwCompSeq", compSeq.get("compSeq"));
			
			insert("AccMoneyAuthDAO.AuthMenuDeptInfoAuthInsert", params.get(i));
		}
		
		update("AccMoneyAuthDAO.AuthMenuDeptInfoAuthUpdate", params.get(0));
		update("AccMoneyAuthDAO.AuthMenuDeptInfoAuthMultiUpdate", params.get(0));
		
		for(int i=0; i<params.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			int cnt = update("AccMoneyAuthDAO.AuthMenuDeptInfoAuthNewMenuInsert",
					params.get(i));
			if(cnt>0) {
				result = 1;
			} else {
				result = 0;
			}
		}

		return result;
	}

	/* 삭제 */
	/* 삭제 - 권한 대상자 삭제 */
	public int AuthEmpInfoDelete(LoginVO loginVO, Map<String, Object> params)
			throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		int result = 0;
		/* 삭제 : 삭제한 row 수 */
		result = (int) delete("AccMoneyAuthDAO.AuthEmpInfoDelete", params);
		return result;
	}

	/* 삭제 - 기존 권한 지우기 */
	public String AuthUserDelete(LoginVO loginVO, List<Map<String, Object>> params)
			throws Exception {

		String result = null;
		
		String groupSeq = "";
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			groupSeq = loginVO.getGroupSeq();
		}		
		
		JSONArray compArray = (JSONArray)params.get(0).get("compArray");
		
		delete("AccMoneyAuthDAO.AuthMenuDeptInfoMenuDelete", params.get(0));
		delete("AccMoneyAuthDAO.AuthMenuDeptInfoAuthDelete", params.get(0));
		
		for(int i=0; i<compArray.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			JSONObject compSeq = compArray.getJSONObject(i);
			
			params.get(i).put("gwCompSeq", compSeq.get("compSeq"));
			
			result = (String)insert("AccMoneyAuthDAO.AuthUserInsert",
					params.get(i));
			
			result = (String)insert("AccMoneyAuthDAO.AuthUserInsertMulti",
					params.get(i));
			
		}
		
		/* 삭제 : 삭제한 row 수 */
		for(int i=0; i<params.size(); i++) {
			
			if(!groupSeq.equals("")) {
				params.get(i).put("groupSeq", groupSeq);
			}
			
			delete("AccMoneyAuthDAO.AuthEmpInfoDelete", params.get(i));
			result = (String)insert("AccMoneyAuthDAO.AuthEmpInfoInsert",
					params.get(i));
			
			result = (String)insert("AccMoneyAuthDAO.AuthMenuDeptInfoInsert",
					params.get(i));
		}
		
		
		return result;
	}

	/* 삭제 - 권한 메뉴, ERP 조직도 삭제 */
	public int AuthMenuDeptInfoDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}	
		
		int resultMenu = 0;
		int resultAuth = 0;
		int resultAuthMulti = 0;
		int result;
		/* 삭제 : 삭제한 row 수 */
		resultMenu = (int) delete("AccMoneyAuthDAO.AuthMenuDeptInfoMenuDelete", params);
		delete("AccMoneyAuthDAO.AuthMenuDeptInfoEmpDelete", params);
		resultAuth = (int) delete("AccMoneyAuthDAO.AuthMenuDeptInfoAuthDelete", params);
		resultAuthMulti = (int) delete("AccMoneyAuthDAO.AuthMenuDeptInfoAuthMultiDelete", params);
		
		if(resultMenu > 0 && resultAuth > 0 && resultAuthMulti > 0) {
			result = 1;
		} else {
			result = 0;
		}
		return result;
	}
	
	/* 삭제 - 유저 권한 삭제 */
	public int AccUserAuthDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {

		int result = 0;
		
		if(loginVO != null && loginVO.getGroupSeq() != null && !loginVO.getGroupSeq().equals("")) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}		
		
		String paramsInfo = params.get("info").toString();
		
		JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
				.toJSON(paramsInfo));
		
		JSONArray empArray = jsonObject.getJSONArray("empSeqLists");
		
		for(int i=0; i<empArray.size(); i++) {
			
			JSONObject empSeq = empArray.getJSONObject(i);
			
			params.put("empSeq", empSeq.get("empSeq"));
			
			if(jsonObject.get("userAuth").equals("Y")) {
				result = (int)delete("AccMoneyAuthDAO.AccUserAuthDelete", params);
				result = (int)delete("AccMoneyAuthDAO.AccUserAuthMultiDelete", params);
				result = (int)delete("AccMoneyAuthDAO.AccUserAuthMenuDelete", params);
			}
			
			result = (int)delete("AccMoneyAuthDAO.AccEmpAuthDelete", params);
			
		}

		return result;
	}
}