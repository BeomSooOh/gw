package neos.cmm.systemx.alarm.admin.service;

import java.util.List;
import java.util.Map;

public interface AlarmAdminService {

	public List<Map<String, Object>> getAlarmMenu(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> getAlarmMenuDetail(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> getAlarmMasterSetting(Map<String, Object> paramMap);
	
	public void updateAlarmDetail(Map<String, Object> paramMap, String userID, String groupSeq, String compSeq);
	
	public List<Map<String, Object>> getModuleAlarmList(Map<String, Object> paramMap);
	
	public void alarmSettingCheck(Map<String, Object> paramMap);
}
