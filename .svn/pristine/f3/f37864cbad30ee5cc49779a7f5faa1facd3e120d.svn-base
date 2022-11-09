package neos.cmm.systemx.dutyPosition.sercive.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.dutyPosition.sercive.DutyPositionManageService;
import neos.cmm.systemx.wehagoAdapter.service.wehagoAdapterService;
import neos.cmm.util.CommonUtil;

@Service("DutyPositionManageService")
public class DutyPositionManageServiceImpl implements DutyPositionManageService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource ( name = "wehagoAdapterService" )
	private wehagoAdapterService wehago;	

	/**
	 * 회사 직급직책 조회
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCompDutyPositionList(Map<String, Object> paramMap) {
		return commonSql.list("DutyPositionManage.selectCompDutyPositionList", paramMap);
	}

	/**
	 * 직급직책 리스트 (관리)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDutyPositionList(Map<String, Object> paramMap) {
		return commonSql.list("DutyPositionManage.getDutyPositionList", paramMap);
	}
	
	/**
	 * 직급직책 정보
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public Map<String, Object> getDutyPositionInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("DutyPositionManage.getDutyPositionInfo", paramMap);
	}
	
	/**
	 * 직급직책 다국어 정보
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public Map<String, Object> getDutyPositionSeqLangInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("DutyPositionManage.getDutyPositionSeqLangInfo", paramMap);
	}
	
	/**
	 * 직급직책 저장(insert, update)
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public Map<String, Object> insertDutyPosition(Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		Integer userCnt = 0;
		// 사용여부가(use_yn) Y => N 으로 변경될때  사용자 체크
		if(paramMap.get("useYn").equals("N")){  
			Map<String, Object> dpInfo = (Map<String, Object>) commonSql.select("DutyPositionManage.getDutyPositionInfo", paramMap);
			if(dpInfo != null && dpInfo.get("useYn").equals("Y")){
				userCnt = (Integer) commonSql.select("DutyPositionManage.getDutyPositionUserCnt", paramMap);
			}
		}
		
		if(userCnt > 0){
			result.put("msg", "1");
			return result;	
		}
		
		//정렬순서 공백 및 null 체크
		String orderNum = (String)paramMap.get("orderNum");
		if (EgovStringUtil.isEmpty(orderNum)){
			paramMap.put("orderNum", null);
		}
		commonSql.insert("DutyPositionManage.insertDutyPosition", paramMap);
		//사원부서정렬텍스트 업데이트 (t_co_emp_dept -> order_text)
		paramMap.put("isPositionDutyPage", "Y");
		commonSql.update("EmpDeptManage.updateEmpDeptOrderText", paramMap);
		
		
		if(!EgovStringUtil.isEmpty(paramMap.get("dpNameKr")+"")){
			paramMap.put("multilangCode", "kr");
			paramMap.put("dpName",paramMap.get("dpNameKr"));
			commonSql.insert("DutyPositionManage.insertDutyPositionMulti", paramMap);
		}
		
		if(!EgovStringUtil.isEmpty(paramMap.get("dpNameEn")+"")){
			paramMap.put("multilangCode", "en");
			paramMap.put("dpName",paramMap.get("dpNameEn"));
			commonSql.insert("DutyPositionManage.insertDutyPositionMulti", paramMap);
		}else{
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("dpSeq", paramMap.get("dpSeq"));
			para.put("langCode", "en");
			para.put("dpType", paramMap.get("dpType"));
			commonSql.delete("DutyPositionManage.delDutyPositionMulti",para);
		}
		
		if(!EgovStringUtil.isEmpty(paramMap.get("dpNameCn")+"")){		
			paramMap.put("multilangCode", "cn");
			paramMap.put("dpName",paramMap.get("dpNameCn"));
			commonSql.insert("DutyPositionManage.insertDutyPositionMulti", paramMap);
		}else{
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("dpSeq", paramMap.get("dpSeq"));
			para.put("langCode", "cn");
			para.put("dpType", paramMap.get("dpType"));
			commonSql.delete("DutyPositionManage.delDutyPositionMulti",para);
		}
		
		if(!EgovStringUtil.isEmpty(paramMap.get("dpNameJp")+"")){
			paramMap.put("multilangCode", "jp");
			paramMap.put("dpName",paramMap.get("dpNameJp"));
			commonSql.insert("DutyPositionManage.insertDutyPositionMulti", paramMap);
		}else{
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("dpSeq", paramMap.get("dpSeq"));
			para.put("langCode", "jp");
			para.put("dpType", paramMap.get("dpType"));
			commonSql.delete("DutyPositionManage.delDutyPositionMulti",para);
		}
		
		result.put("msg", "0");
		
		//위하고 조직도 연동 Sync
		wehago.wehagoInsertDutyPositionOneSync(paramMap.get("groupSeq").toString(), paramMap.get("compSeq").toString(), paramMap.get("dpSeq").toString(), paramMap.get("dpType").toString(), "I");
		
		return result;
		
	}
	
	/**
	 * 직급/직책을 삭제한다.
	 */
	@SuppressWarnings("deprecation")
	@Override
	public Map<String, Object> deleteDutyPosition(Map<String, Object> paramMap)throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		Integer userCnt = 0;
		
		try{
			userCnt = (Integer) commonSql.select("DutyPositionManage.getDutyPositionUserCnt", paramMap);

		}catch(Exception e){
			result.put("msg", "-1");	
		}

		if(userCnt > 0){ // 사용중인 user가 있는지 체크
			result.put("msg", "1");
			return result;
		}
		
		//위하고 조직도 연동 Sync
		wehago.wehagoInsertDutyPositionOneSync(paramMap.get("groupSeq").toString(), "", paramMap.get("dpSeq").toString(), paramMap.get("dpType").toString(), "D");

		commonSql.delete("DutyPositionManage.deleteDutyPositionMulti", paramMap);
		commonSql.delete("DutyPositionManage.deleteDutyPosition", paramMap);
		result.put("msg", "0");
		

		return result;
	}


	/**
	 * 코드 중복 체크 
	 */
	@SuppressWarnings("deprecation")
	@Override
	public Integer getDutyPositionSeqCheck(Map<String, Object> paramMap) throws Exception{
		Integer result = 0;
		try{
			result = (Integer) commonSql.select("DutyPositionManage.getDutyPositionSeqCheck", paramMap);

		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e);
		}
		
		return result;
	}






} 
