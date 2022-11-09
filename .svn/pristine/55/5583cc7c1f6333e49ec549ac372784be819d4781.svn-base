package neos.cmm.systemx.empdept.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.empdept.service.EmpDeptManageService;


@Service("EmpDeptManageService")
public class EmpDeptManageServiceImpl implements EmpDeptManageService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Override
	public void deleteEmpDept(Map<String, Object> params) {
		commonSql.delete("EmpDeptManage.deleteEmpDept", params);
		commonSql.delete("EmpDeptManage.deleteEmpDeptMulti", params);
	}

	@Override
	public void updateEmpAuth(Map<String, Object> paramsMap) {
		commonSql.update("EmpDeptManage.updateEmpAuth", paramsMap);
	}
	
	@Override
	public void deleteEmpAuth(Map<String, Object> params) {
		commonSql.delete("EmpDeptManage.deleteEmpDeptAuthInit", params);
//		commonSql.delete("EmpDeptManage.deleteEmpDeptAuth", params);		
	}

	@Override
	public void insertBaseAuth(Map<String, Object> params) {
		commonSql.delete("EmpDeptManage.insertBaseAuth", params);		
	}

	@Override
	public void setMessengerUseYn(Map<String, Object> params) {		
		commonSql.update("EmpDeptManage.setMessengerUseYn", params);
	}

	@Override
	public void setMessengerUseYnMainDept(Map<String, Object> params) {
		commonSql.update("EmpDeptManage.setMessengerUseYnMainDept", params);
	}

	@Override
	public void updateMessengerUseYn(Map<String, Object> params) {
		commonSql.update("EmpDeptManage.updateMessengerUseYn", params);		
	}

	@Override
	public void setMessengerDisplayYn(Map<String, Object> params) {
		commonSql.update("EmpDeptManage.setMessengerDisplayYn", params);
	}

	@Override
	public int checkMainDept(Map<String, Object> params) {
		return (int) commonSql.select("EmpDeptManage.checkMainDept", params);
	}

	@Override
	public void setMainDept(Map<String, Object> params) {
		commonSql.update("EmpDeptManage.setMainDept", params);
	}

	@Override
	public int checkEmpDeptInfo(Map<String, Object> params) {
		return (int) commonSql.select("EmpDeptManage.checkEmpDeptInfo", params);
	}

	@Override
	public int selectEmpDeptCnt(Map<String, Object> params) {
		return (int) commonSql.select("EmpDeptManage.selectEmpDeptCnt", params);
	}

	@Override
	public void updateMainDeptYn(Map<String, Object> params) {
		commonSql.update("EmpDeptManage.updateMainDeptYn", params);
	}

	@Override
	public Map<String, Object> selectEmpDeptInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("EmpDeptManage.selectEmpDeptInfo", params);
	}

	@Override
	public void updateErpEmpInfo(Map<String, Object> params) {
		commonSql.update("EmpDeptManage.updateErpEmpInfo", params);
	}

	@Override
	public void setEmpMainCompSeq(Map<String, Object> map) {
		commonSql.update("EmpDeptManage.setEmpMainCompSeq", map);
	}

	@Override
	public void updateEmpAuthor(Map<String, Object> params) {
		commonSql.update("EmpDeptManage.updateEmpAuthor", params);
	}
	
	@Override
	public List<Map<String, Object>> empDeptChangeCheck(Map<String, Object> params) {
		return (List<Map<String, Object>>) commonSql.list("EmpDeptManage.empDeptChangeCheck", params);
	}

	@Override
	public Map<String, Object> selectEmpMoveHistoryData(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "EmpDeptManage.SelectEmpMoveHistory");
	}

	@Override
	public String getMainCompYn(Map<String, Object> params) {
		return (String) commonSql.select("EmpDeptManage.getEmpMainCompYn", params);
	}

	@Override
	public String getMainDeptSeq(Map<String, Object> params) {
		return (String) commonSql.select("EmpDeptManage.getMainDeptSeq", params);
	}

}
