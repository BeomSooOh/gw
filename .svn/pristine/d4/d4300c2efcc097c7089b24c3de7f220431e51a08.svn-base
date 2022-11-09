package neos.cmm.systemx.commonOption.service;

import java.util.List;
import java.util.Map;

import neos.cmm.systemx.commonOption.vo.CommonOptionManageVO;
/**
 *<pre>
 * 1. Package Name	: neos.cmm.system.commonOption.vo
 * 2. Class Name	: CommonOptionManageVO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2013. 7. 16.     doban7       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

public interface CommonOptionManageService {

	public CommonOptionManageVO selectCommonOption() throws Exception;    
	public String insertCommonOption(CommonOptionManageVO cmManageVO) throws Exception;  
	public String updateCommonOption(CommonOptionManageVO cmManageVO)  throws Exception;
	public List<Map<String, Object>> getCompList(Map<String, Object> params) throws Exception;
	public List<Map<String, Object>> getOptionList(Map<String, Object> params) throws Exception;
	public List<Map<String, Object>> getOptionSettingValue(Map<String, Object> params) throws Exception;
	public void setOptionSave(Map<String, Object> params) throws Exception;
	public List<Map<String, Object>> getLoginOptionValue(Map<String, Object> mp) throws Exception;
	Map<String, Object> getErpOptionValue(Map<String, Object> params) throws Exception;
	public List<Map<String, Object>> getErpEmpOptionValue(Map<String, Object> params) throws Exception;
	public void resetEmpPwdDate(Map<String, Object> params) throws Exception;
	public void changeOrderDutyPosition(Map<String, Object> params) throws Exception;
	public List<Map<String, Object>> getErpSyncCompList(Map<String, Object>params) throws Exception;
	public Map<String, Object> getNewErpSyncComp(Map<String, Object> params) throws Exception;
	Map<String, Object> getGroupOptionValue(Map<String, Object> params) throws Exception;
	public Map<String, Object> getGroupOptionList(Map<String, Object> params) throws Exception;
	public void changePasswdStausCode(Map<String, Object> params) throws Exception;
	public void changeEmpPwdDate(Map<String, Object> params) throws Exception;
	public void changeBizDisplayYn(Map<String, Object> params);
	public String getCommonOptionValue(String groupSeq, String compSeq, String optionId) throws Exception;
	public void rebuildCommonOptionList(String groupSeq);
}
 

