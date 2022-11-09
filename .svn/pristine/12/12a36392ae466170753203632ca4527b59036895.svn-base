package api.secGrade.controller;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.model.APIResponse;
import main.web.BizboxAMessage;
import neos.cmm.systemx.secGrade.service.SecGradeService;
import neos.cmm.util.MessageUtil;
import net.sf.json.JSONObject;
import restful.mullen.constants.ConstantBiz;

@Controller
@RequestMapping("/secGrade")
public class SecGradeController {
	private Logger logger = Logger.getLogger(SecGradeController.class);
	
	@Resource(name = "SecGradeService")
	private SecGradeService secGradeService;
	
	/*
	 * post 호출 및 json 응답
	 * 사용자 보안등급 매칭정보
	 * Parameters : {secId(보안등급코드)[필수], groupSeq(그룹코드)[필수], compSeq(회사코드)[필수], deptSeq(부서코드)[필수], empSeq(사원코드)[필수]}
	 * Response :   {isMatched(true or false)[필수], originSecId(입력받은 보안등급코드)[필수], matchedSecId(매치된 보안등급코드)[[선택적]]}
	 */
	@RequestMapping(value="/matchedInfo", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse matchedInfo(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> reqParams
							) throws Exception {
		APIResponse response = new APIResponse();
	
		logger.debug("/secGrade/matchedInfo Request params: " + JSONObject.fromObject(reqParams).toString());
		
		try{
			//사용자 보안등급 매칭정보 호출
			HashMap<String, Object> resultObj = secGradeService.getMatchedInfo(reqParams);
			
			String resultCode = (String) resultObj.get("resultCode");
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				HashMap<String, Object> resultMap = new HashMap<>();
				resultMap.put("secGradeUserMatchedInfo", resultObj.get("result"));
				response.setResult(resultMap);
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "secGrade.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/secGrade/matchedInfo Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	/*
	 * post 호출 및 json 응답
	 * 보안등급코드 정보
	 * Parameters : {secId(보안등급코드)[필수], groupSeq(그룹코드)[필수], langCode(다국어코드)[선택]}
	 * Response :   {}
	 */
	@RequestMapping(value="/info", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse info(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> reqParams
							) throws Exception {
		APIResponse response = new APIResponse();
	
		logger.debug("/secGrade/info Request params: " + JSONObject.fromObject(reqParams).toString());
		
		try{
			//사용자 보안등급 매칭정보 호출
			HashMap<String, Object> resultObj = secGradeService.getSecGradeInfo(reqParams);
			
			String resultCode = (String) resultObj.get("resultCode");
			
			if(ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCode)) {
				response.setResultCode(ConstantBiz.API_RESPONSE_SUCCESS);
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				HashMap<String, Object> resultMap = new HashMap<>();
				resultMap.put("secGradeList", resultObj.get("result"));
				response.setResult(resultMap);
			}else {
				response.setResultCode(resultCode);
				MessageUtil.setApiMessage(response, servletRequest, "secGrade.api.error.", resultCode);
			}
		}catch(Exception e){
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/secGrade/info Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
}

