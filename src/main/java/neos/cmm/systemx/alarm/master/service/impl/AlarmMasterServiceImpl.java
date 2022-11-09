package neos.cmm.systemx.alarm.master.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.systemx.alarm.master.service.AlarmMasterService;

import neos.cmm.systemx.alarm.master.vo.AlarmMasterVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.springframework.stereotype.Service;

@Service("AlarmMasterService")
public class AlarmMasterServiceImpl implements AlarmMasterService {
	@Resource(name = "AlarmMasterDAO")
	private AlarmMasterDAO alarmMasterSql;

	/**
	 * 알림 설정 정보 가져오기 getAlarmInfoList
	 * @param params 		
	 * @return resultMap	
	 */
	@Override
	public List<Map<String, Object>> getAlarmInfoList(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> resultMap = alarmMasterSql.selectAlarmInfo(params);

		return resultMap;
	}
	
	/**
	 * 회사 별 알림 설정 값 저장(수정) updateAlarm
	 * @param params 		
	 *              userID		: 유저 아이디
	 *              groupSeq	: 그룹 시퀀스
	 * @return
	 */
	@Override
	public void updateAlarm(Map<String,Object> params, String userID, String groupSeq){
		
		AlarmMasterVO alarmMasterVO = new AlarmMasterVO();
		
		// String to JsonArray Convert (스트링을 JSON 객체 배열로 변환 )
		JSONArray array = JSONArray.fromObject(params.get("paramMap"));
		
		// JsonArray to JsonObject ( JSON 객체 배열을 JSON 객체로 변환 )
		for(Object object : array) {
			JSONObject jsonStr = (JSONObject) JSONSerializer.toJSON(object);
			jsonStr.put("uniqId", userID);
			jsonStr.put("grp_seq", groupSeq);
			
			// 필요 정보들 VO객체에 넣어주기
			alarmMasterVO.setComp_seq((String)jsonStr.get("compSeq"));
			alarmMasterVO.setGrp_seq((String)jsonStr.get("grp_seq"));
			alarmMasterVO.setAlert((String)jsonStr.get("alert"));
			alarmMasterVO.setPush((String)jsonStr.get("push"));			
			alarmMasterVO.setTalk((String)jsonStr.get("talk"));
			alarmMasterVO.setMail((String)jsonStr.get("mail"));
			alarmMasterVO.setSms((String)jsonStr.get("sms"));
			alarmMasterVO.setModify_seq((String)jsonStr.get("uniqId"));
			
			alarmMasterSql.updateAlarm(alarmMasterVO);
			
			// 마스터 설정에 따른 알림 세부 사항 setting 작업
			setAdminAlarm(alarmMasterVO);
		}
	}
	
	/**
	 * 마스터 설정에 따른 알림 세부 사항 setting 작업 : setAdminAlarm
	 * @param alarmMasterVO
	 */
	public void setAdminAlarm(AlarmMasterVO alarmMasterVO) {
		alarmMasterSql.updateAlarmAdmin(alarmMasterVO);
	}
}
