package neos.cmm.systemx.commonOption.service.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import neos.cmm.systemx.commonOption.vo.CommonOptionManageVO;

/**
 *<pre>
 * 1. Package Name	: neos.cmm.system.commonOption.service.impl
 * 2. Class Name	: CommonOptionManageDAO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2013. 7. 16.     doban7       최초작성
 *  -----------------------------------------------------
 *</pre>
 */
@Repository("CommonOptionDAO")
public class CommonOptionManageDAO extends EgovComAbstractDAO {

  
	public CommonOptionManageVO selectCommonOption() throws Exception 	{
		Map<String, Object> mp = new HashMap<String, Object>();
		CommonOptionManageVO list = (CommonOptionManageVO) select("CommonOptionDAO.selectCommonOption", mp);
		return list;
	}	
	
    public String insertCommonOption(CommonOptionManageVO cmManageVO) throws Exception {
    	insert("CommonOptionDAO.InsertCommonOption", cmManageVO);
    	return "insert";
    } 
    
    public String updateCommonOption(CommonOptionManageVO cmManageVO) throws Exception {
    	
    	update("CommonOptionDAO.UpdateCommonOption", cmManageVO);    	
    	return "update";
    }    
     
    public List<Map<String, Object>> getCompList(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> compList = list("CommonOptionDAO.selectCompList", params);
    	
    	return compList; 
    }
    
    public List<Map<String, Object>> getOptionList(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> optionList = list("CommonOptionDAO.selectOptionList", params);
    	
    	return optionList; 
    }
    
    public List<Map<String, Object>> getOptionSettingValue(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> optionSettingValue = list("CommonOptionDAO.selectOptionValue", params);
    	
    	return optionSettingValue;
    }
    
    public void getOptionSave(Map<String, Object> params) throws Exception {
    	
    	if(params == null) {
    		return;
    	}
    	return;
    }
    
    public void setOptionInsert(Map<String, Object> params) throws Exception {
    	insert("CommonOptionDAO.insertOptionValue", params);
    }
    
    public void setOptionUpdate(Map<String, Object> params) throws Exception {
    	update("CommonOptionDAO.updateOptionValue", params);
    }
    
    public List<Map<String, Object>> getLoginOptionValue(Map<String, Object> mp) throws Exception {
    	List<Map<String, Object>> optionLoginValue = list("CommonOptionDAO.selectLoginOptionValue", mp);
    	
    	return optionLoginValue;
    }
    
    public Map<String, Object> getErpOptionValue(Map<String, Object> params) throws Exception {
    	Map<String, Object> optionErpValue = (Map<String, Object>)select("CommonOptionDAO.selectErpOptionValue", params);
    	
    	return optionErpValue;
    }
    
    public Map<String, Object> getGroupOptionValue(Map<String, Object> params) throws Exception {
    	Map<String, Object> optionErpValue = (Map<String, Object>)select("CommonOptionDAO.selectGroupOptionValue", params);
    	
    	return optionErpValue;
    }
    
    public List<Map<String, Object>> getErpEmpOptionValue(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> optionErpEmpValue = list("CommonOptionDAO.selectErpEmpOptionValue", params);
    	
    	return optionErpEmpValue;
    }
    
    public void resetEmpPwdDate(Map<String, Object> params) throws Exception {
    	update("CommonOptionDAO.resetEmpPwdDate", params);
    }    
    
    public void changeOrderDutyPosition(Map<String, Object> params) throws Exception {
    	update("CommonOptionDAO.changeOrderDutyPosition", params);
    }
    
    public List<Map<String, Object>> getErpSyncCompList(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> erpSyncCompList = new ArrayList<Map<String, Object>>();
    	
    	erpSyncCompList = list("CommonOptionDAO.getErpSyncCompList", params);
    	
    	return erpSyncCompList;
    }
    
    public Map<String, Object> getNewErpSyncComp(Map<String, Object> params) throws Exception {
    	Map<String, Object> newErpSyncComp = new HashMap<String, Object>();
    	
    	newErpSyncComp = (Map<String, Object>)select("CommonOptionDAO.getNewErpSyncComp", params);
    	
    	return newErpSyncComp;
    }
    
    public Map<String, Object> getGroupOptionList(Map<String, Object> params) throws Exception {
    	Map<String, Object> optionObject = new HashMap<String, Object>();
    	List<Map<String, Object>> optionList = list("CommonOptionDAO.getGroupOptionList", params);
    	
    	if(optionList != null && optionList.size() > 0){
			for(Map<String,Object> map : optionList) {
				optionObject.put(map.get("optionId").toString(), map.get("optionValue").toString());
			}
    	}
    	
    	return optionObject; 
    }    
    
    public void changePasswdStausCode(Map<String, Object> params) throws Exception {
    	update("commonOptionDAO.changePasswdStausCode", params);
    }
    
    public void changeEmpPwdDate(Map<String, Object> params) throws Exception {
    	update("commonOptionDAO.changeEmpPwdDate", params);
    }

	public void changeBizDisplayYn(Map<String, Object> params) {
		update("commonOptionDAO.changeBizDisplayYn", params);
	}
}
 

