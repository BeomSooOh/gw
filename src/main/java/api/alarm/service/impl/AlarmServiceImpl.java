package api.alarm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.springframework.stereotype.Service;

import api.alarm.service.AlarmService;
import api.alarm.vo.AlarmVO;
import api.common.model.APIResponse;
import main.web.BizboxAMessage;

@Service("AlarmService")
public class AlarmServiceImpl implements AlarmService{
	
	@Resource(name="AlarmDAO")
	private AlarmDAO alarmSql;
	
	/** 2016.03.08 장지훈 작성
	 * alarmModuleList : 모듈 별 알림 설정 가져오기
	 * @param paramMap
	 * @return
	 */
	public APIResponse alarmModuleList(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");
			
			param.put("groupSeq", header.get("groupSeq"));
			param.put("empSeq", header.get("empSeq"));
			param.put("tId", header.get("tId"));
			param.put("pId", header.get("pId"));
			
			param.put("compSeq", company.get("compSeq"));
			param.put("bizSeq", company.get("bizSeq"));
			param.put("deptSeq", company.get("deptSeq"));
			param.put("emailAddr", company.get("emailAddr"));
			param.put("emailDomain", company.get("emailDomain"));
			
			param.put("langCode", body.get("langCode"));
			param.put("codeValue", body.get("codeValue"));
			
			//System.out.println("service단" + param);
			
			// 항목별 알림 리스트 가져오기
			params.put("alarmList", alarmSql.getAlarmModuleList(param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}
	
	/** 2016.03.08 장지훈 작성
	 * saveAlarmModule : 모듈 별 알림 설정하기
	 * @param paramMap
	 * @return
	 */
	public APIResponse saveAlarmModule(Map<String, Object> paramMap) {
		List<Map<String, Object>> params = null;
		Map<String, Object> param = new HashMap<String, Object>();
		
		AlarmVO alarmVO = new AlarmVO();
		
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> header = (Map<String, Object>)(paramMap.get("header"));
			Map<String, Object> body = (Map<String, Object>)(paramMap.get("body"));
			Map<String, Object> company = (Map<String, Object>)(body.get("companyInfo"));
			List<Map<String, Object>> alarmInfo = (List<Map<String, Object>>)(body.get("alarmInfo"));
			
//			System.out.println("alarmInfo : " + alarmInfo);
			
			
			for(Object object:alarmInfo) {
				JSONObject jsonStr = (JSONObject) JSONSerializer.toJSON(object);
				
				param.put("groupSeq", header.get("groupSeq"));
				param.put("empSeq", header.get("empSeq"));
				param.put("tId", header.get("tId"));
				param.put("pId", header.get("pId"));
				
				param.put("compSeq", company.get("compSeq"));
				param.put("bizSeq", company.get("bizSeq"));
				param.put("deptSeq", company.get("deptSeq"));
				param.put("emailAddr", company.get("emailAddr"));
				param.put("emailDomain", company.get("emailDomain"));
				
				param.put("alarmType", jsonStr.get("alarmType"));
				param.put("alert_yn", jsonStr.get("alert_yn"));
				param.put("push_yn", jsonStr.get("push_yn"));
				param.put("talk_yn", jsonStr.get("talk_yn"));
				param.put("mail_yn", jsonStr.get("mail_yn"));
				param.put("sms_yn", jsonStr.get("sms_yn"));
				param.put("portal_yn", jsonStr.get("portal_yn"));
				param.put("timeline_yn", jsonStr.get("timeline_yn"));

//				System.out.println("변환 데이터 : " + param);
				
				int result = alarmSql.updateAlarmModule(param);
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(0);
			}
			
			
//			for(Object object : array) {
//				JSONObject jsonStr = (JSONObject) JSONSerializer.toJSON(object);
//				
//				alarmVO.setAlertType((String)jsonStr.get("alertType"));
//				alarmVO.setAlertYN((String)jsonStr.get("alert_yn"));
//				alarmVO.setPushYN((String)jsonStr.get("push_yn"));
//				alarmVO.setTalkYN((String)jsonStr.get("talk_yn"));
//				alarmVO.setMailYN((String)jsonStr.get("mail_yn"));
//				alarmVO.setSmsYN((String)jsonStr.get("sms_yn"));
//				alarmVO.setPortalYN((String)jsonStr.get("portal_yn"));
//				alarmVO.setTimelineYN((String)jsonStr.get("timeline_yn"));
//				
//				alarmVO.setCompSeq((String)headerJson.get("compSeq"));
//				alarmVO.setGroupSeq((String)headerJson.get("groupSeq"));
//				alarmVO.setModifySeq((String)headerJson.get("userID"));
//				
//				int result = alarmSql.updateAlarmModule(alarmVO);
////
//				response.setResultCode("SUCCESS");
//				response.setResultMessage("성공하였습니다.");
//				response.setResult(result);
//			}

		} catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
		
		return response;
	}

}
