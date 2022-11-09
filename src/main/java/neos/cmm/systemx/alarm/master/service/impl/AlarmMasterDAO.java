package neos.cmm.systemx.alarm.master.service.impl;

import java.util.List;
import java.util.Map;

import neos.cmm.systemx.alarm.master.vo.AlarmMasterVO;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("AlarmMasterDAO")
public class AlarmMasterDAO extends EgovComAbstractDAO{
	// 회사별 알림 조회
	public List<Map<String, Object>> selectAlarmInfo(Map<String, Object> params) throws Exception {
		List<Map<String,Object>> result = null;
		result = (List<Map<String,Object>>) list("alarmMasterAdmin.selectAlarmInfo", params);
		
		return result;
	}
	
	// 알림 설정
	public void updateAlarm(AlarmMasterVO alarmMasterVO) {
		update("alarmMasterAdmin.updateAlarm", alarmMasterVO);
	}
	
	// 마스터 설정에 따른 알림 세부 사항 setting 작업
	public void updateAlarmAdmin(AlarmMasterVO alarmMasterVO) {
		update("alarmMasterAdmin.updateAlarmAdmin", alarmMasterVO);
	}
}

