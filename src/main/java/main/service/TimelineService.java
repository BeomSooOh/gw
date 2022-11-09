package main.service;

import java.util.List;
import java.util.Map;


public interface TimelineService {
	
	/**
	 * 타임라인 포틀릿(iframe) 정보 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectTimelinePortlet(Map<String, Object> params);
	
	/**
	 * 타임라인 리스트 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectTimelineList(Map<String, Object> params);

	/**
	 * 타임라인 상세 조회
	 * @param params
	 * @return
	 */
	public String checkTimelineNew(Map<String, Object> params);

	
	public String checkTimelineNewEventType(Map<String, Object> params);
	
	/**
	 * 타임라인 상세 조회
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectTimelineInfo(Map<String, Object> params);

	/**
	 * 이메일 주소
	 * @param params
	 * @return
	 */
	public String selectMailUrl(Map<String, Object> params);

}
