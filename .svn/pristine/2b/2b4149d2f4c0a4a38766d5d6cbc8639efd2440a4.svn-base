package neos.cmm.systemx.dept.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.dept.service.DeptManageService;

@Service("DeptManageService")
public class DeptManageServiceImpl implements DeptManageService{
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectDeptInfo(Map<String, Object> params) {
		//return (Map<String, Object>) commonSql.select("DeptManage.selectDept", params);
		return (Map<String, Object>) commonSql.select("DeptManage.getDeptBizInfo", params);
	}
	
	@Override
	public Map<String, Object> selectDeptInfoLangMulti(Map<String, Object> params) {
		//return (Map<String, Object>) commonSql.select("DeptManage.selectDept", params);
		return (Map<String, Object>) commonSql.select("DeptManage.getDeptBizInfoLangMulti", params);
	}	

	@Override
	public void insertDept(Map<String, Object> paramMap) {
		commonSql.insert("DeptManage.insertDept", paramMap);
	}

	@Override
	public List<Map<String, Object>> getParentDept(Map<String, Object> paramMap) {
		return commonSql.list("DeptManage.selectParentDept", paramMap);
	}

	@Override
	public void insertDeptMulti(Map<String, Object> paramMap) {
		commonSql.insert("DeptManage.insertDeptMulti", paramMap);		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> selectCompSortList(Map<String, Object> paramMap) {
		return commonSql.list("DeptManage.selectCompSortList", paramMap);
	}

	@Override
	public void insertCompEmpSort(Map<String, Object> paramMap) {
		commonSql.insert("DeptManage.insertCompEmpSort", paramMap);		
	}

	@Override
	public List<Map<String, Object>> selectCompDeptList(Map<String, Object> paramMap) {
		return commonSql.list("DeptManage.selectCompDeptList", paramMap);
	}

	@Override
	public void updateDeptOrderNum(Map<String, Object> updateList) {
		commonSql.update("DeptManage.updateDeptOrderNum", updateList);
	}

	@Override
	public void updateDeptParent(Map<String, Object> paramMap) {
		return;
	}

	@Override
	public Integer getDeptExist(Map<String, Object> paramMap) {
		return (Integer) commonSql.select("DeptManage.getDeptExist", paramMap);
	}

	@Override
	public Integer getEmpExist(Map<String, Object> paramMap) {
		return (Integer) commonSql.select("DeptManage.getEmpExist", paramMap);
	}

	@Override
	public void deleteDept(Map<String, Object> params) {
		commonSql.delete("DeptManage.deleteDept", params);		
	}

	@Override
	public void deleteDeptMulti(Map<String, Object> params) {
		commonSql.delete("DeptManage.deleteDeptMulti", params);		
	}
	
	public Map<String, Object> checkExcelData(Map<String, Object> eData) {
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		int cnt = 0;
		int formAbjust = 0;
		
		for (Map.Entry<String, Object> entry:eData.entrySet()) {
	    	if (entry.getKey() != "num") {
	    		cnt++;
	    	}
	    }
		
		if((cnt % 3) != 0){
			formAbjust = 8;
		}
		
		resultMap.put("batchSeq", eData.get("batchSeq"));
		resultMap.put("groupSeq", eData.get("groupSeq"));
		resultMap.put("compSeq", eData.get("C0"));
//		resultMap.put("deptSeq", eData.get("C"+(cnt-4-formAbjust)));
		resultMap.put("seq", eData.get("num"));

		String dName = "";
		String dType = "";
		String dPath = "";
		String pSeq = "";
		
		String deptSeq = "";
		String[] ds = new String[(cnt-6-formAbjust)/3];
		
		
		for (int i = 1 ; i <= (cnt-6-formAbjust)/3 ; i++) {			
			String ds2 = (String) eData.get("C"+(i*3-1));
			ds[i-1] = ds2;
			if(!ds2.equals("")){
				deptSeq = ds2;
				dName = (String) eData.get("C"+(i*3));
				dType = (String) eData.get("C"+(i*3+1));
			}			
			if (i == 1){
				dPath = (String) eData.get("C"+(i*3-1));
			}
			else {
				if (eData.get("C"+(i*3-1)) != "") {
					dPath += "|" + eData.get("C"+(i*3-1));
				}
			}
		}
		
		int idx = 0;
		for(int i=0;i<ds.length;i++) {
			if(!ds[i].equals("")) {
				if(i == 0) {
					idx = 0;
				}
				else {
					idx = i - 1;
				}
			}				
		}
		pSeq = ds[idx];
		
		resultMap.put("deptSeq", deptSeq);
		resultMap.put("deptName", dName);
		resultMap.put("deptType", dType);
		resultMap.put("deptPath", dPath);
		resultMap.put("parentDeptSeq", pSeq);
		
		resultMap.put("deptNameEn", eData.get("C"+(cnt-3-formAbjust)));
		resultMap.put("deptNameJp", eData.get("C"+(cnt-2-formAbjust)));
		resultMap.put("deptNameCn", eData.get("C"+(cnt-1-formAbjust)));
		
		if(formAbjust != 0){
			resultMap.put("deptNickname", eData.get("C"+(cnt+0-formAbjust)));
			resultMap.put("orderNum", eData.get("C"+(cnt+1-formAbjust)));
			resultMap.put("zipCode", eData.get("C"+(cnt+2-formAbjust)));
			resultMap.put("addr", eData.get("C"+(cnt+3-formAbjust)));
			resultMap.put("detailAddr", eData.get("C"+(cnt+4-formAbjust)));
			resultMap.put("innerReceiveYn", eData.get("C"+(cnt+5-formAbjust)));
			resultMap.put("standardCode", eData.get("C"+(cnt+6-formAbjust)));
			resultMap.put("senderName", eData.get("C"+(cnt+7-formAbjust)));			
		}else{
			resultMap.put("deptNickname", "");
			resultMap.put("orderNum", eData.get("num"));
			resultMap.put("zipCode", "");
			resultMap.put("addr", "");
			resultMap.put("detailAddr", "");
			resultMap.put("innerReceiveYn", "Y");
			resultMap.put("standardCode", "");
			resultMap.put("senderName", "");			
		}


		return resultMap;
	}

	@Override
	public List<Map<String, Object>> getDeptBatchInfo(Map<String, Object> params) {
		return commonSql.list("DeptManage.getDeptBatchInfo", params);
	}

	@Override
	public Map<String, Object> getDeptInfo(Map<String, Object> param) {
		return (Map<String, Object>) commonSql.select("DeptManage.getDeptInfo", param);
	}

	@Override
	public List<Map<String, Object>> getSelectedDeptBatchInfo(Map<String, Object> param) {
		return commonSql.list("DeptManage.getSelectedDeptBatchInfo", param);
	}

	@Override
	public Map<String, Object> getDeptSeqList(Map<String, Object> param) {
		return (Map<String, Object>) commonSql.select("DeptManage.getDeptSeqList", param);
	}

	@Override
	public void deleteDeptBatchInfo(Map<String, Object> param) {		
		commonSql.delete("DeptManage.deleteDeptBatchInfo", param);
	}

	@Override
	public List<Map<String, Object>> getDeptBatchPreviewList(Map<String, Object> params) {
		return commonSql.list("OrgChart.selectOrgBatchPreviewList", params);
	}

	@Override
	public List<Map<String, Object>> getChildDeptInfoList(Map<String, Object> mp) {
		return commonSql.list("DeptManage.getChildDeptInfoList", mp);
	}

	@Override
	public void updateChildDeptInfo(Map<String, Object> map) {
		commonSql.update("DeptManage.updateChildDeptInfo", map);		
	}

	@Override
	public void updateChildDeptMultiInfo(Map<String, Object> map) {
		commonSql.update("DeptManage.updateChildDeptMultiInfo", map);		
	}

	@Override
	public void updateChildDeptLevelInfo(Map<String, Object> paramMap) {
		commonSql.update("DeptManage.updateChildDeptLevelInfo", paramMap);	
	}

	
	
	@Override
	public Map<String, Object> selectDeptBizInfo(Map<String, Object> params) {
		if(params.get("gbnOrg").toString().equals("b")) {
			return (Map<String, Object>) commonSql.select("DeptManage.selectBizInfo", params);
		}
		else {
			return (Map<String, Object>) commonSql.select("DeptManage.selectDeptInfo", params);
		}
	}

	@Override
	public Map<String, Object> selectDeptBizInfoLangMulti(Map<String, Object> params) {
		if(params.get("gbnOrg").toString().equals("b")) {
			return (Map<String, Object>) commonSql.select("DeptManage.selectBizMultiInfo", params);
		}
		else {
			return (Map<String, Object>) commonSql.select("DeptManage.selectDeptMultiInfo", params);
		}
	}

	@Override
	public Integer getDeptBizExist(Map<String, Object> params) {
		return (Integer) commonSql.select("DeptManage.getDeptBizExist", params);
	}
	
}
