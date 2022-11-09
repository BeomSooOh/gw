package api.helpdesk.constants;

import net.sf.json.JSONObject;


public class HelpdeskConstants {
	
	// 헬프데스크 Api 테스트서버 주소
	//"http://14.41.55.25"
	public static String HELPDESK_ADDR = "http://58.224.117.49";
	
	//가장 최근 공지팝업의 boardSeq를 5분마다 갱신
	public static JSONObject HELPDESK_APIINFO = new JSONObject();
	
	public static JSONObject NOTICE_CONTENTS = new JSONObject();
	
	public static JSONObject NOTICE_POPINFO = new JSONObject();
	
	// 몇초마다 헬프데스크 api 호출할지 시간
	public static long HELPDESK_APICALLTIME = 20;
	
	public static final String GET_NOTICELIST_API_URL = "/board/noticeApi/retrieveNoticeApiList.do";
	
	public static final String NOTICEDETAIL_API_URL = "/board/noticeApi/noticeApiDetail.do";
	
	public static final String GET_NOTICESEQ_API_URL = "/board/noticeApi/retrievePopNoticeSeq.do";
	
	public static final String GET_NOTICEDATA_API_URL = "/board/noticeApi/retrieveNoticeApiDetail.do";
	
	public static final String NO_SECRETKEY_MSG = "helpdesk secretKey is null";

	public static final String NO_EXIST_NOTICEINFO_MSG = 	"helpdesk noticeInfo not exist";
	
	public static final String RETRIEVE_POPNOTICESEQ_APIFAIL_MSG = "helpdesk retrievePopNoticeSeq api fail";
	
	public static final String BOARDSEQ_ISNULL_MSG = "helpdesk boardSeq of noticeInfo is null";
	
	public static final String BOARDSEQ_OR_SECRETKEY_ISNULL_MSG = "helpdesk secretKey or boardSeq is null";
	
	public static final String NO_EXIST_NOTICELIST_MSG = "helpdesk noticeList not exist";
	
	public static final String RETRIEVE_NOTICEAPILIST_APIFAIL_MSG = "helpdesk retrieveNoticeApiList api fail";
	
	public static final String CLOSE_NETWORK = "close network";
	
	public static final String NOTICEDETAIL_APIFAIL_MSG = "helpdesk noticeApiDetail api fail";


}
