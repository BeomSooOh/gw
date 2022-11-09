package neos.cmm.systemx.alarm.admin.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;











import org.springframework.stereotype.Service;

import main.web.BizboxAMessage;
import neos.cmm.systemx.alarm.admin.service.AlarmAdminService;
import neos.cmm.systemx.alarm.admin.vo.AlarmAdminVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("AlarmAdminService")
public class AlarmAdminServiceImpl implements AlarmAdminService{
	@Resource(name="AlarmAdminDAO")
	private AlarmAdminDAO alarmAdminSql;
	
	@Override
	public List<Map<String, Object>> getAlarmMenu(Map<String, Object> paramMap) {
		List<Map<String, Object>> resultMap = alarmAdminSql.selectAlarmMenu(paramMap);
		
		Map<String, Object> all = new HashMap<String, Object>();
		
		// 전체 메뉴 항목 추가
		all.put("orderNum", "0");
		all.put("flag1","ALL");
		all.put("flag2", BizboxAMessage.getMessage("TX000000862","전체"));
		
		resultMap.add(0, all);

		return resultMap;
	}
	
	@Override
	public List<Map<String, Object>> getAlarmMenuDetail(Map<String, Object> paramMap) {
		List<Map<String, Object>> resultMap = null;
		
		// 메뉴 code값 포함
		if(paramMap.get("codeValue") != null) {
			paramMap.put("codeValue", paramMap.get("codeValue"));
		}
		
		resultMap = alarmAdminSql.selectAlarmMenuDetail(paramMap);
		
		return resultMap;
	}
	
	@Override
	public List<Map<String, Object>> getAlarmMasterSetting(Map<String, Object> paramMap) {
		List<Map<String, Object>> resultMap = null;
		
		resultMap = alarmAdminSql.selectAlarmMasterSetting(paramMap);
		
		return resultMap;
	}
	
	@Override
	public void updateAlarmDetail(Map<String, Object> paramMap, String userID, String groupSeq, String compSeq) {
		AlarmAdminVO alarmAdminVO = new AlarmAdminVO();
		
		// String to JsonArray Convert (스트링을 JSON 객체 배열로 변환 )
		JSONArray array = JSONArray.fromObject(paramMap.get("paramMap"));
		
		// JsonArray to JsonObject ( JSON 객체 배열을 JSON 객체로 변환 )
		for(Object object : array) {
			JSONObject jsonStr = (JSONObject) JSONSerializer.toJSON(object);
			jsonStr.put("uniqID", userID);
			jsonStr.put("groupSeq", groupSeq);
			
			if(jsonStr.get("compSeq") == null) {
				jsonStr.put("compSeq", compSeq);
				alarmAdminVO.setCompSeq((String)jsonStr.get("compSeq"));
			} else {
				alarmAdminVO.setCompSeq((String)jsonStr.get("compSeq"));
			}
			//jsonStr.put("compSeq", compSeq);
			
			// 필요 정보들 VO객체에 넣어주기
			
			alarmAdminVO.setGroupSeq((String)jsonStr.get("groupSeq"));
			alarmAdminVO.setAlertType((String)jsonStr.get("alertType"));
			alarmAdminVO.setAlertYN((String)jsonStr.get("alert_yn"));
			alarmAdminVO.setPushYN((String)jsonStr.get("push_yn"));
			alarmAdminVO.setTalkYN((String)jsonStr.get("talk_yn"));
			alarmAdminVO.setMailYN((String)jsonStr.get("mail_yn"));
			alarmAdminVO.setSmsYN((String)jsonStr.get("sms_yn"));
			alarmAdminVO.setPortalYN((String)jsonStr.get("portal_yn"));
			alarmAdminVO.setTimelineYN((String)jsonStr.get("portal_yn"));
			alarmAdminVO.setModifySeq((String)jsonStr.get("uniqID"));
			
			alarmAdminSql.updateAlarmDetail(alarmAdminVO);
		}
	}
	
	@Override
	public List<Map<String, Object>> getModuleAlarmList(Map<String, Object> paramMap) {
		List<Map<String, Object>> resultMap = null;
		
		resultMap = alarmAdminSql.selectAlarmModule(paramMap);
		
		return resultMap;
	}
	
	@Override
	public void alarmSettingCheck(Map<String, Object> paramMap) {
		List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();

		result = alarmAdminSql.alarmSettingCheck(paramMap);
		
		if(result != null) {
			for(Map<String, Object> newCode : result) {
				//System.out.println(newCode);
				newCode.put("compSeq", paramMap.get("compSeq"));
				newCode.put("groupSeq", paramMap.get("groupSeq"));
				alarmAdminSql.alarmSetting(newCode);
			}
				
		} 
		
	}
}
