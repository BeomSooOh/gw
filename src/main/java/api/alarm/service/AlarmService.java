package api.alarm.service;

import java.util.Map;

import api.common.model.APIResponse;

public interface AlarmService {

	public APIResponse alarmModuleList(Map<String, Object> paramMap);
	
	public APIResponse saveAlarmModule(Map<String, Object> paramMap);

}
