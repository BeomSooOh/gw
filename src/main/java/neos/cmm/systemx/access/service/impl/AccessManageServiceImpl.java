package neos.cmm.systemx.access.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.access.service.AccessManageService;
import org.springframework.stereotype.Service;

@Service("AccessManageService")
public class AccessManageServiceImpl implements AccessManageService{

	/* 로그 변수 정의 */
	//private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(this.getClass());
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	
	@Override
	public void accessIpSaveProc(Map<String, Object> params) {
		commonSql.insert("AcessManage.accessIpSaveProc", params);
	}


	@Override
	public int getNewAccessId(Map<String, Object> params) {
		return (int) commonSql.select("AcessManage.getNewAccessId", params);
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAccessIpList(Map<String, Object> params) {
		return commonSql.list("AcessManage.getAccessIpList", params);
	}


	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getAccessIpInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("AcessManage.getAccessIpInfo", params);
	}


	@Override
	public void deleteAccessIp(Map<String, Object> params) {
		commonSql.delete("AcessManage.deleteAccessIp", params);
	}


	@Override
	public void deleteAccessRelate(Map<String, Object> params) {
		commonSql.delete("AcessManage.deleteAccessRelateInfo", params);		
	}

}
