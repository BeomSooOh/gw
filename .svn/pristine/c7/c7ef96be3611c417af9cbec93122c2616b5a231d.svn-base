package api.alarm.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import api.alarm.service.AlarmService;
import api.common.model.APIResponse;



@Controller
public class AlarmController {

	@Resource(name="AlarmService")
	private AlarmService alarmService;
	
	/** 2016.03.08 장지훈 작성
	 * getAlarmModuleList : 모듈 별 알림 설정 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/alarm/AlarmModuleList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getAlarmModuleList(@RequestBody Map<String, Object> paramMap) {
		//ModelAndView mv = new ModelAndView();
		APIResponse response = null;

//		System.out.println("paramMap : " + paramMap);
		
		// 리턴 결과 
		response = alarmService.alarmModuleList(paramMap);
		
//		System.out.println("controller : " + response);
		
		//mv.addObject(response);
		//mv.setViewName("jsonView");
		
		return response;
	}
	
	/** 2016.03.08 장지훈 작성
	 * setAlarmModule : 모듈 별 알림 설정하기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/alarm/AlarmModuleSave", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse setAlarmModule(@RequestBody Map<String, Object> paramMap) {
		//ModelAndView mv = new ModelAndView();
		APIResponse response = null;
		
		// 리턴결과
		response = alarmService.saveAlarmModule(paramMap);
		
		//mv.addObject(response);
		//mv.setViewName("jsonView");
		
		return response;
		
	}	
}
