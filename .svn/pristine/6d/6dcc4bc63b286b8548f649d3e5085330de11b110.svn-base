package api.alarm.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("AlarmDAO")
public class AlarmDAO extends EgovComAbstractDAO {

	public List<Map<String, Object>> getAlarmModuleList(Map<String, Object> paramMap) {
	
		List<Map<String, Object>> result = list("alarmModule.getAlarmModuleList", paramMap);
	
		return result;
	}
	
	public int updateAlarmModule(Map<String, Object> paramMap) {
		return update("alamrModule.updateAlarmModule", paramMap);
	}
}
