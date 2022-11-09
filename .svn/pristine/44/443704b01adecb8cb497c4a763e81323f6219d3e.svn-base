package neos.cmm.systemx.item.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Repository;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import neos.cmm.util.CommonUtil;
import neos.cmm.vo.ConnectionVO;

@Repository("ItemManageDAO")
public class ItemManageDAO extends EgovComAbstractDAO{

private SqlSessionFactory sqlSessionFactory;
	
	// 세션 팩토리 객체를 생성하고 그 결과를 리턴해주는 메서드
	private boolean connect(ConnectionVO conVo) {
		boolean result = false;
		try {
			// 환경 설정 파일의 경로를 문자열로 저장
			// String resource = "sample/mybatis/sql/mybatis-config.xml";
			String resource = "egovframework/sqlmap/config/" + conVo.getDatabaseType() + "/item/item-mybatis-config.xml";

			Properties props = new Properties();
			props.put("databaseType", conVo.getDatabaseType());
			props.put("driver", conVo.getDriver());
			props.put("url", conVo.getUrl());
			props.put("username", conVo.getUserId());
			props.put("password", conVo.getPassWord());
			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader(resource);
			
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
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return result;
	}
	
	/* 조회 */
	/* 조회 - 항목목록 조회 */
	public List<Map<String, Object>> ItemListSelect(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		result = (List<Map<String, Object>>)list("ItemManageDAO.ItemListSelect", params);
		
		return result;
	}
	
	/* 조회 - 항목 코드 세부사항 */
	public Map<String, Object> ItemCodeDetailSelect(Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result = (Map<String, Object>)select("ItemManageDAO.ItemCodeDetailSelect", params);
		
		return result;
	}
	
	/* 조회 - 그룹 코드 목록 조회 */
	public List<Map<String, Object>> ItemUserDefineCodeListSelect(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		result = (List<Map<String, Object>>)list("ItemManageDAO.ItemUserDefineCodeListSelect", params);
		
		return result;	
	}
	
	/* 조회 - 외부코드 목록 조회 */
	public List<Map<String, Object>> ItemExternalCodeListSelect(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		result = (List<Map<String, Object>>)list("ItemManageDAO.ItemExternalCodeListSelect", params);
		
		return result;	
	}
	
	/* 조회 - 그룹코드 상세코드 목록 조회 */
	public List<Map<String, Object>> ItemCodeGroupDetailCodeSelect(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		result = (List<Map<String, Object>>)list("ItemManageDAO.ItemCodeGroupDetailCodeSelect", params);
		
		return result;	
	}
	
	/* 조회 - 상세코드 데이터 조회 */
	public Map<String, Object> ItemDetailCodeSelect(Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result = (Map<String, Object>)select("ItemManageDAO.ItemDetailCodeSelect", params);
		
		return result;
	}
	
	/* 조회 - 외부코드 상세 데이터 조회 */
	public Map<String, Object> ItemExternalCodeDetailSelect(Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result = (Map<String, Object>)select("ItemManageDAO.ItemExternalCodeDetailSelect", params);
		
		return result;
	}
	
	/* 조회 - 코드 중복확인 */
	public Map<String, Object> checkItemCodeSeq(LoginVO loginVO, Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		params.put("groupSeq", loginVO.getGroupSeq()); 
		result = (Map<String, Object>)select("ItemManageDAO.checkItemCodeSeq", params);
		
		return result;
	}
	
	/* 조회 - 상세 코드 중복확인 */
	public Map<String, Object> checkDetailCodeSeq(LoginVO loginVO, Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		params.put("groupSeq", loginVO.getGroupSeq()); 
		result = (Map<String, Object>)select("ItemManageDAO.checkDetailCodeSeq", params);
		
		return result;
	}
	
	/* 조회 - 외부 코드 중복확인 */
	public Map<String, Object> checkExternalCodeSeq(LoginVO loginVO, Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		params.put("groupSeq", loginVO.getGroupSeq()); 
		result = (Map<String, Object>)select("ItemManageDAO.checkExternalCodeSeq", params);
		
		return result;
	}
	
	/* 조회 - 그룹코드 중복확인 */
	public Map<String, Object> checkGroupCodeSeq(LoginVO loginVO, Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String,Object>();
		params.put("groupSeq", loginVO.getGroupSeq()); 
		result = (Map<String, Object>)select("ItemManageDAO.checkGroupCodeSeq", params);
		
		return result;
	}
	
	/* 조회 - 외부시스템 쿼리 조회 */
	public List<Map<String, Object>> getExternalCodeList(ConnectionVO conVo, Map<String, Object> params) throws Exception {
		/* 별도처리 ( ERP 데이터 조회 필요 ) */
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		connect(conVo);

		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession();
		try {
		
			result = session.selectList("selectItemExternalQuery", params);
			
			session.close();
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			session.close();
		}

		return result;
	}
	
	/* 생성 */
	/* 생성 - 항목생성 */
	public String ItemCodeInsert(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemCodeInsert", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 생성 - 코드 그룹 생성 */
	public String ItemCodeGroupInsert(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemCodeGroupInsert", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 생성 - 코드 그룹 상세코드 생성 */
	public String ItemCodeGroupDetailCodeInsert(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemCodeGroupDetailCodeInsert", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 생성 - 외부코드 생성 */
	public String ItemExternalCodeInsert(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemExternalCodeInsert", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 수정 */
	/* 수정 - 항목수정*/
	public String ItemCodeUpdate(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemCodeUpdate", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 수정 - 상세코드 수정*/
	public String ItemCodeGroupDetailCodeEdit(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemCodeGroupDetailCodeEdit", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 수정 - 외부코드 상세 수정*/
	public String ItemExternalCodeEdit(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemExternalCodeEdit", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 수정 - 그룹코드 수정*/
	public String ItemCodeGroupUpdate(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = update("ItemManageDAO.ItemCodeGroupUpdate", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 삭제 */
	/* 삭제 - 항목 삭제 */
	public String ItemCodeDelete(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = delete("ItemManageDAO.ItemCodeDelete", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 삭제 - 그룹코드 삭제*/
	public String ItemGroupCodeDelete(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = delete("ItemManageDAO.ItemGroupCodeDelete", params);
		delete("ItemManageDAO.ItemGroupCodeDetailDelete", params);
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 삭제 - 외부코드 삭제*/
	public String ItemExternalCodeDelete(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = delete("ItemManageDAO.ItemExternalCodeDelete", params);
		
		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 삭제 - 상세코드 삭제*/
	public String ItemDetailCodeDelete(Map<String, Object> params) throws Exception {
		String result = "";
		int cnt = 0;
		
		cnt = delete("ItemManageDAO.ItemDetailCodeDelete", params);

		if(cnt > 0) {
			result = "success";
		} else {
			result = "fail";
		}
		
		return result;
	}
	
	/* 기타(공통) */
	/* 외부코드 정보 가져오기 */
	public Map<String, Object> getExternalCodeInfo(Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String,Object>();
		
		result = (Map<String, Object>)select("ItemManageDAO.getExternalCodeInfo", params);

		return result;
	}

	public Map<String, Object> getCodeGrpInfo(Map<String, Object> params) {
		return (Map<String, Object>)select("ItemManageDAO.getCodeGrpInfo", params);
	}
}
