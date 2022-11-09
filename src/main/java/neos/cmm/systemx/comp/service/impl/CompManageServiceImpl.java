package neos.cmm.systemx.comp.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.comp.service.CompManageService;

@Service("CompManageService")
public class CompManageServiceImpl implements CompManageService{
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Override
	public List<Map<String, Object>> getCompList(Map<String, Object> paramMap) {
		return commonSql.list("CompManage.getCompList", paramMap);
	}

	@Override
	public Map<String, Object> getComp(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("CompManage.getComp", paramMap);
	}
	
	@Override
	public Map<String, Object> getCompAdmin(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("CompManage.getCompAdmin", paramMap);
	}

	@Override
	public Map<String, Object> getCompMulti(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("CompManage.getCompMulti", paramMap);
	}
	
	@Override
	public Map<String, Object> getCompMultiLang(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("CompManage.getCompMultiLang", paramMap);
	}	

	@Override
	public void updateComp(Map<String, Object> paramMap) {
		commonSql.update("CompManage.updateComp", paramMap);
	}

	@Override
	public void updateCompMulti(Map<String, Object> paramMap) {
		commonSql.update("CompManage.updateCompMulti", paramMap);
	}
	
	@Override
	public void insertCompLang(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.insertCompLang", paramMap);
	}
	
	@Override
	public void insertCompMulti(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.insertCompMulti", paramMap);
	}
	
	@Override
	public void updateCompLang(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.updateCompLang", paramMap);
	}

	@Override
	public Map<String, Object> getGroupCompList(Map<String, Object> params, PaginationInfo paginationInfo) {
		 
		Map<String, Object> map = commonSql.listOfPaging2(params, paginationInfo, "CompManage.getGroupCompList");
		
		return map;
	}

	@Override
	public List<Map<String, Object>> getCompListAuth(Map<String, Object> paramMap) {
		return commonSql.list("CompManage.getCompListAuth", paramMap);
	}

	@Override
	public List<Map<String, Object>> getChildComp(Map<String, Object> paramMap) {
		return commonSql.list("CompManage.getChildComp", paramMap);
	}

	@Override
	public void deleteComp(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteComp", params);
	}

	@Override
	public void deleteCompMulti(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteCompMulti", params);
	}

	@Override
	public Integer getCompDeptExist(Map<String, Object> paramMap) {
		return (Integer) commonSql.select("CompManage.getCompDeptExist", paramMap);
	}

	@Override
	public Map<String, Object> getErpConInfo_ac(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("CompManage.getErpConInfo_ac", params);
	}

	@Override
	public Map<String, Object> getErpConInfo_hr(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("CompManage.getErpConInfo_hr", params);
	}

	@Override
	public Map<String, Object> getErpConInfo_etc(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("CompManage.getErpConInfo_etc", params);
	}

	@Override
	public void dbConnectInfoSave(Map<String, Object> params) {
		commonSql.insert("CompManage.dbConnectInfoSave", params);
	}

	@Override
	public void deleteDbConnectInfo(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteDbConnectInfo", params);
	}

	@Override
	public void updateCompInfo(Map<String, Object> paramMap) {
		commonSql.update("CompManage.updateCompInfo", paramMap);
	}

	@Override
	public Map<String, Object> getCompSmsOption(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("CompManage.selectCompSmsOption", params);
	}

	@Override
	public Map<String, Object> getOrgImg(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("CompManage.selectOrgImg", params);
	}

	@Override
	public Map<String, Object> getTitle(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("CompManage.getTitle", params);
	}

	@Override
	public List<Map<String, Object>> getErpConList(Map<String, Object> params) {
		return commonSql.list("CompManage.getErpConList", params);
	}

	@Override
	public Map<String, Object> getErpEmpInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("CompManage.getErpEmpInfo", params);
	}

	@Override
	public void updateErpEmpInfo(Map<String, Object> params) {
	    String checkWork = EgovStringUtil.isNullToString(params.get("checkWork"));	    
		commonSql.update("CompManage.updateErpEmpInfo", params);
		if(checkWork.equals("Y")){
            updateOtherStatus(params);
        }
	}

	@Override
	public void insertErpEmpInfo(Map<String, Object> params) {
	    String checkWork = EgovStringUtil.isNullToString(params.get("checkWork"));
	    if(params.get("erpEmpNum") == null){
	    	params.put("erpEmpNum", "");
	    }
		commonSql.insert("CompManage.insertErpEmpInfo", params);
		if(checkWork.equals("Y")){
            updateOtherStatus(params);
        }
	}

	@Override
	public List<Map<String, Object>> checkMessengerUseYn(Map<String, Object> params) {
		return commonSql.list("CompMange.checkMessengerUseYn", params);
	}

	@Override
	public void dbConnectInfoDelete(Map<String, Object> params) {
		commonSql.delete("CompManage.dbConnectInfoDelete", params);
	}

	@Override
	public void deleteErpEmpInfo(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteErpEmpInfo", params);
	}

	@Override
	public List<Map<String, Object>> getMyCompList(Map<String, Object> params) {
		return commonSql.list("CompManage.getMyCompList", params);
	}
	
	public void updateOtherStatus(Map<String, Object> params){
	    commonSql.update("CompManage.updateOtherStatus", params);
	}
	
	public String getBizSeq(Map<String, Object> params){
	    return (String)commonSql.select("CompManage.getBizSeq", params);
    }

	@Override
	public void setCompDomain(Map<String, Object> paramMap) {
		commonSql.update("CompManage.setCompDomain", paramMap);
	}
	
	@Override
	public void setBaseAlarm(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.setBaseAlarm", paramMap);
	}
	
	@Override
	public void setBaseAlarmAdmin(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.setBaseAlarmAdmin", paramMap);
	}

	@Override
	public void insertGrouppingComp(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.insertGrouppingComp", paramMap);
	}

	@Override
	public void deleteGrouppingComp(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteGrouppingComp", params);
	}

	@Override
	public void insertBizInfo(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.insertBizInfo", paramMap);
	}

	@Override
	public void insertBizMultiInfo(Map<String, Object> paramMap) {
		commonSql.insert("CompManage.insertBizMultiInfo", paramMap);
	}

	@Override
	public void deleteBizInfo(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteBizInfo", params);
	}

	@Override
	public void deleteBizMultiInfo(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteBizMultiInfo", params);
	}

    @Override
    public Map<String, Object> getTeamWorkInfo(Map<String, Object> params) {        
        return (Map<String, Object>) commonSql.select("CompManage.getTeamWorkInfo", params);
    }

	@Override
	public void deleteErpCompInfo(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteErpCompInfo", params);
		
	}

	@Override
	public void insertErpCompInfo(Map<String, Object> params) {
		commonSql.insert("CompManage.insertErpCompInfo", params);		
	}

	@Override
	public void updateErpEmpCheckWorkInfo(Map<String, Object> params) {
		commonSql.insert("CompManage.updateErpEmpCheckWorkInfo", params);
	}

	@Override
	public void deleteMsgLinkInfo(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteMsgLinkInfo", params);		
	}

	@Override
	public void setBaseDateInfo(Map<String, Object> para) {
		commonSql.insert("CompManage.setBaseDateInfo", para);
	}

	@Override
	public void updateCompEaType(Map<String, Object> params) {
		commonSql.update("CompManage.updateCompEaType", params);		
	}

	@Override
	public void deleteAuthCode(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteAuthCode", params);		
	}

	@Override
	public void deleteAuthCodeMulti(Map<String, Object> params) {
		commonSql.delete("CompManage.deleteAuthCodeMulti", params);	
	}

	@Override
	public List<Map<String, Object>> getEmpErpCompList(Map<String, Object> params) {
		return commonSql.list("CompManage.getEmpErpCompList", params);
	}
	
	@Override
	public Map<String, Object> getCompMailUrl(Map<String, Object> params) {
		return (Map<String, Object>)commonSql.select("CompManage.getCompMailUrl", params);
	}

	@Override
	public List<Map<String, Object>> getCompListGroupping(Map<String, Object> params) {
		return commonSql.list("CompManage.getCompListGroupping", params);
	}

} 
