package neos.cmm.erp.orgchart.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import bizbox.orgchart.service.vo.EmpDeptMultiVO;
import bizbox.orgchart.service.vo.EmpDeptVO;
import bizbox.orgchart.service.vo.EmpMultiVO;
import bizbox.orgchart.service.vo.EmpVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.erp.dao.ErpOrgchartDAO;
import neos.cmm.util.CommonUtil;

@Repository("ErpOrgchartDAO")
public class ErpOrgchartSyncDAO extends EgovComAbstractDAO {

	public Map<String, Object> selectErpSyncDetailList(Map<String, Object> params, PaginationInfo paginationInfo) {

		return listOfPaging2(params, paginationInfo, "ErpOrgchartDAO.selectErpSyncDetailList");
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectErpSyncDetailList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectErpSyncDetailList", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectErpSyncCodeList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectErpSyncCodeList", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectCommonCodeList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectCommonCodeList", params);
	}

	public void deleteErpSyncCodeList(Map<String, Object> params) {
		delete("ErpOrgchartDAO.deleteErpSyncCodeList", params);

	}

	public void insertErpSyncCodeList(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertErpSyncCodeList", params);

	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectSyncBizList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectSyncBizList", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectSyncDeptList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectSyncDeptList", params);
	}

	public String insertDept(Map<String, Object> map) {
		return (String) insert("ErpOrgchartDAO.insertDept", map);
	}

	public void insertDeptMulti(Map<String, Object> map) {
		if(map == null) {
			return;
		}
	}

	public void insertErpDept(Map<String, Object> map) {
		if(map == null) {
			return;
		}
	}

	public void insertTmpBiz(Map<String, Object> map) {
		insert("ErpOrgchartDAO.insertTmpBiz", map);

	}

	public void insertTmpBizMulti(Map<String, Object> map) {
		insert("ErpOrgchartDAO.insertTmpBizMulti", map);
		String langCode = map.get("langCode") + "";
		
		if(map.get("bizNameEn") != null && !map.get("bizNameEn").equals("")) {
			map.put("langCode", "en");
			map.put("bizName", map.get("bizNameEn"));
			insert("ErpOrgchartDAO.insertTmpBizMulti", map);
		}
		map.put("langCode", langCode);
	}

	public void insertTmpDept(Map<String, Object> map) {
		/*
		if(map.get("deptSeq").toString().equals("104A01000")) {
			System.out.println(map);
		}
		*/
		
		insert("ErpOrgchartDAO.insertTmpDept", map);
	}

	public void insertTmpDeptMulti(Map<String, Object> map) {
		/*
		if(map.get("deptSeq").toString().equals("104A01000")) {
			System.out.println(map);
		}
		*/
		
		insert("ErpOrgchartDAO.insertTmpDeptMulti", map);
		
		String langCode = map.get("langCode") + "";
		
		if(map.get("deptNameEn") != null && !map.get("deptNameEn").equals("")) {
			map.put("langCode", "en");
			map.put("deptName", map.get("deptNameEn"));
			insert("ErpOrgchartDAO.insertTmpDeptMulti", map);
		}
		
		map.put("langCode", langCode);
	}

	public List<Map<String, Object>> selectCompList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectCompList", params);
	}

	public List<Map<String, Object>> selectTmpBizList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectTmpBizList", params);
	}

	public List<Map<String, Object>> selectTmpDeptList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectTmpDeptList", params);
	}
	
	public List<Map<String, Object>> selectTmpBizInfoList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectTmpBizInfoList", params);
	}

	public String insertTmpEmp(Map<String, Object> params) {

		params.put("empSeq", select("ErpOrgchartDAO.selectTmpEmpSeq", params));
		insert("ErpOrgchartDAO.insertTmpEmp", params);
		
		return params.get("empSeq").toString();
	}

	public void insertTmpEmpMulti(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertTmpEmpMulti", params);
		
		String langCode = params.get("langCode") + "";
		
		if(params.get("empNameEn") != null && !params.get("empNameEn").equals("")) {
			params.put("langCode", "en");
			params.put("empName", params.get("empNameEn"));
			insert("ErpOrgchartDAO.insertTmpEmpMulti", params);
		}
		
		params.put("langCode", langCode);
	}

	public Map<String, Object> selectTmpEmpList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return listOfPaging2(params, paginationInfo, "ErpOrgchartDAO.selectTmpEmpList");
	}

	public Map<String, Object> selectTmpEmpList(Map<String, Object> params) {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> returnResult = new HashMap<String, Object>();

		result = (List<Map<String, Object>>) list("ErpOrgchartDAO.selectTmpEmpAutoList", params);

		returnResult.put("list", result);

		return returnResult;
	}

	public void insertTmpEmpDept(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertTmpEmpDept", params);
	}

	public void insertTmpEmpDeptMulti(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertTmpEmpDeptMulti", params);
	}

	public void insertBizList(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertBizList", params);
		insert("ErpOrgchartDAO.updateBizList", params);
		insert("ErpOrgchartDAO.insertBizMultiList", params);
		update("ErpOrgchartDAO.updateBizMultiList", params);
		insert("ErpOrgchartDAO.insertErpBizList", params);
	}

	public void deleteOrgchart(Map<String, Object> params) {
		/** ERP 맵핑 데이터 삭제 */
		delete("ErpOrgchartDAO.deleteEmpComp", params);
		delete("ErpOrgchartDAO.deleteErpDept", params);
		delete("ErpOrgchartDAO.deleteErpBiz", params);

		/** 사원정보 삭제 */
		delete("ErpOrgchartDAO.deleteEmp", params);

		/** 겸직정보 삭제 */
		delete("ErpOrgchartDAO.deleteEmpDeptMulti", params);
		delete("ErpOrgchartDAO.deleteEmpDept", params);

		/** 부서정보 삭제 */
		delete("ErpOrgchartDAO.deleteDeptMulti", params);
		delete("ErpOrgchartDAO.deleteDept", params);

		/** 사업장 정보 삭제 */
		delete("ErpOrgchartDAO.deleteBizMulti", params);
		delete("ErpOrgchartDAO.deleteBiz", params);
	}

	private void setPage(Map<String, Object> params) {
		PaginationInfo paginationInfo = new PaginationInfo();
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int totalCount = EgovStringUtil.zeroConvert(params.get("totalCount"));

		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(100);
		paginationInfo.setRecordCountPerPage(10);
		paginationInfo.setTotalRecordCount(totalCount);

		int startNum = ((paginationInfo.getCurrentPageNo() - 1) * paginationInfo.getPageSize()) + 1;
		int endNum = startNum + paginationInfo.getPageSize() - 1;

		if (!Globals.DB_TYPE.toLowerCase().equals("oracle")) {
			startNum = ((paginationInfo.getCurrentPageNo() - 1) * paginationInfo.getPageSize());
			endNum = paginationInfo.getPageSize();
		} else {
			startNum = ((paginationInfo.getCurrentPageNo() - 1) * paginationInfo.getPageSize());
			endNum = paginationInfo.getPageSize();
		}

		if (paginationInfo.getCurrentPageNo() >= paginationInfo.getLastPageNo()
				|| paginationInfo.getTotalPageCount() == 0) {
			params.put("moreYn", "N");
		} else {
			params.put("moreYn", "Y");
		}

		params.put("startNum", startNum);
		params.put("endNum", endNum);

	}

	public void insertDeptList(Map<String, Object> params) {
		params.put("totalCount", params.get("deptJoinTotalCount"));

		if (params.get("autoYn") == null) {
			params.put("autoYn", "N");
		}

		if (!params.get("autoYn").toString().equals("Y")) {
			setPage(params);
		}
		
		insert("ErpOrgchartDAO.insertDeptList", params);
		insert("ErpOrgchartDAO.insertDeptMultiList", params);

		insert("ErpOrgchartDAO.insertErpDeptList", params);
		
		//path, path_name 보정처리
		update("ErpOrgchartDAO.updateDeptPath", params);
		update("ErpOrgchartDAO.updateDeptPathName", params);
	}

	public List<Map<String, Object>> selectTmpDeptTotalCount(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectTmpDeptTotalCount", params);
	}

	public List<Map<String, Object>> selectTmpEmpTotalCount(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectTmpEmpTotalCount", params);
	}

	public EmpVO selectTmpEmp(Map<String, Object> params) {
		return (EmpVO) select("ErpOrgchartDAO.selectTmpEmp", params);
	}

	public EmpMultiVO selectTmpEmpMulti(Map<String, Object> params) {
		return (EmpMultiVO) select("ErpOrgchartDAO.selectTmpEmpMulti", params);
	}

	public EmpDeptVO selectTmpEmpDept(Map<String, Object> params) {
		return (EmpDeptVO) select("ErpOrgchartDAO.selectTmpEmpDept", params);
	}

	public EmpDeptMultiVO selectTmpEmpDeptMulti(Map<String, Object> params) {
		return (EmpDeptMultiVO) select("ErpOrgchartDAO.selectTmpEmpDeptMulti", params);
	}

	public Map<String, Object> selectSyncTmpEmpList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return listOfPaging2(params, paginationInfo, "ErpOrgchartDAO.selectSyncTmpEmpList");
	}

	public Map<String, Object> selectBiz(Map<String, Object> params) {
		return (Map<String, Object>) select("ErpOrgchartDAO.selectBiz", params);
	}

	public Map<String, Object> selectDept(Map<String, Object> params) {
		return (Map<String, Object>) select("ErpOrgchartDAO.selectDept", params);
	}

	public void insertEmpComp(Map<String, Object> params) {
		update("ErpOrgchartDAO.insertEmpComp", params);
	}
	
	public void updateEmpComp(Map<String, Object> params) {
		update("ErpOrgchartDAO.updateEmpComp", params);
	}

	public void insertErpSync(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertErpSync", params);
	}

	public void updateErp(Map<String, Object> params) {
		update("ErpOrgchartDAO.updateErp", params);
	}

	public void insertCompDutyPosition(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertCompDutyPosition", params);
	}

	public void insertCompDutyPositionMulti(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertCompDutyPositionMulti", params);
		
		if(params.get("dpNameEn") != null && !params.get("dpNameEn") .toString().equals("")) {
			params.put("dpName", params.get("dpNameEn"));
			params.put("langCode", "en");
			insert("ErpOrgchartDAO.insertCompDutyPositionMulti", params);
		}
	}

	public void updateDeptList(Map<String, Object> params) {
		update("ErpOrgchartDAO.updateDeptList", params);
	}
	
	public void updateDeptInfo(Map<String, Object> params) {
		int cnt = update("ErpOrgchartDAO.updateDeptInfo", params);
		
		
		List<Map<String, Object>> deptMultiList = list("ErpOrgchartDAO.selectDeptMultiList", params);
		for(Map<String, Object> mp : deptMultiList) {
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			Iterator<String> keys = mp.keySet().iterator();
	        while( keys.hasNext() ){
	            String key = keys.next();
	            param.put(key, mp.get(key));
	        }			
			
			update("ErpOrgchartDAO.updateDeptMulti",param);
		}
		
		//상위부서코드 보정쿼리
		update("ErpOrgchartDAO.updateParentDeptSeqInfo", params);
		
		//path, path_name 보정처리
		update("ErpOrgchartDAO.updateDeptPath", params);
		update("ErpOrgchartDAO.updateDeptPathName", params);
		
		//다국어 정보는 전체 삭제후 저장.
//		delete("ErpOrgchartDAO.deleteDeptMultiInfo",params);		
//		insert("ErpOrgchartDAO.insertDeptMultiInfo", params);
	}

	public List<Map<String, Object>> selectSyncFailTmpEmpList(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectSyncFailTmpEmpList", params);
	}

	public List<Map<String, Object>> selectSyncSuccessTmpEmpList(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectSyncSuccessTmpEmpList", params);
	}

	public Map<String, Object> selectEmpDeptInfo(Map<String, Object> map) {
		return (Map<String, Object>) select("ErpOrgchartDAO.selectEmpDeptInfo", map);
	}
	
	public Map<String, Object> selectTmpEmpDeptInfo(Map<String, Object> map) {
		return (Map<String, Object>) select("ErpOrgchartDAO.selectTmpEmpDeptInfo", map);
	}
	
	public void deleteEmpDeptForChange(Map<String, Object> params) {
		delete("ErpOrgchartDAO.deleteEmpDeptForChange", params);
		delete("ErpOrgchartDAO.deleteEmpDeptMultiForChange", params);
	}

	public void insertErpSyncAutoList(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertErpSyncAutoList", params);
	}

	public List<Map<String, Object>> selectErpSyncAutoList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectErpSyncAutoList", params);
	}

	public void updateErpSyncAutoList(Map<String, Object> params) {
		update("ErpOrgchartDAO.updateErpSyncAutoList", params);
	}

	public List<Map<String, Object>> selectErpSyncAutoUseCompList(String groupSeq) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", groupSeq);
		return (List<Map<String, Object>>) list("ErpOrgchartDAO.selectErpSyncAutoUseCompList", param);
	}
	
	public void insertCustomData(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertCustomData", params);
	}

	public Map<String, Object> selectErpSyncCompDetailList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return listOfPaging2(params, paginationInfo, "ErpOrgchartDAO.selectErpSyncCompDetailList");
	}

	public Map<String, Object> selectTmpCompList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return listOfPaging2(params, paginationInfo, "ErpOrgchartDAO.selectTmpCompList");
	}

	public void insertTmpComp(Map<String, Object> comp) {
		insert("ErpOrgchartDAO.insertTmpComp", comp);
	}

	public void insertTmpCompMulti(Map<String, Object> compMulti) {
		insert("ErpOrgchartDAO.insertTmpCompMulti", compMulti);
	}

	public List<Map<String, Object>> selectTmpCompTotalCount(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectTmpCompTotalCount", params);
	}

	public List<Map<String, Object>> selectTmpCompList(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectTmpCompList", params);
	}

	public void insertErpCompList(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertErpCompList", params);
		
	}

	public void insertErpCompSync(Map<String, Object> params) {
		insert("ErpOrgchartDAO.insertErpCompSync", params);
		
	}
	
	
	public void setEmpResign(Map<String, Object> params) {
		// 퇴직자들 확인
		List<Map<String, Object>> resignEmpList = new ArrayList<Map<String, Object>>();
		
		resignEmpList = list("ErpOrgchartDAO.selectEmpResignList", params);
				
		ErpOrgchartDAO erpOrgchartDAO = (ErpOrgchartDAO)params.get("erpOrgchartDAO");					
		
		
		for(Map<String, Object> temp : resignEmpList) {
			try {
				
				Map<String, Object> param = new HashMap<String, Object>();
				
				Iterator<String> keys = temp.keySet().iterator();
		        while( keys.hasNext() ){
		            String key = keys.next();
		            param.put(key, temp.get(key));
		        }	
				
				// 재직상태 변경
				update("ErpOrgchartDAO.updateEmpResign", param);
				update("ErpOrgchartDAO.updateEmpMultiResign", param);
	
				// 사원 부서 상태 변경
				update("ErpOrgchartDAO.updateEmpDeptResign", param);
				update("ErpOrgchartDAO.updateEmpDeptMultiResign", param);
				
				// 사원 회사 상태 변경
				update("ErpOrgchartDAO.updateEmpCompResign", param);
				
				param.put("erpEmpSeq", param.get("erpEmpNum"));
				param.put("erpCompSeq", params.get("erpCompSeq"));
				erpOrgchartDAO.updateErpEmpGwUpdateDate(param);
			}catch(Exception e) {
				Logger.getLogger( ErpOrgchartSyncServiceImpl.class ).error( "ErpOrgchartSyncDAO.setEmpResign Error");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}	
		}
	}
		

	public List<Map<String, Object>> selectErpSyncCompList(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectErpSyncCompList", params);
	}

	public void updateLicenseValue(Map<String, Object> params) {
		update("ErpOrgchartDAO.updateLicenseValue", params);
	}
	
	public void deleteErpDeptSync(Map<String, Object> params) {
		update("ErpOrgchartDAO.deleteErpDeptSync", params);
		update("ErpOrgchartDAO.deleteErpDeptMultiSync", params);
	}

	public int selectNoMappingEmpCnt(Map<String, Object> params) {
		return (int) select("ErpOrgchartDAO.selectNoMappingEmpCnt", params);
	}

	public int selectEmpResignCnt(Map<String, Object> params) {
		return (int) select("ErpOrgchartDAO.selectEmpResignCnt", params);
	}

	public int selectEmpModifyCnt(Map<String, Object> params) {
		return (int) select("ErpOrgchartDAO.selectEmpModifyCnt", params);
	}

	public void updateEmpCompInfo(Map<String, Object> map) {
		update("ErpOrgchartDAO.updateEmpCompInfo", map);		
	}

	public void deleteTmpBiz(Map<String, Object> params) {
		delete("ErpOrgchartDAO.deleteTmpBiz", params);
	}
	public void deleteTmpBizMulti(Map<String, Object> params) {
		delete("ErpOrgchartDAO.deleteTmpBizMulti", params);
	}
	public void deleteTmpDept(Map<String, Object> params) {
		delete("ErpOrgchartDAO.deleteTmpDept", params);
	}
	public void deleteTmpDeptMulti(Map<String, Object> params) {
		delete("ErpOrgchartDAO.deleteTmpDeptMulti", params);
	}

	public List<Map<String, Object>> selectEmpSyncList(Map<String, Object> params) {
		return list("ErpOrgchartDAO.selectEmpSyncList", params);
	}
}
