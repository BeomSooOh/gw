package neos.cmm.systemx.alarm.master.service;

import java.util.List;
import java.util.Map;

public interface AlarmMasterService {
	/**
	 * 회사별 알림 정보 조회
	 * @param params
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, Object>> getAlarmInfoList(Map<String, Object> params) throws Exception;
	
	/**
	 * 회사 별 알림 설정 값 저장(수정)
	 * @param params (회사 별 알림 체크 박스 정보)
	 * @param userID 사용자 아이디
	 * @param groupSeq 그룹 아이디
	 */
	public void updateAlarm(Map<String,Object> params, String userID, String groupSeq);
}
