package neos.cmm.systemx.satistics.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Repository("SatisticsDAO")
public class SatisticsDAO extends EgovComAbstractDAO {
	
	public Map<String, Object> loginSatisticsData(Map<String, Object> params, PaginationInfo paginationInfo) throws Exception{
		Map<String, Object> list = new HashMap<String, Object>();
		
		// list = (Map<String,Object>) list("Satistics.loginSatistics", params);
		list = (Map<String,Object>)listOfPaging2(params, paginationInfo, "Satistics.loginSatistics");
		return list;
		
	}
	
	public Map<String, Object> menuSatisticsData(Map<String, Object> params, PaginationInfo paginationInfo) throws Exception{
		Map<String, Object> list = new HashMap<String, Object>();
		
		// list = (Map<String,Object>) list("Satistics.loginSatistics", params);
		list = (Map<String,Object>)listOfPaging2(params, paginationInfo, "Satistics.menuSatistics");
		return list;
		
	}

}
