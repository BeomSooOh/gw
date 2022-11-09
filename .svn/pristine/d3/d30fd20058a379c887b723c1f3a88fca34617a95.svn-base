package api.mail.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.model.APIResponse;
import api.mail.service.ApiMailService;



@Controller
public class ApiMailController {
	
	@Resource(name="ApiMailService")
	 private ApiMailService apiMailService;
	
	
	@RequestMapping(value="/mail/UpdateDomain", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse UpdateDomain(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.UpdateDomain(paramMap);
		
		return response;
	}
	
	@RequestMapping(value="/mail/passwordChange", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse passwordChange(@RequestBody Map<String, Object> paramMap, HttpServletRequest request) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.passwordChange(paramMap, request);
		
		return response;
	}
	
	@RequestMapping(value="/mail/passwordChangeCheck", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse passwordChangeCheck(@RequestBody Map<String, Object> paramMap, HttpServletRequest request) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.passwordChangeCheck(paramMap, request);
		
		return response;
	}
	
	
	@RequestMapping(value="/mail/getManualUrl", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getManualUrl(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.getManualUrl();
		
		return response;
	}
	
	
	
	@RequestMapping(value="/mail/getGwVolume", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getGwVolume(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.getGwVolume(paramMap);
		
		return response;
	}
	
	
	@RequestMapping(value="/mail/setGwVolumeFromMail", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse setGwVolumeFromMail(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.setGwVolumeFromMail(paramMap);
		
		return response;
	}
	
	@RequestMapping(value="/mail/getDownloadType", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getDownloadType(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.getDownloadType(paramMap);
		
		return response;
	}	
	
	@RequestMapping(value="/mail/getGwGroupInfo", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getGwGroupInfo(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.getGwGroupInfo(paramMap);
		
		return response;
	}
	
	@RequestMapping(value="/mail/getGwDomain", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getGwDomain(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = apiMailService.getGwDomain(paramMap);
		
		return response;
	}
}
