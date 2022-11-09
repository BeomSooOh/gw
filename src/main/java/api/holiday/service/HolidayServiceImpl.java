package api.holiday.service;

import java.util.List;
import java.util.Map;

import api.common.model.APIResponse;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import main.web.BizboxAMessage;
import neos.cmm.systemx.holiday.service.HolidayManageService;


@Service("HolidayService")
public class HolidayServiceImpl implements HolidayService{
	Logger logger = LoggerFactory.getLogger(HolidayServiceImpl.class);

	@Resource(name = "HolidayManageService")
	private HolidayManageService holidayManageService;
	
	@Override
	public APIResponse getHolidayList(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		try {
			//공휴일 목록 조회.
			List<Map<String, Object>> list = holidayManageService.getHolidayList(paramMap);

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(list);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
		
		return response;
	}
	
	@Override
	public APIResponse getAnniversaryList(@RequestBody Map<String, Object> paramMap) {
		APIResponse response = new APIResponse();
			String sDate = paramMap.get("startDate").toString().substring(4);
			String eDate = paramMap.get("endDate").toString().substring(4);
		
		try{
			paramMap.put("sDate", sDate);
			paramMap.put("eDate", eDate);
			
			//기념일 목록 조회.
			List<Map<String, Object>> list = holidayManageService.getAnniversaryList(paramMap);
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(list);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
		
		return response;
	}
}