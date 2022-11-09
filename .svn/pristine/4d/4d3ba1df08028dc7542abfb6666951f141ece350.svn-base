package neos.cmm.systemx.alarm.admin.service.impl;

import java.util.List;
import java.util.Map;

import neos.cmm.systemx.alarm.admin.vo.AlarmAdminVO;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("AlarmAdminDAO")
public class AlarmAdminDAO extends EgovComAbstractDAO {
	public List<Map<String, Object>> selectAlarmMenu(Map<String, Object> params) {
		List<Map<String, Object>> result = null;
		
		result = (List<Map<String, Object>>) list("alarmAdminMenu.selectAlarmMenu", params);
		
		return result;
	}
	
	public List<Map<String, Object>> selectAlarmMenuDetail(Map<String, Object> params) {
		
		List<Map<String, Object>> result = null;
		
		result = (List<Map<String, Object>>) list("alarmAdminMenu.selectAlarmMenuDetail", params);
		
		return result;
	}
	
	public List<Map<String, Object>> selectAlarmMasterSetting(Map<String, Object> params) {
		List<Map<String, Object>> result = null;
		
		result = (List<Map<String, Object>>) list("alarmAdminMenu.selectAlarmMasterSetting", params);
		
		return result;
	}
	
	public void updateAlarmDetail(AlarmAdminVO alarmAdminVO) {
		update("alarmMasterAdmin.updateAlarmDetail", alarmAdminVO);
	}
	
	public List<Map<String, Object>> selectAlarmModule(Map<String, Object> params) {
		List<Map<String, Object>> result = null;
		
		result = (List<Map<String, Object>>) list("alarmAdminMenu.selectAlarmModule", params);
		
		return result;
	}
	
	public List<Map<String, Object>> alarmSettingCheck(Map<String, Object> paramMap) {
		List<Map<String, Object>> result = null;
		
		result = (List<Map<String, Object>>)list("alarmAdminMenu.alarmSettingCheck", paramMap);
		return result;
	}
	
	public void alarmSetting(Map<String, Object> param) {
		insert("alarmAdminMenu.alarmSetting", param);
	}
 }
