package main.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;


@Repository("TimelineManageDAO")
public class TimelineManageDAO extends EgovComAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectTimelinePortlet(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("TimelineManageDAO.selectTimelinePortlet", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectTimelineList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("TimelineManageDAO.selectTimelineList", params);
	}

	public String checkTimelineNew(Map<String, Object> params) {
		return (String) select("TimelineManageDAO.checkTimelineNew", params);
	}
	
	public String checkTimelineNewEventType(Map<String, Object> params) {
		return (String) select("TimelineManageDAO.checkTimelineNewEventType", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectTimelineInfo(Map<String, Object> params) {
		return (Map<String, Object>) select("TimelineManageDAO.selectTimelineInfo", params);
	}

	public String selectMailUrl(Map<String, Object> params) {
		return (String) select("TimelineManageDAO.selectMailUrl", params);
	}

}
