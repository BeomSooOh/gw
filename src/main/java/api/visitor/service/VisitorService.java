package api.visitor.service;

import java.util.List;
import java.util.Map;

public interface VisitorService {
	
	List<Map<String, Object>> getAppvVisitorList(Map<String, Object> request);

	Map<String, Object> insertInHouseVisitorList(Map<String, Object> request) throws Exception ;
	
	Map<String, Object> BatchInOutCheck(Map<String, Object> request) throws Exception;

	Map<String, Object> getVisitorInfo(Map<String, Object> request);

	Map<String, Object> insertQrStayLog(Map<String, Object> param) throws Exception;
}
