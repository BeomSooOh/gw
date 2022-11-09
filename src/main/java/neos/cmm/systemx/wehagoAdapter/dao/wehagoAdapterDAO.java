package neos.cmm.systemx.wehagoAdapter.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Repository;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import neos.cmm.systemx.wehagoAdapter.service.wehagoAdapterService;

@Repository("wehagoAdapterDAO")
public class wehagoAdapterDAO extends EgovComAbstractDAO{
		
	@Resource(name="wehagoAdapterService")
	public wehagoAdapterService wehagoManageService;	
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoSetInfoList(Map<String, Object> params){
    	return list("WehagoManage.getWehagoSetInfoList", params);
    }
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> getWehagoServerInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("WehagoManage.getWehagoServerInfo", params);
    }	
    
	public void updateWehagoOrgKey(Map<String, Object> params){
    	update("WehagoManage.updateWehagoOrgKey", params);
    }
	
	public void updateWehagoEmpKey(Map<String, Object> params){
    	update("WehagoManage.updateWehagoEmpKey", params);
    }	
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoGwOrgAllList(Map<String, Object> params){
    	return list("WehagoManage.getWehagoGwOrgAllList", params);
    }
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoGwOrgOneSyncInfo(Map<String, Object> params){
    	return list("WehagoManage.getWehagoGwOrgOneSyncInfo", params);
    }	
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoGwEmpAllList(Map<String, Object> params){
    	return list("WehagoManage.getWehagoGwEmpAllList", params);
    }
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoSendMailList(Map<String, Object> params){
    	return list("WehagoManage.getWehagoSendMailList", params);
    }	
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoGwEmpOneSyncInfo(Map<String, Object> params){
    	return list("WehagoManage.getWehagoGwEmpOneSyncInfo", params);
    }
	
	public void updateWehagoJoinCallback(Map<String, Object> params){
    	update("WehagoManage.updateWehagoJoinCallback", params);
    }
	
	public void updateWehagoSyncYn(Map<String, Object> params){
    	update("WehagoManage.updateWehagoSyncYn", params);
    }
	
	public void updateWehagoDutyPositionGroupKey(Map<String, Object> params){
    	update("WehagoManage.updateWehagoDutyPositionGroupKey", params);
    }	

	public void updateWehagoDutyPositionKey(Map<String, Object> params){

		delete("WehagoManage.deleteWehagoDutyPositionKey", params);
    	insert("WehagoManage.insertWehagoDutyPositionKey", params);
    }
	
	public void deleteWehagoDutyPositionKey(Map<String, Object> params){

		delete("WehagoManage.deleteWehagoDutyPositionKey", params);
    }	
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoGwDutyPositionAllList(Map<String, Object> params){
    	return list("WehagoManage.getWehagoGwDutyPositionAllList", params);
    }
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getWehagoGwDutyPositionOneSyncInfo(Map<String, Object> params){
    	return list("WehagoManage.getWehagoGwDutyPositionOneSyncInfo", params);
    }
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> getWehagoJoinUrlInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("WehagoManage.getWehagoJoinUrlInfo", params);
    }	
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> getWehagoSyncInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("WehagoManage.getWehagoSyncInfo", params);
    }	    
	
	public void updateWehagoToken(Map<String, Object> params){
    	update("WehagoManage.updateWehagoToken", params);
    }	
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> getWehagoJoinState(Map<String, Object> params){
    	return (Map<String, Object>)select("WehagoManage.getWehagoJoinState", params);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> getWehagoSignInUserInfo(Map<String, Object> params){
    	return (Map<String, Object>)select("WehagoManage.getWehagoSignInUserInfo", params);
    }
    
	public void updateWehagoSignInUser(Map<String, Object> params){
    	update("WehagoManage.updateWehagoSignInUser", params);
    }    
	
}