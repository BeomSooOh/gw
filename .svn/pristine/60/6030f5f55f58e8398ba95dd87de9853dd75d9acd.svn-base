package restful.mullen.service.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import api.common.model.EventRequest;
import api.common.service.EventService;
import neos.cmm.db.CommonSqlDAO;
import net.sf.json.JSONObject;
import restful.mullen.constants.ConstantBiz;
import restful.mullen.dao.MullenDAO;
import restful.mullen.service.MullenFriendService;
import restful.mullen.util.MullenUtil;
import restful.mullen.vo.MullenFriend;


@Service("MullenFriendService")
public class MullenFriendServiceImpl implements MullenFriendService{
	
	private Logger logger = Logger.getLogger(MullenFriendServiceImpl.class);
	
	@Resource(name = "MullenDAO")
	MullenDAO mullenDAO;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="EventService")
	EventService eventService;
	
	@Override
	public String processReqFriend(HashMap<String, Object> params) {
		
		//필수 파라메터 체크
		if(!validateForReqFriend(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		//화면에서 넘어온 empSeq, oppoEmpSeq
		String groupSeq = (String) params.get("groupSeq");
		String empSeq = (String) params.get("empSeq");
		String oppoEmpSeq = (String) params.get("oppoEmpSeq");
		
		//1. 친구 상태 인지 조회 (양방향 2번 조회 empSeq <> oppoEmpSeq, AND status = 400(친구등록완료 상태)
		MullenFriend mullenFriend1 = mullenDAO.selectMullenFriend(params);
		HashMap<String, Object> exParams = new HashMap<>();
		exParams.put("empSeq", oppoEmpSeq);
		exParams.put("oppoEmpSeq", empSeq);
		exParams.put("groupSeq", groupSeq);
		MullenFriend mullenFriend2 = mullenDAO.selectMullenFriend(exParams);
		
		//2. 친구 상태가 아니면 친구 요청 처리.
		//		  이미 친구 상태이면 에러코드 900 리턴
		if( (mullenFriend1 != null && ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400.equals(mullenFriend1.getStatus())) 
				|| (mullenFriend2 != null && ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400.equals(mullenFriend2.getStatus()))
				|| empSeq.equals(oppoEmpSeq)) {//친구 등록된 상태
			return ConstantBiz.MULLEN_FRIEND_REQ_ERROR_REQ900;
		}else {//친구 등록 안된 상태, 
			//친구 요청 처리.
			params.put("status", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_100);
			try {
				if(mullenFriend1 != null) {//이미 존재하면 update
					mullenDAO.updateMullenFriend(params);
				}else {//존재 하지 않으면 insert
					mullenDAO.insertMullenFriend(params);
				}
			}catch(Exception e) {
				return ConstantBiz.MULLEN_FRIEND_REQ_ERROR_REQ901;
			}
		}
		
		//event 알림 전송 호출 [OO 님이 친구요청을 했습니다.]
		reqFriendEventSend(params, exParams);
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	//OO 님이 친구요청을 했습니다. 이벤트 알림 전송
	//수신자 : oppoEmpSeq
	//발신자 : empSeq ---> empName (OO) 필요
	private void reqFriendEventSend(HashMap<String, Object> params, HashMap<String, Object> exParams) {
		
		String groupSeq = (String) params.get("groupSeq");
		String empSeq = (String) params.get("empSeq"); 
		
		//발신자 정보
		HashMap<String, String> empSeqInfo = mullenDAO.selectMemberInfo(params);
		String empName = empSeqInfo.get("emp_name");
		String compSeq = empSeqInfo.get("comp_seq");
		
		//수신자 정보
		HashMap<String, String> oppoEmpSeqInfo = mullenDAO.selectMemberInfo(exParams);
		
		//EventRequest Object
		EventRequest eventRequest = new EventRequest();
		eventRequest.setEventType("GROUP");
		eventRequest.setEventSubType("GR001");
		eventRequest.setGroupSeq(groupSeq);
		eventRequest.setCompSeq(compSeq);
		eventRequest.setSenderSeq(empSeq);
		eventRequest.setPushYn("Y");//맞는지
		eventRequest.setAlertYn("Y");//맞는지
		List<Map<String, Object>> recvEmpList = new ArrayList<>();
		HashMap<String, Object> recvEmp = new HashMap<>();
		//수신자 리스트의 항목 맞는지? 예제의 count, count2, pushYn ??
		recvEmp.put("compSeq", oppoEmpSeqInfo.get("comp_seq"));
		recvEmp.put("deptSeq", oppoEmpSeqInfo.get("dept_seq"));
		recvEmp.put("empSeq", oppoEmpSeqInfo.get("emp_seq"));
		recvEmp.put("pushYn", "Y");
		recvEmpList.add(recvEmp);
		eventRequest.setRecvEmpList(recvEmpList);
		HashMap<String, Object> data = new HashMap<>();
		data.put("oppoName", empName); //"OO 님이 친구요청을 했습니다." 의 OO을 data에 보내는게 맞는지?
		data.put("empSeq", empSeq);
		eventRequest.setData(data);
		
		/**
		 [case1] 소영님이 친구요청을 했습니다.
		 - API 주소 /event/EventSend 맞는지
		 - null로 되어있는 항목 필요 없는지.
		 - 빠진 항목 있는지.
		 {
		  "eventType": "",     //뭐로 넣어야하는지
		  "eventSubType": "",  //eventSubType ([case1] 소영님이 친구요청을 했습니다. [case2] 엄문재님과 친구가 되었습니다.)
		  "groupSeq": "Mullen",
		  "compSeq": "1000",
		  "senderSeq": "aqagdk",
		  "seq": null,
		  "subSeq": null,
		  "recvEmpList": [
		  //수신자 리스트의 deptSeq, compSeq, empSeq 3가지 항목만 있으면되는지 
		  //예제의 count, count2, pushYn도 넣어야하는지
		    {
		      "deptSeq": "1",
		      "compSeq": "1000",
		      "empSeq": "zqoykj"
		    }
		  ],
		  "data": {//"OO님이 친구요청을 했습니다." 의 OO을 data에 보내는게 맞는지 (ex.이멀린님이 친구요청을 했습니다.) 
		    "oppoName": "이멀린",
		    "empSeq": "aqagdk"
		  },
		  "url": null,
		  "alertYn": "Y",    //alertYn만 Y로 보내면 되는지
		  "pushYn": null,
		  "talkYn": null,
		  "mailYn": null,
		  "smsYn": null,
		  "portalYn": null,
		  "timelineYn": null,
		  "recvEmpBulk": null,
		  "recvEmpBulkList": null,
		  "recvMentionEmpList": null,
		  "langCode": null,
		  "ignoreCntYn": null
		}
		 */
		
		try {
			eventService.eventSend(eventRequest);
		} catch (IOException e) {
			logger.error( "MullenServiceImpl processReqFriend reqFriendEventSend eventSend IOException", e);
		}
		
	}

	//친구요청 필수 파라메터 체크
	private boolean validateForReqFriend(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		if(params.get("oppoEmpSeq") == null || StringUtils.isBlank((String)params.get("oppoEmpSeq"))) {
			return false;
		}
		return true;
	}
	@Override
	public HashMap<String, Object> getRecvReqList(HashMap<String, Object> params) {
		HashMap<String, Object> returnObj = new HashMap<>();
		
		//필수 파라메터 체크
		if(!validateForRecvReqListOrSendReqList(params)) {
			returnObj.put("resultCode", ConstantBiz.MULLEN_COMMON_ERROR_COM700);
			return returnObj;
		}
		
		returnObj.put("resultList", mullenDAO.selectRecvReq(params));
		returnObj.put("resultCode", ConstantBiz.API_RESPONSE_SUCCESS);
		
		return returnObj;
	}
	
	@Override
	public HashMap<String, Object> getSendReqList(HashMap<String, Object> params) {
		HashMap<String, Object> returnObj = new HashMap<>();
		
		//필수 파라메터 체크
		if(!validateForRecvReqListOrSendReqList(params)) {
			returnObj.put("resultCode", ConstantBiz.MULLEN_COMMON_ERROR_COM700);
			return returnObj;
		}
		
		returnObj.put("resultList", mullenDAO.selectSendReq(params));
		returnObj.put("resultCode", ConstantBiz.API_RESPONSE_SUCCESS);
		
		return returnObj;
	}

	//받은신청목록/보낸신청목록 필수 파라메터 체크
	private boolean validateForRecvReqListOrSendReqList(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		return true;
	}

	@Override
	public String processCancelSendReq(HashMap<String, Object> params) {
		//필수 파라메터 체크
		if(!validateForCancelSendReq(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		params.put("oppoEmpSeq", params.get("cancelEmpSeq"));
		params.put("prevStatusCheck", true);
		params.put("prevStatus", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_100);
		params.put("status", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_300);
		
		if(mullenDAO.updateMullenFriend(params) < 1) {
			return ConstantBiz.MULLEN_FRIEND_SEND_REQ_ERROR_SND900;
		}
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	//보낸신청취소 필수 파라메터 체크
	private boolean validateForCancelSendReq(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		if(params.get("cancelEmpSeq") == null || StringUtils.isBlank((String)params.get("cancelEmpSeq"))) {
			return false;
		}
		return true;
	}

	@Override
	public String processRejectRecvReq(HashMap<String, Object> params) {
		//필수 파라메터 체크
		if(!validateForRejectRecvReq(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		params.put("oppoEmpSeq", params.get("empSeq"));
		params.put("empSeq", params.get("rejectEmpSeq"));
		params.put("prevStatusCheck", true);
		params.put("prevStatus", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_100);
		params.put("status", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_200);
		
		if(mullenDAO.updateMullenFriend(params) < 1) {
			return ConstantBiz.MULLEN_FRIEND_REJECT_REQ_ERROR_RJT900;
		}
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	
	//친구거절 필수 파라메터 체크
	private boolean validateForRejectRecvReq(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		if(params.get("rejectEmpSeq") == null || StringUtils.isBlank((String)params.get("rejectEmpSeq"))) {
			return false;
		}
		return true;
	}

	@Override
	public String processAcceptFriend(HashMap<String, Object> params) {
		//필수 파라메터 체크
		if(!validateForAcceptFriend(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		//화면에서 넘어온 empSeq, oppoEmpSeq
		String groupSeq = (String) params.get("groupSeq");
		String empSeq = (String) params.get("empSeq");
		String oppoEmpSeq = (String) params.get("oppoEmpSeq");
		String acceptType = (String) params.get("acceptType"); //0: 수락버튼으로 요청시, 1:QR코드로 요청시
		
		//메신져 마이그룹 구성원 등록 API를 호출할지 여부
		boolean canCallMessengerAPI = false;
		
		//1. 친구 상태 인지 조회 (양방향 2번 조회 empSeq <> oppoEmpSeq, AND status = 400(친구등록완료 상태)
		MullenFriend mullenFriend1 = mullenDAO.selectMullenFriend(params);
		HashMap<String, Object> exParams = new HashMap<>();
		exParams.put("empSeq", oppoEmpSeq);
		exParams.put("oppoEmpSeq", empSeq);
		exParams.put("groupSeq", groupSeq);
		MullenFriend mullenFriend2 = mullenDAO.selectMullenFriend(exParams);
		
		//2. 친구 상태가 아니면 친구 요청 처리.
		//이미 친구 상태이면 에러코드 900 리턴
		if( (mullenFriend1 != null && ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400.equals(mullenFriend1.getStatus())) 
				|| (mullenFriend2 != null && ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400.equals(mullenFriend2.getStatus()))) {//친구 등록된 상태
			return ConstantBiz.MULLEN_FRIEND_ACCEPT_ERROR_ACP900;
		}else {//친구 등록 안된 상태, 
			//친구 등록 처리.
			try {
				if(ConstantBiz.MULLEN_FRIEND_ACCEPT_TYPE_0.equals(acceptType)) {//0: 수락버튼으로 요청시
					//status = 100 AND recv_emp_seq = empSeq AND emp_seq = oppoEmpSeq 에 status = 400 업데이트				
					params.put("prevStatusCheck", true);
					params.put("prevStatus", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_100);
					params.put("status", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400);
					int cnt1 = mullenDAO.updateMullenFriend(params);
					//status = 100 AND recv_emp_seq = oppoEmpSeq AND emp_seq = empSeq 에 status = 400 업데이트
					params.put("empSeq", oppoEmpSeq);
					params.put("oppoEmpSeq", empSeq);
					int cnt2 = mullenDAO.updateMullenFriend(params);
					//둘중 하나라도 0보다 크면 canCallMessengerAPI = true;세팅
					if(cnt1 > 0 || cnt2 > 0) {
						canCallMessengerAPI = true;
					}else {
						return ConstantBiz.MULLEN_FRIEND_ACCEPT_ERROR_ACP901;		
					}
				}else if(ConstantBiz.MULLEN_FRIEND_ACCEPT_TYPE_1.equals(acceptType)){//1:QR코드로 요청시
					params.put("status", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400);
					//recv_emp_seq = empSeq AND emp_seq = oppoEmpSeq 에 status = 400 delete insert
					mullenDAO.deleteMullenFriend(params);
					mullenDAO.insertMullenFriend(params);
					//recv_emp_seq = oppoEmpSeq AND emp_seq = empSeq 에 status = 400 delete insert
					params.put("empSeq", oppoEmpSeq);
					params.put("oppoEmpSeq", empSeq);
					mullenDAO.deleteMullenFriend(params);
					mullenDAO.insertMullenFriend(params);
					canCallMessengerAPI = true;
				}
			} catch(Exception e) {
				return ConstantBiz.MULLEN_FRIEND_ACCEPT_ERROR_ACP902;	
			}
		}
		if(canCallMessengerAPI) {
			//양방향 마이그룹에 등록할 empSeq, oppoEmpSeq의 deptSeq, myGroupId 조회
			HashMap<String, String> oppoEmpSeqInfo = mullenDAO.selectMemberInfo(params);
			params.put("empSeq", empSeq);
			params.put("oppoEmpSeq", oppoEmpSeq);
			HashMap<String, String> empSeqInfo = mullenDAO.selectMemberInfo(params);
			
			if(oppoEmpSeqInfo != null && empSeqInfo != null) {
				//메신져 마이그룹 구성원 등록 API를 호출 (중복 등록 호출해도 1개만 등록되는것으로 확인) 
				//1. 수락한 사용자의 마이그룹에 요청한 사용자 등록
				JSONObject obj = new JSONObject();
				JSONObject header = new JSONObject();
				JSONObject body = new JSONObject();
				ArrayList<HashMap<String, String>> members = new ArrayList<>();
				HashMap<String, String> member = new HashMap<>();
				header.put("groupSeq", empSeqInfo.get("group_seq"));
				header.put("empSeq", empSeqInfo.get("emp_seq"));
				body.put("myGroupId", empSeqInfo.get("my_group_id"));
				member.put("deptSeq", oppoEmpSeqInfo.get("dept_seq"));
				member.put("empSeq", oppoEmpSeqInfo.get("emp_seq"));
				members.add(member);
				body.put("members", members);
				obj.put("header", header);
				obj.put("body", body);
				//Messenger API(마이그룹 구성원 등록) 호출
				MullenUtil.getPostJSON(
						empSeqInfo.get("messenger_url") 
						+ ConstantBiz.MESSENGER_MOBILE_API_URL
						+ ConstantBiz.MESSENGER_MOBILE_API_URL_MY_GROUP_MEMBER_INSERT, obj.toString());
				
				//2. 요청한 사용자의 마이그룹에 수락한 사용자 등록
				members = new ArrayList<>();
				member = new HashMap<>();
				header.put("groupSeq", oppoEmpSeqInfo.get("group_seq"));
				header.put("empSeq", oppoEmpSeqInfo.get("emp_seq"));
				body.put("myGroupId", oppoEmpSeqInfo.get("my_group_id"));
				member.put("deptSeq", empSeqInfo.get("dept_seq"));
				member.put("empSeq", empSeqInfo.get("emp_seq"));
				members.add(member);
				body.put("members", members);
				obj.put("header", header);
				obj.put("body", body);
				//Messenger API(마이그룹 구성원 등록) 호출
				MullenUtil.getPostJSON(
						oppoEmpSeqInfo.get("messenger_url") 
						+ ConstantBiz.MESSENGER_MOBILE_API_URL
						+ ConstantBiz.MESSENGER_MOBILE_API_URL_MY_GROUP_MEMBER_INSERT, obj.toString());
			}
		}else {
			return ConstantBiz.MULLEN_FRIEND_ACCEPT_ERROR_ACP901;
		}
		
		//event 알림 전송 호출 [소영님과 친구가 되었습니다.(엄문재님과 친구가 되었습니다.) event 호출필요 (양쪽 event 호출 필요)]
		acceptFriendEventSend(params, exParams);
		acceptFriendEventSend(exParams, params);

		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	
	//OO님과 친구가 되었습니다. 이벤트 알림 전송
	//수신자 : oppoEmpSeq
	//발신자 : empSeq ---> empName (OO) 필요
	private void acceptFriendEventSend(HashMap<String, Object> params, HashMap<String, Object> exParams) {
		
		String groupSeq = (String) params.get("groupSeq");
		String empSeq = (String) params.get("empSeq"); 
		
		//발신자 정보
		HashMap<String, String> empSeqInfo = mullenDAO.selectMemberInfo(params);
		String empName = empSeqInfo.get("emp_name");
		String compSeq = empSeqInfo.get("comp_seq");
		
		//수신자 정보
		HashMap<String, String> oppoEmpSeqInfo = mullenDAO.selectMemberInfo(exParams);
		
		//EventRequest Object
		EventRequest eventRequest = new EventRequest();
		eventRequest.setEventType("GROUP");
		eventRequest.setEventSubType("GR002");
		eventRequest.setGroupSeq(groupSeq);
		eventRequest.setCompSeq(compSeq);
		eventRequest.setSenderSeq(empSeq);
		eventRequest.setPushYn("Y");//맞는지
		eventRequest.setAlertYn("Y");//맞는지
		List<Map<String, Object>> recvEmpList = new ArrayList<>();
		HashMap<String, Object> recvEmp = new HashMap<>();
		//수신자 리스트의 항목 맞는지? 예제의 count, count2, pushYn ??
		recvEmp.put("compSeq", oppoEmpSeqInfo.get("comp_seq"));
		recvEmp.put("deptSeq", oppoEmpSeqInfo.get("dept_seq"));
		recvEmp.put("empSeq", oppoEmpSeqInfo.get("emp_seq"));
		recvEmp.put("pushYn", "Y");
		recvEmpList.add(recvEmp);
		eventRequest.setRecvEmpList(recvEmpList);
		HashMap<String, Object> data = new HashMap<>();
		data.put("oppoName", empName); //"OO님과 친구가 되었습니다." 의 OO을 data에 보내는게 맞는지 (ex.엄문재님과 친구가 되었습니다.)
		data.put("empSeq", empSeq);
		eventRequest.setData(data);
		
		/**
		 [case2] 엄문재님과 친구가 되었습니다.
		 - API 주소 /event/EventSend 맞는지
		 - null로 되어있는 항목 필요 없는지.
		 - 빠진 항목 있는지.
		 {
		  "eventType": "",     //뭐로 넣어야하는지
		  "eventSubType": "",  //뭐로 넣어야하는지
		  "groupSeq": "Mullen",
		  "compSeq": "1000",
		  "senderSeq": "aqagdk",
		  "seq": null,
		  "subSeq": null,
		  "recvEmpList": [
		  //수신자 리스트의 deptSeq, compSeq, empSeq 3가지 항목만 있으면되는지 
		  //예제의 count, count2, pushYn도 넣어야하는지
		    {
		      "deptSeq": "1",
		      "compSeq": "1000",
		      "empSeq": "zqoykj"
		    }
		  ],
		  "data": {//"OO님과 친구가 되었습니다." 의 OO을 data에 보내는게 맞는지 (ex.엄문재님과 친구가 되었습니다.) 
		    "oppoName": "엄문재",
		    "empSeq":"aqagd"
		  },
		  "url": null,
		  "alertYn": "Y",    //alertYn만 Y로 보내면 되는지
		  "pushYn": null,
		  "talkYn": null,
		  "mailYn": null,
		  "smsYn": null,
		  "portalYn": null,
		  "timelineYn": null,
		  "recvEmpBulk": null,
		  "recvEmpBulkList": null,
		  "recvMentionEmpList": null,
		  "langCode": null,
		  "ignoreCntYn": null
		}
		 */
		
		try {
			eventService.eventSend(eventRequest);
		} catch (IOException e) {
			logger.error( "MullenServiceImpl processAcceptFriend acceptFriendEventSend eventSend IOException", e);
		}
		
	}
	
	//친구수락 필수 파라메터 체크
	private boolean validateForAcceptFriend(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		if(params.get("oppoEmpSeq") == null || StringUtils.isBlank((String)params.get("oppoEmpSeq"))) {
			return false;
		}
		if(params.get("acceptType") == null || StringUtils.isBlank((String)params.get("acceptType"))) {
			return false;
		}
		return true;
	}

	@Override
	public String processRemoveFriend(HashMap<String, Object> params) {
		//필수 파라메터 체크
		if(!validateForRemoveFriend(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		//화면에서 넘어온 empSeq, oppoEmpSeq
		String groupSeq = (String) params.get("groupSeq");
		String empSeq = (String) params.get("empSeq");
		String oppoEmpSeq = (String) params.get("oppoEmpSeq");
		
		//메신져 마이그룹 구성원 등록 API를 호출할지 여부
		boolean canCallMessengerAPI = false;
		
		//1. 친구 상태 인지 조회 (양방향 2번 조회 empSeq <> oppoEmpSeq, AND status = 400(친구등록완료 상태)
		MullenFriend mullenFriend1 = mullenDAO.selectMullenFriend(params);
		HashMap<String, Object> exParams = new HashMap<>();
		exParams.put("empSeq", oppoEmpSeq);
		exParams.put("oppoEmpSeq", empSeq);
		exParams.put("groupSeq", groupSeq);
		MullenFriend mullenFriend2 = mullenDAO.selectMullenFriend(exParams);
		
		//2. 친구 상태이면 친구 삭제 처리.
		//친구 상태가 아니면 에러코드 900 리턴
		if((mullenFriend1 != null && ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400.equals(mullenFriend1.getStatus())) 
				|| (mullenFriend2 != null && ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400.equals(mullenFriend2.getStatus()))) {
			//친구 삭제 처리.
			//status = 400 AND recv_emp_seq = empSeq AND emp_seq = oppoEmpSeq 에 status = 900 업데이트				
			params.put("prevStatusCheck", true);
			params.put("prevStatus", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_400);
			params.put("status", ConstantBiz.MULLEN_FRIEND_REQ_STATUS_900);
			int cnt1 = mullenDAO.updateMullenFriend(params);
			//status = 400 AND recv_emp_seq = oppoEmpSeq AND emp_seq = empSeq 에 status = 900 업데이트
			params.put("empSeq", oppoEmpSeq);
			params.put("oppoEmpSeq", empSeq);
			int cnt2 = mullenDAO.updateMullenFriend(params);
			//둘중 하나라도 0보다 크면 canCallMessengerAPI = true;세팅
			if(cnt1 > 0 || cnt2 > 0) {
				canCallMessengerAPI = true;
			}else {
				return ConstantBiz.MULLEN_FRIEND_REMOVE_ERROR_RMV901;		
			}
	
		}else {//친구 상태가 아니면 에러코드 900 리턴
			return ConstantBiz.MULLEN_FRIEND_REMOVE_ERROR_RMV900;
		}
		
		if(canCallMessengerAPI) {
			//양방향 마이그룹에서 삭제할 empSeq, oppoEmpSeq의 deptSeq, myGroupId 조회
			HashMap<String, String> oppoEmpSeqInfo = mullenDAO.selectMemberInfo(params);
			params.put("empSeq", empSeq);
			params.put("oppoEmpSeq", oppoEmpSeq);
			HashMap<String, String> empSeqInfo = mullenDAO.selectMemberInfo(params);
			
			if(oppoEmpSeqInfo != null && empSeqInfo != null) {
				//메신져 마이그룹 구성원 삭제 API를 호출 (중복 등록 호출해도 1개만 등록되는것으로 확인) 
				//1. 삭제 요청한 사용자의 마이그룹에 등록된 사용자 삭제
				JSONObject obj = new JSONObject();
				JSONObject header = new JSONObject();
				JSONObject body = new JSONObject();
				ArrayList<HashMap<String, Object>> delList = new ArrayList<>();
				ArrayList<HashMap<String, String>> members = new ArrayList<>();
				HashMap<String, Object> del = new HashMap<>();
				HashMap<String, String> member = new HashMap<>();
				header.put("groupSeq", empSeqInfo.get("group_seq"));
				header.put("empSeq", empSeqInfo.get("emp_seq"));
				del.put("myGroupId", empSeqInfo.get("my_group_id"));
				member.put("deptSeq", oppoEmpSeqInfo.get("dept_seq"));
				member.put("empSeq", oppoEmpSeqInfo.get("emp_seq"));
				members.add(member);
				del.put("members", members);
				delList.add(del);
				body.put("delList", delList);
				obj.put("header", header);
				obj.put("body", body);
				//Messenger API(마이그룹 구성원 삭제) 호출
				MullenUtil.getPostJSON(
						empSeqInfo.get("messenger_url") 
						+ ConstantBiz.MESSENGER_MOBILE_API_URL
						+ ConstantBiz.MESSENGER_MOBILE_API_URL_MY_GROUP_MEMBER_DELETE, obj.toString());
				
				//2. 삭제될 사용자의 마이그룹에 등록된 삭제 요청한 사용자 삭제
				delList = new ArrayList<>();
				members = new ArrayList<>();
				del = new HashMap<>();
				member = new HashMap<>();
				header.put("groupSeq", oppoEmpSeqInfo.get("group_seq"));
				header.put("empSeq", oppoEmpSeqInfo.get("emp_seq"));
				del.put("myGroupId", oppoEmpSeqInfo.get("my_group_id"));
				member.put("deptSeq", empSeqInfo.get("dept_seq"));
				member.put("empSeq", empSeqInfo.get("emp_seq"));
				members.add(member);
				del.put("members", members);
				delList.add(del);
				body.put("delList", delList);
				obj.put("header", header);
				obj.put("body", body);
				//Messenger API(마이그룹 구성원 삭제) 호출
				MullenUtil.getPostJSON(
						oppoEmpSeqInfo.get("messenger_url") 
						+ ConstantBiz.MESSENGER_MOBILE_API_URL
						+ ConstantBiz.MESSENGER_MOBILE_API_URL_MY_GROUP_MEMBER_DELETE, obj.toString());
			}
		}else {
			return ConstantBiz.MULLEN_FRIEND_REMOVE_ERROR_RMV901;
		}
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	//친구삭제 필수 파라메터 체크
	private boolean validateForRemoveFriend(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		if(params.get("oppoEmpSeq") == null || StringUtils.isBlank((String)params.get("oppoEmpSeq"))) {
			return false;
		}
		return true;
	}
}