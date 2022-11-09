package neos.cmm.systemx.orgAdapter.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("OrgAdapterDAO")
public class OrgAdapterDAO extends EgovComAbstractDAO{
	
    public String getOrgSequence(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getSequence", paramMap);
    }
    
    public String getCompCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getCompCnt", paramMap);
    }
    
    public String getBizCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getBizCnt", paramMap);
    }
    
    public String getDeptCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getDeptCnt", paramMap);
    }    
    
    public String getDeptBizSeq(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getDeptBizSeq", paramMap);
    }
    
    public String getCompEaType(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getCompEaType", paramMap);
    }    
    
    public String getCompDeptCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getCompDeptCnt", paramMap);
    }
    
    public String getBizDeptCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getBizDeptCnt", paramMap);
    }
    
    public String getDeptChildCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getDeptChildCnt", paramMap);
    }
    
    public String getDeptEmpCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getDeptEmpCnt", paramMap);
    }
    
    public String getDeptEmpResignCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getDeptEmpResignCnt", paramMap);
	}	
    
    public String getEmpDeptCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpDeptCnt", paramMap);
    }
    
    public String getEmpDeptAllCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpDeptAllCnt", paramMap);
    }
    
    public String getEmpCompCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpCompCnt", paramMap);
    }
    
    public String getEmpCompWorkCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpCompWorkCnt", paramMap);
    }    
    
    public String getNewEmpDeptCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getNewEmpDeptCnt", paramMap);
    }     
    
    public String getEmpCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpCnt", paramMap);
    }
    
    public String getEmpDefCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpDefCnt", paramMap);
    }    
    
    public String getEmpDuplicate(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpDuplicate", paramMap);
    }  
    
    public void insertComp(Map<String, Object> params) {
        insert("OrgAdapterManage.insertComp", params);        
    }
    
    public int updateComp(Map<String, Object> params) {
        return update("OrgAdapterManage.updateComp", params);        
    }
    
    public int deleteComp(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteComp", params);        
    }
    
    public void insertCompMulti(Map<String, Object> params) {
        insert("OrgAdapterManage.insertCompMulti", params);        
    }
    
    public int updateCompMulti(Map<String, Object> params) {
        return update("OrgAdapterManage.updateCompMulti", params);        
    }     
    
    public int deleteCompMulti(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteCompMulti", params);        
    }
    
    public void insertBiz(Map<String, Object> params) {
        insert("OrgAdapterManage.insertBiz", params);        
    }
    
    public int updateBiz(Map<String, Object> params) {
        return update("OrgAdapterManage.updateBiz", params);        
    }
    
    public int deleteBiz(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteBiz", params);        
    }
    
    public void insertBizMulti(Map<String, Object> params) {
        insert("OrgAdapterManage.insertBizMulti", params);        
    }
    
    public int updateBizMulti(Map<String, Object> params) {
        return update("OrgAdapterManage.updateBizMulti", params);        
    }     
    
    public int deleteBizMulti(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteBizMulti", params);        
    }
    
    public void insertDept(Map<String, Object> params) {
        insert("OrgAdapterManage.insertDept", params);
        update("OrgAdapterManage.UpdateDisplayDeptSeq", params);
    }
    
    public int updateDept(Map<String, Object> params) {
        update("OrgAdapterManage.updateDept", params);
        return update("OrgAdapterManage.UpdateDisplayDeptSeq", params);
    }
    
    public int deleteDept(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteDept", params);        
    }
    
    public void insertDeptMulti(Map<String, Object> params) {
        insert("OrgAdapterManage.insertDeptMulti", params);        
    }
    
    public int updateDeptMulti(Map<String, Object> params) {
        return update("OrgAdapterManage.updateDeptMulti", params);        
    }        
    
    public int deleteDeptMulti(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteDeptMulti", params);        
    }
    
    public void insertEmp(Map<String, Object> params) {
        insert("OrgAdapterManage.insertEmp", params);        
    }
    
    public int updateEmp(Map<String, Object> params) {
        return update("OrgAdapterManage.updateEmp", params);        
    }  
    
    public int deleteEmp(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteEmp", params);        
    }
    
    public void insertEmpMulti(Map<String, Object> params) {
    	
    	if(params.get("mainWork") != null && params.get("mainWork").toString().length() > 128){
    		params.put("mainWork", params.get("mainWork").toString().substring(0,128));
    	}
    	
        insert("OrgAdapterManage.insertEmpMulti", params);
    }
    
    public int updateEmpMulti(Map<String, Object> params) {
        return update("OrgAdapterManage.updateEmpMulti", params);        
    }     
    
    public int deleteEmpMulti(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteEmpMulti", params);        
    }
    
    public void insertEmpDept(Map<String, Object> params) {
        insert("OrgAdapterManage.insertEmpDept", params);        
    }
    
    public int updateEmpDept(Map<String, Object> params) {
    	int updateCnt = update("OrgAdapterManage.updateEmpDept", params);
    	
    	//메일, 비라이선스일 경우 메신저/모바일 조직도표시여부 N셋팅 - 모든 겸직부서 동일
		if ( params.get( "licenseCheckYn" ) == null || !params.get( "licenseCheckYn" ).equals( "1" ) ) {
			update("OrgAdapterManage.updateEmpDeptMessengerDisplayYn", params);
		}
    	
        return updateCnt;       
    }
    
    public int deleteEmpDept(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteEmpDept", params);        
    }
    
    public void insertEmpDeptMulti(Map<String, Object> params) {
        insert("OrgAdapterManage.insertEmpDeptMulti", params);        
    }
    
    public int updateEmpDeptMulti(Map<String, Object> params) {
        return update("OrgAdapterManage.updateEmpDeptMulti", params);        
    }    
    
    public int deleteEmpDeptMulti(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteEmpDeptMulti", params);        
    }
    
    public void insertEmpComp(Map<String, Object> params) {
        insert("OrgAdapterManage.insertEmpComp", params);
    }
    
    public int updateEmpComp(Map<String, Object> params) {
    	if(update("OrgAdapterManage.updateEmpComp", params) > 0){
    		
    		//주부서 설정 시 타부서 부부서로 업데이트
    		if(params.get("mainDeptYn") != null && params.get("mainDeptYn").equals("Y")){
    			update("OrgAdapterManage.updateEmpDeptMainDeptYn", params);
    		}
    		
    		return 1;
    	}else{
    		return 0;
    	}
    }
    
    public int deleteEmpComp(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteEmpComp", params);        
    }
    
    public void insertEmpBaseAuth(Map<String, Object> params) {
        insert("OrgAdapterManage.insertEmpBaseAuth", params);        
    }
    
    public int updateEmpBaseAuth(Map<String, Object> params) {
        return update("OrgAdapterManage.updateEmpBaseAuth", params);        
    }     
    
    public int deleteEmpAuth(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteEmpAuth", params);        
    }    
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectEmpMainDept(Map<String, Object> params){
        return (Map<String, Object>)select("OrgAdapterManage.selectEmpMainDept", params);
    }
    public int updateAccessIpRelate(Map<String, Object> params) {
        return update("OrgAdapterManage.updateAccessIpRelate", params);        
    }     
    public int deleteAccessIpRelate(Map<String, Object> params) {
        return update("OrgAdapterManage.deleteAccessIpRelate", params);        
    }     
    
    public void deleteCompPack(Map<String, Object> params) {
        delete("OrgAdapterManage.deleteCompAuthCodeMulti", params);
        delete("OrgAdapterManage.deleteCompMenuAuth", params);
        delete("OrgAdapterManage.deleteCompAuthRelate", params);
        delete("OrgAdapterManage.deleteCompAuthCode", params);
        delete("OrgAdapterManage.deleteGrouppingComp", params);
        params.put("ipDiv", "comp");
        delete("OrgAdapterManage.deleteAccessIp", params);
        delete("OrgAdapterManage.deleteAccessIpRelate", params);
    }     
    
    public void updateChildDeptInfo(Map<String, Object> params){
    	update("OrgAdapterManage.updateChildDeptInfo", params);
    	update("OrgAdapterManage.updateChildDeptMultiInfo", params);
    	update("OrgAdapterManage.updateChildEmpDeptInfo", params);
    	update("OrgAdapterManage.updateChildEmpDeptMultiInfo", params);
    	update("OrgAdapterManage.updateChildEmpCompInfo", params);
    }
    
    public void updateDeptMovePack(Map<String, Object> params){
    	update("OrgAdapterManage.updateWorkTeam", params);
    	update("OrgAdapterManage.updateWorkTeamHistory", params);
    	update("OrgAdapterManage.updateAttRegulate", params);
    	update("OrgAdapterManage.updateAccessEmpInfo", params);
    	update("OrgAdapterManage.updateProjectUser", params);
    	update("OrgAdapterManage.updateMcalUser", params);
    }
    
    public void updateEmpDeptCompCalibrate(Map<String, Object> params){
    	update("OrgAdapterManage.updateEmpDeptOrderText", params);
		update("OrgAdapterManage.setEmpCalibrate", params);
		
		if(params.get("checkWorkYn") != null && params.get("checkWorkYn").equals("Y")){
			update("OrgAdapterManage.setEmpCompCheckWorkYn", params);	
		}
		
		String mainCompSeq = (String) select("OrgAdapterManage.getEmpMainComp", params);
		
		if(mainCompSeq != null){
			params.put("mainCompSeq", mainCompSeq);
			update("OrgAdapterManage.setEmpMainCompYn", params);	
		}
		
    }
    
    public int updateEmpDeptOrderNum(Map<String, Object> params){
    	update("OrgAdapterManage.updateEmpDeptOrderNum", params);
    	return update("OrgAdapterManage.updateEmpDeptOrderText", params);
    }
    
    public void setEmpCalibrate(Map<String, Object> params){
		update("OrgAdapterManage.setEmpCalibrate", params);
    }
    
    public void setEmpDeptCompCalibrate(Map<String, Object> params){
    	@SuppressWarnings("unchecked")
		Map<String, Object> result = (Map<String, Object>) select("OrgAdapterManage.selectEmpDeptTop", params);
    	if(result != null){
    		params.put("deptSeq", result.get("deptSeq"));
    		update("OrgAdapterManage.updateEmpDeptTop", params);
    		update("OrgAdapterManage.updateEmpCompTop", params);
    	}
    }    
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectEmpInfo", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpCompInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectEmpCompInfo", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpDeptInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectEmpDeptInfo", params);
    }        
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectErpInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectErpInfo", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectMailInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectMailInfo", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectMailInfoGroup(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectMailInfoGroup", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectGroupInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectGroupInfo", params);
    }    
    
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> selectEmpMailResignList(Map<String, Object> params){
    	return list("OrgAdapterManage.selectEmpMailResignList", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectDeptInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectDeptInfo", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectGroupPath(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectGroupPath", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpDept(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectEmpDept", params);
    }    
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpDeptMulti(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectEmpDeptMulti", params);
    }        
    
    public void insertBasicData(Map<String, Object> params){
    	insert("OrgAdapterManage.insertMsgLink", params);
    	insert("OrgAdapterManage.insertAlertMaster", params);
    	insert("OrgAdapterManage.insertAlertAdmin", params);
    	insert("OrgAdapterManage.insertAttCodeItem", params);
    	insert("OrgAdapterManage.insertAttCodeDiv", params);
    	insert("OrgAdapterManage.insertAttConfig", params);
    	insert("OrgAdapterManage.setBaseDateInfo", params);
    }
    
    public void insertEmpCalendar(Map<String, Object> params){
    	params.put("mcalSeq", select("OrgAdapterManage.getEmpCalendarSeq", params));
		insert("OrgAdapterManage.insertEmpMcalendar", params);
		insert("OrgAdapterManage.insertEmpMcalUserCreate", params);
		insert("OrgAdapterManage.insertEmpMcalUserOwner", params);
		insert("OrgAdapterManage.insertEmpMcalUserStyle", params);
    }
    
    public void setEmpResign(Map<String, Object> params){
    	update("OrgAdapterManage.resignEmpDeptMulti", params);
    	update("OrgAdapterManage.resignEmpDept", params);
    	update("OrgAdapterManage.resignEmpComp", params);
    }
    
    public void updateDocAdm(Map<String, Object> params){
    	update("OrgAdapterManage.updateDocAdm", params);
    }
    
    public void deleteDocAdm(Map<String, Object> params){
    	delete("OrgAdapterManage.deleteDocAdm", params);
    }
    
    public void updateBoardAdm(Map<String, Object> params){
    	update("OrgAdapterManage.updateBoardAdm", params);
    }
    
    public void deleteBoardAdm(Map<String, Object> params){
    	delete("OrgAdapterManage.deleteBoardAdm", params);
    }
    
    public String getDocAdmCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getDocAdmCnt", paramMap);
    }
    
    public String getBoardAdmCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getBoardAdmCnt", paramMap);
    }

    public String getEmpOptionCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpOptionCnt", paramMap);
    }
    
    public String getEmpMasterCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getEmpMasterCnt", paramMap);
    }
    
    public void insertEmpOption(Map<String, Object> paramMap) {
    	insert("OrgAdapterManage.insertEmpOption", paramMap);
    }
    
    public int updateEmpOption(Map<String, Object> paramMap) {
    	return update("OrgAdapterManage.updateEmpOption", paramMap);
    }    
    
    public int deleteEmpOption(Map<String, Object> paramMap) {
    	return delete("OrgAdapterManage.deleteEmpOption", paramMap);
    }
    
    public void updateEaProgressInfo(Map<String, Object> paramMap) {
    	update("OrgAdapterManage.updateEaProgressDoc", paramMap);
    	update("OrgAdapterManage.updateEaProgressLine", paramMap);
    	update("OrgAdapterManage.updateEaProgressProxy", paramMap);
    }

	public int selectChildDeptCount(Map<String, Object> paramMap) {
		return (int) select("OrgAdapterManage.selectChildDeptCount", paramMap);
	}

	public void updateEmpDeptDisplayInfo(Map<String, Object> innerParam) {
		update("OrgAdapterManage.updateEmpDeptDisplayInfo", innerParam);
	}

	public List<Map<String, Object>> selectEmpDeptInfoForEaYn(Map<String, Object> paramMap) {
		return list("OrgAdapterManage.selectEmpDeptInfoForEaYn", paramMap);
	}

	public void setEmpMainCompYn(Map<String, Object> innerParam) {
		update("OrgAdapterManage.setEmpMainCompN", innerParam);
		update("OrgAdapterManage.setEmpMainCompY", innerParam);
	}
    
    public String getEmpCompWorkUseY(Map<String, Object> paramMap) {
        return (String) select("OrgAdapterManage.getEmpCompWorkUseY", paramMap);
    }    
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpPasswdCheck(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectEmpPasswdCheck", params);
    }
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpMultiLangName(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectEmpMultiLangName", params);
    }
    
	public void empLoginPasswdResetProc(Map<String, Object> innerParam) {
		update("OrgAdapterManage.empLoginPasswdResetProc", innerParam);
	}
	
    public void updateEmpResignInfo(Map<String, Object> innerParam){
    	update("OrgAdapterManage.updateEmpResignInfo", innerParam);
    }
    
    public void insertDutyPosition(Map<String, Object> params) {
        insert("OrgAdapterManage.insertDutyPosition", params);        
    }
    
    public int updateDutyPosition(Map<String, Object> params) {
        return update("OrgAdapterManage.updateDutyPosition", params);        
    }
    
    public int deleteDutyPosition(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteDutyPosition", params);        
    }
    
    public void insertDutyPositionMulti(Map<String, Object> params) {
        insert("OrgAdapterManage.insertDutyPositionMulti", params);        
    }
    
    public int deleteDutyPositionMulti(Map<String, Object> params) {
        return delete("OrgAdapterManage.deleteDutyPositionMulti", params);        
    }
    
    public String getDutyPositionCnt(Map<String, Object> paramMap) {
    	return (String) select("OrgAdapterManage.getDutyPositionCnt", paramMap);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectCompInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("OrgAdapterManage.selectCompInfo", params);
    }
    
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> selectFtpProfileSyncList(Map<String, Object> params){
    	return list("OrgAdapterManage.selectFtpProfileSyncList", params);
    }

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEmpInfo(Map<String, Object> empMap) {
		return (Map<String, Object>) select("OrgAdapterManage.getEmpInfo", empMap);
	}  
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> selectStandardCodeList(Map<String, Object> paramMap) {
		return list("OrgAdapterManage.selectStandardCodeList", paramMap);
	}

	public void updateDeptPathName(Map<String, Object> innerParam) {
		update("OrgAdapterManage.updateDeptPathName", innerParam);   
	}

	
    
}