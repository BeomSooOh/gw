package main.service.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;


@Repository("MainManageDAO")
public class MainManageDAO extends EgovComAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMainPortlet(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MainManageDAO.selectMainPortlet", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectAlertReceiverList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MainManageDAO.selectAlertReceiverList", params);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectAlertReceiverReadCnt(Map<String, Object> params) {
		return (Map<String, Object>) select("MainManageDAO.selectAlertReceiverReadCnt", params);
	}

	public int updateAlertReceiver(Map<String, Object> params) {
		return update("MainManageDAO.updateAlertReceiver", params);
	}

	public String selectAdminAuthCnt(Map<String, Object> params) {
		return (String) select("MainManageDAO.selectAdminAuthCnt", params);
	}
	
	public String selectMasterAuthCnt(Map<String, Object> params) {
		return (String) select("MainManageDAO.selectMasterAuthCnt", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectLinkMenuInfo(Map<String, Object> params) throws Exception {
		
		Map<String, Object> checkToken = (Map<String, Object>) select("MainManageDAO.checkLinkToken", params);
		
		if(checkToken != null){
			String sLinkType = params.get("linkType") + "";
			String sLinkSeq = (String) select("MainManageDAO.selectLinkSeq", params);
			String sRet = "1";
			params.put("sLinkSeq", sLinkSeq);
			params.put("sRet", sRet);
			
			if(!sLinkType.equals("L") && !sLinkType.equals("S") && !sLinkType.equals("A") && !sLinkType.equals("B") && !sLinkType.equals("P") && !sLinkType.equals("R")){
				params.remove("linkType");
			}			
			
		}else{
			String sRet = "0";
			params.put("sRet", sRet);
		}
		
		return (Map<String, Object>) select("MainManageDAO.selectLinkInfo", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectTokenInfo(Map<String, Object> params) {
		return (Map<String, Object>) select("MainManageDAO.selectGerpTokenInfo", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectCustInfo(Map<String, Object> params) {
		return (Map<String, Object>) select("MainManageDAO.selectCustInfo", params);
	}	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> testSQL(Map<String, Object> params) {
		return (Map<String, Object>) select("MainManageDAO.testSQL", params);
	}
	
	public void deleteAlert(Map<String, Object> params) {
		delete("MainManageDAO.deleteAlert", params);
	}
	
	public void deleteAlertReceiver(Map<String, Object> params) {
		delete("MainManageDAO.deleteAlertReceiver", params);
	}

	public void alertRemoveNew(Map<String, Object> params) {
		update("MainManageDAO.alertRemoveNew", params);
	}
	
}
