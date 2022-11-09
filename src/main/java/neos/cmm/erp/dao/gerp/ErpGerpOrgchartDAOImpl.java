package neos.cmm.erp.dao.gerp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.AbstractInterlockSqlSession;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.erp.dao.ErpOrgchartDAO;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;

public class ErpGerpOrgchartDAOImpl extends AbstractInterlockSqlSession implements ErpOrgchartDAO{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "CommonOptionManageService")
	private CommonOptionManageService commonOptionManageService;
	
	public ErpGerpOrgchartDAOImpl(){
		
	}
	
	public ErpGerpOrgchartDAOImpl(Map<String, Object> erpDbInfo) {
		setSqlSession(erpDbInfo);
	}

	@Override
	public void setSqlSession(Map<String,Object> params) {
		String dbType = params.get("databaseType")+"";
		String url = params.get("url")+"";
		String username = params.get("userid")+"";
		String password = params.get("password")+"";
		String pakage = "neos.cmm.erp.sqlmap";
		String erpType = params.get("erpType")+"";
//		String databaseType = params.get("databaseType")+"";
		pakage += "."+erpType;
		// pakage += "."+databaseType;
		
//		System.out.println(pakage);
		
		createSqlSession(dbType, url, username, password, pakage);
		
	}
	
	public Map<String,Object> selectCurrentTime(Map<String,Object> params) {
		return selectOne("selectCurrentTime", params);
	}
	public List<Map<String, Object>> selectMaDeptList(Map<String,Object> params) {
		return selectList("selectMaDeptList", params);
	}
	
	public List<Map<String, Object>> selectMaUserList(Map<String,Object> params) {
		return selectList("selectMaUserList", params);
	}
	
	public List<Map<String, Object>> selectHrPhotoList(Map<String,Object> params) {
		return selectList("selectHrPhotoList", params);
	}
	
	public List<Map<String, Object>> selectMaEmpList(Map<String,Object> params) {
		return selectList("selectMaEmpList", params);
	}
	public List<Map<String, Object>> selectMaCodedtlList(Map<String,Object> params) {
		return selectList("selectMaCodedtlList", params);
	}
	public List<Map<String, Object>> selectMaDeptGwDelete(Map<String,Object> params) {
		return selectList("selectMaDeptGwDelete", params);
	}
	public List<Map<String, Object>> selectMaUserGwDelete(Map<String,Object> params) {
		return selectList("selectMaUserGwDelete", params);
	}
	public List<Map<String, Object>> selectHrPhotoGwDelete(Map<String,Object> params) {
		return selectList("selectHrPhotoGwDelete", params);
	}
	public List<Map<String, Object>> selectMaEmpGwDelete(Map<String,Object> params) {
		return selectList("selectMaEmpGwDelete", params);
	}
	public List<Map<String, Object>> selectMaCodedtlGwDelete(Map<String,Object> params) {
		return selectList("selectMaCodedtlGwDelete", params);
	}
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args) {
//		ErpGerpOrgchartDAOImpl dao = new ErpGerpOrgchartDAOImpl();
//		
//		Map<String,Object> params = new HashMap<String,Object>();
//		params.put("databaseType","mssql");
//		params.put("url","jdbc:sqlserver://172.16.112.14:11433;databasename=NEOE");
//		params.put("userid","NEOE");
//		params.put("password","NEOE");
//		params.put("erpType","iu");
//		params.put("databaseType","mssql");
//		
//		dao.setSqlSession(params);
//		
//		
////		params.put("cdCompany", "1000");
////		
////		System.out.println(dao.selectCurrentTime(params));
////		System.out.println(dao.selectMaDeptList(params));
////		System.out.println(dao.selectMaUserList(params));
////		System.out.println(dao.selectHrPhotoList(params));
////		System.out.println(dao.selectMaEmpList(params));
////		
////		//직급
//		// params.put("cdField", "HR_H000003");
////		//직책
////		params.put("cdField", "HR_H000002");
////		
////		System.out.println(dao.selectMaCodedtlList(params));
////		System.out.println(dao.selectMaDeptGwDelete(params));
////		System.out.println(dao.selectMaUserGwDelete(params));
////		System.out.println(dao.selectHrPhotoGwDelete(params));
////		System.out.println(dao.selectMaEmpGwDelete(params));
////		System.out.println(dao.selectMaCodedtlGwDelete(params));
//		
//	}

	@Override
	public List<Map<String, Object>> selectErpJobCodeList(Map<String, Object> params) {
		params.put("cdField", "P00990"); // 직군 CD_DUTY_TYPE ->  MA_CODEDTL / CD_MODULE='HR' AND CD_FIELD='P00990'
		params.put("aliasCode", "erpCode");
		params.put("aliasName", "erpCodeName");
		
		return selectMaCodedtlList(params);
	}

	@Override
	public List<Map<String, Object>> selectErpEmpWorkCodeList(Map<String, Object> params) {
//		return selectList("selectErpEmpWorkCodeList", params);
		return null;
	}

	@Override
	public List<Map<String, Object>> selectErpDeptList(Map<String, Object> params) {
		return selectMaDeptList(params);
	}

	@Override
	public List<Map<String, Object>> selectErpBizList(Map<String, Object> params) {
		return selectMaBizList(params);
	}

	private List<Map<String, Object>> selectMaBizList(Map<String, Object> params) {
		return selectList("selectMaBizList", params);
	}

	@Override
	public List<Map<String, Object>> selectErpCompList(Map<String, Object> params) {
		return selectMaCompList(params);
	}

	private List<Map<String, Object>> selectMaCompList(Map<String, Object> params) {
		return selectList("selectMaCompList", params);
	}

	@Override
	public List<Map<String, Object>> selectErpDeptPathList(Map<String, Object> params) {
		return selectMaDeptPathList(params);
	}

	private List<Map<String, Object>> selectMaDeptPathList(Map<String, Object> params) {
		return selectList("selectMaDeptPathList", params);
	}

	@Override
	public String selectErpCurrentTime() {
		Map<String, Object> r = selectOne("selectCurrentTime", null);
		String str = null;
		if (r != null) {
			
			str = r.get("currentTime")+"";
		}
		
		return str;
	}
	
	
	

	@Override
	public List<Map<String, Object>> selectErpEmpList(Map<String, Object> params) {
		
		return selectMaEmpList(params);
	}
	
	
	@Override
	public Map<String, Object> selectErpEmpListOfPage(Map<String, Object> params, PaginationInfo paginationInfo) {

		String firstYn = params.get("firstYn")+"";
		
		/** 최초 동기화여부  */
		params.put("updateErp", firstYn.equals("N") ? "Y" : null);
		
		return selectListOfPage("selectMaEmpList", params, paginationInfo);
	}

	@Override
	public void updateErpSyncGwUpdateDate(Map<String, Object> params) {
		
		updateMaDeptGwUpdateDate(params);
		updateMaEmpGwUpdateDate(params);
		
	}

	private void updateMaEmpGwUpdateDate(Map<String, Object> params) {
		if(params != null) {
			return;
		}
	}

	private void updateMaDeptGwUpdateDate(Map<String, Object> params) {
		if(params != null) {
			return;
		}
	}

	@Override
	public List<Map<String, Object>> selectErpDutyCodeList(Map<String, Object> params) {
		
		// 0:직책, 1: 직위
		if(params.get("dutyType").equals("0")) {
			params.put("cdField","P00980"); // 직책  CD_DUTY_RESP  -> MA_CODEDTL / CD_MODULE='HR' AND CD_FIELD = ‘P00980’
		} else {
			params.put("cdField","P00640"); // 직위  CD_DUTY_RANK -> MA_CODEDTL / CD_MODULE='HR' AND CD_FIELD = ‘P00640’
		}
		
		

		return selectMaCodedtlList(params);
	}

	@Override
	public List<Map<String, Object>> selectErpPositionCodeList(Map<String, Object> params) {
		params.put("cdField","P00650");  // 직급 CD_DUTY_STEP  -> MA_CODEDTL / CD_MODULE='HR' AND CD_FIELD = ‘P00650’

		return selectMaCodedtlList(params);
	}

	@Override
	public void updateErpSyncFailGwUpdateDate(Map<String, Object> params) {
//		updateMaEmpGwUpdateDate(params);
		
	}

	@Override
	public void updateErpSyncEmpGwUpdateDate(Map<String, Object> params) {
//		updateMaEmpGwUpdateDate(params);
	}

	@Override
	public List<Map<String, Object>> selectErpCustom(Map<String, Object> params) {
		return selectList("selectCustomList", params);
	}

	@Override
	public Map<String, Object> selectErpCompListOfPage(Map<String, Object> params, PaginationInfo paginationInfo) {
		String firstYn = params.get("firstYn")+"";
		
		/** 최초 동기화여부  */
		params.put("updateErp", firstYn.equals("N") ? firstYn : null);
		
		return selectListOfPage("selectMaCompList", params, paginationInfo);
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
		return null;
	}
	
	@Override
	public void updateErpEmpGwUpdateDate(Map<String, Object> params) {
		return;
	}
}
