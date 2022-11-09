package neos.cmm.systemx.commonOption.service.logic;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import bizbox.orgchart.util.JedisClient;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.service.EgovFileMngService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.commonOption.service.dao.CommonOptionManageDAO;
import neos.cmm.systemx.commonOption.vo.CommonOptionManageVO;
import neos.cmm.util.code.CloudCommonCodeUtil;


@Service("CommonOptionManageService")
public class CommonOptionManageServiceLogic implements CommonOptionManageService {

    @Resource(name = "CommonOptionDAO")
    private CommonOptionManageDAO commonOptionDAO;
    
    @Resource(name = "EgovFileMngService")
    private EgovFileMngService fileService;
    
    
	public  CommonOptionManageVO  selectCommonOption() throws Exception	{
		CommonOptionManageVO resultMap = commonOptionDAO.selectCommonOption();
		return resultMap;
	}    
    

    public String insertCommonOption(CommonOptionManageVO cmManageVO) throws Exception {
    	return commonOptionDAO.insertCommonOption(cmManageVO);
    }
        
    public String updateCommonOption(CommonOptionManageVO cmManageVO)  throws Exception{
    	return commonOptionDAO.updateCommonOption(cmManageVO);
    }    
    
    public List<Map<String, Object>> getCompList(Map<String, Object> params) throws Exception{
    	return commonOptionDAO.getCompList(params);
    }
    
    public List<Map<String, Object>> getOptionList(Map<String, Object> params) throws Exception{
    	List<Map<String, Object>> optionList = commonOptionDAO.getOptionList(params);
    	Map<String, Object> root = new HashMap<String, Object>();
    	List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();

    	// 루트 노드 만들기
    	for(Map<String, Object> item : optionList) {
			if(item.get("optionLevel").equals("1")) {
				item.put("children", new ArrayList<Map<String, Object>>());
				root.put(item.get("optionId").toString(), item);	
			} else if(!item.get("optionLevel").equals("1") && item.get("pOptionId") != null) {
				item.put("children", new ArrayList<Map<String, Object>>());
				root.put(item.get("optionId").toString(), item);
			}
    	}
    	
    	// 루트 노드 하위것들 만들기
    	for(Map<String, Object> item : optionList) {
    		
    		if(item.get("pOptionId") != null) {
    			if(Integer.parseInt(item.get("optionLevel").toString()) > 1) {
    				((ArrayList<Map<String, Object>>)
    						((Map<String,Object>) 
    								root.get(item.get("pOptionId"))
    						)
    						.get("children")
    				)
    				.add(item);
    			}
			}	
    	}
    	
		TreeMap treeMap = new TreeMap(root);
		Iterator treeMapIter = treeMap.keySet().iterator();
		while(treeMapIter.hasNext()){
			String key = (String)treeMapIter.next();
			Object value = (Object)treeMap.get(key);
			Map<String,Object> result = new HashMap<String,Object>();
			result.put("optionId", key);
			result.put("value", value);
			list.add(result);
		}

		
    	return list;
    }
    
    public List<Map<String, Object>> getOptionSettingValue(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> optionValue = null;
    	
    	optionValue = commonOptionDAO.getOptionSettingValue(params);
    	
    	
    	return optionValue;
    }
    
    public void setOptionSave(Map<String, Object> params) throws Exception {
    	//params.put("optionId", "CM200");
    	params.put("compare", "compare");
    	List<Map<String, Object>> optionList = commonOptionDAO.getOptionList(params);
    	
    	String gubun = "insert";
    	
    	for(Map<String,Object> item : optionList) {
    		if(item.get("optionValueReal") != null) {
    			gubun = "update";
    		} else {
    			gubun = "insert";
    		}
    	}
    	
    	if(gubun.equals("insert")) {
    		commonOptionDAO.setOptionInsert(params);
    	} else {
    		commonOptionDAO.setOptionUpdate(params);
    	}
    }
    
    // 로그인 설정 값 가져오기
    public List<Map<String, Object>> getLoginOptionValue(Map<String, Object> mp) throws Exception {
    	List<Map<String, Object>> optionLoginValue = null;
    	
    	optionLoginValue = commonOptionDAO.getLoginOptionValue(mp);
    	
    	return optionLoginValue;
    }
    
    // ERP 조직도 옵션 값 가져오기
    public Map<String, Object> getErpOptionValue(Map<String, Object> params) throws Exception {
    	Map<String, Object> optionErpValue = null;
    	
    	optionErpValue = commonOptionDAO.getErpOptionValue(params);
    	
    	return optionErpValue;
    }
    
    // Erp 사원등록 옵션 값 가져오기
    public List<Map<String, Object>> getErpEmpOptionValue(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> optionErpEmpValue = null;
    	
    	optionErpEmpValue = commonOptionDAO.getErpEmpOptionValue(params);
    	
    	return optionErpEmpValue;
    }
    
    public void resetEmpPwdDate(Map<String, Object> params) throws Exception {
    	commonOptionDAO.resetEmpPwdDate(params);
    }    
    
    public void changeOrderDutyPosition(Map<String, Object> params) throws Exception {
    	// optionValue 0: 직급 / 1: 직책
    	if(params.get("optionValue").equals("0")) {
    		params.put("dutyPositionOption", "position");
    	} else {
    		params.put("dutyPositionOption", "duty");
    	}
    	
    	commonOptionDAO.changeOrderDutyPosition(params);
    }
    
    // Erp 연동된 회사 가져오기
    public List<Map<String, Object>> getErpSyncCompList(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> erpSyncCompList = new ArrayList<Map<String, Object>>();
    	
    	erpSyncCompList = commonOptionDAO.getErpSyncCompList(params);
    	
    	return erpSyncCompList;
    }
    
    // Erp 새로운 회사 
    public Map<String, Object> getNewErpSyncComp(Map<String, Object> params) throws Exception {
    	Map<String, Object> newErpSyncComp = new HashMap<String, Object>();
    	
    	newErpSyncComp = commonOptionDAO.getNewErpSyncComp(params);
    	
    	return newErpSyncComp;
    }
    
    // 그룹 옵션 값 가져오기
    public Map<String, Object> getGroupOptionValue(Map<String, Object> params) throws Exception {
    	Map<String, Object> optionGroupValue = null;
    	
    	optionGroupValue = commonOptionDAO.getGroupOptionValue(params);
    	
    	return optionGroupValue;
    }
    
    // 그룹 옵션리스트 가져오기
    public Map<String, Object> getGroupOptionList(Map<String, Object> params) throws Exception {
    	return commonOptionDAO.getGroupOptionList(params);
    }    
    
    // 비밀번호 설정 규칙 변경
    public void changePasswdStausCode(Map<String, Object> params) throws Exception {
    	commonOptionDAO.changePasswdStausCode(params);
    }
    
    // 만료기간 수정
    public void changeEmpPwdDate(Map<String, Object> params) throws Exception {
    	commonOptionDAO.changeEmpPwdDate(params);
    }

    
    // 조직도 사업장 조직도 일괄 표시/미표시 적용
	@Override
	public void changeBizDisplayYn(Map<String, Object> params) {
		commonOptionDAO.changeBizDisplayYn(params);
	}
	
	// 공통옵션 설정값 조회(REDIS/DB)
	public String getCommonOptionValue(String groupSeq, String compSeq, String optionId) throws Exception {
		
		String returnVal = CloudCommonCodeUtil.cmmGetOptionValue(groupSeq, compSeq, optionId);
		
		if(returnVal == null || returnVal.equals("")) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("groupSeq", groupSeq);
			param.put("compSeq", compSeq);
			param.put("optionId", optionId);
			
			@SuppressWarnings("unchecked")
			Map<String,Object> optionInfo = (Map<String, Object>) commonOptionDAO.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", param);
			
			if(optionInfo != null) {
				returnVal = optionInfo.get("val").toString();
			}
		}
				
		return returnVal;
		
	}
	
	public void rebuildCommonOptionList(String groupSeq) {
		JedisClient jedis = CloudConnetInfo.getJedisClient();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", groupSeq);
		param.put("type", "cm");
		List<Map<String, String>> optionList = (List<Map<String, String>>) commonOptionDAO.list("commonOptionDAO.getCommonOptionList", param);
		
		jedis.initCMOptionCode(groupSeq, "CM", optionList);
	}
	
}
 

