package main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.db.CommonSqlDAO;

import org.springframework.stereotype.Service;

import main.service.TimelineService;


@Service("TimelineService")
public class TimelineServiceImpl implements TimelineService{
	
	@Resource(name = "TimelineManageDAO")
	private TimelineManageDAO timelineManageDAO;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;


	@Override
	public List<Map<String, Object>> selectTimelinePortlet(Map<String, Object> params) {
		return timelineManageDAO.selectTimelinePortlet(params);
	}
	
	@Override
	public List<Map<String, Object>> selectTimelineList(Map<String, Object> params) {
		return timelineManageDAO.selectTimelineList(params); 
	}
	
	@Override
	public String checkTimelineNew(Map<String, Object> params) {
		return timelineManageDAO.checkTimelineNew(params); 
	}
	
	@Override
	public String checkTimelineNewEventType(Map<String, Object> params) {
		return timelineManageDAO.checkTimelineNewEventType(params); 
	}

	@Override
	public Map<String, Object> selectTimelineInfo(Map<String, Object> params) {
		return timelineManageDAO.selectTimelineInfo(params);
	}
	
	@Override
	public String selectMailUrl(Map<String, Object> params) {
		return timelineManageDAO.selectMailUrl(params); 
	}
	
}
