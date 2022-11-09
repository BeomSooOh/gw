package api.common.service;

import java.io.IOException;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.common.model.EventRequest;
import bizbox.orgchart.helper.ConnectionHelper;
import bizbox.orgchart.helper.ConnectionHelperFactory;
import neos.cmm.util.BizboxAProperties;

@Service("EventService")
public class EventService {
	private Logger logger = LoggerFactory.getLogger(EventService.class);
	
	private String urlEventSend = BizboxAProperties.getProperty("BizboxA.event.url");
	
	public static final String URL_CONTEXT_EVENT_SEND = "/event/EventSend";
	public static final String URL_CONTEXT_EVENT_ORGSYNC_SEND = "/event/OrgSync";
	

	/**
	 * event 모듈에 푸시 전송 요청
	 * @param pushData
	 * @throws IOException 
	 */
	public void eventOrgSync(Map<String,Object> eventRequest) throws IOException{
		if(StringUtils.isEmpty(urlEventSend)) { return; }

		logger.info("AlarmService.eventOrgSync-start[" + eventRequest + "]");
		
		ConnectionHelper connect = ConnectionHelperFactory.createInstacne(urlEventSend+URL_CONTEXT_EVENT_ORGSYNC_SEND);

		ObjectMapper mapper = new ObjectMapper();
		String json = mapper.writeValueAsString(eventRequest);

		//connect.requestDataNoResponse(json);
		String reuslt = connect.requestData(json);
		
		org.apache.log4j.Logger.getLogger( EventService.class ).debug("AlarmService.eventOrgSync-reuslt=[" + reuslt + "]");
		org.apache.log4j.Logger.getLogger( EventService.class ).debug("AlarmService.eventOrgSync-end=[" + eventRequest + "]");
		org.apache.log4j.Logger.getLogger( EventService.class ).debug("AlarmService.eventOrgSync-jsonParam=[" + json + "]");
		
	}
	
	/**
	 * 이벤트(알림, 타임라인) 발송
	 * @param eventRequest
	 * @throws IOException
	 */
	public void eventSend(EventRequest eventRequest) throws IOException{
		if(StringUtils.isEmpty(urlEventSend)) { return; }

		org.apache.log4j.Logger.getLogger( EventService.class ).debug( "EventService.eventSend eventRequest : " + eventRequest );
		org.apache.log4j.Logger.getLogger( EventService.class ).debug( "EventService.eventSend urlEventSend : " + urlEventSend );
		org.apache.log4j.Logger.getLogger( EventService.class ).debug( "EventService.eventSend URL_CONTEXT_EVENT_SEND : " + URL_CONTEXT_EVENT_SEND );
		
		ConnectionHelper connect = ConnectionHelperFactory.createInstacne(urlEventSend+URL_CONTEXT_EVENT_SEND);

		ObjectMapper mapper = new ObjectMapper();
		String json = mapper.writeValueAsString(eventRequest);

		org.apache.log4j.Logger.getLogger( EventService.class ).debug( "EventService.eventSend json : " + json );
		
		String reuslt = connect.requestData(json);
		
		org.apache.log4j.Logger.getLogger( EventService.class ).debug( "EventService.eventSend reuslt : " + reuslt );
	}
	
}
