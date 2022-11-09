package api.helpdesk.service;

import org.json.simple.parser.ParseException;
import net.sf.json.JSONObject;

public interface HelpdeskService {

	public String makeSecretKey(String groupSeq, String loginId) throws Exception;
	
	public void getRecentBoardSeq(JSONObject helpDeskApiInfoMap) throws Exception;
	
	public JSONObject stringToJSONObject(String json) throws ParseException;
		
	public Boolean objEmptyCheck(Object obj);
	
	public String getCurrentTime();
		
	public void setApiErrorValue(JSONObject helpDeskApiInfoMap, String errMsg);
	
//	public void getBoardContentsUsePopup(JSONObject helpDeskApiInfoMap);
		
	public void setLogAndReturnMsg(String errMsg, JSONObject helpDeskApiInfoMap);
	
	public void getNoticeList(JSONObject helpDeskApiInfoMap);
	
	public String callHelpdeskApi(String url, String secretKey, String boardSeq, String boardType);
	
	public String callHelpdeskApi(String url, String secretKey, String boardSeq);
	
	public String callHelpdeskApi(String url, String secretKey);
	
	public void callHelpdeskApiSaveCache();
	
	public JSONObject returnHelpdeskInfo();

	public boolean compareCurrentTime();

	public void getBoardContentsUsePopup(JSONObject helpDeskApiInfoMap);
	
	//폐쇄망 확인
	public boolean checkCloseNetwork();
	
	//공지사항 상세뷰 html code 보정
	public String correctNoticeContentsHTML(String htmlCode, String secretKey, String boardSeq);
	
	//공지사항 상세조회 htmlCode 리턴
	public JSONObject returnNoticeContetns();
	
	//getRecentBoardSeq 메소드 호출 후 리턴값 세팅
	public void setCallgetRecentBoardSeqMethodResult(JSONObject helpDeskApiInfoMap, String boardSeq);
	
	//공지사항 팝업 상세조회 화면의 데이터를 가져옴
	public void getNoticePopData(JSONObject helpDeskApiInfoMap, String boardSeq);
	
	//공지사항 리스트의 데이터를 가져옴
	public void getNoticeListData(JSONObject noticePopInfo, JSONObject helpDeskApiInfoMap);
}
