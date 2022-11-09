package neos.cmm.systemx.item.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.apache.ibatis.datasource.pooled.PooledDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.systemx.item.dao.ItemManageDAO;
import neos.cmm.systemx.item.service.ItemManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("ItemMangeService")
public class ItemManageServiceImpl implements ItemManageService {
	/* 변수정의 */
	/* 변수정의 - DAO */
	@Resource(name = "ItemManageDAO")
	private ItemManageDAO itemManageDAO;
	
	/* 변수정의 - 로그 */
	private Logger LOG = LogManager.getLogger(this
			.getClass());
	
	private ConnectionVO conVo = new ConnectionVO();
	
	/* 조회 */
	/* 조회 - 항목목록 */
	public List<Map<String, Object>> ItemListSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemListSelect");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			/* 변수정의 */
			
			/* 초기값 정의 */
			params.put("langCode", loginVO.getLangCode());
			
			/* 서비스 호출 */
			result = itemManageDAO.ItemListSelect(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemListSelect");

		return result;
	}
	
	/* 조회 - 항목목록 세부사항 */
	public Map<String, Object> ItemCodeDetailSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeDetailSelect");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			
			result = itemManageDAO.ItemCodeDetailSelect(params);

		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeDetailSelect");

		return result;
	}
	
	/* 조회 - 사용자정의 코드관리 조회 */
	public List<Map<String, Object>> ItemUserDefineCodeListSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemUserDefineCodeListSelect");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			params.put("langCode", loginVO.getLangCode());
			result = itemManageDAO.ItemUserDefineCodeListSelect(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemUserDefineCodeListSelect");

		return result;
	}
	
	/* 조회 - 사용자정의 코드관리 조회 */
	public List<Map<String, Object>> ItemExternalCodeListSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemExternalCodeListSelect");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			result = itemManageDAO.ItemExternalCodeListSelect(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemExternalCodeListSelect");

		return result;
	}
	
	/* 조회 - 그룹코드 상세코드 목록 조회 */
	public List<Map<String, Object>> ItemCodeGroupDetailCodeSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeGroupDetailCodeSelect");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			result = itemManageDAO.ItemCodeGroupDetailCodeSelect(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeGroupDetailCodeSelect");

		return result;
	}
	
	/* 조회 - 상세코드 데이터 조회 */
	public Map<String, Object> ItemDetailCodeSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemDetailCodeSelect");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			result = itemManageDAO.ItemDetailCodeSelect(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemDetailCodeSelect");

		return result;
	}
	
	/* 조회 - 외부코드 상세 데이터 조회 */
	public Map<String, Object> ItemExternalCodeDetailSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemExternalCodeDetailSelect");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			result = itemManageDAO.ItemExternalCodeDetailSelect(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemExternalCodeDetailSelect");

		return result;
	}
	
	/* 조회 - 코드 중복확인 */
	public Map<String, Object> checkItemCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> checkItemCodeSeq");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		
		result = itemManageDAO.checkItemCodeSeq(loginVO, params);
		


		LOG.debug("- [ItemManage] INFO - ItemManageService >> checkItemCodeSeq");

		return result;
	}
	
	/* 조회 - 상세코드 중복확인 */
	public Map<String, Object> checkDetailCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> checkDetailCodeSeq");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		
		result = itemManageDAO.checkDetailCodeSeq(loginVO, params);
		


		LOG.debug("- [ItemManage] INFO - ItemManageService >> checkDetailCodeSeq");

		return result;
	}
	
	/* 조회 - 외부코드 중복확인 */
	public Map<String, Object> checkExternalCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> checkExternalCodeSeq");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		
		result = itemManageDAO.checkExternalCodeSeq(loginVO, params);
		


		LOG.debug("- [ItemManage] INFO - ItemManageService >> checkExternalCodeSeq");

		return result;
	}
	
	/* 조회 - 그룹코드 중복확인 */
	public Map<String, Object> checkGroupCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> checkGroupCodeSeq");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		
		result = itemManageDAO.checkGroupCodeSeq(loginVO, params);
		


		LOG.debug("- [ItemManage] INFO - ItemManageService >> checkGroupCodeSeq");

		return result;
	}	
	
	/* 생성 */
	/* 생성 - 항목 생성 */
	public Map<String, Object> ItemCodeInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeInsert");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("itemCode", EgovStringUtil.isNullToString(params.get("itemCode")));
			params.put("itemName", EgovStringUtil.isNullToString(params.get("itemName")));
			params.put("itemDesc", EgovStringUtil.isNullToString(params.get("itemDesc")));
			params.put("itemRange", EgovStringUtil.isNullToString(params.get("itemRange")));
			params.put("itemUseYN", EgovStringUtil.isNullToString(params.get("itemUseYN")));
			params.put("systemGubun", EgovStringUtil.isNullToString(params.get("systemGubun")));
			params.put("systemDefault", EgovStringUtil.isNullToString(params.get("systemDefault")));
			params.put("systemMulti", EgovStringUtil.isNullToString(params.get("systemMulti")));
			params.put("systemDisplay", EgovStringUtil.isNullToString(params.get("systemDisplay")));
			params.put("textLineCount", EgovStringUtil.isNullToString(params.get("textLineCount")));
			params.put("numberMaxVal", EgovStringUtil.isNullToString(params.get("numberMaxVal")));
			params.put("numberMinVal", EgovStringUtil.isNullToString(params.get("numberMinVal")));
			params.put("numberDecimalPoint", EgovStringUtil.isNullToString(params.get("numberDecimalPoint")));
			params.put("datetimeType", EgovStringUtil.isNullToString(params.get("datetimeType")));
			params.put("datetimeDateType", EgovStringUtil.isNullToString(params.get("datetimeDateType")));
			params.put("datetimeDefault1", EgovStringUtil.isNullToString(params.get("datetimeDefault1")));
			params.put("datetimeDefault2", EgovStringUtil.isNullToString(params.get("datetimeDefault2")));
			params.put("userDefineCodeType", EgovStringUtil.isNullToString(params.get("userDefineCodeType")));
			params.put("userDefineCodeKind", EgovStringUtil.isNullToString(params.get("userDefineCodeKind")));
			params.put("userDefineCodeDefault", EgovStringUtil.isNullToString(params.get("userDefineCodeDefault")));
			params.put("externalCodeKind", EgovStringUtil.isNullToString(params.get("externalCodeKind")));
			
			params.put("empSeq", loginVO.getUniqId());
			itemManageDAO.ItemCodeInsert(params);
			
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeInsert");

		return result;
		
	}
	
	/* 생성 - 코드 그룹 생성 */
	public Map<String, Object> ItemCodeGroupInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeGroupInsert");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("groupCode", EgovStringUtil.isNullToString(params.get("groupCode")));
			params.put("groupName", EgovStringUtil.isNullToString(params.get("groupName")));
			params.put("authGubun", EgovStringUtil.isNullToString(params.get("authGubun")));
			params.put("useYN", EgovStringUtil.isNullToString(params.get("useYN")));

			params.put("empSeq", EgovStringUtil.isNullToString(loginVO.getUniqId()));

			itemManageDAO.ItemCodeGroupInsert(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeGroupInsert");

		return result;
	}
	
	/* 생성 - 코드 그룹 상세코드 생성 */
	public Map<String, Object> ItemCodeGroupDetailCodeInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeGroupDetailCodeInsert");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("detailCode", EgovStringUtil.isNullToString(params.get("detailCode")));
			params.put("detailCodeName", EgovStringUtil.isNullToString(params.get("detailCodeName")));
			params.put("detailCodeOrder", EgovStringUtil.isNullToString(params.get("detailCodeOrder")));
			params.put("groupCode", EgovStringUtil.isNullToString(params.get("groupCode")));

			params.put("empSeq", EgovStringUtil.isNullToString(loginVO.getUniqId()));

			itemManageDAO.ItemCodeGroupDetailCodeInsert(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeGroupDetailCodeInsert");

		return result;
	}
	
	/* 생성 - 외부코드 생성 */
	public Map<String, Object> ItemExternalCodeInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemExternalCodeInsert");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("code", EgovStringUtil.isNullToString(params.get("code")));
			params.put("codeName", EgovStringUtil.isNullToString(params.get("codeName")));
			params.put("codeExplanation", EgovStringUtil.isNullToString(params.get("codeExplanation")));
			params.put("dbType", EgovStringUtil.isNullToString(params.get("dbType")));
			params.put("dbName", EgovStringUtil.isNullToString(params.get("dbName")));
			params.put("dbAddress", EgovStringUtil.isNullToString(params.get("dbAddress")));
			params.put("dbID", EgovStringUtil.isNullToString(params.get("dbID")));
			params.put("dbPW", EgovStringUtil.isNullToString(params.get("dbPW")));
			params.put("dbCode", EgovStringUtil.isNullToString(params.get("dbCode")));
			params.put("dbCodeName", EgovStringUtil.isNullToString(params.get("dbCodeName")));
			params.put("outputForm", EgovStringUtil.isNullToString(params.get("outputForm")));
			params.put("outputFormEn", EgovStringUtil.isNullToString(params.get("outputFormEn")));
			params.put("outputFormJp", EgovStringUtil.isNullToString(params.get("outputFormJp")));
			params.put("outputFormCn", EgovStringUtil.isNullToString(params.get("outputFormCn")));
			params.put("searchCode", EgovStringUtil.isNullToString(params.get("searchCode")));
			params.put("queryArea", EgovStringUtil.isNullToString(params.get("queryArea")));
			params.put("selectMode", EgovStringUtil.isNullToString(params.get("selectMode")));
			params.put("returnCode", EgovStringUtil.isNullToString(params.get("returnCode")));
			params.put("returnCodeEn", EgovStringUtil.isNullToString(params.get("returnCodeEn")));
			params.put("returnCodeJp", EgovStringUtil.isNullToString(params.get("returnCodeJp")));
			params.put("returnCodeCn", EgovStringUtil.isNullToString(params.get("returnCodeCn")));
			params.put("returnCodeOutputForm", EgovStringUtil.isNullToString(params.get("returnCodeOutputForm")));
			params.put("returnCodeOutputFormEn", EgovStringUtil.isNullToString(params.get("returnCodeOutputFormEn")));
			params.put("returnCodeOutputFormJp", EgovStringUtil.isNullToString(params.get("returnCodeOutputFormJp")));
			params.put("returnCodeOutputFormCn", EgovStringUtil.isNullToString(params.get("returnCodeOutputFormCn")));
			params.put("useYN", EgovStringUtil.isNullToString(params.get("useYN")));
			
			params.put("popupWidthSize", EgovStringUtil.isNullToString(params.get("popupWidthSize")));
			params.put("popupHeightSize", EgovStringUtil.isNullToString(params.get("popupHeightSize")));
			params.put("callbackFuncName", EgovStringUtil.isNullToString(params.get("callbackFuncName")));
			params.put("url", EgovStringUtil.isNullToString(params.get("url")));
			
			itemManageDAO.ItemExternalCodeInsert(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemExternalCodeInsert");

		return result;
	}
	
	/* 수정 */
	/* 수정 - 항목수정*/
	public Map<String, Object> ItemCodeUpdate(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeUpdate");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("itemCode", EgovStringUtil.isNullToString(params.get("itemCode")));
			params.put("itemName", EgovStringUtil.isNullToString(params.get("itemName")));
			params.put("itemDesc", EgovStringUtil.isNullToString(params.get("itemDesc")));
			params.put("itemRange", EgovStringUtil.isNullToString(params.get("itemRange")));
			params.put("itemUseYN", EgovStringUtil.isNullToString(params.get("itemUseYN")));
			params.put("systemGubun", EgovStringUtil.isNullToString(params.get("systemGubun")));
			params.put("systemDefault", EgovStringUtil.isNullToString(params.get("systemDefault")));
			params.put("systemMulti", EgovStringUtil.isNullToString(params.get("systemMulti")));
			params.put("systemDisplay", EgovStringUtil.isNullToString(params.get("systemDisplay")));
			params.put("textLineCount", EgovStringUtil.isNullToString(params.get("textLineCount")));
			params.put("numberMaxVal", EgovStringUtil.isNullToString(params.get("numberMaxVal")));
			params.put("numberMinVal", EgovStringUtil.isNullToString(params.get("numberMinVal")));
			params.put("numberDecimalPoint", EgovStringUtil.isNullToString(params.get("numberDecimalPoint")));
			params.put("datetimeType", EgovStringUtil.isNullToString(params.get("datetimeType")));
			params.put("datetimeDateType", EgovStringUtil.isNullToString(params.get("datetimeDateType")));
			params.put("datetimeDefault1", EgovStringUtil.isNullToString(params.get("datetimeDefault1")));
			params.put("datetimeDefault2", EgovStringUtil.isNullToString(params.get("datetimeDefault2")));
			params.put("userDefineCodeType", EgovStringUtil.isNullToString(params.get("userDefineCodeType")));
			params.put("userDefineCodeKind", EgovStringUtil.isNullToString(params.get("userDefineCodeKind")));
			params.put("userDefineCodeDefault", EgovStringUtil.isNullToString(params.get("userDefineCodeDefault")));
			params.put("externalCodeKind", EgovStringUtil.isNullToString(params.get("externalCodeKind")));
			
			params.put("empSeq", loginVO.getUniqId());
			
			itemManageDAO.ItemCodeUpdate(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeUpdate");

		return result;
	}

	/* 수정 - 상세코드수정*/
	public Map<String, Object> ItemCodeGroupDetailCodeEdit(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeUpdate");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("detailCode", EgovStringUtil.isNullToString(params.get("detailCode")));
			params.put("detailCodeName", EgovStringUtil.isNullToString(params.get("detailCodeName")));
			params.put("detailCodeOrder", EgovStringUtil.isNullToString(params.get("detailCodeOrder")));
			params.put("groupCode", EgovStringUtil.isNullToString(params.get("groupCode")));

			params.put("empSeq", EgovStringUtil.isNullToString(loginVO.getUniqId()));
			
			itemManageDAO.ItemCodeGroupDetailCodeEdit(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeUpdate");

		return result;
	}
	
	/* 수정 - 상세코드수정*/
	public Map<String, Object> ItemExternalCodeEdit(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemExternalCodeEdit");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("code", EgovStringUtil.isNullToString(params.get("code")));
			params.put("codeName", EgovStringUtil.isNullToString(params.get("codeName")));
			params.put("codeExplanation", EgovStringUtil.isNullToString(params.get("codeExplanation")));
			params.put("dbType", EgovStringUtil.isNullToString(params.get("dbType")));
			params.put("dbName", EgovStringUtil.isNullToString(params.get("dbName")));
			params.put("dbAddress", EgovStringUtil.isNullToString(params.get("dbAddress")));
			params.put("dbID", EgovStringUtil.isNullToString(params.get("dbID")));
			params.put("dbPW", EgovStringUtil.isNullToString(params.get("dbPW")));
			params.put("dbCode", EgovStringUtil.isNullToString(params.get("dbCode")));
			params.put("dbCodeName", EgovStringUtil.isNullToString(params.get("dbCodeName")));
			params.put("outputForm", EgovStringUtil.isNullToString(params.get("outputForm")));
			params.put("outputFormEn", EgovStringUtil.isNullToString(params.get("outputFormEn")));
			params.put("outputFormJp", EgovStringUtil.isNullToString(params.get("outputFormJp")));
			params.put("outputFormCn", EgovStringUtil.isNullToString(params.get("outputFormCn")));
			params.put("searchCode", EgovStringUtil.isNullToString(params.get("searchCode")));
			params.put("queryArea", EgovStringUtil.isNullToString(params.get("queryArea")));
			params.put("selectMode", EgovStringUtil.isNullToString(params.get("selectMode")));
			params.put("returnCode", EgovStringUtil.isNullToString(params.get("returnCode")));
			params.put("returnCodeEn", EgovStringUtil.isNullToString(params.get("returnCodeEn")));
			params.put("returnCodeJp", EgovStringUtil.isNullToString(params.get("returnCodeJp")));
			params.put("returnCodeCn", EgovStringUtil.isNullToString(params.get("returnCodeCn")));
			params.put("returnCodeOutputForm", EgovStringUtil.isNullToString(params.get("returnCodeOutputForm")));
			params.put("returnCodeOutputFormEn", EgovStringUtil.isNullToString(params.get("returnCodeOutputFormEn")));
			params.put("returnCodeOutputFormJp", EgovStringUtil.isNullToString(params.get("returnCodeOutputFormJp")));
			params.put("returnCodeOutputFormCn", EgovStringUtil.isNullToString(params.get("returnCodeOutputFormCn")));
			params.put("useYN", EgovStringUtil.isNullToString(params.get("useYN")));
			
			params.put("popupWidthSize", EgovStringUtil.isNullToString(params.get("popupWidthSize")));
			params.put("popupHeightSize", EgovStringUtil.isNullToString(params.get("popupHeightSize")));
			params.put("callbackFuncName", EgovStringUtil.isNullToString(params.get("callbackFuncName")));
			params.put("url", EgovStringUtil.isNullToString(params.get("url")));
		
			itemManageDAO.ItemExternalCodeEdit(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemExternalCodeEdit");

		return result;
	}
	
	/* 수정 - 그룹코드 수정*/
	public Map<String, Object> ItemCodeGroupUpdate(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeGroupUpdate");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("groupCode", EgovStringUtil.isNullToString(params.get("groupCode")));
			params.put("groupName", EgovStringUtil.isNullToString(params.get("groupName")));
			params.put("authGubun", EgovStringUtil.isNullToString(params.get("authGubun")));
			params.put("useYN", EgovStringUtil.isNullToString(params.get("useYN")));

			params.put("empSeq", EgovStringUtil.isNullToString(loginVO.getUniqId()));
			
			itemManageDAO.ItemCodeGroupUpdate(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeGroupUpdate");

		return result;
	}
	
	/* 삭제 */
	/* 삭제 - 항목 삭제 */
	public Map<String, Object> ItemCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemCodeDelete");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			String paramsInfo = params.get("itemCodeArray").toString();
			
			JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
					.toJSON(paramsInfo));
			
			JSONArray itemCodeArray = jsonObject.getJSONArray("itemCodeArray");
			
			/* 초기값 정의 */
			//params.put("itemCode", EgovStringUtil.isNullToString(params.get("itemCode")));

			for(int i=0; i<itemCodeArray.size(); i++) {
				JSONObject itemCodeInfo = itemCodeArray.getJSONObject(i);
				params.put("itemCode", itemCodeInfo.get("itemCode").toString());
				itemManageDAO.ItemCodeDelete(params);
			}
			
			
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemCodeDelete");

		return result;
	}
	
	/* 삭제 - 그룹코드 삭제 */
	public Map<String, Object> ItemGroupCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemGroupCodeDelete");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			String paramsInfo = params.get("groupCodeArray").toString();
			
			JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
					.toJSON(paramsInfo));
			
			JSONArray groupCodeArray = jsonObject.getJSONArray("groupCodeArray");
			
			/* 초기값 정의 */
			//params.put("groupCode", EgovStringUtil.isNullToString(params.get("groupCode")));

			for(int i=0; i<groupCodeArray.size(); i++) {
				JSONObject groupCodeInfo = groupCodeArray.getJSONObject(i);
				params.put("groupCode", groupCodeInfo.get("groupCode").toString());
				itemManageDAO.ItemGroupCodeDelete(params);
			}
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemGroupCodeDelete");

		return result;
	}
	
	/* 삭제 - 외부코드 삭제 */
	public Map<String, Object> ItemExternalCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemExternalCodeDelete");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("externalCode", EgovStringUtil.isNullToString(params.get("externalCode")));
			
			itemManageDAO.ItemExternalCodeDelete(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemGroupCodeDelete");

		return result;
	}
	
	/* 삭제 - 상세코드 삭제 */
	public Map<String, Object> ItemDetailCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> ItemDetailCodeDelete");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			/* 초기값 정의 */
			params.put("groupCode", EgovStringUtil.isNullToString(params.get("groupCode")));
			params.put("detailCode", EgovStringUtil.isNullToString(params.get("detailCode")));

			itemManageDAO.ItemDetailCodeDelete(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> ItemDetailCodeDelete");

		return result;
	}
	
	/* 기타(공통) */
	/* 외부코드 정보 가져오기 */
	public Map<String, Object> getExternalCodeInfo(Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> getExternalCodeInfo");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ params.toString());
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try {
			result = itemManageDAO.getExternalCodeInfo(params);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ result.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> getExternalCodeInfo");

		return result;
	}
	
	/* [조회] DB 커넥션 후 데이터 가져오기 */
	public List<Map<String, Object>> getExternalCodeList(Map<String, Object> externalCodeInfo) throws Exception {
		LOG.debug("+ [ItemManage] INFO - ItemManageService >> getExternalCodeList");
		LOG.debug("+ [ItemManage] INFO - Map<String, Object> params >> "
				+ externalCodeInfo.toString());

		Map<String, Object> result = new HashMap<String,Object>();
		List<Map<String, Object>> queryResult = new ArrayList<Map<String, Object>>();
		
		
		String query = externalCodeInfo.get("query").toString().replace("\n", " ").replace("\r", " ");
		String sSearchText = externalCodeInfo.get("sSearchText").toString();
		String search = externalCodeInfo.get("search") == null ? "" : externalCodeInfo.get("search").toString();
		
		if(externalCodeInfo.get("search") != null && !externalCodeInfo.get("search").equals("")) {
			if(sSearchText.split("▥").length == search.split(",").length) {
	            String[] arrSearchCode = search.split(",");
	            String[] arrSearchText = sSearchText.split("▥");
	
	            for (int i = 0; i < arrSearchCode.length; i++) {
	                 String tmpCode = "▥" + arrSearchCode[i] + "▥";
	                 query = query.replace(tmpCode, arrSearchText[i]);
	            }
	        }
		}
		
		try {
			LOG.debug("+ [ItemManage] INFO - ItemManageService >> getExternalCodeList >> 외부시스템 데이터 커넥션,데이터 가져오기 [Start]");

			String driverMssql = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
			String driverMysql = "com.mysql.jdbc.Driver";
			String driverOracle = "oracle.jdbc.driver.OracleDriver";
			
			String serverType = "";
			String serverIP = externalCodeInfo.get("servername").toString();
			String serverDB = externalCodeInfo.get("databasename").toString();
			String serverID = externalCodeInfo.get("userid").toString();
			String serverPW = externalCodeInfo.get("password").toString();
			
			if(externalCodeInfo != null) {
				if(externalCodeInfo.get("dbmsType").equals("0")) {
					serverType = "mysql";
				} else if(externalCodeInfo.get("dbmsType").equals("1")) {
					serverType = "oracle";
				} else if(externalCodeInfo.get("dbmsType").equals("2")) {
					serverType = "mssql";
				}
			}
			
			//DB별 url 셋팅
			String urlMssql = "jdbc:sqlserver://"+serverIP+";databasename="+serverDB;
			String urlMysql = "jdbc:mysql://"+serverIP+"/"+serverDB;
			String urlOracle = "jdbc:oracle:thin:@"+serverIP;
			
			String driver = "";
			String url = "";

			//Mssql
			if(serverType.equals("mssql")){
				driver = driverMssql;
				url = urlMssql;
			}
			
			//Mysql, Maria
			else if(serverType.equals("mysql") || serverType.equals("mariadb")){
				driver = driverMysql;
				url = urlMysql;
			}
			
			//Oracle
			else if(serverType.equals("oracle")){
				driver = driverOracle;
				url = urlOracle;
			}
			
			conVo.setDatabaseType(serverType);
			conVo.setDriver(driver);
			conVo.setUrl(url);
			conVo.setUserId(serverID);
			conVo.setPassWord(serverPW);
			
			Map<String, Object> externalQuery = new HashMap<String, Object>();
			
			externalQuery.put("query", query);
			
			queryResult = itemManageDAO.getExternalCodeList(conVo, externalQuery);

			result.put("result", 1);	//접속 성공.
			LOG.debug("+ [ItemManage] INFO - ItemManageService >> getExternalCodeList >> 외부시스템 데이터 커넥션,데이터 가져오기 [END]");
		} catch (Exception e) {
			result.put("result", -1);	//접속 실패.
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("+ [ItemManage] INFO - Map<String, Object> result >> "
				+ queryResult.toString());
		LOG.debug("- [ItemManage] INFO - ItemManageService >> getExternalCodeList");

		return queryResult;
	}
	
	/* DB커넥션 정보 */
    @SuppressWarnings("unused")
	private static DataSource getDataSource(Map<String, Object> params) {
    	// Maria는 mysql driver, url로 사용.
		String driverMssql = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String driverMysql = "com.mysql.jdbc.Driver";
		String driverOracle = "oracle.jdbc.driver.OracleDriver";
		
		String serverType = "";
		String serverIP = params.get("servername").toString();
		String serverDB = params.get("databasename").toString();
		String serverID = params.get("userid").toString();
		String serverPW = params.get("password").toString();
		
		
		if(params != null) {
			if(params.get("dbmsType").equals("0")) {
				serverType = "mysql";
			} else if(params.get("dbmsType").equals("1")) {
				serverType = "oracle";
			} else if(params.get("dbmsType").equals("2")) {
				serverType = "mssql";
			}
		}
		
		//DB별 url 셋팅
		String urlMssql = "jdbc:sqlserver://"+serverIP+";databasename="+serverDB;
		String urlMysql = "jdbc:mysql://"+serverIP+"/"+serverDB;
		String urlOracle = "jdbc:oracle:thin:@"+serverIP;
		
		String driver = "";
		String url = "";
		
		//Mssql
		if(serverType.equals("mssql")){
			driver = driverMssql;
			url = urlMssql;
		}
		
		//Mysql, Maria
		else if(serverType.equals("mysql") || serverType.equals("mariadb")){
			driver = driverMysql;
			url = urlMysql;
		}
		
		//Oracle
		else if(serverType.equals("oracle")){
			driver = driverOracle;
			url = urlOracle;
		}
 
		DataSource dataSource = new PooledDataSource(driver, url, serverID, serverPW);
        return dataSource;
    }

    
    /* [조회] 그룹 코드 상세 조회 */
	@Override
	public Map<String, Object> getCodeGrpInfo(Map<String, Object> params) {
		Map<String, Object> result = itemManageDAO.getCodeGrpInfo(params);
		return result;
	}
}
