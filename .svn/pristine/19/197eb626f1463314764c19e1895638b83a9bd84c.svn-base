package neos.cmm.erp.dao.icube;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.AbstractInterlockSqlSession;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.erp.dao.ErpOrgchartDAO;

public class ErpICubeOrgchartDAOImpl extends AbstractInterlockSqlSession implements ErpOrgchartDAO, ErpICubePictureDAO{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	public ErpICubeOrgchartDAOImpl(){
		
	}
	
	public ErpICubeOrgchartDAOImpl(Map<String, Object> erpDbInfo) {
		setSqlSession(erpDbInfo);
	}
	
	@Override
	public void setSqlSession(Map<String, Object> params) {
		String dbType = params.get("databaseType")+"";
		String url = params.get("url")+"";
		String username = params.get("userid")+"";
		String password = params.get("password")+"";
		String pakage = "neos.cmm.erp.sqlmap";
		String erpType = params.get("erpType")+"";
		pakage += "."+erpType;
		
		createSqlSession(dbType, url, username, password, pakage);
		
	}

	@Override
	public List<Map<String, Object>> selectErpJobCodeList(Map<String, Object> params) {
		params.put("moduleCd", "H");//인사
		params.put("ctrlCd", "G2"); //직종
		params.put("aliasCode", "erpCode");
		params.put("aliasName", "erpCodeName");
		 
		return selectSCtrlList(params);
	}

	@Override
	public List<Map<String, Object>> selectErpEmpWorkCodeList(Map<String, Object> params) {
		
		params.put("moduleCd", "H");//인사
		params.put("ctrlCd", "HE"); //재직구분
		params.put("aliasCode", "erpCode");
		params.put("aliasName", "erpCodeName");
		
		return selectSCtrlList(params);
	}

	@Override
	public List<Map<String, Object>> selectErpDeptList(Map<String, Object> params) {
		return selectList("selectSDeptList", params);
	}

	@Override
	public List<Map<String, Object>> selectErpBizList(Map<String, Object> params) {
		return selectList("selectZaDivList", params);
	}

	@Override
	public List<Map<String, Object>> selectErpCompList(Map<String, Object> params) {
		return selectList("selectZaCompList", params);
	}

	@Override
	public List<Map<String, Object>> selectErpDeptPathList(Map<String, Object> params) {
		return selectList("selectSDeptPathList", params);
	}

	@Override
	public String selectErpCurrentTime() {
		Map<String,Object> map = selectOne("selectIcubeCurrentTime", null);
		
		String currentTime = null;
		
		if(map != null) {
			currentTime = (String)map.get("currentTime");
		}
		
		return currentTime;
	}

	@Override
	public List<Map<String, Object>> selectErpEmpList(Map<String, Object> params) {
		return selectList("selectSEmpList", params);
	}

	@Override
	public Map<String, Object> selectErpEmpListOfPage(Map<String, Object> params, PaginationInfo paginationInfo) {
		return selectListOfPage("selectSEmpList", params, paginationInfo);
	}

	@Override
	public void updateErpSyncGwUpdateDate(Map<String, Object> params) {
		updateSgwLogDeptGwUpdateDate(params);
		updateErpSyncEmpGwUpdateDate(params);
	}

	@Override
	public List<Map<String, Object>> selectErpDutyCodeList(Map<String, Object> params) {
		params.put("moduleCd", "H");//인사
		params.put("ctrlCd", "G3"); //직책
		
		return selectSCtrlList(params);
	}

	@Override
	public List<Map<String, Object>> selectErpPositionCodeList(Map<String, Object> params) {
		params.put("moduleCd", "H");//인사
		params.put("ctrlCd", "G4");//직급
		
		return selectSCtrlList(params);
	}

	@Override
	public void updateErpSyncFailGwUpdateDate(Map<String, Object> params) {
		updateErpSyncEmpGwUpdateDate(params);
	}

	@Override
	public void updateErpSyncEmpGwUpdateDate(Map<String, Object> params) {
		update("updateSgwLogEmpGwUpdateDate", params);
		
	}
	
	public void updateSgwLogDeptGwUpdateDate(Map<String, Object> params) {
		update("updateSgwLogDeptGwUpdateDate", params);
		
	}
	
	public List<Map<String,Object>> selectSCtrlList(Map<String, Object> params) {
		
		return selectList("selectSCtrlList", params);
		
	}

	@Override
	public Map<String, Object> selectICubePictureInfo(Map<String, Object> params) {
		return selectOne("selectPictureInfo", params);
	}

	@Override
	public List<Map<String, Object>> selectErpCustom(Map<String, Object> params) {
		return selectList("selectCustomList", params);
	}

	@Override
	public Map<String, Object> selectErpCompListOfPage(Map<String, Object> params, PaginationInfo paginationInfo) {
		return null;
	}
	
	@Override
	public List<Map<String, Object>> selectErpProjectList(Map<String, Object> params) {
		return selectList("selectErpProjectList", params);
	}	
	
	@Override
	public List<Map<String, Object>> selectErpPartnerList(Map<String, Object> params) {
		return selectList("selectErpPartnerList", params);
	}		
	
	@Override
	public List<Map<String, Object>> selectErpDeptDeleteList(Map<String, Object> params) {
		return selectList("selectErpDeptDeleteList", params);
	}
	
	@Override
	public void updateErpEmpGwUpdateDate(Map<String, Object> params) {
		update("updateICubeEmpGwUpdateDate", params);
	}
}
