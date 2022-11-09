package api.emp.controller;

import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.model.APIResponse;
import api.emp.service.EmpService;

@Controller
public class EmpController {

	
	@Resource(name="EmpService")
	private EmpService empService;
	
	/** 2016.07.06 주성덕 작성
	 * AddrList : 사용자 추가(메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/mail2/createUser.do", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse createUser(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = empService.createUser(paramMap);
		
		return response;
	}
	
	
	/** 2016.07.06 주성덕 작성
	 * AddrList : 사용자 퇴직처리(메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/mail2/resignUser.do", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse resignUser(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = empService.resignUser(paramMap);
		
		return response;
	}
	
	
	
	/** 2016.07.06 주성덕 작성
	 * AddrList : 사용자 삭제(메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/mail2/deleteUser.do", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse deleteUser(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = empService.deleteUser(paramMap);
		
		return response;
	}
	
	
	
	/** 2016.07.06 주성덕 작성
	 * AddrList : 사용자 아이디 변경(메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/mail2/changeUserId.do", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse changeUserId(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = empService.changeUserId(paramMap);
		
		return response;
	}
	

}
