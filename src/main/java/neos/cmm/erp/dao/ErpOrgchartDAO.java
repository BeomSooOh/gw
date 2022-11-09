package neos.cmm.erp.dao;

import java.util.List;
import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public interface ErpOrgchartDAO {
	
	/**
	 * ERP 고용형태 코드 조회(직무/직군)
	 * @param params
	 * @return
	 */
	public List<Map<String,Object>> selectErpJobCodeList(Map<String,Object> params);

	/**
	 * ERP 재직구분 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectErpEmpWorkCodeList(Map<String, Object> params);

	public List<Map<String, Object>> selectErpDeptList(Map<String, Object> params);

	public List<Map<String, Object>> selectErpBizList(Map<String, Object> params);

	public List<Map<String, Object>> selectErpCompList(Map<String, Object> params);

	public List<Map<String, Object>> selectErpDeptPathList(Map<String, Object> params);

	/**
	 * ERP 현재시간 조회
	 * @return
	 */
	public String selectErpCurrentTime();

	public List<Map<String, Object>> selectErpEmpList(Map<String, Object> params);
	
	
	public Map<String, Object> selectErpEmpListOfPage(Map<String, Object> params, PaginationInfo paginationInfo);

	public void updateErpSyncGwUpdateDate(Map<String, Object> params);

	public List<Map<String, Object>> selectErpDutyCodeList(Map<String, Object> params);

	public List<Map<String, Object>> selectErpPositionCodeList(Map<String, Object> params);

	public void updateErpSyncFailGwUpdateDate(Map<String, Object> params);

	public void updateErpSyncEmpGwUpdateDate(Map<String, Object> params);
	
	/**
	 * ERP 커스텀
	 */
	public List<Map<String, Object>> selectErpCustom(Map<String, Object> params);

	/**
	 * ERP 회사 리스트
	 * @param params
	 * @param paginationInfo
	 * @return
	 */
	public Map<String, Object> selectErpCompListOfPage(Map<String, Object> params, PaginationInfo paginationInfo);
	
	public List<Map<String, Object>> selectErpProjectList(Map<String, Object> params);
	
	public List<Map<String, Object>> selectErpPartnerList(Map<String, Object> params);	
	
	public List<Map<String, Object>> selectErpDeptDeleteList(Map<String, Object> params);
	
	

	public void updateErpEmpGwUpdateDate(Map<String, Object> params);
}
