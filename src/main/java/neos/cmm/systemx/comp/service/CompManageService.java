package neos.cmm.systemx.comp.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public interface CompManageService {
	
	/**
	 * 회사정보 리스트 조회
	 * @param params
	 * @return
	 */
	public List<Map<String,Object>> getCompList(Map<String,Object> params);
	
	/**
	 * 회사기본정보(t_co_comp)
	 * @param params
	 * @return
	 */
	public Map<String,Object> getComp(Map<String,Object> params);
	/**
	 * 회사기본정보(t_co_comp) 관리자
	 * @param params
	 * @return
	 */
	public Map<String, Object> getCompAdmin(Map<String, Object> paramMap);
	
	/**
	 * 회사다국어정보(t_co_comp_multi)
	 * @param params
	 * @return
	 */
	public Map<String,Object> getCompMulti(Map<String,Object> params);
	
	/**
	 * 회사기본정보 업데이트
	 * @param params
	 * @return
	 */
	public Map<String,Object> getCompMultiLang(Map<String,Object> params);
	
	/**
	 * 회사기본정보 업데이트
	 * @param params
	 * @return
	 */	
	public void updateComp(Map<String,Object> params);
	
	/**
	 * 회사 부가정보 업데이트
	 * @param params
	 * @return
	 */
	public void updateCompMulti(Map<String,Object> params);
	
	
	/**
	 * 회사 다국어 저장Multi
	 * @param map
	 */
	public void insertCompMulti(Map<String, Object> paramMap);
	

	/**
	 * 회사 다국어 저장
	 * @param map
	 */
	public void insertCompLang(Map<String, Object> map);

	/**
	 * 회사 다국어 업데이트
	 * @param paramMap
	 */
	public void updateCompLang(Map<String, Object> paramMap);

	/**
	 * 마스터 > 회사관리
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> getGroupCompList(Map<String, Object> params, PaginationInfo paginationInfo);

	/**
	 * 관리자가 갖고 있는 회사 리스트 조회
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, Object>> getCompListAuth(Map<String, Object> paramMap);
	
	
	public List<Map<String, Object>> getChildComp(Map<String, Object> paramMap);

	public void deleteComp(Map<String, Object> params);

	public void deleteCompMulti(Map<String, Object> params);

	public Integer getCompDeptExist(Map<String, Object> paramMap);

	public Map<String, Object> getErpConInfo_ac(Map<String, Object> params);

	public Map<String, Object> getErpConInfo_hr(Map<String, Object> params);

	public Map<String, Object> getErpConInfo_etc(Map<String, Object> params);

	public void dbConnectInfoSave(Map<String, Object> params);

	public void deleteDbConnectInfo(Map<String, Object> params);

	public void updateCompInfo(Map<String, Object> paramMap);

	public Map<String, Object> getCompSmsOption(Map<String, Object> params);

	public Map<String, Object> getOrgImg(Map<String, Object> params);

	public Map<String, Object> getTitle(Map<String, Object> params);

	public List<Map<String, Object>> getErpConList(Map<String, Object> params);

	public Map<String, Object> getErpEmpInfo(Map<String, Object> params);

	public void updateErpEmpInfo(Map<String, Object> params);

	public void insertErpEmpInfo(Map<String, Object> params);

	public List<Map<String, Object>> checkMessengerUseYn(Map<String, Object> params);

	public void dbConnectInfoDelete(Map<String, Object> params);

	public void deleteErpEmpInfo(Map<String, Object> params);

	public List<Map<String, Object>> getMyCompList(Map<String, Object> params);
	
	public String getBizSeq(Map<String, Object> params);

	public void setCompDomain(Map<String, Object> paramMap);	

	public void setBaseAlarm(Map<String, Object> paramMap);

	public void setBaseAlarmAdmin(Map<String, Object> paramMap);
	
	public void insertGrouppingComp(Map<String, Object> paramMap);

	public void deleteGrouppingComp(Map<String, Object> params);

	public void insertBizInfo(Map<String, Object> paramMap);

	public void insertBizMultiInfo(Map<String, Object> paramMap);

	public void deleteBizInfo(Map<String, Object> params);

	public void deleteBizMultiInfo(Map<String, Object> params);

	public Map<String, Object> getTeamWorkInfo(Map<String, Object> params);

	public void deleteErpCompInfo(Map<String, Object> params);

	public void insertErpCompInfo(Map<String, Object> params);

	public void updateErpEmpCheckWorkInfo(Map<String, Object> params);

	public void deleteMsgLinkInfo(Map<String, Object> params);

	public void setBaseDateInfo(Map<String, Object> para);

	public void updateCompEaType(Map<String, Object> params);

	public void deleteAuthCode(Map<String, Object> params);

	public void deleteAuthCodeMulti(Map<String, Object> params);

	public List<Map<String, Object>> getEmpErpCompList(Map<String, Object> params);

	public Map<String, Object> getCompMailUrl(Map<String, Object> params);

	public List<Map<String, Object>> getCompListGroupping(
			Map<String, Object> params);
}
