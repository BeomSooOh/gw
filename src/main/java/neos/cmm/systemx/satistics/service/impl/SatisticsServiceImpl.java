package neos.cmm.systemx.satistics.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.systemx.satistics.service.SatisticsService;

@Service("SatisticsService")
public class SatisticsServiceImpl implements SatisticsService {
	@Resource(name = "SatisticsDAO")
	private SatisticsDAO satisticsSql;
	
	@Override
	public Map<String, Object> loginSatisticsData(Map<String, Object> params, PaginationInfo paginationInfo) throws Exception {
		Map<String, Object> list = new HashMap<String, Object>();
		
		list = satisticsSql.loginSatisticsData(params, paginationInfo);
		
		return list;
				
	}
	
	@Override
	public Map<String, Object> menuSatisticsData(Map<String, Object> params, PaginationInfo paginationInfo) throws Exception {
		Map<String, Object> list = new HashMap<String, Object>();
		
		return list;
				
	}
	
    @Override
    public Map<String, Object> menuAccessExcelList(Map<String, Object> params, PaginationInfo paginationInfo) throws Exception {
        Map<String, Object> list = new HashMap<String, Object>();
        
        return list;
                
    }
}
