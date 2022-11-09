package api.orgchart.service;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import api.common.model.APIResponse;

public interface ApiOrgchartService {
	public void downloadOrgChart(HttpServletRequest request, HttpServletResponse response, String groupSeq) throws IOException;
	public String[] orgChartEidtYn(HttpServletRequest request, HttpServletResponse response, String groupSeq, String orgChartDt, String reqType) throws IOException;
	/**
	 * 그룹  정보 리스트
	 * @param params
	 * @return
	 */
	public Object selectGroupList(Map<String,Object> paramMap);

	/**
	 * 회사/사업장/부서 목록 조회
	 * @param paramMap
	 * @return
	 */
	public Object selectCompBizDeptList(Map<String,Object> paramMap);

	/**
	 * 회사/사업장/부서 목록 조회
	 * @param paramMap
	 * @return
	 */
	public Object selectEmpList(HttpServletRequest request, Map<String,Object> paramMap);

	/**
	 * 조직도 동기화
	 * @param groupSeq
	 */
	public int pollingOrgSync(String groupSeq, String isEventSend, boolean foceReq);

	/**
	 * 사용자 사번 등록
	 * @param paramMap
	 * @return
	 */
	public Object insertEmpNum(Map<String,Object> paramMap);
	public void downloadOrgChartZip(HttpServletRequest request, HttpServletResponse response, String groupSeq) throws IOException;

    /**
     * DERP > UC 조직도 연동
     * @param paramMap
     * @return
     */
	public APIResponse ebpSyncOrgchart(Map<String, Object> paramMap);
    public APIResponse ebpSyncOrgchartAll(Map<String, Object> paramMap);
    public APIResponse ebpOrgAdapter(String str, Map<String, Object> paramMap);
    
//    public APIResult erp10SyncTestapi(Map<String, Object> paramMap);

    public String ebpFindGempnoToLoginid(String loginId);
    
    
    /**
     * 최초 ERP10 연동 이후  알파에서 해당컬럼 변경하였는데 연동 시 빈스트링 넘어오는 컬럼 or 연동 처리되지않는 컬럼들을 제거
     * @param compList
     * @param removeColumn
     */
    public void removeNonInterlockingColumns(Map<String, Object> compList, String removeColumn);
}
