package api.main.service;

import java.util.Map;

public interface ApiMainService {

	/**
	 * 알림 안읽음수 조회
	 * @param request
	 * @return
	 */
	public int AlertCnt(Map request);
	
	/**
	 * 알림 리스트 조회
	 * @param request
	 * @return
	 */
	public Map<String,Object> AlertList(Map request);
	
	/**
	 * 알림 읽음 처리
	 * @param request
	 * @return
	 */
	public int AlertRead(Map request);
	
	/**
	 * 타임라인 안읽음수 조회
	 * @param request
	 * @return
	 */
	public int TimelineCnt(Map request);
	
	/**
	 * 타임라인 리스트 조회
	 * @param request
	 * @return
	 */
	public Map<String,Object> TimelineList(Map request);
	
	/**
	 * 타임라인 읽음 처리
	 * @param request
	 * @return
	 */
	public int TimelineRead(Map request);

	/**
	 * 
	 * @param serviceName
	 * @param body
	 * @return
	 */
	public Object action(String serviceName, Map<String, Object> body);

}
