package neos.cmm.systemx.dept.service;

import java.util.List;
import java.util.Map;

public interface DeptManageService {
	
	public Map<String,Object> selectDeptInfo(Map<String,Object> params);
	
	public Map<String,Object> selectDeptInfoLangMulti(Map<String,Object> params);

	public void insertDept(Map<String, Object> paramMap);

	public void insertDeptMulti(Map<String, Object> paramMap);
	
	public List<Map<String,Object>> selectCompSortList(Map<String,Object> paramMap);

	public void insertCompEmpSort(Map<String, Object> paramMap); 
	
	public List<Map<String,Object>> selectCompDeptList(Map<String,Object> paramMap);

	public void updateDeptOrderNum(Map<String, Object> updateList);

	public void updateDeptParent(Map<String, Object> paramMap);
	
	public Integer getDeptExist(Map<String, Object> paramMap);
	
	public Integer getEmpExist(Map<String, Object> paramMap);

	public void deleteDept(Map<String, Object> params);

	public void deleteDeptMulti(Map<String, Object> params);
	
	public List<Map<String, Object>> getParentDept(Map<String, Object> params);
	
	public Map<String,Object> checkExcelData(Map<String,Object> params);

	public List<Map<String, Object>> getDeptBatchInfo(Map<String, Object> params);

	public Map<String, Object> getDeptInfo(Map<String, Object> param);

	public List<Map<String, Object>> getSelectedDeptBatchInfo(Map<String, Object> param);
	
	public Map<String, Object> getDeptSeqList(Map<String, Object> param);

	public void deleteDeptBatchInfo(Map<String, Object> param);

	public List<Map<String, Object>> getDeptBatchPreviewList(Map<String, Object> params);

	public List<Map<String, Object>> getChildDeptInfoList(Map<String, Object> mp);

	public void updateChildDeptInfo(Map<String, Object> map);

	public void updateChildDeptMultiInfo(Map<String, Object> map);

	public void updateChildDeptLevelInfo(Map<String, Object> paramMap);

	public Map<String, Object> selectDeptBizInfo(Map<String, Object> params);

	public Map<String, Object> selectDeptBizInfoLangMulti(
			Map<String, Object> params);

	public Integer getDeptBizExist(Map<String, Object> params);
	
}
