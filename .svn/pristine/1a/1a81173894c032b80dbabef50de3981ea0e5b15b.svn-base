package neos.cmm.systemx.orgchart.service;

import java.util.List;
import java.util.Map;

import neos.cmm.systemx.orgchart.OrgChartTree;

public interface OrgChartService {
	public Map<String,Object> getGroupInfo(Map<String, Object> paramMap);
	
	/**
	 * 회사 다국어 가져오기
	 * @param compMap
	 * @return
	 */
	public List<Map<String, Object>> getCompLangList(Map<String, Object> compMap);
	
	/**
	 * 그룹 다국어 가져오기
	 * @param compMap
	 * @return
	 */
	public List<Map<String, Object>> getGroupLangList(Map<String, Object> groupMap);
	
//	/**
//	 * 권한 부서 리스트 가져오기
//	 * @param String
//	 * @return
//	 */
//	public List<Map<String, Object>> SelectAuthDeptList(Map<String, Object> paramMap);
	
	
	
	public List<Map<String,Object>> selectUserPositionList(Map<String, Object> paramMap) throws Exception;

	/**
	 * 회사, 사업장, 부서 트리구조 리스트 조회
	 * @param groupMap
	 * @return
	 */
	public List<Map<String, Object>> selectCompBizDeptList(Map<String, Object> groupMap);
	/**
	 * 회사, 사업장, 부서 트리구조 리스트 조회 (관리자)
	 * @param groupMap
	 * @return
	 */
	public List<Map<String, Object>> selectCompBizDeptListAdmin(Map<String, Object> groupMap);

	public OrgChartTree getOrgChartTree(List<Map<String, Object>> list, Map<String, Object> params);

	public List<Map<String, Object>> getOrgChartTreeJT(List<Map<String, Object>> list, Map<String, Object> params);
	
	public List<Map<String, Object>> getdeptManageOrgChartListJT(Map<String, Object> params);
	
	public List<Map<String, Object>> getEmpSelectedList(Map<String, Object> params);

	public List<Map<String, Object>> getDeptSelectedList(Map<String, Object> params);
	
	public List<Map<String, Object>> getAddrGroupList(Map<String, Object> params);

	public List<Map<String, Object>> getAddrList(Map<String, Object> params);

	public List<Map<String, Object>> getEmpList(Map<String, Object> params);
	
	public List<Map<String, Object>> getCompBizDeptList(Map<String, Object> params);
	
	public List<Map<String, Object>> getCompBizDeptListAdmin(Map<String, Object> params);

	
	public List<Map<String, Object>> GetUserDeptProfileListForDept(Map<String, Object> param);
	public List<Map<String, Object>> GetUserDeptProfileListForDeptAttend(Map<String, Object> param);
	public List<Map<String, Object>> GetFilterdUserDeptProfileListForDept(Map<String, Object> param);
    public List<Map<String, Object>> GetFilterdUserDeptProfileListForDeptAttend(Map<String, Object> params);
	
	public List<Map<String, Object>> GetUserDeptList(Map<String, Object> params);
	public List<Map<String, Object>> GetUserDeptListJSTree(List<Map<String, Object>> list,Map<String, Object> params);
	public List<Map<String, Object>> GetUserDeptPathList(Map<String, Object> params);
	public List<Map<String, Object>> GetSelectedUserDeptProfileListForDept(Map<String, Object> param);

	public List<Map<String, Object>> getCompList(Map<String, Object> params);

	public List<Map<String, Object>> GetOrgFullList(Map<String, Object> params);

	public String GetOrgMyDeptPath(Map<String, Object> params);
	public String GetOrgMyDeptPathAdmin(Map<String, Object> params);
	
	/*
	 * 부서조회 검색 OrgList(회사사용유무 확인, 부서사용유무 확인안함)
	 */
	public List<Map<String, Object>> GetSearchDeptListAdmin(Map<String, Object> param);
	
	
	public List<Map<String, Object>> getCompBizDeptListForAdmin(Map<String, Object> params);
	public List<Map<String, Object>> getOrgChartTreeForAdmin(List<Map<String, Object>> list, Map<String, Object> params);

	public List<Map<String, Object>> getUserInfoList(Map<String, Object> params);
	public List<Map<String, Object>> getUserFormList(Map<String, Object> params);
	
	public List<Map<String, Object>> GetBizProfileListForBiz(Map<String, Object> params);
	public List<Map<String, Object>> GetFilterdBizProfileListForBiz(Map<String, Object> param);
	public List<Map<String, Object>> GetSelectedBizProfileListBiz(Map<String, Object> param);

	
}
