package neos.cmm.systemx.emp.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.vo.ConnectionVO;

public interface EmpManageService {
	
	public Map<String,Object> selectEmpInfo(Map<String,Object> params, PaginationInfo paginationInfo);
	
	public List<Map<String, Object>> selectEmpInfoListNew(Map<String,Object> params);
	
	public Map<String,Object> selectEmpInfoListNewPaging(Map<String,Object> params, PaginationInfo paginationInfo);
	
	public Map<String,Object> selectEmpInfoNew(Map<String,Object> params, PaginationInfo paginationInfo);
	 
	public String selectEmpDuplicate(Map<String,Object> params);
	
	public void updateEmpLoginId(Map<String,Object> params);
	
	public Map<String,Object> selectEmpInfo(Map<String,Object> params);
	
	public boolean isPossbileSettleDocument(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 생산문서 결재가능문서조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> possibleSettleDraftDocument(Map<String, Object> paramMap) throws Exception;

	public List<Map<String, Object>> selectEmpAuthList(Map<String, Object> params);
	
	public List<Map<String, Object>> getEmpJobList(Map<String, Object> params);
	
	public List<Map<String, Object>> getEmpStatusList(Map<String, Object> params);

	/**
	 * 사용자 삭제
	 * @param empInfoMap
	 * @return
	 */
	public boolean deleteEmpDept(Map<String, Object> empInfoMap);

	public boolean deleteEmpDeptMulti(Map<String, Object> empInfoMap);
	
	
	/**
	 * 사용자 기본정보 수정
	 * @param params
	 * @return
	 */
	public void updatemyInfo(Map<String, Object> params);
	
	public void updatemyInfoMulti(Map<String, Object> params);
	
	public void updatemyInfodeptMulti(Map<String, Object> params);
	
	public void deletemyInfoAtchFile(Map<String, Object> params);
	
	/**
	 * 사용자 기본부여권한 추가.
	 * @param empInfoMap
	 * @return
	 */
	
	public void InsertBaseAuth(Map<String, Object> params);
	
	
	/**
	 * 사용자 퇴사처리
	 * @param empInfoMap
	 * @return
	 */

	public void empResignProc(Map<String, Object> params);

	
	/**
	 * 사용자 기본부여권한 삭제.
	 * @param empInfoMap
	 * @return
	 */
	public void DeleteBaseAuth(Map<String, Object> params);

	public List<Map<String, Object>> selectEmpCurAuthList(Map<String, Object> authMap);

	
	/**
	 * 사용자 리스트 조회
	 * @param empInfoMap
	 * @return
	 */
	public List<Map<String, Object>> selectEmpInfoList(Map<String, Object> params);
	
	public HashMap<String, Object> changeEmailData(Map<String, Object> params);
	
	public void updateMailAddr(Map<String, Object> params);
	
	public List<Map<String, Object>> getWorkTeamMst(Map<String, Object> params);
	
	public void insertTeamWork(Map<String, Object> params);
	
	/*
	 * 사용자 퇴사처리 팝업 데이터 한번에 조회
	 */
	public Map<String, Object> empResignInitData (Map<String, Object> params);
	
	public Map<String, Object> empResignDocData (Map<String, Object> params);
	
	/**
	 * 사용자 퇴사처리  처리
	 * 
	 */
	 public List<Map<String, Object>> empResignProcFinish(Map<String, Object> params);

	public List<Map<String, Object>> getEmpInfoList(Map<String, Object> params);
	
	public List<Map<String, Object>> getEmpInfoListNew(Map<String, Object> params);

    String isMailUse(Map<String, Object> params);
    
    String getMailDomain(Map<String, Object> params);

	public String getbizSeq(Map<String, Object> para);

	public void updateEmpPicFileId(Map<String, Object> empMap);

	public Map<String, Object> getAttendTimeInfo(Map<String, Object> params);

	public Map<String, Object> updateUserMailPasswd(Map<String, Object> params) throws Exception;

	public String getEmpMasterAuth(Map<String, Object> params);
	
	public void updateErpEmpInfo(Map<String, Object> params, ConnectionVO conVo) throws Exception;
	
	public void initPasswordFailcount(Map<String, Object> params) throws Exception;
	
	public void setUserPortlet(Map<String, Object> params) throws Exception;
	
	public void initToken(Map<String, Object> params) throws Exception;
	
	public boolean delToken(Map<String, Object> params) throws Exception;
}
 