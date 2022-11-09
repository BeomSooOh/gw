package api.holiday.controller;

import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.model.APIResponse;
import api.holiday.service.HolidayService;

@Controller
public class HolidayController {	
	@Resource(name="HolidayService")
	private HolidayService holidayService;
	
	/** 2016.09.22 주성덕 작성
	 * AddrGroupList : 공휴일 목록 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/holiday/getHolidayList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getHolidayList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = holidayService.getHolidayList(paramMap);
		
		return response;
	}
	
	/** 2017.03.03 장지훈 작성
	 * getAnniversaryList : 기념일 목록 가져오기
	 * @param paramMap
	 * @return
	 */	
	@RequestMapping(value="/holiday/getAnniversaryList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getAnniversaryList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = holidayService.getAnniversaryList(paramMap);
		
		return response;
	}
}