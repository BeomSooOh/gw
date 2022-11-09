package main.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.service.TimelineService;
import neos.cmm.menu.service.dao.MenuManageDAO;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import cloud.CloudConnetInfo;

@Controller
public class BizboxTimelineController {
	
	private static final Logger logger = LoggerFactory.getLogger(BizboxTimelineController.class);
	
	@Resource(name="TimelineService")
	TimelineService timelineService;
	
	/** EgovLoginService */
	@Resource(name = "loginService")
    private EgovLoginService loginService;
	
	@Resource(name="EmpManageService")
	EmpManageService empManageService;
	
	@Resource(name = "MenuManageDAO")
	private MenuManageDAO menuManageDAO;
	
	
	@RequestMapping("/timeline.do")
	public ModelAndView Timeline(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {		
				
		List<Map<String, String>> mentionOption = CommonCodeUtil.getCodeList("mentionUseYn");
		
		if(mentionOption != null && mentionOption.size() > 0){
			
			ModelAndView mv = new ModelAndView();
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			//eaType 셋팅
			String eaType = loginVO.getEaType() + "";
			if(eaType == null || eaType.equals("")) {
				eaType = "eap";
			}
			
			mv.addObject("loginVO", loginVO);
			
			// 알림 조회 API호출(전체)
			String jsonParam =	"{\"header\":{";
			jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
			jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\"},";
			jsonParam +=	    "\"body\":{";
			jsonParam +=	    "\"timeStamp\":\"" + System.currentTimeMillis() + "\",";
			jsonParam +=	    "\"reqType\":\"" + "2" + "\",";
			jsonParam +=	    "\"reqSubType\":\"" + "N" + "\",";
			jsonParam +=	    "\"pageSize\":\"" + "30" + "\",";
			jsonParam +=	    "\"newYn\":\"" + "N" + "\",";
			jsonParam +=	    "\"mentionYn\":\"" + "N" + "\",";
			jsonParam +=	    "\"langCode\":\"" + loginVO.getLangCode() + "\"}}";
			
	
			String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertList";
	//		String apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertList";
			 
			JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
			HttpJsonUtil httpJson = new HttpJsonUtil();
			String alertList = httpJson.execute("POST", apiUrl, jsonObject2);
			alertList = alertList.replaceAll("\'", "&#39;");
			alertList = alertList.replaceAll("<", "&lt;");
			alertList = alertList.replaceAll(">'", "&gt;");
			
			
			// 알림 조회 API호출(멘션만)
			jsonParam =	        "{\"header\":{";
			jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
			jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\"},";
			jsonParam +=	    "\"body\":{";
			jsonParam +=	    "\"timeStamp\":\"" + System.currentTimeMillis() + "\",";
			jsonParam +=	    "\"reqType\":\"" + "2" + "\",";
			jsonParam +=	    "\"reqSubType\":\"" + "N" + "\",";
			jsonParam +=	    "\"pageSize\":\"" + "30" + "\",";
			jsonParam +=	    "\"newYn\":\"" + "N" + "\",";
			jsonParam +=	    "\"mentionYn\":\"" + "Y" + "\",";
			jsonParam +=	    "\"langCode\":\"" + loginVO.getLangCode() + "\"}}";
			
			
			apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertList";
	//		apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertList";
			 
			jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
			httpJson = new HttpJsonUtil();
			String mentionList = httpJson.execute("POST", apiUrl, jsonObject2);
			mentionList = mentionList.replaceAll("\'", "&#39;");
			mentionList = mentionList.replaceAll("<", "&lt;");
			mentionList = mentionList.replaceAll(">'", "&gt;");
			
			ObjectMapper om = new ObjectMapper();
			Map<String, Object> m = om.readValue(alertList, new TypeReference<Map<String, Object>>(){});
			mv.addObject("alertList", m);
			
			m = om.readValue(mentionList, new TypeReference<Map<String, Object>>(){});
			mv.addObject("mentionList", m);
			
			
			
			//카운트 조회
			JSONObject jsonObj = new JSONObject();
			JSONObject header = new JSONObject();
			JSONObject body = new JSONObject();
			
			header.put("groupSeq", loginVO.getGroupSeq());
			header.put("empSeq", loginVO.getUniqId());
			
			body.put("mentionYn", "N");
			
			jsonObj.put("header", header);
			jsonObj.put("body", body);
					
			apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertUnreadCount";
	//		apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertUnreadCount";
			
			Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
			Map<String, Object> cntResult = (Map<String, Object>) result.get("result");
			
			mv.addObject("alertCnt", cntResult.get("alertCnt").toString());
			
			//멘션알림 카운트만 재조회
			body.put("mentionYn", "Y");
			jsonObj.put("body", body);
			
			result = callApiToMap(jsonObj, apiUrl);
			cntResult = (Map<String, Object>) result.get("result");
			
			mv.addObject("alertMentionCnt", cntResult.get("alertCnt").toString());
			
			mv.addObject("topType", "timeline");
			mv.addObject("userSe", loginVO.getUserSe());
			
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
			}else{
				mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
			}
			
			mv.setViewName("/main/timeline/timeline");
			
			
			return mv;
		}
		else{
			long time = System.currentTimeMillis();
			
			ModelAndView mv = new ModelAndView();
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			
			/** 로그인 정보 (LoginVO)	**/
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("start", 0);
			paramMap.put("end", 10);
			
					
			/**	타임라인 리스트	**/
			try{
				
				logger.info( "-start selectTimelineList(Controller)");
				
				List<Map<String,Object>> timelineList = timelineService.selectTimelineList(paramMap);
				
				ObjectMapper mapper = new ObjectMapper();
				
				try {
					
					if(timelineList != null){

						for( int i = 0; i < timelineList.size(); i++){
							Map<String,Object> tItem = (Map<String,Object>) timelineList.get(i);
							
							Map<String, Object> dMap = new HashMap<String, Object>();
		
							// convert JSON string to Map
							dMap = mapper.readValue((String) tItem.get("data"), new TypeReference<Map<String, Object>>(){});
							
							List<Map<String,Object>> fList = (List<Map<String,Object>>) dMap.get("fileList");
							
							Integer fileCnt = 0;
							if(fList != null){
								fileCnt = fList.size();
							}
							tItem.put("fileCnt", fileCnt);
							tItem.put("data", dMap);
		
							timelineList.set(i, tItem);
						}
						
						mv.addObject("retCnt", timelineList.size());
						
					}
					else{
						mv.addObject("retCnt", 0);
					}
					
					String authCode = loginVO.getAuthorCode();
					if (!EgovStringUtil.isEmpty(authCode)) {
						String[] authArr = authCode.split("#");
						
						Map<String,Object> params = new HashMap<String,Object>();
						
						params.put("id", loginVO.getId()); 
						params.put("authCodeList", authArr);
						params.put("level", 1);
						params.put("compSeq", loginVO.getCompSeq());
						params.put("langCode", loginVO.getLangCode());
						params.put("startWith", 0);
						params.put("userSe", loginVO.getUserSe());
						params.put("timelint", "Y");
						
						list = menuManageDAO.selectMenuTreeList(params);
					}
					

				} catch (JsonGenerationException e) {
					
					time = System.currentTimeMillis() - time;
					logger.error("-error -JsonGenerationException timeline(Controller) [" + time + "] " + e);
					
				} catch (JsonMappingException e) {

					time = System.currentTimeMillis() - time;
					logger.error("-error -JsonMappingException timeline(Controller) [" + time + "] " + e);
					
				} catch (IOException e) {
					
					time = System.currentTimeMillis() - time;
					logger.error("-error -IOException timeline(Controller) [" + time + "] " + e);
					
				}
				
				mv.addObject("topMenuList", JSONArray.fromObject(list));
				mv.addObject("timelineList", timelineList);
				mv.addObject("topType", "timeline");
				mv.addObject("eaType", loginVO.getEaType());
				
				JSONArray jsonTimelineList = JSONArray.fromObject(timelineList);
				mv.addObject("jsonTimelineList", jsonTimelineList);
				
				
				/** 메인 iframe 정보 조회 */
			    List<Map<String,Object>> iframeList = timelineService.selectTimelinePortlet(paramMap);
			    
			    mv.addObject("iframeListJson", JSONArray.fromObject(iframeList));
			    
			    
			    /** 메일 URL 정보 조회 */
			    String mailUrl = timelineService.selectMailUrl(paramMap);
			    
			    mv.addObject("mailUrl", mailUrl);
				
				
			} catch(Exception ex) {
				
				time = System.currentTimeMillis() - time;
				logger.error("-error timeline(Controller) [" + time + "] " + ex);
				
			}
			
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
			}else{
				mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
			}
			
			mv.setViewName("/main/timeline/timeline_bak");
			
			return mv;
		}

	}
	
	@RequestMapping("/getTimelineList.do")
	public ModelAndView getTimelineList(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		long time = System.currentTimeMillis();
		
		ModelAndView mv = new ModelAndView();
		
		
		/** 로그인 정보 (LoginVO)	**/
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("lSeq", paramMap.get("lSeq"));
		paramMap.put("start", 0);
		paramMap.put("end", 10);
		
				
		/**	타임라인 리스트	**/
		try{
			
			logger.info( "-start selectTimelineList(Controller)");
			
			List<Map<String,Object>> timelineList = timelineService.selectTimelineList(paramMap);
			
			ObjectMapper mapper = new ObjectMapper();
			
			try {
				
				if(timelineList != null){

					for( int i = 0; i < timelineList.size(); i++){
						Map<String,Object> tItem = (Map<String,Object>) timelineList.get(i);
						
						Map<String, Object> map1 = new HashMap<String, Object>();
						Map<String, Object> map2 = new HashMap<String, Object>();
	
						// convert JSON string to Map
						map1 = mapper.readValue((String) tItem.get("data"), new TypeReference<Map<String, Object>>(){});
						map2 = mapper.readValue((String) tItem.get("dataV"), new TypeReference<Map<String, Object>>(){});
						
						List<Map<String,Object>> fList = (List<Map<String,Object>>) map1.get("fileList");
	
						tItem.put("data", map1);
						tItem.put("dataV", map2);
						tItem.put("fileCnt", fList.size());
	
						timelineList.set(i, tItem);
					}
					
				}

			} catch (JsonGenerationException e) {
				
				time = System.currentTimeMillis() - time;
				logger.error("-error -JsonGenerationException timeline(Controller) [" + time + "] " + e);
				
			} catch (JsonMappingException e) {

				time = System.currentTimeMillis() - time;
				logger.error("-error -JsonMappingException timeline(Controller) [" + time + "] " + e);
				
			} catch (IOException e) {
				
				time = System.currentTimeMillis() - time;
				logger.error("-error -IOException timeline(Controller) [" + time + "] " + e);
				
			}
			
			JSONArray jsonTimelineList = JSONArray.fromObject(timelineList);

			mv.addObject("timelineList", timelineList);
			mv.addObject("jsonTimelineList", jsonTimelineList);
			
		} catch(Exception ex) {
			
			time = System.currentTimeMillis() - time;
			logger.error("-error timeline(Controller) [" + time + "] " + ex);
			
		}

		mv.setViewName("jsonView");
		
		
		return mv;

	}
	
	@RequestMapping("/checkTimelineNew.do")
	public ModelAndView checkTimelineNew(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		long time = System.currentTimeMillis();
		
		ModelAndView mv = new ModelAndView();
		
		
		/** 로그인 정보 (LoginVO)	**/
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		
				
		/**	타임라인 리스트	**/
		try{
			
			logger.info( "-start checkTimelineNew(Controller)");
			
			String timelineSeq = timelineService.checkTimelineNew(paramMap);
			
			
			Integer ret = -1;
			
			if(Integer.parseInt((String) paramMap.get("lSeq")) < Integer.parseInt(timelineSeq)){
				String newEventType = timelineService.checkTimelineNewEventType(paramMap);
				ret = 1;
				mv.addObject("lSeq", timelineSeq);
				mv.addObject("newEventType", newEventType);
			}
			
			mv.addObject("ret", ret);
			
		} catch(Exception ex) {
			
			time = System.currentTimeMillis() - time;
			logger.error("-error timeline(Controller) [" + time + "] " + ex);
			
			mv.addObject("ret", -1);
		}

		mv.setViewName("jsonView");
		
		
		return mv;

	}
	
	@RequestMapping("/popProFile.do")
	public ModelAndView popProFile(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		long time = System.currentTimeMillis();
		
		ModelAndView mv = new ModelAndView();
		
		
		/** 로그인 정보 (LoginVO)	**/
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
				
		/**	타임라인 리스트	**/
		try{
			
			logger.info( "-start checkTimelineNew(Controller)");
			
			Map<String,Object> userInfo = empManageService.selectEmpInfo(paramMap);
			
			mv.addObject("userInfo", userInfo);
			
		} catch(Exception ex) {
			
			time = System.currentTimeMillis() - time;
			logger.error("-error timeline(Controller) [" + time + "] " + ex);
			
		}
		

		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}
		 
		mv.setViewName("/main/pop/popProfile");
		
		
		return mv;
	}
	
	// getTimelinePaingList.do
	@RequestMapping("/getTimelinePaingList.do")
	public ModelAndView GetTimelinePaingList(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		long time = System.currentTimeMillis();
		
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		/** 로그인 정보 (LoginVO)	**/
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("start", Integer.parseInt(paramMap.get("start").toString()));
		paramMap.put("end", Integer.parseInt(paramMap.get("end").toString()));
		
				
		/**	타임라인 리스트	**/
		try{
			
			logger.info( "-start selectTimelineList(Controller)");
			
			List<Map<String,Object>> timelineList = timelineService.selectTimelineList(paramMap);
			
			ObjectMapper mapper = new ObjectMapper();
			
			try {
				
				if(timelineList != null){

					for( int i = 0; i < timelineList.size(); i++){
						Map<String,Object> tItem = (Map<String,Object>) timelineList.get(i);
						
						Map<String, Object> dMap = new HashMap<String, Object>();
	
						// convert JSON string to Map
						dMap = mapper.readValue((String) tItem.get("data"), new TypeReference<Map<String, Object>>(){});
						
						List<Map<String,Object>> fList = (List<Map<String,Object>>) dMap.get("fileList");
						
						Integer fileCnt = 0;
						if(fList != null){
							fileCnt = fList.size();
						}
						tItem.put("fileCnt", fileCnt);
						tItem.put("data", dMap);
	
						timelineList.set(i, tItem);
					}
					
					mv.addObject("retCnt", timelineList.size());
					
				}
				else{
					mv.addObject("retCnt", 0);
				}
				
				String authCode = loginVO.getAuthorCode();
				if (!EgovStringUtil.isEmpty(authCode)) {
					String[] authArr = authCode.split("#");
					
					Map<String,Object> params = new HashMap<String,Object>();
					
					params.put("id", loginVO.getId()); 
					params.put("authCodeList", authArr);
					params.put("level", 1);
					params.put("compSeq", loginVO.getCompSeq());
					params.put("langCode", loginVO.getLangCode());
					params.put("startWith", 0);
					params.put("userSe", loginVO.getUserSe());
					params.put("timelint", "Y");
					
					list = menuManageDAO.selectMenuTreeList(params);
				}
				

			} catch (JsonGenerationException e) {
				
				time = System.currentTimeMillis() - time;
				logger.error("-error -JsonGenerationException timeline(Controller) [" + time + "] " + e);
				
			} catch (JsonMappingException e) {

				time = System.currentTimeMillis() - time;
				logger.error("-error -JsonMappingException timeline(Controller) [" + time + "] " + e);
				
			} catch (IOException e) {
				
				time = System.currentTimeMillis() - time;
				logger.error("-error -IOException timeline(Controller) [" + time + "] " + e);
				
			}
			
			mv.addObject("topMenuList1", JSONArray.fromObject(list));
			mv.addObject("timelineList1", timelineList);
			mv.addObject("topType1", "timeline");
			mv.addObject("eaType1", loginVO.getEaType());
			
			JSONArray jsonTimelineList = JSONArray.fromObject(timelineList);
			mv.addObject("jsonTimelineList1", jsonTimelineList);
			
			
			/** 메인 iframe 정보 조회 */
		    List<Map<String,Object>> iframeList = timelineService.selectTimelinePortlet(paramMap);
		    
		    mv.addObject("iframeListJson1", JSONArray.fromObject(iframeList));
		    
		    
		    /** 메일 URL 정보 조회 */
		    String mailUrl = timelineService.selectMailUrl(paramMap);
		    
		    mv.addObject("mailUrl1", mailUrl);
			
			
		} catch(Exception ex) {
			
			time = System.currentTimeMillis() - time;
			logger.error("-error timeline(Controller) [" + time + "] " + ex);
			
		}
		
		mv.setViewName("jsonView");
		
		
		return mv;

	}
	
	
	public Map<String, Object> callApiToMap(JSONObject jsonObject, String url) throws JsonParseException, JsonMappingException, IOException{
		 HttpJsonUtil httpJson = new HttpJsonUtil();
		 String alertList = httpJson.execute("POST", url, jsonObject);
		 
		 ObjectMapper om = new ObjectMapper();
		 Map<String, Object> m = om.readValue(alertList, new TypeReference<Map<String, Object>>(){});
		 
		 return m;
	 }
}
