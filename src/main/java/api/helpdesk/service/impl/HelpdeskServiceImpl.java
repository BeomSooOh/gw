package api.helpdesk.service.impl;

import java.lang.reflect.Array;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.stereotype.Service;

import api.helpdesk.constants.HelpdeskConstants;
import api.helpdesk.service.HelpdeskService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("HelpdeskService")
public class HelpdeskServiceImpl implements HelpdeskService{

	
	//헬프데스크 api호출시 필요한 secretKey 생성
	@Override
	public String makeSecretKey(String groupSeq, String loginId) {
		
		try {
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			Date date = new Date();
			String currentTime = dateFormat.format(date);
			String secretKey = null;
			
			secretKey = AESCipher.AES_Encode(currentTime + "▦" + groupSeq + "▦" + loginId);
			
			return secretKey;
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return null;
	}

	
	// 팝업설정된 가장 최신의 boardSeq를 가져옴
	@Override
	public void getRecentBoardSeq(JSONObject helpDeskApiInfoMap) {
		
		try {
			
			String result = callHelpdeskApi(HelpdeskConstants.GET_NOTICESEQ_API_URL, (String) helpDeskApiInfoMap.get("secretKey"));
			
			if(result != null && !result.equals("")) {
				JSONObject retrievePopNoticeSeqJSONObj = stringToJSONObject(result);
				
//				System.out.print(retrievePopNoticeSeqJSONObj.get("noticeInfo"));
				if(retrievePopNoticeSeqJSONObj.get("resultCode").equals("ok")) {
					
					JSONObject noticeInfo = (JSONObject) retrievePopNoticeSeqJSONObj.get("noticeInfo");
					
					if(!noticeInfo.isNullObject() && !objEmptyCheck(noticeInfo)) {
						
						String nextBoardSeq = EgovStringUtil.isNullToString(noticeInfo.getString("boardSeq"));
						
						if(!nextBoardSeq.equals("")) {
							
							String prevBoardSeq = EgovStringUtil.isNullToString(helpDeskApiInfoMap.get("boardSeq"));
							
							// 노출기간이 안지난 공지사항기간이지났으면 안뛰어줌
							// 오늘하루안보기 -> 더이상 안보기
							// 마지막키가 5면 프론트에서 5를 받고 그것을 띄워주고 거기서 더이상 보지않기를 체크하면 닫으면
							// 그 로컬스토리지에 키(5)를저장 다음에 열었을떄 이 로컬스토리지에 키 밸류를 가져와서 비교
							// 다른피시에서 할떄는 또뜨는게 맞음
							
							setCallgetRecentBoardSeqMethodResult(helpDeskApiInfoMap, nextBoardSeq);
						}else {
							// 정상호출 되었지만 noticeInfo에 boardSeq값이 null -> 팝업공지사항이 없음
							setCallgetRecentBoardSeqMethodResult(helpDeskApiInfoMap, "");

							//setErrLogAndReturnErr(HelpdeskConstants.boardSeqIsNull, helpDeskApiInfoMap);
						}
						
					}else {
						// 정상호출되었지만 noticeInfo에 대한 정보가 없음 -> 팝업 공지사항이 없음
						setCallgetRecentBoardSeqMethodResult(helpDeskApiInfoMap, "");
						//setErrLogAndReturnErr(HelpdeskConstants.noExistNoticeInfoMsg, helpDeskApiInfoMap);
					}
				}else {
					// retrievePopNoticeSeq api 호출 실패 
					setLogAndReturnMsg(HelpdeskConstants.RETRIEVE_POPNOTICESEQ_APIFAIL_MSG, helpDeskApiInfoMap);
				}
			}else {
				// secretKey가 존재하지않음 
				setLogAndReturnMsg(HelpdeskConstants.NO_SECRETKEY_MSG, helpDeskApiInfoMap);
			}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}

	@Override
	public JSONObject stringToJSONObject(String json) {
		try {			
			return JSONObject.fromObject(JSONSerializer.toJSON(json));
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return null;
	}
	
	// 객체가 비었는지 확인
	@Override
	public Boolean objEmptyCheck(Object obj) {
		  if (obj instanceof String) { return obj == null || "".equals(obj.toString().trim()); }
		  else if (obj instanceof List) { return obj == null || ((List) obj).isEmpty(); }
		  else if (obj instanceof Map) { return obj == null || ((Map) obj).isEmpty(); }
		  else if (obj instanceof Object[]) { return obj == null || Array.getLength(obj) == 0; }
		  else { return obj == null; }
	}

	@Override
	public String getCurrentTime() {
		
		SimpleDateFormat formatter = new SimpleDateFormat ("HH:mm:ss");
		Date date = new Date();
		String time = formatter.format(date);
		return time;
	}

	// api 호출 실패 or 값이없을때 세팅
	@Override
	public void setApiErrorValue(JSONObject helpDeskApiInfoMap, String errMsg) {
		helpDeskApiInfoMap.put("boardSeq", "");
		helpDeskApiInfoMap.put("noticeList", "");
		helpDeskApiInfoMap.put("currentTime", getCurrentTime());
		
		if(helpDeskApiInfoMap.get("errMsg") == null || helpDeskApiInfoMap.get("errMsg").equals("")) {
			helpDeskApiInfoMap.put("errMsg", errMsg);
		}
	}


	@Override
	public void getBoardContentsUsePopup(JSONObject helpDeskApiInfoMap) {
		
		String url = HelpdeskConstants.HELPDESK_ADDR + HelpdeskConstants.NOTICEDETAIL_API_URL;
		JSONObject jsonParam = new JSONObject();
		
		String secretKey = EgovStringUtil.isNullToString(helpDeskApiInfoMap.get("secretKey"));
		String boardSeq = EgovStringUtil.isNullToString(helpDeskApiInfoMap.get("boardSeq"));
		String result = null;
		
		JSONArray noticeList = (JSONArray) helpDeskApiInfoMap.get("noticeList");
		Iterator<JSONObject> iterator = noticeList.iterator();
		
		while(iterator.hasNext()) {
			//System.out.println((iterator.next()).get("boardSeq"));
			boardSeq = EgovStringUtil.isNullToString((iterator.next()).get("boardSeq"));
		}
		
		if(!secretKey.equals("") && !boardSeq.equals("")) {
			
			jsonParam.put("secretKey", secretKey);
			jsonParam.put("boardSeq", boardSeq);
		}else {
			// retrievePopNoticeSeq 호출시 에러
			setLogAndReturnMsg(HelpdeskConstants.BOARDSEQ_OR_SECRETKEY_ISNULL_MSG, helpDeskApiInfoMap);
			return;
		}
		
		result = (String) HttpJsonUtil.execute("POST", url, jsonParam);

		result = correctNoticeContentsHTML(result, secretKey, boardSeq);
		
		HelpdeskConstants.HELPDESK_APIINFO.put("prevBoardSeq", boardSeq);

//		System.out.println("result : " + result);

		if(result != null && !result.equals("")) {
			HelpdeskConstants.NOTICE_CONTENTS.put("noticePopContents", result);
			HelpdeskConstants.NOTICE_CONTENTS.put("errMsg", "");
		}else {
			// noticeApiDetail 호출시 에러
			setLogAndReturnMsg(HelpdeskConstants.NOTICEDETAIL_APIFAIL_MSG, helpDeskApiInfoMap);
			HelpdeskConstants.NOTICE_CONTENTS.put("noticePopContents", "");
			HelpdeskConstants.NOTICE_CONTENTS.put("errMsg", HelpdeskConstants.NOTICEDETAIL_APIFAIL_MSG);
			return;
		}		
		
	}


	@Override
	public void setLogAndReturnMsg(String errMsg, JSONObject helpDeskApiInfoMap) {
		setApiErrorValue(helpDeskApiInfoMap, errMsg);
	}


	@Override
	public void getNoticeList(JSONObject helpDeskApiInfoMap) {
		
		try {	
			String result = callHelpdeskApi(HelpdeskConstants.GET_NOTICELIST_API_URL,(String) helpDeskApiInfoMap.get("secretKey"));
			
			if(result != null && !result.equals("")) {
//				System.out.println("result : " + result);
				
				JSONObject retrieveNoticeApiListJSONObj = stringToJSONObject(result);
				if(retrieveNoticeApiListJSONObj.get("resultCode").equals("ok")) {
					JSONArray noticeList =  (JSONArray) retrieveNoticeApiListJSONObj.get("noticeList");
					
					if(	!noticeList.isEmpty() && !objEmptyCheck(noticeList) && noticeList != null) {
						helpDeskApiInfoMap.put("noticeList", retrieveNoticeApiListJSONObj.get("noticeList"));
					}else {
						// 정상호출되었지만 noticeList에 대한 정보가 없음 -> 공지사항이 없음
						helpDeskApiInfoMap.put("noticeList", "");
						//setErrLogAndReturnErr(HelpdeskConstants.noExistNoticeListMsg, helpDeskApiInfoMap);
					}
				}else {
					// retrieveNoticeApiList Api 호출 실패
					setLogAndReturnMsg(HelpdeskConstants.RETRIEVE_NOTICEAPILIST_APIFAIL_MSG, helpDeskApiInfoMap);
				}
				
			}else {
				setLogAndReturnMsg(HelpdeskConstants.BOARDSEQ_OR_SECRETKEY_ISNULL_MSG, helpDeskApiInfoMap);
			}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}


	@Override
	public String callHelpdeskApi(String url, String secretKey, String boardSeq) {

		JSONObject jsonParam = new JSONObject();
		
		if(!EgovStringUtil.isNullToString(secretKey).equals("") && !EgovStringUtil.isNullToString(boardSeq).equals("")) {
			jsonParam.put("secretKey", secretKey);	
			jsonParam.put("boardSeq", boardSeq);					
		}else {
			return null;
		}
		
		return HttpJsonUtil.execute("POST", HelpdeskConstants.HELPDESK_ADDR + url, jsonParam);
	}


	@Override
	public String callHelpdeskApi(String url, String secretKey) {

		JSONObject jsonParam = new JSONObject();
		
		if(!EgovStringUtil.isNullToString(secretKey).equals("")) {
			jsonParam.put("secretKey", secretKey);					
		}else {
			return null;
		}
		
		return HttpJsonUtil.execute("POST", HelpdeskConstants.HELPDESK_ADDR + url, jsonParam);
	}
	
	@Override
	public String callHelpdeskApi(String url, String secretKey, String boardSeq, String boardType) {
		JSONObject jsonParam = new JSONObject();
		
		if(!EgovStringUtil.isNullToString(secretKey).equals("")) {
			jsonParam.put("secretKey", secretKey);
			jsonParam.put("boardSeq", boardSeq);
			jsonParam.put("boardType", boardType);
		}else {
			return null;
		}
		
		return HttpJsonUtil.execute("POST", HelpdeskConstants.HELPDESK_ADDR + url, jsonParam);
	}



	@Override
	public void callHelpdeskApiSaveCache() {
//		try {			
//			
//
//		}catch(Exception e) {
//			e.printStackTrace();
//		}
	}

	@Override
	public JSONObject returnHelpdeskInfo() {
		
		try {
			
			if(checkCloseNetwork() && compareCurrentTime()) {
				callHelpdeskApiSaveCache();
			}
			
			return HelpdeskConstants.HELPDESK_APIINFO;
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return null;
	}
	
	@Override
	public boolean compareCurrentTime() {
		
		try {
			
			String apiInfoCurrentTime = (String) HelpdeskConstants.HELPDESK_APIINFO.get("currentTime");
			
			//helpdeskApiInfo에 currentTime이 없으면 그냥 api 호출
			if(apiInfoCurrentTime == null || apiInfoCurrentTime.equals("")) {
				return true;
			}
			
			SimpleDateFormat f = new SimpleDateFormat("HH:mm:ss", Locale.KOREA);
			Date apiInfoTime = f.parse(apiInfoCurrentTime);
			Date currentTime = f.parse(getCurrentTime());
			long diff = currentTime.getTime() - apiInfoTime.getTime();
			long timeDiff = diff / 1000;
			
			//헬프데스크 api 호출한지 5분이 지났는지 확인
			if(timeDiff >= HelpdeskConstants.HELPDESK_APICALLTIME) {
				return true;
			}
			
			return false;
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return false;
	}

	@Override
	public boolean checkCloseNetwork() {
		
		if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")) {
			return false;
		}
		
		return true;
	}

	@Override
	public String correctNoticeContentsHTML(String htmlCode, String secretKey, String boardSeq) {
		
		
		htmlCode = htmlCode.replaceAll("src=\"", "src=\"" + HelpdeskConstants.HELPDESK_ADDR);
		htmlCode = htmlCode.replaceAll("href=\"", "href=\"" + HelpdeskConstants.HELPDESK_ADDR);
		htmlCode = htmlCode.replaceAll("url : '", "url : '" + HelpdeskConstants.HELPDESK_ADDR);
		htmlCode = htmlCode.replaceAll("\"", "\\\\\"");
		htmlCode = htmlCode.replaceAll("/", "\\\\/");
		htmlCode = htmlCode.replaceAll("'", "\\\\\"");
		htmlCode = htmlCode.replaceAll("type='button'", "type=\\'button\\'");
		htmlCode = htmlCode.replaceAll("type='text'", "type=\\'text\\'");
		htmlCode = htmlCode.replaceAll("data-role='W'", "data-role=\\'W\\'");
		htmlCode = htmlCode.replaceAll("data-role='D'", "data-role=\\'D\\'");
		htmlCode = htmlCode.replaceAll("data-role='F'", "data-role=\\'F\\'");
		htmlCode = htmlCode.replaceAll("data-role='E'", "data-role=\\'E\\'");
		htmlCode = htmlCode.replaceAll("sessionKey = \\\\\"\\\\\"", "sessionKey = \\\\\"" + secretKey + "\\\\\"");
		htmlCode = htmlCode.replaceAll("BOARD_SEQ  = \\\\\"0\\\\\"", "BOARD_SEQ  = \\\\\"" + boardSeq + "\\\\\"");
		htmlCode = htmlCode.replaceAll("\r", "\\\\r");
		htmlCode = htmlCode.replaceAll("\n", "\\\\n");
		htmlCode = htmlCode.replaceAll("\t", "\\\\t");

		
		return htmlCode;
	}

	@Override
	public JSONObject returnNoticeContetns() {
		return HelpdeskConstants.NOTICE_CONTENTS;
	}

	@Override
	public void setCallgetRecentBoardSeqMethodResult(JSONObject helpDeskApiInfoMap, String boardSeq) {
		
		helpDeskApiInfoMap.put("boardSeq", boardSeq);
		helpDeskApiInfoMap.put("errMsg", "");
		helpDeskApiInfoMap.put("currentTime", getCurrentTime());
	}
	
	@Override
	public void getNoticePopData(JSONObject helpDeskApiInfoMap, String boardSeq) {
		
		try {
			String result = callHelpdeskApi(HelpdeskConstants.GET_NOTICEDATA_API_URL, (String) helpDeskApiInfoMap.get("secretKey"), boardSeq, "G");
			
			if(result != null && !result.equals("")) {
//				System.out.println("result : " + result);
				
				JSONObject noticeDataJSONObj = stringToJSONObject(result);
				noticeDataJSONObj.put("content", correctNoticeContentsHTML((String) noticeDataJSONObj.get("content").toString(), "1", "1"));
				
				HelpdeskConstants.NOTICE_POPINFO.put("noticePopInfo", noticeDataJSONObj);
				
			}else {
				setLogAndReturnMsg(HelpdeskConstants.BOARDSEQ_OR_SECRETKEY_ISNULL_MSG, helpDeskApiInfoMap);
			}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}

	@Override
	public void getNoticeListData(JSONObject noticePopInfo, JSONObject helpDeskApiInfoMap) {
		
		try {
			
			Object obj = helpDeskApiInfoMap.get("noticeList");
			
			if(obj == null || obj.equals("")) {
				return;
			}
			
			JSONArray noticeList = (JSONArray) obj;
			List<Object> popInfoList = new ArrayList<>();
			
			int noticeListSize = noticeList.size();
			
			for(int i = 0; i < noticeListSize; i++) {
				
				String result = callHelpdeskApi(HelpdeskConstants.GET_NOTICEDATA_API_URL, (String) helpDeskApiInfoMap.get("secretKey"), String.valueOf(( (JSONObject) noticeList.get(i) ).get("boardSeq")), "G");

				if(result != null && !result.equals("")) {
//					System.out.println("result : " + result);
					
					JSONObject noticeDataJSONObj = stringToJSONObject(result);
					noticeDataJSONObj.put("content", correctNoticeContentsHTML((String) noticeDataJSONObj.get("content").toString(), "1", "1"));
					
					popInfoList.add(noticeDataJSONObj);
										
				}else {
					setLogAndReturnMsg(HelpdeskConstants.BOARDSEQ_OR_SECRETKEY_ISNULL_MSG, helpDeskApiInfoMap);
					return;
				}
			}
			
			HelpdeskConstants.NOTICE_POPINFO.put("noticeListPopInfo", popInfoList);
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	// 최신 boardSeq와 기존에 가지고있던 boardSeq를 비교
//	public boolean compareBoardSeq(String prevBoardSeq, String nextBoardSeq) {
//		
//		if(prevBoardSeq.equals(nextBoardSeq)) {
//			return true;
//		}else if(nextBoardSeq.equals("")) {
//			// nextBoardSeq가 제대로된 값이 아니여서 "" 가 세팅되었을때
//			return true;
//		}else if(prevBoardSeq.equals("")) {
//			// prevBoardSeq가 제대로된 값이 아니여서 "" 가 세팅되었을때
//			return true;
//		}else {
//			return false;
//		}
//	}
	
//	public void checkHelpdeskApiInfoNull(String groupSeq, String loginId) throws Exception {
//
//		if(HelpdeskConstants.HELPDESK_APIINFO.get("secretKey") == null || HelpdeskConstants.HELPDESK_APIINFO.get("secretKey").equals("")) {				
//			HelpdeskConstants.HELPDESK_APIINFO.put("secretKey", makeSecretKey(groupSeq, loginId));
//		}
//		
//		// 공지사항이없으면 배번호출됨 -> 수정
//		// 백단에서해주는거는 스태틱에 리턴해야될 데이턱아ㅣㅆ고 마지막으로 요창한시간 마지막 요청한시간에서 5분지났는지 체크
//		// 5분이 안지났으면 정보를 그대로 리턴
//		// 최초 was 기동시 시간이 없으니까 null일때는 한번 호출
//		
//		if(HelpdeskConstants.HELPDESK_APIINFO.get("boardSeq") == null || HelpdeskConstants.HELPDESK_APIINFO.get("boardSeq").equals("")) {
//			try {
//				getRecentBoardSeq(HelpdeskConstants.HELPDESK_APIINFO);
//			}catch(Exception e) {
//				e.printStackTrace();
//				LOG.error("helpdesk retrievePopNoticeSeq error", e);
//			}
//		}
//		
//		if(HelpdeskConstants.HELPDESK_APIINFO.get("ClosedNetworkYn") == null || HelpdeskConstants.HELPDESK_APIINFO.get("ClosedNetworkYn").equals("")) {
//			HelpdeskConstants.HELPDESK_APIINFO.put("ClosedNetworkYn", BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn"));
//		}		
//	}
	
}
