package neos.cmm.erp.dao;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import neos.cmm.erp.dao.gerp.ErpGerpOrgchartDAOImpl;
import neos.cmm.erp.dao.icube.ErpICubeOrgchartDAOImpl;
import neos.cmm.erp.dao.iu.ErpIuOrgchartDAOImpl;

public class ErpOrgchartDAOCreator {
	
	private static final Log LOG = LogFactory.getLog(ErpOrgchartDAOCreator.class);
	
	
	
	public static ErpOrgchartDAO newInstanceDao(Map<String, Object> erpDbInfo) {
		LOG.debug("newInstanceDao");
		
		LOG.debug("erpDbInfo : " + erpDbInfo);
		
		ErpOrgchartDAO erpOrgchartDAO = null;
		
		if (erpDbInfo != null) {
			String erpType = erpDbInfo.get("erpType")+""; 
			if(erpType.toLowerCase().equals("icube")) {
				erpOrgchartDAO = new ErpICubeOrgchartDAOImpl(erpDbInfo);
			}
			else if(erpType.toLowerCase().equals("iu")) {
				erpOrgchartDAO = new ErpIuOrgchartDAOImpl(erpDbInfo);
			}
			else if(erpType.toLowerCase().equals("gerp")) {
				erpOrgchartDAO = new ErpGerpOrgchartDAOImpl(erpDbInfo);
			}
		}
		
		return erpOrgchartDAO;
	}
	
	
}
