package neos.cmm.erp.orgchart.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public interface ErpOrgchartSyncService {

	Map<String, Object> selectErpSyncDetailList(Map<String, Object> params, PaginationInfo paginationInfo);

	List<Map<String, Object>> selectErpGwJobCodeList(Map<String, Object> params);

	/**
	 * ERP - GW 재직구분 맵핑 정보 조회
	 * @param erpWorkCodeList ERP 재직구분 리스트
	 * @param params
	 * @return
	 */
	List<Map<String, Object>> selectErpSyncWorkCodeList(List<Map<String, Object>> erpWorkCodeList,
			Map<String, Object> params);

	/**
	 * 재직구분 공통코드에서 조회
	 * @param params
	 * @return
	 */
	List<Map<String, Object>> selectErpEmpWorkCodeList(Map<String, Object> params);
	
	List<Map<String, Object>> selectCommonCodeList(Map<String, Object> params);

	/**
	 * 상용직 동기화 데이터 조회
	 * @param regularCodeList
	 * @param params
	 * @return
	 */
	List<Map<String, Object>> selectErpSyncJobCodeList(List<Map<String, Object>> codeList,
			Map<String, Object> params);

	void deleteErpSyncCodeList(Map<String, Object> params);

	void insertErpSyncCodeList(Map<String, Object> params);

	List<Map<String, Object>> getErpdeptOrgchartListJT(List<Map<String, Object>> list, Map<String, Object> pathMap, Map<String, Object> params);
	
	List<Map<String, Object>> getGwdeptOrgchartListJT(Map<String, Object> params);

	List<Map<String, Object>> selectErpSyncDetailList(Map<String, Object> params);

	List<Map<String, Object>> getErpdeptOrgchartTestList(HttpServletRequest request, List<Map<String, Object>> orgList, Map<String, Object> params);

	List<Map<String, Object>> insertErpdeptOrgchartList(HttpServletRequest request, List<Map<String, Object>> orgList,
			Map<String, Object> params, Map<String, Object> params2);

	List<Map<String, Object>> setTempdeptOrgchart(Map<String, Object> params);

	List<Map<String, Object>> getErpdeptOrgchartTempListJT(Map<String, Object> params);

	List<Map<String, Object>> setTempEmp(Map<String, Object> params);

	Map<String, Object> selectTmpEmpList(Map<String, Object> params, PaginationInfo paginationInfo);

	Map<String, Object> setBiz(Map<String, Object> params);

	Map<String, Object> setDept(Map<String, Object> params);

	Map<String, Object> setEmp(Map<String, Object> params);

	Map<String, Object> initOrgchart(Map<String, Object> params);

	Map<String, Object> setEmpComp(Map<String, Object> params);

	void setErpSync(Map<String, Object> params);

	void updateErp(Map<String, Object> params);

	void setCompDutyPosition(Map<String, Object> params);

	List<Map<String, Object>> selectSyncFailTmpEmpList(Map<String, Object> params);

	List<Map<String, Object>> selectSyncSuccessTmpEmpList(Map<String, Object> params);

	Map<String, Object> setDeptUpdate(Map<String, Object> params);

	Map<String, Object> setEmpUpdate(Map<String, Object> params);

	void insertErpSyncAutoList(Map<String, Object> params);
	
	List<Map<String, Object>> selectErpSyncAutoList(Map<String, Object> params);
	
	void updateErpSyncAutoList(Map<String, Object> params);
	
	List<Map<String, Object>> pollingOrgSyncAuto(String groupSeq) throws Exception;
	
	public Map<String, Object> getErpDbInfo(Map<String, Object> params);
	public Map<String, Object> getGerpDbInfo(Map<String, Object> params);
	
	public String getCmmOptionValue(String compSeq, String option);
	
	public Map<String, Object> setDeptInfoUpdate(Map<String, Object> params);
	
	public void deleteEmpDept(List<Map<String, Object>> params);
	
	public void insertAuthList(List<Map<String, Object>> params);
	
	public Map<String, Object> selectErpSyncResignParam(Map<String, Object> params);
	
	
	Map<String, Object> selectErpSyncCompDetailList(Map<String, Object> params, PaginationInfo paginationInfo);

	Map<String, Object> selectTmpCompList(Map<String, Object> params, PaginationInfo paginationInfo);

	List<Map<String, Object>> setTempComp(Map<String, Object> params);

	Map<String, Object> setComp(Map<String, Object> params);

	void setErpCompSync(Map<String, Object> params);

	void setErpCompList(Map<String, Object> params);
	
		
	public Map<String, Object> setEmpResign(Map<String, Object> params);
	
	List<Map<String, Object>> getErpCompList(Map<String, Object> resultMap);
	
	void updateLicenseValue(Map<String, Object> params);

	String erpSyncDutyPosiSaveProc(Map<String, Object> params);

	void setEmpOrderText(Map<String, Object> params);

	List<Map<String, Object>> selectSyncDutyPosiCodeList(Map<String, Object> params);

	String selectErpResignCodeStr(Map<String, Object> params);

	void setMainCompYn(Map<String, Object> params);

	void reSetWeddingDay(Map<String, Object> paramMap);

	void licenseCheck(Map<String, Object> params) throws Exception;
}
