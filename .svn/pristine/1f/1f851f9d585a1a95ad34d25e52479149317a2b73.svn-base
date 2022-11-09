package neos.cmm.erp.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.erp.service.CmmErpDataService;

@Service("CmmErpDataService")
public class CmmErpDataServiceImpl implements CmmErpDataService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@SuppressWarnings({ "unused", "unchecked" })
	private Map<String,Object> setErpDbInfo(Map<String, Object> params) {
		Map<String,Object> erpDbInfo = (Map<String, Object>) commonSql.select("ErpManageDAO.selectErpInfo", params);
		return erpDbInfo;
	}
	
	
	
	
}
