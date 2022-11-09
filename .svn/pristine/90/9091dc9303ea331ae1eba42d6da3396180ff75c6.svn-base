package neos.cmm.systemx.group.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.group.service.GroupManageService;

@Service("GroupManageService")
public class GroupManageServiceImpl implements GroupManageService{
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Override
	public Object insertGroup(Map<String, Object> params) {
		return commonSql.insert("GroupManage.insertGroup", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> selectGroupPathList(
			Map<String, Object> params) {
		return commonSql.list("GroupManage.selectGroupPathList", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void setMasterSecu(Map<String, Object> params) {
		commonSql.update("GroupManage.setMasterSecu", params);
	}	
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectGroupPath(
			Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", params);
	}

	@Override
	public void updateGroupPath(Map<String, Object> paramMap) {
		commonSql.update("GroupManage.updateGroupPath", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> selectGroupContainerList(Map<String, Object> params) {
		return commonSql.list("GroupManage.selectGroupContainerList", params);
	}

	@Override
	public void insertGroupContainer(Map<String, Object> cParams) {
		commonSql.insert("GroupManage.insertGroupContainer", cParams);
		
	}

	@Override
	public Map<String, Object> selectGroupIpInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("GroupManage.selectGroupIpInfo", params);
	}

	@Override
	public void setLoginImgType(Map<String, Object> paramMap) {		
		commonSql.update("GroupManage.setLoginImgType", paramMap);
	}

	@Override
	public List<Map<String, Object>> getLogoImgFile(Map<String, Object> paramMap) {
		return commonSql.list("GroupManage.getLogoImgFile", paramMap);
	}

	@Override
	public List<Map<String, Object>> getBgImgFile(Map<String, Object> paramMap) {
		return commonSql.list("GroupManage.getBgImgFile", paramMap);
	}

	@Override
	public List<Map<String, Object>> getMsgLoginLogoImgFile(Map<String, Object> paramMap) {
		return commonSql.list("GroupManage.getMsgLoginLogoImgFile", paramMap);
	}

	@Override
	public List<Map<String, Object>> getMsgMainTopImgFile(Map<String, Object> paramMap) {
		return commonSql.list("GroupManage.getMsgMainTopImgFile", paramMap);
	}

	@Override
	public List<Map<String, Object>> getPhoneImgFile(Map<String, Object> paramMap) {
		return commonSql.list("GroupManage.getPhoneImgFile", paramMap);
	}

	@Override
	public List<Map<String, Object>> getMainTopLogoImgFile(Map<String, Object> paramMap) {
		return commonSql.list("GroupManage.getMainTopImgFile", paramMap);
	}

	@Override
	public List<Map<String, Object>> getMainFootImgFile(Map<String, Object> paramMap) {
		return commonSql.list("GroupManage.getMainFootImgFile", paramMap);
	}

	@Override
	public Map<String, Object> getOrgDisplayText(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("GroupManage.getOrgDisplayText", paramMap);
	}

	@Override
	public Map<String, Object> getGroupInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", paramMap);
	}

	@Override
	public Map<String, Object> selectPathInfo(Map<String, Object> param) {
		return (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", param);
	}
	
	@Override
	public List<Map<String, Object>> getGroupList(Map<String, Object> param) {
		return (List<Map<String, Object>>) commonSql.list("GroupManage.getGroupList", param); 
	}
	
	@Override
	public void groupSave(Map<String, Object> param) {
		commonSql.insert("GroupManage.groupSave", param);
	}
	
	@Override
	public Map<String, Object> selectGroupSeq() {
		Map<String, Object> mp = new HashMap<String, Object>();
		return (Map<String, Object>) commonSql.select("GroupManage.selectSeq", mp);
	}
	
	@Override
	public void groupDel(Map<String, Object> param) {
		commonSql.delete("GroupManage.groupDel", param);
	}
	
	@Override
	public void groupingCompAdd(Map<String, Object> param) {
		List<Map<String, Object>> compList = (List<Map<String, Object>>) param.get("compList");
		for(Map<String, Object> comp : compList){
			param.put("compSeq", comp.get("compSeq"));
			commonSql.insert("GroupManage.groupingCompAdd", param);
		}		
	}
	
	@Override
	public void groupingCompDel(Map<String, Object> param) {
		commonSql.delete("GroupManage.groupingCompDel", param);
	}
	
	@Override
	public List<Map<String, Object>> groupInfo(Map<String, Object> param) {
		return (List<Map<String, Object>>) commonSql.list("GroupManage.groupInfo", param);
	}
	
	@Override
	public void groupInfoUpdate(Map<String, Object> param) {
		commonSql.update("GroupManager.groupInfoUpdate", param);
	}

	@Override
	public String selectGroupLangCode(Map<String, Object> param) {
		return (String) commonSql.select("GroupManager.selectGroupLangCode", param);
	}
	
	@Override
	public void updateBgType(Map<String, Object> param) {
		commonSql.update("GroupManager.updateBgType", param);
	}	
}
